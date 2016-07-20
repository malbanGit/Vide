; all letters start at the bottom left and end at the bottom right
; hight of font is 9
; width is 5 + 1 space == 6
; (Turtle is wider!)

BLOWUP = 12 ; max = 126

_abc:
ABC:
 DW ABC_0 ; list of all single vectorlists in this
 DW ABC_1
 DW ABC_2
 DW ABC_3
 DW ABC_4
 DW ABC_5
 DW ABC_6
 DW ABC_7
 DW ABC_8
 DW ABC_9
 DW ABC_10
 DW ABC_11
 DW ABC_12
 DW ABC_13
 DW ABC_14
 DW ABC_15
 DW ABC_16
 DW ABC_17
 DW ABC_18
 DW ABC_19
 DW ABC_20
 DW ABC_21
 DW ABC_22
 DW ABC_23
 DW ABC_24
 DW ABC_25
 DW ABC_26; dot
 DW ABC_27; turtle
 DW ABC_28; space

ABC_0:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $02, +BLOWUP*$05, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$05, +BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$05, +BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$05 ; mode, y, x
 DB $00, +BLOWUP*$00, +BLOWUP*$05 ; mode, y, x
 DB $02, -BLOWUP*$05, +BLOWUP*$00 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_1:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$03 ; mode, y, x
 DB $02, -BLOWUP*$02, +BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$02, -BLOWUP*$02 ; mode, y, x
 DB $02, -BLOWUP*$02, +BLOWUP*$03 ; mode, y, x
 DB $02, -BLOWUP*$03, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_2:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$09, +BLOWUP*$05 ; mode, y, x
 DB $02, +BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$03 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$08, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$03 ; mode, y, x
 DB $02, +BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $00, -BLOWUP*$01, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_3:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$03 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$04, +BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$04, -BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$03 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_4:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$00, +BLOWUP*$05 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$05 ; mode, y, x
 DB $02, +BLOWUP*$04, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$01, +BLOWUP*$04 ; mode, y, x
 DB $02, +BLOWUP*$01, -BLOWUP*$04 ; mode, y, x
 DB $02, +BLOWUP*$04, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$05 ; mode, y, x
 DB $00, -BLOWUP*$0A, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_5:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $02, +BLOWUP*$04, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$01, +BLOWUP*$04 ; mode, y, x
 DB $02, +BLOWUP*$01, -BLOWUP*$04 ; mode, y, x
 DB $02, +BLOWUP*$04, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$05 ; mode, y, x
 DB $00, -BLOWUP*$0A, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_6:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$09, +BLOWUP*$05 ; mode, y, x
 DB $02, +BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$03 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$08, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$03 ; mode, y, x
 DB $02, +BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$04, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$04 ; mode, y, x
 DB $00, -BLOWUP*$05, -BLOWUP*$01 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_7:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $00, -BLOWUP*$05, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$05 ; mode, y, x
 DB $00, +BLOWUP*$05, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_8:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$04 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$04 ; mode, y, x
 DB $00, -BLOWUP*$0A, -BLOWUP*$04 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_9:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$01, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$03 ; mode, y, x
 DB $02, +BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$09, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$05 ; mode, y, x
 DB $00, -BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_10:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $00, -BLOWUP*$05, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$05, +BLOWUP*$04 ; mode, y, x
 DB $00, -BLOWUP*$05, -BLOWUP*$04 ; mode, y, x
 DB $02, -BLOWUP*$05, +BLOWUP*$05 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_11:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$05 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_12:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$05, +BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$05, +BLOWUP*$02 ; mode, y, x
 DB $02, -BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_13:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$0A, +BLOWUP*$05 ; mode, y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $00, -BLOWUP*$0A, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_14:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$00, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$08, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$03 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$08, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$03 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$01 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_15:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$04 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$03, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$04 ; mode, y, x
 DB $00, -BLOWUP*$05, +BLOWUP*$00 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_16:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$00, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$08, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$03 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$08, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$03 ; mode, y, x
 DB $00, +BLOWUP*$03, +BLOWUP*$02 ; mode, y, x
 DB $02, -BLOWUP*$03, +BLOWUP*$03 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$06 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_17:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$04 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$03, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$04 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$03 ; mode, y, x
 DB $02, -BLOWUP*$05, +BLOWUP*$02 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_18:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$09, +BLOWUP*$05 ; mode, y, x
 DB $02, +BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$03 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$03, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$03 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$03, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$03 ; mode, y, x
 DB $02, +BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $00, -BLOWUP*$01, +BLOWUP*$00 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_19:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$00, +BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$03 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$06 ; mode, y, x
 DB $00, -BLOWUP*$0A, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_20:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$09, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$03 ; mode, y, x
 DB $02, +BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$09, +BLOWUP*$00 ; mode, y, x
 DB $00, -BLOWUP*$0A, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_21:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$0A, +BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$02 ; mode, y, x
 DB $00, -BLOWUP*$0A, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_22:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$04, +BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$04, +BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $00, -BLOWUP*$0A, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_23:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $02, +BLOWUP*$0A, +BLOWUP*$05 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$05 ; mode, y, x
 DB $02, -BLOWUP*$0A, +BLOWUP*$05 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_24:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$05, +BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$05, +BLOWUP*$02 ; mode, y, x
 DB $00, -BLOWUP*$05, -BLOWUP*$02 ; mode, y, x
 DB $02, -BLOWUP*$05, +BLOWUP*$00 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$02 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_25:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$0A, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$05 ; mode, y, x
 DB $02, -BLOWUP*$0A, -BLOWUP*$05 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$05 ; mode, y, x
 DB $00, +BLOWUP*$00, -BLOWUP*$05 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_26:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$02, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$02 ; mode, y, x
 DB $02, -BLOWUP*$02, +BLOWUP*$00 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_27:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
 DB $00, +BLOWUP*$05, +BLOWUP*$00 ; mode, y, x
 DB $02, +BLOWUP*$02, +BLOWUP*$02 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$02, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$02, -BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$00, +BLOWUP*$02 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$01, +BLOWUP*$03 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$04 ; mode, y, x
 DB $02, +BLOWUP*$01, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$03, +BLOWUP*$02 ; mode, y, x
 DB $02, -BLOWUP*$03, -BLOWUP*$02 ; mode, y, x
 DB $02, -BLOWUP*$01, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$01, +BLOWUP*$00 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$04 ; mode, y, x
 DB $02, +BLOWUP*$01, -BLOWUP*$03 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$01 ; mode, y, x
 DB $02, +BLOWUP*$00, -BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$02, +BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$02, -BLOWUP*$01 ; mode, y, x
 DB $02, -BLOWUP*$01, -BLOWUP*$02 ; mode, y, x
 DB $02, +BLOWUP*$02, -BLOWUP*$02 ; mode, y, x
 DB $00, -BLOWUP*$05, +BLOWUP*$00 ; mode, y, x
 DB $01 ; endmarker (1)
ABC_28:
 DB $00, +BLOWUP*$00, +BLOWUP*$00 ; move to y, x
; DB $00, +BLOWUP*$00, +BLOWUP*$06 ; mode, y, x
 DB $01 ; endmarker (1)

