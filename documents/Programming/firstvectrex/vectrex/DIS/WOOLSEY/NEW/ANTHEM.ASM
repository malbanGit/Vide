; can be assembled correctly now
; compatibilty added by Malban;
; assenmble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti anthem.asm >error
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

        DB      'g GCE 1776',$80
        FDB     MUSIC,$F850,$30E8
        DB      'ANTHEM',$80,0

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

BOXLOC  FCB     0,0
BOX     FCB     0,$E7,$E7       ;0,-25,-25       ;CENTER BOX
        FCB     $FF,0,50        ;-1,0,50
        FCB     $FF,50,0        ;-1,50,0
        FCB     $FF,0,$CE       ;-1,0,-50
        FCB     $FF,$CE,0       ;-1,-50,0
        FCB     1

ENVLOP  FCB     $FF,$FF,$EE,$EE,$DD,$DD,$CC,$CC
        FCB     $BB,$BB,$AA,$AA,$99,$99,$88,$88

MUSIC   FDB     ENVLOP,$FEB6    ;STAR SPANGLED BANNER (2 PART)

        FCB     17,15           ;OH
        FCB     14,5
        FCB     10,20           ;SAY
        FCB     14,20           ;CAN
        FCB     17,20           ;YOU
        FCB     $96,14,40       ;SEE
        FCB     $9A,14,15       ;BY
        FCB     $98,14,5        ;THE
        FCB     $96,14,20       ;DAWN'S
        FCB     14,20           ;EAR-
        FCB     $90,12,20       ;LY
        FCB     $91,12,40       ;LIGHT
        FCB     17,10           ;WHAT
        FCB     17,10           ;SO
        FCB     $9A,17,30       ;PROUD-
        FCB     $98,17,10       ;LY
        FCB     $96,17,20       ;WE
        FCB     $95,17,40       ;HAILED
        FCB     $93,17,15       ;AT
        FCB     $95,17,5        ;THE
        FCB     $96,17,20       ;TWI-
        FCB     22,20           ;LIGHT'S
        FCB     17,20           ;LAST
        FCB     14,20           ;GLEAM-
        FCB     10,20           ;ING
        FCB     17,15           ;WHOSE
        FCB     14,5            ;BROAD
        FCB     10,20           ;STRIPES
        FCB     14,20           ;AND
        FCB     17,20           ;BRIGHT
        FCB     $96,14,40       ;STARS
        FCB     $9A,14,15       ;THROUGH
        FCB     $98,14,5        ;THE
        FCB     $96,14,20       ;PER-
        FCB     14,20           ;IL-
        FCB     $90,12,20       ;OUS
        FCB     $91,12,40       ;FIGHT

        FCB     17,10           ;O'ER
        FCB     17,10           ;THE
        FCB     $9A,15,30       ;RAM-
        FCB     $98,15,10       ;PARTS
        FCB     $96,15,20       ;WE
        FCB     $95,15,40       ;WATCHED
        FCB     $93,15,15       ;WERE
        FCB     $95,15,5        ;SO
        FCB     $96,15,20       ;GALL-
        FCB     22,20           ;ANT-
        FCB     17,20           ;LY
        FCB     14,20           ;STREAM-
        FCB     10,20           ;ING

        FCB     $9A,22,10       ;AND
        FCB     $9A,22,10       ;THE
        FCB     $9A,22,20       ;ROCK-
        FCB     $9B,24,20       ;ETS
        FCB     $9D,26,20       ;RED
        FCB     $9D,26,40       ;GLARE
        FCB     $9B,24,10       ;THE
        FCB     $9A,22,10       ;BOMBS
        FCB     $98,21,20       ;BURST-
        FCB     $9A,22,20       ;ING
        FCB     $9B,24,20       ;IN
        FCB     $9B,24,40       ;AIR

        FCB     $9B,17,20       ;GAVE
        FCB     $9A,17,30       ;PROOF
        FCB     $98,17,10       ;THROUGH
        FCB     $96,17,20       ;THE
        FCB     $95,17,40       ;NIGHT
        FCB     $93,17,15       ;THAT
        FCB     $95,17,5        ;OUR
        FCB     $96,17,20       ;FLAG
        FCB     14,20           ;WAS
        FCB     $90,12,20       ;STILL
        FCB     $91,12,40       ;THERE

        FCB     17,20           ;OH
        FCB     $96,14,20       ;SAY
        FCB     $96,15,20       ;DOES
        FCB     $96,14,10       ;THA-
        FCB     $95,14,10       ;T
        FCB     $93,15,20       ;STAR
        FCB     $93,15,20       ;SPANG-
        FCB     $93,17,20       ;LED
        FCB     $98,15,20       ;BAN-
        FCB     $9B,15,10       ;NER-
        FCB     $9A,17,10       ;R
        FCB     $98,19,10       ;YET-
        FCB     $96,19,10       ;T
        FCB     $96,17,20       ;WAVE-
        FCB     $95,17,24       ;E  (FERMATA)

        FCB     17,10           ;O'ER
        FCB     17,10           ;THE
        FCB     $96,17,30       ;LAND-
        FCB     $98,17,10       ;D
        FCB     $9A,17,10       ;OF
        FCB     $9B,22,10       ;THE
        FCB     $9D,22,44       ;FREE  (FERMATA)

        FCB     $96,19,10       ;AND
        FCB     $98,16,10       ;THE
        FCB     $9A,17,30       ;HOME
        FCB     $9B,19,10       ;OF
        FCB     $98,15,20       ;THE
        FCB     $96,14,40       ;BRAVE

        FCB     0,$80           ;END OF MUSIC

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
