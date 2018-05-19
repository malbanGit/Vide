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
	".bank page_f6 (BASE=0xf601,SIZE=0x00ff)\n\t"
	".area .0xf6 (OVR,BANK=page_f6)\n\t"
);

// ---------------------------------------------------------------------------
// 0xF600

int __Rise_Run_Y[0xf603 - 0xF601]		__attribute__((section(".0xf6"), used)); // 0xF601
int __Rise_Run_Len[0xf610 - 0xF603]		__attribute__((section(".0xf6"), used)); // 0xF603
int __Rot_VL_ab[0xf613 - 0xF610]		__attribute__((section(".0xf6"), used)); // 0xF610
int __Rot_VL_Diff[0xf616 - 0xF613]		__attribute__((section(".0xf6"), used)); // 0xF613
int __Rot_VL[0xf61f - 0xF616]			__attribute__((section(".0xf6"), used)); // 0xF616 
int __Rot_VL_Mode[0xf622 - 0xF61F]		__attribute__((section(".0xf6"), used)); // 0xF61F 
int __Rot_VL_Pack[0xf62b - 0xF622]		__attribute__((section(".0xf6"), used)); // 0xF622
int __Rot_VL_M_dft[0xf65B - 0xF62B]		__attribute__((section(".0xf6"), used)); // 0xF62B 
int __Xform_Run_a[0xf65d - 0xF65B]		__attribute__((section(".0xf6"), used)); // 0xF65B 
int __Xform_Run[0xf661 - 0xF65D]		__attribute__((section(".0xf6"), used)); // 0xF65D 
int __Xform_Rise_a[0xf663 - 0xF661]		__attribute__((section(".0xf6"), used)); // 0xF661 
int __Xform_Rise[0xf67f - 0xF663]		__attribute__((section(".0xf6"), used)); // 0xF663 
int __Move_Mem_a_1[0xf683 - 0xF67F]		__attribute__((section(".0xf6"), used)); // 0xF67F 
int __Move_Mem_a[0xf687 - 0xF683]		__attribute__((section(".0xf6"), used)); // 0xF683
int __Init_Music_chk[0xf68d - 0xF687]	__attribute__((section(".0xf6"), used)); // 0xF687
int __Init_Music[0xf690 - 0xF68D]		__attribute__((section(".0xf6"), used)); // 0xF68D 
int __Init_Music_a[0xf692 - 0xF690]		__attribute__((section(".0xf6"), used)); // 0xF690 
int __Init_Music_x						__attribute__((section(".0xf6"), used)); // 0xF692 

// ***************************************************************************
// end of file
// ***************************************************************************
