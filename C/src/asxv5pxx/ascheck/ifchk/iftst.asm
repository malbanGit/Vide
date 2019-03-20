	.title	if-else-endif Checks
	.list (me)

	.page
	.sbttl	Verify all if types

	.if	0		; 0
	 .error	1		; .if 0 failed
	.endif

	.if	1		; 1
	 .byte	0x00
	.endif

	.if	ne,0		; 0
	 .error	1		; .if ne,0 failed
	.endif

	.if	ne,1		; 1
	 .byte	0x01
	.endif

	.if	gt,0		; 0
	 .error	1		; .if gt,0 failed
	.endif

	.if	gt,1		; 1
	 .byte	0x02
	.endif

	.if	lt,0		; 0
	 .error	1		; .if lt,0 failed
	.endif

	.if	lt,-1		; 1
	 .byte	0x03
	.endif

	.if	ge,-1		; 0
	 .error	1		; .if ge,-1 failed
	.endif

	.if	ge,0		; 1
	 .byte	0x04
	.endif

	.if	le,1		; 0
	 .error	1		; .if le,1 failed
	.endif

	.if	le,0		; 1
	 .byte	0x05
	.endif

	.if	b,J		; 0
	 .error	1		; .if b,J failed
	.endif

	.if	b,		; 1
	 .byte	0x06
	.endif

	.if	nb		; 0
	 .error	1		; .if nb failed
	.endif

	.if	nb,J		; 1
	 .byte	0x07
	.endif

	.undefine	defsym
	.if	def,defsym	; 0
	 .error	1		; .if def,defsym failed
	.endif

	.define		defsym
	.if	def,defsym	; 1
	 .byte	0x08
	.endif

	.if	ndef,defsym	; 0
	 .error	1		; .if def,defsym failed
	.endif

	.undefine	defsym
	.if	ndef,defsym	; 1
	 .byte	0x09
	.endif

	.if	idn	A,B	; 0
	 .error	1		; .if iden A,B failed
	.endif

	.if	idn	D,D	; 1
	 .byte	0x0A
	.endif

	.if	dif	D,D	; 0
	 .error	1		; .if dif D,D failed
	.endif

	.if	dif	A,B	; 1
	 .byte	0x0B
	.endif


	.page
	.sbttl	Verify all alternate if types

	.if	0		; 0
	 .error	1		; .if 0 failed
	.endif

	.if	1		; 1
	 .byte	0x00
	.endif

	.ifne	0		; 0
	 .error	1		; .if ne,0 failed
	.endif

	.ifne	1		; 1
	 .byte	0x01
	.endif

	.ifgt	0		; 0
	 .error	1		; .if gt,0 failed
	.endif

	.ifgt	1		; 1
	 .byte	0x02
	.endif

	.iflt	0		; 0
	 .error	1		; .if lt,0 failed
	.endif

	.iflt	-1		; 1
	 .byte	0x03
	.endif

	.ifge	-1		; 0
	 .error	1		; .if ge,-1 failed
	.endif

	.ifge	0		; 1
	 .byte	0x04
	.endif

	.ifle	1		; 0
	 .error	1		; .if le,1 failed
	.endif

	.ifle	0		; 1
	 .byte	0x05
	.endif

	.ifb	J		; 0
	 .error	1		; .if b,J failed
	.endif

	.ifb			; 1
	 .byte	0x06
	.endif

	.ifnb			; 0
	 .error	1		; .if nb failed
	.endif

	.ifnb	J		; 1
	 .byte	0x07
	.endif

	.undefine	defsym
	.ifdef	defsym		; 0
	 .error	1		; .if def,defsym failed
	.endif

	.define		defsym
	.ifdef	defsym		; 1
	 .byte	0x08
	.endif

	.ifndef	defsym		; 0
	 .error	1		; .if def,defsym failed
	.endif

	.undefine	defsym
	.ifndef	defsym		; 1
	 .byte	0x09
	.endif

	.ifidn	A,B		; 0
	 .error	1		; .if iden A,B failed
	.endif

	.ifidn	D,D		; 1
	 .byte	0x0A
	.endif

	.ifdif	D,D		; 0
	 .error	1		; .if dif D,D failed
	.endif

	.ifdif	A,B		; 1
	 .byte	0x0B
	.endif


	.page
	.sbttl	Verify all iif types

	.iif	0	 .error	1		; .iif 0 failed
	.iif	1	 .byte	0x00

	.iif	ne,0	 .error	1		; .iif ne,0 failed
	.iif	ne,1	 .byte	0x01

	.iif	gt,0	 .error	1		; .iif gt,0 failed
	.iif	gt,1	 .byte	0x02

	.iif	lt,0	 .error	1		; .iif lt,0 failed
	.iif	lt,-1	 .byte	0x03

	.iif	ge,-1	 .error	1		; .iif ge,-1 failed
	.iif	ge,0	 .byte	0x04

	.iif	le,1	 .error	1		; .iif le,1 failed
	.iif	le,0	 .byte	0x05

	.iif	b,J	 .error	1		; .iif b,J failed
	.iif	b,^!!	 .byte	0x06

	.iif	nb,^!!	 .error	1		; .iif nb failed
	.iif	nb,J	 .byte	0x07

	.undefine	defsym
	.iif	def,defsym	 .error	1		; .iif def,defsym failed
	.define		defsym
	.iif	def,defsym	 .byte	0x08

	.iif	ndef,defsym	 .error	1		; .iif def,defsym failed
	.undefine	defsym
	.iif	ndef,defsym	 .byte	0x09

	.iif	idn	A,B	 .error	1		; .iif iden A,B failed
	.iif	idn	D,D	 .byte	0x0A

	.iif	dif	D,D	 .error	1		; .iif dif D,D failed
	.iif	dif	A,B	 .byte	0x0B


	.page
	.sbttl	Verify all alternate iif types

	.iif	0	 .error	1		; .iif 0 failed
	.iif	1	 .byte	0x00

	.iifne	0	 .error	1		; .iif ne,0 failed
	.iifne	1	 .byte	0x01

	.iifgt	0	 .error	1		; .iif gt,0 failed
	.iifgt	1	 .byte	0x02

	.iiflt	0	 .error	1		; .iif lt,0 failed
	.iiflt	-1	 .byte	0x03

	.iifge	-1	 .error	1		; .iif ge,-1 failed
	.iifge	0	 .byte	0x04

	.iifle	1	 .error	1		; .iif le,1 failed
	.iifle	0	 .byte	0x05

	.iifb	J	 .error	1		; .iif b,J failed
	.iifb	^!!	 .byte	0x06

	.iifnb	^!!	 .error	1		; .iif nb failed
	.iifnb	J	 .byte	0x07

	.undefine	defsym
	.iifdef		defsym	 .error	1		; .iif def,defsym failed
	.define		defsym
	.iifdef		defsym	 .byte	0x08

	.iifndef	defsym	 .error	1		; .iif ndef,defsym failed
	.undefine	defsym
	.iifndef	defsym	 .byte	0x09

	.iifidn	A,B	 .error	1		; .iif iden A,B failed
	.iifidn	D,D	 .byte	0x0A

	.iifdif	D,D	 .error	1		; .iif dif D,D failed
	.iifdif	A,B	 .byte	0x0B


	.page
	.sbttl	Verify blank and non-blank conditionals

	.if	b		; 1
	 .byte 0x01
	.endif

	.if	b,		; 1
	 .byte	0x02
	.endif

	.if	b,,		; 1
	 .byte	0x03
	.endif

	.if	b,J		; 0
	 .byte	0x04
	.endif

	.if	b J		; 0
	 .byte	0x04
	.endif

	.if	nb		; 0
	 .byte	0x05
	.endif

	.if	nb,		; 0
	 .byte	0x06
	.endif

	.if	nb,,		; 0
	 .byte	0x07
	.endif

	.if	nb,J		; 1
	 .byte	0x08
	.endif

	.if	nb J		; 1
	 .byte	0x08
	.endif

	.page
	.sbttl	Verify if-else-endif

	sym = 1			; True value

	.if	sym		;Condition = TRUE
	  .byte		0x01	; 01
	.else			;Condition = FALSE
	  .error	0x01	; .else failed
	.endif

	sym = 0			; False value

	.if	sym		;Condition = FALSE
	  .error	0x02	; .if failed
	.else			;Condition = TRUE
	  .byte		0x02	; 02
	.endif


	.page
	.sbttl	Verify if-else-endif with multiple else, if == TRUE

	sym = 1			; True value

	.if	sym		;Condition = TRUE
	  .byte		0x03	; 03
	.else			;Condition = FALSE
	  .error	0x03	; .else failed
	.else			;Condition = TRUE
	  .byte		0x04	; 04
	.endif

	.if	sym		;Condition = TRUE
	  .byte		0x05	; 05
	.else			;Condition = FALSE
	  .error	0x05	; .else failed
	.else			;Condition = TRUE
	  .byte		0x06	; 06
	.else			;Condition = FALSE
	  .error	0x06	; .else failed
	.endif

	.if	sym		;Condition = TRUE
	  .byte		0x07	; 07
	.else			;Condition = FALSE
	  .error	0x07	; .else failed
	.else			;Condition = TRUE
	  .byte		0x08	; 08
	.else			;Condition = FALSE
	  .error	0x08	; .else failed
	.else			;Condition = TRUE
	  .byte		0x09	; 09
	.endif


	.page
	.sbttl	Verify if-else-endif with multiple else, if == FALSE

	sym = 0			; False value

	.if	sym		;Condition = FALSE
	  .error	0x09	; .if failed
	.else			;Condition = TRUE
	  .byte		0x0A	; 0A
	.else			;Condition = FALSE
	  .error	0x0A	; .else failed
	.endif

	.if	sym		;Condition = FALSE
	  .error	0x0B	; .if failed
	.else			;Condition = TRUE
	  .byte		0x0B	; 0B
	.else			;Condition = FALSE
	  .error	0x0C	; .else failed
	.else			;Condition = TRUE
	  .byte		0x0C	; 0C
	.endif

	.if	sym		;Condition = FALSE
	  .error	0x0D	; .if failed
	.else			;Condition = TRUE
	  .byte		0x0D	; 0D
	.else			;Condition = FALSE
	  .error	0x0E	; .else failed
	.else			;Condition = TRUE
	  .byte		0x0E	; 0E
	.else			;Condition = FALSE
	  .error	0x0F	; .else failed
	.endif


	.page
	.sbttl	Verify iff-ift-iftf

	sym = 1			; True value

	.if	sym		;Condition = TRUE
	  .byte		0x10	; 10
	  .ift			;IF Condition == TRUE
	    .byte 	0x11	; 11
	  .iff			;IF Condition == FALSE
	    .error	0x11	; .iff failed
	  .iftf			;IF Condition == TRUE or FALSE
	    .byte	0x12	; 12
	.else			;Condition = FALSE
	  .error	0x12	; .else failed
	  .ift			;IF Condition == TRUE
	    .error	0x13	; .ift failed
	  .iff			;IF Condition == FALSE
	    .byte	0x13	; 13
	  .iftf			;IF Condition == TRUE or FALSE
	    .byte	0x14	; 14
	.endif

	sym = 0			; False value

	.if	sym		;Condition = FALSE
	  .error	0x14	; .if failed
	  .ift			;IF Condition == TRUE
	    .error 	0x15	; .ift filed
	  .iff			;IF Condition == FALSE
	    .byte	0x15	; 15
	  .iftf			;IF Condition == TRUE or FALSE
	    .byte	0x16	; 16
	.else			;Condition = TRUE
	  .ift			;IF Condition == TRUE
	    .byte	0x17	; 17
	  .iff			;IF Condition == FALSE
	    .error	0x17	; .iff failed
	  .iftf			;IF Condition == TRUE or FALSE
	    .byte	0x18
	.endif


	.page
	.sbttl	Verify nested iff-ift-iftf

	sym = 1			; True value

	.if	sym		;Condition = TRUE
	  .byte		0x20	; 20
	  .ift			;IF Condition == TRUE
	    .ifeq	1       ; 0
	       .error	0x20	; .ifeq failed
	    .endif
	    .byte 	0x21	; 21
	  .iff			;IF Condition == FALSE
	    .ifne	0
	       .error	0x22	; .ifne failed
	    .endif
	    .error	0x23	; .iff failed
	  .iftf			;IF Condition == TRUE or FALSE
	    .byte	0x22	; 22
	.else			;Condition = FALSE
	  .error	0x24	; .else failed
	  .ift			;IF Condition == TRUE
	    .ifeq	1
	       .error	0x25	; .ifeq failed
	    .endif
	    .error	0x26	; .ift failed
	  .iff			;IF Condition == FALSE
	    .ifne	0       ; 0
	       .error	0x27	; .ifne failed
	    .endif
	    .byte	0x23	; 23
	  .iftf			;IF Condition == TRUE or FALSE
	    .byte	0x24	; 24
	.endif

	sym = 0			; False value

	.if	sym		;Condition = FALSE
	  .error	0x28	; .if failed
	  .ift			;IF Condition == TRUE
	    .ifeq	1
	       .error	0x29	; .ifeq failed
	    .endif
	  .iff			;IF Condition == FALSE
	    .ifne	0       ; 0
	       .error	0x2A	; .ifeq failed
	    .endif
	    .byte	0x25	; 25
	  .iftf			;IF Condition == TRUE or FALSE
	    .byte	0x26	; 26
	.else			;Condition = TRUE
	  .ift			;IF Condition == TRUE
	    .ifeq	1       ; 0
	       .error	0x2B	; .ifeq failed
	    .endif
	    .byte	0x27	; 27
	  .iff			;IF Condition == FALSE
	    .ifne	0
	       .error	0x2C	; .ifeq failed
	    .endif
	    .error	0x2D	; .iff failed
	  .iftf			;IF Condition == TRUE or FALSE
	    .byte	0x28    ; 28
	.endif


	.page
	.sbttl	Verify iiff-iift-iiftf

	sym = 1				; True value

	.if	sym			;Condition = TRUE
	  .byte		0x10		; 10
	  .iift	    .byte 	0x11	; 11
	  .iiff	    .error	0x11	; .iiff failed
	  .iiftf    .byte	0x12	; 12
	.else				;Condition = FALSE
	  .error	0x12		; .else failed
	  .iift	    .error	0x13	; .iift failed
	  .iiff	    .byte	0x13	; 13
	  .iiftf    .byte	0x14	; 14
	.endif

	sym = 0				; False value

	.if	sym			;Condition = FALSE
	  .error	0x14		; .if failed
	  .iift	    .error 	0x15	; .iift fAiled
	  .iiff	    .byte	0x15	; 15
	  .iiftf    .byte	0x16	; 16
	.else				;Condition = TRUE
	  .iift	    .byte	0x17	; 17
	  .iiff	    .error	0x17	; .ifff failed
	  .iiftf    .byte	0x18	; 18
	.endif


	.page
	.sbttl	Verify iff t,f,tf

	sym = 1				; True value

	.if	sym			;Condition = TRUE
	  .byte		0x10		; 10
	  .iif	t	.byte 	0x11	; 11
	  .iif	f	.error	0x11	; .iif f failed
	  .iif	tf	.byte	0x12	; 12
	.else				;Condition = FALSE
	  .error	0x12		; .else failed
	  .iif	t	.error	0x13	; .iif t failed
	  .iif	f	.byte	0x13	; 13
	  .iif	tf	.byte	0x14	; 14
	.endif

	sym = 0				; False value

	.if	sym			;Condition = FALSE
	  .error	0x14		; .if failed
	  .iif	t	.error 	0x15	; .iif t failed
	  .iif	f	.byte	0x15	; 15
	  .iif	tf	.byte	0x16	; 16
	.else				;Condition = TRUE
	  .iif	t	.byte	0x17	; 17
	  .iif	f	.error	0x17	; .iif f failed
	  .iif	tf	.byte	0x18	; 18
	.endif


	.page
	.sbttl	Verify TRUE/FALSE States in Nested if-else-endif

	; 0000

	.if	eq,0	; 1
	 .if	eq,0	; 1
	  .if	eq,0	; 1
	  .else		; 0
	  .endif
	 .else		; 0
	  .if	eq,0
	  .else
	  .endif
	 .endif
	.else		; 0
	 .if	eq,0
	  .if	eq,0
	  .else
	  .endif
	 .else
	  .if	eq,0
	  .else
	  .endif
	 .endif
	.endif

	; 0001

	.if	eq,0	; 1
	 .if	eq,0	; 1
	  .if	eq,0	; 1
	  .else		; 0
	  .endif
	 .else		; 0
	  .if	eq,1
	  .else
	  .endif
	 .endif
	.else		; 0
	 .if	eq,0
	  .if	eq,0
	  .else
	  .endif
	 .else
	  .if	eq,1
	  .else
	  .endif
	 .endif
	.endif

	; 0010

	.if	eq,0	; 1
	 .if	eq,0	; 1
	  .if	eq,1	; 0
	  .else		; 1
	  .endif
	 .else		; 0
	  .if	eq,0
	  .else
	  .endif
	 .endif
	.else		; 0
	 .if	eq,0
	  .if	eq,1
	  .else
	  .endif
	 .else
	  .if	eq,0
	  .else
	  .endif
	 .endif
	.endif

	; 0011

	.if	eq,0	; 1
	 .if	eq,0	; 1
	  .if	eq,1	; 0
	  .else		; 1
	  .endif
	 .else		; 0
	  .if	eq,1
	  .else
	  .endif
	 .endif
	.else		; 0
	 .if	eq,0
	  .if	eq,1
	  .else
	  .endif
	 .else
	  .if	eq,1
	  .else
	  .endif
	 .endif
	.endif

	; 0100

	.if	eq,0	; 1
	 .if	eq,1	; 0
	  .if	eq,0
	  .else
	  .endif
	 .else		; 1
	  .if	eq,0	; 1
	  .else		; 0
	  .endif
	 .endif
	.else		; 0
	 .if	eq,1
	  .if	eq,0
	  .else
	  .endif
	 .else
	  .if	eq,0
	  .else
	  .endif
	 .endif
	.endif

	; 0101

	.if	eq,0	; 1
	 .if	eq,1	; 0
	  .if	eq,0
	  .else
	  .endif
	 .else		; 1
	  .if	eq,1	; 0
	  .else		; 1
	  .endif
	 .endif
	.else		; 0
	 .if	eq,1
	  .if	eq,0
	  .else
	  .endif
	 .else
	  .if	eq,1
	  .else
	  .endif
	 .endif
	.endif

	; 0110

	.if	eq,0	; 1
	 .if	eq,1	; 0
	  .if	eq,1
	  .else
	  .endif
	 .else		; 1
	  .if	eq,0	; 1
	  .else		; 0
	  .endif
	 .endif
	.else		; 0
	 .if	eq,1
	  .if	eq,1
	  .else
	  .endif
	 .else
	  .if	eq,0
	  .else
	  .endif
	 .endif
	.endif

	; 0111

	.if	eq,0	; 1
	 .if	eq,1	; 0
	  .if	eq,1
	  .else
	  .endif
	 .else		; 1
	  .if	eq,1	; 0
	  .else		; 1
	  .endif
	 .endif
	.else		; 0
	 .if	eq,1
	  .if	eq,1
	  .else
	  .endif
	 .else
	  .if	eq,1
	  .else
	  .endif
	 .endif
	.endif

	; 1000

	.if	eq,1	; 0
	 .if	eq,0
	  .if	eq,0
	  .else
	  .endif
	 .else
	  .if	eq,0
	  .else
	  .endif
	 .endif
	.else		; 1
	 .if	eq,0	; 1
	  .if	eq,0	; 1
	  .else		; 0
	  .endif
	 .else		; 0
	  .if	eq,0
	  .else
	  .endif
	 .endif
	.endif

	; 1001

	.if	eq,1	; 0
	 .if	eq,0
	  .if	eq,0
	  .else
	  .endif
	 .else
	  .if	eq,1
	  .else
	  .endif
	 .endif
	.else		; 1
	 .if	eq,0	; 1
	  .if	eq,0	; 1
	  .else		; 0
	  .endif
	 .else		; 0
	  .if	eq,1
	  .else
	  .endif
	 .endif
	.endif

	; 1010

	.if	eq,1	; 0
	 .if	eq,0
	  .if	eq,1
	  .else
	  .endif
	 .else
	  .if	eq,0
	  .else
	  .endif
	 .endif
	.else		; 1
	 .if	eq,0	; 1
	  .if	eq,1	; 0
	  .else		; 1
	  .endif
	 .else		; 0
	  .if	eq,0
	  .else
	  .endif
	 .endif
	.endif

	; 1011

	.if	eq,1	; 0
	 .if	eq,0
	  .if	eq,1
	  .else
	  .endif
	 .else
	  .if	eq,1
	  .else
	  .endif
	 .endif
	.else		; 1
	 .if	eq,0	; 1
	  .if	eq,1	; 0
	  .else		; 1
	  .endif
	 .else		; 0
	  .if	eq,1
	  .else
	  .endif
	 .endif
	.endif

	; 1100

	.if	eq,1	; 0
	 .if	eq,1
	  .if	eq,0
	  .else
	  .endif
	 .else
	  .if	eq,0
	  .else
	  .endif
	 .endif
	.else		; 1
	 .if	eq,1	; 0
	  .if	eq,0
	  .else
	  .endif
	 .else		; 1
	  .if	eq,0	; 1
	  .else		; 0
	  .endif
	 .endif
	.endif

	; 1101

	.if	eq,1	; 0
	 .if	eq,1
	  .if	eq,0
	  .else
	  .endif
	 .else
	  .if	eq,1
	  .else
	  .endif
	 .endif
	.else		; 1
	 .if	eq,1	; 0
	  .if	eq,0
	  .else
	  .endif
	 .else		; 1
	  .if	eq,1	; 0
	  .else		; 1
	  .endif
	 .endif
	.endif

	; 1110

	.if	eq,1	; 0
	 .if	eq,1
	  .if	eq,1
	  .else
	  .endif
	 .else
	  .if	eq,0
	  .else
	  .endif
	 .endif
	.else		; 1
	 .if	eq,1	; 0
	  .if	eq,1
	  .else
	  .endif
	 .else		; 1
	  .if	eq,0	; 1
	  .else		; 0
	  .endif
	 .endif
	.endif

	; 1111

	.if	eq,1	; 0
	 .if	eq,1
	  .if	eq,1
	  .else
	  .endif
	 .else
	  .if	eq,1
	  .else
	  .endif
	 .endif
	.else		; 1
	 .if	eq,1	; 0
	  .if	eq,1
	  .else
	  .endif
	 .else		; 1
	  .if	eq,1	; 0
	  .else		; 1
	  .endif
	 .endif
	.endif



