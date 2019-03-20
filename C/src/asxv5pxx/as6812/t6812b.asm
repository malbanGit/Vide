	.title	AS6812 Test Code T6812b.asm

	; This file should be assembled as:
	;
	;	as6812 -laffg t6812b
	;
	; Allowed relocation attributes are verified
	;

	.radix	D

;	immed   =	0x72
;	dir     =	0x57
;	ext     =	0x1234
	ind     =	0x37
	small   =	0x0E
;	pg	=	0x36
	ROT000	=	0x0188
	ROT001	=	0x8944
	ROT002	=	0x3333
	ROT003	=	0x4444

	.=.+0x1000

	; Lines marked with ';noofst' indicate assembled code without
	; the PC offset corrections for movb and movw instructions.
	; (See section 3.9 of the CPU12 Reference Manual)

start:	movb	5,-y,-16,sp	;18 0a 6b 90
;noofst	movb	5,-y,-small,pc	;18 0a 6b d2
	movb	5,-y,-small,pc	;18 0a 6b d1
	movb	5,-y,-small,sp	;18 0a 6b 92
	movb	5,y-,-small,sp	;18 0a 7b 92
	movb	5,-y,-small,x	;18 0a 6b 12
	movb	5,-y,-small,y	;18 0a 6b 52
;noofst	movb	5,-y,0,pc	;18 0a 6b c0
	movb	5,-y,0,pc	;18 0a 6b df
	movb	5,-y,0,sp	;18 0a 6b 80
	trap	0x39		;18 39

	
	bclr	1,+sp,0x55	;0d a0 55
	bclr	1,+sp,#0x55	;0d a0 55
	bclr	1,sp-,0x55	;0d bf 55
	bclr	1,sp-,#0x55	;0d bf 55
	
	bclr	1,+x,0x55	;0d 20 55
	bclr	1,+x,#0x55	;0d 20 55

	bclr	*dir,0x55	;4d*00 55
	bclr	*dir,#0x55	;4d*00 55
	
	bclr	ext,0x55	;1ds00r00 55
	bclr	ext,#0x55	;1ds00r00 55
	
	brclr	1,+sp,0x55,.+0	;0f a0 55 fc
	brclr	1,+sp,#0x55,.+0	;0f a0 55 fc
	
	brclr	*dir,0x55,.+0	;4f*00 55 fc
	brclr	*dir,#0x55,.+0	;4f*00 55 fc
	
	brclr	ext,0x55,.+0	;1fs00r00 55 fb
	brclr	ext,#0x55,.+0	;1fs00r00 55 fb
	
	brset	1,+sp,0x55,.+0	;0e a0 55 fc
	brset	1,+sp,#0x55,.+0	;0e a0 55 fc
	
	brset	*dir,0x55,.+0	;4e*00 55 fc
	brset	*dir,#0x55,.+0	;4e*00 55 fc
	
	brset	ext,0x55,.+0	;1es00r00 55 fb
	brset	ext,#0x55,.+0	;1es00r00 55 fb
	
	bset	1,+sp,0x55	;0c a0 55
	bset	1,+sp,#0x55	;0c a0 55

	bset	*dir,0x55	;4c*00 55
	bset	*dir,#0x55	;4c*00 55

	bset	ext,0x55	;1cs00r00 55
	bset	ext,#0x55	;1cs00r00 55

 	movw	ext,  2,x 	;18 01 02s00r00
 	movw	2,x,  0,x	;18 02 02 00

	movb	1,sp,ext	;18 0d 81s00r00
	movb	1,sp,12,x	;18 0a 81 0c
	movw	2,sp,ext	;18 05 82s00r00
	movw	2,sp,12,x	;18 02 82 0c

	
	movb  	#immed,1,-sp	;18 08 afr00
	movw	ext,2,-sp	;18 01 aes00r00
	movb	ext,1,-sp	;18 09 afs00r00
	movw	#immed,2,-sp	;18 00 aes00r00

a:	aba			;18 06
	abx			;1a e5
	aby			;19 ed
	adca	#immed		;89r00
	adca	1,+sp		;a9 a0
	adca	1,+y		;a9 60
	adca	8,+sp		;a9 a7
	adca	8,+y		;a9 67
	adca	,pc		;a9 c0
	adca	,sp		;a9 80
	adca	,x		;a9 00

	adca	,y		;a9 40
	adca	1,-sp		;a9 af
	adca	1,-x		;a9 2f
	adca	1,-y		;a9 6f
	adca	8,-sp		;a9 a8
	adca	8,-x		;a9 28
	adca	8,-y		;a9 68
	adca	-1,sp		;a9 9f
	adca	-1,x		;a9 1f
	adca	-1,y		;a9 5f
	adca	-16,sp		;a9 90
	adca	-16,x		;a9 10
	adca	-16,y		;a9 50
	adca	-17,sp		;a9 f1 ef
	adca	-17,x		;a9 e1 ef
	adca	-17,y		;a9 e9 ef
	adca	-small,pc	;a9 d2
	adca	-small,sp	;a9 92
	adca	-small,x	;a9 12
	adca	-small,y	;a9 52
	adca	0,pc		;a9 c0
	adca	0,sp		;a9 80
	adca	0,x		;a9 00
	adca	0,y		;a9 40
	adca	1,sp+		;a9 b0
	adca	1,x+		;a9 30
;	ext	=	ROT000
	adca	ext,x		;a9 e2s00r00
;	ext	=	ROT001
	adca	ext,x		;a9 e2s00r00
;	ext	=	ROT002
	adca	ext,x		;a9 e2s00r00
;	ext	=	ROT003
	adca	ext,x		;a9 e2s00r00
;	ext	=	ROT000
	adca	ext,x		;a9 e2s00r00
	adca	1,y+		;a9 70
	adca	1,sp		;a9 81
	adca	1,x		;a9 01
	adca	1,y		;a9 41
	adca	1,sp-		;a9 bf
	adca	1,x-		;a9 3f
	adca	1,y-		;a9 7f
	adca	125,pc		;a9 f8 7d
	adca	125,sp		;a9 f0 7d
	adca	125,x		;a9 e0 7d
	adca	125,y		;a9 e8 7d
	adca	15,sp		;a9 8f
	adca	15,x		;a9 0f
	adca	15,y		;a9 4f
	adca	16,sp		;a9 f0 10
	adca	16,x		;a9 e0 10
	adca	16,y		;a9 e8 10
	adca	8,sp+		;a9 b7
	adca	8,x+		;a9 37
	adca	8,y+		;a9 77
	adca	8,sp-		;a9 b8
	adca	8,x-		;a9 38
	adca	8,y-		;a9 78
	adca	a,sp		;a9 f4
	adca	a,x		;a9 e4
	adca	a,y		;a9 ec
	adca	b,sp		;a9 f5
	adca	b,x		;a9 e5
	adca	b,y		;a9 ed
	adca	d,sp		;a9 f6
	adca	d,x		;a9 e6
	adca	d,y		;a9 ee
	adca	*dir		;99*00
	adca	ext		;b9s00r00
	adca	ext,sp		;a9 f2s00r00
	adca	ext,x		;a9 e2s00r00
	adca	ext,y		;a9 eas00r00
	adca	ind,pc		;a9 f8 37
	adca	ind,sp		;a9 f0 37
	adca	ind,x		;a9 e0 37
	adca	ind,y		;a9 e8 37
	adca	small,pc	;a9 ce
	adca	small,sp	;a9 8e
	adca	small,x		;a9 0e
	adca	small,y		;a9 4e
	adcb	#immed		;c9r00
	adcb	1,+sp		;e9 a0
	adcb	-small,pc	;e9 d2
	adcb	125,pc		;e9 f8 7d
	adcb	*dir		;d9*00
	adcb	ext		;f9s00r00
	adcb	ext,sp		;e9 f2s00r00
	adda	#immed		;8br00
	adda	1,+sp		;ab a0
	adda	*dir		;9b*00
	adda	ext		;bbs00r00
	addb	#immed		;cbr00
	addb	1,+sp		;eb a0
	addb	*dir		;db*00
	addb	ext		;fbs00r00
	addd	#immed		;c3s00r00
	addd	1,+sp		;e3 a0
	addd	*dir		;d3*00
	addd	ext		;f3s00r00
	anda	#immed		;84r00
	anda	1,+sp		;a4 a0
	anda	*dir		;94*00
	anda	ext		;b4s00r00
	andb	#immed		;c4r00
	andb	1,+sp		;e4 a0
	andb	*dir		;d4*00
	andb	ext		;f4s00r00
	andcc	#immed		;10r00
	asl	1,+sp		;68 a0
	asl	*dir		;78s00r00
	asl	ext		;78s00r00
	asla			;48
	aslb			;58
	asld			;59
	asr	1,+sp		;67 a0
	asr	*dir		;77s00r00
	asr	ext		;77s00r00
	asra			;47
	asrb			;57

b:	bcc	.		;24 fe
	bcs	.		;25 fe
	beq	.		;27 fe
	bge	.		;2c fe
	bgt	.		;2e fe
	bhi	.		;22 fe
	bita	#immed		;85r00
	bita	1,+sp		;a5 a0
	bita	*dir		;95*00
	bita	ext		;b5s00r00
	bitb	#immed		;c5r00
	bitb	1,+sp		;e5 a0
	bitb	*dir		;d5*00
	bitb	ext		;f5s00r00
	ble	.		;2f fe
	bls	.		;23 fe
	blt	.		;2d fe
	bmi	.		;2b fe
	bne	.		;26 fe
	bpl	.		;2a fe
	bra	.		;20 fe
	brn	.		;21 fe
	bsr	.		;07 fe
	bvc	.		;28 fe
	bvs	.		;29 fe

c:	cba			;18 17
	clc			;10 fe
	cli			;10 ef
	clr	1,+sp		;69 a0
	clr	*dir		;79s00r00
	clr	ext		;79s00r00
	clra			;87
	clrb			;c7
	clv			;10 fd
	cmpa	#immed		;81r00
	cmpa	1,+sp		;a1 a0
	cmpa	*dir		;91*00
	cmpa	ext		;b1s00r00

	cmpb	#immed		;c1r00
	cmpb	1,+sp		;e1 a0
	cmpb	1,+x		;e1 20
	cmpb	1,+y		;e1 60
	cmpb	8,+sp		;e1 a7
	cmpb	8,+x		;e1 27
	cmpb	8,+y		;e1 67
	cmpb	,pc		;e1 c0
	cmpb	,sp		;e1 80
	cmpb	,x		;e1 00
	cmpb	,y		;e1 40
	cmpb	1,-sp		;e1 af
	cmpb	1,-x		;e1 2f
	cmpb	1,-y		;e1 6f
	cmpb	8,-sp		;e1 a8
	cmpb	8,-x		;e1 28
	cmpb	8,-y		;e1 68
	cmpb	-1,sp		;e1 9f
	cmpb	-1,x		;e1 1f
	cmpb	-1,y		;e1 5f
	cmpb	-16,sp		;e1 90
	cmpb	-16,x		;e1 10
	cmpb	-16,y		;e1 50
	cmpb	-17,sp		;e1 f1 ef
	cmpb	-17,x		;e1 e1 ef
	cmpb	-17,y		;e1 e9 ef
	cmpb	-small,pc	;e1 d2
	cmpb	-small,sp	;e1 92
	cmpb	-small,x	;e1 12
	cmpb	-small,y	;e1 52
	cmpb	0,pc		;e1 c0
	cmpb	0,sp		;e1 80
	cmpb	0,x		;e1 00
	cmpb	0,y		;e1 40
	cmpb	1,sp+		;e1 b0
	cmpb	1,x+		;e1 30
	cmpb	1,y+		;e1 70
	cmpb	1,sp		;e1 81
	cmpb	1,x		;e1 01
	cmpb	1,y		;e1 41
	cmpb	1,sp-		;e1 bf
	cmpb	1,x-		;e1 3f
	cmpb	1,y-		;e1 7f
	cmpb	125,pc		;e1 f8 7d
	cmpb	125,sp		;e1 f0 7d
	cmpb	125,x		;e1 e0 7d
	cmpb	125,y		;e1 e8 7d
	cmpb	15,sp		;e1 8f
	cmpb	15,x		;e1 0f
	cmpb	15,y		;e1 4f
	cmpb	16,sp		;e1 f0 10
	cmpb	16,x		;e1 e0 10
	cmpb	16,y		;e1 e8 10
	cmpb	8,sp+		;e1 b7
	cmpb	8,x+		;e1 37
	cmpb	8,y+		;e1 77
	cmpb	8,sp-		;e1 b8
	cmpb	8,x-		;e1 38
	cmpb	8,y-		;e1 78
	cmpb	a,sp		;e1 f4
	cmpb	a,x		;e1 e4
	cmpb	a,y		;e1 ec
	cmpb	b,sp		;e1 f5
	cmpb	b,x		;e1 e5
	cmpb	b,y		;e1 ed
	cmpb	d,sp		;e1 f6
	cmpb	d,x		;e1 e6
	cmpb	d,y		;e1 ee
	cmpb	*dir		;d1*00
	cmpb	ext		;f1s00r00
	cmpb	ext,sp		;e1 f2s00r00
	cmpb	ext,x		;e1 e2s00r00
	cmpb	ext,y		;e1 eas00r00
	cmpb	ind,pc		;e1 f8 37
	cmpb	ind,sp		;e1 f0 37
	cmpb	ind,x		;e1 e0 37
	cmpb	ind,y		;e1 e8 37
	cmpb	small,pc	;e1 ce
	cmpb	small,sp	;e1 8e
	cmpb	small,x		;e1 0e
	cmpb	small,y		;e1 4e
	com	1,+sp		;61 a0
	com	1,+x		;61 20
	com	1,+y		;61 60
	com	8,+sp		;61 a7
	com	8,+x		;61 27
	com	8,+y		;61 67
	com	,pc		;61 c0
	com	,sp		;61 80
	com	,x		;61 00
	com	,y		;61 40
	com	1,-sp		;61 af
	com	1,-x		;61 2f
	com	1,-y		;61 6f
	com	8,-sp		;61 a8
	com	8,-x		;61 28
	com	8,-y		;61 68
	com	-1,sp		;61 9f
	com	-1,x		;61 1f
	com	-1,y		;61 5f
	com	-16,sp		;61 90
	com	-16,x		;61 10
	com	-16,y		;61 50
	com	-17,sp		;61 f1 ef
	com	-17,x		;61 e1 ef
	com	-17,y		;61 e9 ef
	com	-small,pc	;61 d2
	com	-small,sp	;61 92
	com	-small,x	;61 12
	com	-small,y	;61 52
	com	0,pc		;61 c0
	com	0,sp		;61 80
	com	0,x		;61 00
	com	0,y		;61 40
	com	1,sp+		;61 b0
	com	1,x+		;61 30
	com	1,y+		;61 70
	com	1,sp		;61 81
	com	1,x		;61 01
	com	1,y		;61 41
	com	1,sp-		;61 bf
	com	1,x-		;61 3f
	com	1,y-		;61 7f
	com	125,pc		;61 f8 7d
	com	125,sp		;61 f0 7d
	com	125,x		;61 e0 7d
	com	125,y		;61 e8 7d
	com	15,sp		;61 8f
	com	15,x		;61 0f
	com	15,y		;61 4f
	com	16,sp		;61 f0 10
	com	16,x		;61 e0 10
	com	16,y		;61 e8 10
	com	8,sp+		;61 b7
	com	8,x+		;61 37
	com	8,y+		;61 77
	com	8,sp-		;61 b8
	com	8,x-		;61 38
	com	8,y-		;61 78
	com	a,sp		;61 f4
	com	a,x		;61 e4
	com	a,y		;61 ec
	com	b,sp		;61 f5
	com	b,x		;61 e5
	com	b,y		;61 ed
	com	d,sp		;61 f6
	com	d,x		;61 e6
	com	d,y		;61 ee
	com	*dir		;71s00r00
	com	ext		;71s00r00
	com	ext,sp		;61 f2s00r00
	com	ext,x		;61 e2s00r00
	com	ext,y		;61 eas00r00
	com	ind,pc		;61 f8 37
	com	ind,sp		;61 f0 37
	com	ind,x		;61 e0 37
	com	ind,y		;61 e8 37
	com	small,pc	;61 ce
	com	small,sp	;61 8e
	com	small,x		;61 0e
	com	small,y		;61 4e
	coma			;41
	comb			;51
	cpd	#immed		;8cs00r00
	cpd	1,+sp		;ac a0
	cpd	1,+x		;ac 20
	cpd	1,+y		;ac 60
	cpd	8,+sp		;ac a7
	cpd	8,+x		;ac 27
	cpd	8,+y		;ac 67
	cpd	,pc		;ac c0
	cpd	,sp		;ac 80
	cpd	,x		;ac 00
	cpd	,y		;ac 40
	cpd	1,-sp		;ac af
	cpd	1,-x		;ac 2f
	cpd	1,-y		;ac 6f
	cpd	8,-sp		;ac a8
	cpd	8,-x		;ac 28
	cpd	8,-y		;ac 68
	cpd	-1,sp		;ac 9f
	cpd	-1,x		;ac 1f
	cpd	-1,y		;ac 5f
	cpd	-16,sp		;ac 90
	cpd	-16,x		;ac 10
	cpd	-16,y		;ac 50
	cpd	-17,sp		;ac f1 ef
	cpd	-17,x		;ac e1 ef
	cpd	-17,y		;ac e9 ef
	cpd	-small,pc	;ac d2
	cpd	-small,sp	;ac 92
	cpd	-small,x	;ac 12
	cpd	-small,y	;ac 52
	cpd	0,pc		;ac c0
	cpd	0,sp		;ac 80
	cpd	0,x		;ac 00
	cpd	0,y		;ac 40
	cpd	1,sp+		;ac b0
	cpd	1,x+		;ac 30
	cpd	1,y+		;ac 70
	cpd	1,sp		;ac 81
	cpd	1,x		;ac 01
	cpd	1,y		;ac 41
	cpd	1,sp-		;ac bf
	cpd	1,x-		;ac 3f
	cpd	1,y-		;ac 7f
	cpd	125,pc		;ac f8 7d
	cpd	125,sp		;ac f0 7d
	cpd	125,x		;ac e0 7d
	cpd	125,y		;ac e8 7d
	cpd	15,sp		;ac 8f
	cpd	15,x		;ac 0f
	cpd	15,y		;ac 4f
	cpd	16,sp		;ac f0 10
	cpd	16,x		;ac e0 10
	cpd	16,y		;ac e8 10
	cpd	8,sp+		;ac b7
	cpd	8,x+		;ac 37
	cpd	8,y+		;ac 77
	cpd	8,sp-		;ac b8
	cpd	8,x-		;ac 38
	cpd	8,y-		;ac 78
	cpd	a,sp		;ac f4
	cpd	a,x		;ac e4
	cpd	a,y		;ac ec
	cpd	b,sp		;ac f5
	cpd	b,x		;ac e5
	cpd	b,y		;ac ed
	cpd	d,sp		;ac f6
	cpd	d,x		;ac e6
	cpd	d,y		;ac ee
	cpd	*dir		;9c*00
	cpd	ext		;bcs00r00
	cpd	ext,sp		;ac f2s00r00
	cpd	ext,x		;ac e2s00r00
	cpd	ext,y		;ac eas00r00
	cpd	ind,pc		;ac f8 37
	cpd	ind,sp		;ac f0 37
	cpd	ind,x		;ac e0 37
	cpd	ind,y		;ac e8 37
	cpd	small,pc	;ac ce
	cpd	small,sp	;ac 8e
	cpd	small,x		;ac 0e
	cpd	small,y		;ac 4e
	cps	#immed		;8fs00r00
	cps	1,+sp		;af a0
	cps	1,+x		;af 20
	cps	1,+y		;af 60
	cps	8,+sp		;af a7
	cps	8,+x		;af 27
	cps	8,+y		;af 67
	cps	,pc		;af c0
	cps	,sp		;af 80
	cps	,x		;af 00
	cps	,y		;af 40
	cps	1,-sp		;af af
	cps	1,-x		;af 2f
	cps	1,-y		;af 6f
	cps	8,-sp		;af a8
	cps	8,-x		;af 28
	cps	8,-y		;af 68
	cps	-1,sp		;af 9f
	cps	-1,x		;af 1f
	cps	-1,y		;af 5f
	cps	-16,sp		;af 90
	cps	-16,x		;af 10
	cps	-16,y		;af 50
	cps	-17,sp		;af f1 ef
	cps	-17,x		;af e1 ef
	cps	-17,y		;af e9 ef
	cps	-small,pc	;af d2
	cps	-small,sp	;af 92
	cps	-small,x	;af 12
	cps	-small,y	;af 52
	cps	0,pc		;af c0
	cps	0,sp		;af 80
	cps	0,x		;af 00
	cps	0,y		;af 40
	cps	1,sp+		;af b0
	cps	1,x+		;af 30
	cps	1,y+		;af 70
	cps	1,sp		;af 81
	cps	1,x		;af 01
	cps	1,y		;af 41
	cps	1,sp-		;af bf
	cps	1,x-		;af 3f
	cps	1,y-		;af 7f
	cps	125,pc		;af f8 7d
	cps	125,sp		;af f0 7d
	cps	125,x		;af e0 7d
	cps	125,y		;af e8 7d
	cps	15,sp		;af 8f
	cps	15,x		;af 0f
	cps	15,y		;af 4f
	cps	16,sp		;af f0 10
	cps	16,x		;af e0 10
	cps	16,y		;af e8 10
	cps	8,sp+		;af b7
	cps	8,x+		;af 37
	cps	8,y+		;af 77
	cps	8,sp-		;af b8
	cps	8,x-		;af 38
	cps	8,y-		;af 78
	cps	a,sp		;af f4
	cps	a,x		;af e4
	cps	a,y		;af ec
	cps	b,sp		;af f5
	cps	b,x		;af e5
	cps	b,y		;af ed
	cps	d,sp		;af f6
	cps	d,x		;af e6
	cps	d,y		;af ee
	cps	*dir		;9f*00
	cps	ext		;bfs00r00
	cps	ext,sp		;af f2s00r00
	cps	ext,x		;af e2s00r00
	cps	ext,y		;af eas00r00
	cps	ind,pc		;af f8 37
	cps	ind,sp		;af f0 37
	cps	ind,x		;af e0 37
	cps	ind,y		;af e8 37
	cps	small,pc	;af ce
	cps	small,sp	;af 8e
	cps	small,x		;af 0e
	cps	small,y		;af 4e
	cpx	#immed		;8es00r00
	cpx	1,+sp		;ae a0
	cpx	1,+x		;ae 20
	cpx	1,+y		;ae 60
	cpx	8,+sp		;ae a7
	cpx	8,+x		;ae 27
	cpx	8,+y		;ae 67
	cpx	,pc		;ae c0
	cpx	,sp		;ae 80
	cpx	,x		;ae 00
	cpx	,y		;ae 40
	cpx	1,-sp		;ae af
	cpx	1,-x		;ae 2f
	cpx	1,-y		;ae 6f
	cpx	8,-sp		;ae a8
	cpx	8,-x		;ae 28
	cpx	8,-y		;ae 68
	cpx	-1,sp		;ae 9f
	cpx	-1,x		;ae 1f
	cpx	-1,y		;ae 5f
	cpx	-16,sp		;ae 90
	cpx	-16,x		;ae 10
	cpx	-16,y		;ae 50
	cpx	-17,sp		;ae f1 ef
	cpx	-17,x		;ae e1 ef
	cpx	-17,y		;ae e9 ef
	cpx	-small,pc	;ae d2
	cpx	-small,sp	;ae 92
	cpx	-small,x	;ae 12
	cpx	-small,y	;ae 52
	cpx	0,pc		;ae c0
	cpx	0,sp		;ae 80
	cpx	0,x		;ae 00
	cpx	0,y		;ae 40
	cpx	1,sp+		;ae b0
	cpx	1,x+		;ae 30
	cpx	1,y+		;ae 70
	cpx	1,sp		;ae 81
	cpx	1,x		;ae 01
	cpx	1,y		;ae 41
	cpx	1,sp-		;ae bf
	cpx	1,x-		;ae 3f
	cpx	1,y-		;ae 7f
	cpx	125,pc		;ae f8 7d
	cpx	125,sp		;ae f0 7d
	cpx	125,x		;ae e0 7d
	cpx	125,y		;ae e8 7d
	cpx	15,sp		;ae 8f
	cpx	15,x		;ae 0f
	cpx	15,y		;ae 4f
	cpx	16,sp		;ae f0 10
	cpx	16,x		;ae e0 10
	cpx	16,y		;ae e8 10
	cpx	8,sp+		;ae b7
	cpx	8,x+		;ae 37
	cpx	8,y+		;ae 77
	cpx	8,sp-		;ae b8
	cpx	8,x-		;ae 38
	cpx	8,y-		;ae 78
	cpx	a,sp		;ae f4
	cpx	a,x		;ae e4
	cpx	a,y		;ae ec
	cpx	b,sp		;ae f5
	cpx	b,x		;ae e5
	cpx	b,y		;ae ed
	cpx	d,sp		;ae f6
	cpx	d,x		;ae e6
	cpx	d,y		;ae ee
	cpx	*dir		;9e*00
	cpx	ext		;bes00r00
	cpx	ext,sp		;ae f2s00r00
	cpx	ext,x		;ae e2s00r00
	cpx	ext,y		;ae eas00r00
	cpx	ind,pc		;ae f8 37
	cpx	ind,sp		;ae f0 37
	cpx	ind,x		;ae e0 37
	cpx	ind,y		;ae e8 37
	cpx	small,pc	;ae ce
	cpx	small,sp	;ae 8e
	cpx	small,x		;ae 0e
	cpx	small,y		;ae 4e
	cpy	#immed		;8ds00r00
	cpy	1,+sp		;ad a0
	cpy	1,+x		;ad 20
	cpy	1,+y		;ad 60
	cpy	8,+sp		;ad a7
	cpy	8,+x		;ad 27
	cpy	8,+y		;ad 67
	cpy	,pc		;ad c0
	cpy	,sp		;ad 80
	cpy	,x		;ad 00
	cpy	,y		;ad 40
	cpy	1,-sp		;ad af
	cpy	1,-x		;ad 2f
	cpy	1,-y		;ad 6f
	cpy	8,-sp		;ad a8
	cpy	8,-x		;ad 28
	cpy	8,-y		;ad 68
	cpy	-1,sp		;ad 9f
	cpy	-1,x		;ad 1f
	cpy	-1,y		;ad 5f
	cpy	-16,sp		;ad 90
	cpy	-16,x		;ad 10
	cpy	-16,y		;ad 50
	cpy	-17,sp		;ad f1 ef
	cpy	-17,x		;ad e1 ef
	cpy	-17,y		;ad e9 ef
	cpy	-small,pc	;ad d2
	cpy	-small,sp	;ad 92
	cpy	-small,x	;ad 12
	cpy	-small,y	;ad 52
	cpy	0,pc		;ad c0
	cpy	0,sp		;ad 80
	cpy	0,x		;ad 00
	cpy	0,y		;ad 40
	cpy	1,sp+		;ad b0
	cpy	1,x+		;ad 30
	cpy	1,y+		;ad 70
	cpy	1,sp		;ad 81
	cpy	1,x		;ad 01
	cpy	1,y		;ad 41
	cpy	1,sp-		;ad bf
	cpy	1,x-		;ad 3f
	cpy	1,y-		;ad 7f
	cpy	125,pc		;ad f8 7d
	cpy	125,sp		;ad f0 7d
	cpy	125,x		;ad e0 7d
	cpy	125,y		;ad e8 7d
	cpy	15,sp		;ad 8f
	cpy	15,x		;ad 0f
	cpy	15,y		;ad 4f
	cpy	16,sp		;ad f0 10
	cpy	16,x		;ad e0 10
	cpy	16,y		;ad e8 10
	cpy	8,sp+		;ad b7
	cpy	8,x+		;ad 37
	cpy	8,y+		;ad 77
	cpy	8,sp-		;ad b8
	cpy	8,x-		;ad 38
	cpy	8,y-		;ad 78
	cpy	a,sp		;ad f4
	cpy	a,x		;ad e4
	cpy	a,y		;ad ec
	cpy	b,sp		;ad f5
	cpy	b,x		;ad e5
	cpy	b,y		;ad ed
	cpy	d,sp		;ad f6
	cpy	d,x		;ad e6
	cpy	d,y		;ad ee
	cpy	*dir		;9d*00
	cpy	ext		;bds00r00
	cpy	ext,sp		;ad f2s00r00
	cpy	ext,x		;ad e2s00r00
	cpy	ext,y		;ad eas00r00
	cpy	ind,pc		;ad f8 37
	cpy	ind,sp		;ad f0 37
	cpy	ind,x		;ad e0 37
	cpy	ind,y		;ad e8 37
	cpy	small,pc	;ad ce
	cpy	small,sp	;ad 8e
	cpy	small,x		;ad 0e
	cpy	small,y		;ad 4e

d:	daa			;18 07
	dbne	a,.+0		;04 30 fd
	dbne	b,.+0		;04 31 fd
	dbne	x,.+0		;04 35 fd
	dbne	y,.+0		;04 36 fd
	dec	1,+sp		;63 a0
	dec	1,+x		;63 20
	dec	1,+y		;63 60
	dec	8,+sp		;63 a7
	dec	8,+x		;63 27
	dec	8,+y		;63 67
	dec	,pc		;63 c0
	dec	,sp		;63 80
	dec	,x		;63 00
	dec	,y		;63 40
	dec	1,-sp		;63 af
	dec	1,-x		;63 2f
	dec	1,-y		;63 6f
	dec	8,-sp		;63 a8
	dec	8,-x		;63 28
	dec	8,-y		;63 68
	dec	-1,sp		;63 9f
	dec	-1,x		;63 1f
	dec	-1,y		;63 5f
	dec	-16,sp		;63 90
	dec	-16,x		;63 10
	dec	-16,y		;63 50
	dec	-17,sp		;63 f1 ef
	dec	-17,x		;63 e1 ef
	dec	-17,y		;63 e9 ef
	dec	-small,pc	;63 d2
	dec	-small,sp	;63 92
	dec	-small,x	;63 12
	dec	-small,y	;63 52
	dec	0,pc		;63 c0
	dec	0,sp		;63 80
	dec	0,x		;63 00
	dec	0,y		;63 40
	dec	1,sp+		;63 b0
	dec	1,x+		;63 30
	dec	1,y+		;63 70
	dec	1,sp		;63 81
	dec	1,x		;63 01
	dec	1,y		;63 41
	dec	1,sp-		;63 bf
	dec	1,x-		;63 3f
	dec	1,y-		;63 7f
	dec	125,pc		;63 f8 7d
	dec	125,sp		;63 f0 7d
	dec	125,x		;63 e0 7d
	dec	125,y		;63 e8 7d
	dec	15,sp		;63 8f
	dec	15,x		;63 0f
	dec	15,y		;63 4f
	dec	16,sp		;63 f0 10
	dec	16,x		;63 e0 10
	dec	16,y		;63 e8 10
	dec	8,sp+		;63 b7
	dec	8,x+		;63 37
	dec	8,y+		;63 77
	dec	8,sp-		;63 b8
	dec	8,x-		;63 38
	dec	8,y-		;63 78
	dec	a,sp		;63 f4
	dec	a,x		;63 e4
	dec	a,y		;63 ec
	dec	b,sp		;63 f5
	dec	b,x		;63 e5
	dec	b,y		;63 ed
	dec	d,sp		;63 f6
	dec	d,x		;63 e6
	dec	d,y		;63 ee
	dec	*dir		;73s00r00
	dec	ext		;73s00r00
	dec	ext,sp		;63 f2s00r00
	dec	ext,x		;63 e2s00r00
	dec	ext,y		;63 eas00r00
	dec	ind,pc		;63 f8 37
	dec	ind,sp		;63 f0 37
	dec	ind,x		;63 e0 37
	dec	ind,y		;63 e8 37
	dec	small,pc	;63 ce
	dec	small,sp	;63 8e
	dec	small,x		;63 0e
	dec	small,y		;63 4e
	deca			;43
	decb			;53
	des			;1b 9f
	dex			;09
	dey			;03

e:	ediv			;11
	edivs			;18 14
	emacs	*dir		;18 12s00r00
	emacs	ext		;18 12s00r00
	emacs	small		;18 12 00 0e
	emaxd	1,+sp		;18 1a a0
	emaxd	1,+x		;18 1a 20
	emaxd	1,+y		;18 1a 60
	emaxd	8,+sp		;18 1a a7
	emaxd	8,+x		;18 1a 27
	emaxd	8,+y		;18 1a 67
	emaxd	,pc		;18 1a c0
	emaxd	,sp		;18 1a 80
	emaxd	,x		;18 1a 00
	emaxd	,y		;18 1a 40
	emaxd	1,-sp		;18 1a af
	emaxd	1,-x		;18 1a 2f
	emaxd	1,-y		;18 1a 6f
	emaxd	8,-sp		;18 1a a8
	emaxd	8,-x		;18 1a 28
	emaxd	8,-y		;18 1a 68
	emaxd	-1,sp		;18 1a 9f
	emaxd	-1,x		;18 1a 1f
	emaxd	-1,y		;18 1a 5f
	emaxd	-16,sp		;18 1a 90
	emaxd	-16,x		;18 1a 10
	emaxd	-16,y		;18 1a 50
	emaxd	-17,sp		;18 1a f1 ef
	emaxd	-17,x		;18 1a e1 ef
	emaxd	-17,y		;18 1a e9 ef
	emaxd	-small,pc	;18 1a d2
	emaxd	-small,sp	;18 1a 92
	emaxd	-small,x	;18 1a 12
	emaxd	-small,y	;18 1a 52
	emaxd	0,pc		;18 1a c0
	emaxd	0,sp		;18 1a 80
	emaxd	0,x		;18 1a 00
	emaxd	0,y		;18 1a 40
	emaxd	1,sp+		;18 1a b0
	emaxd	1,x+		;18 1a 30
	emaxd	1,y+		;18 1a 70
	emaxd	1,sp		;18 1a 81
	emaxd	1,x		;18 1a 01
	emaxd	1,y		;18 1a 41
	emaxd	1,sp-		;18 1a bf
	emaxd	1,x-		;18 1a 3f
	emaxd	1,y-		;18 1a 7f
	emaxd	125,pc		;18 1a f8 7d
	emaxd	125,sp		;18 1a f0 7d
	emaxd	125,x		;18 1a e0 7d
	emaxd	125,y		;18 1a e8 7d
	emaxd	15,sp		;18 1a 8f
	emaxd	15,x		;18 1a 0f
	emaxd	15,y		;18 1a 4f
	emaxd	16,sp		;18 1a f0 10
	emaxd	16,x		;18 1a e0 10
	emaxd	16,y		;18 1a e8 10
	emaxd	8,sp+		;18 1a b7
	emaxd	8,x+		;18 1a 37
	emaxd	8,y+		;18 1a 77
	emaxd	8,sp-		;18 1a b8
	emaxd	8,x-		;18 1a 38
	emaxd	8,y-		;18 1a 78
	emaxd	a,sp		;18 1a f4
	emaxd	a,x		;18 1a e4
	emaxd	a,y		;18 1a ec
	emaxd	b,sp		;18 1a f5
	emaxd	b,x		;18 1a e5
	emaxd	b,y		;18 1a ed
	emaxd	d,sp		;18 1a f6
	emaxd	d,x		;18 1a e6
	emaxd	d,y		;18 1a ee
	emaxd	ext,sp		;18 1a f2s00r00
	emaxd	ext,x		;18 1a e2s00r00
	emaxd	ext,y		;18 1a eas00r00
	emaxd	ind,pc		;18 1a f8 37
	emaxd	ind,sp		;18 1a f0 37
	emaxd	ind,x		;18 1a e0 37
	emaxd	ind,y		;18 1a e8 37
	emaxd	small,pc	;18 1a ce
	emaxd	small,sp	;18 1a 8e
	emaxd	small,x		;18 1a 0e
	emaxd	small,y		;18 1a 4e
	emaxm	1,+sp		;18 1e a0
	emaxm	1,+x		;18 1e 20
	emaxm	1,+y		;18 1e 60
	emaxm	8,+sp		;18 1e a7
	emaxm	8,+x		;18 1e 27
	emaxm	8,+y		;18 1e 67
	emaxm	,pc		;18 1e c0
	emaxm	,sp		;18 1e 80
	emaxm	,x		;18 1e 00
	emaxm	,y		;18 1e 40
	emaxm	1,-sp		;18 1e af
	emaxm	1,-x		;18 1e 2f
	emaxm	1,-y		;18 1e 6f
	emaxm	8,-sp		;18 1e a8
	emaxm	8,-x		;18 1e 28
	emaxm	8,-y		;18 1e 68
	emaxm	-1,sp		;18 1e 9f
	emaxm	-1,x		;18 1e 1f
	emaxm	-1,y		;18 1e 5f
	emaxm	-16,sp		;18 1e 90
	emaxm	-16,x		;18 1e 10
	emaxm	-16,y		;18 1e 50
	emaxm	-17,sp		;18 1e f1 ef
	emaxm	-17,x		;18 1e e1 ef
	emaxm	-17,y		;18 1e e9 ef
	emaxm	-small,pc	;18 1e d2
	emaxm	-small,sp	;18 1e 92
	emaxm	-small,x	;18 1e 12
	emaxm	-small,y	;18 1e 52
	emaxm	0,pc		;18 1e c0
	emaxm	0,sp		;18 1e 80
	emaxm	0,x		;18 1e 00
	emaxm	0,y		;18 1e 40
	emaxm	1,sp+		;18 1e b0
	emaxm	1,x+		;18 1e 30
	emaxm	1,y+		;18 1e 70
	emaxm	1,sp		;18 1e 81
	emaxm	1,x		;18 1e 01
	emaxm	1,y		;18 1e 41
	emaxm	1,sp-		;18 1e bf
	emaxm	1,x-		;18 1e 3f
	emaxm	1,y-		;18 1e 7f
	emaxm	125,pc		;18 1e f8 7d
	emaxm	125,sp		;18 1e f0 7d
	emaxm	125,x		;18 1e e0 7d
	emaxm	125,y		;18 1e e8 7d
	emaxm	15,sp		;18 1e 8f
	emaxm	15,x		;18 1e 0f
	emaxm	15,y		;18 1e 4f
	emaxm	16,sp		;18 1e f0 10
	emaxm	16,x		;18 1e e0 10
	emaxm	16,y		;18 1e e8 10
	emaxm	8,sp+		;18 1e b7
	emaxm	8,x+		;18 1e 37
	emaxm	8,y+		;18 1e 77
	emaxm	8,sp-		;18 1e b8
	emaxm	8,x-		;18 1e 38
	emaxm	8,y-		;18 1e 78
	emaxm	a,sp		;18 1e f4
	emaxm	a,x		;18 1e e4
	emaxm	a,y		;18 1e ec
	emaxm	b,sp		;18 1e f5
	emaxm	b,x		;18 1e e5
	emaxm	b,y		;18 1e ed
	emaxm	d,sp		;18 1e f6
	emaxm	d,x		;18 1e e6
	emaxm	d,y		;18 1e ee
	emaxm	ext,sp		;18 1e f2s00r00
	emaxm	ext,x		;18 1e e2s00r00
	emaxm	ext,y		;18 1e eas00r00
	emaxm	ind,pc		;18 1e f8 37
	emaxm	ind,sp		;18 1e f0 37
	emaxm	ind,x		;18 1e e0 37
	emaxm	ind,y		;18 1e e8 37
	emaxm	small,pc	;18 1e ce
	emaxm	small,sp	;18 1e 8e
	emaxm	small,x		;18 1e 0e
	emaxm	small,y		;18 1e 4e
	emind	1,+sp		;18 1b a0
	emind	1,+x		;18 1b 20
	emind	1,+y		;18 1b 60
	emind	8,+sp		;18 1b a7
	emind	8,+x		;18 1b 27
	emind	8,+y		;18 1b 67
	emind	,pc		;18 1b c0
	emind	,sp		;18 1b 80
	emind	,x		;18 1b 00
	emind	,y		;18 1b 40
	emind	1,-sp		;18 1b af
	emind	1,-x		;18 1b 2f
	emind	1,-y		;18 1b 6f
	emind	8,-sp		;18 1b a8
	emind	8,-x		;18 1b 28
	emind	8,-y		;18 1b 68
	emind	-1,sp		;18 1b 9f
	emind	-1,x		;18 1b 1f
	emind	-1,y		;18 1b 5f
	emind	-16,sp		;18 1b 90
	emind	-16,x		;18 1b 10
	emind	-16,y		;18 1b 50
	emind	-17,sp		;18 1b f1 ef
	emind	-17,x		;18 1b e1 ef
	emind	-17,y		;18 1b e9 ef
	emind	-small,pc	;18 1b d2
	emind	-small,sp	;18 1b 92
	emind	-small,x	;18 1b 12
	emind	-small,y	;18 1b 52
	emind	0,pc		;18 1b c0
	emind	0,sp		;18 1b 80
	emind	0,x		;18 1b 00
	emind	0,y		;18 1b 40
	emind	1,sp+		;18 1b b0
	emind	1,x+		;18 1b 30
	emind	1,y+		;18 1b 70
	emind	1,sp		;18 1b 81
	emind	1,x		;18 1b 01
	emind	1,y		;18 1b 41
	emind	1,sp-		;18 1b bf
	emind	1,x-		;18 1b 3f
	emind	1,y-		;18 1b 7f
	emind	125,pc		;18 1b f8 7d
	emind	125,sp		;18 1b f0 7d
	emind	125,x		;18 1b e0 7d
	emind	125,y		;18 1b e8 7d
	emind	15,sp		;18 1b 8f
	emind	15,x		;18 1b 0f
	emind	15,y		;18 1b 4f
	emind	16,sp		;18 1b f0 10
	emind	16,x		;18 1b e0 10
	emind	16,y		;18 1b e8 10
	emind	8,sp+		;18 1b b7
	emind	8,x+		;18 1b 37
	emind	8,y+		;18 1b 77
	emind	8,sp-		;18 1b b8
	emind	8,x-		;18 1b 38
	emind	8,y-		;18 1b 78
	emind	a,sp		;18 1b f4
	emind	a,x		;18 1b e4
	emind	a,y		;18 1b ec
	emind	b,sp		;18 1b f5
	emind	b,x		;18 1b e5
	emind	b,y		;18 1b ed
	emind	d,sp		;18 1b f6
	emind	d,x		;18 1b e6
	emind	d,y		;18 1b ee
	emind	ext,sp		;18 1b f2s00r00
	emind	ext,x		;18 1b e2s00r00
	emind	ext,y		;18 1b eas00r00
	emind	ind,pc		;18 1b f8 37
	emind	ind,sp		;18 1b f0 37
	emind	ind,x		;18 1b e0 37
	emind	ind,y		;18 1b e8 37
	emind	small,pc	;18 1b ce
	emind	small,sp	;18 1b 8e
	emind	small,x		;18 1b 0e
	emind	small,y		;18 1b 4e
	eminm	1,+sp		;18 1f a0
	eminm	1,+x		;18 1f 20
	eminm	1,+y		;18 1f 60
	eminm	8,+sp		;18 1f a7
	eminm	8,+x		;18 1f 27
	eminm	8,+y		;18 1f 67
	eminm	,pc		;18 1f c0
	eminm	,sp		;18 1f 80
	eminm	,x		;18 1f 00
	eminm	,y		;18 1f 40
	eminm	1,-sp		;18 1f af
	eminm	1,-x		;18 1f 2f
	eminm	1,-y		;18 1f 6f
	eminm	8,-sp		;18 1f a8
	eminm	8,-x		;18 1f 28
	eminm	8,-y		;18 1f 68
	eminm	-1,sp		;18 1f 9f
	eminm	-1,x		;18 1f 1f
	eminm	-1,y		;18 1f 5f
	eminm	-16,sp		;18 1f 90
	eminm	-16,x		;18 1f 10
	eminm	-16,y		;18 1f 50
	eminm	-17,sp		;18 1f f1 ef
	eminm	-17,x		;18 1f e1 ef
	eminm	-17,y		;18 1f e9 ef
	eminm	-small,pc	;18 1f d2
	eminm	-small,sp	;18 1f 92
	eminm	-small,x	;18 1f 12
	eminm	-small,y	;18 1f 52
	eminm	0,pc		;18 1f c0
	eminm	0,sp		;18 1f 80
	eminm	0,x		;18 1f 00
	eminm	0,y		;18 1f 40
	eminm	1,sp+		;18 1f b0
	eminm	1,x+		;18 1f 30
	eminm	1,y+		;18 1f 70
	eminm	1,sp		;18 1f 81
	eminm	1,x		;18 1f 01
	eminm	1,y		;18 1f 41
	eminm	1,sp-		;18 1f bf
	eminm	1,x-		;18 1f 3f
	eminm	1,y-		;18 1f 7f
	eminm	125,pc		;18 1f f8 7d
	eminm	125,sp		;18 1f f0 7d
	eminm	125,x		;18 1f e0 7d
	eminm	125,y		;18 1f e8 7d
	eminm	15,sp		;18 1f 8f
	eminm	15,x		;18 1f 0f
	eminm	15,y		;18 1f 4f
	eminm	16,sp		;18 1f f0 10
	eminm	16,x		;18 1f e0 10
	eminm	16,y		;18 1f e8 10
	eminm	8,sp+		;18 1f b7
	eminm	8,x+		;18 1f 37
	eminm	8,y+		;18 1f 77
	eminm	8,sp-		;18 1f b8
	eminm	8,x-		;18 1f 38
	eminm	8,y-		;18 1f 78
	eminm	a,sp		;18 1f f4
	eminm	a,x		;18 1f e4
	eminm	a,y		;18 1f ec
	eminm	b,sp		;18 1f f5
	eminm	b,x		;18 1f e5
	eminm	b,y		;18 1f ed
	eminm	d,sp		;18 1f f6
	eminm	d,x		;18 1f e6
	eminm	d,y		;18 1f ee
	eminm	ext,sp		;18 1f f2s00r00
	eminm	ext,x		;18 1f e2s00r00
	eminm	ext,y		;18 1f eas00r00
	eminm	ind,pc		;18 1f f8 37
	eminm	ind,sp		;18 1f f0 37
	eminm	ind,x		;18 1f e0 37
	eminm	ind,y		;18 1f e8 37
	eminm	small,pc	;18 1f ce
	eminm	small,sp	;18 1f 8e
	eminm	small,x		;18 1f 0e
	eminm	small,y		;18 1f 4e
	eora	#immed		;88r00
	eora	1,+sp		;a8 a0
	eora	1,+x		;a8 20
	eora	1,+y		;a8 60
	eora	8,+sp		;a8 a7
	eora	8,+x		;a8 27
	eora	8,+y		;a8 67
	eora	,pc		;a8 c0
	eora	,sp		;a8 80
	eora	,x		;a8 00
	eora	,y		;a8 40
	eora	1,-sp		;a8 af
	eora	1,-x		;a8 2f
	eora	1,-y		;a8 6f
	eora	8,-sp		;a8 a8
	eora	8,-x		;a8 28
	eora	8,-y		;a8 68
	eora	-1,sp		;a8 9f
	eora	-1,x		;a8 1f
	eora	-1,y		;a8 5f
	eora	-16,sp		;a8 90
	eora	-16,x		;a8 10
	eora	-16,y		;a8 50
	eora	-17,sp		;a8 f1 ef
	eora	-17,x		;a8 e1 ef
	eora	-17,y		;a8 e9 ef
	eora	-small,pc	;a8 d2
	eora	-small,sp	;a8 92
	eora	-small,x	;a8 12
	eora	-small,y	;a8 52
	eora	0,pc		;a8 c0
	eora	0,sp		;a8 80
	eora	0,x		;a8 00
	eora	0,y		;a8 40
	eora	1,sp+		;a8 b0
	eora	1,x+		;a8 30
	eora	1,y+		;a8 70
	eora	1,sp		;a8 81
	eora	1,x		;a8 01
	eora	1,y		;a8 41
	eora	1,sp-		;a8 bf
	eora	1,x-		;a8 3f
	eora	1,y-		;a8 7f
	eora	125,pc		;a8 f8 7d
	eora	125,sp		;a8 f0 7d
	eora	125,x		;a8 e0 7d
	eora	125,y		;a8 e8 7d
	eora	15,sp		;a8 8f
	eora	15,x		;a8 0f
	eora	15,y		;a8 4f
	eora	16,sp		;a8 f0 10
	eora	16,x		;a8 e0 10
	eora	16,y		;a8 e8 10
	eora	8,sp+		;a8 b7
	eora	8,x+		;a8 37
	eora	8,y+		;a8 77
	eora	8,sp-		;a8 b8
	eora	8,x-		;a8 38
	eora	8,y-		;a8 78
	eora	a,sp		;a8 f4
	eora	a,x		;a8 e4
	eora	a,y		;a8 ec
	eora	b,sp		;a8 f5
	eora	b,x		;a8 e5
	eora	b,y		;a8 ed
	eora	d,sp		;a8 f6
	eora	d,x		;a8 e6
	eora	d,y		;a8 ee
	eora	*dir		;98*00
	eora	ext		;b8s00r00
	eora	ext,sp		;a8 f2s00r00
	eora	ext,x		;a8 e2s00r00
	eora	ext,y		;a8 eas00r00
	eora	ind,pc		;a8 f8 37
	eora	ind,sp		;a8 f0 37
	eora	ind,x		;a8 e0 37
	eora	ind,y		;a8 e8 37
	eora	small,pc	;a8 ce
	eora	small,sp	;a8 8e
	eora	small,x		;a8 0e
	eora	small,y		;a8 4e
	eorb	#immed		;c8r00
	eorb	1,+sp		;e8 a0
	eorb	1,+x		;e8 20
	eorb	1,+y		;e8 60
	eorb	8,+sp		;e8 a7
	eorb	8,+x		;e8 27
	eorb	8,+y		;e8 67
	eorb	,pc		;e8 c0
	eorb	,sp		;e8 80
	eorb	,x		;e8 00
	eorb	,y		;e8 40
	eorb	1,-sp		;e8 af
	eorb	1,-x		;e8 2f
	eorb	1,-y		;e8 6f
	eorb	8,-sp		;e8 a8
	eorb	8,-x		;e8 28
	eorb	8,-y		;e8 68
	eorb	-1,sp		;e8 9f
	eorb	-1,x		;e8 1f
	eorb	-1,y		;e8 5f
	eorb	-16,sp		;e8 90
	eorb	-16,x		;e8 10
	eorb	-16,y		;e8 50
	eorb	-17,sp		;e8 f1 ef
	eorb	-17,x		;e8 e1 ef
	eorb	-17,y		;e8 e9 ef
	eorb	-small,pc	;e8 d2
	eorb	-small,sp	;e8 92
	eorb	-small,x	;e8 12
	eorb	-small,y	;e8 52
	eorb	0,pc		;e8 c0
	eorb	0,sp		;e8 80
	eorb	0,x		;e8 00
	eorb	0,y		;e8 40
	eorb	1,sp+		;e8 b0
	eorb	1,x+		;e8 30
	eorb	1,y+		;e8 70
	eorb	1,sp		;e8 81
	eorb	1,x		;e8 01
	eorb	1,y		;e8 41
	eorb	1,sp-		;e8 bf
	eorb	1,x-		;e8 3f
	eorb	1,y-		;e8 7f
	eorb	125,pc		;e8 f8 7d
	eorb	125,sp		;e8 f0 7d
	eorb	125,x		;e8 e0 7d
	eorb	125,y		;e8 e8 7d
	eorb	15,sp		;e8 8f
	eorb	15,x		;e8 0f
	eorb	15,y		;e8 4f
	eorb	16,sp		;e8 f0 10
	eorb	16,x		;e8 e0 10
	eorb	16,y		;e8 e8 10
	eorb	8,sp+		;e8 b7
	eorb	8,x+		;e8 37
	eorb	8,y+		;e8 77
	eorb	8,sp-		;e8 b8
	eorb	8,x-		;e8 38
	eorb	8,y-		;e8 78
	eorb	a,sp		;e8 f4
	eorb	a,x		;e8 e4
	eorb	a,y		;e8 ec
	eorb	b,sp		;e8 f5
	eorb	b,x		;e8 e5
	eorb	b,y		;e8 ed
	eorb	d,sp		;e8 f6
	eorb	d,x		;e8 e6
	eorb	d,y		;e8 ee
	eorb	*dir		;d8*00
	eorb	ext		;f8s00r00
	eorb	ext,sp		;e8 f2s00r00
	eorb	ext,x		;e8 e2s00r00
	eorb	ext,y		;e8 eas00r00
	eorb	ind,pc		;e8 f8 37
	eorb	ind,sp		;e8 f0 37
	eorb	ind,x		;e8 e0 37
	eorb	ind,y		;e8 e8 37
	eorb	small,pc	;e8 ce
	eorb	small,sp	;e8 8e
	eorb	small,x		;e8 0e
	eorb	small,y		;e8 4e
	etbl    5,x		;18 3f 05
	exg	a,a		;b7 80
	exg	a,b		;b7 81
	exg	a,ccr		;b7 82
	exg	a,d		;b7 84
	exg	a,sp		;b7 87
	exg	a,x		;b7 85
	exg	a,y		;b7 86
	exg	b,a		;b7 90
	exg	b,b		;b7 91
	exg	b,ccr		;b7 92
	exg	b,d		;b7 94
	exg	b,sp		;b7 97
	exg	b,x		;b7 95
	exg	b,y		;b7 96
	exg	ccr,a		;b7 a0
	exg	ccr,b		;b7 a1
	exg	ccr,ccr		;b7 a2
	exg	ccr,d		;b7 a4
	exg	ccr,sp		;b7 a7
	exg	ccr,x		;b7 a5
	exg	ccr,y		;b7 a6
	exg	d,a		;b7 c0
	exg	d,b		;b7 c1
	exg	d,ccr		;b7 c2
	exg	d,d		;b7 c4
	exg	d,sp		;b7 c7
	exg	d,x		;b7 c5
	exg	d,y		;b7 c6
	exg	sp,a		;b7 f0
	exg	sp,b		;b7 f1
	exg	sp,ccr		;b7 f2
	exg	sp,d		;b7 f4
	exg	sp,sp		;b7 f7
	exg	sp,x		;b7 f5
	exg	sp,y		;b7 f6
	exg	x,a		;b7 d0
	exg	x,b		;b7 d1
	exg	x,ccr		;b7 d2
	exg	x,d		;b7 d4
	exg	x,sp		;b7 d7
	exg	x,x		;b7 d5
	exg	x,y		;b7 d6
	exg	x,y		;b7 d6
	exg	y,a		;b7 e0
	exg	y,b		;b7 e1
	exg	y,ccr		;b7 e2
	exg	y,d		;b7 e4
	exg	y,sp		;b7 e7
	exg	y,x		;b7 e5
	exg	y,y		;b7 e6

f:	fdiv			;18 11

i:	idiv			;18 10
	inc	1,+sp		;62 a0
	inc	1,+x		;62 20
	inc	1,+y		;62 60
	inc	8,+sp		;62 a7
	inc	8,+x		;62 27
	inc	8,+y		;62 67
	inc	,pc		;62 c0
	inc	,sp		;62 80
	inc	,x		;62 00
	inc	,y		;62 40
	inc	1,-sp		;62 af
	inc	1,-x		;62 2f
	inc	1,-y		;62 6f
	inc	8,-sp		;62 a8
	inc	8,-x		;62 28
	inc	8,-y		;62 68
	inc	-1,sp		;62 9f
	inc	-1,x		;62 1f
	inc	-1,y		;62 5f
	inc	-16,sp		;62 90
	inc	-16,x		;62 10
	inc	-16,y		;62 50
	inc	-17,sp		;62 f1 ef
	inc	-17,x		;62 e1 ef
	inc	-17,y		;62 e9 ef
	inc	-small,pc	;62 d2
	inc	-small,sp	;62 92
	inc	-small,x	;62 12
	inc	-small,y	;62 52
	inc	0,pc		;62 c0
	inc	0,sp		;62 80
	inc	0,x		;62 00
	inc	0,y		;62 40
	inc	1,sp+		;62 b0
	inc	1,x+		;62 30
	inc	1,y+		;62 70
	inc	1,sp		;62 81
	inc	1,x		;62 01
	inc	1,y		;62 41
	inc	1,sp-		;62 bf
	inc	1,x-		;62 3f
	inc	1,y-		;62 7f
	inc	125,pc		;62 f8 7d
	inc	125,sp		;62 f0 7d
	inc	125,x		;62 e0 7d
	inc	125,y		;62 e8 7d
	inc	15,sp		;62 8f
	inc	15,x		;62 0f
	inc	15,y		;62 4f
	inc	16,sp		;62 f0 10
	inc	16,x		;62 e0 10
	inc	16,y		;62 e8 10
	inc	8,sp+		;62 b7
	inc	8,x+		;62 37
	inc	8,y+		;62 77
	inc	8,sp-		;62 b8
	inc	8,x-		;62 38
	inc	8,y-		;62 78
	inc	a,sp		;62 f4
	inc	a,x		;62 e4
	inc	a,y		;62 ec
	inc	b,sp		;62 f5
	inc	b,x		;62 e5
	inc	b,y		;62 ed
	inc	d,sp		;62 f6
	inc	d,x		;62 e6
	inc	d,y		;62 ee
	inc	*dir		;72s00r00
	inc	ext		;72s00r00
	inc	ext,sp		;62 f2s00r00
	inc	ext,x		;62 e2s00r00
	inc	ext,y		;62 eas00r00
	inc	ind,pc		;62 f8 37
	inc	ind,sp		;62 f0 37
	inc	ind,x		;62 e0 37
	inc	ind,y		;62 e8 37
	inc	small,pc	;62 ce
	inc	small,sp	;62 8e
	inc	small,x		;62 0e
	inc	small,y		;62 4e
	inca			;42
	incb			;52
	ins			;1b 81
	inx			;08
	iny			;02

j:	jmp	1,+sp		;05 a0
	jmp	1,+x		;05 20
	jmp	1,+y		;05 60
	jmp	8,+sp		;05 a7
	jmp	8,+x		;05 27
	jmp	8,+y		;05 67
	jmp	,pc		;05 c0
	jmp	,sp		;05 80
	jmp	,x		;05 00
	jmp	,y		;05 40
	jmp	1,-sp		;05 af
	jmp	1,-x		;05 2f
	jmp	1,-y		;05 6f
	jmp	8,-sp		;05 a8
	jmp	8,-x		;05 28
	jmp	8,-y		;05 68
	jmp	-1,sp		;05 9f
	jmp	-1,x		;05 1f
	jmp	-1,y		;05 5f
	jmp	-16,sp		;05 90
	jmp	-16,x		;05 10
	jmp	-16,y		;05 50
	jmp	-17,sp		;05 f1 ef
	jmp	-17,x		;05 e1 ef
	jmp	-17,y		;05 e9 ef
	jmp	-small,pc	;05 d2
	jmp	-small,sp	;05 92
	jmp	-small,x	;05 12
	jmp	-small,y	;05 52
	jmp	0,pc		;05 c0
	jmp	0,sp		;05 80
	jmp	0,x		;05 00
	jmp	0,y		;05 40
	jmp	1,sp+		;05 b0
	jmp	1,x+		;05 30
	jmp	1,y+		;05 70
	jmp	1,sp		;05 81
	jmp	1,x		;05 01
	jmp	1,y		;05 41
	jmp	1,sp-		;05 bf
	jmp	1,x-		;05 3f
	jmp	1,y-		;05 7f
	jmp	125,pc		;05 f8 7d
	jmp	125,sp		;05 f0 7d
	jmp	125,x		;05 e0 7d
	jmp	125,y		;05 e8 7d
	jmp	15,sp		;05 8f
	jmp	15,x		;05 0f
	jmp	15,y		;05 4f
	jmp	16,sp		;05 f0 10
	jmp	16,x		;05 e0 10
	jmp	16,y		;05 e8 10
	jmp	8,sp+		;05 b7
	jmp	8,x+		;05 37
	jmp	8,y+		;05 77
	jmp	8,sp-		;05 b8
	jmp	8,x-		;05 38
	jmp	8,y-		;05 78
	jmp	a,sp		;05 f4
	jmp	a,x		;05 e4
	jmp	a,y		;05 ec
	jmp	b,sp		;05 f5
	jmp	b,x		;05 e5
	jmp	b,y		;05 ed
	jmp	d,sp		;05 f6
	jmp	d,x		;05 e6
	jmp	d,y		;05 ee
	jmp	*dir		;06s00r00
	jmp	ext		;06s00r00
	jmp	ext,sp		;05 f2s00r00
	jmp	ext,x		;05 e2s00r00
	jmp	ext,y		;05 eas00r00
	jmp	ind,pc		;05 f8 37
	jmp	ind,sp		;05 f0 37
	jmp	ind,x		;05 e0 37
	jmp	ind,y		;05 e8 37
	jmp	small,pc	;05 ce
	jmp	small,sp	;05 8e
	jmp	small,x		;05 0e
	jmp	small,y		;05 4e
	jsr	1,+sp		;15 a0
	jsr	1,+x		;15 20
	jsr	1,+y		;15 60
	jsr	8,+sp		;15 a7
	jsr	8,+x		;15 27
	jsr	8,+y		;15 67
	jsr	,pc		;15 c0
	jsr	,sp		;15 80
	jsr	,x		;15 00
	jsr	,y		;15 40
	jsr	1,-sp		;15 af
	jsr	1,-x		;15 2f
	jsr	1,-y		;15 6f
	jsr	8,-sp		;15 a8
	jsr	8,-x		;15 28
	jsr	8,-y		;15 68
	jsr	-1,sp		;15 9f
	jsr	-1,x		;15 1f
	jsr	-1,y		;15 5f
	jsr	-16,sp		;15 90
	jsr	-16,x		;15 10
	jsr	-16,y		;15 50
	jsr	-17,sp		;15 f1 ef
	jsr	-17,x		;15 e1 ef
	jsr	-17,y		;15 e9 ef
	jsr	-small,pc	;15 d2
	jsr	-small,sp	;15 92
	jsr	-small,x	;15 12
	jsr	-small,y	;15 52
	jsr	0,pc		;15 c0
	jsr	0,sp		;15 80
	jsr	0,x		;15 00
	jsr	0,y		;15 40
	jsr	1,sp+		;15 b0
	jsr	1,x+		;15 30
	jsr	1,y+		;15 70
	jsr	1,sp		;15 81
	jsr	1,x		;15 01
	jsr	1,y		;15 41
	jsr	1,sp-		;15 bf
	jsr	1,x-		;15 3f
	jsr	1,y-		;15 7f
	jsr	125,pc		;15 f8 7d
	jsr	125,sp		;15 f0 7d
	jsr	125,x		;15 e0 7d
	jsr	125,y		;15 e8 7d
	jsr	15,sp		;15 8f
	jsr	15,x		;15 0f
	jsr	15,y		;15 4f
	jsr	16,sp		;15 f0 10
	jsr	16,x		;15 e0 10
	jsr	16,y		;15 e8 10
	jsr	8,sp+		;15 b7
	jsr	8,x+		;15 37
	jsr	8,y+		;15 77
	jsr	8,sp-		;15 b8
	jsr	8,x-		;15 38
	jsr	8,y-		;15 78
	jsr	a,sp		;15 f4
	jsr	a,x		;15 e4
	jsr	a,y		;15 ec
	jsr	b,sp		;15 f5
	jsr	b,x		;15 e5
	jsr	b,y		;15 ed
	jsr	d,sp		;15 f6
	jsr	d,x		;15 e6
	jsr	d,y		;15 ee
	jsr	*dir		;17*00
	jsr	ext		;16s00r00
	jsr	ext,sp		;15 f2s00r00
	jsr	ext,x		;15 e2s00r00
	jsr	ext,y		;15 eas00r00
	jsr	ind,pc		;15 f8 37
	jsr	ind,sp		;15 f0 37
	jsr	ind,x		;15 e0 37
	jsr	ind,y		;15 e8 37
	jsr	small,pc	;15 ce
	jsr	small,sp	;15 8e
	jsr	small,x		;15 0e
	jsr	small,y		;15 4e

l:	lbcc	.		;18 24 ff fc
	lbcc	.		;18 24 ff fc
	lbcs	.		;18 25 ff fc
	lbeq	.		;18 27 ff fc
	lbge	.		;18 2c ff fc
	lbgt	.		;18 2e ff fc
	lbhi	.		;18 22 ff fc
	lble	.		;18 2f ff fc
	lbls	.		;18 23 ff fc
	lblt	.		;18 2d ff fc
	lbmi	.		;18 2b ff fc
	lbne	.		;18 26 ff fc
	lbpl	.		;18 2a ff fc
	lbra	.		;18 20 ff fc
	lbrn	.		;18 21 ff fc
	lbvc	.		;18 28 ff fc
	lbvs	.		;18 29 ff fc
	ldaa	#immed		;86r00
	ldaa	1,+sp		;a6 a0
	ldaa	1,+x		;a6 20
	ldaa	1,+y		;a6 60
	ldaa	8,+sp		;a6 a7
	ldaa	8,+x		;a6 27
	ldaa	8,+y		;a6 67
	ldaa	,pc		;a6 c0
	ldaa	,sp		;a6 80
	ldaa	,x		;a6 00
	ldaa	,y		;a6 40
	ldaa	1,-sp		;a6 af
	ldaa	1,-x		;a6 2f
	ldaa	1,-y		;a6 6f
	ldaa	8,-sp		;a6 a8
	ldaa	8,-x		;a6 28
	ldaa	8,-y		;a6 68
	ldaa	-1,sp		;a6 9f
	ldaa	-1,x		;a6 1f
	ldaa	-1,y		;a6 5f
	ldaa	-16,sp		;a6 90
	ldaa	-16,x		;a6 10
	ldaa	-16,y		;a6 50
	ldaa	-17,sp		;a6 f1 ef
	ldaa	-17,x		;a6 e1 ef
	ldaa	-17,y		;a6 e9 ef
	ldaa	-small,pc	;a6 d2
	ldaa	-small,sp	;a6 92
	ldaa	-small,x	;a6 12
	ldaa	-small,y	;a6 52
	ldaa	0,pc		;a6 c0
	ldaa	0,sp		;a6 80
	ldaa	0,x		;a6 00
	ldaa	0,y		;a6 40
	ldaa	1,sp+		;a6 b0
	ldaa	1,x+		;a6 30
	ldaa	1,y+		;a6 70
	ldaa	1,sp		;a6 81
	ldaa	1,x		;a6 01
	ldaa	1,y		;a6 41
	ldaa	1,sp-		;a6 bf
	ldaa	1,x-		;a6 3f
	ldaa	1,y-		;a6 7f
	ldaa	125,pc		;a6 f8 7d
	ldaa	125,sp		;a6 f0 7d
	ldaa	125,x		;a6 e0 7d
	ldaa	125,y		;a6 e8 7d
	ldaa	15,sp		;a6 8f
	ldaa	15,x		;a6 0f
	ldaa	15,y		;a6 4f
	ldaa	16,sp		;a6 f0 10
	ldaa	16,x		;a6 e0 10
	ldaa	16,y		;a6 e8 10
	ldaa	8,sp+		;a6 b7
	ldaa	8,x+		;a6 37
	ldaa	8,y+		;a6 77
	ldaa	8,sp-		;a6 b8
	ldaa	8,x-		;a6 38
	ldaa	8,y-		;a6 78
	ldaa	a,sp		;a6 f4
	ldaa	a,x		;a6 e4
	ldaa	a,y		;a6 ec
	ldaa	b,sp		;a6 f5
	ldaa	b,x		;a6 e5
	ldaa	b,y		;a6 ed
	ldaa	d,sp		;a6 f6
	ldaa	d,x		;a6 e6
	ldaa	d,y		;a6 ee
	ldaa	*dir		;96*00
	ldaa	ext		;b6s00r00
	ldaa	ext,sp		;a6 f2s00r00
	ldaa	ext,x		;a6 e2s00r00
	ldaa	ext,y		;a6 eas00r00
	ldaa	ind,pc		;a6 f8 37
	ldaa	ind,sp		;a6 f0 37
	ldaa	ind,x		;a6 e0 37
	ldaa	ind,y		;a6 e8 37
	ldaa	small,pc	;a6 ce
	ldaa	small,sp	;a6 8e
	ldaa	small,x		;a6 0e
	ldaa	small,y		;a6 4e
	ldab	#immed		;c6r00
	ldab	1,+sp		;e6 a0
	ldab	1,+x		;e6 20
	ldab	1,+y		;e6 60
	ldab	8,+sp		;e6 a7
	ldab	8,+x		;e6 27
	ldab	8,+y		;e6 67
	ldab	,pc		;e6 c0
	ldab	,sp		;e6 80
	ldab	,x		;e6 00
	ldab	,y		;e6 40
	ldab	1,-sp		;e6 af
	ldab	1,-x		;e6 2f
	ldab	1,-y		;e6 6f
	ldab	8,-sp		;e6 a8
	ldab	8,-x		;e6 28
	ldab	8,-y		;e6 68
	ldab	-1,sp		;e6 9f
	ldab	-1,x		;e6 1f
	ldab	-1,y		;e6 5f
	ldab	-16,sp		;e6 90
	ldab	-16,x		;e6 10
	ldab	-16,y		;e6 50
	ldab	-17,sp		;e6 f1 ef
	ldab	-17,x		;e6 e1 ef
	ldab	-17,y		;e6 e9 ef
	ldab	-small,pc	;e6 d2
	ldab	-small,sp	;e6 92
	ldab	-small,x	;e6 12
	ldab	-small,y	;e6 52
	ldab	0,pc		;e6 c0
	ldab	0,sp		;e6 80
	ldab	0,x		;e6 00
	ldab	0,y		;e6 40
	ldab	1,sp+		;e6 b0
	ldab	1,x+		;e6 30
	ldab	1,y+		;e6 70
	ldab	1,sp		;e6 81
	ldab	1,x		;e6 01
	ldab	1,y		;e6 41
	ldab	1,sp-		;e6 bf
	ldab	1,x-		;e6 3f
	ldab	1,y-		;e6 7f
	ldab	125,pc		;e6 f8 7d
	ldab	125,sp		;e6 f0 7d
	ldab	125,x		;e6 e0 7d
	ldab	125,y		;e6 e8 7d
	ldab	15,sp		;e6 8f
	ldab	15,x		;e6 0f
	ldab	15,y		;e6 4f
	ldab	16,sp		;e6 f0 10
	ldab	16,x		;e6 e0 10
	ldab	16,y		;e6 e8 10
	ldab	8,sp+		;e6 b7
	ldab	8,x+		;e6 37
	ldab	8,y+		;e6 77
	ldab	8,sp-		;e6 b8
	ldab	8,x-		;e6 38
	ldab	8,y-		;e6 78
	ldab	a,sp		;e6 f4
	ldab	a,x		;e6 e4
	ldab	a,y		;e6 ec
	ldab	b,sp		;e6 f5
	ldab	b,x		;e6 e5
	ldab	b,y		;e6 ed
	ldab	d,sp		;e6 f6
	ldab	d,x		;e6 e6
	ldab	d,y		;e6 ee
	ldab	*dir		;d6*00
	ldab	ext		;f6s00r00
	ldab	ext,sp		;e6 f2s00r00
	ldab	ext,x		;e6 e2s00r00
	ldab	ext,y		;e6 eas00r00
	ldab	ind,pc		;e6 f8 37
	ldab	ind,sp		;e6 f0 37
	ldab	ind,x		;e6 e0 37
	ldab	ind,y		;e6 e8 37
	ldab	small,pc	;e6 ce
	ldab	small,sp	;e6 8e
	ldab	small,x		;e6 0e
	ldab	small,y		;e6 4e
	ldd	#immed		;ccs00r00
	ldd	1,+sp		;ec a0
	ldd	1,+x		;ec 20
	ldd	1,+y		;ec 60
	ldd	8,+sp		;ec a7
	ldd	8,+x		;ec 27
	ldd	8,+y		;ec 67
	ldd	,pc		;ec c0
	ldd	,sp		;ec 80
	ldd	,x		;ec 00
	ldd	,y		;ec 40
	ldd	1,-sp		;ec af
	ldd	1,-x		;ec 2f
	ldd	1,-y		;ec 6f
	ldd	8,-sp		;ec a8
	ldd	8,-x		;ec 28
	ldd	8,-y		;ec 68
	ldd	-1,sp		;ec 9f
	ldd	-1,x		;ec 1f
	ldd	-1,y		;ec 5f
	ldd	-16,sp		;ec 90
	ldd	-16,x		;ec 10
	ldd	-16,y		;ec 50
	ldd	-17,sp		;ec f1 ef
	ldd	-17,x		;ec e1 ef
	ldd	-17,y		;ec e9 ef
	ldd	-small,pc	;ec d2
	ldd	-small,sp	;ec 92
	ldd	-small,x	;ec 12
	ldd	-small,y	;ec 52
	ldd	0,pc		;ec c0
	ldd	0,sp		;ec 80
	ldd	0,x		;ec 00
	ldd	0,y		;ec 40
	ldd	1,sp+		;ec b0
	ldd	1,x+		;ec 30
	ldd	1,y+		;ec 70
	ldd	1,sp		;ec 81
	ldd	1,x		;ec 01
	ldd	1,y		;ec 41
	ldd	1,sp-		;ec bf
	ldd	1,x-		;ec 3f
	ldd	1,y-		;ec 7f
	ldd	125,pc		;ec f8 7d
	ldd	125,sp		;ec f0 7d
	ldd	125,x		;ec e0 7d
	ldd	125,y		;ec e8 7d
	ldd	15,sp		;ec 8f
	ldd	15,x		;ec 0f
	ldd	15,y		;ec 4f
	ldd	16,sp		;ec f0 10
	ldd	16,x		;ec e0 10
	ldd	16,y		;ec e8 10
	ldd	8,sp+		;ec b7
	ldd	8,x+		;ec 37
	ldd	8,y+		;ec 77
	ldd	8,sp-		;ec b8
	ldd	8,x-		;ec 38
	ldd	8,y-		;ec 78
	ldd	a,sp		;ec f4
	ldd	a,x		;ec e4
	ldd	a,y		;ec ec
	ldd	b,sp		;ec f5
	ldd	b,x		;ec e5
	ldd	b,y		;ec ed
	ldd	d,sp		;ec f6
	ldd	d,x		;ec e6
	ldd	d,y		;ec ee
	ldd	*dir		;dc*00
	ldd	ext		;fcs00r00
	ldd	ext,sp		;ec f2s00r00
	ldd	ext,x		;ec e2s00r00
	ldd	ext,y		;ec eas00r00
	ldd	ind,pc		;ec f8 37
	ldd	ind,sp		;ec f0 37
	ldd	ind,x		;ec e0 37
	ldd	ind,y		;ec e8 37
	ldd	small,pc	;ec ce
	ldd	small,sp	;ec 8e
	ldd	small,x		;ec 0e
	ldd	small,y		;ec 4e
	lds	#immed		;cfs00r00
	lds	1,+sp		;ef a0
	lds	1,+x		;ef 20
	lds	1,+y		;ef 60
	lds	8,+sp		;ef a7
	lds	8,+x		;ef 27
	lds	8,+y		;ef 67
	lds	,pc		;ef c0
	lds	,sp		;ef 80
	lds	,x		;ef 00
	lds	,y		;ef 40
	lds	1,-sp		;ef af
	lds	1,-x		;ef 2f
	lds	1,-y		;ef 6f
	lds	8,-sp		;ef a8
	lds	8,-x		;ef 28
	lds	8,-y		;ef 68
	lds	-1,sp		;ef 9f
	lds	-1,x		;ef 1f
	lds	-1,y		;ef 5f
	lds	-16,sp		;ef 90
	lds	-16,x		;ef 10
	lds	-16,y		;ef 50
	lds	-17,sp		;ef f1 ef
	lds	-17,x		;ef e1 ef
	lds	-17,y		;ef e9 ef
	lds	-small,pc	;ef d2
	lds	-small,sp	;ef 92
	lds	-small,x	;ef 12
	lds	-small,y	;ef 52
	lds	0,pc		;ef c0
	lds	0,sp		;ef 80
	lds	0,x		;ef 00
	lds	0,y		;ef 40
	lds	1,sp+		;ef b0
	lds	1,x+		;ef 30
	lds	1,y+		;ef 70
	lds	1,sp		;ef 81
	lds	1,x		;ef 01
	lds	1,y		;ef 41
	lds	1,sp-		;ef bf
	lds	1,x-		;ef 3f
	lds	1,y-		;ef 7f
	lds	125,pc		;ef f8 7d
	lds	125,sp		;ef f0 7d
	lds	125,x		;ef e0 7d
	lds	125,y		;ef e8 7d
	lds	15,sp		;ef 8f
	lds	15,x		;ef 0f
	lds	15,y		;ef 4f
	lds	16,sp		;ef f0 10
	lds	16,x		;ef e0 10
	lds	16,y		;ef e8 10
	lds	8,sp+		;ef b7
	lds	8,x+		;ef 37
	lds	8,y+		;ef 77
	lds	8,sp-		;ef b8
	lds	8,x-		;ef 38
	lds	8,y-		;ef 78
	lds	a,sp		;ef f4
	lds	a,x		;ef e4
	lds	a,y		;ef ec
	lds	b,sp		;ef f5
	lds	b,x		;ef e5
	lds	b,y		;ef ed
	lds	d,sp		;ef f6
	lds	d,x		;ef e6
	lds	d,y		;ef ee
	lds	*dir		;df*00
	lds	ext		;ffs00r00
	lds	ext,sp		;ef f2s00r00
	lds	ext,x		;ef e2s00r00
	lds	ext,y		;ef eas00r00
	lds	ind,pc		;ef f8 37
	lds	ind,sp		;ef f0 37
	lds	ind,x		;ef e0 37
	lds	ind,y		;ef e8 37
	lds	small,pc	;ef ce
	lds	small,sp	;ef 8e
	lds	small,x		;ef 0e
	lds	small,y		;ef 4e
	ldx	#immed		;ces00r00
	ldx	1,+sp		;ee a0
	ldx	1,+x		;ee 20
	ldx	1,+y		;ee 60
	ldx	8,+sp		;ee a7
	ldx	8,+x		;ee 27
	ldx	8,+y		;ee 67
	ldx	,pc		;ee c0
	ldx	,sp		;ee 80
	ldx	,x		;ee 00
	ldx	,y		;ee 40
	ldx	1,-sp		;ee af
	ldx	1,-x		;ee 2f
	ldx	1,-y		;ee 6f
	ldx	8,-sp		;ee a8
	ldx	8,-x		;ee 28
	ldx	8,-y		;ee 68
	ldx	-1,sp		;ee 9f
	ldx	-1,x		;ee 1f
	ldx	-1,y		;ee 5f
	ldx	-16,sp		;ee 90
	ldx	-16,x		;ee 10
	ldx	-16,y		;ee 50
	ldx	-17,sp		;ee f1 ef
	ldx	-17,x		;ee e1 ef
	ldx	-17,y		;ee e9 ef
	ldx	-small,pc	;ee d2
	ldx	-small,sp	;ee 92
	ldx	-small,x	;ee 12
	ldx	-small,y	;ee 52
	ldx	0,pc		;ee c0
	ldx	0,sp		;ee 80
	ldx	0,x		;ee 00
	ldx	0,y		;ee 40
	ldx	1,sp+		;ee b0
	ldx	1,x+		;ee 30
	ldx	1,y+		;ee 70
	ldx	1,sp		;ee 81
	ldx	1,x		;ee 01
	ldx	1,y		;ee 41
	ldx	1,sp-		;ee bf
	ldx	1,x-		;ee 3f
	ldx	1,y-		;ee 7f
	ldx	125,pc		;ee f8 7d
	ldx	125,sp		;ee f0 7d
	ldx	125,x		;ee e0 7d
	ldx	125,y		;ee e8 7d
	ldx	15,sp		;ee 8f
	ldx	15,x		;ee 0f
	ldx	15,y		;ee 4f
	ldx	16,sp		;ee f0 10
	ldx	16,x		;ee e0 10
	ldx	16,y		;ee e8 10
	ldx	8,sp+		;ee b7
	ldx	8,x+		;ee 37
	ldx	8,y+		;ee 77
	ldx	8,sp-		;ee b8
	ldx	8,x-		;ee 38
	ldx	8,y-		;ee 78
	ldx	a,sp		;ee f4
	ldx	a,x		;ee e4
	ldx	a,y		;ee ec
	ldx	b,sp		;ee f5
	ldx	b,x		;ee e5
	ldx	b,y		;ee ed
	ldx	d,sp		;ee f6
	ldx	d,x		;ee e6
	ldx	d,y		;ee ee
	ldx	*dir		;de*00
	ldx	ext		;fes00r00
	ldx	ext,sp		;ee f2s00r00
	ldx	ext,x		;ee e2s00r00
	ldx	ext,y		;ee eas00r00
	ldx	ind,pc		;ee f8 37
	ldx	ind,sp		;ee f0 37
	ldx	ind,x		;ee e0 37
	ldx	ind,y		;ee e8 37
	ldx	small,pc	;ee ce
	ldx	small,sp	;ee 8e
	ldx	small,x		;ee 0e
	ldx	small,y		;ee 4e
	ldy	#immed		;cds00r00
	ldy	1,+sp		;ed a0
	ldy	1,+x		;ed 20
	ldy	1,+y		;ed 60
	ldy	8,+sp		;ed a7
	ldy	8,+x		;ed 27
	ldy	8,+y		;ed 67
	ldy	,pc		;ed c0
	ldy	,sp		;ed 80
	ldy	,x		;ed 00
	ldy	,y		;ed 40
	ldy	1,-sp		;ed af
	ldy	1,-x		;ed 2f
	ldy	1,-y		;ed 6f
	ldy	8,-sp		;ed a8
	ldy	8,-x		;ed 28
	ldy	8,-y		;ed 68
	ldy	-1,sp		;ed 9f
	ldy	-1,x		;ed 1f
	ldy	-1,y		;ed 5f
	ldy	-16,sp		;ed 90
	ldy	-16,x		;ed 10
	ldy	-16,y		;ed 50
	ldy	-17,sp		;ed f1 ef
	ldy	-17,x		;ed e1 ef
	ldy	-17,y		;ed e9 ef
	ldy	-small,pc	;ed d2
	ldy	-small,sp	;ed 92
	ldy	-small,x	;ed 12
	ldy	-small,y	;ed 52
	ldy	0,pc		;ed c0
	ldy	0,sp		;ed 80
	ldy	0,x		;ed 00
	ldy	0,y		;ed 40
	ldy	1,sp+		;ed b0
	ldy	1,x+		;ed 30
	ldy	1,y+		;ed 70
	ldy	1,sp		;ed 81
	ldy	1,x		;ed 01
	ldy	1,y		;ed 41
	ldy	1,sp-		;ed bf
	ldy	1,x-		;ed 3f
	ldy	1,y-		;ed 7f
	ldy	125,pc		;ed f8 7d
	ldy	125,sp		;ed f0 7d
	ldy	125,x		;ed e0 7d
	ldy	125,y		;ed e8 7d
	ldy	15,sp		;ed 8f
	ldy	15,x		;ed 0f
	ldy	15,y		;ed 4f
	ldy	16,sp		;ed f0 10
	ldy	16,x		;ed e0 10
	ldy	16,y		;ed e8 10
	ldy	8,sp+		;ed b7
	ldy	8,x+		;ed 37
	ldy	8,y+		;ed 77
	ldy	8,sp-		;ed b8
	ldy	8,x-		;ed 38
	ldy	8,y-		;ed 78
	ldy	a,sp		;ed f4
	ldy	a,x		;ed e4
	ldy	a,y		;ed ec
	ldy	b,sp		;ed f5
	ldy	b,x		;ed e5
	ldy	b,y		;ed ed
	ldy	d,sp		;ed f6
	ldy	d,x		;ed e6
	ldy	d,y		;ed ee
	ldy	*dir		;dd*00
	ldy	ext		;fds00r00
	ldy	ext,sp		;ed f2s00r00
	ldy	ext,x		;ed e2s00r00
	ldy	ext,y		;ed eas00r00
	ldy	ind,pc		;ed f8 37
	ldy	ind,sp		;ed f0 37
	ldy	ind,x		;ed e0 37
	ldy	ind,y		;ed e8 37
	ldy	small,pc	;ed ce
	ldy	small,sp	;ed 8e
	ldy	small,x		;ed 0e
	ldy	small,y		;ed 4e
	leas	1,+sp		;1b a0
	leas	1,+x		;1b 20
	leas	1,+y		;1b 60
	leas	8,+sp		;1b a7
	leas	8,+x		;1b 27
	leas	8,+y		;1b 67
	leas	,pc		;1b c0
	leas	,sp		;1b 80
	leas	,x		;1b 00
	leas	,y		;1b 40
	leas	1,-sp		;1b af
	leas	1,-x		;1b 2f
	leas	1,-y		;1b 6f
	leas	8,-sp		;1b a8
	leas	8,-x		;1b 28
	leas	8,-y		;1b 68
	leas	-1,sp		;1b 9f
	leas	-1,x		;1b 1f
	leas	-1,y		;1b 5f
	leas	-16,sp		;1b 90
	leas	-16,x		;1b 10
	leas	-16,y		;1b 50
	leas	-17,sp		;1b f1 ef
	leas	-17,x		;1b e1 ef
	leas	-17,y		;1b e9 ef
	leas	-small,pc	;1b d2
	leas	-small,sp	;1b 92
	leas	-small,x	;1b 12
	leas	-small,y	;1b 52
	leas	0,pc		;1b c0
	leas	0,sp		;1b 80
	leas	0,x		;1b 00
	leas	0,y		;1b 40
	leas	1,sp+		;1b b0
	leas	1,x+		;1b 30
	leas	1,y+		;1b 70
	leas	1,sp		;1b 81
	leas	1,x		;1b 01
	leas	1,y		;1b 41
	leas	1,sp-		;1b bf
	leas	1,x-		;1b 3f
	leas	1,y-		;1b 7f
	leas	125,pc		;1b f8 7d
	leas	125,sp		;1b f0 7d
	leas	125,x		;1b e0 7d
	leas	125,y		;1b e8 7d
	leas	15,sp		;1b 8f
	leas	15,x		;1b 0f
	leas	15,y		;1b 4f
	leas	16,sp		;1b f0 10
	leas	16,x		;1b e0 10
	leas	16,y		;1b e8 10
	leas	8,sp+		;1b b7
	leas	8,x+		;1b 37
	leas	8,y+		;1b 77
	leas	8,sp-		;1b b8
	leas	8,x-		;1b 38
	leas	8,y-		;1b 78
	leas	a,sp		;1b f4
	leas	a,x		;1b e4
	leas	a,y		;1b ec
	leas	b,sp		;1b f5
	leas	b,x		;1b e5
	leas	b,y		;1b ed
	leas	d,sp		;1b f6
	leas	d,x		;1b e6
	leas	d,y		;1b ee
	leas	ext,sp		;1b f2s00r00
	leas	ext,x		;1b e2s00r00
	leas	ext,y		;1b eas00r00
	leas	ind,pc		;1b f8 37
	leas	ind,sp		;1b f0 37
	leas	ind,x		;1b e0 37
	leas	ind,y		;1b e8 37
	leas	small,pc	;1b ce
	leas	small,sp	;1b 8e
	leas	small,x		;1b 0e
	leas	small,y		;1b 4e
	leax	1,+sp		;1a a0
	leax	1,+x		;1a 20
	leax	1,+y		;1a 60
	leax	8,+sp		;1a a7
	leax	8,+x		;1a 27
	leax	8,+y		;1a 67
	leax	,pc		;1a c0
	leax	,sp		;1a 80
	leax	,x		;1a 00
	leax	,y		;1a 40
	leax	1,-sp		;1a af
	leax	1,-x		;1a 2f
	leax	1,-y		;1a 6f
	leax	8,-sp		;1a a8
	leax	8,-x		;1a 28
	leax	8,-y		;1a 68
	leax	-1,sp		;1a 9f
	leax	-1,x		;1a 1f
	leax	-1,y		;1a 5f
	leax	-16,sp		;1a 90
	leax	-16,x		;1a 10
	leax	-16,y		;1a 50
	leax	-17,sp		;1a f1 ef
	leax	-17,x		;1a e1 ef
	leax	-17,y		;1a e9 ef
	leax	-small,pc	;1a d2
	leax	-small,sp	;1a 92
	leax	-small,x	;1a 12
	leax	-small,y	;1a 52
	leax	0,pc		;1a c0
	leax	0,sp		;1a 80
	leax	0,x		;1a 00
	leax	0,y		;1a 40
	leax	1,sp+		;1a b0
	leax	1,x+		;1a 30
	leax	1,y+		;1a 70
	leax	1,sp		;1a 81
	leax	1,x		;1a 01
	leax	1,y		;1a 41
	leax	1,sp-		;1a bf
	leax	1,x-		;1a 3f
	leax	1,y-		;1a 7f
	leax	125,pc		;1a f8 7d
	leax	125,sp		;1a f0 7d
	leax	125,x		;1a e0 7d
	leax	125,y		;1a e8 7d
	leax	15,sp		;1a 8f
	leax	15,x		;1a 0f
	leax	15,y		;1a 4f
	leax	16,sp		;1a f0 10
	leax	16,x		;1a e0 10
	leax	16,y		;1a e8 10
	leax	8,sp+		;1a b7
	leax	8,x+		;1a 37
	leax	8,y+		;1a 77
	leax	8,sp-		;1a b8
	leax	8,x-		;1a 38
	leax	8,y-		;1a 78
	leax	a,sp		;1a f4
	leax	a,x		;1a e4
	leax	a,y		;1a ec
	leax	b,sp		;1a f5
	leax	b,x		;1a e5
	leax	b,y		;1a ed
	leax	d,sp		;1a f6
	leax	d,x		;1a e6
	leax	d,y		;1a ee
	leax	ext,sp		;1a f2s00r00
	leax	ext,x		;1a e2s00r00
	leax	ext,y		;1a eas00r00
	leax	ind,pc		;1a f8 37
	leax	ind,sp		;1a f0 37
	leax	ind,x		;1a e0 37
	leax	ind,y		;1a e8 37
	leax	small,pc	;1a ce
	leax	small,sp	;1a 8e
	leax	small,x		;1a 0e
	leax	small,y		;1a 4e
	leay	1,+sp		;19 a0
	leay	1,+x		;19 20
	leay	1,+y		;19 60
	leay	8,+sp		;19 a7
	leay	8,+x		;19 27
	leay	8,+y		;19 67
	leay	,pc		;19 c0
	leay	,sp		;19 80
	leay	,x		;19 00
	leay	,y		;19 40
	leay	1,-sp		;19 af
	leay	1,-x		;19 2f
	leay	1,-y		;19 6f
	leay	8,-sp		;19 a8
	leay	8,-x		;19 28
	leay	8,-y		;19 68
	leay	-1,sp		;19 9f
	leay	-1,x		;19 1f
	leay	-1,y		;19 5f
	leay	-16,sp		;19 90
	leay	-16,x		;19 10
	leay	-16,y		;19 50
	leay	-17,sp		;19 f1 ef
	leay	-17,x		;19 e1 ef
	leay	-17,y		;19 e9 ef
	leay	-small,pc	;19 d2
	leay	-small,sp	;19 92
	leay	-small,x	;19 12
	leay	-small,y	;19 52
	leay	0,pc		;19 c0
	leay	0,sp		;19 80
	leay	0,x		;19 00
	leay	0,y		;19 40
	leay	1,sp+		;19 b0
	leay	1,x+		;19 30
	leay	1,y+		;19 70
	leay	1,sp		;19 81
	leay	1,x		;19 01
	leay	1,y		;19 41
	leay	1,sp-		;19 bf
	leay	1,x-		;19 3f
	leay	1,y-		;19 7f
	leay	125,pc		;19 f8 7d
	leay	125,sp		;19 f0 7d
	leay	125,x		;19 e0 7d
	leay	125,y		;19 e8 7d
	leay	15,sp		;19 8f
	leay	15,x		;19 0f
	leay	15,y		;19 4f
	leay	16,sp		;19 f0 10
	leay	16,x		;19 e0 10
	leay	16,y		;19 e8 10
	leay	8,sp+		;19 b7
	leay	8,x+		;19 37
	leay	8,y+		;19 77
	leay	8,sp-		;19 b8
	leay	8,x-		;19 38
	leay	8,y-		;19 78
	leay	a,sp		;19 f4
	leay	a,x		;19 e4
	leay	a,y		;19 ec
	leay	b,sp		;19 f5
	leay	b,x		;19 e5
	leay	b,y		;19 ed
	leay	d,sp		;19 f6
	leay	d,x		;19 e6
	leay	d,y		;19 ee
	leay	ext,sp		;19 f2s00r00
	leay	ext,x		;19 e2s00r00
	leay	ext,y		;19 eas00r00
	leay	ind,pc		;19 f8 37
	leay	ind,sp		;19 f0 37
	leay	ind,x		;19 e0 37
	leay	ind,y		;19 e8 37
	leay	small,pc	;19 ce
	leay	small,sp	;19 8e
	leay	small,x		;19 0e
	leay	small,y		;19 4e
	lsl	1,+sp		;68 a0
	lsl	1,+x		;68 20
	lsl	1,+y		;68 60
	lsl	8,+sp		;68 a7
	lsl	8,+x		;68 27
	lsl	8,+y		;68 67
	lsl	,pc		;68 c0
	lsl	,sp		;68 80
	lsl	,x		;68 00
	lsl	,y		;68 40
	lsl	1,-sp		;68 af
	lsl	1,-x		;68 2f
	lsl	1,-y		;68 6f
	lsl	8,-sp		;68 a8
	lsl	8,-x		;68 28
	lsl	8,-y		;68 68
	lsl	-1,sp		;68 9f
	lsl	-1,x		;68 1f
	lsl	-1,y		;68 5f
	lsl	-16,sp		;68 90
	lsl	-16,x		;68 10
	lsl	-16,y		;68 50
	lsl	-17,sp		;68 f1 ef
	lsl	-17,x		;68 e1 ef
	lsl	-17,y		;68 e9 ef
	lsl	-small,pc	;68 d2
	lsl	-small,sp	;68 92
	lsl	-small,x	;68 12
	lsl	-small,y	;68 52
	lsl	0,pc		;68 c0
	lsl	0,sp		;68 80
	lsl	0,x		;68 00
	lsl	0,y		;68 40
	lsl	1,sp+		;68 b0
	lsl	1,x+		;68 30
	lsl	1,y+		;68 70
	lsl	1,sp		;68 81
	lsl	1,x		;68 01
	lsl	1,y		;68 41
	lsl	1,sp-		;68 bf
	lsl	1,x-		;68 3f
	lsl	1,y-		;68 7f
	lsl	125,pc		;68 f8 7d
	lsl	125,sp		;68 f0 7d
	lsl	125,x		;68 e0 7d
	lsl	125,y		;68 e8 7d
	lsl	15,sp		;68 8f
	lsl	15,x		;68 0f
	lsl	15,y		;68 4f
	lsl	16,sp		;68 f0 10
	lsl	16,x		;68 e0 10
	lsl	16,y		;68 e8 10
	lsl	8,sp+		;68 b7
	lsl	8,x+		;68 37
	lsl	8,y+		;68 77
	lsl	8,sp-		;68 b8
	lsl	8,x-		;68 38
	lsl	8,y-		;68 78
	lsl	a,sp		;68 f4
	lsl	a,x		;68 e4
	lsl	a,y		;68 ec
	lsl	b,sp		;68 f5
	lsl	b,x		;68 e5
	lsl	b,y		;68 ed
	lsl	d,sp		;68 f6
	lsl	d,x		;68 e6
	lsl	d,y		;68 ee
	lsl	*dir		;78s00r00
	lsl	ext		;78s00r00
	lsl	ext,sp		;68 f2s00r00
	lsl	ext,x		;68 e2s00r00
	lsl	ext,y		;68 eas00r00
	lsl	ind,pc		;68 f8 37
	lsl	ind,sp		;68 f0 37
	lsl	ind,x		;68 e0 37
	lsl	ind,y		;68 e8 37
	lsl	small,pc	;68 ce
	lsl	small,sp	;68 8e
	lsl	small,x		;68 0e
	lsl	small,y		;68 4e
	lsla			;48
	lslb			;58
	lsld			;59
	lsr	1,+sp		;64 a0
	lsr	1,+x		;64 20
	lsr	1,+y		;64 60
	lsr	8,+sp		;64 a7
	lsr	8,+x		;64 27
	lsr	8,+y		;64 67
	lsr	,pc		;64 c0
	lsr	,sp		;64 80
	lsr	,x		;64 00
	lsr	,y		;64 40
	lsr	1,-sp		;64 af
	lsr	1,-x		;64 2f
	lsr	1,-y		;64 6f
	lsr	8,-sp		;64 a8
	lsr	8,-x		;64 28
	lsr	8,-y		;64 68
	lsr	-1,sp		;64 9f
	lsr	-1,x		;64 1f
	lsr	-1,y		;64 5f
	lsr	-16,sp		;64 90
	lsr	-16,x		;64 10
	lsr	-16,y		;64 50
	lsr	-17,sp		;64 f1 ef
	lsr	-17,x		;64 e1 ef
	lsr	-17,y		;64 e9 ef
	lsr	-small,pc	;64 d2
	lsr	-small,sp	;64 92
	lsr	-small,x	;64 12
	lsr	-small,y	;64 52
	lsr	0,pc		;64 c0
	lsr	0,sp		;64 80
	lsr	0,x		;64 00
	lsr	0,y		;64 40
	lsr	1,sp+		;64 b0
	lsr	1,x+		;64 30
	lsr	1,y+		;64 70
	lsr	1,sp		;64 81
	lsr	1,x		;64 01
	lsr	1,y		;64 41
	lsr	1,sp-		;64 bf
	lsr	1,x-		;64 3f
	lsr	1,y-		;64 7f
	lsr	125,pc		;64 f8 7d
	lsr	125,sp		;64 f0 7d
	lsr	125,x		;64 e0 7d
	lsr	125,y		;64 e8 7d
	lsr	15,sp		;64 8f
	lsr	15,x		;64 0f
	lsr	15,y		;64 4f
	lsr	16,sp		;64 f0 10
	lsr	16,x		;64 e0 10
	lsr	16,y		;64 e8 10
	lsr	8,sp+		;64 b7
	lsr	8,x+		;64 37
	lsr	8,y+		;64 77
	lsr	8,sp-		;64 b8
	lsr	8,x-		;64 38
	lsr	8,y-		;64 78
	lsr	a,sp		;64 f4
	lsr	a,x		;64 e4
	lsr	a,y		;64 ec
	lsr	b,sp		;64 f5
	lsr	b,x		;64 e5
	lsr	b,y		;64 ed
	lsr	d,sp		;64 f6
	lsr	d,x		;64 e6
	lsr	d,y		;64 ee
	lsr	*dir		;74s00r00
	lsr	ext		;74s00r00
	lsr	ext,sp		;64 f2s00r00
	lsr	ext,x		;64 e2s00r00
	lsr	ext,y		;64 eas00r00
	lsr	ind,pc		;64 f8 37
	lsr	ind,sp		;64 f0 37
	lsr	ind,x		;64 e0 37
	lsr	ind,y		;64 e8 37
	lsr	small,pc	;64 ce
	lsr	small,sp	;64 8e
	lsr	small,x		;64 0e
	lsr	small,y		;64 4e
	lsra			;44
	lsrb			;54
	lsrd			;49
	lsrd			;49

m:	maxa	1,+sp		;18 18 a0
	maxa	1,+x		;18 18 20
	maxa	1,+y		;18 18 60
	maxa	8,+sp		;18 18 a7
	maxa	8,+x		;18 18 27
	maxa	8,+y		;18 18 67
	maxa	,pc		;18 18 c0
	maxa	,sp		;18 18 80
	maxa	,x		;18 18 00
	maxa	,y		;18 18 40
	maxa	1,-sp		;18 18 af
	maxa	1,-x		;18 18 2f
	maxa	1,-y		;18 18 6f
	maxa	8,-sp		;18 18 a8
	maxa	8,-x		;18 18 28
	maxa	8,-y		;18 18 68
	maxa	-1,sp		;18 18 9f
	maxa	-1,x		;18 18 1f
	maxa	-1,y		;18 18 5f
	maxa	-16,sp		;18 18 90
	maxa	-16,x		;18 18 10
	maxa	-16,y		;18 18 50
	maxa	-17,sp		;18 18 f1 ef
	maxa	-17,x		;18 18 e1 ef
	maxa	-17,y		;18 18 e9 ef
	maxa	-small,pc	;18 18 d2
	maxa	-small,sp	;18 18 92
	maxa	-small,x	;18 18 12
	maxa	-small,y	;18 18 52
	maxa	0,pc		;18 18 c0
	maxa	0,sp		;18 18 80
	maxa	0,x		;18 18 00
	maxa	0,y		;18 18 40
	maxa	1,sp+		;18 18 b0
	maxa	1,x+		;18 18 30
	maxa	1,y+		;18 18 70
	maxa	1,sp		;18 18 81
	maxa	1,x		;18 18 01
	maxa	1,y		;18 18 41
	maxa	1,sp-		;18 18 bf
	maxa	1,x-		;18 18 3f
	maxa	1,y-		;18 18 7f
	maxa	125,pc		;18 18 f8 7d
	maxa	125,sp		;18 18 f0 7d
	maxa	125,x		;18 18 e0 7d
	maxa	125,y		;18 18 e8 7d
	maxa	15,sp		;18 18 8f
	maxa	15,x		;18 18 0f
	maxa	15,y		;18 18 4f
	maxa	16,sp		;18 18 f0 10
	maxa	16,x		;18 18 e0 10
	maxa	16,y		;18 18 e8 10
	maxa	8,sp+		;18 18 b7
	maxa	8,x+		;18 18 37
	maxa	8,y+		;18 18 77
	maxa	8,sp-		;18 18 b8
	maxa	8,x-		;18 18 38
	maxa	8,y-		;18 18 78
	maxa	a,sp		;18 18 f4
	maxa	a,x		;18 18 e4
	maxa	a,y		;18 18 ec
	maxa	b,sp		;18 18 f5
	maxa	b,x		;18 18 e5
	maxa	b,y		;18 18 ed
	maxa	d,sp		;18 18 f6
	maxa	d,x		;18 18 e6
	maxa	d,y		;18 18 ee
	maxa	ext,sp		;18 18 f2s00r00
	maxa	ext,x		;18 18 e2s00r00
	maxa	ext,y		;18 18 eas00r00
	maxa	ind,pc		;18 18 f8 37
	maxa	ind,sp		;18 18 f0 37
	maxa	ind,x		;18 18 e0 37
	maxa	ind,y		;18 18 e8 37
	maxa	small,pc	;18 18 ce
	maxa	small,sp	;18 18 8e
	maxa	small,x		;18 18 0e
	maxa	small,y		;18 18 4e
	maxm	1,+sp		;18 1c a0
	maxm	1,+x		;18 1c 20
	maxm	1,+y		;18 1c 60
	maxm	8,+sp		;18 1c a7
	maxm	8,+x		;18 1c 27
	maxm	8,+y		;18 1c 67
	maxm	,pc		;18 1c c0
	maxm	,sp		;18 1c 80
	maxm	,x		;18 1c 00
	maxm	,y		;18 1c 40
	maxm	1,-sp		;18 1c af
	maxm	1,-x		;18 1c 2f
	maxm	1,-y		;18 1c 6f
	maxm	8,-sp		;18 1c a8
	maxm	8,-x		;18 1c 28
	maxm	8,-y		;18 1c 68
	maxm	-1,sp		;18 1c 9f
	maxm	-1,x		;18 1c 1f
	maxm	-1,y		;18 1c 5f
	maxm	-16,sp		;18 1c 90
	maxm	-16,x		;18 1c 10
	maxm	-16,y		;18 1c 50
	maxm	-17,sp		;18 1c f1 ef
	maxm	-17,x		;18 1c e1 ef
	maxm	-17,y		;18 1c e9 ef
	maxm	-small,pc	;18 1c d2
	maxm	-small,sp	;18 1c 92
	maxm	-small,x	;18 1c 12
	maxm	-small,y	;18 1c 52
	maxm	0,pc		;18 1c c0
	maxm	0,sp		;18 1c 80
	maxm	0,x		;18 1c 00
	maxm	0,y		;18 1c 40
	maxm	1,sp+		;18 1c b0
	maxm	1,x+		;18 1c 30
	maxm	1,y+		;18 1c 70
	maxm	1,sp		;18 1c 81
	maxm	1,x		;18 1c 01
	maxm	1,y		;18 1c 41
	maxm	1,sp-		;18 1c bf
	maxm	1,x-		;18 1c 3f
	maxm	1,y-		;18 1c 7f
	maxm	125,pc		;18 1c f8 7d
	maxm	125,sp		;18 1c f0 7d
	maxm	125,x		;18 1c e0 7d
	maxm	125,y		;18 1c e8 7d
	maxm	15,sp		;18 1c 8f
	maxm	15,x		;18 1c 0f
	maxm	15,y		;18 1c 4f
	maxm	16,sp		;18 1c f0 10
	maxm	16,x		;18 1c e0 10
	maxm	16,y		;18 1c e8 10
	maxm	8,sp+		;18 1c b7
	maxm	8,x+		;18 1c 37
	maxm	8,y+		;18 1c 77
	maxm	8,sp-		;18 1c b8
	maxm	8,x-		;18 1c 38
	maxm	8,y-		;18 1c 78
	maxm	a,sp		;18 1c f4
	maxm	a,x		;18 1c e4
	maxm	a,y		;18 1c ec
	maxm	b,sp		;18 1c f5
	maxm	b,x		;18 1c e5
	maxm	b,y		;18 1c ed
	maxm	d,sp		;18 1c f6
	maxm	d,x		;18 1c e6
	maxm	d,y		;18 1c ee
	maxm	ext,sp		;18 1c f2s00r00
	maxm	ext,x		;18 1c e2s00r00
	maxm	ext,y		;18 1c eas00r00
	maxm	ind,pc		;18 1c f8 37
	maxm	ind,sp		;18 1c f0 37
	maxm	ind,x		;18 1c e0 37
	maxm	ind,y		;18 1c e8 37
	maxm	small,pc	;18 1c ce
	maxm	small,sp	;18 1c 8e
	maxm	small,x		;18 1c 0e
	maxm	small,y		;18 1c 4e
	mem			;01
	mina	1,+sp		;18 19 a0
	mina	1,+x		;18 19 20
	mina	1,+y		;18 19 60
	mina	8,+sp		;18 19 a7
	mina	8,+x		;18 19 27
	mina	8,+y		;18 19 67
	mina	,pc		;18 19 c0
	mina	,sp		;18 19 80
	mina	,x		;18 19 00
	mina	,y		;18 19 40
	mina	1,-sp		;18 19 af
	mina	1,-x		;18 19 2f
	mina	1,-y		;18 19 6f
	mina	8,-sp		;18 19 a8
	mina	8,-x		;18 19 28
	mina	8,-y		;18 19 68
	mina	-1,sp		;18 19 9f
	mina	-1,x		;18 19 1f
	mina	-1,y		;18 19 5f
	mina	-16,sp		;18 19 90
	mina	-16,x		;18 19 10
	mina	-16,y		;18 19 50
	mina	-17,sp		;18 19 f1 ef
	mina	-17,x		;18 19 e1 ef
	mina	-17,y		;18 19 e9 ef
	mina	-small,pc	;18 19 d2
	mina	-small,sp	;18 19 92
	mina	-small,x	;18 19 12
	mina	-small,y	;18 19 52
	mina	0,pc		;18 19 c0
	mina	0,sp		;18 19 80
	mina	0,x		;18 19 00
	mina	0,y		;18 19 40
	mina	1,sp+		;18 19 b0
	mina	1,x+		;18 19 30
	mina	1,y+		;18 19 70
	mina	1,sp		;18 19 81
	mina	1,x		;18 19 01
	mina	1,y		;18 19 41
	mina	1,sp-		;18 19 bf
	mina	1,x-		;18 19 3f
	mina	1,y-		;18 19 7f
	mina	125,pc		;18 19 f8 7d
	mina	125,sp		;18 19 f0 7d
	mina	125,x		;18 19 e0 7d
	mina	125,y		;18 19 e8 7d
	mina	15,sp		;18 19 8f
	mina	15,x		;18 19 0f
	mina	15,y		;18 19 4f
	mina	16,sp		;18 19 f0 10
	mina	16,x		;18 19 e0 10
	mina	16,y		;18 19 e8 10
	mina	8,sp+		;18 19 b7
	mina	8,x+		;18 19 37
	mina	8,y+		;18 19 77
	mina	8,sp-		;18 19 b8
	mina	8,x-		;18 19 38
	mina	8,y-		;18 19 78
	mina	a,sp		;18 19 f4
	mina	a,x		;18 19 e4
	mina	a,y		;18 19 ec
	mina	b,sp		;18 19 f5
	mina	b,x		;18 19 e5
	mina	b,y		;18 19 ed
	mina	d,sp		;18 19 f6
	mina	d,x		;18 19 e6
	mina	d,y		;18 19 ee
	mina	ext,sp		;18 19 f2s00r00
	mina	ext,x		;18 19 e2s00r00
	mina	ext,y		;18 19 eas00r00
	mina	ind,pc		;18 19 f8 37
	mina	ind,sp		;18 19 f0 37
	mina	ind,x		;18 19 e0 37
	mina	ind,y		;18 19 e8 37
	mina	small,pc	;18 19 ce
	mina	small,sp	;18 19 8e
	mina	small,x		;18 19 0e
	mina	small,y		;18 19 4e
	minm	1,+sp		;18 1d a0
	minm	1,+x		;18 1d 20
	minm	1,+y		;18 1d 60
	minm	8,+sp		;18 1d a7
	minm	8,+x		;18 1d 27
	minm	8,+y		;18 1d 67
	minm	,pc		;18 1d c0
	minm	,sp		;18 1d 80
	minm	,x		;18 1d 00
	minm	,y		;18 1d 40
	minm	1,-sp		;18 1d af
	minm	1,-x		;18 1d 2f
	minm	1,-y		;18 1d 6f
	minm	8,-sp		;18 1d a8
	minm	8,-x		;18 1d 28
	minm	8,-y		;18 1d 68
	minm	-1,sp		;18 1d 9f
	minm	-1,x		;18 1d 1f
	minm	-1,y		;18 1d 5f
	minm	-16,sp		;18 1d 90
	minm	-16,x		;18 1d 10
	minm	-16,y		;18 1d 50
	minm	-17,sp		;18 1d f1 ef
	minm	-17,x		;18 1d e1 ef
	minm	-17,y		;18 1d e9 ef
	minm	-small,pc	;18 1d d2
	minm	-small,sp	;18 1d 92
	minm	-small,x	;18 1d 12
	minm	-small,y	;18 1d 52
	minm	0,pc		;18 1d c0
	minm	0,sp		;18 1d 80
	minm	0,x		;18 1d 00
	minm	0,y		;18 1d 40
	minm	1,sp+		;18 1d b0
	minm	1,x+		;18 1d 30
	minm	1,y+		;18 1d 70
	minm	1,sp		;18 1d 81
	minm	1,x		;18 1d 01
	minm	1,y		;18 1d 41
	minm	1,sp-		;18 1d bf
	minm	1,x-		;18 1d 3f
	minm	1,y-		;18 1d 7f
	minm	125,pc		;18 1d f8 7d
	minm	125,sp		;18 1d f0 7d
	minm	125,x		;18 1d e0 7d
	minm	125,y		;18 1d e8 7d
	minm	15,sp		;18 1d 8f
	minm	15,x		;18 1d 0f
	minm	15,y		;18 1d 4f
	minm	16,sp		;18 1d f0 10
	minm	16,x		;18 1d e0 10
	minm	16,y		;18 1d e8 10
	minm	8,sp+		;18 1d b7
	minm	8,x+		;18 1d 37
	minm	8,y+		;18 1d 77
	minm	8,sp-		;18 1d b8
	minm	8,x-		;18 1d 38
	minm	8,y-		;18 1d 78
	minm	a,sp		;18 1d f4
	minm	a,x		;18 1d e4
	minm	a,y		;18 1d ec
	minm	b,sp		;18 1d f5
	minm	b,x		;18 1d e5
	minm	b,y		;18 1d ed
	minm	d,sp		;18 1d f6
	minm	d,x		;18 1d e6
	minm	d,y		;18 1d ee
	minm	ext,sp		;18 1d f2s00r00
	minm	ext,x		;18 1d e2s00r00
	minm	ext,y		;18 1d eas00r00
	minm	ind,pc		;18 1d f8 37
	minm	ind,sp		;18 1d f0 37
	minm	ind,x		;18 1d e0 37
	minm	ind,y		;18 1d e8 37
	minm	small,pc	;18 1d ce
	minm	small,sp	;18 1d 8e
	minm	small,x		;18 1d 0e
	minm	small,y		;18 1d 4e
	mul			;12

n:	neg	1,+sp		;60 a0
	neg	1,+x		;60 20
	neg	1,+y		;60 60
	neg	8,+sp		;60 a7
	neg	8,+x		;60 27
	neg	8,+y		;60 67
	neg	,pc		;60 c0
	neg	,sp		;60 80
	neg	,x		;60 00
	neg	,y		;60 40
	neg	1,-sp		;60 af
	neg	1,-x		;60 2f
	neg	1,-y		;60 6f
	neg	8,-sp		;60 a8
	neg	8,-x		;60 28
	neg	8,-y		;60 68
	neg	-1,sp		;60 9f
	neg	-1,x		;60 1f
	neg	-1,y		;60 5f
	neg	-16,sp		;60 90
	neg	-16,x		;60 10
	neg	-16,y		;60 50
	neg	-17,sp		;60 f1 ef
	neg	-17,x		;60 e1 ef
	neg	-17,y		;60 e9 ef
	neg	-small,pc	;60 d2
	neg	-small,sp	;60 92
	neg	-small,x	;60 12
	neg	-small,y	;60 52
	neg	0,pc		;60 c0
	neg	0,sp		;60 80
	neg	0,x		;60 00
	neg	0,y		;60 40
	neg	1,sp+		;60 b0
	neg	1,x+		;60 30
	neg	1,y+		;60 70
	neg	1,sp		;60 81
	neg	1,x		;60 01
	neg	1,y		;60 41
	neg	1,sp-		;60 bf
	neg	1,x-		;60 3f
	neg	1,y-		;60 7f
	neg	125,pc		;60 f8 7d
	neg	125,sp		;60 f0 7d
	neg	125,x		;60 e0 7d
	neg	125,y		;60 e8 7d
	neg	15,sp		;60 8f
	neg	15,x		;60 0f
	neg	15,y		;60 4f
	neg	16,sp		;60 f0 10
	neg	16,x		;60 e0 10
	neg	16,y		;60 e8 10
	neg	8,sp+		;60 b7
	neg	8,x+		;60 37
	neg	8,y+		;60 77
	neg	8,sp-		;60 b8
	neg	8,x-		;60 38
	neg	8,y-		;60 78
	neg	a,sp		;60 f4
	neg	a,x		;60 e4
	neg	a,y		;60 ec
	neg	b,sp		;60 f5
	neg	b,x		;60 e5
	neg	b,y		;60 ed
	neg	d,sp		;60 f6
	neg	d,x		;60 e6
	neg	d,y		;60 ee
	neg	*dir		;70s00r00
	neg	ext		;70s00r00
	neg	ext,sp		;60 f2s00r00
	neg	ext,x		;60 e2s00r00
	neg	ext,y		;60 eas00r00
	neg	ind,pc		;60 f8 37
	neg	ind,sp		;60 f0 37
	neg	ind,x		;60 e0 37
	neg	ind,y		;60 e8 37
	neg	small,pc	;60 ce
	neg	small,sp	;60 8e
	neg	small,x		;60 0e
	neg	small,y		;60 4e
	nega			;40
	negb			;50
	nop			;a7

o:	oraa	#immed		;8ar00
	oraa	1,+sp		;aa a0
	oraa	1,+x		;aa 20
	oraa	1,+y		;aa 60
	oraa	8,+sp		;aa a7
	oraa	8,+x		;aa 27
	oraa	8,+y		;aa 67
	oraa	,pc		;aa c0
	oraa	,sp		;aa 80
	oraa	,x		;aa 00
	oraa	,y		;aa 40
	oraa	1,-sp		;aa af
	oraa	1,-x		;aa 2f
	oraa	1,-y		;aa 6f
	oraa	8,-sp		;aa a8
	oraa	8,-x		;aa 28
	oraa	8,-y		;aa 68
	oraa	-1,sp		;aa 9f
	oraa	-1,x		;aa 1f
	oraa	-1,y		;aa 5f
	oraa	-16,sp		;aa 90
	oraa	-16,x		;aa 10
	oraa	-16,y		;aa 50
	oraa	-17,sp		;aa f1 ef
	oraa	-17,x		;aa e1 ef
	oraa	-17,y		;aa e9 ef
	oraa	-small,pc	;aa d2
	oraa	-small,sp	;aa 92
	oraa	-small,x	;aa 12
	oraa	-small,y	;aa 52
	oraa	0,pc		;aa c0
	oraa	0,sp		;aa 80
	oraa	0,x		;aa 00
	oraa	0,y		;aa 40
	oraa	1,sp+		;aa b0
	oraa	1,x+		;aa 30
	oraa	1,y+		;aa 70
	oraa	1,sp		;aa 81
	oraa	1,x		;aa 01
	oraa	1,y		;aa 41
	oraa	1,sp-		;aa bf
	oraa	1,x-		;aa 3f
	oraa	1,y-		;aa 7f
	oraa	125,pc		;aa f8 7d
	oraa	125,sp		;aa f0 7d
	oraa	125,x		;aa e0 7d
	oraa	125,y		;aa e8 7d
	oraa	15,sp		;aa 8f
	oraa	15,x		;aa 0f
	oraa	15,y		;aa 4f
	oraa	16,sp		;aa f0 10
	oraa	16,x		;aa e0 10
	oraa	16,y		;aa e8 10
	oraa	8,sp+		;aa b7
	oraa	8,x+		;aa 37
	oraa	8,y+		;aa 77
	oraa	8,sp-		;aa b8
	oraa	8,x-		;aa 38
	oraa	8,y-		;aa 78
	oraa	a,sp		;aa f4
	oraa	a,x		;aa e4
	oraa	a,y		;aa ec
	oraa	b,sp		;aa f5
	oraa	b,x		;aa e5
	oraa	b,y		;aa ed
	oraa	d,sp		;aa f6
	oraa	d,x		;aa e6
	oraa	d,y		;aa ee
	oraa	*dir		;9a*00
	oraa	ext		;bas00r00
	oraa	ext,sp		;aa f2s00r00
	oraa	ext,x		;aa e2s00r00
	oraa	ext,y		;aa eas00r00
	oraa	ind,pc		;aa f8 37
	oraa	ind,sp		;aa f0 37
	oraa	ind,x		;aa e0 37
	oraa	ind,y		;aa e8 37
	oraa	small,pc	;aa ce
	oraa	small,sp	;aa 8e
	oraa	small,x		;aa 0e
	oraa	small,y		;aa 4e
	orab	#immed		;car00
	orab	1,+sp		;ea a0
	orab	1,+x		;ea 20
	orab	1,+y		;ea 60
	orab	8,+sp		;ea a7
	orab	8,+x		;ea 27
	orab	8,+y		;ea 67
	orab	,pc		;ea c0
	orab	,sp		;ea 80
	orab	,x		;ea 00
	orab	,y		;ea 40
	orab	1,-sp		;ea af
	orab	1,-x		;ea 2f
	orab	1,-y		;ea 6f
	orab	8,-sp		;ea a8
	orab	8,-x		;ea 28
	orab	8,-y		;ea 68
	orab	-1,sp		;ea 9f
	orab	-1,x		;ea 1f
	orab	-1,y		;ea 5f
	orab	-16,sp		;ea 90
	orab	-16,x		;ea 10
	orab	-16,y		;ea 50
	orab	-17,sp		;ea f1 ef
	orab	-17,x		;ea e1 ef
	orab	-17,y		;ea e9 ef
	orab	-small,pc	;ea d2
	orab	-small,sp	;ea 92
	orab	-small,x	;ea 12
	orab	-small,y	;ea 52
	orab	0,pc		;ea c0
	orab	0,sp		;ea 80
	orab	0,x		;ea 00
	orab	0,y		;ea 40
	orab	1,sp+		;ea b0
	orab	1,x+		;ea 30
	orab	1,y+		;ea 70
	orab	1,sp		;ea 81
	orab	1,x		;ea 01
	orab	1,y		;ea 41
	orab	1,sp-		;ea bf
	orab	1,x-		;ea 3f
	orab	1,y-		;ea 7f
	orab	125,pc		;ea f8 7d
	orab	125,sp		;ea f0 7d
	orab	125,x		;ea e0 7d
	orab	125,y		;ea e8 7d
	orab	15,sp		;ea 8f
	orab	15,x		;ea 0f
	orab	15,y		;ea 4f
	orab	16,sp		;ea f0 10
	orab	16,x		;ea e0 10
	orab	16,y		;ea e8 10
	orab	8,sp+		;ea b7
	orab	8,x+		;ea 37
	orab	8,y+		;ea 77
	orab	8,sp-		;ea b8
	orab	8,x-		;ea 38
	orab	8,y-		;ea 78
	orab	a,sp		;ea f4
	orab	a,x		;ea e4
	orab	a,y		;ea ec
	orab	b,sp		;ea f5
	orab	b,x		;ea e5
	orab	b,y		;ea ed
	orab	d,sp		;ea f6
	orab	d,x		;ea e6
	orab	d,y		;ea ee
	orab	*dir		;da*00
	orab	ext		;fas00r00
	orab	ext,sp		;ea f2s00r00
	orab	ext,x		;ea e2s00r00
	orab	ext,y		;ea eas00r00
	orab	ind,pc		;ea f8 37
	orab	ind,sp		;ea f0 37
	orab	ind,x		;ea e0 37
	orab	ind,y		;ea e8 37
	orab	small,pc	;ea ce
	orab	small,sp	;ea 8e
	orab	small,x		;ea 0e
	orab	small,y		;ea 4e
	orcc	#immed		;14r00

p:	psha			;36
	pshb			;37
	pshc			;39
	pshd			;3b
	pshx			;34
	pshy			;35
	pula			;32
	pulb			;33
	pulc			;38
	puld			;3a
	pulx			;30
	puly			;31

r:	rev			;18 3a
	rol	1,+sp		;65 a0
	rol	1,+x		;65 20
	rol	1,+y		;65 60
	rol	8,+sp		;65 a7
	rol	8,+x		;65 27
	rol	8,+y		;65 67
	rol	,pc		;65 c0
	rol	,sp		;65 80
	rol	,x		;65 00
	rol	,y		;65 40
	rol	1,-sp		;65 af
	rol	1,-x		;65 2f
	rol	1,-y		;65 6f
	rol	8,-sp		;65 a8
	rol	8,-x		;65 28
	rol	8,-y		;65 68
	rol	-1,sp		;65 9f
	rol	-1,x		;65 1f
	rol	-1,y		;65 5f
	rol	-16,sp		;65 90
	rol	-16,x		;65 10
	rol	-16,y		;65 50
	rol	-17,sp		;65 f1 ef
	rol	-17,x		;65 e1 ef
	rol	-17,y		;65 e9 ef
	rol	-small,pc	;65 d2
	rol	-small,sp	;65 92
	rol	-small,x	;65 12
	rol	-small,y	;65 52
	rol	0,pc		;65 c0
	rol	0,sp		;65 80
	rol	0,x		;65 00
	rol	0,y		;65 40
	rol	1,sp+		;65 b0
	rol	1,x+		;65 30
	rol	1,y+		;65 70
	rol	1,sp		;65 81
	rol	1,x		;65 01
	rol	1,y		;65 41
	rol	1,sp-		;65 bf
	rol	1,x-		;65 3f
	rol	1,y-		;65 7f
	rol	125,pc		;65 f8 7d
	rol	125,sp		;65 f0 7d
	rol	125,x		;65 e0 7d
	rol	125,y		;65 e8 7d
	rol	15,sp		;65 8f
	rol	15,x		;65 0f
	rol	15,y		;65 4f
	rol	16,sp		;65 f0 10
	rol	16,x		;65 e0 10
	rol	16,y		;65 e8 10
	rol	8,sp+		;65 b7
	rol	8,x+		;65 37
	rol	8,y+		;65 77
	rol	8,sp-		;65 b8
	rol	8,x-		;65 38
	rol	8,y-		;65 78
	rol	a,sp		;65 f4
	rol	a,x		;65 e4
	rol	a,y		;65 ec
	rol	b,sp		;65 f5
	rol	b,x		;65 e5
	rol	b,y		;65 ed
	rol	d,sp		;65 f6
	rol	d,x		;65 e6
	rol	d,y		;65 ee
	rol	*dir		;75s00r00
	rol	ext		;75s00r00
	rol	ext,sp		;65 f2s00r00
	rol	ext,x		;65 e2s00r00
	rol	ext,y		;65 eas00r00
	rol	ind,pc		;65 f8 37
	rol	ind,sp		;65 f0 37
	rol	ind,x		;65 e0 37
	rol	ind,y		;65 e8 37
	rol	small,pc	;65 ce
	rol	small,sp	;65 8e
	rol	small,x		;65 0e
	rol	small,y		;65 4e
	rola			;45
	rolb			;55
	ror	1,+sp		;66 a0
	ror	1,+x		;66 20
	ror	1,+y		;66 60
	ror	8,+sp		;66 a7
	ror	8,+x		;66 27
	ror	8,+y		;66 67
	ror	,pc		;66 c0
	ror	,sp		;66 80
	ror	,x		;66 00
	ror	,y		;66 40
	ror	1,-sp		;66 af
	ror	1,-x		;66 2f
	ror	1,-y		;66 6f
	ror	8,-sp		;66 a8
	ror	8,-x		;66 28
	ror	8,-y		;66 68
	ror	-1,sp		;66 9f
	ror	-1,x		;66 1f
	ror	-1,y		;66 5f
	ror	-16,sp		;66 90
	ror	-16,x		;66 10
	ror	-16,y		;66 50
	ror	-17,sp		;66 f1 ef
	ror	-17,x		;66 e1 ef
	ror	-17,y		;66 e9 ef
	ror	-small,pc	;66 d2
	ror	-small,sp	;66 92
	ror	-small,x	;66 12
	ror	-small,y	;66 52
	ror	0,pc		;66 c0
	ror	0,sp		;66 80
	ror	0,x		;66 00
	ror	0,y		;66 40
	ror	1,sp+		;66 b0
	ror	1,x+		;66 30
	ror	1,y+		;66 70
	ror	1,sp		;66 81
	ror	1,x		;66 01
	ror	1,y		;66 41
	ror	1,sp-		;66 bf
	ror	1,x-		;66 3f
	ror	1,y-		;66 7f
	ror	125,pc		;66 f8 7d
	ror	125,sp		;66 f0 7d
	ror	125,x		;66 e0 7d
	ror	125,y		;66 e8 7d
	ror	15,sp		;66 8f
	ror	15,x		;66 0f
	ror	15,y		;66 4f
	ror	16,sp		;66 f0 10
	ror	16,x		;66 e0 10
	ror	16,y		;66 e8 10
	ror	8,sp+		;66 b7
	ror	8,x+		;66 37
	ror	8,y+		;66 77
	ror	8,sp-		;66 b8
	ror	8,x-		;66 38
	ror	8,y-		;66 78
	ror	a,sp		;66 f4
	ror	a,x		;66 e4
	ror	a,y		;66 ec
	ror	b,sp		;66 f5
	ror	b,x		;66 e5
	ror	b,y		;66 ed
	ror	d,sp		;66 f6
	ror	d,x		;66 e6
	ror	d,y		;66 ee
	ror	*dir		;76s00r00
	ror	ext		;76s00r00
	ror	ext,sp		;66 f2s00r00
	ror	ext,x		;66 e2s00r00
	ror	ext,y		;66 eas00r00
	ror	ind,pc		;66 f8 37
	ror	ind,sp		;66 f0 37
	ror	ind,x		;66 e0 37
	ror	ind,y		;66 e8 37
	ror	small,pc	;66 ce
	ror	small,sp	;66 8e
	ror	small,x		;66 0e
	ror	small,y		;66 4e
	rora			;46
	rorb			;56
	rtc			;0a
	rti			;0b
	rts			;3d

s:	sba			;18 16
	sbca	#immed		;82r00
	sbca	1,+sp		;a2 a0
	sbca	1,+x		;a2 20
	sbca	1,+y		;a2 60
	sbca	8,+sp		;a2 a7
	sbca	8,+x		;a2 27
	sbca	8,+y		;a2 67
	sbca	,pc		;a2 c0
	sbca	,sp		;a2 80
	sbca	,x		;a2 00
	sbca	,y		;a2 40
	sbca	1,-sp		;a2 af
	sbca	1,-x		;a2 2f
	sbca	1,-y		;a2 6f
	sbca	8,-sp		;a2 a8
	sbca	8,-x		;a2 28
	sbca	8,-y		;a2 68
	sbca	-1,sp		;a2 9f
	sbca	-1,x		;a2 1f
	sbca	-1,y		;a2 5f
	sbca	-16,sp		;a2 90
	sbca	-16,x		;a2 10
	sbca	-16,y		;a2 50
	sbca	-17,sp		;a2 f1 ef
	sbca	-17,x		;a2 e1 ef
	sbca	-17,y		;a2 e9 ef
	sbca	-small,pc	;a2 d2
	sbca	-small,sp	;a2 92
	sbca	-small,x	;a2 12
	sbca	-small,y	;a2 52
	sbca	0,pc		;a2 c0
	sbca	0,sp		;a2 80
	sbca	0,x		;a2 00
	sbca	0,y		;a2 40
	sbca	1,sp+		;a2 b0
	sbca	1,x+		;a2 30
	sbca	1,y+		;a2 70
	sbca	1,sp		;a2 81
	sbca	1,x		;a2 01
	sbca	1,y		;a2 41
	sbca	1,sp-		;a2 bf
	sbca	1,x-		;a2 3f
	sbca	1,y-		;a2 7f
	sbca	125,pc		;a2 f8 7d
	sbca	125,sp		;a2 f0 7d
	sbca	125,x		;a2 e0 7d
	sbca	125,y		;a2 e8 7d
	sbca	15,sp		;a2 8f
	sbca	15,x		;a2 0f
	sbca	15,y		;a2 4f
	sbca	16,sp		;a2 f0 10
	sbca	16,x		;a2 e0 10
	sbca	16,y		;a2 e8 10
	sbca	8,sp+		;a2 b7
	sbca	8,x+		;a2 37
	sbca	8,y+		;a2 77
	sbca	8,sp-		;a2 b8
	sbca	8,x-		;a2 38
	sbca	8,y-		;a2 78
	sbca	a,sp		;a2 f4
	sbca	a,x		;a2 e4
	sbca	a,y		;a2 ec
	sbca	b,sp		;a2 f5
	sbca	b,x		;a2 e5
	sbca	b,y		;a2 ed
	sbca	d,sp		;a2 f6
	sbca	d,x		;a2 e6
	sbca	d,y		;a2 ee
	sbca	*dir		;92*00
	sbca	ext		;b2s00r00
	sbca	ext,sp		;a2 f2s00r00
	sbca	ext,x		;a2 e2s00r00
	sbca	ext,y		;a2 eas00r00
	sbca	ind,pc		;a2 f8 37
	sbca	ind,sp		;a2 f0 37
	sbca	ind,x		;a2 e0 37
	sbca	ind,y		;a2 e8 37
	sbca	small,pc	;a2 ce
	sbca	small,sp	;a2 8e
	sbca	small,x		;a2 0e
	sbca	small,y		;a2 4e
	sbcb	#immed		;c2r00
	sbcb	1,+sp		;e2 a0
	sbcb	1,+x		;e2 20
	sbcb	1,+y		;e2 60
	sbcb	8,+sp		;e2 a7
	sbcb	8,+x		;e2 27
	sbcb	8,+y		;e2 67
	sbcb	,pc		;e2 c0
	sbcb	,sp		;e2 80
	sbcb	,x		;e2 00
	sbcb	,y		;e2 40
	sbcb	1,-sp		;e2 af
	sbcb	1,-x		;e2 2f
	sbcb	1,-y		;e2 6f
	sbcb	8,-sp		;e2 a8
	sbcb	8,-x		;e2 28
	sbcb	8,-y		;e2 68
	sbcb	-1,sp		;e2 9f
	sbcb	-1,x		;e2 1f
	sbcb	-1,y		;e2 5f
	sbcb	-16,sp		;e2 90
	sbcb	-16,x		;e2 10
	sbcb	-16,y		;e2 50
	sbcb	-17,sp		;e2 f1 ef
	sbcb	-17,x		;e2 e1 ef
	sbcb	-17,y		;e2 e9 ef
	sbcb	-small,pc	;e2 d2
	sbcb	-small,sp	;e2 92
	sbcb	-small,x	;e2 12
	sbcb	-small,y	;e2 52
	sbcb	0,pc		;e2 c0
	sbcb	0,sp		;e2 80
	sbcb	0,x		;e2 00
	sbcb	0,y		;e2 40
	sbcb	1,sp+		;e2 b0
	sbcb	1,x+		;e2 30
	sbcb	1,y+		;e2 70
	sbcb	1,sp		;e2 81
	sbcb	1,x		;e2 01
	sbcb	1,y		;e2 41
	sbcb	1,sp-		;e2 bf
	sbcb	1,x-		;e2 3f
	sbcb	1,y-		;e2 7f
	sbcb	125,pc		;e2 f8 7d
	sbcb	125,sp		;e2 f0 7d
	sbcb	125,x		;e2 e0 7d
	sbcb	125,y		;e2 e8 7d
	sbcb	15,sp		;e2 8f
	sbcb	15,x		;e2 0f
	sbcb	15,y		;e2 4f
	sbcb	16,sp		;e2 f0 10
	sbcb	16,x		;e2 e0 10
	sbcb	16,y		;e2 e8 10
	sbcb	8,sp+		;e2 b7
	sbcb	8,x+		;e2 37
	sbcb	8,y+		;e2 77
	sbcb	8,sp-		;e2 b8
	sbcb	8,x-		;e2 38
	sbcb	8,y-		;e2 78
	sbcb	a,sp		;e2 f4
	sbcb	a,x		;e2 e4
	sbcb	a,y		;e2 ec
	sbcb	b,sp		;e2 f5
	sbcb	b,x		;e2 e5
	sbcb	b,y		;e2 ed
	sbcb	d,sp		;e2 f6
	sbcb	d,x		;e2 e6
	sbcb	d,y		;e2 ee
	sbcb	*dir		;d2*00
	sbcb	ext		;f2s00r00
	sbcb	ext,sp		;e2 f2s00r00
	sbcb	ext,x		;e2 e2s00r00
	sbcb	ext,y		;e2 eas00r00
	sbcb	ind,pc		;e2 f8 37
	sbcb	ind,sp		;e2 f0 37
	sbcb	ind,x		;e2 e0 37
	sbcb	ind,y		;e2 e8 37
	sbcb	small,pc	;e2 ce
	sbcb	small,sp	;e2 8e
	sbcb	small,x		;e2 0e
	sbcb	small,y		;e2 4e
	sec			;14 01
	sei			;14 10
	sev			;14 02
	sex	a,d		;b7 04
	sex	a,sp		;b7 07
	sex	a,x		;b7 05
	sex	a,y		;b7 06
	sex	b,d		;b7 14
	sex	b,sp		;b7 17
	sex	b,x		;b7 15
	sex	b,y		;b7 16
	sex	ccr,d		;b7 24
	sex	ccr,sp		;b7 27
	sex	ccr,x		;b7 25
	sex	ccr,y		;b7 26
	staa	1,+sp		;6a a0
	staa	1,+x		;6a 20
	staa	1,+y		;6a 60
	staa	8,+sp		;6a a7
	staa	8,+x		;6a 27
	staa	8,+y		;6a 67
	staa	,pc		;6a c0
	staa	,sp		;6a 80
	staa	,x		;6a 00
	staa	,y		;6a 40
	staa	1,-sp		;6a af
	staa	1,-x		;6a 2f
	staa	1,-y		;6a 6f
	staa	8,-sp		;6a a8
	staa	8,-x		;6a 28
	staa	8,-y		;6a 68
	staa	-1,sp		;6a 9f
	staa	-1,x		;6a 1f
	staa	-1,y		;6a 5f
	staa	-16,sp		;6a 90
	staa	-16,x		;6a 10
	staa	-16,y		;6a 50
	staa	-17,sp		;6a f1 ef
	staa	-17,x		;6a e1 ef
	staa	-17,y		;6a e9 ef
	staa	-small,pc	;6a d2
	staa	-small,sp	;6a 92
	staa	-small,x	;6a 12
	staa	-small,y	;6a 52
	staa	0,pc		;6a c0
	staa	0,sp		;6a 80
	staa	0,x		;6a 00
	staa	0,y		;6a 40
	staa	1,sp+		;6a b0
	staa	1,x+		;6a 30
	staa	1,y+		;6a 70
	staa	1,sp		;6a 81
	staa	1,x		;6a 01
	staa	1,y		;6a 41
	staa	1,sp-		;6a bf
	staa	1,x-		;6a 3f
	staa	1,y-		;6a 7f
	staa	125,pc		;6a f8 7d
	staa	125,sp		;6a f0 7d
	staa	125,x		;6a e0 7d
	staa	125,y		;6a e8 7d
	staa	15,sp		;6a 8f
	staa	15,x		;6a 0f
	staa	15,y		;6a 4f
	staa	16,sp		;6a f0 10
	staa	16,x		;6a e0 10
	staa	16,y		;6a e8 10
	staa	8,sp+		;6a b7
	staa	8,x+		;6a 37
	staa	8,y+		;6a 77
	staa	8,sp-		;6a b8
	staa	8,x-		;6a 38
	staa	8,y-		;6a 78
	staa	a,sp		;6a f4
	staa	a,x		;6a e4
	staa	a,y		;6a ec
	staa	b,sp		;6a f5
	staa	b,x		;6a e5
	staa	b,y		;6a ed
	staa	d,sp		;6a f6
	staa	d,x		;6a e6
	staa	d,y		;6a ee
	staa	*dir		;5a*00
	staa	ext		;7as00r00
	staa	ext,sp		;6a f2s00r00
	staa	ext,x		;6a e2s00r00
	staa	ext,y		;6a eas00r00
	staa	ind,pc		;6a f8 37
	staa	ind,sp		;6a f0 37
	staa	ind,x		;6a e0 37
	staa	ind,y		;6a e8 37
	staa	small,pc	;6a ce
	staa	small,sp	;6a 8e
	staa	small,x		;6a 0e
	staa	small,y		;6a 4e
	stab	1,+sp		;6b a0
	stab	1,+x		;6b 20
	stab	1,+y		;6b 60
	stab	8,+sp		;6b a7
	stab	8,+x		;6b 27
	stab	8,+y		;6b 67
	stab	,pc		;6b c0
	stab	,sp		;6b 80
	stab	,x		;6b 00
	stab	,y		;6b 40
	stab	1,-sp		;6b af
	stab	1,-x		;6b 2f
	stab	1,-y		;6b 6f
	stab	8,-sp		;6b a8
	stab	8,-x		;6b 28
	stab	8,-y		;6b 68
	stab	-1,sp		;6b 9f
	stab	-1,x		;6b 1f
	stab	-1,y		;6b 5f
	stab	-16,sp		;6b 90
	stab	-16,x		;6b 10
	stab	-16,y		;6b 50
	stab	-17,sp		;6b f1 ef
	stab	-17,x		;6b e1 ef
	stab	-17,y		;6b e9 ef
	stab	-small,pc	;6b d2
	stab	-small,sp	;6b 92
	stab	-small,x	;6b 12
	stab	-small,y	;6b 52
	stab	0,pc		;6b c0
	stab	0,sp		;6b 80
	stab	0,x		;6b 00
	stab	0,y		;6b 40
	stab	1,sp+		;6b b0
	stab	1,x+		;6b 30
	stab	1,y+		;6b 70
	stab	1,sp		;6b 81
	stab	1,x		;6b 01
	stab	1,y		;6b 41
	stab	1,sp-		;6b bf
	stab	1,x-		;6b 3f
	stab	1,y-		;6b 7f
	stab	125,pc		;6b f8 7d
	stab	125,sp		;6b f0 7d
	stab	125,x		;6b e0 7d
	stab	125,y		;6b e8 7d
	stab	15,sp		;6b 8f
	stab	15,x		;6b 0f
	stab	15,y		;6b 4f
	stab	16,sp		;6b f0 10
	stab	16,x		;6b e0 10
	stab	16,y		;6b e8 10
	stab	8,sp+		;6b b7
	stab	8,x+		;6b 37
	stab	8,y+		;6b 77
	stab	8,sp-		;6b b8
	stab	8,x-		;6b 38
	stab	8,y-		;6b 78
	stab	a,sp		;6b f4
	stab	a,x		;6b e4
	stab	a,y		;6b ec
	stab	b,sp		;6b f5
	stab	b,x		;6b e5
	stab	b,y		;6b ed
	stab	d,sp		;6b f6
	stab	d,x		;6b e6
	stab	d,y		;6b ee
	stab	*dir		;5b*00
	stab	ext		;7bs00r00
	stab	ext,sp		;6b f2s00r00
	stab	ext,x		;6b e2s00r00
	stab	ext,y		;6b eas00r00
	stab	ind,pc		;6b f8 37
	stab	ind,sp		;6b f0 37
	stab	ind,x		;6b e0 37
	stab	ind,y		;6b e8 37
	stab	small,pc	;6b ce
	stab	small,sp	;6b 8e
	stab	small,x		;6b 0e
	stab	small,y		;6b 4e
	std	1,+sp		;6c a0
	std	1,+x		;6c 20
	std	1,+y		;6c 60
	std	8,+sp		;6c a7
	std	8,+x		;6c 27
	std	8,+y		;6c 67
	std	,pc		;6c c0
	std	,sp		;6c 80
	std	,x		;6c 00
	std	,y		;6c 40
	std	1,-sp		;6c af
	std	1,-x		;6c 2f
	std	1,-y		;6c 6f
	std	8,-sp		;6c a8
	std	8,-x		;6c 28
	std	8,-y		;6c 68
	std	-1,sp		;6c 9f
	std	-1,x		;6c 1f
	std	-1,y		;6c 5f
	std	-16,sp		;6c 90
	std	-16,x		;6c 10
	std	-16,y		;6c 50
	std	-17,sp		;6c f1 ef
	std	-17,x		;6c e1 ef
	std	-17,y		;6c e9 ef
	std	-small,pc	;6c d2
	std	-small,sp	;6c 92
	std	-small,x	;6c 12
	std	-small,y	;6c 52
	std	0,pc		;6c c0
	std	0,sp		;6c 80
	std	0,x		;6c 00
	std	0,y		;6c 40
	std	1,sp+		;6c b0
	std	1,x+		;6c 30
	std	1,y+		;6c 70
	std	1,sp		;6c 81
	std	1,x		;6c 01
	std	1,y		;6c 41
	std	1,sp-		;6c bf
	std	1,x-		;6c 3f
	std	1,y-		;6c 7f
	std	125,pc		;6c f8 7d
	std	125,sp		;6c f0 7d
	std	125,x		;6c e0 7d
	std	125,y		;6c e8 7d
	std	15,sp		;6c 8f
	std	15,x		;6c 0f
	std	15,y		;6c 4f
	std	16,sp		;6c f0 10
	std	16,x		;6c e0 10
	std	16,y		;6c e8 10
	std	8,sp+		;6c b7
	std	8,x+		;6c 37
	std	8,y+		;6c 77
	std	8,sp-		;6c b8
	std	8,x-		;6c 38
	std	8,y-		;6c 78
	std	a,sp		;6c f4
	std	a,x		;6c e4
	std	a,y		;6c ec
	std	b,sp		;6c f5
	std	b,x		;6c e5
	std	b,y		;6c ed
	std	d,sp		;6c f6
	std	d,x		;6c e6
	std	d,y		;6c ee
	std	*dir		;5c*00
	std	ext		;7cs00r00
	std	ext,sp		;6c f2s00r00
	std	ext,x		;6c e2s00r00
	std	ext,y		;6c eas00r00
	std	ind,pc		;6c f8 37
	std	ind,sp		;6c f0 37
	std	ind,x		;6c e0 37
	std	ind,y		;6c e8 37
	std	small,pc	;6c ce
	std	small,sp	;6c 8e
	std	small,x		;6c 0e
	std	small,y		;6c 4e
	stop			;18 3e
	sts	1,+sp		;6f a0
	sts	1,+x		;6f 20
	sts	1,+y		;6f 60
	sts	8,+sp		;6f a7
	sts	8,+x		;6f 27
	sts	8,+y		;6f 67
	sts	,pc		;6f c0
	sts	,sp		;6f 80
	sts	,x		;6f 00
	sts	,y		;6f 40
	sts	1,-sp		;6f af
	sts	1,-x		;6f 2f
	sts	1,-y		;6f 6f
	sts	8,-sp		;6f a8
	sts	8,-x		;6f 28
	sts	8,-y		;6f 68
	sts	-1,sp		;6f 9f
	sts	-1,x		;6f 1f
	sts	-1,y		;6f 5f
	sts	-16,sp		;6f 90
	sts	-16,x		;6f 10
	sts	-16,y		;6f 50
	sts	-17,sp		;6f f1 ef
	sts	-17,x		;6f e1 ef
	sts	-17,y		;6f e9 ef
	sts	-small,pc	;6f d2
	sts	-small,sp	;6f 92
	sts	-small,x	;6f 12
	sts	-small,y	;6f 52
	sts	0,pc		;6f c0
	sts	0,sp		;6f 80
	sts	0,x		;6f 00
	sts	0,y		;6f 40
	sts	1,sp+		;6f b0
	sts	1,x+		;6f 30
	sts	1,y+		;6f 70
	sts	1,sp		;6f 81
	sts	1,x		;6f 01
	sts	1,y		;6f 41
	sts	1,sp-		;6f bf
	sts	1,x-		;6f 3f
	sts	1,y-		;6f 7f
	sts	125,pc		;6f f8 7d
	sts	125,sp		;6f f0 7d
	sts	125,x		;6f e0 7d
	sts	125,y		;6f e8 7d
	sts	15,sp		;6f 8f
	sts	15,x		;6f 0f
	sts	15,y		;6f 4f
	sts	16,sp		;6f f0 10
	sts	16,x		;6f e0 10
	sts	16,y		;6f e8 10
	sts	8,sp+		;6f b7
	sts	8,x+		;6f 37
	sts	8,y+		;6f 77
	sts	8,sp-		;6f b8
	sts	8,x-		;6f 38
	sts	8,y-		;6f 78
	sts	a,sp		;6f f4
	sts	a,x		;6f e4
	sts	a,y		;6f ec
	sts	b,sp		;6f f5
	sts	b,x		;6f e5
	sts	b,y		;6f ed
	sts	d,sp		;6f f6
	sts	d,x		;6f e6
	sts	d,y		;6f ee
	sts	*dir		;5f*00
	sts	ext		;7fs00r00
	sts	ext,sp		;6f f2s00r00
	sts	ext,x		;6f e2s00r00
	sts	ext,y		;6f eas00r00
	sts	ind,pc		;6f f8 37
	sts	ind,sp		;6f f0 37
	sts	ind,x		;6f e0 37
	sts	ind,y		;6f e8 37
	sts	small,pc	;6f ce
	sts	small,sp	;6f 8e
	sts	small,x		;6f 0e
	sts	small,y		;6f 4e
	stx	1,+sp		;6e a0
	stx	1,+x		;6e 20
	stx	1,+y		;6e 60
	stx	8,+sp		;6e a7
	stx	8,+x		;6e 27
	stx	8,+y		;6e 67
	stx	,pc		;6e c0
	stx	,sp		;6e 80
	stx	,x		;6e 00
	stx	,y		;6e 40
	stx	1,-sp		;6e af
	stx	1,-x		;6e 2f
	stx	1,-y		;6e 6f
	stx	8,-sp		;6e a8
	stx	8,-x		;6e 28
	stx	8,-y		;6e 68
	stx	-1,sp		;6e 9f
	stx	-1,x		;6e 1f
	stx	-1,y		;6e 5f
	stx	-16,sp		;6e 90
	stx	-16,x		;6e 10
	stx	-16,y		;6e 50
	stx	-17,sp		;6e f1 ef
	stx	-17,x		;6e e1 ef
	stx	-17,y		;6e e9 ef
	stx	-small,pc	;6e d2
	stx	-small,sp	;6e 92
	stx	-small,x	;6e 12
	stx	-small,y	;6e 52
	stx	0,pc		;6e c0
	stx	0,sp		;6e 80
	stx	0,x		;6e 00
	stx	0,y		;6e 40
	stx	1,sp+		;6e b0
	stx	1,x+		;6e 30
	stx	1,y+		;6e 70
	stx	1,sp		;6e 81
	stx	1,x		;6e 01
	stx	1,y		;6e 41
	stx	1,sp-		;6e bf
	stx	1,x-		;6e 3f
	stx	1,y-		;6e 7f
	stx	125,pc		;6e f8 7d
	stx	125,sp		;6e f0 7d
	stx	125,x		;6e e0 7d
	stx	125,y		;6e e8 7d
	stx	15,sp		;6e 8f
	stx	15,x		;6e 0f
	stx	15,y		;6e 4f
	stx	16,sp		;6e f0 10
	stx	16,x		;6e e0 10
	stx	16,y		;6e e8 10
	stx	8,sp+		;6e b7
	stx	8,x+		;6e 37
	stx	8,y+		;6e 77
	stx	8,sp-		;6e b8
	stx	8,x-		;6e 38
	stx	8,y-		;6e 78
	stx	a,sp		;6e f4
	stx	a,x		;6e e4
	stx	a,y		;6e ec
	stx	b,sp		;6e f5
	stx	b,x		;6e e5
	stx	b,y		;6e ed
	stx	d,sp		;6e f6
	stx	d,x		;6e e6
	stx	d,y		;6e ee
	stx	*dir		;5e*00
	stx	ext		;7es00r00
	stx	ext,sp		;6e f2s00r00
	stx	ext,x		;6e e2s00r00
	stx	ext,y		;6e eas00r00
	stx	ind,pc		;6e f8 37
	stx	ind,sp		;6e f0 37
	stx	ind,x		;6e e0 37
	stx	ind,y		;6e e8 37
	stx	small,pc	;6e ce
	stx	small,sp	;6e 8e
	stx	small,x		;6e 0e
	stx	small,y		;6e 4e
	sty	1,+sp		;6d a0
	sty	1,+x		;6d 20
	sty	1,+y		;6d 60
	sty	8,+sp		;6d a7
	sty	8,+x		;6d 27
	sty	8,+y		;6d 67
	sty	,pc		;6d c0
	sty	,sp		;6d 80
	sty	,x		;6d 00
	sty	,y		;6d 40
	sty	1,-sp		;6d af
	sty	1,-x		;6d 2f
	sty	1,-y		;6d 6f
	sty	8,-sp		;6d a8
	sty	8,-x		;6d 28
	sty	8,-y		;6d 68
	sty	-1,sp		;6d 9f
	sty	-1,x		;6d 1f
	sty	-1,y		;6d 5f
	sty	-16,sp		;6d 90
	sty	-16,x		;6d 10
	sty	-16,y		;6d 50
	sty	-17,sp		;6d f1 ef
	sty	-17,x		;6d e1 ef
	sty	-17,y		;6d e9 ef
	sty	-small,pc	;6d d2
	sty	-small,sp	;6d 92
	sty	-small,x	;6d 12
	sty	-small,y	;6d 52
	sty	0,pc		;6d c0
	sty	0,sp		;6d 80
	sty	0,x		;6d 00
	sty	0,y		;6d 40
	sty	1,sp+		;6d b0
	sty	1,x+		;6d 30
	sty	1,y+		;6d 70
	sty	1,sp		;6d 81
	sty	1,x		;6d 01
	sty	1,y		;6d 41
	sty	1,sp-		;6d bf
	sty	1,x-		;6d 3f
	sty	1,y-		;6d 7f
	sty	125,pc		;6d f8 7d
	sty	125,sp		;6d f0 7d
	sty	125,x		;6d e0 7d
	sty	125,y		;6d e8 7d
	sty	15,sp		;6d 8f
	sty	15,x		;6d 0f
	sty	15,y		;6d 4f
	sty	16,sp		;6d f0 10
	sty	16,x		;6d e0 10
	sty	16,y		;6d e8 10
	sty	8,sp+		;6d b7
	sty	8,x+		;6d 37
	sty	8,y+		;6d 77
	sty	8,sp-		;6d b8
	sty	8,x-		;6d 38
	sty	8,y-		;6d 78
	sty	a,sp		;6d f4
	sty	a,x		;6d e4
	sty	a,y		;6d ec
	sty	b,sp		;6d f5
	sty	b,x		;6d e5
	sty	b,y		;6d ed
	sty	d,sp		;6d f6
	sty	d,x		;6d e6
	sty	d,y		;6d ee
	sty	*dir		;5d*00
	sty	ext		;7ds00r00
	sty	ext,sp		;6d f2s00r00
	sty	ext,x		;6d e2s00r00
	sty	ext,y		;6d eas00r00
	sty	ind,pc		;6d f8 37
	sty	ind,sp		;6d f0 37
	sty	ind,x		;6d e0 37
	sty	ind,y		;6d e8 37
	sty	small,pc	;6d ce
	sty	small,sp	;6d 8e
	sty	small,x		;6d 0e
	sty	small,y		;6d 4e
	suba	#immed		;80r00
	suba	1,+sp		;a0 a0
	suba	1,+x		;a0 20
	suba	1,+y		;a0 60
	suba	8,+sp		;a0 a7
	suba	8,+x		;a0 27
	suba	8,+y		;a0 67
	suba	,pc		;a0 c0
	suba	,sp		;a0 80
	suba	,x		;a0 00
	suba	,y		;a0 40
	suba	1,-sp		;a0 af
	suba	1,-x		;a0 2f
	suba	1,-y		;a0 6f
	suba	8,-sp		;a0 a8
	suba	8,-x		;a0 28
	suba	8,-y		;a0 68
	suba	-1,sp		;a0 9f
	suba	-1,x		;a0 1f
	suba	-1,y		;a0 5f
	suba	-16,sp		;a0 90
	suba	-16,x		;a0 10
	suba	-16,y		;a0 50
	suba	-17,sp		;a0 f1 ef
	suba	-17,x		;a0 e1 ef
	suba	-17,y		;a0 e9 ef
	suba	-small,pc	;a0 d2
	suba	-small,sp	;a0 92
	suba	-small,x	;a0 12
	suba	-small,y	;a0 52
	suba	0,pc		;a0 c0
	suba	0,sp		;a0 80
	suba	0,x		;a0 00
	suba	0,y		;a0 40
	suba	1,sp+		;a0 b0
	suba	1,x+		;a0 30
	suba	1,y+		;a0 70
	suba	1,sp		;a0 81
	suba	1,x		;a0 01
	suba	1,y		;a0 41
	suba	1,sp-		;a0 bf
	suba	1,x-		;a0 3f
	suba	1,y-		;a0 7f
	suba	125,pc		;a0 f8 7d
	suba	125,sp		;a0 f0 7d
	suba	125,x		;a0 e0 7d
	suba	125,y		;a0 e8 7d
	suba	15,sp		;a0 8f
	suba	15,x		;a0 0f
	suba	15,y		;a0 4f
	suba	16,sp		;a0 f0 10
	suba	16,x		;a0 e0 10
	suba	16,y		;a0 e8 10
	suba	8,sp+		;a0 b7
	suba	8,x+		;a0 37
	suba	8,y+		;a0 77
	suba	8,sp-		;a0 b8
	suba	8,x-		;a0 38
	suba	8,y-		;a0 78
	suba	a,sp		;a0 f4
	suba	a,x		;a0 e4
	suba	a,y		;a0 ec
	suba	b,sp		;a0 f5
	suba	b,x		;a0 e5
	suba	b,y		;a0 ed
	suba	d,sp		;a0 f6
	suba	d,x		;a0 e6
	suba	d,y		;a0 ee
	suba	*dir		;90*00
	suba	ext		;b0s00r00
	suba	ext,sp		;a0 f2s00r00
	suba	ext,x		;a0 e2s00r00
	suba	ext,y		;a0 eas00r00
	suba	ind,pc		;a0 f8 37
	suba	ind,sp		;a0 f0 37
	suba	ind,x		;a0 e0 37
	suba	ind,y		;a0 e8 37
	suba	small,pc	;a0 ce
	suba	small,sp	;a0 8e
	suba	small,x		;a0 0e
	suba	small,y		;a0 4e
	subb	#immed		;c0r00
	subb	1,+sp		;e0 a0
	subb	1,+x		;e0 20
	subb	1,+y		;e0 60
	subb	8,+sp		;e0 a7
	subb	8,+x		;e0 27
	subb	8,+y		;e0 67
	subb	,pc		;e0 c0
	subb	,sp		;e0 80
	subb	,x		;e0 00
	subb	,y		;e0 40
	subb	1,-sp		;e0 af
	subb	1,-x		;e0 2f
	subb	1,-y		;e0 6f
	subb	8,-sp		;e0 a8
	subb	8,-x		;e0 28
	subb	8,-y		;e0 68
	subb	-1,sp		;e0 9f
	subb	-1,x		;e0 1f
	subb	-1,y		;e0 5f
	subb	-16,sp		;e0 90
	subb	-16,x		;e0 10
	subb	-16,y		;e0 50
	subb	-17,sp		;e0 f1 ef
	subb	-17,x		;e0 e1 ef
	subb	-17,y		;e0 e9 ef
	subb	-small,pc	;e0 d2
	subb	-small,sp	;e0 92
	subb	-small,x	;e0 12
	subb	-small,y	;e0 52
	subb	0,pc		;e0 c0
	subb	0,sp		;e0 80
	subb	0,x		;e0 00
	subb	0,y		;e0 40
	subb	1,sp+		;e0 b0
	subb	1,x+		;e0 30
	subb	1,y+		;e0 70
	subb	1,sp		;e0 81
	subb	1,x		;e0 01
	subb	1,y		;e0 41
	subb	1,sp-		;e0 bf
	subb	1,x-		;e0 3f
	subb	1,y-		;e0 7f
	subb	125,pc		;e0 f8 7d
	subb	125,sp		;e0 f0 7d
	subb	125,x		;e0 e0 7d
	subb	125,y		;e0 e8 7d
	subb	15,sp		;e0 8f
	subb	15,x		;e0 0f
	subb	15,y		;e0 4f
	subb	16,sp		;e0 f0 10
	subb	16,x		;e0 e0 10
	subb	16,y		;e0 e8 10
	subb	8,sp+		;e0 b7
	subb	8,x+		;e0 37
	subb	8,y+		;e0 77
	subb	8,sp-		;e0 b8
	subb	8,x-		;e0 38
	subb	8,y-		;e0 78
	subb	a,sp		;e0 f4
	subb	a,x		;e0 e4
	subb	a,y		;e0 ec
	subb	b,sp		;e0 f5
	subb	b,x		;e0 e5
	subb	b,y		;e0 ed
	subb	d,sp		;e0 f6
	subb	d,x		;e0 e6
	subb	d,y		;e0 ee
	subb	*dir		;d0*00
	subb	ext		;f0s00r00
	subb	ext,sp		;e0 f2s00r00
	subb	ext,x		;e0 e2s00r00
	subb	ext,y		;e0 eas00r00
	subb	ind,pc		;e0 f8 37
	subb	ind,sp		;e0 f0 37
	subb	ind,x		;e0 e0 37
	subb	ind,y		;e0 e8 37
	subb	small,pc	;e0 ce
	subb	small,sp	;e0 8e
	subb	small,x		;e0 0e
	subb	small,y		;e0 4e
	subd	#immed		;83s00r00
	subd	1,+sp		;a3 a0
	subd	1,+x		;a3 20
	subd	1,+y		;a3 60
	subd	8,+sp		;a3 a7
	subd	8,+x		;a3 27
	subd	8,+y		;a3 67
	subd	,pc		;a3 c0
	subd	,sp		;a3 80
	subd	,x		;a3 00
	subd	,y		;a3 40
	subd	1,-sp		;a3 af
	subd	1,-x		;a3 2f
	subd	1,-y		;a3 6f
	subd	8,-sp		;a3 a8
	subd	8,-x		;a3 28
	subd	8,-y		;a3 68
	subd	-1,sp		;a3 9f
	subd	-1,x		;a3 1f
	subd	-1,y		;a3 5f
	subd	-16,sp		;a3 90
	subd	-16,x		;a3 10
	subd	-16,y		;a3 50
	subd	-17,sp		;a3 f1 ef
	subd	-17,x		;a3 e1 ef
	subd	-17,y		;a3 e9 ef
	subd	-small,pc	;a3 d2
	subd	-small,sp	;a3 92
	subd	-small,x	;a3 12
	subd	-small,y	;a3 52
	subd	0,pc		;a3 c0
	subd	0,sp		;a3 80
	subd	0,x		;a3 00
	subd	0,y		;a3 40
	subd	1,sp+		;a3 b0
	subd	1,x+		;a3 30
	subd	1,y+		;a3 70
	subd	1,sp		;a3 81
	subd	1,x		;a3 01
	subd	1,y		;a3 41
	subd	1,sp-		;a3 bf
	subd	1,x-		;a3 3f
	subd	1,y-		;a3 7f
	subd	125,pc		;a3 f8 7d
	subd	125,sp		;a3 f0 7d
	subd	125,x		;a3 e0 7d
	subd	125,y		;a3 e8 7d
	subd	15,sp		;a3 8f
	subd	15,x		;a3 0f
	subd	15,y		;a3 4f
	subd	16,sp		;a3 f0 10
	subd	16,x		;a3 e0 10
	subd	16,y		;a3 e8 10
	subd	8,sp+		;a3 b7
	subd	8,x+		;a3 37
	subd	8,y+		;a3 77
	subd	8,sp-		;a3 b8
	subd	8,x-		;a3 38
	subd	8,y-		;a3 78
	subd	a,sp		;a3 f4
	subd	a,x		;a3 e4
	subd	a,y		;a3 ec
	subd	b,sp		;a3 f5
	subd	b,x		;a3 e5
	subd	b,y		;a3 ed
	subd	d,sp		;a3 f6
	subd	d,x		;a3 e6
	subd	d,y		;a3 ee
	subd	*dir		;93*00
	subd	ext		;b3s00r00
	subd	ext,sp		;a3 f2s00r00
	subd	ext,x		;a3 e2s00r00
	subd	ext,y		;a3 eas00r00
	subd	ind,pc		;a3 f8 37
	subd	ind,sp		;a3 f0 37
	subd	ind,x		;a3 e0 37
	subd	ind,y		;a3 e8 37
	subd	small,pc	;a3 ce
	subd	small,sp	;a3 8e
	subd	small,x		;a3 0e
	subd	small,y		;a3 4e
	swi			;3f

t:	tab			;18 0e
	tap			;b7 02
	tba			;18 0f
	tbl     b,x		;18 3d e5
	tfr	a,a		;b7 00
	tfr	a,b		;b7 01
	tfr	a,ccr		;b7 02
	tfr	a,d		;b7 04
	tfr	a,sp		;b7 07
	tfr	a,x		;b7 05
	tfr	a,y		;b7 06
	tfr	b,a		;b7 10
	tfr	b,b		;b7 11
	tfr	b,ccr		;b7 12
	tfr	b,d		;b7 14
	tfr	b,sp		;b7 17
	tfr	b,x		;b7 15
	tfr	b,y		;b7 16
	tfr	ccr,a		;b7 20
	tfr	ccr,b		;b7 21
	tfr	ccr,ccr		;b7 22
	tfr	ccr,d		;b7 24
	tfr	ccr,sp		;b7 27
	tfr	ccr,x		;b7 25
	tfr	ccr,y		;b7 26
	tfr	d,a		;b7 40
	tfr	d,b		;b7 41
	tfr	d,ccr		;b7 42
	tfr	d,d		;b7 44
	tfr	d,sp		;b7 47
	tfr	d,x		;b7 45
	tfr	d,y		;b7 46
	tfr	sp,a		;b7 70
	tfr	sp,b		;b7 71
	tfr	sp,ccr		;b7 72
	tfr	sp,d		;b7 74
	tfr	sp,sp		;b7 77
	tfr	sp,x		;b7 75
	tfr	sp,y		;b7 76
	tfr	x,a		;b7 50
	tfr	x,b		;b7 51
	tfr	x,ccr		;b7 52
	tfr	x,d		;b7 54
	tfr	x,sp		;b7 57
	tfr	x,x		;b7 55
	tfr	x,y		;b7 56
	tfr	y,a		;b7 60
	tfr	y,b		;b7 61
	tfr	y,ccr		;b7 62
	tfr	y,d		;b7 64
	tfr	y,sp		;b7 67
	tfr	y,x		;b7 65
	tfr	y,y		;b7 66
	tpa			;b7 20
	tst	1,+sp		;e7 a0
	tst	1,+x		;e7 20
	tst	1,+y		;e7 60
	tst	8,+sp		;e7 a7
	tst	8,+x		;e7 27
	tst	8,+y		;e7 67
	tst	,pc		;e7 c0
	tst	,sp		;e7 80
	tst	,x		;e7 00
	tst	,y		;e7 40
	tst	1,-sp		;e7 af
	tst	1,-x		;e7 2f
	tst	1,-y		;e7 6f
	tst	8,-sp		;e7 a8
	tst	8,-x		;e7 28
	tst	8,-y		;e7 68
	tst	-1,sp		;e7 9f
	tst	-1,x		;e7 1f
	tst	-1,y		;e7 5f
	tst	-16,sp		;e7 90
	tst	-16,x		;e7 10
	tst	-16,y		;e7 50
	tst	-17,sp		;e7 f1 ef
	tst	-17,x		;e7 e1 ef
	tst	-17,y		;e7 e9 ef
	tst	-small,pc	;e7 d2
	tst	-small,sp	;e7 92
	tst	-small,x	;e7 12
	tst	-small,y	;e7 52
	tst	0,pc		;e7 c0
	tst	0,sp		;e7 80
	tst	0,x		;e7 00
	tst	0,y		;e7 40
	tst	1,sp+		;e7 b0
	tst	1,x+		;e7 30
	tst	1,y+		;e7 70
	tst	1,sp		;e7 81
	tst	1,x		;e7 01
	tst	1,y		;e7 41
	tst	1,sp-		;e7 bf
	tst	1,x-		;e7 3f
	tst	1,y-		;e7 7f
	tst	125,pc		;e7 f8 7d
	tst	125,sp		;e7 f0 7d
	tst	125,x		;e7 e0 7d
	tst	125,y		;e7 e8 7d
	tst	15,sp		;e7 8f
	tst	15,x		;e7 0f
	tst	15,y		;e7 4f
	tst	16,sp		;e7 f0 10
	tst	16,x		;e7 e0 10
	tst	16,y		;e7 e8 10
	tst	8,sp+		;e7 b7
	tst	8,x+		;e7 37
	tst	8,y+		;e7 77
	tst	8,sp-		;e7 b8
	tst	8,x-		;e7 38
	tst	8,y-		;e7 78
	tst	a,sp		;e7 f4
	tst	a,x		;e7 e4
	tst	a,y		;e7 ec
	tst	b,sp		;e7 f5
	tst	b,x		;e7 e5
	tst	b,y		;e7 ed
	tst	d,sp		;e7 f6
	tst	d,x		;e7 e6
	tst	d,y		;e7 ee
	tst	*dir		;f7s00r00
	tst	ext		;f7s00r00
	tst	ext,sp		;e7 f2s00r00
	tst	ext,x		;e7 e2s00r00
	tst	ext,y		;e7 eas00r00
	tst	ind,pc		;e7 f8 37
	tst	ind,sp		;e7 f0 37
	tst	ind,x		;e7 e0 37
	tst	ind,y		;e7 e8 37
	tst	small,pc	;e7 ce
	tst	small,sp	;e7 8e
	tst	small,x		;e7 0e
	tst	small,y		;e7 4e
	tsta			;97
	tstb			;d7
	tsx			;b7 75
	tsy			;b7 76
	txs			;b7 57
	tys			;b7 67

w:	wai			;3e
	wav			;18 3c

x:	xgdx			;b7 c5
	xgdy			;b7 c6

call:	call	1,+sp,pg 	;4b a0u00
	call	1,+x,pg		;4b 20u00
	call	1,+y,pg		;4b 60u00
	call	8,+sp,pg	;4b a7u00
	call	8,+x,pg		;4b 27u00
	call	8,+y,pg		;4b 67u00
	call	,pc,pg		;4b c0u00
	call	,sp,pg		;4b 80u00
	call	,x,pg		;4b 00u00
	call	,y,pg		;4b 40u00
	call	1,-sp,pg	;4b afu00
	call	1,-x,pg		;4b 2fu00
	call	1,-y,pg		;4b 6fu00
	call	8,-sp,pg	;4b a8u00
	call	8,-x,pg		;4b 28u00
	call	8,-y,pg		;4b 68u00
	call	-1,sp,pg	;4b 9fu00
	call	-1,x,pg		;4b 1fu00
	call	-1,y,pg		;4b 5fu00
	call	-16,sp,pg	;4b 90u00
	call	-16,x,pg	;4b 10u00
	call	-16,y,pg	;4b 50u00
	call	-17,sp,pg	;4b f1 efu00
	call	-17,x,pg	;4b e1 efu00
	call	-17,y,pg	;4b e9 efu00
	call	-small,pc,pg	;4b d2u00
	call	-small,sp,pg	;4b 92u00
	call	-small,x,pg	;4b 12u00
	call	-small,y,pg	;4b 52u00
	call	0,pc,pg		;4b c0u00
	call	0,sp,pg		;4b 80u00
	call	0,x,pg		;4b 00u00
	call	0,y,pg		;4b 40u00
	call	1,sp+,pg	;4b b0u00
	call	1,x+,pg		;4b 30u00
	call	1,y+,pg		;4b 70u00
	call	1,sp,pg		;4b 81u00
	call	1,x,pg		;4b 01u00
	call	1,y,pg		;4b 41u00
	call	1,sp-,pg	;4b bfu00
	call	1,x-,pg		;4b 3fu00
	call	1,y-,pg		;4b 7fu00
	call	125,pc,pg	;4b f8 7du00
	call	125,sp,pg	;4b f0 7du00
	call	125,x,pg	;4b e0 7du00
	call	125,y,pg	;4b e8 7du00
	call	15,sp,pg	;4b 8fu00
	call	15,x,pg		;4b 0fu00
	call	15,y,pg		;4b 4fu00
	call	16,sp,pg	;4b f0 10u00
	call	16,x,pg		;4b e0 10u00
	call	16,y,pg		;4b e8 10u00
	call	8,sp+,pg	;4b b7u00
	call	8,x+,pg		;4b 37u00
	call	8,y+,pg		;4b 77u00
	call	8,sp-,pg	;4b b8u00
	call	8,x-,pg		;4b 38u00
	call	8,y-,pg		;4b 78u00
	call	a,sp,pg		;4b f4u00
	call	a,x,pg		;4b e4u00
	call	a,y,pg		;4b ecu00
	call	b,sp,pg		;4b f5u00
	call	b,x,pg		;4b e5u00
	call	b,y,pg		;4b edu00
	call	d,sp,pg		;4b f6u00
	call	d,x,pg		;4b e6u00
	call	d,y,pg		;4b eeu00
	call	*dir,pg		;4as00r00u00
	call	ext,pg		;4as00r00u00
	call	ext,sp,pg	;4b f2s00r00u00
	call	ext,x,pg	;4b e2s00r00u00
	call	ext,y,pg	;4b eas00r00u00
	call	ind,pc,pg	;4b f8 37u00
	call	ind,sp,pg	;4b f0 37u00
	call	ind,x,pg	;4b e0 37u00
	call	ind,y,pg	;4b e8 37u00
	call	small,pc,pg	;4b ceu00
	call	small,sp,pg	;4b 8eu00
	call	small,x,pg	;4b 0eu00
	call	small,y,pg	;4b 4eu00

movb:	movb	#immed,3,+x	;18 08 22r00
	movb	#immed,5,-y	;18 08 6br00
	movb	#immed,5,sp	;18 08 85r00
	movb	#immed,ext	;18 0br00s00r00
	movb	1,+sp,3,+x	;18 0a a0 22
	movb	1,+sp,5,-y	;18 0a a0 6b
	movb	1,+sp,5,sp	;18 0a a0 85
	movb	1,+sp,ext	;18 0d a0s00r00
	movb	1,+x,3,+x 	;18 0a 20 22
	movb	1,+x,5,-y	;18 0a 20 6b
	movb	1,+x,5,sp	;18 0a 20 85
	movb	1,+x,ext 	;18 0d 20s00r00
	movb	1,+y,3,+x	;18 0a 60 22
	movb	1,+y,5,-y	;18 0a 60 6b
	movb	1,+y,5,sp	;18 0a 60 85
	movb	1,+y,ext	;18 0d 60s00r00
	movb	3,+x,1,+sp 	;18 0a 22 a0
	movb	3,+x,1,+x 	;18 0a 22 20
	movb	3,+x,1,+y 	;18 0a 22 60
	movb	3,+x,8,+sp 	;18 0a 22 a7
	movb	3,+x,8,+x 	;18 0a 22 27
	movb	3,+x,8,+y 	;18 0a 22 67
;noofst	movb	3,+x,0,pc 	;18 0a 22 c0
	movb	3,+x,0,pc 	;18 0a 22 df
	movb	3,+x,0,sp 	;18 0a 22 80
	movb	3,+x,0,x 	;18 0a 22 00
	movb	3,+x,0,y 	;18 0a 22 40
	movb	3,+x,1,-sp 	;18 0a 22 af
	movb	3,+x,1,-x 	;18 0a 22 2f
	movb	3,+x,1,-y 	;18 0a 22 6f
	movb	3,+x,8,-sp 	;18 0a 22 a8
	movb	3,+x,8,-x 	;18 0a 22 28
	movb	3,+x,8,-y 	;18 0a 22 68
	movb	3,+x,-1,sp 	;18 0a 22 9f
	movb	3,+x,-1,x 	;18 0a 22 1f
	movb	3,+x,-1,y 	;18 0a 22 5f
	movb	3,+x,-16,sp 	;18 0a 22 90
	movb	3,+x,-16,x 	;18 0a 22 10
	movb	3,+x,-16,y 	;18 0a 22 50
;noofst	movb	3,+x,-small,pc 	;18 0a 22 d2
	movb	3,+x,-small,pc 	;18 0a 22 d1
	movb	3,+x,-small,sp 	;18 0a 22 92
	movb	3,+x,-small,x 	;18 0a 22 12
	movb	3,+x,-small,y 	;18 0a 22 52
;noofst	movb	3,+x,0,pc 	;18 0a 22 c0
	movb	3,+x,0,pc 	;18 0a 22 df
	movb	3,+x,0,sp 	;18 0a 22 80
	movb	3,+x,0,x 	;18 0a 22 00
	movb	3,+x,0,y 	;18 0a 22 40
	movb	3,+x,1,sp+ 	;18 0a 22 b0
	movb	3,+x,1,x+ 	;18 0a 22 30
	movb	3,+x,1,y+ 	;18 0a 22 70
	movb	3,+x,1,sp 	;18 0a 22 81
	movb	3,+x,1,x 	;18 0a 22 01
	movb	3,+x,1,y 	;18 0a 22 41
	movb	3,+x,1,sp- 	;18 0a 22 bf
	movb	3,+x,1,x- 	;18 0a 22 3f
	movb	3,+x,1,y- 	;18 0a 22 7f
	movb	3,+x,15,sp 	;18 0a 22 8f
	movb	3,+x,15,x 	;18 0a 22 0f
	movb	3,+x,15,y 	;18 0a 22 4f
	movb	3,+x,8,sp+ 	;18 0a 22 b7
	movb	3,+x,8,x+ 	;18 0a 22 37
	movb	3,+x,8,y+ 	;18 0a 22 77
	movb	3,+x,8,sp- 	;18 0a 22 b8
	movb	3,+x,8,x- 	;18 0a 22 38
	movb	3,+x,8,y- 	;18 0a 22 78
	movb	3,+x,a,sp 	;18 0a 22 f4
	movb	3,+x,a,x 	;18 0a 22 e4
	movb	3,+x,a,y 	;18 0a 22 ec
	movb	3,+x,b,sp 	;18 0a 22 f5
	movb	3,+x,b,x 	;18 0a 22 e5
	movb	3,+x,b,y 	;18 0a 22 ed
	movb	3,+x,d,sp 	;18 0a 22 f6
	movb	3,+x,d,x 	;18 0a 22 e6
	movb	3,+x,d,y 	;18 0a 22 ee
	movb	3,+x,ext 	;18 0d 22s00r00
;noofst	movb	3,+x,small,pc 	;18 0a 22 ce
	movb	3,+x,small,pc 	;18 0a 22 cd
	movb	3,+x,small,sp 	;18 0a 22 8e
	movb	3,+x,small,x 	;18 0a 22 0e
	movb	3,+x,small,y 	;18 0a 22 4e
	movb	8,+sp,3,+x	;18 0a a7 22
	movb	8,+sp,5,-y	;18 0a a7 6b
	movb	8,+sp,5,sp	;18 0a a7 85
	movb	8,+sp,ext	;18 0d a7s00r00
	movb	8,+x,3,+x	;18 0a 27 22
	movb	8,+x,5,-y	;18 0a 27 6b
	movb	8,+x,5,sp	;18 0a 27 85
	movb	8,+x,ext	;18 0d 27s00r00
	movb	8,+y,3,+x	;18 0a 67 22
	movb	8,+y,5,-y	;18 0a 67 6b
	movb	8,+y,5,sp	;18 0a 67 85
	movb	8,+y,ext	;18 0d 67s00r00
;noofst	movb	,pc,3,+x	;18 0a c0 22
	movb	,pc,3,+x	;18 0a c1 22
;noofst	movb	,pc,5,-y	;18 0a c0 6b
	movb	,pc,5,-y	;18 0a c1 6b
;noofst	movb	,pc,5,sp	;18 0a c0 85
	movb	,pc,5,sp	;18 0a c1 85
;noofst	movb	,pc,ext		;18 0d c0s00r00
	movb	,pc,ext		;18 0d c2s00r00
	movb	,sp,3,+x	;18 0a 80 22
	movb	,sp,5,-y	;18 0a 80 6b
	movb	,sp,5,sp	;18 0a 80 85
	movb	,sp,ext		;18 0d 80s00r00
	movb	,x,3,+x		;18 0a 00 22
	movb	,x,5,-y		;18 0a 00 6b
	movb	,x,5,sp		;18 0a 00 85
	movb	,x,ext		;18 0d 00s00r00
	movb	,y,3,+x		;18 0a 40 22
	movb	,y,5,-y		;18 0a 40 6b
	movb	,y,5,sp		;18 0a 40 85
	movb	,y,ext		;18 0d 40s00r00
	movb	1,-sp,3,+x	;18 0a af 22
	movb	1,-sp,5,-y	;18 0a af 6b
	movb	1,-sp,5,sp	;18 0a af 85
	movb	1,-sp,ext	;18 0d afs00r00
	movb	1,-x,3,+x	;18 0a 2f 22
	movb	1,-x,5,-y	;18 0a 2f 6b
	movb	1,-x,5,sp	;18 0a 2f 85
	movb	1,-x,ext	;18 0d 2fs00r00
	movb	1,-y,3,+x	;18 0a 6f 22
	movb	1,-y,5,-y	;18 0a 6f 6b
	movb	1,-y,5,sp	;18 0a 6f 85
	movb	1,-y,ext	;18 0d 6fs00r00
	movb	8,-sp,3,+x	;18 0a a8 22
	movb	8,-sp,5,-y	;18 0a a8 6b
	movb	8,-sp,5,sp	;18 0a a8 85
	movb	8,-sp,ext	;18 0d a8s00r00
	movb	8,-x,3,+x	;18 0a 28 22
	movb	8,-x,5,-y	;18 0a 28 6b
	movb	8,-x,5,sp	;18 0a 28 85
	movb	8,-x,ext	;18 0d 28s00r00
	movb	8,-y,3,+x	;18 0a 68 22
	movb	8,-y,5,-y	;18 0a 68 6b
	movb	8,-y,5,sp	;18 0a 68 85
	movb	8,-y,ext	;18 0d 68s00r00
	movb	-1,sp,3,+x	;18 0a 9f 22
	movb	-1,sp,5,-y	;18 0a 9f 6b
	movb	-1,sp,5,sp	;18 0a 9f 85
	movb	-1,sp,ext	;18 0d 9fs00r00
	movb	-1,x,3,+x	;18 0a 1f 22
	movb	-1,x,5,-y	;18 0a 1f 6b
	movb	-1,x,5,sp	;18 0a 1f 85
	movb	-1,x,ext	;18 0d 1fs00r00
	movb	-1,y,3,+x	;18 0a 5f 22
	movb	-1,y,5,-y	;18 0a 5f 6b
	movb	-1,y,5,sp	;18 0a 5f 85
	movb	-1,y,ext	;18 0d 5fs00r00
	movb	-16,sp,3,+x	;18 0a 90 22
	movb	-16,sp,5,-y	;18 0a 90 6b
	movb	-16,sp,5,sp	;18 0a 90 85
	movb	-16,sp,ext	;18 0d 90s00r00
	movb	-16,x,3,+x	;18 0a 10 22
	movb	-16,x,5,-y	;18 0a 10 6b
	movb	-16,x,5,sp	;18 0a 10 85
	movb	-16,x,ext	;18 0d 10s00r00
	movb	-16,y,3,+x	;18 0a 50 22
	movb	-16,y,5,-y	;18 0a 50 6b
	movb	-16,y,5,sp	;18 0a 50 85
	movb	-16,y,ext	;18 0d 50s00r00
;noofst	movb	-small,pc,3,+x	;18 0a d2 22
	movb	-small,pc,3,+x	;18 0a d3 22
;noofst	movb	-small,pc,5,-y	;18 0a d2 6b
	movb	-small,pc,5,-y	;18 0a d3 6b
;noofst	movb	-small,pc,5,sp	;18 0a d2 85
	movb	-small,pc,5,sp	;18 0a d3 85
;noofst	movb	-small,pc,ext	;18 0d d2s00r00
	movb	-small,pc,ext	;18 0d d4s00r00
	movb	-small,sp,3,+x	;18 0a 92 22
	movb	-small,sp,5,-y	;18 0a 92 6b
	movb	-small,sp,5,sp	;18 0a 92 85
	movb	-small,sp,ext	;18 0d 92s00r00
	movb	-small,x,3,+x	;18 0a 12 22
	movb	-small,x,5,-y	;18 0a 12 6b
	movb	-small,x,5,sp	;18 0a 12 85
	movb	-small,x,ext	;18 0d 12s00r00
	movb	-small,y,3,+x	;18 0a 52 22
	movb	-small,y,5,-y	;18 0a 52 6b
	movb	-small,y,5,sp	;18 0a 52 85
	movb	-small,y,ext	;18 0d 52s00r00
;noofst	movb	0,pc,3,+x	;18 0a c0 22
	movb	0,pc,3,+x	;18 0a c1 22
;noofst	movb	0,pc,5,-y	;18 0a c0 6b
	movb	0,pc,5,-y	;18 0a c1 6b
;noofst	movb	0,pc,5,sp	;18 0a c0 85
	movb	0,pc,5,sp	;18 0a c1 85
;noofst	movb	0,pc,ext	;18 0d c0s00r00
	movb	0,pc,ext	;18 0d c2s00r00
	movb	0,sp,3,+x	;18 0a 80 22
	movb	0,sp,5,-y	;18 0a 80 6b
	movb	0,sp,5,sp	;18 0a 80 85
	movb	0,sp,ext	;18 0d 80s00r00
	movb	0,x,3,+x	;18 0a 00 22
	movb	0,x,5,-y	;18 0a 00 6b
	movb	0,x,5,sp	;18 0a 00 85
	movb	0,x,ext		;18 0d 00s00r00
	movb	0,y,3,+x	;18 0a 40 22
	movb	0,y,5,-y	;18 0a 40 6b
	movb	0,y,5,sp	;18 0a 40 85
	movb	0,y,ext		;18 0d 40s00r00
	movb	1,sp+,3,+x	;18 0a b0 22
	movb	1,sp+,5,-y	;18 0a b0 6b
	movb	1,sp+,5,sp	;18 0a b0 85
	movb	1,sp+,ext	;18 0d b0s00r00
	movb	1,x+,3,+x	;18 0a 30 22
	movb	1,x+,5,-y	;18 0a 30 6b
	movb	1,x+,5,sp	;18 0a 30 85
	movb	1,x+,ext	;18 0d 30s00r00
	movb	1,y+,3,+x	;18 0a 70 22
	movb	1,y+,5,-y	;18 0a 70 6b
	movb	1,y+,5,sp	;18 0a 70 85
	movb	1,y+,ext	;18 0d 70s00r00
	movb	1,sp,3,+x	;18 0a 81 22
	movb	1,sp,5,-y	;18 0a 81 6b
	movb	1,sp,5,sp	;18 0a 81 85
	movb	1,sp,ext	;18 0d 81s00r00
	movb	1,x,5,+x	;18 0a 01 24
	movb	1,x,5,-y	;18 0a 01 6b
	movb	1,x,5,sp	;18 0a 01 85
	movb	1,x,ext		;18 0d 01s00r00
	movb	1,y,3,+x	;18 0a 41 22
	movb	1,y,5,-y	;18 0a 41 6b
	movb	1,y,5,sp	;18 0a 41 85
	movb	1,y,ext		;18 0d 41s00r00
	movb	1,sp-,3,+x	;18 0a bf 22
	movb	1,sp-,5,-y	;18 0a bf 6b
	movb	1,sp-,5,sp	;18 0a bf 85
	movb	1,sp-,ext	;18 0d bfs00r00
	movb	1,x-,3,+x	;18 0a 3f 22
	movb	1,x-,5,-y	;18 0a 3f 6b
	movb	1,x-,5,sp	;18 0a 3f 85
	movb	1,x-,ext	;18 0d 3fs00r00
	movb	1,y-,3,+x	;18 0a 7f 22
	movb	1,y-,5,-y	;18 0a 7f 6b
	movb	1,y-,5,sp	;18 0a 7f 85
	movb	1,y-,ext	;18 0d 7fs00r00
	movb	5,-y,1,+sp 	;18 0a 6b a0
	movb	5,-y,1,+x 	;18 0a 6b 20
	movb	5,-y,1,+y 	;18 0a 6b 60
	movb	5,-y,8,+sp 	;18 0a 6b a7
	movb	5,-y,8,+x 	;18 0a 6b 27
	movb	5,-y,8,+y 	;18 0a 6b 67
;noofst	movb	5,-y,0,pc 	;18 0a 6b c0
	movb	5,-y,0,pc 	;18 0a 6b df
	movb	5,-y,0,sp 	;18 0a 6b 80
	movb	5,-y,0,x 	;18 0a 6b 00
	movb	5,-y,0,y 	;18 0a 6b 40
	movb	5,-y,1,-sp 	;18 0a 6b af
	movb	5,-y,1,-x 	;18 0a 6b 2f
	movb	5,-y,1,-y 	;18 0a 6b 6f
	movb	5,-y,8,-sp 	;18 0a 6b a8
	movb	5,-y,8,-x 	;18 0a 6b 28
	movb	5,-y,8,-y 	;18 0a 6b 68
	movb	5,-y,-1,sp 	;18 0a 6b 9f
	movb	5,-y,-1,x 	;18 0a 6b 1f
	movb	5,-y,-1,y 	;18 0a 6b 5f
	movb	5,-y,-16,sp 	;18 0a 6b 90
	movb	5,-y,-16,x 	;18 0a 6b 10
	movb	5,-y,-16,y 	;18 0a 6b 50
;noofst	movb	5,-y,-small,pc 	;18 0a 6b d2
	movb	5,-y,-small,pc 	;18 0a 6b d1
	movb	5,-y,-small,sp 	;18 0a 6b 92
	movb	5,-y,-small,x 	;18 0a 6b 12
	movb	5,-y,-small,y 	;18 0a 6b 52
;noofst	movb	5,-y,0,pc 	;18 0a 6b c0
	movb	5,-y,0,pc 	;18 0a 6b df
	movb	5,-y,0,sp 	;18 0a 6b 80
	movb	5,-y,0,x 	;18 0a 6b 00
	movb	5,-y,0,y 	;18 0a 6b 40
	movb	5,-y,1,sp+ 	;18 0a 6b b0
	movb	5,-y,1,x+ 	;18 0a 6b 30
	movb	5,-y,1,y+ 	;18 0a 6b 70
	movb	5,-y,1,sp 	;18 0a 6b 81
	movb	5,-y,1,x 	;18 0a 6b 01
	movb	5,-y,1,y 	;18 0a 6b 41
	movb	5,-y,1,sp- 	;18 0a 6b bf
	movb	5,-y,1,x- 	;18 0a 6b 3f
	movb	5,-y,1,y- 	;18 0a 6b 7f
	movb	5,-y,15,sp 	;18 0a 6b 8f
	movb	5,-y,15,x 	;18 0a 6b 0f
	movb	5,-y,15,y 	;18 0a 6b 4f
	movb	5,-y,8,sp+ 	;18 0a 6b b7
	movb	5,-y,8,x+ 	;18 0a 6b 37
	movb	5,-y,8,y+ 	;18 0a 6b 77
	movb	5,-y,8,sp- 	;18 0a 6b b8
	movb	5,-y,8,x- 	;18 0a 6b 38
	movb	5,-y,8,y- 	;18 0a 6b 78
	movb	5,-y,a,sp 	;18 0a 6b f4
	movb	5,-y,a,x 	;18 0a 6b e4
	movb	5,-y,a,y 	;18 0a 6b ec
	movb	5,-y,b,sp 	;18 0a 6b f5
	movb	5,-y,b,x 	;18 0a 6b e5
	movb	5,-y,b,y 	;18 0a 6b ed
	movb	5,-y,d,sp 	;18 0a 6b f6
	movb	5,-y,d,x 	;18 0a 6b e6
	movb	5,-y,d,y 	;18 0a 6b ee
	movb	5,-y,ext 	;18 0d 6bs00r00
;noofst	movb	5,-y,small,pc 	;18 0a 6b ce
	movb	5,-y,small,pc 	;18 0a 6b cd
	movb	5,-y,small,sp 	;18 0a 6b 8e
	movb	5,-y,small,x 	;18 0a 6b 0e
	movb	5,-y,small,y 	;18 0a 6b 4e
	movb	15,sp,3,+x	;18 0a 8f 22
	movb	15,sp,5,-y	;18 0a 8f 6b
	movb	15,sp,5,sp	;18 0a 8f 85
	movb	15,sp,ext	;18 0d 8fs00r00
	movb	15,x,3,+x	;18 0a 0f 22
	movb	15,x,5,-y	;18 0a 0f 6b
	movb	15,x,5,sp	;18 0a 0f 85
	movb	15,x,ext	;18 0d 0fs00r00
	movb	15,y,3,+x	;18 0a 4f 22
	movb	15,y,5,-y	;18 0a 4f 6b
	movb	15,y,5,sp	;18 0a 4f 85
	movb	15,y,ext	;18 0d 4fs00r00
	movb	5,sp,1,+sp 	;18 0a 85 a0
	movb	5,sp,1,+x 	;18 0a 85 20
	movb	5,sp,1,+y 	;18 0a 85 60
	movb	5,sp,8,+sp 	;18 0a 85 a7
	movb	5,sp,8,+x 	;18 0a 85 27
	movb	5,sp,8,+y 	;18 0a 85 67
;noofst	movb	5,sp,0,pc 	;18 0a 85 c0
	movb	5,sp,0,pc 	;18 0a 85 df
	movb	5,sp,0,sp 	;18 0a 85 80
	movb	5,sp,0,x 	;18 0a 85 00
	movb	5,sp,0,y 	;18 0a 85 40
	movb	5,sp,1,-sp 	;18 0a 85 af
	movb	5,sp,1,-x 	;18 0a 85 2f
	movb	5,sp,1,-y 	;18 0a 85 6f
	movb	5,sp,8,-sp 	;18 0a 85 a8
	movb	5,sp,8,-x 	;18 0a 85 28
	movb	5,sp,8,-y 	;18 0a 85 68
	movb	5,sp,-1,sp 	;18 0a 85 9f
	movb	5,sp,-1,x 	;18 0a 85 1f
	movb	5,sp,-1,y 	;18 0a 85 5f
	movb	5,sp,-16,sp 	;18 0a 85 90
	movb	5,sp,-16,x 	;18 0a 85 10
	movb	5,sp,-16,y 	;18 0a 85 50
;noofst	movb	5,sp,-small,pc 	;18 0a 85 d2
	movb	5,sp,-small,pc 	;18 0a 85 d1
	movb	5,sp,-small,sp 	;18 0a 85 92
	movb	5,sp,-small,x 	;18 0a 85 12
	movb	5,sp,-small,y 	;18 0a 85 52
;noofst	movb	5,sp,0,pc 	;18 0a 85 c0
	movb	5,sp,0,pc 	;18 0a 85 df
	movb	5,sp,0,sp 	;18 0a 85 80
	movb	5,sp,0,x 	;18 0a 85 00
	movb	5,sp,0,y 	;18 0a 85 40
	movb	5,sp,1,sp+ 	;18 0a 85 b0
	movb	5,sp,1,x+ 	;18 0a 85 30
	movb	5,sp,1,y+ 	;18 0a 85 70
	movb	5,sp,1,sp 	;18 0a 85 81
	movb	5,sp,1,x 	;18 0a 85 01
	movb	5,sp,1,y 	;18 0a 85 41
	movb	5,sp,1,sp- 	;18 0a 85 bf
	movb	5,sp,1,x- 	;18 0a 85 3f
	movb	5,sp,1,y- 	;18 0a 85 7f
	movb	5,sp,8,sp+ 	;18 0a 85 b7
	movb	5,sp,8,x+ 	;18 0a 85 37
	movb	5,sp,8,y+ 	;18 0a 85 77
	movb	5,sp,8,sp- 	;18 0a 85 b8
	movb	5,sp,8,x- 	;18 0a 85 38
	movb	5,sp,8,y- 	;18 0a 85 78
	movb	5,sp,a,sp 	;18 0a 85 f4
	movb	5,sp,a,x 	;18 0a 85 e4
	movb	5,sp,a,y 	;18 0a 85 ec
	movb	5,sp,b,sp 	;18 0a 85 f5
	movb	5,sp,b,x 	;18 0a 85 e5
	movb	5,sp,b,y 	;18 0a 85 ed
	movb	5,sp,d,sp 	;18 0a 85 f6
	movb	5,sp,d,x 	;18 0a 85 e6
	movb	5,sp,d,y 	;18 0a 85 ee
	movb	5,sp,ext 	;18 0d 85s00r00
;noofst	movb	5,sp,small,pc 	;18 0a 85 ce
	movb	5,sp,small,pc 	;18 0a 85 cd
	movb	5,sp,small,sp 	;18 0a 85 8e
	movb	5,sp,small,x 	;18 0a 85 0e
	movb	5,sp,small,y 	;18 0a 85 4e
	movb	8,sp+,3,+x	;18 0a b7 22
	movb	8,sp+,5,-y	;18 0a b7 6b
	movb	8,sp+,5,sp	;18 0a b7 85
	movb	8,sp+,ext	;18 0d b7s00r00
	movb	8,x+,3,+x	;18 0a 37 22
	movb	8,x+,5,-y	;18 0a 37 6b
	movb	8,x+,5,sp	;18 0a 37 85
	movb	8,x+,ext	;18 0d 37s00r00
	movb	8,y+,3,+x	;18 0a 77 22
	movb	8,y+,5,-y	;18 0a 77 6b
	movb	8,y+,5,sp	;18 0a 77 85
	movb	8,y+,ext	;18 0d 77s00r00
	movb	8,sp-,3,+x	;18 0a b8 22
	movb	8,sp-,5,-y	;18 0a b8 6b
	movb	8,sp-,5,sp	;18 0a b8 85
	movb	8,sp-,ext	;18 0d b8s00r00
	movb	8,x-,3,+x	;18 0a 38 22
	movb	8,x-,5,-y	;18 0a 38 6b
	movb	8,x-,5,sp	;18 0a 38 85
	movb	8,x-,ext	;18 0d 38s00r00
	movb	8,y-,3,+x	;18 0a 78 22
	movb	8,y-,5,-y	;18 0a 78 6b
	movb	8,y-,5,sp	;18 0a 78 85
	movb	8,y-,ext	;18 0d 78s00r00
	movb	a,sp,3,+x	;18 0a f4 22
	movb	a,sp,5,-y	;18 0a f4 6b
	movb	a,sp,5,sp	;18 0a f4 85
	movb	a,sp,ext	;18 0d f4s00r00
	movb	a,x,3,+x	;18 0a e4 22
	movb	a,x,5,-y	;18 0a e4 6b
	movb	a,x,5,sp	;18 0a e4 85
	movb	a,x,ext		;18 0d e4s00r00
	movb	a,y,3,+x	;18 0a ec 22
	movb	a,y,5,-y	;18 0a ec 6b
	movb	a,y,5,sp	;18 0a ec 85
	movb	a,y,ext		;18 0d ecs00r00
	movb	b,sp,3,+x	;18 0a f5 22
	movb	b,sp,5,-y	;18 0a f5 6b
	movb	b,sp,5,sp	;18 0a f5 85
	movb	b,sp,ext	;18 0d f5s00r00
	movb	b,x,3,+x	;18 0a e5 22
	movb	b,x,5,-y	;18 0a e5 6b
	movb	b,x,5,sp	;18 0a e5 85
	movb	b,x,ext		;18 0d e5s00r00
	movb	b,y,3,+x	;18 0a ed 22
	movb	b,y,5,-y	;18 0a ed 6b
	movb	b,y,5,sp	;18 0a ed 85
	movb	b,y,ext 	;18 0d eds00r00
	movb	d,sp,3,+x	;18 0a f6 22
	movb	d,sp,5,-y	;18 0a f6 6b
	movb	d,sp,5,sp	;18 0a f6 85
	movb	d,sp,ext	;18 0d f6s00r00
	movb	d,x,3,+x	;18 0a e6 22
	movb	d,x,5,-y	;18 0a e6 6b
	movb	d,x,5,sp	;18 0a e6 85
	movb	d,x,ext		;18 0d e6s00r00
	movb	d,y,3,+x	;18 0a ee 22
	movb	d,y,5,-y	;18 0a ee 6b
	movb	d,y,5,sp	;18 0a ee 85
	movb	d,y,ext		;18 0d ees00r00
	movb	ext,1,+sp 	;18 09 a0s00r00
	movb	ext,1,+x 	;18 09 20s00r00
	movb	ext,1,+y 	;18 09 60s00r00
	movb	ext,8,+sp 	;18 09 a7s00r00
	movb	ext,8,+x 	;18 09 27s00r00
	movb	ext,8,+y 	;18 09 67s00r00
;noofst	movb	ext,0,pc 	;18 09 c0s00r00
	movb	ext,0,pc 	;18 09 des00r00
	movb	ext,0,sp 	;18 09 80s00r00
	movb	ext,0,x   	;18 09 00s00r00
	movb	ext,0,y 	;18 09 40s00r00
	movb	ext,1,-sp	;18 09 afs00r00
	movb	ext,1,-x	;18 09 2fs00r00
	movb	ext,1,-y 	;18 09 6fs00r00
	movb	ext,8,-sp 	;18 09 a8s00r00
	movb	ext,8,-x 	;18 09 28s00r00
	movb	ext,8,-y  	;18 09 68s00r00
	movb	ext,-1,sp 	;18 09 9fs00r00
	movb	ext,-1,x 	;18 09 1fs00r00
	movb	ext,-1,y 	;18 09 5fs00r00
	movb	ext,-16,sp 	;18 09 90s00r00
	movb	ext,-16,x 	;18 09 10s00r00
	movb	ext,-16,y 	;18 09 50s00r00
;noofst	movb	ext,-small,pc 	;18 09 d2s00r00
	movb	ext,-small,pc 	;18 09 d0s00r00
	movb	ext,-small,sp 	;18 09 92s00r00
	movb	ext,-small,x 	;18 09 12s00r00
	movb	ext,-small,y 	;18 09 52s00r00
;noofst	movb	ext,0,pc 	;18 09 c0s00r00
	movb	ext,0,pc 	;18 09 des00r00
	movb	ext,0,sp 	;18 09 80s00r00
	movb	ext,0,x 	;18 09 00s00r00
	movb	ext,0,y 	;18 09 40s00r00
	movb	ext,1,sp+ 	;18 09 b0s00r00
	movb	ext,1,x+ 	;18 09 30s00r00
	movb	ext,1,y+ 	;18 09 70s00r00
	movb	ext,1,sp 	;18 09 81s00r00
	movb	ext,1,x 	;18 09 01s00r00
	movb	ext,1,y 	;18 09 41s00r00
	movb	ext,1,sp- 	;18 09 bfs00r00
	movb	ext,1,x- 	;18 09 3fs00r00
	movb	ext,1,y- 	;18 09 7fs00r00
	movb	ext,8,sp+ 	;18 09 b7s00r00
	movb	ext,8,x+ 	;18 09 37s00r00
	movb	ext,8,y+ 	;18 09 77s00r00
	movb	ext,8,sp- 	;18 09 b8s00r00
	movb	ext,8,x- 	;18 09 38s00r00
	movb	ext,8,y- 	;18 09 78s00r00
	movb	ext,a,sp 	;18 09 f4s00r00
	movb	ext,a,x 	;18 09 e4s00r00
	movb	ext,a,y		;18 09 ecs00r00
	movb	ext,b,sp 	;18 09 f5s00r00
	movb	ext,b,x 	;18 09 e5s00r00
	movb	ext,b,y 	;18 09 eds00r00
	movb	ext,d,sp 	;18 09 f6s00r00
	movb	ext,d,x 	;18 09 e6s00r00
	movb	ext,d,y 	;18 09 ees00r00
	movb	ext,ext 	;18 0cs00r00s00r00
;noofst	movb	ext,small,pc	;18 09 ces00r00
	movb	ext,small,pc	;18 09 ccs00r00
	movb	ext,small,sp 	;18 09 8es00r00
	movb	ext,small,x 	;18 09 0es00r00
	movb	ext,small,y 	;18 09 4es00r00
;noofst	movb	small,pc,3,+x	;18 0a ce 22
	movb	small,pc,3,+x	;18 0a cf 22
;noofst	movb	small,pc,5,-y	;18 0a ce 6b
	movb	small,pc,5,-y	;18 0a cf 6b
;noofst	movb	small,pc,5,sp	;18 0a ce 85
	movb	small,pc,5,sp	;18 0a cf 85
;noofst	movb	small,pc,ext	;18 0d ces00r00
;a	movb	small,pc,ext	;18 0d d0s00r00
	movb	small,sp,3,+x	;18 0a 8e 22
	movb	small,sp,5,-y	;18 0a 8e 6b
	movb	small,sp,5,sp	;18 0a 8e 85
	movb	small,sp,ext	;18 0d 8es00r00
	movb	small,x,3,+x	;18 0a 0e 22
	movb	small,x,5,-y	;18 0a 0e 6b
	movb	small,x,5,sp	;18 0a 0e 85
	movb	small,x,ext	;18 0d 0es00r00
	movb	small,y,3,+x	;18 0a 4e 22
	movb	small,y,5,-y	;18 0a 4e 6b
	movb	small,y,5,sp	;18 0a 4e 85
	movb	small,y,ext	;18 0d 4es00r00

movw:	movw	#immed,3,+x	;18 00 22s00r00
	movw	#immed,5,-y	;18 00 6bs00r00
	movw	#immed,5,sp	;18 00 85s00r00
	movw	#immed,ext	;18 03s00r00s00r00
	movw	1,+sp,3,+x	;18 02 a0 22
	movw	1,+sp,5,-y	;18 02 a0 6b
	movw	1,+sp,5,sp	;18 02 a0 85
	movw	1,+sp,ext	;18 05 a0s00r00
	movw	1,+x,3,+x	;18 02 20 22
	movw	1,+x,5,-y	;18 02 20 6b
	movw	1,+x,5,sp	;18 02 20 85
	movw	1,+x,ext	;18 05 20s00r00
	movw	1,+y,3,+x	;18 02 60 22
	movw	1,+y,5,-y	;18 02 60 6b
	movw	1,+y,5,sp	;18 02 60 85
	movw	1,+y,ext	;18 05 60s00r00
	movw	3,+x,1,+sp 	;18 02 22 a0
	movw	3,+x,1,+x 	;18 02 22 20
	movw	3,+x,1,+y 	;18 02 22 60
	movw	3,+x,8,+sp 	;18 02 22 a7
	movw	3,+x,8,+x 	;18 02 22 27
	movw	3,+x,8,+y 	;18 02 22 67
;noofst	movw	3,+x,0,pc 	;18 02 22 c0
	movw	3,+x,0,pc 	;18 02 22 df
	movw	3,+x,0,sp 	;18 02 22 80
	movw	3,+x,0,x 	;18 02 22 00
	movw	3,+x,0,y 	;18 02 22 40
	movw	3,+x,1,-sp 	;18 02 22 af
	movw	3,+x,1,-x 	;18 02 22 2f
	movw	3,+x,1,-y 	;18 02 22 6f
	movw	3,+x,8,-sp 	;18 02 22 a8
	movw	3,+x,8,-x 	;18 02 22 28
	movw	3,+x,8,-y 	;18 02 22 68
	movw	3,+x,-1,sp 	;18 02 22 9f
	movw	3,+x,-1,x 	;18 02 22 1f
	movw	3,+x,-1,y 	;18 02 22 5f
	movw	3,+x,-16,sp 	;18 02 22 90
	movw	3,+x,-16,x 	;18 02 22 10
	movw	3,+x,-16,y 	;18 02 22 50
;noofst	movw	3,+x,-small,pc 	;18 02 22 d2
	movw	3,+x,-small,pc 	;18 02 22 d1
	movw	3,+x,-small,sp 	;18 02 22 92
	movw	3,+x,-small,x 	;18 02 22 12
	movw	3,+x,-small,y 	;18 02 22 52
;noofst	movw	3,+x,0,pc 	;18 02 22 c0
	movw	3,+x,0,pc 	;18 02 22 df
	movw	3,+x,0,sp 	;18 02 22 80
	movw	3,+x,0,x 	;18 02 22 00
	movw	3,+x,0,y 	;18 02 22 40
	movw	3,+x,1,sp+ 	;18 02 22 b0
	movw	3,+x,1,x+ 	;18 02 22 30
	movw	3,+x,1,y+ 	;18 02 22 70
	movw	3,+x,1,sp 	;18 02 22 81
	movw	3,+x,1,x 	;18 02 22 01
	movw	3,+x,1,y 	;18 02 22 41
	movw	3,+x,1,sp- 	;18 02 22 bf
	movw	3,+x,1,x- 	;18 02 22 3f
	movw	3,+x,1,y- 	;18 02 22 7f
	movw	3,+x,8,sp+ 	;18 02 22 b7
	movw	3,+x,8,x+ 	;18 02 22 37
	movw	3,+x,8,y+ 	;18 02 22 77
	movw	3,+x,8,sp- 	;18 02 22 b8
	movw	3,+x,8,x- 	;18 02 22 38
	movw	3,+x,8,y- 	;18 02 22 78
	movw	3,+x,a,sp 	;18 02 22 f4
	movw	3,+x,a,x 	;18 02 22 e4
	movw	3,+x,a,y 	;18 02 22 ec
	movw	3,+x,b,sp 	;18 02 22 f5
	movw	3,+x,b,x 	;18 02 22 e5
	movw	3,+x,b,y 	;18 02 22 ed
	movw	3,+x,d,sp 	;18 02 22 f6
	movw	3,+x,d,x 	;18 02 22 e6
	movw	3,+x,d,y 	;18 02 22 ee
	movw	3,+x,ext 	;18 05 22s00r00
;noofst	movw	3,+x,small,pc 	;18 02 22 ce
	movw	3,+x,small,pc 	;18 02 22 cd
	movw	3,+x,small,sp 	;18 02 22 8e
	movw	3,+x,small,x 	;18 02 22 0e
	movw	3,+x,small,y 	;18 02 22 4e
	movw	8,+sp,3,+x	;18 02 a7 22
	movw	8,+sp,5,-y	;18 02 a7 6b
	movw	8,+sp,5,sp	;18 02 a7 85
	movw	8,+sp,ext	;18 05 a7s00r00
	movw	8,+x,3,+x	;18 02 27 22
	movw	8,+x,5,-y	;18 02 27 6b
	movw	8,+x,5,sp	;18 02 27 85
	movw	8,+x,ext	;18 05 27s00r00
	movw	8,+y,3,+x	;18 02 67 22
	movw	8,+y,5,-y	;18 02 67 6b
	movw	8,+y,5,sp	;18 02 67 85
	movw	8,+y,ext	;18 05 67s00r00
;noofst	movw	,pc,3,+x	;18 02 c0 22
	movw	,pc,3,+x	;18 02 c1 22
;noofst	movw	,pc,5,-y	;18 02 c0 6b
	movw	,pc,5,-y	;18 02 c1 6b
;noofst	movw	,pc,5,sp	;18 02 c0 85
	movw	,pc,5,sp	;18 02 c1 85
;noofst	movw	,pc,ext		;18 05 c0s00r00
	movw	,pc,ext		;18 05 c2s00r00
	movw	,sp,3,+x	;18 02 80 22
	movw	,sp,5,-y	;18 02 80 6b
	movw	,sp,5,sp	;18 02 80 85
	movw	,sp,ext		;18 05 80s00r00
	movw	,x,3,+x		;18 02 00 22
	movw	,x,5,-y		;18 02 00 6b
	movw	,x,5,sp		;18 02 00 85
	movw	,x,ext		;18 05 00s00r00
	movw	,y,3,+x		;18 02 40 22
	movw	,y,5,-y		;18 02 40 6b
	movw	,y,5,sp		;18 02 40 85
	movw	,y,ext		;18 05 40s00r00
	movw	1,-sp,3,+x	;18 02 af 22
	movw	1,-sp,5,-y	;18 02 af 6b
	movw	1,-sp,5,sp	;18 02 af 85
	movw	1,-sp,ext	;18 05 afs00r00
	movw	1,-x,3,+x	;18 02 2f 22
	movw	1,-x,5,-y	;18 02 2f 6b
	movw	1,-x,5,sp	;18 02 2f 85
	movw	1,-x,ext	;18 05 2fs00r00
	movw	1,-y,3,+x	;18 02 6f 22
	movw	1,-y,5,-y	;18 02 6f 6b
	movw	1,-y,5,sp	;18 02 6f 85
	movw	1,-y,ext	;18 05 6fs00r00
	movw	8,-sp,3,+x	;18 02 a8 22
	movw	8,-sp,5,-y	;18 02 a8 6b
	movw	8,-sp,5,sp	;18 02 a8 85
	movw	8,-sp,ext	;18 05 a8s00r00
	movw	8,-x,3,+x	;18 02 28 22
	movw	8,-x,5,-y	;18 02 28 6b
	movw	8,-x,5,sp	;18 02 28 85
	movw	8,-x,ext	;18 05 28s00r00
	movw	8,-y,3,+x	;18 02 68 22
	movw	8,-y,5,-y	;18 02 68 6b
	movw	8,-y,5,sp	;18 02 68 85
	movw	8,-y,ext	;18 05 68s00r00
	movw	-1,sp,3,+x	;18 02 9f 22
	movw	-1,sp,5,-y	;18 02 9f 6b
	movw	-1,sp,5,sp	;18 02 9f 85
	movw	-1,sp,ext	;18 05 9fs00r00
	movw	-1,x,3,+x	;18 02 1f 22
	movw	-1,x,5,-y	;18 02 1f 6b
	movw	-1,x,5,sp	;18 02 1f 85
	movw	-1,x,ext	;18 05 1fs00r00
	movw	-1,y,3,+x	;18 02 5f 22
	movw	-1,y,5,-y	;18 02 5f 6b
	movw	-1,y,5,sp	;18 02 5f 85
	movw	-1,y,ext	;18 05 5fs00r00
	movw	-16,sp,3,+x	;18 02 90 22
	movw	-16,sp,5,-y	;18 02 90 6b
	movw	-16,sp,5,sp	;18 02 90 85
	movw	-16,sp,ext	;18 05 90s00r00
	movw	-16,x,3,+x	;18 02 10 22
	movw	-16,x,5,-y	;18 02 10 6b
	movw	-16,x,5,sp	;18 02 10 85
	movw	-16,x,ext	;18 05 10s00r00
	movw	-16,y,3,+x	;18 02 50 22
	movw	-16,y,5,-y	;18 02 50 6b
	movw	-16,y,5,sp	;18 02 50 85
	movw	-16,y,ext	;18 05 50s00r00
;noofst	movw	-small,pc,3,+x	;18 02 d2 22
	movw	-small,pc,3,+x	;18 02 d3 22
;noofst	movw	-small,pc,5,-y	;18 02 d2 6b
	movw	-small,pc,5,-y	;18 02 d3 6b
;noofst	movw	-small,pc,5,sp	;18 02 d2 85
	movw	-small,pc,5,sp	;18 02 d3 85
;noofst	movw	-small,pc,ext	;18 05 d2s00r00
	movw	-small,pc,ext	;18 05 d4s00r00
	movw	-small,sp,3,+x	;18 02 92 22
	movw	-small,sp,5,-y	;18 02 92 6b
	movw	-small,sp,5,sp	;18 02 92 85
	movw	-small,sp,ext	;18 05 92s00r00
	movw	-small,x,3,+x	;18 02 12 22
	movw	-small,x,5,-y	;18 02 12 6b
	movw	-small,x,5,sp	;18 02 12 85
	movw	-small,x,ext	;18 05 12s00r00
	movw	-small,y,3,+x	;18 02 52 22
	movw	-small,y,5,-y	;18 02 52 6b
	movw	-small,y,5,sp	;18 02 52 85
	movw	-small,y,ext	;18 05 52s00r00
;noofst	movw	0,pc,3,+x	;18 02 c0 22
	movw	0,pc,3,+x	;18 02 c1 22
;noofst	movw	0,pc,5,-y	;18 02 c0 6b
	movw	0,pc,5,-y	;18 02 c1 6b
;noofst	movw	0,pc,5,sp	;18 02 c0 85
	movw	0,pc,5,sp	;18 02 c1 85
;noofst	movw	0,pc,ext	;18 05 c0s00r00
	movw	0,pc,ext	;18 05 c2s00r00
	movw	0,sp,3,+x	;18 02 80 22
	movw	0,sp,5,-y	;18 02 80 6b
	movw	0,sp,5,sp	;18 02 80 85
	movw	0,sp,ext	;18 05 80s00r00
	movw	0,x,3,+x	;18 02 00 22
	movw	0,x,5,-y	;18 02 00 6b
	movw	0,x,5,sp	;18 02 00 85
	movw	0,x,ext		;18 05 00s00r00
	movw	0,y,3,+x	;18 02 40 22
	movw	0,y,5,-y	;18 02 40 6b
	movw	0,y,5,sp	;18 02 40 85
	movw	0,y,ext		;18 05 40s00r00
	movw	1,sp+,3,+x	;18 02 b0 22
	movw	1,sp+,5,-y	;18 02 b0 6b
	movw	1,sp+,5,sp	;18 02 b0 85
	movw	1,sp+,ext	;18 05 b0s00r00
	movw	1,x+,3,+x	;18 02 30 22
	movw	1,x+,5,-y	;18 02 30 6b
	movw	1,x+,5,sp	;18 02 30 85
	movw	1,x+,ext	;18 05 30s00r00
	movw	1,y+,3,+x	;18 02 70 22
	movw	1,y+,5,-y	;18 02 70 6b
	movw	1,y+,5,sp	;18 02 70 85
	movw	1,y+,ext	;18 05 70s00r00
	movw	1,sp,3,+x	;18 02 81 22
	movw	1,sp,5,-y	;18 02 81 6b
	movw	1,sp,5,sp	;18 02 81 85
	movw	1,sp,ext	;18 05 81s00r00
	movw	1,x,3,+x	;18 02 01 22
	movw	1,x,5,-y	;18 02 01 6b
	movw	1,x,5,sp	;18 02 01 85
	movw	1,x,ext		;18 05 01s00r00
	movw	1,y,3,+x	;18 02 41 22
	movw	1,y,5,-y 	;18 02 41 6b
	movw	1,y,5,sp	;18 02 41 85
	movw	1,y,ext		;18 05 41s00r00
	movw	1,sp-,3,+x	;18 02 bf 22
	movw	1,sp-,5,-y	;18 02 bf 6b
	movw	1,sp-,5,sp	;18 02 bf 85
	movw	1,sp-,ext	;18 05 bfs00r00
	movw	1,x-,3,+x	;18 02 3f 22
	movw	1,x-,5,-y	;18 02 3f 6b
	movw	1,x-,5,sp	;18 02 3f 85
	movw	1,x-,ext	;18 05 3fs00r00
	movw	1,y-,3,+x	;18 02 7f 22
	movw	1,y-,5,-y	;18 02 7f 6b
	movw	1,y-,5,sp	;18 02 7f 85
	movw	1,y-,ext	;18 05 7fs00r00
	movw	5,-y,1,+sp 	;18 02 6b a0
	movw	5,-y,1,+x 	;18 02 6b 20
	movw	5,-y,1,+y 	;18 02 6b 60
	movw	5,-y,8,+sp 	;18 02 6b a7
	movw	5,-y,8,+x 	;18 02 6b 27
	movw	5,-y,8,+y 	;18 02 6b 67
;noofst	movw	5,-y,0,pc 	;18 02 6b c0
	movw	5,-y,0,pc 	;18 02 6b df
	movw	5,-y,0,sp 	;18 02 6b 80
	movw	5,-y,0,x 	;18 02 6b 00
	movw	5,-y,0,y 	;18 02 6b 40
	movw	5,-y,1,-sp 	;18 02 6b af
	movw	5,-y,1,-x 	;18 02 6b 2f
	movw	5,-y,1,-y 	;18 02 6b 6f
	movw	5,-y,8,-sp 	;18 02 6b a8
	movw	5,-y,8,-x 	;18 02 6b 28
	movw	5,-y,8,-y 	;18 02 6b 68
	movw	5,-y,-1,sp 	;18 02 6b 9f
	movw	5,-y,-1,x 	;18 02 6b 1f
	movw	5,-y,-1,y 	;18 02 6b 5f
	movw	5,-y,-16,sp 	;18 02 6b 90
	movw	5,-y,-16,x 	;18 02 6b 10
	movw	5,-y,-16,y 	;18 02 6b 50
;noofst	movw	5,-y,-small,pc 	;18 02 6b d2
	movw	5,-y,-small,pc 	;18 02 6b d1
	movw	5,-y,-small,sp 	;18 02 6b 92
	movw	5,-y,-small,x 	;18 02 6b 12
	movw	5,-y,-small,y 	;18 02 6b 52
;noofst	movw	5,-y,0,pc 	;18 02 6b c0
	movw	5,-y,0,pc 	;18 02 6b df
	movw	5,-y,0,sp 	;18 02 6b 80
	movw	5,-y,0,x 	;18 02 6b 00
	movw	5,-y,0,y 	;18 02 6b 40
	movw	5,-y,1,sp+ 	;18 02 6b b0
	movw	5,-y,1,x+ 	;18 02 6b 30
	movw	5,-y,1,y+ 	;18 02 6b 70
	movw	5,-y,1,sp 	;18 02 6b 81
	movw	5,-y,1,x 	;18 02 6b 01
	movw	5,-y,1,y 	;18 02 6b 41
	movw	5,-y,1,sp- 	;18 02 6b bf
	movw	5,-y,1,x- 	;18 02 6b 3f
	movw	5,-y,1,y- 	;18 02 6b 7f
	movw	5,-y,15,sp 	;18 02 6b 8f
	movw	5,-y,15,x 	;18 02 6b 0f
	movw	5,-y,15,y 	;18 02 6b 4f
	movw	5,-y,8,sp+ 	;18 02 6b b7
	movw	5,-y,8,x+ 	;18 02 6b 37
	movw	5,-y,8,y+ 	;18 02 6b 77
	movw	5,-y,8,sp- 	;18 02 6b b8
	movw	5,-y,8,x- 	;18 02 6b 38
	movw	5,-y,8,y- 	;18 02 6b 78
	movw	5,-y,a,sp 	;18 02 6b f4
	movw	5,-y,a,x 	;18 02 6b e4
	movw	5,-y,a,y 	;18 02 6b ec
	movw	5,-y,b,sp 	;18 02 6b f5
	movw	5,-y,b,x 	;18 02 6b e5
	movw	5,-y,b,y 	;18 02 6b ed
	movw	5,-y,d,sp 	;18 02 6b f6
	movw	5,-y,d,x 	;18 02 6b e6
	movw	5,-y,d,y 	;18 02 6b ee
	movw	5,-y,ext 	;18 05 6bs00r00
;noofst	movw	5,-y,small,pc 	;18 02 6b ce
	movw	5,-y,small,pc 	;18 02 6b cd
	movw	5,-y,small,sp 	;18 02 6b 8e
	movw	5,-y,small,x 	;18 02 6b 0e
	movw	5,-y,small,y 	;18 02 6b 4e
	movw	15,sp,3,+x	;18 02 8f 22
	movw	15,sp,5,-y	;18 02 8f 6b
	movw	15,sp,5,sp	;18 02 8f 85
	movw	15,sp,ext	;18 05 8fs00r00
	movw	15,x,3,+x	;18 02 0f 22
	movw	15,x,5,-y	;18 02 0f 6b
	movw	15,x,5,sp	;18 02 0f 85
	movw	15,x,ext	;18 05 0fs00r00
	movw	15,y,3,+x	;18 02 4f 22
	movw	15,y,5,-y	;18 02 4f 6b
	movw	15,y,5,sp	;18 02 4f 85
	movw	15,y,ext	;18 05 4fs00r00
	movw	5,sp,1,+sp 	;18 02 85 a0
	movw	5,sp,1,+x 	;18 02 85 20
	movw	5,sp,1,+y 	;18 02 85 60
	movw	5,sp,8,+sp 	;18 02 85 a7
	movw	5,sp,8,+x 	;18 02 85 27
	movw	5,sp,8,+y 	;18 02 85 67
;noofst	movw	5,sp,0,pc 	;18 02 85 c0
	movw	5,sp,0,pc 	;18 02 85 df
	movw	5,sp,0,sp 	;18 02 85 80
	movw	5,sp,0,x 	;18 02 85 00
	movw	5,sp,0,y 	;18 02 85 40
	movw	5,sp,1,-sp 	;18 02 85 af
	movw	5,sp,1,-x 	;18 02 85 2f
	movw	5,sp,1,-y 	;18 02 85 6f
	movw	5,sp,8,-sp 	;18 02 85 a8
	movw	5,sp,8,-x 	;18 02 85 28
	movw	5,sp,8,-y 	;18 02 85 68
	movw	5,sp,-1,sp 	;18 02 85 9f
	movw	5,sp,-1,x 	;18 02 85 1f
	movw	5,sp,-1,y 	;18 02 85 5f
	movw	5,sp,-16,sp 	;18 02 85 90
	movw	5,sp,-16,x 	;18 02 85 10
	movw	5,sp,-16,y 	;18 02 85 50
;noofst	movw	5,sp,-small,pc 	;18 02 85 d2
	movw	5,sp,-small,pc 	;18 02 85 d1
	movw	5,sp,-small,sp 	;18 02 85 92
	movw	5,sp,-small,x 	;18 02 85 12
	movw	5,sp,-small,y 	;18 02 85 52
;noofst	movw	5,sp,0,pc 	;18 02 85 c0
	movw	5,sp,0,pc 	;18 02 85 df
	movw	5,sp,0,sp 	;18 02 85 80
	movw	5,sp,0,x 	;18 02 85 00
	movw	5,sp,0,y 	;18 02 85 40
	movw	5,sp,1,sp+ 	;18 02 85 b0
	movw	5,sp,1,x+ 	;18 02 85 30
	movw	5,sp,1,y+ 	;18 02 85 70
	movw	5,sp,1,sp 	;18 02 85 81
	movw	5,sp,1,x 	;18 02 85 01
	movw	5,sp,1,y 	;18 02 85 41
	movw	5,sp,1,sp- 	;18 02 85 bf
	movw	5,sp,1,x- 	;18 02 85 3f
	movw	5,sp,1,y- 	;18 02 85 7f
	movw	5,sp,8,sp+ 	;18 02 85 b7
	movw	5,sp,8,x+ 	;18 02 85 37
	movw	5,sp,8,y+ 	;18 02 85 77
	movw	5,sp,8,sp- 	;18 02 85 b8
	movw	5,sp,8,x- 	;18 02 85 38
	movw	5,sp,8,y- 	;18 02 85 78
	movw	5,sp,a,sp 	;18 02 85 f4
	movw	5,sp,a,x 	;18 02 85 e4
	movw	5,sp,a,y 	;18 02 85 ec
	movw	5,sp,b,sp 	;18 02 85 f5
	movw	5,sp,b,x 	;18 02 85 e5
	movw	5,sp,b,y 	;18 02 85 ed
	movw	5,sp,d,sp 	;18 02 85 f6
	movw	5,sp,d,x 	;18 02 85 e6
	movw	5,sp,d,y 	;18 02 85 ee
	movw	5,sp,ext 	;18 05 85s00r00
;noofst	movw	5,sp,small,pc 	;18 02 85 ce
	movw	5,sp,small,pc 	;18 02 85 cd
	movw	5,sp,small,sp 	;18 02 85 8e
	movw	5,sp,small,x 	;18 02 85 0e
	movw	5,sp,small,y 	;18 02 85 4e
	movw	8,sp+,3,+x	;18 02 b7 22
	movw	8,sp+,5,-y	;18 02 b7 6b
	movw	8,sp+,5,sp	;18 02 b7 85
	movw	8,sp+,ext	;18 05 b7s00r00
	movw	8,x+,3,+x	;18 02 37 22
	movw	8,x+,5,-y	;18 02 37 6b
	movw	8,x+,5,sp	;18 02 37 85
	movw	8,x+,ext	;18 05 37s00r00
	movw	8,y+,3,+x	;18 02 77 22
	movw	8,y+,5,-y	;18 02 77 6b
	movw	8,y+,5,sp	;18 02 77 85
	movw	8,y+,ext	;18 05 77s00r00
	movw	8,sp-,3,+x	;18 02 b8 22
	movw	8,sp-,5,-y	;18 02 b8 6b
	movw	8,sp-,5,sp	;18 02 b8 85
	movw	8,sp-,ext	;18 05 b8s00r00
	movw	8,x-,3,+x	;18 02 38 22
	movw	8,x-,5,-y	;18 02 38 6b
	movw	8,x-,5,sp	;18 02 38 85
	movw	8,x-,ext	;18 05 38s00r00
	movw	8,y-,3,+x	;18 02 78 22
	movw	8,y-,5,-y	;18 02 78 6b
	movw	8,y-,5,sp	;18 02 78 85
	movw	8,y-,ext	;18 05 78s00r00
	movw	a,sp,3,+x	;18 02 f4 22
	movw	a,sp,5,-y	;18 02 f4 6b
	movw	a,sp,5,sp	;18 02 f4 85
	movw	a,sp,ext	;18 05 f4s00r00
	movw	a,x,3,+x	;18 02 e4 22
	movw	a,x,5,-y	;18 02 e4 6b
	movw	a,x,5,sp	;18 02 e4 85
	movw	a,x,ext		;18 05 e4s00r00
	movw	a,y,3,+x	;18 02 ec 22
	movw	a,y,5,-y	;18 02 ec 6b
	movw	a,y,5,sp	;18 02 ec 85
	movw	a,y,ext		;18 05 ecs00r00
	movw	b,sp,3,+x	;18 02 f5 22
	movw	b,sp,5,-y	;18 02 f5 6b
	movw	b,sp,5,sp	;18 02 f5 85
	movw	b,sp,ext	;18 05 f5s00r00
	movw	b,x,3,+x	;18 02 e5 22
	movw	b,x,5,-y	;18 02 e5 6b
	movw	b,x,5,sp	;18 02 e5 85
	movw	b,x,ext		;18 05 e5s00r00
	movw	b,y,3,+x	;18 02 ed 22
	movw	b,y,5,-y	;18 02 ed 6b
	movw	b,y,5,sp	;18 02 ed 85
	movw	b,y,ext		;18 05 eds00r00
	movw	d,sp,3,+x	;18 02 f6 22
	movw	d,sp,5,-y	;18 02 f6 6b
	movw	d,sp,5,sp	;18 02 f6 85
	movw	d,sp,ext	;18 05 f6s00r00
	movw	d,x,3,+x	;18 02 e6 22
	movw	d,x,5,-y	;18 02 e6 6b
	movw	d,x,5,sp	;18 02 e6 85
	movw	d,x,ext		;18 05 e6s00r00
	movw	d,y,3,+x	;18 02 ee 22
	movw	d,y,5,-y	;18 02 ee 6b
	movw	d,y,5,sp	;18 02 ee 85
	movw	d,y,ext 	;18 05 ees00r00
	movw	ext,1,+sp 	;18 01 a0s00r00
	movw	ext,1,+x 	;18 01 20s00r00
	movw	ext,1,+y 	;18 01 60s00r00
	movw	ext,8,+sp 	;18 01 a7s00r00
	movw	ext,8,+x 	;18 01 27s00r00
	movw	ext,8,+y 	;18 01 67s00r00
;noofst	movw	ext,0,pc 	;18 01 c0s00r00
	movw	ext,0,pc 	;18 01 des00r00
	movw	ext,0,sp 	;18 01 80s00r00
	movw	ext,0,x 	;18 01 00s00r00
	movw	ext,0,y 	;18 01 40s00r00
	movw	ext,1,-sp 	;18 01 afs00r00
	movw	ext,1,-x 	;18 01 2fs00r00
	movw	ext,1,-y 	;18 01 6fs00r00
	movw	ext,8,-sp 	;18 01 a8s00r00
	movw	ext,8,-x 	;18 01 28s00r00
	movw	ext,8,-y 	;18 01 68s00r00
	movw	ext,-1,sp 	;18 01 9fs00r00
	movw	ext,-1,x 	;18 01 1fs00r00
	movw	ext,-1,y 	;18 01 5fs00r00
	movw	ext,-16,sp 	;18 01 90s00r00
	movw	ext,-16,x 	;18 01 10s00r00
	movw	ext,-16,y 	;18 01 50s00r00
;noofst	movw	ext,-small,pc 	;18 01 d2s00r00
	movw	ext,-small,pc 	;18 01 d0s00r00
	movw	ext,-small,sp 	;18 01 92s00r00
	movw	ext,-small,x 	;18 01 12s00r00
	movw	ext,-small,y 	;18 01 52s00r00
;noofst	movw	ext,0,pc 	;18 01 c0s00r00
	movw	ext,0,pc 	;18 01 des00r00
	movw	ext,0,sp 	;18 01 80s00r00
	movw	ext,0,x 	;18 01 00s00r00
	movw	ext,0,y 	;18 01 40s00r00
	movw	ext,1,sp+ 	;18 01 b0s00r00
	movw	ext,1,x+ 	;18 01 30s00r00
	movw	ext,1,y+ 	;18 01 70s00r00
	movw	ext,1,sp 	;18 01 81s00r00
	movw	ext,1,x 	;18 01 01s00r00
	movw	ext,1,y 	;18 01 41s00r00
	movw	ext,1,sp- 	;18 01 bfs00r00
	movw	ext,1,x- 	;18 01 3fs00r00
	movw	ext,1,y- 	;18 01 7fs00r00
	movw	ext,8,sp+ 	;18 01 b7s00r00
	movw	ext,8,x+ 	;18 01 37s00r00
	movw	ext,8,y+ 	;18 01 77s00r00
	movw	ext,8,sp- 	;18 01 b8s00r00
	movw	ext,8,x- 	;18 01 38s00r00
	movw	ext,8,y- 	;18 01 78s00r00
	movw	ext,a,sp 	;18 01 f4s00r00
	movw	ext,a,x 	;18 01 e4s00r00
	movw	ext,a,y 	;18 01 ecs00r00
	movw	ext,b,sp 	;18 01 f5s00r00
	movw	ext,b,x 	;18 01 e5s00r00
	movw	ext,b,y 	;18 01 eds00r00
	movw	ext,d,sp 	;18 01 f6s00r00
	movw	ext,d,x 	;18 01 e6s00r00
	movw	ext,d,y 	;18 01 ees00r00
	movw	ext,ext		;18 04s00r00s00r00
;noofst	movw	ext,small,pc 	;18 01 ces00r00
	movw	ext,small,pc 	;18 01 ccs00r00
	movw	ext,small,sp 	;18 01 8es00r00
	movw	ext,small,x 	;18 01 0es00r00
	movw	ext,small,y 	;18 01 4es00r00
;noofst	movw	small,pc,3,+x	;18 02 ce 22
	movw	small,pc,3,+x	;18 02 cf 22
;noofst	movw	small,pc,5,-y	;18 02 ce 6b
	movw	small,pc,5,-y	;18 02 cf 6b
;noofst	movw	small,pc,5,sp	;18 02 ce 85
	movw	small,pc,5,sp	;18 02 cf 85
;noofst	movw	small,pc,ext	;18 05 ces00r00
;a	movw	small,pc,ext	;18 05 d0s00r00
	movw	small,sp,3,+x	;18 02 8e 22
	movw	small,sp,5,-y	;18 02 8e 6b
	movw	small,sp,5,sp	;18 02 8e 85
	movw	small,sp,ext	;18 05 8es00r00
	movw	small,x,3,+x	;18 02 0e 22
	movw	small,x,5,-y	;18 02 0e 6b
	movw	small,x,5,sp	;18 02 0e 85
	movw	small,x,ext	;18 05 0es00r00
	movw	small,y,3,+x	;18 02 4e 22
	movw	small,y,5,-y	;18 02 4e 6b
	movw	small,y,5,sp	;18 02 4e 85
	movw	small,y,ext	;18 05 4es00r00
	movb	1,x+,1,y- 	;18 0a 30 7f
	movb	0,x,0,x 	;18 0a 00 00

end:

