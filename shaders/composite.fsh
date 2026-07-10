#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D depthtex0;
uniform sampler2D noisetex;

uniform int worldTime;
uniform float rainStrength;
uniform float frameTimeCounter;
uniform vec3 sunPosition;
uniform vec3 cameraPosition;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

varying vec2 texcoord;

#include "/lib/common.glsl"
#include "/lib/noise.glsl"
#include "/lib/fog.glsl"
#include "/lib/clouds.glsl"
#include "/lib/color.glsl"
#include "/lib/projection.glsl"
#include "/lib/aurora.glsl"

#ifndef MOOD
#define MOOD 0
#endif
#ifndef FOG_DENSITY
#define FOG_DENSITY 0.3
#endif
#ifndef FOG_COLOR_R
#define FOG_COLOR_R 0.7
#endif
#ifndef FOG_COLOR_G
#define FOG_COLOR_G 0.75
#endif
#ifndef FOG_COLOR_B
#define FOG_COLOR_B 0.85
#endif
#ifndef VOLUMETRIC_CLOUDS
#define VOLUMETRIC_CLOUDS
#endif
#ifndef CLOUD_QUALITY
#define CLOUD_QUALITY 1
#endif
#ifndef AURORA_STRENGTH
#define AURORA_STRENGTH 0.8
#endif
#ifndef AURORA_HEIGHT
#define AURORA_HEIGHT 0.45
#endif

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 fragColor;

void main() {
    vec4 color = texture2D(colortex0, texcoord);
    float depth = texture2D(depthtex0, texcoord).r;
    vec3 viewPos = toViewSpace(vec3(texcoord, depth));
    vec3 worldPos = toWorldSpace(viewPos);
    vec3 viewDir = normalize(viewPos);
    float dayProgress = float(worldTime) / 24000.0;
    dayProgress = fract(dayProgress - 0.25);
    #ifdef VOLUMETRIC_CLOUDS
        int cloudQuality = CLOUD_QUALITY;
        color.rgb = renderClouds(viewDir, color.rgb, dayProgress, cloudQuality, frameTimeCounter, rainStrength);
    #endif
    if (depth >= 1.0 && AURORA_STRENGTH > 0.0) {
        float nightFactor = 1.0 - smoothstep(0.2, 0.3, dayProgress) + smoothstep(0.7, 0.8, dayProgress);
        nightFactor = clamp(nightFactor, 0.0, 1.0);
        nightFactor *= 1.0 - rainStrength;
        if (nightFactor > 0.01) {
            vec3 aurora = getAurora(worldPos, frameTimeCounter, AURORA_STRENGTH * nightFactor, AURORA_HEIGHT, 1);
            color.rgb += aurora;
        }
    }
    vec3 fogColor = vec3(FOG_COLOR_R, FOG_COLOR_G, FOG_COLOR_B);
    color.rgb = applyMoodFog(color.rgb, worldPos, frameTimeCounter, MOOD, FOG_DENSITY, fogColor, dayProgress);
    fragColor = color;
}
