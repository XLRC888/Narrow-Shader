float getFogFactor(float dist, float start, float end, float density) {
    float fogFactor = (end - dist) / (end - start);
    fogFactor = clamp(fogFactor, 0.0, 1.0);
    fogFactor = pow(fogFactor, density);
    return 1.0 - fogFactor;
}

float getFogFactorExp(float dist, float density) {
    return 1.0 - exp(-dist * density);
}

vec3 getDayFogColor(float dayProgress) {
    vec3 dawnFog = vec3(0.7, 0.5, 0.4);
    vec3 dayFog = vec3(0.7, 0.75, 0.85);
    vec3 duskFog = vec3(0.8, 0.5, 0.3);
    vec3 nightFog = vec3(0.1, 0.1, 0.15);
    if (dayProgress < 0.25) {
        return mix(nightFog, dawnFog, dayProgress * 4.0);
    } else if (dayProgress < 0.5) {
        return mix(dawnFog, dayFog, (dayProgress - 0.25) * 4.0);
    } else if (dayProgress < 0.75) {
        return mix(dayFog, duskFog, (dayProgress - 0.5) * 4.0);
    } else {
        return mix(duskFog, nightFog, (dayProgress - 0.75) * 4.0);
    }
}

vec3 applyDistanceFog(vec3 color, float dist, vec3 fogColor, float fogFactor) {
    return mix(color, fogColor, fogFactor);
}

vec3 applyAtmosphericFog(vec3 color, vec3 worldPos, vec3 fogColor, float density, float dayProgress) {
    float heightFactor = exp(-max(worldPos.y - 64.0, 0.0) * 0.005);
    float dist = length(worldPos);
    float fog = getFogFactor(dist, 16.0, 256.0, density);
    fog *= heightFactor;
    return mix(color, fogColor, clamp(fog, 0.0, 1.0));
}

vec3 applyHorrorFog(vec3 color, vec3 worldPos, float time, float density) {
    float dist = length(worldPos);
    float baseFog = getFogFactor(dist, 8.0, 64.0, density);
    float noiseFog = noise3D(worldPos * 0.02 + time * 0.1);
    baseFog = clamp(baseFog + noiseFog * 0.15, 0.0, 1.0);
    vec3 fogColor = vec3(0.05, 0.03, 0.08);
    vec3 fogTint = vec3(0.1, 0.02, 0.15) * noiseFog;
    fogColor += fogTint;
    return mix(color, fogColor, baseFog);
}

vec3 applyMoodFog(vec3 color, vec3 worldPos, float time, int mood, float density, vec3 fogColor, float dayProgress) {
    if (mood == 1) {
        return applyHorrorFog(color, worldPos, time, density);
    }
    vec3 dayFog = getDayFogColor(dayProgress);
    fogColor = mix(fogColor, dayFog, 0.5);
    float dist = length(worldPos);
    float fog = getFogFactor(dist, 32.0, 256.0, density);
    return mix(color, fogColor, clamp(fog, 0.0, 1.0));
}
