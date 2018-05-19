;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___mulhi3 - signed/unsigned multiply
;;; Called by GCC to implement 16x16 multiplication
;;; Arguments: Two 16-bit values, one in stack, one in X.
;;; Result: 16-bit result in X
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_mulhi3:
	pshs	x
	lda   5,s   ; left msb * right lsb * 256
	ldb   ,s
	mul
	tfr   b,a
	clrb
	tfr   d,x
	ldb   1,s   ; left lsb * right msb * 256
	lda   4,s
	mul
	tfr   b,a
	clrb
	leax  d,x
	ldb   1,s   ; left lsb * right lsb
	lda   5,s
	mul
	leax  d,x
	puls	d,pc  ; kill D to remove initial push