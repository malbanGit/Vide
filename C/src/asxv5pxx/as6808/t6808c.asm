	.title	AS6808 Assembler Control

	;***********************************************************
	; 	Overide T6806.ASM Stand Alone Option
	;***********************************************************

	I$C$D	=:	0

	;***********************************************************
	; 	AS6808 Assembler Control Options
	;***********************************************************

	NORMAL	=	1
	ERROR	=	0

	hc08test	=	NORMAL		; Basic 68HC08 Instructions
	hcs08test	=	NORMAL		; Basic 68HC08 Plus 68HCS08 Instructions
	hc05test	=	NORMAL		; BASIC 68HC05 (146805) Mode
	mc05test	=	NORMAL		; BASIC 6805 Mode


	.page
	;***********************************************************
	; 	68HCS08 Test
	;***********************************************************

	.hcs08

.if hcs08test
; normal testing
	.define		hc$s08,	""		; include 68HCS08 instructions
	  .define	hc$08,	""		; include 68HC08 instructions
	  .define	hc$05,	""		; include 68HC05 instructions
	.define		er$s08,	";ers08"	; exclude hsc08 instructions
	.define		er$08,	";er08"		; exclude hc08 instructions
	.define		er$05,	";er05"		; exclude hc05 instructions
.else
; error testing
	.define		hc$s08,	";hcs08"	; exclude 68HCS08 instructions
	  .define	hc$08,	";hc08"		; exclude 68HC08 instructions
	  .define	hc$05,	";hc05"		; exclude 68HC05 instructions
	.define		er$s08,	""		; include hsc08 instructions
	.define		er$08,	""		; include hc08 instructions
	.define		er$05,	""		; include hc05 instructions
.endif


	.title	68HCS08 Assembler Test

	.include	"t6808.asm"

	.undefine	hc$s08
	  .undefine	hc$08
	  .undefine	hc$05
	.undefine	er$s08
	.undefine	er$08
	.undefine	er$05


 	.page
	;***********************************************************
	; 	68HC08 Test
	;***********************************************************

	.hc08

.if hc08test
; normal testing
	.define		hc$s08,	";hcs08"	; exclude 68HCS08 instructions
	  .define	hc$08,	""		; include 68HC08 instructions
	  .define	hc$05,	""		; include 68HC05 instructions
	.define		er$s08,	";ers08"	; exclude hsc08 instructions
	.define		er$08,	";er08"		; exclude hc08 instructions
	.define		er$05,	";er05"		; exclude hc05 instructions
.else
; error testing
	.define		hc$s08,	";hcs08"	; exclude 68HCS08 instructions
	  .define	hc$08,	";hc08"		; exclude 68HC08 instructions
	  .define	hc$05,	";hc05"		; exclude 68HC05 instructions
	.define		er$s08,	""		; include hsc08 instructions
	.define		er$08,	""		; include hc08 instructions
	.define		er$05,	""		; include hc05 instructions
.endif


	.title	68HC08 Assembler Test

	.include	"t6808.asm"

	.undefine	hc$s08
	  .undefine	hc$08
	  .undefine	hc$05
	.undefine	er$s08
	.undefine	er$08
	.undefine	er$05


 	.page
	;***********************************************************
	; 	68HC05 Test
	;***********************************************************

	.hc05

.if hc05test
; normal testing
	.define		hc$s08,	";hcs08"	; exclude 68HCS08 instructions
	  .define	hc$08,	";hc08"		; exclude 68HC08 instructions
	  .define	hc$05,	""		; include 68HC05 instructions
	.define		er$s08,	";ers08"	; exclude hsc08 instructions
	.define		er$08,	";er08"		; exclude hc08 instructions
	.define		er$05,	";er05"		; exclude hc05 instructions
.else
; error testing
	.define		hc$s08,	";hcs08"	; exclude 68HCS08 instructions
	  .define	hc$08,	";hc08"		; exclude 68HC08 instructions
	  .define	hc$05,	";hc05"		; exclude 68HC05 instructions
	.define		er$s08,	""		; include hsc08 instructions
	.define		er$08,	""		; include hc08 instructions
	.define		er$05,	""		; include hc05 instructions
.endif


	.title	68HC05 Assembler Test

	.include	"t6808.asm"

	.undefine	hc$s08
	  .undefine	hc$08
	  .undefine	hc$05
	.undefine	er$s08
	.undefine	er$08
	.undefine	er$05



