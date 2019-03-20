; +=====================================================================+
; |                                                                     |
; |   VABOOM.ASM                                                        |
; |                                                                     |
; |   Copyright 2000, Ronen Habot                                       |
; |                                                                     |
; +=====================================================================+
;
; file created 01-Jan-99

                title   "VABOOM Game for the HP3000 - Vextrex arcade"

                list


Wait_Recal              EQU     $F192
VIA_t1_cnt_lo           EQU     $D004
Vec_Music_Flag          EQU     $C856
Vec_Expl_Flag           EQU     $C867
Vec_line_pat            EQU     $C829
Vec_Misc_Count          EQU     $C823
Intensity_3F            EQU     $F2A1
Intensity_5F            EQU     $F2A5
Intensity_7F            EQU     $F2A9
Moveto_d                EQU     $F312
Moveto_d_7F             EQU     $F30C
Moveto_ix_FF            EQU     $F308
Draw_Pat_VL_a           EQU     $F434
Draw_VLc                EQU     $F3CE
Draw_VLp                EQU     $F410
Delay_3                 EQU     $F56D
Delay_b                 EQU     $F57A
Read_Btns               EQU     $F1BA
Print_Str_xy            EQU     $F378
Print_Str_d             EQU     $F37A
Mov_Draw_VL_d           EQU     $F3BE
Draw_line_d             EQU     $F3DF
Reset0Ref_D0            EQU     $F34A
Reset0Ref               EQU     $F354
Dot_list                EQU     $F2D5
Dot_here                EQU     $F2C5
random                  EQU     $F511
DP_to_D0                EQU     $F1AA
DP_to_D8                EQU     $F1AF
Obj_Hit                 EQU     $F8FF
Vec_Text_HW             EQU     $C82A
Clear_Score             EQU     $F84F
Add_Score_a             EQU     $F85E
JOYENS                  EQU     $C81F           ;JOYSTICK ENABLES (4 BYTES)
Joy_Digital             EQU     $F1F8
Joy_Analog              EQU     $F1F5
Vec_Joy_Resltn          EQU     $C81A
Vec_Joy_1_X             EQU     $C81B
Vec_Joy_1_Y             EQU     $C81C
Compare_Score           EQU     $F8C7
New_High_Score          EQU     $F8D8
Vec_High_Score          EQU     $CBEB
Print_Ships             EQU     $F393
Warm_Start              EQU     $F06C
Cold_Start              EQU     $F000
Music1                  equ     $fd0d
Music2                  equ     $fd1d
Music3                  equ     $fd81
Music4                  equ     $fdd3
Music5                  EQU     $FE38
Music6                  EQU     $FE76
Music7                  EQU     $FEC6
Music8                  EQU     $FEF8
Music9                  EQU     $FF26
Musica                  EQU     $FF44
Musicb                  EQU     $FF62
Musicc                  EQU     $FF7A
Musicd                  EQU     $FF8F
Sound_Byte              EQU     $F256
Sound_Byte2             EQU     $F259
copy_bytes_2_sound_chip EQU     $F27D
Clear_x_d               EQU     $F548
Do_Sound                equ     $f289
Init_Music_chk          equ     $f687
Clear_x_b               EQU     $F53F
Explod                  EQU     $F92E

ManYpos                 EQU     $C880
ManXpos                 EQU     $C881
ManMovDir               EQU     $C882
CurBombsNum             EQU     $C883
BombLoopCntr            EQU     $C884
cheatOnFlag             EQU     $C885
JoyType                 EQU     $C886
LastAnalogVal           EQU     $C887

DivResult               EQU     $C888
DivRemain               EQU     $C889

Pile1Type               EQU     $C890
Pile1Ypos               EQU     $C891
Pile1Xpos               EQU     $C892
Pile2Type               EQU     $C893
Pile2Ypos               EQU     $C894
Pile2Xpos               EQU     $C895
Pile3Type               EQU     $C896
Pile3Ypos               EQU     $C897
Pile3Xpos               EQU     $C898
PileMoveDir             EQU     $C899
BombsInPile             EQU     $C89A           ;C99A
BricksCnt               EQU     $C89B

;******************************************************************************
; Strint to be displayed between levels 0x32 bytes long!
;******************************************************************************
menu_ram_str            EQU     $C9C0
;******************************************************************************
; Bomb variables table declaration:
; @ 2n   : BombYpos
; @ 2n+1 : BombXpos
;******************************************************************************
bomb_pos_tbl            EQU     $CA00
;******************************************************************************
; Bomb parameters table declaration:
; @ 2n   : MoveUP(0) / MoveDN(1)
; @ 2n+1 : MoveLT(0) / MoveRT(1) in case of moving up...
;******************************************************************************
bomb_param_tbl          EQU     $CB00


Score_tbl               EQU     $C950
dbg1_tbl                EQU     $C958
dbg2_tbl                EQU     $C960           ;RealTime clock table

; Global variables
CurLvl                  EQU     $C970
BombsToDraw             EQU     $C971
PilesToDraw             EQU     $C974
CurLvlBombs             EQU     $C975
CurLvlManSpeed          EQU     $C976
CurLvlBombSpeed         EQU     $C977
CurLvlBombBounce        EQU     $C978
CurLvlDropRate          EQU     $C979
HeartYpos               EQU     $C97A
HeartXpos               EQU     $C97B
HeartOnFlag             EQU     $C97C
TotalBombs              EQU     $C97D
ChkHeartFlag            EQU     $C97E
MidLeftRtrn             EQU     $C97F

explsn_num              EQU     $C980
explsn_scale            EQU     $C981
ExplsnFlag              EQU     $C982
TmpScale                EQU     $C987
TmpYpos                 EQU     $C988
TmpXpos                 EQU     $C989
LtrParamSet             EQU     $C98B
CurLtr                  EQU     $C98C
ManHit                  EQU     $C98D
NoMoreHitFlag           EQU     $C98E
BonusRndFlag            EQU     $C98F

PrintMenuFlag           EQU     $C990
ExOnFlag                EQU     $C991
ExYpos                  EQU     $C992
ExXpos                  EQU     $C993
ChkExFlag               EQU     $C994
gameOverFlag            EQU     $C995
hitSndFlag              EQU     $C996
catchSndFlag            EQU     $C997
goodSndFlag             EQU     $C998
fallSndFlag             EQU     $C999
badSndFlag              EQU     $C99A
diamondOnFlag           EQU     $C99B
diamondYpos             EQU     $C99C
diamondXpos             EQU     $C99D
ChkDiamondFlag          EQU     $C99E
;*** YM music related RAM variables ***
        BSS
        ORG   $C8A0             ;C991
current_register:
                DB 0
temp:
                DB 0
temp2:
                DB 0
temp3:
                DB 0
calc_coder:
                DB 0
calc_bits:
                DB 0
ym_data_len:
                DW 0
ym_data_current:
                DW 0
ym_name:
                DW 0
Vec_Text_Width_neg:
                DB 0; variable used in own printing routines
dropManFlag:
                DB 0
BarYpos:
                DB 0

MAN_HITS_TO_BONUS       EQU     10              ;Hits amount for bonus round
MAX_LEFT_MOV            EQU     $87             ;Most left  = 0x80 (-127)
MAX_RIGHT_MOV           EQU     $57             ;Most right = 0x7f (+127)
HSCORE_POS              EQU     $5030
SCORE_POS               EQU     $50A0
BOMB_Y_START            EQU     $50
MAN_Y_POS               EQU     $60
LEVELS_PER_PARAM        EQU     5
PARAM_TBL_SIZE          EQU     5
MOVE_PILE_SPEED         EQU     $07
BOMB_SCORE              EQU     $0A
MAX_BOMBS               EQU     105             ;maximum bombs number
CENTER_PILE             EQU     $F7
SET_TO_0                EQU     $00
SET_TO_1                EQU     $01

;*** YM Sound related constants ***

INFO_START EQU 0
BYTE_POSITION EQU 0
BIT_POSITION EQU 2
CURRENT_BYTE EQU 3
CURRENT_UNPACKED_BYTE EQU 4
CURRENT_RLE_COUNTER EQU 5
CURRENT_RLE_MAPPER EQU 7
CURRENT_IS_PHRASE EQU 9
CURRENT_PHRASE_BYTE EQU 11
CURRENT_PHRASE_START EQU 12
INFO_END EQU 14
STRUCTURE_LENGTH EQU (INFO_END-INFO_START)

ym_data_start:
        CODE
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Begining of the main program
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        ORG     0

; magic init block

        FCB     $67,$20
        FCC     "GCE 2000"
        FCB     $80
        FDB     Music7
        FDB     $f850
        FDB     $30b8
        FCC     "VABOOM!"
        FCB     $80,$0
entry_point:
        JMP     start
        INCLUDE "PRINT.I"            ;replecement for bios print func
        INCLUDE "MyMacros.I"         ;replecement for bios print func
start:
        JSR   init                              ;general initialization
        JSR   opening                           ;Opening music and graphics
main:
        JSR   refresh_scrn                      ;
        JSR   check_status                      ;Check next level/game over
        JSR   draw_background                   ;Refresh background
        JSR   checkjoystick                     ;Check controller movement
        JSR   draw_man                          ;Draw the man at the top
        JSR   draw_piles                        ;Draw the paddles at the bottom
        JSR   draw_bombs                        ;Draw the falling bombs
        JSR   draw_heart                        ;Draw the falling heart
        JSR   draw_diamond                      ;Draw the falling diamond
        JSR   draw_ex                           ;Draw the falling X
        JSR   check_snd                         ;Play sounds when needed
        JSR   print_info                        ;Print the score
        BRA   main                              ;Return to main loop


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Stop any played music - turn off all channels of the sound chip
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
stop_music:
        LDA   #$07                      ;a <- $07, channel on/off bitmap
        LDB   $C807                     ;b <- old value of reg. $07
        ORB   #$3F                      ;Force all bits to be set
        JSR   Sound_Byte                ;Send the value to the sound chip
        RTS                             ;Return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; opeining - This procedure call the YM music routines, displays the opening
;            letters and, waits for a button to be pressed to start the game.
;            This is a program by itself...
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
opening:
        LDU   #SONG_DATA                ;U <- ptr to the YM sound
        JSR   init_ym_sound             ;Initialize the YM sound
        BEQ   opening                   ;
        LDD   #$FC20                    ;Set the Text size
        STD   Vec_Text_HW
opening_loop:
        JSR   Wait_Recal                ;reset the crt
        JSR   Intensity_7F              ;Set the intensity to $7F
        LDA   #$7F                      ;
        STA   VIA_t1_cnt_lo             ;Set scaling factor to be 7f

        JSR   print_vaboom              ;Print the VABOOM! on the screen
; my tip, just leave that one alone!
; no welcome to, otherwise screen wobbles on real vec
;        LDU   #open0_string
;        PRINT_STR_YX                    ;Call enhenced print routine
        RESET_0_REF;_D0                  ;Call Reset0Ref macro
        LDU   #open1_string
        PRINT_STR_YX                    ;Call enhenced print routine
        RESET_0_REF;_D0                  ;Call Reset0Ref macro
        LDU   #open2_string
        PRINT_STR_YX                    ;Call enhenced print routine
        RESET_0_REF;_D0                  ;Call Reset0Ref macro
        LDU   #open3_string
        PRINT_STR_YX                    ;Call enhenced print routine

start_music:
        JSR   do_ym_sound               ;Play the YM sound
        LDD   ym_data_current           ;Check if music reached to its end
        BEQ   opening                   ;if yes, restart...

wait_btn:
        JSR   Read_Btns                 ; Get Buttons status
        CMPA  #$00                      ; If no button pressed,
        BEQ   opening_loop              ; goto opening_loop...
normal_play:
        BITA  #$01
        BEQ   chk_btn1_4                ;
        CLR   JoyType                   ;ORIGINAL CONTROLLER selected...
        JSR   stop_music                ;Turn intro music off...
        RTS
chk_btn1_4:
        BITA  #$08
        BEQ   opening_loop              ;
        JSR   Joy_Analog                ;ATARI 2600 PADDLE selected...
        LDA   Vec_Joy_1_X               ;A <- Xpos of joystick 1
        STA   LastAnalogVal
        LDA   #$04
        STA   JoyType
        ADDA  #$30                      ;prepare the digit 4 for the menu
        LDU   #menu_ram_str
        STA   27,u                      ;store the digit 4 in the menu line
        JSR   stop_music                ;Turn intro music off...
        RTS                             ;Return to main program



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; refresh_scrn - Responsible for the reset of the crt, settings of the scale
;                factor and the real-time clock.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
refresh_scrn:
        LDA   PrintMenuFlag
        BEQ   recal
        LDA   BonusRndFlag
        BEQ   recal
        LDA   dropManFlag
        BNE   recal
        JSR   DP_to_D8                  ;DP to RAM
        LDU   #Music4                   ;
        JSR   Init_Music_chk            ;Check sound parameters
        JSR   Wait_Recal                ;reset the crt
        JSR   Do_Sound                  ;Play the sounds
        BRA   no_recal
recal:
        JSR   Wait_Recal                ;Refresh the CRT
no_recal:
        JSR   Delay_3                   ;Delay 30 cycles...
        LDA   #$7F
        STA   VIA_t1_cnt_lo             ;Set scaling factor to 7f
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; INIT - Initialize all variables and data structures.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
init:
        ;Reste all flags and parameters...
        CLR   cheatOnFlag
        CLR   gameOverFlag
        CLR   dropManFlag
        CLR   HeartOnFlag
        CLR   ExOnFlag
        CLR   diamondOnFlag
        CLR   LtrParamSet
        LDA   #$01
        STA   CurLtr
        STA   TotalBombs

        CLR   BonusRndFlag              ;Reset the Bonus round flag
        LDA   #$04
        STA   Vec_Joy_Resltn            ;Store resolution for analog joystick
        CLR   ManHit                    ;Reset Man Hits counter

        JSR   setjoystick               ; Init the Joysticks
        JSR   Read_Btns                 ; Get 1st value for reference

        LDA   #MAN_Y_POS                ;This remain constant throught the
        STA   ManYpos                   ;whole game...

        LDA   #$03                      ;This is essentially lives...
        STA   PilesToDraw

        LDA   #CENTER_PILE              ;Set piles X pos (all the same...)
        STA   Pile1Xpos
        STA   Pile2Xpos
        STA   Pile3Xpos

        LDA   #$80                      ;Set Pile1 Ypos
        STA   Pile1Ypos
        LDA   #$A0                      ;Set Pile2 Ypos
        STA   Pile2Ypos
        LDA   #$C0                      ;Set Pile3 Ypos
        STA   Pile3Ypos

        LDA   #$8C                      ;Set the Man X position to the center
        STA   ManXpos

        LDA   SET_TO_0
        STA   ManMovDir                 ;Man will move right

        CLR   ExplsnFlag                ;Reset the explosion flag
        LDA   #$30                      ;Set init explosion scale
        STA   explsn_scale

        ;Clear score at start
        LDX   #Score_tbl
        JSR   Clear_Score

        ;Menu related setting
        LDX   #menu_rom_str
        LDU   #menu_ram_str
keep_copy:                              ;Copy the menu string from the ROM to
        LDA   ,x+                       ;the RAM till the $80 is found
        STA   ,u+
        CMPA  #$80
        BNE   keep_copy

        ;Level related settings
        CLR   CurLvl                    ;CurLvl = 0
        LDD   #$FC20                    ;Set menu's text Height & Width
        STD   Vec_Text_HW               ;

        LDA   #1                        ;
        STA   PrintMenuFlag             ;indication flag: 1=print, 0=no print

        LDA   #10                       ;Update Bombs number for current level
        STA   CurLvlBombs

        CLR   fallSndFlag               ;Reset man falling sound flag
        JSR   level_init                ;Jump to level init procedure
init_done:
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; level_init - Responsible for the level initialization process. It can be
;              called either at init or after a level has ended.
;              Basically, it makes sire that the next session won't start in
;              an impossible way...
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
level_init:
        CLR   goodSndFlag               ;Reset heart catch sound flag
        CLR   badSndFlag                ;Reset X catch sound flag
        CLR   catchSndFlag              ;Reset catch sound flag
        CLR   hitSndFlag                ;Reset Hit sound flag
        JSR   stop_music                ;Turn any music off

        LDX   #bomb_param_tbl
        LDB   #$E0
        JSR   Clear_x_b                 ;Clear table parameters

        CLR   CurBombsNum
        CLR   BombsInPile
        CLR   NoMoreHitFlag             ;Clear the flag to allow Hit check

        LDA   #$05
        STA   explsn_num                ;Set explosion loop max value


        LDA   BonusRndFlag              ;Check if Bonus round to be played
        BEQ   set_new_level             ;if not, check if to prepare a new level
                                        ;otherwise, prepare bonus parameters
        LDX   #param_bonus
        LDA   ,x+
        STA   CurLvlManSpeed            ;Update Man's Speed for bonus round
        LDA   ,x+
        STA   CurLvlBombSpeed           ;Update Bomb's Speed for bonus round
        LDA   ,x+
        STA   CurLvlDropRate            ;Update the dropping rate
        LDA   ,x+
        STA   CurLvlBombBounce          ;Update the bouncing rate

        CLR   ExplsnFlag                ;Reset explosion flag
        LBRA  not_new_level


        ;Adjust level's parameters
        LDA   ExplsnFlag                ;Check Explosion Flag, needed???
        LBNE   not_new_level            ;If set, jump without new level settings
set_new_level:
        LDA   CurLvl
        LDB   #LEVELS_PER_PARAM
        LDX   #DivResult
        JSR   divide_x
        LDA   DivResult
        LDB   #PARAM_TBL_SIZE
        MUL
        LDX   #param_table
        ABX
        LDA   ,x+
        STA   CurLvlManSpeed            ;Update Man's Speed for current level
        LDA   ,x+
        STA   CurLvlBombSpeed           ;Update Bomb's Speed for current level
        LDA   ,x+
        STA   CurLvlDropRate            ;Update the dropping rate
        LDA   ,x+
        STA   CurLvlBombBounce          ;Update the bouncing rate

        LDA   DivResult
        LDB   #$0D
        MUL
        LDU   #menu_ram_str
        LDX   #mark_str                 ;X points to remark text
        ABX                             ;X=X+B to point to current remark
        LDA   #$0C                      ;A=Length of remark
copy_remark:                            ;Copy the remark from the ROM to the RAM
        LDB   ,x+
        STB   ,u+
        DECA
        BNE   copy_remark

        LDA   CurLvlBombs               ;Update Bombs number for current level
        ADDA  #5
        CMPA  #MAX_BOMBS                ;if more than 250,
        BHI   dont_change_param         ;don't update the number
        STA   CurLvlBombs               ;otherwise, store the new number

dont_change_param:
        INC   CurLvl                    ;Update current level variable
        LDA   CurLvl                    ;Check current level,
        CMPA  #100                      ;if = 100, game is over, the player is
        LBEQ  game_over                 ;toooo goooooooood.......
keep_chk_lvl:                           ;Check id Level #1, if so, the remark
        CMPA  #$01                      ;has to be welcome!
        BNE   chk_lvl2                  ;otherwise, continue...
        LDU   #menu_ram_str             ;u points to menu line in RAM
        LDX   #welcome_str              ;X points to welcome! text
        LDA   #$0C                      ;A=Length of remark
copy_welcome:
        LDB   ,x+
        STB   ,u+
        DECA
        BNE   copy_welcome
chk_lvl2:
        LDA   CurLvl                    ;Check id Level #2, if so, the remark
        CMPA  #$02                      ;has to be not_bad...
        BNE   not_new_level             ;otherwise, continue...
        LDU   #menu_ram_str             ;u points to menu line in RAM
        LDX   #mark_str                 ;X points to not_bad... text
        LDA   #$0C                      ;A=Length of remark
copy_rem1:
        LDB   ,x+
        STB   ,u+
        DECA
        BNE   copy_rem1

not_new_level:
        CLR   PileMoveDir               ;Assume last move was to right
        CLR   ExplsnFlag                ;Reset explosion flag
        CLR   ManMovDir                 ;
        INC   ManMovDir                 ;Man will move right
        CLR   MidLeftRtrn
        INC   MidLeftRtrn

        LDA   #$8C                      ;ReSet the Man X position
        STA   ManXpos
        JSR   adj_man_x                 ;Ensure that the Xpos is such that this
                                        ;levle movement will divide properly
                                        ;for bombs dropping

        ;prepare the lelvel digits within the menu string
        CLRA                            ;clear MSB
        LDB   CurLvl                    ;LSB=Current level
        JSR   d_to_bcd                  ;Convert the level number to BCD
        TFR   b,a
        LDU   #menu_ram_str             ;U points to the menu in the ram
        JSR   a_to_hex                  ;Update the menu in the ram
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ajd_man_x - check if the remain is such that the bombs will fall, if not,
;             "adjust" the ManXpos variable accordingly.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
adj_man_x:
        LDX   #DivResult                ;x=pointer to division's results
        LDA   ManXpos                   ;
        LDB   CurLvlDropRate            ;
        JSR   divide_x                  ;
        LDB   DivRemain                 ;Check reminder,
        BEQ   adjust_Xpos               ;if not zero, return with no adjustment
        RTS                             ;Return with no change
adjust_Xpos:
        LDA   CurLvlDropRate            ;
        MUL                             ;Multiply A times B
        SUBB  CurLvlManSpeed
        STB   ManXpos                   ;Store correct Xpos
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; param_table - a definition of the different parameters for each level
;               [param_table+0] => ManSpeed
;               [param_table+1] => BombSpeed
;               [param_table+2] => DropSpeed
;               [param_table+3] => BounceRate
;               [param_table+4] => Spare
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
param_table:
        DB   $02, $04, $1E, $0F, $00    ;Levels 01-05 parameters
        DB   $04, $05, $20, $0E, $00    ;Levels 06-10 parameters
        DB   $04, $06, $20, $0A, $00    ;Levels 11-15 parameters
        DB   $04, $06, $20, $09, $00    ;Levels 16-20 parameters
        DB   $04, $06, $20, $07, $00    ;Levels 21-25 parameters
        DB   $04, $07, $20, $06, $00    ;Levels 26-30 parameters
        DB   $04, $07, $20, $05, $00    ;Levels 31-35 parameters
        DB   $04, $07, $20, $05, $00    ;Levels 36-40 parameters
        DB   $08, $07, $18, $05, $00    ;Levels 41-45 parameters
        DB   $08, $07, $18, $05, $00    ;Levels 46-50 parameters
        DB   $08, $07, $18, $05, $00    ;Levels 51-55 parameters
        DB   $08, $07, $18, $05, $00    ;Levels 56-60 parameters
        DB   $08, $07, $18, $05, $00    ;Levels 61-65 parameters
        DB   $08, $08, $18, $05, $00    ;Levels 66-70 parameters
        DB   $08, $08, $18, $05, $00    ;Levels 71-75 parameters
        DB   $08, $08, $18, $05, $00    ;Levels 76-80 parameters
        DB   $08, $09, $18, $05, $00    ;Levels 81-85 parameters
        DB   $08, $09, $18, $05, $00    ;Levels 86-90 parameters
        DB   $0C, $09, $18, $05, $00    ;Levels 91-95 parameters
        DB   $0C, $09, $18, $05, $00    ;Levels 96-100 parameters
param_bonus:
        DB   $08, $07, $14, $FF, $00    ;Bonus parameters


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; draw_bombs - responsible for displaying and moving the bombs on the screen
;              based on predefined amount, speed, Man's X position and level.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
draw_bombs:
        PSHS   u                        ;store u,x in the stack
        PSHS   x
        JSR   Intensity_7F              ;Set bombs intensity

        ;Manipulate ManXpos to see if a bomb has to be dropped
        LDA   ManXpos                   ;A <- Current X pos of Man
        LDB   CurLvlDropRate            ;b=divider
        LDX   #DivResult                ;x=pointer to division's results
        JSR   divide_x                  ;call dividing procedure
        LDB   DivRemain                 ;b=remain of the division
        BNE   no_new_bomb               ;if b=0, draw a bomb, otherwise wait
drop_new_bomb:
        INC   TotalBombs
        LDA   CurLvlBombs               ;a=this level's bomb amount
        CMPA  CurBombsNum               ;if no. of dropped bombs =a, no need for
        BEQ   no_new_bomb               ;new bombs.
        INC   CurBombsNum               ;update variable of bombs number
        LDA   CurBombsNum               ;a=current bombs amount

; Chris
; why not load with -2?
        LDX   #$0000                    ;this part computes the index:
        LEAX  a,x                       ;d=(CurBombsNum-1)*2 =
        LEAX  a,x                       ;d=CurBombsNum + CurBombsNum - 2 !
        LEAX  -2,x                      ;this is done due to the signed arith.
        TFR   x,d                       ;which is no good for this matter!!!
        LDY   #bomb_pos_tbl             ;y=ptr to bombs table
        LEAY  d,y                       ;y=y+a
        LDA   #BOMB_Y_START             ;a=CONST
        LDB   ManXpos                   ;b=current man's x pos
        CMPB  -1,y                      ;Check if current bomb is not on the
        BNE   store_new_xy              ;same Xpos as the previous.
        DEC   CurBombsNum               ;Compenstae for the previous INC
        BRA   no_new_bomb               ;Don't store the Y,X, proceed to draw
store_new_xy:
        STD   ,y                        ;Store new bomb's Y,X @ address y
no_new_bomb:
        LDA   CurBombsNum               ;If no bombs to draw, skip the whole
        LBEQ   draw_bombs_end           ;subrutine...
        LDY   #0x0000                   ;y=0x0000
        LEAY  a,y                       ;y=Current Bombs number
        LDU   #bomb_pos_tbl             ;u=Begining of bombs table
draw_the_bombs:
        JSR   Reset0Ref_D0              ;Center the beam, MUST!
        LDD   ,u++                      ;d=[u], u=u+2
        CMPA  #$00                      ;check if Ypos=0, if so, dont_draw
        BEQ   dont_draw
        JSR   draw_a_bomb               ;call the procedure to draw a bomb at d
dont_draw:
        LEAY  -1,y                      ;decrement the bomb index,
        BNE   draw_the_bombs            ;if not 0, more bombs to draw...
mov_bombs_in_table:                     ;now, no more drawing, prepare for next
        LDX   #bomb_pos_tbl             ;x=pointer to the bomb position table
        LDA   CurBombsNum               ;a=amount of bombs to (virtually) move
        STA   BombLoopCntr
mov_bomb_loop:
        LDB   ,x                        ; Check if Y=7F, if so, don't move this
        CMPB  #$7F                      ; bomb and proceed with the rest of the
        BNE   keep_moving               ; table and proceed to move it
        LBRA   update_index
keep_moving:
        LDB   ,x                        ;b=[x] <- Ypos of current bomb

        LDA   $100,x                    ;a=[256+x] <- Moving Y dir of cur. bomb
        LBEQ   move_down                        ;if = 0, the bomb moves down!
move_up:
        ADDB  CurLvlBombSpeed           ;b=b+dropping speed
        STB   ,x                        ;[x]=b
        LDB   #$00                      ;check if below center of the screen
        CMPB  ,x                        ;if so, goto update the index
        BGT   move_diagonal
        LDB   #$79                      ;check if near top of the screen,
        CMPB  ,x                        ;if so, goto update the index.
        BGT   move_diagonal             ;otherwise, the bomb is at the bottom
                                        ;of the screen and shouldn't be
                                        ;displayed anymore.
        CLR   NoMoreHitFlag             ;Clear the flag to allow Hit check for
        LBRA   turn_bomb_off            ;next up-going bomb
move_diagonal:
        LDB   NoMoreHitFlag
        BNE   no_hit_chance
        LDB   #$60                      ;b=Ypos to check is man is hit
        CMPB  ,x                        ;check if Ypos of the bomb is closer to
        BLT   no_hit_chance             ;upper line, if not, no chance for hit
        TFR   x,u                       ;u = *ptr to bomb location
        PSHS  x,d,u,y
        LDD   ,u                        ;d = current bomb location
        SUBA  #$0A
        SUBB  #$0A
        TFR   d,x                       ;X-> position of the bomb
        LDY   ManYpos                   ;
        LDD   #$1818                    ;Dimentions Man...

        JSR   Obj_Hit                   ;Check if there is a hit...
        BCC   no_man_hit                ;If carry is cleared -> goto no_hit!

                                        ;Prepare to do explosion of supporting
        LDX   #bricks_loc               ;bricks
        LDA   ManHit
        ASLA
        ASLA
        LEAX  a,x                       ;X <- *ptr to brick_loc table
        JSR   do_explosion              ;@ Left brick
        LEAX  2,x                       ;X <- *ptr to brick_loc table
        JSR   do_explosion              ;@ right brick

        INC   ManHit                    ;Update Hit counter
        INC   NoMoreHitFlag             ;Prevent Hit counter from inc...
no_man_hit:
        PULS  x,d,u,y
no_hit_chance:
        LDB   1,x                       ;b=[1+x] <- Xpos of current bomb
        LDA   $101,x                    ;a=[257+x] <- Xdir of bomb...
        BEQ   move_left
move_right:
        ADDB  CurLvlBombSpeed           ;b=b-dropping speed
        DECB
        ;to check boundaries...
        CMPB  #$77
        BLO   store_right
        CMPB  #$80
        BHI   store_right
        CLR   $101,x
        BRA   update_index
store_right:
        STB   1,x
        BRA   update_index
move_left:
        SUBB  CurLvlBombSpeed
        INCB
        CMPB  #$84                      ;check if hit the left boundary,
        BHI   store_left                ;if not, store the new position
        CMPB  #$7F                      ;check if over the left bounday(@hi spd)
        BLO   store_left                ;if not, store the new position
        INC   $101,x                    ;Set the bomb_param_tbl to move right
                                        ;since it hit the left wall...
        BRA   update_index
store_left:
        STB   1,x                       ;store the Xpos of current bomb
        BRA   update_index

move_down:
        SUBB  CurLvlBombSpeed
        STB   ,x                        ;[x]=b
        LDB   #$00                      ;check if below center of the screen
        CMPB  ,x                        ;if so, goto update the index
        BLE   update_index
        LDB   #$86                      ;check if above bottom of the screen,
        CMPB  ,x                        ;if so, goto update the index.
        BLE   catch_check               ;otherwise, the bomb is at the bottom
                                        ;of the screen and shouldn't be
                                        ;displayed anymore.
turn_bomb_off:
        LDB   $100,x                    ;Do the following only if the bomb
        BNE   only_off                  ;is falling down...
        INC   BombsInPile               ;add 1 to current bombs "not on Man"
        JSR   do_explosion

        LDB   BonusRndFlag              ;Check if bonus round flag is set
        BNE   only_off                  ;if set, just remove the bomb from the
                                        ;screen, otherwise, proceed as usual...

        ;***************************************************************
        ;***                          CHEAT                          ***
        ;***    If you read so far, you deserve to know about it ;-) ***
        ;***************************************************************
        LDB   TotalBombs
        CMPB  #$0A
        BHI   end_of_cheat
        LDB   $C810                     ; check previous buttons
        CMPB  #$08
        BNE   end_of_cheat
        INC   cheatOnFlag               ;if missed 1st bomb and btn4 is pressed
end_of_cheat:
        LDB   cheatOnFlag
        BNE   only_off
        ;***************************************************************
        ;***                     END OF CHEAT                        ***
        ;***************************************************************

        DEC   PilesToDraw               ;One less Pile to play with
        BEQ   set_game_over             ;Check if crossed the zero,
        BRA   only_off                  ;if not proceed normaly,
set_game_over:                          ;otherwise, adjust the numbe to be 1
        INC   gameOverFlag
only_off:
        LDB   #$7F                      ;set Ypos to 0x7F to indicate: no_draw!
        STB   ,x                        ;set Ypos of the bomb that got to
                                        ;the bottom. This means not to draw
                                        ;any more.
        BRA   update_index
                                        ;at this point check if to change
                                        ;direction of the bomb from DN 2 UP...
catch_check:
        CLR   ChkHeartFlag              ;indicate that not heart catch check
        CLR   ChkExFlag                 ;indicate that not Ex catch check
        CLR   ChkDiamondFlag            ;indicate that not Diamond catch check
        JSR   catch_chk                 ;check if the bomb hit the piles
update_index:
        LEAX  2,x                       ;Set the pointer to next bomb in the
not_at_bottom:
        DEC   BombLoopCntr              ;are there any more bombs to draw?
        BNE   mov_bomb_loop             ;if not, continue the bomb loop.
draw_bombs_end:
        PULS  u                         ;restore values from the stack
        PULS  x                         ;Restore the x register from the stack
        RTS                             ;return to caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; catch_chk - Checks whether the paddle are catching either the bombs,heart,
;             diamond or, ex.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
catch_chk:
        TFR   x,u
        PSHS  x,d                       ;Very important - KEEP the pointer!!!

        LDY   Pile2Ypos                 ;Player's car current position
        LDD   ,u
        SUBB  #$0F
        TFR   d,x
        LDA   PilesToDraw
        CMPA  #$03
        BNE   no_3_piles
        LDD   #$2618                    ;Dimentions of 3 piles
        bra   tst_hit
no_3_piles:
        LDY   Pile1Ypos                 ;
        CMPA  #$02
        BNE   no_2_piles
        LDD   #$2618                    ;Dimentions of 2 piles
        bra   tst_hit
no_2_piles:
        LDY   Pile1Ypos                 ;Player's car current position
        LDD   #$0A18                    ;Dimentions of 1 piles
tst_hit:
        JSR   Obj_Hit                   ;Check if there is a hit...
        LBCC   no_hit                   ;If carry is cleared -> goto no_hit!
proceed_hit:
        LDA   ChkDiamondFlag            ;Check if diamond is falling
        LBNE  diamond_catch
        LDA   ChkExFlag                 ;Check if Ex is falling,
        BNE   ex_catch                  ;if so, check if that on hit
        LDA   ChkHeartFlag              ;otherwise, check if Heart is falling,
        BNE   heart_catch               ;if so, check this hit...
        LDA   #$05                      ;A<- 0x05
        STA   catchSndFlag              ;Set Sound flag for check_snd proc...
        INC   BombsInPile               ;add 1 to current bombs in pile

                                        ;at this point check if to change
                                        ;direction of the bomb from DN 2 UP...
        LDA   $100,u                    ;IMPORTANT: change direction once -
        BNE   regular_bomb              ;only if bobm is falling, else don't!

        LDA   BombsInPile
        LDB   CurLvlBombBounce          ;b=divider
        LDX   #DivResult                ;x=pointer to division's results
        JSR   divide_x                  ;call dividing procedure
        LDB   DivRemain                 ;b=remain of the division
        BNE   regular_bomb
        LDB   PilesToDraw
        CMPB  #$03
        BNE   chk_if2
        LDB   Pile3Ypos
        BRA   set_y_done
chk_if2:
        CMPB  #$02
        BNE   chk_if1
        LDB   Pile2Ypos
        BRA   set_y_done
chk_if1:
        LDB   Pile1Ypos                 ;b=begining of the Ypos of the bomb
set_y_done:
        STB   ,u                        ;when it has to go up!
        LDA   #$01                      ;a=1 (move bomb up)
        STA   $100,u                    ;store a in the bomb_para_table
        LDA   PileMoveDir               ;decide to which side to move up (in
        STA   $101,u                    ;diagonal) according to the pile move
        BRA   score_hit                 ;done!
regular_bomb:
        LDA   #$7F                      ;a=$7F -> indicates not to draw bomb
        STA   ,u                        ;store a in Ypos of current bomb
        BRA   score_hit
heart_catch:
        LDA   #$0C                      ;
        STA   goodSndFlag               ;Set Sound flag for check_snd proc...
        CLR   HeartOnFlag               ;Turn off the heart drawing...
        LDA   PilesToDraw
        CMPA  #$03                      ;check number of piles,
        BEQ   score_heart               ;if = 3 than don't add one more
        INC   PilesToDraw               ;as a bonus, add one more pile
score_heart:                            ;HEART score = 50 points
        LDA   #BOMB_SCORE*4             ;Update score string
        LDX   #Score_tbl                ;x -> score_table address
        JSR   Add_Score_a               ;update the score table
        BRA   score_hit
ex_catch:
        LDA   #$0B                      ;
        STA   badSndFlag                ;Set Sound flag for check_snd proc...
        CLR   ExOnFlag                  ;Turn off the Ex drawing...
        LDA   PilesToDraw
        DEC   PilesToDraw
        LBEQ  game_over
        BRA   no_hit
diamond_catch:
        LDA   #$0C                      ;
        STA   goodSndFlag               ;Set Sound flag for check_snd proc...
        CLR   diamondOnFlag             ;Turn off the heart drawing...
        LDA   #BOMB_SCORE*9             ;Update score string
        LDX   #Score_tbl                ;x -> score_table address
        JSR   Add_Score_a               ;update the score table
score_hit:
        LDA   #BOMB_SCORE               ;Update score string
        LDB   BonusRndFlag
        BEQ   one_bomb_score
        ADDA  #BOMB_SCORE               ;@ Bonus round, have extra scores when
        ADDA  #BOMB_SCORE               ;player catches a bomb
one_bomb_score:
        LDX   #Score_tbl                ;Point to the score string
        JSR   Add_Score_a               ;Update the score string
no_hit:
                                        ;
catch_chk_end:
        PULS  x,d                       ;Restore the pointers back
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; draw_a_bomb - This procedure draws a bomb at the location specified by D reg.
;               Assumes D=(Y,X) to position the sprite...
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
draw_a_bomb:
        PSHS  x                         ;store x in the stack
        CMPA  #$7F                      ;Don't draw if Y=$7F...
        LBEQ   end_of_draw
        RH_MOVE_TO_D

;        LDA   #$7F                      ;Set the scaling factor to 7f
        LDA   #$9                      ;Set the scaling factor to 7f
        STA   VIA_t1_cnt_lo             ;

        LDX   #bomb                     ;X<-Address[CarVectorList]
        RH_DRAW_VLC
 ; compensate above wrongdoing!
 LDA   #$7F                      ;Set the scaling factor to 7f
 STA   VIA_t1_cnt_lo             ;
end_of_draw:
        PULS  x                         ;restore x from the stack
        RTS                             ;return to caller


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; divide_x: Divides two numbers:
;           *x = a div b, *x+ = reminder, @ exit, b=remian, a=0
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
divide_x:
        CLR   ,x                        ;clear the result field
        STB   1,x                       ;*x+ <- b
repeat_div:
        CMPA  1,x                       ; check if b>a, if so, that's the end
        BLO   a_smaller_then_b
        SUBA  1,x                       ;a = a-b
        INC   ,x                        ;result <- result + 1
        BRA   repeat_div
a_smaller_then_b:
        STA   1,x
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; draw_man - Draws the moving man at the top...
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
draw_man:
        PSHS  x                         ;Store the register in the stack
        LDA   #$7F                      ;While the positioning is in respect
        STA   VIA_t1_cnt_lo             ;with $7F, the car drawing is with $50
        JSR   Reset0Ref_D0
        JSR   Intensity_7F              ;Set player's car intensity
        LDA   dropManFlag
        BEQ   keep_man_moving
        BRA   x_man_rdy
keep_man_moving:
        LDA   PrintMenuFlag             ;Check if menu is on,
        BEQ   mov_man                   ;if not, move the man, otherwise,
        BRA   x_man_rdy                 ;draw the man with no move
mov_man:
        LDA   ManMovDir
        BNE   mov_right
mov_left:
        LDB   #$85                      ;b=left screen border location
        CMPB  ManXpos                   ;check if the man is next to the border
        BGT   chng_to_right             ;if yes, goto change direction to move R

        LDB   MidLeftRtrn
        BEQ   no_lft_mid_rtrn
        LDB   #$00
        CMPB  ManXpos
        BGT   chng_to_right
no_lft_mid_rtrn:
        LDB   ManXpos                   ;b=current X position
        SUBB  CurLvlManSpeed            ;b=b-man's speed -> move left
store_x0:
        STB   ManXpos                   ;store the new Xpos
        BRA   x_man_rdy                 ;goto draw the man
chng_to_right:
        LDB   MidLeftRtrn
        BEQ   set_midrtrn
        CLR   MidLeftRtrn
        BRA   set_man_dir_flag
set_midrtrn:
        INC   MidLeftRtrn
set_man_dir_flag:
        INC   ManMovDir                 ;Set to 1 -> from now, move right...
        BRA   x_man_rdy                 ;goto draw the man
mov_right:
        LDB   #$59                      ;b=right screen border location
        CMPB  ManXpos                   ;check if the man is next to the border
        BLE   chng_to_left
        LDB   ManXpos
        ADDB  CurLvlManSpeed
store_x1:
        STB   ManXpos
        BRA   x_man_rdy

chng_to_left:
        CLR   ManMovDir
x_man_rdy:
        LDB   ManXpos
        TST   dropManFlag
        BEQ   man_at_top
        LDA   ManYpos
        SUBA  #$02
        STA   ManYpos
        BRA   man_to_xy                 ;goto update xy location
man_at_top:
        LDA   #MAN_Y_POS
        STA   ManYpos
man_to_xy:
        LDA   ManYpos                   ;Set Ypos
        JSR   Moveto_d                  ;Move beam to pos(X,Y)
;        LDA   #$50                      ;While the positioning is in respect
        LDA   #$14                      ;While the positioning is in respect
        STA   VIA_t1_cnt_lo             ;with $7F, the car drawing is with $50
        LDX   #man
        RH_DRAW_VLC
;        RH_DRAW_VLP
        PULS  x                         ;Restore the register from the stack
        RTS                             ;Return to the caller


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; draw_piles - Draws the paddles that catch the falling bombs. The X position
;              is defined by the check joystick procedure and stored in the
;              Xpos and Ypos RAM locations.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
draw_piles:
        PSHS  x                         ;Store the register in the stack
        JSR   Intensity_5F              ;Set paddles intensity

        LDA   PilesToDraw               ;Check how many paddles to draw
        CMPA  #$03
        BNE   two_piles
        JSR   Reset0Ref_D0              ;Move the beam to (0,0)
        LDA   #$7F                      ;Set scaling factor to 7f
        STA   VIA_t1_cnt_lo             ;
        LDA   Pile3Ypos                 ;Set Ypos based on Joystick pos
        LDB   Pile3Xpos                 ;Set Xpos based on Joystick pos
        JSR   Moveto_d                  ;Move beam to pos(X,Y)
        LDX   #pile
        LDA   #$7F/3                      ;Set scaling factor to 7f
        STA   VIA_t1_cnt_lo             ;
        RH_DRAW_VLC
        BRA   byps_chk

two_piles:
        LDA   PilesToDraw
        CMPA  #$02
        BNE   one_pile
byps_chk:
        JSR   Reset0Ref_D0              ;Move the beam to (0,0)
        LDA   #$7F                      ;Set scaling factor to 7f
        STA   VIA_t1_cnt_lo             ;
        LDA   Pile2Ypos                 ;Set Ypos based on Joystick pos
        LDB   Pile2Xpos                 ;Set Xpos based on Joystick pos
        JSR   Moveto_d                  ;Move beam to pos(X,Y)
        LDX   #pile
        LDA   #$7F/3                      ;Set scaling factor to 7f
        STA   VIA_t1_cnt_lo             ;
        RH_DRAW_VLC

one_pile:
        JSR   Reset0Ref                 ;Move the beam to (0,0)
        LDA   #$7F                      ;Set scaling factor to 7f
        STA   VIA_t1_cnt_lo             ;
        LDA   Pile1Ypos                 ;Set Ypos based on Joystick pos
        LDB   Pile1Xpos                 ;Set Xpos based on Joystick pos
        JSR   Moveto_d                  ;Move beam to pos(X,Y)
        LDA   #$7F/3                      ;Set scaling factor to 7f
        STA   VIA_t1_cnt_lo             ;
        LDX   #pile
        RH_DRAW_VLC
        LDA   #$7F                      ;Set scaling factor to 7f
        STA   VIA_t1_cnt_lo             ;
        PULS  x                         ;Restore the register from the stack
        RTS                             ;REturn to the caller


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; draw_heart - Draws the falling heart when needed.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
draw_heart:
        PSHS  x,u,d                     ;Store the registers in the stack
        LDA   HeartOnFlag
        BNE   move_heart
        LDA   TotalBombs                ;A <- Total bombs
        CMPA  #$FE
        BNE   check_heart_flag          ;If A=0 , drop a heat
        INC   HeartOnFlag
        BRA   drop_heart
check_heart_flag:
        LDA   HeartOnFlag               ;A <- Heart was dropped flag
        BEQ   dont_drop_heart           ;if cleared, don't proceed
        BRA   move_heart                ;otherwise, move the heart on screen
drop_heart:
        LDA   #BOMB_Y_START
        STA   HeartYpos
        LDA   ManXpos
        STA   HeartXpos
move_heart:
        LDA   HeartYpos
        CMPA  #$00                      ;if so, goto update the index
        BGT   update_heart_loc
        CMPA  #$85                      ;if so, goto update the index.
        BGT   catch_heart_check         ;otherwise, the bomb is at the bottom
                                        ;of the screen and shouldn't be
        CLR   HeartOnFlag               ;displayed
catch_heart_check:
        LDX   #HeartYpos
        INC   ChkHeartFlag
        JSR   catch_chk         ;check if the bomb hit the piles
        CLR   ChkHeartFlag

update_heart_loc:
        LDA   HeartYpos
        SUBA  #$01
        STA   HeartYpos
        JSR   Reset0Ref_D0
        LDD   HeartYpos
        JSR   Moveto_d                  ;Move beam to pos(X,Y)
        LDX   #heart                    ;X<-Address[HeartVectorList]
        RH_DRAW_VLC

dont_drop_heart:
        PULS  x,u,d                     ;Restore the registers from the stack
        RTS                             ;Return to the caller


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; draw_diamond - Draws the falling diamond when needed.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
draw_diamond:
        PSHS  x,u,d                     ;Store the registers in the stack
        LDA   diamondOnFlag
        BNE   move_diamond
        LDA   TotalBombs                ;A <- Total bombs
        CMPA  #$40
        BNE   check_diamond_flag        ;If A=0 , drop a heat
        INC   diamondOnFlag
        BRA   drop_diamond
check_diamond_flag:
        LDA   diamondOnFlag             ;A <- Heart was dropped flag
        BEQ   dont_drop_diamond         ;if cleared, don't proceed
        BRA   move_diamond              ;otherwise, move the heart on screen
drop_diamond:
        LDA   #BOMB_Y_START
        STA   diamondYpos
        LDA   ManXpos
        STA   diamondXpos
move_diamond:
        LDA   diamondYpos
        CMPA  #$00                      ;if so, goto update the index
        BGT   update_diamond_loc
        CMPA  #$90;85                   ;if so, goto update the index.
        BGT   catch_diamond_check       ;otherwise, the bomb is at the bottom
                                        ;of the screen and shouldn't be
        CLR   diamondOnFlag             ;displayed
catch_diamond_check:
        LDX   #diamondYpos
        INC   ChkDiamondFlag
        JSR   catch_chk                 ;check if the bomb hit the piles
        CLR   ChkDiamondFlag
update_diamond_loc:
        LDA   diamondYpos
        SUBA  #$09
        STA   diamondYpos
        JSR   Reset0Ref_D0
        LDD   diamondYpos
        JSR   Moveto_d                  ;Move beam to pos(X,Y)
        LDX   #diamond                  ;X<-Address[HeartVectorList]
        RH_DRAW_VLC

dont_drop_diamond:
        PULS  x,u,d                     ;Restore the registers from the stack
        RTS                             ;Return to the caller


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; draw_ex - Draws the falling X when needed.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
draw_ex:
        PSHS  x,u,d
        LDA   ExOnFlag
        BNE   move_ex
        LDA   TotalBombs                ;A <- Total bombs
        CMPA  #$80
        BNE   check_ex_flag             ;If A=0 , drop a heat
        INC   ExOnFlag
        BRA   drop_ex
check_ex_flag:
        LDA   ExOnFlag                  ;A <- Heart was dropped flag
        LBEQ   dont_drop_ex             ;if cleared, don't proceed
        BRA   move_ex                   ;otherwise, move the heart on screen
drop_ex:
        LDA   #BOMB_Y_START
        STA   ExYpos
        LDA   ManXpos
        STA   ExXpos
move_ex:
        LDA   ExYpos
        CMPA  #$00                      ;if so, goto update the index
        BGT   update_ex_loc
        CMPA  #$85;80                   ;if so, goto update the index.
        BGT   catch_ex_check            ;otherwise, the bomb is at the bottom
                                        ;of the screen and shouldn't be
        CLR   ExOnFlag                  ;displayed
catch_ex_check:
        LDA   BonusRndFlag
        BNE   update_ex_loc             ;skip catch check of Ex if bonus round
        LDX   #ExYpos
        INC   ChkExFlag
        JSR   catch_chk                 ;check if the Ex hit the piles
        CLR   ChkExFlag

update_ex_loc:
        LDA   ExYpos
        SUBA  #$01
        STA   ExYpos

        JSR   Reset0Ref_D0
        LDD   ExYpos
        JSR   Moveto_d                  ;Move beam to pos(X,Y)
        LDX   #ex                       ;X<-Address[HeartVectorList]
        RH_DRAW_VLC
dont_drop_ex:
        PULS  x,u,d                     ;Restore the register from the stack
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; draw_background - This procedure draws the screen background based on a
;                   vector table defined at #bckgnd. This procedure is called
;                   every refresh cycle in order to keep the background always
;                   visible. The scaling factor here is set to $7F.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
draw_background:
        PSHS  x,y,u,d                   ;Store registers in the stack
        LDA   #$7F                      ;A <- $7F scaling factor
        STA   VIA_t1_cnt_lo             ;Store the scaling factor in the VIA
        JSR   Intensity_5F              ;Set the intensity to $5F
        JSR   Reset0Ref_D0
        LDA   dropManFlag               ;Check if begining of bonus round,
        BEQ   stay_at_top               ;if not, stay at top
        LDB   #$80
        LDA   BarYpos
        SUBA  #$02                      ;adjust Ypos for the down movement
        STA   BarYpos
        CMPA  #$00                      ;check if in upper part of screen,
        BGE   move_to_xy                ;if so, just keep moving...
        CMPA  #$90                      ;check if above bottom part,
        BGT   move_to_xy                ;if so, keep moving,
        CLR   dropManFlag               ;otherwise, clear the dropping flag
        BRA   move_to_xy                ;goto update xy location
stay_at_top:
        LDD   #$5780                    ;(Y,X)=Begining of the left line
        STD   BarYpos
move_to_xy:
        JSR   Moveto_d                  ;Send the beam to (X,Y)pos
        LDX   #bckgnd                   ;X <- #bckgnd table
        RH_DRAW_VLC
        JSR   draw_supports             ;Draw the supprting bricks...
        PULS  x,y,u,d                   ;Restore registers from the stack
        RTS                             ;Return to caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; draw_supports: Draw the supporting bricks under the horizontal bar.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
draw_supports:
        LDY   #bricks_loc
        LDA   ManHit                    ;A <- Number of support bricks to draw
        STA   BricksCnt
        ASLA
        ASLA                            ;A <- A*4
        LEAY  a,y
put_more_bricks:
        RESET_0_REF_D0
        LDA   BricksCnt                 ;A <- Number of support bricks to draw
        CMPA  #MAN_HITS_TO_BONUS
        LBGE  bonus_round
        LDA   ,y+                       ;A <- Ypos of brick to be drawn
        LDB   ,y+                       ;B <- Xpos of brick to draw (left)
        RH_MOVE_TO_D
        LDX   #single_brick             ;X<-Address[Brick]
 LDA   #$7F/8                      ;A <- $7F scaling factor
 STA   VIA_t1_cnt_lo             ;Store the scaling factor in the VIA
        RH_DRAW_VLC
        RESET_0_REF_D0
 LDA   #$7F                      ;A <- $7F scaling factor
 STA   VIA_t1_cnt_lo             ;Store the scaling factor in the VIA
        LDA   ,y+                       ;A <- Ypos of brick to be drawn
        LDB   ,y+                       ;B <- Xpos of brick to draw (right)
        RH_MOVE_TO_D
        LDX   #single_brick             ;X<-Address[Brick]
 LDA   #$7F/8                      ;A <- $7F scaling factor
 STA   VIA_t1_cnt_lo             ;Store the scaling factor in the VIA
        RH_DRAW_VLC
 LDA   #$7F                      ;A <- $7F scaling factor
 STA   VIA_t1_cnt_lo             ;Store the scaling factor in the VIA
        INC   BricksCnt
        BRA   put_more_bricks
bonus_round:
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; bricks_loc - predefined location for the support bricks (located under the
;              horizontal bar)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
bricks_loc:
        DB    $37,$80,$37,$6F           ;Brick #0 locations
        DB    $3F,$90,$3F,$5F           ;Brick #1 locations
        DB    $3F,$80,$3F,$6F           ;Brick #2 locations
        DB    $47,$A0,$47,$4F           ;Brick #3 locations
        DB    $47,$90,$47,$5F           ;Brick #4 locations
        DB    $47,$80,$47,$6F           ;Brick #5 locations
        DB    $4F,$B0,$4F,$3F           ;Brick #6 locations
        DB    $4F,$A0,$4F,$4F           ;Brick #7 locations
        DB    $4F,$90,$4F,$5F           ;Brick #8 locations
        DB    $4F,$80,$4F,$6F           ;Brick #9 locations


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; print_info: This procedure is responsible for prinitng game info such as:
;             Score, High score, car speed, cars left etc.
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
print_info:
        RESET_0_REF_D0
print_values:
        LDD   #$8080                    ;YX position of the score
        LDU   #Score_tbl                ;u points to the score string
        JSR   Print_Str_d               ;Print the score!

;;      *** DEBUG ***
;;      LDX   #dbg1_tbl
;;      JSR   Clear_Score
;;      LDA   CurBombsNum;  BombsInPile
;;      LDX   #dbg1_tbl
;;      JSR   Add_Score_a
;
;;      LDD   #$8000
;;      LDU   #dbg1_tbl
;;      JSR   Print_Str_d


;;      LDX   #dbg2_tbl
;;      JSR   Clear_Score
;;      LDA   CurLvlBombs
;;      LDX   #dbg2_tbl
;;      JSR   Add_Score_a
;;
;;      LDD   #$8050
;;      LDU   #dbg2_tbl
;;      JSR   Print_Str_d
;;      *** DEBUG END ***
;;
        RTS                             ;Return to caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; do_explosion - Is called when the player misses a bomb and it hits the bottom
;                of the screen...
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
do_explosion:
        PSHS  x
        JSR   Intensity_7F              ;Bright explosion...
explsn_loop:
                                        ;Do some graphics...
        JSR   Reset0Ref_D0              ;Move the beam to (0,0)
        LDA   #$7F                      ;A <- Explostion Scale
        STA   VIA_t1_cnt_lo             ;Set the VIA t1 to the new scale
        LDA   ,x                        ;A <- Ypos of the current bomb
        ADDA  #$0A
        LDB   1,x                       ;B <- Xpos of the current bomb
        ADDB  #$05
        JSR   Moveto_d                  ;Move beam to the explosion location
        LDX   #explsn_vec_list          ;X <- Address[ExplosionVectorList]
        LDA   explsn_scale              ;A <- Explostion Scale
        STA   VIA_t1_cnt_lo             ;Set the VIA t1 to the new scale
        JSR   Draw_VLc                  ;Draw the EXPLOSIN*!@#$

                                        ;Do some sounds...
        ;LDU   #explosion_sound
        ;JSR   make_the_sound

        LDA   #$0A
        STA   hitSndFlag
                                        ;Do some delay...
        LDU  #$0000
        LEAY 50,u
delay_loop:
        LDB   #$7F
        JSR  Delay_b
        LEAY  -1,y
        BNE   delay_loop
cont_to_draw_rest:
        LDA   #$7F                      ;A <- Explostion Scale
        STA   VIA_t1_cnt_lo             ;Set the VIA t1 to the normal scale
        PULS  x
        RTS

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;*****************************************************************************
check_snd:
        PSHS  x
is_hit:
        LDA   hitSndFlag
        BNE   hit_snd
        BRA   is_catch
hit_snd:
        DEC   hitSndFlag
        BNE   do_hit_snd
stop_hit_snd:
        LDB   $C807                     ;B=current channel activity
        ORB   #$09                      ;Deactivate Tone+Noise1 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte
        BRA   is_catch

do_hit_snd:
        LDB   #$1D                      ;Noise value
        LDA   #$06                      ;Sound reg, 0x06
        JSR   Sound_Byte
        LDA   hitSndFlag                ;A<- current index to volume
        LDX   #explsn_vol               ;X<- *ptr to explosion volume
        LDB   a,x                       ;B<- current explosion volume
        LDA   #$08                      ;Sound reg. Volume 1
        JSR   Sound_Byte
        LDB   $C807                     ;B=current channel activity
        ANDB  #$F7                      ;Activate Noise1 (reset)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte

is_catch:
        LDA   catchSndFlag
        BNE   catch_snd

        BRA   is_good
catch_snd:
        DEC   catchSndFlag
        BNE   do_catch_snd
        LDB   $C807                     ;B=current channel activity
        ORB   #$12                      ;Deactivate Tone+Noise2 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte
        BRA   is_good
do_catch_snd:
        LDX   #catch_tones
        LDA   catchSndFlag
        LDB   a,x                       ;Tone 2 LSB value
        LDA   #$02                      ;Sound reg, 0x00
        JSR   Sound_Byte
        LDB   #$00                      ;Tone 2 MSB value
        LDA   #$03                      ;Sound reg. 0x01
        JSR   Sound_Byte
        LDB   #$0F                      ;Channel 2 Max. volume
        LDA   #$09                      ;Sound reg. Volume 2
        JSR   Sound_Byte
        LDB   $C807                     ;B=current channel activity
        ANDB  #$FD                      ;Activate Tone2 (reset)
        ORB   #$10                      ;Deactivate Noise2 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte

is_good:                                ;using channel 3
        LDA   goodSndFlag
        BNE   good_snd

        BRA   is_man_fall
good_snd:
        DEC   goodSndFlag
        BNE   do_good_snd
        LDB   $C807                     ;B=current channel activity
        ORB   #$24                      ;Deactivate Tone+Noise3 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte
        BRA   is_man_fall
do_good_snd:
        LDX   #good_tones
        LDA   goodSndFlag
        LDB   a,x                       ;Tone 3 LSB value
        LDA   #$04                      ;Sound reg, 0x00
        JSR   Sound_Byte
        LDB   #$00                      ;Tone 3 MSB value
        LDA   #$05                      ;Sound reg. 0x01
        JSR   Sound_Byte
        LDB   #$0F                      ;Channel 3 Max. volume
        LDA   #$0A                      ;Sound reg. Volume 3
        JSR   Sound_Byte
        LDB   $C807                     ;B=current channel activity
        ANDB  #$FB                      ;Activate Tone3 (reset)
        ORB   #$20                      ;Deactivate Noise3 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte

is_man_fall:
        LDA   fallSndFlag
        BNE   fall_snd

        BRA   is_bad
fall_snd:
        DEC   fallSndFlag
        BNE   do_fall_snd
        LDB   $C807                     ;B=current channel activity
        ORB   #$24                      ;Deactivate Tone+Noise3 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte
        BRA   is_bad
do_fall_snd:
        LDB   fallSndFlag
        ADDB  #$64
        LDA   #$04                      ;Sound reg, 0x00
        JSR   Sound_Byte
        LDB   #$00                      ;Tone 3 MSB value
        LDA   #$05                      ;Sound reg. 0x01
        JSR   Sound_Byte
        LDB   #$0F                      ;Channel 3 Max. volume
        LDA   #$0A                      ;Sound reg. Volume 3
        JSR   Sound_Byte
        LDB   $C807                     ;B=current channel activity
        ANDB  #$FB                      ;Activate Tone3 (reset)
        ORB   #$20                      ;Deactivate Noise3 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte

is_bad:
        LDA   badSndFlag
        BNE   bad_snd

        BRA   noSnd
bad_snd:
        DEC   badSndFlag
        BNE   do_bad_snd
        LDB   $C807                     ;B=current channel activity
        ORB   #$24                      ;Deactivate Tone+Noise3 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte
        BRA   noSnd
do_bad_snd:
        LDB   #$FF                      ;Channel 3 constant tone
        LDA   #$04                      ;Sound reg, 0x00
        JSR   Sound_Byte
        LDB   #$00                      ;Tone 3 MSB value
        LDA   #$05                      ;Sound reg. 0x01
        JSR   Sound_Byte
        LDA   badSndFlag
        LDX   #bad_vol
        LDB   a,x                       ;Tone 3 LSB value
        LDA   #$0A                      ;Sound reg. Volume 3
        JSR   Sound_Byte
        LDB   $C807                     ;B=current channel activity
        ANDB  #$FB                      ;Activate Tone3 (reset)
        ORB   #$20                      ;Deactivate Noise3 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte


noSnd:
        PULS  x
        RTS

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
explsn_vol:
        DB   $0F
        DB   $0F
        DB   $0F
        DB   $0A
        DB   $0A
        DB   $0A
        DB   $07
        DB   $07
        DB   $07
        DB   $03
        DB   $02


catch_tones:
        DB   $FF
        DB   $FF
        DB   $FF
        DB   $EF
        DB   $EF

good_tones:
        DB   $FF
        DB   $FF
        DB   $FF
        DB   $DF
        DB   $DF
        DB   $DF
        DB   $BF
        DB   $BF
        DB   $BF
        DB   $9F
        DB   $9F
        DB   $9F


bad_vol:
        DB   $0F
        DB   $0F
        DB   $0F
        DB   $00
        DB   $0F
        DB   $0F
        DB   $0F
        DB   $00
        DB   $0F
        DB   $0F
        DB   $0F



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;*****************************************************************************
check_status:
        LDA   gameOverFlag
        LBNE  game_over
        LDA   ManHit                    ;Check if the man was hit more than
        CMPA  #MAN_HITS_TO_BONUS        ;the min. for bonus round
        BNE   chck_drop_bar             ;if not, proceed to level init
        CLR   ManHit                    ;clear current counter
        INC   BonusRndFlag              ;Set the Bonus round flag
        INC   dropManFlag
        LDA   #$60
        STA   fallSndFlag
        LDA   CurLvlBombs               ;In case of bonus, terminate current
        STA   BombsInPile               ;level by "faking"...
        BRA   goto_level_init
chck_drop_bar:
        LDA   dropManFlag
        BEQ   no_bonus_now
        RTS
no_bonus_now:
        LDA   BombsInPile               ;a=amount of bombs in pile
        CMPA  CurLvlBombs               ;check if levle done...
        BNE   prnt_menu                 ;if not, do nothing here and continue
        CLR   BonusRndFlag

goto_level_init:
        JSR   level_init                ;Prepare variables for next level
        INC   PrintMenuFlag             ;Indicate that the menu has to be shown
        LDA   BonusRndFlag
        BEQ   prnt_menu
        LDA   #$01                      ;Set flag for bonus round music
        STA   Vec_Music_Flag            ;
prnt_menu:
        JSR   do_menu
        RTS



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; do_menu: This procedure is responsible to write the menus of the game. It
;          displays different lines based on the game's mode. At the end, it
;          deletes all the menu lines...
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
do_menu:
        LDA   PrintMenuFlag             ;indication flag: 1=print, 0=no print
        BNE   prepare_menu              ;If "print" menu, goto wait for inputs
        RTS                             ;Otherwise, return to main loop.
prepare_menu:
        JSR   Intensity_7F              ;
        LDA   BonusRndFlag              ;Check bonus round flag,
        BEQ   prnt_reg_menu             ;if cleared, regular menu to be printed
prnt_bonus_menu:
        LDU   #bonus_str                ;otherwise, bonus menu to be printed
        JSR   Print_Str_xy
        RTS                             ;return to caller
prnt_reg_menu:
        LDU   #menu_ram_str             ;print the regular menu line
        PRINT_STR_YX                    ;Call enhenced print routine
        RTS                             ;return to caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; prnt_lvl_menu - Responsible to print the level menus
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;prnt_lvl_menu:
;       LDA   CurrentLvl
;       CMPA  #LVL1                     ;Check if CurrentLvl == LVL1,
;       BNE   chk_lvl2                  ;If not, check if LVL2...
;       LDU   #menu_lvl1_line1_str      ;U <- Point to menu_lvl1_line1_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       LDU   #lvl1_str
;       BRA   print_lvl                 ;Proceed to end of the procedure
;chk_lvl2:
;       CMPA  #LVL2                     ;Check if CurrentLvl == LVL2,
;       BNE   chk_lvl3                  ;If not, check if LVL3...
;       LDU   #menu_lvl2_line1_str      ;U <- Point to menu_lvl2_line1_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       LDU   #lvl2_str
;       BRA   print_lvl                 ;Proceed to end of the procedure
;chk_lvl3:
;       LDU   #menu_lvl3_line1_str      ;U <- Point to menu_lvl3_line1_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       LDU   #lvl3_str
;print_lvl:
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       LDU   #menu_line2_str           ;Always print menu_line2_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       RTS
;
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; prnt_explsn_menu - Responsible to print the menus after an explosion occured
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;prnt_explsn_menu:
;       LDU   #menu_explsn_line1_str    ;U <- Point to menu_explsn_line1_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       LDU   #menu_explsn_line2_str    ;U <- Point to menu_explsn_line1_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       LDU   #menu_line2_str           ;U <- Point to menu_line2_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       RTS                                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;******************************************************************************
; convert a to ASCII, assumes u -> *start of string, 42,u: MSB, 43,u: LSB
;******************************************************************************
a_to_hex:
        PSHS  a
        PSHS  a
                                        ;Calculate ASCII for MSB
        LSRA
        LSRA
        LSRA
        LSRA
        CMPA #$09
        BLS  addm_0x30
        ADDA #$07
addm_0x30:
        ADDA #$30
        ;STA  42,u                      ;Store the MS nibble in location8 of the                                        ;current line
        STA  43,u                       ;Store the MS nibble in location8 of the                                        ;current line

        PULS  a                         ;Calculate ASCII for LSB
        ANDA  #$0F
        CMPA #$09
        BLS  addl_0x30
        ADDA #$07
addl_0x30:
        ADDA  #$30
        ;STA   43,u                     ;Store the LS nibble in location9 of the
        STA   44,u                      ;Store the LS nibble in location9 of the
                                        ;current line
        PULS  a
        RTS                             ;Return to the caller



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;*****************************************************************************
d_to_bcd:
        LDU   #$0000
check_1000:
        CMPD  #$3E7                     ;More than 1,000?
        BLS   check_100
        SUBD  #$3E8                     ;Sub 1,000 from D,
        LEAU  $1000,u                   ;Add 1,000 to u
        BRA   check_1000                ;Proceed, till D < 1000
check_100:
        CMPD  #$63                      ;More than 100?
        BLS   check_10
        SUBD  #$64                      ;Sub 100 from D,
        LEAU  $100,u                    ;Add 100 to u
        BRA   check_100                 ;Proceed, till d < 100
check_10:
        CMPD  #$09                      ;More than 9?
        BLS   complete_bcd
        SUBD  #$0A                      ;Sub 10 from d,
        LEAU  $10,u                     ;Add 10 to u
        BRA   check_10                  ;Proceed, till d < 10
complete_bcd:
        LEAU  d,u                       ;Add the remain to u
        TFR   u,d
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; setjoystick - Enables the Joysticks controllers. In this case, Joystick #2
;               is disabled.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
setjoystick:
        LDX   #JOYENS
        LDA   #1                        ;Enable Joystick1 X doamin1
        STA   ,X+
        CLRA
        STA   ,X+                       ;Disable Joystick1 Y domain
        STA   ,X+                       ;Disable Joystick2 X domain
        STA   ,X+                       ;Disable Joystick2 Y doamin
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; checkjoystick - Monitors Joystic1 movement and set the player's car postion
;                 and speed accordingly.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
checkjoystick:
;        CLR   Vec_Misc_Count
        LDA   JoyType
        BNE   analog_stick
digital_stick:
        JSR   Joy_Digital               ;Read joystick position
        LDB   Pile1Xpos
        LDA   Vec_Joy_1_X               ;A <- Xpos of joystick 1
        BEQ   x_done
        BMI   left_move
        BRA   right_move
analog_stick:
        JSR   Joy_Analog
        LDB   Vec_Joy_1_X
        CMPB  #MAX_RIGHT_MOV
        BGE   chk_btns                  ;IF (lower or same) goto x_done
        CMPB  #MAX_LEFT_MOV
        BLE   chk_btns                  ;IF (lower or same) goto x_done
        CMPB  LastAnalogVal
        BLT   rot_left


;       LDA   #MAX_RIGHT_MOV
;       CMPA  Vec_Joy_1_X               ;Check if got to right limit
;       BLE   chk_btns                  ;IF (lower or same) goto x_done
;       LDA   #MAX_LEFT_MOV
;       CMPA  Vec_Joy_1_X               ;Check if got to left limit
;       BGE   chk_btns                  ;IF (lower or same) goto x_done
;       LDB   Vec_Joy_1_X               ;B <- Xpos of joystick 1
;       CMPB  LastAnalogVal
;       BLT   rot_left
rot_right:
        CLR   PileMoveDir
        BRA   analog_done
rot_left:
        INC   PileMoveDir
analog_done:
        STB   LastAnalogVal
        BRA   x_done
right_move:
        LDA   #MAX_RIGHT_MOV
        CMPA  Pile1Xpos                 ;Check if got to right limit
        BLE   x_done                    ;IF (lower or same) goto x_done

        ADDB  #MOVE_PILE_SPEED
        CLR   PileMoveDir
        BRA   x_done
left_move:
        LDA   #MAX_LEFT_MOV
        CMPA  Pile1Xpos                 ;Check if got to left limit
        BGE   x_done                    ;IF (lower or same) goto x_done

        SUBB  #MOVE_PILE_SPEED
        INC   PileMoveDir
x_done:
        STB   Pile1Xpos
        STB   Pile2Xpos
        STB   Pile3Xpos

chk_btns:
        JSR   check_btns
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; check_btns: Responsible for checking if a button was pressed. If so, checks
;             which button. Since only one button is used in the game and only
;             to exit a displayed menu, once button1 is pressed, the flag
;             (indicating end of the menu) is cleared.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
check_btns:
        JSR   Read_Btns                 ; Get Buttons status
        CMPA  #$00
        BEQ   return_back
check_btn1_1and4:
        BITA  #$09
        BEQ   return_back
        CLR   PrintMenuFlag             ;Clear menu flag
        JSR   stop_music
return_back:
        RTS                             ;Return to the caller



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; game_over - End of game screen, displays the score, hiscore and a comment to
;             press any key to continue...
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
game_over:
        JSR   stop_music                ;As first step...
        LDX   #Score_tbl                ;X points to current score table
        LDU   #Vec_High_Score           ;U points to Vectrex HiScore table
        JSR   New_High_Score            ;Compare and update HiScore table

closing_loop:
        LDA   Vec_Music_Flag            ;Check sound flag
        BNE   no_flag_set               ;if not cleared -> keep playing
        LDA   #$01                      ;if cleared -> set it for more music
        STA   Vec_Music_Flag            ;Constant playing of sound...

no_flag_set:
        JSR   DP_to_D8                  ;DP to RAM
        LDU   #Music3                   ;
        JSR   Init_Music_chk            ;Check sound parameters
        JSR   Wait_Recal                ;Screen refresh
        JSR   Do_Sound                  ;Play the sounds

        JSR   Intensity_7F              ;Set the intensity to $7F
        JSR   Reset0Ref_D0

        LDD   #SCORE_POS                ;Set D to the (Y,X) of the HiScore
        LDU   #Score_tbl                ;U Points to the Score table
        JSR   Print_Str_d               ;Print the HighScore on the screen

        LDA   cheatOnFlag               ;
        BNE   no_hi_score               ;
        LDD   #HSCORE_POS               ;Set D to the (Y,X) of the HiScore
        LDU   #Vec_High_Score           ;U Points to the HiScore table
        JSR   Print_Str_d               ;Print the HighScore on the screen
no_hi_score:
        LDU   #score_string
        JSR   Print_Str_xy
        LDU   #hscore_string
        JSR   Print_Str_xy
        LDU   #close0_string
        JSR   Print_Str_xy
        LDU   #close1_string
        JSR   Print_Str_xy

                                        ;Check btn1
        JSR   Read_Btns                 ;Get Buttons status
        CMPA  #$00
        BEQ   closing_loop              ;wait_btn
        BITA  #$0F
        BEQ   closing_loop              ;wait_btn
                                        ;@ this point btn1_1 was pressed...
        JSR   Cold_Start                ;SoftReset to the system
        RTS                             ;Return to caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; The following are tables of text to be displayed while the game is ongoing
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
menu_rom_str:
        DB 00,-100,$81, "WELCOME!   PRESS BUTTON 1 TO PLAY LEVEL 1  ",$81, $80

welcome_str:
        DB      00,-100,$81, "WELCOME!  "

mark_str:
        DB      00,-100,$81, "NOT BAD..."
        DB      00,-100,$81, "GOOD...   "
        DB      00,-100,$81, "VERY GOOD!"
        DB      00,-100,$81, "COOL!     "
        DB      00,-100,$81, "WOW!!!    "
        DB      00,-100,$81, "GREAT!    "
        DB      00,-100,$81, "SUPER!    "
        DB      00,-100,$81, "SUPER COOL"
        DB      00,-100,$81, "WAY COOL.."
        DB      00,-100,$81, "EXCELLENT!"
        DB      00,-100,$81, "AMAZING!!!"
        DB      00,-100,$81, "TOO GOOD! "
        DB      00,-100,$81, "INCREDABLE"
        DB      00,-100,$81, "INCREDABLE"
        DB      00,-100,$81, "INCREDABLE"
        DB      00,-100,$81, "INCREDABLE"
        DB      00,-100,$81, "INCREDABLE"
        DB      00,-100,$81, "INCREDABLE"
        DB      00,-100,$81, "INCREDABLE"
        DB      00,-100,$81, "INCREDABLE"

bonus_str:
        DB      00,-100, "BONUS ROUND IS ABOUT TO BEGIN...", $80

bonus_clr:
        DB      00,-100, "                                ", $80

menu_rom_clr_str:
        DB      00,-100, "                                           ", $80

open0_string:
        DB       80,-120,$81, "WELCOME TO", $81

open1_string:
        DB      -30,-60,$81, "g RONEN HABOT 3-1-2000", $81

open2_string:
        DB      -60,-110,$81, "PRESS 1 TO PLAY WITH VECTREX CONTROLLER, OR", $81

open3_string:
        DB      -75,-90,$81, " 4 TO PLAY WITH MODIFIED 2600 PADDLE", $81

score_string:
        DB      $5F,$A0, "SCORE", $80

hscore_string:
        DB      $5F,$30, "HI SCORE", $80

close0_string:
        DB       20,-20, "GAME OVER!", $80

close1_string:
        DB      -20,-65, "PRESS ANY BUTTON TO CONTINUE", $80


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; The following are Vector List table for the different sprites/letters/whatever
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
car1_vector_list:

; no need for patterns!!!
man: FCB 22
     FCB 30*4,0*4
     FCB 10*4,10*4
     FCB 0*4,15*4
     FCB 5*4,0*4
     FCB 5*4,-5*4
     FCB 10*4,0*4
     FCB 5*4,5*4
     FCB 0*4,10*4
     FCB -5*4,5*4
     FCB -10*4,0*4
     FCB -5*4,-5*4
     FCB -5*4,0*4
     FCB 0*4,15*4
     FCB -10*4,10*4
     FCB -30*4,0*4
     FCB 0*4,-10*4
     FCB 25*4,0*4
     FCB 0*4,-5*4
     FCB -25*4,0*4
     FCB 0*4,-30*4
     FCB 25*4,0*4
     FCB 0*4,-5*4
     FCB -25*4,0*4
     FCB 0*4,-10*4


bomb:
      FCB 11
      FCB 2*12,-2*12
      FCB 7*12,0*12
      FCB 2*12,2*12
      FCB 0*12,2*12
      FCB 2*12,0*12
      FCB 0*12,2*12
      FCB -2*12,0*12
      FCB 0*12,2*12
      FCB -2*12,2*12
      FCB -7*12,0*12
      FCB -2*12,-2*12
      FCB 0*12,-7*12
;      FCB 2*18,-2*18
;      FCB 7*18,0*18
;      FCB 2*18,2*18
;      FCB 0*18,2*18
;      FCB 2*18,0*18
;      FCB 0*18,2*18
;      FCB -2*18,0*18
;      FCB 0*18,2*18
;      FCB -2*18,2*18
;      FCB -7*18,0*18
;      FCB -2*18,-2*18
;      FCB 0*18,-7*18
heart:
        FCB 9
        FCB 6,-5
        FCB 2,0
        FCB 2,2
        FCB 0,2
        FCB -3,1
        FCB 3,1
        FCB 0,2
        FCB -2,2
        FCB -2,0
        FCB -6,-5

diamond:
        FCB  9
        FCB  6,-5
        FCB  2,1
        FCB  0,8
        FCB  -2,1
        FCB  -6,-5
        FCB  6,-2
        FCB  0,4
        FCB  -6,-2
        FCB  6,5
        FCB  0,-10

ex:
        FCB 11
        FCB 0,3
        FCB 3,3
        FCB -3,3
        FCB 0,3
        FCB 3,-3
        FCB 3,3
        FCB 0,-3
        FCB -3,-3
        FCB 3,-3
        FCB 0,-3
        FCB -3,3
        FCB -3,-3


pile:  FCB 11
      FCB 2*3,0*3
      FCB 2*3,-2*3
      FCB -2*3,0*3
      FCB -2*3,2*3
      FCB -1*3,1*3 ;-10,10
      FCB 0*3,17*2*3 ;0,50
      FCB 1*3,1*3  ;10,10
      FCB 2*3,0*3
      FCB 2*3,-2*3
      FCB 0*3,-35*3 ;-19*2
      FCB -2*3,2*3
      FCB 0*3,35*3 ;19*2

bckgnd:
        FCB 7
        FCB 0,127
        FCB 0,127
        FCB 0,1
        FCB 8,0
        FCB 0,-127
        FCB 0,-127
        FCB 0,-1
        FCB -8,0

single_brick:
        FCB 3
        FCB 0*8,16*8-1
        FCB 8*8,0*8
        FCB 0*8,-16*8+1
        FCB -8*8,0*8

explsn_vec_list:
        FCB   23
        FCB    40,  20
        FCB   -40, -20
        FCB    30,  30
        FCB   -30, -30
        FCB    40,  60
        FCB   -40, -60
        FCB    20, -10
        FCB   -20,  10
        FCB    30, -30
        FCB   -30,  30
        FCB    20, -50
        FCB   -20,  50
        FCB   -10, -30
        FCB    10,  30
        FCB   -40, -50
        FCB    40,  50
        FCB   -30, -10
        FCB    30,  10
        FCB   -40,  10
        FCB    40, -10
        FCB   -50,  30
        FCB    50, -30
        FCB   -10,  40
        FCB    10, -40


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; print_vaboom -
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
print_vaboom:

        LDA   CurLtr
        CMPA  #$01
        BNE   print_a
print_v:
        LDD   #$0080                    ;Point to Left side of the screen
        LDX   #V_Vl
        JSR   move_ltr
        RTS
print_a:
        JSR   draw_v

        LDA   CurLtr
        CMPA  #$02
        BNE   print_b
        LDD   #$00A0                    ;Point to Left side of the screen
        LDX   #A_Vl
        JSR   move_ltr
        RTS
print_b:
        ;LDA   #$7F
        ;STA   VIA_t1_cnt_lo
        JSR   draw_a

        LDA   CurLtr
        CMPA  #$03
        BNE   print_o1
        LDD   #$00C0                    ;Point to Left side of the screen
        LDX   #B_Vl
        JSR   move_ltr
        RTS
print_o1:
        ;LDA   #$7F
        ;STA   VIA_t1_cnt_lo
        JSR   draw_b

        LDA   CurLtr
        CMPA  #$04
        BNE   print_o2
        LDD   #$00EA                    ;Point to Left side of the screen
        LDX   #O_Vl
        JSR   move_ltr
        RTS
print_o2:
        ;LDA   #$7F
        ;STA   VIA_t1_cnt_lo
        JSR   draw_o1

        LDA   CurLtr
        CMPA  #$05
        BNE   print_m
        LDD   #$000A                    ;Point to Left side of the screen
        LDX   #O_Vl
        JSR   move_ltr
        RTS
print_m:
        ;LDA   #$7F
        ;STA   VIA_t1_cnt_lo
        JSR   draw_o2

        LDA   CurLtr
        CMPA  #$06
        BNE   print_i
        LDD   #$002A                    ;Point to Left side of the screen
        LDX   #M_Vl
        JSR   move_ltr
        RTS
print_i:
        ;LDA   #$7F
        ;STA   VIA_t1_cnt_lo
        JSR   draw_m
        LDA   CurLtr
        CMPA  #$07
        BNE   vaboom_printed
        LDD   #$004A                    ;Point to Left side of the screen
        LDX   #i_Vl
        JSR   move_ltr
        RTS
vaboom_printed:
        JSR   draw_i
        RTS


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
draw_v:
        ;;;JSR   Reset0Ref_D0
        RESET_0_REF;_D0
        LDX   #V_Vl
        LDA   #$7f
        STA   VIA_t1_cnt_lo
        LDD   #$0080                    ;Point to Left side of the screen
        ;;;JSR   Moveto_d                       ;Send the beam to (X,Y)pos
        RH_MOVE_TO_D
        LDA   #$40
        STA   VIA_t1_cnt_lo
        ;;;JSR   Draw_VLp                       ;Actually draw the letter
        RH_DRAW_VLP
        RTS

draw_a:
        ;;;;JSR   Reset0Ref_D0
        RESET_0_REF;_D0
        LDX   #A_Vl
        LDA   #$7f
        STA   VIA_t1_cnt_lo
        LDD   #$00A0                    ;Point to Left side of the screen
        ;;;JSR   Moveto_d                       ;Send the beam to (X,Y)pos
        RH_MOVE_TO_D
        ;;;JSR   Draw_VLp                       ;Actually draw the letter
        LDA   #$40
        STA   VIA_t1_cnt_lo
        RH_DRAW_VLP
        RTS

draw_b:
        RESET_0_REF;_D0
        LDX   #B_Vl
        ;;;;JSR   Reset0Ref_D0
;        LDA   #$7f
 LDA   #$40
        STA   VIA_t1_cnt_lo
;        LDD   #$00C0                    ;Point to Left side of the screen
 LDD   #$0083                    ;Point to Left side of the screen
        ;;;JSR   Moveto_d                       ;Send the beam to (X,Y)pos
        RH_MOVE_TO_D
        ;;;JSR   Draw_VLp                       ;Actually draw the letter
        LDA   #$40
        STA   VIA_t1_cnt_lo
        RH_DRAW_VLP
        RTS

draw_o1:
        RESET_0_REF;_D0
        LDX   #O_Vl
        ;;;;JSR   Reset0Ref_D0
;        LDA   #$7f
 LDA   #$14
        STA   VIA_t1_cnt_lo
;        LDD   #$00EA                    ;Point to Left side of the screen
 LDD   #$0080                    ;Point to Left side of the screen
        ;;;JSR   Moveto_d                       ;Send the beam to (X,Y)pos
        RH_MOVE_TO_D
        ;;;JSR   Draw_VLp                       ;Actually draw the letter
        LDA   #$40
        STA   VIA_t1_cnt_lo
        RH_DRAW_VLP
        RTS


draw_o2:
        RESET_0_REF;_D0
        LDX   #O_Vl
        ;;;;JSR   Reset0Ref_D0
;        LDA   #$7f
 LDA   #$0a
        STA   VIA_t1_cnt_lo
;        LDD   #$000A                    ;Point to Left side of the screen
 LDD   #$0068                    ;Point to Left side of the screen
        ;;;JSR   Moveto_d                       ;Send the beam to (X,Y)pos
        RH_MOVE_TO_D
        ;;;JSR   Draw_VLp                       ;Actually draw the letter
        LDA   #$40
        STA   VIA_t1_cnt_lo
        RH_DRAW_VLP
        RTS

draw_m:
        RESET_0_REF;_D0
        ;;;;JSR   Reset0Ref_D0
        LDX   #M_Vl
;        LDA   #$7f
 LDA   #$28
        STA   VIA_t1_cnt_lo
;        LDD   #$002A                    ;Point to Left side of the screen
 LDD   #$007f                    ;Point to Left side of the screen
        ;;;JSR   Moveto_d                       ;Send the beam to (X,Y)pos
        RH_MOVE_TO_D
        ;;;JSR   Draw_VLp                       ;Actually draw the letter
        LDA   #$40
        STA   VIA_t1_cnt_lo
        RH_DRAW_VLP
        RTS

draw_i:
        RESET_0_REF;_D0
        LDX   #i_Vl
        ;;;JSR   Reset0Ref_D0
;        LDA   #$7f
 LDA   #$49
        STA   VIA_t1_cnt_lo
;        LDD   #$004A                    ;Point to Left side of the screen
 LDD   #$007f                    ;Point to Left side of the screen
        ;;;JSR   Moveto_d                       ;Send the beam to (X,Y)pos
        RH_MOVE_TO_D
        ;JSR   Draw_VLp                 ;Actually draw the letter
        LDA   #$40
        STA   VIA_t1_cnt_lo
        RH_DRAW_VLP
        RTS


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;A -> final Ypos
;B -> final Xpos
;X -> ptr to letter vector list
move_ltr:
prepare_param:
        TST   LtrParamSet
        BNE   process_ltr
        LDA   #$7C
        STA   TmpYpos
        STB   TmpXpos
        CLR   TmpScale
        INC   LtrParamSet
process_ltr:
        ;;;JSR   Reset0Ref_D0
        RESET_0_REF_D0
        LDA   #$7F
        STA   VIA_t1_cnt_lo
        LDD   TmpYpos
        ;;;JSR   Moveto_d                       ;Send the beam to (X,Y)pos
        RH_MOVE_TO_D
        LDA   TmpScale
        STA   VIA_t1_cnt_lo
        ;;;JSR   Draw_VLp                       ;Actually draw the letter
        RH_DRAW_VLP
        LDA   TmpYpos
        CMPA  #$00
        BNE   update_ltr_prm
        INC   CurLtr                    ;point to next letter
        CLR   LtrParamSet
        RTS
update_ltr_prm:
        LDA   TmpYpos
        SUBA  #$02
        STA   TmpYpos
        LDA   TmpScale
        ADDA  #$01
        STA   TmpScale
        RTS




;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
A_Vl:
        FCB -1,  50*2,   0*2
        FCB -1,   0*2,  30*2
        FCB -1, -50*2,   0*2
        FCB -1,   0*2, -10*2
        FCB -1,  20*2,   0*2
        FCB -1,   0*2, -10*2
        FCB -1, -20*2,   0*2
        FCB -1,   0*2, -10*2
        FCB  0,  30*2,  10*2
        FCB -1,  10*2,   0*2
        FCB -1,   0*2,  10*2
        FCB -1, -10*2,   0*2
        FCB -1,   0*2, -10*2
        FCB  1


V_Vl:
   fcb 0,0*2,10*2
   fcb -1,50*2,-10*2
   fcb -1,0*2,10*2
   fcb -1,-40*2,10*2
   fcb -1,40*2,0*2
   fcb -1,0*2,10*2
   fcb -1,-50*2,0*2
   fcb -1,0*2,-20*2
        FCB  1
B_Vl:
   fcb -1,0*2,40*2
   fcb -1,30*2,0*2
   fcb -1,0*2,-10*2
   fcb -1,20*2,0*2
   fcb -1,0*2,-30*2
   fcb -1,-50*2,0*2
   fcb 0,10*2,10*2
   fcb -1,0*2,20*2
   fcb -1,10*2,0*2
   fcb -1,0*2,-20*2
   fcb -1,-10*2,0*2
   fcb 0,30*2,0*2
   fcb -1,0*2,10*2
   fcb -1,-10*2,0*2
   fcb -1,0*2,-10*2
   fcb -1,10*2,0*2
        FCB  1
O_Vl:
   fcb -1,50*2,0*2
   fcb -1,0*2,30*2
   fcb -1,-50*2,0*2
   fcb -1,0*2,-30*2
   fcb 0,10*2,10*2
   fcb -1,0*2,10*2
   fcb -1,30*2,0*2
   fcb -1,0*2,-10*2
   fcb -1,-30*2,0*2
        FCB  1
M_Vl:
        fcb -1,50*2,0*2
        fcb -1,0*2,10*2
        fcb -1,-10*2,5*2
        fcb -1,10*2,5*2
        fcb -1,0*2,10*2
        fcb -1,-50*2,0*2
        fcb -1,0*2,-10*2
        fcb -1,30*2,0*2
        fcb -1,-10*2,-5*2
        fcb -1,10*2,-5*2
        fcb -1,-30*2,0*2
        fcb -1,0*2,-10*2
        FCB  1

i_Vl:
        fcb -1,10*2,0*2
        fcb -1,0*2,10*2
        fcb -1,-10*2,0*2
        fcb -1,0*2,-10*2
        fcb 0,15*2,0*2
        fcb -1,35*2,10*2
        fcb -1, 0*2,10*2
        fcb -1,-35*2,-10*2
        fcb -1,0*2,-10*2
        FCB  1



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; YM MUSIC related routines/data.
; This section is simply copy/paste from Chris Salomon's YM sound program that
; converts YM sounds to vectrex.
; The music original name is MLOVER
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
do_ym_sound:
                ldd     ym_data_current
                beq     do_ym_sound_done
                subd    #1
                std     ym_data_current
                clra
                sta     current_register
                ldu     #ym_data_start
next_reg:
                jsr    get_current_byte
                lda    current_register
                ; A PSG reg
                ; B data
                jsr Sound_Byte
                leau    STRUCTURE_LENGTH,u
                inc     current_register
                lda     current_register
                cmpa    #11
                bne     next_reg
do_ym_sound_done:
                RTS

no_valid_byte:
; no we must look at the bits
; a will be our bit register
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POSITION,u
                bne     byte_ready_1
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #$80
                stb     BIT_POSITION,u
byte_ready_1:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
;;;;;;;;;;;;;;;;;;; GET_BIT END
; zero flag show bit
; A is 1 or zero
                lbne     no_single_byte
single_byte:
                ; must be zero
                ; 1 is allways only 8 bit...
                inc      CURRENT_RLE_COUNTER+1,u
dechifer:
                clr       calc_bits
                clr       calc_coder
try_next_bit:
                lsl       calc_coder
                inc       calc_bits    ; increase used bits
;;;;;;;;;;;; GET_BIT_START
                ldb     BIT_POSITION,u
                bne     byte_ready
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #$80
                stb     BIT_POSITION,u
byte_ready:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
                beq     no_add     ; and if non zero
                inc     calc_coder
;;;;;;;;;;;; GET_BIT_END
no_add:
; we load one complete set of mapper index, bits, coder, map-value
                ldx       CURRENT_RLE_MAPPER,u
search_again:
                leax      3,x
                lda       ,x          ; load bits from map
                anda      #127         ; map out phrases
                cmpa      calc_bits      ; neu
                bgt       try_next_bit ; neu
                bne       search_again
                ldb       1,x          ; load coder-byte
                cmpb      calc_coder
                bne       search_again
                ldb       2,x           ; load current mapped byte!
; in b is the byte value we sought
; test for phrase
                lda       ,x          ; load bits from map
                anda     #128         ; map in phrases only
                beq      no_phrase_d
; if phrase, than in b the count of the phrase used
                ldx      CURRENT_PHRASE_START,u
                tstb
                beq     phrase_found
next_phrase:
                lda     ,x+
                leax    a,x
                decb
                bne     next_phrase
phrase_found:
                stx     CURRENT_IS_PHRASE,u
                clr     CURRENT_PHRASE_BYTE,u
                bra      out
no_phrase_d:
                clr      CURRENT_IS_PHRASE,u
                clr      CURRENT_IS_PHRASE+1,u
                stb      CURRENT_UNPACKED_BYTE,u
out:

; U pointer to data structure
; A number of register
get_current_byte:
; do we have a byte that is valid?
                ldd      CURRENT_RLE_COUNTER,u
                beq      no_valid_byte
; yep... use current byte
                ldx       CURRENT_IS_PHRASE,u
                beq       no_phrase
                lda       ,x+ ; length of phrase
                ldb       CURRENT_PHRASE_BYTE,u
                ldb       b,x ; this is the current byte
                stb       CURRENT_UNPACKED_BYTE,u
                inc       CURRENT_PHRASE_BYTE,u
                cmpa      CURRENT_PHRASE_BYTE,u
                bne       counter_not_minus_one
                clr       CURRENT_PHRASE_BYTE,u
                ldd       CURRENT_RLE_COUNTER,u
no_phrase:
                subd      #1
                std       CURRENT_RLE_COUNTER,u
counter_not_minus_one:
                ldb       CURRENT_UNPACKED_BYTE,u
                rts

no_single_byte:
; non single byte here... must decode
; first we look for how many bits the RLE counter spreads

                ; we already encountered a 1
                ; and we allways use + 2
                lda     #2
                sta     temp
more_bits:
                inc     temp
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POSITION,u
                bne     byte_ready_2
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #$80
                stb     BIT_POSITION,u
byte_ready_2:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
;;;;;;;;;;;;;;;;;;; GET_BIT END
                bne     more_bits
; in temp is the # of bits for the counter
; the following '#temp' bits represent the RLE count
; lsb first
                incb            ; we start at 1, since zero is an
                                ; 'own' 'subroutine',
                                ; which doesn't manipulate the temps
                stb     temp2   ; bit counter for shifting
                stb     temp3   ; bit counter for shifting
go_on:
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POSITION,u
                bne     byte_ready_3
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #$80
                stb     BIT_POSITION,u
byte_ready_3:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
                beq     end_here_3
; return 1
                ldb     #1
end_here_3:
;;;;;;;;;;;;;;;;;;; GET_BIT END
; in D now one bit at the right position for the RLE counter
                stb     CURRENT_RLE_COUNTER+1,u
; the first 3 (here only the first one) rounds
; we need not check for temp, since it is at least 3...
go_on_2:
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POSITION,u
                bne     byte_ready_4
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #$80
                stb     BIT_POSITION,u
byte_ready_4:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
                beq     end_here_4
; return 1
                ldb     #1
end_here_4:
                clra
shifting_not_yet_done:
                      LSLA               ; LSR A
                      LSLB               ; LSR B
                      BCC no_carry       ; if no carry, than exit
                      ORA #1             ; otherwise underflow from A to 7bit of B
no_carry:
                dec     temp3
                bne     shifting_not_yet_done
shifting_done:
; in D now one bit at the right position for the RLE counter
                addd    CURRENT_RLE_COUNTER,u
                std     CURRENT_RLE_COUNTER,u

                inc     temp2
                lda     temp2
                sta     temp3
                cmpa    temp
                bne     go_on_2
; now the current counter should be set

; we still need to dechifer the following byte...
                bra       dechifer

init_ym_sound:
                ldx     #ym_data_start
                ldd     #(STRUCTURE_LENGTH*11)
                jsr     Clear_x_d

                ldy     ,u++
                ldd     ,y
                std     ym_data_len
                std     ym_data_current
                ldb     #11
next_reg_init:
                ldy     ,u++
                sty     CURRENT_RLE_MAPPER,x
                ldy     ,u++
                sty     CURRENT_PHRASE_START,x
                ldy     ,u++
                sty     BYTE_POSITION,x
                leax    STRUCTURE_LENGTH,x
                decb
                bne     next_reg_init
                stu     ym_name
                RTS

;***************************************************************************
                ; END entry_point
;***************************************************************************

MLOVER_start:
 DW 1599 ; vbl_len
; translation data
; DB $13; bytes follow
; bits used, code, real 'byte'
MLOVER_reg_0:
 DB $02, $02, $34 ;400
 DB $82, $03, $00 ;450
 DB $03, $02, $70 ;200
 DB $03, $03, $B5 ;200
 DB $84, $01, $01 ;95
 DB $04, $02, $6B ;100
 DB $04, $03, $9C ;150
 DB $06, $03, $DD ;6
 DB $07, $04, $54 ;2
 DB $07, $05, $CB ;2
 DB $08, $01, $42 ;1
 DB $08, $02, $47 ;1
 DB $08, $03, $50 ;1
 DB $08, $04, $7C ;1
 DB $08, $05, $85 ;1
 DB $08, $06, $B1 ;1
 DB $08, $07, $E6 ;1
 DB $09, $01, $1B ;1
 DB $0A, $01, $12 ;1
; phrases follow
MLOVER_pd_0:
 DB $0A, $DD, $DD, $12, $47, $7C, $B1, $E6, $1B, $50, $85; 450
 DB $05, $DD, $DD, $54, $CB, $42; 95
; data follows
MLOVER_reg_0_data:
 DB $CA, $B2, $CF, $2D, $95, $65, $9E, $5B, $2A, $CB
 DB $3C, $B6, $55, $96, $79, $6C, $A5, $95, $BC, $AF
 DB $29, $65, $6F, $2B, $79, $4D, $E5, $37, $94, $E2
 DB $39, $56, $59, $E5, $B2, $AC, $B3, $CB, $65, $59
 DB $67, $96, $CA, $B2, $CF, $2D, $94, $B2, $B7, $95
 DB $E5, $2C, $AD, $E5, $6F, $29, $BC, $A6, $F2, $9C
 DB $47, $2A, $CB, $3C, $B6, $55, $96, $79, $6C, $AB
 DB $2C, $F2, $D9, $56, $59, $E5, $B2, $96, $56, $F2
 DB $BC, $A5, $95, $BC, $AD, $E5, $37, $94, $DE, $53
 DB $88, $E5, $59, $67, $96, $CA, $B2, $CF, $2D, $95
 DB $65, $9E, $5B, $2A, $CB, $3C, $B6, $52, $CA, $DE
 DB $57, $94, $B2, $B7, $95, $BC, $A6, $F2, $9B, $CA
 DB $71, $1C, $AB, $2C, $F2, $D9, $56, $59, $E5, $B2
 DB $AC, $B3, $CB, $65, $59, $67, $96, $CA, $59, $5B
 DB $CA, $F2, $96, $56, $F2, $B7, $94, $DE, $53, $79
 DB $4E, $C3, $20, $C1, $01, $40 ; flushed
; translation data
; DB $0A; bytes follow
; bits used, code, real 'byte'
MLOVER_reg_1:
 DB $82, $02, $00 ;450
 DB $02, $03, $04 ;543
 DB $03, $02, $05 ;150
 DB $83, $03, $02 ;260
 DB $84, $02, $01 ;95
 DB $04, $03, $09 ;100
 DB $05, $01, $01 ;6
 DB $05, $02, $02 ;9
 DB $05, $03, $08 ;10
 DB $06, $01, $03 ;4
; phrases follow
MLOVER_pd_1:
 DB $0A, $01, $01, $02, $02, $02, $02, $02, $03, $03, $03; 450
 DB $05, $01, $01, $02, $02, $03; 95
 DB $0D, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $04, $04, $04; 260
; data follows
MLOVER_reg_1_data:
 DB $3B, $EB, $2E, $77, $D6, $5C, $EF, $AC, $B9, $DF
 DB $59, $7C, $A7, $97, $59, $7C, $A7, $97, $59, $75
 DB $95, $2C, $A9, $65, $51, $23, $BE, $B2, $E7, $7D
 DB $65, $CE, $FA, $CB, $9D, $F5, $97, $CA, $79, $75
 DB $97, $CA, $79, $75, $97, $59, $52, $CA, $96, $55
 DB $12, $3B, $EB, $2E, $77, $D6, $5C, $EF, $AC, $B9
 DB $DF, $59, $7C, $A7, $97, $59, $7C, $A7, $97, $59
 DB $75, $95, $2C, $A9, $65, $51, $23, $BE, $B2, $E7
 DB $7D, $65, $CE, $FA, $CB, $9D, $F5, $97, $CA, $79
 DB $75, $97, $CA, $79, $75, $97, $59, $52, $CA, $96
 DB $55, $12, $3B, $EB, $2E, $77, $D6, $5C, $EF, $AC
 DB $B9, $DF, $59, $7C, $A7, $97, $59, $7C, $A7, $97
 DB $59, $75, $95, $2C, $A9, $65, $56, $29, $06, $42
 ; flushed
; translation data
; DB $2A; bytes follow
; bits used, code, real 'byte'
MLOVER_reg_2:
 DB $03, $04, $86 ;138
 DB $83, $05, $02 ;144
 DB $83, $06, $01 ;288
 DB $83, $07, $00 ;312
 DB $84, $04, $03 ;80
 DB $84, $05, $06 ;80
 DB $04, $06, $9F ;81
 DB $85, $04, $07 ;40
 DB $85, $05, $08 ;40
 DB $05, $06, $64 ;54
 DB $05, $07, $59 ;58
 DB $85, $0E, $05 ;90
 DB $85, $0F, $04 ;96
 DB $06, $04, $54 ;9
 DB $06, $05, $81 ;13
 DB $06, $06, $43 ;28
 DB $06, $07, $4B ;32
 DB $07, $04, $A9 ;5
 DB $07, $06, $70 ;8
 DB $08, $05, $48 ;3
 DB $08, $06, $46 ;4
 DB $08, $0A, $8B ;6
 DB $08, $0B, $A4 ;6
 DB $08, $0E, $B3 ;8
 DB $08, $0F, $00 ;9
 DB $09, $04, $05 ;2
 DB $09, $05, $3E ;2
 DB $09, $06, $4D ;2
 DB $09, $08, $9A ;2
 DB $09, $09, $FB ;2
 DB $09, $0E, $50 ;4
 DB $09, $0F, $5F ;5
 DB $0A, $01, $63 ;1
 DB $0A, $02, $6B ;1
 DB $0A, $03, $6E ;1
 DB $0A, $04, $75 ;1
 DB $0A, $05, $90 ;1
 DB $0A, $06, $AE ;1
 DB $0A, $07, $B8 ;1
 DB $0A, $0E, $5E ;2
 DB $0A, $0F, $69 ;2
 DB $0B, $01, $0A ;1
; phrases follow
MLOVER_pd_2:
 DB $06, $00, $FB, $00, $05, $0A, $05; 312
 DB $06, $86, $81, $86, $8B, $90, $8B; 288
 DB $06, $64, $5F, $64, $69, $6E, $69; 144
 DB $04, $9F, $9A, $9F, $A4; 80
 DB $06, $59, $54, $59, $5E, $63, $5E; 96
 DB $06, $43, $3E, $43, $48, $4D, $48; 90
 DB $0A, $70, $70, $70, $70, $70, $70, $70, $6B, $70, $75; 80
 DB $0A, $B3, $B3, $B3, $B3, $B3, $B3, $B3, $AE, $B3, $B8; 40
 DB $0A, $A9, $A4, $9F, $9A, $9F, $9F, $9F, $9F, $9F, $9F; 40
; data follows
MLOVER_reg_2_data:
 DB $98, $7F, $8B, $E0, $F0, $26, $6C, $49, $C9, $64
 DB $0B, $39, $1D, $36, $20, $93, $92, $C8, $16, $6C
 DB $40, $40, $59, $05, $24, $E4, $71, $66, $69, $51
 DB $80, $F9, $9A, $34, $B7, $81, $50, $15, $33, $C9
 DB $E3, $84, $99, $E4, $F1, $C2, $5C, $70, $30, $70
 DB $3A, $63, $45, $D3, $62, $4E, $4B, $20, $59, $C8
 DB $E9, $B1, $04, $9C, $96, $40, $B3, $62, $02, $02
 DB $C8, $29, $27, $23, $8B, $33, $4A, $8C, $07, $CC
 DB $D1, $A5, $BC, $0A, $80, $A9, $9E, $4F, $1C, $24
 DB $CF, $27, $8E, $12, $E3, $81, $83, $81, $D3, $1A
 DB $2E, $9B, $12, $72, $59, $02, $CE, $47, $4D, $88
 DB $24, $E4, $B2, $05, $9B, $10, $10, $16, $41, $49
 DB $39, $1C, $59, $9A, $54, $60, $3E, $66, $8D, $2D
 DB $E0, $54, $05, $4C, $F2, $78, $E1, $26, $79, $3C
 DB $70, $97, $1C, $0C, $1C, $0E, $98, $D1, $74, $D8
 DB $93, $92, $C8, $16, $72, $3A, $6C, $41, $27, $25
 DB $90, $2C, $D8, $80, $80, $B2, $0A, $49, $C8, $E2
 DB $CC, $D2, $A3, $01, $F3, $34, $69, $6F, $02, $A0
 DB $2A, $67, $93, $C7, $09, $33, $C9, $E3, $84, $B8
 DB $E0, $60, $E0, $74, $C6, $B3, $83, $00, $A1, $80
 DB $A0, $30 ; flushed
; translation data
; DB $03; bytes follow
; bits used, code, real 'byte'
MLOVER_reg_3:
 DB $01, $01, $00 ;1291
 DB $82, $01, $00 ;312
 DB $03, $01, $0F ;2
; phrases follow
MLOVER_pd_3:
 DB $06, $00, $00, $00, $00, $00, $0F; 312
; data follows
MLOVER_reg_3_data:
 DB $BC, $7C, $5B, $FF, $7F, $98 ; flushed
; translation data
; DB $2D; bytes follow
; bits used, code, real 'byte'
MLOVER_reg_4:
 DB $81, $01, $00 ;924
 DB $04, $04, $5A ;48
 DB $84, $06, $02 ;78
 DB $04, $07, $19 ;140
 DB $85, $04, $06 ;24
 DB $05, $06, $91 ;42
 DB $05, $07, $C3 ;45
 DB $85, $0A, $03 ;48
 DB $85, $0B, $01 ;70
 DB $06, $04, $0C ;16
 DB $06, $05, $3E ;16
 DB $06, $06, $66 ;16
 DB $86, $0A, $07 ;24
 DB $86, $0B, $04 ;40
 DB $07, $04, $8C ;5
 DB $07, $06, $00 ;8
 DB $07, $0E, $EF ;16
 DB $87, $0F, $05 ;24
 DB $08, $06, $23 ;3
 DB $08, $0A, $14 ;6
 DB $08, $0B, $55 ;6
 DB $08, $0E, $1E ;8
 DB $08, $0F, $E1 ;8
 DB $09, $03, $05 ;2
 DB $09, $04, $11 ;2
 DB $09, $05, $39 ;2
 DB $09, $06, $43 ;2
 DB $09, $08, $BE ;2
 DB $09, $0A, $F4 ;2
 DB $09, $0B, $07 ;3
 DB $09, $0E, $61 ;3
 DB $09, $0F, $96 ;4
 DB $0A, $01, $64 ;1
 DB $0A, $03, $CD ;1
 DB $0A, $05, $FB ;1
 DB $0A, $0E, $5F ;2
 DB $0A, $0F, $6B ;2
 DB $0A, $12, $C8 ;2
 DB $0A, $13, $EA ;2
 DB $0B, $01, $16 ;1
 DB $0B, $04, $70 ;1
 DB $0B, $05, $9B ;1
 DB $0B, $08, $DC ;1
 DB $0B, $09, $E6 ;1
 DB $0C, $01, $0A ;1
; phrases follow
MLOVER_pd_4:
 DB $06, $00, $FB, $00, $05, $0A, $05; 924
 DB $07, $14, $19, $1E, $23, $1E, $19, $14; 70
 DB $06, $55, $5A, $5F, $64, $5F, $5A; 78
 DB $08, $BE, $C3, $C8, $CD, $C8, $C3, $BE, $C3; 48
 DB $0A, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $DC, $E1, $E6; 40
 DB $06, $0C, $07, $0C, $11, $16, $11; 24
 DB $06, $66, $61, $66, $6B, $70, $6B; 24
 DB $06, $91, $8C, $91, $96, $9B, $96; 24
; data follows
MLOVER_reg_4_data:
 DB $98, $6F, $CB, $39, $17, $71, $C0, $4C, $38, $0A
 DB $98, $92, $1E, $10, $0B, $B8, $A0, $28, $50, $1A
 DB $63, $48, $81, $80, $EB, $B9, $78, $5C, $BC, $2E
 DB $5E, $17, $2F, $8E, $E0, $A3, $83, $AE, $E5, $9C
 DB $1C, $06, $07, $1C, $15, $73, $95, $73, $95, $73
 DB $95, $8C, $C0, $83, $01, $F3, $34, $8A, $18, $12
 DB $E8, $60, $5E, $14, $30, $2F, $0A, $49, $81, $72
 DB $2E, $E3, $80, $98, $70, $15, $31, $24, $3C, $20
 DB $17, $71, $40, $50, $A0, $34, $C6, $91, $03, $01
 DB $D7, $72, $F0, $B9, $78, $5C, $BC, $2E, $5F, $1D
 DB $C1, $47, $07, $5D, $CB, $38, $38, $0C, $0E, $38
 DB $2A, $E7, $2A, $E7, $2A, $E7, $2B, $19, $81, $06
 DB $03, $E6, $69, $14, $30, $25, $D0, $C0, $BC, $28
 DB $60, $5E, $14, $BB, $00 ; flushed
; translation data
; DB $05; bytes follow
; bits used, code, real 'byte'
MLOVER_reg_5:
 DB $81, $01, $00 ;918
 DB $02, $01, $02 ;349
 DB $03, $01, $01 ;260
 DB $04, $01, $00 ;76
 DB $05, $01, $0F ;2
; phrases follow
MLOVER_pd_5:
 DB $06, $00, $00, $00, $00, $00, $0F; 918
; data follows
MLOVER_reg_5_data:
 DB $B8, $83, $FA, $67, $E4, $47, $C9, $9F, $9D, $BF
 DB $05, $3E, $4D, $E7, $8F, $93, $3F, $3B, $7E, $0A
 DB $7E, $F2, $80 ; flushed
; translation data
; DB $01; bytes follow
; bits used, code, real 'byte'
MLOVER_reg_6:
 DB $01, $01, $15 ;1599
; phrases follow
MLOVER_pd_6:
; data follows
MLOVER_reg_6_data:
 DB $FF, $BF, $1C ; flushed
; translation data
; DB $06; bytes follow
; bits used, code, real 'byte'
MLOVER_reg_7:
 DB $02, $02, $3C ;410
 DB $02, $03, $38 ;430
 DB $03, $01, $34 ;200
 DB $03, $02, $3E ;210
 DB $03, $03, $30 ;239
 DB $04, $01, $36 ;110
; phrases follow
MLOVER_pd_7:
; data follows
MLOVER_reg_7_data:
 DB $E2, $AC, $A3, $CF, $59, $47, $9E, $B2, $8F, $3D
 DB $65, $1E, $7A, $CA, $3C, $F5, $94, $72, $AC, $A3
 DB $95, $65, $1C, $AB, $28, $E5, $5C, $51, $E2, $D9
 DB $4F, $3E, $CA, $79, $F6, $53, $CF, $B2, $9E, $7D
 DB $94, $F3, $EC, $A7, $2D, $94, $E5, $B2, $9C, $B6
 DB $53, $96, $E2, $9E, $2D, $94, $F3, $EC, $A7, $9F
 DB $65, $3C, $FB, $29, $E7, $D9, $4F, $3E, $CA, $72
 DB $D9, $4E, $5B, $29, $CB, $65, $39, $7E, $2B, $E2
 DB $F9, $5F, $3F, $CA, $F9, $FE, $57, $CF, $F2, $BE
 DB $7F, $95, $F3, $FC, $AF, $2F, $95, $E5, $F2, $BC
 DB $BE, $57, $97, $E2, $BE, $2F, $95, $F3, $FC, $AF
 DB $9F, $E5, $7C, $FF, $2B, $E7, $F9, $5F, $3F, $CA
 DB $F2, $F9, $5E, $5F, $2B, $CB, $E5, $79, $7E, $CB
 ; flushed
; translation data
; DB $08; bytes follow
; bits used, code, real 'byte'
MLOVER_reg_8:
 DB $81, $01, $00 ;1185
 DB $82, $01, $01 ;350
 DB $83, $01, $02 ;50
 DB $05, $01, $0D ;8
 DB $05, $02, $0E ;14
 DB $05, $03, $0F ;14
 DB $06, $01, $0C ;4
 DB $07, $01, $0B ;4
; phrases follow
MLOVER_pd_8:
 DB $0F, $0F, $0F, $0E, $0E, $0D, $0F, $0F, $0E, $0E, $0D, $0F, $0F, $0E, $0E, $0D; 1185
 DB $05, $0D, $0C, $0C, $0B, $0B; 350
 DB $0A, $0F, $0F, $0E, $0E, $0D, $0D, $0C, $0C, $0B, $0B; 50
; data follows
MLOVER_reg_8_data:
 DB $14, $A5, $29, $4A, $52, $94, $A5, $29, $4A, $65
 DB $14, $A5, $29, $4A, $52, $94, $A5, $29, $4A, $65
 DB $14, $A5, $29, $4A, $52, $94, $A5, $29, $4A, $65
 DB $14, $A5, $29, $4A, $52, $94, $A5, $29, $4A, $65
 DB $14, $A5, $29, $4A, $52, $94, $A5, $29, $4A, $59
 DB $0E, $42, $06, $43, $90, $81, $90, $E4, $20 ; flushed
; translation data
; DB $0E; bytes follow
; bits used, code, real 'byte'
MLOVER_reg_9:
 DB $02, $01, $00 ;320
 DB $82, $02, $01 ;400
 DB $82, $03, $00 ;720
 DB $83, $01, $02 ;150
 DB $06, $02, $0D ;3
 DB $06, $04, $09 ;4
 DB $06, $05, $06 ;5
 DB $06, $06, $07 ;6
 DB $06, $07, $08 ;6
 DB $07, $01, $0A ;3
 DB $07, $02, $0B ;3
 DB $07, $03, $0C ;3
 DB $07, $06, $0E ;3
 DB $07, $07, $0F ;3
; phrases follow
MLOVER_pd_9:
 DB $0A, $0F, $0F, $0F, $0E, $0E, $0E, $0D, $0D, $0D, $0C; 720
 DB $0A, $0C, $0C, $0B, $0B, $0B, $0A, $0A, $0A, $09, $09; 400
 DB $0A, $09, $08, $08, $08, $07, $07, $07, $06, $06, $06; 150
; data follows
MLOVER_reg_9_data:
 DB $FE, $02, $B2, $D3, $43, $6D, $35, $2D, $0C, $B4
 DB $D0, $DB, $4D, $4B, $43, $2D, $34, $36, $D3, $52
 DB $D0, $CB, $4D, $0D, $B4, $D4, $B4, $32, $D3, $43
 DB $6D, $35, $2D, $0C, $B4, $D0, $DB, $4D, $4B, $43
 DB $2D, $34, $36, $D3, $52, $D0, $CB, $4D, $0D, $B4
 DB $D4, $B4, $12, $C3, $D8, $69, $0A ; flushed
; translation data
; DB $10; bytes follow
; bits used, code, real 'byte'
MLOVER_reg_10:
 DB $01, $01, $00 ;959
 DB $83, $02, $02 ;120
 DB $83, $03, $00 ;330
 DB $84, $03, $01 ;80
 DB $05, $02, $0C ;24
 DB $05, $03, $0D ;24
 DB $85, $04, $04 ;24
 DB $85, $05, $03 ;30
 DB $06, $02, $08 ;9
 DB $07, $01, $0B ;4
 DB $07, $02, $09 ;6
 DB $07, $03, $0A ;6
 DB $07, $06, $0E ;9
 DB $07, $07, $0F ;9
 DB $08, $01, $07 ;2
 DB $09, $01, $06 ;2
; phrases follow
MLOVER_pd_10:
 DB $0F, $0F, $0F, $0E, $0E, $0D, $0D, $0C, $0C, $0B, $0B, $0A, $0A, $09, $09, $08; 330
 DB $05, $0F, $0F, $0E, $0E, $0D; 80
 DB $0A, $0F, $0F, $0F, $0F, $0F, $0E, $0E, $0E, $0E, $0E; 120
 DB $05, $0D, $0C, $0C, $0B, $0B; 30
 DB $04, $07, $07, $06, $06; 24
; data follows
MLOVER_reg_10_data:
 DB $FF, $22, $F8, $AA, $8E, $A2, $92, $A8, $EA, $28
 DB $BA, $98, $A3, $16, $40, $E4, $0A, $41, $09, $67
 DB $23, $14, $C1, $09, $66, $08, $48, $AA, $8E, $A2
 DB $92, $A8, $EA, $28, $BA, $98, $A3, $16, $40, $E4
 DB $0A, $41, $09, $67, $23, $14, $C1, $09, $66, $08
 DB $4E, $BC ; flushed
; This data does not appear in binary output!
MLOVER_data:
 DW MLOVER_start
 DW MLOVER_reg_0 - 3, MLOVER_pd_0, MLOVER_reg_0_data
 DW MLOVER_reg_1 - 3, MLOVER_pd_1, MLOVER_reg_1_data
 DW MLOVER_reg_2 - 3, MLOVER_pd_2, MLOVER_reg_2_data
 DW MLOVER_reg_3 - 3, MLOVER_pd_3, MLOVER_reg_3_data
 DW MLOVER_reg_4 - 3, MLOVER_pd_4, MLOVER_reg_4_data
 DW MLOVER_reg_5 - 3, MLOVER_pd_5, MLOVER_reg_5_data
 DW MLOVER_reg_6 - 3, MLOVER_pd_6, MLOVER_reg_6_data
 DW MLOVER_reg_7 - 3, MLOVER_pd_7, MLOVER_reg_7_data
 DW MLOVER_reg_8 - 3, MLOVER_pd_8, MLOVER_reg_8_data
 DW MLOVER_reg_9 - 3, MLOVER_pd_9, MLOVER_reg_9_data
 DW MLOVER_reg_10 - 3, MLOVER_pd_10, MLOVER_reg_10_data
SONG_DATA EQU MLOVER_data
MLOVER_name:
 DB $48, $45, $59, $2C, $4D, $55, $53, $49, $43, $20, $4C, $4F, $56, $45, $52, $21, $20, $28, $53, $27, $45, $58, $50, $52, $45, $53, $53, $29, $80
