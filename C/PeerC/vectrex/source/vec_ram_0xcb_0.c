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

int					Vec_Default_Stk				__attribute__((section(".dpcb"), used));	// 0xCBEA, Default top-of-stack
unsigned int		Vec_High_Score[0xf2-0xeb] 	__attribute__((section(".dpcb"), used));	// 0xCBEB, High score storage (7 bytes)
int					Vec_SWI3_Vector[0xf5-0xf2]	__attribute__((section(".dpcb"), used));	// 0xCBF2, SWI2/SWI3 interrupt vector (3 bytes)
int					Vec_FIRQ_Vector[0xf8-0xf5]	__attribute__((section(".dpcb"), used));	// 0xCBF5, FIRQ interrupt vector (3 bytes)
int					Vec_IRQ_Vector[0xfb-0xf8]	__attribute__((section(".dpcb"), used));	// 0xCBF8, IRQ interrupt vector (3 bytes)
int					Vec_SWI_Vector[0xfe - 0xfb]	__attribute__((section(".dpcb"), used));	// 0xCBFB, SWI/NMI interrupt vector (3 bytes)
long unsigned int	Vec_Cold_Flag				__attribute__((section(".dpcb"), used));	// 0xCBFE, Cold start flag (warm start if = 0x7321)

// ***************************************************************************
// end of file
// ***************************************************************************