/*
	SREC2BIN - Convert Motorola S-Record to binary file
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

#define HEADER1 "\nSREC2BIN " SREC_VER " - Convert Motorola S-Record to binary file.\n"

#define LINE_LEN 1024

char *infilename;
char *outfilename;
FILE *infile, *outfile;

uint32_t max_addr = 0;
uint32_t min_addr = 0;

uint8_t filler = 0xff;
int verbose = true;

/***************************************************************************/

void syntax(void)
{
	fprintf(stderr, HEADER1);
	fprintf(stderr, HEADER2);
	fprintf(stderr, "Syntax: SREC2BIN <options> INFILE OUTFILE\n\n");
	fprintf(stderr, "-help            Show this help.\n");
	fprintf(stderr, "-o <offset>      Start address offset (hex), default = 0.\n");
	fprintf(stderr, "-a <addrsize>    Minimum binary file size (hex), default = 0.\n");
	fprintf(stderr, "-f <fillbyte>    Filler byte (hex), default = FF.\n");
	fprintf(stderr, "-q               Quiet mode\n");
}

/***************************************************************************/

void parse(int scan, uint32_t *max, uint32_t *min)
{
	int i, j;
	char line[LINE_LEN] = "";
	uint32_t address;
	int rec_type, addr_bytes, byte_count;
	uint8_t c;
	uint8_t buf[32];

	do
	{
		if(fgets(line, LINE_LEN, infile));

		if (line[0] == 'S')								/* an S-record */
		{
			rec_type = line[1] - '0';

			if ((rec_type >= 1) && (rec_type <= 3))		/* data record */
			{
				address = 0;
				addr_bytes = rec_type + 1;

				for (i = 4; i < (addr_bytes * 2) + 4; i++)
				{
					c = line[i];
					address <<= 4;
					address += char_to_uint(c);
				}

				byte_count = (char_to_uint(line[2]) << 4) + char_to_uint(line[3]);
				byte_count -= (addr_bytes + 1);

				if (scan)
				{
					if (*min > address)
						*min = address;

					if (*max < (address + (byte_count - 1)))
						*max = address + (byte_count - 1);
				}
				else
				{
					address -= min_addr;

					if (verbose)
						fprintf(stderr, "Writing %d bytes at %08X\r", byte_count, address);

					j = 0;
					for (i = (addr_bytes * 2) + 4; i < (addr_bytes * 2) + (byte_count * 2) + 4; i += 2)
					{
						buf[j] = (char_to_uint(line[i]) << 4) + char_to_uint(line[i+1]);
						j++;
					}
					fseek(outfile, address, SEEK_SET);
					fwrite(buf, 1, byte_count, outfile);
				}
			}
		}
	}
	while(!feof(infile));

	rewind(infile);
}

/***************************************************************************/

int process(void)
{
	uint32_t i;
	uint32_t blocks, remain;
	uint32_t pmax = 0;
	uint32_t pmin = 0xffffffff;

	uint8_t buf[32];

	if (verbose)
	{
		fprintf(stderr, HEADER1);
		fprintf(stderr, HEADER2);
		fprintf(stderr, "Input Motorola S-Record file: %s\n", infilename);
		fprintf(stderr, "Output binary file: %s\n", outfilename);
	}

	parse(true, &pmax, &pmin);

	min_addr = min(min_addr, pmin);
	max_addr = max(pmax, min_addr + max_addr);

	blocks = (max_addr - min_addr + 1) / 32;
	remain = (max_addr - min_addr + 1) % 32;

	if (verbose)
	{
		fprintf(stderr, "Minimum address  = %Xh\n", min_addr);
		fprintf(stderr, "Maximum address  = %Xh\n", max_addr);
		i = max_addr - min_addr + 1;
		fprintf(stderr, "Binary file size = %d (%Xh) bytes.\n", i, i);
	}

	if ((outfile = fopen(outfilename, "wb")) != NULL)
	{
		for (i = 0; i < 32; i++)
			buf[i] = filler;
		for (i = 0; i < blocks; i++)
			fwrite(buf, 1, 32, outfile);
		fwrite(buf, 1, remain, outfile);

		parse(false, &pmax, &pmin);
		fclose(outfile);
	}
	else
	{
		fprintf(stderr, "Cant create output file %s.\n", outfilename);
		return(1);
	}

	if (verbose)
		fprintf(stderr, "Processing complete          \n");

	return(0);
}

/***************************************************************************/

int main(int argc, char *argv[])
{
	int i;
	int result = 0;

	for (i = 1; i < argc; i++)
	{
		if (!strcmp(argv[i], "-q"))
			verbose = false;

		else if (!strcmp(argv[i], "-a"))
			max_addr = str_to_uint32(argv[++i]) - 1;

		else if (!strcmp(argv[i], "-o"))
			min_addr = str_to_uint32(argv[++i]);

		else if (!strcmp(argv[i], "-f"))
			filler = str_to_uint32(argv[++i]) & 0xff;

		else if (!strncmp(argv[i], "-h", 2))			/* -h or -help */
		{
			syntax();
			return(0);
		}
		else
		{
			infilename = argv[i];
			outfilename = argv[++i];
		}
	}

	if (infilename == NULL)
	{
		syntax();
		fprintf(stderr, "\n** No input filename specified\n");
		return(1);
	}

	if (outfilename == NULL)
	{
		syntax();
		fprintf(stderr, "\n** No output filename specified\n");
		return(1);
	}

	if ((infile = fopen(infilename, "rb")) != NULL)
	{
		result = process();
		fclose(infile);
		return(result);
	}
	else
	{
		printf("Input file %s not found\n", infilename);
		return(2);
	}
}

/***************************************************************************/
