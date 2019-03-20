;
;
;         IF      L.PRS = OFF      ;-------------------------------------------
;         LIST    -L               ;--  PRSPCT  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  ***********************************************************************
;  ***********************************************************************
;  ***                                                                 ***
;  ***          P E R S P E C T I V E   I N F O R M A T I O N          ***
;  ***                                                                 ***
;  ***********************************************************************
;  ***********************************************************************
;
;
;  BLASTER COLLISION BOX VALUES
;  ============================
;
BL_BOX   DW      $0E0C            ;  POSITIVE VERTICAL POSITION $00 - $07
         DW      $0E0C            ;  .                          $08 - $0F
         DW      $0E0C            ;  .                          $10 - $17
         DW      $0E0C            ;  .                          $18 - $1F
         DW      $0D0A            ;  .                          $20 - $27
         DW      $0D0A            ;  .                          $28 - $2F
         DW      $0D0A            ;  .                          $30 - $37
         DW      $0D0A            ;  .                          $38 - $3F
         DW      $0C09            ;  .                          $40 - $47
         DW      $0C09            ;  .                          $48 - $4F
         DW      $0C09            ;  .                          $50 - $57
         DW      $0C09            ;  .                          $58 - $5F
         DW      $0B08            ;  .                          $60 - $67
         DW      $0B08            ;  .                          $68 - $6F
         DW      $0B08            ;  .                          $70 - $77
         DW      $0B08            ;  .                          $78 - $7F
         DW      $0A07            ;  .                          $80 - $87
         DW      $0A07            ;  .                          $88 - $8F
         DW      $0A07            ;  .                          $90 - $97
         DW      $0A07            ;  .                          $98 - $9F
         DW      $0906            ;  .                          $A0 - $A7
         DW      $0906            ;  .                          $A8 - $AF
         DW      $0906            ;  .                          $B0 - $B7
         DW      $0906            ;  .                          $B8 - $BF
         DW      $0805            ;  .                          $C0 - $C7
         DW      $0805            ;  .                          $C8 - $CF
         DW      $0805            ;  .                          $D0 - $D7
         DW      $0805            ;  .                          $D8 - $DF
         DW      $0704            ;  .                          $E0 - $E7
         DW      $0704            ;  .                          $E8 - $EF
         DW      $0704            ;  .                          $F0 - $F7
         DW      $0704            ;  .                          $F8 - $FF
;
;
;  GUARDIAN / SPIKER SIZE
;  ======================
;
G_SIZ    DB      $40              ;  POSITIVE VERTICAL POSITION $00 - $07
         DB      $40              ;  .                          $08 - $0F
         DB      $40              ;  .                          $10 - $17
         DB      $3E              ;  .                          $18 - $1F
         DB      $3C              ;  .                          $20 - $27
         DB      $3A              ;  .                          $28 - $2F
         DB      $38              ;  .                          $30 - $37
         DB      $36              ;  .                          $38 - $3F
         DB      $34              ;  .                          $40 - $47
         DB      $32              ;  .                          $48 - $4F
         DB      $30              ;  .                          $50 - $57
         DB      $2E              ;  .                          $58 - $5F
         DB      $2C              ;  .                          $60 - $67
         DB      $2A              ;  .                          $68 - $6F
         DB      $28              ;  .                          $70 - $77
         DB      $26              ;  .                          $78 - $7F
         DB      $24              ;  .                          $80 - $87
         DB      $22              ;  .                          $88 - $8F
         DB      $20              ;  .                          $90 - $97
         DB      $1E              ;  .                          $98 - $9F
         DB      $1C              ;  .                          $A0 - $A7
         DB      $1A              ;  .                          $A8 - $AF
         DB      $18              ;  .                          $B0 - $B7
         DB      $16              ;  .                          $B8 - $BF
         DB      $14              ;  .                          $C0 - $C7
         DB      $12              ;  .                          $C8 - $CF
         DB      $10              ;  .                          $D0 - $D7
         DB      $0E              ;  .                          $D8 - $DF
         DB      $0C              ;  .                          $E0 - $E7
         DB      $0C              ;  .                          $E8 - $EF
         DB      $0C              ;  .                          $F0 - $F7
         DB      $0C              ;  .    USED BY BLASTER       $F8 - $FF
         DB      $0C              ;  .    .
         DB      $08              ;  .    .
         DB      $08              ;  .    .
         DB      $08              ;  .    .
         DB      $08              ;  .    .
;
;
;  GUARDIAN ENERGY LEVELS
;  ======================
;
G_ERG    DB      $38
         DB      $40
         DB      $48
         DB      $50
         DB      $58
         DB      $60
         DB      $68
         DB      $70
;
;
;  WAR-BIRD / SHIELD SIZE
;  ======================
;
BR_SIZ   DB      $40              ;  POSITIVE VERTICAL POSITION $00 - $07
         DB      $40              ;  .                          $08 - $0F
         DB      $40              ;  .                          $10 - $17
         DB      $40              ;  .                          $18 - $1F
         DB      $40              ;  .                          $20 - $27
         DB      $3E              ;  .                          $28 - $2F
         DB      $3C              ;  .                          $30 - $37
         DB      $3A              ;  .                          $38 - $3F
         DB      $38              ;  .                          $40 - $47
         DB      $36              ;  .                          $48 - $4F
         DB      $34              ;  .                          $50 - $57
         DB      $32              ;  .                          $58 - $5F
         DB      $30              ;  .                          $60 - $67
         DB      $2E              ;  .                          $68 - $6F
         DB      $2C              ;  .                          $70 - $77
         DB      $2A              ;  .                          $78 - $7F
         DB      $28              ;  .                          $80 - $87
         DB      $24              ;  .                          $88 - $8F
         DB      $24              ;  .                          $90 - $97
         DB      $22              ;  .                          $98 - $9F
         DB      $20              ;  .                          $A0 - $A7
         DB      $1E              ;  .                          $A8 - $AF
         DB      $1C              ;  .                          $B0 - $B7
         DB      $1A              ;  .                          $B8 - $BF
         DB      $18              ;  .                          $C0 - $C7
         DB      $16              ;  .                          $C8 - $CF
         DB      $14              ;  .                          $D0 - $D7
         DB      $12              ;  .                          $D8 - $DF
         DB      $12              ;  .                          $E0 - $E7
         DB      $10              ;  .                          $E8 - $EF
         DB      $10              ;  .                          $F0 - $F7
         DB      $10              ;  .                          $F8 - $FF
;
;
;  WAR-BIRD COLLISION BOX VALUES
;  =============================
;
BR_BOX   DB      $0F              ;  POSITIVE VERTICAL POSITION $00 - $07
         DB      $0F              ;  .                          $08 - $0F
         DB      $0F              ;  .                          $10 - $17
         DB      $0F              ;  .                          $18 - $1F
         DB      $0F              ;  .                          $20 - $27
         DB      $0E              ;  .                          $28 - $2F
         DB      $0E              ;  .                          $30 - $37
         DB      $0E              ;  .                          $38 - $3F
         DB      $0D              ;  .                          $40 - $47
         DB      $0D              ;  .                          $48 - $4F
         DB      $0D              ;  .                          $50 - $57
         DB      $0C              ;  .                          $58 - $5F
         DB      $0C              ;  .                          $60 - $67
         DB      $0B              ;  .                          $68 - $6F
         DB      $0B              ;  .                          $70 - $77
         DB      $0A              ;  .                          $78 - $7F
         DB      $0A              ;  .                          $80 - $87
         DB      $09              ;  .                          $88 - $8F
         DB      $09              ;  .                          $90 - $97
         DB      $08              ;  .                          $98 - $9F
         DB      $08              ;  .                          $A0 - $A7
         DB      $07              ;  .                          $A8 - $AF
         DB      $07              ;  .                          $B0 - $B7
         DB      $06              ;  .                          $B8 - $BF
         DB      $06              ;  .                          $C0 - $C7 
         DB      $06              ;  .                          $C8 - $CF
         DB      $06              ;  .                          $D0 - $D7
         DB      $06              ;  .                          $D8 - $DF
         DB      $06              ;  .                          $E0 - $E7
         DB      $06              ;  .                          $E8 - $EF
         DB      $06              ;  .                          $F0 - $F7
         DB      $06              ;  .                          $F8 - $FF
;
;
;  BULLET INTENSITY
;  ================
;
B_INT    DB      7                ;  POSITIVE VERTICAL POSITION $00 - $07
         DB      7                ;  .                          $08 - $0F
         DB      7                ;  .                          $10 - $17
         DB      7                ;  .                          $18 - $1F
         DB      7                ;  .                          $20 - $27
         DB      6                ;  .                          $28 - $2F
         DB      6                ;  .                          $30 - $37
         DB      6                ;  .                          $38 - $3F
         DB      6                ;  .                          $40 - $47
         DB      6                ;  .                          $48 - $4F
         DB      5                ;  .                          $50 - $57
         DB      5                ;  .                          $58 - $5F
         DB      5                ;  .                          $60 - $67
         DB      5                ;  .                          $68 - $6F
         DB      4                ;  .                          $70 - $77
         DB      4                ;  .                          $78 - $7F
         DB      4                ;  .                          $80 - $87
         DB      4                ;  .                          $88 - $8F
         DB      3                ;  .                          $90 - $97
         DB      3                ;  .                          $98 - $9F
         DB      3                ;  .                          $A0 - $A7
         DB      3                ;  .                          $A8 - $AF
         DB      2                ;  .                          $B0 - $B7
         DB      2                ;  .                          $B8 - $BF
         DB      2                ;  .                          $C0 - $C7
         DB      2                ;  .                          $C8 - $CF
         DB      1                ;  .                          $D0 - $D7
         DB      1                ;  .                          $D8 - $DF
         DB      0                ;  .                          $E0 - $E7
         DB      0                ;  .                          $E8 - $EF
         DB      0                ;  .                          $F0 - $F7
         DB      0                ;  .                          $F8 - $FF
;
;
;  BULLET INTENSITY FOR KILLER SEQUENCE
;  ====================================
;
K_INT    DB      7                ;  POSITIVE VERTICAL POSITION $00 - $07
         DB      7                ;  .                          $08 - $0F
         DB      7                ;  .                          $10 - $17
         DB      7                ;  .                          $18 - $1F
         DB      7                ;  .                          $20 - $27
         DB      6                ;  .                          $28 - $2F
         DB      6                ;  .                          $30 - $37
         DB      6                ;  .                          $38 - $3F
         DB      6                ;  .                          $40 - $47
         DB      6                ;  .                          $48 - $4F
         DB      5                ;  .                          $50 - $57
         DB      5                ;  .                          $58 - $5F
         DB      5                ;  .                          $60 - $67
         DB      5                ;  .                          $68 - $6F
         DB      4                ;  .                          $70 - $77
         DB      0                ;  .                          $78 - $7F
         DB      0                ;  .                          $80 - $87
         DB      0                ;  .                          $88 - $8F
         DB      0                ;  .                          $90 - $97
;
;
;  BULLET ENERGY LEVELS
;  ====================
;
B_ERG    DB      $00
         DB      $48
         DB      $50
         DB      $58
         DB      $60
         DB      $68
         DB      $70
         DB      $78
;
;
;  RIGHT WALL TRAVEL LIMITS
;  ========================
;
LR_LIM   DB      $48              ;  POSITIVE VERTICAL POSITION $00 - $07
         DB      $44              ;  .                          $08 - $0F
         DB      $40              ;  .                          $10 - $17
         DB      $3B              ;  .                          $18 - $1F
         DB      $36              ;  .                          $20 - $27
         DB      $31              ;  .                          $28 - $2F
         DB      $2C              ;  .                          $30 - $37
         DB      $28              ;  .                          $38 - $3F
         DB      $24              ;  .                          $40 - $47
         DB      $1F              ;  .                          $48 - $4F
         DB      $1A              ;  .                          $50 - $57
         DB      $1B              ;  .                          $58 - $5F
         DB      $1C              ;  .                          $60 - $67
         DB      $21              ;  .                          $68 - $6F
         DB      $26              ;  .                          $70 - $77
         DB      $2B              ;  .                          $78 - $7F
         DB      $30              ;  .                          $80 - $87
         DB      $33              ;  .                          $88 - $8F
         DB      $36              ;  .                          $90 - $97
         DB      $35              ;  .                          $98 - $9F
         DB      $34              ;  .                          $A0 - $A7
         DB      $2D              ;  .                          $A8 - $AF
         DB      $26              ;  .                          $B0 - $B7
         DB      $21              ;  .                          $B8 - $BF
         DB      $1C              ;  .                          $C0 - $C7
         DB      $16              ;  .                          $C8 - $CF
         DB      $10              ;  .                          $D0 - $D7
         DB      $10              ;  .                          $D8 - $DF
         DB      $10              ;  .                          $E0 - $E7
         DB      $10              ;  .                          $E8 - $EF
         DB      $10              ;  .                          $F0 - $F7
         DB      $10              ;  .                          $F8 - $FF
;
;
;  LEFT WALL TRAVEL LIMITS
;  =======================
;
LL_LIM   DB      $B0              ;  POSITIVE VERTICAL POSITION $00 - $07
         DB      $B2              ;  .                          $08 - $0F
         DB      $B4              ;  .                          $10 - $17
         DB      $B6              ;  .                          $18 - $1F
         DB      $B8              ;  .                          $20 - $27
         DB      $BA              ;  .                          $28 - $2F
         DB      $BC              ;  .                          $30 - $37
         DB      $BE              ;  .                          $38 - $3F
         DB      $C0              ;  .                          $40 - $47
         DB      $C3              ;  .                          $48 - $4F
         DB      $C6              ;  .                          $50 - $57
         DB      $C7              ;  .                          $58 - $5F
         DB      $C8              ;  .                          $60 - $67
         DB      $CF              ;  .                          $68 - $6F
         DB      $D6              ;  .                          $70 - $77
         DB      $DE              ;  .                          $78 - $7F
         DB      $E6              ;  .                          $80 - $87
         DB      $F0              ;  .                          $88 - $8F
         DB      $FA              ;  .                          $90 - $97
         DB      $00              ;  .                          $98 - $9F
         DB      $06              ;  .                          $A0 - $A7 
         DB      $04              ;  .                          $A8 - $AF
         DB      $02              ;  .                          $B0 - $B7
         DB      $FF              ;  .                          $B8 - $BF
         DB      $FC              ;  .                          $C0 - $C7
         DB      $F9              ;  .                          $C8 - $CF
         DB      $F6              ;  .                          $D0 - $D7
         DB      $F6              ;  .                          $D8 - $DF
         DB      $F6              ;  .                          $E0 - $E7
         DB      $F6              ;  .                          $E8 - $EF
         DB      $F6              ;  .                          $F0 - $F7
         DB      $F6              ;  .                          $F8 - $FF
;
;
;  RIGHT WALL HIDDEN ROADWAY LIMITS
;  ================================
;
HR_LIM   DB      $68              ;  POSITIVE VERTICAL POSITION $00 - $07
         DB      $64              ;  .                          $08 - $0F
         DB      $60              ;  .                          $10 - $17
         DB      $5B              ;  .                          $18 - $1F
         DB      $56              ;  .                          $20 - $27
         DB      $51              ;  .                          $28 - $2F
         DB      $4C              ;  .                          $30 - $37
         DB      $48              ;  .                          $38 - $3F
         DB      $44              ;  .                          $40 - $47
         DB      $3F              ;  .                          $48 - $4F
         DB      $3A              ;  .                          $50 - $57
         DB      $1A              ;  .                          $58 - $5F*
         DB      $1A              ;  .                          $60 - $67*
         DB      $1A              ;  .                          $68 - $6F*
         DB      $1A              ;  .                          $70 - $77*
         DB      $1A              ;  .                          $78 - $7F*
         DB      $1E              ;  .                          $80 - $87*
         DB      $24              ;  .                          $88 - $8F*
         DB      $28              ;  .                          $90 - $97*
         DB      $2E              ;  .                          $98 - $9F*
         DB      $33              ;  .                          $A0 - $A7*
         DB      $4D              ;  .                          $A8 - $AF
         DB      $46              ;  .                          $B0 - $B7
         DB      $41              ;  .                          $B8 - $BF
         DB      $3C              ;  .                          $C0 - $C7
         DB      $36              ;  .                          $C8 - $CF
         DB      $30              ;  .                          $D0 - $D7
         DB      $30              ;  .                          $D8 - $DF
         DB      $30              ;  .                          $E0 - $E7
         DB      $30              ;  .                          $E8 - $EF
         DB      $30              ;  .                          $F0 - $F7
         DB      $30              ;  .                          $F8 - $FF
;
;
;  LEFT WALL HIDDEN ROADWAY LIMITS
;  ===============================
;
HL_LIM   DB      $90              ;  POSITIVE VERTICAL POSITION $00 - $07
         DB      $92              ;  .                          $08 - $0F
         DB      $94              ;  .                          $10 - $17
         DB      $96              ;  .                          $18 - $1F
         DB      $98              ;  .                          $20 - $27
         DB      $9A              ;  .                          $28 - $2F
         DB      $9C              ;  .                          $30 - $37
         DB      $9E              ;  .                          $38 - $3F
         DB      $A0              ;  .                          $40 - $47
         DB      $A3              ;  .                          $48 - $4F
         DB      $A6              ;  .                          $50 - $57
         DB      $A7              ;  .                          $58 - $5F
         DB      $A8              ;  .                          $60 - $67
         DB      $AF              ;  .                          $68 - $6F
         DB      $B6              ;  .                          $70 - $77
         DB      $BE              ;  .                          $78 - $7F
         DB      $C6              ;  .                          $80 - $87
         DB      $D0              ;  .                          $88 - $8F
         DB      $DA              ;  .                          $90 - $97
         DB      $F0              ;  .                          $98 - $9F
         DB      $F6              ;  .                          $A0 - $A7 
         DB      $05              ;  .                          $A8 - $AF*
         DB      $05              ;  .                          $B0 - $B7*
         DB      $04              ;  .                          $B8 - $BF*
         DB      $01              ;  .                          $C0 - $C7*
         DB      $FD              ;  .                          $C8 - $CF*
         DB      $F8              ;  .                          $D0 - $D7*
         DB      $D6              ;  .                          $D8 - $DF
         DB      $D6              ;  .                          $E0 - $E7
         DB      $D6              ;  .                          $E8 - $EF
         DB      $D6              ;  .                          $F0 - $F7
         DB      $D6              ;  .                          $F8 - $FF
;
;
;         IF      L.PRS = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
