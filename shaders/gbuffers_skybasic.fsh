#version 330 compatibility

varying vec3 viewPos;
varying vec4 color;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 fragColor;

void main() {
    fragColor = color;
}
