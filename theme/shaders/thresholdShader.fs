#version 120
uniform sampler2D uTexture;
uniform float threshold;

void main() 
{
	vec2 texCoord = gl_TexCoord[0].xy;
	vec3 color = texture2D(uTexture, texCoord).xyz;
	if (color.x < threshold)
		gl_FragColor = vec4(0,0,0,1.0);
	else
		gl_FragColor = vec4(color,1.0);
}