#version 120

uniform float colorReduce;
uniform sampler2D uTexture;

void main() 
{
	vec2 texCoord = gl_TexCoord[0].xy;
	vec3 color = vec3(0.0, 0.0, 0.0); 
	color += colorReduce * texture2D(uTexture, texCoord).xyz;
	gl_FragColor = vec4(color,1.0);
}