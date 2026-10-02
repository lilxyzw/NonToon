void AppendFur(inout TriangleStream<v2f> outStream, v2f input[3], SCPositionAndDirection camera, SCPositionAndDirection head, SCPositionAndDirection headBone, float3 factor)
{
    v2f output = SCInterpolateV2F(input, factor);

    SCVertexData vertex = FromPixelInput(output, camera, head, headBone, SCTangentScale(), true);
    SCOutputSVPosition(output, vertex, camera, head, headBone);
    output.customV2f.furVector = -1;
    outStream.Append(output);

    output.position += input[0].customV2f.furVector * factor.x + input[1].customV2f.furVector * factor.y + input[2].customV2f.furVector * factor.z;
    vertex = FromPixelInput(output, camera, head, headBone, SCTangentScale(), true);
    SCOutputSVPosition(output, vertex, camera, head, headBone);
    output.customV2f.furVector = 1;
    outStream.Append(output);
}

#ifdef NT_FUR_ONEPASS
[instance(3)]
#else
[instance(2)]
#endif
[maxvertexcount(16)]
void geom(triangle v2f input[3], inout TriangleStream<v2f> outStream, uint InstanceID : SV_GSInstanceID)
{
    UNITY_SETUP_INSTANCE_ID(input[0]);
    SCPositionAndDirection camera = SCGetCameraData();
    SCPositionAndDirection head = SCGetHeadData();
    SCPositionAndDirection headBone = SCGetHeadBoneData();

    if (InstanceID == 0)

    #if defined(NT_FUR_ONEPASS)
    {
        input[0].customV2f.furVector = -1;
        input[1].customV2f.furVector = -1;
        input[2].customV2f.furVector = -1;
        outStream.Append(input[0]);
        outStream.Append(input[1]);
        outStream.Append(input[2]);
    }
    else if (InstanceID == 1)
    #endif

    {
        if(_FurSubdivision <= 1)
        {
            AppendFur(outStream, input, camera, head, headBone, float3(1.0, 0.0, 0.0) / 1.0);
            AppendFur(outStream, input, camera, head, headBone, float3(0.0, 1.0, 0.0) / 1.0);
            AppendFur(outStream, input, camera, head, headBone, float3(0.0, 0.0, 1.0) / 1.0);
        }
        else
        {
            AppendFur(outStream, input, camera, head, headBone, float3(1.0, 0.0, 0.0) / 1.0);
            AppendFur(outStream, input, camera, head, headBone, float3(0.0, 1.0, 1.0) / 2.0);
            AppendFur(outStream, input, camera, head, headBone, float3(0.0, 1.0, 0.0) / 1.0);
            AppendFur(outStream, input, camera, head, headBone, float3(1.0, 0.0, 1.0) / 2.0);
            AppendFur(outStream, input, camera, head, headBone, float3(0.0, 0.0, 1.0) / 1.0);
            AppendFur(outStream, input, camera, head, headBone, float3(1.0, 1.0, 0.0) / 2.0);
        }
        AppendFur(outStream, input, camera, head, headBone, float3(1.0, 0.0, 0.0) / 1.0);
    }
    else
    {
        if(_FurSubdivision >= 3)
        {
            AppendFur(outStream, input, camera, head, headBone, float3(1.0, 1.0, 0.0) / 2.0);
            AppendFur(outStream, input, camera, head, headBone, float3(1.0, 4.0, 1.0) / 6.0);
            AppendFur(outStream, input, camera, head, headBone, float3(0.0, 1.0, 1.0) / 2.0);
            AppendFur(outStream, input, camera, head, headBone, float3(1.0, 1.0, 4.0) / 6.0);
            AppendFur(outStream, input, camera, head, headBone, float3(1.0, 0.0, 1.0) / 2.0);
            AppendFur(outStream, input, camera, head, headBone, float3(4.0, 1.0, 1.0) / 6.0);
            AppendFur(outStream, input, camera, head, headBone, float3(1.0, 1.0, 0.0) / 2.0);
        }
    }
    outStream.RestartStrip();
}
