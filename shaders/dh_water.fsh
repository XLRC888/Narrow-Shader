#version 330 compatibility

uniform sampler2D texture;
uniform sampler2D lightmap;
uniform int worldTime;
uniform float rainStrength;

varying vec4 color;
varying vec2 texcoord;
varying vec2 lmcoord;
varying vec3 normal;
varying vec3 viewPos;

#include "/lib/common.glsl"
#include "/lib/lighting.glsl"

/* RENDERTARGETS: 0,1,2 */
layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 lightData;
layout(location = 2) out vec4 encodedNormal;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * color;
    albedo.rgb = toLinear(albedo.rgb);
    float dayProgress = float(worldTime) / 24000.0;
    dayProgress = fract(dayProgress - 0.25);
    vec3 litColor = calculateLighting(albedo.rgb, normal, viewPos, lmcoord, dayProgress, rainStrength);
    litColor = toSRGB(litColor);
    fragColor = vec4(litColor, albedo.a * 0.7);
    lightData = vec4(lmcoord, 0.0, 1.0);
    encodedNormal = vec4(normal * 0.5 + 0.5, 1.0);
}
