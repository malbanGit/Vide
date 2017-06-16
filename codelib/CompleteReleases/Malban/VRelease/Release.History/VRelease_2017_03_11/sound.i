;***************************************************************************
do_ym_sound2                                              ;#isfunction  
                    JSR      sfx_doframe_intern_3 
                    JSR      sfx_doframe_intern_2 
                    JSR      sfx_doframe_intern_1 
                    direct   $d0 
; copy all shadows
                    lda      #10                          ; number of regs to copy (+1) 
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
                    db       5                            ; priority 2 = low 

SpawnHunter_Sound: 
                    dw       hunterSpawn_data 
                    db       5                            ; priority 2 = low 
SpawnDragon_Sound:
                    dw       dragon_data 
                    db       5                            ; priority 2 = low 

SpawnBomber_Sound: 
                    dw       bomber_data 
                    db       5                            ; priority 2 = low 
SpawnX_Sound: 
                    dw       spawnX_data 
                    db       5                            ; priority 2 = low 

Gotcha_Sound: 
                    dw       gotcha_data 
                    db       127                            ; priority 2 = low 

phaseChange_Sound
                    dw       phaseChange_data 
                    db       10                            ; priority 2 = low 

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