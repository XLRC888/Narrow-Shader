vec3 toClipSpace(vec3 viewPos) {
    vec4 clipPos = gbufferProjection * vec4(viewPos, 1.0);
    return clipPos.xyz / clipPos.w;
}

vec3 toViewSpace(vec3 clipPos) {
    vec4 viewPos = gbufferProjectionInverse * vec4(clipPos, 1.0);
    return viewPos.xyz / viewPos.w;
}

vec3 toWorldSpace(vec3 viewPos) {
    vec4 worldPos = gbufferModelViewInverse * vec4(viewPos, 1.0);
    return worldPos.xyz;
}

vec3 viewToScreen(vec3 viewPos) {
    vec4 clipPos = gbufferProjection * vec4(viewPos, 1.0);
    clipPos.xyz /= clipPos.w;
    return clipPos.xyz * 0.5 + 0.5;
}

vec3 screenToWorld(vec3 screenPos) {
    vec4 clipPos = vec4(screenPos * 2.0 - 1.0, 1.0);
    vec4 viewPos = gbufferProjectionInverse * clipPos;
    viewPos /= viewPos.w;
    vec4 worldPos = gbufferModelViewInverse * viewPos;
    return worldPos.xyz;
}
