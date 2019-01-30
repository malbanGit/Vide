                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rum_fct_pjc.c
                              7 	.area .text
                              8 	.globl __Dot_d
   0154                       9 __Dot_d:
                             10 ;----- asm -----
                             11 ;  533 "source\vec_rum_fct_pjc.c" 1
   0154 A6 62         [ 5]   12 	lda 2,s
   0156 7E F2 C3      [ 4]   13 	jmp ___Dot_d; BIOS call
                             14 ;  0 "" 2
                             15 ;--- end asm ---
                             16 	.globl __Dot_dd
   0159                      17 __Dot_dd:
                             18 ;----- asm -----
                             19 ;  542 "source\vec_rum_fct_pjc.c" 1
   0159 1F 10         [ 6]   20 	tfr x,d
   015B 7E F2 C3      [ 4]   21 	jmp ___Dot_d; BIOS call
                             22 ;  0 "" 2
                             23 ;--- end asm ---
                             24 	.globl __Print_Str_hwyx
   015E                      25 __Print_Str_hwyx:
   015E 34 40         [ 6]   26 	pshs	u
                             27 ;----- asm -----
                             28 ;  657 "source\vec_rum_fct_pjc.c" 1
   0160 1F 13         [ 6]   29 	tfr x,u
   0162 BD F3 73      [ 8]   30 	jsr ___Print_Str_hwyx; BIOS call
                             31 ;  0 "" 2
                             32 ;--- end asm ---
   0165 35 C0         [ 7]   33 	puls	u,pc
                             34 	.globl __Print_Str_yx
   0167                      35 __Print_Str_yx:
   0167 34 40         [ 6]   36 	pshs	u
                             37 ;----- asm -----
                             38 ;  682 "source\vec_rum_fct_pjc.c" 1
   0169 1F 13         [ 6]   39 	tfr x,u
   016B BD F3 78      [ 8]   40 	jsr ___Print_Str_yx; BIOS call
                             41 ;  0 "" 2
                             42 ;--- end asm ---
   016E 35 C0         [ 7]   43 	puls	u,pc
                             44 	.globl __Print_Str_d
   0170                      45 __Print_Str_d:
   0170 34 40         [ 6]   46 	pshs	u
                             47 ;----- asm -----
                             48 ;  708 "source\vec_rum_fct_pjc.c" 1
   0172 A6 64         [ 5]   49 	lda 4,s
   0174 1F 13         [ 6]   50 	tfr x,u
   0176 BD F3 7A      [ 8]   51 	jsr ___Print_Str_d; BIOS call
                             52 ;  0 "" 2
                             53 ;--- end asm ---
   0179 35 C0         [ 7]   54 	puls	u,pc
                             55 	.globl __Print_Str_dd
   017B                      56 __Print_Str_dd:
   017B 34 40         [ 6]   57 	pshs	u
                             58 ;----- asm -----
                             59 ;  718 "source\vec_rum_fct_pjc.c" 1
   017D 1F 10         [ 6]   60 	tfr x,d
   017F EE 64         [ 6]   61 	ldu 4,s
   0181 BD F3 7A      [ 8]   62 	jsr ___Print_Str_d; BIOS call
                             63 ;  0 "" 2
                             64 ;--- end asm ---
   0184 35 C0         [ 7]   65 	puls	u,pc
                             66 	.globl __Print_List_hw
   0186                      67 __Print_List_hw:
   0186 34 40         [ 6]   68 	pshs	u
                             69 ;----- asm -----
                             70 ;  746 "source\vec_rum_fct_pjc.c" 1
   0188 1F 13         [ 6]   71 	tfr x,u
   018A BD F3 85      [ 8]   72 	jsr ___Print_List_hw; BIOS call
                             73 ;  0 "" 2
                             74 ;--- end asm ---
   018D 35 C0         [ 7]   75 	puls	u,pc
                             76 	.globl __Print_List
   018F                      77 __Print_List:
   018F 34 40         [ 6]   78 	pshs	u
                             79 ;----- asm -----
                             80 ;  773 "source\vec_rum_fct_pjc.c" 1
   0191 1F 13         [ 6]   81 	tfr x,u
   0193 BD F3 8A      [ 8]   82 	jsr ___Print_List; BIOS call
                             83 ;  0 "" 2
                             84 ;--- end asm ---
   0196 35 C0         [ 7]   85 	puls	u,pc
                             86 	.globl __Print_List_chk
   0198                      87 __Print_List_chk:
   0198 34 40         [ 6]   88 	pshs	u
                             89 ;----- asm -----
                             90 ;  800 "source\vec_rum_fct_pjc.c" 1
   019A 1F 13         [ 6]   91 	tfr x,u
   019C BD F3 8C      [ 8]   92 	jsr ___Print_List_chk; BIOS call
                             93 ;  0 "" 2
                             94 ;--- end asm ---
   019F 35 C0         [ 7]   95 	puls	u,pc
                             96 	.globl __Print_Ships_x
   01A1                      97 __Print_Ships_x:
                             98 ;----- asm -----
                             99 ;  825 "source\vec_rum_fct_pjc.c" 1
   01A1 A6 62         [ 5]  100 	lda 2,s
   01A3 7E F3 91      [ 4]  101 	jmp ___Print_Ships_x; BIOS call
                            102 ;  0 "" 2
                            103 ;--- end asm ---
                            104 	.globl __Print_Ships
   01A6                     105 __Print_Ships:
                            106 ;----- asm -----
                            107 ;  850 "source\vec_rum_fct_pjc.c" 1
   01A6 A6 62         [ 5]  108 	lda 2,s
   01A8 7E F3 93      [ 4]  109 	jmp ___Print_Ships; BIOS call
                            110 ;  0 "" 2
                            111 ;--- end asm ---
                            112 	.globl __Print_Str
   01AB                     113 __Print_Str:
   01AB 34 40         [ 6]  114 	pshs	u
                            115 ;----- asm -----
                            116 ;  874 "source\vec_rum_fct_pjc.c" 1
   01AD 1F 13         [ 6]  117 	tfr x,u
   01AF BD F4 95      [ 8]  118 	jsr ___Print_Str; BIOS call
                            119 ;  0 "" 2
                            120 ;--- end asm ---
   01B2 35 C0         [ 7]  121 	puls	u,pc
                            122 	.globl __Print_MRast
   01B4                     123 __Print_MRast:
   01B4 34 40         [ 6]  124 	pshs	u
                            125 ;----- asm -----
                            126 ;  898 "source\vec_rum_fct_pjc.c" 1
   01B6 BD F4 98      [ 8]  127 	jsr ___Print_MRast; BIOS call
                            128 ;  0 "" 2
                            129 ;--- end asm ---
   01B9 35 C0         [ 7]  130 	puls	u,pc
                            131 	.globl __Draw_Pat_VL_aa
   01BB                     132 __Draw_Pat_VL_aa:
                            133 ;----- asm -----
                            134 ;  964 "source\vec_rum_fct_pjc.c" 1
   01BB 1F 98         [ 6]  135 	tfr b,a
   01BD 7E F4 33      [ 4]  136 	jmp ___Draw_Pat_VL_aa; BIOS call
                            137 ;  0 "" 2
                            138 ;--- end asm ---
                            139 	.globl __Draw_Pat_VL_a
   01C0                     140 __Draw_Pat_VL_a:
                            141 ;----- asm -----
                            142 ;  995 "source\vec_rum_fct_pjc.c" 1
   01C0 1F 98         [ 6]  143 	tfr b,a
   01C2 7E F4 34      [ 4]  144 	jmp ___Draw_Pat_VL_a; BIOS call
                            145 ;  0 "" 2
                            146 ;--- end asm ---
                            147 	.globl __Draw_Line_d
   01C5                     148 __Draw_Line_d:
                            149 ;----- asm -----
                            150 ;  1063 "source\vec_rum_fct_pjc.c" 1
   01C5 A6 62         [ 5]  151 	lda 2,s
   01C7 7E F3 DF      [ 4]  152 	jmp ___Draw_Line_d; BIOS call
                            153 ;  0 "" 2
                            154 ;--- end asm ---
                            155 	.globl __Draw_VL_ab
   01CA                     156 __Draw_VL_ab:
                            157 ;----- asm -----
                            158 ;  1120 "source\vec_rum_fct_pjc.c" 1
   01CA A6 62         [ 5]  159 	lda 2,s
   01CC 7E F3 D8      [ 4]  160 	jmp ___Draw_VL_ab; BIOS call
                            161 ;  0 "" 2
                            162 ;--- end asm ---
                            163 	.globl __Draw_VL_a
   01CF                     164 __Draw_VL_a:
                            165 ;----- asm -----
                            166 ;  1235 "source\vec_rum_fct_pjc.c" 1
   01CF 1F 98         [ 6]  167 	tfr b,a
   01D1 7E F3 DA      [ 4]  168 	jmp ___Draw_VL_a; BIOS call
                            169 ;  0 "" 2
                            170 ;--- end asm ---
                            171 	.globl __Mov_Draw_VL_ab
   01D4                     172 __Mov_Draw_VL_ab:
                            173 ;----- asm -----
                            174 ;  1365 "source\vec_rum_fct_pjc.c" 1
   01D4 A6 62         [ 5]  175 	lda 2,s
   01D6 7E F3 B7      [ 4]  176 	jmp ___Mov_Draw_VL_ab; BIOS call
                            177 ;  0 "" 2
                            178 ;--- end asm ---
                            179 	.globl __Mov_Draw_VL_a
   01D9                     180 __Mov_Draw_VL_a:
                            181 ;----- asm -----
                            182 ;  1393 "source\vec_rum_fct_pjc.c" 1
   01D9 1F 98         [ 6]  183 	tfr b,a
   01DB 7E F3 B9      [ 4]  184 	jmp ___Mov_Draw_VL_a; BIOS call
                            185 ;  0 "" 2
                            186 ;--- end asm ---
                            187 	.globl __Mov_Draw_VL_d
   01DE                     188 __Mov_Draw_VL_d:
                            189 ;----- asm -----
                            190 ;  1447 "source\vec_rum_fct_pjc.c" 1
   01DE A6 62         [ 5]  191 	lda 2,s
   01E0 7E F3 BE      [ 4]  192 	jmp ___Mov_Draw_VL_d; BIOS call
                            193 ;  0 "" 2
                            194 ;--- end asm ---
                            195 	.globl __Rot_VL_Mode
   01E3                     196 __Rot_VL_Mode:
   01E3 34 40         [ 6]  197 	pshs	u
                            198 ;----- asm -----
                            199 ;  1694 "source\vec_rum_fct_pjc.c" 1
   01E5 1F 98         [ 6]  200 	tfr b,a
   01E7 EE 64         [ 6]  201 	ldu 4,s
   01E9 BD F6 1F      [ 8]  202 	jsr ___Rot_VL_Mode; BIOS call
                            203 ;  0 "" 2
                            204 ;--- end asm ---
   01EC 35 C0         [ 7]  205 	puls	u,pc
                            206 	.globl __Rot_VL_Pack
   01EE                     207 __Rot_VL_Pack:
   01EE 34 40         [ 6]  208 	pshs	u
                            209 ;----- asm -----
                            210 ;  1722 "source\vec_rum_fct_pjc.c" 1
   01F0 EE 64         [ 6]  211 	ldu 4,s
   01F2 BD F6 22      [ 8]  212 	jsr ___Rot_VL_Pack; BIOS call
                            213 ;  0 "" 2
                            214 ;--- end asm ---
   01F5 35 C0         [ 7]  215 	puls	u,pc
                            216 	.globl __Rot_VL_M_dft
   01F7                     217 __Rot_VL_M_dft:
   01F7 34 40         [ 6]  218 	pshs	u
                            219 ;----- asm -----
                            220 ;  1749 "source\vec_rum_fct_pjc.c" 1
   01F9 EE 64         [ 6]  221 	ldu 4,s
   01FB BD F6 2B      [ 8]  222 	jsr ___Rot_VL_M_dft; BIOS call
                            223 ;  0 "" 2
                            224 ;--- end asm ---
   01FE 35 C0         [ 7]  225 	puls	u,pc
                            226 	.globl __Random_3
   0200                     227 __Random_3:
                            228 ;----- asm -----
                            229 ;  1803 "source\vec_rum_fct_pjc.c" 1
   0200 BD F5 11      [ 8]  230 	jsr ___Random_3; BIOS call
   0203 1F 89         [ 6]  231 	tfr a,b
                            232 ;  0 "" 2
                            233 ;--- end asm ---
   0205 39            [ 5]  234 	rts
                            235 	.globl __Random
   0206                     236 __Random:
                            237 ;----- asm -----
                            238 ;  1821 "source\vec_rum_fct_pjc.c" 1
   0206 BD F5 17      [ 8]  239 	jsr ___Random; BIOS call
   0209 1F 89         [ 6]  240 	tfr a,b
                            241 ;  0 "" 2
                            242 ;--- end asm ---
   020B 39            [ 5]  243 	rts
                            244 	.globl __Bitmask_a
   020C                     245 __Bitmask_a:
                            246 ;----- asm -----
                            247 ;  1848 "source\vec_rum_fct_pjc.c" 1
   020C 1F 98         [ 6]  248 	tfr b,a
   020E BD F5 7E      [ 8]  249 	jsr ___Bitmask_a; BIOS call
   0211 1F 89         [ 6]  250 	tfr a,b
                            251 ;  0 "" 2
                            252 ;--- end asm ---
   0213 39            [ 5]  253 	rts
                            254 	.globl __Abs_a_b
   0214                     255 __Abs_a_b:
                            256 ;----- asm -----
                            257 ;  1870 "source\vec_rum_fct_pjc.c" 1
   0214 A6 62         [ 5]  258 	lda 2,s
   0216 BD F5 84      [ 8]  259 	jsr ___Abs_a_b; BIOS call
   0219 1F 01         [ 6]  260 	tfr d,x
                            261 ;  0 "" 2
                            262 ;--- end asm ---
   021B 39            [ 5]  263 	rts
                            264 	.globl __Xform_Sin
   021C                     265 __Xform_Sin:
                            266 ;----- asm -----
                            267 ;  1955 "source\vec_rum_fct_pjc.c" 1
   021C 1F 98         [ 6]  268 	tfr b,a
   021E BD F5 DB      [ 8]  269 	jsr ___Xform_Sin; BIOS call
   0221 1F 89         [ 6]  270 	tfr a,b
                            271 ;  0 "" 2
                            272 ;--- end asm ---
   0223 39            [ 5]  273 	rts
                            274 	.globl __Get_Rise_Run
   0224                     275 __Get_Rise_Run:
                            276 ;----- asm -----
                            277 ;  1976 "source\vec_rum_fct_pjc.c" 1
   0224 BD F5 EF      [ 8]  278 	jsr ___Get_Rise_Run; BIOS call
   0227 1F 01         [ 6]  279 	tfr d,x
                            280 ;  0 "" 2
                            281 ;--- end asm ---
   0229 39            [ 5]  282 	rts
                            283 	.globl __Xform_Run_a
   022A                     284 __Xform_Run_a:
                            285 ;----- asm -----
                            286 ;  1997 "source\vec_rum_fct_pjc.c" 1
   022A 1F 98         [ 6]  287 	tfr b,a
   022C BD F6 5B      [ 8]  288 	jsr ___Xform_Run_a; BIOS call
   022F 1F 01         [ 6]  289 	tfr d,x
                            290 ;  0 "" 2
                            291 ;--- end asm ---
   0231 39            [ 5]  292 	rts
                            293 	.globl __Xform_Run
   0232                     294 __Xform_Run:
                            295 ;----- asm -----
                            296 ;  2018 "source\vec_rum_fct_pjc.c" 1
   0232 BD F6 5D      [ 8]  297 	jsr ___Xform_Run; BIOS call
   0235 1F 89         [ 6]  298 	tfr a,b
                            299 ;  0 "" 2
                            300 ;--- end asm ---
   0237 39            [ 5]  301 	rts
                            302 	.globl __Xform_Rise_a
   0238                     303 __Xform_Rise_a:
                            304 ;----- asm -----
                            305 ;  2039 "source\vec_rum_fct_pjc.c" 1
   0238 1F 98         [ 6]  306 	tfr b,a
   023A BD F6 61      [ 8]  307 	jsr ___Xform_Rise_a; BIOS call
   023D 1F 89         [ 6]  308 	tfr a,b
                            309 ;  0 "" 2
                            310 ;--- end asm ---
   023F 39            [ 5]  311 	rts
                            312 	.globl __Xform_Rise
   0240                     313 __Xform_Rise:
                            314 ;----- asm -----
                            315 ;  2060 "source\vec_rum_fct_pjc.c" 1
   0240 BD F6 63      [ 8]  316 	jsr ___Xform_Rise; BIOS call
   0243 1F 89         [ 6]  317 	tfr a,b
                            318 ;  0 "" 2
                            319 ;--- end asm ---
   0245 39            [ 5]  320 	rts
                            321 	.globl __Clear_x_d
   0246                     322 __Clear_x_d:
                            323 ;----- asm -----
                            324 ;  2143 "source\vec_rum_fct_pjc.c" 1
   0246 EC 62         [ 6]  325 	ldd 2,s
   0248 7E F5 48      [ 4]  326 	jmp ___Clear_x_d; BIOS call
                            327 ;  0 "" 2
                            328 ;--- end asm ---
                            329 	.globl __Move_Mem_a_1
   024B                     330 __Move_Mem_a_1:
   024B 34 40         [ 6]  331 	pshs	u
                            332 ;----- asm -----
                            333 ;  2169 "source\vec_rum_fct_pjc.c" 1
   024D 1F 98         [ 6]  334 	tfr b,a
   024F EE 64         [ 6]  335 	ldu 4,s
   0251 BD F6 7F      [ 8]  336 	jsr ___Move_Mem_a_1; BIOS call
                            337 ;  0 "" 2
                            338 ;--- end asm ---
   0254 35 C0         [ 7]  339 	puls	u,pc
                            340 	.globl __Move_Mem_a
   0256                     341 __Move_Mem_a:
   0256 34 40         [ 6]  342 	pshs	u
                            343 ;----- asm -----
                            344 ;  2190 "source\vec_rum_fct_pjc.c" 1
   0258 1F 98         [ 6]  345 	tfr b,a
   025A EE 64         [ 6]  346 	ldu 4,s
   025C BD F6 7F      [ 8]  347 	jsr ___Move_Mem_a_1; BIOS call
                            348 ;  0 "" 2
                            349 ;--- end asm ---
   025F 35 C0         [ 7]  350 	puls	u,pc
                            351 	.globl __Clear_x_b_a
   0261                     352 __Clear_x_b_a:
                            353 ;----- asm -----
                            354 ;  2236 "source\vec_rum_fct_pjc.c" 1
   0261 A6 62         [ 5]  355 	lda 2,s
   0263 7E F5 52      [ 4]  356 	jmp ___Clear_x_b_a; BIOS call
                            357 ;  0 "" 2
                            358 ;--- end asm ---
                            359 	.globl __Read_Btns_Mask
   0266                     360 __Read_Btns_Mask:
                            361 ;----- asm -----
                            362 ;  2264 "source\vec_rum_fct_pjc.c" 1
   0266 1F 98         [ 6]  363 	tfr b,a
   0268 7E F1 B4      [ 4]  364 	jmp ___Read_Btns_Mask; BIOS call
                            365 ;  0 "" 2
                            366 ;--- end asm ---
                            367 	.globl __Select_Game
   026B                     368 __Select_Game:
   026B 34 60         [ 7]  369 	pshs	y,u
                            370 ;----- asm -----
                            371 ;  2423 "source\vec_rum_fct_pjc.c" 1
   026D A6 66         [ 5]  372 	lda 6,s
   026F BD F7 A9      [ 8]  373 	jsr ___Select_Game; BIOS call
                            374 ;  0 "" 2
                            375 ;--- end asm ---
   0272 35 E0         [ 8]  376 	puls	y,u,pc
                            377 	.globl __Display_Option
   0274                     378 __Display_Option:
   0274 34 60         [ 7]  379 	pshs	y,u
                            380 ;----- asm -----
                            381 ;  2444 "source\vec_rum_fct_pjc.c" 1
   0276 1F 98         [ 6]  382 	tfr b,a
   0278 1F 12         [ 6]  383 	tfr x,y
   027A BD F8 35      [ 8]  384 	jsr ___Display_Option; BIOS call
                            385 ;  0 "" 2
                            386 ;--- end asm ---
   027D 35 E0         [ 8]  387 	puls	y,u,pc
                            388 	.globl __Add_Score_a
   027F                     389 __Add_Score_a:
   027F 34 40         [ 6]  390 	pshs	u
                            391 ;----- asm -----
                            392 ;  2645 "source\vec_rum_fct_pjc.c" 1
   0281 1F 98         [ 6]  393 	tfr b,a
   0283 BD F8 5E      [ 8]  394 	jsr ___Add_Score_a; BIOS call
                            395 ;  0 "" 2
                            396 ;--- end asm ---
   0286 35 C0         [ 7]  397 	puls	u,pc
                            398 	.globl __Add_Score_d
   0288                     399 __Add_Score_d:
                            400 ;----- asm -----
                            401 ;  2672 "source\vec_rum_fct_pjc.c" 1
   0288 EC 62         [ 6]  402 	ldd 2,s
   028A 7E F8 7C      [ 4]  403 	jmp ___Add_Score_d; BIOS call
                            404 ;  0 "" 2
                            405 ;--- end asm ---
                            406 	.globl __Compare_Score
   028D                     407 __Compare_Score:
   028D 34 40         [ 6]  408 	pshs	u
                            409 ;----- asm -----
                            410 ;  2714 "source\vec_rum_fct_pjc.c" 1
   028F EE 64         [ 6]  411 	ldu 4,s
   0291 BD F8 C7      [ 8]  412 	jsr ___Compare_Score; BIOS call
   0294 1F 89         [ 6]  413 	tfr a,b
                            414 ;  0 "" 2
                            415 ;--- end asm ---
   0296 35 C0         [ 7]  416 	puls	u,pc
                            417 	.globl __New_High_Score
   0298                     418 __New_High_Score:
   0298 34 40         [ 6]  419 	pshs	u
                            420 ;----- asm -----
                            421 ;  2744 "source\vec_rum_fct_pjc.c" 1
   029A EE 64         [ 6]  422 	ldu 4,s
   029C BD F8 D8      [ 8]  423 	jsr ___New_High_Score; BIOS call
                            424 ;  0 "" 2
                            425 ;--- end asm ---
   029F 35 C0         [ 7]  426 	puls	u,pc
                            427 	.globl __Sound_Byte
   02A1                     428 __Sound_Byte:
                            429 ;----- asm -----
                            430 ;  2780 "source\vec_rum_fct_pjc.c" 1
   02A1 A6 62         [ 5]  431 	lda 2,s
   02A3 7E F2 56      [ 4]  432 	jmp ___Sound_Byte; BIOS call
                            433 ;  0 "" 2
                            434 ;--- end asm ---
                            435 	.globl __Sound_Byte_x
   02A6                     436 __Sound_Byte_x:
                            437 ;----- asm -----
                            438 ;  2799 "source\vec_rum_fct_pjc.c" 1
   02A6 A6 62         [ 5]  439 	lda 2,s
   02A8 7E F2 59      [ 4]  440 	jmp ___Sound_Byte_x; BIOS call
                            441 ;  0 "" 2
                            442 ;--- end asm ---
                            443 	.globl __Sound_Bytes
   02AB                     444 __Sound_Bytes:
   02AB 34 40         [ 6]  445 	pshs	u
                            446 ;----- asm -----
                            447 ;  2837 "source\vec_rum_fct_pjc.c" 1
   02AD 1F 13         [ 6]  448 	tfr x,u
   02AF BD F2 7D      [ 8]  449 	jsr ___Sound_Bytes; BIOS call
                            450 ;  0 "" 2
                            451 ;--- end asm ---
   02B2 35 C0         [ 7]  452 	puls	u,pc
                            453 	.globl __Sound_Bytes_x
   02B4                     454 __Sound_Bytes_x:
   02B4 34 40         [ 6]  455 	pshs	u
                            456 ;----- asm -----
                            457 ;  2856 "source\vec_rum_fct_pjc.c" 1
   02B6 EE 64         [ 6]  458 	ldu 4,s
   02B8 BD F2 84      [ 8]  459 	jsr ___Sound_Bytes_x; BIOS call
                            460 ;  0 "" 2
                            461 ;--- end asm ---
   02BB 35 C0         [ 7]  462 	puls	u,pc
                            463 	.globl __Do_Sound
   02BD                     464 __Do_Sound:
   02BD 34 40         [ 6]  465 	pshs	u
                            466 ;----- asm -----
                            467 ;  2876 "source\vec_rum_fct_pjc.c" 1
   02BF BD F2 89      [ 8]  468 	jsr ___Do_Sound; BIOS call
                            469 ;  0 "" 2
                            470 ;--- end asm ---
   02C2 35 C0         [ 7]  471 	puls	u,pc
                            472 	.globl __Init_Music_chk
   02C4                     473 __Init_Music_chk:
   02C4 34 60         [ 7]  474 	pshs	y,u
                            475 ;----- asm -----
                            476 ;  2913 "source\vec_rum_fct_pjc.c" 1
   02C6 1F 13         [ 6]  477 	tfr x,u
   02C8 BD F6 87      [ 8]  478 	jsr ___Init_Music_chk; BIOS call
                            479 ;  0 "" 2
                            480 ;--- end asm ---
   02CB 35 E0         [ 8]  481 	puls	y,u,pc
                            482 	.globl __Init_Music
   02CD                     483 __Init_Music:
   02CD 34 40         [ 6]  484 	pshs	u
                            485 ;----- asm -----
                            486 ;  2961 "source\vec_rum_fct_pjc.c" 1
   02CF 1F 13         [ 6]  487 	tfr x,u
   02D1 BD F6 8D      [ 8]  488 	jsr ___Init_Music; BIOS call
                            489 ;  0 "" 2
                            490 ;--- end asm ---
   02D4 35 C0         [ 7]  491 	puls	u,pc
                            492 	.globl __Init_Music_a
   02D6                     493 __Init_Music_a:
   02D6 34 40         [ 6]  494 	pshs	u
                            495 ;----- asm -----
                            496 ;  2994 "source\vec_rum_fct_pjc.c" 1
   02D8 EE 64         [ 6]  497 	ldu 4,s
   02DA BD F6 90      [ 8]  498 	jsr ___Init_Music_a; BIOS call
                            499 ;  0 "" 2
                            500 ;--- end asm ---
   02DD 35 C0         [ 7]  501 	puls	u,pc
                            502 	.globl __Init_Music_x
   02DF                     503 __Init_Music_x:
   02DF 34 60         [ 7]  504 	pshs	y,u
                            505 ;----- asm -----
                            506 ;  3027 "source\vec_rum_fct_pjc.c" 1
   02E1 1F 13         [ 6]  507 	tfr x,u
   02E3 BD F6 92      [ 8]  508 	jsr ___Init_Music_x; BIOS call
                            509 ;  0 "" 2
                            510 ;--- end asm ---
   02E6 35 E0         [ 8]  511 	puls	y,u,pc
                            512 	.globl __Explosion_Snd
   02E8                     513 __Explosion_Snd:
   02E8 34 40         [ 6]  514 	pshs	u
                            515 ;----- asm -----
                            516 ;  3086 "source\vec_rum_fct_pjc.c" 1
   02EA 1F 13         [ 6]  517 	tfr x,u
   02EC BD F9 2E      [ 8]  518 	jsr ___Explosion_Snd; BIOS call
                            519 ;  0 "" 2
                            520 ;--- end asm ---
   02EF 35 C0         [ 7]  521 	puls	u,pc
                            522 	.globl __Moveto_d_7F
   02F1                     523 __Moveto_d_7F:
                            524 ;----- asm -----
                            525 ;  3188 "source\vec_rum_fct_pjc.c" 1
   02F1 A6 62         [ 5]  526 	lda 2,s
   02F3 7E F2 FC      [ 4]  527 	jmp ___Moveto_d_7F; BIOS call
                            528 ;  0 "" 2
                            529 ;--- end asm ---
                            530 	.globl __Moveto_dd_7F
   02F6                     531 __Moveto_dd_7F:
                            532 ;----- asm -----
                            533 ;  3197 "source\vec_rum_fct_pjc.c" 1
   02F6 1F 10         [ 6]  534 	tfr x,d
   02F8 7E F2 FC      [ 4]  535 	jmp ___Moveto_d_7F; BIOS call
                            536 ;  0 "" 2
                            537 ;--- end asm ---
                            538 	.globl __Moveto_d
   02FB                     539 __Moveto_d:
                            540 ;----- asm -----
                            541 ;  3315 "source\vec_rum_fct_pjc.c" 1
   02FB A6 62         [ 5]  542 	lda 2,s
   02FD 7E F3 12      [ 4]  543 	jmp ___Moveto_d; BIOS call
                            544 ;  0 "" 2
                            545 ;--- end asm ---
                            546 	.globl __Moveto_dd
   0300                     547 __Moveto_dd:
                            548 ;----- asm -----
                            549 ;  3324 "source\vec_rum_fct_pjc.c" 1
   0300 1F 10         [ 6]  550 	tfr x,d
   0302 7E F3 12      [ 4]  551 	jmp ___Moveto_d; BIOS call
                            552 ;  0 "" 2
                            553 ;--- end asm ---
                            554 	.globl __Intensity_a
   0305                     555 __Intensity_a:
                            556 ;----- asm -----
                            557 ;  3434 "source\vec_rum_fct_pjc.c" 1
   0305 1F 98         [ 6]  558 	tfr b,a
   0307 7E F2 AB      [ 4]  559 	jmp ___Intensity_a; BIOS call
                            560 ;  0 "" 2
                            561 ;--- end asm ---
                            562 	.globl __Obj_Will_Hit_u
   030A                     563 __Obj_Will_Hit_u:
   030A 34 60         [ 7]  564 	pshs	y,u
                            565 ;----- asm -----
                            566 ;  3461 "source\vec_rum_fct_pjc.c" 1
   030C A6 66         [ 5]  567 	lda 6,s
   030E 10 AE 67      [ 7]  568 	ldy 7,s
   0311 EE 69         [ 6]  569 	ldu 9,s
   0313 BD F8 E5      [ 8]  570 	jsr ___Obj_Will_Hit_u; BIOS call
   0316 C6 00         [ 2]  571 	ldb #0
   0318 C9 00         [ 2]  572 	adcb #0
                            573 ;  0 "" 2
                            574 ;--- end asm ---
   031A 35 E0         [ 8]  575 	puls	y,u,pc
                            576 	.globl __Obj_Will_Hit
   031C                     577 __Obj_Will_Hit:
   031C 34 60         [ 7]  578 	pshs	y,u
                            579 ;----- asm -----
                            580 ;  3486 "source\vec_rum_fct_pjc.c" 1
   031E A6 66         [ 5]  581 	lda 6,s
   0320 10 AE 67      [ 7]  582 	ldy 7,s
   0323 EE 69         [ 6]  583 	ldu 9,s
   0325 BD F8 F3      [ 8]  584 	jsr ___Obj_Will_Hit; BIOS call
   0328 C6 00         [ 2]  585 	ldb #0
   032A C9 00         [ 2]  586 	adcb #0
                            587 ;  0 "" 2
                            588 ;--- end asm ---
   032C 35 E0         [ 8]  589 	puls	y,u,pc
                            590 	.globl __Obj_Hit
   032E                     591 __Obj_Hit:
   032E 34 20         [ 6]  592 	pshs	y
                            593 ;----- asm -----
                            594 ;  3510 "source\vec_rum_fct_pjc.c" 1
   0330 A6 64         [ 5]  595 	lda 4,s
   0332 10 AE 65      [ 7]  596 	ldy 5,s
   0335 BD F8 FF      [ 8]  597 	jsr ___Obj_Hit; BIOS call
   0338 C6 00         [ 2]  598 	ldb #0
   033A C9 00         [ 2]  599 	adcb #0
                            600 ;  0 "" 2
                            601 ;--- end asm ---
   033C 35 A0         [ 7]  602 	puls	y,pc
                            603 	.globl __Rise_Run_X
   033E                     604 __Rise_Run_X:
                            605 ;----- asm -----
                            606 ;  3545 "source\vec_rum_fct_pjc.c" 1
   033E A6 62         [ 5]  607 	lda 2,s
   0340 BD F5 FF      [ 8]  608 	jsr ___Rise_Run_X; BIOS call
   0343 1F 01         [ 6]  609 	tfr d,x
                            610 ;  0 "" 2
                            611 ;--- end asm ---
   0345 39            [ 5]  612 	rts
                            613 	.globl __Rise_Run_Y
   0346                     614 __Rise_Run_Y:
                            615 ;----- asm -----
                            616 ;  3566 "source\vec_rum_fct_pjc.c" 1
   0346 A6 62         [ 5]  617 	lda 2,s
   0348 BD F6 01      [ 8]  618 	jsr ___Rise_Run_Y; BIOS call
   034B 1F 01         [ 6]  619 	tfr d,x
                            620 ;  0 "" 2
                            621 ;--- end asm ---
   034D 39            [ 5]  622 	rts
                            623 	.globl __Rise_Run_Len
   034E                     624 __Rise_Run_Len:
                            625 ;----- asm -----
                            626 ;  3587 "source\vec_rum_fct_pjc.c" 1
   034E 1F 98         [ 6]  627 	tfr b,a
   0350 BD F6 03      [ 8]  628 	jsr ___Rise_Run_Len; BIOS call
   0353 1F 01         [ 6]  629 	tfr d,x
                            630 ;  0 "" 2
                            631 ;--- end asm ---
   0355 39            [ 5]  632 	rts
                            633 	.globl __Rot_VL_ab
   0356                     634 __Rot_VL_ab:
   0356 34 40         [ 6]  635 	pshs	u
                            636 ;----- asm -----
                            637 ;  3616 "source\vec_rum_fct_pjc.c" 1
   0358 A6 64         [ 5]  638 	lda 4,s
   035A EE 65         [ 6]  639 	ldu 5,s
   035C BD F6 10      [ 8]  640 	jsr ___Rot_VL_ab; BIOS call
                            641 ;  0 "" 2
                            642 ;--- end asm ---
   035F 35 C0         [ 7]  643 	puls	u,pc
                            644 	.globl __Rot_VL_Diff
   0361                     645 __Rot_VL_Diff:
   0361 34 40         [ 6]  646 	pshs	u
                            647 ;----- asm -----
                            648 ;  3643 "source\vec_rum_fct_pjc.c" 1
   0363 EE 64         [ 6]  649 	ldu 4,s
   0365 BD F6 13      [ 8]  650 	jsr ___Rot_VL_Diff; BIOS call
                            651 ;  0 "" 2
                            652 ;--- end asm ---
   0368 35 C0         [ 7]  653 	puls	u,pc
                            654 	.globl __Rot_VL
   036A                     655 __Rot_VL:
   036A 34 40         [ 6]  656 	pshs	u
                            657 ;----- asm -----
                            658 ;  3670 "source\vec_rum_fct_pjc.c" 1
   036C EE 64         [ 6]  659 	ldu 4,s
   036E BD F6 16      [ 8]  660 	jsr ___Rot_VL; BIOS call
                            661 ;  0 "" 2
                            662 ;--- end asm ---
   0371 35 C0         [ 7]  663 	puls	u,pc
                            664 	.globl __Dot_y
   0373                     665 __Dot_y:
   0373 34 20         [ 6]  666 	pshs	y
                            667 ;----- asm -----
                            668 ;  3729 "source\vec_rum_fct_pjc.c" 1
   0375 1F 12         [ 6]  669 	tfr x,y
   0377 BD EA 5D      [ 8]  670 	jsr ___Dot_y; BIOS call
                            671 ;  0 "" 2
                            672 ;--- end asm ---
   037A 35 A0         [ 7]  673 	puls	y,pc
                            674 	.globl __Dot_py
   037C                     675 __Dot_py:
   037C 34 20         [ 6]  676 	pshs	y
                            677 ;----- asm -----
                            678 ;  3747 "source\vec_rum_fct_pjc.c" 1
   037E 1F 12         [ 6]  679 	tfr x,y
   0380 BD EA 6D      [ 8]  680 	jsr ___Dot_py; BIOS call
                            681 ;  0 "" 2
                            682 ;--- end asm ---
   0383 35 A0         [ 7]  683 	puls	y,pc
                            684 	.globl __Draw_Pack
   0385                     685 __Draw_Pack:
   0385 34 20         [ 6]  686 	pshs	y
                            687 ;----- asm -----
                            688 ;  3776 "source\vec_rum_fct_pjc.c" 1
   0387 10 AE 64      [ 7]  689 	ldy 4,s
   038A BD EA 7F      [ 8]  690 	jsr ___Draw_Pack; BIOS call
                            691 ;  0 "" 2
                            692 ;--- end asm ---
   038D 35 A0         [ 7]  693 	puls	y,pc
                            694 	.globl __Draw_Pack_py
   038F                     695 __Draw_Pack_py:
   038F 34 20         [ 6]  696 	pshs	y
                            697 ;----- asm -----
                            698 ;  3803 "source\vec_rum_fct_pjc.c" 1
   0391 10 AE 64      [ 7]  699 	ldy 4,s
   0394 BD EA 8D      [ 8]  700 	jsr ___Draw_Pack_py; BIOS call
                            701 ;  0 "" 2
                            702 ;--- end asm ---
   0397 35 A0         [ 7]  703 	puls	y,pc
                            704 	.globl __Print_Msg
   0399                     705 __Print_Msg:
   0399 34 60         [ 7]  706 	pshs	y,u
                            707 ;----- asm -----
                            708 ;  3825 "source\vec_rum_fct_pjc.c" 1
   039B 1F 12         [ 6]  709 	tfr x,y
   039D EE 66         [ 6]  710 	ldu 6,s
   039F BD EA A8      [ 8]  711 	jsr ___Print_Msg; BIOS call
                            712 ;  0 "" 2
                            713 ;--- end asm ---
   03A2 35 E0         [ 8]  714 	puls	y,u,pc
                            715 	.globl __Displ8_xy
   03A4                     716 __Displ8_xy:
   03A4 34 20         [ 6]  717 	pshs	y
                            718 ;----- asm -----
                            719 ;  3863 "source\vec_rum_fct_pjc.c" 1
   03A6 A6 64         [ 5]  720 	lda 4,s
   03A8 BD E7 B5      [ 8]  721 	jsr ___Displ8_xy; BIOS call
                            722 ;  0 "" 2
                            723 ;--- end asm ---
   03AB 35 A0         [ 7]  724 	puls	y,pc
                            725 	.globl __Displ16_xy
   03AD                     726 __Displ16_xy:
   03AD 34 20         [ 6]  727 	pshs	y
                            728 ;----- asm -----
                            729 ;  3884 "source\vec_rum_fct_pjc.c" 1
   03AF A6 64         [ 5]  730 	lda 4,s
   03B1 BD E7 D2      [ 8]  731 	jsr ___Displ16_xy; BIOS call
                            732 ;  0 "" 2
                            733 ;--- end asm ---
   03B4 35 A0         [ 7]  734 	puls	y,pc
                            735 	.globl __Ranpos
   03B6                     736 __Ranpos:
                            737 ;----- asm -----
                            738 ;  3904 "source\vec_rum_fct_pjc.c" 1
   03B6 BD EA 5D      [ 8]  739 	jsr ___Dot_y; BIOS call
   03B9 1F 01         [ 6]  740 	tfr d,x
                            741 ;  0 "" 2
                            742 ;--- end asm ---
   03BB 39            [ 5]  743 	rts
                            744 	.globl __Draw_Scores
   03BC                     745 __Draw_Scores:
   03BC 34 60         [ 7]  746 	pshs	y,u
                            747 ;----- asm -----
                            748 ;  3935 "source\vec_rum_fct_pjc.c" 1
   03BE BD EA CF      [ 8]  749 	jsr ___Draw_Scores; BIOS call
                            750 ;  0 "" 2
                            751 ;--- end asm ---
   03C1 35 E0         [ 8]  752 	puls	y,u,pc
                            753 	.globl __Draw_Score
   03C3                     754 __Draw_Score:
   03C3 34 60         [ 7]  755 	pshs	y,u
                            756 ;----- asm -----
                            757 ;  3964 "source\vec_rum_fct_pjc.c" 1
   03C5 BD EA B4      [ 8]  758 	jsr ___Draw_Score; BIOS call
                            759 ;  0 "" 2
                            760 ;--- end asm ---
   03C8 35 E0         [ 8]  761 	puls	y,u,pc
                            762 	.globl __Wait_Bound
   03CA                     763 __Wait_Bound:
   03CA 34 60         [ 7]  764 	pshs	y,u
                            765 ;----- asm -----
                            766 ;  3991 "source\vec_rum_fct_pjc.c" 1
   03CC BD EA F0      [ 8]  767 	jsr ___Wait_Bound; BIOS call
                            768 ;  0 "" 2
                            769 ;--- end asm ---
   03CF 35 E0         [ 8]  770 	puls	y,u,pc
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

