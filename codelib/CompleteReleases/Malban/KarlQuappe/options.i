; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;;***************************************************************************
; this routine draws the initial screen
; with information about the game
; nothing is expected and nothing is returned
; leaves dp pointing d0 expected
options_string: 
                    db       "OPTIONS", $80 
no_players_string_0: 
                    db       "PLAYERS   :", $80 
no_players_string_1: 
                    db       "1", $80 
no_players_string_2: 
                    db       "2", $80 
mode_string_0: 
                    db       "GAME MODE :", $80
mode_string_1: 
competition_string: 
                    db       "COMPETITION", $81 
mode_string_2: 
                    db       "TRAINING", $80 
mode_string_3: 
hardcore_string: 
                    db       "HARDCORE", $81 
music_string_0: 
                    db       "MUSIC     :", $80 
music_string_1: 
                    db       "ON", $80 
music_string_2: 
                    db       "OFF", $80 
resetHS_0: 
                    db       "RESET ", $80 
resetHS_1: 
                    db       "STORAGE", $80 
resetHS_2: 
                    db       "DONE", $80 
PLAYER_OPTION       EQU      0 
MODE_OPTION         EQU      1 
MUSIC_OPTION        EQU      2 
LEVEL_OPTION        EQU      3 
RESET_OPTION        EQU      4 
BACK_OPTION         EQU      5 
; first x $80 terminated string
; second u $80 terminated string
; result in stringBufferTemp
; leaves with u = #stringBufferTemp
concatStrings 
                    ldy      #stringBufferTemp 
nextLetter 
                    lda      ,x+ 
                    bmi      nextString 
                    sta      ,y+ 
                    bra      nextLetter 

nextString 
nextLetter2 
                    lda      ,u+ 
                    sta      ,y+ 
                    bpl      nextLetter2 
                    ldu      #stringBufferTemp 
                    rts      

option_screen: 
                    clr      hs_reset_tmp 
                    clr      isAttractMode 
 jsr shutup
;                    MY_QUIT  
;                    DO_MY_SOUND  
;                    JSR      DP_to_D0 
;                    JSR      Do_Sound                     ; ROM function that does the sound playing 
;                    direct   $D0 
                    lda      #BACK_OPTION 
                    sta      currentSelectedOption 
                    JSR      Read_Btns                    ; get button status once, since only 
                                                          ; differences are noticed 
option_screen_loop: 
                    jsr      do_csa_startup 
                    direct   $D0                          ; just for assembler optimization... 
                    jsr      query_joystick 
                    LDA      Vec_Joy_1_X                  ; load joystick 1 position X to A 
                    LDB      last_joy_x                   ; only jump if last joy pos was zero 
                    STA      last_joy_x                   ; store this joystick position 
                    beq      no_x_change 
                    TSTB                                  ; test the old joystick position 
                    lBNE      joystickHandleDone           ; was center 
                    lda      currentSelectedOption 
                    cmpa     #LEVEL_OPTION 
                    lbeq     selectLevel 
                    cmpa     #RESET_OPTION 
                    lblt     toggleOptions 
no_x_change: 
                    LDA      Vec_Joy_1_Y                  ; load joystick 1 position X to A 
                    LDB      last_joy_y                   ; only jump if last joy pos was zero 
                    STA      last_joy_y                   ; store this joystick position 
                    beq      joystickHandleDone           ; no joystick input available 
                    BMI      pos_down_o                   ; joystick moved to down 
pos_up_o: 
                    TSTB                                  ; test the old joystick position 
                    BNE      joystickHandleDone           ; was center 
                    lda      currentSelectedOption 
                    cmpa     #PLAYER_OPTION               ; following code only allows selection of level, when prerequisits are right 
                    beq      joystickHandleDone 
                    dec      currentSelectedOption 
                    cmpa     #RESET_OPTION 
                    bne      levelSelectOk 
                    tst      levelEditAllowed 
                    beq      previousNotReset 
                    lda      gameModeOption 
                    cmpa     #1 
                    bne      previousNotReset 
                    bra      levelSelectOk 

previousNotReset 
                    dec      currentSelectedOption 
levelSelectOk: 
                    lda      playerCountOption            ; can't select training in 2 player 
                    beq      joystickHandleDone 
                    lda      currentSelectedOption 
                    cmpa     #MODE_OPTION 
                    bne      joystickHandleDone 
                    dec      currentSelectedOption 
                    bra      joystickHandleDone 

pos_down_o: 
                    TSTB                                  ; test the old joystick position 
                    BNE      joystickHandleDone           ; was center 
                    lda      currentSelectedOption        ; following code only allows selection of level, when prerequisits are right 
                    cmpa     #BACK_OPTION 
                    beq      joystickHandleDone 
                    inc      currentSelectedOption 
                    cmpa     #MUSIC_OPTION 
                    bne      levelSelectOk2 
                    tst      levelEditAllowed 
                    beq      previousNotReset2 
                    lda      gameModeOption 
                    cmpa     #1 
                    bne      previousNotReset2 
                    bra      levelSelectOk2 

previousNotReset2 
                    inc      currentSelectedOption 
levelSelectOk2: 
                    lda      playerCountOption 
                    beq      joystickHandleDone 
                    lda      currentSelectedOption 
                    cmpa     #MODE_OPTION 
                    bne      joystickHandleDone 
                    inc      currentSelectedOption 
joystickHandleDone: 
DEFAULT_INTENSITY   EQU      $50 
TITLE_INTENSITY     EQU      $60 
                    lda      #$60 
                    _SCALE_A  
                    JSR      Intensity_a                  ; set it 

 ldd #$ff3c
    std      Vec_Text_Height 

                    ldd      #$7fc0 
                    ldu      #options_string 
                    jsr      sync_Print_Str_d_fixed 
                    lda      #$58 
                    _SCALE_A  
                    lda      currentSelectedOption 
                    cmpa     #PLAYER_OPTION 
                    jsr      checkIntensity 
                    ldx      #no_players_string_0 
                    tst      playerCountOption 
                    bne      pl2 
                    ldu      #no_players_string_1 
                    bra      pls 

pl2 
                    ldu      #no_players_string_2 
pls 
                    jsr      concatStrings 
                    ldd      #$5081 
                    jsr      sync_Print_Str_d_fixed 
;;;;;;;;
                    tst      playerCountOption 
                    beq      normalIntensityLevelGO 
                    lda      #$30 
                    jsr      Intensity_a 
                    bra      noIntensityLevel2GO 

normalIntensityLevelGO 
                    lda      currentSelectedOption 
                    cmpa     #MODE_OPTION 
                    jsr      checkIntensity 
noIntensityLevel2GO 
                    ldx      #mode_string_0 
                    lda      gameModeOption 
                    bne      mos2 
                    ldu      #mode_string_1 
                    bra      mos 

mos2 
                    cmpa     #2 
                    beq      mos3 
                    ldu      #mode_string_2 
                    bra      mos 

mos3 
                    ldu      #mode_string_3 
mos 
                    jsr      concatStrings 
                    ldd      #$3081 
                    jsr      sync_Print_Str_d_fixed 
;;;;;;;;
                    lda      currentSelectedOption 
                    cmpa     #MUSIC_OPTION 
                    jsr      checkIntensity 
                    ldx      #music_string_0 
                    tst      musicOption 
                    bne      mus2 
                    ldu      #music_string_1 
                    bra      mus 

mus2 
                    ldu      #music_string_2 
mus 
                    jsr      concatStrings 
                    ldd      #$1081 
                    jsr      sync_Print_Str_d_fixed 
;;;;;;;;
                    tst      levelEditAllowed 
                    beq      noIntensityLevel 
                    lda      gameModeOption 
                    cmpa     #1 
                    beq      normalIntensityLevel 
noIntensityLevel 
                    lda      #$30 
                    jsr      Intensity_a 
                    bra      noIntensityLevel2 

normalIntensityLevel 
                    lda      currentSelectedOption 
                    cmpa     #LEVEL_OPTION 
                    jsr      checkIntensity 
noIntensityLevel2 
                    ldd      #$f081 
                    ldu      #levelString 
                    jsr      sync_Print_Str_d_fixed 
;;;;;;;;
                    lda      currentSelectedOption 
                    cmpa     #RESET_OPTION 
                    jsr      checkIntensity 
                    ldx      #resetHS_0 
                    tst      hs_reset_tmp 
                    bne      res2 
                    ldu      #resetHS_1 
                    bra      res 

res2 
                    ldu      #resetHS_2 
res 
                    jsr      concatStrings 
                    ldd      #$d081 
                    jsr      sync_Print_Str_d_fixed 
;;;;;;;;
                    lda      currentSelectedOption 
                    cmpa     #BACK_OPTION 
                    jsr      checkIntensity 
                    ldd      #$B081 
                    ldu      #backMainMenu 
                    jsr      sync_Print_Str_d_fixed 
                    clra     
                    sta      <VIA_shift_reg 
                    JSR      Read_Btns                    ; get button status 
                    CMPA     #$00                         ; is a button pressed? 
                    lBEQ     option_screen_loop           ; no, than stay in init_screen_loop 
toggleOptions 
                    ldb      currentSelectedOption 
                    cmpb     #BACK_OPTION 
                    beq      outOptions 
                    cmpb     #PLAYER_OPTION 
                    bne      nextOption1 
                    lda      playerCountOption 
                    inca     
                    anda     #1 
                    sta      playerCountOption 
                    beq      playGoOn 
                    clr      gameModeOption               ; training only in 1 player mode 
playGoOn 
                    jmp      joystickHandleDone 

nextOption1 
                    cmpb     #MODE_OPTION 
                    bne      nextOption2 
                    lda      gameModeOption 
                    inca     
                    cmpa     #3 
                    bne      optionOk1 
                    clra     
optionOk1 
                    sta      gameModeOption 
                    jmp      joystickHandleDone 

nextOption2 
                    cmpb     #MUSIC_OPTION 
                    bne      nextOption3 
                    lda      musicOption 
                    inca     
                    anda     #1 
                    sta      musicOption 
                    jmp      joystickHandleDone 

nextOption3 
                    cmpb     #RESET_OPTION 
                    bne      nextOption4 
                    inc      hs_reset_tmp 
                    jsr      resetEprom 
                    ldd      # " 1"
                    std      levelString+6 
nextOption4 
                    jmp      joystickHandleDone 

outOptions: 
                    ldb      v4ecartflags                 ; check if there is any v4e at all? 
                    bpl      nov4eback                        ; if not (positive) jump 
                    cmpa     #$08 
                    lbeq     goback 
nov4eback
                    ldd      levelString+6 
                    ldu      #0 
                    cmpa     # "1"
                    bne      lowerTen 
                    leau     10,u 
lowerTen: 
                    subb     # "0"
                    leau     b,u 
                    tfr      u,d 
                    stb      levelFromOptions             ; one based 
                    ldd      #(EEPROM_STORESIZE_OPTIONS*256)+EEPROM_OPTION_BLOCK 
                    std      current_eprom_blocksize 
                    ldx      #optionsBlock 
                    jsr      eeprom_save_options 
                    inc      isAttractMode 
                    RTS      

;;***************************************************************************
checkIntensity: 
                    beq      flashInt 
                    lda      #DEFAULT_INTENSITY 
setintcheck 
                    jmp      Intensity_a 
;                    _INTENSITY_A  
                    ;rts      

; according to button
; level string one up/ down
selectLevel 
                    ldd      levelString+6                ; " 1" 
                    tst      last_joy_x 
                    bmi      decreaseLevel 
; increaseLevel
                    cmpd     # "16"
                    lbeq     joystickHandleDone           ; cant increase 
                    cmpb     # "9"
                    bne      lowLevel 
                    ldd      # "10"
                    bra      IncDone 

lowLevel: 
                    incb     
DecDone 
IncDone 
                    std      levelString+6 
                    jmp      joystickHandleDone 

decreaseLevel 
                    cmpd     # " 1"
                    lbeq     joystickHandleDone           ; cant decrease 
                    cmpd     # "10"
                    bne      noBiggi 
                    ldd      # " 9"
                    bra      DecDone 

noBiggi: 
                    decb     
                    bra      DecDone 

flashInt: 
                    lda      RecalCounter+1 
                    anda     #$f 
                    ldx      #intensityValues 
                    lda      a,x 
                    bra      setintcheck 

;;***************************************************************************
intensityValues: 
                    db       $7f, $78, $70, $68, $60, $58, $50, $48, $48, $50, $58, $60, $68, $70, $78, $7f 
