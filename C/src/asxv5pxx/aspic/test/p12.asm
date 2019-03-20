	.pic 	"P12C508"
	.pic12bit

	.include	"P12C508.DEF"

	bcf	STATUS,RP1
	bsf	STATUS,RP0	; select Bank 1
	clrf	TRISA		; make porta outputs
