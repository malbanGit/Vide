	.title	Boundary Tests

	.area	BOUNDARY	(ABS,OVR)

	.sbttl	Power of 2 Boundary Modes

	.org	0

	.even			; Address == 0
	.odd			; Address == 1
	.odd			; Address == 1
	.even			; Address == 2
	.even			; Address == 2
	.odd			; Address == 3
	.odd			; Address == 3
	.even			; Address == 4


	.org	0

	.even			; Address == 0
	.bndry	2		; Address == 0
	.bndry	4		; Address == 0
	.bndry	8		; Address == 0
	.bndry	16		; Address == 0
	.bndry	32		; Address == 0
	.bndry	64		; Address == 0
	.bndry	128		; Address == 0
	.bndry	256		; Address == 0
	.bndry	512		; Address == 0
	.bndry	1024		; Address == 0


	.org	1

	.even			; Address == 2
	.bndry	2		; Address == 2
	.bndry	4		; Address == 4
	.bndry	8		; Address == 8
	.bndry	16		; Address == 16
	.bndry	32		; Address == 32
	.bndry	64		; Address == 64
	.bndry	128		; Address == 128
	.bndry	256		; Address == 256
	.bndry	512		; Address == 512
	.bndry	1024		; Address == 1024


	.page
	.sbttl	Non Power of 2 Boundary Modes

	.org	0

	.bndry	1		; Address == 0
	.bndry	3		; Address == 0
	.bndry	7		; Address == 0
	.bndry	15		; Address == 0
	.bndry	31		; Address == 0
	.bndry	63		; Address == 0
	.bndry	127		; Address == 0
	.bndry	255		; Address == 0
	.bndry	511		; Address == 0
	.bndry	1023		; Address == 0


	.org	1

	.bndry	3		; Address == 3
	.bndry	5		; Address == 5
	.bndry	9		; Address == 9
	.bndry	17		; Address == 17
	.bndry	33		; Address == 33
	.bndry	65		; Address == 65
	.bndry	129		; Address == 129
	.bndry	257		; Address == 257
	.bndry	513		; Address == 513
	.bndry	1025		; Address == 1025


	.org	47

	.bndry	3		; Address == 48
	.bndry	6		; Address == 48
	.bndry	12		; Address == 48
	.bndry	24		; Address == 48
	.bndry	48		; Address == 48
	.bndry	96		; Address == 96
	.bndry	192		; Address == 192
	.bndry	384		; Address == 384
	.bndry	768		; Address == 768
	.bndry	1536		; Address == 1536


