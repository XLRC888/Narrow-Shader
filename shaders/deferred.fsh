#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D noisetex;

uniform int worldTime;
uniform float rainStrength;
uniform float frameTimeCounter;
uniform vec3 sunPosition;
uniform vec3 cameraPosition;

varying vec2 texcoord;

#include "/lib/common.glsl"
#include "/lib/depth.glsl"
#include "/lib/lighting.glsl"
#include "/lib/shadow.glsl"
#include "/lib/projection.glsl"

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 fragColor;

void main() {
    vec4 color = texture2D(colortex0, texcoord);
    vec4 lightData = texture2D(colortex1, texcoord);
    vec4 encodedNormal = texture2D(colortex2, texcoord);
    float depth = getDepth(texcoord);
    vec3 normal = normalize(encodedNormal.rgb * 2.0 - 1.0);
    vec3 viewPos = toViewSpace(vec3(texcoord, depth));
    vec3 worldPos = toWorldSpace(viewPos);
    float dayProgress = float(worldTime) / 24000.0;
    dayProgress = fract(dayProgress - 0.25);
    if (depth < 1.0) {
        vec3 blockLight = vec3(1.0, 0.85, 0.6) * lightData.x * lightData.x;
        vec3 skyLight = getSkyLightColor(lightData.y, dayProgress);
        float ndotl = max(dot(normal, normalize(sunPosition)), 0.0);
        float diffuse = ndotl * 0.5 + 0.5;
        diffuse = mix(diffuse, 0.5, rainStrength * 0.5);
        vec3 lighting = blockLight + skyLight * diffuse;
        lighting = mix(lighting, lighting * 0.5, rainStrength * 0.3);
        vec3 albedo = toLinear(color.rgb);
        vec3 lit = albedo * lighting;
        float shadow = 1.0;
        #ifdef SHADOW_QUALITY
            shadow = getShadow(viewPos, normal);
        #endif
        lit *= shadow;
        lit = toSRGB(lit);
        color.rgb = lit;
    }
    fragColor = color;
}
