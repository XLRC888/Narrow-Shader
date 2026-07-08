float getDepth(vec2 uv) {
    return texture2D(depthtex0, uv).r;
}

float getDepthDH(vec2 uv) {
    return texture2D(dhDepthTex0, uv).r;
}

float getLinearDepth(float depth) {
    return (2.0 * near) / (far + near - depth * (far - near));
}

float getLinearDepthDH(float depth) {
    return (2.0 * dhNearPlane) / (dhFarPlane + dhNearPlane - depth * (dhFarPlane - dhNearPlane));
}

vec3 getWorldPos(vec2 uv, float depth) {
    vec4 clipPos = vec4(uv * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);
    vec4 viewPos = gbufferProjectionInverse * clipPos;
    viewPos /= viewPos.w;
    vec4 worldPos = gbufferModelViewInverse * viewPos;
    return worldPos.xyz;
}

vec3 getScreenPos(vec3 worldPos) {
    vec4 viewPos = gbufferModelView * vec4(worldPos, 1.0);
    vec4 clipPos = gbufferProjection * viewPos;
    clipPos /= clipPos.w;
    return clipPos.xyz * 0.5 + 0.5;
}

float getDepthCompare(vec2 uv) {
    float vanillaDepth = getDepth(uv);
    #ifdef DISTANT_HORIZONS
        float dhDepth = getDepthDH(uv);
        if (dhDepth < 1.0) {
            return getLinearDepthDH(dhDepth);
        }
    #endif
    return getLinearDepth(vanillaDepth);
}
