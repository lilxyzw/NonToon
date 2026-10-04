SC_color(_SpecularColor, (0,0,0,1), [], "__Color", "")
SC_float(_SpecularMultiplyAlbedo, 0, [SCRange(0,1)], "__MultiplyAlbedo", "")
SC_Foldout(SimpleFoldout)
SC_uint(_SpecularMaskChannel, 3, [SCInHeader][SCMaskChannel], "__MaskChannel", "")
SC_float4(_SpecularMaskRemap, (1,0,0,0), [SCRemap], "__Remap", "")
SC_FoldoutEnd
