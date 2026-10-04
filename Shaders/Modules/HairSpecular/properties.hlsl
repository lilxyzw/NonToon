SC_int(_HairSpecularGradientIndex, -1, [SCGradientSelect], "__GradientIndex", "")
SC_float(_HairSpecularMultiplyAlbedo, 0, [SCRange(0,1)], "__MultiplyAlbedo", "")
SC_Foldout(SimpleFoldout)
SC_uint(_HairSpecularMaskChannel, 3, [SCInHeader][SCMaskChannel], "__MaskChannel", "")
SC_float4(_HairSpecularMaskRemap, (1,0,0,0), [SCRemap], "__Remap", "")
SC_FoldoutEnd
