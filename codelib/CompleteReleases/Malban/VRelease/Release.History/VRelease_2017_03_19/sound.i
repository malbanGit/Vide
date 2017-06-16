;***************************************************************************
do_ym_sound2  
                                             ;#isfunction  
                    JSR      sfx_doframe_intern_3 
                    JSR      sfx_doframe_intern_2 
;                    JSR      sfx_doframe_intern_1 
                    direct   $d0 
; copy all shadows
                    lda      #13                          ; number of regs to copy (+1) 
                    ldx      #Vec_Music_Work              ; music players write here 
                    ldu      #Vec_Snd_Shadow              ; shadow of actual PSG 
next_reg_dsy: 
                    ldb      a, x 
                    cmpb     a, u 
                    beq      inc_reg_dsy 
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
inc_reg_dsy: 
                    deca     
                    bpl      next_reg_dsy 

                    ldx      currentYLenCount 
                    leax     -1,x 
                    stx      currentYLenCount 
                    bne      doneSound_2 
                    ldx      nextMusic 
                    stx      currentMusic 
                    JSR      init_ym_sound 
doneSound_2:
                    rts      

;***************************************************************************
; destroys D X U
; play the given SFX, but only if nothing else is played (regardless of prio)
play_sfx_3                                                ;#isfunction  
                    ldu      currentSFX_3                 ; load current sfx 
                    beq      storeO_12k_3                 ; if none playing - jump 
                    lda      2,u                          ; load current prio to a 
                    cmpa     2,x                          ; compare to prio of new sfx 
                    bgt      no_new_12_3                  ; if old prio is higher than go out 
storeO_12k_3: 
                    stx      currentSFX_3                 ; so we store it as current sfx 
                    ldx      ,x                           ; and the actual sfx data store to our sfx player vars 
                    stx      sfx_pointer_3 
                    LDA      #$01                         ; tell the player, that it should play! 
                    STA      sfx_status_3 
no_new_12_3 
                    rts      

;***************************************************************************
play_sfx_2 
                    ldu      currentSFX_2                 ; load current sfx 
                    beq      storeO_12k_2                 ; if none playing - jump 
                    lda      2,u                          ; load current prio to a 
                    cmpa     2,x                          ; compare to prio of new sfx 
                    bgt      no_new_12_2                  ; if old prio is higher than go out 
storeO_12k_2: 
                    stx      currentSFX_2                 ; so we store it as current sfx 
                    ldx      ,x                           ; and the actual sfx data store to our sfx player vars 
                    stx      sfx_pointer_2 
                    LDA      #$01                         ; tell the player, that it should play! 
                    STA      sfx_status_2 
no_new_12_2 
                    rts      

;***************************************************************************
play_sfx_1 
                    ldu      currentSFX_1                 ; load current sfx 
                    beq      storeO_12k_1                 ; if none playing - jump 
                    lda      2,u                          ; load current prio to a 
                    cmpa     2,x                          ; compare to prio of new sfx 
                    bgt      no_new_12_1                  ; if old prio is higher than go out 
storeO_12k_1: 
                    stx      currentSFX_1                 ; so we store it as current sfx 
                    ldx      ,x                           ; and the actual sfx data store to our sfx player vars 
                    stx      sfx_pointer_1 
                    LDA      #$01                         ; tell the player, that it should play! 
                    STA      sfx_status_1 
no_new_12_1 
                    rts      


; ***************** AYFX Structures
; priority the higher the more priority!
; *** AYFX following
Explosion_Sound: 
                    dw       explosion1_data 
                    db       4                            ; priority 2 = low 

SpawnHunter_Sound: 
                    dw       hunterSpawn_data 
                    db       5                            ; priority 2 = low 
DragonFirstHit_Sound:
                    dw       DragonFirstHit_data 
                    db       8                            ; priority 2 = low 

SpawnDragon_Sound:
                    dw       dragon_data 
                    db       7                            ; priority 2 = low 

BomberShot_Sound: 
                    dw       BomberShot_data 
                    db       6                            ; priority 2 = low 
SpawnBomber_Sound: 
                    dw       bomber_data 
                    db       5                            ; priority 2 = low 
SpawnBonus_Sound
                    dw       BonusAppears_data 
                    db       9                            ; priority 2 = low 
SpawnX_Sound: 
                    dw       spawnX_data 
                    db       5                            ; priority 2 = low 

Gotcha_Sound: 
                    dw       gotcha_data 
                    db       127                            ; priority 2 = low 
BonusGot_Sound
                    dw       BonusCollected_data 
                    db       9                            ; priority 2 = low 
phaseChange_Sound
                    dw       phaseChange_data 
                    db       10                            ; priority 2 = low 
DragonFirstHit_data:
 DB $F0, $00, $00, $00, $A0, $20, $00, $AE, $9F, $00
 DB $AE, $1E, $01, $AE, $9D, $01, $AE, $1C, $02, $AE
 DB $9B, $02, $AE, $99, $03, $AE, $18, $04, $AE, $97
 DB $04, $AE, $16, $05, $AE, $95, $05, $AE, $93, $06
 DB $AE, $12, $07, $AE, $91, $07, $AE, $10, $08, $AE
 DB $8F, $08, $AE, $0E, $09, $AE, $0C, $0A, $AE, $8B
 DB $0A, $AE, $0A, $0B, $AE, $89, $0B, $AD, $20, $00
 DB $AD, $1E, $01, $AD, $9D, $01, $AD, $1C, $02, $AD
 DB $9B, $02, $AD, $1A, $03, $AD, $99, $03, $AD, $97
 DB $04, $AD, $16, $05, $AD, $95, $05, $AD, $14, $06
 DB $AD, $93, $06, $AD, $91, $07, $AD, $10, $08, $AD
 DB $8F, $08, $AD, $0E, $09, $AD, $8D, $09, $AD, $0C
 DB $0A, $AD, $0A, $0B, $AD, $89, $0B, $AC, $20, $00
 DB $AC, $9F, $00, $AC, $1E, $01, $AC, $1C, $02, $AC
 DB $9B, $02, $AC, $1A, $03, $AC, $99, $03, $AC, $18
 DB $04, $AC, $16, $05, $AC, $95, $05, $AC, $14, $06
 DB $AC, $93, $06, $AC, $12, $07, $AC, $91, $07, $AC
 DB $8F, $08, $AC, $0E, $09, $AC, $8D, $09, $AC, $0C
 DB $0A, $AC, $8B, $0A, $AC, $89, $0B, $B0, $00, $00
 DB $D0, $20
BomberShot_data:
 DB $6E, $40, $00, $1E, $EF, $00, $06, $00, $A0, $00
 DB $00, $AE, $48, $01, $AE, $72, $01, $AE, $A2, $01
 DB $AE, $D7, $01, $AE, $14, $02, $AE, $59, $02, $AE
 DB $A6, $02, $AB, $00, $01, $AB, $21, $01, $AB, $46
 DB $01, $AB, $70, $01, $AB, $9F, $01, $AB, $D5, $01
 DB $AB, $11, $02, $AA, $B0, $00, $AA, $D5, $00, $AA
 DB $F0, $00, $AA, $0F, $01, $A6, $00, $00, $00, $D0
 DB $20

BonusCollected_data:
 DB $EE, $12, $00, $00, $AE, $0E, $00, $AE, $17, $00
 DB $AE, $11, $00, $AE, $22, $00, $AD, $1E, $00, $AD
 DB $27, $00, $AD, $21, $00, $AD, $23, $00, $AD, $22
 DB $00, $AC, $1E, $00, $AC, $27, $00, $AC, $21, $00
 DB $AC, $23, $00, $AC, $21, $00, $AB, $1E, $00, $AB
 DB $27, $00, $AB, $21, $00, $AB, $23, $00, $AB, $21
 DB $00, $AA, $1E, $00, $AA, $27, $00, $AA, $21, $00
 DB $AA, $23, $00, $AA, $21, $00, $AA, $22, $00, $A9
 DB $27, $00, $A9, $21, $00, $A9, $23, $00, $A9, $21
 DB $00, $A9, $22, $00, $A8, $27, $00, $A8, $21, $00
 DB $A8, $23, $00, $A8, $21, $00, $A8, $22, $00, $A7
 DB $1E, $00, $A7, $21, $00, $A7, $23, $00, $A7, $21
 DB $00, $A7, $22, $00, $A6, $1E, $00, $A6, $21, $00
 DB $A6, $23, $00, $A6, $21, $00, $A6, $22, $00, $A5
 DB $1E, $00, $A5, $21, $00, $D0, $20

BonusAppears_data:
 DB $ED, $7C, $01, $0B, $8D, $8D, $8D, $AD, $40, $01
 DB $8D, $8D, $8D, $AD, $FE, $00, $8D, $8D, $8D, $AD
 DB $D5, $00, $8D, $8D, $8D, $AD, $BE, $00, $8D, $8D
 DB $8D, $AD, $A0, $00, $8D, $8D, $8D, $AD, $7F, $00
 DB $8D, $8D, $8D, $AD, $6A, $00, $8D, $8D, $8D, $D0
 DB $20

bomber_data:
 DB $EF, $AB, $00, $10, $AF, $42, $01, $AF, $D9, $01
 DB $AF, $70, $02, $AF, $AB, $00, $AF, $42, $01, $AF
 DB $D9, $01, $AF, $70, $02, $AF, $07, $03, $AE, $AB
 DB $00, $AE, $42, $01, $AE, $D9, $01, $AD, $70, $02
 DB $AD, $07, $03, $AD, $AB, $00, $AC, $42, $01, $AC
 DB $D9, $01, $AC, $70, $02, $AB, $07, $03, $AB, $AB
 DB $00, $AB, $42, $01, $AA, $D9, $01, $AA, $70, $02
 DB $AA, $07, $03, $A9, $AB, $00, $A9, $42, $01, $A9
 DB $D9, $01, $A8, $70, $02, $A8, $07, $03, $A8, $AB
 DB $00, $A7, $42, $01, $A7, $D9, $01, $A7, $70, $02
 DB $A6, $07, $03, $D0, $20

dragon_data:
 DB $E3, $2A, $00, $00, $A5, $2D, $00, $A9, $32, $00
 DB $AB, $35, $00, $AF, $3C, $00, $AF, $3F, $00, $AF
 DB $47, $00, $AE, $50, $00, $AE, $54, $00, $AD, $5F
 DB $00, $AD, $64, $00, $AD, $71, $00, $AC, $7F, $00
 DB $AC, $86, $00, $AB, $96, $00, $AB, $9F, $00, $AB
 DB $B3, $00, $AA, $BE, $00, $AA, $D5, $00, $AA, $E1
 DB $00, $A9, $EF, $00, $A9, $0C, $01, $A9, $1C, $01
 DB $A8, $2D, $01, $A8, $52, $01, $A8, $66, $01, $A7
 DB $92, $01, $A7, $AA, $01, $A6, $DE, $01, $A6, $FA
 DB $01, $A6, $38, $02, $A5, $5A, $02, $A5, $A4, $02
 DB $A5, $CC, $02, $A4, $24, $03, $A4, $86, $03, $A3
 DB $BC, $03, $A3, $31, $04, $A3, $70, $04, $A2, $B4
 DB $04, $A2, $47, $05, $A1, $98, $05, $A1, $47, $06
 DB $A1, $0C, $07, $91, $91, $91, $91, $91, $91, $D0
 DB $20

hunterSpawn_data:
 DB $E8, $78, $00, $00, $A9, $7A, $00, $A9, $7C, $00
 DB $A9, $7E, $00, $A9, $80, $00, $A9, $82, $00, $A9
 DB $84, $00, $A9, $86, $00, $A9, $88, $00, $A9, $8A
 DB $00, $A9, $8C, $00, $A9, $8E, $00, $A9, $90, $00
 DB $A9, $92, $00, $A9, $94, $00, $A9, $96, $00, $A9
 DB $98, $00, $A9, $9A, $00, $A9, $9C, $00, $A9, $9E
 DB $00, $A9, $A0, $00, $A9, $A2, $00, $A9, $A4, $00
 DB $A9, $A6, $00, $A9, $A8, $00, $A9, $AA, $00, $A9
 DB $AC, $00, $A9, $AE, $00, $A9, $AF, $00, $A8, $B0
 DB $00, $D0, $20
spawnX_data:
 DB $EA, $AB, $00, $00, $AA, $81, $00, $AA, $61, $00
 DB $AA, $49, $00, $AA, $37, $00, $AA, $2A, $00, $AA
 DB $20, $00, $D0, $20

; AYFX - Data 
explosion1_data:
 DB $7D, $00, $00, $1A, $1D, $AE, $00, $06, $3D, $00
 DB $00, $1D, $1D, $1D, $AE, $00, $06, $7D, $00, $00
 DB $00, $1D, $5D, $04, $1D, $5D, $08, $1D, $5D, $0C
 DB $1D, $5D, $10, $1D, $5D, $14, $1D, $5A, $00, $1A
 DB $5A, $04, $1A, $5A, $08, $1A, $5A, $0C, $1A, $5A
 DB $10, $1A, $5A, $14, $1A, $57, $00, $17, $57, $04
 DB $17, $85, $D0, $20

gotcha_data:
 DB $EF, $20, $02, $06, $AF, $A0, $02, $AF, $10, $03
 DB $AF, $70, $03, $AE, $C0, $03, $AE, $30, $04, $8E
 DB $AE, $50, $04, $AE, $60, $04, $AF, $60, $02, $AF
 DB $A0, $02, $AF, $10, $03, $AF, $70, $03, $AF, $C0
 DB $03, $AF, $00, $04, $8F, $AF, $30, $04, $8F, $AF
 DB $50, $04, $8F, $AF, $60, $04, $8F, $AE, $20, $02
 DB $AE, $A0, $02, $AE, $10, $03, $AE, $70, $03, $AD
 DB $C0, $03, $AD, $00, $04, $AD, $00, $03, $AD, $50
 DB $04, $AD, $60, $04, $AE, $60, $02, $AE, $A0, $02
 DB $AE, $10, $03, $AE, $70, $03, $AE, $C0, $03, $AD
 DB $00, $04, $8D, $AD, $30, $04, $8D, $AD, $50, $04
 DB $8D, $AD, $60, $04, $8D, $D0, $20

phaseChange_data:
 DB $E7, $E0, $01, $06, $87, $87, $87, $87, $87, $87
 DB $AA, $2C, $02, $8A, $8A, $8A, $AB, $E0, $01, $8B
 DB $8B, $8B, $AD, $2C, $02, $8D, $8D, $8D, $AE, $E0
 DB $01, $8E, $8E, $8E, $AE, $2C, $02, $8E, $8E, $8E
 DB $AD, $E0, $01, $8D, $8D, $8D, $AC, $2C, $02, $8C
 DB $8C, $8C, $AB, $E0, $01, $8B, $8B, $8B, $AA, $2C
 DB $02, $8A, $8A, $8A, $A9, $E0, $01, $89, $89, $89
 DB $A7, $2C, $02, $87, $87, $87, $D0, $20


inGameMusic1: 
                    dw       inGame_ymData                 ; music to play 
                    dw       inGameMusic1                 ; next music piece 


FIRST7 = $3E
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
;                    ldb      #register 
;                    exg      a,b 
;                    WRITE_PSG  

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
;
; expects nothing
; expect in U start of data
; expects d0 set
;***************************************************************************
init_ym_sound: 
;                    ldu      nextDataPos 
;                    ldb      ,u+ 
;                    stu      nextDataPos 
                    lda      musicOption 
                    beq      playMusicOk 
                    ldx      #0 
                    stx      currentMusic 
                    stx      currentYLenCount 
                    stx      nextMusic 
                    rts      

playMusicOk: 
                    ldx      >currentMusic 
                    beq      no_ym_music 
                    ldu      2,x 
                    stu      nextMusic 
                    ldu      ,x 
                    ldd      -2,u 
                    std      >currentYLenCount 
                    stu      >nextDataPos 
                    stu      >startDataPos 
                    lda      ,u+ 
                    stu      >nextDataPos 
                    ldb      #$8 
                    stb      >currentDataBitPos 
                    sta      >currentDataByte 
                    lda      #FIRST7 
                    STORE_PSG  7 
                    stb      >$c807                       ; ensure difference between shadow and virtual reg, so the new reg 7 gets copied 
no_ym_music: 
emptyStreamInMove: 
                    rts      
;***************************************************************************
; if zero flag is set after macro the bit was 0
; if zero is clear after macro the bit was 1
; sets carry according to next bit
;***************************************************************************
; general get 1 bit version
GET_BIT             macro    
                    local    bitPosOk 
                    dec      currentDataBitPos 
                    bpl      bitPosOk 
; load a new byte
                    ldy      nextDataPos                  ; [6] 
                    ldb      ,y+                          ; [6] 
                    sty      nextDataPos                  ; [6] = 18 
                    stb      currentDataByte 
                    ldb      #$7 
                    stb      currentDataBitPos 
bitPosOk: 
;
; remember we use one bit now!
; is the bit at the current position set?
                    rol      currentDataByte 
                    endm     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_BIT_first       macro    
                    local    bitPosOk 
                    ldb      currentDataBitPos 
                    decb     
                    bpl      bitPosOk 
                    ldy      nextDataPos                  ; [6] 
                    ldb      ,y+                          ; [6] 
                    sty      nextDataPos                  ; [6] = 18 
                    stb      currentDataByte 
                    ldb      #$7 
bitPosOk: 
                    rol      currentDataByte 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_BIT_middle      macro    
                    local    bitPosOk 
                    decb     
                    bpl      bitPosOk 
                    ldy      nextDataPos                  ; [6] 
                    ldb      ,y+                          ; [6] 
                    sty      nextDataPos                  ; [6] = 18 
                    stb      currentDataByte 
                    ldb      #$7 
bitPosOk: 
                    rol      currentDataByte 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_BIT_last        macro    
                    local    bitPosOk 
                    decb     
                    bpl      bitPosOk 
                    ldy      nextDataPos                  ; [6] 
                    ldb      ,y+                          ; [6] 
                    sty      nextDataPos                  ; [6] = 18 
                    stb      currentDataByte 
                    ldb      #$7 
bitPosOk: 
                    stb      currentDataBitPos 
                    rol      currentDataByte 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
decode_ym_1_channel
 ldd #STREAM_PART_ANY_CHANGE
 std inMovePointer
decode_on:
 jsr [inMovePointer]
 ldd inMovePointer
 cmpd #emptyStreamInMove
 bne decode_on
 rts
;***************************************************************************

noChangeAtAllp_f3: 

                    ldd      #emptyStreamInMove 
                    std      inMovePointer 
                    rts      

STREAM_FIRST_THREE_SHORTCUT
                    GET_BIT  
                    bcc      noChangeAtAllp_f3 

                    GET_BIT  
                    lbcc      noVoice0Change1_f3 

                    GET_BIT  
                    lbcc      voice0AmplitudedonePart_f3 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     
                    STORE_PSG  8 
voice0AmplitudedonePart_f3: 
                    ldd      #STREAM_PART_VOICE0_NOISE_TONE; 
                    std      inMovePointer 
                    rts  
noVoice0Change1_f3: 
                    GET_BIT  
                    lbcc     noNoiseData_f3 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     

                    STORE_PSG  6 
noNoiseData_f3:
                    ldd      #STREAM_PART_ENVELOPE 
                    std      inMovePointer 
                    rts      
;***************************************************************************

STREAM_PART_ANY_CHANGE ;1
                    GET_BIT  
                    bcc      noChangeAtAllp 
                    ldd      #STREAM_PART_VOICE0_ANY_CHANGE;2
                    std      inMovePointer 
                    rts      

noChangeAtAllp: 

                    ldd      #emptyStreamInMove 
                    std      inMovePointer 
                    rts      
;***************************************************************************
; voice 0 changes?
STREAM_PART_VOICE0_ANY_CHANGE;2
; check voice 0, if next bit 0, than nothing changed in voice0
                    GET_BIT  
                    bcc      noVoice0Change1 
                    ldd      #STREAM_PART_VOICE0_AMPLITUDE 
                    std      inMovePointer 
                    rts      

noVoice0Change1: 
                    ldd      #STREAM_PART_NOISE 
                    std      inMovePointer 
                    rts   
;***************************************************************************
; voice 0 Amplitude
STREAM_PART_VOICE0_AMPLITUDE ;3
                    GET_BIT  
                    lbcc      voice0AmplitudedonePart 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     
                    STORE_PSG  8 
voice0AmplitudedonePart: 
                    ldd      #STREAM_PART_VOICE0_NOISE_TONE; STREAM_PART_VOICE0_LOW_FREQUENCY ;4
                    std      inMovePointer 
                    rts      
;***************************************************************************

STREAM_PART_VOICE0_NOISE_TONE; x
                    lda      $C807                        ; load reg 7 shadow 
                    GET_BIT  
                    bcc      voice0SetNoNoise 
voice0SetNoise: 
                    anda     #(%11110111)                 ; set bit 3 to 0 
                    bra      voice0NoiseDone 
voice0SetNoNoise: 
                    ora      #(%00001000)                 ; set bit 3 to 1 


voice0NoiseDone: 
                    GET_BIT  
                    bcc     voice0SetNoTone 

voice0SetTone: 
                    anda     #(%11111110)                 ; set bit 0 to 0 
                    bra      voice0ToneDone 

voice0SetNoTone: 
                    ora      #(%00000001)                 ; set bit 0 to 1 
voice0ToneDone: 
 ora #(%00110110); only channel 1 - all other channels are OFF
 STORE_PSG 7
                    ldd      #STREAM_PART_VOICE0_LOW_FREQUENCY ;4
                    std      inMovePointer 
                    rts      

;***************************************************************************
; voice 0 Frequency low
voice0NoLowFreqPartFront: 
                    ldd      #STREAM_PART_VOICE0_HIGH_FREQUENCY;5
                    std      inMovePointer 
                    rts      

STREAM_PART_VOICE0_LOW_FREQUENCY;4
; check voice 0 low frequence, if next bit is one, set it
                    GET_BIT  
                    bcc      voice0NoLowFreqPartFront 
                                                          ; get 8 bits of low freq from stream 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     
                    STORE_PSG  0 
voice0NoLowFreqPart: 
                    ldd      #STREAM_PART_VOICE0_HIGH_FREQUENCY ;5
                    std      inMovePointer 
                    rts      


;***************************************************************************
; voice 0 Frequency high
STREAM_PART_VOICE0_HIGH_FREQUENCY ;5
; check voice 0 high frequency, if next bit is one, set it
                    GET_BIT  
                    bcc      voice0NoHiFreqPart 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     
                    STORE_PSG  1 
voice0NoHiFreqPart: 
                    ldd      #STREAM_PART_NOISE 
                    std      inMovePointer 
                    rts      
;***************************************************************************
STREAM_PART_NOISE ;x
                    GET_BIT  
                    lbcc     noNoiseData 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     

                    STORE_PSG  6 
noNoiseData:
                    ldd      #STREAM_PART_ENVELOPE 
                    std      inMovePointer 
                    rts      

;***************************************************************************
STREAM_PART_ENVELOPE ;x
                    GET_BIT  
                    bcc     noEnvData 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     

                    STORE_PSG  13 
noEnvData:
                    ldd      #STREAM_PART_ENVELOPE_FREQUENCY_HI 
                    std      inMovePointer 
                    rts      
;***************************************************************************
noEnvFreqData:
                    ldd      #emptyStreamInMove 
                    std      inMovePointer 
                    rts      
STREAM_PART_ENVELOPE_FREQUENCY_HI ;x
                    GET_BIT  
                    bcc     noEnvFreqData 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     

                    STORE_PSG  11 
                    ldd      #STREAM_PART_ENVELOPE_FREQUENCY_LO 
                    std      inMovePointer 
                    rts      
;***************************************************************************
STREAM_PART_ENVELOPE_FREQUENCY_LO ;x
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     

                    STORE_PSG  12 

                    ldd      #emptyStreamInMove 
                    std      inMovePointer 
                    rts      
