{
    half3 newColor = _LightBoostAsEmission ? max(sd.lightColor, _LightBoost) : max(sd.lightColor, saturate(sd.lightColor * _LightBoost));
    half lightBoostMask = SCRemap(sd.mask[_LightBoostMaskChannel], _LightBoostMaskRemap);
    sd.lightColor = lerp(sd.lightColor, newColor, lightBoostMask);
}
