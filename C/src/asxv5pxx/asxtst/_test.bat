@echo off
REM
REM   Select Assembler Diagnostic to Assemble and Link
REM

if %1.==/?. goto HELP

REM 2-Byte Addressing
if %1.==2bhi. goto 2BHI
if %1.==2blo. goto 2BLO
if %1.==2BHI. goto 2BHI
if %1.==2BLO. goto 2BLO

REM 3-Byte Addressing
if %1.==3bhi. goto 3BHI
if %1.==3blo. goto 3BLO
if %1.==3BHI. goto 3BHI
if %1.==3BLO. goto 3BLO

REM 4-Byte Addressing
if %1.==4bhi. goto 4BHI
if %1.==4blo. goto 4BLO
if %1.==4BHI. goto 4BHI
if %1.==4BLO. goto 4BLO

REM 2-Byte Addressing HI is Default
goto 2BHI

REM
REM 2-Byte HILO Order Assemble and Scan
REM
:2BHI
if %2.==. goto 2BHIASCHECK
del out.lst
%2.exe -glxff out asmt2bhi.asm
asxscn.exe out.lst
goto EXIT

:2BHIASCHECK
del out.lst
ascheck.exe -glxuff out hilo.asm a16bit.asm asmt2bhi.asm
asxscn.exe out.lst
goto EXIT

REM
REM 2-Byte LOHI Order Assemble and Scan
REM
:2BLO
if %2.==. goto 2BLOASCHECK
del out.lst
%2.exe -glxff out asmt2blo.asm
asxscn.exe out.lst
goto EXIT

:2BLOASCHECK
del out.lst
ascheck.exe -glxuff out lohi.asm a16bit.asm asmt2blo.asm
asxscn.exe out.lst
goto EXIT

REM
REM 3-Byte HILO Order Assemble and Scan
REM
:3BHI
if %2.==. goto 3BHIASCHECK
del out.lst
%2.exe -glxff out asmt3bhi.asm
asxscn.exe -3 out.lst
goto EXIT

:3BHIASCHECK
del out.lst
ascheck.exe -glxuff out hilo.asm a24bit.asm asmt3bhi.asm
asxscn.exe -3 out.lst
goto EXIT

REM
REM 3-Byte LOHI Order Assemble and Scan
REM
:3BLO
if %2.==. goto 3BLOASCHECK
del out.lst
%2.exe -glxff out asmt3blo.asm
asxscn.exe -3 out.lst
goto EXIT

:3BLOASCHECK
del out.lst
ascheck.exe -glxuff out lohi.asm a24bit.asm asmt3blo.asm
asxscn.exe -3 out.lst
goto EXIT

REM
REM 4-Byte HILO Order Assemble and Scan
REM
:4BHI
if %2.==. goto 4BHIASCHECK
del out.lst
%2.exe -glxff out asmt4bhi.asm
asxscn.exe -4 out.lst
goto EXIT

:4BHIASCHECK
del out.lst
ascheck.exe -glxuff out hilo.asm a32bit.asm asmt4bhi.asm
asxscn.exe -4 out.lst
goto EXIT

REM
REM 4-Byte LOHI Order Assemble and Scan
REM
:4BLO
if %2.==. goto 4BLOASCHECK
del out.lst
%2.exe -glxff out asmt4blo.asm
asxscn.exe -4 out.lst
goto EXIT

:4BLOASCHECK
del out.lst
ascheck.exe -glxuff out lohi.asm a32bit.asm asmt4blo.asm
asxscn.exe -4 out.lst
goto EXIT

:HELP
echo.
echo Valid arguments are:
echo --------  -----------------------       ---------------------------
echo 2BHI      2-Byte High Order First       optional - asxxxx assembler
echo 2BLO      2-Byte Low  Order First       optional - asxxxx assembler
echo.
echo 3BHI      3-Byte High Order First       optional - asxxxx assembler
echo 3BLO      3-Byte Low  Order First       optional - asxxxx assembler
echo.
echo 4BHI      4-Byte High Order First       optional - asxxxx assembler
echo 4BLO      4-Byte Low  Order First       optional - asxxxx assembler
echo --------  -----------------------       ---------------------------
echo.
echo Default Test Assembler is ascheck
echo.
goto EXIT

:EXIT
