;SUB_START

;ZERO ing the integrators takes time. Measures at my vectrex show e.g.:
;If you move the beam with a to x = -127 and y = -127 at diffferent scale values, the time to reach zero:
;- scale $ff -> zero 110 cycles
;- scale $7f -> zero 75 cycles
;- scale $40 -> zero 57 cycles
;- scale $20 -> zero 53 cycles
ZERO_DELAY_S          EQU      7                            ; delay 7 counter is exactly 111 cycles delay between zero SETTING and zero unsetting (in moveto_d) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;U = address of vectorlist
;X = (y,x) position of vectorlist (this will be point 0,0), positioning on screen
;A = scalefactor "Move" (after sync)
;B = scalefactor "Vector" (vectors in vectorlist)
;
;     mode, rel y, rel x,                                             
;     mode, rel y, rel x,                                             
;     .      .      .                                                
;     .      .      .                                                
;     mode, rel y, rel x,                                             
;     0x02
; where mode has the following meaning:         
; negative draw line                    
; 0 move to specified endpoint                              
; 1 sync (and move to list start and than to place in vectorlist)      
; 2 end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
draw_synced_list: 
                    pshs     a                            ; remember out different scale factors 
                    pshs     b 
                                                          ; first list entry (first will be a sync + moveto_d, so we just stay here!) 
                    lda      ,u+                          ; this will be a "1" 
sync_s: 
                    deca                                  ; test if real sync - or end of list (2) 
                    bne      drawdone_s                     ; if end of list -> jump 
; zero integrators
                    ldb      #$CC                         ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
                    ldb      #ZERO_DELAY_S                  ; and wait for zeroing to be actually done 
; reset integrators
                    clr      <VIA_port_a                  ; reset integrator offset 
                    lda      #%10000010 
; wait that zeroing surely has the desired effect!
zeroLoop_s: 
                    sta      <VIA_port_b                  ; while waiting, zero offsets 
                    decb     
                    bne      zeroLoop_s 
                    inc      <VIA_port_b 
; unzero is done by moveto_d
                    lda      1,s                          ; scalefactor move 
                    sta      <VIA_t1_cnt_lo               ; to timer t1 (lo= 
                    tfr      x,d                          ; load our coordinates of "entry" of vectorlist 
                    jsr      Moveto_d                     ; move there 
                    lda      ,s                           ; scale factor vector 
                    sta      <VIA_t1_cnt_lo               ; to timer T1 (lo) 
moveTo_s: 
                    ldd      ,u++                         ; do our "internal" moveto d 
                    beq      nextListEntry_s                ; there was a move 0,0, if so 
                    jsr      Moveto_d 
nextListEntry_s: 
                    lda      ,u+                          ; load next "mode" byte 
                    beq      moveTo_s                       ; if 0, than we should move somewhere 
                    bpl      sync_s                         ; if still positive it is a 1 pr 2 _> goto sync 
; now we should draw a vector 
                    ldd      ,u++                         ;Get next coordinate pair 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                    LDA      #$ff                         ;Get pattern byte 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    LDB      #$40                         ;B-reg = T1 interrupt bit 
                    CLR      <VIA_t1_cnt_hi               ;Clear T1H 
                    STA      <VIA_shift_reg               ;Store pattern in shift register 
setPatternLoop_s: 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    beq      setPatternLoop_s               ; wait till line is finished 
                    CLR      <VIA_shift_reg               ; switch the light off (for sure) 
                    bra      nextListEntry_s 

drawdone_s: 
                    puls     d                            ; correct stack and go back 
                    rts      
;SUB_END