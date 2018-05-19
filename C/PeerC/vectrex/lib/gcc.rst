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
   0055                      20 _memcmp:
   0055 34 60         [ 7]   21 	pshs	y,u
   0057 32 7A         [ 5]   22 	leas	-6,s
   0059 AF E4         [ 5]   23 	stx	,s
   005B EE 6E         [ 6]   24 	ldu	14,s
   005D 8E 00 00      [ 3]   25 	ldx	#0
   0060 AF 62         [ 6]   26 	stx	2,s
   0062                      27 L2:
   0062 11 83 00 00   [ 5]   28 	cmpu	#0
   0066 27 36         [ 3]   29 	beq	L9
   0068 EC E4         [ 5]   30 	ldd	,s
   006A 10 AE 62      [ 7]   31 	ldy	2,s
   006D 30 AB         [ 8]   32 	leax	d,y
   006F E6 84         [ 4]   33 	ldb	,x
   0071 E7 64         [ 5]   34 	stb	4,s
   0073 EC 6C         [ 6]   35 	ldd	12,s
   0075 30 AB         [ 8]   36 	leax	d,y
   0077 E6 84         [ 4]   37 	ldb	,x
   0079 E7 65         [ 5]   38 	stb	5,s
   007B 1F 20         [ 6]   39 	tfr	y,d
   007D C3 00 01      [ 4]   40 	addd	#1
   0080 ED 62         [ 6]   41 	std	2,s
   0082 33 5F         [ 5]   42 	leau	-1,u
   0084 E6 64         [ 5]   43 	ldb	4,s
   0086 E1 65         [ 5]   44 	cmpb	5,s	;cmpqi:
   0088 27 D8         [ 3]   45 	beq	L2
   008A C6 FF         [ 2]   46 	ldb	#-1
   008C E7 62         [ 5]   47 	stb	2,s
   008E E6 64         [ 5]   48 	ldb	4,s
   0090 E1 65         [ 5]   49 	cmpb	5,s	;cmpqi:
   0092 25 04         [ 3]   50 	blo	L4
   0094 C6 01         [ 2]   51 	ldb	#1
   0096 E7 62         [ 5]   52 	stb	2,s
   0098                      53 L4:
   0098 E6 62         [ 5]   54 	ldb	2,s
   009A 32 66         [ 5]   55 	leas	6,s
   009C 35 E0         [ 8]   56 	puls	y,u,pc
   009E                      57 L9:
   009E 6F 62         [ 7]   58 	clr	2,s
   00A0 E6 62         [ 5]   59 	ldb	2,s
   00A2 32 66         [ 5]   60 	leas	6,s
   00A4 35 E0         [ 8]   61 	puls	y,u,pc
                             62 	.globl _memcpy
   00A6                      63 _memcpy:
   00A6 34 60         [ 7]   64 	pshs	y,u
   00A8 32 7C         [ 5]   65 	leas	-4,s
   00AA AF E4         [ 5]   66 	stx	,s
   00AC AE 6C         [ 6]   67 	ldx	12,s
   00AE 27 1F         [ 3]   68 	beq	L11
   00B0 CE 00 00      [ 3]   69 	ldu	#0
   00B3 EF 62         [ 6]   70 	stu	2,s
   00B5                      71 L12:
   00B5 EC E4         [ 5]   72 	ldd	,s
   00B7 AE 62         [ 6]   73 	ldx	2,s
   00B9 31 8B         [ 8]   74 	leay	d,x
   00BB EC 6A         [ 6]   75 	ldd	10,s
   00BD 30 8B         [ 8]   76 	leax	d,x
   00BF E6 84         [ 4]   77 	ldb	,x
   00C1 E7 A4         [ 4]   78 	stb	,y
   00C3 EC 62         [ 6]   79 	ldd	2,s
   00C5 C3 00 01      [ 4]   80 	addd	#1
   00C8 ED 62         [ 6]   81 	std	2,s
   00CA 10 A3 6C      [ 8]   82 	cmpd	12,s	;cmphi:
   00CD 26 E6         [ 3]   83 	bne	L12
   00CF                      84 L11:
   00CF AE E4         [ 5]   85 	ldx	,s
   00D1 32 64         [ 5]   86 	leas	4,s
   00D3 35 E0         [ 8]   87 	puls	y,u,pc
                             88 	.globl _memmove
   00D5                      89 _memmove:
   00D5 34 60         [ 7]   90 	pshs	y,u
   00D7 32 7C         [ 5]   91 	leas	-4,s
   00D9 AF E4         [ 5]   92 	stx	,s
   00DB AC 6A         [ 7]   93 	cmpx	10,s	;cmphi:
   00DD 24 2C         [ 3]   94 	bhs	L16
   00DF AE 6C         [ 6]   95 	ldx	12,s
   00E1 27 22         [ 3]   96 	beq	L17
   00E3 CE 00 00      [ 3]   97 	ldu	#0
   00E6 EF 62         [ 6]   98 	stu	2,s
   00E8                      99 L18:
   00E8 EC E4         [ 5]  100 	ldd	,s
   00EA AE 62         [ 6]  101 	ldx	2,s
   00EC 31 8B         [ 8]  102 	leay	d,x
   00EE EC 6A         [ 6]  103 	ldd	10,s
   00F0 30 8B         [ 8]  104 	leax	d,x
   00F2 E6 84         [ 4]  105 	ldb	,x
   00F4 E7 A4         [ 4]  106 	stb	,y
   00F6 EC 62         [ 6]  107 	ldd	2,s
   00F8 C3 00 01      [ 4]  108 	addd	#1
   00FB ED 62         [ 6]  109 	std	2,s
   00FD AE 6C         [ 6]  110 	ldx	12,s
   00FF 34 06         [ 7]  111 	pshs	d	;cmphi: R:d with R:x
   0101 AC E1         [ 9]  112 	cmpx	,s++	;cmphi:
   0103 26 E3         [ 3]  113 	bne	L18
   0105                     114 L17:
   0105 AE E4         [ 5]  115 	ldx	,s
   0107 32 64         [ 5]  116 	leas	4,s
   0109 35 E0         [ 8]  117 	puls	y,u,pc
   010B                     118 L16:
   010B EE 6C         [ 6]  119 	ldu	12,s
   010D 27 F6         [ 3]  120 	beq	L17
   010F 1F 30         [ 6]  121 	tfr	u,d
   0111 C3 FF FF      [ 4]  122 	addd	#-1
   0114 ED 62         [ 6]  123 	std	2,s
   0116 EC 6A         [ 6]  124 	ldd	10,s
   0118 EE 62         [ 6]  125 	ldu	2,s
   011A 30 CB         [ 8]  126 	leax	d,u
   011C EC E4         [ 5]  127 	ldd	,s
   011E 31 CB         [ 8]  128 	leay	d,u
   0120 20 07         [ 3]  129 	bra	L19
   0122                     130 L24:
   0122 EC 62         [ 6]  131 	ldd	2,s
   0124 C3 FF FF      [ 4]  132 	addd	#-1
   0127 ED 62         [ 6]  133 	std	2,s
   0129                     134 L19:
   0129 E6 84         [ 4]  135 	ldb	,x
   012B E7 A4         [ 4]  136 	stb	,y
   012D 31 3F         [ 5]  137 	leay	-1,y
   012F 30 1F         [ 5]  138 	leax	-1,x
   0131 EE 62         [ 6]  139 	ldu	2,s
   0133 26 ED         [ 3]  140 	bne	L24
   0135 AE E4         [ 5]  141 	ldx	,s
   0137 32 64         [ 5]  142 	leas	4,s
   0139 35 E0         [ 8]  143 	puls	y,u,pc
                            144 	.globl _memset
   013B                     145 _memset:
   013B 34 60         [ 7]  146 	pshs	y,u
   013D 31 84         [ 4]  147 	leay	,x
   013F EE 66         [ 6]  148 	ldu	6,s
   0141 27 0E         [ 3]  149 	beq	L26
   0143 1E 02         [ 8]  150 	exg	d,y
   0145 33 CB         [ 8]  151 	leau	d,u
   0147 1E 02         [ 8]  152 	exg	d,y
   0149                     153 L27:
   0149 E7 80         [ 6]  154 	stb	,x+
   014B 34 40         [ 6]  155 	pshs	u	;cmphi: R:u with R:x
   014D AC E1         [ 9]  156 	cmpx	,s++	;cmphi:
   014F 26 F8         [ 3]  157 	bne	L27
   0151                     158 L26:
   0151 30 A4         [ 4]  159 	leax	,y
   0153 35 E0         [ 8]  160 	puls	y,u,pc
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

