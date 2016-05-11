
init_emitter_1:	;{
	lda		#127
	sta		emitter_1_intensity
	lda		#25
	sta		emitter_1_life
	clra
	ldb		#64
	ldx		#particle_1_xy		;clear X x2bytes
particle_1_clear_xy:
;	jsr		Random
;	anda	#%00011111
	sta		,x+
	decb
	bne		particle_1_clear_xy
	
	
;set up random	vel
	ldb		#64
	stb		tmp_1
	ldx		#particle_1_vel_xy
	ldy		#firework_1_lookup
	
particle_1_random:
	jsr		Random
	anda	#%00001111		;use mask to get lower number
	suba	#6				;subtract to get some neg values
	ldb		,y+				;load lut
	stb		tmp_2			;save to mem
	adda	tmp_2			;add lut to random value to get some more variation
	sta		,x+
	dec		tmp_1	
	bne		particle_1_random

	rts
	

do_emitter_1:
	dec		emitter_1_life
	bne		emitter_1_draw
	bra		init_emitter_1
emitter_1_draw:
	lda		emitter_1_intensity
	suba	#10
	sta		emitter_1_intensity
	jsr		Intensity_a
	lda		#127
	sta		VIA_t1_cnt_lo	;scale factor
	ldb		#32			;number of particles /2
	stb		tmp_1			;store to temp counter
	ldx		#particle_1_xy		;ram pos x,y
	ldy		#particle_1_vel_xy		;ram intial velocity
	;ldy		#firework_1_lookup
	
;	lda		fire_counter
;	deca
;	bne		fire_draw_save_counter		;if not
;	lda		#5
;	sta		fire_counter
	
fire_v_loop:

	
fire_physics:
;y
	lda		,x				;load pos
	adda	,y				;add velocity
	sta		,x+				;store new pos and inc x
	;dec		,y+				;gravity
	lda		,y
	bpl		is_posy_1
	inca
	bne		was_negy_1 ;was 0?
	lda		#-1
	bra		was_negy_1
is_posy_1:
	deca
	bne		was_negy_1;if not 0
	lda		#1
was_negy_1:
	sta		,y+
;x
	lda		,x				;load pos
	adda	,y				;add velocity
	sta		,x+				;store new pos and inc x
	
		lda		,y
	bpl		is_posx_1
	inca
	bra		was_negx_1
is_posx_1:
	deca
was_negx_1:
	sta		,y+

	dec		tmp_1			;dec number particles
	bne		fire_v_loop
	bra		fire_draw

fire_draw_save_counter:
;	sta		fire_counter

fire_draw:

	jsr		Reset0Ref	;must reset for the first time
	lda		#32
	sta		tmp_1
	ldx		#particle_1_xy	;ram for xy
fire_loop:
	jsr		Reset0Ref
	ldd		,x++
	jsr		Dot_d
	;ldd		,x+		;instead....doesnt work!
;	nega				;of
;	negb				;reset0ref we move back to 0,0
;	jsr		Moveto_d	;is this any faster?

	dec		tmp_1
	bne		fire_loop
	rts
	
firework_1_lookup:
	;right top
	fcb		1,6
	fcb		2,1
	fcb		3,3
	fcb		4,4
	fcb		3,2
	fcb		2,1
	fcb		5,1
	fcb		6,1
	;left top
	fcb		-2,3
	fcb		-3,1
	fcb		-4,7
	fcb		-5,3
	fcb		-6,5
	fcb		-7,4
	fcb		-8,3
	fcb		-8,5
	;left bottom
	fcb		-2,-3
	fcb		-3,-1
	fcb		-4,-7
	fcb		-5,-3
	fcb		-6,-5
	fcb		-7,-4
	fcb		-8,-3
	fcb		-9,-5
	;right bot
	fcb		2,-3
	fcb		3,-1
	fcb		4,-7
	fcb		5,-3
	fcb		6,-5
	fcb		7,-4
	fcb		1,-3
	fcb		4,-5





	
	

	
	