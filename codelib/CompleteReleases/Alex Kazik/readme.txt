
P1X3L-pushr
===========

This a new Vectrex game, a remake of our own P1X3L-pushr for the C64:
http://csdb.dk/release/?id=66971

for more informations see:
http://alex.kazik.de/278/vectrex-p1x3l-pushr/


Usage
-----

Use Joystick 1 to move the player forward/backward and rotate it.
When moving forward boxes can be pushed, the goal is it to move all
boxes to a target field.
Pressing one of the outer buttons will reset the current level while
a push on the inner buttons is only for cheaters and advances to the
next level.


Credits
-------

Code: ALeX of P1X3L.net
Graphics: Retrofan of P1X3L.net


Source
------

The Source is included in this archive.

To generate the levels just use "php levels.php", this step is only necessary if
you changed the leveles because there are already included in the main source.

To compile the source use Alfred Arnold's Macroassembler AS:
http://john.ccac.rwth-aachen.de:8000/as/index.html
"asl -L -U pushr.asm && p2bin -r 0-\$ pushr.p pushr.bin"


License
-------

This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/deed.en_US.
