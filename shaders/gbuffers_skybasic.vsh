#version 330 compatibility

varying vec3 viewPos;
varying vec4 color;

void main() {
    gl_Position = ftransform();

    viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    color = gl_Color;
}
