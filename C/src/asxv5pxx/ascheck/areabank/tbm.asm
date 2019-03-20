	.title	ASxxxx and ASLink Bank Test
	.sbttl	File: tbm.asm

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

	.bank	SCT	(Base=0xC000)

	.area	area1	(ABS,OVR,Bank=SCT)
	.area	area2	(ABS,CON,Bank=SCT)
	.area	area3	(REL,OVR,Bank=SCT)
	.area	area4	(REL,CON,Bank=SCT)


