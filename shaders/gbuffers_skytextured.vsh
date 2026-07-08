#version 330 compatibility

varying vec2 texcoord;
varying vec4 color;

void main() {
    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    color = gl_Color;
}
