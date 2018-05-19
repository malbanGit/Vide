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
	".bank page_fe (BASE=0xfe28,SIZE=0x0100)\n\t"
	".area .dpfe (OVR,BANK=page_fe)\n\t"
);

// ---------------------------------------------------------------------------
// page FE00

const unsigned int Vec_ADSR_FADE1[0xb6-0x28]	__attribute__((section(".dpfe"), used)); // 0xFE28, adsr table
const unsigned int Vec_TWANG_VIBENL 			__attribute__((section(".dpfe"), used)); // 0xFEB6, twang table, minestorm

// ***************************************************************************
// end of file
// ***************************************************************************
