#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D noisetex;
uniform int worldTime;

varying vec2 texcoord;

#include "/lib/common.glsl"
#include "/lib/noise.glsl"
#include "/lib/color.glsl"
#include "/lib/grading.glsl"

#ifndef MOOD
#define MOOD 0
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

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 fragColor;

void main() {
    vec3 color = texture2D(colortex0, texcoord).rgb;
    color = applyColorGrading(color, GRADING_SATURATION, GRADING_CONTRAST, GRADING_TEMPERATURE, GRADING_TINT, GRADING_EXPOSURE, GRADING_GAMMA, MOOD);
    float time = float(worldTime) / 24000.0;
    color = applyMoodSpecific(color, MOOD, time);
    fragColor = vec4(color, 1.0);
}
