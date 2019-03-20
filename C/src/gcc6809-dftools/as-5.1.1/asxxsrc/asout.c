/* asout.c */

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

#include "asxxxx.h"


/*)Module	asout.c
 *
 *	The module asout.c contains all the functions used to
 *	generate the .REL assembler output file.
 *
 *
 * 	The  assemblers' output object file is an ascii file containing
 *	the information needed by the linker  to  bind  multiple  object
 *	modules into a complete loadable memory image.  
 *
 *	The object module contains the following designators:  
 *
 *		[XDQ][HL][234]
 *			X	 Hexadecimal radix
 *			D	 Decimal radix
 *			Q	 Octal radix
 *	
 *			H	 Most significant byte first
 *			L	 Least significant byte first
 *	
 *			2	 16-Bit Relocatable Addresses/Data
 *			3	 24-Bit Relocatable Addresses/Data
 *			4	 32-Bit Relocatable Addresses/Data
 *
 *		H	Header 
 *		M	Module
 *		G	Merge Mode
 *		B	Bank
 *		A	Area
 *		S	Symbol
 *		T	Object code
 *		R	Relocation information
 *		P	Paging information
 *
 *
 *	(1)	Radix Line
 *
 * 	The  first  line  of  an object module contains the [XDQ][HL][234]
 *	format specifier (i.e.  XH2 indicates  a  hexadecimal  file  with
 *	most significant byte first and 16-bit addresses) for the
 *	following designators.  
 *
 *
 *	(2)	Header Line
 *
 *		H aa areas gg global symbols 
 *
 * 	The  header  line  specifies  the number of areas(aa) and the
 *	number of global symbols(gg) defined or referenced in  this  ob-
 *	ject module segment.  
 *
 *
 *	(3)	Module Line 
 *
 *		M name 
 *
 * 	The  module  line  specifies  the module name from which this
 *	header segment was assembled.  The module line will  not  appear
 *	if the .module directive was not used in the source program.  
 *
 *
 *	(4)	Merge Mode Line
 *
 *		G nn ii 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
 *
 *	The mode structure contains the specification (or partial
 *	specification) of one of the assemblers' merge modes.
 *	Sixteen bits may be specified on a single line.
 *	Each assembler must specify at least one merge mode.
 *	The merging specification allows arbitrarily defined active
 *	bits and bit positions.  The 32 element arrays are indexed
 *	from 0 to 31.  Index 0 corresponds to bit 0, ..., and
 *	31 corresponds to bit 31 of a normal integer value.
 *
 *	1.  nn is merge mode number
 *
 *	2.  ii is the beginning bit position of the following data
 *
 *	3.  00 ... merge mode bit elements
 *
 *		The value of the element specifies if the normal integer bit
 *		is active (bit <7> is set, 0x80) and what destination bit
 *		(bits <4:0>, 0 - 31) should be loaded with this normal
 *		integer bit.
 *
 *
 *	(5)	Bank Line
 *
 *		B string base nn size nn flags nn fsfx string
 *
 *	The B line defines a bank name as 'string'.  A bank is
 *	a structure containing a collection of areas.
 *	The bank is treated as a unique linking
 *	structure seperate from other banks.  Each bank
 *	can have a unique base address (starting address).  The
 *	size specification may be used to signal the overflow of
 *	the banks' allocated space.  The Linker combines all areas
 *	included within a bank as seperate from other areas.  The
 *	code from a bank may be output to a unique file by
 *	specifying the File Suffix parameter (fsfx).  This allows
 *	the seperation of multiple data and code segments into
 *	isolated output files.
 *	
 *	
 *	(6)	Symbol Line 
 *
 *		S string Defnnnn 
 *
 *			or 
 *
 *		S string Refnnnn 
 *
 * 	The  symbol line defines (Def) or references (Ref) the symbol
 *	'string' with the value nnnn.  The defined value is relative  to
 *	the  current area base address.  References to constants and ex-
 *	ternal global symbols will always appear before the  first  area
 *	definition.  References to external symbols will have a value of
 *	zero.  
 *
 *
 *	(7)	Area Line 
 *
 *		A label size ss flags ff 
 *
 * 	The  area  line  defines the area label, the size (ss) of the
 *	area in PC increments, and the area flags (ff).  The area flags
 *	specify the area properties:
 *
 *		Basic PC Increment Size in Bytes	<1:0>
 *		OVR/CON		(0x0404/0x0400 i.e.  bit position 2) 
 *		ABS/REL		(0x0808/0x0800 i.e.  bit position 3) 
 *		PAG/NOPAG	(0x1010/0x1000 i.e.  bit position 4) 
 *		DSEG/CSEG	(0x4040/0x4000 i.e.  bit position 6)
 *		BANKED/NOBANK	(0x8080/0x8000 i.e   bit position 7)
 *
 *
 *	(8)	T Line 
 *
 *		T xx xx nn nn nn nn nn ...  
 *
 * 	The  T  line contains the assembled code output by the assem-
 *	bler with xx xx being the offset address from the  current  area
 *	base address and nn being the assembled instructions and data in
 *	byte format.  (xx xx and nn nn can be 2, 3, or 4 bytes as
 *	specified by the .REL file header.) 
 *
 *
 *	(9)	R Line 
 *
 *		R 0 0 nn nn n1 n2 xx xx ...  
 *
 * 	The R line provides the relocation information to the linker.
 *	The nn nn value is the current area index, i.e.  which area  the
 *	current  values  were  assembled.  Relocation information is en-
 *	coded in groups of 4 bytes:  
 *
 *	1.  n1 is the relocation mode and object format 
 *	 	1.  bits <1:0> specify the number of bytes to output) 
 *	 	2.  bit 2 signed(0x00)/unsigned(0x04) byte data 
 *		3.  bit 3 normal(0x00)/MSB(0x08) of value (2nd byte)
 *	 	4.  bit 4 normal(0x00)/page '0'(0x10) reference 
 *	 	5.  bit 5 normal(0x00)/page 'nnn'(0x20) reference
 *			PAGX mode if both bits are set
 *	 	6.  bit 6 normal(0x00)/PC relative(0x40) relocation 
 *	 	7.  bit 7 relocatable area(0x00)/symbol(0x80) 
 *
 *	2.  n2 is a byte index and merge mode index
 *		1.  bits <3:0> are a byte index into the corresponding
 *			(i.e.  preceeding) T line data (i.e.  a pointer to
 *			the data to be updated  by  the  relocation).
 *		2.  bits <7:4> are an index into a selected merge mode.
 *			Currently mode 0 simply specifies to use standard
 *			byte addressing modes and merging is ignored.
 *
 *	3.  xx xx  is the area/symbol index for the area/symbol be-
 *	 	ing referenced.  the corresponding area/symbol is found
 *		in the header area/symbol lists.  
 *
 *
 *	The groups of 4 bytes are repeated for each item requiring relo-
 *	cation in the preceeding T line.  
 *
 *
 *	(10)	P Line 
 *
 *		P 0 0 nn nn n1 n2 xx xx 
 *
 * 	The  P  line provides the paging information to the linker as
 *	specified by a .setdp directive.  The format of  the  relocation
 *	information is identical to that of the R line.  The correspond-
 *	ing T line has the following information:  
 *		T xx xx aa aa bb bb 
 *
 * 	Where  aa aa is the area reference number which specifies the
 *	selected page area and bb bb is the base address  of  the  page.
 *	bb bb will require relocation processing if the 'n1 n2 xx xx' is
 *	specified in the P line.  The linker will verify that  the  base
 *	address is on a 256 byte boundary and that the page length of an
 *	area defined with the PAG type is not larger than 256 bytes.  
 *
 * 	The  linker  defaults any direct page references to the first
 *	area defined in the input REL file.  All ASxxxx assemblers  will
 *	specify the _CODE area first, making this the default page area. 
 *
 *
 *	asout.c contains the following functions:
 *		int	lobyte();
 *		int	hibyte();
 *		int	thrdbyte();
 *		int	frthbyte();
 *		VOID	out();
 *		VOID	outall();
 *		VOID	outarea();
 *		VOID	outbank();
 *		VOID	outbuf();
 *		VOID	outchk();
 *		VOID	outdp();
 *		VOID	outdot();
 *		VOID	outgsd();
 *		VOID	outmerge();
 *		VOID	outmode();
 *		VOID	outsym();
 *		VOID	outab();
 *		VOID	outaw();
 *		VOID	outa3b();
 *		VOID	outa4b();
 *		VOID	outaxb();
 *		VOID	outatxb();
 *		VOID	outrb();
 *		VOID	outrw();
 *		VOID	outr3b();
 *		VOID	outr4b();
 *		VOID	outrxb();
 *		VOID	outrbm();
 *		VOID	outrwm();
 *		VOID	outr3bm();
 *		VOID	outr4bm();
 *		VOID	outrxbm();
 *		VOID	out_lb();
 *		VOID	out_lw();
 *		VOID	out_l3b();
 *		VOID	out_l4b();
 *		VOID	out_lxb();
 *		VOID	out_rw();
 *		VOID	out_txb();
 */

/*)Function	VOID	outab(v)
 *)Function	VOID	outaw(v)
 *)Function	VOID	outa3b(v)
 *)Function	VOID	outa4b(v)
 *
 *		a_uint	v		assembler data
 *
 *	Dispatch to output routine of 1 to 4 absolute bytes.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		VOID	outatxb()	asout.c
 *
 *	side effects:
 *		Absolute data is processed.
 */

VOID
outab(v)
a_uint v;
{
	outaxb(1, v);
}

VOID
outaw(v)
a_uint v;
{
	outaxb(2, v);
}

VOID
outa3b(v)
a_uint v;
{
	outaxb(3, v);
}

VOID
outa4b(v)
a_uint v;
{
	outaxb(4, v);
}

/*)Function	VOID	outaxb(i, v)
 *
 *		int	i		output byte count
 *		int	v		assembler data
 *
 *	The function outaxb() processes 1 to 4 bytes of
 *	assembled data in absolute format.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		sym	dot		defined as sym[0]
 *		int	oflag		-o, generate relocatable output flag
 *		int	pass		assembler pass number
 *
 *	functions called:
 *		VOID	outatxb()	asout.c
 *		VOID	outchk()	asout.c
 *		VOID	out_lxb()	asout.c
 *
 *	side effects:
 *		The current assembly address is incremented by i.
 */

VOID
outaxb(i, v)
int i;
a_uint v;
{
	int p_bytes;

	if (pass == 2) {
		out_lxb(i, v, 0);
		if (oflag) {
			outchk(i, 0);
			outatxb(i, v);
		}
	}
	/*
	 * Update the Program Counter
	 * based upon the area type.
	 */
	p_bytes = 1 + ((dot.s_area->a_flag) & A_BYTES);
	dot.s_addr += (i/p_bytes) + (i % p_bytes ? 1 : 0);
	/*
	 * Area has code
	 */
	dot.s_area->a_flag |= A_OUT;
}

/*)Function	VOID	outatxb(i, v)
 *
 *		int	i		number of bytes to process
 *		int	v		assembler data
 *
 *	The function outatxb() outputs i bytes
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		int	hilo		byte order
 *		char	*txtp		T line output pointer
 *
 *	functions called:
 *		int	lobyte()	asout.c
 *		int	hibyte()	asout.c
 *		int	thrdbyte()	asout.c
 *		int	frthbyte()	asout.c
 *
 *	side effects:
 *		i bytes are placed into the T Line Buffer.
 */

VOID
outatxb(i, v)
int i;
a_uint v;
{
	if ((int) hilo) {
		if (i >= 4) *txtp++ = frthbyte(v);
		if (i >= 3) *txtp++ = thrdbyte(v);
		if (i >= 2) *txtp++ = hibyte(v);
		if (i >= 1) *txtp++ = lobyte(v);
	} else {
		if (i >= 1) *txtp++ = lobyte(v);
		if (i >= 2) *txtp++ = hibyte(v);
		if (i >= 3) *txtp++ = thrdbyte(v);
		if (i >= 4) *txtp++ = frthbyte(v);
	}
}

/*)Function	VOID	outrb(esp, r)
 *)Function	VOID	outrw(esp, r)
 *)Function	VOID	outr3b(esp, r)
 *)Function	VOID	outr4b(esp, r)
 *
 *		expr *	esp		pointer to expr structure
 *		int	r		relocation mode
 *
 *	Dispatch functions for processing relocatable data.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		none
 *		
 *	functions called:
 *		int	outrxb()	asout.c
 *
 *	side effects:
 *	        relocatable data processed
 */

VOID
outrb(esp, r)
struct expr *esp;
int r;
{
	outrxb(1, esp, r);
}

VOID
outrw(esp, r)
struct expr *esp;
int r;
{
	outrxb(2, esp, r);
}

VOID
outr3b(esp, r)
struct expr *esp;
int r;
{
	outrxb(3, esp, r);
}

VOID
outr4b(esp, r)
struct expr *esp;
int r;
{
	outrxb(4, esp, r);
}

/*)Function	VOID	outrxb(i, esp, r)
 *
 *		int	i		output byte count
 *		expr *	esp		pointer to expr structure
 *		int	r		relocation mode
 *
 *	The function outrxb() processes 1 to 4 bytes of generated code
 *	in either absolute or relocatable format dependent upon
 *	the data contained in the expr structure esp.  If the
 *	.REL output is enabled then the appropriate information
 *	is loaded into the txt and rel buffers.
 *
 *	local variables:
 *		int	m		signed value mask
 *		int	n		unsigned value mask
 *					symbol/area reference number
 *
 *	global variables:
 *		int	a_bytes		T Line byte count
 *		sym	dot		defined as sym[0]
 *		int	oflag		-o, generate relocatable output flag
 *		int	pass		assembler pass number
 *		char	rel[]		relocation data for code/data array
 *		char *	relp		pointer to rel array
 *		char	txt[]		assembled code/data array
 *		char *	txtp		pointer to txt array
 *		
 *	functions called:
 *		int	hibyte()	asout.c
 *		int	lobyte()	asout.c
 *		VOID	outatxb()	asout.c
 *		VOID	outchk()	asout.c
 *		VOID	out_lb()	asout.c
 *		VOID	out_lw()	asout.c
 *		VOID	out_lxb()	asout.c
 *		VOID	out_rw()	asout.c
 *		VOID	out_txb()	asout.c
 *
 *	side effects:
 *		R and T Lines updated.  Listing updated.
 *		The current assembly address is incremented by i.
 */

VOID
outrxb(i, esp, r)
int i;
struct expr *esp;
int r;
{
	a_uint m, n;
	int p_bytes;

	if (pass == 2) {
		if (esp->e_flag==0 && esp->e_base.e_ap==NULL &&
		   !((r & (R_PAGE | R_PCR))==R_PAGN)) {
			/*
			 * Mask Value Selection
			 */
#ifdef	LONGINT
			switch(i) {
			default:
			case 1:	m = (a_uint) ~0x0000007Fl;	n = (a_uint) ~0x000000FFl;	break;	/* 1 byte  */
			case 2:	m = (a_uint) ~0x00007FFFl;	n = (a_uint) ~0x0000FFFFl;	break;	/* 2 bytes */
			case 3:	m = (a_uint) ~0x007FFFFFl;	n = (a_uint) ~0x00FFFFFFl;	break;	/* 3 bytes */
			case 4:	m = (a_uint) ~0x7FFFFFFFl;	n = (a_uint) ~0xFFFFFFFFl;	break;	/* 4 bytes */
			}
#else
			switch(i) {
			default:
			case 1:	m = (a_uint) ~0x0000007F;	n = (a_uint) ~0x000000FF;	break;	/* 1 byte  */
			case 2:	m = (a_uint) ~0x00007FFF;	n = (a_uint) ~0x0000FFFF;	break;	/* 2 bytes */
			case 3:	m = (a_uint) ~0x007FFFFF;	n = (a_uint) ~0x00FFFFFF;	break;	/* 3 bytes */
			case 4:	m = (a_uint) ~0x7FFFFFFF;	n = (a_uint) ~0xFFFFFFFF;	break;	/* 4 bytes */
			}
#endif
			/*
			 * Signed Range Check
			 */
			if (((r & (R_SGND | R_USGN | R_PAGX | R_PCR)) == R_SGND) &&
			   ((m & esp->e_addr) != m) && ((m & esp->e_addr) != 0))
				aerr();

			/*
			 * Unsigned/Overflow Range Check
			 */
			if (((r & (R_SGND | R_USGN | R_PAGX | R_PCR)) == R_USGN) &&
			   ((n & esp->e_addr) != 0))
				aerr();

			/*
			 * Page0 Range Check
			 */
			if (((r & (R_SGND | R_USGN | R_PAGX | R_PCR)) == R_PAG0) &&
			   ((n & esp->e_addr) != 0))
				err('d');

			out_lxb(i,esp->e_addr,0);
			if (oflag) {
				outchk(i,0);
				outatxb(i,esp->e_addr);
			}
		} else {
			if (i == 1) {
				r |= R_BYTE | esp->e_rlcf;
				if ((r & (R_SGND | R_USGN | R_PAGX | R_PCR)) == R_MSB) {
					r &= ~R_BYTES;
					r |= as_msb;
					switch(as_msb) {
					default:
					case 0:	out_lb(lobyte(esp->e_addr),r|R_RELOC);		break;
					case 1:	out_lb(hibyte(esp->e_addr),r|R_RELOC|R_HIGH);	break;
					case 2:	out_lb(thrdbyte(esp->e_addr),r|R_RELOC|R_BYT3);	break;
					case 3:	out_lb(frthbyte(esp->e_addr),r|R_RELOC|R_BYT4);	break;
					}
				} else {
					out_lb(lobyte(esp->e_addr),r|R_RELOC);
				}
			} else {
				switch(i) {
				default:
				case 2: r |= R_WORD; break;
				case 3: r |= R_3BYTE; break;
				case 4: r |= R_4BYTE; break;
				}
				r |= esp->e_rlcf;
				out_lxb(i,esp->e_addr,r|R_RELOC);
			}
			if (oflag) {
				outchk(a_bytes,4);
				out_txb(a_bytes,esp->e_addr);
				if (esp->e_base.e_ap == NULL) {
					n = area[1].a_ref;
					r |= R_AREA;
					if ((r & (R_PAGE | R_PCR)) != R_PAGN) {
						fprintf(stderr, "?ASxxxx-OUTRXB-NULL-POINTER error.\n\n");
					}
				} else
				if (esp->e_flag) {
					n = esp->e_base.e_sp->s_ref;
					r |= R_SYM;
				} else {
					n = esp->e_base.e_ap->a_ref;
					r |= R_AREA;
				}
				*relp++ = r;
				*relp++ = ((r & 0x0F00) >> 4) | (txtp - txt - a_bytes);
				out_rw(n);
			}
		}
	}
	/*
	 * Update the Program Counter
	 * based upon the area type.
	 */
	p_bytes = 1 + ((dot.s_area->a_flag) & A_BYTES);
	dot.s_addr += (i/p_bytes) + (i % p_bytes ? 1 : 0);
	/*
	 * Area has code
	 */
	dot.s_area->a_flag |= A_OUT;
}

/*)Function	VOID	outrbm(esp, r, v)
 *)Function	VOID	outrwm(esp, r, v)
 *)Function	VOID	outr3bm(esp, r, v)
 *)Function	VOID	outr4bm(esp, r, v)
 *
 *		expr *	esp		pointer to expr structure
 *		int	r		relocation mode
 *		int	v		data to merge into
 *
 *	Dispatch functions for processing relocatable data.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		none
 *		
 *	functions called:
 *		int	outrxbm()	asout.c
 *
 *	side effects:
 *	        relocatable data processed
 */

VOID
outrbm(esp, r, v)
struct expr *esp;
int r;
a_uint v;
{
	outrxbm(1, esp, r, v);
}

VOID
outrwm(esp, r, v)
struct expr *esp;
int r;
a_uint v;
{
	outrxbm(2, esp, r, v);
}

VOID
outr3bm(esp, r, v)
struct expr *esp;
int r;
a_uint v;
{
	outrxbm(3, esp, r, v);
}

VOID
outr4bm(esp, r, v)
struct expr *esp;
int r;
a_uint v;
{
	outrxbm(4, esp, r, v);
}

/*)Function	VOID	outrxbm(i, esp, r, v)
 *
 *		int	i		output byte count
 *		expr *	esp		pointer to expr structure
 *		int	r		relocation mode
 *		a_uint	v		data to merge into
 *
 *	The function outrxbm() merges the data in the expr structure esp
 *	and the variable v (normally an opcode) using the merge
 *	specification coded in r.  If the data in the structure esp
 *	is absolute then esp and v are merged and output as absolute.
 *	If esp is relocatable then the value of esp is output as a normal
 *	relocatable object followed by the absolute value of op.  The
 *	linker will merge the relocatable data with the op code data
 *	using the selected merge specification.  The function outrxbm()
 *	processes 1 to 4 bytes of generated code specified by i.
 *	If the .REL output is enabled then the appropriate information
 *	is loaded into the txt and rel buffers.
 *
 *	local variables:
 *		int	n		symbol/area reference number
 *		int	esprv		merged value
 *		struct mode *mp		pointer to a merge structure
 *		int	p_bytes		program counter update temporary
 *
 *	global variables:
 *		int	a_bytes		T Line byte count
 *		sym	dot		defined as sym[0]
 *		int	oflag		-o, generate relocatable output flag
 *		struct mode modep	an array of pointers to mode structures
 *		int	pass		assembler pass number
 *		char	rel[]		relocation data for code/data array
 *		char *	relp		pointer to rel array
 *		char	txt[]		assembled code/data array
 *		char *	txtp		pointer to txt array
 *		
 *	functions called:
 *		VOID	aerr()		assubr.c
 *		int	hibyte()	asout.c
 *		int	lobyte()	asout.c
 *		VOID	outatxb()	asout.c
 *		VOID	outchk()	asout.c
 *		int	outmerge()	asout.c
 *		VOID	out_lb()	asout.c
 *		VOID	out_lw()	asout.c
 *		VOID	out_lxb()	asout.c
 *		VOID	out_rw()	asout.c
 *		VOID	out_txb()	asout.c
 *
 *	side effects:
 *		R and T Lines updated.  Listing updated.
 *		The current assembly address is incremented by i.
 */

VOID
outrxbm(i, esp, r, v)
int i;
struct expr *esp;
int r;
a_uint v;
{
	a_uint esprv, m;
	int n, p_bytes;
	struct mode *mp;

	if (pass == 2) {
		esprv = outmerge(esp->e_addr, r, v);
		if (esp->e_flag==0 && esp->e_base.e_ap==NULL &&
		   !((r & (R_PAGE | R_PCR))==R_PAGN)) {
			/*
			 * Signed Range Check
			 */
			if (((r & (R_SGND | R_USGN | R_PAGX | R_PCR)) == R_SGND) &&
			   ((mp = modep[(r >> 8) & 0x0F]) != 0)) {
			   	m = ~(mp->m_sbits >> 1);
				if (((m & esp->e_addr) != m) && ((m & esp->e_addr) != 0))
					aerr();
			}
			/*
			 * Unsigned/Overflow Range Check
			 */
			if (((r & (R_SGND | R_USGN | R_PAGX | R_PCR)) == R_USGN) &&
			   ((mp = modep[(r >> 8) & 0x0F]) != 0)) {
				if (~mp->m_sbits & esp->e_addr)
					aerr();
			}
			/*
			 * Page0 Range Check
			 */
			if (((r & (R_SGND | R_USGN | R_PAGX | R_PCR)) == R_PAG0) &&
			   ((mp = modep[(r >> 8) & 0x0F]) != 0)) {
				if (~mp->m_sbits & esp->e_addr)
					err('d');
			}
			out_lxb(i,esprv,0);
			if (oflag) {
				outchk(i,0);
				outatxb(i,esprv);
			}
		} else {
			if (i == 1) {
				r |= R_BYTE | esp->e_rlcf;
				if ((r & (R_SGND | R_USGN | R_PAGX | R_PCR)) == R_MSB) {
					r &= ~R_BYTES;
					r |= as_msb;
					switch(as_msb) {
					default:
					case 0:	out_lb(lobyte(esp->e_addr),r|R_RELOC);		break;
					case 1:	out_lb(hibyte(esp->e_addr),r|R_RELOC|R_HIGH);	break;
					case 2:	out_lb(thrdbyte(esp->e_addr),r|R_RELOC|R_BYT3);	break;
					case 3:	out_lb(frthbyte(esp->e_addr),r|R_RELOC|R_BYT4);	break;
					}
				} else {
					out_lb(lobyte(esprv),r|R_RELOC);
				}
			} else {
				switch(i) {
				default:
				case 2: r |= R_WORD; break;
				case 3: r |= R_3BYTE; break;
				case 4: r |= R_4BYTE; break;
				}
				r |= esp->e_rlcf;
				out_lxb(i,esprv,r|R_RELOC);
			}
			if (oflag) {
				outchk(2*a_bytes,4);
				out_txb(a_bytes,esp->e_addr);
				if (esp->e_base.e_ap == NULL) {
					n = area[1].a_ref;
					r |= R_AREA;
					if ((r & (R_PAGE | R_PCR)) != R_PAGN) {
						fprintf(stderr, "?ASxxxx-OUTRXBM-NULL-POINTER error.\n\n");
					}
				} else
				if (esp->e_flag) {
					n = esp->e_base.e_sp->s_ref;
					r |= R_SYM;
				} else {
					n = esp->e_base.e_ap->a_ref;
					r |= R_AREA;
				}
				*relp++ = r;
				*relp++ = ((r & 0x0F00) >> 4) | (txtp - txt - a_bytes);
				out_rw(n);
				outatxb(a_bytes,v);
			}
		}
	}
	/*
	 * Update the Program Counter
	 * based upon the area type.
	 */
	p_bytes = 1 + ((dot.s_area->a_flag) & A_BYTES);
	dot.s_addr += (i/p_bytes) + (i % p_bytes ? 1 : 0);
	/*
	 * Area has code
	 */
	dot.s_area->a_flag |= A_OUT;
}

/*)Function	VOID	outmerge(esp, r, v)
 *
 *		a_uint	esp		expr value
 *		int	r		relocation mode
 *		a_uint	base		data to merge into
 *
 *	The function outmerge() merges the data in the expr structure esp
 *	and the variable v using the merge specification coded in r.
 *
 *	local variables:
 *		struct mode  *mp	pointer to a merge specification structure
 *		char *	p		pointer to the merge specification string
 *		int	i		loop counter
 *		int	j		temporary
 *		int	m		bit shuffled value
 *
 *	global variables:
 *		struct mode  *modep[]	array of pointers to merge specification structures
 *		FILE	*stderr		error console
 *		
 *	functions called:
 *		int	fprintf()	c_library
 *		VOID	asexit()	asmain.c
 *
 *	side effects:
 *		none
 */
a_uint outmerge(esp, r, base)
a_uint esp;
int r;
a_uint base;
{
	struct mode *mp;
	char *p;
	int i, j;
	a_uint m;

	r = (r >> 8) & 0x0F;

	if ((mp = modep[r]) == NULL) {
		fprintf(stderr, "?ASxxxx-OUTMERGE-UNDEFINED-G-MODE error.\n\n");
		asexit(ER_FATAL);
	}

	if (mp->m_flag) {
		m = 0;
		p = mp->m_def;
		for (i=0; i<32; i++) {
			if ((j = (int) *p++) & 0x80) {
				m |= (esp & (((a_uint) 1) << i)) ? (((a_uint) 1) << (j & 0x1F)) : 0;
			}
		}
	} else {
		m = esp & mp->m_dbits;
	}
	return((base & ~mp->m_dbits) | m);
}

/*)Function	VOID	outdp(carea, esp, r)
 *
 *		area *	carea		pointer to current area structure
 *		expr *	esp		pointer to expr structure
 *		int	r		optional PAGX relocation coding
 *
 *	The function outdp() flushes the output buffer and
 *	outputs paging information to the .REL file.
 *
 *	local variables:
 *		int	n		symbol/area reference number
 *
 *	global variables:
 *		int	a_bytes		T Line byte count
 *		int	oflag		-o, generate relocatable output flag
 *		int	pass		assembler pass number
 *		char	rel[]		relocation data for code/data array
 *		char *	relp		pointer to rel array
 *		char	txt[]		assembled code/data array
 *		char *	txtp		pointer to txt array
 *		
 *	functions called:
 *		VOID	outbuf()	asout.c
 *		VOID	outchk()	asout.c
 *		VOID	out_rw()	asout.c
 *		VOID	out_txb()	asout.c
 *
 *	side effects:
 *		Output buffer flushed to .REL file.
 *		Paging information dumped to .REL file.
 */

VOID
outdp(carea, esp, r)
struct area *carea;
struct expr *esp;
int r;
{
	a_uint n;

	if (oflag && pass==2) {
		outchk(HUGE,HUGE);
		out_txb(a_bytes,carea->a_ref);
		out_txb(a_bytes,esp->e_addr);
		if (esp->e_flag || esp->e_base.e_ap!=NULL) {
			if (esp->e_base.e_ap == NULL) {
				n = area[1].a_ref;
				r |= R_AREA;
				fprintf(stderr, "?ASxxxx-OUTDP-NULL-POINTER error.\n\n");
			} else
			if (esp->e_flag) {
				n = esp->e_base.e_sp->s_ref;
				r |= R_SYM;
			} else {
				n = esp->e_base.e_ap->a_ref;
				r |= R_AREA;
			}
			*relp++ = r;
			*relp++ = txtp - txt - a_bytes;
			out_rw(n);
		}
		if (p_mask != 0xFF) {
			out_txb(a_bytes,p_mask);
		}
		outbuf("P");
	}
}

/*)Function	VOID	outall()
 *
 *	The function outall() will output any bufferred assembled
 *	data and relocation information (during pass 2 if the .REL
 *	output has been enabled).
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		int	oflag		-o, generate relocatable output flag
 *		int	pass		assembler pass number
 *
 *	functions called:
 *		VOID	outbuf()	asout.c
 *
 *	side effects:
 *		assembled data and relocation buffers will be cleared.
 */

VOID
outall()
{
	if (oflag && pass==2)
		outbuf("R");
}

/*)Function	VOID	outdot()
 *
 *	The function outdot() outputs information about the
 *	current program counter value (during pass 2 if the .REL
 *	output has been enabled).
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		int	oflag		-o, generate relocatable output flag
 *		int	pass		assembler pass number
 *		char	rel[]		relocation data for code/data array
 *		char *	relp		pointer to rel array
 *		char	txt[]		assembled code/data array
 *		char *	txtp		pointer to txt array
 *
 *	functions called:
 *		int	fputc()		c_library
 *		VOID	out()		asout.c
 *
 *	side effects:
 *		assembled data and relocation buffers will be cleared.
 */

VOID
outdot()
{
	if (oflag && pass==2) {
		fputc('T', ofp);
		out(txt,(int) (txtp-txt));
		fputc('\n', ofp);
		fputc('R', ofp);
		out(rel,(int) (relp-rel));
		fputc('\n', ofp);
		txtp = txt;
		relp = rel;
	}
}

/*)Function	outchk(nt, nr)
 *
 *		int	nr		number of additional relocation words
 *		int	nt		number of additional data words
 *
 *	The function outchk() checks the data and relocation buffers
 *	for space to insert the nt data words and nr relocation words.
 *	If space is not available then output the current data and
 *	initialize the data buffers to receive the new data.
 *
 *	local variables:
 *		area *	ap		pointer to an area structure
 *
 *	global variables:
 *		int	a_bytes		T Line byte count
 *		sym	dot		defined as sym[0]
 *		char	rel[]		relocation data for code/data array
 *		char *	relp		pointer to rel array
 *		char	txt[]		assembled code/data array
 *		char *	txtp		pointer to txt array
 *
 *	functions called:
 *		VOID	outbuf()	asout.c
 *		VOID	out_rw()	asout.c
 *		VOID	out_txb()	asout.c
 *
 *	side effects:
 *		Data and relocation buffers may be emptied and initialized.
 */

VOID
outchk(nt, nr)
int nt;
int nr;
{
	struct area *ap;

	if (txtp+nt >= &txt[NTXT] || relp+nr >= &rel[NREL]) {
		outbuf("R");
	}
	if (txtp == txt) {
		out_txb(a_bytes,dot.s_addr);
		if ((ap = dot.s_area) != NULL) {
			*relp++ = R_AREA;
			*relp++ = 0;
			out_rw(ap->a_ref);
		}
	}
}

/*)Function	VOID	outbuf(s)
 *
 *		char *	s		"R" or "P" or ("I" illegal)
 *
 *	The function outbuf() will output any bufferred data
 *	and relocation information to the .REL file.  The output
 *	buffer pointers and counters are initialized.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		FILE *	ofp		relocation output file handle
 *		char	rel[]		relocation data for code/data array
 *		char *	relp		pointer to rel array
 *		char	txt[]		assembled code/data array
 *		char *	txtp		pointer to txt array
 *
 *	functions called:
 *		int	fputc()		c_library
 *		int	fputs()		c_library
 *		VOID	out()		asout.c
 *
 *	side effects:
 *		All bufferred data written to .REL file and
 *		buffer pointers and counters initialized.
 */

VOID
outbuf(s)
char *s;
{
	if (txtp > &txt[a_bytes]) {
		fputc('T', ofp);
		out(txt,(int) (txtp-txt));
		fputc('\n', ofp);
		fputs(s, ofp);
		out(rel,(int) (relp-rel));
		fputc('\n', ofp);
	}
	txtp = txt;
	relp = rel;
}

/*)Function	VOID	outgsd()
 *
 *	The function outgsd() performs the following:
 *	(1)	outputs the .REL file radix
 *	(2)	outputs the header specifying the number
 *		of areas and global symbols
 *	(3)	outputs the module name
 *	(4)	outputs the merge mode specifications
 *	(5)	outputs the bank specifications
 *	(6)	set the reference number and output a symbol line
 *		for all external global variables and absolutes
 *	(7)	output an area name, set reference number and output
 *		a symbol line for all global relocatables in the area.
 *		Repeat this proceedure for all areas.
 *
 *	local variables:
 *		area *	ap		pointer to an area structure
 *		bank *	bp		pointer to a  bank structure
 *		sym *	sp		pointer to a sym structure
 *		int	i		loop counter
 *		int	j		loop counter
 *		int	narea		number of areas
 *		int	nbank		number of banks
 *		int	nglob		number of global symbols
 *		int	nmode		number of merge modes
 *		char *	ptr		string pointer
 *		int	rn		symbol reference number
 *
 *	global variables:
 *		area *	areap		pointer to an area structure
 *		bank *	bankp		pointer to a  bank structure
 *		int	hilo		byte order
 *		mode *	modep[]		array of pointers to the merge mode structures
 *		char	module[]	module name string
 *		sym *	symhash[]	array of pointers to NHASH
 *					linked symbol lists
 *		int	xflag		-x, listing radix flag
 *
 *	functions called:
 *		int	fprintf()	c_library
 *		int	fputc()		c_library
 *		int	fputs()		c_library
 *		VOID	outarea()	asout.c
 *		VOID	outbank()	asout.c
 *		VOID	outmode()	asout.c
 *		VOID	outsym()	asout.c
 *
 *	side effects:
 *		All symbols are given reference numbers, all symbol
 *		and area information is output to the .REL file.
 */

VOID
outgsd()
{
	struct area *ap;
	struct bank *bp;
	struct sym  *sp;
	int i, j;
	char *ptr;
	int narea, nglob, nbank, nmode, rn;

	/*
	 * Number of areas
	 */
	narea = areap->a_ref + 1;

	/*
	 * Number of global references/absolutes
	 */
	nglob = 0;
	for (i = 0; i < NHASH; ++i) {
		sp = symhash[i];
		while (sp) {
			if (sp->s_flag&S_GBL)
				nglob += 1;
			sp = sp->s_sp;
		}
	}

	/*
	 * Banks.
	 */
	nbank = bankp->b_ref + 1;

	/*
	 * Modes
	 */
	nmode = 0;
	for (i=0; i<16; i++) {
		if (modep[i] != NULL) {
			nmode += 1;
		}
	}

	/*
	 * Output Radix and number of  areas and symbols
	 */
	if (xflag == 0) {
		fprintf(ofp, "X%c%d\n", (int) hilo ? 'H' : 'L', a_bytes);
		fprintf(ofp, "H %X areas %X global symbols %X banks %X modes\n", narea, nglob, nbank, nmode);
	} else
	if (xflag == 1) {
		fprintf(ofp, "Q%c%d\n", (int) hilo ? 'H' : 'L', a_bytes);
		fprintf(ofp, "H %o areas %o global symbols %o banks %o modes\n", narea, nglob, nbank, nmode);
	} else
	if (xflag == 2) {
		fprintf(ofp, "D%c%d\n", (int) hilo ? 'H' : 'L', a_bytes);
		fprintf(ofp, "H %u areas %u global symbols %u banks %u modes\n", narea, nglob, nbank, nmode);
	}		

	/*
	 * Module name
	 */
	if (module[0]) {
		fputs("M ", ofp);
		ptr = &module[0];
		fputs(ptr, ofp);
		fputc('\n', ofp);
	}

	/*
	 * Modes
	 */
	for (i=0; i<nmode; i++) {
		outmode(i, modep[i]);
	}

	/*
	 * Banks.
	 */
	for (i=0; i<nbank; ++i) {
		bp = bankp;
		while (bp->b_ref != i)
			bp = bp->b_bp;
		outbank(bp);
	}

	/*
	 * Global references and absolutes.
	 */
	rn = 0;
	for (i=0; i<NHASH; ++i) {
		sp = symhash[i];
		while (sp) {
			if (sp->s_area==NULL && sp->s_flag&S_GBL) {
				sp->s_ref = rn++;
				outsym(sp);
			}
			sp = sp->s_sp;
		}
	}

	/*
	 * Global relocatables.
	 */
	for (i=0; i<narea; ++i) {
		ap = areap;
		while (ap->a_ref != i)
			ap = ap->a_ap;
		outarea(ap);
		for (j=0; j<NHASH; ++j) {
			sp = symhash[j];
			while (sp) {
				if (sp->s_area==ap && sp->s_flag&S_GBL) {
					sp->s_ref = rn++;
					outsym(sp);
				}
				sp = sp->s_sp;
			}
		}
	}
}

/*)Function	VOID	outmode(index, mp)
 *
 *		int index		merge mode number (0 - 15)
 *		struct mode *mp		pointer to a merge mode structure
 *
 *	The function outmode() outputs the G line to the .REL
 *	file.  The G line contains the merge mode definition.
 *
 *	local variables:
 *		char *	p		pointer to bit definition
 *		int	i		loop counter
 *		int	lines		number of data lines per G specification
 *
 *	global variables:
 *		int	a_bytes		T line addressing width
 *		FILE *	ofp		relocation output file handle
 *
 *	functions called:
 *		int	fprintf()	c_library
 *		int	fputc()		c_library
 *		void	out()		.REL file data format processor
 *
 *	side effects:
 *		The G line is sent to the .REL file.
 */

VOID
outmode(index, mp)
int index;
struct mode *mp;
{
	char *p;
	int i, lines;

	p = &mp->m_def[0];
	lines = (a_bytes > 2) ? 2 : 1;

	for (i=0; i<lines; i++) {
		if (xflag == 0) {
			fprintf(ofp, "G %02X %02X", index, i*16);
		} else
		if (xflag == 1) {
			fprintf(ofp, "G %03o %03o", index, i*16);
		} else
		if (xflag == 2) {
			fprintf(ofp, "G %03u %03u", index, i*16);
		}		
		out(p + i*16, 16);
		fputc('\n', ofp);
	}
}

/*)Function	VOID	outbank(bp)
 *
 *		bank *	bp		pointer to a bank structure
 *
 *	The function outbank()	outputs the B line to the .REL
 *	file.  The B line contains the bank's name, base, size,
 *	map, flags, and file suffix.
 *
 *	local variables:
 *		char *	frmt		pointer to format string
 *
 *	global variables:
 *		FILE *	ofp		relocation output file handle
 *		int	xflag		-x, listing radix flag
 *
 *	functions called:
 *		int	fprintf()	c_library
 *		int	fputc()		c_library
 *		int	fputs()		c_library
 *
 *	side effects:
 *		The B line is sent to the .REL file.
 */

VOID
outbank(bp)
struct bank *bp;
{
	char * frmt;

	fputs("B ", ofp);
	fputs(&bp->b_id[0], ofp);

#ifdef	LONGINT
	switch(xflag) {
	default:
	case 0:	frmt = " base %lX size %lX map %lX flags %X";	break;
	case 1: frmt = " base %lo size %lo map %lo flags %o";	break;
	case 2: frmt = " base %lu size %lu map %lu flags %u";	break;
	}
#else
	switch(xflag) {
	default:
	case 0:	frmt = " base %X size %X map %X flags %X";	break;
	case 1: frmt = " base %o size %o map %o flags %o";	break;
	case 2: frmt = " base %u size %u map %u flags %u";	break;
	}
#endif

	fprintf(ofp, frmt, bp->b_base & a_mask, bp->b_size & a_mask, bp->b_map & a_mask, bp->b_flag);
	if ((bp->b_fsfx != NULL) && *bp->b_fsfx) {
		fputs(" fsfx ", ofp);
		fputs(bp->b_fsfx, ofp);
	}
	fputc('\n', ofp);
}

/*)Function	VOID	outarea(ap)
 *
 *		area *	ap		pointer to an area structure
 *
 *	The function outarea()	outputs the A line to the .REL
 *	file.  The A line contains the area's name, bank, size,
 *	and attributes.
 *
 *	local variables:
 *		int	a_flag		local area flags
 *		bank *	bp		pointer to bank structure
 *		char *	frmt		pointer to format string
 *
 *	global variables:
 *		FILE *	ofp		relocation output file handle
 *		int	xflag		-x, listing radix flag
 *
 *	functions called:
 *		int	fprintf()	c_library
 *		int	fputc()		c_library
 *		int	fputs()		c_library
 *
 *	side effects:
 *		The A line is sent to the .REL file.
 *
 *		If the area attributes are not fully defined
 *		then default attributes are specified.
 */

VOID
outarea(ap)
struct area *ap;
{
	int a_flag;
	struct bank *bp;
	char * frmt;

	a_flag = ap->a_flag;
	switch(a_flag & (A_ABS | A_OVR)) {
	case A_CON:	a_flag |= (A_REL | A_CON);	break;
	case A_OVR:	a_flag |= (A_ABS | A_OVR);	break;
	case A_REL:	a_flag |= (A_REL | A_CON);	break;
	case A_ABS:	a_flag |= (A_ABS | A_OVR);	break;
	default:	a_flag |= (A_REL | A_CON);	break;
	}

	fputs("A ", ofp);
	fputs(&ap->a_id[0], ofp);

#ifdef	LONGINT
	switch(xflag) {
	default:
	case 0:	frmt = " size %lX flags %X";	break;
	case 1: frmt = " size %lo flags %o";	break;
	case 2: frmt = " size %lu flags %u";	break;
	}
#else
	switch(xflag) {
	default:
	case 0:	frmt = " size %X flags %X";	break;
	case 1: frmt = " size %o flags %o";	break;
	case 2: frmt = " size %u flags %u";	break;
	}
#endif

	fprintf(ofp, frmt, ap->a_size & a_mask, a_flag);
	bp = ap->b_bp;
	if (((ap->a_flag & A_BNK) == A_BNK) && (bp != NULL)) {
		if (xflag == 0) {
			fprintf(ofp, " bank %X", bp->b_ref);
		} else
		if (xflag == 1) {
			fprintf(ofp, " bank %o", bp->b_ref);
		} else
		if (xflag == 2) {
			fprintf(ofp, " bank %u", bp->b_ref);
		}
	}
	fputc('\n', ofp);
}

/*)Function	VOID	outsym(sp)
 *
 *		sym *	sp		pointer to a sym structure
 *
 *	The function outsym() outputs the S line to the .REL
 *	file.  The S line contains the symbols name and whether the
 *	the symbol is defined or referenced.
 *
 *	local variables:
 *		char *	ptr		pointer to symbol id string
 *		int	s_addr		(int) truncated to 2-bytes
 *
 *	global variables:
 *		int	a_bytes		argument size in bytes
 *		FILE *	ofp		relocation output file handle
 *		int	xflag		-x, listing radix flag
 *
 *	functions called:
 *		int	fprintf()	c_library
 *		int	fputs()		c_library
 *
 *	side effects:
 *		The S line is sent to the .REL file.
 */

VOID
outsym(sp)
struct sym *sp;
{
	char *frmt;
	a_uint s_addr;

	/*
	 * Truncate (int) to N-Bytes
	 */
	s_addr = sp->s_addr & a_mask;

	fputs("S ", ofp);
	fputs(&sp->s_id[0], ofp);
	fputs(sp->s_type==S_NEW ? " Ref" : " Def", ofp);

#ifdef	LONGINT
	switch(xflag) {
	default:
	case 0:
		switch(a_bytes) {
		default:
		case 2:	frmt = "%04lX\n"; break;
		case 3:	frmt = "%06lX\n"; break;
		case 4:	frmt = "%08lX\n"; break;
		}
		break;

	case 1:
		switch(a_bytes) {
		default:
		case 2:	frmt = "%06lo\n"; break;
		case 3:	frmt = "%08lo\n"; break;
		case 4:	frmt = "%011lo\n"; break;
		}
		break;

	case 2:
		switch(a_bytes) {
		default:
		case 2:	frmt = "%05lu\n"; break;
		case 3:	frmt = "%08lu\n"; break;
		case 4:	frmt = "%010lu\n"; break;
		}
		break;
	}
#else
	switch(xflag) {
	default:
	case 0:
		switch(a_bytes) {
		default:
		case 2:	frmt = "%04X\n"; break;
		case 3:	frmt = "%06X\n"; break;
		case 4:	frmt = "%08X\n"; break;
		}
		break;

	case 1:
		switch(a_bytes) {
		default:
		case 2:	frmt = "%06o\n"; break;
		case 3:	frmt = "%08o\n"; break;
		case 4:	frmt = "%011o\n"; break;
		}
		break;

	case 2:
		switch(a_bytes) {
		default:
		case 2:	frmt = "%05u\n"; break;
		case 3:	frmt = "%08u\n"; break;
		case 4:	frmt = "%010u\n"; break;
		}
		break;
	}
#endif

	fprintf(ofp, frmt, s_addr);
}

/*)Function	VOID	out(p, n)
 *
 *		int	n		number of words to output
 *		int *	p		pointer to data words
 *
 *	The function out() outputs the data words to the .REL file
 *	in the specified radix.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		FILE *	ofp		relocation output file handle
 *		int	xflag		-x, listing radix flag
 *
 *	functions called:
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		Data is sent to the .REL file.
 */

VOID
out(p, n)
char *p;
int n;
{
	while (n--) {
		if (xflag == 0) {
			fprintf(ofp, " %02X", (*p++)&0377);
		} else
		if (xflag == 1) {
			fprintf(ofp, " %03o", (*p++)&0377);
		} else
		if (xflag == 2) {
			fprintf(ofp, " %03u", (*p++)&0377);
		}
	}
}

/*)Function	VOID	out_lb(v, t)
 *
 *		a_uint	v		assembled data
 *		int	t		relocation type
 *
 *	The function out_lb() copies the assembled data and
 *	its relocation type to the list data buffers.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		int *	cp		pointer to assembler output array cb[]
 *		int *	cpt		pointer to assembler relocation type
 *					output array cbt[]
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		Pointers to data and relocation buffers incremented by 1.
 */

VOID
out_lb(v, t)
a_uint v;
int t;
{
	if (cp < &cb[NCODE]) {
		*cp++ = (char) v;
		*cpt++ = t;
	}
}

/*)Function	VOID	out_lw(v, t)
 *)Function	VOID	out_l3b(v, t)
 *)Function	VOID	out_l4b(v, t)
 *
 *		int	v		assembled data
 *		int	t		relocation type
 *
 *	Dispatch functions for processing listing data.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		Listing data processed.
 */

VOID
out_lw(v, t)
a_uint v;
int t;
{
	out_lxb(2, v, t);
}

VOID
out_l3b(v, t)
a_uint v;
int t;
{
	out_lxb(3, v, t);
}

VOID
out_l4b(v, t)
a_uint v;
int t;
{
	out_lxb(4, v, t);
}

/*)Function	VOID	out_lxb(i, v, t)
 *
 *		int	i		output byte count
 *		a_uint	v		assembled data
 *		int	t		relocation type
 *
 *	Dispatch function for list processing.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		int	hilo		byte order
 *
 *	functions called:
 *		VOID	out_lb()	asout.c
 *
 *	side effects:
 *		i list bytes are processed.
 */

VOID
out_lxb(i, v, t)
int i;
a_uint v;
int t;
{
	if ((int) hilo) {
		if (i >= 4) out_lb(frthbyte(v),t&R_RELOC ? t|R_BYT4 : 0);
		if (i >= 3) out_lb(thrdbyte(v),t&R_RELOC ? t|R_BYT3 : 0);
		if (i >= 2) out_lb(hibyte(v),t&R_RELOC ? t|R_HIGH : 0);
		if (i >= 1) out_lb(lobyte(v),t);
	} else {
		if (i >= 1) out_lb(lobyte(v),t);
		if (i >= 2) out_lb(hibyte(v),t&R_RELOC ? t|R_HIGH : 0);
		if (i >= 3) out_lb(thrdbyte(v),t&R_RELOC ? t|R_BYT3 : 0);
		if (i >= 4) out_lb(frthbyte(v),t&R_RELOC ? t|R_BYT4 : 0);
	}
}

/*)Function	VOID	out_rw(v)
 *
 *		a_uint	v		assembled data
 *
 *	The function out_rw() outputs the relocation (R)
 *	data word as two bytes ordered according to hilo.
 *
 *	local variables:
 *		char *	relp		pointer to rel array
 *
 *	global variables:
 *		int	hilo		byte order
 *
 *	functions called:
 *		int	lobyte()	asout.c
 *		int	hibyte()	asout.c
 *
 *	side effects:
 *		Pointer to relocation buffer incremented by 2.
 */

VOID
out_rw(v)
a_uint v;
{
	if ((int) hilo) {
		*relp++ = hibyte(v);
		*relp++ = lobyte(v);
	} else {
		*relp++ = lobyte(v);
		*relp++ = hibyte(v);
	}
}

/*)Function	VOID	out_txb(i, v)
 *
 *		int	i		T Line byte count
 *		a_uint	v		data word
 *
 *	The function out_txb() outputs the text (T)
 *	as a_bytes bytes ordered according to hilo.
 *
 *	local variables:
 *		char *	txtp		pointer to txt array
 *
 *	global variables:
 *		int	hilo		byte order
 *
 *	functions called:
 *		int	lobyte()	asout.c
 *		int	hibyte()	asout.c
 *		int	thrdbyte()	asout.c
 *		int	frthbyte()	asout.c
 *
 *	side effects:
 *		T Line buffer updated.
 */

VOID
out_txb(i, v)
int i;
a_uint v;
{
	if ((int) hilo) {
		if (i >= 4) *txtp++ = frthbyte(v);
		if (i >= 3) *txtp++ = thrdbyte(v);
		if (i >= 2) *txtp++ = hibyte(v);
		if (i >= 1) *txtp++ = lobyte(v);
	} else {
		if (i >= 1) *txtp++ = lobyte(v);
		if (i >= 2) *txtp++ = hibyte(v);
		if (i >= 3) *txtp++ = thrdbyte(v);
		if (i >= 4) *txtp++ = frthbyte(v);
	}
}

/*)Function	int	lobyte(v)
 *)Function	int	hibyte(v)
 *)Function	int	thrdbyte(v)
 *)Function	int	frthbyte(v)
 *
 *		a_uint	v		assembled data
 *
 *	These functions return the 1st, 2nd, 3rd, or 4th byte
 *	of integer v.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		none
 */

int
lobyte(v)
a_uint v;
{
	return ((int) (v&0377));
}

int
hibyte(v)
a_uint v;
{
	return ((int) ((v>>8)&0377));
}

int
thrdbyte(v)
a_uint v;
{
	return ((int) ((v>>16)&0377));
}

int
frthbyte(v)
a_uint v;
{
	return ((int) ((v>>24)&0377));
}


