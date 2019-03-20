# Microsoft Developer Studio Generated NMAKE File, Based on asz8.dsp
!IF "$(CFG)" == ""
CFG=asz8 - Win32 Debug
!MESSAGE No configuration specified. Defaulting to asz8 - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "asz8 - Win32 Release" && "$(CFG)" != "asz8 - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "asz8.mak" CFG="asz8 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "asz8 - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "asz8 - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "asz8 - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release

ALL : "..\..\exe\asz8.exe"


CLEAN :
	-@erase "$(INTDIR)\asdata.obj"
	-@erase "$(INTDIR)\asdbg.obj"
	-@erase "$(INTDIR)\asexpr.obj"
	-@erase "$(INTDIR)\aslex.obj"
	-@erase "$(INTDIR)\aslist.obj"
	-@erase "$(INTDIR)\asmain.obj"
	-@erase "$(INTDIR)\asout.obj"
	-@erase "$(INTDIR)\assubr.obj"
	-@erase "$(INTDIR)\assym.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\z8adr.obj"
	-@erase "$(INTDIR)\z8ext.obj"
	-@erase "$(INTDIR)\z8mch.obj"
	-@erase "$(INTDIR)\z8pst.obj"
	-@erase "..\..\exe\asz8.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /ML /W3 /GX /O2 /I "..\..\..\..\asxxsrc" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\asz8.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /J /FD /c 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\asz8.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\asz8.pdb" /machine:I386 /out:"../../exe/asz8.exe" 
LINK32_OBJS= \
	"$(INTDIR)\asdata.obj" \
	"$(INTDIR)\asdbg.obj" \
	"$(INTDIR)\asexpr.obj" \
	"$(INTDIR)\aslex.obj" \
	"$(INTDIR)\aslist.obj" \
	"$(INTDIR)\asmain.obj" \
	"$(INTDIR)\asout.obj" \
	"$(INTDIR)\assubr.obj" \
	"$(INTDIR)\assym.obj" \
	"$(INTDIR)\z8adr.obj" \
	"$(INTDIR)\z8ext.obj" \
	"$(INTDIR)\z8mch.obj" \
	"$(INTDIR)\z8pst.obj"

"..\..\exe\asz8.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "asz8 - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "..\..\exe\asz8.exe"


CLEAN :
	-@erase "$(INTDIR)\asdata.obj"
	-@erase "$(INTDIR)\asdbg.obj"
	-@erase "$(INTDIR)\asexpr.obj"
	-@erase "$(INTDIR)\aslex.obj"
	-@erase "$(INTDIR)\aslist.obj"
	-@erase "$(INTDIR)\asmain.obj"
	-@erase "$(INTDIR)\asout.obj"
	-@erase "$(INTDIR)\assubr.obj"
	-@erase "$(INTDIR)\assym.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\z8adr.obj"
	-@erase "$(INTDIR)\z8ext.obj"
	-@erase "$(INTDIR)\z8mch.obj"
	-@erase "$(INTDIR)\z8pst.obj"
	-@erase "$(OUTDIR)\asz8.pdb"
	-@erase "..\..\exe\asz8.exe"
	-@erase "..\..\exe\asz8.ilk"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MLd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\asxxsrc" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\asz8.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /J /FD /GZ /c 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\asz8.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\asz8.pdb" /debug /machine:I386 /out:"../../exe/asz8.exe" /pdbtype:sept 
LINK32_OBJS= \
	"$(INTDIR)\asdata.obj" \
	"$(INTDIR)\asdbg.obj" \
	"$(INTDIR)\asexpr.obj" \
	"$(INTDIR)\aslex.obj" \
	"$(INTDIR)\aslist.obj" \
	"$(INTDIR)\asmain.obj" \
	"$(INTDIR)\asout.obj" \
	"$(INTDIR)\assubr.obj" \
	"$(INTDIR)\assym.obj" \
	"$(INTDIR)\z8adr.obj" \
	"$(INTDIR)\z8ext.obj" \
	"$(INTDIR)\z8mch.obj" \
	"$(INTDIR)\z8pst.obj"

"..\..\exe\asz8.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("asz8.dep")
!INCLUDE "asz8.dep"
!ELSE 
!MESSAGE Warning: cannot find "asz8.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "asz8 - Win32 Release" || "$(CFG)" == "asz8 - Win32 Debug"
SOURCE=..\..\..\..\asxxsrc\asdata.c

"$(INTDIR)\asdata.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\asxxsrc\asdbg.c

"$(INTDIR)\asdbg.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\asxxsrc\asexpr.c

"$(INTDIR)\asexpr.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\asxxsrc\aslex.c

"$(INTDIR)\aslex.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\asxxsrc\aslist.c

"$(INTDIR)\aslist.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\asxxsrc\asmain.c

"$(INTDIR)\asmain.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\asxxsrc\asout.c

"$(INTDIR)\asout.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\asxxsrc\assubr.c

"$(INTDIR)\assubr.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\asxxsrc\assym.c

"$(INTDIR)\assym.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\asz8\z8adr.c

"$(INTDIR)\z8adr.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\asz8\z8ext.c

"$(INTDIR)\z8ext.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\asz8\z8mch.c

"$(INTDIR)\z8mch.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\asz8\z8pst.c

"$(INTDIR)\z8pst.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

