; this file is part of Release, written by Malban in 2017
;
; all letters start at the bottom left 
; hight of font is 8
; width is 4 
; if commented out lines are used, the draw "returns" to its starting point
;
; the definition is conform to the clipping used - meaning
; each letter is divideable by a power of two
; in this case even all letters are dividable by "8" (see BLOW_UP)

BLOW_UP = 8 ; max = 64

_abc:
ABC: ;#isfunction
 DW ABC_0 ; A list of all single vectorlists in this
 DW ABC_1 ; B
 DW ABC_2 ; C
 DW ABC_3 ; D
 DW ABC_4 ; E
 DW ABC_5 ; F
 DW ABC_6 ; G
 DW ABC_7 ; H
 DW ABC_8 ; I
 DW ABC_9 ; J
 DW ABC_10 ; K
 DW ABC_11 ; L
 DW ABC_12 ; M
 DW ABC_13 ; N
 DW ABC_14 ; O
 DW ABC_15 ; P
 DW ABC_16 ; Q
 DW ABC_17 ; R
 DW ABC_18 ; S
 DW ABC_19 ; T
 DW ABC_20 ; U
 DW ABC_21 ; V
 DW ABC_22 ; W
 DW ABC_23 ; X
 DW ABC_24 ; Y
 DW ABC_25 ; Z
 DW ABC_26; dot
 DW ABC_28; space
 DW ABC_29; ! - only used in greetings for VectrexMad! :-)


ABC_0:
ABC_0__1:
 DB $ff, +$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$04*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $00, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
; DB $00, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_1:
 DB $ff, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_2:
 DB $00, +$06*BLOW_UP, +$04*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, +$00*BLOW_UP ; mode, y, x
; DB $00, -$02*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_3:
 DB $ff, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_4:
 DB $00, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $ff, +$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
 DB $00, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $ff, +$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
; DB $00, -$08*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_5:
 DB $ff, +$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $00, +$00*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, +$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
; DB $00, -$08*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_6:
 DB $00, +$06*BLOW_UP, +$04*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, -$02*BLOW_UP ; mode, y, x
; DB $00, -$04*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_7:
 DB $ff, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $00, -$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
 DB $00, +$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
; DB $00, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_8:
 DB $ff, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
 DB $00, +$00*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $00, +$00*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
; DB $00, -$08*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_9:
 DB $00, +$02*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$06*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
; DB $00, -$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_10:
 DB $ff, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $00, -$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$04*BLOW_UP, +$04*BLOW_UP ; mode, y, x
 DB $00, -$04*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$04*BLOW_UP ; mode, y, x
; DB $00, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_11:
 DB $00, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
; DB $00, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_12:
 DB $ff, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$04*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
; DB $00, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_13:
 DB $ff, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$08*BLOW_UP, +$04*BLOW_UP ; mode, y, x
 DB $ff, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
; DB $00, -$08*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_14:
 DB $00, +$00*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, +$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
; DB $00, +$00*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_15:
 DB $ff, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
; DB $00, -$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_16:
 DB $00, +$00*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, +$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $00, +$02*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $00, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_17:
 DB $ff, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $00, +$00*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$02*BLOW_UP ; mode, y, x
; DB $00, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_18:
 DB $00, +$02*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $00, +$04*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$01*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$01*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, -$02*BLOW_UP ; mode, y, x
; DB $00, -$02*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_19:
 DB $00, +$00*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $00, +$00*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
; DB $00, -$08*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_20:
 DB $00, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
 DB $ff, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
; DB $00, -$08*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_21:
 DB $00, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$08*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$08*BLOW_UP, +$02*BLOW_UP ; mode, y, x
; DB $00, -$08*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_22:
 DB $00, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$04*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
; DB $00, -$08*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_23:
 DB $ff, +$08*BLOW_UP, +$04*BLOW_UP ; mode, y, x
 DB $00, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $ff, -$08*BLOW_UP, +$04*BLOW_UP ; mode, y, x
; DB $00, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_24:
 DB $00, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$04*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $00, -$04*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
; DB $00, +$00*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_25:
 DB $00, +$08*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
 DB $ff, -$08*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$04*BLOW_UP ; mode, y, x
; DB $00, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)
ABC_26:
 DB $ff, +$00*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)

ABC_28:;" "
; DB $00, +$00*BLOW_UP, +$00*BLOW_UP ; mode, y, x
; DB $00, +$00*BLOW_UP, -$04*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)

ABC_29:; "!"
 DB $ff, +$00*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, +$02*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $ff, -$02*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $00, +$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, +$02*BLOW_UP ; mode, y, x
 DB $ff, -$04*BLOW_UP, +$00*BLOW_UP ; mode, y, x
 DB $ff, +$00*BLOW_UP, -$02*BLOW_UP ; mode, y, x
 DB $01 ; endmarker (1)

