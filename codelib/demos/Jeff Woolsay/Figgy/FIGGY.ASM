; can be assembled correctly now
; compatibilty added by Malban
;
; assenmble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti figgy.asm >error
;
; used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
;
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

SW1C1   EQU     $C812           ;SWITCH 1, CONSOLE 1
MAG     EQU     $CBF0           ;BOOT DISPLAYED SCORE ADDRESS
*                               ;STUFF RANDOM MAGNIFICATION IN THERE

        ORG     0

        DB     'g GCE 1776',$80
        FDB     MUSIC,$F850,$30E8
        DB     'MUSIC',$80,0

START   CLR     MAG             ;START WITH SMALLEST BOX
        LDD     #$3075
        STD     $C83D           ;SET T2 TIMER FOR 20 MSEC
        JSR     DPTOD0
        STD     8               ;START T2
LOOP    JSR     WAIRCAL         ;WAIT FOR END OF CYCLE
        JSR     XAXTO7F         ;ADJUST BEAM INTENSITY
        LDA     #$CE
        STA     $C              ;GET OUT OF ZERO MODE!
        DEC     MAG             ;SHRINK BOX ONCE EACH CYCLE
        LDB     MAG
        LDX     #BOX
        JSR     DRAWL1B         ;XREG POINTS TO DLIST NOW
        JSR     RESET0
        LDU     #CSET
        JSR     PRINTU
        LDA     $80            ;SELECT EDGE TRIGGER SW 1, CONSOLE 1
        JSR     SWITCH
        LDA     SW1C1
        BEQ     LOOP            ;IF NO SWITCH, DO NOTHING
        CLR     MAG             ;RESET SQUARE
        BRA     LOOP

BOXLOC  DB     0,0
BOX     DB     0,$E7,$E7       ;0,-25,-25       CENTER BOX
        DB     $FF,0,50        ;-1,0,50
        DB     $FF,50,0        ;-1,50,0
        DB     $FF,0,$CE       ;-1,0,-50
        DB     $FF,$CE,0       ;-1,-50,0
        DB     1

MUSIC   FDB     $ED8F,$FEB6     ;WE WISH YOU A MERRY CHRISTMAS
        DB     9,10            ;WE
        DB     14,10           ;WISH
        DB     14,5            ;YOU
        DB     16,5            ;A
        DB     14,5            ;MER-
        DB     13,5            ;RY
        DB     11,10           ;CHRIST-
        DB     11,10           ;MAS
        DB     11,10           ;WE
        DB     16,10           ;WISH
        DB     16,5            ;YOU
        DB     18,5            ;A
        DB     16,5            ;MER-
        DB     14,5            ;RY
        DB     13,10           ;CHRIST-
        DB     9,10            ;MAS
        DB     9,10            ;WE
        DB     18,10           ;WISH
        DB     18,5            ;YOU
        DB     19,5            ;A
        DB     18,5            ;MER-
        DB     16,5            ;RY
        DB     14,10           ;CHRIST-
        DB     11,10           ;MAS
        DB     9,5             ;AND
        DB     9,5             ;A
        DB     11,10           ;HAP-
        DB     16,10           ;PY
        DB     13,10           ;NEW
        DB     14,20           ;YEAR
        DB     0,$80           ;END OF MUSIC

CSET    DB     $F8,80,32,$9C   ;-8,80,32,-100
        DB     ' !"#$%&',$27,'()*+,-./',$80
        DB     $F8,80,16,$9C   ;-8,80,16,-100
        DB     '0123456789:;<=>?',$80
        DB     $F8,80,0,$9C    ;-8,80,0,-100
        DB     '@ABCDEFGHIJKLMNO',$80
        DB     $F8,80,$F0,$9C  ;-8,80,-16,-100
        DB     'PQRSTUVWXYZ[\]^_',$80
        DB     $F8,80,$E0,$9C  ;-8,80,-32,-100
        DB     '`abcdefghijklmno',$80
        DB     0

        END
