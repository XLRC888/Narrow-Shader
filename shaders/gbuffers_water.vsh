#version 330 compatibility

attribute vec4 at_tangent;

uniform float frameTimeCounter;
uniform mat4 gbufferModelViewInverse;

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
    float wave = sin(frameTimeCounter * 2.0 + worldPos.x * 0.5 + worldPos.z * 0.3) * 0.05;
    wave += sin(frameTimeCounter * 1.5 + worldPos.x * 0.8 + worldPos.z * 0.6) * 0.03;
    position.y += wave;
    gl_Position = gl_ProjectionMatrix * position;

    color = gl_Color;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    normal = normalize(gl_NormalMatrix * gl_Normal);
    normal = normalize(mat3(gbufferModelViewInverse) * normal);
    tangent = vec4(normalize(mat3(gbufferModelViewInverse) * (gl_NormalMatrix * at_tangent.xyz)), at_tangent.w);
}
