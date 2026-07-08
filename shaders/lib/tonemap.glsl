vec3 tonemapReinhard(vec3 color) {
    return color / (color + vec3(1.0));
}

vec3 tonemapACES(vec3 color) {
    color *= 1.1;
    vec3 x = max(vec3(0.0), color - 0.004);
    return (x * (6.2 * x + 0.5)) / (x * (6.2 * x + 1.7) + 0.06);
}

vec3 tonemapACESApprox(vec3 color) {
    color *= 1.05;
    color = color * (2.51 * color + 0.03) / (color * (2.43 * color + 0.59) + 0.14);
    return clamp(color, 0.0, 1.0);
}

vec3 tonemapFilmic(vec3 color) {
    vec3 x = max(vec3(0.0), color - 0.004);
    return (x * (6.2 * x + 0.5)) / (x * (6.2 * x + 1.7) + 0.06);
}

vec3 tonemapLottes(vec3 color) {
    vec3 a = vec3(1.6);
    vec3 d = vec3(0.977);
    vec3 hdrMax = vec3(8.0);
    vec3 midIn = vec3(0.18);
    vec3 midOut = vec3(0.267);
    vec3 b = (-pow(midIn, a) * hdrMax + pow(midIn, a * d) * hdrMax + pow(midIn, a) * midOut - pow(midIn, a * d) * midOut) / ((pow(midIn, a * d) - pow(midIn, a)) * hdrMax);
    vec3 c = (pow(midIn, a * d) * midOut - pow(midIn, a) * midOut * d + pow(midIn, a) * hdrMax * d - pow(midIn, a * d) * hdrMax * d) / ((pow(midIn, a * d) - pow(midIn, a)) * hdrMax);
    return pow(color, a) / (pow(color, a * d) * b + c);
}

vec3 gammaCorrect(vec3 color) {
    return pow(color, vec3(1.0 / 2.2));
}
