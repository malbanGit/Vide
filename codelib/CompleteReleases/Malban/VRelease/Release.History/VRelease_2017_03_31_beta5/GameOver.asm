DO_Z_KOORDINATE     =        1 
                    INCLUDE  "3D_MAKRO.I"
END_RAM_START       =        SCROLL_RAM_START 
                    bss      
;
                    org      END_RAM_START 
                    INCLUDE  "3D_VAR.I"                   ; RAM locations reused
                    org      END_RAM_START 
;
spinSpeed_all       ds       2 
spawnDelay          ds       1 
expl_scale_base     ds       0 
armSpeed            ds       1 
endstage            ds       1 
stageCounter        ds       2 
counter_Arm         ds       1 
expandArms          ds       1 
addi_ex             ds       0 
angle_Arm1          ds       2 
angle_Arm2          ds       2 
angle_Arm3          ds       2 
;
                    struct   DotStruct 
                    ds       dangle, 2 
                    ds       dscale, 1 
                    ds       dintensity, 1 
                    end struct 
;
DOT_SPAWN_DELAY     =        4 
MAX_DOT_PER_ARM     =        24 
ARM_SPAWN_ANGLE_ADD  =       20 
SPIN_SPEED          =        6 
EXPAND_PER_FRAME    =        1 
; space for about 40 dots
dotsArm1            ds       DotStruct*MAX_DOT_PER_ARM 
dotsArm2            ds       DotStruct*MAX_DOT_PER_ARM 
dotsArm3            ds       DotStruct*MAX_DOT_PER_ARM 
;letters_3d ds Letter3d*8
letters_3d          =        start_letter_data 
armsEND             ds       0 
;
;
STAGE_1             equ      0 
STAGE_2             equ      1 
STAGE_3             equ      2 
STAGE_4             equ      3 
STAGE_5             equ      4 
STAGE_6             equ      5 
STAGE_7             equ      6 
STAGE_8             equ      7 
STAGE_1_LENGTH      equ      ($30*2)                      ;(4 seconds) 
STAGE_2_LENGTH      equ      ($30*2)                      ;(4 seconds) 
STAGE_3_LENGTH      equ      ($30*2)                      ;(4 seconds) 
STAGE_4_LENGTH      equ      ($40*2)                      ;(4 seconds) 
STAGE_5_LENGTH      equ      ($50*1)                      ;(4 seconds) 
STAGE_6_LENGTH      equ      ($50*2)                      ;(4 seconds) 
STAGE_7_LENGTH      equ      ($50*6)                      ;(4 seconds) 
SPAWN_ARM_DOT       macro    _angle_Arm, _dotsArm 
                    ldx      _angle_Arm 
                    leax     ARM_SPAWN_ANGLE_ADD,x 
                    cmpx     #720 
                    blt      not_oob\? 
                    leax     -720 ,x 
not_oob\?: 
                    stx      _angle_Arm 
                    ldu      #_dotsArm 
                    lda      counter_Arm 
                    lsla     
                    lsla                                  ; times for, each dot has 4 byte 
                    leau     a,u                          ; space for current dot 
                    lda      #$5f 
                    sta      dintensity,u 
                    lda      #$5 
                    sta      dscale,u 
                    stx      dangle,u 
                    endm     
                    code     
doGameOver 
                    lda      #DOT_SPAWN_DELAY 
                    sta      spawnDelay 
                    ldd      #0 
                    sta      counter_Arm 
                    std      angle_Arm1 
                    addd     #240 
                    std      angle_Arm2 
                    addd     #240 
                    std      angle_Arm3 
                    ldd      #SPIN_SPEED 
                    std      spinSpeed_all 
                    lda      #1 
                    sta      expandArms 
                    lda      #STAGE_1 
                    sta      endstage 
                    ldd      #STAGE_1_LENGTH 
                    std      stageCounter 



                    CLR      Vec_Music_Flag               ; no music is playing ->0 
                    JSR      Init_Music_Buf               ; shadow regs 
                    JSR      Do_Sound                     ; ROM function that does the sound playing 


mainGameOver:                                             ;#isfunction  
                    _ZERO_VECTOR_BEAM  
                                                          ; jsr getButtonState ; is a button pressed? 
                                                          ; lbne doreturn 
                    jsr      Wait_Recal 
;                    JSR      do_ym_sound2 
                    JSR      draw_Score_game              ; has a nice long moveto 
;
                    ldx      stageCounter 
                    leax     -1,x 
                    stx      stageCounter 
                    cmpx     #0 
                    bne      stage_continue 
                    inc      endstage 
                    lda      endstage 
                    cmpa     #STAGE_2 
                    beq      initStage2 
                    cmpa     #STAGE_3 
                    beq      initStage3 
                    cmpa     #STAGE_4 
                    beq      initStage4 
                    cmpa     #STAGE_5 
                    beq      initStage5 
                    cmpa     #STAGE_6 
                    beq      initStage6 
                    cmpa     #STAGE_7 
                    beq      initStage7 
                    cmpa     #STAGE_8 
                    beq      initStage8 
                    bra      stageInitDone 

initStage2 
                    ldd      #STAGE_2_LENGTH 
                    std      stageCounter 
                    bra      stageInitDone 

initStage3 
                    ldd      #STAGE_3_LENGTH 
                    std      stageCounter 
                    bra      stageInitDone 

initStage4 
                    ldd      #STAGE_4_LENGTH 
                    std      stageCounter 
                    lda      #-1 
                    sta      expandArms 
                    bra      stageInitDone 

initStage5 
                    ldd      #STAGE_5_LENGTH 
                    std      stageCounter 
                    bra      stageInitDone 

initStage6 
                    lda      #5 
                    sta      expl_scale_base 
                    ldd      #STAGE_6_LENGTH 
                    std      stageCounter 
                    bra      stageInitDone 

initStage7 
                    ldd      #STAGE_7_LENGTH 
                    std      stageCounter 
                    bra      stageInitDone 

initStage8 
                    jmp      do3dGameOver 

stageInitDone: 
stage_continue: 
                    lda      endstage 
                    cmpa     #STAGE_1 
                    lbeq     do_stage1_stuff 
                    cmpa     #STAGE_2 
                    lbeq      do_stage2_stuff 
                    cmpa     #STAGE_3 
                    beq      do_stage3_stuff 
                    cmpa     #STAGE_4 
                    beq      do_stage4_stuff 
                    cmpa     #STAGE_5 
                    beq      do_stage5_stuff 
                    cmpa     #STAGE_6 
                    beq      do_stage6_stuff 
                    cmpa     #STAGE_7 
                    beq      do_stage7_stuff 
                    lbra      endofstagestuff 

do_stage7_stuff 
                                                          ; display game over 
                    jmp      do3dGameOver 

                    rts      

                    bra      mainGameOver 

do_stage6_stuff 
                                                          ; might explosion 
                    lda      #1 
                    sta      addi_ex 
                    inc      expl_scale_base 
                    inc      expl_scale_base 
                    inc      expl_scale_base 
                    lda      expl_scale_base 
nextexpl 
                    ldb      #$7f 
                    pshs     d 
                    jsr      drawOneBase 
                    ldd      ,s 
                    adda     #5 
                    jsr      drawOneBase 
                    ldd      ,s 
                    adda     #10 
                    jsr      drawOneBase 
                    lda      addi_ex 
                    adda     #10 
                    sta      addi_ex 
                    bmi      donehereAgainb 
                    puls     d 
                    adda     addi_ex 
                    bmi      mainGameOver 
                    bcs      mainGameOver 
                    bra      nextexpl 

donehereAgainb 
                    puls     d 
                    bra      mainGameOver 

do_stage5_stuff 
                    bra      endofstagestuff 

do_stage4_stuff 
                    bra      endofstagestuff 

do_stage3_stuff 
                    ldd      spinSpeed_all 
                    subd     #2 
                    cmpd     #10 
                    bhi      noobs3 
                    bra      endofstagestuff 

noobs3 
                    std      spinSpeed_all 
                    bra      endofstagestuff 

do_stage2_stuff 
                    lda      stageCounter+1 
                    anda     #%00000011 
                    bne      noobs2_2 
                    ldd      spinSpeed_all 
                    addd     #2 
                    cmpd     #720 
                    blo      noobs2 
                    subd     #720 
noobs2 
                    std      spinSpeed_all 
noobs2_2 
                    bra      endofstagestuff 

do_stage1_stuff 
; nothing to do here :-)
                    bra      endofstagestuff 

endofstagestuff 
; increase base angle by 1 degree
; and modulo it at 360 degrees
                    ldx      base_angle 
                    leax     2,x 
                    cmpx     #(360*2) 
                    blo      angleOk_GO 
                    leax     -(360*2),x 
angleOk_GO: 
                    stx      base_angle 
; beq no_playerAction ; zero means no, and last was also not pressed
                    _ZERO_VECTOR_BEAM  
                    lda      endstage 
                    cmpa     #STAGE_5 
                    beq      noHomeDraw 
                    jsr      drawPlayerHome 
                    _ZERO_VECTOR_BEAM  
noHomeDraw 
                    dec      spawnDelay 
                    lbpl     drawTheDots 
                    lda      #DOT_SPAWN_DELAY 
                    sta      spawnDelay 
                    lda      counter_Arm 
                    cmpa     #MAX_DOT_PER_ARM 
                    bhs      armDoneSpawn 
                    SPAWN_ARM_DOT  angle_Arm1, dotsArm1 
                    SPAWN_ARM_DOT  angle_Arm2, dotsArm2 
                    SPAWN_ARM_DOT  angle_Arm3, dotsArm3 
                    inc      counter_Arm 
                    bra      drawTheDots 

armDoneSpawn 
                    bra      drawTheDots 

drawTheDots 
                    ldu      #dotsArm1 
                    lda      counter_Arm 
                    sta      tmp_byte 
draw_next_dot 
                    beq      mainGameOver 
                    jsr      drawTheDot 
                    leau     DotStruct*MAX_DOT_PER_ARM,u 
                    jsr      drawTheDot 
                    leau     DotStruct*MAX_DOT_PER_ARM,u 
                    jsr      drawTheDot 
                    leau     (-2*(DotStruct*MAX_DOT_PER_ARM))+DotStruct,u 
                    dec      tmp_byte 
                    bra      draw_next_dot 

doreturn 
                    rts      

; pointer to dot in u
drawTheDot 
                    ldd      dscale,u 
                    sta      VIA_t1_cnt_lo                ; explosion scale 
                    adda     expandArms 
                    bpl      keepScale 
                    lda      #5 
keepScale 
                    sta      dscale,u 
                    lda      endstage 
                    cmpa     #STAGE_5 
                    bne      noChangeInt 
                    decb     
                    bmi      noChangeInt 
                    stb      dintensity,u 
noChangeInt 
                    _INTENSITY_B  
                    ldd      ,u                           ;angle 
                    addd     spinSpeed_all 
                    cmpd     #720 
                    blt      not_oob1_go 
                    subd     #720 
not_oob1_go: 
                    std      ,u 
                    ldx      #circle 
                    leax     d,x                          ; u pointer to spwan angle coordinates 
                    ldd      ,x 
                    MY_MOVE_TO_D_START_NT                 ; move to the corner, and draw a dot at every corner 
                    lda      #$ff                         ; preload shift 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    STA      <VIA_shift_reg               ; Store in VIA shift register 
; delay for dot dwell
                    lda      endstage 
                    cmpa     #STAGE_3 
                    beq      noShiftOff 
                    nop      10 
                    CLR      <VIA_shift_reg               ; Blank beam in VIA shift register 
                    _ZERO_VECTOR_BEAM  
                    rts      

noShiftOff 
                    LDB      #$eC 
                    STB      VIA_cntl                     ;/BLANK low and /ZERO low 



                    nop      8 
                    CLR      <VIA_shift_reg               ; Blank beam in VIA shift register 
                    _ZERO_VECTOR_BEAM  
                    rts      

; in a scale
; in b intensity
drawOneBase 
                    cmpa     #$d0 
                    bhi      noBaseDraw 
                    sta      VIA_t1_cnt_lo                ; to timer t1 
                    _INTENSITY_B  
                    ldx      #rotList 
;;;;;;;;;;;;;;;;; one draw rotated start
drawRotated_dwb 
                    ldd      1,x 
                    MY_MOVE_TO_D_START  
                    lda      ,x                           ; get count of vectors 
                    sta      tmp_count2 
                    leax     3,x 
                    clra     
                    MY_MOVE_TO_B_END  
next_line_dwb: 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                    LDD      ,X 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    LDD      #$FF00                       ;Shift reg=$FF (solid line), T1H=0 
                    STA      <VIA_shift_reg               ;Put pattern in shift register 
                    STB      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDD      #$0040                       ;B-reg = T1 interrupt bit 
                    LEAX     2,X                          ;Point to next coordinate pair 
wait_draw_dwb: 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      wait_draw_dwb 
; nop 4
;                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                    dec      tmp_count2                   ;Decrement line count 
                    BPL      next_line_dwb                ;Go back for more points 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
;;;;;;;;;;;;;;;;; one draw rotated end
noBaseDraw 
                    _ZERO_VECTOR_BEAM  
                    rts      

                    struct   Letter3d 
                    ds       s_scale_3d, 1 
                    ds       s_vlist_3d, 2 
                    ds       s_pos_3d, 2 
                    ds       s_angle_x_3d, 1 
                    ds       s_angle_y_3d, 1 
                    ds       s_angle_z_3d, 1 
                    ds       s_offset_3d, 1 
                    end struct 
print3dLetter 
                    LDA      scale_3d_move                ; scale factor 
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    LDD      s_pos_3d,y 
                    MY_MOVE_TO_D_START  

                    ldd      s_angle_x_3d ,y 
                    std      angle_x 
                    lda      s_angle_z_3d ,y 
                    sta      angle_z 
                    JSR      init_all                     ; overkill - but saves memory 

                    LDA      scale_3d_move                ; scale factor 
                    cmpa     #$70 
                    blo      notStartgo_3d 
                    ldb      s_offset_3d, y 
                    bpl      decit_3d 
                    ldb      Vec_Loop_Count+1 
                    andb     #%00000001 
                    beq      notStartgo_3d 
                    INC      s_angle_x_3d, y 
                    LDb      s_angle_x_3d, y 
                    CMPb     #64 
                    BNE      in_3d_x_ok 
                    CLR      s_angle_x_3d, y 
in_3d_x_ok 
                    INC      s_angle_y_3d, y 
                    LDb      s_angle_y_3d, y 
                    CMPb     #64 
                    BNE      in_3d_y_ok 
                    CLR      s_angle_y_3d, y 
in_3d_y_ok 
                    INC      s_angle_z_3d, y 
                    LDb      s_angle_z_3d, y 
                    CMPb     #64 
                    BNE      in_3d_z_ok 
                    CLR      s_angle_z_3d, y 
in_3d_z_ok 
                    bra      notStartgo_3d 

decit_3d 
                    dec      s_offset_3d, y 
notStartgo_3d 
               ;     STA       scale_3d_move                ; move to time 1 lo, this means scaling 

; not used atm                    LDA      s_scale_3d,y                 ; scale factor 
                    lda      scale_3d_move 
; lsra
                    lsra     
                    lsra     
 cmpa #14
 blo scaleok3d2
                    lda      #14
scaleok3d2 
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    LDX      s_vlist_3d,y 

                    lda      scale_3d_move 

                    MY_MOVE_TO_B_END  
                    _INTENSITY_A  

;                    JSR      draw_3d 
 jsr myDraw_VL_mode4_3d
                    _ZERO_VECTOR_BEAM  
                    rts      









do3dGameOver 
mainGameOver3d:                                           ;#isfunction  

                    ldb      #0
                    stb      last_button_state 
                    stb      current_button_state 


                    LDA      #6 
                    CLR      angle_x 
                    STA      angle_y 
                    STA      angle_z 
                    lda      #$f 
                    sta      scale_3d 
INIT_3D_LETTER      macro    _vlist_3d, _pos_3d_, _offset_3d_ 
                    lda      #$f 
                    sta      s_scale_3d,u 
                    ldx      #_vlist_3d 
                    stx      s_vlist_3d,u 
                    ldd      #_pos_3d_ 
                    std      s_pos_3d,u 
                    clrb     
                    lda      #48 
                    sta      s_angle_x_3d,u 
                    stb      s_angle_y_3d,u 
                    stb      s_angle_z_3d,u 
                    lda      #_offset_3d_ 
                    sta      s_offset_3d, u 
                    endm     
                    ldu      #letters_3d 
                    INIT_3D_LETTER  g_3d, $2090, 0 
                    leau     Letter3d,u 
                    INIT_3D_LETTER  a_3d, $20b0-2, 7 
                    leau     Letter3d,u 
                    INIT_3D_LETTER  m_3d, $20d0-4, 14 
                    leau     Letter3d,u 
                    INIT_3D_LETTER  e_3d, $20f0-6, 21 
                    leau     Letter3d,u 
                    INIT_3D_LETTER  o_3d, $2010, 28 
                    leau     Letter3d,u 
                    INIT_3D_LETTER  v_3d, $2030-2, 35 
                    leau     Letter3d,u 
                    INIT_3D_LETTER  e_3d, $2050-4, 42 
                    leau     Letter3d,u 
                    INIT_3D_LETTER  r_3d, $2070-6, 49 
                    leau     Letter3d,u 
                    ldd      #0 
                    std      s_vlist_3d,u 
                    sta      scale_3d_move 
mainGameOver3dLoop: 
                    _ZERO_VECTOR_BEAM  

                    jsr      getButtonState               ; is a button pressed? 
                    lbne     doreturn 
                    jsr      Wait_Recal 
;                    JSR      do_ym_sound2 
                    JSR      draw_Score_game              ; has a nice long moveto 
                    JSR      Intensity_3F                 ; intensity to $3f, gets destroyed 
                    lda      scale_3d_move 
                    inca     
                    inca     
                    cmpa     #$7f 
                    bhi      not_higher_scale 
                    sta      scale_3d_move 
not_higher_scale 
                    ldy      #letters_3d 
another_letter 
                    jsr      print3dLetter 
                    leay     Letter3d,y 
                    ldd      s_vlist_3d,y 
                    bne      another_letter 
;letters_3d
; lda scale_3d_move
; ldb scale_3d
                    INC      angle_x 
                    LDA      angle_x 
                    CMPA     #64 
                    BNE      mainGameOver3dLoop 
                    CLR      angle_x 
                    bra      mainGameOver3dLoop 

                    INCLUDE  "3D_PRG.I"
                    INCLUDE  "3D.ASM"
