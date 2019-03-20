	.title	ASM8C Addressing Mode Error Test

	exprs	=	0x01
	exprd	=	0x02

	.page
	.sbttl	S_MATH (add / adc / sub / sbb)

	add	a,a				;a
	add	a,f				;a
	add	a,x				;a
	add	a,sp				;a
	add	a,exprs				; 01 01
	add	a,[exprs]			; 02 01
	add	a,[x+exprs]			; 03 01
	add	a,[[exprs]++]			;a
	add	a,reg[exprs]			;a
	add	a,reg[x+exprs]			;a

	add	f,a				;a
	add	f,f				;a
	add	f,x				;a
	add	f,sp				;a
	add	f,exprs				;a
	add	f,[exprs]			;a
	add	f,[x+exprs]			;a
	add	f,[[exprs]++]			;a
	add	f,reg[exprs]			;a
	add	f,reg[x+exprs]			;a

	add	x,a				;a
	add	x,f				;a
	add	x,x				;a
	add	x,sp				;a
	add	x,exprs				;a
	add	x,[exprs]			;a
	add	x,[x+exprs]			;a
	add	x,[[exprs]++]			;a
	add	x,reg[exprs]			;a
	add	x,reg[x+exprs]			;a

	add	sp,a				;a
	add	sp,f				;a
	add	sp,x				;a
	add	sp,sp				;a
	add	sp,exprs			; 38 01
	add	sp,[exprs]			;a
	add	sp,[x+exprs]			;a
	add	sp,[[exprs]++]			;a
	add	sp,reg[exprs]			;a
	add	sp,reg[x+exprs]			;a

	add	exprd,a				;a
	add	exprd,f				;a
	add	exprd,x				;a
	add	exprd,sp			;a
	add	exprd,exprs			;a
	add	exprd,[exprs]			;a
	add	exprd,[x+exprs]			;a
	add	exprd,[[exprs]++]		;a
	add	exprd,reg[exprs]		;a
	add	exprd,reg[x+exprs]		;a

	add	[exprd],a			; 04 02
	add	[exprd],f			;a
	add	[exprd],x			;a
	add	[exprd],sp			;a
	add	[exprd],exprs			; 06 02 01
	add	[exprd],[exprs]			;a
	add	[exprd],[x+exprs]		;a
	add	[exprd],[[exprs]++]		;a
	add	[exprd],reg[exprs]		;a
	add	[exprd],reg[x+exprs]		;a

	add	[x+exprd],a			; 05 02
	add	[x+exprd],f			;a
	add	[x+exprd],x			;a
	add	[x+exprd],sp			;a
	add	[x+exprd],exprs			; 07 02 01
	add	[x+exprd],[exprs]		;a
	add	[x+exprd],[x+exprs]		;a
	add	[x+exprd],[[exprs]++]		;a
	add	[x+exprd],reg[exprs]		;a
	add	[x+exprd],reg[x+exprs]		;a

	add	[[exprd]++],a			;a
	add	[[exprd]++],f			;a
	add	[[exprd]++],x			;a
	add	[[exprd]++],sp			;a
	add	[[exprd]++],exprs		;a
	add	[[exprd]++],[exprs]		;a
	add	[[exprd]++],[x+exprs]		;a
	add	[[exprd]++],[[exprs]++]		;a
	add	[[exprd]++],reg[exprs]		;a
	add	[[exprd]++],reg[x+exprs]	;a

	add	reg[exprd],a			;a
	add	reg[exprd],f			;a
	add	reg[exprd],x			;a
	add	reg[exprd],sp			;a
	add	reg[exprd],exprs		;a
	add	reg[exprd],[exprs]		;a
	add	reg[exprd],[x+exprs]		;a
	add	reg[exprd],[[exprs]++]		;a
	add	reg[exprd],reg[exprs]		;a
	add	reg[exprd],reg[x+exprs]		;a

	add	reg[x+exprd],a			;a
	add	reg[x+exprd],f			;a
	add	reg[x+exprd],x			;a
	add	reg[x+exprd],sp			;a
	add	reg[x+exprd],exprs		;a
	add	reg[x+exprd],[exprs]		;a
	add	reg[x+exprd],[x+exprs]		;a
	add	reg[x+exprd],[[exprs]++]	;a
	add	reg[x+exprd],reg[exprs]		;a
	add	reg[x+exprd],reg[x+exprs]	;a


	.page
	.sbttl	S_PUSH (push / pop)

	push	a				; 08
	push	f				;a
	push	x				; 10
	push	sp				;a
	push	exprs				;a
	push	[exprs]				;a
	push	[x+exprs]			;a
	push	[[exprs]++]			;a
	push	reg[exprs]			;a
	push	reg[x+exprs]			;a


	.page
	.sbttl	S_LGC (and / or / xor)

	and	a,a				;a
	and	a,f				;a
	and	a,x				;a
	and	a,sp				;a
	and	a,exprs				; 21 01
	and	a,[exprs]			; 22 01
	and	a,[x+exprs]			; 23 01
	and	a,[[exprs]++]			;a
	and	a,reg[exprs]			;a
	and	a,reg[x+exprs]			;a

	and	f,a				;a
	and	f,f				;a
	and	f,x				;a
	and	f,sp				;a
	and	f,exprs				; 70 01
	and	f,[exprs]			;a
	and	f,[x+exprs]			;a
	and	f,[[exprs]++]			;a
	and	f,reg[exprs]			;a
	and	f,reg[x+exprs]			;a

	and	x,a				;a
	and	x,f				;a
	and	x,x				;a
	and	x,sp				;a
	and	x,exprs				;a
	and	x,[exprs]			;a
	and	x,[x+exprs]			;a
	and	x,[[exprs]++]			;a
	and	x,reg[exprs]			;a
	and	x,reg[x+exprs]			;a

	and	sp,a				;a
	and	sp,f				;a
	and	sp,x				;a
	and	sp,sp				;a
	and	sp,exprs			;a
	and	sp,[exprs]			;a
	and	sp,[x+exprs]			;a
	and	sp,[[exprs]++]			;a
	and	sp,reg[exprs]			;a
	and	sp,reg[x+exprs]			;a

	and	exprd,a				;a
	and	exprd,f				;a
	and	exprd,x				;a
	and	exprd,sp			;a
	and	exprd,exprs			;a
	and	exprd,[exprs]			;a
	and	exprd,[x+exprs]			;a
	and	exprd,[[exprs]++]		;a
	and	exprd,reg[exprs]		;a
	and	exprd,reg[x+exprs]		;a

	and	[exprd],a			; 24 02
	and	[exprd],f			;a
	and	[exprd],x			;a
	and	[exprd],sp			;a
	and	[exprd],exprs			; 26 02 01
	and	[exprd],[exprs]			;a
	and	[exprd],[x+exprs]		;a
	and	[exprd],[[exprs]++]		;a
	and	[exprd],reg[exprs]		;a
	and	[exprd],reg[x+exprs]		;a

	and	[x+exprd],a			; 25 02
	and	[x+exprd],f			;a
	and	[x+exprd],x			;a
	and	[x+exprd],sp			;a
	and	[x+exprd],exprs			; 27 02 01
	and	[x+exprd],[exprs]		;a
	and	[x+exprd],[x+exprs]		;a
	and	[x+exprd],[[exprs]++]		;a
	and	[x+exprd],reg[exprs]		;a
	and	[x+exprd],reg[x+exprs]		;a

	and	[[exprd]++],a			;a
	and	[[exprd]++],f			;a
	and	[[exprd]++],x			;a
	and	[[exprd]++],sp			;a
	and	[[exprd]++],exprs		;a
	and	[[exprd]++],[exprs]		;a
	and	[[exprd]++],[x+exprs]		;a
	and	[[exprd]++],[[exprs]++]		;a
	and	[[exprd]++],reg[exprs]		;a
	and	[[exprd]++],reg[x+exprs]	;a

	and	reg[exprd],a			;a
	and	reg[exprd],f			;a
	and	reg[exprd],x			;a
	and	reg[exprd],sp			;a
	and	reg[exprd],exprs		; 41 02 01
	and	reg[exprd],[exprs]		;a
	and	reg[exprd],[x+exprs]		;a
	and	reg[exprd],[[exprs]++]		;a
	and	reg[exprd],reg[exprs]		;a
	and	reg[exprd],reg[x+exprs]		;a

	and	reg[x+exprd],a			;a
	and	reg[x+exprd],f			;a
	and	reg[x+exprd],x			;a
	and	reg[x+exprd],sp			;a
	and	reg[x+exprd],exprs		; 42 02 01
	and	reg[x+exprd],[exprs]		;a
	and	reg[x+exprd],[x+exprs]		;a
	and	reg[x+exprd],[[exprs]++]	;a
	and	reg[x+exprd],reg[exprs]		;a
	and	reg[x+exprd],reg[x+exprs]	;a


	.page
	.sbttl	S_CMP (cmp)

	cmp	a,a				;a
	cmp	a,f				;a
	cmp	a,x				;a
	cmp	a,sp				;a
	cmp	a,exprs				; 39 01
	cmp	a,[exprs]			; 3A 01
	cmp	a,[x+exprs]			; 3B 01
	cmp	a,[[exprs]++]			;a
	cmp	a,reg[exprs]			;a
	cmp	a,reg[x+exprs]			;a

	cmp	f,a				;a
	cmp	f,f				;a
	cmp	f,x				;a
	cmp	f,sp				;a
	cmp	f,exprs				;a
	cmp	f,[exprs]			;a
	cmp	f,[x+exprs]			;a
	cmp	f,[[exprs]++]			;a
	cmp	f,reg[exprs]			;a
	cmp	f,reg[x+exprs]			;a

	cmp	x,a				;a
	cmp	x,f				;a
	cmp	x,x				;a
	cmp	x,sp				;a
	cmp	x,exprs				;a
	cmp	x,[exprs]			;a
	cmp	x,[x+exprs]			;a
	cmp	x,[[exprs]++]			;a
	cmp	x,reg[exprs]			;a
	cmp	x,reg[x+exprs]			;a

	cmp	sp,a				;a
	cmp	sp,f				;a
	cmp	sp,x				;a
	cmp	sp,sp				;a
	cmp	sp,exprs			;a
	cmp	sp,[exprs]			;a
	cmp	sp,[x+exprs]			;a
	cmp	sp,[[exprs]++]			;a
	cmp	sp,reg[exprs]			;a
	cmp	sp,reg[x+exprs]			;a

	cmp	exprd,a				;a
	cmp	exprd,f				;a
	cmp	exprd,x				;a
	cmp	exprd,sp			;a
	cmp	exprd,exprs			;a
	cmp	exprd,[exprs]			;a
	cmp	exprd,[x+exprs]			;a
	cmp	exprd,[[exprs]++]		;a
	cmp	exprd,reg[exprs]		;a
	cmp	exprd,reg[x+exprs]		;a

	cmp	[exprd],a			;a
	cmp	[exprd],f			;a
	cmp	[exprd],x			;a
	cmp	[exprd],sp			;a
	cmp	[exprd],exprs			; 3C 02 01
	cmp	[exprd],[exprs]			;a
	cmp	[exprd],[x+exprs]		;a
	cmp	[exprd],[[exprs]++]		;a
	cmp	[exprd],reg[exprs]		;a
	cmp	[exprd],reg[x+exprs]		;a

	cmp	[x+exprd],a			;a
	cmp	[x+exprd],f			;a
	cmp	[x+exprd],x			;a
	cmp	[x+exprd],sp			;a
	cmp	[x+exprd],exprs			; 3D 02 01
	cmp	[x+exprd],[exprs]		;a
	cmp	[x+exprd],[x+exprs]		;a
	cmp	[x+exprd],[[exprs]++]		;a
	cmp	[x+exprd],reg[exprs]		;a
	cmp	[x+exprd],reg[x+exprs]		;a

	cmp	[[exprd]++],a			;a
	cmp	[[exprd]++],f			;a
	cmp	[[exprd]++],x			;a
	cmp	[[exprd]++],sp			;a
	cmp	[[exprd]++],exprs		;a
	cmp	[[exprd]++],[exprs]		;a
	cmp	[[exprd]++],[x+exprs]		;a
	cmp	[[exprd]++],[[exprs]++]		;a
	cmp	[[exprd]++],reg[exprs]		;a
	cmp	[[exprd]++],reg[x+exprs]	;a

	cmp	reg[exprd],a			;a
	cmp	reg[exprd],f			;a
	cmp	reg[exprd],x			;a
	cmp	reg[exprd],sp			;a
	cmp	reg[exprd],exprs		;a
	cmp	reg[exprd],[exprs]		;a
	cmp	reg[exprd],[x+exprs]		;a
	cmp	reg[exprd],[[exprs]++]		;a
	cmp	reg[exprd],reg[exprs]		;a
	cmp	reg[exprd],reg[x+exprs]		;a

	cmp	reg[x+exprd],a			;a
	cmp	reg[x+exprd],f			;a
	cmp	reg[x+exprd],x			;a
	cmp	reg[x+exprd],sp			;a
	cmp	reg[x+exprd],exprs		;a
	cmp	reg[x+exprd],[exprs]		;a
	cmp	reg[x+exprd],[x+exprs]		;a
	cmp	reg[x+exprd],[[exprs]++]	;a
	cmp	reg[x+exprd],reg[exprs]		;a
	cmp	reg[x+exprd],reg[x+exprs]	;a


	.page
	.sbttl	S_MVI (mvi)

	mvi	a,a				;a
	mvi	a,f				;a
	mvi	a,x				;a
	mvi	a,sp				;a
	mvi	a,exprs				;a
	mvi	a,[exprs]			;a
	mvi	a,[x+exprs]			;a
	mvi	a,[[exprs]++]			; 3E 01
	mvi	a,reg[exprs]			;a
	mvi	a,reg[x+exprs]			;a

	mvi	f,a				;a
	mvi	f,f				;a
	mvi	f,x				;a
	mvi	f,sp				;a
	mvi	f,exprs				;a
	mvi	f,[exprs]			;a
	mvi	f,[x+exprs]			;a
	mvi	f,[[exprs]++]			;a
	mvi	f,reg[exprs]			;a
	mvi	f,reg[x+exprs]			;a

	mvi	x,a				;a
	mvi	x,f				;a
	mvi	x,x				;a
	mvi	x,sp				;a
	mvi	x,exprs				;a
	mvi	x,[exprs]			;a
	mvi	x,[x+exprs]			;a
	mvi	x,[[exprs]++]			;a
	mvi	x,reg[exprs]			;a
	mvi	x,reg[x+exprs]			;a

	mvi	sp,a				;a
	mvi	sp,f				;a
	mvi	sp,x				;a
	mvi	sp,sp				;a
	mvi	sp,exprs			;a
	mvi	sp,[exprs]			;a
	mvi	sp,[x+exprs]			;a
	mvi	sp,[[exprs]++]			;a
	mvi	sp,reg[exprs]			;a
	mvi	sp,reg[x+exprs]			;a

	mvi	exprd,a				;a
	mvi	exprd,f				;a
	mvi	exprd,x				;a
	mvi	exprd,sp			;a
	mvi	exprd,exprs			;a
	mvi	exprd,[exprs]			;a
	mvi	exprd,[x+exprs]			;a
	mvi	exprd,[[exprs]++]		;a
	mvi	exprd,reg[exprs]		;a
	mvi	exprd,reg[x+exprs]		;a

	mvi	[exprd],a			;a
	mvi	[exprd],f			;a
	mvi	[exprd],x			;a
	mvi	[exprd],sp			;a
	mvi	[exprd],exprs			;a
	mvi	[exprd],[exprs]			;a
	mvi	[exprd],[x+exprs]		;a
	mvi	[exprd],[[exprs]++]		;a
	mvi	[exprd],reg[exprs]		;a
	mvi	[exprd],reg[x+exprs]		;a

	mvi	[x+exprd],a			;a
	mvi	[x+exprd],f			;a
	mvi	[x+exprd],x			;a
	mvi	[x+exprd],sp			;a
	mvi	[x+exprd],exprs			;a
	mvi	[x+exprd],[exprs]		;a
	mvi	[x+exprd],[x+exprs]		;a
	mvi	[x+exprd],[[exprs]++]		;a
	mvi	[x+exprd],reg[exprs]		;a
	mvi	[x+exprd],reg[x+exprs]		;a

	mvi	[[exprd]++],a			; 3F 02
	mvi	[[exprd]++],f			;a
	mvi	[[exprd]++],x			;a
	mvi	[[exprd]++],sp			;a
	mvi	[[exprd]++],exprs		;a
	mvi	[[exprd]++],[exprs]		;a
	mvi	[[exprd]++],[x+exprs]		;a
	mvi	[[exprd]++],[[exprs]++]		;a
	mvi	[[exprd]++],reg[exprs]		;a
	mvi	[[exprd]++],reg[x+exprs]	;a

	mvi	reg[exprd],a			;a
	mvi	reg[exprd],f			;a
	mvi	reg[exprd],x			;a
	mvi	reg[exprd],sp			;a
	mvi	reg[exprd],exprs		;a
	mvi	reg[exprd],[exprs]		;a
	mvi	reg[exprd],[x+exprs]		;a
	mvi	reg[exprd],[[exprs]++]		;a
	mvi	reg[exprd],reg[exprs]		;a
	mvi	reg[exprd],reg[x+exprs]		;a

	mvi	reg[x+exprd],a			;a
	mvi	reg[x+exprd],f			;a
	mvi	reg[x+exprd],x			;a
	mvi	reg[x+exprd],sp			;a
	mvi	reg[x+exprd],exprs		;a
	mvi	reg[x+exprd],[exprs]		;a
	mvi	reg[x+exprd],[x+exprs]		;a
	mvi	reg[x+exprd],[[exprs]++]	;a
	mvi	reg[x+exprd],reg[exprs]		;a
	mvi	reg[x+exprd],reg[x+exprs]	;a


	.page
	.sbttl	S_TST (tst)

	tst	a,a				;a
	tst	a,f				;a
	tst	a,x				;a
	tst	a,sp				;a
	tst	a,exprs				;a
	tst	a,[exprs]			;a
	tst	a,[x+exprs]			;a
	tst	a,[[exprs]++]			;a
	tst	a,reg[exprs]			;a
	tst	a,reg[x+exprs]			;a

	tst	f,a				;a
	tst	f,f				;a
	tst	f,x				;a
	tst	f,sp				;a
	tst	f,exprs				;a
	tst	f,[exprs]			;a
	tst	f,[x+exprs]			;a
	tst	f,[[exprs]++]			;a
	tst	f,reg[exprs]			;a
	tst	f,reg[x+exprs]			;a

	tst	x,a				;a
	tst	x,f				;a
	tst	x,x				;a
	tst	x,sp				;a
	tst	x,exprs				;a
	tst	x,[exprs]			;a
	tst	x,[x+exprs]			;a
	tst	x,[[exprs]++]			;a
	tst	x,reg[exprs]			;a
	tst	x,reg[x+exprs]			;a

	tst	sp,a				;a
	tst	sp,f				;a
	tst	sp,x				;a
	tst	sp,sp				;a
	tst	sp,exprs			;a
	tst	sp,[exprs]			;a
	tst	sp,[x+exprs]			;a
	tst	sp,[[exprs]++]			;a
	tst	sp,reg[exprs]			;a
	tst	sp,reg[x+exprs]			;a

	tst	exprd,a				;a
	tst	exprd,f				;a
	tst	exprd,x				;a
	tst	exprd,sp			;a
	tst	exprd,exprs			;a
	tst	exprd,[exprs]			;a
	tst	exprd,[x+exprs]			;a
	tst	exprd,[[exprs]++]		;a
	tst	exprd,reg[exprs]		;a
	tst	exprd,reg[x+exprs]		;a

	tst	[exprd],a			;a
	tst	[exprd],f			;a
	tst	[exprd],x			;a
	tst	[exprd],sp			;a
	tst	[exprd],exprs			; 47 02 01
	tst	[exprd],[exprs]			;a
	tst	[exprd],[x+exprs]		;a
	tst	[exprd],[[exprs]++]		;a
	tst	[exprd],reg[exprs]		;a
	tst	[exprd],reg[x+exprs]		;a

	tst	[x+exprd],a			;a
	tst	[x+exprd],f			;a
	tst	[x+exprd],x			;a
	tst	[x+exprd],sp			;a
	tst	[x+exprd],exprs			; 48 02 01
	tst	[x+exprd],[exprs]		;a
	tst	[x+exprd],[x+exprs]		;a
	tst	[x+exprd],[[exprs]++]		;a
	tst	[x+exprd],reg[exprs]		;a
	tst	[x+exprd],reg[x+exprs]		;a

	tst	[[exprd]++],a			;a
	tst	[[exprd]++],f			;a
	tst	[[exprd]++],x			;a
	tst	[[exprd]++],sp			;a
	tst	[[exprd]++],exprs		;a
	tst	[[exprd]++],[exprs]		;a
	tst	[[exprd]++],[x+exprs]		;a
	tst	[[exprd]++],[[exprs]++]		;a
	tst	[[exprd]++],reg[exprs]		;a
	tst	[[exprd]++],reg[x+exprs]	;a

	tst	reg[exprd],a			;a
	tst	reg[exprd],f			;a
	tst	reg[exprd],x			;a
	tst	reg[exprd],sp			;a
	tst	reg[exprd],exprs		; 49 02 01
	tst	reg[exprd],[exprs]		;a
	tst	reg[exprd],[x+exprs]		;a
	tst	reg[exprd],[[exprs]++]		;a
	tst	reg[exprd],reg[exprs]		;a
	tst	reg[exprd],reg[x+exprs]		;a

	tst	reg[x+exprd],a			;a
	tst	reg[x+exprd],f			;a
	tst	reg[x+exprd],x			;a
	tst	reg[x+exprd],sp			;a
	tst	reg[x+exprd],exprs		; 4A 02 01
	tst	reg[x+exprd],[exprs]		;a
	tst	reg[x+exprd],[x+exprs]		;a
	tst	reg[x+exprd],[[exprs]++]	;a
	tst	reg[x+exprd],reg[exprs]		;a
	tst	reg[x+exprd],reg[x+exprs]	;a


	.page
	.sbttl	S_SWAP (swap)

	swap	a,a				;a
	swap	a,f				;a
	swap	a,x				; 4B
	swap	a,sp				; 4E
	swap	a,exprs				;a
	swap	a,[exprs]			; 4C 01
	swap	a,[x+exprs]			;a
	swap	a,[[exprs]++]			;a
	swap	a,reg[exprs]			;a
	swap	a,reg[x+exprs]			;a

	swap	f,a				;a
	swap	f,f				;a
	swap	f,x				;a
	swap	f,sp				;a
	swap	f,exprs				;a
	swap	f,[exprs]			;a
	swap	f,[x+exprs]			;a
	swap	f,[[exprs]++]			;a
	swap	f,reg[exprs]			;a
	swap	f,reg[x+exprs]			;a

	swap	x,a				;a
	swap	x,f				;a
	swap	x,x				;a
	swap	x,sp				;a
	swap	x,exprs				;a
	swap	x,[exprs]			; 4D 01
	swap	x,[x+exprs]			;a
	swap	x,[[exprs]++]			;a
	swap	x,reg[exprs]			;a
	swap	x,reg[x+exprs]			;a

	swap	sp,a				;a
	swap	sp,f				;a
	swap	sp,x				;a
	swap	sp,sp				;a
	swap	sp,exprs			;a
	swap	sp,[exprs]			;a
	swap	sp,[x+exprs]			;a
	swap	sp,[[exprs]++]			;a
	swap	sp,reg[exprs]			;a
	swap	sp,reg[x+exprs]			;a

	swap	exprd,a				;a
	swap	exprd,f				;a
	swap	exprd,x				;a
	swap	exprd,sp			;a
	swap	exprd,exprs			;a
	swap	exprd,[exprs]			;a
	swap	exprd,[x+exprs]			;a
	swap	exprd,[[exprs]++]		;a
	swap	exprd,reg[exprs]		;a
	swap	exprd,reg[x+exprs]		;a

	swap	[exprd],a			;a
	swap	[exprd],f			;a
	swap	[exprd],x			;a
	swap	[exprd],sp			;a
	swap	[exprd],exprs			;a
	swap	[exprd],[exprs]			;a
	swap	[exprd],[x+exprs]		;a
	swap	[exprd],[[exprs]++]		;a
	swap	[exprd],reg[exprs]		;a
	swap	[exprd],reg[x+exprs]		;a

	swap	[x+exprd],a			;a
	swap	[x+exprd],f			;a
	swap	[x+exprd],x			;a
	swap	[x+exprd],sp			;a
	swap	[x+exprd],exprs			;a
	swap	[x+exprd],[exprs]		;a
	swap	[x+exprd],[x+exprs]		;a
	swap	[x+exprd],[[exprs]++]		;a
	swap	[x+exprd],reg[exprs]		;a
	swap	[x+exprd],reg[x+exprs]		;a

	swap	[[exprd]++],a			;a
	swap	[[exprd]++],f			;a
	swap	[[exprd]++],x			;a
	swap	[[exprd]++],sp			;a
	swap	[[exprd]++],exprs		;a
	swap	[[exprd]++],[exprs]		;a
	swap	[[exprd]++],[x+exprs]		;a
	swap	[[exprd]++],[[exprs]++]		;a
	swap	[[exprd]++],reg[exprs]		;a
	swap	[[exprd]++],reg[x+exprs]	;a

	swap	reg[exprd],a			;a
	swap	reg[exprd],f			;a
	swap	reg[exprd],x			;a
	swap	reg[exprd],sp			;a
	swap	reg[exprd],exprs		;a
	swap	reg[exprd],[exprs]		;a
	swap	reg[exprd],[x+exprs]		;a
	swap	reg[exprd],[[exprs]++]		;a
	swap	reg[exprd],reg[exprs]		;a
	swap	reg[exprd],reg[x+exprs]		;a

	swap	reg[x+exprd],a			;a
	swap	reg[x+exprd],f			;a
	swap	reg[x+exprd],x			;a
	swap	reg[x+exprd],sp			;a
	swap	reg[x+exprd],exprs		;a
	swap	reg[x+exprd],[exprs]		;a
	swap	reg[x+exprd],[x+exprs]		;a
	swap	reg[x+exprd],[[exprs]++]	;a
	swap	reg[x+exprd],reg[exprs]		;a
	swap	reg[x+exprd],reg[x+exprs]	;a


	.page
	.sbttl	S_MOV (mov)

	mov	a,a				;a
	mov	a,f				;a
	mov	a,x				; 5B
	mov	a,sp				;a
	mov	a,exprs				; 50 01
	mov	a,[exprs]			; 51 01
	mov	a,[x+exprs]			; 52 01
	mov	a,[[exprs]++]			;a
	mov	a,reg[exprs]			; 5D 01
	mov	a,reg[x+exprs]			; 5E 01

	mov	f,a				;a
	mov	f,f				;a
	mov	f,x				;a
	mov	f,sp				;a
	mov	f,exprs				;a
	mov	f,[exprs]			;a
	mov	f,[x+exprs]			;a
	mov	f,[[exprs]++]			;a
	mov	f,reg[exprs]			;a
	mov	f,reg[x+exprs]			;a

	mov	x,a				; 5C
	mov	x,f				;a
	mov	x,x				;a
	mov	x,sp				; 4F
	mov	x,exprs				; 57 01
	mov	x,[exprs]			; 58 01
	mov	x,[x+exprs]			; 59 01
	mov	x,[[exprs]++]			;a
	mov	x,reg[exprs]			;a
	mov	x,reg[x+exprs]			;a

	mov	sp,a				;a
	mov	sp,f				;a
	mov	sp,x				;a
	mov	sp,sp				;a
	mov	sp,exprs			;a
	mov	sp,[exprs]			;a
	mov	sp,[x+exprs]			;a
	mov	sp,[[exprs]++]			;a
	mov	sp,reg[exprs]			;a
	mov	sp,reg[x+exprs]			;a

	mov	exprd,a				;a
	mov	exprd,f				;a
	mov	exprd,x				;a
	mov	exprd,sp			;a
	mov	exprd,exprs			;a
	mov	exprd,[exprs]			;a
	mov	exprd,[x+exprs]			;a
	mov	exprd,[[exprs]++]		;a
	mov	exprd,reg[exprs]		;a
	mov	exprd,reg[x+exprs]		;a

	mov	[exprd],a			; 53 02
	mov	[exprd],f			;a
	mov	[exprd],x			; 5A 02
	mov	[exprd],sp			;a
	mov	[exprd],exprs			; 55 02 01
	mov	[exprd],[exprs]			; 5F 02 01
	mov	[exprd],[x+exprs]		;a
	mov	[exprd],[[exprs]++]		;a
	mov	[exprd],reg[exprs]		;a
	mov	[exprd],reg[x+exprs]		;a

	mov	[x+exprd],a			; 54 02
	mov	[x+exprd],f			;a
	mov	[x+exprd],x			;a
	mov	[x+exprd],sp			;a
	mov	[x+exprd],exprs			; 56 02 01
	mov	[x+exprd],[exprs]		;a
	mov	[x+exprd],[x+exprs]		;a
	mov	[x+exprd],[[exprs]++]		;a
	mov	[x+exprd],reg[exprs]		;a
	mov	[x+exprd],reg[x+exprs]		;a

	mov	[[exprd]++],a			;a
	mov	[[exprd]++],f			;a
	mov	[[exprd]++],x			;a
	mov	[[exprd]++],sp			;a
	mov	[[exprd]++],exprs		;a
	mov	[[exprd]++],[exprs]		;a
	mov	[[exprd]++],[x+exprs]		;a
	mov	[[exprd]++],[[exprs]++]		;a
	mov	[[exprd]++],reg[exprs]		;a
	mov	[[exprd]++],reg[x+exprs]	;a

	mov	reg[exprd],a			; 60 02
	mov	reg[exprd],f			;a
	mov	reg[exprd],x			;a
	mov	reg[exprd],sp			;a
	mov	reg[exprd],exprs		; 62 02 01
	mov	reg[exprd],[exprs]		;a
	mov	reg[exprd],[x+exprs]		;a
	mov	reg[exprd],[[exprs]++]		;a
	mov	reg[exprd],reg[exprs]		;a
	mov	reg[exprd],reg[x+exprs]		;a

	mov	reg[x+exprd],a			; 61 02
	mov	reg[x+exprd],f			;a
	mov	reg[x+exprd],x			;a
	mov	reg[x+exprd],sp			;a
	mov	reg[x+exprd],exprs		; 63 02 01
	mov	reg[x+exprd],[exprs]		;a
	mov	reg[x+exprd],[x+exprs]		;a
	mov	reg[x+exprd],[[exprs]++]	;a
	mov	reg[x+exprd],reg[exprs]		;a
	mov	reg[x+exprd],reg[x+exprs]	;a


	.page
	.sbttl	S_SHFT (asl / asr / rrl / rrc)

	asl	a				; 64
	asl	f				;a
	asl	x				;a
	asl	sp				;a
	asl	exprd				;a
	asl	[exprd]				; 65 02
	asl	[x+exprd]			; 66 02
	asl	[[exprd]++]			;a
	asl	reg[exprd]			;a
	asl	reg[x+exprd]			;a


	.page
	.sbttl	S_CPL (cpl)

	cpl	a				; 73
	cpl	f				;a
	cpl	x				;a
	cpl	sp				;a
	cpl	exprd				;a
	cpl	[exprd]				;a
	cpl	[x+exprd]			;a
	cpl	[[exprd]++]			;a
	cpl	reg[exprd]			;a
	cpl	reg[x+exprd]			;a


	.page
	.sbttl	S_CNT (inc / dec)

	inc	a				; 74
	inc	f				;a
	inc	x				; 75
	inc	sp				;a
	inc	exprd				;a
	inc	[exprd]				; 76 02
	inc	[x+exprd]			; 77 02
	inc	[[exprd]++]			;a
	inc	reg[exprd]			;a
	inc	reg[x+exprd]			;a


