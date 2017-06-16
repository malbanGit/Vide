; this file is part of Release, written by Malban in 2017
;
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
                    sta      (Vec_Music_Work + register) 
                    endm     
STORE_PSG_b         macro    register 
                    stb      (Vec_Music_Work + register) 
                    endm     
;***************************************************************************
do_ym_sound2                                              ;#isfunction  
                    tst      sfxOption 
                    bne      do_ym_sound2_no_sfx 
                    JSR      sfx_doframe_intern_3 
                    JSR      sfx_doframe_intern_2 
                    JSR      sfx_doframe_intern_1 
                    direct   $d0 
do_ym_sound2_no_sfx 
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
                    tst      halfnoise 
                    beq      no_halfnoise 
                    tst      return_state                 ; only half noise in game 
                    bne      no_halfnoise 
                    tst      musicOption 
                    beq      noCH1TestHalf 
                    cmpa     #8 
                    beq      do_half 
noCH1TestHalf 
                    cmpa     #9 
                    beq      do_half 
no9_s 
                    cmpa     #10 
                    bne      no10_s 
do_half 
                    lsrb     
                    pshs     b 
                    lsrb     
                    addb     ,s+                          ; 3/4 
no10_s 
no_halfnoise 
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
play_sfx_2                                                ;#isfunction  
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
play_sfx_1                                                ;#isfunction  
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
SpawnStar_Sound: 
                    dw       StarAppears_1_data 
                    db       10                           ; priority 2 = low 
BonusGot_Sound 
                    dw       BonusCollected_data 
                    db       9                            ; priority 2 = low 
phaseChange_Sound 
                    dw       phaseChange_data 
                    db       10                           ; priority 2 = low 
explosionStart_Sound 
                    dw       explosionStart_data 
                    db       120                          ; priority 2 = low 
explosion2_Sound 
                    dw       explosion2_data 
                    db       121                          ; priority 2 = low 
explosion3_Sound 
                    dw       explosion3Triller_data 
                    db       122                          ; priority 2 = low 
explosionB_Sound 
                    dw       DockingB_data 
                    db       123                          ; priority 2 = low 
explosionA_Sound 
                    dw       DockingA_data 
                    db       124                          ; priority 2 = low 
explosionFading_Sound 
                    dw       explostion_fading_data 
                    db       125                          ; priority 2 = low 
explosionLast_Sound 
                    dw       last_explosion_data 
                    db       127                          ; priority 2 = low 
StarAppears_1_data: 
                    DB       $ED, $80, $00, $00, $8D, $8D, $AF, $40, $00, $8F 
                    DB       $8F, $AE, $18, $00, $8E, $8E, $AD, $2A, $00, $8D 
                    DB       $8D, $AC, $3A, $00, $8C, $8C, $AB, $70, $00, $8B 
                    DB       $AD, $40, $00, $8D, $8D, $AC, $18, $00, $8C, $8C 
                    DB       $AB, $2A, $00, $8B, $8B, $AA, $3A, $00, $8A, $8A 
                    DB       $AB, $55, $00, $8B, $8B, $AB, $40, $00, $8B, $8B 
                    DB       $AA, $18, $00, $8A, $8A, $A9, $2A, $00, $89, $89 
                    DB       $A8, $3A, $00, $88, $88, $A9, $55, $00, $89, $89 
                    DB       $A9, $40, $00, $89, $89, $A8, $18, $00, $88, $88 
                    DB       $A7, $2A, $00, $87, $87, $A6, $3A, $00, $86, $86 
                    DB       $A7, $55, $00, $87, $87, $A7, $40, $00, $87, $87 
                    DB       $A6, $18, $00, $86, $86, $A5, $2A, $00, $85, $85 
                    DB       $A4, $3A, $00, $84, $84, $A5, $55, $00, $85, $85 
                    DB       $A5, $40, $00, $85, $85, $A3, $18, $00, $83, $83 
                    DB       $A3, $2A, $00, $83, $83, $D0, $20 
last_explosion_data: 
                    DB       $6F, $FD, $09, $0A, $2F, $F8, $03, $2F, $7E, $02 
                    DB       $2F, $FD, $09, $2F, $F8, $03, $2F, $7E, $02, $2F 
                    DB       $FD, $09, $2F, $F8, $03, $2E, $7E, $02, $2E, $FD 
                    DB       $09, $2E, $F8, $03, $2E, $7E, $02, $2E, $FD, $09 
                    DB       $2E, $F8, $03, $2E, $7E, $02, $2E, $FD, $09, $2D 
                    DB       $F8, $03, $2D, $7E, $02, $2D, $FD, $09, $2D, $F8 
                    DB       $03, $2D, $7E, $02, $2D, $FD, $09, $2D, $F8, $03 
                    DB       $2D, $7E, $02, $2C, $FD, $09, $2C, $F8, $03, $2C 
                    DB       $7E, $02, $2C, $FD, $09, $2C, $F8, $03, $2C, $7E 
                    DB       $02, $2C, $FD, $09, $2C, $F8, $03, $2B, $7E, $02 
                    DB       $2B, $FD, $09, $2B, $F8, $03, $2B, $7E, $02, $2B 
                    DB       $FD, $09, $2B, $F8, $03, $2B, $7E, $02, $2B, $FD 
                    DB       $09, $2A, $F8, $03, $2A, $7E, $02, $2A, $FD, $09 
                    DB       $2A, $F8, $03, $2A, $7E, $02, $2A, $FD, $09, $2A 
                    DB       $F8, $03, $2A, $7E, $02, $29, $FD, $09, $29, $F8 
                    DB       $03, $29, $7E, $02, $29, $FD, $09, $29, $F8, $03 
                    DB       $29, $7E, $02, $29, $FD, $09, $29, $F8, $03, $28 
                    DB       $7E, $02, $28, $FD, $09, $28, $F8, $03, $28, $7E 
                    DB       $02, $28, $FD, $09, $28, $F8, $03, $28, $7E, $02 
                    DB       $28, $FD, $09, $27, $F8, $03, $27, $7E, $02, $27 
                    DB       $FD, $09, $27, $F8, $03, $27, $7E, $02, $27, $FD 
                    DB       $09, $27, $F8, $03, $27, $7E, $02, $26, $FD, $09 
                    DB       $26, $F8, $03, $26, $7E, $02, $26, $FD, $09, $26 
                    DB       $F8, $03, $26, $7E, $02, $26, $FD, $09, $26, $F8 
                    DB       $03, $26, $7E, $02, $D0, $20 
explostion_fading_data: 
                    DB       $6F, $FF, $02, $1F, $2F, $80, $01, $2E, $C0, $00 
                    DB       $2E, $60, $00, $2D, $30, $00, $2D, $18, $00, $2C 
                    DB       $0C, $00, $2C, $06, $00, $2B, $03, $00, $2A, $02 
                    DB       $00, $2A, $01, $00, $0A, $2E, $FF, $02, $2E, $80 
                    DB       $01, $2D, $C0, $00, $2D, $60, $00, $2B, $30, $00 
                    DB       $2B, $18, $00, $2A, $0C, $00, $2A, $06, $00, $2A 
                    DB       $03, $00, $29, $02, $00, $29, $01, $00, $09, $2C 
                    DB       $FF, $02, $2C, $80, $01, $2B, $C0, $00, $2B, $60 
                    DB       $00, $2A, $30, $00, $2A, $18, $00, $29, $0C, $00 
                    DB       $29, $06, $00, $28, $03, $00, $27, $02, $00, $27 
                    DB       $01, $00, $07, $2B, $FF, $02, $2B, $80, $01, $2A 
                    DB       $C0, $00, $2A, $60, $00, $28, $30, $00, $28, $18 
                    DB       $00, $27, $0C, $00, $27, $06, $00, $27, $03, $00 
                    DB       $26, $02, $00, $26, $01, $00, $06, $29, $FF, $02 
                    DB       $29, $80, $01, $28, $C0, $00, $28, $60, $00, $27 
                    DB       $30, $00, $27, $18, $00, $26, $0C, $00, $26, $06 
                    DB       $00, $25, $03, $00, $24, $02, $00, $24, $01, $00 
                    DB       $04, $28, $FF, $02, $28, $80, $01, $27, $C0, $00 
                    DB       $27, $60, $00, $25, $30, $00, $25, $18, $00, $24 
                    DB       $0C, $00, $24, $06, $00, $24, $03, $00, $23, $02 
                    DB       $00, $23, $01, $00, $03, $26, $FF, $02, $26, $80 
                    DB       $01, $25, $C0, $00, $25, $60, $00, $24, $30, $00 
                    DB       $24, $18, $00, $23, $0C, $00, $23, $06, $00, $22 
                    DB       $03, $00, $21, $02, $00, $21, $01, $00, $01, $25 
                    DB       $FF, $02, $25, $80, $01, $24, $C0, $00, $24, $60 
                    DB       $00, $22, $30, $00, $22, $18, $00, $21, $0C, $00 
                    DB       $21, $06, $00, $21, $03, $00, $20, $02, $00, $20 
                    DB       $01, $00, $00, $23, $FF, $02, $23, $80, $01, $22 
                    DB       $C0, $00, $22, $60, $00, $21, $30, $00, $21, $18 
                    DB       $00, $20, $0C, $00, $20, $06, $00, $20, $03, $00 
                    DB       $20, $02, $00, $20, $01, $00, $00, $22, $FF, $02 
                    DB       $22, $80, $01, $21, $C0, $00, $21, $60, $00, $D0 
                    DB       $20 
DockingA_data: 
                    DB       $F0, $00, $00, $00, $A0, $20, $00, $AE, $9F, $00 
                    DB       $AE, $1E, $01, $AE, $9D, $01, $AE, $1C, $02, $AE 
                    DB       $9B, $02, $AE, $99, $03, $AE, $18, $04, $AE, $97 
                    DB       $04, $AE, $16, $05, $AE, $95, $05, $AE, $93, $06 
                    DB       $AE, $12, $07, $AE, $91, $07, $AE, $10, $08, $AE 
                    DB       $8F, $08, $AE, $0E, $09, $AE, $0C, $0A, $AE, $8B 
                    DB       $0A, $AE, $0A, $0B, $AE, $89, $0B, $AD, $20, $00 
                    DB       $AD, $1E, $01, $AD, $9D, $01, $AD, $1C, $02, $AD 
                    DB       $9B, $02, $AD, $1A, $03, $AD, $99, $03, $AD, $97 
                    DB       $04, $AD, $16, $05, $AD, $95, $05, $AD, $14, $06 
                    DB       $AD, $93, $06, $AD, $91, $07, $AD, $10, $08, $AD 
                    DB       $8F, $08, $AD, $0E, $09, $AD, $8D, $09, $AD, $0C 
                    DB       $0A, $AD, $0A, $0B, $AD, $89, $0B, $AC, $20, $00 
                    DB       $AC, $9F, $00, $AC, $1E, $01, $AC, $1C, $02, $AC 
                    DB       $9B, $02, $AC, $1A, $03, $AC, $99, $03, $AC, $18 
                    DB       $04, $AC, $16, $05, $AC, $95, $05, $AC, $14, $06 
                    DB       $AC, $93, $06, $AC, $12, $07, $AC, $91, $07, $AC 
                    DB       $8F, $08, $AC, $0E, $09, $AC, $8D, $09, $AC, $0C 
                    DB       $0A, $AC, $8B, $0A, $AC, $89, $0B, $B0, $00, $00 
                    DB       $D0, $20 
DockingB_data: 
                    DB       $F0, $00, $00, $00, $AF, $10, $00, $AF, $0E, $01 
                    DB       $AF, $8D, $01, $AF, $0C, $02, $AF, $8B, $02, $AF 
                    DB       $0A, $03, $AF, $89, $03, $AF, $87, $04, $AF, $06 
                    DB       $05, $AF, $85, $05, $AE, $04, $06, $AE, $83, $06 
                    DB       $AE, $81, $07, $AE, $10, $00, $AE, $8F, $00, $AE 
                    DB       $0E, $01, $AE, $8D, $01, $AE, $8B, $02, $AE, $0A 
                    DB       $03, $AE, $89, $03, $AD, $08, $04, $AD, $87, $04 
                    DB       $AD, $06, $05, $AD, $04, $06, $AD, $83, $06, $AD 
                    DB       $02, $07, $AD, $81, $07, $AD, $10, $00, $AD, $0E 
                    DB       $01, $AD, $8D, $01, $AC, $0C, $02, $AC, $8B, $02 
                    DB       $AC, $0A, $03, $AC, $89, $03, $AC, $87, $04, $AC 
                    DB       $06, $05, $AC, $85, $05, $AC, $04, $06, $AC, $83 
                    DB       $06, $AC, $81, $07, $AB, $10, $00, $AB, $8F, $00 
                    DB       $AB, $0E, $01, $AB, $8D, $01, $AB, $0C, $02, $AB 
                    DB       $0A, $03, $AB, $89, $03, $AB, $08, $04, $AB, $87 
                    DB       $04, $AB, $06, $05, $AA, $04, $06, $AA, $83, $06 
                    DB       $AA, $02, $07, $AA, $81, $07, $AA, $10, $00, $AA 
                    DB       $0E, $01, $AA, $8D, $01, $AA, $0C, $02, $AA, $8B 
                    DB       $02, $AA, $0A, $03, $AA, $89, $03, $A9, $87, $04 
                    DB       $A9, $06, $05, $A9, $85, $05, $A9, $04, $06, $A9 
                    DB       $83, $06, $A9, $81, $07, $A9, $10, $00, $A9, $8F 
                    DB       $00, $A9, $0E, $01, $A9, $8D, $01, $A8, $0C, $02 
                    DB       $A8, $0A, $03, $A8, $89, $03, $A8, $08, $04, $A8 
                    DB       $87, $04, $A8, $06, $05, $A8, $04, $06, $A8, $83 
                    DB       $06, $A8, $02, $07, $A8, $81, $07, $D0, $20 
explosion3Triller_data: 
                    DB       $7E, $00, $00, $1A, $5E, $1E, $10, $5E, $1A, $5E 
                    DB       $1E, $5E, $1A, $5E, $1E, $10, $5E, $1C, $10, $5E 
                    DB       $1A, $10, $5E, $18, $5E, $14, $5E, $10, $5E, $0C 
                    DB       $5E, $08, $5E, $06, $5E, $02, $1E, $AF, $33, $00 
                    DB       $AF, $13, $00, $AF, $77, $00, $AF, $97, $00, $AF 
                    DB       $33, $00, $AF, $13, $00, $AE, $77, $00, $AE, $97 
                    DB       $00, $AE, $33, $00, $AE, $13, $00, $AE, $77, $00 
                    DB       $AE, $97, $00, $AE, $33, $00, $AE, $13, $00, $AC 
                    DB       $77, $00, $AC, $97, $00, $AC, $33, $00, $AC, $2E 
                    DB       $00, $AC, $29, $00, $AC, $24, $00, $AC, $1F, $00 
                    DB       $AC, $1A, $00, $AC, $15, $00, $AC, $10, $00, $AF 
                    DB       $33, $00, $AF, $2D, $00, $AF, $27, $00, $AF, $21 
                    DB       $00, $AF, $1B, $00, $AF, $15, $00, $AF, $0F, $00 
                    DB       $AF, $09, $00, $AE, $77, $00, $AE, $97, $00, $AE 
                    DB       $B7, $00, $AE, $D7, $00, $AE, $F7, $00, $AE, $17 
                    DB       $01, $AE, $37, $01, $AE, $57, $01, $AE, $33, $00 
                    DB       $AE, $2D, $00, $AE, $27, $00, $AE, $21, $00, $AE 
                    DB       $1B, $00, $AE, $15, $00, $AE, $0F, $00, $AE, $09 
                    DB       $00, $AD, $77, $00, $AD, $97, $00, $AD, $B7, $00 
                    DB       $AD, $D7, $00, $AD, $F7, $00, $AD, $17, $01, $AD 
                    DB       $37, $01, $AD, $57, $01, $AC, $33, $00, $AC, $2D 
                    DB       $00, $AC, $27, $00, $AC, $21, $00, $AC, $1B, $00 
                    DB       $AC, $15, $00, $AC, $0F, $00, $AC, $77, $00, $AC 
                    DB       $97, $00, $AC, $B7, $00, $AC, $D7, $00, $AB, $33 
                    DB       $00, $AB, $2D, $00, $AB, $27, $00, $AB, $21, $00 
                    DB       $AA, $1B, $00, $AA, $15, $00, $AA, $0F, $00, $AA 
                    DB       $09, $00, $D0, $20 
explosion2_data: 
                    DB       $6F, $12, $07, $0A, $2F, $CE, $02, $2F, $C4, $01 
                    DB       $2F, $66, $01, $2F, $E2, $00, $2F, $12, $07, $2F 
                    DB       $CE, $02, $2F, $C4, $01, $2F, $66, $01, $2F, $E2 
                    DB       $00, $2F, $12, $07, $2F, $CE, $02, $2F, $C4, $01 
                    DB       $2F, $66, $01, $2F, $E2, $00, $2F, $12, $07, $2F 
                    DB       $CE, $02, $2F, $C4, $01, $2F, $12, $07, $2F, $66 
                    DB       $01, $2F, $CE, $02, $2F, $C4, $01, $2F, $12, $07 
                    DB       $2F, $CE, $02, $0E, $2E, $C4, $01, $2E, $12, $07 
                    DB       $2E, $CE, $02, $2E, $C4, $01, $0D, $2D, $12, $07 
                    DB       $2D, $CE, $02, $2D, $C4, $01, $2C, $12, $07, $0C 
                    DB       $0C, $2C, $CE, $02, $2B, $C4, $01, $2B, $12, $07 
                    DB       $0B, $0B, $2A, $CE, $02, $2A, $C4, $01, $2A, $12 
                    DB       $07, $0A, $2A, $CE, $02, $29, $C4, $01, $29, $12 
                    DB       $07, $29, $CE, $02, $09, $08, $28, $C4, $01, $28 
                    DB       $12, $07, $28, $CE, $02, $07, $07, $27, $C4, $01 
                    DB       $27, $12, $07, $26, $CE, $02, $06, $26, $C4, $01 
                    DB       $26, $12, $07, $26, $CE, $02, $D0, $20 
explosionStart_data: 
                    DB       $6F, $00, $01, $10, $2F, $00, $02, $2F, $00, $03 
                    DB       $2E, $00, $04, $2E, $00, $05, $2E, $00, $06, $2D 
                    DB       $00, $07, $2C, $00, $08, $6F, $00, $06, $1E, $2F 
                    DB       $80, $02, $2F, $00, $03, $2E, $80, $03, $2E, $00 
                    DB       $04, $2E, $80, $04, $2D, $00, $05, $2D, $80, $05 
                    DB       $2F, $00, $03, $0F, $0F, $0F, $0F, $0F, $2F, $40 
                    DB       $03, $0F, $0F, $0F, $0F, $0F, $2E, $80, $03, $0E 
                    DB       $0E, $0E, $0E, $0E, $2E, $C0, $03, $0E, $0E, $0E 
                    DB       $0E, $0E, $2D, $00, $04, $0D, $0D, $0D, $0D, $0D 
                    DB       $2C, $40, $04, $0C, $0C, $0C, $0C, $0C, $2C, $80 
                    DB       $04, $0C, $0C, $0C, $0C, $0C, $2B, $C0, $04, $0B 
                    DB       $0B, $0B, $0B, $0B, $2A, $00, $05, $0A, $0A, $0A 
                    DB       $0A, $0A, $29, $40, $05, $09, $09, $09, $09, $09 
                    DB       $28, $80, $05, $08, $08, $08, $08, $08, $27, $C0 
                    DB       $05, $07, $07, $07, $07, $07, $26, $00, $06, $06 
                    DB       $06, $06, $06, $06, $D0, $20 
DragonFirstHit_data: 
                    DB       $F0, $00, $00, $00, $A0, $20, $00, $AE, $9F, $00 
                    DB       $AE, $1E, $01, $AE, $9D, $01, $AE, $1C, $02, $AE 
                    DB       $9B, $02, $AE, $99, $03, $AE, $18, $04, $AE, $97 
                    DB       $04, $AE, $16, $05, $AE, $95, $05, $AE, $93, $06 
                    DB       $AE, $12, $07, $AE, $91, $07, $AE, $10, $08, $AE 
                    DB       $8F, $08, $AE, $0E, $09, $AE, $0C, $0A, $AE, $8B 
                    DB       $0A, $AE, $0A, $0B, $AE, $89, $0B, $AD, $20, $00 
                    DB       $AD, $1E, $01, $AD, $9D, $01, $AD, $1C, $02, $AD 
                    DB       $9B, $02, $AD, $1A, $03, $AD, $99, $03, $AD, $97 
                    DB       $04, $AD, $16, $05, $AD, $95, $05, $AD, $14, $06 
                    DB       $AD, $93, $06, $AD, $91, $07, $AD, $10, $08, $AD 
                    DB       $8F, $08, $AD, $0E, $09, $AD, $8D, $09, $AD, $0C 
                    DB       $0A, $AD, $0A, $0B, $AD, $89, $0B, $AC, $20, $00 
                    DB       $AC, $9F, $00, $AC, $1E, $01, $AC, $1C, $02, $AC 
                    DB       $9B, $02, $AC, $1A, $03, $AC, $99, $03, $AC, $18 
                    DB       $04, $AC, $16, $05, $AC, $95, $05, $AC, $14, $06 
                    DB       $AC, $93, $06, $AC, $12, $07, $AC, $91, $07, $AC 
                    DB       $8F, $08, $AC, $0E, $09, $AC, $8D, $09, $AC, $0C 
                    DB       $0A, $AC, $8B, $0A, $AC, $89, $0B, $B0, $00, $00 
                    DB       $D0, $20 
BomberShot_data: 
                    DB       $6E, $40, $00, $1E, $EF, $00, $06, $00, $A0, $00 
                    DB       $00, $AE, $48, $01, $AE, $72, $01, $AE, $A2, $01 
                    DB       $AE, $D7, $01, $AE, $14, $02, $AE, $59, $02, $AE 
                    DB       $A6, $02, $AB, $00, $01, $AB, $21, $01, $AB, $46 
                    DB       $01, $AB, $70, $01, $AB, $9F, $01, $AB, $D5, $01 
                    DB       $AB, $11, $02, $AA, $B0, $00, $AA, $D5, $00, $AA 
                    DB       $F0, $00, $AA, $0F, $01, $A6, $00, $00, $00, $D0 
                    DB       $20 
BonusCollected_data: 
                    DB       $EE, $12, $00, $00, $AE, $0E, $00, $AE, $17, $00 
                    DB       $AE, $11, $00, $AE, $22, $00, $AD, $1E, $00, $AD 
                    DB       $27, $00, $AD, $21, $00, $AD, $23, $00, $AD, $22 
                    DB       $00, $AC, $1E, $00, $AC, $27, $00, $AC, $21, $00 
                    DB       $AC, $23, $00, $AC, $21, $00, $AB, $1E, $00, $AB 
                    DB       $27, $00, $AB, $21, $00, $AB, $23, $00, $AB, $21 
                    DB       $00, $AA, $1E, $00, $AA, $27, $00, $AA, $21, $00 
                    DB       $AA, $23, $00, $AA, $21, $00, $AA, $22, $00, $A9 
                    DB       $27, $00, $A9, $21, $00, $A9, $23, $00, $A9, $21 
                    DB       $00, $A9, $22, $00, $A8, $27, $00, $A8, $21, $00 
                    DB       $A8, $23, $00, $A8, $21, $00, $A8, $22, $00, $A7 
                    DB       $1E, $00, $A7, $21, $00, $A7, $23, $00, $A7, $21 
                    DB       $00, $A7, $22, $00, $A6, $1E, $00, $A6, $21, $00 
                    DB       $A6, $23, $00, $A6, $21, $00, $A6, $22, $00, $A5 
                    DB       $1E, $00, $A5, $21, $00, $D0, $20 
BonusAppears_data: 
                    DB       $ED, $7C, $01, $0B, $8D, $8D, $8D, $AD, $40, $01 
                    DB       $8D, $8D, $8D, $AD, $FE, $00, $8D, $8D, $8D, $AD 
                    DB       $D5, $00, $8D, $8D, $8D, $AD, $BE, $00, $8D, $8D 
                    DB       $8D, $AD, $A0, $00, $8D, $8D, $8D, $AD, $7F, $00 
                    DB       $8D, $8D, $8D, $AD, $6A, $00, $8D, $8D, $8D, $D0 
                    DB       $20 
bomber_data: 
                    DB       $EF, $AB, $00, $10, $AF, $42, $01, $AF, $D9, $01 
                    DB       $AF, $70, $02, $AF, $AB, $00, $AF, $42, $01, $AF 
                    DB       $D9, $01, $AF, $70, $02, $AF, $07, $03, $AE, $AB 
                    DB       $00, $AE, $42, $01, $AE, $D9, $01, $AD, $70, $02 
                    DB       $AD, $07, $03, $AD, $AB, $00, $AC, $42, $01, $AC 
                    DB       $D9, $01, $AC, $70, $02, $AB, $07, $03, $AB, $AB 
                    DB       $00, $AB, $42, $01, $AA, $D9, $01, $AA, $70, $02 
                    DB       $AA, $07, $03, $A9, $AB, $00, $A9, $42, $01, $A9 
                    DB       $D9, $01, $A8, $70, $02, $A8, $07, $03, $A8, $AB 
                    DB       $00, $A7, $42, $01, $A7, $D9, $01, $A7, $70, $02 
                    DB       $A6, $07, $03, $D0, $20 
dragon_data: 
                    DB       $E3, $2A, $00, $00, $A5, $2D, $00, $A9, $32, $00 
                    DB       $AB, $35, $00, $AF, $3C, $00, $AF, $3F, $00, $AF 
                    DB       $47, $00, $AE, $50, $00, $AE, $54, $00, $AD, $5F 
                    DB       $00, $AD, $64, $00, $AD, $71, $00, $AC, $7F, $00 
                    DB       $AC, $86, $00, $AB, $96, $00, $AB, $9F, $00, $AB 
                    DB       $B3, $00, $AA, $BE, $00, $AA, $D5, $00, $AA, $E1 
                    DB       $00, $A9, $EF, $00, $A9, $0C, $01, $A9, $1C, $01 
                    DB       $A8, $2D, $01, $A8, $52, $01, $A8, $66, $01, $A7 
                    DB       $92, $01, $A7, $AA, $01, $A6, $DE, $01, $A6, $FA 
                    DB       $01, $A6, $38, $02, $A5, $5A, $02, $A5, $A4, $02 
                    DB       $A5, $CC, $02, $A4, $24, $03, $A4, $86, $03, $A3 
                    DB       $BC, $03, $A3, $31, $04, $A3, $70, $04, $A2, $B4 
                    DB       $04, $A2, $47, $05, $A1, $98, $05, $A1, $47, $06 
                    DB       $A1, $0C, $07, $91, $91, $91, $91, $91, $91, $D0 
                    DB       $20 
hunterSpawn_data: 
                    DB       $E8, $78, $00, $00, $A9, $7A, $00, $A9, $7C, $00 
                    DB       $A9, $7E, $00, $A9, $80, $00, $A9, $82, $00, $A9 
                    DB       $84, $00, $A9, $86, $00, $A9, $88, $00, $A9, $8A 
                    DB       $00, $A9, $8C, $00, $A9, $8E, $00, $A9, $90, $00 
                    DB       $A9, $92, $00, $A9, $94, $00, $A9, $96, $00, $A9 
                    DB       $98, $00, $A9, $9A, $00, $A9, $9C, $00, $A9, $9E 
                    DB       $00, $A9, $A0, $00, $A9, $A2, $00, $A9, $A4, $00 
                    DB       $A9, $A6, $00, $A9, $A8, $00, $A9, $AA, $00, $A9 
                    DB       $AC, $00, $A9, $AE, $00, $A9, $AF, $00, $A8, $B0 
                    DB       $00, $D0, $20 
spawnX_data: 
                    DB       $EA, $AB, $00, $00, $AA, $81, $00, $AA, $61, $00 
                    DB       $AA, $49, $00, $AA, $37, $00, $AA, $2A, $00, $AA 
                    DB       $20, $00, $D0, $20 
explosion1_data: 
                    DB       $7D, $00, $00, $1A, $1D, $AE, $00, $06, $3D, $00 
                    DB       $00, $1D, $1D, $1D, $AE, $00, $06, $7D, $00, $00 
                    DB       $00, $1D, $5D, $04, $1D, $5D, $08, $1D, $5D, $0C 
                    DB       $1D, $5D, $10, $1D, $5D, $14, $1D, $5A, $00, $1A 
                    DB       $5A, $04, $1A, $5A, $08, $1A, $5A, $0C, $1A, $5A 
                    DB       $10, $1A, $5A, $14, $1A, $57, $00, $17, $57, $04 
                    DB       $17, $85, $D0, $20 
phaseChange_data: 
                    DB       $E7, $E0, $01, $06, $87, $87, $87, $87, $87, $87 
                    DB       $AA, $2C, $02, $8A, $8A, $8A, $AB, $E0, $01, $8B 
                    DB       $8B, $8B, $AD, $2C, $02, $8D, $8D, $8D, $AE, $E0 
                    DB       $01, $8E, $8E, $8E, $AE, $2C, $02, $8E, $8E, $8E 
                    DB       $AD, $E0, $01, $8D, $8D, $8D, $AC, $2C, $02, $8C 
                    DB       $8C, $8C, $AB, $E0, $01, $8B, $8B, $8B, $AA, $2C 
                    DB       $02, $8A, $8A, $8A, $A9, $E0, $01, $89, $89, $89 
                    DB       $A7, $2C, $02, $87, $87, $87, $D0, $20 
inGameMusic: 
                    dw       vtkIngameSong                ; music to play 
                    dw       inGameMusic                  ; next music piece 
titleMusic: 
                    dw       vtktitleSong                 ; music to play 
                    dw       titleMusic                   ; next music piece 
highscoreMusic: 
                    dw       vtkHighscoreSong             ; music to play 
                    dw       highscoreMusic               ; next music piece 
gameOverMusic: 
                    dw       gameOverSong                 ; music to play 
                    dw       gameOverMusic                ; next music piece 
vtkIngameSong: 
                    include  "VTK_InGameMusic.asm"
vtktitleSong 
                    include  "VTK_TitleMusicAKS.asm"
vtkHighscoreSong 
                    include  "VTK_HighscoreMusicAKS.asm"
gameOverSong 
                    include  "VTK_GameOverMusikAKS.asm"
