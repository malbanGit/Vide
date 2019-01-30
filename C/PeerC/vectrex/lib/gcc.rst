                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	gcc.c
                              7 ;----- asm -----
                              8 	.globl		_abort				
                     F000     9 	_abort		.equ 	0xf000		
                             10 	
                             11 	.globl		_free				
                     F000    12 	_free		.equ 	0xf000		
                             13 	
                             14 	.globl		_malloc				
                     F000    15 	_malloc	.equ 	0xf000		
                             16 	
                             17 ;--- end asm ---
                             18 	.area .text
                             19 	.globl _memcmp
   0054                      20 _memcmp:
   0054 34 60         [ 7]   21 	pshs	y,u
   0056 32 7A         [ 5]   22 	leas	-6,s
   0058 AF E4         [ 5]   23 	stx	,s
   005A EE 6E         [ 6]   24 	ldu	14,s
   005C 8E 00 00      [ 3]   25 	ldx	#0
   005F AF 62         [ 6]   26 	stx	2,s
   0061                      27 L2:
   0061 11 83 00 00   [ 5]   28 	cmpu	#0
   0065 27 36         [ 3]   29 	beq	L9
   0067 EC E4         [ 5]   30 	ldd	,s
   0069 10 AE 62      [ 7]   31 	ldy	2,s
   006C 30 AB         [ 8]   32 	leax	d,y
   006E E6 84         [ 4]   33 	ldb	,x
   0070 E7 64         [ 5]   34 	stb	4,s
   0072 EC 6C         [ 6]   35 	ldd	12,s
   0074 30 AB         [ 8]   36 	leax	d,y
   0076 E6 84         [ 4]   37 	ldb	,x
   0078 E7 65         [ 5]   38 	stb	5,s
   007A 1F 20         [ 6]   39 	tfr	y,d
   007C C3 00 01      [ 4]   40 	addd	#1
   007F ED 62         [ 6]   41 	std	2,s
   0081 33 5F         [ 5]   42 	leau	-1,u
   0083 E6 64         [ 5]   43 	ldb	4,s
   0085 E1 65         [ 5]   44 	cmpb	5,s	;cmpqi:
   0087 27 D8         [ 3]   45 	beq	L2
   0089 C6 FF         [ 2]   46 	ldb	#-1
   008B E7 62         [ 5]   47 	stb	2,s
   008D E6 64         [ 5]   48 	ldb	4,s
   008F E1 65         [ 5]   49 	cmpb	5,s	;cmpqi:
   0091 25 04         [ 3]   50 	blo	L4
   0093 C6 01         [ 2]   51 	ldb	#1
   0095 E7 62         [ 5]   52 	stb	2,s
   0097                      53 L4:
   0097 E6 62         [ 5]   54 	ldb	2,s
   0099 32 66         [ 5]   55 	leas	6,s
   009B 35 E0         [ 8]   56 	puls	y,u,pc
   009D                      57 L9:
   009D 6F 62         [ 7]   58 	clr	2,s
   009F E6 62         [ 5]   59 	ldb	2,s
   00A1 32 66         [ 5]   60 	leas	6,s
   00A3 35 E0         [ 8]   61 	puls	y,u,pc
                             62 	.globl _memcpy
   00A5                      63 _memcpy:
   00A5 34 60         [ 7]   64 	pshs	y,u
   00A7 32 7C         [ 5]   65 	leas	-4,s
   00A9 AF E4         [ 5]   66 	stx	,s
   00AB AE 6C         [ 6]   67 	ldx	12,s
   00AD 27 1F         [ 3]   68 	beq	L11
   00AF CE 00 00      [ 3]   69 	ldu	#0
   00B2 EF 62         [ 6]   70 	stu	2,s
   00B4                      71 L12:
   00B4 EC E4         [ 5]   72 	ldd	,s
   00B6 AE 62         [ 6]   73 	ldx	2,s
   00B8 31 8B         [ 8]   74 	leay	d,x
   00BA EC 6A         [ 6]   75 	ldd	10,s
   00BC 30 8B         [ 8]   76 	leax	d,x
   00BE E6 84         [ 4]   77 	ldb	,x
   00C0 E7 A4         [ 4]   78 	stb	,y
   00C2 EC 62         [ 6]   79 	ldd	2,s
   00C4 C3 00 01      [ 4]   80 	addd	#1
   00C7 ED 62         [ 6]   81 	std	2,s
   00C9 10 A3 6C      [ 8]   82 	cmpd	12,s	;cmphi:
   00CC 26 E6         [ 3]   83 	bne	L12
   00CE                      84 L11:
   00CE AE E4         [ 5]   85 	ldx	,s
   00D0 32 64         [ 5]   86 	leas	4,s
   00D2 35 E0         [ 8]   87 	puls	y,u,pc
                             88 	.globl _memmove
   00D4                      89 _memmove:
   00D4 34 60         [ 7]   90 	pshs	y,u
   00D6 32 7C         [ 5]   91 	leas	-4,s
   00D8 AF E4         [ 5]   92 	stx	,s
   00DA AC 6A         [ 7]   93 	cmpx	10,s	;cmphi:
   00DC 24 2C         [ 3]   94 	bhs	L16
   00DE AE 6C         [ 6]   95 	ldx	12,s
   00E0 27 22         [ 3]   96 	beq	L17
   00E2 CE 00 00      [ 3]   97 	ldu	#0
   00E5 EF 62         [ 6]   98 	stu	2,s
   00E7                      99 L18:
   00E7 EC E4         [ 5]  100 	ldd	,s
   00E9 AE 62         [ 6]  101 	ldx	2,s
   00EB 31 8B         [ 8]  102 	leay	d,x
   00ED EC 6A         [ 6]  103 	ldd	10,s
   00EF 30 8B         [ 8]  104 	leax	d,x
   00F1 E6 84         [ 4]  105 	ldb	,x
   00F3 E7 A4         [ 4]  106 	stb	,y
   00F5 EC 62         [ 6]  107 	ldd	2,s
   00F7 C3 00 01      [ 4]  108 	addd	#1
   00FA ED 62         [ 6]  109 	std	2,s
   00FC AE 6C         [ 6]  110 	ldx	12,s
   00FE 34 06         [ 7]  111 	pshs	d	;cmphi: R:d with R:x
   0100 AC E1         [ 9]  112 	cmpx	,s++	;cmphi:
   0102 26 E3         [ 3]  113 	bne	L18
   0104                     114 L17:
   0104 AE E4         [ 5]  115 	ldx	,s
   0106 32 64         [ 5]  116 	leas	4,s
   0108 35 E0         [ 8]  117 	puls	y,u,pc
   010A                     118 L16:
   010A EE 6C         [ 6]  119 	ldu	12,s
   010C 27 F6         [ 3]  120 	beq	L17
   010E 1F 30         [ 6]  121 	tfr	u,d
   0110 C3 FF FF      [ 4]  122 	addd	#-1
   0113 ED 62         [ 6]  123 	std	2,s
   0115 EC 6A         [ 6]  124 	ldd	10,s
   0117 EE 62         [ 6]  125 	ldu	2,s
   0119 30 CB         [ 8]  126 	leax	d,u
   011B EC E4         [ 5]  127 	ldd	,s
   011D 31 CB         [ 8]  128 	leay	d,u
   011F 20 07         [ 3]  129 	bra	L19
   0121                     130 L24:
   0121 EC 62         [ 6]  131 	ldd	2,s
   0123 C3 FF FF      [ 4]  132 	addd	#-1
   0126 ED 62         [ 6]  133 	std	2,s
   0128                     134 L19:
   0128 E6 84         [ 4]  135 	ldb	,x
   012A E7 A4         [ 4]  136 	stb	,y
   012C 31 3F         [ 5]  137 	leay	-1,y
   012E 30 1F         [ 5]  138 	leax	-1,x
   0130 EE 62         [ 6]  139 	ldu	2,s
   0132 26 ED         [ 3]  140 	bne	L24
   0134 AE E4         [ 5]  141 	ldx	,s
   0136 32 64         [ 5]  142 	leas	4,s
   0138 35 E0         [ 8]  143 	puls	y,u,pc
                            144 	.globl _memset
   013A                     145 _memset:
   013A 34 60         [ 7]  146 	pshs	y,u
   013C 31 84         [ 4]  147 	leay	,x
   013E EE 66         [ 6]  148 	ldu	6,s
   0140 27 0E         [ 3]  149 	beq	L26
   0142 1E 02         [ 8]  150 	exg	d,y
   0144 33 CB         [ 8]  151 	leau	d,u
   0146 1E 02         [ 8]  152 	exg	d,y
   0148                     153 L27:
   0148 E7 80         [ 6]  154 	stb	,x+
   014A 34 40         [ 6]  155 	pshs	u	;cmphi: R:u with R:x
   014C AC E1         [ 9]  156 	cmpx	,s++	;cmphi:
   014E 26 F8         [ 3]  157 	bne	L27
   0150                     158 L26:
   0150 30 A4         [ 4]  159 	leax	,y
   0152 35 E0         [ 8]  160 	puls	y,u,pc
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

