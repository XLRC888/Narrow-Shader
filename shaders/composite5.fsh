#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D colortex5;

varying vec2 texcoord;

#include "/lib/common.glsl"
#include "/lib/tonemap.glsl"
#include "/lib/bloom.glsl"

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 fragColor;

void main() {
    vec3 color = texture2D(colortex0, texcoord).rgb;
    color = applyBloom(color, colortex5, texcoord, 0.5);
    color = tonemapACES(color);
    color = gammaCorrect(color);
    color = toSRGB(color);
    fragColor = vec4(color, 1.0);
}
