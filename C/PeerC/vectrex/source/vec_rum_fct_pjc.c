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

#include <macro.h>

// ***************************************************************************
// The BIOS calls assume that the DP register is set up correctly,
// so you are responsible for doing that by using the BIOS calls
// DP_to_D0(...) or DP_to_C8(...) as apropriate
// ***************************************************************************

// 1. Calibration and Vector Reset Functions
// 2. Counter Handling Functions
// 3. Direct Page Register Functions
// 4. Delay Functions
// 5.1 Dot Drawing Routines
// 5.2 String Drawing Routines
// 5.3.1 'DIFFY' Style Drawing Routines
// 5.3.2. 'DUFFY' Style Drawing Routines
// 5.3.3. 'PACKET' Style Drawing Routines
// 6. Mathematical Functions
// 7.1 Memory Management - Memory Clear Functions
// 7.2 Memory Management - Memory Copy Functions
// 7.3 Memory Management - Memory Fill Functions
// 8. Controller / Joystick Routines
// 9. Player Option Functions
// 12. Sound Functions
// 13. Vector Beam Positioning Functions
// 14. Vector Brightness Functions
// 15.1 Object Collision Detection Functions
// 15.2 Rotate Routines

// ***************************************************************************
// 1. Calibration and Vector Reset Functions

// FRAM20 	0xF192 	FRWAIT 	Wait for frame boundary
// DEFLOK 	0xF2E6 	--- 	Overcome scan collapse circuitry
// ZERO.DP 	0xF34A 	ZERO.DP 	Zero integrators and set active ground
// ZEGO 	0xF34F 	ZEGO 	Zero integrators and set active ground
// ZEROIT 	0xF354 	ZEROIT 	Zero integrators and set active ground
// ZEREF 	0xF35B 	ZEREF 	Zero integrators and set active ground
// ZERO. 	0xF36B 	ZERO 	Zero integrators and set active ground

// ---------------------------------------------------------------------------
// Wait for beginning of frame boundary (Timer #2 = $0000). 
// Since the program may exceed frame time, this routine will 
// assure a given maximum frame rate.
// Entry Values
// No register parameters required
// FRMTIM = Frame to frame interval
// Return Values
// A = $03
// B = $01
// X = $F9F4 (#KEPALV + 4)
// DP = $D0
// Comments
// Performs one ‘DEFLOK’

#if 0
__NO_INLINE __NAKED void _Wait_Recal(void) // 0xF192
{
	asm volatile(
		"jmp ___Wait_Recal; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------

/* Set_Refresh: This routine loads the refresh timer (t2) with the value in 0xC83D- 
   0xC83E, and recalibrates the vector generators, thus causing the pen to be left 
   at the origin (0,0). The high order byte for the timer is loaded from 0xC83E, 
   and the low order byte is loaded from 0xC83D. 
   The refresh rate is calculated as follows: rate = (C83E)(C83D) / 1.5 mhz */
   
#if 0
__NO_INLINE __NAKED void _Set_Refresh(void) // 0xF1A2, not official!
{
	asm volatile(
		"jmp ___Set_Refresh; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Over-come screen collapse circuitry
// Entry Values
// DP = $D0
// Return Values
// A = $03
// B = $01
// X = $F9F4 (#KEPALV + 4)
// Comments
// ‘DEFLOK’ is performed by calling ‘FRWAIT’. However, it has been necessary with
// some games to add additional ‘DEFLOK’s to prevent long-term screen collapse.

#if 0
__NO_INLINE __NAKED void _Recalibrate(void) // 0xF2E6 
{
	asm volatile(
		"jmp ___Recalibrate; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Set the 6809 ‘DP’ register to the I/O page ($D0), 
// zero the integrators and set active ground
// Entry Values
// None required
// Return Values
// A = $03
// B = $01
// DP = $D0

#if 0
__NO_INLINE __NAKED void _Reset0Ref_D0(void) // 0xF34A
{
	asm volatile(
		"jmp ___Reset0Ref_D0; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Depending on the setting of ‘ZSKIP’, zero integrators and set the sample / hold for active
// ground.
// Entry Values
// DP = $D0
// ZSKIP = $00 - Skip integrator zeroing
// != 0 - Zero integrators
// Return Values
// A = $03 ($00 if ZSKIP = $00)
// B = $01 (Entry value if ZSKIP = $00)

#if 0
__NO_INLINE __NAKED void _Check0Ref(void) // 0xF34F 
{
	asm volatile(
		"jmp ___Check0Ref; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Zero the integrators and set active ground.
// Entry Values
// DP = $D0
// Return Values
// A = $03
// B = $01

#if 0
__NO_INLINE __NAKED void _Reset0Ref(void) // 0xF354 
{
	asm volatile(
		"jmp ___Reset0Ref; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Set active ground sample / hold to zero volts
// Entry Values
// DP = $D0
// Return Values
// A = $03
// B = $01
// Comments
// The active ground sample / hold should be set approximately every 16 vectors (this really
// needs to be determined by trial and error).

#if 0
__NO_INLINE __NAKED void _Reset_Pen(void) // 0xF35B
{
	asm volatile(
		"jmp ___Reset_Pen; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Zero the integrators only
// Entry Values
// DP = $D0
// Return Values
// A = $00
// B = $CC

#if 0
__NO_INLINE __NAKED void _Reset0Int(void) // 0xF36B
{
	asm volatile(
		"jmp ___Reset0Int; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ***************************************************************************
// 2. Counter Handling Functions

// DEKR3 	0xF55A 	D3TMR 	Decrement interval timers
// DEKR 	0xF55E 	DECTMR 	Decrement interval timers
// DEKRCNT	0xF563	---		Decrement counters, inofficial!

// ---------------------------------------------------------------------------
// Decrement 3 interval timers (XTMR0 – XTMR2)
// Entry Values
// None required
// Return Values
// B = $FF
// X = $C82E (#XTMR0)
// Comments
// If used, generally called once per frame

#if 0
__NO_INLINE __NAKED void _Dec_3_Counters(void) // 0xF55A
{
	asm volatile(
		"jmp ___Dec_3_Counters; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Decrement interval timers (XTMR0 – XTMR5)
// Entry Values
// None required
// Return Values
// B = $FF
// X = $C82E (#XTMR0)
// Comments
// If used, generally called once per frame

#if 0
__NO_INLINE __NAKED void _Dec_6_Counters(void) // 0xF55E
{
	asm volatile(
		"jmp ___Dec_6_Counters; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// checks the counters pointed to by the X register and decrements
// those which are not already zero
// Entry Values
// B = number of counters minus 1
// X = points to counter bytes
// Return Values
// B = $FF

#if 0
__NO_INLINE __NAKED void _Dec_Counters(const unsigned int b, void* const x) // 0xF563
{
	asm volatile(
		"jmp ___Dec_Counters; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ***************************************************************************
// 3. Direct Page Register Functions

// DPIO 	0xF1AA 	--- 	Set direct register
// DPRAM 	0xF1AF 	--- 	Set direct register

// ---------------------------------------------------------------------------
// Set 6809 ‘DP’ register for I/O accesses ($D0)
// Entry Values
// None required
// Return Values
// A = $D0
// DP = $D0

#if 0
__NO_INLINE __NAKED void _DP_to_D0(void)  // 0xF1AA
{
	asm volatile(
		"jmp ___DP_to_D0; BIOS call"
		::
		: "memory", "cc", "dp", "a");
}
#endif

// ---------------------------------------------------------------------------
// Set 6809 ‘DP’ register for RAM accesses ($C8)
// Entry Values
// None required
// Return Values
// A = $C8
// DP = $C8

#if 0
__NO_INLINE __NAKED void _DP_to_C8(void) // 0xF1AF
{
	asm volatile(
		"jmp ___DP_to_C8; BIOS call"
		::
		: "memory", "cc", "dp", "a");
}
#endif

// ***************************************************************************
// 4. Delay Functions

// DEL38 	0xF56D 	--- 	Programmed delays
// DEL33 	0xF571 	--- 	Programmed delays
// DEL28 	0xF575 	--- 	Programmed delays
// DEL20 	0xF579 	--- 	Programmed delays
// DEL 		0xF57A 	--- 	Programmed delays
// DEL13 	0xF57D 	--- 	Programmed delays

// ---------------------------------------------------------------------------
// Delay execution for 38 cycles (x.xxx us)
// Entry Values
// None required
// Return Values
// B = $FF

#if 0
__NO_INLINE __NAKED void _Delay_3(void) // 0xF56D, 30 cycles
{
	asm volatile(
		"jmp ___Delay_3; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Delay execution for 33 cycles (x.xxx us)
// Entry Values
// None required
// Return Values
// B = $FF

#if 0
__NO_INLINE __NAKED void _Delay_2(void) // 0xF571, 25 cycles
{
	asm volatile(
		"jmp ___Delay_2; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Delay execution for 28 cycles (x.xxx us)
// Entry Values
// None required
// Return Values
// B = $FF

#if 0
__NO_INLINE __NAKED void _Delay_1(void) // 0xF575, 20 cycles
{
	asm volatile(
		"jmp ___Delay_1; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Delay execution for 20 cycles (x.xxx us)
// Entry Values
// None required
// Return Values
// B = $FF

#if 0
__NO_INLINE __NAKED void _Delay_0(void) // 0xF579, 12 cycles
{
	asm volatile(
		"jmp ___Delay_0; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Delay execution for a minimum of 20 cycles (x.xxx us)
// Entry Values
// B = Delay period
// Return Values
// B = $FF

#if 0
__NO_INLINE __NAKED void _Delay_b(const unsigned int b) // 0xF57A, 5*B + 10 cycles
{
	asm volatile(
		"jmp ___Delay_b; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Delay execution for 13 cycles (x.xxx us)
// Entry Values
// None required

#if 0
__NO_INLINE __NAKED void _Delay_RTS(void) // 0xF57D, 5 cycles
{
	asm volatile(
		"jmp ___Delay_RTS; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ***************************************************************************
// 5.1 Dot Drawing Routines
 
// DOTTIM 	0xF2BE 	--- 	Draw one dot from 'DIFFY' style list
// DOTX 	0xF2C1 	--- 	Draw one dot from 'DIFFY' style list
// DOTAB 	0xF2C3 	--- 	Draw one dot from the contents of 'A' & 'B'
// DOT 		0xF2C5 	--- 	Turn on beam for dot
// DIFDOT 	0xF2D5 	--- 	Draw dots according to 'DIFFY' format
// DOTPAK 	0xF2DE 	DOTPCK 	Draw dots according to 'PACKET' format

// ---------------------------------------------------------------------------
// Draw one dot from ‘Diffy’ style list
// List Description:
// byte 0 / 1 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X)
// Entry Values
// B = Dot ‘ON’ time
// X = ‘DIFFY’ list pointer
// DP = $D0
// T1LOLC = Vector length (scale factor)
// Return Values
// A = $FF
// B = $00
// X = Entry value + 2

#if 0
__NO_INLINE __NAKED void _Dot_ix_b(const unsigned int b, void* const x) // 0xF2BE 
{
	asm volatile(
		"jmp ___Dot_ix_b; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw one dot from ‘Diffy’ style list
// List Description:
// byte 0 / 1 = Positioning vector (Y:X)
// Entry Values
// X = “DIFFY’ list pointer
// DP = $D0
// DWELL = Dot ‘ON’ time
// T1LOLC = Vector length (scale factor)
// Return Values
// A = $FF
// B = $00
// X = Entry value + 2

#if 0
__NO_INLINE __NAKED void _Dot_ix(void* const x) // 0xF2C1 
{
	asm volatile(
		"jmp ___Dot_ix; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Position relative and draw dot
// Entry Values
// A = Relative ‘Y’ vector value
// B = Relative ‘X’ vector value
// DP = $D0
// DWELL = Dot ‘ON’ time
// T1LOLC = Vector length (scale factor)
// Return Values
// A = $FF
// B = $00

__NO_INLINE __NAKED void _Dot_d(const int b __UNUSED, const int a) // 0xF2C3 
{
	asm volatile(
		"lda %[A]\n\t"
		"jmp ___Dot_d; BIOS call"
		:: 	[A] "mi" (a)
		: "memory", "cc");
}

__NO_INLINE __NAKED void _Dot_dd(const long int d __UNUSED) // 0xF2C3 
{
	asm volatile(
		"tfr x,d\n\t"
		"jmp ___Dot_d; BIOS call"
		:: 
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Draw dot
// Entry Values
// DP = $D0
// DWELL = Dot ‘ON’ time
// Return Values
// A = $FF
// B = $00

#if 0
__NO_INLINE __NAKED void _Dot_here(void) // 0xF2C5
{
	asm volatile(
		"jmp ___Dot_here; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw dots according to ‘Diffy’ format
// List Description:
// byte 0 / 1 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X) 
// Entry Values
// X = ‘DIFFY’ list pointer
// DP = $D0
// DWELL = Dot ‘ON’ time
// LIST = Number of vectors – 1
// T1LOLC = Vector length (scale factor)
// Return Values
// A = $03
// B = $01
// X = End of list + 2
// LIST = $00

#if 0
__NO_INLINE __NAKED void _Dot_List(void* const x __UNUSED) // 0xF2D5
{
	asm volatile(
		"jmp ___Dot_List; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw dots according to ‘Packet’ format
// List Description:
// Byte 0 / 1 / 2 = Vector #1 (C:Y:X)
// - - - -
// n / n+1 / n+2 = Vector #n (C:Y:X)
// n+3 = $01 (packet terminator)
// where C = $01 – packet terminator
// $80 - $FF – position for dot
// Entry Values
// X = ‘PACKET’ list pointer
// DP = $D0
// DWELL = Dot ‘ON’ time
// T1LOLC = Vector length (scale factor)
// Return Values
// A = $03
// B = $01
// X = End of list + 1

#if 0
__NO_INLINE __NAKED void _Dot_List_Reset(void* const x __UNUSED) // 0xF2DE
{
	asm volatile(
		"jmp ___Dot_List_Reset; BIOS call"
		:: 	[X] "mi" (x)
		: "memory", "cc");
}
#endif

// ***************************************************************************
// 5.2 Raster Message Drawing Routines (Strings)
 
// SIZPRAS 	0xF373 	RSTSIZ 	Display raster message
// POSNRAS 	0xF378 	RSTPOS 	Display raster message
// POSDRAS 	0xF37A 	MSSPOS 	Display raster message
// TEXSIZ 	0xF385 	TXTSIZ 	Display raster message
// TEXPOS 	0xF38C 	TXTPOS 	Display raster message
// SHIPSAT 	0xF391 	SHIPX 	Display markers (count remaining)
// SHIPSHO 	0xF393 	DSHIP 	Display markers (count remaining)
// RASTUR 	0xF495 	RASTER 	Display raster string
// RASTER 	0xF498 	MRASTR 	Display raster string

// ---------------------------------------------------------------------------
// Fetch size, position and display raster message
// Message List Description:
// byte 0 / 1 = Raster message size (SIZRAS)
// 2 / 3 = Absolute screen position (Y:X)
// 4 – n = Raster message string ($20 - $6F)
// n+1 = Raster terminator ($80)
// Entry Values
// U = Message string pointer
// DP = $D0
// SIZRAS = ‘YZ’ size of raster message
// Return Values
// A = $03
// B = $01
// X = $FBB4
// U = End of message string + 1

__NO_INLINE void _Print_Str_hwyx(void* const u __UNUSED) // 0xF373 
{
	asm volatile(
		"tfr x,u\n\t"
		"jsr ___Print_Str_hwyx; BIOS call"
		::
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Fetch position and display raster message
// Message List Description:
// byte 0 / 1 = Absolute screen position (Y:X)
// 2 – n = Raster message string ($20 - $6F)
// n+1 = Raster terminator ($80)
// Entry Values
// U = Message string pointer
// DP = $D0
// SIZRAS = ‘YZ’ size of raster message
// Return Values
// A = $03
// B = $01
// X = $FBB4
// U = End of message string + 1

__NO_INLINE void _Print_Str_yx(const void* const u __UNUSED) // 0xF378
{
	asm volatile(
		"tfr x,u\n\t"
		"jsr ___Print_Str_yx; BIOS call"
		::
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Position and display raster message
// Message List Description:
// byte 0 – n = Raster message string ($20 - $6F)
// n+1 = Raster terminator ($80)
// Entry Values
// A = Relative ‘Y’ vector value
// B = Relative ‘X’ vector value
// U = Message string pointer
// DP = $D0
// SIZRAS = ‘YX’ size of raster message
// Return Values
// A = $03
// B = $01
// X = $FBB4
// U = End of message string + 1

__NO_INLINE void _Print_Str_d(const int b __UNUSED, const int a, void* const u __UNUSED) // 0xF37A
{
	asm volatile(
		"lda %[A]\n\t"
		"tfr x,u\n\t"
		"jsr ___Print_Str_d; BIOS call"
		:: 	[A] "mi" (a)
		: "memory", "cc", "u");
}

__NO_INLINE void _Print_Str_dd(const long int d __UNUSED, void* const u) // 0xF37A
{
	asm volatile(
		"tfr x,d\n\t"
		"ldu %[U]\n\t"
		"jsr ___Print_Str_d; BIOS call"
		:: [U] "mi" (u)
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Fetch size, position and display multiple text strings
// Message List Description:
// byte 0 / 1 = Raster message size (SIZRAS)
// 2 / 3 = Absolute screen position (Y:X)
// 4 – n = Raster message string ($20 - $6F)
// n +1 = Raster terminator ($80)
// The rater message string (as above, bytes 0 thru n+1) can be repeated as necessary. The
// terminator for multiple message strings is a $00.
// Entry Values
// U = Message string pointer
// DP = $D0
// Return Values
// A = $00
// B = $01
// X = $FBB4
// U = End of message string + 1

__NO_INLINE void _Print_List_hw(void* const u __UNUSED) // 0xF385
{
	asm volatile(
		"tfr x,u\n\t"
		"jsr ___Print_List_hw; BIOS call"
		::
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Fetch position and display multiple text strings
// Message List Description:
// byte 0 / 1 = Absolute screen position (Y:X)
// 2 – n = Raster message string ($20 - $6F)
// n +1 = Raster terminator ($80)
// The rater message string (as above, bytes 0 thru n+1) can be repeated as
// necessary. The terminator for multiple message strings is a $00.
// Entry Values
// U = Message string pointer
// DP = $D0
// SIZRAS = ‘YX’ size of raster message
// Return Values
// A = $00
// B = $01
// X = $FBB4
// U = End of message string + 1

__NO_INLINE void _Print_List(void* const u __UNUSED) // 0xF38A, not official!
{
	asm volatile(
		"tfr x,u\n\t"
		"jsr ___Print_List; BIOS call"
		::
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Fetch position and display multiple text strings
// Message List Description:
// byte 0 / 1 = Absolute screen position (Y:X)
// 2 – n = Raster message string ($20 - $6F)
// n +1 = Raster terminator ($80)
// The rater message string (as above, bytes 0 thru n+1) can be repeated as
// necessary. The terminator for multiple message strings is a $00.
// Entry Values
// U = Message string pointer
// DP = $D0
// SIZRAS = ‘YX’ size of raster message
// Return Values
// A = $00
// B = $01
// X = $FBB4
// U = End of message string + 1

__NO_INLINE void _Print_List_chk(void* const u __UNUSED) // 0xF38C 
{
	asm volatile(
		"tfr x,u\n\t"
		"jsr ___Print_List_chk; BIOS call"
		::
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Display markers (counters remaining)
// List Description:
// byte 0 / 1 = positioning vector (Y:X)
// Entry Values
// A = ASCII code of symbol
// B = Number of markers remaining
// X = Pointer to screen position list
// DP = $D0
// SIZRAS = ‘YX’ size of raster message
// Return Values
// A = $03
// B = $01
// X = $FBB4
// U = Destroyed

__NO_INLINE __NAKED void _Print_Ships_x(const unsigned int b __UNUSED, const unsigned int a, void* const x __UNUSED) // 0xF391 
{
	asm volatile(
		"lda %[A]\n\t"
		"jmp ___Print_Ships_x; BIOS call"
		:: 	[A] "mi" (a)
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Display markers (counters remaining)
// List Description:
// byte 0 / 1 = positioning vector (Y:X)
// Entry Values
// A = ASCII code of symbol
// B = Number of markers remaining
// X = Pointer to screen position list
// DP = $D0
// SIZRAS = ‘YX’ size of raster message
// Return Values
// A = $03
// B = $01
// X = $FBB4
// U = Destroyed

__NO_INLINE __NAKED void _Print_Ships(const unsigned int b __UNUSED, const unsigned int a, const unsigned long int x __UNUSED) // 0xF393 
{
	asm volatile(
		"lda %[A]\n\t"
		"jmp ___Print_Ships; BIOS call"
		:: 	[A] "mi" (a)
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Display raster string as indicated by ‘U’
// Message List Description:
// byte 0 – n = Raster message string ($20 - $6F)
// n+1 = Raster terminator ($80)
// Entry Values
// U = Message string pointer
// DP = $DP
// SIZRAS = ‘YX’ size of raster message
// Return Values
// A = $03
// B = $01
// X = $FBB4
// U = End of message string + 1

__NO_INLINE void _Print_Str(void* const u __UNUSED) // 0xF495
{
	asm volatile(
		"tfr x,u\n\t"
		"jsr ___Print_Str; BIOS call"
		::
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Display raster string indicated by ‘MESAGE’
// Message List Description:
// byte 0 – n = Raster message string ($20 - $6F)
// n+1 = Raster terminator ($80)
// Entry Values
// DP = $D0
// MESAGE = Raster message string pointer
// SIZRAS = ‘YX’ size of raster message
// Return Values
// A = $03
// B = $01
// X = $FBB4
// U = End of message string + 1

__NO_INLINE void _Print_MRast(void) // 0xF498
{
	asm volatile(
		"jsr ___Print_MRast; BIOS call"
		::
		: "memory", "cc", "u");
}

// ***************************************************************************
// 5.3.1 DIFFY Style Drawing Routines

// A DIFFY style list contains a counted collection of relative (Y:X) coordinate pairs. When
// processing one of these, the drawing functions will draw a line from the current pen position to
// the first point in the list. A line is then drawn to the next relative coordinate, until no more points
// remain.

// Depending upon the function processing the list, the first byte may be expected to contain the
// ‘Vector count –1’, or this value may need to be stored into RAM.

// Depending upon the function processing the list, the second byte may be expected to contain the
// scale factor to be used when processing the list, or this value may need to be stored into RAM.

// A sample DIFFY list might look like the following:
// byte 0 - Vector count – 1 [optional]
// byte 1 - Scale factor [optional]
// bytes 2 / 3 - ‘Y:X’ for coordinate 1
// bytes n / n+1 - ‘Y:X’ for coordinate ‘n’
 
// DIFFAX 	0xF3CE 	--- 	Draw from 'DIFFY' style list
// DIFTIM 	0xF3D2 	--- 	Draw from 'DIFFY' style list
// DIFLST 	0xF3D6 	--- 	Draw from 'DIFFY' style list
// DIFTLS 	0xF3DA 	LDIFFY 	Draw from 'DIFFY' style list
// DIFFX 	0xF3D8 	TDIFFY 	Draw from 'DIFFY' style list
// DIFFY 	0xF3DD 	--- 	Draw from 'DIFFY' style list
// DIFFAB 	0xF3DF 	--- 	Draw from 'DIFFY' style list
// DASHE 	0xF433 	DSHDF1 	Draw dashed lines from 'DIFFY' list
// DASHEL 	0xF434 	DSHDF 	Draw dashed lines from 'DIFFY' list
// DASHY 	0xF437 	DASHDF 	Draw dashed lines from 'DIFFY' list
// DANROT 	0xF610 	DROT 	'DIFFY' style rotate
// DISROT 	0xF613 	BDROT 	'DIFFY' style rotate
// DIFROT 	0xF616 	ADROT 	'DIFFY' style rotate
// DANROT 	0xF610 	DROT 	'DIFFY' style rotate

// ---------------------------------------------------------------------------
// DSHDF1 (DASHE)  equ $F433
// Draw dashed lines according to ‘Diffy’ style list
// List Description:
// byte 0 / 1 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X)
// Entry Values
// A = Number of vectors
// X = ‘DIFFY’ list pointer
// DP = $D0
// DASH = Dash pattern
// T1LOLC = Vector length (scale factor)
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00
// Comments
// Execution of ‘CZERO’ is inconsistent !!!

__NO_INLINE __NAKED void _Draw_Pat_VL_aa(const unsigned int b __UNUSED, void* const x __UNUSED) // 0xF434
{
	asm volatile(
		"tfr b,a\n\t"
		"jmp ___Draw_Pat_VL_aa; BIOS call"
		::
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Draw dashed lines according to ‘Diffy’ style list
// List Description:
// byte 0 / 1 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X)
// Entry Values
// A = Number of vectors – 1
// X = “DIFFY’ list pointer
// DP = $D0
// DASH = Dash pattern
// T1LOLC = Vector length (scale factor)
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00
// Comments
// Execution of ‘CZERO’ is inconsistent !!!

__NO_INLINE __NAKED void _Draw_Pat_VL_a(const unsigned int b __UNUSED, void* const x __UNUSED) // 0xF434
{
	asm volatile(
		"tfr b,a\n\t"
		"jmp ___Draw_Pat_VL_a; BIOS call"
		::
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Draw a dashed version of the given ‘DIFFY’ list
// List Description:
// byte 0 / 1 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X) 
// Entry Values
// X = ‘DIFFY’ list pointer
// DP = $D0
// DASH = Dash pattern
// LIST = Number of vectors – 1
// T1LOLC = Vector length (scale factor)
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00
// Comments
// Execution of ‘CZERO’ is inconsistent!!!

#if 0
__NO_INLINE __NAKED void _Draw_Pat_VL(void* const x __UNUSED) // 0xF437
{
	asm volatile(
		"jmp ___Draw_Pat_VL; BIOS call"
		::
		: "memory", "cc");
}
#endif

#if 0
__NO_INLINE __NAKED void _Draw_Pat_VL_d(void* const x __UNUSED, const long unsigned int d) // 0xF439, not official
{
	asm volatile(
		"ldd %[D]\n\t"
		"jmp ___Draw_Pat_VL_d; BIOS call"
		:: 	[D] "mi" (d)
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw a single vector from the current beam position using the relative vector values
// given in ‘D’.
// Entry Values
// A = Relative ‘Y’ vector value
// B = Relative ‘X’ vector value
// DP = $D0
// LIST = $00
// T1LOLC = Vector length (scale factor)
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = Entry value + 2

__NO_INLINE __NAKED void _Draw_Line_d(const int b __UNUSED, const int a) // 0xF3DF
{
	asm volatile(
		"lda %[A]\n\t"
		"jmp ___Draw_Line_d; BIOS call"
		:: 	[A] "mi" (a)
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Draw from ‘Diffy’ style list
// List Description:
// byte 0 = Number of vectors - 1
// 1 / 2 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X)
// Entry Values
// X = ‘DIFFY’ list pointer
// DP = $D0
// T1LOLC = Vector length (scale factor)
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00

#if 0
__NO_INLINE __NAKED void _Draw_VLc(void* const x __UNUSED) // 0xF3CE
{
	asm volatile(
		"jmp ___Draw_VLc; BIOS call"
		:: 	[X] "mi" (x)
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw according to ‘Diffy’ style list
// List Description:
// Byte 0 / 1 = Vector #1 (Y:X)
// - .
// Byte n / n+ 1 = Vector #n (Y:X)
// Entry Values
// A = Number of vectors – 1
// B = Vector length (scale factor)
// X = “DIFFY” list pointer
// DP = $D0
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00

__NO_INLINE __NAKED void _Draw_VL_ab(const unsigned int b __UNUSED, const unsigned int a, void* const x __UNUSED) // 0xF3D8
{
	asm volatile(
		"lda %[A]\n\t"
		"jmp ___Draw_VL_ab; BIOS call"
		:: [A] "o" (a)
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Draw from ‘Diffy’ style list
// List Description:
// byte 1 / 2 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X)
// Entry Values
// X = “DIFFY’ list pointer
// DP = $D0
// LIST = Number of vectors – 1
// T1LOLC = Vector length (scale factor)
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00

#if 0
__NO_INLINE __NAKED void _Draw_VL(void* const x __UNUSED) // 0xF3DD
{
	asm volatile(
		"jmp ___Draw_VL; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw from ‘Diffy’ style list
// List Description:
// byte 0 = Number of vectors – 1
// 1 = Vector length (scale factor)
// 2 / 3 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X)
// Entry Values
// X = ‘DIFFY’ list pointer
// DP = $DO
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A – Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00

#if 0
__NO_INLINE __NAKED void _Draw_VLcs(void* const x) // 0xF3D6
{
	asm volatile(
		"jmp ___Draw_VLcs; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw from ‘Diffy’ style list
// List Description:
// byte 0 / 1 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X)
// Entry Values
// B = Vector length (scale factor)
// X = ‘DIFFY’ list pointer
// DP = $D0
// LIST = Number of vectors – 1
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00

#if 0
__NO_INLINE __NAKED void _Draw_VL_b(const unsigned int b __UNUSED, void* const x __UNUSED) // 0xF3D2
{
	asm volatile(
		"jmp ___Draw_VL_b; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw according ‘Diffy’ style list
// List Description:
// Byte 0 / 1 = Vector #1 (Y:X)
// - .
// Byte n / n+ 1 = Vector #n (Y:X)
// Entry Values
// A = Number of vectors – 1
// X = ‘DIFFY’ list pointer
// DP = $D0
// T1LOLC = Vector length (scale factor)
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00

__NO_INLINE __NAKED void _Draw_VL_a(const unsigned int b __UNUSED, void* const x __UNUSED) // 0xF3DA
{
	asm volatile(
		"tfr b,a\n\t"
		"jmp ___Draw_VL_a; BIOS call"
		::
		: "memory", "cc");
}

// ***************************************************************************
// 5.3.2. DUFFY Style Drawing Routines

// A DUFFY style list is identical to a DIFFY style list. The only difference appears to be in the way
// that it is processed. When processing one of these, the drawing functions will move to the first
// point in the list. It will then draw a line to the next relative coordinate, until no more points
// remain.

// DUFFAX 	0xF3AD 	--- 	Draw from 'DUFFY' style list
// DUFTIM	0xF3B1 	--- 	Draw from 'DUFFY' style list
// DUFLST 	0xF3B5 	DUFFX 	Draw from 'DUFFY' style list
// DUFTLS	0xF3B7  TDUFFY	Draw from 'DUFFY' style list
// DUFLSTAX	0xF3B9  LDUFFY	Draw from 'DUFFY' style list
// DUFFY 	0xF3BC 	--- 	Draw from 'DUFFY' style list
// DUFFAB 	0xF3BE 	--- 	Draw from 'DUFFY' style list

// ---------------------------------------------------------------------------
// Draw from ‘Duffy’ style list
// List Description:
// byte 0 = Number of vectors - 1
// 1 / 2 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X)
// Entry Values
// X = ‘DUFFY’ list pointer
// DP = $D0
// T1LOLC = Vector length (scale factor)
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00

#if 0
__NO_INLINE __NAKED void _Mov_Draw_VLc_a(void* const x __UNUSED) // 0xF3AD
{
	asm volatile(
		"jmp ___Mov_Draw_VLc_a; BIOS call"
		:: 	[X] "mi" (x)
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw from ‘Duffy’ style list
// List Description:
// byte 0 / 1 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X)
// Entry Values
// B = Vector length (scale factor)
// X = ‘DUFFY’ list pointer
// DP = $D0
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00

#if 0
__NO_INLINE __NAKED void _Mov_Draw_VL_b(const unsigned int b __UNUSED, void* const x __UNUSED) // 0xF3B1
{
	asm volatile(
		"jmp ___Mov_Draw_VL_b; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw from ‘Duffy’ style list
// List Description:
// byte 0 = Number of vectors – 1
// 1 = Vector length (scale factor)
// 2 / 3 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X)
// Entry Values
// X = ‘DUFFY’ list pointer
// DP = $D0
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00

#if 0
__NO_INLINE __NAKED void _Mov_Draw_VLcs(void* const x __UNUSED) // 0xF3B5
{
	asm volatile(
		"jmp ___Mov_Draw_VLcs; BIOS call"
		:: 	[X] "mi" (x)
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw according to ‘Duffy’ style list
// List Description:
// Byte 0 / 1 = Vector #1 (Y:X)
// - .
// Byte n / n+ 1 = Vector #n (Y:X)
// Entry Values
// A = Number of vectors – 1
// B = Vector length (scale factor)
// X = ‘DUFFY’ list pointer
// FP = $D0
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00

__NO_INLINE __NAKED void _Mov_Draw_VL_ab(const unsigned int b __UNUSED, const unsigned int a, void* const x __UNUSED) // 0xF3B7
{
	asm volatile(
		"lda %[A]\n\t"
		"jmp ___Mov_Draw_VL_ab; BIOS call"
		:: [A] "mi" (a)
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Draw according to ‘Duffy’ style list
// List Description:
// Byte 0 / 1 = Vector #1 (Y:X)
// - .
// Byte n / n+ 1 = Vector #n (Y:X)
// Entry Values
// A = Number of vectors – 1
// X = ‘DUFFY’ list pointer
// DP = $D0
// T1LOLC = Vector length (scale factor)
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00

__NO_INLINE __NAKED void _Mov_Draw_VL_a(const unsigned int b __UNUSED, void* const x __UNUSED) // 0xF3B9
{
	asm volatile(
		"tfr b,a\n\t"
		"jmp ___Mov_Draw_VL_a; BIOS call"
		::
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Draw from ‘Duffy’ style list
// List Description:
// byte 0 / 1 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X)
// Entry Values
// X = ‘DUFFY’ list pointer
// DP = $D0
// LIST = Number of vectors – 1
// T1LOLC = Vector length (scale factor)
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 2
// LIST = $00

#if 0
__NO_INLINE __NAKED void _Mov_Draw_VL(void* const x __UNUSED) // 0xF3BC
{
	asm volatile(
		"jmp ___Mov_Draw_VL; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Move a single vector from the current beam position using the relative vector values
// given in ‘D’
// Entry Values
// A = Relative ‘Y’ vector value
// B = Relative ‘X’ vector value
// DP = $D0
// LIST = $00
// T1LOLC = Vector length (scale factor)
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = Entry value + 2

__NO_INLINE __NAKED void _Mov_Draw_VL_d(const int b __UNUSED, const int a) // 0xF3BE
{
	asm volatile(
		"lda %[A]\n\t"
		"jmp ___Mov_Draw_VL_d; BIOS call"
		:: 	[A] "mi" (a)
		: "memory", "cc");
}

// ***************************************************************************
// 5.3.3 PACKET Style Drawing and Rotation Routines

// A PACKET style list is an uncounted list of (mode:Y:X) triplets. This type of packet is useful if
// you need to mix move and draw requests within the same list. The end of the list is indicated by
// the presence of a list terminator ($01).

// Depending upon the function processing the list, the first byte may be expected to contain the
// scale factor to be used when processing tlist, or this value may need to be stored into RAM.

// A sample PACKET list might look like the following:
// byte 0 - Scale factor
// bytes 1 / 2 / 3 - ‘mode:Y:X’ for coordinate 1
// bytes n / n+1 / n+2 - ‘mode:Y:X’ for coordinate ‘n’
// $01 - packet terminator
// where ‘mode’ can assume one of the following values:
// $00 - Move to the specified point
// $FF - Draw a line to the specified point

// DASHY3 	0xF46E 	DASHPK 	Draw dashed lines from 'PACKET' list
// PAC1X 	0xF408 	PACK1X 	Draw from 'PACKET' style list
// PAC2X 	0xF404 	PACK2X 	Draw from 'PACKET' style list
// PACB 	0xF40E 	TPACK 	Draw from 'PACKET' list
// PACKET 	0xF410 	--- 	Draw from 'PACKET' list
// PACXX 	0xF40C 	LPACK 	Draw from 'PACKET' style list
// POTATA 	0xF61F 	PROT 	'PACKET' style rotate
// POTATE 	0xF622 	APROT 	'PACKET' style rotate

// ---------------------------------------------------------------------------
// Draw dashed lines according to ‘Packet’ format
// List Description:
// Byte 0 / 1 / 2 = Vector #1 (C:Y:X)
// - - - -
// n / n+1 / n+2 = Vector #n (C:Y:X)
// n+3 = $01 (packet terminator)
// where C = $00 – draw blank line
// $01 – packet terminator
// $02 – draw solid line
// $FF – draw dashed line (uses ‘DASH’)
// Entry Values
// X = ‘PACKET’ list pointer
// DP = $D0
// DASH = Dash pattern
// LIST = $00
// T1LOLC = Vector length (scale factor)
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list + 1

#if 0
__NO_INLINE __NAKED void _Draw_VL_mode(void* const x __UNUSED) // 0xF46E
{
	asm volatile(
		"jmp ___Draw_VL_mode; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw according to ‘Packet’ style list
// List Description:
// Byte 0 / 1 / 2 = Vector #1 (C:Y:X)
// - - - -
// n / n+1 / n+2 = Vector #n (C:Y:X)
// n+3 = $01 (packet terminator)
// where C = $01 – packet terminator
// $00 – draw blank line
// $FF – draw solid line
// Entry Values
// X = ‘PACKET’ list pointer
// DP = $D0
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list
// Comments
// Uses 1x scale factor ($7F)

#if 0
__NO_INLINE __NAKED void _Draw_VLp_7F(void* const x __UNUSED) // 0xF408
{
	asm volatile(
		"jmp ___Draw_VLp_7F; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw according to ‘Packet’ style list
// List Description:
// Byte 0 / 1 / 2 = Vector #1 (C:Y:X)
// - - - -
// n / n+1 / n+2 = Vector #n (C:Y:X)
// n+3 = $01 (packet terminator)
// where C = $01 – packet terminator
// $00 – draw blank line
// $FF – draw solid line
// Entry Address = $F404
// Entry Values
// X = ‘PACKET’ list pointer
// DP = $D0
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list
// Comments
// Uses 2x scale factor ($FF)

#if 0
__NO_INLINE __NAKED void _Draw_VLp_FF(void* const x __UNUSED) // 0xF404
{
	asm volatile(
		"jmp ___Draw_VLp_FF; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw according to ‘Packet’ style list
// List Description:
// Byte 0 / 1 / 2 = Vector #1 (C:Y:X)
// - - - -
// n / n+1 / n+2 = Vector #n (C:Y:X)
// n+3 = $01 (packet terminator)
// where C = $01 – packet terminator
// $00 – draw blank line
// $FF – draw solid line
// Entry Values
// B = Vector length (scale factor)
// X = ‘PACKET’ list pointer
// FP = $D0
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list

#if 0
__NO_INLINE __NAKED void _Draw_VLp_b(const unsigned int b __UNUSED, void* const x __UNUSED) // 0xF40E
{
	asm volatile(
		"jmp ___Draw_VLp_b; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw according to ‘Packet’ style list
// List Description:
// Byte 0 / 1 / 2 = Vector #1 (C:Y:X)
// - - - -
// n / n+1 / n+2 = Vector #n (C:Y:X)
// n+3 = $01 (packet terminator)
// where C = $01 – packet terminator
// $00 – draw blank line
// $FF – draw solid line
// Entry Values
// X = ‘PACKET’ list pointer
// DP = $D0
// T1LOLC = Vector length (scale factor)
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list

#if 0
__NO_INLINE __NAKED void _Draw_VLp(void* const x __UNUSED) // 0xF410
{
	asm volatile(
		"jmp ___Draw_VLp; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Draw according to ‘Packet’ format
// List Description:
// Byte 0 = Vector length (scale factor)
// 1 / 2 / 3 = Vector #1 (C:Y:X)
// - - - -
// n / n+1 / n+2 = Vector #n (C:Y:X)
// n+3 = $01 (packet terminator)
// where C = $01 – packet terminator
// $00 – draw blank line
// $FF – draw solid line
// Entry Values
// X = ‘PACKET’ list pointer
// DP = $D0
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// A = Destroyed
// B = Destroyed
// X = End of list

#if 0
__NO_INLINE __NAKED void _Draw_VLp_scale(void* const x __UNUSED) // 0xF40C
{
	asm volatile(
		"jmp ___Draw_VLp_scale; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Rotate ‘Packet’ style list
// List Description:
// Byte 0 / 1 / 2 = Vector #1 (C:Y:X)
// - - - -
// n / n+1 / n+2 = Vector #n (C:Y:X)
// n+3 = $01 (packet terminator)
// Entry Values
// A = Rotation angle
// X = ‘Packet’ list pointer
// U = Destination buffer pointer
// Return Values
// A = ‘Packet’ terminator value
// B = Destroyed
// X = End of ‘Packet’ list + 1
// U = End of destination buffer + 1
// LIST = $00

__NO_INLINE void _Rot_VL_Mode(const unsigned int a __UNUSED, void* const x __UNUSED, volatile void* volatile const u) // 0xF61F 
{
	asm volatile(
		"tfr b,a\n\t"
		"ldu %[U]\n\t"
		"jsr ___Rot_VL_Mode; BIOS call"
		:: [U] "mi" (u)
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Rotate ‘Packet’ style list
// List Description:
// Byte 0 / 1 / 2 = Vector #1 (C:Y:X)
// - - - -
// n / n+1 / n+2 = Vector #n (C:Y:X)
// n+3 = $01 (packet terminator)
// Entry Values
// X = ‘Packet’ list pointer
// U = Destination buffer pointer
// ANGLE = Angle of rotation ($00 - $3F)
// Return Values
// A = ‘Packet’ terminator value
// B = Destroyed
// X = End of ‘Packet’ list + 1
// U = End of destination buffer + 1
// LIST = $00

__NO_INLINE void _Rot_VL_Pack(void* const x __UNUSED, void* const u) // 0xF622
{
	asm volatile(
		"ldu %[U]\n\t"
		"jsr ___Rot_VL_Pack; BIOS call"
		:: [U] "mi" (u)
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Rotate ‘Packet’ style list
// List Description:
// Byte 0 / 1 / 2 = Vector #1 (C:Y:X)
// - - - -
// n / n+1 / n+2 = Vector #n (C:Y:X)
// n+3 = $01 (packet terminator)
// Entry Values
// A = Rotation angle
// X = ‘Packet’ list pointer
// U = Destination buffer pointer
// Return Values
// A = ‘Packet’ terminator value
// B = Destroyed
// X = End of ‘Packet’ list + 1
// U = End of destination buffer + 1
// LIST = $00

__NO_INLINE void _Rot_VL_M_dft(void* const x __UNUSED, void* const u) // 0xF62B 
{
	asm volatile(
		"ldu %[U]\n\t"
		"jsr ___Rot_VL_M_dft; BIOS call"
		:: [U] "mi" (u)
		: "memory", "cc", "u");
}

// ***************************************************************************
// 5.4 Unknown

// NIBBY 	0xFF9F 	--- 	Draw vector grid list

#if 0
__NO_INLINE void _Draw_Grid_VL(void* const x __UNUSED, void* const y) //0xFF9F, not official
{
	asm volatile(
		"ldy %[Y]\n\t"
		"jsr ___Draw_Grid_VL; BIOS call"
		:: [Y] "mi" (y)
		: "memory", "cc", "y");
}
#endif

// ***************************************************************************
// 6. Mathematical Functions

// RAND3 	0xF511 	--- 	Calculate new random number
// RANDOM 	0xF517 	--- 	Calculate new random number

// BITE 	0xF57E 	DECBIT 	Decode bit position

// ABSVAL 	0xF584 	ABSAB 	Form absolute value for 'A' & 'B' registers
// AOK 		0xF58B 	ABSB 	Form absolute value for 'B' register

// COMPAS 	0xF593 	CMPASS 	Return angle for given delta 'Y:X'
// COSGET 	0xF5D9 	COSINE 	Calculate the cosine of 'A'
// SINGET 	0xF5DB 	SINE 	Calculate the sine of 'A'
// SINCOS 	0xF5EF 	--- 	Calculate the sine and cosine of 'ANGLE'

// RSINA 	0xF65B 	MSINE 	Multiply 'A' by previous sine value
// RSIN 	0xF65D 	LSINE 	Multiply 'LEG' by previous sine value
// RCOSA 	0xF661 	MCSINE 	Multiply 'A' by previous cosine value
// RCOS 	0xF663 	LCSINE 	Multiply 'LEG' by previous cosine value

// ---------------------------------------------------------------------------
// Generate random number
// Entry Values
// No register parameters required
// SEED = Random number pointer (Normally ‘RANCID’)
// Return Values
// A = Random number

__NO_INLINE unsigned int _Random_3(void) // 0xF511 
{
	asm volatile(
		"jsr ___Random_3; BIOS call\n\t"
		"tfr a,b"
		:
		:
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Generate random number
// Entry Values
// No register parameters required
// SEED = Random number pointer (Normally ‘RANCID’)
// Return Values
// A = Random number

__NO_INLINE unsigned int _Random(void) // 0xF517
{
	asm volatile(
		"jsr ___Random; BIOS call\n\t"
		"tfr a,b"
		:
		:
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Decode bit position
// Entry Values
// A = Bit number ($00 - $07)
// Return Values
// A = Result as below
// ‘A’ Value Returned
// $00 $01
// $01 $02
// $02 $04
// $03 $08
// $04 $10
// $05 $20
// $06 $40
// $07 $80
// X = $F9DC (#DECTBL)

__NO_INLINE unsigned int _Bitmask_a(const unsigned int b __UNUSED) // 0xF57E
{
	asm volatile(
		"tfr b,a\n\t"
		"jsr ___Bitmask_a; BIOS call\n\t"
		"tfr a,b"
		:
		:
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Form the absolute value of registers ‘A’ & ‘B’.
// Entry Values
// A = Value to be made positive
// B = Value to be made positive
// Return Values
// A = Absolute value of entry ‘A’
// B = Absolute value of entry ‘B’
// Comments
// An entry value of $80 will not evaluate properly

__NO_INLINE long unsigned int _Abs_a_b(const int b __UNUSED, const int a) // 0xF584
{
	asm volatile(
		"lda %[A]\n\t"
		"jsr ___Abs_a_b; BIOS call\n\t"
		"tfr d,x"
		:
		: [A] "mi" (a)
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Form the absolute value of register ‘B’
// Entry Values
// B = Value to be made positive
// Return Values
// B = Absolute value of entry ‘B’
// Comments
// An entry value of $80 will not evaluate properly

#if 0
__INLINE int Abs_b(const int b __UNUSED) // 0xF58B
{
	int r;
	asm volatile(
		"jsr ___Abs_b; BIOS call\n\t"
		"stb %[R]\n\t"
		: [R] "=m" (r)
		:
		: "memory", "cc", "b");
	return r;
}
#endif

// ---------------------------------------------------------------------------
// Return angle for given delta ‘Y:X’
// Entry Values
// A = Delta ‘Y’
// B = Delta ‘X’
// DP = $F
// Return Values
// A = Angle for given delta ‘Y:X’
// B = Angle for given delta ‘Y:X’ (same as exit ‘A’)
// ANGLE = Angle for given delta ‘Y:X’ (same as exit ‘A’)

__INLINE long unsigned int Rise_Run_Angle(const int b __UNUSED, const int a) // 0xF593
{
	asm volatile(
		"lda %[A]\n\t"
		"jsr ___Rise_Run_Angle; BIOS call\n\t"
		"tfr d,x"
		:
		: [A] "mi" (a)
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Calculate the cosine of ‘A’
// Entry Values
// A = Angle to be evaluated
// Return Values
// A = Cosine of given angle
// B = Sign / overflow for resulting cosine
// X = $FC6D (#RTRIGS)

__INLINE long unsigned int Get_Rise_Idx(const int b __UNUSED) // 0xF5D9
{
	asm volatile(
		"tfr b,a\n\t"
		"jsr ___Get_Rise_Idx; BIOS call\n\t"
		"tfr d,x"
		:
		:
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Calculate SINE of value given in ‘A’
// Entry Values
// A = Angle to be evaluated
// Return Values
// A = Sine of given angle
// B = Sign / overflow for resulting sine
// X = $FC6D (#RTRIGS)

__NO_INLINE int _Xform_Sin(const int b __UNUSED) // 0xF5DB
{
	asm volatile(
		"tfr b,a\n\t"
		"jsr ___Xform_Sin; BIOS call\n\t"
		"tfr a,b"
		:
		:
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Calculate COSINE and SINE of ‘ANGLE’
// Entry Values
// DP = $C8
// ANGLE = Angle of rotation ($00 - $3F)
// Return Values
// D = Cosine of given angle
// WCSINE = .
// WSINE = .

__NO_INLINE long unsigned int _Get_Rise_Run(void) // 0xF5EF
{
	asm volatile(
		"jsr ___Get_Rise_Run; BIOS call\n\t"
		"tfr d,x"
		:
		: 
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Multiply ‘A’ by previous sine value
// Entry Values
// A = Multiplier
// DP = $C8
// WSINE = Previous sine result
// Return Values
// A = Product of ‘A’ * WSINE
// B = Contents of WSINE + 1
// LEG = Entry ‘A’ value

__NO_INLINE long unsigned int _Xform_Run_a(const int b __UNUSED) // 0xF65B 
{
	asm volatile(
		"tfr b,a\n\t"
		"jsr ___Xform_Run_a; BIOS call\n\t"
		"tfr d,x"
		:
		:
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Multiply ‘LEG’ by previous sine value
// Entry Values
// DP = $C8
// LEG = Multiplier
// WSINE = Previous Sine result
// Return Values
// A = Product of LEG * WSINE
// B = Contents of WSINE + 1

__NO_INLINE int _Xform_Run(void) // 0xF65D 
{
	asm volatile(
		"jsr ___Xform_Run; BIOS call\n\t"
		"tfr a,b"
		:
		: 
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Multiply ‘A’ by previous cosine value
// Entry Values
// A = Multiplier
// DP = $C8
// WCSINE = Previous cosine result
// Return Values
// A = Product of ‘A’ * WCSINE
// B = Contents of WCSINE + 1
// LEG = Entry ‘A’ value

__NO_INLINE int _Xform_Rise_a(const int b __UNUSED) // 0xF661 
{
	asm volatile(
		"tfr b,a\n\t"
		"jsr ___Xform_Rise_a; BIOS call\n\t"
		"tfr a,b"
		:
		:
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Multiply ‘LEG’ by previous cosine value
// Entry Values
// DP = $C8
// LEG = Multiplier
// WCSINE = Previous cosine result
// Return Values
// A = Product of LEG * WCSINE
// B = Contents of WCSINE + 1

__NO_INLINE int _Xform_Rise(void) // 0xF663 
{
	asm volatile(
		"jsr ___Xform_Rise; BIOS call\n\t"
		"tfr a,b"
		:
		: 
		: "memory", "cc");
}

// ***************************************************************************
// 7.1 Memory Management - Memory Clear Functions

// CLRSON 	0xF53F 	BCLR 	Clear 'B' bytes
// CLRMEM 	0xF542 	CLREX 	Clear 256 bytes starting at 0xC800
// CLR256 	0xF545 	---6 	Set-up to clear 256 bytes
// GILL 	0xF548 	CLRBLK 	Clear a block of memory

// ---------------------------------------------------------------------------
// Clear ‘B’ bytes starting at value in ‘X’
// Entry Values
// B = Number of bytes to be cleared
// X = buffer pointer
// Return Values
// A = $FF
// B = $FF

#if 0
__NO_INLINE __NAKED void _Clear_x_b(const unsigned int b, void* const x) // 0xF53F
{
	asm volatile(
		"jmp ___Clear_x_b; BIOS call"
		: 
		:
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Clear executive area of memory ($C800 - $C8FF)
// Entry Values
// None required
// Return Values
// D = $FFFF
// X = $C800

#if 0
__NO_INLINE __NAKED void _Clear_C8_RAM(void) // 0xF542, never used by GCE carts?
{
	asm volatile(
		"jmp ___Clear_C8_RAM; BIOS call"
		: 
		:
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Clear 256 bytes starting at ‘X’
// Entry Values
// X = Buffer pointer
// Return Values
// D = $FFFF

#if 0
__NO_INLINE __NAKED void _Clear_x_256(void* const x __UNUSED) // 0xF545
{
	asm volatile(
		"jmp ___Clear_x_256; BIOS call"
		: 
		:
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Clear a block of memory
// Entry Values
// D = Number of bytes to be cleared
// X = Buffer pointer
// Return Values
// D = $FFFF

__NO_INLINE __NAKED void _Clear_x_d(void* const x __UNUSED, const long unsigned int d) // 0xF548
{
	asm volatile(
		"ldd %[D]\n\t"
		"jmp ___Clear_x_d; BIOS call"
		: 
		: [D] "mi" (d)
		: "memory", "cc", "d");
}

// ***************************************************************************
// 7.2 Memory Management - Memory Copy Functions

// BAGAUX 	0xF67F 	BLKMV1 	Xfer bytes source to destination buffer
// STFAUX 	0xF683 	BLKMOV 	Xfer bytes source to destination buffer

// ---------------------------------------------------------------------------
// Transfer ‘A’ + 1 bytes from source to destination buffer
// Entry Values
// A = Number of (bytes – 1) to be transferred ($00 - $7F)
// X = Destination buffer pointer
// U = Source buffer pointer
// Return Values
// A = $FF
// B = Contents of last byte transferred

__NO_INLINE void _Move_Mem_a_1(const unsigned int b __UNUSED, void* const x __UNUSED, void* const u) // 0xF67F 
{
	asm volatile(
		"tfr b,a\n\t"
		"ldu %[U]\n\t"
		"jsr ___Move_Mem_a_1; BIOS call"
		: 
		: [U] "mi" (u)
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Transfer ‘A’ bytes from source to destination buffer
// Entry Values
// A = Number of bytes to be transfered ($00 - $7F)
// X = Destination buffer pointer
// U = Source buffer pointer
// Return Values
// A = $FF
// B = Contents of last byte transferred

__NO_INLINE void _Move_Mem_a(const unsigned int b __UNUSED, void* const x __UNUSED, void* const u) // 0xF683
{
	asm volatile(
		"tfr b,a\n\t"
		"ldu %[U]\n\t"
		"jsr ___Move_Mem_a_1; BIOS call"
		: 
		: [U] "mi" (u)
		: "memory", "cc", "u");
}

// ***************************************************************************
// 7.3 Memory Management - Memory Fill Functions

// NEGSOM 	0xF550 	CLR80 	Set a block of memory to $80
// FILL 	0xF552 	BLKFIL 	Set a block of memory

// ---------------------------------------------------------------------------
// Set a block of memory starting at ‘X’ to value $80
// Entry Values
// B = Number of bytes to be set ($01 - $7F)
// X = buffer pointer
// Return Values
// A = $80
// B = $00

#if 0
__NO_INLINE __NAKED void _Clear_x_b_80(const int b __UNUSED, void* const x __UNUSED) // 0xF550
{
	asm volatile(
		"jmp ___Clear_x_b_80; BIOS call"
		: 
		: 
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Set a block of memory starting at ‘X’
// Entry Values
// A = Data to be written
// B = number of bytes to be written
// X = Buffer pointer
// Return Values
// B = $00

__NO_INLINE __NAKED void _Clear_x_b_a(const unsigned int b __UNUSED, const unsigned int a, void* const x __UNUSED) // 0xF552
{
	asm volatile(
		"lda %[A]\n\t"
		"jmp ___Clear_x_b_a; BIOS call"
		: 
		: [A] "mi" (a)
		: "memory", "cc");
}

// ***************************************************************************
// 8. Controller / Joystick Routines

// ENPUT 	0xF1B4 	DBNCE 	Read controller buttones
// INPUT 	0xF1BA 	--- 	Read controller buttones
// PBANG4 	0xF1F5 	JOYSTK 	Read joystick
// PANG 	0xF1F8 	JOYBIT 	Read joystick

// ---------------------------------------------------------------------------
// Read controller switches and debounce switch status.
// Entry Values
// A = Direct response switch mask
// DP = $D0
// Return Values
// A = Contents of ‘EDGE’
// B = $00
// X = $C81A (#KEY7 + 1)

__NO_INLINE __NAKED void _Read_Btns_Mask(const unsigned int b __UNUSED) // 0xF1B4
{
	asm volatile(
		"tfr b,a\n\t"
		"jmp ___Read_Btns_Mask; BIOS call"
		:
		:
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Read the status of controll buttons.
// Entry Values
// DP = $D0
// Return Values
// A = Contents of ‘EDGE’
// B = $00
// X = $C81A (#KEY7 + 1)

#if 0
__NO_INLINE __NAKED void _Read_Btns(void) // 0xF1BA
{
	asm volatile(
		"jmp ___Read_Btns; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Read the absolute position of the controller joysticks.
// Entry Values
// DP = $D0
// EPOT0 = $01 ($00 to disable) – Controller #1: Right / Left
// EPOT1 = $03 ($00 to disable) – Controller #1: Up / Down
// EPOT2 = $05 ($00 to disable) – Controller #2: Right / Left
// EPOT3 = $07 ($00 to disable) – Controller #2: Up / Down
// LIST = $00
// POTRES = Joystick resolution limit, where
// $00 – 8 bits (default)
// $01 – 7 bits
// $02 – 6 bits
// $04 – 5 bits
// $08 – 4 bits
// $10 – 3 bits
// $20 – 2 bits
// $40 – 1 bit
// Return Values
// A = $01
// B = Contents of ‘POT3’
// X = $C823 (#LIST)
// LIST = $00
// POT0 = Controller #1: Right / Left
// POT1 = Controller #1: Up / Down
// POT2 = Controller #2: Right / Left
// POT3 = Controller #2: Up / Down

#if 0
__NO_INLINE __NAKED void _Joy_Analog(void) //0xF1F5
{
	asm volatile(
		"jmp ___Joy_Analog; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Read the UP / DOWN, RIGHT / LEFT status of the controller joysticks
// Entry Values
// DP = $D0
// EPOT0 = $01 ($00 to disable) – Controller #1: Right / Left
// EPOT1 = $03 ($00 to disable) – Controller #1: Up / Down
// EPOT2 = $05 ($00 to disable) – Controller #2: Right / Left
// EPOT3 = $07 ($00 to disable) – Controller #2: Up / Down
// LIST = $00 - $7F
// POTRES = Joystick resolution limit
// Return Values
// A = $01
// B = Contents of ‘POT3’
// X = $C823 (#LIST)
// LIST = $00
// POT0 = Controller #1: Right / Left
// POT1 = Controller #1: Up / Down
// POT2 = Controller #2: Right / Left
// POT3 = Controller #2: Up / Down
// where:
// < 0 – joystick is left or down
// = 0 – joystick is centered
// > 0 – joystick is right or up

#if 0
__NO_INLINE __NAKED void _Joy_Digital(void) // 0xF1F8
{
	asm volatile(
		"jmp ___Joy_Digital; BIOS call"
		::
		: "memory", "cc");
}
#endif

/* Read_Btns:  reads the button states on the two joysticks, and return their state 
   in the following RAM locations:
   joystick 1, (In low nybble = 0x0f, of 0xC80F..0xC811 )
   button 1: 0xC812 = 0x01
   button 2: 0xC813 = 0x02
   button 3: 0xC814 = 0x04
   button 4: 0xC815 = 0x08
   joystick 2, (In High nybble = 0xf0, of 0xC80F..0xC811 )
   button 1: 0xC816 = 0x10
   button 2: 0xC817 = 0x20
   button 3: 0xC818 = 0x40
   button 4: 0xC819 = 0x80
  0xC80F: Contains current state of all buttons 1 = depressed, 0 = not depressed
  0xC810: Contains state of all buttons from LAST time these routines were called; 
  0xC811: Contains the same information as 0xC812-0xC819 
  A 1 will only be returned if the button has transitioned to being pressed. DP=D0 */

/* Read_Btns_mask: Like Read_Btns but only returning the bits set to 1 in the mask */

/* Joy_Analog read the current positions of the two joysticks. The joystick enable 
   flags (C81F-C822) must be initialized to one of the following values:
  0 - ignore; return no value.
  1 - return state of console 1 left/right position.
  3 - return state of console 1 up/down position.
  5 - return state of console 2 left/right position.
  7 - return state of console 2 up/down position.
   The joystick values are returned in 0xC81B-0xC81E, where the value returned in 0xC81B 
   corresponds to the mask set in in 0xC81F, and so on and so forth. 
   A successive approximation algorithm is used to read the actual value of the joystick 
   pot, a signed value. In this case, 0xC81A must be set to a power of 2, to to control 
   conversion resolution; 0x80 is least accurate, and 0x00 is most accurate. */

/* Joy_Digital: Same principle as for Joy_Analog but the return values in 0xC81B-0xC81E:
< 0 if joystick is left of down of center.
= 0 if joystick is centered.
> 0 if joystick is right or up of center.*/

// ***************************************************************************
// 9. Player Option Functions

// OPTION 	0xF7A9 	SELOPT 	Fetch game options
// DISOPT	0xF835	------	Display game option, inofficial!

// ---------------------------------------------------------------------------
// Fetch number of players and options from player
// Entry Values
// A = Number of possible players (0 – 9)
// B = Number of possible options (0 – 9)
// Return Values
// A = Destroyed
// B = Destroyed
// X = Destroyed
// Y = Destroyed
// U = Destroyed
// LIST = $00
// PLAYRS = Number of players selected
// OPTION = Number of options selected

__NO_INLINE void _Select_Game(const unsigned int b __UNUSED, const unsigned int a) // 0xF7A9
{
	asm volatile(
		"lda %[A]\n\t"
		"jsr ___Select_Game; BIOS call"
		:: [A] "mi" (a)
		: "memory", "cc", "a", "x", "y", "u");
}

// ---------------------------------------------------------------------------
// Displays player or game option string with the current value
// Entry Values
// DP = $D0
// A = the option value
// Y = points to the string block
// rel y, rel x, ( for value )
// rel y, rel x, ( for option string)
// option string, 0x80
// Return Values
// D, U, X trashed

__NO_INLINE void _Display_Option(const unsigned int b __UNUSED, const void* const x __UNUSED) // 0xF835 - inofficial!
{
	asm volatile(
		"tfr b,a\n\t"
		"tfr x,y\n\t"
		"jsr ___Display_Option; BIOS call"
		::
		: "memory", "cc", "d", "x", "y", "u");
}

// ***************************************************************************
// 10. Reset and Initialization Routines

// POWER 	0xF000 	PWRUP 	Power-up handler
// INITPIA 	0xF14C 	INTPIA 	Initialize PIA
// INITMSC 	0xF164 	INTMSC 	Initialize misc. parameters
// INITALL 	0xF18B 	INTALL 	Full Vectrex initialization
// INITPSG 	0xF272 	INTPSG 	Initialize sound generator
// IREQ 	0xF533 	INTREQ 	Initialize the 'REQZ' area

#if 0
__NO_INLINE __NAKED void _Reset(void) // 0xF000
{
	asm volatile(
		"jmp ___Reset; BIOS call"
		:: 
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Initialize the programmable interface adapter (PIA).
// Entry Values
// No register parameters required
// FRMTIM = Frame to frame interval
// Return Values
// A = $03
// B = $01
// X = $F9F4 (#KEPALV + 4)
// DP = $D0
// Comments
// Zeroes the integrators and sets active ground on return to user.

#if 0
__NO_INLINE __NAKED void _Init_VIA(void) // 0xF14C
{
	asm volatile(
		"jmp ___Init_VIA; BIOS call"
		:: 
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Initialize misc. executive parameters
// Entry Values
// None required
// Return Values
// A = $05
// B = $07
// X = $C800 (#REG0)
// DP = $C8
// RAM between REG0 [$C800] and OPTION [$C87A] (inclusive) are cleared ($00)
// DWELL = $05 (Dot ‘ON’ time)
// EPOT0 = $01 (Enable – Controller #1: Right / Left)
// EPOT1 = $03 (Enable – Controller #1: Up / Down)
// EPOT2 = $05 (Enable – Controller #2: Right / Left)
// EPOT3 = $07 (Enable – Controller #2: Up / Down)
// FRMTIM = $3075 (#MSEC20 – 50 Hertz frame rate)
// RANCID = Non zero
// SEED = $C87D (#RANCID)

#if 0
__NO_INLINE __NAKED void _Init_OS_RAM(void) // 0xF164
{
	asm volatile(
		"jmp ___Init_OS_RAM; BIOS call"
		:: 
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Initialize the Vectrex hardware and executive parameters.
// Entry Values
// None required
// Return Values
// A = $3F
// B = $FF
// X = $C83F (#REQ0)
// DP = $D0
// RAM between REG0 [$C800] and OPTION [$C87A] (inclusive) are cleared ($00)
// DWELL = $05 (Dot ‘ON’ time)
// EPOT0 = $01 (Enable – Controller #1: Right / Left)
// EPOT1 = $03 (Enable – Controller #1: Up / Down)
// EPOT2 = $05 (Enable – Controller #2: Right / Left)
// EPOT3 = $07 (Enable – Controller #2: Up / Down)
// FRMTIM = $3075 (#MSEC20 – 50 Hertz frame rate)
// RANCID = Non zero
// SEED = $C87D (#RANCID)
// Comments
// Zeroes the integrators and sets active ground on return to user.

#if 0
__NO_INLINE __NAKED void _Init_OS(void) // 0xF18B
{
	asm volatile(
		"jmp ___Init_OS; BIOS call"
		:: 
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Initialize the ‘REQx’ area (sound mirror).
// Entry Values
// None required
// Return Values
// A = $3F
// B = $FF
// X = $C83F (#REQ0)
// REQ0 – REQ5, REQ7 – REQD = $00
// REQ6 = $3F

#if 0
__NO_INLINE __NAKED void _Init_Music_Buf(void) // 0xF533
{
	asm volatile(
		"jmp ___Init_Music_Buf; BIOS call"
		:: 
		: "memory", "cc");
}
#endif

/* Init_VIA: This routine is invoked during powerup, to initialize the VIA chip. 
   Among other things, it initializes the scale factor to 0x7F, and sets up the 
   direction for the port A and B data lines. DP=D0 */

/* Init_OS_RAM: This routine first clears the block of RAM in the range 0xC800 
   to 0xC87A, and then it initializes the dot dwell time, the refresh time, and 
   the joystick enable flags. DP=C8 */

/* Init_OS: This routine is responsible for setting up the initial system state, 
   each time the system is either reset or powered up. It will initialize the 
   OS RAM area, initialize the VIA chip, and then clear all the registers on the 
   sound chip. DP=D0 */ 

// ***************************************************************************
// 11. Score / Highscore Routines

// SCLR 	0xF84F 	--- 	Clear indicated score
// SHADD 	0xF85E 	BYTADD 	Add contents of 'A' to indicated score
// SADD 	0xF87C 	SCRADD 	Add contents of 'B' to indicated score
// WINNER 	0xF8C7 	--- 	Determine highest score
// HIGHSCR 	0xF8D8 	HISCR 	Calculate high score and save for logo

// ---------------------------------------------------------------------------
// Clear indicated score field
// ASCII Score Field Description
// byte 0 = Hundred thousand digit ($20, $30 - $39)
// 1 = Ten thousand digit ($20, $30 - $39)
// 2 = One thousand digit ($20, $30 - $39)
// 3 = Hundreds digit ($20, $30 - $39)
// 4 = Tens digit ($20, $30 - $39)
// 5 = Ones digit ($30 - $39)
// 6 = Score field terminator ($80)
// Entry Values
// X = Score field pointer
// Return Values
// A = $30
// B = $80

#if 0
__NO_INLINE __NAKED void _Clear_Score(void* const x __UNUSED) //0xF84F
{
	asm volatile(
		"jmp ___Clear_Score; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Add contents of ‘A’ to indicated score
// ASCII Score Field Description
// byte 0 = Hundred thousand digit ($20, $30 - $39)
// 1 = Ten thousand digit ($20, $30 - $39)
// 2 = One thousand digit ($20, $30 - $39)
// 3 = Hundreds digit ($20, $30 - $39)
// 4 = Tens digit ($20, $30 - $39)
// 5 = Ones digit ($30 - $39)
// 6 = Score field terminator ($80)
// Entry Values
// A = 2-digit BCD number
// X = Score field pointer
// LIST = $00
// Return Values
// A = Destroyed
// B = Destroyed
// U = 4-digit BCD extension of entry ‘A’

__NO_INLINE void _Add_Score_a(const unsigned int b __UNUSED, void* const x __UNUSED) // 0xF85E
{
	asm volatile(
		"tfr b,a\n\t"
		"jsr ___Add_Score_a; BIOS call"
		::
		: "memory", "cc", "a", "u");
}

// ---------------------------------------------------------------------------
// Add indicated BCD value to score field
// ASCII Score Field Description
// byte 0 = Hundred thousand digit ($20, $30 - $39)
// 1 = Ten thousand digit ($20, $30 - $39)
// 2 = One thousand digit ($20, $30 - $39)
// 3 = Hundreds digit ($20, $30 - $39)
// 4 = Tens digit ($20, $30 - $39)
// 5 = Ones digit ($30 - $39)
// 6 = Score field terminator ($80)
// Entry Values
// D = 4-digit BCD number
// X = Score field pointer
// LIST = $00
// Return Values
// A = Destroyed
// B = Destroyed

__NO_INLINE __NAKED void _Add_Score_d(void* const x __UNUSED, const long unsigned int d) // 0xF87C
{
	asm volatile(
		"ldd %[D]\n\t"
		"jmp ___Add_Score_d; BIOS call"
		:: 	[D] "mi" (d)
		: "memory", "cc");
}

// ---------------------------------------------------------------------------

#if 0
__NO_INLINE __NAKED void _Strip_Zeros(const unsigned int b __UNUSED, void* const x __UNUSED) // 0xF8B7
{
	asm volatile(
		"jmp ___Strip_Zeros; BIOS call"
		:: 	
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Compare two score fields
// ASCII Score Field Description
// byte 0 = Hundred thousand digit ($20, $30 - $39)
// 1 = Ten thousand digit ($20, $30 - $39)
// 2 = One thousand digit ($20, $30 - $39)
// 3 = Hundreds digit ($20, $30 - $39)
// 4 = Tens digit ($20, $30 - $39)
// 5 = Ones digit ($30 - $39)
// 6 = Score field terminator ($80)
// Entry Values
// X = Score field #1
// U = Score field #2
// Return Values
// A = $00 – Score #1 = Score #2
// $01 – Score #1 > Score #2
// $02 – Score #1 < Score #2
// B = Destroyed
// X = Destroyed
// U = Destroyed

__NO_INLINE unsigned int _Compare_Score(void* const x __UNUSED, void* const u) // 0xF8C7
{
	asm volatile(
		"ldu %[U]\n\t"
		"jsr ___Compare_Score; BIOS call\n\t"
		"tfr a,b"
		:
		: [U] "mi" (u)
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Calculate high score and save for opening logo
// ASCII Score Field Description
// byte 0 = Hundred thousand digit ($20, $30 - $39)
// 1 = Ten thousand digit ($20, $30 - $39)
// 2 = One thousand digit ($20, $30 - $39)
// 3 = Hundreds digit ($20, $30 - $39)
// 4 = Tens digit ($20, $30 - $39)
// 5 = Ones digit ($30 - $39)
// 6 = Score field terminator ($80)
// Entry Values
// X = Score field pointer
// U = High score field pointer
// Return Values
// A = Destroyed
// B = Destroyed
// X = Destroyed
// U = Destroyed

__NO_INLINE void _New_High_Score(void* const x __UNUSED, void* const u) //0xF8D8
{
	asm volatile(
		"ldu %[U]\n\t"
		"jsr ___New_High_Score; BIOS call"
		:: [U] "mi" (u)
		: "memory", "cc", "u");
}

// ***************************************************************************
// 12. Sound Functions
 
// PSGX 	0xF256 	WRREG 	Write to PSG
// PSG 		0xF259 	WRPSG 	Write to PSG
// INITPSG 	0xF272 	INTPSG 	Initialize sound generator
// PSGLUP 	0xF27D 	PSGLST 	Send sound string to PSG
// PSGULP 	0xF284 	PSGMIR 	Send sound string to PSG
// REQOUT 	0xF289 	--- 	Send 'REQX' to PSG and mirror
// REPLAY 	0xF687 	--- 	Set 'REQX' for given tune
// SPLAY 	0xF68D 	--- 	Set 'REQX' for given tune
// SOPLAY 	0xF690 	ASPLAY 	Set 'REQX' for given tune
// YOPLAY 	0xF692 	TPLAY 	Set 'REQX' for given tune
// XPLAY 	0xF742 	--- 	Set 'REQX' for given tune
// AXE 		0xF92E 	EXPLOD 	Complex explosion sound effect
// LOUDIN 	0xF9CA 	SETAMP 	Complex explosion sound effect

// ---------------------------------------------------------------------------
// Write to PSG and indicated mirror
// Entry Values
// A = PSG address ($00 - $0D)
// B = PSG data
// X = Pointer to user mirror area
// DP = $D0
// Return Values
// B = $01

__NO_INLINE __NAKED void _Sound_Byte(const unsigned int b __UNUSED, const unsigned int a) // 0xF256
{
	asm volatile(
		"lda %[A]\n\t"
		"jmp ___Sound_Byte; BIOS call"
		:: [A] "mi" (a)
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Write to PSG and indicated mirror
// Entry Values
// A = PSG address ($00 - $0D)
// B = PSG data
// X = Pointer to user mirror area
// DP = $D0
// Return Values
// B = $01

__NO_INLINE __NAKED void _Sound_Byte_x(const unsigned int b __UNUSED, const unsigned int a, void* const x __UNUSED) // 0xF259 
{
	asm volatile(
		"lda %[A]\n\t"
		"jmp ___Sound_Byte_x; BIOS call"
		:: 	[A] "mi" (a)
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Initialize programmable sound generator (PSG).
// Entry Values
// DP = $D0
// Return Values
// A = $3F
// B = $FF
// X = $C83F (#REQ0)

#if 0
__NO_INLINE __NAKED void _Clear_Sound(void) // 0xF272 
{
	asm volatile(
		"jmp ___Clear_Sound; BIOS call"
		:: 	
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Send sound string to PSG and mirror
// Entry Values
// U = Pointer to sound string
// DP = $D0
// Return Values
// D = Sound string terminator
// X = $C800 (#REG0)
// U = Points to end of sound string

__NO_INLINE void _Sound_Bytes(void* const x __UNUSED) // 0xF27D 
{
	asm volatile(
		"tfr x,u\n\t"
		"jsr ___Sound_Bytes; BIOS call"
		::
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Send sound string to PSG and indicated mirror
// Entry Values
// X = Pointer to PSG mirror
// U = Pointer to sound string
// DP = $D0
// Return Values
// D = Sound string terminator
// U = Points to end of sound string

__NO_INLINE void _Sound_Bytes_x(void* const x __UNUSED, void* const u) // 0xF284
{
	asm volatile(
		"ldu %[U]\n\t"
		"jsr ___Sound_Bytes_x; BIOS call"
		:: 	[U] "mi" (u)
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Send ‘REQx’ to PSG and mirror
// Entry Values
// DP = $D0
// REQ0 – REQD - .
// Return Values
// A = $FF
// B = Contents of ‘REQD’
// X = $C80D (#REGD)
// U = $C84C (#REQD + 1)

__NO_INLINE void _Do_Sound(void) // 0xF289
{
	asm volatile(
		"jsr ___Do_Sound; BIOS call"
		::
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------

#if 0
__NO_INLINE void _Do_Sound_x(void* const x) // 0xF28C, not official! 
#endif

// ---------------------------------------------------------------------------
// Set tune sequence
// Tune List Description:
// byte 0 / 1 = Fade list pointer
// 2 / 3 = Vibrato list pointer
// n = Note
// $40 = Noise enable
// $80 = Next channel enable
// n+1 = Tone period ($80 = tune list terminator)
// Fade List Description
// <no description provided>
// Vibrato List Description
// <no description provided>
// Entry Values
// U = Tune list pointer
// DP = $C8
// TSTAT = .
// Return Values
// A = Destroyed
// B = Destroyed
// X = Destroyed
// Y = Destroyed

__NO_INLINE void _Init_Music_chk(const void* const x __UNUSED) // 0xF687
{
	asm volatile(
		"tfr x,u\n\t"
		"jsr ___Init_Music_chk; BIOS call"
		:: 
		: "memory", "cc", "y", "u");
}

// ---------------------------------------------------------------------------
// Set tune sequence
// Tune List Description:
// byte 0 / 1 = Fade list pointer
// 2 / 3 = Vibrato list pointer
// n = Note
// $40 = Noise enable
// $80 = Next channel enable
// n+1 = Tone period ($80 = tune list terminator)
// Fade List Description
// <no description provided>
// Vibrato List Description
// <no description provided>
// Entry Values
// U = Tune list pointer
// DP = $C8
// Return Values
// A = Destroyed
// B = Destroyed
// X = Destroyed
// Y = Destroyed
// U = Destroyed
// STKADD (SADD2) equ $F880; Add value on stack to indicated score field
// ASCII Score Field Description
// byte 0 = Hundred thousand digit ($20, $30 - $39)
// 1 = Ten thousand digit ($20, $30 - $39)
// 2 = One thousand digit ($20, $30 - $39)
// 3 = Hundreds digit ($20, $30 - $39)
// 4 = Tens digit ($20, $30 - $39)
// 5 = Ones digit ($30 - $39)
// 6 = Score field terminator ($80)
// Entry Values
// S = .
// LIST = $00
// Return Values
// A = Destroyed
// B = Destroyed
// S = Entry value + 2

__NO_INLINE void _Init_Music(void* const x __UNUSED) // 0xF68D 
{
	asm volatile(
		"tfr x,u\n\t"
		"jsr ___Init_Music; BIOS call"
		::
		: "memory", "cc", "u", "s");
}

// ---------------------------------------------------------------------------
// Set tune sequence with alternate note set
// Tune List Description:
// Byte 0 / 1 = Fade list pointer
// 2 / 3 = Vibrato list pointer
// n = Note
// $40 = Noise enable
// $80 = Next channel enable
// n+1 = Tone period ($80 = tune list terminator)
// Fade List Description
// <no description provided>
// Vibrato List Description
// <no description provided> 
// Entry Values
// X = User note table pointer
// U = Tune list pointer
// DP = $C8
// Return Values
// A = Destroyed
// B = Destroyed
// X = Destroyed
// Y = Destroyed
// U = Destroyed

__NO_INLINE void _Init_Music_a(void* const x __UNUSED, void* const u) // 0xF690 
{
	asm volatile(
		"ldu %[U]\n\t"
		"jsr ___Init_Music_a; BIOS call"
		:: [U] "mi" (u)
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Set tune sequence
// Tune List Description:
// byte 0 / 1 = Fade list pointer
// 2 / 3 = Vibrato list pointer
// n = Note
// $40 = Noise enable
// $80 = Next channel enable
// n+1 = Tone period ($80 = tune list terminator)
// Fade List Description
// <no description provided>
// Vibrato List Description
// <no description provided>
// Entry Values
// U = Tune list pointer
// DP = $C8
// DOREMI = .
// Return Values
// A = Destroyed
// B = Destroyed
// X = Destroyed
// Y = Destroyed
// U = Destroyed

__NO_INLINE void _Init_Music_x(void* const x __UNUSED) // 0xF692 
{
	asm volatile(
		"tfr x,u\n\t"
		"jsr ___Init_Music_x; BIOS call"
		::
		: "memory", "cc", "y", "u");
}

// ---------------------------------------------------------------------------
// Terminate current tune
// Entry Values
// DP = $C8
// Return Values
// A = $3F
// B = $FF
// X = $C83F (#REQ0)
// TSTAT = .

#if 0
__NO_INLINE __NAKED void _Stop_Sound(void) // 0xF742
{
	asm volatile(
		"jmp ___Stop_Sound; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Complex explosion sound-effect handler
// Explosion Parameter Table Description
// Byte 0 = Tone and noise channel enables
// Bit 0 = Tone channel #
// 1 = Tone channel #
// 2 = Tone channel #
// 3 = Noise source #
// 4 = Noise source #
// 5 = Noise source #
// Byte 1 = Noise source sweep
// = 0 – Sweep frequency UP
// > 0 – Sweep frequencey DOWN
// < 0 – Inhibit frequency sweep
// Byte 2 = Volume sweep
// = 0 – Sweep volume UP
// > 0 – Sweep volume DOWN
// < 0 – Inhibit volume sweep
// Byte 3 = Explosion duration
// $01 – Longest explosion duration
// $80 – Shortest explosion duration
// Entry Values
// U = Explosion parameter table pointer
// DP = $C8
// Return Values
// A = Destroyed
// B = Destroyed
// X = Destroyed
// XACON = $00 (when explosion is completed)

__NO_INLINE void _Explosion_Snd(const void* const x __UNUSED) // 0xF92E
{
	asm volatile(
		"tfr x,u\n\t"
		"jsr ___Explosion_Snd; BIOS call"
		::
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Set amplitude in ‘REQx’
// Entry Values
// B = Volume setting
// DP = $C8
// TUNE = .
// Return Values
// A = Destroyed
// X = Destroyed

#if 0
__NO_INLINE __NAKED void _Set_Amp(const unsigned int b __UNUSED) // 0xF9CA
{
	asm volatile(
		"jmp ___Set_Amp; BIOS call"
		::
		: "memory", "cc");
}
#endif

/* Init_Music_chk: These routines are responsible for filling the music work 
   buffer while a sound is being made. It should be called once during each 
   refresh cycle. If you want to start a new sound, then you must set 0xC856 
   to 0x01, and point the U-register to the sound block. If no sound is in 
   progress (0xC856 = 0), then it returns immediately (unless you called 
   Init_Music or Init_Music_dft, which do not make this check). When a sound 
   is in progress, 0xC856 will be set to 0x80.
   These routines process a single note at a time, and calculate the amplitude 
   and course/fine tuning values for the 3 sound channels. The values 
   calculated are stored in the music work buffer, at 0xC83F-0xC84C.
  Music data format:
  header word -> 0xC84F 32 nibble ADSR table
  header word -> 0xC851 8-byte "twang" table
  data bytes
   The ADSR table is simply 32 nibbles (16 bytes) of amplitude values.
   The twang table is 8 signed bytes to modify the base frequency of each note 
   being played. Each channel has a different limit to its twang table index 
   (6-8) to keep them out of phase to each other.
  Music data bytes:
   Bits 0-5 = frequency
   Bit 6 clear = tone
   Bit 6 set = noise
   Bit 7 set = next music data byte is for next channel
   Bit 7 clear, play note with duration in next music data byte:
   bits 0-5 = duration
   bit 6 = unused
   bit 7 set = end of music */

// ***************************************************************************
// 13. Vector Beam Positioning Functions

// POSWID 	0xF2F2 	--- 	Position relative vector
// POSITD 	0xF2FC 	--- 	Position relative vector
// POSIT2 	0xF308 	--- 	Position relative vector
// POSIT1 	0xF30C 	--- 	Position relative vector
// POSITB 	0xF30E 	--- 	Position relative vector
// POSITX 	0xF310 	--- 	Position relative vector
// POSITN 	0xF312 	--- 	Position relative vector

// ---------------------------------------------------------------------------
// Release integrators and position beam using 16-bit ‘Y:X’ values
// List Description:
// byte 0 / 1 = ‘Y’ Position vector (16-bits)
// byte 2 / 3 = ‘X’ Positioning vector (16-bits)
// Entry Values
// X = List pointer
// DP = $D0
// Return Values
// A = Destroyed
// B = Destroyed
// Comments
// Uses 1x scale factor ($7F)

#if 0
__NO_INLINE __NAKED void _Moveto_x_7F(void* const x __UNUSED) // 0xF2F2
{
	asm volatile(
		"jmp ___Moveto_x_7F; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Release integrators and position beam
// Entry Values
// A = Relative ‘Y’ vector value
// B = Relative ‘X’ vector value
// DP = $D0
// Return Values
// A = Destroyed
// B = Destroyed

__NO_INLINE __NAKED void _Moveto_d_7F(const int b __UNUSED, const int a) // 0xF2FC
{
	asm volatile(
		"lda %[A]\n\t"
		"jmp ___Moveto_d_7F; BIOS call"
		:: 	[A] "mi" (a)
		: "memory", "cc");
}

__NO_INLINE __NAKED void _Moveto_dd_7F(const long int x __UNUSED) // 0xF2FC
{
	asm volatile(
		"tfr x,d\n\t"
		"jmp ___Moveto_d_7F; BIOS call"
		::
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Release integrators and position beam
// List Description:
// byte 0 / 1 = Positioning vector (Y:X)
// Entry Values
// X = List pointer
// DP = $D0
// Return Values
// A = Destroyed
// B = Destroyed
// X = Entry value + 2
// Comments
// Uses 2x scale factor ($FF)

#if 0
__NO_INLINE __NAKED void _Moveto_ix_FF(void* const x __UNUSED) // 0xF308 
{
	asm volatile(
		"jmp ___Moveto_ix_FF; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Release integrators and position beam
// List Description:
// byte 0 / 1 = Positioning vector (Y:X)
// Entry Values
// X = List pointer
// DP = $D0
// Return Values
// A = Destroyed
// B = Destroyed
// X = Entry value + 2
// Comments
// Uses 1x scale factor ($7F)

#if 0
__NO_INLINE __NAKED void _Moveto_ix_7F(void* const x __UNUSED) // 0xF30C 
{
	asm volatile(
		"jmp ___Moveto_ix_7F; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Release integrators and position beam
// List Description:
// byte 0 / 1 = Positioning vector (Y:X)
// Entry Values
// B = Vector length (scale factor)
// X = List pointer
// DP = $D0
// Return Values
// A = Destroyed
// B = Destroyed
// X = Entry value + 2
// Comments
// Uses scale factor specified in ‘B’ register

#if 0
__NO_INLINE __NAKED void _Moveto_ix_b(const unsigned int b __UNUSED, void* const x __UNUSED) // 0xF30E 
{
	asm volatile(
		"jmp ___Moveto_ix_b; BIOS call"
		:: 	
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Release integrators and position beam
// List Description:
// byte 0 / 1 = Positioning vector (Y:X)
// Entry Values
// X = List pointer
// DP = $D0
// T1LOLC = Vector length (scale factor)
// Return Values
// A = Destroyed
// B = Destroyed
// X = Entry value + 2

#if 0
__NO_INLINE __NAKED void _Moveto_ix(void* const x __UNUSED) // 0xF310 
{
	asm volatile(
		"jmp ___Moveto_ix; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Release integrators and position beam
// Entry Values
// A = Relative ‘Y’ vector value
// B = Relative ‘X’ vector value
// DP = $D0
// T1LOLC = Vector length (scale factor)
// Return Values
// A = Destroyed
// B = Destroyed
// Comments
// Uses 1x scale factor ($7F), not! uses preset RAM scale

__NO_INLINE __NAKED void _Moveto_d(const int b __UNUSED, const int a) // 0xF312
{
	asm volatile(
		"lda %[A]\n\t"
		"jmp ___Moveto_d; BIOS call"
		:: [A] "mi" (a)
		: "memory", "cc");
}

__NO_INLINE __NAKED void _Moveto_dd(const long int x __UNUSED) // 0xF312, performance opt!
{
	asm volatile(
		"tfr x,d\n\t"
		"jmp ___Moveto_d; BIOS call"
		::
		: "memory", "cc");
}

// ***************************************************************************
// 14. Vector Brightness Functions

// INT1Q 	0xF29D 	--- 	Set beam intensity
// INTMID 	0xF2A1 	INT2Q 	Set beam intensity
// INT3Q 	0xF2A5 	--- 	Set beam intensity
// INTMAX 	0xF2A9 	--- 	Set beam intensity
// INTENS 	0xF2AB 	--- 	Set beam intensity

// ---------------------------------------------------------------------------
// Set intensity at _ level
// Entry Values
// DP = $D0
// Return Values
// A = $05
// B = $01
// Comments
// Sets intensity to $1F

#if 0
__NO_INLINE __NAKED void _Intensity_1F(void) // 0xF29D
{
	asm volatile(
		"jmp ___Intensity_1F; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Set intensity at 1/2 level
// Entry Values
// DP = $D0
// Return Values
// A = $05
// B = $01
// Comments
// Sets intensity to $3F

#if 0
__NO_INLINE __NAKED void _Intensity_3F(void) // 0xF2A1 
{
	asm volatile(
		"jmp ___Intensity_3F; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Set intensity at 3/4 level
// Entry Values
// DP = $D0
// Return Values
// A = $05
// B = $01
// Comments
// Sets intensity to $5F

#if 0
__NO_INLINE __NAKED void _Intensity_5F(void) // 0xF2A5 
{
	asm volatile(
		"jmp ___Intensity_5F; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Set intensity at maximum level
// Entry Values
// DP = $D0
// Return Values
// A = $05
// B = $01
// Comments
// Sets intensity to $7F

#if 0
__NO_INLINE __NAKED void _Intensity_7F(void) // 0xF2A9 
{
	asm volatile(
		"jmp ___Intensity_7F; BIOS call"
		::
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Set intensity at user value
// Entry Values
// A = Intensity level ($00 - $7F)
// DP = $D0
// Return Values
// A = $05
// B = $01
// Comments
// The value given for the intensity setting must not be negative ($80 - $FF). Setting the
// intensity to a negative value may result in damage to the Vectrex.

__NO_INLINE __NAKED void _Intensity_a(const unsigned int b __UNUSED) // 0xF2AB
{
	asm volatile(
		"tfr b,a\n\t"
		"jmp ___Intensity_a; BIOS call"
		::
		: "memory", "cc");
}

// ***************************************************************************
// 15.1 Object Collision Detection Functions

// OFF1BOX 	0xF8E5 	OFF1BX 	Symmetric collison test
// OFF2BOX 	0xF8F3 	OFF2BX 	Symmetric collison test
// FINDBOX 	0xF8FF 	BXTEST 	Symmetric collison test

// ---------------------------------------------------------------------------
// Off-center symmetric collision test
// Entry Values
// A = Box ‘Y’ dimension (Delta ‘Y’)
// B = Box ‘X’ dimension (Delta ‘X’)
// X = ‘Y:X’ coordinates of point to be tested
// Y = ‘Y:X’ coordinates of center of box
// U = Off-set value pointer
// Return Values
// C = 1 – Collision detected

__NO_INLINE unsigned int _Obj_Will_Hit_u(const int b __UNUSED, const int a, const long int x __UNUSED, const long int y, const long int u) // 0xF8E5
{
	asm volatile(
		"lda %[A]\n\t"
		"ldy %[Y]\n\t"
		"ldu %[U]\n\t"
		"jsr ___Obj_Will_Hit_u; BIOS call\n\t"
		"ldb #0\n\t"
		"adcb #0"		
		:
		: [A] "mins" (a), [Y] "mi" (y), [U] "mi" (u)
		: "memory", "cc", "y", "u");
}

// ---------------------------------------------------------------------------
// Off-center symmetric collision text
// Entry Values
// A = Box ‘Y’ dimension (Delta ‘Y’)
// B = Box ‘X’ dimension (Delta ‘X’)
// X = ‘Y:X’ coordinates of point to be tested
// Y = ‘Y:X’ coordinates of center of box
// U = Off-set value (‘Y:X’)
// Return Values
// C = 1 – Collision detected

__NO_INLINE unsigned int _Obj_Will_Hit(const int b __UNUSED, const int a, const long int x __UNUSED, const long int y, const long int* u) // 0xF8F3
{
	asm volatile(
		"lda %[A]\n\t"
		"ldy %[Y]\n\t"
		"ldu %[U]\n\t"
		"jsr ___Obj_Will_Hit; BIOS call\n\t"
		"ldb #0\n\t"
		"adcb #0"		
		:
		: [A] "mins" (a), [Y] "mi" (y), [U] "mi" (u)
		: "memory", "cc", "y", "u");
}

// ---------------------------------------------------------------------------
// Symmetric collision test
// Entry Values
// A = Box ‘Y’ dimension (delta ‘Y’)
// B = Box ‘X’ dimension (delta ‘X’)
// X = Y:X coordinates of point to be tested
// Y = Y:X coordinates of box center
// Return Values
// C = 1 – collision detected

__NO_INLINE unsigned int _Obj_Hit(const int b __UNUSED, const int a, const long int x __UNUSED, const long int y) // 0xF8FF
{
	asm volatile(
		"lda %[A]\n\t"
		"ldy %[Y]\n\t"
		"jsr ___Obj_Hit; BIOS call\n\t"
		"ldb #0\n\t"
		"adcb #0"		
		:
		: [A] "mins" (a), [Y] "mi" (y)
		: "memory", "cc", "y");
}

// ***************************************************************************
// 15.2 Rotate Routines

// RATOT 	0xF5FF 	LROT90 	Rotate a single line
// ROTOR 	0xF601 	LNROT 	Rotate a single line
// ROTAR 	0xF603 	ALNROT 	Rotate a single line
// DANROT 	0xF610 	DROT 	'DIFFY' style rotate
// DISROT 	0xF613 	BDROT 	'DIFFY' style rotate
// DIFROT 	0xF616 	ADROT 	'DIFFY' style rotate
// POTATA 	0xF61F 	PROT 	'PACKET' style rotate
// POTATE 	0xF622 	APROT 	'PACKET' style rotate

// ---------------------------------------------------------------------------
// Rotate a single line
// Entry Values
// A = Initial ‘Y’ value
// B = Angle of rotation
// DP = $C8
// Return Values
// A = Rotated ‘Y’ vector value
// B = Rotated ‘X’ vector value

__NO_INLINE long unsigned int _Rise_Run_X(const int b __UNUSED, const int a) // 0xF5FF
{
	asm volatile(
		"lda %[A]\n\t"
		"jsr ___Rise_Run_X; BIOS call\n\t"
		"tfr d,x"
		:
		: [A] "mi" (a)
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Rotate a single line
// Entry Values
// A = Initial ‘Y’ value
// B = Angle of rotation
// DP = $C8
// Return Values
// A = Rotated ‘Y’ vector value
// B = Rotated ‘X’ vector value

__NO_INLINE long unsigned int _Rise_Run_Y(const int b __UNUSED, const int a) // 0xF601
{
	asm volatile(
		"lda %[A]\n\t"
		"jsr ___Rise_Run_Y; BIOS call\n\t"
		"tfr d,x"
		:
		: [A] "mi" (a)
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Rotate a single line
// Entry Values
// A = Initial ‘Y’ value
// DP = $C8
// ANGLE = Angle of rotation ($00 - $3F)
// Return Values
// A = Rotated ‘Y’ vector value
// B = Rotated ‘X’ vector value

__NO_INLINE unsigned long int _Rise_Run_Len(const int b __UNUSED) // 0xF603
{
	asm volatile(
		"tfr b,a\n\t"
		"jsr ___Rise_Run_Len; BIOS call\n\t"
		"tfr d,x"
		:
		:
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Rotate ‘Diffy’ style list
// List Description:
// byte 0 / 1 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X)
// Entry Values
// A = Rotation angle
// B = Number of vectors – 1
// X = ‘DIFFY’ list pointer
// U = Destination buffer pointer
// Return Values
// A = $00
// B = Destroyed
// X = Entry value + 1
// U = Entry value + 1
// LIST = $00

__NO_INLINE void _Rot_VL_ab(const unsigned int b __UNUSED, const unsigned int a, void* const x __UNUSED, void* const u) // 0xF610
{
	asm volatile(
		"lda %[A]\n\t"
		"ldu %[U]\n\t"
		"jsr ___Rot_VL_ab; BIOS call"
		:: [A] "mi" (a), [U] "mi" (u)
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Rotate ‘Diffy’ style list
// List Description:
// byte 0 / 1 = Vector #1 (Y:X)
// - -
// n / n+1 = Vector #n (Y:X) 
// Entry Values
// B = Number of vectors – 1
// X = ‘Diffy’ list pointer
// U = Destination buffer pointer
// Return Values
// A = $00
// B = Destroyed
// X = Entry value + 1
// U = Entry value + 1
// LIST = $00

__NO_INLINE void _Rot_VL_Diff(const unsigned int b __UNUSED, void* const x __UNUSED, void* const u) // 0xF613
{
	asm volatile(
		"ldu %[U]\n\t"
		"jsr ___Rot_VL_Diff; BIOS call"
		:: [U] "mi" (u)
		: "memory", "cc", "u");
}

// ---------------------------------------------------------------------------
// Rotate ‘DIFFY’ style list
// List Description:
// Byte 0 / 1 = Vector #1 (Y:X)
// - .
// Byte n / n+ 1 = Vector #n (Y:X)
// Entry Values
// X = ‘DIFFY’ list pointer
// U = Destination buffer pointer
// ANGLE = Angle of rotation ($00 - $3F)
// LIST = Number of vectors - 1
// Return Values
// A = $00
// B = Destroyed
// X = Entry value + 1
// U = Entry value + 1
// LIST = $00

__NO_INLINE void _Rot_VL(void* const x __UNUSED, void* const u) // 0xF616 
{
	asm volatile(
		"ldu %[U]\n\t"
		"jsr ___Rot_VL; BIOS call"
		:: [U] "mi" (u)
		: "memory", "cc", "u");
}

// *******************************************************************************************
// BIOS calls
// The BIOS calls assume that the DP register is set up correctly,
// so you are responsible for doing that by using the BIOS calls
// DP_to_D0(...) or DP_to_C8(...) as apropriate
// *******************************************************************************************

/* Draw_VLc: This routine draws vectors between the set of (y,x) points 
   pointed to by the X register. The number of vectors to draw is specified 
   as the first byte in the vector list. The current scale factor is used. 
   The vector list has the following format:
     count, rel y, rel x, rel y, rel x, ...
*/

/* Draw_Line_d: This routine will draw a line from the current pen position, 
   to the point specified by the (y,x) pair specified in the D register. 
   The current scale factor is used. Before calling this routine, 
   0xC823 should be = 0, so that only the one vector will be drawn. */

/* Wait_Recal: Wait for t2 (the refresh timer) to timeout, then restart it using 
   the value in 0xC83D. then, recalibrate the vector generators to the origin (0,0). 
   This routine MUST be called once every refresh cycle, or your vectors will get 
   out of whack. This routine calls Reset0Ref, so the integrators are left in zero 
   mode. DP=D0 */

/* Moveto_ix_b: These routines force the scale factor to the value of the B register, 
  and then move the pen to the (y,x) position pointed to by the X-register. 
  The X-register is then incremented by 2. */

/* Moveto_d: This routine uses the current scale factor, and moves the pen to the (y,x) 
   position specified in D register. */

/* Intensity_a: setting the vector/dot intensity (commonly used to denote the z axis) 
   to a specific value. 0x00 is the lowest intensity, and 0x7F is the brightest 
   intensity. A negative intensity is also lowest intensity (7th bit set). The 
   intensity must be reset to the desired value after each call to Wait_Recal; 
   however, it can also be changed at any other time. A copy of the new intensity 
   value is saved in 0xC827.*/

// ***************************************************************************
// MINESTORM

// ---------------------------------------------------------------------------
// Position and then draw dot
// Entry Values
// Y = Absolute ‘Y:X’ position
// DP = $D0
// Return Values
// Same as entry values

__NO_INLINE void _Dot_y(const long int x __UNUSED) // 0xEA5D
{
	asm volatile(
		"tfr x,y\n\t"
		"jsr ___Dot_y; BIOS call"
		::
		: "memory", "cc", "y");
}

// ---------------------------------------------------------------------------
// Position with 16-bit ‘Y:X’ values and draw dot
// Entry Values
// Y = Pointer to 32-bit absolute ‘Y:X’ position
// DP = $D0
// DWELL = Dot ‘ON’ time
// Return Values
// Same as entry values

__NO_INLINE void _Dot_py(void* const x __UNUSED) // 0xEA6D
{
	asm volatile(
		"tfr x,y\n\t"
		"jsr ___Dot_py; BIOS call"
		::
		: "memory", "cc", "y");
}

// ---------------------------------------------------------------------------
// Position and draw packet
// List Description:
// Byte 0 / 1 / 2 = Vector #1 (C:Y:X)
// - - - -
// n / n+1 / n+2 = Vector #n (C:Y:X)
// n+3 = $01 (packet terminator)
// where C = $01 – packet terminator
// $00 – draw blank line
// $FF – draw solid line 
// Entry Values
// B = Zoom value (scale factor)
// X = ‘Packet’ list pointer
// Y = Absolute ‘Y:X’ position
// DP = $D0
// ZSKIP = $00 – Skip integrator zeroing
// != $00 – Zero integrators
// Return Values
// Same as entry values

__NO_INLINE void _Draw_Pack(const unsigned int b __UNUSED, void* const x __UNUSED, const long int y) // 0xEA7F
{
	asm volatile(
		"ldy %[Y]\n\t"
		"jsr ___Draw_Pack; BIOS call"
		:: [Y] "mi" (y)
		: "memory", "cc", "y");
}

// ---------------------------------------------------------------------------
// Position with 16-bit ‘X:Y’ values and draw packet
// List Description:
// Byte 0 / 1 / 2 = Vector #1 (C:Y:X)
// - - - -
// n / n+1 / n+2 = Vector #n (C:Y:X)
// n+3 = $01 (packet terminator)
// where C = $01 – packet terminator
// $00 – draw blank line
// $FF – draw solid line
// Entry Values
// B = Zoom value (scale factor)
// X = ‘Packet’ list pointer
// Y = Pointer to 32-bit absolute ‘Y:X’ position
// DP = $D0
// Return Values
// Same as entry values

__NO_INLINE void _Draw_Pack_py(const unsigned int b __UNUSED, void* const x __UNUSED, void* const y) // 0xEA8D
{
	asm volatile(
		"ldy %[Y]\n\t"
		"jsr ___Draw_Pack_py; BIOS call"
		:: [Y] "mi" (y)
		: "memory", "cc", "y");
}

// ---------------------------------------------------------------------------
// Position and draw raster message
// Message List Description:
// Byte 0 – n = Raster message string ($20 - $6F)
// n + 1 = Raster terminator ($80)
// Entry Values
// Y = Absolute ‘Y:X’ position
// U = Message list pointer
// DP = $D0
// SIZRAS = ‘YX’ size of raster message
// Return Values
// Same as entry values

__NO_INLINE void _Print_Msg(void* const x __UNUSED, void* const u) // 0xEAA8
{
	asm volatile(
		"tfr x,y\n\t"
		"ldu %[U]\n\t"
		"jsr ___Print_Msg; BIOS call"
		:: [U] "mi" (u)
		: "memory", "cc", "y", "u");
}

// ---------------------------------------------------------------------------
// Select direction within limit cones
// Entry Values
// SEED = Random number pointer (Normally ‘RANCID’)
// Return Values
// B = Random number within limit cones

#if 0
__NO_INLINE unsigned int _Rnd_Cone(void) // 0xEA3E
{
	asm volatile(
		"jmp ___Rnd_Cone; BIOS call"
		:
		: 	
		: "memory", "cc");
}
#endif

// ---------------------------------------------------------------------------
// Form ‘Y:X’ displacements (x8)
// Entry Values
// A = speed vector
// B = Direction (Angle of rotation)
// DP = $C8
// Return Values
// X = ‘X’ Displacement value (x8)
// Y = ‘Y’ Displacement value (x8)

__NO_INLINE long unsigned int _Displ8_xy(const unsigned int b __UNUSED, const unsigned int a) // 0xE7B5
{
	asm volatile(
		"lda %[A]\n\t"
		"jsr ___Displ8_xy; BIOS call"
		:
		: [A] "mi" (a)
		: "memory", "cc", "y");
	// returns only x
}

// ---------------------------------------------------------------------------
// Form ‘Y:X’ displacements (x16)
// Entry Values
// A = Speed vector
// B = Direction (Angle of rotation)
// DP = $C8
// Return Values
// X = ‘X’ Displacement value (x16)
// Y = ‘Y’ Displacement value (x16)

__NO_INLINE long unsigned int _Displ16_xy(const unsigned int b __UNUSED, const unsigned int a) // 0xE7D2
{
	asm volatile(
		"lda %[A]\n\t"
		"jsr ___Displ16_xy; BIOS call"
		: 
		: [A] "mi" (a)
		: "memory", "cc", "y");
	// returns only x
}

// ---------------------------------------------------------------------------
// Determine random ‘Y:X’ position
// Entry Values
// No register parameters required
// SEED = Random number pointer (Normally ‘RANCID’)
// Return Values
// A = ‘Y’ axis value ($00 - $FF)
// B = ‘X’ axis value ($60 - $7F, $A0 - $FF)

__NO_INLINE long unsigned int _Ranpos(void) // 0xE98A
{
	asm volatile(
		"jsr ___Dot_y; BIOS call\n\t"
		"tfr d,x"
		:
		:
		: "memory", "cc");
}

// ---------------------------------------------------------------------------
// Draw scores for both players
// ASCII Score Field Description
// byte 0 = Hundred thousand digit ($20, $30 - $39)
// 1 = Ten thousand digit ($20, $30 - $39)
// 2 = One thousand digit ($20, $30 - $39)
// 3 = Hundreds digit ($20, $30 - $39)
// 4 = Tens digit ($20, $30 - $39)
// 5 = Ones digit ($30 - $39)
// 6 = Score field terminator ($80)
// Entry Values
// DP = $D0
// PLAYRS = Number of players selected – 1
// SCOR1 = Raster score for player #1
// SCOR2 = Raster score for player #2
// Return Values
// A = Destroyed
// B = Destroyed
// Y = Destroyed
// U = Destroyed

__NO_INLINE void _Draw_Scores(void) // 0xEACF
{
	asm volatile(
		"jsr ___Draw_Scores; BIOS call"
		::
		: "memory", "cc", "y", "u");
}

// ---------------------------------------------------------------------------
// Draw score for currently active player
// ASCII Score Field Description
// byte 0 = Hundred thousand digit ($20, $30 - $39)
// 1 = Ten thousand digit ($20, $30 - $39)
// 2 = One thousand digit ($20, $30 - $39)
// 3 = Hundreds digit ($20, $30 - $39)
// 4 = Tens digit ($20, $30 - $39)
// 5 = Ones digit ($30 - $39)
// 6 = Score field terminator ($80)
// Entry Values
// DP = $D0
// ACTPLY = Currently active player ($00 or $02)
// SCOR1 = Raster score for player #1
// SCOR2 = Raster score for player #2
// Return Values
// A = Destroyed
// B = Destroyed
// Y = Destroyed
// U = Destroyed

__NO_INLINE void _Draw_Score(void) // 0xEAB4
{
	asm volatile(
		"jsr ___Draw_Score; BIOS call"
		::
		: "memory", "cc", "y", "u");
}

// ---------------------------------------------------------------------------
// Wait for frame boundary and input from controller
// Entry Values
// No register parameters required
// ACTPLY = Currently active player ($00 or $02)
// FRMTIM = Frame to frame interval
// SBTN = Button de-edge mask
// SCOR1 = Raster score for player #1
// SCOR2 = Rater score for player #2
// SJOY = Joystick multiplexer enable (controller #1)
// Return Values
// A = Destroyed
// B = Destroyed
// X = Destroyed
// Y = Destroyed
// U = Destroyed
// DP = $D0
// LIST = $00

__NO_INLINE void _Wait_Bound(void) // 0xEAF0
{
	asm volatile(
		"jsr ___Wait_Bound; BIOS call"
		:: 	
		: "memory", "cc", "y", "u");
}

// ***************************************************************************
// end of file
// ***************************************************************************
