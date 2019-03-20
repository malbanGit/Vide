	.title	Area / Bank Tests

	.module	BankFile

	.sbttl	Define Banks and Areas

	.area	NOBANK

	.bank	CODE1		(size = 8, fsfx = _C1)
	.area	C1		(REL,CON,CSEG,BANK=CODE1)

	.bank	DATA1		(fsfx = _D1)
	.area	D1		(REL,CON,DSEG,BANK=DATA1)

	.bank	CODE2		(fsfx = _C2)
	.area	C2		(REL,CON,CSEG,BANK=CODE2)

	.bank	DATA2		(fsfx = _D2)
	.area	D2		(REL,CON,DSEG,BANK=DATA2)


	.sbttl	Some Data in Each Area

	.area	NOBANK

	. = . + 0x0100
LBL_NB:
	.byte	0x00


	.area	C1

	. = . + 0x0200
LBL_C1:
	.word	0x0201
	.word	0x0403


	.area	D1

	. = . + 0x0300
LBL_D1:
	.byte	0x05
	.byte	0x06
	.byte	0x07


	.area	C2

	. = . + 0x0400
LBL_C2:
	.word	0x0908
	.word	0x0B0A


	.area	D2

	. = . + 0x0500
LBL_D2:
	.byte	0x0C
	.byte	0x0D
	.byte	0x0E


	.area	C1

LBL_C1_1:
	.word	0x0100,	0x0302,	0x0504,	0x0706,	0x0908,	0x0B0A,	0x0D0C,	0x0F0E


	.page
	.sbttl	Banking Areas

	.bank	system	(base = 0x1000, size = 0x1000, fsfx = _S)

	.area	s1	(CSEG, bank = system)
	.area	s2	(DSEG, bank = system)
	.area	s3	(CSEG, bank = system)
	.area	s4	(DSEG, bank = system)

	.area	s1

	.word	0x0201

	.area	s2

	.byte	0x03

	.area	s3

	.byte	0x04

	.area	s4

	.byte	0x05


