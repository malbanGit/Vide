	.title	Multiple File ASxxxx and ASLink Banked AREA Tests
	.sbttl	File: tbm1.asm

	; Compile and Link:
	;
	;	ascheck -gloaxff tbm
	;	ascheck -gloaxff tbm1
	;	ascheck -gloaxff tbm2
	;	aslink  -smu tbm tbm tbm1 tbm2
	;
	; Verify values after linking:
	;
	;	asxscn   tbm1.rst
	;	asxscn   tbm2.rst
	;
	;
	; Linked Memory Map:
	;
        ;               (ABS,OVR) (ABS,OVR) (ABS,CON) (REL,OVR) (REL,OVR)
	;                                   (ABS,CON)      (REL,CON)
	;                                                  (REL,CON)
	;	+------+---------+---------+---------+---------+---------+
	;	| C000 | 1:area1 | 2:area1 | 1:area2 | 1:area3 | 2:area3 |
	;	|      |         |---------|         |         |---------|
	;	|      |         |/////////|         |         |/////////|
        ;       |      |-------------------|         |         |/////////|
        ;       |      |         |         |---------|         |/////////|
        ;       |      |         |         | 2:area2 |-------------------|
        ;       |      |         |         |---------|      1:area4      |
        ;       |      |         |         |         |         |         |
        ;       |      |         |         |         |         |         |
        ;       |      |         |         |         |         |         |
        ;       |      |         |         |         |         |         |
        ;       |      |         |         |         |         |         |
        ;       |      |         |         |         |-------------------|
        ;       |      |         |         |         |      2:area4      |
	;	+------+---------+---------+---------+---------+---------+
	;
        ;       ALL Absolute Areas Begin At Address 0000 relative
	;	to the BANK Base Address.
	;
        ;       The First Relocatable Area Begins At Address 0000 relative
	;	to the BANK Base Address.
	;
	;	For multiple linked files the OVR and CON attributes
	;	specify how an area is combined.  Note that the
	;	order of linking will change the concatenation sequence.
	;
	;	The s_xxxxx symbols are the area start addresses and
	;	the l_xxxxx symbols are the area lengths.  These symbols
	;	will be defined by ASLink at link time.
	;

	.area area1 (ABS,OVR)
tm1_1:  .word	tm1_1		; C0 00
	.word	s_area3		; C0 00
	.word	l_area3		; 00 0E

	.area area2 (ABS,CON)
tm1_2:	.word	tm1_2		; C0 00
	.word	s_area4		; C0 0E
	.word	l_area4		; 00 14
	.word	s_area1		; C0 00
	.word	l_area1		; 00 06


	.area area3 (REL,OVR)
tm1_3:	.word	tm1_3		; C0 00
	.word	s_area1		; C0 00
	.word	l_area1		; 00 06
	.word	s_area2		; C0 00
	.word	l_area2		; 00 0C
	.word	s_area4		; C0 0E
	.word	l_area4		; 00 14


	.area area4 (REL,CON)
tm1_4:	.word	tm1_4		; C0 0E
	.word	s_area1		; C0 00
	.word	l_area1		; 00 06
	.word	s_area2		; C0 00
	.word	l_area2		; 00 0C
	.word	s_area3		; C0 00
	.word	l_area3		; 00 0E
	.word	s_area4		; C0 0E
	.word	l_area4		; 00 14

