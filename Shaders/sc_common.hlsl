struct SCCustomData
{
    half screenrim;
};

void SCVertexMorph(inout SCVertexData vertex, SCPositionAndDirection camera, SCPositionAndDirection head, SCPositionAndDirection headBone)
{
    __SC_PHASE_morph__
}

void SCVertexPost(inout SCVertexData vertex, SCPositionAndDirection camera, SCPositionAndDirection head, SCPositionAndDirection headBone, float3 L = 0)
{
    #ifdef OUTLINE
    float3 outlineN = vertex.color.rgb * 2.0 - 1.0;
    if(!_OutlineWidth || dot(outlineN,outlineN) < 1e-6f) vertex.position = 0.0/0.0;
    outlineN = _OutlineFromVertexColor ? mul(outlineN, vertex.TBN) : vertex.N;
    float offset = _OutlineFromVertexColor ? _OutlineZOffset * vertex.color.a : _OutlineZOffset;
    vertex.position += outlineN * _OutlineWidth * 0.01 - vertex.V * offset;
    #endif

    __SC_PHASE_postvertex__

    float bias = _NTShadowBias;
    #if defined(UNIVERSAL_PIPELINE_CORE_INCLUDED)
    bias *= 0.5;
    #endif
    bias *= saturate(vertex.position.y + 0.3);
    #if defined(SHADOWS_DEPTH)
        if(UNITY_MATRIX_P._m33 == 0.0) bias = 0;
    #endif
    vertex.position -= L * bias * saturate(dot(L,normalize(_WorldSpaceCameraPos.xyz - vertex.position)) * 2 + 1);
}

void SCPixelClip(v2f i, bool isFront, float bitangentDir)
{
    SCPositionAndDirection camera = SCGetCameraData();
    SCPositionAndDirection head = SCGetHeadData();
    SCPositionAndDirection headBone = SCGetHeadBoneData();
    SCVertexData vertex = FromPixelInput(i, camera, head, headBone, bitangentDir, isFront);
    vertex.shadowOffset = _NTShadowBias;

    // Main Texture
    SCShadingData sd;
    sd.shadow = 1;
    sd.add = 0;
    sd.postadd = 0;
    sd.uv = vertex.uv[0].xy;
    sd.albedoAlpha = SCSample(_BaseTexture, sampler_BaseTexture, sd.uv);
    sd.mask = SCSample(_SharedMask, sampler_BaseTexture, sd.uv);
    sd.roughness = _Roughness;
    sd.N = half3(0,0,1);
    sd.N_detail = half3(0,0,1);
    sd.maskTexture = _SharedMask;
    sd.gradientsTexture = _SharedGradients;

    __SC_PHASE_base__

    sd.albedoAlpha = saturate(sd.albedoAlpha);

    sd.col = sd.albedoAlpha;

    #ifdef NT_FUR
    sd.col.a = saturate((SCSampleRepeat(_FurNoiseMask, sd.uv * _FurNoiseTiling).r - i.customV2f.furVector.z * abs(i.customV2f.furVector.z)) * 3);
    if (sd.col.a < 1) discard;
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

    if (_RenderingMode == 2) clip(sd.col.a - (_NTDitherTex[uint2(i.pos.xy)%4].r * 255 + 1) / (15+2));
    #endif
}

#ifdef NT_FUR
void SCCustomV2FFunc(inout v2f o, SCVertexData vertex, SCPositionAndDirection camera, SCPositionAndDirection head, SCPositionAndDirection headBone)
{
    SCCustomV2F customV2f = (SCCustomV2F)0;
    customV2f.furVector = vertex.T * _FurVector.x + vertex.B * _FurVector.y + vertex.N * _FurVector.z;
    o.customV2f = customV2f;
}
#endif
