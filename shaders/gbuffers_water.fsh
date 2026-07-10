#version 330 compatibility

uniform sampler2D texture;
uniform sampler2D lightmap;
uniform sampler2D noisetex;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D depthtex0;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 cameraPosition;
uniform float viewWidth;
uniform float viewHeight;

uniform int worldTime;
uniform float rainStrength;
uniform vec3 sunPosition;
uniform mat4 gbufferModelViewInverse;

varying vec4 color;
varying vec2 texcoord;
varying vec2 lmcoord;
varying vec3 normal;
varying vec3 viewPos;
varying vec3 worldPos;
varying vec4 tangent;

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

#include "/lib/common.glsl"
#include "/lib/lighting.glsl"
#include "/lib/shadow.glsl"

/* RENDERTARGETS: 0,1,2 */
layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 lightData;
layout(location = 2) out vec4 encodedNormal;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * color;
    albedo.rgb = toLinear(albedo.rgb);
    float dayProgress = float(worldTime) / 24000.0;
    dayProgress = fract(dayProgress - 0.25);
    float waterDepth = texture2D(depthtex0, gl_FragCoord.xy / vec2(viewWidth, viewHeight)).r;
    float nearVal = gl_ProjectionMatrix[3][2] / (gl_ProjectionMatrix[2][2] - 1.0);
    float farVal = gl_ProjectionMatrix[3][2] / (gl_ProjectionMatrix[2][2] + 1.0);
    waterDepth = (2.0 * nearVal) / (farVal + nearVal - waterDepth * (farVal - nearVal));
    vec3 waterColor = vec3(WATER_COLOR_R, WATER_COLOR_G, WATER_COLOR_B);
    waterColor = toLinear(waterColor);
    float absorption = exp(-waterDepth * 3.0);
    albedo.rgb = mix(waterColor, albedo.rgb, absorption * WATER_OPACITY);
    vec3 litColor = calculateLighting(albedo.rgb, normal, viewPos, lmcoord, dayProgress, rainStrength);
    float shadow = 1.0;
    #ifdef SHADOW_QUALITY
        shadow = getShadow(viewPos, normal);
    #endif
    litColor *= shadow;
    vec3 reflectDir = reflect(normalize(viewPos), normal);
    vec3 reflectWorld = normalize(mat3(gbufferModelViewInverse) * reflectDir);
    float skyReflect = max(reflectWorld.y, 0.0);
    vec3 skyColor = getSkyLightColor(1.0, dayProgress);
    litColor += skyColor * skyReflect * WATER_REFLECTIVITY * 0.3;
    litColor = toSRGB(litColor);
    fragColor = vec4(litColor, albedo.a * 0.8);
    lightData = vec4(lmcoord, 0.0, 1.0);
    encodedNormal = vec4(normal * 0.5 + 0.5, 1.0);
}
