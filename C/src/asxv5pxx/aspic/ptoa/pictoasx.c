/* pictoasx.c */

/*
 *  Copyright (C) 2002-2009  Alan R. Baldwin
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

#include <stdio.h>
#include <setjmp.h>
#include <string.h>

#ifdef WIN32
#include <stdlib.h>
#else
#include <alloc.h>
#endif

#include "ptoa.h"

/*)Module	pictoasx.c
 *
 *	The module pictoasx.c converts pic assembler definition
 *	files to aspic compatable definition files.
 *
 *	pictoasx.c contains the following functions:
 *		FILE *	afile()
 *		VOID	afilex()
 *		VOID	ptoaexit()
 *		char	endline()
 *		int	fndidx()
 *		int	get()
 *		VOID	getid()
 *		int	axgetline()
 *		int	getnb()
 *		int	main()
 *		int	more()
 *		int	changekey()
 *		VOID	scanline()
 *		VOID	unget()
 *		VOID	usage()
 *
 *	pictoasx.c contains the array char *usetxt[] which
 *	references the usage text strings printed by usage().
 */

/*)Function	int	main(argc, argv)
 *
 *		int	argc		argument count
 *		char *	argv		array of pointers to argument strings
 *
 *	The function main() is responsible for opening the input and
 *	output files and processing the input pic assembler definition
 *	file into an aspic definition file.
 *
 *	local variables:
 *		char *	p		pointer to argument string
 *		int	c		character from argument string
 *		int	i		argument loop counter
 *
 *	global variables:
 *		int	zflag		-z, enable symbol case sensitivity
 *		FILE *	ifp		input file handle
 *		FILE *	ofp		relocation output file handle
 *
 *	called functions:
 *		FILE *	afile()		pictoasx.c
 *		VOID	ptoaexit()	pictoasx.c
 *		int	fprintf()	c-library
 *		int	axgetline()	pictoasx.c
 *		VOID	usage()		pictoasx.c
 *
 *	side effects:
 *		Completion of main() completes the assembly process.
 *		REL, LST, and/or SYM files may be generated.
 */

int
main(argc, argv)
int argc;
char *argv[];
{
	char *p;
	int c, i;

	fprintf(stdout, "\n");
	for (i=1; i<argc; ++i) {
		p = argv[i];
		if (*p == '-') {
			if (ifp != NULL)
				usage(ER_FATAL);
			++p;
			while ((c = *p++) != 0)
				switch(c) {

				case 'z':
				case 'Z':
					++zflag;
					break;

				default:
					usage(ER_FATAL);
				}
		} else {
			ifp = afile(p, "", 0);
			if (ifp != NULL) {
				ofp = afile(p, "def", 1);
			}
		}
	}
	if (ifp == NULL)
		usage(ER_WARNING);
	while axgetline()) {
		fprintf(ofp, "%s\n", ib);
	}
	ptoaexit(ER_NONE);
	return(0);
}

/*)Function	VOID	ptoaexit(i)
 *
 *			int	i	exit code
 *
 *	The function ptoaexit() explicitly closes all open
 *	files and then terminates the program.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		FILE *	ifp		input file handle
 *		FILE *	ofp		output file handle
 *
 *	functions called:
 *		int	fclose()	c-library
 *		VOID	exit()		c-library
 *
 *	side effects:
 *		All files closed. Program terminates.
 */

VOID
ptoaexit(i)
int i;
{
	if (ifp != NULL) fclose(ifp);
	if (ofp != NULL) fclose(ofp);
	exit(i);
}

/*)Function	FILE *	afile(fn, ft, wf)
 *
 *		char *	fn		file specification string
 *		char *	ft		file type string
 *		int	wf		read(0)/write(1) flag
 *
 *	The function afile() opens a file for reading or writing.
 *
 *	afile() returns a file handle for the opened file or aborts
 *	the assembler on an open error.
 *
 *	local variables:
 *		FILE *	fp		file handle for opened file
 *
 *	global variables:
 *		char	afn[]		afile() constructed filespec
 *		int	afp		afile() constructed path length
 *		char	afntmp[]	afilex() constructed filespec
 *		int	afptmp		afilex() constructed path length
 *
 *	functions called:
 *		VOID	afilex()	pictoasx.c
 *		FILE *	fopen()		c_library
 *		int	fprintf()	c_library
 *		char *	strcpy()	c_library
 *
 *	side effects:
 *		File is opened for read or write.
 */

FILE *
afile(fn, ft, wf)
char *fn;
char *ft;
int wf;
{
	FILE *fp;

	afilex(fn, ft);

	if ((fp = fopen(afntmp, wf?"w":"r")) == NULL) {
	    fprintf(stderr, "%s: cannot %s.\n", afntmp, wf?"create":"open");
	    ptoaexit(ER_FATAL);
	}

	strcpy(afn, afntmp);
	afp = afptmp;

	return (fp);
}

/*)Function	VOID	afilex(fn, ft)
 *
 *		char *	fn		file specification string
 *		char *	ft		file type string
 *
 *	The function afilex() processes the file specification string:
 *		(1)	If the file type specification string ft
 *			is not NULL then a file specification is
 *			constructed with the file path\name in fn
 *			and the extension in ft.
 *		(2)	If the file type specification string ft
 *			is NULL then the file specification is
 *			constructed from fn.  If fn does not have
 *			a file type then the default source file
 *			type dsft is appended to the file specification.
 *
 *	afilex() aborts the assembler on a file specification length error.
 *
 *	local variables:
 *		int	c		character value
 *		char *	p1		pointer into filespec string afntmp
 *		char *	p2		pointer into filespec string fn
 *		char *	p3		pointer to filetype string ft
 *
 *	global variables:
 *		char	afntmp[]	afilex() constructed filespec
 *		int	afptmp		afilex() constructed path length
 *
 *	functions called:
 *		VOID	ptoaexit()	pictoasx.c
 *		int	fndidx()	pictoasx.c
 *		int	fprintf()	c_library
 *		char *	strcpy()	c_library
 *
 *	side effects:
 *		File specification string may be modified.
 */

VOID
afilex(fn, ft)
char *fn;
char *ft;
{
	char *p1, *p2;
	int c;

	if (strlen(fn) > (FILSPC-5)) {
		fprintf(stderr, "File Specification %s is too long.", fn);
		ptoaexit(ER_FATAL);
	}

	/*
	 * Save the File Name Index
	 */
	strcpy(afntmp, fn);
	afptmp = fndidx(afntmp);

	/*
	 * Skip to File Extension separator
	 */
	p1 = strrchr(&afntmp[afptmp], FSEPX);

	/*
	 * Copy File Extension
	 */
	 p2 = ft;
	 if (*p2 == 0) {
		if (p1 == NULL) {
			p2 = "inc";
		} else {
			p2 = strrchr(&fn[afptmp], FSEPX) + 1;
		}
	}
	if (p1 == NULL) {
		p1 = &afntmp[strlen(afntmp)];
	}
	*p1++ = FSEPX;
	while ((c = *p2++) != 0) {
		if (p1 < &afntmp[FILSPC-1])
			*p1++ = c;
	}
	*p1++ = 0;
}

/*)Function	int	fndidx(str)
 *
 *		char *	str		file specification string
 *
 *	The function fndidx() scans the file specification string
 *	to find the index to the file name.  If the file
 *	specification contains a 'path' then the index will
 *	be non zero.
 *
 *	fndidx() returns the index value.
 *
 *	local variables:
 *		char *	p1		temporary pointer
 *		char *	p2		temporary pointer
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		char *	strrchr()	c_library
 *
 *	side effects:
 *		none
 */

int
fndidx(str)
char *str;
{
	char *p1, *p2;

	/*
	 * Skip Path Delimiters
	 */
	p1 = str;
	if ((p2 = strrchr(p1,  ':')) != NULL) { p1 = p2 + 1; }
	if ((p2 = strrchr(p1,  '/')) != NULL) { p1 = p2 + 1; }
	if ((p2 = strrchr(p1, '\\')) != NULL) { p1 = p2 + 1; }

	return(p1 - str);
}

/*)Function	int	getid(id,c)
 *
 *		char *	id		a pointer to a string of
 *					maximum length NCPS-1
 *		int	c		mode flag
 *					>=0	this is first character to
 *						copy to the string buffer
 *					<0	skip white space, first
 *						character must be a LETTER
 *
 *	The function getid() scans the current text line from the
 *	current position copying the next LETTER | DIGIT string into
 *	the external string buffer id[].  The string ends when a non
 *	LETTER or DIGIT character is found. The maximum number of characters
 *	copied is NCPS-1.  If the input string is larger than NCPS-1
 *	characters then the string is truncated.  The string is always
 *	NULL terminated.  If the mode argument (c) is >=0 then (c) is
 *	the first character copied to the string buffer, if (c) is <0
 *	then intervening white space (SPACES and TABS) are skipped and
 *	the first character found must be a LETTER else a 'q' error
 *	terminates the parse of this text line.
 *
 *	local variables:
 *		char *	p		pointer to external string buffer
 *
 *	global variables:
 *		char	ctype[]		a character array which defines the
 *					type of character being processed.
 *					This index is the character
 *					being processed.
 *
 *	called functions:
 *		VOID	ptoaexit()	pictoasx.c
 *		int	get()		pictoasx.c
 *		int	getnb()		pictoasx.c
 *		VOID	unget()		pictoasx.c
 *
 *	side effects:
 *		Use of getnb(), get(), and unget() updates the
 *		global pointer ip, the position in the current
 *		text line.
 */

VOID
getid(id, c)
int c;
char *id;
{
	char *p;

	if (c < 0) {
		c = getnb();
		if ((ctype[c] & LETTER) == 0)
			ptoaexit(ER_FATAL);
	}
	p = id;
	do {
		if (p < &id[NCPS-1])
			*p++ = c;
	} while (ctype[c=get()] & (LETTER|DIGIT));
	unget(c);
	*p++ = 0;
}

/*)Function	int	getnb()
 *
 *	The function getnb() scans the current text line
 *	returning the first character not a SPACE or TAB.
 *
 *	local variables:
 *		int	c		current character from
 *					the text line
 *
 *	global variables:
 *		none
 *
 *	called functions:
 *		int	get()		pictoasx.c
 *
 *	side effects:
 *		use of get() updates the global pointer ip, the position
 *		in the current text line
 */

int
getnb()
{
	int c;

	while ((c=get()) == ' ' || c == '\t')
		;
	return (c);
}

/*)Function	int	get()
 *
 *	The function get() returns the next character in the text
 *	line, at the end of the line a NULL character is returned.
 *
 *	local variables:
 *		int	c		current character from
 *					the text line
 *
 *	global variables:
 *		char *	ip		pointer into the current
 *					text line
 *
 *	called functions:
 *		none
 *
 *	side effects:
 *		updates ip to the next character position in the
 *		text line.  If ip is at the end of the line,
 *		ip is not updated.
 */

int
get()
{
	int c;

	if ((c = *ip) != 0)
		++ip;
	return (c & 0x007F);
}

/*)Function	VOID	unget(c)
 *
 *		int	c		value of last character read
 *					from the text line
 *
 *	If (c) is not a NULL character then the global pointer ip
 *	is updated to point to the preceeding character in the
 *	text line.
 *
 *	NOTE:	This function does not push the character (c) back
 *		into the text line, only the pointer ip is changed.
 *
 *	local variables:
 *		int	c		last character read from
 *					the text line
 *
 *	global variables:
 *		char *	ip		position into the current
 *					text line
 *
 *	called functions:
 *		none
 *
 *	side effects:
 *		ip decremented by 1 character position
 */

VOID
unget(c)
int c;
{
	if (c)
		if (ip != ib)
			--ip;
}

/*)Function	int	axgetline()
 *
 *	The function axgetline() reads a line of text from an assembly
 *	source text file.  The input text line is transferred into the
 *	global string ib[] and converted to a NULL terminated string.
 *	The function scanline() is called to process any substitutions
 *	in the text line.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		char	ib[]		string buffer containing
 *					assembler-source text line
 *		char	ifp[]		array of file handles for
 *					include files
 *
 *	called functions:
 *		VOID	chopcrlf()	pictoasx.c
 *		char *	fgets()		c-library
 *		int	scanline()	pictoasx.c
 *
 *	side effects:
 *		The source line will be updated.
 */

int
axgetline()
{
	if (fgets(ib, NINPUT, ifp) == NULL) {
		return (0);
	}
	chopcrlf(ib);
	scanline();
	return (1);
}


/*)Function	int	scanline()
 *
 *	The function scanline() scans the assembler-source text line
 *	for a valid substitutable string.  The only valid targets
 *	for substitution strings are strings beginning with a
 *	LETTER and containing any combination of DIGITS and LETTERS.
 *	If a valid target is found then the function changekey() is
 *	called to search the keyword substitution list.  This is
 *	followed by a call to changestr() which searches for embedded
 *	keywords a call to cnvhex() to convert H'1234 form constants
 *	to 0x1234 form constants.
 *
 *	local variables:
 *		int	c		temporary character value
 *		char	id[]		a string of maximum length NINPUT
 *
 *	global variables:
 *		char	ctype[]		a character array which defines the
 *					type of character being processed.
 *					The index is the character
 *					being processed.
 *		char	ib[]		assembler-source text line
 *		char *	ip		pointer into the assembler-source text line
 *
 *	called functions:
 *		int	changekey()	pictoasx.c
 *		VOID	cnvhex()	pictoasx.c
 *		int	get()		pictoasx.c
 *		int	getid()		pictoasx.c
 *		int	symeq()		pictoasx.c
 *		int	unget()		pictoasx.c
 *
 *	side effects:
 *		The text line may be updated and a substitution
 *		made for keywords and hex constants.
 */

VOID
scanline()
{
	int c;
	char id[NINPUT];

	ip = ib;
	while ((c = get()) != 0) {
		if (c == ';') break;
		if (ctype[c] & DIGIT) {
			while (ctype[c] & (LETTER|DIGIT)) c = get();
			unget(c);
		} else
		if (ctype[c] & LETTER) {
			getid(id, c);
			changekey(id);
		}
	}

	changestr();
	cnvhex();
}


/*)Function	int	changekey(id)
 *
 *		char *	id		a pointer to a string of
 *					maximum length NINPUT
 *
 *	The function changekey() scans the keyword substitution list
 *	for a match to the string id[].  If a match is found then
 *	a substition is made from the keyword definition list.
 *	The function changekey() returns a non-zero value if a
 *	substitutuion is made else zero is returned.
 *
 *	local variables:
 *		char	c		character read from text line
 *		char *	p		pointer to beginning of id
 *		char	str[]		temporary string
 *		struct def *dp		pointer to .define definitions
 *
 *	global variables:
 *		char	ib[]		assembler-source text line
 *		char *	ip		pointer into the assembler-source text line
 *		int	zflag		case sensitivity flag
 *
 *	called functions:
 *		char *	strcat()	c_library
 *		char *	strcpy()	c_library
 *		int	strlen()	c_library
 *		int	symeq()		pictoasx.c
 *
 *	side effects:
 *		The assembler-source text line may be updated
 *		and a substitution made for the string id[].
 */

int
changekey(id)
char *id;
{
	char *p;
	int c;
	char str[NINPUT];
	struct def *dp;

	/*
	 * Check for substitution
	 */
	dp = &defk[0];
	while (dp->d_id != NULL) {
		if (symeq(id, dp->d_id, zflag)) {
			p = ip - strlen(id);
			strcpy(str, ip);
			strcpy(p, dp->d_define);
			strcat(ib, str);
			ip = p + strlen(dp->d_define);
			/*
			 * Special Processing for __badram
			 */
			if (symeq("__badram", dp->d_id, 0)) {
				p = ip;
				while (((c = get()) != 0) && (c != ';')) {
					if (c == '-') {
						*(ip-1) = ':';
					}
				}
				ip = p;
			}
			return(1);
		}
		dp++;
	}
	return(0);
}


/*)Function	int	changestr()
 *
 *	The function changestr() scans the input text line
 *	for a string match from the imbedded substitution list.
 *	A match results in the replacement of the string with
 *	the replacement string from the imbedded substitution list.
 *
 *	local variables:
 *		char *	id		pointer to beginning of search string
 *		char	str[]		temporary string
 *		struct def *dp		pointer to .define definitions
 *
 *	global variables:
 *		char	ib[]		assembler-source text line
 *		int	zflag		case sensitivity flag
 *
 *	called functions:
 *		char *	strcat()	c_library
 *		char *	strcpy()	c_library
 *		int	strlen()	c_library
 *		int	symeqn()	pictoasx.c
 *
 *	side effects:
 *		The assembler-source text line may be updated
 *		and a substitution made for the string id[].
 */

VOID
changestr()
{
	char str[NINPUT];
	char *id;
	int i,len,len_id;
	struct def *dp;

	len = strlen(ib);

	dp = &defs[0];
	while (dp->d_id != NULL) {
		id = dp->d_id;
		len_id = strlen(id);
		for (i=0; i<len-len_id; i++) {
			if (ib[i] == ';') break;
			if (symeqn(&ib[i],id,zflag,len_id)) {
				/* save tail of string */
				strcpy(str, &ib[i+len_id]);
				/* replacement string */
				strcpy(&ib[i], dp->d_define);
				/* place end of string */
				strcat(ib, str);
			}
		}
		dp++;
	}
}


/*)Function	VOID	cnvhex()
 *
 *	The function cnvhex() converts Hex constants
 *	from the form H'1234 to the form 0x1234.
 *
 *	local variables:
 *		int	i		loop counter
 *		int	j		loop counter
 *		int	len		length of string
 *		char	str[]		temporary string
 *
 *	global variables:
 *		char	ib[]		assembler-source text line
 *
 *	called functions:
 *		char *	strcat()	c_library
 *		char *	strcpy()	c_library
 *		int	strlen()	c_library
 *		int	symeqn()	pictoasx.c
 *
 *	side effects:
 *		The text line may be updated.
 */

VOID
cnvhex()
{
	char str[NINPUT];
	int i,j,len;

	len = strlen(ib);

	for (i=0; i<len-2; i++) {
		if (symeqn(&ib[i],"H\'",1,2)) {
			/* H'23456789' */
			for (j=2; j<11; j++) {
				if (ib[i+j] == '\'') {
					/* remove ' */
					strcpy(&ib[i+j], &ib[i+j+1]);
					/* save tail of string */
					strcpy(str, &ib[i+2]);
					/* replacement string */
					strcpy(&ib[i], "0x");
					/* place end of string */
					strcat(ib, str);
					break;
				}
			}
		}
	}
}


/*)Function	int	symeq(p1, p2, flag)
 *
 *		int	flag		case sensitive flag
 *		char *	p1		name string
 *		char *	p2		name string
 *
 *	The function symeq() compares the two name strings for a match.
 *	The return value is 1 for a match and 0 for no match.
 *
 *		flag == 0	case sensitive compare
 *		flag != 0	case insensitive compare
 *
 *	local variables:
 *		int	n		loop counter
 *
 *	global variables:
 *		char	ccase[]		an array of characters which
 *					perform the case translation function
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		none
 *
 */

int
symeq(p1, p2, flag)
char *p1, *p2;
int flag;
{
	int n;

	n = strlen(p1) + 1;
	if(flag) {
		/*
		 * Case Sensitive Compare
		 */
		do {
			if (*p1++ != *p2++)
				return (0);
		} while (--n);
	} else {
		/*
		 * Case Insensitive Compare
		 */
		do {
			if (ccase[*p1++ & 0x007F] != ccase[*p2++ & 0x007F])
				return (0);
		} while (--n);
	}
	return (1);
}


/*)Function	int	symeqn(p1, p2, flag, n)
 *
 *		int	flag		case sensitive flag
 *		int	n		number of characters to match
 *		char *	p1		name string
 *		char *	p2		name string
 *
 *	The function symeqn() compares the two name strings for a match.
 *	The return value is 1 for a match and 0 for no match.
 *
 *		flag == 0	case sensitive compare
 *		flag != 0	case insensitive compare
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		char	ccase[]		an array of characters which
 *					perform the case translation function
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		none
 *
 */

int
symeqn(p1, p2, flag, n)
char *p1, *p2;
int flag, n;
{
	if(flag) {
		/*
		 * Case Sensitive Compare
		 */
		do {
			if (*p1++ != *p2++)
				return (0);
		} while (--n);
	} else {
		/*
		 * Case Insensitive Compare
		 */
		do {
			if (ccase[*p1++ & 0x007F] != ccase[*p2++ & 0x007F])
				return (0);
		} while (--n);
	}
	return (1);
}


/*)Function	VOID	chopcrlf(str)
 *
 *		char	*str		string to chop
 *
 *	The function chop_crlf() removes
 *	LF, CR, LF/CR, or CR/LF from str.
 *
 *	local variables:
 *		char *	p		temporary string pointer
 *		char	c		temporary character
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		All CR and LF characters removed.
 */

VOID
chopcrlf(str)
char *str;
{
	char *p;
	char c;

	p = str;
	do {
		c = *p++ = *str++;
		if ((c == '\r') || (c == '\n')) {
			p--;
		}
	} while (c != 0);
}


/*)Function	VOID	usage(n)
 *
 *		int	n		exit code
 *
 *	The function usage() outputs to the stderr
 *	device the list of valid program options.
 *
 *	local variables:
 *		char **	dp		pointer to an array of
 *					text string pointers.
 *
 *	global variables:
 *		char *	usetxt[]	array of string pointers
 *
 *	functions called:
 *		VOID	ptoaexit()	pictoasx.c
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		program is terminated
 */

char *usetxt[] = {
	"Usage: [-options] file",
	"  z    Enable case sensitivity for KeyWords",
	"",
	NULL
};

VOID
usage(n)
int n;
{
	char   **dp;

	fprintf(stderr, "\nPicToAsx Conversion Utility  %s\n\n", VERSION);
	for (dp = usetxt; *dp; dp++)
		fprintf(stderr, "%s\n", *dp);
	ptoaexit(n);
}

