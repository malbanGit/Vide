#pragma once

#include <vectrex.h>

/*
 example to play a sfx
...
#include "ayfxPlayer.h"
#include "aleste_1.h"
...


    while (!game_over)
    {
      Wait_Recal();
      Do_Sound();

      if ( button_1_1_pressed() != 0)
      {
        sfx_pointer_1 = (long unsigned int) (&aleste_1_data);
        sfx_status_1 = 1;
      }
         if (sfx_status_1 == 1)
        {
         ayfx_sound1();
        }

    }
*/

extern volatile unsigned int sfx_status_1;
extern volatile unsigned int sfx_status_2;
extern volatile unsigned int sfx_status_3;

extern unsigned long sfx_pointer_1;
extern unsigned long sfx_pointer_2;
extern unsigned long sfx_pointer_3;

extern unsigned long sfx_doframe_intern_1;
extern unsigned long sfx_doframe_intern_2;
extern unsigned long sfx_doframe_intern_3;

#define __DO_SFX1   sfx_doframe_intern_1
#define __DO_SFX2   sfx_doframe_intern_2
#define __DO_SFX3   sfx_doframe_intern_3

#define __ass	asm volatile

#define asm_ayfx_sound1() __MC6809_jsr_clobber_ayfx(__DO_SFX1, DO_SFX1, d, u, dp)
#define asm_ayfx_sound2() __MC6809_jsr_clobber_ayfx(__DO_SFX2, DO_SFX2, d, u, dp)
#define asm_ayfx_sound3() __MC6809_jsr_clobber_ayfx(__DO_SFX3, DO_SFX3, d, u, dp)
#define __MC6809_jsr_clobber_ayfx(args...)	__mc6809_jsr_clobber_ayfx(args)

#ifdef OMMIT_FRAMEPOINTER


#define __mc6809_jsr_clobber_ayfx(func, name, regs...) { \
	__ass( \
		"jsr " #func "; " #name "\n\t" \
		:: \
		: "s", "memory", "cc","a","b","d","dp","u"); \
}


#else

#define __mc6809_jsr_clobber_ayfx(func, name, regs...) { \
	__ass( \
		"pshs u\n\t" \
		"jsr " #func "; " #name "\n\t" \
		"puls u\n\t" \
		:: \
		: "s", "memory", "cc","a","b","d","dp"); \
}


#endif


__INLINE void ayfx_sound1() \
  {asm_ayfx_sound1(); } 
__INLINE void ayfx_sound2() \
  {asm_ayfx_sound2(); } 
__INLINE void ayfx_sound3() \
  {asm_ayfx_sound3(); } 




