                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_rum_fct_pjc.c
                              6 	.area	.text
                              7 	.globl	__Dot_d
   0155                       8 __Dot_d:
                              9 ;----- asm -----
                             10 ; 533 "source\vec_rum_fct_pjc.c" 1
   0155 A6 62         [ 5]   11 	lda 2,s
   0157 7E F2 C3      [ 4]   12 	jmp ___Dot_d; BIOS call
                             13 ;--- end asm ---
                             14 	.globl	__Dot_dd
   015A                      15 __Dot_dd:
                             16 ;----- asm -----
                             17 ; 542 "source\vec_rum_fct_pjc.c" 1
   015A 1F 10         [ 6]   18 	tfr x,d
   015C 7E F2 C3      [ 4]   19 	jmp ___Dot_d; BIOS call
                             20 ;--- end asm ---
                             21 	.globl	__Print_Str_hwyx
   015F                      22 __Print_Str_hwyx:
   015F 34 40         [ 6]   23 	pshs	u
                             24 ;----- asm -----
                             25 ; 657 "source\vec_rum_fct_pjc.c" 1
   0161 1F 13         [ 6]   26 	tfr x,u
   0163 BD F3 73      [ 8]   27 	jsr ___Print_Str_hwyx; BIOS call
                             28 ;--- end asm ---
   0166 35 C0         [ 7]   29 	puls	u,pc
                             30 	.globl	__Print_Str_yx
   0168                      31 __Print_Str_yx:
   0168 34 40         [ 6]   32 	pshs	u
                             33 ;----- asm -----
                             34 ; 682 "source\vec_rum_fct_pjc.c" 1
   016A 1F 13         [ 6]   35 	tfr x,u
   016C BD F3 78      [ 8]   36 	jsr ___Print_Str_yx; BIOS call
                             37 ;--- end asm ---
   016F 35 C0         [ 7]   38 	puls	u,pc
                             39 	.globl	__Print_Str_d
   0171                      40 __Print_Str_d:
   0171 34 40         [ 6]   41 	pshs	u
                             42 ;----- asm -----
                             43 ; 708 "source\vec_rum_fct_pjc.c" 1
   0173 A6 64         [ 5]   44 	lda 4,s
   0175 1F 13         [ 6]   45 	tfr x,u
   0177 BD F3 7A      [ 8]   46 	jsr ___Print_Str_d; BIOS call
                             47 ;--- end asm ---
   017A 35 C0         [ 7]   48 	puls	u,pc
                             49 	.globl	__Print_Str_dd
   017C                      50 __Print_Str_dd:
   017C 34 40         [ 6]   51 	pshs	u
                             52 ;----- asm -----
                             53 ; 718 "source\vec_rum_fct_pjc.c" 1
   017E 1F 10         [ 6]   54 	tfr x,d
   0180 EE 64         [ 6]   55 	ldu 4,s
   0182 BD F3 7A      [ 8]   56 	jsr ___Print_Str_d; BIOS call
                             57 ;--- end asm ---
   0185 35 C0         [ 7]   58 	puls	u,pc
                             59 	.globl	__Print_List_hw
   0187                      60 __Print_List_hw:
   0187 34 40         [ 6]   61 	pshs	u
                             62 ;----- asm -----
                             63 ; 746 "source\vec_rum_fct_pjc.c" 1
   0189 1F 13         [ 6]   64 	tfr x,u
   018B BD F3 85      [ 8]   65 	jsr ___Print_List_hw; BIOS call
                             66 ;--- end asm ---
   018E 35 C0         [ 7]   67 	puls	u,pc
                             68 	.globl	__Print_List
   0190                      69 __Print_List:
   0190 34 40         [ 6]   70 	pshs	u
                             71 ;----- asm -----
                             72 ; 773 "source\vec_rum_fct_pjc.c" 1
   0192 1F 13         [ 6]   73 	tfr x,u
   0194 BD F3 8A      [ 8]   74 	jsr ___Print_List; BIOS call
                             75 ;--- end asm ---
   0197 35 C0         [ 7]   76 	puls	u,pc
                             77 	.globl	__Print_List_chk
   0199                      78 __Print_List_chk:
   0199 34 40         [ 6]   79 	pshs	u
                             80 ;----- asm -----
                             81 ; 800 "source\vec_rum_fct_pjc.c" 1
   019B 1F 13         [ 6]   82 	tfr x,u
   019D BD F3 8C      [ 8]   83 	jsr ___Print_List_chk; BIOS call
                             84 ;--- end asm ---
   01A0 35 C0         [ 7]   85 	puls	u,pc
                             86 	.globl	__Print_Ships_x
   01A2                      87 __Print_Ships_x:
                             88 ;----- asm -----
                             89 ; 825 "source\vec_rum_fct_pjc.c" 1
   01A2 A6 62         [ 5]   90 	lda 2,s
   01A4 7E F3 91      [ 4]   91 	jmp ___Print_Ships_x; BIOS call
                             92 ;--- end asm ---
                             93 	.globl	__Print_Ships
   01A7                      94 __Print_Ships:
                             95 ;----- asm -----
                             96 ; 850 "source\vec_rum_fct_pjc.c" 1
   01A7 A6 62         [ 5]   97 	lda 2,s
   01A9 7E F3 93      [ 4]   98 	jmp ___Print_Ships; BIOS call
                             99 ;--- end asm ---
                            100 	.globl	__Print_Str
   01AC                     101 __Print_Str:
   01AC 34 40         [ 6]  102 	pshs	u
                            103 ;----- asm -----
                            104 ; 874 "source\vec_rum_fct_pjc.c" 1
   01AE 1F 13         [ 6]  105 	tfr x,u
   01B0 BD F4 95      [ 8]  106 	jsr ___Print_Str; BIOS call
                            107 ;--- end asm ---
   01B3 35 C0         [ 7]  108 	puls	u,pc
                            109 	.globl	__Print_MRast
   01B5                     110 __Print_MRast:
   01B5 34 40         [ 6]  111 	pshs	u
                            112 ;----- asm -----
                            113 ; 898 "source\vec_rum_fct_pjc.c" 1
   01B7 BD F4 98      [ 8]  114 	jsr ___Print_MRast; BIOS call
                            115 ;--- end asm ---
   01BA 35 C0         [ 7]  116 	puls	u,pc
                            117 	.globl	__Draw_Pat_VL_aa
   01BC                     118 __Draw_Pat_VL_aa:
                            119 ;----- asm -----
                            120 ; 964 "source\vec_rum_fct_pjc.c" 1
   01BC 1F 98         [ 6]  121 	tfr b,a
   01BE 7E F4 33      [ 4]  122 	jmp ___Draw_Pat_VL_aa; BIOS call
                            123 ;--- end asm ---
                            124 	.globl	__Draw_Pat_VL_a
   01C1                     125 __Draw_Pat_VL_a:
                            126 ;----- asm -----
                            127 ; 995 "source\vec_rum_fct_pjc.c" 1
   01C1 1F 98         [ 6]  128 	tfr b,a
   01C3 7E F4 34      [ 4]  129 	jmp ___Draw_Pat_VL_a; BIOS call
                            130 ;--- end asm ---
                            131 	.globl	__Draw_Line_d
   01C6                     132 __Draw_Line_d:
                            133 ;----- asm -----
                            134 ; 1063 "source\vec_rum_fct_pjc.c" 1
   01C6 A6 62         [ 5]  135 	lda 2,s
   01C8 7E F3 DF      [ 4]  136 	jmp ___Draw_Line_d; BIOS call
                            137 ;--- end asm ---
                            138 	.globl	__Draw_VL_ab
   01CB                     139 __Draw_VL_ab:
                            140 ;----- asm -----
                            141 ; 1120 "source\vec_rum_fct_pjc.c" 1
   01CB A6 62         [ 5]  142 	lda 2,s
   01CD 7E F3 D8      [ 4]  143 	jmp ___Draw_VL_ab; BIOS call
                            144 ;--- end asm ---
                            145 	.globl	__Draw_VL_a
   01D0                     146 __Draw_VL_a:
                            147 ;----- asm -----
                            148 ; 1235 "source\vec_rum_fct_pjc.c" 1
   01D0 1F 98         [ 6]  149 	tfr b,a
   01D2 7E F3 DA      [ 4]  150 	jmp ___Draw_VL_a; BIOS call
                            151 ;--- end asm ---
                            152 	.globl	__Mov_Draw_VL_ab
   01D5                     153 __Mov_Draw_VL_ab:
                            154 ;----- asm -----
                            155 ; 1365 "source\vec_rum_fct_pjc.c" 1
   01D5 A6 62         [ 5]  156 	lda 2,s
   01D7 7E F3 B7      [ 4]  157 	jmp ___Mov_Draw_VL_ab; BIOS call
                            158 ;--- end asm ---
                            159 	.globl	__Mov_Draw_VL_a
   01DA                     160 __Mov_Draw_VL_a:
                            161 ;----- asm -----
                            162 ; 1393 "source\vec_rum_fct_pjc.c" 1
   01DA 1F 98         [ 6]  163 	tfr b,a
   01DC 7E F3 B9      [ 4]  164 	jmp ___Mov_Draw_VL_a; BIOS call
                            165 ;--- end asm ---
                            166 	.globl	__Mov_Draw_VL_d
   01DF                     167 __Mov_Draw_VL_d:
                            168 ;----- asm -----
                            169 ; 1447 "source\vec_rum_fct_pjc.c" 1
   01DF A6 62         [ 5]  170 	lda 2,s
   01E1 7E F3 BE      [ 4]  171 	jmp ___Mov_Draw_VL_d; BIOS call
                            172 ;--- end asm ---
                            173 	.globl	__Rot_VL_Mode
   01E4                     174 __Rot_VL_Mode:
   01E4 34 40         [ 6]  175 	pshs	u
                            176 ;----- asm -----
                            177 ; 1694 "source\vec_rum_fct_pjc.c" 1
   01E6 1F 98         [ 6]  178 	tfr b,a
   01E8 EE 64         [ 6]  179 	ldu 4,s
   01EA BD F6 1F      [ 8]  180 	jsr ___Rot_VL_Mode; BIOS call
                            181 ;--- end asm ---
   01ED 35 C0         [ 7]  182 	puls	u,pc
                            183 	.globl	__Rot_VL_Pack
   01EF                     184 __Rot_VL_Pack:
   01EF 34 40         [ 6]  185 	pshs	u
                            186 ;----- asm -----
                            187 ; 1722 "source\vec_rum_fct_pjc.c" 1
   01F1 EE 64         [ 6]  188 	ldu 4,s
   01F3 BD F6 22      [ 8]  189 	jsr ___Rot_VL_Pack; BIOS call
                            190 ;--- end asm ---
   01F6 35 C0         [ 7]  191 	puls	u,pc
                            192 	.globl	__Rot_VL_M_dft
   01F8                     193 __Rot_VL_M_dft:
   01F8 34 40         [ 6]  194 	pshs	u
                            195 ;----- asm -----
                            196 ; 1749 "source\vec_rum_fct_pjc.c" 1
   01FA EE 64         [ 6]  197 	ldu 4,s
   01FC BD F6 2B      [ 8]  198 	jsr ___Rot_VL_M_dft; BIOS call
                            199 ;--- end asm ---
   01FF 35 C0         [ 7]  200 	puls	u,pc
                            201 	.globl	__Random_3
   0201                     202 __Random_3:
                            203 ;----- asm -----
                            204 ; 1803 "source\vec_rum_fct_pjc.c" 1
   0201 BD F5 11      [ 8]  205 	jsr ___Random_3; BIOS call
   0204 1F 89         [ 6]  206 	tfr a,b
                            207 ;--- end asm ---
   0206 39            [ 5]  208 	rts
                            209 	.globl	__Random
   0207                     210 __Random:
                            211 ;----- asm -----
                            212 ; 1821 "source\vec_rum_fct_pjc.c" 1
   0207 BD F5 17      [ 8]  213 	jsr ___Random; BIOS call
   020A 1F 89         [ 6]  214 	tfr a,b
                            215 ;--- end asm ---
   020C 39            [ 5]  216 	rts
                            217 	.globl	__Bitmask_a
   020D                     218 __Bitmask_a:
                            219 ;----- asm -----
                            220 ; 1848 "source\vec_rum_fct_pjc.c" 1
   020D 1F 98         [ 6]  221 	tfr b,a
   020F BD F5 7E      [ 8]  222 	jsr ___Bitmask_a; BIOS call
   0212 1F 89         [ 6]  223 	tfr a,b
                            224 ;--- end asm ---
   0214 39            [ 5]  225 	rts
                            226 	.globl	__Abs_a_b
   0215                     227 __Abs_a_b:
                            228 ;----- asm -----
                            229 ; 1870 "source\vec_rum_fct_pjc.c" 1
   0215 A6 62         [ 5]  230 	lda 2,s
   0217 BD F5 84      [ 8]  231 	jsr ___Abs_a_b; BIOS call
   021A 1F 01         [ 6]  232 	tfr d,x
                            233 ;--- end asm ---
   021C 39            [ 5]  234 	rts
                            235 	.globl	__Xform_Sin
   021D                     236 __Xform_Sin:
                            237 ;----- asm -----
                            238 ; 1955 "source\vec_rum_fct_pjc.c" 1
   021D 1F 98         [ 6]  239 	tfr b,a
   021F BD F5 DB      [ 8]  240 	jsr ___Xform_Sin; BIOS call
   0222 1F 89         [ 6]  241 	tfr a,b
                            242 ;--- end asm ---
   0224 39            [ 5]  243 	rts
                            244 	.globl	__Get_Rise_Run
   0225                     245 __Get_Rise_Run:
                            246 ;----- asm -----
                            247 ; 1976 "source\vec_rum_fct_pjc.c" 1
   0225 BD F5 EF      [ 8]  248 	jsr ___Get_Rise_Run; BIOS call
   0228 1F 01         [ 6]  249 	tfr d,x
                            250 ;--- end asm ---
   022A 39            [ 5]  251 	rts
                            252 	.globl	__Xform_Run_a
   022B                     253 __Xform_Run_a:
                            254 ;----- asm -----
                            255 ; 1997 "source\vec_rum_fct_pjc.c" 1
   022B 1F 98         [ 6]  256 	tfr b,a
   022D BD F6 5B      [ 8]  257 	jsr ___Xform_Run_a; BIOS call
   0230 1F 01         [ 6]  258 	tfr d,x
                            259 ;--- end asm ---
   0232 39            [ 5]  260 	rts
                            261 	.globl	__Xform_Run
   0233                     262 __Xform_Run:
                            263 ;----- asm -----
                            264 ; 2018 "source\vec_rum_fct_pjc.c" 1
   0233 BD F6 5D      [ 8]  265 	jsr ___Xform_Run; BIOS call
   0236 1F 89         [ 6]  266 	tfr a,b
                            267 ;--- end asm ---
   0238 39            [ 5]  268 	rts
                            269 	.globl	__Xform_Rise_a
   0239                     270 __Xform_Rise_a:
                            271 ;----- asm -----
                            272 ; 2039 "source\vec_rum_fct_pjc.c" 1
   0239 1F 98         [ 6]  273 	tfr b,a
   023B BD F6 61      [ 8]  274 	jsr ___Xform_Rise_a; BIOS call
   023E 1F 89         [ 6]  275 	tfr a,b
                            276 ;--- end asm ---
   0240 39            [ 5]  277 	rts
                            278 	.globl	__Xform_Rise
   0241                     279 __Xform_Rise:
                            280 ;----- asm -----
                            281 ; 2060 "source\vec_rum_fct_pjc.c" 1
   0241 BD F6 63      [ 8]  282 	jsr ___Xform_Rise; BIOS call
   0244 1F 89         [ 6]  283 	tfr a,b
                            284 ;--- end asm ---
   0246 39            [ 5]  285 	rts
                            286 	.globl	__Clear_x_d
   0247                     287 __Clear_x_d:
                            288 ;----- asm -----
                            289 ; 2143 "source\vec_rum_fct_pjc.c" 1
   0247 EC 62         [ 6]  290 	ldd 2,s
   0249 7E F5 48      [ 4]  291 	jmp ___Clear_x_d; BIOS call
                            292 ;--- end asm ---
                            293 	.globl	__Move_Mem_a_1
   024C                     294 __Move_Mem_a_1:
   024C 34 40         [ 6]  295 	pshs	u
                            296 ;----- asm -----
                            297 ; 2169 "source\vec_rum_fct_pjc.c" 1
   024E 1F 98         [ 6]  298 	tfr b,a
   0250 EE 64         [ 6]  299 	ldu 4,s
   0252 BD F6 7F      [ 8]  300 	jsr ___Move_Mem_a_1; BIOS call
                            301 ;--- end asm ---
   0255 35 C0         [ 7]  302 	puls	u,pc
                            303 	.globl	__Move_Mem_a
   0257                     304 __Move_Mem_a:
   0257 34 40         [ 6]  305 	pshs	u
                            306 ;----- asm -----
                            307 ; 2190 "source\vec_rum_fct_pjc.c" 1
   0259 1F 98         [ 6]  308 	tfr b,a
   025B EE 64         [ 6]  309 	ldu 4,s
   025D BD F6 7F      [ 8]  310 	jsr ___Move_Mem_a_1; BIOS call
                            311 ;--- end asm ---
   0260 35 C0         [ 7]  312 	puls	u,pc
                            313 	.globl	__Clear_x_b_a
   0262                     314 __Clear_x_b_a:
                            315 ;----- asm -----
                            316 ; 2236 "source\vec_rum_fct_pjc.c" 1
   0262 A6 62         [ 5]  317 	lda 2,s
   0264 7E F5 52      [ 4]  318 	jmp ___Clear_x_b_a; BIOS call
                            319 ;--- end asm ---
                            320 	.globl	__Read_Btns_Mask
   0267                     321 __Read_Btns_Mask:
                            322 ;----- asm -----
                            323 ; 2264 "source\vec_rum_fct_pjc.c" 1
   0267 1F 98         [ 6]  324 	tfr b,a
   0269 7E F1 B4      [ 4]  325 	jmp ___Read_Btns_Mask; BIOS call
                            326 ;--- end asm ---
                            327 	.globl	__Select_Game
   026C                     328 __Select_Game:
   026C 34 60         [ 7]  329 	pshs	y,u
                            330 ;----- asm -----
                            331 ; 2423 "source\vec_rum_fct_pjc.c" 1
   026E A6 66         [ 5]  332 	lda 6,s
   0270 BD F7 A9      [ 8]  333 	jsr ___Select_Game; BIOS call
                            334 ;--- end asm ---
   0273 35 E0         [ 8]  335 	puls	y,u,pc
                            336 	.globl	__Display_Option
   0275                     337 __Display_Option:
   0275 34 60         [ 7]  338 	pshs	y,u
                            339 ;----- asm -----
                            340 ; 2444 "source\vec_rum_fct_pjc.c" 1
   0277 1F 98         [ 6]  341 	tfr b,a
   0279 1F 12         [ 6]  342 	tfr x,y
   027B BD F8 35      [ 8]  343 	jsr ___Display_Option; BIOS call
                            344 ;--- end asm ---
   027E 35 E0         [ 8]  345 	puls	y,u,pc
                            346 	.globl	__Add_Score_a
   0280                     347 __Add_Score_a:
   0280 34 40         [ 6]  348 	pshs	u
                            349 ;----- asm -----
                            350 ; 2645 "source\vec_rum_fct_pjc.c" 1
   0282 1F 98         [ 6]  351 	tfr b,a
   0284 BD F8 5E      [ 8]  352 	jsr ___Add_Score_a; BIOS call
                            353 ;--- end asm ---
   0287 35 C0         [ 7]  354 	puls	u,pc
                            355 	.globl	__Add_Score_d
   0289                     356 __Add_Score_d:
                            357 ;----- asm -----
                            358 ; 2672 "source\vec_rum_fct_pjc.c" 1
   0289 EC 62         [ 6]  359 	ldd 2,s
   028B 7E F8 7C      [ 4]  360 	jmp ___Add_Score_d; BIOS call
                            361 ;--- end asm ---
                            362 	.globl	__Compare_Score
   028E                     363 __Compare_Score:
   028E 34 40         [ 6]  364 	pshs	u
                            365 ;----- asm -----
                            366 ; 2714 "source\vec_rum_fct_pjc.c" 1
   0290 EE 64         [ 6]  367 	ldu 4,s
   0292 BD F8 C7      [ 8]  368 	jsr ___Compare_Score; BIOS call
   0295 1F 89         [ 6]  369 	tfr a,b
                            370 ;--- end asm ---
   0297 35 C0         [ 7]  371 	puls	u,pc
                            372 	.globl	__New_High_Score
   0299                     373 __New_High_Score:
   0299 34 40         [ 6]  374 	pshs	u
                            375 ;----- asm -----
                            376 ; 2744 "source\vec_rum_fct_pjc.c" 1
   029B EE 64         [ 6]  377 	ldu 4,s
   029D BD F8 D8      [ 8]  378 	jsr ___New_High_Score; BIOS call
                            379 ;--- end asm ---
   02A0 35 C0         [ 7]  380 	puls	u,pc
                            381 	.globl	__Sound_Byte
   02A2                     382 __Sound_Byte:
                            383 ;----- asm -----
                            384 ; 2780 "source\vec_rum_fct_pjc.c" 1
   02A2 A6 62         [ 5]  385 	lda 2,s
   02A4 7E F2 56      [ 4]  386 	jmp ___Sound_Byte; BIOS call
                            387 ;--- end asm ---
                            388 	.globl	__Sound_Byte_x
   02A7                     389 __Sound_Byte_x:
                            390 ;----- asm -----
                            391 ; 2799 "source\vec_rum_fct_pjc.c" 1
   02A7 A6 62         [ 5]  392 	lda 2,s
   02A9 7E F2 59      [ 4]  393 	jmp ___Sound_Byte_x; BIOS call
                            394 ;--- end asm ---
                            395 	.globl	__Sound_Bytes
   02AC                     396 __Sound_Bytes:
   02AC 34 40         [ 6]  397 	pshs	u
                            398 ;----- asm -----
                            399 ; 2837 "source\vec_rum_fct_pjc.c" 1
   02AE 1F 13         [ 6]  400 	tfr x,u
   02B0 BD F2 7D      [ 8]  401 	jsr ___Sound_Bytes; BIOS call
                            402 ;--- end asm ---
   02B3 35 C0         [ 7]  403 	puls	u,pc
                            404 	.globl	__Sound_Bytes_x
   02B5                     405 __Sound_Bytes_x:
   02B5 34 40         [ 6]  406 	pshs	u
                            407 ;----- asm -----
                            408 ; 2856 "source\vec_rum_fct_pjc.c" 1
   02B7 EE 64         [ 6]  409 	ldu 4,s
   02B9 BD F2 84      [ 8]  410 	jsr ___Sound_Bytes_x; BIOS call
                            411 ;--- end asm ---
   02BC 35 C0         [ 7]  412 	puls	u,pc
                            413 	.globl	__Do_Sound
   02BE                     414 __Do_Sound:
   02BE 34 40         [ 6]  415 	pshs	u
                            416 ;----- asm -----
                            417 ; 2876 "source\vec_rum_fct_pjc.c" 1
   02C0 BD F2 89      [ 8]  418 	jsr ___Do_Sound; BIOS call
                            419 ;--- end asm ---
   02C3 35 C0         [ 7]  420 	puls	u,pc
                            421 	.globl	__Init_Music_chk
   02C5                     422 __Init_Music_chk:
   02C5 34 60         [ 7]  423 	pshs	y,u
                            424 ;----- asm -----
                            425 ; 2913 "source\vec_rum_fct_pjc.c" 1
   02C7 1F 13         [ 6]  426 	tfr x,u
   02C9 BD F6 87      [ 8]  427 	jsr ___Init_Music_chk; BIOS call
                            428 ;--- end asm ---
   02CC 35 E0         [ 8]  429 	puls	y,u,pc
                            430 	.globl	__Init_Music
   02CE                     431 __Init_Music:
   02CE 34 40         [ 6]  432 	pshs	u
                            433 ;----- asm -----
                            434 ; 2961 "source\vec_rum_fct_pjc.c" 1
   02D0 1F 13         [ 6]  435 	tfr x,u
   02D2 BD F6 8D      [ 8]  436 	jsr ___Init_Music; BIOS call
                            437 ;--- end asm ---
   02D5 35 C0         [ 7]  438 	puls	u,pc
                            439 	.globl	__Init_Music_a
   02D7                     440 __Init_Music_a:
   02D7 34 40         [ 6]  441 	pshs	u
                            442 ;----- asm -----
                            443 ; 2994 "source\vec_rum_fct_pjc.c" 1
   02D9 EE 64         [ 6]  444 	ldu 4,s
   02DB BD F6 90      [ 8]  445 	jsr ___Init_Music_a; BIOS call
                            446 ;--- end asm ---
   02DE 35 C0         [ 7]  447 	puls	u,pc
                            448 	.globl	__Init_Music_x
   02E0                     449 __Init_Music_x:
   02E0 34 60         [ 7]  450 	pshs	y,u
                            451 ;----- asm -----
                            452 ; 3027 "source\vec_rum_fct_pjc.c" 1
   02E2 1F 13         [ 6]  453 	tfr x,u
   02E4 BD F6 92      [ 8]  454 	jsr ___Init_Music_x; BIOS call
                            455 ;--- end asm ---
   02E7 35 E0         [ 8]  456 	puls	y,u,pc
                            457 	.globl	__Explosion_Snd
   02E9                     458 __Explosion_Snd:
   02E9 34 40         [ 6]  459 	pshs	u
                            460 ;----- asm -----
                            461 ; 3086 "source\vec_rum_fct_pjc.c" 1
   02EB 1F 13         [ 6]  462 	tfr x,u
   02ED BD F9 2E      [ 8]  463 	jsr ___Explosion_Snd; BIOS call
                            464 ;--- end asm ---
   02F0 35 C0         [ 7]  465 	puls	u,pc
                            466 	.globl	__Moveto_d_7F
   02F2                     467 __Moveto_d_7F:
                            468 ;----- asm -----
                            469 ; 3188 "source\vec_rum_fct_pjc.c" 1
   02F2 A6 62         [ 5]  470 	lda 2,s
   02F4 7E F2 FC      [ 4]  471 	jmp ___Moveto_d_7F; BIOS call
                            472 ;--- end asm ---
                            473 	.globl	__Moveto_dd_7F
   02F7                     474 __Moveto_dd_7F:
                            475 ;----- asm -----
                            476 ; 3197 "source\vec_rum_fct_pjc.c" 1
   02F7 1F 10         [ 6]  477 	tfr x,d
   02F9 7E F2 FC      [ 4]  478 	jmp ___Moveto_d_7F; BIOS call
                            479 ;--- end asm ---
                            480 	.globl	__Moveto_d
   02FC                     481 __Moveto_d:
                            482 ;----- asm -----
                            483 ; 3315 "source\vec_rum_fct_pjc.c" 1
   02FC A6 62         [ 5]  484 	lda 2,s
   02FE 7E F3 12      [ 4]  485 	jmp ___Moveto_d; BIOS call
                            486 ;--- end asm ---
                            487 	.globl	__Moveto_dd
   0301                     488 __Moveto_dd:
                            489 ;----- asm -----
                            490 ; 3324 "source\vec_rum_fct_pjc.c" 1
   0301 1F 10         [ 6]  491 	tfr x,d
   0303 7E F3 12      [ 4]  492 	jmp ___Moveto_d; BIOS call
                            493 ;--- end asm ---
                            494 	.globl	__Intensity_a
   0306                     495 __Intensity_a:
                            496 ;----- asm -----
                            497 ; 3434 "source\vec_rum_fct_pjc.c" 1
   0306 1F 98         [ 6]  498 	tfr b,a
   0308 7E F2 AB      [ 4]  499 	jmp ___Intensity_a; BIOS call
                            500 ;--- end asm ---
                            501 	.globl	__Obj_Will_Hit_u
   030B                     502 __Obj_Will_Hit_u:
   030B 34 60         [ 7]  503 	pshs	y,u
                            504 ;----- asm -----
                            505 ; 3461 "source\vec_rum_fct_pjc.c" 1
   030D A6 66         [ 5]  506 	lda 6,s
   030F 10 AE 67      [ 7]  507 	ldy 7,s
   0312 EE 69         [ 6]  508 	ldu 9,s
   0314 BD F8 E5      [ 8]  509 	jsr ___Obj_Will_Hit_u; BIOS call
   0317 C6 00         [ 2]  510 	ldb #0
   0319 C9 00         [ 2]  511 	adcb #0
                            512 ;--- end asm ---
   031B 35 E0         [ 8]  513 	puls	y,u,pc
                            514 	.globl	__Obj_Will_Hit
   031D                     515 __Obj_Will_Hit:
   031D 34 60         [ 7]  516 	pshs	y,u
                            517 ;----- asm -----
                            518 ; 3486 "source\vec_rum_fct_pjc.c" 1
   031F A6 66         [ 5]  519 	lda 6,s
   0321 10 AE 67      [ 7]  520 	ldy 7,s
   0324 EE 69         [ 6]  521 	ldu 9,s
   0326 BD F8 F3      [ 8]  522 	jsr ___Obj_Will_Hit; BIOS call
   0329 C6 00         [ 2]  523 	ldb #0
   032B C9 00         [ 2]  524 	adcb #0
                            525 ;--- end asm ---
   032D 35 E0         [ 8]  526 	puls	y,u,pc
                            527 	.globl	__Obj_Hit
   032F                     528 __Obj_Hit:
   032F 34 20         [ 6]  529 	pshs	y
                            530 ;----- asm -----
                            531 ; 3510 "source\vec_rum_fct_pjc.c" 1
   0331 A6 64         [ 5]  532 	lda 4,s
   0333 10 AE 65      [ 7]  533 	ldy 5,s
   0336 BD F8 FF      [ 8]  534 	jsr ___Obj_Hit; BIOS call
   0339 C6 00         [ 2]  535 	ldb #0
   033B C9 00         [ 2]  536 	adcb #0
                            537 ;--- end asm ---
   033D 35 A0         [ 7]  538 	puls	y,pc
                            539 	.globl	__Rise_Run_X
   033F                     540 __Rise_Run_X:
                            541 ;----- asm -----
                            542 ; 3545 "source\vec_rum_fct_pjc.c" 1
   033F A6 62         [ 5]  543 	lda 2,s
   0341 BD F5 FF      [ 8]  544 	jsr ___Rise_Run_X; BIOS call
   0344 1F 01         [ 6]  545 	tfr d,x
                            546 ;--- end asm ---
   0346 39            [ 5]  547 	rts
                            548 	.globl	__Rise_Run_Y
   0347                     549 __Rise_Run_Y:
                            550 ;----- asm -----
                            551 ; 3566 "source\vec_rum_fct_pjc.c" 1
   0347 A6 62         [ 5]  552 	lda 2,s
   0349 BD F6 01      [ 8]  553 	jsr ___Rise_Run_Y; BIOS call
   034C 1F 01         [ 6]  554 	tfr d,x
                            555 ;--- end asm ---
   034E 39            [ 5]  556 	rts
                            557 	.globl	__Rise_Run_Len
   034F                     558 __Rise_Run_Len:
                            559 ;----- asm -----
                            560 ; 3587 "source\vec_rum_fct_pjc.c" 1
   034F 1F 98         [ 6]  561 	tfr b,a
   0351 BD F6 03      [ 8]  562 	jsr ___Rise_Run_Len; BIOS call
   0354 1F 01         [ 6]  563 	tfr d,x
                            564 ;--- end asm ---
   0356 39            [ 5]  565 	rts
                            566 	.globl	__Rot_VL_ab
   0357                     567 __Rot_VL_ab:
   0357 34 40         [ 6]  568 	pshs	u
                            569 ;----- asm -----
                            570 ; 3616 "source\vec_rum_fct_pjc.c" 1
   0359 A6 64         [ 5]  571 	lda 4,s
   035B EE 65         [ 6]  572 	ldu 5,s
   035D BD F6 10      [ 8]  573 	jsr ___Rot_VL_ab; BIOS call
                            574 ;--- end asm ---
   0360 35 C0         [ 7]  575 	puls	u,pc
                            576 	.globl	__Rot_VL_Diff
   0362                     577 __Rot_VL_Diff:
   0362 34 40         [ 6]  578 	pshs	u
                            579 ;----- asm -----
                            580 ; 3643 "source\vec_rum_fct_pjc.c" 1
   0364 EE 64         [ 6]  581 	ldu 4,s
   0366 BD F6 13      [ 8]  582 	jsr ___Rot_VL_Diff; BIOS call
                            583 ;--- end asm ---
   0369 35 C0         [ 7]  584 	puls	u,pc
                            585 	.globl	__Rot_VL
   036B                     586 __Rot_VL:
   036B 34 40         [ 6]  587 	pshs	u
                            588 ;----- asm -----
                            589 ; 3670 "source\vec_rum_fct_pjc.c" 1
   036D EE 64         [ 6]  590 	ldu 4,s
   036F BD F6 16      [ 8]  591 	jsr ___Rot_VL; BIOS call
                            592 ;--- end asm ---
   0372 35 C0         [ 7]  593 	puls	u,pc
                            594 	.globl	__Dot_y
   0374                     595 __Dot_y:
   0374 34 20         [ 6]  596 	pshs	y
                            597 ;----- asm -----
                            598 ; 3729 "source\vec_rum_fct_pjc.c" 1
   0376 1F 12         [ 6]  599 	tfr x,y
   0378 BD EA 5D      [ 8]  600 	jsr ___Dot_y; BIOS call
                            601 ;--- end asm ---
   037B 35 A0         [ 7]  602 	puls	y,pc
                            603 	.globl	__Dot_py
   037D                     604 __Dot_py:
   037D 34 20         [ 6]  605 	pshs	y
                            606 ;----- asm -----
                            607 ; 3747 "source\vec_rum_fct_pjc.c" 1
   037F 1F 12         [ 6]  608 	tfr x,y
   0381 BD EA 6D      [ 8]  609 	jsr ___Dot_py; BIOS call
                            610 ;--- end asm ---
   0384 35 A0         [ 7]  611 	puls	y,pc
                            612 	.globl	__Draw_Pack
   0386                     613 __Draw_Pack:
   0386 34 20         [ 6]  614 	pshs	y
                            615 ;----- asm -----
                            616 ; 3776 "source\vec_rum_fct_pjc.c" 1
   0388 10 AE 64      [ 7]  617 	ldy 4,s
   038B BD EA 7F      [ 8]  618 	jsr ___Draw_Pack; BIOS call
                            619 ;--- end asm ---
   038E 35 A0         [ 7]  620 	puls	y,pc
                            621 	.globl	__Draw_Pack_py
   0390                     622 __Draw_Pack_py:
   0390 34 20         [ 6]  623 	pshs	y
                            624 ;----- asm -----
                            625 ; 3803 "source\vec_rum_fct_pjc.c" 1
   0392 10 AE 64      [ 7]  626 	ldy 4,s
   0395 BD EA 8D      [ 8]  627 	jsr ___Draw_Pack_py; BIOS call
                            628 ;--- end asm ---
   0398 35 A0         [ 7]  629 	puls	y,pc
                            630 	.globl	__Print_Msg
   039A                     631 __Print_Msg:
   039A 34 60         [ 7]  632 	pshs	y,u
                            633 ;----- asm -----
                            634 ; 3825 "source\vec_rum_fct_pjc.c" 1
   039C 1F 12         [ 6]  635 	tfr x,y
   039E EE 66         [ 6]  636 	ldu 6,s
   03A0 BD EA A8      [ 8]  637 	jsr ___Print_Msg; BIOS call
                            638 ;--- end asm ---
   03A3 35 E0         [ 8]  639 	puls	y,u,pc
                            640 	.globl	__Displ8_xy
   03A5                     641 __Displ8_xy:
   03A5 34 20         [ 6]  642 	pshs	y
                            643 ;----- asm -----
                            644 ; 3863 "source\vec_rum_fct_pjc.c" 1
   03A7 A6 64         [ 5]  645 	lda 4,s
   03A9 BD E7 B5      [ 8]  646 	jsr ___Displ8_xy; BIOS call
                            647 ;--- end asm ---
   03AC 35 A0         [ 7]  648 	puls	y,pc
                            649 	.globl	__Displ16_xy
   03AE                     650 __Displ16_xy:
   03AE 34 20         [ 6]  651 	pshs	y
                            652 ;----- asm -----
                            653 ; 3884 "source\vec_rum_fct_pjc.c" 1
   03B0 A6 64         [ 5]  654 	lda 4,s
   03B2 BD E7 D2      [ 8]  655 	jsr ___Displ16_xy; BIOS call
                            656 ;--- end asm ---
   03B5 35 A0         [ 7]  657 	puls	y,pc
                            658 	.globl	__Ranpos
   03B7                     659 __Ranpos:
                            660 ;----- asm -----
                            661 ; 3904 "source\vec_rum_fct_pjc.c" 1
   03B7 BD EA 5D      [ 8]  662 	jsr ___Dot_y; BIOS call
   03BA 1F 01         [ 6]  663 	tfr d,x
                            664 ;--- end asm ---
   03BC 39            [ 5]  665 	rts
                            666 	.globl	__Draw_Scores
   03BD                     667 __Draw_Scores:
   03BD 34 60         [ 7]  668 	pshs	y,u
                            669 ;----- asm -----
                            670 ; 3935 "source\vec_rum_fct_pjc.c" 1
   03BF BD EA CF      [ 8]  671 	jsr ___Draw_Scores; BIOS call
                            672 ;--- end asm ---
   03C2 35 E0         [ 8]  673 	puls	y,u,pc
                            674 	.globl	__Draw_Score
   03C4                     675 __Draw_Score:
   03C4 34 60         [ 7]  676 	pshs	y,u
                            677 ;----- asm -----
                            678 ; 3964 "source\vec_rum_fct_pjc.c" 1
   03C6 BD EA B4      [ 8]  679 	jsr ___Draw_Score; BIOS call
                            680 ;--- end asm ---
   03C9 35 E0         [ 8]  681 	puls	y,u,pc
                            682 	.globl	__Wait_Bound
   03CB                     683 __Wait_Bound:
   03CB 34 60         [ 7]  684 	pshs	y,u
                            685 ;----- asm -----
                            686 ; 3991 "source\vec_rum_fct_pjc.c" 1
   03CD BD EA F0      [ 8]  687 	jsr ___Wait_Bound; BIOS call
                            688 ;--- end asm ---
   03D0 35 E0         [ 8]  689 	puls	y,u,pc
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 __Abs_a_b          00C0 GR  |   2 __Add_Score_a      012B GR
  2 __Add_Score_d      0134 GR  |   2 __Bitmask_a        00B8 GR
  2 __Clear_x_b_a      010D GR  |   2 __Clear_x_d        00F2 GR
  2 __Compare_Scor     0139 GR  |   2 __Displ16_xy       0259 GR
  2 __Displ8_xy        0250 GR  |   2 __Display_Opti     0120 GR
  2 __Do_Sound         0169 GR  |   2 __Dot_d            0000 GR
  2 __Dot_dd           0005 GR  |   2 __Dot_py           0228 GR
  2 __Dot_y            021F GR  |   2 __Draw_Line_d      0071 GR
  2 __Draw_Pack        0231 GR  |   2 __Draw_Pack_py     023B GR
  2 __Draw_Pat_VL_     006C GR  |   2 __Draw_Pat_VL_     0067 GR
  2 __Draw_Score       026F GR  |   2 __Draw_Scores      0268 GR
  2 __Draw_VL_a        007B GR  |   2 __Draw_VL_ab       0076 GR
  2 __Explosion_Sn     0194 GR  |   2 __Get_Rise_Run     00D0 GR
  2 __Init_Music       0179 GR  |   2 __Init_Music_a     0182 GR
  2 __Init_Music_c     0170 GR  |   2 __Init_Music_x     018B GR
  2 __Intensity_a      01B1 GR  |   2 __Mov_Draw_VL_     0085 GR
  2 __Mov_Draw_VL_     0080 GR  |   2 __Mov_Draw_VL_     008A GR
  2 __Move_Mem_a       0102 GR  |   2 __Move_Mem_a_1     00F7 GR
  2 __Moveto_d         01A7 GR  |   2 __Moveto_d_7F      019D GR
  2 __Moveto_dd        01AC GR  |   2 __Moveto_dd_7F     01A2 GR
  2 __New_High_Sco     0144 GR  |   2 __Obj_Hit          01DA GR
  2 __Obj_Will_Hit     01C8 GR  |   2 __Obj_Will_Hit     01B6 GR
  2 __Print_List       003B GR  |   2 __Print_List_c     0044 GR
  2 __Print_List_h     0032 GR  |   2 __Print_MRast      0060 GR
  2 __Print_Msg        0245 GR  |   2 __Print_Ships      0052 GR
  2 __Print_Ships_     004D GR  |   2 __Print_Str        0057 GR
  2 __Print_Str_d      001C GR  |   2 __Print_Str_dd     0027 GR
  2 __Print_Str_hw     000A GR  |   2 __Print_Str_yx     0013 GR
  2 __Random           00B2 GR  |   2 __Random_3         00AC GR
  2 __Ranpos           0262 GR  |   2 __Read_Btns_Ma     0112 GR
  2 __Rise_Run_Len     01FA GR  |   2 __Rise_Run_X       01EA GR
  2 __Rise_Run_Y       01F2 GR  |   2 __Rot_VL           0216 GR
  2 __Rot_VL_Diff      020D GR  |   2 __Rot_VL_M_dft     00A3 GR
  2 __Rot_VL_Mode      008F GR  |   2 __Rot_VL_Pack      009A GR
  2 __Rot_VL_ab        0202 GR  |   2 __Select_Game      0117 GR
  2 __Sound_Byte       014D GR  |   2 __Sound_Byte_x     0152 GR
  2 __Sound_Bytes      0157 GR  |   2 __Sound_Bytes_     0160 GR
  2 __Wait_Bound       0276 GR  |   2 __Xform_Rise       00EC GR
  2 __Xform_Rise_a     00E4 GR  |   2 __Xform_Run        00DE GR
  2 __Xform_Run_a      00D6 GR  |   2 __Xform_Sin        00C8 GR
    ___Abs_a_b         **** GX  |     ___Add_Score_a     **** GX
    ___Add_Score_d     **** GX  |     ___Bitmask_a       **** GX
    ___Clear_x_b_a     **** GX  |     ___Clear_x_d       **** GX
    ___Compare_Sco     **** GX  |     ___Displ16_xy      **** GX
    ___Displ8_xy       **** GX  |     ___Display_Opt     **** GX
    ___Do_Sound        **** GX  |     ___Dot_d           **** GX
    ___Dot_py          **** GX  |     ___Dot_y           **** GX
    ___Draw_Line_d     **** GX  |     ___Draw_Pack       **** GX
    ___Draw_Pack_p     **** GX  |     ___Draw_Pat_VL     **** GX
    ___Draw_Pat_VL     **** GX  |     ___Draw_Score      **** GX
    ___Draw_Scores     **** GX  |     ___Draw_VL_a       **** GX
    ___Draw_VL_ab      **** GX  |     ___Explosion_S     **** GX
    ___Get_Rise_Ru     **** GX  |     ___Init_Music      **** GX
    ___Init_Music_     **** GX  |     ___Init_Music_     **** GX
    ___Init_Music_     **** GX  |     ___Intensity_a     **** GX
    ___Mov_Draw_VL     **** GX  |     ___Mov_Draw_VL     **** GX
    ___Mov_Draw_VL     **** GX  |     ___Move_Mem_a_     **** GX
    ___Moveto_d        **** GX  |     ___Moveto_d_7F     **** GX
    ___New_High_Sc     **** GX  |     ___Obj_Hit         **** GX
    ___Obj_Will_Hi     **** GX  |     ___Obj_Will_Hi     **** GX
    ___Print_List      **** GX  |     ___Print_List_     **** GX
    ___Print_List_     **** GX  |     ___Print_MRast     **** GX
    ___Print_Msg       **** GX  |     ___Print_Ships     **** GX
    ___Print_Ships     **** GX  |     ___Print_Str       **** GX
    ___Print_Str_d     **** GX  |     ___Print_Str_h     **** GX
    ___Print_Str_y     **** GX  |     ___Random          **** GX
    ___Random_3        **** GX  |     ___Read_Btns_M     **** GX
    ___Rise_Run_Le     **** GX  |     ___Rise_Run_X      **** GX
    ___Rise_Run_Y      **** GX  |     ___Rot_VL          **** GX
    ___Rot_VL_Diff     **** GX  |     ___Rot_VL_M_df     **** GX
    ___Rot_VL_Mode     **** GX  |     ___Rot_VL_Pack     **** GX
    ___Rot_VL_ab       **** GX  |     ___Select_Game     **** GX
    ___Sound_Byte      **** GX  |     ___Sound_Byte_     **** GX
    ___Sound_Bytes     **** GX  |     ___Sound_Bytes     **** GX
    ___Wait_Bound      **** GX  |     ___Xform_Rise      **** GX
    ___Xform_Rise_     **** GX  |     ___Xform_Run       **** GX
    ___Xform_Run_a     **** GX  |     ___Xform_Sin       **** GX

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
   2 .text            size  27D   flags  100
[_DSEG]
   1 _DATA            size    0   flags C0C0

