                              1 ;;; gcc for m6809 : Mar 17 2019 13:25:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O0
                              5 	.module	vec_rum_0xf5.c
                              6 ;----- asm -----
                              7 	.bank page_f5 (BASE=0xf511,SIZE=0x00ef)
                              8 	.area .0xf5 (OVR,BANK=page_f5)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	___Random_3
                             12 	.area	.0xf5
   F511                      13 ___Random_3:
   F511 00 00 00 00 00 00    14 	.word	0,0,0
                             15 	.globl	___Random
   F517                      16 ___Random:
   F517 00 00 00 00 00 00    17 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00
                             18 	.globl	___Init_Music_Buf
   F533                      19 ___Init_Music_Buf:
   F533 00 00 00 00 00 00    20 	.word	0,0,0,0,0,0
        00 00 00 00 00 00
                             21 	.globl	___Clear_x_b
   F53F                      22 ___Clear_x_b:
   F53F 00 00                23 	.word	0
   F541 00                   24 	.byte	0
                             25 	.globl	___Clear_C8_RAM
   F542                      26 ___Clear_C8_RAM:
   F542 00 00                27 	.word	0
   F544 00                   28 	.byte	0
                             29 	.globl	___Clear_x_256
   F545                      30 ___Clear_x_256:
   F545 00 00                31 	.word	0
   F547 00                   32 	.byte	0
                             33 	.globl	___Clear_x_d
   F548                      34 ___Clear_x_d:
   F548 00 00 00 00 00 00    35 	.word	0,0,0,0
        00 00
                             36 	.globl	___Clear_x_b_80
   F550                      37 ___Clear_x_b_80:
   F550 00 00                38 	.word	0
                             39 	.globl	___Clear_x_b_a
   F552                      40 ___Clear_x_b_a:
   F552 00 00 00 00 00 00    41 	.word	0,0,0,0
        00 00
                             42 	.globl	___Dec_3_Counters
   F55A                      43 ___Dec_3_Counters:
   F55A 00 00 00 00          44 	.word	0,0
                             45 	.globl	___Dec_6_Counters
   F55E                      46 ___Dec_6_Counters:
   F55E 00 00 00 00          47 	.word	0,0
   F562 00                   48 	.byte	0
                             49 	.globl	___Dec_Counters
   F563                      50 ___Dec_Counters:
   F563 00 00 00 00 00 00    51 	.word	0,0,0,0,0
        00 00 00 00
                             52 	.globl	___Delay_3
   F56D                      53 ___Delay_3:
   F56D 00 00 00 00          54 	.word	0,0
                             55 	.globl	___Delay_2
   F571                      56 ___Delay_2:
   F571 00 00 00 00          57 	.word	0,0
                             58 	.globl	___Delay_1
   F575                      59 ___Delay_1:
   F575 00 00 00 00          60 	.word	0,0
                             61 	.globl	___Delay_0
   F579                      62 ___Delay_0:
   F579 00                   63 	.byte	0
                             64 	.globl	___Delay_b
   F57A                      65 ___Delay_b:
   F57A 00 00                66 	.word	0
   F57C 00                   67 	.byte	0
                             68 	.globl	___Delay_RTS
   F57D                      69 ___Delay_RTS:
   F57D 00                   70 	.byte	0
                             71 	.globl	___Bitmask_a
   F57E                      72 ___Bitmask_a:
   F57E 00 00 00 00 00 00    73 	.word	0,0,0
                             74 	.globl	___Abs_a_b
   F584                      75 ___Abs_a_b:
   F584 00 00 00 00 00 00    76 	.word	0,0,0
   F58A 00                   77 	.byte	0
                             78 	.globl	___Abs_b
   F58B                      79 ___Abs_b:
   F58B 00 00 00 00 00 00    80 	.word	0,0,0,0
        00 00
                             81 	.globl	___Rise_Run_Angle
   F593                      82 ___Rise_Run_Angle:
   F593 00 00 00 00 00 00    83 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   F5B3 00 00 00 00 00 00    84 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   F5D3 00 00 00 00 00 00    85 	.word	0,0,0
                             86 	.globl	___Get_Rise_Idx
   F5D9                      87 ___Get_Rise_Idx:
   F5D9 00 00                88 	.word	0
                             89 	.globl	___Xform_Sin
   F5DB                      90 ___Xform_Sin:
   F5DB 00 00 00 00 00 00    91 	.word	0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
                             92 	.globl	___Get_Rise_Run
   F5EF                      93 ___Get_Rise_Run:
   F5EF 00 00 00 00 00 00    94 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             95 	.globl	___Rise_Run_X
   F5FF                      96 ___Rise_Run_X:
   F5FF 00                   97 	.byte	0
ASxxxx Assembler V05.31  (Motorola 6809)                                Page 1
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:29 2020

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Abs_a_b         0073 GR  |   2 ___Abs_b           007A GR
  2 ___Bitmask_a       006D GR  |   2 ___Clear_C8_RA     0031 GR
  2 ___Clear_x_256     0034 GR  |   2 ___Clear_x_b       002E GR
  2 ___Clear_x_b_8     003F GR  |   2 ___Clear_x_b_a     0041 GR
  2 ___Clear_x_d       0037 GR  |   2 ___Dec_3_Count     0049 GR
  2 ___Dec_6_Count     004D GR  |   2 ___Dec_Counter     0052 GR
  2 ___Delay_0         0068 GR  |   2 ___Delay_1         0064 GR
  2 ___Delay_2         0060 GR  |   2 ___Delay_3         005C GR
  2 ___Delay_RTS       006C GR  |   2 ___Delay_b         0069 GR
  2 ___Get_Rise_Id     00C8 GR  |   2 ___Get_Rise_Ru     00DE GR
  2 ___Init_Music_     0022 GR  |   2 ___Random          0006 GR
  2 ___Random_3        0000 GR  |   2 ___Rise_Run_An     0082 GR
  2 ___Rise_Run_X      00EE GR  |   2 ___Xform_Sin       00CA GR

ASxxxx Assembler V05.31  (Motorola 6809)                                Page 2
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:29 2020

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f5]
   2 .0xf5            size   EF   flags 8584

