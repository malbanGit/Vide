// ***************************************************************************
// VECTREX EXECUTIVE RAM
// as described in the Vectrex Programmer's Manual Volume 1
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
// ---------------------------------------------------------------------------

__asm(
	".bank page_00 (BASE=0x0000,SIZE=0x0100)\n\t"
	".area .direct (OVR,BANK=page_00)\n\t"
);

// ***************************************************************************
// 0xC800 - 0xCBFF (1KB)	static RAM (read or write)
// ---------------------------------------------------------------------------
// 0xC800 - 0xC87F (128B)	reserved for RUM
// 0xC880 - 0xCBE0 (874B)	reserved for game logic including stack
// 0xCBEA - 0xCBFF (22B)	reserved for RUM
// ***************************************************************************
int					dp_Vec_Snd_shadow[15]	__attribute__((section(".direct"), used));	// 0xC800, Shadow of sound chip registers (15 bytes)
unsigned int		dp_Vec_Btn_State 		__attribute__((section(".direct"), used));	// 0xC80F, Current state of all joystick buttons
unsigned int		dp_Vec_Prev_Btns 		__attribute__((section(".direct"), used));	// 0xC810, Previous state of all joystick buttons
unsigned int		dp_Vec_Buttons 			__attribute__((section(".direct"), used));	// 0xC811, Current toggle state of all buttons
unsigned int		dp_Vec_Button_1_1 		__attribute__((section(".direct"), used));	// 0xC812, Current toggle state of stick 1 button 1
unsigned int		dp_Vec_Button_1_2		__attribute__((section(".direct"), used));	// 0xC813, Current toggle state of stick 1 button 2
unsigned int		dp_Vec_Button_1_3		__attribute__((section(".direct"), used));	// 0xC814, Current toggle state of stick 1 button 3
unsigned int		dp_Vec_Button_1_4		__attribute__((section(".direct"), used));	// 0xC815, Current toggle state of stick 1 button 4
unsigned int		dp_Vec_Button_2_1		__attribute__((section(".direct"), used));	// 0xC816, Current toggle state of stick 2 button 1
unsigned int		dp_Vec_Button_2_2		__attribute__((section(".direct"), used));	// 0xC817, Current toggle state of stick 2 button 2
unsigned int		dp_Vec_Button_2_3		__attribute__((section(".direct"), used));	// 0xC818, Current toggle state of stick 2 button 3
unsigned int		dp_Vec_Button_2_4		__attribute__((section(".direct"), used));	// 0xC819, Current toggle state of stick 2 button 4
int					dp_Vec_Joy_Resltn		__attribute__((section(".direct"), used));	// 0xC81A, Joystick A/D resolution (0x80=min 0x00=max)
int 				dp_Vec_Joy_1_X			__attribute__((section(".direct"), used));	// 0xC81B, Joystick 1 left/right
int					dp_Vec_Joy_1_Y			__attribute__((section(".direct"), used));	// 0xC81C, Joystick 1 up/down
int					dp_Vec_Joy_2_X			__attribute__((section(".direct"), used));	// 0xC81D, Joystick 2 left/right
int					dp_Vec_Joy_2_Y			__attribute__((section(".direct"), used));	// 0xC81E, Joystick 2 up/down
int					dp_Vec_Joy_mux[4] 		__attribute__((section(".direct"), used));	// 0xC81F, Joystick enable/mux flags (4 bytes)
unsigned int		dp_Vec_Misc_Count		__attribute__((section(".direct"), used));	// 0xC823, Misc counter/flag byte, zero when not in use
int					dp_Vec_0Ref_Enable		__attribute__((section(".direct"), used));	// 0xC824, Check0Ref enable flag
unsigned long int	dp_Vec_Loop_Count		__attribute__((section(".direct"), used));	// 0xC825, Loop counter word (incremented in Wait_Recal)
int					dp_Vec_Brightness		__attribute__((section(".direct"), used));	// 0xC827, Default brightness
unsigned int		dp_Vec_Dot_Dwell		__attribute__((section(".direct"), used));	// 0xC828, Dot dwell time?
unsigned int		dp_Vec_Pattern			__attribute__((section(".direct"), used));	// 0xC829, Dot pattern (bits)
unsigned long int	dp_Vec_Text_HW 			__attribute__((section(".direct"), used));	// 0xC82A, Default text height and width
int*				dp_Vec_Str_Ptr			__attribute__((section(".direct"), used));	// 0xC82C, Temporary string pointer for Print_Str
int					dp_Vec_counters[6]		__attribute__((section(".direct"), used));	// 0xC82E, Six bytes of counters
unsigned long int	dp_Vec_RiseRun_Tmp		__attribute__((section(".direct"), used));	// 0xC834, Temp storage word for rise/run
int					dp_Vec_Angle			__attribute__((section(".direct"), used));	// 0xC836, Angle for rise/run and rotation calculations
unsigned long int	dp_Vec_Run_Index		__attribute__((section(".direct"), used));	// 0xC837, Index pair for run
unsigned long int	dp_Vec_Rise_Index		__attribute__((section(".direct"), used));	// 0xC839, Index pair for rise
int					dp_Vec_RiseRun_Len		__attribute__((section(".direct"), used));	// 0xC83B, length for rise/run
int					dp_Vec_XXX_02			__attribute__((section(".direct"), used));	// 0xC83C, temp byte
unsigned long int	dp_Vec_Rfrsh			__attribute__((section(".direct"), used));	// 0xC83D, Refresh time (divided by 1.5MHz)
int					dp_Vec_Music_Work[3]	__attribute__((section(".direct"), used));	// 0xC83F, Music work buffer (14 bytes, backwards?)
int					dp_Vec_Music_Wk_A		__attribute__((section(".direct"), used));	// 0xC842, register 10
int					dp_Vec_XXX_03			__attribute__((section(".direct"), used));	// 0xC843, register 9
int					dp_Vec_XXX_04			__attribute__((section(".direct"), used));	// 0xC844, register 8
int					dp_Vec_Music_Wk_7		__attribute__((section(".direct"), used));	// 0xC845, register 7
int					dp_Vec_Music_Wk_6		__attribute__((section(".direct"), used));	// 0xC846, register 6
int					dp_Vec_Music_Wk_5		__attribute__((section(".direct"), used));	// 0xC847, register 5
int					dp_Vec_XXX_05			__attribute__((section(".direct"), used));	// 0xC848, register 4
int					dp_Vec_XXX_06			__attribute__((section(".direct"), used));	// 0xC849, register 3
int					dp_Vec_XXX_07			__attribute__((section(".direct"), used));	// 0xC84A, register 2
int					dp_Vec_Music_Wk_1		__attribute__((section(".direct"), used));	// 0xC84B, register 1
int					dp_Vec_XXX_08			__attribute__((section(".direct"), used));	// 0xC84C, register 0
int*				dp_Vec_Freq_Table		__attribute__((section(".direct"), used));	// 0xC84D, Pointer to note-to-frequency table (normally 0xFC8D)
long unsigned int	dp_Vec_ADSR_Table		__attribute__((section(".direct"), used));	// 0xC84F, Storage for first music header word (ADSR table)
int*				dp_Vec_Twang_Table		__attribute__((section(".direct"), used));	// 0xC851, Storage for second music header word ('twang' table)
int*				dp_Vec_Music_Ptr		__attribute__((section(".direct"), used));	// 0xC853, Music data pointer
int					dp_Vec_Music_Chan		__attribute__((section(".direct"), used));	// 0xC855, Current sound channel number for Init_Music
int					dp_Vec_Music_Flag		__attribute__((section(".direct"), used));	// 0xC856, Music active flag (0x00=off 0x01=start 0x80=on)
int					dp_Vec_Duration			__attribute__((section(".direct"), used));	// 0xC857, Duration counter for Init_Music
int					dp_Vec_Expl_1			__attribute__((section(".direct"), used));	// 0xC858, Four bytes copied from Explosion_Snd's U-reg parameters
int					dp_Vec_Expl_2			__attribute__((section(".direct"), used));	// 0xC859, 
int					dp_Vec_Expl_3			__attribute__((section(".direct"), used));	// 0xC85A, 
int					dp_Vec_Expl_4			__attribute__((section(".direct"), used));	// 0xC85B, 
int					dp_Vec_Expl_Chan		__attribute__((section(".direct"), used));	// 0xC85C by Explosion_Snd - channel number in use?
int					dp_Vec_Expl_ChanB		__attribute__((section(".direct"), used));	// 0xC85D by Explosion_Snd - bit for second channel used?
int					dp_Vec_ADSR_timers[3]	__attribute__((section(".direct"), used));	// 0xC85E, ADSR timers for each sound channel (3 bytes)
unsigned long int	dp_Vec_Music_freq[3]	__attribute__((section(".direct"), used));	// 0xC861, Storage for base frequency of each channel (3 words)
unsigned int		dp_Vec_Expl_Flag		__attribute__((section(".direct"), used));	// 0xC867, Explosion_Snd initialization flag?
int					dp_Vec_XXX_10			__attribute__((section(".direct"), used));	// 0xC868, Unused?
int					dp_Vec_XXX_11			__attribute__((section(".direct"), used));	// 0xC869, Unused?
int					dp_Vec_XXX_12			__attribute__((section(".direct"), used));	// 0xC86A, Unused?
int					dp_Vec_XXX_13			__attribute__((section(".direct"), used));	// 0xC86B, Unused?
int					dp_Vec_XXX_14			__attribute__((section(".direct"), used));	// 0xC86C, Unused?
int					dp_Vec_XXX_15			__attribute__((section(".direct"), used));	// 0xC86D, Unused?
int					dp_Vec_XXX_16			__attribute__((section(".direct"), used));	// 0xC86E, Unused?
int					dp_Vec_XXX_17			__attribute__((section(".direct"), used));	// 0xC86F, Unused?
int					dp_Vec_XXX_18			__attribute__((section(".direct"), used));	// 0xC870, Unused?
int					dp_Vec_XXX_19			__attribute__((section(".direct"), used));	// 0xC871, Unused?
int					dp_Vec_XXX_20			__attribute__((section(".direct"), used));	// 0xC872, Unused?
int					dp_Vec_XXX_21			__attribute__((section(".direct"), used));	// 0xC873, Unused?
int					dp_Vec_XXX_22			__attribute__((section(".direct"), used));	// 0xC874, Unused?
int					dp_Vec_XXX_23			__attribute__((section(".direct"), used));	// 0xC875, Unused?
int					dp_Vec_XXX_24			__attribute__((section(".direct"), used));	// 0xC876, Unused?
int					dp_Vec_Expl_Timer		__attribute__((section(".direct"), used));	// 0xC877, Used by Explosion_Snd
int					dp_Vec_XXX_25			__attribute__((section(".direct"), used));	// 0xC878, Unused?
unsigned int		dp_Vec_Num_Players		__attribute__((section(".direct"), used));	// 0xC879, Number of players selected in Select_Game
unsigned int		dp_Vec_Num_Game			__attribute__((section(".direct"), used));	// 0xC87A, Game number selected in Select_Game
unsigned int*		dp_Vec_Seed_Ptr			__attribute__((section(".direct"), used));	// 0xC87B, Pointer to 3-byte random number seed (=0xC87D)
unsigned int		dp_Vec_Random_Seed0		__attribute__((section(".direct"), used));	// 0xC87D, Default 3-byte random number seed
unsigned int		dp_Vec_Random_Seed1		__attribute__((section(".direct"), used));	// 0xC87E, Default 3-byte random number seed
unsigned int		dp_Vec_Random_Seed2		__attribute__((section(".direct"), used));	// 0xC87F, Default 3-byte random number seed

// ***************************************************************************
// end of file
// ***************************************************************************
