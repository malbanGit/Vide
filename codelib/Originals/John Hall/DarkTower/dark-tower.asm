; Dark Tower as gotten from John Hall's web site:
; https://roadsidethoughts.com/vectrex/dark-tower.htm
;
; this version was "fitted" to be compilable with Vide
; changes made:
; 1) exclude all linker stuff
; 2) replace all „.“ with „_“
; 3) replace LINK with „include“
; 4) ensure all RAM locations are „BSS“
; 5) changed binary form from 00000000B to %00000000
; 6) LDA X (and the like) statments changed to LDA ,X
; 7) made 2 new include files for BIOS, RAM and IO locations as in "RUM"
; 8) identified missing VAR names and JSR locations
;    and added them in "other.i"
; 
; for binary compatabilty changed all
; ld# 0,#
; to ld# <<,#
; since assi tries optimizing that automatically
;
; The resulting binary has the same CRC32 checksum as the "available" binary 

                    include  "BIOS.I"
                    include  "DECL.I"
                    include  "OTHER.I" ; gotton from Minestorm, or "by hand" 

                    noopt    

;  *********************************************************
;  *********************************************************
;  ***                                                   ***
;  ***          G C E     === V E C T R E X ===          ***
;  ***                                                   ***
;  ***                     D A R K   T O W E R           ***
;  ***                                                   ***
;  *********************************************************
;  *********************************************************
;
;
;=============================================================================
;
;  REV     DATE     PROG     COMMENT(S)
;  ---     ----     ----     ----------
;
;   A    08.16.83   JJH      LOWERED FOREST HORIZON LINE
;                            INCREASED KEY, GOLD & TOWER CAPTURE DISTANCE
;                            REMOVED 'TROOPS' INCREMENTING WHEN 'HEALER'
;                               OR 'SCOUT' GRANTED
;                            CANNOT ENTER INVENTORY PAGE WHEN SOUND EFFECT
;                               OR TUNE PENDING
;
;   -    07.22.83   JJH      INITIAL RELEASE
;
;=============================================================================
;
;
;  *********************************************************
;  *********************************************************
;  ***                                                   ***
;  ***          L I S T I N G   C O N T R O L S          ***
;  ***                                                   ***
;  *********************************************************
;  *********************************************************
;
;
;         LIST    -F
;
;
;ON       EQU     1
;OFF      EQU     0
;
;
;
;L.ALL    EQU     ON               ;  OVER-RIDE ALL LISTING SECTIONS ?
;
;
;L.STOR   EQU     OFF OR L.ALL     ;  LIST WORKING STORAGE ?
;L.INT    EQU     OFF OR L.ALL     ;  LIST SECTION 'INIT.DRK' [DRKTWR.ASM] ?
;L.FRST   EQU     OFF OR L.ALL     ;  LIST SECTION 'FOREST.DRK' ?
;L.WAR    EQU     OFF OR L.ALL     ;  LIST SECTION 'WARIOR.DRK' ?
;L.SCN    EQU     OFF OR L.ALL     ;  LIST SECTION 'SCENRY.DRK' ?
;L.BOX    EQU     OFF OR L.ALL     ;  LIST SECTION 'BOXES.DRK' [SCENRY.DRK] ?
;L.DTWR   EQU     OFF OR L.ALL     ;  LIST SECTION 'DRWTWR.DRK' [SCENRY.DRK] ?
;L.SKEY   EQU     OFF OR L.ALL     ;  LIST SECTION 'SCNKEY.DRK' [SCENRY.DRK] ?
;L.SGLD   EQU     OFF OR L.ALL     ;  LIST SECTION 'SCNGLD.DRK' [SCENRY.DRK] ?
;L.FOG    EQU     OFF OR L.ALL     ;  LIST SECTION 'FOG.DRK' [GRDSCN.DRK] ?
;L.PLG    EQU     OFF OR L.ALL     ;  LIST SECTION 'PLAGUE.DRK' [GRDSCN.DRK] ?
;L.GRD    EQU     OFF OR L.ALL     ;  LIST SECTION 'GRDSCN.DRK' ?
;
;L.BRG    EQU     OFF OR L.ALL     ;  LIST SECTION 'BRGAND.DRK' ?
;L.GBLN   EQU     OFF OR L.ALL     ;  LIST SECTION 'GOBLIN.DRK' ?
;L.FGHT   EQU     OFF OR L.ALL     ;  LIST SECTION 'FIGHT.DRK' ?
;L.FLM    EQU     OFF OR L.ALL     ;  LIST SECTION 'FLAMER.DRK' ?
;L.FRAG   EQU     OFF OR L.ALL     ;  LIST SECTION 'FRGMNT.DRK' ?
;L.COLD   EQU     OFF OR L.ALL     ;  LIST SECTION 'COLIDE.DRK' ?
;
;L.MAG    EQU     OFF OR L.ALL     ;  LIST SECTION 'MAGIC.DRK' ?
;L.WIZ    EQU     OFF OR L.ALL     ;  LIST SECTION 'WIZARD.DRK' ?
;
;L.TWR    EQU     OFF OR L.ALL     ;  LIST SECTION 'TOWER.DRK' ?
;L.INV    EQU     OFF OR L.ALL     ;  LIST SECTION 'INVENT.DRK' ?
;
;L.SND    EQU     OFF OR L.ALL     ;  LIST SECTION 'SOUND.DRK' ?
;L.TMR    EQU     OFF OR L.ALL     ;  LIST SECTION 'TIMERS.DRK' ?
;L.SBR    EQU     OFF OR L.ALL     ;  LIST SECTION 'SUBR.DRK' ?
;
;L.MAP    EQU     OFF OR L.ALL     ;  LIST SECTION 'MAP.DRK' ?
;L.PCK    EQU     OFF OR L.ALL     ;  LIST SECTION 'PACKS.DRK' ?
;
;
;
;
;
;
;  ***************************************
;  ***************************************
;  ***                                 ***
;  ***          E Q U A T E S          ***
;  ***                                 ***
;  ***************************************
;  ***************************************
;
;
SY_WAR              EQU      $C000                        ; POINT WARRIOR - SCREEN 'Y' POSITION 
SX_WAR              EQU      $0000                        ; . - SCREEN 'X' POSITION 
SZ_WAR              EQU      $30                          ; . - SCREEN 'Z' POSITION 
;
BY_WAR              EQU      $2800                        ; BOX WARRIOR - SCREEN 'Y' POSITION 
BX_WAR              EQU      $0000                        ; . - SCREEN 'X' POSITION 
BZ_WAR              EQU      $F8                          ; . - SCREEN 'Z' POSITION 
;
SHFDSP              EQU      $0060                        ; WARRIOR SHUFFLE RATE 
;
;
;
BRGCNT              EQU      6                            ; BRIGAND TABLE: NUMBER OF ENTRIES 
FLMCNT              EQU      8                            ; FLAMOID TABLE: NUMBER OF ENTRIES 
EXPCNT              EQU      14                           ; EXPLOSION TABLE: NUMBER OF ENTRIES 
OBJCNT              EQU      32                           ; OBJECT TABLE: NUMBER OF ENTRIES 
SCNCNT              EQU      18                           ; GRID SCAN TABLE: NUMBER OF ENTRIES 
;
WARSPD              EQU      $20                          ; WARRIOR SPEED ON MAP 
WARINS              EQU      $1F                          ; WARRIOR INSERTION TIMER 
;
FLMSPD              EQU      $40                          ; FLAMOID SPEED 
;
FRSTY               EQU      $FC                          ; VIEWER'S ELEVATION (FOR PROJECTION) 
;
;
PLGTIM              EQU      $0500                        ; PLAGUE LOCK-OUT TIME 
;
;
;
;
;  SWITCH EQUATES
;  ==============
;
INVNTY              EQU      KEY0                         ; ASSIGN INVENTORY PAGE KEY 
OPEN                EQU      KEY3                         ; ASSIGN BOX OPENING KEY 
;
TRGHT               EQU      KEY3                         ; WARRIOR THROW RIGHT KEY 
TSTRT               EQU      KEY2                         ; WARRIOR THROW STRAIGHT KEY 
TLEFT               EQU      KEY1                         ; WARRIOR THROW LEFT KEY 
;
NXTKEY              EQU      KEY1                         ; MOVE TO NEXT KEY PLACE 
INCKEY              EQU      KEY2                         ; MOVE TO NEXT KEY SELECTION 
TRYKEY              EQU      KEY3                         ; TRY KEY COMBINATION 
;
;
;
;
;  TREASURE PRICES
;  ===============
;
GLDPRC              EQU      $0060                        ; GOLD KEY 
SLVPRC              EQU      $0050                        ; SILVER KEY 
BRZPRC              EQU      $0040                        ; BRONZE KEY 
BRSPRC              EQU      $0030                        ; BRASS KEY 
CRWPRC              EQU      $0060                        ; CRYSTAL CROWN 
SCTPRC              EQU      $0020                        ; SCOUT 
HLRPRC              EQU      $0015                        ; HEALER 
WARPRC              EQU      $0010                        ; WARRIOR 

;
;
;
;
;
;
;
;
;
;         IF      L.STOR = OFF     ;-------------------------------------------
;         LIST    -L               ;--  WORKING STORAGE  ----------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;  *******************************************************
;  *******************************************************
;  ***                                                 ***
;  ***          W O R K I N G   S T O R A G E          ***
;  ***                                                 ***
;  *******************************************************
;  *******************************************************
;
                    bss      
                    ORG      $C8A8 
;        ===     =====
;
;
FRAM7               DB       0                            ; FRAME FLAG (.AND. $07) 
FRAM3               DB       0                            ; FRAME FLAG (.AND. $03) 
FRAM1               DB       0                            ; FRAME FLAG (.AND. $01) 
;
DRWINT              DB       0                            ; DRAWING INTENSITY 
DRWSIZ              DB       0                            ; DRAWING ZOOM SIZE 
DRWLS1              DW       0                            ; POINTER TO 'DIFFY' LIST #1 
DRWLS2              DW       0                            ; POINTER TO 'DIFFY' LIST #2 
;
;
INTFLG              DB       0                            ; GAME INITIALIZATION FLAG (1 = INIT DONE) 
;
LOKANG              DB       0                            ; CURRENT LOOK-ANGLE INTO MAP 
RFANGL              DB       0                            ; -45 DEGREE REFERENCE ANGLE 
;
MAPY                DW       0                            ; ABSOLUTE MAP POSITION - 'Y' AXIS 
MAPX                DW       0                            ; . - 'X' AXIS 
;
LASTY               DB       0                            ; LAST MAP POSITION - 'Y' AXIS 
LASTX               DB       0                            ; . - 'X' AXIS 
;
WARYD               DW       0                            ; WARRIOR MOTION DISPLACEMENTS - 'Y' AXIS 
WARXD               DW       0                            ; . - 'X' AXIS 
WARWLK              DB       0                            ; WARRIOR WALKING FLAG (LAST FRAME) 
;
WARINH              DB       0                            ; INHIBIT WARRIOR ACTION 
WARTHR              DB       0                            ; WARRIOR THROWING FLAG 
;
SCTINH              DB       0                            ; INHIBIT SCOUT ACTION 
SCTCNT              DB       0                            ; SCOUT USE COUNTER 
HLRCNT              DB       0                            ; HEALER USE COUNTER 
;
DSINE               DW       0                            ; SINE FOR CURRENT LOOK-ANGLE 
DCSINE              DW       0                            ; COSINE FOR CURRENT LOOK-ANGLE 
;
RXPOS               DB       0                            ; RELATIVE OBJECT POSITION - 'X' AXIS 
RYPOS               DB       0                            ; . - 'Y' AXIS 
RZPOS               DB       0                            ; . - 'Z' AXIS 
PRJLIM              DB       0                            ; LOWER 'Y' LIMIT FOR 'PRJCTN' 
;
DRWSCZ              DB       0                            ; SCREEN 'Z' AXIS FOR OBJECT 
DRWSCY              DB       0                            ; SCREEN 'Y' AXIS FOR OBJECT 
DRWSCX              DB       0                            ; SCREEN 'X' AXIS FOR OBJECT 
DRWCNT              DB       0                            ; COUNTER FOR 'SCENRY' 
;
WARSCY              DB       0                            ; FIGHTING WARRIOR PROJECTION - 'Y' AXIS 
WARSCX              DB       0                            ; . - 'X' AXIS 
;
SCNFND              DB       0                            ; NUMBER OF OBJECTS FOUND DURING GRID SCAN 
;
;
ABORT               DB       0                            ; GAME ABORT FLAG 
;
TIMOUT              DW       0                            ; LONG TIME-OUT DELAY 
;
GLDKEY              DB       0                            ; GOLD KEY FLAG 
SLVKEY              DB       0                            ; SILVER KEY FLAG 
BRZKEY              DB       0                            ; BRONZE KEY FLAG 
BRSKEY              DB       0                            ; BRASS KEY FLAG 
CROWN               DB       0                            ; CRYSTAL CROWN FLAG 
SCTFLG              DB       0                            ; SCOUT FLAG 
HLRFLG              DB       0                            ; HEALER FLAG 
BGOLD               DW       0                            ; BAGS OF GOLD HELD 
TROOPS              DB       0                            ; NUMBER OF RESERVE TROOPS 
;
;
;
;
;  CURRENT BOX / OBJECT
;  ====================
;
CBXDST              DB       0                            ; DISTANCE TO FRONT OBJECT 
CBXSCN              DW       0                            ; POINTER TO GRID SCAN TABLE ENTRY 
CBXOBJ              DW       0                            ; POINTER TO OBJECT TABLE ENTRY 
CBXPTR              DW       0                            ; POINTER TO BOX ACTIVITY MAP 
CBXBIT              DB       0                            ; BIT MASK FOR BOX ACTIVITY MAP 
CBXACT              DB       0                            ; BOX ACTIVITY FLAG (1 = PREVIOUSLY OPENED) 
CBXAMT              DB       0                            ; AMOUNT OF CURRENT BOX ACTION 
CBXDLY              DB       0                            ; ACTION DELAY TIMER 
;
;
;
;
;  WARRIORS TABLE
;  ==============
;
WARFLG              DB       0                            ; WARRIOR FLAG 
;                                       00 = WARRIOR DEAD
;                                       01 = STANDARD WARRIOR TYPE
WARYW               DW       0                            ; CURRENT WARRIOR 'Y' POSITION ON SCREEN 
WARXW               DW       0                            ; CURRENT WARRIOR 'X' POSITION ON SCREEN 
WARINT              DB       0                            ; CURRENT WARRIOR INTENSITY 
WARDSH              DB       0                            ; WARRIOR DASHING PATTERN 
WARFRM              DB       0                            ; ANIMATION FRAME BIAS ($00 - $03) 
;
;
;
;
;  TREASURE MESSAGE WORKING AREA
;  =============================
;
MSGPTR              DW       0                            ; TREASURE MESSAGE POINTER 
MSGVCT              DW       0                            ; TREASURE MESSAGE VECTOR 
MSGFRM              DB       0                            ; TREASURE MESSAGE FRAME COUNTER 
;
;
;
;
;  BOX ACTIVITY TABLE
;  ==================
;
;                0.......  1.......  2.......  3.......
;                02468ACE  02468ACE  02468ACE  02468ACE
;                --------  --------  --------  --------
;
BOXACT              DB       %00000000,%00000000,%00000000,%00000000 ; 00 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 02 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 04 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 06 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 08 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 0A 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 0C 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 0E 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 10 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 12 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 14 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 16 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 18 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 1A 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 1C 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 1E 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 20 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 22 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 24 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 26 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 28 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 2A 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 2C 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 2E 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 30 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 32 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 34 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 36 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 38 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 3A 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 3C 
                    DB       %00000000,%00000000,%00000000,%00000000 ; 3E 
;
;
;
;
;  GRID SCAN TABLE RETENTION
;  =========================
;
RGDCMD              EQU      0                            ; OBJECT COMMAND / STATUS 
RGDTMR              EQU      RGDCMD + 1                   ; OBJECT ANIMATION TIMER 
;
RGDLEN              EQU      RGDTMR + 1                   ; OBJECT TABLE ENTRY LENGTH 
;
RGDTBL              DS       RGDLEN * SCNCNT 
;
;
;
;
;  KEY RIDDLE
;  ==========
;
KRIDL0              DB       0                            ; FIRST KEY 
KRIDL1              DB       0                            ; SECOND KEY 
KRIDL2              DB       0                            ; THIRD KEY 
KRIDL3              DB       0                            ; FOURTH KEY 
;
;
;.............................................................................
ENDWRK              EQU      *                            ; END OF NON-OVERLAYED WORKING STORAGE 
;.............................................................................
;
;
;
;
                    bss      
                    ORG      $CB2C 
;        ===     =====
;
UP_RAM              EQU      *                            ; MARK THE START OF UPPER RAM 
;
;
;
;  WORKING AREA FOR PLAYERS SCORE
;  ==============================
;
PLAYER              DS       21                           ; PLAYERS SCORE 
PLYSCR              EQU      PLAYER + 14                  ; . START OF SCORE ASCII 
;
;
;
;  WORKING AREA FOR PEDOMETER MESSAGE
;  ==================================
;
PEDMTR              DS       9                            ; RASTER PEDOMETER MESSAGE 
PEDSGN              EQU      PEDMTR + 4                   ; SIGN OF DISTANCE (BLANK OR '-') 
PEDZRO              DB       0                            ; PEDOMETER ZERO FLAG 
;
;
;
;  WORKING AREA FOR BAGS OF GOLD MESSAGES
;  ======================================
;
GOLD                DS       18                           ; BAGS OF GOLD MESSAGE 
NGOLD               DS       15                           ; BAGS OF GOLD FOUND MESSAGE 
;
;
;
;  SOUND FLAGS
;  ===========
;
STEPS               DB       0                            ; FOOT-STEP FLAG 
BOXSQK              DB       0                            ; BOX SQUEAK FLAG 
;
THRSND              DB       0                            ; FLAMOID RELEASE SOUND 
EXPBRG              DB       0                            ; BRIGAND EXPLOSION FLAG 
EXPWAR              DB       0                            ; WARRIOR EXPLOSION FLAG 
;
;
;
;  WORKING AREA FOR HYPER (REQUIRED BY 'MINE STORM')
;  =================================================
;
FSTAR               DS       16                           ; MINE-STORM STAR-FIELD ALLOCATIONS 
ZSTAR               DS       8                            ; . 
;
;
BRSFLG              DB       0                            ; STAR-BURST FLAG 
;                                       $01 = EXPANDING STAR-BURST
;                                       $80 = CONTRACTING STAR-BURST
BRSTMR              DB       0                            ; STAR-BURST TIMER 
BRSDLY              DB       0                            ; STAR-BURST DELAY TIMER 
;
;
;
;  WORKING AREA FOR RESERVE TROOPS MESSAGES
;  ========================================
;
MEN                 DS       20                           ; NUMBER OF TROOPS MESSAGE 
NMEN                EQU      NGOLD                        ; NUMBER OF NEW TROOPS MESSAGE 
;
;
;
RFLAG               DB       0                            ; DRAW REVERSE FLAG (0 = NORMAL DRAW) 
;
;
;
;
;  ************************************************************
;  ************************************************************
;  ***                                                      ***
;  ***          O V E R - L A Y E D   S T O R A G E         ***
;  ***                                                      ***
;  ***            F O R E S T   S U B  -  P L O T           ***
;  ***                                                      ***
;  ************************************************************
;  ************************************************************
;
                    bss      
                    ORG      ENDWRK 
;        ===     ======
;
FOGFLG              DB       0                            ; FOG ACTIVITY FLAG 
FOGLIM              DB       0                            ; LIMIT FOR FOG ALTITUDE 
;
PLGFLG              DB       0                            ; PLAGUE ACTIVITY FLAG 
PLGLIM              DB       0                            ; LIMIT FOR PLAGUE ALTITUDE 
PLGLCK              DW       0                            ; PLAGUE LOCK-OUT TIMER 
;
;
;
;
;  GRID SCAN TABLE
;  ===============
;
SCNADR              EQU      0                            ; OBJECT DRAW ADDRESS 
SCNGY               EQU      SCNADR + 2                   ; ABSOLUTE GRID 'Y' POSITION 
SCNGX               EQU      SCNGY + 2                    ; ABSOLUTE GRID 'X' POSITION 
SCNDRW              EQU      SCNGX + 2                    ; OBJECT DRAWING FLAG (&gt;0 = REVERSE) 
SCNCMD              EQU      SCNDRW + 1                   ; OBJECT COMMAND / STATUS 
;                                       BIT 0 = OBJECT IS ACTIVE
;                                           1 = BOX IS OPENING
;                                           2 = BOX IS CLOSING
;                                           3 = BOX IS OPENED
;                                           4 = BOX ACTION IS PENDING
;                                           5 = ACTION COMPLETION
SCNTMR              EQU      SCNCMD + 1                   ; OBJECT ANIMATION TIMER 
;
SCNLEN              EQU      SCNTMR + 1                   ; OBJECT TABLE ENTRY LENGTH 
;
SCNTBL              DS       SCNLEN * SCNCNT 
;
ENDSCN              EQU      * 
;
;
;
;
;  OBJECT TABLE
;  ============
;
OBJFLG              EQU      0                            ; OBJECT FLAG 
;                                       $00 = SKIP ENTRY
;                                       $01 = NORMAL SCENERY
;                                       $8X = BOX ANIMATION
;                                       $EX = SCENERY FOG OR PLAGUE
;                                       $F0 = SCENERY KEY
;                                       $F2 = SCENERY BAG OF GOLD
;                                       $F4 = DARK TOWER
OBJSCY              EQU      OBJFLG + 1                   ; OBJECT SCREEN ABSOLUTE 'Y' POSITION 
OBJSCX              EQU      OBJSCY + 1                   ; OBJECT SCREEN ABSOLUTE 'X' POSITION 
OBJSCZ              EQU      OBJSCX + 1                   ; OBJECT SCREEN ABSOLUTE 'Z' POSITION 
OBJPTR              EQU      OBJSCZ + 1                   ; OBJECT POINTER TO GRID SCAN TABLE ENTRY 
;
OBJLEN              EQU      OBJPTR + 2                   ; OBJECT TABLE ENTRY LENGTH 
;
OBJTBL              DS       OBJLEN * OBJCNT 
;
ENDOBJ              EQU      * 
;
;         MSG     'END OF RAM - FOREST   = ',*
;
;         IF      * < UP.RAM
;         MSG     '----- UPPER RAM ALLOCATIONS VIOLATED -----'
;         ENDIF
;
;
;
;
;  ************************************************************
;  ************************************************************
;  ***                                                      ***
;  ***          O V E R - L A Y E D   S T O R A G E         ***
;  ***                                                      ***
;  ***           B R I G A N D   S U B  -  P L O T          ***
;  ***                                                      ***
;  ************************************************************
;  ************************************************************
;
                    bss      
                    ORG      ENDWRK 
;        ===     ======
;
GBLACT              DB       0                            ; GOBLIN VISIBLE TO WARRIOR FLAG 
GBLKIL              DB       0                            ; LAST GOBLIN KILLED FLAG 
;
THRANG              DB       0                            ; WARRIOR FLAMOID THROW ANGLE 
;
EXPEND              DB       0                            ; EXPLOSION PENDING FLAG 
;
RFLAME              DS       60                           ; ROTATING FLAMOID (DUFFY) 
;
;
;
;
;  BRIGAND TABLE
;  =============
;
BRGFLG              EQU      0                            ; BRIGAND FLAG 
;                                       00 = BRIGAND DEAD
;                                       80 = BRIGAND EXPOSED
;                                       C0 = FLAMOID RELEASED
BRGTMR              EQU      BRGFLG + 1                   ; BRIGAND ANIMATION TIMER 
BRGPTR              EQU      BRGTMR + 1                   ; BRIGAND ABSOLUTE 'Y' POSITION 
;
BRGLEN              EQU      BRGPTR + 2                   ; BRIGAND TABLE ENTRY LENGTH 
;
BRGTBL              DS       BRGLEN * BRGCNT 
;
BRG_00              EQU      BRGTBL 
BRG_01              EQU      BRG_00 + BRGLEN 
BRG_02              EQU      BRG_01 + BRGLEN 
BRG_03              EQU      BRG_02 + BRGLEN 
;
ENDBRG              EQU      * 
;
;
;
;        BRIGAND PARAMETER TABLE LABELS
;        ------------------------------
;
BRGYW               EQU      0                            ; ABSOLUTE SCREEN 'Y' POSITION 
BRGXW               EQU      BRGYW + 2                    ; ABSOLUTE SCREEN 'X' POSITION 
BRGYT               EQU      BRGXW + 2                    ; RELATIVE 'Y' POSITION FOR THROWING 
BRGXT               EQU      BRGYT + 2                    ; RELATIVE 'X' POSITION FOR THROWING 
BRGZT               EQU      BRGXT + 2                    ; RELATIVE 'Z' POSITION FOR THROWING 
BRGHTY              EQU      BRGZT + 1                    ; RELATIVE 'Y' BOX CENTER 
BRGHTX              EQU      BRGHTY + 2                   ; RELATIVE 'X' BOX CENTER 
BRGDRW              EQU      BRGHTX + 2                   ; REVERSE DRAW FLAG 
BRGSIZ              EQU      BRGDRW + 1                   ; BRIGAND SIZE 
BRGBOX              EQU      BRGSIZ + 1                   ; COLLISION BOX 
;
;
;
;
;  FLAMOID TABLE
;  =============
;
FLMFLG              EQU      0                            ; FLAMOID FLAG 
;                                       01 = FLAMOID SEED
;                                       BIT 6 = FLAMOID THROWN BY WARRIOR
;                                       BIT 7 = FULL FLAMOID ANIMATION
FLMYD               EQU      FLMFLG + 1                   ; 'Y' DISPLACEMENT FOR FLAMOID 
FLMXD               EQU      FLMYD + 2                    ; 'X' DISPLACEMENT FOR FLAMOID 
FLMYW               EQU      FLMXD + 2                    ; ABSOLUTE 'Y' FOR FLAMOID 
FLMXW               EQU      FLMYW + 2                    ; ABSOLUTE 'X' FOR FLAMOID 
FLMZW               EQU      FLMXW + 2                    ; 'Z' VALUE FOR 'PRJCTN' 
FLMTMR              EQU      FLMZW + 1                    ; FLAMOID TIMER 
;
FLMLEN              EQU      FLMTMR + 1                   ; FLAMOID TABLE ENTRY LENGTH 
;
FLMTBL              DS       FLMLEN * FLMCNT 
;
FLM_00              EQU      FLMTBL 
FLM_01              EQU      FLM_00 + FLMLEN 
FLM_02              EQU      FLM_01 + FLMLEN 
FLM_03              EQU      FLM_02 + FLMLEN 
;
ENDFLM              EQU      * 
;
;
;
;
;  EXPLOSION TABLE
;  ===============
;
EXPFLG              EQU      0                            ; EXPLOSION FLAG 
;                                       01 = EXPLOSION FRAGMENT ACTIVE
EXPYD               EQU      EXPFLG + 1                   ; 'Y' DISPLACEMENT FOR FRAGMENT 
EXPXD               EQU      EXPYD + 2                    ; 'X' DISPLACEMENT FOR FRAGMENT 
EXPYW               EQU      EXPXD + 2                    ; ABSOLUTE 'Y' FOR FRAGMENT 
EXPXW               EQU      EXPYW + 2                    ; ABSOLUTE 'X' FOR FRAGMENT 
EXPSIZ              EQU      EXPXW + 2                    ; EXPLOSION SIZE 
EXPROT              EQU      EXPSIZ + 1                   ; EXPLOSION ROTATIONAL VALUE 
EXPRAT              EQU      EXPROT + 1                   ; EXPLOSION ROTATIONAL RATE 
EXPTR               EQU      EXPRAT + 1                   ; POINTER TO FRAGMENT 'DUFFY' 
EXPTMR              EQU      EXPTR + 2                    ; EXPLOSION TIMER 
;
EXPLEN              EQU      EXPTMR + 1                   ; EXPLOSION TABLE ENTRY LENGTH 
;
EXPTBL              DS       EXPLEN * EXPCNT 
;
EXP_00              EQU      EXPTBL 
EXP_01              EQU      EXP_00 + EXPLEN 
EXP_02              EQU      EXP_01 + EXPLEN 
EXP_03              EQU      EXP_02 + EXPLEN 
;
ENDEXP              EQU      * 
;
;
;         MSG     'END OF RAM - BRIGANDS = ',*
;
;         IF      * < UP.RAM
;         MSG     '----- UPPER RAM ALLOCATIONS VIOLATED -----'
;         ENDIF
;
;
;
;
;  ************************************************************
;  ************************************************************
;  ***                                                      ***
;  ***          O V E R - L A Y E D   S T O R A G E         ***
;  ***                                                      ***
;  ***          M A G I C I A N   S U B  -  P L O T         ***
;  ***                                                      ***
;  ************************************************************
;  ************************************************************
;
                    bss      
                    ORG      ENDWRK 
;        ===     ======
;
WZCNT               DB       0                            ; WIZARD ANIMATION COUNTER 
WZINT               DB       0                            ; WIZARD INTENSITY MODIFIER 
WZDON               DB       0                            ; WIZARD ACTION COMPLETED 
;
;
;         MSG     'END OF RAM - MAGICIAN = ',*
;
;         IF      * < UP.RAM
;         MSG     '----- UPPER RAM ALLOCATIONS VIOLATED -----'
;         ENDIF
;
;
;
;
;  ************************************************************
;  ************************************************************
;  ***                                                      ***
;  ***          O V E R - L A Y E D   S T O R A G E         ***
;  ***                                                      ***
;  ***         K E Y   R I D D L E   S U B - P L O T        ***
;  ***                                                      ***
;  ************************************************************
;  ************************************************************
;
                    bss      
                    ORG      ENDWRK 
;        ===     ======
;
RKEY0               DB       0                            ; FIRST KEY ($00 - $04) 
RKEY1               DB       0                            ; SECOND KEY 
RKEY2               DB       0                            ; THIRD KEY 
RKEY3               DB       0                            ; FOURTH KEY 
;
RKPTR               DB       0                            ; KEY POINTER ($00 - $03) 
;
;
;         MSG     'END OF RAM - RIDDLE   = ',*
;
;         IF      * < UP.RAM
;         MSG     '----- UPPER RAM ALLOCATIONS VIOLATED -----'
;         ENDIF
;
;
;
;         IF      L.STOR = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;
;
;  *********************************************************
;  *********************************************************
;  ***                                                   ***
;  ***          R E A D - O N L Y   M E M O R Y          ***
;  ***                                                   ***
;  *********************************************************
;  *********************************************************
;
                    code     
                    ORG      $0000 
;        ===     =====
;
                    DB       $67, ' GCE 1983',$80
                    DW       OPNING 
;
                    DW       $F850 
                    DW       $40E0 
                    DB       'DARK',$80
                    DW       $F850 
                    DW       $20D8 
                    DB       'TOWER',$80
                    DB       0 
;
;
;         IF      L.INT = OFF      ;-------------------------------------------
;         LIST    -L               ;--  INIT  ---------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;  POWER-UP INITIALIZATION
;  =======================
;
                    direct   $D0 
;        =====   ===
;
ENTRY               JSR      DPRAM                        ; SET 'DP' = RAM 
                    direct   $C8                          ; . 
;
                    INC      ZSKIP                        ; SET POST-PACKET ZEROING FLAG 
;
                    LDD      #$0004                       ; SELECT GAME OPTIONS 
                    JSR      SELOPT                       ; . 
;
;
                    JSR      DPRAM                        ; SET 'DP' = RAM 
                    direct   $C8                          ; . 
;
                    LDA      #$EE                         ; SET-UP CONTROLLER FLAGS 
                    STA      SBTN                         ; . 
                    LDX      #$0103                       ; . 
                    STX      SJOY                         ; . 
;
                    LDX      #ETMP1                       ; CLEAR MEMORY 
INIT1               CLR      ,X+                          ; . 
                    CMPX     #STACK                       ; . 
                    BNE      INIT1                        ; . 
;
                    JSR      ISTARS                       ; INITIALIZE STAR BURST 
;
                    LDD      #$1000                       ; SET GAME-OVER TIME-OUT DURATION 
                    STD      TIMOUT                       ; . 
;
                    DEC      OPTION                       ; ESTABLISH STARTING NUMBER OF KEYS 
                    BLE      INIT2                        ; . STARTING KEYS DO NOT SCORE !! 
                    JSR      FNDSKY                       ; . GRANT ONE KEY (SILVER KEY) ? 
;
                    DEC      OPTION                       ; . GRANT SECOND KEY (BRONZE KEY) ? 
                    BLE      INIT2                        ; . . 
                    JSR      FNDBZK                       ; . . 
;
                    DEC      OPTION                       ; . GRANT THIRD KEY (BRASS KEY) ? 
                    BLE      INIT2                        ; . . 
                    JSR      FNDBSK                       ; . . 
;
INIT2               LDX      #M_PLAY                      ; CLEAR PLAYER'S SCORE 
                    LDU      #PLAYER                      ; . ESTABLISH PLAYER SCORE MESSAGE 
                    JSR      SMOVE                        ; . . 
;
                    LDD      #PLGTIM                      ; SET PLAGUE LOCK-OUT TIMER 
                    STD      PLGLCK                       ; . 
;
                    LDD      #HANDL1                      ; SET-UP FOR WARRIOR INSERTION 
                    STD      TMR1 + 1                     ; . SET TIME-OUT VECTOR 
                    LDA      #WARINS                      ; . SET INITIAL INSERTION TIME 
                    STA      TMR1                         ; . . 
;
                    LDD      #HANDL2                      ; SET-UP FOR BRIGAND INSERTION 
                    STD      TMR2 + 1                     ; . 
;
;
                    LDA      #$06                         ; SET REMAINING TROOP COUNT 
                    STA      TROOPS                       ; . 
;
                    LDX      #M_MEN                       ; INITIALIZE NUMBER OF TROOPS MESSAGE 
                    LDU      #MEN                         ; . 
                    JSR      SMOVE                        ; . 
;
;
                    LDD      #$0002                       ; SET NUMBER OF BAGS HELD COUNT (HEX) 
                    STD      BGOLD                        ; . 
;
                    LDX      #M_BAGS                      ; INITIALIZE BAGS OF GOLD MESSAGE 
                    LDU      #GOLD                        ; . 
                    JSR      SMOVE                        ; . 
;
INIT3               JSR      NEWMAP                       ; SET-UP LOCATION ON MAP 
                    LDA      MAPX                         ; . NEW POSITION WITHIN DEAD ZONE ? 
                    LSLA                                  ; . . 
                    ANDA     #$40                         ; . . 
                    ORA      MAPY                         ; . . 
                    ANDA     #$60                         ; . . 
                    BEQ      INIT3                        ; . . 
;
;
                    LDX      #ETMP1 - 1                   ; SET-UP KEY RIDDLE FOR THIS GAME 
                    LDD      #$0000                       ; . 
                    STD      ETMP1                        ; . 
                    STD      ETMP2                        ; . 
;
                    JSR      RANDOM                       ; . DETERMINE FIRST KEY TYPE 
                    ANDA     #$03                         ; . . KEYS RANGE FROM $01 TO $04 
                    INCA                                  ; . . 
                    STA      KRIDL0                       ; . . 
                    STA      TEMP1                        ; . . 
                    INC      A,X                          ; . . 
;
INIT4               JSR      RANDOM                       ; . DETERMINE SECOND KEY TYPE 
                    ANDA     #$03                         ; . . 
                    INCA                                  ; . . 
                    STA      KRIDL1                       ; . . 
                    LDB      A,X                          ; . . IS THIS KEY ALREADY SET ? 
                    BNE      INIT4                        ; . . . 
                    INC      A,X                          ; . . SET KEY 
                    ADDA     TEMP1                        ; . . 
                    STA      TEMP1                        ; . . 
;
INIT5               JSR      RANDOM                       ; . DETERMINE THIRD KEY TYPE 
                    ANDA     #$03                         ; . . 
                    INCA                                  ; . . 
                    STA      KRIDL2                       ; . . 
                    LDB      A,X                          ; . . IS THIS KEY ALREADY SET ? 
                    BNE      INIT5                        ; . . . 
                    INC      A,X                          ; . . SET KEY 
                    ADDA     TEMP1                        ; . . 
                    STA      TEMP1                        ; . . 
;
                    LDA      #$0A                         ; . DETERMINE FOURTH KEY TYPE 
                    SUBA     TEMP1                        ; . . 
                    STA      KRIDL3                       ; . . 
;
;         IF      L.INT = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;.............................................................................
;.............................................................................
;
                    include  "forest.asm"
                    include  "scenry.asm"
                    include  "warior.asm"
                    include  "grdscn.asm"
;
;.............................................................................
;
                    include  "brgand.asm"
                    include  "goblin.asm"
                    include  "fight.asm"
                    include  "flamer.asm"
                    include  "frgmnt.asm"
                    include  "colide.asm"
;
;.............................................................................
;
                    include  "magic.asm"
                    include  "wizard.asm"
;
;.............................................................................
;
                    include  "tower.asm"
;
;.............................................................................
;
                    include  "invent.asm"
                    include  "sound.asm"
                    include  "timers.asm"
                    include  "subr.asm"
;
;.............................................................................
;
                    include  "map.asm"
                    include  "packs.asm"
