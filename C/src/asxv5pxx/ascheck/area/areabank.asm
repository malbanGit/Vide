	.title	Area / Bank Tests

	.sbttl	Areas with non conflicting definitions

	; Define a Bank
	.bank	CODE1

	.area	Program1
	.area	Program1		(REL)
	.area	Program1		(CON)
	.area	Program1		(NOPAG)
	.area	Program1		(CSEG)
	.area	Program1		(BANK=CODE1)
	.area	Program1


	; Define a Bank
	.bank	CODE2

	.area	Program2
	.area	Program2		(ABS)
	.area	Program2		(OVR)
	.area	Program2		(PAG)
	.area	Program2		(DSEG)
	.area	Program2		(BANK=CODE2)
	.area	Program2


	.page
	.sbttl	Areas with conflicting definitions

	; Define a Bank
	.bank	CODE3

	.area	Program3
	.area	Program3		(REL)
	.area	Program3		(ABS)		; m
	.area	Program3		(CON)
	.area	Program3		(OVR)		; m
	.area	Program3		(NOPAG)
	.area	Program3		(PAG)		; m
	.area	Program3		(CSEG)
	.area	Program3		(DSEG)		; m
	.area	Program3		(BANK=CODE3)
	.area	Program3		(BANK=CODE1)	; m
	.area	Program3


	; Define a Bank
	.bank	CODE4

 	.area	Program4
	.area	Program4		(ABS)
	.area	Program4		(REL)		; m
	.area	Program4		(OVR)
	.area	Program4		(CON)		; m
	.area	Program4		(PAG)
	.area	Program4		(NOPAG)		; m
	.area	Program4		(DSEG)
	.area	Program4		(CSEG)		; m
	.area	Program4		(BANK=CODE4)
	.area	Program4		(BANK=CODE1)	; m
	.area	Program4


	.page
	.sbttl	Areas with forward Banks

	.area	Program5
	.area	Program5		(REL)
	.area	Program5		(CON)
	.area	Program5		(NOPAG)
	.area	Program5		(CSEG)
	.area	Program5		(BANK=CODE5)
	.area	Program5

	; Define a Bank
	.bank	CODE5

	.area	Program6
	.area	Program6		(ABS)
	.area	Program6		(OVR)
	.area	Program6		(PAG)
	.area	Program6		(DSEG)
	.area	Program6		(BANK=CODE6)
	.area	Program6

	; Define a Bank
	.bank	CODE6


	.page
	.sbttl	Bank with out conflicting definitions

	.bank	CB1
	.bank	CB1	(base = 0x4000)
	.bank	CB1	(size = 0x2000)
	.bank	CB1	(fsfx = _C1)
	.bank	CB1	(base = 0x4000, size = 0x2000, fsfx = _C1)
	.bank	CB1

	.bank	CB2
	.bank	CB2	(base = 0x2000, size = 0x4000, fsfx = _C2)
	.bank	CB2	(fsfx = _C2)
	.bank	CB2	(size = 0x4000)
	.bank	CB2	(base = 0x2000)
	.bank	CB2


	.page
	.sbttl	Bank with conflicting definitions

	.bank	CB3
	.bank	CB3	(base = 0x4000)
	.bank	CB3	(size = 0x2000)
	.bank	CB3	(fsfx = _C3)
	.bank	CB3	(base = 0x4000, size = 0x2000, fsfx = _C3)
	.bank	CB3
	.bank	CB3	(base = 0x3000)					; m
	.bank	CB3	(size = 0x3000)					; m
	.bank	CB3	(fsfx = _C3X)					; m
	.bank	CB3	(base = 0x3000, size = 0x3000, fsfx = _C3X)	; m
	.bank	CB3

	.bank	CB4
	.bank	CB4	(base = 0x2000, size = 0x4000, fsfx = _C4)
	.bank	CB4	(fsfx = _C4)
	.bank	CB4	(size = 0x4000)
	.bank	CB4	(base = 0x2000)
	.bank	CB4
	.bank	CB4	(base = 0x1000, size = 0x5000, fsfx = _C4X)	; m
	.bank	CB4	(fsfx = _C4X)					; m
	.bank	CB4	(size = 0x5000)					; m
	.bank	CB4	(base = 0x1000)					; m
	.bank	CB4


