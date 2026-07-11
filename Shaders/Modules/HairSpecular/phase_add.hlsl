if(_HairSpecularGradientIndex >= 0)
{
    half aniso = dot(vertex.B,normalize(sd.L * 0.5 + vertex.Head * 0.3 + vertex.N - headBone.up * dot(vertex.N,headBone.up)));
    half3 anisoRamp = SCSampleClamp(sd.gradientsTexture, float2(aniso * 0.5 + 0.5, 0.5), _HairSpecularGradientIndex).rgb;
    sd.add += sd.shadow * sd.mask[_HairSpecularMaskChannel] * lerp(anisoRamp, sd.albedoAlpha.rgb * anisoRamp, _HairSpecularMultiplyAlbedo);
}
