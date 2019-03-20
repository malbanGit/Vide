ORIGIN		= Symantec C++
ORIGIN_VER	= Version 7.20
VERSION		= RELEASE

!IFDEF SUB_DEBUG
DEBUG		= $(SUB_DEBUG)
NDEBUG		= !$(SUB_DEBUG)
!ELSE
DEBUG		= 0
NDEBUG		= 1
!ENDIF

PROJ		= aslink
APPTYPE		= DOS EXE
PROJTYPE	= EXE

CC		= SC
CPP		= SPP
MAKE		= SMAKE
RC		= RCC
HC		= HC31
ASM		= SC
DISASM		= OBJ2ASM
LNK		= LINK
DLLS		= 

HEADERS		= C:\SC\INCLUDE\stdio.h C:\SC\INCLUDE\string.h C:\SC\INCLUDE\alloc.h  \
		C:\SC\INCLUDE\stdlib.h ..\..\..\LINKSRC\aslink.h C:\SC\INCLUDE\setjmp.h 

DEFFILE		= aslink.DEF

!IF $(DEBUG)
OUTPUTDIR	= .
CREATEOUTPUTDIR	=
TARGETDIR	= .
CREATETARGETDIR	=

LIBS		= 

CFLAGS		=  -ms -C -S -3 -a2 -c -g -gd 
LFLAGS		=  /CO /DE /XN
DEFINES		= 
!ELSE
OUTPUTDIR	= ..\build
!IF EXIST (..\build)
CREATEOUTPUTDIR	=
!ELSE
CREATEOUTPUTDIR	= if not exist $(OUTPUTDIR)\*.* md $(OUTPUTDIR)
!ENDIF
TARGETDIR	= ..\exe
!IF EXIST (..\exe)
CREATETARGETDIR	=
!ELSE
CREATETARGETDIR	= if not exist $(TARGETDIR)\*.* md $(TARGETDIR)
!ENDIF

LIBS		= 

CFLAGS		=  -A -r -J -ml -o+time -3 -a2 -c 
LFLAGS		=  /DE /PACKF /XN
DEFINES		= 
!ENDIF

HFLAGS		= $(CFLAGS) 
MFLAGS		= MASTERPROJ=$(PROJ) 
LIBFLAGS	=  /C 
RESFLAGS	=  -32 
DEBUGGERFLAGS	=  
AFLAGS		= $(CFLAGS) 
HELPFLAGS	= 

MODEL		= L

PAR		= PROJS BATS OBJS

RCDEFINES	= 

INCLUDES	= 

INCLUDEDOBJS	= 

OBJS		=  $(OUTPUTDIR)\lkarea.OBJ  $(OUTPUTDIR)\lkbank.OBJ  $(OUTPUTDIR)\lkdata.OBJ  \
		 $(OUTPUTDIR)\lkeval.OBJ  $(OUTPUTDIR)\lkhead.OBJ  $(OUTPUTDIR)\lklex.OBJ  $(OUTPUTDIR)\lklibr.OBJ  \
		 $(OUTPUTDIR)\lklist.OBJ  $(OUTPUTDIR)\lkmain.OBJ  $(OUTPUTDIR)\lknoice.OBJ  $(OUTPUTDIR)\lkout.OBJ  \
		 $(OUTPUTDIR)\lkrloc.OBJ  $(OUTPUTDIR)\lksdcdb.OBJ  $(OUTPUTDIR)\lksym.OBJ  $(OUTPUTDIR)\lkrloc3.OBJ  \
		 $(OUTPUTDIR)\lkrloc4.OBJ 

RCFILES		= 

RESFILES	= 

SYMS		= 

HELPFILES	= 

BATS		= 

.SUFFIXES: .C .CP .CPP .CXX .CC .H .HPP .HXX .COM .EXE .DLL .LIB .RTF .DLG .ASM .RES .RC .OBJ 

.C.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.c

.CPP.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.cpp

.CXX.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.cxx

.CC.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.cc

.CP.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.cp

.H.SYM:
	$(CC) $(HFLAGS) $(DEFINES) $(INCLUDES) -HF -o$(*B).sym $*.h

.HPP.SYM:
	$(CC) $(HFLAGS) $(DEFINES) $(INCLUDES) -HF -o$(*B).sym $*.hpp

.HXX.SYM:
	$(CC) $(HFLAGS) $(DEFINES) $(INCLUDES) -HF -o$(*B).sym $*.hxx

.C.EXP:
	$(CPP) $(CFLAGS) $(DEFINES) $(INCLUDES)   $*.c   -o$*.lst

.CPP.EXP:
	$(CPP) $(CFLAGS) $(DEFINES) $(INCLUDES) $*.cpp -o$*.lst

.CXX.EXP:
	$(CPP) $(CFLAGS) $(DEFINES) $(INCLUDES) $*.cxx -o$*.lst

.CP.EXP:
	$(CPP) $(CFLAGS) $(DEFINES) $(INCLUDES)  $*.cp  -o$*.lst

.CC.EXP:
	$(CPP) $(CFLAGS) $(DEFINES) $(INCLUDES)  $*.cc  -o$*.lst

.ASM.EXP:
	$(CPP) $(CFLAGS) $(DEFINES) $(INCLUDES) $*.asm -o$*.lst

.OBJ.COD:
	$(DISASM) $*.OBJ -c

.OBJ.EXE:
	$(LNK) $(LFLAGS) @$(PROJ).LNK

.RTF.HLP:
	$(HC) $(HELPFLAGS) $*.HPJ

.ASM.OBJ:
	$(ASM) $(AFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.asm

.RC.RES: 
	$(RC) $(RCDEFINES) $(RESFLAGS) $(INCLUDES) $*.rc -o$*.res

.DLG.RES:
	echo ^#include "windows.h" >$$$*.rc
	echo ^IF EXIST "$*.h" >>$$$*.rc
	echo ^#include "$*.h" >>$$$*.rc
	echo ^#include "$*.dlg" >>$$$*.rc
	$(RC) $(RCDEFINES) $(RESFLAGS) $(INCLUDES) $$$*.rc
	-del $*.res
	-ren $$$*.res $*.res



all:	createdir $(PRECOMPILE) $(SYMS) $(OBJS) $(INCLUDEDOBJS) $(POSTCOMPILE) $(TARGETDIR)\$(PROJ).$(PROJTYPE) $(POSTLINK) _done

createdir:
	$(CREATEOUTPUTDIR)
	$(CREATETARGETDIR)

$(TARGETDIR)\$(PROJ).$(PROJTYPE): $(OBJS) $(INCLUDEDOBJS) $(RCFILES) $(RESFILES) $(HELPFILES) 
			-del $(TARGETDIR)\$(PROJ).$(PROJTYPE)
			$(LNK) $(LFLAGS) @$(PROJ).LNK;
			-ren $(TARGETDIR)\$$SCW$$.$(PROJTYPE) $(PROJ).$(PROJTYPE)
			-echo $(TARGETDIR)\$(PROJ).$(PROJTYPE) built

_done:
		-echo $(PROJ).$(PROJTYPE) done

buildall:	clean	all


clean:
		-del $(TARGETDIR)\$$SCW$$.$(PROJTYPE)
		-del $(TARGETDIR)\$(PROJ).CLE
		-del $(OUTPUTDIR)\SCPH.SYM
		-del aslink.dpd
		-del $(OBJS)

cleanres:

res:		cleanres $(RCFILES) all


link:
		$(LNK) $(LFLAGS) @$(PROJ).LNK;
		-del $(TARGETDIR)\$(PROJ).$(PROJTYPE)
		-ren $(TARGETDIR)\$$SCW$$.$(PROJTYPE) $(PROJ).$(PROJTYPE)




!IF EXIST (aslink.dpd)
!INCLUDE aslink.dpd
!ENDIF



$(OUTPUTDIR)\lkarea.OBJ:	..\..\..\LINKSRC\lkarea.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lkarea.obj ..\..\..\LINKSRC\lkarea.c



$(OUTPUTDIR)\lkbank.OBJ:	..\..\..\LINKSRC\lkbank.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lkbank.obj ..\..\..\LINKSRC\lkbank.c



$(OUTPUTDIR)\lkdata.OBJ:	..\..\..\LINKSRC\lkdata.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lkdata.obj ..\..\..\LINKSRC\lkdata.c



$(OUTPUTDIR)\lkeval.OBJ:	..\..\..\LINKSRC\lkeval.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lkeval.obj ..\..\..\LINKSRC\lkeval.c



$(OUTPUTDIR)\lkhead.OBJ:	..\..\..\LINKSRC\lkhead.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lkhead.obj ..\..\..\LINKSRC\lkhead.c



$(OUTPUTDIR)\lklex.OBJ:	..\..\..\LINKSRC\lklex.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lklex.obj ..\..\..\LINKSRC\lklex.c



$(OUTPUTDIR)\lklibr.OBJ:	..\..\..\LINKSRC\lklibr.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lklibr.obj ..\..\..\LINKSRC\lklibr.c



$(OUTPUTDIR)\lklist.OBJ:	..\..\..\LINKSRC\lklist.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lklist.obj ..\..\..\LINKSRC\lklist.c



$(OUTPUTDIR)\lkmain.OBJ:	..\..\..\LINKSRC\lkmain.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lkmain.obj ..\..\..\LINKSRC\lkmain.c



$(OUTPUTDIR)\lknoice.OBJ:	..\..\..\LINKSRC\lknoice.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lknoice.obj ..\..\..\LINKSRC\lknoice.c



$(OUTPUTDIR)\lkout.OBJ:	..\..\..\LINKSRC\lkout.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lkout.obj ..\..\..\LINKSRC\lkout.c



$(OUTPUTDIR)\lkrloc.OBJ:	..\..\..\LINKSRC\lkrloc.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lkrloc.obj ..\..\..\LINKSRC\lkrloc.c



$(OUTPUTDIR)\lksdcdb.OBJ:	..\..\..\LINKSRC\lksdcdb.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lksdcdb.obj ..\..\..\LINKSRC\lksdcdb.c



$(OUTPUTDIR)\lksym.OBJ:	..\..\..\LINKSRC\lksym.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lksym.obj ..\..\..\LINKSRC\lksym.c



$(OUTPUTDIR)\lkrloc3.OBJ:	..\..\..\LINKSRC\lkrloc3.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lkrloc3.obj ..\..\..\LINKSRC\lkrloc3.c



$(OUTPUTDIR)\lkrloc4.OBJ:	..\..\..\LINKSRC\lkrloc4.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$(OUTPUTDIR)\lkrloc4.obj ..\..\..\LINKSRC\lkrloc4.c




