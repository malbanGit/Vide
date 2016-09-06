;; this hand optmized raster routine for this image is about 14000 cycles faster than the "normal" templated one!

; expects width strength to be set to the default bios location Vec_Text_Width
; expects height strength to be set to the default bios location Vec_Text_Height
; address of raster data is expected in U
; print is done to current screen location
; 
; uses bios ram-locations  Vec_Counter_1,  Vec_Counter_2,  Vec_Counter_3
; as temporary storages
; zero delay is needed for zeroing to work correctly
; depends on the distance of the current integrator position to actual zero point
; experiment with my vectri:
;ZERO ing the integrators takes time. Measures at my vectrex show e.g.:
;If you move the beam with a to x = -127 and y = -127 at diffferent scale values, the time to reach zero:
;- scale $ff -> zero 110 cycles
;- scale $7f -> zero 75 cycles
;- scale $40 -> zero 57 cycles
;- scale $20 -> zero 53 cycles
ZERO_DELAY          EQU      1                            ; delay 7 counter is exactly 111 cycles delay between zero SETTING and zero unsetting (in moveto_d) 
                    direct   $d0 
draw_raster_image: 
; put move position on stack put it so, that we can load "d" directly from stack
                    pshs     b 
                    pshs     a 
                    lda      ,u+                          ; load line counter 
                    sta      Vec_Counter_1                ; height counter 
                    lda      ,u+                          ; load line width 
                    sta      Vec_Counter_2                ; width counter 
                    sta      Vec_Counter_3                ; width counter (work) 
; setup VIA raster routine
; setup rampin with auxControl 
next_line: 
                    lda      Vec_Counter_2                ; reload line width 
                    sta      Vec_Counter_3 
; zero
                    ldb      #$CC                         ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
                    ldb      #ZERO_DELAY                  ; and wait for zeroing to be actually done 
; reset integrators
                    clr      <VIA_port_a                  ; reset integrator offset 
                    lda      #%10000010 
; wait that zeroing surely has the desired effect!
zeroLoop: 
                    sta      <VIA_port_b                  ; while waiting, zero offsets 
                    decb     
                    bne      zeroLoop 
                    inc      <VIA_port_b 
; unzero is done by moveto_d
                    lda      #SCALE_MOVE 
                    sta      <VIA_t1_cnt_lo 
                    ldd      0,s 
;                    jsr      Moveto_d 
;;;;;; move to d as direct code start
                    STA      VIA_port_a                   ;Store Y in D/A register 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      VIA_cntl                     ; 
                    CLRA     
                    STA      VIA_port_b                   ;Enable mux 
                    STA      VIA_shift_reg                ;Clear shift regigster 
                    INC      VIA_port_b                   ;Disable mux 
                    STB      VIA_port_a                   ;Store X in D/A register 
                    STA      VIA_t1_cnt_hi                ;enable timer 
                    lda      #-4                          ; optimized correct adder for next scan line 
                    adda     0,s                          ; done befor wait loop of move to d 
                    sta      0,s 
                    lda      #SCALE_DRAW                  ; preload next scale 
                    LDB      #$40                         ; 
m2d:                BITB     VIA_int_flags                ; 
                    BEQ      m2d                          ; 
;;;;;; move to d as direct code end
                    sta      <VIA_t1_cnt_lo 
; ensure y int does nothing
                    lda      #%10000001                   ; mux disabled, mux sel = y int 
                    sta      <VIA_port_b                  ; to via b 
                    clr      <VIA_port_a                  ; ensure dac is 0 
                    dec      <VIA_port_b                  ; enable mux 
                    nop                                   ; delay 
                    inc      <VIA_port_b                  ;disable mux 
                    lda      #$18                         ; a = $18, 
                    sta      <VIA_aux_cntl                ; $18: T1 OneSHotMode WITHOUT Ramp control, Shift out under System clock 
                    lda      Vec_Text_Width               ; get width 
                    sta      <VIA_port_a                  ; Send it to the D/A 
                    lda      #$01                         ; a = $01 
                    sta      <VIA_port_b                  ; Enable RAMP, disable mux 
; output is ongoing! (RAMP is enabled)
                    ldb      Vec_Counter_3                ; [5] 
                    nop                                   ; [2] wait 
                    nop                                   ; [2] wait 
oneShiftOutForward: 
                    lda      ,u+                          ; [6] get bitmap (shiftreg-data) from raster table 
                    sta      <VIA_shift_reg               ; [4] This loop needs to have exactly 18 cycles (8*2+2) 
                                                          ; one complete shiftreg output takes 16 cycles (8*2) + 2 cycles since VIA needs some rest 
                    bra      dummy1                       ; [3] 

dummy1: 
                    decb                                  ; [2] 
                    bne      oneShiftOutForward           ; [3] go back if not done for line 
                    nop                                   ; [2] delay 2 to finish last shiftout 
                    stb      <VIA_shift_reg               ; [4] b is 0 now, switch of shift 
; don't bother about ramp and dac, in the next round all will be resetted
                    lda      #$98                         ; EXIT routine 
                    sta      <VIA_aux_cntl                ; T1->PB7 enabled 
                    dec      Vec_Counter_1                ; check for last row 
                    bne      next_line                    ; branch if not last row 
                    puls     d                            ; all done, correct stack 
                    rts      


C1_data:
 db $3C-10, $04
 db %00000000, %00000000, %10100000, %00000000; forward
 db %00000000, %00000001, %11111000, %00000000; forward
 db %00000010, %00100111, %11111100, %00000000; forward
 db %00000111, %11101111, %11111111, %00000000; forward
 db %00001111, %11111111, %11111111, %00000000; forward
 db %00001111, %11111111, %11111111, %10000000; forward
 db %00001111, %11111111, %11111111, %11000000; forward
 db %00011111, %11111111, %11111111, %11100000; forward
 db %00011111, %11111111, %11111111, %11100000; forward
 db %00111111, %11111111, %11111111, %11100000; forward
 db %00111111, %11111111, %11111111, %11100000; forward
 db %00111111, %11111111, %11111111, %11100000; forward
 db %00111111, %11111111, %11111111, %11110000; forward
 db %00011111, %11111111, %11111111, %11110000; forward
 db %00011111, %11111111, %11111111, %11110000; forward
 db %00011111, %11111111, %11111111, %11110000; forward
 db %00001111, %11111111, %11111111, %11110000; forward
 db %00011111, %11111111, %11110000, %11110000; forward
 db %00011111, %11111111, %11000000, %00010001; forward
 db %00000000, %11111111, %00000111, %10110001; forward
 db %00000000, %01111111, %00000001, %11110011; forward
 db %00110000, %00111110, %00000000, %11110011; forward
 db %00000000, %00011100, %00100101, %11110011; forward
 db %01101000, %10001101, %11011111, %11110011; forward
 db %01110011, %11101101, %11111111, %11110011; forward
 db %11111111, %11101111, %11111111, %11110011; forward
 db %11111111, %11101111, %11111111, %11110011; forward
 db %11111111, %11101101, %11111111, %11110011; forward
 db %11111111, %11101100, %11111111, %11110111; forward
 db %01111111, %11001110, %01111111, %11110110; forward
 db %01111111, %11001110, %00111111, %11110110; forward
 db %01111111, %10001111, %10111111, %11110100; forward
 db %00111111, %10111110, %11111111, %11110000; forward
 db %00111111, %11001100, %01111111, %11110000; forward
 db %00011111, %11100001, %11111111, %11110000; forward
 db %00011111, %11111111, %11111111, %11110000; forward
 db %00011111, %00011111, %00010111, %11100000; forward
 db %00001110, %01111111, %11111111, %11100000; forward
 db %00001111, %11111111, %11000111, %11100000; forward
 db %00001111, %00000000, %00001111, %11000000; forward
 db %00001111, %10000001, %11111111, %11000000; forward
 db %00001111, %11111111, %11111111, %10000000; forward
 db %00000111, %11100000, %00111111, %00000000; forward
 db %00000011, %11110000, %01111110, %00000000; forward
 db %00000000, %11111111, %11111100, %00000000; forward
 db %00000000, %11111111, %11111000, %00000000; forward
 db %00000000, %01111111, %11110000, %00000000; forward
 db %00000000, %00111111, %11110000, %00000000; forward
 db %00000000, %00001111, %10000000, %00000000; forward
 db %00000000, %00001111, %00000000, %00000000; forward
