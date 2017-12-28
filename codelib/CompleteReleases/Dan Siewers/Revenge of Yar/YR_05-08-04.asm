;************ REVENGE OF YAR ***************
;*********** By Dan Siewers **************

;NOTES:
;		Scale of objects = 20
;		Scale for pen movement = 127
;		Points:
;			1 points each "nibble" on front of force field
;			5 points for bullet hitting front of force field
;			500 points for Super Bomb hitting any part of force field
;			1000 points for destroying each part of force field


	include	"vecbios.txt"

Buttons_State = Vec_Buttons



Count				equ	$c880		;2 bytes - general purpose counter
Print1			equ	$c882		;2 bytes - for test print string
Print2			equ	$c884		;2 bytes - for test print string
counter2			equ	$c886		;1 byte - for test print string
Str_y				equ	$c887		;1 byte - for test print string
Str_x				equ	$c888		;1 byte - for test print string
Test_String			equ	$c889		;9 bytes - for test print string
String_End			equ	$c891		;1 byte - for test print string
Dashed_Line_Counter	equ	$c892		;1 byte - counter for dashed lines routine
Dashed_Line_Pattern	equ	$c893		;1 byte - storage for dashed line pattern
Dashed_Line_Intensity	equ	$c894		;1 byte - dashed line intensity
Line_Intensity_Dir	equ	$c895		;1 byte - line intensity drection 0=up 1=down
Joy_State			equ	$c896		;1 byte - 1=left, 2=right, 3=up, 4=down
Yar_x				equ	$c897		;2 bytes - Yar's X-coordinates
Yar_y				equ	$c899		;2 bytes - Yar's Y-coordinates
Yar_Speed			equ	$c89b		;2 bytes - Yar's speed
Yar_Angle			equ	$c89d		;1 byte - Yar's current / incremental angle
Yar_Target_Angle		equ	$c89e		;1 byte - Yar's target angle
Yar_Rotate_Dir		equ	$c89f		;1 byte - +1=ccw, -1=cw
Yar_VL_Pointer		equ	$c8a0		;2 bytes - Pointer to Yar VL
Yar_Wing_State_Counter	equ	$c8a2		;1 byte - counter for Yar's wing state
Enemy_y			equ	$c8a3		;1 byte - Enemy ship's Y-coordinates
Enemy_x			equ	$c8a4		;1 byte - Enemy ship's X-coordinates
Enemy_Dir_Flag		equ	$c8a5		;1 byte - 0=up, 2=down
Enemy_Move_Count		equ	$c8a6		;1 byte - counter for enemy ship movement
Force_Field_Status	equ	$c8a7		;1 byte - 0=none, 1=inner field only , 2=both fields
Collision_Flag		equ	$c8a8		;1 byte - 0=none, 1=up, 2=down (direction of enemy travel)
Force_Field_1_Strength	equ	$c8a9		;2 bytes - Inner force field strength remaining
Force_Field_2_Strength	equ	$c8ab		;2 bytes - Outer force field strength remaining
Force_Field_Hit_Flag	equ	$c8ad		;1 byte - 0=not hit, 1=hit
Force_Field_1_Intensity	equ	$c8af		;2 bytes - Intensity value of inner force field
Force_Field_2_Intensity	equ	$c8b1		;1 byte - Intensity value of outer force field
Shooting_Status_Flag	equ	$c8b2		;1 byte - 0=not shooting, 1=shooting, 2=exploding
Bullet_y			equ	$c8b3		;2 bytes - bullet y position
Bullet_x			equ	$c8b5		;2 bytes - bullet x pos
Bullet_Angle		equ	$c8b7		;1 byte - bullet's angle of travel
Bullet_Speed		equ	$c8b8		;1 byte - bullet's speed
Explosion_Timer		equ	$c8b9		;1 byte - counter for bullet explosion routine
Explosion_Scale		equ	$c8ba		;1 byte - scale factor of explosion
Vanguard_Speed		equ	$c8bb		;1 byte - Vanguard's speed
Vanguard_y			equ	$c8bc		;2 bytes - Vanguard's Y-position
Vanguard_x			equ	$c8be		;2 bytes - Vangurad's X-position
Vanguard_Angle		equ	$c8c0		;1 byte - Vanguard's angle of travel
Vanguard_Hit_Yar_Flag	equ	$c8c1		;1 byte - 0=no hit, $ff=hit
Yar_Death_Spin_Counter	equ	$c8c2		;1 byte - Counter for Yar's death spin
Yar_Life_State		equ	$c8c3		;1 byte - $ff=Yar finished dying
Super_Bomb_Counter	equ	$c8c4		;1 byte - Counter for super bomb
Super_Bomb_Status_Flag	equ	$c8c5		;1 byte - 0=no bomb, 1=show bomb, 2=shoot bomb, 3=explode
Button_2_State		equ	$c8c6		;1 byte - 0=button 2 not pressed, 1=button 2 pressed
Super_Bomb_y		equ	$c8c7		;2 bytes - Super Bomb's Y-position
Super_Bomb_x		equ	$c8c9		;2 bytes - Super Bomb's X-position
Super_Bomb_Nibbles	equ	$c8cb		;1 byte - Yar # of "nibbles" to display super bomb
Fireball_Start_Counter	equ	$c8cc		;2 bytes - when it reaches 0 fireball is displayed
Fire_Ball_Status		equ	$c8ce		;2 bytes - 0=delay, 1=stationary, 2=shooting, 3=reset, 4=about to shoot
Random_Seed			equ	$c8d0		;3 bytes - random number generator seed
Fireball_Angle		equ	$c8d4		;1 byte - Firball's rotation angle
Fireball_y			equ	$c8d5		;2 bytes - Fireball's Y-coordinate
Fireball_x			equ	$c8d7		;2 bytes - Fireball's X-coordinate
Fireball_Spin_Time	equ	$c8d9		;1 byte - Fireball's rotation time
Fireball_Speed		equ	$c8da		;1 byte - Fireball's speed
Fireball_Shoot_Angle	equ	$c8db		;1 byte - Fireball's shooting angle
Fireball_Rise		equ	$c8dc		;2 bytes - Yar's rise value from fireball
Fireball_Run		equ	$c8de		;2 bytes - Yar's run value from fireball
Fireball_Calc_Temp	equ	$c8df		;1 byte
Level				equ	$c8e0		;1 byte - Current level
Level_List			equ	$c8e1		;6 bytes - Level in ASCII
Level_Print			equ	$c8e7		;7 bytes - Level print list
Yar_Lives			equ	$c8ee		;1 bytes - Yar's current number of lives
Yar_Lives_List		equ	$c8ef		;6 bytes - Yar's number of lives in ASCII
Yar_Lives_Print		equ	$c8f5		;7 bytes - Yar's number of lives print list
Score				equ	$c8fc		;6 bytes - Player's score
Score_List			equ	$c902		;6 bytes - Player's score in ASCII
Score_Print			equ	$c908		;11 bytes - Player's score print list
Sound_Type			equ	$c913		;1 byte - 0=grumble,1=fireball,3=fireball shooting

Yar_VL_Rotated		equ	$ca00		;43 bytes - Rotated Yar vector list
Fireball_VL_Rotated	equ	$ca30		;16 bytes - Rotated Fireball vector list

	
	org	$0000


;******************
;Magic Init Block
;******************
	fcb	$67,$20
	fcc	"GCE 2004"
	fcb	$80
	fdb	Intro_Music
	fdb	$f850
	fcb	30,-115
	fcc	"DAN SIEWERS PRESENTS"
	fcb	$80,$0

Cold_Start
	lda	#2
	sta	Force_Field_Status		;make sure we start with two force fields
	ldd	#$0100
	std	Force_Field_1_Strength		;set force fields to full strength
	std	Force_Field_2_Strength
	clr	Force_Field_Hit_Flag		;clear the force field hit flag
	lda	#$7f
	sta	Force_Field_1_Intensity		;set force field intensity
	sta	Force_Field_2_Intensity

	lda	#$5
	sta	Vanguard_Speed			;set Vanguard's initital speed
	lda	#150
	sta	Fireball_Speed			;set Fireball's initial speed

	lda	#1					;set Level to 1
	sta	Level
	lda	#$30					;clear the level ASCII string
	std	Level_List
	std	Level_List+2
	std	Level_List+4
	lda	#$31					;make sure to put a 1 in level string
	sta	Level_List+5

	lda	#$f5					;set up Level print string
	ldb	#$60
	std	Level_Print
	lda	#-30
	ldb	#-35
	std	Level_Print+2
	lda	#$80
	sta	Level_Print+6
	
	clr	Print1				;set up Print_String variables
	clr	Print1+1
	clr	Print2
	clr	Print2+1
	lda	#50					
	ldb	#-50
	sta	Str_y
	stb	Str_x
	lda	#$80
	sta	String_End

	lda	#5					;Yar starts with 5 lives
	sta	Yar_Lives
	lda	#$30					;clear the Yar lives left ASCII string
	std	Yar_Lives_List
	std	Yar_Lives_List+2
	std	Yar_Lives_List+4
	lda	#$35					;make sure to put a 5 in Yar lives string
	sta	Yar_Lives_List+5

	lda	#$f5					;set up Yar Lives print string
	ldb	#$60
	std	Yar_Lives_Print
	lda	#119
	ldb	#-25
	std	Yar_Lives_Print+2
	lda	#$80
	sta	Yar_Lives_Print+6

	clra						;clear the Score
	sta	Score
	sta	Score+1
	sta	Score+2
	sta	Score+3
	sta	Score+4
	sta	Score+5	

	lda	#$20					;clear the Score ASCII string
	sta	Score_List
	sta	Score_List+1
	sta	Score_List+2
	sta	Score_List+3
	sta	Score_List+4
	lda	#$30
	sta	Score_List+5

	lda	#$f5					;set up Score print string
	ldb	#$60
	std	Score_Print
	lda	#45
	ldb	#-80
	std	Score_Print+2
	lda	#$80
	sta	Score_Print+10

Level_Start	
	clr	Count					;clear the general counters
	clr	Count+1
	
	ldu	#Dashed_Line_String
	lda	16,u
	sta	Dashed_Line_Pattern		;set initial line pattern for dashed lines
	lda	17,u
	sta	Dashed_Line_Intensity		;set initial intensity for dashed lines
	clr	Dashed_Line_Counter
	clr	Line_Intensity_Dir		;set line intensity direction to "UP"

	clr	Joy_State				;here we set all joystick paramters
	lda	#1
	sta	Vec_Joy_Mux_1_X			;make sure we only look at joystick 1
	lda	#3
	sta	Vec_Joy_Mux_1_Y
	clr	Vec_Joy_Mux_2_X
	clr	Vec_Joy_Mux_2_Y

	ldd	#0000
	std	Yar_y
	lda	#-100
	ldb	#00
	std	Yar_x					;set Yar's start position
	ldd	#$01ff
	std	Yar_Speed				;set Yar's speed
	lda	#$30
	sta	Yar_Target_Angle
	sta	Yar_Angle				;set Yar to face right
	clr	Yar_Rotate_Dir			;set Yar to no rotate
	ldd	#Yar_VL_Wings_Up				
	std	Yar_VL_Pointer			;set Yar VL list pointer
	clr	Yar_Wing_State_Counter
	
	jsr	DP_to_C8				;set up Yar's VL list
	lda	Yar_Angle
	ldx	Yar_VL_Pointer
	leax	0,x
	ldu	#Yar_VL_Rotated
	jsr	Rot_VL_Mode				;now rotate Yar
	jsr	DP_to_D0

	lda	#0					;set enemy ship's start position
	ldb	#115
	std	Enemy_y
	clr	Enemy_Dir_Flag			;set enemy ship to scroll up
	clr	Enemy_Move_Count			;clear the enemy ship move counter
	

	clr	Collision_Flag

	ldd	#0000					;clear bullet (y,x) values
	std	Bullet_y
	std	Bullet_x
	ldd	#$0300				;set bullet's speed
	std	Bullet_Speed
	clr	Shooting_Status_Flag		;clear the shooting flag
	clr	Explosion_Timer			;clear explosion timer
	lda	#16
	sta	Explosion_Scale			;set initial scale factor for explosion

	ldd	#0000
	std	Vanguard_y				;set Vanguard's start position
	ldd	#$4500
	std	Vanguard_x
	clr	Vanguard_Angle
	clr	Vanguard_Hit_Yar_Flag

	clr	Yar_Death_Spin_Counter
	clr	Yar_Life_State
	
	clr	Super_Bomb_Status_Flag
	lda	#50					;Yar needs to "nibble" this many times
	sta	Super_Bomb_Nibbles
	sta	Super_Bomb_Counter		;for the super bomb to appear

	clr	Button_2_State
	
	ldd	#0
	std	Super_Bomb_y
	std	Super_Bomb_x

	clr	Fireball_Start_Counter
	clr	Fireball_Start_Counter+1
	lda	#3					;flag fireball to generate a random delay
	sta	Fire_Ball_Status
	clr	Fireball_Angle

	jsr	Clear_Sound
	clr	Vec_Music_Flag

Intro
	jsr	Wait_Recal
	lda	#127					;display score
	sta	VIA_t1_cnt_lo
	lda	#$5f
	jsr	Intensity_a
	jsr	Reset0Ref
	lda	#80
	ldb	#-40
	jsr	Moveto_d
	lda	#40
	sta	VIA_t1_cnt_lo
	ldx	#Score_VL
	jsr	Draw_VLp
	lda	#127					;display level
	sta	VIA_t1_cnt_lo
	lda	#$5f
	jsr	Intensity_a
	jsr	Reset0Ref
	lda	#-15
	ldb	#-40
	jsr	Moveto_d
	lda	#40
	sta	VIA_t1_cnt_lo
	ldx	#Level_VL
	jsr	Draw_VLp
	lda	Level_List+4			;here we display the actual level in ASCII
	sta	Level_Print+4
	ldb	Level_List+5
	stb	Level_Print+5
	jsr	Reset0Ref
	lda	#$7f
	jsr	Intensity_a
	ldu	#Level_Print
	jsr	Print_Str_hwyx
	lda	#127					;draw Yar symbol
	sta	VIA_t1_cnt_lo
	lda	#$5f
	jsr	Intensity_a
	jsr	Reset0Ref
	lda	#112
	ldb	#-35
	jsr	Moveto_d
	lda	#20
	sta	VIA_t1_cnt_lo
	ldx	#Yar_VL_Rotated
	jsr	Draw_VLp
	lda	#127					;display equals sign
	sta	VIA_t1_cnt_lo
	lda	#$5f
	jsr	Intensity_a
	jsr	Reset0Ref
	lda	#115
	ldb	#-25
	jsr	Moveto_d
	lda	#40
	sta	VIA_t1_cnt_lo
	ldx	#Equals_VL
	jsr	Draw_VLp
	lda	Yar_Lives_List+4			;here we display Yar's lives left in ASCII
	sta	Yar_Lives_Print+4
	ldb	Yar_Lives_List+5
	stb	Yar_Lives_Print+5
	jsr	Reset0Ref
	lda	#$7f
	jsr	Intensity_a
	ldu	#Yar_Lives_Print
	jsr	Print_Str_hwyx
	ldd	Score_List				;here we display Yar's score in ASCII
	std	Score_Print+4
	ldd	Score_List+2
	std	Score_Print+6
	ldd	Score_List+4
	std	Score_Print+8
	jsr	Reset0Ref
	lda	#$7f
	jsr	Intensity_a
	ldu	#Score_Print
	jsr	Print_Str_hwyx
	lda	#127					;now for the "Press Button 1" message
	sta	VIA_t1_cnt_lo
	jsr	Reset0Ref
	lda	#$7f
	jsr	Intensity_a
	ldu	#Button_1_To_Begin
	jsr	Print_Str_hwyx
	jsr	Read_Btns				;read state of all buttons
	lda	Buttons_State			;get state of button 1
	bne	We_Start_Here			;button 1 pressed?
	bra	Intro					;button 1 not pressed
	
We_Start_Here
	lda	Sound_Type
	beq	Grumble_Sound
	cmpa	#1
	beq	Fireball_Sound
	cmpa	#2
	beq	Fireball_Shooting_Sound
	cmpa	#3
	beq	Super_Bomb_Shooting_Sound
Fireball_Sound
	lda	Vec_Music_Flag
	bne	Keep_Playing
	lda	#1
	sta	Vec_Music_Flag
	ldu	#Fireball_Music
	bra	Keep_Playing
Grumble_Sound
	lda	Vec_Music_Flag
	bne	Keep_Playing
	lda	#1
	sta	Vec_Music_Flag
	ldu	#Grumble
	bra	Keep_Playing
Fireball_Shooting_Sound
	lda	Vec_Music_Flag
	bne	Keep_Playing
	lda	#1
	sta	Vec_Music_Flag
	ldu	#Fireball_Shooting_Music
	bra	Keep_Playing
Super_Bomb_Shooting_Sound
	lda	Vec_Music_Flag
	bne	Keep_Playing
	lda	#1
	sta	Vec_Music_Flag
	ldu	#Super_Bomb_Shooting_Music
	;bra	Keep_Playing
Keep_Playing
	jsr	DP_to_C8
	jsr	Init_Music_chk
	jsr	Wait_Recal
	jsr	Do_Sound
	bsr	Dashed_Lines
	;jsr	Print_String
	lda	Yar_Life_State			;has Yar died?
	cmpa	#$ff
	bne	We_Start_Here			;no, continue playing
	dec	Yar_Lives
	bmi	End_Of_Game
	dec	Yar_Lives_List+5
	bra	Level_Start
End_Of_Game
	bra	Cold_Start



;*******************************************************************************
;---Dashed_Lines---
;This routine draws the dashed lines on the screen
;Four lines are drawn, two above and two below the X-axis
;The line intensity is raised or lowered depending on the "Dashed_Line_Dir" flag
;*******************************************************************************
Dashed_Lines
	ldu	#Dashed_Line_String			;pointer to x, y and pattern data
	lda	Dashed_Line_Intensity
	ldb	Line_Intensity_Dir			;dashed line intensity goes up or down?
	beq	Dashed_Line_Intensity_Up
	cmpa	17,u						;dashed line intesity goes down here
	beq	Change_Line_Intensity_Direction
	deca
	bra	Save_Dashed_Line_Intensity
Dashed_Line_Intensity_Up				;dashed line intensity goes up here
	cmpa	#$7f
	beq	Change_Line_Intensity_Direction
	inca
	bra	Save_Dashed_Line_Intensity
Change_Line_Intensity_Direction	
	eorb	#1						;flip intensity direction flag when ready
	stb	Line_Intensity_Dir
	bra	Dashed_Lines_Start
Save_Dashed_Line_Intensity
	sta	Dashed_Line_Intensity
	jsr	Intensity_a					;go set intensity
Dashed_Lines_Start
	lda	Dashed_Line_Pattern				
	andcc	#%11111110					;here we change the line pattern...
	rora							;by moving all bits over by on bit to the right
	bne	Change_Line_Pattern
	lda	16,u						;here we reset the line patterns
Change_Line_Pattern
	sta	Dashed_Line_Pattern
Dashed_Line_Reset
	sta	Dashed_Line_Counter
	lda	#4
	sta	Count						;we are drawing four lines
	lda	#127
	sta	VIA_t1_cnt_lo				;set scale factor
Dashed_Lines_1
	jsr	Reset0Ref
	ldd	,u++
	jsr	Moveto_d					;move pen
	lda	Dashed_Line_Pattern
	sta	Vec_Pattern					;set the line pattern
	lda	#0
	leax	0,u
	leau	2,u						
	jsr	Draw_Pat_VL_a				;draw the dashed lines
	dec 	Count
	bne	Dashed_Lines_1				;make sure we draw all lines
	
;***********************************************************
;This routine reads the joystick and then places the results
;in Joy_State
;Yar's Target angle is also determined here. The target angle
;is Yar's final resting angle should a turn be initiated
;***********************************************************
Read_Joystick
	lda	Vanguard_Hit_Yar_Flag		;has Vanguard hit Yar?
	bne	Joy_No_Move				;yes, ignore joystick
	lda	Yar_Rotate_Dir			;is Yar rotating?
	bne	Yar_Set_Rotation			;yes, keep rotating
	jsr	Joy_Digital				;Read Joystick
	lda	Vec_Joy_1_X				;check left/right
	beq	Check_Up_Down		
	bmi	Joy_Left				;left joy?
Joy_Right
	lda	#02					;no, must be right
	sta	Joy_State
	lda	#$30
	sta	Yar_Target_Angle			;set Yar's target angle
	bra	Yar_Set_Rotation
Joy_Left
	lda	#1					;left joy
	sta	Joy_State
	lda	#$10
	sta	Yar_Target_Angle			;set Yar's target angle
	bra	Yar_Set_Rotation
Check_Up_Down
	lda	Vec_Joy_1_Y				;now check up/down
	beq	Joy_No_Move
	bmi	Joy_Down
Joy_Up
	lda	#3					;up joy
	sta	Joy_State
	lda	#$00
	sta	Yar_Target_Angle			;set Yar's target angle
	bra	Yar_Set_Rotation
Joy_Down
	lda	#4					;down joy
	sta	Joy_State
	lda	#$20
	sta	Yar_Target_Angle			;set Yar's target angle
	bra	Yar_Set_Rotation
Joy_No_Move
	lda	#0					;no joystick pressed
	sta	Joy_State
	lbra	Move_Yar_Wings			;go check wings


;**************************************************************
;This routine calculates the Yar's rotation angle and direction
;It is called from the Read_Joystick routine
;**************************************************************

Yar_Set_Rotation
	lda	Yar_Rotate_Dir
	bne	Yar_Is_Rotating			;Yar is already rotating, go process
	lda	Yar_Target_Angle
	cmpa	Yar_Angle				;Yar already facing desired direction of travel?
	lbeq	Move_Yar				;yes, go move him
	lda	Joy_State				;no, he starts rotating here
	cmpa	#1					
	bne	Check_Joy_2
	ldu	#Yar_Rot_Table_Left		;Joy left, pointer table for rotation values
	bra	Yar_Start_Rotating
Check_Joy_2
	cmpa	#2					;Joy right
	bne	Check_Joy_3
	lda	Yar_Angle
	bne	Right_Turn_Not_From_Up		
	lda	#$40					;if Yar is pointing up then
	sta	Yar_Angle				;change his start angle to $40 and count down to $30
Right_Turn_Not_From_Up
	ldu	#Yar_Rot_Table_Right		;Joy right, pointer table for rotation values
	bra	Yar_Start_Rotating
Check_Joy_3
	cmpa	#3
	bne	Must_Be_Joy_4
	lda	Yar_Angle
	cmpa	#$30
	bne	Not_Rot_From_30
	lda	#$40					;if Yar is pointing right then
	sta	Yar_Target_Angle			;change his target angle to $40 and count up
Not_Rot_From_30
	ldu	#Yar_Rot_Table_Up			;Joy Up, pointer table for rotation values
	bra	Yar_Start_Rotating
Must_Be_Joy_4
	ldu	#Yar_Rot_Table_Down		;Joy down, pointer table for rotation values
Yar_Start_Rotating
	lda	Yar_Angle				;get Yar's current angle
	lsra
	lsra
	lsra
	lsra
	lda	a,u					;get the rotation direction from table
	sta	Yar_Rotate_Dir
Yar_Is_Rotating	
	lda	Yar_Angle
	adda	Yar_Rotate_Dir			;increment Yar's current angle
	cmpa	Yar_Target_Angle			;Yar done rotating?
	bne	Yar_Is_Rotating_1			;nope, he still needs to spin a little more
	cmpa	#$40
	bne	Clear_Direction_Register
	clra						;make sure angle changes to $00 from $40
	clr	Yar_Target_Angle			;same for target angle
Clear_Direction_Register
	clr	Yar_Rotate_Dir			;yes, stop him from rotating
Yar_Is_Rotating_1
	sta	Yar_Angle				;save Yar's new angle
	pshs	dp
	lda	#$c8
	tfr	a,dp
	lda	Yar_Angle
	ldx	Yar_VL_Pointer
	leax	0,x
	ldu	#Yar_VL_Rotated
	jsr	Rot_VL_Mode				;now rotate Yar
	puls	dp
	lbra	Draw_Yar

Yar_Rot_Table_Left
	fcb	+1					;direction if Yar_angle is $00
	fcb	0					;direction if Yar_angle is $10
	fcb	-1					;direction if Yar_angle is $20
	fcb	-1					;direction if Yar_angle is $30

Yar_Rot_Table_Right
	fcb	-1					;direction if Yar_angle is $00
	fcb	+1					;direction if Yar_angle is $10
	fcb	+1					;direction if Yar_angle is $20
	fcb	0					;direction if Yar_angle is $30
	fcb	-1					;direction if Yar_angle is $40

Yar_Rot_Table_Up
	fcb	0					;direction if Yar_angle is $00
	fcb	-1					;direction if Yar_angle is $10
	fcb	-1					;direction if Yar_angle is $20
	fcb	+1					;direction if Yar_angle is $30

Yar_Rot_Table_Down
	fcb	+1					;direction if Yar_angle is $00
	fcb	+1					;direction if Yar_angle is $10
	fcb	0					;direction if Yar_angle is $20
	fcb	-1					;direction if Yar_angle is $30


;*********************************************************
;This routine move's Yar around the screen
;player's ship is adjusted to reflect joystick direction
;Yar is prevented from running off edge of screen
;Yar is also prevented from running through a force field
;*********************************************************

Move_Yar
	lda	Joy_State					;Was Joystick moved?
	cmpa	#01						;joystick left
	bne	Move_Yar_2
	lda	Yar_x
	bpl	Move_Yar_Left_Plus			;branch if we are right of Y-Axis
	ldd	Yar_x						;here we are left of the Y-Axis
	subd	Yar_Speed					;move Yar to the left
	cmpa	#$7f						;have we reached the end of the screen?
	bls	Move_Yar_Max_Left				;yes we have reached the end of the screen
	std	Yar_x						;no, save the new X coordinate value
	lbra	Move_Yar_Wings
Move_Yar_Max_Left
	lda	#$80						;here we keep Yar from...
	sta	Yar_x						;going off screen edge
	lbra	Move_Yar_Wings
Move_Yar_Left_Plus	
	ldd	Yar_x						;Here we are to the right of the Y-axis
	subd	Yar_Speed
	std	Yar_x
	lbra	Move_Yar_Wings
Move_Yar_2
	cmpa	#02						;joystick right
	bne	Move_Yar_3
	lda	Collision_Flag				;don't move Yar if he has hit a force field
	lbne	Move_Yar_Wings
	lda	Yar_x
	bmi	Move_Yar_Right_Minus			;branch if we are left of Y-Axis
	ldd	Yar_x						;here we are right of the Y-Axis
	addd	Yar_Speed					;move Yar to the right
	cmpa	#$80						;have we reached the end of the screen?
	bhs	Move_Yar_Max_Right			;yes we have reached the end of the screen
	std	Yar_x						;no, save the new X coordinate value
	lbra	Move_Yar_Wings
Move_Yar_Max_Right
	lda	#$7f						;here we keep Yar from...
	sta	Yar_x						;going off screen edge
	lbra	Move_Yar_Wings
Move_Yar_Right_Minus
	ldd	Yar_x						;here we are left of the Y-Axis
	addd	Yar_Speed
	std	Yar_x
	lbra	Move_Yar_Wings
Move_Yar_3
	cmpa	#03						;joystick up
	bne	Move_Yar_4
	lda	Collision_Flag				;don't move Yar if he has hit a force field
	bne	Move_Yar_Wings
	lda	Yar_y
	bmi	Move_Yar_Up_Plus				;branch if we are below the X-Axis
	ldd	Yar_y						;here we are above of the X-Axis
	addd	Yar_Speed					;move Yar up
	cmpa	#$80						;have we reached the end of the screen?
	bhs	Move_Yar_Max_Up				;yes we have reached the end of the screen
	std	Yar_y						;no, save the new Y coordinate value
	lbra	Move_Yar_Wings
Move_Yar_Max_Up
	lda	#$7f						;here we keep Yar from...
	sta	Yar_y						;going off screen edge
	lbra	Move_Yar_Wings
Move_Yar_Up_Plus	
	ldd	Yar_y						;Here we are below the X-axis
	addd	Yar_Speed
	std	Yar_y
	lbra	Move_Yar_Wings
Move_Yar_4
	lda	Collision_Flag				;don't move Yar if he has hit a force field
	bne	Move_Yar_Wings
	lda	Yar_y
	bpl	Move_Yar_Down_Plus			;branch if we are above the X-Axis
	ldd	Yar_y						;here we are below the X-Axis
	subd	Yar_Speed					;move Yar down
	cmpa	#$7f						;have we reached the end of the screen?
	bls	Move_Yar_Max_Down				;yes we have reached the end of the screen
	std	Yar_y						;no, save the new X coordinate value
	bra	Move_Yar_Wings
Move_Yar_Max_Down
	lda	#$80						;here we keep the Yar from...
	sta	Yar_y						;going off screen edge
	bra	Move_Yar_Wings
Move_Yar_Down_Plus	
	ldd	Yar_y						;Here we are above the X-axis
	subd	Yar_Speed
	std	Yar_y
Move_Yar_Wings
	clr	Collision_Flag				;clear the collision flag
	inc	Yar_Wing_State_Counter
	lda	Yar_Wing_State_Counter
	cmpa	#$07						;time to change wing state?
	bne	Draw_Yar
	clr	Yar_Wing_State_Counter			;yes, clear the counter
	ldd	Yar_VL_Pointer
	cmpd	#Yar_VL_Wings_Up				;check wing state
	beq	Yar_Wings_Down
	ldd	#Yar_VL_Wings_Up				;wings are down, set them to go up
	bra	Yar_Set_Wings
Yar_Wings_Down
	ldd	#Yar_VL_Wings_Down			;wings are up, set them to go down
Yar_Set_Wings
	std	Yar_VL_Pointer
	lda	Yar_Angle					;make sure new VL is in rotated VL table
	lbra	Yar_Is_Rotating_1

;*******************************************
;Here we draw Yar 
;*******************************************
Draw_Yar
	lda	Yar_Life_State
	bne	Draw_Enemy
	lda	#127
	sta	VIA_t1_cnt_lo
	lda	#$5f
	jsr	Intensity_a
	jsr	Reset0Ref
	lda	Yar_y
	ldb	Yar_x
	jsr	Moveto_d
	lda	#20
	sta	VIA_t1_cnt_lo
	ldx	#Yar_VL_Rotated
	jsr	Draw_VLp
		
;*******************************************
;Here we draw Enemy Ship
;Also, the enemy ship is moved up or down depending
;upon the Enemy_Dir_Flag status
;*******************************************
Draw_Enemy
	inc	Enemy_Move_Count
	lda	Enemy_Move_Count
	cmpa	#2					;move ship every second entry to this routine
	bne	Enemy_Stays_Put
	clr	Enemy_Move_Count			;now start moving the ship
	ldu	#Enemy_Ship_Move_Data		
	ldb	Enemy_Dir_Flag
	lda	b,u
	adda	Enemy_y				;move the ship according to enemy ship data table
	sta	Enemy_y
	incb
	lda	b,u
	cmpa	Enemy_y				;check to see if ship has reached end of travel limit
	bne	Enemy_Stays_Put
Change_Enemy_Dir_Flag
	lda	Enemy_Dir_Flag			;reverse ship direction of travel
	eora	#$2
	sta	Enemy_Dir_Flag
Enemy_Stays_Put
	lda	Fire_Ball_Status			;make sure the firball is not on the screen
	bne	Draw_Force_Field			;if so do not draw the enemy ship
	lda	#127					;otherwise draw it
	sta	VIA_t1_cnt_lo
	lda	#$6f
	jsr	Intensity_a
	jsr	Reset0Ref				;now draw the ship
	lda	Enemy_y
	ldb	Enemy_x
	jsr	Moveto_d
	lda	#20
	sta	VIA_t1_cnt_lo
	ldx	#Enemy_VL
	jsr	Draw_VLp

;*******************************************************
;Here we draw the force fields that surround the
;the enemy ship
;The force fields will move along with the enemy ship
;*******************************************************
Draw_Force_Field
	ldb	Force_Field_Status
	beq	No_Force_Field			;no force fields to draw
	stb	Count
	ldu	#Force_Field_1_Intensity
Draw_Force_Field_Loop
	ldx	#Enemy_Force_Field		;vector list points to inner force field
	lda	#127
	sta	VIA_t1_cnt_lo
	jsr	Reset0Ref
	ldb	Enemy_x
	lda	Enemy_y
	jsr	Moveto_d				;move integrators to center of enemy ship
	ldb	Count
	andb	#2					;which force field are we drawing here?
	pshs	b
	lda	b,u
	jsr	Intensity_a				;set force field intensity
	puls	b
	cmpb	#2					;are we drawing outer force field here?
	bne	Draw_Inner_Force_Field_Only	;no, inner force field only
	leax	8,x					;now vector list points to outer force field
Draw_Inner_Force_Field_Only
	lda	#3					;get number of coordinates to draw
	jsr	Mov_Draw_VL_a			;draw the force field
	dec	Count
	beq	No_Force_Field			;leave routine if we are finished here
	bra	Draw_Force_Field_Loop
No_Force_Field
	lda	Dashed_Line_Intensity		;make sure to reset intensity back to...
	jsr	Intensity_a				;that of the dashed lines

;******************************************************
;This routine checks to see if yar has hit any objects
;If Yar hits the front of one of the force fields
;then that force field is flagged to be weakened
;If yar hits the top or bottom of the force field then the
;force field will push him
;******************************************************
Check_Yar_Hit_Anything
	lda	Vanguard_Hit_Yar_Flag		;has Vanguard hit Yar?
	lbne	Force_Field_Update		;yes, skip collision detection routines
	lda	Yar_x
	cmpa	#$4d					;is Yar close to enemy ship?
	lblo	Check_Hit_Vanguard		;nope go check other potential collisions
	lda	Force_Field_Status
	beq	Check_Hit_Enemy			;no force fields, check other collisions
	ldy	Enemy_y				;now check to see if we have hit a force field
	lda	Yar_y
	ldb	Yar_x
	tfr	d,x
	lda	Force_Field_Status
	cmpa	#1					;which one?
	bne	Check_Col_2_Force_Fields
	lda	#35					;h/2 of inner force field
	ldb	#26					;w/2 of inner force field
	bra	Check_Yar_Hit_Force_Field
Check_Col_2_Force_Fields
	lda	#45					;h/2 of outer force field
	ldb	#36					;w/2 of outer force field
Check_Yar_Hit_Force_Field
	jsr	Obj_Hit				;force field hit?
	bcc	Check_Hit_Vanguard		;nope go see if we hit anything else
	ldb	Force_Field_Status
	ldu	#Hit_Force_Field_Data
	lda	Yar_x
	cmpa	b,u					;is Yar in front of the Force Field?
	blo	Yar_Is_Infront_Enemy		;yes, make sure he does not move forward
	lda	Enemy_Dir_Flag			;yes, we hit the force field
	bne	Enemy_Is_Moving_Down		;which way is the enemy ship moving?
	lda	Enemy_y				;here the enemy is moving up
	cmpa	Yar_y
	bgt	Yar_Is_Below_Enemy_Up
	inc	Yar_y					;increment Yar's Y-pos if he is above the enemy
	inc	Yar_y
Yar_Is_Below_Enemy_Up
	inc	Collision_Flag			;here Yar is below the ship
	bra	Force_Field_Update
Enemy_Is_Moving_Down
	lda	Enemy_y				;here the enemy is moving down
	cmpa	Yar_y
	blt	Yar_Is_Above_Enemy_Down
	inc	Collision_Flag
	dec	Yar_y					;decrement Yar's Y-Pos if he is below the ship
	dec	Yar_y
Yar_Is_Above_Enemy_Down
	inc	Collision_Flag			;here Yar is above the ship
	bra	Force_Field_Update
Yar_Is_Infront_Enemy
	ldd	Yar_x					;Here we bounce Yar off the front of the
	subd	Yar_Speed				;force field
	std	Yar_x
	inc	Collision_Flag			;set the collision flag
	inc	Force_Field_Hit_Flag		;set the force field hit flag
	dec	Super_Bomb_Counter		;decrement the bomb counter
	lda	#1					;add 1 points to the score
	ldx	#Score_List
	jsr	Add_Score_a
	clr	Shooting_Status_Flag		;get rid of any bullet the is on the screen
Check_Hit_Enemy
	lda	Enemy_y				;now see if Vaguard has run into Yar
	ldb	Enemy_x
	tfr	d,y
	lda	Yar_y
	ldb	Yar_x
	tfr	d,x
	lda	#4					;Enemy's h/2
	ldb	#9					;Enemy's w/2
	jsr	Obj_Hit				;Enemy touched Yar?
	bcc	Check_No_Hit			;nope, go check other collisions
	clr	Super_Bomb_Counter		;yes flag the super bomb
Check_Hit_Vanguard
	lda	Vanguard_y				;now see if Vaguard has run into Yar
	ldb	Vanguard_x
	tfr	d,y
	lda	Yar_y
	ldb	Yar_x
	tfr	d,x
	lda	#4					;Vanguard's h/2
	ldb	#9					;Vanguard's w/2
	jsr	Obj_Hit				;Vanguard touched Yar?
	bcc	Check_No_Hit			;nope, go check other collisions
	lda	#$ff					;yes, set the hit flag
	sta	Vanguard_Hit_Yar_Flag		;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	bra	Force_Field_Update
Check_No_Hit
	;rts	

;******************************************************
;This routine updates the force fields
;Here we decrease the force field strength and intensity 
;if the force field was hit
;******************************************************
Force_Field_Update
	lda	Force_Field_Hit_Flag		;was force field hit?
	bne	Force_Field_Was_Hit		
	bra	Joy_Buttons				;no, go check button press
Force_Field_Was_Hit
	clr	Force_Field_Hit_Flag		;clear the force field hit flag
	ldu	#Force_Field_1_Strength		
	ldb	Force_Field_Status		;make sure we look at the first
	andb	#2					;active force field
	ldx	b,u
	leax	-1,x					;now decrease it's strength
	beq	Force_Field_Dead			;the force field needs to be destroyed
	stx	b,u					;save the force field strength data
	clr	Count
	clrb
Force_Field_Intensity_Update
	ldu	#Force_Field_Intensity_Data	;has the force field weakened enough
	cmpx	b,u					;to warrant decreasing the intensity?
	beq	Change_Intensity			;yes
	addb	#3					
	cmpb	#12					;otherwise keep checking
	bne	Force_Field_Intensity_Update
	bra	Joy_Buttons				;now go check button press
Change_Intensity
	incb
	incb
	lda	b,u					;get the new intensity setting
	ldb	Force_Field_Status
	andb	#2
	ldx	#Force_Field_1_Intensity
	sta	b,x					;now save the new setting
	bra	Joy_Buttons				;now go check button press
Force_Field_Dead
	dec	Force_Field_Status		;here we destroy the force field
	ldb	#3
Force_Field_Add_Score
	pshs	b					;now we add 1000 points to score
	lda	#250
	ldx	#Score_List
	jsr	Add_Score_a
	puls	b
	decb
	bne	Force_Field_Add_Score
		


;*******************************************************************
;This routine reads the joystick buttons
;and processes the bullets
;Here we also draw the exploding bullet if it has hit a force field
;Yar is kept from firing if he is in the middle zone
;*******************************************************************
Joy_Buttons
	lda	Shooting_Status_Flag		;is there a bullet already on screen?
	lbne	Still_Shooting
	lda	Vanguard_Hit_Yar_Flag		;has Vanguard hit Yar?
	lbne	Joy_Buttons_Next			;yes, ignore button press
	lda	Yar_Rotate_Dir			;first make sure Yar is not rotating
	beq	Joy_Buttons_Not_Rotating
	lbra	Joy_Buttons_Next			;Yar is rotating so move on
Joy_Buttons_Not_Rotating
	lda	Yar_x					;is Yar in the middle zone?
	bpl	Joy_Buttons_Right_Zone		
	cmpa	#$d3
	blo	Joy_Buttons_Not_Zone		;no, he is to the right of it
	lbra	Joy_Buttons_Next
Joy_Buttons_Right_Zone
	cmpa	#5
	bhi	Joy_Buttons_Not_Zone		;no, he is to the left of it
	lbra	Joy_Buttons_Next
Joy_Buttons_Not_Zone
	jsr	Read_Btns				;read state of all buttons
	lda	Buttons_State+2			;get state of button 3
	bne	Start_Shooting			;button 3 pressed?
	lbra	Joy_Buttons_Next			;button 2 not pressed
Start_Shooting					;yes, start shooting here
	lda	Super_Bomb_Status_Flag		;super bomb on screen?
	beq	Start_Shooting_Bullet	
	lbra	Vanguard_Move			;yes, do not process bullets
Start_Shooting_Bullet
	ldb	Yar_Angle				;first we see if Yar is too close to edge of screen
	bne	Shoot_Yar_Facing_Left
Shoot_Yar_Facing_Up
	lda	Yar_y					;here Yar is facing up
	bmi	Calculate_Bullet_Start_Pos
	cmpa	#$7a					;is he too close to the edge of screen?
	blo	Calculate_Bullet_Start_Pos
	lbra	Joy_Buttons_Next
Shoot_Yar_Facing_Left
	cmpb	#$10
	bne	Shoot_Yar_Facing_Down		;here Yar is facing left
	lda	Yar_x
	bpl	Calculate_Bullet_Start_Pos
	cmpa	#$85					;is he too close to the edge of screen?
	bhi	Calculate_Bullet_Start_Pos
	lbra	Joy_Buttons_Next
Shoot_Yar_Facing_Down
	cmpb	#$20
	bne	Shoot_Yar_Facing_Right		;here Yar is facing left
	lda	Yar_y
	bpl	Calculate_Bullet_Start_Pos
	cmpa	#$85					;is he too close to the edge of screen?
	bhi	Calculate_Bullet_Start_Pos
	lbra	Joy_Buttons_Next
Shoot_Yar_Facing_Right
	lda	Yar_x					;here Yar is facing right
	bmi	Calculate_Bullet_Start_Pos
	cmpa	#$7a					;is he too close to the edge of screen?
	blo	Calculate_Bullet_Start_Pos
	lbra	Joy_Buttons_Next
Calculate_Bullet_Start_Pos
	ldb	Yar_Angle				;now we determine the bullet's start position
	stb	Bullet_Angle
	lsrb
	lsrb
	lsrb
	ldu	#Shoot_Table_Data_Bullet
	lda	Yar_y
	adda	b,u
	sta	Bullet_y				;save bullet start position (y)
	incb
	lda	Yar_x
	adda	b,u
	sta	Bullet_x				;save bullet start position (x)
	inc	Shooting_Status_Flag		;now we are shooting
Still_Shooting
	lda	Shooting_Status_Flag
	cmpa	#2					;is the bullet exploding?
	lbeq	Bullet_Exploding
	lda	Bullet_Angle			;no, it is on the move... get bullet's angle
	bne	Bullet_Check_Left
Bullet_Up
	lda	Bullet_y
	bmi	Move_Bullet_Up_Plus		;branch if we are below the X-Axis
	ldd	Bullet_y				;here we are above of the X-Axis
	addd	Bullet_Speed			;move bullet up
	cmpa	#$80					;have we reached the end of the screen?
	bhs	Move_Bullet_Max_Up		;yes we have reached the end of the screen
	std	Bullet_y				;no, save the new Y coordinate value
	lbra	Draw_Bullet
Move_Bullet_Max_Up
	lda	#$7f					;here we keep bullet from...
	sta	Bullet_y				;going off screen edge
	clr	Shooting_Status_Flag		;bullet exists no more
	lbra	Draw_Bullet
Move_Bullet_Up_Plus
	ldd	Bullet_y				;Here we are below the X-axis
	addd	Bullet_Speed
	std	Bullet_y
	lbra	Draw_Bullet
Bullet_Check_Left
	cmpa	#$10					;here we keep shooting to the left
	bne	Check_Bullet_Down
	lda	Bullet_x
	bpl	Move_Bullet_Left_Plus		;branch if we are right of Y-Axis
	ldd	Bullet_x				;here we are left of the Y-Axis
	subd	Bullet_Speed			;move Yar to the left
	cmpa	#$7f					;have we reached the end of the screen?
	bls	Move_Bullet_Max_Left		;yes we have reached the end of the screen
	std	Bullet_x				;no, save the new X coordinate value
	bra	Draw_Bullet
Move_Bullet_Max_Left
	lda	#$80					;here we keep bullet from...
	sta	Bullet_x				;going off screen edge
	clr	Shooting_Status_Flag
	bra	Draw_Bullet
Move_Bullet_Left_Plus
	ldd	Bullet_x				;Here we are to the right of the Y-axis
	subd	Bullet_Speed
	std	Bullet_x
	bra	Draw_Bullet
Check_Bullet_Down
	cmpa	#$20					;here we keep shooting down
	bne	Check_Bullet_Right
	lda	Bullet_y
	bpl	Move_Bullet_Down_Plus		;branch if we are above the X-Axis
	ldd	Bullet_y				;here we are below the X-Axis
	subd	Bullet_Speed			;move bullet down
	cmpa	#$7f					;have we reached the end of the screen?
	bls	Move_Bullet_Max_Down		;yes we have reached the end of the screen
	std	Bullet_y				;no, save the new X coordinate value
	bra	Draw_Bullet
Move_Bullet_Max_Down
	lda	#$80					;here we keep the bullet from...
	sta	Bullet_y				;going off screen edge
	clr	Shooting_Status_Flag
	bra	Draw_Bullet
Move_Bullet_Down_Plus
	ldd	Bullet_y				;Here we are above the X-axis
	subd	Bullet_Speed
	std	Bullet_y
	bra	Draw_Bullet
Check_Bullet_Right
	lda	Bullet_x
	bmi	Move_Bullet_Right_Minus		;branch if we are left of Y-Axis
	ldd	Bullet_x				;here we are right of the Y-Axis
	addd	Bullet_Speed			;move bullet to the right
	cmpa	#$80					;have we reached the end of the screen?
	bhs	Move_Bullet_Max_Right		;yes we have reached the end of the screen
	std	Bullet_x				;no, save the new X coordinate value
	bra	Draw_Bullet
Move_Bullet_Max_Right
	ldd	#$7f00				;here we keep bullet from...
	std	Bullet_x				;going off screen edge
	clr	Shooting_Status_Flag
	bra	Draw_Bullet
Move_Bullet_Right_Minus
	ldd	Bullet_x				;here we are left of the Y-Axis
	addd	Bullet_Speed
	std	Bullet_x
Draw_Bullet
	lda	#127					;now draw the bullet
	sta	VIA_t1_cnt_lo	
	lda	#$5f
	jsr	Intensity_a
	jsr	Reset0Ref
	lda	Bullet_y
	ldb	Bullet_x
	jsr	Moveto_d
	jsr	Dot_here
	lda	Dashed_Line_Intensity		;make sure to reset intensity back to...
	jsr	Intensity_a				;that of the dashed lines
	bra	Check_Bullet_Hit_Anything
Bullet_Exploding
	inc	Explosion_Timer
	lda	Explosion_Timer			;here we process an exploding bullet
	cmpa	#2					;adjust explosion size every 2 entries to routine
	bne	Draw_Explosion
	clr	Explosion_Timer
	lda	#2
	adda	Explosion_Scale			;increase the explosion's scale factor
	cmpa	#26					;check if finished exploding
	bne	Prep_Scale_Explosion
	clr	Explosion_Timer			;here we stop exploding and...
	lda	#16					;reset all related variables
	sta	Explosion_Scale
	clr	Shooting_Status_Flag		;make sure we stop exploding
Prep_Scale_Explosion
	sta	Explosion_Scale
Draw_Explosion
	jsr	Reset0Ref				;here we draw the explosion
	lda	#$5f
	jsr	Intensity_a
	lda	Bullet_y
	ldb	Bullet_x
	jsr	Moveto_d
	ldx	#Explosion_VL
	ldb	Explosion_Scale
	jsr	Draw_VLp_b
	lda	Dashed_Line_Intensity		;make sure to reset intensity back to...
	jsr	Intensity_a				;that of the dashed lines
Joy_Buttons_Next	
	bra	Vanguard_Move
	
;************************************************************
;This routine checks to see if a bullet has hit anything
;If it hits a force field then it explodes the bullet
;If the front of the force field was hit then the force field
;strength is decreased, otherwise it just explodes
;This routine is only called from Draw_Bullet
;************************************************************
Check_Bullet_Hit_Anything
	lda	Bullet_x				;is bullet close to force field?
	cmpa	#$50
	blo	Vanguard_Move			;nope 
	lda	Bullet_Angle
	cmpa	#$10					
	beq	Vanguard_Move			;bullet is traveling left (away from force field)
	lda	Force_Field_Status
	beq	Vanguard_Move			;no force fields, check other collisions
	ldy	Enemy_y				;now check to see if we have hit a force field
	lda	Bullet_y
	ldb	Bullet_x
	tfr	d,x
	lda	Force_Field_Status
	cmpa	#1					;which one?
	bne	Check_Bullet_2_Force_Fields
	lda	#31					;h/2 of inner force field
	ldb	#22					;w/2 of inner force field
	bra	Check_Bullet_Hit_Force_Field
Check_Bullet_2_Force_Fields
	lda	#41					;h/2 of outer force field
	ldb	#32					;w/2 of outer force field
Check_Bullet_Hit_Force_Field
	jsr	Obj_Hit				;force field hit?
	bcc	Vanguard_Move			;nope 
	lda	Bullet_Angle			;yes a hit
	cmpa	#$30					;see if the shot came from the right
	beq	Bullet_Hit_Traveling_Right
	ldb	Force_Field_Status
	ldu	#Hit_Force_Field_Doublecheck
	lda	Bullet_x				;shot came from angle other then from right
	cmpa	b,u					;did we really hit the force field?
	bhi	Record_Bullet_Hit			;yes, go flag it
	bra	Vanguard_Move			;nope, bullet will keep going
Bullet_Hit_Traveling_Right
	ldu	#Hit_Force_Field_Data_Bullet
	cmpa	b,u					;is bullet in front of the Force Field?
	blo	Bullet_Is_Infront_Enemy		;yes, go process
Record_Bullet_Hit
	lda	#2
	sta	Shooting_Status_Flag		;yes, set the bullet to explode
	bra	Vanguard_Move
Bullet_Is_Infront_Enemy
	inc	Force_Field_Hit_Flag		;set the force field hit flag
	lda	#2
	sta	Shooting_Status_Flag		;yes, set the bullet to explode
	lda	#5
	ldx	#Score_List
	jsr	Add_Score_a
	;bra	Vanguard_Move

;***********************************************************************
;This routine moves the Vanguard around the screen
;In order for Vanguard to maintain the proper angle of travel
;we must check Yar's position to see if he is more than 120 units away
;We must also check to see if he is exactly 120 units away since the
;Rise_Run_Angle routine will reverse Vanguard's angle if he is moving
;from the bottom of the screen to the top or from the left of the 
;screen to the right
;***********************************************************************
Vanguard_Move
	pshs	dp
	lda	#$c8
	tfr	a,dp
	lda	Yar_y					
	suba	Vanguard_y				;even though I can't figure out why
	cmpa	#$80					;the Rise_Run_Angle routine abhores $80
	bne	Vanguard_Keep_Chasing_y
	lda	Yar_y					;is Yar in top half of screen?
	bmi	Vanguard_Chase_Yar_x		
	deca						;yes, accumulator now hold 
	bra	Vanguard_Chase_Yar_x		;to keep Vanguard moving in proper direction
Vanguard_Keep_Chasing_y
	lda	Yar_y					;here Yar is under 120 units away
	suba	Vanguard_y
	bvs	Over_128_y		
	bra	Vanguard_Chase_Yar_x
Over_128_y
	lda	Vanguard_y				;here Yar is over 120 units away
	suba	Yar_y
Vanguard_Chase_Yar_x
	ldb	Yar_x					;now the same goes for X axis
	subb	Vanguard_x
	cmpb	#$80
	bne	Vanguard_Keep_Chasing_x
	ldb	Yar_x
	bmi	Vanguard_Angle_Calc
	decb
	bra	Vanguard_Angle_Calc
Vanguard_Keep_Chasing_x
	ldb	Yar_x
	subb	Vanguard_x
	bvs	Over_128_x
	bra	Vanguard_Angle_Calc
Over_128_x
	ldb	Vanguard_x
	subb	Yar_x
Vanguard_Angle_Calc
	jsr	Rise_Run_Angle			;find the angle between them
	subb	#$10
	lda	Vanguard_Speed
       pshs  a,b,x,y				;b=angle, a=velocity
       jsr   Rise_Run_Y				;now calculate rise/run angle to Yar
       sta   4,s
       sex
       aslb
       rola
       aslb
       rola
       aslb
       rola
       std   2,s
       ldb   4,s
       sex
       aslb
       rola
       aslb
       rola
       aslb
       rola
       std   4,s
       puls  a,b,x,y				;y=rise, x=run
	puls	dp
	tfr	y,d
	addd	Vanguard_y
	std	Vanguard_y				;calculate Vanguard Y movement
	tfr	x,d
	addd	Vanguard_x
	std	Vanguard_x				;calculate Vanguard X movement
Draw_Vanguard
	lda	#127					;now we draw Vanguard
	sta	VIA_t1_cnt_lo
	lda	#$6f
	jsr	Intensity_a
	jsr	Reset0Ref
	lda	Vanguard_y
	ldb	Vanguard_x
	jsr	Moveto_d
	lda	#20
	sta	VIA_t1_cnt_lo
	ldx	#Vanguard_VL
	jsr	Draw_VLp
	lda	Dashed_Line_Intensity		;make sure to reset intensity back to...
	jsr	Intensity_a				;that of the dashed lines
	lda	Vanguard_Hit_Yar_Flag		;has Vanguard hit Yar?
	lbne	Yar_Was_Hit				;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	

;**********************************************************************
;This routine processes the super bomb
;If the super bomb status flag is set then the bomb appears to left
;of the screen. If button 2 is pressed then the bomb is launched
;If super bomb hits a force field it explodes
;If it hits the edge of the screen then it goes away
;If it hits a fireball then it's fanfare and good times
;If it hits the enemy ship then it's all good as well
;**********************************************************************
Yar_Super_Bomb
	lda	Super_Bomb_Status_Flag		;is it time to display a super bomb?
	bne	Super_Bomb_Check_Status		
	lda	Super_Bomb_Counter		;new super bomb?
	beq	Start_The_Bomb			;yes
	lbra	Fireball				;nope, no bomb here
Super_Bomb_Check_Status
	cmpa	#1
	beq	Show_The_Bomb			;branch here if the bomb is not launching
	cmpa	#2
	beq	Shoot_The_Bomb			;branch here if the bomb has been launched
	cmpa	#3
	lbeq	Super_Bomb_Explode
	lbra	Fireball				;no bomb
Start_The_Bomb					;here we place a new bomb on the screen
	clr	Shooting_Status_Flag
	inc	Super_Bomb_Status_Flag		;bomb status=1 (show bomb)
Show_The_Bomb
	lda	Buttons_State+2			;button 3 pressed?
	beq	No_Shoot_The_Bomb
	lda	#2
	sta	Super_Bomb_Status_Flag
	lda	Sound_Type
	cmpa	#1					;no sound if fireball is on screen
	beq	Shoot_The_Bomb
	cmpa	#2
	beq	Shoot_The_Bomb
	lda	#3					;start super bomb shooting sound
	sta	Sound_Type
	clr	Vec_Music_Flag
	bra	Shoot_The_Bomb
No_Shoot_The_Bomb
	lda	Super_Bomb_Nibbles		;reset the counter
	sta	Super_Bomb_Counter
	lda	Yar_y					;set (y,x) position for new bomb
	ldb	#-125
	sta	Super_Bomb_y
	stb	Super_Bomb_x
	lbra	Draw_Super_Bomb
Shoot_The_Bomb					;here we shoot the bomb
	lda	Super_Bomb_x
	bmi	Move_Bomb_Right_Minus		;branch if we are left of Y-Axis
	ldd	Super_Bomb_x			;here we are right of the Y-Axis
	addd	Bullet_Speed			;move bullet to the right
	cmpa	#$80					;have we reached the end of the screen?
	bhs	Move_Bomb_Max_Right		;yes we have reached the end of the screen
	std	Super_Bomb_x			;no, save the new X coordinate value
	bra	Check_Bomb_Hit_Anything
Move_Bomb_Max_Right				;bomb has hit edge of screen
	clr	Super_Bomb_Status_Flag		;make bomb dissapear
	lda	Super_Bomb_Nibbles		;reset the Yar "nibble" counter
	sta	Super_Bomb_Counter
	lda	Sound_Type
	cmpa	#1					;no sound if fireball is on screen
	lbeq	Draw_Super_Bomb
	cmpa	#2
	lbeq	Draw_Super_Bomb
	clr	Sound_Type				;set sound to Grumble
	clr	Vec_Music_Flag
	lbra	Draw_Super_Bomb
Move_Bomb_Right_Minus
	ldd	Super_Bomb_x			;here we are left of the Y-Axis
	addd	Bullet_Speed
	std	Super_Bomb_x
Check_Bomb_Hit_Anything
	lda	Super_Bomb_x			;is Super Bomb close to force field?
	cmpa	#$50
	blo	Check_Bomb_Hit_Yar		;nope
	lda	Force_Field_Status
	beq	Check_Bomb_Hit_Enemy		;no force fields, check other collisions
	ldy	Enemy_y				;now check to see if we have hit a force field
	lda	Super_Bomb_y
	ldb	Super_Bomb_x
	tfr	d,x
	lda	Force_Field_Status
	cmpa	#1					;which one?
	bne	Check_Bomb_2_Force_Fields
	lda	#31					;h/2 of inner force field
	ldb	#22					;w/2 of inner force field
	bra	Check_Bomb_Hit_Force_Field
Check_Bomb_2_Force_Fields
	lda	#41					;h/2 of outer force field
	ldb	#32					;w/2 of outer force field
Check_Bomb_Hit_Force_Field
	jsr	Obj_Hit				;force field hit?
	bcc	Check_Bomb_Hit_Yar		;nope 
	inc	Force_Field_Hit_Flag		;set the force field hit flag
	lda	#3
	sta	Super_Bomb_Status_Flag		;yes, set the bomb to explode
	lda	Sound_Type
	cmpa	#1					;no sound if fireball is on screen
	beq	Check_Bomb_Hit_Force_Field_1
	cmpa	#2
	beq	Check_Bomb_Hit_Force_Field_1
	clr	Sound_Type
	clr	Vec_Music_Flag
Check_Bomb_Hit_Force_Field_1
	ldb	#2
Check_Bomb_Add_Score
	pshs	b					;now we add 500 points to score
	lda	#250
	ldx	#Score_List
	jsr	Add_Score_a
	puls	b
	decb
	bne	Check_Bomb_Add_Score
	bra	Draw_Super_Bomb
Check_Bomb_Hit_Enemy
	lda	Super_Bomb_y			;now see if Super Bomb has run into Yar
	ldb	Super_Bomb_x
	tfr	d,y
	lda	Enemy_y
	ldb	Enemy_x
	tfr	d,x
	lda	#6					;Super Bomb's h/2
	ldb	#11					;Super Bomb's w/2
	jsr	Obj_Hit				;Super Bomb touched Enemy?
	bcc	Check_Bomb_Hit_Yar		;nope, go check other collisions
	lda	#$ff					;yes, set the hit flag
	sta	Vanguard_Hit_Yar_Flag		;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	lbra	Force_Field_Update
Check_Bomb_Hit_Yar
	lda	Super_Bomb_y			;now see if Super Bomb has run into Yar
	ldb	Super_Bomb_x
	tfr	d,y
	lda	Yar_y
	ldb	Yar_x
	tfr	d,x
	lda	#6					;Super Bomb's h/2
	ldb	#11					;Super Bomb's w/2
	jsr	Obj_Hit				;Super Bomb touched Yar?
	bcc	Check_Bomb_Hit_Fireball		;nope, go check other collisions
	lda	#$ff					;yes, set the hit flag
	sta	Vanguard_Hit_Yar_Flag		;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	lbra	Force_Field_Update
Check_Bomb_Hit_Fireball
	lda	Fire_Ball_Status
	beq	Draw_Super_Bomb
	lda	Fireball_y			;now see if Super Bomb has run into Fireball
	ldb	Fireball_x
	tfr	d,y
	lda	Super_Bomb_y
	ldb	Super_Bomb_x
	tfr	d,x
	lda	#6					;Fireball's h/2
	ldb	#11					;Fireball's w/2
	jsr	Obj_Hit				;Fireball touched Yar?
	bcc	Draw_Super_Bomb			;nope, go check other collisions
	lda	#$ff					;yes, set the hit flag
	sta	Vanguard_Hit_Yar_Flag		;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	lbra	Force_Field_Update
Draw_Super_Bomb
	lda	#127					;now we draw the super bomb
	sta	VIA_t1_cnt_lo
	lda	#$5f
	jsr	Intensity_a
	jsr	Reset0Ref
	lda	Super_Bomb_y
	ldb	Super_Bomb_x
	jsr	Moveto_d
	lda	#20
	sta	VIA_t1_cnt_lo
	ldx	#Super_Bomb_VL
	jsr	Draw_VLp
	lda	Dashed_Line_Intensity		;make sure to reset intensity back to...
	jsr	Intensity_a				;that of the dashed lines
	lda	Super_Bomb_Nibbles
	sta	Super_Bomb_Counter
	bra	Fireball
Super_Bomb_Explode
	inc	Explosion_Timer
	lda	Explosion_Timer			;here we process an exploding super bomb
	cmpa	#2					;adjust explosion size every 2 entries to routine
	bne	Draw_Super_Bomb_Explosion
	clr	Explosion_Timer
	lda	#2
	adda	Explosion_Scale			;increase the explosion's scale factor
	cmpa	#26					;check if finished exploding
	bne	Prep_Bomb_Scale_Explosion
	clr	Explosion_Timer			;here we stop exploding and...
	lda	#16					;reset all related variables
	sta	Explosion_Scale
	clr	Super_Bomb_Status_Flag		;make bomb dissapear
	lda	Super_Bomb_Nibbles		;reset the Yar "nibble" counter
	sta	Super_Bomb_Counter
	bra	Fireball
Prep_Bomb_Scale_Explosion
	sta	Explosion_Scale
Draw_Super_Bomb_Explosion
	lda	#127
	sta	VIA_t1_cnt_lo
	jsr	Reset0Ref				;here we draw the explosion
	lda	#$5f
	jsr	Intensity_a
	lda	Super_Bomb_y
	ldb	Super_Bomb_x
	jsr	Moveto_d
	ldx	#Explosion_VL
	ldb	Explosion_Scale
	jsr	Draw_VLp_b
	lda	Dashed_Line_Intensity		;make sure to reset intensity back to...
	jsr	Intensity_a				;that of the dashed lines
	

;****************************************************************************************
;This routine processes the Fireballs
;First a random number is generated to produce the delay between fireballs
;When the delay is up the fireball starts rotating and another delay is
;is calculated for rotation time
;Then the fireball is shot towards Yar
;When fireball is done shooting is straightens out and leaves the left side
;of the screen
;****************************************************************************************
Fireball
	lda	Fire_Ball_Status			;is there a fireball on screen?
	cmpa	#1
	beq	Fireball_Stationary		;not ready to shoot yet
	cmpa	#2
	lbeq	Shoot_Fireball			;ready to shoot
	cmpa	#3
	beq	Fireball_Reset			;make it go away
	cmpa	#4
	lbeq	Calc_Fireball_Angle		;track fireball to target (Yar)
	cmpa	#5
	lbeq	Fireball_Track_Yar_1		;keep tracking it to the target (Yar)
	cmpa	#6
	lbeq	Fireball_Be_Gone			;fireball gets ready to exit
	cmpa	#7
	lbeq	Shoot_Fireball			;fireball exits stage left
	ldx	Fireball_Start_Counter		;nope, is it time to place one on screen?
	beq	Fireball_Stationary_Start
	leax	-1,x					;nope, keep delaying
	stx	Fireball_Start_Counter
	rts
Fireball_Stationary_Start
	clr	Vec_Music_Flag
	lda	#1
	sta	Sound_Type				;start fireball spinning sound
	sta	Fire_Ball_Status			;flag fireball as stationary
	lda	Yar_y					;here we calculate a random number
	sta	Random_Seed				;to determine fireballs rotation time
	lda	Vanguard_x
	sta	Random_Seed+1
	lda	Enemy_y
	sta	Random_Seed+2
	ldx	#Random_Seed			;set random number seed pointer
	stx	$c87b
	jsr	Random
	sta	Fireball_Spin_Time
Fireball_Stationary	
	lda	Enemy_y				;fireball now takes the place of the enemy ship
	sta	Fireball_y
	lda	Enemy_x
	sta	Fireball_x
	dec	Fireball_Spin_Time		;time to shoot the fireball?
	lbne	Check_Fireball_Hit_Yar		;nope, go draw spinning fireball
	lda	#4
	sta	Fire_Ball_Status			;yes, flag it
	bra	Calc_Fireball_Angle
Fireball_Reset	
	clr	Sound_Type				;stop sounds
	clr	Vec_Music_Flag
	lda	Yar_y					;here we reset the fireball
	sta	Random_Seed				;here we calculate a random number
	lda	Vanguard_x				;to determine time between fireballs
	sta	Random_Seed+1
	lda	Enemy_y
	sta	Random_Seed+2
	ldx	#Random_Seed			;set random number seed pointer
	stx	$c87b
	jsr	Random				;get random number
	sta	Fireball_Start_Counter+1	;and store it in the counter
	anda	#3
	ora	#1
	sta	Fireball_Start_Counter
	clr	Fire_Ball_Status			;hide the fireball
	rts
Calc_Fireball_Angle
	lda	Enemy_y				;Fireball Y-pos at zero?
	bne	Calc_Fireball_Angle_1
	lda	#2
	sta	Sound_Type				;start fireball shooting sound
	clr	Vec_Music_Flag
	bra	Fireball_Track_Yar		;yes
Calc_Fireball_Angle_1
	lda	Enemy_y				;keep moving that fireball if
	sta	Fireball_y				;it is not time to shoot
	lda	Enemy_x
	sta	Fireball_x
	lbra	Check_Fireball_Hit_Yar
Fireball_Track_Yar
	clr	Fireball_y				;make sure  fireball Y-pos is zero
Fireball_Track_Yar_1
	lda	Yar_x
	bpl	Fireball_Yar_Is_Right		;Yar is at right hand side of screen
	nega						;Yar is on left side of screen
	adda	Fireball_x
	cmpa	#$7f					;go calc angle from Yar to target
	bhi	Fireball_Shoot_Straight		;if we are at the proper distance
Fireball_Yar_Is_Right
	lda	Yar_x					;here we track fireball to the target (Yar)
	suba	Fireball_x
	sta	Fireball_Run
	lda	Yar_y
	suba	Fireball_y
	sta	Fireball_Rise
	pshs	dp
	lda	#$c8
	tfr	a,dp
	lda	Fireball_Rise			;get fireball's angle to Yar
	ldb	Fireball_Run
	jsr	Rise_Run_Angle
	subb	#$30					;adjust it for Y-Axis
	stb	Fireball_Shoot_Angle
	puls	dp
	lda	#2					;make sure angle stays fixed from now on
	sta	Fire_Ball_Status
	bra	Shoot_Fireball
Fireball_Shoot_Straight
	lda	#$30					;here the fireball shoots straight out
	sta	Fireball_Shoot_Angle
	lda	#5					;flag that we are doing this
	sta	Fire_Ball_Status
	bra	Shoot_Fireball
Fireball_Be_Gone
	lda	#$30
	sta	Fireball_Shoot_Angle
	lda	Fireball_x
	bpl	Shoot_Fireball
	lda	#7
	sta	Fire_Ball_Status
Shoot_Fireball
	pshs	dp
	lda	#$c8
	tfr	a,dp
	lda	Fireball_Speed
	ldb	Fireball_Shoot_Angle
	 pshs  a,b,x,y				;b=angle, a=velocity
       jsr   Rise_Run_Y				;now calculate rise/run angle to Yar
       sta   4,s
       sex
       aslb
       rola
       aslb
       rola
       aslb
       rola
       std   2,s
       ldb   4,s
       sex
       aslb
       rola
       aslb
       rola
       aslb
       rola
       std   4,s
       puls  a,b,x,y				;y=rise, x=run
	puls	dp
	tfr	y,d
	addd	Fireball_y
	std	Fireball_y				;calculate Vanguard Y movement
	tfr	x,d
	addd	Fireball_x
	std	Fireball_x				;calculate Vanguard X movement
	lda	Fire_Ball_Status
	cmpa	#7					;fireball trying to exit?
	bne	Shoot_Fireball_Check_6
	lda	Fireball_x				;reset fireball?
	bmi	Check_Fireball_Hit_Yar		;not yet
	lda	#3					;reset the fireball
	sta	Fire_Ball_Status
	rts
Shoot_Fireball_Check_6
	cmpa	#6
	beq	Check_Fireball_Hit_Yar
	dec	Fireball_Spin_Time
	bne	Check_Fireball_Hit_Yar
	lda	#6
	sta	Fire_Ball_Status
Check_Fireball_Hit_Yar
	lda	Fireball_y				;now see if Fireball has run into Yar
	ldb	Fireball_x
	tfr	d,y
	lda	Yar_y
	ldb	Yar_x
	tfr	d,x
	lda	#4					;Fireball's h/2
	ldb	#9					;Fireball's w/2
	jsr	Obj_Hit				;Super Bomb touched Yar?
	bcc	Draw_Fireball			;nope, go check other collisions
	lda	#$ff					;yes, set the hit flag
	sta	Vanguard_Hit_Yar_Flag		;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	lbra	Force_Field_Update	
Draw_Fireball
	lda	Fireball_Angle
	adda	#3
	sta	Fireball_Angle			;increment fireball's angle
	pshs	dp
	ldb	#$c8
	tfr	b,dp
	ldx	#Fireball_VL			;now rotate the fireball
	ldu	#Fireball_VL_Rotated
	jsr	Rot_VL_Mode
	puls	dp
	lda	#127					;now we draw the fireball
	sta	VIA_t1_cnt_lo
	lda	#$6f
	jsr	Intensity_a
	jsr	Reset0Ref
	lda	Fireball_y
	ldb	Fireball_x
	jsr	Moveto_d
	lda	#20
	sta	VIA_t1_cnt_lo
	ldx	#Fireball_VL_Rotated
	jsr	Draw_VLp
	lda	Dashed_Line_Intensity		;make sure to reset intensity back to...
	jsr	Intensity_a				;that of the dashed lines
	rts


;************************************************************
;This routine sends Yr into his death throws
;Basically he rotates around and eventually disintegrates
;************************************************************
Yar_Was_Hit
	lda	Yar_Life_State
	bne	Yar_Done_Spinning_1
	inc	Yar_Death_Spin_Counter		;make sure Yar spins a few times first
	bvs	Yar_Done_Spinning
	pshs	dp
	lda	#$c8
	tfr	a,dp
	lda	Yar_Angle
	adda	#3
	sta	Yar_Angle
	ldx	#Yar_VL_Wings_Up
	ldu	#Yar_VL_Rotated
	jsr	Rot_VL_Mode				;now rotate Yar
	puls	dp
	rts
Yar_Done_Spinning
	lda	#1
	sta	Yar_Life_State			;Yar is done spinning, set flag appropriately
	clr	Yar_Death_Spin_Counter
Yar_Done_Spinning_1
	inc	Yar_Death_Spin_Counter		;now Yar shrinks and dies
	lda	Yar_Death_Spin_Counter		
	cmpa	#$16					;time to shrink him some more?
	bne	Draw_Yar_Dying
	clr	Yar_Death_Spin_Counter		;yes, shrink him
	inc	Yar_Life_State
	lda	Yar_Life_State
	cmpa	#5					;finished shrinking?
	bne	Draw_Yar_Dying
	lda	#$ff					;Yar has finished dying
	sta	Yar_Life_State			;flag it
	rts
Draw_Yar_Dying
	lda	#127					;here we draw Yar dying
	sta	VIA_t1_cnt_lo
	lda	#$5f
	jsr	Intensity_a
	jsr	Reset0Ref
	lda	Yar_y
	ldb	Yar_x
	jsr	Moveto_d
	ldx	#Yar_Death_Scale_Table		;now get scale
	ldb	Yar_Life_State
	lda	b,x
	sta	VIA_t1_cnt_lo
	ldx	#Yar_VL_Rotated
	jsr	Draw_VLp				;draw Yar
	lda	#127					;now we draw the incrementing dots
	sta	VIA_t1_cnt_lo
	lda	#$5f
	jsr	Intensity_a
	jsr	Reset0Ref
	lda	Yar_y
	ldb	Yar_x
	jsr	Moveto_d
	lda	#20
	sta	VIA_t1_cnt_lo
	ldx	#Yar_Death_Dot_Table_Count
	ldb	Yar_Life_State
	lda	b,x
	sta	$c823
	ldx	#Yar_Death_Dot_Table
	jsr	Dot_List				;draw those dots
	rts

Yar_Death_Dot_Table_Count
	fcb	00
	fcb	9
	fcb	16
	fcb	27
	fcb	27
	
Yar_Death_Scale_Table
	fcb	0
	fcb	15
	fcb	10
	fcb	5
	fcb	2

Yar_Death_Dot_Table
	fcb	20,0
	fcb	20,0
	fcb	-10,30
	fcb	-60,-10
	fcb	40,-10
	fcb	-10,0
	fcb	-20,-10
	fcb	-10,-20
	fcb	60,0

	fcb	10,-10
	fcb	10,20
	fcb	0,20
	fcb	-30,30
	fcb	-70,-50
	fcb	50,0
	fcb	-10,-20

	fcb	10,-10
	fcb	30,-10
	fcb	-10,20
	fcb	30,60
	fcb	-10,20
	fcb	-50,-20
	fcb	-10,10
	fcb	-40,-20
	fcb	20,-10
	fcb	-20,-50
	fcb	30,0

Shoot_Table_Data_Bullet
	fcb	5,0					;(y,x) bullet displacement values if Yar is facing up
	fcb	0,-5					;(y,x) bullet displacement values if Yar is facing left
	fcb	-5,0					;(y,x) bullet displacement values if Yar is facing down
	fcb	0,5					;(y,x) bullet displacement values if Yar is facing right
	
Force_Field_Intensity_Data
	fcb	$00,$cc,$6f				;(force field strength),(Intensity)
	fcb	$00,$99,$5f				;(force field strength),(Intensity)
	fcb	$00,$66,$4f				;(force field strength),(Intensity)
	fcb	$00,$33,$4f				;(force field strength),(Intensity)

Hit_Force_Field_Data				;this table for Yar in front of force field
	fcb	00					;dummy value for table
	fcb	$5a					;X-pos limit front of inner force field
	fcb	$51					;X-pos limit front of outer force field

Hit_Force_Field_Data_Bullet			;this table for bullet in front of force field
	fcb	00					;dummy value for table
	fcb	$5a					;X-pos limit front of inner force field
	fcb	$55					;X-pos limit front of outer force field

Hit_Force_Field_Doublecheck			;this table for bullet above/below force field
	fcb	00					;dummy value for table
	fcb	$5e					;X-pos limit front of inner force field
	fcb	$54					;X-pos limit front of outer force field

Enemy_Ship_Move_Data
	fcb	+2					;scalar value for moving enemy upwards
	fcb	50					;upper travel limit of enemy ship				
	fcb	-2					;scalar value for moving enemy downwards
	fcb	-50					;lower travel limit of enemy ship

Yar_VL_Wings_Up
	fcb	0,-30,0
	fcb	255,20,20
	fcb	255,30,0
	fcb	255,10,-10
	fcb	255,0,-20
	fcb	255,-10,-10
	fcb	255,-30,0
	fcb	255,-20,20
	fcb	0,30,-20
	fcb	255,0,-20
	fcb	255,-20,-20
	fcb	0,20,80
	fcb	255,0,20
	fcb	255,-20,20
	fcb	1

Yar_VL_Wings_Down
	fcb	0,-30,0
	fcb	255,20,20
	fcb	255,30,0
	fcb	255,10,-10
	fcb	255,0,-20
	fcb	255,-10,-10
	fcb	255,-30,0
	fcb	255,-20,20
	fcb	0,30,-20
	fcb	255,0,-20
	fcb	255,-20,0
	fcb	0,20,60
	fcb	255,0,20
	fcb	255,-20,0
	fcb	1

Enemy_VL
	fcb	0,0,-40
	fcb	255,-10,20
	fcb	255,-50,60
	fcb	255,120,0
	fcb	255,-50,-60
	fcb	255,-10,-20
	fcb	1

Fireball_VL
	fcb	255,40,0
	fcb	0,-40,-40
	fcb	255,0,80
	fcb	0,-40,-40
	fcb	255,40,0
	fcb	1

Enemy_Force_Field
	fcb	30,10					;move coordinates for inner force field
	fcb	0,-30					;draw coordinates for inner force field
	fcb	-60,0
	fcb	0,30
		
	fcb	40,10					;move coordinates for outter force field
	fcb	0,-40					;draw coordinates for outter force field
	fcb	-80,0					
	fcb	0,40

Vanguard_VL
	fcb	0,0,-20
	fcb	255,0,40
	fcb	1

Dashed_Line_String
	fcb	127,0						;rel y, rel x - move pen for top line
	fcb	-127,0					;rel y, rel x - draw coordinates for top line
	fcb	-127,0					;rel y, rel x - move pen for bottom line
	fcb	127,0						;rel y, rel x - draw coordinates for bottom line
	
	fcb	127,-40					;rel y, rel x - move pen for top line
	fcb	-127,0					;rel y, rel x - draw coordinates for top line
	fcb	-127,-40					;rel y, rel x - move pen for bottom line
	fcb	127,0						;rel y, rel x - draw coordinates for bottom line

	fcb	%11000000					;start pattern for dashed lines
	fcb	$4f						;start intensity for dashed lines

E	equ	2
Explosion_VL
	fcb	0,E*5,0
	fcb	255,E*-2,E*2
	fcb	255,0,E*3
	fcb	255,E*-2,E*-2
	fcb	255,E*-1,E*3
	fcb	255,E*-2,E*-4
	fcb	255,E*-3,E*-1
	fcb	255,E*2,E*-2
	fcb	255,0,E*-3
	fcb	255,E*2,E*2
	fcb	255,E*1,E*-2
	fcb	255,E*4,E*2
	fcb	255,E*-1,E*1
	fcb	255,E*2,E*2
	fcb	01

Super_Bomb_VL
	fcb	0,20,0
	fcb	255,-20,-20
	fcb	255,-20,20
	fcb	255,20,20
	fcb	255,20,-20
	fcb	1

Score_VL
	fcb	255,0,-20
	fcb	255,-30,0
	fcb	255,0,20
	fcb	255,-30,0
	fcb	255,0,-20

	fcb	0,0,60
	fcb	255,0,-20
	fcb	255,60,0
	fcb	255,0,20

	fcb	0,0,30
	fcb	255,-10,-10
	fcb	255,-40,0
	fcb	255,-10,10
	fcb	255,0,10
	fcb	255,10,10
	fcb	255,40,0
	fcb	255,10,-10
	fcb	255,0,-10

	fcb	0,-60,40
	fcb	255,60,0
	fcb	255,0,20
	fcb	255,-10,10
	fcb	255,-10,0
	fcb	255,-20,-20
	fcb	255,-20,20

	fcb	0,0,40
	fcb	255,0,-20
	fcb	255,60,0
	fcb	255,0,20
	fcb	0,-30,0
	fcb	255,0,-20
	fcb	1

Level_VL
	fcb	255,0,-20
	fcb	255,60,0

	fcb	0,0,60
	fcb	255,0,-20
	fcb	255,-60,0
	fcb	255,0,20

	fcb	0,30,0
	fcb	255,0,-20

	fcb	0,30,40
	fcb	255,-30,0
	fcb	255,-30,10
	fcb	255,30,10
	fcb	255,30,0

	fcb	0,0,40
	fcb	255,0,-20
	fcb	255,-60,0
	fcb	255,0,20

	fcb	0,30,0
	fcb	255,0,-20
	fcb	0,30,40
	fcb	255,-60,0
	fcb	255,0,20
	fcb	1

Button_1_To_Begin
	fcb	-8,45
	fcb	-80,-80
	fcc	"BUTTON 1 TO CONTINUE"
	fcb	$80

Equals_VL
	fcb	255,0,20
	fcb	0,-20,0
	fcb	255,0,-20
	fcb	1

Grumble
	fdb	$fee8
	fdb	Twang_Grumble;,$feb6
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	0,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,2
	fcb	1,20
	fcb	19,$80
Twang_Grumble
	fdb	$ccee,$ccee,$ccee,$ccee,$ccee,$ccee,$ccee,$ccee

Fireball_Music
	fdb	$fd69,$fd79
	fcb	$30,3
	fcb	$2e,3
	fcb	$2d,3
	fcb	$2b,3
	fcb	$29,3
	fcb	$28,3
	fcb	$26,3
	fcb	$25,3
	fcb	19,$80

Fireball_Shooting_Music
	fdb	$fd69,$feb6
	fcb	$18+40+128,$30+40,1
	fcb	$30+40+128,30+40,2
	fcb	$18+40+128,$30+40,1
	fcb	$30+40+128,30+40,2
	fcb	$18+40+128,$30+40,1
	fcb	$30+40+128,30+40,2
	fcb	$18+40+128,$30+40,1
	fcb	$30+40+128,30+40,2
	fcb	19,$80

Super_Bomb_Shooting_Music
	fdb	$fd69,$feb6
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	00+128,$05+128,$09,5
	fcb	00+128,00+128,00,1
	fcb	19,$80


Print_String
	clra
	sta	counter2
Convert
	ldx	#Print1
	ldy	#Test_String
Convert_1	
	lda	,x
	lsra
	lsra
	lsra
	lsra
	cmpa	#$9
	bls	Convert_2
	adda	#$7
Convert_2
	adda	#$30
	sta	,y+
	lda	,x+
	anda	#$f
	cmpa	#$09
	bls	Convert_3
	adda	#$07
Convert_3
	adda	#$30
	sta	,y+
	inc	counter2
	lda	counter2
	cmpa	#4
	bne	Convert_1
Repeat_Print
	jsr	Reset0Ref
	lda	#127
	sta	VIA_t1_cnt_lo
	clra
	clrb
	jsr	Moveto_d
	ldu	#Str_y
	jsr	Print_Str_yx
	rts








Intro_Music
	fdb	$fee8,$feb6
	fcb	19,$80
