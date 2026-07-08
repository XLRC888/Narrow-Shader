vec3 getBlockLightColor(float lightLevel) {
    vec3 warmLight = vec3(1.0, 0.85, 0.6);
    vec3 coolLight = vec3(0.6, 0.75, 1.0);
    return mix(coolLight, warmLight, lightLevel);
}

vec3 getSkyLightColor(float lightLevel, float dayProgress) {
    vec3 daySky = vec3(0.5, 0.6, 0.8);
    vec3 nightSky = vec3(0.05, 0.05, 0.15);
    vec3 dawnSky = vec3(0.7, 0.5, 0.4);
    vec3 skyColor;
    if (dayProgress < 0.25) {
        skyColor = mix(nightSky, dawnSky, dayProgress * 4.0);
    } else if (dayProgress < 0.5) {
        skyColor = mix(dawnSky, daySky, (dayProgress - 0.25) * 4.0);
    } else if (dayProgress < 0.75) {
        skyColor = mix(daySky, dawnSky, (dayProgress - 0.5) * 4.0);
    } else {
        skyColor = mix(dawnSky, nightSky, (dayProgress - 0.75) * 4.0);
    }
    return skyColor * (lightLevel * 0.8 + 0.2);
}

vec3 calculateLighting(vec3 albedo, vec3 normal, vec3 viewPos, vec2 lmcoord, float dayProgress, float rainStrength) {
    vec3 blockLight = getBlockLightColor(lmcoord.x);
    vec3 skyLight = getSkyLightColor(lmcoord.y, dayProgress);
    float ndotl = max(dot(normal, normalize(sunPosition)), 0.0);
    float diffuse = ndotl * 0.5 + 0.5;
    diffuse = mix(diffuse, 0.5, rainStrength * 0.5);
    vec3 lighting = blockLight * lmcoord.x * lmcoord.x + skyLight * diffuse;
    lighting = mix(lighting, lighting * 0.5, rainStrength * 0.3);
    return albedo * lighting;
}

vec3 calculateHandLight(vec3 albedo, vec3 viewPos) {
    vec3 handLight = vec3(1.0, 0.9, 0.7);
    float handDist = length(viewPos);
    float attenuation = 1.0 / (1.0 + handDist * handDist * 0.1);
    return albedo * handLight * attenuation * 0.5;
}
