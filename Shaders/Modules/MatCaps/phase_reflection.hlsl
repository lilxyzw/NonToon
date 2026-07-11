if (_Enable)
{
    half3 N_VD = vertex.Head;
    half3 B_VD = normalize(float3(0,1,0) - N_VD * N_VD.y * 0.9);
    half3 T_VD = cross(N_VD, B_VD);
    half3x3 TBN_VD = float3x3(T_VD, B_VD, N_VD);
    half2 uvMat = mul(TBN_VD, sd.N).xy * 0.5 + 0.5;
    half2 uvMat_Detail = mul(TBN_VD, sd.N_detail).xy * 0.5 + 0.5;
    sd.col.rgb *= lerp(1, SCSampleClamp(_MatCapMultiply, lerp(uvMat, uvMat_Detail, _MatCapMultiplyDetail)).rgb * _MatCapMultiplyColor.rgb, sd.mask[_MatCapMultiplyMaskChannel]);
    sd.add += SCSampleClamp(_MatCapAdd, lerp(uvMat, uvMat_Detail, _MatCapAddDetail)).rgb * _MatCapAddColor.rgb * sd.mask[_MatCapAddMaskChannel];
}
