; taken from RUM 
                    bss      
                    ORG      0xC800                       ;RAM 
REG0                DS       1                            ;MIRROR SOUND CHIP REGS FINE TUNE -A- 8 BIT 
REG1                DS       1                            ;COARSE TUNE -A- 4 BIT 
REG2                DS       1                            ;FINE TUNE -B- 8 BIT 
REG3                DS       1                            ;COARSE TUNE -B- 4 BIT 
REG4                DS       1                            ;FINE TUNE -C- 
REG5                DS       1                            ;COARSE TUNE -C- 
REG6                DS       1                            ;NOISE PER, 5 BIT 
REG7                DS       1                            ;ENABLE BAR- IN BAR/OUT: IOB,IOA 
;                                  ;NOISE BAR: C,B,A TONE BAR: C,B,A
REG8                DS       1                            ;AMPL -A-, 4 BIT, 5TH BIT OVERRIDE IF=1 
REG9                DS       1                            ;AMPLITUDE -B- " " 
REGA                DS       1                            ;AMPL -C- 
REGB                DS       1                            ;FINE TUNE ENVELOPE PER, 8 BITS 
REGC                DS       1                            ;COARSE TUNE ENVELOPE PER, 8 BIT 
REGD                DS       1                            ;ENVELOPE TYPE, 4 BIT- CONT,ATT,ALT,HOLD 
REGE                DS       1                            ;PORT A I/O 
;
;
TRIGGR              DS       2                            ;BUTTONS INPUT TO PSG- NEW, LAST 
HEDGES              DS       1                            ;POS EDGE, 1 BIT PER BUTTON 
KEY0                DS       1                            ;POS EDGE, 1 BYTE PER BUTTON, POS LOG 
KEY1                DS       1 
KEY2                DS       1 
KEY3                DS       1 
KEY4                DS       1 
KEY5                DS       1 
KEY6                DS       1 
KEY7                DS       1 
;
POTRES              DS       1                            ;ACCURACY REQ D FOR POT READ, LESS IS FASTER 
                                                          ;$40=1 BIT,$20=2 BITS,$01=7 BITS,$00=8 BITS 
POT0                DS       1                            ;VALUE READ FROM POTS 
POT1                DS       1 
POT2                DS       1 
POT3                DS       1 
DPOT0               DS       1                            ;DELTA FROM LAST TEST 
DPOT1               DS       1 
DPOT2               DS       1 
DPOT3               DS       1 
;
LIST                DS       1                            ;# OF VECTORS IN PRESENT CHART 
ZGO                 DS       1                            ;IF NONZERO, CAUSES 'ZEROIT' CALL AFTER VECTOR ROUTINES 
; "FRAME" must be the low counter...
FRAME_hi            DS       1                            ;INCRS EVERY TIME FRAM20 OR FRAM30 CALLED 
FRAME               DS       0                            ;INCRS EVERY TIME FRAM20 OR FRAM30 CALLED 
FRAME_lo            DS       1                            ;INCRS EVERY TIME FRAM20 OR FRAM30 CALLED 
TENSTY              DS       1                            ;WAST INTENSITY WEVEL 
;
DWELL               DS       1                            ;DOT DWELL TIME, SET IN INITMSC OR AFTER 
DASH                DS       1                            ;PATTERN FOR DASHED VECTORS 
;
;
SIZRAS              DS       2                            ;FOR RASTER - CONTROLS SLEW RATE 
                                                          ;SIZE,SIZE+1=Y RATE,X RATE 
MESAGE              DS       2                            ;START OF STRING 
;
;
X0                  DS       1 
X1                  DS       1                            ;INTERVAL TIMERS 
X2                  DS       1                            ;COUNT DOWN TO 0 PER FRAME IF 'DEKR' CALLED 
X3                  DS       1 
X4                  DS       1 
X5                  DS       1 
;
ABSY                DS       1                            ;FOR COMPAS ROUTINE 
ABSX                DS       1                            ;" 
ANGLE               DS       1                            ;" 
SINE                DS       2                            ;VALUE,OVERFLOW 
COSINE              DS       2 
LEG                 DS       1 
LAG                 DS       1 
;
XMSEC               DS       2                            ;REFRESH VALUE, INITMSC SETS TO MSEC20 
;
MSEC20              EQU      0x3075                       ;LO BYTE, HI 
MSEC25              EQU      0x7C92 
MSEC30              EQU      0xC8AF 
;
; -   - - REGS FOR TUNE PLAYING AND SOUND EFFECTS - - - - -
;
REQ0                DS       1                            ;ENVELOPE TYPE - FOR REQOUT ROUTINE 
REQ1                DS       1                            ;TUNE ENVELOPE- MSB (INVERTED ORDER OF REG0-D) 
REQ2                DS       1                            ; " " LSB 
REQ3                DS       1                            ;LEVEL- C 
REQ4                DS       1                            ;LEVEL- B 
REQ5                DS       1                            ;LEVEL- A 
REQ6                DS       1                            ;ENABLES- TONES / NOISE / I-O 
REQ7                DS       1                            ;TUNE NOISE - 5 BIT 
REQ8                DS       1                            ;TUNE C- MSB 
REQ9                DS       1                            ; " " LSB 
REQA                DS       1                            ;TUNE B- MSB 
REQB                DS       1                            ; " " LSB 
REQC                DS       1                            ;TUNE A- MSB 
REQD                DS       1                            ; " " LSB 
;
CHCF                EQU      REQ8                         ;CHANNEL C FREQUENCY 
CHBF                EQU      REQA 
CHAF                EQU      REQC 
NOISEF              EQU      REQ7                         ;NOISE FREQ 
ENVELF              EQU      REQ1                         ;ENVELOPE FREQ 
;
CHCV                EQU      REQ3                         ;CHANNEL C VOLUME 
CHBV                EQU      REQ4 
CHAV                EQU      REQ5 
;
SENABL              EQU      REQ6                         ;SOUND ENABLE 
;
DOREMI              DS       2                            ;BASE TABLE FOR NOTES USUALLY=NOTES 
FADE                DS       2                            ;FOR TUNE PLAYER USE 
VIBE                DS       2 
TUNE                DS       2 
NEWGEN              DS       1 
TSTAT               DS       1 
RESTC               DS       1 
RATEA               DS       1 
VIBA                DS       1 
RATEB               DS       1                            ;VIBRATO 
VIBB                DS       1 
RATEC               DS       1 
VIBC                DS       1 
FADEA               DS       1 
FADEB               DS       1 
FADEC               DS       1 
TONEA               DS       2                            ;FREQ BEFORE VIBE 
TONEB               DS       2 
TONEC               DS       2 
;
; - - - - - REGS FOR SOUND EFFECTS - - - - -
;
SATUS               DS       1                            ;GAME-SOUNDS INTERFACE 
LATUS               DS       1                            ;LAST 'SATUS' VALUE 
XATUS               DS       1                            ; ", EXPLOSION TYPE 
GAP                 DS       1                            ;TIMES HOLD IN BACKGROUND SOUND 
B1FREQ              DS       2                            ; 
B2FREQ              DS       2 
F1FREQ              DS       2 
FEAST               DS       1                            ;FIRING STATE COUNTER 
PEDGE               DS       1                            ;POSITIVE EDGE OF 'SATUS' 
NEDGE               DS       1                            ;NEGATIVE EDGE OF 'SATUS' 
K1FREQ              DS       2                            ;BACKGROUND FREQ 1 
BACON               DS       1                            ;" SEQUENCER 
XACON               DS       1                            ;EXPLO SEQ 
SPEKT               DS       1                            ;EXPL SPECTR 
;
PLAYRZ              DS       1                            ;# PLAYERS IN GAME 
GAMZ                DS       1                            ;GAME # OPTION 
;
SEED                DS       2                            ;POINTER TO 3 BYTE RANDOM #, USUALLY IS RANCID 
RANCID              DS       3 
;
;
LASRAM              EQU      * 
;
;
RAMMES              EQU      0xCA00 
;
                    bss      
                    ORG      0xCBEA 
;
STACK               DS       1 
HEIGH               DS       7                            ;TITLE PAGE HIGH SCORE 
INMI 
ISWI3 
ISWI2               DS       3 
IFIRQ               DS       3 
IIRQ                DS       3 
ISWI                DS       3 
JRES                DS       2 
;
                    bss      
                    ORG      0xD000                       ;I/O 
;
BPORT               DS       1 
APORT               DS       1 
BPORTD              DS       1 
APORTD              DS       1 
T1LOLC              DS       1 
T1HOC               DS       1 
T1LOL               DS       1 
T1HOL               DS       1 
T2LOLC              DS       1 
T2HOC               DS       1 
SR                  DS       1 
ACR                 DS       1 
PPCR                DS       1 
IFR                 DS       1 
IER                 DS       1 
ORAIRA              DS       1 
;
;
DAC                 EQU      APORT                        ;FOR HUMAN INTERFACE 
PORT                EQU      BPORT                        ;MAIN CONTROL PORT 
_2ZERO              EQU      0xCC                         ;CODE TO PCR ZERO INTEGRATORS 
UNZERO              EQU      0xCE                         ;CODE FOR RELEASE ZERO HOLD 
SCAL1X              EQU      0x7F                         ;TIMING PARMAMETERS FOR VECTOR WRITE 
SCAL2X              EQU      0xFF 
CARTS               EQU      0x0                          ;ADDRESS OF EXTERNAL ROM PACK 
ROMS                EQU      0xF000                       ;ADDRESS OF ON-BOARD ROM 
INHOUS              EQU      0xE000 
;
; - - - - - - RESET VECTORS - - - - - - -
;
;                    ORG      0xFFF2 
;                    DW       ISWI3                        ;RAM INDIRECT VECTORS 
;                    DW       ISWI2                        ;NMI AND SWI HANDLED BY -MAID- 
;                    DW       IFIRQ 
;                    DW       IIRQ 
;                    DW       ISWI                         ;NOT IN MAID 
;                    DW       ISWI                         ;NOT IN MAID 
;                    DW       POWER 
