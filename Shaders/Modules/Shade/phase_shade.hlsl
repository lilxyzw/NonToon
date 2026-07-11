if(_ShadeGradientIndex >= 0)
{
    // Default Shade
    half2 shadeRange = _ShadeGradientRange.xy;
    half4 sdfMap = SCSample(_SDFMap, sampler_BaseTexture, sd.uv);
    half3 L = sd.L;
    half3 L_Shade = normalize(lerp(L - headBone.up * dot(L, headBone.up), L, sdfMap.b));
    half NdotL_N = dot(sd.N,L_Shade);
    half NdotL_Detail = dot(sd.N_detail,L_Shade);
    half NdotL = min(NdotL_N * 0.5 + 0.5, shadeRange.y) + (NdotL_Detail - NdotL_N) * (shadeRange.y - shadeRange.x) * 0.5;

    // SDF Shade
    if(_SDFType == 1)
    {
        half sdf = dot(L.xz, headBone.left.xz) < 0 ? sdfMap.g : sdfMap.r;

        half3 faceF = headBone.forward;
        faceF.y *= _SDFBlendVertical;
        faceF = dot(faceF,faceF) == 0 ? 0 : normalize(faceF);

        half3 faceL = L.xyz;
        faceL.y *= _SDFBlendVertical;
        faceL = dot(faceL,faceL) == 0 ? 0 : normalize(faceL);

        half lnSDF = dot(faceL,faceF);
        NdotL = lerp(saturate(lnSDF * 0.5 + sdf * 0.5 + 0.25), NdotL, sdfMap.b);
    }
    if(_SDFType == 2)
    {
        half NdotR = dot(sd.N, headBone.right);
        half3 side = NdotR > 0 ? headBone.right : headBone.left;
        half LdotS = dot(L, side);
        half LdotU = dot(L, headBone.up);
        bool isShadow = LdotS < 0;

        float _SDFSharpen = 0.5 - 0.5 * sdfMap.b;
        shadeRange.xy = lerp(shadeRange.xy, (shadeRange.x + shadeRange.y) * 0.5, _SDFSharpen);

        sdfMap.rg *= saturate(abs(LdotS) * 4 - 1.0);

        if (isShadow) NdotL -= sdfMap.r * saturate((NdotL_N * 0.5 + 0.5 - shadeRange.y) * 4);
        if (!isShadow) NdotL += sdfMap.r;
        if (isShadow) NdotL += sdfMap.g * abs(NdotR) * sqrt(abs(NdotR));

        NdotL = (NdotL - shadeRange.x) / (1-_SDFSharpen) + shadeRange.x;
    }
    NdotL = min(NdotL, _ShadeGradientRange.y);

    half shade = saturate(NdotL) * (sd.shadow * (_ShadeGradientRange.y - _ShadeGradientRange.x) + _ShadeGradientRange.x) / _ShadeGradientRange.y;
    sd.shadow *= saturate((NdotL - shadeRange.x) / (shadeRange.y - shadeRange.x));

    // Ramp Shading
    sd.col.rgb *= SCSampleClamp(sd.gradientsTexture, float2(shade, 0.5), _ShadeGradientIndex).rgb;
}
