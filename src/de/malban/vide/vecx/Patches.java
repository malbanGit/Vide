/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

/**
 *
 * @author salchr
 */
public class Patches 
{
    // from MAME Machine:
    	/*
	 * Minestorm's PRNG doesn't work with a 0 seed (mines in the first
	 * level are not randomly distributed then). Only patch the seed's
	 * location since initializing all RAM randomly causes problems
	 * with Berzerk.
	 */
    /*
	m_gce_vectorram[0x7e] = machine().rand() | 1;
	m_gce_vectorram[0x7f] = machine().rand() | 1;
*/    
 
    // Parabellum
  /*  
07/07/2006

Finally located the bug in MineStorm that drew garbage vectors for a few seconds when a fireball mine was shot before it became active.

It was in fact an error in the original code of minestorm, not in the emulator : In the mines rendering code, drawing an inactive fireball mine that was destroyed ended up in rendering a list that was located in the cartridge rom space (which is empty, since Minestorm is running)!

Once the bug was identified, the cure was extremely easy : initialising the cartridge rom space with $01, so that every location in this space is an empty Vector List.

Here is the comment added to the removeCartridge() method in VectrexMemory.java:
*/
    /**
    * We fill with $01 to bypass a bug in MineStorm (invalid
    * reference to the ROM area, when a fireball mine is hit by
    * a bullet while it is not yet moving). This could be fixed
    * around here in the ROM :
    *
    * launch_fireball:
    * EC17 [86.04.........] LDA #4
    * EC19 [A7.41.........] STA 1,U
    * EC1B [0A.EA.........] DEC <$EA ; $C8EA
    * EC1D [7E.EB.53......] JMP check_next_bullet ; $EB53
    *
    * Somewhere in this routine there should have been :
    * LDA #8 ; mark fireball as active
    * STA ,U ; store mine state (if it wasn't moving, state was $10)
    *
    * Actually, when a stationnary fire mine is hit, the program ends
    * up drawing a VL located at $3408 (because it assumes that an
    * object that's not moving is either a dumb / fire / magnet /
    * magnet+fire mine, whereas here it's a fireball!
    *
    * So to fix this we just fill the ROM with ones so that it
    * becomes a big empty vector list.
    *
    */    
    
    
    /*
    BUG: The first version has a bug which may cause the game to reset back to the title screen. Once a level is cleared, the program jumps to some code which looks to see if any buttons are pressed - if they are, then it assumes the user wants to start a new game. This routine should have only been executed when a game was over. According to the Vectrex help line is that after level 13, if you had more than 1 shot on the screen when the last mine was destroyed, the system would reset.

BUG: The first 2 versions have the “level 13” bug. Each level of Mine Storm is described by an entry in an array of structures; which determines such details as the types of mines at a given level, etc. Unfortunately, the array was only defined to contain 13 entries! That's why the first 13 levels work as expected; however, once you got past level 13, the game ran out of array entries. Since the game doesn’t check for this, it simply uses the next block of code after the array for level details. The code was smart enough to skip levels if there were no valid mines, which is why that sometimes happens. 
        */
        
}
