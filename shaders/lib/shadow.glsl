float getShadowBias(vec3 viewPos, vec3 normal) {
    float bias = max(0.05 * (1.0 - dot(normal, normalize(sunPosition))), 0.005);
    return bias;
}

float getShadowPCF(vec3 shadowCoord, float bias) {
    float shadow = 0.0;
    vec2 texelSize = 1.0 / shadowMapResolution;
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            vec2 offset = vec2(float(x), float(y)) * texelSize;
            float shadowDepth = texture2D(shadowtex0, shadowCoord.xy + offset).r;
            shadow += step(shadowCoord.z - bias, shadowDepth);
        }
    }
    shadow /= 9.0;
    return shadow;
}

float getShadowPCSS(vec3 shadowCoord, float bias, float softness) {
    float avgBlockerDepth = 0.0;
    int numBlockers = 0;
    vec2 texelSize = 1.0 / shadowMapResolution;
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(float(x), float(y)) * texelSize * softness;
            float sampleDepth = texture2D(shadowtex0, shadowCoord.xy + offset).r;
            if (shadowCoord.z - bias > sampleDepth) {
                avgBlockerDepth += sampleDepth;
                numBlockers++;
            }
        }
    }
    if (numBlockers == 0) return 1.0;
    avgBlockerDepth /= float(numBlockers);
    float penumbra = (shadowCoord.z - avgBlockerDepth) / avgBlockerDepth * softness;
    penumbra = clamp(penumbra, 0.0, softness * 2.0);
    float shadow = 0.0;
    for (int x = -3; x <= 3; x++) {
        for (int y = -3; y <= 3; y++) {
            vec2 offset = vec2(float(x), float(y)) * texelSize * penumbra;
            float shadowDepth = texture2D(shadowtex0, shadowCoord.xy + offset).r;
            shadow += step(shadowCoord.z - bias, shadowDepth);
        }
    }
    shadow /= 49.0;
    return shadow;
}

float getShadow(vec3 viewPos, vec3 normal) {
    vec4 shadowClip = shadowModelView * vec4(viewPos + cameraPosition, 1.0);
    shadowClip = shadowProjection * shadowClip;
    shadowClip.xyz /= shadowClip.w;
    vec3 shadowCoord = shadowClip.xyz * 0.5 + 0.5;
    if (shadowCoord.x < 0.0 || shadowCoord.x > 1.0 || shadowCoord.y < 0.0 || shadowCoord.y > 1.0 || shadowCoord.z < 0.0 || shadowCoord.z > 1.0) {
        return 1.0;
    }
    float bias = getShadowBias(viewPos, normal);
    #ifdef SHADOW_QUALITY
        return getShadowPCF(shadowCoord, bias);
    #else
        float shadowDepth = texture2D(shadowtex0, shadowCoord.xy).r;
        return step(shadowCoord.z - bias, shadowDepth);
    #endif
}

float getCloudShadow(vec3 worldPos) {
    vec3 sunDir = normalize(sunPosition);
    vec3 cloudHit = worldPos + sunDir * ((160.0 - worldPos.y) / max(sunDir.y, 0.001));
    float shadow = cloudDensity(cloudHit.xz, frameTimeCounter, 0);
    return mix(1.0, 0.7, shadow * 0.3);
}
