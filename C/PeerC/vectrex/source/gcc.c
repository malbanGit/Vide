// ***************************************************************************
// gcc built-in stdlib functions for gcc6809
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

#define _GCC_BUILTIN_FUNCTIONS	1	// add missing code for gcc built in functions
#define _GCC_BUILTIN_INLINE		0	// inline all functions

#define _GCC_BUILTIN_ABORT		1	// add code for abort()
#define _GCC_BUILTIN_FREE		1	// add code for free()
#define _GCC_BUILTIN_MALLOC		1	// add code for malloc()
#define _GCC_BUILTIN_MEMCMP		1	// add code for memcmp()
#define _GCC_BUILTIN_MEMCPY		1	// add code for memcpy()
#define _GCC_BUILTIN_MEMMOVE	1	// add code for memmove()
#define _GCC_BUILTIN_MEMSET		1	// add code for memset()

#define _GCC_BUILTIN_RESET		1	// use optimized code for abort(), free(), malloc()
#define _GCC_BUILTIN_ASM		0	// use optimized assembly code rather than c - TODO!

#if _GCC_BUILTIN_INLINE
#define __INLINE static inline __attribute__((always_inline))
#else
#define __INLINE
#endif

#define __ass asm

// ***************************************************************************

#if _GCC_BUILTIN_FUNCTIONS

// ***************************************************************************

#if _GCC_BUILTIN_ABORT
#if _GCC_BUILTIN_RESET
__ass(
	".globl		_abort				\n\t"
	"_abort		.equ 	0xf000		\n\t"
);
#else
__INLINE
__attribute__ ((naked))
void abort(void)
{
#if _GCC_BUILTIN_ASM
	asm volatile ("jmp 0xf000; abort -> restart system" : :: "pc");
#else
	goto *((void*) 0xf000);
#endif
}
#endif
#endif

// ***************************************************************************

#if _GCC_BUILTIN_FREE
#if _GCC_BUILTIN_RESET
__ass(
	".globl		_free				\n\t"
	"_free		.equ 	0xf000		\n\t"
);
#else
__INLINE
__attribute__ ((naked))
void free(void* pointer __attribute__((unused)))
{
#if _GCC_BUILTIN_ASM
	asm volatile ("jmp 0xf000; free -> restart system" : :: "pc");
#else
	goto *((void*) 0xf000);
#endif
}
#endif
#endif

// ***************************************************************************

#if _GCC_BUILTIN_MALLOC
#if _GCC_BUILTIN_RESET
__ass(
	".globl		_malloc				\n\t"
	"_malloc	.equ 	0xf000		\n\t"
);
#else
__INLINE
__attribute__ ((naked))
void* malloc(long unsigned int size __attribute__((unused)))
{
#if GCC_BUILTIN_ASM
	asm volatile ("jmp 0xf000; free -> restart system" : :: "pc");
#else
	goto *((void*) 0xf000);
#endif
	return (void*) 0;
}
#endif
#endif

// ***************************************************************************

#if _GCC_BUILTIN_MEMCMP
__INLINE
int memcmp (const void* str1, const void* str2, long unsigned int count)
{
	const unsigned char* s1 = (unsigned char*) str1;
	const unsigned char* s2 = (unsigned char*) str2;

	while (count-- > 0)
	{
		if (*s1++ != *s2++)
		{
			return s1[-1] < s2[-1] ? -1 : 1;
		}
	}
	return 0;
}
#endif

// ***************************************************************************

#if _GCC_BUILTIN_MEMCPY
__INLINE
void* memcpy (void* dest, const void* src, long unsigned int len)
{
	char* d = (char*) dest;
	const char* s = (char*) src;
	while (len--)
	{
		*d++ = *s++;
	}
	return dest;
}
#endif

// ***************************************************************************

#if _GCC_BUILTIN_MEMMOVE
__INLINE
void* memmove(void* dest, const void* src, long unsigned int len)
{
	char* d = (char*) dest;
	const char* s = (char*) src;
	if (d < s)
	{
		while (len--)
		{
			*d++ = *s++;
		}
	}
	else
	{
		const char* lasts = s + (len-1);
		char* lastd = d + (len-1);
		while (len--)
		{
			*lastd-- = *lasts--;
		}
	}
	return dest;
}
#endif

// ***************************************************************************

#if _GCC_BUILTIN_MEMSET
__INLINE
void* memset(void* dest, int val, long unsigned int len)
{
	int* ptr = dest;
	while (len-- > 0)
	{
		*ptr++ = val;
	}
	return dest;
}
#endif

// ***************************************************************************

#endif 

// ***************************************************************************
// end of file
// ***************************************************************************
