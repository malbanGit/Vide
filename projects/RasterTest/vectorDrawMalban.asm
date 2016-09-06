;ZERO ing the integrators takes time. Measures at my vectrex show e.g.:
;If you move the beam with a to x = -127 and y = -127 at diffferent scale values, the time to reach zero:
;- scale $ff -> zero 110 cycles
;- scale $7f -> zero 75 cycles
;- scale $40 -> zero 57 cycles
;- scale $20 -> zero 53 cycles
ZERO_DELAY          EQU      7                           ; delay 7 counter is exactly 111 cycles delay between zero SETTING and zero unsetting (in moveto_d) 
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
sync_sl: 
                    deca                                  ; test if real sync - or end of list (2) 
                    bne      drawdone_sl                  ; if end of list -> jump 
; zero integrators
                    ldb      #$CC                         ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
                    ldb      #ZERO_DELAY                  ; and wait for zeroing to be actually done 
; reset integrators
                    clr      <VIA_port_a                  ; reset integrator offset 
                    lda      #%10000010 
; wait that zeroing surely has the desired effect!
zeroLoop_sl: 
                    sta      <VIA_port_b                  ; while waiting, zero offsets 
                    decb     
;                    bne      zeroLoop_sl 
                    inc      <VIA_port_b 
; unzero is done by moveto_d
                    lda      1,s                          ; scalefactor move 
                    sta      <VIA_t1_cnt_lo               ; to timer t1 (lo= 
                    tfr      x,d                          ; load our coordinates of "entry" of vectorlist 
        ;            jsr      Moveto_d                     ; move there 

                    nop      5                            ; we must delay some more because of zeroing 
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
                    LDB      #$40                         ; 
                    lda      ,s                           ; scale factor vector 
m2d_1: 
                    BITB     VIA_int_flags                ; 
                    BEQ      m2d_1                        ; 
;;;;;; move to d as direct code end


                    sta      <VIA_t1_cnt_lo               ; to timer T1 (lo) 
moveTo_sl: 
                    ldd      ,u++                         ; do our "internal" moveto d 
                    beq      nextListEntry_sl             ; there was a move 0,0, if so 
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
                    LDB      #$40                         ; 
m2d_2:              BITB     VIA_int_flags                ; 
                    BEQ      m2d_2                        ; 
;;;;;; move to d as direct code end
nextListEntry_sl: 
                    lda      ,u+                          ; load next "mode" byte 
                    beq      moveTo_sl                    ; if 0, than we should move somewhere 
                    bpl      sync_sl                      ; if still positive it is a 1 pr 2 _> goto sync 
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
setPatternLoop_sl: 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    beq      setPatternLoop_sl            ; wait till line is finished 
                    CLR      <VIA_shift_reg               ; switch the light off (for sure) 
                    bra      nextListEntry_sl 

drawdone_sl: 
                    puls     d                            ; correct stack and go back 
                    rts      

vData = VectorList
VectorList:
 DB $01, +$64, -$05 ; sync and move to y, x
 DB $FF, -$60, +$00 ; draw, y, x
 DB $FF, -$5F, -$01 ; draw, y, x
 DB $FF, -$02, -$09 ; draw, y, x
 DB $FF, +$5F, +$00 ; draw, y, x
 DB $FF, +$60, -$01 ; draw, y, x
 DB $FF, +$02, +$0B ; draw, y, x
 DB $01, +$5C, -$47 ; sync and move to y, x
 DB $FF, -$5A, +$07 ; draw, y, x
 DB $FF, -$59, +$06 ; draw, y, x
 DB $FF, -$0C, -$04 ; draw, y, x
 DB $FF, +$00, -$05 ; draw, y, x
 DB $FF, +$0C, -$04 ; draw, y, x
 DB $FF, +$44, -$04 ; draw, y, x
 DB $FF, -$4A, -$0D ; draw, y, x
 DB $FF, +$00, -$07 ; draw, y, x
 DB $FF, +$3D, -$07 ; draw, y, x
 DB $FF, -$3B, -$08 ; draw, y, x
 DB $FF, -$05, -$08 ; draw, y, x
 DB $FF, +$08, -$02 ; draw, y, x
 DB $FF, +$59, +$07 ; draw, y, x
 DB $FF, +$5A, +$07 ; draw, y, x
 DB $FF, +$00, +$06 ; draw, y, x
 DB $FF, -$5D, +$0A ; draw, y, x
 DB $FF, +$63, +$0C ; draw, y, x
 DB $FF, -$05, +$07 ; draw, y, x
 DB $01, +$58, +$0F ; sync and move to y, x
 DB $FF, -$30, -$01 ; draw, y, x
 DB $FF, +$02, +$0E ; draw, y, x
 DB $FF, -$0A, +$06 ; draw, y, x
 DB $FF, -$22, +$07 ; draw, y, x
 DB $FF, +$21, +$0B ; draw, y, x
 DB $FF, +$0A, +$07 ; draw, y, x
 DB $FF, +$00, +$0B ; draw, y, x
 DB $FF, -$09, +$06 ; draw, y, x
 DB $FF, -$0F, +$04 ; draw, y, x
 DB $FF, -$44, +$03 ; draw, y, x
 DB $FF, +$5C, +$02 ; draw, y, x
 DB $FF, -$07, +$0A ; draw, y, x
 DB $FF, +$07, +$08 ; draw, y, x
 DB $FF, +$00, +$07 ; draw, y, x
 DB $FF, -$76, +$0A ; draw, y, x
 DB $FF, -$0C, -$04 ; draw, y, x
 DB $01, -$59, +$74 ; sync and move to y, x
 DB $FF, +$00, -$06 ; draw, y, x
 DB $FF, +$5E, -$07 ; draw, y, x
 DB $FF, -$5E, -$0B ; draw, y, x
 DB $FF, +$00, -$06 ; draw, y, x
 DB $FF, +$0A, -$03 ; draw, y, x
 DB $FF, -$0B, -$04 ; draw, y, x
 DB $FF, +$04, -$07 ; draw, y, x
 DB $FF, +$00, -$05 ; draw, y, x
 DB $FF, -$04, -$0D ; draw, y, x
 DB $FF, +$0F, -$07 ; draw, y, x
 DB $FF, +$17, -$04 ; draw, y, x
 DB $FF, -$25, -$10 ; draw, y, x
 DB $FF, +$00, -$15 ; draw, y, x
 DB $FF, +$0B, -$04 ; draw, y, x
 DB $FF, +$56, +$01 ; draw, y, x
 DB $FF, +$57, +$02 ; draw, y, x
 DB $FF, -$07, +$0A ; draw, y, x
 DB $01, +$29, -$1F ; sync and move to y, x
 DB $FF, -$17, +$09 ; draw, y, x
 DB $FF, -$5F, +$04 ; draw, y, x
 DB $FF, -$0D, -$04 ; draw, y, x
 DB $FF, +$04, -$07 ; draw, y, x
 DB $FF, -$04, -$10 ; draw, y, x
 DB $FF, +$08, -$06 ; draw, y, x
 DB $FF, +$55, -$05 ; draw, y, x
 DB $FF, +$1C, +$08 ; draw, y, x
 DB $FF, +$0A, +$06 ; draw, y, x
 DB $FF, +$00, +$0B ; draw, y, x
 DB $01, +$03, +$1A ; sync and move to y, x
 DB $FF, +$04, -$05 ; draw, y, x
 DB $FF, -$34, -$07 ; draw, y, x
 DB $FF, -$09, +$03 ; draw, y, x
 DB $FF, +$00, +$08 ; draw, y, x
 DB $FF, +$12, +$05 ; draw, y, x
 DB $FF, +$27, -$04 ; draw, y, x
 DB $01, -$33, +$38 ; sync and move to y, x
 DB $FF, +$02, +$0B ; draw, y, x
 DB $FF, +$33, -$01 ; draw, y, x
 DB $FF, -$0F, -$0B ; draw, y, x
 DB $FF, -$26, +$01 ; draw, y, x
 DB $01, +$02, -$23 ; sync and move to y, x
 DB $FF, -$0F, -$0A ; draw, y, x
 DB $FF, -$26, +$01 ; draw, y, x
 DB $FF, -$04, +$05 ; draw, y, x
 DB $FF, +$06, +$05 ; draw, y, x
 DB $FF, +$33, -$01 ; draw, y, x
 DB $02 ; endmarker 
