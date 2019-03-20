; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;
HAS_VOICE0          =        1 
HAS_VOICE1          =        1 
HAS_TONE0           =        1 
HAS_TONE1           =        1 
FIRST7              =        $3C 
                    include  "ymStreamedPlayerKarl.i"
                    INCLUDE  "sounds\\KarlLevelDoneTheme14.asm"
                    INCLUDE  "sounds\\KarlStartTheme.asm"
                    INCLUDE  "sounds\\KarlInGamePart1Theme.asm"
                    INCLUDE  "sounds\\KarlInGamePart2Theme.asm"
                    INCLUDE  "sounds\\KarlInGamePart3Theme.asm"
                    include  "sounds\\KarlReachedHomeRestartTheme.asm"
                    include  "sounds\\KarlGameOverTheme14.asm"
                    include  "sounds\\KarlHomeHappyJingle.asm"
; ***************** YM Music Structures
gameStartMusic: 
                    dw       gameStartTheme               ; music to play 
                    dw       inGameMusic1                 ; next music piece 
inGameMusic1: 
                    dw       inGameTheme1                 ; music to play 
                    dw       inGameMusic2                 ; next music piece 
inGameMusic2: 
                    dw       inGameTheme2 
                    dw       inGameMusic3 
inGameMusic3: 
                    dw       inGameTheme3 
                    dw       inGameMusic1 
reachedHomeMusicNormal: 
                    dw       reachedHomeTheme 
                    dw       inGameMusic1                 ; next music piece 
reachedHomeMusicGirl: 
                    dw       reachedHomeTheme 
                    dw       inGameMusic2                 ; next music piece 
reachedHomeMusicFly: 
                    dw       reachedHomeTheme 
                    dw       inGameMusic3                 ; next music piece 
reachedHomeHappyMusic: 
                    dw       reachedHomeHappyTheme 
                    dw       inGameMusic1                 ; next music piece 
levelDoneMusic: 
                    dw       levelDoneTheme 
                    dw       inGameMusic1                 ; next music piece 
gameOverMusic: 
                    dw       gameOverTheme 
                    dw       0                            ; next music piece 
;KarlHomeJumpMusic: 
;                    dw       KarlHomeJumpTheme 
;                    dw       0                            ; next music piece 
; ***************** AYFX Structures
; priority the higher the more priority!
; *** AYFX following
Karl_Jump_Sound: 
                    dw       KarlJump_data 
                    db       5                            ; priority 2 = low 
Karl_DeathLane_Sound: 
                    dw       KarlDeathLane_data 
                    db       10                           ; priority 2 = low 
Karl_DeathWater_Sound: 
                    dw       KarlDeathWater_data 
                    db       10                           ; priority 2 = low 
KarlHomeJump_Sound: 
                    dw       KarlHomeJump_data 
                    db       6                            ; priority 2 = low 
KarlGirlGot_Sound: 
                    dw       KarlGirlGot_data 
                    db       10                           ; priority 2 = low 
KarlSnakeNoise_Sound: 
                    dw       KarlSnakeNoise_data 
                    db       3                            ; priority 2 = low 
KarlTimeOut_Sound: 
                    dw       KarlTimeOut_data 
                    db       11                           ; priority 2 = low 
KarlWaveNoise_Sound: 
                    dw       KarlWaveNoise_data 
                    db       2                            ; priority 2 = low 
;Karl_Live_Got_Sound 
;                    dw       KarlCoinNoise_data 
                    db       12                           ; priority 2 = low 
Karl_NewHigScoreSound 
                    dw       NewHighScoreJingle_data 
                    db       12                           ; priority 2 = low 
KarlTimerBonusSound 
                    dw       KarlTimerBonus_data 
                    db       7                            ; priority 2 = low 
KarlGimmickSound 
                    dw       KarlGimmick_data 
                    db       9                            ; priority 2 = low 


; ***************** AYFX DATA
KarlJump_data: 
                    DB       $E5, $71, $00, $00, $A8, $BE, $00, $A9, $97, $00 
                    DB       $87, $A8, $7F, $00, $A8, $5F, $00, $87, $A8, $71 
                    DB       $00, $88, $85, $85, $85, $81, $D0, $20 
KarlDeathLane_data: 
                    DB       $F0, $00, $00, $00, $AA, $18, $01, $AA, $42, $01 
                    DB       $AA, $6C, $01, $AA, $96, $01, $AA, $C0, $01, $AA 
                    DB       $EA, $01, $AA, $14, $02, $AA, $3E, $02, $AA, $68 
                    DB       $02, $AA, $92, $02, $AA, $BC, $02, $AA, $E6, $02 
                    DB       $AA, $10, $03, $AA, $3A, $03, $AA, $64, $03, $AA 
                    DB       $8E, $03, $AA, $B5, $03, $AA, $DF, $03, $AA, $09 
                    DB       $04, $AA, $33, $04, $AA, $5D, $04, $AA, $87, $04 
                    DB       $AA, $B1, $04, $AA, $DB, $04, $AA, $05, $05, $AA 
                    DB       $2F, $05, $AA, $59, $05, $AA, $83, $05, $AA, $AD 
                    DB       $05, $AA, $D7, $05, $AA, $01, $06, $AA, $2B, $06 
                    DB       $AA, $55, $06, $AA, $7F, $06, $AA, $A9, $06, $AA 
                    DB       $D3, $06, $AA, $FD, $06, $AA, $27, $07, $AA, $51 
                    DB       $07, $AA, $7B, $07, $AA, $A5, $07, $AA, $CF, $07 
                    DB       $AA, $F9, $07, $AA, $23, $08, $AA, $4D, $08, $AA 
                    DB       $77, $08, $AA, $A1, $08, $D0, $20 
KarlDeathWater_data: 
                    DB       $EE, $70, $00, $00, $8E, $80, $80, $80, $80, $AB 
                    DB       $3C, $00, $80, $80, $80, $AA, $E4, $00, $AA, $C8 
                    DB       $00, $AA, $AC, $00, $AA, $90, $00, $A9, $88, $00 
                    DB       $A9, $A4, $00, $A9, $C0, $00, $A9, $DC, $00, $A9 
                    DB       $F8, $00, $A8, $EA, $00, $A8, $CE, $00, $A8, $B2 
                    DB       $00, $A8, $96, $00, $A7, $8A, $00, $A7, $A6, $00 
                    DB       $A7, $C2, $00, $A7, $DE, $00, $A7, $FA, $00, $A6 
                    DB       $EC, $00, $A6, $D0, $00, $A6, $B4, $00, $A6, $98 
                    DB       $00, $A5, $88, $00, $A5, $A4, $00, $A5, $C0, $00 
                    DB       $A5, $DC, $00, $A5, $F8, $00, $A4, $EE, $00, $A4 
                    DB       $D2, $00, $A4, $B6, $00, $A4, $9A, $00, $A3, $84 
                    DB       $00, $A3, $A0, $00, $A3, $BC, $00, $A3, $D8, $00 
                    DB       $A3, $F4, $00, $A2, $F2, $00, $A2, $D6, $00, $A2 
                    DB       $BA, $00, $A2, $9E, $00, $A2, $82, $00, $A1, $9E 
                    DB       $00, $A1, $BA, $00, $A1, $D4, $00, $D0, $20 
KarlHomeJump_data: 
                    DB       $E0, $00, $00, $00, $AD, $50, $00, $A0, $5A, $00 
                    DB       $80, $8D, $A0, $50, $00, $80, $A0, $5A, $00, $80 
                    DB       $80, $8D, $A0, $50, $00, $80, $80, $80, $D0, $20 
KarlGirlGot_data: 
                    DB       $E3, $C5, $01, $00, $A8, $F8, $02, $A8, $D8, $02 
                    DB       $A8, $B0, $02, $A8, $88, $02, $A8, $68, $02, $A8 
                    DB       $C0, $02, $A8, $A0, $02, $A8, $78, $02, $A8, $50 
                    DB       $02, $A8, $B0, $02, $A8, $88, $02, $A8, $68, $02 
                    DB       $A8, $40, $02, $A8, $A0, $02, $A8, $78, $02, $A8 
                    DB       $50, $02, $A8, $30, $02, $A8, $08, $02, $A8, $68 
                    DB       $02, $A8, $40, $02, $A8, $18, $02, $A8, $F8, $01 
                    DB       $A8, $50, $02, $A8, $30, $02, $A8, $08, $02, $A8 
                    DB       $E8, $01, $A8, $40, $02, $A8, $20, $02, $A8, $F8 
                    DB       $01, $A8, $D0, $01, $A8, $B0, $01, $A8, $08, $02 
                    DB       $A8, $E8, $01, $A8, $C0, $01, $A8, $98, $01, $A8 
                    DB       $F8, $01, $A8, $D0, $01, $A8, $B0, $01, $A8, $88 
                    DB       $01, $A8, $60, $01, $A8, $C0, $01, $A8, $98, $01 
                    DB       $A8, $78, $01, $A8, $50, $01, $A8, $B0, $01, $A8 
                    DB       $88, $01, $A8, $60, $01, $A8, $40, $01, $A8, $98 
                    DB       $01, $A8, $78, $01, $A8, $50, $01, $A8, $28, $01 
                    DB       $A8, $08, $01, $A8, $60, $01, $A8, $40, $01, $A8 
                    DB       $18, $01, $A8, $F0, $00, $A8, $50, $01, $A8, $28 
                    DB       $01, $A8, $08, $01, $A8, $E0, $00, $A8, $40, $01 
                    DB       $A8, $18, $01, $A8, $F0, $00, $A8, $D0, $00, $A8 
                    DB       $A8, $00, $A8, $08, $01, $A8, $E0, $00, $A8, $B8 
                    DB       $00, $A8, $98, $00, $A2, $00, $01, $D0, $20 
KarlSnakeNoise_data: 
                    DB       $E4, $80, $00, $00, $A4, $B0, $00, $A4, $F0, $00 
                    DB       $A4, $20, $01, $A4, $60, $01, $A6, $70, $01, $A6 
                    DB       $E0, $00, $A6, $C0, $00, $A6, $A0, $00, $A6, $90 
                    DB       $00, $A6, $70, $00, $A6, $50, $00, $A0, $40, $00 
                    DB       $80, $80, $A4, $70, $00, $A4, $A0, $00, $A4, $E0 
                    DB       $00, $A4, $10, $01, $A4, $50, $01, $A6, $70, $01 
                    DB       $A6, $E0, $00, $A6, $D0, $00, $A6, $B0, $00, $A6 
                    DB       $90, $00, $A6, $70, $00, $A6, $60, $00, $A6, $40 
                    DB       $00, $80, $D0, $20 
KarlTimeOut_data: 
                    DB       $F0, $00, $00, $00, $AD, $3B, $02, $8C, $8A, $89 
                    DB       $AD, $57, $03, $8C, $8A, $89, $AD, $76, $04, $8C 
                    DB       $8A, $89, $AD, $3B, $02, $8C, $8A, $89, $AD, $57 
                    DB       $03, $8C, $8A, $89, $AD, $76, $04, $8C, $8A, $89 
                    DB       $AD, $3B, $02, $8C, $8A, $89, $AD, $57, $03, $8C 
                    DB       $8A, $89, $AD, $76, $04, $8C, $8A, $89, $AD, $3B 
                    DB       $02, $8C, $8A, $89, $AD, $57, $03, $8C, $8A, $89 
                    DB       $AD, $76, $04, $8C, $8A, $89, $87, $86, $84, $83 
                    DB       $81, $D0, $20 
KarlWaveNoise_data: 
                    DB       $70, $18, $00, $00, $10, $14, $10, $10, $14, $14 
                    DB       $10, $10, $15, $15, $10, $10, $15, $15, $10, $10 
                    DB       $16, $16, $10, $10, $16, $16, $10, $10, $17, $17 
                    DB       $10, $10, $17, $17, $10, $10, $16, $16, $10, $10 
                    DB       $16, $16, $10, $10, $15, $15, $10, $10, $15, $14 
                    DB       $10, $10, $14, $14, $10, $10, $14, $10, $10, $13 
                    DB       $13, $10, $10, $13, $12, $10, $10, $12, $12, $10 
                    DB       $10, $12, $11, $10, $10, $11, $11, $10, $D0, $20 


NewHighScoreJingle_data: 
                    DB       $EF, $E0, $00, $00, $8F, $AF, $C0, $00, $8F, $AF 
                    DB       $B0, $00, $AF, $A0, $00, $AF, $90, $00, $8F, $AD 
                    DB       $E0, $00, $8D, $AD, $C0, $00, $8D, $AD, $B0, $00 
                    DB       $AD, $A0, $00, $AD, $90, $00, $8D, $AB, $E0, $00 
                    DB       $8B, $AB, $C0, $00, $8B, $AB, $B0, $00, $AB, $A0 
                    DB       $00, $AB, $90, $00, $8B, $AA, $E0, $00, $8A, $AA 
                    DB       $C0, $00, $8A, $AA, $B0, $00, $AA, $A0, $00, $AA 
                    DB       $90, $00, $8A, $20, $00, $00, $D0, $20 
KarlTimerBonus_data: 
                    DB       $EA, $AB, $00, $00, $EA, $81, $00, $00, $AA, $61 
                    DB       $00, $AA, $49, $00, $AA, $37, $00, $AA, $2A, $00 
                    DB       $AA, $20, $00, $AA, $18, $00, $20, $00, $00, $D0 
                    DB       $20 
KarlGimmick_data: ; 7
 DB $E7, $60, $01, $00, $A7, $50, $01, $A7, $40, $01
 DB $A7, $30, $01, $A7, $20, $01, $A7, $00, $01, $87
 DB $A7, $E0, $00, $87, $A7, $D0, $00, $A7, $C0, $00
 DB $A7, $B0, $00, $A7, $A0, $00, $B7, $00, $00, $97
 DB $D0, $20


