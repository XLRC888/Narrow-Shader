#version 330 compatibility

uniform sampler2D colortex5;
uniform float viewWidth;
uniform float viewHeight;

varying vec2 texcoord;

#include "/lib/common.glsl"
#include "/lib/bloom.glsl"

/* RENDERTARGETS: 5 */
layout(location = 0) out vec4 fragColor;

void main() {
    vec2 texelSize = 1.0 / vec2(viewWidth, viewHeight);
    vec3 color = bloomBlur13(colortex5, texcoord, texelSize, vec2(0.0, 1.0));
    fragColor = vec4(color, 1.0);
}
