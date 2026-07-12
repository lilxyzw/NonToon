using System.Collections.Generic;
using System.Linq;
using jp.lilxyzw.shadercore;
using UnityEditor;
using UnityEngine.Rendering;
using UnityEngine.UIElements;

#if !UNITY_6000_1_OR_NEWER
using MaterialProperty = jp.lilxyzw.shadercore.MaterialProperty;
#endif

namespace jp.lilxyzw.nontoon
{
    internal class NTRenderingModeElement : PopupField<int>, IMaterialPropertyElement
    {
        public MaterialProperty Property { get; set; }
        public string ModuleID { get; set; }
        public string LocalizedLabel { get; set; }
        private readonly List<int> values = new(){0,1,2};
        private readonly List<string> names = new(){"Opaque", "Cutout", "Transparent"};
        private List<string> localizedNames;

        [InitializeOnLoadMethod]
        private static void Init()
        {
            AttributeActions.AddDrawer("NTRenderingMode", NTRenderingMode);
        }

        private static void NTRenderingMode(SCMaterialEditor editor, MaterialProperty prop, string args, VisualElement container)
        {
            container.Add(new NTRenderingModeElement(prop));
        }

        public NTRenderingModeElement(MaterialProperty property)
        {
            localizedNames = names.Select(n => SCL10n.L(n)).ToList();

            string GetLabel(int v)
            {
                var index = values.IndexOf(v);
                if (index >= 0) return localizedNames[index];
                return "";
            }
            choices = values;
            formatListItemCallback = GetLabel;
            formatSelectedValueCallback = GetLabel;

            ((IMaterialPropertyElement)this).InitializeVisualElement(this, UpdateUI, property);
            SCStyles.ApplyPopupStyle(this);
            style.flexGrow = 0;

            RegisterCallback<SCLocalizeEvent>(e =>
            {
                SCL10n.Load(ModuleID);
                localizedNames = names.Select(n => SCL10n.L(n)).ToList();
                textElement.text = formatSelectedValueCallback(rawValue);
            });
        }

        public override void SetValueWithoutNotify(int newValue)
        {
            if (Property != null && new System.Diagnostics.StackFrame(3, false).GetMethod().ToString() == "Void ChangeValueFromMenu(Int32)")
            {
                Property.intValue = newValue;
                if (newValue == 0)
                {
                    SetValue("_SrcBlend", (int)BlendMode.One);
                    SetValue("_DstBlend", (int)BlendMode.Zero);
                    SetValue("_AlphaToMask", 0);
                }
                else if (newValue == 1)
                {
                    SetValue("_SrcBlend", (int)BlendMode.One);
                    SetValue("_DstBlend", (int)BlendMode.Zero);
                    var _NTDitherTex = MaterialEditor.GetMaterialProperty(Property.targets, "_NTDitherTex");
                    if (!_NTDitherTex.hasMixedValue) SetValue("_AlphaToMask", _NTDitherTex.textureValue != null ? 0 : 1);
                }
                else if (newValue == 2)
                {
                    SetValue("_SrcBlend", (int)BlendMode.SrcAlpha);
                    SetValue("_DstBlend", (int)BlendMode.OneMinusSrcAlpha);
                    SetValue("_AlphaToMask", 0);
                }
                using var so = new SerializedObject(Property.targets);
                using var m_CustomRenderQueue = so.FindProperty("m_CustomRenderQueue");
                if (newValue == 0)
                {
                    m_CustomRenderQueue.intValue = -1;
                }
                else if (newValue == 1)
                {
                    m_CustomRenderQueue.intValue = 2450;
                }
                else if (newValue == 2)
                {
                    m_CustomRenderQueue.intValue = GraphicsSettings.currentRenderPipeline ? 3000 : 2460;
                }
                so.ApplyModifiedProperties();
                SCUpdateEvent.Invoke();
            }
            base.SetValueWithoutNotify(newValue);
        }

        public void UpdateUI()
        {
            if (!Property.hasMixedValue)
            {
                rawValue = Property.intValue;
                if (formatSelectedValueCallback != null) textElement.text = formatSelectedValueCallback(rawValue);
            }
        }

        private void SetValue(string name, int value)
        {
            MaterialEditor.GetMaterialProperty(Property.targets, name).floatValue = value;
        }
    }
}
