; Fortress of Narzod as gotten from John Hall's web site:
; https://roadsidethoughts.com/vectrex/fortress-of-narzod.htm
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
; The resulting binary 
; could not be directly compared to any known dump, since 
; I have no "Revision B" dump - was it every released in cartridge form?

                    include  "BIOS.I"
                    include  "DECL.I"
                    include  "OTHER.I" ; gotton from Minestorm, or "by hand" 

                    noopt    

;  *********************************************************
;  *********************************************************
;  ***                                                   ***
;  ***          G C E     === V E C T R E X ===          ***
;  ***                                                   ***
;  ***             F O R T R E S S   O F   N A R Z O D   ***
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
;   B     8/25/83   JJH      MISC. CODE COMPACTION
;                            ADDED LISTING CONTROLS
;                            CORRECTED BLASTER COUNTER DURING TWO PLAYER MODE
;                            CORRECTED KILLER ABORT / TWO PLAYER SWITCHING
;
;   A     5/05/83   JJH      EXPANDED THE INTER-LINE SPACING FOR THE
;                               'ABANDON ALL HOPE' MESSAGE
;
;   -    12/26/82   JJH      INITIAL RELEASE
;
;=============================================================================
;
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
;L.STOR   EQU     ON  OR L.ALL     ;  LIST WORKING STORAGE ?
;
;L.INIT   EQU     ON  OR L.ALL     ;  LIST SECTION 'INIT.NAR' ?
;L.MAIN   EQU     ON  OR L.ALL     ;  LIST SECTION 'MAIN.NAR' ?
;L.KIL    EQU     ON  OR L.ALL     ;  LIST SECTION 'KILLER.NAR' ?
;
;L.BLST   EQU     OFF OR L.ALL     ;  LIST SECTION 'GBLAST.NAR' ?
;L.BLT    EQU     OFF OR L.ALL     ;  LIST SECTION 'GBULET.NAR' ?
;L.GRD    EQU     OFF OR L.ALL     ;  LIST SECTION 'GGUARD.NAR' ?
;L.SPK    EQU     OFF OR L.ALL     ;  LIST SECTION 'GSPIKE.NAR' ?
;L.BRD    EQU     OFF OR L.ALL     ;  LIST SECTION 'GBIRD.NAR' ?
;L.TAIL   EQU     ON  OR L.ALL     ;  LIST SECTION 'TAIL.NAR' ?
;
;L.CIT    EQU     OFF OR L.ALL     ;  LIST SECTION 'CITDEL.NAR' ?
;L.SND    EQU     OFF OR L.ALL     ;  LIST SECTION 'SOUND.NAR' ?
;L.COL    EQU     OFF OR L.ALL     ;  LIST SECTION 'COLLIDE.NAR' ?
;L.TMR    EQU     OFF OR L.ALL     ;  LIST SECTION 'TIMERS.NAR' ?
;L.SUBR   EQU     OFF OR L.ALL     ;  LIST SECTION 'SUBR.NAR' ?
;
;L.GAM    EQU     OFF OR L.ALL     ;  LIST SECTION 'GAME.NAR' ?
;L.WALL   EQU     OFF OR L.ALL     ;  LIST SECTION 'WALLS.NAR' ?
;L.PRS    EQU     OFF OR L.ALL     ;  LIST SECTION 'PRSPCT.NAR' ?
;L.PCK    EQU     OFF OR L.ALL     ;  LIST SECTION 'PACKS.NAR' ?
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
BULETS   EQU     5                ;  SIZE OF BULLET TABLE
GUARDS   EQU     6                ;  SIZE OF GUARDIAN TABLE
BIRDS    EQU     3                ;  SIZE OF WAR-BIRD TABLE
;
BLEFT    EQU     KEY0             ;  BLASTER LEFT BUTTON
BRGHT    EQU     KEY1             ;  BLASTER RIGHT BUTTON
BFIRE    EQU     KEY3             ;  FIRE BUTTON
;
LLIMIT   EQU     $90              ;  BLASTER LOWER-LIMIT
ULIMIT   EQU     $10              ;  BLASTER UPPER-LIMIT (ACTIVE = 1)
GLIMIT   EQU     $5C              ;  BLASTER UPPER-LIMIT (ACTIVE = 0)
KLIMIT   EQU     $F0              ;  BLASTER UPPER-LIMIT (KILLER SEQUENCE)
BLBIAS   EQU     $05              ;  BLASTER SIZE VS. DEPTH BIAS
;
SPKSPD   EQU     $40              ;  SPIKER SPEED
;
WALLA    EQU     0                ;  WALL ANGLE
WALLYS   EQU     WALLA + 1        ;  WALL STARTING 'Y' POINT
WALLYE   EQU     WALLYS + 1       ;  WALL ENDING 'Y' POINT
WALLXS   EQU     WALLYE + 1       ;  WALL STARTING 'X' POINT
WALLXE   EQU     WALLXS + 1       ;  WALL ENDING 'X' POINT
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
         ORG     $C8B6
;        ===     =====
;
LASTY    DW      0                ;  LAST 'Y' POSITION
NEXTY    DW      0                ;  NEXT 'Y' POSITION
LASTX    DW      0                ;  LAST 'X' POSITION
NEXTX    DW      0                ;  NEXT 'X' POSITION
;
DELTAY   DW      0                ;  'Y' AXIS DISPLACEMENT
DELTAX   DW      0                ;  'X' AXIS DISPLACEMENT
DOTTMP   DW      0                ;  WORKING STORAGE FOR DOT PRODUCT
BNCTBL   DW      0                ;  POINTER TO BOUNCE LOOK-UP TABLE
;
CWALYS   DB      0                ;  'Y' START FOR INDICATED WALL
CWALYE   DB      0                ;  'Y' END FOR INDICATED WALL
CWALXS   DB      0                ;  'X' START FOR INDICATED WALL
CWALXE   DB      0                ;  'X' END FOR INDICATED WALL
;
ABORT    DB      0                ;  GAME ABORT FLAG
LOCK     DB      0                ;  LOCK-UP ON GAME SEQUENCE
;
;
LFLAG    DB      0                ;  ROAD-WAY LEVEL FLAG
GRDTYP   DB      0                ;  GUARDIAN TYPE FOR THIS LEVEL
;
;
GAMCMD   DB      0                ;  LEVEL COMMAND FLAGS
ACTLVL   DB      0                ;  ACTIVE GAME LEVEL
TOTGRD   DB      0                ;  TOTAL GUARDIAN COUNT FOR THIS TYPE
TOTBRD   DB      0                ;  TOTAL WAR-BIRD COUNT
GUARDY   DW      0                ;  GUARDIAN VERTICAL SPEED
GUARDX   DW      0                ;  GUARDIAN HORIZONTAL SPEED
;
CITFLG   DB      0                ;  BLASTER STILL ON ROADWAY
ACTIVE   DB      0                ;  GAME ACTIVITY PENDING - INHIBIT GATEWAY
;
KILFLG   DB      0                ;  KILLER LEVEL FLAG
KILHIT   DB      0                ;  KILLER HIT COUNTER
KILXD    DW      0                ;  KILLER 'X' DISPLACEMENT
KILDED   DB      0                ;  KILLER DEAD FLAG
;
;
BLSTYD   DW      0                ;  'Y' DISPLACEMENT FOR BLASTER
BLSTXD   DW      0                ;  'X' DISPLACEMENT FOR BLASTER
BLSTY    DW      0                ;  ABSOLUTE 'Y' FOR BLASTER
BLSTX    DW      0                ;  ABSOLUTE 'X' FOR BLASTER
BLSTYX   DW      0                ;  ABSOLUTE 'YX' VALUE FOR BLASTER
;
BLSTSZ   DB      0                ;  CURRENT BLASTER SIZE
BLSTR    DB      0                ;  CURRENT RIGHT LIMIT FOR BLASTER
BLSTL    DB      0                ;  CURRENT LEFT LIMIT FOR BLASTER
BLSTBX   DW      0                ;  CURRENT COLLISION BOX FOR BLASTER
;
BLSTMR   DB      0                ;  TIMER FOR BLASTER
;
;
SHOOT    DB      0                ;  BULLET FIRING SOUND FLAG
OUCH     DB      0                ;  GUARDIAN OUCH SOUND FLAG
SIZZLE   DB      0                ;  CITADEL DISINTEGRATING SOUND FLAG
SQUAWK   DB      0                ;  WAR-BIRD SQUAWK SOUND FLAG
EXPLO1   DB      0                ;  GUARDIAN EXPLOSION SOUND FLAG
EXPLO2   DB      0                ;  BLASTER EXPLOSION SOUND FLAG
;
BASFRQ   DS      2                ;  BASE FREQUENCY FOR GUARDIAN OUCH
SIZCNT   DS      1                ;  TIMER FOR MAXIMUM INTENSITY DURING SIZZLE
;
;
EKLTMR   DB      0                ;  KILLER EXPLOSION TIMER
EXPTMR   DB      0                ;  BLASTER EXPLOSION TIMER
KLLINT   DB      0                ;  FORTRESS INTENSITY FOR KILLER SEQUENCE
;
EBLYD1   DW      0                ;  POSITION FOR BLASTER FRAGMENT #1
EBLXD1   DW      0                ;  .
EBLYW1   DW      0                ;  .
EBLXW1   DW      0                ;  .
EBLYX1   DW      0                ;  .
EBLRT1   DB      0                ;  .
;
EBLYD2   DW      0                ;  POSITION FOR BLASTER FRAGMENT #2
EBLXD2   DW      0                ;  .
EBLYW2   DW      0                ;  .
EBLXW2   DW      0                ;  .
EBLYX2   DW      0                ;  .
EBLRT2   DB      0                ;  .
;
EBLYD3   DW      0                ;  POSITION FOR BLASTER FRAGMENT #3
EBLXD3   DW      0                ;  .
EBLYW3   DW      0                ;  .
EBLXW3   DW      0                ;  .
EBLYX3   DW      0                ;  .
EBLRT3   DB      0                ;  .
;
BLSCNT   DB      0                ;  CURRENT BLASTER COUNT FOR ACTIVE PLAYER
;
;
CBLT     DB      0                ;  ACTIVE BULLET COUNTER
CGRD     DB      0                ;  ACTIVE GUARDIAN COUNTER
CSPK     DB      0                ;  ACTIVE SPIKER COUNTER
CBRD     DB      0                ;  ACTIVE WAR-BIRD COUNTER
;
BTNTMR   DW      0                ;  PLAYER ACTIVITY TIMER
SPKTIM   DB      0                ;  RANDOM SPIKER RELEASE TIMER
LVLTMR   DB      0                ;  LEVEL DISPLAY TIMER
TIMOUT   DW      0                ;  LONG TIME-OUT DELAY
LCKTMR   DB      0                ;  LOCK-UP TIMER
;
;
TBLPT1   DW      0                ;  GAME-LEVEL TABLE POINTERS
         DB      0                ;  .    PLAYER #1
         DB      0                ;  .    .    LEVEL FLAG
         DB      0                ;  .    .    GUARDIAN COUNTER
         DB      0                ;  .    .    WAR-BIRD COUNTER
         DB      0                ;  .    .    BLASTER COUNT
;
TBLPT2   DW      0                ;  .    PLAYER #2
         DB      0                ;  .    .    GUARDIAN TYPE
         DB      0                ;  .    .    LEVEL FLAG
         DB      0                ;  .    .    GUARDIAN COUNTER
         DB      0                ;  .    .    WAR-BIRD COUNTER
         DB      0                ;  .    .    BLASTER COUNT
;
FIELD1   DS      7                ;  ACTIVE FIELD FOR PLAYER #1
FIELD2   DS      7                ;  ACTIVE FIELD FOR PLAYER #2;
;
;
;
;
;  BULLET TABLE
;  ============
;
BLTFLG   EQU     0                ;  BULLET FLAG
BLTYD    EQU     BLTFLG + 1       ;  WORKING 'Y' DISPLACEMENT
BLTXD    EQU     BLTYD + 2        ;  WORKING 'X' DISPLACEMENT
BLTYW    EQU     BLTXD + 2        ;  WORKING 'Y' POSITION
BLTXW    EQU     BLTYW + 2        ;  WORKING 'X' POSITION
BLTYX    EQU     BLTXW + 2        ;  ABSOLUTE 'YX' POSITION
BLTANG   EQU     BLTYX + 2        ;  CURRENT BULLET ANGLE
BLTERG   EQU     BLTANG + 1       ;  BULLET ENERGY LEVEL
BLTBNC   EQU     BLTERG + 1       ;  BULLET BOUNCE COUNTER
BLTHLD   EQU     BLTBNC + 1       ;  BULLET BOUNCE HOLD-OFF
;
BLTLEN   EQU     BLTHLD + 1       ;  BULLET TABLE LENGTH
;
BLTTBL   DS      BLTLEN * BULETS  
;
WARBLT   DS      BLTLEN * 4       ;  MINI-BULLET TABLE FOR WAR-BIRD
;
ENDBLT   EQU     *
;
;
;
;      
;  GUARDIAN TABLE
;  ==============
;
GRDFLG   EQU     0                ;  GUARDIAN FLAG
;                                        01 = LEVEL #1
;                                        09 = LEVEL #2
;                                        11 = LEVEL #3
;                                        19 = KILLER SEGMENT #0
;                                        21 = KILLER SEGMENT #1
;                                        29 = KILLER SEGMENT #2
;                                        40 = GUARDIAN IS FALLING
;                                        80 = GUARDIAN IS DYING
GRDYD    EQU     GRDFLG + 1       ;  WORKING 'Y' DISPLACEMENT
GRDXD    EQU     GRDYD + 2        ;  WORKING 'X' DISPLACEMENT
GRDYW    EQU     GRDXD + 2        ;  WORKING 'Y' POSITION
GRDXW    EQU     GRDYW + 2        ;  WORKING 'X' POSITION
GRDYX    EQU     GRDXW + 2        ;  ABSOLUTE 'YX' POSITION
GRDANG   EQU     GRDYX + 2        ;  ANGLE OF MOTION
GRDSIZ   EQU     GRDANG + 1       ;  GUARDIAN ZOOM SIZE
GRDTMR   EQU     GRDSIZ + 1       ;  GUARDIAN TIMER
GRDERG   EQU     GRDTMR + 1       ;  GUARDIAN ENERGY LEVEL
;
GRDLEN   EQU     GRDERG + 1       ;  TABLE LENGTH
;
GRDTBL   DS      GRDLEN * GUARDS
;
ENDGRD   EQU     *
;
GRD_00   EQU     GRDTBL
GRD_01   EQU     GRD_00 + GRDLEN
GRD_02   EQU     GRD_01 + GRDLEN
GRD_03   EQU     GRD_02 + GRDLEN
;
;
;
;
;  SPIKER TABLE
;  ============
;
SPKFLG   EQU     0                ;  SPIKER FLAG
;                                        80 = GUARDIAN IS STILL HOLDING SPIKER
;                                        40 = SPLIT SPIKER
SPKYD    EQU     SPKFLG + 1       ;  WORKING 'Y' DISPLACEMENT
SPKXD    EQU     SPKYD + 2        ;  WORKING 'X' DISPLACEMENT
SPKYW    EQU     SPKXD + 2        ;  WORKING 'Y' POSITION
SPKXW    EQU     SPKYW + 2        ;  WORKING 'X' POSITION
SPKYX    EQU     SPKXW + 2        ;  ABSOLUTE 'YX' POSITION
SPKANG   EQU     SPKYX + 2        ;  CURRENT SPIKER ANGLE
SPKSIZ   EQU     SPKANG + 1       ;  SPIKER ZOOM SIZE
SPKHLD   EQU     SPKSIZ + 1       ;  SPIKER BOUNCE HOLD-OFF
;
SPKLEN   EQU     SPKHLD + 1       ;  TABLE LENGTH
;
SPKTBL   DS      SPKLEN * GUARDS
;
SPK_00   EQU     SPKTBL
SPK_01   EQU     SPK_00 + SPKLEN
SPK_02   EQU     SPK_01 + SPKLEN
SPK_03   EQU     SPK_02 + SPKLEN
;
;
DBLSPK   DS      SPKLEN * 4
;
ENDSPK   EQU     *
;
;
;
;      
;  WAR-BIRD TABLE
;  ==============
;
BRDFLG   EQU     0                ;  WAR-BIRD FLAG
;                                        80 = SHIELD MODE
;                                        40 = OVER ROAD-WAY FLAG
BRDYD    EQU     BRDFLG + 1       ;  WORKING 'Y' DISPLACEMENT
BRDXD    EQU     BRDYD + 2        ;  WORKING 'X' DISPLACEMENT
BRDYW    EQU     BRDXD + 2        ;  WORKING 'Y' POSITION
BRDXW    EQU     BRDYW + 2        ;  WORKING 'X' POSITION
BRDYX    EQU     BRDXW + 2        ;  ABSOLUTE 'YX' POSITION
BRDANG   EQU     BRDYX + 2        ;  ANGLE OF MOTION
BRDSIZ   EQU     BRDANG + 1       ;  ZOOM SIZE
BRDTMR   EQU     BRDSIZ + 1       ;  MOTION TIMER
BRDBOX   EQU     BRDTMR + 1       ;  COLLISION BOX PARAMETERS
;
BRDLEN   EQU     BRDBOX + 2       ;  TABLE LENGTH
;
BRDTBL   DS      BRDLEN * BIRDS
;
ENDBRD   EQU     *
;
BRD_00   EQU     BRDTBL
BRD_01   EQU     BRD_00 + BRDLEN
BRD_02   EQU     BRD_01 + BRDLEN
BRD_03   EQU     BRD_02 + BRDLEN
;
;
;
;
;  EXPLOSION TABLE FOR KILLER SEQUENCE
;  ===================================
;
EKLYD    EQU     0                ;  'Y' DISPLACEMENT
EKLXD    EQU     EKLYD + 2        ;  'X' DISPLACEMENT
EKLYW    EQU     EKLXD + 2        ;  CURRENT 'Y' POSITION
EKLXW    EQU     EKLYW + 2        ;  CURRENT 'X' POSITION
EKLYX    EQU     EKLXW + 2        ;  CURRENT 'YX' POSITION
EKLROT   EQU     EKLYX + 2        ;  ROTATIONAL COUNTER
;
EKLLEN   EQU     EKLROT + 1       ;  TABLE LENGTH
;
EKLTBL   EQU     BRDTBL
;
EKL_00   EQU     EKLTBL
EKL_01   EQU     EKL_00 + EKLLEN
EKL_02   EQU     EKL_01 + EKLLEN
EKL_03   EQU     EKL_02 + EKLLEN
;
;
;
RSPKR    DS      $20              ;  ROTATING SPIKER 'DUFFY'
;
RGRD1    EQU     RSPKR            ;  ROTATING GUARDIAN DISMEMBERMENT
RGRD2    DS      $20              ;  .
RGRD3    DS      $20              ;  .
;
;
CR_LIM   DS      32               ;  RIGHT LIMITS OF ROADWAY
CL_LIM   DS      32               ;  LEFT LIMITS OF ROADWAY
;
CHRLIM   DS      32               ;  RIGHT LIMITS OF HIDDEN ROADWAY
CHLLIM   DS      32               ;  LEFT LIMITS OF HIDDEN ROADWAY
;
ENDRAM   EQU     *
;
;
;         MSG     'END OF RAM      = ',*
;
;
;         IF      L.STOR = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
         include "init.asm"
         include "main.asm"
         include "killer.asm"
;
         include "gblast.asm"
         include "gbulet.asm"
         include "gguard.asm"
         include "gspike.asm"
         include "gbird.asm"
;
         include "tail.asm"
         include "citdel.asm"
         include "sound.asm"
;
         include "collide.asm"
;
         include "timers.asm"
         include "subr.asm"
;
         include "game.asm"
         include "walls.asm"
         include "prspct.asm"
         include "packs.asm"

