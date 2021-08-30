                              1 ;;; gcc for m6809 : Mar 17 2019 13:25:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O0
                              5 	.module	vec_rum_0xf6.c
                              6 ;----- asm -----
                              7 	.bank page_f6 (BASE=0xf601,SIZE=0x00ff)
                              8 	.area .0xf6 (OVR,BANK=page_f6)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	___Rise_Run_Y
                             12 	.area	.0xf6
   F601                      13 ___Rise_Run_Y:
   F601 00 00                14 	.word	0
                             15 	.globl	___Rise_Run_Len
   F603                      16 ___Rise_Run_Len:
   F603 00 00 00 00 00 00    17 	.word	0,0,0,0,0,0
        00 00 00 00 00 00
   F60F 00                   18 	.byte	0
                             19 	.globl	___Rot_VL_ab
   F610                      20 ___Rot_VL_ab:
   F610 00 00                21 	.word	0
   F612 00                   22 	.byte	0
                             23 	.globl	___Rot_VL_Diff
   F613                      24 ___Rot_VL_Diff:
   F613 00 00                25 	.word	0
   F615 00                   26 	.byte	0
                             27 	.globl	___Rot_VL
   F616                      28 ___Rot_VL:
   F616 00 00 00 00 00 00    29 	.word	0,0,0,0
        00 00
   F61E 00                   30 	.byte	0
                             31 	.globl	___Rot_VL_Mode
   F61F                      32 ___Rot_VL_Mode:
   F61F 00 00                33 	.word	0
   F621 00                   34 	.byte	0
                             35 	.globl	___Rot_VL_Pack
   F622                      36 ___Rot_VL_Pack:
   F622 00 00 00 00 00 00    37 	.word	0,0,0,0
        00 00
   F62A 00                   38 	.byte	0
                             39 	.globl	___Rot_VL_M_dft
   F62B                      40 ___Rot_VL_M_dft:
   F62B 00 00 00 00 00 00    41 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   F64B 00 00 00 00 00 00    42 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             43 	.globl	___Xform_Run_a
   F65B                      44 ___Xform_Run_a:
   F65B 00 00                45 	.word	0
                             46 	.globl	___Xform_Run
   F65D                      47 ___Xform_Run:
   F65D 00 00 00 00          48 	.word	0,0
                             49 	.globl	___Xform_Rise_a
   F661                      50 ___Xform_Rise_a:
   F661 00 00                51 	.word	0
                             52 	.globl	___Xform_Rise
   F663                      53 ___Xform_Rise:
   F663 00 00 00 00 00 00    54 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00
                             55 	.globl	___Move_Mem_a_1
   F67F                      56 ___Move_Mem_a_1:
   F67F 00 00 00 00          57 	.word	0,0
                             58 	.globl	___Move_Mem_a
   F683                      59 ___Move_Mem_a:
   F683 00 00 00 00          60 	.word	0,0
                             61 	.globl	___Init_Music_chk
   F687                      62 ___Init_Music_chk:
   F687 00 00 00 00 00 00    63 	.word	0,0,0
                             64 	.globl	___Init_Music
   F68D                      65 ___Init_Music:
   F68D 00 00                66 	.word	0
   F68F 00                   67 	.byte	0
                             68 	.globl	___Init_Music_a
   F690                      69 ___Init_Music_a:
   F690 00 00                70 	.word	0
                             71 	.globl	___Init_Music_x
   F692                      72 ___Init_Music_x:
   F692 00                   73 	.byte	0
ASxxxx Assembler V05.31  (Motorola 6809)                                Page 1
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:29 2020

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Init_Music      008C GR  |   2 ___Init_Music_     008F GR
  2 ___Init_Music_     0086 GR  |   2 ___Init_Music_     0091 GR
  2 ___Move_Mem_a      0082 GR  |   2 ___Move_Mem_a_     007E GR
  2 ___Rise_Run_Le     0002 GR  |   2 ___Rise_Run_Y      0000 GR
  2 ___Rot_VL          0015 GR  |   2 ___Rot_VL_Diff     0012 GR
  2 ___Rot_VL_M_df     002A GR  |   2 ___Rot_VL_Mode     001E GR
  2 ___Rot_VL_Pack     0021 GR  |   2 ___Rot_VL_ab       000F GR
  2 ___Xform_Rise      0062 GR  |   2 ___Xform_Rise_     0060 GR
  2 ___Xform_Run       005C GR  |   2 ___Xform_Run_a     005A GR

ASxxxx Assembler V05.31  (Motorola 6809)                                Page 2
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:29 2020

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f6]
   2 .0xf6            size   92   flags 8584

