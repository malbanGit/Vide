;
;
;         IF      L.WALL = OFF     ;-------------------------------------------
;         LIST    -L               ;--  WALLS  --------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  ***************************************************************
;  ***************************************************************
;  ***                                                         ***
;  ***          W A L L   /   R O A D W A Y   D A T A          ***
;  ***                                                         ***
;  ***************************************************************
;  ***************************************************************
;
;
;  QUICK LOOK-UP COLLISION TEST
;  ============================
;
;                 $00   $20   $40   $60   $80   $A0   $C0   $E0          VERT
;                 ---   ---   ---   ---   ---   ---   ---   ---          ----
;
TCOL     DW      $0100,$0000,$0000,$0000,$0000,$0000,$0400,$0400       ;  $00
         DW      $0100,$0100,$0000,$0000,$0000,$0400,$0400,$8000       ;  $20
         DW      $8000,$0100,$0000,$0000,$0000,$0400,$0400,$8000       ;  $40
         DW      $8000,$0100,$0100,$0000,$0405,$0405,$8000,$8000       ;  $60
         DW      $8000,$8000,$0102,$0200,$0000,$0500,$0500,$8000       ;  $80
         DW      $8000,$8000,$8000,$0200,$0203,$0506,$0506,$8000       ;  $A0
         DW      $8000,$8000,$8000,$0300,$0600,$0600,$8000,$8000       ;  $C0
         DW      $8000,$8000,$8000,$0300,$0600,$8000,$8000,$8000       ;  $E0
;
;
;  DETAILED WALL COLLISION INFORMATION
;  ===================================
;
;
;        WALL LOOK-UP TABLES
;        -------------------
;
WALLS    DW      0                ;  0 = NO WALL AT ALL
;
         DW      LLWALL           ;  1 = LOWER-LEFT WALL
         DW      MLWALL           ;  2 = MIDDLE-LEFT WALL
         DW      ULWALL           ;  3 = UPPER-LEFT WALL
;
         DW      LRWALL           ;  4 = LOWER-RIGHT WALL
         DW      MRWALL           ;  5 = MIDDLE-RIGHT WALL
         DW      URWALL           ;  6 = UPPER-RIGHT WALL
;
;
;        DETAILED WALL DATA
;        ------------------
;
;             BYTE 0   = WALL FLAG
;                  1   = WALL ANGLE ($00 - $3F)
;                  2   = 'Y' AXIS START
;                  3   = 'Y' AXIS END
;                  4   = 'X' AXIS START
;                  5   = 'X' AXIS END
;
LLWALL   DB      $3B              ;  LOWER-LEFT WALL
         DB      $98,$08          ;  .    YS,YE
         DB      $90,$CC          ;  .    XS,XE
;
MLWALL   DB      $36              ;  MIDDLE-LEFT WALL
         DB      $05,$2D          ;  .    YS,YE
         DB      $CA,$04          ;  .    XS,XE
;
ULWALL   DB      $04              ;  UPPER-LEFT WALL
         DB      $2B,$5F          ;  .    YS,YE
         DB      $02,$ED          ;  .    XS,XE
;
;
LRWALL   DB      $07              ;  LOWER-RIGHT WALL
         DB      $98,$ED          ;  .    YS,YE
         DB      $60,$1A          ;  .    XS,XE
;
MRWALL   DB      $3A              ;  MIDDLE-RIGHT WALL
         DB      $EB,$26          ;  .    YS,YE
         DB      $1C,$43          ;  .    XS,XE
;
URWALL   DB      $07              ;  UPPER-RIGHT WALL
         DB      $23,$5E          ;  .    YS,YE
         DB      $40,$10          ;  .    XS,XE
;   
;
;
;
;  BULLET BOUNCE ANGLE TABLES (ALL LEVELS)
;  =======================================
;
;
BLBNC    DW      0                ;  0 = NO WALL AT ALL
;
         DW      BLBNC1           ;  1 = LOWER-LEFT WALL
         DW      BLBNC2           ;  2 = MIDDLE-LEFT WALL
         DW      BLBNC3           ;  3 = UPPER-LEFT WALL
;
         DW      BLBNC4           ;  4 = LOWER-RIGHT WALL
         DW      BLBNC5           ;  5 = MIDDLE-RIGHT WALL
         DW      BLBNC6           ;  6 = UPPER-LEFT WALL
;
;
;        LOWER-LEFT WALL
;        ---------------
;
BLBNC1   DB      $80,$80,$2A,$17       ;  BULLET ANGLES = $08,$0C,$10,$14
         DB      $80,$80,$0D,$80       ;                = $18,$1C,$20,$24
         DB      $80,$80,$80,$80       ;                = $28,$2C,$30,$34
         DB      $80,$80,$33,$80       ;                = $38,$3C,$00,$04
;
;
;        MIDDLE-LEFT WALL
;        ----------------
;
BLBNC2   DB      $31,$31,$0F,$80       ;  BULLET ANGLES = $0C,$10,$14,$18
         DB      $80,$0D,$80,$80       ;                = $1C,$20,$24,$28
         DB      $80,$80,$80,$80       ;                = $2C,$30,$34,$38
         DB      $80,$31,$80,$80       ;                = $3C,$00,$04,$06
;
;
;        UPPER-LEFT WALL
;        ---------------
;
BLBNC3   DB      $80,$31,$80,$80       ;  BULLET ANGLES = $3C,$00,$04,$08
         DB      $33,$0F,$0F,$80       ;                = $0C,$10,$14,$18
         DB      $80,$0E,$80,$80       ;                = $1C,$20,$24,$28
         DB      $80,$80,$80,$80       ;                = $2C,$30,$34,$38
;
;
;        LOWER-RIGHT WALL
;        ----------------
;
BLBNC4   DB      $80,$0F,$80,$80       ;  BULLET ANGLES = $3C,$00,$04,$08
         DB      $80,$80,$80,$80       ;                = $0C,$10,$14,$18
         DB      $80,$31,$80,$80       ;                = $1C,$20,$24,$28
         DB      $80,$80,$0C,$80       ;                = $2C,$30,$34,$38
;
;
;        MIDDLE-RIGHT WALL
;        -----------------
;
BLBNC5   DB      $80,$80,$80,$80       ;  BULLET ANGLES = $08,$0C,$10,$14
         DB      $80,$80,$31,$80       ;                = $18,$1C,$20,$24
         DB      $80,$34,$0D,$0D       ;                = $28,$2C,$30,$34
         DB      $80,$80,$0E,$80       ;                = $38,$3C,$00,$04
;
;
;        UPPER-RIGHT WALL
;        ----------------
;
BLBNC6   DB      $80,$0F,$80,$80       ;  BULLET ANGLES = $3C,$00,$04,$08
         DB      $80,$80,$80,$80       ;                = $0C,$10,$14,$18
         DB      $80,$31,$80,$80       ;                = $1C,$20,$24,$28
         DB      $80,$32,$0F,$80       ;                = $2C,$30,$34,$38
;   
;
;
;
;  SPIKER BOUNCE ANGLE TABLES (LEVELS #0 & #2)
;  ===========================================
;
;
SPBN0    DW      0                ;  0 = NO WALL AT ALL
;
         DW      SPBN01           ;  1 = LOWER-LEFT WALL
         DW      SPBN02           ;  2 = MIDDLE-LEFT WALL
         DW      SPBN03           ;  3 = UPPER-LEFT WALL
;
         DW      SPBN04           ;  4 = LOWER-RIGHT WALL
         DW      SPBN05           ;  5 = MIDDLE-RIGHT WALL
         DW      SPBN06           ;  6 = UPPER-LEFT WALL
;
;
;        LOWER-LEFT WALL
;        ---------------
;
SPBN01   DB      $80,$80,$24,$28       ;  SPIKER ANGLES = $08,$0C,$10,$14
         DB      $2B,$80,$80,$80       ;                = $18,$1C,$20,$24
         DB      $80,$80,$80,$80       ;                = $28,$2C,$30,$34
         DB      $80,$80,$80,$80       ;                = $38,$3C,$00,$04
;
;
;        MIDDLE-LEFT WALL
;        ----------------
;
SPBN02   DB      $24,$24,$2A,$80       ;  SPIKER ANGLES = $0C,$10,$14,$18
         DB      $28,$28,$80,$80       ;                = $1C,$20,$24,$28
         DB      $80,$80,$80,$80       ;                = $2C,$30,$34,$38
         DB      $80,$80,$80,$80       ;                = $3C,$00,$04,$06
;
;
;        UPPER-LEFT WALL
;        ---------------
;
SPBN03   DB      $80,$80,$80,$80       ;  SPIKER ANGLES = $3C,$00,$04,$08
         DB      $2C,$2C,$2A,$2A       ;                = $0C,$10,$14,$18
         DB      $2C,$28,$80,$80       ;                = $1C,$20,$24,$28
         DB      $80,$80,$80,$80       ;                = $2C,$30,$34,$38
;
;
;        LOWER-RIGHT WALL
;        ----------------
;
SPBN04   DB      $80,$80,$80,$80       ;  SPIKER ANGLES = $3C,$00,$04,$08
         DB      $80,$80,$80,$80       ;                = $0C,$10,$14,$18
         DB      $80,$18,$15,$80       ;                = $1C,$20,$24,$28
         DB      $12,$12,$80,$80       ;                = $2C,$30,$34,$38
;
;
;        MIDDLE-RIGHT WALL
;        -----------------
;
SPBN05   DB      $80,$80,$80,$80       ;  SPIKER ANGLES = $08,$0C,$10,$14
         DB      $80,$12,$18,$15       ;                = $18,$1C,$20,$24
         DB      $14,$12,$0C,$80       ;                = $28,$2C,$30,$34
         DB      $80,$80,$80,$80       ;                = $38,$3C,$00,$04
;
;
;        UPPER-RIGHT WALL
;        ----------------
;
SPBN06   DB      $80,$80,$80,$80       ;  SPIKER ANGLES = $3C,$00,$04,$08
         DB      $80,$80,$80,$80       ;                = $0C,$10,$14,$18
         DB      $80,$80,$80,$80       ;                = $1C,$20,$24,$28
         DB      $13,$15,$80,$0C       ;                = $2C,$30,$34,$38
;
;
;
;
;  SPIKER BOUNCE ANGLE TABLES (LEVEL #1)
;  =====================================
;
;
SPBN1    DW      0                ;  0 = NO WALL AT ALL
;
         DW      SPBN11           ;  1 = LOWER-LEFT WALL
         DW      SPBN12           ;  2 = MIDDLE-LEFT WALL
         DW      SPBN13           ;  3 = UPPER-LEFT WALL
;
         DW      SPBN14           ;  4 = LOWER-RIGHT WALL
         DW      SPBN15           ;  5 = MIDDLE-RIGHT WALL
         DW      SPBN16           ;  6 = UPPER-LEFT WALL
;
;
;        LOWER-LEFT WALL
;        ---------------
;
SPBN11   DB      $18,$18,$16,$80       ;  SPIKER ANGLES = $08,$0C,$10,$14
         DB      $80,$80,$80,$80       ;                = $18,$1C,$20,$24
         DB      $80,$80,$80,$80       ;                = $28,$2C,$30,$34
         DB      $80,$80,$80,$80       ;                = $38,$3C,$00,$04
;
;
;        MIDDLE-LEFT WALL
;        ----------------
;
SPBN12   DB      $18,$14,$1A,$80       ;  SPIKER ANGLES = $0C,$10,$14,$18
         DB      $80,$80,$80,$80       ;                = $1C,$20,$24,$28
         DB      $80,$80,$80,$80       ;                = $2C,$30,$34,$38
         DB      $80,$18,$14,$14       ;                = $3C,$00,$04,$06
;
;
;        UPPER-LEFT WALL
;        ---------------
;
SPBN13   DB      $80,$16,$14,$12       ;  SPIKER ANGLES = $3C,$00,$04,$08
         DB      $14,$0E,$0F,$80       ;                = $0C,$10,$14,$18
         DB      $80,$80,$80,$80       ;                = $1C,$20,$24,$28
         DB      $80,$80,$80,$80       ;                = $2C,$30,$34,$38
;
;
;        LOWER-RIGHT WALL
;        ----------------
;
SPBN14   DB      $28,$28,$2C,$28       ;  SPIKER ANGLES = $3C,$00,$04,$08
         DB      $80,$80,$80,$80       ;                = $0C,$10,$14,$18
         DB      $80,$80,$80,$80       ;                = $1C,$20,$24,$28
         DB      $80,$28,$2A,$24       ;                = $2C,$30,$34,$38
;
;
;        MIDDLE-RIGHT WALL
;        -----------------
;
SPBN15   DB      $28,$80,$80,$80       ;  SPIKER ANGLES = $08,$0C,$10,$14
         DB      $80,$80,$80,$80       ;                = $18,$1C,$20,$24
         DB      $80,$80,$34,$2C       ;                = $28,$2C,$30,$34
         DB      $2C,$28,$28,$2C       ;                = $38,$3C,$00,$04
;
;
;        UPPER-RIGHT WALL
;        ----------------
;
SPBN16   DB      $80,$80,$80,$80       ;  SPIKER ANGLES = $3C,$00,$04,$08
         DB      $80,$80,$80,$80       ;                = $0C,$10,$14,$18
         DB      $80,$80,$80,$80       ;                = $1C,$20,$24,$28
         DB      $80,$29,$29,$24       ;                = $2C,$30,$34,$38
;
;
;         IF      L.WALL = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
