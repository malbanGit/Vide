	.pic 	"P16C923"
	.pic14bit

	.include	"P16C923.DEF"

	bcf	STATUS,RP1
	bsf	STATUS,RP0	; select Bank 1
	clrf	TRISA		; make porta outputs

	.setdmm		0x0080

	clrf	TRISA		; make porta outputs


