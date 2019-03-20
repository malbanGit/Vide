####################################################################
#  Makefile
#		'Turbo C++ make'  Version
#		=========================
#
#   17  January  2009
#
####################################################################

ASXXXX =	as1802		\
		as2650		\
		as430		\
		as61860		\
		as6500		\
		as6800		\
		as6801		\
		as6804		\
		as6805		\
		as6808		\
		as6809		\
		as6811		\
		as6812		\
		as6816		\
		as740		\
		as8048		\
		as8051		\
		as8085		\
		as8xcxxx	\
		asavr		\
		ascheck		\
		asez80		\
		asf2mc8		\
		asgb		\
		ash8		\
		asm8c		\
		aspic		\
		asrab		\
		asscmp		\
		asz8		\
		asz80		\
		aslink		\
		asxcnv		\
		asxscn		\
		s19os9

####################################################################
# Special
####################################################################

all:	$(ASXXXX)

clean:
	_clean.bat


####################################################################
# Option Definitions
####################################################################
#
# Memory Model Options:		TCC	TLINK
#				----------------------------------------------
# Tiny Model	(DS == SS)	-mt	C0T.OBJ		MATHS.LIB	CS.LIB
# Tiny Model	(DS != SS)	-mt!	C0T.OBJ		MATHS.LIB	CS.LIB
# Small Model	(DS == SS)	-ms	C0S.OBJ		MATHS.LIB	CS.LIB
# Small Model	(DS != SS)	-ms!	C0S.OBJ		MATHS.LIB	CS.LIB
# Medium Model	(DS == SS)	-mm	C0M.OBJ		MATHM.LIB	CM.LIB
# Medium Model	(DS != SS)	-mm!	C0M.OBJ		MATHM.LIB	CM.LIB
# Compact Model			-mc	C0C.OBJ		MATHC.LIB	CC.LIB
# Large Model			-ml	C0L.OBJ		MATHL.LIB	CL.LIB
# Huge Model			-mh	C0H.OBJ		MATHH.LIB	CH.LIB
#
# Common TCC Options:
#
#	-1-	8088/8086 instructions
#	-A	ANSI Keyords
#	-c	Compile to obj only
#	-K	Default character type is unsigned
#	-K-	Default character type is signed
#	-w	Display Warnings ON
#
CC=		TCC
CCOPT=		-c -1- -w -ml
CCFLAGS=	-A -K $(CCOPT)

# Common TLINK Options:
#
#	/c	Case is significant in symbols.
#	/i	Initializes all segments.
#	/L	Specify library search paths.
#	/s	Creates detailed map of segments.
#	/v	Include full symbolic debug information.
#	/x	Donot create map file.
#
LD=		TLINK
LIBPATH =	C:\TC\LIB
LDFLAGS=	/x/i/c/L$(LIBPATH)
STARTUP=	C0L.OBJ
LIB=		EMU.LIB MATHL.LIB CL.LIB


####################################################################
# ASXXXX Directories
####################################################################

#  Set ASXBAS relative to this make file.

ASXBAS=		..\..\..

SRCASX=		$(ASXBAS)\asxxsrc
SRCLNK=		$(ASXBAS)\linksrc
SRCMISC=	$(ASXBAS)\asxxmisc
SRCS19OS9=	$(ASXBAS)\s19os9

DSTEXE=		..\exe

SRC1802=	$(ASXBAS)\as1802
SRC2650=	$(ASXBAS)\as2650
SRC430=		$(ASXBAS)\as430
SRC61860=	$(ASXBAS)\as61860
SRC6500=	$(ASXBAS)\as6500
SRC6800=	$(ASXBAS)\as6800
SRC6801=	$(ASXBAS)\as6801
SRC6804=	$(ASXBAS)\as6804
SRC6805=	$(ASXBAS)\as6805
SRC6808=	$(ASXBAS)\as6808
SRC6809=	$(ASXBAS)\as6809
SRC6811=	$(ASXBAS)\as6811
SRC6812=	$(ASXBAS)\as6812
SRC6816=	$(ASXBAS)\as6816
SRC740=		$(ASXBAS)\as740
SRC8048=	$(ASXBAS)\as8048
SRC8051=	$(ASXBAS)\as8051
SRC8085=	$(ASXBAS)\as8085
SRC8XCXXX=	$(ASXBAS)\as8xcxxx
SRCAVR=		$(ASXBAS)\asavr
SRCCHECK=	$(ASXBAS)\ascheck
SRCEZ80=	$(ASXBAS)\asez80
SRCF2MC8=	$(ASXBAS)\asf2mc8
SRCGB=		$(ASXBAS)\asgb
SRCH8=		$(ASXBAS)\ash8
SRCM8C=		$(ASXBAS)\asm8c
SRCPIC=		$(ASXBAS)\aspic
SRCRAB=		$(ASXBAS)\asrab
SRCSCMP=	$(ASXBAS)\asscmp
SRCZ8=		$(ASXBAS)\asz8
SRCZ80=		$(ASXBAS)\asz80


####################################################################
# ASXXXX ASSEMBLER BASE FILES
####################################################################

ASXX =		asmain.obj asmcro.obj asdata.obj aslex.obj	\
		asexpr.obj assym.obj assubr.obj asdbg.obj	\
		aslist.obj asout.obj

asmain.obj:	$(SRCASX)\asmain.c $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) $(SRCASX)\asmain.c $<
asmcro.obj:	$(SRCASX)\asmcro.c $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) $(SRCASX)\asmcro.c $<
asdata.obj:	$(SRCASX)\asdata.c $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) $(SRCASX)\asdata.c $<
aslex.obj:	$(SRCASX)\aslex.c  $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) $(SRCASX)\aslex.c  $<
asexpr.obj:	$(SRCASX)\asexpr.c $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) $(SRCASX)\asexpr.c $<
assym.obj:	$(SRCASX)\assym.c  $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) $(SRCASX)\assym.c  $<
assubr.obj:	$(SRCASX)\assubr.c $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) $(SRCASX)\assubr.c $<
asdbg.obj:	$(SRCASX)\asdbg.c $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) $(SRCASX)\asdbg.c  $<
aslist.obj:	$(SRCASX)\aslist.c $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) $(SRCASX)\aslist.c $<
asout.obj:	$(SRCASX)\asout.c $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) $(SRCASX)\asout.c  $<


####################################################################
# AS1802
####################################################################

AS1802 =	1802pst.obj 1802mch.obj

1802pst.obj:	$(SRC1802)\1802pst.c $(SRC1802)\1802.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC1802) -I$(SRCMISC) $(SRC1802)\1802pst.c $<
1802mch.obj:	$(SRC1802)\1802mch.c $(SRC1802)\1802.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC1802) -I$(SRCMISC) $(SRC1802)\1802mch.c $<

as1802:	$(ASXX) $(AS1802)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS1802)
$(DSTEXE)\as1802
as1802
$(LIB)
!


####################################################################
# AS2650
####################################################################

AS2650 =	s26pst.obj s26mch.obj s26adr.obj

s26pst.obj:	$(SRC2650)\s26pst.c $(SRC2650)\s2650.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC2650) -I$(SRCMISC) $(SRC2650)\s26pst.c $<
s26mch.obj:	$(SRC2650)\s26mch.c $(SRC2650)\s2650.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC2650) -I$(SRCMISC) $(SRC2650)\s26mch.c $<
s26adr.obj:	$(SRC2650)\s26adr.c $(SRC2650)\s2650.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC2650) -I$(SRCMISC) $(SRC2650)\s26adr.c $<

as2650:	$(ASXX) $(AS2650)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS2650)
$(DSTEXE)\as2650
as2650
$(LIB)
!


####################################################################
# AS430
####################################################################

AS430 =		m430adr.obj m430pst.obj m430mch.obj

m430adr.obj:	$(SRC430)\m430adr.c $(SRC430)\m430.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC430) -I$(SRCMISC) $(SRC430)\m430adr.c $<
m430pst.obj:	$(SRC430)\m430pst.c $(SRC430)\m430.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC430) -I$(SRCMISC) $(SRC430)\m430pst.c $<
m430mch.obj:	$(SRC430)\m430mch.c $(SRC430)\m430.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC430) -I$(SRCMISC) $(SRC430)\m430mch.c $<

as430:		$(ASXX) $(AS430)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS430)
$(DSTEXE)\as430
as430
$(LIB)
!


####################################################################
# AS61860
####################################################################

AS61860 =	s6186pst.obj s6186mch.obj s6186adr.obj

s6186pst.obj:	$(SRC61860)\s6186pst.c $(SRC61860)\s61860.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC61860) -I$(SRCMISC) $(SRC61860)\s6186pst.c $<
s6186mch.obj:	$(SRC61860)\s6186mch.c $(SRC61860)\s61860.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC61860) -I$(SRCMISC) $(SRC61860)\s6186mch.c $<
s6186adr.obj:	$(SRC61860)\s6186adr.c $(SRC61860)\s61860.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC61860) -I$(SRCMISC) $(SRC61860)\s6186adr.c $<

as61860:	$(ASXX) $(AS61860)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS61860)
$(DSTEXE)\as61860
as61860
$(LIB)
!


####################################################################
# AS6500
####################################################################

AS6500 =	r65pst.obj r65mch.obj r65adr.obj

r65pst.obj:	$(SRC6500)\r65pst.c $(SRC6500)\r6500.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6500) -I$(SRCMISC) $(SRC6500)\r65pst.c $<
r65mch.obj:	$(SRC6500)\r65mch.c $(SRC6500)\r6500.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6500) -I$(SRCMISC) $(SRC6500)\r65mch.c $<
r65adr.obj:	$(SRC6500)\r65adr.c $(SRC6500)\r6500.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6500) -I$(SRCMISC) $(SRC6500)\r65adr.c $<

as6500:		$(ASXX) $(AS6500)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS6500)
$(DSTEXE)\as6500
as6500
$(LIB)
!


####################################################################
# AS6800
####################################################################

AS6800 =	m00pst.obj m00mch.obj m00adr.obj

m00pst.obj:	$(SRC6800)\m00pst.c $(SRC6800)\m6800.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6800) -I$(SRCMISC) $(SRC6800)\m00pst.c $<
m00mch.obj:	$(SRC6800)\m00mch.c $(SRC6800)\m6800.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6800) -I$(SRCMISC) $(SRC6800)\m00mch.c $<
m00adr.obj:	$(SRC6800)\m00adr.c $(SRC6800)\m6800.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6800) -I$(SRCMISC) $(SRC6800)\m00adr.c $<

as6800:		$(ASXX) $(AS6800)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS6800)
$(DSTEXE)\as6800
as6800
$(LIB)
!


####################################################################
# AS6801
####################################################################

AS6801 =	m01pst.obj m01mch.obj m01adr.obj

m01pst.obj:	$(SRC6801)\m01pst.c $(SRC6801)\m6801.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6801) -I$(SRCMISC) $(SRC6801)\m01pst.c $<
m01mch.obj:	$(SRC6801)\m01mch.c $(SRC6801)\m6801.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6801) -I$(SRCMISC) $(SRC6801)\m01mch.c $<
m01adr.obj:	$(SRC6801)\m01adr.c $(SRC6801)\m6801.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6801) -I$(SRCMISC) $(SRC6801)\m01adr.c $<

as6801:		$(ASXX) $(AS6801)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS6801)
$(DSTEXE)\as6801
as6801
$(LIB)
!


####################################################################
# AS6804
####################################################################

AS6804 =	m04pst.obj m04mch.obj m04adr.obj

m04pst.obj:	$(SRC6804)\m04pst.c $(SRC6804)\m6804.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6804) -I$(SRCMISC) $(SRC6804)\m04pst.c $<
m04mch.obj:	$(SRC6804)\m04mch.c $(SRC6804)\m6804.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6804) -I$(SRCMISC) $(SRC6804)\m04mch.c $<
m04adr.obj:	$(SRC6804)\m04adr.c $(SRC6804)\m6804.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6804) -I$(SRCMISC) $(SRC6804)\m04adr.c $<

as6804:		$(ASXX) $(AS6804)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS6804)
$(DSTEXE)\as6804
as6804
$(LIB)
!


####################################################################
# AS6805
####################################################################

AS6805 =	m05pst.obj m05mch.obj m05adr.obj

m05pst.obj:	$(SRC6805)\m05pst.c $(SRC6805)\m6805.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6805) -I$(SRCMISC) $(SRC6805)\m05pst.c $<
m05mch.obj:	$(SRC6805)\m05mch.c $(SRC6805)\m6805.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6805) -I$(SRCMISC) $(SRC6805)\m05mch.c $<
m05adr.obj:	$(SRC6805)\m05adr.c $(SRC6805)\m6805.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6805) -I$(SRCMISC) $(SRC6805)\m05adr.c $<

as6805:	$(ASXX) $(AS6805)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS6805)
$(DSTEXE)\as6805
as6805
$(LIB)
!


####################################################################
# AS6808
####################################################################

AS6808 =	m08pst.obj m08mch.obj m08adr.obj

m08pst.obj:	$(SRC6808)\m08pst.c $(SRC6808)\m6808.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6808) -I$(SRCMISC) $(SRC6808)\m08pst.c $<
m08mch.obj:	$(SRC6808)\m08mch.c $(SRC6808)\m6808.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6808) -I$(SRCMISC) $(SRC6808)\m08mch.c $<
m08adr.obj:	$(SRC6808)\m08adr.c $(SRC6808)\m6808.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6808) -I$(SRCMISC) $(SRC6808)\m08adr.c $<

as6808:		$(ASXX) $(AS6808)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS6808)
$(DSTEXE)\as6808
as6808
$(LIB)
!


####################################################################
# AS6809
####################################################################

AS6809 =	m09pst.obj m09mch.obj m09adr.obj

m09pst.obj:	$(SRC6809)\m09pst.c $(SRC6809)\m6809.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6809) -I$(SRCMISC) $(SRC6809)\m09pst.c $<
m09mch.obj:	$(SRC6809)\m09mch.c $(SRC6809)\m6809.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6809) -I$(SRCMISC) $(SRC6809)\m09mch.c $<
m09adr.obj:	$(SRC6809)\m09adr.c $(SRC6809)\m6809.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6809) -I$(SRCMISC) $(SRC6809)\m09adr.c $<

as6809:		$(ASXX) $(AS6809)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS6809)
$(DSTEXE)\as6809
as6809
$(LIB)
!


####################################################################
# AS6811
####################################################################

AS6811 =	m11pst.obj m11mch.obj m11adr.obj 

m11pst.obj:	$(SRC6811)\m11pst.c $(SRC6811)\m6811.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6811) -I$(SRCMISC) $(SRC6811)\m11pst.c $<
m11mch.obj:	$(SRC6811)\m11mch.c $(SRC6811)\m6811.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6811) -I$(SRCMISC) $(SRC6811)\m11mch.c $<
m11adr.obj:	$(SRC6811)\m11adr.c $(SRC6811)\m6811.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6811) -I$(SRCMISC) $(SRC6811)\m11adr.c $<

as6811:		$(ASXX) $(AS6811)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS6811)
$(DSTEXE)\as6811
as6811
$(LIB)
!


####################################################################
# AS6812
####################################################################

AS6812 =	m12pst.obj m12mch.obj m12adr.obj 

m12pst.obj:	$(SRC6812)\m12pst.c $(SRC6812)\m6812.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6812) -I$(SRCMISC) $(SRC6812)\m12pst.c $<
m12mch.obj:	$(SRC6812)\m12mch.c $(SRC6812)\m6812.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6812) -I$(SRCMISC) $(SRC6812)\m12mch.c $<
m12adr.obj:	$(SRC6812)\m12adr.c $(SRC6812)\m6812.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6812) -I$(SRCMISC) $(SRC6812)\m12adr.c $<

as6812:		$(ASXX) $(AS6812)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS6812)
$(DSTEXE)\as6812
as6812
$(LIB)
!


####################################################################
# AS6816
####################################################################

AS6816 =	m16pst.obj m16mch.obj m16adr.obj 

m16pst.obj:	$(SRC6816)\m16pst.c $(SRC6816)\m6816.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6816) -I$(SRCMISC) $(SRC6816)\m16pst.c $<
m16mch.obj:	$(SRC6816)\m16mch.c $(SRC6816)\m6816.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6816) -I$(SRCMISC) $(SRC6816)\m16mch.c $<
m16adr.obj:	$(SRC6816)\m16adr.c $(SRC6816)\m6816.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC6816) -I$(SRCMISC) $(SRC6816)\m16adr.c $<

as6816:	$(ASXX) $(AS6816)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS6816)
$(DSTEXE)\as6816
as6816
$(LIB)
!


####################################################################
# AS740
####################################################################

AS740 =		m74adr.obj m74pst.obj m74mch.obj

m74adr.obj:	$(SRC740)\m74adr.c $(SRC740)\m740.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC740) -I$(SRCMISC) $(SRC740)\m74adr.c $<
m74pst.obj:	$(SRC740)\m74pst.c $(SRC740)\m740.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC740) -I$(SRCMISC) $(SRC740)\m74pst.c $<
m74mch.obj:	$(SRC740)\m74mch.c $(SRC740)\m740.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC740) -I$(SRCMISC) $(SRC740)\m74mch.c $<

as740:		$(ASXX) $(AS740)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS740)
$(DSTEXE)\as740
as740
$(LIB)
!


####################################################################
# AS8048
####################################################################

AS8048 =	i48pst.obj i48mch.obj i48adr.obj 

i48pst.obj:	$(SRC8048)\i48pst.c $(SRC8048)\i8048.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC8048) -I$(SRCMISC) $(SRC8048)\i48pst.c $<
i48mch.obj:	$(SRC8048)\i48mch.c $(SRC8048)\i8048.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC8048) -I$(SRCMISC) $(SRC8048)\i48mch.c $<
i48adr.obj:	$(SRC8048)\i48adr.c $(SRC8048)\i8048.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC8048) -I$(SRCMISC) $(SRC8048)\i48adr.c $<

as8048:		$(ASXX) $(AS8048)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS8048)
$(DSTEXE)\as8048
as8048
$(LIB)
!


####################################################################
# AS8051
####################################################################

AS8051 =	i51pst.obj i51mch.obj i51adr.obj 

i51pst.obj:	$(SRC8051)\i51pst.c $(SRC8051)\i8051.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC8051) -I$(SRCMISC) $(SRC8051)\i51pst.c $<
i51mch.obj:	$(SRC8051)\i51mch.c $(SRC8051)\i8051.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC8051) -I$(SRCMISC) $(SRC8051)\i51mch.c $<
i51adr.obj:	$(SRC8051)\i51adr.c $(SRC8051)\i8051.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC8051) -I$(SRCMISC) $(SRC8051)\i51adr.c $<

as8051:		$(ASXX) $(AS8051)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS8051)
$(DSTEXE)\as8051
as8051
$(LIB)
!


####################################################################
# AS8085
####################################################################

AS8085 =	i85pst.obj i85mch.obj

i85pst.obj:	$(SRC8085)\i85pst.c $(SRC8085)\i8085.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC8085) -I$(SRCMISC) $(SRC8085)\i85pst.c $<
i85mch.obj:	$(SRC8085)\i85mch.c $(SRC8085)\i8085.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC8085) -I$(SRCMISC) $(SRC8085)\i85mch.c $<

as8085:		$(ASXX) $(AS8085)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS8085)
$(DSTEXE)\as8085
as8085
$(LIB)
!


####################################################################
# AS8XCXXX
####################################################################

AS8XCXXX =	ds8pst.obj ds8mch.obj ds8adr.obj

ds8pst.obj:	$(SRC8XCXXX)\ds8pst.c $(SRC8XCXXX)\ds8.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC8XCXXX) -I$(SRCMISC) $(SRC8XCXXX)\ds8pst.c $<
ds8mch.obj:	$(SRC8XCXXX)\ds8mch.c $(SRC8XCXXX)\ds8.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC8XCXXX) -I$(SRCMISC) $(SRC8XCXXX)\ds8mch.c $<
ds8adr.obj:	$(SRC8XCXXX)\ds8adr.c $(SRC8XCXXX)\ds8.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRC8XCXXX) -I$(SRCMISC) $(SRC8XCXXX)\ds8adr.c $<

as8xcxxx:	$(ASXX) $(AS8XCXXX)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(AS8XCXXX)
$(DSTEXE)\as8xcxxx
as8xcxxx
$(LIB)
!


####################################################################
# ASAVR
####################################################################

ASAVR =		avrpst.obj avrmch.obj avradr.obj

avrpst.obj:	$(SRCAVR)\avrpst.c $(SRCAVR)\avr.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCAVR) -I$(SRCMISC) $(SRCAVR)\avrpst.c $<
avrmch.obj:	$(SRCAVR)\avrmch.c $(SRCAVR)\avr.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCAVR) -I$(SRCMISC) $(SRCAVR)\avrmch.c $<
avradr.obj:	$(SRCAVR)\avradr.c $(SRCAVR)\avr.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCAVR) -I$(SRCMISC) $(SRCAVR)\avradr.c $<

asavr:		$(ASXX) $(ASAVR)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(ASAVR)
$(DSTEXE)\asavr
asavr
$(LIB)
!


####################################################################
# ASCHECK
####################################################################

ASCHECK =		chkpst.obj chkmch.obj chkadr.obj

chkpst.obj:	$(SRCCHECK)\chkpst.c $(SRCCHECK)\chk.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCCHECK) -I$(SRCMISC) $(SRCCHECK)\chkpst.c $<
chkmch.obj:	$(SRCCHECK)\chkmch.c $(SRCCHECK)\chk.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCCHECK) -I$(SRCMISC) $(SRCCHECK)\chkmch.c $<
chkadr.obj:	$(SRCCHECK)\chkadr.c $(SRCCHECK)\chk.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCCHECK) -I$(SRCMISC) $(SRCCHECK)\chkadr.c $<

ascheck:	$(ASXX) $(ASCHECK)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(ASCHECK)
$(DSTEXE)\ascheck
ascheck
$(LIB)
!


####################################################################
# ASEZ80
####################################################################

ASEZ80 =	ez80pst.obj ez80mch.obj ez80adr.obj

ez80pst.obj:	$(SRCEZ80)\ez80pst.c $(SRCEZ80)\ez80.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCEZ80) -I$(SRCMISC) $(SRCEZ80)\ez80pst.c $<
ez80mch.obj:	$(SRCEZ80)\ez80mch.c $(SRCEZ80)\ez80.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCEZ80) -I$(SRCMISC) $(SRCEZ80)\ez80mch.c $<
ez80adr.obj:	$(SRCEZ80)\ez80adr.c $(SRCEZ80)\ez80.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCEZ80) -I$(SRCMISC) $(SRCEZ80)\ez80adr.c $<

asez80:		$(ASXX) $(ASEZ80)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(ASEZ80)
$(DSTEXE)\asez80
asez80
$(LIB)
!


####################################################################
# ASF2MC8
####################################################################

ASF2MC8 =	f8pst.obj f8mch.obj f8adr.obj

f8pst.obj:	$(SRCF2MC8)\f8pst.c $(SRCF2MC8)\f2mc8.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCF2MC8) -I$(SRCMISC) $(SRCF2MC8)\f8pst.c $<
f8mch.obj:	$(SRCF2MC8)\f8mch.c $(SRCF2MC8)\f2mc8.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCF2MC8) -I$(SRCMISC) $(SRCF2MC8)\f8mch.c $<
f8adr.obj:	$(SRCF2MC8)\f8adr.c $(SRCF2MC8)\f2mc8.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCF2MC8) -I$(SRCMISC) $(SRCF2MC8)\f8adr.c $<

asf2mc8:	$(ASXX) $(ASF2MC8)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(ASF2MC8)
$(DSTEXE)\asf2mc8
asf2mc8
$(LIB)
!


####################################################################
# ASGB
####################################################################

ASGB =		gbpst.obj gbmch.obj gbadr.obj

gbpst.obj:	$(SRCGB)\gbpst.c $(SRCGB)\gb.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCGB) -I$(SRCMISC) $(SRCGB)\gbpst.c $<
gbmch.obj:	$(SRCGB)\gbmch.c $(SRCGB)\gb.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCGB) -I$(SRCMISC) $(SRCGB)\gbmch.c $<
gbadr.obj:	$(SRCGB)\gbadr.c $(SRCGB)\gb.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCGB) -I$(SRCMISC) $(SRCGB)\gbadr.c $<

asgb:		$(ASXX) $(ASGB)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(ASGB)
$(DSTEXE)\asgb
asgb
$(LIB)
!


####################################################################
# ASH8
####################################################################

ASH8 =		h8pst.obj h8mch.obj h8adr.obj

h8pst.obj:	$(SRCH8)\h8pst.c $(SRCH8)\h8.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCH8) -I$(SRCMISC) $(SRCH8)\h8pst.c $<
h8mch.obj:	$(SRCH8)\h8mch.c $(SRCH8)\h8.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCH8) -I$(SRCMISC) $(SRCH8)\h8mch.c $<
h8adr.obj:	$(SRCH8)\h8adr.c $(SRCH8)\h8.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCH8) -I$(SRCMISC) $(SRCH8)\h8adr.c $<

ash8:		$(ASXX) $(ASH8)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(ASH8)
$(DSTEXE)\ash8
ash8
$(LIB)
!


####################################################################
# ASM8C
####################################################################

ASM8C =		m8cpst.obj m8cmch.obj m8cadr.obj

m8cpst.obj:	$(SRCM8C)\m8cpst.c $(SRCM8C)\m8c.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCM8C) -I$(SRCMISC) $(SRCM8C)\m8cpst.c $<
m8cmch.obj:	$(SRCM8C)\m8cmch.c $(SRCM8C)\m8c.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCM8C) -I$(SRCMISC) $(SRCM8C)\m8cmch.c $<
m8cadr.obj:	$(SRCM8C)\m8cadr.c $(SRCM8C)\m8c.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCM8C) -I$(SRCMISC) $(SRCM8C)\m8cadr.c $<

asm8c:		$(ASXX) $(ASM8C)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(ASM8C)
$(DSTEXE)\asm8c
asm8c
$(LIB)
!


####################################################################
# ASPIC
####################################################################

ASPIC =		 picpst.obj picmch.obj picadr.obj

picpst.obj:	$(SRCPIC)\picpst.c $(SRCPIC)\pic.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCPIC) -I$(SRCMISC) $(SRCPIC)\picpst.c $<
picmch.obj:	$(SRCPIC)\picmch.c $(SRCPIC)\pic.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCPIC) -I$(SRCMISC) $(SRCPIC)\picmch.c $<
picadr.obj:	$(SRCPIC)\picadr.c $(SRCPIC)\pic.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCPIC) -I$(SRCMISC) $(SRCPIC)\picadr.c $<

aspic:		$(ASXX) $(ASPIC)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(ASPIC)
$(DSTEXE)\aspic
aspic
$(LIB)
!


####################################################################
# ASRAB
####################################################################

ASRAB =		rabpst.obj rabmch.obj rabadr.obj

rabpst.obj:	$(SRCRAB)\rabpst.c $(SRCRAB)\rab.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCRAB) -I$(SRCMISC) $(SRCRAB)\rabpst.c $<
rabmch.obj:	$(SRCRAB)\rabmch.c $(SRCRAB)\rab.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCRAB) -I$(SRCMISC) $(SRCRAB)\rabmch.c $<
rabadr.obj:	$(SRCRAB)\rabadr.c $(SRCRAB)\rab.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCRAB) -I$(SRCMISC) $(SRCRAB)\rabadr.c $<

asrab:		$(ASXX) $(ASRAB)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(ASRAB)
$(DSTEXE)\asrab
asrab
$(LIB)
!


####################################################################
# ASSCMP
####################################################################

ASSCMP =	scmppst.obj scmpmch.obj scmpadr.obj

scmppst.obj:	$(SRCSCMP)\scmppst.c $(SRCSCMP)\scmp.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCSCMP) -I$(SRCMISC) $(SRCSCMP)\scmppst.c $<
scmpmch.obj:	$(SRCSCMP)\scmpmch.c $(SRCSCMP)\scmp.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCSCMP) -I$(SRCMISC) $(SRCSCMP)\scmpmch.c $<
scmpadr.obj:	$(SRCSCMP)\scmpadr.c $(SRCSCMP)\scmp.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCSCMP) -I$(SRCMISC) $(SRCSCMP)\scmpadr.c $<

asscmp:		$(ASXX) $(ASSCMP)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(ASSCMP)
$(DSTEXE)\asscmp
asscmp
$(LIB)
!


####################################################################
# ASZ8
####################################################################

ASZ8 =		z8pst.obj z8mch.obj z8adr.obj

z8pst.obj:	$(SRCZ8)\z8pst.c $(SRCZ8)\z8.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCZ8) -I$(SRCMISC) $(SRCZ8)\z8pst.c $<
z8mch.obj:	$(SRCZ8)\z8mch.c $(SRCZ8)\z8.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCZ8) -I$(SRCMISC) $(SRCZ8)\z8mch.c $<
z8adr.obj:	$(SRCZ8)\z8adr.c $(SRCZ8)\z8.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCZ8) -I$(SRCMISC) $(SRCZ8)\z8adr.c $<

asz8:		$(ASXX) $(ASZ8)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(ASZ8)
$(DSTEXE)\asz8
asz8
$(LIB)
!


####################################################################
# ASZ80
####################################################################

ASZ80 =		z80pst.obj z80mch.obj z80adr.obj

z80pst.obj:	$(SRCZ80)\z80pst.c $(SRCZ80)\z80.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCZ80) -I$(SRCMISC) $(SRCZ80)\z80pst.c $<
z80mch.obj:	$(SRCZ80)\z80mch.c $(SRCZ80)\z80.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCZ80) -I$(SRCMISC) $(SRCZ80)\z80mch.c $<
z80adr.obj:	$(SRCZ80)\z80adr.c $(SRCZ80)\z80.h $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCZ80) -I$(SRCMISC) $(SRCZ80)\z80adr.c $<

asz80:		$(ASXX) $(ASZ80)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXX) +
$(ASZ80)
$(DSTEXE)\asz80
asz80
$(LIB)
!


####################################################################
# ASLINK
####################################################################

ASLINK =	lkmain.obj lkarea.obj lkdata.obj lkeval.obj	\
		lkhead.obj lklex.obj lklibr.obj lklist.obj	\
		lkrloc.obj lkrloc3.obj lkrloc4.obj lksym.obj	\
		lknoice.obj lksdcdb.obj lkbank.obj lkout.obj

lkmain.obj:	$(SRCLNK)\lkmain.c  $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lkmain.c  $<
lkhead.obj:	$(SRCLNK)\lkhead.c  $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lkhead.c  $<
lkarea.obj:	$(SRCLNK)\lkarea.c  $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lkarea.c  $<
lklex.obj:	$(SRCLNK)\lklex.c   $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lklex.c   $<
lksym.obj:	$(SRCLNK)\lksym.c   $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lksym.c   $<
lkeval.obj:	$(SRCLNK)\lkeval.c  $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lkeval.c  $<
lkdata.obj:	$(SRCLNK)\lkdata.c  $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lkdata.c  $<
lklibr.obj:	$(SRCLNK)\lklibr.c  $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lklibr.c  $<
lklist.obj:	$(SRCLNK)\lklist.c  $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lklist.c  $<
lkrloc.obj:	$(SRCLNK)\lkrloc.c  $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lkrloc.c  $<
lkrloc3.obj:	$(SRCLNK)\lkrloc3.c $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lkrloc3.c $<
lkrloc4.obj:	$(SRCLNK)\lkrloc4.c $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lkrloc4.c $<
lknoice.obj:	$(SRCLNK)\lknoice.c $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lknoice.c $<
lksdcdb.obj:	$(SRCLNK)\lksdcdb.c $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lksdcdb.c $<
lkbank.obj:	$(SRCLNK)\lkbank.c  $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lkbank.c  $<
lkout.obj:	$(SRCLNK)\lkout.c   $(SRCLNK)\aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCLNK) $(SRCLNK)\lkout.c   $<

aslink:	$(ASLINK)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASLINK)
$(DSTEXE)\aslink
aslink
$(LIB)
!


####################################################################
# ASXCNV
####################################################################

ASXCNV =	asxxconv.obj

asxxconv.obj:	$(SRCMISC)\asxxconv.c $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) $(SRCMISC)\asxxconv.c $<

asxcnv:		$(ASXCNV)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXCNV)
$(DSTEXE)\asxcnv
asxcnv
$(LIB)
!


####################################################################
# ASXSCN
####################################################################

ASXSCN =	asxxscan.obj

asxxscan.obj:	$(SRCMISC)\asxxscan.c $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) $(SRCMISC)\asxxscan.c $<

asxscn:		$(ASXSCN)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(ASXSCN)
$(DSTEXE)\asxscn
asxscn
$(LIB)
!


####################################################################
# S19OS9
####################################################################

S19OS9 =	s19os9.obj

s19os9.obj:	$(SRCS19OS9)\s19os9.c $(SRCASX)\asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) $(SRCS19OS9)\s19os9.c $<

s19os9:		$(S19OS9)
		$(LD) $(LDFLAGS) @&&!
$(STARTUP) +
$(S19OS9)
$(DSTEXE)\s19os9
s19os9
$(LIB)
!


### end #########################################################
