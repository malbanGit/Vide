// ***************************************************************************
// VECTREX EXECUTIVE RAM ADDRESSES
// as described in the Vectrex Programmer's Manual Volume 1
// ***************************************************************************
// quick reference - do not use this file as header file
// use #include <vectrex.h> instead
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
// ***************************************************************************
// 0xC800 - 0xCBFF (1KB)	static RAM (read or write)
// ---------------------------------------------------------------------------
// 0xC800 - 0xC87F (128B)	reserved for RUM
// 0xC880 - 0xCBE0 (874B)	reserved for game logic including stack
// 0xCBEA - 0xCBFF (22B)	reserved for RUM
// ***************************************************************************

int					Vec_Snd_Shadow 		// 0xC800, Shadow of sound chip registers (15 bytes)
int					Vec_Snd_shadow[15]	// 0xC800, Shadow of sound chip registers (15 bytes)
unsigned int		Vec_Btn_State 		// 0xC80F, Current state of all joystick buttons
unsigned int		Vec_Prev_Btns 		// 0xC810, Previous state of all joystick buttons
unsigned int		Vec_Buttons 		// 0xC811, Current toggle state of all buttons
unsigned int		Vec_Button_1_1 		// 0xC812, Current toggle state of stick 1 button 1
unsigned int		Vec_Button_1_2		// 0xC813, Current toggle state of stick 1 button 2
unsigned int		Vec_Button_1_3		// 0xC814, Current toggle state of stick 1 button 3
unsigned int		Vec_Button_1_4		// 0xC815, Current toggle state of stick 1 button 4
unsigned int		Vec_Button_2_1		// 0xC816, Current toggle state of stick 2 button 1
unsigned int		Vec_Button_2_2		// 0xC817, Current toggle state of stick 2 button 2
unsigned int		Vec_Button_2_3		// 0xC818, Current toggle state of stick 2 button 3
unsigned int		Vec_Button_2_4		// 0xC819, Current toggle state of stick 2 button 4
int					Vec_Joy_Resltn		// 0xC81A, Joystick A/D resolution (0x80=min 0x00=max)
int 				Vec_Joy_1_X			// 0xC81B, Joystick 1 left/right
int					Vec_Joy_1_Y			// 0xC81C, Joystick 1 up/down
int					Vec_Joy_2_X			// 0xC81D, Joystick 2 left/right
int					Vec_Joy_2_Y			// 0xC81E, Joystick 2 up/down
int					Vec_Joy_Mux 		// 0xC81F, Joystick enable/mux flags (4 bytes)
int					Vec_Joy_mux[4] 		// 0xC81F, Joystick enable/mux flags (4 bytes)
int					Vec_Joy_Mux_1_X		// 0xC81F, Joystick 1 X enable/mux flag (=1)
int					Vec_Joy_Mux_1_Y		// 0xC820, Joystick 1 Y enable/mux flag (=3)
int					Vec_Joy_Mux_2_X		// 0xC821, Joystick 2 X enable/mux flag (=5)
int					Vec_Joy_Mux_2_Y		// 0xC822, Joystick 2 Y enable/mux flag (=7)
unsigned int		Vec_Misc_Count		// 0xC823, Misc counter/flag byte, zero when not in use
int					Vec_0Ref_Enable		// 0xC824, Check0Ref enable flag
unsigned long int	Vec_Loop_Count		// 0xC825, Loop counter word (incremented in Wait_Recal)
unsigned int		Vec_Loop_Count_hi	// 0xC825, Loop counter hi byte (incremented in Wait_Recal)
unsigned int		Vec_Loop_Count_lo	// 0xC826, Loop counter lo byte (incremented in Wait_Recal)
int					Vec_Brightness		// 0xC827, Default brightness
unsigned int		Vec_Dot_Dwell		// 0xC828, Dot dwell time?
unsigned int		Vec_Pattern			// 0xC829, Dot pattern (bits)
unsigned long int	Vec_Text_HW 		// 0xC82A, Default text height and width
int 				Vec_Text_Height 	// 0xC82A, Default text height
int					Vec_Text_Width 		// 0xC82B, Default text width
int*				Vec_Str_Ptr			// 0xC82C, Temporary string pointer for Print_Str
int					Vec_counters[6]		// 0xC82E, Six bytes of counters
int					Vec_Counters		// 0xC82E, Six bytes of counters
int					Vec_Counter_1		// 0xC82E, First  counter byte
int					Vec_Counter_2		// 0xC82F, Second counter byte
int					Vec_Counter_3		// 0xC830, Third  counter byte
int					Vec_Counter_4		// 0xC831, Fourth counter byte
int					Vec_Counter_5		// 0xC832, Fifth  counter byte
int					Vec_Counter_6		// 0xC833, Sixth  counter byte
unsigned long int	Vec_RiseRun_Tmp		// 0xC834, Temp storage word for rise/run
int					Vec_Angle			// 0xC836, Angle for rise/run and rotation calculations
unsigned long int	Vec_Run_Index		// 0xC837, Index pair for run
unsigned long int	Vec_Rise_Index		// 0xC839, Index pair for rise
unsigned long int	Vec_XXX_00			// 0xC839, Pointer to copyright string during startup
int					Vec_RiseRun_Len		// 0xC83B, length for rise/run
int					Vec_XXX_01			// 0xC83B, High score cold-start flag (=0 if valid)
int					Vec_XXX_02			// 0xC83C, temp byte
unsigned long int	Vec_Rfrsh			// 0xC83D, Refresh time (divided by 1.5MHz)
unsigned int		Vec_Rfrsh_lo		// 0xC83D, Refresh time low byte
unsigned int		Vec_Rfrsh_hi		// 0xC83E, Refresh time high byte
int					Vec_Music_Work		// 0xC83F, Music work buffer (14 bytes, backwards?)
int					Vec_Music_Wk_A		// 0xC842, register 10
int					Vec_XXX_03			// 0xC843, register 9
int					Vec_XXX_04			// 0xC844, register 8
int					Vec_Music_Wk_7		// 0xC845, register 7
int					Vec_Music_Wk_6		// 0xC846, register 6
int					Vec_Music_Wk_5		// 0xC847, register 5
int					Vec_XXX_05			// 0xC848, register 4
int					Vec_XXX_06			// 0xC849, register 3
int					Vec_XXX_07			// 0xC84A, register 2
int					Vec_Music_Wk_1		// 0xC84B, register 1
int					Vec_XXX_08			// 0xC84C, register 0
int*				Vec_Freq_Table		// 0xC84D, Pointer to note-to-frequency table (normally 0xFC8D)
long unsigned int	Vec_ADSR_Table		// 0xC84F, Storage for first music header word (ADSR table)
int					Vec_Max_Players		// 0xC84F, Maximum number of players for Select_Game
int					Vec_Max_Games		// 0xC850, Maximum number of games for Select_Game
int*				Vec_Twang_Table		// 0xC851, Storage for second music header word ('twang' table)
int*				Vec_Music_Ptr		// 0xC853, Music data pointer
int					Vec_Expl_ChanA		// 0xC853, Used by Explosion_Snd - bit for first channel used?
int					Vec_Expl_Chans		// 0xC854, Used by Explosion_Snd - bits for all channels used?
int					Vec_Music_Chan		// 0xC855, Current sound channel number for Init_Music
int					Vec_Music_Flag		// 0xC856, Music active flag (0x00=off 0x01=start 0x80=on)
int					Vec_Duration		// 0xC857, Duration counter for Init_Music
int					Vec_Expl_1			// 0xC858, Four bytes copied from Explosion_Snd's U-reg parameters
long unsigned int	Vec_Music_Twang		// 0xC858, 3 word 'twang' table used by Init_Music
int					Vec_Expl_2			// 0xC859, 
int					Vec_Expl_3			// 0xC85A, 
int					Vec_Expl_4			// 0xC85B, 
int					Vec_Expl_Chan		// 0xC85C by Explosion_Snd - channel number in use?
int					Vec_Expl_ChanB		// 0xC85D by Explosion_Snd - bit for second channel used?
int					Vec_XXX_09			// 0xC85E, Scratch 'score' storage for Display_Option (7 bytes)
int					Vec_ADSR_Timers		// 0xC85E, ADSR timers for each sound channel (3 bytes)
int					Vec_ADSR_timers[3]	// 0xC85E, ADSR timers for each sound channel (3 bytes)
unsigned long int	Vec_Music_Freq		// 0xC861, Storage for base frequency of each channel (3 words)
unsigned long int	Vec_Music_freq[3]	// 0xC861, Storage for base frequency of each channel (3 words)
unsigned int		Vec_Expl_Flag		// 0xC867, Explosion_Snd initialization flag?
int					Vec_XXX_10			// 0xC868, Unused?
int					Vec_XXX_11			// 0xC869, Unused?
int					Vec_XXX_12			// 0xC86A, Unused?
int					Vec_XXX_13			// 0xC86B, Unused?
int					Vec_XXX_14			// 0xC86C, Unused?
int					Vec_XXX_15			// 0xC86D, Unused?
int					Vec_XXX_16			// 0xC86E, Unused?
int					Vec_XXX_17			// 0xC86F, Unused?
int					Vec_XXX_18			// 0xC870, Unused?
int					Vec_XXX_19			// 0xC871, Unused?
int					Vec_XXX_20			// 0xC872, Unused?
int					Vec_XXX_21			// 0xC873, Unused?
int					Vec_XXX_22			// 0xC874, Unused?
int					Vec_XXX_23			// 0xC875, Unused?
int					Vec_XXX_24			// 0xC876, Unused?
int					Vec_Expl_Timer		// 0xC877, Used by Explosion_Snd
int					Vec_XXX_25			// 0xC878, Unused?
unsigned int		Vec_Num_Players		// 0xC879, Number of players selected in Select_Game
unsigned int		Vec_Num_Game		// 0xC87A, Game number selected in Select_Game
unsigned int*		Vec_Seed_Ptr		// 0xC87B, Pointer to 3-byte random number seed (=0xC87D)
unsigned int		Vec_Random_Seed		// 0xC87D, working storage for random number generator (3 bytes)
unsigned int		Vec_Random_Seed0	// 0xC87D, Default 3-byte random number seed
unsigned int		Vec_Random_Seed1	// 0xC87E, Default 3-byte random number seed
unsigned int		Vec_Random_Seed2	// 0xC87F, Default 3-byte random number seed

// ---------------------------------------------------------------------------

int					Vec_Default_Stk		// 0xCBEA, Default top-of-stack
unsigned int		Vec_High_Score 		// 0xCBEB, High score storage (7 bytes)
unsigned int		Vec_High_score[7]	// 0xCBEB, High score storage (7 bytes)
int					Vec_SWI3_Vector		// 0xCBF2, SWI2/SWI3 interrupt vector (3 bytes)
int					Vec_SWI3_vector[3]	// 0xCBF2, SWI2/SWI3 interrupt vector (3 bytes)
int					Vec_SWI2_Vector		// 0xCBF2, SWI2/SWI3 interrupt vector (3 bytes)
int					Vec_SWI2_vector[3]	// 0xCBF2, SWI2/SWI3 interrupt vector (3 bytes)
int					Vec_FIRQ_Vector		// 0xCBF5, FIRQ interrupt vector (3 bytes)
int					Vec_FIRQ_vector[3]	// 0xCBF5, FIRQ interrupt vector (3 bytes)
int					Vec_IRQ_Vector		// 0xCBF8, IRQ interrupt vector (3 bytes)
int					Vec_IRQ_vector[3]	// 0xCBF8, IRQ interrupt vector (3 bytes)
int					Vec_SWI_Vector		// 0xCBFB, SWI/NMI interrupt vector (3 bytes)
int					Vec_SWI_vector[3]	// 0xCBFB, SWI/NMI interrupt vector (3 bytes)
int					Vec_NWI_Vector		// 0xCBFB, SWI/NMI interrupt vector (3 bytes)
int					Vec_NWI_vector[3]	// 0xCBFB, SWI/NMI interrupt vector (3 bytes)
long unsigned int	Vec_Cold_Flag		// 0xCBFE, Cold start flag (warm start if = 0x7321)

// ***************************************************************************
// 0xDxx0 - 0xDxxF (16B)	programmable interface adapter VIA (read or write) 
// ***************************************************************************

int					VIA_port_b		// 0xD000, VIA port B data I/O register
int					VIA_port_a		// 0xD001, VIA port A data I/O register (handshaking)
unsigned int		VIA_DDR_b		// 0xD002, VIA port B data direction register (0=input 1=output)
unsigned int		VIA_DDR_a		// 0xD003, VIA port A data direction register (0=input 1=output)
unsigned long int	VIA_t1_cnt		// 0xD004, VIA timer 1 count register
unsigned int		VIA_t1_cnt_lo	// 0xD004, VIA timer 1 count register lo (scale factor)
unsigned int		VIA_t1_cnt_hi	// 0xD005, VIA timer 1 count register hi
unsigned long int	VIA_t1_lch		// 0xD006, VIA timer 1 latch register
unsigned int		VIA_t1_lch_lo	// 0xD006, VIA timer 1 latch register lo
unsigned int		VIA_t1_lch_hi	// 0xD007, VIA timer 1 latch register hi
unsigned long int	VIA_t2			// 0xD008, VIA timer 2 count register lo/hi (little endian access) (refresh)
unsigned int		VIA_t2_lo		// 0xD008, VIA timer 2 count/latch register lo (refresh)
unsigned int		VIA_t2_hi		// 0xD009, VIA timer 2 count/latch register hi
unsigned int		VIA_shift_reg	// 0xD00A, VIA shift register
unsigned int		VIA_aux_cntl	// 0xD00B, VIA auxiliary control register
unsigned int 		VIA_cntl 		// 0xD00C, VIA control register
unsigned int 		VIA_int_flags 	// 0xD00D, VIA interrupt flags register
unsigned int 		VIA_int_enable 	// 0xD00E, VIA interrupt enable register
unsigned int 		VIA_port_a_nohs // 0xD00F, VIA port A data I/O register (no handshaking)

// ***************************************************************************
// end of file
// ***************************************************************************
