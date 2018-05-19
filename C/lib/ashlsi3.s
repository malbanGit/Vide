	/* X points to the SImode (source/dest)
		B is the count */
_ashlsi3:
	pshs	u
	cmpb	#16
	blt	try8_ashlsi3
	subb	#16
	; Shift by 16
	ldu	2,x
	stu	,x
try8_ashlsi3:
	cmpb	#8
	blt	try_rest
	subb	#8
	; Shift by 8

try_rest_ashlsi3:
	tstb
	beq	done_ashlsi3
do_rest_ashlsi3:
	; Shift by 1
	asl	3,x
	rol	2,x
	rol	1,x
	rol	,x
	decb
	bne	do_rest_ashlsi3
done_ashlsi3:
	puls	u,pc