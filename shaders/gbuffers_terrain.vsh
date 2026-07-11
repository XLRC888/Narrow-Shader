#version 330 compatibility

#ifndef SHADOW_DIST
#define SHADOW_DIST 1
#endif
#ifndef REFLECTIONS
#define REFLECTIONS 1
#endif
#ifndef TAA
#define TAA 1
#endif
#ifndef MOOD
#define MOOD 0
#endif
#ifndef CLOUD_QUALITY
#define CLOUD_QUALITY 1
#endif
#ifndef FOG_DENSITY
#define FOG_DENSITY 0.3
#endif
#ifndef FOG_START
#define FOG_START 32.0
#endif
#ifndef FOG_END
#define FOG_END 256.0
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
#ifndef FOG_NOISE
#define FOG_NOISE 0.0
#endif
#ifndef GRADING_SATURATION
#define GRADING_SATURATION 1.0
#endif
#ifndef GRADING_CONTRAST
#define GRADING_CONTRAST 1.0
#endif
#ifndef GRADING_TEMPERATURE
#define GRADING_TEMPERATURE 0.0
#endif
#ifndef GRADING_TINT
#define GRADING_TINT 0.0
#endif
#ifndef GRADING_EXPOSURE
#define GRADING_EXPOSURE 0.0
#endif
#ifndef GRADING_GAMMA
#define GRADING_GAMMA 1.0
#endif
#ifndef VIGNETTE_STRENGTH
#define VIGNETTE_STRENGTH 0.5
#endif
#ifndef CA_STRENGTH
#define CA_STRENGTH 0.003
#endif
#ifndef DOF_STRENGTH
#define DOF_STRENGTH 1.0
#endif
#ifndef MOTION_BLUR_SAMPLES
#define MOTION_BLUR_SAMPLES 4
#endif
#ifndef WATER_COLOR_R
#define WATER_COLOR_R 0.0
#endif
#ifndef WATER_COLOR_G
#define WATER_COLOR_G 0.3
#endif
#ifndef WATER_COLOR_B
#define WATER_COLOR_B 0.6
#endif
#ifndef WATER_OPACITY
#define WATER_OPACITY 0.85
#endif
#ifndef WATER_REFLECTIVITY
#define WATER_REFLECTIVITY 0.5
#endif
#ifndef CLOUD_OPACITY
#define CLOUD_OPACITY 1.0
#endif
#ifndef CLOUD_SPEED
#define CLOUD_SPEED 1.0
#endif
#ifndef CLOUD_COVERAGE
#define CLOUD_COVERAGE 0.5
#endif
#ifndef CLOUD_DETAIL
#define CLOUD_DETAIL 1.0
#endif
#ifndef CLOUD_HEIGHT
#define CLOUD_HEIGHT 160.0
#endif

attribute vec4 mc_Entity;
attribute vec4 at_tangent;

uniform float frameTimeCounter;
uniform float rainStrength;
uniform mat4 gbufferModelViewInverse;
uniform sampler2D noisetex;

varying vec4 color;
varying vec2 texcoord;
varying vec2 lmcoord;
varying vec3 normal;
varying vec3 viewPos;
varying vec3 worldPos;
varying vec4 tangent;

void main() {
    vec4 position = gl_ModelViewMatrix * gl_Vertex;
    viewPos = position.xyz;
    vec4 worldPos4 = gbufferModelViewInverse * position;
    worldPos = worldPos4.xyz;

    #ifdef WAVE_FOLIAGE
        float blockId = mc_Entity.x;
        if (blockId == 31.0 || blockId == 37.0 || blockId == 38.0 || blockId == 59.0 || blockId == 175.0) {
            float wind = sin(frameTimeCounter * 1.5 + worldPos.x * 0.5 + worldPos.z * 0.3) * 0.08;
            wind += sin(frameTimeCounter * 2.0 + worldPos.x * 0.8) * 0.04;
            wind *= 1.0 + rainStrength * 0.5;
            position.y += wind;
        }
        if (blockId == 18.0 || blockId == 161.0) {
            float leaf = sin(frameTimeCounter * 2.0 + worldPos.x * 0.3 + worldPos.z * 0.4) * 0.03;
            leaf += sin(frameTimeCounter * 3.0 + worldPos.y * 0.5) * 0.02;
            leaf *= 1.0 + rainStrength * 0.3;
            position.x += leaf;
            position.z += leaf * 0.5;
        }
    #endif

    gl_Position = gl_ProjectionMatrix * position;
    color = gl_Color;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    normal = normalize(gl_NormalMatrix * gl_Normal);
    normal = normalize(mat3(gbufferModelViewInverse) * normal);
    tangent = vec4(normalize(mat3(gbufferModelViewInverse) * (gl_NormalMatrix * at_tangent.xyz)), at_tangent.w);
}
