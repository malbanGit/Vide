#version 120
// taken from:
// https://wiki.delphigl.com/index.php/shader_blur2

uniform sampler2D uTexture;
uniform vec2 uShift;
 
const int gaussRadius = 11;
//const float gaussFilter[gaussRadius] = float[gaussRadius](
//	0.0402,0.0623,0.0877,0.1120,0.1297,0.1362,0.1297,0.1120,0.0877,0.0623,0.0402
//);
 
void main() 
{
float gaussFilter[gaussRadius];// = float[gaussRadius](0.0402,0.0623,0.0877,0.1120,0.1297,0.1362,0.1297,0.1120,0.0877,0.0623,0.0402);

gaussFilter[0] = 0.0402;
gaussFilter[1] = 0.0623;
gaussFilter[2] = 0.0877;
gaussFilter[3] = 0.1120;
gaussFilter[4] = 0.1297;
gaussFilter[5] = 0.1362;
gaussFilter[6] = 0.1297;
gaussFilter[7] = 0.1120;
gaussFilter[8] = 0.0877;
gaussFilter[9] = 0.0623;
gaussFilter[10] = 0.0402;


	vec2 texCoord = gl_TexCoord[0].xy - float(int(gaussRadius/2)) * uShift;
	vec3 color = vec3(0.0, 0.0, 0.0); 
	for (int i=0; i<gaussRadius; ++i) { 
		color += gaussFilter[i] * texture2D(uTexture, texCoord).xyz;
		texCoord += uShift;
	}
	gl_FragColor = vec4(color,1.0);
}