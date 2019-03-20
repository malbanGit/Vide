@echo off
REM Note:
REM   This is NOT a real 'make' file, just an alias.
REM
REM This BATCH file assumes PATH does NOT include msdev.exe
REM
REM This definition is valid for Visual Studio 6
REM installed in the default location.
REM
SET MS$DEV="C:\Program Files\Microsoft Visual Studio\Common\MSDev98\Bin\msdev.exe"
REM

if %1.==/?. goto ERROR
if %1.==. goto ALL
if %1.==all. goto ALL
if %1.==clean. goto EXIT
goto ASXXXX

:ALL
cd as1802
@echo on
%MS$DEV% as1802.dsw /MAKE "as1802 - Win32 Release" /REBUILD /OUT as1802.log
@echo off
type as1802.log
cd ..
cd as2650
@echo on
%MS$DEV% as2650.dsw /MAKE "as2650 - Win32 Release" /REBUILD /OUT as2650.log
@echo off
type as2650.log
cd ..
cd as430
@echo on
%MS$DEV% as430.dsw /MAKE "as430 - Win32 Release" /REBUILD /OUT as430.log
@echo off
type as430.log
cd ..
cd as61860
@echo on
%MS$DEV% as61860.dsw /MAKE "as61860 - Win32 Release" /REBUILD /OUT as61860.log
@echo off
type as61860.log
cd ..
cd as6500
@echo on
%MS$DEV% as6500.dsw /MAKE "as6500 - Win32 Release" /REBUILD /OUT as6500.log
@echo off
type as6500.log
cd ..
cd as6800
@echo on
%MS$DEV% as6800.dsw /MAKE "as6800 - Win32 Release" /REBUILD /OUT as6800.log
@echo off
type as6800.log
cd ..
cd as6801
@echo on
%MS$DEV% as6801.dsw /MAKE "as6801 - Win32 Release" /REBUILD /OUT as6801.log
@echo off
type as6801.log
cd ..
cd as6804
@echo on
%MS$DEV% as6804.dsw /MAKE "as6804 - Win32 Release" /REBUILD /OUT as6804.log
@echo off
type as6804.log
cd ..
cd as6805
@echo on
%MS$DEV% as6805.dsw /MAKE "as6805 - Win32 Release" /REBUILD /OUT as6805.log
@echo off
type as6805.log
cd ..
cd as6808
@echo on
%MS$DEV% as6808.dsw /MAKE "as6808 - Win32 Release" /REBUILD /OUT as6808.log
@echo off
type as6808.log
cd ..
cd as6809
@echo on
%MS$DEV% as6809.dsw /MAKE "as6809 - Win32 Release" /REBUILD /OUT as6809.log
@echo off
type as6809.log
cd ..
cd as6811
@echo on
%MS$DEV% as6811.dsw /MAKE "as6811 - Win32 Release" /REBUILD /OUT as6811.log
@echo off
type as6811.log
cd ..
cd as6812
@echo on
%MS$DEV% as6812.dsw /MAKE "as6812 - Win32 Release" /REBUILD /OUT as6812.log
@echo off
type as6812.log
cd ..
cd as6816
@echo on
%MS$DEV% as6816.dsw /MAKE "as6816 - Win32 Release" /REBUILD /OUT as6816.log
@echo off
type as6816.log
cd ..
cd as740
@echo on
%MS$DEV% as740.dsw /MAKE "as740 - Win32 Release" /REBUILD /OUT as740.log
@echo off
type as740.log
cd ..
cd as8048
@echo on
%MS$DEV% as8048.dsw /MAKE "as8048 - Win32 Release" /REBUILD /OUT as8048.log
@echo off
type as8048.log
cd ..
cd as8051
@echo on
%MS$DEV% as8051.dsw /MAKE "as8051 - Win32 Release" /REBUILD /OUT as8051.log
@echo off
type as8051.log
cd ..
cd as8085
@echo on
%MS$DEV% as8085.dsw /MAKE "as8085 - Win32 Release" /REBUILD /OUT as8085.log
@echo off
type as8085.log
cd ..
cd as8xcxxx
@echo on
%MS$DEV% as8xcxxx.dsw /MAKE "as8xCxxx - Win32 Release" /REBUILD /OUT as8xcxxx.log
@echo off
type as8xcxxx.log
cd ..
cd asavr
@echo on
%MS$DEV% asavr.dsw /MAKE "asavr - Win32 Release" /REBUILD /OUT asavr.log
@echo off
type asavr.log
cd ..
cd ascheck
@echo on
%MS$DEV% ascheck.dsw /MAKE "ascheck - Win32 Release" /REBUILD /OUT ascheck.log
@echo off
type ascheck.log
cd ..
cd asez80
@echo on
%MS$DEV% asez80.dsw /MAKE "asez80 - Win32 Release" /REBUILD /OUT asez80.log
@echo off
type asez80.log
cd ..
cd asf2mc8
@echo on
%MS$DEV% asf2mc8.dsw /MAKE "asf2mc8 - Win32 Release" /REBUILD /OUT asf2mc8.log
@echo off
type asf2mc8.log
cd ..
cd asgb
@echo on
%MS$DEV% asgb.dsw /MAKE "asgb - Win32 Release" /REBUILD /OUT asgb.log
@echo off
type asgb.log
cd ..
cd ash8
@echo on
%MS$DEV% ash8.dsw /MAKE "ash8 - Win32 Release" /REBUILD /OUT ash8.log
@echo off
type ash8.log
cd ..
cd asm8c
@echo on
%MS$DEV% asm8c.dsw /MAKE "asm8c - Win32 Release" /REBUILD /OUT asm8c.log
@echo off
type asm8c.log
cd ..
cd aspic
@echo on
%MS$DEV% aspic.dsw /MAKE "aspic - Win32 Release" /REBUILD /OUT aspic.log
@echo off
type aspic.log
cd ..
cd asrab
@echo on
%MS$DEV% asrab.dsw /MAKE "asrab - Win32 Release" /REBUILD /OUT asrab.log
@echo off
type asrab.log
cd ..
cd asscmp
@echo on
%MS$DEV% asscmp.dsw /MAKE "asscmp - Win32 Release" /REBUILD /OUT asscmp.log
@echo off
type asscmp.log
cd ..
cd asz8
@echo on
%MS$DEV% asz8.dsw /MAKE "asz8 - Win32 Release" /REBUILD /OUT asz8.log
@echo off
type asz8.log
cd ..
cd asz80
@echo on
%MS$DEV% asz80.dsw /MAKE "asz80 - Win32 Release" /REBUILD /OUT asz80.log
@echo off
type asz80.log
cd ..
cd aslink
@echo on
%MS$DEV% aslink.dsw /MAKE "aslink - Win32 Release" /REBUILD /OUT aslink.log
@echo off
type aslink.log
cd ..
cd asxcnv
@echo on
%MS$DEV% asxcnv.dsw /MAKE "asxcnv - Win32 Release" /REBUILD /OUT asxcnv.log
@echo off
type asxcnv.log
cd ..
cd asxscn
@echo on
%MS$DEV% asxscn.dsw /MAKE "asxscn - Win32 Release" /REBUILD /OUT asxscn.log
@echo off
type asxscn.log
cd ..
cd s19os9
@echo on
%MS$DEV% s19os9.dsw /MAKE "s19os9 - Win32 Release" /REBUILD /OUT s19os9.log
@echo off
type s19os9.log
cd ..
goto EXIT

:ASXXXX
cd %1
if not exist %1.dsw goto ERROR
@echo on
%MS$DEV% %1.dsw /MAKE "%1 - Win32 Release" /REBUILD /OUT %1.log
@echo off
type %1.log
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

