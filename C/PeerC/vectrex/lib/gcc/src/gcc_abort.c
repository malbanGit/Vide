// ***************************************************************************
// gcc built-in stdlib functions for gcc6809
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
// vectrex@pforzheim-university.de
//
// ---------------------------------------------------------------------------

#include "gcc.h"

// ---------------------------------------------------------------------------

#if _GCC_BUILTIN_ABORT
#if _GCC_BUILTIN_RESET
__ass(
	".globl		_abort				\n\t"
	"_abort		.equ 	0xf000		\n\t"
);
#else
__INLINE
__attribute__ ((naked))
void abort(void)
{
#if _GCC_BUILTIN_ASM
	asm volatile ("jmp 0xf000; abort -> restart system" : :: "pc");
#else
	goto *((void*) 0xf000);
#endif
}
#endif
#endif

// ***************************************************************************
// end of file
// ***************************************************************************
