
        FDB     BAKGND          BACKGROUND DRONE SOUND
        FDB     $0C00
        FCB     $0C,$18,$00

*
*
KLAXON  LDD     #$1040          SETUP ENVALOPE PERIOD
        STD     REQ1
        LDA     #$08            SETUP ENVALOPE TYPE
        STA     REQ0
        JMP     STUVIT
*
*
FIRSND: LDY     #FIRRAM
        LDA     SNDWRD
        ANDA    MASK
        BEQ     PRESET
        LDD     #0
        STA     ,Y
        LDD     #3
        STD     4,Y
        LDD     #5
        STD     8,Y
        LDD     #$F18
        STD     2,Y
        STD     6,Y
        STD     10,Y
PRESET: LDU     #FIRTBL-6
        LDD     #$00A0          SETUP ENVALOPE PERIOD
        STD     REQ1
        CLR     REQ7            SETUP WHITE NOISE FREQ TO MAX
        LDA     #$0E            SETUP ENVALOPE TYPE
        STA     REQ0
        BSR     SWP_DN
        LEAY    4,Y
        LEAU    1,U
        BSR     SWP_DN
        LEAY    4,Y
        LEAU    1,U
        BSR     SWP_DN
        CLR     CHAN
        RTS

SWP_DN  DEC     3,Y
        LBEQ    SHUTIT
        LDA     3,Y
SWPDN0  CMPA    #$0E
        BGT     SWPDN1
        STA     2,Y             DECAY AMPLITUDE WHEN TIMER  IS LESS THAN 0E
*
SWPDN1  LDX     ,Y
        LEAX    $02,X
        STX     ,Y
        JMP     STUVIT
*
FULOUT: LDY     #OUTRAM
        LDA     SNDWRD
        BITA    MASK
        BEQ     QRESET
*       ANDA    #$FD                                            ****REMOVE
*       STA     SNDWRD                                          ****REMOVE
        LDA     SNDMAB
        ANDA    #$FD
        STA     SNDMAB
        LDA     SNDGO                                           ****INSERT
        ANDA    #$FD                                            ****INSERT
        STA     SNDGO                                           ****INSERT
        LDD     #$10
        STD     ,Y
        STD     4,Y
        LDD     #$E0E
        STD     2,Y
        LDD     #0
        STD     8,Y
        LDD     #$E07
        STD     6,Y
        LDD     #$F03
        STD     10,Y
QRESET: BSR     NOMOGO
        LEAY    4,Y
        BSR     NOMOGO
        LEAY    4,Y

NOMOGO  DEC     3,Y     CHECK TIMER
        BNE     STUVIT  NO CHANGE TILL EVERY TIMER CYCLE
        LDA     #$03    RESET TIMER WHEN OVER
        STA     3,Y
        LDX     0,X     DROP FREQUENCY
        LEAX    1,X
        STX     0,Y
        BRA     STUVIT
*
*
FEULIN:
*       LDA     SNDWRD                                          ****REMOVE
*       ANDA    #$FD                                            ****REMOVE
*       STA     SNDWRD                                          ****REMOVE
        LDA     SNDMAB
        ANDA    #$FD
        STA     SNDMAB
        LDA     SNDGO                                           ****INSERT
        ANDA    #$FD                                            ****INSERT
        STA     SNDGO                                           ****INSERT
        LDD     0,Y     RAISE TONE FREQUENCY
        SUBD    #$030
        STD     0,Y
        DEC     NOSEFR  RAISE NOISE FREQUENCY
        LDA     NOSEFR
        STA     REQ7
        CMPA    #$0F
        BGT     FUELI1
        STA     2,Y
FUELI1  BNE     STUVIT
        BRA     SHUTIT
*
PASTRU  LDD     #$2F40
        STD     REQ1    SETUP ENVALOPE PERIOD
        LDA     #$03
        STA     REQ0    SETUP ENVALOPE TYPE
        DEC     3,Y     CHECK TIMER
        BNE     STUVIT
        LDA     #$02    RESET ENVALOPE GEN IF DONE
        STA     REQ0
        BRA     SHUTIT
*
BAKGND  LDD     0,Y
        SUBD    #$03
        STD     0,Y
        CMPD    #$0A00
        BHI     STUVIT
        ******
**
** PROGRAM
**
****************

****************
**
** DRWBOX
**
** DRAW THE BOX POINTED AT BY REG X
**
** ZOOM,TIMER INFO POINTED AT BY REG Y
**
****************

DRWBOX
        LDA     0,Y
        CMPA    #$FF
        BNE     DRWBB2
        RTS
DRWBB2
        PSHS    X
        LDB     #DISPAR          DISPARITY TIMER
        STB     T1LOLC
        LDD     0,X++            GET OFFSET
        STA     DAC
        CLR     PORT
        LDA     #UZEROX
        STA     PPCR
        INC     PORT
        STB     DAC
        LDB     #$40
        CLR     T1HOC
DRWB_2
        BITB    IFR
        BEQ     DRWB_2
        LDA     0,Y
        STA     UNTILL
        ADDA    #$40
        BPL     DRWB_4
        LDA     #$7F
DRWB_4
        JSR     INTENS
        JSR     DRAW
        PULS    X
ZEROO
        LDA     #ZEROX           ZERO BEAM
        STA     PPCR
        JSR     ZEREF
        JSR     DEL13
        RTS

******************
**
** WALL
**
** DRAW THE WALL AND THEN THE BOX
**
*****************
WALL
        PSHS    X                POINTER TO BOX
        LDX     #TUN9
TRAW
        CLR     PORT            SET MULTIPLEXER TO YAXIS S/H
        LDA     1,X             A HAS YAXIS VOLTAGE
        STA     DAC             SET YAXIS VOLTAGE INTO Y S/H
*                               FOLLOWING IS Y AXIS SAMPLE TIME
        LDB     3,X             B HAS ZOOM PWR OF 2 MULTIPLIER
        STB     UNTILL+1        ZOOM MULT WORKING REG
        LDB     #$55            MAKES A TOTAL OF 4 ADDED EVERY 2 2X
        STB     TEMP            IN THE 2X MULTIPLY LOOP (DR1)
        LDB     UNTILL          B HAS ZOOM TIMER LSB
        CLRA                    SETUP FOR DOUBLE PRECIS
        DEC     UNTILL+1        NO ZOOM IF ZERO
        BMI     TR2             NO ZOOM, SETUP TIMER AND Y SAMPLE/H
TR1     ASL     TEMP             (IF >4X EVER USED)
        ROLB                    ZOOM VALUE =ZOOM VALUE X2
        ROLA                    A HAS ZOOM MSB
        ADDB    #$03            ZOOM 00 IS A TIME QUANTITY OF ~3_75
        ADCA    #$00
        DEC     UNTILL+1        NO MORE ZOOM IF 0
        BPL     TR1             2X AGAIN
TR2     STB     T1LOLC          SET TIMER LSB = ZOOM LSB
        LDB     2,X             B HAS XAXIS VOLTAGE
        INC     PORT            SET TO XAXIS PORT
*                               END OF Y S/H TIME
        STB     DAC             SET X VOLTAGE
        LDB     0,X             B HAS BLANKING
        ORCC    #$10            DISABLE IRQ DURING DRAW OF LINE
        STB     SR              SET BEAM ON OR OFF PER BLANKING
        STA     T1HOC           SET TIMER MSB = ZOOM MSB
*                               START RAMP TIMER
        LDB     #$40            TIMER FLAG BIT POSN MASK
TR3     BITB    IFR
        BEQ     TR3             WAIT FOR RAMP TIMER

        LEAX    4,X             WAIT FOR BEAM
        LEAX    0,X
*                               X POINTS AT START OF NEXT PACKET
        CLR     SR              TURN OFF BEAM
        ANDCC   #$EF            RE-ENABLE INTERRUPTS AFTER LINE

        LDA     MOT_PW+1        GET MOTOR WORKING PULSE WIDTH
        BEQ     TTR4            DONT MESS WITH JOB IF LOCKED OUT

        CMPA    T2HOC           COMPARE TO WHEEL TIMER MSB
        BHI     TR5             IF MSB LOWER THAN PW, MOTOR OFF
