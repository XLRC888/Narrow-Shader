#define PI 3.141592653589793
#define TAU 6.283185307179586

vec3 toLinear(vec3 srgb) {
    return mix(srgb / 12.92, pow(max((srgb + 0.055) / 1.055, vec3(0.0)), vec3(2.4)), step(0.04045, srgb));
}

vec3 toSRGB(vec3 linear) {
    return mix(linear * 12.92, 1.055 * pow(max(linear, vec3(0.0)), vec3(1.0 / 2.4)) - 0.055, step(0.0031308, linear));
}

float luma(vec3 color) {
    return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

vec3 blendScreen(vec3 base, vec3 blend) {
    return 1.0 - (1.0 - base) * (1.0 - blend);
}

vec3 blendOverlay(vec3 base, vec3 blend) {
    return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), step(0.5, base));
}

float remap(float value, float oldMin, float oldMax, float newMin, float newMax) {
    return newMin + (value - oldMin) / (oldMax - oldMin) * (newMax - newMin);
}

float inverseLerp(float a, float b, float value) {
    return clamp((value - a) / (b - a), 0.0, 1.0);
}
