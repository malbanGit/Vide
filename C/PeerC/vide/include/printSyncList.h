#include <vectrex.h>

/*
 example to play a song
...
#include <printSyncList.h>
...
const signed char BaggerExample[]=
{	(signed char) 0x01, -0x5F, +0x00, // sync and move to y, x
	(signed char) 0xFF, +0x20, +0x00, // draw, y, x
	(signed char) 0xFF, -0x20, +0x00, // draw, y, x
	(signed char) 0xFF, +0x00, +0x1F, // draw, y, x
	...
	(signed char) 0xFF, -0x5E, +0x00, // draw, y, x
	(signed char) 0xFF, -0x20, -0x20, // draw, y, x
	(signed char) 0xFF, +0x00, +0x7F, // draw, y, x
	(signed char) 0x02 // endmarker 
};

	do
	{
		Wait_Recal();
		Do_Sound();
		VIA_t1_cnt_lo= MAX_SCALE;
		Moveto_d( BOTTOM_MOST-BOTTOM_MOST/3, 0);

		drawSyncList(&BaggerExample,80,0,120,50);

		check_buttons();
	}
	while ( button_1_1_pressed() == 0);
*/

extern unsigned long draw_synced_list;
#define __ass	asm volatile

#define __PRINT_SYNC_LIST   draw_synced_list

#define __MC6809_jsrSync_abxu__y(args...)		__mc6809_jsrSync_abxu__y(args)
#define asm_drawSyncList(D, X, U) __MC6809_jsrSync_abxu__y(D, X, U, __PRINT_SYNC_LIST, PRINT_SYNC_LIST, d, x, u)


#ifdef OMMIT_FRAMEPOINTER

#define __mc6809_jsrSync_abxu__y(d,x,u, func, name, regs...) { \
	__ass( \
		"ldd %[D]\n\t" \
		"ldx %[X]\n\t" \
		"ldu %[U]\n\t" \
		"jsr " #func "; " #name "\n\t" \
		:: [D] "m" (d),[X] "m" (x),[U] "m" (u) \
		: "memory","d", "u", "x","y","cc"); \
}



#else

#define __mc6809_jsrSync_abxu__y(d,x,u, func, name, regs...) { \
	__ass( \
		"pshs u\n\t" \
		"ldd %[D]\n\t" \
		"ldx %[X]\n\t" \
		"ldu %[U]\n\t" \
		"jsr " #func "; " #name "\n\t" \
		"puls u\n\t" \
		:: [D] "m" (d),[X] "m" (x),[U] "m" (u) \
		: "memory","d", "x","y","cc"); \
}

#endif

// U = address of vectorlist
// X = (y,x) position of vectorlist (this will be point 0,0), positioning on screen
// A = scalefactor "Move" (after sync)
// B = scalefactor "Vector" (vectors in vectorlist)
__INLINE void drawSyncList(
	void* volatile u, 
	signed int y, 
	signed int x, 
	unsigned int scaleMove, 
	unsigned int scaleList)
{	
	unsigned long xReg = ((unsigned long)(((unsigned long)y)<<8)+(((unsigned long)x)&0xff));
	unsigned long dReg = ((unsigned long)(((unsigned long)scaleMove)<<8)+(((unsigned long)scaleList)&0xff));

	asm_drawSyncList(
		dReg,  
		xReg,
		((unsigned long)u) 
	); 
} 






