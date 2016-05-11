
	; This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/deed.en_US.

	;	
	; VECTREX SYSTEM CONSTANTS
	;

V_Buttons     EQU     $C811   ;Current toggle state of all buttons
V_Joy_1_X     EQU     $C81B   ;Joystick 1 left/right
V_Joy_1_Y     EQU     $C81C   ;Joystick 1 up/down
V_Joy_Mux_1_X EQU     $C81F   ;Joystick 1 X enable/mux flag (=1)
V_Joy_Mux_1_Y EQU     $C820   ;Joystick 1 Y enable/mux flag (=3)
V_Joy_Mux_2_X EQU     $C821   ;Joystick 2 X enable/mux flag (=5)
V_Joy_Mux_2_Y EQU     $C822   ;Joystick 2 Y enable/mux flag (=7)
V_Rfrsh       EQU     $C83D   ;Refresh time (divided by 1.5MHz)
V_Rfrsh_lo    EQU     $C83D   ;Refresh time low byte

VIA_t1_cnt_lo   EQU     $D004   ;VIA timer 1 count register lo (scale factor)

F_Wait_Recal      EQU     $F192
F_DP_to_D0        EQU     $F1AA
F_DP_to_C8        EQU     $F1AF
F_Read_Btns       EQU     $F1BA
F_Joy_Digital     EQU     $F1F8
F_Intensity_1F    EQU     $F29D
F_Intensity_3F    EQU     $F2A1
F_Intensity_5F    EQU     $F2A5
F_Intensity_7F    EQU     $F2A9
F_Intensity_a     EQU     $F2AB
F_Moveto_d_7F     EQU     $F2FC
F_Reset0Ref       EQU     $F354
F_Draw_VLp        EQU     $F410
F_Rot_VL_Mode_a   EQU     $F61F
	
	;
	; RAM USAGE
	;
	
v_player_ptr	EQU $c880 ; + $c881
v_wait			EQU $c882
v_wait2			EQU $c883
v_player_y		EQU $c884
v_player_x		EQU $c885
v_player_dir	EQU $c886
v_joy_wait		EQU $c887
v_level_ptr		EQU $c888 ; + $c889
v_can_push		EQU $c88a
v_rotate		EQU $c88b
v_rot_dir		EQU $c88c
v_temp_1		EQU $c88d
v_temp_2		EQU $c88e ; + $c88f


; the current level
v_level_ram		EQU $c900 ; - $c97f

; holds the rotated player
v_vector_temp	EQU $c980 ; (should be) 88 bytes

; holds the vector of the current level
v_level_vector	EQU $ca00 ; max. len 202 bytes

; uncompressed vectors
vec_start_dst EQU $cb00
t_target EQU $cb00
t_box EQU $cb28
t_box_on EQU $cb44
t_player EQU $cb69

	;
	; CONSTANTS
	;
	
; compressed level data
rFL EQU 0
rWL EQU 1
rTG EQU 2
rBX EQU 3

; level data
lFL EQU $00
lPLbase EQU $04
lPLn EQU $04
lPLe EQU $05
lPLs EQU $06
lPLw EQU $07
lPLall EQU $07
lBX EQU $08
lTG EQU $40
lWL EQU $80 | lBX

intens_level EQU $3f
intens_obj EQU $5f
intens_player EQU $7f

	;
	; macros
	;

ldab macro a, b
	ldd # (((a) & $ff) << 8) | ((b) & $ff)
	endm

intensity macro i
	if i = $1f
		jsr F_Intensity_1F
	elseif i = $3f
		jsr F_Intensity_3F
	elseif i = $5f
		jsr F_Intensity_5F
	elseif i = $7f
		jsr F_Intensity_7F
	else
		lda # i
		jsr F_Intensity_a
	endif
	endm

	;
	; START!
	;
	
	org $0000
	direct $d0

	;
	; rom header
	;
	
	db "g GCE 2013", $80
	dw d_no_music
	db $f8, $50, $20, -$56
	db "P1X3L PUSHR", $80
	db $f8, $50, $00, $08
	db "BY ALX", $80, $00
	
	;
	; init routine
	;

	; which joystick(s) to read
	lda #$01
	sta V_Joy_Mux_1_X
	lda #$03
	sta V_Joy_Mux_1_Y
	lda #$00
	sta V_Joy_Mux_2_X
	sta V_Joy_Mux_2_Y
	; joystick is ready
	sta v_joy_wait
	
	; set fram rate
          ldd # (lo((1500000/25))<<8) | (hi(60000)) ; that is a 16 bit, exactly what we want!
	; but from my experience setting the refreshrate is allways a bad idea!
          std V_Rfrsh
	
	; decrunch all 4 vector objects
	ldx # vec_start_src
	ldy # vec_start_dst
	bsr f_decrunch_vector
	bsr f_decrunch_vector
	bsr f_decrunch_vector
	bsr f_decrunch_vector
	
	; the current level
	ldd # t_levels
	std v_level_ptr

	; the "move to the middle" vector element which is prefixed to the rotated player
	clr v_vector_temp+0 ; $00 = don't display
	ldab 15, 15
	std v_vector_temp+1 ; 15, 15 = move the beam
	
	; jump to the restart level routine
	bra restart_level

	;
	; decrunch a vector
	;

f_decrunch_vector:
	; X = src
	; Y = dst
	ldb , x+
	beq exit_decrunch_vector
	sex
	sta , y+
	clra
	bitb # 1
	beq fd1
	lda , x+
fd1:
	sta , y+
	clra
	bitb # 2
	beq fd2
	lda , x+
fd2
	sta , y+
	bra f_decrunch_vector

exit_decrunch_vector:
	lda # 1
	sta , y+
	rts


	;
	; restart the current level
	;
restart_level:
	; U = ptr to level
	ldu v_level_ptr

	; x and y position of the player
	ldd 4,u
	std v_player_y ; + x

	; pointer to the player in the level data
	ldb 6,u
	lda # v_level_ram >> 8
	std v_player_ptr

	; decrunch the vector which draws the level
	ldx 0, u
	ldy # v_level_vector
	bsr f_decrunch_vector

	; unpack level ram
	ldy 2,u
	ldu # v_level_ram
one_byte:
	lda , y+
	ldx # 4
one_element:
	tfr a, b
	andb # 3
	beq is_fl
	decb
	beq is_wl
	decb
	beq is_tg
	;decb
	;beq is_bx
is_bx:
	ldb # lBX
	bra set_tile
is_tg:
	ldb # lTG
	bra set_tile
is_wl:
	ldb # lWL
is_fl:
set_tile:
	stb , u+
	lsra
	lsra
	leax -1,x
	bne one_element
	cmpu # v_level_ram + 16*8
	bne one_byte
	
	; add player to level
	lda # lPLe
	sta [v_player_ptr]
	
	; basics
	lda # 1
	sta v_player_dir ; heading east
	clr v_rotate ; currently not rotating
	
	;
	; main routine
	;
	
main_loop: 
	; screen
	jsr F_Wait_Recal

	; paint level background
	jsr F_Reset0Ref
	intensity intens_level

	ldab 0, 0
	jsr F_Moveto_d_7F

	lda # 64
	sta VIA_t1_cnt_lo ; scale factor

	ldx # v_level_vector
	jsr F_Draw_VLp

	jsr f_paint_level

	; is the player rotating: rotate more	
	lda v_rotate
	beq no_rot
	adda v_rot_dir
	sta v_rotate
no_rot:
	
	; read the yoystick
	jsr F_Joy_Digital

	; have we to wait until the joustick is released?
	tst v_joy_wait
	bne wait_joy

	; X direction: rotate player
	ldx v_player_ptr

	lda V_Joy_1_X
	beq no_x_dir
	bmi left
right:
	lda # 14
	sta v_rotate
	lda #-2
	sta v_rot_dir
	lda v_player_dir
	inca
	bra l1
left:
	lda #-14
	sta v_rotate
	lda # 2
	sta v_rot_dir
	lda v_player_dir
	deca
l1
	anda # $03
	sta v_player_dir
	lda 0, x
	anda  #~lPLall
	ora # lPLbase
	ora v_player_dir
	sta 0, x
	inc v_joy_wait

no_x_dir:

	; Y direction: move player / push box (only forward)
	clr v_can_push
	ldb v_player_dir
	lda V_Joy_1_Y
	beq no_y_dir
	bpl up
down:
	ldb v_player_dir
	addb # 2
	andb # 3
	inc v_can_push
up:

	jsr move_to_dir
	inc v_joy_wait

no_y_dir:

	; wait until the joystick is released	
wait_joy:
	lda V_Joy_1_X
	bne noJoy
	lda V_Joy_1_Y
	bne noJoy
	clr v_joy_wait
noJoy

	;
	; check level done
	;

	ldb # $7f
	ldx # v_level_ram
check
	lda b, x
	anda # lTG | lBX
	cmpa # lTG
	beq buttons ; we found an target without a box -> not done
	decb
	bpl check
	bmi go_next_level
buttons

	;
	; joystick buttons
	;

	jsr F_Read_Btns
	
	lda V_Buttons
	
	; check for next level btton
	tfr a, b
	anda # $06
	bne next_level

	; check for restart level button
	andb # $09
	lbne restart_level

	; we're done -> start the main loop again
	jmp main_loop





	;
	; a level is done!! (wait a little bit and then blink the level)
	;

go_next_level:
	lda # 7
	sta v_wait
	lda # 12
	sta v_wait2
go_next_level_loop:
	; screen
	jsr F_Wait_Recal

	; blink?
	lda v_wait
	bita # $01
	beq draw_level

	; paint level background
	jsr F_Reset0Ref
	intensity intens_level

	ldab 0, 0
	jsr F_Moveto_d_7F

	lda # 64
	sta VIA_t1_cnt_lo ; scale factor

	ldx # v_level_vector
	jsr F_Draw_VLp
draw_level

	jsr f_paint_level
	
	dec v_wait2
	bne go_next_level_loop

	lda # 2
	sta v_wait2

	dec v_wait
	bne go_next_level_loop
	
	;
	; advance to the next level (either by completing one or pressing the button)
	;

next_level:
	ldx v_level_ptr
	; when this is the last level -> start over
	cmpx # t_level_last
	bne nl1
	ldx # t_levels-7
nl1
	; calc the next level
	leax 7, x
	stx v_level_ptr
	; and restart
	jmp restart_level


	;
	; paint the level objects
	;

f_paint_level:
	ldb # $7f+1
	ldu # v_level_ram
f_paint_level_loop:
	decb
	bpl norts
	rts
norts
	lda b, u
	beq f_paint_level_loop ; no object
	bmi f_paint_level_loop ; wall
	
	stb v_temp_1
	
	; object
	bita # lPLall
	bne is_pl
	anda # lBX | lTG
	cmpa # lBX
	beq is_box
	cmpa # lBX | lTG
	beq is_box_on
is_target
	ldx # t_target
	intensity intens_level
	bra drawNow
is_box:
	ldx # t_box
	intensity intens_obj
	bra drawNow
is_box_on:
	ldx # t_box_on
	intensity intens_obj
	bra drawNow
is_pl
	intensity intens_player
	jsr F_DP_to_C8
	direct $c8
	ldb v_temp_1
	lda # 1
	suba b, u
	stu v_temp_2
	anda # 3
	lsla
	lsla
	lsla
	lsla
	adda v_rotate
	ldx # t_player
	ldu # v_vector_temp+3
	jsr F_Rot_VL_Mode_a ; needs dp = $c8
	ldx # v_vector_temp
	ldu v_temp_2
	jsr F_DP_to_D0
	direct $d0

	; now X = object to draw
drawNow	
	jsr F_Reset0Ref ; kills a+b

	; calc position on screen
	lda v_temp_1
	lsra
	lsra
	lsra
	ldb # 15
	mul
	negb
	addb # 7*15
	stb v_temp_2
	lda v_temp_1
	anda # 7
	ldb # 15
	mul
	subb # 4*15
	lda v_temp_2

	jsr F_Moveto_d_7F
	lda # 64
	sta VIA_t1_cnt_lo ; scale factor
	jsr F_Draw_VLp
	
	ldb v_temp_1
	
	jmp f_paint_level_loop






	;
	; move/push the player
	;
	


	direct $c8


move_north:
	LDB #-8
	lda v_player_y
	beq exit_move
	ldx v_player_ptr
	lda -1*8, x
	bmi exit_move ; is a wall
	anda # lBX
	beq go_north ; is neither wall nor box
	; is box, check next field
	lda v_player_y
	cmpa # 1
	beq exit_move ; behind the block is the border
	lda -2*8, x
	anda # lBX
	bne exit_move ; behind the block is a wall or another block
	lda v_can_push
	bne exit_move
push_north:
	bsr push_sub
go_north:
	dec v_player_y
	bra go_sub

move_south:
	ldb #+8
	lda v_player_y
	cmpa # 15
	beq exit_move ; right border
	ldx v_player_ptr
	lda 1*8, x
	bmi exit_move ; is a wall
	anda # lBX
	beq go_south ; is neither wall nor box
	; is box, check next field
	lda v_player_y
	cmpa # 14
	beq exit_move ; behind the block is the border
	lda 2*8, x
	anda # lBX
	bne exit_move ; behind the block is a wall or another block
	lda v_can_push
	bne exit_move
push_south:
	bsr push_sub
go_south:
	inc v_player_y
	bra go_sub


push_sub:
	lda b, x
	anda #~lBX
	sta b, x
	lslb
	lda b, x
	ora # lBX
	sta b, x
	asrb
	rts

go_sub:
	lda 0, x
	anda #~lPLall
	sta 0, x
	lda v_player_dir
	ora # lPLbase
	ora b, x
	sta b, x
	leax b, x
	stx v_player_ptr
	clr v_rotate

exit_move:
	jsr F_DP_to_D0
	rts


move_to_dir:
	jsr F_DP_to_C8
	decb
	bmi move_north
	beq move_east
	decb
	beq move_south
move_west:
	ldb #-1
	lda v_player_x
	beq exit_move
	ldx v_player_ptr
	lda -1, x
	bmi exit_move ; is a wall
	anda # lBX
	beq go_west ; is neither wall nor box
	; is box, check next field
	lda v_player_x
	cmpa # 1
	beq exit_move ; behind the block is the border
	lda -2, x
	anda # lBX
	bne exit_move ; behind the block is a wall or another block
	lda v_can_push
	bne exit_move
push_west:
	bsr push_sub
go_west:
	dec v_player_x
	bra go_sub
		


move_east:
	ldb #+1
	lda v_player_x
	cmpa # 7
	beq exit_move ; right border
	ldx v_player_ptr
	lda 1, x
	bmi exit_move ; is a wall
	anda # lBX
	beq go_east ; is neither wall nor box
	; is box, check next field
	lda v_player_x
	cmpa # 6
	beq exit_move ; behind the block is the border
	lda 2, x
	anda # lBX
	bne exit_move ; behind the block is a wall or another block
	lda v_can_push
	bne exit_move
push_east:
	bsr push_sub
go_east:
	inc v_player_x
	bra go_sub

	direct $d0



	;
	; the "no music" data
	;

d_no_music:
	dw $fee8
	dw $feb6
	db $0, $80
	db $0, $80

	;
	; the level objects (crunched)
	;

vec_start_src:
;t_target
	db $03,    3,    9
	db $82,         12
	db $83,    6,    6
	db $81,   12
	db $83,    6,   -6
	db $82,        -12
	db $83,   -6,   -6
	db $81,  -12
	db $83,   -6,    6
	db $03,    8,   -2
	db $81,    8
	db $83,    3,    3
	db $82,          8
	db 0
;t_box
	 DB $03,    3,    3
	 DB $81,   24
	 DB $82,         24
	 DB $81,  -24
	 DB $82,        -24
	 DB $01,    4
	 DB $82,         24
	 DB $01,   16
	 DB $82,        -24
	 DB 0
;t_box_on
	 DB $03,    3,    3
	 DB $81,   24
	 DB $82,         24
	 DB $81,  -24
	 DB $82,        -24
	 DB $01,    4
	 DB $82,         24
	 DB $01,   16
	 DB $82,        -24
	 DB $03,   -8,    6
	 DB $83,   -4,    4
	 DB $83,    8,    8
	 DB 0
;t_player
	 DB $03,  -11,   -9
	 DB $82,         14
	 DB $03,   -1,    7
	 DB $82,         -1
	 DB $83,    3,   -3
	 DB $81,   18
	 DB $83,    3,    3
	 DB $82,          1
	 DB $81,   -4
	 DB $83,   -1,   -1
	 DB $81,  -14
	 DB $83,   -1,    1
	 DB $81,   -4
	 DB $03,    7,   -4
	 DB $82,         -3
	 DB $02,         -4
	 DB $82,         -4
	 DB $81,   10
	 DB $82,          4
	 DB $81,  -10
	 DB $03,   10,    4
	 DB $82,          3
	 DB $03,  -16,   -3
	 DB $81,   22
	 DB $82,        -14
	 DB $83,   -3,   -3
	 DB $81,  -16
	 DB $83,   -3,    3
	 DB 0

	;
	; the level data
	;
	; the crunched vector + the level data + and pointers around

t_level_0_vec:
	 DB $03,   60,   60
	 DB $81,  -90
	 DB $82,        -30
	 DB $81,  -30
	 DB $82,        -60
	 DB $81,   30
	 DB $82,        -30
	 DB $81,   60
	 DB $82,         30
	 DB $81,   30
	 DB $82,         90
	 DB $03,   30,   30
	 DB $81, -120
	 DB $82,         30
	 DB $81,  -90
	 DB $82,        -90
	 DB $81,   30
	 DB $82,        -60
	 DB $81,  -30
	 DB $82,        -90
	 DB $81,   90
	 DB $82,         30
	 DB $81,   60
	 DB $82,        -30
	 DB $81,   90
	 DB $82,         90
	 DB $81,  -30
	 DB $82,        120
	 DB $00
t_level_0_ram:
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rFL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rFL << 0) | (rBX << 2) | (rFL << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rFL << 4) | (rWL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rFL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rFL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rFL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rFL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rFL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rFL << 4) | (rWL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rFL << 4) | (rWL << 6), (rWL << 0) | (rFL << 2) | (rBX << 4) | (rFL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rBX << 4) | (rTG << 6)
	 DB (rFL << 0) | (rFL << 2) | (rFL << 4) | (rWL << 6), (rWL << 0) | (rFL << 2) | (rTG << 4) | (rTG << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
t_level_1_vec:
	 DB $81,   30
	 DB $82,        -90
	 DB $81,   75
	 DB $81,   75
	 DB $82,         75
	 DB $82,         75
	 DB $81,  -60
	 DB $82,         30
	 DB $81,   60
	 DB $82,         30
	 DB $81,  -90
	 DB $81,  -90
	 DB $81,  -90
	 DB $81,  -90
	 DB $82,        -30
	 DB $81,   60
	 DB $82,        -30
	 DB $81,  -60
	 DB $82,        -90
	 DB $82,        -90
	 DB $81,   75
	 DB $81,   75
	 DB $82,         90
	 DB $82,         90
	 DB $81,  -60
	 DB $82,         30
	 DB $81,   90
	 DB $81,   90
	 DB $82,        -30
	 DB $81,  -90
	 DB $82,        -60
	 DB $00
t_level_1_ram:
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rWL << 0) | (rFL << 2) | (rTG << 4) | (rBX << 6), (rTG << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rWL << 0) | (rFL << 2) | (rBX << 4) | (rFL << 6), (rBX << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6)
	 DB (rWL << 0) | (rFL << 2) | (rTG << 4) | (rBX << 6), (rTG << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rWL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rFL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rTG << 2) | (rBX << 4) | (rTG << 6), (rBX << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rBX << 2) | (rTG << 4) | (rBX << 6), (rTG << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rTG << 2) | (rBX << 4) | (rTG << 6), (rBX << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
t_level_2_vec:
	 DB $03,   30,  -30
	 DB $82,        -60
	 DB $81,   30
	 DB $82,         30
	 DB $81,   60
	 DB $82,         30
	 DB $81,  -90
	 DB $03,  -60,   30
	 DB $82,         90
	 DB $81,  -30
	 DB $82,        -60
	 DB $81, -120
	 DB $82,        -30
	 DB $81,   75
	 DB $81,   75
	 DB $02,        -30
	 DB $81,  -75
	 DB $81,  -75
	 DB $82,        -30
	 DB $81,  -30
	 DB $82,         30
	 DB $81,  -30
	 DB $82,         60
	 DB $81,   30
	 DB $82,         30
	 DB $81,   30
	 DB $82,         30
	 DB $81,   60
	 DB $82,         30
	 DB $81,  120
	 DB $81,  120
	 DB $82,        -30
	 DB $81,   60
	 DB $82,        -30
	 DB $81,   30
	 DB $82,        -30
	 DB $81,  -75
	 DB $81,  -75
	 DB $82,         60
	 DB $81,  -30
	 DB $82,        -90
	 DB $81,   90
	 DB $81,   90
	 DB $82,         30
	 DB $81,   30
	 DB $82,        -60
	 DB $81,  -30
	 DB $82,        -30
	 DB $81,  -30
	 DB $82,        -30
	 DB $81,  -30
	 DB $82,        -30
	 DB $81,  -75
	 DB $81,  -75
	 DB $81,  -75
	 DB $81,  -75
	 DB $82,         30
	 DB $81,  -30
	 DB $82,         30
	 DB $81,  120
	 DB $82,        -30
	 DB $81,   30
	 DB $82,         60
	 DB $00
t_level_2_ram:
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rFL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rFL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rFL << 4) | (rWL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rFL << 4) | (rWL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rBX << 4) | (rTG << 6)
	 DB (rFL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rFL << 4) | (rTG << 6)
	 DB (rFL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rTG << 6)
	 DB (rFL << 0) | (rBX << 2) | (rFL << 4) | (rBX << 6), (rFL << 0) | (rBX << 2) | (rFL << 4) | (rTG << 6)
	 DB (rFL << 0) | (rFL << 2) | (rBX << 4) | (rFL << 6), (rBX << 0) | (rFL << 2) | (rBX << 4) | (rTG << 6)
	 DB (rFL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rTG << 6)
	 DB (rFL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rFL << 4) | (rTG << 6)
	 DB (rFL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rBX << 4) | (rTG << 6)
	 DB (rFL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rFL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rFL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rFL << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rFL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
t_level_3_vec:
	 DB $82,        120
	 DB $81,  -60
	 DB $82,        -60
	 DB $81,  -30
	 DB $82,         60
	 DB $81, -120
	 DB $03,   30,  -30
	 DB $82,        -30
	 DB $81,   30
	 DB $82,         30
	 DB $81,  -30
	 DB $03,  -30,   30
	 DB $82,        -90
	 DB $81,   60
	 DB $82,        -30
	 DB $81,   60
	 DB $82,         30
	 DB $81,   60
	 DB $82,        -60
	 DB $81,   90
	 DB $82,         90
	 DB $81,   30
	 DB $82,        -90
	 DB $82,        -90
	 DB $81,   60
	 DB $82,         60
	 DB $81,   60
	 DB $82,         60
	 DB $81,  -60
	 DB $82,         30
	 DB $81,  -30
	 DB $82,         60
	 DB $81,  -90
	 DB $82,        -90
	 DB $81,  -30
	 DB $00
t_level_3_ram:
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rFL << 4) | (rFL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rFL << 4) | (rBX << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rTG << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6), (rFL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rFL << 0) | (rBX << 2) | (rTG << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rFL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rFL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rFL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rBX << 2) | (rBX << 4) | (rFL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rFL << 0) | (rFL << 2) | (rFL << 4) | (rTG << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rFL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rTG << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
t_level_4_vec:
	 DB $01,   60
	 DB $82,         30
	 DB $81,  -75
	 DB $81,  -75
	 DB $82,         60
	 DB $81,  -30
	 DB $82,        -90
	 DB $81,   90
	 DB $81,   90
	 DB $02,         60
	 DB $81, -120
	 DB $82,         60
	 DB $81,  -90
	 DB $82,        -30
	 DB $81,  -90
	 DB $82,        -90
	 DB $82,        -90
	 DB $81,   30
	 DB $82,        120
	 DB $81,   30
	 DB $82,        -90
	 DB $81,   30
	 DB $82,        -60
	 DB $03,   30,   30
	 DB $81,   75
	 DB $81,   75
	 DB $82,         60
	 DB $81,  -75
	 DB $81,  -75
	 DB $82,        -60
	 DB $03,  -30,  -30
	 DB $81,   98
	 DB $81,   97
	 DB $81,   98
	 DB $81,   97
	 DB $03,  -30,   30
	 DB $82,         90
	 DB $81,  -90
	 DB $82,        -90
	 DB $81,   90
	 DB $03,   30,  -30
	 DB $82,        120
	 DB $82,        120
	 DB $03,  -30,  -30
	 DB $81, -120
	 DB $82,        -30
	 DB $81,   30
	 DB $82,        -30
	 DB $81,   90
	 DB $82,         60
	 DB $03,   30,   30
	 DB $81,  -90
	 DB $81,  -90
	 DB $82,        -60
	 DB $00
t_level_4_ram:
	 DB (rFL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rFL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rFL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rFL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rBX << 4) | (rFL << 6), (rBX << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rBX << 2) | (rFL << 4) | (rBX << 6), (rFL << 0) | (rBX << 2) | (rFL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rFL << 0) | (rWL << 2) | (rWL << 4) | (rBX << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rFL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rFL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rFL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rFL << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rFL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rFL << 2) | (rFL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rTG << 2) | (rTG << 4) | (rTG << 6), (rTG << 0) | (rTG << 2) | (rTG << 4) | (rWL << 6)
t_level_5_vec:
	 DB $01,  -60
	 DB $81,   68
	 DB $81,   67
	 DB $81,   68
	 DB $81,   67
	 DB $82,         30
	 DB $81,  -68
	 DB $81,  -67
	 DB $81,  -68
	 DB $81,  -67
	 DB $82,        -30
	 DB $03,  -30,  -30
	 DB $81,   90
	 DB $81,   90
	 DB $01,   30
	 DB $81,   30
	 DB $82,        -60
	 DB $81,  -30
	 DB $82,         60
	 DB $01,  -30
	 DB $82,        -30
	 DB $81,  -30
	 DB $82,        -60
	 DB $81,   90
	 DB $81,   90
	 DB $03,  -30,   30
	 DB $82,         60
	 DB $81,  -30
	 DB $82,        -60
	 DB $81,   30
	 DB $03,   30,  -30
	 DB $82,        120
	 DB $82,        120
	 DB $81, -120
	 DB $81, -120
	 DB $81, -120
	 DB $81, -120
	 DB $82,       -120
	 DB $82,       -120
	 DB $03,   30,   30
	 DB $81,   30
	 DB $82,         60
	 DB $81,  -30
	 DB $82,        -60
	 DB $03,  -30,  -30
	 DB $81,   68
	 DB $81,   67
	 DB $81,   68
	 DB $81,   67
	 DB $82,         60
	 DB $81,  -75
	 DB $81,  -75
	 DB $82,         30
	 DB $81,  -30
	 DB $82,         30
	 DB $81,   30
	 DB $82,         60
	 DB $81,   83
	 DB $81,   82
	 DB $81,   83
	 DB $81,   82
	 DB $82,         30
	 DB $81,  -75
	 DB $81,  -75
	 DB $81,  -75
	 DB $81,  -75
	 DB $82,       -120
	 DB $00
t_level_5_ram:
	 DB (rFL << 0) | (rFL << 2) | (rTG << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rFL << 4) | (rTG << 6)
	 DB (rFL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rBX << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rBX << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rFL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rTG << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rTG << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rTG << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6), (rWL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rTG << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6), (rFL << 0) | (rFL << 2) | (rWL << 4) | (rFL << 6)
	 DB (rBX << 0) | (rBX << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rFL << 4) | (rBX << 6)
	 DB (rFL << 0) | (rFL << 2) | (rTG << 4) | (rWL << 6), (rFL << 0) | (rFL << 2) | (rBX << 4) | (rTG << 6)
	 DB (rFL << 0) | (rFL << 2) | (rBX << 4) | (rFL << 6), (rFL << 0) | (rBX << 2) | (rFL << 4) | (rTG << 6)
	 DB (rFL << 0) | (rWL << 2) | (rWL << 4) | (rBX << 6), (rBX << 0) | (rFL << 2) | (rFL << 4) | (rTG << 6)
	 DB (rFL << 0) | (rFL << 2) | (rFL << 4) | (rFL << 6), (rBX << 0) | (rFL << 2) | (rFL << 4) | (rTG << 6)
t_level_6_vec:
	 DB $03,  -25,  -68
	 DB $03,  -25,  -67
	 DB $81,  100
	 DB $82,         47
	 DB $83,  -13,   13
	 DB $81,  -73
	 DB $83,  -13,  -13
	 DB $82,        -47
	 DB $03,   20,   20
	 DB $81,   60
	 DB $82,         20
	 DB $81,  -60
	 DB $82,        -20
	 DB $03,  -20,   73
	 DB $82,         33
	 DB $83,   13,   13
	 DB $81,   73
	 DB $83,   13,  -13
	 DB $82,        -33
	 DB $83,  -13,  -13
	 DB $81,  -73
	 DB $83,  -13,   13
	 DB $03,   20,    7
	 DB $81,   60
	 DB $82,         20
	 DB $81,  -60
	 DB $82,        -20
	 DB $03,  -20,   60
	 DB $81,  100
	 DB $82,         47
	 DB $83,  -13,   13
	 DB $81,  -87
	 DB $82,        -20
	 DB $81,   80
	 DB $82,        -20
	 DB $81,  -80
	 DB $82,        -20
	 DB $02,         80
	 DB $81,  100
	 DB $82,         50
	 DB $81,  -20
	 DB $82,        -30
	 DB $81,  -20
	 DB $82,         20
	 DB $81,  -20
	 DB $82,        -20
	 DB $81,  -20
	 DB $82,         30
	 DB $81,  -20
	 DB $82,        -50
	 DB $00
t_level_6_ram:
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rFL << 4) | (rWL << 6), (rBX << 0) | (rWL << 2) | (rTG << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
	 DB (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6), (rWL << 0) | (rWL << 2) | (rWL << 4) | (rWL << 6)
t_levels:
;t_level_0:
	DW t_level_0_vec, t_level_0_ram
	 DB 10, 5
	 DB 10*8 + 5
;t_level_1:
	DW t_level_1_vec, t_level_1_ram
	 DB 4, 3
	 DB 4*8 + 3
;t_level_2:
	DW t_level_2_vec, t_level_2_ram
	 DB 8, 3
	 DB 8*8 + 3
;t_level_3:
	DW t_level_3_vec, t_level_3_ram
	 DB 4, 0
	 DB 4*8 + 0
;t_level_4:
	DW t_level_4_vec, t_level_4_ram
	 DB 2, 4
	 DB 2*8 + 4
;t_level_5:
	DW t_level_5_vec, t_level_5_ram
	 DB 6, 5
	 DB 6*8 + 5
;t_level_6:
t_level_last:
	DW t_level_6_vec, t_level_6_ram
	 DB 10, 2
	 DB 10*8 + 2

