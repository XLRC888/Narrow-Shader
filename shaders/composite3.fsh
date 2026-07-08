#version 330 compatibility

uniform sampler2D colortex0;
uniform float viewWidth;
uniform float viewHeight;

varying vec2 texcoord;

#include "/lib/common.glsl"
#include "/lib/bloom.glsl"

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 fragColor;

void main() {
    vec2 texelSize = 1.0 / vec2(viewWidth, viewHeight);
    vec3 color = bloomBlur13(colortex0, texcoord, texelSize, vec2(1.0, 0.0));
    fragColor = vec4(color, 1.0);
}
