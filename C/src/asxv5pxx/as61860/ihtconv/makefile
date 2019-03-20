####################################################################
#  Makefile
#		Linux 'GNU make' Version
#		========================
#
#  24  March  2003
#
####################################################################

IHXCONV = ihx2wav ihx2bas


####################################################################
# Special
####################################################################

.PHONY:	all clean

all:	$(IHXCONV)

clean:
	rm -fv *.o

####################################################################
# Option Definitions
####################################################################

CC=		gcc
CCOPT=		-O3
CCFLAGS=	-Wall -funsigned-char $(CCOPT)

LD=		gcc
LDFLAGS=	-Wall


####################################################################
# IHXCONV Directories
####################################################################

#  Set RELDIR relative to this make file.

RELDIR=		.

SRC=		$(RELDIR)/
DSTEXE=		./

####################################################################
# IHXCONV FILES
####################################################################

IHX2WAV =	ihx2wav.o ihxconv.o
IHX2BAS =       ihx2bas.o ihxconv.o 

ihx2wav.o :	$(SRC)ihx2wav.c $(SRC)ihxconv.h
		$(CC) $(CCFLAGS) -c $< -o $(@F)
ihx2bas.o :	$(SRC)ihx2bas.c $(SRC)ihxconv.h
		$(CC) $(CCFLAGS) -c $< -o $(@F)
ihxconv.o :	$(SRC)ihxconv.c $(SRCASX)ihxconv.h
		$(CC) $(CCFLAGS) -c $< -o $(@F)

ihx2wav :	$(IHX2WAV)
		$(LD) $(LDFLAGS) -o $(DSTEXE)ihx2wav $(IHX2WAV)
		strip $(DSTEXE)ihx2wav

ihx2bas :	$(IHX2BAS)
		$(LD) $(LDFLAGS) -o $(DSTEXE)ihx2bas $(IHX2BAS)
		strip $(DSTEXE)ihx2bas



### end #########################################################


