/*
	common.c - Common functions for both srec2bin and bin2srec
	Copyright (C) 1998-2015  Anthony Goffart

	This file is part of SREC2BIN and BIN2SREC

	BIN2SREC and SREC2BIN are free software: you can redistribute them
	and/or modify them under the terms of the GNU General Public License
	as published by the Free Software Foundation, either version 3
	of the License, or (at your option) any later version.

	BIN2SREC and SREC2BIN are distributed in the hope that they will be
	useful, but WITHOUT ANY WARRANTY; without even the implied warranty
	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
	See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along
	with BIN2SREC and SREC2BIN. If not, see <http://www.gnu.org/licenses/>.
*/

#include <sys/stat.h>
#include "common.h"

/***************************************************************************/

unsigned int char_to_uint(char c)
{
	int res = 0;

	if (c >= '0' && c <= '9')
		res = (c - '0');
	else if (c >= 'A' && c <= 'F')
		res = (c - 'A' + 10);
	else if (c >= 'a' && c <= 'f')
		res = (c - 'a' + 10);

	return(res);
}

/***************************************************************************/

uint32_t str_to_uint32(char *s)
{
	int i;
	char c;
	uint32_t res = 0;

	for (i = 0; (i < 8) && (s[i] != '\0'); i++)
	{
		c = s[i];
		res <<= 4;
		res += char_to_uint(c);
	}

	return(res);
}

/***************************************************************************/

uint32_t file_size(FILE *f)
{
	struct stat info;

	if (!fstat(fileno(f), &info))
		return((uint32_t)info.st_size);
	else
		return(0);
}

/***************************************************************************/
