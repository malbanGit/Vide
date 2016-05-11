3D for assembler.

Only

####################################################
   AS09 Assembler for M6809/H6309 [1.19].
   Copyright 1994-97, Frank A. Vorstenbosch
####################################################

supported, since I make heavy use of the macro
functionality that assembler supplies.

I strongly recomend using that Assembler for vectrex
development anyway, since it IS good.


This Assembler port was done in about 2h.

I don't promise it will work allright.
I only tested it with the CUBEM.

Strangely enough the assembler port needs another vector
to keep the cube in center than the C version.

This MIGHT just be a bug somewhere, but I don't know
if it is in assembly or in C.


If there are errors in the assembler port they will
most probably be in the ###.i files.
The macro definitions for the uniform vectors.

If some vector does not come out as expected, take a look
at these definitions and compare them with their
C counterpart.

They nearly look the same, so if there is a bug you will
probably discover it by a closer look.

It was really a boring job to convert those 14 files, so
there might just be that I made a few mistakes by accidently
falling asleep while doing it :-)

For comments on how to use it, read the "3ddemo.txt".

A small assembler demo is provided, see there how to use it
from assembler.

There are 3 main files for the assembler version.

The file "3D_VAR.I" declares all needed variables, and should
go to the BSS section (including).

The file "3D_MAKRO.I" includes all macros that are there for 3d
stuff. Should be at the beginning of your code section.
But may probably be placed anywhere it fits.

The file "3D_PRG.I" has the two custom vector drawing functions.
Include it somewhere in your code section.
It also holds the cosinus and sinus tables, needed for angle computations.

Thats it for now!

Malban

