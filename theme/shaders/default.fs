#version 110

varying vec3 color;

//varying vec4 outColor;

void main()
{
gl_FragColor = vec4(color.x, color.y, color.z, 1.0);
//    outColor = vec4(color.x, color.y, color.z, 1.0);
}