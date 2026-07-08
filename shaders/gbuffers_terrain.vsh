#version 330 compatibility

#define SHADOW_QUALITY
#define SHADOW_DIST 1
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
#define VOLUMETRIC_CLOUDS
#define CLOUD_QUALITY 1
#define FOG_DENSITY 0.3
#define FOG_START 32.0
#define FOG_END 256.0
#define FOG_COLOR_R 0.7
#define FOG_COLOR_G 0.75
#define FOG_COLOR_B 0.85
#define FOG_NOISE 0.0
#define GRADING_SATURATION 1.0
#define GRADING_CONTRAST 1.0
#define GRADING_TEMPERATURE 0.0
#define GRADING_TINT 0.0
#define GRADING_EXPOSURE 0.0
#define GRADING_GAMMA 1.0
#define VIGNETTE_STRENGTH 0.5
#define CA_STRENGTH 0.003
#define DOF_STRENGTH 1.0
#define MOTION_BLUR
#define MOTION_BLUR_SAMPLES 4
#define WATER_COLOR_R 0.0
#define WATER_COLOR_G 0.3
#define WATER_COLOR_B 0.6
#define WATER_OPACITY 0.85
#define WATER_REFLECTIVITY 0.5
#define CLOUD_OPACITY 1.0
#define CLOUD_SPEED 1.0
#define CLOUD_COVERAGE 0.5
#define CLOUD_DETAIL 1.0
#define CLOUD_HEIGHT 160.0

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
    gl_FogFragCoord = length(position.xyz);
    color = gl_Color;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    normal = normalize(gl_NormalMatrix * gl_Normal);
    normal = normalize(mat3(gbufferModelViewInverse) * normal);
    tangent = vec4(normalize(mat3(gbufferModelViewInverse) * (gl_NormalMatrix * at_tangent.xyz)), at_tangent.w);
}
