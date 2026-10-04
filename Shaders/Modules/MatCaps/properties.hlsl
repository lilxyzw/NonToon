SC_uint(_Enable, 0, [SCInHeader][SCToggle][SCConstValue(1,pixel)], "", "")

SC_Box
SC_color(_MatCapMultiplyColor, (1,1,1,1), [SCCache], "", "")
SC_Texture2D(_MatCapMultiply, "white", [], "MatCap (Multiply)", "")
SC_float(_MatCapMultiplyDetail, 1, [SCRange(0,1)], "Detail Normal", "")
SC_Foldout(SimpleFoldout)
SC_uint(_MatCapMultiplyMaskChannel, 3, [SCInHeader][SCMaskChannel], "__MaskChannel", "")
SC_float4(_MatCapMultiplyMaskRemap, (1,0,0,0), [SCRemap], "__Remap", "")
SC_FoldoutEnd
SC_BoxEnd

SC_Box
SC_color(_MatCapAddColor, (1,1,1,1), [SCCache], "", "")
SC_Texture2D(_MatCapAdd, "black", [], "MatCap (Add)", "")
SC_float(_MatCapAddDetail, 1, [SCRange(0,1)], "Detail Normal", "")
SC_Foldout(SimpleFoldout)
SC_uint(_MatCapAddMaskChannel, 3, [SCInHeader][SCMaskChannel], "__MaskChannel", "")
SC_float4(_MatCapAddMaskRemap, (1,0,0,0), [SCRemap], "__Remap", "")
SC_FoldoutEnd
SC_BoxEnd
