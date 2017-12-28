;*** KONG ****
;*** By Dan Siewers ***

	include	"vecbios.txt"

Buttons_State	equ	$c812			;4 bytes - returned button states
Recal_Count		equ	$c880			;1 bytes
Ladder_Position	equ	$c881			;2 bytes
Ladder_Vectors	equ	$c883			;2 bytes
Mario_Pos_Y		equ	$c885			;2 bytes
Mario_Pos_X		equ	$c887			;2 bytes
Mario_Move		equ	$c889			;1 byte - 0= None, 1=Left, 2=Right, 3=Up, 4=Down
Mario_Floor		equ	$c88a			;1 byte - 1=1st,2=2nd,3=3rd,4=4th,5=L1,6=L2,7=L3,8=L4
Floor1_Rise_Right	equ	$c88b			;1 bytes - unused
Floor1_Run_Right	equ	$c88c			;1 bytes - unused
Mario_Pos_Temp_Y	equ	$c88d			;2 bytes
Mario_Pos_Temp_X	equ	$c88f			;2 bytes
Temp_Rise		equ	$c891			;2 bytes
Angle_Temp		equ	$c893			;1 byte
Print1		equ	$c894			;2 bytes - for test print string
Print2		equ	$c896			;2 bytes - for test print string
counter2		equ	$c898			;1 byte - for test print string
Str_y			equ	$c899			;1 byte - for test print string
Str_x			equ	$c89a			;1 byte - for test print string
Test_String		equ	$c89b			;- for test print string
String_End		equ	$c8a3			;- for test print string
Floor1_Rise_Left	equ	$c8a4			;1 byte - unused
Floor1_Run_Left	equ	$c8a5			;1 byte - unused
Temp_Run		equ	$c8a6			;2 bytes
Mario_Shape		equ	$c8a8			;2 bytes - pointer to Mario vector list
Mario_Legs		equ	$c8aa			;1 byte - =<3 Leg up, >3=<7 Leg Down
End_Of_Floor	equ	$c8ab			;1 byte - end of floor variable
Y_Axis_Adjust	equ	$c8ac			;1 byte - Adjust Y-Axis calculation for floor
Save_Scalar		equ	$c8ad			;2 bytes - scalar values at base of ladder
Mario_Pos_Temp	equ	$c8af			;2 bytes - temp Mario position for Legs routine
Kong_Legs		equ	$c8b1			;1 byte - 3=right leg up, 6=left leg up
Kong_Shape		equ	$c8b2			;2 bytes - pointer to Kong vector list
Kong_Move		equ	$c8b4			;1 byte - 0=right ft dwn, 1=left ft dwn
Mario_Jump		equ	$c8b5			;1 byte - 0=no jmp, 1=jmp up, 2=jmp lft, 3=jmp rt
Mario_Jump_State	equ	$c8b6			;1 byte - 0=start jump, 1=mid jump
Jump_Count		equ	$c8b7			;1 byte - counter for jump routine
Mario_Shape_Temp	equ	$c8b8			;2 bytes - stores Mario's shape for jump routine
Mario_Save_X	equ	$c8ba			;2 bytes
Mario_Save_Y	equ	$c8bc			;2 bytes
Barrel1_Pos_X	equ	$c8be			;2 bytes
Barrel1_Pos_Y	equ	$c8c0			;2 bytes
Barrel2_Pos_X	equ	$c8c2			;2 bytes
Barrel2_Pos_Y	equ	$c8c4			;2 bytes
Barrel3_Pos_X	equ	$c8c6			;2 bytes
Barrel3_Pos_Y	equ	$c8c8			;2 bytes
Barrel4_Pos_X	equ	$c8ca			;2 bytes
Barrel4_Pos_Y	equ	$c8cc			;2 bytes
Barrel1_Floor	equ	$c8ce			;2 byte - 1=1st,2=2nd,3=3rd,4=4th,5=L1,6=L2,7=L3,8=L4
							;	    9=1/2,10=2/3,11=3/4
Barrel2_Floor	equ	$c8d0			;2 bytes - 1=1st,2=2nd,3=3rd,4=4th,5=L1,6=L2,7=L3,8=L4
							;	    9=1/2,10=2/3,11=3/4
Barrel3_Floor	equ	$c8d2			;2 byte - 1=1st,2=2nd,3=3rd,4=4th,5=L1,6=L2,7=L3,8=L4
							;	    9=1/2,10=2/3,11=3/4
Barrel4_Floor	equ	$c8d4			;2 byte - 1=1st,2=2nd,3=3rd,4=4th,5=L1,6=L2,7=L3,8=L4
							;	    9=1/2,10=2/3,11=3/4
Barrel1_Move	equ	$c8d6			;2 byte - 0= None, 1=Left, 2=Right, 3=Down
Barrel2_Move	equ	$c8d8			;2 byte - 0= None, 1=Left, 2=Right, 3=Down
Barrel3_Move	equ	$c8da			;2 byte - 0= None, 1=Left, 2=Right, 3=Down
Barrel4_Move	equ	$c8dc			;2 byte - 0= None, 1=Left, 2=Right, 3=Down
Add_Barrel		equ	$c8de			;2 byte - 0= None, 1=Barrel 1, 2= Barrel 2, 3=Barrel 3, 4=Barrel 4
Barrel_Count	equ	$c8e0			;2 byte
Barrel_Move_Count	equ	$c8e2			;2 bytes
Barrel_Floor_Count	equ	$c8e4		;2 bytes
Barrel_Is_Moving	equ	$c8e6			;2 byte
Barrel1_Add		equ	$c8e8			;2 byte
Barrel2_Add		equ	$c8ea			;2 byte
Barrel3_Add		equ	$c8ec			;2 byte
Barrel4_Add		equ	$c8ee			;2 byte
Barrel_On_Ladder1	equ	$c8f0			;2 byte - 0 - barrel falling off edge, >=1 - barrel down ladder
Barrel_On_Ladder2	equ	$c8f2			;2 bytes
Barrel_On_Ladder3	equ	$c8f4			;2 bytes
Barrel_On_Ladder4	equ	$c8f6			;2 bytes
Rise_Run_Temp	equ	$c8f8			;2 bytes
Mult_Count		equ	$c8fa			;2 bytes
Mult_Result		equ	$c8fc			;2 bytes
Sound_Type		equ	$c8fe			;1 bytes - 1=Jump Sound, 2=Walk Sound, 3=Over Barrel Sound
							;        - 4=Mario Hit by barrel, 5= Fireball
							;	   - 6= Big Mario Scale Down, 7=Broken Heart, 8=Last Barrel
Sound_Counter	equ	$c8ff			;1 byte - counter for length of sound being played
Next_Sound_Counter	equ	$c900		;1 byte - offset for note play index
Reg_Edit_Loop	equ	$c901			;1 byte - temp counter for Make_Sound Routine
Sound_Init_Temp	equ	$c902			;2 bytes - pointer for sound init list
Sound_Temp		equ	$c904			;2 bytes - pointer to sound list
Ladder_Temp1	equ	$c906			;1 byte - ladder X pos left
Ladder_Temp2	equ	$c907			;1 byte - ladder X pos right
Ladder_Temp3	equ	$c908			;1 byte - barrel X position down ladder
Mario_Dead		equ	$c909			;1 byte - 1=Mario hit by barrel
Asterisk_Rotate	equ	$c90a			;1 byte - rotate angle for asterisks
Mario_Asterisks_Rotated	equ	$c90b		;99 bytes - rotated vector list for asterisks ($c90b-$c96e)
Dead_Count		equ	$c96f			;1 byte - counter for Mario barrel crash routine
Fireball_Pos_X	equ	$c970			;2 bytes - Fireball's X position
Fireball_Pos_Y	equ	$c972			;2 bytes - Fireball's Y position
Mario_Scale		equ	$c974			;1 byte - Mario's scale when he dies
Number_Barrels_Jumped	equ	$c975		;1 byte - Number of Barrels that Mario has cleared
Barrels_Left	equ	$c976			;3 bytes - Number of barrels left to clear
Back_To_Intro	equ	$c979			;1 byte - 1=back to Intro
All_Barrels_Cleared	equ	$c97a		;1 byte - 1= All barrels cleared
Mario_Got_The_Girl	equ	$c97b		;1 byte - 1= Mario has reached the girl
Star_Rotated		equ	$c97c		;20 bytes - rotated star vector list ($c97c-$c990)
Star_Count			equ	$c991		;1 byte - used for start rotate routine
Heartbeat			equ	$c992		;1 byte - scale value for heart at end of game
Heartbeat_Sign		equ	$c993		;1 byte - 0=positive, 1=negative


	org	$0000

;Magic Init Block

	fcb	$67,$20
	fcc	"GCE 2003"
	fcb	$80
	fdb	Allentown
	fdb	$f850
	fcb	30,-95
	fcc	"BECKY'S MESSAGE"
	fcb	$80,$0

Setup_Hard_Start
	clr	Number_Barrels_Jumped
	clr	Mario_Got_The_Girl
	jsr	Setup
	lbra	Intro
Setup
	jsr	Wait_Recal
	jsr	Clear_Sound
	clr	Heartbeat_Sign
	clr	Dead_Count
	clr	Asterisk_Rotate
	clr	Mario_Dead
	clr	Recal_Count
	clr	Ladder_Temp1
	clr	Ladder_Temp2
	clr	Ladder_Temp3
	clr	Barrel1_Pos_X
	clr	Barrel1_Pos_Y
	clr	Barrel2_Pos_X
	clr	Barrel2_Pos_Y
	clr	Barrel3_Pos_X
	clr	Barrel3_Pos_Y
	clr	Barrel4_Pos_X
	clr	Barrel4_Pos_Y
	clr	Barrel_Move_Count
	clr	Barrel_Floor_Count
	clr	Barrel1_Floor
	clr	Barrel2_Floor
	clr	Barrel3_Floor
	clr	Barrel4_Floor
	clr	Barrel1_Move
	clr	Barrel2_Move
	clr	Barrel3_Move
	clr	Barrel4_Move
	clr	Barrel2_Add
	clr	Barrel3_Add
	clr	Barrel4_Add
	clr	Barrel_Count
	clr	Barrel_Is_Moving
	clr	Add_Barrel
	clr	Barrel_On_Ladder1
	clr	Barrel_On_Ladder2
	clr	Barrel_On_Ladder3
	clr	Barrel_On_Ladder4
	clr	Sound_Counter
	clr	Next_Sound_Counter
	lda	#180
	sta	Mario_Scale
	lda	#94
	ldb	#00
	std	Fireball_Pos_Y
	lda	#-52
	ldb	#00
	std	Fireball_Pos_X
	lda	#1
	sta	Vec_Joy_Mux_1_X			;make sure we look at joystick 1 only
	lda	#3
	sta	Vec_Joy_Mux_1_Y
	clr	Vec_Joy_Mux_2_X
	clr	Vec_Joy_Mux_2_Y
	clr	Mario_Jump
	clr	Mario_Jump_State
	clr	Jump_Count
	clr	Print1
	clr	Print1+1
	clr	Print2
	clr	Print2+1
	clr	Y_Axis_Adjust
	clr	Kong_Legs
	clr	Sound_Type
	clr	Back_To_Intro
	lda	#-64
	sta	Mario_Pos_Y				;Mario's start position
	sta	Floor1_Rise_Right
	lda	#-54
	sta	Mario_Pos_X
	sta	Floor1_Run_Right
	lda	#01
	sta	Mario_Floor
	clr	Temp_Rise
	clr	Temp_Run
	ldx	#Mario_Right_Leg_Up
	stx	Mario_Shape
	clr	Mario_Legs
	ldx	#Kong_Left
	stx	Kong_Shape
	clr	Kong_Move
	lda	#1
	sta	Barrel1_Add				;make sure to add first barrel
	ldd	#00
	std	Rise_Run_Temp
	std	Mult_Count
	std	Mult_Result
	lda	#50					;for test only
	ldb	#-50
	sta	Str_y
	stb	Str_x
	lda	#$80
	sta	String_End
	sta	Barrels_Left+2			;end of print string for Intro
	jsr	Read_Btns
	clr	Back_To_Intro
	clr	All_Barrels_Cleared
	clr	Heartbeat
	rts
	
Intro							;we come here at the start of program
	jsr	Wait_Recal				;and after each time Mario dies
	jsr	Reset0Ref
	ldd	#00
	jsr	Moveto_d
	lda	#$7f
	jsr	Intensity_a
	lda	Back_To_Intro			;are we back from Mario dying?
	bne	Intro_Repeat
	ldu	#Message1				;print the intro message
	jsr	Print_List_hw
	ldu	#Message2
	jsr	Print_List_hw
	ldu	#Message3
	jsr	Print_List_hw
	ldu	#Message4
	jsr	Print_List_hw
	ldu	#Message5
	jsr	Print_List_hw
	ldu	#Message6
	jsr	Print_List_hw
	ldu	#Message7
	jsr	Print_List_hw
Intro_Repeat
	ldu	#Message8
	jsr	Print_List_hw
	ldu	#Message9
	jsr	Print_List_hw
	ldu	#Message10
	jsr	Print_List_hw
	ldu	#Message11
	jsr	Print_List_hw
	ldu	#Message12
	jsr	Print_List_hw
	lda	#15
	suba	Number_Barrels_Jumped
	daa
	sta	Barrels_Left
	anda	#$0f
	adda	#$30
	sta	Barrels_Left+1
	lda	Barrels_Left
	lsra
	lsra
	lsra
	lsra
	adda	#$30
	sta	Barrels_Left
	ldu	#Barrels_Left
	lda	#-40
	ldb	#20
	jsr	Print_Str_d
	jsr	Read_Btns			;read state of all buttons
	lda	Buttons_State+2		;get state of button 3
	beq	Intro				;not pressed, keep waiting
	jsr	Setup
	
Main_Loop
	lda	Mario_Got_The_Girl
	beq	Main_Loop_1
	lbra	Mario_Wins
Main_Loop_1	
	jsr	Main_Screen
	lda	Mario_Dead				;is Mario dead?
	beq	Main_Loop_Joystick
	bra	Mario_Is_Dead
Main_Loop_Joystick					;Mario is alive, keep processing main loop
	jsr	Joystick
	jsr	Mario
	jsr	When_Sprites_Collide
	jsr	Wait_Recal
	bra	Main_Loop
Mario_Is_Dead					;here Mario has died
	jsr	Crash_Over_Barrel
	lda	Back_To_Intro
	beq	Main_Loop
	lbra	Intro

Main_Screen						;here we display the main screen graphics
	ldx	#Bottom_Floor
	jsr	Draw_Vectors
	ldx	#Second_Floor
	jsr	Draw_Vectors
	ldx	#Third_Floor
	jsr	Draw_Vectors
	ldx	#Fourth_Floor
	jsr	Draw_Vectors
	ldx	#Top_Floor
	jsr	Draw_Vectors
	lda	All_Barrels_Cleared
	beq	Main_Screen_No_Girl
	ldx	#Girl_LegL
	jsr	Draw_Girl
	ldx	#Girl_LegR
	jsr	Draw_Girl
	ldx	#Girl_Body
	jsr	Draw_Girl
	ldx	#Girl_Head
	jsr	Draw_Girl
Main_Screen_No_Girl
	ldy	#Ladders			;get ladder list pointer
Ladders_Here
	lda	,y				;end of ladder list?
	cmpa	#$80
	bne	Ladders_Here_1		;nope keep drawing ladder parts
	bra	Draw_Kong			;yes, go draw Kong
Ladders_Here_1
	ldd	,y++				;get ladder part position
	std	Ladder_Position		;save it
	ldx	,y++				;get ladder part vectors
	stx	Ladder_Vectors		;save it
	jsr	Draw_Ladders		;now go draw the ladder part
	bra	Ladders_Here		;keep going until done

Draw_Girl
	jsr	Reset0Ref
	lda	#$5F
	jsr	Intensity_a
	ldd	,x++
	jsr	Moveto_d_7F
	jsr	Draw_VLcs
	rts

Draw_Kong
	lda	All_Barrels_Cleared
	beq	Draw_Kong_1
	rts
Draw_Kong_1
	ldx	#Kong_Head
	jsr	Draw_Vectors
	ldx	Kong_Shape
	lda	Mario_Move
	beq	Draw_Kong_Finalize
	cmpa	#1
	bne	Draw_Kong_Right
	ldx	#Kong_Right
	bra	Draw_Kong_Finalize
Draw_Kong_Right
	cmpa	#2
	bne	Draw_Kong_Up_Down
	ldx	#Kong_Left
	bra	Draw_Kong_Finalize
Draw_Kong_Up_Down
	cmpa	#3
	blo	Draw_Kong_Body
	inc	Kong_Legs
	lda	Kong_Legs
	cmpa	#6
	bne	Draw_Kong_Body
	clr	Kong_Legs
	lda	Kong_Move
	eora	#1				;toggle Kong's foot
	sta	Kong_Move
	bra	Draw_Kong_Body
Draw_Kong_Body
	lda	Kong_Move
	beq	Kong_Left_Down
	ldx	#Kong_Right
	bra	Draw_Kong_Finalize
Kong_Left_Down
	ldx	#Kong_Left
Draw_Kong_Finalize
	stx	Kong_Shape
	jsr	Draw_Vectors
	rts

Draw_Vectors
	jsr	Reset0Ref			;x-reg contains pointer to vector list
	ldd	#00
	jsr	Moveto_d_7F
	lda	#$5F
	jsr	Intensity_a
	jsr	Mov_Draw_VLcs
	rts

Draw_Ladders
	jsr	Reset0Ref			;Here we draw the ladders
	ldd	Ladder_Position
	jsr	Moveto_d_7F
	lda	#$5F
	jsr	Intensity_a
	ldd	Ladder_Vectors
	jsr	Draw_Line_d	
	rts

Joystick
	lda	Mario_Jump			;is Mario jumping?
	beq	Joystick_1			;no, process joystick
	bra	Jump				;yes, contuniue jumping
Joystick_1
	jsr	Joy_Digital			;Read Joystick
	lda	Vec_Joy_1_X			;check left/right
	beq	Check_Up_Down		
	bmi	Mario_Left			;left joy?
Mario_Right
	lda	#02				;no, must be right
	sta	Mario_Move
	bra	Joy_Buttons	
Mario_Left
	lda	#1				;left joy
	sta	Mario_Move
	bra	Joy_Buttons
Check_Up_Down
	lda	Vec_Joy_1_Y			;now check up/down
	beq	Mario_No_Move
	bmi	Mario_Down
Mario_Up
	lda	#3
	sta	Mario_Move
	bra	Joy_Buttons
Mario_Down
	lda	#4
	sta	Mario_Move
	bra	Joy_Buttons
Mario_No_Move
	lda	#0				;no joystick pressed
	sta	Mario_Move
		

Joy_Buttons
	lda	Mario_Jump			;is Mario already jumping?
	beq	Joy_Buttons1		;no, process buttons
	bra	Jump				;yes, ignore joystick until jump is over
Joy_Buttons1
	lda	Mario_Floor
	cmpa	#4				;are we on a ladder?
	bls	Joy_Buttons_Go		;nope, let's check the buttons
	rts					;yes, go back
Joy_Buttons_Go
	jsr	Read_Btns			;read state of all buttons
	lda	Buttons_State+3		;get state of button 4
	bne	Joy_Button4			;button 4 pressed?
	bra	Joy_Buttons_Back		;nope, go back
Joy_Button4
	inc	Mario_Jump			;yes, set jump flag
	lda	#1
	sta	Sound_Type			;start jump sound
	clr	Next_Sound_Counter
	bra	Jump
Joy_Buttons_Back
	clr	Mario_Jump			;reset jump flag if we are not jumping
	rts

Jump
	lda	Mario_Jump			;should we jump?
	bne	Jump_Process		;yep
	rts					;no go back
Jump_Process
	inc	Jump_Count
	lda	Jump_Count
	cmpa	#10				;this is the jump 'hang time'
	beq	Jump_Reset
	cmpa	#1				;are we just starting a jump?
	bne	Jump_Process_Return
	ldx	Mario_Shape			;save Mario's shape
	stx	Mario_Shape_Temp
	lda	Mario_Pos_Y			;yes, let's make sure he jumps up
	adda	#5
	sta	Mario_Pos_Y
Jump_Process_Return
	rts
Jump_Reset
	ldx	Mario_Shape_Temp		;here Mario's feet touch back down
	stx	Mario_Shape
	lda	Mario_Pos_Y
	suba	#5
	sta	Mario_Pos_Y
	clr	Mario_Jump
	clr	Jump_Count
	lda	Mario_Floor
	lda	#0
Jump_Over_Barrel					;here we see if Mario jumped over a barrel
	ldx	#Barrel1_Floor
	ldb	a,x
	cmpb	Mario_Floor				;is barrel on same floor as Mario?
	beq	Jump_Check_Over_Barrel		;yes
Jump_Over_Barrel1
	inca
	inca						;nope check next barrel
	cmpa	#8
	bne	Jump_Over_Barrel
	rts
Jump_Check_Over_Barrel
	ldx	#Barrel1_Move
	ldb	a,x
	cmpb	#3					;is the barrel going down?
	beq	Jump_Over_Barrel1			;yes, check next barrel
	pshs	a
	ldx	#Barrel1_Pos_X			;get the barrels X position
	ldb	#2
	mul
	exg	a,b
	ldb	a,x
	lda	Mario_Floor				;get Mario's floor
	cmpa	#1					;Mario on floor 1?
	bne	Jump_Check_Over_Barrel2
Jump_Check_Over_Barrel1	
	lda	Mario_Pos_X				;get Mario's X position
	pshs	b
	suba	,s+					;subtract it from Barrels position
	cmpa	#15					;we just clear a barrel?
	blo	Jump_Over_Barrel_Flag		;yes go set the sound flag
	puls	a
	bra	Jump_Over_Barrel1			;no, go finish checking barrels
Jump_Check_Over_Barrel2
	cmpa	#2					;Mario on floor2?
	bne	Jump_Check_Over_Barrel3
Jump_Check_Over_Barrel_Left
	lda	Mario_Pos_X				;yes, get Mario's X position
	exg	a,b
	pshs	b
	suba	,s+					;subtract it from Barrels position
	cmpa	#15					;we just clear a barrel?
	blo	Jump_Over_Barrel_Flag		;yes go set the sound flag
	puls	a
	bra	Jump_Over_Barrel1			;no, go finish checking barrels
Jump_Check_Over_Barrel3
	cmpa	#3
	bne	Jump_Check_Over_Barrel4
	bra	Jump_Check_Over_Barrel1
Jump_Check_Over_Barrel4
	bra	Jump_Check_Over_Barrel_Left
Jump_Over_Barrel_Flag
	lda	#3					;make over the barrel sound
	sta	Sound_Type
	clr	Next_Sound_Counter
	inc	Number_Barrels_Jumped		;increment # of barrels jumped
	lda	Number_Barrels_Jumped
	cmpa	#15					;jumped over last barrel?
	blo	Jump_Over_Barrel_Flag_1		;nope
	lda	#15					;yes, make sure barrel jump counter
	sta	Number_Barrels_Jumped		;does not change
	lda	All_Barrels_Cleared
	bne	Jump_Over_Barrel_Flag_1
	lda	#8
	sta	Sound_Type
	lda	#1
	sta	All_Barrels_Cleared		;last barrel so flag it
Jump_Over_Barrel_Flag_1
	puls	a
	rts

Mario
	lda	Mario_Move			;which way is Mario going to move?
	beq	Mario_Stay			;he isn't, go draw him as stationary
	cmpa	#01
	beq	Mario_Go_Left		;he's going left
	cmpa	#02
	beq	Mario_Go_Right		;he's going right
	cmpa	#03
	lbeq	Mario_Go_Up			;he's going up
	cmpa	#04
	lbeq	Mario_Go_Down
	lbra	Draw_Mario
Mario_Stay
	lbra	Run_Nowhere
Mario_Go_Left					;ok now we make him run to the left
	lda	Mario_Floor
	cmpa	#01					;are we on floor 1?
	beq	Go_Left_Floor1			
	cmpa	#02					;are we on floor 2?
	beq	Go_Left_Floor2
	cmpa	#03					;are we on floor 3?
	beq	Go_Left_Floor3
	cmpa	#04					;are we on floor 4?
	beq	Go_Left_Floor4
	lbra	Draw_Mario				;nope we must be on a ladder
Go_Left_Floor1
	lda	#$10					;Floor 1, set angle to 90 degrees
	sta	Angle_Temp
	lda	#-55					;set the end of floor variable
	sta	End_Of_Floor
	lbra	Run_To_The_Right_Left
Go_Left_Floor2
	lda	#$0f					;Floor 1, set angle to 90 degrees
	sta	Angle_Temp
	lda	#-65					;set the end of floor variable
	sta	End_Of_Floor
	lbra	Run_To_The_Right_Left
Go_Left_Floor3
	lda	#$11					;Floor 1, set angle to 90 degrees
	sta	Angle_Temp
	lda	#-55					;set the end of floor variable
	sta	End_Of_Floor
	lbra	Run_To_The_Right_Left
Go_Left_Floor4
	lda	#$10					;Floor 1, set angle to 90 degrees
	sta	Angle_Temp
	lda	#-65					;set the end of floor variable
	sta	End_Of_Floor
	lbra	Run_To_The_Right_Left
Mario_Go_Right					;ok now we make him run to the right
	lda	Mario_Floor
	cmpa	#01					;are we on floor 1?
	beq	Go_Right_Floor1
	cmpa	#02					;are we on floor 2?
	beq	Go_Right_Floor2
	cmpa	#03
	beq	Go_Right_Floor3
	cmpa	#04
	beq	Go_Right_Floor4
	lbra	Draw_Mario				;nope try next floor
Go_Right_Floor1	
	lda	#$30					;yes, floor 1, set angle to 90 degrees
	sta	Angle_Temp
	lda	#64					;set the end of floor variable
	sta	End_Of_Floor
	lbra	Run_To_The_Right_Left
Go_Right_Floor2	
	lda	#$2f					;yes, floor 2, set angle to xx degrees
	sta	Angle_Temp
	lda	#54					;set the end of floor variable
	sta	End_Of_Floor
	lbra	Run_To_The_Right_Left
Go_Right_Floor3	
	lda	#$31					;yes, floor 3, set angle to xx degrees
	sta	Angle_Temp
	lda	#64					;set the end of floor variable
	sta	End_Of_Floor
	lbra	Run_To_The_Right_Left
Go_Right_Floor4
	lda	#$30					;yes, floor 2, set angle to xx degrees
	sta	Angle_Temp
	lda	#56					;set the end of floor variable
	sta	End_Of_Floor
	lbra	Run_To_The_Right_Left
Mario_Go_Up
	lda	Mario_Floor
	cmpa	#4					;are we on floor 4?
	lbeq	Up_Floor4
	cmpa	#8					;are we o ladder floor 4?
	beq	Up_Floor4
	cmpa	#5					;are we on ladder floor 1?
	beq	Up_Floor1				;yes, keep moving on up
	cmpa	#6
	beq	Up_Floor2
	cmpa	#7
	beq	Up_Floor3
	cmpa	#01					;are we on Floor1?
	beq	Up_Floor1				;yes
	cmpa	#02
	beq	Up_Floor2
	cmpa	#03
	beq	Up_Floor3
	lbra	Draw_Mario
Up_Floor1
	lda	Mario_Pos_X
	cmpa	#44					;are we left of the ladder?
	lblo	Kong_No_Move			;yep so Mario stays on the ground
	cmpa	#46					;are we right of the ladder?
	lbhi	Kong_No_Move			;yep so Mario stays on the ground
	lda	#5
	sta	Mario_Floor				;set floor flag to ladder 1
	lda	#$40
	sta	Angle_Temp
	lda	#-22
	sta	End_Of_Floor
	lbra	Run_Up	
Up_Floor2
	lda	Mario_Pos_X
	cmpa	#-26					;are we left of the ladder?
	lblo	Kong_No_Move			;yep so Mario stays on the ground
	cmpa	#-24					;are we right of the ladder?
	lbhi	Kong_No_Move			;yep so Mario stays on the ground
	lda	#6
	sta	Mario_Floor				;set floor flag to ladder 2
	lda	#$40
	sta	Angle_Temp
	lda	#20
	sta	End_Of_Floor
	lbra	Run_Up	
Up_Floor3
	lda	Mario_Pos_X
	cmpa	#34					;are we left of the ladder?
	lblo	Kong_No_Move			;yep so Mario stays on the ground
	cmpa	#36					;are we right of the ladder?
	lbhi	Kong_No_Move			;yep so Mario stays on the ground
	lda	#7
	sta	Mario_Floor				;set floor flag to ladder 3
	lda	#$40
	sta	Angle_Temp
	lda	#66
	sta	End_Of_Floor
	lbra	Run_Up
Up_Floor4
	lda	All_Barrels_Cleared
	lbeq	Kong_No_Move
	lda	Mario_Pos_X
	cmpa	#-26					;are we left of the ladder?
	lblo	Kong_No_Move			;yep so Mario stays on the ground
	cmpa	#-24					;are we right of the ladder?
	lbhi	Kong_No_Move			;yep so Mario stays on the ground
	lda	#8
	sta	Mario_Floor				;set floor flag to ladder 2
	lda	#$40
	sta	Angle_Temp
	lda	#100
	sta	End_Of_Floor
	lbra	Run_Up	

Mario_Go_Down				;he's going down
	lda	Mario_Floor
	cmpa	#1
	lbeq	Kong_No_Move
	cmpa	#05				;are we on ladder 1?
	beq	Down_Floor2			;yes keep moving down
	cmpa	#06				;are we on ladder 2?
	beq	Down_Floor3			;yes keep moving down
	cmpa	#07				;are we on ladder 3?
	beq	Down_Floor4			;yes keep moving down
	cmpa	#8
	beq	Down_Floor4_Ladder
	cmpa	#02				;are we on floor 2
	beq	Down_Floor2			;yes we are
	cmpa	#03				;are we on floor 3?
	beq	Down_Floor3			;yes we are
	cmpa	#04				;are we on floor 4?
	beq	Down_Floor4			;yes we are
	lbra	Draw_Mario
Down_Floor2
	lda	Mario_Pos_X
	cmpa	#44				;are we standing above ladder 2?
	lblo	Kong_No_Move			
	cmpa	#46
	lbhi	Kong_No_Move
	lda	#5				;yes, let's go down
	sta	Mario_Floor
	lda	#$20
	sta	Angle_Temp
	lda	#-64
	sta	End_Of_Floor
	lbra	Run_Down
Down_Floor3
	lda	Mario_Pos_X
	cmpa	#-26				;are we standing above ladder 3?
	lblo	Kong_No_Move			
	cmpa	#-24
	lbhi	Kong_No_Move
	lda	#6				;yes, let's go down
	sta	Mario_Floor
	lda	#$20
	sta	Angle_Temp
	lda	#-16
	sta	End_Of_Floor
	lbra	Run_Down
Down_Floor4
	lda	Mario_Pos_X
	cmpa	#34				;are we standing above ladder 3?
	lblo	Kong_No_Move			
	cmpa	#36
	lbhi	Kong_No_Move
	lda	#7				;yes, let's go down
	sta	Mario_Floor
	lda	#$20
	sta	Angle_Temp
	lda	#25
	sta	End_Of_Floor
	lbra	Run_Down
Down_Floor4_Ladder
	lda	Mario_Pos_X
	cmpa	#-26				;are we standing above ladder 3?
	lblo	Kong_No_Move			
	cmpa	#-24
	lbhi	Kong_No_Move
	lda	#8				;yes, let's go down
	sta	Mario_Floor
	lda	#$20
	sta	Angle_Temp
	lda	#66
	sta	End_Of_Floor
	lbra	Run_Down

Kong_No_Move
	clr	Mario_Move
	lbra	Draw_Mario

Run_To_The_Right_Left
	lda	Mario_Pos_X
	cmpa	End_Of_Floor			;reached end of floor?
	lbeq	Draw_Mario				;yep, we're done here
	lda	Mario_Pos_X				;save X position for Legs routine
	sta	Mario_Pos_Temp+1
	jsr	DP_to_C8
	lda	#$7f					;this is the scalar value (Mario's speed)
	ldb	Angle_Temp				;this is the angle of movement
	jsr	Rise_Run_Y				;go calculate the rise/run values
	sta	Temp_Rise+1
	stb	Temp_Run+1
	lda	#2
	jsr	Mult_Rise_Run_By_A		;multiply rise/run by xx
	std	Temp_Run
	ldd	Mario_Pos_X
	addd	Temp_Run
	std	Mario_Pos_X				;store Mario's new X position
	ldb	Temp_Rise+1
	lda	#2
	jsr	Mult_Rise_Run_By_A
	std	Temp_Rise
	ldd	Mario_Pos_Y
	addd	Temp_Rise
	std	Mario_Pos_Y				;store Mario's new X position
Right_Finalize
	ldd	#00
	std	Temp_Rise
	std	Temp_Run				;reset temp variables
	jsr	DP_to_D0
	lda	Mario_Pos_X
	sta	Mario_Pos_Temp+1
	jsr	Mario_Move_Legs			;let's go see what to do about Mario's legs
	lbra	Draw_Mario


Run_Up
	lda	Mario_Pos_Y				;save Y Position for Legs routine
	sta	Mario_Pos_Temp+1
	jsr	DP_to_C8
	lda	#$7f					;this is the scalar value (Mario's speed)
	ldb	Angle_Temp				;this is the angle of movement
	jsr	Rise_Run_Y				;go calculate the rise/run values
	exg	a,b
	lda	#2
	jsr	Mult_Rise_Run_By_A
	std	Temp_Rise
	ldd	Mario_Pos_Y
	addd	Temp_Rise
	std	Mario_Pos_Y
	jsr	DP_to_D0
	lda	Mario_Pos_Y
	cmpa	End_Of_Floor			;reached end of floor?
	bne	Run_Up_Legs				;nope, we're done here
	lda	Mario_Floor
	cmpa	#8
	bne	Run_Up_Next_Floor
	inc	Mario_Got_The_Girl
Run_Up_Next_Floor
	clr	Mario_Pos_Y+1			;reset scalar values
	clr	Mario_Pos_X+1
	dec	Mario_Floor				;Mario is now on the next floor up!
	dec	Mario_Floor
	dec	Mario_Floor
	bra	Run_Up_Legs_1
Run_Up_Legs
	sta	Mario_Pos_Temp
	jsr	Mario_Move_Legs
Run_Up_Legs_1
	ldd	#00
	std	Temp_Rise
	std	Temp_Run
	lbra	Draw_Mario	

Run_Down
	lda	Mario_Pos_Y				;save Y position for Legs routine
	sta	Mario_Pos_Temp+1
	jsr	DP_to_C8
	lda	#$7f					;this is the scalar value ()
	ldb	Angle_Temp				;this is the angle of movement
	jsr	Rise_Run_Y				;go calculate the rise/run values
	exg	a,b
	lda	#2					;Mario's speed
	jsr	Mult_Rise_Run_By_A
	std	Temp_Rise
	ldd	Mario_Pos_Y
	addd	Temp_Rise
	std	Mario_Pos_Y
	jsr	DP_to_D0
	lda	Mario_Pos_Y
	cmpa	End_Of_Floor			;reached end of floor?
	bne	Run_Down_Legs			;nope, we're done here
	clr	Mario_Pos_Y+1			;reset scalar values
	clr	Mario_Pos_X+1
	dec	Mario_Floor				;Mario is now on the next floor down!
	dec	Mario_Floor
	dec	Mario_Floor
	dec	Mario_Floor
	bra	Run_Down_Legs_1
Run_Down_Legs
	sta	Mario_Pos_Temp
	jsr	Mario_Move_Legs
Run_Down_Legs_1
	ldd	#00
	std	Temp_Rise
	std	Temp_Run
	lbra	Draw_Mario

Run_Nowhere						;here Mario is standing still or in a stationarey jump
	ldx	Mario_Pos_X				;this routine makes sure that game timing
	stx	Mario_Save_X			;remains constant when Mario stands still
	ldx	Mario_Pos_Y
	stx	Mario_Save_Y			;save Mario's position, he's not going anywhere
	jsr	DP_to_C8
	lda	#50					;this is the scalar value (Mario's speed)
	ldb	#32					;this is the angle of movement
	jsr	Rise_Run_X				;go calculate the rise/run values
	sta	Temp_Rise+1
	stb	Temp_Run+1
	ldd	Mario_Pos_X				;now adjust Mario's X-Axis Position
	andcc	#%11111110				
	subd	Temp_Run
	std	Mario_Pos_X
	ldd	Mario_Pos_Y
	andcc	#%11111110
	subd	Temp_Rise
	std	Mario_Pos_Y
	jsr	DP_to_D0
	jsr	Mario_Move_Legs
	ldx	Mario_Save_X			;make sure Mario stays put
	stx	Mario_Pos_X
	ldx	Mario_Save_Y
	stx	Mario_Pos_Y
	lbra	Draw_Mario

Mario_Move_Legs
	lda	Mario_Jump				;are we jumping?
	beq	Mario_Move_Legs_1
	ldx	#Mario_Legs_Jumping		;yes, show Mario jumping
	stx	Mario_Shape
	rts
Mario_Move_Legs_1
	lda	Mario_Move				;are we stationary?
	bne	Mario_Move_Legs_2			;nope, we are moving
	rts						;yes, we are stationary
Mario_Move_Legs_2
	lda	Mario_Pos_Temp
	cmpa	Mario_Pos_Temp+1			;has Mario moved?
	beq	Mario_Move_Legs_Done		;nope, nothing to do here
	lda	Mario_Legs				;what do we do with Mario's legs?
	cmpa	#3
	bhi	Mario_Move_Legs_Down
	lda	Mario_Move
	beq	Mario_Move_Legs_Done
	cmpa	#1					;are we moving left?
	bne	Mario_Move_Check_Right		
	ldx	#Mario_Left_Leg_Up		;leg goes up
	stx	Mario_Shape
	bra	Mario_Move_Legs_Done
Mario_Move_Check_Right
	cmpa	#2					;are we moving right?
	bne	Mario_Move_Check_Up_Down
	ldx	#Mario_Right_Leg_Up		;yep
	stx	Mario_Shape
	bra	Mario_Move_Legs_Done
Mario_Move_Check_Up_Down
	ldx	#Mario_Up_Leg_Up			;looks like we are moving up or down
	stx	Mario_Shape
	bra	Mario_Move_Legs_Done
Mario_Move_Legs_Down				;leg goes down
	lda	Mario_Legs
	cmpa	#7
	blo	Mario_Move_Check_Legs_Down
	clr 	Mario_Legs
	lda	Sound_Type
	cmpa	#3					;are we making an over barrel sound?
	bne	Mario_Move_Legs_Down1
	rts						;yes, keep making that sound
Mario_Move_Legs_Down1
	cmpa	#8
	bne	Mario_Move_Legs_Down2
	rts
Mario_Move_Legs_Down2
	lda	#2
	sta	Sound_Type				;flag walking sound
	clr	Next_Sound_Counter
	rts
Mario_Move_Check_Legs_Down
	lda	Mario_Move
	cmpa	#1					;are we moving left?
	bne	Mario_Move_Right_Down
	ldx	#Mario_Left_Leg_Down		;leg goes down
	stx	Mario_Shape
	bra	Mario_Move_Legs_Done
Mario_Move_Right_Down
	cmpa	#2					;are we moving left?
	bne	Mario_Move_Check_Up_Down_2
	ldx	#Mario_Right_Leg_Down		;leg goes down
	stx	Mario_Shape
	bra	Mario_Move_Legs_Done
Mario_Move_Check_Up_Down_2
	ldx	#Mario_Up_Leg_Down		;looks like we are moving up or down
	stx	Mario_Shape
Mario_Move_Legs_Done
	inc	Mario_Legs
	rts

Draw_Mario
	jsr	Reset0Ref				;Here we draw Mario
	lda	Mario_Pos_Y
	ldb	Mario_Pos_X
	jsr	Moveto_d_7F
	lda	#$5F
	jsr	Intensity_a
	lda	Mario_Jump				;are we jumping?
	beq	Draw_Mario_No_Jump
	ldx	#Mario_Legs_Jumping		;yes, show Mario jumping
	stx	Mario_Shape
Draw_Mario_No_Jump
	ldx	Mario_Shape
	jsr	Draw_VLp_7F
	
Barrels_Start
	lda	Mario_Dead
	beq	Barrels_Mario_Not_Dead
	rts						;If mario is dead then go back
Barrels_Mario_Not_Dead
	ldx	#Barrel1_Add
	ldb	Barrel_Move_Count
	lda	b,x				;Let's see if we need to add a barrel?
	cmpa	#2				;did this barrel leave floor 1 before barrel 4 started?
	bne	Barrels_Start_Check
	lda	Add_Barrel			;yes, is it time for it to make an appearance?
	lbeq	Barrels_Check_Move_Back	;nope, let's try the next barrel
	lda	,x
Barrels_Start_Check
	cmpa	#0
	lbeq	Barrels_Check_Move	;nope, process other barrels
	lda	Add_Barrel			;has a barrel gone off the screen?
	beq	Barrels_Start_For_Real	;nope, it's a new barrel
	cmpa	#2				
	beq	Barrel_Start_Again
	inc	Add_Barrel			;yes, bring the barrel back
	bra	Barrels_Start_For_Real
Barrel_Start_Again
	ldb	Barrel_Move_Count
	cmpb	#0				;is this barrel 1?
	beq	Barrels_Start_1
	cmpb	#2				;is this barrel 2?
	beq	Barrels_Start_2
	cmpb	#4
	beq	Barrels_Start_3
	bra	Barrels_Start_4
Barrels_Start_1
	lda	Barrel4_Floor		;time to bring back barrel 1?
	cmpa	#3
	bhi	Barrels_Check_Move
	blo	Barrels_Check_Move
	lda	Barrel4_Pos_X		;yep, bring it back
	cmpa	#32
	bhi	Barrels_Check_Move
	bra	Barrels_Start_For_Real
Barrels_Start_2
	lda	Barrel1_Floor		;time to bring back barrel 2?
	cmpa	#3
	bhi	Barrels_Check_Move
	blo	Barrels_Check_Move
	lda	Barrel1_Pos_X		;yep, bring it back
	cmpa	#32
	bhi	Barrels_Check_Move
	bra	Barrels_Start_For_Real
Barrels_Start_3
	lda	Barrel2_Floor
	cmpa	#3
	bhi	Barrels_Check_Move
	blo	Barrels_Check_Move
	lda	Barrel2_Pos_X
	cmpa	#32
	bhi	Barrels_Check_Move
	bra	Barrels_Start_For_Real
Barrels_Start_4
	lda	Barrel3_Floor
	cmpa	#3
	bhi	Barrels_Check_Move
	blo	Barrels_Check_Move
	lda	Barrel3_Pos_X
	cmpa	#32
	bhi	Barrels_Check_Move
	bra	Barrels_Start_For_Real
Barrels_Start_For_Real
	ldb	Barrel_Move_Count
	ldx	#Barrel1_Add
	lda	#00
	sta	b,x				;reset the add barrel flag
	ldx	#Barrel1_Move
	ldb	Barrel_Move_Count
	lda	#2
	sta	b,x				;set Barrel  move flag to 2 (Right)
	ldx	#Barrel1_Pos_Y
	ldb	Barrel_Count
	lda	#59				;let's place it at the top of the screen
	sta	b,x
	ldx	#Barrel1_Pos_X
	ldb	Barrel_Count
	lda	#-65
	sta	b,x
	ldx	#Barrel1_Floor
	ldb	Barrel_Move_Count
	lda	#04					;we are on floor 4
	sta	b,x
Barrels_Check_Move
	ldx	#Barrel1_Move
	ldb	Barrel_Move_Count
	lda	b,x					;look at a barrel's move flag
	cmpa	#1					;is this barrel moving to the left?
	beq	Barrel_Move_Left
	cmpa	#2
	beq	Barrel_Move_Right			;is this barrel moving to the right?
	cmpa	#3
	lbeq	Barrel_Move_Down			;is this barrel moving Down?
Barrels_Check_Move_Back	
	inc	Barrel_Count			;nope and nope, we do not draw this barrel
	inc	Barrel_Count
	inc	Barrel_Count
	inc	Barrel_Count
	inc	Barrel_Move_Count
	inc	Barrel_Move_Count
	lbra	Draw_Ceck_Last_Barrel
Barrel_Move_Left
	ldb	Barrel_Move_Count
	ldx	#Barrel1_Floor			;what floor is this barrel on?
	lda	b,x
	cmpa	#1
	beq	Barrel_Left_Floor1
	cmpa	#3
	beq	Barrel_Left_Floor3
Barrel_Left_Floor1
	lda	#$10					;floor 1, set angle to 90 degrees
	sta	Angle_Temp
	lda	#-65					;set the end of floor variable
	sta	End_Of_Floor
	lbra	Barrel_To_The_Left
Barrel_Left_Floor3
	lda	#$11					;floor 3, set angle to xx degrees
	sta	Angle_Temp
	lda	#-68					;set the end of floor variable
	sta	End_Of_Floor
	lda	#-26					;load the ladder positions
	sta	Ladder_Temp1
	lda	#-24
	sta	Ladder_Temp2
	lda	#-25
	sta	Ladder_Temp3
	lbra	Barrel_To_The_Left

Barrel_Move_Right
	ldb	Barrel_Move_Count
	ldx	#Barrel1_Floor			;what floor is this barrel on?
	lda	b,x
	cmpa	#2
	beq	Barrel_Right_Floor2
	cmpa	#4
	beq	Barrel_Right_Floor4
Barrel_Right_Floor2
	lda	#$2f					;yes, floor 2, set angle to xx degrees
	sta	Angle_Temp
	lda	#68					;set the end of floor variable
	sta	End_Of_Floor
	lda	#44					;load the ladder positions
	sta	Ladder_Temp1
	lda	#46
	sta	Ladder_Temp2
	lda	#45
	sta	Ladder_Temp3
	lbra	Barrel_To_The_Right
Barrel_Right_Floor4
	lda	#$30					;yes, floor 4, set angle to 90 degrees
	sta	Angle_Temp
	lda	#67					;set the end of floor variable
	sta	End_Of_Floor
	lda	#34					;load the ladder positions
	sta	Ladder_Temp1
	lda	#36
	sta	Ladder_Temp2
	lda	#35
	sta	Ladder_Temp3
	lbra	Barrel_To_The_Right

Barrel_Move_Down
	ldb	Barrel_Move_Count
	ldx	#Barrel1_Floor			;what floor is this barrel on?
	lda	b,x
	cmpa	#1
	beq	Barrel_Down_Floor1
	cmpa	#2
	beq	Barrel_Down_Floor2
	cmpa	#3
	beq	Barrel_Down_Floor3
	cmpa	#4
	beq	Barrel_Down_Floor4
Barrel_Down_Floor1
	ldx	#Barrel1_Move			;barrel move flag = 0
	ldb	Barrel_Move_Count
	lda	#0
	sta	b,x
	lda	Add_Barrel
	bne	Barrel_Down_Floor1_Add
	lda	#2
	bra	Barrel_Down_Floor1_Add1
Barrel_Down_Floor1_Add
	lda	#1
Barrel_Down_Floor1_Add1
	ldx	#Barrel1_Add
	sta	b,x
	lbra	Draw_Ceck_Last_Barrel
Barrel_Down_Floor2
	lda	#$20
	sta	Angle_Temp
	lda	#-71
	sta	End_Of_Floor
	lbra	Barrel_Go_Down
Barrel_Down_Floor3
	lda	#$20
	sta	Angle_Temp
	ldx	#Barrel_On_Ladder1		;barrel going down ladder?
	ldb	Barrel_Move_Count
	lda	b,x
	beq	Barrel_Down_Floor3_Edge		;nope
	lda	#-23					;yep
	bra	Barrel_Down_Floor3_Ladder
Barrel_Down_Floor3_Edge
	lda	#-19
Barrel_Down_Floor3_Ladder
	sta	End_Of_Floor
	lbra	Barrel_Go_Down
Barrel_Down_Floor4
	lda	#$20
	sta	Angle_Temp
	ldx	#Barrel_On_Ladder1		;barrel going down ladder?
	ldb	Barrel_Move_Count
	lda	b,x
	beq	Barrel_Down_Floor4_Edge		;nope
	lda	#18					;yep
	bra	Barrel_Down_Floor4_Ladder
Barrel_Down_Floor4_Edge
	lda	#21
Barrel_Down_Floor4_Ladder
	sta	End_Of_Floor
	lbra	Barrel_Go_Down

Barrel_To_The_Left
	ldx	#Barrel1_Pos_X			;Get current position of barrel
	ldb	Barrel_Count	
	leax	b,x
	lda	,x
	tsta
	bpl	Barrel_To_The_Left_1		;we have not reached center screen
	lda	,x
	cmpa	End_Of_Floor			;end of floor reached?
	bhi	Barrel_To_The_Left_1		;not yet
	ldx	#Barrel_On_Ladder1		;clear the ladder flag
	ldb	Barrel_Move_Count
	clr	b,x
	lbra	Barrel_Left_Reset			;yep, we're done here
Barrel_To_The_Left_1
	ldx	#Barrel1_Floor			;what floor is the barrel on?
	ldb	Barrel_Move_Count
	ldb	b,x
	cmpb	#1					;first floor?
	beq	Barrel_Left_No_Ladder		;then do not check for ladder
	ldx	#Barrel1_Pos_X
	lda	Barrel_Count
	ldb	a,x
	cmpb	Ladder_Temp1
	blo	Barrel_Left_No_Ladder
	cmpb	Ladder_Temp2
	bhi	Barrel_Left_No_Ladder
	jsr	Random_3				;we are on top of a ladder
	cmpa	#200					;do we go down the ladder?
	bls	Barrel_Left_No_Ladder
	ldx	#Barrel_On_Ladder1
	ldb	Barrel_Move_Count			;set the ladder flag
	lda	#1
	sta	b,x
	ldx	#Barrel1_Pos_X			;make sure barrel is centered on ladder
	lda	Barrel_Count
	ldb	Ladder_Temp3
	stb	a,x
	bra	Barrel_Left_Reset			;yes
Barrel_Left_No_Ladder
	jsr	DP_to_C8
	lda	#$7f					;this is the scalar value (Barrel's speed)
	ldb	Angle_Temp				;this is the angle of movement
	jsr	Rise_Run_Y				;go calculate the rise/run values
	sta	Temp_Rise+1
	stb	Temp_Run+1
	lda	#3
	jsr	Mult_Rise_Run_By_A
	std	Temp_Run
	ldx	#Barrel1_Pos_X			;now add the rise/run values to...
	ldb	Barrel_Count
	leax	b,x
	ldy	#Barrel1_Pos_Y
	leay	b,y
	ldd	,x
	addd	Temp_Run
	std	,x
	lda	,x
	cmpa	#32					;time to start a new barrel?
	bhi	Return_Check_Add_Barrel
	lda	Add_Barrel
	bne	Return_Check_Add_Barrel
	ldx	#Barrel1_Floor
	ldb	Barrel_Move_Count
	abx
	lda	,x
	cmpa	#3
	beq	Check_Add_Barrel
Return_Check_Add_Barrel
	ldb	Temp_Rise+1
	lda	#3
	jsr	Mult_Rise_Run_By_A
	std	Temp_Run
	ldd	,y
	addd	Temp_Run
	std	,y
	ldd	#00
	std	Temp_Rise
	std	Temp_Run
	jsr	DP_to_D0
Barrel_Left_Finalize
	clr	Y_Axis_Adjust
	lbra	Draw_Barrel
Barrel_Left_Reset
	ldx	#Barrel1_Move
	ldb	Barrel_Move_Count
	lda	#3
	sta	b,x
	lbra	Draw_Barrel

Check_Add_Barrel					;this routine handles initial barrel rollout
	ldb	Barrel_Move_Count
	incb
	incb
	ldx	#Barrel1_Move
	lda	b,x
	bne	Return_Check_Add_Barrel
	ldx	#Barrel1_Add
	lda	#1
	sta	b,x
	lda	Barrel4_Add
	beq	Return_Check_Add_Barrel
	inc	Add_Barrel
	bra	Return_Check_Add_Barrel

Barrel_To_The_Right
	ldx	#Barrel1_Pos_X			;Get current position of barrel
	ldb	Barrel_Count	
	leax	b,x
	lda	,x
	bmi	Barrel_To_The_Right_1		;we have not reached center screen
	cmpa	End_Of_Floor			;end of floor reached?
	blo	Barrel_To_The_Right_1		;not yet
	ldx	#Barrel_On_Ladder1		;clear the ladder flag
	ldb	Barrel_Move_Count
	clr	b,x
	bra	Barrel_Right_Reset		;yep, we're done here
Barrel_To_The_Right_1	
	ldx	#Barrel1_Pos_X
	lda	Barrel_Count
	ldb	a,x
	cmpb	Ladder_Temp1
	blo	Barrel_Right_No_Ladder
	cmpb	Ladder_Temp2
	bhi	Barrel_Right_No_Ladder
	jsr	Random_3				;we are on top of a ladder
	cmpa	#200					;do we go down the ladder?
	bls	Barrel_Right_No_Ladder
	ldx	#Barrel_On_Ladder1
	ldb	Barrel_Move_Count			;set the ladder flag
	lda	#1
	sta	b,x
	ldx	#Barrel1_Pos_X			;make sure barrel is centered on ladder
	lda	Barrel_Count
	ldb	Ladder_Temp3
	stb	a,x
	bra	Barrel_Right_Reset		;yes
Barrel_Right_No_Ladder	
	jsr	DP_to_C8
	lda	#$7f					;this is the scalar value (Barrel's speed)
	ldb	Angle_Temp				;this is the angle of movement
	jsr	Rise_Run_Y				;go calculate the rise/run values
	sta	Temp_Rise+1
	stb	Temp_Run+1
	lda	#3
	jsr	Mult_Rise_Run_By_A
	std	Temp_Run
	ldx	#Barrel1_Pos_X			;now add the rise/run values to...
	ldb	Barrel_Count
	leax	b,x
	ldy	#Barrel1_Pos_Y
	leay	b,y
	ldd	,x
	addd	Temp_Run
	std	,x
	ldb	Temp_Rise+1
	lda	#3
	jsr	Mult_Rise_Run_By_A
	std	Temp_Run
	ldd	,y
	addd	Temp_Run
	std	,y
	ldd	#00
	std	Temp_Rise
	std	Temp_Run
	jsr	DP_to_D0
	lbra	Draw_Barrel
Barrel_Right_Reset
	ldx	#Barrel1_Move
	ldb	Barrel_Move_Count
	lda	#3					;set barrel's move flag to "down"
	sta	b,x
	lbra	Draw_Barrel

Barrel_Go_Down
	ldx	#Barrel1_Pos_Y
	ldb	Barrel_Count
	abx
	lda	,x
	cmpa	End_Of_Floor			;reached end of floor?
	beq	Barrel_Go_Down_Reset
	jsr	DP_to_C8
	lda	#$7f					;this is the scalar value (Barrel's speed)
	ldb	Angle_Temp				;this is the angle of movement
	jsr	Rise_Run_Y				;go calculate the rise/run values
	sta	Temp_Rise+1
	stb	Temp_Run+1
	lda	#2
	jsr	Mult_Rise_Run_By_A
	std	Temp_Run
	ldx	#Barrel1_Pos_X			;now add the rise/run values to...
	ldb	Barrel_Count
	leax	b,x
	ldy	#Barrel1_Pos_Y
	leay	b,y
	ldd	,x
	addd	Temp_Run
	std	,x
	ldb	Temp_Rise+1
	lda	#2
	jsr	Mult_Rise_Run_By_A
	std	Temp_Run
	ldd	,y
	addd	Temp_Run
	std	,y
	ldd	#00
	std	Temp_Rise
	std	Temp_Run
	jsr	DP_to_D0
	bra	Barrel_Go_Down_Finalize
Barrel_Go_Down_Reset
	ldx	#Barrel1_Floor
	ldb	Barrel_Move_Count
	abx
	lda	,x
	cmpa	#4					;we just drop from floor 4?
	bne	Barrel_Go_Down_Reset_3
	deca						;yes, we are now on floor 3
	sta	,x
	ldx	#Barrel1_Move
	ldb	Barrel_Move_Count
	abx
	lda	#1					;and now we move to the left
	sta	,x
	bra	Barrel_Go_Down_Finalize
Barrel_Go_Down_Reset_3
	ldx	#Barrel1_Floor
	ldb	Barrel_Move_Count
	abx
	lda	,x
	cmpa	#3					;we just drop from floor 3?
	bne	Barrel_Go_Down_Reset_2
	deca						;yes, we are now on floor 2
	sta	,x
	ldx	#Barrel1_Move
	ldb	Barrel_Move_Count
	abx
	lda	#2					;and now we move to the right
	sta	,x
	bra	Barrel_Go_Down_Finalize
Barrel_Go_Down_Reset_2
	ldx	#Barrel1_Floor
	ldb	Barrel_Move_Count
	abx
	lda	,x
	cmpa	#2					;we just drop from floor 2?
	bne	Barrel_Go_Down_Reset_1
	deca						;yes, we are now on floor 1
	sta	,x
	ldx	#Barrel1_Move
	ldb	Barrel_Move_Count
	abx
	lda	#1					;and now we move to the right
	sta	,x
	bra	Barrel_Go_Down_Finalize
Barrel_Go_Down_Reset_1
	bra	Barrel_Go_Down_Reset_1
Barrel_Go_Down_Finalize
	bra	Draw_Barrel


Draw_Barrel
	jsr	Reset0Ref				;Here we draw the barrels
	lda	#$5F
	jsr	Intensity_a
	ldb	Barrel_Count
	ldx	#Barrel1_Pos_Y
	abx
	lda	,x
	ldx	#Barrel1_Pos_X
	abx
	ldb	,x
	jsr	Moveto_d_7F
	ldx	#Barrel_VL
	jsr	Draw_VLp_7F
	inc	Barrel_Count
	inc	Barrel_Count
	inc	Barrel_Count
	inc	Barrel_Count
	inc	Barrel_Move_Count
	inc	Barrel_Move_Count
Draw_Ceck_Last_Barrel
	lda	Barrel_Count			;have we processed all barrels yet?
	cmpa	#16
	bne	Draw_Again
	clr	Barrel_Count			;yes, back to main loop
	clr	Barrel_Move_Count
	lbra	Make_Sound
Draw_Again		
	lbra	Barrels_Start

When_Sprites_Collide
	ldx	#Mario_Pos_Y
	lda	,x
	ldx	#Mario_Pos_X
	ldb	,x
	exg	d,y
	clr	Barrel_Count
Collision_Check	
	ldx	#Barrel1_Pos_Y
	ldb	Barrel_Count
	lda	b,x
	ldx	#Barrel1_Pos_X
	ldb	b,x
	exg	d,x
	lda	Mario_Jump
	beq	Collision_No_Jump
	lda	#7
	bra	Collision_Jump
Collision_No_Jump
	lda	#7+5
Collision_Jump
	ldb	#3+5
	jsr	Obj_Hit
	bcs	Sprites_Have_Collided
	inc	Barrel_Count
	inc	Barrel_Count
	inc	Barrel_Count
	inc	Barrel_Count
	lda	Barrel_Count
	cmpa	#16
	bne	Collision_Check
	clr	Barrel_Count
	rts
Sprites_Have_Collided
	jsr	Clear_Sound
	lda	#1
	sta	Mario_Dead
	lda	#4
	sta	Sound_Type
	clr	Next_Sound_Counter
	clr	Sound_Counter
	clr	All_Barrels_Cleared
	lda	Number_Barrels_Jumped
	cmpa	#15
	blo	Sprites_Have_Collided_1
	lda	#14
	sta	Number_Barrels_Jumped
Sprites_Have_Collided_1
	lbra	Crash_Over_Barrel


Mult_Rise_Run_By_9			;Stolen from Star Castle
    	lda   #02  
Mult_Rise_Run_By_A
      clr   Mult_Count   
      tstb    
      bpl   P0C3A
      inc   Mult_Count			;/* Keep track if value is negative. */
P0C3A	jsr   Abs_a_b
      mul
      std   Mult_Result
      lsr   Mult_Count   
      bhs   P0C4B
      coma					;/* If the rise/run value was negative */
      comb					;/* then take twos complement, to make */
      addd  #0001				;/* the result negative also.          */
      std   Mult_Result   
P0C4B rts


Make_Sound
	lda	Sound_Type
	cmpa	#1				;is Mario Jumping?
	beq	Sound_Jump
	cmpa	#2
	beq	Sound_Mario_Run
	cmpa	#3
	beq	Sound_Over_Barrel
	cmpa	#4
	beq	Sound_Crash_Over_Barrel
	cmpa	#5
	beq	Sound_Throw_Fireball
	cmpa	#6
	beq	Sound_Kong_Scale_Down
	cmpa	#7
	beq	Sound_Broken_Heart
	cmpa	#8
	lbeq	Sound_Fifteen_Barrels
	rts
Sound_Jump
	lda	Sound_Counter		;sound still in progress?
	bne	Sound_Jump_Return
	ldx	#Sound_Jump_Init
	stx	Sound_Init_Temp
	ldx	#Sound_Mario_Jump
	stx	Sound_Temp
	lbra	Make_Sound_Main
Sound_Jump_Return
	dec	Sound_Counter
	rts
Sound_Mario_Run
	lda	Sound_Counter		;sound still in progress?
	bne	Sound_Jump_Return
	ldx	#Sound_Run_Init
	stx	Sound_Init_Temp
	ldx	#Mario_Sound_Run
	stx	Sound_Temp
	bra	Make_Sound_Main
Sound_Over_Barrel
	lda	Sound_Counter		;sound still in progress?
	bne	Sound_Jump_Return
	ldx	#Sound_Barrel_Init
	stx	Sound_Init_Temp
	ldx	#Sound_Jump_Barrel
	stx	Sound_Temp
	bra	Make_Sound_Main
Sound_Crash_Over_Barrel
	lda	Sound_Counter		;sound still in progress?
	bne	Sound_Jump_Return
	ldx	#Sound_Crash_Init
	stx	Sound_Init_Temp
	ldx	#Sound_Crash
	stx	Sound_Temp
	bra	Make_Sound_Main
Sound_Throw_Fireball
	lda	Sound_Counter		;sound still in progress?
	bne	Sound_Jump_Return
	ldx	#Sound_Fireball_Init
	stx	Sound_Init_Temp
	ldx	#Sound_Fireball
	stx	Sound_Temp
	bra	Make_Sound_Main
Sound_Kong_Scale_Down
	lda	Sound_Counter		;sound still in progress?
	bne	Sound_Jump_Return
	ldx	#Sound_Kong_Scale_Down_Init
	stx	Sound_Init_Temp
	ldx	#Sound_Kong_Scale_Down_Play
	stx	Sound_Temp
	bra	Make_Sound_Main
Sound_Broken_Heart
	lda	Sound_Counter		;sound still in progress?
	bne	Sound_Jump_Return
	ldx	#Broken_Heart_Init
	stx	Sound_Init_Temp
	ldx	#Broken_Heart_Play
	stx	Sound_Temp
	bra	Make_Sound_Main
Sound_Fifteen_Barrels
	lda	Sound_Counter		;sound still in progress?
	bne	Sound_Jump_Return
	ldx	#Fifteen_Barrels_Init
	stx	Sound_Init_Temp
	ldx	#Fifteen_Barrels_Play
	stx	Sound_Temp
	bra	Make_Sound_Main

Make_Sound_Main
	lda	Next_Sound_Counter	;are we playing a sound
	bne	Sound_Continue		;yes, keep going
	ldx	Sound_Init_Temp		;new sound
	lda	#8				;start with register 8 (vol v1)
	sta	Reg_Edit_Loop
Sound_Volume
	ldb	,x+				;get volume for each voice
	pshs	x
	lda	Reg_Edit_Loop
	jsr	Sound_Byte
	puls	x
	inc	Reg_Edit_Loop		;next voice volume register
	lda	Reg_Edit_Loop
	cmpa	#11
	bne	Sound_Volume
Sound_Reg_7
	lda	#7				;now we turn on the voices (register 7)
	ldb	,x
	jsr	Sound_Byte
Sound_Continue
	ldx	Sound_Temp
	lda	Next_Sound_Counter	;now point to the sound string
	ldb	a,x				;get note duration
	inc	Next_Sound_Counter
	stb	Sound_Counter
	cmpb	#$ff				;end of string?
	lbeq	Sound_Done			;yes sound is done
	clr	Reg_Edit_Loop		;nope, let's get the next note
Sound_Voice_Freq
	ldx	Sound_Temp
	lda	Next_Sound_Counter
	leax	a,x				;go get the next note
	ldb	,x
	lda	Reg_Edit_Loop		;this is the voice (register) counter
	jsr	Sound_Byte
	inc	Next_Sound_Counter
	inc	Reg_Edit_Loop
	lda	Reg_Edit_Loop
	cmpa	#7				;have we processed all voices?
	bne	Sound_Voice_Freq		;nope, next voice
	rts
Sound_Done
	clr	Sound_Type			;end sound here
	clr	Sound_Counter
	clr	Next_Sound_Counter
	jsr	Clear_Sound
	rts

Crash_Over_Barrel
	lda	Sound_Type
	cmpa	#4
	beq	Crash_Over_Barrel_1
	bra	Kong_Fireball
Crash_Over_Barrel_1
	lda	#3
	sta	Mario_Move
	lda	#1
	sta	Mario_Jump				;Mario Legs up
	jsr	Draw_Mario
	lda	Asterisk_Rotate
	adda	#3
	sta	Asterisk_Rotate
	jsr	DP_to_C8
	lda	Asterisk_Rotate
	ldx	#Mario_Asterisks
	ldu	#Mario_Asterisks_Rotated
	jsr	Rot_VL_Mode
	jsr	DP_to_D0
	clr	Mario_Jump
	ldd	#Mario_Asterisks_Rotated
	std	Mario_Shape
	jsr	Draw_Mario
	inc	Mario_Jump
	jsr	Make_Sound
	jsr	Counter
	rts
Kong_Fireball
	lda	Sound_Type
	cmpa	#5
	beq	Kong_Fireball_1
	lda	#5
	sta	Sound_Type
Kong_Fireball_1
	lda	Mario_Pos_Y			;calculate rise and run from Kong to Mario
	suba	Fireball_Pos_Y
	sta	Temp_Rise
	lda	Mario_Pos_X
	suba	Fireball_Pos_X
	sta	Temp_Run
	jsr	DP_to_C8			;now get the rise/run angle
	lda	Temp_Rise
	ldb	Temp_Run
	jsr	Rise_Run_Angle
	suba	#$10				;convert to vectrex angle
	anda	#$3f
	sta	Angle_Temp
	lda	Temp_Rise
	blt	Kong_Fireball_Less_128	;is Mario standing more that 128 y-coord away?
	lda	Angle_Temp			;yes, we must adjust the angle
	adda	Angle_Temp
	sta	Angle_Temp
	lda	#$1e
	suba	Angle_Temp
	sta	Angle_Temp
Kong_Fireball_Less_128	
	ldd	#0000
	std	Temp_Rise
	std	Temp_Run
	lda	#$7f				;calculate rise_run index values
	ldb	Angle_Temp
	jsr	Rise_Run_Y
	sta	Temp_Rise+1
	stb	Temp_Run+1
	jsr	DP_to_D0
	lda	#9
	ldb	Temp_Rise+1
	jsr	Mult_Rise_Run_By_A
	std	Temp_Rise
	ldd	Fireball_Pos_Y
	addd	Temp_Rise
	std	Fireball_Pos_Y
	lda	#9
	ldb	Temp_Run+1
	jsr	Mult_Rise_Run_By_A
	std	Temp_Run
	ldd	Fireball_Pos_X
	addd	Temp_Run
	std	Fireball_Pos_X
	jsr	Reset0Ref			;now draw fireball
	lda	#$5F
	jsr	Intensity_a
	lda	Fireball_Pos_Y
	ldb	Fireball_Pos_X
	jsr	Moveto_d
	ldx	#Fireball
	jsr	Draw_VLp_7F
	lda	Fireball_Pos_Y
	ldb	Fireball_Pos_X
	exg	d,y
	lda	Mario_Pos_Y
	ldb	Mario_Pos_X
	exg	d,x
	lda	#2
	ldb	#2
	jsr	Obj_Hit
	bcs	Fireball_Has_Hit_Mario
	bra	Crash_Over_Barrel_1
Fireball_Has_Hit_Mario
	jsr	Clear_Sound				;stop sounds
	lda	#6
	sta	Sound_Type
	clr	Next_Sound_Counter
Fireball_Has_HitMario_1
	jsr	Make_Sound
	jsr	Reset0Ref
	ldd	#00
	jsr	Moveto_d
	lda	#$5f					;set intensity
	jsr	Intensity_a
	ldb	Mario_Scale				;get the scale factor
	ldx	#Mario_Big_Legs_Jumping
	jsr	Draw_VLp_b				;draw giant Mario
	jsr	Counter
	lda	Mario_Scale				
	deca						;now scale him down
	cmpa	#30
	beq	Fireball_Has_HitMario_2
	sta	Mario_Scale
	bra	Fireball_Has_HitMario_1
Fireball_Has_HitMario_2
	jsr	Clear_Sound
	clr	Next_Sound_Counter
	lda	#7
	sta	Sound_Type
Fireball_Has_HitMario_3
	jsr	Make_Sound
	jsr	Reset0Ref
	lda	#30
	ldb	#0
	jsr	Moveto_d_7F
	lda	#$5f					;set intensity
	jsr	Intensity_a
	ldb	#30
	ldx	#Broken_Heart
	jsr	Draw_VLp_b
	jsr	Reset0Ref
	ldd	#00
	jsr	Moveto_d_7F
	lda	#$5f					;set intensity
	jsr	Intensity_a
	ldb	Mario_Scale
	ldx	#Mario_Big_Legs_Jumping
	jsr	Draw_VLp_b
	jsr	Counter
	lda	Sound_Type
	bne	Fireball_Has_HitMario_3
	lda	#1
	sta	Back_To_Intro
	rts

Mario_Wins
	lda	#1
	sta	Vec_Music_Flag			;set music to start playing
	lda	#0
	std	Fireball_Pos_Y
	lda	#100
	sta	Fireball_Pos_X
	lda	#-50
	sta	Mario_Pos_Y
	lda	#30
	sta	Mario_Pos_X
	lda	#-60
	sta	Mario_Pos_Y+1
	lda	#-30
	sta	Mario_Pos_X+1
	lda	#-120					;******
	sta	Ladder_Temp1			;******
	lda	#15					;******
	sta	Ladder_Temp2			;******
	lda	#0
	sta	Asterisk_Rotate
	clr	Star_Count
	clr	Heartbeat
	clr	Heartbeat_Sign
	clr	Mario_Move
	clr	Jump_Count
	clr	Recal_Count
	lda	#-80
	sta	Barrel1_Pos_X
	clr	Angle_Temp
Mario_Wins_Loop
	jsr	DP_to_C8				;here we rotatate and draw the star
	lda	Asterisk_Rotate
	ldx	#Star
	ldu	#Star_Rotated
	jsr	Rot_VL_Mode
	jsr	DP_to_D0
	jsr	Reset0Ref
	lda	Fireball_Pos_Y
	ldb	Fireball_Pos_X
	jsr	Moveto_d_7F
	lda	#$5f					;set intensity
	jsr	Intensity_a
	ldb	#30					;get the scale factor
	ldx	#Star_Rotated
	jsr	Draw_VLp_b				;draw star
	inc 	Asterisk_Rotate
	lda	Asterisk_Rotate
	bne	Mario_Wins_Play_Music
	lda	Fireball_Pos_X
	cmpa	#100
	beq	Move_Star_Left
	lda	#100
	sta	Fireball_Pos_X
	bra	Mario_Wins_Play_Music
Move_Star_Left
	lda	#-100
	sta	Fireball_Pos_X
Mario_Wins_Play_Music
	lda	Vec_Music_Flag
	beq	Mario_Wins
	jsr	DP_to_C8
	ldu	#Mario_Wins_Music
	jsr	Init_Music_chk
	jsr	Wait_Recal
	jsr	Do_Sound
Draw_Heart_End
	jsr	Reset0Ref
	lda	#30
	ldb	#0
	jsr	Moveto_d_7F
	lda	#$5f					;set intensity
	jsr	Intensity_a
	jsr	Random
	cmpa	#100
	blo	Draw_Heart_End_Low
	lda	#3
	bra	Draw_Heart_End_4
Draw_Heart_End_Low
	lda	#1
Draw_Heart_End_4
	ldb	Heartbeat_Sign
	beq	Draw_Heart_End_2
	coma
Draw_Heart_End_1
	adda	Heartbeat
	sta	Heartbeat
	cmpa	#128
	blo	Draw_Heart_End_3
	clr	Heartbeat
	clr	Heartbeat_Sign
	bra	Draw_Heart_End_3
Draw_Heart_End_2
	adda	Heartbeat
	sta	Heartbeat
	cmpa	#40
	blo	Draw_Heart_End_3
	lda	#40
	sta	Heartbeat
	lda	#1
	sta	Heartbeat_Sign
Draw_Heart_End_3
	ldb	Heartbeat
	ldx	#Heart
	jsr	Draw_VLp_b
Draw_Mario_End
	jsr	Reset0Ref
	lda	Mario_Pos_Y
	ldb	Mario_Pos_X
	jsr	Moveto_d_7F
	lda	#$6F					;set intensity
	jsr	Intensity_a
	ldb	#80
	ldx	#Mario_Left_Leg_Down_End
	jsr	Draw_VLp_b
	inc	Jump_Count
	lda	Jump_Count
	cmpa	#5
	bne	Draw_Girl_End
	clr	Jump_Count
	lda	Mario_Move				;0=left, 1=right
	bne	Draw_Mario_End_Right
	dec	Mario_Pos_X
	dec	Mario_Pos_X+1
	dec	Ladder_Temp2
	lda	Mario_Pos_X
	cmpa	#-10
	bne	Draw_Girl_End
	inc	Mario_Move
Draw_Mario_End_Right
	inc	Mario_Pos_X
	inc	Mario_Pos_X+1
	inc	Ladder_Temp2
	lda	Mario_Pos_X
	cmpa	#70
	bne	Draw_Girl_End
	clr	Mario_Move
Draw_Girl_End
	jsr	Reset0Ref
	lda	Mario_Pos_Y+1
	ldb	Mario_Pos_X+1
	jsr	Moveto_d_7F
	lda	#$6F					;set intensity
	jsr	Intensity_a
	ldb	#80
	ldx	#Girl_End
	jsr	Draw_VLp_b
Draw_Koko_End
	jsr	Reset0Ref
	lda	Ladder_Temp1
	ldb	Ladder_Temp2
	jsr	Moveto_d_7F
	lda	#$4f
	jsr	Intensity_a
	ldx	#Koko_End
	jsr	Draw_VLp_scale
Draw_Final_Message
	jsr	Reset0Ref
	lda	#$6f
	jsr	Intensity_a
	lda	#-8
	ldb	#70
	std	$c82a
	lda	#120
	ldb	Barrel1_Pos_X
	ldu	#Message_End
	jsr	Print_Str_d
	inc	Recal_Count
	lda	Recal_Count
	cmpa	#20
	bne	Draw_Message_End
	clr	Recal_Count
	lda	Angle_Temp				;0=left, 1=right
	bne	Draw_Message_Right
	dec	Barrel1_Pos_X
	lda	Barrel1_Pos_X
	cmpa	#-90
	bne	Draw_Message_End
	inc	Angle_Temp
	bra	Draw_Message_End
Draw_Message_Right
	inc	Barrel1_Pos_X
	lda	Barrel1_Pos_X
	cmpa	#-70
	bne	Draw_Message_End
	clr	Angle_Temp
Draw_Message_End
	bra	Mario_Wins_Loop

Counter
	inc	Recal_Count
	lda	Recal_Count
	cmpa	#100
	bne	Counter1
	jsr	Wait_Recal
	clr	Recal_Count
Counter1
	rts

S	equ	9
E	equ	11+3
Q	equ	20+3
H	equ	24+3
N	equ	$80


Mario_Wins_Music
	fdb	$fee8,$fd79
	
	fcb	N+$10,$0b,E
	fcb	N+$14,$14,E
	fcb	N+$12,$12,S
	fcb	N+$14,$14,S
	fcb	N+$15,N+$10,$0d,E+E
	fcb	N+$14,N+$10,$0b,Q
	fcb	N+$12,N+$0e,$09,H+E

	fcb	N+$1e,N+$15,$12,E
	fcb	N+$19,N+$15,$10,E
	fcb	N+$19,N+$15,$10,E
	fcb	N+$15,N+$12,$0e,E

	fcb	N+$14,N+$0b,$0b,E
	fcb	N+$14,N+$14,$14,E
	fcb	N+$12,N+$12,$12,S
	fcb	N+$14,N+$14,$12,S
	fcb	N+$15,N+$10,$0d,E+E
	fcb	N+$14,N+$10,$0b,Q
	fcb	N+$12,N+$0e,$09,H+E

	fcb	N+$1e,N+$15,$12,E
	fcb	N+$19,N+$15,$10,E
	fcb	N+$17,N+$14,$10,E
	fcb	N+$15,N+$10,$0d,E

	fcb	N+$14,N+$10,$0b,E
	fcb	N+$0b,N+$0b,$0b,S
	fcb	N+$0d,N+$0d,$0d,S
	fcb	N+$10,N+$10,$10,S
	fcb	N+$0d,N+$0d,$0d,S
	fcb	N+$10,N+$10,$10,S
	fcb	N+$0d,N+$0d,$0d,S
	fcb	N+$10,N+$10,$0b,E
	fcb	N+$14,$14,Q
	fcb	N+$12,$12,S
	fcb	N+$14,$14,S

	fcb	N+$12,N+$09,$09,S
	fcb	N+$0e,N+$0e,$0e,S
	fcb	N+$0e,N+$0e,$0e,S
	fcb	N+$0e,N+$0e,$0e,S
	fcb	N+$0e,N+$09,$09,E
	fcb	N+$10,N+$10,$10,S
	fcb	N+$12,N+$0e,$09,E
	fcb	N+$10,N+$10,$10,S
	fcb	N+$0e,N+$0e,$0e,Q
	fcb	N+$10,N+$0d,$09,E
	
	fcb	N+$10,N+$0b,$08,E
	fcb	N+$0b,N+$0b,$0b,S
	fcb	N+$0d,N+$0d,$0d,S
	fcb	N+$10,N+$10,$10,S
	fcb	N+$0d,N+$0d,$0d,S
	fcb	N+$10,N+$10,$10,S
	fcb	N+$0d,N+$0d,$0d,S
	fcb	N+$10,N+$10,$0b,E
	fcb	N+$14,N+$14,$14,Q
	fcb	N+$12,N+$12,$12,S
	fcb	N+$14,N+$14,$14,S	

	fcb	N+$12,N+$09,$09,E
	fcb	N+$0e,N+$09,$09,Q
	fcb	N+$12,N+$09,$09,E
	fcb	N+$0e,N+$09,$09,Q
	fcb	N+$12,N+$0e,$09,E
	fcb	N+$10,N+$0d,$09,E

	fcb	N+$10,N+$0b,$08,E
	fcb	N+$0b,N+$0b,$0b,S
	fcb	N+$0d,N+$0d,$0d,S
	fcb	N+$10,N+$10,$10,S
	fcb	N+$0d,N+$0d,$0d,S
	fcb	N+$10,N+$10,$10,S
	fcb	N+$0d,N+$0d,$0d,S
	fcb	N+$10,N+$10,$0b,E
	fcb	N+$14,N+$14,$14,Q
	fcb	N+$12,N+$12,$12,S
	fcb	N+$14,N+$14,$14,S

	fcb	N+$15,N+$12,$0e,E
	fcb	N+$14,N+$14,$14,S
	fcb	N+$12,N+$0e,$0e,E+S
	fcb	N+$14,N+$14,$14,S
	fcb	N+$15,N+$12,$0e,E
	fcb	N+$14,N+$14,$14,S
	fcb	N+$12,N+$12,$12,S
	fcb	N+$10,N+$0d,$09,E+S
	fcb	N+$0d,N+$09,$09,E

	fcb	N+$15,N+$10,$0d,E
	fcb	N+$15,N+$10,$0d,Q
	fcb	N+$17,N+$17,$17,S
	fcb	N+$19,N+$15,$10,E+S
	fcb	N+$15,N+$10,$10,E
	fcb	N+$12,N+$12,$12,E
	fcb	N+$10,N+$10,$10,E

	fcb	N+$15,N+$12,$0e,E
	fcb	N+$15,N+$12,$0e,E
	fcb	N+$17,N+$17,$17,E
	fcb	N+$19,N+$14,$10,S
	fcb	N+$19,N+$19,$19,S
	fcb	N+$15,N+$15,$15,E
	fcb	N+$17,N+$14,$10,E
	fcb	N+$19,N+$19,$19,E

	fcb	N+$15,N+$10,$0d,E
	fcb	N+$15,N+$10,$0d,Q
	fcb	N+$17,N+$17,$17,E
	fcb	N+$19,N+$10,$10,S
	fcb	N+$19,N+$19,$19,S
	fcb	N+$15,N+$15,$15,E
	fcb	N+$12,N+$09,$09,E
	fcb	N+$10,N+$10,$10,E

	fcb	N+$15,N+$12,$0e,E
	fcb	N+$15,N+$12,$0e,E
	fcb	N+$17,N+$17,$17,E
	fcb	N+$19,N+$14,$10,S
	fcb	N+$19,N+$19,$19,S
	fcb	N+$15,N+$15,$15,E
	fcb	N+$17,N+$14,$10,E
	fcb	N+$19,N+$19,$19,E

	fcb	N+$15,N+$10,$0d,E
	fcb	N+$15,N+$10,$0d,Q
	fcb	N+$17,N+$17,$17,E
	fcb	N+$19,N+$10,$10,S
	fcb	N+$19,N+$19,$19,S
	fcb	N+$15,N+$15,$15,E
	fcb	N+$12,N+$09,$09,E
	fcb	N+$10,N+$10,$10,E

	fcb	N+$15,N+$12,$0e,E
	fcb	N+$15,N+$12,$0e,E
	fcb	N+$10,N+$10,$10,Q
	fcb	N+$19,N+$14,$10,E
	fcb	N+$17,N+$10,$10,S
	fcb	N+$15,N+$15,$15,S
	fcb	N+$14,N+$14,$14,E

	fcb	N+$15,N+$15,$15,E
	fcb	N+$1c,N+$19,$15,Q
	fcb	N+$1c,N+$19,$15,Q
	fcb	N+$1c,N+$19,$15,Q
	fcb	N+$1e,N+$1a,$15,Q+E

	fcb	N+$1a,N+$15,$12,Q
	fcb	N+$15,N+$12,$0d,E
	fcb	N+$19,N+$19,$19,E
	fcb	N+$17,N+$10,$10,S
	fcb	N+$15,N+$15,$15,S
	fcb	N+$14,N+$14,$14,E

	fcb	N+$15,N+$15,$15,E
	fcb	N+$1c,N+$19,$15,Q
	fcb	N+$1c,N+$19,$15,Q
	fcb	N+$1c,N+$19,$15,Q
	fcb	N+$1e,N+$1a,$15,Q+E

	fcb	N+$15,N+$12,$0e,Q
	fcb	N+$15,N+$10,$0d,Q
	fcb	N+$14,N+$10,$0b,Q

	fcb	N+$15,N+$11,$0c,E
	fcb	N+$15,N+$11,$0c,S
	fcb	N+$13,N+$13,$13,S
	fcb	N+$15,N+$15,$15,S
	fcb	N+$13,N+$13,$13,S
	fcb	N+$15,N+$15,$15,S
	fcb	N+$13,N+$13,$13,S
	fcb	N+$15,N+$11,$0c,E
	fcb	N+$15,N+$11,$0c,Q
	fcb	N+$15,N+$15,$15,S
	fcb	N+$18,N+$18,$18,S

	fcb	N+$17,N+$13,$0e,E
	fcb	N+$17,N+$13,$0e,E
	fcb	N+$17,N+$13,$0e,S
	fcb	N+$15,N+$15,$15,S
	fcb	N+$13,N+$13,$13,E
	fcb	N+$13,N+$10,$0c,E+S
	fcb	N+$11,N+$11,$11,S
	fcb	N+$10,N+$0c,$0c,E
	fcb	N+$13,N+$13,$13,E

	fcb	N+$15,N+$11,$0c,E
	fcb	N+$15,N+$11,$0c,S
	fcb	N+$13,N+$13,$13,S
	fcb	N+$15,N+$15,$15,S
	fcb	N+$13,N+$13,$13,S
	fcb	N+$15,N+$15,$15,S
	fcb	N+$13,N+$13,$13,S
	fcb	N+$15,N+$11,$0c,E
	fcb	N+$15,N+$11,$0c,E
	fcb	N+$15,N+$15,$15,S
	fcb	N+$15,N+$15,$15,S
	fcb	N+$15,N+$15,$15,S
	fcb	N+$18,N+$18,$18,S

	fcb	N+$17,N+$13,$0e,E
	fcb	N+$17,N+$13,$0e,E
	fcb	N+$17,N+$0e,$0e,S
	fcb	N+$15,N+$15,$15,S
	fcb	N+$13,N+$13,$13,E
	fcb	N+$13,N+$10,$0c,E+S
	fcb	N+$15,N+$15,$15,S
	fcb	N+$18,N+$13,$10,E
	fcb	N+$18,N+$13,$10,E

	fcb	N+$15,N+$11,$0c,E
	fcb	N+$15,N+$11,$0c,E
	fcb	N+$15,N+$10,$0c,E
	fcb	N+$15,N+$10,$0c,E
	fcb	N+$15,N+$11,$0c,E
	fcb	N+$15,N+$11,$0c,E
	fcb	N+$15,N+$10,$10,E
	fcb	N+$18,N+$13,$10,E

	fcb	N+$17,N+$13,$0e,E
	fcb	N+$17,N+$13,$0e,E
	fcb	N+$17,N+$17,$17,S
	fcb	N+$15,N+$15,$15,S
	fcb	N+$13,N+$13,$13,S
	fcb	N+$13,N+$10,$0c,E+S
	fcb	N+$11,N+$11,$11,S
	fcb	N+$10,N+$0c,$0c,Q+E

	fcb	N+$15,N+$12,$0e,E
	fcb	N+$15,N+$12,$0e,E
	fcb	N+$14,N+$12,$0e,E
	fcb	N+$15,N+$12,$0e,E
	fcb	N+$15,N+$12,$0e,Q
	fcb	N+$15,N+$12,$0e,E

	fcb	N+$19,N+$15,$12,Q
	fcb	N+$1a,N+$15,$12,Q
	fcb	N+$19,N+$15,$12,Q
	fcb	N+$17,N+$12,$0e,Q

	fcb	N+$17,N+$12,$0f,E
	fcb	N+$17,N+$12,$0f,Q
	fcb	N+$19,N+$19,$19,S
	fcb	N+$1b,N+$17,$12,E
	fcb	N+$17,N+$12,$12,E
	fcb	N+$14,N+$14,$14,E
	fcb	N+$12,N+$12,$12,E

	fcb	N+$17,N+$14,$10,E
	fcb	N+$17,N+$14,$10,Q
	fcb	N+$19,N+$19,$19,E
	fcb	N+$1b,N+$16,$12,S
	fcb	N+$1b,N+$1b,$1b,S
	fcb	N+$17,N+$17,$17,E
	fcb	N+$19,N+$16,$12,E
	fcb	N+$1b,N+$1b,$1b,E

	fcb	N+$17,N+$12,$0f,E
	fcb	N+$17,N+$12,$0f,Q
	fcb	N+$19,N+$19,$19,E
	fcb	N+$1b,N+$12,$12,S
	fcb	N+$1b,N+$1b,$1b,S
	fcb	N+$17,N+$17,$17,E
	fcb	N+$14,N+$0b,$0b,E
	fcb	N+$12,N+$12,$12,E

	fcb	N+$17,N+$14,$10,E
	fcb	N+$17,N+$14,$10,Q
	fcb	N+$19,N+$19,$19,E
	fcb	N+$1b,N+$16,$12,S
	fcb	N+$1b,N+$1b,$1b,S
	fcb	N+$17,N+$17,$17,E
	fcb	N+$19,N+$16,$12,E
	fcb	N+$1b,N+$1b,$1b,E

	fcb	N+$17,N+$12,$0f,E
	fcb	N+$17,N+$12,$0f,Q
	fcb	N+$19,N+$19,$19,E
	fcb	N+$1b,N+$12,$12,S
	fcb	N+$1b,N+$1b,$1b,S
	fcb	N+$17,N+$17,$17,E
	fcb	N+$14,N+$0b,$0b,E
	fcb	N+$12,N+$12,$12,E

	fcb	N+$17,N+$14,$10,E
	fcb	N+$17,N+$14,$10,Q
	fcb	N+$12,N+$12,$12,Q
	fcb	N+$1b,N+$16,$12,E
	fcb	N+$19,N+$12,$12,S
	fcb	N+$17,N+$17,$17,S
	fcb	N+$16,N+$16,$16,E

	fcb	N+$17,N+$17,$17,E
	fcb	N+$1e,N+$1b,$17,Q
	fcb	N+$1e,N+$1b,$17,Q
	fcb	N+$1e,N+$1b,$17,Q
	fcb	N+$20,N+$1c,$17,Q+E

	fcb	N+$1c,N+$17,$14,Q
	fcb	N+$17,N+$14,$10,E
	fcb	N+$1b,N+$1b,$1b,E
	fcb	N+$19,N+$12,$12,S
	fcb	N+$17,N+$17,$17,S
	fcb	N+$16,N+$16,$16,E

	fcb	N+$17,N+$17,$17,E
	fcb	N+$1e,N+$1b,$17,Q
	fcb	N+$1e,N+$1b,$17,Q
	fcb	N+$1e,N+$1b,$17,Q
	fcb	N+$20,N+$1c,$17,Q+E

	fcb	N+$17,N+$14,$10,H
	fcb	N+$17,N+$12,$0f,H
	fcb	N+$16,N+$12,$0d,H
	fcb	N+$17,N+$14,$10,50

	fcb	19,$80


Allentown	
	fdb	$fee8,$feb6
	
	fcb	$80+$18,$80+$15,$0c,E-3			;bar #1
	fcb	$80+$18,$15,E-3
	fcb	$80+$18,$15,E-3
	fcb	$80+$18,$15,E-3
	fcb	$80+$0c,$80+$18,$18,E-3
	fcb	128+15,128+23,$18,Q-3
	fcb	$80+$18,$80+$13,$0c,Q+E-6			;bar #2
	fcb	128+19,$18,E-3
	fcb	128+19,$18,E-3
	fcb	128+19,$18,E-3
	fcb	128+19,$18,E-3
	fcb	128+16,$18,E-3
	fcb	128+19,$18,E-3
	fcb	$80+$18,$80+$15,$0c,E+Q-6			;bar #3
	fcb	128+21,$18,E-3
	fcb	128+21,$18,E-3
	fcb	128+21,$18,E-3
	fcb	128+15,$80+$18,$18,E-3
	fcb	128+15,128+23,$18,Q-3
	fcb	$80+$18,$80+$13,$0c,Q+E-6			;bar #4
	fcb	128+19,$18,E-3
	fcb	128+19,$18,E-3
	fcb	128+19,$18,E-3
	fcb	128+19,$18,E-3
	fcb	128+16,$18,E-3
	fcb	128+19,$18,E-3
	fcb	$80+$18,$80+$15,$0c,E+Q-6			;bar #5
	fcb	128+21,$18,E-3
	fcb	128+21,$18,E-3
	fcb	128+21,$18,E-3
	fcb	128+15,$80+$18,$18,E-3
	fcb	128+15,128+23,$18,Q+2-3			;bar #6
	fcb	128+16,$80+$18,$18,E-3
	fcb	128+17,$80+$18,$18,Q-3
	fcb	128+16,$80+$18,$18,Q+E-6
	fcb	19,$80

Message_End
	fcc	"DAN LOVES BECKY"
	fcb	$80
	
Message1
	fcb	-8,70,80,-90
	fcc	"JUMP OVER"
	fcb	$80,0
Message2
	fcb	-8,70,80,6
	fcc	"ALL OF"
	fcb	$80,0
Message3
	fcb	-8,70,50,-90
	fcc	"THE BARRELS"
	fcb	$80,0
Message4
	fcb	-8,70,50,25
	fcc	"TO        "
	fcb	$80
	fcb	0
Message5
	fcb	-8,70,20,-90
	fcc	"SEE THE"
	fcb	$80
	fcb	0
Message6
	fcb	-8,70,20,-12
	fcc	"SECRET"
	fcb	$80
	fcb	0
Message7
	fcb	-8,70,-10,-90
	fcc	"MESSAGE"
	fcb	$80
	fcb	0
Message8
	fcb	-8,40,-40,-55
	fcc	"BARRELS"
	fcb	$80
	fcb	0
Message9
	fcb	-8,40,-40,-10
	fcc	"LEFT="
	fcb	$80
	fcb	0
Message10
	fcb	-8,40,-70,-70
	fcc	"BUTTON"
	fcb	$80
	fcb	0
Message11
	fcb	-8,40,-70,-30
	fcc	"3 TO  "
	fcb	$80
	fcb	0
Message12
	fcb	-8,40,-70,0
	fcc	"CONTINUE"
	fcb	$80
	fcb	0



Bottom_Floor
	fcb	2,$7F
	fcb	-76,-70			;-	
	fcb	0,70				;
	fcb	0,70				;
Barrel	
	fcb	3,$7F				;-
	fcb	-76,-70			;	
	fcb	15,0				;
	fcb	0,7				;Barrel on bottom floor
	fcb	-15,0				;
Second_Floor
	fcb	2,$7F				;
	fcb	-24,-70			;-(-31,-70)
	fcb	-6,70				;-
	fcb	-6,60				;
Third_Floor
	fcb	2,$7F				;-
	fcb	4,-60				;
	fcb	6,60				;
	fcb	6,70				;
Fourth_Floor
	fcb	2,$7F				;-
	fcb	54,-70			;
	fcb	0,65				;
	fcb	0,65				;
Top_Floor	
	fcb	1,$7F				;-
	fcb	94,-70			;
	fcb	0,50				;Top floor

Ladders
	fcb	94,-20			;-
	fcb	-40,0				;
	fcb	94,-30			;
	fcb	-40,0				;
	fcb	90,-30			;
	fcb	0,10				;
	fcb	80,-30			;
	fcb	0,10				;Ladder 4
	fcb	70,-20			;
	fcb	0,-10				;
	fcb	60,-30			;
	fcb	0,10				;-
			
	fcb	54,30				;-
	fcb	-42,0				;
	fcb	54,40				;
	fcb	-41,0				;
	fcb	50,30				;
	fcb	0,10				;
	fcb	40,30				;
	fcb	0,10				;Ladder 3
	fcb	30,30				;
	fcb	0,10				;
	fcb	20,30				;
	fcb	0,10				;
	;fcb	10,30				;
	;fcb	0,10				;-

	fcb	6,-30				;-
	fcb	-34,0				;
	fcb	7,-20				;
	fcb	-36,0				;
	fcb	0,-30				;
	fcb	0,10				;Ladder 2
	fcb	-10,-30			;
	fcb	0,10				;
	fcb	-20,-30			;
	fcb	0,10				;
	
	fcb	-76,50			;-
	fcb	41,0				;
	fcb	-76,40			;
	fcb	42,0				;
	fcb	-40,40			;
	fcb	0,10				;Ladder 1
	fcb	-50,40			;
	fcb	0,10				;
	fcb	-60,40			;
	fcb	0,10				;
	fcb	-70,40			;
	fcb	0,10				;-
	fcb	$80

Kong_Head
	fcb	4,$7f
	fcb	108,-55
	fcb	0,-7
	fcb	4,0
	fcb	0,7
	fcb	-4,0

Kong_Left
	fcb	22,$7f			;-
	fcb	94,-52			;
	fcb	0,-5
	fcb	3,0
	fcb	0,-8
	fcb	5,0
	fcb	0,2
	fcb	-3,0
	fcb	0,2
	fcb	6,0
	fcb	0,-5
	fcb	6,0
	fcb	0,2
	fcb	-4,0
	fcb	0,11
	fcb	-6,0
	fcb	0,-2
	fcb	4,0
	fcb	0,-2
	fcb	-6,0
	fcb	0,2
	fcb	-3,0
	fcb	0,3
	fcb	-2,0				;-

Kong_Right
	fcb	22,$7f			;-
	fcb	94,-61			;
	fcb	0,-5
	fcb	2,0
	fcb	0,3
	fcb	3,0
	fcb	0,2
	fcb	6,0
	fcb	0,-2
	fcb	-4,0
	fcb	0,-2
	fcb	6,0
	fcb	0,11
	fcb	4,0
	fcb	0,2
	fcb	-6,0
	fcb	0,-5
	fcb	-6,0
	fcb	0,2
	fcb	3,0
	fcb	0,2
	fcb	-5,0
	fcb	0,-8
	fcb	-3,0				;-

Girl_LegL
	fcb	98,-23
	fcb	2,$5f
	fcb	-5,0
	fcb	0,-2
	fcb	5,0
	
Girl_LegR
	fcb	98,-27
	fcb	2,$5f
	fcb	-5,0
	fcb	0,-2
	fcb	5,0

Girl_Body
	fcb	98,-21
	fcb	2,$5f
	fcb	0,-12
	fcb	10,6
	fcb	-10,6

Girl_Head
	fcb	106,-24
	fcb	3,$5f
	fcb	0,-4
	fcb	4,0
	fcb	0,4
	fcb	-4,0

Mario_Right_Leg_Up
	fcb	0,7,-2
	fcb	255,0,5
	fcb	255,-2,0
	fcb	255,0,-2
	fcb	255,-2,0
	fcb	255,0,2
	fcb	255,-8,0
	fcb	255,0,-6
	fcb	255,8,0
	fcb	255,0,2
	fcb	255,2,0
	fcb	255,0,-1
	fcb	255,2,0
	fcb	0,-7,2
	fcb	255,4,6
	fcb	0,-9,-7
	fcb	255,-3,0
	fcb	255,-2,-2
	fcb	255,-2,2
	fcb	255,0,2
	fcb	0,7,0
	fcb	255,-6,4
	fcb	255,3,3
	fcb	01

Mario_Right_Leg_Down
	fcb	0,7,-2
	fcb	255,0,5
	fcb	255,-2,0
	fcb	255,0,-2
	fcb	255,-2,0
	fcb	255,0,2
	fcb	255,-8,0
	fcb	255,0,-6
	fcb	255,8,0
	fcb	255,0,2
	fcb	255,2,0
	fcb	255,0,-1
	fcb	255,2,0
	fcb	0,-7,2
	fcb	255,0,7
	fcb	0,-5,-7
	fcb	255,-7,0
	fcb	255,0,4
	fcb	01

Mario_Left_Leg_Up
	fcb	0,7,2
	fcb	255,0,-5
	fcb	255,-2,0
	fcb	255,0,2
	fcb	255,-2,0
	fcb	255,0,-2
	fcb	255,-8,0
	fcb	255,0,6
	fcb	255,8,0
	fcb	255,0,-2
	fcb	255,2,0
	fcb	255,0,1
	fcb	255,2,0
	fcb	0,-7,-2
	fcb	255,4,-6
	fcb	0,-9,5
	fcb	255,-6,-4
	fcb	255,3,-3
	fcb	0,3,9
	fcb	255,-3,0
	fcb	255,-2,2
	fcb	255,-2,-2
	fcb	255,0,-2
	fcb	01

Mario_Left_Leg_Down
	fcb	0,7,2
	fcb	255,0,-5
	fcb	255,-2,0
	fcb	255,0,2
	fcb	255,-2,0
	fcb	255,0,-2
	fcb	255,-8,0
	fcb	255,0,6
	fcb	255,8,0
	fcb	255,0,-2
	fcb	255,2,0
	fcb	255,0,1
	fcb	255,2,0
	fcb	0,-7,-2
	fcb	255,0,-7
	fcb	0,-5,7
	fcb	255,-7,0
	fcb	255,0,-4
	fcb	01

Mario_Up_Leg_Up
	fcb	0,7,2
	fcb	255,0,-4
	fcb	255,-2,0
	fcb	255,0,1
	fcb	255,-2,0
	fcb	255,0,-2
	fcb	255,-8,0
	fcb	255,0,6
	fcb	255,8,0
	fcb	255,0,-2
	fcb	255,2,0
	fcb	255,0,1
	fcb	255,2,0
	fcb	0,-4,1
	fcb	255,-2,2
	fcb	255,2,2
	fcb	0,3,-13
	fcb	255,-3,3
	fcb	0,-8,2
	fcb	255,-7,0
	fcb	0,2,4
	fcb	255,2,0
	fcb	255,3,-2
	fcb	01

Mario_Up_Leg_Down
	fcb	0,7,2
	fcb	255,0,-4
	fcb	255,-2,0
	fcb	255,0,1
	fcb	255,-2,0
	fcb	255,0,-2
	fcb	255,-8,0
	fcb	255,0,6
	fcb	255,8,0
	fcb	255,0,-2
	fcb	255,2,0
	fcb	255,0,1
	fcb	255,2,0
	fcb	0,-4,1
	fcb	255,3,3
	fcb	0,-3,-9
	fcb	255,-2,-2
	fcb	255,2,-2
	fcb	0,-8,6
	fcb	255,-3,-2
	fcb	255,-2,0
	fcb	0,5,4
	fcb	255,-7,0
	fcb	01

Mario_Legs_Jumping
	fcb	0,7,2
	fcb	255,0,-4
	fcb	255,-2,0
	fcb	255,0,1
	fcb	255,-2,0
	fcb	255,0,-2
	fcb	255,-8,0
	fcb	255,0,6
	fcb	255,8,0
	fcb	255,0,-2
	fcb	255,2,0
	fcb	255,0,1
	fcb	255,2,0
	fcb	0,-1,-8
	fcb	255,-3,3
	fcb	0,0,6
	fcb	255,3,3
	fcb	0,-9,1
	fcb	255,-2,0
	fcb	255,0,-4
	fcb	0,0,-6
	fcb	255,0,-4
	fcb	255,2,0
	fcb	01

EE	equ	10

Mario_Big_Legs_Jumping
	fcb	0,7*EE,2*EE
	fcb	255,0,-4*EE
	fcb	255,-2*EE,0
	fcb	255,0,1*EE
	fcb	255,-2*EE,0
	fcb	255,0,-2*EE
	fcb	255,-8*EE,0
	fcb	255,0,6*EE
	fcb	255,8*EE,0
	fcb	255,0,-2*EE
	fcb	255,2*EE,0
	fcb	255,0,1*EE
	fcb	255,2*EE,0
	fcb	0,-1*EE,-8*EE
	fcb	255,-3*EE,3*EE
	fcb	0,0,6*EE
	fcb	255,3*EE,3*EE
	fcb	0,-9*EE,1*EE
	fcb	255,-2*EE,0
	fcb	255,0,-4*EE
	fcb	0,0,-6*EE
	fcb	255,0,-4*EE
	fcb	255,2*EE,0
	fcb	01


Barrel_VL
	fcb	0,-5,-2
	fcb	255,0,4
	fcb	255,3,3
	fcb	255,4,0
	fcb	255,3,-3
	fcb	255,0,-4
	fcb	255,-3,-3
	fcb	255,-4,0
	fcb	255,-3,3
	fcb	01

Mario_Asterisks
	fcb	0,15,-1		;asterisk 1
	fcb	255,0,4
	fcb	0,2,0
	fcb	255,-4,-4
	fcb	0,0,2
	fcb	255,4,0
	fcb	0,0,-2
	fcb	255,-4,4
	fcb	0,-12,-19		;asterisk 2
	fcb	255,0,4
	fcb	0,2,0
	fcb	255,-4,-4
	fcb	0,0,2
	fcb	255,4,0
	fcb	0,0,-2
	fcb	255,-4,4
	fcb	0,-16,10		;asterisk 3
	fcb	255,0,4
	fcb	0,2,0
	fcb	255,-4,-4
	fcb	0,0,2
	fcb	255,4,0
	fcb	0,0,-2
	fcb	255,-4,4
	fcb	0,16,13		;asterisk 4
	fcb	255,0,4
	fcb	0,2,0
	fcb	255,-4,-4
	fcb	0,0,2
	fcb	255,4,0
	fcb	0,0,-2
	fcb	255,-4,4
	fcb	01

Fireball
	fcb	0,2,-2
	fcb	255,-4,4
	fcb	0,4,0
	fcb	255,-4,-4
	fcb	1

Broken_Heart
	fcb	255,11*EE,-6*EE
	fcb	255,4*EE,0
	fcb	255,4*EE,4*EE
	fcb	255,0,2*EE
	fcb	255,-1*EE,1*EE
	fcb	255,-1*EE,-1*EE
	fcb	255,-1*EE,1*EE
	fcb	255,-1*EE,-1*EE
	fcb	255,-1*EE,1*EE
	fcb	255,2*EE,2*EE
	fcb	255,1*EE,-1*EE
	fcb	255,2*EE,2*EE
	fcb	255,0,2*EE
	fcb	255,-4*EE,3*EE
	fcb	255,-4*EE,0
	fcb	255,-11*EE,-9*EE
	fcb	01

Heart
	fcb	255,11*EE,-8*EE
	fcb	255,4*EE,0
	fcb	255,4*EE,4*EE
	fcb	255,0,2*EE
	fcb	255,-5*EE,2*EE
	fcb	255,5*EE,2*EE
	fcb	255,0,2*EE
	fcb	255,-4*EE,4*EE
	fcb	255,-4*EE,0
	fcb	255,-11*EE,-8*EE
	fcb	01

Mario_Left_Leg_Down_End
	fcb	0,7*EE,2*EE
	fcb	255,0,-5*EE
	fcb	255,-2*EE,0
	fcb	255,0,2*EE
	fcb	255,-2*EE,0
	fcb	255,0,-2*EE
	fcb	255,-8*EE,0
	fcb	255,0,6*EE
	fcb	255,8*EE,0
	fcb	255,0,-2*EE
	fcb	255,2*EE,0
	fcb	255,0,1*EE
	fcb	255,2*EE,0
	fcb	0,-7*EE,-2*EE
	fcb	255,0,-7*EE
	fcb	0,-5*EE,7*EE
	fcb	255,-7*EE,0
	fcb	255,0,-4*EE
	fcb	01

Girl_End
	fcb	0,8*EE,-2*EE
	fcb	255,0,4*EE
	fcb	255,-3*EE,0
	fcb	255,0,-4*EE
	fcb	255,3*EE,0
	fcb	0,-3*EE,2*EE
	fcb	255,-10*EE,-6*EE
	fcb	255,0,12*EE
	fcb	255,10*EE,-6*EE
	fcb	0,-10*EE,-1*EE
	fcb	255,-5*EE,0
	fcb	255,0,-2*EE
	fcb	255,5*EE,0
	fcb	0,0,4*EE
	fcb	255,-5*EE,0
	fcb	255,0,2*EE
	fcb	255,5*EE,0
	fcb	01

DD	equ	4

Star
	fcb	0,7*DD,0
	fcb	255,-14*DD,5*DD
	fcb	255,9*DD,-12*DD
	fcb	255,0,14*DD
	fcb	255,-9*DD,-12*DD
	fcb	255,14*DD,5*DD
	fcb	01

Koko_End
	fcb	40
	fcb	255,2*DD,1*DD
	fcb	255,0,-2*DD
	fcb	255,-2*DD,1*DD
	fcb	255,-1*DD,0
	fcb	255,-1*DD,-1*DD
	fcb	255,0,-1*DD
	fcb	255,1*DD,-1*DD
	fcb	0,0,3*DD
	fcb	255,-1*DD,1*DD
	fcb	255,0,1*DD
	fcb	255,1*DD,1*DD
	fcb	0,3*DD,1*DD
	fcb	255,-5*DD,0
	fcb	255,-1*DD,1*DD
	fcb	255,0,1*DD
	fcb	255,2*DD,2*DD
	fcb	255,6*DD,0
	fcb	255,4*DD,-4*DD
	fcb	255,0,-8*DD
	fcb	255,-4*DD,-4*DD
	fcb	255,-6*DD,0
	fcb	255,-2*DD,2*DD
	fcb	255,0,1*DD
	fcb	255,1*DD,1*DD
	fcb	255,5*DD,0
	fcb	0,2*DD,0
	fcb	255,1*DD,0
	fcb	255,1*DD,1*DD
	fcb	255,0,1*DD
	fcb	255,-1*DD,1*DD
	fcb	255,-1*DD,0
	fcb	255,-1*DD,-1*DD
	fcb	255,0,-1*DD
	fcb	255,1*DD,-1*DD
	fcb	0,0,5*DD
	fcb	255,1*DD,0
	fcb	255,1*DD,1*DD
	fcb	255,0,1*DD
	fcb	255,-1*DD,1*DD
	fcb	255,-1*DD,0
	fcb	255,-1*DD,-1*DD
	fcb	255,0,-1*DD
	fcb	255,1*DD,-1*DD
	fcb	01

Barrel_Ladders_Right
	fcb	0,0,45,-25,35
	fcb	0,0,0,0,0


MUSIC
	fdb	$fee8
	fdb	$feb6
	fcb	$0,$80
	fcb	$0,$80

Sound_Jump_Init
	fcb	13,13,13,56
	
Sound_Mario_Jump
	fcb	1,$80,2,$60,2,$70,2,0
	fcb	2,$80,1,$60,1,$70,1,0
	fcb	1,$80,2,$60,2,$70,2,0
	fcb	2,$80,1,$60,1,$70,1,0
	fcb	$ff

Sound_Run_Init
	fcb	8,10,10,53

Mario_Sound_Run
	fcb	1,0,0,$90,1,0,0,10
	fcb	1,0,0,$60,1,0,0,0
	fcb	$ff

Sound_Barrel_Init
	fcb	13,0,0,62
	
Sound_Jump_Barrel
	fcb	2,$2f,1,0,0,0,0,0
	fcb	1,0,0,0,0,0,0,0
	fcb	2,$08,1,0,0,0,0,0
	fcb	1,0,0,0,0,0,0,0
	fcb	4,$90,0,0,0,0,0,0
	fcb	2,$08,1,0,0,0,0,0
	fcb	$ff

Sound_Crash_Init
	fcb	13,13,13,56

Sound_Crash
	fcb	10,$13,1,$0a,1,0,0,0
	fcb	10,$16,1,$1f,1,0,0,0
	fcb	10,$22,1,$2b,1,0,0,0
	fcb	10,$2e,1,$37,1,0,0,0
	fcb	$ff

Sound_Fireball_Init
	fcb	12,13,13,46

Sound_Fireball
	fcb	3,$10,1,0,0,0,0,30
	fcb	1,0,0,0,0,0,0,28
	fcb	3,$10,1,0,0,0,0,26
	fcb	1,0,0,0,0,0,0,24
	fcb	3,$10,1,0,0,0,0,22
	fcb	1,0,0,0,0,0,0,20
	fcb	3,$10,1,0,0,0,0,18
	fcb	1,0,0,0,0,0,0,16
	fcb	3,$10,1,0,0,0,0,14
	fcb	1,0,0,0,0,0,0,12
	fcb	3,$10,1,0,0,0,0,10
	fcb	1,0,0,0,0,0,0,8
	fcb	3,$10,1,0,0,0,0,6
	fcb	1,0,0,0,0,0,0,4
	fcb	3,$10,1,0,0,0,0,2
	fcb	$ff

Sound_Kong_Scale_Down_Init
	fcb	14,14,14,56

Sound_Kong_Scale_Down_Play
	fcb	10,$10,1,$d0,2,$1a,2,0
	fcb	10,$15,1,$c0,2,0,0,0
	fcb	10,$30,1,$b0,2,$1a,2,0
	fcb	10,$40,1,$a0,2,0,0,0
	fcb	10,$50,1,$90,2,$1a,2,0
	fcb	10,$60,1,$80,2,0,0,0
	fcb	10,$70,1,$70,2,$1a,2,0
	fcb	10,$80,1,$60,2,0,0,0
	fcb	10,$90,1,$50,2,$1a,2,0
	fcb	10,$a0,1,$40,2,0,0,0
	fcb	10,$b0,1,$30,2,$1a,2,0
	fcb	10,$c0,1,$20,2,0,0,0
	fcb	10,$d0,1,$10,2,$1a,2,0
	fcb	$ff

Broken_Heart_Init
	fcb	14,14,14,56

Broken_Heart_Play
	fcb	200,$2a,2,$30,2,$3a,2,0
	fcb	200,$2a,2,$30,2,$3a,2,0
	fcb	200,$2a,2,$30,2,$3a,2,0
	fcb	$ff

Fifteen_Barrels_Init
	fcb	14,14,14,56
	
Fifteen_Barrels_Play
	fcb	2,$1a,1,$1c,1,$20,1,0
	fcb	1,0,0,0,0,0,0,0
	fcb	2,$10,1,$12,1,$1e,1,0
	fcb	1,0,0,0,0,0,0,0
	fcb	50,$0a,1,$0c,1,$10,1,0
	fcb	$ff

;----------------------------------

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
	clra
	clrb
	jsr	Moveto_d_7F
	ldu	#Str_y
	jsr	Print_Str_yx
	;dec	counter
	;lda	counter
	;cmpa	#$00
	;bne	Repeat_Print
	;clra
	;sta	counter
	rts
