   _
 _| |_ ___ _ ___ ___ _     ___ ___ ___ ___ ___ ___   ___ ___ ___ ___ ___ _____
|   |_|   |_|_  |   | |   |   |   | | |   |   |   | |   | | |   |_  |   | | | |
| | | | | | | | | | | |_  | |_| | | | | | | | | |_| | |_| | | |_| | | | | | | |
| | | | | | | | |   | | | |_  | | | | | | | | |_  | |_  | | |_  | | |  _| | | |
| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
|___|_|_  |_| |_|_|_|___| |___|___|___|_|_|___|___| |___|_  |___| |_|___|_|_|_|
      | | |                                             | | | 
      |___|                    ~ presents ~             |___|  [LDA, STA, THC]
            
           3D VECTOR SPACE CAB - a 16Kb game for your Vectrex \o/
           
             ---={(...or Windows / Mac / Linux machine...)}=---
              
                design & code by Fell^DSS for Ludum Dare #38

    /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
    TOO LONG WON'T READ? Run the batch file, controls are LEFT, RIGHT and R!
    \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
    
===============================================================================
PLAY
===============================================================================

Pick up passengers and drop them at their destinations. Refuel at fuel depots!
Score MAD COMBO POINTS for doing multiple passenger trips without refuelling.

*** WINDOWS: Run RUN_ME.bat

*** MAC & LINUX: Get ParaJVE from http://www.vectrex.fr/ParaJVE/ and then load 
the ROM ludumdare.bin from this zip

*** REAL VECTREX: Burn ludumdare.bin to an EPROM (or dev cart of your choice).

THRUST: R (any button on hardware)
LEFT/RIGHT: Cursors (joystick on hardware)

===============================================================================
ABOUT
===============================================================================

Coded by Fell^DSS/RiFT/TRSi as an entry in the 48 hr compo, with much emotional
support from a bunch o friendly Twitchers.

The platform's Vectrex: An amazing machine from 1982. 

CPU: 1.5Mhz Motorola 6809
RAM: 1Kb (a bit less than that is usable as the BIOS maintains some state)
ROM: 4Kb BIOS, 32Kb space on a game ROM
Resolution: IT DOESN'T WORK LIKE THAT (Awesome analogue vector display, no 
scanlines here)         
Audio: 3 channels (AY-3-8912 chip)

More info: https://en.wikipedia.org/wiki/Vectrex

TESTED ON REAL HARDWARE!

If you have a real Vectrex, you can burn ludumdare.bin to a standard EPROM and 
enjoy the game on your machine.

Otherwise (assuming you're on Windows), hit RUN_ME.bat to play in the awesome 
ParaJVE emulator (Java runtime required). For other platforms, get thee to
http://www.vectrex.fr/ParaJVE/ and download an emulator.

===============================================================================
BUILD
===============================================================================

Assemble ludumdare.asm with as09. That file includes everything else needed.

===============================================================================
TOOLS USED
===============================================================================

Notepad++
as09
ParaJVE
Vide
AY Sound FX Editor



