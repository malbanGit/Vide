; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains private makros, some are taken from the BIOS of vectrex;
; and changed slightly to be more speedy, other were written alltogether by ;
; me, some of these are even obsolete... but all should be in a working     ;
; state                                                                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
                    ifndef   MY_MAKROS_I 
                    include  "highscoreMakro.I"
MY_MAKROS_I         equ      1 
;**************************************************************************
;
;
; following are some 'private' makro definitions
;
; some heavily optimized for speed :-(
; needs: DP = D0
;***************************************************************************
WRITE_PSG           macro                                 ; a = reg, b = data 
                    STA      <VIA_port_a                  ;store register select byte 
                    LDA      #$19                         ;sound BDIR on, BC1 on, mux off _ LATCH 
                    STA      <VIA_port_b 
                    LDA      #$01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
                    STA      <VIA_port_b 
                    LDA      <VIA_port_a                  ;read sound chip status (?) 
                    STB      <VIA_port_a                  ;store data byte 
                    LDB      #$11                         ;sound BDIR on, BC1 off, mux off - WRITE 
                    STB      <VIA_port_b 
                    LDB      #$01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
                    STB      <VIA_port_b 
                    endm     
;***************************************************************************
; store data in reg a in an
; appropriate way to PSG register (here: BIOS working buffer)
STORE_PSG           macro    register 
;                    ldu      #(Vec_Music_Work + register) 
;                    sta      ,u 
                    sta      (Vec_Music_Work + register) 
                    endm     
STORE_PSG_b         macro    register 
;                    ldu      #(Vec_Music_Work + register) 
;                    stb      ,u 
                    stb      (Vec_Music_Work + register) 
                    endm     
;***************************************************************************
DEFAULT_PSG_SETTING  macro   
                    pshs     dp 
                    LDA      #$D0 
                    TFR      A,DP 
                    ldd      #(7 *256)+FIRST7             ; Karl Quappe $3c is default, all music is plaxed using channel 0+1 
                    stb      >$c807 
                    STORE_PSG_b  7 
                    WRITE_PSG  
                    puls     dp 
                    endm     
;
;***************************************************************************
; this makro is supposed to 'reset' the sound hardware,
MY_QUIT             macro    
                    CLR      Vec_Music_Flag               ; no music is playing ->0 
                    JSR      Init_Music_Buf               ; shadow regs 
                                                          ; in the next do sound call 
                                                          ; all regs are cleared automatically 
                    endm                                  ; end of macro 
;***************************************************************************
; this makro should be called every round a music is to be played
; this does not play the sound, it initializes it only, but also every round!
;
; BIOS MUSIC
; leaves with DP set to C8
; expects music to be initialized
; and pointer in music_active
DO_MY_SOUND         macro                                 ; name of macro 
                    _DP_TO_C8                             ; (MAKRO) the 'Init_Music_chk' expects this 
                    LDU      music_active                 ; get active music 
                    JSR      Init_Music_chk               ; and init new notes 
                    endm                                  ; end of macro 
; offspring of the above, squized cycles :-)
DO_MY_SOUND_MAIN    macro                                 ; name of macro 
                    direct   $c8 
                    LDU      music_active                 ; get active music 
                    JSR      Init_Music_chk               ; and init new notes 
                    endm                                  ; end of macro 
;***************************************************************************
; this makro initializes a new piece of music
; the above 'function' must be called every round in order for the music
; actually to be played
; BIOS MUSIC
PLAY_SOUND          macro    piece_of_music               ; name of macro, and variable name, can also be accessed with \1 
                                                          ; the next instructions initialize a new sound 
                                                          ; load #1 
                                                          ; set this as marker for music start 
;                    CLR      Vec_Music_Flag               ; doesn'T destroy a register 
;                    INC      Vec_Music_Flag               ; to do it that way 
                    lda      #1 
                    sta      Vec_Music_Flag 
                    LDU      #\1                          ; load a music structure (piece_of_music) 
                    STU      music_active                 ; and store it to my own music active pointer 
                                                          ; next a do_my_sound and than do sound must be called 
doNotPlayMusic\? 
                    endm                                  ; end of macro 
;***************************************************************************
; this makro is sort of the startup for every display round
; does all sound stuff and recalibration, leaves with
; DP set to D0
; destroyes pretty much every register...
; BIOS MUSIC
ROUND_STARTUP       macro                                 ; name of macro 
                    tst      musicOption 
                    bne      doNotPlayMusic\? 
                    DO_MY_SOUND                           ; (MAKRO) see above 
doNotPlayMusic\? 
                    ldx      RecalCounter                 ; recal counter, about 21 Minutes befor roll over 
                    leax     1,x 
                    stx      RecalCounter 
                    JSR      Wait_Recal                   ; sets dp to d0, and pos at 0, 0 
                    direct   $D0                          ; just for assembler optimization... 
                    JSR      Do_Sound                     ; ROM function that does the sound playing 
                    endm                                  ; end of macro 
;***************************************************************************
; offspring of the above, squized cycles :-)
; no MUSIC init
ROUND_STARTUP_MAIN  macro                                 ; name of macro 
                    direct   $D0                          ; just for assembler optimization... 
                    MY_WAIT_RECAL  
                    endm                                  ; end of macro 
;***************************************************************************
MY_WAIT_RECAL       macro    
                    direct   $d0 
                    LDA      #$20 
                    ldx      RecalCounter                 ; recal counter, about 21 Minutes befor roll over 
                    leax     1,x 
                    stx      RecalCounter 
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
; the following makros are for intensity setting
; to set a intensity the bios does use some (many) cycles, here a
; test really saves some cycles, if intensity is set many times per round
; (like differently shaded sprites)
;
; intensity set to value found in register A
; is compared/stored to 'current_brightness'
; if not equal the new brightness is set!
MY_INTENSITY_A      macro                                 ; name of macro, and variable name, can also be accessed with 
                    CMPA     current_brightness           ; compare to last known value 
                    BEQ      no_brightness_change\?       ; if the same, than jump 
                    STA      current_brightness           ; otherwise store new value 
                    _INTENSITY_A                          ; and than set the intensity 
no_brightness_change\?: 
                    endm                                  ; end of macro 
;***************************************************************************
; same as above, but allways sets the new brightness
; good for startup of new round, since intensity MUST be set at that point
; or after other functions which destroy brighness (print_str...)
MY_INTENSITY_FORCE  macro    brightness                   ; name of macro, and variable name, can also be accessed with \1 
                    LDA      #\1                          ; load brightness to A 
                    STA      current_brightness           ; store it 
                    _INTENSITY_A                          ; and change the brightness 
                    endm                                  ; end of macro 
;***************************************************************************
MY_GAME_SCALE       macro    
                    LDA      #SCALE_FACTOR_GAME 
                    _SCALE_A  
                    endm     
;***************************************************************************
; the following makro ...
; they search for a better (faster) scale/DAC relation and use
; the scaling thus found, it should be somewhat faster that way...
; per round we save approxematly: ? cycles
; both destroy X and D
; SCALE factor is changed
;
; forget it !!!
;***************************************************************************
MY_MOVE_TO_D        macro    
; optimzed, tweaked not perfect... 'MOVE TO D' makro
;
;
; NOT DONE:
;
; what should be done:
; s = $ff / max(abs(a),abs(b))
; a = a * s
; b = b * s
; scaling = scaling / s
;
; that would give the most efficient positioning
; bother it takes more time to calculate the above,
; than it saves
; with every positioning via this routine now,
; it takes SCALE_FACTOR_GAME + const (of another 100+) cycles
; to do one simple positioning!!!
; that is probably about 300 cycles per positioning
; this is done about 30-40 times per round
; alone the positioning takes thus about over 10000 cycles
; and we haven't drawn a single line yet!!!
                    local    LF33D 
                    STA      <VIA_port_a                  ;Store Y in D/A register 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux 
                    STA      <VIA_shift_reg               ;Clear shift regigster 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 
                    LDB      #$40                         ; 
LF33D:              BITB     <VIA_int_flags               ; 
                    BEQ      LF33D                        ; 
                    endm     
;***************************************************************************
; there are many 16 bit operands missing, so is
; a LSRD
; this macro does a 16 bit LSR on register D
MY_LSR_D            macro    
                    LSRB                                  ; LSR B 
                    LSRA                                  ; LSR A 
                    BCC      no_carry\?                   ; if no carry, than exit 
                    ORB      #128                         ; otherwise underflow from A to 7bit of B 
no_carry\?: 
                    endm                                  ; done 
;***************************************************************************
MY_DIV_D_16_UNSIGNED_  macro  
                    LSLA     
                    LSLA     
                    LSLA     
                    LSLA     
                    LSRB     
                    LSRB     
                    LSRB     
                    LSRB     
                    STA      divide_tmp 
                    ORB      divide_tmp 
                    endm     
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
MY_DIV_D_BY_TMP1_TO_B_UNSIGNED  macro  
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
MY_DIV_D_16_UNSIGNED  macro  
                    LSLA     
                    LSLA     
                    LSLA     
                    LSLA     
                    LSRB     
                    LSRB     
                    LSRB     
                    LSRB     
                    STA      divide_tmp 
                    ORB      divide_tmp 
                    endm     
;***************************************************************************
VECTOR_RESET        macro    
                    LDB      #$A0 
                    STB      <VIA_t1_cnt_lo               ;Set scale factor 
                    LDD      #$7F7F 
                    jsr      my_move_to_d 
                    LDB      #$CC 
                    STB      <VIA_cntl                    ;blank low and zero low 
                    STA      <VIA_shift_reg               ;clear shift register 
                    LDD      #$8080 
                    jsr      my_move_to_d 
                    LDB      #$CC 
                    STB      <VIA_cntl                    ;/BLANK low and /ZERO low 
                    STA      <VIA_shift_reg               ;clear shift register 
                    LDD      #$0302 
                    CLR      <VIA_port_a                  ;clear D/A register 
                    STA      <VIA_port_b                  ;mux=1, disable mux 
                    STB      <VIA_port_b                  ;mux=1, enable mux 
                    dec      <VIA_port_b                  ;disable mux 
                    endm     
;***************************************************************************
FULL_WAIT_RECAL     macro    
                    direct   $d0 
                    LDA      #$20 
                    ldx      RecalCounter                 ; recal counter, about 21 Minutes befor roll over 
                    leax     1,x 
                    stx      RecalCounter 
LF19E\?:            BITA     <VIA_int_flags               ;Wait for timer t2 
                    BEQ      LF19E\? 
                    LDD      $C83D                        ;Store refresh value 
                    STD      <VIA_t2_lo                   ;into timer t2 
                    endm     
;***************************************************************************
QUERY_JOYSTICK      macro    
                    tst      isAttractMode                ; is some kind of attract mode? 
                    beq      queryHW\? 
                    ldx      attractMovePointer           ; if yes, do not query joystick, but look at our recorded data 
                    ldd      #0                           ; default > nothing moved 
                    std      Vec_Joy_1_X 
                    std      last_joy_x 
                    ldd      ,x++ 
                    anda     #%00111111                   ; 14 bit of our recorded data is the time stamp 
                    cmpd     RecalCounter 
                    lbne     attractDoneHere\? 
                    stx      attractMovePointer           ; reload data, and check the first 2 bits 
                    lda      -2,x 
                    anda     #%10000000                   ; if msb is set, than joystick moved in X 
                    beq      joyIsY\?                     ; jump if else (than y) 
                    lda      -2,x 
                    anda     #%01000000                   ; if MSB -1 is set, than movement as positive (negative - else) 
                    beq      xisnegative\? 
                    inc      Vec_Joy_1_X                  ; store it to our joystick result var 
                    bra      attractDoneHere\? 

xisnegative\? 
                    dec      Vec_Joy_1_X                  ; negative movement, store... 
                    bra      attractDoneHere\?            ; and out 

joyIsY\? 
                    lda      -2,x                         ; was an Y movement, reload data 
                    anda     #%01000000                   ; if MSB -1 is set, than movement as positive (negative - else) 
                    beq      yisnegative\? 
                    inc      Vec_Joy_1_Y                  ; store it to our joystick result var 
                    bra      attractDoneHere\?            ; and out 

yisnegative\? 
                    dec      Vec_Joy_1_Y                  ; negative movement, store... 
                    bra      attractDoneHere\?            ; and out 

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
                    lda      RecalCounterLow 
                    adda     my_random 
                    sta      my_random 
                    bra      attractDoneHere\?            ; if y moved I assume no X move 

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
                    lda      RecalCounterLow 
                    adda     my_random 
                    sta      my_random 
noxmove\? 
attractDoneHere\?: 
                    endm     
;***************************************************************************
DO_SOUND            macro    
                    JSR      sfx_doframe_intern_3 
                    direct   $d0 
; copy all shadows
                    lda      #10                          ; number of regs to copy (+1) 
                    ldx      #Vec_Music_Work              ; music players write here 
                    ldu      #Vec_Snd_Shadow              ; shadow of actual PSG 
next_reg\?: 
                    ldb      a, x 
                    cmpb     a, u 
                    beq      inc_reg\? 
; no put to psg
                    stb      a,u                          ; ensure shadow has copy 
; a = register
; b = value
                    STA      <VIA_port_a                  ;store register select byte 
                    LDA      #$19                         ;sound BDIR on, BC1 on, mux off _ LATCH 
                    STA      <VIA_port_b 
                    LDA      #$01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
                    STA      <VIA_port_b 
                    LDA      <VIA_port_a                  ;read sound chip status (?) 
                    STB      <VIA_port_a                  ;store data byte 
                    LDB      #$11                         ;sound BDIR on, BC1 off, mux off - WRITE 
                    STB      <VIA_port_b 
                    LDB      #$01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
                    STB      <VIA_port_b 
inc_reg\?: 
                    deca     
                    bpl      next_reg\? 
                    ldx      currentYLenCount 
                    leax     -1,x 
                    stx      currentYLenCount 
                    bne      doneSound\? 
                    ldx      nextMusic 
                    stx      currentMusic 
                    JSR      init_ym_sound 
doneSound\?: 
                    endm     
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
PLAY_SFX            macro    sfxPiece 
                    ldx      #sfxPiece 
                    jsr      play_sfx_x 
                    endm     
;***************************************************************************
PLAY_SFX_           macro    sfxPiece 
                    ldx      currentSFX                   ; load current sfx 
                    beq      storeOk\?                    ; if none playing - jump 
                    lda      2,x                          ; load current prio to a 
                    cmpa     sfxPiece+2                   ; compare to prio of new sfx 
                    bgt      no_new\?                     ; if old prio is higher than go out 
storeOk\?: 
                    ldx      #sfxPiece                    ; new sfx is nice 
                    stx      currentSFX                   ; so we store it as current sfx 
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
                    tst      currentSFX 
                    bne      noNew\? 
                                                          ; hey dissi "b reak" 
                    PLAY_SFX  sfxPiece 
noNew\?: 
                    endm     
;***************************************************************************
; reset integrators
RESET_INT           macro    
                    clra     
                    sta      VIA_port_a 
                    lda      #%00000010                   ; integrator reset 
                    sta      VIA_port_b 
                    inc      VIA_port_b 
                    endm     
;***************************************************************************
; divide (unsigned) D by 16 bit in TMP1
; result in B
; SLOW!
MY_DIV_D_BY_TMP1_TO_B  macro  
                    CLR      divide_tmp 
                    tst      tmp1 
                    bne      notZero 
                    tst      tmp1+1 
                    bne      notZero 
                    Bra      divide_by_zero\? 

notZero 
                    DEC      divide_tmp 
                    BRA      divide_next\? 

divide_by_zero1\?: 
                    LDB      divide_tmp 
                    NEGB     
                    BRA      divide_end\? 

divide_next\?: 
                    INC      divide_tmp 
                    SUBD     tmp1 
                    bcc      divide_next\? 
divide_by_zero\?: 
                    LDB      divide_tmp 
divide_end\?: 
                    endm     
;***************************************************************************
;gimickTable:
; db 0 ; y
; db -70 ; x
; db 250 ; length 
; db pacman1a_object
;
;
;gimmickPossible     equ      initMoveTable+2 
;gimmickActive       equ      gimmickPossible+2 
;gimmick_status      EQU      gimmickActive + 1            ; what's the gimmick status? 
;gimmick_object      EQU      gimmick_status + 1           ; pointer to current gimmick object information 
;gimmick_pos         EQU      gimmick_object + 2           ; current position of gimmick 
;gimmick_anim_counter  EQU    gimmick_pos + 2              ; animation counter of gimmick 
;gimmick_speed       EQU      gimmick_anim_counter + 1     ; speed of gimmick 
;gimmick_countdown       EQU      gimmick_speed + 1     ; speed of gimmick 
INIT_GIMICK         macro    
                    ldx      gimmick_pointer 
                    ldx      ,x 
                    ldd      ,x 
                    std      gimmick_pos 
                    ldu      3,x 
                    stu      gimmick_object 
                    lda      4,u 
                    sta      gimmick_anim_counter 
                    lda      2,x 
                    sta      gimmick_countdown 
                    lda      #1 
                    sta      gimmickActive 
                    lda      ,u 
                    sta      gimmick_speed 
                    ldx      gimmick_pointer 
                    leax     2,x 
                    ldu      ,x 
                    bne      noGimickreset 
                    ldx      #gimickTable 
noGimickreset 
                    stx      gimmick_pointer 
                    endm     
DISPLAY_GIMICK      macro    
                    direct   $d0 
                    _ZERO_VECTOR_BEAM                     ; go to 0,0 
                    lda      #$48 
                    jsr      Intensity_a 
;............................................................................
; this is actually the same as the code used in the main sprite loop
; just fitted for gimick
                    MY_GAME_SCALE                         ; scale for game positioning 
                    LDD      gimmick_pos                  ; load position 
                                                          ; move to 
                    STA      <VIA_port_a                  ; Store Y in D/A register 
                    LDA      #$CE                         ; Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ; Enable mux 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_port_a                  ; Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ; enable timer 
; in move stuff, since it
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; IN MOVE GIMICK START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    dec      gimmick_countdown 
                    bne      gstillActive 
                    lda      #0 
                    sta      gimmickActive 
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    STA      VIA_t1_cnt_hi                ; move to time 1 lo, this means scaling 
                    inca     
                    sta      gimmickPossible 
                    bra      outOfGimick                  ; and do the next 

gstillActive 
; in move stuff start
                    LDD      gimmick_pos                  ; load otter position 
                    ADDB     gimmick_speed                ; add the speed 
                    STB      gimmick_pos + 1              ; store the new x position 
                    LDx      gimmick_object               ; load the otter object to U 
                    DEC      gimmick_anim_counter         ; decrease animation counter 
                    BNE      no_anim_change_gimick        ; if zero, we must initialize new animation phase 
                    LDD      7,x                          ; load old sprite offsets 
                    NEGA                                  ; negate them (A) 
                    NEGB                                  ; negate them (B) 
                    ADDA     gimmick_pos                  ; add y position to old sprite offset y 
                    ADDB     gimmick_pos + 1              ; add x position to old sprite offset x 
                    LDu      5,x                          ; load new object definition 
                    ADDA     7,u                          ; add new sprite offset y 
                    ADDB     8,u                          ; add new sprite offset x 
                    STD      gimmick_pos                  ; and store the corrected position 
                    STu      gimmick_object               ; store new object definition to object list 
                    LDA      4,u                          ; load new animation counter start 
                    STA      gimmick_anim_counter         ; and set it in object list 
no_anim_change_gimick: 
                    LDu      1,x                          ; load object vector list to X, 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; IN MOVE OTTER END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    jsr      move_wait_draw_vlc_unloop 
                    lda      #$ce 
                    sta      <VIA_cntl                    ; 22 cycles from switch on ZERO disabled, and BLANK enabled 
                    jsr      calibration 
outOfGimick 
                    lda      #$60 
                    jsr      Intensity_a 
                    endm     
;............................................................................
;COPY_VECROM_TO_RAM  macro    
;                    ldu      #vec4SaveBuffer              ; Source copy the vec4ever switching function into place 
;                    ldx      #v4e_saveBlockStart          ; destination 
;                    lda      #1+(v4e_saveBlockEnd-v4e_saveBlockStart) 
;                    jsr      Move_Mem_a 
;                    endm     
;............................................................................
;............................................................................
DEBUG_PRINT__       macro    
                    pshs     d,y,u,cc,dp 
loopi\? 
                    jsr      do_csa_startup 
                    LDD      #NORMAL_TEXT_SIZE            ; load default text height & width 
                    STD      Vec_Text_HW                  ; poke it to ram location 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                    lda      #60 
                    sta      Vec_Text_Width 
                    lda      #-1 
                    sta      Vec_Text_Height 
                    lda      #80 
                    _SCALE_A  
                    ldu      Vec_Str_Ptr 
                    ldd      #0 
                    jsr      Print_Str_d 
                    JSR      Read_Btns                    ; get button status 
                    CMPA     #$00                         ; is a button pressed? 
                    lBEQ     loopi\?                      ; no, than stay in init_screen_loop 
                    puls     d,y,u,cc,dp 
                    endm     
                    endif    
DEBUG_PRINT         macro    someText 
                    pshs     x 
                    ldx      #someText 
                    stx      Vec_Str_Ptr 
                    jsr      debug_print 
                    puls     x 
                    endm     
