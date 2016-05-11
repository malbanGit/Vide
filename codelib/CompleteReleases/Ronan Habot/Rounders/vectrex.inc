; +=====================================================================+
; |                                                                     |
; |   VECTREX.INC                                                       |
; |                                                                     |
; |   Copyright 1999, Ronen Habot                                       |
; |                                                                     |
; +=====================================================================+
;
; file created 01-Dec-99


                list


Wait_Recal		EQU	$F192
VIA_t1_cnt_lo		EQU	$D004
Vec_Music_Flag		EQU	$C856
Vec_Expl_Flag		EQU	$C867
Vec_line_pat		EQU	$C829
Vec_Misc_Count		EQU	$C823
Intensity_to_a		EQU	$F2AB
Intensity_3F		EQU	$F2A1
Intensity_5F		EQU	$F2A5
Intensity_7F		EQU	$F2A9
Moveto_d		EQU	$F312
Moveto_d_7F		EQU	$F30C
Moveto_ix_FF		EQU	$F308
Draw_Pat_VL_a		EQU	$F434
Draw_VL			EQU	$F3DD
Draw_VLc		EQU	$F3CE
Draw_VLp		EQU	$F410
Delay_3			EQU	$F56D
Delay_b			EQU	$F57A
Abs_a_b			EQU	$F584
Read_Btns		EQU	$F1BA
Vec_Btn_State		EQU     $C80F
Print_Str_xy		EQU	$F378
Print_Str_d 		EQU	$F37A
Mov_Draw_VL_d		EQU	$F3BE
Draw_line_d		EQU	$F3DF
Reset0Ref_D0		EQU	$F34A
Reset0Ref   		EQU	$F354
Dot_list		EQU	$F2D5
Dot_here		EQU	$F2C5
Random  		EQU	$F511
Random_3  		EQU	$F517
DP_to_D0		EQU	$F1AA
DP_to_D8		EQU	$F1AF
Obj_Hit    		EQU	$F8FF
Vec_Text_HW		EQU	$C82A
;Explosion_Snd		EQU	$F92E
;Do_Sound		EQU     $F289
byte2sndchip		EQU     $F256
byte2sndchip2		EQU	$F259
;Clear_Sound		EQU	$F272
Clear_Score  		EQU	$F84F
Add_Score_a		EQU	$F85E
Add_Score_d		EQU	$F87C
JOYENS			EQU	$C81F		;JOYSTICK ENABLES (4 BYTES)
Joy_Digital		EQU	$F1F8
Joy_Analog		EQU	$F1F5
Vec_Joy_Resltn          EQU     $C81A
Vec_Joy_1_X		EQU     $C81B
Vec_Joy_1_Y		EQU     $C81C
Compare_Score		EQU     $F8C7
New_High_Score		EQU     $F8D8
Vec_High_Score		EQU     $CBEB
Print_Ships   		EQU     $F393
Warm_Start   		EQU     $F06C
Music1			equ	$fd0d
Music2			equ	$fd1d
Music3			equ	$fd81
Music4			equ	$fdd3
Music5                  EQU     $FE38
Music6                  EQU     $FE76
Music7                  EQU     $FEC6
Music8                  EQU     $FEF8
Music9                  EQU     $FF26
Musica                  EQU     $FF44
Musicb                  EQU     $FF62
Musicc                  EQU     $FF7A
Musicd                  EQU     $FF8F
Do_Sound		equ	$f289
Init_Music_chk		equ	$f687
Clear_x_d               EQU     $F548
Clear_x_b               EQU     $F53F
Cold_Start              EQU     $F000
Sound_Byte              EQU     $F256
Rise_Run_Y              EQU     $F601
Rise_Run_X              EQU     $F5FF
Rot_VL_ab		EQU	$F610
