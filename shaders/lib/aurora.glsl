vec3 auroraColor(float t, float time) {
    vec3 green = vec3(0.1, 0.8, 0.3);
    vec3 teal = vec3(0.1, 0.7, 0.6);
    vec3 purple = vec3(0.5, 0.1, 0.8);
    vec3 pink = vec3(0.8, 0.1, 0.5);
    float wave = sin(t * 3.0 + time * 0.3) * 0.5 + 0.5;
    float wave2 = sin(t * 5.0 - time * 0.2) * 0.5 + 0.5;
    vec3 c1 = mix(green, teal, wave);
    vec3 c2 = mix(purple, pink, wave2);
    return mix(c1, c2, sin(t * 2.0 + time * 0.1) * 0.5 + 0.5);
}

float auroraBand(vec2 pos, float time, float height) {
    float y = pos.y;
    float curtain = sin(pos.x * 8.0 + time * 0.5 + noise2D(pos * 3.0 + time * 0.1) * 2.0) * 0.5 + 0.5;
    curtain *= sin(pos.x * 12.0 - time * 0.3 + noise2D(pos * 5.0 + time * 0.15) * 1.5) * 0.5 + 0.5;
    float band = smoothstep(height - 0.15, height, y) * smoothstep(height + 0.15, height, y);
    float detail = fbm(pos * 10.0 + vec2(time * 0.1, 0.0), 4);
    float ribbon = smoothstep(0.3, 0.7, detail) * curtain;
    return band * ribbon;
}

vec3 getAurora(vec3 playerPos, float time, float strength, float height, int everyworld) {
    if (playerPos.y < -10.0) return vec3(0.0);
    vec2 pos = playerPos.xz * 0.002;
    pos.y += playerPos.y * 0.005;
    float scroll = time * 0.02;
    float band1 = auroraBand(pos + vec2(scroll, 0.0), time, height);
    float band2 = auroraBand(pos * 1.3 + vec2(scroll * 0.7, 0.5), time, height + 0.05);
    float band3 = auroraBand(pos * 0.8 + vec2(scroll * 1.2, 1.0), time, height - 0.03);
    float total = max(max(band1, band2), band3);
    if (total < 0.01) return vec3(0.0);
    float t = pos.x * 2.0 + time * 0.1;
    vec3 col = auroraColor(t, time);
    float flicker = 0.9 + 0.1 * sin(time * 3.0 + pos.x * 10.0);
    total *= flicker * strength;
    total *= smoothstep(-0.1, 0.3, playerPos.y * 0.01 + 0.5);
    return col * total;
}
