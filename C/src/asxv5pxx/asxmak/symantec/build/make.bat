@echo off
REM Note:
REM   This is NOT a real 'make' file, just an alias.
REM
REM This BATCH file assumes PATH includes smake.exe
REM

if %1.==/?. goto ERROR
if %1.==. goto ALL
if %1.==all. goto ALL
if %1.==clean. goto CLEAN
goto ASXXXX

:ALL
@echo on
smake /f as1802.mak
smake /f as2650.mak
smake /f as430.mak
smake /f as61860.mak
smake /f as6500.mak
smake /f as6800.mak
smake /f as6801.mak
smake /f as6804.mak
smake /f as6805.mak
smake /f as6808.mak
smake /f as6809.mak
smake /f as6811.mak
smake /f as6812.mak
smake /f as6816.mak
smake /f as740.mak
smake /f as8048.mak
smake /f as8051.mak
smake /f as8085.mak
smake /f as8xcxxx.mak
smake /f asavr.mak
smake /f ascheck.mak
smake /f asez80.mak
smake /f asf2mc8.mak
smake /f asgb.mak
smake /f ash8.mak
smake /f asm8c.mak
smake /f aspic.mak
smake /f asrab.mak
smake /f asscmp.mak
smake /f asz8.mak
smake /f asz80.mak
smake /f aslink.mak
smake /f asxcnv.mak
smake /f asxscn.mak
smake /f s19os9.mak
@echo off
goto EXIT

:ASXXXX
@echo on
smake /f %1.mak
@echo off
goto EXIT

:CLEAN
del ..\exe\*.exe
del *.obj
goto EXIT

:ERROR
echo.
echo make - Compiles the ASxxxx Assemblers, Linker, and Utilities.
echo.
echo Valid arguments are:
echo --------  --------  --------  --------  --------  --------
echo all       ==        'blank'
echo --------  --------  --------  --------  --------  --------
echo as1802    as2650    as430     as740     as61860
echo as6500    as6800    as6801    as6804    as6805
echo as6808    as6809    as6811    as6812    as6816
echo as8048    as8051    as8085    as8xcxxx
echo asz8      asz80     asez80    asgb      asrab
echo ash8      asf2mc8   asm8c     aspic     asavr
echo ascheck   asscmp
echo --------  --------  --------  --------  --------  --------
echo aslink    asxcnv    asxscn    s19os9
echo --------  --------  --------  --------  --------  --------
echo.
goto EXIT

:EXIT

