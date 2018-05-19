                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_ram_0xc8_2.c
                              7 ;----- asm -----
                              8 	.bank page_c8 (BASE=0xc800,SIZE=0x0080)
                              9 	.area .dpc8 (OVR,BANK=page_c8)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _Vec_Snd_shadow
                             13 	.area	.dpc8
   C800                      14 _Vec_Snd_shadow:
   C800 00 00                15 	.word	0	;skip space 31
   C802 00 00                16 	.word	0	;skip space 29
   C804 00 00                17 	.word	0	;skip space 27
   C806 00 00                18 	.word	0	;skip space 25
   C808 00 00                19 	.word	0	;skip space 23
   C80A 00 00                20 	.word	0	;skip space 21
   C80C 00 00                21 	.word	0	;skip space 19
   C80E 00 00                22 	.word	0	;skip space 17
   C810 00 00                23 	.word	0	;skip space 15
   C812 00 00                24 	.word	0	;skip space 13
   C814 00 00                25 	.word	0	;skip space 11
   C816 00 00                26 	.word	0	;skip space 9
   C818 00 00                27 	.word	0	;skip space 7
   C81A 00 00                28 	.word	0	;skip space 5
   C81C 00 00                29 	.word	0	;skip space 3
   C81E 00                   30 	.byte	0	;skip space
                             31 	.globl _Vec_Joy_Mux
   C81F                      32 _Vec_Joy_Mux:
   C81F 00 00                33 	.word	0	;skip space 15
   C821 00 00                34 	.word	0	;skip space 13
   C823 00 00                35 	.word	0	;skip space 11
   C825 00 00                36 	.word	0	;skip space 9
   C827 00 00                37 	.word	0	;skip space 7
   C829 00 00                38 	.word	0	;skip space 5
   C82B 00 00                39 	.word	0	;skip space 3
   C82D 00                   40 	.byte	0	;skip space
                             41 	.globl _Vec_Counters
   C82E                      42 _Vec_Counters:
   C82E 00 00                43 	.word	0	;skip space 48
   C830 00 00                44 	.word	0	;skip space 46
   C832 00 00                45 	.word	0	;skip space 44
   C834 00 00                46 	.word	0	;skip space 42
   C836 00 00                47 	.word	0	;skip space 40
   C838 00 00                48 	.word	0	;skip space 38
   C83A 00 00                49 	.word	0	;skip space 36
   C83C 00 00                50 	.word	0	;skip space 34
   C83E 00 00                51 	.word	0	;skip space 32
   C840 00 00                52 	.word	0	;skip space 30
   C842 00 00                53 	.word	0	;skip space 28
   C844 00 00                54 	.word	0	;skip space 26
   C846 00 00                55 	.word	0	;skip space 24
   C848 00 00                56 	.word	0	;skip space 22
   C84A 00 00                57 	.word	0	;skip space 20
   C84C 00 00                58 	.word	0	;skip space 18
   C84E 00 00                59 	.word	0	;skip space 16
   C850 00 00                60 	.word	0	;skip space 14
   C852 00 00                61 	.word	0	;skip space 12
   C854 00 00                62 	.word	0	;skip space 10
   C856 00 00                63 	.word	0	;skip space 8
   C858 00 00                64 	.word	0	;skip space 6
   C85A 00 00                65 	.word	0	;skip space 4
   C85C 00 00                66 	.word	0	;skip space 2
                             67 	.globl _Vec_XXX_09
   C85E                      68 _Vec_XXX_09:
   C85E 00                   69 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_Counters      002E GR  |   2 _Vec_Joy_Mux       001F GR
  2 _Vec_Snd_shado     0000 GR  |   2 _Vec_XXX_09        005E GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_c8]
   2 .dpc8            size   5F   flags 8584

