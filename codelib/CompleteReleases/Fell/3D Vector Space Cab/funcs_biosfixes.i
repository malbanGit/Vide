; Bugfixed BIOS routines
; Erm.. from a forum somewhere! Sorry..

;-----------------------------------------------------------------------;
;       F511    Random_3                                                ;
;       F517    Random                                                  ;
;                                                                       ;
; This routine generates a random 1-byte number, and places it in the   ;
; A register.  Random_3 runs through the random number generator        ;
; algorithm three times.  The random number seed is stored in the       ;
; three bytes pointed to by $C87B.                                      ;
;                                                                       ;
; EXIT: A-reg contains the generated random number                      ;
;                                                                       ;
;       All other registers are preserved.                              ;
;-----------------------------------------------------------------------;

FixedRandom_3:       
	pshs b,x
	ldb #$02
	bra LF51A
		
FixedRandom:         
	pshs b,x
	clrb
LF51A:	ldx #Vec_Seed_Ptr	; FIXED: Was ldx Vec_Seed_Ptr (see http://vectorgaming.proboards.com/thread/1329/random)
LF51D:  lda 1,x
	rola
	rola
	rola
	rola
	eora 2,x
	rora
	rol ,x
	rol 1,x
	rol 2,x
	decb
	bpl LF51D
	lda ,x
	puls b,x,pc