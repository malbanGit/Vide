#version 120

uniform sampler2D screenTexture;
uniform float screenBrightnessAdjust; 
 
void main() 
{
 vec2 coord = gl_TexCoord[0].xy;
 vec4 screenColor = texture2D(screenTexture, coord).xyzw;
 gl_FragColor = vec4(screenColor.x*screenBrightnessAdjust,screenColor.y*screenBrightnessAdjust,screenColor.z*screenBrightnessAdjust,screenColor.w);

}