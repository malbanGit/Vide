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
	".area direct (OVR,BANK=page_00)\n\t"
);

// ***************************************************************************
// 0xDxx0 - 0xDxxF (16B)	programmable interface adapter VIA (read or write) 
// ***************************************************************************

volatile int 			dp_VIA_port_b 		__attribute__((section("direct"), used));	// 0xD000, VIA port B data I/O register
volatile int 			dp_VIA_port_a		__attribute__((section("direct"), used));	// 0xD001, VIA port A data I/O register (handshaking)
volatile unsigned int 	dp_VIA_DDR_b		__attribute__((section("direct"), used));	// 0xD002, VIA port B data direction register (0=input 1=output)
volatile unsigned int 	dp_VIA_DDR_a		__attribute__((section("direct"), used));	// 0xD003, VIA port A data direction register (0=input 1=output)
volatile unsigned int 	dp_VIA_t1_cnt_lo	__attribute__((section("direct"), used));	// 0xD004, VIA timer 1 count register lo (scale factor)
volatile unsigned int 	dp_VIA_t1_cnt_hi	__attribute__((section("direct"), used));	// 0xD005, VIA timer 1 count register hi
volatile unsigned int 	dp_VIA_t1_lch_lo	__attribute__((section("direct"), used));	// 0xD006, VIA timer 1 latch register lo
volatile unsigned int 	dp_VIA_t1_lch_hi	__attribute__((section("direct"), used));	// 0xD007, VIA timer 1 latch register hi
volatile unsigned int 	dp_VIA_t2_lo		__attribute__((section("direct"), used));	// 0xD008, VIA timer 2 count/latch register lo (refresh)
volatile unsigned int 	dp_VIA_t2_hi		__attribute__((section("direct"), used));	// 0xD009, VIA timer 2 count/latch register hi
volatile unsigned int 	dp_VIA_shift_reg	__attribute__((section("direct"), used));	// 0xD00A, VIA shift register
volatile unsigned int 	dp_VIA_aux_cntl		__attribute__((section("direct"), used));	// 0xD00B, VIA auxiliary control register
volatile unsigned int 	dp_VIA_cntl 		__attribute__((section("direct"), used));	// 0xD00C, VIA control register
volatile unsigned int 	dp_VIA_int_flags 	__attribute__((section("direct"), used));	// 0xD00D, VIA interrupt flags register
volatile unsigned int 	dp_VIA_int_enable 	__attribute__((section("direct"), used));	// 0xD00E, VIA interrupt enable register
volatile unsigned int 	dp_VIA_port_a_nohs	__attribute__((section("direct"), used));	// 0xD00F, VIA port A data I/O register (no handshaking)

// ***************************************************************************
// end of file
// ***************************************************************************
