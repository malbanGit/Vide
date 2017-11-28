#version 120

uniform sampler2D uTexture;
uniform vec2 uShift;
uniform float spillThreshold; 
 
 
void main() 
{
	vec2 shift0 = vec2(0,0);

	vec2 shift1 = vec2(-uShift.x,-uShift.y);
	vec2 shift2 = vec2(-uShift.x,0);
	vec2 shift3 = vec2(-uShift.x,+uShift.y);

	vec2 shift4 = vec2(+uShift.x,-uShift.y);
	vec2 shift5 = vec2(+uShift.x,0);
	vec2 shift6 = vec2(+uShift.x,+uShift.y);

	vec2 shift7 = vec2(0,-uShift.y);
	vec2 shift8 = vec2(0,+uShift.y);
	
	
	vec2 texCoord = gl_TexCoord[0].xy;
	vec3 color = texture2D(uTexture, texCoord).xyz;
	// if own color > threshold, reduce to threshold

	float x = color.x;
	float y = color.y;
	float z = color.z;
	if (color.x>spillThreshold) x = spillThreshold;
	if (color.y>spillThreshold) y = spillThreshold;
	if (color.z>spillThreshold) z = spillThreshold;


	color = vec3(x,y,z);

	// get colors from surrounding
	// DIRECTs 15%
	float var=0;
	vec3 testColor = texture2D(uTexture, texCoord+shift2).xyz;
	if (testColor.x> spillThreshold) color.x+= (testColor.x-spillThreshold)*0.15f;
	if (testColor.y> spillThreshold) color.y+= (testColor.y-spillThreshold)*0.15f;
	if (testColor.z> spillThreshold) color.z+= (testColor.z-spillThreshold)*0.15f;

	testColor = texture2D(uTexture, texCoord+shift5).xyz;
	if (testColor.x> spillThreshold) color.x+= (testColor.x-spillThreshold)*0.15f;
	if (testColor.y> spillThreshold) color.y+= (testColor.y-spillThreshold)*0.15f;
	if (testColor.z> spillThreshold) color.z+= (testColor.z-spillThreshold)*0.15f;

	testColor = texture2D(uTexture, texCoord+shift7).xyz;
	if (testColor.x> spillThreshold) color.x+= (testColor.x-spillThreshold)*0.15f;
	if (testColor.y> spillThreshold) color.y+= (testColor.y-spillThreshold)*0.15f;
	if (testColor.z> spillThreshold) color.z+= (testColor.z-spillThreshold)*0.15f;

	testColor = texture2D(uTexture, texCoord+shift8).xyz;
	if (testColor.x> spillThreshold) color.x+= (testColor.x-spillThreshold)*0.15f;
	if (testColor.y> spillThreshold) color.y+= (testColor.y-spillThreshold)*0.15f;
	if (testColor.z> spillThreshold) color.z+= (testColor.z-spillThreshold)*0.15f;
	
	// DIAGONALSs 10%
    	testColor = texture2D(uTexture, texCoord+shift1).xyz;
	if (testColor.x> spillThreshold) color.x+= (testColor.x-spillThreshold)*0.10f;
	if (testColor.y> spillThreshold) color.y+= (testColor.y-spillThreshold)*0.10f;
	if (testColor.z> spillThreshold) color.z+= (testColor.z-spillThreshold)*0.10f;

	testColor = texture2D(uTexture, texCoord+shift3).xyz;
	if (testColor.x> spillThreshold) color.x+= (testColor.x-spillThreshold)*0.10f;
	if (testColor.y> spillThreshold) color.y+= (testColor.y-spillThreshold)*0.10f;
	if (testColor.z> spillThreshold) color.z+= (testColor.z-spillThreshold)*0.10f;

	testColor = texture2D(uTexture, texCoord+shift4).xyz;
	if (testColor.x> spillThreshold) color.x+= (testColor.x-spillThreshold)*0.10f;
	if (testColor.y> spillThreshold) color.y+= (testColor.y-spillThreshold)*0.10f;
	if (testColor.z> spillThreshold) color.z+= (testColor.z-spillThreshold)*0.10f;

	testColor = texture2D(uTexture, texCoord+shift6).xyz;
	if (testColor.x> spillThreshold) color.x+= (testColor.x-spillThreshold)*0.10f;
	if (testColor.y> spillThreshold) color.y+= (testColor.y-spillThreshold)*0.10f;
	if (testColor.z> spillThreshold) color.z+= (testColor.z-spillThreshold)*0.10f;
	
	gl_FragColor = vec4(color,1.0);
}