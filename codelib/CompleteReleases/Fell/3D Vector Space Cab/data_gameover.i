; Game over state data
; By Fell^DSS, Ludum Dare 38 \p/

; ***** Game over text *****
gameover_text:
	db 'GAME OVER',$80
	
cta_text:
	db 'ANY BUTTON TO RETRY',$80	

hs_label:
	db 'CURRENT BEST',$80
	
new_hs_label:
	db 'NEW HI SCORE',$80
	
; ***** Crashed UFO pic *****

crashed_ufo_pic:
	db $02, +$10, +$6a
	db $00, -$0c, -$52
	db $02, +$16, -$0c
	db $02, +$24, -$0c
	db $02, +$0c, +$00
	db $02, +$04, +$04
	db $02, +$00, +$04
	db $02, -$18, +$17
	db $02, +$00, +$13
	db $02, -$04, +$10
	db $02, -$10, +$0c
	db $02, -$0c, +$04
	db $02, -$06, +$00
	db $00, +$26, -$33
	db $02, -$0c, +$03
	db $02, -$14, +$08
	db $02, -$0e, +$08
	db $00, +$3e, +$10
	db $02, +$14, +$0c
	db $02, -$10, +$08
	db $02, +$14, +$10
	db $00, -$38, -$76
	db $02, +$14, -$10
	db $02, -$1c, -$08
	db $02, +$28, -$10
	db $00, -$7e, +$1c
	db $02, +$2c, +$00
	db $02, +$00, +$0c
	db $02, -$04, +$04
	db $02, -$08, +$00
	db $02, -$04, -$04
	db $02, +$00, -$04
	db $02, -$1c, +$08
	db $00, +$00, +$76
	db $02, +$2c, +$00
	db $02, +$00, +$0c
	db $02, -$04, +$04
	db $02, -$08, +$00
	db $02, -$04, -$04
	db $02, +$00, -$08
	db $00, +$10, -$44
	db $02, -$2c, +$00
	db $01
