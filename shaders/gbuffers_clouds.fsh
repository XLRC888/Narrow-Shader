#version 330 compatibility

uniform sampler2D texture;

varying vec4 color;
varying vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 fragColor;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * color;
    if (albedo.a < 0.01) discard;
    fragColor = albedo;
}
