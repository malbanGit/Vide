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
	".bank page_f7 (BASE=0xf742,SIZE=0x00be)\n\t"
	".area .0xf7 (OVR,BANK=page_f7)\n\t"
);

// ---------------------------------------------------------------------------
// 0xF700

int __Stop_Sound[0xf7a9 - 0xF742]	__attribute__((section(".0xf7"), used)); // 0xF742
int __Select_Game					__attribute__((section(".0xf7"), used)); // 0xF7A9

// ***************************************************************************
// end of file
// ***************************************************************************
