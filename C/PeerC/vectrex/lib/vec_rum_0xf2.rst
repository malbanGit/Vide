                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_rum_0xf2.c
                              6 ;----- asm -----
                              7 	.bank page_f2 (BASE=0xf256,SIZE=0x00aa)
                              8 	.area .0xf2 (OVR,BANK=page_f2)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	___Sound_Byte
                             12 	.area	.0xf2
   F256                      13 ___Sound_Byte:
   F256 00 00                14 	.word	0
   F258 00                   15 	.byte	0
                             16 	.globl	___Sound_Byte_x
   F259                      17 ___Sound_Byte_x:
   F259 00 00 00 00 00 00    18 	.word	0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
   F271 00                   19 	.byte	0
                             20 	.globl	___Clear_Sound
   F272                      21 ___Clear_Sound:
   F272 00 00 00 00 00 00    22 	.word	0,0,0,0,0
        00 00 00 00
   F27C 00                   23 	.byte	0
                             24 	.globl	___Sound_Bytes
   F27D                      25 ___Sound_Bytes:
   F27D 00 00 00 00 00 00    26 	.word	0,0,0
   F283 00                   27 	.byte	0
                             28 	.globl	___Sound_Bytes_x
   F284                      29 ___Sound_Bytes_x:
   F284 00 00 00 00          30 	.word	0,0
   F288 00                   31 	.byte	0
                             32 	.globl	___Do_Sound
   F289                      33 ___Do_Sound:
   F289 00 00                34 	.word	0
   F28B 00                   35 	.byte	0
                             36 	.globl	___Do_Sound_x
   F28C                      37 ___Do_Sound_x:
   F28C 00 00 00 00 00 00    38 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
   F29C 00                   39 	.byte	0
                             40 	.globl	___Intensity_1F
   F29D                      41 ___Intensity_1F:
   F29D 00 00 00 00          42 	.word	0,0
                             43 	.globl	___Intensity_3F
   F2A1                      44 ___Intensity_3F:
   F2A1 00 00 00 00          45 	.word	0,0
                             46 	.globl	___Intensity_5F
   F2A5                      47 ___Intensity_5F:
   F2A5 00 00 00 00          48 	.word	0,0
                             49 	.globl	___Intensity_7F
   F2A9                      50 ___Intensity_7F:
   F2A9 00 00                51 	.word	0
                             52 	.globl	___Intensity_a
   F2AB                      53 ___Intensity_a:
   F2AB 00 00 00 00 00 00    54 	.word	0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
   F2BD 00                   55 	.byte	0
                             56 	.globl	___Dot_ix_b
   F2BE                      57 ___Dot_ix_b:
   F2BE 00 00                58 	.word	0
   F2C0 00                   59 	.byte	0
                             60 	.globl	___Dot_ix
   F2C1                      61 ___Dot_ix:
   F2C1 00 00                62 	.word	0
                             63 	.globl	___Dot_d
   F2C3                      64 ___Dot_d:
   F2C3 00 00                65 	.word	0
                             66 	.globl	___Dot_here
   F2C5                      67 ___Dot_here:
   F2C5 00 00 00 00 00 00    68 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             69 	.globl	___Dot_List
   F2D5                      70 ___Dot_List:
   F2D5 00 00 00 00 00 00    71 	.word	0,0,0,0
        00 00
   F2DD 00                   72 	.byte	0
                             73 	.globl	___Dot_List_Reset
   F2DE                      74 ___Dot_List_Reset:
   F2DE 00 00 00 00 00 00    75 	.word	0,0,0,0
        00 00
                             76 	.globl	___Recalibrate
   F2E6                      77 ___Recalibrate:
   F2E6 00 00 00 00 00 00    78 	.word	0,0,0,0,0,0
        00 00 00 00 00 00
                             79 	.globl	___Moveto_x_7F
   F2F2                      80 ___Moveto_x_7F:
   F2F2 00 00 00 00 00 00    81 	.word	0,0,0,0,0
        00 00 00 00
                             82 	.globl	___Moveto_d_7F
   F2FC                      83 ___Moveto_d_7F:
   F2FC 00                   84 	.byte	0
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Clear_Sound     001C GR  |   2 ___Do_Sound        0033 GR
  2 ___Do_Sound_x      0036 GR  |   2 ___Dot_List        007F GR
  2 ___Dot_List_Re     0088 GR  |   2 ___Dot_d           006D GR
  2 ___Dot_here        006F GR  |   2 ___Dot_ix          006B GR
  2 ___Dot_ix_b        0068 GR  |   2 ___Intensity_1     0047 GR
  2 ___Intensity_3     004B GR  |   2 ___Intensity_5     004F GR
  2 ___Intensity_7     0053 GR  |   2 ___Intensity_a     0055 GR
  2 ___Moveto_d_7F     00A6 GR  |   2 ___Moveto_x_7F     009C GR
  2 ___Recalibrate     0090 GR  |   2 ___Sound_Byte      0000 GR
  2 ___Sound_Byte_     0003 GR  |   2 ___Sound_Bytes     0027 GR
  2 ___Sound_Bytes     002E GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f2]
   2 .0xf2            size   A7   flags 8584

