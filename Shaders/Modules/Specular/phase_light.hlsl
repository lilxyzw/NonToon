{
    half3 V = vertex.V;
    half3 N = sd.N_detail;
    half NdotV = abs(dot(N, V));
    half specular = 0.04;

    half roughnessT = sd.roughness.x;
    half roughnessB = sd.roughness.y;
    half r2 = roughnessT * roughnessB;
    half roughness2 = roughnessT * 0.5 + roughnessB * 0.5;
    half f1 = 1e-4f + NdotV * roughness2;
    half f2 = roughness2 + (NdotV - NdotV * roughness2) * 2;

    half3 L = light.direction;
    half3 H = normalize(V + L);
    half NdotL = saturate(dot(N, L)) * sqrt(saturate(dot(sd.N, L)));
    half NdotH = saturate(dot(N, H));

    half sjggx = 0.5 / (f1 + f2 * NdotL);

    #if 1
    half3 v = half3(dot(sd.T, H) * roughnessB, dot(sd.B, H) * roughnessT, NdotH * r2);
    half w = r2 / dot(v, v);
    half ggx = r2 * w * w;
    #else
    half d = (NdotH * r2 - NdotH) * NdotH + 1.0;
    half ggx = r2 / (d * d + 1e-7f);
    #endif

    half specularTerm = sjggx * ggx;
    if (SCIsGamma()) specularTerm = sqrt(max(1e-4f, specularTerm));

    half a = 1.0-saturate(dot(L, H));
    half fresnelTerm = specular + (1-specular) * a * a * a * a * a;

    sd.postadd += specularTerm * NdotL * fresnelTerm * sd.mask[_SpecularMaskChannel] * light.color * lerp(_SpecularColor.rgb, sd.albedoAlpha.rgb * _SpecularColor.rgb, _SpecularMultiplyAlbedo);
}
