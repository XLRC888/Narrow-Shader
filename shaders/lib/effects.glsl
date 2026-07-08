vec3 applyVignette(vec3 color, vec2 uv, float strength) {
    vec2 center = uv - 0.5;
    float dist = length(center);
    float vignette = smoothstep(0.4, 1.0, dist);
    return color * (1.0 - vignette * strength);
}

vec3 applyFilmGrain(vec3 color, vec2 uv, float time, float strength) {
    vec2 noiseUV = uv * vec2(viewWidth, viewHeight) * 0.5;
    float noise = hash(noiseUV + fract(time * 123.456));
    noise = (noise - 0.5) * strength;
    return color + noise;
}

vec3 applyChromaticAberration(sampler2D tex, vec2 uv, float strength) {
    vec2 center = uv - 0.5;
    float dist = length(center);
    vec2 offset = center * dist * strength;
    float r = texture2D(tex, uv + offset).r;
    float g = texture2D(tex, uv).g;
    float b = texture2D(tex, uv - offset).b;
    return vec3(r, g, b);
}

vec3 applyMotionBlur(sampler2D tex, vec2 uv, vec2 velocity, float strength) {
    vec3 color = vec3(0.0);
    float totalWeight = 0.0;
    const int SAMPLES = 8;
    for (int i = 0; i < SAMPLES; i++) {
        float t = float(i) / float(SAMPLES - 1) - 0.5;
        vec2 offset = velocity * t * strength;
        float weight = 1.0 - abs(t) * 2.0;
        weight = max(weight, 0.0);
        color += texture2D(tex, uv + offset).rgb * weight;
        totalWeight += weight;
    }
    return color / totalWeight;
}
