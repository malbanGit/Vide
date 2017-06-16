;***************************************************************************
_DP_TO_C8           macro                                 ;   pretty for optimizing to use a makro :-) 
                    LDA      #$C8 
                    TFR      A,DP 
                    direct   $C8 
                    endm     
;***************************************************************************
_DP_TO_D0           macro                                 ;   pretty for optimizing to use a makro :-) 
                    LDA      #$D0 
                    TFR      A,DP 
                    direct   $D0 
                    endm     
_ZERO_VECTOR_BEAM macro
                 LDB     #$CC
                 STB     VIA_cntl       ;/BLANK low and /ZERO low
                 endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro D = D *2
MY_LSL_D            macro    
                    ASLB     
                    ROLA     
                    endm                                  ; done 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro D = D /2
MY_LSR_D            macro    
                    ASRA     
                    RORB     
                    endm                                  ; done 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set X to correct correction pointer for current sidedness polygon
SET_CORRECTION_POINTER  macro  
                    ldx      #polygon_5_div_correction 
                    ;ldx      #polygon_5_correction 
                    lda      sided 
                    cmpa     #5 
                    beq      done\? 
                    leax     <(polygon_6_div_correction-polygon_5_div_correction),x 
                    cmpa     #6 
                    beq      done\? 
                    leax     <(polygon_7_div_correction-polygon_6_div_correction),x 
                    cmpa     #7 
                    beq      done\? 
                    leax     <(polygon_8_div_correction-polygon_7_div_correction),x 
done\? 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; load the "divider" for n polygone (given in sided)
; to d
GET_POLY_DIV        macro    
                    lda      sided 
                    cmpa     #5 
                    bne      test_n6\? 
                    ldd      #FIVE_ADD 
                    bra      got_it\? 

test_n6\?: 
                    cmpa     #6 
                    bne      test_n7\? 
                    ldd      #SIX_ADD 
                    bra      got_it\? 

test_n7\?: 
                    cmpa     #7 
                    bne      test_n8\? 
                    ldd      #SEVEN_ADD 
                    bra      got_it\? 

test_n8\?: 
                    ldd      #EIGHT_ADD 
got_it\?: 
                    endm     
;***************************************************************************


;***************************************************************************
; expect DP = d0
; playes one piece of music, that is given as param
INIT_MUSICl         macro    musicPiece 
                    ldx      #musicPiece                  ; this piece of music 
                    stx      >currentMusic                ; must be played 
                    jSR      init_ym_sound                ; NOW 
                    endm     
INIT_MUSICs         macro    musicPiece 
                    ldx      #musicPiece                  ; this piece of music 
                    stx      >currentMusic                ; must be played 
                    bSR      init_ym_sound                ; NOW 
                    endm     
; playes one piece of music, that is given as param (same as above *cough*)
FORCE_INIT_MUSIC    macro    musicPiece                   ; this piece of music 
                    ldx      #musicPiece                  ; must be played 
                    stx      >currentMusic                ; NOW 
                    JSR      init_ym_sound 
                    endm     
; if no music is playing, than play given piece,
; otherwise play the given piece as next music
;***************************************************************************
INIT_NEXT_MUSIC_X   macro    musicPiece 
                    ldd      currentMusic                 ; is there a current piece playing? 
                    bne      initNext\?                   ; if not 
                    stx      >currentMusic                ; play it now 
                    JSR      init_ym_sound 
                    bra      doneHere\? 

initNext\?: 
                    stx      >nextMusic 
doneHere\? 
                    endm     
;***************************************************************************
INIT_NEXT_MUSIC     macro    musicPiece 
                    ldx      currentMusic                 ; is there a current piece playing? 
                    bne      initNext\?                   ; if not 
                    ldx      #musicPiece                  ; take that piece given and 
                    stx      >currentMusic                ; play it now 
                    JSR      init_ym_sound 
                    bra      doneHere\? 

initNext\?: 
                    ldx      #musicPiece                  ; otherwise, store it as next possible piece 
                    stx      >nextMusic 
doneHere\? 
                    endm     
;***************************************************************************
; destroys X D
; tests if the given SFX has higher (or same) prio as currently playing
; if prio higher (or none playing)
; than playes the SFX (ignored otherwise)
; all effects are playing in PSG channel 3

PLAY_SFX_3            macro    sfxPiece 
 pshs u,x
                    ldx      #sfxPiece 
                    jsr      play_sfx_3 
 puls u,x
                    endm     

PLAY_SFX_2            macro    sfxPiece 
 pshs u,x
                    ldx      #sfxPiece 
                    jsr      play_sfx_2 
 puls u,x
                    endm     

PLAY_SFX_1            macro    sfxPiece 
 pshs u,x
                    ldx      #sfxPiece 
                    jsr      play_sfx_1 
 puls u,x
                    endm     

PLAY_SFX            macro    sfxPiece 
    tst sfx_status_1
    bne use2SFX\?
                    PLAY_SFX_1 sfxPiece
 bra out\?
use2SFX\?:
    tst sfx_status_2
    bne use3SFX\?
                    PLAY_SFX_2 sfxPiece
 bra out\?
use3SFX\?:
    tst sfx_status_3
    bne testPrio1\?
                    PLAY_SFX_3 sfxPiece
 bra out\?
testPrio1\?:
 PLAY_SFX_1 sfxPiece ; leaves on success with a = 1
 cmpa #1
 beq out\? ; playing1\?

testPrio2\?:
 PLAY_SFX_2 sfxPiece
 cmpa #1
 beq out\? ; playing2\?

testPrio3\?:
 PLAY_SFX_3 sfxPiece
out\?
                    endm     

;***************************************************************************
PLAY_SFX_           macro    sfxPiece 
                    ldx      currentSFX_3                   ; load current sfx 
                    beq      storeOk\?                    ; if none playing - jump 
                    lda      2,x                          ; load current prio to a 
                    cmpa     sfxPiece+2                   ; compare to prio of new sfx 
                    bgt      no_new\?                     ; if old prio is higher than go out 
storeOk\?: 
                    ldx      #sfxPiece                    ; new sfx is nice 
                    stx      currentSFX_3                   ; so we store it as current sfx 
                    ldx      ,x                           ; and the actual sfx data store to our sfx player vars 
                    stx      sfx_pointer_3 
                    LDA      #$01                         ; tell the player, that it should play! 
                    STA      sfx_status_3 
no_new\? 
                    endm     
;***************************************************************************
; destroys D X 
; play the given SFX, but only if nothing else is played (regardless of prio)
PLAY_SFX_IF_NOTHING_ELSE  macro  sfxPiece 
                    ldx      #sfxPiece 
                    jsr      play_sfx_x_if_nothing_else 
                    endm     
PLAY_SFX_IF_NOTHING_ELSE_  macro  sfxPiece 
                    tst      currentSFX_3 
                    bne      noNew\? 
                                                          ; hey dissi "b reak" 
                    PLAY_SFX  sfxPiece 
noNew\?: 
                    endm 


;***************************************************************************
MY_MOVE_TO_D_START        macro    
                    STA      <VIA_port_a                  ;Store Y in D/A register 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux 
                    STA      <VIA_shift_reg               ;Clear shift regigster 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 
                    endm     
MY_MOVE_TO_A_END        macro    
                    local    LF33D 
                    LDA      #$40                         ; 
LF33D:              BITA     <VIA_int_flags               ; 
                    BEQ      LF33D                        ; 
                    endm     
MY_MOVE_TO_B_END        macro    
                    local    LF33D 
                    LDB      #$40                         ; 
LF33D:              BITB     <VIA_int_flags               ; 
                    BEQ      LF33D                        ; 
                    endm     

MY_MOVE_TO_D        macro    
; optimzed, tweaked not perfect... 'MOVE TO D' makro
 MY_MOVE_TO_D_START                    
 MY_MOVE_TO_B_END
 endm     

;***************************************************************************
_INTENSITY_A        macro    
                    STA      <VIA_port_a                  ;Store intensity in D/A 
                    LDD      #$0504                       ;mux disabled channel 2 
                    STA      <VIA_port_b                  ; 
                    STB      <VIA_port_b                  ;mux enabled channel 2 
                    STA      <VIA_port_b                  ;turn off mux 
                    endm     

  