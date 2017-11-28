#version 120
uniform sampler2D uTexture;
uniform float factor;

void main() 
{
	vec2 texCoord = gl_TexCoord[0].xy;
	vec3 color = texture2D(uTexture, texCoord).xyz;
	float x = (factor) * color.x;
	if (x>1.0) x = 1.0;
	float y = (factor) * color.y;
	if (y>1.0) y = 1.0;
	float z = (factor) * color.z;
	if (z>1.0) z = 1.0;
	
	gl_FragColor = vec4(x,y,z,1.0);
}