/* lklex.c */

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
 */

#include "aslink.h"

/*)Module	lklex.c
 *
 *	The module lklex.c contains the general lexical analysis
 *	functions used to scan the text lines from the .rel files.
 *
 *	lklex.c contains the following functions:
 *		VOID	chopcrlf()
 *		char	endline()
 *		int	get()
 *		VOID	getfid()
 *		VOID	getid()
 *		int	getmap()
 *		int	getnb()
 *		int	more()
 *		int	nxtline()
 *		VOID	skip()
 *		VOID	unget()
 *
 *	lklex.c contains no local variables.
 */

/*)Function	VOID	getid(id,c)
 *
 *		char *	id		a pointer to a string of
 *					maximum length NCPS-1
 *		int	c		mode flag
 *					>=0	this is first character to
 *						copy to the string buffer
 *					<0	skip white space
 *
 *	The function getid() scans the current input text line
 *	from the current position copying the next LETTER | DIGIT string
 *	into the external string buffer (id).  The string ends when a non
 *	LETTER or DIGIT character is found. The maximum number of characters
 *	copied is NCPS-1.  If the input string is larger than NCPS-1
 *	characters then the string is truncated.  The string is always
 *	NULL terminated.  If the mode argument (c) is >=0 then (c) is
 *	the first character copied to the string buffer, if (c) is <0
 *	then intervening white space (SPACES and TABS) are skipped.
 *
 *	local variables:
 *		char *	p		pointer to external string buffer
 *
 *	global variables:
 *		char	ctype[]		a character array which defines the
 *					type of character being processed.
 *					This index is the character
 *					being processed.
 *		char	id[]		string buffer
 *
 *	called functions:
 *		int	get()		lklex.c
 *		int	getnb()		lklex.c
 *		VOID	unget()		lklex.c
 *
 *	side effects:
 *		use of getnb(), get(), and unget() updates the
 *		global pointer ip the position in the current
 *		input text line.
 */

VOID
getid(id, c)
int c;
char *id;
{
	char *p;

	if (c < 0) {
		c = getnb();
	}
	p = id;
	do {
		if (p < &id[NCPS-1])
			*p++ = c;
	} while (ctype[c=get()] & (LETTER|DIGIT));
	unget(c);
	*p++ = 0;
}

/*)Function	VOID	getfid(str,c)
 *
 *		char *	str		a pointer to a string of
 *					maximum length FILSPC-1
 *		int	c		this is first character to
 *					copy to the string buffer
 *
 *	The function getfid() copies a string of characters from
 *	the current text line into the external string buffer (str).
 *	The maximum number of characters copied is FILSPC-1.  The
 *	string is terminated by a 'space', 'tab' or end of string.
 *
 *	local variables:
 *		char *	p		pointer to external string buffer
 *
 *	called functions:
 *		int	get()		lklex.c
 *
 *	side effects:
 *		use of get() updates the global pointer ip
 *		the position in the current input text line.
 */

VOID
getfid(str, c)
int c;
char *str;
{
	char *p;

	p = str;
	do {
		if (p < &str[FILSPC-1])
			*p++ = c;
		c = get();		
	} while ((c != 0) && (c != ' ') && (c != '\t'));
	*p++ = 0;
}

/*)Function	int	getnb()
 *
 *	The function getnb() scans the current input text
 *	line returning the first character not a SPACE or TAB.
 *
 *	local variables:
 *		int	c		current character from input
 *
 *	global variables:
 *		none
 *
 *	called functions:
 *		int	get()		lklex.c
 *
 *	side effects:
 *		use of get() updates the global pointer ip, the position
 *		in the current input text line
 */

int
getnb()
{
	int c;

	while ((c=get())==' ' || c=='\t')
		;
	return (c);
}

/*)Function	VOID	skip(c)
 *
 *	The function skip() scans the input text skipping all
 *	letters and digits.
 *
 *	local variables:
 *		int	c		last character read
 *		none
 *
 *	global variables:
 *		char	ctype[]		array of character types, one per
 *				 	ASCII character
 *		
 *	functions called:
 *		int	get()		lklex.c
 *		int	getnb()		lklex.c
 *		VOID	unget()		lklex.c
 *
 *	side effects:
 *		Input letters and digits are skipped.
 */

VOID
skip(c)
int c;
{
	if (c < 0)
		c = getnb();
	while (ctype[c=get()] & (LETTER|DIGIT)) { ; }
	unget(c);
}

/*)Function	int	get()
 *
 *	The function get() returns the next character in the
 *	input text line, at the end of the line a
 *	NULL character is returned.
 *
 *	local variables:
 *		int	c		current character from
 *					input text line
 *
 *	global variables:
 *		char *	ip		pointer into the current
 *					input text line
 *
 *	called functions:
 *		none
 *
 *	side effects:
 *		updates ip to the next character position in the
 *		input text line.  If ip is at the end of the
 *		line, ip is not updated.
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
 *		int	c		value of last character
 *					read from input text line
 *
 *	If (c) is not a NULL character then the global pointer ip
 *	is updated to point to the preceeding character in the
 *	input text line.
 *
 *	NOTE:	This function does not push the character (c)
 *		back into the input text line, only
 *		the pointer ip is changed.
 *
 *	local variables:
 *		int	c		last character read
 *					from input text line
 *
 *	global variables:
 *		char *	ip		position into the current
 *					input text line
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
	if (c != 0)
		--ip;
}

/*)Function	int	getmap(d)
 *
 *		int	d		value to compare with the
 *					input text line character
 *
 *	The function getmap() converts the 'C' style characters \b, \f,
 *	\n, \r, and \t to their equivalent ascii values and also
 *	converts 'C' style octal constants '\123' to their equivalent
 *	numeric values.  If the first character is equivalent to (d) then
 *	a (-1) is returned, if the end of the line is detected then
 *	a 'q' error terminates the parse for this line, or if the first
 *	character is not a \ then the character value is returned.
 *
 *	local variables:
 *		int	c		value of character
 *					from input text line
 *		int	n		looping counter
 *		int	v		current value of numeric conversion
 *
 *	global variables:
 *		none
 *
 *	called functions:
 *		int	get()		lklex.c
 *		VOID	unget()		lklex.c
 *
 *	side effects:
 *		use of get() updates the global pointer ip the position
 *		in the current input text line
 */

int
getmap(d)
int d;
{
	int c, n, v;

	if ((c = get()) == '\0')
		return (-1);
	if (c == d)
		return (-1);
	if (c == '\\') {
		c = get();
		switch (c) {

		case 'b':
			c = '\b';
			break;

		case 'f':
			c = '\f';
			break;

		case 'n':
			c = '\n';
			break;

		case 'r':
			c = '\r';
			break;

		case 't':
			c = '\t';
			break;

		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
			n = 0;
			v = 0;
			while (++n<=3 && c>='0' && c<='7') {
				v = (v<<3) + c - '0';
				c = get();
			}
			unget(c);
			c = v;
			break;
		}
	}
	return (c);
}

/*)Function	int	nxtline()
 *
 *	The function nxtline() reads a line of input text from a
 *	.rel source text file, a .lnk command file or from stdin.
 *	Lines of text are processed from a single .lnk file or
 *	multiple .rel files until all files have been read.
 *	The input text line is copied into the global string ib[]
 *	and converted to a NULL terminated string.  The function
 *	nxtline() returns a (1) after succesfully reading a line
 *	or a (0) if all files have been read.
 *	This function also opens each input .lst file and output
 *	.rst file as each .rel file is processed.
 *
 *	local variables:
 *		int	ftype		file type
 *		char *	fid		file name
 *
 *	global variables:
 *		FILE	*hfp		The file handle to the current
 *					.lst to .rst hint file associated
 *					with the LST file being scanned.
 *		lfile	*cfp		The pointer *cfp points to the
 *				 	current lfile structure
 *		lfile	*filep	 	The pointer *filep points to the
 *				 	beginning of a linked list of
 *				 	lfile structures.
 *		int	gline		get a line from the LST file
 *					to translate for the RST file
 *		int	hline		get a line from the HLR file
 *					as a hint to update the RST file
 *		char	ib[NINPUT]	REL file text line
 *		int	obj_flag	Linked file/library object flag
 *		int	pass		linker pass number
 *		FILE	*rfp		The file handle to the current
 *					output RST file
 *		FILE	*sfp		The file handle to the current
 *				 	input file
 *		FILE *	stdin		c_library
 *		FILE *	stdout		c_library
 *		FILE	*tfp		The file handle to the current
 *					LST file being scanned
 *		int	uflag		update listing flag
 *
 *	called functions:
 *		VOID	chopcrlf()	lklex.c
 *		FILE *	afile()		lkmain.c
 *		int	fclose()	c_library
 *		char *	fgets()		c_library
 *		int	fprintf()	c_library
 *		VOID	gethlr()	lklist.c
 *		VOID	lkulist()	lklist.c
 *		VOID	lkerror()	lkmain.c
 *		VOID	SDCDBcopy()	lksdcdb.c
 *
 *	side effects:
 *		The input stream is scanned.  The .rel files will be
 *		opened and closed sequentially scanning each in turn.
 */

int
nxtline()
{
	int ftype;
	char *fid;

loop:	if (cfp && cfp->f_type == F_STD)
		fprintf(stdout, "ASlink >> ");

	if (sfp == NULL || fgets(ib, sizeof(ib), sfp) == NULL) {
		obj_flag = 0;
		if (sfp) {
			if(sfp != stdin) {
				fclose(sfp);
			}
			sfp = NULL;
			lkulist(0);
		}
		if (cfp == NULL) {
			cfp = filep;
		} else {
			cfp = cfp->f_flp;
		}
		if (cfp) {
			ftype = cfp->f_type;
			fid = cfp->f_idp;
			if (ftype == F_STD) {
				sfp = stdin;
			} else
			if (ftype == F_LNK) {
				sfp = afile(fid, "lnk", 0);
			} else
			if (ftype == F_REL) {
				obj_flag = cfp->f_obj;
				sfp = afile(fid, "", 0);
				if (sfp && (obj_flag == 0)) {
				  if (uflag && (pass != 0)) {
				    if ((tfp = afile(fid, "lst", 0)) != NULL) {
				      if ((rfp = afile(fid, "rst", 1)) == NULL) {
					fclose(tfp);
					tfp = NULL;
				      } else {
				        hfp = afile(fid, "hlr", 4);
				      }
				    }
				  }
				}

#if SDCDB
				if (sfp && (pass == 0)) {
				  SDCDBcopy(fid, NULL);
				}
#endif

				gline = 1;
				hline = 1;
			} else {
				lkerror("Invalid file type");
			}
			if (sfp == NULL) {
				lkerror(NULL);
			}
			goto loop;
		} else {
			filep = NULL;
			return(0);
		}
	}
	chopcrlf(ib);
	return (1);
}

/*)Function	int	more()
 *
 *	The function more() scans the input text line
 *	skipping white space (SPACES and TABS) and returns a (0)
 *	if the end of the line or a comment delimeter (;) is found,
 *	or a (1) if their are additional characters in the line.
 *
 *	local variables:
 *		int	c		next character from
 *					the input text line
 *
 *	global variables:
 *		none
 *
 *	called functions:
 *		int	getnb()		lklex.c
 *		VOID	unget()		lklex.c
 *
 *	side effects:
 *		use of getnb() and unget() updates the global pointer ip
 *		the position in the current input text line
 */

int
more()
{
	int c;

	c = getnb();
	unget(c);
	return( (c == '\0' || c == ';') ? 0 : 1 );
}

/*)Function	char	endline()
 *
 *	The function endline() scans the input text line
 *	skipping white space (SPACES and TABS) and returns the next
 *	character or a (0) if the end of the line is found or a
 *	comment delimiter (;) is found.
 *
 *	local variables:
 *		int	c		next character from
 *					the input text line
 *
 *	global variables:
 *		none
 *
 *	called functions:
 *		int	getnb()		lklex.c
 *
 *	side effects:
 *		Use of getnb() updates the global pointer ip the
 *		position in the current input text line.
 */

char
endline()
{
	int c;

	c = getnb();
	return( (c == '\0' || c == ';') ? 0 : c );
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
#ifdef __unix__
	int len;

	len = strlen(str);
	if (len > 0) {
		if (str[len-1] == '\n')
			str[--len] = 0;
		if (len > 0) {
			if (str[--len] == '\r')
				str[len] = 0;
		}
	}
#else
	char *p;
	char c;

	p = str;
	do {
		c = *p++ = *str++;
		if ((c == '\r') || (c == '\n')) {
			p--;
		}
	} while (c != 0);
#endif
}

