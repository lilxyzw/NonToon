if(_RimShadeGradientIndex >= 0)
{
    sd.col.rgb *= SCSampleClamp(sd.gradientsTexture, float2(1 - (sd.mask[_RimShadeMaskChannel] - dot(vertex.N,vertex.Head) * sd.mask[_RimShadeMaskChannel]), 0.5), _RimShadeGradientIndex).rgb;
}
