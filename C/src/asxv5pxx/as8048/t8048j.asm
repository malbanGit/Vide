	.title	AS8048 Boundary Tests

	.area	as8048	(ABS, OVR)

	.org	0

J1:	jc	J1
	jc	J2
	jc	J3	; Link Error
	jc	J5	; Link Error
	.blkb	256 - 12
	jc	J1
J2:	jc	J1
J3:	jc	J3
	jc	J4
	jc	J5	; Link Error
	jc	J1	; Link Error
	.blkb	256 - 12
	jc	J3
J4:	jc	J3
J5:


	.org	0

J11:	jmp	J11
	jmp	J12
	jmp	J13	; Link Error
	jmp	J15	; Link Error
	.blkb	2048 - 12
	jmp	J11
J12:	jmp	J11
J13:	jmp	J13
	jmp	J14
	jmp	J15	; Link Error
	jmp	J11	; Link Error
	.blkb	2048 - 12
	jmp	J13
J14:	jmp	J13
J15:



