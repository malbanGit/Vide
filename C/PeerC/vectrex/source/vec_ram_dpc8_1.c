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
	".area direct (OVR,BANK=page_00)\n\t"
);

// ***************************************************************************
// 0xC800 - 0xCBFF (1KB)	static RAM (read or write)
// ---------------------------------------------------------------------------
// 0xC800 - 0xC87F (128B)	reserved for RUM
// 0xC880 - 0xCBE0 (874B)	reserved for game logic including stack
// 0xCBEA - 0xCBFF (22B)	reserved for RUM
// ***************************************************************************

int					dp_Vec_Snd_Shadow[0x1f-0x00] 	__attribute__((section("direct"), used));	// 0xC800, Shadow of sound chip registers (15 bytes)
int					dp_Vec_Joy_Mux_1_X				__attribute__((section("direct"), used));	// 0xC81F, Joystick 1 X enable/mux flag (=1)
int					dp_Vec_Joy_Mux_1_Y				__attribute__((section("direct"), used));	// 0xC820, Joystick 1 Y enable/mux flag (=3)
int					dp_Vec_Joy_Mux_2_X				__attribute__((section("direct"), used));	// 0xC821, Joystick 2 X enable/mux flag (=5)
int					dp_Vec_Joy_Mux_2_Y[0x25-0x22]	__attribute__((section("direct"), used));	// 0xC822, Joystick 2 Y enable/mux flag (=7)
unsigned int		dp_Vec_Loop_Count_hi			__attribute__((section("direct"), used));	// 0xC825, Loop counter hi byte (incremented in Wait_Recal)
unsigned int		dp_Vec_Loop_Count_lo[0x2a-0x26]	__attribute__((section("direct"), used));	// 0xC826, Loop counter lo byte (incremented in Wait_Recal)
int 				dp_Vec_Text_Height 				__attribute__((section("direct"), used));	// 0xC82A, Default text height
int					dp_Vec_Text_Width[0x2e - 0x2b] 	__attribute__((section("direct"), used));	// 0xC82B, Default text width
int					dp_Vec_Counter_1				__attribute__((section("direct"), used));	// 0xC82E, First  counter byte
int					dp_Vec_Counter_2				__attribute__((section("direct"), used));	// 0xC82F, Second counter byte
int					dp_Vec_Counter_3				__attribute__((section("direct"), used));	// 0xC830, Third  counter byte
int					dp_Vec_Counter_4				__attribute__((section("direct"), used));	// 0xC831, Fourth counter byte
int					dp_Vec_Counter_5				__attribute__((section("direct"), used));	// 0xC832, Fifth  counter byte
int					dp_Vec_Counter_6[0x39-0x33]		__attribute__((section("direct"), used));	// 0xC833, Sixth  counter byte
unsigned long int	dp_Vec_XXX_00					__attribute__((section("direct"), used));	// 0xC839, Pointer to copyright string during startup
int					dp_Vec_XXX_01[0x3d-0x3b]		__attribute__((section("direct"), used));	// 0xC83B, High score cold-start flag (=0 if valid)
unsigned int		dp_Vec_Rfrsh_lo					__attribute__((section("direct"), used));	// 0xC83D, Refresh time low byte
unsigned int		dp_Vec_Rfrsh_hi[0x4f-0x3e]		__attribute__((section("direct"), used));	// 0xC83E, Refresh time high byte
int					dp_Vec_Max_Players				__attribute__((section("direct"), used));	// 0xC84F, Maximum number of players for Select_Game
int					dp_Vec_Max_Games[0x53-0x50]		__attribute__((section("direct"), used));	// 0xC850, Maximum number of games for Select_Game
int					dp_Vec_Expl_ChanA				__attribute__((section("direct"), used));	// 0xC853, Used by Explosion_Snd - bit for first channel used?
int					dp_Vec_Expl_Chans[0x58-0x54]	__attribute__((section("direct"), used));	// 0xC854, Used by Explosion_Snd - bits for all channels used?
unsigned int		dp_Vec_Music_Twang[0x5e - 0x58]	__attribute__((section("direct"), used));	// 0xC858, 3 word 'twang' table used by Init_Music
int					dp_Vec_ADSR_Timers[0x61-0x5e]	__attribute__((section("direct"), used));	// 0xC85E, ADSR timers for each sound channel (3 bytes)
unsigned int		dp_Vec_Music_Freq[0x7d-0x61]	__attribute__((section("direct"), used));	// 0xC861, Storage for base frequency of each channel (3 words)
unsigned int		dp_Vec_Random_Seed				__attribute__((section("direct"), used));	// 0xC87D, working storage for random number generator (3 bytes)

// ***************************************************************************
// end of file
// ***************************************************************************
