#version 330 compatibility

uniform sampler2D texture;

varying vec4 color;
varying vec2 texcoord;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * color;
    if (albedo.a < 0.1) discard;
    gl_FragData[0] = albedo;
}
