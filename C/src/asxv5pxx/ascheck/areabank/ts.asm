	.title	Single File ASxxxx and ASLink AREA Tests

	; Compile and Link:
	;
	;	ascheck -gloaxff ts
	;	aslink  -smu ts
	;
	; Verify values after linking:
	;
	;	asxscn   ts.rst
	;
	;
	; Linked Memory Map:
	;
	;                (ABS,OVR)   (ABS,CON)   (REL,OVR)
	;                                        (REL,CON)
	;	+------+-----------+-----------+-----------+
	;	| 0000 |   area1   |   area2   |   area3   |
	;	|      |-----------|           |           |
	;	|      |           |           |           |
	;	|      |           |-----------|           |
	;	|      |           |           |           |
	;	|      |           |           |-----------|
	;	| 000C |           |           |   area4   |
	;	|      |           |           |           |
	;	|      |           |           |           |
	;	|      |           |           |           |
	;	|      |           |           |           |
	;	|      |           |           |           |
	;	|      |           |           |           |
	;	+------+-----------+-----------+-----------+
	;
	;	ALL Absolute Areas Always Begin At Address 0000
	;
	;	The First Relocatable Always Bigins At Address 0000
	;
	;	For a single linked file the OVR and CON attributes
	;	have no significance.
	;

	.area area1 (ABS,OVR)
	; . == 0000 ( == s_area1 )
	.word	s_area3		; 00 00
	.word	l_area3		; 00 0C

	.area area2 (ABS,CON)
	; . == 0000 ( == s_area2 )
	.word	s_area4		; 00 0C
	.word	l_area4		; 00 10
	.word	s_area1		; 00 00
	.word	l_area1		; 00 04


	.area area3 (REL,OVR)
	; . == 0000 ( == s_area3 )
	.word	s_area1		; 00 00
	.word	l_area1		; 00 04
	.word	s_area2		; 00 00
	.word	l_area2		; 00 08
	.word	s_area4		; 00 0C
	.word	l_area4		; 00 10


	.area area4 (REL,CON)
	; . == 000C ( == s_area4 )
	.word	s_area1		; 00 00
	.word	l_area1		; 00 04
	.word	s_area2		; 00 00
	.word	l_area2		; 00 08
	.word	s_area3		; 00 00
	.word	l_area3		; 00 0C
	.word	s_area4		; 00 0C
	.word	l_area4		; 00 10

