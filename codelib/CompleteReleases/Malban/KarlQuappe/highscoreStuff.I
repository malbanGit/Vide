; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains macros that are used to print the score while in game  ;
; It is special in the way that it uses an own 5 line FONT                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;High score in Karl Quappe - 3 parts
;1) HighScore while playing
;2) Highscore in HighscoreTable
;3) Highscore on Eprom
;
;1) While playing - is kept  in 5 seperate bytes
; score_digit_1 - score_digit_5
; each of these digits has a range from 0-9
; digit 5 (MSB) has a range from 0-16
; each digit is printed with a special font, 0-9 representing 0-9 and 10-16 representing 10-16 (in one character)
; so the highest score displayable is: 16 999 0 (last character is always a "0")
;2) Highscore table consists of 6 ascii characters representing the score in ascii nothing special here
;3) Highscore on the eprom is kept as a 16bit unsigned int (0-65535)
;  upon conversion the score is shifted one position to the right (divided by 10), since the last position is always a 0
;  Thus on the eprom a score up to 655350 can be stored.
;
; ergo: in game highscore is correct displayed up to a score of 169990
; highscore recording and displaying in HS table is correct up to a score of 655350
; after that the score starts from 0 again 
;
;
;
;***************************************************************************
highscores_screen 
                    lda      gameModeOption 
                    sta      current_highscore_gameMode 
                    lda      isAttractMode 
                    ldx      RecalCounter                 ; save recal counter, since 
                    pshs     a,x 
                    clr      isAttractMode 
                    JSR      DP_to_D0 
; setup high score editing stuff, like cursor pos and blinking
                    clr      currentHSEditPlace 
                    clr      currentHSEditBlinkState 
                    lda      # 'A'                        ; all letters in editor start with A-position
                    sta      hsEditLetter1 
                    sta      hsEditLetter2 
                    sta      hsEditLetter3 
                    direct   $D0 
 jsr shutup

                    clr      RecalCounter                 ; recal counter is used as blinking "counter" 
                    clr      RecalCounter+1 
                    JSR      Read_Btns                    ; get button status once, since only 
                                                          ; differences are noticed 
highscores_screen_loop_1: 
                    direct   $D0 
                    LDA      Vec_Music_Flag               ; is music still playing? 
                    BNE      no_new_music_1hs             ; than jump 
                    LDX      #yankee                      ; load adddress of music structure 
                    PLAY_SOUND  yankee                    ; and play the tune again... 
no_new_music_1hs: 
                    ROUND_STARTUP                         ; well, the startup... 
                    LDD      #NORMAL_TEXT_SIZE            ; load default text height & width 
                    STD      Vec_Text_HW                  ; poke it to ram location 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
;                    ldd      #$ff3c 
                    ldd      #$fe3c 
                    std      Vec_Text_Height 
                    lda      #80 
                    _SCALE_A  
                    ldd      #$78AB                       ; max, since -2 in each step 
                    ldu      #highscore_string            ; high score title 
                    jsr      sync_Print_Str_d_fixed 
                    lda      current_highscore_gameMode 
                    cmpa     #2 
                    bne      viewTournamentHS 
                    ldu      #hardcore_string 
                    ldx      #highScoreHardTable 
                    ldd      #$9cc0                       ; max, since -2 in each step 
                    bra      goonhigm 

viewTournamentHS: 
                    ldu      #competition_string 
                    ldx      #highScoreTable 
                    ldd      #$9cAB                       ; max, since -2 in each step 
goonhigm: 
                    pshs     x 
                    jsr      sync_Print_Str_d_fixed 
                    puls     x 
                    lda      #5 
                    sta      tmp2 
                    ldd      #$5a8e 
                    pshs     d 
                    clr      mul_tmp2                     ; counter of highscores handled 
nextHSScore 
                    jsr      buildHighScoreTmp            ; build one highscore line (X is scoretable entry parameter) 
; change string to appear edited!
                    tst      highScoreEditMode 
                    beq      noEdit 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                    lda      highScorePlace 
                    cmpa     mul_tmp2 
                    bne      noEdit 
                    JSR      Intensity_7F                 ; Sets the intensity of the 
; the current score string is the one we are editing currently
; that high score takes its "name" letters from the special editor positions
; the following code replaces in the tmp line the 3 letters, 
; in relation to the blink state also exchanges a letter with an underscore
                    lda      RecalCounter+1 
                    anda     #$07 
                    bne      noBlinkChange 
                    lda      currentHSEditBlinkState 
                    inca     
                    anda     #$01 
                    sta      currentHSEditBlinkState 
noBlinkChange: 
                    LDU      #highScoreTmpBuffer 
                    lda      hsEditLetter1 
                    sta      0,u 
                    lda      hsEditLetter2 
                    sta      1,u 
                    lda      hsEditLetter3 
                    sta      2,u 
                    tst      currentHSEditBlinkState 
                    beq      drawString 
; here place cursor instead of Letter
                    lda      # '_'
                    ldb      currentHSEditPlace 
                    sta      b,u 
drawString: 
noEdit: 
; each line of the high score is printed out, regardless of editing
                    inc      mul_tmp2 
                    leax     HighScoreEntry,x 
                    lda      #70 
                    _SCALE_A  
                    LDU      #highScoreTmpBuffer 
                    ldd      ,s 
                    pshs     x                            ; save x pointer 
                    jsr      sync_Print_Str_d_fixed 
                    puls     x 
                    lda      ,s 
                    suba     #30                          ; next highscore entry is 30 "pixels" down 
                    sta      ,s 
                    dec      tmp2 
                    bne      nextHSScore 
                    puls     d 
                    jsr      query_joystick 
                    tst      highScoreEditMode            ; if in edit mode - do question the joystick... and stuff 
                                                          ; hey dissi "bre ak once" 
                    bne      dohseditMode                 ; otherwise stay here and "return" to main screen on button press 
                    LDB      last_joy_x                   ; only jump if last joy pos was zero (needed for testing later) 
                    LDA      Vec_Joy_1_X                  ; load joystick 1 position X to A 
                    STA      last_joy_x                   ; store this joystick position 
                    BEQ      hs_no_new_xpos_dis 
                    tstb     
                    bne      hs_no_new_xpos_dis 

                    lda      current_highscore_gameMode 
                    cmpa     #2 
                    beq      clrit 
                    lda      #2 
                    sta      current_highscore_gameMode 
                    bra      hs_no_new_xpos_dis 

clrit 
                    clr      current_highscore_gameMode 
hs_no_new_xpos_dis 
                    JSR      Read_Btns                    ; get button status 
                    CMPA     #$00                         ; is a button pressed? 
                    lBEQ     highscores_screen_loop_1     ; no, than stay in init_screen_loop 
                    puls     a,x                            ; restore counter 
                    stx      RecalCounter 
                    sta      isAttractMode 
                    rts      

;***************************************************************************
dohseditMode: 
; get joystick
; left right change cursor pos
; up down, change letters
; any button finish editing
                    JSR      Read_Btns                    ; get button status 
                    CMPA     #$00                         ; is a button pressed? 
                    bne      exitHS                       ; no, than stay in init_screen_loop 
; X POS TESTS
                    LDB      last_joy_x                   ; only jump if last joy pos was zero (needed for testing later) 
                    LDA      Vec_Joy_1_X                  ; load joystick 1 position X to A 
                    STA      last_joy_x                   ; store this joystick position 
                    BEQ      hs_no_new_xpos 
                    BMI      pos_left_hse                 ; joystick moved to left 
pos_right_hse: 
                    TSTB                                  ; test the old joystick position 
                    BNE      positioning_done_hse         ; was center 
; move right, letterpos =  letterpos +1
                    inc      currentHSEditPlace 
                    lda      currentHSEditPlace 
                    cmpa     #2 
                    ble      positioning_done_hse 
                    clr      currentHSEditPlace 
                    bra      positioning_done_hse 

pos_left_hse: 
                    TSTB                                  ; test the old joystick position 
                    BNE      positioning_done_hse         ; was center 
                    dec      currentHSEditPlace 
                    bpl      positioning_done_hse 
                    lda      #2 
                    sta      currentHSEditPlace 
                    bra      positioning_done_hse 

hs_no_new_xpos: 
; Y POS TESTS
                    LDB      last_joy_y                   ; only jump if last joy pos was zero (needed for testing later) 
                    LDA      Vec_Joy_1_Y                  ; load joystick 1 position X to A 
                    STA      last_joy_y                   ; store this joystick position 
                    BEQ      hs_no_new_ypos 
                    BMI      pos_down_hse                 ; joystick moved to left 
pos_up_hse: 
                    TSTB                                  ; test the old joystick position 
                    BNE      positioning_done_hse         ; was center 
; move up, letter =  letter -1
                    lda      currentHSEditPlace 
                    ldu      #hsEditLetter1 
                    ldb      a,u 
                    incb     
                    cmpb     # 'Z'
                    ble      letterOk_hse 
                    ldb      # 'A'
letterOk_hse 
                    stb      a,u 
                    bra      positioning_done_hse 

pos_down_hse: 
                    TSTB                                  ; test the old joystick position 
                    BNE      positioning_done_hse         ; was center 
                    lda      currentHSEditPlace 
                    ldu      #hsEditLetter1 
                    ldb      a,u 
                    decb     
                    cmpb     # 'A'
                    bge      letterOk_hse 
                    ldb      # 'Z'
                    bra      letterOk_hse 

hs_no_new_ypos: 
positioning_done_hse 
                    jmp      highscores_screen_loop_1 

exitHS: 
; write letters to HS and exit
                    lda      current_highscore_gameMode 
                    cmpa     #2 
                    bne      viewTournamentHS2 
                    ldu      #highScoreHardTable 
                    bra      goonhigm2 

viewTournamentHS2: 
                    ldu      #highScoreTable 
goonhigm2: 
                                                          ; LDU #highScoreTable 
                    ldb      highScorePlace 
                    beq      hsFound 
addhsFound: 
                    leau     HighScoreEntry,u 
                    decb     
                    bne      addhsFound 
hsFound 
                    lda      hsEditLetter1 
                    sta      0,u 
                    lda      hsEditLetter2 
                    sta      1,u 
                    lda      hsEditLetter3 
                    sta      2,u 
                    puls     a,x 
                    stx      RecalCounter 
                    sta      isAttractMode 
                    rts      

;***************************************************************************
highscore_string: 
                    db       "HIGH SCORE", $80 
; score table entry in x
; destroys D, y
; this builds one "highscore" line, that can be printed in the highscore screen
buildHighScoreTmp 
                    ldy      #highScoreTmpBuffer 
                    ldd      0,x                          ; name 
                    STd      ,y++ 
                    lda      2,x                          ; name 
                    STa      ,y+ 
                    lda      # ' '
                    STa      ,y+                          ; 
                    ldb      3,x                          ;  and level 
                    cmpb     #10 
                    blt      smallerTen 
                    lda      # '1'
                    STa      ,y+                          ; 
                    subb     #10 
                    bra      greater9 

smallerTen 
                    lda      # ' '                        ;  space 
                    STa      ,y+                          ; 
greater9: 
                    addb     # '0'
                    STb      ,y+                          ; 
                    lda      # ' '
                    STa      ,y+                          ; space 
                    ldd      4,x 
                    STd      ,y++                         ; 2 byte of score 
                    ldd      6,x 
                    STd      ,y++                         ; 2 byte of score 
                    ldd      8,x 
                    STd      ,y++                         ; 2 byte of score 
                    lda      #$81 
                    STa      ,y+                          ; score done 
                    rts      

;***************************************************************************
;***************************************************************************
; divide 16 bit number in D by 16 bit number in tmp1, result must fit in 8 bit, result in b
; UNSIGNED
divide_d_by_tmp1 
                    MY_DIV_D_BY_TMP1_TO_B  
                    rts      

;***************************************************************************
; destroys tmp1 tmp2, alters X 
reduceX_by_b_timesU 
                    pshs     d 
                    stb      tmp2 
                    stu      tmp1 
                    tfr      x,d 
                    tst      tmp2 
                    beq      endreduce 
nextreduce: 
                    subd     tmp1 
                    dec      tmp2 
                    bne      nextreduce 
                    tfr      d,x 
endreduce: 
                    puls     d,pc 
;                    rts      
;***************************************************************************
; SLOW but straight forward, no need for speed!
; input number in D
; output number * 10 as ascii in conversionBuffer (with $80)
; max result -> 655350
; destroys u,x,y,d, tmp1 (16bit), tmp2 (16bit), divide_tmp
convertDToAscii 
                    ldy      #conversionBuffer 
convertDToAsciiInY 
                    tfr      d,x 
                    ldu      #10000 
                    stu      tmp1 
                    bsr      divide_d_by_tmp1 
                    bsr      reduceX_by_b_timesU 
                    addb     # '0'
                    stb      ,y 
                    tfr      x,d 
                    ldu      #1000 
                    stu      tmp1 
                    bsr      divide_d_by_tmp1 
                    bsr      reduceX_by_b_timesU 
                    addb     # '0'
                    stb      1,y 
                    tfr      x,d 
                    ldu      #100 
                    stu      tmp1 
                    bsr      divide_d_by_tmp1 
                    bsr      reduceX_by_b_timesU 
                    addb     # '0'
                    stb      2,y 
                    tfr      x,d 
                    ldu      #10 
                    stu      tmp1 
                    bsr      divide_d_by_tmp1 
                    bsr      reduceX_by_b_timesU 
                    addb     # '0'
                    stb      3,y 
                    tfr      x,d 
                    ldu      #1 
                    stu      tmp1 
                    lbsr     divide_d_by_tmp1 
                    bsr      reduceX_by_b_timesU 
                    addb     # '0'
                    stb      4,y 
                    ldd      # '0'*256+$81
                    std      5,y 
                    bra      Yleading0ToSpace 

                                                          ;rts 
;***************************************************************************
; loads the 5 ascii score pointed by x to 
; the 6 bcd score conversion buffer
; destroys d
toConversion5: 
                    ldy      #conversionBuffer 
                    ldd      ,x 
                    std      ,y 
                    ldd      2,x 
                    std      2,y 
                    lda      4,x 
                    sta      4,y 
                    lda      #0 
                    sta      5,y 
                    rts      

;***************************************************************************
; add to all values in conversion buffer a '0'
; destroys d, x
addConversion0: 
                    ldb      #5 
                    ldx      #conversionBuffer 
next0add: 
                    lda      # '0'
                    adda     ,x 
                    sta      ,x+ 
                    decb     
                    bne      next0add 
                    rts      

;***************************************************************************
; destroys d
Yleading0ToSpace 
                    pshs     y 
                    ldb      #6 
nextLeady0: 
                    lda      ,y+ 
                    cmpa     # '0'
                    bne      doneyl0 
                    lda      # ' '
                    sta      -1,y 
                    decb     
                    bne      nextLeady0 
doneyl0 
                    puls     y ,pc 
;***************************************************************************
; destroys d
YleadingSpaceTo0 
                    pshs     y 
                    ldb      #6 
nextLeady: 
                    lda      ,y+ 
                    cmpa     # ' '
                    bne      doneyl 
                    lda      # '0'
                    sta      -1,y 
                    decb     
                    bne      nextLeady 
doneyl 
                    puls     y ,pc 
; scrolls position of score one to the right
; up to a max score of 199990 -> 19999
; "bcd" values expected in conversion buffer
scrollOneRight 
                    ldy      #conversionBuffer 
                    ldd      2,y 
                    std      3,y 
                    ldd      0,y 
                    std      1,y 
                    cmpa     #10 
                    blt      doneHeresor 
                    suba     #10 
                    sta      1,y 
                    lda      #1 
                    sta      0,y 
                    rts      

doneHeresor: 
                    lda      #0 
                    sta      0,y 
                    rts      

;***************************************************************************
; SLOW but straight forward, no need for speed!
; input asccii in conversionBuffer 6 bytes + $80
; last zero is discarded!
; max input 655350
; destroys x,y,d, tmp1 (16bit), tmp2 (16bit)
convertAsciiToD 
                    ldy      #conversionBuffer 
convertAsciiToDInY 
                    bsr      YleadingSpaceTo0 
                    ldx      #0 
                    ldb      ,y 
                    subb     # '0' 
                    ldu      #10000 
                    bsr      addToX_b_timesU 
                    ldb      1,y 
                    subb     # '0' 
                    ldu      #1000 
                    bsr      addToX_b_timesU 
                    ldb      2,y 
                    subb     # '0' 
                    ldu      #100 
                    bsr      addToX_b_timesU 
                    ldb      3,y 
                    subb     # '0' 
                    ldu      #10 
                    bsr      addToX_b_timesU 
                    ldb      4,y 
                    subb     # '0' 
                    ldu      #1 
                    bsr      addToX_b_timesU 
                    tfr      x,d 
                    rts      

;***************************************************************************
addToX_b_timesU 
                    stb      tmp1 
                    beq      addDoneX 
                    pshs     d 
                    tfr      x,d 
                    stu      tmp2 
anotherAddX: 
                    addd     tmp2 
                    dec      tmp1 
                    bne      anotherAddX 
                    tfr      d,x 
                    puls     d 
addDoneX: 
                    rts      

;***************************************************************************
