/* armain.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "aslib.h"
#define ZLIBARCH_STATIC
#include "zlibarch.h"

static char tag_libbeg[6] = "LIB";
static char tag_libend[6] = "END";
static char tag_objbeg[6] = "L0";
static char tag_objend[6] = "L1";
static int tag_libsz = sizeof("LIB")-1;
static int tag_objsz = sizeof("L0")-1;

static int creation_flag = 0;
static int verbose_level = 0;
static int verbose_action = 0;
#define VERBOSE_LEVEL
#include "common.c"



/* addprefix:
 *  Add a character prefix to a string.
 */
static void addprefix(char *str)
{
	memmove(str+1, str, strlen(str)+1);
	*str = '!';
}



/* basenam:
 *  Strips path from the filename.
 */
static char *basenam(char *filename)
{
	char *p;

	p = strrchr(filename, '/');
	if (p != NULL)
		return p+1;

	return filename;
}



/* copycontents:
 *  Copy the contents from src to dst.
 */
static void copycontents(char *buffer, int buflen, FILE *src, FILE *dst)
{
	while (fgets(buffer, buflen, src)) {
		striplineend(buffer);
		FPUTS(buffer, dst);
		FPUTS("\n", dst);
	}
}



/* create_archive:
 *  Creates an empty archive.
 */
static void create_archive(char *filename)
{
	FILE *libf;
	char *name;

	libf = fopen(filename, "w");
	if (!libf) {
		fprintf(stderr, "Error: cannot create '%s'.\n", filename);
		exit(1);
	}

	if (!creation_flag)
		fprintf(stderr, "Warning: '%s' did not exist.\n", filename);

	name = basenam(filename);
	fprintf(libf, "%s %s\n", tag_libbeg, name);
	fprintf(libf, "%s %s\n", tag_libend, name);
	fclose(libf);
}



/* name_in_list:
 *  Helper for finding whether a name is present in the list.
 */
static int name_in_list(char *name, struct lfile *list)
{
	while (list) {
		if (!strcmp(name, list->f_idp)) {
			list->f_found = 1;
			return 1;
		}
		list = list->f_flp;
	}

	return 0;
}



/* append:
 *  Appends members to an archive.
 */
static void append(char *arname, struct lfile *memberp)
{
	FILE *libf, *libftmp;
	char modname[NCPS];
	char line[FILSPC];
	char tmpfile[FILSPC];
	int ret;
	long offset;

	verbose_action = 'a';

	libf = FOPEN(arname, "r");
	if (!libf) {
		create_archive(arname);
		libf = FOPEN(arname, "r");
	}
	if (!libf) {
		fprintf(stderr, "Error: cannot open '%s'.\n", arname);
		exit(1);
	}
	ret = snprintf(tmpfile, FILSPC, "%s.tmp", arname);
	if (ret <= 0 || ret >= FILSPC-1)
		*tmpfile = 0;
#ifdef ZLIBARCH
	libftmp = FOPEN(tmpfile, FDIRECT(libf) ?  "wT" : "w");
#else
	libftmp = FOPEN(tmpfile, "w");
#endif
	if (!libftmp) {
		fprintf(stderr, "Error: cannot create temporary file.\n");
		exit(1);
	}

	skipheader(libf);

	/* seek 'END' marker */
	for (offset=0; FGETS(line, FILSPC, libf) != NULL && strncmp(line, tag_libend, tag_libsz); offset=FTELL(libf)) {
		striplineend(line);
		FPUTS(line, libftmp);
		FPUTS("\n", libftmp);
	}
	if (FERROR(libf) || FEOF(libf) || FSEEK(libf, offset, SEEK_SET) < 0) {
		fprintf(stderr, "Error: cannot seek 'END' marker.\n");
		FCLOSE(libftmp);
		remove(tmpfile);
		exit(1);
	}

	FCLOSE(libf);

	*modname = 0;
	filep = memberp;
	cfp = NULL;

	while ((ret = nxtline())) {
		if (ret == 2) {
			if (*modname)
				FPRINTF(libftmp, "%s %s\n", tag_objend, modname);

			strcpy(modname, basenam(cfp->f_idp));
			FPRINTF(libftmp, "%s %s\n", tag_objbeg, modname);
		}

		FPUTS(ib, libftmp);
		FPUTS("\n", libftmp);
	}

	FPRINTF(libftmp, "%s %s\n", tag_objend, modname);
	FPRINTF(libftmp, "%s %s\n", tag_libend, basenam(arname));
	FCLOSE(libftmp);

	/* replace existing archive by new one */
	remove(arname);
	rename(tmpfile, arname);
}



/* replace:
 *  Adds members to an archive with replacement or deletes them.
 */
static void replace(char *arname, struct lfile *memberp, int delete)
{
	FILE * libf, *newf = NULL;
	char modname[NCPS];
	char newb[NINPUT];
	int replaced, ret;
	char tmpfile[FILSPC];
#ifdef ZLIBARCH
	int direct = 1;
#endif

	verbose_action = 0;

	/* check that the archive exists */
	if ((libf = FOPEN(arname, "r"))) {
#ifdef ZLIBARCH
		direct = FDIRECT(libf);
#endif
		FCLOSE(libf);
		libf = NULL;
	}
	else {
		if (delete) {
			fprintf(stderr, "Error: cannot open '%s'.\n", arname);
			exit(1);
		}
		create_archive(arname);
	}

	filep = new_lfile(arname, 1);
	cfp = NULL;

	while (memberp) {
		if (!delete) {
			if (verbose_level)
				fprintf(stdout, "r - %s\n", memberp->f_idp);
			newf = fopen(memberp->f_idp, "r");
			if (!newf) {
				fprintf(stderr, "Error: cannot open '%s'.\n", memberp->f_idp);
				if (libf) {
					FCLOSE(libf);
					remove(tmpfile);
				}
				exit(1);
			}
		}
		else {
			if (verbose_level)
				fprintf(stdout, "d - %s\n", memberp->f_idp);
		}

		ret = snprintf(tmpfile, FILSPC, "%s.tmp", arname);
		if (ret <= 0 || ret >= FILSPC-1)
			*tmpfile = 0;
#ifdef ZLIBARCH
		libf = FOPEN(tmpfile, direct ? "wT" : "w");
#else
		libf = FOPEN(tmpfile, "w");
#endif
		if (!libf) {
			fprintf(stderr, "Error: cannot create temporary file.\n");
			exit(1);
		}

		replaced = 0;
		cfp = NULL;

		while (nxtline()) {
			if (!strncmp(ib, tag_objbeg, tag_objsz)) {
				ip = ib + tag_objsz;
				getid(modname, -1);

				/* test whether the module name is the requested one */
				if (!strcmp(modname, memberp->f_idp)) {
					if (!delete) {
						FPRINTF(libf, "%s\n", ib);  /* L0 .. */

						/* copy the contents */
						copycontents(newb, NINPUT, newf, libf);

						replaced = 1;
					}

					while (nxtline()) {
						if (!strncmp(ib, tag_objend, tag_objsz))
							break;
					}

					if (!delete)
						FPRINTF(libf, "%s\n", ib);   /* L1 .. */

					continue;
				}
			}
			else
			if (!strncmp(ib, tag_libend, tag_libsz)) {
				if (!delete && !replaced) {
					strcpy(modname, basenam(memberp->f_idp));

					FPRINTF(libf, "%s %s\n", tag_objbeg, modname);

					/* copy the contents */
					copycontents(newb, NINPUT, newf, libf);

					FPRINTF(libf, "%s %s\n", tag_objend, modname);
					FPRINTF(libf, "%s %s\n", tag_libend, basenam(arname));

					continue;
				}
			}
			FPUTS(ib, libf);
			FPUTS("\n", libf);
		}

		FCLOSE(libf);
		libf = NULL;
		if (!delete)
			fclose(newf);

		/* replace existing archive by new one */
		remove(arname);
		rename(tmpfile, arname);

		memberp = memberp->f_flp;
	}
}



/* extract:
 *  Extracts members from an archive.
 */
static void extract(char *arname, struct lfile *memberp, int create)
{
	FILE *newf;
	char modname[NCPS];
	struct lfile *lfp;
	int err;
	long begin, end;

	verbose_action = 0;

	filep = new_lfile(arname, 1);
	cfp = NULL;

	while (nxtline()) {
		if (!strncmp(ib, tag_objbeg, tag_objsz)) {
			ip = ib + tag_objsz;
			getid(modname, -1);

			if (!memberp || name_in_list(modname, memberp)) {
				if (create == 1) {
					/* list files */
					begin = end = as_offset();
					while (nxtline()) {
						if (!strncmp(ib, tag_objend, tag_objsz))
							break;
						end = as_offset();
					}
					if (verbose_level)
						fprintf(stdout, "% 7li %s\n", end-begin, modname);
					else
						fprintf(stdout, "%s\n", modname);
				}
				else {
					/* extract or print files */
					if (create) {
						if (verbose_level)
							fprintf(stdout, "x - %s\n", modname);
						newf = fopen(modname, "w");
						if (!newf) {
							fprintf(stderr, "Error: cannot create '%s'.\n", modname);
							exit(1);
						}
					}
					else {
						if (verbose_level)
							fprintf(stdout, "\n<%s>\n\n", modname);
						newf = stdout;
					}

					while (nxtline()) {
						if (!strncmp(ib, tag_objend, tag_objsz))
							break;
						fprintf(newf, "%s\n", ib);
					}

					if (create)
						fclose(newf);
				}
			}
		}
	}

	err = 0;
	for (lfp = memberp; lfp; lfp = lfp->f_flp) {
		if (!lfp->f_found) {
			fprintf(stderr, "Error: object not found '%s'.\n", lfp->f_idp);
			err = 1;
		}
	}
	if (err)
		exit(1);
}



static char *usetxt[] = {
	"Usage: [-]p[mod [count]...] archive [member...]",
	"  where p must be one of:",
	"    d   delete file(s)",
	"    p   print contents of archive",
	"    q   quick append file(s)",
	"    r   insert file(s) with replacement",
	"    t   list file(s)",
	"    x   extract file(s)",
	"  and mod must be one of:",
	"    c   create new lib",
	"    v   request verbose",
   NULL
};



static void usage(void)
{
	char **dp;

	fprintf(stderr, "ASxxxx Library Manager %s\n\n", VERSION);
	for (dp = usetxt; *dp; dp++)
		fprintf(stderr, "%s\n", *dp);

	exit(1);
}



int main(int argc, char *argv[])
{
	char *p, *arname = NULL, c, *name, *env;
	struct lfile *lfp = NULL, *memberp = NULL;
	int i, action = 0;

	if (argc < 3)
		usage();

	p = argv[1];
	if (*p == '-')
		p++;

	while ((c = *p++)) {
		switch (c) {
		case 'd': /* delete */
		case 'p': /* print contents */
		case 'q': /* append */
		case 'r': /* insert and replace */
		case 't': /* list */
		case 'x': /* extract */
			if (action && action != c)
				usage();
			action = c;
			break;
		case 'c':
			creation_flag = 1;
			break;
		case 'v':
			verbose_level = 1;
			break;
		default:
			usage();
		}
	}

	if (!action)
		usage();

	for (i=2; i<argc; ++i) {
		p = argv[i];
		if (strchr(basenam(p), ' ')) {
			fprintf(stderr, "Error: filename '%s' contain a space character.\n", p);
			exit(1);
		}
		if (!arname) {
			arname = new(strlen(p)+1);
			strcpy(arname, p);
		}
		else {
			name = action == 'd' || action == 'x' ? basenam(p) : p;
			if (!memberp) {
				memberp = new_lfile(name, 0);
				lfp = memberp;
			}
			else {
				lfp->f_flp = new_lfile(name, 0);
				lfp = lfp->f_flp;
			}
		}
	}

	if (!arname)
		usage();

	if (((env=getenv("USEAS09")) && *env) || ((env=getenv("AS09OPT")) && *env))
	{
		addprefix(tag_libbeg);
		addprefix(tag_libend);
		addprefix(tag_objbeg);
		addprefix(tag_objend);
		tag_libsz++;
		tag_objsz++;
	}

	switch (action) {
	case 'd': replace(arname, memberp, 1); break;
	case 'p': extract(arname, memberp, 0); break;
	case 'q': append(arname, memberp);     break;
	case 'r': replace(arname, memberp, 0); break;
	case 't': extract(arname, memberp, 1); break;
	case 'x': extract(arname, memberp, 2); break;
	}

	return 0;
}
