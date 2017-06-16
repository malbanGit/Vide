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
                    ORG      $c880                        ; start of our ram space 
zero_delay          ds       1                            ; delay for sync list -> variable 
ring_scale          ds       1 
current_button_state  ds     1                            ; only bit 0 
last_button_state   ds       1                            ; only bit 0 
angle ds 1
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
                    DB       "NEW PROG", $80              ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
                    clra     
                    sta      current_button_state 
                    sta      last_button_state 
                    jmp      start 

                    INCLUDE  "drawSubRoutines.i"          ; vectrex function includes
start: 
; here the cartridge program starts off
                                                          ; the difference 
main: 
 jsr Wait_Recal

 ldu #eightSided
 inc angle
 lda angle
 
 jsr drawRotated

                    jsr      getButtonState               ; is a button pressed? 
                    CMPB     #$01                         ; yes, but last time is was not pressed 
                    beq      newRing 
                    CMPB     #$03                         ; yes, and last time was pressed 
                    beq      ringContinue 
                    CMPB     #$02                         ; no, but last time was pressed 
                    beq      ringFinished 
; beq no_playerAction ; zero means no, and last was also not pressed
no_playerAction: 
                    jsr      drawPlayerHome 
                                                          ; vector beam to $5f 
                    BRA      main                         ; and repeat forever 

newRing: 
                    lda      #5 
                    sta      ring_scale 
ringContinue: 
                    inc      ring_scale 
                    bne      noMax 
                    dec      ring_scale 
noMax: 
                    jsr      drawCompleteRing 
                    jmp      no_playerAction 

ringFinished: 
                    jmp      no_playerAction 

 
drawPlayerHome
; draw player "home"
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                                                          ; vector beam to $5f 
                    ldu      #RingOnly                    ; address of list 
                    LDA      #$0                          ; Text position relative Y 
                    LDB      #$0                          ; Text position relative X 
                    sta      zero_delay 
                    tfr      d,x                          ; in x position of list 
                    lda      #$5                          ; scale positioning 
                    ldb      #$5                          ; scale move in list 
                    jsr      draw_synced_list 
; draw play home done
                    rts      

drawCompleteRing
; draw Ring
                    JSR      Intensity_5F                 ; Sets the intensity of the 
   lda ring_scale
 cmpa #$a0
 bls completeRing

 cmpa #$f0
 bls halfRing
                    ldu      #RingOnly                ; address of list 
 bra doDrawRing

halfRing:
                    ldu      #RingAllInner                ; address of list 
 bra doDrawRing
completeRing
                    ldu      #RingComplete                ; address of list 

doDrawRing:
                    lda      #7                           ; vector beam to $5f 
                    sta      zero_delay 
                    LDA      #$0                          ; Text position relative Y 
                    LDB      #$0                          ; Text position relative X 
                    tfr      d,x                          ; in x position of list 
                    lda      ring_scale 
                    tfr      a,b 
                    jsr      draw_synced_list 
; draw Ring done
                    rts      

; returns in B the current button state in relation to last button state
; bit 0 represents current button state
; bit 1 last button state
; 1 = pressed
; 0 = not pressed
getButtonState: 
; save last states, and shift the old current one bit
; query buttons from psg
                    LDA      #$0E                         ;Sound chip register 0E to port A 
                    STA      <VIA_port_a 
                    LDD      #$9981                       ;sound BDIR on, BC1 on, mux off 
                    sta      <VIA_port_b                  ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address) 
                    NOP                                   ;pause 
                    STB      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    CLR      <VIA_DDR_a                   ;DDR A to input 
                    LDD      #$8981                       ;sound BDIR off, BC1 on, mux off 
                    STA      <VIA_port_b                  ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (PSG Read) 
                    NOP                                   ;pause 
                    LDA      <VIA_port_a                  ;Read buttons 
                    STB      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    LDB      #$FF 
                    STB      <VIA_DDR_a                   ;DDR A to output 
; query done, in A current button stae directly from psg
                    ldb      current_button_state 
                    stb      last_button_state 
                    lslb     
 anda #$f ; only jostick 1
                    cmpa     #$0f                          
                    beq      noButtonPressed 
                    incb     
noButtonPressed: 
                    stb      current_button_state 
                    andb     #3 
                    rts      

;***************************************************************************
; DATA SECTION
;***************************************************************************
;***************************************************************************
; sync list
RingComplete: 
 DB $01, -$3F, -$7F ; sync and move to y, x
 DB $FF, +$7E, +$00 ; draw, y, x
 DB $FF, +$40, +$40 ; draw, y, x
 DB $FF, +$00, +$7E ; draw, y, x
 DB $FF, -$40, +$40 ; draw, y, x
 DB $FF, -$7E, +$00 ; draw, y, x
 DB $FF, -$40, -$40 ; draw, y, x
 DB $FF, +$00, -$7E ; draw, y, x
 DB $FF, +$40, -$40 ; draw, y, x
RingAllInner: 
 DB $01, +$3F, -$7F ; sync and move to y, x
 DB $FF, +$15, +$55 ; draw, y, x
 DB $FF, +$2B, +$69 ; draw, y, x
 DB $FF, -$55, +$15 ; draw, y, x
 DB $FF, -$69, +$2B ; draw, y, x
 DB $FF, -$15, -$55 ; draw, y, x
 DB $FF, -$2B, -$69 ; draw, y, x
 DB $FF, +$55, -$15 ; draw, y, x
 DB $FF, +$69, -$2B ; draw, y, x
 DB $01, +$7F, -$3F ; sync and move to y, x
 DB $FF, -$2B, +$69 ; draw, y, x
 DB $FF, -$15, +$55 ; draw, y, x
 DB $FF, -$69, -$2B ; draw, y, x
 DB $FF, -$55, -$15 ; draw, y, x
 DB $FF, +$2B, -$69 ; draw, y, x
 DB $FF, +$15, -$55 ; draw, y, x
 DB $FF, +$69, +$2B ; draw, y, x
 DB $FF, +$55, +$15 ; draw, y, x
RingOnly: 
 DB $01, -$2A, -$54 ; sync and move to y, x
 DB $FF, +$54, +$00 ; draw, y, x
 DB $FF, +$2A, +$2A ; draw, y, x
 DB $FF, +$00, +$54 ; draw, y, x
 DB $FF, -$2A, +$2A ; draw, y, x
 DB $FF, -$54, +$00 ; draw, y, x
 DB $FF, -$2A, -$2A ; draw, y, x
 DB $FF, +$00, -$54 ; draw, y, x
 DB $FF, +$2A, -$2A ; draw, y, x
 DB $02 ; endmarker 


; VLMode Lists
EnemyX:
 DB $02, +$7E, +$7E ; mode, y, x
 DB $00, -$7E, +$00 ; mode, y, x
 DB $02, +$7E, -$7E ; mode, y, x
 DB $01 ; endmarker (1)

eightSided:
 DB $08 ; count
 DB $00, +$03, -$01 ; move, y, x
 DB $02, +$00, +$02 ; draw, y, x
 DB $02, -$02, +$02 ; draw, y, x
 DB $02, -$02, +$00 ; draw, y, x
 DB $02, -$02, -$02 ; draw, y, x
 DB $02, +$00, -$02 ; draw, y, x
 DB $02, +$02, -$02 ; draw, y, x
 DB $02, +$02, +$00 ; draw, y, x
 DB $02, +$02, +$02 ; draw, y, x

; rotation coords, actually X = -sin, Y = cos
; BIOS also has a sin table, but that one is one 1/4 of a full wave
; and it is called so weirdly (Rise/Run)
; this is straight forward and I don't have to check in what quarter I am or whether I am cos or sin...
; thank god we have the space :-) 
cos_sin_list: 
                    DB       +$00, +$78                   ; draw to y, x 
                    DB       -$0C, +$77                   ; draw to y, x 
                    DB       -$19, +$75                   ; draw to y, x 
                    DB       -$24, +$72                   ; draw to y, x 
                    DB       -$30, +$6E                   ; draw to y, x 
                    DB       -$3B, +$68                   ; draw to y, x 
                    DB       -$46, +$62                   ; draw to y, x 
                    DB       -$4F, +$5A                   ; draw to y, x 
                    DB       -$58, +$52                   ; draw to y, x 
                    DB       -$60, +$48                   ; draw to y, x 
                    DB       -$67, +$3E                   ; draw to y, x 
                    DB       -$6D, +$33                   ; draw to y, x 
                    DB       -$71, +$27                   ; draw to y, x 
                    DB       -$75, +$1C                   ; draw to y, x 
                    DB       -$77, +$0F                   ; draw to y, x 
                    DB       -$78, +$03                   ; draw to y, x 
                    DB       -$78, -$09                   ; draw to y, x 
                    DB       -$76, -$16                   ; draw to y, x 
                    DB       -$73, -$22                   ; draw to y, x 
                    DB       -$6F, -$2D                   ; draw to y, x 
                    DB       -$6A, -$38                   ; draw to y, x 
                    DB       -$64, -$43                   ; draw to y, x 
                    DB       -$5C, -$4D                   ; draw to y, x 
                    DB       -$54, -$56                   ; draw to y, x 
                    DB       -$4A, -$5E                   ; draw to y, x 
                    DB       -$40, -$65                   ; draw to y, x 
                    DB       -$36, -$6B                   ; draw to y, x 
                    DB       -$2A, -$70                   ; draw to y, x 
                    DB       -$1F, -$74                   ; draw to y, x 
                    DB       -$12, -$77                   ; draw to y, x 
                    DB       -$06, -$78                   ; draw to y, x 
                    DB       +$06, -$78                   ; draw to y, x 
                    DB       +$12, -$77                   ; draw to y, x 
                    DB       +$1F, -$74                   ; draw to y, x 
                    DB       +$2A, -$70                   ; draw to y, x 
                    DB       +$36, -$6B                   ; draw to y, x 
                    DB       +$40, -$65                   ; draw to y, x 
                    DB       +$4A, -$5E                   ; draw to y, x 
                    DB       +$54, -$56                   ; draw to y, x 
                    DB       +$5C, -$4D                   ; draw to y, x 
                    DB       +$64, -$43                   ; draw to y, x 
                    DB       +$6A, -$38                   ; draw to y, x 
                    DB       +$6F, -$2D                   ; draw to y, x 
                    DB       +$73, -$22                   ; draw to y, x 
                    DB       +$76, -$16                   ; draw to y, x 
                    DB       +$78, -$09                   ; draw to y, x 
                    DB       +$78, +$03                   ; draw to y, x 
                    DB       +$77, +$0F                   ; draw to y, x 
                    DB       +$75, +$1C                   ; draw to y, x 
                    DB       +$71, +$27                   ; draw to y, x 
                    DB       +$6D, +$33                   ; draw to y, x 
                    DB       +$67, +$3E                   ; draw to y, x 
                    DB       +$60, +$48                   ; draw to y, x 
                    DB       +$58, +$52                   ; draw to y, x 
                    DB       +$4F, +$5A                   ; draw to y, x 
                    DB       +$46, +$62                   ; draw to y, x 
                    DB       +$3B, +$68                   ; draw to y, x 
                    DB       +$30, +$6E                   ; draw to y, x 
                    DB       +$24, +$72                   ; draw to y, x 
                    DB       +$19, +$75                   ; draw to y, x 
                    DB       +$0C, +$77                   ; draw to y, x 
