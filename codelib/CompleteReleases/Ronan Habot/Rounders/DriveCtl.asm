;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Assumes Atari Driving Controller connected to Port #1
; When done, A contains the direction of the rotation
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
s_DrvCtrlr:
        JSR   Read_Btns      	       	;Get Buttons status
	LDA   $C80F			;Current buttons value
	ANDA  #$03			;Mask non-relevant bits
	LDB   $C810			;Previous buttons value

	ANDB  #$03			;Mask non-relevant bits
	ASLB				;Shift left 1st time
	ASLB				;Shift left 2nd time
	STB   TempBtns			;Store in temp RAM location
	ORA   TempBtns			;A - offset to l_DirTbl
	LDX   #l_DirTbl			;X - Pointer to l_DirTbl start
	LDA   A,X			;A = value to add to position index:
					;    -2 => Move right
					;     0 => No change
					;    +2 => Move left
	RTS

l_DirTbl:
	DB    0				;Loc#0 - no change
	DB   -2				;Loc#1
	DB    2				;Loc#2
	DB    0				;Loc#3
	DB    2				;Loc#4
	DB    0				;Loc#5
	DB    0				;Loc#6
	DB   -2				;Loc#7
	DB   -2				;Loc#8
	DB    0				;Loc#9
	DB    0				;Loc#10
	DB    2				;Loc#11
	DB    0				;Loc#12
	DB    2				;Loc#13
	DB   -2				;Loc#14
	DB    0				;Loc#15
