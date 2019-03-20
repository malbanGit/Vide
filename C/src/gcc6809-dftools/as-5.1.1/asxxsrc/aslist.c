/* aslist.c */

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
 *   With enhancements from
 *
 *	John L. Hartman	(JLH)
 *	jhartman at compuserve dot com
 *
 *	Mike McCarty
 *	mike dot mccarty at sbcglobal dot net
*/

#include "asxxxx.h"

/*)Module	aslist.c
 *
 *	The module aslist.c contains all the functions used
 *	to generate the assembler list and symbol output files.
 *
 *	aslist.c contains the following functions:
 *		VOID	list()
 *		VOID	list1()
 *		VOID	list2()
 *		VOID	listhlr()
 *		VOID	slew()
 *		VOID	lstsym()
 *
 *	The module aslist.c contains no local/static variables
 */

/*)Function	VOID	list()
 *
 *	The function list() generates the listing output
 *	which includes the input source, line numbers,
 *	and generated code.  Numerical output may be selected
 *	as hexadecimal, decimal, or octal.
 * 
 *	local variables:
 *		int	a		beginning character position for option
 *		int	b		number of character positions for option
 *		char *	frmt		format string
 *		int	i		for loop index
 *		int	hlr_lst		listed parameters for current line
 *		int	listing		LIST-NLIST state for current line
 *		int	n		maximum number of bytes listed per line
 *		int	nb		computed number of assembled bytes
 *		int	nl		number of bytes listed on this line
 *		int	op		output position in line
 *		int	paging		computed paging enable flag
 *		int *	wp		pointer to the assembled data bytes
 *		int *	wpt		pointer to the data byte mode
 *
 *	global variables:
 *		int	a_bytes		T line addressing size
 *		struct asmf * asmc	Pointer to the current
 *					source input structure
 *		int	cb[]		array of assembler output values
 *		int	cbt[]		array of assembler relocation types
 *					describing the data in cb[]
 *		int	cflag		-c, cycle count flag
 *		int *	cp		pointer to assembler output array cb[]
 *		char	eb[]		array of generated error codes
 *		char *	ep		pointer into error list
 *					array eb[]
 *		char *	il		pointer to assembler-source listing line
 *		a_uint	laddr		address of current assembler line,
 *				 	equate, or value of .if argument
 *		FILE *	lfp		list output file handle
 *		int	line		current assembler source line number
 *		int	lmode		listing mode
 *		int	lnlist		LIST-NLIST state
 *		int	pflag		-p, paging flag
 *		int	srcline		source file line number
 *		int	uflag		-u, disable .list/.nlist processing
 *		int	xflag		-x, listing radix flag
 *
 *	functions called:
 *		int	fprintf()	c_library
 *		VOID	list1()		aslist.c
 *		VOID	listhlr()	aslist.c
 *		int	putc()		c_library
 *		VOID	slew()		asslist.c
 *
 *	side effects:
 *		Listing or symbol output updated.
 */

/* The Output Formats, No Cycle Count
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

/* The Output Formats,  With Cycle Count [nn]
| Tabs- |       |       |       |       |       |
          11111111112222222222333333333344444-----
012345678901234567890123456789012345678901234-----
   |    |               |     | |
ee XXXX xx xx xx xx xx[nn]LLLLL *************	HEX(16)
ee 000000 ooo ooo ooo [nn]LLLLL *************	OCTAL(16)
ee  DDDDD ddd ddd ddd [nn]LLLLL *************	DECIMAL(16)
                     XXXX
		   OOOOOO
		    DDDDD

| Tabs- |       |       |       |       |       |
          11111111112222222222333333333344444-----
012345678901234567890123456789012345678901234-----
     |       |                  |     | |
ee    XXXXXX xx xx xx xx xx xx[nn]LLLLL *********	HEX(24)
ee   OO000000 ooo ooo ooo ooo [nn]LLLLL *********	OCTAL(24)
ee   DDDDDDDD ddd ddd ddd ddd [nn]LLLLL *********	DECIMAL(24)
                           XXXXXX
			 OOOOOOOO
			 DDDDDDDD

| Tabs- |       |       |       |       |       |
          11111111112222222222333333333344444-----
012345678901234567890123456789012345678901234-----
  |          |                  |     | |
ee  XXXXXXXX xx xx xx xx xx xx[nn]LLLLL *********	HEX(32)
eeOOOOO000000 ooo ooo ooo ooo [nn]LLLLL *********	OCTAL(32)
ee DDDDDDDDDD ddd ddd ddd ddd [nn]LLLLL *********	DECIMAL(32)
                         XXXXXXXX
		      OOOOOOOOOOO
		       DDDDDDDDDD
*/

/*
 *	The listing of the current assembler line is determined
 *	by the enabled listing parameters, lnlist, and the current
 *	listing mode, lmode.  The line is output to the listing
 *	file on the fly, ie not bufferred.  Therefor the sequence
 *	of the generated output is all important.  The following
 *	table is organized as lmode versus lnlist parameters
 *	ordered by location in the output listing line.
 *
 *				   lnlist
 *		|-------------------------------------------------|
 *	lmode	ERR	LOC	BIN	EQT	CYC	LIN	SRC
 *	-----	---	---	---	---	---	---	---
 *	SLIST						 *	 *
 *	ALIST	 *	 *				 *	 *
 *	BLIST	 *	 *				 *	 *
 *	CLIST	 *	 *	 *		 *	 *	 *
 *	ELIST	 *			 *		 *	 *
 *
 *	The generated HLR file, a hint file for the linker to
 *	create an RST file, will contain the listing flags enabled
 *	for each assembled line.
 *
 */

VOID
list()
{
	char *frmt, *wp;
	int *wpt;
	int n, nb, nl;
	int listing, paging;
	int hlr_lst;
	int a, b, i, op;

	/*
	 * Get Correct Line Number
	 */
	line = srcline;

	/*
	 * Internal Listing
	 */
	listing = lnlist;

	/*
	 * Listing Control Override
	 */
	if (uflag) {
		listing = LIST_BITS;
		if (lmode == NLIST) {
			lmode = SLIST;
		}
	}

	/*
	 * Paging Control
	 */
	paging = !pflag && ((lnlist & LIST_PAG) || (uflag == 1)) ? 1 : 0;

	/*
	 * ALIST/BLIST Output Processing
	 */
	if (lmode == ALIST) {
		outchk(HUGE,HUGE);
	}
	if (lmode == ALIST || lmode == BLIST) {
		outdot();
	}

	/*
	 * Check NO-LIST Conditions
	 */
	if ((lfp == NULL) || (lmode == NLIST)) {
		if ((cp - cb) || (rflag > 1)) {
			listhlr(HLR_NLST, lmode, (int) (cp - cb));
		}
		return;
	}

	/*
	 * Check Listing Nothing
	 */
	if (listing == LIST_NONE) {
		if ((cp - cb) || (rflag > 1)) {
			listhlr(HLR_NLST, lmode, (int) (cp - cb));
		}
		return;
	}

	/*
	 * ON ERROR override listing
	 */
	if ((ep != eb) && (listing & LIST_ERR)) {
		listing = LIST_ASM | LIST_ME;
	}

	switch (lmode) {
	case SLIST:
	case ALIST:
	case BLIST:
		if (asmc->objtyp == T_MACRO) {
			if (listing & LIST_ME) {
				listing |= LIST_ASM;
			} else {
				if ((ep != eb) && (listing & LIST_ERR)) {
					; /* Use listing mode in effect. */
				} else {
					if ((cp - cb) || (rflag > 1)) {
						listhlr(HLR_NLST, lmode, (int) (cp - cb));
					}
					return;
				}
			}
		}
		break;

	case ELIST:
		if (asmc->objtyp == T_MACRO) {
			if (listing & LIST_ME) {
				listing |= LIST_ASM;
			} else {
				if ((ep != eb) && (listing & LIST_ERR)) {
					; /* Use listing mode in effect. */
				} else {
					if ((cp - cb) || (rflag > 1)) {
						listhlr(HLR_NLST, lmode, (int) (cp - cb));
					}
					return;
				}
			}
		}
		break;

	case CLIST:
		if (asmc->objtyp == T_MACRO) {
			if (listing & LIST_ME) {
				listing |= LIST_ASM;
			} else
			if ((listing & LIST_MEB) && ((int) (cp - cb))) {
				listing = LIST_BIN;
			} else {
				if ((ep != eb) && (listing & LIST_ERR)) {
					; /* Use listing mode in effect. */
				} else {
					if ((cp - cb) || (rflag > 1)) {
						listhlr(HLR_NLST, lmode, (int) (cp - cb));
					}
					return;
				}
			}
		}
		break;

	default:
		if ((cp - cb) || (rflag > 1)) {
			listhlr(HLR_NLST, lmode, (int) (cp - cb));
		}
		return;
	}

	/*
	 * Move to next line.
	 */
	slew(lfp, paging);

	/*
	 * Initialize parameters
	 */
	hlr_lst = LIST_NONE;
	op = 0;
	n = nb = nl = (int) (cp - cb);
	wp = cb;
	wpt = cbt;

	/*
	 * LIST_ERR - Output a maximum of NERR error codes with listing.
	 */
	if (listing & LIST_ERR) {
		if (eb != ep) {
			switch(lmode) {
			default:
			case SLIST:
				break;
			case ALIST:
			case BLIST:
			case CLIST:
			case ELIST:
				hlr_lst |= LIST_ERR;
				while (ep < &eb[NERR])
					*ep++ = ' ';
				fprintf(lfp, "%.2s", eb);
				op = 2;
				break;
			}
		}
	}

	/*
	 * LIST_LOC - Location Address
	 */
	if (listing & LIST_LOC) {
		switch(lmode) {
		default:
		case SLIST:
		case ELIST:
			break;
		case ALIST:
		case BLIST:
		case CLIST:
			hlr_lst |= LIST_LOC;
			switch (xflag) {
			default:
			case 0:		/* HEX */
#ifdef	LONGINT
				switch(a_bytes) {
				default:
				case 2: a = 3; b = 4; frmt = "%04lX"; break;
				case 3: a = 6; b = 6; frmt = "%06lX"; break;
				case 4: a = 4; b = 8; frmt = "%08lX"; break;
				}
#else
				switch(a_bytes) {
				default:
				case 2: a = 3; b = 4; frmt = "%04X"; break;
				case 3: a = 6; b = 6; frmt = "%06X"; break;
				case 4: a = 4; b = 8; frmt = "%08X"; break;
				}
#endif
				break;

			case 1:		/* OCTAL */
#ifdef	LONGINT
				switch(a_bytes) {
				default:
				case 2: a = 3; b = 6; frmt = "%06lo"; break;
				case 3: a = 5; b = 8; frmt = "%08lo"; break;
				case 4: a = 2; b = 11; frmt = "%011lo"; break;
				}
#else
				switch(a_bytes) {
				default:
				case 2: a = 3; b = 6; frmt = "%06o"; break;
				case 3: a = 5; b = 8; frmt = "%08o"; break;
				case 4: a = 2; b = 11; frmt = "%011o"; break;
				}
#endif
				break;

			case 2:		/* DECIMAL */
#ifdef	LONGINT
				switch(a_bytes) {
				default:
				case 2: a = 4; b = 5; frmt = "%05lu"; break;
				case 3: a = 5; b = 8; frmt = "%08lu"; break;
				case 4: a = 3; b = 10; frmt = "%010lu"; break;
				}
#else
				switch(a_bytes) {
				default:
				case 2: a = 4; b = 5; frmt = "%05u"; break;
				case 3: a = 5; b = 8; frmt = "%08u"; break;
				case 4: a = 3; b = 10; frmt = "%010u"; break;
				}
#endif
				break;
			}
			for (i=0; i<(a-op); i++) {
				fprintf(lfp, " ");
			}
			op = a;
			fprintf(lfp, frmt, laddr & a_mask);
			op += b;
		}
	}

	/*
	 * LIST_BIN - List binary output
	 */
	if (listing & LIST_BIN) {
		if (nb != 0) {
			switch(lmode) {
			default:
			case SLIST:
			case ALIST:
			case BLIST:
			case ELIST:
				break;
			case CLIST:
				hlr_lst |= LIST_BIN;
				switch (xflag) {
				default:
				case 0:		/* HEX */
					switch(a_bytes) {
					default:
					case 2: a = 7; b = 3; n = 6; break;
					case 3:
					case 4: a = 12; b = 3; n = 7; break;
					}
					break;

				case 1:		/* OCTAL */
					switch(a_bytes) {
					default:
					case 2: a = 9; b = 4; n = 4; break;
					case 3:
					case 4: a = 13; b = 4; n = 5; break;
					}
					break;

				case 2:		/* DECIMAL */
					switch(a_bytes) {
					default:
					case 2: a = 9; b = 4; n = 4; break;
					case 3:
					case 4: a = 13; b = 4; n = 5; break;
					}
					break;
				}
				for (i=0; i<(a-op); i++) {
					fprintf(lfp, " ");
				}
				op = a;

				/*
				 * If we list cycles decrease maximum bytes on this line.
				 */
				nl = (!cflag && !(opcycles & OPCY_NONE) && (listing & LIST_CYC)) ? (n-1) : n;
				nl = (nb > nl) ? nl : nb;
				list1(wp, wpt, nl);
				wp += nl;
				wpt += nl;
				op += (nl * b);
			}
		}
	}

	/*
	 * LIST_EQT - Equate Listing Option
	 */
	if (listing & LIST_EQT) {
		switch(lmode) {
		default:
		case SLIST:
		case ALIST:
		case BLIST:
		case CLIST:
			break;
		case ELIST:
			hlr_lst |= LIST_EQT;
			switch (xflag) {
			default:
			case 0:		/* HEX */
#ifdef	LONGINT
				switch(a_bytes) {
				default:
				case 2: a = 21; b = 4; frmt = "%04lX"; break;
				case 3: a = 27; b = 6; frmt = "%06lX"; break;
				case 4: a = 25; b = 8; frmt = "%08lX"; break;
				}
#else
				switch(a_bytes) {
				default:
				case 2: a = 21; b = 4; frmt = "%04X"; break;
				case 3: a = 27; b = 6; frmt = "%06X"; break;
				case 4: a = 25; b = 8; frmt = "%08X"; break;
				}
#endif
				break;

			case 1:		/* OCTAL */
#ifdef	LONGINT
				switch(a_bytes) {
				default:
				case 2: a = 19; b = 6; frmt = "%06lo"; break;
				case 3: a = 25; b = 8; frmt = "%08lo"; break;
				case 4: a = 22; b = 11; frmt = "%011lo"; break;
				}
#else
				switch(a_bytes) {
				default:
				case 2: a = 19; b = 6; frmt = "%06o"; break;
				case 3: a = 25; b = 8; frmt = "%08o"; break;
				case 4: a = 22; b = 11; frmt = "%011o"; break;
				}
#endif
				break;

			case 2:		/* DECIMAL */
#ifdef	LONGINT
				switch(a_bytes) {
				default:
				case 2: a = 20; b = 5; frmt = "%05lu"; break;
				case 3: a = 25; b = 8; frmt = "%08lu"; break;
				case 4: a = 23; b = 10; frmt = "%%010lu"; break;
				}
#else
				switch(a_bytes) {
				default:
				case 2: a = 20; b = 5; frmt = "%05u"; break;
				case 3: a = 25; b = 8; frmt = "%08u"; break;
				case 4: a = 23; b = 10; frmt = "%010u"; break;
				}
#endif
				break;
			}
			for (i=0; i<(a-op); i++) {
				fprintf(lfp, " ");
			}
			op = a;
			fprintf(lfp, frmt, laddr & a_mask);
			op += b;
			break;
		}
	}

	/*
	 * LIST_CYC - Output opcode cycle count with listing.
	 */
	if (listing & LIST_CYC) {
		if (!cflag && !(opcycles & OPCY_NONE)) {
			switch(lmode) {
			default:
			case SLIST:
			case ALIST:
			case BLIST:
			case ELIST:
				break;
			case CLIST:
				hlr_lst |= LIST_CYC;
				switch(a_bytes) {
				default:
				case 2: a = 22; b = 4; break;
				case 3:
				case 4: a = 30; b = 4; break;
				}
				for (i=0; i<(a-op); i++) {
					fprintf(lfp, " ");
				}
				op = a;
				fprintf(lfp, "%c%2d%c", CYCNT_BGN, opcycles, CYCNT_END);
				op += b;
				break;
			}
		}
	}

	/*
	 * LIST_LIN - Output line number with listing.
	 */
	if (listing & LIST_LIN) {
		switch(lmode) {
		default:
			break;
		case SLIST:
		case ALIST:
		case BLIST:
		case ELIST:
		case CLIST:
			hlr_lst |= LIST_LIN;
			switch(a_bytes) {
			default:
			case 2: a = 26; b = 5; break;
			case 3:
			case 4: a = 34; b = 5; break;
			}
			for (i=0; i<(a-op); i++) {
				fprintf(lfp, " ");
			}
			op = a;
			fprintf(lfp, "%5u", line);
			op += b;
			break;
		}
	}

	/*
	 * LIST_SRC - Output assembler source with listing.
	 */
	if (listing & LIST_SRC) {
		switch(lmode) {
		default:
			break;
		case SLIST:
		case ALIST:
		case BLIST:
		case ELIST:
		case CLIST:
			hlr_lst |= LIST_SRC;
			switch(a_bytes) {
			default:
			case 2: a = 32; break;
			case 3:
			case 4: a = 40; break;
			}
			for (i=0; i<(a-op); i++) {
				fprintf(lfp, " ");
			}
			fprintf(lfp, "%s", il);
			break;
		}
	}

	/*
	 * Check Listing Nothing
	 */
	if (hlr_lst == LIST_NONE) {
		if ((cp - cb) || (rflag > 1)) {
			listhlr(HLR_NLST, lmode, (int) (cp - cb));
		}
		return;
	}

	/*
	 * Listing output line complete
	 */
	fprintf(lfp, "\n");
	if (!(hlr_lst & LIST_BIN)) {
		listhlr(hlr_lst, lmode, (int) (cp - cb));
		return;
	} else
	if (nb == 0) {
		listhlr(hlr_lst, lmode, 0);
		return;
	} else {
		listhlr(hlr_lst, lmode, nl);
		nb = (nb > nl) ? (nb - nl) : 0;
		if (nb == 0) {
			return;
		}
	}

	/*
	 * Subsequent lines of output if more data.
	 */
	if (listing & LIST_BIN) {
		/*
		 * Format
		 */
		switch (xflag) {
		default:
		case 0:		/* HEX */
			switch(a_bytes) {
			default:
			case 2: frmt = "%7s"; break;
			case 3:
			case 4: frmt = "%12s"; break;
			}
			break;

		case 1:		/* OCTAL */
			switch(a_bytes) {
			default:
			case 2: frmt = "%9s"; break;
			case 3:
			case 4: frmt = "%13s"; break;
			}
			break;

		case 2:		/* DECIMAL */
			switch(a_bytes) {
			default:
			case 2: frmt = "%9s"; break;
			case 3:
			case 4: frmt = "%13s"; break;
			}
			break;
		}

		while (nb > 0) {
			nl = (nb > n) ? n : nb;
			slew(lfp, paging);
			fprintf(lfp, frmt, "");
			list1(wp, wpt, nl);
			putc('\n', lfp);
			listhlr(LIST_BIN, lmode, nl);
			nb -= nl;
			wp += nl;
			wpt += nl;
		}
	}
}

/*)Function	VOID	list1(wp, wpt, n)
 *
 *		int	nb		number of bytes listed per line
 *		int *	wp		pointer to data bytes
 *		int *	wpt		pointer to data byte mode
 *
 *	local variables:
 *		int	i		loop counter
 *		char *	frmt		data format
 *
 *	global variables:
 *		int	xflag		-x, listing radix flag
 *
 *	functions called:
 *		VOID	list2()		asslist.c
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		Data formatted and output to listing.
 */

VOID
list1(wp, wpt, nb)
char *wp;
int *wpt, nb;
{
	int i;
	char *frmt;

	switch (xflag) {
	default:
	case 0:		/* HEX */
		frmt = "%02X";
		break;

	case 1:		/* OCTAL */
		frmt = "%03o";
		break;

	case 2:		/* DECIMAL */
		frmt = "%03u";
		break;
	}

	/*
	 * Output bytes.
	 */
	for (i=0; i<nb; ++i) {
		list2(*wpt++);
		fprintf(lfp, frmt, (*wp++)&0377);
	}
}

/*)Function	VOID	list2(t)
 *
 *		int	t		relocation mode
 *
 *	The function list2() outputs the selected
 *	relocation flag as specified by fflag.
 *
 *	local variables:
 *		int	c		relocation flag character
 *
 *	global variables:
 *		int	fflag		-f(f), relocations flagged flag
 *
 *	functions called:
 *		int	putc()		c_library
 *
 *	side effects:
 *		Relocation flag output to listing file.
 */

VOID
list2(t)
int t;
{
	int c;

	c = ' ';

	/*
	 * Designate a relocatable word by `.
	 */
	if (fflag == 1) {
		if (t & R_RELOC) {
			c = '`';
		}
	} else
	/*
	 * Designate a relocatable word by its mode:
	 *	paged			* (n) (M) (N)
	 *	unsigned/bit range	u (v) (U) (V)
	 *	operand offset		p (q) (P) (Q)
	 *	relocatable symbol	r (s) (R) (S)
	 */
	if (fflag >= 2) {
		if (t & R_RELOC) {
			if (t & R_PCR) {
				c = 'p';
			} else
			if (t & R_PAGE) {
				c = '*';
			} else
			if ((t & (R_SGND | R_USGN)) == R_USGN) {
				c = 'u';
			} else {
				c = 'r';
			}
			if (c == '*') {
				if (t & R_HIGH) c = 'n';
				if (t & R_BYT3) c = 'M';
				if (t & R_BYT4) c = 'N';
			} else {
				if (t & R_HIGH || t & R_BYT4) c += 1;
				if (t & R_BYT3 || t & R_BYT4) c &= ~0x20;
			}
		}
	}

	/*
	 * Output the selected mode.
	 */
	putc(c, lfp);
}

/*)Function	VOID	listhlr(hlr_lst, hlr_mode, nb)
 *
 *		int	hlr_lst		output listing flags for src line
 *		int	hlr_mode	output listing mode for src line
 *		int	hlr_nb		number of bytes output for this line
 *
 *	The function listhlr() outputs
 *	the hints for this assembled line.
 *
 *	local variables:
 *		char *	frmt		output format specifier
 *
 *	global variables:
 *		char *	eqt_area	.area of equate evaluation
 *		FILE *	hfp		HLR file handle
 *		int	rflag		output line number in hint file
 *		int	xflag		listing radix flag
 *
 *	functions called:
 *		int	fprintf()		c_library
 *
 *	side effects:
 *		A line of hint parameters
 *		is written to the HLR file.
 */

VOID
listhlr(hlr_lst, hlr_mode, hlr_nb)
int hlr_lst;
int hlr_mode;
int hlr_nb;
{
	char *frmt;

	if (hfp == NULL)
		return;

	if (rflag) {
		fprintf(hfp, "  %5u", line);
	}

	switch (xflag) {
	default:
	case 0:		/* HEX */
		frmt = " %02X %02X %02X";
		break;

	case 1:		/* OCTAL */
		frmt = " %03o %03o %03o";
		break;

	case 2:		/* DECIMAL */
		frmt = " %03u %03u %03u";
		break;
	}
	fprintf(hfp, frmt, hlr_lst, hlr_mode, hlr_nb);
	if (lmode == ELIST) {
		if (eqt_area != NULL) {
			fprintf(hfp, " %s", eqt_area);
		}
	}
	fprintf(hfp, "\n");
}


/*)Function	VOID	slew(fp, flag)
 *
 *		FILE *	fp		file handle for listing
 *		int	flag		enable pagination
 *
 *	The function slew() increments the page line count.
 *	If the page overflows and pagination is enabled:
 *		1)	put out a page skip,
 *		2)	assembler info and page number
 *		3)	Number Type and current time
 *		4)	a title,
 *		5)	a subtitle,
 *		6)	and reset the line count.
 *
 *	local variables:
 *		char *	frmt		string format
 *		char	np[]		new page string
 *		char	tp[]		temporary string
 *
 *	global variables:
 *		char	cpu[]		cpu type string
 *		time_t	curtim		current time string pointer
 *		int	lop		current line number on page
 *		int	page		current page number
 *		char	stb[]		Subtitle string buffer
 *		char	tb[]		Title string buffer
 *
 *	functions called:
 *		char *	ctime()		c_library
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		Increments page line counter, on overflow
 *		a new page header is output to the listing file.
 */

VOID
slew(fp,flag)
FILE *fp;
int flag;
{
	char *frmt;
	char np[80];
	char tp[80];

	if (lop++ >= NLPP) {
		if (flag) {
			/*
			 *12345678901234567890123456789012345678901234567890123456789012345678901234567890
			 *ASxxxx Assembler Vxx.xx (Motorola 6809)                                 Page 1
			 */
			/*
			 * Total string length is 78 characters.
			 */
			sprintf(tp, "ASxxxx Assembler %s (%s)", VERSION, cpu);
			sprintf(np, "%-78s", tp);
			/*
			 * Right justify page number in string.
			 */
			sprintf(tp, "Page %u", ++page);
			strncpy(&np[strlen(np) - strlen(tp)], tp, strlen(tp));
			/*
			 * Output string.
			 */
#if NOFORMFEED
			fprintf(fp, "%s\n", np);
#else
			fprintf(fp, "\f%s\n", np);
#endif
			/*
			 *12345678901234567890123456789012345678901234567890123456789012345678901234567890
			 *Hexadecimal [16-Bits]                                 Sun Sep 15 17:22:25 2013
			 */
			/*
			 * Total string length is 78 characters.
			 */
			switch(xflag) {
			default:
			case 0:	frmt = "Hexadecimal [%d-Bits]"; break;
			case 1:	frmt = "Octal [%d-Bits]"; break;
			case 2:	frmt = "Decimal [%d-Bits]"; break;
			}
			sprintf(tp, frmt, 8 * a_bytes);
			sprintf(np, "%-78s", tp);
			/*
			 * Right justify current time in string.
			 */
			strncpy(&np[strlen(np) - 24], ctime(&curtim), 24);
			/*
			 * Output string.
			 */
			fprintf(fp, "%s\n", np);
			fprintf(fp, "%s\n", tb);
			fprintf(fp, "%s\n\n", stb);
			if (fp == lfp) {
				for (lop=1; lop<6; lop++) {
					listhlr(LIST_SRC, SLIST, 0);
				}
			}
			lop = 6;
		} else {
			lop = 1;
		}
	}
}

/*)Function	VOID	lstsym(fp)
 *
 *		FILE *	fp		file handle for output
 *
 *	The function lstsym() outputs alphabetically
 *	sorted symbol and area tables.
 *
 *	local variables:
 *		int	c		temporary
 *		int	i		loop counter
 *		int	j		temporary
 *		int	k		temporary
 *		int	nmsym		number of symbols
 *		int	narea		number of areas
 *		sym **	p		pointer to an array of
 *					pointers to symbol structures
 *		int	paging		computed paging enable flag
 *		char *	ptr		pointer to an id string
 *		a_uint	sa		temporary
 *		sym *	sp		pointer to symbol structure
 *		area *	ap		pointer to an area structure
 *
 *	global variables:
 *		area *	areap		pointer to an area structure
 *		char	aretbl[]	string "Area Table"
 *		sym	dot		defined as sym[0]
 *		int	lnlist		LIST-NLIST state
 *		char	stb[]		Subtitle string buffer
 *		sym * symhash[]		array of pointers to NHASH
 *					linked symbol lists
 *		char	symtbl[]	string "Symbol Table"
 *		FILE *	tfp		symbol table output file handle
 *		int	uflag		LIST-NLIST override flag
 *		int	wflag		-w, wide listing flag
 *		int	xflag		-x, listing radix flag
 *
 *	functions called:
 *		int	fprintf()	c_library
 *		int	putc()		c_library
 *		VOID	slew()		aslist.c
 *		int	strcmp()	c_library
 *		char *	strcpy()	c_library
 *
 *	side effects:
 *		Symbol and area tables output.
 */

VOID
lstsym(fp)
FILE *fp;
{
	int c, i, j, k, n, paging;
	int nmsym, narea, nbank;
	a_uint sa;
	char *frmt, *ptr;
	struct sym *sp;
	struct sym **p;
	struct area *ap;
	struct bank *bp;

	/*
	 * Symbol Table Header
	 */
	strcpy(stb, &symtbl[0]);
	lop = NLPP;
	if (fp == tfp) {
		page = 0;
		paging = 1;
	} else {
		paging = !pflag && ((lnlist & LIST_PAG) || (uflag == 1)) ? 1 : 0;
	}
	slew(fp, 1);

	/*
	 * Find number of symbols
	 */
	nmsym = 0;
	for (i=0; i<NHASH; i++) {
		sp = symhash[i];
		while (sp) {
			if (sp != &dot)
				++nmsym;
			sp = sp->s_sp;
		}
	}
	if (nmsym == 0)
		goto atable;

	/*
	 * Allocate space for an array of pointers to symbols
	 * and load array.
	 */
	p = (struct sym **) new (sizeof((struct sym *) sp)*nmsym);
	nmsym = 0;
	for (i=0; i<NHASH; i++) {
		sp = symhash[i];
		while (sp) {
			if (sp != &dot)
				p[nmsym++] = sp;
			sp = sp->s_sp;
		}
	}

	/*
	 * Bubble Sort on Symbol Table Array
	 */
	j = 1;
	c = nmsym - 1;
	while (j) {
		j = 0;
		for (i=0; i<c; ++i) {
			if (strcmp(&p[i]->s_id[0],&p[i+1]->s_id[0]) > 0) {
				j = 1;
				sp = p[i+1];
				p[i+1] = p[i];
				p[i] = sp;
			}
		}
	}

	/*
	 * Symbol Table Output
	 */
	for (i=0; i<nmsym;) {
		sp = p[i];
		if (sp->s_area) {
			j = sp->s_area->a_ref;
			switch(xflag) {
			default:
			case 0:	frmt = " %2X "; break;
			case 1:	frmt = "%3o "; break;
			case 2:	frmt = "%3u "; break;
			}
			fprintf(fp, frmt, j);
		} else {
			fprintf(fp, "    ");
		}

		ptr = &sp->s_id[0];
		if (wflag) {
			fprintf(fp, "%-55.55s", ptr );	/* JLH */
		} else {
			fprintf(fp, "%-14.14s", ptr);
		}
		if (sp->s_flag & S_ASG) {
			fprintf(fp, " = ");
		} else {
			fprintf(fp, "   ");
		}
		if (sp->s_type == S_NEW) {
			switch(a_bytes) {
			default:
			case 2:
				switch(xflag) {
				default:
				case 0:	frmt = "  **** "; break;
				case 1:	frmt = "****** "; break;
				case 2:	frmt = " ***** "; break;
				}
				break;

			case 3:
				switch(xflag) {
				default:
				case 0:	frmt = "  ****** "; break;
				case 1:	frmt = "******** "; break;
				case 2:	frmt = "******** "; break;
				}
				break;

			case 4:
				switch(xflag) {
				default:
				case 0:	frmt = "   ******** "; break;
				case 1:	frmt = "*********** "; break;
				case 2:	frmt = " ********** "; break;
				}
				break;

			}
			fputs(frmt, fp);
		} else {
			sa = sp->s_addr & a_mask;
#ifdef	LONGINT
			switch(a_bytes) {
			default:
			case 2:
				switch(xflag) {
				default:
				case 0:	frmt = "  %04lX "; break;
				case 1:	frmt = "%06lo "; break;
				case 2:	frmt = " %05lu "; break;
				}
				break;

			case 3:
				switch(xflag) {
				default:
				case 0:	frmt = "  %06lX "; break;
				case 1:	frmt = "%08lo "; break;
				case 2:	frmt = "%08lu "; break;
				}
				break;

			case 4:
				switch(xflag) {
				default:
				case 0:	frmt = "   %08lX "; break;
				case 1:	frmt = "%011lo "; break;
				case 2:	frmt = " %010lu "; break;
				}
				break;
			}
#else
			switch(a_bytes) {
			default:
			case 2:
				switch(xflag) {
				default:
				case 0:	frmt = "  %04X "; break;
				case 1:	frmt = "%06o "; break;
				case 2:	frmt = " %05u "; break;
				}
				break;

			case 3:
				switch(xflag) {
				default:
				case 0:	frmt = "  %06X "; break;
				case 1:	frmt = "%08o "; break;
				case 2:	frmt = "%08u "; break;
				}
				break;

			case 4:
				switch(xflag) {
				default:
				case 0:	frmt = "   %08X "; break;
				case 1:	frmt = "%011o "; break;
				case 2:	frmt = " %010u "; break;
				}
				break;
			}
#endif
			fprintf(fp, frmt, sa);
		}

		j = 0;
		if (sp->s_flag & S_GBL) {
			putc('G', fp);
			++j;
		}
		if (sp->s_flag & S_LCL) {
			putc('L', fp);
			++j;
		}
		if (sp->s_area != NULL) {
			putc('R', fp);
			++j;
		}
		if (sp->s_type == S_NEW) {
			putc('X', fp);
			++j;
		}
		if (wflag) {
			putc('\n', fp);		/* JLH */
			slew(fp, paging);
			++i;
		} else {
			if (++i % 2 == 0) {
				putc('\n', fp);
				slew(fp, paging);
			} else
			if (i < nmsym) {
				while (j++ < 4)
					putc(' ', fp);
				fprintf(fp, "| ");
			}
		}
	}
	if (nmsym % 2) {
		putc('\n', fp);
	}
	putc('\n', fp);

	/*
	 * Area Table Header
	 */

atable:
	strcpy(stb, &aretbl[0]);
	lop = NLPP;
	slew(fp, 1);

	/*
	 * Area Table Output
	 */
	narea = areap->a_ref + 1;
	nbank = bankp->b_ref + 1;

	for (n=0; n<nbank; ++n) {
		bp = bankp;
		for (j=n+1; j<nbank; ++j)
			bp = bp->b_bp;
		if (nbank > 1) {
			fprintf(fp, "[%.79s]\n", bp->b_id );
			slew(fp, paging);
		}
	 	for (i=0; i<narea; ++i) {
			ap = areap;
			for (j=i+1; j<narea; ++j)
				ap = ap->a_ap;
			j = ap->a_ref;
			if ((n == 0) && (ap->b_bp == NULL)) {
				;
			} else
			if (ap->b_bp != bp) {
				continue;
			}
			switch(xflag) {
			default:
			case 0:	frmt = "  %2X "; break;
			case 1:	frmt = " %3o "; break;
			case 2:	frmt = " %3u "; break;
			}
			fprintf(fp, frmt, j);

			ptr = &ap->a_id[0];
			if (wflag) {
				fprintf(fp, "%-35.35s", ptr );
			} else {
				fprintf(fp, "%-14.14s", ptr);
			}

			sa = ap->a_size & a_mask;
			k = ap->a_flag;
#ifdef	LONGINT
			switch(a_bytes) {
			default:
			case 2:
				switch(xflag) {
				default:
				case 0:	frmt = "   size %4lX   flags %4X\n"; break;
				case 1:	frmt = "   size %6lo   flags %6o\n"; break;
				case 2:	frmt = "   size %5lu   flags %6u\n"; break;
				}
				break;

			case 3:
				switch(xflag) {
				default:
				case 0:	frmt = "   size %6lX   flags %4X\n"; break;
				case 1:	frmt = "   size %8lo   flags %6o\n"; break;
				case 2:	frmt = "   size %8lu   flags %6u\n"; break;
				}
				break;

			case 4:
				switch(xflag) {
				default:
				case 0:	frmt = "   size %8lX   flags %4X\n"; break;
				case 1:	frmt = "   size %11lo   flags %6o\n"; break;
				case 2:	frmt = "   size %10lu   flags %6u\n"; break;
				}
				break;
			}
#else
			switch(a_bytes) {
			default:
			case 2:
				switch(xflag) {
				default:
				case 0:	frmt = "   size %4X   flags %4X\n"; break;
				case 1:	frmt = "   size %6o   flags %6o\n"; break;
				case 2:	frmt = "   size %5u   flags %6u\n"; break;
				}
				break;

			case 3:
				switch(xflag) {
				default:
				case 0:	frmt = "   size %6X   flags %4X\n"; break;
				case 1:	frmt = "   size %8o   flags %6o\n"; break;
				case 2:	frmt = "   size %8u   flags %6u\n"; break;
				}
				break;

			case 4:
				switch(xflag) {
				default:
				case 0:	frmt = "   size %8X   flags %4X\n"; break;
				case 1:	frmt = "   size %11o   flags %6o\n"; break;
				case 2:	frmt = "   size %10u   flags %6u\n"; break;
				}
				break;
			}
#endif
			fprintf(fp, frmt, sa, k);
			slew(fp, paging);
		}
	}
	putc('\n', fp);
}


