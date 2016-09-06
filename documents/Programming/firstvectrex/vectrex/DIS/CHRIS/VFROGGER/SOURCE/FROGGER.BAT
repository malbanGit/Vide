@echo off
..\ass\as09.exe -w200 -h0 -l -mcti frogger.asm >error
if errorlevel 1 goto error
del error
::del frogger.lst
::copy frogger.bin ..\..
::make_cnt.exe frogger.lst frogger.cnt
::cd ..\..
::cd eprom
::call frogger.bat
::cd ..
::vectrex frogger.bin
::cd dev\frogger
echo Assembling OK!
goto end
:error
echo Assembling error!
:end
