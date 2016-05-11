;get the name


get_score_name:
;no need to check byte3 any more as removing it!
;	lda		scr_byte3	
;	cmpa	#0
;	beq		gsn_2		;if byte3 is 0, check byte2
;	jmp		scr_100		;else check byte3 , we use jmp because its to far away to bra
;gsn_2:

	lda		scr_byte2
	cmpa	#0
	beq		scr_0		;if byte2 is 0, check byte1
	cmpa	#1
	lbeq		scr_10		;else check byte2
	cmpa	#2
	lbeq		scr_20	;lbeq long jump required
	cmpa	#3
	lbeq		scr_30
	cmpa	#4
	lbeq		scr_40
	cmpa	#5
	lbeq		scr_50

scr_0:
	lda 	scr_byte1
	cmpa	#0
	bne		scr_1
	ldu		#scrname_0
	rts
scr_1:

	lda 	scr_byte1
	cmpa	#1
	bne		scr_2
	ldu		#scrname_1
	rts
scr_2:

	lda 	scr_byte1
	cmpa	#2
	bne		scr_3
	ldu		#scrname_2
	rts
scr_3:

	lda 	scr_byte1
	cmpa	#3
	bne		scr_4
	ldu		#scrname_3
	rts
scr_4:

	lda 	scr_byte1
	cmpa	#4
	bne		scr_5
	ldu		#scrname_4
	rts
scr_5:

	lda 	scr_byte1
	cmpa	#5
	bne		scr_6
	ldu		#scrname_5
	rts
scr_6:

	lda 	scr_byte1
	cmpa	#6
	bne		scr_7
	ldu		#scrname_6
	rts
	
scr_7:
	lda 	scr_byte1
	cmpa	#7
	bne		scr_8
	ldu		#scrname_7
	rts
	
scr_8:
	lda 	scr_byte1
	cmpa	#8
	bne		scr_9
	ldu		#scrname_8
	rts

scr_9:						
	lda 	scr_byte1
	cmpa	#9
	bne		scr_10
	ldu		#scrname_9
	rts
	
scr_10:
	lda 	scr_byte2
	cmpa	#1
	bne		scr_20		;jump to 20 if byte 2 is not 1 - so try 20s
	ldu		#scrname_10
;	rts
	
scr_15:
	lda 	scr_byte1
	cmpa	#5
	bne		scr_20
	ldu		#scrname_15
	rts
	
scr_20:
	lda 	scr_byte2
	cmpa	#2
	bne		scr_30
	ldu		#scrname_20
;	rts
	
scr_25:
	lda 	scr_byte1
	cmpa	#5
	bne		scr_30
	ldu		#scrname_25
	rts
	
scr_30:
	lda 	scr_byte2
	cmpa	#3
	bne		scr_40
	ldu		#scrname_30
;	rts
	
	
scr_35:
	lda 	scr_byte1
	cmpa	#5
	bne		scr_36
	ldu		#scrname_35
;	rts
	
scr_36:
	lda 	scr_byte1
	cmpa	#6
	bne		scr_37
	ldu		#scrname_36
;	rts
	
scr_37:
	lda 	scr_byte1
	cmpa	#7
	bne		scr_38
	ldu		#scrname_37
;	rts
	
scr_38:
	lda 	scr_byte1
	cmpa	#8
	bne		scr_39
	ldu		#scrname_38
;	rts
	
scr_39:
	lda 	scr_byte1
	cmpa	#9
	bne		scr_40
	ldu		#scrname_39
	rts

scr_40:
	lda 	scr_byte2
	cmpa	#4
	bne		scr_50
	ldu		#scrname_40
;	rts

scr_41:
	lda 	scr_byte1
	cmpa	#1
	bne		scr_42
	ldu		#scrname_41
;	rts
	
scr_42:
	lda 	scr_byte1
	cmpa	#2
	bne		scr_43
	ldu		#scrname_42
;	rts
	
scr_43:
	lda 	scr_byte1
	cmpa	#3
	bne		scr_44
	ldu		#scrname_43
;	rts
	
scr_44:
	lda 	scr_byte1
	cmpa	#4
	bne		scr_45
	ldu		#scrname_44
;	rts
	
scr_45:
	lda 	scr_byte1
	cmpa	#5
	bne		scr_46
	ldu		#scrname_45
;	rts
	
scr_46:
	lda 	scr_byte1
	cmpa	#6
	bne		scr_47
	ldu		#scrname_46
;	rts
	
scr_47:
	lda 	scr_byte1
	cmpa	#7
	bne		scr_48
	ldu		#scrname_47
;	rts
	
scr_48:
	lda 	scr_byte1
	cmpa	#8
	bne		scr_49
	ldu		#scrname_48
;	rts
	
scr_49:
	lda 	scr_byte1
	cmpa	#9
	bne		scr_60
	ldu		#scrname_49
	rts
	
scr_50:
;	lda 	scr_byte2
;	cmpa	#5
;	bne		scr_60
;	ldu		#scrname_50
;	rts
	

scr_60:		;should not be possible to get to this
	rts
