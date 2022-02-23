/*
 * Copyright 2016 by David Flamand <dflamand@gmail.com>
 *
 * This file is part of GCC6809.
 *
 * GCC6809 is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 *
 * GCC6809 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with GCC6809; see the file COPYING3.  If not see
 * <http://www.gnu.org/licenses/>.
 */

#ifndef _ZLIBARCH_H_
# ifdef ZLIBARCH
#  include <zlib.h>
#  define FGETS(str, size, stream) (gzgets((gzFile)(stream), (str), (size)))
#  define FSEEK(stream, offset, whence) ((long)(gzseek((gzFile)(stream), (z_off_t)(offset), (whence))<0?-1:0))
#  define FOPEN(path, mode) ((FILE*)gzopen((path), (mode)))
#  define FCLOSE(stream) (gzclose((gzFile)(stream))==Z_OK?0:-1)
#  define FTELL(stream) ((long)gztell((gzFile)(stream)))
#  define FEOF(stream) (gzeof((gzFile)(stream)))
#  define FERROR(stream) (_gzerror((gzFile)(stream)))
#  define FREAD(ptr, size, nmemb, stream) ((size_t)(gzread((gzFile)(stream), (ptr), (size)*(nmemb))/(size)))
#  define FWRITE(ptr, size, nmemb, stream) ((size_t)(gzwrite((gzFile)(stream), (ptr), (size)*(nmemb))/(size)))
#  define FPUTS(str, stream) (gzputs((gzFile)(stream), (str)))
#  define FPRINTF(stream, ...) (gzprintf((gzFile)(stream), __VA_ARGS__))
#  define FDOPEN(fd, mode) ((FILE*)gzdopen((fd), (mode)))
#  define FDIRECT(stream) (gzdirect((gzFile)(stream)))
#  if !defined(ZLIBARCH_STATIC) && !defined(ZLIBARCH_DEFINE)
extern int _gzerror(gzFile file);
#  endif
#  ifdef ZLIBARCH_STATIC
#   undef ZLIBARCH_STATIC
#   undef ZLIBARCH_DEFINE
#   define ZLIBARCH_STATIC static
#   define ZLIBARCH_DEFINE
#  else
#   define ZLIBARCH_STATIC
#  endif
#  ifdef ZLIBARCH_DEFINE
ZLIBARCH_STATIC int
_gzerror(file)
gzFile file;
{
	int errnum;
	gzerror(file, &errnum);
	return errnum < Z_OK;
}
#  endif
# else
#  define FGETS fgets
#  define FSEEK fseek
#  define FOPEN fopen
#  define FCLOSE fclose
#  define FTELL ftell
#  define FEOF feof
#  define FERROR ferror
#  define FREAD fread
#  define FWRITE fwrite
#  define FPUTS fputs
#  define FPRINTF fprintf
#  define FDOPEN fdopen
#  endif
#endif
