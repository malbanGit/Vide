	.pic 	"P18C242"
	.pic20bit

	.include	"P18C242.DEF"

	bcf	STATUS,RP1
	bsf	STATUS,RP0	; select Bank 1
	clrf	TRISA		; make porta outputs
