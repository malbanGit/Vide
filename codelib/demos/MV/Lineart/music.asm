;--- music data [created with Mod2Vectrex v1.06 - 23.06.2009 by Wolf (the@BigBadWolF.de), additions by Nitro/NCE] ---
songLength          equ      $3B 
loopPosition        equ      $08 
pd_dudel: 
                    fdb      partdudel 
                    fdb      init_partdudel 
                    fcb      BANK_DUDEL 
pd_vozlogo: 
                    fdb      partvozlogo 
                    fdb      init_partvozlogo 
                    fcb      BANK_VOZLOGO 
pd_title: 
                    fdb      part_title 
                    fdb      init_part_title 
                    fcb      BANK_NCELOGO 
pd_presentslogo: 
                    fdb      partpresentslogo 
                    fdb      init_partpresentslogo 
                    fcb      BANK_PRESENTS 
pd_hauptdemologo: 
                    fdb      parthauptdemologo 
                    fdb      init_hauptdemologo 
                    fcb      BANK_HAUPTDEMO 
pd_march: 
                    fdb      part_march 
                    fdb      init_march 
                    fcb      BANK_MARCH 
pd_bnc: 
                    fdb      part_bnc 
                    fdb      init_bnc 
                    fcb      BANK_BOUNCE 
pd_teapot: 
                    fdb      partteapotlogo 
                    fdb      init_partteapotlogo 
                    fcb      BANK_TEAPOT 
pd_teapotB: 
                    fdb      partteapotBlogo 
                    fdb      init_partteapotBlogo 
                    fcb      BANK_TEAPOTB 
pd_twister: 
                    fdb      parttwister 
                    fdb      init_parttwister 
                    fcb      BANK_TWISTER 
pd_twister2: 
                    fdb      parttwister 
                    fdb      init_parttwister2 
                    fcb      BANK_TWISTER 
pd_twister3: 
                    fdb      parttwister3 
                    fdb      init_parttwister2 
                    fcb      BANK_TWISTER 
pd_disco: 
                    fdb      partdiscostulogo 
                    fdb      init_partdiscostulogo 
                    fcb      BANK_DISCO 
pd_ekg: 
                    fdb      partekglogo 
                    fdb      init_partekglogo 
                    fcb      BANK_EKG 
pd_auge: 
                    fdb      partaugelogo 
                    fdb      init_partaugelogo 
                    fcb      BANK_AUGE 
pd_bruce: 
                    fdb      partbrucelogo 
                    fdb      init_partbrucelogo 
                    fcb      BANK_BRUCE 
pd_welt: 
                    fdb      partweltkugellogo 
                    fdb      init_partweltkugellogo 
                    fcb      BANK_WELT 
pd_greet: 
                    fdb      partgreetingslogo 
                    fdb      init_partgreetingslogo 
                    fcb      BANK_GREETINGS 
pd_credits: 
                    fdb      partcreditslogo 
                    fdb      init_partcreditslogo 
                    fcb      BANK_CREDITS 
pd_battle: 
                    fdb      partbattle 
                    fdb      init_partbattle 
                    fcb      BANK_BATTLE 
pd_runner: 
                    fdb      partrunner 
                    fdb      init_partrunner 
                    fcb      BANK_ROADRUNNER 
pd_runner2: 
                    fdb      partrunner2 
                    fdb      init_partrunner2 
                    fcb      BANK_ROADRUNNER 
adsr:
;	fcb	$ff,$ff,$ff,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	fcb	$ff,$ed,$cb,$a9,$87,$65,$43,$21,$00,$00,$00,$00,$00,$00,$00,$00
	fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;
;	fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;	fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;	fcb	$ff,$ff,$33,$44,$55,$66,$77,$88,$99,$aa,$bb,$cc,$dd,$ee,$ff,$ff

;	fcb	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

;	fcb	$cc,$ff,$ff,$cc,$44,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;	fcb	$cc,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ee,$cc,$aa,$88,$66,$44,$22,$00

;	fcb	$44,$cc,$ff,$ff,$ff,$ee,$cc,$aa,$cc,$aa,$88,$66,$88,$66,$44,$22
;	fcb	$44,$cc,$ff,$ff,$ff,$ff,$ff,$ff,$ee,$cc,$aa,$88,$66,$44,$22,$00

twang:
	fcb	$ff,$ff,$00,$00,$00,$00,$00,$00
;;;;;;;;;;   Pattern  ; Part
script: 
                    fdb      pattern1F, pd_vozlogo 
                    fdb      pattern1C, pd_vozlogo 
                    fdb      pattern1C, pd_vozlogo 
                    fdb      pattern1A, pd_title 
                    fdb      pattern1A, pd_title 
                    fdb      pattern17, pd_presentslogo 
                    fdb      pattern17, pd_hauptdemologo 
                    fdb      pattern1D, pd_hauptdemologo 
                    fdb      pattern1D, pd_hauptdemologo 
                    fdb      pattern07, pd_march 
                    fdb      pattern08, pd_march 
                    fdb      pattern07, pd_march 
                    fdb      pattern09, pd_march 
                    fdb      pattern0A, pd_bnc 
                    fdb      pattern04, pd_bnc 
                    fdb      pattern0A, pd_bnc 
                    fdb      pattern1B, pd_bnc 
                    fdb      pattern18, pd_teapot 
                    fdb      pattern19, pd_teapot 
                    fdb      pattern18, pd_teapotB 
                    fdb      pattern19, pd_teapotB 
                    fdb      pattern00, pd_teapot 
                    fdb      pattern01, pd_teapot 
                    fdb      pattern02, pd_twister 
                    fdb      pattern03, pd_twister 
                    fdb      pattern04, pd_twister2 
                    fdb      pattern04, pd_twister2 
                    fdb      pattern05, pd_twister2 
                    fdb      pattern06, pd_twister2 
                    fdb      pattern18, pd_twister3 
                    fdb      pattern19, pd_twister3 
                    fdb      pattern04, pd_twister3 
                    fdb      pattern1B, pd_twister3 
                    fdb      pattern20, pd_dudel 
                    fdb      pattern20, pd_dudel 
                    fdb      pattern20, pd_dudel 
                    fdb      pattern20, pd_bruce 
                    fdb      pattern21, pd_bruce 
                    fdb      pattern21, pd_ekg 
                    fdb      pattern21, pd_ekg 
                    fdb      pattern22, pd_ekg 
                    fdb      pattern0B, pd_welt 
                    fdb      pattern0C, pd_welt 
                    fdb      pattern0D, pd_welt 
                    fdb      pattern0E, pd_welt 
                    fdb      pattern0F, pd_greet 
                    fdb      pattern10, pd_greet 
                    fdb      pattern11, pd_greet 
                    fdb      pattern12, pd_greet 
                    fdb      pattern13, pd_greet 
                    fdb      pattern14, pd_greet 
                    fdb      pattern15, pd_battle 
                    fdb      pattern16, pd_battle 
                    fdb      pattern0F, pd_battle 
                    fdb      pattern0F, pd_credits 
                    fdb      pattern0F, pd_credits 
                    fdb      pattern0F, pd_credits 
                    fdb      pattern0F, pd_runner 
                    fdb      pattern1E, pd_runner2 
pattern00: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $A2, $0C, $02           ; $00 
                    fcb      $9D, $0F, $02                ; $01 
                    fcb      $80, $A4, $13, $02           ; $02 
                    fcb      $1F, $02                     ; $03 
                    fcb      $8C, $A4, $0C, $02           ; $04 
                    fcb      $9F, $0F, $02                ; $05 
                    fcb      $80, $A4, $13, $02           ; $06 
                    fcb      $1F, $02                     ; $07 
                    fcb      $C1, $80, $0C, $02           ; $08 
                    fcb      $9F, $0F, $02                ; $09 
                    fcb      $80, $80, $13, $02           ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $8C, $80, $0C, $02           ; $0C 
                    fcb      $0F, $02                     ; $0D 
                    fcb      $80, $80, $13, $02           ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $8C, $A2, $0C, $02           ; $10 
                    fcb      $9D, $0F, $02                ; $11 
                    fcb      $80, $A2, $13, $02           ; $12 
                    fcb      $1D, $02                     ; $13 
                    fcb      $8C, $80, $18, $02           ; $14 
                    fcb      $80, $0C, $02                ; $15 
                    fcb      $80, $80, $18, $02           ; $16 
                    fcb      $80, $0C, $02                ; $17 
                    fcb      $C1, $9F, $0C, $02           ; $18 
                    fcb      $98, $0F, $02                ; $19 
                    fcb      $80, $9F, $13, $02           ; $1A 
                    fcb      $18, $02                     ; $1B 
                    fcb      $8C, $A2, $0C, $02           ; $1C 
                    fcb      $9D, $0F, $02                ; $1D 
                    fcb      $80, $A2, $13, $02           ; $1E 
                    fcb      $1D, $02                     ; $1F 
                    fcb      $EF, $80, $1B, $02           ; $20 
                    fcb      $80, $0F, $02                ; $21 
                    fcb      $80, $80, $1B, $02           ; $22 
                    fcb      $80, $0F, $02                ; $23 
                    fcb      $8C, $A4, $0C, $02           ; $24 
                    fcb      $9F, $0F, $02                ; $25 
                    fcb      $80, $A4, $13, $02           ; $26 
                    fcb      $1F, $02                     ; $27 
                    fcb      $C1, $A4, $0C, $02           ; $28 
                    fcb      $9F, $0F, $02                ; $29 
                    fcb      $80, $A4, $13, $02           ; $2A 
                    fcb      $1F, $02                     ; $2B 
                    fcb      $8C, $A4, $1D, $02           ; $2C 
                    fcb      $9F, $11, $02                ; $2D 
                    fcb      $80, $A4, $1D, $02           ; $2E 
                    fcb      $9F, $11, $02                ; $2F 
                    fcb      $8C, $A4, $0C, $02           ; $30 
                    fcb      $9F, $0F, $02                ; $31 
                    fcb      $80, $A4, $13, $02           ; $32 
                    fcb      $1F, $02                     ; $33 
                    fcb      $8C, $80, $1B, $02           ; $34 
                    fcb      $80, $0F, $02                ; $35 
                    fcb      $80, $80, $1B, $02           ; $36 
                    fcb      $80, $0F, $02                ; $37 
                    fcb      $C1, $80, $0C, $02           ; $38 
                    fcb      $80, $0F, $02                ; $39 
                    fcb      $80, $80, $13, $02           ; $3A 
                    fcb      $00, $02                     ; $3B 
                    fcb      $8C, $80, $18, $02           ; $3C 
                    fcb      $80, $0C, $02                ; $3D 
                    fcb      $80, $80, $18, $02           ; $3E 
                    fcb      $80, $0C, $02                ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern01: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $A6, $0C, $02           ; $00 
                    fcb      $A7, $0F, $02                ; $01 
                    fcb      $80, $A2, $13, $02           ; $02 
                    fcb      $00, $02                     ; $03 
                    fcb      $8C, $80, $0C, $02           ; $04 
                    fcb      $80, $0F, $02                ; $05 
                    fcb      $80, $80, $13, $02           ; $06 
                    fcb      $00, $02                     ; $07 
                    fcb      $C1, $A6, $0C, $02           ; $08 
                    fcb      $A7, $0F, $02                ; $09 
                    fcb      $80, $A2, $13, $02           ; $0A 
                    fcb      $00, $02                     ; $0B 
                    fcb      $8C, $80, $0C, $02           ; $0C 
                    fcb      $80, $0F, $02                ; $0D 
                    fcb      $80, $80, $13, $02           ; $0E 
                    fcb      $00, $02                     ; $0F 
                    fcb      $8C, $A6, $0C, $02           ; $10 
                    fcb      $A7, $0F, $02                ; $11 
                    fcb      $80, $A6, $13, $02           ; $12 
                    fcb      $00, $02                     ; $13 
                    fcb      $8C, $A6, $18, $02           ; $14 
                    fcb      $A7, $0C, $02                ; $15 
                    fcb      $80, $A6, $18, $02           ; $16 
                    fcb      $A7, $0C, $02                ; $17 
                    fcb      $C1, $A6, $0C, $02           ; $18 
                    fcb      $A7, $0F, $02                ; $19 
                    fcb      $80, $A6, $13, $02           ; $1A 
                    fcb      $27, $02                     ; $1B 
                    fcb      $8C, $A6, $0C, $02           ; $1C 
                    fcb      $A7, $0F, $02                ; $1D 
                    fcb      $80, $A9, $13, $02           ; $1E 
                    fcb      $29, $02                     ; $1F 
                    fcb      $EF, $AB, $1D, $02           ; $20 
                    fcb      $A6, $11, $02                ; $21 
                    fcb      $80, $AB, $1D, $02           ; $22 
                    fcb      $A6, $11, $02                ; $23 
                    fcb      $8C, $AB, $0C, $02           ; $24 
                    fcb      $A6, $0F, $02                ; $25 
                    fcb      $80, $A9, $13, $02           ; $26 
                    fcb      $24, $02                     ; $27 
                    fcb      $C1, $9F, $0C, $02           ; $28 
                    fcb      $80, $0F, $02                ; $29 
                    fcb      $80, $80, $13, $02           ; $2A 
                    fcb      $00, $02                     ; $2B 
                    fcb      $8C, $A7, $1B, $02           ; $2C 
                    fcb      $A7, $0F, $02                ; $2D 
                    fcb      $80, $A7, $1B, $02           ; $2E 
                    fcb      $A7, $0F, $02                ; $2F 
                    fcb      $8C, $A9, $0C, $02           ; $30 
                    fcb      $A4, $0F, $02                ; $31 
                    fcb      $80, $A9, $13, $02           ; $32 
                    fcb      $24, $02                     ; $33 
                    fcb      $8C, $A9, $1A, $02           ; $34 
                    fcb      $A4, $0E, $02                ; $35 
                    fcb      $80, $A7, $1A, $02           ; $36 
                    fcb      $A2, $0E, $02                ; $37 
                    fcb      $C1, $A7, $0C, $02           ; $38 
                    fcb      $A2, $0F, $02                ; $39 
                    fcb      $80, $A4, $13, $02           ; $3A 
                    fcb      $1F, $02                     ; $3B 
                    fcb      $8C, $A4, $18, $02           ; $3C 
                    fcb      $9F, $0C, $02                ; $3D 
                    fcb      $80, $A4, $18, $02           ; $3E 
                    fcb      $9F, $0C, $02                ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern02: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $A5, $07, $02           ; $00 
                    fcb      $A0, $0A, $02                ; $01 
                    fcb      $86, $A5, $0D, $02           ; $02 
                    fcb      $20, $02                     ; $03 
                    fcb      $92, $A5, $07, $02           ; $04 
                    fcb      $A0, $0A, $02                ; $05 
                    fcb      $86, $A5, $0D, $02           ; $06 
                    fcb      $20, $02                     ; $07 
                    fcb      $C1, $A5, $07, $02           ; $08 
                    fcb      $A0, $0A, $02                ; $09 
                    fcb      $86, $86, $0D, $02           ; $0A 
                    fcb      $1E, $02                     ; $0B 
                    fcb      $92, $A4, $07, $02           ; $0C 
                    fcb      $9F, $0A, $02                ; $0D 
                    fcb      $86, $A4, $0D, $02           ; $0E 
                    fcb      $1F, $02                     ; $0F 
                    fcb      $92, $A4, $07, $02           ; $10 
                    fcb      $9F, $0A, $02                ; $11 
                    fcb      $86, $86, $0D, $02           ; $12 
                    fcb      $06, $02                     ; $13 
                    fcb      $92, $A2, $16, $02           ; $14 
                    fcb      $1D, $02                     ; $15 
                    fcb      $86, $A2, $16, $02           ; $16 
                    fcb      $1D, $02                     ; $17 
                    fcb      $C1, $A4, $07, $02           ; $18 
                    fcb      $9F, $0A, $02                ; $19 
                    fcb      $86, $A4, $0D, $02           ; $1A 
                    fcb      $1F, $02                     ; $1B 
                    fcb      $92, $A7, $07, $02           ; $1C 
                    fcb      $A2, $0A, $02                ; $1D 
                    fcb      $86, $A7, $0D, $02           ; $1E 
                    fcb      $22, $02                     ; $1F 
                    fcb      $EF, $A5, $19, $02           ; $20 
                    fcb      $20, $02                     ; $21 
                    fcb      $86, $86, $19, $02           ; $22 
                    fcb      $06, $02                     ; $23 
                    fcb      $92, $86, $07, $02           ; $24 
                    fcb      $86, $0A, $02                ; $25 
                    fcb      $86, $A5, $0D, $02           ; $26 
                    fcb      $20, $02                     ; $27 
                    fcb      $C1, $86, $07, $02           ; $28 
                    fcb      $86, $0A, $02                ; $29 
                    fcb      $86, $86, $0D, $02           ; $2A 
                    fcb      $06, $02                     ; $2B 
                    fcb      $92, $A5, $19, $02           ; $2C 
                    fcb      $20, $02                     ; $2D 
                    fcb      $86, $86, $19, $02           ; $2E 
                    fcb      $06, $02                     ; $2F 
                    fcb      $92, $A4, $07, $02           ; $30 
                    fcb      $9F, $0A, $02                ; $31 
                    fcb      $86, $86, $0D, $02           ; $32 
                    fcb      $06, $02                     ; $33 
                    fcb      $92, $86, $18, $02           ; $34 
                    fcb      $06, $02                     ; $35 
                    fcb      $86, $A4, $18, $02           ; $36 
                    fcb      $1F, $02                     ; $37 
                    fcb      $C1, $86, $07, $02           ; $38 
                    fcb      $86, $0A, $02                ; $39 
                    fcb      $86, $86, $0D, $02           ; $3A 
                    fcb      $06, $02                     ; $3B 
                    fcb      $92, $A2, $16, $02           ; $3C 
                    fcb      $1D, $02                     ; $3D 
                    fcb      $86, $86, $16, $02           ; $3E 
                    fcb      $06, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern03: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $A2, $07, $02           ; $00 
                    fcb      $9D, $0B, $02                ; $01 
                    fcb      $87, $87, $0E, $02           ; $02 
                    fcb      $07, $02                     ; $03 
                    fcb      $93, $87, $07, $02           ; $04 
                    fcb      $87, $0B, $02                ; $05 
                    fcb      $87, $87, $0E, $02           ; $06 
                    fcb      $07, $02                     ; $07 
                    fcb      $C1, $A2, $07, $02           ; $08 
                    fcb      $9D, $0B, $02                ; $09 
                    fcb      $87, $87, $0E, $02           ; $0A 
                    fcb      $07, $02                     ; $0B 
                    fcb      $93, $87, $07, $02           ; $0C 
                    fcb      $87, $0B, $02                ; $0D 
                    fcb      $87, $9F, $0E, $02           ; $0E 
                    fcb      $1A, $02                     ; $0F 
                    fcb      $93, $87, $07, $02           ; $10 
                    fcb      $87, $0B, $02                ; $11 
                    fcb      $87, $87, $0E, $02           ; $12 
                    fcb      $07, $02                     ; $13 
                    fcb      $93, $9F, $16, $02           ; $14 
                    fcb      $1A, $02                     ; $15 
                    fcb      $87, $87, $16, $02           ; $16 
                    fcb      $07, $02                     ; $17 
                    fcb      $C1, $87, $07, $02           ; $18 
                    fcb      $87, $0B, $02                ; $19 
                    fcb      $87, $9F, $0E, $02           ; $1A 
                    fcb      $1A, $02                     ; $1B 
                    fcb      $93, $87, $07, $02           ; $1C 
                    fcb      $87, $0B, $02                ; $1D 
                    fcb      $87, $87, $0E, $02           ; $1E 
                    fcb      $07, $02                     ; $1F 
                    fcb      $EF, $9F, $19, $02           ; $20 
                    fcb      $1A, $02                     ; $21 
                    fcb      $87, $87, $19, $02           ; $22 
                    fcb      $07, $02                     ; $23 
                    fcb      $93, $87, $07, $02           ; $24 
                    fcb      $87, $0B, $02                ; $25 
                    fcb      $87, $87, $0E, $02           ; $26 
                    fcb      $07, $02                     ; $27 
                    fcb      $C1, $87, $07, $02           ; $28 
                    fcb      $87, $0B, $02                ; $29 
                    fcb      $87, $87, $0E, $02           ; $2A 
                    fcb      $07, $02                     ; $2B 
                    fcb      $93, $87, $19, $02           ; $2C 
                    fcb      $07, $02                     ; $2D 
                    fcb      $87, $87, $19, $02           ; $2E 
                    fcb      $07, $02                     ; $2F 
                    fcb      $93, $87, $07, $02           ; $30 
                    fcb      $87, $0B, $02                ; $31 
                    fcb      $87, $87, $0E, $02           ; $32 
                    fcb      $07, $02                     ; $33 
                    fcb      $93, $87, $18, $02           ; $34 
                    fcb      $07, $02                     ; $35 
                    fcb      $87, $87, $18, $02           ; $36 
                    fcb      $07, $02                     ; $37 
                    fcb      $C1, $87, $07, $02           ; $38 
                    fcb      $87, $0B, $02                ; $39 
                    fcb      $87, $87, $0E, $02           ; $3A 
                    fcb      $07, $02                     ; $3B 
                    fcb      $93, $87, $18, $02           ; $3C 
                    fcb      $07, $02                     ; $3D 
                    fcb      $87, $87, $18, $02           ; $3E 
                    fcb      $07, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern04: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $A4, $24, $02           ; $00 
                    fcb      $A7, $24, $02                ; $01 
                    fcb      $80, $AB, $00, $02           ; $02 
                    fcb      $80, $00, $02                ; $03 
                    fcb      $8C, $A4, $24, $02           ; $04 
                    fcb      $A7, $24, $02                ; $05 
                    fcb      $C1, $AB, $00, $02           ; $06 
                    fcb      $8C, $00, $02                ; $07 
                    fcb      $FF, $98, $00, $02           ; $08 
                    fcb      $98, $00, $02                ; $09 
                    fcb      $80, $8C, $00, $02           ; $0A 
                    fcb      $8C, $00, $02                ; $0B 
                    fcb      $FF, $98, $1F, $02           ; $0C 
                    fcb      $98, $1F, $02                ; $0D 
                    fcb      $C1, $8C, $00, $02           ; $0E 
                    fcb      $8C, $00, $02                ; $0F 
                    fcb      $EF, $98, $1F, $02           ; $10 
                    fcb      $98, $1F, $02                ; $11 
                    fcb      $80, $8C, $00, $02           ; $12 
                    fcb      $8C, $00, $02                ; $13 
                    fcb      $FF, $98, $00, $02           ; $14 
                    fcb      $98, $00, $02                ; $15 
                    fcb      $C1, $8C, $00, $02           ; $16 
                    fcb      $8C, $00, $02                ; $17 
                    fcb      $FF, $9A, $22, $02           ; $18 
                    fcb      $9A, $22, $02                ; $19 
                    fcb      $80, $8E, $00, $02           ; $1A 
                    fcb      $8E, $00, $02                ; $1B 
                    fcb      $8C, $9A, $22, $02           ; $1C 
                    fcb      $9A, $22, $02                ; $1D 
                    fcb      $C1, $8E, $00, $02           ; $1E 
                    fcb      $8E, $00, $02                ; $1F 
                    fcb      $FF, $9D, $00, $02           ; $20 
                    fcb      $9D, $00, $02                ; $21 
                    fcb      $80, $91, $00, $02           ; $22 
                    fcb      $91, $00, $02                ; $23 
                    fcb      $80, $9B, $1D, $02           ; $24 
                    fcb      $9B, $1D, $02                ; $25 
                    fcb      $C1, $8F, $00, $02           ; $26 
                    fcb      $8F, $00, $02                ; $27 
                    fcb      $FF, $9B, $1D, $02           ; $28 
                    fcb      $9B, $1D, $02                ; $29 
                    fcb      $80, $8F, $00, $02           ; $2A 
                    fcb      $8F, $00, $02                ; $2B 
                    fcb      $80, $9A, $00, $02           ; $2C 
                    fcb      $9A, $00, $02                ; $2D 
                    fcb      $C1, $8E, $00, $02           ; $2E 
                    fcb      $8E, $00, $02                ; $2F 
                    fcb      $EF, $A2, $1B, $02           ; $30 
                    fcb      $A7, $1B, $02                ; $31 
                    fcb      $80, $A9, $00, $02           ; $32 
                    fcb      $80, $00, $02                ; $33 
                    fcb      $80, $A2, $1B, $02           ; $34 
                    fcb      $A7, $1B, $02                ; $35 
                    fcb      $C1, $A9, $00, $02           ; $36 
                    fcb      $80, $00, $02                ; $37 
                    fcb      $FF, $83, $18, $02           ; $38 
                    fcb      $83, $18, $02                ; $39 
                    fcb      $80, $85, $00, $02           ; $3A 
                    fcb      $85, $00, $02                ; $3B 
                    fcb      $FF, $87, $00, $02           ; $3C 
                    fcb      $87, $00, $02                ; $3D 
                    fcb      $C1, $8A, $00, $02           ; $3E 
                    fcb      $8A, $00, $02                ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern05: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $A4, $24, $02           ; $00 
                    fcb      $A7, $24, $02                ; $01 
                    fcb      $86, $AB, $06, $02           ; $02 
                    fcb      $80, $06, $02                ; $03 
                    fcb      $92, $A4, $24, $02           ; $04 
                    fcb      $A7, $24, $02                ; $05 
                    fcb      $C1, $AB, $06, $02           ; $06 
                    fcb      $8C, $06, $02                ; $07 
                    fcb      $FF, $98, $06, $02           ; $08 
                    fcb      $98, $06, $02                ; $09 
                    fcb      $86, $8C, $06, $02           ; $0A 
                    fcb      $8C, $06, $02                ; $0B 
                    fcb      $FF, $98, $1F, $02           ; $0C 
                    fcb      $98, $1F, $02                ; $0D 
                    fcb      $C1, $8C, $06, $02           ; $0E 
                    fcb      $8C, $06, $02                ; $0F 
                    fcb      $EF, $98, $1F, $02           ; $10 
                    fcb      $98, $1F, $02                ; $11 
                    fcb      $86, $8C, $06, $02           ; $12 
                    fcb      $8C, $06, $02                ; $13 
                    fcb      $FF, $98, $06, $02           ; $14 
                    fcb      $98, $06, $02                ; $15 
                    fcb      $C1, $8C, $06, $02           ; $16 
                    fcb      $8C, $06, $02                ; $17 
                    fcb      $FF, $9A, $22, $02           ; $18 
                    fcb      $9A, $22, $02                ; $19 
                    fcb      $86, $8E, $06, $02           ; $1A 
                    fcb      $8E, $06, $02                ; $1B 
                    fcb      $92, $9A, $22, $02           ; $1C 
                    fcb      $9A, $22, $02                ; $1D 
                    fcb      $C1, $8E, $06, $02           ; $1E 
                    fcb      $8E, $06, $02                ; $1F 
                    fcb      $FF, $9D, $06, $02           ; $20 
                    fcb      $9D, $06, $02                ; $21 
                    fcb      $86, $91, $06, $02           ; $22 
                    fcb      $91, $06, $02                ; $23 
                    fcb      $86, $9B, $1D, $02           ; $24 
                    fcb      $9B, $1D, $02                ; $25 
                    fcb      $C1, $8F, $06, $02           ; $26 
                    fcb      $8F, $06, $02                ; $27 
                    fcb      $FF, $9B, $1D, $02           ; $28 
                    fcb      $9B, $1D, $02                ; $29 
                    fcb      $86, $8F, $06, $02           ; $2A 
                    fcb      $8F, $06, $02                ; $2B 
                    fcb      $86, $9A, $06, $02           ; $2C 
                    fcb      $9A, $06, $02                ; $2D 
                    fcb      $C1, $8E, $06, $02           ; $2E 
                    fcb      $8E, $06, $02                ; $2F 
                    fcb      $EF, $A4, $1B, $02           ; $30 
                    fcb      $A7, $1B, $02                ; $31 
                    fcb      $86, $AB, $06, $02           ; $32 
                    fcb      $80, $06, $02                ; $33 
                    fcb      $86, $A4, $1B, $02           ; $34 
                    fcb      $A7, $1B, $02                ; $35 
                    fcb      $C1, $AB, $06, $02           ; $36 
                    fcb      $80, $06, $02                ; $37 
                    fcb      $FF, $83, $18, $02           ; $38 
                    fcb      $83, $18, $02                ; $39 
                    fcb      $86, $85, $06, $02           ; $3A 
                    fcb      $85, $06, $02                ; $3B 
                    fcb      $FF, $87, $06, $02           ; $3C 
                    fcb      $87, $06, $02                ; $3D 
                    fcb      $C1, $8A, $06, $02           ; $3E 
                    fcb      $8A, $06, $02                ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern06: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $A4, $24, $02           ; $00 
                    fcb      $A7, $24, $02                ; $01 
                    fcb      $87, $AB, $07, $02           ; $02 
                    fcb      $80, $07, $02                ; $03 
                    fcb      $93, $A4, $24, $02           ; $04 
                    fcb      $A7, $24, $02                ; $05 
                    fcb      $C1, $AB, $07, $02           ; $06 
                    fcb      $8C, $07, $02                ; $07 
                    fcb      $FF, $98, $07, $02           ; $08 
                    fcb      $98, $07, $02                ; $09 
                    fcb      $87, $8C, $07, $02           ; $0A 
                    fcb      $8C, $07, $02                ; $0B 
                    fcb      $FF, $98, $1F, $02           ; $0C 
                    fcb      $98, $1F, $02                ; $0D 
                    fcb      $C1, $8C, $07, $02           ; $0E 
                    fcb      $8C, $07, $02                ; $0F 
                    fcb      $EF, $98, $1F, $02           ; $10 
                    fcb      $98, $1F, $02                ; $11 
                    fcb      $87, $8C, $07, $02           ; $12 
                    fcb      $8C, $07, $02                ; $13 
                    fcb      $FF, $98, $07, $02           ; $14 
                    fcb      $98, $07, $02                ; $15 
                    fcb      $C1, $8C, $07, $02           ; $16 
                    fcb      $8C, $07, $02                ; $17 
                    fcb      $FF, $9A, $22, $02           ; $18 
                    fcb      $9A, $22, $02                ; $19 
                    fcb      $87, $8E, $07, $02           ; $1A 
                    fcb      $8E, $07, $02                ; $1B 
                    fcb      $93, $9A, $22, $02           ; $1C 
                    fcb      $9A, $22, $02                ; $1D 
                    fcb      $C1, $8E, $07, $02           ; $1E 
                    fcb      $8E, $07, $02                ; $1F 
                    fcb      $FF, $9D, $07, $02           ; $20 
                    fcb      $9D, $07, $02                ; $21 
                    fcb      $87, $91, $07, $02           ; $22 
                    fcb      $91, $07, $02                ; $23 
                    fcb      $87, $9B, $1D, $02           ; $24 
                    fcb      $9B, $1D, $02                ; $25 
                    fcb      $C1, $8F, $07, $02           ; $26 
                    fcb      $8F, $07, $02                ; $27 
                    fcb      $FF, $9B, $1D, $02           ; $28 
                    fcb      $9B, $1D, $02                ; $29 
                    fcb      $87, $8F, $07, $02           ; $2A 
                    fcb      $8F, $07, $02                ; $2B 
                    fcb      $87, $9A, $07, $02           ; $2C 
                    fcb      $9A, $07, $02                ; $2D 
                    fcb      $C1, $8E, $07, $02           ; $2E 
                    fcb      $8E, $07, $02                ; $2F 
                    fcb      $EF, $A4, $1B, $02           ; $30 
                    fcb      $A7, $1B, $02                ; $31 
                    fcb      $87, $AB, $07, $02           ; $32 
                    fcb      $80, $07, $02                ; $33 
                    fcb      $87, $A4, $1B, $02           ; $34 
                    fcb      $A7, $1B, $02                ; $35 
                    fcb      $C1, $AB, $07, $02           ; $36 
                    fcb      $80, $07, $02                ; $37 
                    fcb      $FF, $83, $18, $02           ; $38 
                    fcb      $83, $18, $02                ; $39 
                    fcb      $87, $85, $07, $02           ; $3A 
                    fcb      $85, $07, $02                ; $3B 
                    fcb      $FF, $87, $07, $02           ; $3C 
                    fcb      $87, $07, $02                ; $3D 
                    fcb      $C1, $8A, $07, $02           ; $3E 
                    fcb      $8A, $07, $02                ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern07: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_MARCH 

  fcb $81, $FF, $00, $02 ; $00
  fcb $82, $92, $01, $02 ; $01
  fcb $83, $86, $02, $02 ; $02
  fcb $84, $86, $03, $02 ; $03
  fcb $85, $92, $04, $02 ; $04
  fcb $86, $92, $05, $02 ; $05
  fcb $87, $86, $06, $02 ; $06
  fcb $88, $86, $07, $02 ; $07
  fcb $89, $C1, $08, $02 ; $08
  fcb $8A, $92, $09, $02 ; $09
  fcb $8B, $86, $0A, $02 ; $0A
  fcb $8C, $86, $0B, $02 ; $0B
  fcb $8D, $92, $0C, $02 ; $0C
  fcb $8E, $92, $0D, $02 ; $0D
  fcb $8F, $86, $0E, $02 ; $0E
  fcb $90, $86, $0F, $02 ; $0F
  fcb $91, $92, $10, $02 ; $10
  fcb $92, $92, $11, $02 ; $11
  fcb $93, $86, $12, $02 ; $12
  fcb $94, $86, $13, $02 ; $13
  fcb $95, $92, $14, $02 ; $14
  fcb $96, $92, $15, $02 ; $15
  fcb $97, $86, $16, $02 ; $16
  fcb $98, $86, $17, $02 ; $17
  fcb $99, $C1, $18, $02 ; $18
  fcb $9A, $92, $19, $02 ; $19
  fcb $9B, $86, $1A, $02 ; $1A
  fcb $9C, $86, $1B, $02 ; $1B
  fcb $9D, $92, $1C, $02 ; $1C
  fcb $9E, $92, $1D, $02 ; $1D
  fcb $9F, $86, $1E, $02 ; $1E
  fcb $A0, $86, $1F, $02 ; $1F
  fcb $A1, $EF, $20, $02 ; $20
  fcb $A2, $92, $21, $02 ; $21
  fcb $A3, $86, $22, $02 ; $22
  fcb $A4, $86, $23, $02 ; $23
  fcb $A5, $92, $24, $02 ; $24
  fcb $A6, $92, $25, $02 ; $25
  fcb $A7, $86, $26, $02 ; $26
  fcb $A8, $86, $27, $02 ; $27
  fcb $A9, $C1, $28, $02 ; $28
  fcb $AA, $92, $29, $02 ; $29
  fcb $A9, $86, $28, $02 ; $2A
  fcb $A8, $86, $27, $02 ; $2B
  fcb $A7, $92, $26, $02 ; $2C
  fcb $A6, $92, $25, $02 ; $2D
  fcb $A5, $86, $24, $02 ; $2E
  fcb $A4, $86, $23, $02 ; $2F
  fcb $A3, $92, $22, $02 ; $30
  fcb $A2, $92, $21, $02 ; $31
  fcb $A1, $86, $20, $02 ; $32
  fcb $A0, $86, $1F, $02 ; $33
  fcb $9F, $92, $1E, $02 ; $34
  fcb $9E, $92, $1D, $02 ; $35
  fcb $9D, $86, $1C, $02 ; $36
  fcb $9C, $86, $1B, $02 ; $37
  fcb $9B, $C1, $1A, $02 ; $38
  fcb $9A, $92, $19, $02 ; $39
  fcb $99, $86, $18, $02 ; $3A
  fcb $98, $86, $17, $02 ; $3B
  fcb $97, $92, $16, $02 ; $3C
  fcb $96, $92, $15, $02 ; $3D
  fcb $95, $86, $14, $02 ; $3E
  fcb $94, $86, $13, $02 ; $3F
 fcb $00, $80 ; end-marker

                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern08: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_MARCH 

  fcb $93, $FF, $12, $02 ; $00
  fcb $92, $93, $11, $02 ; $01
  fcb $91, $87, $10, $02 ; $02
  fcb $90, $87, $0F, $02 ; $03
  fcb $8F, $93, $0E, $02 ; $04
  fcb $8E, $93, $0D, $02 ; $05
  fcb $8D, $87, $0C, $02 ; $06
  fcb $8C, $87, $0B, $02 ; $07
  fcb $8B, $C1, $0A, $02 ; $08
  fcb $8A, $93, $09, $02 ; $09
  fcb $89, $87, $08, $02 ; $0A
  fcb $88, $87, $07, $02 ; $0B
  fcb $86, $93, $05, $02 ; $0C
  fcb $85, $93, $04, $02 ; $0D
  fcb $84, $87, $03, $02 ; $0E
  fcb $83, $87, $02, $02 ; $0F
  fcb $82, $93, $01, $02 ; $10
  fcb $81, $93, $00, $02 ; $11
  fcb $82, $87, $01, $02 ; $12
  fcb $83, $87, $02, $02 ; $13
  fcb $84, $93, $03, $02 ; $14
  fcb $85, $93, $04, $02 ; $15
  fcb $86, $87, $05, $02 ; $16
  fcb $87, $87, $06, $02 ; $17
  fcb $88, $C1, $07, $02 ; $18
  fcb $89, $93, $08, $02 ; $19
  fcb $8A, $87, $09, $02 ; $1A
  fcb $8B, $87, $0A, $02 ; $1B
  fcb $8C, $93, $0B, $02 ; $1C
  fcb $8D, $93, $0C, $02 ; $1D
  fcb $8E, $87, $0D, $02 ; $1E
  fcb $8F, $87, $0E, $02 ; $1F
  fcb $90, $EF, $0F, $02 ; $20
  fcb $91, $93, $10, $02 ; $21
  fcb $92, $87, $11, $02 ; $22
  fcb $93, $87, $12, $02 ; $23
  fcb $94, $93, $13, $02 ; $24
  fcb $95, $93, $14, $02 ; $25
  fcb $96, $87, $15, $02 ; $26
  fcb $97, $87, $16, $02 ; $27
  fcb $98, $C1, $17, $02 ; $28
  fcb $99, $93, $18, $02 ; $29
  fcb $9A, $87, $19, $02 ; $2A
  fcb $9B, $87, $1A, $02 ; $2B
  fcb $9C, $93, $1B, $02 ; $2C
  fcb $9D, $93, $1C, $02 ; $2D
  fcb $9E, $87, $1D, $02 ; $2E
  fcb $9D, $87, $1C, $02 ; $2F
  fcb $9C, $93, $1B, $02 ; $30
  fcb $9B, $93, $1A, $02 ; $31
  fcb $9A, $87, $19, $02 ; $32
  fcb $99, $87, $18, $02 ; $33
  fcb $98, $93, $17, $02 ; $34
  fcb $97, $93, $16, $02 ; $35
  fcb $96, $87, $15, $02 ; $36
  fcb $95, $87, $14, $02 ; $37
  fcb $94, $C1, $13, $02 ; $38
  fcb $93, $93, $12, $02 ; $39
  fcb $92, $87, $11, $02 ; $3A
  fcb $91, $87, $10, $02 ; $3B
  fcb $90, $93, $0F, $02 ; $3C
  fcb $8F, $93, $0E, $02 ; $3D
  fcb $8E, $87, $0D, $02 ; $3E
  fcb $8D, $87, $0C, $02 ; $3F
 fcb $00, $80 ; end-marker
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern09: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_MARCH 

  fcb $93, $FF, $12, $02 ; $00
  fcb $92, $93, $11, $02 ; $01
  fcb $91, $87, $10, $02 ; $02
  fcb $90, $87, $0F, $02 ; $03
  fcb $8F, $93, $0E, $02 ; $04
  fcb $8E, $93, $0D, $02 ; $05
  fcb $8D, $87, $0C, $02 ; $06
  fcb $8C, $87, $0B, $02 ; $07
  fcb $8B, $C1, $0A, $02 ; $08
  fcb $8A, $93, $09, $02 ; $09
  fcb $89, $87, $08, $02 ; $0A
  fcb $88, $87, $07, $02 ; $0B
  fcb $86, $93, $05, $02 ; $0C
  fcb $85, $93, $04, $02 ; $0D
  fcb $84, $87, $03, $02 ; $0E
  fcb $83, $87, $02, $02 ; $0F
  fcb $82, $93, $01, $02 ; $10
  fcb $80, $93, $00, $02 ; $11
  fcb $87, $87, $07, $02 ; $12
  fcb $8C, $87, $0C, $02 ; $13
  fcb $8F, $93, $0F, $02 ; $14
  fcb $93, $93, $13, $02 ; $15
  fcb $98, $87, $18, $02 ; $16
  fcb $9B, $87, $1B, $02 ; $17
  fcb $9F, $C1, $1F, $02 ; $18
  fcb $A4, $93, $24, $02 ; $19
  fcb $9F, $87, $1F, $02 ; $1A
  fcb $9B, $87, $1B, $02 ; $1B
  fcb $98, $93, $18, $02 ; $1C
  fcb $93, $93, $13, $02 ; $1D
  fcb $8F, $87, $0F, $02 ; $1E
  fcb $8C, $87, $0C, $02 ; $1F
  fcb $87, $EF, $07, $02 ; $20
  fcb $80, $93, $00, $02 ; $21
  fcb $87, $87, $07, $02 ; $22
  fcb $8C, $87, $0C, $02 ; $23
  fcb $8F, $93, $0F, $02 ; $24
  fcb $93, $93, $13, $02 ; $25
  fcb $98, $87, $18, $02 ; $26
  fcb $9B, $87, $1B, $02 ; $27
  fcb $9F, $C1, $1F, $02 ; $28
  fcb $A4, $93, $24, $02 ; $29
  fcb $9F, $87, $1F, $02 ; $2A
  fcb $9B, $87, $1B, $02 ; $2B
  fcb $98, $93, $18, $02 ; $2C
  fcb $93, $93, $13, $02 ; $2D
  fcb $8F, $87, $0F, $02 ; $2E
  fcb $8C, $87, $0C, $02 ; $2F
  fcb $87, $93, $07, $02 ; $30
  fcb $80, $93, $00, $02 ; $31
  fcb $87, $87, $07, $02 ; $32
  fcb $8C, $87, $0C, $02 ; $33
  fcb $8F, $93, $0F, $02 ; $34
  fcb $93, $93, $13, $02 ; $35
  fcb $98, $87, $18, $02 ; $36
  fcb $9B, $87, $1B, $02 ; $37
  fcb $9F, $C1, $1F, $02 ; $38
  fcb $A4, $93, $24, $02 ; $39
  fcb $9F, $87, $1F, $02 ; $3A
  fcb $9B, $87, $1B, $02 ; $3B
  fcb $98, $93, $18, $02 ; $3C
  fcb $93, $93, $13, $02 ; $3D
  fcb $8F, $87, $0F, $02 ; $3E
  fcb $8C, $87, $0C, $02 ; $3F
 fcb $00, $80 ; end-marker

                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern0A: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $A4, $24, $02           ; $00 
                    fcb      $A7, $24, $02                ; $01 
                    fcb      $80, $AB, $00, $02           ; $02 
                    fcb      $80, $00, $02                ; $03 
                    fcb      $8C, $A4, $24, $02           ; $04 
                    fcb      $A7, $24, $02                ; $05 
                    fcb      $C1, $AB, $00, $02           ; $06 
                    fcb      $8C, $00, $02                ; $07 
                    fcb      $FF, $98, $00, $02           ; $08 
                    fcb      $98, $00, $02                ; $09 
                    fcb      $80, $8C, $00, $02           ; $0A 
                    fcb      $8C, $00, $02                ; $0B 
                    fcb      $FF, $98, $1F, $02           ; $0C 
                    fcb      $98, $1F, $02                ; $0D 
                    fcb      $C1, $8C, $00, $02           ; $0E 
                    fcb      $8C, $00, $02                ; $0F 
                    fcb      $EF, $98, $1F, $02           ; $10 
                    fcb      $98, $1F, $02                ; $11 
                    fcb      $80, $8C, $00, $02           ; $12 
                    fcb      $8C, $00, $02                ; $13 
                    fcb      $FF, $98, $00, $02           ; $14 
                    fcb      $98, $00, $02                ; $15 
                    fcb      $C1, $8C, $00, $02           ; $16 
                    fcb      $8C, $00, $02                ; $17 
                    fcb      $FF, $9A, $22, $02           ; $18 
                    fcb      $9A, $22, $02                ; $19 
                    fcb      $80, $8E, $00, $02           ; $1A 
                    fcb      $8E, $00, $02                ; $1B 
                    fcb      $8C, $9A, $22, $02           ; $1C 
                    fcb      $9A, $22, $02                ; $1D 
                    fcb      $C1, $8E, $00, $02           ; $1E 
                    fcb      $8E, $00, $02                ; $1F 
                    fcb      $FF, $9D, $00, $02           ; $20 
                    fcb      $9D, $00, $02                ; $21 
                    fcb      $80, $91, $00, $02           ; $22 
                    fcb      $91, $00, $02                ; $23 
                    fcb      $80, $9B, $1D, $02           ; $24 
                    fcb      $9B, $1D, $02                ; $25 
                    fcb      $C1, $8F, $00, $02           ; $26 
                    fcb      $8F, $00, $02                ; $27 
                    fcb      $FF, $9B, $1D, $02           ; $28 
                    fcb      $9B, $1D, $02                ; $29 
                    fcb      $80, $8F, $00, $02           ; $2A 
                    fcb      $8F, $00, $02                ; $2B 
                    fcb      $80, $9A, $00, $02           ; $2C 
                    fcb      $9A, $00, $02                ; $2D 
                    fcb      $C1, $8E, $00, $02           ; $2E 
                    fcb      $8E, $00, $02                ; $2F 
                    fcb      $EF, $A4, $1B, $02           ; $30 
                    fcb      $A7, $1B, $02                ; $31 
                    fcb      $80, $AB, $00, $02           ; $32 
                    fcb      $80, $00, $02                ; $33 
                    fcb      $80, $A4, $1B, $02           ; $34 
                    fcb      $A7, $1B, $02                ; $35 
                    fcb      $C1, $AB, $00, $02           ; $36 
                    fcb      $80, $00, $02                ; $37 
                    fcb      $FF, $83, $18, $02           ; $38 
                    fcb      $83, $18, $02                ; $39 
                    fcb      $80, $85, $00, $02           ; $3A 
                    fcb      $85, $00, $02                ; $3B 
                    fcb      $FF, $87, $00, $02           ; $3C 
                    fcb      $87, $00, $02                ; $3D 
                    fcb      $C1, $8A, $00, $02           ; $3E 
                    fcb      $8A, $00, $02                ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern0B: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_WELT 
                    fcb      $9D, $FF, $20, $02           ; $00 
                    fcb      $A0, $9D, $24, $02           ; $01 
                    fcb      $A4, $9C, $1D, $02           ; $02 
                    fcb      $1B, $02                     ; $03 
                    fcb      $85, $1A, $02                ; $04 
                    fcb      $99, $05, $02                ; $05 
                    fcb      $18, $02                     ; $06 
                    fcb      $17, $02                     ; $07 
                    fcb      $85, $16, $02                ; $08 
                    fcb      $95, $05, $02                ; $09 
                    fcb      $14, $02                     ; $0A 
                    fcb      $13, $02                     ; $0B 
                    fcb      $85, $12, $02                ; $0C 
                    fcb      $91, $05, $02                ; $0D 
                    fcb      $10, $02                     ; $0E 
                    fcb      $0F, $02                     ; $0F 
                    fcb      $9D, $8E, $20, $02           ; $10 
                    fcb      $A0, $8D, $24, $02           ; $11 
                    fcb      $A4, $8C, $1D, $02           ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $05, $02                     ; $14 
                    fcb      $05, $02                     ; $15 
                    fcb      $05, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $05, $02                     ; $18 
                    fcb      $05, $02                     ; $19 
                    fcb      $05, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $05, $02                     ; $1C 
                    fcb      $05, $02                     ; $1D 
                    fcb      $05, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $9D, $20, $02                ; $20 
                    fcb      $A0, $25, $02                ; $21 
                    fcb      $A5, $85, $1D, $02           ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $05, $02                     ; $24 
                    fcb      $05, $02                     ; $25 
                    fcb      $05, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $05, $02                     ; $28 
                    fcb      $05, $02                     ; $29 
                    fcb      $05, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $05, $02                     ; $2C 
                    fcb      $05, $02                     ; $2D 
                    fcb      $05, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $9D, $20, $02                ; $30 
                    fcb      $A0, $24, $02                ; $31 
                    fcb      $A4, $85, $1D, $02           ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $05, $02                     ; $34 
                    fcb      $05, $02                     ; $35 
                    fcb      $05, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $05, $02                     ; $38 
                    fcb      $05, $02                     ; $39 
                    fcb      $05, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $05, $02                     ; $3C 
                    fcb      $05, $02                     ; $3D 
                    fcb      $05, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern0C: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_WELT 
                    fcb      $9D, $20, $02                ; $00 
                    fcb      $A0, $25, $02                ; $01 
                    fcb      $A5, $81, $1D, $02           ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $01, $02                     ; $04 
                    fcb      $01, $02                     ; $05 
                    fcb      $01, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $01, $02                     ; $08 
                    fcb      $01, $02                     ; $09 
                    fcb      $01, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $01, $02                     ; $0C 
                    fcb      $01, $02                     ; $0D 
                    fcb      $01, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $9D, $20, $02                ; $10 
                    fcb      $A0, $25, $02                ; $11 
                    fcb      $A5, $81, $1D, $02           ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $01, $02                     ; $14 
                    fcb      $01, $02                     ; $15 
                    fcb      $01, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $01, $02                     ; $18 
                    fcb      $01, $02                     ; $19 
                    fcb      $01, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $01, $02                     ; $1C 
                    fcb      $01, $02                     ; $1D 
                    fcb      $01, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $9D, $20, $02                ; $20 
                    fcb      $A0, $27, $02                ; $21 
                    fcb      $A7, $81, $1D, $02           ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $01, $02                     ; $24 
                    fcb      $01, $02                     ; $25 
                    fcb      $01, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $01, $02                     ; $28 
                    fcb      $01, $02                     ; $29 
                    fcb      $01, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $01, $02                     ; $2C 
                    fcb      $01, $02                     ; $2D 
                    fcb      $01, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $9D, $20, $02                ; $30 
                    fcb      $A0, $25, $02                ; $31 
                    fcb      $A5, $81, $1D, $02           ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $01, $02                     ; $34 
                    fcb      $01, $02                     ; $35 
                    fcb      $01, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $01, $02                     ; $38 
                    fcb      $01, $02                     ; $39 
                    fcb      $01, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $01, $02                     ; $3C 
                    fcb      $01, $02                     ; $3D 
                    fcb      $01, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern0D: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_WELT 
                    fcb      $9D, $24, $02                ; $00 
                    fcb      $A0, $1D, $02                ; $01 
                    fcb      $A4, $88, $20, $02           ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $08, $02                     ; $04 
                    fcb      $08, $02                     ; $05 
                    fcb      $08, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $08, $02                     ; $08 
                    fcb      $08, $02                     ; $09 
                    fcb      $08, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $08, $02                     ; $0C 
                    fcb      $08, $02                     ; $0D 
                    fcb      $08, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $9D, $24, $02                ; $10 
                    fcb      $A0, $1D, $02                ; $11 
                    fcb      $A4, $88, $20, $02           ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $08, $02                     ; $14 
                    fcb      $08, $02                     ; $15 
                    fcb      $08, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $08, $02                     ; $18 
                    fcb      $08, $02                     ; $19 
                    fcb      $08, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $08, $02                     ; $1C 
                    fcb      $08, $02                     ; $1D 
                    fcb      $08, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $9D, $24, $02                ; $20 
                    fcb      $A0, $1D, $02                ; $21 
                    fcb      $A4, $88, $20, $02           ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $08, $02                     ; $24 
                    fcb      $08, $02                     ; $25 
                    fcb      $08, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $08, $02                     ; $28 
                    fcb      $08, $02                     ; $29 
                    fcb      $08, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $08, $02                     ; $2C 
                    fcb      $08, $02                     ; $2D 
                    fcb      $08, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $9D, $24, $02                ; $30 
                    fcb      $A0, $1D, $02                ; $31 
                    fcb      $A4, $88, $20, $02           ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $08, $02                     ; $34 
                    fcb      $08, $02                     ; $35 
                    fcb      $08, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $08, $02                     ; $38 
                    fcb      $08, $02                     ; $39 
                    fcb      $08, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $08, $02                     ; $3C 
                    fcb      $08, $02                     ; $3D 
                    fcb      $08, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern0E: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_WELT 
                    fcb      $9D, $20, $02                ; $00 
                    fcb      $A0, $24, $02                ; $01 
                    fcb      $A4, $83, $1D, $02           ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $03, $02                     ; $04 
                    fcb      $03, $02                     ; $05 
                    fcb      $03, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $03, $02                     ; $08 
                    fcb      $03, $02                     ; $09 
                    fcb      $03, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $03, $02                     ; $0C 
                    fcb      $03, $02                     ; $0D 
                    fcb      $03, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $9D, $20, $02                ; $10 
                    fcb      $A0, $24, $02                ; $11 
                    fcb      $A4, $83, $1D, $02           ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $03, $02                     ; $14 
                    fcb      $03, $02                     ; $15 
                    fcb      $03, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $03, $02                     ; $18 
                    fcb      $03, $02                     ; $19 
                    fcb      $03, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $03, $02                     ; $1C 
                    fcb      $03, $02                     ; $1D 
                    fcb      $03, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $9B, $22, $02                ; $20 
                    fcb      $9F, $1B, $02                ; $21 
                    fcb      $A2, $83, $1F, $02           ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $03, $02                     ; $24 
                    fcb      $03, $02                     ; $25 
                    fcb      $03, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $03, $02                     ; $28 
                    fcb      $03, $02                     ; $29 
                    fcb      $03, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $03, $02                     ; $2C 
                    fcb      $03, $02                     ; $2D 
                    fcb      $03, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $9B, $22, $02                ; $30 
                    fcb      $9F, $1B, $02                ; $31 
                    fcb      $A2, $83, $1F, $02           ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $03, $02                     ; $34 
                    fcb      $03, $02                     ; $35 
                    fcb      $03, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $03, $02                     ; $38 
                    fcb      $03, $02                     ; $39 
                    fcb      $03, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $03, $02                     ; $3C 
                    fcb      $03, $02                     ; $3D 
                    fcb      $03, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern0F: 
                    fdb      adsr 
                    fdb      twang 



                    if       BANK=BANK_CREDITS
                    fcb      $9D, $91, $20, $02           ; $00 
                    fcb      $A0, $91, $24, $02           ; $01 
                    fcb      $A4, $1D, $02                ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $85, $11, $02                ; $04 
                    fcb      $91, $05, $02                ; $05 
                    fcb      $3f, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $85, $0F, $02                ; $08 
                    fcb      $8F, $05, $02                ; $09 
                    fcb      $3f, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $85, $11, $02                ; $0C 
                    fcb      $91, $05, $02                ; $0D 
                    fcb      $05, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $9D, $20, $02                ; $10 
                    fcb      $A0, $24, $02                ; $11 
                    fcb      $A4, $85, $1D, $02           ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $05, $02                     ; $14 
                    fcb      $05, $02                     ; $15 
                    fcb      $05, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $05, $02                     ; $18 
                    fcb      $05, $02                     ; $19 
                    fcb      $05, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $05, $02                     ; $1C 
                    fcb      $05, $02                     ; $1D 
                    fcb      $05, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $9D, $20, $02                ; $20 
                    fcb      $A0, $25, $02                ; $21 
                    fcb      $A5, $85, $1D, $02           ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $05, $02                     ; $24 
                    fcb      $05, $02                     ; $25 
                    fcb      $05, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $05, $02                     ; $28 
                    fcb      $05, $02                     ; $29 
                    fcb      $05, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $05, $02                     ; $2C 
                    fcb      $05, $02                     ; $2D 
                    fcb      $05, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $9D, $20, $02                ; $30 
                    fcb      $A0, $24, $02                ; $31 
                    fcb      $A4, $85, $1D, $02           ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $05, $02                     ; $34 
                    fcb      $05, $02                     ; $35 
                    fcb      $05, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $05, $02                     ; $38 
                    fcb      $05, $02                     ; $39 
                    fcb      $05, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $05, $02                     ; $3C 
                    fcb      $05, $02                     ; $3D 
                    fcb      $05, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    


                    if       BANK=BANK_BATTLE
                    fcb      $9D, $91, $20, $02           ; $00 
                    fcb      $A0, $91, $24, $02           ; $01 
                    fcb      $A4, $1D, $02                ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $85, $11, $02                ; $04 
                    fcb      $91, $05, $02                ; $05 
                    fcb      $3f, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $85, $0F, $02                ; $08 
                    fcb      $8F, $05, $02                ; $09 
                    fcb      $3f, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $85, $11, $02                ; $0C 
                    fcb      $91, $05, $02                ; $0D 
                    fcb      $05, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $9D, $20, $02                ; $10 
                    fcb      $A0, $24, $02                ; $11 
                    fcb      $A4, $85, $1D, $02           ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $05, $02                     ; $14 
                    fcb      $05, $02                     ; $15 
                    fcb      $05, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $05, $02                     ; $18 
                    fcb      $05, $02                     ; $19 
                    fcb      $05, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $05, $02                     ; $1C 
                    fcb      $05, $02                     ; $1D 
                    fcb      $05, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $9D, $20, $02                ; $20 
                    fcb      $A0, $25, $02                ; $21 
                    fcb      $A5, $85, $1D, $02           ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $05, $02                     ; $24 
                    fcb      $05, $02                     ; $25 
                    fcb      $05, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $05, $02                     ; $28 
                    fcb      $05, $02                     ; $29 
                    fcb      $05, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $05, $02                     ; $2C 
                    fcb      $05, $02                     ; $2D 
                    fcb      $05, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $9D, $20, $02                ; $30 
                    fcb      $A0, $24, $02                ; $31 
                    fcb      $A4, $85, $1D, $02           ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $05, $02                     ; $34 
                    fcb      $05, $02                     ; $35 
                    fcb      $05, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $05, $02                     ; $38 
                    fcb      $05, $02                     ; $39 
                    fcb      $05, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $05, $02                     ; $3C 
                    fcb      $05, $02                     ; $3D 
                    fcb      $05, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    

                    if       BANK=BANK_ROADRUNNER 
                    fcb      $9D, $91, $20, $02           ; $00 
                    fcb      $A0, $91, $24, $02           ; $01 
                    fcb      $A4, $1D, $02                ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $85, $11, $02                ; $04 
                    fcb      $91, $05, $02                ; $05 
                    fcb      $3f, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $85, $0F, $02                ; $08 
                    fcb      $8F, $05, $02                ; $09 
                    fcb      $3f, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $85, $11, $02                ; $0C 
                    fcb      $91, $05, $02                ; $0D 
                    fcb      $05, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $9D, $20, $02                ; $10 
                    fcb      $A0, $24, $02                ; $11 
                    fcb      $A4, $85, $1D, $02           ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $05, $02                     ; $14 
                    fcb      $05, $02                     ; $15 
                    fcb      $05, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $05, $02                     ; $18 
                    fcb      $05, $02                     ; $19 
                    fcb      $05, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $05, $02                     ; $1C 
                    fcb      $05, $02                     ; $1D 
                    fcb      $05, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $9D, $20, $02                ; $20 
                    fcb      $A0, $25, $02                ; $21 
                    fcb      $A5, $85, $1D, $02           ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $05, $02                     ; $24 
                    fcb      $05, $02                     ; $25 
                    fcb      $05, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $05, $02                     ; $28 
                    fcb      $05, $02                     ; $29 
                    fcb      $05, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $05, $02                     ; $2C 
                    fcb      $05, $02                     ; $2D 
                    fcb      $05, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $9D, $20, $02                ; $30 
                    fcb      $A0, $24, $02                ; $31 
                    fcb      $A4, $85, $1D, $02           ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $05, $02                     ; $34 
                    fcb      $05, $02                     ; $35 
                    fcb      $05, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $05, $02                     ; $38 
                    fcb      $05, $02                     ; $39 
                    fcb      $05, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $05, $02                     ; $3C 
                    fcb      $05, $02                     ; $3D 
                    fcb      $05, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    


                    if       BANK=BANK_GREETINGS
                    fcb      $9D, $91, $20, $02           ; $00 
                    fcb      $A0, $91, $24, $02           ; $01 
                    fcb      $A4, $1D, $02                ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $85, $11, $02                ; $04 
                    fcb      $91, $05, $02                ; $05 
                    fcb      $3f, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $85, $0F, $02                ; $08 
                    fcb      $8F, $05, $02                ; $09 
                    fcb      $3f, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $85, $11, $02                ; $0C 
                    fcb      $91, $05, $02                ; $0D 
                    fcb      $05, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $9D, $20, $02                ; $10 
                    fcb      $A0, $24, $02                ; $11 
                    fcb      $A4, $85, $1D, $02           ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $05, $02                     ; $14 
                    fcb      $05, $02                     ; $15 
                    fcb      $05, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $05, $02                     ; $18 
                    fcb      $05, $02                     ; $19 
                    fcb      $05, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $05, $02                     ; $1C 
                    fcb      $05, $02                     ; $1D 
                    fcb      $05, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $9D, $20, $02                ; $20 
                    fcb      $A0, $25, $02                ; $21 
                    fcb      $A5, $85, $1D, $02           ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $05, $02                     ; $24 
                    fcb      $05, $02                     ; $25 
                    fcb      $05, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $05, $02                     ; $28 
                    fcb      $05, $02                     ; $29 
                    fcb      $05, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $05, $02                     ; $2C 
                    fcb      $05, $02                     ; $2D 
                    fcb      $05, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $9D, $20, $02                ; $30 
                    fcb      $A0, $24, $02                ; $31 
                    fcb      $A4, $85, $1D, $02           ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $05, $02                     ; $34 
                    fcb      $05, $02                     ; $35 
                    fcb      $05, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $05, $02                     ; $38 
                    fcb      $05, $02                     ; $39 
                    fcb      $05, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $05, $02                     ; $3C 
                    fcb      $05, $02                     ; $3D 
                    fcb      $05, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    




pattern10: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_GREETINGS 
                    fcb      $9D, $91, $20, $02           ; $00 
                    fcb      $A0, $91, $25, $02           ; $01 
                    fcb      $A5, $1D, $02                ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $81, $11, $02                ; $04 
                    fcb      $91, $01, $02                ; $05 
                    fcb      $3f, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $81, $0F, $02                ; $08 
                    fcb      $8F, $01, $02                ; $09 
                    fcb      $3f, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $81, $11, $02                ; $0C 
                    fcb      $91, $01, $02                ; $0D 
                    fcb      $01, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $9D, $20, $02                ; $10 
                    fcb      $A0, $25, $02                ; $11 
                    fcb      $A5, $81, $1D, $02           ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $01, $02                     ; $14 
                    fcb      $01, $02                     ; $15 
                    fcb      $01, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $01, $02                     ; $18 
                    fcb      $01, $02                     ; $19 
                    fcb      $01, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $01, $02                     ; $1C 
                    fcb      $01, $02                     ; $1D 
                    fcb      $01, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $9D, $20, $02                ; $20 
                    fcb      $A0, $27, $02                ; $21 
                    fcb      $A7, $81, $1D, $02           ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $01, $02                     ; $24 
                    fcb      $01, $02                     ; $25 
                    fcb      $01, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $01, $02                     ; $28 
                    fcb      $01, $02                     ; $29 
                    fcb      $01, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $01, $02                     ; $2C 
                    fcb      $01, $02                     ; $2D 
                    fcb      $01, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $9D, $20, $02                ; $30 
                    fcb      $A0, $25, $02                ; $31 
                    fcb      $A5, $81, $1D, $02           ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $01, $02                     ; $34 
                    fcb      $01, $02                     ; $35 
                    fcb      $01, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $01, $02                     ; $38 
                    fcb      $01, $02                     ; $39 
                    fcb      $01, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $01, $02                     ; $3C 
                    fcb      $01, $02                     ; $3D 
                    fcb      $01, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern11: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_GREETINGS 
                    fcb      $9D, $91, $24, $02           ; $00 
                    fcb      $A0, $91, $1D, $02           ; $01 
                    fcb      $A4, $20, $02                ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $88, $11, $02                ; $04 
                    fcb      $91, $08, $02                ; $05 
                    fcb      $3f, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $88, $0F, $02                ; $08 
                    fcb      $8F, $08, $02                ; $09 
                    fcb      $3f, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $88, $11, $02                ; $0C 
                    fcb      $91, $08, $02                ; $0D 
                    fcb      $08, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $9D, $24, $02                ; $10 
                    fcb      $A0, $1D, $02                ; $11 
                    fcb      $A4, $88, $20, $02           ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $08, $02                     ; $14 
                    fcb      $08, $02                     ; $15 
                    fcb      $08, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $08, $02                     ; $18 
                    fcb      $08, $02                     ; $19 
                    fcb      $08, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $08, $02                     ; $1C 
                    fcb      $08, $02                     ; $1D 
                    fcb      $08, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $9D, $24, $02                ; $20 
                    fcb      $A0, $1D, $02                ; $21 
                    fcb      $A4, $88, $20, $02           ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $08, $02                     ; $24 
                    fcb      $08, $02                     ; $25 
                    fcb      $08, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $08, $02                     ; $28 
                    fcb      $08, $02                     ; $29 
                    fcb      $08, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $08, $02                     ; $2C 
                    fcb      $08, $02                     ; $2D 
                    fcb      $08, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $9D, $24, $02                ; $30 
                    fcb      $A0, $1D, $02                ; $31 
                    fcb      $A4, $88, $20, $02           ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $08, $02                     ; $34 
                    fcb      $08, $02                     ; $35 
                    fcb      $08, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $08, $02                     ; $38 
                    fcb      $08, $02                     ; $39 
                    fcb      $08, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $08, $02                     ; $3C 
                    fcb      $08, $02                     ; $3D 
                    fcb      $08, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern12: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_GREETINGS 
                    fcb      $9D, $91, $20, $02           ; $00 
                    fcb      $A0, $91, $24, $02           ; $01 
                    fcb      $A4, $1D, $02                ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $83, $11, $02                ; $04 
                    fcb      $91, $03, $02                ; $05 
                    fcb      $3f, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $83, $0F, $02                ; $08 
                    fcb      $8F, $03, $02                ; $09 
                    fcb      $3f, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $83, $11, $02                ; $0C 
                    fcb      $91, $03, $02                ; $0D 
                    fcb      $03, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $9D, $20, $02                ; $10 
                    fcb      $A0, $24, $02                ; $11 
                    fcb      $A4, $83, $1D, $02           ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $03, $02                     ; $14 
                    fcb      $03, $02                     ; $15 
                    fcb      $03, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $03, $02                     ; $18 
                    fcb      $03, $02                     ; $19 
                    fcb      $03, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $03, $02                     ; $1C 
                    fcb      $03, $02                     ; $1D 
                    fcb      $03, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $9B, $22, $02                ; $20 
                    fcb      $9F, $1B, $02                ; $21 
                    fcb      $A2, $83, $1F, $02           ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $03, $02                     ; $24 
                    fcb      $03, $02                     ; $25 
                    fcb      $03, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $03, $02                     ; $28 
                    fcb      $03, $02                     ; $29 
                    fcb      $03, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $03, $02                     ; $2C 
                    fcb      $03, $02                     ; $2D 
                    fcb      $03, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $9B, $FF, $22, $02           ; $30 
                    fcb      $9F, $1B, $02                ; $31 
                    fcb      $A2, $83, $1F, $02           ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $83, $7F, $02                ; $34 
                    fcb      $03, $02                     ; $35 
                    fcb      $03, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $83, $6F, $02                ; $38 
                    fcb      $03, $02                     ; $39 
                    fcb      $03, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $83, $7F, $02                ; $3C 
                    fcb      $03, $02                     ; $3D 
                    fcb      $03, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern13: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_GREETINGS 
                    fcb      $9D, $FF, $11, $02           ; $00 
                    fcb      $A0, $11, $02                ; $01 
                    fcb      $A4, $05, $02                ; $02 
                    fcb      $41, $02                     ; $03 
                    fcb      $85, $FF, $11, $02           ; $04 
                    fcb      $11, $02                     ; $05 
                    fcb      $41, $02                     ; $06 
                    fcb      $41, $02                     ; $07 
                    fcb      $85, $EF, $0F, $02           ; $08 
                    fcb      $0F, $02                     ; $09 
                    fcb      $05, $02                     ; $0A 
                    fcb      $41, $02                     ; $0B 
                    fcb      $85, $FF, $11, $02           ; $0C 
                    fcb      $11, $02                     ; $0D 
                    fcb      $41, $02                     ; $0E 
                    fcb      $41, $02                     ; $0F 
                    fcb      $9D, $05, $02                ; $10 
                    fcb      $20, $02                     ; $11 
                    fcb      $A4, $05, $02                ; $12 
                    fcb      $41, $02                     ; $13 
                    fcb      $85, $FF, $0F, $02           ; $14 
                    fcb      $0F, $02                     ; $15 
                    fcb      $41, $02                     ; $16 
                    fcb      $41, $02                     ; $17 
                    fcb      $85, $EF, $11, $02           ; $18 
                    fcb      $11, $02                     ; $19 
                    fcb      $05, $02                     ; $1A 
                    fcb      $41, $02                     ; $1B 
                    fcb      $85, $FF, $14, $02           ; $1C 
                    fcb      $14, $02                     ; $1D 
                    fcb      $41, $02                     ; $1E 
                    fcb      $41, $02                     ; $1F 
                    fcb      $9D, $85, $16, $02           ; $20 
                    fcb      $A0, $16, $02                ; $21 
                    fcb      $A5, $85, $18, $02           ; $22 
                    fcb      $C1, $18, $02                ; $23 
                    fcb      $85, $7F, $02                ; $24 
                    fcb      $3f, $02                     ; $25 
                    fcb      $41, $02                     ; $26 
                    fcb      $41, $02                     ; $27 
                    fcb      $85, $EF, $16, $02           ; $28 
                    fcb      $16, $02                     ; $29 
                    fcb      $85, $18, $02                ; $2A 
                    fcb      $C1, $18, $02                ; $2B 
                    fcb      $85, $7F, $02                ; $2C 
                    fcb      $3f, $02                     ; $2D 
                    fcb      $41, $02                     ; $2E 
                    fcb      $41, $02                     ; $2F 
                    fcb      $9D, $85, $16, $02           ; $30 
                    fcb      $A0, $16, $02                ; $31 
                    fcb      $A4, $05, $02                ; $32 
                    fcb      $41, $02                     ; $33 
                    fcb      $85, $FF, $14, $02           ; $34 
                    fcb      $14, $02                     ; $35 
                    fcb      $41, $02                     ; $36 
                    fcb      $41, $02                     ; $37 
                    fcb      $85, $EF, $11, $02           ; $38 
                    fcb      $11, $02                     ; $39 
                    fcb      $05, $02                     ; $3A 
                    fcb      $41, $02                     ; $3B 
                    fcb      $85, $7F, $02                ; $3C 
                    fcb      $3f, $02                     ; $3D 
                    fcb      $0C, $02                     ; $3E 
                    fcb      $41, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern14: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_GREETINGS 
                    fcb      $9D, $FF, $11, $02           ; $00 
                    fcb      $A0, $11, $02                ; $01 
                    fcb      $A5, $01, $02                ; $02 
                    fcb      $41, $02                     ; $03 
                    fcb      $81, $FF, $11, $02           ; $04 
                    fcb      $11, $02                     ; $05 
                    fcb      $41, $02                     ; $06 
                    fcb      $41, $02                     ; $07 
                    fcb      $81, $EF, $0F, $02           ; $08 
                    fcb      $0F, $02                     ; $09 
                    fcb      $01, $02                     ; $0A 
                    fcb      $41, $02                     ; $0B 
                    fcb      $81, $FF, $11, $02           ; $0C 
                    fcb      $11, $02                     ; $0D 
                    fcb      $41, $02                     ; $0E 
                    fcb      $41, $02                     ; $0F 
                    fcb      $9D, $01, $02                ; $10 
                    fcb      $20, $02                     ; $11 
                    fcb      $A5, $0D, $02                ; $12 
                    fcb      $41, $02                     ; $13 
                    fcb      $81, $FF, $0F, $02           ; $14 
                    fcb      $0F, $02                     ; $15 
                    fcb      $41, $02                     ; $16 
                    fcb      $41, $02                     ; $17 
                    fcb      $81, $EF, $11, $02           ; $18 
                    fcb      $11, $02                     ; $19 
                    fcb      $01, $02                     ; $1A 
                    fcb      $41, $02                     ; $1B 
                    fcb      $81, $FF, $14, $02           ; $1C 
                    fcb      $14, $02                     ; $1D 
                    fcb      $41, $02                     ; $1E 
                    fcb      $41, $02                     ; $1F 
                    fcb      $9D, $8D, $16, $02           ; $20 
                    fcb      $A0, $16, $02                ; $21 
                    fcb      $A7, $81, $18, $02           ; $22 
                    fcb      $C1, $18, $02                ; $23 
                    fcb      $81, $7F, $02                ; $24 
                    fcb      $3f, $02                     ; $25 
                    fcb      $41, $02                     ; $26 
                    fcb      $41, $02                     ; $27 
                    fcb      $81, $EF, $16, $02           ; $28 
                    fcb      $16, $02                     ; $29 
                    fcb      $8D, $18, $02                ; $2A 
                    fcb      $C1, $18, $02                ; $2B 
                    fcb      $81, $7F, $02                ; $2C 
                    fcb      $3f, $02                     ; $2D 
                    fcb      $41, $02                     ; $2E 
                    fcb      $41, $02                     ; $2F 
                    fcb      $9D, $81, $16, $02           ; $30 
                    fcb      $A0, $16, $02                ; $31 
                    fcb      $A5, $0D, $02                ; $32 
                    fcb      $41, $02                     ; $33 
                    fcb      $81, $FF, $14, $02           ; $34 
                    fcb      $14, $02                     ; $35 
                    fcb      $41, $02                     ; $36 
                    fcb      $41, $02                     ; $37 
                    fcb      $81, $EF, $11, $02           ; $38 
                    fcb      $11, $02                     ; $39 
                    fcb      $01, $02                     ; $3A 
                    fcb      $41, $02                     ; $3B 
                    fcb      $81, $7F, $02                ; $3C 
                    fcb      $3f, $02                     ; $3D 
                    fcb      $0D, $02                     ; $3E 
                    fcb      $41, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern15: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_GREETINGS 
                    fcb      $9D, $FF, $11, $02           ; $00 
                    fcb      $A0, $11, $02                ; $01 
                    fcb      $A4, $08, $02                ; $02 
                    fcb      $41, $02                     ; $03 
                    fcb      $88, $FF, $11, $02           ; $04 
                    fcb      $11, $02                     ; $05 
                    fcb      $41, $02                     ; $06 
                    fcb      $41, $02                     ; $07 
                    fcb      $88, $EF, $0F, $02           ; $08 
                    fcb      $0F, $02                     ; $09 
                    fcb      $08, $02                     ; $0A 
                    fcb      $41, $02                     ; $0B 
                    fcb      $88, $FF, $11, $02           ; $0C 
                    fcb      $11, $02                     ; $0D 
                    fcb      $41, $02                     ; $0E 
                    fcb      $41, $02                     ; $0F 
                    fcb      $9D, $08, $02                ; $10 
                    fcb      $20, $02                     ; $11 
                    fcb      $A4, $14, $02                ; $12 
                    fcb      $41, $02                     ; $13 
                    fcb      $88, $FF, $0F, $02           ; $14 
                    fcb      $0F, $02                     ; $15 
                    fcb      $41, $02                     ; $16 
                    fcb      $41, $02                     ; $17 
                    fcb      $88, $EF, $11, $02           ; $18 
                    fcb      $11, $02                     ; $19 
                    fcb      $08, $02                     ; $1A 
                    fcb      $41, $02                     ; $1B 
                    fcb      $88, $FF, $14, $02           ; $1C 
                    fcb      $14, $02                     ; $1D 
                    fcb      $41, $02                     ; $1E 
                    fcb      $41, $02                     ; $1F 
                    fcb      $9D, $94, $11, $02           ; $20 
                    fcb      $A0, $11, $02                ; $21 
                    fcb      $A4, $08, $02                ; $22 
                    fcb      $41, $02                     ; $23 
                    fcb      $88, $FF, $11, $02           ; $24 
                    fcb      $11, $02                     ; $25 
                    fcb      $41, $02                     ; $26 
                    fcb      $41, $02                     ; $27 
                    fcb      $88, $EF, $0F, $02           ; $28 
                    fcb      $0F, $02                     ; $29 
                    fcb      $14, $02                     ; $2A 
                    fcb      $41, $02                     ; $2B 
                    fcb      $88, $FF, $11, $02           ; $2C 
                    fcb      $11, $02                     ; $2D 
                    fcb      $41, $02                     ; $2E 
                    fcb      $41, $02                     ; $2F 
                    fcb      $9D, $88, $16, $02           ; $30 
                    fcb      $A0, $16, $02                ; $31 
                    fcb      $A4, $14, $02                ; $32 
                    fcb      $41, $02                     ; $33 
                    fcb      $88, $FF, $14, $02           ; $34 
                    fcb      $14, $02                     ; $35 
                    fcb      $41, $02                     ; $36 
                    fcb      $41, $02                     ; $37 
                    fcb      $88, $EF, $11, $02           ; $38 
                    fcb      $11, $02                     ; $39 
                    fcb      $08, $02                     ; $3A 
                    fcb      $41, $02                     ; $3B 
                    fcb      $88, $7F, $02                ; $3C 
                    fcb      $3f, $02                     ; $3D 
                    fcb      $14, $02                     ; $3E 
                    fcb      $41, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern16: 
                    fdb      adsr 
                    fdb      twang 
                    if       BANK=BANK_GREETINGS 
                    fcb      $9D, $FF, $11, $02           ; $00 
                    fcb      $A0, $11, $02                ; $01 
                    fcb      $A4, $03, $02                ; $02 
                    fcb      $41, $02                     ; $03 
                    fcb      $83, $FF, $11, $02           ; $04 
                    fcb      $11, $02                     ; $05 
                    fcb      $41, $02                     ; $06 
                    fcb      $41, $02                     ; $07 
                    fcb      $83, $EF, $0F, $02           ; $08 
                    fcb      $0F, $02                     ; $09 
                    fcb      $03, $02                     ; $0A 
                    fcb      $41, $02                     ; $0B 
                    fcb      $83, $FF, $11, $02           ; $0C 
                    fcb      $11, $02                     ; $0D 
                    fcb      $41, $02                     ; $0E 
                    fcb      $41, $02                     ; $0F 
                    fcb      $9D, $03, $02                ; $10 
                    fcb      $20, $02                     ; $11 
                    fcb      $A4, $0F, $02                ; $12 
                    fcb      $41, $02                     ; $13 
                    fcb      $83, $FF, $0F, $02           ; $14 
                    fcb      $0F, $02                     ; $15 
                    fcb      $41, $02                     ; $16 
                    fcb      $41, $02                     ; $17 
                    fcb      $83, $EF, $11, $02           ; $18 
                    fcb      $11, $02                     ; $19 
                    fcb      $03, $02                     ; $1A 
                    fcb      $41, $02                     ; $1B 
                    fcb      $83, $FF, $14, $02           ; $1C 
                    fcb      $14, $02                     ; $1D 
                    fcb      $41, $02                     ; $1E 
                    fcb      $41, $02                     ; $1F 
                    fcb      $9B, $8F, $16, $02           ; $20 
                    fcb      $9F, $16, $02                ; $21 
                    fcb      $A2, $83, $18, $02           ; $22 
                    fcb      $C1, $18, $02                ; $23 
                    fcb      $83, $7F, $02                ; $24 
                    fcb      $3f, $02                     ; $25 
                    fcb      $41, $02                     ; $26 
                    fcb      $41, $02                     ; $27 
                    fcb      $83, $EF, $16, $02           ; $28 
                    fcb      $16, $02                     ; $29 
                    fcb      $8F, $18, $02                ; $2A 
                    fcb      $C1, $18, $02                ; $2B 
                    fcb      $83, $7F, $02                ; $2C 
                    fcb      $3f, $02                     ; $2D 
                    fcb      $41, $02                     ; $2E 
                    fcb      $41, $02                     ; $2F 
                    fcb      $9B, $83, $16, $02           ; $30 
                    fcb      $9F, $16, $02                ; $31 
                    fcb      $A2, $0F, $02                ; $32 
                    fcb      $41, $02                     ; $33 
                    fcb      $83, $FF, $14, $02           ; $34 
                    fcb      $14, $02                     ; $35 
                    fcb      $41, $02                     ; $36 
                    fcb      $41, $02                     ; $37 
                    fcb      $83, $EF, $11, $02           ; $38 
                    fcb      $11, $02                     ; $39 
                    fcb      $03, $02                     ; $3A 
                    fcb      $41, $02                     ; $3B 
                    fcb      $83, $7F, $02                ; $3C 
                    fcb      $3f, $02                     ; $3D 
                    fcb      $0F, $02                     ; $3E 
                    fcb      $41, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
                    else     
                    fcb      $FF, $A2, $0C, $20           ; $00 
                    fcb      $00, $80                     ; end-marker 
                    endif    
pattern17: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $C1, $24, $02                ; $00 
                    fcb      $24, $02                     ; $01 
                    fcb      $3f, $02                     ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $24, $02                     ; $04 
                    fcb      $24, $02                     ; $05 
                    fcb      $18, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $18, $02                     ; $08 
                    fcb      $3f, $02                     ; $09 
                    fcb      $8C, $18, $02                ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $98, $1F, $02                ; $0C 
                    fcb      $1F, $02                     ; $0D 
                    fcb      $0C, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $C1, $1F, $02                ; $10 
                    fcb      $1F, $02                     ; $11 
                    fcb      $13, $02                     ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $93, $0C, $02                ; $14 
                    fcb      $0C, $02                     ; $15 
                    fcb      $87, $80, $13, $02           ; $16 
                    fcb      $00, $02                     ; $17 
                    fcb      $93, $8E, $22, $02           ; $18 
                    fcb      $8E, $22, $02                ; $19 
                    fcb      $87, $02, $02                ; $1A 
                    fcb      $02, $02                     ; $1B 
                    fcb      $8E, $22, $02                ; $1C 
                    fcb      $8E, $22, $02                ; $1D 
                    fcb      $82, $16, $02                ; $1E 
                    fcb      $02, $02                     ; $1F 
                    fcb      $96, $91, $41, $02           ; $20 
                    fcb      $11, $02                     ; $21 
                    fcb      $8A, $85, $16, $02           ; $22 
                    fcb      $05, $02                     ; $23 
                    fcb      $96, $8F, $1D, $02           ; $24 
                    fcb      $8F, $1D, $02                ; $25 
                    fcb      $8A, $03, $02                ; $26 
                    fcb      $03, $02                     ; $27 
                    fcb      $8F, $1D, $02                ; $28 
                    fcb      $8F, $1D, $02                ; $29 
                    fcb      $83, $11, $02                ; $2A 
                    fcb      $03, $02                     ; $2B 
                    fcb      $91, $0E, $02                ; $2C 
                    fcb      $0E, $02                     ; $2D 
                    fcb      $85, $82, $11, $02           ; $2E 
                    fcb      $02, $02                     ; $2F 
                    fcb      $91, $8E, $41, $02           ; $30 
                    fcb      $0E, $02                     ; $31 
                    fcb      $85, $02, $02                ; $32 
                    fcb      $02, $02                     ; $33 
                    fcb      $0E, $02                     ; $34 
                    fcb      $0E, $02                     ; $35 
                    fcb      $02, $02                     ; $36 
                    fcb      $02, $02                     ; $37 
                    fcb      $0C, $02                     ; $38 
                    fcb      $0C, $02                     ; $39 
                    fcb      $00, $02                     ; $3A 
                    fcb      $00, $02                     ; $3B 
                    fcb      $0C, $02                     ; $3C 
                    fcb      $0C, $02                     ; $3D 
                    fcb      $00, $02                     ; $3E 
                    fcb      $00, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern18: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $A4, $24, $02           ; $00 
                    fcb      $A7, $24, $02                ; $01 
                    fcb      $80, $AB, $00, $02           ; $02 
                    fcb      $C1, $80, $00, $02           ; $03 
                    fcb      $FF, $A4, $24, $02           ; $04 
                    fcb      $A7, $24, $02                ; $05 
                    fcb      $C1, $AB, $00, $02           ; $06 
                    fcb      $C1, $8C, $00, $02           ; $07 
                    fcb      $EF, $98, $00, $02           ; $08 
                    fcb      $98, $00, $02                ; $09 
                    fcb      $80, $8C, $00, $02           ; $0A 
                    fcb      $C1, $8C, $00, $02           ; $0B 
                    fcb      $FF, $98, $1F, $02           ; $0C 
                    fcb      $98, $1F, $02                ; $0D 
                    fcb      $C1, $8C, $00, $02           ; $0E 
                    fcb      $C1, $8C, $00, $02           ; $0F 
                    fcb      $80, $98, $1F, $02           ; $10 
                    fcb      $98, $1F, $02                ; $11 
                    fcb      $8C, $8C, $00, $02           ; $12 
                    fcb      $C1, $8C, $00, $02           ; $13 
                    fcb      $FF, $98, $00, $02           ; $14 
                    fcb      $98, $00, $02                ; $15 
                    fcb      $C1, $8C, $00, $02           ; $16 
                    fcb      $C1, $8C, $00, $02           ; $17 
                    fcb      $EF, $9A, $22, $02           ; $18 
                    fcb      $9A, $22, $02                ; $19 
                    fcb      $80, $8E, $00, $02           ; $1A 
                    fcb      $C1, $8E, $00, $02           ; $1B 
                    fcb      $FF, $9A, $22, $02           ; $1C 
                    fcb      $9A, $22, $02                ; $1D 
                    fcb      $C1, $8E, $00, $02           ; $1E 
                    fcb      $C1, $8E, $00, $02           ; $1F 
                    fcb      $8C, $9D, $00, $02           ; $20 
                    fcb      $9D, $00, $02                ; $21 
                    fcb      $80, $91, $00, $02           ; $22 
                    fcb      $C1, $91, $00, $02           ; $23 
                    fcb      $FF, $9B, $1D, $02           ; $24 
                    fcb      $9B, $1D, $02                ; $25 
                    fcb      $C1, $8F, $00, $02           ; $26 
                    fcb      $C1, $8F, $00, $02           ; $27 
                    fcb      $EF, $9B, $1D, $02           ; $28 
                    fcb      $9B, $1D, $02                ; $29 
                    fcb      $8C, $8F, $00, $02           ; $2A 
                    fcb      $C1, $8F, $00, $02           ; $2B 
                    fcb      $FF, $9A, $00, $02           ; $2C 
                    fcb      $9A, $00, $02                ; $2D 
                    fcb      $C1, $8E, $00, $02           ; $2E 
                    fcb      $C1, $8E, $00, $02           ; $2F 
                    fcb      $80, $A4, $1B, $02           ; $30 
                    fcb      $A7, $1B, $02                ; $31 
                    fcb      $8C, $AB, $00, $02           ; $32 
                    fcb      $C1, $80, $00, $02           ; $33 
                    fcb      $FF, $A4, $1B, $02           ; $34 
                    fcb      $A7, $1B, $02                ; $35 
                    fcb      $C1, $AB, $00, $02           ; $36 
                    fcb      $C1, $80, $00, $02           ; $37 
                    fcb      $EF, $83, $18, $02           ; $38 
                    fcb      $83, $18, $02                ; $39 
                    fcb      $80, $85, $00, $02           ; $3A 
                    fcb      $C1, $85, $00, $02           ; $3B 
                    fcb      $FF, $87, $00, $02           ; $3C 
                    fcb      $87, $00, $02                ; $3D 
                    fcb      $8C, $8A, $00, $02           ; $3E 
                    fcb      $C1, $8A, $00, $02           ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern19: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $A4, $24, $02           ; $00 
                    fcb      $A7, $24, $02                ; $01 
                    fcb      $80, $AB, $00, $02           ; $02 
                    fcb      $C1, $80, $00, $02           ; $03 
                    fcb      $FF, $A4, $24, $02           ; $04 
                    fcb      $A7, $24, $02                ; $05 
                    fcb      $C1, $AB, $00, $02           ; $06 
                    fcb      $C1, $8C, $00, $02           ; $07 
                    fcb      $EF, $98, $00, $02           ; $08 
                    fcb      $98, $00, $02                ; $09 
                    fcb      $80, $8C, $00, $02           ; $0A 
                    fcb      $C1, $8C, $00, $02           ; $0B 
                    fcb      $FF, $98, $1F, $02           ; $0C 
                    fcb      $98, $1F, $02                ; $0D 
                    fcb      $C1, $8C, $00, $02           ; $0E 
                    fcb      $C1, $8C, $00, $02           ; $0F 
                    fcb      $80, $98, $1F, $02           ; $10 
                    fcb      $98, $1F, $02                ; $11 
                    fcb      $8C, $8C, $00, $02           ; $12 
                    fcb      $C1, $8C, $00, $02           ; $13 
                    fcb      $FF, $98, $00, $02           ; $14 
                    fcb      $98, $00, $02                ; $15 
                    fcb      $C1, $8C, $00, $02           ; $16 
                    fcb      $C1, $8C, $00, $02           ; $17 
                    fcb      $EF, $9A, $22, $02           ; $18 
                    fcb      $9A, $22, $02                ; $19 
                    fcb      $80, $8E, $00, $02           ; $1A 
                    fcb      $C1, $8E, $00, $02           ; $1B 
                    fcb      $FF, $9A, $22, $02           ; $1C 
                    fcb      $9A, $22, $02                ; $1D 
                    fcb      $C1, $8E, $00, $02           ; $1E 
                    fcb      $C1, $8E, $00, $02           ; $1F 
                    fcb      $8C, $9D, $00, $02           ; $20 
                    fcb      $9D, $00, $02                ; $21 
                    fcb      $80, $91, $00, $02           ; $22 
                    fcb      $C1, $91, $00, $02           ; $23 
                    fcb      $FF, $9B, $1D, $02           ; $24 
                    fcb      $9B, $1D, $02                ; $25 
                    fcb      $C1, $8F, $00, $02           ; $26 
                    fcb      $C1, $8F, $00, $02           ; $27 
                    fcb      $EF, $9B, $1D, $02           ; $28 
                    fcb      $9B, $1D, $02                ; $29 
                    fcb      $8C, $8F, $00, $02           ; $2A 
                    fcb      $C1, $8F, $00, $02           ; $2B 
                    fcb      $FF, $9A, $00, $02           ; $2C 
                    fcb      $9A, $00, $02                ; $2D 
                    fcb      $C1, $8E, $00, $02           ; $2E 
                    fcb      $C1, $8E, $00, $02           ; $2F 
                    fcb      $80, $A2, $1B, $02           ; $30 
                    fcb      $A7, $1B, $02                ; $31 
                    fcb      $8C, $A9, $00, $02           ; $32 
                    fcb      $C1, $80, $00, $02           ; $33 
                    fcb      $FF, $A2, $1B, $02           ; $34 
                    fcb      $A7, $1B, $02                ; $35 
                    fcb      $C1, $A9, $00, $02           ; $36 
                    fcb      $C1, $80, $00, $02           ; $37 
                    fcb      $EF, $83, $18, $02           ; $38 
                    fcb      $83, $18, $02                ; $39 
                    fcb      $80, $85, $00, $02           ; $3A 
                    fcb      $C1, $85, $00, $02           ; $3B 
                    fcb      $FF, $87, $00, $02           ; $3C 
                    fcb      $87, $00, $02                ; $3D 
                    fcb      $8C, $8A, $00, $02           ; $3E 
                    fcb      $C1, $8A, $00, $02           ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern1A: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $C1, $24, $02                ; $00 
                    fcb      $3f, $02                     ; $01 
                    fcb      $3f, $02                     ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $24, $02                     ; $04 
                    fcb      $3f, $02                     ; $05 
                    fcb      $18, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $18, $02                     ; $08 
                    fcb      $3f, $02                     ; $09 
                    fcb      $8C, $18, $02                ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $18, $02                     ; $0C 
                    fcb      $3f, $02                     ; $0D 
                    fcb      $0C, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $41, $02                     ; $10 
                    fcb      $3f, $02                     ; $11 
                    fcb      $3f, $02                     ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $3f, $02                     ; $14 
                    fcb      $3f, $02                     ; $15 
                    fcb      $3f, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $22, $02                     ; $18 
                    fcb      $3f, $02                     ; $19 
                    fcb      $3f, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $22, $02                     ; $1C 
                    fcb      $3f, $02                     ; $1D 
                    fcb      $16, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $96, $41, $02                ; $20 
                    fcb      $3f, $02                     ; $21 
                    fcb      $8A, $16, $02                ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $16, $02                     ; $24 
                    fcb      $3f, $02                     ; $25 
                    fcb      $0A, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $3f, $02                     ; $28 
                    fcb      $3f, $02                     ; $29 
                    fcb      $3f, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $3f, $02                     ; $2C 
                    fcb      $3f, $02                     ; $2D 
                    fcb      $3f, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $8C, $41, $02                ; $30 
                    fcb      $0C, $02                     ; $31 
                    fcb      $00, $02                     ; $32 
                    fcb      $00, $02                     ; $33 
                    fcb      $0C, $02                     ; $34 
                    fcb      $0C, $02                     ; $35 
                    fcb      $00, $02                     ; $36 
                    fcb      $00, $02                     ; $37 
                    fcb      $0C, $02                     ; $38 
                    fcb      $0C, $02                     ; $39 
                    fcb      $00, $02                     ; $3A 
                    fcb      $00, $02                     ; $3B 
                    fcb      $0C, $02                     ; $3C 
                    fcb      $0C, $02                     ; $3D 
                    fcb      $00, $02                     ; $3E 
                    fcb      $00, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern1B: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $A4, $24, $02           ; $00 
                    fcb      $A7, $24, $02                ; $01 
                    fcb      $80, $AB, $00, $02           ; $02 
                    fcb      $80, $00, $02                ; $03 
                    fcb      $8C, $A4, $24, $02           ; $04 
                    fcb      $A7, $24, $02                ; $05 
                    fcb      $C1, $AB, $00, $02           ; $06 
                    fcb      $8C, $00, $02                ; $07 
                    fcb      $FF, $98, $00, $02           ; $08 
                    fcb      $98, $00, $02                ; $09 
                    fcb      $80, $8C, $00, $02           ; $0A 
                    fcb      $8C, $00, $02                ; $0B 
                    fcb      $FF, $98, $1F, $02           ; $0C 
                    fcb      $98, $1F, $02                ; $0D 
                    fcb      $C1, $8C, $00, $02           ; $0E 
                    fcb      $8C, $00, $02                ; $0F 
                    fcb      $EF, $98, $1F, $02           ; $10 
                    fcb      $98, $1F, $02                ; $11 
                    fcb      $80, $8C, $00, $02           ; $12 
                    fcb      $8C, $00, $02                ; $13 
                    fcb      $FF, $98, $00, $02           ; $14 
                    fcb      $98, $00, $02                ; $15 
                    fcb      $C1, $8C, $00, $02           ; $16 
                    fcb      $8C, $00, $02                ; $17 
                    fcb      $FF, $9A, $22, $02           ; $18 
                    fcb      $9A, $22, $02                ; $19 
                    fcb      $80, $8E, $00, $02           ; $1A 
                    fcb      $8E, $00, $02                ; $1B 
                    fcb      $8C, $9A, $22, $02           ; $1C 
                    fcb      $9A, $22, $02                ; $1D 
                    fcb      $C1, $8E, $00, $02           ; $1E 
                    fcb      $8E, $00, $02                ; $1F 
                    fcb      $FF, $9D, $00, $02           ; $20 
                    fcb      $9D, $00, $02                ; $21 
                    fcb      $80, $91, $00, $02           ; $22 
                    fcb      $91, $00, $02                ; $23 
                    fcb      $80, $9B, $1D, $02           ; $24 
                    fcb      $9B, $1D, $02                ; $25 
                    fcb      $C1, $8F, $00, $02           ; $26 
                    fcb      $8F, $00, $02                ; $27 
                    fcb      $FF, $9B, $1D, $02           ; $28 
                    fcb      $9B, $1D, $02                ; $29 
                    fcb      $80, $8F, $00, $02           ; $2A 
                    fcb      $8F, $00, $02                ; $2B 
                    fcb      $80, $9A, $00, $02           ; $2C 
                    fcb      $9A, $00, $02                ; $2D 
                    fcb      $C1, $8E, $00, $02           ; $2E 
                    fcb      $8E, $00, $02                ; $2F 
                    fcb      $EF, $A2, $00, $02           ; $30 
                    fcb      $27, $02                     ; $31 
                    fcb      $80, $29, $02                ; $32 
                    fcb      $00, $02                     ; $33 
                    fcb      $22, $02                     ; $34 
                    fcb      $27, $02                     ; $35 
                    fcb      $29, $02                     ; $36 
                    fcb      $00, $02                     ; $37 
                    fcb      $C1, $03, $02                ; $38 
                    fcb      $03, $02                     ; $39 
                    fcb      $00, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $6F, $02                     ; $3C 
                    fcb      $3f, $02                     ; $3D 
                    fcb      $41, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern1C: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $C1, $24, $02                ; $00 
                    fcb      $3f, $02                     ; $01 
                    fcb      $3f, $02                     ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $24, $02                     ; $04 
                    fcb      $3f, $02                     ; $05 
                    fcb      $18, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $18, $02                     ; $08 
                    fcb      $3f, $02                     ; $09 
                    fcb      $8C, $18, $02                ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $18, $02                     ; $0C 
                    fcb      $3f, $02                     ; $0D 
                    fcb      $0C, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $41, $02                     ; $10 
                    fcb      $3f, $02                     ; $11 
                    fcb      $3f, $02                     ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $3f, $02                     ; $14 
                    fcb      $3f, $02                     ; $15 
                    fcb      $3f, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $3f, $02                     ; $18 
                    fcb      $3f, $02                     ; $19 
                    fcb      $3f, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $3f, $02                     ; $1C 
                    fcb      $3f, $02                     ; $1D 
                    fcb      $3f, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $41, $02                     ; $20 
                    fcb      $3f, $02                     ; $21 
                    fcb      $3f, $02                     ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $3f, $02                     ; $24 
                    fcb      $3f, $02                     ; $25 
                    fcb      $3f, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $3f, $02                     ; $28 
                    fcb      $3f, $02                     ; $29 
                    fcb      $3f, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $3f, $02                     ; $2C 
                    fcb      $3f, $02                     ; $2D 
                    fcb      $3f, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $8C, $41, $02                ; $30 
                    fcb      $0C, $02                     ; $31 
                    fcb      $00, $02                     ; $32 
                    fcb      $00, $02                     ; $33 
                    fcb      $0C, $02                     ; $34 
                    fcb      $0C, $02                     ; $35 
                    fcb      $00, $02                     ; $36 
                    fcb      $00, $02                     ; $37 
                    fcb      $0C, $02                     ; $38 
                    fcb      $0C, $02                     ; $39 
                    fcb      $00, $02                     ; $3A 
                    fcb      $00, $02                     ; $3B 
                    fcb      $0C, $02                     ; $3C 
                    fcb      $0C, $02                     ; $3D 
                    fcb      $00, $02                     ; $3E 
                    fcb      $00, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern1D: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $C1, $24, $02                ; $00 
                    fcb      $24, $02                     ; $01 
                    fcb      $3f, $02                     ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $24, $02                     ; $04 
                    fcb      $24, $02                     ; $05 
                    fcb      $18, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $98, $41, $02                ; $08 
                    fcb      $3f, $02                     ; $09 
                    fcb      $8C, $18, $02                ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $98, $1F, $02                ; $0C 
                    fcb      $1F, $02                     ; $0D 
                    fcb      $0C, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $C1, $1F, $02                ; $10 
                    fcb      $1F, $02                     ; $11 
                    fcb      $13, $02                     ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $93, $0C, $02                ; $14 
                    fcb      $0C, $02                     ; $15 
                    fcb      $87, $80, $13, $02           ; $16 
                    fcb      $00, $02                     ; $17 
                    fcb      $C1, $8E, $22, $02           ; $18 
                    fcb      $8E, $22, $02                ; $19 
                    fcb      $87, $02, $02                ; $1A 
                    fcb      $02, $02                     ; $1B 
                    fcb      $8E, $22, $02                ; $1C 
                    fcb      $8E, $22, $02                ; $1D 
                    fcb      $82, $16, $02                ; $1E 
                    fcb      $02, $02                     ; $1F 
                    fcb      $96, $91, $41, $02           ; $20 
                    fcb      $11, $02                     ; $21 
                    fcb      $8A, $85, $16, $02           ; $22 
                    fcb      $05, $02                     ; $23 
                    fcb      $96, $8F, $1D, $02           ; $24 
                    fcb      $8F, $1D, $02                ; $25 
                    fcb      $8A, $03, $02                ; $26 
                    fcb      $03, $02                     ; $27 
                    fcb      $C1, $8F, $1D, $02           ; $28 
                    fcb      $8F, $1D, $02                ; $29 
                    fcb      $83, $11, $02                ; $2A 
                    fcb      $03, $02                     ; $2B 
                    fcb      $91, $0E, $02                ; $2C 
                    fcb      $0E, $02                     ; $2D 
                    fcb      $85, $82, $11, $02           ; $2E 
                    fcb      $02, $02                     ; $2F 
                    fcb      $91, $8E, $41, $02           ; $30 
                    fcb      $0E, $02                     ; $31 
                    fcb      $85, $02, $02                ; $32 
                    fcb      $02, $02                     ; $33 
                    fcb      $0E, $02                     ; $34 
                    fcb      $0E, $02                     ; $35 
                    fcb      $02, $02                     ; $36 
                    fcb      $02, $02                     ; $37 
                    fcb      $8C, $41, $02                ; $38 
                    fcb      $0C, $02                     ; $39 
                    fcb      $00, $02                     ; $3A 
                    fcb      $00, $02                     ; $3B 
                    fcb      $0C, $02                     ; $3C 
                    fcb      $0C, $02                     ; $3D 
                    fcb      $00, $02                     ; $3E 
                    fcb      $00, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern1E: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $9D, $91, $05, $02           ; $00 
                    fcb      $A0, $11, $02                ; $01 
                    fcb      $24, $02                     ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $85, $11, $02                ; $04 
                    fcb      $11, $02                     ; $05 
                    fcb      $3f, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $85, $0F, $02                ; $08 
                    fcb      $0F, $02                     ; $09 
                    fcb      $3f, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $85, $11, $02                ; $0C 
                    fcb      $11, $02                     ; $0D 
                    fcb      $3f, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $1D, $02                     ; $10 
                    fcb      $20, $02                     ; $11 
                    fcb      $24, $02                     ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $05, $02                     ; $14 
                    fcb      $3f, $02                     ; $15 
                    fcb      $3f, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $05, $02                     ; $18 
                    fcb      $3f, $02                     ; $19 
                    fcb      $3f, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $05, $02                     ; $1C 
                    fcb      $3f, $02                     ; $1D 
                    fcb      $3f, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $9D, $41, $02                ; $20 
                    fcb      $20, $02                     ; $21 
                    fcb      $24, $02                     ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $3f, $02                     ; $24 
                    fcb      $3f, $02                     ; $25 
                    fcb      $3f, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $3f, $02                     ; $28 
                    fcb      $3f, $02                     ; $29 
                    fcb      $3f, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $3f, $02                     ; $2C 
                    fcb      $3f, $02                     ; $2D 
                    fcb      $3f, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $41, $02                     ; $30 
                    fcb      $3f, $02                     ; $31 
                    fcb      $3f, $02                     ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $3f, $02                     ; $34 
                    fcb      $3f, $02                     ; $35 
                    fcb      $3f, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $3f, $02                     ; $38 
                    fcb      $3f, $02                     ; $39 
                    fcb      $3f, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $3f, $02                     ; $3C 
                    fcb      $3f, $02                     ; $3D 
                    fcb      $3f, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern1F: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $41, $02                     ; $00 
                    fcb      $3f, $02                     ; $01 
                    fcb      $3f, $02                     ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $3f, $02                     ; $04 
                    fcb      $3f, $02                     ; $05 
                    fcb      $3f, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $3f, $02                     ; $08 
                    fcb      $3f, $02                     ; $09 
                    fcb      $3f, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $3f, $02                     ; $0C 
                    fcb      $3f, $02                     ; $0D 
                    fcb      $3f, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $41, $02                     ; $10 
                    fcb      $3f, $02                     ; $11 
                    fcb      $3f, $02                     ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $3f, $02                     ; $14 
                    fcb      $3f, $02                     ; $15 
                    fcb      $3f, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $3f, $02                     ; $18 
                    fcb      $3f, $02                     ; $19 
                    fcb      $3f, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $3f, $02                     ; $1C 
                    fcb      $3f, $02                     ; $1D 
                    fcb      $3f, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $41, $02                     ; $20 
                    fcb      $3f, $02                     ; $21 
                    fcb      $3f, $02                     ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $3f, $02                     ; $24 
                    fcb      $3f, $02                     ; $25 
                    fcb      $3f, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $3f, $02                     ; $28 
                    fcb      $3f, $02                     ; $29 
                    fcb      $3f, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $3f, $02                     ; $2C 
                    fcb      $3f, $02                     ; $2D 
                    fcb      $3f, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $41, $02                     ; $30 
                    fcb      $3f, $02                     ; $31 
                    fcb      $3f, $02                     ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $3f, $02                     ; $34 
                    fcb      $3f, $02                     ; $35 
                    fcb      $3f, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $3f, $02                     ; $38 
                    fcb      $3f, $02                     ; $39 
                    fcb      $3f, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $3f, $02                     ; $3C 
                    fcb      $3f, $02                     ; $3D 
                    fcb      $3f, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern20: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $8C, $0C, $02           ; $00 
                    fcb      $8C, $0C, $02                ; $01 
                    fcb      $00, $02                     ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $8C, $0C, $02                ; $04 
                    fcb      $0C, $02                     ; $05 
                    fcb      $41, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $7F, $02                     ; $08 
                    fcb      $3f, $02                     ; $09 
                    fcb      $00, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $FF, $87, $07, $02           ; $0C 
                    fcb      $87, $07, $02                ; $0D 
                    fcb      $41, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $EF, $07, $02                ; $10 
                    fcb      $07, $02                     ; $11 
                    fcb      $00, $02                     ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $7F, $02                     ; $14 
                    fcb      $3f, $02                     ; $15 
                    fcb      $41, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $FF, $8A, $0A, $02           ; $18 
                    fcb      $8A, $0A, $02                ; $19 
                    fcb      $00, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $8C, $0A, $02                ; $1C 
                    fcb      $0A, $02                     ; $1D 
                    fcb      $41, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $7F, $02                     ; $20 
                    fcb      $3f, $02                     ; $21 
                    fcb      $00, $02                     ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $80, $85, $05, $02           ; $24 
                    fcb      $85, $05, $02                ; $25 
                    fcb      $41, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $FF, $05, $02                ; $28 
                    fcb      $05, $02                     ; $29 
                    fcb      $00, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $00, $02                     ; $2C 
                    fcb      $3f, $02                     ; $2D 
                    fcb      $41, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $EF, $83, $03, $02           ; $30 
                    fcb      $83, $03, $02                ; $31 
                    fcb      $00, $02                     ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $80, $03, $02                ; $34 
                    fcb      $03, $02                     ; $35 
                    fcb      $41, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $FF, $80, $00, $02           ; $38 
                    fcb      $80, $00, $02                ; $39 
                    fcb      $00, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $7F, $02                     ; $3C 
                    fcb      $3f, $02                     ; $3D 
                    fcb      $41, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern21: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $80, $00, $02           ; $00 
                    fcb      $80, $00, $02                ; $01 
                    fcb      $41, $02                     ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $C1, $00, $02                ; $04 
                    fcb      $00, $02                     ; $05 
                    fcb      $41, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $FF, $00, $02                ; $08 
                    fcb      $00, $02                     ; $09 
                    fcb      $41, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $7F, $02                     ; $0C 
                    fcb      $3f, $02                     ; $0D 
                    fcb      $41, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $6F, $02                     ; $10 
                    fcb      $3f, $02                     ; $11 
                    fcb      $41, $02                     ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $7F, $02                     ; $14 
                    fcb      $3f, $02                     ; $15 
                    fcb      $41, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $FF, $80, $00, $02           ; $18 
                    fcb      $80, $00, $02                ; $19 
                    fcb      $41, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $C1, $00, $02                ; $1C 
                    fcb      $00, $02                     ; $1D 
                    fcb      $41, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $FF, $80, $00, $02           ; $20 
                    fcb      $80, $00, $02                ; $21 
                    fcb      $41, $02                     ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $C1, $00, $02                ; $24 
                    fcb      $00, $02                     ; $25 
                    fcb      $41, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $FF, $00, $02                ; $28 
                    fcb      $00, $02                     ; $29 
                    fcb      $41, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $41, $02                     ; $2C 
                    fcb      $3f, $02                     ; $2D 
                    fcb      $41, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $EF, $80, $00, $02           ; $30 
                    fcb      $80, $00, $02                ; $31 
                    fcb      $41, $02                     ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $C1, $00, $02                ; $34 
                    fcb      $00, $02                     ; $35 
                    fcb      $41, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $FF, $00, $02                ; $38 
                    fcb      $00, $02                     ; $39 
                    fcb      $41, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $7F, $02                     ; $3C 
                    fcb      $3f, $02                     ; $3D 
                    fcb      $41, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
pattern22: 
                    fdb      adsr 
                    fdb      twang 
                    fcb      $FF, $80, $00, $02           ; $00 
                    fcb      $80, $00, $02                ; $01 
                    fcb      $41, $02                     ; $02 
                    fcb      $3f, $02                     ; $03 
                    fcb      $C1, $00, $02                ; $04 
                    fcb      $00, $02                     ; $05 
                    fcb      $41, $02                     ; $06 
                    fcb      $3f, $02                     ; $07 
                    fcb      $FF, $00, $02                ; $08 
                    fcb      $00, $02                     ; $09 
                    fcb      $41, $02                     ; $0A 
                    fcb      $3f, $02                     ; $0B 
                    fcb      $7F, $02                     ; $0C 
                    fcb      $3f, $02                     ; $0D 
                    fcb      $41, $02                     ; $0E 
                    fcb      $3f, $02                     ; $0F 
                    fcb      $6F, $02                     ; $10 
                    fcb      $3f, $02                     ; $11 
                    fcb      $41, $02                     ; $12 
                    fcb      $3f, $02                     ; $13 
                    fcb      $7F, $02                     ; $14 
                    fcb      $3f, $02                     ; $15 
                    fcb      $41, $02                     ; $16 
                    fcb      $3f, $02                     ; $17 
                    fcb      $FF, $80, $00, $02           ; $18 
                    fcb      $80, $00, $02                ; $19 
                    fcb      $41, $02                     ; $1A 
                    fcb      $3f, $02                     ; $1B 
                    fcb      $C1, $00, $02                ; $1C 
                    fcb      $00, $02                     ; $1D 
                    fcb      $41, $02                     ; $1E 
                    fcb      $3f, $02                     ; $1F 
                    fcb      $FF, $80, $00, $02           ; $20 
                    fcb      $80, $00, $02                ; $21 
                    fcb      $3f, $02                     ; $22 
                    fcb      $3f, $02                     ; $23 
                    fcb      $00, $02                     ; $24 
                    fcb      $00, $02                     ; $25 
                    fcb      $3f, $02                     ; $26 
                    fcb      $3f, $02                     ; $27 
                    fcb      $00, $02                     ; $28 
                    fcb      $00, $02                     ; $29 
                    fcb      $3f, $02                     ; $2A 
                    fcb      $3f, $02                     ; $2B 
                    fcb      $3f, $02                     ; $2C 
                    fcb      $3f, $02                     ; $2D 
                    fcb      $3f, $02                     ; $2E 
                    fcb      $3f, $02                     ; $2F 
                    fcb      $80, $00, $02                ; $30 
                    fcb      $80, $00, $02                ; $31 
                    fcb      $3f, $02                     ; $32 
                    fcb      $3f, $02                     ; $33 
                    fcb      $00, $02                     ; $34 
                    fcb      $00, $02                     ; $35 
                    fcb      $3f, $02                     ; $36 
                    fcb      $3f, $02                     ; $37 
                    fcb      $00, $02                     ; $38 
                    fcb      $00, $02                     ; $39 
                    fcb      $3f, $02                     ; $3A 
                    fcb      $3f, $02                     ; $3B 
                    fcb      $3f, $02                     ; $3C 
                    fcb      $3f, $02                     ; $3D 
                    fcb      $3f, $02                     ; $3E 
                    fcb      $3f, $02                     ; $3F 
                    fcb      $00, $80                     ; end-marker 
