void SCCalculateEnvironmentLight(inout SCLightData lightSum, inout half3 env, inout SCShadingData sd, inout SCCustomData cd, SCVertexData vertex, half4 SHAr, half4 SHAg, half4 SHAb, half4 SHBr, half4 SHBg, half4 SHBb, half4 SHC)
{
    half4 vB = vertex.Head.xyzz * vertex.Head.yzzx;
    // L0 L2 average
    half3 res = float3(SHAr.w,SHAg.w,SHAb.w);
    res += float3(SHBr.z, SHBg.z, SHBb.z) * 0.333333;
    // L1
    half3 l1;
    l1.r = dot(SHAr.rgb, vertex.Head);
    l1.g = dot(SHAg.rgb, vertex.Head);
    l1.b = dot(SHAb.rgb, vertex.Head);
    half3 envF = res + max(l1 * 0.666666, 0);
    half3 envB = res - l1 * 0.666666;
    #if defined(UNITY_COLORSPACE_GAMMA)
        envF = LinearToGammaSpace(envF);
        envB = LinearToGammaSpace(envB);
    #endif
    sd.L = lightSum.direction + SHAr.rgb * 0.333333 + SHAg.rgb * 0.333333 + SHAb.rgb * 0.333333;
    sd.L = dot(sd.L,sd.L) == 0 ? 0 : normalize(sd.L);

    half NdotL = dot(sd.N,sd.L);
    half VdotL = dot(vertex.Head,sd.L);
    half fakerim = saturate((NdotL - VdotL - 0.5) * 2) * saturate(NdotL*3);
    env += envF + saturate(envB - envF) * fakerim * fakerim;

    // Rampの影を乗算するので少し明るくしてバランスをとる
    env *= 1.2;
}

void SCCalculateLight(inout SCLightData lightSum, inout SCShadingData sd, inout SCCustomData cd, SCVertexData vertex, SCLightData light)
{
    __SC_PHASE_light__

    lightSum.direction += light.direction * dot(light.color, 0.333333);
    {
        half factor = saturate(dot(light.direction,vertex.Head) * 1 + 0.25);
        half NdotL = dot(sd.N,light.direction);
        half NdotH = dot(sd.N,vertex.Head);
        half mix = (_BacklightRange-NdotH+NdotL)*_BacklightSharpness+0.5;
        half rim = saturate((mix - (factor*0.75+0.25))) * cd.screenrim * sd.mask[_BacklightMaskChannel];
        #ifdef OUTLINE
        rim = 0;
        #endif
        light.color *= saturate(factor + rim * rim);
    }
    lightSum.color += light.color;
}

#include "Packages/jp.lilxyzw.shadercore/ShaderLibrary/birp_lighting.hlsl"

half4 frag(v2f i, bool isFront : SV_IsFrontFace) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(i);
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
    SCPositionAndDirection camera = SCGetCameraData();
    SCPositionAndDirection head = SCGetHeadData();
    SCPositionAndDirection headBone = SCGetHeadBoneData();
    SCVertexData vertex = FromPixelInput(i, camera, head, headBone, SCTangentScale(), isFront);
    vertex.shadowOffset = _NTShadowBias * 0.5;

    // Custom Data
    SCCustomData cd = (SCCustomData)0;

    // Screen Space Rimlighting
    cd.screenrim = 0;
    if (SCIsFrameDepthGenerated())
    {
        float random = frac(sin(dot(vertex.uvDepth.xy,float2(12.9898,78.233))) * 36203.4357);
        float2 normalVS = normalize(mul((float3x3)SC_W2V(), vertex.N)).xy * abs(SC_V2P()._m00_m11/vertex.positionRaw.w) * 0.02;
        float maxcount = 8;
        for (int count = 0; count < maxcount; count++)
        {
            float2 uv = vertex.uvDepth + normalVS * (count + random) / maxcount;
            float depth = SCGetFrameDepth(uv);
            cd.screenrim = saturate(cd.screenrim + saturate((depth - vertex.positionRaw.w - 0.2) * 2) / maxcount);
        }
    }
    else
    {
        cd.screenrim = 1;
    }

    // Main Texture
    SCShadingData sd;
    sd.L = 0;
    sd.lightColor = 0;
    sd.shadow = 1;
    sd.add = 0;
    sd.postadd = 0;
    sd.uv = vertex.uv[0].xy;
    sd.albedoAlpha = SCSample(_BaseTexture, sampler_BaseTexture, sd.uv);
    sd.mask = SCSample(_SharedMask, sampler_BaseTexture, sd.uv);
    sd.roughness = _Roughness;
    sd.normalMapWithRoughness = _NormalMapWithRoughness;
    sd.N = SCUnpackNormalAndRoughness(SCSample(_NormalMap, sampler_BaseTexture, sd.uv), _NormalScale, sd.roughness, sd.normalMapWithRoughness);
    sd.N_detail = sd.N;
    sd.maskTexture = _SharedMask;
    sd.gradientsTexture = _SharedGradients;

    __SC_PHASE_base__

    sd.albedoAlpha = saturate(sd.albedoAlpha);
    sd.col = sd.albedoAlpha;

    sd.N = normalize(mul(sd.N, vertex.TBN));
    sd.N_detail = normalize(mul(sd.N_detail, vertex.TBN));
    sd.T = normalize(vertex.T - sd.N_detail * dot(sd.N_detail, vertex.T));
    sd.B = normalize(cross(sd.N_detail, sd.T) * vertex.crossDirection * SCTangentScale());

    sd.roughness = saturate(_NormalMapWithRoughness ? sd.roughness : _Roughness);

    half3 dx = ddx(sd.N);
    half3 dy = ddy(sd.N);
    half dxy = max(dot(dx,dx), dot(dy,dy));
    half roughnessGSAA = saturate(dxy / (dxy * 5 + 0.002) * 0.5);

    sd.roughness = max(sd.roughness, roughnessGSAA);

    SCLightData lightSum = (SCLightData)0;
    half3 env = 0;
    SCCalculateAllLights(lightSum, env, sd, cd, vertex, i);

    sd.L = normalize(sd.L + vertex.Head * 1.5 + float3(0,1,0));

    // lighting in the VRChat world is not set up correctly
    //sd.lightColor = env + lightSum.color * lerp(0.5, 1, saturate(rcp(dot(lightSum.color,1))));
    sd.lightColor = saturate(env + lightSum.color);

    __SC_PHASE_modifylight__

    __SC_PHASE_shade__

    __SC_PHASE_reflection__

    __SC_PHASE_add__

    #ifdef NT_FUR
    sd.add += i.customV2f.furVector.z * pow(saturate(1-abs(dot(normalize(sd.N), vertex.V))), _FurRimFresnelPower) * lerp(1, saturate(1-sd.lightColor), _FurRimAntiLight) * _FurRimColor.rgb;
    #endif

    sd.col.rgb += sd.add;
    sd.col.rgb *= sd.lightColor;
    sd.col.rgb += sd.postadd;

    __SC_PHASE_postpixel__

    #ifdef OUTLINE
    sd.col.rgb *= _OutlineColor.rgb;
    #endif

    #ifdef NT_FUR
    sd.col.a = saturate((SCSampleRepeat(_FurNoiseMask, sd.uv * _FurNoiseTiling).r - i.customV2f.furVector.z * abs(i.customV2f.furVector.z)) * 3);
    if (sd.col.a == 0) discard;
    #else
    if (_RenderingMode == 0)
    {
        sd.col.a = 1;
    }
    else if (_RenderingMode == 1)
    {
        if (_NTDitherTex[uint2(0,0)].a != 0)
        {
            clip(sd.col.a - (_NTDitherTex[uint2(i.pos.xy)%4].r * 255 + 1) / (15+2));
        }
        else
        {
            sd.col.a = saturate((sd.col.a - _Cutoff) / max(fwidth(sd.col.a), 0.0001) + 0.5);
            if (sd.col.a == 0) discard;
        }
    }
    else if (_RenderingMode == 2)
    {
        clip(sd.col.a - _Cutoff);
    }
    #endif

    UNITY_APPLY_FOG(i.fogCoord, sd.col);
    return sd.col;
}
