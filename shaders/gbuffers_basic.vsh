#version 330 compatibility

varying vec4 color;
varying vec2 texcoord;

void main() {
    gl_Position = ftransform();
    gl_FogFragCoord = length((gl_ModelViewMatrix * gl_Vertex).xyz);
    color = gl_Color;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}
