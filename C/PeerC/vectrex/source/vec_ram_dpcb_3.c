// ***************************************************************************
// VECTREX EXECUTIVE RAM
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
// direct page

int	dp_Vec_Snd_shadow[0xf2]			__attribute__((section(".direct"), used));	// 0xC800, Shadow of sound chip registers (15 bytes)
int	dp_Vec_SWI2_vector[0xfb-0xf2]	__attribute__((section(".direct"), used));	// 0xCBF2, SWI2/SWI3 interrupt vector (3 bytes)
int	dp_Vec_NWI_vector[3]			__attribute__((section(".direct"), used));	// 0xCBFB, SWI/NMI interrupt vector (3 bytes)

// ***************************************************************************
// end of file
// ***************************************************************************
