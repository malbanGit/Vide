// ***************************************************************************
// vectrex cartridge init block
// ***************************************************************************

#include "config.h"
#include "utils/utils.h"
#include "cartridge.h"
#include "melody.h"

// ---------------------------------------------------------------------------
// game title

const struct cartridge_t game_header __attribute__((section(".cartridge"), used)) = 
{
	.copyright 		= "g GCE 2021\x80",
	.music 			= &melody_game_title,
	.title_height 	= TEXT_HEIGHT_L,
	.title_width 	= TEXT_WIDTH_L,
	.title_y 		= 32,
	.title_x 		= CENTER_TEXT(TEXT_WIDTH_L, 16),
	.title 			= "KINGSLAYER CHESS\x80" // note that \x00 is automatically appended!
};

__attribute__((section(".text.last")))
void eof(void)
{
}

__attribute__((section(".bankswitch.code")))
void foo(void)
{
}

__attribute__((section(".bankswitch.code")))
void bar(void)
{
}

const int willi __attribute__((section(".bankswitch.data"))) = 42;
const int hugo __attribute__((section(".bankswitch.data"))) = 17;

// ***************************************************************************
// end of file
// ***************************************************************************
