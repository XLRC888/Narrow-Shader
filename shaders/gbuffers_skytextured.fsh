#version 330 compatibility

uniform sampler2D texture;

varying vec2 texcoord;
varying vec4 color;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 fragColor;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * color;
    fragColor = albedo;
}
