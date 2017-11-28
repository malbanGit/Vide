// ***************************************************************************
// VECTREX EXECUTIVE RAM ADRESSES
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

#define RAM(addr, type) *((volatile type* const) addr)

// ***************************************************************************
// 0xC800 - 0xCBFF (1KB)	static RAM (read or write)
// ---------------------------------------------------------------------------
// 0xC800 - 0xC87F (128B)	reserved for RUM
// 0xC880 - 0xCBE0 (874B)	reserved for game logic including stack
// 0xCBEA - 0xCBFF (22B)	reserved for RUM
// ***************************************************************************

#define Vec_Snd_Shadow		RAM(0xC800, int) // Shadow of sound chip registers (15 bytes)
#define Vec_Btn_State		RAM(0xC80F, unsigned int) // Current state of all joystick buttons
#define Vec_Prev_Btns		RAM(0xC810, unsigned int) // Previous state of all joystick buttons
#define Vec_Buttons			RAM(0xC811, unsigned int) // Current toggle state of all buttons
#define Vec_Button_1_1		RAM(0xC812, unsigned int) // Current toggle state of stick 1 button 1
#define Vec_Button_1_2		RAM(0xC813, unsigned int) // Current toggle state of stick 1 button 2
#define Vec_Button_1_3		RAM(0xC814, unsigned int) // Current toggle state of stick 1 button 3
#define Vec_Button_1_4		RAM(0xC815, unsigned int) // Current toggle state of stick 1 button 4
#define Vec_Button_2_1		RAM(0xC816, unsigned int) // Current toggle state of stick 2 button 1
#define Vec_Button_2_2		RAM(0xC817, unsigned int) // Current toggle state of stick 2 button 2
#define Vec_Button_2_3		RAM(0xC818, unsigned int) // Current toggle state of stick 2 button 3
#define Vec_Button_2_4		RAM(0xC819, unsigned int) // Current toggle state of stick 2 button 4
#define Vec_Joy_Resltn		RAM(0xC81A, int) // Joystick A/D resolution (0x80=min 0x00=max)
#define Vec_Joy_1_X			RAM(0xC81B, int) // Joystick 1 left/right
#define Vec_Joy_1_Y			RAM(0xC81C, int) // Joystick 1 up/down
#define Vec_Joy_2_X			RAM(0xC81D, int) // Joystick 2 left/right
#define Vec_Joy_2_Y			RAM(0xC81E, int) // Joystick 2 up/down
#define Vec_Joy_Mux			RAM(0xC81F, int) // Joystick enable/mux flags (4 bytes)
#define Vec_Joy_Mux_1_X		RAM(0xC81F, int) // Joystick 1 X enable/mux flag (=1)
#define Vec_Joy_Mux_1_Y		RAM(0xC820, int) // Joystick 1 Y enable/mux flag (=3)
#define Vec_Joy_Mux_2_X		RAM(0xC821, int) // Joystick 2 X enable/mux flag (=5)
#define Vec_Joy_Mux_2_Y		RAM(0xC822, int) // Joystick 2 Y enable/mux flag (=7)
#define Vec_Misc_Count		RAM(0xC823, unsigned int) // Misc counter/flag byte, zero when not in use
#define Vec_0Ref_Enable		RAM(0xC824, int) // Check0Ref enable flag
#define Vec_Loop_Count		RAM(0xC825, int) // Loop counter word (incremented in Wait_Recal)
#define Vec_Brightness		RAM(0xC827, int) // Default brightness
#define Vec_Dot_Dwell		RAM(0xC828, unsigned int) // Dot dwell time?
#define Vec_Pattern			RAM(0xC829, unsigned int) // Dot pattern (bits)
#define Vec_Text_HW			RAM(0xC82A, unsigned long int) // Default text height and width
#define Vec_Text_Height		RAM(0xC82A, int) // Default text height
#define Vec_Text_Width		RAM(0xC82B, int) // Default text width
#define Vec_Str_Ptr			RAM(0xC82C, int) // Temporary string pointer for Print_Str
#define Vec_Counters		RAM(0xC82E, int) // Six bytes of counters
#define Vec_Counter_1		RAM(0xC82E, int) // First  counter byte
#define Vec_Counter_2		RAM(0xC82F, int) // Second counter byte
#define Vec_Counter_3		RAM(0xC830, int) // Third  counter byte
#define Vec_Counter_4		RAM(0xC831, int) // Fourth counter byte
#define Vec_Counter_5		RAM(0xC832, int) // Fifth  counter byte
#define Vec_Counter_6		RAM(0xC833, int) // Sixth  counter byte
#define Vec_RiseRun_Tmp		RAM(0xC834, int) // Temp storage word for rise/run
#define Vec_Angle			RAM(0xC836, int)	// Angle for rise/run and rotation calculations
#define Vec_Run_Index		RAM(0xC837, int)	// Index pair for run
#define Vec_XXX_00			RAM(0xC839, int)	// Pointer to copyright string during startup
#define Vec_Rise_Index		RAM(0xC839, int)	// Index pair for rise
#define Vec_XXX_01			RAM(0xC83B, int)	// High score cold-start flag (=0 if valid)
#define Vec_RiseRun_Len		RAM(0xC83B, int)	// length for rise/run
#define Vec_XXX_02			RAM(0xC83C, int)	// temp byte
#define Vec_Rfrsh			RAM(0xC83D, int) // Refresh time (divided by 1.5MHz)
#define Vec_Rfrsh_lo		RAM(0xC83D, int) // Refresh time low byte
#define Vec_Rfrsh_hi		RAM(0xC83E, int) // Refresh time high byte
#define Vec_Music_Work		RAM(0xC83F, int) // Music work buffer (14 bytes, backwards?)
#define Vec_Music_Wk_A		RAM(0xC842, int) //         register 10
#define Vec_XXX_03			RAM(0xC843, int)	// register 9
#define Vec_XXX_04			RAM(0xC844, int)	// register 8
#define Vec_Music_Wk_7		RAM(0xC845, int) //         register 7
#define Vec_Music_Wk_6		RAM(0xC846, int) //         register 6
#define Vec_Music_Wk_5		RAM(0xC847, int) //         register 5
#define Vec_XXX_05			RAM(0xC848, int)	// register 4
#define Vec_XXX_06			RAM(0xC849, int)	// register 3
#define Vec_XXX_07			RAM(0xC84A, int)	// register 2
#define Vec_Music_Wk_1		RAM(0xC84B, int) //         register 1
#define Vec_XXX_08			RAM(0xC84C, int)	// register 0
#define Vec_Freq_Table		RAM(0xC84D, int) // Pointer to note-to-frequency table (normally 0xFC8D)
#define Vec_Max_Players		RAM(0xC84F, int) // Maximum number of players for Select_Game
#define Vec_Max_Games		RAM(0xC850, int) // Maximum number of games for Select_Game
#define Vec_ADSR_Table		RAM(0xC84F, int) // Storage for first music header word (ADSR table)
#define Vec_Twang_Table		RAM(0xC851, int) // Storage for second music header word ('twang' table)
#define Vec_Music_Ptr		RAM(0xC853, int) // Music data pointer
#define Vec_Expl_ChanA		RAM(0xC853, int) // Used by Explosion_Snd - bit for first channel used?
#define Vec_Expl_Chans		RAM(0xC854, int) // Used by Explosion_Snd - bits for all channels used?
#define Vec_Music_Chan		RAM(0xC855, int) // Current sound channel number for Init_Music
#define Vec_Music_Flag		RAM(0xC856, int) // Music active flag (0x00=off 0x01=start 0x80=on)
#define Vec_Duration		RAM(0xC857, int) // Duration counter for Init_Music
#define Vec_Music_Twang		RAM(0xC858, int) // 3 word 'twang' table used by Init_Music
#define Vec_Expl_1			RAM(0xC858, int) // Four bytes copied from Explosion_Snd's U-reg parameters
#define Vec_Expl_2			RAM(0xC859, int) // 
#define Vec_Expl_3			RAM(0xC85A, int) // 
#define Vec_Expl_4			RAM(0xC85B, int) // 
#define Vec_Expl_Chan		RAM(0xC85C, int) // Used by Explosion_Snd - channel number in use?
#define Vec_Expl_ChanB		RAM(0xC85D, int) // Used by Explosion_Snd - bit for second channel used?
#define Vec_ADSR_Timers		RAM(0xC85E, int) // ADSR timers for each sound channel (3 bytes)
#define Vec_Music_Freq		RAM(0xC861, int) // Storage for base frequency of each channel (3 words)
#define Vec_XXX_09			RAM(0xC85E, int)	// Scratch 'score' storage for Display_Option (7 bytes)
#define Vec_Expl_Flag		RAM(0xC867, unsigned int) // Explosion_Snd initialization flag?
#define Vec_XXX_10			RAM(0xC868, int)	// Unused?
#define Vec_XXX_11			RAM(0xC869, int)	// Unused?
#define Vec_XXX_12			RAM(0xC86A, int)	// Unused?
#define Vec_XXX_13			RAM(0xC86B, int)	// Unused?
#define Vec_XXX_14			RAM(0xC86C, int)	// Unused?
#define Vec_XXX_15			RAM(0xC86D, int)	// Unused?
#define Vec_XXX_16			RAM(0xC86E, int)	// Unused?
#define Vec_XXX_17			RAM(0xC86F, int)	// Unused?
#define Vec_XXX_18			RAM(0xC870, int)	// Unused?
#define Vec_XXX_19			RAM(0xC871, int)	// Unused?
#define Vec_XXX_20			RAM(0xC872, int)	// Unused?
#define Vec_XXX_21			RAM(0xC873, int)	// Unused?
#define Vec_XXX_22			RAM(0xC874, int)	// Unused?
#define Vec_XXX_23			RAM(0xC875, int)	// Unused?
#define Vec_XXX_24			RAM(0xC876, int)	// Unused?
#define Vec_Expl_Timer		RAM(0xC877, int) // Used by Explosion_Snd
#define Vec_XXX_25			RAM(0xC878, int)	// Unused?
#define Vec_Num_Players		RAM(0xC879, unsigned int) // Number of players selected in Select_Game
#define Vec_Num_Game		RAM(0xC87A, unsigned int) // Game number selected in Select_Game
#define Vec_Seed_Ptr		RAM(0xC87B, unsigned int*) // Pointer to 3-byte random number seed (=0xC87D)
#define Vec_Random_Seed		RAM(0xC87D, long unsigned int) // working storage for random number generator (3 bytes)
#define Vec_Random_Seed0	RAM(0xC87D, unsigned int) // Default 3-byte random number seed
#define Vec_Random_Seed1	RAM(0xC87E, unsigned int) // Default 3-byte random number seed
#define Vec_Random_Seed2	RAM(0xC87F, unsigned int) // Default 3-byte random number seed

// ---------------------------------------------------------------------------

#define Vec_Default_Stk		RAM(0xCBEA, int) // Default top-of-stack
#define Vec_High_Score		RAM(0xCBEB, int) // High score storage (7 bytes)
#define Vec_SWI3_Vector		RAM(0xCBF2, int) // SWI2/SWI3 interrupt vector (3 bytes)
#define Vec_SWI2_Vector		RAM(0xCBF2, int) // SWI2/SWI3 interrupt vector (3 bytes)
#define Vec_FIRQ_Vector		RAM(0xCBF5, int) // FIRQ interrupt vector (3 bytes)
#define Vec_IRQ_Vector		RAM(0xCBF8, int) // IRQ interrupt vector (3 bytes)
#define Vec_SWI_Vector		RAM(0xCBFB, int) // SWI/NMI interrupt vector (3 bytes)
#define Vec_NMI_Vector		RAM(0xCBFB, int) // SWI/NMI interrupt vector (3 bytes)
#define Vec_Cold_Flag		RAM(0xCBFE, int) // Cold start flag (warm start if = 0x7321)

// ***************************************************************************
// 0xDxx0 - 0xDxxF (16B)	programmable interface adapter VIA (read or write) 
// ***************************************************************************

#define VIA_port_b		RAM(0xD000, int) // VIA port B data I/O register
//       0 sample/hold (0=enable  mux 1=disable mux)
//       1 mux sel 0
//       2 mux sel 1
//       3 sound BC1
//       4 sound BDIR
//       5 comparator input
//       6 external device (slot pin 35) initialized to input
//       7 /RAMP
#define VIA_port_a		RAM(0xD001, int) // VIA port A data I/O register (handshaking)
#define VIA_DDR_b		RAM(0xD002, int) // VIA port B data direction register (0=input 1=output)
#define VIA_DDR_a		RAM(0xD003, int) // VIA port A data direction register (0=input 1=output)
#define VIA_t1_cnt_lo	RAM(0xD004, unsigned int) // VIA timer 1 count register lo (scale factor)
#define VIA_t1_cnt_hi	RAM(0xD005, int) // VIA timer 1 count register hi
#define VIA_t1_lch_lo	RAM(0xD006, int) // VIA timer 1 latch register lo
#define VIA_t1_lch_hi	RAM(0xD007, int) // VIA timer 1 latch register hi
#define VIA_t2_lo		RAM(0xD008, int) // VIA timer 2 count/latch register lo (refresh)
#define VIA_t2_hi		RAM(0xD009, int) // VIA timer 2 count/latch register hi
#define VIA_shift_reg	RAM(0xD00A, int) // VIA shift register
#define VIA_aux_cntl	RAM(0xD00B, int) // VIA auxiliary control register
//       0 PA latch enable
//       1 PB latch enable
//       2 \                     110=output to CB2 under control of phase 2 clock
//       3  > shift register control     (110 is the only mode used by the Vectrex ROM)
//       4 /
//       5 0=t2 one shot                 1=t2 free running
//       6 0=t1 one shot                 1=t1 free running
//       7 0=t1 disable PB7 output       1=t1 enable PB7 output
#define VIA_cntl		RAM(0xD00C, int) // VIA control register
//       0 CA1 control     CA1 -> SW7    0=IRQ on low 1=IRQ on high
//       1 \ x
//       2  > CA2 control  CA2 -> /ZERO  110=low 111=high
//       3 /
//       4 CB1 control     CB1 -> NC     0=IRQ on low 1=IRQ on high
//       5 \ x
//       6  > CB2 control  CB2 -> /BLANK 110=low 111=high
//       7 /
#define VIA_int_flags		RAM(0xD00D, int) // VIA interrupt flags register
//               bit                             cleared by
//       0 CA2 interrupt flag            reading or writing port A I/O
//       1 CA1 interrupt flag            reading or writing port A I/O
//       2 shift register interrupt flag reading or writing shift register
//       3 CB2 interrupt flag            reading or writing port B I/O
//       4 CB1 interrupt flag            reading or writing port A I/O
//       5 timer 2 interrupt flag        read t2 low or write t2 high
//       6 timer 1 interrupt flag        read t1 count low or write t1 high
//       7 IRQ status flag               write logic 0 to IER or IFR bit
#define VIA_int_enable		RAM(0xD00E, int) // VIA interrupt enable register
//       0 CA2 interrupt enable
//       1 CA1 interrupt enable
//       2 shift register interrupt enable
//       3 CB2 interrupt enable
//       4 CB1 interrupt enable
//       5 timer 2 interrupt enable
//       6 timer 1 interrupt enable
//       7 IER set/clear control
#define VIA_port_a_nohs		RAM(0xD00F, int) // VIA port A data I/O register (no handshaking)

// ***************************************************************************
// end of file
// ***************************************************************************
