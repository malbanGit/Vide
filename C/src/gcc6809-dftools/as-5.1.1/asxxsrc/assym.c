/* assym.c */

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
 */

#include "asxxxx.h"

/*)Module	assym.c
 *
 *	The module assym.c contains the functions that operate
 *	on the mnemonic/directive and symbol structures.
 *
 *	assym.c contains the following functions:
 *		VOID	allglob()
 *		area *	alookup()
 *		VOID	asfree()
 *		bank *	blookup()
 *		def *	dlookup()
 *		int	hash()
 *		sym *	lookup()
 *		mne *	mlookup()
 *		VOID *	new()
 *		sym *	slookup()
 *		char *	strsto()
 *		int	symeq()
 *		VOID	syminit()
 *		VOID	symglob()
 *
 *	assym.c contains the static variables:
 *		char *	pnext
 *		int	bytes
 *	used by the string store function.
 */

/*)Function	VOID	syminit()
 *
 *	The function syminit() is called early in the game
 *	to set up the hashtables.  First all buckets in a
 *	table are cleared.  Then a pass is made through
 *	the respective symbol lists, linking them into
 *	their hash buckets.
 *
 *	local variables:
 *		int	h		computed hash value
 *		mne *	mp		pointer to a mne structure
 *		mne **	mpp		pointer to an array of
 *					mne structure pointers
 *		sym *	sp		pointer to a sym structure
 *		sym **	spp		pointer to an array of
 *					sym structure pointers
 *
 *	global variables:
 *		mne * mnehash[]		array of pointers to NHASH
 *					linked mnemonic/directive lists
 *		sym * symhash[]		array of pointers to NHASH
 *					linked symbol lists
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		(1)	The symbol hash tables are initialized,
 *			the predefined symbols are '.', '.__.ABS.',
 *			and '.__.CPU.'.
 *		(2)	The mnemonic/directive hash tables are
 *			initialized with the assembler directives
 *			and mnemonics found in the machine dependent
 *			file ___pst.c.
 */

VOID
syminit()
{
	struct mne  *mp;
	struct mne **mpp;
	struct sym  *sp;
	struct sym **spp;
	int h;

	mpp = &mnehash[0];
	while (mpp < &mnehash[NHASH])
		*mpp++ = NULL;
	mp = &mne[0];
	for (;;) {
		h = hash(mp->m_id, 1);
		mp->m_mp = mnehash[h];
		mnehash[h] = mp;
		if (mp->m_flag&S_EOL)
			break;
		++mp;
	}

	spp = &symhash[0];
	while (spp < &symhash[NHASH])
		*spp++ = NULL;
	sp = &sym[0];
	for (;;) {
		h = hash(sp->s_id, zflag);
		sp->s_sp = symhash[h];
		symhash[h] = sp;
		if (sp->s_flag&S_EOL)
			break;
		++sp;
	}
}

/*)Function	area *	alookup(id)
 *
 *		char *	id		area name string
 *
 *	The function alookup() searches the area list for a
 *	match with id.  If the area is defined then a pointer
 *	to this area is returned else a NULL is returned.
 *
 *	local variables:
 *		area *	ap		pointer to area structure
 *
 *	global variables:
 *		area *	areap		pointer to an area structure
 *
 *	functions called:
 *		int	symeq()		assym.c
 *
 *	side effects:
 *		none
 */

struct area *
alookup(id)
char *id;
{
	struct area *ap;

	ap = areap;
	while (ap) {
		/*
		 * JLH: case insensitive lookup always
		 */
		if(symeq(id, ap->a_id, 1))
			return (ap);
		ap = ap->a_ap;
	}
	return(NULL);
}

/*)Function	bank *	blookup(id)
 *
 *		char *	id		bank name string
 *
 *	The function blookup() searches the bank list for a
 *	match with id.  If the bank is defined then a pointer
 *	to this bank is returned else a NULL is returned.
 *
 *	local variables:
 *		bank *	bp		pointer to bank structure
 *
 *	global variables:
 *		bank *	bankp		pointer to a bank structure
 *
 *	functions called:
 *		int	()		assym.c
 *
 *	side effects:
 *		none
 */

struct bank *
blookup(id)
char *id;
{
	struct bank *bp;

	bp = bankp;
	while (bp) {
		/*
		 * JLH: case insensitive lookup always
		 */
		if(symeq(id, bp->b_id, 1))
			return (bp);
		bp = bp->b_bp;
	}
	return(NULL);
}

/*)Function	def *	dlookup(id)
 *
 *		char *	id		definition name string
 *
 *	The function dlookup() searches the definition list for a
 *	match with id.  If the definition is defined then a pointer
 *	to this definition is returned else a NULL is returned.
 *
 *	local variables:
 *		def *	dp		pointer to a def structure
 *
 *	global variables:
 *		def *	defp		pointer to a def structure
 *
 *	functions called:
 *		int	symeq()		assym.c
 *
 *	side effects:
 *		none
 */

struct def *
dlookup(id)
char *id;
{
	struct def *dp;

	dp = defp;
	while (dp) {
		if (symeq(id, dp->d_id, zflag)) {
			break;
		}
		dp = dp->d_dp;
	}
	return(dp);
}

/*)Function	mne *	mlookup(id)
 *
 *		char *	id		mnemonic/directive name string
 *
 *	The function mlookup() searches the mnemonic/directive
 *	hash tables for a match returning a pointer to the
 *	mne structure else it returns a NULL.
 *
 *	local variables:
 *		mne *	mp		pointer to mne structure
 *		int	h		calculated hash value
 *
 *	global variables:
 *		mne * mnehash[]		array of pointers to NHASH
 *					linked mnemonic/directive lists
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		none
 */

struct mne *
mlookup(id)
char *id;
{
	struct mne *mp;
	int h;

	/*
	 * JLH: case insensitive lookup always
	 */
	h = hash(id, 1);
	mp = mnehash[h];
	while (mp) {
		if(symeq(id, mp->m_id, 1))
			return (mp);
		mp = mp->m_mp;
	}
	return (NULL);
}

/*)Function	sym *	slookup(id)
 *
 *		char *	id		symbol name string
 *
 *	The function slookup() searches the symbol hash tables for
 *	a symbol name match returning a pointer to the sym structure
 *	else it returns a NULL.
 *
 *	local variables:
 *		int	h		computed hash value
 *		sym *	sp		pointer to a sym structure
 *
 *	global varaibles:
 *		sym *	symhash[]	array of pointers to NHASH
 *					linked symbol lists
 *		int	zflag		disable symbol case sensitivity
 *
 *	functions called:
 *		int	hash()		assym.c
 *		int	symeq()		assym.c
 *
 *	side effects:
 *		none
 */

struct sym *
slookup(id)
char *id;
{
	struct sym *sp;
	int h;

	h = hash(id, zflag);
	sp = symhash[h];
	while (sp) {
		if(symeq(id, sp->s_id, zflag))
			return (sp);
		sp = sp->s_sp;
	}
	return (NULL);
}

/*)Function	sym *	lookup(id)
 *
 *		char *	id		symbol name string
 *
 *	The function lookup() searches the symbol hash tables for
 *	a symbol name match returning a pointer to the sym structure.
 *	If the symbol is not found then a sym structure is created,
 *	initialized, and linked to the appropriate hash table.
 *	A pointer to this new sym structure is returned.
 *
 *	local variables:
 *		int	h		computed hash value
 *		sym *	sp		pointer to a sym structure
 *
 *	global varaibles:
 *		sym *	symhash[]	array of pointers to NHASH
 *					linked symbol lists
 *		int	zflag		disable symbol case sensitivity
 *
 *	functions called:
 *		int	hash()		assym.c
 *		VOID *	new()		assym.c
 *		char *	strsto()	assym.c
 *		int	symeq()		assym.c
 *
 *	side effects:
 *		If the function new() fails to allocate space
 *		for the new sym structure the assembly terminates.
 */

struct sym *
lookup(id)
char *id;
{
	struct sym *sp;
	int h;

	h = hash(id, zflag);
	sp = symhash[h];
	while (sp) {
		if(symeq(id, sp->s_id, zflag))
			return (sp);
		sp = sp->s_sp;
	}
	sp = (struct sym *) new (sizeof(struct sym));
	sp->s_sp = symhash[h];
	symhash[h] = sp;
	sp->s_tsym = NULL;
	sp->s_id = strsto(id);
	sp->s_type = S_NEW;
	sp->s_flag = 0;
	sp->s_area = NULL;
	sp->s_ref = 0;
	sp->s_addr = 0;
	return (sp);
}

/*)Function	VOID	symglob()
 *
 *	The function symglob() will mark all symbols of
 *	type S_NEW and not local as global.  Called at
 *	the beginning of pass 1 if the assembly
 *	option -g was specified.
 *
 *	local variables:
 *		sym *	sp		pointer to a sym structure
 *		int	i		loop index
 *
 *	global variables:
 *		sym * symhash[]		array of pointers to NHASH
 *					linked symbol lists
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		Symbol types changed.
 */

VOID
symglob()
{
	struct sym *sp;
	int i;

	for (i=0; i<NHASH; ++i) {
		sp = symhash[i];
		while (sp != NULL) {
			if (sp->s_type == S_NEW && !(sp->s_flag & S_LCL))
				sp->s_flag |= S_GBL;
			sp = sp->s_sp;
		}
	}
}

/*)Function	VOID	allglob()
 *
 *	The function allglob() will mark all symbols of
 *	type S_USER and not local as global.  Called at
 *	the beginning of pass 1 if the assembly
 *	option -a was specified.
 *
 *	local variables:
 *		sym *	sp		pointer to a sym structure
 *		int	i		loop index
 *
 *	global variables:
 *		sym * symhash[]		array of pointers to NHASH
 *					linked symbol lists
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		Symbol types changed.
 */

VOID
allglob()
{
	struct sym *sp;
	int i;

	for (i=0; i<NHASH; ++i) {
		sp = symhash[i];
		while (sp != NULL) {
			if (sp != &dot && sp->s_type == S_USER && !(sp->s_flag & S_LCL))
				sp->s_flag |= S_GBL;
			sp = sp->s_sp;
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
		 * Case Insensitive Compare
		 */
		do {
			if (ccase[*p1++ & 0x007F] != ccase[*p2++ & 0x007F])
				return (0);
		} while (--n);
	} else {
		/*
		 * Case Sensitive Compare
		 */
		do {
			if (*p1++ != *p2++)
				return (0);
		} while (--n);
	}
	return (1);
}

/*)Function	int	hash(p, flag)
 *
 *		char *	p		pointer to string to hash
 *		int	flag		case sensitive flag
 *
 *	The function hash() computes a hash code using the sum
 *	of all characters mod table size algorithm.
 *
 *		flag == 0	case insensitve hash
 *		flag != 0	case sensitive hash
 *
 *	local variables:
 *		int	h		accumulated character sum
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
 */
 
int
hash(p, flag)
char *p;
int flag;
{
	int h;

	h = 0;
	while (*p) {
		if(flag) {
			/*
			 * Case Insensitive Hash
			 */
			h += ccase[*p++ & 0x007F];
		} else {
			/*
			 * Case Sensitive Hash
			 */
			h += *p++;
		}
	}
	return (h&HMASK);
}

/*)Function	char *	strsto(str)
 *
 *		char *	str		pointer to string to save
 *
 *	Allocate space for "str", copy str into new space.
 *	Return a pointer to the allocated string.
 *
 *	This function based on code by
 *		John L. Hartman
 *		jhartman at compuserve dot com
 *
 *	local variables:
 *		int	bytes		bytes remaining in buffer area
 *		int	bofst		structure alignment offset
 *		int	len		string length + 1
 *		char *	p		pointer to head of copied string
 *		char *	pnext		next location in buffer area
 *
 *	global variables:
 *		int	asmblk		number of memory blocks allocated
 *		int	bndry		structure alignment
 *
 *	functions called:
 *		VOID *	new()		assym.c
 *		char *	strcpy()	c_library
 *		int *	strlen()	c_library
 *
 *	side effects:
 *		Space allocated for string, string copied
 *		to space.  Out of Space terminates assembler.
 */
 
/*
 * To avoid wasting memory headers on small allocations, we
 * allocate a big chunk and parcel it out as required.
 * These static variables remember our hunk.
 */

#define	STR_SPC	1024

static	char *	pnext = NULL;
static	int	bytes = 0;
   
char *
strsto(str)
char *str;
{
	int  len;
	char *p;
   
	/*
	 * What we need, including a null.
	 */
	len = strlen(str) + 1;

	if (len > bytes) {
		/*
		 * No space.  Allocate a new hunk.
		 * We lose the pointer to any old hunk.
		 * We don't care, as the names are never deleted.
		*/
		pnext = (char *) new (STR_SPC);
		bytes = STR_SPC;
		asmblk += 1;
	}

	/*
	 * Copy the name and terminating null.
	 */
	p = pnext;
	strcpy(p, str);

	pnext += len;
	bytes -= len;

	return(p);
}

/*)Function	char *	new(n)
 *
 *		unsigned int	n	allocation size in bytes
 *
 *	The function new() allocates n bytes of space and returns
 *	a pointer to this memory.  If no space is available the
 *	assembly is terminated.
 *
 *	local variables:
 *		memlnk *lnk		an allocation structure link
 *		VOID *	p		a general pointer
 *
 *	global variables:
 *		memlnk *asxmem		a linked list of allocation structures
 *
 *	functions called:
 *		VOID	asexit()	asmain.c
 *		int	fprintf()	c_library
 *		VOID *	malloc()	c_library
 *
 *	side effects:
 *		Memory is allocated, if allocation fails
 *		the assembly is terminated.  A linked
 *		memory allocation list is created to
 *		enable memory deallocation by asfree().
 */

char *
new(n)
unsigned int n;
{
	struct memlnk *lnk;
	VOID *p;

	if ((lnk = (struct memlnk *) malloc (sizeof(struct memlnk))) == NULL) {
		fprintf(stderr, "Out of space!\n");
		asexit(ER_FATAL);
	}
	lnk->next = (asxmem == NULL) ? NULL : asxmem;
	lnk->ptr = NULL;
	asxmem = lnk;

	if ((p = (VOID *) malloc (n)) == NULL) {
		fprintf(stderr, "Out of space!\n");
		asexit(ER_FATAL);
	}
	asxmem->ptr = p;
	return (p);
}

/*)Function	VOID	asfree()
 *
 *	The function asfree() frees all space allocated by new().
 *
 *	local variables:
 *		VOID *	p		a general pointer
 *
 *	global variables:
 *		memlnk *asxmem		a linked list of allocation structures
 *
 *	functions called:
 *		int	free()		c_library
 *
 *	side effects:
 *		Memory is freed.
 */

VOID
asfree()
{
	VOID *p;

	while (asxmem != NULL) {
		if ((p = asxmem->ptr) != NULL) {
			free(p);
		}
		p = (VOID *) asxmem;
		asxmem = asxmem->next;
		free(p);
	}
}

