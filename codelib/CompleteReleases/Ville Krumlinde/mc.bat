@echo off
rem gcc09 -Wall -Wl,-b,_CODE=0xA000 -O2 -o hello.bin hello.c

rem Generate source
cd..\gcc

rem gcc09 -S -Wall -ffast-math -fomit-frame-pointer -fstrict-aliasing -Wl,-b,_CODE=0xA000 -O3 -o ..\thrust\test.s ..\thrust\thrustc\clip.c
rem för lång kommandorad ger: "could not execute"?
gcc09 -S -Wall -ffast-math -fomit-frame-pointer -fverbose-asm -O3 -o ..\thrust\test.s ..\thrust\thrustc\clip.c

rem gcc09 -S -o ..\thrust\test.s ..\thrust\thrustc\clip.c
cd..\thrust
