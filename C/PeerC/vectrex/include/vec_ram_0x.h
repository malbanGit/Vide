// ***************************************************************************
// VECTREX EXECUTIVE RAM ADDRESSES
// as described in the Vectrex Programmer's Manual Volume 1
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

// ***************************************************************************
// 0xC800 - 0xCBFF (1KB)	static RAM (read or write)
// ---------------------------------------------------------------------------
// 0xC800 - 0xC87F (128B)	reserved for RUM
// 0xC880 - 0xCBE0 (874B)	reserved for game logic including stack
// 0xCBEA - 0xCBFF (22B)	reserved for RUM
// ***************************************************************************

extern int					Vec_Snd_Shadow 		__attribute__((section(".dpc8")));	// 0xC800, Shadow of sound chip registers (15 bytes)
extern int					Vec_Snd_shadow[15]	__attribute__((section(".dpc8")));	// 0xC800, Shadow of sound chip registers (15 bytes)
extern unsigned int			Vec_Btn_State 		__attribute__((section(".dpc8")));	// 0xC80F, Current state of all joystick buttons
extern unsigned int			Vec_Prev_Btns 		__attribute__((section(".dpc8")));	// 0xC810, Previous state of all joystick buttons
extern unsigned int			Vec_Buttons 		__attribute__((section(".dpc8")));	// 0xC811, Current toggle state of all buttons
extern unsigned int			Vec_Button_1_1 		__attribute__((section(".dpc8")));	// 0xC812, Current toggle state of stick 1 button 1
extern unsigned int			Vec_Button_1_2		__attribute__((section(".dpc8")));	// 0xC813, Current toggle state of stick 1 button 2
extern unsigned int			Vec_Button_1_3		__attribute__((section(".dpc8")));	// 0xC814, Current toggle state of stick 1 button 3
extern unsigned int			Vec_Button_1_4		__attribute__((section(".dpc8")));	// 0xC815, Current toggle state of stick 1 button 4
extern unsigned int			Vec_Button_2_1		__attribute__((section(".dpc8")));	// 0xC816, Current toggle state of stick 2 button 1
extern unsigned int			Vec_Button_2_2		__attribute__((section(".dpc8")));	// 0xC817, Current toggle state of stick 2 button 2
extern unsigned int			Vec_Button_2_3		__attribute__((section(".dpc8")));	// 0xC818, Current toggle state of stick 2 button 3
extern unsigned int			Vec_Button_2_4		__attribute__((section(".dpc8")));	// 0xC819, Current toggle state of stick 2 button 4
extern int					Vec_Joy_Resltn		__attribute__((section(".dpc8")));	// 0xC81A, Joystick A/D resolution (0x80=min 0x00=max)
extern int 					Vec_Joy_1_X			__attribute__((section(".dpc8")));	// 0xC81B, Joystick 1 left/right
extern int					Vec_Joy_1_Y			__attribute__((section(".dpc8")));	// 0xC81C, Joystick 1 up/down
extern int					Vec_Joy_2_X			__attribute__((section(".dpc8")));	// 0xC81D, Joystick 2 left/right
extern int					Vec_Joy_2_Y			__attribute__((section(".dpc8")));	// 0xC81E, Joystick 2 up/down
extern int					Vec_Joy_Mux 		__attribute__((section(".dpc8")));	// 0xC81F, Joystick enable/mux flags (4 bytes)
extern int					Vec_Joy_mux[4] 		__attribute__((section(".dpc8")));	// 0xC81F, Joystick enable/mux flags (4 bytes)
extern int					Vec_Joy_Mux_1_X		__attribute__((section(".dpc8")));	// 0xC81F, Joystick 1 X enable/mux flag (=1)
extern int					Vec_Joy_Mux_1_Y		__attribute__((section(".dpc8")));	// 0xC820, Joystick 1 Y enable/mux flag (=3)
extern int					Vec_Joy_Mux_2_X		__attribute__((section(".dpc8")));	// 0xC821, Joystick 2 X enable/mux flag (=5)
extern int					Vec_Joy_Mux_2_Y		__attribute__((section(".dpc8")));	// 0xC822, Joystick 2 Y enable/mux flag (=7)
extern unsigned int			Vec_Misc_Count		__attribute__((section(".dpc8")));	// 0xC823, Misc counter/flag byte, zero when not in use
extern int					Vec_0Ref_Enable		__attribute__((section(".dpc8")));	// 0xC824, Check0Ref enable flag
extern unsigned long int	Vec_Loop_Count		__attribute__((section(".dpc8")));	// 0xC825, Loop counter word (incremented in Wait_Recal)
extern unsigned int			Vec_Loop_Count_hi	__attribute__((section(".dpc8")));	// 0xC825, Loop counter hi byte (incremented in Wait_Recal)
extern unsigned int			Vec_Loop_Count_lo	__attribute__((section(".dpc8")));	// 0xC826, Loop counter lo byte (incremented in Wait_Recal)
extern int					Vec_Brightness		__attribute__((section(".dpc8")));	// 0xC827, Default brightness
extern unsigned int			Vec_Dot_Dwell		__attribute__((section(".dpc8")));	// 0xC828, Dot dwell time?
extern unsigned int			Vec_Pattern			__attribute__((section(".dpc8")));	// 0xC829, Dot pattern (bits)
extern unsigned long int	Vec_Text_HW 		__attribute__((section(".dpc8")));	// 0xC82A, Default text height and width
extern int 					Vec_Text_Height 	__attribute__((section(".dpc8")));	// 0xC82A, Default text height
extern int					Vec_Text_Width 		__attribute__((section(".dpc8")));	// 0xC82B, Default text width
extern int*					Vec_Str_Ptr			__attribute__((section(".dpc8")));	// 0xC82C, Temporary string pointer for Print_Str
extern int					Vec_counters[6]		__attribute__((section(".dpc8")));	// 0xC82E, Six bytes of counters
extern int					Vec_Counters		__attribute__((section(".dpc8")));	// 0xC82E, Six bytes of counters
extern int					Vec_Counter_1		__attribute__((section(".dpc8")));	// 0xC82E, First  counter byte
extern int					Vec_Counter_2		__attribute__((section(".dpc8")));	// 0xC82F, Second counter byte
extern int					Vec_Counter_3		__attribute__((section(".dpc8")));	// 0xC830, Third  counter byte
extern int					Vec_Counter_4		__attribute__((section(".dpc8")));	// 0xC831, Fourth counter byte
extern int					Vec_Counter_5		__attribute__((section(".dpc8")));	// 0xC832, Fifth  counter byte
extern int					Vec_Counter_6		__attribute__((section(".dpc8")));	// 0xC833, Sixth  counter byte
extern unsigned long int	Vec_RiseRun_Tmp		__attribute__((section(".dpc8")));	// 0xC834, Temp storage word for rise/run
extern int					Vec_Angle			__attribute__((section(".dpc8")));	// 0xC836, Angle for rise/run and rotation calculations
extern unsigned long int	Vec_Run_Index		__attribute__((section(".dpc8")));	// 0xC837, Index pair for run
extern unsigned long int	Vec_Rise_Index		__attribute__((section(".dpc8")));	// 0xC839, Index pair for rise
extern unsigned long int	Vec_XXX_00			__attribute__((section(".dpc8")));	// 0xC839, Pointer to copyright string during startup
extern int					Vec_RiseRun_Len		__attribute__((section(".dpc8")));	// 0xC83B, length for rise/run
extern int					Vec_XXX_01			__attribute__((section(".dpc8")));	// 0xC83B, High score cold-start flag (=0 if valid)
extern int					Vec_XXX_02			__attribute__((section(".dpc8")));	// 0xC83C, temp byte
extern unsigned long int	Vec_Rfrsh			__attribute__((section(".dpc8")));	// 0xC83D, Refresh time (divided by 1.5MHz)
extern unsigned int			Vec_Rfrsh_lo		__attribute__((section(".dpc8")));	// 0xC83D, Refresh time low byte
extern unsigned int			Vec_Rfrsh_hi		__attribute__((section(".dpc8")));	// 0xC83E, Refresh time high byte
extern int					Vec_Music_Work		__attribute__((section(".dpc8")));	// 0xC83F, Music work buffer (14 bytes, backwards?)
extern int					Vec_Music_Wk_A		__attribute__((section(".dpc8")));	// 0xC842, register 10
extern int					Vec_XXX_03			__attribute__((section(".dpc8")));	// 0xC843, register 9
extern int					Vec_XXX_04			__attribute__((section(".dpc8")));	// 0xC844, register 8
extern int					Vec_Music_Wk_7		__attribute__((section(".dpc8")));	// 0xC845, register 7
extern int					Vec_Music_Wk_6		__attribute__((section(".dpc8")));	// 0xC846, register 6
extern int					Vec_Music_Wk_5		__attribute__((section(".dpc8")));	// 0xC847, register 5
extern int					Vec_XXX_05			__attribute__((section(".dpc8")));	// 0xC848, register 4
extern int					Vec_XXX_06			__attribute__((section(".dpc8")));	// 0xC849, register 3
extern int					Vec_XXX_07			__attribute__((section(".dpc8")));	// 0xC84A, register 2
extern int					Vec_Music_Wk_1		__attribute__((section(".dpc8")));	// 0xC84B, register 1
extern int					Vec_XXX_08			__attribute__((section(".dpc8")));	// 0xC84C, register 0
extern int*					Vec_Freq_Table		__attribute__((section(".dpc8")));	// 0xC84D, Pointer to note-to-frequency table (normally 0xFC8D)
extern long unsigned int	Vec_ADSR_Table		__attribute__((section(".dpc8")));	// 0xC84F, Storage for first music header word (ADSR table)
extern int					Vec_Max_Players		__attribute__((section(".dpc8")));	// 0xC84F, Maximum number of players for Select_Game
extern int					Vec_Max_Games		__attribute__((section(".dpc8")));	// 0xC850, Maximum number of games for Select_Game
extern int*					Vec_Twang_Table		__attribute__((section(".dpc8")));	// 0xC851, Storage for second music header word ('twang' table)
extern int*					Vec_Music_Ptr		__attribute__((section(".dpc8")));	// 0xC853, Music data pointer
extern int					Vec_Expl_ChanA		__attribute__((section(".dpc8")));	// 0xC853, Used by Explosion_Snd - bit for first channel used?
extern int					Vec_Expl_Chans		__attribute__((section(".dpc8")));	// 0xC854, Used by Explosion_Snd - bits for all channels used?
extern int					Vec_Music_Chan		__attribute__((section(".dpc8")));	// 0xC855, Current sound channel number for Init_Music
extern int					Vec_Music_Flag		__attribute__((section(".dpc8")));	// 0xC856, Music active flag (0x00=off 0x01=start 0x80=on)
extern int					Vec_Duration		__attribute__((section(".dpc8")));	// 0xC857, Duration counter for Init_Music
extern int					Vec_Expl_1			__attribute__((section(".dpc8")));	// 0xC858, Four bytes copied from Explosion_Snd's U-reg parameters
extern long unsigned int	Vec_Music_Twang		__attribute__((section(".dpc8")));	// 0xC858, 3 word 'twang' table used by Init_Music
extern int					Vec_Expl_2			__attribute__((section(".dpc8")));	// 0xC859, 
extern int					Vec_Expl_3			__attribute__((section(".dpc8")));	// 0xC85A, 
extern int					Vec_Expl_4			__attribute__((section(".dpc8")));	// 0xC85B, 
extern int					Vec_Expl_Chan		__attribute__((section(".dpc8")));	// 0xC85C by Explosion_Snd - channel number in use?
extern int					Vec_Expl_ChanB		__attribute__((section(".dpc8")));	// 0xC85D by Explosion_Snd - bit for second channel used?
extern int					Vec_XXX_09			__attribute__((section(".dpc8")));	// 0xC85E, Scratch 'score' storage for Display_Option (7 bytes)
extern int					Vec_ADSR_Timers		__attribute__((section(".dpc8")));	// 0xC85E, ADSR timers for each sound channel (3 bytes)
extern int					Vec_ADSR_timers[3]	__attribute__((section(".dpc8")));	// 0xC85E, ADSR timers for each sound channel (3 bytes)
extern unsigned long int	Vec_Music_Freq		__attribute__((section(".dpc8")));	// 0xC861, Storage for base frequency of each channel (3 words)
extern unsigned long int	Vec_Music_freq[3]	__attribute__((section(".dpc8")));	// 0xC861, Storage for base frequency of each channel (3 words)
extern unsigned int			Vec_Expl_Flag		__attribute__((section(".dpc8")));	// 0xC867, Explosion_Snd initialization flag?
extern int					Vec_XXX_10			__attribute__((section(".dpc8")));	// 0xC868, Unused?
extern int					Vec_XXX_11			__attribute__((section(".dpc8")));	// 0xC869, Unused?
extern int					Vec_XXX_12			__attribute__((section(".dpc8")));	// 0xC86A, Unused?
extern int					Vec_XXX_13			__attribute__((section(".dpc8")));	// 0xC86B, Unused?
extern int					Vec_XXX_14			__attribute__((section(".dpc8")));	// 0xC86C, Unused?
extern int					Vec_XXX_15			__attribute__((section(".dpc8")));	// 0xC86D, Unused?
extern int					Vec_XXX_16			__attribute__((section(".dpc8")));	// 0xC86E, Unused?
extern int					Vec_XXX_17			__attribute__((section(".dpc8")));	// 0xC86F, Unused?
extern int					Vec_XXX_18			__attribute__((section(".dpc8")));	// 0xC870, Unused?
extern int					Vec_XXX_19			__attribute__((section(".dpc8")));	// 0xC871, Unused?
extern int					Vec_XXX_20			__attribute__((section(".dpc8")));	// 0xC872, Unused?
extern int					Vec_XXX_21			__attribute__((section(".dpc8")));	// 0xC873, Unused?
extern int					Vec_XXX_22			__attribute__((section(".dpc8")));	// 0xC874, Unused?
extern int					Vec_XXX_23			__attribute__((section(".dpc8")));	// 0xC875, Unused?
extern int					Vec_XXX_24			__attribute__((section(".dpc8")));	// 0xC876, Unused?
extern int					Vec_Expl_Timer		__attribute__((section(".dpc8")));	// 0xC877, Used by Explosion_Snd
extern int					Vec_XXX_25			__attribute__((section(".dpc8")));	// 0xC878, Unused?
extern unsigned int			Vec_Num_Players		__attribute__((section(".dpc8")));	// 0xC879, Number of players selected in Select_Game
extern unsigned int			Vec_Num_Game		__attribute__((section(".dpc8")));	// 0xC87A, Game number selected in Select_Game
extern unsigned int*		Vec_Seed_Ptr		__attribute__((section(".dpc8")));	// 0xC87B, Pointer to 3-byte random number seed (=0xC87D)
extern unsigned int			Vec_Random_Seed		__attribute__((section(".dpc8")));	// 0xC87D, working storage for random number generator (3 bytes)
extern unsigned int			Vec_Random_Seed0	__attribute__((section(".dpc8")));	// 0xC87D, Default 3-byte random number seed
extern unsigned int			Vec_Random_Seed1	__attribute__((section(".dpc8")));	// 0xC87E, Default 3-byte random number seed
extern unsigned int			Vec_Random_Seed2	__attribute__((section(".dpc8")));	// 0xC87F, Default 3-byte random number seed

// ---------------------------------------------------------------------------

extern int					Vec_Default_Stk		__attribute__((section(".dpcb")));	// 0xCBEA, Default top-of-stack
extern unsigned int			Vec_High_Score 		__attribute__((section(".dpcb")));	// 0xCBEB, High score storage (7 bytes)
extern unsigned int			Vec_High_score[7]	__attribute__((section(".dpcb")));	// 0xCBEB, High score storage (7 bytes)
extern int					Vec_SWI3_Vector		__attribute__((section(".dpcb")));	// 0xCBF2, SWI2/SWI3 interrupt vector (3 bytes)
extern int					Vec_SWI3_vector[3]	__attribute__((section(".dpcb")));	// 0xCBF2, SWI2/SWI3 interrupt vector (3 bytes)
extern int					Vec_SWI2_Vector		__attribute__((section(".dpcb")));	// 0xCBF2, SWI2/SWI3 interrupt vector (3 bytes)
extern int					Vec_SWI2_vector[3]	__attribute__((section(".dpcb")));	// 0xCBF2, SWI2/SWI3 interrupt vector (3 bytes)
extern int					Vec_FIRQ_Vector		__attribute__((section(".dpcb")));	// 0xCBF5, FIRQ interrupt vector (3 bytes)
extern int					Vec_FIRQ_vector[3]	__attribute__((section(".dpcb")));	// 0xCBF5, FIRQ interrupt vector (3 bytes)
extern int					Vec_IRQ_Vector		__attribute__((section(".dpcb")));	// 0xCBF8, IRQ interrupt vector (3 bytes)
extern int					Vec_IRQ_vector[3]	__attribute__((section(".dpcb")));	// 0xCBF8, IRQ interrupt vector (3 bytes)
extern int					Vec_SWI_Vector		__attribute__((section(".dpcb")));	// 0xCBFB, SWI/NMI interrupt vector (3 bytes)
extern int					Vec_SWI_vector[3]	__attribute__((section(".dpcb")));	// 0xCBFB, SWI/NMI interrupt vector (3 bytes)
extern int					Vec_NWI_Vector		__attribute__((section(".dpcb")));	// 0xCBFB, SWI/NMI interrupt vector (3 bytes)
extern int					Vec_NWI_vector[3]	__attribute__((section(".dpcb")));	// 0xCBFB, SWI/NMI interrupt vector (3 bytes)
extern long unsigned int	Vec_Cold_Flag		__attribute__((section(".dpcb")));	// 0xCBFE, Cold start flag (warm start if = 0x7321)

// ***************************************************************************
// 0xDxx0 - 0xDxxF (16B)	programmable interface adapter VIA (read or write) 
// ***************************************************************************

extern volatile unsigned long int VIA_port_ba		__attribute__((section(".dpd0")));	// 0xD000, VIA port data I/O registers

extern volatile int	VIA_port_b	__attribute__((section(".dpd0")));	// 0xD000, VIA port B data I/O register
extern volatile int	VIA_port_a	__attribute__((section(".dpd0")));	// 0xD001, VIA port A data I/O register (handshaking)
//       0 sample/hold (0=enable  mux 1=disable mux)
//       1 mux sel 0
//       2 mux sel 1
//       3 sound BC1
//       4 sound BDIR
//       5 comparator input
//       6 external device (slot pin 35) initialized to input
//       7 /RAMP
extern volatile unsigned long int	VIA_DDR_ba		__attribute__((section(".dpd0")));	// 0xD002, VIA port data direction registers
extern volatile unsigned int		VIA_DDR_b		__attribute__((section(".dpd0")));	// 0xD002, VIA port B data direction register (0=input 1=output)
extern volatile unsigned int		VIA_DDR_a		__attribute__((section(".dpd0")));	// 0xD003, VIA port A data direction register (0=input 1=output)
extern volatile unsigned long int	VIA_t1_cnt		__attribute__((section(".dpd0")));	// 0xD004, VIA timer 1 count register
extern volatile unsigned int		VIA_t1_cnt_lo	__attribute__((section(".dpd0")));	// 0xD004, VIA timer 1 count register lo (scale factor)
extern volatile unsigned int		VIA_t1_cnt_hi	__attribute__((section(".dpd0")));	// 0xD005, VIA timer 1 count register hi
extern volatile unsigned long int	VIA_t1_lch		__attribute__((section(".dpd0")));	// 0xD006, VIA timer 1 latch register
extern volatile unsigned int		VIA_t1_lch_lo	__attribute__((section(".dpd0")));	// 0xD006, VIA timer 1 latch register lo
extern volatile unsigned int		VIA_t1_lch_hi	__attribute__((section(".dpd0")));	// 0xD007, VIA timer 1 latch register hi
extern volatile unsigned long int	VIA_t2			__attribute__((section(".dpd0")));	// 0xD008, VIA timer 2 count register lo/hi (little endian access) (refresh)
extern volatile unsigned int		VIA_t2_lo		__attribute__((section(".dpd0")));	// 0xD008, VIA timer 2 count/latch register lo (refresh)
extern volatile unsigned int		VIA_t2_hi		__attribute__((section(".dpd0")));	// 0xD009, VIA timer 2 count/latch register hi
extern volatile unsigned int		VIA_shift_reg	__attribute__((section(".dpd0")));	// 0xD00A, VIA shift register
extern volatile unsigned long int	VIA_aux_cntl_w	__attribute__((section(".dpd0")));	// 0xD00B, VIA auxiliary control register
extern volatile unsigned int		VIA_aux_cntl	__attribute__((section(".dpd0")));	// 0xD00B, VIA auxiliary control register
//       0 PA latch enable
//       1 PB latch enable
//       2 \                     110=output to CB2 under control of phase 2 clock
//       3  > shift register control     (110 is the only mode used by the Vectrex ROM)
//       4 /
//       5 0=t2 one shot                 1=t2 free running
//       6 0=t1 one shot                 1=t1 free running
//       7 0=t1 disable PB7 output       1=t1 enable PB7 output
extern volatile unsigned int VIA_cntl __attribute__((section(".dpd0")));	// 0xD00C, VIA control register
//       0 CA1 control     CA1 -> SW7    0=IRQ on low 1=IRQ on high
//       1 \ x
//       2  > CA2 control  CA2 -> /ZERO  110=low 111=high
//       3 /
//       4 CB1 control     CB1 -> NC     0=IRQ on low 1=IRQ on high
//       5 \ x
//       6  > CB2 control  CB2 -> /BLANK 110=low 111=high
//       7 /
extern volatile unsigned int VIA_int_flags __attribute__((section(".dpd0")));	// 0xD00D, VIA interrupt flags register
//               bit                             cleared by
//       0 CA2 interrupt flag            reading or writing port A I/O
//       1 CA1 interrupt flag            reading or writing port A I/O
//       2 shift register interrupt flag reading or writing shift register
//       3 CB2 interrupt flag            reading or writing port B I/O
//       4 CB1 interrupt flag            reading or writing port A I/O
//       5 timer 2 interrupt flag        read t2 low or write t2 high
//       6 timer 1 interrupt flag        read t1 count low or write t1 high
//       7 IRQ status flag               write logic 0 to IER or IFR bit
extern volatile unsigned int VIA_int_enable __attribute__((section(".dpd0")));	// 0xD00E, VIA interrupt enable register
//       0 CA2 interrupt enable
//       1 CA1 interrupt enable
//       2 shift register interrupt enable
//       3 CB2 interrupt enable
//       4 CB1 interrupt enable
//       5 timer 2 interrupt enable
//       6 timer 1 interrupt enable
//       7 IER set/clear control
extern volatile unsigned int VIA_port_a_nohs __attribute__((section(".dpd0")));	// 0xD00F, VIA port A data I/O register (no handshaking)

// ***************************************************************************
// end of file
// ***************************************************************************
