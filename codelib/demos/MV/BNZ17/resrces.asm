; includes for ressources						

annc_glenz  fcc "VIEW THE INSIDE"
			fcb $80
annc_glenz2 fcc "   OF A CUBE"
			fcb $80
annc_glenz3 fcc "   THROUGH A"
			fcb $80
annc_glenz4 fcc "MAGIC BLOCK :-)"
			fcb $80
loadstring fcc "MV-DOS 69"
			fcb $80
	
prompt2 fcc "C:>BYNZLI17.EXE"
		fcb $80	
prompt3 fcc "LOADING..."
		fcb $80
warn    fcc "CONTAINS MUSIC BY FIESERWOLF"
		fcb $80

annc_elite  fcc " THE ONE "
			fcb $80
annc_elite2 fcc "   AND"
			fcb $80
annc_elite3 fcc "  ONLY"
			fcb $80
annc_elite4 fcc "  ELITE"
			fcb $80
annc_eod	fcc "END OF LINE"
			fcb $80
bresenlogo fcb 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,$80
metalvotzelogo fcb 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,$80


	include "sinus.asm"     ; sine tab
	include "gridtab.asm"
    ; pixels
	include "pix_brsn.asm"
	include "pix_mv3.asm"
	; gfx
	include "gfx_atn.asm"
	include "gfx_grts.asm"
	include "gfx_tits.asm"
	include "gfx_gir2.asm"
	; vid
	include "bnz17ope.asm"
    include "elite.asm"
	include "vid_tun.asm"
	include "vid_ten.asm"
	include "vid_cugl.asm"
	; mus/scp
	include "bnz16mus.asm"      ; including script
	; snd-env
	include "snd.asm"       


