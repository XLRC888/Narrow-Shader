#version 330 compatibility

uniform sampler2D colortex0;
uniform int worldTime;

varying vec2 texcoord;

#include "/lib/common.glsl"
#include "/lib/noise.glsl"
#include "/lib/effects.glsl"

#define MOOD 0
#define VIGNETTE 0
#define VIGNETTE_STRENGTH 0.5
#define FILM_GRAIN 0
#define CHROMATIC_ABERRATION 0
#define CA_STRENGTH 0.003

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 fragColor;

void main() {
    vec3 color = texture2D(colortex0, texcoord).rgb;
    #ifdef CHROMATIC_ABERRATION
        color = applyChromaticAberration(colortex0, texcoord, CA_STRENGTH);
    #endif
    #ifdef VIGNETTE
        color = applyVignette(color, texcoord, VIGNETTE_STRENGTH);
    #endif
    #ifdef FILM_GRAIN
        float time = float(worldTime) / 24000.0;
        color = applyFilmGrain(color, texcoord, time, 0.03);
    #endif
    color = clamp(color, 0.0, 1.0);
    fragColor = vec4(color, 1.0);
}
