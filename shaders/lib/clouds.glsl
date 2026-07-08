float cloudNoise(vec2 pos, float time) {
    vec2 uv = pos * 0.002 + time * 0.02;
    float n = fbm(uv, 5);
    return n;
}

float cloudDensity(vec2 pos, float time, int quality) {
    float density = 0.0;
    if (quality == 0) {
        density = cloudNoise(pos, time);
        density = smoothstep(0.4, 0.8, density);
    } else if (quality == 1) {
        float base = cloudNoise(pos, time);
        float detail = noise2D(pos * 0.01 + time * 0.05) * 0.3;
        density = base + detail;
        density = smoothstep(0.35, 0.75, density);
    } else {
        float base = cloudNoise(pos, time);
        float detail = noise2D(pos * 0.01 + time * 0.05) * 0.25;
        float detail2 = noise2D(pos * 0.02 + time * 0.08) * 0.15;
        density = base + detail + detail2;
        float curl = curlNoise(vec3(pos * 0.005, time * 0.1)).x * 0.1;
        density += curl;
        density = smoothstep(0.3, 0.7, density);
    }
    return density;
}

vec3 getCloudLighting(float density, float dayProgress, float rainStrength) {
    vec3 sunColor = mix(vec3(1.0, 0.9, 0.7), vec3(0.6, 0.6, 0.7), rainStrength);
    vec3 ambientColor = mix(vec3(0.5, 0.6, 0.8), vec3(0.2, 0.2, 0.3), rainStrength);
    float sunFactor = smoothstep(0.2, 0.8, dayProgress) * (1.0 - smoothstep(0.2, 0.8, dayProgress - 0.5 + 1.0));
    vec3 lightColor = mix(ambientColor, sunColor, sunFactor * 0.5 + 0.3);
    float brightness = mix(0.6, 1.0, 1.0 - density);
    return lightColor * brightness;
}

vec3 renderClouds(vec3 viewDir, vec3 baseColor, float dayProgress, int quality, float time, float rainStrength) {
    if (viewDir.y < 0.0) return baseColor;
    float cloudPlane = 160.0;
    float cloudThickness = 20.0;
    if (quality == 0) cloudThickness = 8.0;
    else if (quality == 2) cloudThickness = 40.0;
    float planeDistance = (cloudPlane - cameraPosition.y) / max(viewDir.y, 0.001);
    vec3 planePos = cameraPosition + viewDir * planeDistance;
    int samples = 4;
    if (quality == 1) samples = 8;
    else if (quality == 2) samples = 16;
    float increment = cloudThickness / float(samples);
    vec3 incrementVec = viewDir * (increment / max(viewDir.y, 0.001));
    float totalDensity = 0.0;
    float totalLight = 0.0;
    vec3 currentPos = planePos;
    for (int i = 0; i < samples; i++) {
        float d = cloudDensity(currentPos.xz, time, quality);
        totalDensity += d * increment * 0.01;
        currentPos += incrementVec;
    }
    totalDensity = clamp(totalDensity, 0.0, 1.0);
    if (totalDensity < 0.01) return baseColor;
    vec3 cloudColor = getCloudLighting(totalDensity, dayProgress, rainStrength);
    float horizonBlend = smoothstep(0.0, 0.15, viewDir.y);
    float alpha = totalDensity * horizonBlend;
    return mix(baseColor, cloudColor, alpha);
}
