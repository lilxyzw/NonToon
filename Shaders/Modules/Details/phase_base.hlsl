if (_Enable)
{
    half4 detailMask = SCSample(_DetailMask, sampler_BaseTexture, sd.uv);
    float2 detail0uv = vertex.uv[_Detail0UV].xy * _Detail0Texture_ST.xy + _Detail0Texture_ST.zw;
    sd.albedoAlpha *= lerp(1, SCSampleRepeat(_Detail0Texture, detail0uv) * half4(_Detail0Boost.xxx, 1), detailMask[0]);
    half3 detail0N = SCUnpackNormalAndRoughness(SCSampleRepeat(_Detail0NormalMap, detail0uv), _Detail0NormalScale * detailMask[0], sd.roughness, sd.normalMapWithRoughness);
    sd.N_detail = half3(sd.N_detail.xy + detail0N.xy, sd.N_detail.z * detail0N.z);

    float2 detail1uv = vertex.uv[_Detail1UV].xy * _Detail1Texture_ST.xy + _Detail1Texture_ST.zw;
    sd.albedoAlpha *= lerp(1, SCSampleRepeat(_Detail1Texture, detail1uv) * half4(_Detail1Boost.xxx, 1), detailMask[1]);
    half3 detail1N = SCUnpackNormalAndRoughness(SCSampleRepeat(_Detail1NormalMap, detail1uv), _Detail1NormalScale * detailMask[1], sd.roughness, sd.normalMapWithRoughness);
    sd.N_detail = half3(sd.N_detail.xy + detail1N.xy, sd.N_detail.z * detail1N.z);

    float2 detail2uv = vertex.uv[_Detail2UV].xy * _Detail2Texture_ST.xy + _Detail2Texture_ST.zw;
    sd.albedoAlpha *= lerp(1, SCSampleRepeat(_Detail2Texture, detail2uv) * half4(_Detail2Boost.xxx, 1), detailMask[2]);
    half3 detail2N = SCUnpackNormalAndRoughness(SCSampleRepeat(_Detail2NormalMap, detail2uv), _Detail2NormalScale * detailMask[2], sd.roughness, sd.normalMapWithRoughness);
    sd.N_detail = half3(sd.N_detail.xy + detail2N.xy, sd.N_detail.z * detail2N.z);

    float2 detail3uv = vertex.uv[_Detail3UV].xy * _Detail3Texture_ST.xy + _Detail3Texture_ST.zw;
    sd.albedoAlpha *= lerp(1, SCSampleRepeat(_Detail3Texture, detail3uv) * half4(_Detail3Boost.xxx, 1), detailMask[3]);
    half3 detail3N = SCUnpackNormalAndRoughness(SCSampleRepeat(_Detail3NormalMap, detail3uv), _Detail3NormalScale * detailMask[3], sd.roughness, sd.normalMapWithRoughness);
    sd.N_detail = half3(sd.N_detail.xy + detail3N.xy, sd.N_detail.z * detail3N.z);
}
