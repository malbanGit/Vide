/* s19os9.c */

/*
 *  Copyright (C) 2006-2009  Alan R. Baldwin
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

#ifdef	OTHERSYSTEM
extern	unsigned char	os9_chk(unsigned char *ptr, unsigned int sz);
extern	int		os9_crc(unsigned char *ptr, unsigned int sz, unsigned char *crc);
#else
extern	unsigned char	os9_chk();
extern	int		os9_crc();
#endif

#define OS9_HEADER_SIZE 9

#define OS9_ID0		0x87
#define OS9_ID1		0xCD

#define	OS9_IHC		0xFF

#define	OS9_CRC_SIZE	3

#define	OS9_CRC0	0x80
#define	OS9_CRC1	0x0F
#define	OS9_CRC2	0xE3

FILE		*inpfp;		/* Input  File Handle		*/
FILE		*outfp;		/* Output File Handle		*/

int		ofarg;		/* Output File Argv Number	*/

char		ib[NINPUT*2];	/* Input text line		*/
char		*ip;		/* String Pointer		*/

int		lincnt;		/* Input Line Counter		*/

int		reclen;		/* Load Record Length		*/
unsigned int	addr;		/* Load Address			*/
int		data;		/* Load Data			*/
int		chksum;		/* Load Check Sum		*/

#define	MAXSIZ	((unsigned int) 12*4096)

unsigned char	bin[MAXSIZ];	/* Largest S19 Image Size 	*/
unsigned int	binhi;		/* Highest Image Address	*/

unsigned char	os9crc[3];	/* OS9 CRC			*/

/*)Function	int	main(argc,argv)
 *
 *		int	argc		number of command line arguments + 1
 *		char *	argv[]		array of pointers to the command line
 *					arguments
 *
 *	The function main() evaluates the command line arguments.
 *
 *	local variables:
 *		int	c		character from argument string
 *		int	i		loop counter
 *		int	j		loop counter
 *		int	k		loop counter
 *
 *	global variables:
 *		char	ib[NINPUT]	input file text line
 *		char	*ip		pointer into the text line
 *		FILE	*inpfp		Input  file handle
 *		FILE	*outfp		Output file handle
 *		FILE *	stdout		c_library
 *
 *	functions called:
 *		VOID		asexit()	s19os9.c
 *		VOID		chopcrlf()	s19os9.c
 *		int		digit()		s19os9.c
 *		int		fclose()	c_library
 *		FILE		fopen()		c_library
 *		int		fprintf()	c_library
 *		int		axgetline()	s19os9.c
 *		VOID		usage()		s19os9.c
 *		unsigned char	os9_chk()	s19os9.c
 *		int		os9_hdr()	s19os9.c
 *
 *	side effects:
 *		Completion of main() completes the translation of
 *		an S19 OS9 Module file into a binary OS9 Module file.
 *		The OS9 Module file header checksum byte and
 *		3 CRC bytes are calculated and replace the initial
 *		values defined by os9_mod.asm during assembly.
 */

int
main(argc, argv)
int argc;
char *argv[];
{
	int c, i, j, k;
	int inpfil;
	int radix;

	fprintf(stdout, "\n");

	inpfil = 0;
	radix = 16;

	for(i=1; i<argc; i++) {
		if(argv[i][0] == '-') {
			j = i;
			k = 1;
			while((c = argv[j][k]) != '\0') {
				switch(c) {

				/*
				 * Options with arguments
				 */
				case 'o':
				case 'O':
					ofarg = ++i;
					if (ofarg >= argc) {
						fprintf(stderr, "Missing argument for -o.\r\n");
						asexit(ER_FATAL);
					}
					break;

				/*
				 * Options without arguments
				 */
				default:
					fprintf(stderr,
					    "Unkown option -%c ignored\n", c);
					break;
				}
				k++;
			}
		} else {
			if (++inpfil > 1) {
				fprintf(stderr, "\r\nToo many files.\r\n");
				asexit(ER_FATAL);
			}
			inpfp = fopen(argv[i], "r");
			if (inpfp == NULL) {
				printf("\r\nFile %s not opened\r\n", argv[i]);
				asexit(ER_FATAL);
			}
		}
	}
	if (!inpfil) {
		usage(0);
	}

	/*
	 * Initialize Memory Array
	 */
	for (addr=0; addr<MAXSIZ; addr++) {
		bin[addr] = 0;
	}
	binhi = 0;

	/*
	 * S19 Input Scanner
	 */
	lincnt = 0;
	while axgetline()) {
		lincnt += 1;
		ip = ib;
		/*
		 * Beginning == "S1"
		 */
		if (strncmp(ip, "S1", 2)) continue;
		ip += 2;
		/*
		 * Record Length
		 */
		for (i=0,reclen=0; i<2; i++) {
			if (*ip) {
				reclen *= radix;
				if ((c = digit(*ip++,radix)) == -1) {
					fprintf(stderr, "Non Hex Character in line %d (reclen).\r\n", lincnt);
					asexit(ER_FATAL);
				}
				reclen += c;
			} else {
				fprintf(stderr, "Unexpected End-Of-Line in line %d ((reclen).\r\n", lincnt);
				asexit(ER_FATAL);
			}
		}
		chksum = reclen;
		/*
		 * Load Address
		 */
		for (j=1,addr=0; j<3; j++) {
			for (i=0; i<2; i++) {
				if (*ip) {
					addr *= radix;
					if ((c = digit(*ip++,radix)) == -1) {
						fprintf(stderr, "Non Hex Character in line %d (addr).\r\n", lincnt);
						asexit(ER_FATAL);
					}
					addr += c;
				} else {
					fprintf(stderr, "Unexpected End-Of-Line in line %d (addr).\r\n", lincnt);
					asexit(ER_FATAL);
				}
			}
			chksum += addr;
		}
		/*
		 * Data
		 */
		for (j=3; j<reclen; j++) {
			for (i=0,data=0; i<2; i++) {
				if (*ip) {
					data *= radix;
					if ((c = digit(*ip++,radix)) == -1) {
						fprintf(stderr, "Non Hex Character in line %d (data).\r\n", lincnt);
						asexit(ER_FATAL);
					}
					data += c;
				} else {
					fprintf(stderr, "Unexpected End-Of-Line in line %d {data).\r\n", lincnt);
					asexit(ER_FATAL);
				}
			}
			chksum += data;
			if (addr < MAXSIZ) {
				bin[addr++] = data;
			}
			binhi =  addr > binhi ? addr : binhi;
		}
		/*
		 * Final Checksum
		 */
		for (i=0,data=0; i<2; i++) {
			if (*ip) {
				data *= radix;
				if ((c = digit(*ip++,radix)) == -1) {
					fprintf(stderr, "Non Hex Character in line %d (chsum).\r\n", lincnt);
					asexit(ER_FATAL);
				}
				data += c;
			} else {
				fprintf(stderr, "Unexpected End-Of-Line in line %d (chksum).\r\n", lincnt);
				asexit(ER_FATAL);
			}
		}
		chksum += data;
		chksum += 1;
		if (chksum & 0xFF) {
			fprintf(stderr, "CheckSum Error in line %d.\r\n", lincnt);
			asexit(ER_FATAL);
		}
	}

	/*
	 * Check Binary Size
	 */
	if (binhi < OS9_HEADER_SIZE + OS9_CRC_SIZE) {
		fprintf(stderr, "OS9 Module Size Too Small.\r\n");
		asexit(ER_FATAL);
	}
	if (binhi > MAXSIZ) {
		fprintf(stderr, "OS9 Module Size Too Large.\r\n");
		asexit(ER_FATAL);
	}

	/*
	 * Check OS9 Module
	 */
	if ((bin[0] != OS9_ID0) ||
	    (bin[1] != OS9_ID1)) {
		fprintf(stderr, "OS9 Module ID not correct.\r\n");
		asexit(ER_FATAL);
	}
	if (bin[OS9_HEADER_SIZE-1] != OS9_IHC) {
		fprintf(stderr, "OS9 Initial Header Checksum not correct.\r\n");
		asexit(ER_FATAL);
	}
	if ((bin[--addr] != OS9_CRC2) ||
	    (bin[--addr] != OS9_CRC1) ||
	    (bin[--addr] != OS9_CRC0)) {
		fprintf(stderr, "OS9 Initial Module CRC not correct.\r\n");
		asexit(ER_FATAL);
	}

	/*
	 * Compute the Header Checksum
	 */
	bin[OS9_HEADER_SIZE-1] = os9_chk(bin, OS9_HEADER_SIZE);

	/*
	 * Compute the Module CRC
	 */
	if (os9_crc(bin, binhi-3, os9crc)) {
		fprintf(stderr, "Error Calculating OS9 CRC.\r\n");
		asexit(ER_FATAL);
	}
	for (i=0; i<OS9_CRC_SIZE; i++) {
		bin[addr++] = os9crc[i];
	}

	/*
	 * Output OS9 Binary Module
	 */
#ifdef	DECUS
	outfp = fopen(argv[ofarg], "wn");
#else
	outfp = fopen(argv[ofarg], "wb");
#endif
	if (outfp == NULL) {
		printf("\r\nOS9 Output File %s not opened.\r\n", argv[i]);
		asexit(ER_FATAL);
	}
	if (fwrite(bin, 1, binhi, outfp) != binhi) {
		fprintf(stderr, "OS9 Output File Error.\r\n");
		asexit(ER_FATAL);
	}

	asexit(0);
	return(0);
}

/*)Function	unsigned char	os9_hdr(ptr, sz)
 *
 *		unsigned char	*ptr	Pointer to Input Data Array
 *		unsigned int	sz	Number of Input Array Bytes
 *
 *	The function os9_chk() returns the computed checksum
 *	over sz bytes of the Input Data Array.
 *
 *	local variables:
 *		unsigned char	chksum	Temporary byte value
 *		unsigned int	i	loop counter
 *
 *	global variables:
 *		none
 *
 *	called functions:
 *		none
 *
 *	side effects:
 *		none
 */

unsigned char
os9_chk(ptr, sz)
unsigned char *ptr;
unsigned int sz;
{
	unsigned int	i;

	/*
	 * Compute the Header Checksum:
	 *	One's Complement of the
	 *	vertical parity (xor)
	 *	of sz bytes.
	 */
	for (i=0,chksum=0; i<sz; i++) {
		chksum ^= *ptr++;
	}
	return(chksum);
}

/*)Function	int	os9_crc(ptr, sz, crc)
 *
 *		unsigned char	*ptr	Pointer to Input Data Array
 *		unsigned int	sz	Number of Input Array Bytes
 *		unsigned char	*crc	CRC Array
 *
 *	local variables:
 *		int		ec	Error Code (OK==0, Error==1)
 *		unsigned char	a	Temporary byte value
 *		unsigned int	i	loop counter
 *
 *	global variables:
 *		none
 *
 *	called functions:
 *		none
 *
 *	side effects:
 *		The crc[] array elements contain the CRC of
 *		sz bytes from array ptr[].
 *
 ********************************************************************
 * crc.c - OS-9 CRC computation algorithm
 *
 * $Id: crc.c,v 1.2 2004/03/31 22:02:39 boisy Exp $
 ********************************************************************
 */

int
os9_crc(ptr, sz, crc)
unsigned char *ptr;
unsigned int sz;
unsigned char *crc;
{
	int		ec;
	unsigned char	a;
	unsigned int	i;

	/*
	 * Initialize CRC
	 */
	for (i=0; i<OS9_CRC_SIZE; i++) {
		crc[i] = 0xFF;
	}

	for (i = 0; i < sz; i++) {
		a = *(ptr++);

		a ^= crc[0];
		crc[0] = crc[1];
		crc[1] = crc[2];
		crc[1] ^= (a >> 7);
		crc[2] = (a << 1);
		crc[1] ^= (a >> 2);
		crc[2] ^= (a << 6);
		a ^= (a << 1);
		a ^= (a << 2);
		a ^= (a << 4);

		if (a & 0x80) {
			crc[0] ^= 0x80;
			crc[2] ^= 0x21;
		}
	}
	
	ec = 0;
	if ((crc[0] == OS9_CRC0) &&
	    (crc[1] == OS9_CRC1) &&
	    (crc[2] == OS9_CRC2)) {
		ec = 1;
	}
	return (ec);
}

/*)Function	int	axgetline()
 *
 *	The function getline() reads a line of text from the S19
 *	text file.  The input text line is transferred into the
 *	global string ib[] and converted to a NULL terminated string.
 *	The function getline() returns a (1) after succesfully
 *	reading a line,	or a (0) if the End-Of-File is found.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		char	ib[]		Input text string
 *		FILE	inpfp		file handle for S19 file
 *
 *	called functions:
 *		VOID	chopcrlf()	s19os9.c
 *		int	fclose()	c-library
 *		char *	fgets()		c-library
 *
 *	side effects:
 *		New line read from input file or file is closed.
 */

int
axgetline()
{
	if (fgets(ib, NINPUT, inpfp) == NULL) {
		fclose(inpfp);
		return (0);
	}
	chopcrlf(ib);
	return (1);
}

/*)Function	VOID	chopcrlf(str)
 *
 *		char	*str		string to chop
 *
 *	The function chopcrlf() removes
 *	LF, CR, LF/CR, or CR/LF from str
 *	and strips trailing white space.
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
 *		int	j		loop counter
 *
 *	global variables:
 *		FILE *	inpfp		input file handle
 *		FILE *	outfp		output file handle
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
	if (inpfp != NULL) fclose(inpfp);
	if (outfp != NULL) fclose(outfp);
	exit(i);
}


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

/*)Function	int	digit(c, r)
 *
 *		int	c		digit character
 *		int	r		current radix
 *
 *	The function digit() returns the value of c
 *	in the current radix r.  If the c value is not
 *	a number of the current radix then a -1 is returned.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		char	ctype[]		array of character types, one per
 *					ASCII character
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		none
 */

int
digit(c, r)
int c, r;
{
	if (r == 16) {
		if (ctype[c] & RAD16) {
			if (c >= 'A' && c <= 'F')
				return (c - 'A' + 10);
			if (c >= 'a' && c <= 'f')
				return (c - 'a' + 10);
			return (c - '0');
		}
	} else
	if (r == 10) {
		if (ctype[c] & RAD10)
			return (c - '0');
	} else
	if (r == 8) {
		if (ctype[c] & RAD8)
			return (c - '0');
	} else
	if (r == 2) {
		if (ctype[c] & RAD2)
			return (c - '0');
	}
	return (-1);
}


char *usetxt[] = {
	"Usage: file [-o ofile]"
	"",
	NULL
};

/*)Function	VOID	usage(n)
 *
 *		int	n		exit code
 *
 *	The function usage() outputs to the stderr device the
 *	program name and version and a list of valid options.
 *
 *	local variables:
 *		char **	dp		pointer to an array of
 *					text string pointers.
 *
 *	global variables:
 *		char	cpu[]		assembler type string
 *		char *	usetxt[]	array of string pointers
 *
 *	functions called:
 *		VOID	asexit()	s19os9.c
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		program is terminated
 */

VOID
usage(n)
int n;
{
	char   **dp;

	fprintf(stderr, "\nASxxxx S19 to OS9 Binary Module Translator %s\n\n", VERSION);
	for (dp = usetxt; *dp; dp++)
		fprintf(stderr, "%s\n", *dp);
	asexit(n);
}
