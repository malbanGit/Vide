*****************************************************************************
* twistex
*
* 256 byte twister for vectrex
* assembles fine with as09
*
* ultra^orb 20090306
*
* (c) 2009 orb
*****************************************************************************
* some defines
*****************************************************************************

height		equ	16
barcount	equ	13
starty		equ	((barcount*height/2)*-1)-4
off1		equ	92
off2		equ	105
*****************************************************************************

		include	"vectrex.i"

*****************************************************************************

		org	0

oldx		equ	$c880
tab		equ	oldx+1

dummy		equ	tab + 5
dummy2		equ	dummy + 2
bars		equ	dummy2 + 2
barsb		equ	bars + 2
sintab2		equ	barsb + 2

rotdat		equ	sintab2 + 256

;***************************************************************************
; header section
;***************************************************************************
		db	"g GCE 1998", $80       ; 'g' is copyright sign
		dw	music8                  ; music from the rom
		db	0                       ; end of game header	
;***************************************************************************
; here we go
;***************************************************************************
start:
; sin fake gen
		ldx	#128
		stx	<VIA_t2_hi

		ldy	#$3f0>>2
singen
		tfr	y,d
		addd	<VIA_t2_hi
		std	<VIA_t2_hi

		sta	sintab2-1,x		;1
		coma
		sta	sintab2-1+128,x		;3

		leay	-($4),y
		leax	-1,x
		bne	singen

;***************************************************************************
		ldy	#$7c00+(orblinecount)
doorb:
;		jsr	debugmode
		
		bsr	domusic

		tfr	y,d
		jsr	Intensity_a

		tfr	y,d
		ldx	#o_dat
		ldu	#rotdat
		jsr	Rot_VL_ab
		clrb
		jsr     Moveto_d


		tfr	y,d
		
		deca
		beq	main
		tfr	d,y
		exg	a,b
		
		ldx	#rotdat
		jsr	Draw_VL_ab

		bra	doorb
;***************************************************************************

main:
		bsr	domusic

		ldd	dummy
		tfr	d,x
		comb
		tfr	d,y

		bsr	drawdoubletripleshitfuckfuck
		bsr	drawdoubletripleshitfuckfuck
		bsr	drawdoubletripleshitfuckfuck

		bra     main                    ; loop da fuck ;)
;***************************************************************************
domusic:
		pshs	y
                jsr     DP_to_C8
                tst	<Vec_Music_Flag
                bne	norestart
                inc     <Vec_Music_Flag  ; get ready to face the music
norestart
		dec	<dummy+1

		ldu	#$fe76
                jsr     Init_Music_chk  ; initialize the music

                jsr     Wait_Recal      ; vectrex bios recalibration
                jsr     Do_Sound        ; play the sound
                puls	y
		rts
;***************************************************************************
drawdoubletripleshitfuckfuck
		pshs	x,y
		lda	#barcount
		sta	bars

		ldd	#(starty*256)
		stb	oldx

		jsr     Moveto_d
drawbarsloop

		leay	-8,y
		leax	-10,x
		
		tfr	x,d
		clra
		tfr	d,x

		tfr	y,d
		
		addb	sintab2,x
		clra
		tfr	d,u

 		subb	#off1
		cmpb	#256-off2-off1
		blo	nooff
		lda	#$7f
nooff		
		jsr	Intensity_a

		ldb	sintab2,u

		lda	#height

  		pshs	b,x
		subb	oldx
   		jsr     Draw_Line_d

   		puls	b,x
   		stb	oldx

		dec	bars
		bne	drawbarsloop

		lda	#(barcount*height*-1)-starty
		comb
		jsr     Moveto_d

		puls	x,y
		leay	85,y
doorbend
		rts
;***************************************************************************
orblinecount	equ	17-1
size		equ	25
size1		equ	size
size2		equ	size*2
size3		equ	size*3
size4		equ	size*4
size5		equ	size*5
o_dat:
;r part
		db	size1, size2
		db	size1, -size4

		db	-size4, 0
;3
;o
		db	0,-size1	;space
		
		db	size4,0
		db	0,-size4
		db	-size4,0
		db	0,size4
;8		
		db	0,size5		;space
;r part 2
;10
		db	size2,-size2
		db	-size2,size2
		db	0,size1		;space
;13
;b
		db	size4, 0
		db	-size1, size4
		db	-size1, -size2
		db	-size1, size2
		db	-size1, -size4
		db	"ULTRA'09"
;***************************************************************************
;	include	"debug.asm"
;***************************************************************************
	end	main
;***************************************************************************