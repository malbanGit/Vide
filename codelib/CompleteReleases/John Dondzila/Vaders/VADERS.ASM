WAITRCL EQU     $F192           ;WAIT FOR T2 TIMEOUT, RECALIBRATE
DPTOD0	EQU	$F1AA		;SET DP TO D0 (I/O)
DPTOC8	EQU	$F1AF		;SET DP TO C8 (RAM)
SWITCHS	EQU	$F1B4		;READ SWITCHES
JOYSTK	EQU	$F1F8		;READ JOYSTICK
ZAXTO7F	EQU	$F2A9		;SET Z AXIS INTENSITY TO 7F
ZAXTOA  EQU     $F2AB           ;SET Z AXIS INTENSITY TO A
MVD170	EQU	$F308		;MOVE DOT WITH LONG INTEGRATION
MVD85	EQU	$F30C		;MOVE DOT WITH MEDIUM INTEGRATION
MOVED	EQU	$F312		;MOVE DOT WITH LAST INTEGRATION TIME
RES0RF	EQU	$F354		;RESET ZERO REFERENCE
DRWL1	EQU	$F40C		;DRAW LINE
DRWL1B	EQU	$F40E		;DRAW LINE, MAG IN B
RANDOM	EQU	$F517		;RETURN A RANDOM NUMBER IN A
VROW1   EQU     $C9C1
VROW2   EQU     $C9C3
VROW3   EQU     $C9C5

SW11	EQU	$C812		;SWITCH 1, CONSOLE 1
SW12	EQU	$C813		;   "   2,    "    1
SW13	EQU	$C814		;   "   3,    "    1
SW14	EQU	$C815		;   "   4,    "    1


MOLMAG  EQU     $C900           
MOLINT  EQU     $C901           
MOLPOS  EQU     $C903           ;X AND Y FOR INVADERS
MISPOS  EQU     $C905           ;X AND Y FOR MISSILE (YOURS)
BASEX   EQU     $C920
INVPOS  EQU     $C930           ;INVADERS X AND Y POSITIONS - 25 OF EM !
INVSTA  EQU     $C980           ;1=DEAD INVADER, 0=LIVE

	ORG	0

        db     'g GCE XXXX',$80
        FDB     MUSICH          ;POINTER TO INITIAL MUSIC BLOCK
        FCB     $F8,$30,$4C,$AA
        db     'OVER 12 YEARS HAVE PASSED',$80
        FCB     $F8,$30,$3C,$AA
        db     'SINCE THE RELEASE OF ANY',$80
        FCB     $F8,$30,$2C,$AA
        db     '    NEW VECTREX GAME',$80
        FCB     $F8,$5C,$FA,$80
        db      'LIFE JUST GOT BETTER',$80
        FCB     $F8,$15,$08,$CA
        db      ' ',$80,0
        
BEGIN   LDD     #$0000
        STD     $CBEB
        LDX     #$CBEB
        JSR     $F84F           ;INIT HIGH SCORE TO ZERO
        LDD     #$0000
        LDX     #$CBEB
        JSR     $F87C
        JMP     INTRO

START   LDX     #$C880         ;CLEAR RAM
        JSR     $F545
        LDA     #$01
        STA     $C9B9

START1  LDD     #$0000
        STD     $C8B0
        STD     $C8D0
        LDX     #$C8B0
        JSR     $F84F           ;INIT PLAYER SCORE
        LDX     #$C8D0
        JSR     $F84F           ;INIT FREE SHIP SCORE
        LDX     #$C8D0
        LDD     #$3000          ;SET UP SCORE FOR EXTRA BASE
        JSR     $F87C
        LDA     #$03
        STA     $C9BD           ;PLAYER LIVES
        LDA     #$01
        STA     $C9C9           ;PHYSICAL SKILL LEVEL
        LDA     #$05
        STA     $C9CA           ;INVADERS VERTICAL START LEVEL
        LDA     #$00
        STA     $C903
        STA     $C904
        STA     $C9D3
NEWLEV  LDD     #$3075          ;***NEW LEVEL STARTS HERE ***
	STD	$C83D		;SET T2 TIMER FOR 20 MSEC
	JSR	DPTOD0
	STD	$8		;START T2

        LDA     #$00            ;SET MISSILE FIRE STATUS TO OFF
        STA     $C922
        STA     $C9D4           ;GAME OVER TIMER
        STA     $C9D5           ;GAME OVER TIMER PART 2
        LDA     #50             
	STA	MOLMAG
        LDA     #$AF            
	STA	MOLINT

	LDX	#MOLPOS		;CLEAR ALL POSITIONS AND VELOCITIES
	LDA	#20
STA1	CLR	,X+
	DECA
	BNE	STA1
        LDX     #INVSTA         ;CLEAR ALL INVADERS
        LDA     #30
STA2    CLR     ,X+
	DECA
        BNE     STA2

        LDA     #$6F            ;INVADER START POSITIONS
        STA     $C930           ;Y COORDS
        STA     $C932
        STA     $C934
        STA     $C936
        STA     $C938
        LDA     #$5F
        STA     $C940
        STA     $C942
        STA     $C944
        STA     $C946
        STA     $C948
        LDA     #$4F
        STA     $C950
        STA     $C952
        STA     $C954
        STA     $C956
        STA     $C958
        LDA     #$3F
        STA     $C960
        STA     $C962
        STA     $C964
        STA     $C966
        STA     $C968
        LDA     #$2F
        STA     $C970
        STA     $C972
        STA     $C974
        STA     $C976
        STA     $C978

        LDA     #$83                    ;X COORDS
        STA     $C931
        STA     $C941
        STA     $C951
        STA     $C961
        STA     $C971
        LDA     #$9E
        STA     $C933
        STA     $C943
        STA     $C953
        STA     $C963
        STA     $C973
        LDA     #$BC
        STA     $C935
        STA     $C945
        STA     $C955
        STA     $C965
        STA     $C975
        LDA     #$DA
        STA     $C937
        STA     $C947
        STA     $C957
        STA     $C967
        STA     $C977
        LDA     #$F8
        STA     $C939
        STA     $C949
        STA     $C959
        STA     $C969
        STA     $C979

        LDA     #$12            ;MORE INVADERS VARIABLE
        STA     $C925
        STA     $C9C8
        LDA     #$7F
        STA     $C9BA
        LDA     #$FF
        STA     $C9BB
        LDA     #$03
        STA     $C927
        LDA     #$00            ;LEFT OR RIGHT MOVEMENT
        STA     $C928
        LDA     #$0A
        STA     $C929
        LDA     #$7F            ;RIGHT BOUNDARY
        STA     $C9B7
        LDA     #$AC            ;LEFT BOUNDARY
        STA     $C9B8
        LDA     #$19
        STA     $C924
        LDA     #$00
        STA     $C9BC
        LDA     #$05
        STA     $C9CE

        LDA     #$B0            ;BASE VARIABLES
        STA     $C904
        LDA     #$7F
        STA     $C920
        LDA     #$80
        STA     $C903
        LDA     #$80
        STA     $C905

        LDA     #$00            ;INVADER SPLAT INFO
        STA     $C92C

        LDA     #$A0            ;BUNKER LOCATIONS
        STA     $C999
        STA     $C99B
        STA     $C99D
        STA     $C99F
        LDA     #$B0
        STA     $C99A
        LDA     #$11
        STA     $C99C
        LDA     #$40
        STA     $C99E
        LDA     #$E4
        STA     $C9A0
        
        LDA     #$00
        STA     $C92D           ;SEED OUR RANDOM # GENERATOR

        LDA     #$20
        STA     $C9AC           ;BASE REGISTERS
        STA     $C9AD           ;0=BASE BLOWS UP
        STA     $C9AE           ;1 OR GREATER, BASE IS OK
        STA     $C9AF

        LDA     #$7F            ;SAUCER YX COORDS
        STA     $C9B0
        LDA     #$80
        STA     $C9B1
        LDA     #$00
        STA     $C9B2
        LDA     #$01
        STA     $C9B3
        LDA     #$00
        STA     $C9B4
        LDA     #$FF
        STA     $C9B6

        LDA     #$00
        STA     $C9BE           ;PLAYER 0=OK 1+=DEAD!
        STA     $C9C7           ;ANIMATION COUNTER
        
        LDX     #VADE1A
        STX     VROW1
        LDX     #VADE2A
        STX     VROW2
        LDX     #VADE3A
        STX     VROW3

        LDB     #$01            ;MOVE INVADERS TO VERTICAL POSITION
VSTART  CMPB    $C9CA           ;DETERMINED BY SKILL LEVEL
        BEQ     VPASS
        JSR     VERT
        INCB
        DEC     $C929
        BNE     VSTART
        LDA     #$0A
        STA     $C929

VPASS   JSR     SETEF1          ;SET ENEMY MISSILE LOCATIONS
        JSR     SETEF2          ;SET ENEMY MISSILE LOCATIONS
        JSR     SETEF3          ;SET ENEMY MISSILE LOCATIONS
        
        LDA     #$00            ;SIZE OF EXPLOSION
        STA     $C9CB
        LDA     #$00            ;DIRECTION OF EXPLOSION
        STA     $C9CC
        STA     $C9CD
        LDA     #$FC
        STA     $C82A
        LDU     #MUSIC1
        STU     $C9D0
        LDA     #$7F
        STA     $C9D2

        LDD     #$0000
        STD     $C9D6
        LDX     #$C9D6
        JSR     $F84F           ;INIT LEVEL COUNTER
        LDA     $C9C9
        STA     $C9E8

LEVLOOP LDD     #$0001
        LDX     #$C9D6          ;SET UP LEVEL DISPLAY
        JSR     $F87C
        DEC     $C9E8
        LDA     $C9E8
        CMPA    #$00
        BEQ     LOOP
        BRA     LEVLOOP

LOOP    LDA     #$60
        JSR     ZAXTOA
        LDA     $C9D3
        CMPA    #$01
        BEQ     LOOPP
        LDX     #$C8B0
        LDU     #$C8D0
        JSR     $F8C7
        CMPA    #$01
        BNE     LOOPP
        LDU     #BONUS 
        STU     $C9D0
        LDB     #$01
        STB     $C856
        LDA     #$01
        STA     $C9D3
        INC     $C9BD
        LDA     #$7F
        STA     $C9D2
LOOPP   LDX     #$C8B0
        LDU     #$CBEB
        JSR     $F8D8
        JSR     DPTOC8
        LDU     $C9D0
        JSR     $F687
        JSR     WAITRCL         ;WAIT FOR END OF CYCLE
        JSR     $F289
        JSR     MAKERND

        JSR     SHOWSCR
        LDA     $C9B9
        CMPA    #$00
        BNE     SHOSKP
        LDA     $C9D2
        CMPA    #$00
        BEQ     SHOSKP
        JSR     SHOSHPS
        DEC     $C9D2
SHOSKP  LDA     $C9B9
        CMPA    #$00
        BNE     POORSA
BASEDR  LDA     $C9CD
        CMPA    #$00
        BNE     SAUCSE
        LDX     #MOLPOS
        JSR     MVD85           ;MOVE TO NEW LOCATION
        LDX     #BASE
        LDB     #$20            ;GET MAGNIFICATION
        JSR     DRWL1B          ;DRAW THE BASE
	JSR	RES0RF		;BACK TO ORIGIN

SAUCSE  LDA     $C9BE
        CMPA    #$00
        BEQ     POORSA
        LDX     #MOLPOS         ;DRAW THE BOOM IF DEAD
        JSR     MVD85           ;MOVE TO NEW LOCATION
        LDX     #BOOM
        LDB     $C9CB            ;GET MAGNIFICATION
        JSR     DRWL1B          ;DRAW THE BASE
	JSR	RES0RF		;BACK TO ORIGIN
        LDY     #$40
BETL1   INC     $C9CB
        LEAY    -1,Y
        BNE     BETL1
        LDA     $C9CB
        CMPA    #$E0
        BNE     SAUSBR
        LDA     #$01
        STA     $C9CC
        BRA     SAUSBR
SAUSBR  DEC     $C9BE           ;KILL PLAYER
        LDA     $C9BE
        CMPA    #$00
        BNE     POORSA
        JSR     NEWLIFE

POORSA  LDA     $C9B3           ;CHECK TO SEE IF WE SHOW SAUCER BONUS
        CMPA    #$01
        BEQ     DTS1
        CMPA    #$00
        BEQ     DTS1
        JSR     SHOWBON
        INC     $C9B3
        LDA     $C9B3
        CMPA    #$FF
        BNE     MDRAWR
        LDA     #$00
        STA     $C9B3
        LDA     #$80
        STA     $C9B1
        LDA     #$00
        STA     $C9B2
        LDA     #$FF
        STA     $C9B6
DTS1    LDA     $C9B6           ;SAUCER ROUTINE
        CMPA    #$00
        BEQ     DRSA1
        DEC     $C9B6
        LDA     $C9B6
        CMPA    #$00
        BNE     MDRAWR
        LDA     #$01
        STA     $C9B3
        JMP     MDRAWR
DRSA1   LDX     #$C9B0         ;DRAW THE SAUCER
        JSR     MVD85
        LDX     #SAUCER          
        LDB     #$60             
        JSR     DRWL1B
        JSR     RES0RF
        LDA     $C9B2           ;CHECK WHICH DIRECTION HE'S GOING
        CMPA    #$00
        BNE     SLEFT
        INC     $C9B1
        LDA     $C9B1
        CMPA    #$7F
        BNE     MDRAWR
        LDA     #$01            ;CHANGE HIS DIRECTION
        STA     $C9B2
        LDA     #$FF
        STA     $C9B6
        JMP     MDRAWR
SLEFT   DEC     $C9B1
        LDA     $C9B1
        CMPA    #$80
        BNE     MDRAWR
        LDA     #$00
        STA     $C9B2
        LDA     #$FF
        STA     $C9B6
MDRAWR  LDA     $C922           ;MISSILE DRAW ROUTINE
        CMPA    #$00
        BEQ     PASS1
        LDX     #MISPOS         
        JSR     MVD85           
        LDX     #MISSL          
        LDB     #$04            
        JSR     DRWL1B          
        JSR     RES0RF          

PASS1   LDA     $C924
        CMPA    #$00
        BNE     PASS1Z
        JMP     INVGT
PASS1Z  LDA     #$01
        CMPA    $C980
        BEQ     PASS02
        LDX     #$C930         ;DRAW THE INVADERS ROUTINE
        JSR     MVD85
        LDX     VROW1
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS02  LDA     #$01
        CMPA    $C981
        BEQ     PASS03
        LDX     #$C932         ;DRAW #2
        JSR     MVD85
        LDX     VROW1
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS03  LDA     #$01           ;DRAW #3
        CMPA    $C982
        BEQ     PASS04
        LDX     #$C934         
        JSR     MVD85
        LDX     VROW1
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS04  LDA     #$01           ;DRAW #4
        CMPA    $C983
        BEQ     PASS05
        LDX     #$C936         
        JSR     MVD85
        LDX     VROW1
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS05  LDA     #$01           ;DRAW #5
        CMPA    $C984
        BEQ     PASS06
        LDX     #$C938         
        JSR     MVD85
        LDX     VROW1
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS06  LDA     #$01           ;DRAW #1
ROW2    CMPA    $C985
        BEQ     PASS07
        LDX     #$C940          
        JSR     MVD85
        LDX     VROW2
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS07  LDA     #$01           ;DRAW #2
        CMPA    $C986
        BEQ     PASS08
        LDX     #$C942         
        JSR     MVD85
        LDX     VROW2
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS08  LDA     #$01           ;DRAW #3
        CMPA    $C987
        BEQ     PASS09
        LDX     #$C944
        JSR     MVD85
        LDX     VROW2
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS09  LDA     #$01           ;DRAW #4
        CMPA    $C988
        BEQ     PASS10
        LDX     #$C946
        JSR     MVD85
        LDX     VROW2
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS10  LDA     #$01           ;DRAW #5
        CMPA    $C989
        BEQ     PASS11
        LDX     #$C948
        JSR     MVD85
        LDX     VROW2
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS11  LDA     #$01           ;DRAW #1
ROW3    CMPA    $C98A
        BEQ     PASS12
        LDX     #$C950        
        JSR     MVD85
        LDX     VROW2
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS12  LDA     #$01           ;DRAW #2
        CMPA    $C98B
        BEQ     PASS13
        LDX     #$C952       
        JSR     MVD85
        LDX     VROW2
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS13  LDA     #$01           ;DRAW #3
        CMPA    $C98C
        BEQ     PASS14
        LDX     #$C954      
        JSR     MVD85
        LDX     VROW2
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS14  LDA     #$01           ;DRAW #4
        CMPA    $C98D
        BEQ     PASS15
        LDX     #$C956 
        JSR     MVD85
        LDX     VROW2
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS15  LDA     #$01           ;DRAW #5
        CMPA    $C98E
        BEQ     PASS16
        LDX     #$C958 
        JSR     MVD85
        LDX     VROW2
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
PASS16  LDA     #$01           ;DRAW #1
ROW4    CMPA    $C98F
        BEQ     PASS17
        LDX     #$C960
        JSR     MVD85
        LDX     VROW3
        LDB     #$50             
        JSR     DRWL1B
        JSR     RES0RF
PASS17  LDA     #$01           ;DRAW #2
        CMPA    $C990
        BEQ     PASS18
        LDX     #$C962
        JSR     MVD85
        LDX     VROW3
        LDB     #$50             
        JSR     DRWL1B
        JSR     RES0RF
PASS18  LDA     #$01           ;DRAW #3
        CMPA    $C991
        BEQ     PASS19
        LDX     #$C964
        JSR     MVD85
        LDX     VROW3
        LDB     #$50             
        JSR     DRWL1B
        JSR     RES0RF
PASS19  LDA     #$01           ;DRAW #4
        CMPA    $C992
        BEQ     PASS20
        LDX     #$C966
        JSR     MVD85
        LDX     VROW3
        LDB     #$50             
        JSR     DRWL1B
        JSR     RES0RF
PASS20  LDA     #$01           ;DRAW #5
        CMPA    $C993
        BEQ     PASS21
        LDX     #$C968        
        JSR     MVD85
        LDX     VROW3
        LDB     #$50             
        JSR     DRWL1B
        JSR     RES0RF
PASS21  LDA     #$01           ;DRAW #1
ROW5    CMPA    $C994
        BEQ     PASS22
        LDX     #$C970
        JSR     MVD85
        LDX     VROW3
        LDB     #$50             
        JSR     DRWL1B
        JSR     RES0RF
PASS22  LDA     #$01           ;DRAW #2
        CMPA    $C995
        BEQ     PASS23
        LDX     #$C972
        JSR     MVD85
        LDX     VROW3
        LDB     #$50             
        JSR     DRWL1B
        JSR     RES0RF
PASS23  LDA     #$01           ;DRAW #3
        CMPA    $C996
        BEQ     PASS24
        LDX     #$C974
        JSR     MVD85
        LDX     VROW3
        LDB     #$50             
        JSR     DRWL1B
        JSR     RES0RF
PASS24  LDA     #$01           ;DRAW #4
        CMPA    $C997
        BEQ     PASS25
        LDX     #$C976
        JSR     MVD85
        LDX     VROW3
        LDB     #$50             
        JSR     DRWL1B
        JSR     RES0RF
PASS25  LDA     #$01           ;DRAW #5
        CMPA    $C998
        BEQ     PASS26
        LDX     #$C978
        JSR     MVD85
        LDX     VROW3
        LDB     #$50             
        JSR     DRWL1B
        JSR     RES0RF
PASS26

INVLGK  LDA     #$00
        ADDA    $C980
        ADDA    $C985
        ADDA    $C98A
        ADDA    $C98F
        ADDA    $C994
        CMPA    #$05
        BNE     COLCK04         ; SKIP THE REST !!!!
        LDA     #$75
        STA     $C9B7
COLCK01 
        LDA     #$00
        ADDA    $C981
        ADDA    $C986
        ADDA    $C98B
        ADDA    $C990
        ADDA    $C995 
        CMPA    #$05
        BNE     COLCK04         ; SKIP THE REST !!!!
        LDA     #$6D
        STA     $C9B7
COLCK02 
        LDA     #$00
        ADDA    $C982
        ADDA    $C987
        ADDA    $C98C
        ADDA    $C991
        ADDA    $C996 
        CMPA    #$05
        BNE     COLCK04         ; SKIP THE REST !!!!
        LDA     #$65
        STA     $C9B7
COLCK03 
        LDA     #$00
        ADDA    $C983
        ADDA    $C988
        ADDA    $C98D
        ADDA    $C992
        ADDA    $C997 
        CMPA    #$05
        BNE     COLCK04         ; SKIP THE REST !!!!
        LDA     #$5D
        STA     $C9B7
COLCK04
        LDA     #$00
        ADDA    $C984
        ADDA    $C989
        ADDA    $C98E
        ADDA    $C993
        ADDA    $C998
        CMPA    #$05
        BNE     COLCK08         ; SKIP THE REST !!!!
        LDA     #$AC
        STA     $C9B8
COLCK05
        LDA     #$00
        ADDA    $C983
        ADDA    $C988
        ADDA    $C98D
        ADDA    $C992
        ADDA    $C997
        CMPA    #$05
        BNE     COLCK08         ; SKIP THE REST !!!!
        LDA     #$B2
        STA     $C9B8
COLCK06
        LDA     #$00
        ADDA    $C982
        ADDA    $C987
        ADDA    $C98C
        ADDA    $C991
        ADDA    $C996
        CMPA    #$05
        BNE     COLCK08         ; SKIP THE REST !!!!
        LDA     #$BA
        STA     $C9B8
COLCK07
        LDA     #$00
        ADDA    $C981
        ADDA    $C986
        ADDA    $C98B
        ADDA    $C990
        ADDA    $C995
        CMPA    #$05
        BNE     COLCK08         ; SKIP THE REST !!!!
        LDA     #$C2
        STA     $C9B8
COLCK08
        JSR     CHKBROW         ;CHECK BOTTOM ROW BOUNDARIES
        DEC     $C925           ;STOMP SPEED
        BNE     CHEAP
        LDA     $C9C8
        STA     $C925
        LDA     $C928
        CMPA    #$01
        BEQ     LEFT
INVSKP  INC     $C931
        INC     $C941
        INC     $C951
        INC     $C961
        INC     $C971
        INC     $C933
        INC     $C943
        INC     $C953
        INC     $C963
        INC     $C973
        INC     $C935
        INC     $C945
        INC     $C955
        INC     $C965
        INC     $C975
        INC     $C937
        INC     $C947
        INC     $C957
        INC     $C967
        INC     $C977
        INC     $C939
        INC     $C949
        INC     $C959
        INC     $C969
        INC     $C979
        DEC     $C927
        BNE     INVSKP
        INC     $C9BA
        LDA     #$03
        STA     $C927
        JSR     ANIM01
CHEAP   JMP     INVPS1
LEFT    DEC     $C931
        DEC     $C941
        DEC     $C951
        DEC     $C961
        DEC     $C971
        DEC     $C933
        DEC     $C943
        DEC     $C953
        DEC     $C963
        DEC     $C973
        DEC     $C935
        DEC     $C945
        DEC     $C955
        DEC     $C965
        DEC     $C975
        DEC     $C937
        DEC     $C947
        DEC     $C957
        DEC     $C967
        DEC     $C977
        DEC     $C939
        DEC     $C949
        DEC     $C959
        DEC     $C969
        DEC     $C979
        DEC     $C927
        BNE     LEFT  
        DEC     $C9BA
        LDA     #$03
        STA     $C927
        JSR     ANIM01
        JMP     INVPS2
INVPS1  LDA     $C9BA           ;CHECK LEFT BOUNDARY
        CMPA    $C9B8
        BNE     INVPS3
        LDA     #$01
        STA     $C928
        JSR     VERT
        LDA     #$01            ;RESET STEP COUNTER
        STA     $C925
        JMP     INVPS3
INVPS2  LDA     $C9BA           ;CHECK RIGHT BOUNDARY
        CMPA    $C9B7
        BNE     INVPS3
        LDA     #$00
        STA     $C928
        JSR     VERT
        LDA     #$01            ;RESET STEP COUNTER
        STA     $C925
INVPS3  LDA     $C9B9
        CMPA    #$00
        BEQ     INVGT
        JMP     SKIP4A
INVGT   LDA     $C9CD
        CMPA    #$00
        BEQ     CHKSWZ
        JMP     SKIP4A
CHKSWZ  CLRA                    ;CHECK SWITCHES, MOVE THE BASE
        JSR     SWITCHS
        LDA     $C904
        CMPA    #$A0
        BEQ     SKIP1
        TST     SW11
        BEQ     SKIP1
        JSR     MAKERND
        DEC     $C904
        DEC     $C904

SKIP1   LDA     $C904
        CMPA    #$50
        BEQ     SKIP2
        TST     SW12
        BEQ     SKIP2
        JSR     MAKERND
        INC     $C904
        INC     $C904

SKIP2   LDA     $C922           ;CHECK TO SEE IF MISSILE IS FIRING
        CMPA    #$01
        BNE     SKIP3           ;BRANCH IF NOT
        INC     $C905           ;FIRING ROUTINE GOES HERE
        INC     $C905
        INC     $C905
        DEC     $C921           ;DECREMENT MISSILE COUNTER
        DEC     $C921
        DEC     $C921
        LDA     $C921
        CMPA    #$00
        BEQ     MREST
        BRA     SKIP3
MREST   LDA     #$00            ;MISSILE REACHES TOP, RESET IT.
        STA     $C922
        STA     $C921

SKIP3   LDA     $C922
        CMPA    #$01
        BEQ     SKIP4
        TST     SW14
        BEQ     SKIP4
        LDU     #MUSIC4
        STU     $C9D0
        JSR     CKSND           ;MAKE THE MISSILE SOUND, BUT MAKE SURE
        LDA     #$01            ;NO OTHER SOUNDS ARE PLAYING FIRST
        STA     $C922
        LDA     #$FF
        STA     $C921
        LDA     #$80
        STA     $C905
        LDA     $C904
        STA     $C906

SKIP4   NOP
        NOP
        NOP
        NOP

SKIP5   LDA     $C922
        CMPA    #$01
        BEQ     SKIP4A
        JMP     MCK26
SKIP4A  LDA     #$01            ;HERE WE GO - CHECK THE MISSILE
XXXXX   CMPA    $C980           ;AGAINST INVADER POSITIONS
        BEQ     MCK02           ;CHECK INVADER #1
        LDD     #$0808
        LDX     $C905
        LDY     $C930
        JSR     $F8FF
        BLO     KIL01
        BRA     MCK02
KIL01   JSR     ADD30
        LDA     #$01
        STA     $C980
        JSR     MISOFF
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C930
        STA     $C92A
        LDA     $C931
        STA     $C92B
MCK02   LDA     #$01            ;CHECK INVADER #2
        CMPA    $C981           
        BEQ     MCK03           
        LDD     #$0808
        LDX     $C905
        LDY     $C932
        JSR     $F8FF
        BLO     KIL02
        BRA     MCK03
KIL02   JSR     ADD30
        LDA     #$01
        STA     $C981
        JSR     MISOFF
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C932
        STA     $C92A
        LDA     $C933
        STA     $C92B
MCK03   LDA     #$01            ;CHECK INVADER #3
        CMPA    $C982           
        BEQ     MCK04           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C934           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL03           ;A HIT - KILL INVADER
        BRA     MCK04           ;NO HIT - CHECK NEXT ONE !
KIL03   JSR     ADD30
        LDA     #$01            ;SET INVADER
        STA     $C982           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C934
        STA     $C92A
        LDA     $C935
        STA     $C92B
MCK04   LDA     #$01            ;CHECK INVADER #4
        CMPA    $C983           
        BEQ     MCK05           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C936           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL04           ;A HIT - KILL INVADER
        BRA     MCK05           ;NO HIT - CHECK NEXT ONE !
KIL04   JSR     ADD30
        LDA     #$01            ;SET INVADER
        STA     $C983           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C936
        STA     $C92A
        LDA     $C937
        STA     $C92B
MCK05   LDA     #$01            ;CHECK INVADER #5
        CMPA    $C984        
        BEQ     MCK06           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C938           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL05           ;A HIT - KILL INVADER
        BRA     MCK06           ;NO HIT - CHECK NEXT ONE !
KIL05   JSR     ADD30
        LDA     #$01            ;SET INVADER
        STA     $C984           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C938
        STA     $C92A
        LDA     $C939
        STA     $C92B
MCK06   LDA     #$01            ;CHECK INVADER #6
        CMPA    $C985        
        BEQ     MCK07           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C940           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL06           ;A HIT - KILL INVADER
        BRA     MCK07           ;NO HIT - CHECK NEXT ONE !
KIL06   JSR     ADD20
        LDA     #$01            ;SET INVADER
        STA     $C985           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C940
        STA     $C92A
        LDA     $C941
        STA     $C92B
MCK07   LDA     #$01            ;CHECK INVADER #7
        CMPA    $C986        
        BEQ     MCK08           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C942           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL07           ;A HIT - KILL INVADER
        BRA     MCK08           ;NO HIT - CHECK NEXT ONE !
KIL07   JSR     ADD20
        LDA     #$01            ;SET INVADER
        STA     $C986           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C942
        STA     $C92A
        LDA     $C943
        STA     $C92B
MCK08   LDA     #$01            ;CHECK INVADER #8
        CMPA    $C987        
        BEQ     MCK09           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C944           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL08           ;A HIT - KILL INVADER
        BRA     MCK09           ;NO HIT - CHECK NEXT ONE !
KIL08   JSR     ADD20
        LDA     #$01            ;SET INVADER
        STA     $C987           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C944
        STA     $C92A
        LDA     $C945
        STA     $C92B
MCK09   LDA     #$01            ;CHECK INVADER #9
        CMPA    $C988        
        BEQ     MCK10           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C946           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL09           ;A HIT - KILL INVADER
        BRA     MCK10           ;NO HIT - CHECK NEXT ONE !
KIL09   JSR     ADD20
        LDA     #$01            ;SET INVADER
        STA     $C988           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C946
        STA     $C92A
        LDA     $C947
        STA     $C92B
MCK10   LDA     #$01            ;CHECK INVADER #10
        CMPA    $C989        
        BEQ     MCK11           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C948           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL10           ;A HIT - KILL INVADER
        BRA     MCK11           ;NO HIT - CHECK NEXT ONE !
KIL10   JSR     ADD20
        LDA     #$01            ;SET INVADER
        STA     $C989           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C948
        STA     $C92A
        LDA     $C949
        STA     $C92B
MCK11   LDA     #$01            ;CHECK INVADER #11
        CMPA    $C98A        
        BEQ     MCK12           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C950           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL11           ;A HIT - KILL INVADER
        BRA     MCK12           ;NO HIT - CHECK NEXT ONE !
KIL11   JSR     ADD20
        LDA     #$01            ;SET INVADER
        STA     $C98A           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C950
        STA     $C92A
        LDA     $C951
        STA     $C92B
MCK12   LDA     #$01            ;CHECK INVADER #12
        CMPA    $C98B        
        BEQ     MCK13           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C952           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL12           ;A HIT - KILL INVADER
        BRA     MCK13           ;NO HIT - CHECK NEXT ONE !
KIL12   JSR     ADD20
        LDA     #$01            ;SET INVADER
        STA     $C98B           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C952
        STA     $C92A
        LDA     $C953
        STA     $C92B
MCK13   LDA     #$01            ;CHECK INVADER #13
        CMPA    $C98C        
        BEQ     MCK14           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C954           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL13           ;A HIT - KILL INVADER
        BRA     MCK14           ;NO HIT - CHECK NEXT ONE !
KIL13   JSR     ADD20
        LDA     #$01            ;SET INVADER
        STA     $C98C           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C954
        STA     $C92A
        LDA     $C955
        STA     $C92B
MCK14   LDA     #$01            ;CHECK INVADER #14
        CMPA    $C98D        
        BEQ     MCK15           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C956           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL14           ;A HIT - KILL INVADER
        BRA     MCK15           ;NO HIT - CHECK NEXT ONE !
KIL14   JSR     ADD20
        LDA     #$01            ;SET INVADER
        STA     $C98D           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C956
        STA     $C92A
        LDA     $C957
        STA     $C92B
MCK15   LDA     #$01            ;CHECK INVADER #15
        CMPA    $C98E        
        BEQ     MCK16           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C958           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL15           ;A HIT - KILL INVADER
        BRA     MCK16           ;NO HIT - CHECK NEXT ONE !
KIL15   JSR     ADD20
        LDA     #$01            ;SET INVADER
        STA     $C98E           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C958
        STA     $C92A
        LDA     $C959
        STA     $C92B
MCK16   LDA     #$01            ;CHECK INVADER #16
        CMPA    $C98F        
        BEQ     MCK17           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C960           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL16           ;A HIT - KILL INVADER
        BRA     MCK17           ;NO HIT - CHECK NEXT ONE !
KIL16   JSR     ADD10
        LDA     #$01            ;SET INVADER
        STA     $C98F           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C960
        STA     $C92A
        LDA     $C961
        STA     $C92B
MCK17   LDA     #$01            ;CHECK INVADER #17
        CMPA    $C990        
        BEQ     MCK18           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C962           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL17           ;A HIT - KILL INVADER
        BRA     MCK18           ;NO HIT - CHECK NEXT ONE !
KIL17   JSR     ADD10
        LDA     #$01            ;SET INVADER
        STA     $C990           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C962
        STA     $C92A
        LDA     $C963
        STA     $C92B
MCK18   LDA     #$01            ;CHECK INVADER #18
        CMPA    $C991        
        BEQ     MCK19           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C964           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL18           ;A HIT - KILL INVADER
        BRA     MCK19           ;NO HIT - CHECK NEXT ONE !
KIL18   JSR     ADD10
        LDA     #$01            ;SET INVADER
        STA     $C991           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C964
        STA     $C92A
        LDA     $C965
        STA     $C92B
MCK19   LDA     #$01            ;CHECK INVADER #19
        CMPA    $C992
        BEQ     MCK20           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C966           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL19           ;A HIT - KILL INVADER
        BRA     MCK20           ;NO HIT - CHECK NEXT ONE !
KIL19   JSR     ADD10
        LDA     #$01            ;SET INVADER
        STA     $C992           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C966
        STA     $C92A
        LDA     $C967
        STA     $C92B
MCK20   LDA     #$01            ;CHECK INVADER #20
        CMPA    $C993
        BEQ     MCK21           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C968           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL20           ;A HIT - KILL INVADER
        BRA     MCK21           ;NO HIT - CHECK NEXT ONE !
KIL20   JSR     ADD10
        LDA     #$01            ;SET INVADER
        STA     $C993           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C968
        STA     $C92A
        LDA     $C969
        STA     $C92B
MCK21   LDA     #$01            ;CHECK INVADER #21
        CMPA    $C994
        BEQ     MCK22           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C970           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL21           ;A HIT - KILL INVADER
        BRA     MCK22           ;NO HIT - CHECK NEXT ONE !
KIL21   JSR     ADD10
        LDA     #$01            ;SET INVADER
        STA     $C994           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C970
        STA     $C92A
        LDA     $C971
        STA     $C92B
MCK22   LDA     #$01            ;CHECK INVADER #22
        CMPA    $C995
        BEQ     MCK23           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C972           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL22           ;A HIT - KILL INVADER
        BRA     MCK23           ;NO HIT - CHECK NEXT ONE !
KIL22   JSR     ADD10
        LDA     #$01            ;SET INVADER
        STA     $C995           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C972
        STA     $C92A
        LDA     $C973
        STA     $C92B
MCK23   LDA     #$01            ;CHECK INVADER #23
        CMPA    $C996
        BEQ     MCK24           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C974           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL23           ;A HIT - KILL INVADER
        BRA     MCK24           ;NO HIT - CHECK NEXT ONE !
KIL23   JSR     ADD10
        LDA     #$01            ;SET INVADER
        STA     $C996           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C974
        STA     $C92A
        LDA     $C975
        STA     $C92B
MCK24   LDA     #$01            ;CHECK INVADER #24
        CMPA    $C997
        BEQ     MCK25           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C976           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL24           ;A HIT - KILL INVADER
        BRA     MCK25           ;NO HIT - CHECK NEXT ONE !
KIL24   JSR     ADD10
        LDA     #$01            ;SET INVADER
        STA     $C997           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C976
        STA     $C92A
        LDA     $C977
        STA     $C92B
MCK25   LDA     #$01            ;CHECK INVADER #25
        CMPA    $C998
        BEQ     MCK26           
        LDD     #$0808
        LDX     $C905           ;MISSILE XY
        LDY     $C978           ;INVADER XY
        JSR     $F8FF           ;JUMP TO COLLISION DETECT
        BLO     KIL25           ;A HIT - KILL INVADER
        BRA     MCK26           ;NO HIT - CHECK NEXT ONE !
KIL25   JSR     ADD10
        LDA     #$01            ;SET INVADER
        STA     $C998           ;TO DEAD STATUS
        JSR     MISOFF          ;SHUT OFF MISSILE
        JSR     DECINV
        LDA     #$15
        STA     $C92C
        LDA     $C978
        STA     $C92A
        LDA     $C979
        STA     $C92B

MCK26   LDA     $C92C           ;CHECK TO SEE IF DEAD INVADER HAS TO BE DRAWN
        CMPA    #$00
        BEQ     MORE1
        LDX     #$C92A         
        JSR     MVD85
        LDX     #HIT             
        LDB     #$40             
        JSR     DRWL1B
        JSR     RES0RF
        DEC     $C92C

MORE1   LDA     #$3F
        JSR     ZAXTOA
        LDA     $C9AC          ;DRAW BUNKER 1
        CMPA    #$00
        BEQ     MORE2
        LDX     #$C999
        JSR     MVD85
        LDX     #FORT            
        LDB     #$A0             
        JSR     DRWL1B
        JSR     RES0RF
MORE2   LDA     $C9AD          ;DRAW BUNKER 2
        CMPA    #$00
        BEQ     MORE3
        LDX     #$C99B         
        JSR     MVD85
        LDX     #FORT            
        LDB     #$A0             
        JSR     DRWL1B
        JSR     RES0RF
MORE3   LDA     $C9AE          ;DRAW BUNKER 3
        CMPA    #$00
        BEQ     MORE4
        LDX     #$C99D         
        JSR     MVD85
        LDX     #FORT            
        LDB     #$A0             
        JSR     DRWL1B
        JSR     RES0RF
MORE4   LDA     $C9AF          ;DRAW BUNKER 4
        CMPA    #$00
        BEQ     CHKMI
        LDX     #$C99F
        JSR     MVD85
        LDX     #FORT            
        LDB     #$A0             
        JSR     DRWL1B
        JSR     RES0RF
CHKMI   LDA     #$60
        JSR     ZAXTOA
        LDA     $C922
        CMPA    #$01
        BEQ     CHKMIZ
        JMP     CHKMI8

CHKMIZ  LDA     $C9B3           ;CHECK HIT SAUCER
        CMPA    #$01
        BEQ     CHKMNO
        JMP     CHKMI0
CHKMNO  LDD     #$0808
        LDX     $C905
        LDY     $C9B0
        JSR     $F8FF
        BLO     HITSAU
        BRA     CHKMI0
HITSAU  LDU     #MUSIC5
        STU     $C9D0
        LDB     #$01
        STB     $C856                
        LDA     #$D0
        STA     $C9B3
        LDA     $C9B4
        CMPA    #$00
        BNE     SAU1
        JSR     ADD300
        BRA     SAUZ
SAU1    LDA     $C9B4
        CMPA    #$01
        BNE     SAU2
        JSR     ADD150
        BRA     SAUZ
SAU2    LDA     $C9B4
        CMPA    #$02
        BNE     SAU3
        JSR     ADD100
        BRA     SAUZ
SAU3    JSR     ADD50
SAUZ    LDA     $C9B4
        STA     $C9B5
        JSR     MISOFF
CHKMI0  LDA     $C9AC           ;CHECK MISSILE HIT BUNKERS
        CMPA    #$00
        BEQ     CHKMI2
        LDD     #$0808
        LDX     $C905
        LDY     $C999
        JSR     $F8FF
        BLO     CHKMI1
        BRA     CHKMI2
CHKMI1  
        JSR     MISOFF
        JSR     HITBU1
        NOP                     ;HIT BUNKER, TURN IT OFF
CHKMI2  LDA     $C9AD
        CMPA    #$00
        BEQ     CHKMI4
        LDD     #$0808          ;CHECK MISSILE HIT BUNKERS
        LDX     $C905
        LDY     $C99B
        JSR     $F8FF
        BLO     CHKMI3
        BRA     CHKMI4
CHKMI3  
        JSR     MISOFF
        JSR     HITBU2
        NOP                     ;HIT BUNKER, TURN IT OFF
CHKMI4  LDA     $C9AE
        CMPA    #$00
        BEQ     CHKMI6
        LDD     #$0808          ;CHECK MISSILE HIT BUNKERS
        LDX     $C905
        LDY     $C99D
        JSR     $F8FF
        BLO     CHKMI5
        BRA     CHKMI6
CHKMI5  
        JSR     MISOFF
        JSR     HITBU3
        NOP                     ;HIT BUNKER, TURN IT OFF
CHKMI6  LDA     $C9AF
        CMPA    #$00
        BEQ     CHKMI8
        LDD     #$0808          ;CHECK MISSILE HIT BUNKERS
        LDX     $C905
        LDY     $C99F
        JSR     $F8FF
        BLO     CHKMI7
        BRA     CHKMI8
CHKMI7  
        JSR     MISOFF
        JSR     HITBU4          ;HIT BUNKER, TURN IT OFF
        NOP                     
CHKMI8  LDA     $C924
        CMPA    #$00
        BNE     CHKMI8A
        JMP     MWQ3
CHKMI8A LDX     #$C9A1          ;ENEMY FIRE ROUTINES
        JSR     MVD85           ;DRAW MISSILE 1
        LDX     #MISSL2
        LDB     #$01             
        JSR     DRWL1B
        JSR     RES0RF
        DEC     $C9A1
        DEC     $C9A1
        DEC     $C9A1
        LDA     $C9A1
MWO1    CMPA    #$80
        BEQ     MWP1
        CMPA    #$81
        BEQ     MWP1
        CMPA    #$82
        BEQ     MWP1
        CMPA    #$83
        BEQ     MWP1
        CMPA    #$84
        BEQ     MWP1
        BRA     MWQ00
MWP1    JSR     SETEF1

MWQ00   LDA     $C924
        CMPA    #$00
        BNE     MWQ0A
        JMP     MWQ4
MWQ0A   JSR     CEM1AB1
        JSR     CIFHIT          ;CHECK MISSILES AGAINST YOUR BASE
MWQ1    LDX     #$C9A4         ;DRAW MISSILE 2
        JSR     MVD85
        LDX     #MISSL
        LDB     #$04             
        JSR     DRWL1B
        JSR     RES0RF
        DEC     $C9A4
        DEC     $C9A4
        DEC     $C9A4
        LDA     $C9A4
        CMPA    #$80
        BEQ     MWP2
        CMPA    #$81
        BEQ     MWP2
        CMPA    #$82
        BEQ     MWP2
        CMPA    #$83
        BEQ     MWP2
        CMPA    #$84
        BEQ     MWP2
        BRA     MWQ2 
MWP2    JSR     SETEF2
MWQ2    LDX     #$C9A7         ;DRAW MISSILE 3
        JSR     MVD85
        LDX     #MISSL
        LDB     #$04             
        JSR     DRWL1B
        JSR     RES0RF
        DEC     $C9A7
        DEC     $C9A7
        DEC     $C9A7
        LDA     $C9A7
        CMPA    #$80
        BEQ     MWP3
        CMPA    #$81
        BEQ     MWP3
        CMPA    #$82
        BEQ     MWP3
        CMPA    #$83
        BEQ     MWP3
        CMPA    #$84
        BEQ     MWP3
        BRA     MWQ3
MWP3    JSR     SETEF3

MWQ3    LDA     $C9BC
        CMPA    #$00
        BEQ     MWQ4
        DEC     $C9BC
        LDA     $C9BC
        CMPA    #$01
        BNE     MWQ4
        JMP     NEWLEV
MWQ4    LDA     $C9B9
        CMPA    #$01
        BEQ     GOWAIT
        BRA     LOOP
GOWAIT  JSR     GO              ;GAME OVER. CHECK SW13 TO RESTART GAME
        JSR     SWITCHS
        TST     SW13
        BNE     GWAIT1
        BRA     LOOP
GWAIT1  LDA     #$00            ;SETUP TO RESTART GAME
        STA     $C9B9
COMPLE  JMP     START1
VERT    LDA     $C9BE
        CMPA    #$00
        BEQ     VERT0
        RTS
VERT0   LDA     $C9B9
        CMPA    #$00
        BEQ     VERT1
        RTS
VERT1   DEC     $C930           ;Y COORDS
        DEC     $C932
        DEC     $C934
        DEC     $C936
        DEC     $C938
        DEC     $C940
        DEC     $C942
        DEC     $C944
        DEC     $C946
        DEC     $C948
        DEC     $C950
        DEC     $C952
        DEC     $C954
        DEC     $C956
        DEC     $C958
        DEC     $C960
        DEC     $C962
        DEC     $C964
        DEC     $C966
        DEC     $C968
        DEC     $C970
        DEC     $C972
        DEC     $C974
        DEC     $C976
        DEC     $C978
        DEC     $C929
        BNE     VERT
        LDA     #$0A
        STA     $C929
LARS    LDA     $C9CE           ;CHECK IF LAST ROW OF INVADERS
        CMPA    #$05            ;HITS THE BOTTOM OF THE SCREEN
        BNE     LAB1A
        LDA     $C970
        STA     $C9CF
        JMP     LAB1
LAB1A   LDA     $C9CE
        CMPA    #$04
        BNE     LAB1B
        LDA     $C960
        STA     $C9CF
        JMP     LAB1
LAB1B   LDA     $C9CE
        CMPA    #$03
        BNE     LAB1C
        LDA     $C950
        STA     $C9CF
        JMP     LAB1
LAB1C   LDA     $C9CE
        CMPA    #$02
        BNE     LAB1D
        LDA     $C940
        STA     $C9CF
        JMP     LAB1
LAB1D   LDA     $C9CE
        CMPA    #$01
        BNE     LAB1 
        LDA     $C930
        STA     $C9CF
LAB1    LDA     $C9CF           ;CHECK THE BOTTOM ROW
        CMPA    #$7F            ;NEXT ROUTINE SHOULD CHECK
        BPL     LAB2            ;AGAINST BUNKERS
        BRA     BAB1
LAB2    CMPA    #$90
        BMI     DIE
BAB1    LDA     $C9CF           ;CHECK THE BOTTOM ROW
        CMPA    #$7F            ;NEXT ROUTINE SHOULD CHECK
        BPL     BAB2            ;AGAINST BUNKERS
        RTS
BAB2    CMPA    #$a6
        BMI     NOBUNK
        RTS
NOBUNK  LDA     #$00
        STA     $C9AC
        STA     $C9AD
        STA     $C9AE
        STA     $C9AF
        RTS

DIE     LDA     #$01
        STA     $C9BD
        STA     $C9CD
        LDA     #$7F
        STA     $C9BE
        JSR     MISOFF
        LDU     #MUSIC6
        STU     $C9D0
        LDB     #$01
        STB     $C856
        RTS

MISOFF  LDA     #$00
        STA     $C922
        LDA     #$80
        STA     $C905
        LDA     #$7F
        STA     $C906
        RTS

SET01   LDA     $C924
        CMPA    #$00
        BNE     SET01A
        RTS
SET01A  LDA     $C92D
        CMPA    #$01
        BNE     SET02
        LDA     $C931  
        STA     $C9AB
        LDA     $C930  
        STA     $C9AA
        LDB     $C980
        JMP     GOTIT
SET02   CMPA    #$02
        BNE     SET03
        LDA     $C933  
        STA     $C9AB
        LDA     $C932  
        STA     $C9AA
        LDB     $C981
        JMP     GOTIT
SET03   CMPA    #$03
        BNE     SET04
        LDA     $C935  
        STA     $C9AB
        LDA     $C934  
        STA     $C9AA
        LDB     $C982
        JMP     GOTIT
SET04   CMPA    #$04
        BNE     SET05
        LDA     $C937  
        STA     $C9AB
        LDA     $C936  
        STA     $C9AA
        LDB     $C983
        JMP     GOTIT
SET05   CMPA    #$05
        BNE     SET06
        LDA     $C939  
        STA     $C9AB
        LDA     $C938  
        STA     $C9AA
        LDB     $C984
        JMP     GOTIT
SET06   CMPA    #$06
        BNE     SET07
        LDA     $C941  
        STA     $C9AB
        LDA     $C940  
        STA     $C9AA
        LDB     $C985
        JMP     GOTIT
SET07   CMPA    #$07
        BNE     SET08
        LDA     $C943  
        STA     $C9AB
        LDA     $C942  
        STA     $C9AA
        LDB     $C986
        JMP     GOTIT
SET08   CMPA    #$08
        BNE     SET09
        LDA     $C945  
        STA     $C9AB
        LDA     $C944  
        STA     $C9AA
        LDB     $C987
        JMP     GOTIT
SET09   CMPA    #$09
        BNE     SET10
        LDA     $C947  
        STA     $C9AB
        LDA     $C946  
        STA     $C9AA
        LDB     $C988
        JMP     GOTIT
SET10   CMPA    #$0A
        BNE     SET11
        LDA     $C949  
        STA     $C9AB
        LDA     $C948  
        STA     $C9AA
        LDB     $C989
        JMP     GOTIT
SET11   CMPA    #$0B
        BNE     SET12
        LDA     $C951  
        STA     $C9AB
        LDA     $C950  
        STA     $C9AA
        LDB     $C98A
        JMP     GOTIT
SET12   CMPA    #$0C
        BNE     SET13
        LDA     $C953  
        STA     $C9AB
        LDA     $C952  
        STA     $C9AA
        LDB     $C98B
        JMP     GOTIT
SET13   CMPA    #$0D
        BNE     SET14
        LDA     $C955  
        STA     $C9AB
        LDA     $C954  
        STA     $C9AA
        LDB     $C98C
        JMP     GOTIT
SET14   CMPA    #$0E
        BNE     SET15
        LDA     $C957  
        STA     $C9AB
        LDA     $C956  
        STA     $C9AA
        LDB     $C98D
        JMP     GOTIT
SET15   CMPA    #$0F
        BNE     SET16
        LDA     $C959  
        STA     $C9AB
        LDA     $C958  
        STA     $C9AA
        LDB     $C98E
        JMP     GOTIT
SET16   CMPA    #$10
        BNE     SET17
        LDA     $C961  
        STA     $C9AB
        LDA     $C960  
        STA     $C9AA
        LDB     $C98F
        JMP     GOTIT
SET17   CMPA    #$11
        BNE     SET18
        LDA     $C963  
        STA     $C9AB
        LDA     $C962  
        STA     $C9AA
        LDB     $C990
        JMP     GOTIT
SET18   CMPA    #$12
        BNE     SET19
        LDA     $C965  
        STA     $C9AB
        LDA     $C964  
        STA     $C9AA
        LDB     $C991
        JMP     GOTIT
SET19   CMPA    #$13
        BNE     SET20
        LDA     $C967  
        STA     $C9AB
        LDA     $C966  
        STA     $C9AA
        LDB     $C992
        JMP     GOTIT
SET20   CMPA    #$14
        BNE     SET21
        LDA     $C969  
        STA     $C9AB
        LDA     $C968  
        STA     $C9AA
        LDB     $C993
        JMP     GOTIT
SET21   CMPA    #$15
        BNE     SET22
        LDA     $C971  
        STA     $C9AB
        LDA     $C970  
        STA     $C9AA
        LDB     $C994
        JMP     GOTIT
SET22   CMPA    #$16
        BNE     SET23
        LDA     $C973  
        STA     $C9AB
        LDA     $C972  
        STA     $C9AA
        LDB     $C995
        JMP     GOTIT
SET23   CMPA    #$17
        BNE     SET24
        LDA     $C975  
        STA     $C9AB
        LDA     $C974  
        STA     $C9AA
        LDB     $C996
        JMP     GOTIT
SET24   CMPA    #$18
        BNE     SET25
        LDA     $C977  
        STA     $C9AB
        LDA     $C976  
        STA     $C9AA
        LDB     $C997 
        JMP     GOTIT
SET25   LDA     $C979  
        STA     $C9AB
        LDA     $C978  
        LDB     $C998
        STA     $C9AA
GOTIT   RTS
SETEF1  JSR     SET01
        CMPB    #$00
        BEQ     SETDF1
        JSR     MAKERND
        BRA     SETEF1
SETDF1  LDA     $C9AA
        STA     $C9A1
        LDA     $C9AB
        STA     $C9A2
        INC     $C92D
        RTS
SETEF2  JSR     MAKERND
        JSR     SET01
        CMPB    #$00
        BEQ     SETDF2
        BRA     SETEF2
SETDF2  LDA     $C9AA
        STA     $C9A4
        LDA     $C9AB
        STA     $C9A5
        RTS
SETEF3  JSR     MAKERND
SETEF3A JSR     MAKERND
        JSR     SET01
        CMPB    #$00
        BEQ     SETDF3
        BRA     SETEF3A
SETDF3  LDA     $C9AA
        STA     $C9A7
        LDA     $C9AB
        STA     $C9A8
        RTS

MAKERND INC     $C9B4
        LDA     $C9B4
        CMPA    #$04
        BNE     MAKERN2
        LDA     #$00
        STA     $C9B4
MAKERN2 INC     $C92D
        LDA     $C92D
        CMPA    #$1A
        BEQ     RESEED
        RTS
RESEED  
        LDA     #$00
        STA     $C92D
        RTS

HITBU1  LDA     $C9AC
        CMPA     #$00
        BNE     HITBU1A
        RTS
HITBU1A DEC     $C9AC
        RTS
HITBU2  LDA     $C9AD
        CMPA     #$00
        BNE     HITBU2A
        RTS
HITBU2A DEC     $C9AD
        RTS
HITBU3  LDA     $C9AE
        CMPA     #$00
        BNE     HITBU3A
        RTS
HITBU3A DEC     $C9AE
        RTS
HITBU4  LDA     $C9AF
        CMPA     #$00
        BNE     HITBU4A
        RTS
HITBU4A DEC     $C9AF
TOSHORT RTS

DECINV  DEC     $C924           ;ADD INVADER HIT SOUND HERE
        LDA     $C924
        CMPA    #$00
        BNE     DECINV1
        LDA     #$FF
        STA     $C9BC
        INC     $C9C9           ;INCREMENT SKILL LEVEL
        INC     $C9CA
        INC     $C9CA
        INC     $C9CA
        INC     $C9CA
        LDA     $C9CA
        CMPA    #$15
        BNE     DECINV1
        LDA     #$11
        STA     $C9CA
DECINV1 LDA     $C924
        CMPA    #$15
        BPL     TOSHORT
        CMPA    #$14
        BNE     DECI01
        LDA     #$0B
        STA     $C9C8
        RTS
DECI01  LDA     $C924
        CMPA    #$12
        BNE     DECI02
        LDA     #$0A
        STA     $C9C8
        RTS
DECI02  LDA     $C924
        CMPA    #$10
        BNE     DECI03
        LDA     #$09
        STA     $C9C8
        RTS
DECI03  LDA     $C924
        CMPA    #$0E
        BNE     DECI04
        LDA     #$08
        STA     $C9C8
        RTS
DECI04  LDA     $C924
        CMPA    #$0C
        BNE     DECI05
        LDA     #$07
        STA     $C9C8
        RTS
DECI05  LDA     $C924
        CMPA    #$0A
        BNE     DECI06
        LDA     #$06
        STA     $C9C8
        RTS
DECI06  LDA     $C924
        CMPA    #$08
        BNE     DECI07
        LDA     #$05
        STA     $C9C8
        RTS
DECI07  LDA     $C924
        CMPA    #$06
        BNE     DECI08
        LDA     #$05
        STA     $C9C8
        RTS
DECI08  LDA     $C924
        CMPA    #$04
        BNE     DECI09
        LDA     #$03
        STA     $C9C8
        RTS
DECI09  LDA     $C924
        CMPA    #$02
        BNE     DECI10
        LDA     #$02
        STA     $C9C8
        RTS
DECI10  LDA     $C924
        CMPA    #$01
        BNE     DECI11
        LDA     #$01
        STA     $C9C8
DECI11  RTS
        
SHOWBON LDA     #$FE
        STA     $C82A
        LDA     $C9B5
        CMPA    #$00
        BEQ     SHOWBO1
        CMPA    #$01
        BEQ     SHOWBO2
        CMPA    #$02
        BEQ     SHOWBO3
        CMPA    #$03
        BEQ     SHOWBO4
SHOWBO1 
        LDU     #B300
        JMP     SHOWBOZ
SHOWBO2 
        LDU     #B150
        JMP     SHOWBOZ
SHOWBO3 
        LDU     #B100
        JMP     SHOWBOZ
SHOWBO4 
        LDU     #B050
SHOWBOZ LDD     #0000
        LDA     $C9B0
        LDB     $C9B1
        JSR     $F37A
        RTS

ANIM01
        INC     $C9C7
        LDA     $C9C7
        CMPA    #$02
        BNE     ANIM02
        LDA     #$00
        STA     $C9C7
ANIM02  LDA     $C9C7
        CMPA    #$01
        BNE     ANIM03
        LDX     #VADE1B
        STX     VROW1
        LDX     #VADE2B
        STX     VROW2
        LDX     #VADE3B
        STX     VROW3
        RTS
ANIM03  LDX     #VADE1A
        STX     VROW1
        LDX     #VADE2A
        STX     VROW2
        LDX     #VADE3A
        STX     VROW3
        RTS

CEM1AB1 LDA     $C9AC           ;CHECK BUNKER 1 STATUS
        CMPA    #$00
        BEQ     CEM2AB1         ;BUNKER IS DEAD - BYPASS CHECKING
        LDD     #$0808          ;CHECK ENEMY MISSILE 1 AGAINST BUNKER 1
        LDX     $C9A1           ;MISSILE 1 YX
        LDY     $C999           ;BUNKER 1  YX
        JSR     $F8FF           ;COLLISION DETECT ROUTINE
        BLO     M1HB1           ;A HIT
        BRA     CEM2AB1         ;CHECK NEXT MISSILE
M1HB1   JSR     SETEF1          ;SET NEW MISSILE LOCATION
        JSR     HITBU1          ;INFLICT BUNKER DAMAGE
CEM2AB1 LDD     #$0808          ;CHECK ENEMY MISSILE 2 AGAINST BUNKER 1
        LDX     $C9A4           ;MISSILE 2 YX
        LDY     $C999           ;BUNKER 1  YX
        JSR     $F8FF           ;COLLISION DETECT ROUTINE
        BLO     M2HB1           ;A HIT
        BRA     CEM3AB1         ;CHECK NEXT MISSILE
M2HB1   JSR     SETEF2          ;SET NEW MISSILE LOCATION
        JSR     HITBU1          ;INFLICT BUNKER DAMAGE
CEM3AB1 LDD     #$0808          ;CHECK ENEMY MISSILE 3 AGAINST BUNKER 1
        LDX     $C9A7           ;MISSILE 3 YX
        LDY     $C999           ;BUNKER 1  YX
        JSR     $F8FF           ;COLLISION DETECT ROUTINE
        BLO     M3HB1           ;A HIT
        BRA     CEM1AB2         ;CHECK NEXT BUNKER
M3HB1   JSR     SETEF3          ;SET NEW MISSILE LOCATION
        JSR     HITBU1          ;INFLICT BUNKER DAMAGE

CEM1AB2 LDA     $C9AD           ;CHECK BUNKER 2 STATUS
        CMPA    #$00
        BEQ     CEM1AB3         ;BUNKER IS DEAD - BYPASS CHECKING
        LDD     #$0808          ;CHECK ENEMY MISSILE 1 AGAINST BUNKER 2
        LDX     $C9A1           ;MISSILE 1 YX
        LDY     $C99B           ;BUNKER 2  YX
        JSR     $F8FF           ;COLLISION DETECT ROUTINE
        BLO     M1HB2           ;A HIT
        BRA     CEM2AB2         ;CHECK NEXT MISSILE
M1HB2   JSR     SETEF1          ;SET NEW MISSILE LOCATION
        JSR     HITBU2          ;INFLICT BUNKER DAMAGE
CEM2AB2 LDD     #$0808          ;CHECK ENEMY MISSILE 2 AGAINST BUNKER 2
        LDX     $C9A4           ;MISSILE 2 YX
        LDY     $C99B           ;BUNKER 2  YX
        JSR     $F8FF           ;COLLISION DETECT ROUTINE
        BLO     M2HB2           ;A HIT
        BRA     CEM3AB2         ;CHECK NEXT MISSILE
M2HB2   JSR     SETEF2          ;SET NEW MISSILE LOCATION
        JSR     HITBU2          ;INFLICT BUNKER DAMAGE
CEM3AB2 LDD     #$0808          ;CHECK ENEMY MISSILE 3 AGAINST BUNKER 2
        LDX     $C9A7           ;MISSILE 3 YX
        LDY     $C99B           ;BUNKER 2  YX
        JSR     $F8FF           ;COLLISION DETECT ROUTINE
        BLO     M3HB2           ;A HIT
        BRA     CEM1AB3         ;CHECK NEXT BUNKER
M3HB2   JSR     SETEF3          ;SET NEW MISSILE LOCATION
        JSR     HITBU2          ;INFLICT BUNKER DAMAGE

CEM1AB3 LDA     $C9AE           ;CHECK BUNKER 3 STATUS
        CMPA    #$00
        BEQ     CEM1AB4         ;BUNKER IS DEAD - BYPASS CHECKING
        LDD     #$0808          ;CHECK ENEMY MISSILE 1 AGAINST BUNKER 3 
        LDX     $C9A1           ;MISSILE 1 YX
        LDY     $C99D           ;BUNKER 3  YX
        JSR     $F8FF           ;COLLISION DETECT ROUTINE
        BLO     M1HB3           ;A HIT
        BRA     CEM2AB3         ;CHECK NEXT MISSILE
M1HB3   JSR     SETEF1          ;SET NEW MISSILE LOCATION
        JSR     HITBU3          ;INFLICT BUNKER DAMAGE
CEM2AB3 LDD     #$0808          ;CHECK ENEMY MISSILE 2 AGAINST BUNKER 3
        LDX     $C9A4           ;MISSILE 2 YX
        LDY     $C99D           ;BUNKER 3  YX
        JSR     $F8FF           ;COLLISION DETECT ROUTINE
        BLO     M2HB3           ;A HIT
        BRA     CEM3AB3         ;CHECK NEXT MISSILE
M2HB3   JSR     SETEF2          ;SET NEW MISSILE LOCATION
        JSR     HITBU3          ;INFLICT BUNKER DAMAGE
CEM3AB3 LDD     #$0808          ;CHECK ENEMY MISSILE 3 AGAINST BUNKER 3
        LDX     $C9A7           ;MISSILE 3 YX
        LDY     $C99D           ;BUNKER 3  YX
        JSR     $F8FF           ;COLLISION DETECT ROUTINE
        BLO     M3HB3           ;A HIT
        BRA     CEM1AB4         ;CHECK NEXT BUNKER
M3HB3   JSR     SETEF3          ;SET NEW MISSILE LOCATION
        JSR     HITBU3          ;INFLICT BUNKER DAMAGE

CEM1AB4 LDA     $C9AF           ;CHECK BUNKER 4 STATUS
        CMPA    #$00
        BEQ     CDRSUB          ;BUNKER IS DEAD - BYPASS CHECKING
        LDD     #$0808          ;CHECK ENEMY MISSILE 1 AGAINST BUNKER 4 
        LDX     $C9A1           ;MISSILE 1 YX
        LDY     $C99F           ;BUNKER 4  YX
        JSR     $F8FF           ;COLLISION DETECT ROUTINE
        BLO     M1HB4           ;A HIT
        BRA     CEM2AB4         ;CHECK NEXT MISSILE
M1HB4   JSR     SETEF1          ;SET NEW MISSILE LOCATION
        JSR     HITBU4          ;INFLICT BUNKER DAMAGE
CEM2AB4 LDD     #$0808          ;CHECK ENEMY MISSILE 2 AGAINST BUNKER 4
        LDX     $C9A4           ;MISSILE 2 YX
        LDY     $C99F           ;BUNKER 4  YX
        JSR     $F8FF           ;COLLISION DETECT ROUTINE
        BLO     M2HB4           ;A HIT
        BRA     CEM3AB4         ;CHECK NEXT MISSILE
M2HB4   JSR     SETEF2          ;SET NEW MISSILE LOCATION
        JSR     HITBU4          ;INFLICT BUNKER DAMAGE
CEM3AB4 LDD     #$0808          ;CHECK ENEMY MISSILE 3 AGAINST BUNKER 4
        LDX     $C9A7           ;MISSILE 3 YX
        LDY     $C99F           ;BUNKER 4  YX
        JSR     $F8FF           ;COLLISION DETECT ROUTINE
        BLO     M3HB4           ;A HIT
        BRA     CDRSUB          ;CHECK NEXT BUNKER
M3HB4   JSR     SETEF3          ;SET NEW MISSILE LOCATION
        JSR     HITBU4          ;INFLICT BUNKER DAMAGE
CDRSUB  RTS

NEWLIFE JSR     MISOFF
        LDA     #$00
        STA     $C9BE
        STA     $C9CD
        LDA     #$B0
        STA     $C904
        JSR     SETEF1
        JSR     SETEF2
        JSR     SETEF3
        LDA     #$7F
        STA     $C9D2
        DEC     $C9BD
        LDA     $C9BD
        CMPA    #$00
        BEQ     NOLIFE
        RTS
NOLIFE  LDA     #$01
        STA     $C9B9
        RTS

CHKBROW LDA     #$00
        ADDA    $C994
        ADDA    $C995
        ADDA    $C996
        ADDA    $C997
        ADDA    $C998
        CMPA    #$05
        BNE     CHKBRO5
        LDA     #$04
        STA     $C9CE
CHKBRO2 LDA     #$00
        ADDA    $C98F
        ADDA    $C990
        ADDA    $C991
        ADDA    $C992
        ADDA    $C993
        CMPA    #$05
        BNE     CHKBRO5
        LDA     #$03
        STA     $C9CE
CHKBRO3 LDA     #$00
        ADDA    $C98A
        ADDA    $C98B
        ADDA    $C98C
        ADDA    $C98D
        ADDA    $C98E
        CMPA    #$05
        BNE     CHKBRO5
        LDA     #$02
        STA     $C9CE
CHKBRO4 LDA     #$00
        ADDA    $C985
        ADDA    $C986
        ADDA    $C987
        ADDA    $C988
        ADDA    $C989
        CMPA    #$05
        BNE     CHKBRO5
        LDA     #$01
        STA     $C9CE
CHKBRO5 RTS
GO      INC     $C9D4
        LDA     $C9D4
        CMPA    #$FF
        BNE     GOGO
        INC     $C9D5
        LDA     $C9D5
        CMPA    #$05
        BNE     GOGO
        JMP     INTRO
GOGO    LDA     #$FA
        STA     $C82A
        LDU     #OVER
        LDD     #0000
        LDA     #$00
        LDB     #$CB
        JSR     $F37A
        LDA     #$FC
        STA     $C82A
        LDU     #OVER1
        LDD     #0000
        LDA     #$F0
        LDB     #$8A
        JSR     $F37A
        RTS

SHOWSCR LDD     #$7F20          ;DISPLAY SCORE
        JSR     $F2FC
        LDU     #$C8B0
        LDD     #$FC47
        STD     $C82A
        JSR     $F495
        LDD     #$8020          ;DISPLAY LEVEL
        JSR     $F2FC
        LDU     #$C9D6
        LDD     #$FE4A
        STD     $C82A
        JSR     $F495
        RTS        
SHOSHPS LDD     #$7F80          ;DISPLAY BASES REMAINING
        JSR     $F2FC
        LDA     $C9BD
        CMPA    #$04
        BNE     SHOWS0
        LDU     #LIVE4
        BRA     DOSHOW
SHOWS0  CMPA    #$03
        BNE     SHOWS1
        LDU     #LIVE3
        BRA     DOSHOW
SHOWS1  CMPA    #$02
        BNE     SHOWS2
        LDU     #LIVE2
        BRA     DOSHOW
SHOWS2  CMPA    #$01
        BNE     SHOWS3
        LDU     #LIVE1
        BRA     DOSHOW
SHOWS3  LDU     #LIVE0
DOSHOW  LDD     #$FC47
        STD     $C82A
        JSR     $F495
        RTS

ADD10   LDU     #MUSIC1
        STU     $C9D0
        LDB     #$01
        STB     $C856
        LDD     #$0010
        JSR     ADD2SC
        RTS

ADD20   LDU     #MUSIC2
        STU     $C9D0
        LDB     #$01
        STB     $C856
        LDD     #$0020
        JSR     ADD2SC
        RTS

ADD30   LDU     #MUSIC3
        STU     $C9D0
        LDB     #$01
        STB     $C856
        LDD     #$0030
        JSR     ADD2SC
        RTS

ADD300  LDD     #$0300
        JSR     ADD2SC
        RTS

ADD150  LDD     #$0150
        JSR     ADD2SC
        RTS

ADD100  LDD     #$0100
        JSR     ADD2SC
        RTS

ADD50   LDD     #$0050
        JSR     ADD2SC
        RTS

ADD2SC  LDX     #$C8B0
        JSR     $F87C
        RTS

CIFHIT  LDA     $C9BE
        CMPA    #$00
        BEQ     CIFHIT0
        RTS
CIFHIT0 LDD     #$0808          ;CHECK ENEMY MISSILES AGAINST YOUR BASE
        LDX     $C9A1           ;MISSILE 1 YX
        LDY     $C903           ;YOU YX
        JSR     $F8FF
        BLO     HITYA1          ;MISSILE 1 HITS YOU !
        BRA     CIFHIT1
HITYA1  LDA     #$7F
        STA     $C9BE
        LDA     #$01
        STA     $C9CD
        JSR     MISOFF
        LDU     #MUSIC6
        STU     $C9D0
        LDB     #$01
        STB     $C856
        RTS
CIFHIT1 LDD     #$0808          ;CHECK ENEMY MISSILES AGAINST YOUR BASE
        LDX     $C9A4           ;MISSILE 1 YX
        LDY     $C903           ;YOU YX
        JSR     $F8FF
        BLO     HITYA2          ;MISSILE 2 HITS YOU !
        BRA     CIFHIT2
HITYA2  LDA     #$7F
        STA     $C9BE
        LDA     #$01
        STA     $C9CD
        JSR     MISOFF
        LDU     #MUSIC6
        STU     $C9D0
        LDB     #$01
        STB     $C856
        RTS
CIFHIT2 LDD     #$0808          ;CHECK ENEMY MISSILES AGAINST YOUR BASE
        LDX     $C9A7           ;MISSILE 1 YX
        LDY     $C903           ;YOU YX
        JSR     $F8FF
        BLO     HITYA3          ;MISSILE 3 HITS YOU !
        RTS
HITYA3  LDA     #$7F
        STA     $C9BE
        LDA     #$01
        STA     $C9CD
        JSR     MISOFF
        LDU     #MUSIC6
        STU     $C9D0
        LDB     #$01
        STB     $C856
        RTS

MISSL   fcb     0,$DF,0
        fcb      $FF,$7F,0
        fcb      1

MISSL2  FCB      0,$DF,0
        fcb      $FF,$2F,$DF
        fcb      $FF,$2F,$2F
        fcb      $FF,$2F,$DF
        fcb      $FF,$2F,$2F
        fcb      $FF,$2F,$DF
        fcb     1
BASE    fcb      $0, $9, $0
        fcb      $FF, $F7, $FB
        fcb      $FF, $0, $F4
        fcb      $FF, $FD, $FB
        fcb      $FF, $F8, $0
        fcb      $FF, $FE, $1
        fcb      $FF, $0, $2D
        fcb      $FF, $1, $1
        fcb      $FF, $9, $0
        fcb      $FF, $2, $FB
        fcb      $FF, $0, $F4
        fcb      $FF, $9, $FB
        fcb      1               ;END OF 

VADE2A  fcb      $00, $3, $0
        fcb      $00, $0, $F9
        fcb      $FF, $FA, $0
        fcb      $FF, $0, $E
        fcb      $FF, $5, $0
        fcb      $FF, $0, $F4
        fcb      $00, $F8, $FE
        fcb      $FF, $0, $2
        fcb      $FF, $2, $2
        fcb      $00, $0, $6
        fcb      $FF, $FE, $2
        fcb      $FF, $0, $2
        fcb     1

VADE2B  fcb      $00, $3, $0
        fcb      $00, $0, $F9
        fcb      $FF, $FA, $0
        fcb      $FF, $0, $E
        fcb      $FF, $6, $0
        fcb      $FF, $0, $F4
        fcb      $00, $F7, $02
        fcb      $FF, $0, $2
        fcb      $FF, $2, $FE
        fcb      $00, $0, $6
        fcb      $FF, $FE, $FE
        fcb      $FF, $0, $2
        fcb     1               

VADE1A  fcb      $00, $5, $0
        fcb      $FF, $FB, $FB
        fcb      $FF, $FB, $5
        fcb      $FF, $5, $5
        fcb      $FF, $5, $FB
        fcb      $00, $FB, $FB
        fcb      $FF, $FB, $FB
        fcb      $00, $0, $14
        fcb      $FF, $5, $FB
        fcb     1

VADE1B  fcb      $00, $5, $0
        fcb      $FF, $FB, $FB
        fcb      $FF, $FB, $5
        fcb      $FF, $5, $5
        fcb      $FF, $5, $FB
        fcb      $00, $0, $F6
        fcb      $FF, $FB, $5
        fcb      $00, $0, $A
        fcb      $FF, $5, $5
        fcb     1

VADE3A  fcb      $00, $0, $FA
        fcb      $00, $0, $FD
        fcb      $FF, $3, $0
        fcb      $FF, $FA, $6
        fcb      $FF, $0, $7
        fcb      $FF, $6, $6
        fcb      $FF, $FD, $0
        fcb      $00, $0, $FD
        fcb      $FF, $0, $F4
        fcb     1

VADE3B  fcb      $00, $0, $FA
        fcb      $00, $0, $FD
        fcb      $FF, $FD, $0
        fcb      $FF, $3, $3
        fcb      $FF, $FD, $3
        fcb      $FF, $0, $7
        fcb      $FF, $3, $3
        fcb      $FF, $FD, $3
        fcb      $FF, $3, $0
        fcb      $00, $0, $FD
        fcb      $FF, $0, $F4
        fcb     1

HIT     fcb      $0, $4, $0
        fcb      $FF, $4, $0
        fcb      $0, $FC, $0
        fcb      $0, $0, $FC
        fcb      $FF, $3, $FD
        fcb      $0, $FA, $1;
        fcb      $FF, $0, $FC
        fcb      $0, $0, $10
        fcb      $FF, $0, $4
        fcb      $0, $6, $FD;;
        fcb      $FF, $FD, $FD
        fcb      $0, $F8, $0
        fcb      $FF, $FD, $3
        fcb      $0, $0, $F2
        fcb      $FF, $3, $3
        fcb      $0, $0, $4
        fcb      $FF, $FC, $0
        fcb     1               ;END OF 

FORT    fcb      0, 0,4
        fcb      $FF, $0, $F6
        fcb      $FF, $FF, $FF
        fcb      $FF, $F6, $0
        fcb      $FF, $0, $4
        fcb      $FF, $1, $0
        fcb      $FF, $0, $4
        fcb      $FF, $FE, $0
        fcb      $FF, $0, $4
        fcb      $FF, $A, $0
        fcb      $FF, $1, $FF
        fcb     1               ;END OF 

SAUCER  fcb      $0, $3, $0
        fcb      $FF, $0, $FE
        fcb      $FF, $FE, $0
        fcb      $FF, $0, $FC
        fcb      $FF, $FC, $FC
        fcb      $FF, $0, $14
        fcb      $FF, $4, $FC
        fcb      $FF, $0, $FC
        fcb      $FF, $2, $0
        fcb      $FF, $0, $FE
        fcb     1

BOOM    fcb      $00, $7, $0
        fcb      $00, $F5, $0
        fcb      $00, $0, $FD
        fcb      $FF, $5, $FB
        fcb      $FF, $FE, $5
        fcb      $FF, $5, $FE
        fcb      $FF, $FD, $3
        fcb      $FF, $6, $2
        fcb      $FF, $FA, $2
        fcb      $FF, $3, $3
        fcb      $FF, $FB, $FE
        fcb      $FF, $2, $5
        fcb      $FF, $FB, $FB
        fcb     1

B300    db     '300',$80
B150    db     '150',$80
B100    db     '100',$80
B050    db     ' 50',$80
OVER    db     'GAME OVER',$80
OVER1   db     'PRESS BUTTON 3 TO PLAY',$80
LIVE0   db      'SHIPS LEFT    0',$80
LIVE1   db      'SHIPS LEFT    h',$80
LIVE2   db      'SHIPS LEFT   hh',$80
LIVE3   db      'SHIPS LEFT  hhh',$80
LIVE4   db      'SHIPS LEFT hhhh',$80
HIGHS   db      'HI SCORE',$80
MUSIC   FDB     $FEE8           ;MAGIC NUMBERS TO MAKE A PSEUDO
	FDB	$FEB6		;CHROMATIC PIANO NOISE WITH REVERB
        FCB     10,1, 11,1, 12,1, 13,1, 14,1, 15,1, 16,1, 17,1, 18,1
        FCB     10,1, 11,1, 12,1, 13,1, 14,1, 15,1, 16,1, 17,1, 18,1
        FCB     10,1, 11,1, 12,1, 13,1, 14,1, 15,1, 16,1, 17,1, 18,1
        FCB     18,1, 17,1, 16,1, 15,1, 14,1, 13,1, 12,1, 11,1, 10,1
        FCB     18,1, 17,1, 16,1, 15,1, 14,1, 13,1, 12,1, 11,1, 10,1
        FCB     18,1, 17,1, 16,1, 15,1, 14,1, 13,1, 12,1, 11,1, 10,1
        FCB     0, $80     

;	END
MUSIC3  FDB     $FEE8       
        FDB     $FEB6       
        fcb     1,1,5,1,10,1,15,1,20,1,25,1,30,1,35,1,40,1
        FCB     0, $80      
MUSIC2  FDB     $FEE8       
        FDB     $FEB6       
        fcb     1,1,5,1,10,1,15,1,20,1,25,1,30,1,35,1,40,1
        FCB     0, $80      
MUSIC1  FDB     $FEE8       
        FDB     $FEB6       
        fcb     1,1,5,1,10,1,15,1,20,1,25,1,30,1,35,1,40,1
        FCB     0, $80      
MUSIC4  FDB     $FD69       
        FDB     $FD79       
        fcb     $7F,$12
        FCB     0, $80      
MUSIC5  FDB     $FD69       
        FDB     $FD79       
        FCB     18,1, 17,1, 16,1, 15,1, 14,1, 13,1, 12,1, 11,1, 10,1
        FCB     18,1, 17,1, 16,1, 15,1, 14,1, 13,1, 12,1, 11,1, 10,1
        FCB     18,1, 17,1, 16,1, 15,1, 14,1, 13,1, 12,1, 11,1, 10,1
        FCB     0, $80      
MUSIC6  FDB     $FEE8       
        FDB     $FEB6       
        fcb     50,1,45,1,40,1,35,1,30,1,25,1,20,1,15,1,10,1,$5F,12,$7F,50
        FCB     0, $80       
MUSICH  FDB     $FEE8        
        FDB     $FEB6        
        fcb     $1A,20,$13,20
        fcb     $18,20
        fcb     $11,40
        fcb     $11,10
        fcb     $18,10
        fcb     $16,5
        fcb     $18,5
        fcb     $1A,20
        FCB     0, $80       
BONUS   FDB     $FEE8       
        FDB     $FEB6       
        FCB     30,10,30,10,30,10,30,10
        FCB     30,10,30,10,30,10,30,10
        FCB     0, $80      

VVV     fcb      $00, $6, $FC
        fcb      $FF, $F4, $4
        fcb      $FF, $C, $4
        fcb     1

EEE     fcb      $00, $FA, $4
        fcb      $FF, $0, $F8
        fcb      $FF, $C, $0
        fcb      $FF, $0, $8
        fcb      $FF, $FA, $0
        fcb      $FF, $0, $F8
        fcb     1

CCC     fcb      $00, $FA, $4
        fcb      $FF, $0, $F8
        fcb      $FF, $C, $0
        fcb      $FF, $0, $8
        fcb     1

TTT     fcb      $00, $FA, $0
        fcb      $FF, $C, $0
        fcb      $00, $0, $FC
        fcb      $FF, $0, $8
        fcb     1

OOO     fcb      $00, $FA, $4
        fcb      $FF, $0, $F8
        fcb      $FF, $C, $0
        fcb      $FF, $0, $8
        fcb      $FF, $F4, $0
        fcb     1

RRR     fcb      $00, $FA, $FC
        fcb      $FF, $C, $0
        fcb      $FF, $0, $8
        fcb      $FF, $FA, $0
        fcb      $FF, $0, $F8
        fcb      $FF, $FA, $8
        fcb     1

AAA     fcb      $00, $FA, $FC
        fcb      $FF, $C, $4
        fcb      $FF, $F4, $4
        fcb      $FF, $4, $FA
        fcb     1

DDD     fcb      $00, $0, $4
        fcb      $FF, $0, $F8
        fcb      $FF, $FA, $0
        fcb      $FF, $0, $8
        fcb      $FF, $C, $0
        fcb     1

SSS     fcb      $00, $FC, $FA
        fcb      $FF, $0, $8
        fcb      $FF, $6, $0
        fcb      $FF, $0, $F8
        fcb      $FF, $6, $0
        fcb      $FF, $0, $8
        fcb     1
        
GREET1  db      'BY JOHN DONDZILA',$80
GREET2  db      'RELEASED TO THE',$80
GREET3  db      ' PUBLIC DOMAIN',$80
GREET4  db      ' 3 f 8 f  1996',$80

KILLALL LDX     #$19
KILLAL1 LEAX    -1,X
        LDA     #$01
        STA     $C980,X
        CMPX    #$00
        BNE     KILLAL1
        LDA     #$01
        STA     $C924
        JSR     DECINV
        RTS

INTRO   LDD     #$3075
        STD     $C83D           ;SET T2 TIMER FOR 20 MSEC
        STD     $8              ;START T2
        LDA     #$60
        STA     $CB00
        STA     $CB02
        STA     $CB04
        STA     $CB06
        STA     $CB08
        STA     $CB0A
        LDA     #$20
        STA     $CB0C
        STA     $CB0E
        STA     $CB10
        STA     $CB12
        STA     $CB14
        STA     $CB16
        LDA     #$90            ;V
        STA     $CB01
        STA     $CB0D
        LDA     #$BE            ;E
        STA     $CB03
        STA     $CB0F
        LDA     #$EA           ;C
        STA     $CB05
        STA     $CB11
        LDA     #$14            ;T
        STA     $CB07
        STA     $CB13
        LDA     #$3D            ;O
        STA     $CB09
        STA     $CB15
        LDA     #$6F            ;R
        STA     $CB0B
        STA     $CB17
        LDA     #$00
        STA     $C9FF           ;ROTATIONAL VALUE
        LDA     #$00
        STA     $C9FE           ;SCALE VALUE
        STA     $C9FD           ;0= GROW, 1=SHRINK
        LDA     #$00
        STA     $C9D4

TLOOP   JSR     WAITRCL
        LDD     #$FAB0          ;DISPLAY HIGH SCORE
        JSR     $F2FC
        LDU     #HIGHS
        LDD     #$FE4A
        STD     $C82A
        JSR     $F495
        LDD     #$FA10          ;DISPLAY HIGH SCORE VALUE
        JSR     $F2FC
        LDU     #$CBEB
        LDD     #$FE4A
        STD     $C82A
        JSR     $F495
        LDA     $C9D4
        CMPA    #$03
        BEQ     TLOOPA
        JSR     SWITCHS
        TST     SW14
        BEQ     TLOOP0
TLOOPA  JMP     START
TLOOP0  LDA     #$5F
        JSR     ZAXTOA
        LDD     #$E0B9
        JSR     $F2FC
        LDD     #$FC3D  
        STD     $C82A
        LDU     #GREET1
        JSR     $F495
        LDD     #$C0B9      
        JSR     $F2FC
        LDD     #$FC3D  
        STD     $C82A
        LDU     #GREET2
        JSR     $F495
        LDD     #$B0B9      
        JSR     $F2FC
        LDD     #$FC3D  
        STD     $C82A
        LDU     #GREET3
        JSR     $F495
        LDD     #$90B9      
        JSR     $F2FC
        LDD     #$FC3D  
        STD     $C82A
        LDU     #GREET4
        JSR     $F495
        INC     $C9FF
        INC     $C9FF
        LDA     $C9FD
        CMPA    #$01
        BEQ     TLOOP1
        INC     $C9FE
        BRA     TLOOP2
TLOOP1  DEC     $C9FE
TLOOP2  LDA     $C9FE
        CMPA    #$00
        BEQ     TLOOP3
        CMPA    #$FF
        BNE     DRAWV
        LDA     #$01
        STA     $C9FD
        BRA     DRAWV
TLOOP3  LDA     #$00
        STA     $C9FD
        INC     $C9D4

DRAWV   LDX     #VVV
        LDU     #$CA00
        LDA     $C9FF
        JSR     $F61F
        LDX     #$CB00
        JSR     MVD85          
        LDX     #$CA00         
        LDB     $C9FE           
        JSR     DRWL1B         
        JSR     RES0RF
       
DRAWE   LDX     #EEE
        LDU     #$CA00
        LDA     $C9FF
        JSR     $F61F
        LDX     #$CB02
        JSR     MVD85          
        LDX     #$CA00         
        LDB     $C9FE
        JSR     DRWL1B         
        JSR     RES0RF         

DRAWC   LDX     #CCC
        LDU     #$CA00
        LDA     $C9FF
        JSR     $F61F
        LDX     #$CB04
        JSR     MVD85
        LDX     #$CA00         
        LDB     $C9FE
        JSR     DRWL1B         
        JSR     RES0RF         

DRAWT   LDX     #TTT
        LDU     #$CA00
        LDA     $C9FF
        JSR     $F61F
        LDX     #$CB06
        JSR     MVD85          
        LDX     #$CA00         
        LDB     $C9FE
        JSR     DRWL1B         
        JSR     RES0RF         

DRAWO   LDX     #OOO
        LDU     #$CA00
        LDA     $C9FF
        JSR     $F61F
        LDX     #$CB08
        JSR     MVD85          
        LDX     #$CA00         
        LDB     $C9FE
        JSR     DRWL1B         
        JSR     RES0RF         

DRAWR   LDX     #RRR
        LDU     #$CA00
        LDA     $C9FF
        JSR     $F61F
        LDX     #$CB0A
        JSR     MVD85          
        LDX     #$CA00         
        LDB     $C9FE
        JSR     DRWL1B         
        JSR     RES0RF         

DRAWV1  LDX     #VVV
        LDU     #$CA00
        LDA     $C9FF
        JSR     $F61F
        LDX     #$CB0C
        JSR     MVD85          
        LDX     #$CA00         
        LDB     $C9FE
        JSR     DRWL1B         
        JSR     RES0RF         
       
DRAWA   LDX     #AAA
        LDU     #$CA00
        LDA     $C9FF
        JSR     $F61F
        LDX     #$CB0E
        JSR     MVD85          
        LDX     #$CA00         
        LDB     $C9FE
        JSR     DRWL1B         
        JSR     RES0RF         

DRAWD   LDX     #DDD
        LDU     #$CA00
        LDA     $C9FF
        JSR     $F61F
        LDX     #$CB10
        JSR     MVD85          
        LDX     #$CA00         
        LDB     $C9FE
        JSR     DRWL1B         
        JSR     RES0RF         

DRAWE1  LDX     #EEE
        LDU     #$CA00
        LDA     $C9FF
        JSR     $F61F
        LDX     #$CB12
        JSR     MVD85          
        LDX     #$CA00         
        LDB     $C9FE
        JSR     DRWL1B         
        JSR     RES0RF         

DRAWR1  LDX     #RRR
        LDU     #$CA00
        LDA     $C9FF
        JSR     $F61F
        LDX     #$CB14
        JSR     MVD85          
        LDX     #$CA00         
        LDB     $C9FE
        JSR     DRWL1B         
        JSR     RES0RF         

DRAWS   LDX     #SSS
        LDU     #$CA00
        LDA     $C9FF
        JSR     $F61F
        LDX     #$CB16
        JSR     MVD85          
        LDX     #$CA00         
        LDB     $C9FE
        JSR     DRWL1B         
        JSR     RES0RF         
        BRA     TLOOP

CKSND   LDA     $C856
        CMPA    #$00
        BEQ     CKSND1
        RTS
CKSND1  LDA     #$01
        STA     $C856
        RTS
