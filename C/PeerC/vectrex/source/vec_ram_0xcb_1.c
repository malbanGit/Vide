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

int				Vec_Default_Stk		__attribute__((section(".dpcb"), used));	// 0xCBEA, Default top-of-stack
unsigned int	Vec_High_score[7]	__attribute__((section(".dpcb"), used));	// 0xCBEB, High score storage (7 bytes)
int				Vec_SWI3_vector[3]	__attribute__((section(".dpcb"), used));	// 0xCBF2, SWI2/SWI3 interrupt vector (3 bytes)
int				Vec_FIRQ_vector[3]	__attribute__((section(".dpcb"), used));	// 0xCBF5, FIRQ interrupt vector (3 bytes)
int				Vec_IRQ_vector[3]	__attribute__((section(".dpcb"), used));	// 0xCBF8, IRQ interrupt vector (3 bytes)
int				Vec_SWI_vector[3]	__attribute__((section(".dpcb"), used));	// 0xCBFB, SWI/NMI interrupt vector (3 bytes)

// ***************************************************************************
// end of file
// ***************************************************************************