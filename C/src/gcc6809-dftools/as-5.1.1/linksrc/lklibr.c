/* lklibr.c */

/*
 *  Copyright (C) 1989-2014  Alan R. Baldwin
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *
 * Alan R. Baldwin
 * 721 Berkeley St.
 * Kent, Ohio  44240
 *
 * With contributions for the
 * object libraries from
 * Ken Hornstein
 * kenhat cmf dot nrl dot navy dot mil
 *
 * Major update, support single file library,
 * added support for gzip'ed library,
 * added hash table and symbol index for
 * a huge improvement in link time,
 * contributions from
 * David Flamand <dflamand@gmail.com>
 *
 */

#include "aslink.h"
#define ZLIBARCH_STATIC
#include "zlibarch.h"

/*)Module	lklibr.c
 *
 *	The module lklibr.c contains the functions which
 *	(1) specify the path(s) to library files [.LIB]
 *	(2) specify the library file(s) [.LIB] to search
 *	(3) search the library files for specific symbols
 *	    and link the module containing this symbol
 *
 *	lklibr.c contains the following functions:
 *		int	djb2hash()
 *		VOID	addpath()
 *		VOID	addlib()
 *		int	addfile()
 *		VOID	search()
 *		VOID	processtag()
 *		VOID	fndsym_noind()
 *		VOID	fndsym_cache()
 *		VOID	fndsym()
 *		VOID	library()
 *		VOID	loadfile()
 *
 */

/*)Function	int	djb2hash()
 *
 *		char	*p		input string
 *
 *	The function djb2hash() compute a hash on a string.
 *
 *	local variables:
 *		int	h		hash value
 *
 *	side effects:
 *		An hash is computed from string.
 */

static
int
djb2hash(p)
char *p;
{
	int h;
	h = 5381;
	while (*p)
		h = ((h << 5) + h) + *p++;
	return h;
}

/*)Function	VOID	addpath()
 *
 *	The function addpath() creates a linked structure containing
 *	the paths to various object module library files.
 *
 *	local variables:
 *		lbpath	*lbph		pointer to new path structure
 *
 *	global variables:
 *		lbpath	*lbphead	The pointer to the first
 *				 	path structure
 *		lbpath	*lbptail	The pointer to the last
 *				 	path structure
 *
 *	 functions called:
 *		char *	new()		lksym.c
 *		char *	strto()		lksym.c
 *		int	getnb()		lklex.c
 *		VOID	unget()		lklex.c
 *
 *	side effects:
 *		An lbpath structure is created.
 */

VOID
addpath()
{
	struct lbpath *lbph;

	lbph = (struct lbpath *) new (sizeof(struct lbpath));
	if (lbphead == NULL)
		lbphead = lbptail = lbph;
	else
		lbptail = lbptail->next = lbph;
	unget(getnb());
	lbph->path = strsto (ip);
}

/*)Function	VOID	addlib()
 *
 *	The function addlib() tests for the existance of a
 *	library path structure to determine the method of
 *	adding this library file to the library search structure.
 *
 *	This function calls the function addfile() to actually
 *	add the library file to the search list.
 *
 *	local variables:
 *		lbpath	*lbph		pointer to path structure
 *		int	libfnd		library found flag
 *
 *	global variables:
 *		lbpath	*lbphead	The pointer to the first
 *				 	path structure
 *		int	aflag		library must exist flag
 *
 *	 functions called:
 *		int	addfile()	lklibr.c
 *		int	getnb()		lklex.c
 *		VOID	unget()		lklex.c
 *		VOID	lkerror()	lkmain.c
 *
 *	side effects:
 *		The function addfile() may add the file to
 *		the library search list.
 */

VOID
addlib()
{
	struct lbpath *lbph;
	int libfnd = 0;

	unget(getnb());

	if (lbphead == NULL) {
		libfnd |= addfile(NULL,ip);
	} else {
		for (lbph=lbphead; lbph; lbph=lbph->next) {
			libfnd |= addfile(lbph->path,ip);
			if (aflag && libfnd)
				break;
		}
	}

	if (aflag && !libfnd) {
		lkerror("Cannot find or open library \"%s\"", ip);
	}
}

/*)Function	int	addfile(path,libfil)
 *
 *		char	*path		library path specification
 *		char	*libfil		library file specification
 *
 *	The function addfile() searches for the library file
 *	by concatenating the path and libfil specifications.
 *	if the library is found, an lbname structure is created
 *	and linked to any previously defined structures.  This
 *	linked list is used by the function fndsym() to attempt
 *	to find any undefined symbols.
 *
 *	The function does not report an error on invalid
 *	path / file specifications or if the file is not found.
 *
 *	local variables:
 *		FILE *	fp		library file pointer
 *		lbname	*lbnh		pointer to new name structure
 *		char *	str		path / file string
 *		char *	strend		end of path pointer
 *
 *	global variables:
 *		lbname	*lbnhead	The pointer to the first
 *				 	path structure
 *		lbname	*lbntail	The pointer to the last
 *				 	path structure
 *		int	objflg		linked file/library object output flag
 *
 *	 functions called:
 *		char *	new()		lksym.c
 *		char *	strto()		lksym.c
 *		VOID	free()		c_library
 *		FILE *	fopen()		c_library
 *		int	strlen()	c_library
 *		char *	strcpy()	c_library
 *		char *	strcat()	c_library
 *		char *	strchr()	c_library
 *		int	sprintf()	c_library
 *
 *	side effects:
 *		An lbname structure may be created.
 */

int
addfile(path,libfil)
char *path;
char *libfil;
{
	FILE *fp;
	struct lbname *lbnh;
	char *str, *strend;
#ifdef __unix__
	if ((path != NULL) && *path && *libfil != '/') {
		str = new (strlen(path) + strlen(libfil) + 2);
		strcpy(str,path);
		strend = str + strlen(str) - 1;
		if (*strend != '/') {
			strend[1] = '/';
			strend[2] = 0;
		}
		strcat(str,libfil);
	} else {
		str = strsto (libfil);
	}
#else
	if ((path != NULL) && (strchr(libfil,':') == NULL)) {
		str = new (strlen(path) + strlen(libfil) + 5);
		strcpy(str,path);
		strend = str + strlen(str) - 1;
		if ((*libfil == '\\' && *strend == '\\') ||
		    (*libfil ==  '/' && *strend ==  '/')) {
			*strend = '\0';
		}
		strcat(str,libfil);
	} else {
		str = new (strlen(libfil) + 5);
		strcpy(str,libfil);
	}
	if (strchr(str,FSEPX) == NULL) {
		sprintf(&str[strlen(str)], "%clib", FSEPX);
	}
#endif
	if ((fp = FOPEN(str, "r")) != NULL) {
		lbnh = (struct lbname *) new (sizeof(struct lbname));
		if (lbnhead == NULL)
			lbnhead = lbntail = lbnh;
		else
			lbntail = lbntail->next = lbnh;
#ifdef __unix__
		if ((path != NULL) && *libfil != '/')
			lbnh->path = path;
#else
		if ((path != NULL) && (strchr(libfil,':') == NULL))
			lbnh->path = path;
#endif
		lbnh->libfil = strsto (libfil);
		lbnh->libspc = str;
		lbnh->libfp = fp;
		lbnh->f_obj = objflg;
		return 1;
	} else {
		free(str);
		return 0;
	}
}

/*)Function	VOID	search()
 *
 *	The function search() looks through all the symbol tables
 *	at the end of pass 1.  If any undefined symbols are found
 *	then the function fndsym() is called. Function fndsym()
 *	searches any specified library files to automagically
 *	import the object modules containing the needed symbol.
 *
 *	After a symbol is found and imported by the function
 *	fndsym() the symbol tables are again searched.  The
 *	symbol tables are searched until no more symbols can be
 *	resolved within the library files.  This ensures that
 *	back references from one library module to another are
 *	also resolved.
 *
 *	local variables:
 *		sym	*sp		pointer to a symbol structure
 *		int	i		temporary counter
 *		int	symfnd		found a symbol flag
 *
 *	global variables:
 *		sym	*symhash[]	array of pointers to symbol tables
 *
 *	 functions called:
 *		int	fndsym()	lklibr.c
 *
 *	side effects:
 *		If a symbol is found then the library object module
 *		containing the symbol will be imported and linked.
 */

VOID
search()
{
	struct sym *sp;
	int i,symfnd;

	/*
	 * Look for undefined symbols.  Keep
	 * searching until no more symbols are resolved.
	 */
	symfnd = 1;
	while (symfnd) {
		symfnd = 0;
		/*
		 * Look through all the symbols
		 */
		for (i=0; i<NHASH; ++i) {
			sp = symhash[i];
			while (sp) {
				/* If we find an undefined symbol
				 * (one where S_DEF is not set), then
				 * try looking for it.  If we find it
				 * in any of the libraries then
				 * increment symfnd.  This will force
				 * another pass of symbol searching and
				 * make sure that back references work.
				 */
				if ((sp->s_type & S_DEF) == 0) {
					if (fndsym(sp->s_id)) {
						symfnd++;
					}
				}
				sp = sp->s_sp;
			}
		}
	}
}

/*)Function	VOID	processtag()
 *
 *		char *	line		line to process
 *		lbname	*lbnh		pointer to lbname structure
 *		int *	phashptr	pointer to hash pointer
 *
 *	The function processtag() process a library tag of an
 *	indexed library.  A library tag is any line that begin
 *	with '#' and is followed by a tag at the begining of
 *	a library.
 *
 *	local variables:
 *		char *	str		string pointer
 *		long *	hashbin		hash bin pointer
 *		long	value		a value
 *		int	nhashbin	number of hash bin minus one
 *		int	hashptr		hash pointer
 *
 *	 functions called:
 *		int	strncmp()	c_library
 *		int	strcmp()	c_library
 *		long	strtol()	c_library
 *		char *	strchr()	c_library
 *		char *	new()		lksym.c
 *		VOID	chopcrlf()	lklex.c
 *		VOID	lkerror()	lkmain.c
 *
 *	side effects:
 *		Process the tag, can throw an error if something is wrong.
 */

static
VOID
processtag(line, lbnh, phashptr)
char *line;
struct lbname *lbnh;
int *phashptr;
{
	char *str;
	long *hashbin, value;
	int nhashbin, hashptr;
	/* Proccess hash tag. */
	if (!strncmp(line, " HASH ", sizeof(" HASH ")-1)) {
		hashptr = *phashptr;
		if (hashptr >= 0) {
			str = line + sizeof(" HASH ") - 1 - 1;
			if (!hashptr) {
				value = strtol(++str, NULL, 16);
				if (value < 0 || value > MAXHASHBIT)
					lkerror("Bad hash size in library file \"%s\"", lbnh->libspc);
				nhashbin = 1 << value;
				lbnh->nhashbin = nhashbin;
				hashptr = nhashbin > 1 ? 1 : -1;
			}
			if (hashptr > 0) {
				if (lbnh->hashbin == NULL) {
					lbnh->hashbin = (long*)new (sizeof(long)*lbnh->nhashbin);
					lbnh->nhashbin--;
				}
				nhashbin = lbnh->nhashbin;
				hashbin = lbnh->hashbin;
				while (hashptr<=(nhashbin+1) && (str=strchr(str, ' '))) {
					hashbin[hashptr-1] = strtol(++str, NULL, 16);
					hashptr++;
				}
			}
			*phashptr = hashptr;
		}
	}
	/* Proccess format tag. */
	else if (!strncmp(line, " FORMAT ", sizeof(" FORMAT ")-1)) {
		str = line + sizeof(" FORMAT ") - 1;
		chopcrlf(str);
		if (strcmp(str, "DFAR"))
			lkerror("Wrong format '%s' for library file \"%s\"", str, lbnh->libspc);
	}
	/* Proccess version tag. */
	else if (!strncmp(line, " VERSION ", sizeof(" VERSION ")-1)) {
		str = line + sizeof(" VERSION ") - 1;
		value = strtol(str, NULL, 10);
		if (value != 1)
			lkerror("Wrong version '%li' for library file \"%s\"", value, lbnh->libspc);
	}
}

/*)Function	int	fndsym_noind()
 *
 *		lbname	*lbnh		pointer to lbname structure
 *		char	*name		symbol name to find
 *
 *	The function fndsym_noind() searches for a symbol
 *	in an unindexed library file, it return zero if
 *	the symbol is not found or one if found.
 *
 *	local variables:
 *		FILE *	libfp		library file pointer
 *		lbfile	*lbfh		pointer to lbfile structure
 *		char	obj[]		object name buffer
 *		char	buf[]		line buffer
 *		char	symname[]	symbol name
 *		char 	c		character
 *		long	offset		object offset
 *		long	curoffset	object current offset
 *
 *	global variables:
 *		int	obj_flag	linked file/library object output flag
 *
 *	 functions called:
 *		int	fseek()		c_library
 *		long	ftell()		c_library
 *		char *	fgets()		c_library
 *		char *	strcpy()	c_library
 *		int	sscanf()	c_library
 *		int	strncmp()	c_library
 *		char *	new()		lksym.c
 *		char *	strto()		lksym.c
 *		VOID	chopcrlf()	lklex.c
 *		VOID	loadfile()	lklibr.c
 *		VOID	lkerror()	lkmain.c
 *
 *	side effects:
 *		If the symbol is found then a new lbfile structure
 *		is created and added to the linked list of lbfile
 *		structures.  The library object module
 *		containing the symbol will be imported and linked.
 */

int
fndsym_noind(lbnh, name)
struct lbname *lbnh;
char *name;
{
	FILE *libfp;
	struct lbfile *lbfh;
	char obj[NINPUT];
	char buf[NINPUT];
	char symname[NINPUT], c;
	long offset, curoffset;

	/*
	 * Set library file pointer to begin.
	 */
	libfp = lbnh->libfp;
	if (FSEEK (libfp, lbnh->begin, SEEK_SET) != 0)
		lkerror("Cannot seek library file \"%s\"", lbnh->libspc);

	*obj = 0;
	curoffset = offset = 0;
	while (FGETS (buf, NINPUT, libfp) != NULL) {
		chopcrlf(buf);

		/*
		 * Check for 'E' line, terminate if found.
		 */
		if (buf[0] == 'E')
			break;

		/*
		 * Check for 'L' line.
		 */
		if (buf[0] == 'L') {
			if (buf[1] == '0' && buf[2] == ' ') {
				strcpy(obj, &buf[3]);
				offset = curoffset;
				curoffset = FTELL (libfp);
			}
			else if (buf[1] == '1' && buf[2] == ' ') {
				*obj = 0;
			}
			curoffset = FTELL (libfp);
			continue;
		}

		/*
		 * Not between 'L0' and 'L1' line, so continue.
		 */
		if (*obj == 0)
			continue;

		/*
		 * When a 'T line' is found terminate file scan.
		 * All 'S lines' preceed 'T lines' in .REL files.
		 */
		if (buf[0] == 'T') {
			*obj = 0;
			continue;
		}

		/*
		 * Skip everything that's not a symbol record.
		 */
		if (buf[0] != 'S')
			continue;

		sscanf(buf, "S %s %c", symname, &c);

		/*
		 * If we find a symbol definition for the
		 * symbol we're looking for, load in the
		 * file and add it to lbfhead so it gets
		 * loaded on pass number 2.
		 */
		if (strncmp(symname, name, NCPS) == 0 && c == 'D') {
			if (FSEEK (libfp, offset, SEEK_SET) != 0)
				lkerror("Cannot seek library file \"%s\"", lbnh->libspc);
			/* Add the object to lbfhead. */
			lbfh = (struct lbfile *) new (sizeof(struct lbfile));
			if (lbfhead == NULL)
				lbfhead = lbftail = lbfh;
			else
				lbftail = lbftail->next = lbfh;
			lbfh->libspc = lbnh->libspc;
			lbfh->relfil = strsto (obj);;
			lbfh->libfp = libfp;
			lbfh->offset = offset;
			lbfh->f_obj = lbnh->f_obj;
			obj_flag = lbfh->f_obj;
#if SDCDB
			SDCDBcopy (NULL, lbfh);
#endif
			loadfile (lbfh);
			return 1;
		}

	}
	return 0;
}

/*)Function	int	fndsym_cache()
 *
 *		lbname	*lbnh		pointer to lbname structure
 *		char	*name		symbol name to find
 *
 *	The function fndsym_cache() searches for a symbol
 *	in a cache library file, it return zero if
 *	the symbol is not found or one if found.
 *
 *	local variables:
 *		FILE *	libfp		library file pointer
 *		lbfile	*lbfh		pointer to lbfile structure
 *		lbfile	*lbf		pointer to temporary lbfile structure
 *		char	relfil[]	[.REL] file specification
 *		char	buf[]		line buffer
 *		char	symname[]	[.REL] file symbol string
 *		char	*path		file specification path
 *		char	*str		combined path and file specification
 *		char	*strend		end of path pointer
 *		char	c		[.REL] file input character
 *		int	lbscan		scan library file flag
 *
 *	global variables:
 *		int	obj_flag	linked file/library object output flag
 *
 *	 functions called:
 *		FILE *	fopen()		c_library
 *		int	fclose()	c_library
 *		int	fseek()		c_library
 *		long	ftell()		c_library
 *		char *	fgets()		c_library
 *		VOID	free()		c_library
 *		char *	strcpy()	c_library
 *		char *	strcat()	c_library
 *		int	strlen()	c_library
 *		int	sscanf()	c_library
 *		int	sprintf()	c_library
 *		int	strcmp()	c_library
 *		int	strncmp()	c_library
 *		char *	new()		lksym.c
 *		char *	strto()		lksym.c
 *		VOID	chopcrlf()	lklex.c
 *		VOID	loadfile()	lklibr.c
 *		VOID	lkerror()	lkmain.c
 *
 *	side effects:
 *		If the symbol is found then a new lbfile structure
 *		is created and added to the linked list of lbfile
 *		structures.  The file containing the found symbol
 *		is linked.
 */

int
fndsym_cache(lbnh, name)
struct lbname *lbnh;
char *name;
{
	FILE *libfp, *fp;
	struct lbfile *lbfh, *lbf;
	char relfil[NINPUT+2];
	char buf[NINPUT+2];
	char symname[NINPUT];
	char *path,*str,*strend,c;
	int lbscan;

	/*
	 * Set library file pointer to 0.
	 */
	libfp = lbnh->libfp;
	if (FSEEK (libfp, 0, SEEK_SET) != 0)
		lkerror("Cannot seek library file \"%s\"", lbnh->libspc);
	path = lbnh->path;

	/*
	 * Read in a line from the library file.
	 * This is the relative file specification
	 * for a .REL file in this library.
	 */
	while (FGETS (relfil, NINPUT, libfp) != NULL) {
		chopcrlf(relfil);
#ifdef __unix__
		if ((path != NULL) && *path && *relfil != '/') {
			str = new (strlen(path) + strlen(relfil) + 2);
			strcpy(str,path);
			strend = str + strlen(str) - 1;
			if (*strend != '/') {
				strend[1] = '/';
				strend[2] = 0;
			}
			strcat(str,relfil);
		} else {
			str = strsto (relfil);
		}
#else
		if (path != NULL) {
			str = new (strlen(path)+strlen(relfil)+5);
			strcpy(str,path);
			strend = str + strlen(str) - 1;
			if ((*relfil == '\\' && *strend == '\\') ||
				(*relfil ==  '/' && *strend ==  '/')) {
				*strend = '\0';
			}
			strcat(str,relfil);
		} else {
			str = new (strlen(relfil) + 5);
			strcpy(str,relfil);
		}
		if(strchr(str,FSEPX) == NULL) {
			sprintf(&str[strlen(str)], "%crel", FSEPX);
		}
#endif
		/*
		 * Scan only files not yet loaded
		 */
		for (lbf=lbfhead, lbscan=1; lbf&&lbscan; lbf=lbf->next) {
			if (lbf->filspc != NULL && strcmp(lbf->filspc,str) == 0) {
				lbscan = 0;
			}
		}
		if (lbscan && (fp = FOPEN(str, "r")) != NULL) {

			/*
			 * Read in the object file.  Look for lines that
			 * begin with "S" and end with "D".  These are
			 * symbol table definitions.  If we find one, see
			 * if it is our symbol.  Make sure we only read in
			 * our object file and don't go into the next one.
			 */
			while (FGETS (buf, NINPUT, fp) != NULL) {
				chopcrlf(buf);

				/*
				 * When a 'T line' is found terminate file scan.
				 * All 'S lines' preceed 'T lines' in .REL files.
				 */
				if (buf[0] == 'T')
					break;

				/*
				 * Skip everything that's not a symbol record.
				 */
				if (buf[0] != 'S')
					continue;

				sscanf(buf, "S %s %c", symname, &c);

				/*
				 * If we find a symbol definition for the
				 * symbol we're looking for, load in the
				 * file and add it to lbfhead so it gets
				 * loaded on pass number 2.
				 */
				if (strncmp(symname, name, NCPS) == 0 && c == 'D') {

					lbfh = (struct lbfile *) new (sizeof(struct lbfile));
					if (lbfhead == NULL)
						lbfhead = lbftail = lbfh;
					else
						lbftail = lbftail->next = lbfh;
					lbfh->libspc = lbnh->libspc;
					lbfh->filspc = str;
					lbfh->relfil = strsto (relfil);
					lbfh->f_obj = lbnh->f_obj;
					FCLOSE (fp);
					obj_flag = lbfh->f_obj;
#if SDCDB
					SDCDBcopy (NULL, lbfh);
#endif
					loadfile (lbfh);
					return 1;

				}

			}
			FCLOSE (fp);
		}
		free (str);
	}
	return 0;
}

/*)Function	VOID	fndsym(name)
 *
 *		char	*name		symbol name to find
 *
 *	The function fndsym() searches through all combinations of the
 *	library path specifications (input by the -k option) and the
 *	library file specifications (input by the -l option) that
 *	lead to an existing file.
 *
 *	The file specification may be formed in one of two ways:
 *
 *	(1)	If the library file contained an absolute
 *		path/file specification then this becomes filspc.
 *		(i.e. C:\...)
 *
 *	(2)	If the library file contains a relative path/file
 *		specification then the concatenation of the path
 *		and this file specification becomes filspc.
 *		(i.e. \...)
 *
 *	The structure lbfile is created for the first library
 *	object file which contains the definition for the
 *	specified undefined symbol.
 *
 *	If the library file [.LIB] contains file specifications for
 *	non existant files, no errors are returned.
 *
 *	local variables:
 *		FILE	*libfp		file handle for library file
 *		lbname	*lbnh		pointer to lbname structure
 *		lbfile	*lbfh		pointer to lbfile structure
 *		char	symname[]	line input buffer / symbol name
 *		char	*obj		object file name
 *		char	*offstr		object offset string
 *		char	first		first line flag
 *		long	begin		file offset of symbol index
 *		long	offset		file offset of object
 *		int	hashptr		hash table pointer
 *
 *	global variables:
 *		lbname	*lbnhead	The pointer to the first
 *				 	name structure
 *		lbfile	*lbfhead	The pointer to the first
 *				 	file structure
 *		int	obj_flag	linked file/library object output flag
 *
 *	 functions called:
 *		int	fseek()		c_library
 *		int	fgets()		c_library
 *		long	ftell()		c_library
 *		VOID	loadfile()	lklibr.c
 *		char *	new()		lksym.c
 *		char *	strto()		lksym.c
 *		char *	strchr()	c_library
 *		int	strcmp()	c_library
 *		VOID	processtag()	lklibr.c
 *		VOID	fndsym_cache()	lklibr.c
 *		VOID	fndsym_noind()	lklibr.c
 *		VOID	lkerror()	lkmain.c
 *
 *	side effects:
 *		If the symbol is found then a new lbfile structure
 *		is created and added to the linked list of lbfile
 *		structures.  The file containing the found symbol
 *		is linked.
 */

int
fndsym(name)
char *name;
{
	FILE *libfp;
	struct lbname *lbnh;
	struct lbfile *lbfh;
	char symname[NINPUT];
	char *obj,*offstr,first;
	long begin, offset;
	int hashptr;

	/* Search through every library in the linked list "lbnhead". */
	for (lbnh=lbnhead; lbnh; lbnh=lbnh->next) {
		first = 0;
		offset = 0;
		hashptr = 0;
		libfp = lbnh->libfp;
		begin = lbnh->begin;
		if (FSEEK (libfp, begin, SEEK_SET) != 0)
			lkerror("Cannot seek library file \"%s\"", lbnh->libspc);
		/* Parse header/metadata/comments at the begining. */
		while (FGETS (symname, NINPUT, libfp) != NULL) {
			if (*symname == '#') {
				/* Proccess header tag. */
				processtag(symname+1, lbnh, &hashptr);
				first = 1;
				begin = FTELL(libfp);
				/* Should not happen, skip to next. */
				if (begin <= 0)
					break;
				lbnh->begin = begin;
				continue;
			}
			else {
				if (*symname != '\n') {
					obj = strchr(symname, ' ');
					/* If the first line contain no separator and first char */
					/* is not '#', then the format is a cache library. */
					if (first == 0) {
						first = 1;
						if (obj == NULL) {
							if (fndsym_cache(lbnh, name))
								return 1;
							break;
						}
					}
					/* If the line contain one separators, */
					/* then the format is an unindexed library. */
					if (obj && !strchr(obj+1, ' ')) {
						if (fndsym_noind(lbnh, name))
							return 1;
						break;
					}
				}
			}
			/* Have an hash table? if so seek to to proper location. */
			if (lbnh->hashbin) {
				offset = lbnh->hashbin[djb2hash(name)&lbnh->nhashbin];
				/* Offset zero mean no symbol for that bin, therefore skip. */
				if (offset == 0)
					break;
				if (FSEEK (libfp, begin+offset, SEEK_SET) != 0)
					lkerror("Cannot seek library file \"%s\"", lbnh->libspc);
				if (FGETS (symname, NINPUT, libfp) == NULL)
					break;
			}
			/* Scan through all symbols. */
			do {
				/* Scan object name, space char is the separator. */
				obj = strchr(symname, ' ');
				/* Separator not found, skip to the next file. */
				if (obj == NULL)
					break;
				*obj++ = 0;
				/* Symbol name match ? */
				if (strcmp(symname, name) == 0) {
					/* Seek object offset, space char is the separator. */
					offstr = strchr(obj, ' ');
					/* Space not found, something wrong with the lib file,
					   skip to the next file. */
					if (offstr == NULL)
						break;
					*offstr++ = 0;
					/* Convert offset string to long */
					offset = strtol(offstr, NULL, 16);
					/* Should not happen. */
					if (offset <= 0)
						break;
					offset += begin;
					/* Again should not happen. */
					if (offset <= 0)
						break;
					/* Add the object to lbfhead. */
					lbfh = (struct lbfile *) new (sizeof(struct lbfile));
					if (lbfhead == NULL)
						lbfhead = lbftail = lbfh;
					else
						lbftail = lbftail->next = lbfh;
					lbfh->libspc = lbnh->libspc;
					lbfh->relfil = strsto (obj);
					lbfh->libfp = libfp;
					lbfh->offset = offset;
					lbfh->f_obj = lbnh->f_obj;
					obj_flag = lbfh->f_obj;
#if SDCDB
					SDCDBcopy (NULL, lbfh);
#endif
					loadfile (lbfh);
					return 1;
				}
			} while (FGETS (symname, NINPUT, libfp) != NULL);
			break;
		}
	}
	return 0;
}

/*)Function	VOID	library()
 *
 *	The function library() links all the library object files
 *	contained in the lbfile structures.
 *
 *	local variables:
 *		lbfile	*lbfh		pointer to lbfile structure
 *
 *	global variables:
 *		lbfile	*lbfhead	pointer to first lbfile structure
 *		int	obj_flag	linked file/library object output flag
 *
 *	 functions called:
 *		VOID	loadfile	lklibr.c
 *
 *	side effects:
 *		Links all files contained in the lbfile structures.
 */

VOID
library()
{
	struct lbfile *lbfh;

	for (lbfh=lbfhead; lbfh; lbfh=lbfh->next) {
		obj_flag = lbfh->f_obj;
		loadfile(lbfh);
	}
}

/*)Function	VOID	loadfile(lbfh)
 *
 *		lbfile	*lbfh		pointer to lbfile structure
 *
 *	The function loadfile() links the library object module.
 *
 *	local variables:
 *		FILE	*fp		file handle
 *		char	str[]		file input line
 *
 *	global variables:
 *		char	*ip		pointer to linker input string
 *
 *	 functions called:
 *		VOID	chopcrlf()	lklex.c
 *		int	fclose()	c_library
 *		int	fgets()		c_library
 *		FILE *	fopen()		c_library
 *		int	fseek()		c_library
 *		int	ferror()	c_library
 *		VOID	lklink()	lkmain.c
 *		VOID	lkerror()	lkmain.c
 *
 *	side effects:
 *		If file exists it is linked.
 */

VOID
loadfile(lbfh)
struct lbfile *lbfh;
{
	FILE *fp;
	char str[NINPUT];

	if (lbfh->filspc == NULL) {
		/* The object is embedded in a library file. */

		fp = lbfh->libfp;

		/* Make sure the object is enclosed by 'L0' and 'L1' line. */
		if (FSEEK(fp, lbfh->offset, SEEK_SET) == 0) {
			if (FGETS(str, sizeof(str), fp) != NULL) {
				if (str[0] == 'L' && str[1] == '0') {
					while (FGETS(str, sizeof(str), fp) != NULL) {
						if (str[0] == 'L' && str[1] == '1')
							return;
						chopcrlf(str);
						ip = str;
						lklink();
					}
				}
			}
		}

		lkerror("%s object \"%s\" in library \"%s\"",
			FERROR(fp) ? "Failed to read" : "Wrong format for",
			lbfh->relfil, lbfh->libspc);

	} else {
		/* The object is in an external file. */

		if ((fp = FOPEN(lbfh->filspc,"r")) != NULL) {
			while (FGETS(str, sizeof(str), fp) != NULL) {
				chopcrlf(str);
				ip = str;
				lklink();
			}
			FCLOSE(fp);
		}

		if (fp == NULL || FERROR(fp))
			lkerror("Failed to read \"%s\"", lbfh->filspc);

	}
}
