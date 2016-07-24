;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
                    INCLUDE  "VECTREX.I"                  ; vectrex function includes
;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    BSS      
                    ORG      $ca00                        ; start of our ram space 
my_point:                                                 ;        structure for the Submenu 2 demo of "move point" 
my_point_y:         db       $00                          ; position 
my_point_x:         db       $00 
my_point_found:     db       0                            ; and flag whether point was moved last time or not 
;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    CODE     
                    ORG      0 
; the first few bytes are mandatory, otherwise the BIOS will not load
; the ROM file, and will start MineStorm instead
                    DB       "g GCE 1998", $80 ; 'g' is copyright sign
                    DW       music1                       ; music from the rom 
                    DB       $F8, $50, $20, -$80          ; hight, width, rel y, rel x (from 0,0) 
                    DB       "LIGHTPEN EXAMPLE", $80      ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
;
                    clr      scan_picked                  ; clear used "tmp" variable 
;;;;;;;;;;;;;;;
; main menu, displaying the 3 possible lightpen "picks" (the fourth is the the menu itself)
;;;;;;;;;;;;;;;
main1: 
                    jsr      Read_Btns                    ; get one button status first, for checking later 
                    jsr      Wait_Recal                   ; Vectrex BIOS recalibration 
                    jsr      Intensity_5F                 ; Sets the intensity of the 
                                                          ; vector beam to $5f 
; menu item 1
                    ldu      #menuitem1                   ; address of menu string 
                    jsr      print_with_pick_check        ; print string routine with loghtpen check 
                    tst      lightpen_pick                ; check if this print str triggered a lightpen pick 
                    beq      nopick1                      ; if not continue 
                    ldu      #menuitem1                   ; if yes, reload string structure 
                    leau     2,u                          ; go to the coordinates 
                    ldd      ,u                           ; load the coordinates and reuse y 
                    addb     #$60                         ; add a way to X pos 
                    bsr      print_picked                 ; and print the "picked" string 
                    jsr      Read_Btns                    ; get button status 
                    cmpa     #$00                         ; is a button pressed? 
                    bne      submenu1                     ; yes, than go to sub menu 1 
nopick1: 
; menu item 2
                    ldu      #menuitem2                   ; address of string 
                    jsr      print_with_pick_check        ; Vectrex BIOS print routine 
                    tst      lightpen_pick                ; check if this print str triggered a lightpen pick 
                    beq      nopick2                      ; if not continue 
                    ldu      #menuitem2                   ; if yes, reload string structure 
                    leau     2,u                          ; go to the coordinates 
                    ldd      ,u                           ; load the coordinates and reuse y 
                    addb     #$60                         ; add a way to X pos 
                    bsr      print_picked                 ; and print the "picked" string 
                    jsr      Read_Btns                    ; get button status 
                    cmpa     #$00                         ; is a button pressed? 
                    bne      submenu2_entry               ; yes, than go to sub menu 2 
nopick2: 
; menu item 3
                    ldu      #menuitem3                   ; address of string 
                    jsr      print_with_pick_check        ; Vectrex BIOS print routine 
                    tst      lightpen_pick                ; check if this print str triggered a lightpen pick 
                    beq      nopick3                      ; if not continue 
                    ldu      #menuitem3                   ; if yes, reload string structure 
                    leau     2,u                          ; go to the coordinates 
                    ldd      ,u                           ; load the coordinates and reuse y 
                    addb     #$50                         ; add a way to X pos 
                    bsr      print_picked                 ; and print the "picked" string 
                    jsr      Read_Btns                    ; get button status 
                    cmpa     #$00                         ; is a button pressed? 
                    lbne     submenu3                     ; yes, than go to sub menu 3 
nopick3: 
                    bra      main1                        ; and repeat forever 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; subroutine to print the "picked" string
; for main menu 1
; d = position on screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_picked: 
                    ldx      #$fc20                       ; load vector width and height 
                    stx      Vec_Text_Height              ; different, than for lightpen print str routine! 
                    ldu      #pickedCont                  ; load the address of the string 
                    jmp      Print_Str_d                  ; and print it, the subroutine returns to main, if jumped to 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sub menu 1, vector lightpen pick
; print a vector, which can be "picked" by a lightpen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
submenu1: 
                    jsr      Read_Btns                    ; get one status first, for 
                    jsr      Wait_Recal                   ; Vectrex BIOS recalibration 
                    jsr      Intensity_5F                 ; Sets the intensity of the 
; display menu name
                    ldx      #$fc20                       ; load text height/width 
                    stx      Vec_Text_Height              ; set these to BIOS location 
                    ldu      #menuitem1                   ; load name structure 
                    leau     4,u                          ; go to the string in the structure 
                    ldd      #$60e0                       ; load some coordinates (top of screen) 
                    jsr      Print_Str_d                  ; redisplay submenu name on top 
; display "go back"
                    ldu      #goBack                      ; load go back string address 
                    ldd      #$90d0                       ; load some position (bottom of screen) 
                    jsr      Print_Str_d                  ; and print it with "normal" BIOS routine 
; draw "demo vector"
                    jsr      Reset0Ref                    ; zero integrators 
                    jsr      Intensity_5F                 ; Sets the intensity $5f 
                    ldd      #$00e0                       ; load start position of demo vector 
                    jsr      Moveto_d_7F                  ; go there 
                    ldd      #$0060                       ; load y and x delta 
                    jsr      draw_vector_with_pick_check  ; and cusom draw it with lightpen check routine 
                    tsta                                  ; test if pick occured 
                    beq      no_vector_pick               ; if not, just go on 
; display "picked" string
                    ldd      #$0510                       ; load position 
                    ldx      #$fb20                       ; load vector width and height 
                    stx      Vec_Text_Height              ; different, than for lightpen print str routine! 
                    ldu      #picked                      ; load the address of the string 
                    jsr      Print_Str_d                  ; and print it, the subroutine returns to main, if jumped to 
no_vector_pick: 
                    jsr      Read_Btns                    ; get button status 
                    cmpa     #$00                         ; is a button pressed? 
                    bne      main1                        ; yes, return to main menu 
                    bra      submenu1                     ; otherwise stay in sub menu 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; main menu2, point lightpen move
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
submenu2_entry: 
; initialize upon start
                    ldd      #0                           ; point starts at pos 0,0 
                    std      my_point                     ; store to my ram position 
                    sta      my_point_found               ; also store a "not recently found" flag 
submenu2: 
                    jsr      Read_Btns                    ; get one status first, for 
                    jsr      Wait_Recal                   ; Vectrex BIOS recalibration 
                    jsr      Intensity_5F                 ; Sets the intensity of the 
; display menu name
                    ldx      #$fc20                       ; load text height/width 
                    stx      Vec_Text_Height              ; set these to BIOS location 
                    ldu      #menuitem2                   ; load name structure 
                    leau     4,u                          ; go to the string in the structure 
                    ldd      #$60e0                       ; load some coordinates (top of screen) 
                    jsr      Print_Str_d                  ; redisplay submenu name on top 
; display "go back"
                    ldu      #goBack                      ; load go back string address 
                    ldd      #$90d0                       ; load some position (bottom of screen) 
                    jsr      Print_Str_d                  ; and print it with "normal" BIOS routine 
; draw dot
                    jsr      Reset0Ref                    ; reset vectors 
                    ldd      my_point                     ; reloads coordinates, of that position 
                    jsr      Dot_d                        ; and also draw a bright dot there (BIOS function) 
; check movement
                    ldx      my_point                     ; loads coordinates, of my point to x 
                    lda      my_point_found               ; load flag if moved last time 
                    jsr      check_point_move             ; run the subroutine, which returns in the same registers as input the result 
                    sta      my_point_found               ; stroe result back to "flag" 
                    stx      my_point                     ; and to the position 
                    jsr      Read_Btns                    ; get button status 
                    cmpa     #$00                         ; is a button pressed? 
                    bne      main1                        ; yes, return to main menu 
                    bra      submenu2 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sub menu 3, location finder
; searches the screen for a lightpen "pick"
; and displayes a "dot" and a "picked" string near the pick
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
submenu3: 
                    jsr      Read_Btns                    ; get one status first, for 
                    jsr      Wait_Recal                   ; Vectrex BIOS recalibration 
                    jsr      Intensity_5F                 ; Sets the intensity of the 
; display menu name
                    ldx      #$fc20                       ; load text height/width 
                    stx      Vec_Text_Height              ; set these to BIOS location 
                    ldu      #menuitem3                   ; load name structure 
                    leau     4,u                          ; go to the string in the structure 
                    ldd      #$60e0                       ; load some coordinates (top of screen) 
                    jsr      Print_Str_d                  ; redisplay submenu name on top 
; display "go back"
                    ldu      #goBack                      ; load go back string address 
                    ldd      #$90d0                       ; load some position (bottom of screen) 
                    jsr      Print_Str_d                  ; and print it with "normal" BIOS routine 
; display "help"
                    ldu      #toScan                      ; load string address 
                    ldd      #$b0d0                       ; load some position (bottom (not bottom bottom of screen) 
                    jsr      Print_Str_d                  ; and print it with "normal" BIOS routine 
; display "picked"
                    tst      scan_picked                  ; check if we did a scan with a successfull pick befor 
                    beq      no_scan_picked               ; if not - jump 
                    ldd      scan_last_coords             ; if so, load screen position 
                    ldu      #picked                      ; load address of "picked" string 
                    jsr      Print_Str_d                  ; and display it with BIOS function 
                    ldd      scan_last_coords             ; reloads coordinates, of that position 
                    jsr      Dot_d                        ; and also draw a bright dot there (BIOS function) 
no_scan_picked: 
                    jsr      Read_Btns                    ; get button status 
                    cmpa     #$08                         ; was button 4 of joyport 0 pressed? 
                    beq      doScan                       ; if yes, jump to scan routine 
                    cmpa     #$00                         ; is another button pressed? 
                    bne      main1                        ; yes, than go back to main menu 
                    bra      submenu3                     ; otherwise stay in sub menu 

; scan whole screen for a possible pick
doScan: 
                    clr      scan_picked                  ; clear last scan status 
                    jsr      search_screen_for_lightpen   ; execute scan routine 
                    tsta                                  ; if a == 0, than NOT successfull, otherwise a pick was found 
                    beq      no_scan_pick_found           ; no pick -> jump :-( 
                    stx      scan_last_coords             ; otherwise coordinates are in X register, rememeber them in "scan_last_coords" 
                    inc      scan_picked                  ; also remember in "scan_picked" our success (anything != 0) 
no_scan_pick_found: 
                    bra      submenu3                     ; and "return" to sub menu 3 

;***************************************************************************
; DATA SECTION
;***************************************************************************
menu: 
menuitem1: 
                    DB       $E8                          ; hight 
                    DB       $20                          ; width 
                    DB       $30                          ; Y 
                    DB       -$60                         ; X 
                    DB       "VECTOR PICK"                ; only capital letters
                    DB       $80                          ; $80 is end of string 
menuitem2: 
                    DB       $E8                          ; hight 
                    DB       $20                          ; width 
                    DB       $00                          ; Y 
                    DB       -$60 
                    DB       "POINT MOVE"                 ; only capital letters
                    DB       $80                          ; $80 is end of string 
menuitem3: 
                    DB       $E8                          ; hight 
                    DB       $20                          ; width 
                    DB       -$30                         ; Y 
                    DB       -$60                         ; X 
                    DB       "LOCATION FINDER"            ; only capital letters
                    DB       $80                          ; $80 is end of string 
pickedCont: 
                    DB       "PICKED (BUTTON TO CONT)"    ; only capital letters
                    DB       $80                          ; $80 is end of string 
picked: 
                    DB       "PICKED"                     ; only capital letters
                    DB       $80                          ; $80 is end of string 
goBack: 
                    DB       "BUTTON TO GO BACK"          ; only capital letters
                    DB       $80                          ; $80 is end of string 
toScan: 
                    DB       "BUTTON 4 TO SCAN"           ; only capital letters
                    DB       $80                          ; $80 is end of string 
;***************************************************************************
                    INCLUDE  "LightpenSubroutines.i"      ; vectrex function includes
