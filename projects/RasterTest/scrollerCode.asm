USE_RELATIVE_POSITIONING = 0

 include "drawMACRO.i"

; if above is 1, than positioning of letters is relative to first letter
; if != 1 than each letter is poisitioned individually
; a "RESET" to ZERO and of the offsets
; is done befor drawing of each letter
; this is a bit slower, but perhaps results in a more
; stable display!

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
                    ORG      SCROLL_RAM_START             ; start of our ram space 
SCROLL_SCALE_FACTOR  EQU     12 
NUMBER_OF_SCROLL_LETTERS  EQU  13 
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

mov_y = tmp1
mov_x = tmp1+1
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
set_up_scrolling: 
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
                    RTS                                   ; bye bye... 

;***************************************************************************
; does one scroll step of text initialized with the above function
; does also all printing...
; expects dp set to d0
; sets intensity and trashs beam position (as well as everything else...)
; destroys tmp1
do_one_scroll_step: 
                    direct   $d0 
                    LDA      scroll_intensity             ; load intensity 
                    JSR      Intensity_a 
                    if USE_RELATIVE_POSITIONING = 1       ; at least one reset int the begining!
                        RESET_VECTOR_BEAM
                    endif

                    lda      #NUMBER_OF_SCROLL_LETTERS    ; setup counter of chars to be displayed 
                    sta      counter 
                    LDY      scroll_text_address_current  ; get address of current letter 
                    LDB      scroll_x                     ; load x coordinate 
                    ADDB     scroll_speed                 ; add to scroll speed (x coordinate that is) 
                    CMPB     scroll_x_left                ; is on left side out of bounds? 
                    BGT      getNextChar_start            ; if not go on... REALLY get the char 
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
scroll_text_not_over_yet: 
getNextChar_start: 
                    LDD      scroll_y                     ; load y, x coordinate 
                    ADDB     scroll_speed                 ; add to B (x coordinate that is) 
                    STB      scroll_x                     ; store the new x position 
                    std      tmp1                         ; this will be our next MOV, the first mov actually moves to 
                                                          ; start position of scroller, all subsequent moves only to the "width" of one scroll char! 
getNextChar: 
                    LDB      ,Y+                          ; and load the first letter of the text to B (and inc y)
                    CMPB     #$80                         ; compare to $80, end marker 
                    BNE      no_text_end                  ; if not set, go on 
                    LDY      scroll_text_address_start    ; otherwise load start address of text 
                    LDB      ,Y+                          ; and load the first letter of the text to B 
no_text_end: 
                                                          ; here we certainly have a correct 'letter'- value in B register 
                    CMPB     #' '                         ; really correct? isn't it a SPACE
                    BNE      no_scroll_space              ; no? than go on... 
                    LDX      #ABC_28                      ; otherwise zero everything, pointer to vector list 
                    BRA      load_x_with_letter_address_done ; go on 

no_scroll_space: 
                    CMPB     #'.'                         ; is it even a 'fullstop'
                    BNE      no_scroll_fullstop           ; if not... go on 
                    LDX      #ABC_26                      ; if it is load vectorlist addres to X 
                    BRA      load_x_with_letter_address_done ; and go on 

no_scroll_fullstop: 
                    CMPB     #'0'                         ; is it even a 'turtle' :-)
                    BNE      no_scroll_0                  ; if not... go on 
                    LDX      #ABC_27                      ; if it is load vectorlist addres to X 
                    BRA      load_x_with_letter_address_done ; and go on 

no_scroll_0: 
                                                          ; no it should be a 'real' letter (CAPITAL!!!) 
                                                          ; lets calculate the abc-table offset... 
                    SUBB     #'A'                         ; subtract smallest letter, so A has 0 offset
                    LSLB                                  ; multiply by two, since addresses are 16 bit 
                    CLRA                                  ; SEX it :-) 
                    ADDD     #_abc                        ; and add the abc (table of vector list address of the alphabet's letters) 
                    TFR      D,X                          ; get that into an index register (X) 
                    LDX      ,X                           ; load the letters address from the table 
load_x_with_letter_address_done: 
startScrolling: 
scroll_next_intern: 
                    if USE_RELATIVE_POSITIONING != 1
                         RESET_VECTOR_BEAM                ; draw each letter with a move from zero, perhaps more stable! 
                    endif
                    _SCALE   (SCALE_FACTOR_GAME)          ; everything we do with "positioning" is scale SCALE_FACTOR_GAME
                    ldd      tmp1                         ; the current move vector                   
                    MY_MOVE_TO_D                           ; as a macro
                                                          ; in X is the current pointer to the to be drawn char
                    _SCALE   (SCROLL_SCALE_FACTOR)        ; drawing of letters is done in SCROLL_SCALE_FACTOR

                    SIMPLE_DRAW_VL_MODE  
                    if USE_RELATIVE_POSITIONING = 1
                        lda      #0                           ; setup next move as y = 0
                        LDb      scroll_step_width            ; and width of one scroll "char"
                        std      tmp1                         ; store to temp                    
                    else
                        LDb      scroll_step_width            ; and width of one scroll "char"
                        addb     mov_x
                        stb      mov_x                        ; store to temp
                    endif
                    dec      counter                      ; are we done yet?
                    bne      getNextChar 
scroll_objects_all_done: 
                    RTS                                   ; ok, that was our scroll step :-) 

;***************************************************************************
; used variables and constants...
;
;SCROLL_SCALE_FACTOR             EQU    $6
;NUMBER_OF_SCROLL_LETTERS        EQU    10
;scroll_text_address_start       EQU    scroll_variables_start
;scroll_text_address_current     EQU    scroll_text_address_start + 2
;scroll_speed                    EQU    scroll_text_address_current + 2
;scroll_y                        EQU    scroll_speed + 1
;scroll_left_boundary            EQU    scroll_y + 1
;scroll_right_boundary           EQU    scroll_left_boundary + 1
;scroll_step_width               EQU    scroll_right_boundary + 1
;scroll_intensity                EQU    scroll_step_width + 1
;scroll_objects                  EQU    scroll_intensity + 1
;scroll_objects_end              EQU    (scroll_objects+(5*NUMBER_OF_SCROLL_LETTERS)+1)
;scroll_variables_end            EQU    scroll_objects_end
;***************************************************************************
                    include  "ABC.I"
