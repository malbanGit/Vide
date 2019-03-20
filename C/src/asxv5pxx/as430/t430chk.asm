	.title	AS430 Checks

	;
	; In area relative addressing
	;

	.area	Code	(ABS, OVR)

	.org	0x0000
	mov	1$,2$			; 90 40 10 00 10 00

	.org	0x0000
	mov	.+0x0012,.+0x0014	; 90 40 10 00 10 00

	.org	0x0012
1$:	.word	0			; 00 00
2$:	.word	0			; 00 00

	.org	0x0020
	mov	1$,2$			; 90 40 F0 FF F0 FF

	.org	0x0020
	mov	.-0x000E,.-0x000C	; 90 40 F0 FF F0 FF


	;
	; Out of area relative addressing
	;

	.org	0x0000
	mov	srcdat,dstdat		; 90 40p12q00p14q00


	.area	Code1	(ABS,OVR)

	.org	0x0012
srcdat:	.word	0			; 00 00


	.area	Code2	(ABS,OVR)

	.org	0x0014
dstdat:	.word	0			; 00 00


	.area	Code	(ABS, OVR)

	.org	0x0020
	mov	srcdat,dstdat		; 90 40p12q00p14q00


	;
	; In area Conditional Jumps (relative)
	;

	.org	0x0000
	jmp	3$			; 08 3C

	.org	0x0000
	jmp	.+0x0012		; 08 3C


	.org	0x0012
3$:

	.org	0x0020
	jmp	3$			; F8 3F

	.org	0x0020
	jmp	.-0x000E		; F8 3F


	;
	; Out of area Conditional Jumps (relative)
	;

	.org	0x0000
	jmp	label			;p09q3C


	.area	Code1	(ABS,OVR)

	.org	0x0012
label:


	.area	Code	(ABS,OVR)

	.org	0x0020
	jmp	label			;p09q3C


