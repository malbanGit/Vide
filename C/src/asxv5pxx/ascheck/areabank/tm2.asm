	.title	Multiple File ASxxxx and ASLink AREA Tests
        .sbttl  File: tm2.asm

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
        ;       | 000C |         |         |         |         |         |
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
tm2_1:  .word   tm2_1           ; 00 00


	.area area2 (ABS,CON)
tm2_2:  .word   tm2_2           ; 00 0A


	.area area3 (REL,OVR)
tm2_3:  .word   tm2_3           ; 00 00


	.area area4 (REL,CON)
tm2_4:  .word   tm2_4           ; 00 20


