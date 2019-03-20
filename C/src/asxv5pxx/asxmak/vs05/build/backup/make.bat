@echo off
REM Note:
REM   This is NOT a real 'make' file, just an alias.
REM
REM This BATCH file assumes PATH does NOT include vcbuild.exe
REM
REM This definition is valid for Visual Studio 2005
REM installed in the default location.
REM
SET VC$BUILD="C:\Program Files\Microsoft Visual Studio 8\VC\vcpackages\vcbuild.exe"
REM

if %1.==/?. goto ERROR
if %1.==. goto ALL
if %1.==all. goto ALL
if %1.==clean. goto EXIT
goto ASXXXX

:ALL
cd as1802
@echo on
%VC$BUILD% /rebuild as1802.vcproj "Release|Win32"
@echo off
cd ..
cd as2650
@echo on
%VC$BUILD% /rebuild as2650.vcproj "Release|Win32"
@echo off
cd ..
cd as430
@echo on
%VC$BUILD% /rebuild as430.vcproj "Release|Win32"
@echo off
cd ..
cd as61860
@echo on
%VC$BUILD% /rebuild as61860.vcproj "Release|Win32"
@echo off
cd ..
cd as6500
@echo on
%VC$BUILD% /rebuild as6500.vcproj "Release|Win32"
@echo off
cd ..
cd as6800
@echo on
%VC$BUILD% /rebuild as6800.vcproj "Release|Win32"
@echo off
cd ..
cd as6801
@echo on
%VC$BUILD% /rebuild as6801.vcproj "Release|Win32"
@echo off
cd ..
cd as6804
@echo on
%VC$BUILD% /rebuild as6804.vcproj "Release|Win32"
@echo off
cd ..
cd as6805
@echo on
%VC$BUILD% /rebuild as6805.vcproj "Release|Win32"
@echo off
cd ..
cd as6808
@echo on
%VC$BUILD% /rebuild as6808.vcproj "Release|Win32"
@echo off
cd ..
cd as6809
@echo on
%VC$BUILD% /rebuild as6809.vcproj "Release|Win32"
@echo off
cd ..
cd as6811
@echo on
%VC$BUILD% /rebuild as6811.vcproj "Release|Win32"
@echo off
cd ..
cd as6812
@echo on
%VC$BUILD% /rebuild as6812.vcproj "Release|Win32"
@echo off
cd ..
cd as6816
@echo on
%VC$BUILD% /rebuild as6816.vcproj "Release|Win32"
@echo off
cd ..
cd as740
@echo on
%VC$BUILD% /rebuild as740.vcproj "Release|Win32"
@echo off
cd ..
cd as8048
@echo on
%VC$BUILD% /rebuild as8048.vcproj "Release|Win32"
@echo off
cd ..
cd as8051
@echo on
%VC$BUILD% /rebuild as8051.vcproj "Release|Win32"
@echo off
cd ..
cd as8085
@echo on
%VC$BUILD% /rebuild as8085.vcproj "Release|Win32"
@echo off
cd ..
cd as8xcxxx
@echo on
%VC$BUILD% /rebuild as8xcxxx.vcproj "Release|Win32"
@echo off
cd ..
cd asavr
@echo on
%VC$BUILD% /rebuild asavr.vcproj "Release|Win32"
@echo off
cd ..
cd ascheck
@echo on
%VC$BUILD% /rebuild ascheck.vcproj "Release|Win32"
@echo off
cd ..
cd asez80
@echo on
%VC$BUILD% /rebuild asez80.vcproj "Release|Win32"
@echo off
cd ..
cd asf2mc8
@echo on
%VC$BUILD% /rebuild asf2mc8.vcproj "Release|Win32"
@echo off
cd ..
cd asgb
@echo on
%VC$BUILD% /rebuild asgb.vcproj "Release|Win32"
@echo off
cd ..
cd ash8
@echo on
%VC$BUILD% /rebuild ash8.vcproj "Release|Win32"
@echo off
cd ..
cd asm8c
@echo on
%VC$BUILD% /rebuild asm8c.vcproj "Release|Win32"
@echo off
cd ..
cd aspic
@echo on
%VC$BUILD% /rebuild aspic.vcproj "Release|Win32"
@echo off
cd ..
cd asrab
@echo on
%VC$BUILD% /rebuild asrab.vcproj "Release|Win32"
@echo off
cd ..
cd asscmp
@echo on
%VC$BUILD% /rebuild asscmp.vcproj "Release|Win32"
@echo off
cd ..
cd asz8
@echo on
%VC$BUILD% /rebuild asz8.vcproj "Release|Win32"
@echo off
cd ..
cd asz80
@echo on
%VC$BUILD% /rebuild asz80.vcproj "Release|Win32"
@echo off
cd ..
cd aslink
@echo on
%VC$BUILD% /rebuild aslink.vcproj "Release|Win32"
@echo off
cd ..
cd asxcnv
@echo on
%VC$BUILD% /rebuild asxcnv.vcproj "Release|Win32"
@echo off
cd ..
cd asxscn
@echo on
%VC$BUILD% /rebuild asxscn.vcproj "Release|Win32"
@echo off
cd ..
cd s19os9
@echo on
%VC$BUILD% /rebuild s19os9.vcproj "Release|Win32"
@echo off
cd ..
goto EXIT

:ASXXXX
cd %1
if not exist %1.vcproj goto ERROR
@echo on
%VC$BUILD% /rebuild %1.vcproj "Release|Win32"
@echo off
cd ..
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

