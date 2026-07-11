{
    float depth = vertex.headDepth;
    half distFade = saturate((depth - _DistanceFade.x) / (_DistanceFade.y - _DistanceFade.x));
    sd.col.rgb = lerp(sd.col.rgb, 0, _DistanceFadeStrength - distFade * _DistanceFadeStrength);
}
