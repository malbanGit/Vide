; expects width strength to be set to the default bios location Vec_Text_Width
; expects height strength to be set to the default bios location Vec_Text_Height
; address of raster data is expected in U
; print is done to current screen location
; 
; uses bios ram-locations  Vec_Counter_1,  Vec_Counter_2,  Vec_Counter_3
; as temporary storages
                    direct $d0 
exit_raster_early: 
                    lda #$98                              ; EXIT routine 
                    sta <VIA_aux_cntl                     ; T1->PB7 enabled 
                    jmp Reset0Ref                         ; Reset the zero reference 

draw_raster_image: 
                    lda ,u+ 
                    sta Vec_Counter_1                     ; height counter 
                    lda ,u+ 
                    sta Vec_Counter_2                     ; width counter 
                    sta Vec_Counter_3                     ; width counter (work) 
; setup VIA raster routine
; step 1
; reset X, Y integrator offset values 
; setup rampin with auxControl 
                    ldd #$1883                            ; a = $18, b = $83 disable RAMP, muxsel=false, channel 1 (integrators offsets) 
                    clr <VIA_port_a                       ; Clear D/A output 
                    sta <VIA_aux_cntl                     ; $18: T1 OneSHotMode WITHOUT Ramp control, Shift out under System clock 
                    stb <VIA_port_b                       ; set mux to channel 1, 
                    dec <VIA_port_b                       ; set "b" setting to orb 
                    ldd #$8081                            ; a = $80, b = $81 prepare next orb configuration 
                    nop                                   ; Wait a moment 
                    inc <VIA_port_b                       ; Disable mux 
; step 2
; VIA_ORA is 0
; integrator y = 0
                    stb <VIA_port_b                       ; disable RAMP, set mux to channel 0 (muxsel = false) 
                    sta <VIA_port_b                       ; enable mux 
                    tst $C800                             ; I think this is a delay only 
                    inc <VIA_port_b                       ; disable mux 
; step 3
; output each line!
nextForwardLine: 
                    lda Vec_Text_Width                    ; get width 
                    sta <VIA_port_a                       ; Send it to the D/A 
                    lda #$01                              ; a = $01 
                    sta <VIA_port_b                       ; Enable RAMP, disable mux 
; output is ongoing! (RAMP is enabled)
                    ldb Vec_Counter_3                     ; [5] 
                    nop                                   ; [2] wait 
                    nop                                   ; [2] wait 
oneShiftOutForward: 
                    lda ,u+                               ; [6] get bitmap (shiftreg-data) from raster table 
                    sta <VIA_shift_reg                    ; [4] This loop needs to have exactly 18 cycles (8*2+2) 
                                                          ; one complete shiftreg output takes 16 cycles (8*2) + 2 cycles since VIA needs some rest 
                    bra dummy1                            ; [3] 

dummy1: 
                    decb                                  ; [2] 
                    bne oneShiftOutForward                ; [3] go back if not done for line 
                    lda #$81                              ; [2] 
                    nop                                   ; [2] delay 2 to finish last shiftout 
                    sta <VIA_port_b                       ; [4] disable RAMP, disable mux 
                    stb <VIA_port_a                       ; dac = 0 
                    dec Vec_Counter_1                     ; check for last row 
                    beq exit_raster_early                 ; branch if last row 
; prepare going backwards next rasterline
                                                          ; 0 ref - avoids woble on large images 
                    lda #$83                              ; ramp still off, mux sel = 1, mux disable 
                    sta <VIA_port_b                       ; put to orb 
                    dec <VIA_port_b                       ; mux enable 
                    lda Vec_Text_Height                   ; get height to a 
                    dec <VIA_port_b                       ; mux disable 
                    dec <VIA_port_b                       ; enable mux 
                    sta <VIA_port_a                       ; put y speed to  dac 
                    neg Vec_Text_Width                    ; for the way back take the "negative" x-direction 
                    inc <VIA_port_b                       ; disable mux 
                    clr <VIA_port_a                       ; x should not be integrating! 
                    lda #$01                              ; a= enable ramp, disable mux 
                    sta <VIA_port_b                       ; set it to orb 
; now we are going down a little bit
                    nop                                   ; ? 
                    nop                                   ; ? 
                    lda #$81                              ; disable ramp, disable mux (muxsel = Y) 
                    sta <VIA_port_b                       ; set it to orb 
                    clr <VIA_port_a                       ; clear D/A, (Y integration = 0) 
                    dec <VIA_port_b                       ; enable mux 
                    lda Vec_Counter_2                     ; width of one line 
                    sta Vec_Counter_3                     ; reset output counter 
                    inc <VIA_port_b                       ; disable mux 

;                     bra dummy3 ; if bra is done, cycles for forward and backword are exactly the same

dummy3 
                    lda Vec_Text_Width                    ; get x speed (going back) 
                    sta <VIA_port_a                       ; send it to the D/A 
                    lda #$01                              ; a = $01 
                    sta <VIA_port_b                       ; enable RAMP, disable mux 
; output is ongoing! (RAMP is enabled)
                    ldb Vec_Counter_3                     ; [5] 
                    nop                                   ; [2] 
                    nop                                   ; [2] 
oneShiftOutBackward: 
                    lda ,u+                               ; [6] get bitmap from raster table 
                    sta <VIA_shift_reg                    ; [4] this loop needs to have exactly 18 cycles (8*2+2) 
                    bra dummy2                            ; [3] 

dummy2: 
                    decb                                  ; [2] 
                    bne oneShiftOutBackward               ; [3] go back if not finished 
                    lda #$81                              ; [2] 
                    nop                                   ; [2] delay 2 to finish last shiftout 
                    sta <VIA_port_b                       ; [4] disable RAMP, disable mux 
                    stb <VIA_port_a                       ; dac = 0 
                    dec Vec_Counter_1                     ; check for last row 
                    beq exit_raster_late                  ; branch if last row 
; prepare going forward next rasterline
                                                          ; 0 ref - avoids woble on large images 
                    lda #$83                              ; ramp still off, mux sel = 1, mux disable 
                    sta <VIA_port_b                       ; put to orb 
                    dec <VIA_port_b                       ; mux enable 
                    lda Vec_Text_Height                   ; get height to a 
                    dec <VIA_port_b                       ; mux disable 
                    dec <VIA_port_b                       ; enable mux 
                    sta <VIA_port_a                       ; put it to dac 
                    neg Vec_Text_Width                    ; for the way back take the "negative" x-direction 
                    inc <VIA_port_b                       ; disable mux 
                    clr <VIA_port_a                       ; x should not be integrating! 
                    lda #$01                              ; a= enable ramp, disable mux 
                    sta <VIA_port_b                       ; set it to orb 
; now we are going down a little bit
                    nop                                   ; ? 
                    nop                                   ; ? 
                    lda #$81                              ; disable ramp, disable mux (muxsel = Y) 
                    sta <VIA_port_b                       ; set it to orb 
                    clr <VIA_port_a                       ; clear D/A, (Y integration = 0) 
                    dec <VIA_port_b                       ; enable mux 
                    lda Vec_Counter_2                     ; width of one line 
                    sta Vec_Counter_3                     ; reset output counter 
                    inc <VIA_port_b                       ; disable mux 
                    bra nextForwardLine                   ; go back for next scan line 

exit_raster_late: 
                    lda #$98                              ; EXIT routine 
                    sta <VIA_aux_cntl                     ; T1->PB7 enabled 
                    jmp Reset0Ref                         ; Reset the zero reference 
