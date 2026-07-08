vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 adjustSaturation(vec3 color, float amount) {
    float lum = luma(color);
    return mix(vec3(lum), color, amount);
}

vec3 adjustContrast(vec3 color, float amount) {
    return clamp((color - 0.5) * amount + 0.5, 0.0, 1.0);
}

vec3 adjustTemperature(vec3 color, float temp) {
    float t = temp / 100.0;
    color.r += t * 0.1;
    color.b -= t * 0.1;
    return clamp(color, 0.0, 1.0);
}

vec3 adjustTint(vec3 color, float tint) {
    float t = tint / 100.0;
    color.g += t * 0.1;
    return clamp(color, 0.0, 1.0);
}

vec3 adjustExposure(vec3 color, float exposure) {
    return color * pow(2.0, exposure);
}

vec3 adjustGamma(vec3 color, float gamma) {
    return pow(max(color, vec3(0.0)), vec3(1.0 / gamma));
}

vec3 brightness(vec3 color, float amount) {
    return color + amount;
}

vec3 contrastBrightness(vec3 color, float contrast, float brightness) {
    color = (color - 0.5) * contrast + 0.5;
    color += brightness;
    return clamp(color, 0.0, 1.0);
}
