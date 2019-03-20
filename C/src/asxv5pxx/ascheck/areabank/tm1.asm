	.title	Multiple File ASxxxx and ASLink AREA Tests
	.sbttl	File: tm1.asm

	; Compile and Link:
	;
	;	ascheck -gloaxff tm1
	;	ascheck -gloaxff tm2
	;	aslink  -smu tm tm1 tm2
	;
	; Verify values after linking:
	;
	;	asxscn   tm1.rst
	;	asxscn   tm2.rst
	;
	;
	; Linked Memory Map:
	;
        ;               (ABS,OVR) (ABS,OVR) (ABS,CON) (REL,OVR) (REL,OVR)
	;                                   (ABS,CON)      (REL,CON)
	;                                                  (REL,CON)
	;	+------+---------+---------+---------+---------+---------+
	;	| 0000 | 1:area1 | 2:area1 | 1:area2 | 1:area3 | 1:area3 |
	;	|      |         |---------|         |         |         |
	;	|      |         |/////////|         |         |---------|
        ;       |      |-------------------|         |         |/////////|
        ;       |      |         |         |---------|         |/////////|
        ;       |      |         |         | 2:area2 |-------------------|
        ;       |      |         |         |---------|      1:area4      |
        ;       |      |         |         |         |         |         |
        ;       |      |         |         |         |         |         |
        ;       |      |         |         |         |         |         |
        ;       |      |         |         |         |-------------------|
        ;       |      |         |         |         |      2:area4      |
        ;       |      |         |         |         |         |         |
        ;       |      |         |         |         |         |         |
	;	+------+---------+---------+---------+---------+---------+
	;
        ;       ALL Absolute Areas Begin At Address 0000
	;
        ;       The First Relocatable Area Begins At Address 0000
	;
	;	For multiple linked files the OVR and CON attributes
	;	specify how an area is combined.  Note that the
	;	order of linking will change the concatenation sequence.
	;

	.area area1 (ABS,OVR)
tm1_1:  .word	tm1_1		; 00 00
	.word	s_area3		; 00 00
	.word	l_area3		; 00 0E

	.area area2 (ABS,CON)
tm1_2:	.word	tm1_2		; 00 00
	.word	s_area4		; 00 0E
	.word	l_area4		; 00 14
	.word	s_area1		; 00 00
	.word	l_area1		; 00 06


	.area area3 (REL,OVR)
tm1_3:	.word	tm1_3		; 00 00
	.word	s_area1		; 00 00
	.word	l_area1		; 00 06
	.word	s_area2		; 00 00
	.word	l_area2		; 00 0C
	.word	s_area4		; 00 0E
	.word	l_area4		; 00 14


	.area area4 (REL,CON)
tm1_4:	.word	tm1_4		; 00 0E
	.word	s_area1		; 00 00
	.word	l_area1		; 00 06
	.word	s_area2		; 00 00
	.word	l_area2		; 00 0C
	.word	s_area3		; 00 00
	.word	l_area3		; 00 0E
	.word	s_area4		; 00 0E
	.word	l_area4		; 00 14

