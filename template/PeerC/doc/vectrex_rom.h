// ***************************************************************************
// VECTREX EXECUTIVE ROM ADRESSES
// as described in the Vectrex Programmer's Manual Volume 1
// ***************************************************************************
// quick reference - do not use this file as header file
// use #include <vectrex.h> instead
// ***************************************************************************
// This file was developed by Prof. Dr. Peer Johannsen as part of the 
// "Retro-Programming" and "Advanced C Programming" class at
// Pforzheim University, Germany.
// 
// It can freely be used, but at one's own risk and for non-commercial
// purposes only. Please respect the copyright and credit the origin of
// this file.
//
// Feedback, suggestions and bug-reports are welcome and can be sent to:
// peer.johannsen@pforzheim-university.de
// ***************************************************************************

#define ROM(addr, type) *((const type* const) addr)

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

// ---------------------------------------------------------------------------
// Frequency Table

#define Vec_Note_Table		ROM(0xFC8D, long int) // frequency table
#define Vec_Sine_Table		ROM(0xFC8D - 32, int) // frequency table
#define Vec_Cosine_Table	ROM(0xFC8D - 16, int) // frequency table

// ---------------------------------------------------------------------------
// Built in Melodies

#define Vec_Music_1			ROM(0xFD0D, unsigned int) // vectrex opening tune
#define Vec_Music_2			ROM(0xFD1D, unsigned int) // berzerk
#define Vec_Music_3			ROM(0xFD81, unsigned int) // armor attack
#define Vec_Music_4			ROM(0xFDD3, unsigned int) // scramble
#define Vec_Music_5			ROM(0xFE38, unsigned int) // solar quest
#define Vec_Music_6			ROM(0xFE76, unsigned int) // clean sweep
#define Vec_Music_7			ROM(0xFEC6, unsigned int) // star trek
#define Vec_Music_8			ROM(0xFEF8, unsigned int) // fanfare 1
#define Vec_Music_9			ROM(0xFF26, unsigned int) // fanfare 2
#define Vec_Music_a			ROM(0xFF44, unsigned int) // fanfare 3 (berzerk)
#define Vec_Music_b			ROM(0xFF62, unsigned int) // fanfare 3a
#define Vec_Music_c			ROM(0xFF7A, unsigned int) // fanfare 4
#define Vec_Music_d			ROM(0xFF8F, unsigned int) // fanfare 5
#define Vec_Music_e			ROM(0xED77, unsigned int) // minestorm

// ---------------------------------------------------------------------------
// Adsr Tables

#define Vec_ADSR_FADE0 		ROM(0xFD69, unsigned int) //
#define Vec_ADSR_FADE1 		ROM(0xFE28, unsigned int) //
#define Vec_ADSR_FADE2 		ROM(0xFE66, unsigned int) //
#define Vec_ADSR_FADE3 		ROM(0xFEB2, unsigned int) //
#define Vec_ADSR_FADE4 		ROM(0xFEE8, unsigned int) //
#define Vec_ADSR_FADE8 		ROM(0xFF16, unsigned int) //
#define Vec_ADSR_FADE12		ROM(0xFDC3, unsigned int) //
#define Vec_ADSR_FADE66		ROM(0xED8F, unsigned int) // minestorm

// ---------------------------------------------------------------------------
// Twang Tables

#define Vec_TWANG_VIBE0		ROM(0xFD79, unsigned int) //
#define Vec_TWANG_VIBENL	ROM(0xFEB6, unsigned int) // minestorm
#define Vec_TWANG_VIBEHL	ROM(0xFEB6, unsigned int) //

// ***************************************************************************
// end of file
// ***************************************************************************
