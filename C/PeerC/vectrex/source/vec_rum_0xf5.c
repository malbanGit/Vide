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
	".bank page_f5 (BASE=0xf511,SIZE=0x00ef)\n\t"
	".area .0xf5 (OVR,BANK=page_f5)\n\t"
);

// ---------------------------------------------------------------------------
// 0xF500

int __Random_3[0xf517 - 0xF511]			__attribute__((section(".0xf5"), used)); // 0xF511 
int __Random[0xf533 - 0xF517]			__attribute__((section(".0xf5"), used)); // 0xF517
int __Init_Music_Buf[0xf53f - 0xF533]	__attribute__((section(".0xf5"), used)); // 0xF533
int __Clear_x_b[0xf542 - 0xF53F]		__attribute__((section(".0xf5"), used)); // 0xF53F
int __Clear_C8_RAM[0xf545 - 0xF542]		__attribute__((section(".0xf5"), used)); // 0xF542, never used by GCE carts?
int __Clear_x_256[0xf548 - 0xF545]		__attribute__((section(".0xf5"), used)); // 0xF545
int __Clear_x_d[0xf550 - 0xF548]		__attribute__((section(".0xf5"), used)); // 0xF548
int __Clear_x_b_80[0xf552 - 0xF550]		__attribute__((section(".0xf5"), used)); // 0xF550
int __Clear_x_b_a[0xf55a - 0xF552]		__attribute__((section(".0xf5"), used)); // 0xF552
int __Dec_3_Counters[0xf55e - 0xF55A]	__attribute__((section(".0xf5"), used)); // 0xF55A
int __Dec_6_Counters[0xf563 - 0xF55E]	__attribute__((section(".0xf5"), used)); // 0xF55E
int __Dec_Counters[0xf56d - 0xF563]		__attribute__((section(".0xf5"), used)); // 0xF563
int __Delay_3[0xf571 - 0xF56D]			__attribute__((section(".0xf5"), used)); // 0xF56D, 30 cycles
int __Delay_2[0xf575 - 0xF571]			__attribute__((section(".0xf5"), used)); // 0xF571, 25 cycles
int __Delay_1[0xf579 - 0xF575]			__attribute__((section(".0xf5"), used)); // 0xF575, 20 cycles
int __Delay_0[0xf57a - 0xF579]			__attribute__((section(".0xf5"), used)); // 0xF579, 12 cycles
int __Delay_b[0xf57d - 0xF57A]			__attribute__((section(".0xf5"), used)); // 0xF57A, 5*B + 10 cycles
int __Delay_RTS[0xf57e - 0xF57D]		__attribute__((section(".0xf5"), used)); // 0xF57D, 5 cycles
int __Bitmask_a[0xf584 - 0xF57E]		__attribute__((section(".0xf5"), used)); // 0xF57E
int __Abs_a_b[0xf58b - 0xF584]			__attribute__((section(".0xf5"), used)); // 0xF584
int __Abs_b[0xf593 - 0xF58B]			__attribute__((section(".0xf5"), used)); // 0xF58B
int __Rise_Run_Angle[0xf5d9 - 0xF593]	__attribute__((section(".0xf5"), used)); // 0xF593
int __Get_Rise_Idx[0xf5db - 0xF5D9]		__attribute__((section(".0xf5"), used)); // 0xF5D9
int __Xform_Sin[0xf5ef - 0xF5DB]		__attribute__((section(".0xf5"), used)); // 0xF5DB
int __Get_Rise_Run[0xf5ff - 0xF5EF]		__attribute__((section(".0xf5"), used)); // 0xF5EF
int __Rise_Run_X						__attribute__((section(".0xf5"), used)); // 0xF5FF

// ***************************************************************************
// end of file
// ***************************************************************************
