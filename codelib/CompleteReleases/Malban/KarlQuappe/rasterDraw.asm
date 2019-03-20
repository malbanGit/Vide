; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
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
SCALE_MOVE          equ      100 
draw_raster_image: 
; put move position on stack put it so, that we can load "d" directly from stack
                    pshs     d 
                    ldd      ,u++                         ; load line counter 
                    std      Vec_Counter_1                ; height counter +width counter + 
                    stb      Vec_Counter_3                ; width counter (work) 
; setup VIA raster routine
; setup rampin with auxControl 
next_line: 
; zero
                    ldd      #(%10000010)*256+$CC         ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
         ;           ldb      #ZERO_DELAY                  ; and wait for zeroing to be actually done 
; reset integrators
                    clr      <VIA_port_a                  ; reset integrator offset 
; wait that zeroing surely has the desired effect!
zeroLoop: 
                    sta      <VIA_port_b                  ; while waiting, zero offsets 
         ;           decb     
         ;           bne      zeroLoop 
                    inc      <VIA_port_b 
; unzero is done by moveto_d
                    lda      #SCALE_MOVE 
                    sta      <VIA_t1_cnt_lo 
                    ldd      0,s 
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
                    lda      Vec_Counter_2                ; reload line width 
                    sta      Vec_Counter_3 
                    lda      #-2                          ; optimized correct adder for next scan line 
                    adda     0,s                          ; done befor wait loop of move to d 
                    sta      0,s 
                    LDD      #(%10000001)*256+$40         ; mux disabled, mux sel = y int 
m2d:                BITB     VIA_int_flags                ; 
                    BEQ      m2d                          ; 
;;;;;; move to d as direct code end
; ensure y int does nothing
                    sta      <VIA_port_b                  ; to via b 
                    clr      <VIA_port_a                  ; ensure dac is 0 
                    dec      <VIA_port_b                  ; enable mux 
                                                          ; nop ; delay 
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
                    puls     d,pc                            ; all done, correct stack 
                 ;   rts      
