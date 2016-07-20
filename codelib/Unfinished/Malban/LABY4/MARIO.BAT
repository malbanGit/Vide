@echo off
data\back_db data\turning.sam data\turning.db
data\back_db data\west.sam data\west.db
data\back_db data\south.sam data\south.db
data\back_db data\east.sam data\east.db
data\back_db data\north.sam data\north.db
..\ass\as09.exe -w200 -h0 -l -mcti MARIO.asm >error
if errorlevel 1 goto error
del error
::del MARIO.lst
copy MARIO.bin ..\..
rem ..\ass\make_cnt.exe MARIO.lst MARIO.cnt
rem copy MARIO.cnt ..
cd ..\..
cd eprom
rem call MARIO.bat
cd ..
vectrex MARIO.bin
cd dev\MARIO
goto end
:error
echo Assembling error!
:end
