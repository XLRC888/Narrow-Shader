#version 330 compatibility

varying vec4 color;
varying vec2 texcoord;

void main() {
    gl_FragData[0] = color;
}
