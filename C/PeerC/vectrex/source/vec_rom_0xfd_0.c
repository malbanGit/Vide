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
	".bank page_fd (BASE=0xfd0d,SIZE=0x0100)\n\t"
	".area .dpfd (OVR,BANK=page_fd)\n\t"
);

// ---------------------------------------------------------------------------
// page FD00

const unsigned int Vec_Music_1[0x1d-0x0d] 		__attribute__((section(".dpfd"), used)); // 0xFD0D, melody, vectrex opening tune
const unsigned int Vec_Music_2[0x69-0x1d] 		__attribute__((section(".dpfd"), used)); // 0xFD1D, melody, berzerk
const unsigned int Vec_ADSR_FADE0[0x79-0x69]  	__attribute__((section(".dpfd"), used)); // 0xFD69, adsr table
const unsigned int Vec_TWANG_VIBE0[0x81-0x79]  	__attribute__((section(".dpfd"), used)); // 0xFD79, twang table
const unsigned int Vec_Music_3[0xc3-0x81] 		__attribute__((section(".dpfd"), used)); // 0xFD81, melody, armor attack
const unsigned int Vec_ADSR_FADE12[0xd3-0xc3] 	__attribute__((section(".dpfd"), used)); // 0xFDC3, adsr table
const unsigned int Vec_Music_4					__attribute__((section(".dpfd"), used)); // 0xFDD3, melody, scramble

// ***************************************************************************
// end of file
// ***************************************************************************
