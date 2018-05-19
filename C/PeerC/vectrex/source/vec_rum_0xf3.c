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
	".bank page_f3 (BASE=0xf308,SIZE=0x00f8)\n\t"
	".area .0xf3 (OVR,BANK=page_f3)\n\t"
);

// ---------------------------------------------------------------------------
// 0xF300

int __Moveto_ix_FF[0xf30c - 0xF308]		__attribute__((section(".0xf3"), used)); // 0xF308 
int __Moveto_ix_7F[0xf30e - 0xF30C]		__attribute__((section(".0xf3"), used)); // 0xF30C 
int __Moveto_ix_b[0xf310 - 0xF30E]		__attribute__((section(".0xf3"), used)); // 0xF30E 
int __Moveto_ix[0xf312 - 0xF310]		__attribute__((section(".0xf3"), used)); // 0xF310 
int __Moveto_d[0xf34a - 0xF312]			__attribute__((section(".0xf3"), used)); // 0xF312
int __Reset0Ref_D0[0xf34f - 0xF34A]		__attribute__((section(".0xf3"), used)); // 0xF34A
int __Check0Ref[0xf354 - 0xF34F]		__attribute__((section(".0xf3"), used)); // 0xF34F 
int __Reset0Ref[0xf35b - 0xF354]		__attribute__((section(".0xf3"), used)); // 0xF354 
int __Reset_Pen[0xf36b - 0xF35B]		__attribute__((section(".0xf3"), used)); // 0xF35B
int __Reset0Int[0xf373 - 0xF36B]		__attribute__((section(".0xf3"), used)); // 0xF36B
int __Print_Str_hwyx[0xf378 - 0xF373]	__attribute__((section(".0xf3"), used)); // 0xF373 
int __Print_Str_yx[0xf37a - 0xF378]		__attribute__((section(".0xf3"), used)); // 0xF378
int __Print_Str_d[0xf385 - 0xF37A]		__attribute__((section(".0xf3"), used)); // 0xF37A
int __Print_List_hw[0xf38a - 0xF385]	__attribute__((section(".0xf3"), used)); // 0xF385
int __Print_List[0xf38c - 0xF38A]		__attribute__((section(".0xf3"), used)); // 0xF38A, not official!
int __Print_List_chk[0xf391 - 0xF38C]	__attribute__((section(".0xf3"), used)); // 0xF38C 
int __Print_Ships_x[0xf393 - 0xF391]	__attribute__((section(".0xf3"), used)); // 0xF391 
int __Print_Ships[0xf3ad - 0xF393]		__attribute__((section(".0xf3"), used)); // 0xF393 
int __Mov_Draw_VLc_a[0xf3b1 - 0xF3AD]	__attribute__((section(".0xf3"), used)); // 0xF3AD, count y x y x ...
int __Mov_Draw_VL_b[0xf3b5 - 0xF3B1]	__attribute__((section(".0xf3"), used)); // 0xF3B1, y x y x ...
int __Mov_Draw_VLcs[0xf3b7 - 0xF3B5]	__attribute__((section(".0xf3"), used)); // 0xF3B5, count scale y x y x ...
int __Mov_Draw_VL_ab[0xf3b9 - 0xF3B7]	__attribute__((section(".0xf3"), used)); // 0xF3B7
int __Mov_Draw_VL_a[0xf3bc - 0xF3B9]	__attribute__((section(".0xf3"), used)); // 0xF3B9, y x y x ...
int __Mov_Draw_VL[0xf3be - 0xF3BC]		__attribute__((section(".0xf3"), used)); // 0xF3BC, y x y x ...
int __Mov_Draw_VL_d[0xf3ce - 0xF3BE]	__attribute__((section(".0xf3"), used)); // 0xF3BE, y x
int __Draw_VLc[0xf3d2 - 0xF3CE]			__attribute__((section(".0xf3"), used)); // 0xF3CE, count y x y x ...
int __Draw_VL_b[0xf3d6 - 0xF3D2]		__attribute__((section(".0xf3"), used)); // 0xF3D2, x x y x ...
int __Draw_VLcs[0xf3d8 - 0xF3D6]		__attribute__((section(".0xf3"), used)); // 0xF3D6, count scale y x y x ...
int __Draw_VL_ab[0xf3da - 0xF3D8]		__attribute__((section(".0xf3"), used)); // 0xF3D8
int __Draw_VL_a[0xf3dd - 0xF3DA]		__attribute__((section(".0xf3"), used)); // 0xF3DA, y x y x ...
int __Draw_VL[0xf3df - 0xF3DD]			__attribute__((section(".0xf3"), used)); // 0xF3DD, y x y x ...
int __Draw_Line_d						__attribute__((section(".0xf3"), used)); // 0xF3DF

// ***************************************************************************
// end of file
// ***************************************************************************
