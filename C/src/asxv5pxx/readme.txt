ASxxxx and ASlink V5.00 April 2009

   The  ASxxxx  assemblers are a series of microprocessor assem-
blers written in the C programming  language.   This  collection
contains  cross  assemblers  for the 1802, S2650, SC/MP, MPS430,
61860, 6500,  6800(6802/6808),  6801(6803/HD6303),  6804,  6805,
68HC(S)08,     6809,    68HC11,    68HC(S)12,    68HC16,    740,
8048(8041/8022/8021)  8051,  8085(8080),  DS8xCxxx,  AVR,  EZ80,
F2MC8L/FX,  GameBoy(Z80), H8/3xx, Cypress PSoC(M8C), PIC, Rabbit
2000/3000, Z8, and  Z80(HD64180)  series  microprocessors.   The
companion program ASLINK is a relocating linker  supporting  all
the cross assemblers.  ASLINK also supports object files created
with V4.xx and V3.xx assemblers.  The assemblers and linker have
been tested using Linux and  DJGPP, Cygwin, Symantec C/C++ V7.2,
Turbo C++ 3.0,  Open Watcom V1.7a,  VC6, and Visual Studio 2005.
Complete source code  and  documentation  for the assemblers and
linker is included with the  distribution.   Additionally,  test
code  for  each  assembler  and  several microprocessor monitors
(ASSIST05  for  the  6805,  MONDEB  and  ASSIST09  for the 6809,
and  BUFFALO 2.5 for the 6811) are included as  working examples
of use of these assemblers.  

asxv5p00.zip	ASxxxx and ASlink V5.00 Zipped

	MS-DOS:
	Windows:	unzip asxv5p00.zip		or
			pkunzip -d asxv5p00.zip
			unzips and restores directory structure

	Linux:		unzip -L -a asxv5p00.zip
			unzips to lower-case names and converts ascii
			files to \n from \r\n form.


Exectutables are in directories:

	Linux:		/asxv5pxx/asxmak/linux/exe/

	Cygwin:		\asxv5pxx\asxmak\cygwin\exe\

	DJGPP:		\asxv5pxx\asxmak\djgpp\exe\

	Symantec:	\asxv5pxx\asxmak\symantec\exe\

	TurboC:		\asxv5pxx\asxmak\TurboC30\exe\

	VC6:		\asxv5pxx\asxmak\vc6\exe\

	VS05:		\asxv5pxx\asxmak\vs05\exe\

	Watcom:		\asxv5pxx\asxmak\watcom\exe\


Makefiles or Build command files are in directories:

	Linux:		/asxv5pxx/asxmak/linux/build/

	Cygwin:		\asxv5pxx\asxmak\cygwin\build\

	DJGPP:		\asxv5pxx\asxmak\djgpp\build\

	Symantec:	\asxv5pxx\asxmak\symantec\build\

	TurboC:		\asxv5pxx\asxmak\TurboC30\build\

	VC6:		\asxv5pxx\asxmak\vc6\build\

	VS05:		\asxv5pxx\asxmak\vs05\build\

	Watcom:		\asxv5pxx\asxmak\watcom\build\


 Documentation in pdf form is
 	\asxv5pxx\asxhtml\asmlnk.pdf

 Documentation in plain text form is
 	\asxv5pxx\asxhtml\asmlnk.txt

 Documentation in HTML form may be found starting with
 	\asxv5pxx\asxhtml\asxxxx.htm


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
 */

