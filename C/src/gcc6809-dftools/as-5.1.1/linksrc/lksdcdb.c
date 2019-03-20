/* lksdcdb.c */

/*
 *  Copyright (C) 2001-2014  Alan R. Baldwin
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
 */

#include "aslink.h"

#if SDCDB

/*Module	lkcdb.c
 *
 *	The module lkcdb.c contains the functions
 *	required to create a SDCDB debug file.
 *
 *	lksdcdb.c contains the following functions:
 *		VOID	SDCDBfopen()
 *		VOID	SDCDBcopy()
 *		VOID	DefineSDCDB()
 */

/*)Function	VOID	SDCDBfopen()
 * 
 *	The function SDCDBfopen() opens the SDCDB output file
 *	and sets the map flag, mflag, to create a map file.
 *	SDCDB processing is performed during map generation.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		int	yflag		SDCDB Debug flag
 *		FILE *	yfp		SDCDB Debug File handle
 *		struct lfile *linkp	Pointer to the Linker output file name
 *		int	mflag		Map output flag
 *
 *	functions called:
 *		FILE *	afile()		lkmain.c
 *		VOID	lkerror()	lkmain.c
 *
 *	side effects:
 *		The SDCDB output file is opened.
 *		Failure to open the file will
 *		terminate the linker.
 */

VOID SDCDBfopen(void)
{
	if (yflag) {
		yfp = afile(linkp->f_idp, "cdb", 1);
		if (yfp == NULL) {
			lkerror("Cannot create SDCDB file");
		}
		mflag = 1;
	}
}


/*)Function	VOID	SDCDBcopy()
 * 
 *		char *	str             pointer to the file spec
 *		lbfile	*lbfh		pointer to lbfile structure
 *
 *	The function SDCDBcopy() copies an existing cdb file
 *	into the linker cdb file.
 *
 * 	The function is called from lklex.c and lklibr.c
 *
 *	local variables:
 *		FILE *	xfp		file handle
 *		char	line[]		line from file
 *		char *	sep		filename separator
 *		char *	filename	cdb file name
 *		int	len		string length
 *		int	len2		string length 2
 *
 *	global variables:
 *		int	yflag		SDCDB Debug flag
 *		FILE *	yfp		SDCDB Debug File handle
 *
 *	functions called:
 *		FILE *	afile()		lkmain.c
 *		int	fgets()		c_library
 *		int	fprintf()	c_library
 *		int	fclose()	c_library
 *
 *	side effects:
 *		SDCDB cdb file is copied into
 *		the linker cdb output file.
 */

VOID SDCDBcopy(str, lbfh)
char * str;
struct lbfile *lbfh;
{
	FILE * xfp;
	char line[NINPUT], *sep, *filename;
	int len, len2;

	/*
	 * Copy cdb file if present and requested.
	 */
	if (yflag && yfp) {

		if (str == NULL && lbfh->filspc == NULL) {

			filename = NULL;

#ifdef __unix__
			sep = strrchr(lbfh->libspc, '/');
#else
			sep = strrchr(lbfh->libspc, '\\');
#endif
			len = sep ? sep - lbfh->libspc + 1 : 0;
			if (len < NINPUT-1) {
				strncpy(line, lbfh->libspc, len);
				len2 = snprintf(&line[len], NINPUT-len, "%s", lbfh->relfil);
				if (len2 > 0 && len+len2 < NINPUT-1) {
					filename = line;
				}
			}

		} else {

			filename = str ? str : lbfh->filspc;

		}

		if (filename != NULL) {
			xfp = afile(filename,"cdb",0);
			if (xfp) {
				while (fgets(line, sizeof(line), xfp) != NULL) {
					fprintf(yfp, "%s", line);
				}
				fclose(xfp);
			}
		}

	}
}

/*)Function	VOID	DefineSDCDB()
 * 
 *		char *	name		pointer to the symbol string
 *		a_uint	value		value of symbol
 *
 *	The function DefineSDCDB() processes the symbols into
 *	SDCDB commands for inclusion in the SDCDB output file.
 *
 * 	The function is called from lstarea in lklist.c
 *	for each symbol.
 *
 *	local variables:
 *		int	j		argument count
 *		char *	p1		temporary string pointer
 *
 *	global variables:
 *		FILE *	yfp		SDCDB Debug File handle
 *
 *	functions called:
 *		int	fprintf()	c_library
 *		int	strchr()	c_library
 *
 *	side effects:
 *		SDCDB debug symbols are placed
 *		into the output file.
 */

VOID DefineSDCDB(name, value)
char *name;
a_uint value;
{
	int  j;
	char *p1;

	/* no output if file is not open */
	if (yfp == NULL) return;

	/*
	 * SDC symbols have 3 or more $ characters
	 */
	j = 0;
	p1 = name;
	while ((p1 = strchr(p1, '$')) != NULL) {
		j += 1;
	}

	if (j > 2) {
#ifdef	LONGINT
		fprintf(yfp, "L:%s:%lX\n", name ,value);
#else
		fprintf(yfp, "L:%s:%X\n", name ,value);
#endif
	}

}

#endif

