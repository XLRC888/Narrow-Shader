#version 330 compatibility

uniform sampler2D colortex0;

varying vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 fragColor;

void main() {
    fragColor = texture2D(colortex0, texcoord);
}
