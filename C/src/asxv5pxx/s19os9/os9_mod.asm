;	.sbttl	OS9 Module Header

	; This file: os9_mod.asm, is used to configure
	; one of the standard module formats for OS9.
	;
	; The following example can be built
	; using the file BldMod.asm::
	;
	;
	;	.title	os9_mod Test Assembly
	;
	;	OS9_Module = 2
	;  ;	.include	"os9_mod.asm"
	;
	;	.nlist
	;	.include	"os9_mod.asm"
	;	.list
	;

;[ This Statement NOT Required in a Normal Build
.ifeq	OS9_Module - 2		; Assemble this Module (Testing Only)
;[ This Statement NOT Required in a Normal Build
	.list

	;****
	;  LIST UTILITY COMMAND
	;  Syntax: list <pathname> 
	;  COPIES INPUT FROM SPECIFIED FILE TO STANDARD OUTPUT

	; Step 1:
	; Use the .define assembler directive
	; to insert the parameters into the
	; os9_mod.asm's header structure.
	;
	;	Note:	See the file os9_mod.asm for
	;		parameter names and definitions.
	;
	
	.define	OS9_ModNam,	"LSTNAM"
	.define	OS9_Typ,	"PRGRM"
	.define	OS9_Lng,	"OBJCT"
	.define	OS9_Att,	"REENT"
	.define	OS9_Rev,	"1"
	.define	OS9_ModExe,	"LSTENT"
	.define	OS9_ModMem,	"LSTMEM"
	
	; Step 2:
	; Set the symbol OS9_Module equal to 1
	; and .include the file os9_mod.asm.

	OS9_Module = 1		; OS9 Module Begin (==1)
;	.include	"os9_mod.asm"
	.nlist
	.include	"os9_mod.asm"
	.list

	; Step 3:
	; Allocate the storage in .area OS9_Data

	.area	OS9_Data

	; STATIC STORAGE OFFSETS 
	
	BUFSIZ	.equ	200	; size of input buffer
	
	Base = .
IPATH = . - Base
	.rmb	1		; input path number
PRMPTR = . - Base
	.rmb	2		; parameter pointer
BUFFER = . - Base
	.rmb	BUFSIZ		; allocate line buffer
	.rmb	200		; allocate stack
	.rmb	200		; room for parameter list
LSTMEM = . - Base
	
	; Step 4:
	; Insert the Module Code into .area OS9_Module

	.area	OS9_Module

LSTNAM:	.strs   "List"		; String with last byte or'd with 0x80
	
LSTENT:	stx	*PRMPTR		; save parameter ptr
	lda	#READ.		; select read access mode
	os9	I$OPEN		; open input file
	bcs	LIST50		; exit if error
	sta	*IPATH		; save input path number
	stx	*PRMPTR		; save updated param ptr
LIST20:	lda	*IPATH		; load input path number
	leax	*BUFFER,U	; load buffer pointer
	ldy	#BUFSIZ		; maximum bytes to read
	os9	I$READLN	; read line of input
	bcs	LIST30		; exit if error
	lda	#1		; load std. out. path #
	os9	I$WRITLN	; output line
	bcc	LIST20		; Repeat if no error
	bra	LIST50		; exit if error

LIST30:	cmpb	#E$EOF		; at end of file?
	bne	LIST50		; branch if not
	lda	*IPATH		; load input path number
	os9	I$CLOSE		; close input path
	bcs	LIST50		; ..exit if error
	ldx	*PRMPTR		; restore parameter ptr
	lda	,X
	cmpa	#0x0D		; End of parameter line?
	bne	LSTENT		; ..no, list next file
	clrb
LIST50:	os9	F$EXIT		; ... terminate

	; Step 5:
	; Set the symbol OS9_Module equal to 0
	; and .include the file os9_mod.asm.

	OS9_Module = 0			; OS9 Module End (==0)
;	.include	"os9_mod.asm"
	.nlist
	.include	"os9_mod.asm"
	.list

	.nlist
;[ This Statement NOT Required in a Normal Build
	OS9_Module = 2			; Restore Value
;[ This Statement NOT Required in a Normal Build
.endif

	; Include this file, os9_mod.asm, to define the
	; OS9 Module Header.  Preceeding the file Inclusion
	; the header parameters must be specified in a series
	; of define statements:
	;
	;   Basic Header:
	;
	;	.define	OS9_ModNam,	"Module_Name"
	;	.define	OS9_Typ,	"Type_Value"
	;	.define	OS9_Lng,	"Language_Value"
	;	.define	OS9_Att,	"Attributes_Value"
	;	.define	OS9_Rev,	"Revision_Value"
	;
	;   General Parameters:
	;	.define	OS9_ModExe,	"Module Entry Point Offset"
	;	.define	OS9_ModMem,	"Module Permanent Storage"
	;
	;   Device Driver Parameters:
        ;
	;	.define	OS9_Mod,	"Module Mode"
	;
	;   Descriptor Parameters:
	;
	;	.define	OS9_FMN,	"Device Driver Name Label"
	;	.define	OS9_DDR,	"Device Driver Name Label"
	;	.define	OS9_AbsAdr02,	"Device Absolute Address <23:16>"
	;	.define	OS9_AbsAdr01,	"Device Absolute Address <15:08>"
	;	.define	OS9_AbsAdr00,	"Device Absolute Address <07:00>"
	;	.define	OS9_Opt,	"Descriptor Option"
	;	.define	OS9_DType,	"Descriptor Data Type"
	;

.ifeq	OS9_Module - 1		; ==1: Begin OS9 Module
	.list

	.define	os9,	"swi2	.byte"	; os9 macro

	; Include OS9 Definition Files
	; os9_sys.def Listing Disabled
	.nlist
	.include	"os9_sys.def"
	.list
	; os9_mod.def Listing Disabled
	.nlist
	.include	"os9_mod.def"
	.list

	; Define The OS9 Module Bank and Areas.
	;
	; Place the module program code in area OS9_Module
	; and the module data in area OS9_Data.
	;

	.bank	OS9_Module	(BASE=0,FSFX=_OS9)
	.area	OS9_Module	(REL,CON,BANK=OS9_Module)

	.bank	OS9_Data	(BASE=0,FSFX=_DAT)
	.area	OS9_Data	(REL,CON,BANK=OS9_Data)


	.area	OS9_Module

	OS9_ModBgn = .

	.byte	OS9_ID0, OS9_ID1		; OS9 Module Sync Bytes
	.word	OS9_ModEnd - OS9_ModBgn		; Length (Includes 3 CRC Bytes)
	.word	OS9_ModNam - OS9_ModBgn		; Offset to Module Name String
	.byte	OS9_Typ | OS9_Lng		; Type / Language
	.byte	OS9_Att | OS9_Rev		; Attributes / Revision
	.byte	0xFF				; Header Parity
	.nlist

	; Plain Modules

	;
	; System
	;
  .ifeq	OS9_Typ - SYSTM
  	.list
	.word	OS9_ModExe - OS9_ModBgn		; Execution Entry Offset
	;	OS9_ModData			; Module Data
	.nlist
  .endif
	;
	; Program
	;
  .ifeq	OS9_Typ - PRGRM				; Program Module
  	.list
	.word	OS9_ModExe - OS9_ModBgn		; Execution Entry Offset
	.word	OS9_ModMem			; Storage Requirement
	;	OS9_ModData			; Module Data
	.nlist
  .endif
	;
	; Subroutine
	;
  .ifeq OS9_Typ - SBTRN				; Subroutine Module
	.list
	.word	OS9_ModExe - OS9_ModBgn		; Execution Entry Offset
	.word	OS9_ModMem			; Storage Requirement
	;	OS9_ModData			; Module Data
	.nlist
  .endif
	;
	; Driver
	;
  .ifeq	OS9_Typ - DRIVR				; Device Driver Module
	.list
	.word	OS9_ModExe - OS9_ModBgn		; Execution Entry Offset
	.word	OS9_ModMem			; Storage Requirement
	.byte	OS9_Mode			; Module Mode
	;	OS9_ModData			; Module Data
	.nlist
  .endif
	;
	; File Manager
	;
  .ifeq	OS9_Typ - FLMGR				; File Manager Module
	.list
	.word	OS9_ModExe - OS9_ModBgn		; Execution Entry Offset
	;	OS9_ModData			; Module Data
	.nlist
  .endif
	;
	; Descriptor
	;
  .ifeq OS9_Typ - DEVIC				; Device Descriptor Module
	.list
  	.word	OS9_FMN - OS9_ModBgn		; File Manager Name Offset
	.word	OS9_DDR - OS9_ModBgn		; Device Driver Name Offset
	.byte	OS9_DMode			; Device driver Mode / Capabilities
	.byte	OS9_AbsAdr02			; Device Absolute Address <23:16>
	.byte	OS9_AbsAdr01			; Device Absolute Address <15:08>
	.byte	OS9_AbsAdr00			; Device Absolute Address <07:00>
	.byte	OS9_Opt				; Device Options
	.byte	OS9_DType			; Device Type
	;	OS9_ModData			; Module Data
	.nlist
  .endif

.endif


.ifeq	OS9_Module				; ==0: End OS9 Module
	.list

	.area	OS9_Module

	; The 3-Byte Module CRC
	.byte	OS9_CRC0, OS9_CRC1, OS9_CRC2	; CRC (Initially the CRC Polynomial)

	OS9_ModEnd = .				; End of OS9 Module
	.nlist
.endif

