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
	".bank page_c8 (BASE=0xc800,SIZE=0x0080)\n\t"
	".area .dpc8 (OVR,BANK=page_c8)\n\t"
);

// ***************************************************************************
// 0xC800 - 0xCBFF (1KB)	static RAM (read or write)
// ---------------------------------------------------------------------------
// 0xC800 - 0xC87F (128B)	reserved for RUM
// 0xC880 - 0xCBE0 (874B)	reserved for game logic including stack
// 0xCBEA - 0xCBFF (22B)	reserved for RUM
// ***************************************************************************
int	Vec_Snd_shadow[0x1f]		__attribute__((section(".dpc8"), used));	// 0xC800, Shadow of sound chip registers (15 bytes)
int Vec_Joy_Mux[0x2e - 0x1f] 	__attribute__((section(".dpc8"), used));	// 0xC81F, Joystick enable/mux flags (4 bytes)
int	Vec_Counters[0x5e - 0x2e]	__attribute__((section(".dpc8"), used));	// 0xC82E, Six bytes of counters
int	Vec_XXX_09					__attribute__((section(".dpc8"), used));	// 0xC85E, Scratch 'score' storage for Display_Option (7 bytes)

// ***************************************************************************
// end of file
// ***************************************************************************
