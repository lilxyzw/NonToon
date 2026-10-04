SC_float(_LightBoost, 1, [SCRange(0,10)], "Light Boost", "")
SC_Foldout(SimpleFoldout)
SC_uint(_LightBoostMaskChannel, 3, [SCInHeader][SCMaskChannel], "__MaskChannel", "")
SC_float4(_LightBoostMaskRemap, (1,0,0,0), [SCRemap], "__Remap", "")
SC_FoldoutEnd
SC_uint(_LightBoostAsEmission, 0, [SCToggle], "As Emission", "")
