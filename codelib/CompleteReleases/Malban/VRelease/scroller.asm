; this file is part of Release, written by Malban in 2017
;
; 
; Scroller of text (normal vectrex text format)
; using vector chartable
; the chars 0,0
; (start is allways = end!)
; all letters are drawn in "SCROLL_SCALE_FACTOR" 
; positioning is done in "SCALE_FACTOR_GAME"
; two routines, 
; a) set_up_scrolling() need parameter set to RAM addresses (see function head)
;    expectes dp = $c8
; b) do_one_scroll_step() no parameters
;    expectes dp = $d0
; macros for MOV and DRAW_MODE
; can be replaced with BIOS to save more space (althogh slower)
; setup uses MACRO DIV
;
; RAM start must be set to SCROLL_RAM_START
                    BSS      
                    ORG      SCROLL_RAM_START             ; start of our ram space ;#isfunction 
SCROLL_SCALE_FACTOR  EQU     8 
NUMBER_OF_SCROLL_LETTERS  EQU  15 
scroll_text_address_start: 
                    ds       2                            ; this is fix for one scroll, the start of the original text 
scroll_text_address_current: 
                    ds       2                            ; this is the current scroller start position in text 
scroll_speed: 
                    ds       1                            ; speed of scroll, should be negative 
scroll_y: 
                    ds       1                            ; current y pos of scroll (allways the same) (SCALE_FACTOR_GAME) 
scroll_x: 
                    ds       1                            ; current x pos of first (top left) char in the scrolling display (SCALE_FACTOR_GAME) 
scroll_x_left: 
                    ds       1                            ; left position, lower than this and a char is "discarded" 
scroll_x_right: 
                    ds       1                            ; new chars start (more or less) here 
scroll_step_width: 
                    ds       1                            ; calculated, this is the offset between two chars in the scroller (SCALE_FACTOR_GAME) 
scroll_intensity: 
                    ds       1                            ; only set once upon every "scroll" 
counter             ds       1                            ; counte, used to count the currently drawn chars, initiates with NUMBER_OF_SCROLL_LETTERS and is brought to zero 
tmp1                ds       2                            ; used as a storage for yx position, and during setup in MUL 
divide_tmp          ds       2                            ; used in setup for DIV 
half_stepCounter    ds       1 
mov_y               =        tmp1 
mov_x               =        tmp1+1 
; clipping
v0: 
y0:                 ds       1 
x0:                 ds       1 
v1: 
y1:                 ds       1 
x1:                 ds       1 
v2: 
y2:                 ds       1 
x2:                 ds       1 
scrollReset         ds       1                            ; "round" counter of scroll text -> if 1 (or higher) the scrolltext has been fully shown 
neggi:              ds       1 
clip_test:          ds       2 
clip_line_counter:  ds       1 
clip_counter:       ds       2 
clip_pattern:       ds       2 
firstVector         ds       1 
BORDER              ds       2 
is_first_letter     ds       1 
do_another_letter   ds       1 
clipped_vector_list:  DS     20*3                         ; maximum 20 vectors to clip 
clip_end            ds       0 
                    code     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; scroll subroutines used in the startup screen                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;***************************************************************************
; below are all subroutines for scroll text
; scrolling from right to left!
; (only two) set_up_scrolling(), do_one_scroll_step()
; scroll text ends with $80
; this restarts scrolling...
;***************************************************************************
; expects text address in X register
; scroll_y:                  the y coordinate (signed byte value)
; scroll_x_left              (signed byte value)
; scroll_x_right             (signed byte value)
; scroll_speed               (signed byte value) must be negative
; scroll_intensity           (byte value)
;
; NUMBER_OF_SCROLL_LETTERS
;
; uses tmp1, tmp2
STEP_DELAY          =        1                            ; tst bpl -> 1 = 2 
set_up_scrolling:                                         ;#isfunction  
                    direct   $c8 
                    STX      scroll_text_address_start    ; remember address of first letter 
                    STX      scroll_text_address_current  ; and store it as current address 
                    LDD      #NUMBER_OF_SCROLL_LETTERS    ; how many letters are at most to be displayed at once? 
                    STD      tmp1                         ; remember that value in tmp1 (16 bit) 
                    LDB      scroll_x_right               ; load right boundary 
                    SUBB     scroll_x_left                ; subtract left boundary 
                    CLRA                                  ; SEX it, this is the 16 bit width 'in pixel' 
                    MY_DIV_D_BY_TMP1_TO_B                 ; divide it by the number of letters to be displayed 
                    STB      scroll_step_width            ; remember that as the scroll step... 
                    LDA      scroll_x_left                ; and screen address where last letter will appear 
                    STA      scroll_x                     ; here our first char will be displayed 
                    lda      #STEP_DELAY 
                    sta      half_stepCounter 
                    clr      scrollReset 
                    RTS                                   ; bye bye... 

;***************************************************************************
; does one scroll step of text initialized with the above function
; does also all printing...
; expects dp set to d0
; sets intensity and trashs beam position (as well as everything else...)
; destroys tmp1
;
; clipped version of scroll routines  
; uses hardcoded -128 <-> +127 edges, despite the fact that
; scroll_x_left and scroll_x_right are set
; they are EXPECTED to be set to those values
do_one_scroll_step:                                       ;#isfunction  
                    direct   $d0 
                    clr      is_first_letter 
                    LDA      scroll_intensity             ; load intensity 
                    JSR      Intensity_a 
                    lda      #NUMBER_OF_SCROLL_LETTERS    ; setup counter of chars to be displayed 
                    sta      counter 
                    LDY      scroll_text_address_current  ; get address of current letter 
                    tst      use_half_stepCounter 
                    bne      do_not_use_half_steps 
                    dec      half_stepCounter 
                    bpl      no_scrollstep_change 
                    lda      #STEP_DELAY 
                    sta      half_stepCounter 
do_not_use_half_steps 
                    clr      neg_test                     ; 0 = positive, 1 = netgaive 
                    LDB      scroll_x                     ; load x coordinate 
                    bpl      no_neg_s 
                    inc      neg_test                     ; if 1 then negative 
no_neg_s 
                    ADDB     scroll_speed                 ; add to scroll speed (x coordinate that is) 
                    bmi      notestForSignChange 
                    tst      neg_test 
                    bne      scroll_overflow_hardcoded    ; if true than an overflow from negative to positive occured 
notestForSignChange 
                    CMPB     scroll_x_left                ; is on left side out of bounds? 
                    BGT      getNextChar_start            ; if not go on... REALLY get the char 
scroll_overflow_hardcoded 
                    lda      scroll_step_width            ; other wise correct x position 
                    adda     scroll_x                     ; the start of X now should point to the NEXT char, whoch is one "width" away 
                    sta      scroll_x                     ; and remember it 
                    leay     1,y                          ; increment char pointer to scrolltext by one 
                    STY      scroll_text_address_current  ; and store it back 
                                                          ; init new letter here 
                    LDB      ,Y                           ; load the current letter to B 
                    CMPB     #$80                         ; compare to $80, end marker 
                    BNE      scroll_text_not_over_yet     ; if not set, go on 
                    LDY      scroll_text_address_start    ; otherwise load start address of text 
                    STY      scroll_text_address_current  ; store it as current 
; inc scrollReset
scroll_text_not_over_yet: 
getNextChar_start: 
                    LDD      scroll_y                     ; load y, x coordinate 
                    ADDB     scroll_speed                 ; add to B (x coordinate that is) 
                    STB      scroll_x                     ; store the new x position 
                    std      tmp1                         ; this will be our next MOV, the first mov actually moves to 
                                                          ; start position of scroller, all subsequent moves only to the "width" of one scroll char! 
                    bra      getNextChar 

no_scrollstep_change 
                    LDD      scroll_y                     ; load y, x coordinate 
                    std      tmp1                         ; this will be our next MOV, the first mov actually moves to 
getNextChar: 
                    LDB      ,Y+                          ; and load the first letter of the text to B (and inc y) 
                    CMPB     #$80                         ; compare to $80, end marker 
                    BNE      no_text_end                  ; if not set, go on 
                    inc      scrollReset 
                    LDY      scroll_text_address_start    ; otherwise load start address of text 
                    LDB      ,Y+                          ; and load the first letter of the text to B 
no_text_end: 
                                                          ; here we certainly have a correct 'letter'- value in B register 
                    CMPB     # ' '                        ; really correct? isn't it a SPACE
                    BNE      no_scroll_space              ; no? than go on... 
                    LDX      #ABC_28                      ; otherwise zero everything, pointer to vector list 
                    BRA      load_x_with_letter_address_done ; go on 

no_scroll_space: 
                    CMPB     # '.'                        ; is it even a 'fullstop'
                    BNE      no_scroll_fullstop           ; if not... go on 
                    LDX      #ABC_26                      ; if it is load vectorlist addres to X 
                    BRA      load_x_with_letter_address_done ; and go on 

; small letter "blink" in the scrolltext!
no_scroll_fullstop: 
                    CMPB     # '!'                        ; is it even a 'fullstop'
                    BNE      noExclamation                ; if not... go on 
                    LDX      #ABC_29                      ; if it is load vectorlist addres to X 
                    BRA      load_x_with_letter_address_done ; and go on 

noExclamation 
                    lda      #$5f 
                    sta      scrollIntensity 
no_scroll_0: 
                    cmpb     # 'a'
                    blo      noBlinky 
                    subb     #( 'a'-'A')
                    lda      scrollBlink 
                    sta      scrollIntensity 
noBlinky 
                                                          ; now it should be a 'real' letter (CAPITAL!!!) 
                                                          ; lets calculate the abc-table offset... 
                    SUBB     # 'A'                        ; subtract smallest letter, so A has 0 offset
                    LSLB                                  ; multiply by two, since addresses are 16 bit 
                    ldx      #_abc 
                    LDX      b,X                          ; load the letters address from the table 
load_x_with_letter_address_done: 
startScrolling: 
scroll_next_intern: 
                    _ZERO_VECTOR_BEAM                     ; draw each letter with a move from zero, more stable 
                    _SCALE   (SCALE_FACTOR_GAME)          ; everything we do with "positioning" is scale SCALE_FACTOR_GAME 
                    ldb      mov_x 
                    bmi      not_last_letter 
                    addb     scroll_step_width 
                    cmpb     mov_x 
                    bgt      isPerhapsLastLetter          ; 
                    bra      isLastLetter 

isPerhapsLastLetter 
                    lda      counter 
                    cmpa     #1 
                    bne      not_last_letter 
isLastLetter 
                    ldb      scroll_x_right               ; +127 
                    subb     mov_x                        ; - 124 (e.g.) = -4 
                    cmpb     #8                           ; scale of letter is 64 
                    bhi      noClipRight_s 
                    clra     
                    lslb     
                    lslb     
                    lslb                                  ; times 8 
                    pshs     y 
                    JSR      clip_vlp_p2_right 
                    puls     y 
noClipRight_s 
not_last_letter 
                    tst      is_first_letter 
                    bne      not_first_letter 
                                                          ; in X is the current pointer to the to be drawn char 
; check position, if very left, than I can  do a clipping
; HARDCODE left most here!
                    ldb      scroll_x_left                ; -128 
                    subb     scroll_x                     ; - -124 (e.g.) = -4 
                    negb     
                                                          ; scale of positioning is $60 
                                                          ; strength of positioning is max $ff (-128 <-> +127 
                                                          ; -> max pos in dec = +-12192 "pixel" 
                                                          ; scrolling is done by 1 Strength 
                                                          ; that means the minimum movement is 96 pixel per step 
                                                          ; 15 letter maximum 
                                                          ; each letter takes up 812 "pixel" 
                                                          ; the scroll step per letter per "pixel" is thus "8" (812 / 96) 
                                                          ; thus we must calculate 8 different "clipping" positions per letter. 
                                                          ; strength of letter is max $40 
                                                          ; thus $40/8 = 64/8 = 8 
                                                          ; we habe one clipping position each 8 pixels in each letter 
                    cmpb     #8                           ; scale of letter is 64 
                    bhi      noClipLeft_s 
                    negb     
                    addb     #8 
                    clra     
                    lslb     
                    lslb     
                    lslb                                  ; times 8 
                    pshs     y 
                    JSR      clip_vlp_p2_left 
                    puls     y 
noClipLeft_s 
                    inc      is_first_letter 
not_first_letter 
                    ldd      tmp1                         ; the current move vector 
                    MY_MOVE_TO_D_START_NT  
                    LDb      scroll_step_width            ; and width of one scroll "char" 
                    stb      do_another_letter            ; anything but zero indicates another letter must be drawn 
                    addb     mov_x 
                    cmpb     mov_x 
                    bgt      scroll_objects_all_notdone_1 
                    clr      do_another_letter 
scroll_objects_all_notdone_1 
                    stb      mov_x                        ; store to temp 
                    dec      counter                      ; are we done yet? 
                    bne      scroll_objects_all_notdone_2 
                    clr      do_another_letter 
scroll_objects_all_notdone_2 
                    _SCALE   24                           ; (SCROLL_SCALE_FACTOR) ; drawing of letters is done in SCROLL_SCALE_FACTOR 
                    lda      scrollIntensity 
                    MY_MOVE_TO_B_END  
                    _INTENSITY_A  
                    jsr      myDraw_VL_mode3 
                    tst      do_another_letter 
                    lbne     getNextChar 
                    rts      

scroll_objects_all_done: 
                    RTS                                   ; ok, that was our scroll step :-) 

                    include  "abc.i"
                    include  "clip.i"
