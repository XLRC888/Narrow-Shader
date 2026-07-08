#version 330 compatibility

#define SHADOW_QUALITY
#define SHADOW_DIST 1
#define VOLUMETRIC_CLOUDS
#define CLOUD_QUALITY 1
#define WAVE_FOLIAGE
#define REFLECTIONS 1
#define SSAO
#define BLOOM
#define DOF
#define CHROMATIC_ABERRATION
#define TAA 1
#define VIGNETTE
#define FILM_GRAIN
#define MOOD 0
#define FOG_DENSITY 0.3
#define FOG_COLOR_R 0.7
#define FOG_COLOR_G 0.75
#define FOG_COLOR_B 0.85
#define GRADING_SATURATION 1.0
#define GRADING_CONTRAST 1.0
#define GRADING_TEMPERATURE 0.0
#define GRADING_TINT 0.0
#define GRADING_EXPOSURE 0.0
#define GRADING_GAMMA 1.0
#define VIGNETTE_STRENGTH 0.5
#define CA_STRENGTH 0.003
#define shadowMapResolution 2048
#define shadowDistance 64.0

uniform sampler2D texture;
uniform sampler2D lightmap;
uniform sampler2D noisetex;

uniform int worldTime;
uniform float rainStrength;
uniform vec3 sunPosition;

varying vec4 color;
varying vec2 texcoord;
varying vec2 lmcoord;
varying vec3 normal;
varying vec3 viewPos;
varying vec3 worldPos;
varying vec4 tangent;

#include "/lib/common.glsl"
#include "/lib/lighting.glsl"

/* RENDERTARGETS: 0,1,2 */
layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 lightData;
layout(location = 2) out vec4 encodedNormal;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * color;
    if (albedo.a < 0.1) discard;
    albedo.rgb = toLinear(albedo.rgb);
    float dayProgress = float(worldTime) / 24000.0;
    dayProgress = fract(dayProgress - 0.25);
    vec3 litColor = calculateLighting(albedo.rgb, normal, viewPos, lmcoord, dayProgress, rainStrength);
    float shadow = 1.0;
    #ifdef SHADOW_QUALITY
        shadow = getShadow(viewPos, normal);
    #endif
    litColor *= shadow;
    litColor = toSRGB(litColor);
    fragColor = vec4(litColor, albedo.a);
    lightData = vec4(lmcoord, 0.0, 1.0);
    encodedNormal = vec4(normal * 0.5 + 0.5, 1.0);
}
