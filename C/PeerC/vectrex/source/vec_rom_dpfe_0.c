// ***************************************************************************
// VECTREX EXECUTIVE ROM ADRESSES
// as described in the Vectrex Programmer's Manual Volume 1
// ***************************************************************************
// This file was developed by Prof. Dr. Peer Johannsen as part of the 
// "Retro-Programming" and "Advanced C Programming" class at
// Pforzheim University, Germany.
// 
// It can freely be used, but at one's own risk and for non-commercial
// purposes only. Please respect the copyright and credit the origin of
// this file.
//
// Feedback, suggestions and bug-reports are welcome and can be sent to:
// peer.johannsen@pforzheim-university.de
// ---------------------------------------------------------------------------

__asm(
	".bank page_00 (BASE=0x0000,SIZE=0x0100)\n\t"
	".area direct (OVR,BANK=page_00)\n\t"
);

// ---------------------------------------------------------------------------
// page FE00

int					dp_Vec_Snd_shadow[0x28]			__attribute__((section("direct"), used)); // 0xC800, Shadow of sound chip registers (15 bytes)
const unsigned int 	dp_Vec_ADSR_FADE1[0x38-0x28]	__attribute__((section("direct"), used)); // 0xFE28, adsr table
const unsigned int 	dp_Vec_Music_5[0x66-0x38] 		__attribute__((section("direct"), used)); // 0xFE38, melody, solar quest
const unsigned int 	dp_Vec_ADSR_FADE2[0x76-0x66]	__attribute__((section("direct"), used)); // 0xFE66, adsr table
const unsigned int 	dp_Vec_Music_6[0xb2-0x76] 		__attribute__((section("direct"), used)); // 0xFE76, melody, clean sweep
const unsigned int 	dp_Vec_ADSR_FADE3[0xb6-0xb2]	__attribute__((section("direct"), used)); // 0xFEB2, adsr table
const unsigned int 	dp_Vec_TWANG_VIBEHL[0xc6-0xb6] 	__attribute__((section("direct"), used)); // 0xFEB6, twang table, minestorm
const unsigned int 	dp_Vec_Music_7[0xe8-0xc6] 		__attribute__((section("direct"), used)); // 0xFEC6, melody, star trek
const unsigned int 	dp_Vec_ADSR_FADE4[0xf8-0xe8]	__attribute__((section("direct"), used)); // 0xFEE8, adsr table
const unsigned int 	dp_Vec_Music_8					__attribute__((section("direct"), used)); // 0xFEF8, melody, fanfare 1

// ***************************************************************************
// end of file
// ***************************************************************************
