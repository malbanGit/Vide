	.title	AS2650 Assembler Checks

	; Assembler this file:
	;
	;	as2650 -gloaxff t2650
	;

	.sbttl	Absolute Code

	; Absolute Variables

	.define	ADDR	"0x1234"
	.define	BADD	"0x7654"
	.define	DATA8	"0x21"
	.define	DATA2	"0"
	.define	P	"0x98"
	.define	DISP	"."


	.area	AS2650	(ABS,OVR)
	.org	0x0000


	.sbttl	lod_ 'Sequential' Instruction Tests

;	lodz	r0			; 00
	lodz	r0			; 60
	lodz	r1			; 01
	lodz	r2			; 02
	lodz	r3			; 03
	lodi	r0,#DATA8		; 04 21
	lodi	r1,#DATA8		; 05 21
	lodi	r2,#DATA8		; 06 21
	lodi	r3,#DATA8		; 07 21
	lodr	r0,DISP			; 08 7E
	lodr	r1,DISP			; 09 7E
	lodr	r2,DISP			; 0A 7E
	lodr	r3,DISP			; 0B 7E
	loda	r0,ADDR			; 0C 12 34
	loda	r1,ADDR			; 0D 12 34
	loda	r2,ADDR			; 0E 12 34
	loda	r3,ADDR			; 0F 12 34

	.sbttl	lod_ 'Default Indirect' Instruction Tests

	lodr	r0,[DISP]		; 08 FE
	lodr	r1,[DISP]		; 09 FE
	lodr	r2,[DISP]		; 0A FE
	lodr	r3,[DISP]		; 0B FE

	loda	r0,[ADDR]		; 0C 92 34
	loda	r1,[ADDR]		; 0D 92 34
	loda	r2,[ADDR]		; 0E 92 34
	loda	r3,[ADDR]		; 0F 92 34

	loda	r0,[ADDR,+r0]		; 0C B2 34
	loda	r0,[ADDR,+r1]		; 0D B2 34
	loda	r0,[ADDR,+r2]		; 0E B2 34
	loda	r0,[ADDR,+r3]		; 0F B2 34

	loda	r0,[ADDR,-r0]		; 0C D2 34
	loda	r0,[ADDR,-r1]		; 0D D2 34
	loda	r0,[ADDR,-r2]		; 0E D2 34
	loda	r0,[ADDR,-r3]		; 0F D2 34

	loda	r0,[ADDR,r0]		; 0C F2 34
	loda	r0,[ADDR,r1]		; 0D F2 34
	loda	r0,[ADDR,r2]		; 0E F2 34
	loda	r0,[ADDR,r3]		; 0F F2 34

	.sbttl	lod_ 'Alternate Indirect' Instruction Tests

	lodr	r0,@DISP		; 08 FE
	lodr	r1,@DISP		; 09 FE
	lodr	r2,@DISP		; 0A FE
	lodr	r3,@DISP		; 0B FE

	loda	r0,@ADDR		; 0C 92 34
	loda	r1,@ADDR		; 0D 92 34
	loda	r2,@ADDR		; 0E 92 34
	loda	r3,@ADDR		; 0F 92 34

	loda	r0,@ADDR,+r0		; 0C B2 34
	loda	r0,@ADDR,+r1		; 0D B2 34
	loda	r0,@ADDR,+r2		; 0E B2 34
	loda	r0,@ADDR,+r3		; 0F B2 34

	loda	r0,@ADDR,-r0		; 0C D2 34
	loda	r0,@ADDR,-r1		; 0D D2 34
	loda	r0,@ADDR,-r2		; 0E D2 34
	loda	r0,@ADDR,-r3		; 0F D2 34

	loda	r0,@ADDR,r0		; 0C F2 34
	loda	r0,@ADDR,r1		; 0D F2 34
	loda	r0,@ADDR,r2		; 0E F2 34
	loda	r0,@ADDR,r3		; 0F F2 34


	.sbttl	'Sequential' Instruction Tests

					; 10
					; 11
	spsu				; 12
	spsl				; 13

	retc	.eq.			; 14
	retc	.gt.			; 15
	retc	.lt.			; 16
	retc	.un.			; 17

	retc	#DATA2 + 0		; 14
	retc	#DATA2 + 1		; 15
	retc	#DATA2 + 2		; 16
	retc	#DATA2 + 3		; 17

	.sbttl	bctr 'Sequential' Instruction Test

	bctr	.eq.,DISP		; 18 7E
	bctr	.gt.,DISP		; 19 7E
	bctr	.lt.,DISP		; 1A 7E
	bctr	.un.,DISP		; 1B 7E

	bctr	#DATA2 + 0,DISP		; 18 7E
	bctr	#DATA2 + 1,DISP		; 19 7E
	bctr	#DATA2 + 2,DISP		; 1A 7E
	bctr	#DATA2 + 3,DISP		; 1B 7E

	bctr	.eq.,[DISP]		; 18 FE
	bctr	.gt.,[DISP]		; 19 FE
	bctr	.lt.,[DISP]		; 1A FE
	bctr	.un.,[DISP]		; 1B FE

	bctr	#DATA2 + 0,[DISP]	; 18 FE
	bctr	#DATA2 + 1,[DISP]	; 19 FE
	bctr	#DATA2 + 2,[DISP]	; 1A FE
	bctr	#DATA2 + 3,[DISP]	; 1B FE

	bctr	.eq.,@DISP		; 18 FE
	bctr	.gt.,@DISP		; 19 FE
	bctr	.lt.,@DISP		; 1A FE
	bctr	.un.,@DISP		; 1B FE

	bctr	#DATA2 + 0,@DISP	; 18 FE
	bctr	#DATA2 + 1,@DISP	; 19 FE
	bctr	#DATA2 + 2,@DISP	; 1A FE
	bctr	#DATA2 + 3,@DISP	; 1B FE


	.sbttl	bcta 'Sequential' Instruction Test

	bcta	.eq.,BADD		; 1C 76 54
	bcta	.gt.,BADD		; 1D 76 54
	bcta	.lt.,BADD		; 1E 76 54
	bcta	.un.,BADD		; 1F 76 54

	bcta	#DATA2 + 0,BADD		; 1C 76 54
	bcta	#DATA2 + 1,BADD		; 1D 76 54
	bcta	#DATA2 + 2,BADD		; 1E 76 54
	bcta	#DATA2 + 3,BADD		; 1F 76 54

	bcta	.eq.,[BADD]		; 1C F6 54
	bcta	.gt.,[BADD]		; 1D F6 54
	bcta	.lt.,[BADD]		; 1E F6 54
	bcta	.un.,[BADD]		; 1F F6 54

	bcta	#DATA2 + 0,[BADD]	; 1C F6 54
	bcta	#DATA2 + 1,[BADD]	; 1D F6 54
	bcta	#DATA2 + 2,[BADD]	; 1E F6 54
	bcta	#DATA2 + 3,[BADD]	; 1F F6 54

	bcta	.eq.,@BADD		; 1C F6 54
	bcta	.gt.,@BADD		; 1D F6 54
	bcta	.lt.,@BADD		; 1E F6 54
	bcta	.un.,@BADD		; 1F F6 54

	bcta	#DATA2 + 0,@BADD	; 1C F6 54
	bcta	#DATA2 + 1,@BADD	; 1D F6 54
	bcta	#DATA2 + 2,@BADD	; 1E F6 54
	bcta	#DATA2 + 3,@BADD	; 1F F6 54


	.sbttl	eor_ 'Sequential' Instruction Tests

	eorz	r0			; 20
	eorz	r1			; 21
	eorz	r2			; 22
	eorz	r3			; 23
	eori	r0,#DATA8		; 24 21
	eori	r1,#DATA8		; 25 21
	eori	r2,#DATA8		; 26 21
	eori	r3,#DATA8		; 27 21
	eorr	r0,DISP			; 28 7E
	eorr	r1,DISP			; 29 7E
	eorr	r2,DISP			; 2A 7E
	eorr	r3,DISP			; 2B 7E
	eora	r0,ADDR			; 2C 12 34
	eora	r1,ADDR			; 2D 12 34
	eora	r2,ADDR			; 2E 12 34
	eora	r3,ADDR			; 2F 12 34

	.sbttl	eor_ 'Default Indirect' Instruction Tests

	eorr	r0,[DISP]		; 28 FE
	eorr	r1,[DISP]		; 29 FE
	eorr	r2,[DISP]		; 2A FE
	eorr	r3,[DISP]		; 2B FE

	eora	r0,[ADDR]		; 2C 92 34
	eora	r1,[ADDR]		; 2D 92 34
	eora	r2,[ADDR]		; 2E 92 34
	eora	r3,[ADDR]		; 2F 92 34

	eora	r0,[ADDR,+r0]		; 2C B2 34
	eora	r0,[ADDR,+r1]		; 2D B2 34
	eora	r0,[ADDR,+r2]		; 2E B2 34
	eora	r0,[ADDR,+r3]		; 2F B2 34

	eora	r0,[ADDR,-r0]		; 2C D2 34
	eora	r0,[ADDR,-r1]		; 2D D2 34
	eora	r0,[ADDR,-r2]		; 2E D2 34
	eora	r0,[ADDR,-r3]		; 2F D2 34

	eora	r0,[ADDR,r0]		; 2C F2 34
	eora	r0,[ADDR,r1]		; 2D F2 34
	eora	r0,[ADDR,r2]		; 2E F2 34
	eora	r0,[ADDR,r3]		; 2F F2 34

	.sbttl	eor_ 'Alternate Indirect' Instruction Tests

	eorr	r0,@DISP		; 28 FE
	eorr	r1,@DISP		; 29 FE
	eorr	r2,@DISP		; 2A FE
	eorr	r3,@DISP		; 2B FE

	eora	r0,@ADDR		; 2C 92 34
	eora	r1,@ADDR		; 2D 92 34
	eora	r2,@ADDR		; 2E 92 34
	eora	r3,@ADDR		; 2F 92 34

	eora	r0,@ADDR,+r0		; 2C B2 34
	eora	r0,@ADDR,+r1		; 2D B2 34
	eora	r0,@ADDR,+r2		; 2E B2 34
	eora	r0,@ADDR,+r3		; 2F B2 34

	eora	r0,@ADDR,-r0		; 2C D2 34
	eora	r0,@ADDR,-r1		; 2D D2 34
	eora	r0,@ADDR,-r2		; 2E D2 34
	eora	r0,@ADDR,-r3		; 2F D2 34

	eora	r0,@ADDR,r0		; 2C F2 34
	eora	r0,@ADDR,r1		; 2D F2 34
	eora	r0,@ADDR,r2		; 2E F2 34
	eora	r0,@ADDR,r3		; 2F F2 34


	.sbttl	'Sequential' Instruction Tests

	redc	r0			; 30
	redc	r1			; 31
	redc	r2			; 32
	redc	r3			; 33

	rete	.eq.			; 34
	rete	.gt.			; 35
	rete	.lt.			; 36
	rete	.un.			; 37

	rete	#DATA2 + 0		; 34
	rete	#DATA2 + 1		; 35
	rete	#DATA2 + 2		; 36
	rete	#DATA2 + 3		; 37

	.sbttl	bstr 'Sequential' Instruction Test

	bstr	.eq.,DISP		; 38 7E
	bstr	.gt.,DISP		; 39 7E
	bstr	.lt.,DISP		; 3A 7E
	bstr	.un.,DISP		; 3B 7E

	bstr	#DATA2 + 0,DISP		; 38 7E
	bstr	#DATA2 + 1,DISP		; 39 7E
	bstr	#DATA2 + 2,DISP		; 3A 7E
	bstr	#DATA2 + 3,DISP		; 3B 7E

	bstr	.eq.,[DISP]		; 38 FE
	bstr	.gt.,[DISP]		; 39 FE
	bstr	.lt.,[DISP]		; 3A FE
	bstr	.un.,[DISP]		; 3B FE

	bstr	#DATA2 + 0,[DISP]	; 38 FE
	bstr	#DATA2 + 1,[DISP]	; 39 FE
	bstr	#DATA2 + 2,[DISP]	; 3A FE
	bstr	#DATA2 + 3,[DISP]	; 3B FE

	bstr	.eq.,@DISP		; 38 FE
	bstr	.gt.,@DISP		; 39 FE
	bstr	.lt.,@DISP		; 3A FE
	bstr	.un.,@DISP		; 3B FE

	bstr	#DATA2 + 0,@DISP	; 38 FE
	bstr	#DATA2 + 1,@DISP	; 39 FE
	bstr	#DATA2 + 2,@DISP	; 3A FE
	bstr	#DATA2 + 3,@DISP	; 3B FE


	.sbttl	bsta 'Sequential' Instruction Test

	bsta	.eq.,BADD		; 3C 76 54
	bsta	.gt.,BADD		; 3D 76 54
	bsta	.lt.,BADD		; 3E 76 54
	bsta	.un.,BADD		; 3F 76 54

	bsta	#DATA2 + 0,BADD		; 3C 76 54
	bsta	#DATA2 + 1,BADD		; 3D 76 54
	bsta	#DATA2 + 2,BADD		; 3E 76 54
	bsta	#DATA2 + 3,BADD		; 3F 76 54

	bsta	.eq.,[BADD]		; 3C F6 54
	bsta	.gt.,[BADD]		; 3D F6 54
	bsta	.lt.,[BADD]		; 3E F6 54
	bsta	.un.,[BADD]		; 3F F6 54

	bsta	#DATA2 + 0,[BADD]	; 3C F6 54
	bsta	#DATA2 + 1,[BADD]	; 3D F6 54
	bsta	#DATA2 + 2,[BADD]	; 3E F6 54
	bsta	#DATA2 + 3,[BADD]	; 3F F6 54

	bsta	.eq.,@BADD		; 3C F6 54
	bsta	.gt.,@BADD		; 3D F6 54
	bsta	.lt.,@BADD		; 3E F6 54
	bsta	.un.,@BADD		; 3F F6 54

	bsta	#DATA2 + 0,@BADD	; 3C F6 54
	bsta	#DATA2 + 1,@BADD	; 3D F6 54
	bsta	#DATA2 + 2,@BADD	; 3E F6 54
	bsta	#DATA2 + 3,@BADD	; 3F F6 54


	.sbttl	and_ 'Sequential' Instruction Tests

	halt				; 40
	wait				; 40
;	andz	r0			; 40
	andz	r1			; 41
	andz	r2			; 42
	andz	r3			; 43
	andi	r0,#DATA8		; 44 21
	andi	r1,#DATA8		; 45 21
	andi	r2,#DATA8		; 46 21
	andi	r3,#DATA8		; 47 21
	andr	r0,DISP			; 48 7E
	andr	r1,DISP			; 49 7E
	andr	r2,DISP			; 4A 7E
	andr	r3,DISP			; 4B 7E
	anda	r0,ADDR			; 4C 12 34
	anda	r1,ADDR			; 4D 12 34
	anda	r2,ADDR			; 4E 12 34
	anda	r3,ADDR			; 4F 12 34

	.sbttl	and_ 'Default Indirect' Instruction Tests

	andr	r0,[DISP]		; 48 FE
	andr	r1,[DISP]		; 49 FE
	andr	r2,[DISP]		; 4A FE
	andr	r3,[DISP]		; 4B FE

	anda	r0,[ADDR]		; 4C 92 34
	anda	r1,[ADDR]		; 4D 92 34
	anda	r2,[ADDR]		; 4E 92 34
	anda	r3,[ADDR]		; 4F 92 34

	anda	r0,[ADDR,+r0]		; 4C B2 34
	anda	r0,[ADDR,+r1]		; 4D B2 34
	anda	r0,[ADDR,+r2]		; 4E B2 34
	anda	r0,[ADDR,+r3]		; 4F B2 34

	anda	r0,[ADDR,-r0]		; 4C D2 34
	anda	r0,[ADDR,-r1]		; 4D D2 34
	anda	r0,[ADDR,-r2]		; 4E D2 34
	anda	r0,[ADDR,-r3]		; 4F D2 34

	anda	r0,[ADDR,r0]		; 4C F2 34
	anda	r0,[ADDR,r1]		; 4D F2 34
	anda	r0,[ADDR,r2]		; 4E F2 34
	anda	r0,[ADDR,r3]		; 4F F2 34

	.sbttl	and_ 'Alternate Indirect' Instruction Tests

	andr	r0,@DISP		; 48 FE
	andr	r1,@DISP		; 49 FE
	andr	r2,@DISP		; 4A FE
	andr	r3,@DISP		; 4B FE

	anda	r0,@ADDR		; 4C 92 34
	anda	r1,@ADDR		; 4D 92 34
	anda	r2,@ADDR		; 4E 92 34
	anda	r3,@ADDR		; 4F 92 34

	anda	r0,@ADDR,+r0		; 4C B2 34
	anda	r0,@ADDR,+r1		; 4D B2 34
	anda	r0,@ADDR,+r2		; 4E B2 34
	anda	r0,@ADDR,+r3		; 4F B2 34

	anda	r0,@ADDR,-r0		; 4C D2 34
	anda	r0,@ADDR,-r1		; 4D D2 34
	anda	r0,@ADDR,-r2		; 4E D2 34
	anda	r0,@ADDR,-r3		; 4F D2 34

	anda	r0,@ADDR,r0		; 4C F2 34
	anda	r0,@ADDR,r1		; 4D F2 34
	anda	r0,@ADDR,r2		; 4E F2 34
	anda	r0,@ADDR,r3		; 4F F2 34


	.sbttl	'Sequential' Instruction Tests

	rrr	r0			; 50
	rrr	r1			; 51
	rrr	r2			; 52
	rrr	r3			; 53

	rede	r0,#P			; 54 98
	rede	r1,#P			; 55 98
	rede	r2,#P			; 56 98
	rede	r3,#P			; 57 98

	.sbttl	brnr 'Sequential' Instruction Test

	brnr	r0,DISP			; 58 7E
	brnr	r1,DISP			; 59 7E
	brnr	r2,DISP			; 5A 7E
	brnr	r3,DISP			; 5B 7E

	brnr	r0,[DISP]		; 58 FE
	brnr	r1,[DISP]		; 59 FE
	brnr	r2,[DISP]		; 5A FE
	brnr	r3,[DISP]		; 5B FE

	brnr	r0,@DISP		; 58 FE
	brnr	r1,@DISP		; 59 FE
	brnr	r2,@DISP		; 5A FE
	brnr	r3,@DISP		; 5B FE

 	.sbttl	brna 'Sequential' Instruction Test

	brna	r0,BADD			; 5C 76 54
	brna	r1,BADD			; 5D 76 54
	brna	r2,BADD			; 5E 76 54
	brna	r3,BADD			; 5F 76 54

	brna	r0,[BADD]		; 5C F6 54
	brna	r1,[BADD]		; 5D F6 54
	brna	r2,[BADD]		; 5E F6 54
	brna	r3,[BADD]		; 5F F6 54

	brna	r0,@BADD		; 5C F6 54
	brna	r1,@BADD		; 5D F6 54
	brna	r2,@BADD		; 5E F6 54
	brna	r3,@BADD		; 5F F6 54


	.sbttl	ior_ 'Sequential' Instruction Tests

	iorz	r0			; 60
	iorz	r1			; 61
	iorz	r2			; 62
	iorz	r3			; 63
	iori	r0,#DATA8		; 64 21
	iori	r1,#DATA8		; 65 21
	iori	r2,#DATA8		; 66 21
	iori	r3,#DATA8		; 67 21
	iorr	r0,DISP			; 68 7E
	iorr	r1,DISP			; 69 7E
	iorr	r2,DISP			; 6A 7E
	iorr	r3,DISP			; 6B 7E
	iora	r0,ADDR			; 6C 12 34
	iora	r1,ADDR			; 6D 12 34
	iora	r2,ADDR			; 6E 12 34
	iora	r3,ADDR			; 6F 12 34

	.sbttl	ior_ 'Default Indirect' Instruction Tests

	iorr	r0,[DISP]		; 68 FE
	iorr	r1,[DISP]		; 69 FE
	iorr	r2,[DISP]		; 6A FE
	iorr	r3,[DISP]		; 6B FE

	iora	r0,[ADDR]		; 6C 92 34
	iora	r1,[ADDR]		; 6D 92 34
	iora	r2,[ADDR]		; 6E 92 34
	iora	r3,[ADDR]		; 6F 92 34

	iora	r0,[ADDR,+r0]		; 6C B2 34
	iora	r0,[ADDR,+r1]		; 6D B2 34
	iora	r0,[ADDR,+r2]		; 6E B2 34
	iora	r0,[ADDR,+r3]		; 6F B2 34

	iora	r0,[ADDR,-r0]		; 6C D2 34
	iora	r0,[ADDR,-r1]		; 6D D2 34
	iora	r0,[ADDR,-r2]		; 6E D2 34
	iora	r0,[ADDR,-r3]		; 6F D2 34

	iora	r0,[ADDR,r0]		; 6C F2 34
	iora	r0,[ADDR,r1]		; 6D F2 34
	iora	r0,[ADDR,r2]		; 6E F2 34
	iora	r0,[ADDR,r3]		; 6F F2 34

	.sbttl	ior_ 'Alternate Indirect' Instruction Tests

	iorr	r0,@DISP		; 68 FE
	iorr	r1,@DISP		; 69 FE
	iorr	r2,@DISP		; 6A FE
	iorr	r3,@DISP		; 6B FE

	iora	r0,@ADDR		; 6C 92 34
	iora	r1,@ADDR		; 6D 92 34
	iora	r2,@ADDR		; 6E 92 34
	iora	r3,@ADDR		; 6F 92 34

	iora	r0,@ADDR,+r0		; 6C B2 34
	iora	r0,@ADDR,+r1		; 6D B2 34
	iora	r0,@ADDR,+r2		; 6E B2 34
	iora	r0,@ADDR,+r3		; 6F B2 34

	iora	r0,@ADDR,-r0		; 6C D2 34
	iora	r0,@ADDR,-r1		; 6D D2 34
	iora	r0,@ADDR,-r2		; 6E D2 34
	iora	r0,@ADDR,-r3		; 6F D2 34

	iora	r0,@ADDR,r0		; 6C F2 34
	iora	r0,@ADDR,r1		; 6D F2 34
	iora	r0,@ADDR,r2		; 6E F2 34
	iora	r0,@ADDR,r3		; 6F F2 34


	.sbttl	'Sequential' Instruction Tests

	redd	r0			; 70
	redd	r1			; 71
	redd	r2			; 72
	redd	r3			; 73

	cpsu	#DATA8			; 74 21
	cpsl	#DATA8			; 75 21
	ppsu	#DATA8			; 76 21
	ppsl	#DATA8			; 77 21

	.sbttl	bsnr 'Sequential' Instruction Test

	bsnr	r0,DISP			; 78 7E
	bsnr	r1,DISP			; 79 7E
	bsnr	r2,DISP			; 7A 7E
	bsnr	r3,DISP			; 7B 7E

	bsnr	r0,[DISP]		; 78 FE
	bsnr	r1,[DISP]		; 79 FE
	bsnr	r2,[DISP]		; 7A FE
	bsnr	r3,[DISP]		; 7B FE

	bsnr	r0,@DISP		; 78 FE
	bsnr	r1,@DISP		; 79 FE
	bsnr	r2,@DISP		; 7A FE
	bsnr	r3,@DISP		; 7B FE

 	.sbttl	bsna 'Sequential' Instruction Test

	bsna	r0,BADD			; 7C 76 54
	bsna	r1,BADD			; 7D 76 54
	bsna	r2,BADD			; 7E 76 54
	bsna	r3,BADD			; 7F 76 54

	bsna	r0,[BADD]		; 7C F6 54
	bsna	r1,[BADD]		; 7D F6 54
	bsna	r2,[BADD]		; 7E F6 54
	bsna	r3,[BADD]		; 7F F6 54

	bsna	r0,@BADD		; 7C F6 54
	bsna	r1,@BADD		; 7D F6 54
	bsna	r2,@BADD		; 7E F6 54
	bsna	r3,@BADD		; 7F F6 54


	.sbttl	add_ 'Sequential' Instruction Tests

	addz	r0			; 80
	addz	r1			; 81
	addz	r2			; 82
	addz	r3			; 83
	addi	r0,#DATA8		; 84 21
	addi	r1,#DATA8		; 85 21
	addi	r2,#DATA8		; 86 21
	addi	r3,#DATA8		; 87 21
	addr	r0,DISP			; 88 7E
	addr	r1,DISP			; 89 7E
	addr	r2,DISP			; 8A 7E
	addr	r3,DISP			; 8B 7E
	adda	r0,ADDR			; 8C 12 34
	adda	r1,ADDR			; 8D 12 34
	adda	r2,ADDR			; 8E 12 34
	adda	r3,ADDR			; 8F 12 34

	.sbttl	add_ 'Default Indirect' Instruction Tests

	addr	r0,[DISP]		; 88 FE
	addr	r1,[DISP]		; 89 FE
	addr	r2,[DISP]		; 8A FE
	addr	r3,[DISP]		; 8B FE

	adda	r0,[ADDR]		; 8C 92 34
	adda	r1,[ADDR]		; 8D 92 34
	adda	r2,[ADDR]		; 8E 92 34
	adda	r3,[ADDR]		; 8F 92 34

	adda	r0,[ADDR,+r0]		; 8C B2 34
	adda	r0,[ADDR,+r1]		; 8D B2 34
	adda	r0,[ADDR,+r2]		; 8E B2 34
	adda	r0,[ADDR,+r3]		; 8F B2 34

	adda	r0,[ADDR,-r0]		; 8C D2 34
	adda	r0,[ADDR,-r1]		; 8D D2 34
	adda	r0,[ADDR,-r2]		; 8E D2 34
	adda	r0,[ADDR,-r3]		; 8F D2 34

	adda	r0,[ADDR,r0]		; 8C F2 34
	adda	r0,[ADDR,r1]		; 8D F2 34
	adda	r0,[ADDR,r2]		; 8E F2 34
	adda	r0,[ADDR,r3]		; 8F F2 34

	.sbttl	add_ 'Alternate Indirect' Instruction Tests

	addr	r0,@DISP		; 88 FE
	addr	r1,@DISP		; 89 FE
	addr	r2,@DISP		; 8A FE
	addr	r3,@DISP		; 8B FE

	adda	r0,@ADDR		; 8C 92 34
	adda	r1,@ADDR		; 8D 92 34
	adda	r2,@ADDR		; 8E 92 34
	adda	r3,@ADDR		; 8F 92 34

	adda	r0,@ADDR,+r0		; 8C B2 34
	adda	r0,@ADDR,+r1		; 8D B2 34
	adda	r0,@ADDR,+r2		; 8E B2 34
	adda	r0,@ADDR,+r3		; 8F B2 34

	adda	r0,@ADDR,-r0		; 8C D2 34
	adda	r0,@ADDR,-r1		; 8D D2 34
	adda	r0,@ADDR,-r2		; 8E D2 34
	adda	r0,@ADDR,-r3		; 8F D2 34

	adda	r0,@ADDR,r0		; 8C F2 34
	adda	r0,@ADDR,r1		; 8D F2 34
	adda	r0,@ADDR,r2		; 8E F2 34
	adda	r0,@ADDR,r3		; 8F F2 34


	.sbttl	'Sequential' Instruction Tests

					; 90
					; 91
	lpsu				; 92
	lpsl				; 93

	dar	r0			; 94
	dar	r1			; 95
	dar	r2			; 96
	dar	r3			; 97

	.sbttl	bcfr 'Sequential' Instruction Test

	bcfr	.eq.,DISP		; 98 7E
	bcfr	.gt.,DISP		; 99 7E
	bcfr	.lt.,DISP		; 9A 7E
;	bcfr	.un.,DISP		; 9B 7E

	zbrr	DISP			; 9B 7E
	zbrr	[DISP]			; 9B FE
	zbrr	@DISP			; 9B FE

	bcfr	#DATA2 + 0,DISP		; 98 7E
	bcfr	#DATA2 + 1,DISP		; 99 7E
	bcfr	#DATA2 + 2,DISP		; 9A 7E
;	bcfr	#DATA2 + 3,DISP		; 9B 7E

	bcfr	.eq.,[DISP]		; 98 FE
	bcfr	.gt.,[DISP]		; 99 FE
	bcfr	.lt.,[DISP]		; 9A FE
;	bcfr	.un.,[DISP]		; 9B FE

	bcfr	#DATA2 + 0,[DISP]	; 98 FE
	bcfr	#DATA2 + 1,[DISP]	; 99 FE
	bcfr	#DATA2 + 2,[DISP]	; 9A FE
;	bcfr	#DATA2 + 3,[DISP]	; 9B FE

	bcfr	.eq.,@DISP		; 98 FE
	bcfr	.gt.,@DISP		; 99 FE
	bcfr	.lt.,@DISP		; 9A FE
;	bcfr	.un.,@DISP		; 9B FE

	bcfr	#DATA2 + 0,@DISP	; 98 FE
	bcfr	#DATA2 + 1,@DISP	; 99 FE
	bcfr	#DATA2 + 2,@DISP	; 9A FE
;	bcfr	#DATA2 + 3,@DISP	; 9B FE

	.sbttl	bcfa 'Sequential' Instruction Test

	bcfa	.eq.,BADD		; 9C 76 54
	bcfa	.gt.,BADD		; 9D 76 54
	bcfa	.lt.,BADD		; 9E 76 54
;	bcfa	.un.,BADD		; 9F 76 54

	bxa	BADD			; 9F 76 54
	bxa	[BADD]			; 9F F6 54
	bxa	@BADD			; 9F F6 54

	bcfa	#DATA2 + 0,BADD		; 9C 76 54
	bcfa	#DATA2 + 1,BADD		; 9D 76 54
	bcfa	#DATA2 + 2,BADD		; 9E 76 54
;	bcfa	#DATA2 + 3,BADD		; 9F 76 54

	bcfa	.eq.,[BADD]		; 9C F6 54
	bcfa	.gt.,[BADD]		; 9D F6 54
	bcfa	.lt.,[BADD]		; 9E F6 54
;	bcfa	.un.,[BADD]		; 9F F6 54

	bcfa	#DATA2 + 0,[BADD]	; 9C F6 54
	bcfa	#DATA2 + 1,[BADD]	; 9D F6 54
	bcfa	#DATA2 + 2,[BADD]	; 9E F6 54
;	bcfa	#DATA2 + 3,[BADD]	; 9F F6 54

	bcfa	.eq.,@BADD		; 9C F6 54
	bcfa	.gt.,@BADD		; 9D F6 54
	bcfa	.lt.,@BADD		; 9E F6 54
;	bcfa	.un.,@BADD		; 9F F6 54

	bcfa	#DATA2 + 0,@BADD	; 9C F6 54
	bcfa	#DATA2 + 1,@BADD	; 9D F6 54
	bcfa	#DATA2 + 2,@BADD	; 9E F6 54
;	bcfa	#DATA2 + 3,@BADD	; 9F F6 54


	.sbttl	sub_ 'Sequential' Instruction Tests

	subz	r0			; A0
	subz	r1			; A1
	subz	r2			; A2
	subz	r3			; A3
	subi	r0,#DATA8		; A4 21
	subi	r1,#DATA8		; A5 21
	subi	r2,#DATA8		; A6 21
	subi	r3,#DATA8		; A7 21
	subr	r0,DISP			; A8 7E
	subr	r1,DISP			; A9 7E
	subr	r2,DISP			; AA 7E
	subr	r3,DISP			; AB 7E
	suba	r0,ADDR			; AC 12 34
	suba	r1,ADDR			; AD 12 34
	suba	r2,ADDR			; AE 12 34
	suba	r3,ADDR			; AF 12 34

	.sbttl	sub_ 'Default Indirect' Instruction Tests

	subr	r0,[DISP]		; A8 FE
	subr	r1,[DISP]		; A9 FE
	subr	r2,[DISP]		; AA FE
	subr	r3,[DISP]		; AB FE

	suba	r0,[ADDR]		; AC 92 34
	suba	r1,[ADDR]		; AD 92 34
	suba	r2,[ADDR]		; AE 92 34
	suba	r3,[ADDR]		; AF 92 34

	suba	r0,[ADDR,+r0]		; AC B2 34
	suba	r0,[ADDR,+r1]		; AD B2 34
	suba	r0,[ADDR,+r2]		; AE B2 34
	suba	r0,[ADDR,+r3]		; AF B2 34

	suba	r0,[ADDR,-r0]		; AC D2 34
	suba	r0,[ADDR,-r1]		; AD D2 34
	suba	r0,[ADDR,-r2]		; AE D2 34
	suba	r0,[ADDR,-r3]		; AF D2 34

	suba	r0,[ADDR,r0]		; AC F2 34
	suba	r0,[ADDR,r1]		; AD F2 34
	suba	r0,[ADDR,r2]		; AE F2 34
	suba	r0,[ADDR,r3]		; AF F2 34

	.sbttl	sub_ 'Alternate Indirect' Instruction Tests

	subr	r0,@DISP		; A8 FE
	subr	r1,@DISP		; A9 FE
	subr	r2,@DISP		; AA FE
	subr	r3,@DISP		; AB FE

	suba	r0,@ADDR		; AC 92 34
	suba	r1,@ADDR		; AD 92 34
	suba	r2,@ADDR		; AE 92 34
	suba	r3,@ADDR		; AF 92 34

	suba	r0,@ADDR,+r0		; AC B2 34
	suba	r0,@ADDR,+r1		; AD B2 34
	suba	r0,@ADDR,+r2		; AE B2 34
	suba	r0,@ADDR,+r3		; AF B2 34

	suba	r0,@ADDR,-r0		; AC D2 34
	suba	r0,@ADDR,-r1		; AD D2 34
	suba	r0,@ADDR,-r2		; AE D2 34
	suba	r0,@ADDR,-r3		; AF D2 34

	suba	r0,@ADDR,r0		; AC F2 34
	suba	r0,@ADDR,r1		; AD F2 34
	suba	r0,@ADDR,r2		; AE F2 34
	suba	r0,@ADDR,r3		; AF F2 34


	.sbttl	'Sequential' Instruction Tests

	wrtc	r0			; B0
	wrtc	r1			; B1
	wrtc	r2			; B2
	wrtc	r3			; B3

	tpsu	#DATA8			; B4 21
	tpsl	#DATA8			; B5 21
					; B6
					; B7

	.sbttl	bsfr 'Sequential' Instruction Test

	bsfr	.eq.,DISP		; B8 7E
	bsfr	.gt.,DISP		; B9 7E
	bsfr	.lt.,DISP		; BA 7E
;	bsfr	.un.,DISP		; BB 7E

	zbsr	DISP			; BB 7E
	zbsr	[DISP]			; BB FE
	zbsr	@DISP			; BB FE

	bsfr	#DATA2 + 0,DISP		; B8 7E
	bsfr	#DATA2 + 1,DISP		; B9 7E
	bsfr	#DATA2 + 2,DISP		; BA 7E
;	bsfr	#DATA2 + 3,DISP		; BB 7E

	bsfr	.eq.,[DISP]		; B8 FE
	bsfr	.gt.,[DISP]		; B9 FE
	bsfr	.lt.,[DISP]		; BA FE
;	bsfr	.un.,[DISP]		; BB FE

	bsfr	#DATA2 + 0,[DISP]	; B8 FE
	bsfr	#DATA2 + 1,[DISP]	; B9 FE
	bsfr	#DATA2 + 2,[DISP]	; BA FE
;	bsfr	#DATA2 + 3,[DISP]	; BB FE

	bsfr	.eq.,@DISP		; B8 FE
	bsfr	.gt.,@DISP		; B9 FE
	bsfr	.lt.,@DISP		; BA FE
;	bsfr	.un.,@DISP		; BB FE

	bsfr	#DATA2 + 0,@DISP	; B8 FE
	bsfr	#DATA2 + 1,@DISP	; B9 FE
	bsfr	#DATA2 + 2,@DISP	; BA FE
;	bsfr	#DATA2 + 3,@DISP	; BB FE

	.sbttl	bsfa 'Sequential' Instruction Test

	bsfa	.eq.,BADD		; BC 76 54
	bsfa	.gt.,BADD		; BD 76 54
	bsfa	.lt.,BADD		; BE 76 54
;	bsfa	.un.,BADD		; BF 76 54

	bsxa	BADD			; BF 76 54
	bsxa	[BADD]			; BF F6 54
	bsxa	@BADD			; BF F6 54

	bsfa	#DATA2 + 0,BADD		; BC 76 54
	bsfa	#DATA2 + 1,BADD		; BD 76 54
	bsfa	#DATA2 + 2,BADD		; BE 76 54
;	bsfa	#DATA2 + 3,BADD		; BF 76 54

	bsfa	.eq.,[BADD]		; BC F6 54
	bsfa	.gt.,[BADD]		; BD F6 54
	bsfa	.lt.,[BADD]		; BE F6 54
;	bsfa	.un.,[BADD]		; BF F6 54

	bsfa	#DATA2 + 0,[BADD]	; BC F6 54
	bsfa	#DATA2 + 1,[BADD]	; BD F6 54
	bsfa	#DATA2 + 2,[BADD]	; BE F6 54
;	bsfa	#DATA2 + 3,[BADD]	; BF F6 54

	bsfa	.eq.,@BADD		; BC F6 54
	bsfa	.gt.,@BADD		; BD F6 54
	bsfa	.lt.,@BADD		; BE F6 54
;	bsfa	.un.,@BADD		; BF F6 54

	bsfa	#DATA2 + 0,@BADD	; BC F6 54
	bsfa	#DATA2 + 1,@BADD	; BD F6 54
	bsfa	#DATA2 + 2,@BADD	; BE F6 54
;	bsfa	#DATA2 + 3,@BADD	; BF F6 54


	.sbttl	str_ 'Sequential' Instruction Tests

	strz	r0			; C0
	strz	r1			; C1
	strz	r2			; C2
	strz	r3			; C3
;	stri	r0,#DATA8		; C4 21
;	stri	r1,#DATA8		; C5 21
;	stri	r2,#DATA8		; C6 21
;	stri	r3,#DATA8		; C7 21
	strr	r0,DISP			; C8 7E
	strr	r1,DISP			; C9 7E
	strr	r2,DISP			; CA 7E
	strr	r3,DISP			; CB 7E
	stra	r0,ADDR			; CC 12 34
	stra	r1,ADDR			; CD 12 34
	stra	r2,ADDR			; CE 12 34
	stra	r3,ADDR			; CF 12 34

	.sbttl	str_ 'Default Indirect' Instruction Tests

	strr	r0,[DISP]		; C8 FE
	strr	r1,[DISP]		; C9 FE
	strr	r2,[DISP]		; CA FE
	strr	r3,[DISP]		; CB FE

	stra	r0,[ADDR]		; CC 92 34
	stra	r1,[ADDR]		; CD 92 34
	stra	r2,[ADDR]		; CE 92 34
	stra	r3,[ADDR]		; CF 92 34

	stra	r0,[ADDR,+r0]		; CC B2 34
	stra	r0,[ADDR,+r1]		; CD B2 34
	stra	r0,[ADDR,+r2]		; CE B2 34
	stra	r0,[ADDR,+r3]		; CF B2 34

	stra	r0,[ADDR,-r0]		; CC D2 34
	stra	r0,[ADDR,-r1]		; CD D2 34
	stra	r0,[ADDR,-r2]		; CE D2 34
	stra	r0,[ADDR,-r3]		; CF D2 34

	stra	r0,[ADDR,r0]		; CC F2 34
	stra	r0,[ADDR,r1]		; CD F2 34
	stra	r0,[ADDR,r2]		; CE F2 34
	stra	r0,[ADDR,r3]		; CF F2 34

	.sbttl	str_ 'Alternate Indirect' Instruction Tests

	strr	r0,@DISP		; C8 FE
	strr	r1,@DISP		; C9 FE
	strr	r2,@DISP		; CA FE
	strr	r3,@DISP		; CB FE

	stra	r0,@ADDR		; CC 92 34
	stra	r1,@ADDR		; CD 92 34
	stra	r2,@ADDR		; CE 92 34
	stra	r3,@ADDR		; CF 92 34

	stra	r0,@ADDR,+r0		; CC B2 34
	stra	r0,@ADDR,+r1		; CD B2 34
	stra	r0,@ADDR,+r2		; CE B2 34
	stra	r0,@ADDR,+r3		; CF B2 34

	stra	r0,@ADDR,-r0		; CC D2 34
	stra	r0,@ADDR,-r1		; CD D2 34
	stra	r0,@ADDR,-r2		; CE D2 34
	stra	r0,@ADDR,-r3		; CF D2 34

	stra	r0,@ADDR,r0		; CC F2 34
	stra	r0,@ADDR,r1		; CD F2 34
	stra	r0,@ADDR,r2		; CE F2 34
	stra	r0,@ADDR,r3		; CF F2 34


	.sbttl	'Sequential' Instruction Tests

	rrl	r0			; D0
	rrl	r1			; D1
	rrl	r2			; D2
	rrl	r3			; D3

	wrte	r0,#P			; D4 98
	wrte	r1,#P			; D5 98
	wrte	r2,#P			; D6 98
	wrte	r3,#P			; D7 98

	.sbttl	birr 'Sequential' Instruction Test

	birr	r0,DISP			; D8 7E
	birr	r1,DISP			; D9 7E
	birr	r2,DISP			; DA 7E
	birr	r3,DISP			; DB 7E

	birr	r0,[DISP]		; D8 FE
	birr	r1,[DISP]		; D9 FE
	birr	r2,[DISP]		; DA FE
	birr	r3,[DISP]		; DB FE

	birr	r0,@DISP		; D8 FE
	birr	r1,@DISP		; D9 FE
	birr	r2,@DISP		; DA FE
	birr	r3,@DISP		; DB FE

 	.sbttl	bira 'Sequential' Instruction Test

	bira	r0,BADD			; DC 76 54
	bira	r1,BADD			; DD 76 54
	bira	r2,BADD			; DE 76 54
	bira	r3,BADD			; DF 76 54

	bira	r0,[BADD]		; DC F6 54
	bira	r1,[BADD]		; DD F6 54
	bira	r2,[BADD]		; DE F6 54
	bira	r3,[BADD]		; DF F6 54

	bira	r0,@BADD		; DC F6 54
	bira	r1,@BADD		; DD F6 54
	bira	r2,@BADD		; DE F6 54
	bira	r3,@BADD		; DF F6 54


	.sbttl	com_ 'Sequential' Instruction Tests

	comz	r0			; E0
	comz	r1			; E1
	comz	r2			; E2
	comz	r3			; E3
	comi	r0,#DATA8		; E4 21
	comi	r1,#DATA8		; E5 21
	comi	r2,#DATA8		; E6 21
	comi	r3,#DATA8		; E7 21
	comr	r0,DISP			; E8 7E
	comr	r1,DISP			; E9 7E
	comr	r2,DISP			; EA 7E
	comr	r3,DISP			; EB 7E
	coma	r0,ADDR			; EC 12 34
	coma	r1,ADDR			; ED 12 34
	coma	r2,ADDR			; EE 12 34
	coma	r3,ADDR			; EF 12 34

	.sbttl	com_ 'Default Indirect' Instruction Tests

	comr	r0,[DISP]		; E8 FE
	comr	r1,[DISP]		; E9 FE
	comr	r2,[DISP]		; EA FE
	comr	r3,[DISP]		; EB FE

	coma	r0,[ADDR]		; EC 92 34
	coma	r1,[ADDR]		; ED 92 34
	coma	r2,[ADDR]		; EE 92 34
	coma	r3,[ADDR]		; EF 92 34

	coma	r0,[ADDR,+r0]		; EC B2 34
	coma	r0,[ADDR,+r1]		; ED B2 34
	coma	r0,[ADDR,+r2]		; EE B2 34
	coma	r0,[ADDR,+r3]		; EF B2 34

	coma	r0,[ADDR,-r0]		; EC D2 34
	coma	r0,[ADDR,-r1]		; ED D2 34
	coma	r0,[ADDR,-r2]		; EE D2 34
	coma	r0,[ADDR,-r3]		; EF D2 34

	coma	r0,[ADDR,r0]		; EC F2 34
	coma	r0,[ADDR,r1]		; ED F2 34
	coma	r0,[ADDR,r2]		; EE F2 34
	coma	r0,[ADDR,r3]		; EF F2 34

	.sbttl	com_ 'Alternate Indirect' Instruction Tests

	comr	r0,@DISP		; E8 FE
	comr	r1,@DISP		; E9 FE
	comr	r2,@DISP		; EA FE
	comr	r3,@DISP		; EB FE

	coma	r0,@ADDR		; EC 92 34
	coma	r1,@ADDR		; ED 92 34
	coma	r2,@ADDR		; EE 92 34
	coma	r3,@ADDR		; EF 92 34

	coma	r0,@ADDR,+r0		; EC B2 34
	coma	r0,@ADDR,+r1		; ED B2 34
	coma	r0,@ADDR,+r2		; EE B2 34
	coma	r0,@ADDR,+r3		; EF B2 34

	coma	r0,@ADDR,-r0		; EC D2 34
	coma	r0,@ADDR,-r1		; ED D2 34
	coma	r0,@ADDR,-r2		; EE D2 34
	coma	r0,@ADDR,-r3		; EF D2 34

	coma	r0,@ADDR,r0		; EC F2 34
	coma	r0,@ADDR,r1		; ED F2 34
	coma	r0,@ADDR,r2		; EE F2 34
	coma	r0,@ADDR,r3		; EF F2 34


	.sbttl	cmp_ 'Sequential' Instruction Tests

	cmpz	r0			; E0
	cmpz	r1			; E1
	cmpz	r2			; E2
	cmpz	r3			; E3
	cmpi	r0,#DATA8		; E4 21
	cmpi	r1,#DATA8		; E5 21
	cmpi	r2,#DATA8		; E6 21
	cmpi	r3,#DATA8		; E7 21
	cmpr	r0,DISP			; E8 7E
	cmpr	r1,DISP			; E9 7E
	cmpr	r2,DISP			; EA 7E
	cmpr	r3,DISP			; EB 7E
	cmpa	r0,ADDR			; EC 12 34
	cmpa	r1,ADDR			; ED 12 34
	cmpa	r2,ADDR			; EE 12 34
	cmpa	r3,ADDR			; EF 12 34

	.sbttl	cmp_ 'Default Indirect' Instruction Tests

	cmpr	r0,[DISP]		; E8 FE
	cmpr	r1,[DISP]		; E9 FE
	cmpr	r2,[DISP]		; EA FE
	cmpr	r3,[DISP]		; EB FE

	cmpa	r0,[ADDR]		; EC 92 34
	cmpa	r1,[ADDR]		; ED 92 34
	cmpa	r2,[ADDR]		; EE 92 34
	cmpa	r3,[ADDR]		; EF 92 34

	cmpa	r0,[ADDR,+r0]		; EC B2 34
	cmpa	r0,[ADDR,+r1]		; ED B2 34
	cmpa	r0,[ADDR,+r2]		; EE B2 34
	cmpa	r0,[ADDR,+r3]		; EF B2 34

	cmpa	r0,[ADDR,-r0]		; EC D2 34
	cmpa	r0,[ADDR,-r1]		; ED D2 34
	cmpa	r0,[ADDR,-r2]		; EE D2 34
	cmpa	r0,[ADDR,-r3]		; EF D2 34

	cmpa	r0,[ADDR,r0]		; EC F2 34
	cmpa	r0,[ADDR,r1]		; ED F2 34
	cmpa	r0,[ADDR,r2]		; EE F2 34
	cmpa	r0,[ADDR,r3]		; EF F2 34

	.sbttl	cmp_ 'Alternate Indirect' Instruction Tests

	cmpr	r0,@DISP		; E8 FE
	cmpr	r1,@DISP		; E9 FE
	cmpr	r2,@DISP		; EA FE
	cmpr	r3,@DISP		; EB FE

	cmpa	r0,@ADDR		; EC 92 34
	cmpa	r1,@ADDR		; ED 92 34
	cmpa	r2,@ADDR		; EE 92 34
	cmpa	r3,@ADDR		; EF 92 34

	cmpa	r0,@ADDR,+r0		; EC B2 34
	cmpa	r0,@ADDR,+r1		; ED B2 34
	cmpa	r0,@ADDR,+r2		; EE B2 34
	cmpa	r0,@ADDR,+r3		; EF B2 34

	cmpa	r0,@ADDR,-r0		; EC D2 34
	cmpa	r0,@ADDR,-r1		; ED D2 34
	cmpa	r0,@ADDR,-r2		; EE D2 34
	cmpa	r0,@ADDR,-r3		; EF D2 34

	cmpa	r0,@ADDR,r0		; EC F2 34
	cmpa	r0,@ADDR,r1		; ED F2 34
	cmpa	r0,@ADDR,r2		; EE F2 34
	cmpa	r0,@ADDR,r3		; EF F2 34


	.sbttl	'Sequential' Instruction Tests

	wrtd	r0			; F0
	wrtd	r1			; F1
	wrtd	r2			; F2
	wrtd	r3			; F3

	tmi	r0,#P			; F4 98
	tmi	r1,#P			; F5 98
	tmi	r2,#P			; F6 98
	tmi	r3,#P			; F7 98

	.sbttl	bdrr 'Sequential' Instruction Test

	bdrr	r0,DISP			; F8 7E
	bdrr	r1,DISP			; F9 7E
	bdrr	r2,DISP			; FA 7E
	bdrr	r3,DISP			; FB 7E

	bdrr	r0,[DISP]		; F8 FE
	bdrr	r1,[DISP]		; F9 FE
	bdrr	r2,[DISP]		; FA FE
	bdrr	r3,[DISP]		; FB FE

	bdrr	r0,@DISP		; F8 FE
	bdrr	r1,@DISP		; F9 FE
	bdrr	r2,@DISP		; FA FE
	bdrr	r3,@DISP		; FB FE

 	.sbttl	bdra 'Sequential' Instruction Test

	bdra	r0,BADD			; FC 76 54
	bdra	r1,BADD			; FD 76 54
	bdra	r2,BADD			; FE 76 54
	bdra	r3,BADD			; FF 76 54

	bdra	r0,[BADD]		; FC F6 54
	bdra	r1,[BADD]		; FD F6 54
	bdra	r2,[BADD]		; FE F6 54
	bdra	r3,[BADD]		; FF F6 54

	bdra	r0,@BADD		; FC F6 54
	bdra	r1,@BADD		; FD F6 54
	bdra	r2,@BADD		; FE F6 54
	bdra	r3,@BADD		; FF F6 54



	.sbttl	Linked Code

	; External Variables

	.undefine	ADDR
	.undefine	BADD
	.undefine	DATA8
	.undefine	DATA2
	.undefine	P
	.undefine	DISP

	.define	ADDR	"0x1234 + xADDR"
	.define	BADD	"0x7654 + xBADD"
	.define	DATA8	"0x21 + xDATA8"
	.define	DATA2	"0 + xDATA2"
	.define	P	"0x98 + xP"
	.define	DISP	"."


	.area	AS2650	(ABS,OVR)
	.org	0x1000


	.sbttl	lod_ 'Sequential' Instruction Tests

;	lodz	r0			; 00
	lodz	r0			; 60
	lodz	r1			; 01
	lodz	r2			; 02
	lodz	r3			; 03
	lodi	r0,#DATA8		; 04r21
	lodi	r1,#DATA8		; 05r21
	lodi	r2,#DATA8		; 06r21
	lodi	r3,#DATA8		; 07r21
	lodr	r0,DISP			; 08 7E
	lodr	r1,DISP			; 09 7E
	lodr	r2,DISP			; 0A 7E
	lodr	r3,DISP			; 0B 7E
	loda	r0,ADDR			; 0Cs12r34
	loda	r1,ADDR			; 0Ds12r34
	loda	r2,ADDR			; 0Es12r34
	loda	r3,ADDR			; 0Fs12r34

	.sbttl	lod_ 'Default Indirect' Instruction Tests

	lodr	r0,[DISP]		; 08 FE
	lodr	r1,[DISP]		; 09 FE
	lodr	r2,[DISP]		; 0A FE
	lodr	r3,[DISP]		; 0B FE

	loda	r0,[ADDR]		; 0Cs92r34
	loda	r1,[ADDR]		; 0Ds92r34
	loda	r2,[ADDR]		; 0Es92r34
	loda	r3,[ADDR]		; 0Fs92r34

	loda	r0,[ADDR,+r0]		; 0CsB2r34
	loda	r0,[ADDR,+r1]		; 0DsB2r34
	loda	r0,[ADDR,+r2]		; 0EsB2r34
	loda	r0,[ADDR,+r3]		; 0FsB2r34

	loda	r0,[ADDR,-r0]		; 0CsD2r34
	loda	r0,[ADDR,-r1]		; 0DsD2r34
	loda	r0,[ADDR,-r2]		; 0EsD2r34
	loda	r0,[ADDR,-r3]		; 0FsD2r34

	loda	r0,[ADDR,r0]		; 0CsF2r34
	loda	r0,[ADDR,r1]		; 0DsF2r34
	loda	r0,[ADDR,r2]		; 0EsF2r34
	loda	r0,[ADDR,r3]		; 0FsF2r34

	.sbttl	lod_ 'Alternate Indirect' Instruction Tests

	lodr	r0,@DISP		; 08 FE
	lodr	r1,@DISP		; 09 FE
	lodr	r2,@DISP		; 0A FE
	lodr	r3,@DISP		; 0B FE

	loda	r0,@ADDR		; 0Cs92r34
	loda	r1,@ADDR		; 0Ds92r34
	loda	r2,@ADDR		; 0Es92r34
	loda	r3,@ADDR		; 0Fs92r34

	loda	r0,@ADDR,+r0		; 0CsB2r34
	loda	r0,@ADDR,+r1		; 0DsB2r34
	loda	r0,@ADDR,+r2		; 0EsB2r34
	loda	r0,@ADDR,+r3		; 0FsB2r34

	loda	r0,@ADDR,-r0		; 0CsD2r34
	loda	r0,@ADDR,-r1		; 0DsD2r34
	loda	r0,@ADDR,-r2		; 0EsD2r34
	loda	r0,@ADDR,-r3		; 0FsD2r34

	loda	r0,@ADDR,r0		; 0CsF2r34
	loda	r0,@ADDR,r1		; 0DsF2r34
	loda	r0,@ADDR,r2		; 0EsF2r34
	loda	r0,@ADDR,r3		; 0FsF2r34


	.sbttl	'Sequential' Instruction Tests

					; 10
					; 11
	spsu				; 12
	spsl				; 13

	retc	.eq.			; 14
	retc	.gt.			; 15
	retc	.lt.			; 16
	retc	.un.			; 17

	retc	#DATA2 + 0		;u14
	retc	#DATA2 + 1		;u15
	retc	#DATA2 + 2		;u16
	retc	#DATA2 + 3		;u17

	.sbttl	bctr 'Sequential' Instruction Test

	bctr	.eq.,DISP		; 18 7E
	bctr	.gt.,DISP		; 19 7E
	bctr	.lt.,DISP		; 1A 7E
	bctr	.un.,DISP		; 1B 7E

	bctr	#DATA2 + 0,DISP		;u18 7E
	bctr	#DATA2 + 1,DISP		;u19 7E
	bctr	#DATA2 + 2,DISP		;u1A 7E
	bctr	#DATA2 + 3,DISP		;u1B 7E

	bctr	.eq.,[DISP]		; 18 FE
	bctr	.gt.,[DISP]		; 19 FE
	bctr	.lt.,[DISP]		; 1A FE
	bctr	.un.,[DISP]		; 1B FE

	bctr	#DATA2 + 0,[DISP]	;u18 FE
	bctr	#DATA2 + 1,[DISP]	;u19 FE
	bctr	#DATA2 + 2,[DISP]	;u1A FE
	bctr	#DATA2 + 3,[DISP]	;u1B FE

	bctr	.eq.,@DISP		; 18 FE
	bctr	.gt.,@DISP		; 19 FE
	bctr	.lt.,@DISP		; 1A FE
	bctr	.un.,@DISP		; 1B FE

	bctr	#DATA2 + 0,@DISP	;u18 FE
	bctr	#DATA2 + 1,@DISP	;u19 FE
	bctr	#DATA2 + 2,@DISP	;u1A FE
	bctr	#DATA2 + 3,@DISP	;u1B FE


	.sbttl	bcta 'Sequential' Instruction Test

	bcta	.eq.,BADD		; 1Cv76u54
	bcta	.gt.,BADD		; 1Dv76u54
	bcta	.lt.,BADD		; 1Ev76u54
	bcta	.un.,BADD		; 1Fv76u54

	bcta	#DATA2 + 0,BADD		;u1Cv76u54
	bcta	#DATA2 + 1,BADD		;u1Dv76u54
	bcta	#DATA2 + 2,BADD		;u1Ev76u54
	bcta	#DATA2 + 3,BADD		;u1Fv76u54

	bcta	.eq.,[BADD]		; 1CvF6u54
	bcta	.gt.,[BADD]		; 1DvF6u54
	bcta	.lt.,[BADD]		; 1EvF6u54
	bcta	.un.,[BADD]		; 1FvF6u54

	bcta	#DATA2 + 0,[BADD]	;u1CvF6u54
	bcta	#DATA2 + 1,[BADD]	;u1DvF6u54
	bcta	#DATA2 + 2,[BADD]	;u1EvF6u54
	bcta	#DATA2 + 3,[BADD]	;u1FvF6u54

	bcta	.eq.,@BADD		; 1CvF6u54
	bcta	.gt.,@BADD		; 1DvF6u54
	bcta	.lt.,@BADD		; 1EvF6u54
	bcta	.un.,@BADD		; 1FvF6u54

	bcta	#DATA2 + 0,@BADD	;u1CvF6u54
	bcta	#DATA2 + 1,@BADD	;u1DvF6u54
	bcta	#DATA2 + 2,@BADD	;u1EvF6u54
	bcta	#DATA2 + 3,@BADD	;u1FvF6u54


	.sbttl	eor_ 'Sequential' Instruction Tests

	eorz	r0			; 20
	eorz	r1			; 21
	eorz	r2			; 22
	eorz	r3			; 23
	eori	r0,#DATA8		; 24r21
	eori	r1,#DATA8		; 25r21
	eori	r2,#DATA8		; 26r21
	eori	r3,#DATA8		; 27r21
	eorr	r0,DISP			; 28 7E
	eorr	r1,DISP			; 29 7E
	eorr	r2,DISP			; 2A 7E
	eorr	r3,DISP			; 2B 7E
	eora	r0,ADDR			; 2Cs12r34
	eora	r1,ADDR			; 2Ds12r34
	eora	r2,ADDR			; 2Es12r34
	eora	r3,ADDR			; 2Fs12r34

	.sbttl	eor_ 'Default Indirect' Instruction Tests

	eorr	r0,[DISP]		; 28 FE
	eorr	r1,[DISP]		; 29 FE
	eorr	r2,[DISP]		; 2A FE
	eorr	r3,[DISP]		; 2B FE

	eora	r0,[ADDR]		; 2Cs92r34
	eora	r1,[ADDR]		; 2Ds92r34
	eora	r2,[ADDR]		; 2Es92r34
	eora	r3,[ADDR]		; 2Fs92r34

	eora	r0,[ADDR,+r0]		; 2CsB2r34
	eora	r0,[ADDR,+r1]		; 2DsB2r34
	eora	r0,[ADDR,+r2]		; 2EsB2r34
	eora	r0,[ADDR,+r3]		; 2FsB2r34

	eora	r0,[ADDR,-r0]		; 2CsD2r34
	eora	r0,[ADDR,-r1]		; 2DsD2r34
	eora	r0,[ADDR,-r2]		; 2EsD2r34
	eora	r0,[ADDR,-r3]		; 2FsD2r34

	eora	r0,[ADDR,r0]		; 2CsF2r34
	eora	r0,[ADDR,r1]		; 2DsF2r34
	eora	r0,[ADDR,r2]		; 2EsF2r34
	eora	r0,[ADDR,r3]		; 2FsF2r34

	.sbttl	eor_ 'Alternate Indirect' Instruction Tests

	eorr	r0,@DISP		; 28 FE
	eorr	r1,@DISP		; 29 FE
	eorr	r2,@DISP		; 2A FE
	eorr	r3,@DISP		; 2B FE

	eora	r0,@ADDR		; 2Cs92r34
	eora	r1,@ADDR		; 2Ds92r34
	eora	r2,@ADDR		; 2Es92r34
	eora	r3,@ADDR		; 2Fs92r34

	eora	r0,@ADDR,+r0		; 2CsB2r34
	eora	r0,@ADDR,+r1		; 2DsB2r34
	eora	r0,@ADDR,+r2		; 2EsB2r34
	eora	r0,@ADDR,+r3		; 2FsB2r34

	eora	r0,@ADDR,-r0		; 2CsD2r34
	eora	r0,@ADDR,-r1		; 2DsD2r34
	eora	r0,@ADDR,-r2		; 2EsD2r34
	eora	r0,@ADDR,-r3		; 2FsD2r34

	eora	r0,@ADDR,r0		; 2CsF2r34
	eora	r0,@ADDR,r1		; 2DsF2r34
	eora	r0,@ADDR,r2		; 2EsF2r34
	eora	r0,@ADDR,r3		; 2FsF2r34


	.sbttl	'Sequential' Instruction Tests

	redc	r0			; 30
	redc	r1			; 31
	redc	r2			; 32
	redc	r3			; 33

	rete	.eq.			; 34
	rete	.gt.			; 35
	rete	.lt.			; 36
	rete	.un.			; 37

	rete	#DATA2 + 0		;u34
	rete	#DATA2 + 1		;u35
	rete	#DATA2 + 2		;u36
	rete	#DATA2 + 3		;u37

	.sbttl	bstr 'Sequential' Instruction Test

	bstr	.eq.,DISP		; 38 7E
	bstr	.gt.,DISP		; 39 7E
	bstr	.lt.,DISP		; 3A 7E
	bstr	.un.,DISP		; 3B 7E

	bstr	#DATA2 + 0,DISP		;u38 7E
	bstr	#DATA2 + 1,DISP		;u39 7E
	bstr	#DATA2 + 2,DISP		;u3A 7E
	bstr	#DATA2 + 3,DISP		;u3B 7E

	bstr	.eq.,[DISP]		; 38 FE
	bstr	.gt.,[DISP]		; 39 FE
	bstr	.lt.,[DISP]		; 3A FE
	bstr	.un.,[DISP]		; 3B FE

	bstr	#DATA2 + 0,[DISP]	;u38 FE
	bstr	#DATA2 + 1,[DISP]	;u39 FE
	bstr	#DATA2 + 2,[DISP]	;u3A FE
	bstr	#DATA2 + 3,[DISP]	;u3B FE

	bstr	.eq.,@DISP		; 38 FE
	bstr	.gt.,@DISP		; 39 FE
	bstr	.lt.,@DISP		; 3A FE
	bstr	.un.,@DISP		; 3B FE

	bstr	#DATA2 + 0,@DISP	;u38 FE
	bstr	#DATA2 + 1,@DISP	;u39 FE
	bstr	#DATA2 + 2,@DISP	;u3A FE
	bstr	#DATA2 + 3,@DISP	;u3B FE


	.sbttl	bsta 'Sequential' Instruction Test

	bsta	.eq.,BADD		; 3Cv76u54
	bsta	.gt.,BADD		; 3Dv76u54
	bsta	.lt.,BADD		; 3Ev76u54
	bsta	.un.,BADD		; 3Fv76u54

	bsta	#DATA2 + 0,BADD		;u3Cv76u54
	bsta	#DATA2 + 1,BADD		;u3Dv76u54
	bsta	#DATA2 + 2,BADD		;u3Ev76u54
	bsta	#DATA2 + 3,BADD		;u3Fv76u54

	bsta	.eq.,[BADD]		; 3CvF6u54
	bsta	.gt.,[BADD]		; 3DvF6u54
	bsta	.lt.,[BADD]		; 3EvF6u54
	bsta	.un.,[BADD]		; 3FvF6u54

	bsta	#DATA2 + 0,[BADD]	;u3CvF6u54
	bsta	#DATA2 + 1,[BADD]	;u3DvF6u54
	bsta	#DATA2 + 2,[BADD]	;u3EvF6u54
	bsta	#DATA2 + 3,[BADD]	;u3FvF6u54

	bsta	.eq.,@BADD		; 3CvF6u54
	bsta	.gt.,@BADD		; 3DvF6u54
	bsta	.lt.,@BADD		; 3EvF6u54
	bsta	.un.,@BADD		; 3FvF6u54

	bsta	#DATA2 + 0,@BADD	;u3CvF6u54
	bsta	#DATA2 + 1,@BADD	;u3DvF6u54
	bsta	#DATA2 + 2,@BADD	;u3EvF6u54
	bsta	#DATA2 + 3,@BADD	;u3FvF6u54


	.sbttl	and_ 'Sequential' Instruction Tests

	halt				; 40
	wait				; 40
;	andz	r0			; 40
	andz	r1			; 41
	andz	r2			; 42
	andz	r3			; 43
	andi	r0,#DATA8		; 44r21
	andi	r1,#DATA8		; 45r21
	andi	r2,#DATA8		; 46r21
	andi	r3,#DATA8		; 47r21
	andr	r0,DISP			; 48 7E
	andr	r1,DISP			; 49 7E
	andr	r2,DISP			; 4A 7E
	andr	r3,DISP			; 4B 7E
	anda	r0,ADDR			; 4Cs12r34
	anda	r1,ADDR			; 4Ds12r34
	anda	r2,ADDR			; 4Es12r34
	anda	r3,ADDR			; 4Fs12r34

	.sbttl	and_ 'Default Indirect' Instruction Tests

	andr	r0,[DISP]		; 48 FE
	andr	r1,[DISP]		; 49 FE
	andr	r2,[DISP]		; 4A FE
	andr	r3,[DISP]		; 4B FE

	anda	r0,[ADDR]		; 4Cs92r34
	anda	r1,[ADDR]		; 4Ds92r34
	anda	r2,[ADDR]		; 4Es92r34
	anda	r3,[ADDR]		; 4Fs92r34

	anda	r0,[ADDR,+r0]		; 4CsB2r34
	anda	r0,[ADDR,+r1]		; 4DsB2r34
	anda	r0,[ADDR,+r2]		; 4EsB2r34
	anda	r0,[ADDR,+r3]		; 4FsB2r34

	anda	r0,[ADDR,-r0]		; 4CsD2r34
	anda	r0,[ADDR,-r1]		; 4DsD2r34
	anda	r0,[ADDR,-r2]		; 4EsD2r34
	anda	r0,[ADDR,-r3]		; 4FsD2r34

	anda	r0,[ADDR,r0]		; 4CsF2r34
	anda	r0,[ADDR,r1]		; 4DsF2r34
	anda	r0,[ADDR,r2]		; 4EsF2r34
	anda	r0,[ADDR,r3]		; 4FsF2r34

	.sbttl	and_ 'Alternate Indirect' Instruction Tests

	andr	r0,@DISP		; 48 FE
	andr	r1,@DISP		; 49 FE
	andr	r2,@DISP		; 4A FE
	andr	r3,@DISP		; 4B FE

	anda	r0,@ADDR		; 4Cs92r34
	anda	r1,@ADDR		; 4Ds92r34
	anda	r2,@ADDR		; 4Es92r34
	anda	r3,@ADDR		; 4Fs92r34

	anda	r0,@ADDR,+r0		; 4CsB2r34
	anda	r0,@ADDR,+r1		; 4DsB2r34
	anda	r0,@ADDR,+r2		; 4EsB2r34
	anda	r0,@ADDR,+r3		; 4FsB2r34

	anda	r0,@ADDR,-r0		; 4CsD2r34
	anda	r0,@ADDR,-r1		; 4DsD2r34
	anda	r0,@ADDR,-r2		; 4EsD2r34
	anda	r0,@ADDR,-r3		; 4FsD2r34

	anda	r0,@ADDR,r0		; 4CsF2r34
	anda	r0,@ADDR,r1		; 4DsF2r34
	anda	r0,@ADDR,r2		; 4EsF2r34
	anda	r0,@ADDR,r3		; 4FsF2r34


	.sbttl	'Sequential' Instruction Tests

	rrr	r0			; 50
	rrr	r1			; 51
	rrr	r2			; 52
	rrr	r3			; 53

	rede	r0,#P			; 54r98
	rede	r1,#P			; 55r98
	rede	r2,#P			; 56r98
	rede	r3,#P			; 57r98

	.sbttl	brnr 'Sequential' Instruction Test

	brnr	r0,DISP			; 58 7E
	brnr	r1,DISP			; 59 7E
	brnr	r2,DISP			; 5A 7E
	brnr	r3,DISP			; 5B 7E

	brnr	r0,[DISP]		; 58 FE
	brnr	r1,[DISP]		; 59 FE
	brnr	r2,[DISP]		; 5A FE
	brnr	r3,[DISP]		; 5B FE

	brnr	r0,@DISP		; 58 FE
	brnr	r1,@DISP		; 59 FE
	brnr	r2,@DISP		; 5A FE
	brnr	r3,@DISP		; 5B FE

 	.sbttl	brna 'Sequential' Instruction Test

	brna	r0,BADD			; 5Cv76u54
	brna	r1,BADD			; 5Dv76u54
	brna	r2,BADD			; 5Ev76u54
	brna	r3,BADD			; 5Fv76u54

	brna	r0,[BADD]		; 5CvF6u54
	brna	r1,[BADD]		; 5DvF6u54
	brna	r2,[BADD]		; 5EvF6u54
	brna	r3,[BADD]		; 5FvF6u54

	brna	r0,@BADD		; 5CvF6u54
	brna	r1,@BADD		; 5DvF6u54
	brna	r2,@BADD		; 5EvF6u54
	brna	r3,@BADD		; 5FvF6u54


	.sbttl	ior_ 'Sequential' Instruction Tests

	iorz	r0			; 60
	iorz	r1			; 61
	iorz	r2			; 62
	iorz	r3			; 63
	iori	r0,#DATA8		; 64r21
	iori	r1,#DATA8		; 65r21
	iori	r2,#DATA8		; 66r21
	iori	r3,#DATA8		; 67r21
	iorr	r0,DISP			; 68 7E
	iorr	r1,DISP			; 69 7E
	iorr	r2,DISP			; 6A 7E
	iorr	r3,DISP			; 6B 7E
	iora	r0,ADDR			; 6Cs12r34
	iora	r1,ADDR			; 6Ds12r34
	iora	r2,ADDR			; 6Es12r34
	iora	r3,ADDR			; 6Fs12r34

	.sbttl	ior_ 'Default Indirect' Instruction Tests

	iorr	r0,[DISP]		; 68 FE
	iorr	r1,[DISP]		; 69 FE
	iorr	r2,[DISP]		; 6A FE
	iorr	r3,[DISP]		; 6B FE

	iora	r0,[ADDR]		; 6Cs92r34
	iora	r1,[ADDR]		; 6Ds92r34
	iora	r2,[ADDR]		; 6Es92r34
	iora	r3,[ADDR]		; 6Fs92r34

	iora	r0,[ADDR,+r0]		; 6CsB2r34
	iora	r0,[ADDR,+r1]		; 6DsB2r34
	iora	r0,[ADDR,+r2]		; 6EsB2r34
	iora	r0,[ADDR,+r3]		; 6FsB2r34

	iora	r0,[ADDR,-r0]		; 6CsD2r34
	iora	r0,[ADDR,-r1]		; 6DsD2r34
	iora	r0,[ADDR,-r2]		; 6EsD2r34
	iora	r0,[ADDR,-r3]		; 6FsD2r34

	iora	r0,[ADDR,r0]		; 6CsF2r34
	iora	r0,[ADDR,r1]		; 6DsF2r34
	iora	r0,[ADDR,r2]		; 6EsF2r34
	iora	r0,[ADDR,r3]		; 6FsF2r34

	.sbttl	ior_ 'Alternate Indirect' Instruction Tests

	iorr	r0,@DISP		; 68 FE
	iorr	r1,@DISP		; 69 FE
	iorr	r2,@DISP		; 6A FE
	iorr	r3,@DISP		; 6B FE

	iora	r0,@ADDR		; 6Cs92r34
	iora	r1,@ADDR		; 6Ds92r34
	iora	r2,@ADDR		; 6Es92r34
	iora	r3,@ADDR		; 6Fs92r34

	iora	r0,@ADDR,+r0		; 6CsB2r34
	iora	r0,@ADDR,+r1		; 6DsB2r34
	iora	r0,@ADDR,+r2		; 6EsB2r34
	iora	r0,@ADDR,+r3		; 6FsB2r34

	iora	r0,@ADDR,-r0		; 6CsD2r34
	iora	r0,@ADDR,-r1		; 6DsD2r34
	iora	r0,@ADDR,-r2		; 6EsD2r34
	iora	r0,@ADDR,-r3		; 6FsD2r34

	iora	r0,@ADDR,r0		; 6CsF2r34
	iora	r0,@ADDR,r1		; 6DsF2r34
	iora	r0,@ADDR,r2		; 6EsF2r34
	iora	r0,@ADDR,r3		; 6FsF2r34


	.sbttl	'Sequential' Instruction Tests

	redd	r0			; 70
	redd	r1			; 71
	redd	r2			; 72
	redd	r3			; 73

	cpsu	#DATA8			; 74r21
	cpsl	#DATA8			; 75r21
	ppsu	#DATA8			; 76r21
	ppsl	#DATA8			; 77r21

	.sbttl	bsnr 'Sequential' Instruction Test

	bsnr	r0,DISP			; 78 7E
	bsnr	r1,DISP			; 79 7E
	bsnr	r2,DISP			; 7A 7E
	bsnr	r3,DISP			; 7B 7E

	bsnr	r0,[DISP]		; 78 FE
	bsnr	r1,[DISP]		; 79 FE
	bsnr	r2,[DISP]		; 7A FE
	bsnr	r3,[DISP]		; 7B FE

	bsnr	r0,@DISP		; 78 FE
	bsnr	r1,@DISP		; 79 FE
	bsnr	r2,@DISP		; 7A FE
	bsnr	r3,@DISP		; 7B FE

 	.sbttl	bsna 'Sequential' Instruction Test

	bsna	r0,BADD			; 7Cv76u54
	bsna	r1,BADD			; 7Dv76u54
	bsna	r2,BADD			; 7Ev76u54
	bsna	r3,BADD			; 7Fv76u54

	bsna	r0,[BADD]		; 7CvF6u54
	bsna	r1,[BADD]		; 7DvF6u54
	bsna	r2,[BADD]		; 7EvF6u54
	bsna	r3,[BADD]		; 7FvF6u54

	bsna	r0,@BADD		; 7CvF6u54
	bsna	r1,@BADD		; 7DvF6u54
	bsna	r2,@BADD		; 7EvF6u54
	bsna	r3,@BADD		; 7FvF6u54


	.sbttl	add_ 'Sequential' Instruction Tests

	addz	r0			; 80
	addz	r1			; 81
	addz	r2			; 82
	addz	r3			; 83
	addi	r0,#DATA8		; 84r21
	addi	r1,#DATA8		; 85r21
	addi	r2,#DATA8		; 86r21
	addi	r3,#DATA8		; 87r21
	addr	r0,DISP			; 88 7E
	addr	r1,DISP			; 89 7E
	addr	r2,DISP			; 8A 7E
	addr	r3,DISP			; 8B 7E
	adda	r0,ADDR			; 8Cs12r34
	adda	r1,ADDR			; 8Ds12r34
	adda	r2,ADDR			; 8Es12r34
	adda	r3,ADDR			; 8Fs12r34

	.sbttl	add_ 'Default Indirect' Instruction Tests

	addr	r0,[DISP]		; 88 FE
	addr	r1,[DISP]		; 89 FE
	addr	r2,[DISP]		; 8A FE
	addr	r3,[DISP]		; 8B FE

	adda	r0,[ADDR]		; 8Cs92r34
	adda	r1,[ADDR]		; 8Ds92r34
	adda	r2,[ADDR]		; 8Es92r34
	adda	r3,[ADDR]		; 8Fs92r34

	adda	r0,[ADDR,+r0]		; 8CsB2r34
	adda	r0,[ADDR,+r1]		; 8DsB2r34
	adda	r0,[ADDR,+r2]		; 8EsB2r34
	adda	r0,[ADDR,+r3]		; 8FsB2r34

	adda	r0,[ADDR,-r0]		; 8CsD2r34
	adda	r0,[ADDR,-r1]		; 8DsD2r34
	adda	r0,[ADDR,-r2]		; 8EsD2r34
	adda	r0,[ADDR,-r3]		; 8FsD2r34

	adda	r0,[ADDR,r0]		; 8CsF2r34
	adda	r0,[ADDR,r1]		; 8DsF2r34
	adda	r0,[ADDR,r2]		; 8EsF2r34
	adda	r0,[ADDR,r3]		; 8FsF2r34

	.sbttl	add_ 'Alternate Indirect' Instruction Tests

	addr	r0,@DISP		; 88 FE
	addr	r1,@DISP		; 89 FE
	addr	r2,@DISP		; 8A FE
	addr	r3,@DISP		; 8B FE

	adda	r0,@ADDR		; 8Cs92r34
	adda	r1,@ADDR		; 8Ds92r34
	adda	r2,@ADDR		; 8Es92r34
	adda	r3,@ADDR		; 8Fs92r34

	adda	r0,@ADDR,+r0		; 8CsB2r34
	adda	r0,@ADDR,+r1		; 8DsB2r34
	adda	r0,@ADDR,+r2		; 8EsB2r34
	adda	r0,@ADDR,+r3		; 8FsB2r34

	adda	r0,@ADDR,-r0		; 8CsD2r34
	adda	r0,@ADDR,-r1		; 8DsD2r34
	adda	r0,@ADDR,-r2		; 8EsD2r34
	adda	r0,@ADDR,-r3		; 8FsD2r34

	adda	r0,@ADDR,r0		; 8CsF2r34
	adda	r0,@ADDR,r1		; 8DsF2r34
	adda	r0,@ADDR,r2		; 8EsF2r34
	adda	r0,@ADDR,r3		; 8FsF2r34


	.sbttl	'Sequential' Instruction Tests

					; 90
					; 91
	lpsu				; 92
	lpsl				; 93

	dar	r0			; 94
	dar	r1			; 95
	dar	r2			; 96
	dar	r3			; 97

	.sbttl	bcfr 'Sequential' Instruction Test

	bcfr	.eq.,DISP		; 98 7E
	bcfr	.gt.,DISP		; 99 7E
	bcfr	.lt.,DISP		; 9A 7E
;	bcfr	.un.,DISP		; 9B 7E

	zbrr	DISP			; 9B 7E
	zbrr	[DISP]			; 9B FE
	zbrr	@DISP			; 9B FE

	bcfr	#DATA2 + 0,DISP		;u98 7E
	bcfr	#DATA2 + 1,DISP		;u99 7E
	bcfr	#DATA2 + 2,DISP		;u9A 7E
;	bcfr	#DATA2 + 3,DISP		;u9B 7E

	bcfr	.eq.,[DISP]		; 98 FE
	bcfr	.gt.,[DISP]		; 99 FE
	bcfr	.lt.,[DISP]		; 9A FE
;	bcfr	.un.,[DISP]		; 9B FE

	bcfr	#DATA2 + 0,[DISP]	;u98 FE
	bcfr	#DATA2 + 1,[DISP]	;u99 FE
	bcfr	#DATA2 + 2,[DISP]	;u9A FE
;	bcfr	#DATA2 + 3,[DISP]	;u9B FE

	bcfr	.eq.,@DISP		; 98 FE
	bcfr	.gt.,@DISP		; 99 FE
	bcfr	.lt.,@DISP		; 9A FE
;	bcfr	.un.,@DISP		; 9B FE

	bcfr	#DATA2 + 0,@DISP	;u98 FE
	bcfr	#DATA2 + 1,@DISP	;u99 FE
	bcfr	#DATA2 + 2,@DISP	;u9A FE
;	bcfr	#DATA2 + 3,@DISP	;u9B FE

	.sbttl	bcfa 'Sequential' Instruction Test

	bcfa	.eq.,BADD		; 9Cv76u54
	bcfa	.gt.,BADD		; 9Dv76u54
	bcfa	.lt.,BADD		; 9Ev76u54
;	bcfa	.un.,BADD		; 9Fv76u54

	bxa	BADD			; 9Fv76u54
	bxa	[BADD]			; 9FvF6u54
	bxa	@BADD			; 9FvF6u54

	bcfa	#DATA2 + 0,BADD		;u9Cv76u54
	bcfa	#DATA2 + 1,BADD		;u9Dv76u54
	bcfa	#DATA2 + 2,BADD		;u9Ev76u54
;	bcfa	#DATA2 + 3,BADD		;u9Fv76u54

	bcfa	.eq.,[BADD]		; 9CvF6u54
	bcfa	.gt.,[BADD]		; 9DvF6u54
	bcfa	.lt.,[BADD]		; 9EvF6u54
;	bcfa	.un.,[BADD]		; 9FvF6u54

	bcfa	#DATA2 + 0,[BADD]	;u9CvF6u54
	bcfa	#DATA2 + 1,[BADD]	;u9DvF6u54
	bcfa	#DATA2 + 2,[BADD]	;u9EvF6u54
;	bcfa	#DATA2 + 3,[BADD]	;u9FvF6u54

	bcfa	.eq.,@BADD		; 9CvF6u54
	bcfa	.gt.,@BADD		; 9DvF6u54
	bcfa	.lt.,@BADD		; 9EvF6u54
;	bcfa	.un.,@BADD		; 9FvF6u54

	bcfa	#DATA2 + 0,@BADD	;u9CvF6u54
	bcfa	#DATA2 + 1,@BADD	;u9DvF6u54
	bcfa	#DATA2 + 2,@BADD	;u9EvF6u54
;	bcfa	#DATA2 + 3,@BADD	;u9FvF6u54


	.sbttl	sub_ 'Sequential' Instruction Tests

	subz	r0			; A0
	subz	r1			; A1
	subz	r2			; A2
	subz	r3			; A3
	subi	r0,#DATA8		; A4r21
	subi	r1,#DATA8		; A5r21
	subi	r2,#DATA8		; A6r21
	subi	r3,#DATA8		; A7r21
	subr	r0,DISP			; A8 7E
	subr	r1,DISP			; A9 7E
	subr	r2,DISP			; AA 7E
	subr	r3,DISP			; AB 7E
	suba	r0,ADDR			; ACs12r34
	suba	r1,ADDR			; ADs12r34
	suba	r2,ADDR			; AEs12r34
	suba	r3,ADDR			; AFs12r34

	.sbttl	sub_ 'Default Indirect' Instruction Tests

	subr	r0,[DISP]		; A8 FE
	subr	r1,[DISP]		; A9 FE
	subr	r2,[DISP]		; AA FE
	subr	r3,[DISP]		; AB FE

	suba	r0,[ADDR]		; ACs92r34
	suba	r1,[ADDR]		; ADs92r34
	suba	r2,[ADDR]		; AEs92r34
	suba	r3,[ADDR]		; AFs92r34

	suba	r0,[ADDR,+r0]		; ACsB2r34
	suba	r0,[ADDR,+r1]		; ADsB2r34
	suba	r0,[ADDR,+r2]		; AEsB2r34
	suba	r0,[ADDR,+r3]		; AFsB2r34

	suba	r0,[ADDR,-r0]		; ACsD2r34
	suba	r0,[ADDR,-r1]		; ADsD2r34
	suba	r0,[ADDR,-r2]		; AEsD2r34
	suba	r0,[ADDR,-r3]		; AFsD2r34

	suba	r0,[ADDR,r0]		; ACsF2r34
	suba	r0,[ADDR,r1]		; ADsF2r34
	suba	r0,[ADDR,r2]		; AEsF2r34
	suba	r0,[ADDR,r3]		; AFsF2r34

	.sbttl	sub_ 'Alternate Indirect' Instruction Tests

	subr	r0,@DISP		; A8 FE
	subr	r1,@DISP		; A9 FE
	subr	r2,@DISP		; AA FE
	subr	r3,@DISP		; AB FE

	suba	r0,@ADDR		; ACs92r34
	suba	r1,@ADDR		; ADs92r34
	suba	r2,@ADDR		; AEs92r34
	suba	r3,@ADDR		; AFs92r34

	suba	r0,@ADDR,+r0		; ACsB2r34
	suba	r0,@ADDR,+r1		; ADsB2r34
	suba	r0,@ADDR,+r2		; AEsB2r34
	suba	r0,@ADDR,+r3		; AFsB2r34

	suba	r0,@ADDR,-r0		; ACsD2r34
	suba	r0,@ADDR,-r1		; ADsD2r34
	suba	r0,@ADDR,-r2		; AEsD2r34
	suba	r0,@ADDR,-r3		; AFsD2r34

	suba	r0,@ADDR,r0		; ACsF2r34
	suba	r0,@ADDR,r1		; ADsF2r34
	suba	r0,@ADDR,r2		; AEsF2r34
	suba	r0,@ADDR,r3		; AFsF2r34


	.sbttl	'Sequential' Instruction Tests

	wrtc	r0			; B0
	wrtc	r1			; B1
	wrtc	r2			; B2
	wrtc	r3			; B3

	tpsu	#DATA8			; B4r21
	tpsl	#DATA8			; B5r21
					; B6
					; B7

	.sbttl	bsfr 'Sequential' Instruction Test

	bsfr	.eq.,DISP		; B8 7E
	bsfr	.gt.,DISP		; B9 7E
	bsfr	.lt.,DISP		; BA 7E
;	bsfr	.un.,DISP		; BB 7E

	zbsr	DISP			; BB 7E
	zbsr	[DISP]			; BB FE
	zbsr	@DISP			; BB FE

	bsfr	#DATA2 + 0,DISP		;uB8 7E
	bsfr	#DATA2 + 1,DISP		;uB9 7E
	bsfr	#DATA2 + 2,DISP		;uBA 7E
;	bsfr	#DATA2 + 3,DISP		;uBB 7E

	bsfr	.eq.,[DISP]		; B8 FE
	bsfr	.gt.,[DISP]		; B9 FE
	bsfr	.lt.,[DISP]		; BA FE
;	bsfr	.un.,[DISP]		; BB FE

	bsfr	#DATA2 + 0,[DISP]	;uB8 FE
	bsfr	#DATA2 + 1,[DISP]	;uB9 FE
	bsfr	#DATA2 + 2,[DISP]	;uBA FE
;	bsfr	#DATA2 + 3,[DISP]	;uBB FE

	bsfr	.eq.,@DISP		; B8 FE
	bsfr	.gt.,@DISP		; B9 FE
	bsfr	.lt.,@DISP		; BA FE
;	bsfr	.un.,@DISP		; BB FE

	bsfr	#DATA2 + 0,@DISP	;uB8 FE
	bsfr	#DATA2 + 1,@DISP	;uB9 FE
	bsfr	#DATA2 + 2,@DISP	;uBA FE
;	bsfr	#DATA2 + 3,@DISP	;uBB FE

	.sbttl	bsfa 'Sequential' Instruction Test

	bsfa	.eq.,BADD		; BCv76u54
	bsfa	.gt.,BADD		; BDv76u54
	bsfa	.lt.,BADD		; BEv76u54
;	bsfa	.un.,BADD		; BFv76u54

	bsxa	BADD			; BFv76u54
	bsxa	[BADD]			; BFvF6u54
	bsxa	@BADD			; BFvF6u54

	bsfa	#DATA2 + 0,BADD		;uBCv76u54
	bsfa	#DATA2 + 1,BADD		;uBDv76u54
	bsfa	#DATA2 + 2,BADD		;uBEv76u54
;	bsfa	#DATA2 + 3,BADD		;uBFv76u54

	bsfa	.eq.,[BADD]		; BCvF6u54
	bsfa	.gt.,[BADD]		; BDvF6u54
	bsfa	.lt.,[BADD]		; BEvF6u54
;	bsfa	.un.,[BADD]		; BFvF6u54

	bsfa	#DATA2 + 0,[BADD]	;uBCvF6u54
	bsfa	#DATA2 + 1,[BADD]	;uBDvF6u54
	bsfa	#DATA2 + 2,[BADD]	;uBEvF6u54
;	bsfa	#DATA2 + 3,[BADD]	;uBFvF6u54

	bsfa	.eq.,@BADD		; BCvF6u54
	bsfa	.gt.,@BADD		; BDvF6u54
	bsfa	.lt.,@BADD		; BEvF6u54
;	bsfa	.un.,@BADD		; BFvF6u54

	bsfa	#DATA2 + 0,@BADD	;uBCvF6u54
	bsfa	#DATA2 + 1,@BADD	;uBDvF6u54
	bsfa	#DATA2 + 2,@BADD	;uBEvF6u54
;	bsfa	#DATA2 + 3,@BADD	;uBFvF6u54


	.sbttl	str_ 'Sequential' Instruction Tests

	strz	r0			; C0
	strz	r1			; C1
	strz	r2			; C2
	strz	r3			; C3
;	stri	r0,#DATA8		; C4r21
;	stri	r1,#DATA8		; C5r21
;	stri	r2,#DATA8		; C6r21
;	stri	r3,#DATA8		; C7r21
	strr	r0,DISP			; C8 7E
	strr	r1,DISP			; C9 7E
	strr	r2,DISP			; CA 7E
	strr	r3,DISP			; CB 7E
	stra	r0,ADDR			; CCs12r34
	stra	r1,ADDR			; CDs12r34
	stra	r2,ADDR			; CEs12r34
	stra	r3,ADDR			; CFs12r34

	.sbttl	str_ 'Default Indirect' Instruction Tests

	strr	r0,[DISP]		; C8 FE
	strr	r1,[DISP]		; C9 FE
	strr	r2,[DISP]		; CA FE
	strr	r3,[DISP]		; CB FE

	stra	r0,[ADDR]		; CCs92r34
	stra	r1,[ADDR]		; CDs92r34
	stra	r2,[ADDR]		; CEs92r34
	stra	r3,[ADDR]		; CFs92r34

	stra	r0,[ADDR,+r0]		; CCsB2r34
	stra	r0,[ADDR,+r1]		; CDsB2r34
	stra	r0,[ADDR,+r2]		; CEsB2r34
	stra	r0,[ADDR,+r3]		; CFsB2r34

	stra	r0,[ADDR,-r0]		; CCsD2r34
	stra	r0,[ADDR,-r1]		; CDsD2r34
	stra	r0,[ADDR,-r2]		; CEsD2r34
	stra	r0,[ADDR,-r3]		; CFsD2r34

	stra	r0,[ADDR,r0]		; CCsF2r34
	stra	r0,[ADDR,r1]		; CDsF2r34
	stra	r0,[ADDR,r2]		; CEsF2r34
	stra	r0,[ADDR,r3]		; CFsF2r34

	.sbttl	str_ 'Alternate Indirect' Instruction Tests

	strr	r0,@DISP		; C8 FE
	strr	r1,@DISP		; C9 FE
	strr	r2,@DISP		; CA FE
	strr	r3,@DISP		; CB FE

	stra	r0,@ADDR		; CCs92r34
	stra	r1,@ADDR		; CDs92r34
	stra	r2,@ADDR		; CEs92r34
	stra	r3,@ADDR		; CFs92r34

	stra	r0,@ADDR,+r0		; CCsB2r34
	stra	r0,@ADDR,+r1		; CDsB2r34
	stra	r0,@ADDR,+r2		; CEsB2r34
	stra	r0,@ADDR,+r3		; CFsB2r34

	stra	r0,@ADDR,-r0		; CCsD2r34
	stra	r0,@ADDR,-r1		; CDsD2r34
	stra	r0,@ADDR,-r2		; CEsD2r34
	stra	r0,@ADDR,-r3		; CFsD2r34

	stra	r0,@ADDR,r0		; CCsF2r34
	stra	r0,@ADDR,r1		; CDsF2r34
	stra	r0,@ADDR,r2		; CEsF2r34
	stra	r0,@ADDR,r3		; CFsF2r34


	.sbttl	'Sequential' Instruction Tests

	rrl	r0			; D0
	rrl	r1			; D1
	rrl	r2			; D2
	rrl	r3			; D3

	wrte	r0,#P			; D4r98
	wrte	r1,#P			; D5r98
	wrte	r2,#P			; D6r98
	wrte	r3,#P			; D7r98

	.sbttl	birr 'Sequential' Instruction Test

	birr	r0,DISP			; D8 7E
	birr	r1,DISP			; D9 7E
	birr	r2,DISP			; DA 7E
	birr	r3,DISP			; DB 7E

	birr	r0,[DISP]		; D8 FE
	birr	r1,[DISP]		; D9 FE
	birr	r2,[DISP]		; DA FE
	birr	r3,[DISP]		; DB FE

	birr	r0,@DISP		; D8 FE
	birr	r1,@DISP		; D9 FE
	birr	r2,@DISP		; DA FE
	birr	r3,@DISP		; DB FE

 	.sbttl	bira 'Sequential' Instruction Test

	bira	r0,BADD			; DCv76u54
	bira	r1,BADD			; DDv76u54
	bira	r2,BADD			; DEv76u54
	bira	r3,BADD			; DFv76u54

	bira	r0,[BADD]		; DCvF6u54
	bira	r1,[BADD]		; DDvF6u54
	bira	r2,[BADD]		; DEvF6u54
	bira	r3,[BADD]		; DFvF6u54

	bira	r0,@BADD		; DCvF6u54
	bira	r1,@BADD		; DDvF6u54
	bira	r2,@BADD		; DEvF6u54
	bira	r3,@BADD		; DFvF6u54


	.sbttl	com_ 'Sequential' Instruction Tests

	comz	r0			; E0
	comz	r1			; E1
	comz	r2			; E2
	comz	r3			; E3
	comi	r0,#DATA8		; E4r21
	comi	r1,#DATA8		; E5r21
	comi	r2,#DATA8		; E6r21
	comi	r3,#DATA8		; E7r21
	comr	r0,DISP			; E8 7E
	comr	r1,DISP			; E9 7E
	comr	r2,DISP			; EA 7E
	comr	r3,DISP			; EB 7E
	coma	r0,ADDR			; ECs12r34
	coma	r1,ADDR			; EDs12r34
	coma	r2,ADDR			; EEs12r34
	coma	r3,ADDR			; EFs12r34

	.sbttl	com_ 'Default Indirect' Instruction Tests

	comr	r0,[DISP]		; E8 FE
	comr	r1,[DISP]		; E9 FE
	comr	r2,[DISP]		; EA FE
	comr	r3,[DISP]		; EB FE

	coma	r0,[ADDR]		; ECs92r34
	coma	r1,[ADDR]		; EDs92r34
	coma	r2,[ADDR]		; EEs92r34
	coma	r3,[ADDR]		; EFs92r34

	coma	r0,[ADDR,+r0]		; ECsB2r34
	coma	r0,[ADDR,+r1]		; EDsB2r34
	coma	r0,[ADDR,+r2]		; EEsB2r34
	coma	r0,[ADDR,+r3]		; EFsB2r34

	coma	r0,[ADDR,-r0]		; ECsD2r34
	coma	r0,[ADDR,-r1]		; EDsD2r34
	coma	r0,[ADDR,-r2]		; EEsD2r34
	coma	r0,[ADDR,-r3]		; EFsD2r34

	coma	r0,[ADDR,r0]		; ECsF2r34
	coma	r0,[ADDR,r1]		; EDsF2r34
	coma	r0,[ADDR,r2]		; EEsF2r34
	coma	r0,[ADDR,r3]		; EFsF2r34

	.sbttl	com_ 'Alternate Indirect' Instruction Tests

	comr	r0,@DISP		; E8 FE
	comr	r1,@DISP		; E9 FE
	comr	r2,@DISP		; EA FE
	comr	r3,@DISP		; EB FE

	coma	r0,@ADDR		; ECs92r34
	coma	r1,@ADDR		; EDs92r34
	coma	r2,@ADDR		; EEs92r34
	coma	r3,@ADDR		; EFs92r34

	coma	r0,@ADDR,+r0		; ECsB2r34
	coma	r0,@ADDR,+r1		; EDsB2r34
	coma	r0,@ADDR,+r2		; EEsB2r34
	coma	r0,@ADDR,+r3		; EFsB2r34

	coma	r0,@ADDR,-r0		; ECsD2r34
	coma	r0,@ADDR,-r1		; EDsD2r34
	coma	r0,@ADDR,-r2		; EEsD2r34
	coma	r0,@ADDR,-r3		; EFsD2r34

	coma	r0,@ADDR,r0		; ECsF2r34
	coma	r0,@ADDR,r1		; EDsF2r34
	coma	r0,@ADDR,r2		; EEsF2r34
	coma	r0,@ADDR,r3		; EFsF2r34


	.sbttl	cmp_ 'Sequential' Instruction Tests

	cmpz	r0			; E0
	cmpz	r1			; E1
	cmpz	r2			; E2
	cmpz	r3			; E3
	cmpi	r0,#DATA8		; E4r21
	cmpi	r1,#DATA8		; E5r21
	cmpi	r2,#DATA8		; E6r21
	cmpi	r3,#DATA8		; E7r21
	cmpr	r0,DISP			; E8 7E
	cmpr	r1,DISP			; E9 7E
	cmpr	r2,DISP			; EA 7E
	cmpr	r3,DISP			; EB 7E
	cmpa	r0,ADDR			; ECs12r34
	cmpa	r1,ADDR			; EDs12r34
	cmpa	r2,ADDR			; EEs12r34
	cmpa	r3,ADDR			; EFs12r34

	.sbttl	cmp_ 'Default Indirect' Instruction Tests

	cmpr	r0,[DISP]		; E8 FE
	cmpr	r1,[DISP]		; E9 FE
	cmpr	r2,[DISP]		; EA FE
	cmpr	r3,[DISP]		; EB FE

	cmpa	r0,[ADDR]		; ECs92r34
	cmpa	r1,[ADDR]		; EDs92r34
	cmpa	r2,[ADDR]		; EEs92r34
	cmpa	r3,[ADDR]		; EFs92r34

	cmpa	r0,[ADDR,+r0]		; ECsB2r34
	cmpa	r0,[ADDR,+r1]		; EDsB2r34
	cmpa	r0,[ADDR,+r2]		; EEsB2r34
	cmpa	r0,[ADDR,+r3]		; EFsB2r34

	cmpa	r0,[ADDR,-r0]		; ECsD2r34
	cmpa	r0,[ADDR,-r1]		; EDsD2r34
	cmpa	r0,[ADDR,-r2]		; EEsD2r34
	cmpa	r0,[ADDR,-r3]		; EFsD2r34

	cmpa	r0,[ADDR,r0]		; ECsF2r34
	cmpa	r0,[ADDR,r1]		; EDsF2r34
	cmpa	r0,[ADDR,r2]		; EEsF2r34
	cmpa	r0,[ADDR,r3]		; EFsF2r34

	.sbttl	cmp_ 'Alternate Indirect' Instruction Tests

	cmpr	r0,@DISP		; E8 FE
	cmpr	r1,@DISP		; E9 FE
	cmpr	r2,@DISP		; EA FE
	cmpr	r3,@DISP		; EB FE

	cmpa	r0,@ADDR		; ECs92r34
	cmpa	r1,@ADDR		; EDs92r34
	cmpa	r2,@ADDR		; EEs92r34
	cmpa	r3,@ADDR		; EFs92r34

	cmpa	r0,@ADDR,+r0		; ECsB2r34
	cmpa	r0,@ADDR,+r1		; EDsB2r34
	cmpa	r0,@ADDR,+r2		; EEsB2r34
	cmpa	r0,@ADDR,+r3		; EFsB2r34

	cmpa	r0,@ADDR,-r0		; ECsD2r34
	cmpa	r0,@ADDR,-r1		; EDsD2r34
	cmpa	r0,@ADDR,-r2		; EEsD2r34
	cmpa	r0,@ADDR,-r3		; EFsD2r34

	cmpa	r0,@ADDR,r0		; ECsF2r34
	cmpa	r0,@ADDR,r1		; EDsF2r34
	cmpa	r0,@ADDR,r2		; EEsF2r34
	cmpa	r0,@ADDR,r3		; EFsF2r34


	.sbttl	'Sequential' Instruction Tests

	wrtd	r0			; F0
	wrtd	r1			; F1
	wrtd	r2			; F2
	wrtd	r3			; F3

	tmi	r0,#P			; F4r98
	tmi	r1,#P			; F5r98
	tmi	r2,#P			; F6r98
	tmi	r3,#P			; F7r98

	.sbttl	bdrr 'Sequential' Instruction Test

	bdrr	r0,DISP			; F8 7E
	bdrr	r1,DISP			; F9 7E
	bdrr	r2,DISP			; FA 7E
	bdrr	r3,DISP			; FB 7E

	bdrr	r0,[DISP]		; F8 FE
	bdrr	r1,[DISP]		; F9 FE
	bdrr	r2,[DISP]		; FA FE
	bdrr	r3,[DISP]		; FB FE

	bdrr	r0,@DISP		; F8 FE
	bdrr	r1,@DISP		; F9 FE
	bdrr	r2,@DISP		; FA FE
	bdrr	r3,@DISP		; FB FE

 	.sbttl	bdra 'Sequential' Instruction Test

	bdra	r0,BADD			; FCv76u54
	bdra	r1,BADD			; FDv76u54
	bdra	r2,BADD			; FEv76u54
	bdra	r3,BADD			; FFv76u54

	bdra	r0,[BADD]		; FCvF6u54
	bdra	r1,[BADD]		; FDvF6u54
	bdra	r2,[BADD]		; FEvF6u54
	bdra	r3,[BADD]		; FFvF6u54

	bdra	r0,@BADD		; FCvF6u54
	bdra	r1,@BADD		; FDvF6u54
	bdra	r2,@BADD		; FEvF6u54
	bdra	r3,@BADD		; FFvF6u54






