;
;
;         IF      L.PCK = OFF      ;-------------------------------------------
;         LIST    -L               ;--  PACKS  --------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  ***************************************
;  ***************************************
;  ***                                 ***
;  ***          P A C K E T S          ***
;  ***                                 ***
;  ***************************************
;  ***************************************
;
;
;  BOX ANIMATION
;  =============
;
PBOX1    DW      BXOPN0           ;  BOX OPENING / CLOSING ANIMATION
         DW      BXOPN1           ;  .
         DW      BXOPN1           ;  .
         DW      BXOPN1           ;  .
         DW      BXOPN1           ;  .
         DW      BXOPN1           ;  .
         DW      0                ;  .    TERMINATOR
;
PBOX2    DW      LDOPN0           ;  LID OPENING / CLOSING ANIMATION
         DW      LDOPN1           ;  .
         DW      LDOPN2           ;  .
         DW      LDOPN3           ;  .
         DW      LDOPN4           ;  .
         DW      LDOPN5           ;  .
;
;
;
BXOPN0   DB      $07              ;  BOTTOM OF BOX CLOSED (DIFFY)
         DW      $E800            ;  .
         DW      $F8E0            ;  .
         DW      $1800            ;  .
         DW      $00C0            ;  .
         DW      $E800            ;  .
         DW      $0040            ;  .
         DW      $1800            ;  .
         DW      $0820            ;  .
;
LDOPN0   DB      $0A              ;  LID OF BOX CLOSED (DIFFY)
         DW      $0800            ;  .
         DW      $00C0            ;  .
         DW      $F8E0            ;  .
         DW      $0040            ;  .
         DW      $F800            ;  .
         DW      $081F            ;  .
         DW      $0700            ;  .
         DW      $F8E0            ;  .
         DW      $F800            ;  .
         DW      $00C1            ;  .
         DW      $0800            ;  .
;
;
;
BXOPN1   DB      $09              ;  BOX ANIMATION (DIFFY) - BOTTOM OF BOX
         DW      $E800            ;  .
         DW      $F8E0            ;  .
         DW      $1800            ;  .
         DW      $00C0            ;  .
         DW      $E800            ;  .
         DW      $0040            ;  .
         DW      $1800            ;  .
         DW      $0820            ;  .
         DW      $00C0            ;  .
         DW      $F8E0            ;  .
;
;
LDOPN1   DB      $0B              ;  BOX ANIMATION (DIFFY) - FRAME #1
         DW      $0902            ;  .
         DW      $08E0            ;  .
         DW      $F7FE            ;  .
         DW      $00C0            ;  .
         DW      $F820            ;  .
         DW      $0702            ;  .
         DW      $F9FE            ;  .
         DW      $0040            ;  .
         DW      $07E0            ;  .
         DW      $0902            ;  .
         DW      $00C0            ;  .
         DW      $F7FE            ;  .
;
LDOPN2   DB      $0E              ;  BOX ANIMATION (DIFFY) - FRAME #2
         DW      $0904            ;  .
         DW      $10E0            ;  .
         DW      $F8FC            ;  .
         DW      $00C0            ;  .
         DW      $0704            ;  .
         DW      $0040            ;  .
         DW      $F8FC            ;  .
         DW      $F021            ;  .
         DW      $00C0            ;  .
         DW      $10DF            ;  .
         DW      $0012            ;  .
         DW      $F812            ;  .
         DW      $F8FD            ;  .
         DW      $0803            ;  .
         DW      $0029            ;  .
;
LDOPN3   DB      $0D              ;  BOX ANIMATION (DIFFY) - FRAME #3
         DW      $0606            ;  .
         DW      $1AE4            ;  .
         DW      $FAFA            ;  .
         DW      $00C0            ;  .
         DW      $0606            ;  .
         DW      $0040            ;  .
         DW      $FAFA            ;  .
         DW      $E61C            ;  .
         DW      $07F8            ;  .
         DW      $00CF            ;  .
         DW      $12EA            ;  .
         DW      $00F4            ;  .
         DW      $E71C            ;  .
         DW      $0606            ;  .
;
LDOPN4   DB      $0E              ;  BOX ANIMATION (DIFFY) - FRAME #4
         DW      $0208            ;  .
         DW      $24F6            ;  .
         DW      $FEF8            ;  .
         DW      $00C0            ;  .
         DW      $0208            ;  .
         DW      $0040            ;  .
         DW      $FEF8            ;  .
         DW      $DC0A            ;  .
         DW      $03FF            ;  .
         DW      $00CA            ;  .
         DW      $FEF8            ;  .
         DW      $0208            ;  .
         DW      $22F5            ;  .
         DW      $FEF8            ;  .
         DW      $DD0B            ;  .
;
LDOPN5   DB      $0B              ;  BOX ANIMATION (DIFFY) - FRAME #5
         DW      $FE08            ;  .
         DW      $2408            ;  .
         DW      $02F8            ;  .
         DW      $00C0            ;  .
         DW      $DDF8            ;  .
         DW      $0008            ;  .
         DW      $2008            ;  .
         DW      $02F8            ;  .
         DW      $FE08            ;  .
         DW      $0038            ;  .
         DW      $0200            ;  .
         DW      $DCF7            ;  .
;
;
;
;
;  WALKING ANIMATION
;  =================
;
WLKNG1   DW      WWAR11           ;  WARRIOR WALKING ANIMATION (RIGHT SIDE)
         DW      WWAR21           ;  .
         DW      WWAR31           ;  .
         DW      WWAR21           ;  .
         DW      WWAR31           ;  .
         DW      0                ;  .    TERMINATOR
;
WLKNG2   DW      WWAR12           ;  WARRIOR WALKING ANIMATION (LEFT SIDE)
         DW      WWAR22           ;  .
         DW      WWAR32           ;  .
         DW      WWAR22           ;  .
         DW      WWAR32           ;  .
;
;
WKDRW    DB      $00              ;  DRAWING FLAGS FOR WALKING ANIMATION
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $FF              ;  .
         DB      $FF              ;  .
;
;
;
WWAR11   DB      $14              ;  WALKING WARRIOR (RIGHT) - FRAME #0 (DIFFY)
         DW      $14FF            ;  .
         DW      $0002            ;  .
         DW      $E600            ;  .
         DW      $0205            ;  .
         DW      $F801            ;  .
         DW      $FE0C            ;  .
         DW      $D4FE            ;  .
         DW      $FEFC            ;  .
         DW      $0602            ;  .
         DW      $FEFC            ;  .
         DW      $0200            ;  .
         DW      $0404            ;  .
         DW      $1EFC            ;  .
         DW      $F4FC            ;  .
         DW      $F004            ;  .
         DW      $D0FE            ;  .
         DW      $0400            ;  .
         DW      $FE04            ;  .
         DW      $F8FC            ;  .
         DW      $00FC            ;  .
         DW      $32FA            ;  .
;
WWAR12   DB      $1A              ;  WALKING WARRIOR (LEFT) - FRAME #0 (DIFFY)
         DW      $1401            ;  .
         DW      $00FE            ;  .
         DW      $E600            ;  .
         DW      $04F5            ;  .
         DW      $0C00            ;  .
         DW      $080C            ;  .
         DW      $F80C            ;  .
         DW      $F400            ;  .
         DW      $FBF4            ;  .
         DW      $02FA            ;  .
         DW      $F8FE            ;  .
         DW      $FEF4            ;  .
         DW      $D402            ;  .
         DW      $FE04            ;  .
         DW      $06FE            ;  .
         DW      $FE04            ;  .
         DW      $0200            ;  .
         DW      $04FC            ;  .
         DW      $1E04            ;  .
         DW      $F404            ;  .
         DW      $F0FC            ;  .
         DW      $D002            ;  .
         DW      $0400            ;  .
         DW      $FEFC            ;  .
         DW      $F804            ;  .
         DW      $0004            ;  .
         DW      $3305            ;  .
;
;
WWAR21   DB      $1A              ;  WALKING WARRIOR (RIGHT) - FRAME #1 (DIFFY)
         DW      $14FF            ;  .
         DW      $0002            ;  .
         DW      $E600            ;  .
         DW      $0205            ;  .
         DW      $F801            ;  .
         DW      $FE0C            ;  .
         DW      $D4FE            ;  .
         DW      $FEFC            ;  .
         DW      $0602            ;  .
         DW      $FEFC            ;  .
         DW      $0200            ;  .
         DW      $0404            ;  .
         DW      $1EFC            ;  .
         DW      $F4FC            ;  .
         DW      $DC08            ;  .
         DW      $F4FA            ;  .
         DW      $02FE            ;  .
         DW      $00FE            ;  .
         DW      $FEFE            ;  .
         DW      $F602            ;  .
         DW      $0006            ;  .
         DW      $0AFE            ;  .
         DW      $02FE            ;  .
         DW      $00FE            ;  .
         DW      $FEFE            ;  .
         DW      $0C04            ;  .
         DW      $0FF9            ;  .
;
WWAR22   DB      $1C              ;  WALKING WARRIOR (LEFT) - FRAME #1 (DIFFY)
         DW      $1401            ;  .
         DW      $00FE            ;  .
         DW      $E600            ;  .
         DW      $04F5            ;  .
         DW      $0C00            ;  .
         DW      $080C            ;  .
         DW      $F80C            ;  .
         DW      $F400            ;  .
         DW      $FBF4            ;  .
         DW      $02FA            ;  .
         DW      $F8FE            ;  .
         DW      $FCF4            ;  .
         DW      $E600            ;  .
         DW      $F604            ;  .
         DW      $F802            ;  .
         DW      $0600            ;  .
         DW      $FE02            ;  .
         DW      $0200            ;  .
         DW      $02FE            ;  .
         DW      $0CFE            ;  .
         DW      $1404            ;  .
         DW      $F404            ;  .
         DW      $F0FC            ;  .
         DW      $D002            ;  .
         DW      $0400            ;  .
         DW      $FEFC            ;  .
         DW      $F804            ;  .
         DW      $0004            ;  .
         DW      $3205            ;  .
;
;
WWAR31   DB      $17              ;  WALKING WARRIOR (RIGHT) - FRAME #2 (DIFFY)
         DW      $14FF            ;  .
         DW      $0002            ;  .
         DW      $E600            ;  .
         DW      $0205            ;  .
         DW      $F801            ;  .
         DW      $FE0C            ;  .
         DW      $D4FE            ;  .
         DW      $FEFC            ;  .
         DW      $0602            ;  .
         DW      $FEFC            ;  .
         DW      $0200            ;  .
         DW      $0404            ;  .
         DW      $1EFC            ;  .
         DW      $F4FC            ;  .
         DW      $F004            ;  .
         DW      $EC00            ;  .
         DW      $F2FE            ;  .
         DW      $0200            ;  .
         DW      $0206            ;  .
         DW      $FC00            ;  .
         DW      $FCFA            ;  .
         DW      $00FC            ;  .
         DW      $1400            ;  .
         DW      $0EFA            ;  .
;
WWAR32   DB      $18              ;  WALKING WARRIOR (LEFT) - FRAME #2 (DIFFY)
         DW      $1401            ;  .
         DW      $00FE            ;  .
         DW      $E600            ;  .
         DW      $04F5            ;  .
         DW      $0C00            ;  .
         DW      $080C            ;  .
         DW      $F80C            ;  .
         DW      $F400            ;  .
         DW      $FBF4            ;  .
         DW      $02FA            ;  .
         DW      $F8FE            ;  .
         DW      $FCF4            ;  .
         DW      $E402            ;  .
         DW      $0208            ;  .
         DW      $0301            ;  .
         DW      $00FC            ;  .
         DW      $1201            ;  .
         DW      $F404            ;  .
         DW      $F0FC            ;  .
         DW      $D002            ;  .
         DW      $0400            ;  .
         DW      $FEFC            ;  .
         DW      $F804            ;  .
         DW      $0004            ;  .
         DW      $3305            ;  .
;
;
;
;
;  INTERIOR OF BOX
;  ===============
;
WALLS    DB      $00              ;  WALLS FOR INTERIOR OF BOX (PACKET)
         DB      $00,$38,$C4      ;  .
         DB      $FF,$00,$10      ;  .
         DB      $FF,$A0,$00      ;  .
         DB      $FF,$00,$F0      ;  .
         DB      $00,$08,$10      ;  .
         DB      $FF,$00,$0C      ;  .
         DB      $FF,$50,$00      ;  .
         DB      $FF,$00,$F4      ;  .
         DB      $00,$FA,$0C      ;  .
         DB      $FF,$00,$08      ;  .
         DB      $FF,$BC,$00      ;  .
         DB      $FF,$00,$F8      ;  .
         DB      $00,$04,$08      ;  .
         DB      $FF,$00,$06      ;  .
         DB      $FF,$3A,$00      ;  .
         DB      $FF,$00,$FA      ;  .
         DB      $01              ;  .    TERMINATOR
;
;
;
;
;  THROWING WARRIOR ANIMATION
;  ==========================
;
FWAR1    DW      WWAR11           ;  WARRIOR SHUFFLE (RIGHT SIDE)
         DW      WWAR31           ;  .
         DW      WWAR31           ;  .
         DW      0                ;  .    TERMINATOR
;
FWAR2    DW      WWAR12           ;  WARRIOR SHUFFLE (LEFT SIDE)
         DW      WWAR32           ;  .
         DW      WWAR32           ;  .
;
FWDRW    DB      $00              ;  DRAW FLAGS FOR WARRIOR SHUFFLE
         DB      $00              ;  .
         DB      $FF              ;  .
;
;
;
THROW1   DW      WWAR11           ;  WARRIOR THROWING ANIMATION (RIGHT SIDE)
         DW      THRW21           ;  .
         DW      THRW41           ;  .
         DW      THRW31           ;  .
         DW      THRW41           ;  .
         DW      THRW51           ;  .
         DW      THRW61           ;  .
         DW      THRW61           ;  .
         DW      THRW61           ;  .
         DW      THRW61           ;  .
         DW      THRW71           ;  .
         DW      0                ;  .    TERMINATOR
;
WTHRW    DB      $00              ;  WARRIOR THROW FLAG
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $01              ;  .    RELEASE FLAMOID THIS FRAME
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .    INSURANCE
;
;
;
THRW21   DB      $18              ;  THROWING WARRIOR (RIGHT) - FRAME #2
         DW      $14FF            ;  .    (DIFFY)
         DW      $0002            ;  .
         DW      $E600            ;  .
         DW      $0205            ;  .
         DW      $F801            ;  .
         DW      $FE0C            ;  .
         DW      $EE08            ;  .
         DW      $FA05            ;  .
         DW      $0004            ;  .
         DW      $FE01            ;  .
         DW      $00FD            ;  .
         DW      $FC04            ;  .
         DW      $FC00            ;  .
         DW      $00FA            ;  .
         DW      $06FE            ;  .
         DW      $08F4            ;  .
         DW      $0DFA            ;  .
         DW      $F4FC            ;  .
         DW      $F004            ;  .
         DW      $D0FE            ;  .
         DW      $0400            ;  .
         DW      $FE04            ;  .
         DW      $F8FC            ;  .
         DW      $00FC            ;  .
         DW      $32FA            ;  .
;
;
THRW31   DB      $18              ;  THROWING WARRIOR (RIGHT) - FRAME #4
         DW      $14FF            ;  .    (DIFFY)
         DW      $0002            ;  .
         DW      $E600            ;  .
         DW      $0205            ;  .
         DW      $F801            ;  .
         DW      $FC0C            ;  .
         DW      $06FE            ;  .
         DW      $FCFC            ;  .
         DW      $02FF            ;  .
         DW      $0402            ;  .
         DW      $02FA            ;  .
         DW      $0602            ;  .
         DW      $0006            ;  .
         DW      $FE04            ;  .
         DW      $F006            ;  .
         DW      $FA00            ;  .
         DW      $04F2            ;  .
         DW      $F4FC            ;  .
         DW      $F004            ;  .
         DW      $D0FE            ;  .
         DW      $0400            ;  .
         DW      $FE04            ;  .
         DW      $F8FC            ;  .
         DW      $00FC            ;  .
         DW      $32FA            ;  .
;
;
THRW41   DB      $18              ;  THROWING WARRIOR (RIGHT) - FRAME #3, 5
         DW      $14FF            ;  .   (DIFFY)
         DW      $0002            ;  .
         DW      $E600            ;  .
         DW      $0205            ;  .
         DW      $F801            ;  .
         DW      $FE08            ;  .
         DW      $FC08            ;  .
         DW      $0A08            ;  .
         DW      $02FE            ;  .
         DW      $0202            ;  .
         DW      $FF01            ;  .
         DW      $0301            ;  .
         DW      $FE04            ;  .
         DW      $FC00            ;  .
         DW      $FEFC            ;  .
         DW      $F0FC            ;  .
         DW      $04F0            ;  .
         DW      $F6FA            ;  .
         DW      $F004            ;  .
         DW      $D0FE            ;  .
         DW      $0400            ;  .
         DW      $FE04            ;  .
         DW      $F8FC            ;  .
         DW      $00FC            ;  .
         DW      $32FA            ;  .
;
;
THRW51   DB      $17              ;  THROWING WARRIOR (RIGHT) - FRAME #6
         DW      $14FF            ;  .   (DIFFY)
         DW      $0002            ;  .
         DW      $E600            ;  .
         DW      $0205            ;  .
         DW      $F801            ;  .
         DW      $FE08            ;  .
         DW      $FA06            ;  .
         DW      $040A            ;  .
         DW      $0201            ;  .
         DW      $0001            ;  .
         DW      $FF00            ;  .
         DW      $0303            ;  .
         DW      $FC00            ;  .
         DW      $FEFC            ;  .
         DW      $F8F8            ;  .
         DW      $02F4            ;  .
         DW      $F8FB            ;  .
         DW      $F004            ;  .
         DW      $D0FE            ;  .
         DW      $0400            ;  .
         DW      $FE04            ;  .
         DW      $F8FC            ;  .
         DW      $00FC            ;  .
         DW      $32FA            ;  .
;
;
THRW61   DB      $15              ;  THROWING WARRIOR (RIGHT) - FRAME #7 - 10
         DW      $14FF            ;  .   (DIFFY)
         DW      $0002            ;  .
         DW      $E600            ;  .
         DW      $0205            ;  .
         DW      $F801            ;  .
         DW      $0006            ;  .
         DW      $FE04            ;  .
         DW      $0204            ;  .
         DW      $02FE            ;  .
         DW      $0001            ;  .
         DW      $04FF            ;  .
         DW      $FE04            ;  .
         DW      $F800            ;  .
         DW      $FAF2            ;  .
         DW      $F6FF            ;  .
         DW      $F004            ;  .
         DW      $D0FE            ;  .
         DW      $0400            ;  .
         DW      $FE04            ;  .
         DW      $F8FC            ;  .
         DW      $00FC            ;  .
         DW      $32FA            ;  .
;
;
THRW71   DB      $17              ;  THROWING WARRIOR (RIGHT) - FRAME #11
         DW      $14FF            ;  .    (DIFFY)
         DW      $0002            ;  .
         DW      $E600            ;  .
         DW      $0205            ;  .
         DW      $F801            ;  .
         DW      $FE0C            ;  .
         DW      $EC04            ;  .
         DW      $F8FE            ;  .
         DW      $FA00            ;  .
         DW      $FEFC            ;  .
         DW      $06FE            ;  .
         DW      $FEFE            ;  .
         DW      $01FF            ;  .
         DW      $0303            ;  .
         DW      $0802            ;  .
         DW      $0EFB            ;  .
         DW      $F4FC            ;  .
         DW      $F004            ;  .
         DW      $D0FE            ;  .
         DW      $0400            ;  .
         DW      $FE04            ;  .
         DW      $F8FC            ;  .
         DW      $00FC            ;  .
         DW      $32FA            ;  .
;
;
;
;
;  WARRIOR EXPLOSION FRAGMENTS
;  ===========================
;
EXWAR1   DB      $8F              ;  WARRIOR EXPLOSION FRAGMENT - HEAD
         DW      $1800            ;  .    (DUFFY)
         DW      $1401            ;  .
         DW      $00FE            ;  .
         DW      $E600            ;  .
         DW      $04F5            ;  .
         DW      $0C00            ;  .
         DW      $080C            ;  .
         DW      $F80C            ;  .
         DW      $F400            ;  .
         DW      $FBF4            ;  .
         DW      $02FA            ;  .
         DW      $F8FE            ;  .
         DW      $0802            ;  .
         DW      $FE06            ;  .
         DW      $0206            ;  .
         DW      $F802            ;  .
;
;
EXWAR2   DB      $89              ;  WARRIOR EXPLOSION FRAGMENT - LEFT ARM
         DW      $0CF8            ;  .    (DUFFY)
         DW      $FEF4            ;  .
         DW      $D402            ;  .
         DW      $FE04            ;  .
         DW      $06FE            ;  .
         DW      $FE04            ;  .
         DW      $0200            ;  .
         DW      $04FC            ;  .
         DW      $1E04            ;  .
         DW      $F404            ;  .
;
;
EXWAR3   DB      $8D              ;  WARRIOR EXPLOSION FRAGMENT - RIGHT ARM
         DW      $0C08            ;  .    (DUFFY)
         DW      $FE08            ;  .
         DW      $FC08            ;  .
         DW      $0A08            ;  .
         DW      $02FE            ;  .
         DW      $0202            ;  .
         DW      $FF01            ;  .
         DW      $0301            ;  .
         DW      $FE04            ;  .
         DW      $FC00            ;  .
         DW      $FEFC            ;  .
         DW      $F0FC            ;  .
         DW      $04F0            ;  .
         DW      $F6FA            ;  .
;
;
EXWAR4   DB      $8E              ;  WARRIOR EXPLOSION FRAGMENT - LEGS
         DW      $F8FA            ;  .    (DUFFY)
         DW      $F0FC            ;  .
         DW      $D002            ;  .
         DW      $0400            ;  .
         DW      $FEFC            ;  .
         DW      $F804            ;  .
         DW      $0004            ;  .
         DW      $3305            ;  .
         DW      $CD05            ;  .
         DW      $0004            ;  .
         DW      $0804            ;  .
         DW      $02FC            ;  .
         DW      $FC00            ;  .
         DW      $3002            ;  .
         DW      $10FC            ;  .
;
;
;
;
;  BRIGAND THROWING ANIMATION
;  ==========================
;
TBRGN1   DW      $FFFF            ;  BRIGAND THROWING ANIMATION (RIGHT SIDE)
         DW      TBRG11           ;  .
         DW      TBRG11           ;  .
         DW      TBRG21           ;  .
         DW      TBRG21           ;  .
         DW      TBRG21           ;  .
         DW      TBRG11           ;  .
         DW      TBRG11           ;  .
         DW      TBRG21           ;  .
         DW      TBRG31           ;  .
;
         DW      TBRG31           ;  .
         DW      TBRG31           ;  .
         DW      TBRG31           ;  .
         DW      TBRG31           ;  .
         DW      TBRG31           ;  .
         DW      TBRG31           ;  .
;
         DW      TBRG41           ;  .
         DW      TBRG51           ;  .
         DW      TBRG61           ;  .
;
         DW      TBRG61           ;  .
         DW      TBRG51           ;  .
         DW      0                ;  .    TERMINATOR
;
;
TBRGN2   DW      $FFFF            ;  BRIGAND THROWING ANIMATION (LEFT SIDE)
         DW      $FFFF            ;  .
         DW      $FFFF            ;  .
         DW      TBRG22           ;  .
         DW      TBRG22           ;  .
         DW      TBRG22           ;  .
         DW      $FFFF            ;  .
         DW      $FFFF            ;  .
         DW      TBRG22           ;  .
         DW      TBRG32           ;  .
;
         DW      TBRG32           ;  .
         DW      TBRG32           ;  .
         DW      TBRG32           ;  .
         DW      TBRG32           ;  .
         DW      TBRG32           ;  .
         DW      TBRG32           ;  .
;
         DW      TBRG32           ;  .
         DW      TBRG32           ;  .
         DW      TBRG32           ;  .
;
         DW      TBRG32           ;  .
         DW      $FFFF            ;  .
;
;
;
BTHRW    DB      $00              ;  BRIGAND THROW FLAG
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $01              ;  .    RELEASE FLAMOID THIS FRAME
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .
         DB      $00              ;  .    INSURANCE
;
;
;
BRGVIS   DB      0                ;  IS THE BRIGAND VISIBLE ?
         DB      0                ;  .
         DB      0                ;  .
         DB      0                ;  .
         DB      0                ;  .
         DB      0                ;  .
         DB      0                ;  .
         DB      0                ;  .
         DB      0                ;  .
         DB      1                ;  .
         DB      1                ;  .
         DB      1                ;  .
         DB      1                ;  .
         DB      1                ;  .
         DB      1                ;  .
         DB      1                ;  .
         DB      1                ;  .
         DB      1                ;  .
         DB      1                ;  .
         DB      1                ;  .
         DB      1                ;  .
         DB      0                ;  .    INSURANCE
;
;
;
TBRG11   DB      $11              ;  THROWING BRIGAND (ARM) - FRAME #0
         DW      $4D00            ;  .    (DIFFY)
         DW      $05E6            ;  .
         DW      $2C00            ;  .
         DW      $0408            ;  .
         DW      $FC04            ;  .
         DW      $FBFF            ;  .
         DW      $FCFD            ;  .
         DW      $EC06            ;  .
         DW      $000C            ;  .
         DW      $1F00            ;  .
         DW      $04F1            ;  .
         DW      $100F            ;  .
         DW      $0200            ;  .
         DW      $02F8            ;  .
         DW      $0608            ;  .
         DW      $EF00            ;  .
         DW      $FAFC            ;  .
         DW      $0004            ;  .
;
TBRG21   DB      $0D              ;  THROWING BRIGAND (ARM) - FRAME #1
         DW      $3700            ;  .    (DIFFY)
         DW      $12E8            ;  .
         DW      $FDDD            ;  .
         DW      $1A01            ;  .
         DW      $0604            ;  .
         DW      $FE04            ;  .
         DW      $FC01            ;  .
         DW      $FCFD            ;  .
         DW      $FB02            ;  .
         DW      $0F1C            ;  .
         DW      $FC0F            ;  .
         DW      $F0FB            ;  .
         DW      $FA0A            ;  .
         DW      $0102            ;  .
;
;
TBRG22   DB      $16              ;  THROWING BRIGAND (HEAD) - FRAME #1
         DW      $5400            ;  .    (DIFFY)
         DW      $04FC            ;  .
         DW      $F801            ;  .
         DW      $04FB            ;  .
         DW      $0C04            ;  .
         DW      $FC04            ;  .
         DW      $2D00            ;  .
         DW      $FCFB            ;  .
         DW      $02F7            ;  .
         DW      $F0E6            ;  .
         DW      $1303            ;  .
         DW      $FBF2            ;  .
         DW      $0C06            ;  .
         DW      $F4FA            ;  .
         DW      $020A            ;  .
         DW      $E9F9            ;  .
         DW      $061F            ;  .
         DW      $F7FE            ;  .
         DW      $FD0A            ;  .
         DW      $0603            ;  .
         DW      $04FA            ;  .
         DW      $F9F9            ;  .
         DW      $F50B            ;  .
;
;
TBRG31   DB      $1B              ;  THROWING BRIGAND (ARM) - FRAME #2
         DW      $1500            ;  .    (DIFFY)
         DW      $0FF2            ;  .
         DW      $1ED9            ;  .
         DW      $F6DD            ;  .
         DW      $20F1            ;  .
         DW      $0705            ;  .
         DW      $FE06            ;  .
         DW      $FC01            ;  .
         DW      $FBFF            ;  .
         DW      $F80A            ;  .
         DW      $1219            ;  .
         DW      $000F            ;  .
         DW      $EF00            ;  .
         DW      $FC08            ;  .
         DW      $0408            ;  .
         DW      $0D01            ;  .
         DW      $FA03            ;  .
         DW      $0604            ;  .
         DW      $07F4            ;  .
         DW      $F6FF            ;  .
         DW      $05F7            ;  .
         DW      $F3FF            ;  .
         DW      $FE06            ;  .
         DW      $07FD            ;  .
         DW      $F90C            ;  .
         DW      $0307            ;  .
         DW      $0B03            ;  .
         DW      $0AF5            ;  .
;
TBRG32   DB      $20              ;  THROWING BRIGAND (HEAD) - FRAME #2 - 5
         DW      $7000            ;  .    (DIFFY)
         DW      $00F8            ;  .
         DW      $F6EF            ;  .
         DW      $0F01            ;  .
         DW      $01F5            ;  .
         DW      $F9FE            ;  .
         DW      $FD07            ;  .
         DW      $0906            ;  .
         DW      $06F8            ;  .
         DW      $0E1D            ;  .
         DW      $0EEC            ;  .
         DW      $050A            ;  .
         DW      $06F2            ;  .
         DW      $FA0E            ;  .
         DW      $FBF1            ;  .
         DW      $F30E            ;  .
         DW      $FDE2            ;  .
         DW      $F9FB            ;  .
         DW      $00F7            ;  .
         DW      $EAEC            ;  .
         DW      $13FE            ;  .
         DW      $F8F3            ;  .
         DW      $0D04            ;  .
         DW      $F3FC            ;  .
         DW      $0409            ;  .
         DW      $E800            ;  .
         DW      $0E1D            ;  .
         DW      $F7FF            ;  .
         DW      $FF0B            ;  .
         DW      $0702            ;  .
         DW      $02F9            ;  .
         DW      $F8FA            ;  .
         DW      $F80E            ;  .
;
;
TBRG41   DB      $1B              ;  THROWING BRIGAND (ARM) - FRAME #3
         DW      $1500            ;  .    (DIFFY)
         DW      $0FF3            ;  .
         DW      $1BD5            ;  .
         DW      $F1EC            ;  .
         DW      $13E7            ;  .
         DW      $FEF4            ;  .
         DW      $07FA            ;  .
         DW      $0B08            ;  .
         DW      $FB07            ;  .
         DW      $F51B            ;  .
         DW      $140F            ;  .
         DW      $0715            ;  .
         DW      $EF00            ;  .
         DW      $FC08            ;  .
         DW      $0408            ;  .
         DW      $0D01            ;  .
         DW      $FA03            ;  .
         DW      $0604            ;  .
         DW      $07F4            ;  .
         DW      $F6FF            ;  .
         DW      $05F7            ;  .
         DW      $F3FF            ;  .
         DW      $FE06            ;  .
         DW      $07FD            ;  .
         DW      $F90C            ;  .
         DW      $0307            ;  .
         DW      $0B03            ;  .
         DW      $0AF5            ;  .
;
;
TBRG51   DB      $1D              ;  THROWING BRIGAND (ARM) - FRAME #4
         DW      $1500            ;  .    (DIFFY)
         DW      $0FF3            ;  .
         DW      $1AE4            ;  .
         DW      $06F1            ;  .
         DW      $FBF0            ;  .
         DW      $F109            ;  .
         DW      $FCFD            ;  .
         DW      $07FA            ;  .
         DW      $EFF8            ;  .
         DW      $FCF7            ;  .
         DW      $11FB            ;  .
         DW      $120B            ;  .
         DW      $100E            ;  .
         DW      $0D1C            ;  .
         DW      $EF00            ;  .
         DW      $FC08            ;  .
         DW      $0408            ;  .
         DW      $0D01            ;  .
         DW      $FA03            ;  .
         DW      $0604            ;  .
         DW      $07F4            ;  .
         DW      $F6FF            ;  .
         DW      $05F7            ;  .
         DW      $F3FF            ;  .
         DW      $FE06            ;  .
         DW      $07FD            ;  .
         DW      $F90C            ;  .
         DW      $0307            ;  .
         DW      $0B03            ;  .
         DW      $0AF5            ;  .
;
;
TBRG61   DB      $1E              ;  THROWING BRIGAND (ARM) - FRAME #5
         DW      $1500            ;  .    (DIFFY)
         DW      $0FF3            ;  .
         DW      $17DF            ;  .
         DW      $F8F0            ;  .
         DW      $ED02            ;  .
         DW      $FC09            ;  .
         DW      $FD00            ;  .
         DW      $FFFD            ;  .
         DW      $FB06            ;  .
         DW      $F8FF            ;  .
         DW      $FFF5            ;  .
         DW      $0FF7            ;  .
         DW      $19F5            ;  .
         DW      $190E            ;  .
         DW      $1319            ;  .
         DW      $EF00            ;  .
         DW      $FC08            ;  .
         DW      $0408            ;  .
         DW      $0D01            ;  .
         DW      $FA03            ;  .
         DW      $0604            ;  .
         DW      $07F4            ;  .
         DW      $F6FF            ;  .
         DW      $05F7            ;  .
         DW      $F3FF            ;  .
         DW      $FE06            ;  .
         DW      $07FD            ;  .
         DW      $F90C            ;  .
         DW      $0307            ;  .
         DW      $0B03            ;  .
         DW      $0AF5            ;  .
;
;
;
;
;  BRIGAND EXPLOSION FRAGMENTS
;  ===========================
;
EXBRG1   DB      $8B              ;  BRIGAND EXPLOSION FRAGMENT - ARM (DUFFY)
         DW      $E400            ;  .
         DW      $0FF2            ;  .
         DW      $1ED9            ;  .
         DW      $F6DD            ;  .
         DW      $20F1            ;  .
         DW      $0705            ;  .
         DW      $FE06            ;  .
         DW      $FC01            ;  .
         DW      $FBFF            ;  .
         DW      $F80A            ;  .
         DW      $1219            ;  .
         DW      $000F            ;  .
;
EXBRG2   DB      $8D              ;  BRIGAND EXPLOSION FRAGMENT - ARM (DUFFY)
         DW      $E400            ;  .
         DW      $0F0D            ;  .
         DW      $1A1C            ;  .
         DW      $060F            ;  .
         DW      $FB10            ;  .
         DW      $F1F7            ;  .
         DW      $FC03            ;  .
         DW      $0706            ;  .
         DW      $EF08            ;  .
         DW      $FC09            ;  .
         DW      $1105            ;  .
         DW      $12F5            ;  .
         DW      $10F2            ;  .
         DW      $0DE4            ;  .
;
EXBRG3   DB      $9B              ;  BRIGAND EXPLOSION FRAGMENT - HEAD (DUFFY)
         DW      $36E6            ;  .
         DW      $0F01            ;  .
         DW      $06F8            ;  .
         DW      $0E1D            ;  .
         DW      $0EEC            ;  .
         DW      $050A            ;  .
         DW      $06F2            ;  .
         DW      $FA0E            ;  .
         DW      $FBF1            ;  .
         DW      $F30E            ;  .
         DW      $FDE2            ;  .
         DW      $F9FB            ;  .
         DW      $00F7            ;  .
         DW      $EAEC            ;  .
         DW      $13FE            ;  .
         DW      $F8F3            ;  .
         DW      $0D04            ;  .
         DW      $F3FC            ;  .
         DW      $0409            ;  .
         DW      $E800            ;  .
         DW      $0E1D            ;  .
         DW      $F7FF            ;  .
         DW      $F80E            ;  .
         DW      $EF00            ;  .
         DW      $FC08            ;  .
         DW      $070E            ;  .
         DW      $0B03            ;  .
         DW      $0AF5            ;  .
;
;
;
;
;  MAGICIAN ANIMATION
;  ==================
;
MAGIC1   DW      MAGC11           ;  MAGICIAN ANIMATION (RIGHT SIDE)
         DW      MAGC11           ;  .
         DW      MAGC11           ;  .
         DW      MAGC21           ;  .
         DW      MAGC31           ;  .
         DW      MAGC41           ;  .
         DW      MAGC31           ;  .
         DW      MAGC41           ;  .
         DW      MAGC51           ;  .
         DW      MAGC41           ;  .
         DW      MAGC41           ;  .
         DW      0                ;  .    TERMINATOR
;
MAGIC2   DW      MAGC12           ;  MAGICIAN ANIMATION (LEFT SIDE)
         DW      MAGC12           ;  .
         DW      MAGC12           ;  .
         DW      MAGC22           ;  .
         DW      MAGC32           ;  .
         DW      MAGC42           ;  .
         DW      MAGC32           ;  .
         DW      MAGC42           ;  .
         DW      MAGC52           ;  .
         DW      MAGC42           ;  .
         DW      MAGC42           ;  .
;
;
;
MAGC11   DB      $21              ;  MAGICIAN ANIMATION (RIGHT) - FRAME #1
         DW      $FF02            ;  .    (DIFFY)
         DW      $0402            ;  .
         DW      $FEFC            ;  .
         DW      $02FC            ;  .
         DW      $FC02            ;  .
         DW      $08F8            ;  .
         DW      $0604            ;  .
         DW      $FC02            ;  .
         DW      $0202            ;  .
         DW      $02FC            ;  .
         DW      $00FA            ;  .
         DW      $FCFF            ;  .
         DW      $06FF            ;  .
         DW      $0208            ;  .
         DW      $0202            ;  .
         DW      $0008            ;  .
         DW      $FE02            ;  .
         DW      $FE08            ;  .
         DW      $FAFF            ;  .
         DW      $04FF            ;  .
         DW      $00FA            ;  .
         DW      $FA04            ;  .
         DW      $FEFE            ;  .
         DW      $FC08            ;  .
         DW      $E804            ;  .
         DW      $F2FA            ;  .
         DW      $18FC            ;  .
         DW      $DA06            ;  .
         DW      $F8F6            ;  .
         DW      $06FC            ;  .
         DW      $F6F8            ;  .
         DW      $0404            ;  .
         DW      $FC0E            ;  .
         DW      $0A02            ;  .
;
MAGC12   DB      $17              ;  MAGICIAN ANIMATION (LEFT) - FRAME #1
         DW      $FFFE            ;  .    (DIFFY)
         DW      $08F8            ;  .
         DW      $0604            ;  .
         DW      $0204            ;  .
         DW      $FC02            ;  .
         DW      $0402            ;  .
         DW      $FE04            ;  .
         DW      $FCFE            ;  .
         DW      $02FE            ;  .
         DW      $0204            ;  .
         DW      $FA04            ;  .
         DW      $F8F8            ;  .
         DW      $01FE            ;  .
         DW      $FFFE            ;  .
         DW      $06FA            ;  .
         DW      $FCF8            ;  .
         DW      $E8FC            ;  .
         DW      $F206            ;  .
         DW      $1804            ;  .
         DW      $DAFA            ;  .
         DW      $F40A            ;  .
         DW      $04FC            ;  .
         DW      $FCFC            ;  .
         DW      $09FF            ;  .
;
;
MAGC21   DB      $26              ;  MAGICIAN ANIMATION (RIGHT) - FRAME #2
         DW      $FF02            ;  .    (DIFFY)
         DW      $0402            ;  .
         DW      $FEFC            ;  .
         DW      $02FC            ;  .
         DW      $FC02            ;  .
         DW      $08F8            ;  .
         DW      $0604            ;  .
         DW      $FC02            ;  .
         DW      $0202            ;  .
         DW      $02FC            ;  .
         DW      $00FA            ;  .
         DW      $FCFF            ;  .
         DW      $06FF            ;  .
         DW      $0208            ;  .
         DW      $0202            ;  .
         DW      $0008            ;  .
         DW      $FE02            ;  .
         DW      $FE08            ;  .
         DW      $FAFF            ;  .
         DW      $04FF            ;  .
         DW      $00FA            ;  .
         DW      $FA04            ;  .
         DW      $FEFE            ;  .
         DW      $FC08            ;  .
         DW      $EE10            ;  .
         DW      $FA04            ;  .
         DW      $04FA            ;  .
         DW      $FE00            ;  .
         DW      $02FE            ;  .
         DW      $0204            ;  .
         DW      $F4F2            ;  .
         DW      $10F8            ;  .
         DW      $DA06            ;  .
         DW      $F8F6            ;  .
         DW      $06FC            ;  .
         DW      $F6F8            ;  .
         DW      $0404            ;  .
         DW      $FC0E            ;  .
         DW      $0A02            ;  .
;
MAGC22   DB      $1C              ;  MAGICIAN ANIMATION (LEFT) - FRAME #2
         DW      $FFFE            ;  .    (DIFFY)
         DW      $08F8            ;  .
         DW      $0604            ;  .
         DW      $0204            ;  .
         DW      $FC02            ;  .
         DW      $0402            ;  .
         DW      $FE04            ;  .
         DW      $FCFE            ;  .
         DW      $02FE            ;  .
         DW      $0204            ;  .
         DW      $FA04            ;  .
         DW      $F8F8            ;  .
         DW      $01FE            ;  .
         DW      $FFFE            ;  .
         DW      $06FA            ;  .
         DW      $FCF8            ;  .
         DW      $EEF0            ;  .
         DW      $FAFC            ;  .
         DW      $0406            ;  .
         DW      $FE00            ;  .
         DW      $0202            ;  .
         DW      $02FC            ;  .
         DW      $F40E            ;  .
         DW      $1008            ;  .
         DW      $DAFA            ;  .
         DW      $F40A            ;  .
         DW      $04FC            ;  .
         DW      $FCFC            ;  .
         DW      $09FF            ;  .
;
;
MAGC31   DB      $2A              ;  MAGICIAN ANIMATION (RIGHT) - FRAME #3
         DW      $FF02            ;  .    (DIFFY)
         DW      $0402            ;  .
         DW      $FEFC            ;  .
         DW      $02FC            ;  .
         DW      $FC02            ;  .
         DW      $08F8            ;  .
         DW      $0604            ;  .
         DW      $FC02            ;  .
         DW      $0202            ;  .
         DW      $02FC            ;  .
         DW      $00FA            ;  .
         DW      $FCFF            ;  .
         DW      $06FF            ;  .
         DW      $0208            ;  .
         DW      $0202            ;  .
         DW      $0008            ;  .
         DW      $FE02            ;  .
         DW      $FE08            ;  .
         DW      $FAFF            ;  .
         DW      $04FF            ;  .
         DW      $00FA            ;  .
         DW      $FA04            ;  .
         DW      $FEFE            ;  .
         DW      $FC08            ;  .
         DW      $FA02            ;  .
         DW      $040C            ;  .
         DW      $FC02            ;  .
         DW      $FAFE            ;  .
         DW      $0400            ;  .
         DW      $FEFE            ;  .
         DW      $0400            ;  .
         DW      $FEFE            ;  .
         DW      $0400            ;  .
         DW      $F400            ;  .
         DW      $F6F8            ;  .
         DW      $0CF6            ;  .
         DW      $DA06            ;  .
         DW      $F8F6            ;  .
         DW      $06FC            ;  .
         DW      $F6F8            ;  .
         DW      $0404            ;  .
         DW      $FC0E            ;  .
         DW      $0A02            ;  .
;
MAGC32   DB      $20              ;  MAGICIAN ANIMATION (LEFT) - FRAME #3
         DW      $FFFE            ;  .    (DIFFY)
         DW      $08F8            ;  .
         DW      $0604            ;  .
         DW      $0204            ;  .
         DW      $FC02            ;  .
         DW      $0402            ;  .
         DW      $FE04            ;  .
         DW      $FCFE            ;  .
         DW      $02FE            ;  .
         DW      $0204            ;  .
         DW      $FA04            ;  .
         DW      $F8F8            ;  .
         DW      $01FE            ;  .
         DW      $FFFE            ;  .
         DW      $06FA            ;  .
         DW      $FCF8            ;  .
         DW      $FAFE            ;  .
         DW      $04F4            ;  .
         DW      $FCFE            ;  .
         DW      $FA02            ;  .
         DW      $0400            ;  .
         DW      $FE02            ;  .
         DW      $0400            ;  .
         DW      $FE02            ;  .
         DW      $0400            ;  .
         DW      $F400            ;  .
         DW      $F608            ;  .
         DW      $0C09            ;  .
         DW      $DAFA            ;  .
         DW      $F40A            ;  .
         DW      $04FC            ;  .
         DW      $FCFC            ;  .
         DW      $09FF            ;  .
;
;
MAGC41   DB      $2A              ;  MAGICIAN ANIMATION (RIGHT) - FRAME #4
         DW      $FF02            ;  .    (DIFFY)
         DW      $0402            ;  .
         DW      $FEFC            ;  .
         DW      $02FC            ;  .
         DW      $FC02            ;  .
         DW      $08F8            ;  .
         DW      $0604            ;  .
         DW      $FC02            ;  .
         DW      $0202            ;  .
         DW      $02FC            ;  .
         DW      $00FA            ;  .
         DW      $FCFF            ;  .
         DW      $06FF            ;  .
         DW      $0208            ;  .
         DW      $0202            ;  .
         DW      $0008            ;  .
         DW      $FE02            ;  .
         DW      $FE08            ;  .
         DW      $FAFF            ;  .
         DW      $04FF            ;  .
         DW      $00FA            ;  .
         DW      $FA04            ;  .
         DW      $FEFE            ;  .
         DW      $FC08            ;  .
         DW      $FA02            ;  .
         DW      $0E0E            ;  .
         DW      $FE04            ;  .
         DW      $F802            ;  .
         DW      $06FE            ;  .
         DW      $FC00            ;  .
         DW      $04FE            ;  .
         DW      $FAFC            ;  .
         DW      $0600            ;  .
         DW      $F400            ;  .
         DW      $EEF6            ;  .
         DW      $0CF7            ;  .
         DW      $DA06            ;  .
         DW      $F8F6            ;  .
         DW      $06FC            ;  .
         DW      $F6F8            ;  .
         DW      $0404            ;  .
         DW      $FC0E            ;  .
         DW      $0A02            ;  .
;
MAGC42   DB      $20              ;  MAGICIAN ANIMATION (LEFT) - FRAME #4
         DW      $FFFE            ;  .    (DIFFY)
         DW      $08F8            ;  .
         DW      $0604            ;  .
         DW      $0204            ;  .
         DW      $FC02            ;  .
         DW      $0402            ;  .
         DW      $FE04            ;  .
         DW      $FCFE            ;  .
         DW      $02FE            ;  .
         DW      $0204            ;  .
         DW      $FA04            ;  .
         DW      $F8F8            ;  .
         DW      $01FE            ;  .
         DW      $FFFE            ;  .
         DW      $06FA            ;  .
         DW      $FCF8            ;  .
         DW      $FAFE            ;  .
         DW      $0EF2            ;  .
         DW      $FEFC            ;  .
         DW      $F8FE            ;  .
         DW      $0602            ;  .
         DW      $FC00            ;  .
         DW      $0402            ;  .
         DW      $FA04            ;  .
         DW      $0600            ;  .
         DW      $F400            ;  .
         DW      $EE0A            ;  .
         DW      $0C09            ;  .
         DW      $DAFA            ;  .
         DW      $F40A            ;  .
         DW      $04FC            ;  .
         DW      $FCFC            ;  .
         DW      $09FF            ;  .
;
;
MAGC51   DB      $29              ;  MAGICIAN ANIMATION (RIGHT) - FRAME #5
         DW      $FF02            ;  .    (DIFFY)
         DW      $0402            ;  .
         DW      $FEFC            ;  .
         DW      $02FC            ;  .
         DW      $FC02            ;  .
         DW      $08F8            ;  .
         DW      $0604            ;  .
         DW      $FC02            ;  .
         DW      $0202            ;  .
         DW      $02FC            ;  .
         DW      $00FA            ;  .
         DW      $FCFF            ;  .
         DW      $06FF            ;  .
         DW      $0208            ;  .
         DW      $0202            ;  .
         DW      $0008            ;  .
         DW      $FE02            ;  .
         DW      $FE08            ;  .
         DW      $FAFF            ;  .
         DW      $04FF            ;  .
         DW      $00FA            ;  .
         DW      $FA04            ;  .
         DW      $FEFE            ;  .
         DW      $FC08            ;  .
         DW      $FA02            ;  .
         DW      $0E0E            ;  .
         DW      $0400            ;  .
         DW      $FE02            ;  .
         DW      $0406            ;  .
         DW      $FA00            ;  .
         DW      $F8F4            ;  .
         DW      $0400            ;  .
         DW      $F400            ;  .
         DW      $EEF6            ;  .
         DW      $0CF7            ;  .
         DW      $DA06            ;  .
         DW      $F8F6            ;  .
         DW      $06FC            ;  .
         DW      $F6F8            ;  .
         DW      $0404            ;  .
         DW      $FC0E            ;  .
         DW      $0A02            ;  .
;
MAGC52   DB      $1F              ;  MAGICIAN ANIMATION (LEFT) - FRAME #5
         DW      $FFFE            ;  .    (DIFFY)
         DW      $08F8            ;  .
         DW      $0604            ;  .
         DW      $0204            ;  .
         DW      $FC02            ;  .
         DW      $0402            ;  .
         DW      $FE04            ;  .
         DW      $FCFE            ;  .
         DW      $02FE            ;  .
         DW      $0204            ;  .
         DW      $FA04            ;  .
         DW      $F8F8            ;  .
         DW      $01FE            ;  .
         DW      $FFFE            ;  .
         DW      $06FA            ;  .
         DW      $FCF8            ;  .
         DW      $FAFE            ;  .
         DW      $0EF2            ;  .
         DW      $0400            ;  .
         DW      $FEFE            ;  .
         DW      $04FA            ;  .
         DW      $FA00            ;  .
         DW      $F80C            ;  .
         DW      $0400            ;  .
         DW      $F400            ;  .
         DW      $EE0A            ;  .
         DW      $0C09            ;  .
         DW      $DAFA            ;  .
         DW      $F40A            ;  .
         DW      $04FC            ;  .
         DW      $FCFC            ;  .
         DW      $09FF            ;  .
;
;
;
;
;    FOREST / MAP OBJECTS
;    ====================
;
OBJTYP   DW      PTREE0           ;  OBJECT PACKET LOOK-UP TABLE
         DW      PTREE1           ;  .    TREE TYPE #1            $01
         DW      PTREE2           ;  .    TREE TYPE #2            $02
         DW      PTREE3           ;  .    TREE TYPE #3            $03
         DW      PTREE0           ;  .    DEAD TREE               $04
         DW      $00F0            ;  .    SCENERY KEY             $05
         DW      $00F2            ;  .    SCENERY GOLD            $06
         DW      $00F4            ;  .    DARK TOWER              $07
         DW      $0080            ;  .    DO NOTHING BOX          $08
         DW      $0082            ;  .    BOX - TREASURE          $09
         DW      $0084            ;  .    BOX - BRIGANDS          $0A
         DW      $0086            ;  .    BOX - MAGICIAN          $0B
         DW      $0088            ;  .    BOX - FOG               $0C
         DW      $008A            ;  .    BOX - PLAGUE            $0D
         DW      $00E0            ;  .    SCENERY PLAGUE          $0E
         DW      $00E2            ;  .    SCENERY FOG             $0F
;
;
PTREE0   DB      $1C              ;  DEAD TREE (DIFFY)
         DW      $F810            ;  .
         DW      $0CFA            ;  .
         DW      $380C            ;  .
         DW      $1820            ;  .
         DW      $18F4            ;  .
         DW      $1020            ;  .
         DW      $F810            ;  .
         DW      $08F0            ;  .
         DW      $0808            ;  .
         DW      $FC08            ;  .
         DW      $04F8            ;  .
         DW      $F8F8            ;  .
         DW      $F2D4            ;  .
         DW      $E808            ;  .
         DW      $F0E0            ;  .
         DW      $20E0            ;  .
         DW      $1810            ;  .
         DW      $10F0            ;  .
         DW      $F00C            ;  .
         DW      $E6EC            ;  .
         DW      $F00C            ;  .
         DW      $F0F0            ;  .
         DW      $08F8            ;  .
         DW      $F808            ;  .
         DW      $0A14            ;  .
         DW      $F00E            ;  .
         DW      $D0F0            ;  .
         DW      $E0E0            ;  .
         DW      $1834            ;  .
;
;
PTREE1   DB      $0A              ;  PINE TREE (DIFFY)
         DW      $2300            ;  .
         DW      $00DD            ;  .
         DW      $2D0F            ;  .
         DW      $00FB            ;  .
         DW      $370A            ;  .
         DW      $00FB            ;  .
         DW      $6414            ;  .
         DW      $8319            ;  .
         DW      $00F6            ;  .
         DW      $A614            ;  .
         DW      $00DD            ;  .
;
;
PTREE2   DB      $15              ;  FLESHED-OUT DEAD TREE (DIFFY)
         DW      $F810            ;  .
         DW      $0CFA            ;  .
         DW      $380C            ;  .
         DW      $1016            ;  .
         DW      $E020            ;  .
         DW      $4030            ;  .
         DW      $3000            ;  .
         DW      $30A0            ;  .
         DW      $00C0            ;  .
         DW      $C0D0            ;  .
         DW      $D0F8            ;  .
         DW      $D030            ;  .
         DW      $2C30            ;  .
         DW      $F426            ;  .
         DW      $05F0            ;  .
         DW      $F4EC            ;  .
         DW      $0AF4            ;  .
         DW      $F8F8            ;  .
         DW      $F80A            ;  .
         DW      $D0F0            ;  .
         DW      $E0E0            ;  .
         DW      $1834            ;  .
;
;
PTREE3   DB      $00              ;  ELM TREE (PACKET)
         DB      $FF,$50,$00      ;  .
         DB      $FF,$4A,$28      ;  .
         DB      $00,$D8,$E2      ;  .
         DB      $FF,$1E,$E2      ;  .
         DB      $00,$BF,$14      ;  .
         DB      $FF,$00,$DD      ;  .
         DB      $00,$0F,$F1      ;  .
         DB      $FF,$50,$0F      ;  .
         DB      $00,$18,$EC      ;  .
         DB      $FF,$30,$28      ;  .
         DB      $FF,$F6,$20      ;  .
         DB      $00,$EA,$20      ;  .
         DB      $FF,$E8,$1E      ;  .
         DB      $FF,$E0,$F6      ;  .
         DB      $00,$E8,$F1      ;  .
         DB      $FF,$C8,$C8      ;  .
         DB      $01              ;  .
;
;
;
;
PFLAME   DB      $08              ;  FLAMOID (DUFFY)
         DW      $0200            ;  .
         DW      $03FB            ;  .
         DW      $FB03            ;  .
         DW      $FBFD            ;  .
         DW      $0305            ;  .
         DW      $FD05            ;  .
         DW      $05FD            ;  .
         DW      $0503            ;  .
         DW      $FCFA            ;  .
;
;
;
;
DTWR1    DB      $11              ;  DARK TOWER - RIGHT HALF (DIFFY)
         DW      $FC06            ;  .
         DW      $EE02            ;  .
         DW      $0208            ;  .
         DW      $0400            ;  .
         DW      $0208            ;  .
         DW      $F810            ;  .
         DW      $08F0            ;  .
         DW      $FFFC            ;  .
         DW      $37FA            ;  .
         DW      $06F2            ;  .
         DW      $FAF2            ;  .
         DW      $06FE            ;  .
         DW      $0A12            ;  .
         DW      $F6FE            ;  .
         DW      $D200            ;  .
         DW      $FC05            ;  .
         DW      $F001            ;  .
         DW      $00F2            ;  .
;
;
DTWR2    DB      $10              ;  DARK TOWER - LEFT HALF (DIFFY)
         DW      $FCFA            ;  .
         DW      $EEFE            ;  .
         DW      $02FA            ;  .
         DW      $0AFC            ;  .
         DW      $0402            ;  .
         DW      $02FE            ;  .
         DW      $FCFC            ;  .
         DW      $F8FC            ;  .
         DW      $FCF0            ;  .
         DW      $0410            ;  .
         DW      $0804            ;  .
         DW      $0303            ;  .
         DW      $2D05            ;  .
         DW      $06FE            ;  .
         DW      $0A12            ;  .
         DW      $F60E            ;  .
         DW      $FAFE            ;  .
;
;
TWRDR1   DB      $08              ;  TOWER DOOR - FRAME & DOOR (DIFFY)
         DW      $4C06            ;  .
         DW      $101C            ;  .
         DW      $F01E            ;  .
         DW      $B408            ;  .
         DW      $4CF8            ;  .
         DW      $10E2            ;  .
         DW      $F01A            ;  .
         DW      $B806            ;  .
         DW      $00BE            ;  .
;
;
TWRDR2   DB      $00              ;  TOWER DOOR - KEY HOLE (PACKET)
         DB      $FF,$FE,$FE      ;  .
         DB      $FF,$FE,$01      ;  .
         DB      $FF,$FC,$FF      ;  .
         DB      $FF,$00,$04      ;  .
         DB      $FF,$04,$FF      ;  .
         DB      $FF,$02,$01      ;  .
         DB      $FF,$02,$FE      ;  .
         DB      $00,$02,$FE      ;  .
         DB      $FF,$FE,$FE      ;  .
         DB      $FF,$F8,$00      ;  .
         DB      $FF,$FE,$02      ;  .
         DB      $FF,$00,$04      ;  .
         DB      $FF,$02,$02      ;  .
         DB      $FF,$08,$00      ;  .
         DB      $FF,$02,$FE      ;  .
         DB      $FF,$00,$FC      ;  .
         DB      $01              ;  .
;
;
PKEY     DB      $12              ;  KEY SYMBOL (DIFFY)
         DW      $0014            ;  .
         DW      $FA02            ;  .
         DW      $000C            ;  .
         DW      $0804            ;  .
         DW      $08FC            ;  .
         DW      $00F4            ;  .
         DW      $FAFE            ;  .
         DW      $00DE            ;  .
         DW      $F800            ;  .
         DW      $0002            ;  .
         DW      $0400            ;  .
         DW      $0004            ;  .
         DW      $FC00            ;  .
         DW      $0002            ;  .
         DW      $0200            ;  .
         DW      $0004            ;  .
         DW      $FE00            ;  .
         DW      $0002            ;  .
         DW      $0400            ;  .
;
;
PPOINT   DB      $06              ;  KEY RIDDLE POINTER (DIFFY)
         DW      $D020            ;  .
         DW      $00F0            ;  .
         DW      $E000            ;  .
         DW      $00E0            ;  .
         DW      $2000            ;  .
         DW      $00F0            ;  .
         DW      $3020            ;  .
;
;
APOINT   DB      $C1              ;  KEY RIDDLE POINTER 'X-AXIS' POSITION
         DB      $EF              ;  .
         DB      $1C              ;  .
         DB      $4C              ;  .
;
;
PGOLD    DB      $0E              ;  SCENERY BAG OF GOLD (DIFFY)
         DW      $0AF6            ;  .
         DW      $0C00            ;  .
         DW      $0E0E            ;  .
         DW      $0AF2            ;  .
         DW      $FE0A            ;  .
         DW      $0604            ;  .
         DW      $FC06            ;  .
         DW      $060A            ;  .
         DW      $F0FC            ;  .
         DW      $00F4            ;  .
         DW      $000C            ;  .
         DW      $F212            ;  .
         DW      $F800            ;  .
         DW      $F2F4            ;  .
         DW      $00EA            ;  .
;
;
;
;
;  PEDOMETER MESSAGES
;  ==================
;
MPED     DW      MPED0            ;  LOOK-ANGLE = $00 - $07
         DW      MPED1            ;  .            $08 - $0F
         DW      MPED2            ;  .            $10 - $17
         DW      MPED3            ;  .            $18 - $1F
         DW      MPED4            ;  .            $20 - $27
         DW      MPED5            ;  .            $28 - $2F
         DW      MPED6            ;  .            $30 - $37
         DW      MPED7            ;  .            $38 - $3F
;
;
MPED0    DB      '  N',$80        ;  LOOK-ANGLE = $00 - $07
MPED1    DB      ' NW',$80        ;  LOOK-ANGLE = $08 - $0F
MPED2    DB      '  W',$80        ;  LOOK-ANGLE = $10 - $17
MPED3    DB      ' SW',$80        ;  LOOK-ANGLE = $18 - $1F
MPED4    DB      '  S',$80        ;  LOOK-ANGLE = $20 - $27
MPED5    DB      ' SE',$80        ;  LOOK-ANGLE = $28 - $2F
MPED6    DB      '  E',$80        ;  LOOK-ANGLE = $30 - $37
MPED7    DB      ' NE',$80        ;  LOOK-ANGLE = $38 - $3F
;
;
;
;
;  BRIGAND INITIALIZATION TABLE
;  ============================
;
BRGINT   DB      $01              ;  RIGHT - FRONT BRIGAND
         DB      $00              ;  .    BRIGAND ANIMATION TIMER
         DW      PRBRG1           ;  .    PARAMETER POINTER
;
         DB      $01              ;  RIGHT - MIDDLE BRIGAND
         DB      $00              ;  .    BRIGAND ANIMATION TIMER
         DW      PRBRG2           ;  .    PARAMETER POINTER
;
         DB      $01              ;  RIGHT - REAR BRIGAND
         DB      $00              ;  .    BRIGAND ANIMATION TIMER
         DW      PRBRG3           ;  .    PARAMETER POINTER
;
         DB      $01              ;  LEFT - FRONT BRIGAND
         DB      $00              ;  .    BRIGAND ANIMATION TIMER
         DW      PRBRG4           ;  .    PARAMETER POINTER
;
         DB      $01              ;  LEFT - MIDDLE BRIGAND
         DB      $00              ;  .    BRIGAND ANIMATION TIMER
         DW      PRBRG5           ;  .    PARAMETER POINTER
;
         DB      $01              ;  LEFT - REAR BRIGAND
         DB      $00              ;  .    BRIGAND ANIMATION TIMER
         DW      PRBRG6           ;  .    PARAMETER POINTER
;
BRGEND   EQU     *                ;  END OF BRIGAND INITIALIZATION TABLE
;
;
;
;
;  BRIGAND ANIMATION PARAMETERS
;  ============================
;
;        RIGHT - FRONT BRIGAND
;        ---------------------
;
PRBRG1   DW      $D000            ;  .    BRIGAND ABSOLUTE 'Y' POSITION
         DW      $4000            ;  .    BRIGAND ABSOLUTE 'X' POSITION
         DW      $5200            ;  .    RELATIVE 'Y' THROWING POSITION
         DW      $0C00            ;  .    RELATIVE 'X' THROWING POSITION
         DB      $F3              ;  .    RELATIVE 'Z' THROWING POSITION
         DW      $5200            ;  .    RELATIVE 'Y' BOX CENTER
         DW      $1500            ;  .    RELATIVE 'X' BOX CENTER
         DB      $00              ;  .    BRIGAND DRAWING FLAG
         DB      $28              ;  .    CURRENT BRIGAND SIZE
         DW      $0306            ;  .    CURRENT COLLISION BOX FOR BRIGAND
;
;
;        RIGHT - MIDDLE BRIGAND
;        ----------------------
;
PRBRG2   DW      $DC00            ;  .    BRIGAND ABSOLUTE 'Y' POSITION
         DW      $3000            ;  .    BRIGAND ABSOLUTE 'X' POSITION
         DW      $5E00            ;  .    RELATIVE 'Y' THROWING POSITION
         DW      $0800            ;  .    RELATIVE 'X' THROWING POSITION
         DB      $F8              ;  .    RELATIVE 'Z' THROWING POSITION
         DW      $5E00            ;  .    RELATIVE 'Y' BOX CENTER
         DW      $1200            ;  .    RELATIVE 'X' BOX CENTER
         DB      $00              ;  .    BRIGAND DRAWING FLAG
         DB      $20              ;  .    CURRENT BRIGAND SIZE
         DW      $0306            ;  .    CURRENT COLLISION BOX FOR BRIGAND
;
;
;        RIGHT - REAR BRIGAND
;        --------------------
;
PRBRG3   DW      $E200            ;  .    BRIGAND ABSOLUTE 'Y' POSITION
         DW      $2600            ;  .    BRIGAND ABSOLUTE 'X' POSITION
         DW      $6600            ;  .    RELATIVE 'Y' THROWING POSITION
         DW      $0500            ;  .    RELATIVE 'X' THROWING POSITION
         DB      $F8              ;  .    RELATIVE 'Z' THROWING POSITION
         DW      $6600            ;  .    RELATIVE 'Y' BOX CENTER
         DW      $0E00            ;  .    RELATIVE 'X' BOX CENTER
         DB      $00              ;  .    BRIGAND DRAWING FLAG
         DB      $18              ;  .    CURRENT BRIGAND SIZE
         DW      $0306            ;  .    CURRENT COLLISION BOX FOR BRIGAND
;
;
;        LEFT - FRONT BRIGAND
;        --------------------
;
PRBRG4   DW      $D000            ;  .    BRIGAND ABSOLUTE 'Y' POSITION
         DW      $C000            ;  .    BRIGAND ABSOLUTE 'X' POSITION
         DW      $5200            ;  .    RELATIVE 'Y' THROWING POSITION
         DW      $F500            ;  .    RELATIVE 'X' THROWING POSITION
         DB      $F3              ;  .    RELATIVE 'Z' THROWING POSITION
         DW      $5200            ;  .    RELATIVE 'Y' BOX CENTER
         DW      $EC00            ;  .    RELATIVE 'X' BOX CENTER
         DB      $01              ;  .    BRIGAND DRAWING FLAG
         DB      $28              ;  .    CURRENT BRIGAND SIZE
         DW      $0306            ;  .    CURRENT COLLISION BOX FOR BRIGAND
;
;
;        LEFT - MIDDLE BRIGAND
;        ---------------------
;
PRBRG5   DW      $DC00            ;  .    BRIGAND ABSOLUTE 'Y' POSITION
         DW      $D000            ;  .    BRIGAND ABSOLUTE 'X' POSITION
         DW      $5E00            ;  .    RELATIVE 'Y' THROWING POSITION
         DW      $F800            ;  .    RELATIVE 'X' THROWING POSITION
         DB      $F8              ;  .    RELATIVE 'Z' THROWING POSITION
         DW      $5E00            ;  .    RELATIVE 'Y' BOX CENTER
         DW      $EE00            ;  .    RELATIVE 'X' BOX CENTER
         DB      $01              ;  .    BRIGAND DRAWING FLAG
         DB      $20              ;  .    CURRENT BRIGAND SIZE
         DW      $0306            ;  .    CURRENT COLLISION BOX FOR BRIGAND
;
;
;        LEFT - REAR BRIGAND
;        -------------------
;
PRBRG6   DW      $E200            ;  .    BRIGAND ABSOLUTE 'Y' POSITION
         DW      $DD00            ;  .    BRIGAND ABSOLUTE 'X' POSITION
         DW      $6600            ;  .    RELATIVE 'Y' THROWING POSITION
         DW      $FB00            ;  .    RELATIVE 'X' THROWING POSITION
         DB      $F8              ;  .    RELATIVE 'Z' THROWING POSITION
         DW      $6600            ;  .    RELATIVE 'Y' BOX CENTER
         DW      $F100            ;  .    RELATIVE 'X' BOX CENTER
         DB      $01              ;  .    BRIGAND DRAWING FLAG
         DB      $18              ;  .    CURRENT BRIGAND SIZE
         DW      $0306            ;  .    CURRENT COLLISION BOX FOR BRIGAND
;
;
;
;
;  RASTER ZOOM TABLE
;  =================
;
RSTZOM   DW      $FC04
         DW      $FC06
         DW      $FC08
         DW      $FB0C
         DW      $FB0D
         DW      $FA0D
         DW      $FA10
         DW      $F914
         DW      $F815
         DW      $F717
         DW      $F618
         DW      $F619
         DW      $F61B
         DW      $F51D
         DW      $F51F
         DW      $F421
         DW      $F421
;
;
;
;
;  TREASURE SELECTION TABLES
;  =========================
;
TRSOPT   DW      FNDGKY           ;  INITIALIZATION TREASURE SELECTION TABLE
         DW      FNDSKY           ;  .
         DW      FNDBZK           ;  .
         DW      FNDBSK           ;  .
         DW      FNDBSK           ;  .
         DW      FNDBZK           ;  .
         DW      FNDSKY           ;  .
         DW      FNDGKY           ;  .
;
TRSBOX   DW      FNDGLD           ;  TREASURE BOX SELECTION TABLE
         DW      FNDGLD           ;  .
         DW      FNDGLD           ;  .
         DW      FNDGLD           ;  .
         DW      FNDWAR           ;  .
         DW      FNDGLD           ;  .
         DW      FNDGLD           ;  .
         DW      FNDWAR           ;  .
;
TRSBRG   DW      FNDGLD           ;  BRIGAND TREASURE SELECTION TABLE
         DW      FNDGLD           ;  .
         DW      FNDGLD           ;  .
         DW      FNDWAR           ;  .
         DW      0                ;  .
         DW      FNDGLD           ;  .
         DW      FNDGLD           ;  .
         DW      FNDGLD           ;  .
;
;
;
;
;  TREASURE MESSAGES
;  =================
;
M_TRES   DB      'PLAYER INVENTORY',$80
;
;
TRSMSG   DW      M_NTHIN          ;  TREASURE MESSAGE LOOK-UP TABLE      $00
         DW      M_GKEY           ;  .                                   $02
         DW      M_SKEY           ;  .                                   $04
         DW      M_ZKEY           ;  .                                   $06
         DW      M_BKEY           ;  .                                   $08
         DW      M_CRWN           ;  .                                   $0A
         DW      M_SCT            ;  .                                   $0C
         DW      M_HLR            ;  .                                   $0E
         DW      NGOLD            ;  .                                   $10
         DW      NMEN             ;  .                                   $12
;
;
TRSVCT   DW      $7FF4            ;  TREASURE MESSAGE ZOOM VECTOR VALUES $00
         DW      $7FF0            ;  .                                   $02
         DW      $7FEC            ;  .                                   $04
         DW      $7FEC            ;  .                                   $06
         DW      $7FEC            ;  .                                   $08
         DW      $7FE4            ;  .                                   $0A
         DW      $7FF4            ;  .                                   $0C
         DW      $7FF4            ;  .                                   $0E
         DW      $7FE4            ;  .                                   $10
         DW      $7FE4            ;  .                                   $12
;
;
;
M_GKEY   DB      'GOLD KEY',$80
;
M_SKEY   DB      'SILVER KEY',$80
;
M_ZKEY   DB      'BRONZE KEY',$80
;
M_BKEY   DB      'BRASS KEY',$80
;
M_CRWN   DB      'CRYSTAL CROWN',$80
;
M_SCT    DB      'SCOUT',$80
;
M_HLR    DB      'HEALER',$80
;
;
M_PLAY   DB      'YOUR SCORE IS      0',$80
;
M_BAGS   DB      $20,$20,$20
M_NGLD   DB      $32,$20
         DB      'BAGS OF GOLD',$80
;
M_MEN    DB      $20,$20,$20
         DB      $36,$20
         DB      'RESERVE TROOPS',$80
;
M_NMEN   DB      $30,$20
         DB      'NEW WARRIOR',$80
;
M_NTHIN  DB      'BE GONE',$80
;
;
;
;
;  RIDDLE OF KEYS MESSAGES
;  =======================
;
M_RIDL   DW      $F834
         DW      $78C0
         DB      'RIDDLE OF THE KEYS',$80
         DB      0
;
;
;
RK_TBL   DW      RK_KEY           ;  KEY LOOK-UP TABLE
         DW      RK_GLD           ;  .
         DW      RK_SLV           ;  .
         DW      RK_BRZ           ;  .
         DW      RK_BRS           ;  .
;
;
;
RK_KEY   DB      'KEY ? ',$80
;
RK_GLD   DB      'GOLD  ',$80
;
RK_SLV   DB      'SILVER',$80
;
RK_BRZ   DB      'BRONZE',$80
;
RK_BRS   DB      'BRASS ',$80
;
;
;
RK_DON   DW      $F840
         DW      $38E4
         DB      'ENTER,',$80
         DW      $FA40
         DW      $18D2
         DB      'VICTORIOUS',$80
         DW      $FA40
         DW      $04DE
         DB      'WARRIOR',$80
         DB      0
;
;
;
;
;  MISC. RASTER MESSAGES
;  =====================
;
M_END    DW      $FA38
         DW      $B0D8
         DB      'GAME OVER',$80
         DB      0
;
M_FRST   DW      $FA38
         DW      $50D8
         DB      'YOUR FIRST',$80
         DW      $FA38
         DW      $40E8
         DB      'WARRIOR',$80
         DB      0
;
M_NWAR   DW      $FA38
         DW      $50D8
         DB      'REPLACEMENT',$80
         DW      $FA38
         DW      $40E8
         DB      'WARRIOR',$80
         DB      0
 db $bd ; Malban - for whatever reason a stupid filler
;
;
;
;         MSG     'END OF UPPER ROM      = ',*
;
;
;         IF      L.PCK = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
