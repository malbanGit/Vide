// ***************************************************************************
// cartridge
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

#include <vectrex.h>

// ---------------------------------------------------------------------------
// vectrex cartridge init block 

struct cartridge_t
{
	char copyright[11];			// copyright string, must start with "g GCE" and must end with "\x80"
	const void* music;			// 16 bit memory adress of title music data
	signed int title_height;	// signed 8 bit value, height of game title letters
	unsigned int title_width;	// unsigned 8 bit value, width of game title letters
	int title_y;				// signed 8 bit value, y coordinate of game title
	int title_x;				// signed 8 bit value, x coordinate of game title
	char title[]; 				// game title string, must end with "\x80\x00"
};

// ---------------------------------------------------------------------------
// edit here to set game title

const struct cartridge_t game_header __attribute__((section(".cartridge"), used)) = 
{
	.copyright 		= "g GCE 2021\x80",	// change year if neccessary, do not change "g GCE"
	.music 			= &Vec_Music_1,		// taken from included headers
	.title_height 	= -8,
	.title_width 	= 80,
	.title_y 		= -16,
	.title_x 		= -72,
	.title 			= "C GAME 2 BANKS\x80"	// note that \x00 is automatically appended!
};

#define __ass asm volatile


//void goMain() __attribute__((noreturn,section(".bootloader")));
//void goMain() 
//{
     __asm  (
    ".area .bootloader\n"
    	" jmp _endOfHeading\n"
    );
//}
#define NUMBER_OF_FUNCTIONS 10
extern const void* const bankFunctions[NUMBER_OF_FUNCTIONS] __attribute__((section(".bankswitch.data"))); 


// idea for parameters
//
// all passed parameters use
// unused BIOS RAM locations
// they get loaded before the call
// and reread after the call

 __asm  (
	".area .bankswitch.code\n"
	".setdp 0xd000,_DATA\n"
	".globl _subBank0\n"
	"_subBank0:\n"
    " lda      #0xDF                          ; Prepare DDR Registers % 1101 1111 1111 1111\n"
    " sta      *_VIA_DDR_b                     ; all ORB/ORA to output except ORB 5, PB6 goes LOW\n"
    " lda      #0x01                          ; A = 0x01, B = 0\n"
    " sta      *_VIA_port_b                    ; ORB = 0x1 (ramp on, mux off), ORA = 0 (DAC)\n"
    " ldx      #_bankFunctions\n"
    " lslb\n"
    " ldx b,x\n"
    " jsr      ,x\n"
    " lda      #0x9F                           ; Prepare DDR Registers % 1001 1111 1111 1111\n"
    " sta      *_VIA_DDR_b                     ; all ORB/ORA to output except ORB 5, PB6 goes LOW\n"
	" rts\n"

	"_subBank1:\n"
    " lda      #0x9F                           ; Prepare DDR Registers % 1001 1111 1111 1111\n"
    " sta      *_VIA_DDR_b                     ; all ORB/ORA to output except ORB 5, PB6 goes LOW\n"
    " ldx      #_bankFunctions\n"
    " lslb\n"
    " ldx b,x\n"
    " jsr      ,x\n"
    " lda      #0xDF                          ; Prepare DDR Registers % 1101 1111 1111 1111\n"
    " sta      *_VIA_DDR_b                     ; all ORB/ORA to output except ORB 5, PB6 goes LOW\n"
    " lda      #0x01                          ; A = 0x01, B = 0\n"
    " sta      *_VIA_port_b                    ; ORB = 0x1 (ramp on, mux off), ORA = 0 (DAC)\n"
	" rts\n"

	"_endOfHeading:\n"
);

// ***************************************************************************
// end of file
// ***************************************************************************
