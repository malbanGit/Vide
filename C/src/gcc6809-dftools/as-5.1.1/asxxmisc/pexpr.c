/* pexpr.c */

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

/*)Module	pexpr.c
 *
 *	pexpr.c contains no local/static variables
 */

/*)Function	VOID	pexpr(esp)
 *
 *		expr *	esp		pointer to expression structure
 *
 *	The function pexpr() prints the values of the expression structure.
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
 
VOID
pexpr(esp)
struct expr *esp;
{
	printf("%s\r\n", "printexpr() {");
	printf("    e_mode   =       %2.2X\r\n", esp->e_mode);
	printf("    e_flag   =       %2.2X\r\n", esp->e_flag);
	printf("    e_addr   = %8.8X\r\n", esp->e_addr);
	printf("    e_base{} = %8.8X\r\n", (a_uint) esp->e_base.e_ap);
	printf("    e_rlcf   =       %2.2X\r\n", esp->e_rlcf);
	printf("};\r\n");
}

