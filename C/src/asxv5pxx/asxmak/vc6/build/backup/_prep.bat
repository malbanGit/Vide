@echo off
REM _PREP.BAT
REM   Remove all build files.
REM

if %1.==/?. goto ERROR
if %1.==. goto ALL
if %1.==all. goto ALL
goto ASXXXX

:ALL
cd as1802
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as2650
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as430
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as61860
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as6500
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as6800
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as6801
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as6804
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as6805
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as6808
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as6809
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as6811
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as6812
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as6816
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as740
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as8048
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as8051
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as8085
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd as8xcxxx
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd asavr
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd ascheck
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd asez80
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd asf2mc8
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd asgb
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd ash8
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd asm8c
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd aspic
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd asrab
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd asscmp
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd asz8
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd asz80
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd aslink
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd asxcnv
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd asxscn
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
cd s19os9
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
goto EXIT

:ASXXXX
cd %1
if not exist %1.dsw goto ERROR
del *.log
del *.opt
del *.plg
del /q .\release\*.*
cd ..
goto EXIT

:ERROR
echo.
echo Clears the build files for the ASxxxx Assemblers, Linker, and Utilities.
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

