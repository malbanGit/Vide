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
SpawnX_Sound: 
                    dw       spawnX_data 
                    db       5                            ; priority 2 = low 

Gotcha_Sound: 
                    dw       gotcha_data 
                    db       127                            ; priority 2 = low 


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