#version 330 compatibility

uniform sampler2D texture;

varying vec4 color;
varying vec2 texcoord;
varying vec2 lmcoord;

/* RENDERTARGETS: 0,1 */
layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 lightData;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * color;
    if (albedo.a < 0.1) discard;
    fragColor = vec4(toLinear(albedo.rgb), albedo.a);
    lightData = vec4(lmcoord, 0.0, 1.0);
}
