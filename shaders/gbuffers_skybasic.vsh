#version 330 compatibility

varying vec3 viewPos;
varying vec4 color;

void main() {
    gl_Position = ftransform();
    gl_FogFragCoord = length((gl_ModelViewMatrix * gl_Vertex).xyz);
    viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    color = gl_Color;
}
