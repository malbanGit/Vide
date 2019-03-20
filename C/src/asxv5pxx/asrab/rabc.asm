	.title	ASRAB Assembler Control

	NORMAL	=	1
	ERROR	=	0

	r2ktest		=	NORMAL
	z180test	=	NORMAL
	hd64test	=	NORMAL
	z80test		=	NORMAL


.if	gbltest

	.globl	offset
	.globl	n
	.globl	mn

.else

	offset	=	0x33		; arbitrary constants
	n	=	0x20
	mn	=	0x0584	        ; (0x05 << 8),ix | (0x84 << 0),ix
					;	m	     n
.endif

	.page
	;***********************************************************
	; 	Rabbit 2K/3K Test
	;***********************************************************

	.r2k

.if r2ktest
; normal testing
	.define		r$2k,	""		; include Rabbit 2K/3K instructions
	  .define	alt$y,	"altd"		; alternate register
	  .define	ioe$y,	"ioe"		; memory i/o
	  .define	ioi$y,	"ioi"		; internal i/o
	  .define	alt$n,	";o altd"	; no alternate register
	  .define	ioe$n,	";o ioe"	; no memory i/o
	  .define	ioi$n,	";o ioi"	; no internal i/o
	.define		hd$64,	";hd64"		; exclude hd64180 instructions
	.define		z80$b,	""		; include z80 base instructions
	.define		z80$x,	";z80"		; exclude z80 base instructions
	.define		err$y,	";a err"	; disable op code error checks
	.define		err$n,	";"		; disable op code error checks
;	.define		err$y,	""		; enable op code error checks
;	.define		err$n,	""		; enable op code error checks
.else
; error testing
	.define		r$2k,	""		; include Rabbit 2K/3K instructions
	  .define	alt$y,	"altd"		; alternate register
	  .define	ioe$y,	"ioe"		; memory i/o
	  .define	ioi$y,	"ioi"		; internal i/o
	  .define	alt$n,	"altd"		; alternate register
	  .define	ioe$n,	"ioe"		; memory i/o
	  .define	ioi$n,	"ioi"		; internal i/o
	.define		hd$64,	""		; include hd64180 instructions
	.define		z80$b,	""		; include z80 base instructions
	.define		z80$x,	""		; include z80 base instructions
	.define		err$y,	""		; enable op code error checks
	.define		err$n,	""		; enable op code error checks
.endif


	.title	Rabbit 2K/3K Assembler Test

r2k:	.include	"rab.asm"

	.undefine	r$2k
	  .undefine	alt$y
	  .undefine	ioe$y
	  .undefine	ioi$y
	  .undefine	alt$n
	  .undefine	ioe$n
	  .undefine	ioi$n
	.undefine	hd$64
	.undefine	z80$b
	.undefine	z80$x
	.undefine	err$y
	.undefine	err$n


 	.page
	;***********************************************************
	; 	Z180 Test
	;***********************************************************

	.z180

.if z180test
; normal testing
	.define		r$2k,	";r2k"		; exclude Rabbit 2K/3K instructions
	  .define	alt$y,	";o altd"	; no alternate register
	  .define	ioe$y,	";o ioe"	; no memory i/o
	  .define	ioi$y,	";o ioi"	; no internal i/o
	  .define	alt$n,	";o altd"	; no alternate register
	  .define	ioe$n,	";o ioe"	; no memory i/o
	  .define	ioi$n,	";o ioi"	; no internal i/o
	.define		hd$64,	""		; include hd64180 instructions
	.define		z80$b,	""		; include z80 base instructions
	.define		z80$x,	""		; include z80 base instructions
	.define		err$y,	";a err"	; disable op code error checks
	.define		err$n,	";"		; disable op code error checks
;	.define		err$y,	""		; enable op code error checks
;	.define		err$n,	""		; enable op code error checks
.else
; error testing
	.define		r$2k,	""		; include Rabbit 2K/3K instructions
	  .define	alt$y,	"altd"		; alternate register
	  .define	ioe$y,	"ioe"		; memory i/o
	  .define	ioi$y,	"ioi"		; internal i/o
	  .define	alt$n,	"altd"		; alternate register
	  .define	ioe$n,	"ioe"		; memory i/o
	  .define	ioi$n,	"ioi"		; internal i/o
	.define		hd$64,	""		; include hd64180 instructions
	.define		z80$b,	""		; include z80 base instructions
	.define		z80$x,	""		; include z80 base instructions
	.define		err$y,	""		; enable op code error checks
	.define		err$n,	""		; enable op code error checks
.endif


	.title	Z180 Assembler Test

z180:	.include	"rab.asm"

	.undefine	r$2k
	  .undefine	alt$y
	  .undefine	ioe$y
	  .undefine	ioi$y
	  .undefine	alt$n
	  .undefine	ioe$n
	  .undefine	ioi$n
	.undefine	hd$64
	.undefine	z80$b
	.undefine	z80$x
	.undefine	err$y
	.undefine	err$n


 	.page
	;***********************************************************
	; 	HD64180 Test
	;***********************************************************

	.hd64

.if hd64test
; normal testing
	.define		r$2k,	";r2k"		; exclude Rabbit 2K/3K instructions
	  .define	alt$y,	";o altd"	; no alternate register
	  .define	ioe$y,	";o ioe"	; no memory i/o
	  .define	ioi$y,	";o ioi"	; no internal i/o
	  .define	alt$n,	";o altd"	; no alternate register
	  .define	ioe$n,	";o ioe"	; no memory i/o
	  .define	ioi$n,	";o ioi"	; no internal i/o
	.define		hd$64,	""		; include hd64180 instructions
	.define		z80$b,	""		; include z80 base instructions
	.define		z80$x,	""		; include z80 base instructions
	.define		err$y,	";a err"	; disable op code error checks
	.define		err$n,	";"		; disable op code error checks
;	.define		err$y,	""		; enable op code error checks
;	.define		err$n,	""		; enable op code error checks
.else
; error testing
	.define		r$2k,	""		; include Rabbit 2K/3K instructions
	  .define	alt$y,	"altd"		; alternate register
	  .define	ioe$y,	"ioe"		; memory i/o
	  .define	ioi$y,	"ioi"		; internal i/o
	  .define	alt$n,	"altd"		; alternate register
	  .define	ioe$n,	"ioe"		; memory i/o
	  .define	ioi$n,	"ioi"		; internal i/o
	.define		hd$64,	""		; include hd64180 instructions
	.define		z80$b,	""		; include z80 base instructions
	.define		z80$x,	""		; include z80 base instructions
	.define		err$y,	""		; enable op code error checks
	.define		err$n,	""		; enable op code error checks
.endif


	.title	HD64180 Assembler Test

hd64:	.include	"rab.asm"

	.undefine	r$2k
	  .undefine	alt$y
	  .undefine	ioe$y
	  .undefine	ioi$y
	  .undefine	alt$n
	  .undefine	ioe$n
	  .undefine	ioi$n
	.undefine	hd$64
	.undefine	z80$b
	.undefine	z80$x
	.undefine	err$y
	.undefine	err$n


	.page
	;***********************************************************
	; 	Z80 Test
	;***********************************************************

	.z80

.if z80test
; normal testing
	.define		r$2k,	";r2k"		; exclude Rabbit 2K/3K instructions
	  .define	alt$y,	";o altd"	; no alternate register
	  .define	ioe$y,	";o ioe"	; no memory i/o
	  .define	ioi$y,	";o ioi"	; no internal i/o
	  .define	alt$n,	";o altd"	; no alternate register
	  .define	ioe$n,	";o ioe"	; no memory i/o
	  .define	ioi$n	";o ioi"	; no internal i/o
	.define		hd$64,	";hd64"		; exclude hd64180 instructions
	.define		z80$b,	""		; include z80 base instructions
	.define		z80$x,	""		; include z80 base instructions
	.define		err$y,	";a err"	; disable op code error checks
	.define		err$n,	";"		; disable op code error checks
;	.define		err$y,	""		; enable op code error checks
;	.define		err$n,	""		; enable op code error checks
.else
; error testing
	.define		r$2k,	""		; include Rabbit 2K/3K instructions
	  .define	alt$y,	"altd"		; alternate register
	  .define	ioe$y,	"ioe"		; memory i/o
	  .define	ioi$y,	"ioi"		; internal i/o
	  .define	alt$n,	"altd"		; alternate register
	  .define	ioe$n,	"ioe"		; memory i/o
	  .define	ioi$n,	"ioi"		; internal i/o
	.define		hd$64,	""		; include hd64180 instructions
	.define		z80$b,	""		; include z80 base instructions
	.define		z80$x,	""		; include z80 base instructions
	.define		err$y,	""		; enable op code error checks
	.define		err$n,	""		; enable op code error checks
.endif


	.title	Z80 Assembler Test

z80:	.include	"rab.asm"

	.undefine	r$2k
	  .undefine	alt$y
	  .undefine	ioe$y
	  .undefine	ioi$y
	  .undefine	alt$n
	  .undefine	ioe$n
	  .undefine	ioi$n
	.undefine	hd$64
	.undefine	z80$b
	.undefine	z80$x
	.undefine	err$y
	.undefine	err$n


