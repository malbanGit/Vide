; this file is part of Release, written by Malban in 2017
;
;***************************************************************************
; DATA SECTION
;***************************************************************************
; VLMode Lists

BonusExpandList: ;#isfunction
 DB $ff, +$40, +$3F ; mode, y, x
 DB $ff, +$3E, +$00 ; mode, y, x
 DB $ff, +$40, -$3F ; mode, y, x
 DB $00, -$5F, +$5F ; mode, y, x
 DB $ff, +$00, +$3F ; mode, y, x
 DB $ff, +$1F, -$1F ; mode, y, x
 DB $00, -$3E, +$00 ; mode, y, x
 DB $ff, +$1F, +$1F ; mode, y, x
 DB $00, +$7F, -$3F ; mode, y, x
 DB $ff, -$40, +$5F ; mode, y, x
 DB $ff, -$7E, +$00 ; mode, y, x
 DB $ff, -$40, -$5F ; mode, y, x
 DB $01 ; endmarker (1)

BonusFasterList: ;#isfunction
 DB $ff, +$33, +$4C ; mode, y, x
 DB $ff, +$64, +$00 ; mode, y, x
 DB $ff, +$33, -$4C ; mode, y, x
 DB $00, -$65, +$00 ; mode, y, x
 DB $ff, -$32, -$4C ; mode, y, x
 DB $00, +$64, +$00 ; mode, y, x
 DB $ff, -$32, +$4C ; mode, y, x
 DB $ff, +$00, -$7F ; mode, y, x
 DB $01 ; endmarker (1)

BonusShieldList: ;#isfunction
 DB $ff, +$7C, -$5D ; mode, y, x
 DB $ff, +$7F, +$00 ; mode, y, x
 DB $ff, +$00, +$5D ; mode, y, x
 DB $ff, +$00, +$5D ; mode, y, x
 DB $ff, -$7F, +$00 ; mode, y, x
 DB $ff, -$7C, -$5D ; mode, y, x
 DB $01 ; endmarker (1)


Dragonchild_List: ;#isfunction
 DB $00, -$12, -$12 ; mode, y, x
 DB $ff, +$24, +$24 ; mode, y, x
 DB $00, +$00, -$24 ; mode, y, x
 DB $ff, -$24, +$24 ; mode, y, x
 DB $01 ; endmarker (1)

enemyXList_0: ;#isfunction
 DB $00, +$00, -$3F ; mode, y, x
 DB $ff, +$00, +$7E ; mode, y, x
 DB $00, +$3F, -$3F ; mode, y, x
 DB $ff, -$7E, +$00 ; mode, y, x
 DB $01 ; endmarker (1)
enemyXList_1:
 DB $00, +$00, -$32 ; mode, y, x
 DB $ff, +$00, +$64 ; mode, y, x
 DB $00, +$32, -$32 ; mode, y, x
 DB $ff, -$64, +$00 ; mode, y, x
 DB $01 ; endmarker (1)
enemyXList_2:
 DB $00, +$00, -$26 ; mode, y, x
 DB $ff, +$00, +$4C ; mode, y, x
 DB $00, +$26, -$26 ; mode, y, x
 DB $ff, -$4C, +$00 ; mode, y, x
 DB $01 ; endmarker (1)
enemyXList_3:
 DB $00, +$00, -$32 ; mode, y, x
 DB $ff, +$00, +$64 ; mode, y, x
 DB $00, +$32, -$32 ; mode, y, x
 DB $ff, -$64, +$00 ; mode, y, x
 DB $01 ; endmarker (1)



score10: ;#isfunction
 DB $00, +$3F, 0              ; mode, y, x 
 DB $ff, +$00, +$3F ; mode, y, x
 DB $ff, -$7E, +$00 ; mode, y, x
 DB $ff, +$00, -$3F ; mode, y, x
 DB $ff, +$7E, +$00 ; mode, y, x
 DB $00, +$00, -$3F ; mode, y, x
 DB $ff, -$7E, +$00 ; mode, y, x
 DB $01 ; endmarker (1)

score15: ;#isfunction
 DB $ff, +$7F, +$00 ; mode, y, x
 DB $00, -$7F, +$1F ; mode, y, x
 DB $ff, +$00, +$5F ; mode, y, x
 DB $ff, +$3F, +$00 ; mode, y, x
 DB $ff, +$00, -$5F ; mode, y, x
 DB $ff, +$40, +$00 ; mode, y, x
 DB $ff, +$00, +$5F ; mode, y, x
 DB $01 ; endmarker (1)

score18: ;#isfunction
 DB $ff, -$7F, +$00 ; mode, y, x
 DB $00, +$00, +$3F ; mode, y, x
 DB $ff, +$7F, +$5F ; mode, y, x
 DB $ff, +$00, -$5F ; mode, y, x
 DB $ff, -$7F, +$5F ; mode, y, x
 DB $ff, +$00, -$5F ; mode, y, x
 DB $01 ; endmarker (1)

score20: ;#isfunction
 DB $ff, +$00, +$60 ; mode, y, x
 DB $ff, -$7F, -$60 ; mode, y, x
 DB $ff, +$00, +$60 ; mode, y, x
 DB $00, +$00, +$3E ; mode, y, x
 DB $ff, +$00, +$60 ; mode, y, x
 DB $ff, +$7F, +$00 ; mode, y, x
 DB $ff, +$00, -$60 ; mode, y, x
 DB $ff, -$7F, +$00 ; mode, y, x
 DB $01 ; endmarker (1)

score30: ;#isfunction
 DB $ff, +$00, +$60 ; mode, y, x
 DB $ff, -$40, -$40 ; mode, y, x
 DB $ff, -$3F, +$40 ; mode, y, x
 DB $ff, +$00, -$60 ; mode, y, x
 DB $00, +$00, +$7F ; mode, y, x
 DB $ff, +$00, +$5F ; mode, y, x
 DB $ff, +$7F, +$00 ; mode, y, x
 DB $ff, +$00, -$5F ; mode, y, x
 DB $ff, -$7F, +$00 ; mode, y, x
 DB $01 ; endmarker (1)

score36: ;#isfunction
 DB $ff, +$00, +$60 ; mode, y, x
 DB $ff, -$40, -$40 ; mode, y, x
 DB $ff, -$3F, +$40 ; mode, y, x
 DB $ff, +$00, -$60 ; mode, y, x
 DB $00, +$3F, +$7F ; mode, y, x
 DB $ff, -$3F, +$00 ; mode, y, x
 DB $ff, +$00, +$5F ; mode, y, x
 DB $ff, +$3F, +$00 ; mode, y, x
 DB $ff, +$00, -$5F ; mode, y, x
 DB $ff, +$40, +$00 ; mode, y, x
 DB $01 ; endmarker (1)

score45: ;#isfunction
 DB $ff, +$7F, +$00 ; mode, y, x
 DB $ff, -$60, -$60 ; mode, y, x
 DB $ff, +$00, +$7F ; mode, y, x
 DB $00, -$1F, +$3F ; mode, y, x
 DB $ff, +$00, +$5F ; mode, y, x
 DB $ff, +$3F, +$00 ; mode, y, x
 DB $ff, +$00, -$5F ; mode, y, x
 DB $ff, +$40, +$00 ; mode, y, x
 DB $ff, +$00, +$5F ; mode, y, x
 DB $01 ; endmarker (1)

score50: ;#isfunction
 DB $ff, +$00, +$60 ; mode, y, x
 DB $ff, +$3F, +$00 ; mode, y, x
 DB $ff, +$00, -$60 ; mode, y, x
 DB $ff, +$40, +$00 ; mode, y, x
 DB $ff, +$00, +$60 ; mode, y, x
 DB $00, +$00, +$3E ; mode, y, x
 DB $ff, +$00, +$60 ; mode, y, x
 DB $ff, -$7F, +$00 ; mode, y, x
 DB $ff, +$00, -$60 ; mode, y, x
 DB $ff, +$7F, +$00 ; mode, y, x
 DB $01 ; endmarker (1)

score54: ;#isfunction
 DB $ff, +$00, +$5F ; mode, y, x
 DB $ff, +$3F, +$00 ; mode, y, x
 DB $ff, +$00, -$5F ; mode, y, x
 DB $ff, +$40, +$00 ; mode, y, x
 DB $ff, +$00, +$5F ; mode, y, x
 DB $00, -$60, +$3F ; mode, y, x
 DB $ff, +$60, +$5F ; mode, y, x
 DB $ff, -$7F, +$00 ; mode, y, x
 DB $00, +$1F, -$5F ; mode, y, x
 DB $ff, +$00, +$7F ; mode, y, x
 DB $01 ; endmarker (1)

NumberList: ;#isfunction
 DW NumberList_0 ; list of all single vectorlists in this
 DW NumberList_1
 DW NumberList_2
 DW NumberList_3
 DW NumberList_4
 DW NumberList_5
 DW NumberList_6
 DW NumberList_7
 DW NumberList_8
 DW NumberList_9
NumberList_0:
 DB $ff, +$00, +$4C ; mode, y, x
 DB $ff, +$65, +$00 ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $ff, -$65, +$00 ; mode, y, x
 DB $00, +$00, +$7F ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_1:
 DB $00, +$00, $02c ;+$4C ; mode, y, x
 DB $ff, +$65, +$00 ; mode, y, x
 DB $00, -$65, +$5c ;+$33 ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_2:
 DB $00, +$65, +$00 ; mode, y, x
 DB $ff, +$00, +$4C ; mode, y, x
 DB $ff, -$65, -$4C ; mode, y, x
 DB $ff, +$00, +$4C ; mode, y, x
 DB $00, +$00, +$33 ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_3:
 DB $ff, +$00, +$4C ; mode, y, x
 DB $ff, +$32, -$33 ; mode, y, x
 DB $ff, +$33, +$33 ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $00, -$65, +$7F ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_4:
 DB $00, +$00, +$19 ; move to y, x
 DB $00, +$00, +$19 ; mode, y, x
 DB $ff, +$65, +$00 ; mode, y, x
 DB $ff, -$4C, -$32 ; mode, y, x
 DB $ff, +$00, +$4C ; mode, y, x
 DB $00, -$19, +$33 ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_5:
 DB $ff, +$00, +$4C ; mode, y, x
 DB $ff, +$32, +$00 ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $ff, +$33, +$00 ; mode, y, x
 DB $ff, +$00, +$4C ; mode, y, x
 DB $00, -$65, +$33 ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_6:
 DB $ff, +$65, +$00 ; mode, y, x
 DB $00, -$33, +$00 ; mode, y, x
 DB $ff, +$00, +$4C ; mode, y, x
 DB $ff, -$32, +$00 ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $00, +$00, +$7F ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_7:
 DB $ff, +$65, +$4C ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $00, -$65, +$7F ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_8:
 DB $ff, +$65, +$4C ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $ff, -$65, +$4C ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $00, +$00, +$7F ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_9:
 DB $00, +$00, +$4C ; mode, y, x
 DB $ff, +$65, +$00 ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $ff, -$33, +$00 ; mode, y, x
 DB $ff, +$00, +$4C ; mode, y, x
 DB $00, -$32, +$33 ; mode, y, x
 DB $01 ; endmarker (1)



HunterList: ;#isfunction
 DW HunterList_0 ; list of all single vectorlists in this
 DW HunterList_1
 DW HunterList_2
 DW HunterList_3
 DW HunterList_4
 DW HunterList_5
 DW HunterList_6
 DW HunterList_7
 DW HunterList_8
 DW HunterList_9
 DW HunterList_10
 DW HunterList_11
 DW HunterList_12
 DW HunterList_13
 DW HunterList_14
 DW HunterList_15
 DW HunterList_16
 DW HunterList_17
 DW HunterList_18
 DW HunterList_19
 DW HunterList_20
 DW HunterList_21
 DW HunterList_22
 DW HunterList_23

HunterList_0:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB +$3E, -$1A ; draw to y, x
 DB -$7C, +$1A ; draw to y, x
 DB +$7C, +$1A ; draw to y, x
 DB +$00, -$34 ; draw to y, x
HunterList_1:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB +$35, -$29 ; draw to y, x
 DB -$71, +$39 ; draw to y, x
 DB +$7F, -$07 ; draw to y, x
 DB -$0E, -$32 ; draw to y, x
HunterList_2:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB +$29, -$36 ; draw to y, x
 DB -$5F, +$55 ; draw to y, x
 DB +$79, -$27 ; draw to y, x
 DB -$1A, -$2E ; draw to y, x
HunterList_3:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB +$19, -$3E ; draw to y, x
 DB -$45, +$6A ; draw to y, x
 DB +$6A, -$45 ; draw to y, x
 DB -$25, -$25 ; draw to y, x
HunterList_4:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB +$08, -$43 ; draw to y, x
 DB -$27, +$79 ; draw to y, x
 DB +$55, -$5F ; draw to y, x
 DB -$2E, -$1A ; draw to y, x
HunterList_5:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB -$09, -$43 ; draw to y, x
 DB -$07, +$7F ; draw to y, x
 DB +$39, -$71 ; draw to y, x
 DB -$32, -$0E ; draw to y, x
HunterList_6:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB -$1A, -$3E ; draw to y, x
 DB +$1A, +$7C ; draw to y, x
 DB +$1A, -$7C ; draw to y, x
 DB -$34, +$00 ; draw to y, x
HunterList_7:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB -$29, -$35 ; draw to y, x
 DB +$39, +$71 ; draw to y, x
 DB -$07, -$7F ; draw to y, x
 DB -$32, +$0E ; draw to y, x
HunterList_8:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB -$36, -$29 ; draw to y, x
 DB +$55, +$5F ; draw to y, x
 DB -$27, -$79 ; draw to y, x
 DB -$2E, +$1A ; draw to y, x
HunterList_9:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB -$3E, -$19 ; draw to y, x
 DB +$6A, +$45 ; draw to y, x
 DB -$45, -$6A ; draw to y, x
 DB -$25, +$25 ; draw to y, x
HunterList_10:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB -$43, -$08 ; draw to y, x
 DB +$79, +$27 ; draw to y, x
 DB -$5F, -$55 ; draw to y, x
 DB -$1A, +$2E ; draw to y, x
HunterList_11:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB -$43, +$09 ; draw to y, x
 DB +$7F, +$07 ; draw to y, x
 DB -$71, -$39 ; draw to y, x
 DB -$0E, +$32 ; draw to y, x
HunterList_12:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB -$3E, +$1A ; draw to y, x
 DB +$7C, -$1A ; draw to y, x
 DB -$7C, -$1A ; draw to y, x
 DB +$00, +$34 ; draw to y, x
HunterList_13:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB -$35, +$29 ; draw to y, x
 DB +$71, -$39 ; draw to y, x
 DB -$7F, +$07 ; draw to y, x
 DB +$0E, +$32 ; draw to y, x
HunterList_14:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB -$29, +$36 ; draw to y, x
 DB +$5F, -$55 ; draw to y, x
 DB -$79, +$27 ; draw to y, x
 DB +$1A, +$2E ; draw to y, x
HunterList_15:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB -$19, +$3E ; draw to y, x
 DB +$45, -$6A ; draw to y, x
 DB -$6A, +$45 ; draw to y, x
 DB +$25, +$25 ; draw to y, x
HunterList_16:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB -$08, +$43 ; draw to y, x
 DB +$27, -$79 ; draw to y, x
 DB -$55, +$5F ; draw to y, x
 DB +$2E, +$1A ; draw to y, x
HunterList_17:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB +$09, +$43 ; draw to y, x
 DB +$07, -$7F ; draw to y, x
 DB -$39, +$71 ; draw to y, x
 DB +$32, +$0E ; draw to y, x
HunterList_18:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB +$1A, +$3E ; draw to y, x
 DB -$1A, -$7C ; draw to y, x
 DB -$1A, +$7C ; draw to y, x
 DB +$34, +$00 ; draw to y, x
HunterList_19:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB +$29, +$35 ; draw to y, x
 DB -$39, -$71 ; draw to y, x
 DB +$07, +$7F ; draw to y, x
 DB +$32, -$0E ; draw to y, x
HunterList_20:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB +$36, +$29 ; draw to y, x
 DB -$55, -$5F ; draw to y, x
 DB +$27, +$79 ; draw to y, x
 DB +$2E, -$1A ; draw to y, x
HunterList_21:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB +$3E, +$19 ; draw to y, x
 DB -$6A, -$45 ; draw to y, x
 DB +$45, +$6A ; draw to y, x
 DB +$25, -$25 ; draw to y, x
HunterList_22:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB +$43, +$08 ; draw to y, x
 DB -$79, -$27 ; draw to y, x
 DB +$5F, +$55 ; draw to y, x
 DB +$1A, -$2E ; draw to y, x
HunterList_23:
 DW       (MAX_LINE_NUM-($03+1))*ONE_LINE_LENGTH  
 DB +$43, -$09 ; draw to y, x
 DB -$7F, -$07 ; draw to y, x
 DB +$71, +$39 ; draw to y, x
 DB +$0E, -$32 ; draw to y, x



; Starlet list
; count
; move y,x
; data y,x ...
DragonList: ;#isfunction
 DW DragonList_0 ; list of all single vectorlists in this
 DW DragonList_1
 DW DragonList_2
 DW DragonList_3

DragonList_0:
 DW       (MAX_LINE_NUM-($04+1))*ONE_LINE_LENGTH 
 DB +$00, -$4A ; draw to y, x
 DB +$4A, +$4A ; draw to y, x
 DB -$4A, +$4A ; draw to y, x
 DB -$4A, -$4A ; draw to y, x
 DB +$4A, -$4A ; draw to y, x
DragonList_1:
 DW       (MAX_LINE_NUM-($04+1))*ONE_LINE_LENGTH 
 DB +$00, -$46 ; draw to y, x
 DB +$46, +$46 ; draw to y, x
 DB -$46, +$46 ; draw to y, x
 DB -$46, -$46 ; draw to y, x
 DB +$46, -$46 ; draw to y, x
DragonList_2:
 DW       (MAX_LINE_NUM-($04+1))*ONE_LINE_LENGTH 
 DB +$00, -$42 ; draw to y, x
 DB +$42, +$42 ; draw to y, x
 DB -$42, +$42 ; draw to y, x
 DB -$42, -$42 ; draw to y, x
 DB +$42, -$42 ; draw to y, x
DragonList_3:
 DW       (MAX_LINE_NUM-($04+1))*ONE_LINE_LENGTH 
 DB +$00, -$46 ; draw to y, x
 DB +$46, +$46 ; draw to y, x
 DB -$46, +$46 ; draw to y, x
 DB -$46, -$46 ; draw to y, x
 DB +$46, -$46 ; draw to y, x


; Starlet list
; count
; move y,x
; data y,x ...

StarletList: ;#isfunction
 DW StarletList_0 ; list of all single vectorlists in this
 DW StarletList_1
 DW StarletList_2
 DW StarletList_3
 DW StarletList_4
 DW StarletList_5
 DW StarletList_6
 DW StarletList_7
 DW StarletList_8
 DW StarletList_9
 DW StarletList_10


StarletList_0:
 DW       (MAX_LINE_NUM-($0a+1))*ONE_LINE_LENGTH 
 DB +$24, -$14 ; draw to y, x
 DB -$02, -$38 ; draw to y, x
 DB -$2A, +$23 ; draw to y, x
 DB -$37, -$0F ; draw to y, x
 DB +$15, +$35 ; draw to y, x
 DB -$1F, +$2D ; draw to y, x
 DB +$38, -$03 ; draw to y, x
 DB +$21, +$2B ; draw to y, x
 DB +$0E, -$36 ; draw to y, x
 DB +$36, -$14 ; draw to y, x
 DB -$30, -$1C ; draw to y, x
StarletList_1:
 DW       (MAX_LINE_NUM-($0a+1))*ONE_LINE_LENGTH 
 DB +$21, -$18 ; draw to y, x
 DB -$08, -$37 ; draw to y, x
 DB -$26, +$27 ; draw to y, x
 DB -$38, -$08 ; draw to y, x
 DB +$1B, +$32 ; draw to y, x
 DB -$1A, +$30 ; draw to y, x
 DB +$38, -$09 ; draw to y, x
 DB +$25, +$27 ; draw to y, x
 DB +$08, -$38 ; draw to y, x
 DB +$33, -$1A ; draw to y, x
 DB -$33, -$16 ; draw to y, x
StarletList_2:
 DW       (MAX_LINE_NUM-($0a+1))*ONE_LINE_LENGTH 
 DB +$1F, -$1C ; draw to y, x
 DB -$0F, -$36 ; draw to y, x
 DB -$21, +$2C ; draw to y, x
 DB -$39, -$02 ; draw to y, x
 DB +$20, +$2F ; draw to y, x
 DB -$14, +$32 ; draw to y, x
 DB +$36, -$0F ; draw to y, x
 DB +$2A, +$22 ; draw to y, x
 DB +$02, -$38 ; draw to y, x
 DB +$30, -$1F ; draw to y, x
 DB -$35, -$11 ; draw to y, x
StarletList_3:
 DW       (MAX_LINE_NUM-($0a+1))*ONE_LINE_LENGTH 
 DB +$1B, -$1F ; draw to y, x
 DB -$15, -$34 ; draw to y, x
 DB -$1B, +$2F ; draw to y, x
 DB -$39, +$04 ; draw to y, x
 DB +$25, +$2B ; draw to y, x
 DB -$0E, +$35 ; draw to y, x
 DB +$34, -$16 ; draw to y, x
 DB +$2E, +$1E ; draw to y, x
 DB -$05, -$38 ; draw to y, x
 DB +$2C, -$25 ; draw to y, x
 DB -$37, -$0A ; draw to y, x
StarletList_4:
 DW       (MAX_LINE_NUM-($0a+1))*ONE_LINE_LENGTH 
 DB +$17, -$22 ; draw to y, x
 DB -$1A, -$31 ; draw to y, x
 DB -$16, +$32 ; draw to y, x
 DB -$38, +$0B ; draw to y, x
 DB +$2A, +$26 ; draw to y, x
 DB -$08, +$36 ; draw to y, x
 DB +$31, -$1C ; draw to y, x
 DB +$31, +$19 ; draw to y, x
 DB -$0C, -$37 ; draw to y, x
 DB +$28, -$2A ; draw to y, x
 DB -$38, -$04 ; draw to y, x
StarletList_5:
 DW       (MAX_LINE_NUM-($0a+1))*ONE_LINE_LENGTH 
 DB +$13, -$24 ; draw to y, x
 DB -$1F, -$2E ; draw to y, x
 DB -$11, +$34 ; draw to y, x
 DB -$36, +$11 ; draw to y, x
 DB +$2E, +$21 ; draw to y, x
 DB -$02, +$37 ; draw to y, x
 DB +$2E, -$21 ; draw to y, x
 DB +$33, +$12 ; draw to y, x
 DB -$12, -$35 ; draw to y, x
 DB +$23, -$2E ; draw to y, x
 DB -$38, +$03 ; draw to y, x
StarletList_6:
 DW       (MAX_LINE_NUM-($0a+1))*ONE_LINE_LENGTH 
 DB +$0F, -$26 ; draw to y, x
 DB -$25, -$2A ; draw to y, x
 DB -$0A, +$35 ; draw to y, x
 DB -$34, +$18 ; draw to y, x
 DB +$32, +$1B ; draw to y, x
 DB +$04, +$37 ; draw to y, x
 DB +$2A, -$26 ; draw to y, x
 DB +$34, +$0C ; draw to y, x
 DB -$17, -$32 ; draw to y, x
 DB +$1D, -$32 ; draw to y, x
 DB -$37, +$09 ; draw to y, x
StarletList_7:
 DW       (MAX_LINE_NUM-($0a+1))*ONE_LINE_LENGTH 
 DB +$0B, -$28 ; draw to y, x
 DB -$2A, -$25 ; draw to y, x
 DB -$04, +$36 ; draw to y, x
 DB -$31, +$1D ; draw to y, x
 DB +$35, +$16 ; draw to y, x
 DB +$0A, +$36 ; draw to y, x
 DB +$25, -$2B ; draw to y, x
 DB +$36, +$07 ; draw to y, x
 DB -$1D, -$30 ; draw to y, x
 DB +$17, -$35 ; draw to y, x
 DB -$35, +$0F ; draw to y, x
StarletList_8:
 DW       (MAX_LINE_NUM-($0a+1))*ONE_LINE_LENGTH 
 DB +$06, -$29 ; draw to y, x
 DB -$2D, -$20 ; draw to y, x
 DB +$02, +$36 ; draw to y, x
 DB -$2E, +$23 ; draw to y, x
 DB +$37, +$0F ; draw to y, x
 DB +$11, +$34 ; draw to y, x
 DB +$20, -$2E ; draw to y, x
 DB +$36, +$00 ; draw to y, x
 DB -$23, -$2C ; draw to y, x
 DB +$12, -$37 ; draw to y, x
 DB -$34, +$15 ; draw to y, x
StarletList_9:
 DW       (MAX_LINE_NUM-($0a+1))*ONE_LINE_LENGTH 
 DB +$01, -$29 ; draw to y, x
 DB -$31, -$1B ; draw to y, x
 DB +$09, +$36 ; draw to y, x
 DB -$29, +$27 ; draw to y, x
 DB +$38, +$09 ; draw to y, x
 DB +$16, +$32 ; draw to y, x
 DB +$1B, -$31 ; draw to y, x
 DB +$35, -$06 ; draw to y, x
 DB -$27, -$28 ; draw to y, x
 DB +$0B, -$39 ; draw to y, x
 DB -$31, +$1B ; draw to y, x
StarletList_10:
 DW       (MAX_LINE_NUM-($0a+1))*ONE_LINE_LENGTH 
 DB -$03, -$29 ; draw to y, x
 DB -$34, -$15 ; draw to y, x
 DB +$0E, +$34 ; draw to y, x
 DB -$24, +$2C ; draw to y, x
 DB +$39, +$03 ; draw to y, x
 DB +$1C, +$2F ; draw to y, x
 DB +$14, -$34 ; draw to y, x
 DB +$35, -$0C ; draw to y, x
 DB -$2B, -$24 ; draw to y, x
 DB +$04, -$39 ; draw to y, x
 DB -$2D, +$20 ; draw to y, x



BomberList: ;#isfunction
 DW BomberList_0 ; list of all single vectorlists in this
 DW BomberList_1
 DW BomberList_2
 DW BomberList_3
 DW BomberList_4
 DW BomberList_5
 DW BomberList_6
 DW BomberList_7
 DW BomberList_8

BomberList_0:
 DW       (MAX_LINE_NUM-($08+1))*ONE_LINE_LENGTH
 DB +$45, +$00 ; draw to y, x
 DB -$12, +$33 ; draw to y, x
 DB -$33, +$12 ; draw to y, x
 DB -$33, -$12 ; draw to y, x
 DB -$12, -$33 ; draw to y, x
 DB +$12, -$33 ; draw to y, x
 DB +$33, -$12 ; draw to y, x
 DB +$33, +$12 ; draw to y, x
 DB +$12, +$33 ; draw to y, x
BomberList_1:
 DW       (MAX_LINE_NUM-($08+1))*ONE_LINE_LENGTH
 DB +$45, -$05 ; draw to y, x
 DB -$0D, +$33 ; draw to y, x
 DB -$33, +$17 ; draw to y, x
 DB -$33, -$0D ; draw to y, x
 DB -$17, -$33 ; draw to y, x
 DB +$0D, -$33 ; draw to y, x
 DB +$33, -$17 ; draw to y, x
 DB +$33, +$0D ; draw to y, x
 DB +$17, +$33 ; draw to y, x
BomberList_2:
 DW       (MAX_LINE_NUM-($08+1))*ONE_LINE_LENGTH
 DB +$45, -$0B ; draw to y, x
 DB -$0A, +$34 ; draw to y, x
 DB -$30, +$1C ; draw to y, x
 DB -$34, -$0A ; draw to y, x
 DB -$1C, -$30 ; draw to y, x
 DB +$0A, -$34 ; draw to y, x
 DB +$30, -$1C ; draw to y, x
 DB +$34, +$0A ; draw to y, x
 DB +$1C, +$30 ; draw to y, x
BomberList_3:
 DW       (MAX_LINE_NUM-($08+1))*ONE_LINE_LENGTH
 DB +$44, -$12 ; draw to y, x
 DB -$05, +$36 ; draw to y, x
 DB -$2D, +$20 ; draw to y, x
 DB -$36, -$05 ; draw to y, x
 DB -$20, -$2D ; draw to y, x
 DB +$05, -$36 ; draw to y, x
 DB +$2D, -$20 ; draw to y, x
 DB +$36, +$05 ; draw to y, x
 DB +$20, +$2D ; draw to y, x
BomberList_4:
 DW       (MAX_LINE_NUM-($08+1))*ONE_LINE_LENGTH
 DB +$41, -$17 ; draw to y, x
 DB +$01, +$35 ; draw to y, x
 DB -$2B, +$23 ; draw to y, x
 DB -$35, +$01 ; draw to y, x
 DB -$23, -$2B ; draw to y, x
 DB -$01, -$35 ; draw to y, x
 DB +$2B, -$23 ; draw to y, x
 DB +$35, -$01 ; draw to y, x
 DB +$23, +$2B ; draw to y, x
BomberList_5:
 DW       (MAX_LINE_NUM-($08+1))*ONE_LINE_LENGTH
 DB +$3F, -$1D ; draw to y, x
 DB +$06, +$35 ; draw to y, x
 DB -$28, +$27 ; draw to y, x
 DB -$35, +$06 ; draw to y, x
 DB -$27, -$28 ; draw to y, x
 DB -$06, -$35 ; draw to y, x
 DB +$28, -$27 ; draw to y, x
 DB +$35, -$06 ; draw to y, x
 DB +$27, +$28 ; draw to y, x
BomberList_6:
 DW       (MAX_LINE_NUM-($08+1))*ONE_LINE_LENGTH
 DB +$3C, -$22 ; draw to y, x
 DB +$0A, +$34 ; draw to y, x
 DB -$24, +$2A ; draw to y, x
 DB -$34, +$0A ; draw to y, x
 DB -$2A, -$24 ; draw to y, x
 DB -$0A, -$34 ; draw to y, x
 DB +$24, -$2A ; draw to y, x
 DB +$34, -$0A ; draw to y, x
 DB +$2A, +$24 ; draw to y, x
BomberList_7:
 DW       (MAX_LINE_NUM-($08+1))*ONE_LINE_LENGTH
 DB +$39, -$27 ; draw to y, x
 DB +$0F, +$33 ; draw to y, x
 DB -$21, +$2D ; draw to y, x
 DB -$33, +$0F ; draw to y, x
 DB -$2D, -$21 ; draw to y, x
 DB -$0F, -$33 ; draw to y, x
 DB +$21, -$2D ; draw to y, x
 DB +$33, -$0F ; draw to y, x
 DB +$2D, +$21 ; draw to y, x
BomberList_8:
 DW       (MAX_LINE_NUM-($08+1))*ONE_LINE_LENGTH
 DB +$35, -$2C ; draw to y, x
 DB +$14, +$32 ; draw to y, x
 DB -$1D, +$2F ; draw to y, x
 DB -$32, +$14 ; draw to y, x
 DB -$2F, -$1D ; draw to y, x
 DB -$14, -$32 ; draw to y, x
 DB +$1D, -$2F ; draw to y, x
 DB +$32, -$14 ; draw to y, x
 DB +$2F, +$1D ; draw to y, x

ShotList_0:
 DW       (MAX_LINE_NUM_A-($03+1))*ONE_LINE_LENGTH
 DB +$28, +$28 ; draw to y, x
 DB -$28, +$28 ; draw to y, x
 DB -$28, -$28 ; draw to y, x
 DB +$28, -$28 ; draw to y, x


BonusList: ;#isfunction
 DW BonusList_0 ; list of all single vectorlists in this
 DW BonusList_1
 DW BonusList_2
 DW BonusList_3
 DW BonusList_4
 DW BonusList_5
 DW BonusList_6
 DW BonusList_7
 DW BonusList_8
 DW BonusList_9
 DW BonusList_10
 DW BonusList_11
 DW BonusList_12
 DW BonusList_13
 DW BonusList_14
 DW BonusList_15
 DW BonusList_16

BonusList_0:
 DB $00, +$24, -$1D ; mode, y, x
 DB $ff, +$18, +$1D ; mode, y, x
 DB $ff, -$18, +$1D ; mode, y, x
 DB $ff, -$21, -$1D ; mode, y, x
 DB $ff, -$27, +$00 ; mode, y, x
 DB $00, -$19, +$00 ; mode, y, x
 DB $ff, +$00, +$04 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_1:
 DB $00, +$18, -$28 ; mode, y, x
 DB $ff, +$20, +$14 ; mode, y, x
 DB $ff, -$0B, +$21 ; mode, y, x
 DB $ff, -$2A, -$0D ; mode, y, x
 DB $ff, -$25, +$0C ; mode, y, x
 DB $00, -$17, +$09 ; mode, y, x
 DB $ff, +$03, +$05 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_2:
 DB $00, +$07, -$2F ; mode, y, x
 DB $ff, +$25, +$07 ; mode, y, x
 DB $ff, +$03, +$26 ; mode, y, x
 DB $ff, -$2D, +$00 ; mode, y, x
 DB $ff, -$1D, +$1A ; mode, y, x
 DB $00, -$11, +$10 ; mode, y, x
 DB $ff, +$04, +$04 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_3:
 DB $00, -$08, -$2E ; mode, y, x
 DB $ff, +$22, -$08 ; mode, y, x
 DB $ff, +$11, +$23 ; mode, y, x
 DB $ff, -$2A, +$10 ; mode, y, x
 DB $ff, -$10, +$24 ; mode, y, x
 DB $00, -$0B, +$15 ; mode, y, x
 DB $ff, +$06, +$03 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_4:
 DB $00, -$18, -$28 ; mode, y, x
 DB $ff, +$1C, -$14 ; mode, y, x
 DB $ff, +$1C, +$1A ; mode, y, x
 DB $ff, -$20, +$1F ; mode, y, x
 DB $ff, -$02, +$27 ; mode, y, x
 DB $00, -$02, +$19 ; mode, y, x
 DB $ff, +$04, +$00 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_5:
 DB $00, -$26, -$1C ; mode, y, x
 DB $ff, +$17, -$1D ; mode, y, x
 DB $ff, +$20, +$0D ; mode, y, x
 DB $ff, -$11, +$29 ; mode, y, x
 DB $ff, +$09, +$27 ; mode, y, x
 DB $00, +$06, +$17 ; mode, y, x
 DB $ff, +$07, -$02 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_6:
 DB $00, -$2E, -$0B ; mode, y, x
 DB $ff, +$0A, -$25 ; mode, y, x
 DB $ff, +$24, +$01 ; mode, y, x
 DB $ff, -$02, +$2D ; mode, y, x
 DB $ff, +$18, +$1F ; mode, y, x
 DB $00, +$0E, +$14 ; mode, y, x
 DB $ff, +$04, -$05 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_7:
 DB $00, -$2F, +$04 ; mode, y, x
 DB $ff, -$03, -$23 ; mode, y, x
 DB $ff, +$23, -$0D ; mode, y, x
 DB $ff, +$0C, +$2B ; mode, y, x
 DB $ff, +$22, +$14 ; mode, y, x
 DB $00, +$15, +$0C ; mode, y, x
 DB $ff, +$02, -$05 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_8:
 DB $00, -$2A, +$14 ; mode, y, x
 DB $ff, -$11, -$1D ; mode, y, x
 DB $ff, +$1C, -$1B ; mode, y, x
 DB $ff, +$1C, +$24 ; mode, y, x
 DB $ff, +$27, +$05 ; mode, y, x
 DB $00, +$18, +$05 ; mode, y, x
 DB $ff, +$01, -$06 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_9:
 DB $00, -$1F, +$23 ; mode, y, x
 DB $ff, -$1C, -$1A ; mode, y, x
 DB $ff, +$11, -$1E ; mode, y, x
 DB $ff, +$27, +$15 ; mode, y, x
 DB $ff, +$27, -$05 ; mode, y, x
 DB $00, +$18, -$05 ; mode, y, x
 DB $ff, -$01, -$05 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_10:
 DB $00, -$0F, +$2C ; mode, y, x
 DB $ff, -$23, -$0D ; mode, y, x
 DB $ff, +$03, -$23 ; mode, y, x
 DB $ff, +$2C, +$05 ; mode, y, x
 DB $ff, +$22, -$14 ; mode, y, x
 DB $00, +$15, -$0C ; mode, y, x
 DB $ff, -$03, -$05 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_11:
 DB $00, +$00, +$2F ; mode, y, x
 DB $ff, -$24, +$01 ; mode, y, x
 DB $ff, -$0A, -$25 ; mode, y, x
 DB $ff, +$2C, -$09 ; mode, y, x
 DB $ff, +$18, -$1F ; mode, y, x
 DB $00, +$0E, -$14 ; mode, y, x
 DB $ff, -$05, -$03 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_12:
 DB $00, +$11, +$2C ; mode, y, x
 DB $ff, -$20, +$0D ; mode, y, x
 DB $ff, -$17, -$1D ; mode, y, x
 DB $ff, +$26, -$19 ; mode, y, x
 DB $ff, +$09, -$27 ; mode, y, x
 DB $00, +$06, -$17 ; mode, y, x
 DB $ff, -$06, -$01 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_13:
 DB $00, +$20, +$22 ; mode, y, x
 DB $ff, -$1C, +$1A ; mode, y, x
 DB $ff, -$1D, -$14 ; mode, y, x
 DB $ff, +$19, -$25 ; mode, y, x
 DB $ff, -$02, -$27 ; mode, y, x
 DB $00, -$02, -$19 ; mode, y, x
 DB $ff, -$06, +$01 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_14:
 DB $00, +$2B, +$13 ; mode, y, x
 DB $ff, -$11, +$23 ; mode, y, x
 DB $ff, -$23, -$07 ; mode, y, x
 DB $ff, +$0A, -$2C ; mode, y, x
 DB $ff, -$10, -$24 ; mode, y, x
 DB $00, -$0B, -$15 ; mode, y, x
 DB $ff, -$06, +$02 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_15:
 DB $00, +$2F, +$02 ; mode, y, x
 DB $ff, -$03, +$26 ; mode, y, x
 DB $ff, -$25, +$07 ; mode, y, x
 DB $ff, -$05, -$2D ; mode, y, x
 DB $ff, -$1D, -$1A ; mode, y, x
 DB $00, -$11, -$10 ; mode, y, x
 DB $ff, -$05, +$04 ; mode, y, x
 DB $01 ; endmarker (1)
BonusList_16:
 DB $00, +$2C, -$0C ; mode, y, x
 DB $ff, +$0C, +$20 ; mode, y, x
 DB $ff, -$20, +$14 ; mode, y, x
 DB $ff, -$15, -$28 ; mode, y, x
 DB $ff, -$25, -$0C ; mode, y, x
 DB $00, -$17, -$09 ; mode, y, x
 DB $ff, -$02, +$06 ; mode, y, x
 DB $01 ; endmarker (1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
circle:  ;#isfunction
; circle generated 0°-360° in 360 steps (cos, -sin), radius: 108
; if radius is greater a 5 sided polygon has sides longer than 127!
                    db       $6C, $00                     ; degrees: 0° 
                    db       $6B, $FF                     ; degrees: 1° 
                    db       $6B, $FD                     ; degrees: 2° 
                    db       $6B, $FB                     ; degrees: 3° 
                    db       $6B, $F9                     ; degrees: 4° 
                    db       $6B, $F7                     ; degrees: 5° 
                    db       $6B, $F5                     ; degrees: 6° 
                    db       $6B, $F3                     ; degrees: 7° 
                    db       $6A, $F1                     ; degrees: 8° 
                    db       $6A, $F0                     ; degrees: 9° 
                    db       $6A, $EE                     ; degrees: 10° 
                    db       $6A, $EC                     ; degrees: 11° 
                    db       $69, $EA                     ; degrees: 12° 
                    db       $69, $E8                     ; degrees: 13° 
                    db       $68, $E6                     ; degrees: 14° 
                    db       $68, $E5                     ; degrees: 15° 
                    db       $67, $E3                     ; degrees: 16° 
                    db       $67, $E1                     ; degrees: 17° 
                    db       $66, $DF                     ; degrees: 18° 
                    db       $66, $DD                     ; degrees: 19° 
                    db       $65, $DC                     ; degrees: 20° 
                    db       $64, $DA                     ; degrees: 21° 
                    db       $64, $D8                     ; degrees: 22° 
                    db       $63, $D6                     ; degrees: 23° 
                    db       $62, $D5                     ; degrees: 24° 
                    db       $61, $D3                     ; degrees: 25° 
                    db       $61, $D1                     ; degrees: 26° 
                    db       $60, $CF                     ; degrees: 27° 
                    db       $5F, $CE                     ; degrees: 28° 
                    db       $5E, $CC                     ; degrees: 29° 
                    db       $5D, $CB                     ; degrees: 30° 
                    db       $5C, $C9                     ; degrees: 31° 
                    db       $5B, $C7                     ; degrees: 32° 
                    db       $5A, $C6                     ; degrees: 33° 
                    db       $59, $C4                     ; degrees: 34° 
                    db       $58, $C3                     ; degrees: 35° 
                    db       $57, $C1                     ; degrees: 36° 
                    db       $56, $C0                     ; degrees: 37° 
                    db       $55, $BE                     ; degrees: 38° 
                    db       $53, $BD                     ; degrees: 39° 
                    db       $52, $BB                     ; degrees: 40° 
                    db       $51, $BA                     ; degrees: 41° 
                    db       $50, $B8                     ; degrees: 42° 
                    db       $4E, $B7                     ; degrees: 43° 
                    db       $4D, $B5                     ; degrees: 44° 
                    db       $4C, $B4                     ; degrees: 45° 
                    db       $4B, $B3                     ; degrees: 46° 
                    db       $49, $B2                     ; degrees: 47° 
                    db       $48, $B0                     ; degrees: 48° 
                    db       $46, $AF                     ; degrees: 49° 
                    db       $45, $AE                     ; degrees: 50° 
                    db       $43, $AD                     ; degrees: 51° 
                    db       $42, $AB                     ; degrees: 52° 
                    db       $40, $AA                     ; degrees: 53° 
                    db       $3F, $A9                     ; degrees: 54° 
                    db       $3D, $A8                     ; degrees: 55° 
                    db       $3C, $A7                     ; degrees: 56° 
                    db       $3A, $A6                     ; degrees: 57° 
                    db       $39, $A5                     ; degrees: 58° 
                    db       $37, $A4                     ; degrees: 59° 
                    db       $36, $A3                     ; degrees: 60° 
                    db       $34, $A2                     ; degrees: 61° 
                    db       $32, $A1                     ; degrees: 62° 
                    db       $31, $A0                     ; degrees: 63° 
                    db       $2F, $9F                     ; degrees: 64° 
                    db       $2D, $9F                     ; degrees: 65° 
                    db       $2B, $9E                     ; degrees: 66° 
                    db       $2A, $9D                     ; degrees: 67° 
                    db       $28, $9C                     ; degrees: 68° 
                    db       $26, $9C                     ; degrees: 69° 
                    db       $24, $9B                     ; degrees: 70° 
                    db       $23, $9A                     ; degrees: 71° 
                    db       $21, $9A                     ; degrees: 72° 
                    db       $1F, $99                     ; degrees: 73° 
                    db       $1D, $99                     ; degrees: 74° 
                    db       $1B, $98                     ; degrees: 75° 
                    db       $1A, $98                     ; degrees: 76° 
                    db       $18, $97                     ; degrees: 77° 
                    db       $16, $97                     ; degrees: 78° 
                    db       $14, $96                     ; degrees: 79° 
                    db       $12, $96                     ; degrees: 80° 
                    db       $10, $96                     ; degrees: 81° 
                    db       $0F, $96                     ; degrees: 82° 
                    db       $0D, $95                     ; degrees: 83° 
                    db       $0B, $95                     ; degrees: 84° 
                    db       $09, $95                     ; degrees: 85° 
                    db       $07, $95                     ; degrees: 86° 
                    db       $05, $95                     ; degrees: 87° 
                    db       $03, $95                     ; degrees: 88° 
                    db       $01, $95                     ; degrees: 89° 
                    db       $00, $94                     ; degrees: 90° 
                    db       $FF, $95                     ; degrees: 91° 
                    db       $FD, $95                     ; degrees: 92° 
                    db       $FB, $95                     ; degrees: 93° 
                    db       $F9, $95                     ; degrees: 94° 
                    db       $F7, $95                     ; degrees: 95° 
                    db       $F5, $95                     ; degrees: 96° 
                    db       $F3, $95                     ; degrees: 97° 
                    db       $F1, $96                     ; degrees: 98° 
                    db       $F0, $96                     ; degrees: 99° 
                    db       $EE, $96                     ; degrees: 100° 
                    db       $EC, $96                     ; degrees: 101° 
                    db       $EA, $97                     ; degrees: 102° 
                    db       $E8, $97                     ; degrees: 103° 
                    db       $E6, $98                     ; degrees: 104° 
                    db       $E5, $98                     ; degrees: 105° 
                    db       $E3, $99                     ; degrees: 106° 
                    db       $E1, $99                     ; degrees: 107° 
                    db       $DF, $9A                     ; degrees: 108° 
                    db       $DD, $9A                     ; degrees: 109° 
                    db       $DC, $9B                     ; degrees: 110° 
                    db       $DA, $9C                     ; degrees: 111° 
                    db       $D8, $9C                     ; degrees: 112° 
                    db       $D6, $9D                     ; degrees: 113° 
                    db       $D5, $9E                     ; degrees: 114° 
                    db       $D3, $9F                     ; degrees: 115° 
                    db       $D1, $9F                     ; degrees: 116° 
                    db       $CF, $A0                     ; degrees: 117° 
                    db       $CE, $A1                     ; degrees: 118° 
                    db       $CC, $A2                     ; degrees: 119° 
                    db       $CB, $A3                     ; degrees: 120° 
                    db       $C9, $A4                     ; degrees: 121° 
                    db       $C7, $A5                     ; degrees: 122° 
                    db       $C6, $A6                     ; degrees: 123° 
                    db       $C4, $A7                     ; degrees: 124° 
                    db       $C3, $A8                     ; degrees: 125° 
                    db       $C1, $A9                     ; degrees: 126° 
                    db       $C0, $AA                     ; degrees: 127° 
                    db       $BE, $AB                     ; degrees: 128° 
                    db       $BD, $AD                     ; degrees: 129° 
                    db       $BB, $AE                     ; degrees: 130° 
                    db       $BA, $AF                     ; degrees: 131° 
                    db       $B8, $B0                     ; degrees: 132° 
                    db       $B7, $B2                     ; degrees: 133° 
                    db       $B5, $B3                     ; degrees: 134° 
                    db       $B4, $B4                     ; degrees: 135° 
                    db       $B3, $B5                     ; degrees: 136° 
                    db       $B2, $B7                     ; degrees: 137° 
                    db       $B0, $B8                     ; degrees: 138° 
                    db       $AF, $BA                     ; degrees: 139° 
                    db       $AE, $BB                     ; degrees: 140° 
                    db       $AD, $BD                     ; degrees: 141° 
                    db       $AB, $BE                     ; degrees: 142° 
                    db       $AA, $C0                     ; degrees: 143° 
                    db       $A9, $C1                     ; degrees: 144° 
                    db       $A8, $C3                     ; degrees: 145° 
                    db       $A7, $C4                     ; degrees: 146° 
                    db       $A6, $C6                     ; degrees: 147° 
                    db       $A5, $C7                     ; degrees: 148° 
                    db       $A4, $C9                     ; degrees: 149° 
                    db       $A3, $CB                     ; degrees: 150° 
                    db       $A2, $CC                     ; degrees: 151° 
                    db       $A1, $CE                     ; degrees: 152° 
                    db       $A0, $CF                     ; degrees: 153° 
                    db       $9F, $D1                     ; degrees: 154° 
                    db       $9F, $D3                     ; degrees: 155° 
                    db       $9E, $D5                     ; degrees: 156° 
                    db       $9D, $D6                     ; degrees: 157° 
                    db       $9C, $D8                     ; degrees: 158° 
                    db       $9C, $DA                     ; degrees: 159° 
                    db       $9B, $DC                     ; degrees: 160° 
                    db       $9A, $DD                     ; degrees: 161° 
                    db       $9A, $DF                     ; degrees: 162° 
                    db       $99, $E1                     ; degrees: 163° 
                    db       $99, $E3                     ; degrees: 164° 
                    db       $98, $E5                     ; degrees: 165° 
                    db       $98, $E6                     ; degrees: 166° 
                    db       $97, $E8                     ; degrees: 167° 
                    db       $97, $EA                     ; degrees: 168° 
                    db       $96, $EC                     ; degrees: 169° 
                    db       $96, $EE                     ; degrees: 170° 
                    db       $96, $F0                     ; degrees: 171° 
                    db       $96, $F1                     ; degrees: 172° 
                    db       $95, $F3                     ; degrees: 173° 
                    db       $95, $F5                     ; degrees: 174° 
                    db       $95, $F7                     ; degrees: 175° 
                    db       $95, $F9                     ; degrees: 176° 
                    db       $95, $FB                     ; degrees: 177° 
                    db       $95, $FD                     ; degrees: 178° 
                    db       $95, $FF                     ; degrees: 179° 
                    db       $94, $00                     ; degrees: 180° 
                    db       $95, $01                     ; degrees: 181° 
                    db       $95, $03                     ; degrees: 182° 
                    db       $95, $05                     ; degrees: 183° 
                    db       $95, $07                     ; degrees: 184° 
                    db       $95, $09                     ; degrees: 185° 
                    db       $95, $0B                     ; degrees: 186° 
                    db       $95, $0D                     ; degrees: 187° 
                    db       $96, $0F                     ; degrees: 188° 
                    db       $96, $10                     ; degrees: 189° 
                    db       $96, $12                     ; degrees: 190° 
                    db       $96, $14                     ; degrees: 191° 
                    db       $97, $16                     ; degrees: 192° 
                    db       $97, $18                     ; degrees: 193° 
                    db       $98, $1A                     ; degrees: 194° 
                    db       $98, $1B                     ; degrees: 195° 
                    db       $99, $1D                     ; degrees: 196° 
                    db       $99, $1F                     ; degrees: 197° 
                    db       $9A, $21                     ; degrees: 198° 
                    db       $9A, $23                     ; degrees: 199° 
                    db       $9B, $24                     ; degrees: 200° 
                    db       $9C, $26                     ; degrees: 201° 
                    db       $9C, $28                     ; degrees: 202° 
                    db       $9D, $2A                     ; degrees: 203° 
                    db       $9E, $2B                     ; degrees: 204° 
                    db       $9F, $2D                     ; degrees: 205° 
                    db       $9F, $2F                     ; degrees: 206° 
                    db       $A0, $31                     ; degrees: 207° 
                    db       $A1, $32                     ; degrees: 208° 
                    db       $A2, $34                     ; degrees: 209° 
                    db       $A3, $36                     ; degrees: 210° 
                    db       $A4, $37                     ; degrees: 211° 
                    db       $A5, $39                     ; degrees: 212° 
                    db       $A6, $3A                     ; degrees: 213° 
                    db       $A7, $3C                     ; degrees: 214° 
                    db       $A8, $3D                     ; degrees: 215° 
                    db       $A9, $3F                     ; degrees: 216° 
                    db       $AA, $40                     ; degrees: 217° 
                    db       $AB, $42                     ; degrees: 218° 
                    db       $AD, $43                     ; degrees: 219° 
                    db       $AE, $45                     ; degrees: 220° 
                    db       $AF, $46                     ; degrees: 221° 
                    db       $B0, $48                     ; degrees: 222° 
                    db       $B2, $49                     ; degrees: 223° 
                    db       $B3, $4B                     ; degrees: 224° 
                    db       $B4, $4C                     ; degrees: 225° 
                    db       $B5, $4D                     ; degrees: 226° 
                    db       $B7, $4E                     ; degrees: 227° 
                    db       $B8, $50                     ; degrees: 228° 
                    db       $BA, $51                     ; degrees: 229° 
                    db       $BB, $52                     ; degrees: 230° 
                    db       $BD, $53                     ; degrees: 231° 
                    db       $BE, $55                     ; degrees: 232° 
                    db       $C0, $56                     ; degrees: 233° 
                    db       $C1, $57                     ; degrees: 234° 
                    db       $C3, $58                     ; degrees: 235° 
                    db       $C4, $59                     ; degrees: 236° 
                    db       $C6, $5A                     ; degrees: 237° 
                    db       $C7, $5B                     ; degrees: 238° 
                    db       $C9, $5C                     ; degrees: 239° 
                    db       $CA, $5D                     ; degrees: 240° 
                    db       $CC, $5E                     ; degrees: 241° 
                    db       $CE, $5F                     ; degrees: 242° 
                    db       $CF, $60                     ; degrees: 243° 
                    db       $D1, $61                     ; degrees: 244° 
                    db       $D3, $61                     ; degrees: 245° 
                    db       $D5, $62                     ; degrees: 246° 
                    db       $D6, $63                     ; degrees: 247° 
                    db       $D8, $64                     ; degrees: 248° 
                    db       $DA, $64                     ; degrees: 249° 
                    db       $DC, $65                     ; degrees: 250° 
                    db       $DD, $66                     ; degrees: 251° 
                    db       $DF, $66                     ; degrees: 252° 
                    db       $E1, $67                     ; degrees: 253° 
                    db       $E3, $67                     ; degrees: 254° 
                    db       $E5, $68                     ; degrees: 255° 
                    db       $E6, $68                     ; degrees: 256° 
                    db       $E8, $69                     ; degrees: 257° 
                    db       $EA, $69                     ; degrees: 258° 
                    db       $EC, $6A                     ; degrees: 259° 
                    db       $EE, $6A                     ; degrees: 260° 
                    db       $F0, $6A                     ; degrees: 261° 
                    db       $F1, $6A                     ; degrees: 262° 
                    db       $F3, $6B                     ; degrees: 263° 
                    db       $F5, $6B                     ; degrees: 264° 
                    db       $F7, $6B                     ; degrees: 265° 
                    db       $F9, $6B                     ; degrees: 266° 
                    db       $FB, $6B                     ; degrees: 267° 
                    db       $FD, $6B                     ; degrees: 268° 
                    db       $FF, $6B                     ; degrees: 269° 
                    db       $00, $6C                     ; degrees: 270° 
                    db       $01, $6B                     ; degrees: 271° 
                    db       $03, $6B                     ; degrees: 272° 
                    db       $05, $6B                     ; degrees: 273° 
                    db       $07, $6B                     ; degrees: 274° 
                    db       $09, $6B                     ; degrees: 275° 
                    db       $0B, $6B                     ; degrees: 276° 
                    db       $0D, $6B                     ; degrees: 277° 
                    db       $0F, $6A                     ; degrees: 278° 
                    db       $10, $6A                     ; degrees: 279° 
                    db       $12, $6A                     ; degrees: 280° 
                    db       $14, $6A                     ; degrees: 281° 
                    db       $16, $69                     ; degrees: 282° 
                    db       $18, $69                     ; degrees: 283° 
                    db       $1A, $68                     ; degrees: 284° 
                    db       $1B, $68                     ; degrees: 285° 
                    db       $1D, $67                     ; degrees: 286° 
                    db       $1F, $67                     ; degrees: 287° 
                    db       $21, $66                     ; degrees: 288° 
                    db       $23, $66                     ; degrees: 289° 
                    db       $24, $65                     ; degrees: 290° 
                    db       $26, $64                     ; degrees: 291° 
                    db       $28, $64                     ; degrees: 292° 
                    db       $2A, $63                     ; degrees: 293° 
                    db       $2B, $62                     ; degrees: 294° 
                    db       $2D, $61                     ; degrees: 295° 
                    db       $2F, $61                     ; degrees: 296° 
                    db       $31, $60                     ; degrees: 297° 
                    db       $32, $5F                     ; degrees: 298° 
                    db       $34, $5E                     ; degrees: 299° 
                    db       $36, $5D                     ; degrees: 300° 
                    db       $37, $5C                     ; degrees: 301° 
                    db       $39, $5B                     ; degrees: 302° 
                    db       $3A, $5A                     ; degrees: 303° 
                    db       $3C, $59                     ; degrees: 304° 
                    db       $3D, $58                     ; degrees: 305° 
                    db       $3F, $57                     ; degrees: 306° 
                    db       $40, $56                     ; degrees: 307° 
                    db       $42, $55                     ; degrees: 308° 
                    db       $43, $53                     ; degrees: 309° 
                    db       $45, $52                     ; degrees: 310° 
                    db       $46, $51                     ; degrees: 311° 
                    db       $48, $50                     ; degrees: 312° 
                    db       $49, $4E                     ; degrees: 313° 
                    db       $4B, $4D                     ; degrees: 314° 
                    db       $4C, $4C                     ; degrees: 315° 
                    db       $4D, $4B                     ; degrees: 316° 
                    db       $4E, $49                     ; degrees: 317° 
                    db       $50, $48                     ; degrees: 318° 
                    db       $51, $46                     ; degrees: 319° 
                    db       $52, $45                     ; degrees: 320° 
                    db       $53, $43                     ; degrees: 321° 
                    db       $55, $42                     ; degrees: 322° 
                    db       $56, $40                     ; degrees: 323° 
                    db       $57, $3F                     ; degrees: 324° 
                    db       $58, $3D                     ; degrees: 325° 
                    db       $59, $3C                     ; degrees: 326° 
                    db       $5A, $3A                     ; degrees: 327° 
                    db       $5B, $39                     ; degrees: 328° 
                    db       $5C, $37                     ; degrees: 329° 
                    db       $5D, $36                     ; degrees: 330° 
                    db       $5E, $34                     ; degrees: 331° 
                    db       $5F, $32                     ; degrees: 332° 
                    db       $60, $31                     ; degrees: 333° 
                    db       $61, $2F                     ; degrees: 334° 
                    db       $61, $2D                     ; degrees: 335° 
                    db       $62, $2B                     ; degrees: 336° 
                    db       $63, $2A                     ; degrees: 337° 
                    db       $64, $28                     ; degrees: 338° 
                    db       $64, $26                     ; degrees: 339° 
                    db       $65, $24                     ; degrees: 340° 
                    db       $66, $23                     ; degrees: 341° 
                    db       $66, $21                     ; degrees: 342° 
                    db       $67, $1F                     ; degrees: 343° 
                    db       $67, $1D                     ; degrees: 344° 
                    db       $68, $1B                     ; degrees: 345° 
                    db       $68, $1A                     ; degrees: 346° 
                    db       $69, $18                     ; degrees: 347° 
                    db       $69, $16                     ; degrees: 348° 
                    db       $6A, $14                     ; degrees: 349° 
                    db       $6A, $12                     ; degrees: 350° 
                    db       $6A, $10                     ; degrees: 351° 
                    db       $6A, $0F                     ; degrees: 352° 
                    db       $6B, $0D                     ; degrees: 353° 
                    db       $6B, $0B                     ; degrees: 354° 
                    db       $6B, $09                     ; degrees: 355° 
                    db       $6B, $07                     ; degrees: 356° 
                    db       $6B, $05                     ; degrees: 357° 
                    db       $6B, $03                     ; degrees: 358° 
                    db       $6B, $01                     ; degrees: 359° 
; some overflow angles
; since random does 0-127 instead of 0-120
                    db       $6C, $00                     ; degrees: 0° 
                    db       $6B, $FF                     ; degrees: 1° 
                    db       $6B, $FD                     ; degrees: 2° 
                    db       $6B, $FB                     ; degrees: 3° 
                    db       $6B, $F9                     ; degrees: 4° 
                    db       $6B, $F7                     ; degrees: 5° 
                    db       $6B, $F5                     ; degrees: 6° 
                    db       $6B, $F3                     ; degrees: 7° 
                    db       $6A, $F1                     ; degrees: 8° 
                    db       $6A, $F0                     ; degrees: 9° 
                    db       $6A, $EE                     ; degrees: 10° 
                    db       $6A, $EC                     ; degrees: 11° 
                    db       $69, $EA                     ; degrees: 12° 
                    db       $69, $E8                     ; degrees: 13° 
                    db       $68, $E6                     ; degrees: 14° 
                    db       $68, $E5                     ; degrees: 15° 
                    db       $67, $E3                     ; degrees: 16° 
                    db       $67, $E1                     ; degrees: 17° 
                    db       $66, $DF                     ; degrees: 18° 
                    db       $66, $DD                     ; degrees: 19° 
                    db       $65, $DC                     ; degrees: 20° 
                    db       $64, $DA                     ; degrees: 21° 
                    db       $64, $D8                     ; degrees: 22° 

; Following are the 3 gimmick definitions
; Gimmick - a sprite is displayed in places "just for fun"
; there is a Pacman, a ghost and a little worm crawling
;
BLOW_UP_PACMAN      EQU      14 

;
BLOW_UP_GHOST       EQU      12 

;
BLOW_UP_WORM       EQU      12 

; below are nearly 1500 byte!!!



PacmanSmall_0: 
                    DW       (MAX_LINE_NUM_A-($8+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP_PACMAN, +$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$03*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$02*BLOW_UP_PACMAN, +$00*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$02*BLOW_UP_PACMAN, +$00*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$03*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$00*BLOW_UP_PACMAN, -$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$04*BLOW_UP_PACMAN, +$00*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
PacmanSmall_1: 
                    DW       (MAX_LINE_NUM_A-($8+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP_PACMAN, +$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$04*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$01*BLOW_UP_PACMAN, -$02*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$01*BLOW_UP_PACMAN, +$02*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$04*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$00*BLOW_UP_PACMAN, -$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$04*BLOW_UP_PACMAN, +$00*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
PacmanSmall_2: 
                    DW       (MAX_LINE_NUM_A-($8+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP_PACMAN, +$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$03*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$02*BLOW_UP_PACMAN, -$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$02*BLOW_UP_PACMAN, +$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$03*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$00*BLOW_UP_PACMAN, -$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$04*BLOW_UP_PACMAN, +$00*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
PacmanSmall_3: 
                    DW       (MAX_LINE_NUM_A-($8+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP_PACMAN, +$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$02*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$03*BLOW_UP_PACMAN, -$05*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$03*BLOW_UP_PACMAN, +$05*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$02*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$00*BLOW_UP_PACMAN, -$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$04*BLOW_UP_PACMAN, +$00*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 


GhostSmall_0: 
                    DW       (MAX_LINE_NUM_A-($9+1))*ONE_LINE_LENGTH 
                    DB       +$05*BLOW_UP_GHOST, +$00*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$05*BLOW_UP_GHOST, -$01*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$00*BLOW_UP_GHOST, -$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$00*BLOW_UP_GHOST, -$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$05*BLOW_UP_GHOST, -$01*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$05*BLOW_UP_GHOST, +$00*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$02*BLOW_UP_GHOST, +$04*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$02*BLOW_UP_GHOST, +$03*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$02*BLOW_UP_GHOST, +$03*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$02*BLOW_UP_GHOST, +$02*BLOW_UP_GHOST ; draw to y, x 
GhostSmall_1: 
                    DW       (MAX_LINE_NUM_A-($9+1))*ONE_LINE_LENGTH 
                    DB       +$05*BLOW_UP_GHOST, +$00*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$05*BLOW_UP_GHOST, -$01*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$00*BLOW_UP_GHOST, -$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$00*BLOW_UP_GHOST, -$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$05*BLOW_UP_GHOST, -$01*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$05*BLOW_UP_GHOST, +$00*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$02*BLOW_UP_GHOST, +$02*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$02*BLOW_UP_GHOST, +$03*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$02*BLOW_UP_GHOST, +$03*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$02*BLOW_UP_GHOST, +$04*BLOW_UP_GHOST ; draw to y, x 
GhostSmall_2: 
                    DW       (MAX_LINE_NUM_A-($9+1))*ONE_LINE_LENGTH 
                    DB       +$05*BLOW_UP_GHOST, +$00*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$05*BLOW_UP_GHOST, -$01*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$00*BLOW_UP_GHOST, -$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$00*BLOW_UP_GHOST, -$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$05*BLOW_UP_GHOST, -$01*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$05*BLOW_UP_GHOST, +$00*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$02*BLOW_UP_GHOST, +$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$02*BLOW_UP_GHOST, +$03*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$02*BLOW_UP_GHOST, +$03*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$02*BLOW_UP_GHOST, +$01*BLOW_UP_GHOST ; draw to y, x 

WormSmall_0:
                    DW       (MAX_LINE_NUM_A-($5+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
WormSmall_1:
                    DW       (MAX_LINE_NUM_A-($5+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$02*BLOW_UP_WORM, +$04*BLOW_UP_WORM ; draw to y, x
 DB -$02*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
WormSmall_2:
                    DW       (MAX_LINE_NUM-($5+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$03*BLOW_UP_WORM ; draw to y, x
 DB +$02*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB -$03*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
WormSmall_3:
                    DW       (MAX_LINE_NUM_A-($5+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$03*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB -$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB -$02*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
WormSmall_4:
                    DW       (MAX_LINE_NUM_A-($5+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$02*BLOW_UP_WORM, +$00*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB -$03*BLOW_UP_WORM, +$00*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
WormSmall_5:
                    DW       (MAX_LINE_NUM_A-($5+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$02*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB -$01*BLOW_UP_WORM, +$03*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
WormSmall_6:
                    DW       (MAX_LINE_NUM_A-($5+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB -$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x


