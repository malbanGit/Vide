/*
	BIN2SREC  - Convert binary to Motorola S-Record file
	Copyright (C) 1998-2015  Anthony Goffart

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

#include "common.h"

#define HEADER1 "\nBIN2SREC " SREC_VER " - Convert binary to Motorola S-Record file.\n"

char *filename;
FILE *infile;

uint32_t addr_offset = 0;
uint32_t begin_addr;
uint32_t end_addr;
int addr_bytes = 2;
int do_headers = true;
int verbose = true;
int line_length = 32;


/***************************************************************************/

void syntax(void)
{
	fprintf(stderr, HEADER1);
	fprintf(stderr, HEADER2);
	fprintf(stderr, "Syntax: BIN2SREC <options> INFILE > OUTFILE\n\n");
	fprintf(stderr, "-help            Show this help.\n");
	fprintf(stderr, "-b <begin>       Address to begin at in binary file (hex), default = 0.\n");
	fprintf(stderr, "-e <end>         Address to end at in binary file (hex), default = end of file.\n");
	fprintf(stderr, "-o <offset>      Generated address offset (hex), default = begin address.\n");
	fprintf(stderr, "-a <addrsize>    Number of bytes used for address (2-4),\n");
	fprintf(stderr, "                  default = minimum needed for maximum address.\n");
	fprintf(stderr, "-l <linelength>  Number of bytes per line (8-32), default = 32.\n");
	fprintf(stderr, "-s               Suppress header and footer records.\n");
	fprintf(stderr, "-q               Quiet mode - no output except S-Record.\n");
}

/***************************************************************************/

void process(void)
{
	int i;
	uint32_t max_addr, address;
	int byte_count, this_line;
	unsigned char checksum;
	uint32_t c;
	int record_count = 0;

	unsigned char buf[32];

	max_addr = addr_offset + (end_addr - begin_addr);

	fseek(infile, begin_addr, SEEK_SET);

	if ((max_addr > 0xffffl) && (addr_bytes < 3))
		addr_bytes = 3;

	if ((max_addr > 0xffffffl) && (addr_bytes < 4))
		addr_bytes = 4;

	if (verbose)
	{
		fprintf(stderr, HEADER1);
		fprintf(stderr, HEADER2);
		fprintf(stderr, "Input binary file: %s\n", filename);
		fprintf(stderr, "Begin address   = %Xh\n", begin_addr);
		fprintf(stderr, "End address     = %Xh\n", end_addr);
		fprintf(stderr, "Address offset  = %Xh\n", addr_offset);
		fprintf(stderr, "Maximum address = %Xh\n", max_addr);
		fprintf(stderr, "Address bytes   = %d\n", addr_bytes);
	}

	if (do_headers)
		printf("S00600004844521B\n");		/* Header record */

	address = addr_offset;

	for (;;)
	{
		if (verbose)
			fprintf(stderr, "Processing %08Xh\r", address);

		this_line = min(line_length, (max_addr - address) + 1);
		byte_count = (addr_bytes + this_line + 1);
		printf("S%d%02X", addr_bytes - 1, byte_count);

		checksum = byte_count;

		for (i = addr_bytes - 1; i >= 0; i--)
		{
			c = (address >> (i << 3)) & 0xff;
			printf("%02X", c);
			checksum += c;
		}

		if(fread(buf, 1, this_line, infile));

		for (i = 0; i < this_line; i++)
		{
			printf("%02X", buf[i]);
			checksum += buf[i];
		}

		printf("%02X\n", 255 - checksum);

		record_count++;

		/* check before adding to allow for finishing at 0xffffffff */
		if ((address - 1 + line_length) >= max_addr)
			break;

		address += line_length;
	}

	if (do_headers)
	{
		if (record_count > 0xffff)
		{
			checksum = 4 + (record_count & 0xff) + ((record_count >> 8) & 0xff) + ((record_count >> 16) & 0xff);
			printf("S604%06X%02X\n", record_count, 255 - checksum);
		}
		else
		{
			checksum = 3 + (record_count & 0xff) + ((record_count >> 8) & 0xff);
			printf("S503%04X%02X\n", record_count, 255 - checksum);
		}

		byte_count = (addr_bytes + 1);
		printf("S%d%02X", 11 - addr_bytes, byte_count);

		checksum = byte_count;

		for (i = addr_bytes - 1; i >= 0; i--)
		{
			c = (addr_offset >> (i << 3)) & 0xff;
			printf("%02X", c);
			checksum += c;
		}
		printf("%02X\n", 255 - checksum);
	}

	if (verbose)
		fprintf(stderr, "Processing complete \n");
}

/***************************************************************************/

int main(int argc, char *argv[])
{
	int i;
	uint32_t size;
	int offset_specified = false;
	int end_specified = false;

	for (i = 1; i < argc; i++)
	{
		if (!strcmp(argv[i], "-o"))
		{
			addr_offset = str_to_uint32(argv[++i]);
			offset_specified = true;
			continue;
		}

		else if (!strcmp(argv[i], "-b"))
		{
			begin_addr = str_to_uint32(argv[++i]);
			continue;
		}

		else if (!strcmp(argv[i], "-e"))
		{
			end_addr = str_to_uint32(argv[++i]);
			end_specified = true;
			continue;
		}

		else if (!strcmp(argv[i], "-a"))
		{
			sscanf(argv[++i], "%d", &addr_bytes);
			addr_bytes = max(2, addr_bytes);
			addr_bytes = min(4, addr_bytes);
			continue;
		}

		else if (!strcmp(argv[i], "-l"))
		{
			sscanf(argv[++i], "%d", &line_length);
			line_length = max(8, line_length);
			line_length = min(32, line_length);
			continue;
		}

		else if (!strcmp(argv[i], "-s"))
		{
			do_headers = false;
			continue;
		}

		else if (!strcmp(argv[i], "-q"))
		{
			verbose = false;
			continue;
		}

		else if (!strncmp(argv[i], "-h", 2))		 /* -h or -help */
		{
			syntax();
			return(0);
		}

		else
		{
			filename = argv[i];
		}
	}

	if (filename == NULL)
	{
		syntax();
		fprintf(stderr, "\n** No input filename specified\n");
		return(1);
	}

	if ((infile = fopen(filename, "rb")) != NULL)
	{
		size = file_size(infile) - 1;

		if (end_specified)
			end_addr = min(size, end_addr);
		else
			end_addr = size;

		if (begin_addr > size)
		{
			fprintf(stderr, "Begin address %Xh is greater than file size %Xh\n", begin_addr, size);
			return(3);
		}

		if (end_addr < begin_addr)
		{
			fprintf(stderr, "End address %Xh is less than begin address %Xh\n", end_addr, begin_addr);
			return(3);
		}

		if (!offset_specified)
			addr_offset = begin_addr;

		process();
		fclose(infile);
		return(0);
	}
	else
	{
		fprintf(stderr, "Input file %s not found\n", filename);
		return(2);
	}
}

/***************************************************************************/
