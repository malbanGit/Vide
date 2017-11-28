#version 120

uniform sampler2D overlayTexture;
uniform sampler2D destinationTexture;
uniform float overlayAlphaAdjust; 
uniform float destinationAlphaAdjust; 
uniform float alphaThreshold; 
 
void main() 
{
	vec2 coord = gl_TexCoord[0].xy;
	vec2 flippedCoord = vec2(coord.x, -coord.y); 
	vec4 destColor = texture2D(destinationTexture, flippedCoord).xyzw;
	vec4 overlayColor = texture2D(overlayTexture, coord).xyzw;
	
	if (overlayColor.w >= alphaThreshold)
	{
		gl_FragColor = overlayColor;
	}
	else
	{
		if (destColor.x != 0.0)
		{
			gl_FragColor = vec4(overlayColor.x,overlayColor.y,overlayColor.z,overlayColor.w*overlayAlphaAdjust+(destColor.x*destinationAlphaAdjust));
		}
		else
		{
			gl_FragColor = vec4(overlayColor.x,overlayColor.y,overlayColor.z,overlayColor.w*overlayAlphaAdjust);
		}
	
	}
	
	
}