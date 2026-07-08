#version 330 compatibility

varying vec4 color;
varying vec2 texcoord;
varying vec2 lmcoord;
varying vec3 normal;
varying vec3 viewPos;
varying vec3 worldPos;
varying vec4 tangent;

void main() {
    gl_Position = ftransform();
    gl_FogFragCoord = length((gl_ModelViewMatrix * gl_Vertex).xyz);
    viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    vec4 worldPos4 = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
    worldPos = worldPos4.xyz;
    color = gl_Color;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    normal = normalize(gl_NormalMatrix * gl_Normal);
    tangent = vec4(normalize(mat3(gbufferModelViewInverse) * (gl_NormalMatrix * at_tangent.xyz)), at_tangent.w);
}
