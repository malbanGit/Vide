
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___divhi3 - signed division
;;; Arguments: Dividend in X, divisor on the stack
;;; Returns result in X.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_divhi3:
	ldd	2,s
	bne	do_div_divhi3		; check dividend
  rts ; do nothing on div by 0
	;SIGFPE
do_div_divhi3:
	pshs	x
	bsr	_seuclid_divhi3
	puls	x,pc
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___udivhi3 - unsigned division
;;; Arguments: Dividend in X, divisor on the stack
;;; Returns result in X.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_udivhi3:
	ldd	2,s
	bne	do_udiv_udivhi3		; check dividend
  rts ; do nothing on div by 0
	;SIGFPE
do_udiv_udivhi3:
	pshs	x
	bsr	_euclid_divhi3
	puls	x,pc	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___modhi3 - signed modulo
;;; Arguments: Dividend in X, divisor on the stack
;;; Returns result in X.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
_modhi3:
	ldd	2,s
	bne	do_mod_modhi3		; check dividend
  rts ; do nothing on div by 0
	;SIGFPE
do_mod_modhi3:
	pshs	x
	bsr	_seuclid_divhi3
	leas	2,s
	tfr	d,x
	rts	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___umodhi3 - unsigned modulo
;;; Arguments: Dividend in X, divisor on the stack
;;; Returns result in X.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_umodhi3:
	ldd	2,s
	bne	do_umod_umodhi3		; check dividend
  rts ; do nothing on div by 0
	;SIGFPE
do_umod_umodhi3:
	pshs	x
	bsr	_euclid_divhi3
	leas	2,s
	tfr	d,x
	rts	
	
	
	
	
	
	
	
;	signed euclidean division
;	calling: (left / right)
;		push left
;		ldd right
;		jsr _seuclid
;	quotient on the stack (left)
;	modulus in d

s_left = 6
s_right = 2
s_quot_sign = 1
s_mod_sign = 0
	
_seuclid_divhi3:
	leas	-4,s		; 3 local variables
	std	s_right,s
	clr	s_mod_sign,s
	clr	s_quot_sign,s
	ldd	s_left,s
	bge	mod_abs_divhi3
	inc	s_mod_sign,s	; sign(mod) = sign(left)
	inc	s_quot_sign,s
	bsr	negd_divhi3		; abs(left) -> D
mod_abs_divhi3:
	pshs	b,a		; push abs(left)
	ldd	s_right+2,s	; all references shifted by 2
	bge	quot_abs_divhi3
	dec	s_quot_sign+2,s	; sign(quot) = sign(left) XOR sign(right)
	bsr	negd_divhi3		; abs(right) -> D
quot_abs_divhi3:
	bsr	_euclid_divhi3		; call (unsigned) euclidean division
	std	s_right+2,s
	puls	a,b		; quot -> D
	tst	s_quot_sign,s	; all references no longer shifted
	beq	quot_done_divhi3
	bsr	negd_divhi3
quot_done_divhi3:
	std	s_left,s		; quot -> left
	ldd	s_right,s
	tst	s_mod_sign,s
	beq	mod_done_divhi3
	bsr	negd_divhi3
mod_done_divhi3:
	leas	4,s		; destroy stack frame
	rts

negd_divhi3:				; self-explanatory !
	nega
	negb
	sbca	#0
	rts
	

;	unsigned euclidean division
;	calling: (left / right)
;		push left
;		ldd right
;		jsr _euclid
;	quotient on the stack (left)
;	modulus in d

e_left = 5
e_right = 1			; word
e_count = 0			; byte
e_CARRY = 1			; alias

_euclid_divhi3:
	leas	-3,s		; 2 local variables
	clr	e_count,s		; prescale divisor
	inc	e_count,s
	tsta
presc_divhi3:
	bmi	presc_done_divhi3
	inc	e_count,s
	aslb
	rola
	bra	presc_divhi3
presc_done_divhi3:
	std	e_right,s
	ldd	e_left,s
	clr	e_left,s		; quotient = 0
	clr	e_left+1,s
mod1_divhi3:
	subd	e_right,s		; check subtract
	bcc	mod2_divhi3
	addd	e_right,s
	andcc	#~e_CARRY
	bra	mod3_divhi3
mod2_divhi3:
	orcc	#e_CARRY
mod3_divhi3:
	rol	e_left+1,s	; roll in carry
	rol	e_left,s
	lsr	e_right,s
	ror	e_right+1,s
	dec	e_count,s
	bne	mod1_divhi3
	leas	3,s
	rts		