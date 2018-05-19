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
	".bank page_f8 (BASE=0xf835,SIZE=0x00cb)\n\t"
	".area .0xf8 (OVR,BANK=page_f8)\n\t"
);

// ---------------------------------------------------------------------------
// 0xF800

int __Display_Option[0xf84f - 0xF835]	__attribute__((section(".0xf8"), used)); // 0xF835 - inofficial!
int __Clear_Score[0xf85e - 0xF84f]		__attribute__((section(".0xf8"), used));  //0xF84F
int __Add_Score_a[0xf87c - 0xF85E]		__attribute__((section(".0xf8"), used)); // 0xF85E
int __Add_Score_d[0xf8b7 - 0xF87C]		__attribute__((section(".0xf8"), used)); // 0xF87C
int __Strip_Zeros[0xf8c7 - 0xF8B7]		__attribute__((section(".0xf8"), used)); // 0xF8B7
int __Compare_Score[0xf8d8 - 0xF8C7]	__attribute__((section(".0xf8"), used)); // 0xF8C7
int __New_High_Score[0xf8e5 - 0xf8d8] 	__attribute__((section(".0xf8"), used)); //0xF8D8
int __Obj_Will_Hit_u[0xf8f3 - 0xF8E5]	__attribute__((section(".0xf8"), used)); // 0xF8E5
int __Obj_Will_Hit[0xf8ff - 0xF8F3]		__attribute__((section(".0xf8"), used)); // 0xF8F3
int __Obj_Hit							__attribute__((section(".0xf8"), used)); // 0xF8FF

// ***************************************************************************
// end of file
// ***************************************************************************
