;  TPIC18CX.ASM - Test file for ASPIC assembler
;
;  Assemble and Link:
;	aspic -gloaxff tpic18cx
;	asxscn -4 tpic18cx.lst
;	aslink -nxu -g extaddr=0 -g exlbl6=0 -g exlbl7=0 tpic18cx
;	asxscn -i4 tpic18cx.rst
;

 	.include	"tpic18cx.def"

	.area	DATA

	fcode =		1
	wcode =		0

	num0 =		0
	num7 =		7

	num1 =		1

	.area	CODE

	addr_00	=	. + 0x00
	addr_0FFFFF =	. + 0x0fffff

	nop			; 00 00

	sleep			; 03 00
	clrwdt			; 04 00

	push			; 05 00
	pop			; 06 00

	daw			; 07 00

	tblrd			; 08 00
	tblrd*			; 08 00
	tblrd*+			; 09 00
	tblrd*-			; 0A 00
	tblrd+*			; 0B 00

	tblwt			; 0C 00
	tblwt*			; 0C 00
	tblwt*+			; 0D 00
	tblwt*-			; 0E 00
	tblwt+*			; 0F 00

	retfie			; 10 00
	return			; 12 00

	;
	; First of Type S_F Instructions
	; Comprehensive Testing
	;
	; Constant Addressing ==>> 'Data Memory Map' Addressing
	;	Absolute addresses 0x00-0x7F and 0xF80-0xFFF are always
	;	'access bank' mapped when the 'a' parameter is blank.
	;	Additional bank address	checking is performed by the linker.
	;
	movlb	0x0F		; 0F 01
.setdmm	0x0F*0x100,DATA
	mulwf	0x00		; 00 02
	mulwf	0x7F		; 7F 02

	movlb	0x00		; 00 01
.setdmm	0x00*0x100,DATA
	mulwf	0x00		; 00 02
	mulwf	0x7F		; 7F 02
	mulwf	0x80		;*80n03
	mulwf	0xFF		;*FFn03

	movlb	0x01		; 01 01
.setdmm	0x01*0x100,DATA
	mulwf	0x100		;*00n03
	mulwf	0x17F		;*7Fn03
	mulwf	0x180		;*80n03
	mulwf	0x1FF		;*FFn03

	movlb	0x02		; 02 01
.setdmm	0x02*0x100,DATA
	mulwf	0x200		;*00n03
	mulwf	0x27F		;*7Fn03
	mulwf	0x280		;*80n03
	mulwf	0x2FF		;*FFn03

	movlb	0x03		; 03 01
.setdmm	0x03*0x100,DATA
	mulwf	0x300		;*00n03
	mulwf	0x37F		;*7Fn03
	mulwf	0x380		;*80n03
	mulwf	0x3FF		;*FFn03

	movlb	0x04		; 04 01
.setdmm	0x04*0x100,DATA
	mulwf	0x400		;*00n03
	mulwf	0x47F		;*7Fn03
	mulwf	0x480		;*80n03
	mulwf	0x4FF		;*FFn03

	movlb	0x05		; 05 01
.setdmm	0x05*0x100,DATA
	mulwf	0x500		;*00n03
	mulwf	0x57F		;*7Fn03
	mulwf	0x580		;*80n03
	mulwf	0x5FF		;*FFn03

	movlb	0x06		; 06 01
.setdmm	0x06*0x100,DATA
	mulwf	0x600		;*00n03
	mulwf	0x67F		;*7Fn03
	mulwf	0x680		;*80n03
	mulwf	0x6FF		;*FFn03

	movlb	0x07		; 07 01
.setdmm	0x07*0x100,DATA
	mulwf	0x700		;*00n03
	mulwf	0x77F		;*7Fn03
	mulwf	0x780		;*80n03
	mulwf	0x7FF		;*FFn03

	movlb	0x08		; 08 01
.setdmm	0x08*0x100,DATA
	mulwf	0x800		;*00n03
	mulwf	0x87F		;*7Fn03
	mulwf	0x880		;*80n03
	mulwf	0x8FF		;*FFn03

	movlb	0x09		; 09 01
.setdmm	0x09*0x100,DATA
	mulwf	0x900		;*00n03
	mulwf	0x97F		;*7Fn03
	mulwf	0x980		;*80n03
	mulwf	0x9FF		;*FFn03

	movlb	0x0A		; 0A 01
.setdmm	0x0A*0x100,DATA
	mulwf	0xA00		;*00n03
	mulwf	0xA7F		;*7Fn03
	mulwf	0xA80		;*80n03
	mulwf	0xAFF		;*FFn03

	movlb	0x0B		; 0B 01
.setdmm	0x0B*0x100,DATA
	mulwf	0xB00		;*00n03
	mulwf	0xB7F		;*7Fn03
	mulwf	0xB80		;*80n03
	mulwf	0xBFF		;*FFn03

	movlb	0x0C		; 0C 01
.setdmm	0x0C*0x100,DATA
	mulwf	0xC00		;*00n03
	mulwf	0xC7F		;*7Fn03
	mulwf	0xC80		;*80n03
	mulwf	0xCFF		;*FFn03

	movlb	0x0D		; 0D 01
.setdmm	0x0D*0x100,DATA
	mulwf	0xD00		;*00n03
	mulwf	0xD7F		;*7Fn03
	mulwf	0xD80		;*80n03
	mulwf	0xDFF		;*FFn03

	movlb	0x0E		; 0E 01
.setdmm	0x0E*0x100,DATA
	mulwf	0xE00		;*00n03
	mulwf	0xE7F		;*7Fn03
	mulwf	0xE80		;*80n03
	mulwf	0xEFF		;*FFn03

	movlb	0x0F		; 0F 01
.setdmm	0x0F*0x100,DATA
	mulwf	0xF00		;*00n03
	mulwf	0xF7F		;*7Fn03
	mulwf	0xF80		; 80 02
	mulwf	0xFFF		; FF 02

	movlb	0x00		; 00 01
.setdmm	0x00*0x100,DATA
	mulwf	0xF80		; 80 02
	mulwf	0xFFF		; FF 02

	;
	; 'Data Memory Map' Addressing.
	;	Absolute addresses 0x00-0x7F and 0xF80-0xFFF are always
	;	'access bank' mapped when the 'a' parameter is blank.
	;	Additional bank address	checking is performed by the linker.
	;
	movlb	0x0F		; 0F 01
.setdmm	0x0F*0x100,DATA
	mulwf	*0x00		; 00 02
	mulwf	*0x7F		; 7F 02

	movlb	0x00		; 00 01
.setdmm	0x00*0x100,DATA
	mulwf	*0x00		; 00 02
	mulwf	*0x7F		; 7F 02
	mulwf	*0x80		;*80n03
	mulwf	*0xFF		;*FFn03

	movlb	0x01		; 01 01
.setdmm	0x01*0x100,DATA
	mulwf	*0x100		;*00n03
	mulwf	*0x17F		;*7Fn03
	mulwf	*0x180		;*80n03
	mulwf	*0x1FF		;*FFn03

	movlb	0x02		; 02 01
.setdmm	0x02*0x100,DATA
	mulwf	*0x200		;*00n03
	mulwf	*0x27F		;*7Fn03
	mulwf	*0x280		;*80n03
	mulwf	*0x2FF		;*FFn03

	movlb	0x03		; 03 01
.setdmm	0x03*0x100,DATA
	mulwf	*0x300		;*00n03
	mulwf	*0x37F		;*7Fn03
	mulwf	*0x380		;*80n03
	mulwf	*0x3FF		;*FFn03

	movlb	0x04		; 04 01
.setdmm	0x04*0x100,DATA
	mulwf	*0x400		;*00n03
	mulwf	*0x47F		;*7Fn03
	mulwf	*0x480		;*80n03
	mulwf	*0x4FF		;*FFn03

	movlb	0x05		; 05 01
.setdmm	0x05*0x100,DATA
	mulwf	*0x500		;*00n03
	mulwf	*0x57F		;*7Fn03
	mulwf	*0x580		;*80n03
	mulwf	*0x5FF		;*FFn03

	movlb	0x06		; 06 01
.setdmm	0x06*0x100,DATA
	mulwf	*0x600		;*00n03
	mulwf	*0x67F		;*7Fn03
	mulwf	*0x680		;*80n03
	mulwf	*0x6FF		;*FFn03

	movlb	0x07		; 07 01
.setdmm	0x07*0x100,DATA
	mulwf	*0x700		;*00n03
	mulwf	*0x77F		;*7Fn03
	mulwf	*0x780		;*80n03
	mulwf	*0x7FF		;*FFn03

	movlb	0x08		; 08 01
.setdmm	0x08*0x100,DATA
	mulwf	*0x800		;*00n03
	mulwf	*0x87F		;*7Fn03
	mulwf	*0x880		;*80n03
	mulwf	*0x8FF		;*FFn03

	movlb	0x09		; 09 01
.setdmm	0x09*0x100,DATA
	mulwf	*0x900		;*00n03
	mulwf	*0x97F		;*7Fn03
	mulwf	*0x980		;*80n03
	mulwf	*0x9FF		;*FFn03

	movlb	0x0A		; 0A 01
.setdmm	0x0A*0x100,DATA
	mulwf	*0xA00		;*00n03
	mulwf	*0xA7F		;*7Fn03
	mulwf	*0xA80		;*80n03
	mulwf	*0xAFF		;*FFn03

	movlb	0x0B		; 0B 01
.setdmm	0x0B*0x100,DATA
	mulwf	*0xB00		;*00n03
	mulwf	*0xB7F		;*7Fn03
	mulwf	*0xB80		;*80n03
	mulwf	*0xBFF		;*FFn03

	movlb	0x0C		; 0C 01
.setdmm	0x0C*0x100,DATA
	mulwf	*0xC00		;*00n03
	mulwf	*0xC7F		;*7Fn03
	mulwf	*0xC80		;*80n03
	mulwf	*0xCFF		;*FFn03

	movlb	0x0D		; 0D 01
.setdmm	0x0D*0x100,DATA
	mulwf	*0xD00		;*00n03
	mulwf	*0xD7F		;*7Fn03
	mulwf	*0xD80		;*80n03
	mulwf	*0xDFF		;*FFn03

	movlb	0x0E		; 0E 01
.setdmm	0x0E*0x100,DATA
	mulwf	*0xE00		;*00n03
	mulwf	*0xE7F		;*7Fn03
	mulwf	*0xE80		;*80n03
	mulwf	*0xEFF		;*FFn03

	movlb	0x0F		; 0F 01
.setdmm	0x0F*0x100,DATA
	mulwf	*0xF00		;*00n03
	mulwf	*0xF7F		;*7Fn03
	mulwf	*0xF80		; 80 02
	mulwf	*0xFFF		; FF 02

	movlb	0x00		; 00 01
.setdmm	0x00*0x100,DATA
	mulwf	*0xF80		; 80 02
	mulwf	*0xFFF		; FF 02

	; Constant Addressing ==>> 'Data Memory Map' Addressing
	;	Absolute addresses 0x00-0x7F and 0xF80-0xFFF are
	;	not automatically 'access bank' mapped when the
	;	'a' parameter is specified.  An absolute address
	;	of 0x080-0xF7F with an 'a' parameter of value '0'
	;	will report an 'a' error.  Additional address
	;	checking is performed by the linker.
	;
	movlb	0x00		; 00 01
.setdmm	0x00*0x100,DATA
	mulwf	0x00,1		;*00n03
	mulwf	0x7F,1		;*7Fn03

	movlb	0x00		; 00 01
.setdmm	0x00*0x100,DATA
	mulwf	0x00,1		;*00n03
	mulwf	0x7F,1		;*7Fn03
	mulwf	0x80,1		;*80n03
	mulwf	0xFF,1		;*FFn03

	movlb	0x01		; 01 01
.setdmm	0x01*0x100,DATA
	mulwf	0x100,1		;*00n03
	mulwf	0x17F,1		;*7Fn03
	mulwf	0x180,1		;*80n03
	mulwf	0x1FF,1		;*FFn03

	movlb	0x02		; 02 01
.setdmm	0x02*0x100,DATA
	mulwf	0x200,1		;*00n03
	mulwf	0x27F,1		;*7Fn03
	mulwf	0x280,1		;*80n03
	mulwf	0x2FF,1		;*FFn03

	movlb	0x03		; 03 01
.setdmm	0x03*0x100,DATA
	mulwf	0x300,1		;*00n03
	mulwf	0x37F,1		;*7Fn03
	mulwf	0x380,1		;*80n03
	mulwf	0x3FF,1		;*FFn03

	movlb	0x04		; 04 01
.setdmm	0x04*0x100,DATA
	mulwf	0x400,1		;*00n03
	mulwf	0x47F,1		;*7Fn03
	mulwf	0x480,1		;*80n03
	mulwf	0x4FF,1		;*FFn03

	movlb	0x05		; 05 01
.setdmm	0x05*0x100,DATA
	mulwf	0x500,1		;*00n03
	mulwf	0x57F,1		;*7Fn03
	mulwf	0x580,1		;*80n03
	mulwf	0x5FF,1		;*FFn03

	movlb	0x06		; 06 01
.setdmm	0x06*0x100,DATA
	mulwf	0x600,1		;*00n03
	mulwf	0x67F,1		;*7Fn03
	mulwf	0x680,1		;*80n03
	mulwf	0x6FF,1		;*FFn03

	movlb	0x07		; 07 01
.setdmm	0x07*0x100,DATA
	mulwf	0x700,1		;*00n03
	mulwf	0x77F,1		;*7Fn03
	mulwf	0x780,1		;*80n03
	mulwf	0x7FF,1		;*FFn03

	movlb	0x08		; 08 01
.setdmm	0x08*0x100,DATA
	mulwf	0x800,1		;*00n03
	mulwf	0x87F,1		;*7Fn03
	mulwf	0x880,1		;*80n03
	mulwf	0x8FF,1		;*FFn03

	movlb	0x09		; 09 01
.setdmm	0x09*0x100,DATA
	mulwf	0x900,1		;*00n03
	mulwf	0x97F,1		;*7Fn03
	mulwf	0x980,1		;*80n03
	mulwf	0x9FF,1		;*FFn03

	movlb	0x0A		; 0A 01
.setdmm	0x0A*0x100,DATA
	mulwf	0xA00,1		;*00n03
	mulwf	0xA7F,1		;*7Fn03
	mulwf	0xA80,1		;*80n03
	mulwf	0xAFF,1		;*FFn03

	movlb	0x0B		; 0B 01
.setdmm	0x0B*0x100,DATA
	mulwf	0xB00,1		;*00n03
	mulwf	0xB7F,1		;*7Fn03
	mulwf	0xB80,1		;*80n03
	mulwf	0xBFF,1		;*FFn03

	movlb	0x0C		; 0C 01
.setdmm	0x0C*0x100,DATA
	mulwf	0xC00,1		;*00n03
	mulwf	0xC7F,1		;*7Fn03
	mulwf	0xC80,1		;*80n03
	mulwf	0xCFF,1		;*FFn03

	movlb	0x0D		; 0D 01
.setdmm	0x0D*0x100,DATA
	mulwf	0xD00,1		;*00n03
	mulwf	0xD7F,1		;*7Fn03
	mulwf	0xD80,1		;*80n03
	mulwf	0xDFF,1		;*FFn03

	movlb	0x0E		; 0E 01
.setdmm	0x0E*0x100,DATA
	mulwf	0xE00,1		;*00n03
	mulwf	0xE7F,1		;*7Fn03
	mulwf	0xE80,1		;*80n03
	mulwf	0xEFF,1		;*FFn03

	movlb	0x0F		; 0F 01
.setdmm	0x0F*0x100,DATA
	mulwf	0xF00,1		;*00n03
	mulwf	0xF7F,1		;*7Fn03
	mulwf	0xF80,1		;*80n03
	mulwf	0xFFF,1		;*FFn03

	movlb	0x00		; 00 01
.setdmm	0x00*0x100,DATA

	;
	; 'Data Memory Map' Addressing.
	;	Absolute addresses 0x00-0x7F and 0xF80-0xFFF are
	;	not automatically 'access bank' mapped when the
	;	'a' parameter is specified.  An absolute address
	;	of 0x080-0xF7F with an 'a' parameter of value '0'
	;	will report an 'a' error.  Additional bank address
	;	checking is performed by the linker.
	;
	;
	movlb	0x00		; 00 01
.setdmm	0x00*0x100,DATA
	mulwf	*0x00,1		;*00n03
	mulwf	*0x7F,1		;*7Fn03

	mulwf	*0x00,1		;*00n03
	mulwf	*0x7F,1		;*7Fn03
	mulwf	*0x80,1		;*80n03
	mulwf	*0xFF,1		;*FFn03

	movlb	0x01		; 01 01
.setdmm	0x01*0x100,DATA
	mulwf	*0x100,1	;*00n03
	mulwf	*0x17F,1	;*7Fn03
	mulwf	*0x180,1	;*80n03
	mulwf	*0x1FF,1	;*FFn03

	movlb	0x02		; 02 01
.setdmm	0x02*0x100,DATA
	mulwf	*0x200,1	;*00n03
	mulwf	*0x27F,1	;*7Fn03
	mulwf	*0x280,1	;*80n03
	mulwf	*0x2FF,1	;*FFn03

	movlb	0x03		; 03 01
.setdmm	0x03*0x100,DATA
	mulwf	*0x300,1	;*00n03
	mulwf	*0x37F,1	;*7Fn03
	mulwf	*0x380,1	;*80n03
	mulwf	*0x3FF,1	;*FFn03

	movlb	0x04		; 04 01
.setdmm	0x04*0x100,DATA
	mulwf	*0x400,1	;*00n03
	mulwf	*0x47F,1	;*7Fn03
	mulwf	*0x480,1	;*80n03
	mulwf	*0x4FF,1	;*FFn03

	movlb	0x05		; 05 01
.setdmm	0x05*0x100,DATA
	mulwf	*0x500,1	;*00n03
	mulwf	*0x57F,1	;*7Fn03
	mulwf	*0x580,1	;*80n03
	mulwf	*0x5FF,1	;*FFn03

	movlb	0x06		; 06 01
.setdmm	0x06*0x100,DATA
	mulwf	*0x600,1	;*00n03
	mulwf	*0x67F,1	;*7Fn03
	mulwf	*0x680,1	;*80n03
	mulwf	*0x6FF,1	;*FFn03

	movlb	0x07		; 07 01
.setdmm	0x07*0x100,DATA
	mulwf	*0x700,1	;*00n03
	mulwf	*0x77F,1	;*7Fn03
	mulwf	*0x780,1	;*80n03
	mulwf	*0x7FF,1	;*FFn03

	movlb	0x08		; 08 01
.setdmm	0x08*0x100,DATA
	mulwf	*0x800,1	;*00n03
	mulwf	*0x87F,1	;*7Fn03
	mulwf	*0x880,1	;*80n03
	mulwf	*0x8FF,1	;*FFn03

	movlb	0x09		; 09 01
.setdmm	0x09*0x100,DATA
	mulwf	*0x900,1	;*00n03
	mulwf	*0x97F,1	;*7Fn03
	mulwf	*0x980,1	;*80n03
	mulwf	*0x9FF,1	;*FFn03

	movlb	0x0A		; 0A 01
.setdmm	0x0A*0x100,DATA
	mulwf	*0xA00,1	;*00n03
	mulwf	*0xA7F,1	;*7Fn03
	mulwf	*0xA80,1	;*80n03
	mulwf	*0xAFF,1	;*FFn03

	movlb	0x0B		; 0B 01
.setdmm	0x0B*0x100,DATA
	mulwf	*0xB00,1	;*00n03
	mulwf	*0xB7F,1	;*7Fn03
	mulwf	*0xB80,1	;*80n03
	mulwf	*0xBFF,1	;*FFn03

	movlb	0x0C		; 0C 01
.setdmm	0x0C*0x100,DATA
	mulwf	*0xC00,1	;*00n03
	mulwf	*0xC7F,1	;*7Fn03
	mulwf	*0xC80,1	;*80n03
	mulwf	*0xCFF,1	;*FFn03

	movlb	0x0D		; 0D 01
.setdmm	0x0D*0x100,DATA
	mulwf	*0xD00,1	;*00n03
	mulwf	*0xD7F,1	;*7Fn03
	mulwf	*0xD80,1	;*80n03
	mulwf	*0xDFF,1	;*FFn03

	movlb	0x0E		; 0E 01
.setdmm	0x0E*0x100,DATA
	mulwf	*0xE00,1	;*00n03
	mulwf	*0xE7F,1	;*7Fn03
	mulwf	*0xE80,1	;*80n03
	mulwf	*0xEFF,1	;*FFn03

	movlb	0x0F		; 0F 01
.setdmm	0x0F*0x100,DATA
	mulwf	*0xF00,1	;*00n03
	mulwf	*0xF7F,1	;*7Fn03
	mulwf	*0xF80,1	;*80n03
	mulwf	*0xFFF,1	;*FFn03

	mulwf	*0xF80,1	;*80n03
	mulwf	*0xFFF,1	;*FFn03

	movlb	0x00		; 00 01
.setdmm	0x00*0x100,DATA

	;
	; External Addressing ==>> 'Data Memory Map' Addressing
	;
	mulwf	extaddr		;*00n03
	mulwf	*extaddr	;*00n03

	mulwf	extaddr,0	;r00s02
	mulwf	*extaddr,0	;r00s02

	mulwf	extaddr,1	;*00n03
	mulwf	*extaddr,1	;*00n03

	movwf	0x00		; 00 6E
	movwf	0x7F		; 7F 6E
	movwf	0x80		;*80n6F
	movwf	0xF80		; 80 6E
	movwf	0xFFF		; FF 6E
	movwf	extaddr		;*00n6F

	movwf	*0x00		; 00 6E
	movwf	*0x7F		; 7F 6E
	movwf	*0x80		;*80n6F
.setdmm	0xF00,DATA
	movwf	*0xF7F		;*7Fn6F
.setdmm	0x000,DATA
	movwf	*0xF80		; 80 6E
	movwf	*0xFFF		; FF 6E
	movwf	*extaddr	;*00n6F

	subwfb	0x00,w		; 00 58
	subwfb	0xFF,w		;*FFn59
	subwfb	0xFFF,w		; FF 58
	subwfb	extaddr,w	;*00n59

	subwfb	0x00,f		; 00 5A
	subwfb	0xFFF,f		; FF 5A
	subwfb	0xFF,f		;*FFn5B
	subwfb	extaddr,f	;*00n5B

	subwfb	*0x00,w		; 00 58
	subwfb	*0xFFF,w	; FF 58
	subwfb	*0xFF,w		;*FFn59
	subwfb	*extaddr,w	;*00n59

	subwfb	*0x00,f		; 00 5A
	subwfb	*0xFFF,f	; FF 5A
	subwfb	*0xFF,f		;*FFn5B
	subwfb	*extaddr,f	;*00n5B

	subwfb	0x00,0		; 00 58
	subwfb	*0x00,0		; 00 58
	subwfb	extaddr,0	;*00n59
	subwfb	*extaddr,0	;*00n59
	subwfb	0x00,#0		; 00 58
	subwfb	*0x00,#0	; 00 58
	subwfb	extaddr,#0	;*00n59
	subwfb	*extaddr,#0	;*00n59
	subwfb	0x00,wcode	; 00 58
	subwfb	*0x00,wcode	; 00 58
	subwfb	extaddr,wcode	;*00n59
	subwfb	*extaddr,wcode	;*00n59
	subwfb	0x00,#wcode	; 00 58
	subwfb	*0x00,#wcode	; 00 58
	subwfb	extaddr,#wcode	;*00n59
	subwfb	*extaddr,#wcode	;*00n59

	subwfb	0x00,1		; 00 5A
	subwfb	*0x00,1		; 00 5A
	subwfb	extaddr,1	;*00n5B
	subwfb	*extaddr,1	;*00n5B
	subwfb	0x00,#1		; 00 5A
	subwfb	*0x00,#1	; 00 5A
	subwfb	extaddr,#1	;*00n5B
	subwfb	*extaddr,#1	;*00n5B
	subwfb	0x00,fcode	; 00 5A
	subwfb	*0x00,fcode	; 00 5A
	subwfb	extaddr,fcode	;*00n5B
	subwfb	*extaddr,fcode	;*00n5B
	subwfb	0x00,#fcode	; 00 5A
	subwfb	*0x00,#fcode	; 00 5A
	subwfb	extaddr,#fcode	;*00n5B
	subwfb	*extaddr,#fcode	;*00n5B

	subwf	0x00,w		; 00 5C
	subwf	0xFF,w		;*FFn5D
	subwf	extaddr,w	;*00n5D

	subwf	0x00,f		; 00 5E
	subwf	0xFF,f		;*FFn5F
	subwf	extaddr,f	;*00n5F

	subwf	*0x00,w		; 00 5C
	subwf	*0xFF,w		;*FFn5D
	subwf	*extaddr,w	;*00n5D

	subwf	*0x00,f		; 00 5E
	subwf	*0xFF,f		;*FFn5F
	subwf	*extaddr,f	;*00n5F

	subwf	0x00,0		; 00 5C
	subwf	*0x00,0		; 00 5C
	subwf	extaddr,0	;*00n5D
	subwf	*extaddr,0	;*00n5D
	subwf	0x00,#0		; 00 5C
	subwf	*0x00,#0	; 00 5C
	subwf	extaddr,#0	;*00n5D
	subwf	*extaddr,#0	;*00n5D
	subwf	0x00,wcode	; 00 5C
	subwf	*0x00,wcode	; 00 5C
	subwf	extaddr,wcode	;*00n5D
	subwf	*extaddr,wcode	;*00n5D
	subwf	0x00,#wcode	; 00 5C
	subwf	*0x00,#wcode	; 00 5C
	subwf	extaddr,#wcode	;*00n5D
	subwf	*extaddr,#wcode	;*00n5D

	subwf	0x00,1		; 00 5E
	subwf	*0x00,1		; 00 5E
	subwf	extaddr,1	;*00n5F
	subwf	*extaddr,1	;*00n5F
	subwf	0x00,#1		; 00 5E
	subwf	*0x00,#1	; 00 5E
	subwf	extaddr,#1	;*00n5F
	subwf	*extaddr,#1	;*00n5F
	subwf	0x00,fcode	; 00 5E
	subwf	*0x00,fcode	; 00 5E
	subwf	extaddr,fcode	;*00n5F
	subwf	*extaddr,fcode	;*00n5F
	subwf	0x00,#fcode	; 00 5E
	subwf	*0x00,#fcode	; 00 5E
	subwf	extaddr,#fcode	;*00n5F
	subwf	*extaddr,#fcode	;*00n5F

	decf	0x00,w		; 00 04
	decf	0xFF,w		;*FFn05
	decf	extaddr,w	;*00n05

	decf	0x00,f		; 00 06
	decf	0xFF,f		;*FFn07
	decf	extaddr,f	;*00n07

	decf	*0x00,w		; 00 04
	decf	*0xFF,w		;*FFn05
	decf	*extaddr,w	;*00n05

	decf	*0x00,f		; 00 06
	decf	*0xFF,f		;*FFn07
	decf	*extaddr,f	;*00n07

	decf	0x00,0		; 00 04
	decf	*0x00,0		; 00 04
	decf	extaddr,0	;*00n05
	decf	*extaddr,0	;*00n05
	decf	0x00,#0		; 00 04
	decf	*0x00,#0	; 00 04
	decf	extaddr,#0	;*00n05
	decf	*extaddr,#0	;*00n05
	decf	0x00,wcode	; 00 04
	decf	*0x00,wcode	; 00 04
	decf	extaddr,wcode	;*00n05
	decf	*extaddr,wcode	;*00n05
	decf	0x00,#wcode	; 00 04
	decf	*0x00,#wcode	; 00 04
	decf	extaddr,#wcode	;*00n05
	decf	*extaddr,#wcode	;*00n05

	decf	0x00,1		; 00 06
	decf	*0x00,1		; 00 06
	decf	extaddr,1	;*00n07
	decf	*extaddr,1	;*00n07
	decf	0x00,#1		; 00 06
	decf	*0x00,#1	; 00 06
	decf	extaddr,#1	;*00n07
	decf	*extaddr,#1	;*00n07
	decf	0x00,fcode	; 00 06
	decf	*0x00,fcode	; 00 06
	decf	extaddr,fcode	;*00n07
	decf	*extaddr,fcode	;*00n07
	decf	0x00,#fcode	; 00 06
	decf	*0x00,#fcode	; 00 06
	decf	extaddr,#fcode	;*00n07
	decf	*extaddr,#fcode	;*00n07

	iorwf	0x00,w		; 00 10
	iorwf	0xFF,w		;*FFn11
	iorwf	extaddr,w	;*00n11

	iorwf	0x00,f		; 00 12
	iorwf	0xFF,f		;*FFn13
	iorwf	extaddr,f	;*00n13

	iorwf	*0x00,w		; 00 10
	iorwf	*0xFF,w		;*FFn11
	iorwf	*extaddr,w	;*00n11

	iorwf	*0x00,f		; 00 12
	iorwf	*0xFF,f		;*FFn13
	iorwf	*extaddr,f	;*00n13

	iorwf	0x00,0		; 00 10
	iorwf	*0x00,0		; 00 10
	iorwf	extaddr,0	;*00n11
	iorwf	*extaddr,0	;*00n11
	iorwf	0x00,#0		; 00 10
	iorwf	*0x00,#0	; 00 10
	iorwf	extaddr,#0	;*00n11
	iorwf	*extaddr,#0	;*00n11
	iorwf	0x00,wcode	; 00 10
	iorwf	*0x00,wcode	; 00 10
	iorwf	extaddr,wcode	;*00n11
	iorwf	*extaddr,wcode	;*00n11
	iorwf	0x00,#wcode	; 00 10
	iorwf	*0x00,#wcode	; 00 10
	iorwf	extaddr,#wcode	;*00n11
	iorwf	*extaddr,#wcode	;*00n11

	iorwf	0x00,1		; 00 12
	iorwf	*0x00,1		; 00 12
	iorwf	extaddr,1	;*00n13
	iorwf	*extaddr,1	;*00n13
	iorwf	0x00,#1		; 00 12
	iorwf	*0x00,#1	; 00 12
	iorwf	extaddr,#1	;*00n13
	iorwf	*extaddr,#1	;*00n13
	iorwf	0x00,fcode	; 00 12
	iorwf	*0x00,fcode	; 00 12
	iorwf	extaddr,fcode	;*00n13
	iorwf	*extaddr,fcode	;*00n13
	iorwf	0x00,#fcode	; 00 12
	iorwf	*0x00,#fcode	; 00 12
	iorwf	extaddr,#fcode	;*00n13
	iorwf	*extaddr,#fcode	;*00n13

	andwf	0x00,w		; 00 14
	andwf	0xFF,w		;*FFn15
	andwf	extaddr,w	;*00n15

	andwf	0x00,f		; 00 16
	andwf	0xFF,f		;*FFn17
	andwf	extaddr,f	;*00n17

	andwf	*0x00,w		; 00 14
	andwf	*0xFF,w		;*FFn15
	andwf	*extaddr,w	;*00n15

	andwf	*0x00,f		; 00 16
	andwf	*0xFF,f		;*FFn17
	andwf	*extaddr,f	;*00n17

	andwf	0x00,0		; 00 14
	andwf	*0x00,0		; 00 14
	andwf	extaddr,0	;*00n15
	andwf	*extaddr,0	;*00n15
	andwf	0x00,#0		; 00 14
	andwf	*0x00,#0	; 00 14
	andwf	extaddr,#0	;*00n15
	andwf	*extaddr,#0	;*00n15
	andwf	0x00,wcode	; 00 14
	andwf	*0x00,wcode	; 00 14
	andwf	extaddr,wcode	;*00n15
	andwf	*extaddr,wcode	;*00n15
	andwf	0x00,#wcode	; 00 14
	andwf	*0x00,#wcode	; 00 14
	andwf	extaddr,#wcode	;*00n15
	andwf	*extaddr,#wcode	;*00n15

	andwf	0x00,1		; 00 16
	andwf	*0x00,1		; 00 16
	andwf	extaddr,1	;*00n17
	andwf	*extaddr,1	;*00n17
	andwf	0x00,#1		; 00 16
	andwf	*0x00,#1	; 00 16
	andwf	extaddr,#1	;*00n17
	andwf	*extaddr,#1	;*00n17
	andwf	0x00,fcode	; 00 16
	andwf	*0x00,fcode	; 00 16
	andwf	extaddr,fcode	;*00n17
	andwf	*extaddr,fcode	;*00n17
	andwf	0x00,#fcode	; 00 16
	andwf	*0x00,#fcode	; 00 16
	andwf	extaddr,#fcode	;*00n17
	andwf	*extaddr,#fcode	;*00n17

	xorwf	0x00,w		; 00 18
	xorwf	0xFF,w		;*FFn19
	xorwf	extaddr,w	;*00n19

	xorwf	0x00,f		; 00 1A
	xorwf	0xFF,f		;*FFn1B
	xorwf	extaddr,f	;*00n1B

	xorwf	*0x00,w		; 00 18
	xorwf	*0xFF,w		;*FFn19
	xorwf	*extaddr,w	;*00n19

	xorwf	*0x00,f		; 00 1A
	xorwf	*0xFF,f		;*FFn1B
	xorwf	*extaddr,f	;*00n1B

	xorwf	0x00,0		; 00 18
	xorwf	*0x00,0		; 00 18
	xorwf	extaddr,0	;*00n19
	xorwf	*extaddr,0	;*00n19
	xorwf	0x00,#0		; 00 18
	xorwf	*0x00,#0	; 00 18
	xorwf	extaddr,#0	;*00n19
	xorwf	*extaddr,#0	;*00n19
	xorwf	0x00,wcode	; 00 18
	xorwf	*0x00,wcode	; 00 18
	xorwf	extaddr,wcode	;*00n19
	xorwf	*extaddr,wcode	;*00n19
	xorwf	0x00,#wcode	; 00 18
	xorwf	*0x00,#wcode	; 00 18
	xorwf	extaddr,#wcode	;*00n19
	xorwf	*extaddr,#wcode	;*00n19

	xorwf	0x00,1		; 00 1A
	xorwf	*0x00,1		; 00 1A
	xorwf	extaddr,1	;*00n1B
	xorwf	*extaddr,1	;*00n1B
	xorwf	0x00,#1		; 00 1A
	xorwf	*0x00,#1	; 00 1A
	xorwf	extaddr,#1	;*00n1B
	xorwf	*extaddr,#1	;*00n1B
	xorwf	0x00,fcode	; 00 1A
	xorwf	*0x00,fcode	; 00 1A
	xorwf	extaddr,fcode	;*00n1B
	xorwf	*extaddr,fcode	;*00n1B
	xorwf	0x00,#fcode	; 00 1A
	xorwf	*0x00,#fcode	; 00 1A
	xorwf	extaddr,#fcode	;*00n1B
	xorwf	*extaddr,#fcode	;*00n1B

	addwf	0x00,w		; 00 24
	addwf	0xFF,w		;*FFn25
	addwf	extaddr,w	;*00n25

	addwf	0x00,f		; 00 26
	addwf	0xFF,f		;*FFn27
	addwf	extaddr,f	;*00n27

	addwf	*0x00,w		; 00 24
	addwf	*0xFF,w		;*FFn25
	addwf	*extaddr,w	;*00n25

	addwf	*0x00,f		; 00 26
	addwf	*0xFF,f		;*FFn27
 	addwf	*extaddr,f	;*00n27

	addwf	0x00,0		; 00 24
	addwf	*0x00,0		; 00 24
	addwf	extaddr,0	;*00n25
	addwf	*extaddr,0	;*00n25
	addwf	0x00,#0		; 00 24
	addwf	*0x00,#0	; 00 24
	addwf	extaddr,#0	;*00n25
	addwf	*extaddr,#0	;*00n25
	addwf	0x00,wcode	; 00 24
	addwf	*0x00,wcode	; 00 24
	addwf	extaddr,wcode	;*00n25
	addwf	*extaddr,wcode	;*00n25
	addwf	0x00,#wcode	; 00 24
	addwf	*0x00,#wcode	; 00 24
	addwf	extaddr,#wcode	;*00n25
	addwf	*extaddr,#wcode	;*00n25

	addwf	0x00,1		; 00 26
	addwf	*0x00,1		; 00 26
	addwf	extaddr,1	;*00n27
	addwf	*extaddr,1	;*00n27
	addwf	0x00,#1		; 00 26
	addwf	*0x00,#1	; 00 26
	addwf	extaddr,#1	;*00n27
	addwf	*extaddr,#1	;*00n27
	addwf	0x00,fcode	; 00 26
	addwf	*0x00,fcode	; 00 26
	addwf	extaddr,fcode	;*00n27
	addwf	*extaddr,fcode	;*00n27
	addwf	0x00,#fcode	; 00 26
	addwf	*0x00,#fcode	; 00 26
	addwf	extaddr,#fcode	;*00n27
	addwf	*extaddr,#fcode	;*00n27

	addwfc	0x00,w		; 00 20
	addwfc	0xFF,w		;*FFn21
	addwfc	extaddr,w	;*00n21

	addwfc	0x00,f		; 00 22
	addwfc	0xFF,f		;*FFn23
	addwfc	extaddr,f	;*00n23

	addwfc	*0x00,w		; 00 20
	addwfc	*0xFF,w		;*FFn21
	addwfc	*extaddr,w	;*00n21

	addwfc	*0x00,f		; 00 22
	addwfc	*0xFF,f		;*FFn23
 	addwfc	*extaddr,f	;*00n23

	addwfc	0x00,0		; 00 20
	addwfc	*0x00,0		; 00 20
	addwfc	extaddr,0	;*00n21
	addwfc	*extaddr,0	;*00n21
	addwfc	0x00,#0		; 00 20
	addwfc	*0x00,#0	; 00 20
	addwfc	extaddr,#0	;*00n21
	addwfc	*extaddr,#0	;*00n21
	addwfc	0x00,wcode	; 00 20
	addwfc	*0x00,wcode	; 00 20
	addwfc	extaddr,wcode	;*00n21
	addwfc	*extaddr,wcode	;*00n21
	addwfc	0x00,#wcode	; 00 20
	addwfc	*0x00,#wcode	; 00 20
	addwfc	extaddr,#wcode	;*00n21
	addwfc	*extaddr,#wcode	;*00n21

	addwfc	0x00,1		; 00 22
	addwfc	*0x00,1		; 00 22
	addwfc	extaddr,1	;*00n23
	addwfc	*extaddr,1	;*00n23
	addwfc	0x00,#1		; 00 22
	addwfc	*0x00,#1	; 00 22
	addwfc	extaddr,#1	;*00n23
	addwfc	*extaddr,#1	;*00n23
	addwfc	0x00,fcode	; 00 22
	addwfc	*0x00,fcode	; 00 22
	addwfc	extaddr,fcode	;*00n23
	addwfc	*extaddr,fcode	;*00n23
	addwfc	0x00,#fcode	; 00 22
	addwfc	*0x00,#fcode	; 00 22
	addwfc	extaddr,#fcode	;*00n23
	addwfc	*extaddr,#fcode	;*00n23

	comf	0x00,w		; 00 1C
	comf	0xFF,w		;*FFn1D
	comf	extaddr,w	;*00n1D

	comf	0x00,f		; 00 1E
	comf	0xFF,f		;*FFn1F
 	comf	extaddr,f	;*00n1F

	comf	*0x00,w		; 00 1C
	comf	*0xFF,w		;*FFn1D
	comf	*extaddr,w	;*00n1D

	comf	*0x00,f		; 00 1E
	comf	*0xFF,f		;*FFn1F
 	comf	*extaddr,f	;*00n1F

	comf	0x00,0		; 00 1C
	comf	*0x00,0		; 00 1C
	comf	extaddr,0	;*00n1D
	comf	*extaddr,0	;*00n1D
	comf	0x00,#0		; 00 1C
	comf	*0x00,#0	; 00 1C
	comf	extaddr,#0	;*00n1D
	comf	*extaddr,#0	;*00n1D
	comf	0x00,wcode	; 00 1C
	comf	*0x00,wcode	; 00 1C
	comf	extaddr,wcode	;*00n1D
	comf	*extaddr,wcode	;*00n1D
	comf	0x00,#wcode	; 00 1C
	comf	*0x00,#wcode	; 00 1C
	comf	extaddr,#wcode	;*00n1D
	comf	*extaddr,#wcode	;*00n1D

	comf	0x00,1		; 00 1E
	comf	*0x00,1		; 00 1E
	comf	extaddr,1	;*00n1F
	comf	*extaddr,1	;*00n1F
	comf	0x00,#1		; 00 1E
	comf	*0x00,#1	; 00 1E
	comf	extaddr,#1	;*00n1F
	comf	*extaddr,#1	;*00n1F
	comf	0x00,fcode	; 00 1E
	comf	*0x00,fcode	; 00 1E
	comf	extaddr,fcode	;*00n1F
	comf	*extaddr,fcode	;*00n1F
	comf	0x00,#fcode	; 00 1E
	comf	*0x00,#fcode	; 00 1E
	comf	extaddr,#fcode	;*00n1F
	comf	*extaddr,#fcode	;*00n1F

	incf	0x00,w		; 00 28
	incf	0xFF,w		;*FFn29
	incf	extaddr,w	;*00n29

	incf	0x00,f		; 00 2A
	incf	0xFF,f		;*FFn2B
	incf	extaddr,f	;*00n2B

	incf	*0x00,w		; 00 28
	incf	*0xFF,w		;*FFn29
	incf	*extaddr,w	;*00n29

	incf	*0x00,f		; 00 2A
	incf	*0xFF,f		;*FFn2B
	incf	*extaddr,f	;*00n2B

	incf	0x00,0		; 00 28
	incf	*0x00,0		; 00 28
	incf	extaddr,0	;*00n29
	incf	*extaddr,0	;*00n29
	incf	0x00,#0		; 00 28
	incf	*0x00,#0	; 00 28
	incf	extaddr,#0	;*00n29
	incf	*extaddr,#0	;*00n29
	incf	0x00,wcode	; 00 28
	incf	*0x00,wcode	; 00 28
	incf	extaddr,wcode	;*00n29
	incf	*extaddr,wcode	;*00n29
	incf	0x00,#wcode	; 00 28
	incf	*0x00,#wcode	; 00 28
	incf	extaddr,#wcode	;*00n29
	incf	*extaddr,#wcode	;*00n29

	incf	0x00,1		; 00 2A
	incf	*0x00,1		; 00 2A
	incf	extaddr,1	;*00n2B
	incf	*extaddr,1	;*00n2B
	incf	0x00,#1		; 00 2A
	incf	*0x00,#1	; 00 2A
	incf	extaddr,#1	;*00n2B
	incf	*extaddr,#1	;*00n2B
	incf	0x00,fcode	; 00 2A
	incf	*0x00,fcode	; 00 2A
	incf	extaddr,fcode	;*00n2B
	incf	*extaddr,fcode	;*00n2B
	incf	0x00,#fcode	; 00 2A
	incf	*0x00,#fcode	; 00 2A
	incf	extaddr,#fcode	;*00n2B
	incf	*extaddr,#fcode	;*00n2B

	decfsz	0x00,w		; 00 2C
	decfsz	0xFF,w		;*FFn2D
	decfsz	extaddr,w	;*00n2D

	decfsz	0x00,f		; 00 2E
	decfsz	0xFF,f		;*FFn2F
	decfsz	extaddr,f	;*00n2F

	decfsz	*0x00,w		; 00 2C
	decfsz	*0xFF,w		;*FFn2D
	decfsz	*extaddr,w	;*00n2D

	decfsz	*0x00,f		; 00 2E
	decfsz	*0xFF,f		;*FFn2F
 	decfsz	*extaddr,f	;*00n2F

	decfsz	0x00,0		; 00 2C
	decfsz	*0x00,0		; 00 2C
	decfsz	extaddr,0	;*00n2D
	decfsz	*extaddr,0	;*00n2D
	decfsz	0x00,#0		; 00 2C
	decfsz	*0x00,#0	; 00 2C
	decfsz	extaddr,#0	;*00n2D
	decfsz	*extaddr,#0	;*00n2D
	decfsz	0x00,wcode	; 00 2C
	decfsz	*0x00,wcode	; 00 2C
	decfsz	extaddr,wcode	;*00n2D
	decfsz	*extaddr,wcode	;*00n2D
	decfsz	0x00,#wcode	; 00 2C
	decfsz	*0x00,#wcode	; 00 2C
	decfsz	extaddr,#wcode	;*00n2D
	decfsz	*extaddr,#wcode	;*00n2D

	decfsz	0x00,1		; 00 2E
	decfsz	*0x00,1		; 00 2E
	decfsz	extaddr,1	;*00n2F
	decfsz	*extaddr,1	;*00n2F
	decfsz	0x00,#1		; 00 2E
	decfsz	*0x00,#1	; 00 2E
	decfsz	extaddr,#1	;*00n2F
	decfsz	*extaddr,#1	;*00n2F
	decfsz	0x00,fcode	; 00 2E
	decfsz	*0x00,fcode	; 00 2E
	decfsz	extaddr,fcode	;*00n2F
	decfsz	*extaddr,fcode	;*00n2F
	decfsz	0x00,#fcode	; 00 2E
	decfsz	*0x00,#fcode	; 00 2E
	decfsz	extaddr,#fcode	;*00n2F
	decfsz	*extaddr,#fcode	;*00n2F

	rrcf	0x00,w		; 00 30
	rrcf	0xFF,w		;*FFn31
	rrcf	extaddr,w	;*00n31

	rrcf	0x00,f		; 00 32
	rrcf	0xFF,f		;*FFn33
	rrcf	extaddr,f	;*00n33

	rrcf	*0x00,w		; 00 30
	rrcf	*0xFF,w		;*FFn31
	rrcf	*extaddr,w	;*00n31

	rrcf	*0x00,f		; 00 32
	rrcf	*0xFF,f		;*FFn33
 	rrcf	*extaddr,f	;*00n33

	rrcf	0x00,0		; 00 30
	rrcf	*0x00,0		; 00 30
	rrcf	extaddr,0	;*00n31
	rrcf	*extaddr,0	;*00n31
	rrcf	0x00,#0		; 00 30
	rrcf	*0x00,#0	; 00 30
	rrcf	extaddr,#0	;*00n31
	rrcf	*extaddr,#0	;*00n31
	rrcf	0x00,wcode	; 00 30
	rrcf	*0x00,wcode	; 00 30
	rrcf	extaddr,wcode	;*00n31
	rrcf	*extaddr,wcode	;*00n31
	rrcf	0x00,#wcode	; 00 30
	rrcf	*0x00,#wcode	; 00 30
	rrcf	extaddr,#wcode	;*00n31
	rrcf	*extaddr,#wcode	;*00n31

	rrcf	0x00,1		; 00 32
	rrcf	*0x00,1		; 00 32
	rrcf	extaddr,1	;*00n33
	rrcf	*extaddr,1	;*00n33
	rrcf	0x00,#1		; 00 32
	rrcf	*0x00,#1	; 00 32
	rrcf	extaddr,#1	;*00n33
	rrcf	*extaddr,#1	;*00n33
	rrcf	0x00,fcode	; 00 32
	rrcf	*0x00,fcode	; 00 32
	rrcf	extaddr,fcode	;*00n33
	rrcf	*extaddr,fcode	;*00n33
	rrcf	0x00,#fcode	; 00 32
	rrcf	*0x00,#fcode	; 00 32
	rrcf	extaddr,#fcode	;*00n33
	rrcf	*extaddr,#fcode	;*00n33

	rlcf	0x00,w		; 00 34
	rlcf	0xFF,w		;*FFn35
	rlcf	extaddr,w	;*00n35

	rlcf	0x00,f		; 00 36
	rlcf	0xFF,f		;*FFn37
	rlcf	extaddr,f	;*00n37

	rlcf	*0x00,w		; 00 34
	rlcf	*0xFF,w		;*FFn35
	rlcf	*extaddr,w	;*00n35

	rlcf	*0x00,f		; 00 36
	rlcf	*0xFF,f		;*FFn37
	rlcf	*extaddr,f	;*00n37

	rlcf	0x00,0		; 00 34
	rlcf	*0x00,0		; 00 34
	rlcf	extaddr,0	;*00n35
	rlcf	*extaddr,0	;*00n35
	rlcf	0x00,#0		; 00 34
	rlcf	*0x00,#0	; 00 34
	rlcf	extaddr,#0	;*00n35
	rlcf	*extaddr,#0	;*00n35
	rlcf	0x00,wcode	; 00 34
	rlcf	*0x00,wcode	; 00 34
	rlcf	extaddr,wcode	;*00n35
	rlcf	*extaddr,wcode	;*00n35
	rlcf	0x00,#wcode	; 00 34
	rlcf	*0x00,#wcode	; 00 34
	rlcf	extaddr,#wcode	;*00n35
	rlcf	*extaddr,#wcode	;*00n35

	rlcf	0x00,1		; 00 36
	rlcf	*0x00,1		; 00 36
	rlcf	extaddr,1	;*00n37
	rlcf	*extaddr,1	;*00n37
	rlcf	0x00,#1		; 00 36
	rlcf	*0x00,#1	; 00 36
	rlcf	extaddr,#1	;*00n37
	rlcf	*extaddr,#1	;*00n37
	rlcf	0x00,fcode	; 00 36
	rlcf	*0x00,fcode	; 00 36
	rlcf	extaddr,fcode	;*00n37
	rlcf	*extaddr,fcode	;*00n37
	rlcf	0x00,#fcode	; 00 36
	rlcf	*0x00,#fcode	; 00 36
	rlcf	extaddr,#fcode	;*00n37
	rlcf	*extaddr,#fcode	;*00n37

	swapf	0x00,w		; 00 38
	swapf	0xFF,w		;*FFn39
	swapf	extaddr,w	;*00n39

	swapf	0x00,f		; 00 3A
	swapf	0xFF,f		;*FFn3B
	swapf	extaddr,f	;*00n3B

	swapf	*0x00,w		; 00 38
	swapf	*0xFF,w		;*FFn39
	swapf	*extaddr,w	;*00n39


	swapf	*0x00,f		; 00 3A
	swapf	*0xFF,f		;*FFn3B
	swapf	*extaddr,f	;*00n3B

	swapf	0x00,0		; 00 38
	swapf	*0x00,0		; 00 38
	swapf	extaddr,0	;*00n39
	swapf	*extaddr,0	;*00n39
	swapf	0x00,#0		; 00 38
	swapf	*0x00,#0	; 00 38
	swapf	extaddr,#0	;*00n39
	swapf	*extaddr,#0	;*00n39
	swapf	0x00,wcode	; 00 38
	swapf	*0x00,wcode	; 00 38
	swapf	extaddr,wcode	;*00n39
	swapf	*extaddr,wcode	;*00n39
	swapf	0x00,#wcode	; 00 38
	swapf	*0x00,#wcode	; 00 38
	swapf	extaddr,#wcode	;*00n39
	swapf	*extaddr,#wcode	;*00n39

	swapf	0x00,1		; 00 3A
	swapf	*0x00,1		; 00 3A
	swapf	extaddr,1	;*00n3B
	swapf	*extaddr,1	;*00n3B
	swapf	0x00,#1		; 00 3A
	swapf	*0x00,#1	; 00 3A
	swapf	extaddr,#1	;*00n3B
	swapf	*extaddr,#1	;*00n3B
	swapf	0x00,fcode	; 00 3A
	swapf	*0x00,fcode	; 00 3A
	swapf	extaddr,fcode	;*00n3B
	swapf	*extaddr,fcode	;*00n3B
	swapf	0x00,#fcode	; 00 3A
	swapf	*0x00,#fcode	; 00 3A
	swapf	extaddr,#fcode	;*00n3B
	swapf	*extaddr,#fcode	;*00n3B

	incfsz	0x00,w		; 00 3C
	incfsz	0xFF,w		;*FFn3D
	incfsz	extaddr,w	;*00n3D

	incfsz	0x00,f		; 00 3E
	incfsz	0xFF,f		;*FFn3F
	incfsz	extaddr,f	;*00n3F

	incfsz	*0x00,w		; 00 3C
	incfsz	*0xFF,w		;*FFn3D
	incfsz	*extaddr,w	;*00n3D

	incfsz	*0x00,f		; 00 3E
	incfsz	*0xFF,f		;*FFn3F
	incfsz	*extaddr,f	;*00n3F

	incfsz	0x00,0		; 00 3C
	incfsz	*0x00,0		; 00 3C
	incfsz	extaddr,0	;*00n3D
	incfsz	*extaddr,0	;*00n3D
	incfsz	0x00,#0		; 00 3C
	incfsz	*0x00,#0	; 00 3C
	incfsz	extaddr,#0	;*00n3D
	incfsz	*extaddr,#0	;*00n3D
	incfsz	0x00,wcode	; 00 3C
	incfsz	*0x00,wcode	; 00 3C
	incfsz	extaddr,wcode	;*00n3D
	incfsz	*extaddr,wcode	;*00n3D
	incfsz	0x00,#wcode	; 00 3C
	incfsz	*0x00,#wcode	; 00 3C
	incfsz	extaddr,#wcode	;*00n3D
	incfsz	*extaddr,#wcode	;*00n3D

	incfsz	0x00,1		; 00 3E
	incfsz	*0x00,1		; 00 3E
	incfsz	extaddr,1	;*00n3F
	incfsz	*extaddr,1	;*00n3F
	incfsz	0x00,#1		; 00 3E
	incfsz	*0x00,#1	; 00 3E
	incfsz	extaddr,#1	;*00n3F
	incfsz	*extaddr,#1	;*00n3F
	incfsz	0x00,fcode	; 00 3E
	incfsz	*0x00,fcode	; 00 3E
	incfsz	extaddr,fcode	;*00n3F
	incfsz	*extaddr,fcode	;*00n3F
	incfsz	0x00,#fcode	; 00 3E
	incfsz	*0x00,#fcode	; 00 3E
	incfsz	extaddr,#fcode	;*00n3F
	incfsz	*extaddr,#fcode	;*00n3F

	rrncf	0x00,w		; 00 40
	rrncf	0xFF,w		;*FFn41
	rrncf	extaddr,w	;*00n41

	rrncf	0x00,f		; 00 42
	rrncf	0xFF,f		;*FFn43
	rrncf	extaddr,f	;*00n43

	rrncf	*0x00,w		; 00 40
	rrncf	*0xFF,w		;*FFn41
	rrncf	*extaddr,w	;*00n41

	rrncf	*0x00,f		; 00 42
	rrncf	*0xFF,f		;*FFn43
 	rrncf	*extaddr,f	;*00n43

	rrncf	0x00,0		; 00 40
	rrncf	*0x00,0		; 00 40
	rrncf	extaddr,0	;*00n41
	rrncf	*extaddr,0	;*00n41
	rrncf	0x00,#0		; 00 40
	rrncf	*0x00,#0	; 00 40
	rrncf	extaddr,#0	;*00n41
	rrncf	*extaddr,#0	;*00n41
	rrncf	0x00,wcode	; 00 40
	rrncf	*0x00,wcode	; 00 40
	rrncf	extaddr,wcode	;*00n41
	rrncf	*extaddr,wcode	;*00n41
	rrncf	0x00,#wcode	; 00 40
	rrncf	*0x00,#wcode	; 00 40
	rrncf	extaddr,#wcode	;*00n41
	rrncf	*extaddr,#wcode	;*00n41

	rrncf	0x00,1		; 00 42
	rrncf	*0x00,1		; 00 42
	rrncf	extaddr,1	;*00n43
	rrncf	*extaddr,1	;*00n43
	rrncf	0x00,#1		; 00 42
	rrncf	*0x00,#1	; 00 42
	rrncf	extaddr,#1	;*00n43
	rrncf	*extaddr,#1	;*00n43
	rrncf	0x00,fcode	; 00 42
	rrncf	*0x00,fcode	; 00 42
	rrncf	extaddr,fcode	;*00n43
	rrncf	*extaddr,fcode	;*00n43
	rrncf	0x00,#fcode	; 00 42
	rrncf	*0x00,#fcode	; 00 42
	rrncf	extaddr,#fcode	;*00n43
	rrncf	*extaddr,#fcode	;*00n43

	rlncf	0x00,w		; 00 44
	rlncf	0xFF,w		;*FFn45
	rlncf	extaddr,w	;*00n45

	rlncf	0x00,f		; 00 46
	rlncf	0xFF,f		;*FFn47
	rlncf	extaddr,f	;*00n47

	rlncf	*0x00,w		; 00 44
	rlncf	*0xFF,w		;*FFn45
	rlncf	*extaddr,w	;*00n45

	rlncf	*0x00,f		; 00 46
	rlncf	*0xFF,f		;*FFn47
	rlncf	*extaddr,f	;*00n47

	rlncf	0x00,0		; 00 44
	rlncf	*0x00,0		; 00 44
	rlncf	extaddr,0	;*00n45
	rlncf	*extaddr,0	;*00n45
	rlncf	0x00,#0		; 00 44
	rlncf	*0x00,#0	; 00 44
	rlncf	extaddr,#0	;*00n45
	rlncf	*extaddr,#0	;*00n45
	rlncf	0x00,wcode	; 00 44
	rlncf	*0x00,wcode	; 00 44
	rlncf	extaddr,wcode	;*00n45
	rlncf	*extaddr,wcode	;*00n45
	rlncf	0x00,#wcode	; 00 44
	rlncf	*0x00,#wcode	; 00 44
	rlncf	extaddr,#wcode	;*00n45
	rlncf	*extaddr,#wcode	;*00n45

	rlncf	0x00,1		; 00 46
	rlncf	*0x00,1		; 00 46
	rlncf	extaddr,1	;*00n47
	rlncf	*extaddr,1	;*00n47
	rlncf	0x00,#1		; 00 46
	rlncf	*0x00,#1	; 00 46
	rlncf	extaddr,#1	;*00n47
	rlncf	*extaddr,#1	;*00n47
	rlncf	0x00,fcode	; 00 46
	rlncf	*0x00,fcode	; 00 46
	rlncf	extaddr,fcode	;*00n47
	rlncf	*extaddr,fcode	;*00n47
	rlncf	0x00,#fcode	; 00 46
	rlncf	*0x00,#fcode	; 00 46
	rlncf	extaddr,#fcode	;*00n47
	rlncf	*extaddr,#fcode	;*00n47

	infsnz	0x00,w		; 00 48
	infsnz	0xFF,w		;*FFn49
	infsnz	extaddr,w	;*00n49

	infsnz	0x00,f		; 00 4A
	infsnz	0xFF,f		;*FFn4B
	infsnz	extaddr,f	;*00n4B

	infsnz	*0x00,w		; 00 48
	infsnz	*0xFF,w		;*FFn49
	infsnz	*extaddr,w	;*00n49

	infsnz	*0x00,f		; 00 4A
	infsnz	*0xFF,f		;*FFn4B
	infsnz	*extaddr,f	;*00n4B

	infsnz	0x00,0		; 00 48
	infsnz	*0x00,0		; 00 48
	infsnz	extaddr,0	;*00n49
	infsnz	*extaddr,0	;*00n49
	infsnz	0x00,#0		; 00 48
	infsnz	*0x00,#0	; 00 48
	infsnz	extaddr,#0	;*00n49
	infsnz	*extaddr,#0	;*00n49
	infsnz	0x00,wcode	; 00 48
	infsnz	*0x00,wcode	; 00 48
	infsnz	extaddr,wcode	;*00n49
	infsnz	*extaddr,wcode	;*00n49
	infsnz	0x00,#wcode	; 00 48
	infsnz	*0x00,#wcode	; 00 48
	infsnz	extaddr,#wcode	;*00n49
	infsnz	*extaddr,#wcode	;*00n49

	infsnz	0x00,1		; 00 4A
	infsnz	*0x00,1		; 00 4A
	infsnz	extaddr,1	;*00n4B
	infsnz	*extaddr,1	;*00n4B
	infsnz	0x00,#1		; 00 4A
	infsnz	*0x00,#1	; 00 4A
	infsnz	extaddr,#1	;*00n4B
	infsnz	*extaddr,#1	;*00n4B
	infsnz	0x00,fcode	; 00 4A
	infsnz	*0x00,fcode	; 00 4A
	infsnz	extaddr,fcode	;*00n4B
	infsnz	*extaddr,fcode	;*00n4B
	infsnz	0x00,#fcode	; 00 4A
	infsnz	*0x00,#fcode	; 00 4A
	infsnz	extaddr,#fcode	;*00n4B
	infsnz	*extaddr,#fcode	;*00n4B

	dcfsnz	0x00,w		; 00 4C
	dcfsnz	0xFF,w		;*FFn4D
	dcfsnz	extaddr,w	;*00n4D

	dcfsnz	0x00,f		; 00 4E
	dcfsnz	0xFF,f		;*FFn4F
	dcfsnz	extaddr,f	;*00n4F

	dcfsnz	*0x00,w		; 00 4C
	dcfsnz	*0xFF,w		;*FFn4D
	dcfsnz	*extaddr,w	;*00n4D

	dcfsnz	*0x00,f		; 00 4E
	dcfsnz	*0xFF,f		;*FFn4F
 	dcfsnz	*extaddr,f	;*00n4F

	dcfsnz	0x00,0		; 00 4C
	dcfsnz	*0x00,0		; 00 4C
	dcfsnz	extaddr,0	;*00n4D
	dcfsnz	*extaddr,0	;*00n4D
	dcfsnz	0x00,#0		; 00 4C
	dcfsnz	*0x00,#0	; 00 4C
	dcfsnz	extaddr,#0	;*00n4D
	dcfsnz	*extaddr,#0	;*00n4D
	dcfsnz	0x00,wcode	; 00 4C
	dcfsnz	*0x00,wcode	; 00 4C
	dcfsnz	extaddr,wcode	;*00n4D
	dcfsnz	*extaddr,wcode	;*00n4D
	dcfsnz	0x00,#wcode	; 00 4C
	dcfsnz	*0x00,#wcode	; 00 4C
	dcfsnz	extaddr,#wcode	;*00n4D
	dcfsnz	*extaddr,#wcode	;*00n4D

	dcfsnz	0x00,1		; 00 4E
	dcfsnz	*0x00,1		; 00 4E
	dcfsnz	extaddr,1	;*00n4F
	dcfsnz	*extaddr,1	;*00n4F
	dcfsnz	0x00,#1		; 00 4E
	dcfsnz	*0x00,#1	; 00 4E
	dcfsnz	extaddr,#1	;*00n4F
	dcfsnz	*extaddr,#1	;*00n4F
	dcfsnz	0x00,fcode	; 00 4E
	dcfsnz	*0x00,fcode	; 00 4E
	dcfsnz	extaddr,fcode	;*00n4F
	dcfsnz	*extaddr,fcode	;*00n4F
	dcfsnz	0x00,#fcode	; 00 4E
	dcfsnz	*0x00,#fcode	; 00 4E
	dcfsnz	extaddr,#fcode	;*00n4F
	dcfsnz	*extaddr,#fcode	;*00n4F

	clrf	0x00		; 00 6A
	clrf	0xFF		;*FFn6B
	clrf	extaddr		;*00n6B

	clrf	*0x00		; 00 6A
	clrf	*0xFF		;*FFn6B
	clrf	*extaddr	;*00n6B

	clrf	0x00,0		; 00 6A
	clrf	*0x00,0		; 00 6A
	clrf	extaddr,0	;r00s6A
	clrf	*extaddr,0	;r00s6A

	setf	0x00		; 00 68
	setf	0xFF		;*FFn69
	setf	extaddr		;*00n69

	setf	*0x00		; 00 68
	setf	*0xFF		;*FFn69
	setf	*extaddr	;*00n69

	setf	0x00		; 00 68
	setf	*0x00		; 00 68
	setf	extaddr		;*00n69
	setf	*extaddr	;*00n69

	negf	0x00		; 00 6C
	negf	0xFF		;*FFn6D
	negf	extaddr		;*00n6D

	negf	*0x00		; 00 6C
	negf	*0xFF		;*FFn6D
	negf	*extaddr	;*00n6D

	negf	0x00		; 00 6C
	negf	*0x00		; 00 6C
	negf	extaddr		;*00n6D
	negf	*extaddr	;*00n6D

	cpfslt	0x00		; 00 60
	cpfslt	0xFF		;*FFn61
	cpfslt	extaddr		;*00n61

	cpfslt	*0x00		; 00 60
	cpfslt	*0xFF		;*FFn61
	cpfslt	*extaddr	;*00n61

	cpfseq	0x00		; 00 62
	cpfseq	0xFF		;*FFn63
	cpfseq	extaddr		;*00n63

	cpfseq	*0x00		; 00 62
	cpfseq	*0xFF		;*FFn63
	cpfseq	*extaddr	;*00n63

	cpfsgt	0x00		; 00 64
	cpfsgt	0xFF		;*FFn65
	cpfsgt	extaddr		;*00n65

	cpfsgt	*0x00		; 00 64
	cpfsgt	*0xFF		;*FFn65
	cpfsgt	*extaddr	;*00n65

	tstfsz	0x00		; 00 66
	tstfsz	0xFF		;*FFn67
	tstfsz	extaddr		;*00n67

	tstfsz	*0x00		; 00 66
	tstfsz	*0xFF		;*FFn67
	tstfsz	*extaddr	;*00n67


	btg	0x00,0		; 00 70
	btg	0xFF,0		;*FFn71
	btg	extaddr,0	;*00n71

	btg	0x00,7		; 00 7E
	btg	0xFF,7		;*FFn7F
	btg	extaddr,7	;*00n7F

	btg	*0x00,0		; 00 70
	btg	*0xFF,0		;*FFn71
	btg	*extaddr,0	;*00n71

	btg	*0x00,7		; 00 7E
	btg	*0xFF,7		;*FFn7F
	btg	*extaddr,7	;*00n7F

	btg	0x00,num0	; 00 70
	btg	*0x00,num0	; 00 70
	btg	extaddr,num0	;*00n71
	btg	*extaddr,num0	;*00n71
	btg	0x00,#num0	; 00 70
	btg	*0x00,#num0	; 00 70
	btg	extaddr,#num0	;*00n71
	btg	*extaddr,#num0	;*00n71
	btg	0x00,num7	; 00 7E
	btg	*0x00,num7	; 00 7E
	btg	extaddr,num7	;*00n7F
	btg	*extaddr,num7	;*00n7F
	btg	0x00,#num7	; 00 7E
	btg	*0x00,#num7	; 00 7E
	btg	extaddr,#num7	;*00n7F
	btg	*extaddr,#num7	;*00n7F

	movff	0x00,0x00	; 00 C0 00 F0
	movff	0x0FFF,0x00	; FF CF 00 F0
	movff	0x00,0x0FFF	; 00 C0 FF FF
	movff	0x0FFF,0x0FFF	; FF CF FF FF

	movff	0x00,*0x00	; 00 C0 00 F0
	movff	0x0FFF,*0x00	; FF CF 00 F0
	movff	0x00,*0x0FFF	; 00 C0 FF FF
	movff	0x0FFF,*0x0FFF	; FF CF FF FF

	movff	*0x00,0x00	; 00 C0 00 F0
	movff	*0x0FFF,*0x00	; FF CF 00 F0
	movff	*0x00,0x0FFF	; 00 C0 FF FF
	movff	*0x0FFF,*0x0FFF	; FF CF FF FF

	movff	*0x00,*0x00	; 00 C0 00 F0
	movff	*0x0FFF,*0x00	; FF CF 00 F0
	movff	*0x00,*0x0FFF	; 00 C0 FF FF
	movff	*0x0FFF,*0x0FFF	; FF CF FF FF

	movff	0x00,extaddr	; 00 C0u00vF0
	movff	0x0FFF,*extaddr	; FF CFu00vF0
	movff	extaddr,0x00	;u00vC0 00 F0
	movff	*extaddr,0x0FFF	;u00vC0 FF FF

	movff  extaddr,extaddr	;u00vC0u00vF0
	movff *extaddr,*extaddr	;u00vC0u00vF0

	bsf	0x00,0		; 00 80
	bsf	0xFF,0		;*FFn81
	bsf	extaddr,0	;*00n81

	bsf	0x00,7		; 00 8E
	bsf	0xFF,7		;*FFn8F
	bsf	extaddr,7	;*00n8F

	bsf	*0x00,0		; 00 80
	bsf	*0xFF,0		;*FFn81
	bsf	*extaddr,0	;*00n81

	bsf	*0x00,7		; 00 8E
	bsf	*0xFF,7		;*FFn8F
 	bsf	*extaddr,7	;*00n8F

	bsf	0x00,num0	; 00 80
	bsf	*0x00,num0	; 00 80
	bsf	extaddr,num0	;*00n81
	bsf	*extaddr,num0	;*00n81
	bsf	0x00,#num0	; 00 80
	bsf	*0x00,#num0	; 00 80
	bsf	extaddr,#num0	;*00n81
	bsf	*extaddr,#num0	;*00n81
	bsf	0x00,num7	; 00 8E
	bsf	*0x00,num7	; 00 8E
	bsf	extaddr,num7	;*00n8F
	bsf	*extaddr,num7	;*00n8F
	bsf	0x00,#num7	; 00 8E
	bsf	*0x00,#num7	; 00 8E
	bsf	extaddr,#num7	;*00n8F
	bsf	*extaddr,#num7	;*00n8F

	bcf	0x00,0		; 00 90
	bcf	0xFF,0		;*FFn91
	bcf	extaddr,0	;*00n91

	bcf	0x00,7		; 00 9E
	bcf	0xFF,7		;*FFn9F
	bcf	extaddr,7	;*00n9F

	bcf	*0x00,0		; 00 90
	bcf	*0xFF,0		;*FFn91
	bcf	*extaddr,0	;*00n91

	bcf	*0x00,7		; 00 9E
	bcf	*0xFF,7		;*FFn9F
	bcf	*extaddr,7	;*00n9F

	bcf	0x00,num0	; 00 90
	bcf	*0x00,num0	; 00 90
	bcf	extaddr,num0	;*00n91
	bcf	*extaddr,num0	;*00n91
	bcf	0x00,#num0	; 00 90
	bcf	*0x00,#num0	; 00 90
	bcf	extaddr,#num0	;*00n91
	bcf	*extaddr,#num0	;*00n91
	bcf	0x00,num7	; 00 9E
	bcf	*0x00,num7	; 00 9E
	bcf	extaddr,num7	;*00n9F
	bcf	*extaddr,num7	;*00n9F
	bcf	0x00,#num7	; 00 9E
	bcf	*0x00,#num7	; 00 9E
	bcf	extaddr,#num7	;*00n9F
	bcf	*extaddr,#num7	;*00n9F

	btfss	0x00,0		; 00 A0
	btfss	0xFF,0		;*FFnA1
	btfss	extaddr,0	;*00nA1

	btfss	0x00,7		; 00 AE
	btfss	0xFF,7		;*FFnAF
	btfss	extaddr,7	;*00nAF

	btfss	*0x00,0		; 00 A0
	btfss	*0xFF,0		;*FFnA1
	btfss	*extaddr,0	;*00nA1

	btfss	*0x00,7		; 00 AE
	btfss	*0xFF,7		;*FFnAF
	btfss	*extaddr,7	;*00nAF

	btfss	0x00,num0	; 00 A0
	btfss	*0x00,num0	; 00 A0
	btfss	extaddr,num0	;*00nA1
	btfss	*extaddr,num0	;*00nA1
	btfss	0x00,#num0	; 00 A0
	btfss	*0x00,#num0	; 00 A0
	btfss	extaddr,#num0	;*00nA1
	btfss	*extaddr,#num0	;*00nA1
	btfss	0x00,num7	; 00 AE
	btfss	*0x00,num7	; 00 AE
	btfss	extaddr,num7	;*00nAF
	btfss	*extaddr,num7	;*00nAF
	btfss	0x00,#num7	; 00 AE
	btfss	*0x00,#num7	; 00 AE
	btfss	extaddr,#num7	;*00nAF
	btfss	*extaddr,#num7	;*00nAF

	btfsc	0x00,0		; 00 B0
	btfsc	0xFF,0		;*FFnB1
	btfsc	extaddr,0	;*00nB1

	btfsc	0x00,7		; 00 BE
	btfsc	0xFF,7		;*FFnBF
	btfsc	extaddr,7	;*00nBF

	btfsc	*0x00,0		; 00 B0
	btfsc	*0xFF,0		;*FFnB1
	btfsc	*extaddr,0	;*00nB1

	btfsc	*0x00,7		; 00 BE
	btfsc	*0xFF,7		;*FFnBF
	btfsc	*extaddr,7	;*00nBF

	btfsc	0x00,num0	; 00 B0
	btfsc	*0x00,num0	; 00 B0
	btfsc	extaddr,num0	;*00nB1
	btfsc	*extaddr,num0	;*00nB1
	btfsc	0x00,#num0	; 00 B0
	btfsc	*0x00,#num0	; 00 B0
	btfsc	extaddr,#num0	;*00nB1
	btfsc	*extaddr,#num0	;*00nB1
	btfsc	0x00,num7	; 00 BE
	btfsc	*0x00,num7	; 00 BE
	btfsc	extaddr,num7	;*00nBF
	btfsc	*extaddr,num7	;*00nBF
	btfsc	0x00,#num7	; 00 BE
	btfsc	*0x00,#num7	; 00 BE
	btfsc	extaddr,#num7	;*00nBF
	btfsc	*extaddr,#num7	;*00nBF

	movlw	0x00		; 00 0E
	movlw	0xFF		; FF 0E
	movlw	extaddr		;r00s0E

	movlw	#0x00		; 00 0E
	movlw	#0xFF		; FF 0E
	movlw	#extaddr	;r00s0E

	addlw	0x00		; 00 0F
	addlw	0xFF		; FF 0F
	addlw	extaddr		;r00s0F

	addlw	#0x00		; 00 0F
	addlw	#0xFF		; FF 0F
	addlw	#extaddr	;r00s0F

	sublw	0x00		; 00 08
	sublw	0xFF		; FF 08
	sublw	extaddr		;r00s08

	sublw	#0x00		; 00 08
	sublw	#0xFF		; FF 08
	sublw	#extaddr	;r00s08

	iorlw	0x00		; 00 09
	iorlw	0xFF		; FF 09
	iorlw	extaddr		;r00s09

	iorlw	#0x00		; 00 09
	iorlw	#0xFF		; FF 09
	iorlw	#extaddr	;r00s09

	xorlw	0x00		; 00 0A
	xorlw	0xFF		; FF 0A
	xorlw	extaddr		;r00s0A

	xorlw	#0x00		; 00 0A
	xorlw	#0xFF		; FF 0A
	xorlw	#extaddr	;r00s0A

	andlw	0x00		; 00 0B
	andlw	0xFF		; FF 0B
	andlw	extaddr		;r00s0B

	andlw	#0x00		; 00 0B
	andlw	#0xFF		; FF 0B
	andlw	#extaddr	;r00s0B

	retlw	0x00		; 00 0C
	retlw	0xFF		; FF 0C
	retlw	extaddr		;r00s0C

	retlw	#0x00		; 00 0C
	retlw	#0xFF		; FF 0C
	retlw	#extaddr	;r00s0C

	movlb	0x00		; 00 01
	movlb	0x0F		; 0F 01
	movlb	extaddr		;r00s01

	movlb	#0x00		; 00 01
	movlb	#0x0F		; 0F 01
	movlb	#extaddr	;r00s01

	mullw	0x00		; 00 0D
	mullw	0xFF		; FF 0D
	mullw	extaddr		;r00s0D

	mullw	#0x00		; 00 0D
	mullw	#0xFF		; FF 0D
	mullw	#extaddr	;r00s0D

	;
	; ASxxxx Call, Goto, and Branching Mode
	;
	.picgoto	0 	; Default Mode

	goto	0x000000	; 00 EF 00 F0
	goto	0x00000F	; 07 EF 00 F0
	goto	0x0000FF	; 7F EF 00 F0
	goto	0x000FFF	; FF EF 07 F0
	goto	0x00FFFF	; FF EF 7F F0
	goto	0x0FFFFF	; FF EF FF F7
	goto	0x1FFFFF	; FF EF FF FF

	goto	addr_00		;r00sEFR00SF0
	goto	addr_0FFFFF	;rFFsEFRFFSF7
	goto	extaddr		;r00sEFR00SF0

	;
	; PIC Call, Goto, and Branching Mode
	;
	.picgoto	1 	; Compatibility Mode

	goto	0x000000	; 00 EF 00 F0
	goto	0x00000F	; 0F EF 00 F0
	goto	0x0000FF	; FF EF 00 F0
	goto	0x000FFF	; FF EF 0F F0
	goto	0x00FFFF	; FF EF FF F0
	goto	0x0FFFFF	; FF EF FF FF
	;goto	0x1FFFFF	; FF EF FF FF

	;goto	addr_00		;r00sEFR00SF0
	;goto	addr_0FFFFF	;rFFsEFRFFSF7
	;goto	extaddr		;r00sEFR00SF0

	;
	; ASxxxx Call, Goto, and Branching Mode
	;
	.picgoto	0 	; Default Mode

	call	0x000000	; 00 EC 00 F0
	call	0x00000F	; 07 EC 00 F0
	call	0x0000FF	; 7F EC 00 F0
	call	0x000FFF	; FF EC 07 F0
	call	0x00FFFF	; FF EC 7F F0
	call	0x0FFFFF	; FF EC FF F7
	call	0x1FFFFF	; FF EC FF FF

	call	addr_00		;r00sECR00SF0
	call	addr_0FFFFF	;rFFsECRFFSF7
	call	extaddr		;r00sECR00SF0

	;
	; PIC Call, Goto, and Branching Mode
	;
	.picgoto	1 	; Compatibility Mode

	call	0x000000	; 00 EC 00 F0
	call	0x00000F	; 0F EC 00 F0
	call	0x0000FF	; FF EC 00 F0
	call	0x000FFF	; FF EC 0F F0
	call	0x00FFFF	; FF EC FF F0
	call	0x0FFFFF	; FF EC FF FF
	;call	0x1FFFFF	; FF EC FF FF

	;call	addr_00		;r00sECR00SF0
	;call	addr_0FFFFF	;rFFsECRFFSF7
	;call	extaddr		;r00sECR00SF0

	;
	; Non Relocatable Branching
	;
	;
	; ASxxxx Call, Goto, and Branching Mode
	;
A:	.picgoto	0 	; Default Mode

	bnc	3$		; 02 E3
1$:	bnc	3$		; 01 E3
2$:	bnc	3$		; 00 E3

3$:	goto	0xA8642		; 21 EF 43 F5
	call	0xA8642		; 21 EC 43 F5


;a	bnc	4$		; 80 E3	; assembler relocation error
	bnc	4$		; 7F E3
	. = . + 0xFE
4$:
	. = . + 0xFE
	bnc	4$		; 80 E3
;a	bnc	4$		; 7F E3	; assembler relocation error


;a	bra	5$		; 00 D4	; assembler relocation error
	bra	5$		; FF D3
	. = . + 0x7FE
5$:
	. = . + 0x7FE
	bra	5$		; 00 D4
;a	bra	5$		; FF D3	; assembler relocation error

	;
	; PIC Call, Goto, and Branching Mode
	;
B:	.picgoto	1 	; Compatibility Mode

	bnc	2		; 02 E3
1$:	bnc	1		; 01 E3
2$:	bnc	0		; 00 E3

3$:	goto	0xA8642		; 42 EF 86 FA
	call	0xA8642		; 42 EC 86 FA


;a	bnc	128 + extaddr	;r80sE3	; assembler branching error
	bnc	127 + extaddr	;r7FsE3
	. = . + 0xFE
4$:
	. = . + 0xFE
	bnc	-128		; 80 E3
;a	bnc	-129		; 7F E3	; assembler relocation error


;a	bra	1024		; 00 D4	; assembler relocation error
	bra	1023		; FF D3
	. = . + 0x7FE
5$:
	. = . + 0x7FE
	bra	-1024 + extaddr	;r00sD4
;a	bra	-1025 + extaddr	;rFFsD3	; assembler relocation error

	;
	; Relocatable Branching
	;
	; The following cryptic code produces
	; the correct code values from the
	; assembler before linking and
	; after linker.
	;
C:	.picgoto	0 	; Default Mode

;L	bnc	exlbl6		;p80qE3	; linker relocation error
	bnc  lbl6f+(lbl6-(.+2))	;p7FqE3
	. = . + 0xFE
lbl6:
	. = . + 0xFE
	bnc  lbl6r+(lbl6-(.+2))	;p80qE3
;L	bnc	exlbl6		;p80qE3	; linker relocation error


;L	bra	exlbl7		;p00qD4	; linker relocation error
	bra  lbl7f+(lbl7-(.+2))	;pFFqD3
	. = . + 0x7FE
lbl7:
	. = . + 0x7FE
	bra  lbl7r+(lbl7-(.+2))	;p00qD4
;L	bra	exlbl7		;pFFqD3	; linker relocation error

	;
	; All pic18xxxx Instructions
	;
	addlw	extaddr		;r00s0F
	addwf	extaddr,w	;*00n25
	addwfc	extaddr,f	;*00n23
	andlw	extaddr		;r00s0B
	andwf	*extaddr,w	;*00n15

	bc	1$		; 0D E2
	bcf	0x12,7,0	; 12 9E
	bn	1$		; 0B E6
	bnc	1$		; 0A E3
	bnn	1$		; 09 E7
	bnov	1$		; 08 E5
	bnz	1$		; 07 E1
	bov	1$		; 06 E4
	bra	1$		; 05 D0
	bsf	0x12,7,0	; 12 8E
	btfsc	0x12,7,0	; 12 BE
	btfss	0x12,7,0	; 12 AE
	btg	0x12,7,0	; 12 7E
	bz	1$		; 00 E0

1$:	call	1$		;r47sECR21SF0
	clrf	extaddr		;*00n6B
	clrwdt			; 04 00
	comf	*0xFF,w		;*FFn1D
	cpfseq	*extaddr	;*00n63
	cpfsgt	0x00		; 00 64
	cpfslt	extaddr		;*00n61

	daw			; 07 00
	decf	0xFF,w		;*FFn05
	decfsz	*0x00,f		; 00 2E
	decfsz	0xFF,w		;*FFn2D

	goto	1$		;r47sEFR21SF0

	incf	extaddr,f	;*00n2B
	incfsz	extaddr,f	;*00n3F
	infsnz	*extaddr,w	;*00n49
	iorlw	#extaddr	;r00s09
	iorwf	*extaddr,w	;*00n11

	lfsr	2,#0x123	; 21 EE 23 F0

	movf	*0x12,0,0	; 12 50
	movff	0x0FFF,*0x00	; FF CF 00 F0
	movlb	0x0F		; 0F 01
	movlw	#extaddr	;r00s0E
	movwf	extaddr		;*00n6F
	mulwf	0x00		; 00 02
	mullw	#extaddr	;r00s0D

	negf	0x00		; 00 6C
	nop			; 00 00

	pop			; 06 00
	push			; 05 00

	rcall	1$		; DE DF
	retfie	1		; 11 00
	retlw	extaddr		;r00s0C
	return			; 12 00
	rlcf	0xFF,f		;*FFn37
	rlncf	*0xFF,w		;*FFn45
 	rrcf	*extaddr,f	;*00n33
	rrncf	*extaddr,w	;*00n41

	setf	*0xFF		;*FFn69
	sleep			; 03 00
	subfwb	0x12,0,0	; 12 54
	sublw	extaddr		;r00s08
	subwf	*0x12,0,0	; 12 5C
	subwfb	*0x00,w		; 00 58
	swapf	0xFF,w		;*FFn39

	tblrd			; 08 00
	tblwt			; 0C 00
	tstfsz	*0xFF		;*FFn67

	xorwf	extaddr,f	;*00n1B
	xorlw	0x00		; 00 0A

	; PIC18Fxxx Extended Instructions

	addfsr	2,#0x3F		; BF E8
	addulnk #0x3F		; FF E8
	callw			; 14 00
	movsf	*0x7F,*0xFFF	; 7F EB FF FF
	movss	*0x7F,*0x7F	; FF EB 7F F0
	pushl   #0x45		; 45 EA
	subfsr	2,#0x3F		; BF E9
	subulnk #0x3F		; FF E9

