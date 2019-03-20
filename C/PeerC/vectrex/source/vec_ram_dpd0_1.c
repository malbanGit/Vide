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

// ***************************************************************************
// 0xDxx0 - 0xDxxF (16B)	programmable interface adapter VIA (read or write) 
// ***************************************************************************

volatile unsigned long int	dp_VIA_port_ba	__attribute__((section(".direct"), used));	// 0xD000, VIA port data I/O registers
volatile unsigned long int 	dp_VIA_DDR_ba	__attribute__((section(".direct"), used));	// 0xD002, VIA port data direction registers (0=input 1=output)
volatile unsigned long int 	dp_VIA_t1_cnt	__attribute__((section(".direct"), used));	// 0xD004, VIA timer 1 count register lo (scale factor)
volatile unsigned long int 	dp_VIA_t1_lch	__attribute__((section(".direct"), used));	// 0xD006, VIA timer 1 latch register lo
volatile unsigned long int 	dp_VIA_t2		__attribute__((section(".direct"), used));	// 0xD008, VIA timer 2 count/latch register lo (refresh)
int dp_dummy __attribute__((section(".direct"), used));
volatile unsigned long int 	dp_VIA_aux_cntl_w	__attribute__((section(".direct"), used));	// 0xD00B, VIA auxiliary control register

// ***************************************************************************
// end of file
// ***************************************************************************
