For more information, visit the website at http://www.s-record.com/


BIN2SREC
--------

V1.01   First revision

V1.10   Allows the user to select part of the file - i.e. specify a start and
        end address.

V1.11   Makefile mofified and GNU licence added.



SREC2BIN
--------
V1.01   First revision

V1.10   Ignores S0 records with misc information which caused errors.
        Ignores lines which don't contain data records.
        Added an option to change the default FF filler byte.
        An offset can be specified.

V1.11   Makefile mofified and GNU licence added.

Combined
--------

V1.20   Makefiles merged and minor bug fixes.
V1.21   Builds under Linux with no modifications

V1.30   Added binsplit

V1.40   Fixed bin2srec ending on address 0xFFFFFFFF
V1.41   Fixed spelling errors
V1.42   Changed return code from srec2bin if output file fails to be created
V1.43   Use S6 instead of S5 count record when record count is greater than 65535
V1.44   Use <stdbool.h> for boolean types (not published)
V1.45   Fix compiler warnings for ignored return values (not published)
V1.46   Fix srec2bin creation when last address is 0xFFFFFFFFF

The utilities now compile using the free MinGW GNU based tools
as well as GCC under Linux using Gnu Make.

This software is provided under the terms of the GNU General Public Licence.
See the enclosed file gpl-3.0.txt

Ant Goffart
January 2015
