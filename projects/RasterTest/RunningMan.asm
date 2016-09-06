

;***************************************************************************
; SUBROUTINE SECTION
;***************************************************************************

;ZERO ing the integrators takes time. Measures at my vectrex show e.g.:
;If you move the beam with a to x = -127 and y = -127 at diffferent scale values, the time to reach zero:
;- scale $ff -> zero 110 cycles
;- scale $7f -> zero 75 cycles
;- scale $40 -> zero 57 cycles
;- scale $20 -> zero 53 cycles
ZERO_DELAY_1          EQU      1                            ; delay 7 counter is exactly 111 cycles delay between zero SETTING and zero unsetting (in moveto_d) 
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
draw_synced_list_rm: 
                    pshs     a                            ; remember out different scale factors 
                    pshs     b 
                                                          ; first list entry (first will be a sync + moveto_d, so we just stay here!) 
                    lda      ,u+                          ; this will be a "1" 
sync_rm: 
                    deca                                  ; test if real sync - or end of list (2) 
                    bne      drawdone_rm                     ; if end of list -> jump 
; zero integrators
                    ldb      #$CC                         ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
                    ldb      #ZERO_DELAY_1                  ; and wait for zeroing to be actually done 
; reset integrators
                    clr      <VIA_port_a                  ; reset integrator offset 
                    lda      #%10000010 
; wait that zeroing surely has the desired effect!
zeroLoop_rm: 
                    sta      <VIA_port_b                  ; while waiting, zero offsets 
                    decb     
                    bne      zeroLoop_rm 
                    inc      <VIA_port_b 
; unzero is done by moveto_d
                    lda      1,s                          ; scalefactor move 
                    sta      <VIA_t1_cnt_lo               ; to timer t1 (lo= 
                    tfr      x,d                          ; load our coordinates of "entry" of vectorlist 
                    jsr      Moveto_d                     ; move there 
                    lda      ,s                           ; scale factor vector 
                    sta      <VIA_t1_cnt_lo               ; to timer T1 (lo) 
moveTo_rm: 
                    ldd      ,u++                         ; do our "internal" moveto d 
                    beq      nextListEntry_rm                ; there was a move 0,0, if so 
                    jsr      Moveto_d 
nextListEntry_rm: 
                    lda      ,u+                          ; load next "mode" byte 
                    beq      moveTo_rm                       ; if 0, than we should move somewhere 
                    bpl      sync_rm                         ; if still positive it is a 1 pr 2 _> goto sync 
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
setPatternLoop_rm: 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    beq      setPatternLoop_rm               ; wait till line is finished 
                    CLR      <VIA_shift_reg               ; switch the light off (for sure) 
                    bra      nextListEntry_rm 

drawdone_rm: 
                    puls     d                            ; correct stack and go back 
                    rts      
;***************************************************************************
; DATA SECTION
;******************


rmData = AnimList_rm
rmDataLength = 14
AnimList_rm:
 DW AnimList_rm_0 ; list of all single vectorlists in this
 DW AnimList_rm_1
 DW AnimList_rm_2
 DW AnimList_rm_3
 DW AnimList_rm_4
 DW AnimList_rm_5
 DW AnimList_rm_6
 DW AnimList_rm_7
 DW AnimList_rm_8
 DW AnimList_rm_9
 DW AnimList_rm_10
 DW AnimList_rm_11
 DW AnimList_rm_12
 DW AnimList_rm_13

AnimList_rm_0:
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$3F, +$00 ; move to y, x
 DB $FF, -$33, +$00 ; draw, y, x
 DB $FF, -$0C, -$0C ; draw, y, x
 DB $FF, -$1A, -$0C ; draw, y, x
 DB $01, +$65, -$0C ; sync and move to y, x
 DB $FF, -$26, -$0D ; draw, y, x
 DB $FF, -$0D, +$00 ; draw, y, x
 DB $FF, -$3E, +$0D ; draw, y, x
 DB $01, -$0C, -$0C ; sync and move to y, x
 DB $FF, -$36, -$0D ; draw, y, x
 DB $FF, -$0A, -$33 ; draw, y, x
 DB $FF, -$33, +$00 ; draw, y, x
 DB $01, -$7F, -$4C ; sync and move to y, x
 DB $FF, +$1A, +$0D ; draw, y, x
 DB $FF, +$00, +$33 ; draw, y, x
 DB $FF, +$00, -$33 ; draw, y, x
 DB $01, -$80, +$19 ; sync and move to y, x
 DB $00, -$3E, +$00 ; move to y, x
 DB $FF, +$72, -$19 ; draw, y, x
 DB $FF, -$19, -$0C ; draw, y, x
 DB $01, -$4C, +$00 ; sync and move to y, x
 DB $FF, -$72, +$19 ; draw, y, x
 DB $FF, +$00, +$26 ; draw, y, x
 DB $FF, +$0D, +$00 ; draw, y, x
 DB $FF, +$0A, -$19 ; draw, y, x
 DB $01, -$80, +$26 ; sync and move to y, x
 DB $00, -$27, +$00 ; move to y, x
 DB $FF, +$4F, +$00 ; draw, y, x
 DB $FF, +$32, -$0D ; draw, y, x
 DB $FF, +$3F, +$00 ; draw, y, x
 DB $FF, +$00, +$0D ; draw, y, x
 DB $01, +$19, +$26 ; sync and move to y, x
 DB $FF, -$0D, +$0C ; draw, y, x
 DB $FF, +$1A, -$0C ; draw, y, x
 DB $FF, +$0C, +$00 ; draw, y, x
 DB $FF, +$33, -$0D ; draw, y, x
 DB $01, +$65, +$19 ; sync and move to y, x
 DB $FF, +$26, +$00 ; draw, y, x
 DB $FF, +$00, +$0D ; draw, y, x
 DB $01, +$7F, +$26 ; sync and move to y, x
 DB $00, +$0C, +$00 ; move to y, x
 DB $FF, +$33, +$00 ; draw, y, x
 DB $FF, +$00, -$1A ; draw, y, x
 DB $FF, -$33, +$00 ; draw, y, x
 DB $02 ; endmarker 
AnimList_rm_1:
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$3F, +$00 ; move to y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $FF, -$19, -$18 ; draw, y, x
 DB $FF, -$1A, -$0D ; draw, y, x
 DB $01, +$65, -$19 ; sync and move to y, x
 DB $FF, -$7E, +$00 ; draw, y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $FF, -$33, -$19 ; draw, y, x
 DB $FF, -$33, -$0D ; draw, y, x
 DB $01, -$80, -$3F ; sync and move to y, x
 DB $00, -$25, +$00 ; move to y, x
 DB $FF, -$0C, +$0D ; draw, y, x
 DB $FF, -$0D, +$19 ; draw, y, x
 DB $FF, +$0D, +$00 ; draw, y, x
 DB $01, -$80, -$19 ; sync and move to y, x
 DB $00, -$31, +$00 ; move to y, x
 DB $FF, +$0C, -$0D ; draw, y, x
 DB $FF, +$33, +$0D ; draw, y, x
 DB $FF, +$0D, +$25 ; draw, y, x
 DB $FF, +$0D, +$1A ; draw, y, x
 DB $01, -$58, +$26 ; sync and move to y, x
 DB $FF, +$0C, +$0C ; draw, y, x
 DB $FF, +$0D, +$00 ; draw, y, x
 DB $FF, +$26, -$0C ; draw, y, x
 DB $01, -$19, +$26 ; sync and move to y, x
 DB $FF, +$25, -$0D ; draw, y, x
 DB $FF, +$1A, +$00 ; draw, y, x
 DB $FF, +$19, +$19 ; draw, y, x
 DB $FF, +$19, +$0D ; draw, y, x
 DB $01, +$58, +$3F ; sync and move to y, x
 DB $FF, +$00, -$0D ; draw, y, x
 DB $FF, -$0C, -$0C ; draw, y, x
 DB $FF, +$00, -$0D ; draw, y, x
 DB $01, +$4C, +$19 ; sync and move to y, x
 DB $FF, +$3F, +$00 ; draw, y, x
 DB $FF, +$00, +$0D ; draw, y, x
 DB $FF, +$33, +$00 ; draw, y, x
 DB $FF, +$00, -$1A ; draw, y, x
 DB $01, -$3A, -$0A ; sync and move to y, x
 DB $FF, +$0D, +$0C ; draw, y, x
 DB $FF, -$05, +$17 ; draw, y, x
 DB $FF, -$14, -$17 ; draw, y, x
 DB $01, -$46, +$02 ; sync and move to y, x
 DB $FF, -$0D, +$00 ; draw, y, x
 DB $FF, +$00, -$0C ; draw, y, x
 DB $FF, +$19, +$00 ; draw, y, x
 DB $02 ; endmarker 
AnimList_rm_2:
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$32, +$00 ; move to y, x
 DB $FF, -$32, +$00 ; draw, y, x
 DB $FF, -$1A, -$0C ; draw, y, x
 DB $01, +$65, +$00 ; sync and move to y, x
 DB $FF, -$19, -$19 ; draw, y, x
 DB $FF, -$40, +$00 ; draw, y, x
 DB $FF, +$00, +$0D ; draw, y, x
 DB $01, +$0C, -$0C ; sync and move to y, x
 DB $FF, -$25, -$0D ; draw, y, x
 DB $FF, -$26, -$0D ; draw, y, x
 DB $01, -$3F, -$26 ; sync and move to y, x
 DB $FF, -$33, -$19 ; draw, y, x
 DB $FF, -$33, -$0D ; draw, y, x
 DB $FF, -$0C, +$00 ; draw, y, x
 DB $01, -$80, -$4C ; sync and move to y, x
 DB $00, -$31, +$00 ; move to y, x
 DB $FF, -$0D, +$1A ; draw, y, x
 DB $FF, +$00, +$0C ; draw, y, x
 DB $01, -$80, -$26 ; sync and move to y, x
 DB $00, -$3E, +$00 ; move to y, x
 DB $FF, +$0D, -$0C ; draw, y, x
 DB $FF, +$0C, -$0D ; draw, y, x
 DB $FF, +$26, +$19 ; draw, y, x
 DB $01, -$7F, -$26 ; sync and move to y, x
 DB $FF, +$33, +$1A ; draw, y, x
 DB $FF, +$1A, +$0A ; draw, y, x
 DB $01, -$32, -$02 ; sync and move to y, x
 DB $FF, +$00, +$0E ; draw, y, x
 DB $FF, -$0D, +$0D ; draw, y, x
 DB $FF, -$0D, +$0D ; draw, y, x
 DB $01, -$4C, +$26 ; sync and move to y, x
 DB $FF, -$26, -$0D ; draw, y, x
 DB $FF, -$26, -$19 ; draw, y, x
 DB $01, -$80, +$00 ; sync and move to y, x
 DB $00, -$18, +$00 ; move to y, x
 DB $FF, -$0D, +$0C ; draw, y, x
 DB $FF, -$0C, +$1A ; draw, y, x
 DB $FF, +$0C, +$00 ; draw, y, x
 DB $01, -$80, +$26 ; sync and move to y, x
 DB $00, -$25, +$00 ; move to y, x
 DB $FF, +$0D, -$0D ; draw, y, x
 DB $FF, +$26, +$19 ; draw, y, x
 DB $01, -$72, +$32 ; sync and move to y, x
 DB $FF, +$1A, +$1A ; draw, y, x
 DB $FF, +$0C, +$00 ; draw, y, x
 DB $FF, +$4C, -$33 ; draw, y, x
 DB $01, +$00, +$19 ; sync and move to y, x
 DB $FF, +$19, +$00 ; draw, y, x
 DB $FF, +$0D, +$0D ; draw, y, x
 DB $01, +$26, +$26 ; sync and move to y, x
 DB $FF, +$00, +$19 ; draw, y, x
 DB $FF, +$32, +$00 ; draw, y, x
 DB $FF, -$0C, -$0D ; draw, y, x
 DB $01, +$4C, +$32 ; sync and move to y, x
 DB $FF, -$0D, +$00 ; draw, y, x
 DB $FF, +$0D, -$0C ; draw, y, x
 DB $FF, +$33, -$0D ; draw, y, x
 DB $01, +$7F, +$19 ; sync and move to y, x
 DB $FF, +$00, +$0D ; draw, y, x
 DB $FF, +$32, +$00 ; draw, y, x
 DB $FF, +$00, -$1A ; draw, y, x
 DB $02 ; endmarker 
AnimList_rm_3:
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$26, +$00 ; move to y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $FF, -$1A, -$18 ; draw, y, x
 DB $FF, -$19, -$26 ; draw, y, x
 DB $FF, -$33, +$00 ; draw, y, x
 DB $01, +$19, -$32 ; sync and move to y, x
 DB $FF, -$0D, +$19 ; draw, y, x
 DB $FF, +$33, +$00 ; draw, y, x
 DB $01, +$3F, -$19 ; sync and move to y, x
 DB $FF, +$0D, +$0D ; draw, y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $FF, -$0D, -$0D ; draw, y, x
 DB $01, +$19, -$19 ; sync and move to y, x
 DB $FF, -$32, +$00 ; draw, y, x
 DB $FF, -$33, -$19 ; draw, y, x
 DB $01, -$4C, -$32 ; sync and move to y, x
 DB $FF, -$3F, -$40 ; draw, y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $FF, +$0C, +$0D ; draw, y, x
 DB $01, -$80, -$65 ; sync and move to y, x
 DB $00, -$25, +$00 ; move to y, x
 DB $FF, +$1A, +$0D ; draw, y, x
 DB $FF, +$0C, +$19 ; draw, y, x
 DB $01, -$7F, -$3F ; sync and move to y, x
 DB $FF, +$1A, +$26 ; draw, y, x
 DB $FF, +$19, +$0A ; draw, y, x
 DB $FF, +$1A, +$0D ; draw, y, x
 DB $01, -$32, -$02 ; sync and move to y, x
 DB $FF, +$00, +$0E ; draw, y, x
 DB $FF, -$1A, +$0D ; draw, y, x
 DB $01, -$4C, +$19 ; sync and move to y, x
 DB $FF, -$0C, +$19 ; draw, y, x
 DB $FF, -$0D, -$0C ; draw, y, x
 DB $FF, -$4C, +$00 ; draw, y, x
 DB $01, -$80, +$26 ; sync and move to y, x
 DB $00, -$31, +$00 ; move to y, x
 DB $FF, +$00, +$26 ; draw, y, x
 DB $FF, +$0C, -$1A ; draw, y, x
 DB $01, -$80, +$32 ; sync and move to y, x
 DB $00, -$25, +$00 ; move to y, x
 DB $FF, +$26, +$0D ; draw, y, x
 DB $FF, +$33, +$0D ; draw, y, x
 DB $FF, +$4C, -$33 ; draw, y, x
 DB $01, +$00, +$19 ; sync and move to y, x
 DB $FF, +$26, +$00 ; draw, y, x
 DB $FF, -$0D, +$0D ; draw, y, x
 DB $01, +$19, +$26 ; sync and move to y, x
 DB $FF, +$26, +$19 ; draw, y, x
 DB $FF, +$19, +$00 ; draw, y, x
 DB $FF, -$19, -$19 ; draw, y, x
 DB $01, +$3F, +$26 ; sync and move to y, x
 DB $FF, +$19, -$0D ; draw, y, x
 DB $FF, +$1A, +$00 ; draw, y, x
 DB $01, +$72, +$19 ; sync and move to y, x
 DB $FF, +$00, +$0D ; draw, y, x
 DB $FF, +$33, +$00 ; draw, y, x
 DB $FF, +$00, -$1A ; draw, y, x
 DB $02 ; endmarker 
AnimList_rm_4:
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$0C, +$00 ; move to y, x
 DB $FF, +$1A, +$00 ; draw, y, x
 DB $FF, +$00, +$1A ; draw, y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $FF, -$0D, -$0D ; draw, y, x
 DB $01, +$72, +$19 ; sync and move to y, x
 DB $FF, -$1A, +$00 ; draw, y, x
 DB $FF, -$19, +$0D ; draw, y, x
 DB $FF, +$26, +$19 ; draw, y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $01, +$3F, +$3F ; sync and move to y, x
 DB $FF, -$0D, -$0D ; draw, y, x
 DB $FF, -$19, -$0C ; draw, y, x
 DB $FF, +$0D, -$0D ; draw, y, x
 DB $FF, -$32, +$00 ; draw, y, x
 DB $01, -$0C, +$19 ; sync and move to y, x
 DB $FF, -$4C, +$26 ; draw, y, x
 DB $FF, -$4D, +$0D ; draw, y, x
 DB $01, -$80, +$4C ; sync and move to y, x
 DB $00, -$25, +$00 ; move to y, x
 DB $FF, +$00, +$19 ; draw, y, x
 DB $FF, -$0C, +$00 ; draw, y, x
 DB $FF, -$0D, -$33 ; draw, y, x
 DB $01, -$80, +$32 ; sync and move to y, x
 DB $00, -$3E, +$00 ; move to y, x
 DB $FF, +$33, +$00 ; draw, y, x
 DB $FF, +$26, -$0C ; draw, y, x
 DB $FF, +$19, -$0D ; draw, y, x
 DB $FF, +$1A, -$0D ; draw, y, x
 DB $01, -$32, +$0C ; sync and move to y, x
 DB $FF, +$0C, -$0C ; draw, y, x
 DB $FF, -$32, -$0C ; draw, y, x
 DB $01, -$58, -$0C ; sync and move to y, x
 DB $FF, -$1A, -$17 ; draw, y, x
 DB $FF, -$03, -$1C ; draw, y, x
 DB $FF, -$23, -$19 ; draw, y, x
 DB $01, -$80, -$58 ; sync and move to y, x
 DB $00, -$18, +$00 ; move to y, x
 DB $FF, +$00, -$0D ; draw, y, x
 DB $FF, +$33, +$19 ; draw, y, x
 DB $FF, +$17, +$26 ; draw, y, x
 DB $FF, +$28, +$00 ; draw, y, x
 DB $01, -$26, -$26 ; sync and move to y, x
 DB $FF, +$26, +$0D ; draw, y, x
 DB $FF, +$3F, -$0D ; draw, y, x
 DB $01, +$3F, -$26 ; sync and move to y, x
 DB $FF, +$33, +$1A ; draw, y, x
 DB $FF, +$0D, +$18 ; draw, y, x
 DB $FF, +$0C, +$00 ; draw, y, x
 DB $01, +$26, -$0C ; sync and move to y, x
 DB $FF, +$26, +$00 ; draw, y, x
 DB $02 ; endmarker 
AnimList_rm_5:
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$32, +$00 ; move to y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $FF, -$19, -$0C ; draw, y, x
 DB $FF, -$1A, -$19 ; draw, y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $01, +$32, -$19 ; sync and move to y, x
 DB $FF, -$26, +$0D ; draw, y, x
 DB $FF, -$25, -$0D ; draw, y, x
 DB $FF, -$33, -$0D ; draw, y, x
 DB $FF, -$0C, -$19 ; draw, y, x
 DB $01, -$58, -$3F ; sync and move to y, x
 DB $FF, +$00, -$26 ; draw, y, x
 DB $FF, -$33, +$00 ; draw, y, x
 DB $FF, +$19, +$0D ; draw, y, x
 DB $FF, +$00, +$26 ; draw, y, x
 DB $01, -$72, -$32 ; sync and move to y, x
 DB $FF, +$0D, +$26 ; draw, y, x
 DB $FF, +$26, +$0C ; draw, y, x
 DB $01, -$3F, +$00 ; sync and move to y, x
 DB $FF, +$19, +$0C ; draw, y, x
 DB $FF, -$4C, +$0D ; draw, y, x
 DB $FF, -$4C, +$0D ; draw, y, x
 DB $01, -$80, +$26 ; sync and move to y, x
 DB $00, -$3E, +$00 ; move to y, x
 DB $FF, +$00, +$19 ; draw, y, x
 DB $FF, +$0D, +$19 ; draw, y, x
 DB $FF, +$0C, +$00 ; draw, y, x
 DB $FF, -$0C, -$19 ; draw, y, x
 DB $01, -$80, +$3F ; sync and move to y, x
 DB $00, -$31, +$00 ; move to y, x
 DB $FF, +$4C, -$03 ; draw, y, x
 DB $FF, +$3F, -$0C ; draw, y, x
 DB $01, -$26, +$30 ; sync and move to y, x
 DB $FF, +$26, -$0A ; draw, y, x
 DB $FF, +$26, -$0D ; draw, y, x
 DB $FF, +$00, +$19 ; draw, y, x
 DB $01, +$26, +$32 ; sync and move to y, x
 DB $FF, +$0C, +$0D ; draw, y, x
 DB $FF, +$1A, +$00 ; draw, y, x
 DB $FF, -$0D, -$0D ; draw, y, x
 DB $FF, +$00, -$0C ; draw, y, x
 DB $01, +$3F, +$26 ; sync and move to y, x
 DB $FF, +$40, +$00 ; draw, y, x
 DB $FF, +$00, -$0D ; draw, y, x
 DB $01, +$7F, +$19 ; sync and move to y, x
 DB $FF, +$0C, +$0D ; draw, y, x
 DB $FF, +$26, +$00 ; draw, y, x
 DB $FF, +$00, -$1A ; draw, y, x
 DB $02 ; endmarker 
AnimList_rm_6:
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$32, +$00 ; move to y, x
 DB $FF, -$32, +$00 ; draw, y, x
 DB $FF, -$1A, -$18 ; draw, y, x
 DB $FF, -$26, -$1A ; draw, y, x
 DB $01, +$3F, -$26 ; sync and move to y, x
 DB $FF, -$4B, +$0D ; draw, y, x
 DB $FF, -$2C, +$00 ; draw, y, x
 DB $FF, -$20, -$3F ; draw, y, x
 DB $FF, -$33, +$00 ; draw, y, x
 DB $01, -$80, -$58 ; sync and move to y, x
 DB $00, -$0B, +$00 ; move to y, x
 DB $FF, +$26, +$0C ; draw, y, x
 DB $FF, +$0A, +$36 ; draw, y, x
 DB $FF, +$1C, +$20 ; draw, y, x
 DB $01, -$3F, +$0A ; sync and move to y, x
 DB $FF, -$33, +$0F ; draw, y, x
 DB $FF, -$4C, +$00 ; draw, y, x
 DB $FF, +$00, +$33 ; draw, y, x
 DB $FF, +$0D, +$00 ; draw, y, x
 DB $01, -$80, +$4C ; sync and move to y, x
 DB $00, -$31, +$00 ; move to y, x
 DB $FF, +$0C, -$1A ; draw, y, x
 DB $FF, +$40, +$00 ; draw, y, x
 DB $FF, +$19, -$02 ; draw, y, x
 DB $01, -$4C, +$30 ; sync and move to y, x
 DB $FF, +$26, -$0D ; draw, y, x
 DB $FF, +$32, -$0A ; draw, y, x
 DB $FF, +$00, +$0D ; draw, y, x
 DB $FF, +$1A, +$19 ; draw, y, x
 DB $01, +$26, +$3F ; sync and move to y, x
 DB $FF, +$00, -$0D ; draw, y, x
 DB $FF, +$00, -$19 ; draw, y, x
 DB $FF, +$26, +$00 ; draw, y, x
 DB $01, +$4C, +$19 ; sync and move to y, x
 DB $FF, +$26, +$00 ; draw, y, x
 DB $FF, +$0D, +$0D ; draw, y, x
 DB $FF, +$32, +$00 ; draw, y, x
 DB $FF, +$00, -$1A ; draw, y, x
 DB $02 ; endmarker 
AnimList_rm_7:
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$32, +$00 ; move to y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $FF, -$19, -$18 ; draw, y, x
 DB $FF, -$0D, +$00 ; draw, y, x
 DB $01, +$65, -$0C ; sync and move to y, x
 DB $FF, -$33, +$00 ; draw, y, x
 DB $FF, -$4E, -$0D ; draw, y, x
 DB $FF, -$23, +$0D ; draw, y, x
 DB $FF, -$0D, +$00 ; draw, y, x
 DB $01, -$4C, -$0C ; sync and move to y, x
 DB $FF, -$0C, -$0D ; draw, y, x
 DB $FF, +$0C, -$26 ; draw, y, x
 DB $FF, -$26, -$0D ; draw, y, x
 DB $01, -$72, -$4C ; sync and move to y, x
 DB $FF, +$0D, +$1A ; draw, y, x
 DB $FF, -$0D, +$32 ; draw, y, x
 DB $FF, -$4C, +$00 ; draw, y, x
 DB $FF, +$00, +$32 ; draw, y, x
 DB $01, -$80, +$32 ; sync and move to y, x
 DB $00, -$3E, +$00 ; move to y, x
 DB $FF, +$0D, +$00 ; draw, y, x
 DB $FF, +$0C, -$19 ; draw, y, x
 DB $FF, +$40, +$0D ; draw, y, x
 DB $01, -$65, +$26 ; sync and move to y, x
 DB $FF, +$33, -$0D ; draw, y, x
 DB $FF, +$3E, +$00 ; draw, y, x
 DB $FF, -$0C, +$19 ; draw, y, x
 DB $FF, +$0C, +$00 ; draw, y, x
 DB $01, +$0C, +$32 ; sync and move to y, x
 DB $FF, +$0D, -$0C ; draw, y, x
 DB $FF, +$26, +$00 ; draw, y, x
 DB $FF, +$19, -$0D ; draw, y, x
 DB $01, +$58, +$19 ; sync and move to y, x
 DB $FF, +$27, +$00 ; draw, y, x
 DB $FF, +$00, +$0D ; draw, y, x
 DB $FF, +$32, +$00 ; draw, y, x
 DB $FF, +$00, -$1A ; draw, y, x
 DB $02 ; endmarker 
AnimList_rm_8:
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$32, +$00 ; move to y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $FF, -$0C, +$00 ; draw, y, x
 DB $FF, -$1A, -$0C ; draw, y, x
 DB $FF, -$19, -$0C ; draw, y, x
 DB $01, +$4C, -$0C ; sync and move to y, x
 DB $FF, -$33, -$0D ; draw, y, x
 DB $FF, -$32, +$00 ; draw, y, x
 DB $FF, -$19, +$0D ; draw, y, x
 DB $FF, -$1A, +$00 ; draw, y, x
 DB $01, -$4C, -$0C ; sync and move to y, x
 DB $FF, -$0C, -$0D ; draw, y, x
 DB $FF, +$00, -$19 ; draw, y, x
 DB $FF, -$33, +$00 ; draw, y, x
 DB $FF, +$19, +$0C ; draw, y, x
 DB $01, -$72, -$26 ; sync and move to y, x
 DB $FF, +$00, +$0D ; draw, y, x
 DB $FF, -$33, +$00 ; draw, y, x
 DB $FF, -$0C, -$0D ; draw, y, x
 DB $FF, -$0D, +$00 ; draw, y, x
 DB $01, -$80, -$26 ; sync and move to y, x
 DB $00, -$3E, +$00 ; move to y, x
 DB $FF, +$00, +$32 ; draw, y, x
 DB $FF, +$0D, -$18 ; draw, y, x
 DB $FF, +$26, +$0C ; draw, y, x
 DB $FF, +$19, +$0C ; draw, y, x
 DB $01, -$72, +$0C ; sync and move to y, x
 DB $FF, +$0D, +$1A ; draw, y, x
 DB $FF, +$26, +$00 ; draw, y, x
 DB $FF, +$26, -$0D ; draw, y, x
 DB $FF, +$32, +$00 ; draw, y, x
 DB $01, +$19, +$19 ; sync and move to y, x
 DB $FF, +$0D, +$26 ; draw, y, x
 DB $FF, +$0C, +$00 ; draw, y, x
 DB $FF, +$0D, +$00 ; draw, y, x
 DB $FF, -$0D, -$19 ; draw, y, x
 DB $01, +$32, +$26 ; sync and move to y, x
 DB $FF, +$40, -$0D ; draw, y, x
 DB $FF, +$0D, +$0D ; draw, y, x
 DB $FF, +$32, +$00 ; draw, y, x
 DB $FF, +$00, -$1A ; draw, y, x
 DB $02 ; endmarker 
AnimList_rm_9:
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$26, +$00 ; move to y, x
 DB $FF, -$33, +$00 ; draw, y, x
 DB $FF, -$33, -$32 ; draw, y, x
 DB $FF, -$33, +$1A ; draw, y, x
 DB $FF, -$18, -$0D ; draw, y, x
 DB $01, -$0C, -$19 ; sync and move to y, x
 DB $FF, -$40, +$00 ; draw, y, x
 DB $FF, -$4C, -$26 ; draw, y, x
 DB $FF, -$19, +$19 ; draw, y, x
 DB $FF, +$19, +$00 ; draw, y, x
 DB $01, -$80, -$26 ; sync and move to y, x
 DB $00, -$18, +$00 ; move to y, x
 DB $FF, +$19, +$1A ; draw, y, x
 DB $FF, +$27, +$0C ; draw, y, x
 DB $FF, +$19, +$00 ; draw, y, x
 DB $FF, +$00, +$0C ; draw, y, x
 DB $01, -$3F, +$0C ; sync and move to y, x
 DB $FF, -$0D, +$0D ; draw, y, x
 DB $FF, -$19, +$00 ; draw, y, x
 DB $FF, -$0D, -$19 ; draw, y, x
 DB $FF, -$0D, +$00 ; draw, y, x
 DB $01, -$7F, +$00 ; sync and move to y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $FF, +$1A, +$0C ; draw, y, x
 DB $FF, +$26, +$33 ; draw, y, x
 DB $FF, +$33, -$19 ; draw, y, x
 DB $01, -$32, +$26 ; sync and move to y, x
 DB $FF, +$26, -$0D ; draw, y, x
 DB $FF, +$25, +$00 ; draw, y, x
 DB $FF, -$0D, +$0D ; draw, y, x
 DB $FF, +$0D, +$0C ; draw, y, x
 DB $01, +$19, +$32 ; sync and move to y, x
 DB $FF, +$19, +$1A ; draw, y, x
 DB $FF, +$0D, +$00 ; draw, y, x
 DB $FF, -$0D, -$0D ; draw, y, x
 DB $FF, -$0C, -$19 ; draw, y, x
 DB $01, +$26, +$26 ; sync and move to y, x
 DB $FF, +$26, -$0D ; draw, y, x
 DB $FF, +$19, +$00 ; draw, y, x
 DB $01, +$65, +$19 ; sync and move to y, x
 DB $FF, +$0D, +$0D ; draw, y, x
 DB $FF, +$33, +$00 ; draw, y, x
 DB $FF, +$00, -$1A ; draw, y, x
 DB $02 ; endmarker 
AnimList_rm_10:
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$26, +$00 ; move to y, x
 DB $FF, -$33, +$00 ; draw, y, x
 DB $FF, -$0D, -$0C ; draw, y, x
 DB $FF, -$0D, -$19 ; draw, y, x
 DB $FF, -$0C, -$0D ; draw, y, x
 DB $01, +$4C, -$26 ; sync and move to y, x
 DB $FF, -$0D, +$00 ; draw, y, x
 DB $FF, -$19, +$0D ; draw, y, x
 DB $01, +$26, -$19 ; sync and move to y, x
 DB $FF, -$1A, +$00 ; draw, y, x
 DB $FF, -$64, -$19 ; draw, y, x
 DB $FF, -$1A, -$0D ; draw, y, x
 DB $01, -$72, -$3F ; sync and move to y, x
 DB $FF, -$33, +$00 ; draw, y, x
 DB $FF, +$26, +$0D ; draw, y, x
 DB $01, -$7F, -$32 ; sync and move to y, x
 DB $FF, +$0D, +$0C ; draw, y, x
 DB $FF, +$26, +$0D ; draw, y, x
 DB $FF, +$1A, +$0D ; draw, y, x
 DB $01, -$32, -$0C ; sync and move to y, x
 DB $FF, +$00, +$0C ; draw, y, x
 DB $FF, -$1A, +$19 ; draw, y, x
 DB $01, -$4C, +$19 ; sync and move to y, x
 DB $FF, -$0C, +$0D ; draw, y, x
 DB $FF, -$27, -$1A ; draw, y, x
 DB $FF, -$19, -$0C ; draw, y, x
 DB $01, -$80, +$00 ; sync and move to y, x
 DB $00, -$18, +$00 ; move to y, x
 DB $FF, -$19, +$19 ; draw, y, x
 DB $FF, +$19, +$00 ; draw, y, x
 DB $FF, +$19, +$0D ; draw, y, x
 DB $FF, +$27, +$19 ; draw, y, x
 DB $01, -$58, +$3F ; sync and move to y, x
 DB $FF, +$32, -$19 ; draw, y, x
 DB $FF, +$26, -$1A ; draw, y, x
 DB $01, +$00, +$0C ; sync and move to y, x
 DB $FF, +$0C, +$0D ; draw, y, x
 DB $FF, +$1A, +$00 ; draw, y, x
 DB $FF, +$00, +$19 ; draw, y, x
 DB $01, +$26, +$32 ; sync and move to y, x
 DB $FF, +$19, +$1A ; draw, y, x
 DB $FF, +$19, +$00 ; draw, y, x
 DB $01, +$58, +$4C ; sync and move to y, x
 DB $FF, -$0C, -$0D ; draw, y, x
 DB $FF, -$0D, -$0D ; draw, y, x
 DB $FF, +$0D, -$0C ; draw, y, x
 DB $01, +$4C, +$26 ; sync and move to y, x
 DB $FF, +$19, -$0D ; draw, y, x
 DB $FF, +$0D, +$00 ; draw, y, x
 DB $01, +$72, +$19 ; sync and move to y, x
 DB $FF, +$00, +$0D ; draw, y, x
 DB $FF, +$33, +$00 ; draw, y, x
 DB $FF, +$00, -$1A ; draw, y, x
 DB $02 ; endmarker 
AnimList_rm_11:
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$32, +$00 ; move to y, x
 DB $FF, -$32, +$00 ; draw, y, x
 DB $FF, -$1A, -$18 ; draw, y, x
 DB $FF, -$19, -$26 ; draw, y, x
 DB $FF, -$40, +$19 ; draw, y, x
 DB $01, +$0C, -$19 ; sync and move to y, x
 DB $FF, -$25, -$19 ; draw, y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $FF, -$19, -$0D ; draw, y, x
 DB $FF, -$0D, -$19 ; draw, y, x
 DB $01, -$65, -$58 ; sync and move to y, x
 DB $FF, -$0D, -$1A ; draw, y, x
 DB $FF, -$26, -$0D ; draw, y, x
 DB $FF, +$19, +$1A ; draw, y, x
 DB $FF, +$0D, +$33 ; draw, y, x
 DB $01, -$72, -$32 ; sync and move to y, x
 DB $FF, +$0D, +$0C ; draw, y, x
 DB $FF, +$19, +$0D ; draw, y, x
 DB $01, -$4C, -$19 ; sync and move to y, x
 DB $FF, +$1A, +$0D ; draw, y, x
 DB $FF, +$00, +$18 ; draw, y, x
 DB $FF, -$0D, +$0D ; draw, y, x
 DB $01, -$3F, +$19 ; sync and move to y, x
 DB $FF, -$0D, +$0D ; draw, y, x
 DB $FF, -$59, +$00 ; draw, y, x
 DB $FF, -$0C, +$26 ; draw, y, x
 DB $FF, +$19, -$0D ; draw, y, x
 DB $01, -$80, +$3F ; sync and move to y, x
 DB $00, -$18, +$00 ; move to y, x
 DB $FF, +$4C, +$00 ; draw, y, x
 DB $FF, +$4C, -$33 ; draw, y, x
 DB $01, +$00, +$0C ; sync and move to y, x
 DB $FF, +$19, +$0D ; draw, y, x
 DB $FF, +$19, +$00 ; draw, y, x
 DB $FF, -$0C, +$0D ; draw, y, x
 DB $01, +$26, +$26 ; sync and move to y, x
 DB $FF, +$00, +$00 ; draw, y, x
 DB $FF, +$19, +$19 ; draw, y, x
 DB $FF, +$19, +$00 ; draw, y, x
 DB $FF, -$0C, -$0D ; draw, y, x
 DB $01, +$4C, +$32 ; sync and move to y, x
 DB $FF, +$0C, -$19 ; draw, y, x
 DB $FF, +$1A, +$00 ; draw, y, x
 DB $01, +$72, +$19 ; sync and move to y, x
 DB $FF, +$0D, +$0D ; draw, y, x
 DB $FF, +$32, +$00 ; draw, y, x
 DB $FF, +$00, -$1A ; draw, y, x
 DB $01, +$19, -$0C ; sync and move to y, x
 DB $FF, +$19, +$00 ; draw, y, x
 DB $02 ; endmarker 
AnimList_rm_12:
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$32, +$00 ; move to y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $FF, -$0C, -$18 ; draw, y, x
 DB $01, +$7F, -$0C ; sync and move to y, x
 DB $FF, -$1A, -$1A ; draw, y, x
 DB $FF, -$0D, -$0C ; draw, y, x
 DB $FF, -$0C, +$00 ; draw, y, x
 DB $01, +$4C, -$32 ; sync and move to y, x
 DB $FF, -$1A, +$0C ; draw, y, x
 DB $FF, -$19, +$0D ; draw, y, x
 DB $01, +$19, -$19 ; sync and move to y, x
 DB $FF, -$19, -$0D ; draw, y, x
 DB $FF, -$19, -$0C ; draw, y, x
 DB $FF, -$19, +$00 ; draw, y, x
 DB $01, -$32, -$32 ; sync and move to y, x
 DB $FF, -$26, -$26 ; draw, y, x
 DB $FF, -$0D, -$1A ; draw, y, x
 DB $01, -$65, -$72 ; sync and move to y, x
 DB $FF, -$33, +$00 ; draw, y, x
 DB $FF, +$19, +$0D ; draw, y, x
 DB $FF, +$1A, +$26 ; draw, y, x
 DB $01, -$65, -$3F ; sync and move to y, x
 DB $FF, +$0D, +$19 ; draw, y, x
 DB $FF, +$19, +$1A ; draw, y, x
 DB $01, -$3F, -$0C ; sync and move to y, x
 DB $FF, +$19, +$0C ; draw, y, x
 DB $FF, -$32, +$0C ; draw, y, x
 DB $FF, -$1A, +$0D ; draw, y, x
 DB $01, -$72, +$19 ; sync and move to y, x
 DB $FF, -$26, +$0D ; draw, y, x
 DB $FF, -$19, +$0C ; draw, y, x
 DB $01, -$80, +$32 ; sync and move to y, x
 DB $00, -$31, +$00 ; move to y, x
 DB $FF, +$00, +$0D ; draw, y, x
 DB $FF, +$0C, +$19 ; draw, y, x
 DB $FF, +$0D, +$00 ; draw, y, x
 DB $01, -$80, +$58 ; sync and move to y, x
 DB $00, -$18, +$00 ; move to y, x
 DB $FF, -$03, -$19 ; draw, y, x
 DB $FF, +$36, -$0D ; draw, y, x
 DB $01, -$65, +$32 ; sync and move to y, x
 DB $FF, +$33, -$0C ; draw, y, x
 DB $FF, +$3E, -$1A ; draw, y, x
 DB $FF, +$0D, +$00 ; draw, y, x
 DB $01, +$19, +$0C ; sync and move to y, x
 DB $FF, +$26, +$0D ; draw, y, x
 DB $FF, +$00, +$0D ; draw, y, x
 DB $01, +$3F, +$26 ; sync and move to y, x
 DB $FF, +$19, +$19 ; draw, y, x
 DB $FF, +$0D, +$00 ; draw, y, x
 DB $FF, -$0D, -$19 ; draw, y, x
 DB $01, +$58, +$26 ; sync and move to y, x
 DB $FF, +$00, -$0D ; draw, y, x
 DB $FF, +$27, +$00 ; draw, y, x
 DB $01, +$7F, +$19 ; sync and move to y, x
 DB $FF, +$0C, +$0D ; draw, y, x
 DB $FF, +$26, +$00 ; draw, y, x
 DB $FF, +$00, -$1A ; draw, y, x
 DB $01, +$4C, -$19 ; sync and move to y, x
 DB $FF, -$0D, +$0D ; draw, y, x
 DB $02 ; endmarker 
AnimList_rm_13:
 DB $01, -$80, +$4C ; sync and move to y, x
 DB $00, -$25, +$00 ; move to y, x
 DB $FF, +$40, -$0D ; draw, y, x
 DB $FF, +$33, -$19 ; draw, y, x
 DB $FF, +$4B, -$10 ; draw, y, x
 DB $01, +$19, +$16 ; sync and move to y, x
 DB $FF, +$0D, +$1C ; draw, y, x
 DB $FF, +$0C, +$00 ; draw, y, x
 DB $FF, +$00, -$19 ; draw, y, x
 DB $FF, +$40, +$00 ; draw, y, x
 DB $01, +$72, +$19 ; sync and move to y, x
 DB $FF, +$0D, +$0D ; draw, y, x
 DB $FF, +$3F, +$00 ; draw, y, x
 DB $FF, +$00, -$1A ; draw, y, x
 DB $01, +$7F, +$0C ; sync and move to y, x
 DB $00, +$3F, +$00 ; move to y, x
 DB $FF, -$26, +$00 ; draw, y, x
 DB $FF, -$0D, +$00 ; draw, y, x
 DB $FF, -$0C, -$0C ; draw, y, x
 DB $FF, -$0D, -$0C ; draw, y, x
 DB $01, +$72, -$0C ; sync and move to y, x
 DB $FF, -$26, -$26 ; draw, y, x
 DB $FF, -$1A, +$0C ; draw, y, x
 DB $FF, -$19, +$0D ; draw, y, x
 DB $01, +$19, -$19 ; sync and move to y, x
 DB $FF, -$25, +$00 ; draw, y, x
 DB $FF, -$4C, -$19 ; draw, y, x
 DB $FF, +$00, -$33 ; draw, y, x
 DB $FF, -$27, -$0D ; draw, y, x
 DB $01, -$7F, -$72 ; sync and move to y, x
 DB $FF, +$0D, +$1A ; draw, y, x
 DB $FF, +$00, +$3F ; draw, y, x
 DB $FF, +$26, +$19 ; draw, y, x
 DB $FF, -$33, +$26 ; draw, y, x
 DB $01, -$7F, +$26 ; sync and move to y, x
 DB $FF, -$3F, +$19 ; draw, y, x
 DB $FF, +$0D, +$33 ; draw, y, x
 DB $FF, +$0C, +$00 ; draw, y, x
 DB $FF, +$00, -$26 ; draw, y, x
 DB $02 ; endmarker 
