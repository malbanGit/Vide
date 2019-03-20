/*
 * Copyright 2016 by David Flamand <dflamand@gmail.com>
 *
 * This file is part of GCC6809.
 *
 * GCC6809 is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 *
 * GCC6809 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with GCC6809; see the file COPYING3.  If not see
 * <http://www.gnu.org/licenses/>.
 */

#define _GNU_SOURCE
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <stdint.h>
#include <time.h>
#define ZLIBARCH_STATIC
#include "zlibarch.h"


#define VERSION				"1.0"
#define ARCHIVE_FORMAT		"DFAR"
#define ARCHIVE_VERSION		"1"
#ifndef ARCHIVE_ARCH
#define ARCHIVE_ARCH		"m6809" /* m6809 */
#endif
#ifndef ARCHIVE_MACH
#define ARCHIVE_MACH		"m6809" /* m6809 or m6309 */
#endif
#define TMP_FILE			"/tmp/ranlib.XXXXXX"
#define OPT_HELP			"--help"
#define OPT_VERSION			"--version"
#define OPT_ARCH			"--arch"
#define OPT_MACH			"--mach"
#define OPT_NOHASH			"--nohash"
#define OPT_STRIP			"--strip"
#define OPT_DETER			"-D"
#define OPT_NONDETER		"-U"
#ifdef ZLIBARCH
#define OPT_GZIP			"--gzip"
#define OPT_NOGZIP			"--nogzip"
#endif
#define HEXBIT				4
#define HEXLONGSZ			(sizeof(long)*2)
#define DECINTSZ			11 /* -2^31 */
#define MAX_SYMBOL_SIZE		512
#define MAX_OBJECT_SIZE		256
#define MAX_LINE_SIZE		\
	(MAX_SYMBOL_SIZE + 1 + MAX_OBJECT_SIZE + 1 + HEXLONGSZ + 1 + DECINTSZ + 4)
#define MIN_HASH_BIT		3
#define MAX_HASH_BIT		16
#define MAX_HASH_LINE_SIZE	80


typedef struct _symbol_t {
	struct _symbol_t *next;
	long offset;
	char *name;
	int digit;
	char *pos;
	char *nameend;
	int lineno;
	int linenodigit1;
} symbol_t;

typedef struct _file_t {
	struct _file_t *next;
	char *name;
} file_t;


static FILE *tmpfp;
static symbol_t **symbols, **symtail;
static file_t *files, *filtail;
static char tmpfilename[sizeof(TMP_FILE)];
static char *opt_arch, *opt_mach, *fname;
static int hashsize, hashmask, as09;
static int opt_nohash, opt_strip, opt_deterministic;
static int linesheader;
#ifdef ZLIBARCH
static int opt_gzip;
#endif


static void usage(int error)
{
	fprintf(error ? stderr : stdout,
		"Usage: ranlib [options] archive\n"
		" The options are:\n"
		"  "OPT_HELP"\n"
		"  "OPT_VERSION"\n"
		"  "OPT_ARCH"=<name>\n"
		"  "OPT_MACH"=<name>\n"
		"  "OPT_STRIP"\n"
		"  "OPT_NOHASH"\n"
#ifdef ZLIBARCH
		"  "OPT_GZIP"\n"
		"  "OPT_NOGZIP"\n"
#endif
		"  "OPT_DETER"\n"
		"  "OPT_NONDETER"\n"
		);
	exit(error);
}

static void version(void)
{
	printf(
		"ranlib ("ARCHIVE_ARCH") "VERSION"\n"
		"This program is free software; you may redistribute it under the terms of\n"
		"the GNU General Public License version 3 or (at your option) any later version.\n"
		"This program has absolutely no warranty.\n"
		);
	exit(0);
}

static void cleanuptemp(void)
{
	if (tmpfp != NULL) {
		FCLOSE(tmpfp);
		tmpfp = NULL;
	}
	if (*tmpfilename != 0) {
		remove(tmpfilename);
		*tmpfilename = 0;
	}
}

static void error(char *format, ...)
{
	va_list ap;
	fprintf(stderr, "ranlib: ");
	if (fname)
		fprintf(stderr, "error while proccessing '%s': ", fname);
	va_start(ap, format);
	vfprintf(stderr, format, ap);
	va_end(ap);
	fputs("\n", stderr);
	cleanuptemp();
	exit(1);
}

static void *emalloc(size_t size)
{
	void *ptr = malloc(size);
	if (!ptr)
		error("out of memory");
	return ptr;
}

static void *ecalloc(size_t nmemb, size_t size)
{
	void *ptr = calloc(nmemb, size);
	if (!ptr)
		error("out of memory");
	return ptr;
}

static char *estrdup(const char *s)
{
	char *str = strdup(s);
	if (!str)
		error("out of memory");
	return str;
}

static char *escstring(const char *str, int escspace)
{
	char *newstr;
	size_t i, j, len;
	len = strlen(str);
	newstr = (char*)emalloc(len * 2 + 1);
	if (!newstr)
		return NULL;
	for (i=j=0; i<len;) {
		if (escspace || (!escspace && str[i] != ' '))
			newstr[j++] = '\\';
		newstr[j++] = str[i++];
	}
	newstr[j] = 0;
	return newstr;
}

static void add_file(char *filename)
{
	file_t *file;
	char *name;
	file = (file_t *)ecalloc(1, sizeof(file_t));
	name = estrdup(filename);
	if (files == NULL)
		files = filtail = file;
	else
		filtail = filtail->next = file;
	file->name = name;
}

static int gethashbit(unsigned int number)
{
	int bit = 0;
	if (!opt_nohash) {
		while (number >>= 1)
			bit++;
		if (bit < MIN_HASH_BIT)
			bit = 0;
		else
		if (bit > MAX_HASH_BIT)
			bit = MAX_HASH_BIT;
	}
	return bit;
}

static int gethexdigit(unsigned long number)
{
	int digit = 1;
	while (number >>= 4)
		digit++;
	return digit;
}

static int getdecdigit(unsigned int number)
{
	int digit = 1;
	if (number > INT_MAX) {
		if (number != (unsigned int)INT_MIN)
			number = abs(number);/*abs undefined for the most negative integer*/
		digit++; /* negative sign */
	}
	while (number /= 10)
		digit++;
	return digit;
}

/* djb2 hash function */
static int djb2hash(char *p)
{
	int h;
	h = 5381;
	while (*p)
		h = ((h << 5) + h) + *p++;
	return h & hashmask;
}

static long add_symbol(char *symbol, char *object, long offset, int lineno)
{
	symbol_t *sym;
	char *name;
	size_t len;
	int namelen, linenodigit1;
	namelen = strlen(symbol);
	linenodigit1 = lineno == -1 ? 0 : getdecdigit(lineno)+1;
	len = namelen + 1 + strlen(object) + 1 + HEXLONGSZ + linenodigit1 + 1;
	sym = (symbol_t *)ecalloc(1, sizeof(symbol_t));
	name = (char *)emalloc(len + 1);
	sprintf(name, "%s %s ", symbol, object);
	if (symbols[0] == NULL)
		symbols[0] = symtail[0] = sym;
	else
		symtail[0] = symtail[0]->next = sym;
	sym->offset = offset;
	sym->name = name;
	sym->pos = name + len - 1 - linenodigit1 - HEXLONGSZ;
	sym->nameend = name + namelen;
	sym->lineno = lineno;
	sym->linenodigit1 = linenodigit1;
	return len;
}

static void free_symbols(void)
{
	int i;
	symbol_t *symbol, *next;
	if (symbols != NULL) {
		for (i=0; i<hashsize; i++) {
			symbol = symbols[i];
			while (symbol) {
				next = symbol->next;
				free(symbol->name);
				free(symbol);
				symbol = next;
			}
		}
		free(symbols);
		symbols = NULL;
	}
	if (symtail != NULL) {
		free(symtail);
		symtail = NULL;
	}
}

static int striplineend(char *str)
{
	int len = strlen(str);
	if (str[len-1] == '\n')
		str[--len] = 0;
	if (len > 0) {
		if (str[len-1] == '\r')
			str[--len] = 0;
	}
	return len;
}

static int copy_object(char *buffer, char *object)
{
	char *str;
	size_t len;
	len = striplineend(object);
	if (len > 0) {
		str = strchr(object, ' ');
		if (str != NULL) {
			*str = 0;
			len = strlen(object);
		}
		if (len > 0) {
			strcpy(buffer, object);
			return 1;
		}
	}
	return 0;
}

static void ranlib(char *filename)
{
	FILE *fp, *tmpfpr;
	char line[MAX_LINE_SIZE], object[MAX_LINE_SIZE], *str, *arch, *mach;
	long begin, offset, indexsize, objoff, size;
	unsigned long maxoffset;
	symbol_t *symbol, *symbol2, *next;
	int fd, digit, begdigit, diff, changed, h, i, j, err, ret, hashbit;
	size_t len, len2, nsymbols;

	/* Free previous symbols if any. */
	free_symbols();

	/* Set current filename for error printing. */
	fname = filename;

	/* Init ARCH and MACH to NULL */
	arch = mach = NULL;

	/* Open input file. */
	fp = FOPEN(filename, "r");
	if (fp == NULL)
		error("cannot open archive");

	/* Process header/metadata/comments and skip hash/symbol table if any. */
	begin = 0;
	linesheader = 0;
	while (FGETS(line, MAX_LINE_SIZE, fp) != NULL) {
		if (*line == '#') {
			str = line+1;
			striplineend(str);
			if (!strncmp(str, " FORMAT ", sizeof(" FORMAT ")-1)) {
				if (strcmp(str+sizeof(" FORMAT ")-1, ARCHIVE_FORMAT))
					error("wrong library format");
			}
			else
			if (!strncmp(str, " VERSION ", sizeof(" VERSION ")-1)) {
				if (strcmp(str+sizeof(" VERSION ")-1, ARCHIVE_VERSION))
					error("wrong version number");
			}
			else
			if (!strncmp(str, " ARCH ", sizeof(" ARCH ")-1)) {
				if (arch == NULL)
					arch = strdup(str+sizeof(" ARCH ")-1);
			}
			else
			if (!strncmp(str, " MACH ", sizeof(" MACH ")-1)) {
				if (mach == NULL)
					mach = strdup(str+sizeof(" MACH ")-1);
			}
			begin = FTELL(fp);
			linesheader++;
			continue;
		}
		do {
			if (*line == '\n' || *line == '\r' || ((str = strchr(line, ' ')) && strchr(str+1, ' '))) {
				begin = FTELL(fp);
				linesheader++;
				continue;
			}
			if ((!as09 && (line[0] != 'L' || (line[1] >= '0' && line[1] <= '9'))) ||
				(as09 && (line[0] != '!' || line[1] != 'L' || line[2] != 'I' || line[3] != 'B')))
				error("wrong archive format");
			break;
		} while (FGETS(line, MAX_LINE_SIZE, fp) != NULL);
		break;
	}
	if (FERROR(fp))
		error("cannot read file");

	/* The variable 'begin' should point at the beginning of 'LIB' line. */
	if (begin < 0)
		error("something goes wrong with header processing");

	/* Create and open temp file. */
	strcpy(tmpfilename, TMP_FILE);
	fd = mkstemp(tmpfilename);
	if (fd < 0)
		error("cannot create temp file");
#ifdef ZLIBARCH
	tmpfp = FDOPEN(fd, (!FDIRECT(fp) && opt_gzip == 0) || (opt_gzip > 0) ? "w" : "wT");
#else
	tmpfp = FDOPEN(fd, "r+");
#endif
	if (tmpfp == NULL)
		error("cannot open temp file");

	/* Check for strip option, when set skip symbol table output. */
	if (!opt_strip) {
		/* Alloc buffer for symbol table. */
		symbols = ecalloc(1, sizeof(symbol_t*));
		symtail = ecalloc(1, sizeof(symbol_t*));

		/* Scan for all defined symbols, and add them to 'symbols'. */
		*object = 0;
		objoff = 0;
		nsymbols = 0;
		indexsize = 0;
		if (!as09) {
			offset = FTELL(fp);
			while (FGETS(line, MAX_LINE_SIZE, fp) != NULL) {
				if (line[0] == 'E')
					break;
				if (line[0] == 'L') {
					if (line[1] == '0' && line[2] == ' ')
						objoff = copy_object(object, &line[3]) ? offset - begin : 0;
					else
					if (line[1] == '1' && line[2] == ' ')
						objoff = 0;
					offset = FTELL(fp);
					continue;
				}
				if (objoff) {
					if (line[0] == 'S' && line[1] == ' ') {
						str = strchr(&line[2], ' ');
						if (str && str != &line[2]) {
							if (str[1] == 'D') {
								*str = 0;
								/* Add only '.__.ABS.' symbol if not defined to zero. */
								if (!(!strcmp(&line[2], ".__.ABS.") &&
									(str[2] == 'E' || str[2] == 'e') &&
									(str[3] == 'F' || str[3] == 'f') &&
									strtol(&str[4], NULL, 16) == 0)) {
									indexsize += add_symbol(&line[2], object, objoff, -1);
									nsymbols++;
								}
							}
						}
					}
				}
				offset = FTELL(fp);
			}
			if (FERROR(fp))
				error("cannot read file");
		}
		else {
			FILE *fp;
			size_t len;
			char *command, *linker, *psymbol, *plineno, *poffset, *pobject, *fname;
			linker = "as09link";
			fname = escstring(filename, 1);
/*fprintf(stderr, "%s\n", fname);*/
			if (asprintf(&command, "%s -h -y -pe %s", linker, fname) == -1)
				error("out of memory");
			fp = popen(command, "r");
			if (!fp)
				error("cannot execute linker '%s'", linker);
			while (fgets(line, MAX_LINE_SIZE, fp) != NULL) {
				len = strlen(line);
				if (len > 1 && line[len-1] == '\n')
					line[len-1] = 0;
/*fprintf(stderr, "%s\n", line);*/
				if (len > 2) {
					if (line[0] == 'e' && line[1] == ' ') {
						psymbol = &line[2];
						plineno = strchr(psymbol+1, ' ');
						if (plineno) {
							*plineno++ = 0;
							poffset = strchr(plineno, ' ');
							if (poffset) {
								*poffset++ = 0;
								pobject = strchr(poffset, ' ');
								if (pobject) {
									*pobject++ = 0;;
									offset = strtol(poffset, NULL, 16);
									indexsize += add_symbol(psymbol, pobject, offset - begin, atoi(plineno) - linesheader);
									nsymbols++;
								}
							}
						}
					}
				}
			}
			if (ferror(fp))
				error("cannot read linker output");
			pclose(fp);
			free(fname);
		}

		/* If hashsize > 1 then compute hash function on symbols
		   and fill bins. */
		hashbit = gethashbit(nsymbols);
		hashsize = 1 << hashbit;
		if (hashsize > 1) {
			hashmask = hashsize - 1;
			symbol = symbols[0];
			free(symbols);
			free(symtail);
			symbols = ecalloc(hashsize, sizeof(symbol_t*));
			symtail = ecalloc(hashsize, sizeof(symbol_t*));
			while (symbol) {
				next = symbol->next;
				symbol->next = NULL;
				*symbol->nameend = 0;
				h = djb2hash(symbol->name);
				*symbol->nameend = ' ';
				if (symbols[h] == NULL)
					symbols[h] = symtail[h] = symbol;
				else
					symtail[h] = symtail[h]->next = symbol;
				symbol = next;
			}
			/* For offset zero. */
			indexsize++;
			/* Compute indexsize for the number of non-zero bin. */
			for (i=0; i<hashsize; i++)
				if (symbols[i])
					indexsize++;
		}

		/* Compute the required number of digit for each symbol offset,
		   iterate until the number of digit stabilize. Two steps: */
		begdigit = HEXLONGSZ;
		/* Step 1, find the greatest offset and try to strip digit for all symbols. */
		do {
			maxoffset = 0;
			for (i=0; i<hashsize; i++) {
				if (symtail[i]) {
					offset = symtail[i]->offset + indexsize;
					if (offset > (long)maxoffset)
						maxoffset = offset;
				}
			}
			digit = 1;
			while (maxoffset>>=HEXBIT)
				digit++;
			diff = begdigit - digit;
			begdigit = digit;
			indexsize -= diff * nsymbols;
			changed = diff;
		} while (changed);
		/* Step 2, strip digit for each symbol. */
		do {
			changed = 0;
			for (i=0; i<hashsize; i++) {
				for (symbol = symbols[i]; symbol; symbol=symbol->next) {
					maxoffset = symbol->offset + indexsize;
					digit = 1;
					while (maxoffset>>=HEXBIT)
						digit++;
					diff = (symbol->digit ? symbol->digit : begdigit) - digit;
					symbol->digit = digit;
					if (diff) {
						changed |= diff;
						for (j=0; j<hashsize; j++)
							for (symbol2 = symbols[j]; symbol2; symbol2=symbol2->next)
								symbol2->offset -= diff;
					}
				}
			}
		} while (changed);

		/* Output header. */
		err = FPRINTF(tmpfp, 
			"# FORMAT %s\n"
			"# VERSION %s\n"
			, ARCHIVE_FORMAT, ARCHIVE_VERSION) <= 0;
		if (opt_arch != (char*)-1)
			err |= FPRINTF(tmpfp, "# ARCH %s\n", opt_arch ? opt_arch : (arch ? arch : ARCHIVE_ARCH)) <= 0;
		if (opt_mach != (char*)-1)
			err |= FPRINTF(tmpfp, "# MACH %s\n", opt_mach ? opt_mach : (mach ? mach : ARCHIVE_MACH)) <= 0;
		if (!opt_deterministic)
			err |= FPRINTF(tmpfp, "# TIMESTAMP %li\n", time(NULL)) <= 0;
		if (nsymbols != 0 && hashsize > 1) {
			ret = FPRINTF(tmpfp, "# HASH %X", hashbit);
			err |= ret <= 0;
			len = ret;
			for (i=0, size=1 /* for zero offset */; i<hashsize && !err; i++) {
				symbol = symbols[i];
				len2 = symbol ? gethexdigit(size)+1 : 1+1;
				len += len2;
				if (len >= MAX_HASH_LINE_SIZE) {
					ret = FPRINTF(tmpfp, "\n# HASH");
					err |= ret <= 0;
					len = ret-1 + len2;
				}
				err |= FPRINTF(tmpfp, " %lX", symbol ? size : 0) <= 0;
				if (symbol) {
					for (; symbol; symbol=symbol->next)
						size += symbol->pos - symbol->name + symbol->digit + symbol->linenodigit1 + 1;
					size++;
				}
			}
			err |= FPRINTF(tmpfp, "\n") <= 0;
		}
		if (err || FERROR(tmpfp))
			error("cannot write header");

		/* Output symbol table. */
		if (nsymbols != 0) {
			if (hashsize > 1)
				FPUTS("\n", tmpfp); /* offset zero */
			for (i=0; i<hashsize; i++) {
				symbol = symbols[i];
				if (symbol) {
					for (symbol = symbols[i]; symbol; symbol=symbol->next) {
						if (sprintf(symbol->pos, symbol->linenodigit1 ? "%lX %d\n" : "%lX\n", symbol->offset + indexsize, symbol->lineno)
							!= symbol->digit+symbol->linenodigit1+1)
							error("something wrong with sprintf");
						if (FPUTS(symbol->name, tmpfp) == EOF)
							break;
					}
					if (hashsize > 1)
						FPUTS("\n", tmpfp); /* end of bin */
				}
				if (FERROR(tmpfp))
					error("failed to write to temp file");
			}
		}
	}

	/* Seek library file to 'begin'. */
	if (FSEEK(fp, begin, SEEK_SET))
		error("cannot seek file");

	/* Copy the library content to temp file. */
	while ((len = FREAD(line, 1, MAX_LINE_SIZE, fp)))
		if (FWRITE(line, 1, len, tmpfp) != len)
			error("cannot write temp file");
	if (FERROR(fp))
		error("cannot read file");

	/* Close file. */
	if (FCLOSE(fp))
		error("closing file failed");

#ifdef ZLIBARCH
	/* We must reopen the temp file for reading, because zlib */
	/* don't support reading and writing on the same file. */
	err = FCLOSE(tmpfp);
	tmpfp = NULL;
	if (err)
		error("closing temp file failed");
	/* The temp file is opened for reading with pure stdio, */
	/* we only do a file copy here. */
	tmpfpr = fopen(tmpfilename, "r");
	if (tmpfpr == NULL)
		error("cannot open temp file");
#else
	/* No zlib, so set the temp file offet to zero. */
	tmpfpr = tmpfp;
	tmpfp = NULL;
	if (fseek(tmpfpr, 0, SEEK_SET))
		error("cannot seek temp file");
#endif

	/* From this point, if something goes wrong, */
	/* the original library file may be lost. */

	/* Delete old library file. */
	if (remove(filename))
		error("cannot remove file");

	/* Create and open the new library file. */
	fp = fopen(filename, "w");
	if (fp == NULL)
		error("cannot create file");

	/* Copy temp file to new library file. */
	while ((len = fread(line, 1, MAX_LINE_SIZE, tmpfpr)))
		if (fwrite(line, 1, len, fp) != len)
			error("cannot write file");
	if (ferror(tmpfpr))
		error("cannot read temp file");

	/* Close library file. */
	if (fclose(fp))
		error("closing file failed");

	/* Close temp file. */
	if (fclose(tmpfpr))
		error("closing temp file failed");

	/* Cleanup temp file. */
	cleanuptemp();

	/* Free 'arch' and 'mach' if set. */
	if (arch != NULL)
		free(arch);
	if (mach != NULL)
		free(mach);

	/* No filename for error printing. */
	fname = NULL;
}


int main(int argc, char **argv)
{
	char *env;
	file_t *file;

	/* No arguments? */
	if (argc < 2)
		usage(1);

	/* Parse options. */
	for (argv++, argc--; argc > 0; argv++, argc--) {
		switch (*argv[0]) {
		case '-':
			if (!strcmp(*argv, OPT_HELP)) {
				usage(0);
			}
			else
			if (!strcmp(*argv, OPT_VERSION)) {
				version();
			}
			else
			if (!strncmp(*argv, OPT_ARCH, sizeof(OPT_ARCH)-1)) {
				if (argv[0][sizeof(OPT_ARCH)-1] == 0) {
					opt_arch = (char*)-1;
					break;
				}
				if (argv[0][sizeof(OPT_ARCH)-1] == '=') {
					opt_arch = &argv[0][sizeof(OPT_ARCH)];
					if (!*opt_arch)
						opt_arch = (char*)-1;
					break;
				}
			}
			else
			if (!strncmp(*argv, OPT_MACH, sizeof(OPT_MACH)-1)) {
				if (argv[0][sizeof(OPT_MACH)-1] == 0) {
					opt_mach = (char*)-1;
					break;
				}
				if (argv[0][sizeof(OPT_MACH)-1] == '=') {
					opt_mach = &argv[0][sizeof(OPT_MACH)];
					if (!*opt_mach)
						opt_mach = (char*)-1;
					break;
				}
			}
			else
			if (!strcmp(*argv, OPT_NOHASH)) {
				opt_nohash = 1;
				break;
			}
			else
			if (!strcmp(*argv, OPT_STRIP)) {
				opt_strip = 1;
				break;
			}
			else
			if (!strcmp(*argv, OPT_DETER)) {
				opt_deterministic = 1;
				break;
			}
			else
			if (!strcmp(*argv, OPT_NONDETER)) {
				opt_deterministic = 0;
				break;
			}
#ifdef ZLIBARCH
			else
			if (!strcmp(*argv, OPT_GZIP)) {
				opt_gzip = 1;
				break;
			}
			else
			if (!strcmp(*argv, OPT_NOGZIP)) {
				opt_gzip = -1;
				break;
			}
#endif
			error("unrecognized option '%s'", *argv);
			break;
		default:
			add_file(*argv);
			break;
		}
	}

	/* No files? */
	if (files == NULL)
		error("no file given");

	/* as09 */
	as09 = ((env=getenv("USEAS09")) && *env) || ((env=getenv("AS09OPT")) && *env);

	/* Do ranlib() on files. */
	for (file=files; file; file=file->next)
		ranlib(file->name);

	return 0;
}
