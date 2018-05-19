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

int	dp_Vec_Snd_shadow[0x1f]			__attribute__((section("direct"), used));	// 0xC800, Shadow of sound chip registers (15 bytes)
int dp_Vec_Joy_Mux[0x2e - 0x1f] 	__attribute__((section("direct"), used));	// 0xC81F, Joystick enable/mux flags (4 bytes)
int	dp_Vec_Counters[0x5e - 0x2e]	__attribute__((section("direct"), used));	// 0xC82E, Six bytes of counters
int	dp_Vec_XXX_09					__attribute__((section("direct"), used));	// 0xC85E, Scratch 'score' storage for Display_Option (7 bytes)

// ***************************************************************************
// end of file
// ***************************************************************************
