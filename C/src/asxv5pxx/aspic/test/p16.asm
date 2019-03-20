	.pic 	"P17C42"
	.pic16bit

	.include	"P17C42.DEF"

	bcf	STATUS,RP1
	bsf	STATUS,RP0	; select Bank 1
	clrf	TRISA		; make porta outputs
