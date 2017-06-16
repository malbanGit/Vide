; this file is part of Release, written by Malban in 2017
;
;***************************************************************************
_DP_TO_C8           macro                                 ; pretty for optimizing to use a makro :-) 
                    LDA      #$C8 
                    TFR      A,DP 
                    direct   $C8 
                    endm     
;***************************************************************************
_DP_TO_D0           macro                                 ; pretty for optimizing to use a makro :-) 
                    LDA      #$D0 
                    TFR      A,DP 
                    direct   $D0 
                    endm     
NEG_D               macro    
                    COMA     
                    COMB     
                    ADDD     #1 
                    endm                                  ; done 
;***************************************************************************
; divides D by tmp1, result in B
; uses divide_tmp as storage
; only 8 bit in tmp1, but must be manually poked to tmp1 + 1
; sign is correctly handled
;
; can probably be optimized like hell
; perhaps only nearing the result
; using 2 shifts and a plus
; might be worth a try,
; see vectrex emulator for algorithm...
; could be implemented with a tabel, which in turn
; could be caclulated on the fly... (upon startup)
;
; this makro divides exact, but slow
MY_DIV_D_BY_TMP1_TO_B  macro  
                    CLR      divide_tmp 
                    TST      tmp1+1 
                    BEQ      divide_by_zero\? 
                    DEC      divide_tmp 
                    CMPD     #0 
                    BPL      divide_next\? 
divide_next1\?: 
                    INC      divide_tmp 
                    ADDD     tmp1 
                    BMI      divide_next1\? 
divide_by_zero1\?: 
                    LDB      divide_tmp 
                    NEGB     
                    BRA      divide_end\? 

divide_next\?: 
                    INC      divide_tmp 
                    SUBD     tmp1 
                    BPL      divide_next\? 
divide_by_zero\?: 
                    LDB      divide_tmp 
divide_end\?: 
                    endm     
;***************************************************************************
RESET_VECTOR_BEAM   macro    
                    LDA      #$CC 
                    STA      <VIA_cntl                    ;/BLANK low and /ZERO low 
                    lda      #$83                         ; a = $18, b = $83 disable RAMP, muxsel=false, channel 1 (integrators offsets) 
                    clr      <VIA_port_a                  ; Clear D/A output 
                    sta      <VIA_port_b                  ; set mux to channel 1, leave mux disabled 
                    dec      <VIA_port_b                  ; enable mux, reset integrator offset values 
                                                          ;nop 4 
                    LDA      #$CE 
                    STA      <VIA_cntl                    ;/BLANK high and /ZERO low 
                    inc      <VIA_port_b                  ; Disable mux 
                    endm     
;***************************************************************************
_SCALE              macro    value 
                    LDA      #\1                          ; scale for placing first point 
                    _SCALE_A  
                    endm     
;***************************************************************************
_SCALE_A            macro    
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    endm     
;*************************************************************************** 
MY_WAIT_RECAL       macro    
                    direct   $d0 
                    LDA      #$20 
                    ldx      RecalCounter                 ; recal counter, about 21 Minutes befor roll over 
                    leax     1,x 
                    stx      RecalCounter 
                    tst      noTimerCheck 
                    bne      wrn_trch\? 
                    ldb      <VIA_t2_hi 
                    stb      t2_rest 
wrn_trch\? 
                    clr      noTimerCheck 
LF19E\?:            BITA     <VIA_int_flags               ;Wait for timer t2 
                    BEQ      LF19E\? 
                    LDD      $C83D                        ;Store refresh value 
                    STD      <VIA_t2_lo                   ;into timer t2 
                    LDD      #$CC 
                    STB      <VIA_cntl                    ;blank low and zero low 
                    STA      <VIA_shift_reg               ;clear shift register 
                    sta      <VIA_port_a                  ;clear D/A register 
                    LDD      #$0302 
                    STA      <VIA_port_b                  ;mux=1, disable mux 
                    STB      <VIA_port_b                  ;mux=1, enable mux 
                    LDB      #$01 
                    STB      <VIA_port_b                  ;disable mux 
                    endm     
;***************************************************************************
_ZERO_VECTOR_BEAM   macro    
                    LDB      #$CC 
                    STB      VIA_cntl                     ;/BLANK low and /ZERO low 
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
                                                          ;ldx #polygon_5_correction 
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
; stx tmp_offset
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
INIT_MUSIC_1CH      macro    musicPiece 
                    ldu      musicPiece                   ; this piece of music 
                    jSR      PLY_INIT_CH1                 ; NOW 
                    endm     
INIT_MUSIC          macro    musicPiece 
                    ldu      musicPiece                   ; this piece of music 
                    jSR      PLY_INIT_ALL                 ; NOW 
                    endm     
;***************************************************************************
; destroys X D
; tests if the given SFX has higher (or same) prio as currently playing
; if prio higher (or none playing)
; than playes the SFX (ignored otherwise)
; all effects are playing in PSG channel 3
PLAY_SFX_3          macro    sfxPiece 
                    pshs     u,x 
                    ldx      #sfxPiece 
                    jsr      play_sfx_3 
                    puls     u,x 
                    endm     
PLAY_SFX_2          macro    sfxPiece 
                    pshs     u,x 
                    ldx      #sfxPiece 
                    jsr      play_sfx_2 
                    puls     u,x 
                    endm     
PLAY_SFX_1          macro    sfxPiece 
                    pshs     u,x 
                    ldx      #sfxPiece 
                    jsr      play_sfx_1 
                    puls     u,x 
                    endm     
PLAY_SFX_all3       macro    sfxPiece 
                    tst      sfx_status_1 
                    bne      use2SFX\? 
                    PLAY_SFX_1  sfxPiece 
                    bra      out\? 

use2SFX\?: 
                    tst      sfx_status_2 
                    bne      use3SFX\? 
                    PLAY_SFX_2  sfxPiece 
                    bra      out\? 

use3SFX\?: 
                    tst      sfx_status_3 
                    bne      testPrio1\? 
                    PLAY_SFX_3  sfxPiece 
                    bra      out\? 

testPrio1\?: 
                    PLAY_SFX_1  sfxPiece                  ; leaves on success with a = 1 
                    cmpa     #1 
                    beq      out\?                        ; playing1\? 
testPrio2\?: 
                    PLAY_SFX_2  sfxPiece 
                    cmpa     #1 
                    beq      out\?                        ; playing2\? 
testPrio3\?: 
                    PLAY_SFX_3  sfxPiece 
out\? 
                    endm     
PLAY_SFX            macro    sfxPiece 
use2SFX\?: 
                    tst      sfx_status_2 
                    bne      use3SFX\? 
                    PLAY_SFX_2  sfxPiece 
                    bra      out\? 

use3SFX\?: 
                    tst      sfx_status_3 
                    bne      testPrio2\? 
                    PLAY_SFX_3  sfxPiece 
                    bra      out\? 

testPrio2\?: 
                    PLAY_SFX_2  sfxPiece 
                    cmpa     #1 
                    beq      out\?                        ; playing2\? 
testPrio3\?: 
                    PLAY_SFX_3  sfxPiece 
out\? 
                    endm     
; P1 here means prefer 1 - only to be used with NOISE
; since vtks song doesn't feature noise!
PLAY_SFX_P1         macro    sfxPiece 
use1SFX\?: 
                    tst      sfx_status_1 
                    bne      use2SFX\? 
                    PLAY_SFX_1  sfxPiece 
                    bra      out\? 

use2SFX\?: 
                    tst      sfx_status_2 
                    bne      use3SFX\? 
                    PLAY_SFX_2  sfxPiece 
                    bra      out\? 

use3SFX\?: 
                    tst      sfx_status_3 
                    bne      testPrio1\? 
                    PLAY_SFX_3  sfxPiece 
                    bra      out\? 

testPrio1\?: 
                    PLAY_SFX_1  sfxPiece 
                    cmpa     #1 
                    beq      out\?                        ; playing1|\? 
testPrio2\?: 
                    PLAY_SFX_2  sfxPiece 
                    cmpa     #1 
                    beq      out\?                        ; playing2\? 
testPrio3\?: 
                    PLAY_SFX_3  sfxPiece 
out\? 
                    endm     
;***************************************************************************
PLAY_SFX_           macro    sfxPiece 
                    ldx      currentSFX_3                 ; load current sfx 
                    beq      storeOk\?                    ; if none playing - jump 
                    lda      2,x                          ; load current prio to a 
                    cmpa     sfxPiece+2                   ; compare to prio of new sfx 
                    bgt      no_new\?                     ; if old prio is higher than go out 
storeOk\?: 
                    ldx      #sfxPiece                    ; new sfx is nice 
                    stx      currentSFX_3                 ; so we store it as current sfx 
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
                                                          ; hey di ssi "break" 
                    PLAY_SFX  sfxPiece 
noNew\?: 
                    endm     
;***************************************************************************
MY_MOVE_TO_D_START_NT  macro  
                    STA      <VIA_port_a 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux 
                    STA      <VIA_shift_reg               ;Clear shift regigster 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 
                    endm     
MY_MOVE_TO_D_START  macro    
                    STA      <VIA_port_a                  ;Store Y in D/A register 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux ; hey dis si "break integratorzero 440" 
                    STA      <VIA_shift_reg               ;Clear shift regigster 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 
                    endm     
MY_MOVE_TO_A_END    macro    
                    local    LF33D 
                    LDA      #$40                         ; 
LF33D:              BITA     <VIA_int_flags               ; 
                    BEQ      LF33D                        ; 
                    endm     
MY_MOVE_TO_B_END    macro    
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
MY_MOVE_TO_D_NT     macro    
; optimzed, tweaked not perfect... 'MOVE TO D' makro
                    MY_MOVE_TO_D_START_NT  
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
_INTENSITY_B        macro    
                    STB      <VIA_port_a                  ;Store intensity in D/A 
                    LDD      #$0504                       ;mux disabled channel 2 
                    STA      <VIA_port_b                  ; 
                    STB      <VIA_port_b                  ;mux enabled channel 2 
                    STA      <VIA_port_b                  ;turn off mux 
                    endm     
; uses x and d
ADD_SCORE_10        macro    
                    ldx      #score_buf 
                    ldd      #1 
                    std      ,x 
                    sta      2,x 
                    jsr      add_score_x 
                    endm     
ADD_SCORE_20        macro    
                    ldx      #score_buf 
                    ldd      #2 
                    std      ,x 
                    sta      2,x 
                    jsr      add_score_x 
                    endm     
ADD_SCORE_30        macro    
                    ldx      #score_buf 
                    ldd      #3 
                    std      ,x 
                    sta      2,x 
                    jsr      add_score_x 
                    endm     
ADD_SCORE_50        macro    
                    ldx      #score_buf 
                    ldd      #5 
                    std      ,x 
                    sta      2,x 
                    jsr      add_score_x 
                    endm     
ADD_SCORE_15        macro    
                    ldx      #score_buf 
                    ldd      #1 
                    std      ,x 
                    lda      #5 
                    sta      2,x 
                    jsr      add_score_x 
                    endm     
ADD_SCORE_18        macro    
                    ldx      #score_buf 
                    ldd      #1 
                    std      ,x 
                    lda      #8 
                    sta      2,x 
                    jsr      add_score_x 
                    endm     
ADD_SCORE_36        macro    
                    ldx      #score_buf 
                    ldd      #3 
                    std      ,x 
                    lda      #6 
                    sta      2,x 
                    jsr      add_score_x 
                    endm     
ADD_SCORE_45        macro    
                    ldx      #score_buf 
                    ldd      #4 
                    std      ,x 
                    lda      #5 
                    sta      2,x 
                    jsr      add_score_x 
                    endm     
ADD_SCORE_54        macro    
                    ldx      #score_buf 
                    ldd      #5 
                    std      ,x 
                    lda      #4 
                    sta      2,x 
                    jsr      add_score_x 
                    endm     
GET_DIVI_B_M        macro    
                    clra     
                    tfr      d,u 
                    lda      ,y 
                    beq      subCompleteDone\? 
                    lsla     
                    ldx      #divi_list 
                    jsr      [a,x] 
                    tfr      u,d 
subCompleteDone\?: 
                    endm     
;***************************************************************************
QUERY_JOYSTICK      macro    
queryHW\? 
; joytick pot readings are also switched by the (de)muliplexer (analog section)
; with joystick pots the switching is not done in regard of the output (in opposite to "input" switching of integrator logic)
; but with regard to input
; thus, the SEL part of the mux now selects which joystick pot is selected and send to the compare logic.
; mux sel:
;    xxxx x00x: port 0 horizontal
;    xxxx x01x: port 0 vertical
;    xxxx x10x: port 1 horizontal
;    xxxx x11x: port 1 vertical
; 
; the result of the pot reading is compared to the 
; value present in the dac and according to the comparisson the compare flag of VIA (bit 5 of port b) is set.
; (compare bit is set if contents of dac was "smaller" (signed) than the "pot" read)
DIGITAL_JOYTICK_LOOP_MIN  EQU  $08 
                    ldd      #$0300                       ; mux disabled, mux sel = 01 (vertical pot port 0) 
                    std      <VIA_port_b 
                    dec      <VIA_port_b                  ; mux enabled, mux sel = 01 
                    ldb      #DIGITAL_JOYTICK_LOOP_MIN    ; a wait loop 32 times a loop (waiting for the pots to "read" values, and feed to compare logic) 
waitLoopV\?: 
                    decb                                  ; ... 
                    bne      waitLoopV\?                  ; wait... 
                    inc      <VIA_port_b                  ; disable mux 
                    ldd      #$4020                       ; load a with test value (positive y) 
                    sta      <VIA_port_a                  ; test value to DAC 
                    lda      #$01                         ; default result value y was pushed UP 
                    bitb     <VIA_port_b                  ; test comparator 
                    bne      yReadDone\?                  ; if comparator cleared - joystick was moved up 
                    neg      <VIA_port_a                  ; "load" with negative value 
                    nega                                  ; also switch the possible result in A 
                    bitb     <VIA_port_b                  ; test comparator again 
                    beq      yReadDone\?                  ; if cleared the joystick was moved down 
                    clra                                  ; if still not cleared, we clear a as the final vertical test result (no move at all) 
yReadDone\?: 
                    sta      >Vec_Joy_1_Y                 ; remember the result in "our" joystick data 
                    beq      noymove\? 
                    bra      noxmove\?                    ; if y moved I assume no X move 

noymove\? 
;
; now the same for horizontal
                    ldd      #$0100                       ; mux disabled, mux sel = 00 (horizontal pot port 0) 
                    std      <VIA_port_b 
                    dec      <VIA_port_b                  ; mux enabled, mux sel = 01 
                    ldb      #DIGITAL_JOYTICK_LOOP_MIN    ; a wait loop 32 times a loop (waiting for the pots to "read" values, and feed to compare logic) 
waitLoopH\?: 
                    decb                                  ; ... 
                    bne      waitLoopH\?                  ; wait... 
                    inc      <VIA_port_b                  ; disable mux 
                    ldd      #$4020                       ; load a with test value (positive x) 
                    sta      <VIA_port_a                  ; test value to DAC 
                    lda      #$01                         ; default result value x was pushed right 
                    bitb     <VIA_port_b                  ; test comparator 
                    bne      xReadDone\?                  ; if comparator cleared - joystick was moved right 
                    neg      <VIA_port_a                  ; "load" with negative value 
                    nega                                  ; also switch the possible result in A 
                    bitb     <VIA_port_b                  ; test comparator again 
                    beq      xReadDone\?                  ; if cleared the joystick was moved left 
                    clra                                  ; if still not cleared, we clear a as the final vertical test result (no move at all) 
xReadDone\?: 
                    sta      >Vec_Joy_1_X                 ; remember the result in "our" joystick data 
                    beq      noxmove\? 
noxmove\? 
                    endm     
