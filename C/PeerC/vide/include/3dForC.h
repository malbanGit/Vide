#pragma once

#include <vectrex.h>


/*



*/
#define __ass	asm volatile

struct Line3ds
{
 unsigned char pattern;
 unsigned char scale;
 signed char *moveTo;
};

struct Line3d
{
 unsigned char pattern;
 signed char *moveTo;
};


// vars
// 0 = do not calc vector
// 1 = calc vector 
extern unsigned int  angle_x;
extern unsigned int  angle_y;
extern unsigned int  angle_z;

extern unsigned  long vectorBits;

#define TEST_0_0_0 0x01 // low byte
#define TEST_1_0_0 0x02 // low byte
#define TEST_1_1_0 0x04 // low byte
#define TEST_1_0_1 0x08 // low byte
#define TEST_1_1_1 0x10 // low byte
#define TEST_0_1_0 0x20 // low byte
#define TEST_0_1_1 0x40 // low byte
#define TEST_0_0_1 0x80 // low byte
#define TEST_N_1_0 0x0100 // high byte
#define TEST_N_0_1 0x0200 // high byte
#define TEST_0_N_1 0x0400 // high byte
#define TEST_N_1_1 0x0800 // high byte
#define TEST_1_N_1 0x1000 // high byte
#define TEST_1_1_N 0x2000 // high byte



// functions
extern unsigned long init_2d;  // no input
extern unsigned long init_all; // no input

extern unsigned long asm_draw_3ds; // input X
extern unsigned long asm_draw_3d_dp; // input X
extern const signed char allDirs_calc;

#define __INIT_2D    init_2d
#define __INIT_ALL   init_all
#define __PRINT_3DS  asm_draw_3ds
#define __PRINT_3D   asm_draw_3d_dp


#define __MC6809_jsr_init3d(args...)	__mc6809_jsr_init3d(args)
#define asm_init3d_2d() __MC6809_jsr_init3d(__INIT_2D, INIT_2D, d, u, y, x, dp)
#define asm_init3d_all() __MC6809_jsr_init3d(__INIT_ALL, INIT_ALL, d, u, y, x, dp)

#define __MC6809_print_3dlist_jsr_x__duy(args...)		__mc6809_print_3dlist_jsr_x__duy(args)
#define asm_print_3dlist(X) __MC6809_print_3dlist_jsr_x__duy(X, __PRINT_3D, PRINT_3D, d, x, y, u, dp)
#define asm_print_3dslist(X) __MC6809_print_3dlist_jsr_x__duy(X, __PRINT_3DS, PRINT_3DS, d, x, y, u, dp)




#ifdef OMMIT_FRAMEPOINTER

    #define __mc6809_jsr_init3d(func, name, regs...) { \
    	__ass( \
    		"jsr " #func "; " #name "\n\t" \
    		:: \
    		: "s", "memory", "cc","a","b","d","dp","u","y","x"); \
    }
    #define __mc6809_print_3dlist_jsr_x__duy(x, func, name, regs...) { \
    	__ass( \
    		"ldx %[X]\n\t" \
    		"jsr " #func "; " #name "\n\t" \
    		:: [X] "m" (x) \
    		: "memory","d", "u", "x","y","cc"); \
    }

#else

    #define __mc6809_jsr_init3d(func, name, regs...) { \
    	__ass( \
	 	"pshs u\n\t" \
    		"jsr " #func "; " #name "\n\t" \
	 	"puls u\n\t" \
    		:: \
    		: "s", "memory", "cc","d","dp","y","x"); \
    }
    #define __mc6809_print_3dlist_jsr_x__duy(x, func, name, regs...) { \
    	__ass( \
    		"ldx %[X]\n\t" \
	 	"pshs u\n\t" \
    		"jsr " #func "; " #name "\n\t" \
	 	"puls u\n\t" \
    		:: [X] "m" (x) \
    		: "memory","d", "x","y","cc"); \
    }

#endif


__INLINE void init3d_2d() \
{asm_init3d_2d(); } 
__INLINE void init3d_all() \
{asm_init3d_all(); } 

__INLINE void draw_3ds(void* volatile x) \
{asm_print_3dslist(x); } 

__INLINE void draw_3d(void* volatile x) \
{asm_print_3dlist(x); } 


#define toCharPointer(a) ((signed char *) a)



#define _0_0_0 toCharPointer( (const signed char *)(&allDirs_calc + 0) )
#define _1_0_0 toCharPointer((const signed char *)(&allDirs_calc + 3))
#define _1_1_0 toCharPointer((const signed char *)(&allDirs_calc + 6))
#define _1_0_1 toCharPointer((const signed char *)(&allDirs_calc + 9))
#define _1_1_1 toCharPointer((const signed char *)(&allDirs_calc + 12))
#define _0_1_0 toCharPointer((const signed char *)(&allDirs_calc + 15))
#define _0_1_1 toCharPointer((const signed char *)(&allDirs_calc + 18))
#define _0_0_1 toCharPointer((const signed char *)(&allDirs_calc + 21))
#define _N_1_0 toCharPointer((const signed char *)(&allDirs_calc + 24))
#define _N_0_1 toCharPointer((const signed char *)(&allDirs_calc + 27))
#define _0_N_1 toCharPointer((const signed char *)(&allDirs_calc + 30))
#define _N_1_1 toCharPointer((const signed char *)(&allDirs_calc + 33))
#define _1_N_1 toCharPointer((const signed char *)(&allDirs_calc + 36))
#define _1_1_N toCharPointer((const signed char *)(&allDirs_calc + 39))

#define INVERS_OFFSET 42

#define I_0_0_0 (_0_0_0 + INVERS_OFFSET)
#define I_1_0_0 (_1_0_0 + INVERS_OFFSET)
#define I_1_1_0 (_1_1_0 + INVERS_OFFSET)
#define I_1_0_1 (_1_0_1 + INVERS_OFFSET)
#define I_1_1_1 (_1_1_1 + INVERS_OFFSET)
#define I_0_1_0 (_0_1_0 + INVERS_OFFSET)
#define I_0_1_1 (_0_1_1 + INVERS_OFFSET)
#define I_0_0_1 (_0_0_1 + INVERS_OFFSET)
#define I_N_1_0 (_N_1_0 + INVERS_OFFSET)
#define I_N_0_1 (_N_0_1 + INVERS_OFFSET)
#define I_0_N_1 (_0_N_1 + INVERS_OFFSET)
#define I_N_1_1 (_N_1_1 + INVERS_OFFSET)
#define I_1_N_1 (_1_N_1 + INVERS_OFFSET)
#define I_1_1_N (_1_1_N + INVERS_OFFSET)

#define _N_0_0 I_1_0_0
#define _N_N_0 I_1_1_0
#define _N_0_N I_1_0_1
#define _N_N_N I_1_1_1
#define _0_N_0 I_0_1_0
#define _0_N_N I_0_1_1
#define _0_0_N I_0_0_1
#define _1_N_0 I_N_1_0
#define _1_0_N I_N_0_1
#define _0_1_N I_0_N_1
#define _1_N_N I_N_1_1
#define _N_1_N I_1_N_1
#define _N_N_1 I_1_1_N