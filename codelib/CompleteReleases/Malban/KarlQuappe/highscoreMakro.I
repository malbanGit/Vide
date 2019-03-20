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
MY_PRINT_TEXT_WIDTH  EQU     (80) 
MY_PRINT_TEXT_HEIGHT  EQU    -$5 
PRINT_STR_5         macro    font, font_end, font_count, textwidth, textheight 
                    STU      Vec_Str_Ptr                  ;Save string pointer 
                    LDX      #font                        ;Point to start of chargen bitmaps 
                    LDD      #$1883                       ;a->AUX: b->ORB: $8x = Disable RAMP, Disable Mux, mux sel = 01 (int offsets) 
                    CLR      <VIA_port_a                  ;Clear D/A output 
                    STA      <VIA_aux_cntl                ;Shift reg mode = 110 (shift out under system clock), T1 PB7 disabled, one shot mode 
; first entry here, ramp is disabled             
; if there was a jump from below             
; ramp will be enabled by next line
LF4A5\?: 
                    STB      <VIA_port_b                  ;ramp off/on set mux to channel 1 
                    DEC      <VIA_port_b                  ;Enable mux 
                    LDD      #$8081                       ;both to ORB, both disable ram, mux sel = 0 (y int), a:->enable mux: b:->disable mux 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_b                  ;Disable RAMP, set mux to channel 0, disable mux 
                    STA      <VIA_port_b                  ;Enable mux 
                    INC      <VIA_port_b                  ; disable mux 
; Note: 
; doing another "STB      <VIA_port_b" does not work due to timing issues!

                    LDD      #textwidth*256+1             ;Get text width 
                    STA      <VIA_port_a                  ;Send it to the D/A 
                    STB      <VIA_port_b                  ;[4]enable RAMP, disable mux 
                    BRA      LF4CB\?                      ;[3] 

; one letter is drawn (one row that is) in 18 cycles 
; 13 cycles overhead 
; ramp is thus active for #ofLetters*18 + 13 cycles 
LF4C7\?: 
                    LDA      A,X                          ;[+5]Get bitmap from chargen table 
                    STA      <VIA_shift_reg               ;[+4]rasterout of char bitmap "row" thru shift out in shift register 
LF4CB\?: 
                    LDA      ,U+                          ;[+6]Get next character 
                    BPL      LF4C7\?                      ;[+3]Go back if not terminator 
                    STA      <VIA_port_b                  ;[4]disable RAMP, disable mux 
                    NEG      <VIA_port_a                  ;Negate text width to D/A 
                    LDA      #$01                         ;enable ramp, disable mux 
                    STA      <VIA_port_b                  ;enable RAMP, disable mux 
                    CMPX     #font_end - font_count       ;[4]Check for last row 
                    BEQ      LF50A\?                      ;[3]Branch if last row 
                    LEAX     <font_count,X                ;[3]Point to next chargen row 
                    TFR      U,D                          ;[6]Get string length 
                    SUBD     Vec_Str_Ptr                  ;[7] 
                    SUBB     #$02                         ;[2] - 2 
                    BRN      LF4EB\?                      ;[3]Delay a moment 
; I think if the Macro was given the length of the string
; than another 2 cycles per line can be saved,
; since we probably could use leay -1,y bne...
; in the loop, and not only load "A", but also B with textheight!                   
LF4EB\?: 
                    LDU      Vec_Str_Ptr                  ;[6] Point to start of text string 
                    BRN      to9_3\?                      ;[3]Delay a moment 
to9_3\? 
                    LDA      #$81                         ;[2]disable RAMP, disable mux 
                    NOP                                   ;[2] 
                    DECB                                  ;[2] 
                    BNE      LF4EB\?                      ;[3]Delay some more in a loop 
                    STA      <VIA_port_b                  ;disable RAMP, disable mux 
                    LDB      #textheight-3                ;Get text height 
                    STB      <VIA_port_a                  ;Store text height in D/A [go down -> later] 
                    DEC      <VIA_port_b                  ;Enable mux 
                    LDD      #$8103 
                    STA      <VIA_port_b                  ;disable RAMP, disable mux 
                    CLR      <VIA_port_a                  ;Clear D/A 
                    BRA      LF4A5\?                      ;Go back for next scan line 

LF50A\?: 
                    LDA      #$80                         ; #$98 ; 
                    STA      <VIA_aux_cntl                ; T1->PB7 enabled 
                    endm     
;***************************************************************************
CLEAR_SCORE         macro    
                    ldd      #0 
                    std      score_digit_5 
                    std      score_digit_3 
                    stb      score_digit_1 
                    ldb      #SPACE                       ; end string with $81 
                    stb      score_digit_SPACE1           ; space betwwen score, and lives 
                    stb      score_digit_SPACE2           ; space betwwen lifes, and level 
                    ldb      # 5 
                    stb      score_digit_LIFES 
                    ldb      # 1 
                    stb      score_digit_Level 
                    ldb      #$81                         ; end string with $81 
                    stb      score_digit_front 
                    stb      score_digit_back 
                    endm     
;***************************************************************************
DO_SCORE            macro    
; move to score position
                    LDd      #(%10000010*256)+$CC         ; this and the overnext instruction, zero the beam! 
                    STB      <VIA_cntl                    ; /BLANK low and /ZERO low 
                                                          ; for positioning allways 'SCALE_FACTOR_GRID' 
; delay in zeroing + integrator reset makes display of score much nore stable
                    clr      <VIA_port_a                  ; reset integrator offset 
                    sta      <VIA_port_b                  ; 
                    LDD      #125                         ; clear A, and scale to B 
                    _SCALE_B                              ; patched for speed... /2 
                                                          ; this is again a move to D, this time D is splitted into two B, A is 
                                                          ; still 0 
                    LDB      #$7f                         ; y,x 
                    STD      <VIA_port_b 
                    LDB      #$CE                         ; Blank low, zero high? 
                    STB      <VIA_cntl                    ; 
                    INC      <VIA_port_b                  ; Disable mux 
                    STA      <VIA_t1_cnt_hi               ; enable timer 
; we load our X integrators AFTER we enable RAMP
; since this is a solidary move this is ok
; it saves a few cycles out of the timer wait
; but we have to offset the loss of ramp with a higher integration value
                    tst      currentPlayer                ; player 1 first 
                    bne      do_score_goon\? 
                    LDa      #-128                        ; X pos relative to start 
do_score_goon\? 
                    STa      <VIA_port_a                  ; Store X in D/A register 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE SCORE START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 125 cycles to spare
; do everything really slowly in here - we have time enough!!!

                    tst      intermissionActive 
                    bne      noMoveFrog 
; following move frog takes abou 80 cycles
; ideal for another in move routine!
                    JSR      move_frog                    ; get joystick stuff, and move frog, collision detection... 
                    _DP_TO_D0  
noMoveFrog: 
                    LDU      #score_digit_5               ;Vec_Str_Ptr ;Point to start of text string 
                    LDX      #zahlen2                     ;Point to start of chargen bitmaps 
                    tst      isAttractMode 
                    beq      noAtt3\? 
                    clr      VIA_t1_cnt_lo 
                    clr      VIA_t1_cnt_hi 
                    bra      noAttJmp3\? 

noAtt3\? 
                    ldb      #$40                         ; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE SCORE END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
score_draw_move\?: 
                    BITB     <VIA_int_flags               ; done with move? 
                    BEQ      score_draw_move\?            ; no, than go on waiting 
                    PRINT_STR_5  zahlen2,zahlen2_end, ZAHLEN_MAX, MY_PRINT_TEXT_WIDTH, MY_PRINT_TEXT_HEIGHT 
no_score_print\?: 
noAttJmp3\? 
                    _ZERO_VECTOR_BEAM  
                    endm     
;***************************************************************************
; special add routines. since there are only +-10 and 200 hundred 
;***************************************************************************
; the "large" adds are not cycle relevant since only used in intermissions
ADD_SCORE_100       macro    
                    lda      #(10)                        ; 
                    inc      score_digit_3 
                    cmpa     score_digit_3 
                    bgt      no_change\? 
                    clr      score_digit_3 
                    inc      score_digit_4 
                    cmpa     score_digit_4 
                    bgt      no_change\? 
                    clr      score_digit_4 
                    inc      score_digit_5 
no_change\?: 
                    endm     
;***************************************************************************
ADD_SCORE_200       macro    
                    bsr      addHundred 
                    bsr      addHundred 
                    endm     
;***************************************************************************
ADD_SCORE_500       macro    
                    ldb      #5 
again100\? 
                    jsr      addHundred 
                    decb     
                    bne      again100\? 
                    endm     
;***************************************************************************
; destroys D
ADD_SCORE_10        macro    
                    ldd      #(10*256)+0 
                    inc      score_digit_2 
                    cmpa     score_digit_2 
                    bgt      no_change\? 
                    stb      score_digit_2 
                    inc      score_digit_3 
                    cmpa     score_digit_3 
                    bgt      no_change\? 
                    stb      score_digit_3 
                    inc      score_digit_4 
                    cmpa     score_digit_4 
                    bgt      no_change\? 
                    stb      score_digit_4 
                    inc      score_digit_5 
no_change\?: 
                    endm     
;***************************************************************************
SUB_SCORE_10        macro    
                    ldd      #(0*256)+9 
                    dec      score_digit_2 
                    cmpa     score_digit_2 
                    ble      no_change\? 
                    stb      score_digit_2 
                    dec      score_digit_3 
                    cmpa     score_digit_3 
                    ble      no_change\? 
                    stb      score_digit_3 
                    dec      score_digit_4 
                    cmpa     score_digit_4 
                    ble      no_change\? 
                    stb      score_digit_4 
                    dec      score_digit_5 
                    cmpa     score_digit_5 
                    ble      no_change\? 
                    inc      score_digit_5 
no_change\?: 
                    endm     
;***************************************************************************
