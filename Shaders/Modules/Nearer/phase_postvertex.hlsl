if (SCIsPerspective())
{
    #if defined(SC_PASS_NON_VIEW) && (defined(UNITY_SHADER_VARIABLES_INCLUDED) || defined(UNIVERSAL_SHADER_VARIABLES_INCLUDED))
    float _Near = _ProjectionParams.y;
    float3 cameraPosition = _WorldSpaceCameraPos.xyz;
    float3 cameraForward = -unity_WorldToCamera._m20_m21_m22;
    #elif defined(UNITY_SHADER_VARIABLES_INCLUDED) || defined(UNIVERSAL_SHADER_VARIABLES_INCLUDED)
    float _Near = _ProjectionParams.y;
    float3 cameraPosition = _WorldSpaceCameraPos.xyz;
    float3 cameraForward = camera.forward;
    #else
    // 不明なプラットフォーム
    // うまく動かないかも
    float _Near = SC_V2P()._m23;
    float3 cameraPosition = camera.position;
    float3 cameraForward = camera.forward;
    #endif

    if (_Near < 0.1 && dot(vertex.N,vertex.N) > 0)
    {
        float clipStart = -_Near - 0.001;
        float clipEnd = 0.1;

        float3 diff = vertex.position - cameraPosition;
        float z = dot(cameraForward, diff);
        float move = saturate((z-clipStart)/(clipEnd-clipStart));
        #if !defined(SC_PASS_NON_VIEW)
        float3 diffXY = diff - cameraForward * dot(diff, cameraForward);
        vertex.position = vertex.position - diffXY + diffXY / (1-move*0.999);
        #endif
        vertex.position -= cameraForward * (clipEnd+_Near) * move;
    }
}
