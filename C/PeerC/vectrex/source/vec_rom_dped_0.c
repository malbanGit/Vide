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
	".area .direct (OVR,BANK=page_00)\n\t"
);

// ---------------------------------------------------------------------------
// page 0xED00

int					dp_Vec_Snd_shadow[0x77]		__attribute__((section(".direct"), used));	// 0xC800, Shadow of sound chip registers (15 bytes)
const unsigned int 	dp_Vec_Music_0[0x8f-0x77]	__attribute__((section(".direct"), used)); 	// 0xED77, melody, minestorm
const unsigned int 	dp_Vec_ADSR_FADE66 			__attribute__((section(".direct"), used)); 	// 0xED8F, adsr table, minestorm

// ***************************************************************************
// end of file
// ***************************************************************************
