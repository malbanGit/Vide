	.title	68HC16 Assembler Test

	.module t6816

	; This file should be assembled as follows:
	;
	; as6816 -xlff t6816
	;

	imm8	=	0x01
	imm16	=	0x2345
	ind8	=	0x12
	ind16	=	0x3456
	ix	=	0x06
	iy	=	0x07
	ixiy	=	0x89
	mask8	=	0x78
	mask16	=	0x9ABC

	address	=	0x1122
	bnk	=	0x03

	.globl	ebnk
	.globl	eixiy
	.globl	external
	.globl	emsk8
	.globl	emsk16
	.globl	num8
	.globl	num16
	.globl	offset8
	.globl	offset16

	aba			;37 0B
	abx			;37 4F
	aby			;37 5F
	abz			;37 6F
	ace			;37 22
	aced			;37 23

	adca	,x		;43 00
	adca	,y		;53 00
	adca	,z		;63 00
	adca	,x8		;43 00
	adca	,y8		;53 00
	adca	,z8		;63 00
	adca	,x16		;17 43 00 00
	adca	,y16		;17 53 00 00
	adca	,z16		;17 63 00 00
	adca	offset8,x8	;43u00
	adca	offset8,y8	;53u00
	adca	offset8,z8	;63u00
	adca	ind8,x8		;43 12
	adca	ind8,y8		;53 12
	adca	ind8,z8		;63 12
	adca	ind8,x		;43 12
	adca	ind8,y		;53 12
	adca	ind8,z		;63 12
	adca	#imm8		;73 01
	adca	#num8		;73r00
	adca	offset16,x16	;17 43s00r00
	adca	offset16,y16	;17 53s00r00
	adca	offset16,z16	;17 63s00r00
	adca	offset16,x	;17 43s00r00
	adca	offset16,y	;17 53s00r00
	adca	offset16,z	;17 63s00r00
	adca	ind16,x16	;17 43 34 56
	adca	ind16,y16	;17 53 34 56
	adca	ind16,z16	;17 63 34 56
	adca	ind16,x		;17 43 34 56
	adca	ind16,y		;17 53 34 56
	adca	ind16,z		;17 63 34 56
	adca	address		;17 73 11 22
	adca	external	;17 73s00r00
	adca	e,x		;27 43
	adca	e,y		;27 53
	adca	e,z		;27 63

	adcb	,x		;C3 00
	adcb	,y		;D3 00
	adcb	,z		;E3 00
	adcb	,x8		;C3 00
	adcb	,y8		;D3 00
	adcb	,z8		;E3 00
	adcb	,x16		;17 C3 00 00
	adcb	,y16		;17 D3 00 00
	adcb	,z16		;17 E3 00 00
	adcb	offset8,x8	;C3u00
	adcb	offset8,y8	;D3u00
	adcb	offset8,z8	;E3u00
	adcb	ind8,x8		;C3 12
	adcb	ind8,y8		;D3 12
	adcb	ind8,z8		;E3 12
	adcb	ind8,x		;C3 12
	adcb	ind8,y		;D3 12
	adcb	ind8,z		;E3 12
	adcb	#imm8		;F3 01
	adcb	#num8		;F3r00
	adcb	offset16,x16	;17 C3s00r00
	adcb	offset16,y16	;17 D3s00r00
	adcb	offset16,z16	;17 E3s00r00
	adcb	offset16,x	;17 C3s00r00
	adcb	offset16,y	;17 D3s00r00
	adcb	offset16,z	;17 E3s00r00
	adcb	ind16,x16	;17 C3 34 56
	adcb	ind16,y16	;17 D3 34 56
	adcb	ind16,z16	;17 E3 34 56
	adcb	ind16,x		;17 C3 34 56
	adcb	ind16,y		;17 D3 34 56
	adcb	ind16,z		;17 E3 34 56
	adcb	address		;17 F3 11 22
	adcb	external	;17 F3s00r00
	adcb	e,x		;27 C3
	adcb	e,y		;27 D3
	adcb	e,z		;27 E3

	adcd	,x		;83 00
	adcd	,y		;93 00
	adcd	,z		;A3 00
	adcd	,x8		;83 00
	adcd	,y8		;93 00
	adcd	,z8		;A3 00
	adcd	,x16		;37 C3 00 00
	adcd	,y16		;37 D3 00 00
	adcd	,z16		;37 E3 00 00
	adcd	offset8,x8	;83u00
	adcd	offset8,y8	;93u00
	adcd	offset8,z8	;A3u00
	adcd	ind8,x8		;83 12
	adcd	ind8,y8		;93 12
	adcd	ind8,z8		;A3 12
	adcd	ind8,x		;83 12
	adcd	ind8,y		;93 12
	adcd	ind8,z		;A3 12
	adcd	#imm16		;37 B3 23 45
	adcd	#num16		;37 B3s00r00
	adcd	offset16,x16	;37 C3s00r00
	adcd	offset16,y16	;37 D3s00r00
	adcd	offset16,z16	;37 E3s00r00
	adcd	offset16,x	;37 C3s00r00
	adcd	offset16,y	;37 D3s00r00
	adcd	offset16,z	;37 E3s00r00
	adcd	ind16,x16	;37 C3 34 56
	adcd	ind16,y16	;37 D3 34 56
	adcd	ind16,z16	;37 E3 34 56
	adcd	ind16,x		;37 C3 34 56
	adcd	ind16,y		;37 D3 34 56
	adcd	ind16,z		;37 E3 34 56
	adcd	address		;37 F3 11 22
	adcd	external	;37 F3s00r00
	adcd	e,x		;27 83
	adcd	e,y		;27 93
	adcd	e,z		;27 A3

	adce	#imm16		;37 33 23 45
	adce	#num16		;37 33s00r00
	adce	,x		;37 43 00 00
	adce	,y		;37 53 00 00
	adce	,z		;37 63 00 00
	adce	,x16		;37 43 00 00
	adce	,y16		;37 53 00 00
	adce	,z16		;37 63 00 00
	adce	offset16,x16	;37 43s00r00
	adce	offset16,y16	;37 53s00r00
	adce	offset16,z16	;37 63s00r00
	adce	offset16,x	;37 43s00r00
	adce	offset16,y	;37 53s00r00
	adce	offset16,z	;37 63s00r00
	adce	ind16,x16	;37 43 34 56
	adce	ind16,y16	;37 53 34 56
	adce	ind16,z16	;37 63 34 56
	adce	ind16,x		;37 43 34 56
	adce	ind16,y		;37 53 34 56
	adce	ind16,z		;37 63 34 56
	adce	address		;37 73 11 22
	adce	external	;37 73s00r00

	adda	,x		;41 00
	adda	,y		;51 00
	adda	,z		;61 00
	adda	,x8		;41 00
	adda	,y8		;51 00
	adda	,z8		;61 00
	adda	,x16		;17 41 00 00
	adda	,y16		;17 51 00 00
	adda	,z16		;17 61 00 00
	adda	offset8,x8	;41u00
	adda	offset8,y8	;51u00
	adda	offset8,z8	;61u00
	adda	ind8,x8		;41 12
	adda	ind8,y8		;51 12
	adda	ind8,z8		;61 12
	adda	ind8,x		;41 12
	adda	ind8,y		;51 12
	adda	ind8,z		;61 12
	adda	#imm8		;71 01
	adda	#num8		;71r00
	adda	offset16,x16	;17 41s00r00
	adda	offset16,y16	;17 51s00r00
	adda	offset16,z16	;17 61s00r00
	adda	offset16,x	;17 41s00r00
	adda	offset16,y	;17 51s00r00
	adda	offset16,z	;17 61s00r00
	adda	ind16,x16	;17 41 34 56
	adda	ind16,y16	;17 51 34 56
	adda	ind16,z16	;17 61 34 56
	adda	ind16,x		;17 41 34 56
	adda	ind16,y		;17 51 34 56
	adda	ind16,z		;17 61 34 56
	adda	address		;17 71 11 22
	adda	external	;17 71s00r00
	adda	e,x		;27 41
	adda	e,y		;27 51
	adda	e,z		;27 61

	addb	,x		;C1 00
	addb	,y		;D1 00
	addb	,z		;E1 00
	addb	,x8		;C1 00
	addb	,y8		;D1 00
	addb	,z8		;E1 00
	addb	,x16		;17 C1 00 00
	addb	,y16		;17 D1 00 00
	addb	,z16		;17 E1 00 00
	addb	offset8,x8	;C1u00
	addb	offset8,y8	;D1u00
	addb	offset8,z8	;E1u00
	addb	ind8,x8		;C1 12
	addb	ind8,y8		;D1 12
	addb	ind8,z8		;E1 12
	addb	ind8,x		;C1 12
	addb	ind8,y		;D1 12
	addb	ind8,z		;E1 12
	addb	#imm8		;F1 01
	addb	#num8		;F1r00
	addb	offset16,x16	;17 C1s00r00
	addb	offset16,y16	;17 D1s00r00
	addb	offset16,z16	;17 E1s00r00
	addb	offset16,x	;17 C1s00r00
	addb	offset16,y	;17 D1s00r00
	addb	offset16,z	;17 E1s00r00
	addb	ind16,x16	;17 C1 34 56
	addb	ind16,y16	;17 D1 34 56
	addb	ind16,z16	;17 E1 34 56
	addb	ind16,x		;17 C1 34 56
	addb	ind16,y		;17 D1 34 56
	addb	ind16,z		;17 E1 34 56
	addb	address		;17 F1 11 22
	addb	external	;17 F1s00r00
	addb	e,x		;27 C1
	addb	e,y		;27 D1
	addb	e,z		;27 E1

	addd	#imm8		;FC 01
	addd	#num8		;37 B1s00r00
	addd	,x		;81 00
	addd	,y		;91 00
	addd	,z		;A1 00
	addd	,x8		;81 00
	addd	,y8		;91 00
	addd	,z8		;A1 00
	addd	,x16		;37 C1 00 00
	addd	,y16		;37 D1 00 00
	addd	,z16		;37 E1 00 00
	addd	offset8,x8	;81u00
	addd	offset8,y8	;91u00
	addd	offset8,z8	;A1u00
	addd	ind8,x8		;81 12
	addd	ind8,y8		;91 12
	addd	ind8,z8		;A1 12
	addd	ind8,x		;81 12
	addd	ind8,y		;91 12
	addd	ind8,z		;A1 12
	addd	#imm16		;37 B1 23 45
	addd	#num16		;37 B1s00r00
	addd	offset16,x16	;37 C1s00r00
	addd	offset16,y16	;37 D1s00r00
	addd	offset16,z16	;37 E1s00r00
	addd	offset16,x	;37 C1s00r00
	addd	offset16,y	;37 D1s00r00
	addd	offset16,z	;37 E1s00r00
	addd	ind16,x16	;37 C1 34 56
	addd	ind16,y16	;37 D1 34 56
	addd	ind16,z16	;37 E1 34 56
	addd	ind16,x		;37 C1 34 56
	addd	ind16,y		;37 D1 34 56
	addd	ind16,z		;37 E1 34 56
	addd	address		;37 F1 11 22
	addd	external	;37 F1s00r00
	addd	e,x		;27 81
	addd	e,y		;27 91
	addd	e,z		;27 A1

	adde	#imm8		;7C 01
	adde	#num8		;37 31s00r00
	adde	#imm16		;37 31 23 45
	adde	#num16		;37 31s00r00
	adde	,x		;37 41 00 00
	adde	,y		;37 51 00 00
	adde	,z		;37 61 00 00
	adde	,x16		;37 41 00 00
	adde	,y16		;37 51 00 00
	adde	,z16		;37 61 00 00
	adde	offset16,x16	;37 41s00r00
	adde	offset16,y16	;37 51s00r00
	adde	offset16,z16	;37 61s00r00
	adde	offset16,x	;37 41s00r00
	adde	offset16,y	;37 51s00r00
	adde	offset16,z	;37 61s00r00
	adde	ind16,x16	;37 41 34 56
	adde	ind16,y16	;37 51 34 56
	adde	ind16,z16	;37 61 34 56
	adde	ind16,x		;37 41 34 56
	adde	ind16,y		;37 51 34 56
	adde	ind16,z		;37 61 34 56
	adde	address		;37 71 11 22
	adde	external	;37 71s00r00

	ade			;27 78
	adx			;37 CD
	ady			;37 DD
	adz			;37 ED
	aex			;37 4D
	aey			;37 5D
	aez			;37 6D

	ais	#imm8		;3F 01
	ais	#num8		;37 3Fs00r00
	ais	#imm16		;37 3F 23 45
	ais	#num16		;37 3Fs00r00

	aix	#imm8		;3C 01
	aix	#num8		;37 3Cs00r00
	aix	#imm16		;37 3C 23 45
	aix	#num16		;37 3Cs00r00

	aiy	#imm8		;3D 01
	aiy	#num8		;37 3Ds00r00
	aiy	#imm16		;37 3D 23 45
	aiy	#num16		;37 3Ds00r00

	aiz	#imm8		;3E 01
	aiz	#num8		;37 3Es00r00
	aiz	#imm16		;37 3E 23 45
	aiz	#num16		;37 3Es00r00

	anda	,x		;46 00
	anda	,y		;56 00
	anda	,z		;66 00
	anda	,x8		;46 00
	anda	,y8		;56 00
	anda	,z8		;66 00
	anda	,x16		;17 46 00 00
	anda	,y16		;17 56 00 00
	anda	,z16		;17 66 00 00
	anda	offset8,x8	;46u00
	anda	offset8,y8	;56u00
	anda	offset8,z8	;66u00
	anda	ind8,x8		;46 12
	anda	ind8,y8		;56 12
	anda	ind8,z8		;66 12
	anda	ind8,x		;46 12
	anda	ind8,y		;56 12
	anda	ind8,z		;66 12
	anda	#imm8		;76 01
	anda	#num8		;76r00
	anda	offset16,x16	;17 46s00r00
	anda	offset16,y16	;17 56s00r00
	anda	offset16,z16	;17 66s00r00
	anda	offset16,x	;17 46s00r00
	anda	offset16,y	;17 56s00r00
	anda	offset16,z	;17 66s00r00
	anda	ind16,x16	;17 46 34 56
	anda	ind16,y16	;17 56 34 56
	anda	ind16,z16	;17 66 34 56
	anda	ind16,x		;17 46 34 56
	anda	ind16,y		;17 56 34 56
	anda	ind16,z		;17 66 34 56
	anda	address		;17 76 11 22
	anda	external	;17 76s00r00
	anda	e,x		;27 46
	anda	e,y		;27 56
	anda	e,z		;27 66

	andb	,x		;C6 00
	andb	,y		;D6 00
	andb	,z		;E6 00
	andb	,x8		;C6 00
	andb	,y8		;D6 00
	andb	,z8		;E6 00
	andb	,x16		;17 C6 00 00
	andb	,y16		;17 D6 00 00
	andb	,z16		;17 E6 00 00
	andb	offset8,x8	;C6u00
	andb	offset8,y8	;D6u00
	andb	offset8,z8	;E6u00
	andb	ind8,x8		;C6 12
	andb	ind8,y8		;D6 12
	andb	ind8,z8		;E6 12
	andb	ind8,x		;C6 12
	andb	ind8,y		;D6 12
	andb	ind8,z		;E6 12
	andb	#imm8		;F6 01
	andb	#num8		;F6r00
	andb	offset16,x16	;17 C6s00r00
	andb	offset16,y16	;17 D6s00r00
	andb	offset16,z16	;17 E6s00r00
	andb	offset16,x	;17 C6s00r00
	andb	offset16,y	;17 D6s00r00
	andb	offset16,z	;17 E6s00r00
	andb	ind16,x16	;17 C6 34 56
	andb	ind16,y16	;17 D6 34 56
	andb	ind16,z16	;17 E6 34 56
	andb	ind16,x		;17 C6 34 56
	andb	ind16,y		;17 D6 34 56
	andb	ind16,z		;17 E6 34 56
	andb	address		;17 F6 11 22
	andb	external	;17 F6s00r00
	andb	e,x		;27 C6
	andb	e,y		;27 D6
	andb	e,z		;27 E6

	andd	,x		;86 00
	andd	,y		;96 00
	andd	,z		;A6 00
	andd	,x8		;86 00
	andd	,y8		;96 00
	andd	,z8		;A6 00
	andd	,x16		;37 C6 00 00
	andd	,y16		;37 D6 00 00
	andd	,z16		;37 E6 00 00
	andd	offset8,x8	;86u00
	andd	offset8,y8	;96u00
	andd	offset8,z8	;A6u00
	andd	ind8,x8		;86 12
	andd	ind8,y8		;96 12
	andd	ind8,z8		;A6 12
	andd	ind8,x		;86 12
	andd	ind8,y		;96 12
	andd	ind8,z		;A6 12
	andd	#imm16		;37 B6 23 45
	andd	#num16		;37 B6s00r00
	andd	offset16,x16	;37 C6s00r00
	andd	offset16,y16	;37 D6s00r00
	andd	offset16,z16	;37 E6s00r00
	andd	offset16,x	;37 C6s00r00
	andd	offset16,y	;37 D6s00r00
	andd	offset16,z	;37 E6s00r00
	andd	ind16,x16	;37 C6 34 56
	andd	ind16,y16	;37 D6 34 56
	andd	ind16,z16	;37 E6 34 56
	andd	ind16,x		;37 C6 34 56
	andd	ind16,y		;37 D6 34 56
	andd	ind16,z		;37 E6 34 56
	andd	address		;37 F6 11 22
	andd	external	;37 F6s00r00
	andd	e,x		;27 86
	andd	e,y		;27 96
	andd	e,z		;27 A6

	ande	#imm16		;37 36 23 45
	ande	#num16		;37 36s00r00
	ande	,x		;37 46 00 00
	ande	,y		;37 56 00 00
	ande	,z		;37 66 00 00
	ande	,x16		;37 46 00 00
	ande	,y16		;37 56 00 00
	ande	,z16		;37 66 00 00
	ande	offset16,x16	;37 46s00r00
	ande	offset16,y16	;37 56s00r00
	ande	offset16,z16	;37 66s00r00
	ande	offset16,x	;37 46s00r00
	ande	offset16,y	;37 56s00r00
	ande	offset16,z	;37 66s00r00
	ande	ind16,x16	;37 46 34 56
	ande	ind16,y16	;37 56 34 56
	ande	ind16,z16	;37 66 34 56
	ande	ind16,x		;37 46 34 56
	ande	ind16,y		;37 56 34 56
	ande	ind16,z		;37 66 34 56
	ande	address		;37 76 11 22
	ande	external	;37 76s00r00

	andp	#imm8		;37 3A 00 01
	andp	#num8		;37 3As00r00
	andp	#imm16		;37 3A 23 45
	andp	#num16		;37 3As00r00

	asl	,x		;04 00
	asl	,y		;14 00
	asl	,z		;24 00
	asl	,x8		;04 00
	asl	,y8		;14 00
	asl	,z8		;24 00
	asl	,x16		;17 04 00 00
	asl	,y16		;17 14 00 00
	asl	,z16		;17 24 00 00
	asl	offset8,x8	;04u00
	asl	offset8,y8	;14u00
	asl	offset8,z8	;24u00
	asl	ind8,x8		;04 12
	asl	ind8,y8		;14 12
	asl	ind8,z8		;24 12
	asl	ind8,x		;04 12
	asl	ind8,y		;14 12
	asl	ind8,z		;24 12
	asl	offset16,x16	;17 04s00r00
	asl	offset16,y16	;17 14s00r00
	asl	offset16,z16	;17 24s00r00
	asl	offset16,x	;17 04s00r00
	asl	offset16,y	;17 14s00r00
	asl	offset16,z	;17 24s00r00
	asl	ind16,x16	;17 04 34 56
	asl	ind16,y16	;17 14 34 56
	asl	ind16,z16	;17 24 34 56
	asl	ind16,x		;17 04 34 56
	asl	ind16,y		;17 14 34 56
	asl	ind16,z		;17 24 34 56
	asl	address		;17 34 11 22
	asl	external	;17 34s00r00

	asla			;37 04
	aslb			;37 14
	asld			;27 F4
	asle			;27 74
	aslm			;27 B6

	aslw	,x		;27 04 00 00
	aslw	,y		;27 14 00 00
	aslw	,z		;27 24 00 00
	aslw	,x16		;27 04 00 00
	aslw	,y16		;27 14 00 00
	aslw	,z16		;27 24 00 00
	aslw	offset16,x16	;27 04s00r00
	aslw	offset16,y16	;27 14s00r00
	aslw	offset16,z16	;27 24s00r00
	aslw	offset16,x	;27 04s00r00
	aslw	offset16,y	;27 14s00r00
	aslw	offset16,z	;27 24s00r00
	aslw	ind16,x16	;27 04 34 56
	aslw	ind16,y16	;27 14 34 56
	aslw	ind16,z16	;27 24 34 56
	aslw	ind16,x		;27 04 34 56
	aslw	ind16,y		;27 14 34 56
	aslw	ind16,z		;27 24 34 56
	aslw	address		;27 34 11 22
	aslw	external	;27 34s00r00

	asr	,x		;0D 00
	asr	,y		;1D 00
	asr	,z		;2D 00
	asr	,x8		;0D 00
	asr	,y8		;1D 00
	asr	,z8		;2D 00
	asr	,x16		;17 0D 00 00
	asr	,y16		;17 1D 00 00
	asr	,z16		;17 2D 00 00
	asr	offset8,x8	;0Du00
	asr	offset8,y8	;1Du00
	asr	offset8,z8	;2Du00
	asr	ind8,x8		;0D 12
	asr	ind8,y8		;1D 12
	asr	ind8,z8		;2D 12
	asr	ind8,x		;0D 12
	asr	ind8,y		;1D 12
	asr	ind8,z		;2D 12
	asr	offset16,x16	;17 0Ds00r00
	asr	offset16,y16	;17 1Ds00r00
	asr	offset16,z16	;17 2Ds00r00
	asr	offset16,x	;17 0Ds00r00
	asr	offset16,y	;17 1Ds00r00
	asr	offset16,z	;17 2Ds00r00
	asr	ind16,x16	;17 0D 34 56
	asr	ind16,y16	;17 1D 34 56
	asr	ind16,z16	;17 2D 34 56
	asr	ind16,x		;17 0D 34 56
	asr	ind16,y		;17 1D 34 56
	asr	ind16,z		;17 2D 34 56
	asr	address		;17 3D 11 22
	asr	external	;17 3Ds00r00

	asra			;37 0D
	asrb			;37 1D
	asrd			;27 FD
	asre			;27 7D
	asrm			;27 BA

	asrw	,x		;27 0D 00 00
	asrw	,y		;27 1D 00 00
	asrw	,z		;27 2D 00 00
	asrw	,x16		;27 0D 00 00
	asrw	,y16		;27 1D 00 00
	asrw	,z16		;27 2D 00 00
	asrw	offset16,x16	;27 0Ds00r00
	asrw	offset16,y16	;27 1Ds00r00
	asrw	offset16,z16	;27 2Ds00r00
	asrw	offset16,x	;27 0Ds00r00
	asrw	offset16,y	;27 1Ds00r00
	asrw	offset16,z	;27 2Ds00r00
	asrw	ind16,x16	;27 0D 34 56
	asrw	ind16,y16	;27 1D 34 56
	asrw	ind16,z16	;27 2D 34 56
	asrw	ind16,x		;27 0D 34 56
	asrw	ind16,y		;27 1D 34 56
	asrw	ind16,z		;27 2D 34 56
	asrw	address		;27 3D 11 22
	asrw	external	;27 3Ds00r00

	bclr	,x,#mask8		;17 08 78 00
	bclr	,y,#mask8		;17 18 78 00
	bclr	,z,#mask8		;17 28 78 00
	bclr	,x8,#mask8		;17 08 78 00
	bclr	,y8,#mask8		;17 18 78 00
	bclr	,z8,#mask8		;17 28 78 00
	bclr	,x16,#mask8		;08 78 00 00
	bclr	,y16,#mask8		;18 78 00 00
	bclr	,z16,#mask8		;28 78 00 00
	bclr	offset8,x8,#mask8	;17 08 78u00
	bclr	offset8,y8,#mask8	;17 18 78u00
	bclr	offset8,z8,#mask8	;17 28 78u00
	bclr	ind8,x8,#mask8		;17 08 78 12
	bclr	ind8,y8,#mask8		;17 18 78 12
	bclr	ind8,z8,#mask8		;17 28 78 12
	bclr	ind8,x,#mask8		;17 08 78 12
	bclr	ind8,y,#mask8		;17 18 78 12
	bclr	ind8,z,#mask8		;17 28 78 12
	bclr	offset16,x16,#mask8	;08 78s00r00
	bclr	offset16,y16,#mask8	;18 78s00r00
	bclr	offset16,z16,#mask8	;28 78s00r00
	bclr	offset16,x,#mask8	;08 78s00r00
	bclr	offset16,y,#mask8	;18 78s00r00
	bclr	offset16,z,#mask8	;28 78s00r00
	bclr	ind16,x16,#mask8	;08 78 34 56
	bclr	ind16,y16,#mask8	;18 78 34 56
	bclr	ind16,z16,#mask8	;28 78 34 56
	bclr	ind16,x,#mask8		;08 78 34 56
	bclr	ind16,y,#mask8		;18 78 34 56
	bclr	ind16,z,#mask8		;28 78 34 56
	bclr	address,#mask8		;38 78 11 22
	bclr	external,#mask8		;38 78s00r00

	bclr	,x,#emsk8		;17 08u00 00
	bclr	,y,#emsk8		;17 18u00 00
	bclr	,z,#emsk8		;17 28u00 00
	bclr	,x8,#emsk8		;17 08u00 00
	bclr	,y8,#emsk8		;17 18u00 00
	bclr	,z8,#emsk8		;17 28u00 00
	bclr	,x16,#emsk8		;08u00 00 00
	bclr	,y16,#emsk8		;18u00 00 00
	bclr	,z16,#emsk8		;28u00 00 00
	bclr	offset8,x8,#emsk8	;17 08u00u00
	bclr	offset8,y8,#emsk8	;17 18u00u00
	bclr	offset8,z8,#emsk8	;17 28u00u00
	bclr	ind8,x8,#emsk8		;17 08u00 12
	bclr	ind8,y8,#emsk8		;17 18u00 12
	bclr	ind8,z8,#emsk8		;17 28u00 12
	bclr	ind8,x,#emsk8		;17 08u00 12
	bclr	ind8,y,#emsk8		;17 18u00 12
	bclr	ind8,z,#emsk8		;17 28u00 12
	bclr	offset16,x16,#emsk8	;08u00s00r00
	bclr	offset16,y16,#emsk8	;18u00s00r00
	bclr	offset16,z16,#emsk8	;28u00s00r00
	bclr	offset16,x,#emsk8	;08u00s00r00
	bclr	offset16,y,#emsk8	;18u00s00r00
	bclr	offset16,z,#emsk8	;28u00s00r00
	bclr	ind16,x16,#emsk8	;08u00 34 56
	bclr	ind16,y16,#emsk8	;18u00 34 56
	bclr	ind16,z16,#emsk8	;28u00 34 56
	bclr	ind16,x,#emsk8		;08u00 34 56
	bclr	ind16,y,#emsk8		;18u00 34 56
	bclr	ind16,z,#emsk8		;28u00 34 56
	bclr	address,#emsk8		;38u00 11 22
	bclr	external,#emsk8		;38u00s00r00

	bclrw	,x,#mask16		;27 08 9A BC 00 00
	bclrw	,y,#mask16		;27 18 9A BC 00 00
	bclrw	,z,#mask16		;27 28 9A BC 00 00
	bclrw	,x16,#mask16		;27 08 9A BC 00 00
	bclrw	,y16,#mask16		;27 18 9A BC 00 00
	bclrw	,z16,#mask16		;27 28 9A BC 00 00
	bclrw	offset16,x16,#mask16	;27 08 9A BCs00r00
	bclrw	offset16,y16,#mask16	;27 18 9A BCs00r00
	bclrw	offset16,z16,#mask16	;27 28 9A BCs00r00
	bclrw	offset16,x,#mask16	;27 08 9A BCs00r00
	bclrw	offset16,y,#mask16	;27 18 9A BCs00r00
	bclrw	offset16,z,#mask16	;27 28 9A BCs00r00
	bclrw	ind16,x16,#mask16	;27 08 9A BC 34 56
	bclrw	ind16,y16,#mask16	;27 18 9A BC 34 56
	bclrw	ind16,z16,#mask16	;27 28 9A BC 34 56
	bclrw	ind16,x,#mask16		;27 08 9A BC 34 56
	bclrw	ind16,y,#mask16		;27 18 9A BC 34 56
	bclrw	ind16,z,#mask16		;27 28 9A BC 34 56
	bclrw	address,#mask16		;27 38 9A BC 11 22
	bclrw	external,#mask16	;27 38 9A BCs00r00

	bclrw	,x,#emsk16		;27 08s00r00 00 00
	bclrw	,y,#emsk16		;27 18s00r00 00 00
	bclrw	,z,#emsk16		;27 28s00r00 00 00
	bclrw	,x16,#emsk16		;27 08s00r00 00 00
	bclrw	,y16,#emsk16		;27 18s00r00 00 00
	bclrw	,z16,#emsk16		;27 28s00r00 00 00
	bclrw	offset16,x16,#emsk16	;27 08s00r00s00r00
	bclrw	offset16,y16,#emsk16	;27 18s00r00s00r00
	bclrw	offset16,z16,#emsk16	;27 28s00r00s00r00
	bclrw	offset16,x,#emsk16	;27 08s00r00s00r00
	bclrw	offset16,y,#emsk16	;27 18s00r00s00r00
	bclrw	offset16,z,#emsk16	;27 28s00r00s00r00
	bclrw	ind16,x16,#emsk16	;27 08s00r00 34 56
	bclrw	ind16,y16,#emsk16	;27 18s00r00 34 56
	bclrw	ind16,z16,#emsk16	;27 28s00r00 34 56
	bclrw	ind16,x,#emsk16		;27 08s00r00 34 56
	bclrw	ind16,y,#emsk16		;27 18s00r00 34 56
	bclrw	ind16,z,#emsk16		;27 28s00r00 34 56
	bclrw	address,#emsk16		;27 38s00r00 11 22
	bclrw	external,#emsk16	;27 38s00r00s00r00

	bgnd			;37 A6

	bcc	.+0x12		;B4 0C
	bcs	.+0x12		;B5 0C
	beq	.+0x12		;B7 0C
	bge	.+0x12		;BC 0C
	bgt	.+0x12		;BE 0C
	bhi	.+0x12		;B2 0C
	bhis	.+0x12		;B4 0C
	bhs	.+0x12		;B4 0C
	ble	.+0x12		;BF 0C
	blo	.+0x12		;B5 0C
	blos	.+0x12		;B3 0C
	bls	.+0x12		;B3 0C
	blt	.+0x12		;BD 0C
	bmi	.+0x12		;BB 0C
	bne	.+0x12		;B6 0C
	bpl	.+0x12		;BA 0C
	bra	.+0x12		;B0 0C
	brn	.+0x12		;B1 0C
	bsr	.+0x12		;36 0C
	bvc	.+0x12		;B8 0C
	bvs	.+0x12		;B9 0C

	bcc	external	;B4pFC
	bcs	external	;B5pFC
	beq	external	;B7pFC
	bge	external	;BCpFC
	bgt	external	;BEpFC
	bhi	external	;B2pFC
	bhis	external	;B4pFC
	bhs	external	;B4pFC
	ble	external	;BFpFC
	blo	external	;B5pFC
	blos	external	;B3pFC
	bls	external	;B3pFC
	blt	external	;BDpFC
	bmi	external	;BBpFC
	bne	external	;B6pFC
	bpl	external	;BApFC
	bra	external	;B0pFC
	brn	external	;B1pFC
	bsr	external	;36pFC
	bvc	external	;B8pFC
	bvs	external	;B9pFC

short:	bcc	short		;B4 FA
	bcs	short		;B5 F8
	beq	short		;B7 F6
	bge	short		;BC F4
	bgt	short		;BE F2
	bhi	short		;B2 F0
	bhis	short		;B4 EE
	bhs	short		;B4 EC
	ble	short		;BF EA
	blo	short		;B5 E8
	blos	short		;B3 E6
	bls	short		;B3 E4
	blt	short		;BD E2
	bmi	short		;BB E0
	bne	short		;B6 DE
	bpl	short		;BA DC
	bra	short		;B0 DA
	brn	short		;B1 D8
	bsr	short		;36 D6
	bvc	short		;B8 D4
	bvs	short		;B9 D2

	bita	,x		;49 00
	bita	,y		;59 00
	bita	,z		;69 00
	bita	,x8		;49 00
	bita	,y8		;59 00
	bita	,z8		;69 00
	bita	,x16		;17 49 00 00
	bita	,y16		;17 59 00 00
	bita	,z16		;17 69 00 00
	bita	offset8,x8	;49u00
	bita	offset8,y8	;59u00
	bita	offset8,z8	;69u00
	bita	ind8,x8		;49 12
	bita	ind8,y8		;59 12
	bita	ind8,z8		;69 12
	bita	ind8,x		;49 12
	bita	ind8,y		;59 12
	bita	ind8,z		;69 12
	bita	#imm8		;79 01
	bita	#num8		;79r00
	bita	offset16,x16	;17 49s00r00
	bita	offset16,y16	;17 59s00r00
	bita	offset16,z16	;17 69s00r00
	bita	offset16,x	;17 49s00r00
	bita	offset16,y	;17 59s00r00
	bita	offset16,z	;17 69s00r00
	bita	ind16,x16	;17 49 34 56
	bita	ind16,y16	;17 59 34 56
	bita	ind16,z16	;17 69 34 56
	bita	ind16,x		;17 49 34 56
	bita	ind16,y		;17 59 34 56
	bita	ind16,z		;17 69 34 56
	bita	address		;17 79 11 22
	bita	external	;17 79s00r00
	bita	e,x		;27 49
	bita	e,y		;27 59
	bita	e,z		;27 69

	bitb	,x		;C9 00
	bitb	,y		;D9 00
	bitb	,z		;E9 00
	bitb	,x8		;C9 00
	bitb	,y8		;D9 00
	bitb	,z8		;E9 00
	bitb	,x16		;17 C9 00 00
	bitb	,y16		;17 D9 00 00
	bitb	,z16		;17 E9 00 00
	bitb	offset8,x8	;C9u00
	bitb	offset8,y8	;D9u00
	bitb	offset8,z8	;E9u00
	bitb	ind8,x8		;C9 12
	bitb	ind8,y8		;D9 12
	bitb	ind8,z8		;E9 12
	bitb	ind8,x		;C9 12
	bitb	ind8,y		;D9 12
	bitb	ind8,z		;E9 12
	bitb	#imm8		;F9 01
	bitb	#num8		;F9r00
	bitb	offset16,x16	;17 C9s00r00
	bitb	offset16,y16	;17 D9s00r00
	bitb	offset16,z16	;17 E9s00r00
	bitb	offset16,x	;17 C9s00r00
	bitb	offset16,y	;17 D9s00r00
	bitb	offset16,z	;17 E9s00r00
	bitb	ind16,x16	;17 C9 34 56
	bitb	ind16,y16	;17 D9 34 56
	bitb	ind16,z16	;17 E9 34 56
	bitb	ind16,x		;17 C9 34 56
	bitb	ind16,y		;17 D9 34 56
	bitb	ind16,z		;17 E9 34 56
	bitb	address		;17 F9 11 22
	bitb	external	;17 F9s00r00
	bitb	e,x		;27 C9
	bitb	e,y		;27 D9
	bitb	e,z		;27 E9

	brclr	,x,#mask8,.+0x16		;CB 78 00 10
	brclr	,y,#mask8,.+0x16		;DB 78 00 10
	brclr	,z,#mask8,.+0x16		;EB 78 00 10
	brclr	,x8,#mask8,.+0x16		;CB 78 00 10
	brclr	,y8,#mask8,.+0x16		;DB 78 00 10
	brclr	,z8,#mask8,.+0x16		;EB 78 00 10
	brclr	,x16,#mask8,.+0x16		;0A 78 00 00 00 10
	brclr	,y16,#mask8,.+0x16		;1A 78 00 00 00 10
	brclr	,z16,#mask8,.+0x16		;2A 78 00 00 00 10
	brclr	offset8,x8,#mask8,.+0x16	;CB 78u00 10
	brclr	offset8,y8,#mask8,.+0x16	;DB 78u00 10
	brclr	offset8,z8,#mask8,.+0x16	;EB 78u00 10
	brclr	ind8,x8,#mask8,.+0x16		;CB 78 12 10
	brclr	ind8,y8,#mask8,.+0x16		;DB 78 12 10
	brclr	ind8,z8,#mask8,.+0x16		;EB 78 12 10
	brclr	ind8,x,#mask8,.+0x16		;CB 78 12 10
	brclr	ind8,y,#mask8,.+0x16		;DB 78 12 10
	brclr	ind8,z,#mask8,.+0x16		;EB 78 12 10
	brclr	offset16,x16,#mask8,.+0x16	;0A 78s00r00 00 10
	brclr	offset16,y16,#mask8,.+0x16	;1A 78s00r00 00 10
	brclr	offset16,z16,#mask8,.+0x16	;2A 78s00r00 00 10
	brclr	offset16,x,#mask8,.+0x16	;0A 78s00r00 00 10
	brclr	offset16,y,#mask8,.+0x16	;1A 78s00r00 00 10
	brclr	offset16,z,#mask8,.+0x16	;2A 78s00r00 00 10
	brclr	ind16,x16,#mask8,.+0x16		;0A 78 34 56 00 10
	brclr	ind16,y16,#mask8,.+0x16		;1A 78 34 56 00 10
	brclr	ind16,z16,#mask8,.+0x16		;2A 78 34 56 00 10
	brclr	ind16,x,#mask8,.+0x16		;0A 78 34 56 00 10
	brclr	ind16,y,#mask8,.+0x16		;1A 78 34 56 00 10
	brclr	ind16,z,#mask8,.+0x16		;2A 78 34 56 00 10
	brclr	address,#mask8,.+0x16		;3A 78 11 22 00 10
	brclr	external,#mask8,.+0x16		;3A 78s00r00 00 10

	brclr	,x,#emsk8,.+0x16		;CBu00 00 10
	brclr	,y,#emsk8,.+0x16		;DBu00 00 10
	brclr	,z,#emsk8,.+0x16		;EBu00 00 10
	brclr	,x8,#emsk8,.+0x16		;CBu00 00 10
	brclr	,y8,#emsk8,.+0x16		;DBu00 00 10
	brclr	,z8,#emsk8,.+0x16		;EBu00 00 10
	brclr	,x16,#emsk8,.+0x16		;0Au00 00 00 00 10
	brclr	,y16,#emsk8,.+0x16		;1Au00 00 00 00 10
	brclr	,z16,#emsk8,.+0x16		;2Au00 00 00 00 10
	brclr	offset8,x8,#emsk8,.+0x16	;CBu00u00 10
	brclr	offset8,y8,#emsk8,.+0x16	;DBu00u00 10
	brclr	offset8,z8,#emsk8,.+0x16	;EBu00u00 10
	brclr	ind8,x8,#emsk8,.+0x16		;CBu00 12 10
	brclr	ind8,y8,#emsk8,.+0x16		;DBu00 12 10
	brclr	ind8,z8,#emsk8,.+0x16		;EBu00 12 10
	brclr	ind8,x,#emsk8,.+0x16		;CBu00 12 10
	brclr	ind8,y,#emsk8,.+0x16		;DBu00 12 10
	brclr	ind8,z,#emsk8,.+0x16		;EBu00 12 10
	brclr	offset16,x16,#emsk8,.+0x16	;0Au00s00r00 00 10
	brclr	offset16,y16,#emsk8,.+0x16	;1Au00s00r00 00 10
	brclr	offset16,z16,#emsk8,.+0x16	;2Au00s00r00 00 10
	brclr	offset16,x,#emsk8,.+0x16	;0Au00s00r00 00 10
	brclr	offset16,y,#emsk8,.+0x16	;1Au00s00r00 00 10
	brclr	offset16,z,#emsk8,.+0x16	;2Au00s00r00 00 10
	brclr	ind16,x16,#emsk8,.+0x16		;0Au00 34 56 00 10
	brclr	ind16,y16,#emsk8,.+0x16		;1Au00 34 56 00 10
	brclr	ind16,z16,#emsk8,.+0x16		;2Au00 34 56 00 10
	brclr	ind16,x,#emsk8,.+0x16		;0Au00 34 56 00 10
	brclr	ind16,y,#emsk8,.+0x16		;1Au00 34 56 00 10
	brclr	ind16,z,#emsk8,.+0x16		;2Au00 34 56 00 10
	brclr	address,#emsk8,.+0x16		;3Au00 11 22 00 10
	brclr	external,#emsk8,.+0x16		;3Au00s00r00 00 10

brclr1: brclr	offset8,x8,#mask8,brclr1	;CB 78u00 FA
	brclr	offset8,y8,#mask8,brclr1	;DB 78u00 F6
	brclr	offset8,z8,#mask8,brclr1	;EB 78u00 F2
	brclr	ind8,x8,#mask8,brclr1		;CB 78 12 EE
	brclr	ind8,y8,#mask8,brclr1		;DB 78 12 EA
	brclr	ind8,z8,#mask8,brclr1		;EB 78 12 E6
	brclr	ind8,x,#mask8,brclr1		;CB 78 12 E2
	brclr	ind8,y,#mask8,brclr1		;DB 78 12 DE
	brclr	ind8,z,#mask8,brclr1		;EB 78 12 DA
	brclr	offset16,x16,#mask8,brclr1	;0A 78s00r00 FF D6
	brclr	offset16,y16,#mask8,brclr1	;1A 78s00r00 FF D0
	brclr	offset16,z16,#mask8,brclr1	;2A 78s00r00 FF CA
	brclr	offset16,x,#mask8,brclr1	;0A 78s00r00 FF C4
	brclr	offset16,y,#mask8,brclr1	;1A 78s00r00 FF BE
	brclr	offset16,z,#mask8,brclr1	;2A 78s00r00 FF B8
	brclr	ind16,x16,#mask8,brclr1		;0A 78 34 56 FF B2
	brclr	ind16,y16,#mask8,brclr1		;1A 78 34 56 FF AC
	brclr	ind16,z16,#mask8,brclr1		;2A 78 34 56 FF A6
	brclr	ind16,x,#mask8,brclr1		;0A 78 34 56 FF A0
	brclr	ind16,y,#mask8,brclr1		;1A 78 34 56 FF 9A
	brclr	ind16,z,#mask8,brclr1		;2A 78 34 56 FF 94
	brclr	address,#mask8,brclr1		;3A 78 11 22 FF 8E
	brclr	external,#mask8,brclr1		;3A 78s00r00 FF 88

	brclr	offset8,x8,#emsk8,external	;CBu00u00pFE
	brclr	offset8,y8,#emsk8,external	;DBu00u00pFE
	brclr	offset8,z8,#emsk8,external	;EBu00u00pFE
	brclr	ind8,x8,#emsk8,external		;CBu00 12pFE
	brclr	ind8,y8,#emsk8,external		;DBu00 12pFE
	brclr	ind8,z8,#emsk8,external		;EBu00 12pFE
	brclr	ind8,x,#emsk8,external		;0Au00 00 12q00p00
	brclr	ind8,y,#emsk8,external		;1Au00 00 12q00p00
	brclr	ind8,z,#emsk8,external		;2Au00 00 12q00p00
	brclr	offset16,x16,#emsk8,external	;0Au00s00r00q00p00
	brclr	offset16,y16,#emsk8,external	;1Au00s00r00q00p00
	brclr	offset16,z16,#emsk8,external	;2Au00s00r00q00p00
	brclr	offset16,x,#emsk8,external	;0Au00s00r00q00p00
	brclr	offset16,y,#emsk8,external	;1Au00s00r00q00p00
	brclr	offset16,z,#emsk8,external	;2Au00s00r00q00p00
	brclr	ind16,x16,#emsk8,external	;0Au00 34 56q00p00
	brclr	ind16,y16,#emsk8,external	;1Au00 34 56q00p00
	brclr	ind16,z16,#emsk8,external	;2Au00 34 56q00p00
	brclr	ind16,x,#emsk8,external		;0Au00 34 56q00p00
	brclr	ind16,y,#emsk8,external		;1Au00 34 56q00p00
	brclr	ind16,z,#emsk8,external		;2Au00 34 56q00p00
	brclr	address,#emsk8,external		;3Au00 11 22q00p00
	brclr	external,#emsk8,external	;3Au00s00r00q00p00

	brclr	ind8,x,#emsk8,.+0x0106		;0Au00 00 12 01 00
	brclr	ind8,y,#emsk8,.+0x0106		;1Au00 00 12 01 00
	brclr	ind8,z,#emsk8,.+0x0106		;2Au00 00 12 01 00
	brclr	offset16,x16,#emsk8,.+0x0106	;0Au00s00r00 01 00
	brclr	offset16,y16,#emsk8,.+0x0106	;1Au00s00r00 01 00
	brclr	offset16,z16,#emsk8,.+0x0106	;2Au00s00r00 01 00
	brclr	offset16,x,#emsk8,.+0x0106	;0Au00s00r00 01 00
	brclr	offset16,y,#emsk8,.+0x0106	;1Au00s00r00 01 00
	brclr	offset16,z,#emsk8,.+0x0106	;2Au00s00r00 01 00
	brclr	ind16,x16,#emsk8,.+0x0106	;0Au00 34 56 01 00
	brclr	ind16,y16,#emsk8,.+0x0106	;1Au00 34 56 01 00
	brclr	ind16,z16,#emsk8,.+0x0106	;2Au00 34 56 01 00
	brclr	ind16,x,#emsk8,.+0x0106		;0Au00 34 56 01 00
	brclr	ind16,y,#emsk8,.+0x0106		;1Au00 34 56 01 00
	brclr	ind16,z,#emsk8,.+0x0106		;2Au00 34 56 01 00
	brclr	address,#emsk8,.+0x0106		;3Au00 11 22 01 00
	brclr	external,#emsk8,.+0x0106	;3Au00s00r00 01 00

	brset	,x,#mask8,.+0x16		;8B 78 00 10
	brset	,y,#mask8,.+0x16		;9B 78 00 10
	brset	,z,#mask8,.+0x16		;AB 78 00 10
	brset	,x8,#mask8,.+0x16		;8B 78 00 10
	brset	,y8,#mask8,.+0x16		;9B 78 00 10
	brset	,z8,#mask8,.+0x16		;AB 78 00 10
	brset	,x16,#mask8,.+0x16		;0B 78 00 00 00 10
	brset	,y16,#mask8,.+0x16		;1B 78 00 00 00 10
	brset	,z16,#mask8,.+0x16		;2B 78 00 00 00 10
	brset	offset8,x8,#mask8,.+0x16	;8B 78u00 10
	brset	offset8,y8,#mask8,.+0x16	;9B 78u00 10
	brset	offset8,z8,#mask8,.+0x16	;AB 78u00 10
	brset	ind8,x8,#mask8,.+0x16		;8B 78 12 10
	brset	ind8,y8,#mask8,.+0x16		;9B 78 12 10
	brset	ind8,z8,#mask8,.+0x16		;AB 78 12 10
	brset	ind8,x,#mask8,.+0x16		;8B 78 12 10
	brset	ind8,y,#mask8,.+0x16		;9B 78 12 10
	brset	ind8,z,#mask8,.+0x16		;AB 78 12 10
	brset	offset16,x16,#mask8,.+0x16	;0B 78s00r00 00 10
	brset	offset16,y16,#mask8,.+0x16	;1B 78s00r00 00 10
	brset	offset16,z16,#mask8,.+0x16	;2B 78s00r00 00 10
	brset	offset16,x,#mask8,.+0x16	;0B 78s00r00 00 10
	brset	offset16,y,#mask8,.+0x16	;1B 78s00r00 00 10
	brset	offset16,z,#mask8,.+0x16	;2B 78s00r00 00 10
	brset	ind16,x16,#mask8,.+0x16		;0B 78 34 56 00 10
	brset	ind16,y16,#mask8,.+0x16		;1B 78 34 56 00 10
	brset	ind16,z16,#mask8,.+0x16		;2B 78 34 56 00 10
	brset	ind16,x,#mask8,.+0x16		;0B 78 34 56 00 10
	brset	ind16,y,#mask8,.+0x16		;1B 78 34 56 00 10
	brset	ind16,z,#mask8,.+0x16		;2B 78 34 56 00 10
	brset	address,#mask8,.+0x16		;3B 78 11 22 00 10
	brset	external,#mask8,.+0x16		;3B 78s00r00 00 10

	brset	,x,#emsk8,.+0x16		;8Bu00 00 10
	brset	,y,#emsk8,.+0x16		;9Bu00 00 10
	brset	,z,#emsk8,.+0x16		;ABu00 00 10
	brset	,x8,#emsk8,.+0x16		;8Bu00 00 10
	brset	,y8,#emsk8,.+0x16		;9Bu00 00 10
	brset	,z8,#emsk8,.+0x16		;ABu00 00 10
	brset	,x16,#emsk8,.+0x16		;0Bu00 00 00 00 10
	brset	,y16,#emsk8,.+0x16		;1Bu00 00 00 00 10
	brset	,z16,#emsk8,.+0x16		;2Bu00 00 00 00 10
	brset	offset8,x8,#emsk8,.+0x16	;8Bu00u00 10
	brset	offset8,y8,#emsk8,.+0x16	;9Bu00u00 10
	brset	offset8,z8,#emsk8,.+0x16	;ABu00u00 10
	brset	ind8,x8,#emsk8,.+0x16		;8Bu00 12 10
	brset	ind8,y8,#emsk8,.+0x16		;9Bu00 12 10
	brset	ind8,z8,#emsk8,.+0x16		;ABu00 12 10
	brset	ind8,x,#emsk8,.+0x16		;8Bu00 12 10
	brset	ind8,y,#emsk8,.+0x16		;9Bu00 12 10
	brset	ind8,z,#emsk8,.+0x16		;ABu00 12 10
	brset	offset16,x16,#emsk8,.+0x16	;0Bu00s00r00 00 10
	brset	offset16,y16,#emsk8,.+0x16	;1Bu00s00r00 00 10
	brset	offset16,z16,#emsk8,.+0x16	;2Bu00s00r00 00 10
	brset	offset16,x,#emsk8,.+0x16	;0Bu00s00r00 00 10
	brset	offset16,y,#emsk8,.+0x16	;1Bu00s00r00 00 10
	brset	offset16,z,#emsk8,.+0x16	;2Bu00s00r00 00 10
	brset	ind16,x16,#emsk8,.+0x16		;0Bu00 34 56 00 10
	brset	ind16,y16,#emsk8,.+0x16		;1Bu00 34 56 00 10
	brset	ind16,z16,#emsk8,.+0x16		;2Bu00 34 56 00 10
	brset	ind16,x,#emsk8,.+0x16		;0Bu00 34 56 00 10
	brset	ind16,y,#emsk8,.+0x16		;1Bu00 34 56 00 10
	brset	ind16,z,#emsk8,.+0x16		;2Bu00 34 56 00 10
	brset	address,#emsk8,.+0x16		;3Bu00 11 22 00 10
	brset	external,#emsk8,.+0x16		;3Bu00s00r00 00 10

brset1: brset	offset8,x8,#mask8,brset1	;8B 78u00 FA
	brset	offset8,y8,#mask8,brset1	;9B 78u00 F6
	brset	offset8,z8,#mask8,brset1	;AB 78u00 F2
	brset	ind8,x8,#mask8,brset1		;8B 78 12 EE
	brset	ind8,y8,#mask8,brset1		;9B 78 12 EA
	brset	ind8,z8,#mask8,brset1		;AB 78 12 E6
	brset	ind8,x,#mask8,brset1		;8B 78 12 E2
	brset	ind8,y,#mask8,brset1		;9B 78 12 DE
	brset	ind8,z,#mask8,brset1		;AB 78 12 DA
	brset	offset16,x16,#mask8,brset1	;0B 78s00r00 FF D6
	brset	offset16,y16,#mask8,brset1	;1B 78s00r00 FF D0
	brset	offset16,z16,#mask8,brset1	;2B 78s00r00 FF CA
	brset	offset16,x,#mask8,brset1	;0B 78s00r00 FF C4
	brset	offset16,y,#mask8,brset1	;1B 78s00r00 FF BE
	brset	offset16,z,#mask8,brset1	;2B 78s00r00 FF B8
	brset	ind16,x16,#mask8,brset1		;0B 78 34 56 FF B2
	brset	ind16,y16,#mask8,brset1		;1B 78 34 56 FF AC
	brset	ind16,z16,#mask8,brset1		;2B 78 34 56 FF A6
	brset	ind16,x,#mask8,brset1		;0B 78 34 56 FF A0
	brset	ind16,y,#mask8,brset1		;1B 78 34 56 FF 9A
	brset	ind16,z,#mask8,brset1		;2B 78 34 56 FF 94
	brset	address,#mask8,brset1		;3B 78 11 22 FF 8E
	brset	external,#mask8,brset1		;3B 78s00r00 FF 88

	brset	offset8,x8,#emsk8,external	;8Bu00u00pFE
	brset	offset8,y8,#emsk8,external	;9Bu00u00pFE
	brset	offset8,z8,#emsk8,external	;ABu00u00pFE
	brset	ind8,x8,#emsk8,external		;8Bu00 12pFE
	brset	ind8,y8,#emsk8,external		;9Bu00 12pFE
	brset	ind8,z8,#emsk8,external		;ABu00 12pFE
	brset	ind8,x,#emsk8,external		;0Bu00 00 12q00p00
	brset	ind8,y,#emsk8,external		;1Bu00 00 12q00p00
	brset	ind8,z,#emsk8,external		;2Bu00 00 12q00p00
	brset	offset16,x16,#emsk8,external	;0Bu00s00r00q00p00
	brset	offset16,y16,#emsk8,external	;1Bu00s00r00q00p00
	brset	offset16,z16,#emsk8,external	;2Bu00s00r00q00p00
	brset	offset16,x,#emsk8,external	;0Bu00s00r00q00p00
	brset	offset16,y,#emsk8,external	;1Bu00s00r00q00p00
	brset	offset16,z,#emsk8,external	;2Bu00s00r00q00p00
	brset	ind16,x16,#emsk8,external	;0Bu00 34 56q00p00
	brset	ind16,y16,#emsk8,external	;1Bu00 34 56q00p00
	brset	ind16,z16,#emsk8,external	;2Bu00 34 56q00p00
	brset	ind16,x,#emsk8,external		;0Bu00 34 56q00p00
	brset	ind16,y,#emsk8,external		;1Bu00 34 56q00p00
	brset	ind16,z,#emsk8,external		;2Bu00 34 56q00p00
	brset	address,#emsk8,external		;3Bu00 11 22q00p00
	brset	external,#emsk8,external	;3Bu00s00r00q00p00

	brset	ind8,x,#emsk8,.+0x0106		;0Bu00 00 12 01 00
	brset	ind8,y,#emsk8,.+0x0106		;1Bu00 00 12 01 00
	brset	ind8,z,#emsk8,.+0x0106		;2Bu00 00 12 01 00
	brset	offset16,x16,#emsk8,.+0x0106	;0Bu00s00r00 01 00
	brset	offset16,y16,#emsk8,.+0x0106	;1Bu00s00r00 01 00
	brset	offset16,z16,#emsk8,.+0x0106	;2Bu00s00r00 01 00
	brset	offset16,x,#emsk8,.+0x0106	;0Bu00s00r00 01 00
	brset	offset16,y,#emsk8,.+0x0106	;1Bu00s00r00 01 00
	brset	offset16,z,#emsk8,.+0x0106	;2Bu00s00r00 01 00
	brset	ind16,x16,#emsk8,.+0x0106	;0Bu00 34 56 01 00
	brset	ind16,y16,#emsk8,.+0x0106	;1Bu00 34 56 01 00
	brset	ind16,z16,#emsk8,.+0x0106	;2Bu00 34 56 01 00
	brset	ind16,x,#emsk8,.+0x0106		;0Bu00 34 56 01 00
	brset	ind16,y,#emsk8,.+0x0106		;1Bu00 34 56 01 00
	brset	ind16,z,#emsk8,.+0x0106		;2Bu00 34 56 01 00
	brset	address,#emsk8,.+0x0106		;3Bu00 11 22 01 00
	brset	external,#emsk8,.+0x0106	;3Bu00s00r00 01 00

	bset	,x,#mask8		;17 09 78 00
	bset	,y,#mask8		;17 19 78 00
	bset	,z,#mask8		;17 29 78 00
	bset	,x8,#mask8		;17 09 78 00
	bset	,y8,#mask8		;17 19 78 00
	bset	,z8,#mask8		;17 29 78 00
	bset	,x16,#mask8		;09 78 00 00
	bset	,y16,#mask8		;19 78 00 00
	bset	,z16,#mask8		;29 78 00 00
	bset	offset8,x8,#mask8	;17 09 78u00
	bset	offset8,y8,#mask8	;17 19 78u00
	bset	offset8,z8,#mask8	;17 29 78u00
	bset	ind8,x8,#mask8		;17 09 78 12
	bset	ind8,y8,#mask8		;17 19 78 12
	bset	ind8,z8,#mask8		;17 29 78 12
	bset	ind8,x,#mask8		;17 09 78 12
	bset	ind8,y,#mask8		;17 19 78 12
	bset	ind8,z,#mask8		;17 29 78 12
	bset	offset16,x16,#mask8	;09 78s00r00
	bset	offset16,y16,#mask8	;19 78s00r00
	bset	offset16,z16,#mask8	;29 78s00r00
	bset	offset16,x,#mask8	;09 78s00r00
	bset	offset16,y,#mask8	;19 78s00r00
	bset	offset16,z,#mask8	;29 78s00r00
	bset	ind16,x16,#mask8	;09 78 34 56
	bset	ind16,y16,#mask8	;19 78 34 56
	bset	ind16,z16,#mask8	;29 78 34 56
	bset	ind16,x,#mask8		;09 78 34 56
	bset	ind16,y,#mask8		;19 78 34 56
	bset	ind16,z,#mask8		;29 78 34 56
	bset	address,#mask8		;39 78 11 22
	bset	external,#mask8		;39 78s00r00

	bset	,x,#emsk8		;17 09u00 00
	bset	,y,#emsk8		;17 19u00 00
	bset	,z,#emsk8		;17 29u00 00
	bset	,x8,#emsk8		;17 09u00 00
	bset	,y8,#emsk8		;17 19u00 00
	bset	,z8,#emsk8		;17 29u00 00
	bset	,x16,#emsk8		;09u00 00 00
	bset	,y16,#emsk8		;19u00 00 00
	bset	,z16,#emsk8		;29u00 00 00
	bset	offset8,x8,#emsk8	;17 09u00u00
	bset	offset8,y8,#emsk8	;17 19u00u00
	bset	offset8,z8,#emsk8	;17 29u00u00
	bset	ind8,x8,#emsk8		;17 09u00 12
	bset	ind8,y8,#emsk8		;17 19u00 12
	bset	ind8,z8,#emsk8		;17 29u00 12
	bset	ind8,x,#emsk8		;17 09u00 12
	bset	ind8,y,#emsk8		;17 19u00 12
	bset	ind8,z,#emsk8		;17 29u00 12
	bset	offset16,x16,#emsk8	;09u00s00r00
	bset	offset16,y16,#emsk8	;19u00s00r00
	bset	offset16,z16,#emsk8	;29u00s00r00
	bset	offset16,x,#emsk8	;09u00s00r00
	bset	offset16,y,#emsk8	;19u00s00r00
	bset	offset16,z,#emsk8	;29u00s00r00
	bset	ind16,x16,#emsk8	;09u00 34 56
	bset	ind16,y16,#emsk8	;19u00 34 56
	bset	ind16,z16,#emsk8	;29u00 34 56
	bset	ind16,x,#emsk8		;09u00 34 56
	bset	ind16,y,#emsk8		;19u00 34 56
	bset	ind16,z,#emsk8		;29u00 34 56
	bset	address,#emsk8		;39u00 11 22
	bset	external,#emsk8		;39u00s00r00

	bsetw	,x,#mask16		;27 09 9A BC 00 00
	bsetw	,y,#mask16		;27 19 9A BC 00 00
	bsetw	,z,#mask16		;27 29 9A BC 00 00
	bsetw	,x16,#mask16		;27 09 9A BC 00 00
	bsetw	,y16,#mask16		;27 19 9A BC 00 00
	bsetw	,z16,#mask16		;27 29 9A BC 00 00
	bsetw	offset16,x16,#mask16	;27 09 9A BCs00r00
	bsetw	offset16,y16,#mask16	;27 19 9A BCs00r00
	bsetw	offset16,z16,#mask16	;27 29 9A BCs00r00
	bsetw	offset16,x,#mask16	;27 09 9A BCs00r00
	bsetw	offset16,y,#mask16	;27 19 9A BCs00r00
	bsetw	offset16,z,#mask16	;27 29 9A BCs00r00
	bsetw	ind16,x16,#mask16	;27 09 9A BC 34 56
	bsetw	ind16,y16,#mask16	;27 19 9A BC 34 56
	bsetw	ind16,z16,#mask16	;27 29 9A BC 34 56
	bsetw	ind16,x,#mask16		;27 09 9A BC 34 56
	bsetw	ind16,y,#mask16		;27 19 9A BC 34 56
	bsetw	ind16,z,#mask16		;27 29 9A BC 34 56
	bsetw	address,#mask16		;27 39 9A BC 11 22
	bsetw	external,#mask16	;27 39 9A BCs00r00

	bsetw	,x,#emsk16		;27 09s00r00 00 00
	bsetw	,y,#emsk16		;27 19s00r00 00 00
	bsetw	,z,#emsk16		;27 29s00r00 00 00
	bsetw	,x16,#emsk16		;27 09s00r00 00 00
	bsetw	,y16,#emsk16		;27 19s00r00 00 00
	bsetw	,z16,#emsk16		;27 29s00r00 00 00
	bsetw	offset16,x16,#emsk16	;27 09s00r00s00r00
	bsetw	offset16,y16,#emsk16	;27 19s00r00s00r00
	bsetw	offset16,z16,#emsk16	;27 29s00r00s00r00
	bsetw	offset16,x,#emsk16	;27 09s00r00s00r00
	bsetw	offset16,y,#emsk16	;27 19s00r00s00r00
	bsetw	offset16,z,#emsk16	;27 29s00r00s00r00
	bsetw	ind16,x16,#emsk16	;27 09s00r00 34 56
	bsetw	ind16,y16,#emsk16	;27 19s00r00 34 56
	bsetw	ind16,z16,#emsk16	;27 29s00r00 34 56
	bsetw	ind16,x,#emsk16		;27 09s00r00 34 56
	bsetw	ind16,y,#emsk16		;27 19s00r00 34 56
	bsetw	ind16,z,#emsk16		;27 29s00r00 34 56
	bsetw	address,#emsk16		;27 39s00r00 11 22
	bsetw	external,#emsk16	;27 39s00r00s00r00

	cba			;37 1B

	clr	,x		;05 00
	clr	,y		;15 00
	clr	,z		;25 00
	clr	,x8		;05 00
	clr	,y8		;15 00
	clr	,z8		;25 00
	clr	,x16		;17 05 00 00
	clr	,y16		;17 15 00 00
	clr	,z16		;17 25 00 00
	clr	offset8,x8	;05u00
	clr	offset8,y8	;15u00
	clr	offset8,z8	;25u00
	clr	ind8,x8		;05 12
	clr	ind8,y8		;15 12
	clr	ind8,z8		;25 12
	clr	ind8,x		;05 12
	clr	ind8,y		;15 12
	clr	ind8,z		;25 12
	clr	offset16,x16	;17 05s00r00
	clr	offset16,y16	;17 15s00r00
	clr	offset16,z16	;17 25s00r00
	clr	offset16,x	;17 05s00r00
	clr	offset16,y	;17 15s00r00
	clr	offset16,z	;17 25s00r00
	clr	ind16,x16	;17 05 34 56
	clr	ind16,y16	;17 15 34 56
	clr	ind16,z16	;17 25 34 56
	clr	ind16,x		;17 05 34 56
	clr	ind16,y		;17 15 34 56
	clr	ind16,z		;17 25 34 56
	clr	address		;17 35 11 22
	clr	external	;17 35s00r00

	clra			;37 05
	clrb			;37 15
	clrd			;27 F5
	clre			;27 75
	clrm			;27 B7

	clrw	,x		;27 05 00 00
	clrw	,y		;27 15 00 00
	clrw	,z		;27 25 00 00
	clrw	,x16		;27 05 00 00
	clrw	,y16		;27 15 00 00
	clrw	,z16		;27 25 00 00
	clrw	offset16,x16	;27 05s00r00
	clrw	offset16,y16	;27 15s00r00
	clrw	offset16,z16	;27 25s00r00
	clrw	offset16,x	;27 05s00r00
	clrw	offset16,y	;27 15s00r00
	clrw	offset16,z	;27 25s00r00
	clrw	ind16,x16	;27 05 34 56
	clrw	ind16,y16	;27 15 34 56
	clrw	ind16,z16	;27 25 34 56
	clrw	ind16,x		;27 05 34 56
	clrw	ind16,y		;27 15 34 56
	clrw	ind16,z		;27 25 34 56
	clrw	address		;27 35 11 22
	clrw	external	;27 35s00r00

	cmpa	,x		;48 00
	cmpa	,y		;58 00
	cmpa	,z		;68 00
	cmpa	,x8		;48 00
	cmpa	,y8		;58 00
	cmpa	,z8		;68 00
	cmpa	,x16		;17 48 00 00
	cmpa	,y16		;17 58 00 00
	cmpa	,z16		;17 68 00 00
	cmpa	offset8,x8	;48u00
	cmpa	offset8,y8	;58u00
	cmpa	offset8,z8	;68u00
	cmpa	ind8,x8		;48 12
	cmpa	ind8,y8		;58 12
	cmpa	ind8,z8		;68 12
	cmpa	ind8,x		;48 12
	cmpa	ind8,y		;58 12
	cmpa	ind8,z		;68 12
	cmpa	#imm8		;78 01
	cmpa	#num8		;78r00
	cmpa	offset16,x16	;17 48s00r00
	cmpa	offset16,y16	;17 58s00r00
	cmpa	offset16,z16	;17 68s00r00
	cmpa	offset16,x	;17 48s00r00
	cmpa	offset16,y	;17 58s00r00
	cmpa	offset16,z	;17 68s00r00
	cmpa	ind16,x16	;17 48 34 56
	cmpa	ind16,y16	;17 58 34 56
	cmpa	ind16,z16	;17 68 34 56
	cmpa	ind16,x		;17 48 34 56
	cmpa	ind16,y		;17 58 34 56
	cmpa	ind16,z		;17 68 34 56
	cmpa	address		;17 78 11 22
	cmpa	external	;17 78s00r00
	cmpa	e,x		;27 48
	cmpa	e,y		;27 58
	cmpa	e,z		;27 68

	cmpb	,x		;C8 00
	cmpb	,y		;D8 00
	cmpb	,z		;E8 00
	cmpb	,x8		;C8 00
	cmpb	,y8		;D8 00
	cmpb	,z8		;E8 00
	cmpb	,x16		;17 C8 00 00
	cmpb	,y16		;17 D8 00 00
	cmpb	,z16		;17 E8 00 00
	cmpb	offset8,x8	;C8u00
	cmpb	offset8,y8	;D8u00
	cmpb	offset8,z8	;E8u00
	cmpb	ind8,x8		;C8 12
	cmpb	ind8,y8		;D8 12
	cmpb	ind8,z8		;E8 12
	cmpb	ind8,x		;C8 12
	cmpb	ind8,y		;D8 12
	cmpb	ind8,z		;E8 12
	cmpb	#imm8		;F8 01
	cmpb	#num8		;F8r00
	cmpb	offset16,x16	;17 C8s00r00
	cmpb	offset16,y16	;17 D8s00r00
	cmpb	offset16,z16	;17 E8s00r00
	cmpb	offset16,x	;17 C8s00r00
	cmpb	offset16,y	;17 D8s00r00
	cmpb	offset16,z	;17 E8s00r00
	cmpb	ind16,x16	;17 C8 34 56
	cmpb	ind16,y16	;17 D8 34 56
	cmpb	ind16,z16	;17 E8 34 56
	cmpb	ind16,x		;17 C8 34 56
	cmpb	ind16,y		;17 D8 34 56
	cmpb	ind16,z		;17 E8 34 56
	cmpb	address		;17 F8 11 22
	cmpb	external	;17 F8s00r00
	cmpb	e,x		;27 C8
	cmpb	e,y		;27 D8
	cmpb	e,z		;27 E8

	com	,x		;00 00
	com	,y		;10 00
	com	,z		;20 00
	com	,x8		;00 00
	com	,y8		;10 00
	com	,z8		;20 00
	com	,x16		;17 00 00 00
	com	,y16		;17 10 00 00
	com	,z16		;17 20 00 00
	com	offset8,x8	;00u00
	com	offset8,y8	;10u00
	com	offset8,z8	;20u00
	com	ind8,x8		;00 12
	com	ind8,y8		;10 12
	com	ind8,z8		;20 12
	com	ind8,x		;00 12
	com	ind8,y		;10 12
	com	ind8,z		;20 12
	com	offset16,x16	;17 00s00r00
	com	offset16,y16	;17 10s00r00
	com	offset16,z16	;17 20s00r00
	com	offset16,x	;17 00s00r00
	com	offset16,y	;17 10s00r00
	com	offset16,z	;17 20s00r00
	com	ind16,x16	;17 00 34 56
	com	ind16,y16	;17 10 34 56
	com	ind16,z16	;17 20 34 56
	com	ind16,x		;17 00 34 56
	com	ind16,y		;17 10 34 56
	com	ind16,z		;17 20 34 56
	com	address		;17 30 11 22
	com	external	;17 30s00r00

	coma			;37 00
	comb			;37 10
	comd			;27 F0
	come			;27 70

	comw	,x		;27 00 00 00
	comw	,y		;27 10 00 00
	comw	,z		;27 20 00 00
	comw	,x16		;27 00 00 00
	comw	,y16		;27 10 00 00
	comw	,z16		;27 20 00 00
	comw	offset16,x16	;27 00s00r00
	comw	offset16,y16	;27 10s00r00
	comw	offset16,z16	;27 20s00r00
	comw	offset16,x	;27 00s00r00
	comw	offset16,y	;27 10s00r00
	comw	offset16,z	;27 20s00r00
	comw	ind16,x16	;27 00 34 56
	comw	ind16,y16	;27 10 34 56
	comw	ind16,z16	;27 20 34 56
	comw	ind16,x		;27 00 34 56
	comw	ind16,y		;27 10 34 56
	comw	ind16,z		;27 20 34 56
	comw	address		;27 30 11 22
	comw	external	;27 30s00r00

	cpd	,x		;88 00
	cpd	,y		;98 00
	cpd	,z		;A8 00
	cpd	,x8		;88 00
	cpd	,y8		;98 00
	cpd	,z8		;A8 00
	cpd	,x16		;37 C8 00 00
	cpd	,y16		;37 D8 00 00
	cpd	,z16		;37 E8 00 00
	cpd	offset8,x8	;88u00
	cpd	offset8,y8	;98u00
	cpd	offset8,z8	;A8u00
	cpd	ind8,x8		;88 12
	cpd	ind8,y8		;98 12
	cpd	ind8,z8		;A8 12
	cpd	ind8,x		;88 12
	cpd	ind8,y		;98 12
	cpd	ind8,z		;A8 12
	cpd	#imm16		;37 B8 23 45
	cpd	#num16		;37 B8s00r00
	cpd	offset16,x16	;37 C8s00r00
	cpd	offset16,y16	;37 D8s00r00
	cpd	offset16,z16	;37 E8s00r00
	cpd	offset16,x	;37 C8s00r00
	cpd	offset16,y	;37 D8s00r00
	cpd	offset16,z	;37 E8s00r00
	cpd	ind16,x16	;37 C8 34 56
	cpd	ind16,y16	;37 D8 34 56
	cpd	ind16,z16	;37 E8 34 56
	cpd	ind16,x		;37 C8 34 56
	cpd	ind16,y		;37 D8 34 56
	cpd	ind16,z		;37 E8 34 56
	cpd	address		;37 F8 11 22
	cpd	external	;37 F8s00r00
	cpd	e,x		;27 88
	cpd	e,y		;27 98
	cpd	e,z		;27 A8

	cpe	#imm16		;37 38 23 45
	cpe	#num16		;37 38s00r00
	cpe	,x		;37 48 00 00
	cpe	,y		;37 58 00 00
	cpe	,z		;37 68 00 00
	cpe	,x16		;37 48 00 00
	cpe	,y16		;37 58 00 00
	cpe	,z16		;37 68 00 00
	cpe	offset16,x16	;37 48s00r00
	cpe	offset16,y16	;37 58s00r00
	cpe	offset16,z16	;37 68s00r00
	cpe	offset16,x	;37 48s00r00
	cpe	offset16,y	;37 58s00r00
	cpe	offset16,z	;37 68s00r00
	cpe	ind16,x16	;37 48 34 56
	cpe	ind16,y16	;37 58 34 56
	cpe	ind16,z16	;37 68 34 56
	cpe	ind16,x		;37 48 34 56
	cpe	ind16,y		;37 58 34 56
	cpe	ind16,z		;37 68 34 56
	cpe	address		;37 78 11 22
	cpe	external	;37 78s00r00

	cps	,x		;4F 00
	cps	,y		;5F 00
	cps	,z		;6F 00
	cps	,x8		;4F 00
	cps	,y8		;5F 00
	cps	,z8		;6F 00
	cps	,x16		;17 4F 00 00
	cps	,y16		;17 5F 00 00
	cps	,z16		;17 6F 00 00
	cps	offset8,x8	;4Fu00
	cps	offset8,y8	;5Fu00
	cps	offset8,z8	;6Fu00
	cps	ind8,x8		;4F 12
	cps	ind8,y8		;5F 12
	cps	ind8,z8		;6F 12
	cps	ind8,x		;4F 12
	cps	ind8,y		;5F 12
	cps	ind8,z		;6F 12
	cps	#imm16		;37 7F 23 45
	cps	#num16		;37 7Fs00r00
	cps	offset16,x16	;17 4Fs00r00
	cps	offset16,y16	;17 5Fs00r00
	cps	offset16,z16	;17 6Fs00r00
	cps	offset16,x	;17 4Fs00r00
	cps	offset16,y	;17 5Fs00r00
	cps	offset16,z	;17 6Fs00r00
	cps	ind16,x16	;17 4F 34 56
	cps	ind16,y16	;17 5F 34 56
	cps	ind16,z16	;17 6F 34 56
	cps	ind16,x		;17 4F 34 56
	cps	ind16,y		;17 5F 34 56
	cps	ind16,z		;17 6F 34 56
	cps	address		;17 7F 11 22
	cps	external	;17 7Fs00r00

	cpx	,x		;4C 00
	cpx	,y		;5C 00
	cpx	,z		;6C 00
	cpx	,x8		;4C 00
	cpx	,y8		;5C 00
	cpx	,z8		;6C 00
	cpx	,x16		;17 4C 00 00
	cpx	,y16		;17 5C 00 00
	cpx	,z16		;17 6C 00 00
	cpx	offset8,x8	;4Cu00
	cpx	offset8,y8	;5Cu00
	cpx	offset8,z8	;6Cu00
	cpx	ind8,x8		;4C 12
	cpx	ind8,y8		;5C 12
	cpx	ind8,z8		;6C 12
	cpx	ind8,x		;4C 12
	cpx	ind8,y		;5C 12
	cpx	ind8,z		;6C 12
	cpx	#imm16		;37 7C 23 45
	cpx	#num16		;37 7Cs00r00
	cpx	offset16,x16	;17 4Cs00r00
	cpx	offset16,y16	;17 5Cs00r00
	cpx	offset16,z16	;17 6Cs00r00
	cpx	offset16,x	;17 4Cs00r00
	cpx	offset16,y	;17 5Cs00r00
	cpx	offset16,z	;17 6Cs00r00
	cpx	ind16,x16	;17 4C 34 56
	cpx	ind16,y16	;17 5C 34 56
	cpx	ind16,z16	;17 6C 34 56
	cpx	ind16,x		;17 4C 34 56
	cpx	ind16,y		;17 5C 34 56
	cpx	ind16,z		;17 6C 34 56
	cpx	address		;17 7C 11 22
	cpx	external	;17 7Cs00r00

	cpy	,x		;4D 00
	cpy	,y		;5D 00
	cpy	,z		;6D 00
	cpy	,x8		;4D 00
	cpy	,y8		;5D 00
	cpy	,z8		;6D 00
	cpy	,x16		;17 4D 00 00
	cpy	,y16		;17 5D 00 00
	cpy	,z16		;17 6D 00 00
	cpy	offset8,x8	;4Du00
	cpy	offset8,y8	;5Du00
	cpy	offset8,z8	;6Du00
	cpy	ind8,x8		;4D 12
	cpy	ind8,y8		;5D 12
	cpy	ind8,z8		;6D 12
	cpy	ind8,x		;4D 12
	cpy	ind8,y		;5D 12
	cpy	ind8,z		;6D 12
	cpy	#imm16		;37 7D 23 45
	cpy	#num16		;37 7Ds00r00
	cpy	offset16,x16	;17 4Ds00r00
	cpy	offset16,y16	;17 5Ds00r00
	cpy	offset16,z16	;17 6Ds00r00
	cpy	offset16,x	;17 4Ds00r00
	cpy	offset16,y	;17 5Ds00r00
	cpy	offset16,z	;17 6Ds00r00
	cpy	ind16,x16	;17 4D 34 56
	cpy	ind16,y16	;17 5D 34 56
	cpy	ind16,z16	;17 6D 34 56
	cpy	ind16,x		;17 4D 34 56
	cpy	ind16,y		;17 5D 34 56
	cpy	ind16,z		;17 6D 34 56
	cpy	address		;17 7D 11 22
	cpy	external	;17 7Ds00r00

	cpz	,x		;4E 00
	cpz	,y		;5E 00
	cpz	,z		;6E 00
	cpz	,x8		;4E 00
	cpz	,y8		;5E 00
	cpz	,z8		;6E 00
	cpz	,x16		;17 4E 00 00
	cpz	,y16		;17 5E 00 00
	cpz	,z16		;17 6E 00 00
	cpz	offset8,x8	;4Eu00
	cpz	offset8,y8	;5Eu00
	cpz	offset8,z8	;6Eu00
	cpz	ind8,x8		;4E 12
	cpz	ind8,y8		;5E 12
	cpz	ind8,z8		;6E 12
	cpz	ind8,x		;4E 12
	cpz	ind8,y		;5E 12
	cpz	ind8,z		;6E 12
	cpz	#imm16		;37 7E 23 45
	cpz	#num16		;37 7Es00r00
	cpz	offset16,x16	;17 4Es00r00
	cpz	offset16,y16	;17 5Es00r00
	cpz	offset16,z16	;17 6Es00r00
	cpz	offset16,x	;17 4Es00r00
	cpz	offset16,y	;17 5Es00r00
	cpz	offset16,z	;17 6Es00r00
	cpz	ind16,x16	;17 4E 34 56
	cpz	ind16,y16	;17 5E 34 56
	cpz	ind16,z16	;17 6E 34 56
	cpz	ind16,x		;17 4E 34 56
	cpz	ind16,y		;17 5E 34 56
	cpz	ind16,z		;17 6E 34 56
	cpz	address		;17 7E 11 22
	cpz	external	;17 7Es00r00

	daa			;37 21

	dec	,x		;01 00
	dec	,y		;11 00
	dec	,z		;21 00
	dec	,x8		;01 00
	dec	,y8		;11 00
	dec	,z8		;21 00
	dec	,x16		;17 01 00 00
	dec	,y16		;17 11 00 00
	dec	,z16		;17 21 00 00
	dec	offset8,x8	;01u00
	dec	offset8,y8	;11u00
	dec	offset8,z8	;21u00
	dec	ind8,x8		;01 12
	dec	ind8,y8		;11 12
	dec	ind8,z8		;21 12
	dec	ind8,x		;01 12
	dec	ind8,y		;11 12
	dec	ind8,z		;21 12
	dec	offset16,x16	;17 01s00r00
	dec	offset16,y16	;17 11s00r00
	dec	offset16,z16	;17 21s00r00
	dec	offset16,x	;17 01s00r00
	dec	offset16,y	;17 11s00r00
	dec	offset16,z	;17 21s00r00
	dec	ind16,x16	;17 01 34 56
	dec	ind16,y16	;17 11 34 56
	dec	ind16,z16	;17 21 34 56
	dec	ind16,x		;17 01 34 56
	dec	ind16,y		;17 11 34 56
	dec	ind16,z		;17 21 34 56
	dec	address		;17 31 11 22
	dec	external	;17 31s00r00

	deca			;37 01
	decb			;37 11

	decw	,x		;27 01 00 00
	decw	,y		;27 11 00 00
	decw	,z		;27 21 00 00
	decw	,x16		;27 01 00 00
	decw	,y16		;27 11 00 00
	decw	,z16		;27 21 00 00
	decw	offset16,x16	;27 01s00r00
	decw	offset16,y16	;27 11s00r00
	decw	offset16,z16	;27 21s00r00
	decw	offset16,x	;27 01s00r00
	decw	offset16,y	;27 11s00r00
	decw	offset16,z	;27 21s00r00
	decw	ind16,x16	;27 01 34 56
	decw	ind16,y16	;27 11 34 56
	decw	ind16,z16	;27 21 34 56
	decw	ind16,x		;27 01 34 56
	decw	ind16,y		;27 11 34 56
	decw	ind16,z		;27 21 34 56
	decw	address		;27 31 11 22
	decw	external	;27 31s00r00

	ediv			;37 28
	edivs			;37 29
	emul			;37 25
	emuls			;37 26

	eora	,x		;44 00
	eora	,y		;54 00
	eora	,z		;64 00
	eora	,x8		;44 00
	eora	,y8		;54 00
	eora	,z8		;64 00
	eora	,x16		;17 44 00 00
	eora	,y16		;17 54 00 00
	eora	,z16		;17 64 00 00
	eora	offset8,x8	;44u00
	eora	offset8,y8	;54u00
	eora	offset8,z8	;64u00
	eora	ind8,x8		;44 12
	eora	ind8,y8		;54 12
	eora	ind8,z8		;64 12
	eora	ind8,x		;44 12
	eora	ind8,y		;54 12
	eora	ind8,z		;64 12
	eora	#imm8		;74 01
	eora	#num8		;74r00
	eora	offset16,x16	;17 44s00r00
	eora	offset16,y16	;17 54s00r00
	eora	offset16,z16	;17 64s00r00
	eora	offset16,x	;17 44s00r00
	eora	offset16,y	;17 54s00r00
	eora	offset16,z	;17 64s00r00
	eora	ind16,x16	;17 44 34 56
	eora	ind16,y16	;17 54 34 56
	eora	ind16,z16	;17 64 34 56
	eora	ind16,x		;17 44 34 56
	eora	ind16,y		;17 54 34 56
	eora	ind16,z		;17 64 34 56
	eora	address		;17 74 11 22
	eora	external	;17 74s00r00
	eora	e,x		;27 44
	eora	e,y		;27 54
	eora	e,z		;27 64

	eorb	,x		;C4 00
	eorb	,y		;D4 00
	eorb	,z		;E4 00
	eorb	,x8		;C4 00
	eorb	,y8		;D4 00
	eorb	,z8		;E4 00
	eorb	,x16		;17 C4 00 00
	eorb	,y16		;17 D4 00 00
	eorb	,z16		;17 E4 00 00
	eorb	offset8,x8	;C4u00
	eorb	offset8,y8	;D4u00
	eorb	offset8,z8	;E4u00
	eorb	ind8,x8		;C4 12
	eorb	ind8,y8		;D4 12
	eorb	ind8,z8		;E4 12
	eorb	ind8,x		;C4 12
	eorb	ind8,y		;D4 12
	eorb	ind8,z		;E4 12
	eorb	#imm8		;F4 01
	eorb	#num8		;F4r00
	eorb	offset16,x16	;17 C4s00r00
	eorb	offset16,y16	;17 D4s00r00
	eorb	offset16,z16	;17 E4s00r00
	eorb	offset16,x	;17 C4s00r00
	eorb	offset16,y	;17 D4s00r00
	eorb	offset16,z	;17 E4s00r00
	eorb	ind16,x16	;17 C4 34 56
	eorb	ind16,y16	;17 D4 34 56
	eorb	ind16,z16	;17 E4 34 56
	eorb	ind16,x		;17 C4 34 56
	eorb	ind16,y		;17 D4 34 56
	eorb	ind16,z		;17 E4 34 56
	eorb	address		;17 F4 11 22
	eorb	external	;17 F4s00r00
	eorb	e,x		;27 C4
	eorb	e,y		;27 D4
	eorb	e,z		;27 E4

	eord	,x		;84 00
	eord	,y		;94 00
	eord	,z		;A4 00
	eord	,x8		;84 00
	eord	,y8		;94 00
	eord	,z8		;A4 00
	eord	,x16		;37 C4 00 00
	eord	,y16		;37 D4 00 00
	eord	,z16		;37 E4 00 00
	eord	offset8,x8	;84u00
	eord	offset8,y8	;94u00
	eord	offset8,z8	;A4u00
	eord	ind8,x8		;84 12
	eord	ind8,y8		;94 12
	eord	ind8,z8		;A4 12
	eord	ind8,x		;84 12
	eord	ind8,y		;94 12
	eord	ind8,z		;A4 12
	eord	#imm16		;37 B4 23 45
	eord	#num16		;37 B4s00r00
	eord	offset16,x16	;37 C4s00r00
	eord	offset16,y16	;37 D4s00r00
	eord	offset16,z16	;37 E4s00r00
	eord	offset16,x	;37 C4s00r00
	eord	offset16,y	;37 D4s00r00
	eord	offset16,z	;37 E4s00r00
	eord	ind16,x16	;37 C4 34 56
	eord	ind16,y16	;37 D4 34 56
	eord	ind16,z16	;37 E4 34 56
	eord	ind16,x		;37 C4 34 56
	eord	ind16,y		;37 D4 34 56
	eord	ind16,z		;37 E4 34 56
	eord	address		;37 F4 11 22
	eord	external	;37 F4s00r00
	eord	e,x		;27 84
	eord	e,y		;27 94
	eord	e,z		;27 A4

	eore	#imm16		;37 34 23 45
	eore	#num16		;37 34s00r00
	eore	,x		;37 44 00 00
	eore	,y		;37 54 00 00
	eore	,z		;37 64 00 00
	eore	,x16		;37 44 00 00
	eore	,y16		;37 54 00 00
	eore	,z16		;37 64 00 00
	eore	offset16,x16	;37 44s00r00
	eore	offset16,y16	;37 54s00r00
	eore	offset16,z16	;37 64s00r00
	eore	offset16,x	;37 44s00r00
	eore	offset16,y	;37 54s00r00
	eore	offset16,z	;37 64s00r00
	eore	ind16,x16	;37 44 34 56
	eore	ind16,y16	;37 54 34 56
	eore	ind16,z16	;37 64 34 56
	eore	ind16,x		;37 44 34 56
	eore	ind16,y		;37 54 34 56
	eore	ind16,z		;37 64 34 56
	eore	address		;37 74 11 22
	eore	external	;37 74s00r00

	fdiv			;37 2B
	fmuls			;37 27
	idiv			;37 2A

	inc	,x		;03 00
	inc	,y		;13 00
	inc	,z		;23 00
	inc	,x8		;03 00
	inc	,y8		;13 00
	inc	,z8		;23 00
	inc	,x16		;17 03 00 00
	inc	,y16		;17 13 00 00
	inc	,z16		;17 23 00 00
	inc	offset8,x8	;03u00
	inc	offset8,y8	;13u00
	inc	offset8,z8	;23u00
	inc	ind8,x8		;03 12
	inc	ind8,y8		;13 12
	inc	ind8,z8		;23 12
	inc	ind8,x		;03 12
	inc	ind8,y		;13 12
	inc	ind8,z		;23 12
	inc	offset16,x16	;17 03s00r00
	inc	offset16,y16	;17 13s00r00
	inc	offset16,z16	;17 23s00r00
	inc	offset16,x	;17 03s00r00
	inc	offset16,y	;17 13s00r00
	inc	offset16,z	;17 23s00r00
	inc	ind16,x16	;17 03 34 56
	inc	ind16,y16	;17 13 34 56
	inc	ind16,z16	;17 23 34 56
	inc	ind16,x		;17 03 34 56
	inc	ind16,y		;17 13 34 56
	inc	ind16,z		;17 23 34 56
	inc	address		;17 33 11 22
	inc	external	;17 33s00r00

	inca			;37 03
	incb			;37 13

	incw	,x		;27 03 00 00
	incw	,y		;27 13 00 00
	incw	,z		;27 23 00 00
	incw	,x16		;27 03 00 00
	incw	,y16		;27 13 00 00
	incw	,z16		;27 23 00 00
	incw	offset16,x16	;27 03s00r00
	incw	offset16,y16	;27 13s00r00
	incw	offset16,z16	;27 23s00r00
	incw	offset16,x	;27 03s00r00
	incw	offset16,y	;27 13s00r00
	incw	offset16,z	;27 23s00r00
	incw	ind16,x16	;27 03 34 56
	incw	ind16,y16	;27 13 34 56
	incw	ind16,z16	;27 23 34 56
	incw	ind16,x		;27 03 34 56
	incw	ind16,y		;27 13 34 56
	incw	ind16,z		;27 23 34 56
	incw	address		;27 33 11 22
	incw	external	;27 33s00r00

	jmp	#bnk,offset16,x16	;4B 03s00r00
	jmp	#bnk,offset16,y16	;5B 03s00r00
	jmp	#bnk,offset16,z16	;6B 03s00r00
	jmp	#bnk,offset16,x		;4B 03s00r00
	jmp	#bnk,offset16,y		;5B 03s00r00
	jmp	#bnk,offset16,z		;6B 03s00r00
	jmp	#bnk,ind16,x16		;4B 03 34 56
	jmp	#bnk,ind16,y16		;5B 03 34 56
	jmp	#bnk,ind16,z16		;6B 03 34 56
	jmp	#bnk,ind16,x		;4B 03 34 56
	jmp	#bnk,ind16,y		;5B 03 34 56
	jmp	#bnk,ind16,z		;6B 03 34 56
	jmp	#bnk,address		;70 03 11 22
	jmp	#bnk,external		;70 03s00r00

	jmp	ebnk,offset16,x16	;4Bu00s00r00
	jmp	ebnk,offset16,y16	;5Bu00s00r00
	jmp	ebnk,offset16,z16	;6Bu00s00r00
	jmp	ebnk,offset16,x		;4Bu00s00r00
	jmp	ebnk,offset16,y		;5Bu00s00r00
	jmp	ebnk,offset16,z		;6Bu00s00r00
	jmp	ebnk,ind16,x16		;4Bu00 34 56
	jmp	ebnk,ind16,y16		;5Bu00 34 56
	jmp	ebnk,ind16,z16		;6Bu00 34 56
	jmp	ebnk,ind16,x		;4Bu00 34 56
	jmp	ebnk,ind16,y		;5Bu00 34 56
	jmp	ebnk,ind16,z		;6Bu00 34 56
	jmp	ebnk,address		;70u00 11 22
	jmp	ebnk,external		;70u00s00r00

	jsr	#bnk,offset16,x16	;89 03s00r00
	jsr	#bnk,offset16,y16	;99 03s00r00
	jsr	#bnk,offset16,z16	;A9 03s00r00
	jsr	#bnk,offset16,x		;89 03s00r00
	jsr	#bnk,offset16,y		;99 03s00r00
	jsr	#bnk,offset16,z		;A9 03s00r00
	jsr	#bnk,ind16,x16		;89 03 34 56
	jsr	#bnk,ind16,y16		;99 03 34 56
	jsr	#bnk,ind16,z16		;A9 03 34 56
	jsr	#bnk,ind16,x		;89 03 34 56
	jsr	#bnk,ind16,y		;99 03 34 56
	jsr	#bnk,ind16,z		;A9 03 34 56
	jsr	#bnk,address		;FA 03 11 22
	jsr	#bnk,external		;FA 03s00r00

	jsr	ebnk,offset16,x16	;89u00s00r00
	jsr	ebnk,offset16,y16	;99u00s00r00
	jsr	ebnk,offset16,z16	;A9u00s00r00
	jsr	ebnk,offset16,x		;89u00s00r00
	jsr	ebnk,offset16,y		;99u00s00r00
	jsr	ebnk,offset16,z		;A9u00s00r00
	jsr	ebnk,ind16,x16		;89u00 34 56
	jsr	ebnk,ind16,y16		;99u00 34 56
	jsr	ebnk,ind16,z16		;A9u00 34 56
	jsr	ebnk,ind16,x		;89u00 34 56
	jsr	ebnk,ind16,y		;99u00 34 56
	jsr	ebnk,ind16,z		;A9u00 34 56
	jsr	ebnk,address		;FAu00 11 22
	jsr	ebnk,external		;FAu00s00r00

	lbcc	.+0x16		;37 84 00 10
	lbcs	.+0x16		;37 85 00 10
	lbeq	.+0x16		;37 87 00 10
	lbev	.+0x16		;37 91 00 10
	lbge	.+0x16		;37 8C 00 10
	lbgt	.+0x16		;37 8E 00 10
	lbhi	.+0x16		;37 82 00 10
	lbhis	.+0x16		;37 84 00 10
	lbhs	.+0x16		;37 84 00 10
	lble	.+0x16		;37 8F 00 10
	lblo	.+0x16		;37 85 00 10
	lblos	.+0x16		;37 83 00 10
	lbls	.+0x16		;37 83 00 10
	lblt	.+0x16		;37 8D 00 10
	lbmi	.+0x16		;37 8B 00 10
	lbmv	.+0x16		;37 90 00 10
	lbne	.+0x16		;37 86 00 10
	lbpl	.+0x16		;37 8A 00 10
	lbra	.+0x16		;37 80 00 10
	lbrn	.+0x16		;37 81 00 10
	lbsr	.+0x16		;27 F9 00 10
	lbvc	.+0x16		;37 88 00 10
	lbvs	.+0x16		;37 89 00 10

	lbcc	external	;37 84qFFpFE
	lbcs	external	;37 85qFFpFE
	lbeq	external	;37 87qFFpFE
	lbev	external	;37 91qFFpFE
	lbge	external	;37 8CqFFpFE
	lbgt	external	;37 8EqFFpFE
	lbhi	external	;37 82qFFpFE
	lbhis	external	;37 84qFFpFE
	lbhs	external	;37 84qFFpFE
	lble	external	;37 8FqFFpFE
	lblo	external	;37 85qFFpFE
	lblos	external	;37 83qFFpFE
	lbls	external	;37 83qFFpFE
	lblt	external	;37 8DqFFpFE
	lbmi	external	;37 8BqFFpFE
	lbmv	external	;37 90qFFpFE
	lbne	external	;37 86qFFpFE
	lbpl	external	;37 8AqFFpFE
	lbra	external	;37 80qFFpFE
	lbrn	external	;37 81qFFpFE
	lbsr	external	;27 F9qFFpFE
	lbvc	external	;37 88qFFpFE
	lbvs	external	;37 89qFFpFE

long:	lbcc	long		;37 84 FF FA
	lbcs	long		;37 85 FF F6
	lbeq	long		;37 87 FF F2
	lbev	long		;37 91 FF EE
	lbge	long		;37 8C FF EA
	lbgt	long		;37 8E FF E6
	lbhi	long		;37 82 FF E2
	lbhis	long		;37 84 FF DE
	lbhs	long		;37 84 FF DA
	lble	long		;37 8F FF D6
	lblo	long		;37 85 FF D2
	lblos	long		;37 83 FF CE
	lbls	long		;37 83 FF CA
	lblt	long		;37 8D FF C6
	lbmi	long		;37 8B FF C2
	lbmv	long		;37 90 FF BE
	lbne	long		;37 86 FF BA
	lbpl	long		;37 8A FF B6
	lbra	long		;37 80 FF B2
	lbrn	long		;37 81 FF AE
	lbsr	long		;27 F9 FF AA
	lbvc	long		;37 88 FF A6
	lbvs	long		;37 89 FF A2

	ldaa	,x		;45 00
	ldaa	,y		;55 00
	ldaa	,z		;65 00
	ldaa	,x8		;45 00
	ldaa	,y8		;55 00
	ldaa	,z8		;65 00
	ldaa	,x16		;17 45 00 00
	ldaa	,y16		;17 55 00 00
	ldaa	,z16		;17 65 00 00
	ldaa	offset8,x8	;45u00
	ldaa	offset8,y8	;55u00
	ldaa	offset8,z8	;65u00
	ldaa	ind8,x8		;45 12
	ldaa	ind8,y8		;55 12
	ldaa	ind8,z8		;65 12
	ldaa	ind8,x		;45 12
	ldaa	ind8,y		;55 12
	ldaa	ind8,z		;65 12
	ldaa	#imm8		;75 01
	ldaa	#num8		;75r00
	ldaa	offset16,x16	;17 45s00r00
	ldaa	offset16,y16	;17 55s00r00
	ldaa	offset16,z16	;17 65s00r00
	ldaa	offset16,x	;17 45s00r00
	ldaa	offset16,y	;17 55s00r00
	ldaa	offset16,z	;17 65s00r00
	ldaa	ind16,x16	;17 45 34 56
	ldaa	ind16,y16	;17 55 34 56
	ldaa	ind16,z16	;17 65 34 56
	ldaa	ind16,x		;17 45 34 56
	ldaa	ind16,y		;17 55 34 56
	ldaa	ind16,z		;17 65 34 56
	ldaa	address		;17 75 11 22
	ldaa	external	;17 75s00r00
	ldaa	e,x		;27 45
	ldaa	e,y		;27 55
	ldaa	e,z		;27 65

	ldab	,x		;C5 00
	ldab	,y		;D5 00
	ldab	,z		;E5 00
	ldab	,x8		;C5 00
	ldab	,y8		;D5 00
	ldab	,z8		;E5 00
	ldab	,x16		;17 C5 00 00
	ldab	,y16		;17 D5 00 00
	ldab	,z16		;17 E5 00 00
	ldab	offset8,x8	;C5u00
	ldab	offset8,y8	;D5u00
	ldab	offset8,z8	;E5u00
	ldab	ind8,x8		;C5 12
	ldab	ind8,y8		;D5 12
	ldab	ind8,z8		;E5 12
	ldab	ind8,x		;C5 12
	ldab	ind8,y		;D5 12
	ldab	ind8,z		;E5 12
	ldab	#imm8		;F5 01
	ldab	#num8		;F5r00
	ldab	offset16,x16	;17 C5s00r00
	ldab	offset16,y16	;17 D5s00r00
	ldab	offset16,z16	;17 E5s00r00
	ldab	offset16,x	;17 C5s00r00
	ldab	offset16,y	;17 D5s00r00
	ldab	offset16,z	;17 E5s00r00
	ldab	ind16,x16	;17 C5 34 56
	ldab	ind16,y16	;17 D5 34 56
	ldab	ind16,z16	;17 E5 34 56
	ldab	ind16,x		;17 C5 34 56
	ldab	ind16,y		;17 D5 34 56
	ldab	ind16,z		;17 E5 34 56
	ldab	address		;17 F5 11 22
	ldab	external	;17 F5s00r00
	ldab	e,x		;27 C5
	ldab	e,y		;27 D5
	ldab	e,z		;27 E5

	ldd	,x		;85 00
	ldd	,y		;95 00
	ldd	,z		;A5 00
	ldd	,x8		;85 00
	ldd	,y8		;95 00
	ldd	,z8		;A5 00
	ldd	,x16		;37 C5 00 00
	ldd	,y16		;37 D5 00 00
	ldd	,z16		;37 E5 00 00
	ldd	offset8,x8	;85u00
	ldd	offset8,y8	;95u00
	ldd	offset8,z8	;A5u00
	ldd	ind8,x8		;85 12
	ldd	ind8,y8		;95 12
	ldd	ind8,z8		;A5 12
	ldd	ind8,x		;85 12
	ldd	ind8,y		;95 12
	ldd	ind8,z		;A5 12
	ldd	#imm16		;37 B5 23 45
	ldd	#num16		;37 B5s00r00
	ldd	offset16,x16	;37 C5s00r00
	ldd	offset16,y16	;37 D5s00r00
	ldd	offset16,z16	;37 E5s00r00
	ldd	offset16,x	;37 C5s00r00
	ldd	offset16,y	;37 D5s00r00
	ldd	offset16,z	;37 E5s00r00
	ldd	ind16,x16	;37 C5 34 56
	ldd	ind16,y16	;37 D5 34 56
	ldd	ind16,z16	;37 E5 34 56
	ldd	ind16,x		;37 C5 34 56
	ldd	ind16,y		;37 D5 34 56
	ldd	ind16,z		;37 E5 34 56
	ldd	address		;37 F5 11 22
	ldd	external	;37 F5s00r00
	ldd	e,x		;27 85
	ldd	e,y		;27 95
	ldd	e,z		;27 A5

	lde	#imm16		;37 35 23 45
	lde	#num16		;37 35s00r00
	lde	,x		;37 45 00 00
	lde	,y		;37 55 00 00
	lde	,z		;37 65 00 00
	lde	,x16		;37 45 00 00
	lde	,y16		;37 55 00 00
	lde	,z16		;37 65 00 00
	lde	offset16,x16	;37 45s00r00
	lde	offset16,y16	;37 55s00r00
	lde	offset16,z16	;37 65s00r00
	lde	offset16,x	;37 45s00r00
	lde	offset16,y	;37 55s00r00
	lde	offset16,z	;37 65s00r00
	lde	ind16,x16	;37 45 34 56
	lde	ind16,y16	;37 55 34 56
	lde	ind16,z16	;37 65 34 56
	lde	ind16,x		;37 45 34 56
	lde	ind16,y		;37 55 34 56
	lde	ind16,z		;37 65 34 56
	lde	address		;37 75 11 22
	lde	external	;37 75s00r00

	lded	address		;27 71 11 22
	lded	external	;27 71s00r00

	ldhi			;27 B0

	lds	,x		;CF 00
	lds	,y		;DF 00
	lds	,z		;EF 00
	lds	,x8		;CF 00
	lds	,y8		;DF 00
	lds	,z8		;EF 00
	lds	,x16		;17 CF 00 00
	lds	,y16		;17 DF 00 00
	lds	,z16		;17 EF 00 00
	lds	offset8,x8	;CFu00
	lds	offset8,y8	;DFu00
	lds	offset8,z8	;EFu00
	lds	ind8,x8		;CF 12
	lds	ind8,y8		;DF 12
	lds	ind8,z8		;EF 12
	lds	ind8,x		;CF 12
	lds	ind8,y		;DF 12
	lds	ind8,z		;EF 12
	lds	#imm16		;37 BF 23 45
	lds	#num16		;37 BFs00r00
	lds	offset16,x16	;17 CFs00r00
	lds	offset16,y16	;17 DFs00r00
	lds	offset16,z16	;17 EFs00r00
	lds	offset16,x	;17 CFs00r00
	lds	offset16,y	;17 DFs00r00
	lds	offset16,z	;17 EFs00r00
	lds	ind16,x16	;17 CF 34 56
	lds	ind16,y16	;17 DF 34 56
	lds	ind16,z16	;17 EF 34 56
	lds	ind16,x		;17 CF 34 56
	lds	ind16,y		;17 DF 34 56
	lds	ind16,z		;17 EF 34 56
	lds	address		;17 FF 11 22
	lds	external	;17 FFs00r00

	ldx	,x		;CC 00
	ldx	,y		;DC 00
	ldx	,z		;EC 00
	ldx	,x8		;CC 00
	ldx	,y8		;DC 00
	ldx	,z8		;EC 00
	ldx	,x16		;17 CC 00 00
	ldx	,y16		;17 DC 00 00
	ldx	,z16		;17 EC 00 00
	ldx	offset8,x8	;CCu00
	ldx	offset8,y8	;DCu00
	ldx	offset8,z8	;ECu00
	ldx	ind8,x8		;CC 12
	ldx	ind8,y8		;DC 12
	ldx	ind8,z8		;EC 12
	ldx	ind8,x		;CC 12
	ldx	ind8,y		;DC 12
	ldx	ind8,z		;EC 12
	ldx	#imm16		;37 BC 23 45
	ldx	#num16		;37 BCs00r00
	ldx	offset16,x16	;17 CCs00r00
	ldx	offset16,y16	;17 DCs00r00
	ldx	offset16,z16	;17 ECs00r00
	ldx	offset16,x	;17 CCs00r00
	ldx	offset16,y	;17 DCs00r00
	ldx	offset16,z	;17 ECs00r00
	ldx	ind16,x16	;17 CC 34 56
	ldx	ind16,y16	;17 DC 34 56
	ldx	ind16,z16	;17 EC 34 56
	ldx	ind16,x		;17 CC 34 56
	ldx	ind16,y		;17 DC 34 56
	ldx	ind16,z		;17 EC 34 56
	ldx	address		;17 FC 11 22
	ldx	external	;17 FCs00r00

	ldy	,x		;CD 00
	ldy	,y		;DD 00
	ldy	,z		;ED 00
	ldy	,x8		;CD 00
	ldy	,y8		;DD 00
	ldy	,z8		;ED 00
	ldy	,x16		;17 CD 00 00
	ldy	,y16		;17 DD 00 00
	ldy	,z16		;17 ED 00 00
	ldy	offset8,x8	;CDu00
	ldy	offset8,y8	;DDu00
	ldy	offset8,z8	;EDu00
	ldy	ind8,x8		;CD 12
	ldy	ind8,y8		;DD 12
	ldy	ind8,z8		;ED 12
	ldy	ind8,x		;CD 12
	ldy	ind8,y		;DD 12
	ldy	ind8,z		;ED 12
	ldy	#imm16		;37 BD 23 45
	ldy	#num16		;37 BDs00r00
	ldy	offset16,x16	;17 CDs00r00
	ldy	offset16,y16	;17 DDs00r00
	ldy	offset16,z16	;17 EDs00r00
	ldy	offset16,x	;17 CDs00r00
	ldy	offset16,y	;17 DDs00r00
	ldy	offset16,z	;17 EDs00r00
	ldy	ind16,x16	;17 CD 34 56
	ldy	ind16,y16	;17 DD 34 56
	ldy	ind16,z16	;17 ED 34 56
	ldy	ind16,x		;17 CD 34 56
	ldy	ind16,y		;17 DD 34 56
	ldy	ind16,z		;17 ED 34 56
	ldy	address		;17 FD 11 22
	ldy	external	;17 FDs00r00

	ldz	,x		;CE 00
	ldz	,y		;DE 00
	ldz	,z		;EE 00
	ldz	,x8		;CE 00
	ldz	,y8		;DE 00
	ldz	,z8		;EE 00
	ldz	,x16		;17 CE 00 00
	ldz	,y16		;17 DE 00 00
	ldz	,z16		;17 EE 00 00
	ldz	offset8,x8	;CEu00
	ldz	offset8,y8	;DEu00
	ldz	offset8,z8	;EEu00
	ldz	ind8,x8		;CE 12
	ldz	ind8,y8		;DE 12
	ldz	ind8,z8		;EE 12
	ldz	ind8,x		;CE 12
	ldz	ind8,y		;DE 12
	ldz	ind8,z		;EE 12
	ldz	#imm16		;37 BE 23 45
	ldz	#num16		;37 BEs00r00
	ldz	offset16,x16	;17 CEs00r00
	ldz	offset16,y16	;17 DEs00r00
	ldz	offset16,z16	;17 EEs00r00
	ldz	offset16,x	;17 CEs00r00
	ldz	offset16,y	;17 DEs00r00
	ldz	offset16,z	;17 EEs00r00
	ldz	ind16,x16	;17 CE 34 56
	ldz	ind16,y16	;17 DE 34 56
	ldz	ind16,z16	;17 EE 34 56
	ldz	ind16,x		;17 CE 34 56
	ldz	ind16,y		;17 DE 34 56
	ldz	ind16,z		;17 EE 34 56
	ldz	address		;17 FE 11 22
	ldz	external	;17 FEs00r00

	lpstop			;27 F1

	lsl	,x		;04 00
	lsl	,y		;14 00
	lsl	,z		;24 00
	lsl	,x8		;04 00
	lsl	,y8		;14 00
	lsl	,z8		;24 00
	lsl	,x16		;17 04 00 00
	lsl	,y16		;17 14 00 00
	lsl	,z16		;17 24 00 00
	lsl	offset8,x8	;04u00
	lsl	offset8,y8	;14u00
	lsl	offset8,z8	;24u00
	lsl	ind8,x8		;04 12
	lsl	ind8,y8		;14 12
	lsl	ind8,z8		;24 12
	lsl	ind8,x		;04 12
	lsl	ind8,y		;14 12
	lsl	ind8,z		;24 12
	lsl	offset16,x16	;17 04s00r00
	lsl	offset16,y16	;17 14s00r00
	lsl	offset16,z16	;17 24s00r00
	lsl	offset16,x	;17 04s00r00
	lsl	offset16,y	;17 14s00r00
	lsl	offset16,z	;17 24s00r00
	lsl	ind16,x16	;17 04 34 56
	lsl	ind16,y16	;17 14 34 56
	lsl	ind16,z16	;17 24 34 56
	lsl	ind16,x		;17 04 34 56
	lsl	ind16,y		;17 14 34 56
	lsl	ind16,z		;17 24 34 56
	lsl	address		;17 34 11 22
	lsl	external	;17 34s00r00

	lsla			;37 04
	lslb			;37 14
	lsld			;27 F4
	lsle			;27 74
	lslm			;27 B6

	lslw	,x		;27 04 00 00
	lslw	,y		;27 14 00 00
	lslw	,z		;27 24 00 00
	lslw	,x16		;27 04 00 00
	lslw	,y16		;27 14 00 00
	lslw	,z16		;27 24 00 00
	lslw	offset16,x16	;27 04s00r00
	lslw	offset16,y16	;27 14s00r00
	lslw	offset16,z16	;27 24s00r00
	lslw	offset16,x	;27 04s00r00
	lslw	offset16,y	;27 14s00r00
	lslw	offset16,z	;27 24s00r00
	lslw	ind16,x16	;27 04 34 56
	lslw	ind16,y16	;27 14 34 56
	lslw	ind16,z16	;27 24 34 56
	lslw	ind16,x		;27 04 34 56
	lslw	ind16,y		;27 14 34 56
	lslw	ind16,z		;27 24 34 56
	lslw	address		;27 34 11 22
	lslw	external	;27 34s00r00

	lsr	,x		;0F 00
	lsr	,y		;1F 00
	lsr	,z		;2F 00
	lsr	,x8		;0F 00
	lsr	,y8		;1F 00
	lsr	,z8		;2F 00
	lsr	,x16		;17 0F 00 00
	lsr	,y16		;17 1F 00 00
	lsr	,z16		;17 2F 00 00
	lsr	offset8,x8	;0Fu00
	lsr	offset8,y8	;1Fu00
	lsr	offset8,z8	;2Fu00
	lsr	ind8,x8		;0F 12
	lsr	ind8,y8		;1F 12
	lsr	ind8,z8		;2F 12
	lsr	ind8,x		;0F 12
	lsr	ind8,y		;1F 12
	lsr	ind8,z		;2F 12
	lsr	offset16,x16	;17 0Fs00r00
	lsr	offset16,y16	;17 1Fs00r00
	lsr	offset16,z16	;17 2Fs00r00
	lsr	offset16,x	;17 0Fs00r00
	lsr	offset16,y	;17 1Fs00r00
	lsr	offset16,z	;17 2Fs00r00
	lsr	ind16,x16	;17 0F 34 56
	lsr	ind16,y16	;17 1F 34 56
	lsr	ind16,z16	;17 2F 34 56
	lsr	ind16,x		;17 0F 34 56
	lsr	ind16,y		;17 1F 34 56
	lsr	ind16,z		;17 2F 34 56
	lsr	address		;17 3F 11 22
	lsr	external	;17 3Fs00r00

	lsra			;37 0F
	lsrb			;37 1F
	lsrd			;27 FF
	lsre			;27 7F

	lsrw	,x		;27 0F 00 00
	lsrw	,y		;27 1F 00 00
	lsrw	,z		;27 2F 00 00
	lsrw	,x16		;27 0F 00 00
	lsrw	,y16		;27 1F 00 00
	lsrw	,z16		;27 2F 00 00
	lsrw	offset16,x16	;27 0Fs00r00
	lsrw	offset16,y16	;27 1Fs00r00
	lsrw	offset16,z16	;27 2Fs00r00
	lsrw	offset16,x	;27 0Fs00r00
	lsrw	offset16,y	;27 1Fs00r00
	lsrw	offset16,z	;27 2Fs00r00
	lsrw	ind16,x16	;27 0F 34 56
	lsrw	ind16,y16	;27 1F 34 56
	lsrw	ind16,z16	;27 2F 34 56
	lsrw	ind16,x		;27 0F 34 56
	lsrw	ind16,y		;27 1F 34 56
	lsrw	ind16,z		;27 2F 34 56
	lsrw	address		;27 3F 11 22
	lsrw	external	;27 3Fs00r00

	mac	#ix,#iy		;7B 67
	mac	#ixiy		;7B 89
	mac	#eixiy		;7Br00

	movb	address,offset8,x8	;32u00 11 22
	movb	address,offset8,y8	;32u00 11 22
	movb	address,offset8,z8	;32u00 11 22
	movb	address,offset8,x	;32u00 11 22
	movb	address,offset8,y	;32u00 11 22
	movb	address,offset8,z	;32u00 11 22
	movb	address,ind8,x8		;32 12 11 22
	movb	address,ind8,y8		;32 12 11 22
	movb	address,ind8,z8		;32 12 11 22
	movb	address,ind8,x		;32 12 11 22
	movb	address,ind8,y		;32 12 11 22
	movb	address,ind8,z		;32 12 11 22

	movb	external,offset8,x8	;32u00s00r00
	movb	external,offset8,y8	;32u00s00r00
	movb	external,offset8,z8	;32u00s00r00
	movb	external,offset8,x	;32u00s00r00
	movb	external,offset8,y	;32u00s00r00
	movb	external,offset8,z	;32u00s00r00
	movb	external,ind8,x8	;32 12s00r00
	movb	external,ind8,y8	;32 12s00r00
	movb	external,ind8,z8	;32 12s00r00
	movb	external,ind8,x		;32 12s00r00
	movb	external,ind8,y		;32 12s00r00
	movb	external,ind8,z		;32 12s00r00

	movb	offset8,x8,address	;30u00 11 22
	movb	offset8,y8,address	;30u00 11 22
	movb	offset8,z8,address	;30u00 11 22
	movb	offset8,x,address	;30u00 11 22
	movb	offset8,y,address	;30u00 11 22
	movb	offset8,z,address	;30u00 11 22
	movb	ind8,x8,address		;30 12 11 22
	movb	ind8,y8,address		;30 12 11 22
	movb	ind8,z8,address		;30 12 11 22
	movb	ind8,x,address		;30 12 11 22
	movb	ind8,y,address		;30 12 11 22
	movb	ind8,z,address		;30 12 11 22

	movb	offset8,x8,external	;30u00s00r00
	movb	offset8,y8,external	;30u00s00r00
	movb	offset8,z8,external	;30u00s00r00
	movb	offset8,x,external	;30u00s00r00
	movb	offset8,y,external	;30u00s00r00
	movb	offset8,z,external	;30u00s00r00
	movb	ind8,x8,external	;30 12s00r00
	movb	ind8,y8,external	;30 12s00r00
	movb	ind8,z8,external	;30 12s00r00
	movb	ind8,x,external		;30 12s00r00
	movb	ind8,y,external		;30 12s00r00
	movb	ind8,z,external		;30 12s00r00

	movb	address,external	;37 FE 11 22s00r00
	movb	external,address	;37 FEs00r00 11 22
	movb	address,address		;37 FE 11 22 11 22
	movb	external,external	;37 FEs00r00s00r00

	movw	address,offset8,x8	;33u00 11 22
	movw	address,offset8,y8	;33u00 11 22
	movw	address,offset8,z8	;33u00 11 22
	movw	address,offset8,x	;33u00 11 22
	movw	address,offset8,y	;33u00 11 22
	movw	address,offset8,z	;33u00 11 22
	movw	address,ind8,x8		;33 12 11 22
	movw	address,ind8,y8		;33 12 11 22
	movw	address,ind8,z8		;33 12 11 22
	movw	address,ind8,x		;33 12 11 22
	movw	address,ind8,y		;33 12 11 22
	movw	address,ind8,z		;33 12 11 22

	movw	external,offset8,x8	;33u00s00r00
	movw	external,offset8,y8	;33u00s00r00
	movw	external,offset8,z8	;33u00s00r00
	movw	external,offset8,x	;33u00s00r00
	movw	external,offset8,y	;33u00s00r00
	movw	external,offset8,z	;33u00s00r00
	movw	external,ind8,x8	;33 12s00r00
	movw	external,ind8,y8	;33 12s00r00
	movw	external,ind8,z8	;33 12s00r00
	movw	external,ind8,x		;33 12s00r00
	movw	external,ind8,y		;33 12s00r00
	movw	external,ind8,z		;33 12s00r00

	movw	offset8,x8,address	;31u00 11 22
	movw	offset8,y8,address	;31u00 11 22
	movw	offset8,z8,address	;31u00 11 22
	movw	offset8,x,address	;31u00 11 22
	movw	offset8,y,address	;31u00 11 22
	movw	offset8,z,address	;31u00 11 22
	movw	ind8,x8,address		;31 12 11 22
	movw	ind8,y8,address		;31 12 11 22
	movw	ind8,z8,address		;31 12 11 22
	movw	ind8,x,address		;31 12 11 22
	movw	ind8,y,address		;31 12 11 22
	movw	ind8,z,address		;31 12 11 22

	movw	offset8,x8,external	;31u00s00r00
	movw	offset8,y8,external	;31u00s00r00
	movw	offset8,z8,external	;31u00s00r00
	movw	offset8,x,external	;31u00s00r00
	movw	offset8,y,external	;31u00s00r00
	movw	offset8,z,external	;31u00s00r00
	movw	ind8,x8,external	;31 12s00r00
	movw	ind8,y8,external	;31 12s00r00
	movw	ind8,z8,external	;31 12s00r00
	movw	ind8,x,external		;31 12s00r00
	movw	ind8,y,external		;31 12s00r00
	movw	ind8,z,external		;31 12s00r00

	movw	address,external	;37 FF 11 22s00r00
	movw	external,address	;37 FFs00r00 11 22
	movw	address,address		;37 FF 11 22 11 22
	movw	external,external	;37 FFs00r00s00r00

	mul			;37 24

	neg	,x		;02 00
	neg	,y		;12 00
	neg	,z		;22 00
	neg	,x8		;02 00
	neg	,y8		;12 00
	neg	,z8		;22 00
	neg	,x16		;17 02 00 00
	neg	,y16		;17 12 00 00
	neg	,z16		;17 22 00 00
	neg	offset8,x8	;02u00
	neg	offset8,y8	;12u00
	neg	offset8,z8	;22u00
	neg	ind8,x8		;02 12
	neg	ind8,y8		;12 12
	neg	ind8,z8		;22 12
	neg	ind8,x		;02 12
	neg	ind8,y		;12 12
	neg	ind8,z		;22 12
	neg	offset16,x16	;17 02s00r00
	neg	offset16,y16	;17 12s00r00
	neg	offset16,z16	;17 22s00r00
	neg	offset16,x	;17 02s00r00
	neg	offset16,y	;17 12s00r00
	neg	offset16,z	;17 22s00r00
	neg	ind16,x16	;17 02 34 56
	neg	ind16,y16	;17 12 34 56
	neg	ind16,z16	;17 22 34 56
	neg	ind16,x		;17 02 34 56
	neg	ind16,y		;17 12 34 56
	neg	ind16,z		;17 22 34 56
	neg	address		;17 32 11 22
	neg	external	;17 32s00r00

	nega			;37 02
	negb			;37 12
	negd			;27 F2
	nege			;27 72

	negw	,x		;27 02 00 00
	negw	,y		;27 12 00 00
	negw	,z		;27 22 00 00
	negw	,x16		;27 02 00 00
	negw	,y16		;27 12 00 00
	negw	,z16		;27 22 00 00
	negw	offset16,x16	;27 02s00r00
	negw	offset16,y16	;27 12s00r00
	negw	offset16,z16	;27 22s00r00
	negw	offset16,x	;27 02s00r00
	negw	offset16,y	;27 12s00r00
	negw	offset16,z	;27 22s00r00
	negw	ind16,x16	;27 02 34 56
	negw	ind16,y16	;27 12 34 56
	negw	ind16,z16	;27 22 34 56
	negw	ind16,x		;27 02 34 56
	negw	ind16,y		;27 12 34 56
	negw	ind16,z		;27 22 34 56
	negw	address		;27 32 11 22
	negw	external	;27 32s00r00

	nop			;27 4C

	oraa	,x		;47 00
	oraa	,y		;57 00
	oraa	,z		;67 00
	oraa	,x8		;47 00
	oraa	,y8		;57 00
	oraa	,z8		;67 00
	oraa	,x16		;17 47 00 00
	oraa	,y16		;17 57 00 00
	oraa	,z16		;17 67 00 00
	oraa	offset8,x8	;47u00
	oraa	offset8,y8	;57u00
	oraa	offset8,z8	;67u00
	oraa	ind8,x8		;47 12
	oraa	ind8,y8		;57 12
	oraa	ind8,z8		;67 12
	oraa	ind8,x		;47 12
	oraa	ind8,y		;57 12
	oraa	ind8,z		;67 12
	oraa	#imm8		;77 01
	oraa	#num8		;77r00
	oraa	offset16,x16	;17 47s00r00
	oraa	offset16,y16	;17 57s00r00
	oraa	offset16,z16	;17 67s00r00
	oraa	offset16,x	;17 47s00r00
	oraa	offset16,y	;17 57s00r00
	oraa	offset16,z	;17 67s00r00
	oraa	ind16,x16	;17 47 34 56
	oraa	ind16,y16	;17 57 34 56
	oraa	ind16,z16	;17 67 34 56
	oraa	ind16,x		;17 47 34 56
	oraa	ind16,y		;17 57 34 56
	oraa	ind16,z		;17 67 34 56
	oraa	address		;17 77 11 22
	oraa	external	;17 77s00r00
	oraa	e,x		;27 47
	oraa	e,y		;27 57
	oraa	e,z		;27 67

	orab	,x		;C7 00
	orab	,y		;D7 00
	orab	,z		;E7 00
	orab	,x8		;C7 00
	orab	,y8		;D7 00
	orab	,z8		;E7 00
	orab	,x16		;17 C7 00 00
	orab	,y16		;17 D7 00 00
	orab	,z16		;17 E7 00 00
	orab	offset8,x8	;C7u00
	orab	offset8,y8	;D7u00
	orab	offset8,z8	;E7u00
	orab	ind8,x8		;C7 12
	orab	ind8,y8		;D7 12
	orab	ind8,z8		;E7 12
	orab	ind8,x		;C7 12
	orab	ind8,y		;D7 12
	orab	ind8,z		;E7 12
	orab	#imm8		;F7 01
	orab	#num8		;F7r00
	orab	offset16,x16	;17 C7s00r00
	orab	offset16,y16	;17 D7s00r00
	orab	offset16,z16	;17 E7s00r00
	orab	offset16,x	;17 C7s00r00
	orab	offset16,y	;17 D7s00r00
	orab	offset16,z	;17 E7s00r00
	orab	ind16,x16	;17 C7 34 56
	orab	ind16,y16	;17 D7 34 56
	orab	ind16,z16	;17 E7 34 56
	orab	ind16,x		;17 C7 34 56
	orab	ind16,y		;17 D7 34 56
	orab	ind16,z		;17 E7 34 56
	orab	address		;17 F7 11 22
	orab	external	;17 F7s00r00
	orab	e,x		;27 C7
	orab	e,y		;27 D7
	orab	e,z		;27 E7

	ord	,x		;87 00
	ord	,y		;97 00
	ord	,z		;A7 00
	ord	,x8		;87 00
	ord	,y8		;97 00
	ord	,z8		;A7 00
	ord	,x16		;37 C7 00 00
	ord	,y16		;37 D7 00 00
	ord	,z16		;37 E7 00 00
	ord	offset8,x8	;87u00
	ord	offset8,y8	;97u00
	ord	offset8,z8	;A7u00
	ord	ind8,x8		;87 12
	ord	ind8,y8		;97 12
	ord	ind8,z8		;A7 12
	ord	ind8,x		;87 12
	ord	ind8,y		;97 12
	ord	ind8,z		;A7 12
	ord	#imm16		;37 B7 23 45
	ord	#num16		;37 B7s00r00
	ord	offset16,x16	;37 C7s00r00
	ord	offset16,y16	;37 D7s00r00
	ord	offset16,z16	;37 E7s00r00
	ord	offset16,x	;37 C7s00r00
	ord	offset16,y	;37 D7s00r00
	ord	offset16,z	;37 E7s00r00
	ord	ind16,x16	;37 C7 34 56
	ord	ind16,y16	;37 D7 34 56
	ord	ind16,z16	;37 E7 34 56
	ord	ind16,x		;37 C7 34 56
	ord	ind16,y		;37 D7 34 56
	ord	ind16,z		;37 E7 34 56
	ord	address		;37 F7 11 22
	ord	external	;37 F7s00r00
	ord	e,x		;27 87
	ord	e,y		;27 97
	ord	e,z		;27 A7

	ore	#imm16		;37 37 23 45
	ore	#num16		;37 37s00r00
	ore	,x		;37 47 00 00
	ore	,y		;37 57 00 00
	ore	,z		;37 67 00 00
	ore	,x16		;37 47 00 00
	ore	,y16		;37 57 00 00
	ore	,z16		;37 67 00 00
	ore	offset16,x16	;37 47s00r00
	ore	offset16,y16	;37 57s00r00
	ore	offset16,z16	;37 67s00r00
	ore	offset16,x	;37 47s00r00
	ore	offset16,y	;37 57s00r00
	ore	offset16,z	;37 67s00r00
	ore	ind16,x16	;37 47 34 56
	ore	ind16,y16	;37 57 34 56
	ore	ind16,z16	;37 67 34 56
	ore	ind16,x		;37 47 34 56
	ore	ind16,y		;37 57 34 56
	ore	ind16,z		;37 67 34 56
	ore	address		;37 77 11 22
	ore	external	;37 77s00r00

	orp	#imm8		;37 3B 00 01
	orp	#num8		;37 3Bs00r00
	orp	#imm16		;37 3B 23 45
	orp	#num16		;37 3Bs00r00

	psha			;37 08
	pshb			;37 18

	pula			;37 09
	pulb			;37 19

	pshmac			;27 B8
	pulmac			;27 B9

	pshm	d			;34 01
	pshm	d,e			;34 03
	pshm	d,e,x			;34 07
	pshm	d,e,x,y			;34 0f
	pshm	d,e,x,y,z		;34 1f
	pshm	d,e,x,y,z,k		;34 3f
	pshm	d,e,x,y,z,k,ccr		;34 7f

	pulm	ccr			;35 01
	pulm	ccr,k			;35 03
	pulm	ccr,k,z			;35 07
	pulm	ccr,k,z,y		;35 0f
	pulm	ccr,k,z,y,x		;35 1f
	pulm	ccr,k,z,y,x,e		;35 3f
	pulm	ccr,k,z,y,x,e,d		;35 7f

	rmac	#ix,#iy		;FB 67
	rmac	#ixiy		;FB 89
	rmac	#eixiy		;FBr00

	rol	,x		;0C 00
	rol	,y		;1C 00
	rol	,z		;2C 00
	rol	,x8		;0C 00
	rol	,y8		;1C 00
	rol	,z8		;2C 00
	rol	,x16		;17 0C 00 00
	rol	,y16		;17 1C 00 00
	rol	,z16		;17 2C 00 00
	rol	offset8,x8	;0Cu00
	rol	offset8,y8	;1Cu00
	rol	offset8,z8	;2Cu00
	rol	ind8,x8		;0C 12
	rol	ind8,y8		;1C 12
	rol	ind8,z8		;2C 12
	rol	ind8,x		;0C 12
	rol	ind8,y		;1C 12
	rol	ind8,z		;2C 12
	rol	offset16,x16	;17 0Cs00r00
	rol	offset16,y16	;17 1Cs00r00
	rol	offset16,z16	;17 2Cs00r00
	rol	offset16,x	;17 0Cs00r00
	rol	offset16,y	;17 1Cs00r00
	rol	offset16,z	;17 2Cs00r00
	rol	ind16,x16	;17 0C 34 56
	rol	ind16,y16	;17 1C 34 56
	rol	ind16,z16	;17 2C 34 56
	rol	ind16,x		;17 0C 34 56
	rol	ind16,y		;17 1C 34 56
	rol	ind16,z		;17 2C 34 56
	rol	address		;17 3C 11 22
	rol	external	;17 3Cs00r00

	rola			;37 0C
	rolb			;37 1C
	rold			;27 FC
	role			;27 7C

	rolw	,x		;27 0C 00 00
	rolw	,y		;27 1C 00 00
	rolw	,z		;27 2C 00 00
	rolw	,x16		;27 0C 00 00
	rolw	,y16		;27 1C 00 00
	rolw	,z16		;27 2C 00 00
	rolw	offset16,x16	;27 0Cs00r00
	rolw	offset16,y16	;27 1Cs00r00
	rolw	offset16,z16	;27 2Cs00r00
	rolw	offset16,x	;27 0Cs00r00
	rolw	offset16,y	;27 1Cs00r00
	rolw	offset16,z	;27 2Cs00r00
	rolw	ind16,x16	;27 0C 34 56
	rolw	ind16,y16	;27 1C 34 56
	rolw	ind16,z16	;27 2C 34 56
	rolw	ind16,x		;27 0C 34 56
	rolw	ind16,y		;27 1C 34 56
	rolw	ind16,z		;27 2C 34 56
	rolw	address		;27 3C 11 22
	rolw	external	;27 3Cs00r00

	ror	,x		;0E 00
	ror	,y		;1E 00
	ror	,z		;2E 00
	ror	,x8		;0E 00
	ror	,y8		;1E 00
	ror	,z8		;2E 00
	ror	,x16		;17 0E 00 00
	ror	,y16		;17 1E 00 00
	ror	,z16		;17 2E 00 00
	ror	offset8,x8	;0Eu00
	ror	offset8,y8	;1Eu00
	ror	offset8,z8	;2Eu00
	ror	ind8,x8		;0E 12
	ror	ind8,y8		;1E 12
	ror	ind8,z8		;2E 12
	ror	ind8,x		;0E 12
	ror	ind8,y		;1E 12
	ror	ind8,z		;2E 12
	ror	offset16,x16	;17 0Es00r00
	ror	offset16,y16	;17 1Es00r00
	ror	offset16,z16	;17 2Es00r00
	ror	offset16,x	;17 0Es00r00
	ror	offset16,y	;17 1Es00r00
	ror	offset16,z	;17 2Es00r00
	ror	ind16,x16	;17 0E 34 56
	ror	ind16,y16	;17 1E 34 56
	ror	ind16,z16	;17 2E 34 56
	ror	ind16,x		;17 0E 34 56
	ror	ind16,y		;17 1E 34 56
	ror	ind16,z		;17 2E 34 56
	ror	address		;17 3E 11 22
	ror	external	;17 3Es00r00

	rora			;37 0E
	rorb			;37 1E
	rord			;27 FE
	rore			;27 7E

	rorw	,x		;27 0E 00 00
	rorw	,y		;27 1E 00 00
	rorw	,z		;27 2E 00 00
	rorw	,x16		;27 0E 00 00
	rorw	,y16		;27 1E 00 00
	rorw	,z16		;27 2E 00 00
	rorw	offset16,x16	;27 0Es00r00
	rorw	offset16,y16	;27 1Es00r00
	rorw	offset16,z16	;27 2Es00r00
	rorw	offset16,x	;27 0Es00r00
	rorw	offset16,y	;27 1Es00r00
	rorw	offset16,z	;27 2Es00r00
	rorw	ind16,x16	;27 0E 34 56
	rorw	ind16,y16	;27 1E 34 56
	rorw	ind16,z16	;27 2E 34 56
	rorw	ind16,x		;27 0E 34 56
	rorw	ind16,y		;27 1E 34 56
	rorw	ind16,z		;27 2E 34 56
	rorw	address		;27 3E 11 22
	rorw	external	;27 3Es00r00

	rti			;27 77
	rts			;27 F7

	sba			;37 0A

	sbca	,x		;42 00
	sbca	,y		;52 00
	sbca	,z		;62 00
	sbca	,x8		;42 00
	sbca	,y8		;52 00
	sbca	,z8		;62 00
	sbca	,x16		;17 42 00 00
	sbca	,y16		;17 52 00 00
	sbca	,z16		;17 62 00 00
	sbca	offset8,x8	;42u00
	sbca	offset8,y8	;52u00
	sbca	offset8,z8	;62u00
	sbca	ind8,x8		;42 12
	sbca	ind8,y8		;52 12
	sbca	ind8,z8		;62 12
	sbca	ind8,x		;42 12
	sbca	ind8,y		;52 12
	sbca	ind8,z		;62 12
	sbca	#imm8		;72 01
	sbca	#num8		;72r00
	sbca	offset16,x16	;17 42s00r00
	sbca	offset16,y16	;17 52s00r00
	sbca	offset16,z16	;17 62s00r00
	sbca	offset16,x	;17 42s00r00
	sbca	offset16,y	;17 52s00r00
	sbca	offset16,z	;17 62s00r00
	sbca	ind16,x16	;17 42 34 56
	sbca	ind16,y16	;17 52 34 56
	sbca	ind16,z16	;17 62 34 56
	sbca	ind16,x		;17 42 34 56
	sbca	ind16,y		;17 52 34 56
	sbca	ind16,z		;17 62 34 56
	sbca	address		;17 72 11 22
	sbca	external	;17 72s00r00
	sbca	e,x		;27 42
	sbca	e,y		;27 52
	sbca	e,z		;27 62

	sbcb	,x		;C2 00
	sbcb	,y		;D2 00
	sbcb	,z		;E2 00
	sbcb	,x8		;C2 00
	sbcb	,y8		;D2 00
	sbcb	,z8		;E2 00
	sbcb	,x16		;17 C2 00 00
	sbcb	,y16		;17 D2 00 00
	sbcb	,z16		;17 E2 00 00
	sbcb	offset8,x8	;C2u00
	sbcb	offset8,y8	;D2u00
	sbcb	offset8,z8	;E2u00
	sbcb	ind8,x8		;C2 12
	sbcb	ind8,y8		;D2 12
	sbcb	ind8,z8		;E2 12
	sbcb	ind8,x		;C2 12
	sbcb	ind8,y		;D2 12
	sbcb	ind8,z		;E2 12
	sbcb	#imm8		;F2 01
	sbcb	#num8		;F2r00
	sbcb	offset16,x16	;17 C2s00r00
	sbcb	offset16,y16	;17 D2s00r00
	sbcb	offset16,z16	;17 E2s00r00
	sbcb	offset16,x	;17 C2s00r00
	sbcb	offset16,y	;17 D2s00r00
	sbcb	offset16,z	;17 E2s00r00
	sbcb	ind16,x16	;17 C2 34 56
	sbcb	ind16,y16	;17 D2 34 56
	sbcb	ind16,z16	;17 E2 34 56
	sbcb	ind16,x		;17 C2 34 56
	sbcb	ind16,y		;17 D2 34 56
	sbcb	ind16,z		;17 E2 34 56
	sbcb	address		;17 F2 11 22
	sbcb	external	;17 F2s00r00
	sbcb	e,x		;27 C2
	sbcb	e,y		;27 D2
	sbcb	e,z		;27 E2

	sbcd	,x		;82 00
	sbcd	,y		;92 00
	sbcd	,z		;A2 00
	sbcd	,x8		;82 00
	sbcd	,y8		;92 00
	sbcd	,z8		;A2 00
	sbcd	,x16		;37 C2 00 00
	sbcd	,y16		;37 D2 00 00
	sbcd	,z16		;37 E2 00 00
	sbcd	offset8,x8	;82u00
	sbcd	offset8,y8	;92u00
	sbcd	offset8,z8	;A2u00
	sbcd	ind8,x8		;82 12
	sbcd	ind8,y8		;92 12
	sbcd	ind8,z8		;A2 12
	sbcd	ind8,x		;82 12
	sbcd	ind8,y		;92 12
	sbcd	ind8,z		;A2 12
	sbcd	#imm16		;37 B2 23 45
	sbcd	#num16		;37 B2s00r00
	sbcd	offset16,x16	;37 C2s00r00
	sbcd	offset16,y16	;37 D2s00r00
	sbcd	offset16,z16	;37 E2s00r00
	sbcd	offset16,x	;37 C2s00r00
	sbcd	offset16,y	;37 D2s00r00
	sbcd	offset16,z	;37 E2s00r00
	sbcd	ind16,x16	;37 C2 34 56
	sbcd	ind16,y16	;37 D2 34 56
	sbcd	ind16,z16	;37 E2 34 56
	sbcd	ind16,x		;37 C2 34 56
	sbcd	ind16,y		;37 D2 34 56
	sbcd	ind16,z		;37 E2 34 56
	sbcd	address		;37 F2 11 22
	sbcd	external	;37 F2s00r00
	sbcd	e,x		;27 82
	sbcd	e,y		;27 92
	sbcd	e,z		;27 A2

	sbce	#imm16		;37 32 23 45
	sbce	#num16		;37 32s00r00
	sbce	,x		;37 42 00 00
	sbce	,y		;37 52 00 00
	sbce	,z		;37 62 00 00
	sbce	,x16		;37 42 00 00
	sbce	,y16		;37 52 00 00
	sbce	,z16		;37 62 00 00
	sbce	offset16,x16	;37 42s00r00
	sbce	offset16,y16	;37 52s00r00
	sbce	offset16,z16	;37 62s00r00
	sbce	offset16,x	;37 42s00r00
	sbce	offset16,y	;37 52s00r00
	sbce	offset16,z	;37 62s00r00
	sbce	ind16,x16	;37 42 34 56
	sbce	ind16,y16	;37 52 34 56
	sbce	ind16,z16	;37 62 34 56
	sbce	ind16,x		;37 42 34 56
	sbce	ind16,y		;37 52 34 56
	sbce	ind16,z		;37 62 34 56
	sbce	address		;37 72 11 22
	sbce	external	;37 72s00r00

	sde			;27 79

	staa	,x		;4A 00
	staa	,y		;5A 00
	staa	,z		;6A 00
	staa	,x8		;4A 00
	staa	,y8		;5A 00
	staa	,z8		;6A 00
	staa	,x16		;17 4A 00 00
	staa	,y16		;17 5A 00 00
	staa	,z16		;17 6A 00 00
	staa	offset8,x8	;4Au00
	staa	offset8,y8	;5Au00
	staa	offset8,z8	;6Au00
	staa	ind8,x8		;4A 12
	staa	ind8,y8		;5A 12
	staa	ind8,z8		;6A 12
	staa	ind8,x		;4A 12
	staa	ind8,y		;5A 12
	staa	ind8,z		;6A 12
	staa	offset16,x16	;17 4As00r00
	staa	offset16,y16	;17 5As00r00
	staa	offset16,z16	;17 6As00r00
	staa	offset16,x	;17 4As00r00
	staa	offset16,y	;17 5As00r00
	staa	offset16,z	;17 6As00r00
	staa	ind16,x16	;17 4A 34 56
	staa	ind16,y16	;17 5A 34 56
	staa	ind16,z16	;17 6A 34 56
	staa	ind16,x		;17 4A 34 56
	staa	ind16,y		;17 5A 34 56
	staa	ind16,z		;17 6A 34 56
	staa	address		;17 7A 11 22
	staa	external	;17 7As00r00
	staa	e,x		;27 4A
	staa	e,y		;27 5A
	staa	e,z		;27 6A

	stab	,x		;CA 00
	stab	,y		;DA 00
	stab	,z		;EA 00
	stab	,x8		;CA 00
	stab	,y8		;DA 00
	stab	,z8		;EA 00
	stab	,x16		;17 CA 00 00
	stab	,y16		;17 DA 00 00
	stab	,z16		;17 EA 00 00
	stab	offset8,x8	;CAu00
	stab	offset8,y8	;DAu00
	stab	offset8,z8	;EAu00
	stab	ind8,x8		;CA 12
	stab	ind8,y8		;DA 12
	stab	ind8,z8		;EA 12
	stab	ind8,x		;CA 12
	stab	ind8,y		;DA 12
	stab	ind8,z		;EA 12
	stab	offset16,x16	;17 CAs00r00
	stab	offset16,y16	;17 DAs00r00
	stab	offset16,z16	;17 EAs00r00
	stab	offset16,x	;17 CAs00r00
	stab	offset16,y	;17 DAs00r00
	stab	offset16,z	;17 EAs00r00
	stab	ind16,x16	;17 CA 34 56
	stab	ind16,y16	;17 DA 34 56
	stab	ind16,z16	;17 EA 34 56
	stab	ind16,x		;17 CA 34 56
	stab	ind16,y		;17 DA 34 56
	stab	ind16,z		;17 EA 34 56
	stab	address		;17 FA 11 22
	stab	external	;17 FAs00r00
	stab	e,x		;27 CA
	stab	e,y		;27 DA
	stab	e,z		;27 EA

	std	,x		;8A 00
	std	,y		;9A 00
	std	,z		;AA 00
	std	,x8		;8A 00
	std	,y8		;9A 00
	std	,z8		;AA 00
	std	,x16		;37 CA 00 00
	std	,y16		;37 DA 00 00
	std	,z16		;37 EA 00 00
	std	offset8,x8	;8Au00
	std	offset8,y8	;9Au00
	std	offset8,z8	;AAu00
	std	ind8,x8		;8A 12
	std	ind8,y8		;9A 12
	std	ind8,z8		;AA 12
	std	ind8,x		;8A 12
	std	ind8,y		;9A 12
	std	ind8,z		;AA 12
	std	offset16,x16	;37 CAs00r00
	std	offset16,y16	;37 DAs00r00
	std	offset16,z16	;37 EAs00r00
	std	offset16,x	;37 CAs00r00
	std	offset16,y	;37 DAs00r00
	std	offset16,z	;37 EAs00r00
	std	ind16,x16	;37 CA 34 56
	std	ind16,y16	;37 DA 34 56
	std	ind16,z16	;37 EA 34 56
	std	ind16,x		;37 CA 34 56
	std	ind16,y		;37 DA 34 56
	std	ind16,z		;37 EA 34 56
	std	address		;37 FA 11 22
	std	external	;37 FAs00r00
	std	e,x		;27 8A
	std	e,y		;27 9A
	std	e,z		;27 AA

	ste	,x		;37 4A 00 00
	ste	,y		;37 5A 00 00
	ste	,z		;37 6A 00 00
	ste	,x16		;37 4A 00 00
	ste	,y16		;37 5A 00 00
	ste	,z16		;37 6A 00 00
	ste	offset16,x16	;37 4As00r00
	ste	offset16,y16	;37 5As00r00
	ste	offset16,z16	;37 6As00r00
	ste	offset16,x	;37 4As00r00
	ste	offset16,y	;37 5As00r00
	ste	offset16,z	;37 6As00r00
	ste	ind16,x16	;37 4A 34 56
	ste	ind16,y16	;37 5A 34 56
	ste	ind16,z16	;37 6A 34 56
	ste	ind16,x		;37 4A 34 56
	ste	ind16,y		;37 5A 34 56
	ste	ind16,z		;37 6A 34 56
	ste	address		;37 7A 11 22
	ste	external	;37 7As00r00

	sted			;27 73

	sts	,x		;8F 00
	sts	,y		;9F 00
	sts	,z		;AF 00
	sts	,x8		;8F 00
	sts	,y8		;9F 00
	sts	,z8		;AF 00
	sts	,x16		;17 8F 00 00
	sts	,y16		;17 9F 00 00
	sts	,z16		;17 AF 00 00
	sts	offset8,x8	;8Fu00
	sts	offset8,y8	;9Fu00
	sts	offset8,z8	;AFu00
	sts	ind8,x8		;8F 12
	sts	ind8,y8		;9F 12
	sts	ind8,z8		;AF 12
	sts	ind8,x		;8F 12
	sts	ind8,y		;9F 12
	sts	ind8,z		;AF 12
	sts	offset16,x16	;17 8Fs00r00
	sts	offset16,y16	;17 9Fs00r00
	sts	offset16,z16	;17 AFs00r00
	sts	offset16,x	;17 8Fs00r00
	sts	offset16,y	;17 9Fs00r00
	sts	offset16,z	;17 AFs00r00
	sts	ind16,x16	;17 8F 34 56
	sts	ind16,y16	;17 9F 34 56
	sts	ind16,z16	;17 AF 34 56
	sts	ind16,x		;17 8F 34 56
	sts	ind16,y		;17 9F 34 56
	sts	ind16,z		;17 AF 34 56
	sts	address		;17 BF 11 22
	sts	external	;17 BFs00r00

	stx	,x		;8C 00
	stx	,y		;9C 00
	stx	,z		;AC 00
	stx	,x8		;8C 00
	stx	,y8		;9C 00
	stx	,z8		;AC 00
	stx	,x16		;17 8C 00 00
	stx	,y16		;17 9C 00 00
	stx	,z16		;17 AC 00 00
	stx	offset8,x8	;8Cu00
	stx	offset8,y8	;9Cu00
	stx	offset8,z8	;ACu00
	stx	ind8,x8		;8C 12
	stx	ind8,y8		;9C 12
	stx	ind8,z8		;AC 12
	stx	ind8,x		;8C 12
	stx	ind8,y		;9C 12
	stx	ind8,z		;AC 12
	stx	offset16,x16	;17 8Cs00r00
	stx	offset16,y16	;17 9Cs00r00
	stx	offset16,z16	;17 ACs00r00
	stx	offset16,x	;17 8Cs00r00
	stx	offset16,y	;17 9Cs00r00
	stx	offset16,z	;17 ACs00r00
	stx	ind16,x16	;17 8C 34 56
	stx	ind16,y16	;17 9C 34 56
	stx	ind16,z16	;17 AC 34 56
	stx	ind16,x		;17 8C 34 56
	stx	ind16,y		;17 9C 34 56
	stx	ind16,z		;17 AC 34 56
	stx	address		;17 BC 11 22
	stx	external	;17 BCs00r00

	sty	,x		;8D 00
	sty	,y		;9D 00
	sty	,z		;AD 00
	sty	,x8		;8D 00
	sty	,y8		;9D 00
	sty	,z8		;AD 00
	sty	,x16		;17 8D 00 00
	sty	,y16		;17 9D 00 00
	sty	,z16		;17 AD 00 00
	sty	offset8,x8	;8Du00
	sty	offset8,y8	;9Du00
	sty	offset8,z8	;ADu00
	sty	ind8,x8		;8D 12
	sty	ind8,y8		;9D 12
	sty	ind8,z8		;AD 12
	sty	ind8,x		;8D 12
	sty	ind8,y		;9D 12
	sty	ind8,z		;AD 12
	sty	offset16,x16	;17 8Ds00r00
	sty	offset16,y16	;17 9Ds00r00
	sty	offset16,z16	;17 ADs00r00
	sty	offset16,x	;17 8Ds00r00
	sty	offset16,y	;17 9Ds00r00
	sty	offset16,z	;17 ADs00r00
	sty	ind16,x16	;17 8D 34 56
	sty	ind16,y16	;17 9D 34 56
	sty	ind16,z16	;17 AD 34 56
	sty	ind16,x		;17 8D 34 56
	sty	ind16,y		;17 9D 34 56
	sty	ind16,z		;17 AD 34 56
	sty	address		;17 BD 11 22
	sty	external	;17 BDs00r00

	stz	,x		;8E 00
	stz	,y		;9E 00
	stz	,z		;AE 00
	stz	,x8		;8E 00
	stz	,y8		;9E 00
	stz	,z8		;AE 00
	stz	,x16		;17 8E 00 00
	stz	,y16		;17 9E 00 00
	stz	,z16		;17 AE 00 00
	stz	offset8,x8	;8Eu00
	stz	offset8,y8	;9Eu00
	stz	offset8,z8	;AEu00
	stz	ind8,x8		;8E 12
	stz	ind8,y8		;9E 12
	stz	ind8,z8		;AE 12
	stz	ind8,x		;8E 12
	stz	ind8,y		;9E 12
	stz	ind8,z		;AE 12
	stz	offset16,x16	;17 8Es00r00
	stz	offset16,y16	;17 9Es00r00
	stz	offset16,z16	;17 AEs00r00
	stz	offset16,x	;17 8Es00r00
	stz	offset16,y	;17 9Es00r00
	stz	offset16,z	;17 AEs00r00
	stz	ind16,x16	;17 8E 34 56
	stz	ind16,y16	;17 9E 34 56
	stz	ind16,z16	;17 AE 34 56
	stz	ind16,x		;17 8E 34 56
	stz	ind16,y		;17 9E 34 56
	stz	ind16,z		;17 AE 34 56
	stz	address		;17 BE 11 22
	stz	external	;17 BEs00r00

	suba	,x		;40 00
	suba	,y		;50 00
	suba	,z		;60 00
	suba	,x8		;40 00
	suba	,y8		;50 00
	suba	,z8		;60 00
	suba	,x16		;17 40 00 00
	suba	,y16		;17 50 00 00
	suba	,z16		;17 60 00 00
	suba	offset8,x8	;40u00
	suba	offset8,y8	;50u00
	suba	offset8,z8	;60u00
	suba	ind8,x8		;40 12
	suba	ind8,y8		;50 12
	suba	ind8,z8		;60 12
	suba	ind8,x		;40 12
	suba	ind8,y		;50 12
	suba	ind8,z		;60 12
	suba	#imm8		;70 01
	suba	#num8		;70r00
	suba	offset16,x16	;17 40s00r00
	suba	offset16,y16	;17 50s00r00
	suba	offset16,z16	;17 60s00r00
	suba	offset16,x	;17 40s00r00
	suba	offset16,y	;17 50s00r00
	suba	offset16,z	;17 60s00r00
	suba	ind16,x16	;17 40 34 56
	suba	ind16,y16	;17 50 34 56
	suba	ind16,z16	;17 60 34 56
	suba	ind16,x		;17 40 34 56
	suba	ind16,y		;17 50 34 56
	suba	ind16,z		;17 60 34 56
	suba	address		;17 70 11 22
	suba	external	;17 70s00r00
	suba	e,x		;27 40
	suba	e,y		;27 50
	suba	e,z		;27 60

	subb	,x		;C0 00
	subb	,y		;D0 00
	subb	,z		;E0 00
	subb	,x8		;C0 00
	subb	,y8		;D0 00
	subb	,z8		;E0 00
	subb	,x16		;17 C0 00 00
	subb	,y16		;17 D0 00 00
	subb	,z16		;17 E0 00 00
	subb	offset8,x8	;C0u00
	subb	offset8,y8	;D0u00
	subb	offset8,z8	;E0u00
	subb	ind8,x8		;C0 12
	subb	ind8,y8		;D0 12
	subb	ind8,z8		;E0 12
	subb	ind8,x		;C0 12
	subb	ind8,y		;D0 12
	subb	ind8,z		;E0 12
	subb	#imm8		;F0 01
	subb	#num8		;F0r00
	subb	offset16,x16	;17 C0s00r00
	subb	offset16,y16	;17 D0s00r00
	subb	offset16,z16	;17 E0s00r00
	subb	offset16,x	;17 C0s00r00
	subb	offset16,y	;17 D0s00r00
	subb	offset16,z	;17 E0s00r00
	subb	ind16,x16	;17 C0 34 56
	subb	ind16,y16	;17 D0 34 56
	subb	ind16,z16	;17 E0 34 56
	subb	ind16,x		;17 C0 34 56
	subb	ind16,y		;17 D0 34 56
	subb	ind16,z		;17 E0 34 56
	subb	address		;17 F0 11 22
	subb	external	;17 F0s00r00
	subb	e,x		;27 C0
	subb	e,y		;27 D0
	subb	e,z		;27 E0

	subd	,x		;80 00
	subd	,y		;90 00
	subd	,z		;A0 00
	subd	,x8		;80 00
	subd	,y8		;90 00
	subd	,z8		;A0 00
	subd	,x16		;37 C0 00 00
	subd	,y16		;37 D0 00 00
	subd	,z16		;37 E0 00 00
	subd	offset8,x8	;80u00
	subd	offset8,y8	;90u00
	subd	offset8,z8	;A0u00
	subd	ind8,x8		;80 12
	subd	ind8,y8		;90 12
	subd	ind8,z8		;A0 12
	subd	ind8,x		;80 12
	subd	ind8,y		;90 12
	subd	ind8,z		;A0 12
	subd	#imm16		;37 B0 23 45
	subd	#num16		;37 B0s00r00
	subd	offset16,x16	;37 C0s00r00
	subd	offset16,y16	;37 D0s00r00
	subd	offset16,z16	;37 E0s00r00
	subd	offset16,x	;37 C0s00r00
	subd	offset16,y	;37 D0s00r00
	subd	offset16,z	;37 E0s00r00
	subd	ind16,x16	;37 C0 34 56
	subd	ind16,y16	;37 D0 34 56
	subd	ind16,z16	;37 E0 34 56
	subd	ind16,x		;37 C0 34 56
	subd	ind16,y		;37 D0 34 56
	subd	ind16,z		;37 E0 34 56
	subd	address		;37 F0 11 22
	subd	external	;37 F0s00r00
	subd	e,x		;27 80
	subd	e,y		;27 90
	subd	e,z		;27 A0

	sube	#imm16		;37 30 23 45
	sube	#num16		;37 30s00r00
	sube	,x		;37 40 00 00
	sube	,y		;37 50 00 00
	sube	,z		;37 60 00 00
	sube	,x16		;37 40 00 00
	sube	,y16		;37 50 00 00
	sube	,z16		;37 60 00 00
	sube	offset16,x16	;37 40s00r00
	sube	offset16,y16	;37 50s00r00
	sube	offset16,z16	;37 60s00r00
	sube	offset16,x	;37 40s00r00
	sube	offset16,y	;37 50s00r00
	sube	offset16,z	;37 60s00r00
	sube	ind16,x16	;37 40 34 56
	sube	ind16,y16	;37 50 34 56
	sube	ind16,z16	;37 60 34 56
	sube	ind16,x		;37 40 34 56
	sube	ind16,y		;37 50 34 56
	sube	ind16,z		;37 60 34 56
	sube	address		;37 70 11 22
	sube	external	;37 70s00r00

	swi			;37 20
	sxt			;27 F8

	tab			;37 17
	tap			;37 FD
	tba			;37 07
	tbek			;27 FA
	tbsk			;37 9F
	tbxk			;37 9C
	tbyk			;37 9D
	tbzk			;37 9E
	tde			;27 7B
	tdmsk			;37 2F
	tdp			;37 2D
	ted			;27 FB
	tedm			;27 B1
	tekb			;27 BB
	tem			;27 B2
	tmer			;27 B4
	tmet			;27 B5
	tmxed			;27 B3
	tpa			;37 FC
	tpd			;37 2C
	tskb			;37 AF

	tst	,x		;06 00
	tst	,y		;16 00
	tst	,z		;26 00
	tst	,x8		;06 00
	tst	,y8		;16 00
	tst	,z8		;26 00
	tst	,x16		;17 06 00 00
	tst	,y16		;17 16 00 00
	tst	,z16		;17 26 00 00
	tst	offset8,x8	;06u00
	tst	offset8,y8	;16u00
	tst	offset8,z8	;26u00
	tst	ind8,x8		;06 12
	tst	ind8,y8		;16 12
	tst	ind8,z8		;26 12
	tst	ind8,x		;06 12
	tst	ind8,y		;16 12
	tst	ind8,z		;26 12
	tst	offset16,x16	;17 06s00r00
	tst	offset16,y16	;17 16s00r00
	tst	offset16,z16	;17 26s00r00
	tst	offset16,x	;17 06s00r00
	tst	offset16,y	;17 16s00r00
	tst	offset16,z	;17 26s00r00
	tst	ind16,x16	;17 06 34 56
	tst	ind16,y16	;17 16 34 56
	tst	ind16,z16	;17 26 34 56
	tst	ind16,x		;17 06 34 56
	tst	ind16,y		;17 16 34 56
	tst	ind16,z		;17 26 34 56
	tst	address		;17 36 11 22
	tst	external	;17 36s00r00

	tsta			;37 06
	tstb			;37 16
	tstd			;27 F6
	tste			;27 76

	tstw	,x		;27 06 00 00
	tstw	,y		;27 16 00 00
	tstw	,z		;27 26 00 00
	tstw	,x16		;27 06 00 00
	tstw	,y16		;27 16 00 00
	tstw	,z16		;27 26 00 00
	tstw	offset16,x16	;27 06s00r00
	tstw	offset16,y16	;27 16s00r00
	tstw	offset16,z16	;27 26s00r00
	tstw	offset16,x	;27 06s00r00
	tstw	offset16,y	;27 16s00r00
	tstw	offset16,z	;27 26s00r00
	tstw	ind16,x16	;27 06 34 56
	tstw	ind16,y16	;27 16 34 56
	tstw	ind16,z16	;27 26 34 56
	tstw	ind16,x		;27 06 34 56
	tstw	ind16,y		;27 16 34 56
	tstw	ind16,z		;27 26 34 56
	tstw	address		;27 36 11 22
	tstw	external	;27 36s00r00

	tsx			;27 4F
	tsy			;27 5F
	tsz			;27 6F
	txkb			;37 AC
	txs			;37 4E
	txy			;27 5C
	txz			;27 6C
	tykb			;37 AD
	tys			;37 5E
	tyx			;27 4D
	tyz			;27 6D
	tzkb			;37 AE
	tzs			;37 6E
	tzx			;27 4E
	tzy			;27 5E
	wai			;27 F3
	xgab			;37 1A
	xgde			;27 7A
	xgdx			;37 CC
	xgdy			;37 DC
	xgdz			;37 EC
	xgex			;37 4C
	xgey			;37 5C
	xgez			;37 6C

