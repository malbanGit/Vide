; Misc useful shiznazz
; By Fell^DSS, Ludum Dare 38 \p/
	
; *** SOMEONE ELSE'S BIN-TO-ASCII FUNCTION ***

UTILS_BIN2ASCII_SPACE equ ' '

	; in:
	; D = binary value
	; U = dest. number
	; out:
	; U = dest. number (kept)
	; A,B destroyed
	; X,Y kept
bin2ascii:
	; store regs
	pshs x, y

	; clear number
	ldx # $0000
	stx 0, u
	stx 1, u
	stx 3, u

	; convert
	ldx # tab
mainbo:
	lsra
	rorb
	bcc skip_calc

	tfr d, y
	ldb # 4
	; orcc c ; set carry - is set (see bcc above)
addit:
	lda b, u
	sbca b, x
	cmpa # 10
	blo no_overflow
	suba # 10
no_overflow:
	sta b, u
	decb
	bpl addit
	tfr y, d

skip_calc:
	leax 5, x
	; cmpx # tab+16*5 -- run over all 16 bit
	addd # $0000 ; (same as cmpd # $0000 but a dbe shorter and faster) -- run until no bits are left. i.e. 1-16 runs depending on the input
	bne mainbo

	; replace leading zeroes with space
	lda #UTILS_BIN2ASCII_SPACE
	clrb
b2a_1:
	tst b, u
	bne b2a_2
	sta b, u
	incb
	cmpb # 4
	bne b2a_1
b2a_2:

	; convert others to ascii
	lda b, u
	adda # '0'
	sta b, u
	incb
	cmpb # 5
	bne b2a_2

	; restore regs + do rts
	puls x, y, pc

tab:
	db -1, -1, -1,  -1, -2
	db -1, -1, -1,  -1, -3
	db -1, -1, -1,  -1, -5
	db -1, -1, -1,  -1, -9
	db -1, -1, -1,  -2, -7
	db -1, -1, -1,  -4, -3
	db -1, -1, -1,  -7, -5
	db -1, -1, -2,  -3, -9
	db -1, -1, -3,  -6, -7
	db -1, -1, -6,  -2, -3
	db -1, -2, -1,  -3, -5
	db -1, -3, -1,  -5, -9
	db -1, -5, -1, -10, -7
	db -1, -9, -2, -10, -3
	db -2, -7, -4,  -9, -5
	db -4, -3, -8,  -7, -9
