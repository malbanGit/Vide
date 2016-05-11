;attempt at writing 16bit x,x particles - 
;we need 64bytes for 16 particles xy
;and 64bytes for 16 particles xy velocity

;constants
DRAG	equ		7
GRAVITY	equ		8
PCOUNT_1	equ	16 ;count currently same for all 3 systems (32 was too high - ran out of ram!!!)


update_emitters:	
	lda		emitter_1_on
	cmpa	#0
	beq		u_em2
	lda		emitter_1_pcount		;copy pcount
	sta		emitter_current_pcount	;to current pcount
	jsr		update_emitter_1
u_em2:
	lda		emitter_2_on
	cmpa	#0
	beq		u_em3
	lda		emitter_2_pcount		;copy pcount
	sta		emitter_current_pcount	;to current pcount
	jsr		update_emitter_2
u_em3:
	lda		emitter_3_on
	cmpa	#0
	beq		u_em_rt
	lda		emitter_3_pcount		;copy pcount
	sta		emitter_current_pcount	;to current pcount
	jsr		update_emitter_3
u_em_rt:
	rts
	

init_emitter_1:;{ inits for each emitter
	lda		emitter_1_pcount		;copy pcount
	sta		emitter_current_pcount	;to current pcount
	lda		#1
	sta		emitter_1_on
	lda		#127
	sta		emitter_1_intensity		;set emitter intensity
	lda		#100
	sta		emitter_1_life			;set emitter life
	ldu		#particle_1_xy
	ldx		#particle_1_vel_xy
	ldy		#firework_1_lookup
	jsr		init_emitter
	rts
	
init_emitter_2:
	lda		emitter_2_pcount		;copy pcount
	sta		emitter_current_pcount	;to current pcount
	lda		#1
	sta		emitter_2_on
	lda		#127
	sta		emitter_2_intensity		;set emitter intensity
	lda		#101
	sta		emitter_2_life			;set emitter life
	ldu		#particle_2_xy
	ldx		#particle_2_vel_xy
	ldy		#firework_1_lookup
	jsr		init_emitter
	rts	
	
init_emitter_3:
	lda		emitter_3_pcount		;copy pcount
	sta		emitter_current_pcount	;to current pcount
	lda		#1
	sta		emitter_3_on
	lda		#127
	sta		emitter_3_intensity		;set emitter intensity
	lda		#103
	sta		emitter_3_life			;set emitter life
	ldu		#particle_3_xy
	ldx		#particle_3_vel_xy
	ldy		#firework_1_lookup
	jsr		init_emitter
	rts
	
;}	

init_emitter:	;{ init emitter using what is in u x y
	clra
	;ldb			#PCOUNT_1*4
	;set a to 0
	ldb		emitter_current_pcount				;load particle count * 4 (x(2bytes)+y(2bytes)*particles eg 2+2*32=128bytes)
	aslb	;*2
	aslb	;*2
particle_1_clear_xy:				
	sta		,u+
	decb
	bne		particle_1_clear_xy		;loop or continue if 0
	
;set up random	vel
	ldb		emitter_current_pcount
	aslb	;*2
	;ldb		#PCOUNT_1*2
	stb		tmp_1
particle_1_random:
	;high bit
	jsr		Random
	anda	#%00000011		;use mask to get lower number
	suba	#2				;subtract to get some neg values
	sta		,x+
	
	;low bit
	jsr		Random			;doesnt need negative values because high bit holds that flag (I think)
	ldb		,y+				;load lut that gives better distribution instead of just random
	stb		tmp_2			;save to mem lut value
	adda	tmp_2			;add lut value  to random value to get some more variation
	sta		,x+
;loop or return	
	dec		tmp_1	
	bne		particle_1_random
	rts
;}	

update_emitter_1:;{
	dec		emitter_1_life	;decrease emitter life
	bne		emitter_draw_1	;if not 0 draw
	clra
	sta		emitter_1_on ;turn off emitter
	rts	
emitter_draw_1:
	ldx		#particle_1_xy		;ram pos x,y
	ldu		#particle_1_xy		;ram pos x,y , also in u we use later... maybe we could set x back somehow or use jsr instead 
	ldy		#particle_1_vel_xy		;ram intial velocity
	lda		emitter_1_intensity
	deca
	sta		emitter_1_intensity
	jsr		Intensity_a
	lda		#127
	sta		VIA_t1_cnt_lo	;store scale factor
	jsr		Reset0Ref
	lda		emitter_1_y	;hibyte
	ldb		emitter_1_x	;hibyte
	jsr		Moveto_d
	;ldb		#PCOUNT_1
	ldb		emitter_1_pcount
	stb		tmp_1			;store to temp counter
	jsr		particle_physics
	rts
;}

update_emitter_2:;{
	dec		emitter_2_life	;decrease emitter life
	bne		emitter_draw_2	;if not 0 draw
	clra
	sta		emitter_2_on ;turn off emitter
	rts	
emitter_draw_2:
	ldx		#particle_2_xy		;ram pos x,y
	ldu		#particle_2_xy		;ram pos x,y , also in u we use later... maybe we could set x back somehow or use jsr instead 
	ldy		#particle_2_vel_xy		;ram intial velocity
	lda		emitter_2_intensity
	deca
	sta		emitter_2_intensity
	jsr		Intensity_a
	lda		#127
	sta		VIA_t1_cnt_lo	;store scale factor
	jsr		Reset0Ref
	lda		emitter_2_y
	ldb		emitter_2_x
	jsr		Moveto_d
	;ldb		#PCOUNT_1
	ldb		emitter_2_pcount
	stb		tmp_1			;store to temp counter
	jsr		particle_physics
	rts
;}

update_emitter_3:;{
	dec		emitter_3_life	;decrease emitter life
	bne		emitter_draw_3	;if not 0 draw
	clra
	sta		emitter_3_on ;turn off emitter
	rts	
emitter_draw_3:
	ldx		#particle_3_xy		;ram pos x,y
	ldu		#particle_3_xy		;ram pos x,y , also in u we use later... maybe we could set x back somehow or use jsr instead 
	ldy		#particle_3_vel_xy		;ram intial velocity
	lda		emitter_3_intensity
	deca
	sta		emitter_3_intensity
	jsr		Intensity_a
	lda		#127
	sta		VIA_t1_cnt_lo	;store scale factor
	jsr		Reset0Ref
	lda		emitter_3_y
	ldb		emitter_3_x
	jsr		Moveto_d
	;ldb		#PCOUNT_1
	ldb		emitter_3_pcount
	stb		tmp_1			;store to temp counter
	jsr		particle_physics
	rts
;}

;ALL geneirc code below expects X,Y,U registers to be ready for physics and drawing!
particle_physics: ;{ physics loop A is highbyte B is lowbyte 
;do xy coord
;drag constant

;do Y
	ldd		,y			;load velocity
	bmi		y_is_neg
	subd	#DRAG			;do drag
	bra		y_was_pos
y_is_neg:
	addd	#DRAG
y_was_pos:
	subd	#GRAVITY		;do gravity
	std		,y
	ldd		,x				;load 16bit position
	addd	,y++			;add velocity
	std		,x++			;store new pos and inc x
;do X
	ldd		,y			;load velocity
	bmi		x_is_neg
	subd	#DRAG			;do drag
	bra		x_was_pos
x_is_neg:
	addd	#DRAG
x_was_pos:
	std		,y
	ldd		,x				;load 16bit position
	addd	,y++			;add velocity
	std		,x++			;store new pos and inc x
;finish or loop
	dec		tmp_1			;dec number particles
	bne		particle_physics
	bra		particle_draw
;}


particle_draw:;{ drawing the dots
			;must reset for the first time
	lda		emitter_current_pcount
	sta		tmp_1
particle_draw_loop:
	;jsr					Reset0Ref ;is slower than a move???
	lda		,u++			;load only one of the bytes high 
	ldb		,u++			;load other high byte
	std		prev_part_yx 	;saves to prev_1_y and prev_1_x in one go
	jsr		Dot_d			;draw dot 
	ldd		prev_part_yx	;d was trashed, so reload d with yx
	nega					;negate yx values
	negb
	jsr		Moveto_d		;use the pen to 0.... should be faster than Reset0Ref - in theory???
	dec		tmp_1
	bne		particle_draw_loop
	rts
;}	

firework_1_lookup:;{ look up table to help with randomness
	;right top
	fcb		31,46
	fcb		21,11
	fcb		31,33
	fcb		41,42

	;left top
	fcb		-23,32
	fcb		-33,13
	fcb		-43,12
	fcb		-25,32

	;left bottom
	fcb		-12,-13
	fcb		-43,-41
	fcb		-14,-17
	fcb		-15,-13

	;right bot
	fcb		52,-13
	fcb		33,-41
	fcb		54,-17
	fcb		35,-13

	; dupe of other lut
		;right top
	fcb		31,46
	fcb		21,11
	fcb		31,33
	fcb		41,42

	;left top
	fcb		-23,32
	fcb		-33,13
	fcb		-43,12
	fcb		-25,32

	;left bottom
	fcb		-12,-13
	fcb		-43,-41
	fcb		-14,-17
	fcb		-15,-13

	;right bot
	fcb		52,-13
	fcb		33,-41
	fcb		54,-17
	fcb		35,-13
;}




	
	

	
	