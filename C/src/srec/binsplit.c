/*
	BINSPLIT - Split a binary file into 2 or 4 interleaved pieces
	Copyright (C) 2010-2015  Anthony Goffart

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
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

#include "common.h"

#define HEADER1 "\nBINSPLIT " SREC_VER " - Split a binary file into 2 or 4 interleaved pieces.\n"

int verbose = true;
int num_files = 2;

char *infilename;
char *outfilename;

FILE *infile;

/***************************************************************************/

void write_file(FILE *outfile, int f)
{
	uint8_t bytes[4];
	int num;

	rewind(infile);

	for (;;)
	{
		num = fread(bytes, 1, num_files, infile);

		if (num > f)
			fwrite(&bytes[f], 1, 1, outfile);

		if (feof(infile))
				break;
	}
}

/***************************************************************************/

void process(void)
{
	int f;
	int len;
	char *filename, *ext;
	FILE *outfile;

	len = strlen(outfilename);

	if ((ext = strchr(outfilename, '.')))
	{
		*ext = '\0';
		fprintf(stderr, "Basename = '%s'\n", outfilename);
		fprintf(stderr, "Extension = '%s'\n", ++ext);
	}

	if ((filename = (char *)malloc(len+2)) == NULL)
	{
		fprintf(stderr, "Malloc failed\n");
		return;
	}

	for (f = 0; f < num_files; f++)
	{
		sprintf(filename, "%s%d", outfilename, f);

		if (ext)
		{
			strcat(filename, ".");
			strcat(filename, ext);
		}

		printf("Create file '%s'\n", filename);

		if ((outfile = fopen(filename, "wb")) == NULL)
		{
			fprintf(stderr, "Can't open output file '%s'\n", filename);
			break;
		}
		else
		{
			write_file(outfile, f);
			fclose(outfile);
		}
	}

	free(filename);
}

/***************************************************************************/

void syntax(void)
{
	fprintf(stderr, HEADER1);
	fprintf(stderr, HEADER2);
	fprintf(stderr, "Syntax: BINSPLIT <options> INFILE OUTFILE\n\n");
	fprintf(stderr, "-help            Show this help.\n");
	fprintf(stderr, "-2               create 2 output files (default)\n");
	fprintf(stderr, "-4               create 4 output files, not 2)\n");
	fprintf(stderr, "-q               Quiet mode\n");
}

/***************************************************************************/

int main(int argc, char *argv[])
{
	int i;

	for (i = 1; i < argc; i++)
	{
		if (!strcmp(argv[i], "-q"))
			verbose = false;

		else if (!strcmp(argv[i], "-2"))
			num_files = 2;

		else if (!strcmp(argv[i], "-4"))
			num_files = 4;

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
		process();
		fclose(infile);
		return(0);
	}
	else
	{
		printf("Input file %s not found\n", infilename);
		return(2);
	}
}

/***************************************************************************/
