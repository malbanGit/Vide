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
	".bank page_f4 (BASE=0xf404,SIZE=0x00f8)\n\t"
	".area .0xf4 (OVR,BANK=page_f4)\n\t"
);

// ---------------------------------------------------------------------------
// 0xF400

int __Draw_VLp_FF[0xf408 - 0xF404]		__attribute__((section(".0xf4"), used)); // 0xF404, pattern y x pattern y x ... 0x01
int __Draw_VLp_7F[0xf40c - 0xF408]		__attribute__((section(".0xf4"), used)); // 0xF408, pattern y x pattern y x ... 0x01
int __Draw_VLp_scale[0xf40e - 0xF40C]	__attribute__((section(".0xf4"), used)); // 0xF40C, scale pattern y x pattern y x
int __Draw_VLp_b[0xf410 - 0xF40E]		__attribute__((section(".0xf4"), used)); // 0xF40E, scale pattern y x pattern y x
int __Draw_VLp[0xf433 - 0xF410]			__attribute__((section(".0xf4"), used)); // 0xF410, pattern y x pattern y x ... 0x01
int __Draw_Pat_VL_aa[0xf434 - 0xF433]	__attribute__((section(".0xf4"), used)); // 0xF433
int __Draw_Pat_VL_a[0xf437 - 0xF434]	__attribute__((section(".0xf4"), used)); // 0xF434
int __Draw_Pat_VL[0xf439 - 0xF437]		__attribute__((section(".0xf4"), used)); // 0xF437
int __Draw_Pat_VL_d[0xf46e - 0xF439]	__attribute__((section(".0xf4"), used)); // 0xF439, not official
int __Draw_VL_mode[0xf495 - 0xF46E]		__attribute__((section(".0xf4"), used)); // 0xF46E
int __Print_Str[0xf498 - 0xF495]		__attribute__((section(".0xf4"), used)); // 0xF495
int __Print_MRast						__attribute__((section(".0xf4"), used)); // 0xF498

// ***************************************************************************
// end of file
// ***************************************************************************
