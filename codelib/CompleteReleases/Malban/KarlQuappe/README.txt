Technical Readme

Public Domain
-------------
All files of Karl_Quappe are public domain - so far they were written by me (Malban).

Some files contain work of other people (eprom access, VecFever access, BIOS names 
from VECTREX.I etc) this work is NOT public domain. Please contact the
original author to enquire their respective status. The original author is
mentioned whereever I knew who it was.


In General
----------
The directory "KarlQuappe" contains a Vide compatible project.
Copy the directory KarlQuappe to the directory Vide/projects.

To load the project in Vide:
- open Vide
- open the editor (vedi)
- press the button "Open File"
- go to the KarlQuappe directory and chose the file "KarlQuappeProjectProperty.xml"

The project can be assembled and run from the editor by pressing the "build project" button.

I have not tested any other assembler - but the project might also assemble using the
the Kingswood assembler. The main file to assemble is: "KarlQuappe.asm", all other files are
referenced from within that file via include statements.

If you do not know what that "Vide" is - I just mentioned - please visit the Vide blog at:
                         http://vide.malban.de/

Configuration
-------------
At the start of KarlQuappe.asm one configuration options can be set.
a) USE_PB6 = 1 [default is 1]
- in general means, that if not defined as 1 
  permanency is disabled. VecFever and DS2431 code is ignored.
  This also means the resulting "bin" file is 
  runnable on a VecFlash/VecMulti without the need to press a button during startup.

Filestructure
-------------
KarlQuappe-Directory
- all source and inclue files

other
- all files for 
  * overlay
  * instruction manual
  * embossment
  
sounds
- the sound files used in KarlQuappe

vlists
- most, if not all, vectorlists used within KarlQuappe

Source structure
----------------
There is no definite structure - the source "grew" as the project advanced. 
General rules of thump:

Code files
..........

- KarlQuappe.asm
  Is the main file, all files are included from here. As functional blocks it contains:
  * main loop 
  * initialize routines
  * some bios replacement routines (joystick, sound, random)
  * game over
  * title screen

- attractData.i
  Data file which contains data for the attract mode 

- ayfxplayer_f.i
  Player for AYFX sound effects only for channel 3. Originally written by Richard Chadd, quite modified by me.

- ds2431XXX and epromStuff.i
  Contain routines to access the DS2431a one wire eprom chip.
  Also contains some refferences to VecFever routines, since both of these devices can be used
  to permanently save data.

- FASTSPRI.I
  Collector for all vectorlists

- highscoreXXX.i
  All routines/macros concerned with highscores

- IMISSION.I
  All kinds of intermissions (not many left) - mainly "deathbox", "leveldonebox", timer stuff 
  and two player copy/initialization routines

- InMovesXXX.i
  Small "macro"ed routines that can be placed "inside" of moveTo routines (in the wait period)
  
- LEVELS.i
  Definition of the 16 levels

- MACROS.I
  Mainly BIOS replacement macros.

- MORPH.I
  Routines to do the morphing (timer)

- musics.i
  colector for all sounds/music data (except yankee)

- MY_MACROS.I
  Another collection of macros, sound, WaitRecal, Moeveto...

- options.i
  The options screen

- print.i
  5 row font definitions, 8 row font definition, print routines for those fonts

- rasterDraw.asm
  routine to draw the title image (raster)
  
- UNLOOP.I
  routines to draw vectrlists unlooped

- YANKEE.I
  Data of the yankee doodle music piece in BIOS format

- ymStreamedPlayerKarl.i
  Streamed ym player optimized for Karl Quappe




