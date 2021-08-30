// ***************************************************************************
// main
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
#include <assert.h>			

#include "../globals.h"

// As default assertions are enabled.
// to disable do a
// "#define NDEBUG"
// or set the gcc option "-D NDEBUG" (Vide project file)


// ---------------------------------------------------------------------------
// cold reset: the vectrex logo is shown, all ram data is cleared
// warm reset: skip vectrex logo and keep ram data
// ---------------------------------------------------------------------------
// at system startup, when powering up the vectrex, a cold reset is performed
// if the reset button is pressed, then a warm reset is performed
// ---------------------------------------------------------------------------
// after each reset, the cartridge title is shown and then main() is called
// ---------------------------------------------------------------------------

void printBank0Message()
{
		Print_Str_d(40, -70, "HELLO FROM BANK 0!\x80");
}


// !!! ATTENTION
// BANK 0 and BANK 1
// are two TOTALLY seperated "C" programs
// 
// but only BANK 1 is initialized
// this means amongst others, that 
// EITHER
// ALL global variables must be exactly the same!
// 
// OR
// BANK 0 must not have any global variables at all
// unless they OVERWRITE Bank 1 variables!!!
// (also - they will always be uninitialized!)
//
// (or you devise a plan to ensure the RAM does not collide in any other way!)
//
//
// further thoughts on
// global variables in "globals.h"


int main(void)
{
}

// ***************************************************************************
// end of file
// ***************************************************************************
