; can be assembled correctly now
; compatibilty added by Malban
;
; assenmble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti bonnie.asm >error
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
        DB     'BONNIE',$80,0

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
        LDA     #$80            ;SELECT EDGE TRIGGER SW 1, CONSOLE 1
        JSR     SWITCH
        LDA     SW1C1
        BEQ     LOOP            ;IF NO SWITCH, DO NOTHING
        CLR     MAG             ;RESET SQUARE
        BRA     LOOP

BOXLOC  FCB     0,0
BOX     FCB     0,$E7,$E7       ;0,-25,-25       CENTER BOX
        FCB     $FF,0,50        ;-1,0,50
        FCB     $FF,50,0        ;-1,50,0
        FCB     $FF,0,$CE       ;-1,0,-50
        FCB     $FF,$CE,0       ;-1,-50,0
        FCB     1

ENVLOP  FCB     $FF,$FF,$EE,$EE,$DD,$DD,$CC,$CC
        FCB     $BB,$BB,$AA,$AA,$99,$99,$88,$88

MUSIC   FDB     ENVLOP,$FEB6    ;MY BONNIE LIES OVER THE OCEAN (2 PART)

        FCB     $93,16,10       ;MY
        FCB     $9C,19,15       ;BON-
        FCB     $9A,17,5        ;NIE
        FCB     $98,16,10       ;LIES
        FCB     $9A,17,10       ;O-
        FCB     $98,17,10       ;VER
        FCB     $95,17,10       ;THE
        FCB     $93,16,10       ;O-
        FCB     $90,12,30       ;CEAN
        FCB     $3F,5           ;(REST)
        FCB     $93,16,10       ;MY
        FCB     $9C,19,15       ;BON-
        FCB     $9A,17,5        ;NIE
        FCB     $98,16,10       ;LIES
        FCB     $98,16,10       ;O-
        FCB     $97,16,10       ;VER
        FCB     $98,16,10       ;THE
        FCB     $9A,17,50       ;SEA
        FCB     19,10           ;MY
        FCB     $9C,19,15       ;BON-
        FCB     $9A,17,5        ;NIE
        FCB     $98,16,10       ;LIES
        FCB     $9A,17,10       ;O-
        FCB     $98,17,10       ;VER
        FCB     $95,17,10       ;THE
        FCB     $93,16,10       ;O-
        FCB     $90,12,30       ;CEAN
        FCB     $3F,5           ;(REST)
        FCB     $93,16,10       ;O
        FCB     $95,17,10       ;BRING
        FCB     $9A,17,10       ;BACK
        FCB     $98,17,10       ;MY
        FCB     $97,17,10       ;BON-
        FCB     $95,17,10       ;NIE
        FCB     $97,17,10       ;TO
        FCB     $98,16,50       ;ME
        FCB     $3F,5           ;(REST)
        FCB     $93,16,30       ;BRING
        FCB     $98,19,30       ;BACK
        FCB     $95,17,30       ;BRING
        FCB     $98,17,30       ;BACK
        FCB     $97,17,10       ;BRING
        FCB     $97,17,10       ;BACK
        FCB     $97,17,10       ;MY
        FCB     $97,17,10       ;BON-
        FCB     $95,17,10       ;NIE
        FCB     $97,17,10       ;TO
        FCB     $98,16,20       ;ME
        FCB     $9A,19,10       ;TO
        FCB     $9C,19,30       ;ME
        FCB     $93,16,30       ;BRING
        FCB     $98,19,30       ;BACK
        FCB     $95,17,30       ;BRING
        FCB     $9A,18,33       ;BACK (FERMATA)
        FCB     $98,17,10       ;O
        FCB     $97,19,10       ;BRING
        FCB     $97,19,10       ;BACK
        FCB     $97,19,10       ;MY
        FCB     $97,17,10       ;BON-
        FCB     $95,17,10       ;NIE
        FCB     $97,19,10       ;TO
        FCB     $98,16,50       ;ME

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
