SC_uint(_Enable, 0, [SCInHeader][SCToggle][SCConstValue(1,pixel)], "", "")

SC_Texture2D(_DetailMask, "white", [SCMask], "RGBA Mask", "")

SC_Box
SC_float(_Detail0Boost, 1, [SCCache][SCRange(1,2)], "", "")
SC_Texture2D(_Detail0Texture, "white", [], "Detail R", "")
SC_ScaleOffset(_Detail0Texture)
SC_float(_Detail0NormalScale, 1, [SCCache][SCRange(-10,10)], "", "")
SC_Texture2D(_Detail0NormalMap, "bump", [], "__NormalMap", "")
SC_uint(_Detail0UV, 0, [SCEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3)], "__UV", "")
SC_BoxEnd

SC_Box
SC_float(_Detail1Boost, 1, [SCCache][SCRange(1,2)], "", "")
SC_Texture2D(_Detail1Texture, "white", [], "Detail G", "")
SC_ScaleOffset(_Detail1Texture)
SC_float(_Detail1NormalScale, 1, [SCCache][SCRange(-10,10)], "", "")
SC_Texture2D(_Detail1NormalMap, "bump", [], "__NormalMap", "")
SC_uint(_Detail1UV, 0, [SCEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3)], "__UV", "")
SC_BoxEnd

SC_Box
SC_float(_Detail2Boost, 1, [SCCache][SCRange(1,2)], "", "")
SC_Texture2D(_Detail2Texture, "white", [], "Detail B", "")
SC_ScaleOffset(_Detail2Texture)
SC_float(_Detail2NormalScale, 1, [SCCache][SCRange(-10,10)], "", "")
SC_Texture2D(_Detail2NormalMap, "bump", [], "__NormalMap", "")
SC_uint(_Detail2UV, 0, [SCEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3)], "__UV", "")
SC_BoxEnd

SC_Box
SC_float(_Detail3Boost, 1, [SCCache][SCRange(1,2)], "", "")
SC_Texture2D(_Detail3Texture, "white", [], "Detail A", "")
SC_ScaleOffset(_Detail3Texture)
SC_float(_Detail3NormalScale, 1, [SCCache][SCRange(-10,10)], "", "")
SC_Texture2D(_Detail3NormalMap, "bump", [], "__NormalMap", "")
SC_uint(_Detail3UV, 0, [SCEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3)], "__UV", "")
SC_BoxEnd
