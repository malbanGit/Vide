#version 120
// taken from:
// https://wiki.delphigl.com/index.php/shader_blur2

void main() {
	gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}