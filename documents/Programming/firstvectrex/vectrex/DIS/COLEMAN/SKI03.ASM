; ***  Spike goes Skiing ***
; v0.03a

; This source code is copyright Andrew Coleman 

; This whole thing is Freeware.

; You can play around with it, steal bits of it, do whatever you want with it really,
; but please DO NOT distribute any modified versions of this source without my permission.

; Big thanks go out to Malban, without his programming docs i'd never have gotten
; this far.

;***************************************************************************
; DEFINE SECTION
;***************************************************************************
                INCLUDE "VECTREX.I"

; user variables

user_ram   	EQU     $C880
spike_pos_y  	EQU     user_ram
spike_pos_x  	EQU     spike_pos_y+1
obj_1_state	EQU	spike_pos_x+1
obj_1_y		EQU	obj_1_state+1		; There are up to eight objects (trees or gates)
obj_1_x		EQU	obj_1_y+1		; that can be displayed on the playfield at
obj_2_state	EQU	obj_1_x+1		; any one time. obj_(n)_state contains either
obj_2_y		EQU	obj_2_state+1		; 0 (if the object is disabled), -1 (if the 
obj_2_x		EQU	obj_2_y+1		; object is a tree) or 1 (if the object is a
obj_3_state	EQU	obj_2_x+1		; gate)
obj_3_y		EQU	obj_3_state+1
obj_3_x		EQU	obj_3_y+1		; obj_(n)_x and obj_(n)_y hold the objects
obj_4_state	EQU	obj_3_x+1		; current coordinates
obj_4_y		EQU	obj_4_state+1
obj_4_x		EQU	obj_4_y+1
obj_5_state	EQU	obj_4_x+1
obj_5_y		EQU	obj_5_state+1
obj_5_x		EQU	obj_5_y+1
obj_6_state	EQU	obj_5_x+1
obj_6_y		EQU	obj_6_state+1
obj_6_x		EQU	obj_6_y+1
obj_7_state	EQU	obj_6_x+1
obj_7_y		EQU	obj_7_state+1
obj_7_x		EQU	obj_7_y+1
obj_8_state	EQU	obj_7_x+1
obj_8_y		EQU	obj_8_state+1
obj_8_x		EQU	obj_8_y+1
lives		EQU	obj_8_x+1
dead		EQU	lives+1
level		EQU	dead+1
score		EQU	level+1
flag_dist	EQU	score+1
level_type	EQU	flag_dist+1
temp		EQU	level_type+1

; start of vectrex memory with cartridge name...
                ORG     0

;***************************************************************************
; HEADER SECTION
;***************************************************************************
                DB      "g GCE 1998", $80       ; 'g' is copyright sign
                DW      music5                  ; music from the rom
                DB      $F8, $50, $20, -$66     ; height, width, rel y, rel x
                                                ; (from 0,0)
                DB      "SPIKE GOES SKIING",$80 ; some game information,
                                                ; ending with $80
                DB      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
	
main:
		LDA	#1			; Enable X axis on joystick 1
		STA	Vec_Joy_Mux_1_X		
		LDA	#0
		STA	Vec_Joy_Mux_1_Y		; Disable Y axis on joystick 1
		STA	Vec_Joy_Mux_2_X		; Disable Joystick 2
		STA	Vec_Joy_Mux_2_Y
	
		JSR	Read_Btns
title_screen:		
		JSR     Wait_Recal              ; Vectrex BIOS recalibration
                JSR     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
                LDU     #title_string		; address of string
                LDA     #$10                    ; Text position relative Y
                LDB     #-$50                   ; Text position relative X
                JSR     Print_Str_d             ; Vectrex BIOS print routine
                JSR	Read_Btns
		CMPA	#$00			; If a button is pressed then
		BNE	start_game		; start the game
		BRA     title_screen
                   
start_game:
		LDA 	#0			; Initialise general variables
		STA	score
		LDA	#5
		STA	lives
		LDA	#1
		STA	level

start_level:
		LDA	#100
		STA	spike_pos_y		; set the co-ordiates for spike
		LDA	#0			; at 100,0
		STA	spike_pos_x		
		
		
		LDA	#-1
		STA	obj_1_state
		JSR	Random_3
		STA	obj_1_x
		LDA	#-128	
		STA	obj_1_y		

		LDA	#0
		STA	obj_2_state
		JSR	Random_3
		STA	obj_2_x
		LDA	#-96	
		STA	obj_2_y

		LDA	#1
		STA	obj_3_state
		JSR	Random_3
		STA	obj_3_x
		LDA	#-64	
		STA	obj_3_y	

		LDA	#-1
		STA	obj_4_state
		JSR	Random_3
		STA	obj_4_x
		LDA	#-32	
		STA	obj_4_y	

		LDA	#-1
		STA	obj_5_state
		JSR	Random_3
		STA	obj_5_x
		LDA	#0	
		STA	obj_5_y	

		LDA	#1
		STA	obj_6_state
		JSR	Random_3
		STA	obj_6_x
		LDA	#32	
		STA	obj_6_y		

		LDA	#-1
		STA	obj_7_state
		JSR	Random_3
		STA	obj_7_x
		LDA	#64	
		STA	obj_7_y

		LDA	#1
		STA	obj_8_state
		JSR	Random_3
		STA	obj_8_x
		LDA	#96	
		STA	obj_8_y										
skiing:
                JSR     Wait_Recal              ; Vectrex BIOS recalibration
		
		                
		JSR	Joy_Digital		; Read joystick positions
read_x:
		LDA	Vec_Joy_1_X		; Load the x position of joystick 1 to A
		BEQ	no_direction		; If it's zero then jump to no_direction
		BMI	move_left		; If it's negative then the joystick is 
						; pushed left so jump to move_left otherwise
						; carry on to the move_right routine
move_right: 	
		LDA	spike_pos_x		; check if maximum x position has been
		CMPA	#127			; reached, if so jump to no_direction
		BEQ	no_direction
		INC	spike_pos_x		; add one to spike's x position
		LDX	#spike_r_vec_list	; load the address of the spike moving right
		BRA	draw_spike		; vector list to X reg and jump to draw_spike	
move_left:
		LDA	spike_pos_x		; check if minimum x value has been
		CMPA	#-127			; reached, if so jump to no_direction
		BEQ	no_direction			
		DEC	spike_pos_x		; subtract 1 from spike's x co-ordinate
		LDX	#spike_l_vec_list	; load the address of the spike moving left
		BRA	draw_spike		; vector list to X reg and jump to draw_spike
no_direction:
		LDX	#spike_vec_list		; if spike isn't moving sideways then load
						; the address of the normal spike vector
						; list to X reg
draw_spike:
		JSR     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
		LDA	#$80
		STA	VIA_t1_cnt_lo		; set scale factor to $80 
               
		LDA	spike_pos_y
		LDB	spike_pos_x
		JSR	Moveto_d		; move vector beam to co-ordinates for spike
          	JSR	Draw_VL_mode		; draw spike using the vector list address
						; selected in the joystick checking section

draw_obj_1:
		LDA	obj_1_state		; check if object 1 is turned on, if not
		BEQ	draw_obj_2		; jump to draw_obj_2

		JSR	Reset0Int		; reset the vector beam to 0,0
				
		LDA	obj_1_y			; move the vector beam to the coordinates
		LDB	obj_1_x			; for object 1
		JSR	Moveto_d
		
		LDA	obj_1_state		; if obj_1_state is less than 0 then jump to
		BMI	draw_tree_1		; draw_tree_1, otherwise carry on and draw a
						; gate
						
draw_gate_1:
		LDX	#flag_vec_list		; Load X with the address of flag_vec_list
		JSR	Draw_VLc		; and draw the first flag

		LDA	#9			; Move the vector beam to the right 20
		LDB	#30	
		JSR	Moveto_d

		LDX	#flag_vec_list		; Draw the second flag
		JSR	Draw_VLc	

		BRA	upd_xy_1		; Jump to update x,y for object 1

draw_tree_1:
		LDX	#tree_vec_list		; Load X with the address for tree_vec_list
		JSR	Draw_VLc		; and draw a tree

upd_xy_1:
		INC 	obj_1_y			; add 1 to the object's y position

		LDA	obj_1_y			; check to see if object's y position is
		CMPA	#-128 			; -128 (has looped back to the bottom of the 
		BNE	draw_obj_2		; screen). If it has then give it a new
		JSR	Random_3		; x coordinate.
		STA	obj_1_x

draw_obj_2:
		LDA	obj_2_state		; check if object is turned on, if not
		BEQ	draw_obj_3		; jump to draw_obj_3

		JSR	Reset0Int		; reset the vector beam to 0,0
				
		LDA	obj_2_y			; move the vector beam to the coordinates
		LDB	obj_2_x			; for object 2
		JSR	Moveto_d
		
		LDA	obj_2_state		; if obj_2_state is less than 0 then jump to
		BMI	draw_tree_2		; draw_tree_2, otherwise carry on and draw a
						; gate
						
draw_gate_2:
		LDX	#flag_vec_list		; Load X with the address of flag_vec_list
		JSR	Draw_VLc		; and draw the first flag

		LDA	#9			; Move the vector beam to the right 20
		LDB	#30	
		JSR	Moveto_d

		LDX	#flag_vec_list		; Draw the second flag
		JSR	Draw_VLc	

		BRA	upd_xy_2		; Jump to update x,y for object 2

draw_tree_2:
		LDX	#tree_vec_list		; Load X with the address for tree_vec_list
		JSR	Draw_VLc		; and draw a tree

upd_xy_2:
		INC 	obj_2_y			; add 1 to the object's y position

		LDA	obj_2_y			; check to see if object's y position is
		CMPA	#-128 			; -128 (has looped back to the bottom of the 
		BNE	draw_obj_3		; screen). If it has then give it a new
		JSR	Random_3		; x coordinate.
		STA	obj_2_x	

draw_obj_3:
		LDA	obj_3_state		; check if object is turned on, if not
		BEQ	draw_obj_4		; jump to draw_obj_4

		JSR	Reset0Int		; reset the vector beam to 0,0
				
		LDA	obj_3_y			; move the vector beam to the coordinates
		LDB	obj_3_x			; for object 3
		JSR	Moveto_d
		
		LDA	obj_3_state		; if obj_3_state is less than 0 then jump to
		BMI	draw_tree_3		; draw_tree_3, otherwise carry on and draw a
						; gate
						
draw_gate_3:
		LDX	#flag_vec_list		; Load X with the address of flag_vec_list
		JSR	Draw_VLc		; and draw the first flag

		LDA	#9			; Move the vector beam to the right 20
		LDB	#30	
		JSR	Moveto_d

		LDX	#flag_vec_list		; Draw the second flag
		JSR	Draw_VLc	

		BRA	upd_xy_3		; Jump to update x,y for object 3

draw_tree_3:
		LDX	#tree_vec_list		; Load X with the address for tree_vec_list
		JSR	Draw_VLc		; and draw a tree

upd_xy_3:
		INC 	obj_3_y			; add 1 to the object's y position

		LDA	obj_3_y			; check to see if object's y position is
		CMPA	#-128 			; -128 (has looped back to the bottom of the 
		BNE	draw_obj_4		; screen). If it has then give it a new
		JSR	Random_3		; x coordinate.
		STA	obj_3_x

draw_obj_4:
		LDA	obj_4_state		; check if object is turned on, if not
		BEQ	draw_obj_5		; jump to draw_obj_5

		JSR	Reset0Int		; reset the vector beam to 0,0
				
		LDA	obj_4_y			; move the vector beam to the coordinates
		LDB	obj_4_x			; for object 4
		JSR	Moveto_d
		
		LDA	obj_4_state		; if obj_4_state is less than 0 then jump to
		BMI	draw_tree_4		; draw_tree_4, otherwise carry on and draw a
						; gate
						
draw_gate_4:
		LDX	#flag_vec_list		; Load X with the address of flag_vec_list
		JSR	Draw_VLc		; and draw the first flag

		LDA	#9			; Move the vector beam to the right 20
		LDB	#30	
		JSR	Moveto_d

		LDX	#flag_vec_list		; Draw the second flag
		JSR	Draw_VLc	

		BRA	upd_xy_4		; Jump to update x,y for object 4

draw_tree_4:
		LDX	#tree_vec_list		; Load X with the address for tree_vec_list
		JSR	Draw_VLc		; and draw a tree

upd_xy_4:
		INC 	obj_4_y			; add 1 to the object's y position

		LDA	obj_4_y			; check to see if object's y position is
		CMPA	#-128 			; -128 (has looped back to the bottom of the 
		BNE	draw_obj_5		; screen). If it has then give it a new
		JSR	Random_3		; x coordinate.
		STA	obj_4_x

draw_obj_5:
		LDA	obj_5_state		; check if object is turned on, if not
		BEQ	draw_obj_6		; jump to draw_obj_6

		JSR	Reset0Int		; reset the vector beam to 0,0
				
		LDA	obj_5_y			; move the vector beam to the coordinates
		LDB	obj_5_x			; for object 5
		JSR	Moveto_d
		
		LDA	obj_5_state		; if obj_5_state is less than 0 then jump to
		BMI	draw_tree_5		; draw_tree_5, otherwise carry on and draw a
						; gate
						
draw_gate_5:
		LDX	#flag_vec_list		; Load X with the address of flag_vec_list
		JSR	Draw_VLc		; and draw the first flag

		LDA	#9			; Move the vector beam to the right 20
		LDB	#30	
		JSR	Moveto_d

		LDX	#flag_vec_list		; Draw the second flag
		JSR	Draw_VLc	

		BRA	upd_xy_5		; Jump to update x,y for object 1

draw_tree_5:
		LDX	#tree_vec_list		; Load X with the address for tree_vec_list
		JSR	Draw_VLc		; and draw a tree

upd_xy_5:
		INC 	obj_5_y			; add 1 to the object's y position

		LDA	obj_5_y			; check to see if object's y position is
		CMPA	#-128 			; -128 (has looped back to the bottom of the 
		BNE	draw_obj_6		; screen). If it has then give it a new
		JSR	Random_3		; x coordinate.
		STA	obj_5_x

draw_obj_6:
		LDA	obj_6_state		; check if object is turned on, if not
		BEQ	draw_obj_7		; jump to draw_obj_7

		JSR	Reset0Int		; reset the vector beam to 0,0
				
		LDA	obj_6_y			; move the vector beam to the coordinates
		LDB	obj_6_x			; for object 6
		JSR	Moveto_d
		
		LDA	obj_6_state		; if obj_6_state is less than 0 then jump to
		BMI	draw_tree_6		; draw_tree_6, otherwise carry on and draw a
						; gate
						
draw_gate_6:
		LDX	#flag_vec_list		; Load X with the address of flag_vec_list
		JSR	Draw_VLc		; and draw the first flag

		LDA	#9			; Move the vector beam to the right 20
		LDB	#30	
		JSR	Moveto_d

		LDX	#flag_vec_list		; Draw the second flag
		JSR	Draw_VLc	

		BRA	upd_xy_6		; Jump to update x,y for object 6

draw_tree_6:
		LDX	#tree_vec_list		; Load X with the address for tree_vec_list
		JSR	Draw_VLc		; and draw a tree

upd_xy_6:
		INC 	obj_6_y			; add 1 to the object's y position

		LDA	obj_6_y			; check to see if object's y position is
		CMPA	#-128 			; -128 (has looped back to the bottom of the 
		BNE	draw_obj_7		; screen). If it has then give it a new
		JSR	Random_3		; x coordinate.
		STA	obj_6_x	

draw_obj_7:
		LDA	obj_7_state		; check if object is turned on, if not
		BEQ	draw_obj_8		; jump to draw_obj_8

		JSR	Reset0Int		; reset the vector beam to 0,0
				
		LDA	obj_7_y			; move the vector beam to the coordinates
		LDB	obj_7_x			; for object 7
		JSR	Moveto_d
		
		LDA	obj_7_state		; if obj_7_state is less than 0 then jump to
		BMI	draw_tree_7		; draw_tree_7, otherwise carry on and draw a
						; gate
						
draw_gate_7:
		LDX	#flag_vec_list		; Load X with the address of flag_vec_list
		JSR	Draw_VLc		; and draw the first flag

		LDA	#9			; Move the vector beam to the right 20
		LDB	#30	
		JSR	Moveto_d

		LDX	#flag_vec_list		; Draw the second flag
		JSR	Draw_VLc	

		BRA	upd_xy_7		; Jump to update x,y for object 7

draw_tree_7:
		LDX	#tree_vec_list		; Load X with the address for tree_vec_list
		JSR	Draw_VLc		; and draw a tree

upd_xy_7:
		INC 	obj_7_y			; add 1 to the object's y position

		LDA	obj_7_y			; check to see if object's y position is
		CMPA	#-128 			; -128 (has looped back to the bottom of the 
		BNE	draw_obj_8		; screen). If it has then give it a new
		JSR	Random_3		; x coordinate.
		STA	obj_7_x

draw_obj_8:
		LDA	obj_8_state		; check if object is turned on, if not
		BEQ	check_coll_1		; jump to check_coll_1

		JSR	Reset0Int		; reset the vector beam to 0,0
				
		LDA	obj_8_y			; move the vector beam to the coordinates
		LDB	obj_8_x			; for object 8
		JSR	Moveto_d
		
		LDA	obj_8_state		; if obj_8_state is less than 0 then jump to
		BMI	draw_tree_8		; draw_tree_8, otherwise carry on and draw a
						; gate
						
draw_gate_8:
		LDX	#flag_vec_list		; Load X with the address of flag_vec_list
		JSR	Draw_VLc		; and draw the first flag

		LDA	#9			; Move the vector beam to the right 20
		LDB	#30	
		JSR	Moveto_d

		LDX	#flag_vec_list		; Draw the second flag
		JSR	Draw_VLc	

		BRA	upd_xy_8		; Jump to update x,y for object 8

draw_tree_8:
		LDX	#tree_vec_list		; Load X with the address for tree_vec_list
		JSR	Draw_VLc		; and draw a tree

upd_xy_8:
		INC 	obj_8_y			; add 1 to the object's y position

		LDA	obj_8_y			; check to see if object's y position is
		CMPA	#-128 			; -128 (has looped back to the bottom of the 
		BNE	check_coll_1		; screen). If it has then give it a new
		JSR	Random_3		; x coordinate.
		STA	obj_8_x

check_coll_1:
		LDA	obj_1_state		; Check to see if object 1 us a tree
		BMI	coll_tree_1		; if it is then jump to coll_tree_1
		BRA	check_coll_2		
coll_tree_1:
		LDA	spike_pos_y		; Check to see if object 1's y coordinate		
		ADDA	#20			; is near spike's
		STA	temp
		LDA	obj_1_y
		CMPA	temp
		BGT	check_coll_2
		LDA 	spike_pos_y		
		SUBA	#10
		STA	temp
		LDA	obj_1_y
		CMPA	temp
		BLT	check_coll_2
		LDA	spike_pos_x		; Check to see if object 1's x coordinate		
		ADDA	#14			; is near spike's
		STA	temp
		LDA	obj_1_x
		CMPA	temp
		BGT	check_coll_2
		LDA 	spike_pos_x		
		SUBA	#8
		STA	temp
		LDA	obj_1_x
		CMPA	temp
		BLT	check_coll_2
		JSR	Reset0Int
		LDU	#hit_string
		LDA	#0
		LDB	#0
		JSR	Print_Str_d
check_coll_2:
		
		LDA	obj_2_state		; Check to see if object 2 us a tree
		BMI	coll_tree_2		; if it is then jump to coll_tree_2
		BRA	check_coll_3		
coll_tree_2:
		LDA	spike_pos_y		; Check to see if object 2's y coordinate		
		ADDA	#20			; is near spike's
		STA	temp
		LDA	obj_2_y
		CMPA	temp
		BGT	check_coll_3
		LDA 	spike_pos_y		
		SUBA	#10
		STA	temp
		LDA	obj_2_y
		CMPA	temp
		BLT	check_coll_3
		LDA	spike_pos_x		; Check to see if object 2's x coordinate		
		ADDA	#14			; is near spike's
		STA	temp
		LDA	obj_2_x
		CMPA	temp
		BGT	check_coll_3
		LDA 	spike_pos_x		
		SUBA	#8
		STA	temp
		LDA	obj_2_x
		CMPA	temp
		BLT	check_coll_3
		JSR	Reset0Int
		LDU	#hit_string
		LDA	#0
		LDB	#0
		JSR	Print_Str_d
check_coll_3:
		LDA	obj_3_state		; Check to see if object 3 us a tree
		BMI	coll_tree_3		; if it is then jump to coll_tree_3
		BRA	check_coll_4		
coll_tree_3:
		LDA	spike_pos_y		; Check to see if object 3's y coordinate		
		ADDA	#20			; is near spike's
		STA	temp
		LDA	obj_3_y
		CMPA	temp
		BGT	check_coll_4
		LDA 	spike_pos_y		
		SUBA	#10
		STA	temp
		LDA	obj_3_y
		CMPA	temp
		BLT	check_coll_4
		LDA	spike_pos_x		; Check to see if object 3's x coordinate		
		ADDA	#14			; is near spike's
		STA	temp
		LDA	obj_3_x
		CMPA	temp
		BGT	check_coll_4
		LDA 	spike_pos_x		
		SUBA	#8
		STA	temp
		LDA	obj_3_x
		CMPA	temp
		BLT	check_coll_4
		JSR	Reset0Int
		LDU	#hit_string
		LDA	#0
		LDB	#0
		JSR	Print_Str_d
check_coll_4:
		LDA	obj_4_state		; Check to see if object 4 us a tree
		BMI	coll_tree_4		; if it is then jump to coll_tree_4
		BRA	check_coll_5		
coll_tree_4:
		LDA	spike_pos_y		; Check to see if object 4's y coordinate		
		ADDA	#20			; is near spike's
		STA	temp
		LDA	obj_4_y
		CMPA	temp
		BGT	check_coll_5
		LDA 	spike_pos_y		
		SUBA	#10
		STA	temp
		LDA	obj_4_y
		CMPA	temp
		BLT	check_coll_5
		LDA	spike_pos_x		; Check to see if object 4's x coordinate		
		ADDA	#14			; is near spike's
		STA	temp
		LDA	obj_4_x
		CMPA	temp
		BGT	check_coll_5
		LDA 	spike_pos_x		
		SUBA	#8
		STA	temp
		LDA	obj_4_x
		CMPA	temp
		BLT	check_coll_5
		JSR	Reset0Int
		LDU	#hit_string
		LDA	#0
		LDB	#0
		JSR	Print_Str_d
check_coll_5:
		LDA	obj_5_state		; Check to see if object 5 us a tree
		BMI	coll_tree_5		; if it is then jump to coll_tree_5
		BRA	check_coll_6		
coll_tree_5:
		LDA	spike_pos_y		; Check to see if object 5's y coordinate		
		ADDA	#20			; is near spike's
		STA	temp
		LDA	obj_5_y
		CMPA	temp
		BGT	check_coll_6
		LDA 	spike_pos_y		
		SUBA	#10
		STA	temp
		LDA	obj_5_y
		CMPA	temp
		BLT	check_coll_6
		LDA	spike_pos_x		; Check to see if object 5's x coordinate		
		ADDA	#14			; is near spike's
		STA	temp
		LDA	obj_5_x
		CMPA	temp
		BGT	check_coll_6
		LDA 	spike_pos_x		
		SUBA	#8
		STA	temp
		LDA	obj_5_x
		CMPA	temp
		BLT	check_coll_6
		JSR	Reset0Int
		LDU	#hit_string
		LDA	#0
		LDB	#0
		JSR	Print_Str_d
check_coll_6:
		LDA	obj_6_state		; Check to see if object 6 us a tree
		BMI	coll_tree_6		; if it is then jump to coll_tree_6
		BRA	check_coll_7		
coll_tree_6:
		LDA	spike_pos_y		; Check to see if object 6's y coordinate		
		ADDA	#20			; is near spike's
		STA	temp
		LDA	obj_6_y
		CMPA	temp
		BGT	check_coll_7
		LDA 	spike_pos_y		
		SUBA	#10
		STA	temp
		LDA	obj_6_y
		CMPA	temp
		BLT	check_coll_7
		LDA	spike_pos_x		; Check to see if object 6's x coordinate		
		ADDA	#14			; is near spike's
		STA	temp
		LDA	obj_6_x
		CMPA	temp
		BGT	check_coll_7
		LDA 	spike_pos_x		
		SUBA	#8
		STA	temp
		LDA	obj_6_x
		CMPA	temp
		BLT	check_coll_7
		JSR	Reset0Int
		LDU	#hit_string
		LDA	#0
		LDB	#0
		JSR	Print_Str_d
check_coll_7:
		LDA	obj_7_state		; Check to see if object 7 us a tree
		BMI	coll_tree_7		; if it is then jump to coll_tree_7
		BRA	check_coll_8		
coll_tree_7:
		LDA	spike_pos_y		; Check to see if object 7's y coordinate		
		ADDA	#20			; is near spike's
		STA	temp
		LDA	obj_7_y
		CMPA	temp
		BGT	check_coll_8
		LDA 	spike_pos_y		
		SUBA	#10
		STA	temp
		LDA	obj_7_y
		CMPA	temp
		BLT	check_coll_8
		LDA	spike_pos_x		; Check to see if object 7's x coordinate		
		ADDA	#14			; is near spike's
		STA	temp
		LDA	obj_7_x
		CMPA	temp
		BGT	check_coll_8
		LDA 	spike_pos_x		
		SUBA	#8
		STA	temp
		LDA	obj_7_x
		CMPA	temp
		BLT	check_coll_8
		JSR	Reset0Int
		LDU	#hit_string
		LDA	#0
		LDB	#0
		JSR	Print_Str_d
check_coll_8:
		LDA	obj_8_state		; Check to see if object 8 us a tree
		BMI	coll_tree_8		; if it is then jump to coll_tree_8
		BRA	done_coll	
coll_tree_8:
		LDA	spike_pos_y		; Check to see if object 8's y coordinate		
		ADDA	#20			; is near spike's
		STA	temp
		LDA	obj_8_y
		CMPA	temp
		BGT	done_coll
		LDA 	spike_pos_y		
		SUBA	#10
		STA	temp
		LDA	obj_8_y
		CMPA	temp
		BLT	done_coll
		LDA	spike_pos_x		; Check to see if object 8's x coordinate		
		ADDA	#14			; is near spike's
		STA	temp
		LDA	obj_8_x
		CMPA	temp
		BGT	done_coll
		LDA 	spike_pos_x		
		SUBA	#8
		STA	temp
		LDA	obj_8_x
		CMPA	temp
		BLT	done_coll
		JSR	Reset0Int
		LDU	#hit_string
		LDA	#0
		LDB	#0
		JSR	Print_Str_d
done_coll:
		BRA     skiing                  ; and repeat forever

;***************************************************************************
; DATA SECTION
;***************************************************************************
spike_vec_list:
		DB	-1, 6, 4		; spike's body
		DB	-1, 1, 6
		DB	-1, 6,-4
		DB	-1, 6, 1
		DB	-1,-3,-7
		DB	-1, 3,-7
		DB	-1,-6, 1
		DB	-1,-6,-4
		DB	-1,-1, 6
		DB	-1,-6, 4 

		DB	 0, 7,-5		; spike's mouth
		DB	-1, 1, 1
		DB	-1, 1,-1
		DB	 0,-1, 1
		DB	-1,-2, 4
		DB	-1, 2, 4
		DB	-1,-1, 1
		DB	 0, 1,-1
		DB	-1, 1, 1

		DB	 0, 2,-3		; spike's eyes
		DB	-1, 1, 0
		DB	 0, 0,-4
		DB	-1,-1, 0

		DB	 0, -7,-3		; spike's legs and skis
		DB	-1,-10, 2
		DB	 0,  5,-1
		DB	-1,  4, 2
		DB	 0,  0, 4
		DB	-1, -4, 2
		DB	 0, -5,-1
		DB	-1, 10, 2
		DB	1

spike_r_vec_list:
		DB	-1, 6, 4		; spike's body
		DB	-1, 2, 5
		DB	-1, 5,-4
		DB	-1, 7, 1
		DB	-1,-4,-6
		DB	-1, 2,-6
		DB	-1,-6, 1
		DB	-1,-6,-4
		DB	-1, 0, 5
		DB	-1,-6, 4

		DB	 0, 7,-5		; spike's mouth
		DB	-1, 0 ,1
		DB	-1, 1, 0
		DB	 0,-1, 0
		DB	-1,-1, 5
		DB	-1, 3, 3
		DB	-1, 0, 1
		DB	 0, 0,-1
		DB	-1, 1, 0

		DB	 0, 2,-2		; spike's eyes
		DB	-1, 1, 0
		DB	 0,-1,-4
		DB	-1,-1, 0

		DB	 0,-8, 0		; spike's legs and skis
		DB	-1,-4,-2
		DB	 0, 3,-5
		DB	-1,-6,10
		DB	 0, 6, 0
		DB	-1,-7, 7
		DB	 0, 4,-4
		DB	-1, 4,-2
		DB	 1

spike_l_vec_list:
		DB	-1, 6,-4		; spike's body
		DB	-1, 2,-5
		DB	-1, 5, 4
		DB	-1, 7,-1
		DB	-1,-4, 6
		DB	-1, 2, 6
		DB	-1,-6,-1
		DB	-1,-6, 4
		DB	-1, 0,-5
		DB	-1,-6,-4

		DB	 0, 7, 5		; spike's mouth
		DB	-1, 0,-1
		DB	-1, 1, 0
		DB	 0,-1, 0
		DB	-1,-1,-5
		DB	-1, 3,-3
		DB	-1, 0,-1
		DB	 0, 0, 1
		DB	-1, 1, 0

		DB	 0, 2, 2		; spike's eyes
		DB	-1, 1, 0
		DB	 0,-1, 4
		DB	-1,-1, 0

		DB	 0,-8, 0		; spike's legs and skis
		DB	-1,-4, 2
		DB	 0, 3, 5
		DB	-1,-6,-10
		DB	 0, 6, 0
		DB	-1,-7,-7
		DB	 0, 4, 4
		DB	-1, 4, 2
		DB	 1

tree_vec_list:
		DB	19
		DB	-1, 3
		DB	 5,-3
		DB	-1, 2
		DB	 5,-3
		DB	-1, 2
		DB	 4,-3
		DB	-1, 2
		DB	 4,-3
		DB	-4,-3
		DB	 1, 2
		DB	-4,-3
		DB	 1, 2
		DB	-5,-3
		DB	 1, 2
		DB	-5,-3
		DB	 2, 6
		DB	-1, 3
		DB	-4, 0
		DB	 0,-6
		DB	 4, 0

flag_vec_list:
		DB	2
		DB	  3,-5
		DB	  3, 5
		DB	-15, 0

title_string:
		DB	"TITLE SCREEN"
		DB	$80

hit_string:
		DB	"HIT"
		DB	$80
;***************************************************************************
                END  main
;***************************************************************************
