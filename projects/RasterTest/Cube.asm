

;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    BSS      
                    ORG      $c880                ; start of our ram space 

delayReset          EQU      5
delayCounter        EQU     cube_ram
animationCounter    EQU      cube_ram + 1

;***************************************************************************
; DATA SECTION
;***************************************************************************

 CODE

vDataLength = 61
AnimList:
 DW AnimList_0 ; list of all single vectorlists in this
 DW AnimList_1
 DW AnimList_2
 DW AnimList_3
 DW AnimList_4
 DW AnimList_5
 DW AnimList_6
 DW AnimList_7
 DW AnimList_8
 DW AnimList_9
 DW AnimList_10
 DW AnimList_11
 DW AnimList_12
 DW AnimList_13
 DW AnimList_14
 DW AnimList_15
 DW AnimList_16
 DW AnimList_17
 DW AnimList_18
 DW AnimList_19
 DW AnimList_20
 DW AnimList_21
 DW AnimList_22
 DW AnimList_23
 DW AnimList_24
 DW AnimList_25
 DW AnimList_26
 DW AnimList_27
 DW AnimList_28
 DW AnimList_29
 DW AnimList_30
 DW AnimList_31
 DW AnimList_32
 DW AnimList_33
 DW AnimList_34
 DW AnimList_35
 DW AnimList_36
 DW AnimList_37
 DW AnimList_38
 DW AnimList_39
 DW AnimList_40
 DW AnimList_41
 DW AnimList_42
 DW AnimList_43
 DW AnimList_44
 DW AnimList_45
 DW AnimList_46
 DW AnimList_47
 DW AnimList_48
 DW AnimList_49
 DW AnimList_50
 DW AnimList_51
 DW AnimList_52
 DW AnimList_53
 DW AnimList_54
 DW AnimList_55
 DW AnimList_56
 DW AnimList_57
 DW AnimList_58
 DW AnimList_59
 DW AnimList_60

AnimList:
 DW AnimList_0 ; list of all single vectorlists in this
 DW AnimList_1
 DW AnimList_2
 DW AnimList_3
 DW AnimList_4
 DW AnimList_5
 DW AnimList_6
 DW AnimList_7
 DW AnimList_8
 DW AnimList_9
 DW AnimList_10
 DW AnimList_11
 DW AnimList_12
 DW AnimList_13
 DW AnimList_14
 DW AnimList_15
 DW AnimList_16
 DW AnimList_17
 DW AnimList_18
 DW AnimList_19
 DW AnimList_20
 DW AnimList_21
 DW AnimList_22
 DW AnimList_23
 DW AnimList_24
 DW AnimList_25
 DW AnimList_26
 DW AnimList_27
 DW AnimList_28
 DW AnimList_29
 DW AnimList_30
 DW AnimList_31
 DW AnimList_32
 DW AnimList_33
 DW AnimList_34
 DW AnimList_35
 DW AnimList_36
 DW AnimList_37
 DW AnimList_38
 DW AnimList_39
 DW AnimList_40
 DW AnimList_41
 DW AnimList_42
 DW AnimList_43
 DW AnimList_44
 DW AnimList_45
 DW AnimList_46
 DW AnimList_47
 DW AnimList_48
 DW AnimList_49
 DW AnimList_50
 DW AnimList_51
 DW AnimList_52
 DW AnimList_53
 DW AnimList_54
 DW AnimList_55
 DW AnimList_56
 DW AnimList_57
 DW AnimList_58
 DW AnimList_59
 DW AnimList_60

AnimList_0:
 DB $00, -$3F, -$40 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$0C, +$0F ; mode, y, x
 DB $02, +$0D, +$7D ; mode, y, x
 DB $02, +$7E, -$0B ; mode, y, x
 DB $02, -$0D, -$7E ; mode, y, x
 DB $02, -$7E, +$0C ; mode, y, x
 DB $02, +$0D, +$7D ; mode, y, x
 DB $00, +$3E, -$4C ; mode, y, x
 DB $00, +$4C, +$32 ; mode, y, x
 DB $02, -$0D, -$7D ; mode, y, x
 DB $02, -$7E, +$0B ; mode, y, x
 DB $00, +$45, +$39 ; mode, y, x
 DB $00, +$46, +$39 ; mode, y, x
 DB $02, -$0C, +$0F ; mode, y, x
 DB $02, -$0D, -$7E ; mode, y, x
 DB $02, +$0C, -$0E ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_1:
 DB $00, -$3F, -$41 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$15, +$1E ; mode, y, x
 DB $02, +$1A, +$7A ; mode, y, x
 DB $02, +$7A, -$15 ; mode, y, x
 DB $02, -$19, -$79 ; mode, y, x
 DB $02, -$7B, +$14 ; mode, y, x
 DB $02, +$1A, +$7A ; mode, y, x
 DB $00, +$3A, -$57 ; mode, y, x
 DB $00, +$55, +$24 ; mode, y, x
 DB $02, -$1A, -$7A ; mode, y, x
 DB $02, -$7A, +$15 ; mode, y, x
 DB $00, +$4A, +$33 ; mode, y, x
 DB $00, +$4A, +$32 ; mode, y, x
 DB $02, -$15, +$1E ; mode, y, x
 DB $02, -$19, -$79 ; mode, y, x
 DB $02, +$14, -$1F ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_2:
 DB $00, -$40, -$44 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$1A, +$2F ; mode, y, x
 DB $02, +$25, +$73 ; mode, y, x
 DB $02, +$77, -$19 ; mode, y, x
 DB $02, -$25, -$73 ; mode, y, x
 DB $02, -$77, +$19 ; mode, y, x
 DB $02, +$25, +$73 ; mode, y, x
 DB $00, +$35, -$5E ; mode, y, x
 DB $00, +$5B, +$16 ; mode, y, x
 DB $02, -$25, -$73 ; mode, y, x
 DB $02, -$76, +$19 ; mode, y, x
 DB $00, +$4D, +$2D ; mode, y, x
 DB $00, +$4E, +$2D ; mode, y, x
 DB $02, -$19, +$2F ; mode, y, x
 DB $02, -$25, -$73 ; mode, y, x
 DB $02, +$19, -$2F ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_3:
 DB $00, -$42, -$46 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$1C, +$3F ; mode, y, x
 DB $02, +$2E, +$6A ; mode, y, x
 DB $02, +$73, -$1C ; mode, y, x
 DB $02, -$2E, -$6A ; mode, y, x
 DB $02, -$73, +$1C ; mode, y, x
 DB $02, +$2E, +$6A ; mode, y, x
 DB $00, +$30, -$63 ; mode, y, x
 DB $00, +$5F, +$08 ; mode, y, x
 DB $02, -$2E, -$6A ; mode, y, x
 DB $02, -$73, +$1C ; mode, y, x
 DB $00, +$50, +$27 ; mode, y, x
 DB $00, +$51, +$27 ; mode, y, x
 DB $02, -$1C, +$3F ; mode, y, x
 DB $02, -$2E, -$6A ; mode, y, x
 DB $02, +$1C, -$3F ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_4:
 DB $00, -$45, -$49 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$1B, +$4E ; mode, y, x
 DB $02, +$36, +$61 ; mode, y, x
 DB $02, +$70, -$1C ; mode, y, x
 DB $02, -$37, -$60 ; mode, y, x
 DB $02, -$6F, +$1B ; mode, y, x
 DB $02, +$36, +$61 ; mode, y, x
 DB $00, +$2A, -$66 ; mode, y, x
 DB $00, +$61, -$04 ; mode, y, x
 DB $02, -$36, -$60 ; mode, y, x
 DB $02, -$70, +$1B ; mode, y, x
 DB $00, +$53, +$23 ; mode, y, x
 DB $00, +$53, +$22 ; mode, y, x
 DB $02, -$1B, +$4E ; mode, y, x
 DB $02, -$37, -$60 ; mode, y, x
 DB $02, +$1C, -$4E ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_5:
 DB $00, -$47, -$4B ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$1A, +$5C ; mode, y, x
 DB $02, +$3C, +$54 ; mode, y, x
 DB $02, +$6D, -$19 ; mode, y, x
 DB $02, -$3B, -$54 ; mode, y, x
 DB $02, -$6E, +$19 ; mode, y, x
 DB $02, +$3C, +$54 ; mode, y, x
 DB $00, +$25, -$65 ; mode, y, x
 DB $00, +$62, -$10 ; mode, y, x
 DB $02, -$3C, -$54 ; mode, y, x
 DB $02, -$6D, +$19 ; mode, y, x
 DB $00, +$54, +$1E ; mode, y, x
 DB $00, +$55, +$1D ; mode, y, x
 DB $02, -$1A, +$5C ; mode, y, x
 DB $02, -$3B, -$54 ; mode, y, x
 DB $02, +$19, -$5C ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_6:
 DB $00, -$4A, -$4C ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$16, +$67 ; mode, y, x
 DB $02, +$3F, +$47 ; mode, y, x
 DB $02, +$6C, -$15 ; mode, y, x
 DB $02, -$3F, -$48 ; mode, y, x
 DB $02, -$6C, +$16 ; mode, y, x
 DB $02, +$3F, +$47 ; mode, y, x
 DB $00, +$21, -$62 ; mode, y, x
 DB $00, +$61, -$1A ; mode, y, x
 DB $02, -$3F, -$47 ; mode, y, x
 DB $02, -$6C, +$15 ; mode, y, x
 DB $00, +$55, +$19 ; mode, y, x
 DB $00, +$56, +$19 ; mode, y, x
 DB $02, -$16, +$67 ; mode, y, x
 DB $02, -$3F, -$48 ; mode, y, x
 DB $02, +$16, -$66 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_7:
 DB $00, -$4D, -$4C ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$11, +$6F ; mode, y, x
 DB $02, +$3F, +$3B ; mode, y, x
 DB $02, +$6D, -$11 ; mode, y, x
 DB $02, -$3F, -$3A ; mode, y, x
 DB $02, -$6D, +$10 ; mode, y, x
 DB $02, +$3F, +$3B ; mode, y, x
 DB $00, +$1F, -$5E ; mode, y, x
 DB $00, +$5F, -$22 ; mode, y, x
 DB $02, -$3F, -$3B ; mode, y, x
 DB $02, -$6D, +$11 ; mode, y, x
 DB $00, +$56, +$15 ; mode, y, x
 DB $00, +$56, +$15 ; mode, y, x
 DB $02, -$11, +$6F ; mode, y, x
 DB $02, -$3F, -$3A ; mode, y, x
 DB $02, +$11, -$70 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_8:
 DB $00, -$4F, -$4B ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$0C, +$76 ; mode, y, x
 DB $02, +$3D, +$2D ; mode, y, x
 DB $02, +$6E, -$0C ; mode, y, x
 DB $02, -$3D, -$2D ; mode, y, x
 DB $02, -$6E, +$0C ; mode, y, x
 DB $02, +$3D, +$2D ; mode, y, x
 DB $00, +$1F, -$58 ; mode, y, x
 DB $00, +$5C, -$2A ; mode, y, x
 DB $02, -$3D, -$2D ; mode, y, x
 DB $02, -$6F, +$0C ; mode, y, x
 DB $00, +$56, +$11 ; mode, y, x
 DB $00, +$56, +$10 ; mode, y, x
 DB $02, -$0D, +$76 ; mode, y, x
 DB $02, -$3D, -$2D ; mode, y, x
 DB $02, +$0D, -$76 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_9:
 DB $00, -$50, -$49 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$08, +$7A ; mode, y, x
 DB $02, +$38, +$22 ; mode, y, x
 DB $02, +$72, -$08 ; mode, y, x
 DB $02, -$39, -$22 ; mode, y, x
 DB $02, -$71, +$08 ; mode, y, x
 DB $02, +$38, +$22 ; mode, y, x
 DB $00, +$21, -$53 ; mode, y, x
 DB $00, +$59, -$30 ; mode, y, x
 DB $02, -$39, -$21 ; mode, y, x
 DB $02, -$71, +$08 ; mode, y, x
 DB $00, +$55, +$0D ; mode, y, x
 DB $00, +$55, +$0C ; mode, y, x
 DB $02, -$08, +$7B ; mode, y, x
 DB $02, -$39, -$22 ; mode, y, x
 DB $02, +$08, -$7A ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_10:
 DB $00, -$50, -$47 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$05, +$7D ; mode, y, x
 DB $02, +$31, +$17 ; mode, y, x
 DB $02, +$75, -$05 ; mode, y, x
 DB $02, -$30, -$17 ; mode, y, x
 DB $02, -$76, +$05 ; mode, y, x
 DB $02, +$31, +$17 ; mode, y, x
 DB $00, +$24, -$4D ; mode, y, x
 DB $00, +$56, -$35 ; mode, y, x
 DB $02, -$31, -$17 ; mode, y, x
 DB $02, -$75, +$05 ; mode, y, x
 DB $00, +$53, +$09 ; mode, y, x
 DB $00, +$53, +$09 ; mode, y, x
 DB $02, -$05, +$7D ; mode, y, x
 DB $02, -$30, -$17 ; mode, y, x
 DB $02, +$04, -$7D ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_11:
 DB $00, -$4E, -$44 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$03, +$7E ; mode, y, x
 DB $02, +$28, +$0E ; mode, y, x
 DB $02, +$79, -$03 ; mode, y, x
 DB $02, -$28, -$0D ; mode, y, x
 DB $02, -$79, +$02 ; mode, y, x
 DB $02, +$28, +$0E ; mode, y, x
 DB $00, +$29, -$48 ; mode, y, x
 DB $00, +$52, -$39 ; mode, y, x
 DB $02, -$28, -$0E ; mode, y, x
 DB $02, -$78, +$03 ; mode, y, x
 DB $00, +$50, +$06 ; mode, y, x
 DB $00, +$50, +$05 ; mode, y, x
 DB $02, -$02, +$7E ; mode, y, x
 DB $02, -$28, -$0D ; mode, y, x
 DB $02, +$02, -$7F ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_12:
 DB $00, -$4B, -$42 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$01, +$7F ; mode, y, x
 DB $02, +$1D, +$07 ; mode, y, x
 DB $02, +$7B, -$01 ; mode, y, x
 DB $02, -$1C, -$07 ; mode, y, x
 DB $02, -$7C, +$01 ; mode, y, x
 DB $02, +$1D, +$07 ; mode, y, x
 DB $00, +$2F, -$44 ; mode, y, x
 DB $00, +$4D, -$3C ; mode, y, x
 DB $02, -$1C, -$07 ; mode, y, x
 DB $02, -$7C, +$01 ; mode, y, x
 DB $00, +$4C, +$03 ; mode, y, x
 DB $00, +$4C, +$03 ; mode, y, x
 DB $02, -$01, +$7F ; mode, y, x
 DB $02, -$1C, -$07 ; mode, y, x
 DB $02, +$01, -$7F ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_13:
 DB $00, -$46, -$40 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$01, +$7F ; mode, y, x
 DB $02, +$11, +$02 ; mode, y, x
 DB $02, +$7E, +$00 ; mode, y, x
 DB $02, -$11, -$02 ; mode, y, x
 DB $02, -$7E, +$00 ; mode, y, x
 DB $02, +$11, +$02 ; mode, y, x
 DB $00, +$36, -$41 ; mode, y, x
 DB $00, +$48, -$3E ; mode, y, x
 DB $02, -$10, -$02 ; mode, y, x
 DB $02, -$7E, +$00 ; mode, y, x
 DB $00, +$47, +$01 ; mode, y, x
 DB $00, +$47, +$01 ; mode, y, x
 DB $02, +$00, +$7F ; mode, y, x
 DB $02, -$11, -$02 ; mode, y, x
 DB $02, +$01, -$7F ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_14:
 DB $00, -$41, -$3F ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, +$04, +$00 ; mode, y, x
 DB $02, +$7F, +$00 ; mode, y, x
 DB $02, -$04, +$00 ; mode, y, x
 DB $02, -$7F, +$00 ; mode, y, x
 DB $02, +$00, +$7F ; mode, y, x
 DB $00, +$41, +$00 ; mode, y, x
 DB $00, +$42, +$00 ; mode, y, x
 DB $02, -$04, +$00 ; mode, y, x
 DB $02, -$7F, +$00 ; mode, y, x
 DB $00, +$04, -$7F ; mode, y, x
 DB $02, +$7F, +$00 ; mode, y, x
 DB $02, +$00, +$7F ; mode, y, x
 DB $02, -$04, +$00 ; mode, y, x
 DB $02, +$00, -$7F ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_15:
 DB $00, -$3A, -$3F ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $00, -$0A, +$00 ; mode, y, x
 DB $02, +$7F, +$00 ; mode, y, x
 DB $02, +$0A, +$00 ; mode, y, x
 DB $00, -$45, +$3F ; mode, y, x
 DB $00, -$44, +$40 ; mode, y, x
 DB $02, +$7F, +$00 ; mode, y, x
 DB $02, +$0A, +$00 ; mode, y, x
 DB $02, -$7F, +$00 ; mode, y, x
 DB $02, -$0A, +$00 ; mode, y, x
 DB $02, +$00, -$7F ; mode, y, x
 DB $02, +$7F, +$00 ; mode, y, x
 DB $02, +$00, +$7F ; mode, y, x
 DB $02, +$0A, +$00 ; mode, y, x
 DB $02, +$00, -$7F ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_16:
 DB $00, -$33, -$41 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$16, +$04 ; mode, y, x
 DB $02, +$7D, +$00 ; mode, y, x
 DB $02, +$16, -$04 ; mode, y, x
 DB $02, -$7D, +$00 ; mode, y, x
 DB $00, +$33, +$41 ; mode, y, x
 DB $00, -$49, +$42 ; mode, y, x
 DB $02, +$7D, +$00 ; mode, y, x
 DB $02, +$16, -$04 ; mode, y, x
 DB $02, +$00, -$7F ; mode, y, x
 DB $00, -$25, +$41 ; mode, y, x
 DB $00, -$25, +$40 ; mode, y, x
 DB $00, -$49, +$02 ; mode, y, x
 DB $02, +$00, -$7F ; mode, y, x
 DB $02, +$7D, +$00 ; mode, y, x
 DB $02, +$00, +$7F ; mode, y, x
 DB $02, +$16, -$04 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_17:
 DB $00, -$2C, -$44 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$23, +$0A ; mode, y, x
 DB $02, +$7B, +$01 ; mode, y, x
 DB $02, +$22, -$0A ; mode, y, x
 DB $02, -$7A, -$01 ; mode, y, x
 DB $00, +$2C, +$44 ; mode, y, x
 DB $00, -$4D, +$44 ; mode, y, x
 DB $02, +$7A, +$01 ; mode, y, x
 DB $02, +$22, -$09 ; mode, y, x
 DB $02, -$01, -$7F ; mode, y, x
 DB $00, -$27, +$42 ; mode, y, x
 DB $00, -$26, +$41 ; mode, y, x
 DB $00, -$4E, +$04 ; mode, y, x
 DB $02, -$02, -$7E ; mode, y, x
 DB $02, +$7B, +$01 ; mode, y, x
 DB $02, +$01, +$7E ; mode, y, x
 DB $02, +$22, -$09 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_18:
 DB $00, -$27, -$49 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$2C, +$12 ; mode, y, x
 DB $02, +$77, +$03 ; mode, y, x
 DB $02, +$2C, -$12 ; mode, y, x
 DB $02, -$77, -$03 ; mode, y, x
 DB $00, +$27, +$49 ; mode, y, x
 DB $00, -$50, +$47 ; mode, y, x
 DB $02, +$77, +$03 ; mode, y, x
 DB $02, +$2D, -$12 ; mode, y, x
 DB $02, -$04, -$7E ; mode, y, x
 DB $00, -$27, +$43 ; mode, y, x
 DB $00, -$27, +$42 ; mode, y, x
 DB $00, -$52, +$08 ; mode, y, x
 DB $02, -$03, -$7E ; mode, y, x
 DB $02, +$77, +$03 ; mode, y, x
 DB $02, +$03, +$7E ; mode, y, x
 DB $02, +$2D, -$12 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_19:
 DB $00, -$22, -$4E ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$35, +$1C ; mode, y, x
 DB $02, +$74, +$06 ; mode, y, x
 DB $02, +$34, -$1C ; mode, y, x
 DB $02, -$73, -$06 ; mode, y, x
 DB $00, +$22, +$4E ; mode, y, x
 DB $00, -$51, +$49 ; mode, y, x
 DB $02, +$74, +$07 ; mode, y, x
 DB $02, +$34, -$1C ; mode, y, x
 DB $02, -$06, -$7C ; mode, y, x
 DB $00, -$27, +$43 ; mode, y, x
 DB $00, -$27, +$43 ; mode, y, x
 DB $00, -$54, +$0B ; mode, y, x
 DB $02, -$06, -$7B ; mode, y, x
 DB $02, +$74, +$06 ; mode, y, x
 DB $02, +$06, +$7C ; mode, y, x
 DB $02, +$34, -$1C ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_20:
 DB $00, -$1F, -$54 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$3B, +$27 ; mode, y, x
 DB $02, +$70, +$0A ; mode, y, x
 DB $02, +$3B, -$27 ; mode, y, x
 DB $02, -$70, -$0A ; mode, y, x
 DB $00, +$1F, +$55 ; mode, y, x
 DB $00, -$50, +$4B ; mode, y, x
 DB $02, +$70, +$0A ; mode, y, x
 DB $02, +$3B, -$28 ; mode, y, x
 DB $02, -$0A, -$78 ; mode, y, x
 DB $00, -$26, +$44 ; mode, y, x
 DB $00, -$26, +$43 ; mode, y, x
 DB $00, -$55, +$0F ; mode, y, x
 DB $02, -$0A, -$79 ; mode, y, x
 DB $02, +$70, +$0A ; mode, y, x
 DB $02, +$0A, +$79 ; mode, y, x
 DB $02, +$3B, -$28 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_21:
 DB $00, -$1F, -$5A ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$3E, +$34 ; mode, y, x
 DB $02, +$6E, +$0F ; mode, y, x
 DB $02, +$3E, -$35 ; mode, y, x
 DB $02, -$6E, -$0E ; mode, y, x
 DB $00, +$1F, +$5A ; mode, y, x
 DB $00, -$4F, +$4D ; mode, y, x
 DB $02, +$6E, +$0E ; mode, y, x
 DB $02, +$3F, -$34 ; mode, y, x
 DB $02, -$0F, -$73 ; mode, y, x
 DB $00, -$24, +$43 ; mode, y, x
 DB $00, -$24, +$43 ; mode, y, x
 DB $00, -$56, +$13 ; mode, y, x
 DB $02, -$0E, -$73 ; mode, y, x
 DB $02, +$6E, +$0F ; mode, y, x
 DB $02, +$0E, +$72 ; mode, y, x
 DB $02, +$3F, -$34 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_22:
 DB $00, -$20, -$5F ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$3F, +$41 ; mode, y, x
 DB $02, +$6C, +$13 ; mode, y, x
 DB $02, +$40, -$41 ; mode, y, x
 DB $02, -$6D, -$13 ; mode, y, x
 DB $00, +$20, +$5F ; mode, y, x
 DB $00, -$4C, +$4D ; mode, y, x
 DB $02, +$6C, +$14 ; mode, y, x
 DB $02, +$40, -$42 ; mode, y, x
 DB $02, -$13, -$6B ; mode, y, x
 DB $00, -$22, +$41 ; mode, y, x
 DB $00, -$21, +$41 ; mode, y, x
 DB $00, -$56, +$17 ; mode, y, x
 DB $02, -$13, -$6B ; mode, y, x
 DB $02, +$6C, +$13 ; mode, y, x
 DB $02, +$13, +$6C ; mode, y, x
 DB $02, +$40, -$42 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_23:
 DB $00, -$23, -$63 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$3E, +$4E ; mode, y, x
 DB $02, +$6D, +$18 ; mode, y, x
 DB $02, +$3E, -$4E ; mode, y, x
 DB $02, -$6D, -$18 ; mode, y, x
 DB $00, +$23, +$64 ; mode, y, x
 DB $00, -$49, +$4C ; mode, y, x
 DB $02, +$6C, +$17 ; mode, y, x
 DB $02, +$3E, -$4E ; mode, y, x
 DB $02, -$17, -$61 ; mode, y, x
 DB $00, -$3E, +$7C ; mode, y, x
 DB $00, -$55, +$1C ; mode, y, x
 DB $02, -$18, -$62 ; mode, y, x
 DB $02, +$6D, +$18 ; mode, y, x
 DB $02, +$17, +$61 ; mode, y, x
 DB $02, +$3E, -$4E ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_24:
 DB $00, -$27, -$64 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$3A, +$5A ; mode, y, x
 DB $02, +$6E, +$1B ; mode, y, x
 DB $02, +$3A, -$5B ; mode, y, x
 DB $02, -$6E, -$1A ; mode, y, x
 DB $00, +$27, +$64 ; mode, y, x
 DB $00, -$46, +$4B ; mode, y, x
 DB $02, +$6E, +$1B ; mode, y, x
 DB $02, +$39, -$5B ; mode, y, x
 DB $02, -$1A, -$55 ; mode, y, x
 DB $00, -$3A, +$75 ; mode, y, x
 DB $00, -$53, +$20 ; mode, y, x
 DB $02, -$1B, -$55 ; mode, y, x
 DB $02, +$6E, +$1B ; mode, y, x
 DB $02, +$1B, +$55 ; mode, y, x
 DB $02, +$39, -$5B ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_25:
 DB $00, -$2D, -$63 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$33, +$65 ; mode, y, x
 DB $02, +$71, +$1C ; mode, y, x
 DB $02, +$33, -$65 ; mode, y, x
 DB $02, -$71, -$1C ; mode, y, x
 DB $00, +$2D, +$64 ; mode, y, x
 DB $00, -$43, +$48 ; mode, y, x
 DB $02, +$70, +$1C ; mode, y, x
 DB $02, +$33, -$66 ; mode, y, x
 DB $02, -$1C, -$46 ; mode, y, x
 DB $00, -$36, +$6B ; mode, y, x
 DB $00, -$51, +$25 ; mode, y, x
 DB $02, -$1D, -$47 ; mode, y, x
 DB $02, +$71, +$1C ; mode, y, x
 DB $02, +$1C, +$47 ; mode, y, x
 DB $02, +$33, -$66 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_26:
 DB $00, -$33, -$60 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$2A, +$6F ; mode, y, x
 DB $02, +$75, +$1B ; mode, y, x
 DB $02, +$2A, -$6F ; mode, y, x
 DB $02, -$75, -$1B ; mode, y, x
 DB $00, +$33, +$60 ; mode, y, x
 DB $00, -$41, +$46 ; mode, y, x
 DB $02, +$74, +$1B ; mode, y, x
 DB $02, +$2A, -$6F ; mode, y, x
 DB $02, -$1B, -$37 ; mode, y, x
 DB $00, -$34, +$61 ; mode, y, x
 DB $00, -$4F, +$2A ; mode, y, x
 DB $02, -$1C, -$37 ; mode, y, x
 DB $02, +$75, +$1B ; mode, y, x
 DB $02, +$1B, +$37 ; mode, y, x
 DB $02, +$2A, -$6F ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_27:
 DB $00, -$38, -$5A ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$1F, +$77 ; mode, y, x
 DB $02, +$79, +$18 ; mode, y, x
 DB $02, +$1F, -$77 ; mode, y, x
 DB $02, -$79, -$18 ; mode, y, x
 DB $00, +$38, +$5B ; mode, y, x
 DB $00, -$40, +$43 ; mode, y, x
 DB $02, +$79, +$17 ; mode, y, x
 DB $02, +$1F, -$77 ; mode, y, x
 DB $02, -$17, -$26 ; mode, y, x
 DB $00, -$35, +$56 ; mode, y, x
 DB $00, -$4C, +$30 ; mode, y, x
 DB $02, -$17, -$27 ; mode, y, x
 DB $02, +$79, +$18 ; mode, y, x
 DB $02, +$17, +$26 ; mode, y, x
 DB $02, +$1F, -$77 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_28:
 DB $00, -$3C, -$51 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$14, +$7C ; mode, y, x
 DB $02, +$7D, +$11 ; mode, y, x
 DB $02, +$13, -$7C ; mode, y, x
 DB $02, -$7C, -$11 ; mode, y, x
 DB $00, +$3C, +$52 ; mode, y, x
 DB $00, -$3F, +$41 ; mode, y, x
 DB $02, +$7C, +$10 ; mode, y, x
 DB $02, +$14, -$7C ; mode, y, x
 DB $02, -$11, -$16 ; mode, y, x
 DB $00, -$37, +$4C ; mode, y, x
 DB $00, -$48, +$36 ; mode, y, x
 DB $02, -$11, -$17 ; mode, y, x
 DB $02, +$7D, +$11 ; mode, y, x
 DB $02, +$10, +$16 ; mode, y, x
 DB $02, +$14, -$7C ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_29:
 DB $00, -$3F, -$45 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$06, +$7E ; mode, y, x
 DB $02, +$7E, +$07 ; mode, y, x
 DB $02, +$07, -$7F ; mode, y, x
 DB $02, -$7F, -$06 ; mode, y, x
 DB $00, +$00, +$43 ; mode, y, x
 DB $00, +$00, +$42 ; mode, y, x
 DB $02, +$7F, +$06 ; mode, y, x
 DB $02, +$06, -$7E ; mode, y, x
 DB $02, -$06, -$07 ; mode, y, x
 DB $00, -$3D, +$43 ; mode, y, x
 DB $00, -$42, +$3C ; mode, y, x
 DB $02, -$06, -$07 ; mode, y, x
 DB $02, +$7E, +$07 ; mode, y, x
 DB $02, +$07, +$06 ; mode, y, x
 DB $02, +$06, -$7E ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_30:
 DB $00, -$38, +$47 ; move to y, x
 DB $02, +$7F, -$08 ; mode, y, x
 DB $02, -$07, -$7E ; mode, y, x
 DB $00, -$43, +$00 ; mode, y, x
 DB $00, -$43, +$00 ; mode, y, x
 DB $02, +$07, +$7F ; mode, y, x
 DB $02, +$7F, -$07 ; mode, y, x
 DB $02, -$07, -$7E ; mode, y, x
 DB $02, -$7F, +$06 ; mode, y, x
 DB $02, +$07, +$7F ; mode, y, x
 DB $02, +$07, +$06 ; mode, y, x
 DB $02, +$7F, -$07 ; mode, y, x
 DB $02, -$07, -$06 ; mode, y, x
 DB $02, -$07, -$7E ; mode, y, x
 DB $02, +$07, +$06 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_31:
 DB $00, -$28, +$52 ; move to y, x
 DB $02, +$7B, -$17 ; mode, y, x
 DB $02, -$13, -$7C ; mode, y, x
 DB $00, -$49, +$03 ; mode, y, x
 DB $00, -$49, +$03 ; mode, y, x
 DB $02, +$13, +$7C ; mode, y, x
 DB $02, +$7C, -$16 ; mode, y, x
 DB $02, -$14, -$7C ; mode, y, x
 DB $02, -$7B, +$16 ; mode, y, x
 DB $02, +$13, +$7C ; mode, y, x
 DB $02, +$17, +$11 ; mode, y, x
 DB $02, +$7B, -$17 ; mode, y, x
 DB $02, -$16, -$10 ; mode, y, x
 DB $02, -$14, -$7C ; mode, y, x
 DB $02, +$17, +$10 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_32:
 DB $00, -$17, +$5A ; move to y, x
 DB $02, +$75, -$27 ; mode, y, x
 DB $02, -$1F, -$77 ; mode, y, x
 DB $00, -$4E, +$09 ; mode, y, x
 DB $00, -$4E, +$08 ; mode, y, x
 DB $02, +$1F, +$77 ; mode, y, x
 DB $02, +$75, -$27 ; mode, y, x
 DB $02, -$1F, -$77 ; mode, y, x
 DB $02, -$75, +$27 ; mode, y, x
 DB $02, +$1F, +$77 ; mode, y, x
 DB $02, +$27, +$16 ; mode, y, x
 DB $02, +$75, -$27 ; mode, y, x
 DB $02, -$27, -$16 ; mode, y, x
 DB $02, -$1F, -$77 ; mode, y, x
 DB $02, +$27, +$16 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_33:
 DB $00, -$03, +$60 ; move to y, x
 DB $02, +$69, -$39 ; mode, y, x
 DB $02, -$29, -$6F ; mode, y, x
 DB $00, -$51, +$11 ; mode, y, x
 DB $00, -$52, +$10 ; mode, y, x
 DB $02, +$2A, +$6F ; mode, y, x
 DB $02, +$6A, -$38 ; mode, y, x
 DB $02, -$2A, -$70 ; mode, y, x
 DB $02, -$6A, +$39 ; mode, y, x
 DB $02, +$2A, +$6F ; mode, y, x
 DB $02, +$39, +$18 ; mode, y, x
 DB $02, +$69, -$39 ; mode, y, x
 DB $02, -$38, -$17 ; mode, y, x
 DB $02, -$2A, -$70 ; mode, y, x
 DB $02, +$39, +$18 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_34:
 DB $00, +$11, +$62 ; move to y, x
 DB $02, +$5B, -$4A ; mode, y, x
 DB $02, -$33, -$66 ; mode, y, x
 DB $00, -$52, +$1B ; mode, y, x
 DB $00, -$52, +$1B ; mode, y, x
 DB $02, +$33, +$66 ; mode, y, x
 DB $02, +$5A, -$4A ; mode, y, x
 DB $02, -$33, -$66 ; mode, y, x
 DB $02, -$5A, +$4A ; mode, y, x
 DB $02, +$33, +$66 ; mode, y, x
 DB $02, +$49, +$14 ; mode, y, x
 DB $02, +$5B, -$4A ; mode, y, x
 DB $02, -$4A, -$14 ; mode, y, x
 DB $02, -$33, -$66 ; mode, y, x
 DB $02, +$4A, +$14 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_35:
 DB $00, +$26, +$5F ; move to y, x
 DB $02, +$46, -$58 ; mode, y, x
 DB $02, -$39, -$5A ; mode, y, x
 DB $00, -$4F, +$26 ; mode, y, x
 DB $00, -$50, +$26 ; mode, y, x
 DB $02, +$39, +$5A ; mode, y, x
 DB $02, +$47, -$58 ; mode, y, x
 DB $02, -$39, -$5A ; mode, y, x
 DB $02, -$47, +$58 ; mode, y, x
 DB $02, +$39, +$5A ; mode, y, x
 DB $02, +$59, +$0C ; mode, y, x
 DB $02, +$46, -$58 ; mode, y, x
 DB $02, -$58, -$0C ; mode, y, x
 DB $02, -$39, -$5A ; mode, y, x
 DB $02, +$58, +$0C ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_36:
 DB $00, +$05, -$0B ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$3E, -$4E ; mode, y, x
 DB $02, -$30, +$64 ; mode, y, x
 DB $02, +$3E, +$4E ; mode, y, x
 DB $02, +$30, -$64 ; mode, y, x
 DB $02, +$64, +$00 ; mode, y, x
 DB $02, -$3E, -$4E ; mode, y, x
 DB $02, -$64, +$00 ; mode, y, x
 DB $02, -$30, +$64 ; mode, y, x
 DB $00, +$69, -$0B ; mode, y, x
 DB $00, +$39, +$59 ; mode, y, x
 DB $02, +$30, -$64 ; mode, y, x
 DB $02, -$3E, -$4E ; mode, y, x
 DB $00, +$07, +$59 ; mode, y, x
 DB $00, +$07, +$59 ; mode, y, x
 DB $02, -$64, +$00 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_37:
 DB $00, -$0B, -$0D ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$40, -$41 ; mode, y, x
 DB $02, -$16, +$6C ; mode, y, x
 DB $02, +$40, +$41 ; mode, y, x
 DB $02, +$16, -$6C ; mode, y, x
 DB $02, +$6C, -$10 ; mode, y, x
 DB $02, -$40, -$42 ; mode, y, x
 DB $02, -$6C, +$11 ; mode, y, x
 DB $02, -$16, +$6C ; mode, y, x
 DB $00, +$61, -$1E ; mode, y, x
 DB $00, +$4B, +$4E ; mode, y, x
 DB $02, +$16, -$6B ; mode, y, x
 DB $02, -$40, -$42 ; mode, y, x
 DB $00, +$15, +$57 ; mode, y, x
 DB $00, +$15, +$56 ; mode, y, x
 DB $02, -$6C, +$11 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_38:
 DB $00, -$1A, -$0C ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$3F, -$34 ; mode, y, x
 DB $02, +$05, +$6F ; mode, y, x
 DB $02, +$3F, +$34 ; mode, y, x
 DB $02, -$05, -$6F ; mode, y, x
 DB $02, +$6E, -$23 ; mode, y, x
 DB $02, -$3E, -$34 ; mode, y, x
 DB $02, -$6F, +$23 ; mode, y, x
 DB $02, +$05, +$6F ; mode, y, x
 DB $00, +$54, -$2F ; mode, y, x
 DB $00, +$59, +$40 ; mode, y, x
 DB $02, -$05, -$6F ; mode, y, x
 DB $02, -$3E, -$34 ; mode, y, x
 DB $00, +$21, +$52 ; mode, y, x
 DB $00, +$22, +$51 ; mode, y, x
 DB $02, -$6E, +$23 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_39:
 DB $00, -$29, -$07 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$3A, -$27 ; mode, y, x
 DB $02, +$21, +$6B ; mode, y, x
 DB $02, +$3A, +$28 ; mode, y, x
 DB $02, -$21, -$6C ; mode, y, x
 DB $02, +$6C, -$36 ; mode, y, x
 DB $02, -$3B, -$28 ; mode, y, x
 DB $02, -$6B, +$37 ; mode, y, x
 DB $02, +$21, +$6B ; mode, y, x
 DB $00, +$42, -$3D ; mode, y, x
 DB $00, +$64, +$2E ; mode, y, x
 DB $02, -$21, -$6B ; mode, y, x
 DB $02, -$3B, -$28 ; mode, y, x
 DB $00, +$2E, +$4A ; mode, y, x
 DB $00, +$2E, +$49 ; mode, y, x
 DB $02, -$6C, +$37 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_40:
 DB $00, -$34, +$02 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$35, -$1D ; mode, y, x
 DB $02, +$3B, +$64 ; mode, y, x
 DB $02, +$35, +$1C ; mode, y, x
 DB $02, -$3B, -$63 ; mode, y, x
 DB $02, +$63, -$4B ; mode, y, x
 DB $02, -$35, -$1C ; mode, y, x
 DB $02, -$63, +$4A ; mode, y, x
 DB $02, +$3B, +$64 ; mode, y, x
 DB $00, +$2E, -$49 ; mode, y, x
 DB $00, +$6A, +$1B ; mode, y, x
 DB $02, -$3B, -$64 ; mode, y, x
 DB $02, -$35, -$1C ; mode, y, x
 DB $00, +$38, +$40 ; mode, y, x
 DB $00, +$38, +$40 ; mode, y, x
 DB $02, -$63, +$4A ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_41:
 DB $00, -$3E, +$0C ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, -$2C, -$12 ; mode, y, x
 DB $02, +$53, +$56 ; mode, y, x
 DB $02, +$2C, +$12 ; mode, y, x
 DB $02, -$53, -$56 ; mode, y, x
 DB $02, +$56, -$5C ; mode, y, x
 DB $02, -$2C, -$12 ; mode, y, x
 DB $02, -$56, +$5C ; mode, y, x
 DB $02, +$53, +$56 ; mode, y, x
 DB $00, +$17, -$50 ; mode, y, x
 DB $00, +$6B, +$05 ; mode, y, x
 DB $02, -$53, -$55 ; mode, y, x
 DB $02, -$2C, -$12 ; mode, y, x
 DB $00, +$7F, +$67 ; mode, y, x
 DB $02, -$56, +$5D ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_42:
 DB $00, +$65, -$0F ; move to y, x
 DB $02, -$66, -$43 ; mode, y, x
 DB $02, -$22, -$0A ; mode, y, x
 DB $00, +$12, +$57 ; mode, y, x
 DB $00, +$11, +$57 ; mode, y, x
 DB $02, +$22, +$0A ; mode, y, x
 DB $02, -$66, -$42 ; mode, y, x
 DB $02, -$22, -$0A ; mode, y, x
 DB $02, +$66, +$42 ; mode, y, x
 DB $02, +$22, +$0A ; mode, y, x
 DB $02, +$43, -$6B ; mode, y, x
 DB $02, -$66, -$43 ; mode, y, x
 DB $02, -$43, +$6C ; mode, y, x
 DB $02, -$22, -$0A ; mode, y, x
 DB $02, +$43, -$6C ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_43:
 DB $00, +$5B, -$23 ; move to y, x
 DB $02, -$75, -$2C ; mode, y, x
 DB $02, -$16, -$04 ; mode, y, x
 DB $00, +$24, +$52 ; mode, y, x
 DB $00, +$24, +$51 ; mode, y, x
 DB $02, +$17, +$04 ; mode, y, x
 DB $02, -$75, -$2C ; mode, y, x
 DB $02, -$16, -$04 ; mode, y, x
 DB $02, +$74, +$2C ; mode, y, x
 DB $02, +$17, +$04 ; mode, y, x
 DB $02, +$2C, -$77 ; mode, y, x
 DB $02, -$75, -$2C ; mode, y, x
 DB $02, -$2C, +$77 ; mode, y, x
 DB $02, -$16, -$04 ; mode, y, x
 DB $02, +$2C, -$77 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_44:
 DB $00, +$43, -$35 ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $02, +$0A, +$01 ; mode, y, x
 DB $02, -$7D, -$14 ; mode, y, x
 DB $02, -$0A, +$00 ; mode, y, x
 DB $02, +$7D, +$13 ; mode, y, x
 DB $02, -$14, +$7E ; mode, y, x
 DB $02, +$0A, +$00 ; mode, y, x
 DB $02, +$14, -$7D ; mode, y, x
 DB $02, -$7D, -$14 ; mode, y, x
 DB $00, +$30, +$48 ; mode, y, x
 DB $00, -$4E, +$35 ; mode, y, x
 DB $02, +$7D, +$14 ; mode, y, x
 DB $02, +$0A, +$00 ; mode, y, x
 DB $00, -$43, -$0A ; mode, y, x
 DB $00, -$44, -$0A ; mode, y, x
 DB $02, +$14, -$7D ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_45:
 DB $00, +$3D, -$42 ; move to y, x
 DB $02, -$03, +$00 ; mode, y, x
 DB $02, -$7F, +$06 ; mode, y, x
 DB $02, +$07, +$7F ; mode, y, x
 DB $02, +$03, +$00 ; mode, y, x
 DB $02, +$7F, -$06 ; mode, y, x
 DB $02, -$03, +$00 ; mode, y, x
 DB $02, -$07, -$7F ; mode, y, x
 DB $02, -$7F, +$06 ; mode, y, x
 DB $00, +$41, -$03 ; mode, y, x
 DB $00, +$41, -$03 ; mode, y, x
 DB $02, +$07, +$7F ; mode, y, x
 DB $02, -$03, +$00 ; mode, y, x
 DB $02, -$7F, +$06 ; mode, y, x
 DB $02, +$03, +$00 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_46:
 DB $00, +$34, -$4E ; move to y, x
 DB $02, -$10, +$02 ; mode, y, x
 DB $02, -$79, +$20 ; mode, y, x
 DB $02, +$20, +$7B ; mode, y, x
 DB $02, +$10, -$02 ; mode, y, x
 DB $02, +$7A, -$20 ; mode, y, x
 DB $02, -$11, +$02 ; mode, y, x
 DB $02, -$20, -$7B ; mode, y, x
 DB $02, -$79, +$20 ; mode, y, x
 DB $00, +$45, -$11 ; mode, y, x
 DB $00, +$44, -$11 ; mode, y, x
 DB $02, +$21, +$7B ; mode, y, x
 DB $02, -$11, +$02 ; mode, y, x
 DB $02, -$79, +$20 ; mode, y, x
 DB $02, +$10, -$02 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_47:
 DB $00, +$29, -$58 ; move to y, x
 DB $02, -$1C, +$07 ; mode, y, x
 DB $02, -$6F, +$38 ; mode, y, x
 DB $02, +$38, +$72 ; mode, y, x
 DB $02, +$1D, -$07 ; mode, y, x
 DB $02, +$6E, -$38 ; mode, y, x
 DB $02, -$1C, +$07 ; mode, y, x
 DB $02, -$38, -$72 ; mode, y, x
 DB $02, -$6F, +$38 ; mode, y, x
 DB $00, +$46, -$1F ; mode, y, x
 DB $00, +$45, -$20 ; mode, y, x
 DB $02, +$38, +$72 ; mode, y, x
 DB $02, -$1C, +$07 ; mode, y, x
 DB $02, -$6F, +$38 ; mode, y, x
 DB $02, +$1D, -$07 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_48:
 DB $00, +$1C, -$5F ; move to y, x
 DB $02, -$28, +$0E ; mode, y, x
 DB $02, -$5D, +$4D ; mode, y, x
 DB $02, +$4D, +$64 ; mode, y, x
 DB $02, +$27, -$0E ; mode, y, x
 DB $02, +$5D, -$4C ; mode, y, x
 DB $02, -$27, +$0D ; mode, y, x
 DB $02, -$4D, -$64 ; mode, y, x
 DB $02, -$5D, +$4D ; mode, y, x
 DB $00, +$43, -$2D ; mode, y, x
 DB $00, +$42, -$2E ; mode, y, x
 DB $02, +$4C, +$65 ; mode, y, x
 DB $02, -$27, +$0D ; mode, y, x
 DB $02, -$5D, +$4D ; mode, y, x
 DB $02, +$27, -$0E ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_49:
 DB $00, +$0E, -$63 ; move to y, x
 DB $02, -$31, +$17 ; mode, y, x
 DB $02, -$48, +$5D ; mode, y, x
 DB $02, +$5D, +$53 ; mode, y, x
 DB $02, +$31, -$16 ; mode, y, x
 DB $02, +$47, -$5D ; mode, y, x
 DB $02, -$30, +$16 ; mode, y, x
 DB $02, -$5D, -$53 ; mode, y, x
 DB $02, -$48, +$5D ; mode, y, x
 DB $00, +$79, -$74 ; mode, y, x
 DB $02, +$5C, +$54 ; mode, y, x
 DB $02, -$30, +$16 ; mode, y, x
 DB $02, -$48, +$5D ; mode, y, x
 DB $02, +$31, -$16 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_50:
 DB $00, -$01, -$64 ; move to y, x
 DB $02, -$38, +$21 ; mode, y, x
 DB $02, -$2E, +$68 ; mode, y, x
 DB $02, +$68, +$41 ; mode, y, x
 DB $02, +$38, -$22 ; mode, y, x
 DB $02, +$2E, -$68 ; mode, y, x
 DB $02, -$38, +$22 ; mode, y, x
 DB $02, -$68, -$41 ; mode, y, x
 DB $02, -$2E, +$68 ; mode, y, x
 DB $00, +$33, -$44 ; mode, y, x
 DB $00, +$33, -$45 ; mode, y, x
 DB $02, +$68, +$40 ; mode, y, x
 DB $02, -$38, +$22 ; mode, y, x
 DB $02, -$2E, +$68 ; mode, y, x
 DB $02, +$38, -$22 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_51:
 DB $00, -$0F, -$63 ; move to y, x
 DB $02, -$3D, +$2D ; mode, y, x
 DB $02, -$13, +$6E ; mode, y, x
 DB $02, +$6E, +$2D ; mode, y, x
 DB $02, +$3D, -$2E ; mode, y, x
 DB $02, +$13, -$6E ; mode, y, x
 DB $02, -$3D, +$2E ; mode, y, x
 DB $02, -$6E, -$2D ; mode, y, x
 DB $02, -$13, +$6E ; mode, y, x
 DB $00, +$28, -$4D ; mode, y, x
 DB $00, +$28, -$4E ; mode, y, x
 DB $02, +$6E, +$2C ; mode, y, x
 DB $02, -$3D, +$2E ; mode, y, x
 DB $02, -$13, +$6E ; mode, y, x
 DB $02, +$3D, -$2E ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_52:
 DB $00, -$1B, -$60 ; move to y, x
 DB $02, -$40, +$3A ; mode, y, x
 DB $02, +$09, +$6E ; mode, y, x
 DB $02, +$6E, +$1A ; mode, y, x
 DB $02, +$3F, -$3B ; mode, y, x
 DB $02, -$08, -$6E ; mode, y, x
 DB $02, -$40, +$3B ; mode, y, x
 DB $02, -$6E, -$1A ; mode, y, x
 DB $02, +$09, +$6E ; mode, y, x
 DB $00, +$1C, -$54 ; mode, y, x
 DB $00, +$1B, -$54 ; mode, y, x
 DB $02, +$6E, +$19 ; mode, y, x
 DB $02, -$40, +$3B ; mode, y, x
 DB $02, +$09, +$6E ; mode, y, x
 DB $02, +$3F, -$3B ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_53:
 DB $00, -$26, -$5B ; move to y, x
 DB $02, -$3F, +$47 ; mode, y, x
 DB $02, +$23, +$69 ; mode, y, x
 DB $02, +$69, +$08 ; mode, y, x
 DB $02, +$3F, -$48 ; mode, y, x
 DB $02, -$23, -$68 ; mode, y, x
 DB $02, -$3F, +$47 ; mode, y, x
 DB $02, -$69, -$08 ; mode, y, x
 DB $02, +$23, +$69 ; mode, y, x
 DB $00, +$0E, -$58 ; mode, y, x
 DB $00, +$0E, -$58 ; mode, y, x
 DB $02, +$69, +$08 ; mode, y, x
 DB $02, -$3F, +$47 ; mode, y, x
 DB $02, +$23, +$69 ; mode, y, x
 DB $02, +$3F, -$48 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_54:
 DB $00, -$2F, -$56 ; move to y, x
 DB $02, -$3C, +$55 ; mode, y, x
 DB $02, +$3C, +$5E ; mode, y, x
 DB $02, +$5F, -$06 ; mode, y, x
 DB $02, +$3C, -$54 ; mode, y, x
 DB $02, -$3C, -$5F ; mode, y, x
 DB $02, -$3C, +$54 ; mode, y, x
 DB $02, -$5F, +$07 ; mode, y, x
 DB $02, +$3C, +$5E ; mode, y, x
 DB $00, +$00, -$5A ; mode, y, x
 DB $00, +$00, -$59 ; mode, y, x
 DB $02, +$5F, -$06 ; mode, y, x
 DB $02, -$3C, +$54 ; mode, y, x
 DB $02, +$3C, +$5F ; mode, y, x
 DB $02, +$3C, -$54 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_55:
 DB $00, -$35, -$50 ; move to y, x
 DB $02, -$37, +$60 ; mode, y, x
 DB $02, +$51, +$52 ; mode, y, x
 DB $02, +$51, -$11 ; mode, y, x
 DB $02, +$37, -$60 ; mode, y, x
 DB $02, -$51, -$51 ; mode, y, x
 DB $02, -$37, +$60 ; mode, y, x
 DB $02, -$51, +$10 ; mode, y, x
 DB $02, +$51, +$52 ; mode, y, x
 DB $00, -$0D, -$59 ; mode, y, x
 DB $00, -$0D, -$59 ; mode, y, x
 DB $02, +$51, -$10 ; mode, y, x
 DB $02, -$37, +$60 ; mode, y, x
 DB $02, +$51, +$51 ; mode, y, x
 DB $02, +$37, -$60 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_56:
 DB $00, -$3A, -$4A ; move to y, x
 DB $02, -$2F, +$6A ; mode, y, x
 DB $02, +$63, +$42 ; mode, y, x
 DB $02, +$41, -$17 ; mode, y, x
 DB $02, +$2F, -$6A ; mode, y, x
 DB $02, -$63, -$42 ; mode, y, x
 DB $02, -$2E, +$6B ; mode, y, x
 DB $02, -$42, +$16 ; mode, y, x
 DB $02, +$63, +$42 ; mode, y, x
 DB $00, -$1A, -$56 ; mode, y, x
 DB $00, -$1A, -$56 ; mode, y, x
 DB $02, +$41, -$17 ; mode, y, x
 DB $02, -$2E, +$6B ; mode, y, x
 DB $02, +$62, +$41 ; mode, y, x
 DB $02, +$2F, -$6A ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_57:
 DB $00, -$3D, -$45 ; move to y, x
 DB $02, -$25, +$73 ; mode, y, x
 DB $02, +$70, +$30 ; mode, y, x
 DB $02, +$30, -$17 ; mode, y, x
 DB $02, +$25, -$74 ; mode, y, x
 DB $02, -$70, -$30 ; mode, y, x
 DB $02, -$25, +$74 ; mode, y, x
 DB $02, -$30, +$17 ; mode, y, x
 DB $02, +$70, +$30 ; mode, y, x
 DB $00, -$25, -$52 ; mode, y, x
 DB $00, -$26, -$51 ; mode, y, x
 DB $02, +$30, -$18 ; mode, y, x
 DB $02, -$25, +$74 ; mode, y, x
 DB $02, +$70, +$30 ; mode, y, x
 DB $02, +$25, -$74 ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_58:
 DB $00, -$3E, -$42 ; move to y, x
 DB $02, -$1A, +$7A ; mode, y, x
 DB $02, +$79, +$1E ; mode, y, x
 DB $02, +$1E, -$13 ; mode, y, x
 DB $02, +$1A, -$7A ; mode, y, x
 DB $02, -$79, -$1E ; mode, y, x
 DB $02, -$19, +$79 ; mode, y, x
 DB $02, -$1F, +$14 ; mode, y, x
 DB $02, +$79, +$1E ; mode, y, x
 DB $00, -$2F, -$4C ; mode, y, x
 DB $00, -$30, -$4C ; mode, y, x
 DB $02, +$1E, -$13 ; mode, y, x
 DB $02, -$19, +$79 ; mode, y, x
 DB $02, +$78, +$1F ; mode, y, x
 DB $02, +$1A, -$7A ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_59:
 DB $00, -$3F, -$40 ; move to y, x
 DB $02, -$0D, +$7E ; mode, y, x
 DB $02, +$7E, +$0E ; mode, y, x
 DB $02, +$0E, -$0B ; mode, y, x
 DB $02, +$0D, -$7E ; mode, y, x
 DB $02, -$7E, -$0E ; mode, y, x
 DB $02, -$0D, +$7D ; mode, y, x
 DB $02, -$0E, +$0C ; mode, y, x
 DB $02, +$7E, +$0E ; mode, y, x
 DB $00, -$38, -$46 ; mode, y, x
 DB $00, -$39, -$46 ; mode, y, x
 DB $02, +$0E, -$0B ; mode, y, x
 DB $02, -$0D, +$7D ; mode, y, x
 DB $02, +$7E, +$0F ; mode, y, x
 DB $02, +$0D, -$7E ; mode, y, x
 DB $01 ; endmarker (1)
AnimList_60:
 DB $00, -$3F, -$3F ; move to y, x
 DB $02, +$00, +$00 ; mode, y, x
 DB $00, +$00, +$00 ; mode, y, x
 DB $02, +$00, +$7F ; mode, y, x
 DB $02, +$7F, +$00 ; mode, y, x
 DB $02, +$00, -$7F ; mode, y, x
 DB $02, -$7F, +$00 ; mode, y, x
 DB $02, +$00, +$7F ; mode, y, x
 DB $02, +$00, -$7F ; mode, y, x
 DB $01 ; endmarker (1)