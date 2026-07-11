{
    half rimFlat = saturate(1-dot(sd.N,normalize(vertex.Head-sd.L*0.25)));
    half rimDetail = saturate(1-dot(sd.N_detail,normalize(vertex.Head-sd.L*0.25)));
    half rim = saturate((rimFlat - _RimLightRange.x) / (_RimLightRange.y - _RimLightRange.x));
    rimDetail = saturate(rimDetail + saturate(rim * 10 - 9));
    rim *= rimDetail;
    if (!SCIsGamma()) rim *= rim;
    sd.add += rim * sd.shadow * sd.mask[_RimLightMaskChannel] * lerp(_RimLightColor.rgb, sd.albedoAlpha.rgb * _RimLightColor.rgb, _RimLightMultiplyAlbedo);
}
