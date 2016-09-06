@echo off
as09.exe -w200 -h0 -l -mctiz test.asm >error
if errorlevel 1 goto error
del error
::del test.lst
back.exe left.bin left.bac
back.exe right.bin right.bac
back.exe frogger.bin frogger.bac
copy /B test.bin + left.bac + right.bac + frogger.bac test.tmp
copy test.tmp test.bin
del test.tmp
::copy test.bin ..
::make_cnt.exe test.lst test.cnt
::copy test.bin ..\eprom
::cd ..
::cd eprom
::  call test.bat
::cd ..
::vectrex test.bin
::cd dev
goto end
:error
echo Assembling error!
:end
