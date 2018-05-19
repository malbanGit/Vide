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
	".bank page_f2 (BASE=0xf256,SIZE=0x00aa)\n\t"
	".area .0xf2 (OVR,BANK=page_f2)\n\t"
);

// ---------------------------------------------------------------------------
// 0xF200

int __Sound_Byte[0xf259 - 0xF256]		__attribute__((section(".0xf2"), used)); // 0xF256
int __Sound_Byte_x[0xf272 - 0xF259]		__attribute__((section(".0xf2"), used)); // 0xF259 
int __Clear_Sound[0xf27d - 0xF272]		__attribute__((section(".0xf2"), used)); // 0xF272 
int __Sound_Bytes[0xf284 - 0xF27D]		__attribute__((section(".0xf2"), used)); // 0xF27D 
int __Sound_Bytes_x[0xf289 - 0xF284]	__attribute__((section(".0xf2"), used)); // 0xF284
int __Do_Sound[0xf28c - 0xF289]			__attribute__((section(".0xf2"), used)); // 0xF289
int __Do_Sound_x[0xf29d - 0xF28C]		__attribute__((section(".0xf2"), used)); // 0xF28C, not official! 
int __Intensity_1F[0xf2a1 - 0xF29D]		__attribute__((section(".0xf2"), used)); // 0xF29D
int __Intensity_3F[0xf2a5 - 0xF2A1]		__attribute__((section(".0xf2"), used)); // 0xF2A1 
int __Intensity_5F[0xf2a9 - 0xF2A5]		__attribute__((section(".0xf2"), used)); // 0xF2A5 
int __Intensity_7F[0xf2ab - 0xF2A9]		__attribute__((section(".0xf2"), used)); // 0xF2A9 
int __Intensity_a[0xf2be - 0xF2AB]		__attribute__((section(".0xf2"), used)); // 0xF2AB
int __Dot_ix_b[0xf2c1 - 0xF2BE]			__attribute__((section(".0xf2"), used)); // 0xF2BE 
int __Dot_ix[0xf2c3 - 0xF2C1]			__attribute__((section(".0xf2"), used)); // 0xF2C1 
int __Dot_d[0xf2c5 - 0xF2C3]			__attribute__((section(".0xf2"), used)); // 0xF2C3 
int __Dot_here[0xf2d5 - 0xF2C5]			__attribute__((section(".0xf2"), used)); // 0xF2C5
int __Dot_List[0xf2de - 0xF2D5]			__attribute__((section(".0xf2"), used)); // 0xF2D5
int __Dot_List_Reset[0xf2e6 - 0xF2DE]	__attribute__((section(".0xf2"), used)); // 0xF2DE
int __Recalibrate[0xf2f2 - 0xF2E6]		__attribute__((section(".0xf2"), used)); // 0xF2E6 
int __Moveto_x_7F[0xf2fc - 0xF2F2]		__attribute__((section(".0xf2"), used)); // 0xF2F2
int __Moveto_d_7F						__attribute__((section(".0xf2"), used)); // 0xF2FC

// ***************************************************************************
// end of file
// ***************************************************************************
