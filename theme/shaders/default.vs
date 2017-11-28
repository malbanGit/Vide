#version 110

attribute vec3 inColor;
attribute vec2 inPosition;

varying vec3 color;

void main()
{
//    gl_Position = vec4(inPosition, 1.0);
    gl_Position = vec4(inPosition,0.0, 1.0);
	color = inColor;
//	color = vec3(0.0,0.0, 1.0);
}