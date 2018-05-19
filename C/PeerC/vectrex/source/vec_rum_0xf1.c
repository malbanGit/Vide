// ***************************************************************************
// VECTREX EXECUTIVE RUM ADDRESSES AND C INTERFACE - BOTTOM LAYER GCE BIOS
// as described in the Vectrex Programmer's Manual Volume 2
// ***************************************************************************
//
// Disclaimer:
//
// This file is part of the Vectrex C programming setup developed by 
// Prof. Dr. rer. nat. Peer Johannsen. The setup is used as tool and as
// teaching material in the "Retro-Programming" and the "Advanced
// hardware-oriented C and Assembly Language Programming" classes at
// Pforzheim University, Germany.
// 
// Writing their own games for a vintage arcade game console in a programming
// course and seeing them run on a real Vectrex device has proved to greatly
// contribute to the motivation of the students.
//
// The C programming setup can freely be used by everyone for writing 
// Vectrex games and Vectrex programs in C, but at one's own risk. Please
// respect the copyright and credit the origin of these files.
//
// It would be truly fantastic if those who use this setup and/or these files
// to develop and produce their own Vectrex game cartridges, would support the
// educational approach and aim of these programming classes by donating a
// complimentary cartridge which will then be used as additional motivational
// content.
//
// Many thanks to all those out there who have already supported this course
// in various ways!
//
// Feedback, suggestions and bug-reports are always welcome and can be sent
// to the following contact address:
//
// peer.johannsen@pforzheim-university.de
//
// ---------------------------------------------------------------------------

__asm(
	".bank page_f1 (BASE=0xf14c,SIZE=0x00b4)\n\t"
	".area .0xf1 (OVR,BANK=page_f1)\n\t"
);

// ---------------------------------------------------------------------------
// 0xF100

int __Init_VIA[0xf164 - 0xF14C]			__attribute__((section(".0xf1"), used));	// 0xF14C
int __Init_OS_RAM[0xf18b - 0xF164]		__attribute__((section(".0xf1"), used));	// 0xF164
int __Init_OS[0xf192 - 0xF18B]			__attribute__((section(".0xf1"), used));	// 0xF18B
int __Wait_Recal[0xf1aa - 0xF192]		__attribute__((section(".0xf1"), used));	// 0xF192
int __DP_to_D0[0xf1af - 0xF1AA]			__attribute__((section(".0xf1"), used));	// 0xF1AA
int __DP_to_C8[0xf1b4 - 0xF1AF]			__attribute__((section(".0xf1"), used));	// 0xF1AF
int __Read_Btns_Mask[0xf1ba - 0xF1B4]	__attribute__((section(".0xf1"), used));	// 0xF1B4
int __Read_Btns[0xf1f5 - 0xF1BA]		__attribute__((section(".0xf1"), used));	// 0xF1BA
int __Joy_Analog[0xf1f8 - 0xF1F5]		__attribute__((section(".0xf1"), used));	// 0xF1F5
int __Joy_Digital						__attribute__((section(".0xf1"), used));	// 0xF1F8

// ***************************************************************************
// end of file
// ***************************************************************************
