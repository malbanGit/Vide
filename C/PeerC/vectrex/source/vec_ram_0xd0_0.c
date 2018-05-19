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

// page D000

__asm(
	".bank page_d0 (BASE=0xd000,SIZE=0x0100)\n\t"
	".area .dpd0 (OVR,BANK=page_d0)\n\t"
);

// ***************************************************************************
// 0xDxx0 - 0xDxxF (16B)	programmable interface adapter VIA (read or write) 
// ***************************************************************************
volatile int VIA_port_b __attribute__((section(".dpd0"), used));	// 0xD000, VIA port B data I/O register
volatile int VIA_port_a	__attribute__((section(".dpd0"), used));	// 0xD001, VIA port A data I/O register (handshaking)
//       0 sample/hold (0=enable  mux 1=disable mux)
//       1 mux sel 0
//       2 mux sel 1
//       3 sound BC1
//       4 sound BDIR
//       5 comparator input
//       6 external device (slot pin 35) initialized to input
//       7 /RAMPvolatile unsigned int VIA_DDR_b		__attribute__((section(".dpd0"), used));	// 0xD002, VIA port B data direction register (0=input 1=output)volatile unsigned int VIA_DDR_a		__attribute__((section(".dpd0"), used));	// 0xD003, VIA port A data direction register (0=input 1=output)volatile unsigned int VIA_t1_cnt_lo	__attribute__((section(".dpd0"), used));	// 0xD004, VIA timer 1 count register lo (scale factor)volatile unsigned int VIA_t1_cnt_hi	__attribute__((section(".dpd0"), used));	// 0xD005, VIA timer 1 count register hivolatile unsigned int VIA_t1_lch_lo	__attribute__((section(".dpd0"), used));	// 0xD006, VIA timer 1 latch register lovolatile unsigned int VIA_t1_lch_hi	__attribute__((section(".dpd0"), used));	// 0xD007, VIA timer 1 latch register hivolatile unsigned int VIA_t2_lo		__attribute__((section(".dpd0"), used));	// 0xD008, VIA timer 2 count/latch register lo (refresh)volatile unsigned int VIA_t2_hi		__attribute__((section(".dpd0"), used));	// 0xD009, VIA timer 2 count/latch register hivolatile unsigned int VIA_shift_reg	__attribute__((section(".dpd0"), used));	// 0xD00A, VIA shift registervolatile unsigned int VIA_aux_cntl	__attribute__((section(".dpd0"), used));	// 0xD00B, VIA auxiliary control register
//       0 PA latch enable
//       1 PB latch enable
//       2 \                     110=output to CB2 under control of phase 2 clock
//       3  > shift register control     (110 is the only mode used by the Vectrex ROM)
//       4 /
//       5 0=t2 one shot                 1=t2 free running
//       6 0=t1 one shot                 1=t1 free running
//       7 0=t1 disable PB7 output       1=t1 enable PB7 outputvolatile unsigned int VIA_cntl __attribute__((section(".dpd0"), used));	// 0xD00C, VIA control register
//       0 CA1 control     CA1 -> SW7    0=IRQ on low 1=IRQ on high
//       1 \ x
//       2  > CA2 control  CA2 -> /ZERO  110=low 111=high
//       3 /
//       4 CB1 control     CB1 -> NC     0=IRQ on low 1=IRQ on high
//       5 \ x
//       6  > CB2 control  CB2 -> /BLANK 110=low 111=high
//       7 /volatile unsigned int VIA_int_flags __attribute__((section(".dpd0"), used));	// 0xD00D, VIA interrupt flags register
//               bit                             cleared by
//       0 CA2 interrupt flag            reading or writing port A I/O
//       1 CA1 interrupt flag            reading or writing port A I/O
//       2 shift register interrupt flag reading or writing shift register
//       3 CB2 interrupt flag            reading or writing port B I/O
//       4 CB1 interrupt flag            reading or writing port A I/O
//       5 timer 2 interrupt flag        read t2 low or write t2 high
//       6 timer 1 interrupt flag        read t1 count low or write t1 high
//       7 IRQ status flag               write logic 0 to IER or IFR bitvolatile unsigned int VIA_int_enable __attribute__((section(".dpd0"), used));	// 0xD00E, VIA interrupt enable register
//       0 CA2 interrupt enable
//       1 CA1 interrupt enable
//       2 shift register interrupt enable
//       3 CB2 interrupt enable
//       4 CB1 interrupt enable
//       5 timer 2 interrupt enable
//       6 timer 1 interrupt enable
//       7 IER set/clear controlvolatile unsigned int VIA_port_a_nohs __attribute__((section(".dpd0"), used));	// 0xD00F, VIA port A data I/O register (no handshaking)

// ***************************************************************************
// end of file
// ***************************************************************************
