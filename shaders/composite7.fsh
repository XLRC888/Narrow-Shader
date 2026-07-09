#version 330 compatibility

uniform sampler2D colortex0;
uniform int worldTime;
uniform float viewWidth;
uniform float viewHeight;

varying vec2 texcoord;

#include "/lib/common.glsl"
#include "/lib/noise.glsl"
#include "/lib/effects.glsl"

#ifndef VIGNETTE
#define VIGNETTE
#endif
#ifndef VIGNETTE_STRENGTH
#define VIGNETTE_STRENGTH 0.5
#endif
#ifndef FILM_GRAIN
#define FILM_GRAIN
#endif
#ifndef CHROMATIC_ABERRATION
#define CHROMATIC_ABERRATION
#endif
#ifndef CA_STRENGTH
#define CA_STRENGTH 0.003
#endif

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
