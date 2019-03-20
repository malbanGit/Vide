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
PBLST1   DB      $03              ;  BLASTER SECTION (DIFFY)
         DW      $1600            ;  .
         DW      $FEFC            ;  .
         DW      $E8FC            ;  .
         DW      $04F0            ;  .
;
PBLST2   DB      $03              ;  BLASTER SECTION (DIFFY)
         DW      $1600            ;  .
         DW      $FE04            ;  .
         DW      $E804            ;  .
         DW      $0410            ;  .
;
PBLST3   DB      $05              ;  BLASTER SECTION (DIFFY)
         DW      $FCF8            ;  .
         DW      $FA00            ;  .
         DW      $FC08            ;  .
         DW      $0408            ;  .
         DW      $0600            ;  .
         DW      $04F8            ;  .
;
PBLST4   DB      $84              ;  BLASTER SECTION (DUFFY)
         DW      $F6F8            ;  .
         DW      $04F0            ;  .
         DW      $0600            ;  .
         DW      $1E07            ;  .
         DW      $0004            ;  .
;
PBLST5   DB      $84              ;  BLASTER SECTION (DUFFY)
         DW      $F608            ;  .
         DW      $0410            ;  .
         DW      $0600            ;  .
         DW      $1EF9            ;  .
         DW      $00FC            ;  .
;
PBLST6   DB      $84              ;  BLASTER SECTION (DUFFY)
         DW      $02F9            ;  .
         DW      $02F6            ;  .
         DW      $1A04            ;  .
         DW      $FC00            ;  .
         DW      $E9FE            ;  .
;
PBLST7   DB      $84              ;  BLASTER SECTION (DUFFY)
         DW      $0207            ;  .
         DW      $020A            ;  .
         DW      $1AFC            ;  .
         DW      $FC00            ;  .
         DW      $E902            ;  .
;
;
;
EBLST1   DB      $0C              ;  BLASTER EXPLOSION SEGMENT (DIFFY)
         DW      $1600            ;  .
         DW      $FEFC            ;  .
         DW      $E8FC            ;  .
         DW      $0408            ;  .
         DW      $FC08            ;  .
         DW      $FA00            ;  .
         DW      $FCF8            ;  .
         DW      $04F8            ;  .
         DW      $0600            ;  .
         DW      $0408            ;  .
         DW      $1600            ;  .
         DW      $FE04            ;  .
         DW      $E804            ;  .
;
EBLST2   DB      $09              ;  BLASTER EXPLOSION SEGMENT (DUFFY)
         DW      $FCF8            ;  .
         DW      $FA00            ;  .
         DW      $04F0            ;  .
         DW      $0600            ;  .
         DW      $FC10            ;  .
         DW      $0601            ;  .
         DW      $02F6            ;  .
         DW      $1A04            ;  .
         DW      $00FC            ;  .
         DW      $E2F9            ;  .
;
EBLST3   DB      $09              ;  BLASTER EXPLOSION SEGMENT (DUFFY)
         DW      $FC08            ;  .
         DW      $FA00            ;  .
         DW      $0410            ;  .
         DW      $0600            ;  .
         DW      $FCF0            ;  .
         DW      $06FF            ;  .
         DW      $020A            ;  .
         DW      $1AFC            ;  .
         DW      $0004            ;  .
         DW      $E207            ;  .
;
;
;
PCRAB1   DB      $0C              ;  CRAB GUARDIAN - FRAME #1 (DUFFY)
         DW      $00F9            ;  .
         DW      $000E            ;  .
         DW      $F907            ;  .
         DW      $F4FE            ;  .
         DW      $FCF6            ;  .
         DW      $0608            ;  .
         DW      $07FE            ;  .
         DW      $00ED            ;  .
         DW      $F7FA            ;  .
         DW      $FA04            ;  .
         DW      $06FA            ;  .
         DW      $0C02            ;  .
         DW      $0608            ;  .
;
PCRAB2   DB      $0C              ;  CRAB GUARDIAN - FRAME #2 (DUFFY)
         DW      $00F9            ;  .
         DW      $000E            ;  .
         DW      $F907            ;  .
         DW      $F4FE            ;  .
         DW      $FCF6            ;  .
         DW      $0608            ;  .
         DW      $07FE            ;  .
         DW      $00ED            ;  .
         DW      $F7FE            ;  .
         DW      $FB08            ;  .
         DW      $04F6            ;  .
         DW      $0DFE            ;  .
         DW      $0608            ;  .
;
PCRAB3   DB      $0C              ;  CRAB GUARDIAN - FRAME #3 (DUFFY)
         DW      $00F9            ;  .
         DW      $000E            ;  .
         DW      $F907            ;  .
         DW      $F402            ;  .
         DW      $FAFA            ;  .
         DW      $0604            ;  .
         DW      $09FA            ;  .
         DW      $00ED            ;  .
         DW      $F7FE            ;  .
         DW      $FB08            ;  .
         DW      $04F6            ;  .
         DW      $0DFE            ;  .
         DW      $0608            ;  .
;
PCRAB4   DB      $0C              ;  CRAB GUARDIAN - FRAME #4 (DUFFY)
         DW      $00F9            ;  .
         DW      $000E            ;  .
         DW      $F907            ;  .
         DW      $F402            ;  .
         DW      $FAFA            ;  .
         DW      $0604            ;  .
         DW      $09FA            ;  .
         DW      $00ED            ;  .
         DW      $F7FA            ;  .
         DW      $FA04            ;  .
         DW      $06FA            ;  .
         DW      $0C02            ;  .
         DW      $0608            ;  .
;
;
PSPDR1   DB      $09              ;  SPIDER GUARDIAN - FRAME #1 (DUFFY)
         DW      $F500            ;  .
         DW      $0A0B            ;  .
         DW      $EE03            ;  .
         DW      $1A02            ;  .
         DW      $F4F2            ;  .
         DW      $00FA            ;  .
         DW      $0CF2            ;  .
         DW      $E602            ;  .
         DW      $1203            ;  .
         DW      $F60B            ;  .
;
PSPDR2   DB      $09              ;  SPIDER GUARDIAN - FRAME #2 (DUFFY)
         DW      $EF00            ;  .
         DW      $100B            ;  .
         DW      $EE03            ;  .
         DW      $1A02            ;  .
         DW      $F0F2            ;  .
         DW      $00FA            ;  .
         DW      $10F2            ;  .
         DW      $E602            ;  .
         DW      $1203            ;  .
         DW      $F10B            ;  .
;
PSPDR3   DB      $09              ;  SPIDER GUARDIAN - FRAME #3 (DUFFY)
         DW      $FA00            ;  .
         DW      $050B            ;  .
         DW      $EE03            ;  .
         DW      $1A02            ;  .
         DW      $F8F2            ;  .
         DW      $00FA            ;  .
         DW      $07F2            ;  .
         DW      $E602            ;  .
         DW      $1203            ;  .
         DW      $FC0B            ;  .
;
PSPDR4   DB      $09              ;  SPIDER GUARDIAN - FRAME #4 (DUFFY)
         DW      $0000            ;  .
         DW      $FF0B            ;  .
         DW      $EE03            ;  .
         DW      $1A02            ;  .
         DW      $FEF2            ;  .
         DW      $00FA            ;  .
         DW      $02F2            ;  .
         DW      $E602            ;  .
         DW      $1203            ;  .
         DW      $010B            ;  .
;
;
PSTMP1   DB      $11              ;  STOMPER GUARDIAN - FRAME #1 (DUFFY)
         DW      $0600            ;  .
         DW      $0804            ;  .
         DW      $FB00            ;  .
         DW      $FE05            ;  .
         DW      $EA02            ;  .
         DW      $FE04            ;  .
         DW      $FD00            ;  .
         DW      $00F8            ;  .
         DW      $08FB            ;  .
         DW      $00FC            ;  .
         DW      $F8FB            ;  .
         DW      $00F8            ;  .
         DW      $0300            ;  .
         DW      $0204            ;  .
         DW      $1402            ;  .
         DW      $0205            ;  .
         DW      $0500            ;  .
         DW      $F804            ;  .
;
PSTMP2   DB      $11              ;  STOMPER GUARDIAN - FRAME #2 (DUFFY)
         DW      $0600            ;  .
         DW      $0804            ;  .
         DW      $FB00            ;  .
         DW      $FE05            ;  .
         DW      $EE00            ;  .
         DW      $FE04            ;  .
         DW      $FD00            ;  .
         DW      $00F8            ;  .
         DW      $04FD            ;  .
         DW      $00FC            ;  .
         DW      $F8FB            ;  .
         DW      $00F8            ;  .
         DW      $0300            ;  .
         DW      $0204            ;  .
         DW      $1402            ;  .
         DW      $0205            ;  .
         DW      $0500            ;  .
         DW      $F804            ;  .
;
PSTMP3   DB      $11              ;  STOMPER GUARDIAN - FRAME #3 (DUFFY)
         DW      $0600            ;  .
         DW      $0804            ;  .
         DW      $FB00            ;  .
         DW      $FE05            ;  .
         DW      $EE00            ;  .
         DW      $FE04            ;  .
         DW      $FD00            ;  .
         DW      $00F8            ;  .
         DW      $04FD            ;  .
         DW      $00FC            ;  .
         DW      $FCFD            ;  .
         DW      $00F8            ;  .
         DW      $0300            ;  .
         DW      $0204            ;  .
         DW      $1000            ;  .
         DW      $0205            ;  .
         DW      $0500            ;  .
         DW      $F804            ;  .
;
PSTMP4   DB      $11              ;  STOMPER GUARDIAN - FRAME #4 (DUFFY)
         DW      $0600            ;  .
         DW      $0804            ;  .
         DW      $FB00            ;  .
         DW      $FE05            ;  .
         DW      $EA02            ;  .
         DW      $FE04            ;  .
         DW      $FD00            ;  .
         DW      $00F8            ;  .
         DW      $08FB            ;  .
         DW      $00FC            ;  .
         DW      $FCFD            ;  .
         DW      $00F8            ;  .
         DW      $0300            ;  .
         DW      $0204            ;  .
         DW      $1200            ;  .
         DW      $0205            ;  .
         DW      $0500            ;  .
         DW      $F804            ;  .
;
;
;
;
ECRAB1   DB      $06              ;  CRAB DISMEMBERMENT - BODY (DUFFY)
         DW      $00F9            ;  .
         DW      $000E            ;  .
         DW      $F907            ;  .
         DW      $FDFA            ;  .
         DW      $00ED            ;  .
         DW      $02FA            ;  .
         DW      $0608            ;  .
;
ECRAB2   DB      $05              ;  CRAB DISMEMBERMENT - RIGHT LEG (DUFFY)
         DW      $F80E            ;  .
         DW      $F4FE            ;  .
         DW      $FCF6            ;  .
         DW      $0608            ;  .
         DW      $07FE            ;  .
         DW      $0205            ;  .
;
ECRAB3   DB      $05              ;  CRAB DISMEMBERMENT - LEFT LEG (DUFFY)
         DW      $F6F6            ;  .
         DW      $F7FA            ;  .
         DW      $FA04            ;  .
         DW      $06FA            ;  .
         DW      $0C02            ;  .
         DW      $FB05            ;  .
;
;
ESPDR1   DB      $07              ;  SPIDER DISMEMBERMENT - BODY (DUFFY)
         DW      $F500            ;  .
         DW      $0A0B            ;  .
         DW      $0705            ;  .
         DW      $F4F2            ;  .
         DW      $00FA            ;  .
         DW      $0CF2            ;  .
         DW      $F704            ;  .
         DW      $F60B            ;  .
;
ESPDR2   DB      $03              ;  SPIDER DISMEMBERMENT - RIGHT LEG (DUFFY)
         DW      $FF0B            ;  .
         DW      $E802            ;  .
         DW      $2003            ;  .
         DW      $F8FA            ;  .
;
ESPDR3   DB      $03              ;  SPIDER DISMEMBERMENT - LEFT LEG (DUFFY)
         DW      $06EF            ;  .
         DW      $E003            ;  .
         DW      $1802            ;  .
         DW      $08FA            ;  .
;
;
ESTMP1   DB      $07              ;  STOMPER DISMEMBERMENT - BODY (DUFFY)
         DW      $0E00            ;  .
         DW      $FC02            ;  .
         DW      $FD07            ;  .
         DW      $ECF9            ;  .
         DW      $00F9            ;  .
         DW      $14FA            ;  .
         DW      $0207            ;  .
         DW      $0402            ;  .
;   
ESTMP2   DB      $06              ;  STOMPER DISMEMBERMENT - RIGHT LEG (DUFFY)
         DW      $0609            ;  .
         DW      $EA02            ;  .
         DW      $FE04            ;  .
         DW      $FD00            ;  .
         DW      $00F8            ;  .
         DW      $08FB            ;  .
         DW      $1205            ;  .
;
ESTMP3   DB      $06              ;  STOMPER DISMEMBERMENT - LEFT LEG (DUFFY)
         DW      $F4FD            ;  .
         DW      $F8FB            ;  .
         DW      $00F8            ;  .
         DW      $0300            ;  .
         DW      $0104            ;  .
         DW      $1802            ;  .
         DW      $EA05            ;  .
;
;
;
PKLL01   DB      $0B              ;  KILLER LEG SEGMENTS - FRAME #1
         DW      $FC06            ;  .
         DW      $F604            ;  .
         DW      $FE06            ;  .
         DW      $FC00            ;  .
         DW      $00F8            ;  .
         DW      $09FB            ;  .
         DW      $00FA            ;  .
         DW      $F7FB            ;  .
         DW      $00F8            ;  .
         DW      $0400            ;  .
         DW      $0206            ;  .
         DW      $0A04            ;  .
;
PKLL02   DB      $0B              ;  KILLER LEG SEGMENTS - FRAME #2
         DW      $FC06            ;  .
         DW      $F604            ;  .
         DW      $FE06            ;  .
         DW      $FC00            ;  .
         DW      $00F8            ;  .
         DW      $09FB            ;  .
         DW      $00FA            ;  .
         DW      $FCFD            ;  .
         DW      $00F8            ;  .
         DW      $0400            ;  .
         DW      $0206            ;  .
         DW      $0502            ;  .
;
PKLL03   DB      $0B              ;  KILLER LEG SEGMENTS - FRAME #3
         DW      $FC06            ;  .
         DW      $FA02            ;  .
         DW      $FE06            ;  .
         DW      $FC00            ;  .
         DW      $00F8            ;  .
         DW      $05FD            ;  .
         DW      $00FA            ;  .
         DW      $FCFD            ;  .
         DW      $00F8            ;  .
         DW      $0400            ;  .
         DW      $0206            ;  .
         DW      $0502            ;  .
;
PKLL04   DB      $0B              ;  KILLER LEG SEGMENTS - FRAME #4
         DW      $FC06            ;  .
         DW      $FA02            ;  .
         DW      $FE06            ;  .
         DW      $FC00            ;  .
         DW      $00F8            ;  .
         DW      $05FD            ;  .
         DW      $00FA            ;  .
         DW      $F7FB            ;  .
         DW      $00F8            ;  .
         DW      $0400            ;  .
         DW      $0206            ;  .
         DW      $0A04            ;  .
;
;
PKLL11   DB      $0A              ;  KILLER LEFT ARM SEGMENT - FRAME #1
         DW      $FCFB            ;  .
         DW      $08FC            ;  .
         DW      $04F6            ;  .
         DW      $0804            ;  .
         DW      $0403            ;  .
         DW      $FDFF            ;  .
         DW      $0103            ;  .
         DW      $FCFC            ;  .
         DW      $FCFF            ;  .
         DW      $FE03            ;  .
         DW      $0207            ;  .
;
PKLL12   DB      $0A              ;  KILLER LEFT ARM SEGMENT - FRAME #2
         DW      $FCFB            ;  .
         DW      $08FC            ;  .
         DW      $02F6            ;  .
         DW      $08F8            ;  .
         DW      $04FE            ;  .
         DW      $FD03            ;  .
         DW      $0201            ;  .
         DW      $FD01            ;  .
         DW      $FC05            ;  .
         DW      $FE08            ;  .
         DW      $0207            ;  .
;
PKLL13   DB      $09              ;  KILLER LEFT ARM SEGMENT - FRAME #3
         DW      $FCFB            ;  .
         DW      $07FD            ;  .
         DW      $FEF8            ;  .
         DW      $FEFA            ;  .
         DW      $FDFD            ;  .
         DW      $0301            ;  .
         DW      $FEFC            ;  .
         DW      $0405            ;  .
         DW      $0408            ;  .
         DW      $040C            ;  .
;
PKLL14   DB      $08              ;  KILLER LEFT ARM SEGMENT - FRAME #4
         DW      $FCFB            ;  .
         DW      $07FE            ;  .
         DW      $F8FC            ;  .
         DW      $FE01            ;  .
         DW      $02FD            ;  .
         DW      $FDFE            ;  .
         DW      $0401            ;  .
         DW      $0A04            ;  .
         DW      $0306            ;  .
;
;
PKLL21   DB      $08              ;  KILLER RIGHT ARM SEGMENT - FRAME #1
         DW      $FC06            ;  .
         DW      $0702            ;  .
         DW      $F804            ;  .
         DW      $FEFF            ;  .
         DW      $0202            ;  .
         DW      $FD02            ;  .
         DW      $04FE            ;  .
         DW      $0AFC            ;  .
         DW      $03F8            ;  .
;
PKLL22   DB      $09
         DW      $FC06            ;  KILLER RIGHT ARM SEGMENT - FRAME #2
         DW      $0703            ;  .
         DW      $FE08            ;  .
         DW      $FE06            ;  .
         DW      $FD03            ;  .
         DW      $03FF            ;  .
         DW      $FE04            ;  .
         DW      $04FB            ;  .
         DW      $04F6            ;  .
         DW      $04F2            ;  .
;
PKLL23   DB      $0A              ;  KILLER RIGHT ARM SEGMENT - FRAME #3
         DW      $FC06            ;  .
         DW      $0804            ;  .
         DW      $020A            ;  .
         DW      $0808            ;  .
         DW      $0402            ;  .
         DW      $FDFD            ;  .
         DW      $02FF            ;  .
         DW      $FDFF            ;  .
         DW      $FCF8            ;  .
         DW      $FEF8            ;  .
         DW      $02F8            ;  .
;
PKLL24   DB      $0A              ;  KILLER RIGHT ARM SEGMENT - FRAME #4
         DW      $FC06            ;  .
         DW      $0804            ;  .
         DW      $040A            ;  .
         DW      $08FC            ;  .
         DW      $04FD            ;  .
         DW      $FD01            ;  .
         DW      $01FD            ;  .
         DW      $FC02            ;  .
         DW      $FC01            ;  .
         DW      $FEFA            ;  .
         DW      $02F9            ;  .
;
;
PKLL30   DB      $06              ;  KILLER HEAD SEGMENT - ALL FRAMES
         DW      $0E00            ;  .
         DW      $0202            ;  .
         DW      $FC02            ;  .
         DW      $FCFC            ;  .
         DW      $04FC            ;  .
         DW      $0402            ;  .
         DW      $FE02            ;  .
;
;
;
;
;==========================================================================JJH
;PSPIKE  DW      $0200            ;  CODE DELETED - REV. B CHANGES   ======JJH
;        DW      $03FB            ;  .                               ======JJH
;        DW      $FB03            ;  .                               ======JJH
;        DW      $FBFD            ;  .                               ======JJH
;        DW      $0305            ;  .                               ======JJH
;        DW      $FD05            ;  .                               ======JJH
;        DW      $05FD            ;  .                               ======JJH
;        DW      $0503            ;  .                               ======JJH
;        DW      $FCFA            ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
PSPIKE   DB      $08              ;  CODE ADDED - REV. B CHANGES     ======JJH
         DW      $0200            ;  .                               ======JJH
         DW      $03FB            ;  .                               ======JJH
         DW      $FB03            ;  .                               ======JJH
         DW      $FBFD            ;  .                               ======JJH
         DW      $0305            ;  .                               ======JJH
         DW      $FD05            ;  .                               ======JJH
         DW      $05FD            ;  .                               ======JJH
         DW      $0503            ;  .                               ======JJH
         DW      $FCFA            ;  .                               ======JJH
;==========================================================================JJH
;
;
;
;
PBRD01   DW      $FB00            ;  WAR-BIRD / LEFT - FRAME #1 (DUFFY)
         DW      $0804            ;  .
         DW      $00F8            ;  .
         DW      $00F4            ;  .
         DW      $FEF3            ;  .
         DW      $FDFD            ;  .
         DW      $0202            ;  .
         DW      $000C            ;  .
         DW      $FE0E            ;  .
;
PBRD02   DW      $FB00            ;  WAR-BIRD / RIGHT - FRAME #1 (DUFFY)
         DW      $08FC            ;  .
         DW      $0008            ;  .
         DW      $000C            ;  .
         DW      $FE0D            ;  .
         DW      $FD03            ;  .
         DW      $02FD            ;  .
         DW      $00F3            ;  .
         DW      $FEF1            ;  .
;
;
PBRD11   DW      $FB00            ;  WAR-BIRD / LEFT - FRAME #2 (DUFFY)
         DW      $0804            ;  .
         DW      $00F8            ;  .
         DW      $07F4            ;  .
         DW      $FAF3            ;  .
         DW      $FCFD            ;  .
         DW      $0303            ;  .
         DW      $040B            ;  .
         DW      $F80D            ;  .
;
PBRD12   DW      $FB00            ;  WAR-BIRD / RIGHT - FRAME #2 (DUFFY)
         DW      $08FC            ;  .
         DW      $0008            ;  .
         DW      $070C            ;  .
         DW      $FA0D            ;  .
         DW      $FC03            ;  .
         DW      $03FD            ;  .
         DW      $04F3            ;  .
         DW      $F8F1            ;  .
;
;
PBRD21   DW      $FB00            ;  WAR-BIRD / LEFT - FRAME #3 (DUFFY)
         DW      $0804            ;  .
         DW      $00F8            ;  .
         DW      $03F4            ;  .
         DW      $05F7            ;  .
         DW      $03FD            ;  .
         DW      $FC02            ;  .
         DW      $F908            ;  .
         DW      $FA0E            ;  .
;
PBRD22   DW      $FB00            ;  WAR-BIRD / RIGHT - FRAME #3 (DUFFY)
         DW      $08FC            ;  .
         DW      $0008            ;  .
         DW      $030C            ;  .
         DW      $0509            ;  .
         DW      $0302            ;  .
         DW      $FCFE            ;  .
         DW      $F9F8            ;  .
         DW      $FAF1            ;  .
;
;
PBRD31   DW      $FB00            ;  WAR-BIRD / LEFT - FRAME #4 (DUFFY)
         DW      $0804            ;  .
         DW      $00F8            ;  .
         DW      $00F4            ;  .
         DW      $02F3            ;  .
         DW      $03FD            ;  .
         DW      $FC02            ;  .
         DW      $FC0C            ;  .
         DW      $FE0E            ;  .
;
PBRD32   DW      $FB00            ;  WAR-BIRD / RIGHT - FRAME #4 (DUFFY)
         DW      $08FC            ;  .
         DW      $0008            ;  .
         DW      $000C            ;  .
         DW      $020D            ;  .
         DW      $0303            ;  .
         DW      $FCFD            ;  .
         DW      $FCF3            ;  .
         DW      $FEF1            ;  .
;
;
;
;
;==========================================================================JJH
;PSHLD   DW      $0800            ;  CODE DELETED - REV. B CHANGES   ======JJH
;        DW      $FA04            ;  .                               ======JJH
;        DW      $FC14            ;  .                               ======JJH
;        DW      $00D0            ;  .                               ======JJH
;        DW      $0414            ;  .                               ======JJH
;        DW      $0504            ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
PSHLD    DB      $05              ;  CODE ADDED - REV. B CHANGES     ======JJH
         DW      $0800            ;  .                               ======JJH
         DW      $FA04            ;  .                               ======JJH
         DW      $FC14            ;  .                               ======JJH
         DW      $00D0            ;  .                               ======JJH
         DW      $0414            ;  .                               ======JJH
         DW      $0504            ;  .                               ======JJH
;==========================================================================JJH
;
;
;
LROAD1   DB      $C3              ;  LOWER-LEFT ROADWAY (ZDUFFY)
         DW      $90AE            ;  .
         DW      $601C            ;  .
         DW      $2800            ;  .
         DW      $C0D0            ;  .
;
LROAD2   DB      $C3              ;  MID-LEFT ROADWAY (ZDUFFY)
         DW      $F0CA            ;  .
         DW      $3038            ;  .
         DW      $1800            ;  .
         DW      $E0C8            ;  .
;
LROAD3   DB      $C3              ;  UPPER-LEFT ROADWAY (ZDUFFY)
         DW      $3802            ;  .
         DW      $28EC            ;  .
         DW      $FC00            ;  .
         DW      $D80C            ;  .
;
;
RROAD1   DB      $C3              ;  LOWER-RIGHT ROADWAY (ZDUFFY)
         DW      $8050            ;  .
         DW      $58CC            ;  .
         DW      $2800            ;  .
         DW      $C040            ;  .
;
RROAD2   DB      $C3              ;  MID-RIGHT ROADWAY (ZDUFFY)
         DW      $001C            ;  .
         DW      $3024            ;  .
         DW      $E800            ;  .
         DW      $D8EC            ;  .
;
RROAD3   DB      $C3              ;  UPPER-RIGHT ROADWAY (ZDUFFY)
         DW      $3040            ;  .
         DW      $30D0            ;  .
         DW      $FC00            ;  .
         DW      $C828            ;  .
;
;
GATE10   DB      $C9              ;  GATE FOR LOWER ROADWAY (ZDUFFY)
         DW      $6107            ;  .
         DW      $0009            ;  .
         DW      $FB00            ;  .
         DW      $00F3            ;  .
         DW      $0400            ;  .
         DW      $00F9            ;  .
         DW      $FC00            ;  .
         DW      $00F2            ;  .
         DW      $0500            ;  .
         DW      $000A            ;  .
;
GATE11   DB      $C3              ;  .
         DW      $5D06            ;  .
         DW      $0601            ;  .
         DW      $00F2            ;  .
         DW      $F901            ;  .
;
;
GATE20   DB      $C9              ;  GATE FOR MIDDLE ROADWAY (ZDUFFY)
         DW      $6108            ;  .
         DW      $0008            ;  .
         DW      $FB00            ;  .
         DW      $00F4            ;  .
         DW      $0400            ;  .
         DW      $00F8            ;  .
         DW      $FB00            ;  .
         DW      $00F4            ;  .
         DW      $0400            ;  .
         DW      $0009            ;  .
;
GATE21   DB      $C3              ;  .
         DW      $5C09            ;  .
         DW      $06FE            ;  .
         DW      $00F2            ;  .
         DW      $FAFE            ;  .
;
;
GATE33   DB      $04              ;  .
         DW      $620E            ;  .
         DW      $08FE            ;  .
         DW      $F8FE            ;  .
         DW      $02FE            ;  .
         DW      $FEFE            ;  .
;
;
LMTN     DB      $C2              ;  LEFT MOUNTAIN DOWNWARD SLOPE (ZDUFFY)
         DW      $1ED2            ;  .
         DW      $1C18            ;  .
         DW      $2004            ;  .
;
RMTN     DB      $C2              ;  RIGHT MOUNTAIN DOWNWARD SLOPE (ZDUFFY)
         DW      $1840            ;  .
         DW      $E00C            ;  .
         DW      $E828            ;  .
;
;
LPEAK    DB      $C3              ;  LEFT MOUNTAIN PEAK (ZDUFFY)
         DB      $2C,$DC          ;  .
         DB      $18,$F0          ;  .
         DB      $F8,$E0          ;  .
         DB      $E0,$E0          ;  .
;
LPEAK1   DB      $C1              ;  .
         DB      $3B,$AB          ;  .
         DB      $C0,$E8          ;  .
;
;
RSLOPE   DB      $C1              ;  RIGHT MOUNTAIN UPWARD SLOPE (ZDUFFY)
         DW      $2440            ;  .
         DW      $3020            ;  .
;
;
RPEAK    DB      $C2              ;  RIGHT MOUNTAIN PEAK (ZDUFFY)
         DB      $48,$28          ;  .
         DB      $10,$18          ;  .
         DB      $E8,$14          ;  .
;
RPEAK1   DB      $C1              ;  .
         DB      $58,$40          ;  .
         DB      $E8,$F0          ;  .
;
;
;
LHORZ    DB      $C2              ;  LEFT HORIZON LINE FOR FORTRESS (ZDUFFY)
         DW      $0000            ;  .
         DW      $00A0            ;  .
         DW      $E0E0            ;  .
;
RHORZ    DB      $C2              ;  RIGHT HORIZON LINE FOR FORTRESS (ZDUFFY)
         DW      $0000            ;  .
         DW      $005F            ;  .
         DW      $E020            ;  .
;
CROAD    DB      $C3              ;  FORTRESS ROADWAY (ZDUFFY)
         DW      $8870            ;  .
         DW      $79D0            ;  .
         DW      $0080            ;  .
         DW      $84D0            ;  .
;
;
CITY1    DB      $A8              ;  CITY SEGMENT (IDASH)
         DW      $0A03            ;  .
         DW      $1D08            ;  .
         DW      $E906            ;  .
         DW      $4008            ;  .
         DW      $B808            ;  .
         DW      $0004            ;  .
         DW      $1000            ;  .
         DW      $0010            ;  .
         DW      $F408            ;  .
;
CITY2    DB      $A9              ;  CITY SEGMENT (IDASH)
         DW      $000C            ;  .
         DW      $1000            ;  .
         DW      $0008            ;  .
         DW      $F800            ;  .
         DW      $0018            ;  .
         DW      $F800            ;  .
         DW      $0006            ;  .
         DW      $0C04            ;  .
         DW      $0018            ;  .
         DW      $F404            ;  .
;
CITY3    DB      $AB              ;  CITY SEGMENT (IDASH)
         DW      $0004            ;  .
         DW      $0800            ;  .
         DW      $08FC            ;  .
         DW      $00F4            ;  .
         DW      $F8FC            ;  .
         DW      $F800            ;  .
         DW      $18FC            ;  .
         DW      $E8FC            ;  .
         DW      $00E8            ;  .
         DW      $0800            ;  .
         DW      $00E8            ;  .
         DW      $F800            ;  .
;
CITY4    DB      $A6              ;  CITY SEGMENT (IDASH)
         DW      $10EA            ;  .
         DW      $10FA            ;  .
         DW      $E0F4            ;  .
         DW      $00FC            ;  .
         DW      $0C00            ;  .
         DW      $00DE            ;  .
         DW      $F400            ;  .
;
;
;
;         MSG     'END OF ROM      = ',*
;
;
;         IF      L.PCK = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
