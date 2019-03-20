/* lklibr.c */

/*
 *  Copyright (C) 1989-2009  Alan R. Baldwin
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
 */

#include "aslink.h"

/*)Module	lklibr.c
 *
 *	The module lklibr.c contains the functions which
 *	(1) specify the path(s) to library files [.LIB]
 *	(2) specify the library file(s) [.LIB] to search
 *	(3) search the library files for specific symbols
 *	    and link the module containing this symbol
 *
 *	lklibr.c contains the following functions:
 *		VOID	addpath()
 *		VOID	addlib()
 *		VOID	addfile()
 *		VOID	search()
 *		VOID	fndsym()
 *		VOID	library()
 *		VOID	loadfile()
 *
 */

/*)Function	VOID	addpath()
 *
 *	The function addpath() creates a linked structure containing
 *	the paths to various object module library files.
 *
 *	local variables:
 *		lbpath	*lbph		pointer to new path structure
 *		lbpath	*lbp		temporary pointer
 *
 *	global variables:
 *		lbpath	*lbphead	The pointer to the first
 *				 	path structure
 *
 *	 functions called:
 *		int	getnb()		lklex.c
 *		VOID *	new()		lksym.c
 *		int	strlen()	c_library
 *		char *	strcpy()	c_library
 *		VOID	unget()		lklex.c
 *
 *	side effects:
 *		An lbpath structure may be created.
 */

VOID
addpath()
{
	struct lbpath *lbph, *lbp;

	lbph = (struct lbpath *) new (sizeof(struct lbpath));
	if (lbphead == NULL) {
		lbphead = lbph;
	} else {
		lbp = lbphead;
		while (lbp->next)
			lbp = lbp->next;
		lbp->next = lbph;
	}
	unget(getnb());
	lbph->path = (char *) new (strlen(ip)+1);
	strcpy(lbph->path, ip);
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
 *
 *	global variables:
 *		lbpath	*lbphead	The pointer to the first
 *				 	path structure
 *
 *	 functions called:
 *		VOID	addfile()	lklibr.c
 *		int	getnb()		lklex.c
 *		VOID	unget()		lklex.c
 *
 *	side effects:
 *		The function addfile() may add the file to
 *		the library search list.
 */

VOID
addlib()
{
	struct lbpath *lbph;

	unget(getnb());

	if (lbphead == NULL) {
		addfile(NULL,ip);
		return;
	}	
	for (lbph=lbphead; lbph; lbph=lbph->next) {
		addfile(lbph->path,ip);
	}
}

/*)Function	VOID	addfile(path,libfil)
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
 *		lbname	*lbnh		pointer to new name structure
 *		lbname	*lbn		temporary pointer
 *		char *	str		path / file string
 *		char *	strend		end of path pointer
 *
 *	global variables:
 *		lbname	*lbnhead	The pointer to the first
 *				 	path structure
 *		int	objflg		linked file/library object output flag
 *
 *	 functions called:
 *		VOID *	malloc()	c_library
 *		int	strlen()	c_library
 *		char *	strcpy()	c_library
 *
 *	side effects:
 *		An lbname structure may be created.
 */

VOID
addfile(path,libfil)
char *path;
char *libfil;
{
	FILE *fp;
	char *str, *strend;
	struct lbname *lbnh, *lbn;

	if ((path != NULL) && (strchr(libfil,':') == NULL)){
		str = (char *) malloc (strlen(path) + strlen(libfil) + 5);
		strcpy(str,path);
		strend = str + strlen(str) - 1;
		if ((*libfil == '\\' && *strend == '\\') ||
		    (*libfil ==  '/' && *strend ==  '/')) {
			*strend = '\0';
		}
		strcat(str,libfil);
	} else {
		str = (char *) malloc (strlen(libfil) + 5);
		strcpy(str,libfil);
	}
	if(strchr(str,FSEPX) == NULL) {
		sprintf(&str[strlen(str)], "%clib", FSEPX);
	}
	if ((fp = fopen(str, "r")) != NULL) {
		fclose(fp);
		lbnh = (struct lbname *) new (sizeof(struct lbname));
		if (lbnhead == NULL) {
			lbnhead = lbnh;
		} else {
			lbn = lbnhead;
			while (lbn->next)
				lbn = lbn->next;
			lbn->next = lbnh;
		}
		if ((path != NULL) && (strchr(libfil,':') == NULL)){
			lbnh->path = path;
		}
		lbnh->libfil = (char *) new (strlen(libfil) + 1);
		strcpy(lbnh->libfil,libfil);
		lbnh->libspc = str;
		lbnh->f_obj = objflg;
	} else {
		free(str);
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
 *		int	i		temporary counter
 *		sym	*sp		pointer to a symbol structure
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
 *		char	buf[]		[.REL] file input line
 *		char	c		[.REL] file input character
 *		FILE	*fp		file handle for object file
 *		lbfile	*lbf		temporary pointer
 *		lbfile	*lbfh		pointer to lbfile structure
 *		int	lbscan		scan library file flag
 *		FILE	*libfp		file handle for library file
 *		lbname	*lbnh		pointer to lbname structure
 *		char	*path		file specification path
 *		char	relfil[]	[.REL] file specification
 *		char	*str		combined path and file specification
 *		char	*strend		end of path pointer
 *		char	symname[]	[.REL] file symbol string
 *
 *	global variables:
 *		lbname	*lbnhead	The pointer to the first
 *				 	name structure
 *		lbfile	*lbfhead	The pointer to the first
 *				 	file structure
 *		int	obj_flag	linked file/library object output flag
 *
 *	 functions called:
 *		VOID	chopcrlf()	lklex.c
 *		int	fclose()	c_library
 *		int	fgets()		c_library
 *		FILE	*fopen()	c_library
 *		VOID	free()		c_library
 *		VOID	lkexit()	lkmain.c
 *		VOID	loadfile()	lklibr.c
 *		VOID *	malloc()	c_library
 *		char *	sprintf()	c_library
 *		int	sscanf()	c_library
 *		char *	strcat()	c_library
 *		char *	strchr()	c_library
 *		char *	strcpy()	c_library
 *		int	strlen()	c_library
 *		int	strncmp()	c_library
 *		VOID	unget()		lklex.c
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
	FILE *libfp, *fp;
	struct lbname *lbnh;
	struct lbfile *lbfh, *lbf;
	char relfil[NINPUT+2];
	char buf[NINPUT+2];
	char symname[NINPUT];
	char *path,*str,*strend;
	char c;
	int lbscan;

	/*
	 * Search through every library in the linked list "lbnhead".
	 */

/*1*/	for (lbnh=lbnhead; lbnh; lbnh=lbnh->next) {
		if ((libfp = fopen(lbnh->libspc, "r")) == NULL) {
			fprintf(stderr, "Cannot open library file %s\n",
				lbnh->libspc);
			lkexit(ER_FATAL);
		}
		path = lbnh->path;

		/*
		 * Read in a line from the library file.
		 * This is the relative file specification
		 * for a .REL file in this library.
		 */

/*2*/		while (fgets(relfil, NINPUT, libfp) != NULL) {
		    relfil[NINPUT+1] = '\0';
		    chopcrlf(relfil);
		    if (path != NULL) {
			str = (char *) malloc (strlen(path)+strlen(relfil)+5);
			strcpy(str,path);
			strend = str + strlen(str) - 1;
			if ((*relfil == '\\' && *strend == '\\') ||
			    (*relfil ==  '/' && *strend ==  '/')) {
				*strend = '\0';
			}
			strcat(str,relfil);
		    } else {
			str = (char *) malloc (strlen(relfil) + 5);
			strcpy(str,relfil);
		    }
		    if(strchr(str,FSEPX) == NULL) {
			sprintf(&str[strlen(str)], "%crel", FSEPX);
		    }
		    /*
		     * Scan only files not yet loaded
		     */
		    for (lbf=lbfhead, lbscan=1; lbf&&lbscan; lbf=lbf->next) {
			if (strcmp(lbf->filspc,str) == 0) {
			    lbscan = 0;
			}
		    }
/*3*/		    if (lbscan && (fp = fopen(str, "r")) != NULL) {

			/*
			 * Read in the object file.  Look for lines that
			 * begin with "S" and end with "D".  These are
			 * symbol table definitions.  If we find one, see
			 * if it is our symbol.  Make sure we only read in
			 * our object file and don't go into the next one.
			 */
			
/*4*/			while (fgets(buf, NINPUT, fp) != NULL) {

			buf[NINPUT+1] = '\0';
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
/*5*/			if (strncmp(symname, name, NCPS) == 0 && c == 'D') {

			lbfh = (struct lbfile *) new (sizeof(struct lbfile));
			if (lbfhead == NULL) {
				lbfhead = lbfh;
			} else {
				lbf = lbfhead;
				while (lbf->next)
					lbf = lbf->next;
				lbf->next = lbfh;
			}
			lbfh->libspc = lbnh->libspc;
			lbfh->filspc = str;
			lbfh->relfil = (char *) new (strlen(relfil) + 1);
			strcpy(lbfh->relfil,relfil);
			lbfh->f_obj = lbnh->f_obj;
			fclose(fp);
			fclose(libfp);
			obj_flag = lbfh->f_obj;

#if SDCDB
			SDCDBcopy(str);
#endif

			loadfile(str);
			return (1);

/*5*/			}

/*4*/			}
		    fclose(fp);
/*3*/		    }
		    free(str);
/*2*/		}
		fclose(libfp);
/*1*/	}
	return(0);
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
		loadfile(lbfh->filspc);
	}
}

/*)Function	VOID	loadfile(filspc)
 *
 *		char	*filspc		library object file specification
 *
 *	The function loadfile() links the library object module.
 *
 *	local variables:
 *		FILE	*fp		file handle
 *		int	i		input line length
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
 *		VOID	link()		lkmain.c
 *
 *	side effects:
 *		If file exists it is linked.
 */

VOID
loadfile(filspc)
char *filspc;
{
	FILE *fp;
	char str[NINPUT];

	if ((fp = fopen(filspc,"r")) != NULL) {
		while (fgets(str, sizeof(str), fp) != NULL) {
			chopcrlf(str);
			ip = str;
			link();
		}
		fclose(fp);
	}
}
