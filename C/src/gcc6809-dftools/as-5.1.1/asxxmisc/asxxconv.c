/* asxcnv.c */

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


int inpfil;		/* Input File Counter	*/
int radix;		/* Radix Flag		*/
int a_bytes;		/* Addressing Bytes	*/
int aserr;		/* Error Counter	*/

FILE *nfp;		/* Input File Handle	*/
FILE *dfp;		/* Output File Handle	*/

char scline[256];	/* Input text line	*/


/*
 *	array of character types, one per
 *	ASCII character
 */
char	ctype[128] = {
/*NUL*/	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,
/*BS*/	ILL,	SPACE,	ILL,	ILL,	SPACE,	ILL,	ILL,	ILL,
/*DLE*/	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,
/*CAN*/	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,
/*SPC*/	SPACE,	ETC,	ETC,	ETC,	LETTER,	BINOP,	BINOP,	ETC,
/*(*/	ETC,	ETC,	BINOP,	BINOP,	ETC,	BINOP,	LETTER,	BINOP,
/*0*/	DGT2,	DGT2,	DGT8,	DGT8,	DGT8,	DGT8,	DGT8,	DGT8,
/*8*/	DGT10,	DGT10,	ETC,	ETC,	BINOP,	ETC,	BINOP,	ETC,
/*@*/	ETC,	LTR16,	LTR16,	LTR16,	LTR16,	LTR16,	LTR16,	LETTER,
/*H*/	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
/*P*/	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
/*X*/	LETTER,	LETTER,	LETTER,	ETC,	ETC,	ETC,	BINOP,	LETTER,
/*`*/	ETC,	LTR16,	LTR16,	LTR16,	LTR16,	LTR16,	LTR16,	LETTER,
/*h*/	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
/*p*/	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
/*x*/	LETTER,	LETTER,	LETTER,	ETC,	BINOP,	ETC,	ETC,	ETC
};

/*
 *	an array of characters which
 *	perform the case translation function
 */
char	ccase[128] = {
/*NUL*/	'\000',	'\001',	'\002',	'\003',	'\004',	'\005',	'\006',	'\007',
/*BS*/	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
/*DLE*/	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
/*CAN*/	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037',
/*SPC*/	'\040',	'\041',	'\042',	'\043',	'\044',	'\045',	'\046',	'\047',
/*(*/	'\050',	'\051',	'\052',	'\053',	'\054',	'\055',	'\056',	'\057',
/*0*/	'\060',	'\061',	'\062',	'\063',	'\064',	'\065',	'\066',	'\067',
/*8*/	'\070',	'\071',	'\072',	'\073',	'\074',	'\075',	'\076',	'\077',
/*@*/	'\100',	'\141',	'\142',	'\143',	'\144',	'\145',	'\146',	'\147',
/*H*/	'\150',	'\151',	'\152',	'\153',	'\154',	'\155',	'\156',	'\157',
/*P*/	'\160',	'\161',	'\162',	'\163',	'\164',	'\165',	'\166',	'\167',
/*X*/	'\170',	'\171',	'\172',	'\133',	'\134',	'\135',	'\136',	'\137',
/*`*/	'\140',	'\141',	'\142',	'\143',	'\144',	'\145',	'\146',	'\147',
/*h*/	'\150',	'\151',	'\152',	'\153',	'\154',	'\155',	'\156',	'\157',
/*p*/	'\160',	'\161',	'\162',	'\163',	'\164',	'\165',	'\166',	'\167',
/*x*/	'\170',	'\171',	'\172',	'\173',	'\174',	'\175',	'\176',	'\177'
};


/*)Function	int	main(argc, argv)
 *
 *		int	argc		argument count
 *		char *	argv		array of pointers to argument strings
 *
 * Convert a listing file to a test file by:
 *	(1)	stripping the listing headers
 *	(2)	removing the program counter, data bytes, and
 *		line numbers
 *	(3)	appending the data bytes to the source line
 *		as a comment.
 *	(4)	remove any symbol table or area table
 */

int
main(argc, argv)
int argc;
char *argv[];
{
	char *p, *q, *r, *s;
	int c, i, j, k, l, m, n;
	int ldgt, pos, rdx;
	unsigned int lcon, lnum;

	/*
	 * Set Defaults
	 */
	radix = 16;
	a_bytes = 2;
	inpfil = 0;
	aserr = 0;

	for (i=1; i<argc; ++i) {
		p = argv[i];
		if (*p == '-') {
			++p;
			while ((c = *p++) != 0)
				switch(c) {

				case 'x':
				case 'X':
					radix = 16;
					break;

				case 'd':
				case 'D':
					radix = 10;
					break;

				case 'q':
				case 'Q':
					radix = 8;
					break;

				case '2':
					a_bytes = 2;
					break;

				case '3':
					a_bytes = 3;
					break;

				case '4':
					a_bytes = 4;
					break;

				default:
					usage(ER_FATAL);
				}
		} else {
			if (++inpfil > 1) {
				fprintf(stderr, "Too many files\n");
				asexit(ER_FATAL);
			}
			nfp = fopen(p, "r");
			if (nfp == NULL) {
				fprintf(stderr, "File %s not found\n", p);
				asexit(ER_FATAL);
			}
			dfp = fopen("a.out", "w");
			if (dfp == NULL) {
				fprintf(stderr, "File a.out not opened\n");
				asexit(ER_FATAL);
			}
		}
	}
	if (inpfil == 0)
		usage(ER_WARNING);

	/*
	 * Convert listing file to a source file
	 * with assembled data appended as comments.
	 */
loop:
	while (fgets(scline, sizeof(scline), nfp)) {
		chopcrlf(scline);
		p = scline;

		/* ldgt	Last Data Digit in Line		*/
		/* lcon	Line Continuation Length	*/
		/* lnum First Line Number Digit		*/

		switch(a_bytes) {
		default:
		case 2: ldgt = 25; lnum=26; lcon = 32; break;
		case 3:
		case 4: ldgt = 33; lnum=34; lcon = 40; break;
		}

		/* The Output Formats
		| Tabs- |       |       |       |       |       |
		          11111111112222222222333333333344444-----
		012345678901234567890123456789012345678901234-----
		   |    |               |     | |
		ee XXXX xx xx xx xx xx xx LLLLL *************	HEX(16)
		ee 000000 ooo ooo ooo ooo LLLLL *************	OCTAL(16)
		ee  DDDDD ddd ddd ddd ddd LLLLL *************	DECIMAL(16)
		                     XXXX
				   OOOOOO
				    DDDDD

		| Tabs- |       |       |       |       |       |
		          11111111112222222222333333333344444-----
		012345678901234567890123456789012345678901234-----
		     |       |                  |     | |
		ee    XXXXXX xx xx xx xx xx xx xx LLLLL *********	HEX(24)
		ee   OO000000 ooo ooo ooo ooo ooo LLLLL *********	OCTAL(24)
		ee   DDDDDDDD ddd ddd ddd ddd ddd LLLLL *********	DECIMAL(24)
		                           XXXXXX
					 OOOOOOOO
					 DDDDDDDD

		| Tabs- |       |       |       |       |       |
		          11111111112222222222333333333344444-----
		012345678901234567890123456789012345678901234-----
		  |          |                  |     | |
		ee  XXXXXXXX xx xx xx xx xx xx xx LLLLL *********	HEX(32)
		eeOOOOO000000 ooo ooo ooo ooo ooo LLLLL *********	OCTAL(32)
		ee DDDDDDDDDD ddd ddd ddd ddd ddd LLLLL *********	DECIMAL(32)
		                         XXXXXXXX
				      OOOOOOOOOOO
				       DDDDDDDDDD
		*/

		/* p	Starting position of program counter	*/
		/* n	Number of digits in program ccounter	*/
		/* l	Number of digits in byte data		*/
		/* m	Number of bytes per line		*/

		switch(radix) {
		default:
		case 16:
			rdx = RAD16;
			switch(a_bytes) {
			default:
			case 2: p += 3; n = 4; l = 2; m = 6; break;
			case 3: p += 6; n = 6; l = 2; m = 7; break;
			case 4: p += 4; n = 8; l = 2; m = 7; break;
			}
			break;

		case 8:
			rdx = RAD8;
			switch(a_bytes) {
			default:
			case 2: p += 3; n = 6; l = 3; m = 4; break;
			case 3: p += 5; n = 8; l = 3; m = 5; break;
			case 4: p += 2; n = 11; l = 3; m = 5; break;
			}
			break;

		case 10:
			rdx = RAD10;
			switch(a_bytes) {
			default:
			case 2: p += 4; n = 5; l = 3; m = 4; break;
			case 3: p += 5; n = 8; l = 3; m = 5; break;
			case 4: p += 3; n = 10; l = 3; m = 5; break;
			}
			break;
		}

		/*
		 * If the assembled line contains a cycle
		 * count of the form '[__]' then update:
		 *
		 * ldgt	  Last Data Digit in Line
		 * m	  Number of bytes per line
		 */
		if ((scline[ldgt-3] == CYCNT_BGN) && (scline[ldgt] == CYCNT_END)) {
			switch(rdx) {
			default:
			case RAD16:
				ldgt -= 3; 
				break;

			case RAD8:
				ldgt -= 4; 
				break;

			case RAD10:
				ldgt -= 4; 
				break;
			}
			m -= 1;
		}

		/*
		 * Verify this line has program counter
		 * digits or spaces.  If not then this
		 * line was generated by the assembler.
		 * Strip the line.
		 */
		for (i=0; i<n; i++,p++) {
			if ((ctype[*p & 0x007F] & rdx) != rdx &&
			     ctype[*p & 0x007F] != SPACE) {
				goto loop;
			}
		}

		/*
		 * Verify there is only data or spaces
		 * in the data locations.  If the listing
		 * file contains the symbol table then some
		 * assembler lines may still get through.
		 */
		r = p+1;
		for (i=0; i<m; i++,r++) {
			for (j=0; j<l; j++,r++) {
				if ((ctype[*r & 0x007F] & rdx) != rdx &&
				     ctype[*r & 0x007F] != SPACE) {
					goto loop;
				}
			}
		}

		/*
		 * If there is NO data in line then:
		 *   If there is an assembler line number then:
		 *     copy line to output
		 *   else
		 *     skip line
		 *   endif
		 * else
		 *   continue
		 * endif
		 */
		r = p+1;
		for (j=0; j<l; j++,r++) {
			if ((ctype[*r & 0x007F] & rdx) != rdx) {
				r = scline+lnum;
				for (k=0; k<5; k++,r++) {
					if ((ctype[*r & 0x007F] & RAD10) != RAD10 &&
					     ctype[*r & 0x007F] != SPACE) {
						goto loop;
					}
				}
				fprintf(dfp, "%s\n", scline + lcon);
				goto loop;
			}
		}

		/*
		 * Scan for the last data digit.
		 */
		s = q = scline;
		for (i=0; *s && i<ldgt; i++) {
			if ((ctype[*s++ & 0x007F] & rdx) == rdx)
				q = s;
		}

		if (strlen(scline) <= lcon) {
			/*
			 * Line must be data continuation
			 */
			goto loop;
		} else {
			/*
			 * Real source line
			 */
			s = scline + lcon;
			/*
			 * Remove any comment in line
			 */
			r = strchr(s, ';');
			if (r != NULL) {
				*r = '\0';
				while( --r >= s && *r == SPACE) {
					*r = '\0';
				}
			}
			/*
			 * Find line length
			 */
			pos = 0;
			while (*s) {
				if (*s == '\t') {
					pos += 8;
					pos = 8 * (pos/8);
				} else {
					pos += 1;
				}
				s++;
			}
			/*
			 * Extend line to at least 32 characters
			 * before appending data.
			 */
			while (pos < 32) {
				strcat(scline,"\t");
				pos += 8;
				pos = 8 * (pos/8);
			}

			/*
			 * Append assembler generated data to
			 * source line.
			 */
			strcat(scline,";");
			strncat(scline,p,(int) (q-p));
			fprintf(dfp, "%s\n", scline + lcon);
		}
	}
	asexit(aserr ? ER_ERROR : ER_NONE);
	return(0);
}

/*)Function	VOID	chopcrlf(str)
 *
 *		char	*str		string to chop
 *
 *	The function chopcrlf() removes
 *	LF, CR, LF/CR, or CR/LF from str
 *  and strips trailing white space.
 *
 *	local variables:
 *		char *	p		temporary string pointer
 *		char *	q		temporary string pointer
 *		char	c		temporary character
 *		int	i		temporary loop counter
 *		int	n		temporary character count
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		strlen()		c-library
 *
 *	side effects:
 *		All CR and LF characters removed.
 *		Trailing white space removed.
 */

VOID
chopcrlf(str)
char *str;
{
	char *p, *q;
	char c;
	int i, n;

	p = str;
	q = str;
	do {
		c = *p++ = *q++;
		if ((c == '\r') || (c == '\n')) {
			p--;
		}
	} while (c != 0);

	n = strlen(str);
	p = str + n;
	for (i=0; (i<n)&&(*p==0); i++) {
		c = *(--p);
		if ((c == '\t') || (c == ' ')) {
			*p = 0;
		}
	}
}

/*)Function	VOID	asexit(i)
 *
 *			int	i	exit code
 *
 *	The function asexit() explicitly closes all open
 *	files and then terminates the program.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		FILE *	nfp		Input  File Handle
 *		FILE *	dfp		Output File Handle
 *
 *	functions called:
 *		int	fclose()	c-library
 *		VOID	exit()		c-library
 *
 *	side effects:
 *		All files closed. Program terminates.
 */

VOID
asexit(i)
int i;
{
	if (nfp != NULL) fclose(nfp);
	if (dfp != NULL) fclose(dfp);

	exit(i);
}

char *usetxt[] = {
	"Usage: [-dqx234] file",
	"  d    decimal listing",
	"  q    octal   listing",
	"  x    hex     listing (default)",
	"  2    16-Bit  address (default)",
	"  3    24-Bit  address",
	"  4    32-Bit  address",
	"",
	NULL
};

/*)Function	VOID	usage(n)
 *
 *		int	n		exit code
 *
 *	The function usage() outputs to the stderr device the
 *	program name and version and a list of valid assembler options.
 *
 *	local variables:
 *		char **	dp		pointer to an array of
 *					text string pointers.
 *
 *	global variables:
 *		char *	usetxt[]	array of string pointers
 *
 *	functions called:
 *		VOID	asexit()	asmain.c
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		program is terminated
 */

VOID
usage(n)
int n;
{
	char **dp;

	fprintf(stderr, "ASxxxx Assembler Listing Converter " VERSION "\n");
	fprintf(stderr, "Copyright (C) " COPYRIGHT " Alan R. Baldwin\n");
	fprintf(stderr, "This program comes with ABSOLUTELY NO WARRANTY.\n\n");
	for (dp = usetxt; *dp; dp++)
		fprintf(stderr, "%s\n", *dp);
	asexit(n);
}

