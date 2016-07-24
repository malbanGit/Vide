                    bss      
                    org      $c880                        ; double used for different sets of routines 
; temp vars for scan line scanning
scanline_no         ds       1                            ; number of scanlines to print ($7A is count down to 0) 
scanline_coords     ds       2                            ; current coordinate of scanlines printed (y,x) 
scan_picked         ds       1                            ; result of scan line search != 0 is success, == 0 is fail 
scan_last_coords    ds       2                            ; resulting coordinates of a successfull search 
;
                    bss      
                    org      $c880                        ; double used for different sets of routines 
cursor              ds       12                           ; used by lightpen find routines (web search) 
;
                    CODE     
Char_Table          EQU      $F9F4                        ; BIOS font table locations 
Char_Table_End      EQU      $FBD4 
lightpen_pick       EQU      $C89E                        ; if pick occured != 0, if not occured = 0, used in print_with_pick_check 
string_length_1     EQU      $C84F                        ; temporary pointer to string length +1 , used in print_with_pick_check 
; offsets in cursor structure
POS                 equ      0 
Y_POS               equ      0 
X_POS               equ      1 
PICK_FOUND_NOW      equ      2                            ; indicator if a pick was found (after the routines finished), 
                                                          ; while the routine is running and webbing, this is also an index to the "web" scale factor 
DELTA               equ      3 
Y_DELTA             equ      3 
X_DELTA             equ      4 
PICK_FOUND_LAST     equ      5 
Y_MAX               equ      6 
X_MIN               equ      7 
Y_MIN               equ      8 
X_MAX               equ      9 
WEB_PATTERN         equ      10 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; PUBLIC ROUTINE print_with_pick_check U
;
; routine taken from Fred Tafts disassembly of Artmaster
; and changed to accomodate the examples
; print_with_pick_check(string_ptr)
;
;
; At entry: 'u' must point to the string block.
;
; The routine is nearly identical to the "usual" print_str routine
; the only difference is the check for the CA1 interrupt during string printing
; to accomodate the cecking (which is timed to be exactly 18 cycles)
; the string length is internally thought of as strlen = strlen + 1
; that way the "usual" calculating of the "return" way can be done.
;        
;        Prints a string of character, terminated by $80. 
;        At entry, the 'u' register must point to a block
;        having the following format: 
;        
;        1 byte height of string 
;        1 byte width of string 
;        1 byte rel y location 
;        1 byte rel x location 
;        
;        At exit: lightpen_pick will be set if a pick occurred. 
; expected DP = d0
                    direct   $d0 
print_with_pick_check: 
                    jsr      Reset0Ref                    ;ensure string is positionend at zero 
                    ldd      ,u++                         ;load sizes 
                    std      Vec_Text_Height              ;store sizes in BIOS locations 
                    ldd      ,u++                         ;load position 
                    jsr      Moveto_d_7F                  ;and go there 
                    stu      Vec_Str_Ptr                  ;Save string pointer 
                    leau     -1,u                         ;pointer to one position befor the string start 
                    stu      string_length_1              ;needed to calculate string length +1 
                    clr      <VIA_int_flags               ;clear CA1 interrupt, so we can chaeck for it 
                    clr      lightpen_pick                ;clear last pick 
                    ldx      #Char_Table-$20              ;Point to start of chargen bitmaps 
                    ldd      #$1883                       ;a->AUX: b->ORB: $8x = Disable RAMP, Disable Mux, mux sel = 01 (int offsets) 
                    clr      <VIA_port_a                  ;Clear D/A output 
                    sta      <VIA_aux_cntl                ;Shift reg mode = 110 (shift out under system clock), T1 PB7 disabled, one shot mode 
next_font_row: 
                    stb      <VIA_port_b                  ;ramp off/on set mux to channel 1              
                    dec      <VIA_port_b                  ;Enable mux              
                    ldd      #$8081                       ;both to ORB, both disable ram, mux sel = 0 (y int), a:->enable mux: b:->disable mux              
                    nop                                   ;Wait a moment              
                    inc      <VIA_port_b                  ;Disable mux              
                    stb      <VIA_port_b                  ;Disable RAMP, set mux to channel 0, disable mux              
                    sta      <VIA_port_b                  ;Enable mux              
                    tst      $C800                        ;a delay only              
                    inc      <VIA_port_b                  ;disable mux              
                    lda      Vec_Text_Width               ;Get text width              
                    sta      <VIA_port_a                  ;Send it to the D/A 
                    ldd      #$0100                       ;both to ORB, both ENABLE RAMP, a:-> disable mux, b:-> enable mux              
                    ldu      Vec_Str_Ptr                  ;Point to start of text string              
                    sta      <VIA_port_b                  ;[4]enable RAMP, disable mux 
                    bra      shift_load                   ;[3] 

next_shift: 
; one letter is drawn (one row that is) in 18 cycles 
; 13 cycles overhead 
; ramp is thus active for #ofLetters*18 + 13 cycles P0B5E:              
                    lda      a,x                          ;[+5]Get bitmap from chargen table 
                    sta      <VIA_shift_reg               ;[+4]rasterout of char bitmap "row" thru shift out in shift register 
shift_load: 
                    lda      ,u+                          ;[+6]Get next character 
                    bpl      next_shift                   ;[+3]Go back if not terminator 
                    lda      <VIA_int_flags               ;[4] Record any picks. 
                    anda     #$02                         ;[2]CA1 - did an interrupt occur (lightpen on the vector of this string) 
                    ora      lightpen_pick                ;[5]checking of interreuptbit 
                    sta      lightpen_pick                ;[5]is done so it takes also 18 cycles, this way we compensate the 
                    nop                                   ;[2]checking with an imaginary strlen +1 (see below) 
                    lda      #$81                         ;[2]disable mux, disable ramp 
                    sta      <VIA_port_b                  ;[2]disable mux, disable ramp 
                    neg      <VIA_port_a                  ;[6]Negate text width to D/A 
                    lda      #$01                         ;[2]enable ramp, disable mux 
                    sta      <VIA_port_b                  ;[4]enable RAMP, disable mux 
                    cmpx     #Char_Table_End-$20          ;[4]Check for last row 
                    beq      string_done                  ;[3]Branch if last row 
                    leax     $50,x                        ;[3]Point to next chargen row 
                    tfr      u,d                          ;[6]Get string length 
                    subd     string_length_1              ;[7] delay must be 1 "char" longer, since checking of interrupt bit 
                    subb     #$02                         ;[2] - 2 
                    aslb                                  ;[2] * 2 calculate return "way" 
                    brn      delay_jump                   ;[3]Delay a moment 
delay_jump: 
                    lda      #$81                         ;[2]disable RAMP, disable mux 
                    nop                                   ;[2] 
                    decb                                  ;[2] 
                    bne      delay_jump                   ;[3]Delay some more in a loop 
                    sta      <VIA_port_b                  ;disable RAMP, disable mux 
                    ldb      Vec_Text_Height              ;Get text height 
                    stb      <VIA_port_a                  ;Store text height in D/A [go down -> later] 
                    dec      <VIA_port_b                  ;Enable mux 
                    ldd      #$8101 
                    nop                                   ;Wait a moment 
                    sta      <VIA_port_b                  ;disable RAMP, disable mux 
                    clr      <VIA_port_a                  ;Clear D/A 
                    stb      <VIA_port_b                  ;enable RAMP, disable mux 
                    sta      <VIA_port_b                  ;disable RAMP, disable mux 
                    ldb      #$83                         ;$8x = disable ramp, disable mux 
                    bra      next_font_row 

string_done:        lda      #$98 
                    sta      <$0B                         ;VIA_aux_cntl 
                    jmp      Reset0Ref                    ;Reset the zero reference 

;;;;;;;;;;;;;;;;;;;;;;;
; PUBLIC ROUTINE Draw_Line_d_pick_check D -> A
;
; This routine draws a vector, starting at current pen position 
; to the point specified by the (y,x) pair specified in the D register. 
; current scale factor is used.
; if a pick occured a != 0, if no pick occured a = 0;
;
; At entry: 
; 'b' points to x delta
; 'a' points to y delta
;
; At exit: 
; 'a' = 0 => no pick
; otherwise a pick occurred. 
;
draw_vector_with_pick_check: 
                    sta      <VIA_port_a                  ; Set rel y position. 
                    clr      <VIA_port_b                  ; mux sel = integrator Y, mux enabled 
                    lda      #$ff                         ; pattern = $ff -> full line 
                    inc      <VIA_port_b                  ; mux off 
                    stb      <VIA_port_a                  ; Set rel x position. 
                    sta      <VIA_shift_reg               ; Set line pattern. 
                    clr      <VIA_t1_cnt_hi               ; start t1 timer (scale) 
                    ldd      #$0040                       ; bit 6 = t1 timer interrupt 
timerCheck_loop: 
                    bitb     <VIA_int_flags               ; check if scale has run out 
                    beq      timerCheck_loop              ; if interrupt not set -> timer still running 
                    exg      x,x                          ; delay 
                    sta      <VIA_shift_reg               ; shiftreg = 0, pattern = 0, light is off 
                    lda      <VIA_int_flags               ; Check for a lightpen pick 
                    anda     #$02                         ; bit 1 = ca1 interrupt 
                    rts      

; PUBLIC ROUTINE search_screen_for_lightpen -> A, X
;        
;        
; This routine attempts to locate the location of the 
; lightpen, by drawing a series of horizontal scan lines. 
; Starting from the bottom of the display, a series of 
; lines are drawn, until either a lightpen pick occurs, 
; or the last scan line is drawn. If a lightpen pick 
; occurs, then that particular scan line will again be 
; drawn, only this time, interrupts will be enabled, so 
; that the exact location of the pick can be determined. 
;        
; At exit: 
; 'a' = 0 if lightpen was not located.
; 'a' = $FF if lightpen was located.
;        
; The location 
; of the 'pick' is returned in the 'x' register.
;
; Work variables: 
; scanline_no: contains the number of scan lines left to draw. 
; scanline_coords: contain starting point for next scan line. 
search_screen_for_lightpen: 
                    lda      #$7A                         ; # of scan lines 
                    sta      scanline_no                  ; Init to draw 
                    ldd      #$8880                       ; bottom left of screen 
                    std      scanline_coords              ; Init start pt for first scan line 
draw_next_scanline: 
                    tst      scanline_no                  ; are we finished drawing scanlines (0 left) 
                    bne      draw_scan_line               ; if not, jump 
                    jsr      Reset0Ref                    ; if so, reset beam 
                    clra                                  ; If we make it to here, then the, result A = 0 
                    rts                                   ; lightpen was not found. 

draw_scan_line: 
                    jsr      Reset0Ref                    ; reset vector position 
                    ldd      scanline_coords              ; current scanline coordinate 
                    jsr      Moveto_d_7F                  ; Move to start of scan line 
                    clr      <VIA_port_a                  ; dac = 0 (y delta = 0) 
                    clr      <VIA_port_b                  ; mux enable, mux sel = int 7 
                    ldb      #$FF                         ; scale of $ff 
                    stb      <VIA_t1_cnt_lo               ; timer t1 low = scale 
                    inc      <VIA_port_b                  ; mux disabled 
                    lda      #$7F                         ; maximum x delta 
                    sta      <VIA_port_a                  ; set to dac 
                    ldd      #$FF40                       ; solid pattern (a = $ff), bitcheck for T1 interrupt b = $40 
                    sta      <VIA_shift_reg               ; Use solid line pattern. 
                    clr      <VIA_t1_cnt_hi               ; start timer t1 
scanline_t1_loop: 
                    bitb     <VIA_int_flags               ; check if draw finished 
                    beq      scanline_t1_loop             ; no - jump 
                    clr      <VIA_shift_reg               ; pattern = 0, light = off 
                    lda      #$02                         ; Check for a lightpen pick 
                    bita     <VIA_int_flags               ; test intertupt 
                    bne      find_point_of_intersection   ; if interrupt found, than lightpen was found, branch for further checking 
                    dec      scanline_no                  ; No lightpen pick, so continue 
                    lda      scanline_coords              ; to draw the next scan line 
                    adda     #$02                         ; (which is 2 "pixels" up) 
                    sta      scanline_coords              ; store it 
                    bra      draw_next_scanline           ; and draw another 

; INTERNAL ROUTINE
;        
; find_point_of_intersection() 
; 
; This routine is responsible for locating the exact 
; location of the lightpen, after a pick has occurred 
; while a scan line was being drawn. It does this in 
; the following manner: 
; 
; The pen is moved back to the start of the previous 
; scan line, and lightpen interrupts are enabled. 
; Next, the scan line is redrawn ; while this is going 
; on, a timing (counter) loop is executed. If the 
; timing loop completes, then it implies that the 
; lightpen was not located     
; interrupts will be disabled, 
; and control will return to the procedure which had 
; originally invoked the scan line routine. 
; However, if the lightpen interrupts, then the timing 
; loop is interrupted, and the ISR handling routine is 
; called. This handler will calculate the exact location 
; of the lightpen, using the value in the counter. If 
; an interrupt occurs, control will never return to 
; this routine                 
; control returns directly to the routine 
; which had invoked the scan line routine. The location 
; of the 'pick' is returned in the 'x' register.
find_point_of_intersection: 
                    jsr      Reset0Ref                    ; reset integrators 
                    ldd      scanline_coords              ; load current scanline coordinates 
                    jsr      Moveto_d_7F                  ; Move to start of scan line 
                    andcc    #$EF                         ; Enable IRQ on 6809 
                    lda      #$82                         ; bitmask for PIA interrupt CA1 enable 
                    sta      <VIA_int_enable              ; Enable CA1 on PIA 
                    lda      #$7E                         ; write: "JMP #process_ISR" (JMP = $7e) 
                    sta      Vec_IRQ_Vector               ; to irq location in RAM $CBF8 (Vec_IRQ_Vector) 
                    ldd      #process_ISR                 ; adress of interrupt handling routine 
                    std      Vec_IRQ_Vector+1             ; store it to the vector 
                    clr      <VIA_port_a                  ; no Y movement (dac = 0) 
                    clr      <VIA_port_b                  ; mux = enabled, select = 0 (y integrators) 
                    clr      <VIA_t1_cnt_lo               ; T1 timer = 0 
                    nop                                   ; delay 
                    inc      <VIA_port_b                  ; mux = disabled 
                    lda      #$20                         ; A= $20 
                    sta      <VIA_port_a                  ; DAC = A ($20), X - delta 
                    lda      #$FF                         ; pattern of line $ff full draw 
                    sta      <VIA_shift_reg               ; to shiftreg 
                    ldb      #$7F                         ; load a "counter to b 
                    lda      #$05                         ; load timer T1 with 5*255 
                    sta      <VIA_t1_cnt_hi               ; store to T1 high and start timer 
interrupt_wait_loop: 
                    decb                                  ; loop counter to calc position 
                    brn      interrupt_wait_loop          ; delay 3 cycles (branch never) 
                    bne      interrupt_wait_loop          ; loop till interrupt occurs (either T1 or lightpen) 
                    clr      <VIA_t1_cnt_hi               ; stop timer 1 
                    jsr      disable_interrupts           ; disabled intterrupts 
                    clra                                  ; indicate not found 
                    rts                                   ; return 

; INTERNAL ROUTINE
;        
; disable_interrupts() 
; 
; This routine is responsible for disabling lightpen 
; interrupts. 
disable_interrupts: 
                    clra                                  ; A=0 
                    sta      <VIA_int_enable              ; Disable CA1 on PIA 
                    sta      <VIA_port_a                  ; DAC = 0 
                    sta      <VIA_int_flags               ; clear interrupts 
                    orcc     #$10                         ; Disable IRQ on 6809 
                    jsr      Reset0Ref                    ; Integrator reset 
                    rts                                   ; return 

; INTERNAL ROUTINE
;        
; process_ISR() 
; 
; This is the entry point called by the OS, whenever the 
; lightpen generates an IRQ interrupt. This procedure 
; discards the 12 bytes of saved state information 
; placed on the stack by the 6809, including the return 
; address for the interrupted routine. 
;
; This procedure performs most of the work involved, 
; whenever the lightpen generates an interrupt. It 
; uses the counter value, in the 'b' register, to
; calculate the x coordinate of the lightpen. The 
; intersection point is returned in the 'x' register.
; This routine returns to the routine which invoked 
; the scan line search routine. 
process_ISR: 
                    leas     12,s                         ; restore interrupt "corrupted" stack 
                    com      <VIA_shift_reg               ; clear shiftreg 
                    clr      <VIA_t1_cnt_hi               ; clear T1 timer (hi) 
                    subb     #$7F                         ; invert b (start was at $7f, "inverting" it gives "time from start" 
                    negb                                  ; we will "add" this to starting pos ($80) therefor negative (sub -)) 
                    aslb                                  ; double it 
                    sex                                   ; and sign extend it 
                    subd     #$0080                       ; and "add" it to our negative starting pos 
                    lda      scanline_coords              ; Retrieve y coordinate, and join it 
                    tfr      d,x                          ; result in X 
                    jsr      disable_interrupts           ; 
                    lda      #$FF                         ; A = $FF -> Lightpen found 
                    rts                                   ; 

; PUBLIC ROUTINE check_point_move X, A -> X, A
;
; checks point in x if lightpen moved to a location surrounding it
; returns in x either the same coordinates (no move)
; expects in a a value (ff or 0) whether in last "round" a move/pick was found
; also if a pick/move was found, A returns ff (0 if no pick move was found, ff if pick was found)
; or returns in x the new coordinates
;
; routines use internally a "cursor" structure as defined in artmaster:
; The cursor struct is 12 bytes long, and is laid out 
; as follows: 
; 
; ************************ 
; * 0 cursor rel y pos * 
; ************************ 
; * 1 cursor rel x pos * 
; ************************ 
; * 2 found this pass flag* 
; ************************ 
; * 3 cursor y delta * \ 
; ************************ > Used when moving cursor 
; * 4 cursor x delta * / to follow light pen 
; *********************** 
; * 5 found last pass flag* 
; ************************ 
; * 6 max y position * 
; ************************ 
; * 7 min x position * 
; ************************ 
; * 8 min y position * 
; ************************ 
; * 9 max x position * 
; ************************ 
; * 10+11 ptr to line pattern 
; ** array used when ** 
; * drawing search webs * 
; ************************ 
check_point_move: 
; fill the internally used cursor structure 
                    ldu      #cursor                      ; cursor address (RAM location, 12 bytes) 
                    stx      POS,u                        ; save current screen location in cursor struct y,x 
                    sta      PICK_FOUND_LAST,u            ; store last pick information in cursor struct 
                    ldd      #$7f80                       ; y-max, x-min 
                    std      Y_MAX,u                      ; store in cursor struct 
                    ldd      #$807f                       ; y-min, x-max 
                    std      Y_MIN,u                      ; store in cursor struct 
                    ldd      #whole_search_pattern        ; default is while search pattern 
                    std      WEB_PATTERN,u                ; store in cursor struct 
                    jsr      update_cursor_position       ; search for nearby lightpen pos 
                    ldx      ,u                           ; update the return "vars" (registers) with position 
                    lda      PICK_FOUND_NOW,u             ; and whether a "pick" was found 
                    rts                                   ;done 

; INTERNAL ROUTINE
; 
; update_cursor_position_new() 
;
; Malban:
; Not used - this is the "non" optimized version of update_cursor_position.
; Non optimized as in I don't check for min/max and I don't reduce the search pattern 
; in regard of the direction we moved.
; 
; This routine attempts to move the cursor so that 
; it 'stays' with  the lightpen.  First, it sees if
; the lightpen is still within 'sight' of the cursor.
; This is done by draw a series of 'spider web' patterns,
; until the lightpen is found, or the max web is drawn. 
; Then it takes the deltas calculated by the search routine, 
; adds them to the current cursor position, performs some 
; bounds checks, and updates the line patterns used when 
; drawing the search webs. 
update_cursor_position_new: 
                    jsr      find_lightpen                ; Try to find lightpen. 
                    lda      PICK_FOUND_NOW,u             ; Proceed only if the lightpen 
                    cmpa     #$FF                         ; was found somewhere. 
                    bne      exit_now                     ; otherwise jump to exit 
                    ldb      <<Y_POS,u                    ; Get y position, 
                    sex                                   ; & extend to 16 bits 
                    pshs     a,b                          ; tmp storage on stack 
                    ldb      Y_DELTA,u                    ; get new y delta 
                    sex                                   ; & extend to 16 bits 
                    addd     ,s++                         ; Add together (and cleanup stack) 
                    stb      <<Y_POS,u                    ; store result cursor structure. 
                    ldx      #whole_search_pattern        ; place whole search pattern 
                    stx      WEB_PATTERN,u                ; in cursor structure 
P0949_new:          ldb      X_POS,u                      ; Load current x coordinate, and 
                    sex                                   ; extend it to 16 bits. 
                    pshs     a,b                          ; tmp storage on stack 
                    ldb      X_DELTA,u                    ; get new x delta 
                    sex                                   ; & extend to 16 bits 
                    addd     ,s++                         ; Add together (and cleanup stack) 
                    stb      X_POS,u                      ; tore result cursor structure. 
exit_now: 
                    rts                                   ; done 

; INTERNAL ROUTINE
; 
; update_cursor_position() 
; 
; This routine attempts to move the cursor so that 
; it 'stays' with the lightpen. First, it sees if 
; the lightpen is still within 'sight' of the cursor. 
; This is done by draw a series of 'spider web' patterns, 
; until the lightpen is found, or the max web is drawn. 
; Then it takes the deltas calculated by the search routine, 
; adds them to the current cursor position, performs some 
; bounds checks, and updates the line patterns used when 
; drawing the search webs. 
update_cursor_position: 
                    jsr      find_lightpen                ; Try to find lightpen. 
                    lda      PICK_FOUND_NOW,u             ; Proceed only if the lightpen 
                    cmpa     #$FF                         ; was found somewhere. 
                    bne      exit_now2                    ; otherwise jump to exit 
                    ldb      <<Y_POS,u                    ; Get y position, 
                    sex                                   ; & extend to 16 bits 
                    pshs     a,b                          ; store int tmp (stack) 
                    ldb      Y_DELTA,u                    ; Get new y delta 
                    sex                                   ; & extend to 16 bits 
                    addd     ,s++                         ; Add together (and cleanup stack) 
                    pshs     a,b                          ; store int tmp (stack) 
; Compare new coordinate to max y value. Use max y value, if new is larger
                    ldb      Y_MAX,u                      ; load max y form cursor struct 
                    sex                                   ; sign extend max (8 bit value) 
                    cmpd     <<0,s                        ; compare with "tmp" coordinate if too big. 
                    bgt      y_not_to_large               ; jmp if value is ok 
                    leas     2,s                          ; correct stack, we don't need tmp value anymore 
                    ldx      #lower_search_pattern        ; we are at max y, so we don't serach the top anymore 
                    stx      WEB_PATTERN,u                ; Use lower search pattern 
                    lda      Y_MAX,u                      ; use max y as coordinate 
                    sta      <<0,u                        ; store that in cursor structure 
                    bra      vertical_done                ; and vertical is done 

y_not_to_large: 
; Compare new coordinate to min y value. Use min y value if new cordinate is too small. 
                    ldb      Y_MIN,u                      ; load min y from cursor struct 
                    sex                                   ; sign extend 
                    cmpd     <<0,s                        ; compare to our current value 
                    blt      y_not_to_low                 ; jump if value is ok 
                    leas     2,s                          ; correct stack, we don't need tmp value anymore 
                    ldx      #upper_search_pattern        ; we are at min y, so we don't serach the bottom anymore 
                    stx      WEB_PATTERN,u                ; Use upper search pattern 
                    lda      Y_MIN,u                      ; use min y as coordinate 
                    sta      <<Y_POS,u                    ; store that in cursor structure 
                    bra      vertical_done                ; done with y 

y_not_to_low: 
                    ldd      ,s++                         ; Save new y coordinate in the (and restore stack) 
                    stb      <<Y_POS,u                    ; cursor structure. 
                    ldx      #whole_search_pattern        ; we must use the whole search pattern 
                    stx      WEB_PATTERN,u                ; Use whole search pattern. 
vertical_done: 
                    ldb      X_POS,u                      ; Load current x coordinate, and 
                    sex                                   ; extend it to 16 bits. 
                    pshs     a,b                          ; store int tmp (stack) 
                    ldb      X_DELTA,u                    ; Get new x delta 
                    sex                                   ; & extend to 16 bits 
                    addd     ,s++                         ; Add together (and cleanup stack) 
                    pshs     a,b                          ; store int tmp (stack) 
; Compare new x coordinate to max x value. Use max value if new coord is too big. 
                    ldb      X_MAX,u                      ; load max x form cursor struct 
                    sex                                   ; sign extend max (8 bit value) 
                    cmpd     <<0,s                        ; compare with "tmp" coordinate if too big. 
                    bgt      x_not_to_large               ; jmp if value is ok 
                    leas     2,s                          ; correct stack, we don't need tmp value anymore 
                    ldx      #left_search_pattern         ; we are at max x, so we don't serach the right anymore 
                    stx      WEB_PATTERN,u                ; Use left search pattern 
                    lda      X_MAX,u                      ; use max x as coordinate 
                    sta      X_POS,u                      ; store that in cursor structure 
                    bra      horizontal_done              ; and horizontal is done 

x_not_to_large: 
                                                          ; Compare new coordinate to min x value. Use min value, if new coordinate is too small. 
                    ldb      X_MIN,u                      ; load min x from cursor struct 
                    sex                                   ; sign extend 
                    cmpd     <<0,s                        ; compare to our current value 
                    blt      x_not_to_low                 ; jump if value is ok 
                    leas     2,s                          ; correct stack, we don't need tmp value anymore 
                    ldx      #right_search_pattern        ; we are at min x, so we don't serach the left anymore 
                    stx      WEB_PATTERN,u                ; Use right search pattern 
                    lda      X_MIN,u                      ; use min x as coordinate 
                    sta      X_POS,u                      ; store that in cursor structure 
                    bra      horizontal_done              ; done with x 

x_not_to_low:       ldd      ,s++                         ; Save new y coordinate in the (and restore stack) 
                    stb      X_POS,u                      ; cursor structure. 
horizontal_done: 
exit_now2:          rts                                   ; done 

; INTERNAL ROUTINE
; 
; find_lightpen() 
; 
; It does this in the following manner: 
; 
; Firstly, it moves to the last known location of 
; the cursor, and draws a dot. If a lightpen pick 
; occurs, then no further searching is needed, 
; the lightpen has not moved. However, if the lightpen 
; has moved, then we must perform a more extensive 
; search. However, if the lightpen was not found 
; the last time we searched for it, then we won't
; bother searching for it now ; we don't want to 
; continually clutter the screen with our search 
; patterns! 
; 
; Secondly, we will draw a series of ever increasing 
; 8 sided spider webs. If, while drawing one of these 
; search patterns, a lightpen pick is detected, then 
; we will determine which vector of the pattern was 
; picked, and we will calculate a cursor movement 
; delta dependent upon the scale factor used and the 
; vector picked. 
; 
; Depending upon the vector picked, the base delta 
; value will be either -1, <<0, or +1. This will then 
; be multiplied by a scale value, which is obtained 
; by using the scale factor index to index into a 
; multiplier array. The new deltas are saved in the 
; cursor structure. 
find_lightpen: 
                    clr      PICK_FOUND_NOW,u             ; Clear "found this pass" flag (meaning, if nohting changed, we found nothing) 
                    jsr      Intensity_7F                 ; set intensity to max 
                    jsr      Reset0Ref                    ; and reset the integrators to 0 
                    ldd      <<POS,u                      ; load last known position from cursor structure 
                    jsr      Moveto_d_7F                  ; and move there 
                    ldx      #dot_pattern                 ; load dot "structure" 
                    ldb      #$04                         ; scale factor for draw 
                    jsr      draw_with_pick_check         ; Draw a dot; check for pick 
                    tsta                                  ; if a pick occured, than a is 0 (otherwise not) 
                    bne      search_4_lightpen            ; jump if lightpen was not found 
                    inc      PICK_FOUND_NOW,u             ; Lightpen was found - remember that! 
                    lda      #$FF                         ; value to indicate we found something (last time) 
                    sta      PICK_FOUND_LAST,u            ; also remember, for the next time, that last time (now) we found something! 
                    rts                                   ; done 

search_4_lightpen: 
                    tst      PICK_FOUND_LAST,u            ; Don't bother searching if lightpen 
                    bne      continue_lightpen_search     ; wasn't found 
                    rts                                   ; last pass. 

continue_lightpen_search: 
; Draw the spider web, with an increasing scale
; factor, until either the light pen is found, or the last scale 
;factor is reached.
                    jsr      Reset0Ref                    ; reset the integrators 
                    ldx      #small_search_pattern_vl     ; default search pattern is "small" 
                    lda      PICK_FOUND_NOW,u             ; load current scale factor index 
                    cmpa     #$04                         ; half way thru? 
                    blt      use_small_pattern            ; if not halfway done, jump we use the small pattern 
                    ldx      #large_search_pattern_vl     ; nope, second half of possible scanning, we use the large pattern 
use_small_pattern:  ldd      <<POS,u                      ; load current position from cursor 
                    jsr      Moveto_d_7F                  ; move there 
                    ldy      #search_pattern_scale_factors ; load the table of scalefactor 
                    lda      PICK_FOUND_NOW,u             ; get the index we currently use (reuse of PICK_FOUND_NOW in cursor) 
                    ldb      a,y                          ; and load the current scalefactor to b 
                    bne      draw_search_pattern          ; if we have not reached the end of the table (scale == 0) go on drawing the pattern 
                    jsr      Reset0Ref                    ; otherwise exit 
                    clr      PICK_FOUND_NOW,u             ; Flag that cursor is 'lost' 
                    clr      PICK_FOUND_LAST,u            ; to the lightpen. 
                    rts                                   ; out 

; INTERNAL ROUTINE
; scale factor in b
; search vectorlist in X
draw_search_pattern: 
                    ldy      WEB_PATTERN,u                ; get the "pattern" of the search vectorlist 
                    jsr      display_search_pattern       ; display vlist with pattern information and 
                    cmpa     #$FF                         ; Check for a pick. 
                    bne      lightpen_found               ; if pick was found, jump 
                    inc      PICK_FOUND_NOW,u             ; if not iIncrement the scale factor. 
                    bra      search_4_lightpen            ; and try again 

; now we must calculate the delta to the current position
; we can do that because we know:
; a) the current scale, 
; b) the current used delta values of the webbing
; delta values are set to cursor sturcture
;
; entry: A has the index of the vector that was picked ($ff if none was picked - shouldn't come here)
lightpen_found: 
                    ldx      #cursor_deltas               ; load table of cursor deltas 
                    deca                                  ; Decrement the index of the picked 
                    asla                                  ; point, & convert to word index. 
                    ldd      a,x                          ; Load x & y delta values, and save 
                    std      DELTA,u                      ; in the cursor structure. 
                    ldx      #delta_multipliers           ; load table of delta multiplyers 
                    ldb      PICK_FOUND_NOW,u             ; Use the scale factor index to get 
                    lda      b,x                          ; the correct delta multiplier (scale) 
                    pshs     a                            ; use stack as tmp, we resuse the multiplyer in X calculation 
                    ldb      Y_DELTA,u                    ; old delta 
                    jsr      generate_new_cursor_coordinate ; sign correct MUL 
                    stb      Y_DELTA,u                    ; store in structure 
                    puls     a                            ; reload scale value 
                    ldb      X_DELTA,u                    ; Generate new x delta. 
                    jsr      generate_new_cursor_coordinate ; sign correct MUL 
                    stb      X_DELTA,u                    ; store in structure 
                    lda      #$FF                         ; Flag that the cursor is picked 
                    sta      PICK_FOUND_NOW,u             ; 
                    sta      PICK_FOUND_LAST,u            ; 
                    rts                                   ; done 

; INTERNAL ROUTINE
; 
; 
; generate_new_cursor_coordinate() [sign correct!]
; 
; This routine calulates the new cursor delta, 
; by multiplying a delta value (-1, <<0, +1) by 
; a scale multiplier. 
; 
; At entry: 
; 'b' = coordinate delta. (can be negative)
; 'a' = scale multiplier (allways positive)
generate_new_cursor_coordinate: 
                    pshs     b                            ; save b on stack for later use 
                    tstb                                  ; if b negative 
                    bpl      positiveValue1               ; 
                    negb                                  ; make it positive for mul 
positiveValue1:     mul                                   ; multiply, result in b 
                    puls     a                            ; get old "b" back 
                    tsta                                  ; was it negative ? 
                    bpl      positiveValue2               ; 
                    negb                                  ; if so, neg the resulting b 
positiveValue2:     rts                                   ; return 

; INTERNAL ROUTINE
; 
; draw_with_pick_check(vector_list, scale) 
; 
; This procedure will perform a series of move and 
; draw requests, as specified in the passed in vector 
; list. The vector list must have the following format: 
; 
; mode, rel y, rel x 
; | | | 
; | | relative x position 
; | relative y positon 
; FF - draw 
; 0 - move 
; 1 - end o list 
; 
; NOTE: the mode also acts as the line pattern. 
; 
; At entry: 'x' contains pointer to the vector list. 
; 'b' contains the scale factor to be used. 
; 
; At exit: 'a' contains the index of the point being 
; drawn when the lightpen detected a pick. 
; $FF if no pick occurred. 
draw_with_pick_check: 
                    clr      -1,s                         ; Temporary storage of current pt # 
                    lda      #$FF                         ; 
                    sta      -2,s                         ; Temporary storage of last pt picked 
                    stb      <VIA_t1_cnt_lo               ; store scale factor to T1 low 
next_vector_dwpc: 
                    ldd      1,x                          ; load delta y,x values to D 
                    sta      <VIA_port_a                  ; Set rel y position to DAC 
                    clr      <VIA_port_b                  ; mux sel = 0 (integrator Y) mux enabled 
                    lda      <<0,x                        ; Get the mode. (pattern) 
                    leax     3,x                          ; Increment ptr to next entry. 
                    inc      <VIA_port_b                  ; mux disabled 
                    stb      <VIA_port_a                  ; Set rel x position. 
                    sta      <VIA_shift_reg               ; Set line pattern. 
                    clr      <VIA_t1_cnt_hi               ; start T1 timer 
                    ldd      #$0040                       ; load shift reg 0 value and bit test for T1 timer 
T1_loop_dwpc: 
                    bitb     <VIA_int_flags               ; check if T1 interrupt flag was set 
                    beq      T1_loop_dwpc                 ; if not, loop 
                    exg      x,x                          ; delay 
                    sta      <VIA_shift_reg               ; clear shiftreg 
                    lda      <VIA_int_flags               ; Check for a lightpen pick 
                    anda     #$02                         ; bit 2 is ca1 
                    beq      no_pick_dwpc                 ; if not - jump 
                    lda      -1,s                         ; load this vector index 
                    sta      -2,s                         ; Save the "current" vector to previous vector (for next round) 
no_pick_dwpc: 
                    inc      -1,s                         ; Increment the current pt # 
                    lda      <<0,x                        ; check if vector list is finished (anything <= 0 will continue the list, 1 will end list) 
                    ble      next_vector_dwpc             ; jump if not finished 
                    lda      -2,s                         ; Return index if any pt picked. 
                    rts                                   ; done 

; INTERNAL ROUTINE
;
; display_search_pattern() 
; 
; This routine draws the series of vectors, specified in 
; the structure pointed to by they 'x' register. The 'y' 
; 'y' register points to an array of line patterns 
; associated with each vector. The scale factor to be used 
; is specified in 'b'. A pattern of '1' terminates this 
; routine. If a pick is detected, then the index of the 
; vector being drawn is returned in the 'a' register ; 
; if no pick occurred, then $FF is returned. This is used 
; when drawing the spider web search patterns. 
; 
; At entry: 
; 'b' = scale factor 
; 'x' = vector list ptr (rel y, rel x) 
; 'y' = line pattern array ptr 
; 
; At exit: 
; 'a' = $FF => no pick occurred. 
; otherwise, indicates which vector was picked. 
display_search_pattern: 
                    clr      -1,s                         ; Temporary storage of current pt # 
                    lda      #$FF                         ; 
                    sta      -2,s                         ; Temporary storage of last pt picked 
                    stb      <VIA_t1_cnt_lo               ; store scale factor to T1 low 
next_vector_dsp: 
                    ldd      <<0,x                        ; load delta y,x values to D 
                    sta      <VIA_port_a                  ; Set rel y position to DAC 
                    clr      <VIA_port_b                  ; mux sel = 0 (integrator Y) mux enabled 
                    leax     2,x                          ; Increment ptr to next entry. 
                    inc      <VIA_port_b                  ; mux disabled 
                    stb      <VIA_port_a                  ; Set rel x position. 
                    lda      ,y+                          ; load pattern from current pattern table 
                    sta      <VIA_shift_reg               ; and stroe to shiftreg 
                    clr      <VIA_t1_cnt_hi               ; start T1 timer 
                    ldd      #$0040                       ; load shift reg 0 value and bit test for T1 timer 
T1_loop_dsp:        bitb     <VIA_int_flags               ; check if T1 interrupt flag was set 
                    beq      T1_loop_dsp                  ; if not, loop 
                    exg      x,x                          ; delay 
                    sta      <VIA_shift_reg               ; clear shiftreg 
                    lda      <VIA_int_flags               ; Check for a lightpen pick 
                    anda     #$02                         ; bit 2 is ca1 
                    beq      no_pick_dsp                  ; if not - jump 
                    lda      -1,s                         ; load this vector index 
                    sta      -2,s                         ; Save the "current" vector to previous vector (for next round) 
no_pick_dsp: 
                    inc      -1,s                         ; Increment the current pt # 
                    lda      <<0,y                        ; check pattern list, if list is finished 
                    ble      next_vector_dsp              ; jump if not 
                    lda      -2,s                         ; Return index of picked vector. 
                    rts                                   ; 

; vector - "list"
; pattern, y,x
; pattern = 1 -> end
dot_pattern: 
                    DB       $FF                          ; pattern full line 
                    DB       $00, $00                     ; y,x 
                    DB       $01                          ; draw finished 
; The following 5 arrays contain the line patterns 
; used when drawing the spider web search pattern. 
; Depending upon which set of line patterns are used, 
; either the whole pattern, the left side, or right side, 
; or upper portion, or lower portion will be drawn. 
; $ff = full line
; $00 = "move" - no line
whole_search_pattern: 
                    DB       $00                          ; not displayed 
                    DB       $FF                          ; displayed 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $01                          ; list terminator 
lower_search_pattern: 
                    DB       $00 
                    DB       $00 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $00 
                    DB       $00 
                    DB       $01                          ; list terminator 
upper_search_pattern: 
                    DB       $00 
                    DB       $FF 
                    DB       $FF 
                    DB       $00 
                    DB       $00 
                    DB       $00 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $01                          ; list terminator 
right_search_pattern: 
                    DB       $00 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $00 
                    DB       $00 
                    DB       $00 
                    DB       $FF 
                    DB       $01                          ; list terminator 
left_search_pattern: 
                    DB       $00 
                    DB       $00 
                    DB       $00 
                    DB       $00 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $FF 
                    DB       $01                          ; list terminator 
; eight corner vectorlist (small stop sign)
; in format Mov_Draw_VL
; move y,x
; draw y,x
small_search_pattern_vl: 
                    DB       $10, $08 
                    DB       $F8, $08 
                    DB       $F0, $00 
                    DB       $F8, $F8 
                    DB       $00, $F0 
                    DB       $08, $F8 
                    DB       $10, $00 
                    DB       $08, $08 
                    DB       $00, $10 
; eight corner vectorlist (large stop sign)
; in format Mov_Draw_VL
; move y,x
; draw y,x
large_search_pattern_vl: 
                    DB       $40, $20 
                    DB       $E0, $20 
                    DB       $C0, $00 
                    DB       $E0, $E0 
                    DB       $00, $C0 
                    DB       $20, $E0 
                    DB       $40, $00 
                    DB       $20, $20 
                    DB       $00, $40 
; 
; These are (y,x) delta pairs, which are added 
; to the cursor position, to line the cursor up 
; with the lightpen. The pair used depends upon 
; which vector of the search pattern was picked. 
cursor_deltas: 
                    DB       $01 
                    DB       $01 
                    DB       $00 
                    DB       $01 
                    DB       $FF 
                    DB       $01 
                    DB       $FF 
                    DB       $00 
                    DB       $FF 
                    DB       $FF 
                    DB       $00 
                    DB       $FF 
                    DB       $01 
                    DB       $FF 
                    DB       $01 
                    DB       $00 
; 
; This is an array of multiplier values, used when 
; updating the cursors position so that is tracks 
; the lightpen. The scale factor index used to 
; draw the search pattern is also used to index into 
; this byte array. As the scale factor increases, so 
; does the multiplier value. 
delta_multipliers: 
                    DB       $01 
                    DB       $02 
                    DB       $03 
                    DB       $05 
                    DB       $08 
                    DB       $0B 
                    DB       $0E 
                    DB       $12 
                    DB       $16 
                    DB       $1C 
; This array contains the scale factors to be used 
; when drawing the search patterns. 
search_pattern_scale_factors: 
                    DB       $08 
                    DB       $12 
                    DB       $1E 
                    DB       $2C 
                    DB       $0E 
                    DB       $14 
                    DB       $1A 
                    DB       $22 
                    DB       $2C 
                    DB       $38 
                    DB       $00                          ; end of list marker (0) 
