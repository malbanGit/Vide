/* lklist.c */

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
 */

#include "aslink.h"

/*)Module	lklist.c
 *
 *	The module lklist.c contains the functions which
 *	output the linker .map file and produce a relocated
 *	listing .rst file.
 *
 *	lklist.c contains the following functions:
 *		int	dgt()
 *		VOID	gethlr()
 *		VOID	newpag()
 *		VOID	slew()
 *		VOID	lstarea()
 *		VOID	lkulist()
 *		VOID	lkalist()
 *		VOID	lkglist()
 *		VOID	hlralist()
 *		VOID	hlrglist()
 *
 *	lklist.c contains no local variables.
 */

/*)Function	VOID	newpag(fp)
 *
 *		FILE *	fp		file handle for listing
 *
 *	The function newpag() provide pagination.
 *		1)	put out a page skip,
 *		2)	linker info and page number,,
 *		3)	Number Type and current time,
 *		4)	and reset the line count.
 *
 *	local variables:
 *		char *	frmt		string format
 *		char	np[]		new page string
 *		char	tp[]		temporary string
 *
 *	global variables:
 *		time_t	curtim		current time string pointer
 *		int	lop		current line number on page
 *		int	page		current page number
 *
 *	functions called:
 *		char *	ctime()		c_library
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		The page and line counters are updated.
 */

VOID
newpag(fp)
FILE *fp;
{
	char *frmt;
	char np[80];
	char tp[80];
	/*
	 *12345678901234567890123456789012345678901234567890123456789012345678901234567890
	 *ASxxxx Linker Vxx.xx                                                    Page 1
	 */
	/*
	 * Total newpag() string length is 78 characters.
	 */
	sprintf(np, "ASxxxx Linker %-64s", VERSION);
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
	lop = 3;
}

/*)Function	int	dgt(rdx,str,n)
 *
 *		int	rdx		radix bit code
 *		char	*str		pointer to the test string
 *		int	n		number of characters to check
 *
 *	The function dgt() verifies that the string under test
 *	is of the specified radix.
 *
 *	local variables:
 *		int	i		loop counter
 *
 *	global variables:
 *		ctype[]			array of character types
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		none
 */

int
dgt(rdx, str, n)
int rdx, n;
char *str;
{
	int i;

	for (i=0; i<n; i++) {
		if ((ctype[*str++ & 0x007F] & rdx) == 0)
			return(0);
	}
	return(1);
}

/*)Function	VOID	slew(xp, yp)
 *
 *		area *	xp		pointer to an area structure
 *		bank *	yp		pointer to a  bank structure
 *
 *	The function slew() increments the page line counter.
 *	If the number of lines exceeds the maximum number of
 *	lines per page then a page skip and a page header are
 *	output.
 *
 *	local variables:
 *		a_uint	ai		temporary
 *		a_uint	aj		temporary
 *		int	i		loop counter
 *		int	n		repeat counter
 *		char *	frmta		temporary format specifier
 *		char *	frmtb		temporary format specifier
 *		char *	ptr		pointer to an id string
 *
 *	global variables:
 *		int	a_bytes		T line address bytes
 *		int	a_mask		addressing mask
 *		int	lop		current line number on page
 *		FILE	*mfp		Map output file handle
 *		int	wflag		Wide format listing
 *		int	xflag		Map file radix type flag
 *
 *	functions called:
 *		int	fprintf()	c_library
 *		VOID	newpag()	lklist.c
 *		char	putc()		c_library
 *
 *	side effects:
 *		The page line and the page count may be updated.
 */

VOID
slew(xp,yp)
struct area *xp;
struct bank *yp;
{
	int i, n;
	char *frmta, *frmtb, *ptr;
 	a_uint	ai, aj;

       	if (lop++ >= NLPP) {
		newpag(mfp);
		if (*yp->b_id) {
			fprintf(mfp, "[ Bank == %s ]\n", yp->b_id);
			lop += 1;
		}
		fprintf(mfp, "\n");
		fprintf(mfp,
			"Area                       Addr   ");
		fprintf(mfp,
			"     Size        Decimal Bytes (Attributes)\n");
		fprintf(mfp,
			"--------------------       ----   ");
		fprintf(mfp,
			"     ----        ------- ----- ------------\n");

		ai = xp->a_addr & a_mask;
		aj = ((1 + (A4_WLMSK & xp->a_flag)) * xp->a_size) & a_mask;

		/*
		 * Output Area Header
		 */
		ptr = &xp->a_id[0];
		fprintf(mfp, "%-19.19s", ptr);
#ifdef	LONGINT
		switch(a_bytes) {
		default:
		case 2:
			switch(xflag) {
			default:
			case 0: frmta = "        %04lX        %04lX"; break;
			case 1: frmta = "      %06lo      %06lo"; break;
			case 2: frmta = "       %05lu       %05lu"; break;
			}
			frmtb = " =      %6lu. bytes "; break;
		case 3:
			switch(xflag) {
			default:
			case 0: frmta = "      %06lX      %06lX"; break;
			case 1: frmta = "    %08lo    %08lo"; break;
			case 2: frmta = "    %08lu    %08lu"; break;
			}
			frmtb = " =    %8lu. bytes "; break;
		case 4:
			switch(xflag) {
			default:
			case 0: frmta = "    %08lX    %08lX"; break;
			case 1: frmta = " %011lo %011lo"; break;
			case 2: frmta = "  %010lu  %010lu"; break;
			}
			frmtb = " =  %10lu. bytes "; break;
		}
#else
		switch(a_bytes) {
		default:
		case 2:
			switch(xflag) {
			default:
			case 0: frmta = "        %04X        %04X"; break;
			case 1: frmta = "      %06o      %06o"; break;
			case 2: frmta = "       %05u       %05u"; break;
			}
			frmtb = " =      %6u. bytes "; break;
		case 3:
			switch(xflag) {
			default:
			case 0: frmta = "      %06X      %06X"; break;
			case 1: frmta = "    %08o    %08o"; break;
			case 2: frmta = "    %08u    %08u"; break;
			}
			frmtb = " =    %8u. bytes "; break;
		case 4:
			switch(xflag) {
			default:
			case 0: frmta = "    %08X    %08X"; break;
			case 1: frmta = " %011o %011o"; break;
			case 2: frmta = "  %010u  %010u"; break;
			}
			frmtb = " =  %10u. bytes "; break;
		}
#endif
		fprintf(mfp, frmta, ai, aj);
		fprintf(mfp, frmtb, aj);

		if ((xp->a_flag & A4_ABS) == A4_ABS) {
			fprintf(mfp, "(ABS");
		} else {
			fprintf(mfp, "(REL");
		}
		if ((xp->a_flag & A4_OVR) == A4_OVR) {
			fprintf(mfp, ",OVR");
		} else {
			fprintf(mfp, ",CON");
		}
		if ((xp->a_flag & A4_PAG) == A4_PAG) {
			fprintf(mfp, ",PAG");
		}
		if ((xp->a_flag & A4_DSEG) == A4_DSEG) {
			fprintf(mfp, ",DSEG");
		} else {
			fprintf(mfp, ",CSEG");
		}
		fprintf(mfp, ")\n");

		if ((xp->a_flag & A4_PAG) == A4_PAG) {
			ai = (ai & 0xFF);
			aj = (aj > 256);
			if (ai || aj) { fprintf(mfp, "  "); lop += 1; }
			if (ai)       { fprintf(mfp, " Boundary"); }
			if (ai & aj)  { fprintf(mfp, " /"); }
			if (aj)       { fprintf(mfp, " Length"); }
			if (ai || aj) { fprintf(mfp, " Error\n"); }
		}

		if (wflag) {
			putc('\n', mfp);
			fprintf(mfp,
			"         Value  Global                          ");
			fprintf(mfp,
			"   Global Defined In Module\n");
			fprintf(mfp,
			"         -----  --------------------------------");
			fprintf(mfp,
			"   ------------------------\n");
		} else {
			switch(a_bytes) {
			default:
			case 2:	frmta = "   Value  Global   ";
				frmtb = "   -----  ------   ";
				n = 4; break;
			case 3:
			case 4:	frmta = "        Value  Global    ";
				frmtb = "        -----  ------    ";
				n = 3; break;
			}
			putc('\n', mfp);
			for(i=0;i<n;++i)
				fputs(frmta, mfp);
			putc('\n', mfp);
			for(i=0;i<n;++i)
				fputs(frmtb, mfp);
			putc('\n', mfp);
		}

		lop += 9;
	}
}

/*)Function	VOID	lstarea(xp, yp)
 *
 *		area *	xp		pointer to an area structure
 *		bank *	yp		pointer to a  bank structure
 *
 *	The function lstarea() creates the linker map output for
 *	the area specified by pointer xp.  The generated output
 *	area header includes the area name, starting address,
 *	size of area, number of words (in decimal), and the
 *	area attributes.  The symbols defined in this area are
 *	sorted by ascending address and output four per line
 *	in the selected radix (one per line in wide format).
 *
 *	local variables:
 *		areax *	oxp		pointer to an area extension structure
 *		int	i		loop counter
 *		int	j		bubble sort update status
 *		int	n		repeat counter
 *		char *	frmt		temporary format specifier
 *		char *	ptr		pointer to an id string
 *		int	nmsym		number of symbols in area
 *		a_uint	a0		temporary
 *		a_uint	ai		temporary
 *		a_uint	aj		temporary
 *		sym *	sp		pointer to a symbol structure
 *		sym **	p		pointer to an array of
 *					pointers to symbol structures
 *
 *	global variables:
 *		FILE	*mfp		Map output file handle
 *		sym *symhash[NHASH] 	array of pointers to NHASH
 *				      	linked symbol lists
 *		int	wflag		Wide format listing
 *		int	xflag		Map file radix type flag
 *
 *	functions called:
 *		int	fprintf()	c_library
 *		VOID	free()		c_library
 *		char *	malloc()	c_library
 *		char	putc()		c_library
 *		VOID	slew()		lklist.c
 *
 *	side effects:
 *		Map output generated.
 */

VOID
lstarea(xp, yp)
struct area *xp;
struct bank *yp;
{
	struct areax *oxp;
	int i, j, n;
	char *frmt, *ptr;
	int nmsym;
	a_uint a0, ai, aj;
	struct sym *sp;
	struct sym **p;

	/*
	 * Find number of symbols in area
	 */
	nmsym = 0;
	oxp = xp->a_axp;
	while (oxp) {
		for (i=0; i<NHASH; i++) {
			sp = symhash[i];
			while (sp != NULL) {
				if (oxp == sp->s_axp)
					++nmsym;
				sp = sp->s_sp;
			}
		}
		oxp = oxp->a_axp;
	}

	if ((nmsym == 0) && (xp->a_size == 0)) {
		return;
	}

	lop = NLPP;
	slew(xp, yp);

	if (nmsym == 0) {
		return;
	}

	/*
	 * Allocate space for an array of pointers to symbols
	 * and load array.
	 */
	if ( (p = (struct sym **) malloc (nmsym*sizeof(struct sym *))) == NULL) {
		fprintf(mfp, "Insufficient space to build Map Segment.\n");
		return;
	}
	nmsym = 0;
	oxp = xp->a_axp;
	while (oxp) {
		for (i=0; i<NHASH; i++) {
			sp = symhash[i];
			while (sp != NULL) {
				if (oxp == sp->s_axp) {
					p[nmsym++] = sp;
				}
				sp = sp->s_sp;
			}
		}
		oxp = oxp->a_axp;
	}

	/*
	 * Bubble Sort of Addresses in Symbol Table Array
	 */
	j = 1;
	while (j) {
		j = 0;
		sp = p[0];
		a0 = sp->s_addr + sp->s_axp->a_addr;
		for (i=1; i<nmsym; ++i) {
			sp = p[i];
			ai = sp->s_addr + sp->s_axp->a_addr;
			if (a0 > ai) {
				j = 1;
				p[i] = p[i-1];
				p[i-1] = sp;
			}
			a0 = ai;
		}
	}

	/*
	 * Repeat Counter
	 */
	switch(a_bytes) {
	default:
	case 2: n = 4; break;
	case 3:
	case 4: n = 3; break;
	}

	/*
	 * Symbol Table Output
	 */
	i = 0;
	while (i < nmsym) {
		if (wflag) {
			slew(xp, yp);
			switch(a_bytes) {
			default:
			case 2: frmt = "        "; break;
			case 3:
			case 4: frmt = "   "; break;
			}
			fputs(frmt, mfp);
		} else
		if ((i % n) == 0) {
			slew(xp, yp);
			switch(a_bytes) {
			default:
			case 2: frmt = "  "; break;
			case 3:
			case 4: frmt = "  "; break;
			}
			fputs(frmt, mfp);
		}

		sp = p[i];
		aj = (sp->s_addr + sp->s_axp->a_addr) & a_mask;
#ifdef	LONGINT
		switch(a_bytes) {
		default:
		case 2:
			switch(xflag) {
			default:
			case 0: frmt = "  %04lX  "; break;
			case 1: frmt = "%06lo  "; break;
			case 2: frmt = " %05lu  "; break;
			}
			break;
		case 3:
			switch(xflag) {
			default:
			case 0: frmt = "     %06lX  "; break;
			case 1: frmt = "   %08lo  "; break;
			case 2: frmt = "   %08lu  "; break;
			}
			break;
		case 4:
			switch(xflag) {
			default:
			case 0: frmt = "   %08lX  "; break;
			case 1: frmt = "%011lo  "; break;
			case 2: frmt = " %010lu  "; break;
			}
			break;
		}
#else
		switch(a_bytes) {
		default:
		case 2:
			switch(xflag) {
			default:
			case 0: frmt = "  %04X  "; break;
			case 1: frmt = "%06o  "; break;
			case 2: frmt = " %05u  "; break;
			}
			break;
		case 3:
			switch(xflag) {
			default:
			case 0: frmt = "     %06X  "; break;
			case 1: frmt = "   %08o  "; break;
			case 2: frmt = "   %08u  "; break;
			}
			break;
		case 4:
			switch(xflag) {
			default:
			case 0: frmt = "   %08X  "; break;
			case 1: frmt = "%011o  "; break;
			case 2: frmt = " %010u  "; break;
			}
			break;
		}
#endif
		fprintf(mfp, frmt, aj);

		ptr = &sp->s_id[0];

#if NOICE
		/*
		 * NoICE output of symbol
		 */
		if (jflag) DefineNoICE(ptr, aj, yp);
#endif

#if SDCDB
		/*
		 * SDCDB output of symbol
		 */
		if (yflag) DefineSDCDB(ptr, aj);
#endif

		if (wflag) {
			fprintf(mfp, "%-32.32s", ptr);
			i++;
			ptr = &sp->m_id[0];
			if(ptr) {
				fprintf(mfp, "   %-.28s", ptr);
			}
		} else {
			switch(a_bytes) {
			default:
			case 2: frmt = "%-8.8s"; break;
			case 3:
			case 4: frmt = "%-9.9s"; break;
			}
			fprintf(mfp, frmt, ptr);
			if (++i < nmsym)
				if (i % n != 0)
					fprintf(mfp, " | ");
		}
		if (wflag || (i % n == 0)) {
			putc('\n', mfp);
		}
	}
	if (i % n != 0) {
		putc('\n', mfp);
	}
	free(p);
}

/*)Function	VOID	lkulist(i)
 *
 *		int	i	i # 0	process LST to RST file
 *				i = 0	copy remainder of LST file
 *					to RST file and close files
 *
 *	The function lkulist() creates a relocated listing (.rst)
 *	output file from the ASxxxx assembler listing (.lst)
 *	files.  The .lst file's program address and code bytes
 *	are changed to reflect the changes made by ASlink as
 *	the .rel files are combined into a single relocated
 *	output file.
 *
 *	local variables:
 *		a_uint	cpc		current program counter address in PC increments
 *		int	cbytes		bytes so far in T line
 *
 *	global variables:
 *		int	a_bytes		T Line Address Bytes
 *		int	hilo		byte order
 *		int	gline		get a line from the LST file
 *					to translate for the RST file
 *		a_uint	pc		current program counter address in bytes
 *		char	rb[]		read listing file text line
 *		FILE	*rfp		The file handle to the current
 *					output RST file
 *		int	rtcnt		count of data words
 *		int	rtflg[]		output the data flag
 *		a_uint	rtval[]		relocated data
 *		FILE	*tfp		The file handle to the current
 *					LST file being scanned
 *
 *	functions called:
 *		a_uint	adb_xb()	lkrloc.c
 *		int	fclose()	c_library
 *		int	fgets()		c_library
 *		int	fprintf()	c_library
 *		VOID	lkalist()	lklist.c
 *		VOID	lkglist()	lklist.c
 *		VOID	hlralist()	lklist.c
 *		VOID	hlrglist()	lklist.c
 *
 *	side effects:
 *		A .rst file is created for each available .lst
 *		file associated with a .rel file.
 */

VOID
lkulist(i)
int i;
{
	a_uint cpc;
	int cbytes;

	/*
	 * Exit if listing file is not open
	 */
	if (tfp == NULL)
		return;

	/*
	 * Normal processing of LST to RST
	 */
	if (i) {
		/*
		 * Line with only address
		 */	
		if (rtcnt == a_bytes) {
			if (hfp == NULL) {
				lkalist(pc);
			} else {
				hlralist(pc);
			}
		/*
		 * Line with code bytes
		 */
		} else {
			cpc = pc;
			cbytes = 0;
			for (i=a_bytes; i < rtcnt; i++) {
				if (rtflg[i]) {
					if (hfp == NULL) {
						lkglist(cpc, (int) (rtval[i] & 0xFF), rterr[i]);
					} else {
						hlrglist(cpc, (int) (rtval[i] & 0xFF), rterr[i]);
					}
					cbytes += 1;
					cpc += (cbytes % pcb) ? 0 : 1;
				}
			}
		}
	/*
	 * Copy remainder of LST to RST
	 */
	} else {
		if (gline == 0)
			fprintf(rfp, "%s", rb);

		if (hfp) {
			for (gethlr(1); hfp; gethlr(1)) {
				if (listing & NLIST) {
					continue;
				}
				for (i=0; getlst(1); i=0) {
					if ((lmode == ELIST) && (listing & LIST_EQT)) {
						i = hlrelist();
					}
					fprintf(rfp, "%s", rb);
					if (i == 0) {
						break;
					}
				}
			}
		}
		while (fgets(rb, sizeof(rb)-2, tfp) != 0) {
			fprintf(rfp, "%s", rb);
		}
		fclose(tfp);
		tfp = NULL;
		fclose(rfp);
		rfp = NULL;
	}
}

/*)Function	VOID	lkalist(cpc)
 *
 *		int	cpc		current program counter value
 *
 *	The function lkalist() performs the following functions:
 *
 *	(1)	if the value of gline = 0 then the current listing
 *		file line is copied to the relocated listing file output.
 *
 *	(2)	the listing file is read line by line and copied to
 *		the relocated listing file until a valid source
 *		line number and a program counter value of the correct
 *		radix is found.  The new relocated pc value is substituted
 *		and the line is written to the RST file.
 *
 *	local variables:
 *		int	i		loop counter
 *		int	m		character count
 *		int	n		character index
 *		int	q		character index
 *		int	r		character radix
 *		char *	frmt		temporary format specifier
 *		char	str[]		temporary string
 *
 *	global variables:
 *		int	gline		get a line from the LST file
 *					to translate for the RST file
 *		char	rb[]		read listing file text line
 *		char	*rp		pointer to listing file text line
 *		FILE	*rfp		The file handle to the current
 *					output RST file
 *		FILE	*tfp		The file handle to the current
 *					LST file being scanned
 *
 *	functions called:
 *		int	dgt()		lklist.c
 *		int	fclose()	c_library
 *		int	fgets()		c_library
 *		int	fprintf()	c_library
 *		int	sprintf()	c_library
 *		char *	strncpy()	c_library
 *
 *	side effects:
 *		Lines of the LST file are copied to the RST file,
 *		the last line copied has the code address
 *		updated to reflect the program relocation.
 */

/* The Output Formats,  No Cycle Count
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

VOID
lkalist(cpc)
a_uint cpc;
{
	char str[16];
	char *frmt;
	int i, m, n, q, r;

	/*
	 * Exit if listing file is not open
	 */
	if (tfp == NULL)
		return;

	/*
	 * Truncate (int) to N-Bytes
	 */
	cpc &= a_mask;

	/*
	 * Cleanup
	 */
	if (gline == 0) {
		fprintf(rfp, "%s", rb);
	}

	/*
	 * Get next LST text line
	 */
loop:	getlst(1);

	/*
	 * Must have an address in the expected radix
	 */
#ifdef	LONGINT
	switch(radix) {
	default:
	case 16:
		r = RAD16;
		switch(a_bytes) {
		default:
		case 2: n = 3; m = 4; q = 26; frmt = "%04lX"; break;
		case 3: n = 6; m = 6; q = 34; frmt = "%06lX"; break;
		case 4: n = 4; m = 8; q = 34; frmt = "%08lX"; break;
		}
		break;
	case 10:
		r = RAD10;
		switch(a_bytes) {
		default:
		case 2: n = 4; m = 5; q = 26; frmt = "%05lu"; break;
		case 3: n = 5; m = 8; q = 34; frmt = "%08lu"; break;
		case 4: n = 3; m = 10; q = 34; frmt = "%010lu"; break;
		}
		break;
	case 8:
		r = RAD8;
		switch(a_bytes) {
		default:
		case 2: n = 3; m = 6; q = 26; frmt = "%06lo"; break;
		case 3: n = 5; m = 8; q = 34; frmt = "%08lo"; break;
		case 4: n = 2; m = 11; q = 34; frmt = "%011lo"; break;
		}
		break;
	}
#else
	switch(radix) {
	default:
	case 16:
		r = RAD16;
		switch(a_bytes) {
		default:
		case 2: n = 3; m = 4; q = 26; frmt = "%04X"; break;
		case 3: n = 6; m = 6; q = 34; frmt = "%06X"; break;
		case 4: n = 4; m = 8; q = 34; frmt = "%08X"; break;
		}
		break;
	case 10:
		r = RAD10;
		switch(a_bytes) {
		default:
		case 2: n = 4; m = 5; q = 26; frmt = "%05u"; break;
		case 3: n = 5; m = 8; q = 34; frmt = "%08u"; break;
		case 4: n = 3; m = 10; q = 34; frmt = "%010u"; break;
		}
		break;
	case 8:
		r = RAD8;
		switch(a_bytes) {
		default:
		case 2: n = 3; m = 6; q = 26; frmt = "%06o"; break;
		case 3: n = 5; m = 8; q = 34; frmt = "%08o"; break;
		case 4: n = 2; m = 11; q = 34; frmt = "%011o"; break;
		}
		break;
	}
#endif
	if (!dgt(r, &rb[n], m)) {
		fprintf(rfp, "%s", rb);
		goto loop;
	}
	if ((int) strlen(rb) > (n + m + 2)) {
		for (i=(n+m); i<q; i++) {
			if (rb[i] != ' ') {
				fprintf(rfp, "%s", rb);
				goto loop;
			}
		}
	}
	sprintf(str, frmt, cpc);
	strncpy(&rb[n], str, m);

	/*
	 * Copy updated LST text line to RST
	 */
	fprintf(rfp, "%s", rb);
}

/*)Function	VOID	lkglist(cpc,v,err)
 *
 *		int	cpc		current program counter value
 *		int 	v		value of byte at this address
 *		int	err		error flag for this value
 *
 *	The function lkglist() performs the following functions:
 *
 *	(1)	if the value of gline = 1 then the listing file
 *		is read line by line and copied to the
 *		relocated listing file until a valid source
 *		line number and a program counter value of the correct
 *		radix is found.
 *
 *	(2)	The new relocated values and code address are
 *		substituted and the line may be written to the RST file.
 *
 *	local variables:
 *		int	a		string index for first byte
 *		int	i		loop counter
 *		int	m		character count
 *		int	n		character index
 *		int	r		character radix
 *		int	s		spacing
 *		int	u		repeat counter
 *		char *	afrmt		temporary format specifier
 *		char *	frmt		temporary format specifier
 *		char	str[]		temporary string
 *
 *	global variables:
 *		int	a_bytes		T Line Address Bytes
 *		a_uint	a_mask		address masking parameter
 *		int	gcntr		data byte counter
 *		int	gline		get a line from the LST file
 *					to translate for the RST file
 *		char	rb[]		read listing file text line
 *		char	*rp		pointer to listing file text line
 *		FILE	*rfp		The file handle to the current
 *					output RST file
 *		FILE	*tfp		The file handle to the current
 *					LST file being scanned
 *
 *	functions called:
 *		int	dgt()		lklist.c
 *		int	fclose()	c_library
 *		int	fgets()		c_library
 *		int	fprintf()	c_library
 *		int	sprintf()	c_library
 *		char *	strncpy()	c_library
 *
 *	side effects:
 *		Lines of the LST file are copied to the RST file
 *		with updated data values and code addresses.
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

VOID
lkglist(cpc,v,err)
a_uint cpc;
int v;
int err;
{
	char str[16];
	char *afrmt, *frmt;
	int a, n, m, r, s, u;

 	/*
	 * Exit if listing file is not open
	 */
	if (tfp == NULL)
		return;

	/*
	 * Truncate (int) to N-Bytes
	 */
	 cpc &= a_mask;

	/*
	 * Get next LST text line
	 */
loop:	if (gline) {
		getlst(0);
	}

	/*
	 * Hex Listing
	 */
#ifdef	LONGINT
	 switch(radix) {
	 default:
	 case 16:
		r = RAD16;
		switch(a_bytes) {
		default:
		case 2:	a = 8; s = 3; n = 3; m = 4; u = 6; afrmt = "%04lX"; break;
		case 3: a = 13; s = 3; n = 6; m = 6; u = 7; afrmt = "%06lX"; break;
		case 4: a = 13; s = 3; n = 4; m = 8; u = 7; afrmt = "%08lX"; break;
		}
		frmt = " %02X"; break;
	case 10:
		r = RAD10;
		switch(a_bytes) {
		default:
		case 2:	a = 10; s = 4; n = 4; m = 5; u = 4; afrmt = "%05lu"; break;
		case 3: a = 14; s = 4; n = 5; m = 8; u = 5; afrmt = "%08lu"; break;
		case 4: a = 14; s = 4; n = 3; m = 10; u = 5; afrmt = "%010lu"; break;
		}
		frmt = " %03u"; break;
	case 8:
		r = RAD8;
		switch(a_bytes) {
		default:
		case 2:	a = 10; s = 4; n = 3; m = 6; u = 4; afrmt = "%06lo"; break;
		case 3: a = 14; s = 4; n = 5; m = 8; u = 5; afrmt = "%08lo"; break;
		case 4: a = 14; s = 4; n = 2; m = 11; u = 5; afrmt = "%011lo"; break;
		}
		frmt = " %03o"; break;
	}
#else
	 switch(radix) {
	 default:
	 case 16:
		r = RAD16;
		switch(a_bytes) {
		default:
		case 2:	a = 8; s = 3; n = 3; m = 4; u = 6; afrmt = "%04X"; break;
		case 3: a = 13; s = 3; n = 6; m = 6; u = 7; afrmt = "%06X"; break;
		case 4: a = 13; s = 3; n = 4; m = 8; u = 7; afrmt = "%08X"; break;
		}
		frmt = " %02X"; break;
	case 10:
		r = RAD10;
		switch(a_bytes) {
		default:
		case 2:	a = 10; s = 4; n = 4; m = 5; u = 4; afrmt = "%05u"; break;
		case 3: a = 14; s = 4; n = 5; m = 8; u = 5; afrmt = "%08u"; break;
		case 4: a = 14; s = 4; n = 3; m = 10; u = 5; afrmt = "%010u"; break;
		}
		frmt = " %03u"; break;
	case 8:
		r = RAD8;
		switch(a_bytes) {
		default:
		case 2:	a = 10; s = 4; n = 3; m = 6; u = 4; afrmt = "%06o"; break;
		case 3: a = 14; s = 4; n = 5; m = 8; u = 5; afrmt = "%08o"; break;
		case 4: a = 14; s = 4; n = 2; m = 11; u = 5; afrmt = "%011o"; break;
		}
		frmt = " %03o"; break;
	}
#endif
	/*
	 * Data Byte Pointer
	 */
	rp = &rb[a + (s * gcntr)];

	/*
	 * Number must be of proper radix
	 */
	if (!dgt(r, rp, s-1)) {
		fprintf(rfp, "%s", rb);
		gline = 1;
		goto loop;
	}

	/*
	 * Output new data value, overwrite relocation codes
	 */
	sprintf(str, frmt, v);
	strncpy(rp-1, str, s);

	/*
	 * Output relocated code address
	 */
	if (gcntr == 0) {
		if (dgt(r, &rb[n], m)) {
			sprintf(str, afrmt, cpc);
			strncpy(&rb[n], str, m);
		}
	}

	/*
	 * Fix 'u' if [nn], cycles, is specified
	 */
	if (rb[a + (s*u) - 1] == CYCNT_END) {
		u -= 1;
	}
	/*
	 * Output text line when updates finished
	 */
	if (++gcntr == u) {
		fprintf(rfp, "%s", rb);
		gline = 1;
		/*
		 * Output an error line if required
		 */
		if (err) {
			switch(ASxxxx_VERSION) {
			case 3:
				fprintf(rfp, "?ASlink-Warning-%s\n", errmsg3[err]);
				break;

			case 4:
				fprintf(rfp, "?ASlink-Warning-%s\n", errmsg4[err]);
				break;

			default:
				break;
			}
		}
	}
}

/*)Function	VOID	getlst(ngline)
 *
 *		int	ngline		set gline to this value
 *
 *	If a file having the same name as the list file but with the
 *	extension .hlr exists then the function gethlr() reads a line
 *	from the .hlr file.  Each line contains the line number of the
 *	assembled line, the listed parameters in the line, the assembler
 *	mode, and the number of bytes output from this assembled line.
 *	If the file does not exist then the previous .lst to .rst conversion
 *	routines are used.  These routines 'REQUIRE' that the assembler
 *	always outputs the address and all byte values in the .lst file.
 *	This is accomplished by enabling LOC, BIN, and MEB during assembly.
 *
 *	local variables:
 *		int	i		repeat counter
 *
 *	global variables:
 *		int	gcntr		byte counter
 *		int	gline		read a new line if != 0
 *		FILE *	rfp		.rst file handle
 *		char 	rb[]		character array for line input
 *		char *	rp		pointer to a character array
 *		FILE *	tfp		.lst file handle
 *
 *	functions called:
 *		int	fclose()	c_library
 *		int	fgets()		c_library
 *
 *	side effects:
 *		the next .lst file line is read into rb[],
 *		gline is set, and gcntr is cleared.
 */

int
getlst(ngline)
int ngline;
{
	int i;

	/*
	 * Clear text line buffer
	 */
	for (i=0,rp=rb; i<sizeof(rb); i++) {
		*rp++ = 0;
	}

	/*
	 * Get next LST text line
	 */
	if (fgets(rb, sizeof(rb)-2, tfp) == NULL) {
		fclose(tfp);
		tfp = NULL;
		fclose(rfp);
		rfp = NULL;
	}
	gline = ngline;
	gcntr = 0;
	return(tfp ? 1 : 0);
}

/*)Function	VOID	hlralist(cpc)
 *
 *		int	cpc		current program counter value
 *
 *	The function hlralist() performs the following function:
 *
 *	(1)	If the value of gline = 0 then the current listing
 *		file line is copied to the relocated listing file output.
 *
 *	(2)	The LRT hint and LST files are read until
 *		an ALIST or BLIST line is found.
 *
 *	(3)	If the ALIST or BLIST line is NOT listed the function
 *		returns else the LST line will be updated with the
 *		the new relocated pc value if the location was output
 *		to the LST file.
 *
 *	(4)	The updated line is written to the RST file.
 *
 *	local variables:
 *		int	i		loop counter
 *		int	m		character count
 *		int	n		character index
 *		char *	afrmt		address format specifier
 *		char	str[]		temporary string
 *
 *	global variables:
 *		int	bytcnt		number of bytes output on this line
 *		int	gline		get a line from the LST file
 *					to translate for the RST file
 *		int	hline		get a line from the LRT file
 *					to get hints for the translation
 *		int	listing		encoded bits for an assembled line
 *		int	lmode		the assembler line mode
 *		char	rb[]		read listing file text line
 *		char	*rp		pointer to listing file text line
 *		FILE	*rfp		The file handle to the current
 *					output RST file
 *		FILE	*tfp		The file handle to the current
 *					LST file being scanned
 *		FILE	*hfp		The file handle to the current
 *					LRT file being scanned
 *
 *	functions called:
 *		int	dgt()		lklist.c
 *		int	fclose()	c_library
 *		int	fgets()		c_library
 *		int	fprintf()	c_library
 *		VOID	gethlr()	lklist.c
 *		int	sprintf()	c_library
 *		char *	strncpy()	c_library
 *
 *	side effects:
 *		Lines of the LST file are copied to the RST file,
 *		the last line copied has the code address
 *		updated to reflect the program relocation.
 */

/* The Output Formats,  No Cycle Count
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

VOID
hlralist(cpc)
a_uint cpc;
{
	char str[16];
	char *afrmt;
	int m, n;

	/*
	 * Exit if listing file is not open
	 */
	if (tfp == NULL)
		return;

	/*
	 * Truncate (int) to N-Bytes
	 */
	cpc &= a_mask;

	/*
	 * Cleanup
	 */
	if (gline == 0) {
		fprintf(rfp, "%s", rb);
	}
	gline = 1;
	hline = 1;

	/*
	 * Get Listing Hints
	 */
loop:	gethlr(1);

	if (listing & LIST_NLST) {
		if ((lmode == ALIST) || (lmode == BLIST)) {
			return;
		} else {
			goto loop;
		}
	}

	/*
	 * Get next LST text line
	 */
	getlst(1);

	if (lmode == ELIST) {
		if (listing & LIST_EQT) {
			hlrelist();
		}
	}

	if ((lmode != ALIST) && (lmode != BLIST)) {
		fprintf(rfp, "%s", rb);
		goto loop;
	}

	if (listing & LIST_LOC) {
		/*
		 * Character positions and address format.
		 */
#ifdef	LONGINT
		switch(radix) {
		default:
		case 16:
			switch(a_bytes) {
			default:
			case 2: n = 3; m = 4; afrmt = "%04lX"; break;
			case 3: n = 6; m = 6; afrmt = "%06lX"; break;
			case 4: n = 4; m = 8; afrmt = "%08lX"; break;
			}
			break;
		case 10:
			switch(a_bytes) {
			default:
			case 2: n = 4; m = 5; afrmt = "%05lu"; break;
			case 3: n = 5; m = 8; afrmt = "%08lu"; break;
			case 4: n = 3; m = 10; afrmt = "%010lu"; break;
			}
			break;
		case 8:
			switch(a_bytes) {
			default:
			case 2: n = 3; m = 6; afrmt = "%06lo"; break;
			case 3: n = 5; m = 8; afrmt = "%08lo"; break;
			case 4: n = 2; m = 11; afrmt = "%011lo"; break;
			}
			break;
		}
#else
		switch(radix) {
		default:
		case 16:
			switch(a_bytes) {
			default:
			case 2: n = 3; m = 4; afrmt = "%04X"; break;
			case 3: n = 6; m = 6; afrmt = "%06X"; break;
			case 4: n = 4; m = 8; afrmt = "%08X"; break;
			}
			break;
		case 10:
			switch(a_bytes) {
			default:
			case 2: n = 4; m = 5; afrmt = "%05u"; break;
			case 3: n = 5; m = 8; afrmt = "%08u"; break;
			case 4: n = 3; m = 10; afrmt = "%010u"; break;
			}
			break;
		case 8:
			switch(a_bytes) {
			default:
			case 2: n = 3; m = 6; afrmt = "%06o"; break;
			case 3: n = 5; m = 8; afrmt = "%08o"; break;
			case 4: n = 2; m = 11; afrmt = "%011o"; break;
			}
			break;
		}
#endif

		/*
		 * Copy updated LST text line to RST
		 */
		sprintf(str, afrmt, cpc);
		strncpy(&rb[n], str, m);
	}
	fprintf(rfp, "%s", rb);
}

/*)Function	VOID	hlrglist(cpc,v,err)
 *
 *		int	cpc		current program counter value
 *		int 	v		value of byte at this address
 *		int	err		error flag for this value
 *
 *	The function hlrglist() performs the following function:
 *
 *	(1)	The LRT hint file is read.
 *		(A)	NON listed lines are skipped with
 *			output bytes discarded.
 *			Repeat (1) until:
 *		(B)	A listed line without output bytes
 *			is copied directly from the LST file
 *			to the RST file.
 *			Repeat (1) until:
 *		(C)	A listed line created output bytes.
 *
 *	(2)	The LST line is updated with the relocated address
 *		and byte data if these parameters were not inhibited
 *		by a .list or .nlist directive in the assember.
 *
 *	(3)	After all bytes have been updated the line
 *		is written to the RST file.
 *
 *	local variables:
 *		int	a		string index for first byte
 *		int	i		loop counter
 *		int	m		character count
 *		int	n		character index
 *		int	r		character radix
 *		int	s		spacing
 *		int	u		repeat counter
 *		char *	afrmt		address format specifier
 *		char *	dfrmt		data format specifier
 *		char	str[]		temporary string
 *
 *	global variables:
 *		int	a_bytes		T Line Address Bytes
 *		a_uint	a_mask		address masking parameter
 *		int	gcntr		data byte counter
 *					set to -1 for a continuation line
 *		int	bytcnt		number of bytes output on this line
 *		int	gline		get a line from the LST file
 *					to translate for the RST file
 *		int	hline		get a line from the HLR file
 *					to get hints for the translation
 *		int	listing		encoded bits for an assembled line
 *		int	lmode		the assembler line mode
 *		char	rb[]		read listing file text line
 *		char	*rp		pointer to listing file text line
 *		FILE	*rfp		The file handle to the current
 *					output RST file
 *		FILE	*tfp		The file handle to the current
 *					LST file being scanned
 *
 *	functions called:
 *		int	dgt()		lklist.c
 *		int	fclose()	c_library
 *		int	fgets()		c_library
 *		VOID	gethlr()	lklist.c
 *		int	fprintf()	c_library
 *		int	sprintf()	c_library
 *		char *	strncpy()	c_library
 *
 *	side effects:
 *		Lines of the LST file are copied to the RST file
 *		with updated data values and code addresses.
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

VOID
hlrglist(cpc,v,err)
a_uint cpc;
int v;
int err;
{
	char str[16];
	char *afrmt, *dfrmt;
	int a, n, m, r, s, u;
	int i, j;

	/*
	 * Exit if listing file is not open
	 */
	if (tfp == NULL)
		return;

	/*
	 * Truncate (int) to N-Bytes
	 */
	 cpc &= a_mask;

	/*
	 * Get Listing Hints
	 */
loop:	if (hline) {
		gethlr(0);
	}
	/*
	 * If line was not listed
	 * then discard the bytcnt bytes
	 */
	if (listing & LIST_NLST) {
		if (bytcnt == 0) {
			hline = 1;
			goto loop;
		} else {
			bytcnt -= bytcnt ? 1 : 0;
			if (bytcnt == 0) {
				hline = 1;
			}
			return;
		}
	}

	/*
	 * Get next LST text line
	 */
	if (gline) {
		getlst(0);
	}

	/*
	 * Equate Processing
	 */
	if (listing & LIST_EQT) {
		if (hlrelist()) {
			gline = 1;
			goto loop;
		}
	}

	if (bytcnt == 0) {
		fprintf(rfp, "%s", rb);
		hline = 1;
		gline = 1;
		goto loop;
	}

	/*
	 *Listing Format
	 */
#ifdef	LONGINT
	 switch(radix) {
	 default:
	 case 16:
		r = RAD16;
		switch(a_bytes) {
		default:
		case 2:	a = 8; s = 3; n = 3; m = 4; u = 6; afrmt = "%04lX"; break;
		case 3: a = 13; s = 3; n = 6; m = 6; u = 7; afrmt = "%06lX"; break;
		case 4: a = 13; s = 3; n = 4; m = 8; u = 7; afrmt = "%08lX"; break;
		}
		dfrmt = " %02X"; break;
	case 10:
		r = RAD10;
		switch(a_bytes) {
		default:
		case 2:	a = 10; s = 4; n = 4; m = 5; u = 4; afrmt = "%05lu"; break;
		case 3: a = 14; s = 4; n = 5; m = 8; u = 5; afrmt = "%08lu"; break;
		case 4: a = 14; s = 4; n = 3; m = 10; u = 5; afrmt = "%010lu"; break;
		}
		dfrmt = " %03u"; break;
	case 8:
		r = RAD8;
		switch(a_bytes) {
		default:
		case 2:	a = 10; s = 4; n = 3; m = 6; u = 4; afrmt = "%06lo"; break;
		case 3: a = 14; s = 4; n = 5; m = 8; u = 5; afrmt = "%08lo"; break;
		case 4: a = 14; s = 4; n = 2; m = 11; u = 5; afrmt = "%011lo"; break;
		}
		dfrmt = " %03o"; break;
	}
#else
	 switch(radix) {
	 default:
	 case 16:
		r = RAD16;
		switch(a_bytes) {
		default:
		case 2:	a = 8; s = 3; n = 3; m = 4; u = 6; afrmt = "%04X"; break;
		case 3: a = 13; s = 3; n = 6; m = 6; u = 7; afrmt = "%06X"; break;
		case 4: a = 13; s = 3; n = 4; m = 8; u = 7; afrmt = "%08X"; break;
		}
		dfrmt = " %02X"; break;
	case 10:
		r = RAD10;
		switch(a_bytes) {
		default:
		case 2:	a = 10; s = 4; n = 4; m = 5; u = 4; afrmt = "%05u"; break;
		case 3: a = 14; s = 4; n = 5; m = 8; u = 5; afrmt = "%08u"; break;
		case 4: a = 14; s = 4; n = 3; m = 10; u = 5; afrmt = "%010u"; break;
		}
		dfrmt = " %03u"; break;
	case 8:
		r = RAD8;
		switch(a_bytes) {
		default:
		case 2:	a = 10; s = 4; n = 3; m = 6; u = 4; afrmt = "%06o"; break;
		case 3: a = 14; s = 4; n = 5; m = 8; u = 5; afrmt = "%08o"; break;
		case 4: a = 14; s = 4; n = 2; m = 11; u = 5; afrmt = "%011o"; break;
		}
		dfrmt = " %03o"; break;
	}
#endif
	/*
	 * Fix 'u' if [nn], cycles, is specified
	 */
	if (rb[a + (s*u) - 1] == CYCNT_END) {
		u -= 1;
	}
	/*
	 * Must have an address
	 * in the expected radix.
	 */
	if (listing & LIST_LOC) {
		if (!dgt(r, &rb[n], m)) {
			fprintf(rfp, "%s", rb);
			gline = 1;
			goto loop;
		}
	}

	/*
	 * Data Byte Pointer
	 */
	u = (u > bytcnt) ? bytcnt : u;

	/*
	 * Must have data bytes
	 * in the expected radix.
	 */
	if (listing & LIST_BIN) {
		for (i=0,j=u; i<j; i++) {
			if (!dgt(r, &rb[a + (s * i)], s-1)) {
				fprintf(rfp, "%s", rb);
				gline = 1;
				goto loop;
			}
		}
	}

	/*
	 * Output relocated code address
	 */
	if (listing & LIST_LOC) {
		if (gcntr == 0) {
			sprintf(str, afrmt, cpc);
			strncpy(&rb[n], str, m);
		}
	}

	/*
	 * Output new data value, overwrite relocation codes
	 */
	if (listing & LIST_BIN) {
		sprintf(str, dfrmt, v);
		strncpy(&rb[a + (s * gcntr) - 1], str, s);
	}

	/*
	 * Output text line when updates finished
	 */
	if ((u == 0) || (++gcntr == u)) {
		fprintf(rfp, "%s", rb);
		hline = 1;
		gline = 1;
		/*
		 * Output an error line if required
		 */
		if (err) {
			switch(ASxxxx_VERSION) {
			case 3:
				fprintf(rfp, "?ASlink-Warning-%s\n", errmsg3[err]);
				break;

			case 4:
				fprintf(rfp, "?ASlink-Warning-%s\n", errmsg4[err]);
				break;

			default:
				break;
			}
		}
	}
}

/*)Function	int	hlrelist()
 *
 *	The function hlrelist() verifies that a relocation is required
 *	by checking the associated eqt_id for an area name.  If the
 *	name is blank then no relocation is required and a value of 0
 *	is returned.  The next step is to scan the .lst line to verify
 *	it is in a valid ELIST formatted line.  If the line is not in
 *	the ELIST format a value of 1 is returned.  When a valid line
 *	is found the equate value from the list line is updated to
 *	reflect the relocation an a value of 0 is returned.
 *
 *	local variables:
 *		int	a		position in list line
 *		char *	afrmt		pointer to an address format
 *		a_uint	eqtv		equate value from list line
 *		int	i		repeat counter
 *		int	m		number of characters in format
 *		int	r		radix code
 *		char	str[]		temporary character string buffer
 *
 *	global variables:
 *		a_uint	a_mask		address mask
 *		char *	eqt_id		name of area equate is in
 *		struct head *hp		pointer to the current head structure
 *		int	radix		radix value
 *		char	rb[]		.lst line to scan
 *		FILE *	rfp		.rel file handle
 *
 *	functions called:
 *		int	digit()		lkeval.c
 *		int	dgt()		lklist.c
 *		int	fprintf()	c_library
 *		int	strncpy()	c_library
 *		int	sprintf()	c_library
 *		int	symeq()		lksym.c
 *
 *	side effects:
 *		the equate value may be
 *		updated in the .lst line.
 */

int
hlrelist()
{
	char str[16];
	char *afrmt;
	int a, m, r;
	int i;
	a_uint eqtv;

	if (eqt_id[0] != 0) {
		/*
		 *Listing Format
		 */
#ifdef	LONGINT
		switch(radix) {
		default:
		case 16:
			r = RAD16;
			switch(a_bytes) {
			default:
			case 2:	a = 21; m = 4; afrmt = "%04lX"; break;
			case 3: a = 27; m = 6; afrmt = "%06lX"; break;
			case 4: a = 25; m = 8; afrmt = "%08lX"; break;
			}
			break;
		case 10:
			r = RAD10;
			switch(a_bytes) {
			default:
			case 2: a = 20; m = 5; afrmt = "%05lu"; break;
			case 3: a = 25; m = 8; afrmt = "%08lu"; break;
			case 4: a = 23; m = 10; afrmt = "%010lu"; break;
			}
			break;
		case 8:
			r = RAD8;
			switch(a_bytes) {
			default:
			case 2: a = 19; m = 6; afrmt = "%06lo"; break;
			case 3: a = 25; m = 8; afrmt = "%08lo"; break;
			case 4: a = 22; m = 11; afrmt = "%011lo"; break;
			}
			break;
		}
#else
		switch(radix) {
		default:
		case 16:
			r = RAD16;
			switch(a_bytes) {
			default:
			case 2:	a = 21; m = 4; afrmt = "%04X"; break;
			case 3: a = 27; m = 6; afrmt = "%06X"; break;
			case 4: a = 25; m = 8; afrmt = "%08X"; break;
			}
			break;
		case 10:
			r = RAD10;
			switch(a_bytes) {
			default:
			case 2: a = 20; m = 5; afrmt = "%05u"; break;
			case 3: a = 25; m = 8; afrmt = "%08u"; break;
			case 4: a = 23; m = 10; afrmt = "%010u"; break;
			}
			break;
		case 8:
			r = RAD8;
			switch(a_bytes) {
			default:
			case 2: a = 19; m = 6; afrmt = "%06o"; break;
			case 3: a = 25; m = 8; afrmt = "%08o"; break;
			case 4: a = 22; m = 11; afrmt = "%011o"; break;
			}
			break;
		}
#endif
		/*
		 * Require a blank line between any
		 * error codes and the equate value.
		 */
		for (i=2; i<a; i++) {
			if (rb[i] != ' ') {
				fprintf(rfp, "%s", rb);
				return(1);
			}
		}
		/*
		 * Require equate in correct radix.
		 */
		if (!dgt(r, &rb[a], m)) {
			fprintf(rfp, "%s", rb);
			return(1);
		}
		/*
		 * Evaluate the equate value.
		 */
		for (i=0,eqtv=0; i<m; i++) {
			eqtv = eqtv*radix + digit(rb[a+i], radix);
		}

		/*
		 * Search current Header structure for
		 * the correct area and relocation value.
		 */
		for (i=0; i<hp->h_narea; i++) {
			if (symeq(eqt_id, hp->a_list[i]->a_bap->a_id, 1)) {
				eqtv += hp->a_list[i]->a_addr;
				sprintf(str, afrmt, eqtv & a_mask);
				strncpy(&rb[a], str, m);
				break;
			}
		}
	}
	return(0);
}

/*)Function	VOID	gethlr()
 *
 *	If a file having the same name as the list file but with the
 *	extension .hlr exists then the function gethlr() reads a line
 *	from the .hlr file.  Each line contains the line number of the
 *	assembled line, the listed parameters in the line, the assembler
 *	mode, and the number of bytes output from this assembled line.
 *	If the file does not exist then the previous .lst to .rst conversion
 *	routines are used.  These routines 'REQUIRE' that the assembler
 *	always outputs the address and all byte values in the .lst file.
 *	This is accomplished by enabling LOC, BIN, and MEB during assembly.
 *
 *	local variables:
 *		int	a		index into .hlr text line
 *		int	b		a index update value
 *		char *	frmt		file reading format
 *		char	hlr[]		line input string buffer
 *		int	line		current line number
 *
 *	global variables:
 *		FILE *	hfp		.hlr file handle
 *		int	bytcnt		bytes output for this line
 *		char *	eqt_id		name of area equate is in
 *		int	hline		get a line from the HLR file
 *					to get hints for the translation
 *		int	listing		listed parameter bits
 *		int	lmode		assembler listing mode
 *
 *	functions called:
 *		int	fclose()	c_library
 *		int	fgets()		c_library
 *
 *	side effects:
 *		parameters are read from the .hlr file
 *		and placed into the global parameters
 *		bytcnt, listing, lmode, and eqt_id.
 */

int
gethlr(nhline)
int nhline;
{
	char hlr[128];
	char *frmt;
	int line;
	int a, b;

	listing = 0;
	lmode = 0;
	bytcnt = 0;
	if (hfp != NULL) {
		if (fgets(hlr, sizeof(hlr), hfp) == NULL) {
			fclose(hfp);
			hfp = NULL;
		} else {
			a = 0;
			eqt_id[0] = 0;
			if (hlr[1] == ' ') {
				sscanf(hlr, "  %5u", &line);
				a = 7;
			}
			switch(radix) {
			default:
			case 16:	frmt = " %02X %02X %02X";	b = 9;	break;
			case 10:	frmt = " %03d %03d %03d";	b = 12;	break;
			case 8:		frmt = " %03o %03o %03o";	b = 12;	break;
			}
			sscanf(&hlr[a], frmt, &listing, &lmode, &bytcnt);
			a += b;
			if (hlr[a] == ' ') {
				sscanf(&hlr[a], " %s", eqt_id);
			}
		}
	}
	hline = nhline;
	return(hfp ? 1 : 0);
}


