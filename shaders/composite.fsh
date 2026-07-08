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

varying vec2 texcoord;

#include "/lib/common.glsl"
#include "/lib/noise.glsl"
#include "/lib/fog.glsl"
#include "/lib/clouds.glsl"
#include "/lib/depth.glsl"
#include "/lib/color.glsl"
#include "/lib/projection.glsl"

#define MOOD 0
#define FOG_DENSITY 0.3
#define FOG_COLOR_R 0.7
#define FOG_COLOR_G 0.75
#define FOG_COLOR_B 0.85

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 fragColor;

void main() {
    vec4 color = texture2D(colortex0, texcoord);
    float depth = getDepth(texcoord);
    vec3 viewPos = toViewSpace(vec3(texcoord, depth));
    vec3 worldPos = toWorldSpace(viewPos);
    vec3 viewDir = normalize(viewPos);
    float dayProgress = float(worldTime) / 24000.0;
    dayProgress = fract(dayProgress - 0.25);
    #ifdef VOLUMETRIC_CLOUDS
        int cloudQuality = CLOUD_QUALITY;
        color.rgb = renderClouds(viewDir, color.rgb, dayProgress, cloudQuality, frameTimeCounter, rainStrength);
    #endif
    vec3 fogColor = vec3(FOG_COLOR_R, FOG_COLOR_G, FOG_COLOR_B);
    color.rgb = applyMoodFog(color.rgb, worldPos, frameTimeCounter, MOOD, FOG_DENSITY, fogColor, dayProgress);
    fragColor = color;
}
