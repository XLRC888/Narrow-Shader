vec3 CAS(sampler2D Sampler) {
	ivec2 Coords = ivec2(gl_FragCoord.xy);
    vec3 e = texelFetch(Sampler, Coords, 0).rgb;
    vec3 a = texelFetchOffset(Sampler, Coords, 0, ivec2(-1,-1)).rgb;
    vec3 b = texelFetchOffset(Sampler, Coords, 0, ivec2( 0,-1)).rgb;
    vec3 c = texelFetchOffset(Sampler, Coords, 0, ivec2( 1,-1)).rgb;
    vec3 d = texelFetchOffset(Sampler, Coords, 0, ivec2(-1, 0)).rgb;
    vec3 f = texelFetchOffset(Sampler, Coords, 0, ivec2( 1, 0)).rgb;
    vec3 g = texelFetchOffset(Sampler, Coords, 0, ivec2(-1, 1)).rgb;
    vec3 h = texelFetchOffset(Sampler, Coords, 0, ivec2( 0, 1)).rgb;
    vec3 i = texelFetchOffset(Sampler, Coords, 0, ivec2( 1, 1)).rgb;
    vec3 mnRGB  = min(min(min(d,e),min(f,b)),h);
    vec3 mnRGB2 = min(min(min(mnRGB,a),min(g,c)),i);
    mnRGB += mnRGB2;
    vec3 mxRGB  = max(max(max(d,e),max(f,b)),h);
    vec3 mxRGB2 = max(max(max(mxRGB,a),max(g,c)),i);
    mxRGB += mxRGB2;
    vec3 rcpMxRGB = vec3(1)/mxRGB;
    vec3 ampRGB = clamp((min(mnRGB,2.0-mxRGB) * rcpMxRGB),0,1);
    ampRGB = inversesqrt(ampRGB);
    float peak = 8.0 - 3.0 * SHARPENING;
    vec3 wRGB = -vec3(1)/(ampRGB * peak);
    vec3 rcpWeightRGB = vec3(1)/(1.0 + 4.0 * wRGB);
    vec3 window = (b + d) + (f + h);
    vec3 outColor = clamp((window * wRGB + e) * rcpWeightRGB,0,1);
    return outColor;
}
