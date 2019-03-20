# Microsoft Developer Studio Generated NMAKE File, Based on as6809.dsp
!IF "$(CFG)" == ""
CFG=as6809 - Win32 Debug
!MESSAGE No configuration specified. Defaulting to as6809 - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "as6809 - Win32 Release" && "$(CFG)" != "as6809 - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "as6809.mak" CFG="as6809 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "as6809 - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "as6809 - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "as6809 - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release

ALL : "..\..\exe\as6809.exe"


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
	-@erase "$(INTDIR)\m09adr.obj"
	-@erase "$(INTDIR)\m09ext.obj"
	-@erase "$(INTDIR)\m09mch.obj"
	-@erase "$(INTDIR)\m09pst.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "..\..\exe\as6809.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /ML /W3 /GX /O2 /I "..\..\..\..\asxxsrc" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\as6809.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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

RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\as6809.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\as6809.pdb" /machine:I386 /out:"..\..\exe\as6809.exe" 
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
	"$(INTDIR)\m09adr.obj" \
	"$(INTDIR)\m09ext.obj" \
	"$(INTDIR)\m09mch.obj" \
	"$(INTDIR)\m09pst.obj"

"..\..\exe\as6809.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "as6809 - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "..\..\exe\as6809.exe"


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
	-@erase "$(INTDIR)\m09adr.obj"
	-@erase "$(INTDIR)\m09ext.obj"
	-@erase "$(INTDIR)\m09mch.obj"
	-@erase "$(INTDIR)\m09pst.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\as6809.pdb"
	-@erase "..\..\exe\as6809.exe"
	-@erase "..\..\exe\as6809.ilk"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /ML /W3 /Gm /GX /ZI /O2 /I "..\..\..\..\asxxsrc" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\as6809.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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

RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\as6809.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\as6809.pdb" /debug /machine:I386 /out:"..\..\exe\as6809.exe" /pdbtype:sept 
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
	"$(INTDIR)\m09adr.obj" \
	"$(INTDIR)\m09ext.obj" \
	"$(INTDIR)\m09mch.obj" \
	"$(INTDIR)\m09pst.obj"

"..\..\exe\as6809.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("as6809.dep")
!INCLUDE "as6809.dep"
!ELSE 
!MESSAGE Warning: cannot find "as6809.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "as6809 - Win32 Release" || "$(CFG)" == "as6809 - Win32 Debug"
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


SOURCE=..\..\..\..\as6809\m09adr.c

"$(INTDIR)\m09adr.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\as6809\m09ext.c

"$(INTDIR)\m09ext.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\as6809\m09mch.c

"$(INTDIR)\m09mch.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\as6809\m09pst.c

"$(INTDIR)\m09pst.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

