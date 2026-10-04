if(_RimShadeGradientIndex >= 0)
{
    half rimShadeMask = SCRemap(sd.mask[_RimShadeMaskChannel], _RimShadeMaskRemap);
    sd.col.rgb *= SCSampleClamp(sd.gradientsTexture, float2(1 - (rimShadeMask - dot(vertex.N,vertex.Head) * rimShadeMask), 0.5), _RimShadeGradientIndex).rgb;
}
