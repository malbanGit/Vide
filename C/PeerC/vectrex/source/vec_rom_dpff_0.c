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
// page FF00

int					dp_Vec_Snd_shadow[0x16]			__attribute__((section("direct"), used)); // 0xC800, Shadow of sound chip registers (15 bytes)
const unsigned int 	dp_Vec_ADSR_FADE8[0x26-0x16]	__attribute__((section("direct"), used)); // 0xFF16, adsr table
const unsigned int 	dp_Vec_Music_9[0x44-0x26]		__attribute__((section("direct"), used)); // 0xFF26, melody, fanfare 2
const unsigned int 	dp_Vec_Music_a[0x62-0x44]		__attribute__((section("direct"), used)); // 0xFF44, melody, fanfare 3 (berzerk)
const unsigned int 	dp_Vec_Music_b[0x7a-0x62]		__attribute__((section("direct"), used)); // 0xFF62, melody, fanfare 3a
const unsigned int 	dp_Vec_Music_c[0x8f-0x7a]		__attribute__((section("direct"), used)); // 0xFF7A, melody, fanfare 4
const unsigned int 	dp_Vec_Music_d					__attribute__((section("direct"), used)); // 0xFF8F, melody, fanfare 5

// ***************************************************************************
// end of file
// ***************************************************************************
