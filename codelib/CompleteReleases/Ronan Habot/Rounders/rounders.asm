; +=====================================================================+
; |                                                                     |
; |   ROUNDERS.ASM                                                      |
; |                                                                     |
; |   Copyright 2001, Ronen Habot                                       |
; |                                                                     |
; +=====================================================================+
;
; file created 01-Jun-99

                title   "ROUNDERS Game for the HP3000 - Vextrex arcade"

                list

	INCLUDE "vectrex.inc"          

Vec_Text_Width_neg	EQU	$C880
PointsNr		EQU	$C881
RealTimeCounter		EQU	$C882
temp			EQU	$C883
OpeningString		EQU	$C884		;Reserve 13 locations

; Player 1 variables 
Plyr1BallYpos		EQU	$C890
Plyr1BallXpos		EQU	$C891
Plyr1BallFlag		EQU	$C892
Plyr1LocationIndex	EQU     $C893
Plyr1Ypos		EQU     $C894
Plyr1Xpos		EQU     $C895
Plyr1BallDirection	EQU	$C896
Plyr1PaddleMem		EQU	$C997		;Reserve 10 locations
Plyr1BallMoveY		EQU	$C9A1
Plyr1BallMoveX		EQU	$C9A2
Plyr1BallIndex	EQU	$C9A3
;;;Plyr1BallEndIndex	EQU	$C9A4
Plyr1TurnsNr		EQU	$C9A5
Plyr1MissedFlag		EQU	$C9A6
Plyr1ScoreTable		EQU	$C9A7		;Reseve 8 locations
Plyr1LevelDelay		EQU	$C9B0
Plyr1LevelFlag		EQU	$C9B1
Plyr1CurrentScore	EQU	$C9B2
Plyr1Level		EQU	$C9B3
DrawPlyr1Flag		EQU	$C9B4


; Player 2 variables 
Plyr2BallYpos		EQU	$C8A0
Plyr2BallXpos		EQU	$C8A1
Plyr2BallFlag		EQU	$C8A2
plyr2IndxLoc		EQU     $C8A3
plyr2Ypos		EQU     $C8A4
plyr2Xpos		EQU     $C8A5
Plyr2BallDirection	EQU	$C8A6
OrigRandom		EQU	$C8A7
PosRandom		EQU	$C8A8

; General purpose variables
PlyrNum			EQU	$C8A0
RndJoyType		EQU	$C8A1
RndHiScoreTable		EQU	$C8A2		;Reserve 8 locations

; Sound related variables
MissedSoundFlag		EQU	$C8B0
HitSoundFlag		EQU	$C8B1
LevelSoundFlag		EQU	$C8B2
TempRadius		EQU	$C8B3
TempIndex		EQU	$C8B4
TempBtns		EQU	$C8B5
CtrlType		EQU	$C8B6

dbg1_tbl                EQU     $C900
dbg2_tbl                EQU     $C908
dbg3_tbl                EQU     $C910
TempValue1		EQU	$C918
TempValue2		EQU	$C919


VEC_CTRL		EQU	0	;Regular Vectrex controller
DRV_CTRL		EQU	1	;Atari Driving controller (Vectrex Ctrlr is on Port#2)
OPENING_CIR_DISTANCE	EQU	4	;64 (256/4) points for the opeining circle
PADDLE_VL           	EQU	3	;Vector Length -1 of paddle
SCALE1			EQU	2	;Scale factor for paddle1
SCALE2			EQU	1	;Scale factor for Box
PDL_MEM			EQU	11	;Locations in the memory
PADDLE_RADIUS		EQU     87;was 90
HIT_SOUND_NOTES_NUM	EQU	03	;Number of notes to play
MAX_TURNS		EQU   	09	;Number of turns per player
PLYR1_INFO_YX		EQU	$7F90	;Location for plyr1 info
PLYR1_SCORE_YX		EQU	$7083	;Location for plyr1 score
PLYR1_LEVEL_YX		EQU	$7F50	;Location for plyr1 level
HSCORE_POS		EQU	$4AE9	;Location of HiScore @ the end
NOVICE			EQU	$05
INTERMIDIATE		EQU	$04
EXPERT			EQU	$03
SWITCH_TO_INTERMIDIATE	EQU	50
SWITCH_TO_EXPERT	EQU	75	
SWITCH_TO_BLINK		EQU	100		

        CODE
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Begining of the main program
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        ORG     0x0000

; magic init block

        FCB     $67,$20
        FCC     "GCE 2000"
        FCB     $80
        FDB     Music7
        FDB     $f850
        FDB     $30b8
        FCC     "ROUNDERS"
        FCB     $80,$0

        JMP     l_RndStart
        INCLUDE "PRINT.I"          ;replecement for bios print func
        INCLUDE "MyMacros.I"       ;replecement for bios print func
l_RndStart:
        JSR   s_RndInit                         ;general initialization
	JSR   s_RndOpening                      ;Opening music and graphics	
	JSR   s_RndSetJoystick
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
l_RndMainLoop:
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        JSR   s_RndRefreshScreen                ;Wait_recal etc.
        JSR   s_RndDrawBackground              	;Refresh background
        JSR   s_RndCheckJoystick		;Check controller movement
        JSR   s_RndDrawPlyr1                    ;Draw Player1's paddle
        JSR   s_RndDrawPlyr1Ball                ;Draw Player1's ball
        JSR   s_RndCheckSound                   ;Play sounds when needed
        JSR   s_RndPrintInfo                    ;Print the score
        JSR   s_RndCheckGameStatus             	;Check next level/game over
        BRA   l_RndMainLoop                     ;Return to main loop



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; opeining - This procedure call the YM music routines, displays the opening
;            letters and, waits for a button to be pressed to start the game.
;            This is a program by itself...
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndOpening:
        JSR   Read_Btns                 ; Get Buttons status
	;Set/Clear required variables
	CLR   Vec_Text_Width_neg
	LDA   #$02
	STA   PointsNr		;PointsNr updates every ~1 sec
	CLR   RealTimeCounter		;
	
	;Copy opening string from ROM to RAM
	LDX   #l_RoundersString
	LDY   #OpeningString
	LDA   #13
	JSR   s_CopyMem

l_RndOpening_loop:
        JSR   Wait_Recal                ;reset the crt

	LDA   #05
	LDB   PointsNr
	JSR   s_RealTimeClock		;Check if 1 sec passed and update points Nr
	STB   PointsNr

        JSR   Intensity_7F              ;Set the intensity to $7F

        LDA   #$7F                      ;
        STA   VIA_t1_cnt_lo             ;Set scaling factor to be 7f


	;Rotate box...

	LDU   #OpeningString
	LDA   1,U			;A<- Ypos of ROUNDERS text
	ASRA				;Divide by 2
	ASRA				;Divide by 2 once more,
	LDB   #PADDLE_VL		;Length of vector list of the Paddle -1
        LDX   #paddle1                 ;X<- Address of paddle vector list
        ;LDX   #l_Box                    ;X<- Address of paddle vector list
	;LEAX  1,X
					;needed to be drawn.
	LDU   #Plyr1PaddleMem		;U points to the rotated vector list result
	JSR   Rot_VL_ab			;Execute rotation based on previous information.


	JSR   Reset0Ref
	LDD   #$4000
	JSR   Moveto_d

	; Draw the rotated paddle
        LDX   #Plyr1PaddleMem           ;X<- Address of paddle vector list
	LDA   #PADDLE_VL		;Number of vectors -1 to draw
	STA   $C823			;Store for Draw_VL bios subroutine
        JSR   Draw_VL			;Draw Player 1's paddle	



	; Update ROUNDERS text location
	LDU   #OpeningString
	LDA   1,U			;A<- Ypos of ROUNDERS text
	;;;;CMPA  #-40
	;;;;BEQ   l_PrintRounders
	INCA				;A<-A+1
	STA   1,U           		;Store A back to the memory

l_PrintRounders:
        LDD   #$F340                    ;Set the Text size to LARGE
        STD   Vec_Text_HW

	JSR   Reset0Ref
        ;LDU   #OpeningString
        LDU   #l_RoundersString
        PRINT_STR_YX                    ;Call enhenced print routine

        LDD   #$FB20                    ;Set the Text size
        STD   Vec_Text_HW

        LDU   #l_RndOpenString1		;Print (c) Ronen Habot message
        PRINT_STR_YX                    ;Call enhenced print routine

;        LDU   #l_RndOpenString2		;Print 1 - Vectrex controller, or,
;        PRINT_STR_YX                    ;Call enhenced print routine

;        LDU   #l_RndOpenString3		;Print 4 - Modified 2600 Paddle
;        PRINT_STR_YX                    ;Call enhenced print routine


	; Start plotting the dots for the circle
        RESET_0_REF                     ;Must be here since it changes A
	LDA   #$FE			;Initialize index for next plot
	LDX   #sin_entry_0		;Initialize the X dimention pointer
	LDY   #cos_entry_0		;Initialize the Y dimention pointer

l_CircleLoop:
	PSHS  A				;Store A in the stack
	LDB   A,Y			;B <- Ypos of current dot
	LDA   A,X			;A <- Xpos of current dot
	JSR   Moveto_d			;Move screen ptr according to the circle

	JSR   Dot_here			;

        RESET_0_REF                     ;Must be here since it changes A

	PULS  A				;Restore A from stack
	ADDA  #OPENING_CIR_DISTANCE	;Change A to point to next point on circle
	CMPA  PointsNr			;PointsNr updates every ~1 sec
	BNE   l_CircleLoop


l_WaitForBtn:
        JSR   Read_Btns                 ; Get Buttons status
        CMPA  #$00                      ; If no button pressed,
        BEQ   l_RndOpening_loop         ; goto opening_loop...

;l_CheckIfNormalPlay:
;        BITA  #$01
;        BEQ   l_CheckCntrl1Btn4                ;
;        CLR   RndJoyType                   ;ORIGINAL CONTROLLER selected...
;	JMP   l_RndSelectPlyrNum

;l_CheckCntrl1Btn4:
;        BITA  #$08
;        BEQ   l_RndOpening_loop              ;
;        ;JSR   Joy_Analog                ;ATARI 2600 PADDLE selected...
;        ;LDA   Vec_Joy_1_X               ;A <- Xpos of joystick 1
;        ;;STA   rnd_LastAnalogVal
;        ;LDA   #$04
;        ;STA   RndJoyType
;        ;ADDA  #$30                      ;prepare the digit 4 for the menu
;        ;LDU   #menu_ram_str
;        ;STA   27,u                      ;store the digit 4 in the menu line
;;;;;;; TEMPORARY CODE ;;;;;
;        CLR   RndJoyType                ;ORIGINAL CONTROLLER selected...
;;;;;;; END OF TEMPORARY CODE;;;;;
;
;l_RndSelectPlyrNum:
;        ;JSR   s_RndStopMusic            ;Turn intro music off...
	JSR   s_RndSelectGameType
;	LDA   Plyr1LevelDelay
        RTS                             ;Return to main program





;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; refresh_scrn - Responsible for the reset of the crt, settings of the scale
;                factor and the real-time clock.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndRefreshScreen:
        JSR   Wait_Recal                ;Refresh the CRT
l_DontWaitRecal:
        JSR   Delay_3                   ;Delay 30 cycles...
        LDA   #$7F
        STA   VIA_t1_cnt_lo             ;Set scaling factor to 7f
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; INIT - Initialize all variables and data structures.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndInit:
	LDA   #VEC_CTRL
	STA   CtrlType			;Vectrex controller on Port#1 default

	CLR   RealTimeCounter		;Clear real-clock counter
	CLR   MissedSoundFlag		;Clear sound flag
	CLR   HitSoundFlag		;Clear sound flag
        CLR   LevelSoundFlag            ;Clear Level sound flag
	CLR   Plyr1Level		;Clear Level
	INC   Plyr1Level		;Update level - NOVICE
	
	LDA   #$10
	STA   DrawPlyr1Flag		;Make sure Plyr1 is displayed...

	LDA   #$03			;Center position of Plyr1's paddle
	STA   Plyr1LocationIndex
	CLR   Plyr1LocationIndex

	CLR   Plyr1BallFlag		;No Ball to display for plyr1
	CLR   Plyr1BallDirection	;Move in...
	CLR   Plyr1MissedFlag
	CLR   Plyr1LevelFlag
	CLR   Plyr1CurrentScore

	LDA   #MAX_TURNS
	STA   Plyr1TurnsNr

	LDX   #Plyr1ScoreTable
	JSR   Clear_Score

	CLR Plyr2BallFlag		;No Ball to display for plyr2
	CLR Plyr2BallDirection		; TEMP- move in...

	CLR PlyrNum			;Set # of players to 1
        RTS                             ;Return to the caller



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndSelectGameType:

s_RndSelGameType_loop:
        JSR   Wait_Recal                ;reset the crt

        ;RESET_0_REF;                    ;Call Reset0Ref macro
        LDU   #l_RndGameTypeMsg1
        PRINT_STR_YX                    ;Call enhenced print routine

        ;RESET_0_REF;                    ;Call Reset0Ref macro
        LDU   #l_RndGameTypeMsg2
        PRINT_STR_YX                    ;Call enhenced print routine

        ;RESET_0_REF;                    ;Call Reset0Ref macro
        LDU   #l_RndGameTypeMsg3
        PRINT_STR_YX                    ;Call enhenced print routine

        RESET_0_REF;                    ;Call Reset0Ref macro
        LDU   #l_RndGameTypeMsg4
        PRINT_STR_YX                    ;Call enhenced print routine

l_WaitForBtns:
        JSR   Read_Btns   	        ; Get Buttons status
        CMPA  #$00                      ; If no button pressed,
        BEQ   s_RndSelGameType_loop      ; goto opening_loop...

l_CheckCntrl1Btn1:
        BITA  #$01
        BEQ   l_CheckCntrl1Btn2         ;

l_Button1Pressed:
	LDA   #NOVICE			;Delay of Novice level...
	STA   Plyr1LevelDelay
	RTS

l_CheckCntrl1Btn2:
        BITA  #$02
        BEQ   l_CheckCntrl1Btn3		;

l_Button2Pressed:
	LDA   #INTERMIDIATE		;Delay of intermidiate level...
	STA   Plyr1LevelDelay
	SUBA  #$02			;So - it is level 2...
	STA   Plyr1Level
	RTS

l_CheckCntrl1Btn3:
        BITA  #$04
        ;BEQ   s_RndSelGameType_loop	;Nothing else to check, keep looping
        BEQ   l_CheckCntrl2Btn1		;

l_Button3Pressed:
	LDA   #EXPERT			;Delay of Novice level...
	STA   Plyr1LevelDelay
	STA   Plyr1Level


	;; At this point check for Controller #2 buttons. If pressed, Atari 
	;; Driving controller is connected at Port #1...

l_CheckCntrl2Btn1:
        BITA  #$10
        BEQ   l_CheckCntrl2Btn2         ;

l_Button21Pressed:
	LDA   #DRV_CTRL
	STA   CtrlType			;Vectrex controller on Port#1 default

	LDA   #NOVICE			;Delay of Novice level...
	STA   Plyr1LevelDelay
	RTS

l_CheckCntrl2Btn2:
        BITA  #$20
        BEQ   l_CheckCntrl2Btn3		;

l_Button22Pressed:
	LDA   #DRV_CTRL
	STA   CtrlType			;Vectrex controller on Port#1 default

	LDA   #INTERMIDIATE		;Delay of intermidiate level...
	STA   Plyr1LevelDelay
	SUBA  #$02			;So - it is level 2...
	STA   Plyr1Level
	RTS

l_CheckCntrl2Btn3:
        BITA  #$40
        BEQ   s_RndSelGameType_loop	;Nothing else to check, keep looping

l_Button23Pressed:
	LDA   #DRV_CTRL
	STA   CtrlType			;Vectrex controller on Port#1 default

	LDA   #EXPERT			;Delay of Novice level...
	STA   Plyr1LevelDelay
	STA   Plyr1Level


	RTS





;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; s_RndDrawPlyr1Ball - 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndDrawPlyr1Ball:
	LDA   Plyr1BallFlag		;Check whether Ball should be displayed
	BEQ   l_ExitDrawPlyr1Ball

	JSR   Reset0Ref			;Center the beam

	LDD   Plyr1BallYpos		;D <- ball coordinates 
	JSR   Moveto_d			;Move beam to D

	LDX   #l_Ball                   ;X<- Address of ball vector list
        JSR   Draw_VLc			;Draw the ball	

	CLRA				;Indicate Plyr1
	;LDB   #$02			;Indicate ball speed
	JSR   s_PlyrBallMove		;Calculate next coordinates of ball

l_ExitDrawPlyr1Ball:
        RTS                             ;return to caller


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; s_PlyrBallMove - Moves (the pointers of) the Ball asociated with each player.
; A -> Plyr Nr.
; B -> Plyr Ball speed.
; Plyr1BallStart(Y,X)
; Plyr1BallEnd(Y,X)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_PlyrBallMove:
	LDA    Plyr1LevelDelay			;TIKS for delay (# of refresh cycles)
	JSR    s_RealTimeClock
	TST    RealTimeCounter
	BEQ    l_BallHasToMove
	RTS

l_BallHasToMove:
	LDA   Plyr1BallIndex

	LDY   #l_BallMoveEntry		;
	LDX   #(l_BallMoveEntry+1)	;
	LDB   A,X   
	LDA   A,Y			;Now, D contains the values for ball movement 
	STD   Plyr1BallMoveY		;

	;Calculate next Ypos and Xpos of the ball
	LDA   Plyr1BallYpos
	LDB   Plyr1BallXpos

	TST   Plyr1BallDirection
	BEQ   l_BallMovesIn

l_BallMovesOut:
	SUBA  Plyr1BallMoveY
	SUBB  Plyr1BallMoveX
	BRA   l_StoreBallPos

l_BallMovesIn:
	ADDA  Plyr1BallMoveY
	ADDB  Plyr1BallMoveX

l_StoreBallPos:
	STA   Plyr1BallYpos
	STB   Plyr1BallXpos

	;Check if hit a destination 
 	TST   Plyr1BallDirection
 	BEQ   l_CheckBallHitCenter

l_CheckBallHitPlyr:
	LDD   Plyr1BallYpos		;D gets current ball position
	JSR   s_CalcRadius		;A contains the actual R (distance from [0,0])
	CMPA  #PADDLE_RADIUS
	BLO   l_NoHitThisTime		;If A < PADDLE_RADIUS there is no hit...
	
	CMPA  #(PADDLE_RADIUS+16)	;If A > PADDLE_RADIUS+13 the player missed for sure!
	BHI   l_CheckBallMissedPlyr

	;Now, the ball crosses the (invisible) circle that the paddle moves accross.
	;At this point in time, check if the paddle is near by... If it is, change 
	;direction and keep playing, else, let the ball get out of the screen and have
	;a new round started.
	LDA   Plyr1BallIndex
	ADDA  Plyr1BallIndex	;ADjust index (signed way...)

	LDX   #l_PaddleHitEntry
	LDB   A,X
	BNE   l_SpecialHitCheck

	INCA 				;Point to next entry in the table
	LDB   A,X			;Get left corner index of the paddle
	CMPB  Plyr1LocationIndex	;Check if the current crossing point is within
					;the paddle's range (as specified by the l_PaddleHit
					;table)
	BHI   l_CheckBallMissedPlyr

	INCA 				;Point to next entry in the table
	LDB   A,X			;Get right corner index of the paddle
	CMPB  Plyr1LocationIndex	;
	BHS   l_Plyr1ChangeDirection
	BRA   l_CheckBallMissedPlyr

l_SpecialHitCheck:
	LDB   Plyr1LocationIndex
	ADDB  #$30
	STB   TempIndex

	INCA 				;Point to next entry in the table
	LDB   A,X			;Get left corner index of the paddle
	ADDB  #$30
	CMPB  TempIndex		;Check if the current crossing point is within
					;the paddle's range (as specified by the l_PaddleHit
					;table)
	BHI   l_CheckBallMissedPlyr

	INCA 				;Point to next entry in the table
	LDB   A,X			;Get right corner index of the paddle
	ADDB  #$30
	CMPB  TempIndex			;
	BHS   l_Plyr1ChangeDirection
	BRA   l_CheckBallMissedPlyr

l_CheckBallMissedPlyr:
	;;Check if ball passed player's line first on Y and then on X
	LDA   Plyr1BallYpos		;Get current Ypos of the ball
	SUBA  Plyr1BallMoveY		;since ball moves outwards, check if next
	BVS   l_PlyrMissed		;BallYpos would overflow. If so - player missed!

	LDA   Plyr1BallXpos		;Get current Xpos of the ball
	SUBA  Plyr1BallMoveX		;since ball moves outwards, check if next
	BVS   l_PlyrMissed		;BallXpos would overflow. If so - player missed!
	RTS				;Return to caller

l_PlyrMissed:
	LDA  #$0A			;A <- Number of notes to play explosion sound
	STA  MissedSoundFlag		;Reload the explosion notes counter

	LDA   #$01
	STA   Plyr1MissedFlag		;Indicate main loop that Plyr1 missed!
	RTS 				;Return to caller

l_CheckBallHitCenter:
	LDY   #$0000			;Position of central Box/Circle
	LDX   Plyr1BallYpos
	;LDD   #$2020			;Size of central Box
	LDD   #$1515			;Size of central Box
	JSR   Obj_Hit			;Check if ball hit central Box/Circle
	BCS   l_Plyr1ChangeDirection	;If Carry set, change ball direction

l_NoHitThisTime:
	RTS

l_Plyr1ChangeDirection:
	JSR   s_ChangeBallDirection

l_ExitPlyrBallMove:
	RTS



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; s_ChangeBallDirection
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_ChangeBallDirection:

	;If ball hit center, calculate the return path (make sure meets the paddle...) and,
	;update (don't show yet)  score
	TST   Plyr1BallDirection	;Check direction Flag
	BNE   l_Plyr1UpdateDirectionFlag;If the ball moves outwards just change direction...


	LDD   Plyr1BallYpos
	;STB   TempValue1		;------ DEBUG -----
	;STA   TempValue2		;------ DEBUG -----

	;BRA   l_Plyr1UpdateDirectionFlag




	LDX   #l_RndTbl			;X points to the randomize table
   	JSR   Random_3  		;Calculate a new EndIndex...
	STA   OrigRandom
	ASRA
	ASRA
	ASRA
	LDA   A,X			;A Gets a random (valid offset) number
	LDB   Plyr1LevelDelay
	CMPB  #EXPERT
	BHS   l_CalcNewIndex

l_NotAnExpertYet:
	RORA
	RORA
	RORA
	RORA

l_CalcNewIndex:
	ANDA  #$0F
	STA   PosRandom
	LDA   OrigRandom		;Get the original value and check out the sign
	ANDA  #$80
	BNE   l_NegativeIndex

l_positiveIndex:
	LDA   Plyr1BallIndex
	ADDA  PosRandom
	BRA   l_CheckNewIndexRange1

l_NegativeIndex:
	LDA   Plyr1BallIndex
	SUBA  PosRandom

l_CheckNewIndexRange1:
	BMI   l_CheckNewIndexRange2
	CMPA  #$3F
	BLS   l_StoreNewIndex
	LDA   #$3E
	BRA   l_StoreNewIndex

l_CheckNewIndexRange2:
	CMPA  #193			;Mask numbers bigger than 63...
	BHI   l_StoreNewIndex
	LDA   #192

l_StoreNewIndex:
	STA   Plyr1BallIndex
	LDX   #l_HitCenterPos
	LDD   A,X
	STD   Plyr1BallYpos



	LDY   #l_BallMoveEntry		;
	LDX   #(l_BallMoveEntry+1)	;
	LDA   Plyr1BallIndex
	LDB   A,X   
	LDA   A,Y			;Now, D contains the values for ball movement 
	STD   Plyr1BallMoveY		;



	LDA   Plyr1Level		;A Score increase
	;LDA   #$01			;A Score increase
	LDX   #Plyr1ScoreTable		;X Pointer to Score Array in the RAM
	JSR   Add_Score_a		;BIOS function to take care of the rest...
	INC   Plyr1CurrentScore		;Free running counter for level monitoring

	LDA   Plyr1LevelFlag		;Check if still need to check level
	BNE   l_Plyr1UpdateDirectionFlag
	JSR   s_UpdateLevels


l_Plyr1UpdateDirectionFlag:
	LDA   Plyr1BallDirection	;Read current value
	INCA				;Add +1
	ANDA  #$01			;Mask bits 7 downto 1 (A could be 0 or 1)
	STA   Plyr1BallDirection	;Store back into memory

	; Prepare sound Flag
	LDA   #HIT_SOUND_NOTES_NUM	;A is number of notes to play
	STA   HitSoundFlag		;Store it to the RAM

	;Update persistance value (just in case where we are in Blink mode!...)
	LDA   #$06
	STA   DrawPlyr1Flag

	RTS				;Return to caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; D contains YX pair of a given point, the result is the distance from (0,0) in
; ACC A.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_CalcRadius:
	JSR   Abs_a_b			;Must use absolute values!

l_CalcY:
	ANDA  #$78			;Mask irelevant bits
	ASLA				;High Nibble of A contains MSB value of index
	BNE   l_CalcX			;If not Zero calculte X
	LDA   #$10			;If Zero, turn to 0x10 to avoid too big jumps in R

l_CalcX:
	ANDB  #$78			;Mask irelevant bits
	ASRB
	ASRB
	ASRB				;High Nibble of A contains MSB value of index
	STB   TempRadius

l_CalcIndex:
	ORA   TempRadius		;A now is the index to the RadiusTbl
	LDX   #l_RadiusEntry0
	LDA   A,X			;A now gets the radius value
	
	RTS


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; A is begining index
; s_RndDrawCircle - 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndDrawCircle:
	LDX   #sin_entry_0		;Initialize the X dimention pointer
	LDY   #cos_entry_0		;Initialize the Y dimention pointer

l_BckgndCircleLoop:
	PSHS  A				;Store A in the stack
	LDB   A,Y			;B <- Ypos of current dot
	ASRB      
	ASRB      
	LDA   A,X			;A <- Xpos of current dot
	ASRA    
	ASRA    
	JSR   Moveto_d			;Move screen ptr according to the circle

	JSR   Dot_here			;
        JSR   Reset0Ref			;Must be here since it changes A
        ;JSR   Intensity_5F              ;Set the intensity to $5F

	PULS  A				;Restore A from stack
	ADDA  #OPENING_CIR_DISTANCE	;Change A to point to next point on circle
	CMPA  PointsNr			;
	BNE   l_BckgndCircleLoop

        RTS                             ;Return to the caller


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndDrawPlyr1:
	LDA   Plyr1Level
	CMPA  #$04			;Check if Blink mode...
	BNE   l_NoBlinkMode

	LDA   DrawPlyr1Flag		;If Blink mode, check the drawing flag,
	BEQ   l_ExitRndDrawPlyr1	;when cleared, don't draw paddle in this round...
	DEC   DrawPlyr1Flag		;Update the persistance of the paddle...

l_NoBlinkMode:
	JSR   Reset0Ref			;Must be here since it changes A,B...

	LDX   #cos_entry_0
	LDY   #sin_entry_0

	LDA   Plyr1LocationIndex
	LDB   A,X   
	LDA   A,Y			;Now, D contains the Y,X coordinates
					;of the paddle 
	STD   Plyr1Ypos			;

	JSR   Moveto_d			;Moving the pointer is done with 7F
					;scaling factor.
	;JSR   Dot_here			;This is for debug only!


	LDA   Plyr1LocationIndex	;This is the rotation angle (x4)
	ASRA				;Divide by 2
	ASRA				;Divide by 2 once more,
	LDB   #PADDLE_VL		;Length of vector list of the Paddle -1
        LDX   #paddle1                  ;X<- Address of paddle vector list
					;needed to be drawn.
	LDU   #Plyr1PaddleMem		;U points to the rotated vector list result
	JSR   Rot_VL_ab			;Execute rotation based on previous information.

	; Draw the rotated paddle
        LDX   #Plyr1PaddleMem           ;X<- Address of paddle vector list
	LDA   #PADDLE_VL		;Number of vectors -1 to draw
	STA   $C823			;Store for Draw_VL bios subroutine
        JSR   Draw_VL			;Draw Player 1's paddle	

l_ExitRndDrawPlyr1:
	RTS



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; draw_background - This procedure draws the screen background based on a
;                   vector table defined at #bckgnd. This procedure is called
;                   every refresh cycle in order to keep the background always
;                   visible. The scaling factor here is set to $7F.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndDrawBackground:
        JSR   Intensity_5F              ;Set the intensity to $5F
        JSR   Reset0Ref			;;Must be here since it changes A


	LDA   #$00
	LDB   #($FF- OPENING_CIR_DISTANCE + 1)
	STB   PointsNr			;Make sure that PointsNr is a multiplication 
					;of OPENING_CIR_DISTANCE, otherwise, only
					;this circle will be displayed!
        JSR   s_RndDrawCircle                       ;

	;DEBUG
        JSR   Reset0Ref			;;Must be here since it changes A
	LDD   #$1919
	JSR   Moveto_d			;Move pointer to the center 
	LDX   #l_Box
	JSR   Draw_VLc			;This is for debug only!

        RTS                             ;Return to caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; print_info: This procedure is responsible for prinitng game info such as:
;             Score, High score, car speed, cars left etc.
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
s_RndPrintInfo:

	JSR   Reset0Ref

	;Print "(n) - I" at the upper left corner
	LDA   #$49			;The hex value of "I"
	LDB   Plyr1TurnsNr		;Number of turns available to player 1
	LDX   #PLYR1_INFO_YX		;XY position of the printout
	JSR   Print_Ships		;BIOS subroutine that take care of the rest...

	;Print Player1 current score
	LDD   #PLYR1_SCORE_YX
	LDU   #Plyr1ScoreTable
	JSR   Print_Str_d

l_PrintLevelInfo:
	LDA   Plyr1Level
	CMPA  #$01
	LBNE   l_NotNovice

        LDU   #l_RndLevelNOVICE
        PRINT_STR_YX                    ;Call enhenced print routine
	LBRA   l_EndOfLevelInfo

l_NotNovice:
	CMPA  #$02
	LBNE   l_NotIntermidiate

        LDU   #l_RndLevelINTER
        PRINT_STR_YX                    ;Call enhenced print routine
	LBRA   l_EndOfLevelInfo

l_NotIntermidiate:
	CMPA  #$03
	LBNE   l_NotExpert

        LDU   #l_RndLevelEXPERT
        PRINT_STR_YX                    ;Call enhenced print routine
	LBRA   l_EndOfLevelInfo

l_NotExpert:
        LDU   #l_RndLevelBLINK
        PRINT_STR_YX                    ;Call enhenced print routine

l_EndOfLevelInfo:
	RTS

	STB   TempValue2		;------ DEBUG -----


;        LDA   #$7F                      ;
;        STA   VIA_t1_cnt_lo             ;Set scaling factor to be 7f
l_RndPrintValues:
;        LDD   #$8080                    ;YX position of the score
;        LDU   #rnd_Score_tbl                ;u points to the score string
;        JSR   Print_Str_d               ;Print the score!

;;      *** DEBUG ***
      ;;*******************
      ;;*** Left value ***
      ;;*******************
;      LDX   #dbg1_tbl
;      JSR   Clear_Score
;      LDA   Plyr1LocationIndex 
;      LDX   #dbg1_tbl
;      JSR   Add_Score_a
;
;      LDD   #$8090
;      LDU   #dbg1_tbl
;      JSR   Print_Str_d

      ;;*******************
      ;;*** Center value ***
      ;;*******************
      LDX   #dbg2_tbl
      JSR   Clear_Score
      
      LDA   TempValue1

      LDX   #dbg2_tbl
      JSR   Add_Score_a

      LDD   #$8000
      LDU   #dbg2_tbl
      JSR   Print_Str_d





      ;;*******************
      ;;*** Right value ***
      ;;*******************
      LDX   #dbg3_tbl
      JSR   Clear_Score
      
      LDA   TempValue2

      LDX   #dbg3_tbl
      JSR   Add_Score_a

      LDD   #$8050
      LDU   #dbg3_tbl
      JSR   Print_Str_d
;;      *** DEBUG END ***

        RTS                             ;Return to caller



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; setjoystick - Enables the Joysticks controllers. In this case, Joystick #2
;               is disabled.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndSetJoystick:
        LDX   #JOYENS
        LDA   #1                        ;Enable Joystick1 X doamin1
        STA   ,X+
        CLRA
        STA   ,X+                       ;Disable Joystick1 Y domain
        STA   ,X+                       ;Disable Joystick2 X domain
        STA   ,X+                       ;Disable Joystick2 Y doamin
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; checkjoystick - Monitors Joystic1 movement and set the player's car postion
;                 and speed accordingly.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndCheckJoystick:
        LDA   CtrlType
        BNE   l_AtariDrvCtrl
l_RndDigitalStick:
        JSR   Joy_Digital               ;Read joystick position
        LDB   Plyr1LocationIndex
        LDA   Vec_Joy_1_X               ;A <- Xpos of joystick 1
        BEQ   l_RndXDone
        BMI   l_RndLeftMove
l_RndRightMove:
        INC   Plyr1LocationIndex
	BRA   l_RndXDone
l_RndLeftMove:
        DEC   Plyr1LocationIndex
	BRA   l_RndXDone


l_AtariDrvCtrl:
	JSR   s_DrvCtrlr		;Call Driving Controller Routine, A will identify direction	
	ADDA  Plyr1LocationIndex
	STA   Plyr1LocationIndex

l_RndXDone:

        JSR   s_RndCheckBtns
        RTS                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; check_btns: Responsible for checking if a button was pressed. If so, checks
;             which button. Since only one button is used in the game and only
;             to exit a displayed menu, once button1 is pressed, the flag
;             (indicating end of the menu) is cleared.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndCheckBtns:
        JSR   Read_Btns      	       ; Get Buttons status
	LDA   $C80F
	;STA   TempValue1		;------ DEBUG -----
        CMPA  #$00
        BEQ   l_RndCheckBtnsRTS

check_btn1_4:
        BITA  #$08			;Check for button 4 (controller 1)
        BEQ   check_btn2_4
	JSR   s_StartSession		;Display the ball...
	RTS 
	
check_btn2_4:
	ANDA  #$80			;Check for button 4 (controller 2)
        BEQ   l_RndCheckBtnsRTS
	JSR   s_StartSession		;Display the ball...

l_RndCheckBtnsRTS:
        RTS                             ;Return to the caller



s_StartSession:
        TST   Plyr1BallFlag		;Skip this part is ball is already present
        ;BNE   s_StartSession
        BNE   l_RndCheckBtnsRTS

        LDA   #$01         
        STA   Plyr1BallFlag		;Set Player1 ball flag

	LDX   #cos_entry_0		;Initialize the X dimention pointer
	LDY   #sin_entry_0		;Initialize the Y dimention pointer
	LDA   Plyr1LocationIndex
	;SUBA  #$04			;Adjust the origin of the ball to paddle's center
	LDB   A,X   
	LDA   A,Y			;Now, D contains the Y,X coordinates
					;of the paddle 
	STD   Plyr1BallYpos		;


	LDY   #l_BallMoveEntry		;
	LDX   #(l_BallMoveEntry+1)	;

	LDA   Plyr1LocationIndex	;A is the offset within the BallMove table
	;SUBA  #$04			;Adjust the origin of the ball to paddle's center
	ASRA				;Since each Entry takes 2 locations,divide
	ANDA  #$FE			;only by 2 (instead of 4), make sure A is even
		
	STA   Plyr1BallIndex	
	LDB   A,X   
	LDA   A,Y			;Now, D contains the values for ball movement 
	STD   Plyr1BallMoveY		;

	CLR   RealTimeCounter		;

	LDA   #$10
	STA   DrawPlyr1Flag		;Make sure Plyr1 is displayed...

	RTS




;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;; A <- TIKS_PER_SECOND
;; B <- current counter value, increamneted by 1 if a second passed.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RealTimeClock:
	CMPA  RealTimeCounter
	BNE   l_ExitUpdateRealTimeClock

	; Here about 1 Sec passed since last match, update B
	CLR   RealTimeCounter
	ADDB  #OPENING_CIR_DISTANCE
	RTS

l_ExitUpdateRealTimeClock:
	INC   RealTimeCounter
	RTS



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; X -> ptr to Source
; Y -> ptr to Destination
; A -> Length
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_CopyMem:
	LDB   A,X			; B <- Source Data
	STB   A,Y			; [Destination] <- B
	DECA
	BNE   s_CopyMem
	LDB   A,X			; Don't forget entry (0) 
	STB   A,Y			; 
	RTS				; Return to caller



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndCheckSound:
        PSHS  x

;------------------------------------
;--- Missed ball sound generation ---
;------------------------------------
l_CheckMissedFlag:
        LDA   MissedSoundFlag
        BNE   l_MakeMissedSound
        BRA   l_CheckHitFlag

l_MakeMissedSound:
        DEC   MissedSoundFlag
        BNE   l_PlayMissedSound

l_StopMissedSound:
        LDB   $C807                     ;B=current channel activity
        ORB   #$09                      ;Deactivate Tone+Noise1 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte
        LBRA   l_CheckSoundExit

l_PlayMissedSound:
        LDB   #$1D                      ;Noise value
        LDA   #$06                      ;Sound reg, 0x06
        JSR   Sound_Byte
        LDA   MissedSoundFlag      ;A<- current index to volume
        LDX   #l_MissedVolume           ;X<- *ptr to explosion volume
        LDB   a,x                       ;B<- current explosion volume
        LDA   #$08                      ;Sound reg. Volume 1
        JSR   Sound_Byte
        LDB   $C807                     ;B=current channel activity
        ANDB  #$F7                      ;Activate Noise1 (reset)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte

;-----------------------------------------------
;--- Hit (center or paddle) sound generation ---
;-----------------------------------------------
l_CheckHitFlag:
        LDA   HitSoundFlag
        BNE   l_MakeHitSound
        BRA   l_CheckLevelFlag

l_MakeHitSound:
        DEC   HitSoundFlag
        BNE   l_PlayHitSound
        LDB   $C807                     ;B=current channel activity
        ORB   #$12                      ;Deactivate Tone+Noise2 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte
        BRA   l_CheckLevelFlag

l_PlayHitSound:
        LDX   #l_HitSound
        LDA   HitSoundFlag
        LDB   a,x                       ;Tone 2 LSB value
        LDA   #$02                      ;Sound reg, 0x00
        JSR   Sound_Byte
        LDB   #$00                      ;Tone 2 MSB value
        LDA   #$03                      ;Sound reg. 0x01
        JSR   Sound_Byte
        LDB   #$0F                      ;Channel 2 Max. volume
        LDA   #$09                      ;Sound reg. Volume 2
        JSR   Sound_Byte
        LDB   $C807                     ;B=current channel activity
        ANDB  #$FD                      ;Activate Tone2 (reset)
        ORB   #$10                      ;Deactivate Noise2 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte


;-------------------------------------
;--- Level change sound generation ---
;-------------------------------------
l_CheckLevelFlag:                                ;using channel 3
        LDA   LevelSoundFlag
        BNE   l_CheckLevelSound

        BRA   l_Check4FallSound
l_CheckLevelSound:
        DEC   LevelSoundFlag
        BNE   l_PlayLevelSound
        LDB   $C807                     ;B=current channel activity
        ORB   #$24                      ;Deactivate Tone+Noise3 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte
        BRA   l_Check4FallSound
l_PlayLevelSound:
        LDX   #l_GoodSound
        LDA   LevelSoundFlag
        LDB   a,x                       ;Tone 3 LSB value
        LDA   #$04                      ;Sound reg, 0x00
        JSR   Sound_Byte
        LDB   #$00                      ;Tone 3 MSB value
        LDA   #$05                      ;Sound reg. 0x01
        JSR   Sound_Byte
        LDB   #$0F                      ;Channel 3 Max. volume
        LDA   #$0A                      ;Sound reg. Volume 3
        JSR   Sound_Byte
        LDB   $C807                     ;B=current channel activity
        ANDB  #$FB                      ;Activate Tone3 (reset)
        ORB   #$20                      ;Deactivate Noise3 (set)
        LDA   #$07                      ;Sound reg. 0x07
        JSR   Sound_Byte

l_Check4FallSound:
;        LDA   fallSndFlag
;        BNE   l_FallSound
;
;        BRA   l_Check4BadSound
;l_FallSound:
;        DEC   fallSndFlag
;        BNE   l_PlayFallSound
;        LDB   $C807                     ;B=current channel activity
;        ORB   #$24                      ;Deactivate Tone+Noise3 (set)
;        LDA   #$07                      ;Sound reg. 0x07
;        JSR   Sound_Byte
;        BRA   l_Check4BadSound
;l_PlayFallSound:
;        LDB   fallSndFlag
;        ADDB  #$64
;        LDA   #$04                      ;Sound reg, 0x00
;        JSR   Sound_Byte
;        LDB   #$00                      ;Tone 3 MSB value
;        LDA   #$05                      ;Sound reg. 0x01
;        JSR   Sound_Byte
;        LDB   #$0F                      ;Channel 3 Max. volume
;        LDA   #$0A                      ;Sound reg. Volume 3
;        JSR   Sound_Byte
;        LDB   $C807                     ;B=current channel activity
;        ANDB  #$FB                      ;Activate Tone3 (reset)
;        ORB   #$20                      ;Deactivate Noise3 (set)
;        LDA   #$07                      ;Sound reg. 0x07
;        JSR   Sound_Byte
;
;l_Check4BadSound:
;        LDA   badSndFlag
;        BNE   l_BadSound
;
;        BRA   l_CheckSoundExit
;l_BadSound:
;        DEC   badSndFlag
;        BNE   l_PlayBadSound
;        LDB   $C807                     ;B=current channel activity
;        ORB   #$24                      ;Deactivate Tone+Noise3 (set)
;        LDA   #$07                      ;Sound reg. 0x07
;        JSR   Sound_Byte
;        BRA   l_CheckSoundExit
;l_PlayBadSound:
;        LDB   #$FF                      ;Channel 3 constant tone
;        LDA   #$04                      ;Sound reg, 0x00
;        JSR   Sound_Byte
;        LDB   #$00                      ;Tone 3 MSB value
;        LDA   #$05                      ;Sound reg. 0x01
;        JSR   Sound_Byte
;        LDA   badSndFlag
;        LDX   #l_Bad_Volume
;        LDB   a,x                       ;Tone 3 LSB value
;        LDA   #$0A                      ;Sound reg. Volume 3
;        JSR   Sound_Byte
;        LDB   $C807                     ;B=current channel activity
;        ANDB  #$FB                      ;Activate Tone3 (reset)
;        ORB   #$20                      ;Deactivate Noise3 (set)
;        LDA   #$07                      ;Sound reg. 0x07
;        JSR   Sound_Byte


l_CheckSoundExit:
        PULS  x
        RTS

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
l_MissedVolume:
        DB   $0F
        DB   $0F
        DB   $0F
        DB   $0A
        DB   $0A
        DB   $0A
        DB   $07
        DB   $07
        DB   $07
        DB   $03
        DB   $02


l_HitSound:
        DB   $FF
        DB   $FF
        DB   $FF
        DB   $EF
        DB   $EF

l_GoodSound:
        DB   $FF
        DB   $FF
        DB   $FF
        DB   $DF
        DB   $DF
        DB   $DF
        DB   $BF
        DB   $BF
        DB   $BF
        DB   $9F
        DB   $9F
        DB   $9F


l_Bad_Volume:
        DB   $0F
        DB   $0F
        DB   $0F
        DB   $00
        DB   $0F
        DB   $0F
        DB   $0F
        DB   $00
        DB   $0F
        DB   $0F
        DB   $0F



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndCheckGameStatus:
l_StatusMissedFlag:
	LDA   Plyr1MissedFlag
	BEQ   l_RndCheckGameStatusExit

	CLR   Plyr1MissedFlag		;Clear the Missed flag
        CLR   Plyr1BallFlag		;Clear the Ball flag (no ball anymore)
	CLR   Plyr1BallDirection	;Make sure next ball goes inwards
	DEC   Plyr1TurnsNr
	BNE   l_RndCheckGameStatusExit

l_RndGmaeOver:
	JMP   s_RndGameOver
l_RndCheckGameStatusExit:
        RTS


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_UpdateLevels:
	LDA   Plyr1CurrentScore
	CMPA  #$FF
	BEQ   l_SetUpdateFlag

l_CheckIntermidiate:
	CMPA  #SWITCH_TO_INTERMIDIATE
	BNE   l_CheckExpert

l_SwitchToINTERMIDIATE:
	LDA   Plyr1LevelDelay
	CMPA  #INTERMIDIATE
	BLS   l_CheckExpert			;Don't change if not intermidiate...

	LDA   #$0C
	STA   LevelSoundFlag
	INC   Plyr1Level
	DEC   Plyr1LevelDelay
	RTS

l_CheckExpert:
	LDA   Plyr1CurrentScore
	CMPA  #SWITCH_TO_EXPERT
	BNE   l_CheckBlinkLevel

l_SwitchToEXPERT:
	LDA   Plyr1LevelDelay
	CMPA  #EXPERT
	BLS   l_CheckBlinkLevel			;Don't change if not expert...

	LDA   #$0C
	STA   LevelSoundFlag
	INC   Plyr1Level
	DEC   Plyr1LevelDelay
	RTS

l_CheckBlinkLevel:
	LDA   Plyr1CurrentScore
	CMPA  #SWITCH_TO_BLINK
	BNE   l_ExitUpdateLevels

l_SwitchToBLINK:
	LDA   #$0C
	STA   LevelSoundFlag
	INC   Plyr1Level
	
l_ExitUpdateLevels:
	RTS

l_SetUpdateFlag:
	INC   Plyr1LevelFlag		;No more level checks
	RTS

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; s_RndGameOver - End of game screen
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_RndGameOver:
        LDX   #Plyr1ScoreTable          ;X points to current score table
        LDU   #Vec_High_Score           ;U points to Vectrex HiScore table
        JSR   New_High_Score            ;Compare and update HiScore table

l_RndGameOver_loop:
        JSR   Wait_Recal                ;reset the crt

        LDA   #$7F                      ;
        STA   VIA_t1_cnt_lo             ;Set scaling factor to be 7f

	JSR   s_RndDrawBackground
	JSR   s_RndDrawPlyr1
	JSR   s_RndPrintInfo

        RESET_0_REF;                    ;Call Reset0Ref macro
        LDU   #l_RndHighScoreMsg
        PRINT_STR_YX                    ;

        RESET_0_REF;                    ;Call Reset0Ref macro
        LDD   #HSCORE_POS               ;Set D to the (Y,X) of the HiScore
        LDU   #RndHiScoreTable           ;U Points to the HiScore table
        LDU   #Vec_High_Score           ;U Points to the HiScore table
        ;LDU   #Plyr1ScoreTable          ;X points to current score table
        JSR   Print_Str_d               ;Print the HighScore on the screen

	;JSR   Reset0Ref
        RESET_0_REF;                    ;Call Reset0Ref macro
        LDU   #l_RndGameOverMsg
        PRINT_STR_YX                    ;

        JSR   Read_Btns   	        ;Get Buttons status
        CMPA  #$00                      ;If no button pressed,
        BEQ   l_RndGameOver_loop        ;Goto GameOver_loop...

l_RndBtnWasPressed:
        JSR   Cold_Start                ;SoftReset to the system



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; The following are tables of text to be displayed while the game is ongoing
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
l_RndOpenString1:
        DB      -30,-55,$81, "g RONEN HABOT JAN-2001", $81

l_RndOpenString2:
        DB      -60,-65,$81, "1 - VECTREX CONTROLLER, OR", $81

l_RndOpenString3:
        DB      -75,-55,$81, "4 - MODIFIED 2600 PADDLE", $81

l_RoundersString:
        DB      0,-40,$81, "ROUNDERS", $81

l_RndGameTypeMsg1:
        DB      50,-128,$81, "SELECT LEVEL:", $81

l_RndGameTypeMsg2:
        DB      20,-100,$81, "1 - NOVICE", $81

l_RndGameTypeMsg3:
        DB      00,-100,$81, "2 - INTERMEDIATE", $81

l_RndGameTypeMsg4:
        DB      -20,-100,$81, "3 - EXPERT", $81

l_RndHighScoreMsg:
        DB      90,-23,$81, "HIGH SCORE", $81

l_RndGameOverMsg:
        DB      3,-23,$81, "GAME OVER!", $81

l_RndLevelNOVICE:
        DB      $7F,$50,$81, "NOVICE", $81

l_RndLevelINTER:
        DB      $7F,$50,$81, "INTERMIDIATE", $81

l_RndLevelEXPERT:
        DB      $7F,$50,$81, "EXPERT", $81

l_RndLevelBLINK:
        DB      $7F,$50,$81, "SUPER!", $81



paddle1:
	FCB    0 * SCALE1,-12 * SCALE1
	FCB   -2 * SCALE1,  0 * SCALE1
	FCB    0 * SCALE1, 12 * SCALE1
	FCB    2 * SCALE1,  0 * SCALE1

l_Ball:
	FCB    3
	FCB    0 * SCALE1, -1 * SCALE1
	FCB   -1 * SCALE1,  0 * SCALE1
	FCB    0 * SCALE1,  1 * SCALE1
	FCB    1 * SCALE1,  0 * SCALE1

l_Box:
	FCB    3
	FCB    0 * SCALE2, -50 * SCALE2
	FCB   -50* SCALE2,  0 * SCALE2
	FCB    0 * SCALE2,  50* SCALE2
	FCB    50* SCALE2,  0 * SCALE2


	INCLUDE "sin.i"          
	INCLUDE "cos.i"          
	INCLUDE "BallMove.asm"
	INCLUDE "RadTbl.asm"
	INCLUDE "HitTbl.asm"
	INCLUDE "HitPos.asm"
	INCLUDE "RndTbl.asm"
	INCLUDE "DriveCtl.asm"


;;;;;;;;;;;;;
;;;;;;;;;;;;;
;;; MISC STUFF
;;;;;;;;;;;;;
;;;;;;;;;;;;;




;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;; do_menu: This procedure is responsible to write the menus of the game. It
;          displays different lines based on the game's mode. At the end, it
;          deletes all the menu lines...
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;s_RndPrintMenu:
;
;        RTS                             ;return to caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; s_PrintLevelMenu - Responsible to print the level menus
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;s_PrintLevelMenu:
;       LDA   CurrentLvl
;       CMPA  #LVL1                     ;Check if CurrentLvl == LVL1,
;       BNE   l_CheckLevel2                  ;If not, check if LVL2...
;       LDU   #menu_lvl1_line1_str      ;U <- Point to menu_lvl1_line1_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       LDU   #lvl1_str
;       BRA   l_PrintLevel                 ;Proceed to end of the procedure
;l_CheckLevel2:
;       CMPA  #LVL2                     ;Check if CurrentLvl == LVL2,
;       BNE   l_CheckLevel3                  ;If not, check if LVL3...
;       LDU   #menu_lvl2_line1_str      ;U <- Point to menu_lvl2_line1_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       LDU   #lvl2_str
;       BRA   l_PrintLevel                 ;Proceed to end of the procedure
;l_CheckLevel3:
;       LDU   #menu_lvl3_line1_str      ;U <- Point to menu_lvl3_line1_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       LDU   #lvl3_str
;l_PrintLevel:
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       LDU   #menu_line2_str           ;Always print menu_line2_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       RTS
;
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; s_PrintMissedMenu - 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;s_PrintMissedMenu:
;       LDU   #menu_explsn_line1_str    ;U <- Point to menu_explsn_line1_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       LDU   #menu_explsn_line2_str    ;U <- Point to menu_explsn_line1_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       LDU   #menu_line2_str           ;U <- Point to menu_line2_str
;       JSR   Print_Str_xy              ;Print the string pointed by U
;       RTS                                             ;Return to the caller


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;******************************************************************************
; convert a to ASCII, assumes u -> *start of string, 42,u: MSB, 43,u: LSB
;******************************************************************************
;s_AToHex:
;        PSHS  A
;        PSHS  A
;                                        ;Calculate ASCII for MSB
;        LSRA
;        LSRA
;        LSRA
;        LSRA
;        CMPA #$09
;        BLS  l_AddMsb0x30
;        ADDA #$07
;l_AddMsb0x30:
;        ADDA #$30
;        ;STA  42,U                      ;Store the MS nibble in location8 of the                                        ;current line
;        STA  43,U                       ;Store the MS nibble in location8 of the                                        ;current line
;
;        PULS  A                         ;Calculate ASCII for LSB
;        ANDA  #$0F
;        CMPA #$09
;        BLS  l_AddLsb0x30
;        ADDA #$07
;l_AddLsb0x30:
;        ADDA  #$30
;        ;STA   43,U                     ;Store the LS nibble in location9 of the
;        STA   44,U                      ;Store the LS nibble in location9 of the
;                                        ;current line
;        PULS  A
;        RTS                             ;Return to the caller
;


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;*****************************************************************************
;s_RndDToBcd:
;        LDU   #$0000
;l_RndCheck1000:
;        CMPD  #$3E7                     ;More than 1,000?
;        BLS   l_RndCheck100
;        SUBD  #$3E8                     ;Sub 1,000 from D,
;        LEAU  $1000,u                   ;Add 1,000 to u
;        BRA   l_RndCheck1000                ;Proceed, till D < 1000
;l_RndCheck100:
;        CMPD  #$63                      ;More than 100?
;        BLS   l_RndCheck10
;        SUBD  #$64                      ;Sub 100 from D,
;        LEAU  $100,u                    ;Add 100 to u
;        BRA   l_RndCheck100                 ;Proceed, till d < 100
;l_RndCheck10:
;        CMPD  #$09                      ;More than 9?
;        BLS   l_RndCompleteBcd
;        SUBD  #$0A                      ;Sub 10 from d,
;        LEAU  $10,u                     ;Add 10 to u
;        BRA   l_RndCheck10                  ;Proceed, till d < 10
;l_RndCompleteBcd:
;        LEAU  d,u                       ;Add the remain to u
;        TFR   u,d
;        RTS                             ;Return to the caller
;
;;
;
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;; s_DivideAtX: Divides two numbers:
;;           *x = a div b, *x+ = reminder, @ exit, b=remian, a=0
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;s_DivideAtX:
;        CLR   ,x                        ;clear the result field
;        STB   1,x                       ;*x+ <- b
;repeat_div:
;        CMPA  1,x                       ; check if b>a, if so, that's the end
;        BLO   a_smaller_then_b
;        SUBA  1,x                       ;a = a-b
;        INC   ,x                        ;result <- result + 1
;        BRA   repeat_div
;a_smaller_then_b:
;        STA   1,x
;        RTS                             ;Return to the caller
;
;
;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;; s_CheckPaddleHit - Checks whether the paddle are catching either the bombs,heart,
;;             diamond or, ex.
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;s_CheckPaddleHit:
;
;        RTS                             ;Return to the caller
;
;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;s_RndSelectPlyrNum:
;
;s_RndSelPlyrNum_loop:
;        JSR   Wait_Recal                ;reset the crt
;
;        RESET_0_REF;                    ;Call Reset0Ref macro
;        LDU   #l_RndSelectPlyrMsg1
;        PRINT_STR_YX                    ;Call enhenced print routine
;
;        RESET_0_REF;                    ;Call Reset0Ref macro
;        LDU   #l_RndSelectPlyrMsg2
;        PRINT_STR_YX                    ;Call enhenced print routine
;
;l_PlyrNumWaitForBtns:
;        JSR   Read_Btns   	        ; Get Buttons status
;        CMPA  #$00                      ; If no button pressed,
;        BEQ   s_RndSelPlyrNum_loop      ; goto opening_loop...
;
;l_PlyrNumCheckCntrl1Btn1:
;        BITA  #$01
;        BEQ   l_PlyrNumCheckCntrl1Btn2         ;
;
;l_PlyrNumButton1Pressed:
;	CLR   PlyrNum			;Set # of players to 1	
;	RTS
;
;l_PlyrNumCheckCntrl1Btn2:
;        BITA  #$02
;        BEQ   s_RndSelPlyrNum_loop	;Nothing else to check, keep looping
;
;l_PlyrNumButton2Pressed:
;	LDA   #$01
;	STA   PlyrNum			;Set # of players to 2	
;	RTS
;
;
;l_RndSelectPlyrMsg1:
;        DB      30,-60,$81, "PRESS 1 FOR SINGLE PLAYER GAME, OR,", $81
;
;l_RndSelectPlyrMsg2:
;        DB      -30,-50,$81, "PRESS 2 FOR TWO PLAYERS GAME.", $81
;
;;
