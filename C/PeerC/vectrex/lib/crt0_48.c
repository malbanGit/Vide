// ***************************************************************************
// vectrex c runtime initialization - do not change!
// ***************************************************************************

#define __CRT0_ASM
#define __ass asm volatile

// ---------------------------------------------------------------------------
// define linker rom section

__asm(
	".bank rom(BASE=0x0000,SIZE=0xC000,FSFX=_rom)\n\t"
	".area .cartridge	(BANK=rom) \n\t"
	".area .text  			(BANK=rom)\n\t"
	".area .text.hot		(BANK=rom)\n\t"
	".area .text.unlikely	(BANK=rom)\n\t"
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
// initialize data segment and zero bss segment in system ram,	
// then loop through main, error code > 0 causes cold reset

#ifdef __CRT0_ASM

// ---------------------------------------------------------------------------
// mc6809 version
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------

#else

// ---------------------------------------------------------------------------
// c version
// ---------------------------------------------------------------------------
	
#define NORETURN static inline __attribute__((noreturn, used))
extern int main(void);

NORETURN void crt0_init_data(void)
{
	volatile unsigned int* source;
	volatile unsigned int* dest;
	long unsigned int length;

	asm volatile( \
		"	pshs 	x					\n\t" \
		"	ldx		#s_.text			\n\t" \
		"	leax	l_.text,x			\n\t" \
		"	leax	l_.text.hot,x		\n\t" \
		"	leax	l_.text.unlikely,x	\n\t" \
		"	stx 	%[S]				\n\t" \
		"	ldx		#s_.data			\n\t" \
		"	stx 	%[D]				\n\t" \
		"	ldx		#l_.data			\n\t" \
		"	stx 	%[L]				\n\t" \
		"	puls 	x					\n\t" \
		: [S] "=m" (source), [D] "=m" (dest), [L] "=m" (length) \
		:: "memory", "cc");
	
	while(length--)
	{
		*(dest++) = *(source++);
	}

	asm volatile( \
		"	pshs 	x					\n\t" \
		"	ldx		#s_.bss				\n\t" \
		"	stx 	%[D]				\n\t" \
		"	ldx		#l_.bss				\n\t" \
		"	stx 	%[L]				\n\t" \
		"	puls 	x\n\t" \
		: [D] "=m" (dest), [L] "=m" (length) \
		:: "memory", "cc");

	while(length--)
	{
		*(dest++) = 0U;
	}
	
	if (main() > 0)
	{
		*((volatile unsigned int* const) 0xcbfe) = 0U;
	}

	goto *((void*) 0xf000);
}

// ---------------------------------------------------------------------------

#endif

// ***************************************************************************
// end of file
// ***************************************************************************
