;  Lunar.asm

;

;  A totally unfinished Vectrex game.

;

;  Feel free to talk vectrex with me at tomsoft@worldnet.net

;

;  Use key to move ship

;



WAITRCL EQU     $F192           ;WAIT FOR T2 TIMEOUT, RECALIBRATE

BPNT    EQU     $CA00

DPTOD0  EQU     $F1AA           ;SET DP TO D0 (I/O)

DPTOC8  EQU     $F1AF           ;SET DP TO C8 (RAM)

SWITCHS EQU     $F1B4           ;READ SWITCHES

JOYSTK  EQU     $F1F8           ;READ JOYSTICK

ZAXTO7F EQU     $F2A9           ;SET Z AXIS INTENSITY TO 7F

ZAXTOA  EQU     $F2AB           ;SET Z AXIS INTENSITY TO A

draw_dot_at_current_pos EQU     $F2C5

MVD85   EQU     $F30C           ;MOVE DOT WITH MEDIUM INTEGRATION

move_pen_7F_no_inc      EQU     $F2F2

move_pen_7f_to_d   EQU     $F2FC      ;

move_pen_d   EQU     $F312      ;

print_at_d EQU  $F37A

RES0RF  EQU     $F354           ;RESET ZERO REFERENCE

DRWL1B  EQU     $F40E           ;DRAW LINE, MAG IN B

convert_angle_to_rise_run EQU $F601

;draw_VL_with_count2 EQU $F3D6

draw_VL_with_count4 EQU $F3CE

ROTATE  EQU     $F61F           ;ROTATE POINTS

clear_blockxb   EQU     $F53F

get_random_a    EQU     $F517

move_block      EQU     $F67F

generate_explosion_sound        EQU     $F92E

UFO     EQU     $C93B           ;UFO POINTER

SW11    EQU     $C812           ;SWITCH 1, CONSOLE 1

SW12    EQU     $C813           ;   "   2,    "    1

SW13    EQU     $C814           ;   "   3,    "    1

SW14    EQU     $C815           ;   "   4,    "    1

JOYVLS  EQU     $C81B           ;JOYSTICK VALUES (4 BYTES)

JOYENS  EQU     $C81F           ;JOYSTICK ENABLES (4 BYTES)

JOYTYP  EQU     $C823           ;JOYSTICK CONVERSION TYPE

INTENS  EQU     $C828           ; itensity

posbr   EQU     $C900           ; brick pos

ANGLE   EQU     $C904

POWER   EQU     $C905           ; power

PX      EQU     $C906           ; big posx      Word

PY      EQU     $C908           ; big posY      Word

VX      EQU     $C90A           ; X velocity    Word

VY      EQU     $C90C           ; X velocity    Word

FUEL    EQU     $C90e           ; Fuel

PVX     EQU     $C910           ; Power Velocity

PVY     EQU     $C911           ; Power Velocity

T1      EQU     $C913

BOUM    EQU     $C914           ; Flg to tell that hte ship is begin dest.

WIN     EQU     $C915           ; PLayer win's

NBPART  EQU     10

PARTY   EQU     $0

PARTX      EQU    $2

PARTVY  EQU     $4

PARTVX  EQU     $5

PARTT   EQU     $8

SIZEPART        EQU     $9

TABPART EQU     $C970

POWER_THRUST   EQU     3



BUFFER  EQU     $C950           ; buffer point



        ORG     0

        db     'g GCE 0000',$80

        FDB     MUSIC

        FCB     $F8,$50,$20,$C8

        db     'LUNAR LANDER',$80

        FCB     $FA,$43,$00,$AA

        db     'SERIAL NUMBER 0000',$80

        FCB     $FC,$14,$7F,$EA

        db     'GROUMPF',$80,0

*----------------------------------------------------------------------------

BEGIN

        JSR     RESETSHIP       ; Reset all player's data

        ; main loop

LOOP

        JSR     DPTOC8

        JSR     WAITRCL         ; Wait vertical sync



        jsr     >JOYSET

        jsr     KEYS            ; Check keys

        jsr     MOVEPL          ; Move player, according keys



        JSR     DRAWSOL         ; Draw moon land

;        JSR     PRINTINFO

        JSR     PRINTSCORE_FUEL ; Display informations (fuel, score,...)

        TST     BOUM            ; Are we dying?

        BEQ     NOBOUM

        BSR     BOUM_DISP       ; Yes? Display explosion

;        JSR     DRAWBOOM

        BRA     SUITE_LOOP

NOBOUM

        JSR     DRAWSHIP        ; No? Display normal ship

        jsr     TSTCRASH

SUITE_LOOP

        JSR     DISPLAYPART

        BRA      LOOP

        RTS

        ;

        ; Display explosion

        ;

BOUM_DISP

        DEC     BOUM

        BNE     NO_END_BOUM

        JSR     RESETSHIP

NO_END_BOUM

        LDU     #BOUMINFO

        LDA     #-10

        LDB     #0

        JSR     print_at_d

        RTS

BOUMINFO

        db      'BOUM',$80

PRINTINFO

        JSR     RES0RF

        LDD     #$FC24

        STD     $C82A



        LDU     #TOMINFO

        LDA     #50

        LDB     #50

        JSR     print_at_d



        JSR     RES0RF

        JSR     DPTOD0

        LDX     #tompos ; Move to a cool location

        JSR     MVD85

        LDX     #BUFFER

        LDA     #1

        STA     ,X+

        LDA     #0

        STA     ,X+

        STA     ,X+

        LDA     VX+1

        STA     ,X+

        LDA     #0

        STA     ,X+

        LDX     #BUFFER

        JSR     draw_VL_with_count4

        JSR     RES0RF



        LDX     #tompos2 ; Move to a cool location

        JSR     MVD85

        LDX     #BUFFER

        LDA     #1

        STA     ,X+

        LDA     #0

        STA     ,X+

        STA     ,X+

        LDA     VY+1

        STA     ,X+

        LDA     #0

        STA     ,X+

        LDX     #BUFFER

        JSR     draw_VL_with_count4

        JSR     RES0RF



        LDX     #tompos2 ; Move to a cool location

        JSR     MVD85

        LDX     #BUFFER

        LDA     #1

        STA     ,X+

        LDA     #0

        STA     ,X+

        STA     ,X+

        LDA     VY+1

        STA     ,X+

        LDA     VX+1

        STA     ,X+

        LDX     #BUFFER

        JSR     draw_VL_with_count4

        JSR     RES0RF



        RTS

RESETSHIP

        LDX     #posbr

        lda     #50

        sta     ,x+

        sta     ,x+



        LDD     #$00

        STA     ANGLE

        STA     POWER

        STA     BOUM

        STA     WIN

        STD    VX

        STD    VY

        STD     PX

        STD     PY

        lda     #1

        STA     FUEL+1

        lda     #$7F

        STA     FUEL

        ldx     #TABPART

        ldb     #NBPART*SIZEPART

        jsr     clear_blockxb

        RTS



tompos  db      $50,$40

tompos2  db      $50,$50

TOMINFO db      ' SCORE:',$80



PRINTSCORE_FUEL

        LDU     #TOMINFO

        LDA     #$7F

        LDB     #-$80

        JSR     print_at_d

        JSR     RES0RF



        LDD     #$6080

        JSR     move_pen_7f_to_d

        LDX     #BUFFER

        LDA     #1

        STA     ,X+

        LDA     #0

        STA     ,X+

        STA     ,X+

        STA     ,X+

        LDA     FUEL

        STA     ,X+

        LDX     #BUFFER

        JSR     draw_VL_with_count4

        JSR     RES0RF



        RTS



        ; --------------------------------------------

DRAWSHIP



        JSR     DPTOD0

        LDA     #$5F

        JSR     ZAXTOA



        LDX     #posbr

        JSR     MVD85



        LDX     #BRIK   ; Rotate points of ship

        LDU     #BUFFER

        LDA     ANGLE

        JSR     ROTATE



        LDX     #BUFFER ; Draw points of ship

        LDB     #$30

        JSR     DRWL1B

        JSR     RES0RF



        TST     POWER

        BEQ     NODRAWFIRE



        LDX     #posbr

        JSR     MVD85



        LDX     #FIRE   ; Rotate Fire

        LDU     #BUFFER

        LDA     ANGLE

        JSR     ROTATE



;        PSHS    U

;        PULS    X

        LDX     #BUFFER

        LDB     #$30

        JSR     DRWL1B   ; Draw fire

        JSR     RES0RF

NODRAWFIRE

        TST     WIN

        BEQ     NOWIN

        DEC     WIN

        LDU     #WININFO

        LDA     #-10

        LDB     #0

        JSR     print_at_d

NOWIN

        RTS

WININFO db     'WIN',$80

DISPLAYPART

        ; Display particules

        LDY     #TABPART        ; Get particule pointer

        LDB     #NBPART

NEXTPART1

        LDA     PARTT,Y          ; Get particule timer. 0= empty slot

        BEQ     NEW_PART

        DECA                    ; decrement particule timer

        STA     PARTT,Y

        PSHS   B,Y

        LDB     PARTVX,Y        ; Get particule speed

        SEX                     ; use it as a 16 bite value

        ADDD    PARTX,Y         ; add current position

        STD     PARTX,Y         ; store it as new position



        LDB     PARTVY,Y        ; same with Y speed

        SEX

        ADDD    PARTY,Y

        STD     PARTY,Y



        LEAX    PARTY,Y         ; Get particule position



        jsr     move_pen_7F_no_inc

        LDA     PARTT,Y

        LSLA

        NEGA

        ADDA    #$7F

        STA     INTENS

        jsr     draw_dot_at_current_pos

        JSR     RES0RF

        PULS    B,Y

        BRA     NEXT_PART

NEW_PART

        tst     POWER

        BEQ     NEXT_PART

        PSHS   B,Y

        bsr     get_random_a    ; Get a random number, used for timing

        PULS    B,Y

        PSHS   B,Y

        CMPA     #$40          ; but also used to tell if we launch this particule

        BGE     RANDOM_SAY_NO   ; gt 40 > no launch

        ANDA     #$2F           ; Particule life is between $10

        ADDA     #$10           ; and $2F+$10

        sta     PARTT,Y

        lda     posbr           ; put ship position into

        sta     PARTY,Y         ; particule position

        PSHS    Y

        bsr     get_random_a    ; Get a random number, used for timing

        PULS    Y

        anda     #$1F

        adda    PARTY,Y

        lda     posbr+1

        sta     PARTX,Y

        PSHS    Y

        bsr     get_random_a    ; Get a random number, used for timing

        PULS    Y

        anda     #$1F

        adda    PARTX,Y

        lda     PVX             ; put last power direction into

        LSLA                    ; particule direction

        LSLA

        LSLA

        LSLA

        nega

        sta     PARTVX,Y

        lda     PVY

        LSLA

        LSLA

        LSLA

        LSLA

        nega

        sta     PARTVY,Y

RANDOM_SAY_NO

        PULS    B,Y

NEXT_PART

        LEAY    SIZEPART,Y      ; Get next particule pointer

        DECB                    ; while there is particules

        BNE     NEXTPART1

        RTS

        ; --------------------------------------------

DRAWSOL

        LDD     #$8080

        JSR     move_pen_7f_to_d



        LDX     #SOL

        JSR     draw_VL_with_count4

        JSR     RES0RF

        RTS



KEYS    CLRA                    ;NORMAL SWITCH MODE

        JSR     SWITCHS         ;READ SWITCHES

        TST     SW13

        BEQ     KRIGHT

        INC     ANGLE

        BRA     KFIRE

KRIGHT

        TST     SW14

        BEQ     KFIRE

        DEC     ANGLE

KFIRE   LDA     #0

        STA     POWER

        TST     SW12            ; Press fuel button

        BEQ     KOUT

        TST     FUEL            ; is there any fuel ?

        BEQ     KOUT

        DEC     FUEL+1

        TST     FUEL+1

        BNE     F1

        lda     #10

        STa     FUEL+1

        TST     FUEL

        BEQ     F1

        dec     FUEL

F1

        LDA     #POWER_THRUST             ; add a little bit fuel

        STA     POWER

        ldu     #DATA1

        jsr     DPTOC8

        jsr   generate_explosion_sound

KOUT

         RTS

DATA1   fcb      $38, $3F, 00, $10

SETPEN  PSHS    Y               ;THIS ROUTINE CONVERTS STANDARD YX

        LDA     $C902

        SBCA    #$81            ;MOVE Y OVER

        STA     $C904

        LDA     $C903

        ADDA    #$80            ;MOVE X OVER

        STA     $C905

        LDX     #$C904

        JSR     MVD85

        PULS    Y

        RTS

*----------------------------------------------------------------------------

DOJOY   LDA     #$4F

        STA     JOYTYP

        JSR     DPTOD0

        JSR     JOYSTK          ;READ THE STICK

        RTS

*----------------------------------------------------------------------------

MOVEPL  JSR     DOJOY

        LDX     #posbr+1

        LDA     $C81B

        CMPA    #$00

        BEQ     CHKY            ;X IS CENTERED, CHECK Y

        CMPA    #$00

        BPL     JRIGHT          ;JOYSTICK IS MOVED RIGHT

        LDA     ,X

        SUBA     #1

        STA     ,X

        JMP     CHKY



JRIGHT

        LDA     ,X

        ADDA     #1

        STA     ,X

        bra     CHKY

CHKY    LEAX    -1,X

        LDA     $C81C           ;CHECK Y VALUE OF STICK

        CMPA    #$00

        BEQ     JRET            ;CENTERED, RETURN FROM SUB

        CMPA    #$00

        BPL     JUP             ;STICK IS MOVED UP

        LDA     ,X

        SUBA     #1

        STA     ,X

        RTS

JUP

        LDA     ,X

        ADDA     #1

        STA     ,X

JRET

        JSR     DPTOC8

        LDB     ANGLE

        LDA     POWER

        JSR     convert_angle_to_rise_run

        STA     PVY

        STB     PVX

;        STA     VY+1

        ADDA    VY+1              ; Gravity

        cmpa    #100

        ble     no_MAX

        lda     #100

no_MAX

        SUBa    #1

        cmpa    #-100

        bge     MAX_GRAV

        lda     #-100

MAX_GRAV

        STa     VY+1



        ADDB    VX+1

        Cmpb    #100

        blt     pasmax1

        ldb     #100

pasmax1

;        cmpb    #0

;        blt     pasmax2

;        subb    #1

;pasmax2

        Cmpb    #-100

        bge     pasmax3

        ldb     #-100

pasmax3

;        cmpb    #0

;        bge     pasmax4

;        addb    #1

;pasmax4

        STB    VX+1  ;  Y POWER



        LDD     VX   ; Get X Velocity

        SEX          ; Extend it ( 16 bytes values )

        STD     VX   ; Multiply VX*2

        ADDD    VX

        ADDD    VX



        ADDD    PX

        STD     PX

        LDA     PX

        STA     posbr+1



        LDD     VY

        SEX

        STD     VY

        ADDD    VY

        ADDD    VY



        ADDD    PY

        STD     PY

        LDA     PY

        CMPA     #-$78

        BGE     L1

        LDA     #$78

        STA     PY

L1

        STA     posbr



        JSR     DPTOD0

        RTS

TSTCRASH

        LDX     #SOL    ; Get pointer list

        LDA     ,X+     ; Get number of elements in the list

        INCA

        STA     T1

        LDA     #$80

        LDB     #$80

LOOPCRASH

        TST     ,X     ; See what direction is Y vector

        BLT     DIR1

        CMPA    PY

        BGT     NEXT2

        ADDA    ,X+     ; get next relative pos

        CMPA    PY

        BLT     NEXT1

        BRA     TEST_X

DIR1

        CMPA    PY

        BLT     NEXT2

        ADDA    ,X+     ; get next relative pos

        CMPA    PY

        BGE     NEXT1



TEST_X

        CMPB    PX

        BGE     NEXT1

        ADDB    ,X+     ; get next relative pos

        CMPB    PX

        BLT     NEXT



        ; Here, we've found which seg of the land is touched.

        ; If Y deviation is 0, this mean that this is the base

        TST     -2,X    ;Test last delta Y

        BNE     NO_BASE

        LDA     #100    ; Player Win!

        STA     WIN

        RTS

NO_BASE

        PSHS    X

        JSR     move_pen_d

        PULS    X

        LDY     #BUFFER



        LDA     #1

        STA     ,Y

        LDA     #0

        STA     1,Y

        STA     2,Y

        STA     3,Y

        LDA     -1,X

        NEGA

        STA     4,Y

        LDX     #BUFFER

        JSR     draw_VL_with_count4

        JSR     RES0RF



        LDA     #100

        STA     BOUM

        BSR     EXPLODE

        RTS

NEXT2

         ADDA    ,X+

NEXT1

         ADDB    ,X+

NEXT

        DEC     T1

        BNE     LOOPCRASH

        LDA     #$00

        RTS



EXPLODE

        ; Display particules

        LDY     #TABPART        ; Get particule pointer

        LDB     #NBPART

NEXTPART2

        PSHS    B

        LDA     #50

        STA     PARTT,Y          ; Get particule timer. 0= empty slot

        PSHS    Y

        bsr     get_random_a    ; Get a random number, used for timing

        PULS    Y

        sta     PARTVX,Y

        PSHS    Y

        bsr     get_random_a    ; Get a random number, used for timing

        PULS    Y

        ANDA     #$6F           ; Particule life is between $10

        ADDA     #$10           ; and $2F+$10

        sta     PARTVY,Y



        lda     PX

        sta     PARTX,Y

        lda     PY

        sta     PARTY,Y

        PULS    B

        LEAY    SIZEPART,Y      ; Get next particule pointer

        DECB                    ; while there is particules

        BNE     NEXTPART1

        RTS



*----------------------------------------------------------------------------

JOYSET  LDX     #JOYENS

        LDA     #1              ;CONSOLE 1, LEFT/RIGHT

        STA     ,X+

        LDA     #3              ;CONSOLE 1, UP/DOWN

        STA     ,X+

        CLRA                    ;IGNORE THE OTHER TWO

        STA     ,X+

        STA     ,X+

        RTS



BRIK

        fcb      $00,-20,-20

        fcb      $FF, 10, 10

        fcb      $FF,  0, 20

        fcb      $FF, 20,  0

        fcb      $FF,  0,-20

        fcb      $FF,-20,  0

        fcb      $00,  0, 20

        fcb      $FF,-10, 10

        fcb      $00, 30,-20

        fcb      $FF, 10,  0

        fcb     1

FIRE    fcb      $00,-10,-10

        fcb      $FF,  0, 20

        fcb      $FF,-18,-10

        fcb      $FF, 18, -10

        fcb     1

SOL     fcb     10,55,20,-45,20,30,10,10,20,-14,10,0,20,10,15,-20,15,5,30

        fcb     -10,30,30,30



MUSIC   FDB     $FEE8

        FDB     $FEB6

        fcb     20,20,18,20

        fcb     16,20,14,20,16,10,18,10,20,10

        fcb     22,10,20,30

        FCB     0, $80

