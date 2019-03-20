	.sbttl	Jump Range Tests

	; This code verifies the assembler and linker
	; code / error generation.
	;
	; To test the assembler code generation define 'tasm':
	;
	;	asscmp -gloxff tasm tscmpe
	;	asxscn tasm.lst
	;
	; To test the linker code generation define 'tlnk':
	;
	;	asscmp -gloxff tlnk tscmpe
	;	aslink -u tlnk
	;	asxscn -i tlnk
	;

	;a error:
	xpal	1		; 30
	;a error:
	xpah	2(p0)		; 34
	;a error
	xppc	@3(p0)		; 3C

	;a error:
	jmp	#3	        ; 90 FF

	;a error:
	jmp	.-128	        ; 90 7F
	;a error:
	jmp	.-127		; 90 80

	jmp	.-126		; 90 81
	jmp	.-1		; 90 FE
	jmp	.		; 90 FF
	jmp	.+1		; 90 00
	jmp	.+2		; 90 01
	jmp	.+3		; 90 02
	jmp	.+127		; 90 7E
	jmp	.+128		; 90 7F

	;a error:
	jmp	.+129		; 90 80

	.area	Code1	(rel,con)

jt:	jmp	.+5		; 90 04

	.ifdef	tasm
	; check assembler code generation
	jmp	1$		; 90p03
	.endif

	.ifdef	tlnk
	; check linker code generation
	jmp	1$		; 90 04
	.endif


	.area	Code2	(rel,con)

	.byte	0
	.byte	1
	.byte	2
1$:	.byte	3

	; *****-----*****-----*****-----*****

	.area	M128	(rel,con)

m128:	.blkb	0d128

	.area	CoM128	(rel,con)

	.ifdef	tasm
	; check assembler code generation
	jmp	m128		; 90p00
	.endif

	.ifdef	tlnk
	; check linker code generation - ASlink Error
	jmp	m128		; 90 7F
	.endif

	; *****-----*****-----*****-----*****

	.area	M127	(rel,con)

m127:	.blkb	0d127

	.area	CoM127	(rel,con)

	.ifdef	tasm
	; check assembler code generation
	jmp	m127		; 90p00
	.endif

	.ifdef	tlnk
	; check linker code generation
	; The Linker allows the special offset of -128 !!!
	; The instruction uses the extension register rather than the offset value !!!
	jmp	m127		; 90 80
	.endif

	; *****-----*****-----*****-----*****

	.area	CoP128	(rel,con)

	.ifdef	tasm
	; check assembler code generation
	jmp	p128		; 90p7E
	.endif

	.ifdef	tlnk
	; check linker code generation
	jmp	p128		; 90 7F
	.endif

	.area	P128	(rel,con)

	.blkb	0d126	
p128:

	; *****-----*****-----*****-----*****

	.area	CoP129	(rel,con)

	.ifdef	tasm
	; check assembler code generation
	jmp	p129		; 90p7F
	.endif

	.ifdef	tlnk
	; check linker code generation - ASlink Error
	jmp	p129		; 90 80
	.endif

	.area	P129

	.blkb	0d127
p129:

	; *****-----*****-----*****-----*****


