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
	".bank page_cb (BASE=0xcbea,SIZE=0x0100)\n\t"
	".area .dpcb (OVR,BANK=page_cb)\n\t"
);

// ---------------------------------------------------------------------------
// page CB00

int	Vec_Default_Stk[0xf2-0xea]	__attribute__((section(".dpcb"), used));	// 0xCBEA, Default top-of-stack
int	Vec_SWI2_vector[0xfb-0xf2]	__attribute__((section(".dpcb"), used));	// 0xCBF2, SWI2/SWI3 interrupt vector (3 bytes)
int	Vec_NWI_vector[3]			__attribute__((section(".dpcb"), used));	// 0xCBFB, SWI/NMI interrupt vector (3 bytes)

// ***************************************************************************
// end of file
// ***************************************************************************