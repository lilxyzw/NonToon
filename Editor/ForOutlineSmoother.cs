#if LIL_OUTLINESMOOTHER
using jp.lilxyzw.outlinesmoother;
using UnityEditor;
using UnityEngine;

namespace jp.lilxyzw.nontoon
{
    public class ForOutlineSmoother
    {
        private static int ID_OutlineFromVertexColor = -1;
        [InitializeOnLoadMethod]
        private static void InitializeInternal()
        {
            OutlineSmootherProcessor.outputCallbacks.Add(VectorAndZOffset);
            OutlineSmootherProcessor.materialModifyCallbacks.Add(ModifyOutlineVertexR2Width);
        }

        private static bool VectorAndZOffset(Shader shader, float x, float y, float z, float width, float zoffset, ref Color color)
        {
            if (!shader || shader.name != "NonToon") return false;
            color = new(Mathf.Lerp(0.5f, x, width), Mathf.Lerp(0.5f, y, width), Mathf.Lerp(0.5f, z, width), zoffset);
            return true;
        }

        private static bool ModifyOutlineVertexR2Width(ref Material material)
        {
            if (material.shader.name != "NonToon") return false;
            if (ID_OutlineFromVertexColor == -1) ID_OutlineFromVertexColor = Shader.PropertyToID("_OutlineFromVertexColor");
            material.SetInteger(ID_OutlineFromVertexColor, 1);
            return true;
        }
    }
}
#endif
