#include <vectrex.h>

/*
 example to play a song
...
#include "arkosPlayer.h"
extern const void* VTK1_SongAddress;
...

THIS VERSION DOES NOT COPY THE GENERATED YM DATA TO THE SHADOW REGISTERS

a copy like:


; ldu #Vec_Music_Work_End+1; +2 since it is "--" first
; ldx #CVec_Music_Work
; lda ,x+
; sta ,-u
; lda ,x+
; sta ,-u
; lda ,x+
; sta ,-u
; lda ,x+
; sta ,-u
; lda ,x+
; sta ,-u
; lda ,x+
; sta ,-u
; lda ,x+
; sta ,-u
; lda ,x+
; sta ,-u
; lda ,x+
; sta ,-u
; lda ,x+
; sta ,-u
; lda ,x+
; sta ,-u
; lda ,x+
; sta ,-u
; lda ,x+
; sta ,-u



Must be done by the C frontend.
With this obmission it is possible to selectivly copy only
register information one needs (like only channel x + y...)



	arkosInit(&VTK1_SongAddress);
	do
	{
		Wait_Recal();
		Do_Sound();
		arkosPlay();
		...
		check_buttons();
	}
	while ( button_1_1_pressed() == 0);
*/

#define __INIT_ARKOS   PLY_INIT
#define __PLAY_ARKOS   PLY_PLAY

#define __ass	asm volatile




#ifdef OMMIT_FRAMEPOINTER

#define __mc6809_jsr_ArkosclobberAll(func, name, regs...) { \
	__ass( \
		"jsr " #func "; " #name "\n\t" \
		:: \
		: "s", "memory", "cc","a","b","d","dp","u","y","x"); \
}
#define __mc6809_jsrArkos_u__dxy(u, func, name, regs...) { \
	__ass( \
		"ldu %[U]\n\t" \
		"jsr " #func "; " #name "\n\t" \
		:: [U] "m" (u) \
		: "memory","d", "u", "x","y","cc"); \
}


#else

#define __mc6809_jsr_ArkosclobberAll(func, name, regs...) { \
	__ass( \
		" pshs u\n\t" \
		" jsr " #func "; " #name "\n\t" \
		" puls u\n\t" \
		:: \
		: "s", "memory", "cc","a","b","d","dp","y","x"); \
}

#define __mc6809_jsrArkos_u__dxy(_u_, func, name, regs...) { \
	__ass( \
		"leax ,u\n\t" \
		"ldu %[U]\n\t" \
		"pshs x\n\t" \
		"jsr " #func "; " #name "\n\t" \
		"puls u" \
		:: [U] "m" (_u_) \
		: "memory","d", "x","y","cc"); \
}

#endif

#define __MC6809_jsr_ArkosclobberAll(args...)	__mc6809_jsr_ArkosclobberAll(args)
#define asm_arkosPlay() \
	__MC6809_jsr_ArkosclobberAll(__PLAY_ARKOS, PLAY_ARKOS, d, u, x, dp)

#define __MC6809_jsrArkos_u__dxy(args...)		__mc6809_jsrArkos_u__dxy(args)
#define asm_arkosInit(U) \
	__MC6809_jsrArkos_u__dxy(U, __INIT_ARKOS, INIT_ARKOS, d, x)

__INLINE void arkosPlay() \
  {asm_arkosPlay(); } 

__INLINE void arkosInit(void* volatile _u_) \
   {asm_arkosInit(_u_); } 

