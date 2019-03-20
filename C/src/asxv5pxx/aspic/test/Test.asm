	.pic 	"p16C923"
	.pic12bit

	.include	"p16c923.def"

	bcf	STATUS,RP1
	bsf	STATUS,RP0	; select Bank 1
	clrf	TRISA		; make porta outputs
