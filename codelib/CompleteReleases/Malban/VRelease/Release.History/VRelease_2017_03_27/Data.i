;***************************************************************************
; DATA SECTION
;***************************************************************************
; VLMode Lists

BonusExpandList:
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

BonusFasterList:
 DB $ff, +$33, +$4C ; mode, y, x
 DB $ff, +$64, +$00 ; mode, y, x
 DB $ff, +$33, -$4C ; mode, y, x
 DB $00, -$65, +$00 ; mode, y, x
 DB $ff, -$32, -$4C ; mode, y, x
 DB $00, +$64, +$00 ; mode, y, x
 DB $ff, -$32, +$4C ; mode, y, x
 DB $ff, +$00, -$7F ; mode, y, x
 DB $01 ; endmarker (1)

BonusShieldList:
 DB $ff, +$7C, -$5D ; mode, y, x
 DB $ff, +$7F, +$00 ; mode, y, x
 DB $ff, +$00, +$5D ; mode, y, x
 DB $ff, +$00, +$5D ; mode, y, x
 DB $ff, -$7F, +$00 ; mode, y, x
 DB $ff, -$7C, -$5D ; mode, y, x
 DB $01 ; endmarker (1)


Dragonchild_List:
 DB $00, -$12, -$12 ; mode, y, x
 DB $ff, +$24, +$24 ; mode, y, x
 DB $00, +$00, -$24 ; mode, y, x
 DB $ff, -$24, +$24 ; mode, y, x
 DB $01 ; endmarker (1)

enemyXList_0:
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



score10:
 DB $00, +$3F, 0              ; mode, y, x 
 DB $ff, +$00, +$3F ; mode, y, x
 DB $ff, -$7E, +$00 ; mode, y, x
 DB $ff, +$00, -$3F ; mode, y, x
 DB $ff, +$7E, +$00 ; mode, y, x
 DB $00, +$00, -$3F ; mode, y, x
 DB $ff, -$7E, +$00 ; mode, y, x
 DB $01 ; endmarker (1)

score15:
 DB $ff, +$7F, +$00 ; mode, y, x
 DB $00, -$7F, +$1F ; mode, y, x
 DB $ff, +$00, +$5F ; mode, y, x
 DB $ff, +$3F, +$00 ; mode, y, x
 DB $ff, +$00, -$5F ; mode, y, x
 DB $ff, +$40, +$00 ; mode, y, x
 DB $ff, +$00, +$5F ; mode, y, x
 DB $01 ; endmarker (1)

score18:
 DB $ff, -$7F, +$00 ; mode, y, x
 DB $00, +$00, +$3F ; mode, y, x
 DB $ff, +$7F, +$5F ; mode, y, x
 DB $ff, +$00, -$5F ; mode, y, x
 DB $ff, -$7F, +$5F ; mode, y, x
 DB $ff, +$00, -$5F ; mode, y, x
 DB $01 ; endmarker (1)

score20:
 DB $ff, +$00, +$60 ; mode, y, x
 DB $ff, -$7F, -$60 ; mode, y, x
 DB $ff, +$00, +$60 ; mode, y, x
 DB $00, +$00, +$3E ; mode, y, x
 DB $ff, +$00, +$60 ; mode, y, x
 DB $ff, +$7F, +$00 ; mode, y, x
 DB $ff, +$00, -$60 ; mode, y, x
 DB $ff, -$7F, +$00 ; mode, y, x
 DB $01 ; endmarker (1)

score30:
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

score36:
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

score45:
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

score50:
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

score54:
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

NumberList:
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
 DB $00, +$00, +$4C ; mode, y, x
 DB $ff, +$65, +$00 ; mode, y, x
 DB $00, -$65, +$33 ; mode, y, x
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



HunterList:
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
DragonList:
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

StarletList:
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



BomberList:
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


BonusList:
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
circle: 
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


inGame_ymlen:
 dw $0F30
inGame_ymData:
 db $EF, $7F, $B4, $F5, $7E, $02, $C8, $33, $FE, $0C
 db $E0, $24, $33, $81, $0C, $83, $30, $0A, $8C, $83
 db $30, $10, $CE, $0E, $43, $38, $40, $C8, $33, $03
 db $A8, $C8, $33, $04, $0C, $E1, $A4, $33, $87, $0C
 db $83, $30, $6A, $8C, $83, $30, $70, $CE, $26, $43
 db $38, $A0, $C8, $33, $09, $A8, $C8, $33, $0A, $0C
 db $E3, $24, $33, $8D, $0C, $83, $30, $CA, $8C, $83
 db $30, $D0, $CE, $3E, $43, $39, $00, $C8, $33, $0F
 db $A8, $C8, $33, $10, $0C, $E4, $A4, $33, $93, $0C
 db $83, $31, $2A, $8C, $83, $31, $30, $EE, $72, $B2
 db $19, $CB, $06, $41, $98, $AD, $46, $41, $98, $B0
 db $67, $31, $21, $9C, $C8, $64, $19, $8C, $54, $64
 db $19, $8C, $86, $73, $72, $19, $CE, $06, $41, $98
 db $DD, $46, $41, $98, $E0, $67, $3D, $21, $9C, $F8
 db $64, $19, $8F, $54, $64, $19, $8F, $86, $74, $32
 db $19, $D1, $06, $41, $99, $0D, $46, $41, $99, $10
 db $67, $49, $21, $9D, $28, $64, $19, $92, $54, $64
 db $19, $92, $86, $74, $F2, $19, $D4, $06, $41, $99
 db $3D, $46, $41, $99, $40, $67, $55, $21, $9D, $58
 db $64, $1D, $AC, $AA, $A3, $20, $CC, $AC, $33, $AD
 db $90, $CE, $B8, $32, $0C, $CB, $6A, $32, $0C, $CB
 db $83, $3B, $09, $0C, $EC, $43, $20, $CC, $C2, $A3
 db $20, $CC, $C4, $33, $B3, $90, $CE, $D0, $32, $0C
 db $CC, $EA, $32, $0C, $CD, $03, $3B, $69, $0C, $ED
 db $C3, $20, $CC, $DA, $A3, $20, $CC, $DC, $33, $B9
 db $90, $CE, $E8, $32, $0C, $CE, $6A, $32, $0C, $CE
 db $83, $3B, $C9, $0C, $EF, $43, $20, $CC, $F2, $A3
 db $20, $CC, $F4, $33, $BF, $90, $CF, $00, $32, $0C
 db $CF, $EA, $32, $0C, $D0, $03, $B1, $E1, $48, $67
 db $86, $19, $06, $68, $55, $19, $06, $68, $61, $9E
 db $2C, $86, $78, $C1, $90, $66, $8B, $51, $90, $66
 db $8C, $19, $E4, $48, $67, $92, $19, $06, $69, $15
 db $19, $06, $69, $21, $9E, $5C, $86, $79, $81, $90
 db $66, $97, $51, $90, $66, $98, $19, $E7, $48, $67
 db $9E, $19, $06, $69, $D5, $19, $06, $69, $E1, $9E
 db $8C, $86, $7A, $41, $90, $66, $A3, $51, $90, $66
 db $A4, $19, $EA, $48, $67, $AA, $19, $06, $6A, $95
 db $19, $06, $6A, $A1, $9E, $BC, $86, $7B, $01, $90
 db $75, $B5, $7A, $8C, $83, $35, $80, $CF, $6A, $43
 db $3D, $B0, $C8, $33, $5A, $A8, $C8, $33, $5B, $0C
 db $F7, $64, $33, $DE, $0C, $83, $35, $DA, $8C, $83
 db $35, $E0, $CF, $82, $43, $3E, $10, $C8, $33, $60
 db $A8, $C8, $33, $61, $0C, $F8, $E4, $33, $E4, $0C
 db $83, $36, $3A, $8C, $83, $36, $40, $CF, $9A, $43
 db $3E, $70, $C8, $33, $66, $A8, $C8, $33, $67, $0C
 db $FA, $64, $33, $EA, $0C, $83, $36, $9A, $8C, $83
 db $36, $A0, $CF, $B2, $43, $3E, $D0, $C8, $33, $6C
 db $A8, $C8, $33, $6D, $0E, $A7, $DF, $21, $9F, $80
 db $64, $19, $B7, $D4, $64, $19, $B8, $06, $7E, $52
 db $19, $F9, $86, $41, $9B, $95, $46, $41, $9B, $98
 db $67, $EB, $21, $9F, $B0, $64, $19, $BA, $D4, $64
 db $19, $BB, $07, $4B, $F8, $90, $CF, $E4, $32, $0C
 db $DE, $2A, $32, $0C, $DE, $43, $3F, $B9, $0C, $FF
 db $03, $20, $E8, $6F, $75, $19, $06, $6F, $81, $9F
 db $F4, $86, $7F, $E1, $90, $66, $FD, $51, $90, $66
 db $FE, $1C, $EC, $06, $63, $30, $20, $C8, $33, $81
 db $A8, $C8, $33, $82, $0C, $C1, $26, $33, $05, $0C
 db $83, $99, $C2, $54, $64, $19, $C2, $86, $60, $F3
 db $19, $84, $06, $41, $9C, $3D, $46, $41, $9C, $40
 db $72, $B0, $A9, $8C, $C2, $C3, $20, $CE, $2A, $A3
 db $20, $CE, $2C, $33, $0D, $98, $CC, $38, $32, $0E
 db $48, $88, $D0, $1C, $51, $09, $A0, $38, $20, $68
 db $00, $07, $3C, $0E, $58, $1C, $70, $38, $60, $70
 db $40, $D0, $0C, $03, $A2, $07, $34, $0E, $48, $1C
 db $50, $38, $20, $68, $06, $01, $D3, $03, $9E, $07
 db $2C, $0E, $38, $1C, $30, $38, $20, $68, $0C, $03
 db $AA, $07, $44, $0E, $68, $1C, $90, $38, $A0, $70
 db $40, $D0, $18, $07, $5C, $0E, $98, $1C, $F0, $39
 db $60, $71, $C0, $E1, $81, $C1, $03, $40, $C0, $00
 db $1D, $51, $11, $A0, $3A, $22, $13, $40, $72, $C0
 db $D0, $1C, $70, $34, $07, $14, $0D, $01, $C1, $03
 db $40, $76, $C0, $EB, $81, $D3, $03, $9E, $07, $2C
 db $0E, $38, $1C, $30, $38, $20, $60, $1D, $D0, $3B
 db $20, $75, $40, $E8, $81, $CD, $03, $92, $07, $14
 db $0E, $08, $18, $07, $7C, $0E, $D8, $1D, $70, $3A
 db $60, $73, $C0, $E5, $81, $C7, $03, $86, $07, $00
 db $0E, $F8, $1D, $B0, $3A, $E0, $74, $C0, $E7, $81
 db $CB, $03, $8E, $07, $0C, $0E, $00, $1D, $F0, $3B
 db $60, $75, $C0, $E9, $81, $CF, $03, $96, $07, $1C
 db $0E, $18, $1C, $00, $30, $00, $0E, $D8, $88, $D0
 db $1D, $71, $09, $A0, $3A, $20, $68, $0E, $68, $1A
 db $03, $96, $06, $80, $E2, $81, $A0, $3B, $E0, $76
 db $C0, $EB, $81, $D3, $03, $9E, $07, $2C, $0E, $38
 db $1C, $30, $38, $00, $77, $C0, $ED, $81, $D7, $03
 db $A6, $07, $3C, $0E, $58, $1C, $70, $38, $60, $70
 db $00, $EF, $81, $DB, $03, $AE, $07, $4C, $0E, $78
 db $1C, $B0, $38, $E0, $70, $C0, $E0, $01, $DF, $03
 db $B6, $07, $5C, $0E, $98, $1C, $F0, $39, $60, $71
 db $C0, $E1, $81, $C0, $03, $BE, $07, $6C, $0E, $B8
 db $1D, $30, $39, $E0, $72, $C0, $E3, $81, $C3, $03
 db $80, $06, $00, $01, $DB, $11, $1A, $03, $AE, $21
 db $34, $07, $44, $0D, $01, $CD, $03, $40, $72, $C0
 db $D0, $1C, $50, $34, $07, $7C, $0E, $D8, $1D, $70
 db $3A, $60, $73, $C0, $E5, $81, $C7, $03, $86, $07
 db $00, $0E, $F8, $1D, $B0, $3A, $E0, $74, $C0, $E7
 db $81, $CB, $03, $8E, $07, $0C, $0E, $00, $1D, $F0
 db $3B, $60, $75, $C0, $E9, $81, $CF, $03, $96, $07
 db $1C, $0E, $18, $1C, $00, $3B, $E0, $76, $C0, $EB
 db $81, $D3, $03, $9E, $07, $2C, $0E, $38, $1C, $30
 db $38, $00, $77, $C0, $ED, $81, $D7, $03, $A6, $07
 db $3C, $0E, $58, $1C, $70, $38, $60, $70, $00, $C0
 db $00, $3B, $62, $23, $40, $75, $C4, $26, $80, $E8
 db $81, $A0, $39, $A0, $68, $0E, $58, $1A, $03, $8A
 db $06, $80, $EF, $81, $DB, $03, $AE, $07, $4C, $0E
 db $78, $1C, $B0, $38, $E0, $70, $C0, $E0, $01, $DF
 db $03, $B6, $07, $5C, $0E, $98, $1C, $F0, $39, $60
 db $71, $C0, $E1, $81, $C0, $03, $BE, $07, $6C, $0E
 db $B8, $1D, $30, $39, $E0, $72, $C0, $E3, $81, $C3
 db $03, $80, $07, $7C, $0E, $D8, $1D, $70, $3A, $60
 db $73, $C0, $E5, $81, $C7, $03, $86, $07, $00, $0E
 db $F8, $1D, $B0, $3A, $E0, $74, $C0, $E7, $81, $CB
 db $03, $8E, $07, $0C, $0E, $00, $18, $00, $07, $6C
 db $44, $68, $0E, $B8, $84, $D0, $1D, $10, $34, $07
 db $34, $0D, $01, $CB, $03, $40, $71, $40, $D0, $1D
 db $F0, $3B, $60, $75, $C0, $E9, $81, $CF, $03, $96
 db $07, $1C, $0E, $18, $1C, $00, $3B, $E0, $76, $C0
 db $EB, $81, $D3, $03, $9E, $07, $2C, $0E, $38, $1C
 db $30, $38, $00, $77, $C0, $ED, $81, $D7, $03, $A6
 db $07, $3C, $0E, $58, $1C, $70, $38, $60, $70, $00
 db $EF, $81, $DB, $03, $AE, $07, $4C, $0E, $78, $1C
 db $B0, $38, $E0, $70, $C0, $E0, $01, $DF, $03, $B6
 db $07, $5C, $0E, $98, $1C, $F0, $39, $60, $71, $C0
 db $E1, $81, $C0, $03, $00, $00, $ED, $88, $8D, $01
 db $D7, $10, $9A, $03, $A2, $06, $80, $E6, $81, $A0
 db $39, $60, $68, $0E, $28, $1A, $03, $BE, $07, $6C
 db $0E, $B8, $1D, $30, $39, $E0, $72, $C0, $E3, $81
 db $C3, $03, $80, $07, $7C, $0E, $D8, $1D, $70, $3A
 db $60, $73, $C0, $E5, $81, $C7, $03, $86, $07, $00
 db $0E, $F8, $1D, $B0, $3A, $E0, $74, $C0, $E7, $81
 db $CB, $03, $8E, $07, $0C, $0E, $00, $1D, $F0, $3B
 db $60, $75, $C0, $E9, $81, $CF, $03, $96, $07, $1C
 db $0E, $18, $1C, $00, $3B, $E0, $76, $C0, $EB, $81
 db $D3, $03, $9E, $07, $2C, $0E, $38, $1C, $30, $38
 db $00, $60, $00, $1D, $B1, $11, $A0, $3A, $E2, $13
 db $40, $74, $40, $D0, $1C, $D0, $34, $07, $2C, $0D
 db $01, $C5, $03, $40, $77, $C0, $ED, $81, $D7, $03
 db $A6, $07, $3C, $0E, $58, $1C, $70, $38, $60, $70
 db $00, $EF, $81, $DB, $03, $AE, $07, $4C, $0E, $78
 db $1C, $B0, $38, $E0, $70, $C0, $E0, $01, $DF, $03
 db $B6, $07, $5C, $0E, $98, $1C, $F0, $39, $60, $71
 db $C0, $E1, $81, $C0, $03, $BE, $07, $6C, $0E, $B8
 db $1D, $30, $39, $E0, $72, $C0, $E3, $81, $C3, $03
 db $80, $07, $7C, $0E, $D8, $1D, $70, $3A, $60, $73
 db $C0, $E5, $81, $C7, $03, $86, $07, $00, $0C, $00
 db $03, $C3, $98, $D2, $2D, $CC, $41, $36, $0E, $F4
 db $19, $07, $63, $18, $90, $C8, $3A, $59, $8D, $06
 db $41, $C0, $03, $C1, $DE, $4D, $BD, $E0, $1E, $41
 db $DE, $83, $20, $EC, $7B, $D1, $19, $07, $4B, $BC
 db $98, $C8, $38, $00, $77, $C4, $27, $6C, $0E, $B8
 db $1D, $30, $39, $E0, $72, $C0, $E3, $81, $C3, $03
 db $80, $07, $7C, $0E, $D8, $1D, $70, $3A, $60, $73
 db $C0, $E5, $81, $C7, $03, $86, $07, $00, $0E, $F8
 db $1D, $B0, $3A, $E0, $74, $C0, $E7, $81, $CB, $03
 db $8E, $07, $0C, $0E, $00, $1D, $F0, $3B, $60, $75
 db $C0, $E9, $81, $CF, $03, $96, $07, $1C, $0E, $18
 db $1C, $00, $3B, $62, $23, $40, $75, $C4, $26, $80
 db $E8, $81, $A0, $39, $A0, $68, $0E, $58, $1A, $03
 db $8A, $06, $80, $F0, $E6, $34, $8B, $73, $10, $4D
 db $83, $BD, $06, $41, $D8, $C6, $24, $32, $0E, $96
 db $63, $41, $90, $70, $00, $F0, $77, $93, $6F, $78
 db $07, $90, $77, $A0, $C8, $3B, $1E, $F4, $46, $41
 db $D2, $EF, $26, $32, $0E, $00, $1D, $F1, $09, $DB
 db $03, $AE, $07, $4C, $0E, $78, $1C, $B0, $38, $E0
 db $70, $C0, $E0, $01, $DF, $03, $B6, $07, $5C, $0E
 db $98, $1C, $F0, $39, $60, $71, $C0, $E1, $81, $C0
 db $03, $BE, $07, $6C, $0E, $B8, $1D, $30, $39, $E0
 db $72, $C0, $E3, $81, $C3, $03, $80, $07, $7C, $0E
 db $D8, $1D, $70, $3A, $60, $73, $C0, $E5, $81, $C7
 db $03, $86, $07, $00, $0E, $D8, $88, $D0, $1D, $71
 db $09, $A0, $3A, $20, $68, $0E, $68, $1A, $03, $96
 db $06, $80, $E2, $81, $A0, $3C, $39, $8D, $22, $DC
 db $C4, $13, $60, $EF, $41, $90, $76, $31, $89, $0C
 db $83, $A5, $98, $D0, $64, $1C, $00, $3C, $1D, $E4
 db $DB, $DE, $01, $E4, $1D, $E8, $32, $0E, $C7, $BD
 db $11, $90, $74, $BB, $C9, $8C, $83, $80, $07, $7C
 db $42, $76, $C0, $EB, $81, $D3, $03, $9E, $07, $2C
 db $0E, $38, $1C, $30, $38, $00, $77, $C0, $ED, $81
 db $D7, $03, $A6, $07, $3C, $0E, $58, $1C, $70, $38
 db $60, $70, $00, $EF, $81, $DB, $03, $AE, $07, $4C
 db $0E, $78, $1C, $B0, $38, $E0, $70, $C0, $E0, $01
 db $DF, $03, $B6, $07, $5C, $0E, $98, $1C, $F0, $39
 db $60, $71, $C0, $E1, $81, $C0, $03, $B6, $22, $34
 db $07, $5C, $42, $68, $0E, $88, $1A, $03, $9A, $06
 db $80, $E5, $81, $A0, $38, $A0, $68, $0F, $0E, $63
 db $48, $B7, $31, $04, $D8, $3B, $D0, $64, $1D, $8C
 db $62, $43, $20, $E9, $66, $34, $19, $07, $00, $0F
 db $07, $79, $36, $F7, $80, $79, $07, $7A, $0C, $83
 db $B1, $EF, $44, $64, $1D, $2E, $F2, $63, $20, $E0
 db $01, $DF, $10, $9D, $B0, $3A, $E0, $74, $C0, $E7
 db $81, $CB, $03, $8E, $07, $0C, $0E, $00, $1D, $F0
 db $3B, $60, $75, $C0, $E9, $81, $CF, $03, $96, $07
 db $1C, $0E, $18, $1C, $00, $3B, $E0, $76, $C0, $EB
 db $81, $D3, $03, $9E, $07, $2C, $0E, $38, $1C, $30
 db $38, $00, $77, $C0, $ED, $81, $D7, $03, $A6, $07
 db $3C, $0E, $58, $1C, $70, $38, $60, $70, $00, $ED
 db $88, $8D, $01, $D7, $10, $9A, $03, $A2, $06, $80
 db $E6, $81, $A0, $39, $60, $68, $0E, $28, $1A, $03
 db $C3, $98, $D2, $2D, $CC, $41, $36, $0E, $F4, $19
 db $07, $63, $18, $90, $C8, $3A, $59, $8D, $06, $41
 db $C0, $03, $C1, $DE, $4D, $BD, $E0, $1E, $41, $DE
 db $83, $20, $EC, $7B, $D1, $19, $07, $4B, $BC, $98
 db $C8, $38, $00, $77, $C4, $27, $6C, $0E, $B8, $1D
 db $30, $39, $E0, $72, $C0, $E3, $81, $C3, $03, $80
 db $07, $7C, $0E, $D8, $1D, $70, $3A, $60, $73, $C0
 db $E5, $81, $C7, $03, $86, $07, $00, $0E, $F8, $1D
 db $B0, $3A, $E0, $74, $C0, $E7, $81, $CB, $03, $8E
 db $07, $0C, $0E, $00, $1D, $F0, $3B, $60, $75, $C0
 db $E9, $81, $CF, $03, $96, $07, $1C, $0E, $18, $1C
 db $00, $3B, $62, $23, $40, $75, $C4, $26, $80, $E8
 db $81, $A0, $39, $A0, $68, $0E, $58, $1A, $03, $8A
 db $06, $80, $F0, $E6, $34, $8B, $73, $10, $4D, $83
 db $BD, $06, $41, $D8, $C6, $24, $32, $0E, $96, $63
 db $41, $90, $70, $00, $F0, $77, $93, $6F, $78, $07
 db $90, $77, $A0, $C8, $3B, $1E, $F4, $46, $41, $D2
 db $EF, $26, $32, $0E, $00, $1D, $F1, $09, $DB, $03
 db $AE, $07, $4C, $0E, $78, $1C, $B0, $38, $E0, $70
 db $C0, $E0, $01, $DF, $03, $B6, $07, $5C, $0E, $98
 db $1C, $F0, $39, $60, $71, $C0, $E1, $81, $C0, $03
 db $BE, $07, $6C, $0E, $B8, $1D, $30, $39, $E0, $72
 db $C0, $E3, $81, $C3, $03, $80, $07, $7C, $0E, $D8
 db $1D, $70, $3A, $60, $73, $C0, $E5, $81, $C7, $03
 db $86, $07, $00, $0E, $D8, $88, $D0, $1D, $71, $09
 db $A0, $3A, $20, $68, $0E, $68, $1A, $03, $96, $06
 db $80, $E2, $81, $A0, $3C, $39, $8D, $22, $DC, $C4
 db $13, $60, $EF, $41, $90, $76, $31, $89, $0C, $83
 db $A5, $98, $D0, $64, $1C, $00, $3C, $1D, $E4, $DB
 db $DE, $01, $E4, $1D, $E8, $32, $0E, $C7, $BD, $11
 db $90, $74, $BB, $C9, $8C, $83, $80, $07, $7C, $42
 db $76, $C0, $EB, $81, $D3, $03, $9E, $07, $2C, $0E
 db $38, $1C, $30, $38, $00, $77, $C0, $ED, $81, $D7
 db $03, $A6, $07, $3C, $0E, $58, $1C, $70, $38, $60
 db $70, $00, $EF, $81, $DB, $03, $AE, $07, $4C, $0E
 db $78, $1C, $B0, $38, $E0, $70, $C0, $E0, $01, $DF
 db $03, $B6, $07, $5C, $0E, $98, $1C, $F0, $39, $60
 db $71, $C0, $E1, $81, $C0, $03, $B6, $22, $34, $07
 db $5C, $42, $68, $0E, $88, $1A, $03, $9A, $06, $80
 db $E5, $81, $A0, $38, $A0, $68, $0F, $0E, $63, $48
 db $B7, $31, $04, $D8, $3B, $D0, $64, $1D, $8C, $62
 db $43, $20, $E9, $66, $34, $19, $07, $00, $0F, $07
 db $79, $36, $F7, $80, $79, $07, $7A, $0C, $83, $B1
 db $EF, $44, $64, $1D, $2E, $F2, $63, $20, $E0, $01
 db $DF, $10, $9D, $B0, $3A, $E0, $74, $C0, $E7, $81
 db $CB, $03, $8E, $07, $0C, $0E, $00, $1D, $F0, $3B
 db $60, $75, $C0, $E9, $81, $CF, $03, $96, $07, $1C
 db $0E, $18, $1C, $00, $3B, $E0, $76, $C0, $EB, $81
 db $D3, $03, $9E, $07, $2C, $0E, $38, $1C, $30, $38
 db $00, $77, $C0, $ED, $81, $D7, $03, $A6, $07, $3C
 db $0E, $58, $1C, $70, $38, $60, $70, $00, $ED, $88
 db $8D, $01, $D7, $10, $9A, $03, $A2, $06, $80, $E6
 db $81, $A0, $39, $60, $68, $0E, $28, $1A, $03, $C3
 db $98, $D2, $2D, $CC, $41, $36, $0E, $F4, $19, $07
 db $63, $18, $90, $C8, $3A, $59, $8D, $06, $41, $C0
 db $03, $C3, $DE, $4D, $BD, $E0, $1E, $C1, $DE, $83
 db $20, $EC, $7B, $D1, $19, $07, $4B, $BC, $98, $C8
 db $38, $00, $78, $73, $F8, $D7, $AB, $F0, $16, $E5
 db $AA, $8D, $FF, $61, $49, $BB, $DC, $68, $39, $BB
 db $F4, $A7, $37, $7B, $8C, $C6, $E3, $89, $4D, $DF
 db $A5, $21, $B2, $33, $BE, $21, $3B, $60, $75, $C0
 db $E9, $81, $CF, $03, $96, $07, $1C, $0E, $18, $1C
 db $00, $3B, $E0, $76, $C0, $EB, $81, $D3, $03, $9E
 db $07, $2C, $0E, $38, $1C, $30, $38, $00, $77, $C0
 db $ED, $81, $D7, $03, $A6, $07, $3C, $0E, $58, $1C
 db $70, $38, $60, $70, $00, $F0, $E7, $F1, $AF, $4D
 db $CB, $55, $1B, $FE, $C2, $93, $77, $B8, $D0, $73
 db $77, $E9, $4E, $6E, $F7, $19, $8D, $C7, $12, $9B
 db $BF, $4A, $43, $64, $65, $11, $C0, $03, $00, $03
 db $C3, $98, $D1, $B9, $88, $26, $C1, $DE, $83, $20
 db $EC, $63, $12, $19, $07, $4B, $31, $A0, $C8, $38
 db $00, $78, $7B, $C9, $B7, $BC, $03, $D8, $3B, $D0
 db $64, $1D, $8F, $7A, $23, $20, $E9, $77, $93, $19
 db $07, $00, $0F, $0E, $7F, $1A, $F5, $7E, $02, $DC
 db $B5, $51, $BF, $EC, $29, $37, $7B, $8D, $07, $37
 db $7E, $94, $E6, $EF, $71, $98, $DC, $71, $29, $BB
 db $F4, $A4, $36, $46, $77, $C4, $27, $6C, $0E, $B8
 db $1D, $30, $39, $E0, $72, $C0, $E3, $81, $C3, $03
 db $80, $07, $7C, $0E, $D8, $1D, $70, $3A, $60, $73
 db $C0, $E5, $81, $C7, $03, $86, $07, $00, $0E, $F8
 db $1D, $B0, $3A, $E0, $74, $C0, $E7, $81, $CB, $03
 db $8E, $07, $0C, $0E, $00, $1E, $1C, $FE, $35, $E9
 db $B9, $6A, $A3, $7F, $D8, $52, $6E, $F7, $1A, $0E
 db $6E, $FD, $29, $CD, $DE, $E3, $31, $B8, $E2, $53
 db $77, $E9, $48, $6C, $8C, $A2, $38, $00, $60, $00
 db $78, $73, $1A, $37, $31, $04, $D8, $3B, $D0, $64
 db $1D, $8C, $62, $43, $20, $E9, $66, $34, $19, $07
 db $00, $0F, $0F, $79, $36, $F7, $80, $7B, $07, $7A
 db $0C, $83, $B1, $EF, $44, $64, $1D, $2E, $F2, $63
 db $20, $E0, $01, $E1, $CF, $E3, $5E, $AF, $C0, $5B
 db $96, $AA, $37, $FD, $85, $26, $EF, $71, $A0, $E6
 db $EF, $D2, $9C, $DD, $EE, $33, $1B, $8E, $25, $37
 db $7E, $94, $86, $C8, $CE, $F8, $84, $ED, $81, $D7
 db $03, $A6, $07, $3C, $0E, $58, $1C, $70, $38, $60
 db $70, $00, $EF, $81, $DB, $03, $AE, $07, $4C, $0E
 db $78, $1C, $B0, $38, $E0, $70, $C0, $E0, $01, $DF
 db $03, $B6, $07, $5C, $0E, $98, $1C, $F0, $39, $60
 db $71, $C0, $E1, $81, $C0, $03, $C3, $9F, $C6, $BD
 db $37, $2D, $54, $6F, $FB, $0A, $4D, $DE, $E3, $41
 db $CD, $DF, $A5, $39, $BB, $DC, $66, $37, $1C, $4A
 db $6E, $FD, $29, $0D, $91, $94, $47, $00, $0C, $00
 db $0F, $0E, $63, $46, $E6, $20, $9B, $07, $7A, $0C
 db $83, $B1, $8C, $48, $64, $1D, $2C, $C6, $83, $20
 db $E0, $01, $E1, $EF, $26, $DE, $F0, $0F, $60, $EF
 db $41, $90, $76, $3D, $E8, $8C, $83, $A5, $DE, $4C
 db $64, $1C, $00, $3C, $39, $FC, $6B, $D5, $F8, $0B
 db $72, $D5, $46, $FF, $B0, $A4, $DD, $EE, $34, $1C
 db $DD, $FA, $53, $9B, $BD, $C6, $63, $71, $C4, $A6
 db $EF, $D2, $90, $D9, $19, $DF, $10, $9D, $B0, $3A
 db $E0, $74, $C0, $E7, $81, $CB, $03, $8E, $07, $0C
 db $0E, $00, $1D, $F0, $3B, $60, $75, $C0, $E9, $81
 db $CF, $03, $96, $07, $1C, $0E, $18, $1C, $00, $3B
 db $E0, $76, $C0, $EB, $81, $D3, $03, $9E, $07, $2C
 db $0E, $38, $1C, $30, $38, $00, $78, $73, $F8, $D7
 db $A6, $E5, $AA, $8D, $FF, $61, $49, $BB, $DC, $68
 db $39, $BB, $F4, $A7, $37, $7B, $8C, $C6, $E3, $89
 db $4D, $DF, $A5, $21, $B2, $32, $88, $E0, $01, $80
 db $01, $E1, $CC, $68, $DC, $C4, $13, $60, $EF, $41
 db $90, $76, $31, $89, $0C, $83, $A5, $98, $D0, $64
 db $1C, $00, $3C, $3D, $E4, $DB, $DE, $01, $EC, $1D
 db $E8, $32, $0E, $C7, $BD, $11, $90, $74, $BB, $C9
 db $8C, $83, $80, $07, $87, $3F, $8D, $7A, $BF, $01
 db $6E, $5A, $A8, $DF, $F6, $14, $9B, $BD, $C6, $83
 db $9B, $BF, $4A, $73, $77, $B8, $CC, $6E, $38, $94
 db $DD, $FA, $52, $1B, $23, $3B, $E2, $13, $B6, $07
 db $5C, $0E, $98, $1C, $F0, $39, $60, $71, $C0, $E1
 db $81, $C0, $03, $BE, $07, $6C, $0E, $B8, $1D, $30
 db $39, $E0, $72, $C0, $E3, $81, $C3, $03, $80, $07
 db $7C, $0E, $D8, $1D, $70, $3A, $60, $73, $C0, $E5
 db $81, $C7, $03, $86, $07, $00, $0F, $0E, $7F, $1A
 db $F4, $DC, $B5, $51, $BF, $EC, $29, $37, $7B, $8D
 db $07, $37, $7E, $94, $E6, $EF, $71, $98, $DC, $71
 db $29, $BB, $F4, $A4, $36, $46, $51, $1C, $00, $30
 db $00, $3C, $39, $8D, $1B, $98, $82, $6C, $1D, $E8
 db $32, $0E, $C6, $31, $21, $90, $74, $B3, $1A, $0C
 db $83, $80, $07, $87, $BC, $9B, $7B, $C0, $3D, $83
 db $BD, $06, $41, $D8, $F7, $A2, $32, $0E, $97, $79
 db $31, $90, $70, $00, $F0, $E7, $F1, $AF, $57, $E0
 db $2D, $CB, $55, $1B, $FE, $C2, $93, $77, $B8, $D0
 db $73, $77, $E9, $4E, $6E, $F7, $19, $8D, $C7, $12
 db $9B, $BF, $4A, $43, $64, $67, $7C, $42, $76, $C0
 db $EB, $81, $D3, $03, $9E, $07, $2C, $0E, $38, $1C
 db $30, $38, $00, $77, $C0, $ED, $81, $D7, $03, $A6
 db $07, $3C, $0E, $58, $1C, $70, $38, $60, $70, $00
 db $EF, $81, $DB, $03, $AE, $07, $4C, $0E, $78, $1C
 db $B0, $38, $E0, $70, $C0, $E0, $01, $E1, $CF, $E3
 db $5E, $9B, $96, $AA, $37, $FD, $85, $26, $EF, $71
 db $A0, $E6, $EF, $D2, $9C, $DD, $EE, $33, $1B, $8E
 db $25, $37, $7E, $94, $86, $C8, $CA, $23, $80, $06
 db $00, $07, $87, $31, $A3, $73, $10, $4D, $83, $BD
 db $06, $41, $D8, $C6, $24, $32, $0E, $96, $63, $41
 db $90, $70, $00, $F0, $F7, $93, $6F, $78, $07, $B0
 db $77, $A0, $C8, $3B, $1E, $F4, $46, $41, $D2, $EF
 db $26, $32, $0E, $00, $1E, $1C, $FE, $35, $EA, $FC
 db $05, $B9, $6A, $A3, $7F, $D8, $52, $6E, $F7, $1A
 db $0E, $6E, $FD, $29, $CD, $DE, $E3, $31, $B8, $E2
 db $53, $77, $E9, $48, $6C, $8C, $EF, $88, $4E, $D8
 db $1D, $70, $3A, $60, $73, $C0, $E5, $81, $C7, $03
 db $86, $07, $00, $0E, $F8, $1D, $B0, $3A, $E0, $74
 db $C0, $E7, $81, $CB, $03, $8E, $07, $0C, $0E, $00
 db $1D, $F0, $3B, $60, $75, $C0, $E9, $81, $CF, $03
 db $96, $07, $1C, $0E, $18, $1C, $00, $3C, $39, $FC
 db $6B, $D3, $72, $D5, $46, $FF, $B0, $A4, $DD, $EE
 db $34, $1C, $DD, $FA, $53, $9B, $BD, $C6, $63, $71
 db $C4, $A6, $EF, $D2, $90, $D9, $19, $44, $70, $00
 db $C0, $00, $F0, $E6, $34, $6E, $62, $09, $B0, $77
 db $A0, $C8, $3B, $18, $C4, $86, $41, $D2, $CC, $68
 db $32, $0E, $00, $1E, $1E, $F2, $6D, $EF, $00, $F6
 db $0E, $F4, $19, $07, $63, $DE, $88, $C8, $3A, $5D
 db $E4, $C6, $41, $C0, $03, $C3, $9F, $C6, $BD, $5F
 db $80, $B7, $2D, $54, $6F, $FB, $0A, $4D, $DE, $E3
 db $41, $CD, $DF, $A5, $39, $BB, $DC, $66, $37, $1C
 db $4A, $6E, $FD, $29, $0D, $91, $9D, $F1, $09, $DB
 db $03, $AE, $07, $4C, $0E, $78, $1C, $B0, $38, $E0
 db $70, $C0, $E0, $01, $DF, $03, $B6, $07, $5C, $0E
 db $98, $1C, $F0, $39, $60, $71, $C0, $E1, $81, $C0
 db $03, $BE, $07, $6C, $0E, $B8, $1D, $30, $39, $E0
 db $72, $C0, $E3, $81, $C3, $03, $80, $07, $87, $3F
 db $8D, $7A, $6E, $5A, $A8, $DF, $F6, $14, $9B, $BD
 db $C6, $83, $9B, $BF, $4A, $73, $77, $B8, $CC, $6E
 db $38, $94, $DD, $FA, $52, $1B, $23, $28, $8E, $00
 db $18, $00, $1E, $1C, $C6, $8D, $CC, $41, $36, $0E
 db $F4, $19, $07, $63, $18, $90, $C8, $3A, $59, $8D
 db $06, $41, $C0, $03, $C3, $DE, $4D, $BD, $E0, $1E
 db $C1, $DE, $83, $20, $EC, $7B, $D1, $19, $07, $4B
 db $BC, $98, $C8, $38, $00, $78, $73, $F8, $D7, $AB
 db $F0, $16, $E5, $AA, $8D, $FF, $61, $49, $BB, $DC
 db $68, $39, $BB, $F4, $A7, $37, $7B, $8C, $C6, $E3
 db $89, $4D, $DF, $A5, $21, $B2, $33, $BE, $21, $3B
 db $60, $75, $C0, $E9, $81, $CF, $03, $96, $07, $1C
 db $0E, $18, $1C, $00, $3B, $DE, $F4, $46, $7D, $F0
 db $1C, $EF, $7A, $23, $B9, $BB, $C0, $67, $BD, $11
 db $C6, $FB, $E0, $39, $DE, $F4, $47, $43, $77, $80
 db $E0, $7B, $D1, $1D, $F0, $3B, $60, $75, $C0, $E9
 db $81, $CF, $03, $96, $07, $1C, $0E, $18, $1C, $00
 db $3C, $39, $FA, $BD, $37, $2D, $54, $6F, $FB, $0A
 db $4D, $DE, $E3, $41, $CD, $DF, $A5, $39, $BB, $DC
 db $66, $37, $1C, $4A, $6E, $FD, $29, $0D, $91, $9D
 db $EF, $BE, $03, $37, $70, $E7, $7D, $E1, $DC, $CF
 db $03, $3E, $F0, $E3, $6E, $E1, $CE, $FB, $C3, $A1
 db $9E, $07, $03, $EF, $0F, $0E, $63, $48, $B7, $31
 db $04, $D8, $3B, $D0, $64, $1D, $8C, $62, $43, $20
 db $E9, $66, $34, $19, $07, $00, $0F, $0F, $79, $36
 db $F7, $80, $7B, $07, $7A, $0C, $83, $B1, $EF, $44
 db $64, $1D, $2E, $F2, $63, $20, $E0, $01, $E1, $CF
 db $E3, $5E, $AF, $C0, $5B, $96, $AA, $37, $FD, $85
 db $26, $EF, $71, $A0, $E6, $EF, $D2, $9C, $DD, $EE
 db $33, $1B, $8E, $25, $37, $7E, $94, $86, $C8, $CE
 db $F8, $84, $ED, $81, $D7, $03, $A6, $07, $3C, $0E
 db $58, $1C, $70, $38, $60, $70, $00, $EF, $7D, $F0
 db $19, $BB, $87, $3B, $EF, $0E, $E6, $78, $19, $F7
 db $87, $1B, $77, $0E, $77, $DE, $1D, $0C, $F0, $38
 db $1F, $78, $77, $C0, $ED, $81, $D7, $03, $A6, $07
 db $3C, $0E, $58, $1C, $70, $38, $60, $70, $00, $F0
 db $E7, $F1, $AF, $4D, $CB, $55, $1B, $FE, $C2, $93
 db $77, $B8, $D0, $73, $77, $E9, $4E, $6E, $F7, $19
 db $8D, $C7, $12, $9B, $BF, $4A, $43, $64, $65, $11
 db $C0, $03, $00, $03, $C3, $98, $D1, $B9, $88, $26
 db $C1, $DE, $83, $20, $EC, $63, $12, $19, $07, $4B
 db $31, $A0, $C8, $38, $00, $78, $7B, $C9, $B7, $BC
 db $03, $D8, $3B, $D0, $64, $1D, $8F, $7A, $23, $20
 db $E9, $77, $93, $19, $07, $00, $0F, $0E, $7F, $1A
 db $F5, $7E, $02, $DC, $B5, $51, $BF, $EC, $29, $37
 db $7B, $8D, $07, $37, $7E, $94, $E6, $EF, $71, $98
 db $DC, $71, $29, $BB, $F4, $A4, $36, $46, $77, $C4
 db $27, $6C, $0E, $B8, $1D, $30, $39, $E0, $72, $C0
 db $E3, $81, $C3, $03, $80, $07, $7B, $DE, $88, $CF
 db $BE, $03, $9D, $EF, $44, $77, $37, $78, $0C, $F7
 db $A2, $38, $DF, $7C, $07, $3B, $DE, $88, $E8, $6E
 db $F0, $1C, $0F, $7A, $23, $BE, $07, $6C, $0E, $B8
 db $1D, $30, $39, $E0, $72, $C0, $E3, $81, $C3, $03
 db $80, $07, $87, $3F, $57, $A6, $E5, $AA, $8D, $FF
 db $61, $49, $BB, $DC, $68, $39, $BB, $F4, $A7, $37
 db $7B, $8C, $C6, $E3, $89, $4D, $DF, $A5, $21, $B2
 db $33, $BD, $F7, $C0, $66, $EE, $1C, $EF, $BC, $3B
 db $99, $E0, $67, $DE, $1C, $6D, $DC, $39, $DF, $78
 db $74, $33, $C0, $E0, $7D, $E1, $E1, $CC, $69, $16
 db $E6, $20, $9B, $07, $7A, $0C, $83, $B1, $8C, $48
 db $64, $1D, $2C, $C6, $83, $20, $E0, $01, $E1, $EF
 db $26, $DE, $F0, $0F, $60, $EF, $41, $90, $76, $3D
 db $E8, $8C, $83, $A5, $DE, $4C, $64, $1C, $00, $3C
 db $39, $FC, $6B, $D5, $F8, $0B, $72, $D5, $46, $FF
 db $B0, $A4, $DD, $EE, $34, $1C, $DD, $FA, $53, $9B
 db $BD, $C6, $63, $71, $C4, $A6, $EF, $D2, $90, $D9
 db $19, $DF, $10, $9D, $B0, $3A, $E0, $74, $C0, $E7
 db $81, $CB, $03, $8E, $07, $0C, $0E, $00, $1D, $EF
 db $BE, $03, $37, $70, $E7, $7D, $E1, $DC, $CF, $03
 db $3E, $F0, $E3, $6E, $E1, $CE, $FB, $C3, $A1, $9E
 db $07, $03, $EF, $0E, $F8, $1D, $B0, $3A, $E0, $74
 db $C0, $E7, $81, $CB, $03, $8E, $07, $0C, $0E, $00
 db $1E, $1C, $FE, $35, $E9, $B9, $6A, $A3, $7F, $D8
 db $52, $6E, $F7, $1A, $0E, $6E, $FD, $29, $CD, $DE
 db $E3, $31, $B8, $E2, $53, $77, $E9, $48, $6C, $8C
 db $A2, $38, $00, $60, $00, $78, $73, $1A, $37, $31
 db $04, $D8, $3B, $D0, $64, $1D, $8C, $62, $43, $20
 db $E9, $66, $34, $19, $07, $00, $0F, $0F, $79, $36
 db $F7, $80, $7B, $07, $7A, $0C, $83, $B1, $EF, $44
 db $64, $1D, $2E, $F2, $63, $20, $E0, $01, $E1, $CF
 db $E3, $5E, $AF, $C0, $5B, $96, $AA, $37, $FD, $85
 db $26, $EF, $71, $A0, $E6, $EF, $D2, $9C, $DD, $EE
 db $33, $1B, $8E, $25, $37, $7E, $94, $86, $C8, $CE
 db $F8, $84, $ED, $81, $D7, $03, $A6, $07, $3C, $0E
 db $58, $1C, $70, $38, $60, $70, $00, $EF, $7B, $D1
 db $19, $F7, $C0, $73, $BD, $E8, $8E, $E6, $EF, $01
 db $9E, $F4, $47, $1B, $EF, $80, $E7, $7B, $D1, $1D
 db $0D, $DE, $03, $81, $EF, $44, $77, $C0, $ED, $81
 db $D7, $03, $A6, $07, $3C, $0E, $58, $1C, $70, $38
 db $60, $70, $00, $F0, $E7, $EA, $F4, $DC, $B5, $51
 db $BF, $EC, $29, $37, $7B, $8D, $07, $37, $7E, $94
 db $E6, $EF, $71, $98, $DC, $71, $29, $BB, $F4, $A4
 db $36, $46, $77, $BE, $F8, $0C, $DD, $C3, $9D, $F7
 db $87, $73, $3C, $0C, $FB, $C3, $8D, $BB, $87, $3B
 db $EF, $0E, $86, $78, $1C, $0F, $BC, $3C, $39, $8D
 db $22, $DC, $C4, $13, $60, $EF, $41, $90, $76, $31
 db $89, $0C, $83, $A5, $98, $D0, $64, $1C, $00, $3C
 db $3D, $E4, $DB, $DE, $01, $EC, $1D, $E8, $32, $0E
 db $C7, $BD, $11, $90, $74, $BB, $C9, $8C, $83, $80
 db $07, $87, $3F, $8D, $7A, $BF, $01, $6E, $5A, $A8
 db $DF, $F6, $14, $9B, $BD, $C6, $83, $9B, $BF, $4A
 db $73, $77, $B8, $CC, $6E, $38, $94, $DD, $FA, $52
 db $1B, $23, $3B, $E2, $13, $B6, $07, $5C, $0E, $98
 db $1C, $F0, $39, $60, $71, $C0, $E1, $81, $C0, $03
 db $BD, $F7, $C0, $66, $EE, $1C, $EF, $BC, $3B, $99
 db $E0, $67, $DE, $1C, $6D, $DC, $39, $DF, $78, $74
 db $33, $C0, $E0, $7D, $E1, $DF, $03, $B6, $07, $5C
 db $0E, $98, $1C, $F0, $39, $60, $71, $C0, $E1, $81
 db $C0, $03, $C3, $9F, $C6, $BD, $37, $2D, $54, $6F
 db $FB, $0A, $4D, $DE, $E3, $41, $CD, $DF, $A5, $39
 db $BB, $DC, $66, $37, $1C, $4A, $6E, $FD, $29, $0D
 db $91, $94, $47, $00, $0C, $00, $0F, $0E, $63, $46
 db $E6, $20, $9B, $07, $7A, $0C, $83, $B1, $8C, $48
 db $64, $1D, $2C, $C6, $83, $20, $E0, $01, $E1, $EF
 db $26, $DE, $F0, $0F, $60, $EF, $41, $90, $76, $3D
 db $E8, $8C, $83, $A5, $DE, $4C, $64, $1C, $00, $3C
 db $39, $FC, $6B, $D5, $F8, $0B, $72, $D5, $46, $FF
 db $B0, $A4, $DD, $EE, $34, $1C, $DD, $FA, $53, $9B
 db $BD, $C6, $63, $71, $C4, $A6, $EF, $D2, $90, $D9
 db $19, $DF, $10, $9D, $B0, $3A, $E0, $74, $C0, $E7
 db $81, $CB, $03, $8E, $07, $0C, $0E, $00, $1D, $EF
 db $7A, $23, $3E, $F8, $0E, $77, $BD, $11, $DC, $DD
 db $E0, $33, $DE, $88, $E3, $7D, $F0, $1C, $EF, $7A
 db $23, $A1, $BB, $C0, $70, $3D, $E8, $8E, $F8, $1D
 db $B0, $3A, $E0, $74, $C0, $E7, $81, $CB, $03, $8E
 db $07, $0C, $0E, $00, $1E, $1C, $FD, $5E, $9B, $96
 db $AA, $37, $FD, $85, $26, $EF, $71, $A0, $E6, $EF
 db $D2, $9C, $DD, $EE, $33, $1B, $8E, $25, $37, $7E
 db $94, $86, $C8, $CE, $F7, $DF, $01, $9B, $B8, $73
 db $BE, $F0, $EE, $67, $81, $9F, $78, $71, $B7, $70
 db $E7, $7D, $E1, $D0, $CF, $03, $81, $F7, $87, $87
 db $31, $A4, $5B, $98, $82, $6C, $1D, $E8, $32, $0E
 db $C6, $31, $21, $90, $74, $B3, $1A, $0C, $83, $80
 db $07, $87, $BC, $9B, $7B, $C0, $3D, $83, $BD, $06
 db $41, $D8, $F7, $A2, $32, $0E, $97, $79, $31, $90
 db $70, $00, $F0, $E7, $F1, $AF, $57, $E0, $2D, $CB
 db $55, $1B, $FE, $C2, $93, $77, $B8, $D0, $73, $77
 db $E9, $4E, $6E, $F7, $19, $8D, $C7, $12, $9B, $BF
 db $4A, $43, $64, $67, $7C, $42, $76, $C0, $EB, $81
 db $D3, $03, $9E, $07, $2C, $0E, $38, $1C, $30, $38
 db $00, $77, $BE, $F8, $0C, $DD, $C3, $9D, $F7, $87
 db $73, $3C, $0C, $FB, $C3, $8D, $BB, $87, $3B, $EF
 db $0E, $86, $78, $1C, $0F, $BC, $3B, $E0, $76, $C0
 db $EB, $81, $D3, $03, $9E, $07, $2C, $0E, $38, $1C
 db $30, $38, $00, $78, $73, $F8, $D7, $A6, $E5, $AA
 db $8D, $FF, $61, $49, $BB, $DC, $68, $39, $BB, $F4
 db $A7, $37, $7B, $8C, $C6, $E3, $89, $4D, $DF, $A5
 db $21, $B2, $32, $88, $E0, $01, $80, $01, $DB, $10
 db $9A, $07, $1C, $0D, $03, $B6, $22, $34, $0E, $38
 db $1A, $07, $6C, $46, $68, $1C, $70, $34, $0E, $D8
 db $90, $D0, $38, $E0, $68, $1D, $B1, $29, $A0, $71
 db $C0, $D0, $3B, $62, $63, $40, $E3, $81, $A0, $76
 db $C4, $E6, $81, $C7, $03, $40, $ED, $8A, $0D, $03
 db $8E, $06, $81, $DB, $14, $9A, $07, $1C, $0D, $03
 db $B6, $2A, $34, $0E, $38, $1A, $07, $6C, $56, $68
 db $1C, $70, $34, $0E, $D8, $B0, $D0, $38, $E0, $68
 db $1D, $B1, $69, $A0, $71, $C0, $D0, $3B, $62, $E3
 db $40, $E3, $81, $A0, $76, $C5, $E6, $81, $C7, $03
 db $40, $ED, $8C, $0D, $03, $8E, $06, $81, $DB, $18
 db $9A, $07, $1C, $0D, $03, $B6, $32, $34, $0E, $38
 db $1A, $07, $6C, $62, $68, $1C, $70, $34, $0E, $D8
 db $C0, $D0, $38, $E0, $68, $1D, $B1, $79, $A0, $71
 db $C0, $D0, $3B, $62, $E3, $40, $E3, $81, $A0, $76
 db $C5, $A6, $81, $C7, $03, $40, $ED, $8B, $0D, $03
 db $8E, $06, $81, $DB, $15, $9A, $07, $1C, $0D, $03
 db $B6, $2A, $34, $0E, $38, $1A, $07, $6C, $52, $68
 db $1C, $70, $34, $0E, $D8, $A0, $D0, $38, $E0, $68
 db $1D, $B1, $39, $A0, $71, $C0, $D0, $3B, $62, $63
 db $40, $E3, $81, $A0, $76, $C4, $A6, $81, $C7, $03
 db $40, $ED, $89, $0D, $03, $8E, $06, $81, $DB, $11
 db $9A, $07, $1C, $0D, $03, $B6, $22, $34, $0E, $38
 db $1A, $07, $00, $0C, $00, $0E, $FF, $25, $19, $8C
 db $C6, $24, $33, $A4, $0E, $E6, $49, $31, $9D, $E0
 db $70, $00, $C0, $0F, $0C, $8B, $7B, $C0, $3D, $83
 db $BD, $06, $41, $D8, $F7, $A2, $32, $0E, $97, $79
 db $31, $90, $70, $00, $F0, $E7, $F1, $AF, $57, $E0
 db $2D, $CB, $55, $1B, $FE, $C2, $93, $77, $B8, $D0
 db $73, $77, $E9, $4E, $6E, $F7, $19, $8D, $C7, $12
 db $9B, $BF, $4A, $43, $64, $67, $6C, $44, $68, $0E
 db $B8, $84, $D0, $1D, $10, $34, $07, $7B, $DE, $88
 db $CF, $BE, $03, $9D, $EF, $44, $77, $37, $78, $0C
 db $F7, $A2, $38, $DF, $7C, $07, $3B, $DE, $88, $E8
 db $6E, $F0, $1C, $0F, $7A, $23, $BE, $07, $6C, $0E
 db $B8, $1D, $30, $39, $E0, $72, $C0, $E3, $81, $C3
 db $03, $80, $07, $87, $3F, $57, $A6, $E5, $AA, $8D
 db $FF, $61, $49, $BB, $DC, $68, $39, $BB, $F4, $A7
 db $37, $7B, $8C, $C6, $E3, $89, $4D, $DF, $A5, $21
 db $B2, $33, $BD, $F7, $C0, $66, $EE, $1C, $EF, $BC
 db $3B, $99, $E0, $67, $DE, $1C, $6D, $DC, $39, $DF
 db $78, $74, $33, $C0, $E0, $7D, $E1, $DF, $E4, $A3
 db $31, $98, $C4, $86, $74, $81, $DC, $C9, $26, $33
 db $BC, $0E, $00, $18, $01, $E1, $91, $6F, $78, $07
 db $B0, $77, $A0, $C8, $3B, $1E, $F4, $46, $41, $D2
 db $EF, $26, $32, $0E, $00, $1E, $1C, $FE, $35, $EA
 db $FC, $05, $B9, $6A, $A3, $7F, $D8, $52, $6E, $F7
 db $1A, $0E, $6E, $FD, $29, $CD, $DE, $E3, $31, $B8
 db $E2, $53, $77, $E9, $48, $6C, $8C, $EF, $F2, $51
 db $98, $CC, $62, $43, $3A, $40, $EE, $64, $93, $19
 db $DE, $07, $00, $0C, $00, $EE, $E4, $50, $F4, $ED
 db $62, $21, $DC, $C8, $83, $B5, $88, $86, $64, $41
 db $C0, $C4, $43, $00, $3B, $B8, $F0, $76, $B0, $F0
 db $EE, $63, $C1, $DA, $C3, $C3, $31, $E0, $E0, $61
 db $E1, $80, $1E, $1C, $FE, $35, $E9, $B9, $6A, $A3
 db $7F, $D8, $52, $6E, $F7, $1A, $0E, $6E, $FD, $29
 db $CD, $DE, $E3, $31, $B8, $E2, $53, $77, $E9, $48
 db $6C, $8C, $ED, $88, $8D, $01, $D7, $10, $9A, $03
 db $A2, $06, $80, $EF, $F2, $51, $98, $CC, $62, $43
 db $3A, $40, $EE, $64, $93, $19, $DE, $07, $00, $0C
 db $00, $F0, $C8, $B7, $BC, $03, $D8, $3B, $D0, $64
 db $1D, $8F, $7A, $23, $20, $E9, $77, $93, $19, $07
 db $00, $0F, $0E, $7F, $1A, $F5, $7E, $02, $DC, $B5
 db $51, $BF, $EC, $29, $37, $7B, $8D, $07, $37, $7E
 db $94, $E6, $EF, $71, $98, $DC, $71, $29, $BB, $F4
 db $A4, $36, $46, $77, $C4, $27, $6C, $0E, $B8, $1D
 db $30, $39, $E0, $72, $C0, $E3, $81, $C3, $03, $80
 db $07, $7B, $DE, $88, $CF, $BE, $03, $9D, $EF, $44
 db $77, $37, $78, $0C, $F7, $A2, $38, $DF, $7C, $07
 db $3B, $DE, $88, $E8, $6E, $F0, $1C, $0F, $7A, $23
 db $BE, $07, $6C, $0E, $B8, $1D, $30, $39, $E0, $72
 db $C0, $E3, $81, $C3, $03, $80, $07, $87, $3F, $57
 db $A6, $E5, $AA, $8D, $FF, $61, $49, $BB, $DC, $68
 db $39, $BB, $F4, $A7, $37, $7B, $8C, $C6, $E3, $89
 db $4D, $DF, $A5, $21, $B2, $33, $BD, $F7, $C0, $66
 db $EE, $1C, $EF, $BC, $3B, $99, $E0, $67, $DE, $1C
 db $6D, $DC, $39, $DF, $78, $74, $33, $C0, $E0, $7D
 db $E1, $DF, $E4, $A3, $31, $98, $C4, $86, $74, $81
 db $DC, $C9, $26, $33, $BC, $0E, $00, $18, $01, $E1
 db $91, $6F, $78, $07, $B0, $77, $A0, $C8, $3B, $1E
 db $F4, $46, $41, $D2, $EF, $26, $32, $0E, $00, $1E
 db $1C, $FE, $35, $EA, $FC, $05, $B9, $6A, $A3, $7F
 db $D8, $52, $6E, $F7, $1A, $0E, $6E, $FD, $29, $CD
 db $DE, $E3, $31, $B8, $E2, $53, $77, $E9, $48, $6C
 db $8C, $ED, $88, $8D, $01, $D7, $10, $9A, $03, $A2
 db $06, $80, $ED, $E7, $90, $90, $EE, $EE, $EA, $0E
 db $FE, $78, $84, $EE, $7D, $E1, $DE, $CF, $03, $B1
 db $BB, $87, $5B, $3C, $0E, $A6, $EE, $1D, $2C, $F0
 db $3B, $E0, $76, $C0, $EB, $81, $D3, $03, $9E, $07
 db $2C, $0E, $38, $1C, $30, $38, $00, $78, $73, $F8
 db $D7, $A6, $E5, $AA, $8D, $FF, $61, $49, $BB, $DC
 db $68, $39, $BB, $F4, $A7, $37, $7B, $8C, $C6, $E3
 db $89, $4D, $DF, $A5, $21, $B2, $33, $B6, $22, $34
 db $07, $5C, $42, $68, $0E, $88, $1A, $03, $BF, $C9
 db $46, $63, $31, $89, $0C, $E9, $03, $B9, $92, $4C
 db $67, $78, $1C, $00, $30, $03, $C3, $22, $DE, $F0
 db $0F, $60, $EF, $41, $90, $76, $3D, $E8, $8C, $83
 db $A5, $DE, $4C, $64, $1C, $00, $3C, $39, $FC, $6B
 db $D5, $F8, $0B, $72, $D5, $46, $FF, $B0, $A4, $DD
 db $EE, $34, $1C, $DD, $FA, $53, $9B, $BD, $C6, $63
 db $71, $C4, $A6, $EF, $D2, $90, $D9, $19, $DB, $11
 db $1A, $03, $AE, $21, $34, $07, $44, $0D, $01, $DE
 db $F7, $A2, $33, $EF, $80, $E7, $7B, $D1, $1D, $CD
 db $DE, $03, $3D, $E8, $8E, $37, $DF, $01, $CE, $F7
 db $A2, $3A, $1B, $BC, $07, $03, $DE, $88, $EF, $81
 db $DB, $03, $AE, $07, $4C, $0E, $78, $1C, $B0, $38
 db $E0, $70, $C0, $E0, $01, $E1, $CF, $D5, $E9, $B9
 db $6A, $A3, $7F, $D8, $52, $6E, $F7, $1A, $0E, $6E
 db $FD, $29, $CD, $DE, $E3, $31, $B8, $E2, $53, $77
 db $E9, $48, $6C, $8C, $EF, $7D, $F0, $19, $BB, $87
 db $3B, $EF, $0E, $E6, $78, $19, $F7, $87, $1B, $77
 db $0E, $77, $DE, $1D, $0C, $F0, $38, $1F, $78, $77
 db $F9, $28, $CC, $66, $31, $21, $9D, $20, $77, $32
 db $49, $8C, $EF, $03, $80, $06, $00, $78, $64, $5B
 db $DE, $01, $EC, $1D, $E8, $32, $0E, $C7, $BD, $11
 db $90, $74, $BB, $C9, $8C, $83, $80, $07, $87, $3F
 db $8D, $7A, $BF, $01, $6E, $5A, $A8, $DF, $F6, $14
 db $9B, $BD, $C6, $83, $9B, $BF, $4A, $73, $77, $B8
 db $CC, $6E, $38, $94, $DD, $FA, $52, $1B, $23, $3B
 db $FC, $94, $66, $33, $18, $90, $CE, $90, $3B, $99
 db $24, $C6, $77, $81, $C0, $03, $00, $3B, $B9, $14
 db $3D, $3B, $58, $88, $77, $32, $20, $ED, $62, $21
 db $99, $10, $70, $31, $10, $C0, $0E, $EE, $3C, $1D
 db $AC, $3C, $3B, $98, $F0, $76, $B0, $F0, $CC, $78
 db $38, $18, $78, $60, $07, $87, $3F, $8D, $7A, $6E
 db $5A, $A8, $DF, $F6, $14, $9B, $BD, $C6, $83, $9B
 db $BF, $4A, $73, $77, $B8, $CC, $6E, $38, $94, $DD
 db $FA, $52, $1B, $23, $3B, $62, $23, $40, $75, $C4
 db $26, $80, $E8, $81, $A0, $3B, $FC, $94, $66, $33
 db $18, $90, $CE, $90, $3B, $99, $24, $C6, $77, $81
 db $C0, $03, $00, $3C, $32, $2D, $EF, $00, $F6, $0E
 db $F4, $19, $07, $63, $DE, $88, $C8, $3A, $5D, $E4
 db $C6, $41, $C0, $03, $C3, $9F, $C6, $BD, $5F, $80
 db $B7, $2D, $54, $6F, $FB, $0A, $4D, $DE, $E3, $41
 db $CD, $DF, $A5, $39, $BB, $DC, $66, $37, $1C, $4A
 db $6E, $FD, $29, $0D, $91, $9D, $F1, $09, $DB, $03
 db $AE, $07, $4C, $0E, $78, $1C, $B0, $38, $E0, $70
 db $C0, $E0, $01, $DE, $F7, $A2, $33, $EF, $80, $E7
 db $7B, $D1, $1D, $CD, $DE, $03, $3D, $E8, $8E, $37
 db $DF, $01, $CE, $F7, $A2, $3A, $1B, $BC, $07, $03
 db $DE, $88, $EF, $81, $DB, $03, $AE, $07, $4C, $0E
 db $78, $1C, $B0, $38, $E0, $70, $C0, $E0, $01, $E1
 db $CF, $D5, $E9, $B9, $6A, $A3, $7F, $D8, $52, $6E
 db $F7, $1A, $0E, $6E, $FD, $29, $CD, $DE, $E3, $31
 db $B8, $E2, $53, $77, $E9, $48, $6C, $8C, $EF, $7D
 db $F0, $19, $BB, $87, $3B, $EF, $0E, $E6, $78, $19
 db $F7, $87, $1B, $77, $0E, $77, $DE, $1D, $0C, $F0
 db $38, $1F, $78, $77, $F9, $28, $CC, $66, $31, $21
 db $9D, $20, $77, $32, $49, $8C, $EF, $03, $80, $06
 db $00, $78, $64, $5B, $DE, $01, $EC, $1D, $E8, $32
 db $0E, $C7, $BD, $11, $90, $74, $BB, $C9, $8C, $83
 db $80, $07, $87, $3F, $8D, $7A, $BF, $01, $6E, $5A
 db $A8, $DF, $F6, $14, $9B, $BD, $C6, $83, $9B, $BF
 db $4A, $73, $77, $B8, $CC, $6E, $38, $94, $DD, $FA
 db $52, $1B, $23, $3B, $62, $23, $40, $75, $C4, $26
 db $80, $E8, $81, $A0, $3B, $9B, $BC, $06, $67, $81
 db $CC, $DD, $C3, $B5, $8F, $06, $6E, $E1, $C4, $CF
 db $03, $99, $BB, $87, $3B, $1E, $0E, $06, $EE, $1D
 db $F0, $3B, $60, $75, $C0, $E9, $81, $CF, $03, $96
 db $07, $1C, $0E, $18, $1C, $00, $3C, $39, $FC, $6B
 db $D3, $72, $D5, $46, $FF, $B0, $A4, $DD, $EE, $34
 db $1C, $DD, $FA, $53, $9B, $BD, $C6, $63, $71, $C4
 db $A6, $EF, $D2, $90, $D9, $19, $DB, $D0, $E1, $E9
 db $D8, $C8, $83, $B5, $A1, $87, $63, $22, $0C, $D0
 db $C3, $81, $91, $06, $00, $77, $F9, $28, $CC, $66
 db $31, $21, $9D, $20, $77, $32, $49, $8C, $EF, $03
 db $80, $06, $00, $78, $64, $5B, $DE, $01, $EC, $1D
 db $E8, $32, $0E, $C7, $BD, $11, $90, $74, $BB, $C9
 db $8C, $83, $80, $07, $87, $3F, $8D, $7A, $BF, $01
 db $6E, $5A, $A8, $DF, $F6, $14, $9B, $BD, $C6, $83
 db $9B, $BF, $4A, $73, $77, $B8, $CC, $6E, $38, $94
 db $DD, $FA, $52, $1B, $23, $3B, $62, $23, $40, $75
 db $C4, $26, $80, $E8, $81, $A0, $3B, $DE, $F4, $46
 db $7D, $F0, $1C, $EF, $7A, $23, $B9, $BB, $C0, $67
 db $BD, $11, $C6, $FB, $E0, $39, $DE, $F4, $47, $43
 db $77, $80, $E0, $7B, $D1, $1D, $F0, $3B, $60, $75
 db $C0, $E9, $81, $CF, $03, $96, $07, $1C, $0E, $18
 db $1C, $00, $3C, $39, $FA, $BD, $37, $2D, $54, $6F
 db $FB, $0A, $4D, $DE, $E3, $41, $CD, $DF, $A5, $39
 db $BB, $DC, $66, $37, $1C, $4A, $6E, $FD, $29, $0D
 db $91, $9D, $EF, $BE, $03, $37, $70, $E7, $7D, $E1
 db $DC, $CF, $03, $3E, $F0, $E3, $6E, $E1, $CE, $FB
 db $C3, $A1, $9E, $07, $03, $EF, $0E, $FF, $25, $19
 db $8C, $C6, $24, $33, $A4, $0E, $E6, $49, $31, $9D
 db $E0, $70, $00, $C0, $0F, $0C, $8B, $7B, $C0, $3D
 db $83, $BD, $06, $41, $D8, $F7, $A2, $32, $0E, $97
 db $79, $31, $90, $70, $00, $F0, $E7, $F1, $AF, $57
 db $E0, $2D, $CB, $55, $1B, $FE, $C2, $93, $77, $B8
 db $D0, $73, $77, $E9, $4E, $6E, $F7, $19, $8D, $C7
 db $12, $9B, $BF, $4A, $43, $64, $67, $7F, $92, $8C
 db $C6, $63, $12, $19, $D2, $07, $73, $24, $98, $CE
 db $F0, $38, $00, $60, $07, $77, $22, $87, $A7, $6B
 db $11, $0E, $E6, $44, $1D, $AC, $44, $33, $22, $0E
 db $06, $22, $18, $01, $DD, $C7, $83, $B5, $87, $87
 db $73, $1E, $0E, $D6, $1E, $19, $8F, $07, $03, $0F
 db $0C, $00, $F0, $E7, $F1, $AF, $4D, $CB, $55, $1B
 db $FE, $C2, $93, $77, $B8, $D0, $73, $77, $E9, $4E
 db $6E, $F7, $19, $8D, $C7, $12, $9B, $BF, $4A, $43
 db $64, $67, $6C, $44, $68, $0E, $B8, $84, $D0, $1D
 db $10, $34, $07, $7F, $92, $8C, $C6, $63, $12, $19
 db $D2, $07, $73, $24, $98, $CE, $F0, $38, $00, $60
 db $07, $86, $45, $BD, $E0, $1E, $C1, $DE, $83, $20
 db $EC, $7B, $D1, $19, $07, $4B, $BC, $98, $C8, $38
 db $00, $78, $73, $F8, $D7, $AB, $F0, $16, $E5, $AA
 db $8D, $FF, $61, $49, $BB, $DC, $68, $39, $BB, $F4
 db $A7, $37, $7B, $8C, $C6, $E3, $89, $4D, $DF, $A5
 db $21, $B2, $33, $BE, $21, $3B, $60, $75, $C0, $E9
 db $81, $CF, $03, $96, $07, $1C, $0E, $18, $1C, $00
 db $3B, $DE, $F4, $46, $7D, $F0, $1C, $EF, $7A, $23
 db $B9, $BB, $C0, $67, $BD, $11, $C6, $FB, $E0, $39
 db $DE, $F4, $47, $43, $77, $80, $E0, $7B, $D1, $1D
 db $F0, $3B, $60, $75, $C0, $E9, $81, $CF, $03, $96
 db $07, $1C, $0E, $18, $1C, $00, $3C, $39, $FA, $BD
 db $37, $2D, $54, $6F, $FB, $0A, $4D, $DE, $E3, $41
 db $CD, $DF, $A5, $39, $BB, $DC, $66, $37, $1C, $4A
 db $6E, $FD, $29, $0D, $91, $9D, $EF, $BE, $03, $37
 db $70, $E7, $7D, $E1, $DC, $CF, $03, $3E, $F0, $E3
 db $6E, $E1, $CE, $FB, $C3, $A1, $9E, $07, $03, $EF
 db $0E, $FF, $25, $19, $8C, $C6, $24, $33, $A4, $0E
 db $E6, $49, $31, $9D, $E0, $70, $00, $C0, $0F, $0C
 db $8B, $7B, $C0, $3D, $83, $BD, $06, $41, $D8, $F7
 db $A2, $32, $0E, $97, $79, $31, $90, $70, $00, $F0
 db $E7, $F1, $AF, $57, $E0, $2D, $CB, $55, $1B, $FE
 db $C2, $93, $77, $B8, $D0, $73, $77, $E9, $4E, $6E
 db $F7, $19, $8D, $C7, $12, $9B, $BF, $4A, $43, $64
 db $67, $6C, $44, $68, $0E, $B8, $84, $D0, $1D, $10
 db $34, $07, $6F, $3C, $84, $87, $77, $77, $50, $77
 db $F3, $C4, $27, $73, $EF, $0E, $F6, $78, $1D, $8D
 db $DC, $3A, $D9, $E0, $75, $37, $70, $E9, $67, $81
 db $DF, $03, $B6, $07, $5C, $0E, $98, $1C, $F0, $39
 db $60, $71, $C0, $E1, $81, $C0, $03, $C3, $9F, $C6
 db $BD, $37, $2D, $54, $6F, $FB, $0A, $4D, $DE, $E3
 db $41, $CD, $DF, $A5, $39, $BB, $DC, $66, $37, $1C
 db $4A, $6E, $FD, $29, $0D, $91, $9D, $B1, $11, $A0
 db $3A, $E2, $13, $40, $74, $40, $D0, $1D, $FE, $4A
 db $33, $19, $8C, $48, $67, $48, $1D, $CC, $92, $63
 db $3B, $C0, $E0, $01, $80, $1E, $19, $16, $F7, $80
 db $7B, $07, $7A, $0C, $83, $B1, $EF, $44, $64, $1D
 db $2E, $F2, $63, $20, $E0, $01, $E1, $CF, $E3, $5E
 db $AF, $C0, $5B, $96, $AA, $37, $FD, $85, $26, $EF
 db $71, $A0, $E6, $EF, $D2, $9C, $DD, $EE, $33, $1B
 db $8E, $25, $37, $7E, $94, $86, $C8, $CE, $D8, $88
 db $D0, $1D, $71, $09, $A0, $3A, $20, $68, $0E, $F7
 db $BD, $11, $9F, $7C, $07, $3B, $DE, $88, $EE, $6E
 db $F0, $19, $EF, $44, $71, $BE, $F8, $0E, $77, $BD
 db $11, $D0, $DD, $E0, $38, $1E, $F4, $47, $7C, $0E
 db $D8, $1D, $70, $3A, $60, $73, $C0, $E5, $81, $C7
 db $03, $86, $07, $00, $0F, $0E, $7E, $AF, $4D, $CB
 db $55, $1B, $FE, $C2, $93, $77, $B8, $D0, $73, $77
 db $E9, $4E, $6E, $F7, $19, $8D, $C7, $12, $9B, $BF
 db $4A, $43, $64, $67, $7B, $EF, $80, $CD, $DC, $39
 db $DF, $78, $77, $33, $C0, $CF, $BC, $38, $DB, $B8
 db $73, $BE, $F0, $E8, $67, $81, $C0, $FB, $C3, $BF
 db $C9, $46, $63, $31, $89, $0C, $E9, $03, $B9, $92
 db $4C, $67, $78, $1C, $00, $30, $03, $C3, $22, $DE
 db $F0, $0F, $60, $EF, $41, $90, $76, $3D, $E8, $8C
 db $83, $A5, $DE, $4C, $64, $1C, $00, $3C, $39, $FC
 db $6B, $D5, $F8, $0B, $72, $D5, $46, $FF, $B0, $A4
 db $DD, $EE, $34, $1C, $DD, $FA, $53, $9B, $BD, $C6
 db $63, $71, $C4, $A6, $EF, $D2, $90, $D9, $19, $DF
 db $E4, $A3, $31, $98, $C4, $86, $74, $81, $DC, $C9
 db $26, $33, $BC, $0E, $00, $18, $01, $DD, $C8, $A1
 db $E9, $DA, $C4, $43, $B9, $91, $07, $6B, $11, $0C
 db $C8, $83, $81, $88, $86, $00, $77, $71, $E0, $ED
 db $61, $E1, $DC, $C7, $83, $B5, $87, $86, $63, $C1
 db $C0, $C3, $C3, $00, $3C, $39, $FC, $6B, $D3, $72
 db $D5, $46, $FF, $B0, $A4, $DD, $EE, $34, $1C, $DD
 db $FA, $53, $9B, $BD, $C6, $63, $71, $C4, $A6, $EF
 db $D2, $90, $D9, $19, $DB, $11, $1A, $03, $AE, $21
 db $34, $07, $44, $0D, $01, $DF, $E4, $A3, $31, $98
 db $C4, $86, $74, $81, $DC, $C9, $26, $33, $BC, $0E
 db $00, $18, $01, $E1, $91, $6F, $78, $07, $B0, $77
 db $A0, $C8, $3B, $1E, $F4, $46, $41, $D2, $EF, $26
 db $32, $0E, $00, $1E, $1C, $FE, $35, $EA, $FC, $05
 db $B9, $6A, $A3, $7F, $D8, $52, $6E, $F7, $1A, $0E
 db $6E, $FD, $29, $CD, $DE, $E3, $31, $B8, $E2, $53
 db $77, $E9, $48, $6C, $8C, $EF, $88, $4E, $D8, $1D
 db $70, $3A, $60, $73, $C0, $E5, $81, $C7, $03, $86
 db $07, $00, $0E, $F7, $BD, $11, $9F, $7C, $07, $3B
 db $DE, $88, $EE, $6E, $F0, $19, $EF, $44, $71, $BE
 db $F8, $0E, $77, $BD, $11, $D0, $DD, $E0, $38, $1E
 db $F4, $47, $7C, $0E, $D8, $1D, $70, $3A, $60, $73
 db $C0, $E5, $81, $C7, $03, $86, $07, $00, $0F, $0E
 db $7E, $AF, $4D, $CB, $55, $1B, $FE, $C2, $93, $77
 db $B8, $D0, $73, $77, $E9, $4E, $6E, $F7, $19, $8D
 db $C7, $12, $9B, $BF, $4A, $43, $64, $67, $7B, $EF
 db $80, $CD, $DC, $39, $DF, $78, $77, $33, $C0, $CF
 db $BC, $38, $DB, $B8, $73, $BE, $F0, $E8, $67, $81
 db $C0, $FB, $C3, $BF, $C9, $46, $63, $31, $89, $0C
 db $E9, $03, $B9, $92, $4C, $67, $78, $1C, $00, $30
 db $03, $C3, $22, $DE, $F0, $0F, $60, $EF, $41, $90
 db $76, $3D, $E8, $8C, $83, $A5, $DE, $4C, $64, $1C
 db $00, $3C, $39, $FC, $6B, $D5, $F8, $0B, $72, $D5
 db $46, $FF, $B0, $A4, $DD, $EE, $34, $1C, $DD, $FA
 db $53, $9B, $BD, $C6, $63, $71, $C4, $A6, $EF, $D2
 db $90, $D9, $19, $DB, $11, $1A, $03, $AE, $21, $34
 db $07, $44, $0D, $01, $DC, $DD, $E0, $33, $3C, $0E
 db $66, $EE, $1D, $AC, $78, $33, $77, $0E, $26, $78
 db $1C, $CD, $DC, $39, $D8, $F0, $70, $37, $70, $EF
 db $81, $DB, $03, $AE, $07, $4C, $0E, $78, $1C, $B0
 db $38, $E0, $70, $C0, $E0, $01, $E1, $CF, $E3, $5E
 db $9B, $96, $AA, $37, $FD, $85, $26, $EF, $71, $A0
 db $E6, $EF, $D2, $9C, $DD, $EE, $33, $1B, $8E, $25
 db $37, $7E, $94, $86, $C8, $CE, $DE, $87, $0F, $4E
 db $C6, $44, $1D, $AD, $0C, $3B, $19, $10, $66, $86
 db $1C, $0C, $88, $30, $00