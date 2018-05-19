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
	".bank page_ea (BASE=0xea3e,SIZE=0x00c2)\n\t"
	".area .0xea (OVR,BANK=page_ea)\n\t"
);

// ---------------------------------------------------------------------------
// 0xEA00 - MINESTORM

int __Rnd_Cone[0xea5d - 0xEA3E]		__attribute__((section(".0xea"), used)); // 0xEA3E
int __Dot_y[0xea6d - 0xEA5D]		__attribute__((section(".0xea"), used)); // 0xEA5D
int __Dot_py[0xea7f - 0xEA6D]		__attribute__((section(".0xea"), used)); // 0xEA6D
int __Draw_Pack[0xea8d - 0xEA7F]	__attribute__((section(".0xea"), used)); // 0xEA7F
int __Draw_Pack_py[0xeaa8 - 0xEA8D]	__attribute__((section(".0xea"), used)); // 0xEA8D
int __Print_Msg[0xeab4 - 0xEAA8]	__attribute__((section(".0xea"), used)); // 0xEAA8
int __Draw_Score[0xeacf - 0xEAb4]	__attribute__((section(".0xea"), used)); // 0xEAB4
int __Draw_Scores[0xeaf0 - 0xEAcf]	__attribute__((section(".0xea"), used)); // 0xEACF
int __Wait_Bound					__attribute__((section(".0xea"), used)); // 0xEAF0

// ***************************************************************************
// end of file
// ***************************************************************************
