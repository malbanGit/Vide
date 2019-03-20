	.title	EZ80 Banked .adl and .z80 Modes

	.sbttl	Memory Organization

	;	         111111111122222222223333333333444444444455555555556
	;	123456789012345678901234567890123456789012345678901234567890
	;
	;	--------------------	ADL_BANK_0	0x000000
	;	|                  |
	;	|                  |
	;	|                  |
	;	|                  |
	;	|                  |
	;	|                  |
	;	--------------------			0x01FFFF
	;
	;	--------------------	Z80_BANK_02	0x020000
	;	|                  |
	;	|                  |
	;	|                  |
	;	--------------------			0x02FFFF
	;
	;	--------------------		0x030000
	;	|      Unused      |
	;	--------------------		0x03FFFF
	;
	;	--------------------	Z80_BANK_04	0x040000
	;	|                  |
	;	|                  |
	;	|                  |
	;	--------------------			0x04FFFF
	;
	;	--------------------		0x050000
	;	|      Unused      |	        
	;	--------------------		0x05FFFF
	;
	;	--------------------	Z80_BANK_06	0x060000
	;	|                  |
	;	|                  |
	;	|                  |
	;	--------------------			0x06FFFF
	;
	;	--------------------	ADL_BANK_1	0x048000
	;	|                  |
	;	|                  |
	;	|                  |
	;	~                  ~
	;	~                  ~
	;	|                  |
	;	|                  |
	;	|                  |
	;	--------------------			0xFFFFFF
	;

	
	.sbttl	Code Banks

	.Bank	ADL_BANK_0	(Base=0x000000, Size=0x020000)
	.Bank	ADL_BANK_1	(Base=0x048000)

	.Bank	Z80_BANK_02	(Base=0x020000, Size=0x010000, FSFX=_02)
	.Bank	Z80_BANK_04	(Base=0x040000, Size=0x010000, FSFX=_04)
	.Bank	Z80_BANK_06	(Base=0x060000, Size=0x010000, FSFX=_06)


	.sbttl	Code Areas

	.area	ADL_Sys_1	(rel,con,CSEG,Bank=ADL_BANK_0)
	.area	ADL_Sys_2	(rel,con,CSEG,Bank=ADL_BANK_1)

	.area	Z80_Vm_0	(rel,con,CSEG,Bank=Z80_BANK_02)
	.area	Z80_Vm_1	(rel,con,CSEG,Bank=Z80_BANK_04)
	.area	Z80_Vm_2	(rel,con,CSEG,Bank=Z80_BANK_06)


	.msb	2		; select MSB as 3rd byte of address (0,1,[2],3)


	.sbttl	Code in Area ADL_Sys_1

	;*****-----*****-----*****-----******-----******-----*****
	;
	; Area:	ADL_Sys_1
	;
	;*****-----*****-----*****-----******-----******-----*****

	.area	ADL_Sys_1
	.adl			; ADL Memory Mode

Sys_1:	; Beginning Address of Area
	; Prepare mb for 'call'
	ld	a,#>z80_0_sub	; 3ER00
	ld	mb,a		; ED 6D

	; call the 1st Z80 VM
	call.is	z80_0_sub	; 49 CDr13s00

	; Prepare mb for 'call'
	ld	a,#>z80_1_sub	; 3ER00
	ld	mb,a		; ED 6D

	; call the 2nd Z80 VM
	call.is	z80_1_sub	; 49 CDr13s00

	; Prepare mb for 'call'
	ld	a,#>z80_2_sub	; 3ER00
	ld	mb,a		; ED 6D

	; call the 3rd Z80 VM
	call.is	z80_2_sub	; 49 CDr13s00

	; call a routine in current bank
	call	sys_1_sub	; CDr20s00R00

	; call a routine in other ADL bank
	call	sys_2_sub	; CDr20s00R00

sys_1_sub:
	ret			; C9


	.sbttl	Code in Area Z80_Vm_1

	;*****-----*****-----*****-----******-----******-----*****
	;
	; Area:	Z80_Vm_0
	;
	;*****-----*****-----*****-----******-----******-----*****

	.area	Z80_Vm_0
	.z80			; Z80 Memory Mode

VM_0:	; Beginning Address of Area
	; call a routine in the 1st ADL bank
	call.il	sys_1_sub	; 52 CDr20s00R00

	; call a routine in the 2nd ADL bank
	call.il	sys_2_sub	; 52 CDr20s00R00

	; call a routine in the current bank
	call	z80_0_sub	; CD*13n00

	; call a routine in the other Z80 bank
	; *** PageX Link Error during linking ***
	call	z80_1_sub	; CD*13n00

	; call a routine in the other Z80 bank
	; *** PageX Link Error during linking ***
	call	z80_2_sub	; CD*13n00

z80_0_sub:
	ret			; C9

	; Prepare for a Linker PAGE Boundary Check
	bytes = 0x010000 - (.-VM_0) - 3
	.blkb	bytes
	; Instruction completely within PAGE
	call	z80_0_sub	; CD*13n00



	.sbttl	Code in Area Z80_Vm_1

	;*****-----*****-----*****-----******-----******-----*****
	;
	; Area:	Z80_Vm_1
	;
	;*****-----*****-----*****-----******-----******-----*****

	.area	Z80_Vm_1
	.z80			; Z80 Memory Mode

VM_1:	; Beginning Address of Area
	; call a routine in the 1st ADL bank
	call.il	sys_1_sub	; 52 CDr20s00R00

	; call a routine in the 2nd ADL bank
	call.il	sys_2_sub	; 52 CDr20s00R00

	; call a routine in the other Z80 bank
	; *** PageX Link Error during linking ***
	call	z80_0_sub	; CD*13n00

	; call a routine in the current bank
	call	z80_1_sub	; CD*13n00

	; call a routine in the other Z80 bank
	; *** PageX Link Error during linking ***
	call	z80_2_sub	; CD*13n00

z80_1_sub:
	ret			; C9

	; Prepare for a Linker PAGE Boundary Check
	bytes = 0x010000 - (.-VM_1) - 2
	.blkb	bytes
	; Last Byte of Address is outside PAGE
	; *** PageX Link Error during linking ***
	; *** Bank Size  Error during linking ***
	call	z80_1_sub	; CD*13n00



	.sbttl	Code in Area Z80_Vm_2

	;*****-----*****-----*****-----******-----******-----*****
	;
	; Area:	Z80_Vm_2
	;
	;*****-----*****-----*****-----******-----******-----*****

	.area	Z80_Vm_2
	.z80			; Z80 Memory Mode

VM_2:	; Beginning Address of Area
	; call a routine in the 1st ADL bank
	call.il	sys_1_sub	; 52 CDr20s00R00

	; call a routine in the 2nd ADL bank
	call.il	sys_2_sub	; 52 CDr20s00R00

	; call a routine in the other Z80 bank
	; *** PageX Link Error during linking ***
	call	z80_0_sub	; CD*13n00

	; call a routine in the other Z80 bank
	; *** PageX Link Error during linking ***
	call	z80_1_sub	; CD*13n00

	; call a routine in the current Z80 bank
	call	z80_2_sub	; CD*13n00

z80_2_sub:
	ret			; C9

	; Prepare for a Linker PAGE Boundary Check
	bytes = 0x010000 - (.-VM_2) - 1
	.blkb	bytes
	; Both Bytes of Address are outside PAGE
	; *** PageX Link Error during linking ***
	; *** Bank Size  Error during linking ***
	call	z80_2_sub	; CD*13n00



	.sbttl	Code in Area ADL_Sys_2

	;*****-----*****-----*****-----******-----******-----*****
	;
	; Area:	ADL_Sys_2
	;
	;*****-----*****-----*****-----******-----******-----*****

	.area	ADL_Sys_2
	.adl			; ADL Memoy Mode

Sys_2:	; Beginning Address of Area
	; Prepare mb for 'call'
	ld	a,#>z80_0_sub	; 3ER00
	ld	mb,a		; ED 6D

	; call the 1st Z80 VM
	call.is	z80_0_sub	; 49 CDr13s00

	; Prepare mb for 'call'
	ld	a,#>z80_1_sub	; 3ER00
	ld	mb,a		; ED 6D

	; call the 2nd Z80 VM
	call.is	z80_1_sub	; 49 CDr13s00

	; Prepare mb for 'call'
	ld	a,#>z80_2_sub	; 3ER00
	ld	mb,a		; ED 6D

	; call the 3rd Z80 VM
	call.is	z80_2_sub	; 49 CDr13s00

	; call a routine in current bank
	call	sys_2_sub	; CDr20s00R00

	; call a routine in other ADL bank
	call	sys_1_sub	; CDr20s00R00

sys_2_sub:
	ret			; C9


