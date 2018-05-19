# 1 "source\\crt0.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "source\\crt0.c"
# 22 "source\\crt0.c"
__asm(
 ".bank rom(BASE=0x0000,SIZE=0x8000,FSFX=_rom)\n\t"
 ".area .cartridge	(BANK=rom) \n\t"
 ".area .text  			(BANK=rom)\n\t"
 ".area .text.hot		(BANK=rom)\n\t"
 ".area .text.unlikely	(BANK=rom)\n\t"
);




__asm(
 ".bank ram(BASE=0xc880,SIZE=0x036b,FSFX=_ram)\n\t"
 ".area .data  (BANK=ram)\n\t"
 ".area .bss   (BANK=ram)\n\t"
);
# 51 "source\\crt0.c"
__asm(
 "	.area .text					\n\t"
 "_crt0_init_data:				\n\t"
 "	ldu		#s_.text			\n\t"
 "	leau	l_.text,u			\n\t"
 "	leau	l_.text.hot,u		\n\t"
 "	leau	l_.text.unlikely,u	\n\t"
 "	ldy		#s_.data			\n\t"
 "	ldx		#l_.data			\n\t"
 "	beq		_crt0_init_bss		\n\t"
 "_crt0_copy_data:				\n\t"
 "	lda		,u+					\n\t"
 "	sta		,y+					\n\t"
 "	leax	-1,x				\n\t"
 "	bne		_crt0_copy_data		\n\t"
 "_crt0_init_bss:				\n\t"
 "	ldy		#s_.bss				\n\t"
 "	ldx		#l_.bss				\n\t"
 "	beq		_crt0_startup		\n\t"
 "_crt0_zero_bss:				\n\t"
 "	clr		,y+					\n\t"
 "	leax	-1,x				\n\t"
 "	bne		_crt0_zero_bss		\n\t"
 "_crt0_startup:					\n\t"
 "	jsr		_main				\n\t"
 "	tstb						\n\t"
 "	ble		_crt0_restart		\n\t"
 "	clr		0xcbfe;	cold reset	\n\t"
 "_crt0_restart:					\n\t"
 "	jmp 	0xf000;	rum			\n\t"
);
