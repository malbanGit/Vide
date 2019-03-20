# Makefile

CFLAGS = -c -Wall -O2 -MMD
LDFLAGS = -fno-exceptions -s

MAKEFLAGS += -s

ifeq ($(OS), Windows_NT)
	CC = mingw32-gcc
	EXE_SUFFIX = .exe
else
	CC = gcc
endif

LD = $(CC)

BIN2SREC_EXE = bin2srec$(EXE_SUFFIX)
SREC2BIN_EXE = srec2bin$(EXE_SUFFIX)
BINSPLIT_EXE = binsplit$(EXE_SUFFIX)

all: $(BIN2SREC_EXE) $(SREC2BIN_EXE) $(BINSPLIT_EXE)

BIN2SREC_SRC = \
	bin2srec.c \
	common.c \

SREC2BIN_SRC = \
	srec2bin.c \
	common.c \

BINSPLIT_SRC = \
	binsplit.c \
	common.c \

BIN2SREC_OBJS = $(BIN2SREC_SRC:.c=.o)
SREC2BIN_OBJS = $(SREC2BIN_SRC:.c=.o)
BINSPLIT_OBJS = $(BINSPLIT_SRC:.c=.o)

RULES = $(BIN2SREC_SRC:.c=.d) $(SREC2BIN_SRC:.c=.d) $(BINSPLIT_SRC:.c=.d)

%.o:%.c	Makefile
	@echo CC $<
	$(CC) $(CFLAGS) -c $< -o $@

$(BIN2SREC_EXE): $(BIN2SREC_OBJS)
	@echo Linking $@
	$(LD) -o $@ $^ $(LDFLAGS)

$(SREC2BIN_EXE): $(SREC2BIN_OBJS)
	@echo Linking $@
	$(LD) -o $@ $^ $(LDFLAGS)

$(BINSPLIT_EXE): $(BINSPLIT_OBJS)
	@echo Linking $@
	$(LD) -o $@ $^ $(LDFLAGS)

clean:
	-$(RM) $(BIN2SREC_OBJS) $(SREC2BIN_OBJS) $(BINSPLIT_OBJS)
	-$(RM) $(RULES)
	-$(RM) $(BIN2SREC_EXE) $(SREC2BIN_EXE) $(BINSPLIT_EXE)

-include $(RULES)