/* lkarea.c */

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
 */

#include "aslink.h"

/*)Module	lkarea.c
 *
 *	The module lkarea.c contains the functions which
 *	create and link together all area definitions read
 *	from the .rel file(s).
 *
 *	lkarea.c contains the following functions:
 *		VOID	lnkarea()
 *		VOID	lnksect()
 *		VOID	lkparea()
 *		VOID	newarea()
 *		VOID	setarea()
 *
 *	lkarea.c contains no global variables.
 */

/*)Function	VOID	newarea()
 * 
 *	The function newarea() creates and/or modifies area
 *	and areax structures for each A directive read from
 *	the .rel file(s).  The function lkparea() is called
 *	to find tha area structure associated with this name.
 *	If the area does not yet exist then a new area
 *	structure is created and linked to any existing
 *	linked area structures. The area flags are copied
 *	into the area flag variable.  For each occurence of
 *	an A directive an areax structure is created and
 *	linked to the areax structures associated with this
 *	area.  The size of this area section is placed into
 *	the areax structure.  The flag value for all subsequent
 *	area definitions for the same area are compared and
 *	flagged as an error if they are not identical.
 *	The areax structure created for every occurence of
 *	an A directive is loaded with a pointer to the base
 *	area structure and a pointer to the associated
 *	head structure.  And finally, a pointer to this
 *	areax structure is loaded into the list of areax
 *	structures in the head structure.  Refer to lkdata.c
 *	for details of the structures and their linkage.
 *
 *	local variables:
 *		areax **halp		pointer to an array of pointers
 *		a_uint	i		value
 *		char	id[]		id string
 *		int	k		counter, loop variable
 *		int	narea		number of areas in this head structure
 *		areax *	taxp		pointer to an areax structure
 *					to areax structures
 *
 *	global variables:
 *		area	*ap		Pointer to the current
 *				 	area structure
 *		areax	*axp		Pointer to the current
 *				 	areax structure
 *		head	*hp		Pointer to the current
 *				 	head structure
 *		int	lkerr		error flag
 *
 *	functions called:
 *		a_uint	eval()		lkeval.c
 *		VOID	exit()		c_library
 *		int	fprintf()	c_library
 *		VOID	getid()		lklex.c
 *		VOID	lkparea()	lkarea.c
 *		VOID	skip()		lklex.c
 *
 *	side effects:
 *		The area and areax structures are created and
 *		linked with the appropriate head structures.
 *		Failure to allocate area or areax structure
 *		space will terminate the linker.  Other internal
 *		errors most likely caused by corrupted .rel
 *		files will also terminate the linker.
 */

/*
 * Create an area entry.
 *
 * A xxxxxx size nnnn flags mm bank n
 *   |           |          |       |
 *   |           |          |       `--  ap->a_bank  
 *   |           |          `----------  ap->a_flag
 *   |           `--------------------- axp->a_size
 *   `---------------------------------  ap->a_id
 *
 */
VOID
newarea()
{
	a_uint i;
	int k, narea;
	int aflags, iflags;
	struct areax *taxp;
	struct areax **halp;
	struct bank **hblp;
	char id[NCPS];
	char opt[NCPS];

	if (headp == NULL) {
		fprintf(stderr, "No header defined\n");
		lkexit(ER_FATAL);
	}
	/*
	 * Create Area entry
	 */
	getid(id, -1);
	lkparea(id);
	/*
	 * Evaluate Parameters
	 */
	while (more()) {
		getid(opt, -1);
		i = eval();
		/*
		 * Evaluate size
		 */
		if (symeq("size", opt, 1)) {
			axp->a_size = i;
		} else
		/*
		 * Evaluate flags
		 */
		if (symeq("flags", opt, 1)) {
			if (ASxxxx_VERSION == 3) {
				/*
				 * Create version 4 area flags.
				 */
				i &= (A3_OVR | A3_ABS | A3_PAG);
				i = ((i << 8) | i);
			}
			taxp = ap->a_axp;
			if (taxp->a_axp) {
				aflags = ap->a_flag;
				iflags = (int) (i & A4_OVR);
				if (iflags) {
			 		if (aflags & A4_OVR) {
						if (iflags != (aflags & A4_OVR)) {
							fprintf(stderr, "Conflicting CON/OVR flags in area %s\n", id);
							lkerr++;
						}
					} else {
						ap->a_flag |= iflags;
					}
				}
				iflags = (int) (i & A4_ABS);
				if (iflags) {
			 		if (aflags & A4_ABS) {
						if (iflags != (aflags & A4_ABS)) {
							fprintf(stderr, "Conflicting REL/ABS flags in area %s\n", id);
							lkerr++;
						}
					} else {
						ap->a_flag |= iflags;
					}
				}
				iflags = (int) (i & A4_PAG);
				if (iflags) {
			 		if (aflags & A4_PAG) {
						if (iflags != (aflags & A4_PAG)) {
							fprintf(stderr, "Conflicting NOPAG/PAG flags in area %s\n", id);
							lkerr++;
						}
					} else {
						ap->a_flag |= iflags;
					}
				}
				if (i & A4_DSEG) {
					iflags = (int) (i & (A4_DSEG | A4_WLMSK));
				 	if (aflags & A4_DSEG) {
						if (iflags != (aflags & (A4_DSEG | A4_WLMSK))) {
							fprintf(stderr, "Conflicting CSEG/DSEG flags in area %s\n", id);
							lkerr++;
						}
					} else {
						ap->a_flag |= iflags;
					}
				}
				/*
				 * Merge Output Code Flag
				 */
				ap->a_flag |= (int) (i & A4_OUT);
			} else {
				ap->a_flag = (int) i;
			}
		} else
		/*
		 * Evaluate bank
		 */
		if (symeq("bank", opt, 1)) {
			hblp = hp->b_list;
			if (hblp == NULL) {
				fprintf(stderr, "No banks defined\n");
				lkexit(ER_FATAL);
			}
			if (i >= (unsigned) hp->h_nbank) {
				fprintf(stderr, "Invalid bank number\n");
				lkexit(ER_FATAL);
			}
			if (hblp[(int) i] == NULL) {
				fprintf(stderr, "Bank not defined\n");
				lkexit(ER_FATAL);
			}
			if (ap->a_bp != NULL) {
				if (ap->a_bp != hblp[(int) i]) {
					fprintf(stderr, "Multiple Bank assignments for area %s ( %s / %s )\n",
						id, ap->a_bp->b_id, hblp[(int) i]->b_id);
					lkerr++;
				}
			} else {
				ap->a_bp = hblp[(int) i];
			}
		}
	}

	/*
	 * Place pointer in header area list
	 */
	taxp = ap->a_axp;
	while (taxp->a_axp) {
		taxp = taxp->a_axp;
	}
	narea = hp->h_narea;
	halp = hp->a_list;
	for (k=0; k < narea ;++k) {
		if (halp[k] == NULL) {
			halp[k] = taxp;
			return;
		}
	}
	fprintf(stderr, "Header area list overflow\n");
	lkexit(ER_FATAL);
}

/*)Function	VOID	lkparea(id)
 *
 *		char *	id		pointer to the area name string
 *
 *	The function lkparea() searches the linked area structures
 *	for a name match.  If the name is not found then an area
 *	structure is created.  An areax structure is created and
 *	appended to the areax structures linked to the area structure.
 *	The associated base area and head structure pointers are
 *	loaded into the areax structure.
 *
 *	local variables:
 *		area *	tap		pointer to an area structure
 *		areax *	taxp		pointer to an areax structure
 *
 *	global variables:
 *		area	*ap		Pointer to the current
 *				 	area structure
 *		area	*areap		The pointer to the first
 *				 	area structure of a linked list
 *		areax	*axp		Pointer to the current
 *				 	areax structure
 *
 *	functions called:
 *		VOID *	new()		lksym()
 *		char *	strsto()	lksym.c
 *		int	symeq()		lksym.c
 *
 *	side effects:
 *		Area and/or areax structures are created.
 *		Failure to allocate space for created structures
 *		will terminate the linker.
 */

VOID
lkparea(id)
char *id;
{
	struct area *tap;
	struct areax *taxp;

	ap = areap;
	axp = (struct areax *) new (sizeof(struct areax));
	while (ap) {
		if (symeq(id, ap->a_id, 1)) {
			taxp = ap->a_axp;
			while (taxp->a_axp)
				taxp = taxp->a_axp;
			taxp->a_axp = axp;
			axp->a_bap = ap;
			axp->a_bhp = hp;
			return;
		}
		ap = ap->a_ap;
	}
	ap = (struct area *) new (sizeof(struct area));
	if (areap == NULL) {
		areap = ap;
	} else {
		tap = areap;
		while (tap->a_ap)
			tap = tap->a_ap;
		tap->a_ap = ap;
	}
	ap->a_axp = axp;
	axp->a_bap = ap;
	axp->a_bhp = hp;
	ap->a_id = strsto(id);
}

/*)Function	VOID	lnkarea()
 *
 *	The function lnkarea() resolves all area addresses.
 *	The function evaluates each area structure (and all
 *	the associated areax structures) in sequence.  The
 *	linking process supports four (4) possible area types:
 *
 *	ABS/OVR	-	All sections (each individual areax
 *			section) starts at the identical base
 *			area address overlaying all other
 *			areax sections for this area.  The
 *			size of the area is largest of the area
 *			sections.
 *
 *	ABS/CON -	All sections (each individual areax
 *			section) are concatenated with the
 *			first section starting at the base
 *			area address.  The size of the area
 *			is the sum of the section sizes.
 *
 *		NOTE:	Multiple absolute (ABS) areas are
 *			never concatenated with each other,
 *			thus absolute area A and absolute area
 *			B will overlay each other if they begin
 *			at the same location (the default is
 *			always address 0 for absolute areas).
 *
 *	REL/OVR	-	All sections (each individual areax
 *			section) starts at the identical base
 *			area address overlaying all other
 *			areax sections for this area.  The
 *			size of the area is largest of the area
 *			sections.
 *
 *	REL/CON -	All sections (each individual areax
 *			section) are concatenated with the
 *			first section starting at the base
 *			area address.  The size of the area
 *			is the sum of the section sizes.
 *
 *		NOTE:	Relocatable (REL) areas are always concatenated
 *			with each other, thus relocatable area B
 *			(defined after area A) will follow
 *			relocatable area A independent of the
 *			starting address of area A.  Within a
 *			specific area each areax section may be
 *			overlayed or concatenated with other
 *			areax sections.
 *
 *
 *	If a base address for an area is specified then the
 *	area will start at that address.  Any relocatable
 *	areas defined subsequently will be concatenated to the
 *	previous relocatable area if it does not have a base
 *	address specified.
 *
 *	The names s_<areaname> and l_<areaname> are created to
 *	define the starting address and length of each area.
 *
 *	local variables:
 *		a_uint	rloc		;current relocation address
 *		char	temp[]		;temporary string
 *		struct symbol	*sp	;symbol structure
 *
 *	global variables:
 *		area	*ap		Pointer to the current
 *				 	area structure
 *		area	*areap		The pointer to the first
 *				 	area structure of a linked list
 *
 *	functions called:
 *		int	fprintf()	c_library
 *		VOID	lnksect()	lkarea.c
 *		symbol *lkpsym()	lksysm.c
 *		char *	strncpy()	c_library
 *		int	symeq()		lksysm.c
 *
 *	side effects:
 *		All area and areax addresses and sizes are
 *		determined and saved in their respective
 *		structures.
 */

/*
 * Resolve all bank/area addresses.
 */
VOID
lnkarea()
{
	a_uint rloc;
	int bytes;
	char temp[NCPS+2];
	struct sym *sp;

	for (bp = bankp; bp != NULL; bp = bp->b_bp) {
	
	    rloc = 0;
	    for (ap = areap; ap != NULL; ap = ap->a_ap) {
		if (ap->a_bp != bp)
			continue;

		if ((ap->a_flag & A4_ABS) == A4_ABS) {
			/*
			 * Absolute sections
			 */
			lnksect(ap);
		} else {
			/*
			 * Relocatable sections
			 */
			bytes = 1 + (ap->a_flag & A4_WLMSK);
			if (ap->a_bset == 0)
				ap->a_addr = (rloc/bytes) + ((rloc % bytes) ? 1 : 0);
			lnksect(ap);
			rloc = (ap->a_addr + ap->a_size) * bytes;
		}

		/*
		 * Create symbols called:
		 *	s_<areaname>	the start address of the area
		 *	l_<areaname>	the length of the area
		 */

		if (! symeq(ap->a_id, _abs_, 1)) {
			strcpy(temp+2, ap->a_id);
			*(temp+1) = '_';

			*temp = 's';
			sp = lkpsym(temp, 1);
			sp->s_addr = ap->a_addr;
			sp->s_axp = NULL;
			sp->s_type |= S_DEF;

			*temp = 'l';
			sp = lkpsym(temp, 1);
			sp->s_addr = ap->a_size;
			sp->s_axp = NULL;
			sp->s_type |= S_DEF;
		}
	    }
	}
}

/*)Function	VOID	lnksect(tap)
 *
 *		area *	tap		pointer to an area structure
 *
 *	The function lnksect() is the function called by
 *	lnkarea() to resolve the areax addresses.  Refer
 *	to the function lnkarea() for more detail. Pageing
 *	boundary and length errors will be reported by this
 *	function.
 *
 *	local variables:
 *		a_uint	size		size of area
 *		a_uint	addr		address of area
 *		areax *	taxp		pointer to an areax structure
 *
 *	global variables:
 *		int	lkerr		error flag
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		All area and areax addresses and sizes are determined
 *		and linked into the structures.
 */

VOID
lnksect(tap)
struct area *tap;
{
	a_uint size, addr;
	struct areax *taxp;

	size = 0;
	addr = tap->a_addr;
	if (((tap->a_flag & A4_PAG) == A4_PAG) && (addr & 0xFF)) {
	    fprintf(stderr,
		"\n?ASlink-Warning-Paged Area %s Boundary Error\n",
		tap->a_id);
	    lkerr++;
	}
	taxp = tap->a_axp;
	if ((tap->a_flag & A4_OVR) == A4_OVR) {
		/*
		 * Overlayed sections
		 */
		while (taxp) {
			taxp->a_addr = addr;
			if (taxp->a_size > size)
				size = taxp->a_size;
			taxp = taxp->a_axp;
		}
	} else {
		/*
		 * Concatenated sections
		 */
		while (taxp) {
			taxp->a_addr = addr;
			addr += taxp->a_size;
			size += taxp->a_size;
			taxp = taxp->a_axp;
		}
	}
	tap->a_size = size;
	if (((tap->a_flag & A4_PAG) == A4_PAG) && (size > 256)) {
	    fprintf(stderr,
		"\n?ASlink-Warning-Paged Area %s Length Error\n",
		tap->a_id);
	    lkerr++;
	}
}


/*)Function	VOID	setarea()
 *
 *	The function setarea() scans the base address lines in the
 *	basep structure, evaluates the arguments, and sets the beginning
 *	address of the specified areas.
 *
 *	local variables:
 *		a_uint	v		expression value
 *		char	id[]		base id string
 *
 *	global variables:
 *		area	*ap		Pointer to the current
 *				 	area structure
 *		area	*areap		The pointer to the first
 *				 	area structure of a linked list
 *		base	*basep		The pointer to the first
 *				 	base structure
 *		base	*bsp		Pointer to the current
 *				 	base structure
 *		char	*ip		pointer into the REL file
 *				 	text line in ib[]
 *		int	lkerr		error flag
 *
 *	 functions called:
 *		a_uint	expr()		lkeval.c
 *		int	fprintf()	c_library
 *		VOID	getid()		lklex.c
 *		int	getnb()		lklex.c
 *		int	symeq()		lksym.c
 *
 *	side effects:
 *		The base address of an area is set.
 */

VOID
setarea()
{
	a_uint v;
	char id[NCPS];

	bsp = basep;
	while (bsp) {
		ip = bsp->b_strp;
		getid(id, -1);
		if (getnb() == '=') {
			v = expr(0);
			for (ap = areap; ap != NULL; ap = ap->a_ap) {
				if (symeq(id, ap->a_id, 1))
					break;
			}
			if (ap == NULL) {
				fprintf(stderr,
				"No definition of area %s\n", id);
				lkerr++;
			} else {
				ap->a_addr = v;
				ap->a_bset = 1;
			}
		} else {
			fprintf(stderr, "No '=' in base expression");
			lkerr++;
		}
		bsp = bsp->b_base;
	}
}



