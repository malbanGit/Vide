
/*
 * Vectrex.h
 *
 * C/C++ port and assembler BIOS call macros by Joakim Larsson Edstrom, (c) 2015
 * https://github.com/JoakimLarsson
 * 
 * This file is based on previous work by many:
;
; VECTREX.INC was part of vectrex frogger, written by Bruce Tomlin and changed
; by Christopher Salomon in March-April 1998, all stuff contained there is public domain (?)
;
 * BIOS.ASM was used as a reference:
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at: http://www.falstaff.demon.co.uk/cross.html
;
 * Oliver Soehlke and his site http://vectrexmuseum.com/ for reference documentation
 *
 * License: GPLv3:
 *
    This file is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

*
* TODO:
* - Fix all BIOS calls with proper argument handling, now all defaults to no arguments.
* - Fix clobbered list for all BIOS calls, now it is rundamentary
*
* INFO:
*   In general stuff is fixed as it is used, check that the BIOS calls you use seems to 
*   have a comment, arguments handled if any and optionally add a clobbered list. The
*   clobbered list instructs the compiler what registers is trashed by the BIOS call.
*
*   The BIOS calls assumes that the DP register is set up correctly so you are responsible 
*   for doing that by using the BIOS calls DP_to_D0() or DP_to_C8() as apropriate
*/

/* Types */
//typedef signed char int8_t;
typedef signed int int8_t;
//typedef unsigned char uint8_t;
typedef unsigned int uint8_t;

#define true (1==1)
#define false (1==0)

// Byte pointer
#define BP(x) *((volatile uint8_t *) x)

#define Vec_Snd_Shadow       BP(0xC800) // Shadow of sound chip registers (15 bytes)
#define Vec_Btn_State        BP(0xC80F) // Current state of all joystick buttons
#define Vec_Prev_Btns        BP(0xC810) // Previous state of all joystick buttons
#define Vec_Buttons          BP(0xC811) // Current toggle state of all buttons
#define Vec_Button_1_1       BP(0xC812) // Current toggle state of stick 1 button 1
#define Vec_Button_1_2       BP(0xC813) // Current toggle state of stick 1 button 2
#define Vec_Button_1_3       BP(0xC814) // Current toggle state of stick 1 button 3
#define Vec_Button_1_4       BP(0xC815) // Current toggle state of stick 1 button 4
#define Vec_Button_2_1       BP(0xC816) // Current toggle state of stick 2 button 1
#define Vec_Button_2_2       BP(0xC817) // Current toggle state of stick 2 button 2
#define Vec_Button_2_3       BP(0xC818) // Current toggle state of stick 2 button 3
#define Vec_Button_2_4       BP(0xC819) // Current toggle state of stick 2 button 4
#define Vec_Joy_Resltn       BP(0xC81A) // Joystick A/D resolution (0x80=min 0x00=max)
#define Vec_Joy_1_X          BP(0xC81B) // Joystick 1 left/right
#define Vec_Joy_1_Y          BP(0xC81C) // Joystick 1 up/down
#define Vec_Joy_2_X          BP(0xC81D) // Joystick 2 left/right
#define Vec_Joy_2_Y          BP(0xC81E) // Joystick 2 up/down
#define Vec_Joy_Mux          BP(0xC81F) // Joystick enable/mux flags (4 bytes)
#define Vec_Joy_Mux_1_X      BP(0xC81F) // Joystick 1 X enable/mux flag (=1)
#define Vec_Joy_Mux_1_Y      BP(0xC820) // Joystick 1 Y enable/mux flag (=3)
#define Vec_Joy_Mux_2_X      BP(0xC821) // Joystick 2 X enable/mux flag (=5)
#define Vec_Joy_Mux_2_Y      BP(0xC822) // Joystick 2 Y enable/mux flag (=7)
#define Vec_Misc_Count       BP(0xC823) // Misc counter/flag byte, zero when not in use
#define Vec_0Ref_Enable      BP(0xC824) // Check0Ref enable flag
#define Vec_Loop_Count       BP(0xC825) // Loop counter word (incremented in Wait_Recal)
#define Vec_Brightness       BP(0xC827) // Default brightness
#define Vec_Dot_Dwell        BP(0xC828) // Dot dwell time?
#define Vec_Pattern          BP(0xC829) // Dot pattern (bits)
#define Vec_Text_HW          BP(0xC82A) // Default text height and width
#define Vec_Text_Height      BP(0xC82A) // Default text height
#define Vec_Text_Width       BP(0xC82B) // Default text width
#define Vec_Str_Ptr          BP(0xC82C) // Temporary string pointer for Print_Str
#define Vec_Counters         BP(0xC82E) // Six bytes of counters
#define Vec_Counter_1        BP(0xC82E) // First  counter byte
#define Vec_Counter_2        BP(0xC82F) // Second counter byte
#define Vec_Counter_3        BP(0xC830) // Third  counter byte
#define Vec_Counter_4        BP(0xC831) // Fourth counter byte
#define Vec_Counter_5        BP(0xC832) // Fifth  counter byte
#define Vec_Counter_6        BP(0xC833) // Sixth  counter byte
#define Vec_RiseRun_Tmp      BP(0xC834) // Temp storage word for rise/run
#define Vec_Angle            BP(0xC836) // Angle for rise/run and rotation calculations
#define Vec_Run_Index        BP(0xC837) // Index pair for run
//                       0xC839   ;Pointer to copyright string during startup
#define Vec_Rise_Index       BP(0xC839) // Index pair for rise
//                       0xC83B   ;High score cold-start flag (=0 if valid)
#define Vec_RiseRun_Len      BP(0xC83B) // length for rise/run
//                       0xC83C   ;temp byte
#define Vec_Rfrsh            BP(0xC83D) // Refresh time (divided by 1.5MHz)
#define Vec_Rfrsh_lo         BP(0xC83D) // Refresh time low byte
#define Vec_Rfrsh_hi         BP(0xC83E) // Refresh time high byte
#define Vec_Music_Work       BP(0xC83F) // Music work buffer (14 bytes, backwards?)
#define Vec_Music_Wk_A       BP(0xC842) //         register 10
//                       0xC843   ;        register 9
//                       0xC844   ;        register 8
#define Vec_Music_Wk_7       BP(0xC845) //         register 7
#define Vec_Music_Wk_6       BP(0xC846) //         register 6
#define Vec_Music_Wk_5       BP(0xC847) //         register 5
//                       0xC848   ;        register 4
//                       0xC849   ;        register 3
//                       0xC84A   ;        register 2
#define Vec_Music_Wk_1       BP(0xC84B) //         register 1
//                       0xC84C   ;        register 0
#define Vec_Freq_Table       BP(0xC84D) // Pointer to note-to-frequency table (normally 0xFC8D)
#define Vec_Max_Players      BP(0xC84F) // Maximum number of players for Select_Game
#define Vec_Max_Games        BP(0xC850) // Maximum number of games for Select_Game
#define Vec_ADSR_Table       BP(0xC84F) // Storage for first music header word (ADSR table)
#define Vec_Twang_Table      BP(0xC851) // Storage for second music header word ('twang' table)
#define Vec_Music_Ptr        BP(0xC853) // Music data pointer
#define Vec_Expl_ChanA       BP(0xC853) // Used by Explosion_Snd - bit for first channel used?
#define Vec_Expl_Chans       BP(0xC854) // Used by Explosion_Snd - bits for all channels used?
#define Vec_Music_Chan       BP(0xC855) // Current sound channel number for Init_Music
#define Vec_Music_Flag       BP(0xC856) // Music active flag (0x00=off 0x01=start 0x80=on)
#define Vec_Duration         BP(0xC857) // Duration counter for Init_Music
#define Vec_Music_Twang      BP(0xC858) // 3 word 'twang' table used by Init_Music
#define Vec_Expl_1           BP(0xC858) // Four bytes copied from Explosion_Snd's U-reg parameters
#define Vec_Expl_2           BP(0xC859) // 
#define Vec_Expl_3           BP(0xC85A) // 
#define Vec_Expl_4           BP(0xC85B) // 
#define Vec_Expl_Chan        BP(0xC85C) // Used by Explosion_Snd - channel number in use?
#define Vec_Expl_ChanB       BP(0xC85D) // Used by Explosion_Snd - bit for second channel used?
#define Vec_ADSR_Timers      BP(0xC85E) // ADSR timers for each sound channel (3 bytes)
#define Vec_Music_Freq       BP(0xC861) // Storage for base frequency of each channel (3 words)
//                       0xC85E   ;Scratch 'score' storage for Display_Option (7 bytes)
#define Vec_Expl_Flag        BP(0xC867) // Explosion_Snd initialization flag?
//               0xC868...0xC876   ;Unused?
#define Vec_Expl_Timer       BP(0xC877) // Used by Explosion_Snd
//                       0xC878   ;Unused?
#define Vec_Num_Players      BP(0xC879) // Number of players selected in Select_Game
#define Vec_Num_Game         BP(0xC87A) // Game number selected in Select_Game
#define Vec_Seed_Ptr         BP(0xC87B) // Pointer to 3-byte random number seed (=0xC87D)
#define Vec_Random_Seed      BP(0xC87D) // Default 3-byte random number seed

//;*    0xC880 - 0xCBEA is user RAM  ;
                                ;
#define Vec_Default_Stk      BP(0xCBEA) // Default top-of-stack
#define Vec_High_Score       BP(0xCBEB) // High score storage (7 bytes)
#define Vec_SWI3_Vector      BP(0xCBF2) // SWI2/SWI3 interrupt vector (3 bytes)
#define Vec_SWI2_Vector      BP(0xCBF2) // SWI2/SWI3 interrupt vector (3 bytes)
#define Vec_FIRQ_Vector      BP(0xCBF5) // FIRQ interrupt vector (3 bytes)
#define Vec_IRQ_Vector       BP(0xCBF8) // IRQ interrupt vector (3 bytes)
#define Vec_SWI_Vector       BP(0xCBFB) // SWI/NMI interrupt vector (3 bytes)
#define Vec_NMI_Vector       BP(0xCBFB) // SWI/NMI interrupt vector (3 bytes)
#define Vec_Cold_Flag        BP(0xCBFE) // Cold start flag (warm start if = 0x7321)
                                ;
#define VIA_port_b           BP(0xD000) // VIA port B data I/O register
//       0 sample/hold (0=enable  mux 1=disable mux)
//       1 mux sel 0
//       2 mux sel 1
//       3 sound BC1
//       4 sound BDIR
//       5 comparator input
//       6 external device (slot pin 35) initialized to input
//       7 /RAMP
#define VIA_port_a       BP(0xD001)  // VIA port A data I/O register (handshaking)
#define VIA_DDR_b        BP(0xD002)  // VIA port B data direction register (0=input 1=output)
#define VIA_DDR_a        BP(0xD003)  // VIA port A data direction register (0=input 1=output)
#define VIA_t1_cnt_lo    BP(0xD004)  // VIA timer 1 count register lo (scale factor)
#define VIA_t1_cnt_hi    BP(0xD005)  // VIA timer 1 count register hi
#define VIA_t1_lch_lo    BP(0xD006)  // VIA timer 1 latch register lo
#define VIA_t1_lch_hi    BP(0xD007)  // VIA timer 1 latch register hi
#define VIA_t2_lo        BP(0xD008)  // VIA timer 2 count/latch register lo (refresh)
#define VIA_t2_hi        BP(0xD009)  // VIA timer 2 count/latch register hi
#define VIA_shift_reg    BP(0xD00A)  // VIA shift register
#define VIA_aux_cntl     BP(0xD00B)  // VIA auxiliary control register
//       0 PA latch enable
//       1 PB latch enable
//       2 \                     110=output to CB2 under control of phase 2 clock
//       3  > shift register control     (110 is the only mode used by the Vectrex ROM)
//       4 /
//       5 0=t2 one shot                 1=t2 free running
//       6 0=t1 one shot                 1=t1 free running
//       7 0=t1 disable PB7 output       1=t1 enable PB7 output
#define VIA_cntl             BP(0xD00C) // VIA control register
//       0 CA1 control     CA1 -> SW7    0=IRQ on low 1=IRQ on high
//       1 \
//       2  > CA2 control  CA2 -> /ZERO  110=low 111=high
//       3 /
//       4 CB1 control     CB1 -> NC     0=IRQ on low 1=IRQ on high
//       5 \
//       6  > CB2 control  CB2 -> /BLANK 110=low 111=high
//       7 /
#define VIA_int_flags        BP(0xD00D) // VIA interrupt flags register
//               bit                             cleared by
//       0 CA2 interrupt flag            reading or writing port A I/O
//       1 CA1 interrupt flag            reading or writing port A I/O
//       2 shift register interrupt flag reading or writing shift register
//       3 CB2 interrupt flag            reading or writing port B I/O
//       4 CB1 interrupt flag            reading or writing port A I/O
//       5 timer 2 interrupt flag        read t2 low or write t2 high
//       6 timer 1 interrupt flag        read t1 count low or write t1 high
//       7 IRQ status flag               write logic 0 to IER or IFR bit
#define VIA_int_enable       BP(0xD00E) // VIA interrupt enable register
//       0 CA2 interrupt enable
//       1 CA1 interrupt enable
//       2 shift register interrupt enable
//       3 CB2 interrupt enable
//       4 CB1 interrupt enable
//       5 timer 2 interrupt enable
//       6 timer 1 interrupt enable
//       7 IER set/clear control
#define VIA_port_a_nohs      BP(0xD00F) // VIA port A data I/O register (no handshaking)

// BIOS calls
/*
 * C macros with inline assembler for the Vectrex BIOS calls
 */

/* Syntax:

  asm (    assembler template 
           : output operands                  ( optional )
           : input operands                   ( optional )
           : list of clobbered registers      ( optional )
           );

The "assembler template" can be any number of assembler instructions concatenated
as strings ending with \n\t for readability is list files etc.
The "output operands" part is usually empty since most BIOS calls doesn't return a value
The "input operands" describes which parameters to use
The "list of clobbered registers" tells the compiler what registers are trashed by the BIOS call

The operands has a type and a name, for example "g" (x) 
The name is a C identifyer or constant value, for example

  (x) - will link the operand to the symbol x

The type is describing what can be done with it, for example:

 "g" - Any register, memory or immediate integer operand is allowed, except for 
       registers that are not general registers.

The list of clobbered registers is a comma separated string like this

: "a", "b", "x", "y", "u"

In 6809 the "d" register is the 16 bit result of register "a" * 256 + register "b"
so "d" will tell the compiler that both "a" and "b" will be trashed using the inline
assembler statement at hand. Default the compiler assumes that "a" and "x" is trashed.

Read more about inline assembler here:
  https://gcc.gnu.org/onlinedocs/gcc/Using-Assembly-Language-with-C.html

Read more about how the GCC6809 allocates registers here:
  http://web.archive.org/web/20090201175459/http://www.oddchange.com/gcc6809/manual.html

On top of all this I use C macros to reuse code assember constructs as mush as possible
The BIOS function call macros are calling the apropriate C macro template(s) to handle
the arguments properly. This ensures a minimum of overhead.

The naming convention is "jsr" + list of used registers in same order as marco arguments,
for example jsrab(x, y) should map x to register 'a' and y to register 'b' 

*/

/*
 * Templates
 */
#define jsr(func)           asm("jsr " #func "\n\t" : : : "d", "x")

#define jsra(i, func)       asm("lda %0\n\t" \
                                "jsr " #func "\n\t" : : "g" (i) : "d", "x")

#define jsrba(x, y, func)   asm("lda %1\n\t" \
                                "ldb %0\n\t" \
                                "jsr " #func "\n\t" : : "g" (x), "g" (y) : "d", "x")

#define jsru(m, func)       asm("ldu %0\n\t" \
                                "jsr " #func "\n\t" : : "g" (m) : "d", "x", "u")

#define jsrx(v, func)       asm("ldx %0\n\t" \
                                "jsr " #func "\n\t" : : "g" (v) : "d", "x")

#define jsrxb(c, s, func)   asm("ldx %0\n\t" \
                                "ldb %01\n\t" \
                                "jsr " #func "\n\t" : : "g" (c), "g" (s) : "d", "x")
/*
#define jsrabu(y, x, pointer, func)   asm("ldu %2\n\t" \
                                "lda %00\n\t" \
                                "ldb %01\n\t" \
                                "jsr " #func "\n\t" : : "g" (y), "g" (x), "g" (pointer) : "d", "u", "x")
*/
#define jsrdu(d, pointer, func, comment)   asm("ldu %01\n\t" \
                                "ldd %00\t;  "#comment" \n\t" \
                                "jsr " #func "\n\t" : : "g" (d), "g" (pointer) : "d", "u", "x")
#define jsrabu(a, b, pointer, func)  jsrdu((a*256+b), pointer, func, (y=#a, x=#b))




/*
 * BIOS calls
 */

/* Comments below ripped from http://vectrexmuseum.com/share/coder/html/appendixa.htm

/* Cold_Start: Jump here to restart the Vectrex and re-initialize the OS. 
   If the cold start flag is correct (it should be unless you just turned the 
   Vectrex on), the cold start code is skipped. On cold start, the high score 
   is cleared, and the power-on screen is displayed with the power-on music.*/
#define Cold_Start()         jsr(0xF000)

/* Warm_Start: Jump here to restart the Vectrex without re-initializing the OS. */
#define Warm_Start()         jsr(0xF06C) 

/* Init_VIA: This routine is invoked during powerup, to initialize the VIA chip. 
   Among other things, it initializes the scale factor to 0x7F, and sets up the 
   direction for the port A and B data lines. DP=D0 */
#define Init_VIA()           jsr(0xF14C)

/* Init_OS_RAM: This routine first clears the block of RAM in the range 0xC800 
   to 0xC87A, and then it initializes the dot dwell time, the refresh time, and 
   the joystick enable flags. DP=C8 */
#define Init_OS_RAM()        jsr(0xF164)

/* Init_OS: This routine is responsible for setting up the initial system state, 
   each time the system is either reset or powered up. It will initialize the 
   OS RAM area, initialize the VIA chip, and then clear all the registers on the 
   sound chip. DP=D0 */ 
#define Init_OS()            jsr(0xF18B)

/* Wait_Recal: Wait for t2 (the refresh timer) to timeout, then restart it using 
   the value in 0xC83D. then, recalibrate the vector generators to the origin (0,0). 
   This routine MUST be called once every refresh cycle, or your vectors will get 
   out of whack. This routine calls Reset0Ref, so the integrators are left in zero 
   mode. DP=D0 */
#define Wait_Recal()         jsr(0xF192)

/* Set_Refresh: This routine loads the refresh timer (t2) with the value in 0xC83D- 
   0xC83E, and recalibrates the vector generators, thus causing the pen to be left 
   at the origin (0,0). The high order byte for the timer is loaded from 0xC83E, 
   and the low order byte is loaded from 0xC83D. 

   The refresh rate is calculated as follows: rate = (C83E)(C83D) / 1.5 mhz */
#define Set_Refresh()        jsr(0xF1A2)

/* DP_to_D0: Sets the DP register to 0xD0, so that all direct page addressing will 
   start at 0xD000 (the hardware I/O area). */
#define DP_to_D0()           jsr(0xF1AA)

/* DP_to_C8: Sets the DP register to 0xC8, so that all direct page addressing will 
   start at 0xC800 (OS RAM area). */
#define DP_to_C8()           jsr(0xF1AF)


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
#define Read_Btns()          jsr(0xF1BA)

/* Read_Btns_mask: Like Read_Btns but only returning the bits set to 1 in the mask */
#define Read_Btns_Mask(m)    jsra(m, 0xF1B4) 

/* Joy_Analog read the current positions of the two joysticks. The joystick enable 
   flags (C81F-C822) must be initialized to one of the following values:

  0 - ignore; return no value.
  1 - return state of console 1 left/right position.
  3 - return state of console 1 up/down position.
  5 - return state of console 2 left/right position.
  7 - return state of console 2 up/down position.

   The joystick values are returned in $C81B-$C81E, where the value returned in $C81B 
   corresponds to the mask set in in $C81F, and so on and so forth. 
   A successive approximation algorithm is used to read the actual value of the joystick 
   pot, a signed value. In this case, $C81A must be set to a power of 2, to to control 
   conversion resolution; 0x80 is least accurate, and 0x00 is most accurate. */
#define Joy_Analog()         jsr(0xF1F5)

/* Joy_Digital: Same principle as for Joy_Analog but the return values in $C81B-$C81E:

< 0 if joystick is left of down of center.
= 0 if joystick is centered.
> 0 if joystick is right or up of center.*/
#define Joy_Digital()        jsr(0xF1F8)

#define Sound_Byte()         jsr(0xF256)


#define Sound_Byte_x()       jsr(0xF259)   // 
#define Sound_Byte_raw()     jsr(0xF25B)   // 
#define Clear_Sound()        jsr(0xF272)   // 
#define Sound_Bytes()        jsr(0xF27D)   // 
#define Sound_Bytes_x()      jsr(0xF284)   // 
#define Do_Sound()           jsr(0xF289)   // 
#define Do_Sound_x()         jsr(0xF28C)   // 
#define Intensity_1F()       jsr(0xF29D)   // 
#define Intensity_3F()       jsr(0xF2A1)   // 
#define Intensity_5F()       jsr(0xF2A5)   // 
#define Intensity_7F()       jsr(0xF2A9)   // 

/* Intensity_a: setting the vector/dot intensity (commonly used to denote the z axis) 
   to a specific value. 0x00 is the lowest intensity, and 0x7F is the brightest 
   intensity. A negative intensity is also lowest intensity (7th bit set). The 
   intensity must be reset to the desired value after each call to Wait_Recal; 
   however, it can also be changed at any other time. A copy of the new intensity 
   value is saved in $C827.*/
#define Intensity_a(i)       jsra(i, 0xF2AB)
#define Intensity(i)       jsra(i, 0xF2AB)

#define Dot_ix_b()           jsr(0xF2BE)   // 
#define Dot_ix()             jsr(0xF2C1)   // 
#define Dot_d()              jsr(0xF2C3)   // 
#define Dot_here()           jsr(0xF2C5)   // 

/* Dot_List: This routine draws a series of dots, using the intensity already set up 
   in $C828. The format for the dot list, which is pointed to by the X register, is:

   ( rel y, rel x), (rel y, rel x), .....

   The number of dots-1 to draw is specified in $C823.*/ 
#define Dot_List(d, l)          Vec_Misc_Count = l; jsrx(d, 0xF2D5)   // 

#define Dot_List_Reset()     jsr(0xF2DE)   // 
#define Recalibrate()        jsr(0xF2E6)   // 
#define Moveto_x_7F()        jsr(0xF2F2)   // 
#define Moveto_d_7F(x, y)    jsrba(x, y, 0xF2FC)   //
#define Moveto_ix_FF()       jsr(0xF308)   // 
#define Moveto_ix_7F()       jsr(0xF30C)   // 

/* Moveto_ix_b: These routines force the scale factor to the value of the B register, 
  and then move the pen to the (y,x) position pointed to by the X-register. 
  The X-register is then incremented by 2. */
#define Moveto_ix_b(c, s)    jsrxb(c, s, 0xF30E)   // 
#define Moveto_ix()          jsr(0xF310)   // 

/* Moveto_d: This routine uses the current scale factor, and moves the pen to the (y,x) 
   position specified in D register. */
#define Moveto_d(x, y)       jsrba(x, y, 0xF312)   // 

#define Reset0Ref_D0()       jsr(0xF34A)   // 
#define Check0Ref()          jsr(0xF34F)   // 
#define Reset0Ref()          jsr(0xF354)   // 
#define Reset_Pen()          jsr(0xF35B)   // 
#define Reset0Int()          jsr(0xF36B)   // 
#define Print_Str_hwyx()     jsr(0xF373)   // 
#define Print_Str_yx()       jsr(0xF378)   // 
#define Print_Str_d(y,x,p)    jsrabu(y,x,p, 0xF37a) 
#define Print_List_hw()      jsr(0xF385)   // 
#define Print_List()         jsr(0xF38A)   // 
#define Print_List_chk()     jsr(0xF38C)   // 
#define Print_Ships_x()      jsr(0xF391)   // 
#define Print_Ships()        jsr(0xF393)   // 
#define Mov_Draw_VLc_a()     jsr(0xF3AD)   // count y x y x ...
#define Mov_Draw_VL_b()      jsr(0xF3B1)   // y x y x ...
#define Mov_Draw_VLcs()      jsr(0xF3B5)   // count scale y x y x ...
#define Mov_Draw_VL_ab()     jsr(0xF3B7)   // y x y x ...
#define Mov_Draw_VL_a()      jsr(0xF3B9)   // y x y x ...
#define Mov_Draw_VL()        jsr(0xF3BC)   // y x y x ...
#define Mov_Draw_VL_d()      jsr(0xF3BE)   // y x y x ...

/* Draw_VLc: This routine draws vectors between the set of (y,x) points 
   pointed to by the X register. The number of vectors to draw is specified 
   as the first byte in the vector list. The current scale factor is used. 
   The vector list has the following format:

     count, rel y, rel x, rel y, rel x, ...
*/
#define Draw_VLc(c)          jsrx(c, 0xF3CE)   // count y x y x ...
#define Draw_VL_b()          jsr(0xF3D2)   // y x y x ...
#define Draw_VLcs()          jsr(0xF3D6)   // count scale y x y x ...
#define Draw_VL_ab()         jsr(0xF3D8)   // y x y x ...
#define Draw_VL_a()          jsr(0xF3DA)   // y x y x ...
#define Draw_VL()            jsr(0xF3DD)   // y x y x ...

/* Draw_Line_d: This routine will draw a line from the current pen position, 
   to the point specified by the (y,x) pair specified in the D register. 
   The current scale factor is used. Before calling this routine, 
   $C823 should be = 0, so that only the one vector will be drawn. */
#define Draw_Line_d(x, y)    jsrba(x, y, 0xf3df) // y x y x ...

#define Draw_VLp_FF()        jsr(0xF404)   // pattern y x pattern y x ... 0x01
#define Draw_VLp_7F(xp)      jsrx(xp, 0xF408)   // pattern y x pattern y x ... 0x01
#define Draw_VLp_scale()     jsr(0xF40C)   // scale pattern y x pattern y x ... 0x01
#define Draw_VLp_b()         jsr(0xF40E)   // pattern y x pattern y x ... 0x01
#define Draw_VLp()           jsr(0xF410)   // pattern y x pattern y x ... 0x01
#define Draw_Pat_VL_a()      jsr(0xF434)   // y x y x ...
#define Draw_Pat_VL()        jsr(0xF437)   // y x y x ...
#define Draw_Pat_VL_d()      jsr(0xF439)   // y x y x ...
#define Draw_VL_mode()       jsr(0xF46E)   // mode y x mode y x ... 0x01
#define Print_Str()          jsr(0xF495)   // 
#define Random_3()           jsr(0xF511)   // 
#define Random()             jsr(0xF517)   // 
#define Init_Music_Buf()     jsr(0xF533)   // 
#define Clear_x_b()          jsr(0xF53F)   // 
#define Clear_C8_RAM()       jsr(0xF542)   // never used by GCE carts?
#define Clear_x_256()        jsr(0xF545)   // 
#define Clear_x_d()          jsr(0xF548)   // 
#define Clear_x_b_80()       jsr(0xF550)   // 
#define Clear_x_b_a()        jsr(0xF552)   // 
#define Dec_3_Counters()     jsr(0xF55A)   // 
#define Dec_6_Counters()     jsr(0xF55E)   // 
#define Dec_Counters()       jsr(0xF563)   // 
#define Delay_3()            jsr(0xF56D)   // 30 cycles
#define Delay_2()            jsr(0xF571)   // 25 cycles
#define Delay_1()            jsr(0xF575)   // 20 cycles
#define Delay_0()            jsr(0xF579)   // 12 cycles
#define Delay_b()            jsr(0xF57A)   // 5*B + 10 cycles
#define Delay_RTS()          jsr(0xF57D)   // 5 cycles
#define Bitmask_a()          jsr(0xF57E)   // 
#define Abs_a_b()            jsr(0xF584)   // 
#define Abs_b()              jsr(0xF58B)   // 
#define Rise_Run_Angle()     jsr(0xF593)   // 
#define Get_Rise_Idx()       jsr(0xF5D9)   // 
#define Get_Run_Idx()        jsr(0xF5DB)   // 
#define Get_Rise_Run()       jsr(0xF5EF)   // 
#define Rise_Run_X()         jsr(0xF5FF)   // 
#define Rise_Run_Y()         jsr(0xF601)   // 
#define Rise_Run_Len()       jsr(0xF603)   // 
#define Rot_VL_ab()          jsr(0xF610)   // 
#define Rot_VL()             jsr(0xF616)   // 
#define Rot_VL_Mode_a()      jsr(0xF61F)   // 
#define Rot_VL_Mode()        jsr(0xF62B)   // 
#define Rot_VL_dft()         jsr(0xF637)   // 
#define Xform_Run_a()        jsr(0xF65B)   // 
#define Xform_Run()          jsr(0xF65D)   // 
#define Xform_Rise_a()       jsr(0xF661)   // 
#define Xform_Rise()         jsr(0xF663)   // 
#define Move_Mem_a_1()       jsr(0xF67F)   // 
#define Move_Mem_a()         jsr(0xF683)   // 

/* Init_Music_chk: These routines are responsible for filling the music work 
   buffer while a sound is being made. It should be called once during each 
   refresh cycle. If you want to start a new sound, then you must set $C856 
   to 0x01, and point the U-register to the sound block. If no sound is in 
   progress ($C856 = 0), then it returns immediately (unless you called 
   Init_Music or Init_Music_dft, which do not make this check). When a sound 
   is in progress, $C856 will be set to 0x80.

   These routines process a single note at a time, and calculate the amplitude 
   and course/fine tuning values for the 3 sound channels. The values 
   calculated are stored in the music work buffer, at $C83F-$C84C.

  Music data format:

  header word -> $C84F 32 nibble ADSR table
  header word -> $C851 8-byte "twang" table
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
#define Init_Music_chk(m)    jsru(m, 0xF687)   // 
#define Init_Music()         jsr(0xF68D)   // 
#define Init_Music_x()       jsr(0xF692)   // 
#define Select_Game()        jsr(0xF7A9)   // 
#define Clear_Score()        jsr(0xF84F)   // 
#define Add_Score_a()        jsr(0xF85E)   // 
#define Add_Score_d()        jsr(0xF87C)   // 
#define Strip_Zeros()        jsr(0xF8B7)   // 
#define Compare_Score()      jsr(0xF8C7)   // 
#define New_High_Score()     jsr(0xF8D8)   // 
#define Obj_Will_Hit_u()     jsr(0xF8E5)   // 
#define Obj_Will_Hit()       jsr(0xF8F3)   // 
#define Obj_Hit()            jsr(0xF8FF)   // 
#define Explosion_Snd()      jsr(0xF92E)   // 
#define Draw_Grid_VL()       jsr(0xFF9F)   // 
                                ;
#define music1   0xFD0D                 // 
#define music2   0xFD1D                 // 
#define music3   0xFD81                 // 
#define music4   0xFDD3                 // 
#define music5   0xFE38                 // 
#define music6   0xFE76                 // 
#define music7   0xFEC6                 // 
#define music8   0xFEF8                 // 
#define music9   0xFF26                 // 
#define musica   0xFF44                 // 
#define musicb   0xFF62                 // 
#define musicc   0xFF7A                 // 
#define musicd   0xFF8F                 // 

