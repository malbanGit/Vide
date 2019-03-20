;
;
;         IF      L.GAM = OFF      ;-------------------------------------------
;         LIST    -L               ;--  GAME  ---------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  *********************************************************
;  *********************************************************
;  ***                                                   ***
;  ***          G A M E   D A T A   T A B L E S          ***
;  ***                                                   ***
;  *********************************************************
;  *********************************************************
;
;
;  GAME LEVEL TABLES
;  =================
;
;        BYTE 0  = GAME LEVEL COMMAND FLAGS (GAMCMD)
;                       BIT 7 = ENABLE WAR-BIRD CANNON
;                           6 = ENABLE SPIKER SPLITTING
;             1  = ACTIVE GAME LEVEL (ACTLVL)
;             2  = GUARDIAN TYPE (GRDTYP)
;                       BIT 7 = ROADWAY GATE IS OPEN
;             3  = NUMBER OF GUARDIANS (TOTGRD)
;             4  = NUMBER OF WAR-BIRDS (TOTBRD)
;            5/6 = GUARDIAN VERTICAL SPEED (GUARDY)
;            7/8 = GUARDIAN HORIZONTAL SPEED (GUARDX)
;
;
;        GAME LEVEL #1 - LOWER ROADWAY
;        -----------------------------
;
LVL000   DB      $00,$01          ;  LOWER ROADWAY - DISABLE FEATURES
         DB      $06,$00          ;  6 CRABS (NOT VD) - NO WARBIRDS
         DW      $FE00            ;  .
         DW      $0100            ;  .
;
LLEN     EQU     8;* - LVL000
;
;
LVL001   DB      $00,$01          ;  LOWER ROADWAY - DISABLE FEATURES
         DB      $08,$00          ;  8 SPIDERS - NO WARBIRDS
         DW      $FE00            ;  .
         DW      $0140            ;  .
;
LVL002   DB      $00,$01          ;  LOWER ROADWAY - DISABLE FEATURES
         DB      $0A,$00          ;  10 STOMPERS - NO WARBIRDS
         DW      $FE00            ;  .
         DW      $0180            ;  .
;
;
;        GAME LEVEL #1 - MIDDLE ROADWAY
;        ------------------------------
;
LVL010   DB      $00,$01          ;  MIDDLE ROADWAY - DISABLE FEATURES
         DB      $0A,$03          ;  10 CRABS - 3 PASSIVE WARBIRDS
         DW      $FE00            ;  .
         DW      $0140            ;  .
;
         DB      $40,$01          ;  MIDDLE ROADWAY - SPIKER SPLIT
         DB      $0C,$03          ;  12 SPIDERS - 3 PASSIVE WARBIRDS
         DW      $FE00            ;  .
         DW      $0180            ;  .
;
         DB      $40,$01          ;  MIDDLE ROADWAY - SPIKER SPLIT
         DB      $0E,$03          ;  14 STOMPERS - 3 PASSIVE WARBIRDS
         DW      $FE00            ;  .
         DW      $01C0            ;  .
;
;
;        GAME LEVEL #1 - UPPER ROADWAY
;        -----------------------------
;
LVL020   DB      $80,$01          ;  UPPER ROADWAY - WARBIRD CANNON
         DB      $0A,$03          ;  10 CRABS - 3 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $0140            ;  .
;
         DB      $C0,$01          ;  UPPER ROADWAY - WARBIRD CANNON / SPLITTING
         DB      $0C,$03          ;  12 SPIDERS - 3 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $0180            ;  .
;
LVL022   DB      $C0,$01          ;  UPPER ROADWAY - WARBIRD CANNON / SPLITTING
         DB      $0E,$03          ;  14 STOMPERS - 3 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $01C0            ;  .
;
;
;        GAME LEVEL #2 - LOWER ROADWAY
;        -----------------------------
;
LVL100   DB      $00,$02          ;  LOWER ROADWAY - DISABLE FEATURES
         DB      $10,$03          ;  16 CRABS - 3 PASSIVE WARBIRDS
         DW      $FE00            ;  .
         DW      $0180            ;  .
;
         DB      $C0,$02          ;  LOWER ROADWAY - SPIKER SPLIT
         DB      $14,$05          ;  20 SPIDERS - 5 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $01C0            ;  .
;
         DB      $C0,$02          ;  LOWER ROADWAY - SPIKER SPLIT
         DB      $14,$06          ;  20 STOMPERS - 6 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $0200            ;  .
;
;
;        GAME LEVEL #2 - MIDDLE ROADWAY
;        ------------------------------
;
LVL110   DB      $00,$02          ;  MIDDLE ROADWAY - DISABLE FEATURES
         DB      $1E,$06          ;  30 CRABS - 6 PASSIVE WARBIRDS
         DW      $FE00            ;  .
         DW      $0180            ;  .
;
         DB      $C0,$02          ;  MIDDLE ROADWAY - SPIKER SPLIT
         DB      $1E,$06          ;  30 SPIDERS - 6 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $01C0            ;  .
;
         DB      $C0,$02          ;  MIDDLE ROADWAY - WARBIRD CANNON / SPLITTING
         DB      $28,$06          ;  40 STOMPERS - 6 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $0200            ;  .
;
;
;        GAME LEVEL #2 - UPPER ROADWAY
;        -----------------------------
;
LVL120   DB      $80,$02          ;  UPPER ROADWAY - WARBIRD CANNON
         DB      $28,$08          ;  40 STOMPERS - 8 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $0180            ;  .
;
         DB      $C0,$02          ;  UPPER ROADWAY - WARBIRD CANNON / SPLITTING
         DB      $08,$08          ;  8 SPIDERS - 8 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $01C0            ;  .
;
         DB      $C0,$02          ;  UPPER ROADWAY - WARBIRD CANNON / SPLITTING
         DB      $08,$08          ;  8 STOMPERS - 8 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $0200            ;  .
;
;
;        GAME LEVEL #3 - LOWER ROADWAY
;        -----------------------------
;
;===================================================================
GAMOVR   EQU     *                ;  REPEAT STARTING WITH THIS LEVEL
;===================================================================
;
LVL200   DB      $00,$03          ;  LOWER ROADWAY - DISABLE FEATURES
         DB      $20,$05          ;  32 CRABS - 5 PASSIVE WARBIRDS
         DW      $FE00            ;  .
         DW      $01C0            ;  .
;
         DB      $C0,$03          ;  LOWER ROADWAY - SPIKER SPLIT
         DB      $24,$06          ;  36 SPIDERS - 6 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $0200            ;  .
;
         DB      $C0,$03          ;  LOWER ROADWAY - SPIKER SPLIT
         DB      $28,$06          ;  38 STOMPERS - 6 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $0240            ;  .
;
;
;        GAME LEVEL #3 - MIDDLE ROADWAY
;        ------------------------------
;
LVL210   DB      $00,$03          ;  MIDDLE ROADWAY - DISABLE FEATURES
         DB      $28,$08          ;  40 CRABS - 8 PASSIVE WARBIRDS
         DW      $FE00            ;  .
         DW      $0200            ;  .
;
         DB      $C0,$03          ;  MIDDLE ROADWAY - SPIKER SPLIT
         DB      $2A,$08          ;  42 SPIDERS - 8 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $0240            ;  .
;
         DB      $C0,$03          ;  MIDDLE ROADWAY - WARBIRD CANNON / SPLITTING
         DB      $30,$0A          ;  48 STOMPERS - 10 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $0280            ;  .
;
;
;        GAME LEVEL #3 - UPPER ROADWAY
;        -----------------------------
;
LVL220   DB      $80,$03          ;  UPPER ROADWAY - WARBIRD CANNON
         DB      $28,$08          ;  40 STOMPERS - 8 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $0200            ;  .
;
         DB      $C0,$03          ;  UPPER ROADWAY - WARBIRD CANNON / SPLITTING
         DB      $38,$08          ;  56 SPIDERS - 8 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $0240            ;  .
;
         DB      $C0,$03          ;  UPPER ROADWAY - WARBIRD CANNON / SPLITTING
         DB      $48,$0A          ;  62 STOMPERS - 10 NASTY WARBIRDS
         DW      $FE00            ;  .
         DW      $0280            ;  .
;
         DB      $FF              ;  GAME LEVEL TABLE TERMINATOR
;
;
;
;
;  GAME LEVEL POINTERS
;  ===================
;
OPTLVL   DW      LVL000
         DW      LVL100
         DW      LVL200
;
;
PLEVEL   DW      FIELD1
         DW      FIELD2
;
;
PTABLE   DW      TBLPT1
         DW      TBLPT2
;
;
;
;
;  ANIMATION POINTERS
;  ==================
;
PGUARD   DW      PCRAB1           ;  LEVEL #1 GUARDIAN ANIMATION LOOK-UP ($01)
         DW      PCRAB2           ;  .
         DW      PCRAB3           ;  .
         DW      PCRAB4           ;  .
;
;
         DW      PSPDR1           ;  LEVEL #2 GUARDIAN ANIMATION LOOK-UP ($09)
         DW      PSPDR2           ;  .
         DW      PSPDR3           ;  .
         DW      PSPDR4           ;  .
;
;
         DW      PSTMP1           ;  LEVEL #3 GUARDIAN ANIMATION LOOK-UP ($11)
         DW      PSTMP2           ;  .
         DW      PSTMP3           ;  .
         DW      PSTMP4           ;  .
;
;
         DW      PKLL01           ;  KILLER GUARDIAN ANIMATION LOOK-UP ($19)
         DW      PKLL02           ;  .    LEG SEGMENTS
         DW      PKLL03           ;  .    .
         DW      PKLL04           ;  .    .
;
         DW      PKLL11           ;  .    LEFT ARM SEGMENTS ($21)
         DW      PKLL12           ;  .    .
         DW      PKLL13           ;  .    .
         DW      PKLL14           ;  .    .
;
         DW      PKLL21           ;  .    RIGHT ARM SEGMENTS ($29)
         DW      PKLL22           ;  .    .
         DW      PKLL23           ;  .    .
         DW      PKLL24           ;  .    .
;
         DW      PKLL30           ;  .    HEAD SEGMENT ($31)
         DW      PKLL30           ;  .    .
         DW      PKLL30           ;  .    .
         DW      PKLL30           ;  .    .
;
;
;
EXGRD1   DW      ECRAB1           ;  GUARDIAN DISMEMBERMENT TABLES
         DW      ESPDR1           ;  .
         DW      ESTMP1           ;  .
;
EXGRD2   DW      ECRAB2           ;  .
         DW      ESPDR2           ;  .
         DW      ESTMP2           ;  .
;
EXGRD3   DW      ECRAB3           ;  .
         DW      ESPDR3           ;  .
         DW      ESTMP3           ;  .
;
;
;
PBIRDL   DW      PBRD01           ;  WAR-BIRD ANIMATION LOOK-UP (LEFT-SIDE)
         DW      PBRD11           ;  .
         DW      PBRD21           ;  .
         DW      PBRD31           ;  .
;
PBIRDR   DW      PBRD02           ;  WAR-BIRD ANIMATION LOOK-UP (RIGHT-SIDE)
         DW      PBRD12           ;  .
         DW      PBRD22           ;  .
         DW      PBRD32           ;  .
;
;
;
;
;  GRAPHIC STRINGS
;  ===============
;
XBLAST   DW      PBLST1           ;  STRING FOR BLASTER
         DW      PBLST2           ;  .
         DW      PBLST3           ;  .
         DW      PBLST4           ;  .
         DW      PBLST5           ;  .
         DW      PBLST6           ;  .
         DW      PBLST7           ;  .
         DW      0                ;  .    TERMINATOR
;
XRTBL    DW      RGRD1            ;  STRING FOR ROTATION TABLES
         DW      RGRD2            ;  .
         DW      RGRD3            ;  .
         DW      0                ;  .    TERMINATOR
;
XROAD1   DW      LROAD1           ;  STRING FOR FORTRESS ROADWAY
         DW      LROAD2           ;  .
         DW      LROAD3           ;  .
         DW      RROAD1           ;  .
         DW      RROAD2           ;  .
         DW      RROAD3           ;  .
         DW      0                ;  .    TERMINATOR
;
XGATE1   DW      GATE10           ;  STRING FOR LEVEL #1 GATEWAY
         DW      GATE11           ;  .
         DW      0                ;  .    TERMINATOR
;
XGATE2   DW      GATE20           ;  STRING FOR LEVEL #2 GATEWAY
         DW      GATE21           ;  .
         DW      0                ;  .    TERMINATOR
;
XBCKSC   DW      LMTN             ;  STRING FOR FORTRESS LANDSCAPE
         DW      RMTN             ;  .
         DW      LPEAK            ;  .
         DW      LPEAK1           ;  .
         DW      RSLOPE           ;  .
         DW      RPEAK            ;  .
         DW      RPEAK1           ;  .
         DW      0                ;  .    TERMINATOR
;
XCITY    DW      CITY1            ;  STRING FOR FORTRESS CITY
         DW      CITY2            ;  .    (KILLER SEQUENCE)
         DW      CITY3            ;  .
         DW      CITY4            ;  .
         DW      0                ;  .    TERMINATOR
;
KBACK    DW      LHORZ            ;  STRING FOR FORTRESS BACKGROUND
         DW      RHORZ            ;  .    (KILLER SEQUENCE)
         DW      CROAD            ;  .
         DW      0                ;  .    TERMINATOR
;
;
;
;
;  RASTER MESSAGES
;  ===============
;
RLEVEL   DW      $FA25
         DW      $5048
         DB      'LEVEL',$80
;
RPASS    DW      $FA25
         DW      $70E0
         DB      'YOU MAY PASS',$80
;
RABAND   DW      $F928
;==========================================================================JJH
;        DW      $74D4            ;  CODE DELETED - REV. A CHANGES    =====JJH
;==========================================================================JJH
;
;==========================================================================JJH
         DW      $78D4            ;  CODE ADDED - REV. A CHANGES      =====JJH
;==========================================================================JJH
         DB      'ABANDON ALL HOPE',$80
         DW      $F928
         DW      $6CD0
         DB      'YE WHO ENTER HERE',$80
         DB      $00
;
;
;         IF      L.GAM = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
