vec3 bloomExtract(vec3 color, float threshold) {
    float brightness = luma(color);
    float soft = brightness - threshold + 0.1;
    soft = clamp(soft, 0.0, 0.2);
    soft = soft * soft / (4.0 * 0.1 + 0.00001);
    float contribution = max(soft, brightness - threshold) / max(brightness, 0.00001);
    return color * contribution;
}

vec3 bloomBlur13(sampler2D tex, vec2 uv, vec2 texelSize, vec2 direction) {
    vec3 color = vec3(0.0);
    vec2 off1 = vec2(1.411764705882353) * direction;
    vec2 off2 = vec2(3.2941176470588234) * direction;
    vec2 off3 = vec2(5.176470588235294) * direction;
    color += texture2D(tex, uv).rgb * 0.1964825501511404;
    color += texture2D(tex, uv + off1 * texelSize).rgb * 0.2969069646728344;
    color += texture2D(tex, uv - off1 * texelSize).rgb * 0.2969069646728344;
    color += texture2D(tex, uv + off2 * texelSize).rgb * 0.09447039785044732;
    color += texture2D(tex, uv - off2 * texelSize).rgb * 0.09447039785044732;
    color += texture2D(tex, uv + off3 * texelSize).rgb * 0.010381362401148057;
    color += texture2D(tex, uv - off3 * texelSize).rgb * 0.010381362401148057;
    return color;
}

vec3 applyBloom(vec3 color, sampler2D bloomTex, vec2 uv, float strength) {
    vec2 texelSize = 1.0 / vec2(viewWidth, viewHeight);
    vec3 bloom = bloomBlur13(bloomTex, uv, texelSize, vec2(1.0, 0.0));
    bloom += bloomBlur13(bloomTex, uv, texelSize, vec2(0.0, 1.0));
    bloom *= 0.5;
    return color + bloom * strength;
}
