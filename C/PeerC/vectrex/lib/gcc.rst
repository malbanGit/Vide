                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	gcc.c
                              6 ;----- asm -----
                              7 	.globl		_abort				
                     F000     8 	_abort		.equ 	0xf000		
                              9 	
                             10 	.globl		_free				
                     F000    11 	_free		.equ 	0xf000		
                             12 	
                             13 	.globl		_malloc				
                     F000    14 	_malloc	.equ 	0xf000		
                             15 	
                             16 ;--- end asm ---
                             17 	.area	.text
                             18 	.globl	_memcmp
   0054                      19 _memcmp:
   0054 34 60         [ 7]   20 	pshs	y,u
   0056 32 7A         [ 5]   21 	leas	-6,s
   0058 AF E4         [ 5]   22 	stx	,s
   005A EE 6E         [ 6]   23 	ldu	14,s
   005C 8E 00 00      [ 3]   24 	ldx	#0
   005F AF 62         [ 6]   25 	stx	2,s
   0061                      26 L2:
   0061 11 83 00 00   [ 5]   27 	cmpu	#0
   0065 27 36         [ 3]   28 	beq	L9
   0067 EC E4         [ 5]   29 	ldd	,s
   0069 10 AE 62      [ 7]   30 	ldy	2,s
   006C 30 AB         [ 8]   31 	leax	d,y
   006E E6 84         [ 4]   32 	ldb	,x
   0070 E7 64         [ 5]   33 	stb	4,s
   0072 EC 6C         [ 6]   34 	ldd	12,s
   0074 30 AB         [ 8]   35 	leax	d,y
   0076 E6 84         [ 4]   36 	ldb	,x
   0078 E7 65         [ 5]   37 	stb	5,s
   007A 1F 20         [ 6]   38 	tfr	y,d
   007C C3 00 01      [ 4]   39 	addd	#1
   007F ED 62         [ 6]   40 	std	2,s
   0081 33 5F         [ 5]   41 	leau	-1,u
   0083 E6 64         [ 5]   42 	ldb	4,s
   0085 E1 65         [ 5]   43 	cmpb	5,s	;cmpqi:
   0087 27 D8         [ 3]   44 	beq	L2
   0089 C6 FF         [ 2]   45 	ldb	#-1
   008B E7 62         [ 5]   46 	stb	2,s
   008D E6 64         [ 5]   47 	ldb	4,s
   008F E1 65         [ 5]   48 	cmpb	5,s	;cmpqi:
   0091 25 04         [ 3]   49 	blo	L4
   0093 C6 01         [ 2]   50 	ldb	#1
   0095 E7 62         [ 5]   51 	stb	2,s
   0097                      52 L4:
   0097 E6 62         [ 5]   53 	ldb	2,s
   0099 32 66         [ 5]   54 	leas	6,s
   009B 35 E0         [ 8]   55 	puls	y,u,pc
   009D                      56 L9:
   009D 6F 62         [ 7]   57 	clr	2,s
   009F E6 62         [ 5]   58 	ldb	2,s
   00A1 32 66         [ 5]   59 	leas	6,s
   00A3 35 E0         [ 8]   60 	puls	y,u,pc
                             61 	.globl	_memcpy
   00A5                      62 _memcpy:
   00A5 34 60         [ 7]   63 	pshs	y,u
   00A7 32 7C         [ 5]   64 	leas	-4,s
   00A9 AF E4         [ 5]   65 	stx	,s
   00AB AE 6C         [ 6]   66 	ldx	12,s
   00AD 27 1F         [ 3]   67 	beq	L11
   00AF CE 00 00      [ 3]   68 	ldu	#0
   00B2 EF 62         [ 6]   69 	stu	2,s
   00B4                      70 L12:
   00B4 EC E4         [ 5]   71 	ldd	,s
   00B6 AE 62         [ 6]   72 	ldx	2,s
   00B8 31 8B         [ 8]   73 	leay	d,x
   00BA EC 6A         [ 6]   74 	ldd	10,s
   00BC 30 8B         [ 8]   75 	leax	d,x
   00BE E6 84         [ 4]   76 	ldb	,x
   00C0 E7 A4         [ 4]   77 	stb	,y
   00C2 EC 62         [ 6]   78 	ldd	2,s
   00C4 C3 00 01      [ 4]   79 	addd	#1
   00C7 ED 62         [ 6]   80 	std	2,s
   00C9 10 A3 6C      [ 8]   81 	cmpd	12,s	;cmphi:
   00CC 26 E6         [ 3]   82 	bne	L12
   00CE                      83 L11:
   00CE AE E4         [ 5]   84 	ldx	,s
   00D0 32 64         [ 5]   85 	leas	4,s
   00D2 35 E0         [ 8]   86 	puls	y,u,pc
                             87 	.globl	_memmove
   00D4                      88 _memmove:
   00D4 34 60         [ 7]   89 	pshs	y,u
   00D6 32 7C         [ 5]   90 	leas	-4,s
   00D8 AF E4         [ 5]   91 	stx	,s
   00DA AC 6A         [ 7]   92 	cmpx	10,s	;cmphi:
   00DC 24 2C         [ 3]   93 	bhs	L16
   00DE AE 6C         [ 6]   94 	ldx	12,s
   00E0 27 22         [ 3]   95 	beq	L17
   00E2 CE 00 00      [ 3]   96 	ldu	#0
   00E5 EF 62         [ 6]   97 	stu	2,s
   00E7                      98 L18:
   00E7 EC E4         [ 5]   99 	ldd	,s
   00E9 AE 62         [ 6]  100 	ldx	2,s
   00EB 31 8B         [ 8]  101 	leay	d,x
   00ED EC 6A         [ 6]  102 	ldd	10,s
   00EF 30 8B         [ 8]  103 	leax	d,x
   00F1 E6 84         [ 4]  104 	ldb	,x
   00F3 E7 A4         [ 4]  105 	stb	,y
   00F5 EC 62         [ 6]  106 	ldd	2,s
   00F7 C3 00 01      [ 4]  107 	addd	#1
   00FA ED 62         [ 6]  108 	std	2,s
   00FC AE 6C         [ 6]  109 	ldx	12,s
   00FE 34 06         [ 7]  110 	pshs	d	;cmphi: R:d with R:x
   0100 AC E1         [ 9]  111 	cmpx	,s++	;cmphi:
   0102 26 E3         [ 3]  112 	bne	L18
   0104                     113 L17:
   0104 AE E4         [ 5]  114 	ldx	,s
   0106 32 64         [ 5]  115 	leas	4,s
   0108 35 E0         [ 8]  116 	puls	y,u,pc
   010A                     117 L16:
   010A EE 6C         [ 6]  118 	ldu	12,s
   010C 27 F6         [ 3]  119 	beq	L17
   010E 1F 30         [ 6]  120 	tfr	u,d
   0110 C3 FF FF      [ 4]  121 	addd	#-1
   0113 ED 62         [ 6]  122 	std	2,s
   0115 EC 6A         [ 6]  123 	ldd	10,s
   0117 EE 62         [ 6]  124 	ldu	2,s
   0119 30 CB         [ 8]  125 	leax	d,u
   011B EC E4         [ 5]  126 	ldd	,s
   011D 31 CB         [ 8]  127 	leay	d,u
   011F 20 07         [ 3]  128 	bra	L19
   0121                     129 L24:
   0121 EC 62         [ 6]  130 	ldd	2,s
   0123 C3 FF FF      [ 4]  131 	addd	#-1
   0126 ED 62         [ 6]  132 	std	2,s
   0128                     133 L19:
   0128 E6 84         [ 4]  134 	ldb	,x
   012A E7 A4         [ 4]  135 	stb	,y
   012C 31 3F         [ 5]  136 	leay	-1,y
   012E 30 1F         [ 5]  137 	leax	-1,x
   0130 EE 62         [ 6]  138 	ldu	2,s
   0132 26 ED         [ 3]  139 	bne	L24
   0134 AE E4         [ 5]  140 	ldx	,s
   0136 32 64         [ 5]  141 	leas	4,s
   0138 35 E0         [ 8]  142 	puls	y,u,pc
                            143 	.globl	_memset
   013A                     144 _memset:
   013A 34 60         [ 7]  145 	pshs	y,u
   013C 31 84         [ 4]  146 	leay	,x
   013E EE 66         [ 6]  147 	ldu	6,s
   0140 27 0E         [ 3]  148 	beq	L26
   0142 1E 02         [ 8]  149 	exg	d,y
   0144 33 CB         [ 8]  150 	leau	d,u
   0146 1E 02         [ 8]  151 	exg	d,y
   0148                     152 L27:
   0148 E7 80         [ 6]  153 	stb	,x+
   014A 34 40         [ 6]  154 	pshs	u	;cmphi: R:u with R:x
   014C AC E1         [ 9]  155 	cmpx	,s++	;cmphi:
   014E 26 F8         [ 3]  156 	bne	L27
   0150                     157 L26:
   0150 30 A4         [ 4]  158 	leax	,y
   0152 35 E0         [ 8]  159 	puls	y,u,pc
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 L11                007A R   |   2 L12                0060 R
  2 L16                00B6 R   |   2 L17                00B0 R
  2 L18                0093 R   |   2 L19                00D4 R
  2 L2                 000D R   |   2 L24                00CD R
  2 L26                00FC R   |   2 L27                00F4 R
  2 L4                 0043 R   |   2 L9                 0049 R
    _abort         =   F000 G   |     _free          =   F000 G
    _malloc        =   F000 G   |   2 _memcmp            0000 GR
  2 _memcpy            0051 GR  |   2 _memmove           0080 GR
  2 _memset            00E6 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
   2 .text            size  100   flags  100
[_DSEG]
   1 _DATA            size    0   flags C0C0

