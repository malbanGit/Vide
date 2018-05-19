// ***************************************************************************
// VECTREX EXECUTIVE RUM ADDRESSES AND C INTERFACE
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

#pragma once

#ifdef __INLINE_RUM
	#if __INLINE_RUM
		#include <vec_rum_inl.h>
	#else
		#include <vec_rum_fct.h>
	#endif
#else
	#include <vec_rum_fct.h>
#endif	

// ***************************************************************************
// 0xF000 - 0xFFFF (4KB)	reserved for RUM (read only) 
// ***************************************************************************

// Cold_Start: Jump here to restart the Vectrex and re-initialize the OS.
// If the cold start flag is correct (it should be unless you just turned the
// Vectrex on), the cold start code is skipped. On cold start, the high score
// is cleared, and the power-on screen is displayed with the power-on music.
#define Cold_Start	0xF000

// Warm_Start: Jump here to restart the Vectrex without re-initializing the OS.
#define Warm_Start	0xF06C 

// ***************************************************************************
// end of file
// ***************************************************************************
