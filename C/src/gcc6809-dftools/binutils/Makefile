CFLAGS = -O2 -Wall -Wextra -ansi -pedantic -D_XOPEN_SOURCE=700

.PHONY: all
all: ranlib

.PHONY: clean
clean:
	rm -f ranlib

.PHONY: distclean
distclean: clean

ranlib: ranlib.c
	$(CC) $(CFLAGS) $(BINUTILS_CFLAGS) -o $@ $< $(BINUTILS_LDFLAGS)
