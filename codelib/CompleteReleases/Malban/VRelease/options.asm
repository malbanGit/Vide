; this file is part of Release, written by Malban in 2017
;
                    bss      
                    org      clip_end+5 
selected_option_O   ds       1 
selected_scale_size_O  ds    1 
is_first_move_O     ds       1 
letterScale_O       ds       1 
moveScale_O         ds       1 
printing_now        ds       1 
inc_o               ds       1 
use_scale_letter_o  ds       1 
change_scale        ds       1 
resetDone           ds       1 
veryUp              ds       1 
veryUoCount_1       ds       1 
veryUoCount_2       ds       1 
                    code     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
display_options                                           ;#isfunction  
                    ldd      #3*256+24 
                    std      selected_option_O 
                    clr      inc_o 
                    clr      resetDone 
                    clr      veryUp 
                    clr      veryUoCount_1 
                    clr      veryUoCount_2 
                    ldu      #phaseList 
checkLevelAgain 
                    cmpu     initialPhase 
                    beq      initLevelDone 
                    leau     2,u 
                    lda      veryUoCount_1 
                    inca     
                    cmpa     #10 
                    blo      digit1Ok_opt_init 
                    clra     
                    inc      veryUoCount_2 
digit1Ok_opt_init 
                    sta      veryUoCount_1 
                    bra      checkLevelAgain 

initLevelDone 
display_options_loop 
                    jsr      PLY_PLAY 
                    jsr      Wait_Recal 
                    ldx      RecalCounter                 ; recal counter, about 21 Minutes befor roll over 
                    leax     1,x 
                    stx      RecalCounter 
                    _DP_TO_D0                             ; round_startup_main expects dp set to d0 
                    JSR      do_ym_sound2_no_sfx 
; print text pointed to by u as vector string
; only large letters and "."
; terminated by $80
; position in D
; positioning done with $20 scale
; print done with title_scale scale
                    lda      veryUp                       ; if on "MUSIC" and pressed 5 times more "up" the level selection appears 
                    cmpa     #5 
                    blo      noVeryup1 
                    lda      #100 
                    _SCALE_A  
                    jsr      Intensity_3F 
                    ldd      #$7f60 
                    jsr      Moveto_d 
                    lda      #3 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldx      #NumberList                  ; list of pointers to number vectorlists 
                    lda      veryUoCount_2 
                    lsla     
                    ldx      a,x 
                    jsr      myDraw_VL_mode 
                    ldx      #NumberList                  ; list of pointers to number vectorlists 
                    lda      veryUoCount_1 
                    lsla     
                    ldx      a,x 
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
noVeryup1 
                    clr      change_scale 
                    lda      #100 
                    sta      moveScale_O 
                    _SCALE_A  
                    ldd      #(24*256)+$ff 
                    sta      letterScale_O 
                    stb      printing_now 
                    jsr      Intensity_5F 
                    ldd      #$7fd0 
                    ldu      #options_string 
                    jsr      vectorPrint2 
                    inc      printing_now 
                    jsr      Intensity_3F 
                    ldd      #$2ab0 
                    ldu      #music_string 
                    inc      change_scale 
                    jsr      vectorPrint2 
                    dec      change_scale 
                    lda      musicOption 
                    bne      printMusicOff 
printMusicOn 
                    ldd      #$2a20 
                    ldu      #on_string 
                    jsr      vectorPrint2 
                    bra      continueWithSFX 

printMusicOff 
                    ldd      #$2a20 
                    ldu      #off_string 
                    jsr      vectorPrint2 
                    bra      continueWithSFX 

continueWithSFX 
                    inc      printing_now 
                    jsr      Intensity_3F 
                    ldd      #$ffb0 
                    inc      change_scale 
                    ldu      #sfx_string 
                    jsr      vectorPrint2 
                    dec      change_scale 
                    lda      sfxOption 
                    bne      printSFXOff 
printSFXOn 
                    lda      halfnoise 
                    beq      no_haldNoise_print 
                    ldd      #$ff20 
                    ldu      #half_string 
                    jsr      vectorPrint2 
                    bra      continueWithBack 

no_haldNoise_print 
                    ldd      #$ff20 
                    ldu      #on_string 
                    jsr      vectorPrint2 
                    bra      continueWithBack 

printSFXOff 
                    ldd      #$ff20 
                    ldu      #off_string 
                    jsr      vectorPrint2 
                    bra      continueWithBack 

continueWithBack 
                    inc      change_scale 
                    inc      printing_now 
                    jsr      Intensity_3F 
                    ldd      #$d5b0 
                    ldu      #reset_string 
                    jsr      vectorPrint2 
                    dec      change_scale 
                    tst      resetDone 
                    beq      not_done_o 
                    ldd      #$d520 
                    ldu      #done_string 
                    jsr      vectorPrint2 
not_done_o 
                    inc      change_scale 
                    inc      printing_now 
                    jsr      Intensity_3F 
                    ldd      #$80d0 
                    ldu      #back_string 
                    jsr      vectorPrint2 
                    jsr      getButtonState               ; is a button pressed? 
                    beq      display_options_joystick 
                    cmpb     #3                           ; same aslast state 
                    beq      display_options_joystick 
                    cmpb     #2                           ; as released - possibly from highscore return 
                    beq      display_options_joystick 
                    lda      selected_option_O 
                    cmpa     #3 
                    beq      doGoBack_options 
                    cmpa     #2 
                    lbeq     doResetOptions 
                    cmpa     #1 
                    lbeq     doSwitchSFX 
                    cmpa     #0 
                    lbeq     doSwitchMusic 
doGoBack_options 
                    ldd      #(EEPROM_STORESIZE_OPTIONS*256)+EEPROM_OPTION_BLOCK 
                    std      current_eprom_blocksize 
                    ldx      #optionsBlock 
                    jsr      eeprom_save_options 
                    lda      #15 
                    jsr      init_objects_a 
                    ldb      #3 
                    stb      last_button_state 
                    stb      current_button_state 
                    jmp      title_main1_hs_ret 

display_options_joystick 
                    jsr      query_joystick 
                    LDB      last_joy_y                   ; only jump if last joy pos was zero (needed for testing later) 
                    LDA      Vec_Joy_1_Y                  ; load joystick 1 position X to A 
                    STA      last_joy_y                   ; store this joystick position 
                    BEQ      no_new_ypos_options 
                    BMI      pos_down_options             ; joystick moved to left 
pos_up_options: 
                    TSTB                                  ; test the old joystick position 
                    BNE      positioning_done_options     ; was center 
                    lda      selected_option_O 
                    beq      positioning_done_options_2 
                    dec      selected_option_O 
                    bra      no_new_ypos_options 

pos_down_options: 
                    clr      veryUp 
                    TSTB                                  ; test the old joystick position 
                    BNE      positioning_done_options     ; was center 
                    lda      selected_option_O 
                    cmpa     #3 
                    beq      positioning_done_options 
                    inc      selected_option_O 
                    bra      no_new_ypos_options 

; letter inc 1
positioning_done_options 
no_new_ypos_options 
                    ldb      veryUp 
                    cmpb     #5 
                    blo      noVeryup2 
                    LDB      last_joy_x                   ; only jump if last joy pos was zero (needed for testing later) 
                    LDA      Vec_Joy_1_X                  ; load joystick 1 position X to A 
                    STA      last_joy_x                   ; store this joystick position 
                    BEQ      no_new_xpos_opt 
                    BMI      pos_left_opt                 ; joystick moved to left 
pos_right_opt: 
                    TSTB                                  ; test the old joystick position 
                    BNE      noVeryup2                    ; was center 
                    ldu      initialPhase 
                    ldd      2,u 
                    beq      noVeryup2                    ; to high 
                    leau     2,u 
                    stu      initialPhase 
                    lda      veryUoCount_1 
                    inca     
                    cmpa     #10 
                    blo      digit1Ok_opt 
                    clra     
                    inc      veryUoCount_2 
digit1Ok_opt 
                    sta      veryUoCount_1 
                    bra      noVeryup2 

pos_left_opt: 
                    TSTB                                  ; test the old joystick position 
                    BNE      noVeryup2                    ; was center 
; pos inc 1
                    ldu      initialPhase 
                    cmpu     #phaseList 
                    beq      noVeryup2 
                    leau     -2,u 
                    stu      initialPhase 
                    lda      veryUoCount_1 
                    deca     
                    bpl      digit1Ok_opt_2 
                    lda      #9 
                    dec      veryUoCount_2 
digit1Ok_opt_2 
                    sta      veryUoCount_1 
                    bra      noVeryup2 

no_new_xpos_opt 
noVeryup2 
                    jmp      display_options_loop 

positioning_done_options_2 
                    inc      veryUp 
                    jmp      display_options_loop 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
options_string:                                           ;#isfunction  
                    db       "OPTIONS",$80
music_string: 
                    db       "MUSIC",$80
sfx_string: 
                    db       "SFX",$80
reset_string: 
                    db       "RESET",$80
back_string: 
                    db       "BACK",$80
off_string: 
                    db       "OFF",$80
on_string: 
                    db       "ON", $80
half_string: 
                    db       "HALF", $80
done_string: 
                    db       "DONE", $80
; print text pointed to by u as vector string
; only large letters and "."
; terminated by $80
; position in D
; positioning done with title_scale scale
; print done with title_scale/8 scale
vectorPrint2                                              ;#isfunction  
                    clr      is_first_move_O 
                    std      tmp1 
next_name_letter_vp2 
                    lda      moveScale_O 
                    _SCALE_A  
                    ldd      tmp1                         ; the current move vector 
                    MY_MOVE_TO_D_START_NT  
                    tst      is_first_move_O 
                    bne      is_not_first_move 
                    lda      letterScale_O 
                    ldb      printing_now 
                    cmpb     selected_option_O 
                    bne      noScaleChange_o 
                    tst      inc_o 
                    bne      do_dec_o 
do_inc_o 
                    tst      change_scale                 ; do only change once per line 
                    beq      noScaleChange_o1 
                    inc      selected_scale_size_O 
noScaleChange_o1 
                    lda      selected_scale_size_O 
                    cmpa     #26 
                    bne      loadsizedone_o 
                    inc      inc_o 
                    bra      loadsizedone_o 

do_dec_o 
                    tst      change_scale                 ; do only change once per line 
                    beq      noScaleChange_o2 
                    dec      selected_scale_size_O 
noScaleChange_o2 
                    lda      selected_scale_size_O 
                    cmpa     #16 
                    bne      loadsizedone_o 
                    clr      inc_o 
loadsizedone_o 
; lda selected_scale_size_O
noScaleChange_o 
                    sta      use_scale_letter_o 
                    MY_MOVE_TO_B_END  
                    tst      is_first_move_O 
                    bne      is_not_first_move2 
                    ldb      printing_now 
                    cmpb     selected_option_O 
                    bne      noIntChange_o2 
                    jsr      Intensity_7F 
is_not_first_move2 
noIntChange_o2 
                    inc      is_first_move_O 
                    _ZERO_VECTOR_BEAM  
                    nop      2 
                    bra      next_name_letter_vp2 

is_not_first_move: 
                    LDB      ,u+                          ; first char of three letter name 
                                                          ; lets calculate the abc-table offset... 
                    cmpb     # ' '
                    bne      _no_space_found2 
                    ldx      #ABC_28                      ; and add the abc (table of vector list address of the alphabet's letters) 
                    bra      cont_vp2 

_no_space_found2 
                    SUBB     # 'A'                        ; subtract smallest letter, so A has 0 offset
                    LSLB                                  ; multiply by two, since addresses are 16 bit 
                    ldx      #_abc                        ; and add the abc (table of vector list address of the alphabet's letters) 
                    LDX      b,X                          ; in x now address of first letter vectorlist 
cont_vp2 
                    lda      mov_x 
                    adda     #12 
                    sta      mov_x 
                    lda      use_scale_letter_o 
                    _SCALE_A  
                    MY_MOVE_TO_B_END  
                    pshs     u 
                    jsr      myDraw_VL_mode3              ;2 
                    puls     u 
                    _ZERO_VECTOR_BEAM                     ; draw each letter with a move from zero, more stable 
                    LDB      ,u 
                    lbpl     next_name_letter_vp2 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
doResetOptions 
                    jsr      resetEprom 
                    lda      #1 
                    sta      resetDone 
                    bra      switchMusicOn 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
doSwitchSFX 
                    lda      sfxOption 
                    bne      sfx_was_off 
sfx_was_on 
                    lda      halfnoise 
                    bne      half_noise_was_on 
only_sfx_was_on: 
                    lda      #1 
                    sta      halfnoise 
                    bra      sfxOptionOkSwitched 

half_noise_was_on 
                    lda      #1 
                    sta      sfxOption 
                    bra      sfxOptionOkSwitched_1 

sfx_was_off 
                    clr      sfxOption 
sfxOptionOkSwitched_1 
                    clr      halfnoise 
sfxOptionOkSwitched 
                    jmp      display_options_loop 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
doSwitchMusic 
                    lda      musicOption 
                    beq      switchMusicOff 
switchMusicOn 
                    clr      musicOption 
                    jsr      clear_all_sound              ; clear all regs 
                    INIT_MUSIC  titleMusic 
                    jmp      display_options_loop 

switchMusicOff 
                    jsr      clear_all_sound              ; clear all regs 
                    lda      #1 
                    sta      musicOption 
                    jmp      display_options_loop 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
