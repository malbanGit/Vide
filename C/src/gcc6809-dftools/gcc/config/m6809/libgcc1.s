#if 0
;
; libgcc routines for m6809
;   Copyright (C) 2006 Free Software Foundation, Inc.
;
; This file is part of GCC.
;
; GCC is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 3, or (at your option)
; any later version.
;
; GCC is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with GCC; see the file COPYING3.  If not see
; <http://www.gnu.org/licenses/>.
;
; As a special exception, if you link this library with other files,
; some of which are compiled with GCC, to produce an executable,
; this library does not by itself cause the resulting executable
; to be covered by the GNU General Public License.
; This exception does not however invalidate any other reasons why
; the executable file might be covered by the GNU General Public License.
;
#endif

	.module	libgcc1.s

#ifdef __PIC__
#define JUMP lbra
#define CALL lbsr
#else
#define JUMP jmp
#define CALL jsr
#endif
#define SIGFPE JUMP _abort


#if defined(L_ashlhi3) || defined(L_ashrhi3) || defined(L_lshrhi3)
	; Shift functions
	; On input, D is value to be shifted, and X has shift count.
	; Result is also in D.
#endif






#ifdef L_ashlhi3
	.area	.text
	.globl	_ashlhi3
_ashlhi3:
	pshs	x
1$:
	leax	-1,x
	cmpx	#-1
	beq	2$
	aslb
	rola
	bra	1$
2$:
	puls	x,pc
#endif


#ifdef L_ashrhi3
	.area	.text
	.globl	_ashrhi3
_ashrhi3:
	pshs	x
1$:
	leax	-1,x
	cmpx	#-1
	beq	2$
	asra
	rorb
	bra	1$
2$:
	puls	x,pc
#endif


#ifdef L_lshrhi3
	.area	.text
	.globl	_lshrhi3
_lshrhi3:
	pshs	x
1$:
	leax	-1,x
	cmpx	#-1
	beq	2$
	lsra
	rorb
	bra	1$
2$:
	puls	x,pc
#endif


#ifdef L_ashlsi3_one
	.area	.text
	.globl	_ashlsi3_one
_ashlsi3_one:
	asl	3,x
	rol	2,x
	rol	1,x
	rol	,x
	rts
#endif


#ifdef L_ashlsi3
	.area	.text
	.globl	_ashlsi3
	; X points to the SImode (source/dest)
	; B is the count
_ashlsi3:
	pshs	u
	cmpb	#16
	blt	try8
	subb	#16
	; Shift by 16
	ldu	2,x
	stu	,x
try8:
	cmpb	#8
	blt	try_rest
	subb	#8
	; Shift by 8
try_rest:
	tstb
	beq	done
do_rest:
	; Shift by 1
	asl	3,x
	rol	2,x
	rol	1,x
	rol	,x
	decb
	bne	do_rest
done:
	puls	u,pc
#endif


#ifdef L_ashrsi3_one
	.area	.text
	.globl	_ashlsi3_one
_ashrsi3_one:
	asr	,x
	ror	1,x
	ror	2,x
	ror	3,x
	rts
#endif


#ifdef L_lshrsi3_one
	.area	.text
	.globl	_lshrsi3_one
_lshrsi3_one:
	lsr	,x
	ror	1,x
	ror	2,x
	ror	3,x
	rts
#endif


#ifdef L_clzsi2
	.area	.text
	.globl	___clzhi2
	; Input: X = 16-bit unsigned integer
	; Output: X = number of leading zeros
	; This function destroys the value in D.
___clzhi2:
	pshs	x
	; Find the offset of the leftmost '1' bit in
	; the left half of the word.
	;
	; Bits are numbered in the table with 1 meaning the
	; LSB and 8 meaning the MSB.
	;
	; If nonzero, then clz is 8-a.
	tfr	x,d
	ldx	#___clz_tab
	tfr	a,b
	clra
	ldb	d,x
	bne	upper_bit_set
lower_bit_set:
	; If the upper byte is zero, then check the lower
	; half of the word.  Return 16-a.
	puls	d
	clra
	ldb	d,x
	negb
	addb	#16
	bra	done
upper_bit_set:
	negb
	addb	#8
	puls	x
done:
	tfr	d,x
	puls	pc
#endif


#ifdef L_clzdi2
	.area	.text
	.globl	___clzsi2
	; Input: 32-bit unsigned integer is on the stack, just
	; above the return address
	; Output: X = number of leading zeros
___clzsi2:
	; Check the upper 16-bit word
	; If it is not zero, then return clzhi2(X).
	; A branch can be used instead of a call since no
	; postprocessing is needed.  Use long branch form
	; though since functions may not be near each other.
	ldx	2,s
	lbne	___clzhi2
	ldx	4,s
	CALL	___clzhi2
	leax	16,x
	rts
#endif


#ifdef L_ctzsi2
	.area	.text
	.globl	___ctzhi2
	; Input: X = 16-bit unsigned integer
	; Output: X = number of trailing zeros
	; F(x) = 15 - clzhi2(X & -x)
	; This function destroys the value in D.
___ctzhi2:
	tfr	x,d
	coma
	comb
	addd	#1
	pshs	a
	pshs	b
	tfr	x,d
	andb	,s+
	anda	,s+
	tfr	d,x
	CALL	___clzhi2
	tfr	x,d
	subd	#16
	coma
	comb
	tfr	d,x
	rts
#endif


#ifdef L_ctzdi2
	.area	.text
	.globl	___ctzsi2
	; Input: 32-bit unsigned integer is on the stack, just
	; above the return address
	; Output: X = number of leading zeros
___ctzsi2:
	; Check the lower 16-bit word
	; If it is not zero, then return ctzhi2(X).
	; A branch can be used instead of a call since no
	; postprocessing is needed.  Use long branch form
	; though since functions may not be near each other.
	ldx	4,s
	lbne	___ctzhi2
	ldx	2,s
	CALL	___ctzhi2
	leax	16,x
	rts
#endif


#ifdef L_mulhi3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___mulhi3 - signed/unsigned multiply
;;; Called by GCC to implement 16x16 multiplication
;;; Arguments: Two 16-bit values, one in stack, one in X.
;;; Result: 16-bit result in X
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.area	.text
	.globl	_mulhi3
_mulhi3:
	pshs	x
	lda	5,s   ; left msb * right lsb * 256
	ldb	,s
	mul
	tfr	b,a
	clrb
	tfr	d,x
	ldb	1,s   ; left lsb * right msb * 256
	lda	4,s
	mul
	tfr	b,a
	clrb
	leax	d,x
	ldb	1,s   ; left lsb * right lsb
	lda	5,s
	mul
	leax	d,x
	puls	d,pc  ; kill D to remove initial push
#endif


#ifdef L_divhi3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___divhi3 - signed division
;;; Arguments: Dividend in X, divisor on the stack
;;; Returns result in X.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.area	.text
	.globl	_divhi3
_divhi3:
	ldd	2,s
	bne	do_div		; check dividend
	SIGFPE
do_div:
	pshs	x
	CALL	_seuclid
	puls	x,pc
#endif


#ifdef L_modhi3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___modhi3 - signed modulo
;;; Arguments: Dividend in X, divisor on the stack
;;; Returns result in X.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.area	.text
	.globl	_modhi3
_modhi3:
	ldd	2,s
	bne	do_mod		; check dividend
	SIGFPE
do_mod:
	pshs	x
	CALL	_seuclid
	leas	2,s
	tfr	d,x
	rts
#endif


#ifdef L_udivhi3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___udivhi3 - unsigned division
;;; Arguments: Dividend in X, divisor on the stack
;;; Returns result in X.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.area	.text
	.globl	_udivhi3
_udivhi3:
	ldd	2,s
	bne	do_udiv		; check dividend
	SIGFPE
do_udiv:
	pshs	x
	CALL	_euclid
	puls	x,pc
#endif


#ifdef L_umodhi3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___umodhi3 - unsigned modulo
;;; Arguments: Dividend in X, divisor on the stack
;;; Returns result in X.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.area	.text
	.globl	_umodhi3
_umodhi3:
	ldd	2,s
	bne	do_umod		; check dividend
	SIGFPE
do_umod:
	pshs	x
	CALL	_euclid
	leas	2,s
	tfr	d,x
	rts
#endif


#ifdef L_euclid
;	unsigned euclidean division
;	calling: (left / right)
;		push left
;		ldd right
;		jsr _euclid
;	quotient on the stack (left)
;	modulus in d
	.area	.text
	.globl	_euclid
left	=	5
right	=	1		; word
count	=	0		; byte
carry	=	1		; alias
_euclid:
	leas	-3,s		; 2 local variables
	clr	count,s		; prescale divisor
	inc	count,s
	tsta
presc:
	bmi	presc_done
	inc	count,s
	aslb
	rola
	bra	presc
presc_done:
	std	right,s
	ldd	left,s
	clr	left,s		; quotient = 0
	clr	left+1,s
mod1:
	subd	right,s		; check subtract
	bcc	mod2
	addd	right,s
	andcc	#~carry
	bra	mod3
mod2:
	orcc	#carry
mod3:
	rol	left+1,s	; roll in carry
	rol	left,s
	lsr	right,s
	ror	right+1,s
	dec	count,s
	bne	mod1
	leas	3,s
	rts
#endif


#ifdef L_seuclid
;	signed euclidean division
;	calling: (left / right)
;		push left
;		ldd right
;		jsr _seuclid
;	quotient on the stack (left)
;	modulus in d
	.area	.text
	.globl	_seuclid
left	=	6
right	=	2
quo_sgn	=	1
mod_sgn	=	0
_seuclid:
	leas	-4,s		; 3 local variables
	std	right,s
	clr	mod_sgn,s
	clr	quo_sgn,s
	ldd	left,s
	bge	mod_abs
	inc	mod_sgn,s	; sign(mod) = sign(left)
	inc	quo_sgn,s
	bsr	negd		; abs(left) -> D
mod_abs:
	pshs	b,a		; push abs(left)
	ldd	right+2,s	; all references shifted by 2
	bge	quot_abs
	dec	quo_sgn+2,s	; sign(quot) = sign(left) XOR sign(right)
	bsr	negd		; abs(right) -> D
quot_abs:
	CALL	_euclid		; call (unsigned) euclidean division
	std	right+2,s
	puls	a,b		; quot -> D
	tst	quo_sgn,s	; all references no longer shifted
	beq	quot_done
	bsr	negd
quot_done:
	std	left,s		; quot -> left
	ldd	right,s
	tst	mod_sgn,s
	beq	mod_done
	bsr	negd
mod_done:
	leas	4,s		; destroy stack frame
	rts
negd:				; self-explanatory !
	nega
	negb
	sbca	#0
	rts
#endif


#ifdef L_m0
	.area	.direct
	.globl	m0,m1,m2,m3
m0:	.blkb	1
m1:	.blkb	1
m2:	.blkb	1
m3:	.blkb	1
#endif


#ifdef L_m4
	.area	.direct
	.globl	m4,m5,m6,m7
m4:	.blkb	1
m5:	.blkb	1
m6:	.blkb	1
m7:	.blkb	1
#endif


#ifdef L_im0
	.area	.direct
	.globl	im0,im1,im2,im3
im0:	.blkb	1
im1:	.blkb	1
im2:	.blkb	1
im3:	.blkb	1
#endif


#ifdef L_im4
	.area	.direct
	.globl	im4,im5,im6,im7
im4:	.blkb	1
im5:	.blkb	1
im6:	.blkb	1
im7:	.blkb	1
#endif


#ifdef L_fm0
	.area	.direct
	.globl	fm0,fm1,fm2,fm3
fm0:	.blkb	1
fm1:	.blkb	1
fm2:	.blkb	1
fm3:	.blkb	1
#endif


#ifdef L_fm4
	.area	.direct
	.globl	fm4,fm5,fm6,fm7
fm4:	.blkb	1
fm5:	.blkb	1
fm6:	.blkb	1
fm7:	.blkb	1
#endif


