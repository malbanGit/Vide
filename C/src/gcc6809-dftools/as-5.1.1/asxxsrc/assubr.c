/* assubr.c */

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

#include "asxxxx.h"

/*)Module	assubr.c
 *
 *	The module assubr.c contains the error
 *	processing routines.
 *
 *	assubr.c contains the following functions:
 *		VOID	aerr()
 *		VOID	diag()
 *		VOID	err()
 *		VOID	qerr()
 *		VOID	rerr()
 *		char *	geterr()
 *
 *	assubr.c contains the local array of *error[]
 */

/*)Function	VOID	err(c)
 *
 *		int	c		error type character
 *
 *	The function err() logs the error code character
 *	suppressing duplicate errors.  If the error code
 *	is 'q' then the parse of the current assembler-source
 *	text line is terminated.
 *
 *	local variables:
 *		char *	p		pointer to the error array
 *
 *	global variables:
 *		int	aserr		error counter
 *		char	eb[]		array of generated error codes
 *
 *	functions called:
 *		VOID	longjmp()	c_library
 *
 *	side effects:
 *		The error code may be inserted into the
 *		error code array eb[] or the parse terminated.
 */

VOID
err(c)
int c;
{
	char *p;

	aserr++;
	p = eb;
	while (p < ep)
		if (*p++ == c)
			return;
	if (p < &eb[NERR]) {
		*p++ = c;
		ep = p;
	}
	if (c == 'q')
		longjmp(jump_env, -1);
}

/*)Function	VOID	diag()
 *
 *	The function diag() prints any error codes and
 *	the source line number to the stderr output device.
 *
 *	local variables:
 *		char *	p		pointer to error code array eb[]
 *
 *	global variables:
 *		char	eb[]		array of generated error codes
 *		char *	ep		pointer into error list
 *		int	incline		include file line number
 *		int	srcline		source file line number
 *		FILE *	stderr		c_library
 *
 *	functions called:
 *		int	fprintf()	c_library
 *		char *	geterr()	assubr.c
 *		int	getlnm()	assubr.c
 *
 *	side effects:
 *		none
 */

VOID
diag()
{
	char *p,*errstr;

	if (eb != ep) {
		p = eb;
		fprintf(stderr, "?ASxxxx-Error-<");
		while (p < ep) {
			fprintf(stderr, "%c", *p++);
		}
		fprintf(stderr, "> in line ");
		fprintf(stderr, "%d", getlnm());
		fprintf(stderr, " of %s\n", afn);
		p = eb;
		while (p < ep) {
			if ((errstr = geterr(*p++)) != NULL) {
				fprintf(stderr, "              %s\n", errstr);
			}
		}
	}
}

/*)Functions:	VOID	aerr()
 *		VOID	qerr()
 *		VOID	rerr()
 *
 *	The functions aerr(), qerr(), and rerr() report their
 *	respective error type.  These are included only for
 *	convenience.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		VOID	err()		assubr.c
 *
 *	side effects:
 *		The appropriate error code is inserted into the
 *		error array and the parse may be terminated.
 */

/*
 * Note an 'r' error.
 */
VOID
rerr()
{
	err('r');
}

/*
 * Note an 'a' error.
 */
VOID
aerr()
{
	err('a');
}

/*
 * Note a 'q' error.
 */
VOID
qerr()
{
	err('q');
}

/*
 * ASxxxx assembler errors
 */
char *errors[] = {
	"<.> use \". = . + <arg>\" not \". = <arg>\"",
	"<a> machine specific addressing or addressing mode error",
	"<b> address / direct page boundary error",
	"<d> direct page addressing error",
	"<i> .include file error or an .if/.endif mismatch",
	"<m> multiple definitions error or macro recursion error",
	"<n> .endm, .mexit, or .narg outside of a macro",
	"<o> .org in REL area or directive / mnemonic error",
	"<p> phase error: label location changing between passes 2 and 3",
	"<q> missing or improper operators, terminators, or delimiters",
	"<r> relocation error",
	"<s> string substitution / recursion error",
	"<u> undefined symbol encountered during assembly",
	"<v> out of range signed / unsigned value",
	"<z> divide by zero or mod of zero error",
	NULL
};
	
/*)Function:	char	*geterr(c)
 *
 *		int	c		the error code character
 *
 *	The function geterr() scans the list of errors returning the
 *	error string corresponding to the input error character.
 *
 *	local variables:
 *		int	i		error index counter
 *
 *	global variables:
 *		char	*errors[]	array of pointers to the
 *					error strings
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		A pointer to the appropriate
 *		error code string is returned.
 */
char *
geterr(c)
int c;
{
	int i;

	for (i=0; errors[i]!=NULL; i++) {
		if (c == errors[i][1]) {
			return(errors[i]);
		}
	}
	sprintf(erb, "<e> %.*s", (int) (sizeof(erb)-5), ib);
	return(erb);
}


