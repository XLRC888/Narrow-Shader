vec3 applyColorGrading(vec3 color, float saturation, float contrast, float temperature, float tint, float exposure, float gamma, int mood) {
    color = adjustExposure(color, exposure);
    color = adjustSaturation(color, saturation);
    color = adjustContrast(color, contrast);
    color = adjustTemperature(color, temperature);
    color = adjustTint(color, tint);
    color = adjustGamma(color, gamma);
    if (mood == 1) {
        color = mix(vec3(luma(color)), color, 0.2);
        color *= vec3(0.9, 0.95, 1.1);
        color = pow(color, vec3(1.3));
    } else if (mood == 2) {
        color = mix(vec3(luma(color)), color, 1.3);
        color *= vec3(1.1, 1.0, 0.95);
        color = pow(color, vec3(0.95));
    } else if (mood == 3) {
        color = mix(vec3(luma(color)), color, 1.2);
        color *= vec3(1.05, 1.0, 0.95);
        color = pow(color, vec3(0.9));
    } else if (mood == 4) {
        color = mix(vec3(luma(color)), color, 0.4);
        color *= vec3(0.95, 0.95, 1.0);
        color = pow(color, vec3(1.1));
    } else if (mood == 5) {
        color = mix(vec3(luma(color)), color, 0.9);
        color *= vec3(1.0, 1.02, 1.05);
    } else if (mood == 6) {
        float lum = luma(color);
        color = vec3(lum);
        color = (color - 0.5) * 1.4 + 0.5;
        color = clamp(color, 0.0, 1.0);
    } else if (mood == 7) {
        color *= vec3(1.2, 0.9, 1.1);
        color = pow(color, vec3(1.2));
        color.r *= 1.1;
        color.b *= 1.15;
    }
    return clamp(color, 0.0, 1.0);
}

vec3 applyMoodSpecific(vec3 color, int mood, float time) {
    if (mood == 1) {
        float flicker = 1.0 - hash(vec2(floor(time * 10.0), 0.0)) * 0.05;
        color *= flicker;
    } else if (mood == 7) {
        float pulse = sin(time * 2.0) * 0.05 + 0.95;
        color.r *= pulse;
        color.b *= (2.0 - pulse);
    }
    return color;
}
