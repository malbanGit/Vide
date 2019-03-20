; Minestorm as gotten from John Hall's web site:
; https://roadsidethoughts.com/vectrex/mine-storm.htm
;
; this version was "fitted" to be compilable with Vide
; changes made:
; 1) exclude all linker stuff
; 2) replace all „.“ with „_“
; 4) ensure all RAM locations are „BSS“
; 5) LDA X (and the like) statments changed to LDA ,X
; 6) changed the name and added "copyright" so that the resulting binary
;    a) is runnable as a seperate cartridge
;    b) still has the same address for "ENTRY"
;       that way addresses are stilll compareable to the BIOS version
;       (just add $e000)
;       (data addresses after the last subroutine, might be different since this might be
;        the bugfixed version!)
; 
;
 noopt
; MINESTRM_ASM - Rev. C


;  *********************************************************
;  *********************************************************
;  ***                                                   ***
;  ***          G C E     === V E C T R E X ===          ***
;  ***                                                   ***
;  ***                     M I N E   S T O R M           ***
;  ***                                                   ***
;  *********************************************************
;  *********************************************************
;
;
;
;  C O M M E N T S
;  ---------------
;
;       MUST BE ASSEMBLED USING AVOCET 'ASM09'
;
;
;
;=============================================================================
;
;  REV     DATE     PROG     COMMENT(S)
;  ---     ----     ----     ----------
;
;   C    12/23/82   JJH      CORRECTED GAME LEVEL SEQUENCING PROBLEM
;                            LIMITED NUMBER OF MARKERS THAT CAN BE DISPLAYED
;                            MUST KILL MINE-LAYER DURING RESEEDING
;                            MODIFIED MINE FIELD MESSAGE FOR THREE DIGITS
;                                (REV. B & C CAUSED BY RUM CHANGES)
;
;   B    07/29/82   JJH      CORRECTED HIGH-SCORE PROBLEM
;
;   A    07/15/82   JJH      MODIFIED TO REFLECT 'RUM' REV. A CHANGES
;
;   -    05/16/82   RELEASE FROM WESTERN TECHNOLOGIES
;
;=============================================================================
;
;
;
;  'EXECUTIVE' EQUATES
;  ===================
;
;
REG0     EQU     $C800            ;  SOUND GENERATOR (PSG) MIRROR IMAGE
REG2     EQU     $C802            ;  .
;
TRIGGR   EQU     $C80F            ;  COLLECTIVE SWITCH SETTINGS
KEY0     EQU     $C812            ;  CONTROLLER #1 - SWITCH #0 (LEFT)
KEY1     EQU     $C813            ;  .
KEY2     EQU     $C814            ;  .
KEY3     EQU     $C815            ;  .             - SWITCH #3 (RIGHT)
;
POT0     EQU     $C81B            ;  JOYSTICK #1 - 'X' AXIS
POT1     EQU     $C81C            ;  .           - 'Y' AXIS
;
EPOT0    EQU     $C81F            ;  ENABLE POT READ
EPOT2    EQU     $C821            ;  .
;
LIST     EQU     $C823            ;  NUMBER OF VECTORS - 1
ZSKIP    EQU     $C824            ;  SKIP INTEGRATOR ZEROING AND ACTIVE GROUND
FRAME    EQU     $C826            ;  FRAME COUNTER
;
SIZRAS   EQU     $C82A            ;  RASTER MESSAGE SIZE
LEG      EQU     $C83B            ;  EXECUTIVE WORKING STORAGE
TSTAT    EQU     $C856            ;  TUNE STATUS
;
PLAYRS   EQU     $C879            ;  NUMBER OF PLAYERS IN GAME
OPTION   EQU     $C87A            ;  GAME OPTION NUMBER
;
HISCOR   EQU     $CBEB            ;  HIGH-SCORE
;
;
T1LOLC   EQU     $D004            ;  TIMER #1 (LSB)
;
;
PWRUP    EQU     $F000            ;  POWER-UP HANDLER
COLD0    EQU     $F01C            ;  VECTREX RESTART ENTRY FOR MINE-STORM
INTALL   EQU     $F18B            ;  COMPLETE INTIALIZATION
FRWAIT   EQU     $F192            ;  WAIT FOR FRAME BOUNDARY
;
DPIO     EQU     $F1AA            ;  SET DIRECT REGISTER
DPRAM    EQU     $F1AF            ;  .
;
DBNCE    EQU     $F1B4            ;  READ CONTROLLER BUTTONS
INPUT    EQU     $F1BA            ;  .
JOYBIT   EQU     $F1F8            ;  READ JOYSTICKS
;
WRREG    EQU     $F256            ;  WRITE TO PSG
INTPSG   EQU     $F272            ;  INITIALIZE SOUND GENERATOR
PSGLST   EQU     $F27D            ;  SEND SOUND STRING TO PSG
REQOUT   EQU     $F289            ;  SEND 'REQX' TO PSG AND MIRROR
;
INT3Q    EQU     $F2A5            ;  SET INTENSITY
INTMAX   EQU     $F2A9            ;  .
INTENS   EQU     $F2AB            ;  .
;
DOTAB    EQU     $F2C3            ;  DRAW ONE DOT FROM THE CONTENTS OF 'A' & 'B'
DIFDOT   EQU     $F2D5            ;  DRAW DOTS ACCORDING TO 'DIFFY' FORMAT
;
DEFLOK   EQU     $F2E6            ;  OVER-COME SCAN COLLAPSE CIRCUITRY
POSWID   EQU     $F2F2            ;  POSITION RELATIVE VECTOR
POSITD   EQU     $F2FC            ;  .
POSITN   EQU     $F312            ;  .
ZERGND   EQU     $F354            ;  ZERO INTEGRATORS AND SET ACTIVE GROUND
RSTSIZ   EQU     $F373            ;  DISPLAY RASTER MESSAGE
;
TPACK    EQU     $F40E            ;  DRAW FROM 'PACKET' STYLE LIST
PACKET   EQU     $F410            ;  .
RASTER   EQU     $F495            ;  DISPLAY RASTER STRING
;
RANDOM   EQU     $F517            ;  CALCULATE RANDOM NUMBER
BCLR     EQU     $F53F            ;  CLEAR MEMORY BLOCK
CMPASS   EQU     $F593            ;  DETERMINE ANGLE FROM DELTA 'Y:X'
LNROT    EQU     $F601            ;  SINGLE LINE ROTATE
PROT     EQU     $F61F            ;  'PACKET' STYLE ROTATE
;
REPLAY   EQU     $F687            ;  SET 'REQX' FOR GIVEN TUNE
SPLAY    EQU     $F68D            ;  .
;
SELOPT   EQU     $F7A9            ;  FETCH GAME OPTIONS
;
SCLR     EQU     $F84F            ;  CLEAR INDICATED SCORE
SCRADD   EQU     $F87C            ;  ADD CONTENTS OF 'D' TO INDICATED SCORE
HISCR    EQU     $F8D8            ;  CALCULATE HIGH SCORE AND SAVE FOR LOGO
BXTEST   EQU     $F8FF            ;  SYMMETRIC COLLISION TEST
;
VIBENL   EQU     $FEB6
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
RATE     EQU     50               ;  FRAME RATE (HERTZ)
;
;
THYPER   EQU     $20              ;  HYPER-SPACE TIME
;
BULLETS  EQU     4                ;  NUMBER OF BULLETS
MINES    EQU     28               ;  NUMBER OF MINES
;
;
PSCOR1   EQU     $7FA0            ;  POSITION OF PLAYER #1 SCORE
PSCOR2   EQU     $7F10            ;  POSITION OF PLAYER #2 SCORE
;
;
P_SHPSZ  EQU     $0C              ;  INITIAL STAR-SWEEPER SIZE
;
P_LYRSZ  EQU     $08              ;  INITIAL MINE-LAYER SIZE
P_LYRSP  EQU     $10              ;  MINE-LAYER SPEED OFFSET
P_LYRBX  EQU     $0616            ;  MINE-LAYER COLLISION BOX
;
;
MIN_SIZ1 EQU     $10              ;  MINE #1 (LARGE) SIZE
MIN_SIZ2 EQU     $07              ;  MINE #2
MIN_SIZ3 EQU     $02              ;  MINE #3 (SMALLEST)
;
MIN_SPD1 EQU     $10              ;  MINE #1 (LARGE) SPEED
MIN_SPD2 EQU     $18              ;  MINE #2
MIN_SPD3 EQU     $20              ;  MINE #3 (SMALLEST)
;
MIN_BOX1 EQU     $0D0D            ;  MINE #1 (LARGE) COLLISION BOX
MIN_BOX2 EQU     $0808            ;  MINE #2
MIN_BOX3 EQU     $0404            ;  MINE #3 (SMALLEST)
;
M_DUMB   EQU     $00              ;  'DUMB' MINE FLAG
M_MAG    EQU     $01              ;  'MAGNETIC' MINE FLAG
M_FIRE   EQU     $02              ;  'FIREBALL' MINE FLAG
M_MFIRE  EQU     $03              ;  'MAGNETIC FIREBALL' MINE FLAG
FIRBALL  EQU     $04              ;  'RELEASED' FIREBALL
;
;
S_ABRT   EQU     KEY3             ;  TITLE PAGE ABORT
S_THRST  EQU     KEY2             ;  THRUST SWITCH
S_FIRE   EQU     KEY3             ;  FIRE SWITCH
S_HYPER  EQU     KEY1             ;  HYPERSPACE SWITCH
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
;
 bss
         ORG     $C880
;        ===     =====
;
SBTN     DB      0                ;  CONTROLLER DEBOUNCE FLAGS
SJOY     DW      0                ;  JOYSTICK 'BANG' FLAGS
;
;
ETMP1    DB      0                ;  TEMPORARY WORKING STORAGE (FIRST LEVEL)
ETMP2    DB      0                ;  .
ETMP3    DB      0                ;  .
ETMP4    DB      0                ;  .
ETMP5    DB      0                ;  .
ETMP6    DB      0                ;  .
ETMP7    DB      0                ;  .
ETMP8    DB      0                ;  .
ETMP9    DB      0                ;  .
ETMP10   DB      0                ;  .
;
         DW      0                ;  .    WORKING STORAGE SLOP
;
TEMP1    DB      0                ;  TEMPORARY WORKING STORAGE (SECOND LEVEL)
TEMP2    DB      0                ;  .
TEMP3    DB      0                ;  .
TEMP4    DB      0                ;  .
TEMP5    DB      0                ;  .
TEMP6    DB      0                ;  .
TEMP7    DB      0                ;  .
TEMP8    DB      0                ;  .
TEMP9    DB      0                ;  .
TEMP10   DB      0                ;  .
;
         DW      0                ;  .    WORKING STORAGE SLOP
;
;
ACTPLY   DB      0                ;  ACTIVE PLAYER FLAG ($00 / $02)
;
;
TMR1     DB      0                ;  TIMER #1 - DOWN COUNTER
         DW      0                ;  .        - TIME-OUT ROUTINE POINTER
;
TMR2     DB      0                ;  TIMER #2 - DOWN COUNTER
         DW      0                ;  .        - TIME-OUT ROUTINE POINTER
;
TMR3     DB      0                ;  TIMER #3 - DOWN COUNTER
         DW      0                ;  .        - TIME-OUT ROUTINE POINTER
;
TMR4     DB      0                ;  TIMER #4 - DOWN COUNTER
         DW      0                ;  .        - TIME-OUT ROUTINE POINTER
;
;
SCOR1    DS      7                ;  PLAYER #1 SCORE
SCOR2    DS      7                ;  PLAYER #2 SCORE
;
;
BLTSND   DB      0                ;  BULLET SOUND FLAG
;
;
STAR1    DB      0                ;  TEMPORARY WORKING STORAGE (THIRD LEVEL)
STAR2    DB      0                ;  .
STAR3    DB      0                ;  .
STAR4    DB      0                ;  .
STAR5    DB      0                ;  .
STAR6    DB      0                ;  .
;
ABORT    DB      0                ;  GAME ABORT FLAG
LOCK     DB      0                ;  LOCK-UP ON GAME SEQUENCE
;
RSMINES  DB      0                ;  MINE-LAYER RE-SEED MINE COUNT
RESEED   DB      0                ;  MINE-LAYER RESEED FLAG
FRCTIME  DB      0                ;  FORCED GROWTH COUNTER
;
MINTABLE DW      0                ;  MINE FIELD POINTER FOR LAYER SEQUENCE
TBLPTR1  DW      0                ;  MINE FIELD POINTER FOR PLAYER #1
TBLPTR2  DW      0                ;  MINE FIELD POINTER FOR PLAYER #2
;
WSHIPY   DW      0                ;  WORKING 'Y' POSITION
WSHIPX   DW      0                ;  WORKING 'X' POSITION
DSHIPY1  DW      0                ;  'Y' DISPLACEMENT FOR MOMENTUM AXIS #1
DSHIPX1  DW      0                ;  'X' DISPLACEMENT FOR MOMENTUM AXIS #1
DSHIPY2  DW      0                ;  'Y' DISPLACEMENT FOR MOMENTUM AXIS #2
DSHIPX2  DW      0                ;  'X' DISPLACEMENT FOR MOMENTUM AXIS #2
SHIPROT  DB      0                ;  CURRENT SHIP ROTATION
SHIPSPD1 DB      0                ;  SPEED ALONG MOMENTUM AXIS #1
SHIPDIR1 DB      0                ;  DIRECTION OF MOMENTUM AXIS #1
SHIPSPD2 DB      0                ;  SPEED ALONG MOMENTUM AXIS #2
SHIPDIR2 DB      0                ;  DIRECTION OF MOMENTUM AXIS #2
SHIPCNT  DB      0                ;  CURRENT SHIP COUNT FOR ACTIVE PLAYER
SHIPCNT0 DB      0                ;  CURRENT SHIP COUNT FOR PLAYER #1
SHIPCNT1 DB      0                ;  CURRENT SHIP COUNT FOR PLAYER #2
;
LAYRYX   DW      0                ;  CURRENT MINE-LAYER POSITION (Y:X)
WLAYRY   DW      0                ;  .    WORKING 'Y' POSITION
WLAYRX   DW      0                ;  .    WORKING 'X' POSITION
DLAYRY   DW      0                ;  .    'Y' DISPLACEMENT
DLAYRX   DW      0                ;  .    'X' DISPLACEMENT
LAYRDIR  DB      0                ;  CURRENT MINE-LAYER DIRECTION
LAYRSPD  DB      0                ;  CURRENT MINE-LAYER SPEED
LAYRPTR  DW      0                ;  MINE-LAYER RE-SEEDING SEQUENCE POINTER
;
CBULLET  DB      0                ;  ACTIVE BULLET COUNTER
CMINES   DB      0                ;  ACTIVE MINE COUNTER
CEXPLS   DB      0                ;  ACTIVE EXPLOSION COUNTER
;
MINMAX   DB      0                ;  MAXIMUM MINES COUNT
;
HYPFLAG  DB      0                ;  HYPER-SPACE FLAG
HYPCNT   DB      0                ;  HYPER-SPACE SEQUENCE COUNTER
;
TIMEOUT  DW      0                ;  LONG TIME-OUT DELAY
;
THRSND   DB      0                ;  THRUSTER SOUND FLAG
EXPLSND  DB      0                ;  OBJECT EXPLOSION SOUND FLAG
POPSND   DB      0                ;  MINE 'POP' SOUND FLAG
FIRSND   DB      0                ;  'RELEASED' FIRE-BALL SOUND FLAG
HYPSND   DB      0                ;  HYPER-SPACE SOUND FLAG
;
SEXPCNT  DB      0                ;  SHIP EXPLOSION COUNTERS
SEXP1    DB      0                ;  .
;
MNLVL1   DS      7                ;  ACTIVE MINE-FIELD LEVEL FOR PLAYER #1
MNLVL2   DS      7                ;  ACTIVE MINE-FIELD LEVEL FOR PLAYER #2;
;
;        BULLET TABLE
;        ------------
;
DBLTY    DW      0                ;  'Y' DISPLACEMENT FOR ALL NEW BULLETS
DBLTX    DW      0                ;  'X' DISPLACMENET FOR ALL NEW BULLETS
;
;
BLT_FLG  EQU     0                ;  BULLET FLAG
BLT_YD   EQU     BLT_FLG + 1      ;  WORKING 'Y' DISPLACEMENT
BLT_XD   EQU     BLT_YD + 2       ;  WORKING 'X' DISPLACEMENT
BLT_WY   EQU     BLT_XD + 2       ;  WORKING 'Y' POSITION
BLT_WX   EQU     BLT_WY + 2       ;  WORKING 'X' POSITION
BLT_DC   EQU     BLT_WX + 2       ;  BULLET DOWN-COUNTER
;
BLT_LEN  EQU     BLT_DC + 1       ;  BULLET TABLE LENGTH
;
BLT_TBL  DS      BLT_LEN * BULLETS
;
;      
;        MINE TABLE
;        ----------
;
MIN_FLG  EQU     0                ;  MINE FLAG
MIN_PAK  EQU     MIN_FLG + 1      ;  PACKET TYPE (NUMBER)
MIN_SIZ  EQU     MIN_PAK + 1      ;  SIZE (ZOOM VALUE)
MIN_BSZ  EQU     MIN_SIZ + 1      ;  BASE MINE SIZE (0 - 3)
MIN_YW   EQU     MIN_BSZ + 1      ;  WORKING 'Y' POSITION
MIN_XW   EQU     MIN_YW + 2       ;  WORKING 'X' POSITION
MIN_YD   EQU     MIN_XW + 2       ;  WORKING 'Y' DISPLACEMENT
MIN_XD   EQU     MIN_YD + 2       ;  WORKING 'X' DISPLACEMENT
MIN_BOX  EQU     MIN_XD + 2       ;  COLLISION BOX PARAMETERS
MIN_SCR  EQU     MIN_BOX + 2      ;  SCORE VALUE
MIN_T1   EQU     MIN_SCR + 2      ;  MINE TEMPORARY WORKING STORAGE
MIN_T2   EQU     MIN_T1 + 1       ;  .
;
MIN_LEN  EQU     MIN_T2 + 1       ;  MINE TABLE LENGTH
;
MIN_TBL  DS      MIN_LEN * MINES  
;
;
;        EXPLOSION TABLE
;        ---------------
;
EXP_FLG  EQU     0                ;  EXPLOSION FLAG
EXP_SIZ  EQU     EXP_FLG + 1      ;  SIZE (ZOOM VALUE)
EXP_YX   EQU     EXP_SIZ + 1      ;  ABSOLUTE Y:X POSITIONS
EXP_CNT  EQU     EXP_YX + 2       ;  FRAME COUNTER
;
EXP_LEN  EQU     EXP_CNT + 1      ;  EXPLOSION TABLE LENGTH
EXPLSN   EQU     14               ;  NUMBER OF EXPLOSION ENTRIES
;
EXP_TBL  DS      EXP_LEN * EXPLSN
;
;
;        STAR FIELD TABLES
;        -----------------
;
FSTAR    DS      16
ZSTAR    DS      8
;
;
;
;==========================================================================JJH
;PACKET1 DS      30               ;  CODE DELETED - REV. C CHANGES   ======JJH
;PACKET2 DS      30               ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
PACKET1  DS      27               ;  CODE ADDED - REV. C CHANGES     ======JJH
PACKET2  DS      15               ;  .    PACKET WORKING AREA        ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
MINTBL1  DB      0                ;  MINE TABLE FOR PLAYER #1        ======JJH
         DB      0                ;  .    CODE ADDED -               ======JJH
         DB      0                ;  .        REV. C CHANGES         ======JJH
         DB      0                ;  .                               ======JJH
;                                                                    ======JJH
;                                                                    ======JJH
MINTBL2  DB      0                ;  MINE TABLE FOR PLAYER #2        ======JJH
         DB      0                ;  .                               ======JJH
         DB      0                ;  .                               ======JJH
         DB      0                ;  .                               ======JJH
;==========================================================================JJH
;
ENDRAM   DB      0                ;  END-OF-RAM FLAG
;
;
;
;  ***************************************************
;  ***************************************************
;  ***                                             ***
;  ***          R E S I D E N T   G A M E          ***
;  ***                                             ***
;  ***************************************************
;  ***************************************************
;
;
;         ORG     $E000
 code
         ORG     $0000
;        ===     =====
;
 ; ADDED
 DB       "g GCE STOR", $80 

         DW      LAYTUNE
;
         DW      $F850
         DW      $30E8
; SHORTENED so ENTRY is at same address!
         DB      'MIN',$80
         DB      0
;
;
;
;
;  POWER-UP INITIALIZATION
;  =======================
;
         direct   $D0
;        =====   ===
;
; ADDRESS 0016
ENTRY    LDX     #ETMP1           ;  CLEAR MEMORY
CLRALL   CLR     ,X+               ;  .
         CMPX    #ENDRAM          ;  .
         BNE     CLRALL           ;  .
;
         JSR     I_STARS          ;  INITIALIZE STAR FIELDS
;
;==========================================================================JJH
;        LDX     #HISCOR          ;  CODE DELETED - REV. B CHANGES   ======JJH
;        JSR     SCLR             ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
;        NOP                      ;  CODE ADDED - REV. B CHANGES     ======JJH
;        NOP                      ;  CODE DELETED - REV. C CHANGES   ======JJH
;        NOP                      ;  .                               ======JJH
;        NOP                      ;  .                               ======JJH
;        NOP                      ;  .                               ======JJH
;        NOP                      ;  .                               ======JJH
;==========================================================================JJH
;
         INC     ZSKIP            ;  SET POST-PACKET ZEROING FLAG
;
         LDA     #$BB             ;  SET-UP CONTROLLER FLAGS
         STA     SBTN             ;  .
         LDX     #$0101           ;  .
         STX     SJOY             ;  .
;
;
;  INITIALIZE MINE-SWEEPER
;  =======================
;
;
NEWGAME  LDX     #ETMP1           ;  CLEAR MEMORY
CLRMEM   CLR     ,X+               ;  .
         CMPX    #FSTAR - 1       ;  .
         BNE     CLRMEM           ;  .
         BRA     GAME1            ;  .
;
GAME1    JSR     DPRAM            ;  SET "DP" REGISTER FOR RAM
         direct   $C8              ;  .
;
         LDD     #$0200           ;  SELECT OPTIONS
         JSR     SELOPT           ;  .
         DEC     <PLAYRS          ;  .
;
         CLR     <TSTAT           ;  CLEAR TUNE FLAG
         CLR     <ACTPLY          ;  CLEAR ACTIVE PLAYER FLAG
;
         LDX     #SCOR1           ;  CLEAR PLAYERS SCORE
         JSR     SCLR             ;  .
         LDX     #SCOR2           ;  .
         JSR     SCLR             ;  .
;
         LDX     #MNLVL1          ;  CLEAR ACTIVE MINE-FIELD COUNTER
         JSR     SCLR             ;  .    FOR PLAYER #1
         LDD     #$0001           ;  .    .
         JSR     SCRADD           ;  .    .
;
         LDX     #MNLVL2          ;  .    FOR PLAYER #2
         JSR     SCLR             ;  .    .
         LDD     #$0001           ;  .    .
         JSR     SCRADD           ;  .    .
;
;==========================================================================JJH
;        LDX     #MINTBL1         ;  CODE DELETED - REV. C CHANGES   ======JJH
;        STX     <TBLPTR1         ;  .                               ======JJH
;        STX     <TBLPTR2         ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         LDX     #MINTBL1         ;  CODE ADDED - REV. C CHANGES     ======JJH
         STX     <TBLPTR1         ;  .    SET-UP NEW MINE TABLES     ======JJH
         LDX     #MINTBL2         ;  .    .                          ======JJH
         STX     <TBLPTR2         ;  .    .                          ======JJH
         LDB     #$08             ;  .    CLEAR NEW MINE TABLES      ======JJH
         LDX     #MINTBL1         ;  .    .                          ======JJH
         JSR     BCLR             ;  .    .                          ======JJH
;==========================================================================JJH
;
         LDA     #5               ;  SET SHIP COUNT
         STA     <SHIPCNT         ;  .
         STA     <SHIPCNT0        ;  .
         STA     <SHIPCNT1        ;  .
;
         BRA     LVLN1            ;  LEVEL #1 ENTRY POINT IS DIFFERENT
;   
;
;  GAME LEVEL SEQUENCER
;  ====================
;
;
LEVELN   JSR     FALL             ;  FALL-THRU TO NEXT GAME LEVEL
;
         LDY     #TBLPTR1         ;  BUMP GAME DATA POINTER FOR ACTIVE PLAYER
         LDA     <ACTPLY          ;  .
         LDX     A,Y              ;  .
;
;==========================================================================JJH
;        LEAX    4,X              ;  CODE DELETED - REV. C CHANGES   ======JJH
;        STX     A,Y              ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         JSR     REVC_0           ;  CODE ADDED - REV. C CHANGES     ======JJH
;==========================================================================JJH
;
         LDX     #PMNLVL          ;  BUMP ACTIVE MINE-FIELD COUNTER
         LDA     <ACTPLY          ;  .    WHICH PLAYER IS ACTIVE ?
         LDX     A,X              ;  .    .
;
         LDA     5,X              ;  .    BONUS SHIP ?
         ANDA    #$03             ;  .    .
         BNE     LVLN01           ;  .    .
         INC     SHIPCNT          ;  .    .    BUMP SHIP COUNT FOR ACTIVE PLAYER
;
LVLN01   LDD     #$0001           ;  .    BUMP GAME LEVEL
         JSR     SCRADD           ;  .    .
;
LVLN1    JSR     SWPINT           ;  ENTRY FOR LEVEL RE-START
;
         LDX     #TBLPTR1         ;  .    SET-UP FOR NEXT GAME LEVEL
         LDA     <ACTPLY          ;  .    .    WHICH PLAYER IS ACTIVE
         LDX     A,X              ;  .    .    .
;
;==========================================================================JJH
;        LDA     0,X              ;  CODE DELETED - REV. C CHANGES   ======JJH
;        BMI     LVLN2            ;  .                               ======JJH
;==========================================================================JJH
;
         JSR     MINLAY           ;  INITIALIZE FOR GAME LEVEL
         BRA     LVLN3            ;  .
;
LVLN2    LDD     <TIMEOUT         ;  LOCK-UP ON GAME SEQUENCE
         SUBD    #$0001           ;  .    TIME-OUT ON SEQUENCE ?
         STD     <TIMEOUT         ;  .    .
         BEQ     LVLN21           ;  .    .
;
         PSHS    DP               ;  .    DISPLAY BOTH PLAYERS SCORE
         JSR     DPIO             ;  .    .
         JSR     SCRBTH           ;  .    .
         LDU     #M_END           ;  .    DISPLAY 'GAME OVER' MESSAGE
         JSR     MESS             ;  .    .
         PULS    DP               ;  .    .
;
;==========================================================================JJH
;        LDA     <TRIGGR          ;  CODE DELETED - REV. B CHANGES   ======JJH
;        BEQ     LVLN3            ;  .                               ======JJH
;==========================================================================JJH
;
         LDX     #SCOR1           ;  ESCAPE FROM GAME LEVEL LOCK-UP
         LDU     #HISCOR          ;  .    IS PLAYER #1 SCORE HIGHEST ?
         JSR     HISCR            ;  .    .
;
         LDX     #SCOR2           ;  .    IS PLAYER #2 SCORE HIGHEST ?
         LDU     #HISCOR          ;  .    .
         JSR     HISCR            ;  .    .
;
;==========================================================================JJH
         LDA     <TRIGGR          ;  CODE ADDED - REV. B CHANGES     ======JJH
         BEQ     LVLN3            ;  .                               ======JJH
;==========================================================================JJH
;
LVLN21   LDD     <TIMEOUT         ;  LOCK TIME-OUT ?
         LBNE    NEWGAME          ;  .    START GAME OVER
;
;==========================================================================JJH
;        CLR     $CBFE            ;  CODE DELETED - REV. B CHANGES   ======JJH
;        JMP     $F01C            ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         JMP     REVB_0           ;  CODE ADDED - REV. B CHANGES     ======JJH
         NOP                      ;  .    FILLER                     ======JJH
         NOP                      ;  .    .                          ======JJH
         NOP                      ;  .    .                          ======JJH
;==========================================================================JJH
;
;
LVLN3    PSHS    DP               ;  SAVE "DP" REGISTER
         JSR     WAIT             ;  WAIT FOR FRAME BOUNDARY
         JSR     GMINE            ;  HANDLE MINE GAME LOGIC
         JSR     GSHIP            ;  HANDLE SWEEPER GAME LOGIC
         JSR     GBULLET          ;  HANDLE BULLET GAME LOGIC
         JSR     MSHIP            ;  HANDLE MINE-LAYER GAME LOGIC
;
         PULS    DP               ;  SET "DP" REGISTER TO RAM
         direct   $C8              ;  .
;
         JSR     CBULMIN          ;  HANDLE BULLET/MINE COLLISIONS
         JSR     CMINSHIP         ;  HANDLE SHIP/MINE COLLISIONS
         JSR     CSHPLYR          ;  HANDLE SHIP/LAYER COLLISIONS
         JSR     TAIL             ;  HANDLE TAIL-END LOGIC
         BCS     LVLN3            ;  .    MORE GAME LOGIC ?
;
         LDA     <ABORT           ;  RESTART CURRENT GAME POSITION ?
         LBEQ    LEVELN           ;  .    WAS GAME ABORTED ?
         LDA     <LOCK            ;  .    .    LOCK-UP ON GAME SEQUENCE ?
         LBNE    LVLN2            ;  .    .    .
         JMP     LVLN1            ;  .    .    RESTART GAME SEQUENCE
;
;
;  ***********************************************
;  ***********************************************
;  ***                                         ***
;  ***          S U B R O U T I N E S          ***
;  ***                                         ***
;  ***********************************************
;  ***********************************************
;
;
;
;  HANDLE MINE-LAYING SEQUENCE
;  ===========================
;
         direct   $C8
;        =====   ===
;
MINLAY   STX     <MINTABLE        ;  SET-UP FOR INITIAL MINE-LAYING
         LDD     #$7F00           ;  .    SET POSITION OF MINE-LAYER
         STD     <LAYRYX          ;  .    .
         STA     <STAR1           ;  .    SET MINE-LAYER ZOOM VALUE
;
         LDA     #$20             ;  SET MINE INSERTION TIME
         STA     <TMR1            ;  .
         LDX     #INSINT          ;  .
         STX     <TMR1+1          ;  .
         LDX     #MIN_TBL         ;  .    SET-UP FOR MINE INSERTION
         STX     <STAR3           ;  .    .    NEXT MINE TABLE ENTRY
         LDA     #MINES + 1       ;  .    .    TOTAL MINES TO INSERT
         STA     <STAR2           ;  .    .    .
;
         CLR     <TSTAT           ;  SET-UP FOR MINE-LAYING TUNE
         LDU     #LAYTUNE         ;  .
         JSR     SPLAY            ;  .
;
;
MNLY1    PSHS    DP               ;  DEPOSIT INITIAL MINES
         JSR     STAIL            ;  .    DRAW EXPLOSIONS AND SHIP COUNTER
         JSR     REPLAY           ;  .    SET-UP FOR TUNE
;
         LDA     <FRAME           ;  .    CHANGE ZOOM VALUE ?
         BITA    #$01             ;  .    .
         BNE     MNLY2            ;  .    .
         DEC     <STAR1           ;  .    .    INCREMENT LAYER ZOOM VALUE
;
MNLY2    JSR     WAIT             ;  .    WAIT FOR FRAME BOUNDARY
         direct   $D0              ;  .    .
         JSR     SCRBTH           ;  .    DISPLAY BOTH PLAYER'S SCORES
         JSR     REQOUT           ;  .    PLAY LAYING TUNE
         JSR     GMINE            ;  .    HANDLE MINE GAME LOGIC
;
         JSR     INT3Q            ;  .    DISPLAY MINE-LAYER
         LDB     STAR1            ;  .    .    SKIP IF ZOOM VALUE IS ZERO
         BEQ     MNLY3            ;  .    .    .
         LDX     #LLAYR           ;  .    .    DRAW LEFT PACKET
         LDY     LAYRYX           ;  .    .    .
         JSR     APACK            ;  .    .    .
         LDX     #RLAYR           ;  .    .    DRAW RIGHT PACKET
         JSR     APACK            ;  .    .    .
         LDX     #MLAYR           ;  .    .    DRAW MIDDLE PACKET
         JSR     APACK            ;  .    .    .
;
         PULS    DP               ;  .    .
         direct   $C8              ;  .    .
         DEC     <LAYRYX          ;  .    .
         BRA     MNLY1            ;  .    .
;
;
MNLY3    PULS    DP               ;  GROW FOUR LARGE MINES
         direct   $C8              ;  .    .
;
         CLR     <TMR1            ;  .
         LDA     #$04             ;  .    SET MINE COUNT
         STA     <STAR1           ;  .    .
         LDA     #$7F             ;  .    SET GROWING DELAY TIME
         STA     <STAR2           ;  .    .
;
MNLY4    LDA     <STAR1           ;  .    START SEQUENTIAL MINE GROWTH
         BEQ     MNLY7            ;  .    .
;
         LDB     <STAR2           ;  .    .    GROWING DELAY TIME ?
         BEQ     MNLY5            ;  .    .    .
         DEC     <STAR2           ;  .    .    .    DECREMENT DELAY TIMER
         BRA     MNLY6            ;  .    .    .    SKIP MINE GROWTH
;
MNLY5    LDB     <FRAME           ;  .    .    ADJUST GROWTH-TO-GROWTH TIME
         ANDB    #$1F             ;  .    .    .
         BNE     MNLY6            ;  .    .    .
;
         DECA                     ;  .    GROW ONE LARGE MINE
         STA     <STAR1           ;  .    .    DECREMENT MINE COUNTER
;
         LDX     <MINTABLE        ;  .    .    SET SEED ENTRY FOR GROWTH
         LDA     A,X              ;  .    .    .    SET MINE TYPE
         LDB     #$03             ;  .    .    .    SET MINE SIZE (LARGE)
         JSR     RANSEED          ;  .    .    .    FIND AND SET ENTRY
;
MNLY6    PSHS    DP               ;  .    WAIT FOR FRAME BOUNDARY
         JSR     WAIT             ;  .    .
         direct   $D0              ;  .    .
;
         JSR     INTMAX           ;  .    DISPLAY ACTIVE MINE-FIELD MESSAGE
         LDU     #M_MNFLD         ;  .    .    DRAW MINE-FIELD MESSAGE
         JSR     MESS             ;  .    .    .
         LDY     #$E000           ;  .    .    DRAW MINE-FIELD COUNTER
         LDU     #PMNLVL          ;  .    .    .    FIND MESSAGE FOR ACTIVE PLAYER
         LDA     ACTPLY           ;  .    .    .    .
         LDU     A,U              ;  .    .    .    .
         JSR     AMESS            ;  .    .    .
;
         JSR     GMINE            ;  .    HANDLE MINE GAME LOGIC
         JSR     GSHIP            ;  .    HANDLE SWEEPER GAME LOGIC
         JSR     GBULLET          ;  .    HANDLE BULLET GAME LOGIC
;
         PULS    DP               ;  .    SET "DP" REGISTER TO RAM
         direct   $C8              ;  .    .
;
         JSR     CBULMIN          ;  .    HANDLE BULLET/MINE COLLISIONS
         JSR     TAIL             ;  .    HANDLE TAIL-END LOGIC
         BRA     MNLY4            ;  .    .
;
MNLY7    RTS                      ;  RETURN TO CALLER
;
;
;  INITIAL MINE INSERTION
;  ======================
;
;
INSINT   direct   $C8              ;  TIMER "DP" SET TO RAM
;
         DEC     <STAR2           ;  END-OF-MINE INSERTION ?
         BEQ     INSINT9          ;  .
;
         INC     <MINMAX          ;  BUMP MINE-SEED COUNTER
;
         JSR     RANDOM           ;  RESET INSERTION TIME
         ANDA    #$07             ;  .
         ADDA    #$04             ;  .
         STA     <TMR1            ;  .
;
         LDU     <STAR3           ;  INSERT INITIAL MINE BEHAVIOR PARAMETERS
;
         LDA     #$80             ;  .    SET MINE TO INITIAL LOCATION
         STA     MIN_FLG,U        ;  .    .
;
         LDD     <LAYRYX          ;  .    SET SEED RESTING LOCATION
         ADDA    #$08             ;  .    .    FUDGE MINE UP FOR LAYER OPENING
         STA     MIN_YW,U         ;  .    .    SET WORKING VALUES
         CLR     MIN_YW+1,U       ;  .    .    .
         STB     MIN_XW,U         ;  .    .    .
         CLR     MIN_XW+1,U       ;  .    .    .
;
INSINT0  JSR     RANDOM           ;  .    SET SEED DESTINATION LOCATION
         TSTA                     ;  .    .    SET MINIMUM DISTANCE FROM CENTRE
         BMI     INSINT3          ;  .    .    .
;
INSINT1  CMPA    #$10             ;  .    .    .    'X' IS POSITIVE
         BGE     INSINT2          ;  .    .    .    .    BELOW 'X' WINDOW ?
         ADDA    #$0C             ;  .    .    .    .    .    FUDGE IT UP
INSINT2  CMPA    #$60             ;  .    .    .    .    ABOVE 'X' WINDOW ?
         BLE     INSINT5          ;  .    .    .    .    .    FUDGE IT DOWN
         BRA     INSINT0          ;  .    .    .    .    .    .
;
INSINT3  CMPA    #$F0             ;  .    .    .    'X' IS NEGATIVE
         BLE     INSINT4          ;  .    .    .    .    ABOVE 'X' WINDOW ?
         SUBA    #$0C             ;  .    .    .    .    .    FUDGE IT DOWN
INSINT4  CMPA    #$A0             ;  .    .    .    .    BELOW 'X' WINDOW ?
         BGE     INSINT5          ;  .    .    .    .    .    FUDGE IT UP
         BRA     INSINT0          ;  .    .    .    .    .    .
;
INSINT5  STA     MIN_T2,U         ;  .    .    .    .
;
         TFR     A,B              ;  .    SET DISPLACEMENT VALUE ($01 OR $FF)
         SEX                      ;  .    .
         ORA     #$01             ;  .    .
         STA     MIN_T1,U         ;  .    .
;
         CLR     MIN_SIZ,U        ;  .    SET INITIAL ZOOM VALUE
;
         LEAY    MIN_LEN,U        ;  .    BUMP TO NEXT ENTRY
         STY     <STAR3           ;  .    .
;
INSINT9  RTS                      ;  RETURN TO CALLER
;
;
MINSZ    DB      0                ;  MINE SIZE TABLE
         DB      MIN_SIZ3         ;  .    SMALL
         DB      MIN_SIZ2         ;  .    MEDIUM
         DB      MIN_SIZ1         ;  .    LARGE
;
MINSPD   DB      0                ;  MINE SPEED TABLE
         DB      MIN_SPD3         ;  .    SMALL
         DB      MIN_SPD2         ;  .    MEDIUM
         DB      MIN_SPD1         ;  .    LARGE
;
MINSCR   DW      $0100            ;  MINE SCORE TABLE
         DW      $0500            ;  .
         DW      $0325            ;  .
         DW      $0750            ;  .
;
MINSSCR  DW      0                ;  MINE SCORE VS_ SPEED TABLE
         DW      $0100            ;  .    SMALL
         DW      $0035            ;  .    MEDIUM
         DW      $0000            ;  .    LARGE
;
MINBOX   DW      0                ;  MINE COLLISION BOX PARAMETERS
         DW      MIN_BOX3         ;  .
         DW      MIN_BOX2         ;  .
         DW      MIN_BOX1         ;  .
;
MINOBJ   DW      MINE1            ;  MINE PACKET TABLE
         DW      MINE2            ;  .
         DW      MINE3            ;  .
         DW      MINE4            ;  .
;
;
;  STAR-SWEEPER GAME LOGIC
;  =======================
;
;
GSHIP    PSHS    DP               ;  SAVE ENTRY "DP"
         LDA     #$C8             ;  SET "DP" REGISTER TO RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         LDA     <ABORT           ;  GAME ABORTED ?
         LBNE    SHPON2           ;  .    SKIP STAR-SWEEPER LOGIC
;
         LDA     <HYPFLAG         ;  STATUS OF HYPER-SPACE SEQUENCE ?
         LBNE    HYPER1           ;  .    HYPER-SPACE SEQUENCE GOING ALREADY
         LDA     <S_HYPER         ;  .    HYPER-SPACE BUTTON PRESSED ?
         LBNE    HYPER            ;  .    .
;
GSHP1    LDA     <S_THRST         ;  THRUSTING ?
         BEQ     GSHP5            ;  .
;
         LDA     <SHIPROT         ;  .    THRUSTING ALONG EXISTING AXIS ?
         CMPA    <SHIPDIR1        ;  .    .    ALONG FIRST AXIS ?
         BEQ     GSHP3            ;  .    .    .
         CMPA    <SHIPDIR2        ;  .    .    ALONG SECOND AXIS ?
         BEQ     GSHP2            ;  .    .    .
;
         LDA     <SHIPSPD1        ;  .    WHICH AXIS IS FREE ?
         BEQ     GSHP3            ;  .    .    FIRST AXIS ?
         LDA     <SHIPSPD2        ;  .    .    SECOND AXIS ?
         BNE     GSHP5            ;  .    .    .
;
GSHP2    LDA     <SHIPSPD2        ;  .    ACCELERATE SPEED ALONG AXIS #2
         ADDA    #$0C             ;  .    .
         CMPA    #$7F             ;  .    .    MAXIMUM SPEED ?
         BHI     GSHP5            ;  .    .    .
         STA     <SHIPSPD2        ;  .    .    SAVE NEW SPEED
         LDA     <SHIPROT         ;  .    .    SET DIRECTION OF AXIS
         STA     <SHIPDIR2        ;  .    .    .
         BRA     GSHP4            ;  .    .    SET THRUSTER SOUND
;
;
GSHP3    LDA     <SHIPSPD1        ;  .    ACCELERATE SPEED ALONG AXIS #1
         ADDA    #$0C             ;  .    .
         CMPA    #$7F             ;  .    .    MAXIMUM SPEED ?
         BHI     GSHP5            ;  .    .    .
         STA     <SHIPSPD1        ;  .    .    SAVE NEW SPEED
         LDA     <SHIPROT         ;  .    .    SET DIRECTION OF AXIS
         STA     <SHIPDIR1        ;  .    .    .
;
GSHP4    INC     THRSND           ;  .    .    SET THRUSTER SOUND
;
GSHP5    LDA     <SHIPSPD1        ;  DECELERATE SPEED ALONG FIRST AXIS
         BEQ     GSHP6            ;  .
         SUBA    #$02             ;  .
         STA     <SHIPSPD1        ;  .
;
         LDB     <SHIPDIR1        ;  .    CALCULATE SHIP DISPLACEMENTS
         JSR     MLTY8            ;  .    .    FORM DISPLACEMENTS
         STY     <DSHIPY1         ;  .    .    .    SAVE 'Y' DISPLACEMENT
         STX     <DSHIPX1         ;  .    .    .    SAVE 'X' DISPLACEMENT
;
GSHP6    LDA     <SHIPSPD2        ;  DECELERATE SPEED ALONG SECOND AXIS
         BEQ     GSHP7            ;  .
         SUBA    #$02             ;  .
         STA     <SHIPSPD2        ;  .
;
         LDB     <SHIPDIR2        ;  .    CALCULATE SHIP DISPLACEMENTS
         JSR     MLTY8            ;  .    .    FORM DISPLACEMENTS
         STY     <DSHIPY2         ;  .    .    .    SAVE 'Y' DISPLACEMENT
         STX     <DSHIPX2         ;  .    .    .    SAVE 'X' DISPLACEMENT
;
GSHP7    LDD     <WSHIPY          ;  MOVE SHIP 'Y' AXIS
         ADDD    <DSHIPY1         ;  .
         ADDD    <DSHIPY2         ;  .
         STD     <WSHIPY          ;  .
;
         LDD     <WSHIPX          ;  MOVE SHIP 'X' AXIS
         ADDD    <DSHIPX1         ;  .
         ADDD    <DSHIPX2         ;  .
         STD     <WSHIPX          ;  .
;
GSHP8    LDA     <POT0            ;  ROTATE STAR-SWEEPER ?
         BEQ     SHPON1           ;  .    NO ROTATION ?
         BMI     GSHP9            ;  .    ROTATE LEFT ?
;
         DEC     <SHIPROT         ;  .    ROTATE RIGHT
         BRA     SHPON0           ;  .    .
;
GSHP9    INC     <SHIPROT         ;  .    ROTATE LEFT
         BRA     SHPON0           ;  .    .
;
;
SHPONLY  PSHS    DP               ;  SHIP-ONLY ENTRY POINT
;
SHPON0   JSR     SWPROT           ;  ROTATE STAR-SWEEPER
;
SHPON1   LDA     #$D0             ;  SET "DP" REGISTER TO I/O
         TFR     A,DP             ;  .
         direct   $D0              ;  .
;
         JSR     INT3Q            ;  DISPLAY MINE-SWEEPER
         LDB     #P_SHPSZ         ;  .    SET SIZE
         LDY     #WSHIPY          ;  .    SET POSITION
         LDX     #PACKET1         ;  .    SET SHIP PACKET ADDRESS
         JSR     DPACK            ;  .    DRAW PACKET
;
SHPON2   PULS    DP,PC            ;  RETURN TO CALLER
;
;
;  HYPER-SPACE SEQUENCE
;  ====================
;
         direct   $C8
;        =====   ===
;
HYPER    LDA     #$80             ;  START HYPER-SPACE SEQUENCE
         STA     <HYPFLAG         ;  .    SET FLAG FOR RNG MIXING
         JSR     RANDOM           ;  .    SET COUNTER
         ANDA    #$03             ;  .    .
         ADDA    #$03             ;  .    .
         STA     <HYPCNT          ;  .    .
         INC     HYPSND           ;  .    SET HYPER-SPACE SOUND FLAG
;
HYPER1   LDA     <HYPFLAG         ;  SELECT HYPER-SPACE SEQUENCE
         BPL     HYPER30          ;  .    WAITING FOR NEW LOCATION ?
;
HYPER20  DEC     <HYPCNT          ;  WAIT FOR SHIP RE-APPERANCE
         BEQ     HYPER21          ;  .    SEQUENCE DONE ?
;
         JSR     RANPOS           ;  .    STIR-UP RANDOM NUMBER GENERATOR
         STA     <WSHIPY          ;  .    .
         CLR     <WSHIPY + 1      ;  .    .
         STB     <WSHIPX          ;  .    .
         CLR     <WSHIPX + 1      ;  .    .
         PULS    DP,PC            ;  .    .
;
HYPER21  LSR     <HYPFLAG         ;  .    SET FLAG FOR NEXT SEQUENCE
         LDA     #$1F             ;  .    .
         STA     <HYPCNT          ;  .    .
         PULS    DP,PC            ;  .    .
;
;
HYPER30  LDB     <HYPCNT          ;  SHIP RE-APPERANCE
         CMPB    #$E0             ;  .
         BLE     HYPER31          ;  .
         LDA     <HYPCNT          ;  .
         SUBA    #$04             ;  .
         STA     <HYPCNT          ;  .
;
         CLRA                     ;  .    DRAW STAR FIELD
         JSR     H_STARS          ;  .    .
         PULS    DP,PC            ;  .    .
;
HYPER31  CLR     <HYPCNT          ;  HYPER-SPACE SEQUENCE DONE
         CLR     <HYPFLAG         ;  .
         JSR     HSWPRST          ;  .    INITIALIZE SWEEPER PARAMETERS
;
         PULS    DP,PC            ;  RETURN TO CALLER

;
;
;  MINE-LAYER GAME LOGIC
;  =======================
;
         direct   $D0
;        =====   ===
;
MSHIP    LDA     LAYRSPD          ;  IS THE MINE-LAYER ON-SCREEN ?
         BEQ     MSHIP1           ;  .
;
         PSHS    DP               ;  SAVE ENTRY "DP"
         LDA     #$C8             ;  SET "DP" REGISTER TO RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
;==========================================================================JJH
;        LDA     <LAYRSPD         ;  CODE DELETED - REV. C CHANGES   ======JJH
;        BEQ     MSHIP1           ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         NOP                      ;  CODE ADDED - REV. C CHANGES     ======JJH
         NOP                      ;  .                               ======JJH
         NOP                      ;  .                               ======JJH
         NOP                      ;  .                               ======JJH
;==========================================================================JJH
;
         LDD     <WLAYRY          ;  MOVE SHIP 'Y' AXIS
         ADDD    <DLAYRY          ;  .
         STD     <WLAYRY          ;  .
         STA     <LAYRYX          ;  .
;
         LDD     <WLAYRX          ;  MOVE SHIP 'X' AXIS
         ADDD    <DLAYRX          ;  .
         STD     <WLAYRX          ;  .
         STA     <LAYRYX+1        ;  .
;
         PULS    DP               ;  SET "DP" REGISTER TO I/O
         direct   $D0              ;  .
;
         JSR     INT3Q            ;  DISPLAY MINI MINE-LAYER
         LDB     #P_LYRSZ         ;  .    SET SIZE
         LDY     LAYRYX           ;  .    SET POSITION
         LDX     #LAYER           ;  .    SET PACKET ADDRESS
         JSR     APACK            ;  .    DRAW PACKET
;
MSHIP1   RTS                      ;  RETURN TO CALLER
;
;
;  MINE-LAYER PARAMETER MODIFICATIONS
;  ==================================
;
;        FIRST MINE-LAYER MOTION MODIFICATION
;        ------------------------------------
;
BEGLAYR  direct   $C8              ;  TIMER "DP" SET TO RAM
;
         LDX     #INSLAYR         ;  SET-UP FOR GENERAL MINE-LAYER MOTION
         STX     <TMR3 + 1        ;  .
;
         JSR     RANDOM           ;  SELECT PRE-PROGRAMMED MINE-LAYING SEQUENCE
         LDX     #RSTABL          ;  .
         ANDA    #$06             ;  .
         LDX     A,X              ;  .
;
         LDD     ,X++              ;  SET INITIAL MINE-LAYER LOCATION
         STD     <LAYRYX          ;  .
         STA     <WLAYRY          ;  .    WORKING 'Y' LOCATION
         CLR     <WLAYRY + 1      ;  .    .
         STB     <WLAYRX          ;  .    WORKING 'X' LOCATION
         CLR     <WLAYRX + 1      ;  .    .
;
         BRA     INSLYR6          ;  FETCH MOTION MODIFICATIONS
;
;
;        GENERAL MINE-LAYER MOTION MODIFICATIONS
;        ---------------------------------------
;
;
INSLAYR  direct   $C8              ;  TIMER "DP" SET TO RAM
;
         LDA     <RSMINES         ;  USE RANDOM MOTION OR PROGRAMMED SEQUENCE ?
         BNE     INSLYR2          ;  .
;
;
INSLYR1  JSR     RANDOM           ;  RANDOM MOTION
         ANDA    #$7F             ;  .    SET PARAMETER CHANGE TIME
         ADDA    #$30             ;  .    .
         STA     <TMR3            ;  .    .
;
         JSR     RANDOM           ;  .    SET MINE-LAYER DIRECTION
         ANDA    #$3F             ;  .    .
         STA     <LAYRDIR         ;  .    .
;
         JSR     RANDOM           ;  .    SET MINE-LAYER SPEED
         ADDA    #$10             ;  .    .
         STA     <LAYRSPD         ;  .    .
         BRA     INSLYR7          ;  .    .
;
;
INSLYR2  LDA     <ABORT           ;  PRE-PROGRAMMED MINE-LAYING SEQUENCE
         BNE     INSLYR1          ;  .    GAME ABORTED ?
;
;        LDA     <CMINES          ;  .    ALL ACTIVE MINES DESTROYED ?
;        BEQ     INSLYR1          ;  .    .
;
         LDB     #MINES           ;  .    FIND HOLE FOR NEW MINE
         LDU     #MIN_TBL         ;  .    .
;
INSLYR3  LDA     0,U              ;  .    .
         BEQ     INSLYR4          ;  .    .
;
         LEAU    MIN_LEN,U        ;  .    .
         DECB                     ;  .    .    END-OF-TABLE ?
         BNE     INSLYR3          ;  .    .    .
         BRA     INSLYR7          ;  .    .    .    WHAT THE HEY ?
;
;
INSLYR4  INC     <MINMAX          ;  .    INSERT NEW MINE
         DEC     <RSMINES         ;  .    .    DECREMENT RE-SEED MINE COUNT
;
         LDX     <WLAYRY          ;  .    .    SET MINE TO LAYER POSITION
         STX     MIN_YW,U         ;  .    .    .    WORKING DISPLACMENETS
         LDX     <WLAYRX          ;  .    .    .    .
         STX     MIN_XW,U         ;  .    .    .    .
;
         LDA     #$40             ;  .    .    SET MINE-SEED TO IDLE
         STA     MIN_FLG,U        ;  .    .    .
;
         LDA     <RESEED          ;  .    .    MINE RE-SEEDING ALREADY STARTED ?
         BNE     INSLYR5          ;  .    .    .
;
         LDX     #RSGROW          ;  .    .    SET-UP DELAYED MINE GROWTH
         STX     <TMR1 + 1        ;  .    .    .
         JSR     RANDOM           ;  .    .    .    SET DELAY TIME
         ANDA    #$7F             ;  .    .    .    .
         ADDA    #$40             ;  .    .    .    .
         STA     <TMR1            ;  .    .    .    .
;
         INC     <RESEED          ;  .    .    SET RE-SEEDING FLAG
;
INSLYR5  LDX     <LAYRPTR         ;  .    FETCH PRE-PROGRAMMED VALUES
INSLYR6  LDA     ,X+               ;  .    .    SET NEXT PARAMETER CHANGE TIME
         STA     <TMR3            ;  .    .    .
;
         LDA     ,X+               ;  .    .    SET MINE-LAYER DIRECTION
         STA     <LAYRDIR         ;  .    .    .
;
         LDA     ,X+               ;  .    .    SET MINE-LAYER SPEED
         STA     <LAYRSPD         ;  .    .    .
         STX     <LAYRPTR         ;  .    .    .    SAVE UPDATED SEQUENCE POINTER
;
;
INSLYR7  LDB     <LAYRDIR         ;  CALCULATE SHIP DISPLACEMENTS FOR SPEED
         JSR     MLTY8            ;  .    FORM DISPLACEMENTS
         STY     <DLAYRY          ;  .    .    SAVE 'Y' DISPLACEMENT
         STX     <DLAYRX          ;  .    .    SAVE 'X' DISPLACEMENT
;
         RTS                      ;  .    RETURN TO CALLER
;
;
;        RE-SEEDED MINE GROWTH HANDLER
;        -----------------------------
;
;
RSGROW   direct   $C8              ;  TIMER "DP" SET TO RAM
;
         LDU     #TBLPTR1         ;  GROW FEATURED MINE
         LDA     <ACTPLY          ;  .    SELECT POINTER FOR ACTIVE PLAYER
         LDU     A,U              ;  .    .
         LDA     0,U              ;  .    SET MINE TYPE
         LDB     #3               ;  .    SET MINE SIZE
         JSR     RANSEED          ;  .    FIND AND SET ENTRY
;
         LDX     #FRCGROW         ;  SET-UP FOR FORCED MINE GROWTH
         STX     <TMR1 + 1        ;  .
;
         RTS                      ;  .    RETURN TO CALLER
;
;
;        FORCED MINE GROWTH HANDLER
;        --------------------------
;
;
FRCGROW  direct   $C8              ;  TIMER "DP" SET TO RAM
;
         DEC     <FRCTIME         ;  DOWN-COUNT FORCE TIMER
         BEQ     FRC1             ;  .
         LDA     #$FF             ;  .    RESET TIMER #1
         STA     <TMR1            ;  .    .
         BRA     FRC9             ;  .    SKIP FORCED MINE GROWTH
;
FRC1     JSR     RANDOM           ;  FETCH RANDOM NUMBER FOR MINE SIZE
         TFR     A,B              ;  .    NUMBER MUST BE BETWEEN 1 - 3
         ANDB    #$03             ;  .    .
         BNE     FRC2             ;  .    .    BUMP IF ZERO
         ADDB    #$01             ;  .    .    .
;
FRC2     LDU     #TBLPTR1         ;  GROW FEATURED MINE
         LDA     <ACTPLY          ;  .    SELECT POINTER FOR ACTIVE PLAYER
         LDU     A,U              ;  .    .
         LDA     0,U              ;  .    SET MINE TYPE
         JSR     RANSEED          ;  .    FIND AND SET ENTRY
;
FRC9     RTS                      ;  .    RETURN TO CALLER
;
;
;        MINE-LAYER RE-SEEDING SEQUENCES
;        -------------------------------
;
;
RSTABL   DW      RESEED1          ;  RE-SEEDING SEQUENCE LOOK-UP TABLE
         DW      RESEED2          ;  .
         DW      RESEED3          ;  .
         DW      RESEED4          ;  .
;
;
RESEED1  DW      $7F00            ;  RE-SEED SEQUENCE #1
         DB      $28              ;  .    DELAY TO NEXT CHANGE
         DB      $20              ;  .    DIRECTION OF CURRENT MOTION
         DB      $30              ;  .    SPEED OF CURRENT MOTION
         DB      $40,$28,$30      ;  .
         DB      $28,$00,$10      ;  .
         DB      $30,$10,$40      ;  .
         DB      $18,$20,$50      ;  .
         DB      $40,$30,$28      ;  .
         DB      $30,$08,$60      ;  .
         DB      $7F,$38,$70      ;  .
;
;
RESEED2  DW      $8000            ;  RE-SEED SEQUENCE #2
         DB      $40              ;  .    DELAY TO NEXT CHANGE
         DB      $00              ;  .    DIRECTION OF CURRENT MOTION
         DB      $30              ;  .    SPEED OF CURRENT MOTION
         DB      $20,$10,$50      ;  .
         DB      $20,$28,$40      ;  .
         DB      $30,$3E,$70      ;  .
         DB      $18,$30,$60      ;  .
         DB      $20,$18,$40      ;  .
         DB      $30,$24,$50      ;  .
         DB      $7F,$06,$70      ;  .
;
;
RESEED3  DW      $007F            ;  RE-SEED SEQUENCE #3
         DB      $40              ;  .    DELAY TO NEXT CHANGE
         DB      $10              ;  .    DIRECTION OF CURRENT MOTION
         DB      $60              ;  .    SPEED OF CURRENT MOTION
         DB      $28,$38,$30      ;  .
         DB      $28,$08,$40      ;  .
         DB      $30,$28,$7F      ;  .
         DB      $20,$18,$30      ;  .
         DB      $30,$08,$68      ;  .
         DB      $40,$20,$50      ;  .
         DB      $7F,$38,$70      ;  .
;
;
RESEED4  DW      $0080            ;  RE-SEED SEQUENCE #4
         DB      $40              ;  .    DELAY TO NEXT CHANGE
         DB      $30              ;  .    DIRECTION OF CURRENT MOTION
         DB      $60              ;  .    SPEED OF CURRENT MOTION
         DB      $38,$18,$30      ;  .
         DB      $30,$20,$18      ;  .
         DB      $20,$38,$40      ;  .
         DB      $28,$10,$60      ;  .
         DB      $20,$00,$30      ;  .
         DB      $40,$38,$50      ;  .
         DB      $7F,$1C,$70      ;  .
;
;
;  BULLET GAME LOGIC
;  =================
;
         direct   $D0
;        =====   ===
;
GBULLET  LDA     #BULLETS         ;  DISPLAY 'BULLETS' TABLE
         LDU     #BLT_TBL         ;  .
         LDX     #S_FIRE          ;  .
;
SBULLET  STA     TEMP1            ;  .
         JSR     INTMAX           ;  .
;
GBLT1    LDA     BLT_FLG,U        ;  .    BULLET ACTIVE ?
         BEQ     GBLT4            ;  .    .
;
         DEC     BLT_DC,U         ;  .    DECREMENT BULLET DOWN-COUNTER
         BEQ     GBLT3            ;  .    .
;
         LDD     BLT_WY,U         ;  .    CALCULATE NEW BULLET POSITION
         ADDD    BLT_YD,U         ;  .    .    'Y' POSITION
         STD     BLT_WY,U         ;  .    .    .
;
         LDD     BLT_WX,U         ;  .    .    'X' POSITION
         ADDD    BLT_XD,U         ;  .    .    .
         STD     BLT_WX,U         ;  .    .    .
;
         LEAY    BLT_WY,U         ;  .    DISPLAY BULLET FOR THIS ENTRY
         JSR     DDOT             ;  .    .    POSITION BULLET
;
GBLT2    LEAU    BLT_LEN,U        ;  .    BUMP TO NEXT ENTRY
         DEC     TEMP1            ;  .    .    END-OF-BULLET TABLE ?
         BNE     GBLT1            ;  .    .    .
         RTS                      ;  .    .    RETURN TO CALLER
;
GBLT3    CLR     BLT_FLG,U        ;  .    THIS ENTRY HAS MOVED OFF-SCREEN
         DEC     CBULLET          ;  .    .    DECREMENT ACTIVE BULLET COUNTER
;
GBLT4    LDA     ABORT            ;  .    ZERO ENTRY FOUND, GAME ABORTED ?
         BNE     GBLT2            ;  .    .
;
         LDA     HYPFLAG          ;  .    .    HYPER-SPACE SEQUENCE ACTIVE ?
         BNE     GBLT2            ;  .    .    .
;
         LDA     0,X              ;  .    INSERT NEW BULLET ?
         BEQ     GBLT2            ;  .    .    IS FIRE BUTTON DEPRESSED ?
;
         CLR     0,X              ;  .    .    CLEAR 'FIRE' FLAG
         INC     BLTSND           ;  .    .    SET BULLET SOUND FLAG
;
         INC     BLT_FLG,U        ;  .    .    SET BULLET 'ON'
         LDD     WSHIPY           ;  .    .    SET SHIP WORKING POSITION
         STD     BLT_WY,U         ;  .    .    .    'Y' AXIS
         LDD     WSHIPX           ;  .    .    .    'X' AXIS
         STD     BLT_WX,U         ;  .    .    .    .
         LDD     DBLTY            ;  .    .    SET BULLET DISPLACEMENT VALUES
         STD     BLT_YD,U         ;  .    .    .    'Y' AXIS
         LDD     DBLTX            ;  .    .    .    'X' AXIS
         STD     BLT_XD,U         ;  .    .    .    .
         LDA     #$18             ;  .    .    SET DOWN-COUNTERS
         STA     BLT_DC,U         ;  .    .    .
         INC     CBULLET          ;  .    .    BUMP ACTIVE BULLET COUNTER
         BRA     GBLT2            ;  .    .
;
;
;  MINE GAME LOGIC
;  ===============
;
         direct   $D0
;        =====   ===
;
GMINE    LDA     #MINES           ;  SET-UP TO DISPLAY MINE TABLE
         STA     TEMP1            ;  .
         LDU     #MIN_TBL         ;  .
;
GMIN1    LDA     MIN_FLG,U        ;  FETCH MINE FLAG
         BNE     GMIN3            ;  .    SKIP THIS ENTRY ?
;
GMIN2    LEAU    MIN_LEN,U        ;  .    .    BUMP TO NEXT ENTRY
         DEC     TEMP1            ;  .    .    .    END-OF-OBJECT TABLE ?
         BNE     GMIN1            ;  .    .    .    .
         RTS                      ;  .    .    .    RETURN TO CALLER
;
GMIN3    LBMI    MINIT            ;  .    MINE MOVING TO INITIAL POSITION ?
         BITA    #$40             ;  .    IDLE MINE ?
         LBNE    MIDLE            ;  .    .
         BITA    #$20             ;  .    MINE ZOOMING UP FROM SEED ?
         LBNE    MZOOM            ;  .    .
         BITA    #$10             ;  .    IDLE MINE ?
         LBNE    MWAIT            ;  .    .
         BITA    #$01             ;  .    MINE COLLISION DETECTED ?
         LBNE    MBOOM            ;  .    .
;        
MMOVE    LDA     MIN_PAK,U        ;  MINE IN MOTION
;
         CMPA    #FIRBALL         ;  .    'RELEASED' FIRE-BALL ?
         BEQ     MFBALL           ;  .    .
;
         BITA    #$01             ;  .    'DUMB' MINE MOTION ?
         BEQ     MOVDUMB          ;  .    .
;
;
MOVMAG   LDA     HYPFLAG          ;  HYPER-SPACE ACTIVE ?
         BNE     MOVDUMB          ;  .    IF SO, USE 'DUMB' MINE MOTION
;
         LDA     ABORT            ;  GAME ABORTED ?
         BNE     MOVDUMB          ;  .    IF SO, USE 'DUMB' MINE MOTION
;
         PSHS    DP               ;  SAVE ENTRY "DP"
         JSR     DPRAM            ;  SET "DP" REGISTER TO RAM
         direct   $C8              ;  .
;
         LDA     <WSHIPY          ;  CALCULATE DELTA YX VALUES
         SUBA    MIN_YW,U         ;  .
         LDB     <WSHIPX          ;  .
         SUBB    MIN_XW,U         ;  .
;
         JSR     CMPASS           ;  .    CALCULATE ANGLE TO SHIP
         SUBA    #$10             ;  .    .
         STA     <ETMP1           ;  .    .
;
         LDX     #MINSPD          ;  .    CALCULATE NEW DISPLACEMENTS
         LDB     MIN_BSZ,U        ;  .    .    FETCH MINE SPEED FOR SIZE
         LDA     B,X              ;  .    .    .
         LDB     <ETMP1           ;  .    .    FETCH DIRECTION
         JSR     MLTY8            ;  .    .    FETCH NEW DISPLACEMENTS
         STY     MIN_YD,U         ;  .    .    .    SAVE 'Y' DISPLACEMENT
         STX     MIN_XD,U         ;  .    .    .    SAVE 'X' DISPLACEMENT
;
         PULS    DP               ;  .    RECOVER DIRECT REGISTER
         direct   $D0              ;  .    .
;
;
MOVDUMB  LDD     MIN_YW,U         ;  CALCULATE NEW ABSOLUTE 'Y' VALUE
         ADDD    MIN_YD,U         ;  .
         STD     MIN_YW,U         ;  .
;
         LDD     MIN_XW,U         ;  CALCULATE NEW ABSOLUTE 'X' VALUE
         ADDD    MIN_XD,U         ;  .
         STD     MIN_XW,U         ;  .
;
;
MDRAW    JSR     INT3Q            ;  DISPLAY MINE PACKET FOR THIS ENTRY
         LDX     #MINOBJ          ;  .    LOOK-UP PACKET ADDRESS
         LDA     MIN_PAK,U        ;  .    .
         ASLA                     ;  .    .
         LDX     A,X              ;  .    .
         LEAY    MIN_YW,U         ;  .    SET POSITION
         LDB     MIN_SIZ,U        ;  .    SET ZOOM VALUE
         JSR     DPACK            ;  .    .
;
         JMP     GMIN2            ;  DO NEXT MINE ENTRY
;
;
MFBALL   LDD     MIN_YW,U         ;  HANDLE 'RELEASED' FIRE-BALL
         ADDD    MIN_YD,U         ;  .    'Y' AXIS
         BVS     MFBALL1          ;  .    .    OFF-SCREEN ?
         STD     MIN_YW,U         ;  .    .
;
         LDD     MIN_XW,U         ;  .    'X' AXIS
         ADDD    MIN_XD,U         ;  .    .
         BVS     MFBALL1          ;  .    .    OFF-SCREEN ?
         STD     MIN_XW,U         ;  .    .
;
         JSR     INTMAX           ;  .    DRAW FIRE-BALL
         LEAY    MIN_YW,U         ;  .    .    SET POSITION
         LDX     #PACKET2         ;  .    .    DRAW PACKET
         LDB     #$04             ;  .    .    .
         JSR     DPACK            ;  .    .    .
         JMP     GMIN2            ;  .
;
MFBALL1  CLR     MIN_FLG,U        ;  .    MINE OFF-SCREEN - CLEAR ENTRY
         DEC     CMINES           ;  .    .
         JMP     GMIN2            ;  .    .
;
;
MINIT    LDA     MIN_XW,U         ;  HANDLE INITIAL MINE MOTION
         ADDA    MIN_T1,U         ;  .    ADD DISPLACEMENT VALUE
         STA     MIN_XW,U         ;  .
;
         CMPA    MIN_T2,U         ;  .    HAS MINE REACHED DESTINATION ?
         BNE     MIDLE            ;  .    .
;
         LSR     MIN_FLG,U        ;  .    MINE HAS REACHED IDLE DESTINATION
;
;
MIDLE    JSR     INT3Q            ;  IDLE MINE ACTION
         LEAY    MIN_YW,U         ;  .    DRAW MINE SEED
         JSR     DDOT             ;  .    .
         JMP     GMIN2            ;  .    .
;
;
MZOOM    LDA     MIN_BSZ,U        ;  HANDLE THE MINE ZOOMING
         CMPA    #$03             ;  .    SMALL OR MEDIUM MINE ?
         BNE     MZOOM1           ;  .    .     SKIP ZOOMING
;
         LDA     MIN_SIZ,U        ;  IS MINE ZOOMING DONE ?
         CMPA    MIN_T1,U         ;  .
         BGE     MZOOM1           ;  .
;
         ADDA    #$08             ;  .    ZOOM MINE TO PRESET VALUE
         STA     MIN_SIZ,U        ;  .    .
         BRA     MZOOM9           ;  .    .
;
MZOOM1   LSR     MIN_FLG,U        ;  MINE HAS REACHED ITS PROPER SIZE
;
         LDA     MIN_T1,U         ;  .    SET ACTUAL MINE SIZE
         STA     MIN_SIZ,U        ;  .    .
;
         LDA     #$18             ;  .    SET MINE IDLE TIME
         STA     MIN_T1,U         ;  .    .
;
         LDA     MINMAX           ;  .    LAST MINE-SEED ?
         BNE     MZOOM9           ;  .    .
;
         LDA     RESEED           ;  .    .    MINE RE-SEEDING ALREADY STARTED ?
         BNE     MZOOM9           ;  .    .    .
;
         LDA     #$7F             ;  .    .    SET-UP FOR MINE-LAYER INSERTION
         STA     TMR3             ;  .    .    .
;
MZOOM9   JMP     MDRAW            ;  .    DRAW MINE
;
;
MWAIT    DEC     MIN_T1,U         ;  IDLE MINE
         BNE     MWAIT9           ;  .
;
         LSR     MIN_FLG,U        ;  .    SET MINE FLAG FOR NEXT ACTIVITY
;
MWAIT9   JMP     MDRAW            ;  .    DRAW MINE
;
;
MBOOM    CLR     MIN_FLG,U        ;  HANDLE MINE COLLISION
;
         LDA     MIN_PAK,U        ;  DETERMINE TYPE AND SIZE OF CURRENT MINE
         CMPA    #$04             ;  .    RELEASED FIRE-BALL ?
         BEQ     MBOOM9           ;  .    .
         LDB     MIN_BSZ,U        ;  .    SET NEW MINE SIZE
         DECB                     ;  .    .    SET TO NEXT SMALLER SIZE
         BEQ     MBOOM9           ;  .    .    .
;
         PSHS    A,DP             ;  ESTABLISH TWO NEW MINES
         LDA     #$C8             ;  .    SET "DP" REGISTER TO RAM
         TFR     A,DP             ;  .    .
;
         LDA     0,S              ;  .    GROW TWO NEW MINES
         JSR     RANSEED          ;  .    .
         JSR     RANSEED          ;  .    .
         PULS    A,DP             ;  .
;
MBOOM9   JMP     GMIN2            ;  .    DO NEXT MINE ENTRY
;
;
;  TAIL-END OF GAME LOGIC SEQUENCE
;  ===============================
;
;
TAIL     PSHS    DP               ;  SET "DP" REGISTER TO I/O
         JSR     DPIO             ;  .
         direct   $D0              ;  .
;
DEXPL    JSR     INTMAX           ;  DRAW EXPLOSIONS
         LDU     #EXP_TBL         ;  .
         LDA     #EXPLSN          ;  .
         STA     TEMP1            ;  .
;
EXPL1    LDA     EXP_FLG,U        ;  .    EXPLOSION ACTIVE ?
         LBEQ    EXPL9            ;  .    .
;
         LDB     EXP_CNT,U        ;  .    BUMP EXPLOSION COUNTER
         CMPB    EXP_SIZ,U        ;  .    .    EXPLOSION FULLY EXPANDED ?
         BHS     EXPL10           ;  .    .    .
         ADDB    #$03             ;  .    .
         STB     EXP_CNT,U        ;  .    .
;
         LDY     EXP_YX,U         ;  .    DRAW EXPANDING EXPLOSION CLOUD
         LDX     #EXPLODE         ;  .    .
         JSR     APACK            ;  .    .
;
EXPL10   TSTA                     ;  .    SWEEPER EXPLODING ?
         LBPL    EXPL2            ;  .    .
;
         DEC     SEXPCNT          ;  .    .    SWEEPER EXPLODING
         LBEQ    EXPL3            ;  .    .    .    EXPLOSION COMPLETE ?
;
         LDA     FRAME            ;  .    .    .    BUMP EXPLOSION ON EVEN FRAME
         ANDA    #$01             ;  .    .    .    .
         BNE     EXPL11           ;  .    .    .    .
         INC     SEXP1            ;  .    .    .    .
;
EXPL11   LDA     SEXP1            ;  .    .    .    DISPLAY SWEEPER EXPLOSION
         LDY     #$7F00           ;  .    .    .    .
         LDX     #SHPEX1          ;  .    .    .    .
         JSR     DSHPEXP          ;  .    .    .    .
;
         LDY     #$6080           ;  .    .    .    .
         LDX     #SHPEX2          ;  .    .    .    .
         JSR     DSHPEXP          ;  .    .    .    .
;
         LDY     #$8050           ;  .    .    .    .
         LDX     #SHPEX3          ;  .    .    .    .
         JSR     DSHPEXP          ;  .    .    .    .
;
         LDY     #$A080           ;  .    .    .    .
         LDX     #SHPEX4          ;  .    .    .    .
         JSR     DSHPEXP          ;  .    .    .    .
         BRA     EXPL9            ;  .    .    .    .
;
EXPL3    DEC     SHIPCNT          ;  .    RESET SWEEPER EXPLOSION
;
         CLR     CMINES           ;  .    .    CLEAR ACTIVE MINE COUNT
         CLR     MINMAX           ;  .    .    CLEAR MAXIMUM MINE COUNT
;
         LDA     PLAYRS           ;  .    .    SWITCH PLAYERS ?
         BEQ     EXPL30           ;  .    .    .
;
         LDA     ACTPLY           ;  .    .    .    SAVE CURRENT PLAYER STATUS
         LSRA                     ;  .    .    .    .
         LDX     #SHIPCNT0        ;  .    .    .    .    SAVE SHIP COUNTER
         LDB     SHIPCNT          ;  .    .    .    .    .
         STB     A,X              ;  .    .    .    .    .
;
         LDA     SHIPCNT0         ;  .    CONTINUE GAME ?
         BNE     EXPL31           ;  .    .
         LDA     SHIPCNT1         ;  .    .
         BEQ     EXPL32           ;  .    .
;
EXPL31   LDA     ACTPLY           ;  .    .    .    BUMP PLAYER FLAG
         ADDA    #$02             ;  .    .    .    .
         ANDA    #$02             ;  .    .    .    .
         STA     ACTPLY           ;  .    .    .    .
;
         LSRA                     ;  .    .    .    FETCH NEW PLAYER STATUS
         LDX     #SHIPCNT0        ;  .    .    .    .    FETCH SHIP COUNTER
         LDB     A,X              ;  .    .    .    .    .
         STB     SHIPCNT          ;  .    .    .    .    .
         BEQ     EXPL31           ;  .    .    .    .    .    SKIP IF NO SHIPS
;
EXPL30   LDA     SHIPCNT          ;  .    .    ONE PLAYER - SHIPS LEFT ?
         BNE     EXPL8            ;  .    .    .
;
EXPL32   LDA     #$01             ;  .    .    LOCK-UP ON GAME SEQUENCE
         STA     LOCK             ;  .    .    .
         BRA     EXPL8            ;  .    .    .
;
;
EXPL2    LDB     EXP_CNT,U        ;  .    EXPLOSION COMPLETE ?
         CMPB    EXP_SIZ,U        ;  .    .
         BLO     EXPL9            ;  .    .
;
EXPL8    CLR     EXP_FLG,U        ;  .    .    RESET EXPLOSION ENTRY
         DEC     CEXPLS           ;  .    .    .
;
EXPL9    LEAU    EXP_LEN,U        ;  .    BUMP TO NEXT ENTRY
         DEC     TEMP1            ;  .    .
         LBNE    EXPL1            ;  .    .
;
         JSR     SOUND            ;  UPDATE SOUND HANDLER
         BRA     SHPCNT0          ;  .
;
;
STAIL    PSHS    DP               ;  SHORT 'TAIL' ENTRY
         JSR     DPIO             ;  .    SET "DP" REGISTER TO I/O
;
SHPCNT0  JSR     INT3Q            ;  DISPLAY REMAINING SHIPS
         LDX     #$8038           ;  .    SET INITIAL POSITION
         STX     TEMP2            ;  .    .
;==========================================================================JJH
;        LDA     SHIPCNT          ;  CODE DELETED - REV. C CHANGES   ======JJH
;        BEQ     SHPCNT9          ;  .                               ======JJH
;        STA     TEMP1            ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         JSR     REVC_1           ;  CODE ADDED - REV. C CHANGES     ======JJH
         BEQ     SHPCNT9          ;  .                               ======JJH
         NOP                      ;  .                               ======JJH
         NOP                      ;  .                               ======JJH
         NOP                      ;  .                               ======JJH
;==========================================================================JJH
;
SHPCNT1  DEC     TEMP1            ;  .    DRAW THIS SHIP ?
         BEQ     SHPCNT9          ;  .    .
;
         LDA     TEMP2 + 1        ;  .    MOVE SHIP POSITION
         ADDA    #$06             ;  .    .
         STA     TEMP2 + 1        ;  .    .
;
         LDB     #$04             ;  .    DRAW SHIP COUNTER
         LDY     TEMP2            ;  .    .    SET POSITION
         LDX     #NSHIP           ;  .    .    SET PACKET ADDRESS
         JSR     APACK            ;  .    .    .
         BRA     SHPCNT1          ;  .    .    DO IT AGAIN
;
SHPCNT9  PULS    DP               ;  SET "DP" REGISTER TO RAM
         direct   $C8              ;  .
;
         LDA     <FRAME           ;  ROTATE FIREBALL
         ANDA    #$01             ;  .    FORM ROTATION ANGLE
         LSLA                     ;  .    .
         LSLA                     ;  .    .
         LSLA                     ;  .    .
         LDX     #MINE5           ;  .    FETCH SOURCE PACKET ADDRESS
         LDU     #PACKET2         ;  .    FETCH DESTINATION PACKET ADDRESS
         JSR     PROT             ;  .    ROTATE PACKET
;
         LDB     <CEXPLS          ;  END-OF-SEQUENCE
         BNE     TAIL1            ;  .    EXPLOSIONS DONE ?
         LDA     <ABORT           ;  .    GAME ABORTED ?
         BNE     TAIL0            ;  .    .
;
;==========================================================================JJH
;        LDB     <CMINES          ;  CODE DELETED - REV. C CHANGES   ======JJH
;        BNE     TAIL1            ;  .                               ======JJH
;        LDB     <MINMAX          ;  .                               ======JJH
;        BNE     TAIL1            ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         LDB     <CMINES          ;  CODE ADDED - REV. C CHANGES     ======JJH
         ORB     <MINMAX          ;  .                               ======JJH
         ORB     <LAYRSPD         ;  .                               ======JJH
         BNE     TAIL1            ;  .                               ======JJH
;==========================================================================JJH
;
TAIL0    ANDCC   #$FE             ;  SET 'C' TO '0' - LEVEL COMPLETE
         RTS                      ;  .    RETURN TO CALLER
;
TAIL1    ORCC    #$01             ;  SET 'C' TO '1' - MORE GAME LOGIC
         RTS                      ;  .    RETURN TO CALLER
;
;
;        SHIP EXPLOSION HANDLER
;        ----------------------
;
         direct   $D0
;
DSHPEXP  PSHS    A,X,Y            ;  SAVE ENTRY VALUES
         LDX     #WSHIPY          ;  POSITION TO CENETER OF EXPLOSION
         JSR     POSWID           ;  .
;
         LDA     0,S              ;  POSITION SHIP FRAGMENT
         STA     <T1LOLC          ;  .
         TFR     Y,D              ;  .
         JSR     POSITN           ;  .
;
         LDB     #P_SHPSZ         ;  DRAW SHIP FRAGMENT
         LDX     1,S              ;  .
         JSR     TPACK            ;  .
;
         PULS    A,X,Y,PC         ;  RETURN TO CALLER
;
;
;  SET EXPLOSION IN TABLE
;  ======================
;
;        ENTRY VALUES:
;             A = STARTING SIZE OF EXPLOSION
;             B = MAXIMUM SIZE OF EXPLOSION
;             X = POSITION OF EXPLOSION
;
;        RETURN VALUES:
;             SAME AS ENTRY VALUES
;
         direct   $C8
;        =====   ===
;
SETEXP   PSHS    A,B,X            ;  SAVE ENTRY VALUES
;
         LDX     #EXP_TBL         ;  FIND OPENING IN EXPLOSION TABLE
         LDA     #EXPLSN          ;  .
;
STEX1    LDB     EXP_FLG,X        ;  .    EXPLOSION ENTRY ACTIVE ?
         BEQ     STEX2            ;  .    .
;
         LEAX    EXP_LEN,X        ;  .    BUMP TO NEXT ENTRY
         DECA                     ;  .    .
         BNE     STEX1            ;  .    .
         BRA     STEX4            ;  .    .    NO ROOM FOR MORE EXPLOSIONS
;
STEX2    LDA     0,S              ;  ENTER EXPLOSION PARAMETERS
         ANDA    #$80             ;  .    SET EXPLOSION FLAG 
         INCA                     ;  .    .
         STA     EXP_FLG,X        ;  .    .
;
         BPL     STEX3            ;  .    .    EXPLOSION FATAL TO SWEEPER ?
         INC     <ABORT           ;  .    .    .    SET ABORT FLAG
;
STEX3    LDA     0,S              ;  .    SET STARTING EXPLOSION SIZE
         ANDA    #$7F             ;  .    .
         STA     EXP_CNT,X        ;  .    .
;
         LDA     1,S              ;  .    SET MAXIMUM EXPLOSION SIZE
         STA     EXP_SIZ,X        ;  .    .
;
         LDD     2,S              ;  .    SET EXPLOSION CENTRE
         STD     EXP_YX,X         ;  .    .
;
         INC     <CEXPLS          ;  .    BUMP ACTIVE EXPLOSION COUNTER
         INC     EXPLSND          ;  .    TRIGGER EXPLOSION SOUND
;
STEX4    PULS    A,B,X,PC         ;  RETURN TO CALLER
;
;
;  FORM 'YX' DISPLACEMENTS
;  =======================
;
;        ENTRY VALUES:
;             A = SPEED VECTOR
;             B = DIRECTION
;
;        RETURN VALUES:
;             Y = 'Y' DISPLACEMENT VALUE (MSB/LSB)
;             X = 'X' DISPLACEMENT VALUE (MSB/LSB)
;
         direct   $C8
;        =====   ===
;
MLTY8    PSHS    A,B,X,Y          ;  SAVE ENTRY VALUES
;
         JSR     LNROT            ;  CALCULATE SHIP DISPLACEMENTS
         STA     4,S              ;  .
;
         SEX                      ;  .    FORM 'X' DISPLACEMENT (8X)
         ASLB                     ;  .    .    MULTIPLY BY EIGHT
         ROLA                     ;  .    .    .
         ASLB                     ;  .    .    .
         ROLA                     ;  .    .    .
         ASLB                     ;  .    .    .
         ROLA                     ;  .    .    .
         STD     2,S              ;  .    .    .
;
         LDB     4,S              ;  .    FORM 'Y' DISPLACEMENT (8X)
         SEX                      ;  .    .    EXTEND SIGN
         ASLB                     ;  .    .    MULTIPLY BY EIGHT
         ROLA                     ;  .    .    .
         ASLB                     ;  .    .    .
         ROLA                     ;  .    .    .
         ASLB                     ;  .    .    .
         ROLA                     ;  .    .    .
         STD     4,S              ;  .    .    .
;
         PULS    A,B,X,Y,PC       ;  .    RETURN TO CALLER
;
;
;
MLTY16   PSHS    A,B,X,Y          ;  SAVE ENTRY VALUES
;
         BSR     MLTY8            ;  CALCULATE 16X SHIP DISPLACEMENTS
;
         LDD     -4,S             ;  .    FORM 'Y' DISPLACEMENT (16X)
         ASLB                     ;  .    .    MULTIPLY BY TWO
         ROLA                     ;  .    .    .
         STD     4,S              ;  .    .    .
;
         LDD     -6,S             ;  .    FORM 'X' DISPLACEMENT (16X)
         ASLB                     ;  .    .    MULTIPLY BY TWO
         ROLA                     ;  .    .    .
         STD     2,S              ;  .    .    .
;
         PULS    A,B,X,Y,PC       ;  .    RETURN TO CALLER
;
;
;  INITIALIZE STAR-SWEEPER
;  =======================
;
;
SWPINT   LDA     #$D0             ;  SET "DP" REGISTER TO I/O
         TFR     A,DP             ;  .
         direct   $D0              ;  .
;
         JSR     INTPSG           ;  INITIALIZE SOUND GENERATOR
;
         LDA     #$C8             ;  SET "DP" REGISTER TO RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         CLR     <TMR1            ;  CLEAR PROGRAMMABLE TIMERS
         CLR     <TMR2            ;  .
         CLR     <TMR3            ;  .
         CLR     <TMR4            ;  .
;
         LDX     #BLT_TBL         ;  CLEAR TABLES
CLROBJ   CLR     ,X+               ;  .
         CMPX    #FSTAR           ;  .
         BNE     CLROBJ           ;  .
;
         LDD     #$0000           ;  CLEAR MINE-LAYER PARAMETERS
         STD     <WLAYRY          ;  .
         STD     <WLAYRX          ;  .
         STD     <DLAYRY          ;  .
         STD     <DLAYRX          ;  .
         STA     <LAYRSPD         ;  .    CLEAR LAYER SPEED
;
         STA     <ABORT           ;  RESET ABORT FLAG
         STA     <LOCK            ;  RESET LOCK-UP FLAG
;
         STA     <CBULLET         ;  CLEAR ACTIVE BULLET COUNTER
         STA     <CMINES          ;  CLEAR ACTIVE MINE COUNTER
         STA     <CEXPLS          ;  CLEAR ACTIVE EXPLOSION COUNTER
;
         STA     SEXP1            ;  SET SHIP EXPLOSION COUNTERS
         LDB     #$40             ;  .    SHIP EXPLOSION DURATION
         STB     SEXPCNT          ;  .    .
;
         STA     <MINMAX          ;  RESET MINE-SEED COUNTER
         STA     <RESEED          ;  RESET MINE RE-SEEDING COUNTER
;
         LDX     #$0800           ;  SET LONG TIME-OUT DELAY
         STX     TIMEOUT          ;  .
;
         LDA     #$07             ;  SET MINE RE-SEED COUNT
         STA     <RSMINES         ;  .
;
         LDX     #BEGLAYR         ;  SET-UP FOR FIRST MINE-LAYER MODIFICATION
         STX     <TMR3 + 1        ;  .
;
;
;  RESET STAR-SWEEPER PARAMETERS
;  =============================
;
;
SWPRST   LDD     #0               ;  CLEAR STAR-SWEEPER PARAMETERS
         STD     <WSHIPY          ;  .    WORKING POSITIONS
         STD     <WSHIPX          ;  .    .
;
HSWPRST  LDD     #$0000           ;  .    SHIP ROTATION
         STA     <SHIPROT         ;  .    .
         STD     <DSHIPY1         ;  .    AXIS #1 DISPLACEMENTS
         STD     <DSHIPX1         ;  .    .
         STA     <SHIPSPD1        ;  .    .    CLEAR SHIP SPEED
         STA     <SHIPDIR1        ;  .    .    CLEAR SHIP DIRECTION
         STD     <DSHIPY2         ;  .    AXIS #2 DISPLACEMENTS
         STD     <DSHIPX2         ;  .    .
         STA     <SHIPSPD2        ;  .    .    CLEAR SHIP SPEED
         STA     <SHIPDIR2        ;  .    .    CLEAR SHIP DIRECTION
;
SWPROT   LDA     <SHIPROT         ;  ROTATE SWEEPER
         LDX     #NSHIP           ;  .
         LDU     #PACKET1         ;  .
         JSR     PROT             ;  .
;
         LDA     #$7F             ;  CALCULATE NEW BULLET DISPLACEMENTS
         LDB     <SHIPROT         ;  .    FETCH DIRECTION
         JSR     MLTY16           ;  .    FORM DISPLACEMENTS
         STY     DBLTY            ;  .    .    SAVE 'Y' DISPLACEMENT
         STX     DBLTX            ;  .    .    SAVE 'X' DISPLACEMENT
;
         RTS                      ;  RETURN TO CALLER
;
;
;  FALL THRU STAR FIELD AS LEAD-IN TO NEXT SEQUENCE
;  ================================================
;
         direct   $C8
;        =====   ===
;
FALL     PSHS    X,Y              ;  SAVE THE INDEX REGISTERS
         PSHS    DP               ;  SAVE THE ENTRY "DP"
;
         JSR     DPIO             ;  SET "DP" REGISTER TO I/O
         JSR     INTPSG           ;  CLEAR-OUT SOUND
;
         PULS    DP               ;  SET "DP" REGISTER TO RAM
;
         LDA     #$A0             ;  SET MINIMUM FALL-THRU TIME
         STA     <TEMP1           ;  .
;
FALL1    LDA     <WSHIPY          ;  MOVE SHIP TO CENTER POSITION
         BEQ     FALL2            ;  .    'Y' AXIS
         BMI     FALL10           ;  .    .
         DECA                     ;  .    .    CURRENT POSITION POSITIVE
         BRA     FALL11           ;  .    .    .
;
FALL10   INCA                     ;  .    .    CURRENT POSITION NEGATIVE
FALL11   STA     <WSHIPY          ;  .    .    .
         CLR     <WSHIPY + 1      ;  .    .    .
;
FALL2    LDA     <WSHIPX          ;  .    'X' AXIS
         BEQ     FALL3            ;  .    .
         BMI     FALL20           ;  .    
         DECA                     ;  .    .    CURRENT POSITION POSITIVE
         BRA     FALL21           ;  .    .    .
;
FALL20   INCA                     ;  .    .    CURRENT POSITION NEGATIVE
FALL21   STA     <WSHIPX          ;  .    .    .
         CLR     <WSHIPX + 1      ;  .    .    .
;
FALL3    LDA     <SHIPROT         ;  .    ROTATION
         BEQ     FALL4            ;  .    .
         CMPA    #$1F             ;  .    .
         BGT     FALL30           ;  .    .    ROTATE LEFT
         DECA                     ;  .    .    .
         BRA     FALL31           ;  .    .    .
;
FALL30   INCA                     ;  .    .    ROTATE RIGHT
FALL31   ANDA    #$3F             ;  .    .    .
         STA     <SHIPROT         ;  .    .    .
;
FALL4    JSR     SHPONLY          ;  ROTATE AND DISPLAY STAR-SWEEPER
;
         LDX     #ZSTAR           ;  ADVANCE STAR FIELD
         LDB     #$08             ;  .
FALL5    LDA     0,X              ;  .
         ADDA    #$03             ;  .
         STA     ,X+               ;  .
         DECB                     ;  .
         BNE     FALL5            ;  .
;
         PSHS    DP               ;  SET "DP" REGISTER TO I/O
         JSR     DPIO             ;  .
         direct   $D0              ;  .
;
         JSR     SCRBTH           ;  DISPLAY PLAYER SCORES
;
         CLRB                     ;  DISPLAY STAR FIELDS
         LDA     #$20             ;  .
         JSR     D_STARS          ;  .
         JSR     F_STARS          ;  .
;
         PULS    DP               ;  SET "DP" REGISTER TO RAM
         direct   $C8              ;  .
;  
FALL91   LDA     <WSHIPY          ;  FALL-THRU COMPLETED ?
         LBNE    FALL1            ;  .
         LDA     <WSHIPX          ;  .
         LBNE    FALL1            ;  .
         LDA     <SHIPROT         ;  .
         LBNE    FALL1            ;  .
         DEC     <TEMP1           ;  .    END-OF-SEQUENCE ?
         LBNE    FALL1            ;  .    .
;
         JSR     SWPINT           ;  RESET VALUES
         PULS    X,Y,PC           ;  .    RETURN TO CALLER
;
;
;  INITIALIZE STAR FIELDS
;  ======================
;
;
I_STARS  LDX     #STAR_1
         LDY     #FSTAR
         LDU     #ZSTAR
;
         LDB     #$08
         LDA     #$16
;
ST_101   STX     ,Y++
         LEAX    8,X
         STA     ,U+
         ADDA    #$0F
         DECB
         BNE     ST_101
         RTS
;
;
;  ZOOM STAR FIELDS FORWARD AND DISPLAY
;  ====================================
;
;        ENTRY VALUES
;             A = STAR FIELD LIMIT
;             B = ZOOM VALUE
;
;        RETURN VALUES
;             SAME AS ENTRY
;
         direct   $D0
;        =====   ===
;
F_STARS  PSHS    A,B,X,DP         ;  SAVE ENTRY VALUES
;
         LDX     #ZSTAR           ;  BUMP ZOOM VALUES
         LDA     #$08             ;  .
ST_201   INC     ,X+               ;  .
         DECA                     ;  .
         BNE     ST_201           ;  .
;
         BRA     DSTARS1          ;  DISPLAY NEW STAR FIELDS
;
;
;  DISPLAY STAR FIELDS
;  ===================
;
;        ENTRY VALUES
;             A = STAR FIELD INNER LIMIT
;             B = ZOOM VALUE
;
;        RETURN VALUES
;             SAME AS ENTRY
;
         direct   $D0
;        =====   ===
;
D_STARS  PSHS    A,B,X,DP         ;  SAVE ENTRY VALUES
;
DSTARS1  LDA     #$D0             ;  SET "DP" REGISTER TO I/O
         TFR     A,DP             ;  .
;
         LDA     #$09             ;  SET FIELD COUNT
         PSHS    A                ;  .
;
ST_000   DEC     0,S              ;  MOVE TO NEXT STAR FIELD
         BNE     ST_010           ;  .
;
         JSR     ZERGND           ;  ZERO INTEGRATORS
;
         PULS    A                ;  RETURN TO CALLER
         PULS    A,B,X,DP,PC      ;  .
;
;
ST_010   JSR     ZERGND           ;  TURN-OFF CRT GUN AND ZERO INTEGRATORS
;
         LDA     #$03             ;  SET DOT COUNT
         STA     LIST             ;  .
;
         LDA     0,S              ;  FETCH ZOOM VALUE FOR THIS FIELD
         DECA                     ;  .
         LDX     #ZSTAR           ;  .
         LDB     A,X              ;  .
         ANDB    #$7F             ;  .
;
         CMPB    1,S              ;  HAS STAR FIELD REACHED ITS LIMIT ?
         BLS     ST_000           ;  .    IF SO, FETCH NEXT STAR FIELD
         SUBB    2,S              ;  .    MODIFY VECTOR LENGTH WITH ZOOM VALUE
         BLE     ST_000           ;  .    .
         STB     <T1LOLC          ;  .    SET VECTOR LENGTH
;
         LDX     #FSTAR           ;  FETCH STAR FIELD POINTER
         LSLA                     ;  .
         LDX     A,X              ;  .
;
         JSR     INTMAX           ;  SET BRIGHTNESS
         JSR     DIFDOT           ;  DRAW STAR FIELD
         BRA     ST_000           ;  SET-UP FOR NEXT STAR-FIELD
;
;
;  DISPLAY STAR FIELDS FOR HYPERSPACE SEQUENCE
;  ===========================================
;
;        ENTRY VALUES
;             A = OVER-RIDING INTENSITY 
;             B = ZOOM VALUE
;
;        RETURN VALUES
;             SAME AS ENTRY
;
         direct   $D0
;        =====   ===
;
H_STARS  PSHS    A,B,X,DP         ;  SAVE ENTRY VALUES
;
         LDA     #$D0             ;  SET "DP" REGISTER TO I/O
         TFR     A,DP             ;  .
;
         LDA     #$09             ;  SET FIELD COUNT
         PSHS    A                ;  .
;
ST_200   DEC     0,S              ;  MOVE TO NEXT STAR FIELD
         BNE     ST_210           ;  .
;
         JSR     ZERGND           ;  ZERO INTEGRATORS
;
         PULS    A                ;  RETURN TO CALLER
         PULS    A,B,X,DP,PC      ;  .
;
;
ST_210   JSR     ZERGND           ;  TURN-OFF CRT GUN AND ZERO INTEGRATORS
;
         LDA     #$03             ;  SET DOT COUNTER
         STA     LIST             ;  .
;
         LDX     #WSHIPY          ;  POSITION FOR SWEEPER CENTER
         JSR     POSWID           ;  .
;
         LDB     0,S              ;  FETCH ZOOM VALUE FOR THIS FIELD
         LSLB                     ;  .
         LSLB                     ;  .
         ADDB    2,S              ;  .
         BLE     ST_200           ;  .    SKIP THIS STAR FIELD ?
         ANDB    #$7F             ;  .    SET VECTOR LENGTH
         STB     <T1LOLC          ;  .    .
;
         LDX     #FSTAR           ;  FETCH STAR FIELD POINTER
         LDA     0,S              ;  .
         DECA                     ;  .
         LSLA                     ;  .
         LDX     A,X              ;  .
;
         JSR     INTMAX           ;  SET BRIGHTNESS
         JSR     DIFDOT           ;  DRAW STAR FIELD
         BRA     ST_200           ;  SET-UP FOR NEXT STAR-FIELD
;
;
;  DETERMINE RANDOM 'Y:X' POSITION
;  ===============================
;
         direct   $C8
;        =====   ===
;
RANPOS   PSHS    D                ;  SAVE ENTRY VALUES
;
         JSR     RANDOM           ;  'Y' POSITION
         STA     0,S              ;  .
;
RANPOS1  JSR     RANDOM           ;  'X' POSITION
         CMPA    #$60             ;  .
         BGT     RANPOS1          ;  .
         CMPA    #$A0             ;  .
         BLT     RANPOS1          ;  .
         STA     1,S              ;  .
;
         PULS    D                ;  RETURN TO CALLER
         RTS                      ;  .
;
;
;  SELECT RANDOM SEED/MINE ENTRY
;  =============================
;
;        ENTRY VALUES:
;             A = MINE TYPE
;             B = MINE SIZE
;
;        RETURN VALUES:
;             SAME AS ENTRY VALUES
;
         direct   $C8
;        =====   ===
;
RANSEED  PSHS    A,B,X,Y,U        ;  SAVE ENTRY VALUES
;
         LDA     <MINMAX          ;  ALL THE MINES DISPLAYED ?
         LBEQ    RANS9            ;  .
         DEC     <MINMAX          ;  .
;
         JSR     RANDOM           ;  SET-UP FOR RANDOM ENTRY
         ANDA    #$1F             ;  .    ENTRY MUST BE BETWEEN $00 AND $1B
RANS1    STA     <ETMP9           ;  .    .
         CMPA    #27              ;  .    .
         BLS     RANS2            ;  .    .
         SUBA    #$4              ;  .    .    TOO BIG - FUDGE DOWN
         BRA     RANS1            ;  .    .    .
;
RANS2    LDB     #MIN_LEN         ;  .    CALCULATE ACTUAL MINE ENTRY
         MUL                      ;  .    .
         ADDD    #MIN_TBL         ;  .    .
         TFR     D,U              ;  .    .
;
         LDA     MIN_FLG,U        ;  .    MINE ENTRY ACTIVE ?
         ANDA    #$C0             ;  .    .    MOVING TO INITIAL POSITION OR IDLE ?
         BNE     RANS3            ;  .    .
         INC     <ETMP9           ;  .    .    TRY ANOTHER ENTRY
         LDA     <ETMP9           ;  .    .    .
         CMPA    #27              ;  .    .    .    STILL WITHIN RANGE ?
         BLE     RANS2            ;  .    .    .    .
;
         CLR     <ETMP9           ;  .    .    .    OUT-OF-RANGE
         CLRA                     ;  .    .    .    .
         BRA     RANS2            ;  .    .    .    .
;
RANS3    LDA     0,S              ;  .    SET MINE TYPE
         STA     MIN_PAK,U        ;  .    .
;
         LDX     #MINSCR          ;  .    SELECT MINE'S BASIC SCORE
         ASLA                     ;  .    .
         LDY     A,X              ;  .    .
         STY     <ETMP7           ;  .    .
;
         LDB     #$20             ;  .    SET ZOOM FLAG
         STB     MIN_FLG,U        ;  .    .
;
         LDX     #MINSPD          ;  .    SELECT MINE SPEED
         LDA     1,S              ;  .    .    FETCH MINE SIZE
         LDB     A,X              ;  .    .
         STB     <ETMP9           ;  .    .
;
         LDX     #MINSZ           ;  .    SET MINE SIZE
         LDB     A,X              ;  .    .
         STB     MIN_T1,U         ;  .    .
         STA     MIN_BSZ,U        ;  .    .
;
         LDX     #MINBOX          ;  .    SELECT COLLISION BOX PARAMETERS
         LSLA                     ;  .    .
         LDY     A,X              ;  .    .
         STY     MIN_BOX,U        ;  .    .
;
         LDX     #MINSSCR         ;  .    SELECT MINE'S SCORE VS_ SPEED VALUE
         LDY     A,X              ;  .    .
         STY     <ETMP5           ;  .    .
;
         CMPA    #$06             ;  .    SET 'POP' SOUND
         BNE     RANS4            ;  .    .    BIG MINES ONLY
         INC     POPSND           ;  .    .    .
;
RANS4    LDA     <ETMP5 + 1       ;  .    CALCULATE MINE SCORE VALUE
         ADDA    <ETMP7 + 1       ;  .    .    LSB
         DAA                      ;  .    .    .
         STA     MIN_SCR+1,U      ;  .    .    .
         LDA     <ETMP5           ;  .    .    MSB
         ADCA    <ETMP7           ;  .    .    .
         DAA                      ;  .    .    .
         STA     MIN_SCR,U        ;  .    .    .
;
         LDA     <ETMP9           ;  .    CALCULATE MINE DISPLACEMENTS
         JSR     CONE             ;  .    .    SELECT ANGLE
         JSR     MLTY8            ;  .    .    FORM DISPLACEMENTS
         STY     MIN_YD,U         ;  .    .    .    SAVE 'Y' DISPLACEMENTS
         STX     MIN_XD,U         ;  .    .    .    SAVE 'X' DISPLACEMENTS
;
         INC     <CMINES          ;  .    BUMP ACTIVE MINE COUNTER
;
         LDA     <RESEED          ;  .    RESET FORCED MINE GROWTH TIMER
         BEQ     RANS9            ;  .    .    SKIP IF NOT RE-SEEDED
;
         LDA     #$FF             ;  .    .    RESET TIMER #1
         STA     <TMR1            ;  .    .    .
         LDA     #$03             ;  .    .    RESET FORCE COUNTER
         STA     <FRCTIME         ;  .    .    .
;
RANS9    PULS    A,B,X,Y,U,PC     ;  RETURN TO CALLER
;   
;
;  SELECT DIRECTION WITHIN LIMIT CONES
;  ===================================
;
;        ENTRY VALUES
;             NONE REQUIRED
;
;        RETURN VALUES
;             B = RANDOM ANGLE WITHIN LIMIT CONES
;
         direct   $C8
;        =====   ===
;
CONE     PSHS    A,B              ;  SAVE ENTRY VALUES
;
         JSR     RANDOM           ;  FETCH RANDOM NUMBER
         TFR     A,B              ;  .    SET-UP FOR CONE TESTS
         ANDA    #$30             ;  .    .
         STA     1,S              ;  .    .
;
         ANDB    #$0F             ;  LIMIT DIRECTION WITHIN CONE
         CMPB    #$04             ;  .    TEST AGAINST LOW-END LIMIT
         BHS     CONE1            ;  .    .
         ADDB    #$04             ;  .    .    MOVE LOW-END UP
;
CONE1    CMPB    #$0C             ;  .    TEST AGAINST UPPER-END LIMIT
         BLS     CONE2            ;  .    .
         SUBB    #$04             ;  .    .    MOVE UPPER-END DOWN
;
CONE2    ADDB    1,S              ;  ADD QUADRANT TO DIRECTION
         STB     1,S              ;  .
         PULS    A,B,PC           ;  .    RETURN TO CALLER
;
;
;  POSITION AND DRAW DOT
;  =====================
;
;        ENTRY VALUES
;             Y = ABSOLUTE 'YX' POSITION
;
;        RETURN VALUES
;             SAME AS ENTRY VALUES
;
;
         direct   $D0
;        =====   ===
;
ADOT     PSHS    A,B              ;  SAVE ENTRY VALUES
;
         LDA     #$7F             ;  POSITION DOT
         STA     <T1LOLC          ;  .    SET VECTOR LENGTH
         TFR     Y,D              ;  .    SET 'YX' POSITION
         JSR     DOTAB            ;  .    .
;
         JSR     ZERGND           ;  ZERO INTEGRATORS
;
         PULS    A,B,PC           ;  RETURN TO CALLER
;
;
;  POSITION WITH 16-BIT VALUES AND DRAW DOT
;  ========================================
;
;        ENTRY VALUES
;             Y = POINTER TO 32-BIT ABSOLUTE 'YX' POSITION
;
;        RETURN VALUES
;             SAME AS ENTRY VALUES
;
;
         direct   $D0
;        =====   ===
;
DDOT     PSHS    A,B              ;  SAVE ENTRY VALUES
;
         LDA     #$7F             ;  POSITION DOT
         STA     <T1LOLC          ;  .    SET VECTOR LENGTH
;
         LDA     0,Y              ;  .    SET 'YX' POSITION
         LDB     2,Y              ;  .    .
         JSR     DOTAB            ;  .    .
;
         JSR     ZERGND           ;  ZERO INTEGRATORS
;
         PULS    A,B,PC           ;  RETURN TO CALLER
;
;
;  POSITION AND DRAW PACKET
;  ========================
;
;        ENTRY VALUES
;             B = ZOOM VALUE
;             X = PACKET ADDRESS
;             Y = ABSOLUTE 'YX' POSITION
;
;        RETURN VALUES
;             SAME AS ENTRY VALUES
;
;
         direct   $D0
;        =====   ===
;
APACK    PSHS    A,B,X            ;  SAVE ENTRY VALUES
;
         TFR     Y,D              ;  .    SET 'YX' POSITION
         JSR     POSITD           ;  .    .
;
         LDB     1,S              ;  DRAW PACKET
         JSR     TPACK            ;  .    DRAW PACKET
;
         PULS    A,B,X,PC         ;  RETURN TO CALLER
;
;
;  POSITION WITH 16-BIT VALUES AND DRAW PACKET
;  ===========================================
;
;        ENTRY VALUES
;             B = ZOOM VALUE
;             X = ADDRESS OF PACKET
;             Y = POINTER TO 32-BIT ABSOLUTE 'YX' POSITION
;
;        RETURN VALUES
;             SAME AS ENTRY VALUES
;
;
         direct   $D0
;        =====   ===
;
DPACK    PSHS    A,B,X            ;  SAVE ENTRY VALUES
;
         TFR     Y,X              ;  POSITION PACKET
         JSR     POSWID           ;  .
;
         LDB     1,S              ;  DRAW PACKET
         LDX     2,S              ;  .    FETCH PACKET POINTER
         JSR     TPACK            ;  .    DRAW PACKET
;
         PULS    A,B,X,PC         ;  RETURN TO CALLER
;
;
;  DRAW COMPACT RASTER MESSAGE
;  ===========================
;
;        ENTRY VALUES
;             U = ADDRESS OF MESSAGE
;
;        RETURN VALUES
;             SAME AS ENTRY VALUES
;
;
         direct   $D0
;        =====   ===
;
MESS     PSHS    A,B,X,U          ;  SAVE ENTRY VALUES
;
         LDA     #$7F             ;  POSITION PACKET
         STA     <T1LOLC          ;  .    SET VECTOR LENGTH
;
         JSR     RSTSIZ           ;  DRAW RASTER MESSAGE
;
         PULS    A,B,X,U,PC       ;  RETURN TO CALLER
;
;
;  POSITION AND DRAW RASTER MESSAGE
;  ================================
;
;        ENTRY VALUES
;             U = ADDRESS OF MESSAGE
;             Y = ABSOLUTE 'YX' POSITION
;
;        RETURN VALUES
;             SAME AS ENTRY VALUES
;
;
         direct   $D0
;        =====   ===
;
AMESS    PSHS    A,B,X,U          ;  SAVE ENTRY VALUES
;
         TFR     Y,D              ;  .    SET 'YX' POSITION
         JSR     POSITD           ;  .    .
;
         JSR     RASTER           ;  .    DRAW PACKET
;
         PULS    A,B,X,Y,PC       ;  RETURN TO CALLER
;
;
;  DRAW ACTIVE PLAYER'S SCORES
;  ===========================
;
         direct   $D0
;        =====   ===
;
SCRMES   JSR     INTMAX           ;  SET MAXIMUM INTENSITY
;
         LDD     #$FC38           ;  SET RASTER SIZE
         STD     SIZRAS           ;  .
;
         LDA     ACTPLY           ;  FETCH POSITION OF SCORE
         LDY     #PSCRPTR         ;  .
         LDY     A,Y              ;  .
;
         LDU     #SCRPTR          ;  FETCH ADDRESS OF SCORE
         LDU     A,U              ;  .
         BSR     AMESS            ;  .
;
         RTS                      ;  RETURN TO CALLER
;
;
;  DRAW BOTH PLAYER'S SCORES
;  =========================
;
         direct   $D0
;        =====   ===
;
SCRBTH   JSR     INTMAX           ;  SET MAXIMUM INTENSITY
;
         LDD     #$FC38           ;  SET RASTER SIZE
         STD     SIZRAS           ;  .
;
         LDY     #PSCOR1          ;  DRAW PLAYER #1 SCORE
         LDU     #SCOR1           ;  .
         BSR     AMESS            ;  .
;
         LDA     PLAYRS           ;  ONE OR TWO PLAYERS ?
         BEQ     BOTH9            ;  .
         LDY     #PSCOR2          ;  .    DRAW PLAYER #2 SCORE
         LDU     #SCOR2           ;  .    .
         BSR     AMESS            ;  .    .
;
BOTH9    RTS                      ;  RETURN TO CALLER
;
;
;  WAIT FOR FRAME BOUNDARY AND INPUT FROM CONTROLLER
;  =================================================
;
;
WAIT     JSR     FRWAIT           ;  WAIT FOR FRAME BOUNDARY
         PSHS    DP               ;  .
         direct   $D0              ;  .
;
         JSR     DEFLOK           ;  PREVENT SCAN COLLAPSE
         JSR     SCRMES           ;  DRAW PLAYER'S SCORES
;
         LDA     SBTN             ;  INPUT CONSOLE SWITCHES
         JSR     DBNCE            ;  .
         LDD     SJOY             ;  READ JOYSTICK
         STD     EPOT0            ;  .    ENABLE BOTH POTS ON JOYSTICK #1
         STD     EPOT2            ;  .    ENABLE BOTH POTS ON JOYSTICK #2
         JSR     JOYBIT           ;  .
;
         LDA     #$C8             ;  SET "DP" REGISTER TO RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
TIMER    LDA     <TMR1            ;  DOWN-COUNT TIMER #1
         BEQ     DCT2             ;  .    IS TIMER INHIBITED ?
         DEC     <TMR1            ;  .
         BNE     DCT2             ;  .
         JSR     [TMR1+1]         ;  .    EXECUTE THE USER PROGRAM
;
DCT2     LDA     <TMR2            ;  DOWN-COUNT TIMER #2
         BEQ     DCT3             ;  .    IS TIMER INHIBITED ?
         DEC     <TMR2            ;  .
         BNE     DCT3             ;  .
         JSR     [TMR2+1]         ;  .    EXECUTE THE USER PROGRAM
;
DCT3     LDA     <TMR3            ;  DOWN-COUNT TIMER #3
         BEQ     DCT4             ;  .    IS TIMER INHIBITED ?
         DEC     <TMR3            ;  .
         BNE     DCT4             ;  .
         JSR     [TMR3+1]         ;  .    EXECUTE THE USER PROGRAM
;
DCT4     LDA     <TMR4            ;  DOWN-COUNT TIMER #4
         BEQ     WAIT9            ;  .    IS TIMER INHIBITED ?
         DEC     <TMR4            ;  .
         BNE     WAIT9            ;  .
         JSR     [TMR4+1]         ;  .    EXECUTE THE USER PROGRAM
;
WAIT9    PULS    DP,PC            ;  RETURN TO CALLER
;
;
;  HANDLE BULLET VS_ MINE COLLISIONS
;  =================================
;
         direct   $C8
;        =====   ===
;
CBULMIN  LDA     <CBULLET         ;  ACTIVE BULLETS ?
         BEQ     CBUL20           ;  .
;
         LDY     #BLT_TBL         ;  FIND BULLET TO COMPARE WITH
         LDA     #BULLETS         ;  .
         STA     <TEMP1           ;  .
;
CBUL1    TST     BLT_FLG,Y        ;  .    BULLET ACTIVE ?
         BNE     CBUL3            ;  .    .
;
CBUL2    LEAY    BLT_LEN,Y        ;  .    BUMP TO NEXT ENTRY
         DEC     <TEMP1           ;  .    .    END OF TABLE ?
         BNE     CBUL1            ;  .    .    .
CBUL20   RTS                      ;  .    RETURN - NO ACTIVE BULLET FOUND
;
;
CBUL3    LDA     <LAYRSPD         ;  COMPARE BULLET VS_ MINE-LAYER
         BEQ     CBUL30           ;  .    IS MINE-LAYER OFF-SCREEN ?
;
         PSHS    Y                ;  .    FINE COLLISION TEST
         LDA     BLT_WY,Y         ;  .    .    FETCH BULLET POSITION
         LDB     BLT_WX,Y         ;  .    .    .
         TFR     D,X              ;  .    .    .
         LDD     #P_LYRBX         ;  .    .    FETCH MINE-LAYER BOX SIZE
         LDY     <LAYRYX          ;  .    .    FETCH MINE-LAYER POSITION
         JSR     BXTEST           ;  .    .    DO BOX TEST
         PULS    Y                ;  .    .    .    FAILED COLLISION ?
         BCC     CBUL30           ;  .    .    .    .
;
         CLR     BLT_FLG,Y        ;  .    COLLISION DETECTED - RESET CONDITIONS
         CLR     <LAYRSPD         ;  .    .    RESET MINE LAYER
         CLR     <TMR3            ;  .    .    .    INSERTION TIMER
;
         LDX     #SCRPTR          ;  .    .    ADD POINTS TO ACTIVE PLAYER SCORE
         LDA     <ACTPLY          ;  .    .    .    PLAYER #1 OR #2 ?
         LDX     A,X              ;  .    .    .    .
         LDD     #$1000           ;  .    .    .
         JSR     SCRADD           ;  .    .    .
;
         LDA     #$30             ;  .    .    ENTER COLLISION IN EXPLOSION TABLE
         LDB     #$70             ;  .    .    .    SET EXPLOSION SIZE
         LDX     <LAYRYX          ;  .    .    .    SET EXPLOSION CENTRE
         JSR     SETEXP           ;  .    .    .    SET EXPLOSION IN TABLE
;
         DEC     <CBULLET         ;  .    .    DECREMENT ACTIVE BULLET COUNTER
         BRA     CBUL20           ;  .    .    .
;
;
CBUL30   LDU     #MIN_TBL         ;  FIND MINE TO COMPARE AGAINST BULLET
         LDA     #MINES           ;  .
         STA     <TEMP2           ;  .
;
CBUL4    LDA     MIN_FLG,U        ;  .    MINE ACTIVE ?
         ANDA    #$3F             ;  .    .
         BNE     CBUL6            ;  .    .
;
CBUL5    LEAU    MIN_LEN,U        ;  .    BUMP TO NEXT ENTRY
         DEC     <TEMP2           ;  .    .    END OF TABLE ?
         BNE     CBUL4            ;  .    .    .
         BRA     CBUL2            ;  .    NO ACTIVE MINE FOUND - NEXT BULLET
;
CBUL6    PSHS    Y                ;  .    FINE COLLISION TEST
         LDA     BLT_WY,Y         ;  .    .    FETCH BULLET POSITION
         LDB     BLT_WX,Y         ;  .    .    .
         TFR     D,X              ;  .    .    .
         LDA     MIN_YW,U         ;  .    .    FETCH MINE POSITION
         LDB     MIN_XW,U         ;  .    .    .
         TFR     D,Y              ;  .    .    .
         LDD     MIN_BOX,U        ;  .    .    FETCH MINE BOX SIZE
         JSR     BXTEST           ;  .    .    DO BOX TEST
         PULS    Y                ;  .    .    .    FAILED COLLISION ?
         BCC     CBUL5            ;  .    .    .    .
;
         LDA     MIN_PAK,U        ;  .    COLLISION DETECTED
         ANDA    #$02             ;  .    .     FIREBALL RELEASED ?
         BEQ     CBUL7            ;  .    .     .
;
;
         LDX     #SCRPTR          ;  'FIRE-BALL' RELEASED
         LDA     <ACTPLY          ;  .    ADD MINE TO ACTIVE PLAYER SCORE
         LDX     A,X              ;  .    .    PLAYER #1 OR #2 ?
         LDD     MIN_SCR,U        ;  .    .   
         JSR     SCRADD           ;  .    .
;
         INC     FIRSND           ;  .    SET 'FIRE-BALL' SOUND
;
         LDA     MIN_YW,U         ;  .    SET SMALL EXPLOSION
         LDB     MIN_XW,U         ;  .    .    SET POSITION
         TFR     D,X              ;  .    .    .
         LDA     MIN_SIZ,U        ;  .    .    SET STARTING SIZE
         LDB     #$20             ;  .    .    SET MAXIMUM SIZE
         JSR     SETEXP           ;  .    .    .
;
         LDD     #$0110           ;  .    CHANGE SCORE VALUE FOR FIRE-BALL
         STD     MIN_SCR,U        ;  .    .
;
         LDA     <WSHIPY          ;  .    CALCULATE DELTA YX VALUES
         SUBA    MIN_YW,U         ;  .    .
         LDB     <WSHIPX          ;  .    .
         SUBB    MIN_XW,U         ;  .    .
;
         JSR     CMPASS           ;  .    CALCULATE ANGLE TO SHIP
         SUBA    #$10             ;  .    .
         TFR     A,B              ;  .    .
;
         PSHS    Y                ;  .    CALCULATE NEW DISPLACEMENTS
         LDA     #$3F             ;  .    .    SET FIRE-BALL SPEED
         JSR     MLTY8            ;  .    .    FETCH NEW DISPLACEMENTS
;
         STY     MIN_YD,U         ;  .    .    SAVE NEW 'Y' DISPLACEMENT
         STX     MIN_XD,U         ;  .    .    SAVE NEW 'X' DISPLACEMENT
         PULS    Y                ;  .    .
;
         CLR     BLT_FLG,Y        ;  .    RESET BULLET FLAG
;
         LDD     #$0404           ;  .    SET NEW COLLISION BOX
         STD     MIN_BOX,U        ;  .    .
;
         LDA     MIN_PAK,U        ;  .    GROW 2 NEW MINES
         LDB     MIN_BSZ,U        ;  .    .
         DECB                     ;  .    .
         BEQ     CBUL60           ;  .    .
         JSR     RANSEED          ;  .    .
         JSR     RANSEED          ;  .    .
;
CBUL60   LDA     #$04             ;  .    SET FIRE-BALL FLAG
         STA     MIN_PAK,U        ;  .    .
;
         DEC     <CBULLET         ;  .    DECREMENT ACTIVE BULLET COUNT
         JMP     CBUL2            ;  .    TRY NEXT BULLET FOR COLLISION
;
;
CBUL7    LDA     #$01             ;  'DUMB' OR 'MAGNETIC' MINE COLLISION
         STA     MIN_FLG,U        ;  .    FLAG MINE FOR EXPLOSION
         CLR     BLT_FLG,Y        ;  .    RESET BULLET
;
         LDX     #SCRPTR          ;  .    ADD MINE TO ACTIVE PLAYER SCORE
         LDA     <ACTPLY          ;  .    .    PLAYER #1 OR #2 ?
         LDX     A,X              ;  .    .    .
         LDD     MIN_SCR,U        ;  ADD MINE TO SCORE
         JSR     SCRADD           ;  .
;
         LDA     MIN_YW,U         ;  ENTER COLLISION IN EXPLOSION TABLE
         LDB     MIN_XW,U         ;  .    SET EXPLOSION CENTRE
         TFR     D,X              ;  .    .
         LDA     MIN_SIZ,U        ;  .    SET EXPLOSION STARTING SIZE
         LDB     #$40             ;  .    SET EXPLOSION MAXIMUM SIZE
         JSR     SETEXP           ;  .    SET EXPLOSION IN TABLE
;
         DEC     <CMINES          ;  .    DECREMENT ACTIVE MINE COUNT
         DEC     <CBULLET         ;  .    DECREMENT ACTIVE BULLET COUNT
CBUL9    JMP     CBUL2            ;  .    TRY NEXT BULLET FOR COLLISION
;
;
;  HANDLE MINE VS_ SHIP COLLISIONS
;  ===============================
;
         direct   $C8
;        =====   ===
;
CMINSHIP LDA     <ABORT           ;  GAME ABORTED ?
         BNE     CMIN3            ;  .    SKIP COLLISION DETECTION
;
         LDA     <HYPFLAG         ;  .    HYPER-SPACE SEQUENCE ?
         BNE     CMIN3            ;  .    .
;:
         LDY     #MIN_TBL         ;  FIND MINE TO COMPARE WITH
         LDA     #MINES           ;  .
         STA     <TEMP1           ;  .
;
CMIN1    LDA     MIN_FLG,Y        ;  .    MINE ACTIVE ?
         ANDA    #$3F             ;  .    .
         BNE     CMIN4            ;  .    .
;
CMIN2    LEAY    MIN_LEN,Y        ;  .    BUMP TO NEXT ENTRY
         DEC     <TEMP1           ;  .    .    END OF TABLE ?
         BNE     CMIN1            ;  .    .    .
CMIN3    RTS                      ;  .    RETURN - NO ACTIVE MINE
;
CMIN4    PSHS    Y                ;  FINE COLLISION TEST
         LDA     <WSHIPY          ;  .    FETCH SHIP POSITION
         LDB     <WSHIPX          ;  .    .
         TFR     D,X              ;  .    .
         LDA     MIN_YW,Y         ;  .    FETCH MINE POSITION
         LDB     MIN_XW,Y         ;  .    .
         LDY     MIN_BOX,Y        ;  .    FETCH MINE BOX SIZE
         EXG     Y,D              ;  .    .
         JSR     BXTEST           ;  .    DO BOX TEST
         PULS    Y                ;  .    .    FAILED COLLISION ?
         BCC     CMIN2            ;  .    .    .
;
         CLR     MIN_FLG,Y        ;  COLLISION DETECTED - RESET CONDITIONS
         CLR     <MINMAX          ;  .    RESET TOTAL MINE COUNT
;
         LDA     <WSHIPY          ;  ENTER COLLISION IN EXPLOSION TABLE
         LDB     <WSHIPX          ;  .    SET EXPLOSION CENTRE
         TFR     D,X              ;  .    .
         LDA     MIN_SIZ,Y        ;  .    SET STARTING EXPLOSION SIZE
         ORA     #$80             ;  .    .    FATAL HIT TO SWEEPER
         LDB     #$30             ;  .    SET EXPLOSION SIZE
         JSR     SETEXP           ;  .    SET EXPLOSION IN TABLE
;
         INC     EXPLSND          ;  SET EXPLOSION SOUND FLAG
;
         DEC     <CMINES          ;  DECREMENT ACTIVE MINE COUNT
         BRA     CMIN3            ;  TRY NEXT MINE ENTRY
;
;
;  HANDLE SHIP VS_ MINE-LAYER COLLISION
;  ====================================
;
         direct   $C8
;        =====   ===
;
CSHPLYR  LDA     <ABORT           ;  GAME ABORTED ?
         BNE     CSHP0            ;  .    SKIP COLLISION DETECTION
;
         LDA     <HYPFLAG         ;  .    HYPER-SPACE SEQUENCE ?
         BNE     CSHP0            ;  .    .
;
         LDA     <LAYRSPD         ;  MINE-LAYER OFF-SCREEN ?
         BEQ     CSHP0            ;  .    IF SO, SKIP COLLISION DETECTION
;
         LDA     <WSHIPY          ;  PERFORM FINE BOX TEST
         LDB     <WSHIPX          ;  .    FETCH SHIP POSITION
         TFR     D,X              ;  .    .
         LDD     #P_LYRBX         ;  .    FETCH MINE-LAYER COLLISION BOX
         LDY     <LAYRYX          ;  .    FETCH MINE-LAYER POSITION
         JSR     BXTEST           ;  .    DO BOX TEST
         BCS     CSHP1            ;  .    .    PASS COLLISION TEST ?
CSHP0    RTS                      ;  .    .    .    NO COLLISION - RETURN
;
CSHP1    CLR     <LAYRSPD         ;  COLLISION DETECTED - RESET MINE-LAYER
         CLR     <TMR3            ;  .
;
         LDA     <WSHIPY          ;  ENTER COLLISION IN EXPLOSION TABLE
         LDB     <WSHIPX          ;  .    SET EXPLOSION CENTRE
         TFR     D,X              ;  .    .
         LDA     #P_LYRSZ         ;  .    SET STARTING EXPLOSION SIZE
         ORA     #$80             ;  .    .    FATAL TO SWEEPER
         LDB     #$30             ;  .    SET EXPLOSION SIZE
         JSR     SETEXP           ;  .    SET EXPLOSION IN TABLE
;
         INC     EXPLSND          ;  SET EXPLOSION SOUND FLAG
;
         RTS                      ;  RETURN TO CALLER
;
;   
;
;  SOUND HANDLER
;  =============
;
         direct   $D0
;        =====   ===
;
SOUND    LDA     THRSND           ;  THRUSTER SOUND ?
         BEQ     SND1             ;  .
;
         CLR     THRSND           ;  .    RESET THRUSTER SOUND FLAG
         LDU     #SS_THR          ;  .    SET THRUSTER SOUND
         BRA     SND10            ;  .    .
;
SND1     LDA     EXPLSND          ;  EXPLOSION SOUND ?
         BEQ     SND2             ;  .
;
         CLR     EXPLSND          ;  .    RESET EXPLOSION SOUND FLAG
         LDU     #SS_EXP          ;  .    SET EXPLOSION SOUND
         BRA     SND10            ;  .    .
;
SND2     LDA     BLTSND           ;  BULLET SOUND ?
         BEQ     SND3             ;  .
;
         CLR     BLTSND           ;  .    RESET BULLET SOUND FLAG
         LDU     #SS_BLT          ;  .    SET BULLET SOUND
         BRA     SND10            ;  .    .
;
SND3     LDA     POPSND           ;  MINE-SEED 'POP' SOUND ?
         BEQ     SND31            ;  .
;
SND32    CLR     POPSND           ;  .    RESET 'POP' SOUND FLAG
         CLR     HYPSND           ;  .    RESET 'HYPER-SPACE' SOUND FLAG
         LDU     #SS_POP          ;  .    SET 'POP' SOUND
         BRA     SND10            ;  .    .
;
SND31    LDA     HYPSND           ;  HYPER-SPACE SOUND ?
         BNE     SND32            ;  .
;
         BRA     SND18            ;  UPDATE SOUND
;
;
SND10    JSR     PSGLST           ;  UPDATE PSG
;
SND18    LDB     REG0             ;  SLIDE TONE 'A' FREQUENCY
         ADDB    #$10             ;  .
         CMPB    #$A0             ;  .
         BHS     STTNA            ;  .
         LDA     #00              ;  .
         JSR     WRREG            ;  .
         BRA     CKTNB            ;  .
;
STTNA    LDD     #$0800           ;  .    SET 'A' AMPLITUDE = $00
         JSR     WRREG            ;  .    .
;
CKTNB    LDB     REG2             ;  SLIDE TONE 'B' FREQUENCY
         ADDB    #$20             ;  .
         CMPB    #$F0             ;  .
         BHS     STTNB            ;  .
         LDA     #$02             ;  .
         JSR     WRREG            ;  .
         BRA     RUSND            ;  .
;
STTNB    LDD     #$0900           ;  .    SET 'B' AMPLITUDE = $00
         JSR     WRREG            ;  .    .
;
RUSND    RTS                      ;  RETURN TO CALLER
;     
;
;        SOUND LIBRARY
;        -------------
;
;
SS_THR   DW      $0010            ;  THRUSTER SOUND
         DW      $0100            ;  .
         DW      $061F            ;  .
         DW      $0706            ;  .
         DW      $080F            ;  .
         DB      $FF              ;  .    TERMINATOR
;
;
SS_BLT   DW      $0239            ;  BULLET SOUND
         DW      $0300            ;  .
         DW      $061F            ;  .
         DW      $0705            ;  .
         DW      $090F            ;  .
         DB      $FF              ;  .    TERMINATOR
;
;
SS_EXP   DW      $061F            ;  OJECT EXPLOSION SOUND
         DW      $0707            ;  .
         DW      $0A10            ;  .
         DW      $0B00            ;  .
         DW      $0C38            ;  .
         DW      $0D00            ;  .
         DB      $FF              ;  .    TERMINATOR
;
;
SS_POP   DW      $0000            ;  MINE 'POP' SOUND
         DW      $0100            ;  .
         DW      $0230            ;  .
         DW      $0300            ;  .
         DW      $0400            ;  .
         DW      $0500            ;  .
         DW      $061F            ;  .
         DW      $073D            ;  .
         DW      $0800            ;  .
         DW      $090F            ;  .
         DW      $0A00            ;  .
         DW      $0B00            ;  .
         DW      $0C00            ;  .
         DW      $0D00            ;  .
         DB      $FF              ;  .    TERMINATOR
;
;
;       LAYER TUNE
;       ----------
;
;
QSC      EQU     50
SC8      EQU     25
;
G2       EQU     $00
GS2      EQU     $01
CS3      EQU     $06
C3       EQU     $05
;
LAYTUNE  DW      FADE66
         DW      VIBENL
         DB      G2,SC8
         DB      GS2,SC8
         DB      G2,SC8
         DB      GS2,QSC
         DB      G2,SC8
         DB      GS2,SC8 
         DB      G2,SC8
         DB      CS3,SC8
         DB      C3,SC8
         DB      G2,$80
;
;
FADE66   DW      $FFEE,$DDCC,$BBAA,$9988,$7777
         DW      $7777,$7777,$7777
;
;
;
SCRPTR   DW      SCOR1            ;  POINTERS TO PLAYER SCORES
         DW      SCOR2            ;  .
;
PSCRPTR  DW      PSCOR1           ;  SCREEN POSITIONS OF PLAYER SCORES
         DW      PSCOR2           ;  .
;
PMNLVL   DW      MNLVL1           ;  POINTERS TO PLAYERS MINE-LEVEL MESSAGES
         DW      MNLVL2           ;  .
;
;==========================================================================JJH
;                                   =======================================JJH
;  GAME SEQUENCE PARAMETER TABLES   ==  DELETED - REV. C CHANGES  =========JJH
;  ==============================   =======================================JJH
;                                                                    ======JJH
;        LEVEL #1 PARAMETER TABLES                                   ======JJH
;        -------------------------                                   ======JJH
;                                                                    ======JJH
;MINTBL1 DB      M_DUMB           ;  MINE TYPE TABLE                 ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #2 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL2 DB      M_FIRE           ;  MINE TYPE TABLE                 ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #3 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL3 DB      M_MAG            ;  MINE TYPE TABLE                 ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #4 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL4 DB      M_MFIRE          ;  MINE TYPE TABLE                 ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #5 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL5 DB      M_FIRE           ;  MINE TYPE TABLE                 ======JJH
;        DB      M_MAG            ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #6 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL6 DB      M_FIRE           ;  MINE TYPE TABLE                 ======JJH
;        DB      M_MFIRE          ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #7 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL7 DB      M_MAG            ;  MINE TYPE TABLE                 ======JJH
;        DB      M_MFIRE          ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #8 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL8 DB      M_FIRE           ;  MINE TYPE TABLE                 ======JJH
;        DB      M_FIRE           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #9 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL9 DB      M_MAG            ;  MINE TYPE TABLE                 ======JJH
;        DB      M_MAG            ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #10 PARAMETER TABLE                                   ======JJH
;        -------------------------                                   ======JJH
;                                                                    ======JJH
;MINTBL10DB      M_MFIRE          ;  MINE TYPE TABLE                 ======JJH
;        DB      M_MFIRE          ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #11 PARAMETER TABLE                                   ======JJH
;        -------------------------                                   ======JJH
;                                                                    ======JJH
;MINTBL11DB      M_FIRE           ;  MINE TYPE TABLE                 ======JJH
;        DB      M_FIRE           ;  .                               ======JJH
;        DB      M_FIRE           ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #12 PARAMETER TABLE                                   ======JJH
;        -------------------------                                   ======JJH
;                                                                    ======JJH
;MINTBL12DB      M_MAG            ;  MINE TYPE TABLE                 ======JJH
;        DB      M_MAG            ;  .                               ======JJH
;        DB      M_MAG            ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #13 PARAMETER TABLE                                   ======JJH
;        -------------------------                                   ======JJH
;                                                                    ======JJH
;MINTBL13DB      M_MFIRE          ;  MINE TYPE TABLE                 ======JJH
;        DB      M_MFIRE          ;  .                               ======JJH
;        DB      M_MFIRE          ;  .                               ======JJH
;        DB      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        DB      $80              ;  LEVEL PARAMETER TABLE TERMINATOR======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         direct   $C8              ;  CODE ADDED - REV. C CHANGES     ======JJH
;        =====   ===                                                 ======JJH
;                                                                    ======JJH
REVC_0   LDA     #$0C             ;  .    LAST GAME SEQUENCE ?       ======JJH
         SUBA    0,X              ;  .    .                          ======JJH
         SUBA    1,X              ;  .    .                          ======JJH
         SUBA    2,X              ;  .    .                          ======JJH
         SUBA    3,X              ;  .    .                          ======JJH
         BEQ     REVC_09          ;  .    .                          ======JJH
;                                                                    ======JJH
         LDB     0,X              ;  .    INCREMENT MINE #1 TYPE     ======JJH
         ADDB    #$FD             ;  .    .                          ======JJH
         ANDB    #$03             ;  .    .                          ======JJH
         STB     0,X              ;  .    .                          ======JJH
;                                                                    ======JJH
         LDB     #$FC             ;  .    INCREMENT MINE #2 TYPE     ======JJH
         ADCB    1,X              ;  .    .                          ======JJH
         ANDB    #$03             ;  .    .                          ======JJH
         STB     1,X              ;  .    .                          ======JJH
;                                                                    ======JJH
         LDB     #$FC             ;  .    INCREMENT MINE #3 TYPE     ======JJH
         ADCB    2,X              ;  .    .                          ======JJH
         ANDB    #$03             ;  .    .                          ======JJH
         STB     2,X              ;  .    .                          ======JJH
;                                                                    ======JJH
         LDB     #$FC             ;  .    INCREMENT MINE #4 TYPE     ======JJH
         ADCB    3,X              ;  .    .                          ======JJH
         ANDB    #$03             ;  .    .                          ======JJH
         STB     3,X              ;  .    .                          ======JJH
;                                                                    ======JJH
REVC_09  RTS                      ;  .    RETURN TO CALLER           ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         DS      8                ;  CODE ADDED - REV. C CHANGES     ======JJH
;==========================================================================JJH
;
;
;
;  STAR-FIELD TABLES
;  =================
;
;
STAR_1   DB      $C8,$40          ;  STAR FIELD #1
         DB      $3F,$00          ;  .
         DB      $20,$80          ;  .
         DB      $10,$1F          ;  .
;
STAR_2   DB      $3F,$3F          ;  STAR FIELD #2
         DB      $00,$BF          ;  .
         DB      $BF,$BF          ;  .
         DB      $C0,$20          ;  .
;
STAR_3   DB      $48,$08          ;  STAR FIELD #3
         DB      $F8,$30          ;  .
         DB      $A8,$10          ;  .
         DB      $D0,$A0          ;  .
;
STAR_4   DB      $BF,$BF          ;  STAR FIELD #4
         DB      $00,$3F          ;  .
         DB      $3F,$48          ;  .
         DB      $20,$80          ;  .
;
STAR_5   DB      $00,$B0          ;  STAR FIELD #5
         DB      $48,$38          ;  .
         DB      $FB,$38          ;  .
         DB      $80,$28          ;  .
;
STAR_6   DB      $30,$48          ;  STAR FIELD #6
         DB      $80,$80          ;  .
         DB      $45,$F0          ;  .
         DB      $28,$7F          ;  .
;
STAR_7   DB      $3F,$BF          ;  STAR FIELD #7
         DB      $A5,$00          ;  .
         DB      $D0,$60          ;  .
         DB      $20,$28          ;  .
;
STAR_8   DB      $B8,$40          ;  STAR FIELD #8
         DB      $15,$80          ;  .
         DB      $40,$F8          ;  .
         DB      $40,$18          ;  .
;
;
;  RASTER MESSAGES
;  ===============
;
;
M_MNFLD  DW      $FA38
         DW      $E0C0
         DB      "MINE FIELD",$80
;
M_END    DW      $FA38
         DW      $E0D8
         DB      "GAME OVER",$80
;
;
;
;
;  MINES
;  =====
;
;
MINE1    DB      $00,$10,$00      ;  'DUMB' MINE
         DB      $FF,$20,$A0      ;  .
         DB      $FF,$C0,$40      ;  .
         DB      $FF,$90,$20      ;  .
         DB      $FF,$70,$20      ;  .
         DB      $FF,$50,$50      ;  .
         DB      $FF,$D0,$90      ;  .
         DB      $01              ;  .    PACKET TERMINATOR
;
MINE2    DB      $00,$20,$00      ;  'MAGNETIC' MINE
         DB      $FF,$30,$B0      ;  .
         DB      $FF,$B0,$30      ;  .
         DB      $FF,$B0,$D0      ;  .
         DB      $FF,$30,$50      ;  .
         DB      $FF,$D0,$50      ;  .
         DB      $FF,$50,$D0      ;  .
         DB      $FF,$50,$30      ;  .
         DB      $FF,$D0,$B0      ;  .
         DB      $01              ;  .    PACKET TERMINATOR
;
MINE3    DB      $FF,$00,$00      ;  'DUMB FIRE-BALL' MINE
         DB      $00,$30,$00      ;  .
         DB      $FF,$10,$C0      ;  .
         DB      $FF,$C0,$10      ;  .
         DB      $FF,$C0,$F0      ;  .
         DB      $FF,$10,$40      ;  .
         DB      $FF,$F0,$40      ;  .
         DB      $FF,$40,$F0      ;  .
         DB      $FF,$40,$10      ;  .
         DB      $FF,$F0,$C0      ;  .
         DB      $01              ;  .    PACKET TERMINATOR
;
MINE4    DB      $FF,$00,$00      ;  'MAGNETIC FIRE-BALL' MINE
         DB      $00,$F0,$D0      ;  .
         DB      $FF,$C0,$40      ;  .
         DB      $FF,$20,$00      ;  .
         DB      $FF,$40,$40      ;  .
         DB      $FF,$00,$E0      ;  .
         DB      $FF,$40,$C0      ;  .
         DB      $FF,$E0,$00      ;  .
         DB      $FF,$C0,$C0      ;  .
         DB      $FF,$00,$20      ;  .
         DB      $01              ;  .    PACKET TERMINATOR
;
MINE5    DB      $00,$3F,$00      ;  'RELEASED FIRE-BALL' MINE
         DB      $FF,$80,$00      ;  .
         DB      $00,$3F,$3F      ;  .
         DB      $FF,$00,$80      ;  .
         DB      $01              ;  .    PACKET TERMINATOR
;
;
;  EXPLOSION CLOUD
;  ===============
;
;
EXPLODE  DB      $FF,$7F,$20
         DB      $00,$C0,$10
         DB      $FF,$C0,$D0
         DB      $FF,$20,$7F
         DB      $00,$E0,$C0
         DB      $FF,$00,$C0
         DB      $FF,$E0,$30
         DB      $00,$C0,$00
         DB      $FF,$60,$CD
         DB      $FF,$A0,$00
         DB      $00,$20,$D0
         DB      $FF,$3C,$30
         DB      $FF,$00,$82
         DB      $00,$30,$30
         DB      $FF,$D0,$50
         DB      $FF,$20,$F0
         DB      $01
;
;
;  STAR-SWEEPER SHIP
;  =================
;
;
NSHIP    DB      $00,$3F,$00      ;  ANOTHER NEW SHIP
         DB      $FF,$C4,$08      ;  .
         DB      $FF,$D8,$D8      ;  .
         DB      $FF,$20,$00      ;  .
         DB      $00,$00,$40      ;  .
         DB      $FF,$E0,$00      ;  .
         DB      $FF,$28,$D8      ;  .
         DB      $FF,$3C,$08      ;  .
         DB      $01              ;  .
;
;
;        SHIP PACKETS FOR EXPLOSION
;        --------------------------
;
SHPEX1   DB      $00,$3F,$00
         DB      $FF,$C4,$08
         DB      $01
;
SHPEX2   DB      $00,$04,$08
         DB      $FF,$D8,$D8
         DB      $FF,$20,$00
         DB      $01
;
SHPEX3   DB      $00,$3F,$00
         DB      $FF,$C4,$F8
         DB      $01
;
SHPEX4   DB      $00,$04,$F8
         DB      $FF,$D8,$28
         DB      $FF,$20,$00
         DB      $01
;
;
;  MINE-LAYER
;  ==========
;
;
LLAYR    DB      $00,$20,$00      ;  LEFT PORTION OF MINE-LAYER
         DB      $FF,$00,$D8      ;  .
         DB      $FF,$D0,$A8      ;  .
         DB      $FF,$F0,$40      ;  .
         DB      $FF,$08,$18      ;  .
         DB      $FF,$18,$F0      ;  .
         DB      $FF,$F0,$B8      ;  .
         DB      $00,$10,$48      ;  .
         DB      $FF,$08,$00      ;  .
         DB      $FF,$E8,$10      ;  .
         DB      $FF,$F8,$00      ;  .
         DB      $00,$08,$00      ;  .
         DB      $FF,$00,$06      ;  .
         DB      $00,$10,$FA      ;  .
         DB      $FF,$08,$00      ;  .
         DB      $FF,$00,$F0      ;  .
         DB      $00,$10,$18      ;  .
         DB      $FF,$F0,$08      ;  .
         DB      $01              ;  .    PACKET TERMINATOR
;
RLAYR    DB      $00,$20,$00      ;  RIGHT PORTION OF MINE-LAYER
         DB      $FF,$00,$28      ;  .
         DB      $FF,$D0,$58      ;  .
         DB      $FF,$F0,$C0      ;  .
         DB      $FF,$08,$E8      ;  .
         DB      $FF,$18,$10      ;  .
         DB      $FF,$F0,$48      ;  .
         DB      $00,$10,$B8      ;  .
         DB      $FF,$08,$00      ;  .
         DB      $FF,$E8,$F0      ;  .
         DB      $FF,$F8,$00      ;  .
         DB      $FF,$08,$00      ;  .
         DB      $FF,$00,$FA      ;  .
         DB      $00,$10,$06      ;  .
         DB      $FF,$08,$00      ;  .
         DB      $FF,$00,$10      ;  .
         DB      $00,$10,$E8      ;  .
         DB      $FF,$F0,$F8      ;  .
         DB      $01              ;  .    PACKET TERMINATOR
;
MLAYR    DB      $FF,$00,$D8      ;  MID-SECTION OF MINE-LAYER
         DB      $FF,$E8,$08      ;  .
         DB      $FF,$00,$40      ;  .
         DB      $FF,$18,$08      ;  .
         DB      $FF,$00,$D8      ;  .
         DB      $00,$08,$E0      ;  .
         DB      $FF,$10,$00      ;  .
         DB      $FF,$00,$40      ;  .
         DB      $FF,$F0,$00      ;  .
         DB      $FF,$00,$C0      ;  .
         DB      $01              ;  .    PACKET TERMINATOR
;
LAYER    DB      $00,$18,$00      ;  LOW RESOLUTION MINE-LAYER PACKET
         DB      $FF,$00,$20      ;  .
         DB      $FF,$C8,$70      ;  .
         DB      $FF,$10,$A0      ;  .
         DB      $FF,$00,$A0      ;  .
         DB      $FF,$EC,$A4      ;  .
         DB      $FF,$39,$6D      ;  .
         DB      $FF,$00,$20      ;  .
         DB      $01              ;  .    PACKET TERMINATOR
;
;
;==========================================================================JJH
;                                                                    ======JJH
         direct   $00              ;  CODE ADDED - REV. B CHANGES     ======JJH
;        =====   ===                                                 ======JJH
;                                                                    ======JJH
REVB_0   CLR     FRAME - 1        ;  .    CLEAR HOUSE FOR RESTART    ======JJH
         CLR     FRAME            ;  .    .                          ======JJH
         CLR     LEG              ;  .    .                          ======JJH
         JMP     COLD0            ;  .    .    RESTART VECTREX       ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         direct   $D0              ;  CODE ADDED - REV. C CHANGES     ======JJH
;        =====   ===                                                 ======JJH
;                                                                    ======JJH
REVC_1   LDA     SHIPCNT          ;  .    LIMIT NUMBER OF MARKERS    ======JJH
         BEQ     REVC_19          ;  .    .    SKIP DISPLAY ?        ======JJH
;                                                                    ======JJH
         CMPA    #$08             ;  .    .                          ======JJH
         BLE     REVC_11          ;  .    .                          ======JJH
         LDA     #$08             ;  .    .                          ======JJH
REVC_11  STA     TEMP1            ;  .    .                          ======JJH
;                                                                    ======JJH
REVC_19  RTS                      ;  .    RETURN TO CALLER           ======JJH
;==========================================================================JJH
;
;
         END