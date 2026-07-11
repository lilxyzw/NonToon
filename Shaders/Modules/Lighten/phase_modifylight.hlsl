{
    half3 newColor = _LightBoostAsEmission ? max(sd.lightColor, _LightBoost) : max(sd.lightColor, saturate(sd.lightColor * _LightBoost));
    sd.lightColor = lerp(sd.lightColor, newColor, sd.mask[_LightBoostMaskChannel]);
}
