####################################################################
#  Makefile
#		DJGPP V02.03  'GNU make' Version
#		================================
#
#   16  January  2009		GCC 4.0.1 / make 3.79.1
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
		asxscn		\
		asxcnv		\
		s19os9
	
####################################################################
# Option Definitions
####################################################################

CC=		gcc
CCOPT=		-O3
CCFLAGS=	-Wall -funsigned-char $(CCOPT)

LD=		gcc
LDFLAGS=	-Wall


####################################################################
# ASXXXX Directories
####################################################################

#  Set ASXBAS relative to this make file.

ASXBAS=		../../../

SRCASX=		$(ASXBAS)asxxsrc/
SRCLNK=		$(ASXBAS)linksrc/
SRCMISC=	$(ASXBAS)asxxmisc/
SRCS19OS9=	$(ASXBAS)s19os9/
DSTEXE=		../exe/

SRC1802=	$(ASXBAS)as1802/
SRC2650=	$(ASXBAS)as2650/
SRC430=		$(ASXBAS)as430/
SRC61860=	$(ASXBAS)as61860/
SRC6500=	$(ASXBAS)as6500/
SRC6800=	$(ASXBAS)as6800/
SRC6801=	$(ASXBAS)as6801/
SRC6804=	$(ASXBAS)as6804/
SRC6805=	$(ASXBAS)as6805/
SRC6808=	$(ASXBAS)as6808/
SRC6809=	$(ASXBAS)as6809/
SRC6811=	$(ASXBAS)as6811/
SRC6812=	$(ASXBAS)as6812/
SRC6816=	$(ASXBAS)as6816/
SRC740=		$(ASXBAS)as740/
SRC8048=	$(ASXBAS)as8048/
SRC8051=	$(ASXBAS)as8051/
SRC8085=	$(ASXBAS)as8085/
SRC8xcxxx=	$(ASXBAS)as8xcxxx/
SRCAVR=		$(ASXBAS)asavr/
SRCCHECK=	$(ASXBAS)ascheck/
SRCEZ80=	$(ASXBAS)asez80/
SRCF2MC8=	$(ASXBAS)asf2mc8/
SRCGB=		$(ASXBAS)asgb/
SRCH8=		$(ASXBAS)ash8/
SRCM8C=		$(ASXBAS)asm8c/
SRCPIC=		$(ASXBAS)aspic/
SRCRAB=		$(ASXBAS)asrab/
SRCSCMP=	$(ASXBAS)asscmp/
SRCZ8=		$(ASXBAS)asz8/
SRCZ80=		$(ASXBAS)asz80/


####################################################################
# Special
####################################################################

.PHONY:	all clean prep

all:	$(ASXXXX)

clean:
	rm -f $(ASXXXX)
	rm -f *.o
	rm -f $(DSTEXE)*.exe

prep:
	rm -f $(ASXXXX)
	rm -f *.o


####################################################################
# ASXXXX ASSEMBLER BASE FILES
####################################################################

ASXX =		asmain.o asmcro.o asdata.o aslex.o asexpr.o	\
		assym.o assubr.o asdbg.o aslist.o asout.o

asmain.o :	$(SRCASX)asmain.c $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
asmcro.o :	$(SRCASX)asmcro.c $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
asdata.o :	$(SRCASX)asdata.c $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
aslex.o  :	$(SRCASX)aslex.c  $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
asexpr.o :	$(SRCASX)asexpr.c $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
assym.o  :	$(SRCASX)assym.c  $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
assubr.o :	$(SRCASX)assubr.c $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
asdbg.o :	$(SRCASX)asdbg.c  $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
aslist.o :	$(SRCASX)aslist.c $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
asout.o  :	$(SRCASX)asout.c  $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)


####################################################################
# AS1802
####################################################################

AS1802 =	1802pst.o 1802mch.o

1802pst.o :	$(SRC1802)1802pst.c $(SRC1802)1802.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
1802mch.o :	$(SRC1802)1802mch.c $(SRC1802)1802.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as1802 :	$(ASXX) $(AS1802)
		$(LD) $(LDFLAGS) -o as1802 $(ASXX) $(AS1802)
		mv as1802.exe $(DSTEXE)as1802.exe
		strip $(DSTEXE)as1802.exe


####################################################################
# AS2650
####################################################################

AS2650 =		s26adr.o s26pst.o s26mch.o

s26adr.o :	$(SRC2650)s26adr.c $(SRC2650)s2650.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
s26pst.o :	$(SRC2650)s26pst.c $(SRC2650)s2650.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
s26mch.o :	$(SRC2650)s26mch.c $(SRC2650)s2650.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as2650 :		$(ASXX) $(AS2650)
		$(LD) $(LDFLAGS) -o as2650 $(ASXX) $(AS2650)
		mv as2650.exe $(DSTEXE)as2650.exe
		strip $(DSTEXE)as2650.exe


####################################################################
# AS430
####################################################################

AS430 =		m430adr.o m430pst.o m430mch.o

m430adr.o :	$(SRC430)m430adr.c $(SRC430)m430.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m430pst.o :	$(SRC430)m430pst.c $(SRC430)m430.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m430mch.o :	$(SRC430)m430mch.c $(SRC430)m430.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as430 :		$(ASXX) $(AS430)
		$(LD) $(LDFLAGS) -o as430 $(ASXX) $(AS430)
		mv as430.exe $(DSTEXE)as430.exe
		strip $(DSTEXE)as430.exe


####################################################################
# AS61860
####################################################################

AS61860 =	s6186pst.o s6186mch.o s6186adr.o

s6186pst.o :	$(SRC61860)s6186pst.c $(SRC61860)s61860.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
s6186mch.o :	$(SRC61860)s6186mch.c $(SRC61860)s61860.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
s6186adr.o :	$(SRC61860)s6186adr.c $(SRC61860)s61860.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as61860 :	$(ASXX) $(AS61860)
		$(LD) $(LDFLAGS) -o as61860 $(ASXX) $(AS61860)
		mv as61860.exe $(DSTEXE)as61860.exe
		strip $(DSTEXE)as61860.exe


####################################################################
# AS6500
####################################################################

AS6500 =	r65pst.o r65mch.o r65adr.o

r65pst.o :	$(SRC6500)r65pst.c $(SRC6500)r6500.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
r65mch.o :	$(SRC6500)r65mch.c $(SRC6500)r6500.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
r65adr.o :	$(SRC6500)r65adr.c $(SRC6500)r6500.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as6500 :	$(ASXX) $(AS6500)
		$(LD) $(LDFLAGS) -o as6500 $(ASXX) $(AS6500)
		mv as6500.exe $(DSTEXE)as6500.exe
		strip $(DSTEXE)as6500.exe


####################################################################
# AS6800
####################################################################

AS6800 =	m00pst.o m00mch.o m00adr.o 

m00pst.o :	$(SRC6800)m00pst.c $(SRC6800)m6800.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m00mch.o :	$(SRC6800)m00mch.c $(SRC6800)m6800.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m00adr.o :	$(SRC6800)m00adr.c $(SRC6800)m6800.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as6800 :	$(ASXX) $(AS6800)
		$(LD) $(LDFLAGS) -o as6800 $(ASXX) $(AS6800)
		mv as6800.exe $(DSTEXE)as6800.exe
		strip $(DSTEXE)as6800.exe


####################################################################
# AS6801
####################################################################

AS6801 =	m01pst.o m01mch.o m01adr.o 

m01pst.o :	$(SRC6801)m01pst.c $(SRC6801)m6801.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m01mch.o :	$(SRC6801)m01mch.c $(SRC6801)m6801.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m01adr.o :	$(SRC6801)m01adr.c $(SRC6801)m6801.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as6801 :	$(ASXX) $(AS6801)
		$(LD) $(LDFLAGS) -o as6801 $(ASXX) $(AS6801)
		mv as6801.exe $(DSTEXE)as6801.exe
		strip $(DSTEXE)as6801.exe


####################################################################
# AS6804
####################################################################

AS6804 =	m04pst.o m04mch.o m04adr.o 

m04pst.o :	$(SRC6804)m04pst.c $(SRC6804)m6804.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m04mch.o :	$(SRC6804)m04mch.c $(SRC6804)m6804.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m04adr.o :	$(SRC6804)m04adr.c $(SRC6804)m6804.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as6804 :	$(ASXX) $(AS6804)
		$(LD) $(LDFLAGS) -o as6804 $(ASXX) $(AS6804)
		mv as6804.exe $(DSTEXE)as6804.exe
		strip $(DSTEXE)as6804.exe


####################################################################
# AS6805
####################################################################

AS6805 =	m05pst.o m05mch.o m05adr.o 

m05pst.o :	$(SRC6805)m05pst.c $(SRC6805)m6805.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m05mch.o :	$(SRC6805)m05mch.c $(SRC6805)m6805.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m05adr.o :	$(SRC6805)m05adr.c $(SRC6805)m6805.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as6805 :	$(ASXX) $(AS6805)
		$(LD) $(LDFLAGS) -o as6805 $(ASXX) $(AS6805)
		mv as6805.exe $(DSTEXE)as6805.exe
		strip $(DSTEXE)as6805.exe


####################################################################
# AS6808
####################################################################

AS6808 =	m08pst.o m08mch.o m08adr.o 

m08pst.o :	$(SRC6808)m08pst.c $(SRC6808)m6808.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m08mch.o :	$(SRC6808)m08mch.c $(SRC6808)m6808.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m08adr.o :	$(SRC6808)m08adr.c $(SRC6808)m6808.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as6808 :	$(ASXX) $(AS6808)
		$(LD) $(LDFLAGS) -o as6808 $(ASXX) $(AS6808)
		mv as6808.exe $(DSTEXE)as6808.exe
		strip $(DSTEXE)as6808.exe


####################################################################
# AS6809
####################################################################

AS6809 =	m09pst.o m09mch.o m09adr.o 

m09pst.o :	$(SRC6809)m09pst.c $(SRC6809)m6809.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m09mch.o :	$(SRC6809)m09mch.c $(SRC6809)m6809.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m09adr.o :	$(SRC6809)m09adr.c $(SRC6809)m6809.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as6809 :	$(ASXX) $(AS6809)
		$(LD) $(LDFLAGS) -o as6809 $(ASXX) $(AS6809)
		mv as6809.exe $(DSTEXE)as6809.exe
		strip $(DSTEXE)as6809.exe


####################################################################
# AS6811
####################################################################

AS6811 =	m11pst.o m11mch.o m11adr.o 

m11pst.o :	$(SRC6811)m11pst.c $(SRC6811)m6811.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m11mch.o :	$(SRC6811)m11mch.c $(SRC6811)m6811.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m11adr.o :	$(SRC6811)m11adr.c $(SRC6811)m6811.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as6811 :	$(ASXX) $(AS6811)
		$(LD) $(LDFLAGS) -o as6811 $(ASXX) $(AS6811)
		mv as6811.exe $(DSTEXE)as6811.exe
		strip $(DSTEXE)as6811.exe


####################################################################
# AS6812
####################################################################

AS6812 =	m12pst.o m12mch.o m12adr.o 

m12pst.o :	$(SRC6812)m12pst.c $(SRC6812)m6812.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m12mch.o :	$(SRC6812)m12mch.c $(SRC6812)m6812.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m12adr.o :	$(SRC6812)m12adr.c $(SRC6812)m6812.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as6812 :	$(ASXX) $(AS6812)
		$(LD) $(LDFLAGS) -o as6812 $(ASXX) $(AS6812)
		mv as6812.exe $(DSTEXE)as6812.exe
		strip $(DSTEXE)as6812.exe


####################################################################
# AS6816
####################################################################

AS6816 =	m16pst.o m16mch.o m16adr.o 

m16pst.o :	$(SRC6816)m16pst.c $(SRC6816)m6816.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m16mch.o :	$(SRC6816)m16mch.c $(SRC6816)m6816.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m16adr.o :	$(SRC6816)m16adr.c $(SRC6816)m6816.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as6816 :	$(ASXX) $(AS6816)
		$(LD) $(LDFLAGS) -o as6816 $(ASXX) $(AS6816)
		mv as6816.exe $(DSTEXE)as6816.exe
		strip $(DSTEXE)as6816.exe


####################################################################
# AS740
####################################################################

AS740 =		m74adr.o m74pst.o m74mch.o

m74adr.o :	$(SRC740)m74adr.c $(SRC740)m740.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m74pst.o :	$(SRC740)m74pst.c $(SRC740)m740.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m74mch.o :	$(SRC740)m74mch.c $(SRC740)m740.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as740 :		$(ASXX) $(AS740)
		$(LD) $(LDFLAGS) -o as740 $(ASXX) $(AS740)
		mv as740.exe $(DSTEXE)as740.exe
		strip $(DSTEXE)as740.exe


####################################################################
# AS8048
####################################################################

AS8048 =	i48pst.o i48mch.o i48adr.o 

i48pst.o :	$(SRC8048)i48pst.c $(SRC8048)i8048.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
i48mch.o :	$(SRC8048)i48mch.c $(SRC8048)i8048.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
i48adr.o :	$(SRC8048)i48adr.c $(SRC8048)i8048.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as8048 :	$(ASXX) $(AS8048)
		$(LD) $(LDFLAGS) -o as8048 $(ASXX) $(AS8048)
		mv as8048.exe $(DSTEXE)as8048.exe
		strip $(DSTEXE)as8048.exe


####################################################################
# AS8051
####################################################################

AS8051 =	i51pst.o i51mch.o i51adr.o 

i51pst.o :	$(SRC8051)i51pst.c $(SRC8051)i8051.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
i51mch.o :	$(SRC8051)i51mch.c $(SRC8051)i8051.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
i51adr.o :	$(SRC8051)i51adr.c $(SRC8051)i8051.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as8051 :	$(ASXX) $(AS8051)
		$(LD) $(LDFLAGS) -o as8051 $(ASXX) $(AS8051)
		mv as8051.exe $(DSTEXE)as8051.exe
		strip $(DSTEXE)as8051.exe


####################################################################
# AS8085
####################################################################

AS8085 =	i85pst.o i85mch.o

i85pst.o :	$(SRC8085)i85pst.c $(SRC8085)i8085.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
i85mch.o :	$(SRC8085)i85mch.c $(SRC8085)i8085.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as8085 :	$(ASXX) $(AS8085)
		$(LD) $(LDFLAGS) -o as8085 $(ASXX) $(AS8085)
		mv as8085.exe $(DSTEXE)as8085.exe
		strip $(DSTEXE)as8085.exe


####################################################################
# AS8xcxxx
####################################################################

AS8xcxxx =	ds8pst.o ds8mch.o ds8adr.o

ds8pst.o :	$(SRC8xcxxx)ds8pst.c $(SRC8xcxxx)ds8.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
ds8mch.o :	$(SRC8xcxxx)ds8mch.c $(SRC8xcxxx)ds8.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
ds8adr.o :	$(SRC8xcxxx)ds8adr.c $(SRC8xcxxx)ds8.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

as8xcxxx :	$(ASXX) $(AS8xcxxx)
		$(LD) $(LDFLAGS) -o as8xcxxx $(ASXX) $(AS8xcxxx)
		mv as8xcxxx.exe $(DSTEXE)as8xcxxx.exe
		strip $(DSTEXE)as8xcxxx.exe


####################################################################
# ASAVR
####################################################################

ASAVR =		avrpst.o avrmch.o avradr.o

avrpst.o :	$(SRCAVR)avrpst.c $(SRCAVR)avr.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
avrmch.o :	$(SRCAVR)avrmch.c $(SRCAVR)avr.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
avradr.o :	$(SRCAVR)avradr.c $(SRCAVR)avr.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

asavr :		$(ASXX) $(ASAVR)
		$(LD) $(LDFLAGS) -o asavr $(ASXX) $(ASAVR)
		mv asavr.exe $(DSTEXE)asavr.exe
		strip $(DSTEXE)asavr.exe


####################################################################
# ASCHECK
####################################################################

ASCHECK =		chkpst.o chkmch.o chkadr.o

chkpst.o :	$(SRCCHECK)chkpst.c $(SRCCHECK)chk.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
chkmch.o :	$(SRCCHECK)chkmch.c $(SRCCHECK)chk.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
chkadr.o :	$(SRCCHECK)chkadr.c $(SRCCHECK)chk.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

ascheck :	$(ASXX) $(ASCHECK)
		$(LD) $(LDFLAGS) -o ascheck $(ASXX) $(ASCHECK)
		mv ascheck.exe $(DSTEXE)ascheck.exe
		strip $(DSTEXE)ascheck.exe


####################################################################
# ASEZ80
####################################################################

ASEZ80 =	ez80pst.o ez80mch.o ez80adr.o

ez80pst.o :	$(SRCEZ80)ez80pst.c $(SRCEZ80)ez80.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
ez80mch.o :	$(SRCEZ80)ez80mch.c $(SRCEZ80)ez80.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
ez80adr.o :	$(SRCEZ80)ez80adr.c $(SRCEZ80)ez80.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

asez80 :		$(ASXX) $(ASEZ80)
		$(LD) $(LDFLAGS) -o asez80 $(ASXX) $(ASEZ80)
		mv asez80.exe $(DSTEXE)asez80.exe
		strip $(DSTEXE)asez80.exe


####################################################################
# ASF2MC8
####################################################################

ASF2MC8 =	f8pst.o f8mch.o f8adr.o

f8pst.o :	$(SRCF2MC8)f8pst.c $(SRCF2MC8)f2mc8.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
f8mch.o :	$(SRCF2MC8)f8mch.c $(SRCF2MC8)f2mc8.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
f8adr.o :	$(SRCF2MC8)f8adr.c $(SRCF2MC8)f2mc8.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

asf2mc8 :	$(ASXX) $(ASF2MC8)
		$(LD) $(LDFLAGS) -o asf2mc8 $(ASXX) $(ASF2MC8)
		mv asf2mc8.exe $(DSTEXE)asf2mc8.exe
		strip $(DSTEXE)asf2mc8.exe


####################################################################
# ASGB
####################################################################

ASGB =		gbpst.o gbmch.o gbadr.o

gbpst.o :	$(SRCGB)gbpst.c $(SRCGB)gb.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
gbmch.o :	$(SRCGB)gbmch.c $(SRCGB)gb.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
gbadr.o :	$(SRCGB)gbadr.c $(SRCGB)gb.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

asgb :		$(ASXX) $(ASGB)
		$(LD) $(LDFLAGS) -o asgb $(ASXX) $(ASGB)
		mv asgb.exe $(DSTEXE)asgb.exe
		strip $(DSTEXE)asgb.exe


####################################################################
# ASH8
####################################################################

ASH8 =		h8pst.o h8mch.o h8adr.o

h8pst.o :	$(SRCH8)h8pst.c $(SRCH8)h8.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
h8mch.o :	$(SRCH8)h8mch.c $(SRCH8)h8.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
h8adr.o :	$(SRCH8)h8adr.c $(SRCH8)h8.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

ash8 :		$(ASXX) $(ASH8)
		$(LD) $(LDFLAGS) -o ash8 $(ASXX) $(ASH8)
		mv ash8.exe $(DSTEXE)ash8.exe
		strip $(DSTEXE)ash8.exe


####################################################################
# ASM8C
####################################################################

ASM8C =		m8cpst.o m8cmch.o m8cadr.o

m8cpst.o :	$(SRCM8C)m8cpst.c $(SRCM8C)m8c.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m8cmch.o :	$(SRCM8C)m8cmch.c $(SRCM8C)m8c.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
m8cadr.o :	$(SRCM8C)m8cadr.c $(SRCM8C)m8c.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

asm8c :		$(ASXX) $(ASM8C)
		$(LD) $(LDFLAGS) -o asm8c $(ASXX) $(ASM8C)
		mv asm8c.exe $(DSTEXE)asm8c.exe
		strip $(DSTEXE)asm8c.exe


####################################################################
# ASPIC
####################################################################

ASPIC =		picpst.o picmch.o picadr.o

picpst.o :	$(SRCPIC)picpst.c $(SRCPIC)pic.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
picmch.o :	$(SRCPIC)picmch.c $(SRCPIC)pic.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
picadr.o :	$(SRCPIC)picadr.c $(SRCPIC)pic.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

aspic :		$(ASXX) $(ASPIC)
		$(LD) $(LDFLAGS) -o aspic $(ASXX) $(ASPIC)
		mv aspic.exe $(DSTEXE)aspic.exe
		strip $(DSTEXE)aspic.exe


####################################################################
# ASRAB
####################################################################

ASRAB =		rabpst.o rabmch.o rabadr.o

rabpst.o :	$(SRCRAB)rabpst.c $(SRCRAB)rab.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
rabmch.o :	$(SRCRAB)rabmch.c $(SRCRAB)rab.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
rabadr.o :	$(SRCRAB)rabadr.c $(SRCRAB)rab.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

asrab :		$(ASXX) $(ASRAB)
		$(LD) $(LDFLAGS) -o asrab $(ASXX) $(ASRAB)
		mv asrab.exe $(DSTEXE)asrab.exe
		strip $(DSTEXE)asrab.exe


####################################################################
# ASSCMP
####################################################################

ASSCMP =		scmppst.o scmpmch.o scmpadr.o

scmppst.o :	$(SRCSCMP)scmppst.c $(SRCSCMP)scmp.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
scmpmch.o :	$(SRCSCMP)scmpmch.c $(SRCSCMP)scmp.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
scmpadr.o :	$(SRCSCMP)scmpadr.c $(SRCSCMP)scmp.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

asscmp :	$(ASXX) $(ASSCMP)
		$(LD) $(LDFLAGS) -o asscmp $(ASXX) $(ASSCMP)
		mv asscmp.exe $(DSTEXE)asscmp.exe
		strip $(DSTEXE)asscmp.exe


####################################################################
# ASZ8
####################################################################

ASZ8 =		z8pst.o z8mch.o z8adr.o

z8pst.o :	$(SRCZ8)z8pst.c $(SRCZ8)z8.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
z8mch.o :	$(SRCZ8)z8mch.c $(SRCZ8)z8.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
z8adr.o :	$(SRCZ8)z8adr.c $(SRCZ8)z8.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

asz8 :		$(ASXX) $(ASZ8)
		$(LD) $(LDFLAGS) -o asz8 $(ASXX) $(ASZ8)
		mv asz8.exe $(DSTEXE)asz8.exe
		strip $(DSTEXE)asz8.exe


####################################################################
# ASZ80
####################################################################

ASZ80 =		z80pst.o z80mch.o z80adr.o

z80pst.o :	$(SRCZ80)z80pst.c $(SRCZ80)z80.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
z80mch.o :	$(SRCZ80)z80mch.c $(SRCZ80)z80.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)
z80adr.o :	$(SRCZ80)z80adr.c $(SRCZ80)z80.h $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

asz80 :		$(ASXX) $(ASZ80)
		$(LD) $(LDFLAGS) -o asz80 $(ASXX) $(ASZ80)
		mv asz80.exe $(DSTEXE)asz80.exe
		strip $(DSTEXE)asz80.exe


####################################################################
# ASLINK
####################################################################

ASLINK =	lkmain.o lkarea.o lkdata.o lkeval.o	\
		lkhead.o lklex.o lklibr.o lklist.o	\
		lkrloc.o lkrloc3.o lkrloc4.o lksym.o	\
		lknoice.o lksdcdb.o lkbank.o lkout.o

lkmain.o :	$(SRCLNK)lkmain.c $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lkhead.o :	$(SRCLNK)lkhead.c $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lkarea.o :	$(SRCLNK)lkarea.c $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lklex.o  :	$(SRCLNK)lklex.c  $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lksym.o  :	$(SRCLNK)lksym.c  $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lkeval.o :	$(SRCLNK)lkeval.c $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lkdata.o :	$(SRCLNK)lkdata.c $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lklibr.o :	$(SRCLNK)lklibr.c $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lklist.o :	$(SRCLNK)lklist.c $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lkrloc.o :	$(SRCLNK)lkrloc.c $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lkrloc3.o :	$(SRCLNK)lkrloc3.c $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lkrloc4.o :	$(SRCLNK)lkrloc4.c $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lknoice.o :	$(SRCLNK)lknoice.c $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lksdcdb.o :	$(SRCLNK)lksdcdb.c $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lkbank.o  :	$(SRCLNK)lkbank.c  $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)
lkout.o  :	$(SRCLNK)lkout.c  $(SRCLNK)aslink.h
		$(CC) $(CCFLAGS) -I$(SRCMISC) -c $< -o $(@F)

aslink :	$(ASLINK)
		$(LD) $(LDFLAGS) -o aslink $(ASLINK)
		mv aslink.exe $(DSTEXE)aslink.exe
		strip $(DSTEXE)aslink.exe


####################################################################
# ASXCNV
####################################################################

ASXCNV =	asxxconv.o

asxxconv.o :	$(SRCMISC)asxxconv.c $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

asxcnv :	$(ASXCNV)
		$(LD) $(LDFLAGS) -o asxcnv $(ASXCNV)
		mv asxcnv.exe $(DSTEXE)asxcnv.exe
		strip $(DSTEXE)asxcnv.exe


####################################################################
# ASXSCN
####################################################################

ASXSCN =	asxxscan.o

asxxscan.o :	$(SRCMISC)asxxscan.c $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

asxscn :	$(ASXSCN)
		$(LD) $(LDFLAGS) -o asxscn $(ASXSCN)
		mv asxscn.exe $(DSTEXE)asxscn.exe
		strip $(DSTEXE)asxscn.exe


####################################################################
# S19OS9
####################################################################

S19OS9 =	s19os9.o

s19os9.o :	$(SRCS19OS9)s19os9.c $(SRCASX)asxxxx.h
		$(CC) $(CCFLAGS) -I$(SRCASX) -I$(SRCMISC) -c $< -o $(@F)

s19os9 :	$(S19OS9)
		$(LD) $(LDFLAGS) -o s19os9 $(S19OS9)
		mv s19os9.exe $(DSTEXE)s19os9.exe
		strip $(DSTEXE)s19os9.exe


### end #########################################################
