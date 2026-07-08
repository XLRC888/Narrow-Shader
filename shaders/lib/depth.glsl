float getDepth(vec2 uv) {
    return texture2D(depthtex0, uv).r;
}

float getLinearDepth(float depth) {
    return (2.0 * near) / (far + near - depth * (far - near));
}
