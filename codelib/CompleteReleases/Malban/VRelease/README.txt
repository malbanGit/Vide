Technical Readme

Public Domain
-------------
All files of Release are public domain - so far they were written by me (Malban).

Some files contain work of other people (eprom access, VecFever access, AYFX, BIOS names 
from VECTREX.I etc) this work is NOT public domain. Please contact the
original author to enquire their respective status. The original author is
mentioned whereever I knew who it was.

The music files were done by VTK and he told me "you can do whatever you want".
Well, until VTK revokes that statement - the music pieces accompanying Release
are also public domain.

In General
----------
The directory "VRelease" contains a Vide compatible project.
Copy the directory VRelease to the directory Vide/projects.

To load the project in Vide:
- open Vide
- open the editor (vedi)
- press the button "Open File"
- go to the VRelease directory and chose the file "VReleaseProjectProperty.xml"

The project can be assembled and run from the editor by pressing the "build project" button.

Using Vide and within Vide - vedi - you can use the navigation panel to easily locate "important" 
subroutines. If you configure the navigation panel to only show "user labels" than only those
"important" function labels are shown (although I would advise to also show macro definitions).

I have not tested any other assembler - but the project might also assemble using the
the Kingswood assembler. The main file to assemble is: "VRelease.asm", all other files are
referenced from within that file via include statements.

To get more information about the development of Release, visit the 
development blog at: 
                         http://release.malban.de/

If you do not know what that "Vide" is - I just mentioned - please visit the Vide blog at:
                         http://vide.malban.de/

Configuration
-------------
At the start of VRelease.asm two configuration options can be set.
a) INVINCIBLE [default is 0]
- if defined = 1, than the player can not die (- but also you actually can not quit!)
b) USE_PB6 = 1 [default is 1]
- in general means, that if not defined as 1 
  permanency is disabled. VecFever and DS2431 code is ignored.
  This also means the resulting "bin" file is 
  runnable on a VecFlash/VecMulti without the need to press a button during startup.

Filestructure
-------------
VRelease-Directory
- all source and inclue files

music
- the original music files as provided by VTK, in AKS and bin format

graphics
- cartridge and box graphics

3d
- additional include files for Release, which are based on a prior package I made
  available some 18 years ago

Release.History
- Various stages of Release development as a "study" of stages it went through. From the
   earliest stages to nearly the last 32 different "save" points of mine.
   To "use" these - rename the directory you would like to "use" to VRelease and copy it to your
   Vide/projects directory (and before that - save the "real Release" directory).
  
   Interestingly the game was quite feature complete at the first beta. After that only "beautifying" and 
   small additions came in. But these small additions took "longer" to develope than the 
   whole game! But they also made the game much more playable and overall a complete package!

Source structure
----------------
There is no definite structure - the source "grew" as the project advanced. 
General rules of thump:

Code files
..........

- VRelease.asm
  Is the main file, all files are included from here. As functional blocks it contains:
  * main loop 
  * initialize routines
  * shield drawing and generation
  * score/bonus drawing
  * some support functions

- arkosPlayerXXX
  The two files contain the player routines for Arkos Tracker songs.
  Two variants - one for only one channel, which is used in game - and the
  "complete" player (used in title, highscore and gameover).

- ayfxplayerXXX
  Player for AYFX sound effects. Originally written by Richard Chadd, quite modified by me.

- clip.i
  Routines used for clipping the scrolltext.
  This mainly is the package released some 18 years ago by me. I think it contains 2 bugfixed.

- collisionRoutines.i
  These are a couple of short "divs", that reduce a value given via the U register by a fraction.
  These routines are used for the shield/enemy collision detection. The circle coordinates  
  that are the base of all shields gets modified in accordance to the corresponding shield and
  angle of the shield.

- drawSubRotuines.i
  A collection of some draw routines. The routines are "special" in the way, that they do not
  use the SHIFTREG of VIA to enable/disable the blank flag, but rather use the CNTRL register.
  Also the routines are specialized for certain "scales", specialized in the ways, that they
  do not contain wait loops (but the higher scale versions use some NOPS).

- ds2431XXX and eprom.i
  Contain routines to access the DS2431a one wire eprom chip.
  Also contains some refferences to VecFever routines, since both of these devices can be used
  to permanently save data.

- gameover.asm
  All routines used for the game over animation, also main routine to the 3d "GameOver" display.

- highscore.asm
  Routines to display and edit the highscore.

- inBothBanksXXX
  All definitions that I deemed neccessary to build a bankswitching version.
  * in "1" all variable definitions are done.
  * in "2" used to be bankswitching routines, but as of now only the VecFever routines reside there

- macro.i
  Well - some macro definitions.

- objectsXXX
  * 1 contains all enemy objects, spawn routines, and behaviour routines, also general object routines 
    (new object/remove object)
    To seperate some object behaviours, some additional "data" was injected (each behaviour should start 
    at a seperate page boundary, so they can be uniquely identified by the first byte of the behaviour routine)
    The scrolltext is thus e.g. placed "in the middle" of the file.
  * 2 contains all "friendly" objects, and the explosions

- options.i
  The options screen with everything that goes with it.

- phasedefinitions.i
  "Level" definitions of release

- scroller.asm
  The main scroll routines. Also based on a package I did 18 years ago, although this one
  a) uses a better font
  b) supports "blinking"
  c) supports "smooth" scrolling (clipping of the fonts)
  Bulletpoint "c" comes at the cost, that the edges of the scrolltext are now fixed at -128 <-> 127.
  The original scroller had that configurable. But since I did not need it configurable here - I took a shortcut 
  and hardcoded the borders (although the variables are still in the code and still used - but they
  MUST have the above values)

- sound.i
  Contains routines to access the PSG chip.
  All sounds produced by AYFX and the Arkos player are written to a "shadow" area. 
  The YM routine looks each round which registers changed, and updates only those.
  Also contains the definition of all sound effects used within the game.

- title.i
  All routines used within the title screen, mainly the circling "RELEASE", as the scroller and clipping
  is actually contained within different files.

- unloop.i
  A leftover from Karl Quappe. Some very view vectorlists are drawn using loop unrolling.


Data files
..........
- abc.i
  Contains the font definition that is used through the game to show text. The Font is "special" in the
  way, that each "length" is dividable by 8, this makes (easy) clipping possible - using the above mentioned package.

- data.i
 Contains all vectorlists of graphical elements, also contains the definition of the
 numbers (those are not within the abc.i).
 Also contains the "circle" definition.

- sound.i
  see above

- VTK****
  The generated assembler source versions of the Arkos Tracker songs done by VTK



