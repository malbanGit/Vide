 .module printSyncList.s
 .area .text
                    .setdp   0xd000,_DATA

;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
music1              =      0xFD0D
VIA_port_b          =      0xD000                        ;VIA port B data I/O register
VIA_port_a          =      0xD001                        ;VIA port A data I/O register (handshaking)
VIA_t1_cnt_lo       =      0xD004                        ;VIA timer 1 count register lo (scale factor)
VIA_t1_cnt_hi       =      0xD005                        ;VIA timer 1 count register hi
VIA_shift_reg       =      0xD00A                        ;VIA shift register
VIA_cntl            =      0xD00C                        ;VIA control register
VIA_int_flags       =      0xD00D                        ;VIA interrupt flags register
Intensity_5F        =      0xF2A5                        ;
Wait_Recal          =      0xF192                        ;
Mov_Draw_VLc_a      =      0xF3AD                        ;count y x y x ...
Moveto_d            =      0xF312                        ;
; SUBROUTINE SECTION
;***************************************************************************
;ZERO ing the integrators takes time. Measures at my vectrex show e.g.:
;If you move the beam with a to x = -127 and y = -127 at diffferent scale values, the time to reach zero:
;- scale 0xff -> zero 110 cycles
;- scale 0x7f -> zero 75 cycles
;- scale 0x40 -> zero 57 cycles
;- scale 0x20 -> zero 53 cycles
ZERO_DELAY          =      3                            ; delay 7 counter is exactly 111 cycles delay between zero SETTING and zero unsetting (in moveto_d)
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
 .globl draw_synced_list
draw_synced_list:
                    pshs     a                            ; remember out different scale factors
                    pshs     b
                                                          ; first list entry (first will be a sync + moveto_d, so we just stay here!)
                    lda      ,u+                          ; this will be a "1"
 .globl sync
sync:
                    deca                                  ; test if real sync - or end of list (2)
                    bne      drawdone                     ; if end of list -> jump
; zero integrators
                    ldb      #0xCC                         ; zero the integrators
                    stb      *VIA_cntl                    ; store zeroing values to cntl
                    ldb      #ZERO_DELAY                  ; and wait for zeroing to be actually done
; reset integrators
                    clr      *VIA_port_a                  ; reset integrator offset
                    lda      #0b10000010
; wait that zeroing surely has the desired effect!
 .globl zeroLoop
zeroLoop:
                    sta      *VIA_port_b                  ; while waiting, zero offsets
                    decb
                    bne      zeroLoop
                    inc      *VIA_port_b
; unzero is done by moveto_d
                    lda      1,s                          ; scalefactor move
                    sta      *VIA_t1_cnt_lo               ; to timer t1 (lo=
                    tfr      x,d                          ; load our coordinates of "entry" of vectorlist
; macro call ->                     MY_MOVE_TO_D_START                    ; move there
                    STA      *VIA_port_a                  ;Store Y in D/A register
                    LDA      #0xCE                         ;Blank low, zero high?
                    STA      *VIA_cntl                    ;
                    CLRA
                    STA      *VIA_port_b                  ;Enable mux ; hey dis si "break integratorzero 440"
 nop ; y must be set more than xx cycles on some vectrex
                    INC      *VIA_port_b                  ;Disable mux
                    STB      *VIA_port_a                  ;Store X in D/A register
                    STA      *VIA_t1_cnt_hi               ;enable timer
                    lda      ,s                           ; scale factor vector
                    sta      *VIA_t1_cnt_lo               ; to timer T1 (lo)
; macro call ->                     MY_MOVE_TO_B_END
                    LDB      #0x40                         ;
 .globl LF33D22
LF33D22:            BITB     *VIA_int_flags               ;
                    BEQ      LF33D22                      ;
 .globl moveTo
moveTo:
                    ldd      ,u++                         ; do our "internal" moveto d
                    beq      nextListEntry                ; there was a move 0,0, if so
                    jsr      Moveto_d
 .globl nextListEntry
nextListEntry:
                    lda      ,u+                          ; load next "mode" byte
                    beq      moveTo                       ; if 0, than we should move somewhere
                    bpl      sync                         ; if still positive it is a 1 pr 2 _> goto sync
; now we should draw a vector
                    ldd      ,u++                         ;Get next coordinate pair
                    STA      *VIA_port_a                  ;Send Y to A/D
                    CLR      *VIA_port_b                  ;Enable mux
                    LDA      #0xff                         ;Get pattern byte
                    INC      *VIA_port_b                  ;Disable mux
                    STB      *VIA_port_a                  ;Send X to A/D
                    LDB      #0x40                         ;B-reg = T1 interrupt bit
                    CLR      *VIA_t1_cnt_hi               ;Clear T1H
                    STA      *VIA_shift_reg               ;Store pattern in shift register
 .globl setPatternLoop
setPatternLoop:
                    BITB     *VIA_int_flags               ;Wait for T1 to time out
                    beq      setPatternLoop               ; wait till line is finished
                    CLR      *VIA_shift_reg               ; switch the light off (for sure)
                    bra      nextListEntry

 .globl drawdone
drawdone:
                    puls     d, pc                            ; correct stack and go back

;***************************************************************************
; DATA SECTION
;***************************************************************************
