#pragma once

/*
 * Include some standard vectrex functions first!
 */
#include <vectrex.h>

/* example
...
#include <scroll.h>
...

const unsigned char text[] = "THIS MIGHT SOMEDAY BECOME A JUMPMAN CLONE...   \x80";
#define BOTTOM_MOST ((signed char) (-128))

...



void intro(void)
{
  scr_y = 0;
  scr_lbnd= -100;
  scr_rbnd= 100;
  scr_sped=-1;
  scr_ints=MAX_BRIGHTNESS;

  scroll_init((char *)text);
  do
  {
      Wait_Recal();
      Intensity_a(0x7d);
      VIA_t1_cnt_lo= (unsigned int)MAX_SCALE;

      Moveto_d( BOTTOM_MOST-BOTTOM_MOST/3, 0);

      scroll_step();
      check_buttons();
   }
  while ( button_1_1_pressed() == 0);
}
*/




extern signed char scr_y;     /* Y-Position of scroller... */
extern signed char scr_lbnd;  /* left border of scroller */
extern signed char scr_rbnd;  /* right border of scroller */
extern signed char scr_sped;  /* speed 0 - -## (must be negativ) */
extern unsigned char scr_ints;  /* brightness of text */

// functions
extern unsigned long scr_init; /* initialize scroller, above variables must be set */
extern unsigned long scr_step; /* do one scroll step, called ones per round */

#define __ass	asm volatile


#define ym_cdata    RAM(&ym_data_current, unsigned long int)
#define __DO_SCROLL_INIT  scr_init
#define __DO_SCROLL_STEP  scr_step

#define __MC6809_jsr_clobberAll(args...)	__mc6809_jsr_clobberAll(args)
#define asm_scroll_step() __MC6809_jsr_clobberAll(__DO_SCROLL_STEP, DO_SCROLL_STEP, d, u, x, y, dp)

#define __MC6809_jsr_x__dxy(args...)		__mc6809_jsr_x__dxy(args)
#define _asm_scroll_init(X) __MC6809_jsr_x__dxy(X, __DO_SCROLL_INIT, DO_SCROLL_INIT, d, x, u)

#ifdef OMMIT_FRAMEPOINTER
#define __mc6809_jsr_clobberAll(func, name, regs...) { \
	__ass( \
		"jsr " #func "; " #name "\n\t" \
		:: \
		: "s", "memory", "cc","a","b","d","dp","u","y","x"); \
}

#define __mc6809_jsr_x__dxy(x, func, name, regs...) { \
	__ass( \
		"ldx %[X]\n\t" \
		"jsr " #func "; " #name "\n\t" \
		:: [X] "m" (x) \
		: "memory","d", "u", "x","y","cc"); \
}

#else

#define __mc6809_jsr_clobberAll(func, name, regs...) { \
	__ass( \
		"pshs u\n\t" \
		"jsr " #func "; " #name "\n\t" \
		"puls u\n\t" \
		:: \
		: "s", "memory", "cc","a","b","d","dp","y","x"); \
}

#define __mc6809_jsr_x__dxy(x, func, name, regs...) { \
	__ass( \
		"ldx %[X]\n\t" \
		"pshs u\n\t" \
		"jsr " #func "; " #name "\n\t" \
		"puls u\n\t" \
		:: [X] "m" (x) \
		: "memory","d", "x","y","cc"); \
}
#endif


__INLINE void scroll_step() {asm_scroll_step(); } 
  
__INLINE void scroll_init(volatile char*  x) {_asm_scroll_init(x); } 



