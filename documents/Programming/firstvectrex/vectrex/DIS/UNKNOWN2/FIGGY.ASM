*
*       This assembler is so stupid that it cannot fit numbers
*       between -127 and -1 into 8 bits.  ARGH!
*

DPTOC8  EQU     $F1AF
DPTOD0  EQU     $F1AA
DRAWL1B EQU     $F40E
PRINTU  EQU     $F385
RESET0  EQU     $F354
SWITCH  EQU     $F1B4
WAIRCAL EQU     $F192
XAXTO7F EQU     $F2A9

SW1C1   EQU     0C812H          SWITCH 1, CONSOLE 1
MAG     EQU     0CBF0H          BOOT DISPLAYED SCORE ADDRESS
*                               STUFF RANDOM MAGNIFICATION IN THERE

        ORG     0

        FCC     'g GCE 1776',80H
        FDB     MUSIC,0F850H,030E8H
        FCC     'MUSIC',80H,0

START   CLR     MAG             START WITH SMALLEST BOX
        LDD     #03075H
        STD     0C83DH          SET T2 TIMER FOR 20 MSEC
        JSR     DPTOD0
        STD     8               START T2
LOOP    JSR     WAIRCAL         WAIT FOR END OF CYCLE
        JSR     XAXTO7F         ADJUST BEAM INTENSITY
        LDA     #0CEH
        STA     0CH             GET OUT OF ZERO MODE!
        DEC     MAG             SHRINK BOX ONCE EACH CYCLE
        LDB     MAG
        LDX     #BOX
        JSR     DRAWL1B         XREG POINTS TO DLIST NOW
        JSR     RESET0
        LDU     #CSET
        JSR     PRINTU
        LDA     080H            SELECT EDGE TRIGGER SW 1, CONSOLE 1
        JSR     SWITCH
        LDA     SW1C1
        BEQ     LOOP            IF NO SWITCH, DO NOTHING
        CLR     MAG             RESET SQUARE
        BRA     LOOP

BOXLOC  FCB     0,0
BOX     FCB     0,$E7,$E7       0,-25,-25       CENTER BOX
        FCB     $FF,0,50        -1,0,50
        FCB     $FF,50,0        -1,50,0
        FCB     $FF,0,$CE       -1,0,-50
        FCB     $FF,$CE,0       -1,-50,0
        FCB     1

MUSIC   FDB     0ED8FH,0FEB6H   WE WISH YOU A MERRY CHRISTMAS
        FCB     9,10            WE
        FCB     14,10           WISH
        FCB     14,5            YOU
        FCB     16,5            A
        FCB     14,5            MER-
        FCB     13,5            RY
        FCB     11,10           CHRIST-
        FCB     11,10           MAS
        FCB     11,10           WE
        FCB     16,10           WISH
        FCB     16,5            YOU
        FCB     18,5            A
        FCB     16,5            MER-
        FCB     14,5            RY
        FCB     13,10           CHRIST-
        FCB     9,10            MAS
        FCB     9,10            WE
        FCB     18,10           WISH
        FCB     18,5            YOU
        FCB     19,5            A
        FCB     18,5            MER-
        FCB     16,5            RY
        FCB     14,10           CHRIST-
        FCB     11,10           MAS
        FCB     9,5             AND
        FCB     9,5             A
        FCB     11,10           HAP-
        FCB     16,10           PY
        FCB     13,10           NEW
        FCB     14,20           YEAR
        FCB     0,080H          END OF MUSIC

CSET    FCB     $F8,80,32,$9C   -8,80,32,-100
        FCB     ' !"#$%&',$27,'()*+,-./',080H
        FCB     $F8,80,16,$9C   -8,80,16,-100
        FCB     '0123456789:;<=>?',080H
        FCB     $F8,80,0,$9C    -8,80,0,-100
        FCB     '@ABCDEFGHIJKLMNO',080H
        FCB     $F8,80,$F0,$9C  -8,80,-16,-100
        FCB     'PQRSTUVWXYZ[\]^_',080H
        FCB     $F8,80,$E0,$9C  -8,80,-32,-100
        FCB     '`abcdefghijklmno',080H
        FCB     0

        END
