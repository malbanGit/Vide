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

#pragma once

// ---------------------------------------------------------------------------

#define _GCC_BUILTIN_ABORT		1	// add code for abort()
#define _GCC_BUILTIN_FREE		1	// add code for free()
#define _GCC_BUILTIN_MALLOC		1	// add code for malloc()
#define _GCC_BUILTIN_MEMCMP		1	// add code for memcmp()
#define _GCC_BUILTIN_MEMCPY		1	// add code for memcpy()
#define _GCC_BUILTIN_MEMMOVE	1	// add code for memmove()
#define _GCC_BUILTIN_MEMSET		1	// add code for memset()

#define _GCC_BUILTIN_RESET		1	// use optimized code for abort(), free(), malloc()
#define _GCC_BUILTIN_ASM		0	// use optimized assembly code rather than c - TODO!

#define __ass asm

// ---------------------------------------------------------------------------

void abort(void);
void free(void* pointer);
void* malloc(long unsigned int size);
int memcmp (const void* str1, const void* str2, long unsigned int count);
void* memcpy (void* dest, const void* src, long unsigned int len);
void* memmove(void* dest, const void* src, long unsigned int len);
void* memset(void* dest, int val, long unsigned int len);

// ***************************************************************************
// end of file
// ***************************************************************************
