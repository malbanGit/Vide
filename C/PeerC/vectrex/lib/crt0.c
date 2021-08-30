// ***************************************************************************
// vectrex c runtime initialization - do not change!
// ***************************************************************************
//
// Disclaimer:
//
// This file is part of the Vectrex C programming setup developed by 
// Prof. Dr. rer. nat. Peer Johannsen. The setup is used as tool and as
// teaching material in the "Retro-Programming" and the "Advanced
// hardware-oriented C and Assembly Language Programming" classes at
// Pforzheim University, Germany.
// 
// Writing their own games for a vintage arcade game console in a programming
// course and seeing them run on a real Vectrex device has proved to greatly
// contribute to the motivation of the students.
//
// The C programming setup can freely be used by everyone for writing 
// Vectrex games and Vectrex programs in C, but at one's own risk. Please
// respect the copyright and credit the origin of these files.
//
// It would be truly fantastic if those who use this setup and/or these files
// to develop and produce their own Vectrex game cartridges, would support the
// educational approach and aim of these programming classes by donating a
// complimentary cartridge which will then be used as additional motivational
// content.
//
// Many thanks to all those out there who have already supported this course
// in various ways!
//
// Feedback, suggestions and bug-reports are always welcome and can be sent
// to the following contact address:
//
// peer.johannsen@pforzheim-university.de
//
// ---------------------------------------------------------------------------

#define __ASLINK_500 	1	// set to 1 for version 5.00
#define __ZERO_BSS 		1	// set to 1 to clear bss segment

// ---------------------------------------------------------------------------
// define linker rom section

__asm(
	".bank rom(BASE=0x0000,SIZE=0xC000,FSFX=_rom)\n\t"
	".area .cartridge		(BANK=rom)\n\t"
	".area .bootloader		(CSEG,BANK=rom)\n\t"
	".area .bankswitch.data	(DSEG,BANK=rom)\n\t"
	".area .bankswitch.code	(CSEG,BANK=rom)\n\t"
	".area .text  			(BANK=rom)\n\t"
	".area .text.hot		(BANK=rom)\n\t"
	".area .text.unlikely	(BANK=rom)\n\t"
	".area .text.unlikely	(BANK=rom)\n\t"
	".area .text.last		(BANK=rom)\n\t"
);

// ---------------------------------------------------------------------------
// define linker ram section

__asm(
	".bank ram(BASE=0xc880,SIZE=0x036b,FSFX=_ram)\n\t"
	".area .data  (BANK=ram)\n\t"
	".area .bss   (BANK=ram)\n\t"
);

// ---------------------------------------------------------------------------
// c runtime startup code
// ---------------------------------------------------------------------------
// initialize data segment (and zero bss segment in system ram),	
// then loop through main, error code > 0 causes cold reset

__asm(
	"	.area .bootloader			\n\t" 
	"_crt0_init_data:				\n\t"
#if __ASLINK_500
	"	ldu		#s_.text			\n\t"
#else
	"	ldu		#a_.text			\n\t"
#endif
	"	leau	l_.text,u			\n\t"
	"	leau	l_.text.hot,u		\n\t"
	"	leau	l_.text.unlikely,u	\n\t"
#if __ASLINK_500
	"	ldy		#s_.data			\n\t"
#else
	"	ldy		#a_.data			\n\t"
#endif
	"	ldx		#l_.data			\n\t"
	"	beq		_crt0_startup		\n\t"
	"_crt0_copy_data:				\n\t"
	"	lda		,u+					\n\t"
	"	sta		,y+					\n\t"
	"	leax	-1,x				\n\t"
	"	bne		_crt0_copy_data		\n\t"
#if __ZERO_BSS
	"_crt0_init_bss:				\n\t"
#if __ASLINK_500
	"	ldy		#s_.bss				\n\t"
#else
	"	ldy		#a_.bss				\n\t"
#endif
	"	ldx		#l_.bss				\n\t"
	"	beq		_crt0_startup		\n\t"
	"_crt0_zero_bss:				\n\t"
	"	clr		,y+					\n\t"
	"	leax	-1,x				\n\t"
	"	bne		_crt0_zero_bss		\n\t"
#endif
	"_crt0_startup:					\n\t"
	"	jsr		_main				\n\t"
	"	tstb						\n\t"
	"	ble		_crt0_restart		\n\t"
	"	clr		0xcbfe;	cold reset	\n\t"
	"_crt0_restart:					\n\t"
	"	jmp 	0xf000;	rum			\n\t"
);

// ***************************************************************************
// end of file
// ***************************************************************************
