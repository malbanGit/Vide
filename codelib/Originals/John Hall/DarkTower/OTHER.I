; from minestorm
ISTARS              EQU      $E8E3                        ; in Minestorm! (see: I_STARS) 
CONE                EQU      $EA3E                        ; in Minestorm! (see: CONE) 
MLTY16              EQU      $E7D2                        ; in Minestorm! (see: MLTY16) 
ZSKIP               EQU      $C824                        ; SKIP INTEGRATOR ZEROING AND ACTIVE GROUND 
EPOT0               EQU      $C81F                        ; ENABLE POT READ 
EPOT2               EQU      $C821                        ; . 
HISCOR              EQU      $CBEB                        ; HIGH-SCORE 
SELOPT              EQU      $F7A9                        ; FETCH GAME OPTIONS 
BXTEST              EQU      $F8FF                        ; SYMMETRIC COLLISION TEST 
ZERGND              EQU      $F354                        ; ZERO INTEGRATORS AND SET ACTIVE GROUND 
EXPLOD              =        0xF92E                       ; AXE 
INTREQ              =        0xF533                       ; IREQ Initialize the 'REQZ' area 
FRWAIT              =        0xF192                       ; FRAM20 Wait for frame boundary 
DBNCE               =        0xF1B4                       ; ENPUT Read controller buttones 
JOYBIT              =        0xF1F8                       ; PANG Read joystick 
MCSINE              =        0xF661                       ; RCOSA Multiply 'A' by previous cosine value 
MSINE               =        0xF65B                       ; RSINA Multiply 'A' by previous sine value 
LNROT               =        0xF601                       ; ROTOR Rotate a single line 
SCRADD              =        0xF87C                       ; SADD Add contents of 'B' to indicated score 
HISCR               =        0xF8D8                       ; HIGHSCR Calculate high score and save for logo 
DECBIT              =        0xF57E                       ; BITE Decode bit position 
DROT                =        0xF610                       ; DANROT 'DIFFY' style rotate 
CMPASS              =        0xF593                       ; COMPAS Return angle for given delta 'Y:X' 
WSINE               =        SINE                         ; $c837 
WCSINE              =        COSINE                       ; $c839 
SHIFT               =        SR 
IFLAG               =        IFR 
CNTRL               =        BPORT 
OPTION              =        GAMZ 
FFARE2              =        $FF26                        ; BIOS music 
VIBENL              =        $FEB6 
; Note mapping
G2                  EQU      $00 
GS2                 EQU      $01 
A2                  EQU      $02 
AS2                 EQU      $03 
B2                  EQU      $04 
C3                  EQU      $05 
CS3                 EQU      $06 
D3                  EQU      $07 
DS3                 EQU      $08 
E3                  EQU      $09 
F3                  EQU      $0A 
FS3                 EQU      $0B 
G3                  EQU      $0C 
GS3                 EQU      $0D 
A3                  EQU      $0E 
AS3                 EQU      $0F 
B3                  EQU      $10 
C4                  EQU      $11 
CS4                 EQU      $12 
D4                  EQU      $13 
DS4                 EQU      $14 
E4                  EQU      $15 
F4                  EQU      $16 
FS4                 EQU      $17 
G4                  EQU      $18 
GS4                 EQU      $19 
A4                  EQU      $1A 
AS4                 EQU      $1B 
B4                  EQU      $1C 
C5                  EQU      $1D 
CS5                 EQU      $1E 
D5                  EQU      $1F 
DS5                 EQU      $20 
E5                  EQU      $21 
F5                  EQU      $22 
FS5                 EQU      $23 
G5                  EQU      $24 
GS5                 EQU      $25 
A5                  EQU      $26 
AS5                 EQU      $27 
B5                  EQU      $28 
C6                  EQU      $29 
CS6                 EQU      $2A 
D6                  EQU      $2B 
DS6                 EQU      $2C 
E6                  EQU      $2D 
F6                  EQU      $2E 
FS6                 EQU      $2F 
G6                  EQU      $30 
GS6                 EQU      $31 
A6                  EQU      $32 
AS6                 EQU      $33 
B6                  EQU      $34 
C7                  EQU      $35 
CS7                 EQU      $36 
D7                  EQU      $37 
DS7                 EQU      $38 
E7                  EQU      $39 
F7                  EQU      $3A 
FS7                 EQU      $3B 
G7                  EQU      $3C 
GS7                 EQU      $3D 
A7                  EQU      $3E 
AS7                 EQU      $3F 


; - taken from minestorm
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
                    ORG      $C880 
;                   ===      =====
;
SBTN                DB       0                            ; CONTROLLER DEBOUNCE FLAGS 
SJOY                DW       0                            ; JOYSTICK 'BANG' FLAGS 
;
;
ETMP1               DB       0                            ; TEMPORARY WORKING STORAGE (FIRST LEVEL) 
ETMP2               DB       0                            ; . 
ETMP3               DB       0                            ; . 
ETMP4               DB       0                            ; . 
ETMP5               DB       0                            ; . 
ETMP6               DB       0                            ; . 
ETMP7               DB       0                            ; . 
ETMP8               DB       0                            ; . 
ETMP9               DB       0                            ; . 
ETMP10              DB       0                            ; . 
;
                    DW       0                            ; . WORKING STORAGE SLOP 
;
TEMP1               DB       0                            ; TEMPORARY WORKING STORAGE (SECOND LEVEL) 
TEMP2               DB       0                            ; . 
TEMP3               DB       0                            ; . 
TEMP4               DB       0                            ; . 
TEMP5               DB       0                            ; . 
TEMP6               DB       0                            ; . 
TEMP7               DB       0                            ; . 
TEMP8               DB       0                            ; . 
TEMP9               DB       0                            ; . 
TEMP10              DB       0                            ; . 
;
                    DW       0                            ; . WORKING STORAGE SLOP 
;
;
ACTPLY              DB       0                            ; ACTIVE PLAYER FLAG ($00 / $02) 
;
;
TMR1                DB       0                            ; TIMER #1 - DOWN COUNTER 
                    DW       0                            ; . - TIME-OUT ROUTINE POINTER 
;
TMR2                DB       0                            ; TIMER #2 - DOWN COUNTER 
                    DW       0                            ; . - TIME-OUT ROUTINE POINTER 
;
TMR3                DB       0                            ; TIMER #3 - DOWN COUNTER 
                    DW       0                            ; . - TIME-OUT ROUTINE POINTER 
;
TMR4                DB       0                            ; TIMER #4 - DOWN COUNTER 
                    DW       0                            ; . - TIME-OUT ROUTINE POINTER 