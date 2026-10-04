SC_color(_RimLightColor, (0,0,0,1), [], "__Color", "")
SC_float(_RimLightMultiplyAlbedo, 0, [SCRange(0,1)], "__MultiplyAlbedo", "")
SC_float4(_RimLightRange, (0.6,0.9,0,0), [SCMinMax(0,1)], "__Range", "")
SC_Foldout(SimpleFoldout)
SC_uint(_RimLightMaskChannel, 3, [SCInHeader][SCMaskChannel], "__MaskChannel", "")
SC_float4(_RimLightMaskRemap, (1,0,0,0), [SCRemap], "__Remap", "")
SC_FoldoutEnd
