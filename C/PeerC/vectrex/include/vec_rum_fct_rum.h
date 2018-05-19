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

#pragma once

#include <macro.h>

// ***************************************************************************
// The BIOS calls assume that the DP register is set up correctly,
// so you are responsible for doing that by using the BIOS calls
// _DP_to_D0(...) or _DP_to_C8(...) as apropriate
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

// ---------------------------------------------------------------------------
// 1. Calibration and Vector Reset Functions

// FRAM20 	0xF192 	FRWAIT 	Wait for frame boundary
// DEFLOK 	0xF2E6 	--- 	Overcome scan collapse circuitry
// ZERO.DP 	0xF34A 	ZERO.DP 	Zero integrators and set active ground
// ZEGO 	0xF34F 	ZEGO 	Zero integrators and set active ground
// ZEROIT 	0xF354 	ZEROIT 	Zero integrators and set active ground
// ZEREF 	0xF35B 	ZEREF 	Zero integrators and set active ground
// ZERO. 	0xF36B 	ZERO 	Zero integrators and set active ground

__NO_INLINE void __Wait_Recal(void); // 0xF192
__NO_INLINE void __Set_Refresh(void); // 0xF1A2, not official!
__NO_INLINE void __Recalibrate(void); // 0xF2E6 
__NO_INLINE void __Reset0Ref_D0(void); // 0xF34A
__NO_INLINE void __Check0Ref(void); // 0xF34F 
__NO_INLINE void __Reset0Ref(void); // 0xF354 
__NO_INLINE void __Reset_Pen(void); // 0xF35B
__NO_INLINE void __Reset0Int(void); // 0xF36B

/* Set_Refresh: This routine loads the refresh timer (t2) with the value in 0xC83D- 
   0xC83E, and recalibrates the vector generators, thus causing the pen to be left 
   at the origin (0,0). The high order byte for the timer is loaded from 0xC83E, 
   and the low order byte is loaded from 0xC83D. 
   The refresh rate is calculated as follows: rate = (C83E)(C83D) / 1.5 mhz */
   
// ---------------------------------------------------------------------------
// 2. Counter Handling Functions

// DEKR3 	0xF55A 	D3TMR 	Decrement interval timers
// DEKR 	0xF55E 	DECTMR 	Decrement interval timers
// DEKRCNT	0xF563	---		Decrement counters, inofficial!

__NO_INLINE void __Dec_3_Counters(void); // 0xF55A
__NO_INLINE void __Dec_6_Counters(void); // 0xF55E
__NO_INLINE void __Dec_Counters(volatile const unsigned int b, void* volatile const x); // 0xF563

// ---------------------------------------------------------------------------
// 3. Direct Page Register Functions

// DPIO 	0xF1AA 	--- 	Set direct register
// DPRAM 	0xF1AF 	--- 	Set direct register

__NO_INLINE void __DP_to_D0(void); // 0xF1AA
__NO_INLINE void __DP_to_C8(void); // 0xF1AF

/* DP_to_D0: Sets the DP register to 0xD0, so that all direct page addressing will 
   start at 0xD000 (the hardware I/O area). */
/* DP_to_C8: Sets the DP register to 0xC8, so that all direct page addressing will 
   start at 0xC800 (OS RAM area). */

// ---------------------------------------------------------------------------
// 4. Delay Functions

// DEL38 	0xF56D 	--- 	Programmed delays
// DEL33 	0xF571 	--- 	Programmed delays
// DEL28 	0xF575 	--- 	Programmed delays
// DEL20 	0xF579 	--- 	Programmed delays
// DEL 		0xF57A 	--- 	Programmed delays
// DEL13 	0xF57D 	--- 	Programmed delays

__NO_INLINE void __Delay_3(void); // 0xF56D, 30 cycles
__NO_INLINE void __Delay_2(void); // 0xF571, 25 cycles
__NO_INLINE void __Delay_1(void); // 0xF575, 20 cycles
__NO_INLINE void __Delay_0(void); // 0xF579, 12 cycles
__NO_INLINE void __Delay_b(volatile const unsigned int b); // 0xF57A, 5*B + 10 cycles
__NO_INLINE void __Delay_RTS(void); // 0xF57D, 5 cycles

// ---------------------------------------------------------------------------
// 5.1 Dot Drawing Routines
 
// DOTTIM 	0xF2BE 	--- 	Draw one dot from 'DIFFY' style list
// DOTX 	0xF2C1 	--- 	Draw one dot from 'DIFFY' style list
// DOTAB 	0xF2C3 	--- 	Draw one dot from the contents of 'A' & 'B'
// DOT 		0xF2C5 	--- 	Turn on beam for dot
// DIFDOT 	0xF2D5 	--- 	Draw dots according to 'DIFFY' format
// DOTPAK 	0xF2DE 	DOTPCK 	Draw dots according to 'PACKET' format

__NO_INLINE void __Dot_ix_b(volatile const unsigned int b, void* volatile const x); // 0xF2BE 
__NO_INLINE void __Dot_ix(void* volatile const x); // 0xF2C1 
__NO_INLINE void __Dot_d(volatile const int a, volatile const int b); // 0xF2C3 
__NO_INLINE void __Dot_dd(volatile const long int d); // 0xF2C3 
__NO_INLINE void __Dot_here(void); // 0xF2C5
__NO_INLINE void __Dot_List(void* volatile const x); // 0xF2D5
__NO_INLINE void __Dot_List_Reset(void* volatile const x); // 0xF2DE

// Dot_List: This routine draws a series of dots, using the intensity already set up
// in 0xC828. The format for the dot list, which is pointed to by the X register, is:
// ( rel y, rel x), (rel y, rel x), .....
// The number of dots-1 to draw is specified in 0xC823. 

// ---------------------------------------------------------------------------
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

__NO_INLINE void __Print_Str_hwyx(void* volatile const u); // 0xF373 
__NO_INLINE void __Print_Str_yx(const void* volatile const u); // 0xF378
__NO_INLINE void __Print_Str_d(volatile const int a, volatile const int b, void* volatile const u); // 0xF37A
__NO_INLINE void __Print_Str_dd(volatile const long int d, void* volatile const u); // 0xF37A
__NO_INLINE void __Print_List_hw(void* volatile const u); // 0xF385
__NO_INLINE void __Print_List(void* volatile const u); // 0xF38A, not official!
__NO_INLINE void __Print_List_chk(void* volatile const u); // 0xF38C 
__NO_INLINE void __Print_Ships_x(volatile const unsigned int a, volatile const unsigned int b, void* volatile const x); // 0xF391 
__NO_INLINE void __Print_Ships(volatile const unsigned int a, volatile const unsigned int b, volatile const unsigned long int x); // 0xF393 
__NO_INLINE void __Print_Str(void* volatile const u); // 0xF495
__NO_INLINE void __Print_MRast(void); // 0xF498

// ---------------------------------------------------------------------------
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

__NO_INLINE void __Draw_Pat_VL_a(volatile const unsigned int a, void* volatile const x); // 0xF434
__NO_INLINE void __Draw_Pat_VL(void* volatile const x); // 0xF437
__NO_INLINE void __Draw_Pat_VL_d(volatile const long unsigned int d, void* volatile const x); // 0xF439, not official
__NO_INLINE void __Draw_Line_d(volatile const int a, volatile const int b); // 0xF3DF
__NO_INLINE void __Draw_VLc(void* volatile const x); // 0xF3CE, count y x y x ...
__NO_INLINE void __Draw_VL_ab(volatile const unsigned int a, volatile const unsigned int b, void* volatile const x); // 0xF3D8
__NO_INLINE void __Draw_VL(void* volatile const x); // 0xF3DD, y x y x ...
__NO_INLINE void __Draw_VLcs(void* volatile const x); // 0xF3D6, count scale y x y x ...
__NO_INLINE void __Draw_VL_b(volatile const unsigned int b, void* volatile const x); // 0xF3D2, x x y x ...
__NO_INLINE void __Draw_VL_a(volatile const unsigned int a, void* volatile const x); // 0xF3DA, y x y x ...

// ---------------------------------------------------------------------------
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

__NO_INLINE void __Mov_Draw_VLc_a(void* volatile const x); // 0xF3AD, count y x y x ...
__NO_INLINE void __Mov_Draw_VL_b(volatile const unsigned int b, void* volatile const x); // 0xF3B1, y x y x ...
__NO_INLINE void __Mov_Draw_VLcs(void* volatile const x); // 0xF3B5, count scale y x y x ...
__NO_INLINE void __Mov_Draw_VL_ab(volatile const unsigned int a, volatile const unsigned int b, void* volatile const x); // 0xF3B7
__NO_INLINE void __Mov_Draw_VL_a(volatile const unsigned int a, void* volatile const x); // 0xF3B9, y x y x ...
__NO_INLINE void __Mov_Draw_VL(void* volatile const x); // 0xF3BC, y x y x ...
__NO_INLINE void __Mov_Draw_VL_d(volatile const int a, volatile const int b); // 0xF3BE, y x

// ---------------------------------------------------------------------------
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

__NO_INLINE void __Draw_VL_mode(volatile const const void* x); // 0xF46E
__NO_INLINE void __Draw_VLp_7F(void* volatile const x); // 0xF408, pattern y x pattern y x ... 0x01
__NO_INLINE void __Draw_VLp_FF(void* volatile const x); // 0xF404, pattern y x pattern y x ... 0x01
__NO_INLINE void __Draw_VLp_b(volatile const unsigned int b, void* volatile const x); // 0xF40E, scale pattern y x pattern y x ... 0x01
__NO_INLINE void __Draw_VLp(void* const x); // 0xF410, pattern y x pattern y x ... 0x01
__NO_INLINE void __Draw_VLp_scale(void* volatile const x); // 0xF40C, scale pattern y x pattern y x ... 0x01
__NO_INLINE void __Rot_VL_Mode_a(volatile const unsigned int a, void* volatile const x, void* volatile const u); // 0xF61F 
__NO_INLINE void __Rot_VL_Pack(void* volatile const x, void* volatile const u); // 0xF622

// rotate vl, not official!
// (mode, rel_y, rel_x)+, 0x01
// __NO_INLINE _Rot_VL_Mode(volatile const unsigned int a, void* volatile const x, void* volatile const u); // 0xF61F, d, x, u
// __NO_INLINE _Rot_VL_M_dft(void* volatile const x, void* volatile const u); // 0xF62B, d, x, u, 
// ---------------------------------------------------------------------------
// 5.4 Unknown

// NIBBY 	0xFF9F 	--- 	Draw vector grid list
// __NO_INLINE void __Draw_Grid_VL(void* volatile const x, void* volatile const y); //0xFF9F, not official

// ---------------------------------------------------------------------------
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

__NO_INLINE unsigned int __Random_3(void); // 0xF511 
__NO_INLINE unsigned int __Random(void); // 0xF517
__NO_INLINE unsigned int __xRandom(void); // 0xF517

__NO_INLINE unsigned int __Bitmask_a(volatile const unsigned int a); // 0xF57E

__NO_INLINE long unsigned int __Abs_a_b(volatile const int a, volatile const int b); // 0xF584
__NO_INLINE unsigned int __Abs_b(volatile const int b); // 0xF58B

__NO_INLINE long unsigned int __Rise_Run_Angle(volatile const int a, volatile const int b); // 0xF593
__NO_INLINE long unsigned int __Get_Rise_Idx(volatile const int a); // 0xF5D9
__NO_INLINE int __Xform_Sin(volatile const int a); // 0xF5DB
__NO_INLINE long unsigned int __Get_Rise_Run(void); // 0xF5EF

__NO_INLINE int __Xform_Run_a(volatile const int a); // 0xF65B 
__NO_INLINE int __Xform_Run(void); // 0xF65D 
__NO_INLINE int __Xform_Rise_a(volatile const int a); // 0xF661 
__NO_INLINE int __Xform_Rise(void); // 0xF663 

// ---------------------------------------------------------------------------
// 7.1 Memory Management - Memory Clear Functions

// CLRSON 	0xF53F 	BCLR 	Clear 'B' bytes
// CLRMEM 	0xF542 	CLREX 	Clear 256 bytes starting at 0xC800
// CLR256 	0xF545 	---6 	Set-up to clear 256 bytes
// GILL 	0xF548 	CLRBLK 	Clear a block of memory

__NO_INLINE void __Clear_x_b(volatile const unsigned int b, void* volatile const x); // 0xF53F
__NO_INLINE void __Clear_C8_RAM(void); // 0xF542, never used by GCE carts?
__NO_INLINE void __Clear_x_256(void* volatile const x); // 0xF545
__NO_INLINE void __Clear_x_d(volatile const long unsigned int d, void* volatile const x); // 0xF548

// ---------------------------------------------------------------------------
// 7.2 Memory Management - Memory Copy Functions

// BAGAUX 	0xF67F 	BLKMV1 	Xfer bytes source to destination buffer
// STFAUX 	0xF683 	BLKMOV 	Xfer bytes source to destination buffer

__NO_INLINE void __Move_Mem_a_1(volatile const unsigned int a, void* volatile const x, void* volatile const u); // 0xF67F 
__NO_INLINE void __Move_Mem_a(volatile const unsigned int a, void* volatile const x, void* volatile const u); // 0xF683

// ---------------------------------------------------------------------------
// 7.3 Memory Management - Memory Fill Functions

// NEGSOM 	0xF550 	CLR80 	Set a block of memory to $80
// FILL 	0xF552 	BLKFIL 	Set a block of memory

__NO_INLINE void __Clear_x_b_80(volatile const int b, void* volatile const x); // 0xF550
__NO_INLINE void __Clear_x_b_a(volatile const unsigned int a, volatile const unsigned int b, void* volatile const x); // 0xF552

// ---------------------------------------------------------------------------
// 8. Controller / Joystick Routines

// ENPUT 	0xF1B4 	DBNCE 	Read controller buttones
// INPUT 	0xF1BA 	--- 	Read controller buttones
// PBANG4 	0xF1F5 	JOYSTK 	Read joystick
// PANG 	0xF1F8 	JOYBIT 	Read joystick

__NO_INLINE void __Read_Btns_Mask(volatile const unsigned int a); // 0xF1B4
__NO_INLINE void __Read_Btns(void); // 0xF1BA
__NO_INLINE void __Joy_Analog(void); //0xF1F5
__NO_INLINE void __Joy_Digital(void); // 0xF1F8

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

// ---------------------------------------------------------------------------
// 9. Player Option Functions

// OPTION 	0xF7A9 	SELOPT 	Fetch game options
// DISOPT	0xF835	------	Display game option, inofficial!

__NO_INLINE void __Select_Game(volatile const unsigned int a, volatile const unsigned int b); // 0xF7A9
__NO_INLINE void __Display_Option(volatile const unsigned int a, const void (*volatile const const y)); // 0xF835 - inofficial!

// ---------------------------------------------------------------------------
// 10. Reset and Initialization Routines

// POWER 	0xF000 	PWRUP 	Power-up handler
// INITPIA 	0xF14C 	INTPIA 	Initialize PIA
// INITMSC 	0xF164 	INTMSC 	Initialize misc. parameters
// INITALL 	0xF18B 	INTALL 	Full Vectrex initialization
// INITPSG 	0xF272 	INTPSG 	Initialize sound generator
// IREQ 	0xF533 	INTREQ 	Initialize the 'REQZ' area

__NO_INLINE void __Reset(void); // 0xF000
__NO_INLINE void __Init_VIA(void); // 0xF14C
__NO_INLINE void __Init_OS_RAM(void); // 0xF164
__NO_INLINE void __Init_OS(void); // 0xF18B
__NO_INLINE void __Init_Music_Buf(void); // 0xF533

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

// ---------------------------------------------------------------------------
// 11. Score / Highscore Routines

// SCLR 	0xF84F 	--- 	Clear indicated score
// SHADD 	0xF85E 	BYTADD 	Add contents of 'A' to indicated score
// SADD 	0xF87C 	SCRADD 	Add contents of 'B' to indicated score
// WINNER 	0xF8C7 	--- 	Determine highest score
// HIGHSCR 	0xF8D8 	HISCR 	Calculate high score and save for logo

__NO_INLINE void __Clear_Score(void* volatile const x); //0xF84F
__NO_INLINE void __Add_Score_a(volatile const unsigned int a, void* volatile const x); // 0xF85E
__NO_INLINE void __Add_Score_d(volatile const long unsigned int d, void* volatile const x); // 0xF87C
__NO_INLINE void __Strip_Zeros(volatile const unsigned int b, void* volatile const x); // 0xF8B7
__NO_INLINE unsigned int __Compare_Score(void* volatile const x, void* volatile const u); // 0xF8C7
__NO_INLINE void __New_High_Score(void* volatile const x, void* volatile const u); //0xF8D8

// ---------------------------------------------------------------------------
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

__NO_INLINE void __Sound_Byte(volatile const unsigned int a, volatile const unsigned int b); // 0xF256
__NO_INLINE void __Sound_Byte_x(volatile const unsigned int a, volatile const unsigned int b, void* volatile const x); // 0xF259 
__NO_INLINE void __Clear_Sound(void); // 0xF272 
__NO_INLINE void __Sound_Bytes(void* volatile const u); // 0xF27D 
__NO_INLINE void __Sound_Bytes_x(void* volatile const x, void* volatile const u); // 0xF284
__NO_INLINE void __Do_Sound(void); // 0xF289
__NO_INLINE void __Do_Sound_x(void* volatile const x); // 0xF28C, not official! 
__NO_INLINE void __Init_Music_chk(volatile const const void* u); // 0xF687
__NO_INLINE void __Init_Music(void* volatile const u); // 0xF68D 
__NO_INLINE void __Init_Music_a(void* volatile const x, void* volatile const u); // 0xF690 
__NO_INLINE void __Init_Music_x(void* volatile const u); // 0xF692 
__NO_INLINE void __Stop_Sound(void); // 0xF742
__NO_INLINE void __Explosion_Snd(volatile const const void* u); // 0xF92E 
__NO_INLINE void __Set_Amp(volatile const unsigned int b); // 0xF9CA

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

// ---------------------------------------------------------------------------
// 13. Vector Beam Positioning Functions

// POSWID 	0xF2F2 	--- 	Position relative vector
// POSITD 	0xF2FC 	--- 	Position relative vector
// POSIT2 	0xF308 	--- 	Position relative vector
// POSIT1 	0xF30C 	--- 	Position relative vector
// POSITB 	0xF30E 	--- 	Position relative vector
// POSITX 	0xF310 	--- 	Position relative vector
// POSITN 	0xF312 	--- 	Position relative vector

__NO_INLINE void __Moveto_x_7F(void* volatile const x); // 0xF2F2
__NO_INLINE void __Moveto_d_7F(volatile const int a, volatile const int b); // 0xF2FC
__NO_INLINE void __Moveto_dd_7F(volatile const long int d); // 0xF2FC
__NO_INLINE void __Moveto_ix_FF(void* volatile const x); // 0xF308 
__NO_INLINE void __Moveto_ix_7F(void* volatile const x); // 0xF30C 
__NO_INLINE void __Moveto_ix_b(volatile const unsigned int b, void* volatile const x); // 0xF30E 
__NO_INLINE void __Moveto_ix(void* volatile const x); // 0xF310 
__NO_INLINE void __Moveto_d(volatile const int a, volatile const int b); // 0xF312
__NO_INLINE void __Moveto_dd(volatile const long int d); // 0xF312, performance opt!

// ---------------------------------------------------------------------------
// 14. Vector Brightness Functions

// INT1Q 	0xF29D 	--- 	Set beam intensity
// INTMID 	0xF2A1 	INT2Q 	Set beam intensity
// INT3Q 	0xF2A5 	--- 	Set beam intensity
// INTMAX 	0xF2A9 	--- 	Set beam intensity
// INTENS 	0xF2AB 	--- 	Set beam intensity

__NO_INLINE void __Intensity_1F(void); // 0xF29D
__NO_INLINE void __Intensity_3F(void); // 0xF2A1 
__NO_INLINE void __Intensity_5F(void); // 0xF2A5 
__NO_INLINE void __Intensity_7F(void); // 0xF2A9 
__NO_INLINE void __Intensity_a(volatile const unsigned int a); // 0xF2AB

// ---------------------------------------------------------------------------
// 15.1 Object Collision Detection Functions

// OFF1BOX 	0xF8E5 	OFF1BX 	Symmetric collison test
// OFF2BOX 	0xF8F3 	OFF2BX 	Symmetric collison test
// FINDBOX 	0xF8FF 	BXTEST 	Symmetric collison test

__NO_INLINE unsigned int __Obj_Will_Hit_u(volatile const int a, volatile const int b, volatile const long int x, volatile const long int y, volatile const long int u); // 0xF8E5
__NO_INLINE unsigned int __Obj_Will_Hit(volatile const int a, volatile const int b, volatile const long int x, volatile const long int y, volatile const long int* u); // 0xF8F3

__NO_INLINE unsigned int __Obj_Hit(volatile const int a, volatile const int b, volatile const long int x, volatile const long int y); // 0xF8FF

// ---------------------------------------------------------------------------
// 15.2 Rotate Routines

// RATOT 	0xF5FF 	LROT90 	Rotate a single line
// ROTOR 	0xF601 	LNROT 	Rotate a single line
// ROTAR 	0xF603 	ALNROT 	Rotate a single line
// DANROT 	0xF610 	DROT 	'DIFFY' style rotate
// DISROT 	0xF613 	BDROT 	'DIFFY' style rotate
// DIFROT 	0xF616 	ADROT 	'DIFFY' style rotate
// POTATA 	0xF61F 	PROT 	'PACKET' style rotate
// POTATE 	0xF622 	APROT 	'PACKET' style rotate

__NO_INLINE long unsigned int __Rise_Run_X(volatile const int a, volatile const int b); // 0xF5FF
__NO_INLINE long unsigned int __Rise_Run_Y(volatile const int a, volatile const int b); // 0xF601
__NO_INLINE int __Rise_Run_Len(volatile const int a); // 0xF603
__NO_INLINE void __Rot_VL_ab(volatile const unsigned int a, volatile const unsigned int b, void* volatile const x, void* volatile const u);  // 0xF610
__NO_INLINE void __Rot_VL_Diff(volatile const unsigned int b, void* volatile const x, void* volatile const u); // 0xF613
__NO_INLINE void __Rot_VL(void* volatile const x, void* volatile const u); // 0xF616 

// rotate vl, not official!
// (mode, rel_y, rel_x)+, 0x01
// __NO_INLINE _Rot_VL_Mode(volatile const unsigned int a, void* volatile const x, void* volatile const u); // 0xF61F, d, x, u
// __NO_INLINE _Rot_VL_M_dft(void* volatile const x, void* volatile const u); // 0xF62B, d, x, u, 

// *******************************************************************************************
// BIOS calls
// The BIOS calls assume that the DP register is set up correctly,
// so you are responsible for doing that by using the BIOS calls
// _DP_to_D0(...) or _DP_to_C8(...) as apropriate
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

// ---------------------------------------------------------------------------
// MINESTORM

__NO_INLINE void __Dot_y(volatile const long int y); // 0xEA5D
__NO_INLINE void __Dot_py(void* volatile const y); // 0xEA6D

__NO_INLINE void __Draw_Pack(volatile const unsigned int b, void* volatile const x, volatile const long int y); // 0xEA7F
__NO_INLINE void __Draw_Pack_py(volatile const unsigned int b, void* volatile const x, void* volatile const y); // 0xEA8D

__NO_INLINE void __Print_Msg(void* volatile const y, void* volatile const u); // 0xEAA8
__NO_INLINE unsigned int __Rnd_Cone(void); // 0xEA3E

__NO_INLINE long unsigned int __Displ8_xy(volatile const unsigned int a, volatile const unsigned int b); // 0xE7B5
__NO_INLINE long unsigned int __Displ16_xy(volatile const unsigned int a, volatile const unsigned int b);// 0xE7D2

__NO_INLINE long unsigned int __Ranpos(void); // 0xE98A
__NO_INLINE void __Draw_Scores(void); // 0xEACF
__NO_INLINE void __Draw_Score(void); // 0xEAB4
__NO_INLINE void __Wait_Bound(void); // 0xEAF0

// ***************************************************************************
// end of file
// ***************************************************************************
