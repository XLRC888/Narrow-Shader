#version 330 compatibility

uniform sampler2D colortex0;

varying vec2 texcoord;

#include "/lib/common.glsl"
#include "/lib/bloom.glsl"

/* RENDERTARGETS: 5 */
layout(location = 0) out vec4 fragColor;

void main() {
    vec3 color = texture2D(colortex0, texcoord).rgb;
    color = bloomExtract(color, 1.0);
    fragColor = vec4(color, 1.0);
}
