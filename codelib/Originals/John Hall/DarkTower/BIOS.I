;RUM - address - minestorm "names"
INITALL             =        0xF18B                       ; INTALL Full Vectrex initialization 
INITMSC             =        0xF164                       ; INTMSC Initialize misc. parameters 
INITPIA             =        0xF14C                       ; INTPIA Initialize PIA 
INITPSG             =        0xF272                       ; INTPSG Initialize sound generator 
IREQ                =        0xF533                       ; INTREQ Initialize the 'REQZ' area 
POWER               =        0xF000                       ; PWRUP Power-up handler 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Positioning / Intensity / Drawing Overhead Routines
DEFLOK              =        0xF2E6                       ; --- Overcome scan collapse circuitry 
FRAM20              =        0xF192                       ; FRWAIT Wait for frame boundary 
INT1Q               =        0xF29D                       ; --- Set beam intensity 
INT3Q               =        0xF2A5                       ; --- Set beam intensity 
INTENS              =        0xF2AB                       ; --- Set beam intensity 
INTMAX              =        0xF2A9                       ; --- Set beam intensity 
INTMID              =        0xF2A1                       ; INT2Q Set beam intensity 
POSIT1              =        0xF30C                       ; --- Position relative vector 
POSIT2              =        0xF308                       ; --- Position relative vector 
POSITB              =        0xF30E                       ; --- Position relative vector 
POSITD              =        0xF2FC                       ; --- Position relative vector 
POSITN              =        0xF312                       ; --- Position relative vector 
POSITX              =        0xF310                       ; --- Position relative vector 
POSWID              =        0xF2F2                       ; --- Position relative vector 
ZEGO                =        0xF34F                       ; ZEGO Zero integrators and set active ground 
ZEREF               =        0xF35B                       ; ZEREF Zero integrators and set active ground 
;ZERO.DP             =        0xF34A                       ; ZERO.DP Zero integrators and set active ground 
;ZERO.               =        0xF36B                       ; ZERO Zero integrators and set active ground 
ZERODP              =        0xF34A                       ; ZERO.DP Zero integrators and set active ground 
_1ZERO              =        0xF36B                       ; ZERO Zero integrators and set active ground 
ZEROIT              =        0xF354                       ; ZEROIT Zero integrators and set active ground 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;'DIFFY' Style Drawing Routines
DANROT              =        0xF610                       ; DROT 'DIFFY' style rotate 
DASHE               =        0xF433                       ; DSHDF1 Draw dashed lines from 'DIFFY' list 
DASHEL              =        0xF434                       ; DSHDF Draw dashed lines from 'DIFFY' list 
DASHY               =        0xF437                       ; DASHDF Draw dashed lines from 'DIFFY' list 
DIFFAB              =        0xF3DF                       ; --- Draw from 'DIFFY' style list 
DIFFAX              =        0xF3CE                       ; --- Draw from 'DIFFY' style list 
DIFFX               =        0xF3D8                       ; TDIFFY Draw from 'DIFFY' style list 
DIFFY               =        0xF3DD                       ; --- Draw from 'DIFFY' style list 
DIFLST              =        0xF3D6                       ; --- Draw from 'DIFFY' style list 
DIFROT              =        0xF616                       ; ADROT 'DIFFY' style rotate 
DIFTIM              =        0xF3D2                       ; --- Draw from 'DIFFY' style list 
DIFTLS              =        0xF3DA                       ; LDIFFY Draw from 'DIFFY' style list 
DISROT              =        0xF613                       ; BDROT 'DIFFY' style rotate 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;'DUFFY' Style Drawing Routines
DUFFAB              =        0xF3BE                       ; --- Draw from 'DUFFY' style list 
DUFFAX              =        0xF3AD                       ; --- Draw from 'DUFFY' style list 
DUFFY               =        0xF3BC                       ; --- Draw from 'DUFFY' style list 
DUFLST              =        0xF3B5                       ; --- Draw from 'DUFFY' style list 
DUFTIM              =        0xF3B1                       ; --- Draw from 'DUFFY' style list 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;'DOT' Drawing Routines
DIFDOT              =        0xF2D5                       ; --- Draw dots according to 'DIFFY' format 
;?DOT     = 0xF2C     ;---     Turn on beam for dot
; should probably be:
;DOT     = 0xF2C5
DOTAB               =        0xF2C3                       ; --- Draw one dot from the contents of 'A' & 'B' 
DOTPAK              =        0xF2DE                       ; DOTPCK Draw dots according to 'PACKET' format 
DOTTIM              =        0xF2BE                       ; --- Draw one dot from 'DIFFY' style list 
DOTX                =        0xF2C1                       ; --- Draw one dot from 'DIFFY' style list 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;'PACKET' Style Drawing Routines
DASHY3              =        0xF46E                       ; DASHPK Draw dashed lines from 'PACKET' list 
PAC1X               =        0xF408                       ; PACK1X Draw from 'PACKET' style list 
PAC2X               =        0xF404                       ; PACK2X Draw from 'PACKET' style list 
PACB                =        0xF40E                       ; TPACK Draw from 'PACKET' list 
PACKET              =        0xF410                       ; --- Draw from 'PACKET' list 
PACXX               =        0xF40C                       ; LPACK Draw from 'PACKET' style list 
POTATA              =        0xF61F                       ; PROT 'PACKET' style rotate 
POTATE              =        0xF622                       ; APROT 'PACKET' style rotate 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;'RASTER' / Message Drawing Routines
POSDRAS             =        0xF37A                       ; MSSPOS Display raster message 
POSNRAS             =        0xF378                       ; RSTPOS Display raster message 
RASTER              =        0xF495                       ; Malban ; MRASTR Display raster string 
;RASTER              =        0xF498                       ; MRASTR Display raster string 
;RASTUR              =        0xF495                       ; RASTER Display raster string 
SADD                =        0xF87C                       ; SCRADD Add contents of 'B' to indicated score 
SADD2               =        0xF880                       ; STKADD Add stack to indicated score 
SHADD               =        0xF85E                       ; BYTADD Add contents of 'A' to indicated score 
SHIPSAT             =        0xF391                       ; SHIPX Display markers (count remaining) 
SHIPSHO             =        0xF393                       ; DSHIP Display markers (count remaining) 
SIZPRAS             =        0xF373                       ; RSTSIZ Display raster message 
TEXPOS              =        0xF38C                       ; TXTPOS Display raster message 
TEXSIZ              =        0xF385                       ; TXTSIZ Display raster message 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Controller / Joystick Routines
ENPUT               =        0xF1B4                       ; DBNCE Read controller buttones 
HIGHSCR             =        0xF8D8                       ; HISCR Calculate high score and save for logo 
INPUT               =        0xF1BA                       ; --- Read controller buttones 
; name used as a RAM location!
;OPTION              =        0xF7A9                       ; SELOPT Fetch game options 
PANG                =        0xF1F8                       ; JOYBIT Read joystick 
PBANG4              =        0xF1F5                       ; JOYSTK Read joystick 
SCLR                =        0xF84F                       ; --- Clear indicated score 
WINNER              =        0xF8C7                       ; --- Determine highest score 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Rotate Routines
DANROT              =        0xF610                       ; DROT 'DIFFY' style rotate 
DIFROT              =        0xF616                       ; ADROT 'DIFFY' style rotate 
DISROT              =        0xF613                       ; BDROT 'DIFFY' style rotate 
POTATA              =        0xF61F                       ; PROT 'PACKET' style rotate 
POTATE              =        0xF622                       ; APROT 'PACKET' style rotate 
RATOT               =        0xF5FF                       ; LROT90 Rotate a single line 
ROTAR               =        0xF603                       ; ALNROT Rotate a single line 
ROTOR               =        0xF601                       ; LNROT Rotate a single line 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Math Routines
ABSVAL              =        0xF584                       ; ABSAB Form absolute value for 'A' & 'B' registers 
AOK                 =        0xF58B                       ; ABSB Form absolute value for 'B' register 
BITE                =        0xF57E                       ; DECBIT Decode bit position 
COMPAS              =        0xF593                       ; CMPASS Return angle for given delta 'Y:X' 
COSGET              =        0xF5D9                       ; COSINE Calculate the cosine of 'A' 
RAND3               =        0xF511                       ; --- Calculate new random number 
RANDOM              =        0xF517                       ; --- Calculate new random number 
RCOS                =        0xF663                       ; LCSINE Multiply 'LEG' by previous cosine value 
RCOSA               =        0xF661                       ; MCSINE Multiply 'A' by previous cosine value 
RSIN                =        0xF65D                       ; LSINE Multiply 'LEG' by previous sine value 
RSINA               =        0xF65B                       ; MSINE Multiply 'A' by previous sine value 
SINCOS              =        0xF5EF                       ; --- Calculate the sine and cosine of 'ANGLE' 
SINGET              =        0xF5DB                       ; SINE Calculate the sine of 'A' 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Miscellaneous Routines
BAGAUX              =        0xF67F                       ; BLKMV1 Xfer bytes source to destination buffer 
CLR256              =        0xF545                       ; ---6 Set-up to clear 256 bytes 
CLRMEM              =        0xF542                       ; CLREX Clear 256 bytes starting at 0xC800 
CLRSON              =        0xF53F                       ; BCLR Clear 'B' bytes 
DEKR                =        0xF55E                       ; DECTMR Decrement interval timers 
DEKR3               =        0xF55A                       ; D3TMR Decrement interval timers 
DEL                 =        0xF57A                       ; --- Programmed delays 
DEL13               =        0xF57D                       ; --- Programmed delays 
DEL20               =        0xF579                       ; --- Programmed delays 
DEL28               =        0xF575                       ; --- Programmed delays 
DEL33               =        0xF571                       ; --- Programmed delays 
DEL38               =        0xF56D                       ; --- Programmed delays 
DPIO                =        0xF1AA                       ; --- Set direct register 
DPRAM               =        0xF1AF                       ; --- Set direct register 
FILL                =        0xF552                       ; BLKFIL Set a block of memory 
FINDBOX             =        0xF8FF                       ; BXTEST Symmetric collison test 
GILL                =        0xF548                       ; CLRBLK Clear a block of memory 
NEGSOM              =        0xF550                       ; CLR80 Set a block of memory to 0x80 
OFF1BOX             =        0xF8E5                       ; OFF1BX Symmetric collison test 
OFF2BOX             =        0xF8F3                       ; OFF2BX Symmetric collison test 
STFAUX              =        0xF683                       ; BLKMOV Xfer bytes source to destination buffer 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Sound-related Routines
AXE                 =        0xF92E                       ; EXPLOD Complex explosion sound effect 
LOUDIN              =        0xF9CA                       ; SETAMP Complex explosion sound effect 
NIBBY               =        0xFF9F                       ; --- Complex explosion sound effect 
PSG                 =        0xF259                       ; WRPSG Write to PSG 
PSGLPU              =        0xF284                       ; PSGMIR Send sound string to PSG 
PSGLUP              =        0xF27D                       ; PSGLST Send sound string to PSG 
PSGX                =        0xF256                       ; WRREG Write to PSG 
REPLAY              =        0xF687                       ; --- Set 'REQX' for given tune 
REQOUT              =        0xF289                       ; --- Send 'REQX' to PSG and mirror 
SOPLAY              =        0xF690                       ; ASPLAY Set 'REQX' for given tune 
SPLAY               =        0xF68D                       ; --- Set 'REQX' for given tune 
XPLAY               =        0xF742                       ; --- Set 'REQX' for given tune 
YOPLAY              =        0xF692                       ; TPLAY Set 'REQX' for given tune 
