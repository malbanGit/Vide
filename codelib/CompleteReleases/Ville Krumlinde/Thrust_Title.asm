; Thrust title screen
; Copyright (C) 2004  Ville Krumlinde

mSine macro index,freq,amp,first
 local ok
 if first=1
   ldx #SineTable
 endif
 ldb index
 addb #freq
 bpl ok
   subb #128
ok:
 stb index
 ldb b,x
 if amp>2
   asrb
 endif
 if amp>1
   asrb
 endif
 if amp>0
   asrb
 endif
 if first=1
   tfr b,a
 else
   stb -1,s
   adda -1,s
 endif
 endm


;*****************
ShowTitleScreen:                ;dp=d0
  mDecLocals 7,0,0
LocalTextTimer = LocalB1
LocalTextInt = LocalB2
LocalMusicTimer = LocalB3
LocalVolumeTimer = LocalB4
LocalMode = LocalB5
LocalModeClock = LocalB6
LocalBonusGame = LocalB7

tiReset:
  jsr clear_sound_chip

  jsr InitMusic

  lda #110
  sta TitleLogoY

  lda #100
  sta LocalTextTimer,s
  clra
  sta LocalTextInt,s

  lda #100
  sta LocalMusicTimer,s

  lda #100
  sta LocalVolumeTimer,s

  clr LocalMode,s
  lda #150
  sta LocalModeClock,s

  ;test if bonusgame is enabled
  lda BonusGameEnabled
  adda Cheat
  sta LocalBonusGame,s

tiMain:
  jsr waitrecal

  tst LocalMusicTimer,s
  beq tiGoMusic
    dec LocalMusicTimer,s
    bra tiSkipMusic
tiGoMusic:
  jsr UpdateMusic
tiSkipMusic:

  lda LoopCounterLow
  anda #1
  beq tiNoDecClock
    dec LocalModeClock,s
tiNoDecClock:

  lda LocalMode,s
  beq tiModeLogo        ;0
  deca
  beq tiModeLevel       ;1
  deca
  beq tiModeHighscores  ;2

  ;ModeCredits          ;3
  jsr DrawCreditsScroller
  ldd ScrollTextPtr
  cmpd #CreditsTextEnd - Chars - 1
  bne tiKeepCreditsMode
    ;Switch to logo + volume mode
    clr LocalMode,s
    lda #250
    sta LocalModeClock,s
tiKeepCreditsMode:
  bra tiModeFin

tiModeHighscores:
  ;Mode highscores
  jsr DisplayHighscores
  tst LocalModeClock,s
  bne tiModeFin
    ;Switch to credits mode
    lda #3
    sta LocalMode,s
    ldd #CreditsText
    std ScrollTextPtr
    clr ScrollInt
    bra tiModeFin

tiModeLevel:
  jsr TitleDrawLevel
  tst LocalModeClock,s
  bne tiModeFin
    ;Switch mode to highscores
    inc LocalMode,s
    lda #250
    sta LocalModeClock,s
    bra tiModeFin

tiModeLogo:
  tst LocalModeClock,s
  bne tiKeepLogoMode
    ;Switch to level mode
    mDptoC8

    lda #1
    jsr InitNewGame     ;call init game, keep values for random and clock

    mRandomToA
    anda #3
    sta CurLevel
    jsr PrepareLevel
    lda #1
    sta LocalMode,s
    lda #250
    sta LocalModeClock,s

    ldu CurLevelEntry ;center view around pod
    ldd leOrbY,u
    subd #ScreenH / 2
    cmpd CurLevelEndY
    blt *+3
      ldd CurLevelEndY
    std ViewY
    ldd leOrbX,u
    subd #ScreenW / 2
    ldu #ViewX
    std ,u
    jsr ValidateX

    mSetByte NeedRefresh,1
    jsr RefreshDrawList

    mDptoD0

    bra tiModeFin
tiKeepLogoMode:
  jsr DrawTitleLogo

  tst LocalVolumeTimer,s
  bne tiVolumeNotYet
  jsr DrawTitleVolume
  bra tiVolumeFin
tiVolumeNotYet:
  dec LocalVolumeTimer,s
tiVolumeFin:

tiModeFin:

  lda LocalTextTimer,s
  beq tiShowText
    deca
    sta LocalTextTimer,s
    bra tiSkipText
tiShowText
    ldx #TitleStringsList

    clrb
    lda LoopCounterHigh
    asra
    rolb
    tst LocalBonusGame,s
    beq tiNoBonusText
    lda LoopCounterLow
    asla
    rolb
tiNoBonusText:
    lslb
    ldx b,x

    lda LoopCounterLow
    lsra
    lsra
    ldy #SineTable
    lda a,y
    asra
    asra
    asra
    adda #-116

;    lda #-116
    ldb ,x+
    tfr d,y

    mTicToc 32
    lsla
    lsla
    jsr Text_Print_Intensity
    ;Text_Print_Intensity:   ;x=string pointer, y screen coords, a intensity
tiSkipText:

  lda #1 + 2 + 4 + 8
  jsr read_switches
  ldx #$C812
  lda #1
  tst LocalBonusGame,s
  beq *+1
    inca
tiNextButton:
  tst a,x
  bne tiExit
  deca
  bpl tiNextButton

  lda GameMode  ;test if music has set demogame (music end)
  cmpa #DemoGame
  beq tiFin

  bra tiMain

tiExit:

  ;Exit with key pressed in A (0=button1 etc)

  ;need to clear soundworks-buffer because updatesound is called from
  ;textwait, and that memory may have been written by music
  pshs a
  ldx #LevelClearLabel
  jsr clear_256_bytes
  puls a

  cmpa #1
  bne tiNoOptions
    jsr OptionsMenu
    lda GameMode
    cmpa #DemoGame
    beq tiFin
    bra tiReset
tiNoOptions:

  cmpa #2
  bne tiNoBonusGame
    jsr Zzap_Start
    bra tiReset
tiNoBonusGame

  jsr Text_ShowGameMenu
  cmpb #3
  beq tiReset
  stb GameMode          ;Menu return selected GameMode

tiFin:

  mFreeLocals
  rts

TitleString1: db -32,'1: START',$80
TitleString2: db -40,'2: OPTIONS',$80
TitleString3: db -24,'3: ZSB',$80
TitleStringsList:
  dw TitleString1,TitleString2,TitleString3,TitleString3


;*****************
DisplayHighscores:
;   text_write med fixed list
;   text_write med scores
;
;   stackspace
;   x+y sine offset
;
;   display 'highscores'
;   x=gamemodestringlist
;   u=highscorelist
;   get start sineoffset
;   loop gamemodes
;     copy to stack gamemodestring + highscore + extra '0'
;     calc x,y with sineoffset
;     call displaystring
;     inc sineoffset
;   set viewy till -255
;   call drawstars
;
; Stars and 'highscore' string causes framedrop and slows the music down...
; Skip them for now.
;
  mDecLocals 4,2,11 + 1 + HighscoreEntry + 1
LocalSineY = LocalB3
LocalSineX = LocalB4

;  ldx #HighscoreString
;  mCombine d,80,-40
;  jsr Text_Print

  ldx #GameModeStringList
  ldu #Highscores
  lda #40
  sta LocalB2,s
  lda #3
  sta LocalB1,s
  lda LoopCounterLow
  sta LocalSineY,s
  adda LoopCounterHigh
  adda #30
  sta LocalSineX,s
dhsLoop:
  stx LocalW1,s
  stu LocalW2,s

  ldx ,x
  leau LocalBuffer,s
  jsr Text_CopyString
  ldx LocalW2,s
  ldb #$80
  jsr CopyScoreFromXtoU
;  jsr Text_CopyString

  leax LocalBuffer,s
  lda #' '
  sta 11,x
;  mCombine d,'0',$80
;  std 18,x

  ldu #SineTable
  lda LocalSineY,s
  lsra
  lda a,u
  asra
  adda LocalB2,s

  ldb LocalSineX,s
  lsrb
  ldb b,u
  asrb
  addb #-60
  jsr Text_Print

  lda LocalB2,s ;move y
  suba #30
  sta LocalB2,s

  lda LocalSineY,s
  adda #10
  sta LocalSineY,s

  lda LocalSineX,s
  adda #17
  sta LocalSineX,s

  ldx LocalW1,s
  ldu LocalW2,s
  leax 2,x
  leau HighscoreEntry,u

  dec LocalB1,s
  bne dhsLoop

;  ldd #-255
;  std ViewY
;  jsr DrawStars

  mFreeLocals
  rts
;HighscoreString: db 'HIGHSCORES',$80

;*****************
TitleDrawLevel:
  jsr DrawLevel
  jsr DrawFuel
  jsr DrawGuns
  jsr DrawOrb
  jmp DrawPowerplant

;*****************
DemoMenu:               ;returns with Z set, and GameMode=DemoGame if exit
  direct $d0

  jsr Text_ShowDemoMenu
  cmpb #3
  beq dmExit

  lda #DemoGame
  sta GameMode

  stb DemoSelected
  comb

dmExit:
  direct -1
  rts

;*****************
OptionsMenu:

  jsr Text_ShowOptionsMenu

  tstb
  bne omNoControls
    bsr ControlsMenu
    bra omExit
omNoControls:

  decb
  bne omNoDemo
    bsr DemoMenu
    bra omExit
omNoDemo:

 decb
 bne omNoResetHi
   jsr Text_ShowResetMenu
   cmpb #1
   bne omExit
     jsr eeprom_format
   bra omExit
omNoResetHi:

 decb
 bne omNoCheat
   ;Hidden cheat menu
   jsr read_joystick
   tst $c81c
   bpl omNoCheat
   mEmitSound WarpInSoundId
   bsr CheatMenu
   bra omExit
omNoCheat:

omExit:
  rts

;*****************
CheatMenu:
cmShow:
  jsr Text_ShowCheatMenu

  tstb
  bne cmNoLives
    com CheatLives
    mEmitSound ShipFireSoundId
    bra cmShow
cmNoLives:

  decb
  bne cmNoLevel
    lda CheatLevel
    cmpa #(LevelCountNormal*4)-1
    bne cmIncLevel
      lda #-1
cmIncLevel:
    inca
    sta CheatLevel
    mEmitSound GunFireSoundId
    bra cmShow
cmNoLevel

  rts

;*****************
ControlsMenu:
  mDecLocals 2,0,0
  direct $d0

  clra
  sta LocalB1,s
  sta LocalB2,s
cmLoop:
  jsr Text_ShowControlMenu
  lda LocalB1,s
  lsla
  lsla
  stb -1,s
  ora -1,s
  sta LocalB1,s
  inc LocalB2,s
  lda LocalB2,s
  cmpa #4
  bne cmLoop

  lda LocalB1,s
  sta ButtonConfig

  direct -1
  mFreeLocals
  rts


;*****************
DrawTitleVolume:
  mDecLocals 3,1,(ShipVectorCount*2)
LocalX = LocalB2
LocalMod = LocalB3
LocalVol = LocalW1

  lda #-127  ;start x
  sta LocalX,s

  ldx #$c800 + 0
  stx LocalVol,s

  lda #3
  sta LocalB1,s
dtvLoop:
  ldy LocalVol,s
  lda ,y+  ;fine (lo)
  ldb ,y+  ;course (hi)
  lsra
  lsra
  lsra
  lsra
  sty LocalVol,s
  sta LocalMod,s

  jsr reset0ref                 ;Reset pen

  mSetScale 16
  ldb LocalX,s
  lda #-127 ;y
;  mMove_pen_d
  jsr move_pen_d
;  mMove_pen_d_Quick
;  jsr move_pen7f_to_d           ;Set pen position to value of d register

  mSetIntensity $4f

  ldx #ShipVectorList
  lda   #ShipVectorCount-1      ;Nr of vectors in list
  ldb   #8                      ;Scale
  addb LocalMod,s
  jsr   move_draw_VL4           ;Draw list

  lda LocalX,s
  adda #127
  sta LocalX,s

  dec LocalB1,s
  bne dtvLoop

  mFreeLocals
  rts


;*****************
DrawTitleLogo:
;   att testa
;     g�r verktyg som genererar kod ifr�n bmp
;       mPattern, mRow
;       PacmanLines: dw Pacman_DrawLine01,Pacman_DrawLine02
;       subs anropas av generell drawrutin
;       generar intensity change vid behov
;     dela upp line i tv� horizontella, d� kan scale $7f anv�ndas
;     kan man bumpa upp x-length innan den �r klar? d� blir det inget glapp.
;
;     l�s igenom "SHIFT REGISTER OPERATION" i vectrex.txt
;     skriv $18 till 0B f�r att st�nga av andra interrupt
;     se rom DISPLAY_STRING
  mDecLocals 2,1,0
LocalLine=8             ;
LocalH=28               ;these were local, but changed to constants to save some code size
LocalRepeat = LocalB2
LocalBitmap = LocalW1

  ldx #TitleBitmap

  lda ,x+               ;load repeat
  sta LocalRepeat,s

  stx LocalBitmap,s

  clra                  ;for a=0 to height-1
dbiLoop:
  sta LocalB1,s

  ;Set intensity
  ;lda #$60
  ;Increase/decrease intensity for this line
  lda LoopCounterLow
  bpl dbiIntOk
  nega
dbiIntOk:
  ldb LocalB1,s         ;�ka varannan rad, minska varannan
  bitb #1
  beq dbiInt1
    suba LocalB1,s
    suba LocalB1,s
    bra dbiIntSet
dbiInt1:
    adda LocalB1,s
dbiIntSet:
  mSetIntensity

  jsr reset0ref

  lda #2                ;loop twice
  sta -1,s

  ;Scale 64 for positioning, otherwise y skips every other line
  mSetScale 64

  ldb #-127
  lda #LocalH/2          ;set y to vertical center
  suba LocalB1,s
  adda TitleLogoY

dbiMoveLine:
  mMove_pen_d_Quick
  ;to reach left edge, another x move is needed. loop to avoid inlining twice.
  mCombine d,0,-24
  dec -1,s
  bne dbiMoveLine

  ;Max scale for drawing
  mSetScale 255


  ldx LocalBitmap,s

  lda #127              ;line length
  tfr a,b               ;init hw for line drawing
  clra
  sta   <0x01
  clr   <0x00
  inc   <0x00
  stb   <0x01
  clr   <0x05

  ;rom inner loop
;37c0 :    PF4C7:
;37c0 : a686             [ 5]   lda   a,x
;37c2 : 970a             [ 4]   sta   <0x0A
;37c4 : a6c0             [ 6]   lda   ,u+
;37c6 : 2af8             [ 3]   bpl   PF4C7
;Total 18 cycles

  ldb #LocalLine
dbiLineLoop:
  lda ,x+    ;6
  sta <0x0A  ;4
  orcc #0 ;3
  decb ;2
  bne dbiLineLoop  ;3

  nop 1                         ;wait for the last pattern in line to appear before clearing

  clr <0x0a                     ;clear pattern

;No need to wait, line is drawn
;**todo: keep this delay if possible, MESS cannot display logo otherwise
;  ldb   #0x40                   ;wait timer finish
;dbiWait
;  bitb  <$0D
;  beq   dbiWait


  ldx LocalBitmap,s             ;next row
  dec LocalRepeat,s
  bne dbiKeepRepeating
    leax LocalLine,x
    lda ,x+
    sta LocalRepeat,s
dbiKeepRepeating:
  stx LocalBitmap,s

  lda LocalB1,s
  inca
  cmpa #LocalH
  bne dbiLoop

  lda TitleLogoY                ;move logo down
  cmpa #20
  beq dbiNoAdjustY
    deca
    sta TitleLogoY
dbiNoAdjustY:

  mFreeLocals
  rts




;   custom typsnitt d�r varje bokstav �r tv� tecken (=16 pixels)
;   scrolla pixels genom att flytta x och maska f�rsta/sista pattern byte
;
;   skapa str�ng p� stacken
;     skriv start and-mask
;     get char
;     konvertera till tv� tecken
;       eller ett tecken tv� pekare
;       x=fonttable1, y=fonttable2
;       om loopcounterlow 8..15
;         b�rja med y �ka 1, x sen y sen �ka 1, sluta med x
;       0..7
;         x sen y sen �ka 1
;       b�rja med vanlig loop, dista x 0..15
;       g�r hela draw till macro, anropa tv� ggr olika konfad
;     skriv till stack
;     ev loopa text
;     skriv slut and-mask
;   display_rom
;     unroll char-loop
;     g�r till macro och anropa s� m�nga ggr som antal samtidigt synliga tecken
;
;   h�mta fatfont.dat
;     r�kna hur m�nga tecken den inneh�ller
;     writebyte(char,value)

;*****************
DrawCreditsScroller:
Chars = 16  ;Chars visible at the same time
  mDecLocals 1,0,Chars

  lda LoopCounterLow
  anda #3
  bne dcsNoNewChar
    ldx ScrollTextPtr
    leax 1,x
;    cmpx #CreditsTextEnd - Chars
;    bne dcsNoWrap
;      ldx #CreditsText
;dcsNoWrap:
    stx ScrollTextPtr
dcsNoNewChar:
  lsla
  lsla
  sta LocalB1,s

  ;FC = one space line, FB = one every 4 lines, FD = no space
  ldd   #0xFA38
  std   $C82A           ;Specify height and width
  jsr reset0ref
  mSetScale $7f

  lda ScrollInt
  cmpa #$7f
  beq dcsNoIncInt
    inca
    sta ScrollInt
dcsNoIncInt:
  mSetIntensity

  ;index,freq,amp,first
  mSine SineIndex1,2,1,1
  mSine SineIndex2,1,2,0

  ldb #-127 + 16

  subb LocalB1,s
  jsr move_pen_d

  ldu ScrollTextPtr
  jsr Credits_Draw_display_string

  mFreeLocals
  rts




CreditsText:
  db '                VECTREX THRUST V1.2 BY VILLE KRUMLINDE 2004. MUSIC BY ROB HUBBARD. ORIGINAL C64 THRUST BY JEREMY C SMITH 1985. THIS GAME IS FREEWARE.                  '
CreditsTextEnd:

;Copied from ROM: display_string
;Modified to draw 16*16 pixel font
Credits_Draw_display_string:
       stu   $C82C     ;/* Save pointer to start of string. */

;       ldx   #0xF9D4
 ldx #FontTable1-32
 ldy #FontTable2-32

       ldd   #0x1883
       clr   <0x01
       sta   <0x0B
;       ldx   #0xF9D4
  orcc #0  ;wait 3 cycles
PF4A5: stb   <0x00
       dec   <0x00
       ldd   #0x8081
       nop
       inc   <0x00
       stb   <0x00
       sta   <0x00
       tst   $C800
       inc   <0x00
       lda   $C82B    ;/* Get the string width. */
       sta   <0x01
       ldd   #0x0100
       ldu   $C82C
       sta   <0x00


;[ 3]        bra   PF4CB
;[ 5] PF4C7: lda   a,x
;[ 4]        sta   <0x0A
;[ 6] PF4CB: lda   ,u+
;[ 3]        bpl   PF4C7

  orcc #0  ;wait 3 cycles

_m macro
  lda   ,u+
  orcc #0  ;wait 3 cycles
  ldb   a,x
  stb   <0x0A
  orcc #0  ;wait 3 cycles
  tst ,x   ;wait 6 cycles
  ldb   a,y
  stb   <0x0A
 endm

;**todo beh�vs unroll? om inte, byt tillbaka till loop

 _m
 _m
 _m
 _m
 _m
 _m
 _m
 _m

 _m
 _m
 _m
 _m
 _m
 _m
 _m

  lda ,u+       ;6 cycles, increase u to printed chars + 1
  orcc #0  ;wait 3 cycles

       lda   #0x81
       sta   <0x00
       neg   <0x01
       lda   #0x01
       sta   <0x00

;       cmpx  #0xFBB4  ;/* If not at end of char table, then */
  cmpx #(FontTable1-32) + (14*62)
       beq   PF50A    ;/* proceed to next row of pixels.    */

;       leax  0x50,x     ;add to font definition pointer, $50=one row
  leax 62,x
  leay 62,y

       tfr   u,d
       subd  $C82C    ;/* Point back to first character. */
       subb  #0x02      ;waitloop, depending on string length
       aslb
  ;wait*2 because we now use width*2 font
  aslb
  nop 6
       brn   PF4EB
PF4EB: lda   #0x81
       nop
       decb
       bne   PF4EB

       sta   <0x00
       ldb   $C82A      ;height
       stb   <0x01
       dec   <0x00

       ldd   #0x8101
       nop
       sta   <0x00
       clr   <0x01
       stb   <0x00
       sta   <0x00
       ldb   #0x03
       bra   PF4A5
PF50A: lda   #0x98
       sta   <0x0B
 rts
;       jmp reset0ref


;todo: many unused letters, save memory by having a char-translation table?
FontTable1:
; db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,96,224
 db 0,3,6,6,6,24,31,0,3,3,0,0,0,0,0,0,15,7,15,15,248,255,0,255,31,15,0,0,0,0,14,15,31,15,255,15,255,15,15,15,248,6,0,24,24,248,240,15,255,15,255,15,255,192,224,192,48,240,255,7,111,239
 db 0,7,15,14,63,60,127,1,7,3,1,3,0,0,0,0,63,15,63,63,248,255,1,255,127,63,3,3,1,0,31,63,127,63,255,63,255,63,63,63,248,7,0,56,56,252,248,63,255,63,255,63,255,224,240,224,120,252,127,0,63,63
 db 0,7,30,14,127,102,249,3,15,1,25,3,0,0,0,0,127,31,127,127,248,255,3,255,252,127,7,7,3,63,31,127,112,127,255,127,255,127,127,127,248,7,0,120,120,255,252,127,255,127,255,127,255,240,240,240,252,254,63,63,127,127
 db 0,7,60,63,127,102,240,7,14,0,29,3,0,0,0,0,127,31,124,124,248,255,7,255,248,124,7,7,7,63,15,124,224,127,255,127,255,127,127,127,248,7,0,249,248,255,254,127,248,127,248,127,255,248,248,248,254,255,31,127,127,127
 db 0,7,24,127,118,60,121,3,30,0,15,3,0,0,0,0,252,3,56,56,248,248,15,0,252,248,3,3,15,63,7,56,207,252,248,255,255,255,255,252,248,7,0,251,248,255,255,255,248,255,248,252,7,248,248,248,127,63,1,252,252,255
 db 0,7,0,127,127,25,63,0,28,0,7,63,0,63,0,1,248,3,0,0,248,255,31,0,127,248,0,0,31,0,3,0,223,248,248,254,248,252,252,249,248,7,0,255,248,251,255,252,248,252,248,127,7,248,124,248,63,15,3,248,248,252
 db 0,7,0,14,127,3,31,0,28,0,63,63,0,63,0,3,248,3,0,0,252,255,63,1,31,124,0,0,63,0,1,0,216,248,248,252,248,255,252,249,255,7,0,255,248,248,255,248,255,248,255,127,7,248,124,249,31,15,7,248,248,248
 db 0,7,0,14,63,7,31,0,28,0,63,63,0,63,0,7,248,3,1,0,127,255,127,3,127,127,0,0,62,0,0,3,216,255,248,252,248,255,255,248,255,7,0,255,248,248,255,248,255,248,255,63,7,248,62,251,15,7,15,255,255,248
 db 0,3,0,63,6,15,63,0,28,0,7,3,0,0,0,15,248,3,3,0,127,127,252,7,252,63,0,0,63,63,1,7,220,255,248,252,248,255,255,248,255,7,248,255,248,248,255,248,255,248,255,15,7,248,62,255,31,7,31,255,255,248
 db 0,0,0,127,6,31,121,0,28,0,15,3,0,0,0,31,248,3,7,56,63,0,248,15,248,15,0,0,31,63,3,7,207,255,248,254,248,252,255,252,248,7,248,255,252,248,251,252,248,252,255,0,7,248,31,255,63,7,63,255,255,252
 db 0,0,0,127,127,62,240,0,30,0,29,3,0,0,0,62,252,3,15,124,15,0,248,31,248,15,3,0,15,63,7,7,231,248,248,255,255,255,252,255,248,7,252,251,255,248,249,255,248,254,249,0,7,252,31,255,127,7,127,248,248,255
 db 0,3,0,14,127,124,248,0,14,0,25,3,3,0,3,124,127,15,31,127,0,255,124,63,252,31,7,3,7,0,15,0,96,248,255,127,255,127,252,127,248,7,127,249,127,248,248,127,248,127,248,31,7,127,15,255,254,7,255,248,248,127
 db 0,7,0,14,127,120,127,0,15,1,1,0,7,0,7,248,127,15,63,127,0,255,127,126,255,63,7,7,3,0,31,7,120,240,255,127,255,127,252,127,240,7,127,248,127,240,248,127,120,127,120,63,3,127,15,126,252,3,255,240,240,127
 db 0,7,0,12,6,48,127,0,7,3,0,0,15,0,7,240,63,15,127,63,0,255,63,252,127,127,3,15,1,0,31,15,63,224,255,63,255,63,252,63,224,7,63,248,63,224,248,63,56,63,56,127,1,63,7,60,120,1,255,224,224,63
 db 0,3,0,0,0,0,31,0,3,3,0,0,30,0,3,96,15,15,127,15,0,255,15,248,31,126,0,30,0,0,14,7,15,192,255,15,255,15,252,15,192,7,15,248,15,192,248,15,24,15,24,255,0,15,7,24,48,0,255,192,192,15
FontTable2:
; db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,6,14
 db 0,128,24,48,96,12,128,192,128,128,0,0,0,0,0,12,224,224,224,224,248,254,252,252,240,224,0,0,224,0,0,224,240,224,224,254,224,254,254,254,6,0,48,60,0,62,6,224,224,224,224,254,254,6,14,6,24,30,254,128,230,238
 db 0,192,60,112,252,30,224,224,128,192,128,128,0,0,0,30,248,224,248,248,248,254,252,254,252,248,128,128,240,0,0,248,252,248,248,254,248,254,254,254,14,0,56,126,0,126,14,248,248,248,248,252,254,14,30,14,60,126,254,0,248,248
 db 0,192,120,112,252,62,240,192,0,224,152,128,0,0,0,62,252,224,252,252,248,254,248,254,126,252,192,192,240,248,128,252,28,252,252,252,252,252,252,252,30,128,60,252,0,254,30,252,252,252,252,248,254,30,30,30,126,254,254,248,252,252
 db 0,192,240,254,252,124,240,128,0,224,184,128,0,0,0,124,252,224,126,126,248,254,240,254,62,124,192,192,224,248,192,126,14,252,252,248,252,248,248,248,62,192,62,248,0,254,62,252,124,252,124,240,254,62,62,62,254,254,254,252,252,252
 db 0,192,96,254,96,248,224,0,0,240,240,128,0,0,0,248,126,224,62,62,248,0,224,126,126,62,128,128,192,248,224,62,102,126,124,240,254,240,240,0,62,192,62,240,0,254,62,254,62,254,62,0,192,62,62,62,252,248,252,126,126,254
 db 0,192,0,252,252,240,192,0,0,112,224,248,0,248,0,240,62,224,126,126,248,224,224,252,252,62,0,0,128,0,240,126,230,62,124,0,126,0,0,252,62,192,62,224,0,190,190,126,124,126,124,224,192,62,124,62,248,224,248,62,62,126
 db 0,192,0,112,254,224,128,0,0,112,252,248,0,248,0,224,62,224,252,252,248,248,248,248,240,126,0,0,0,0,248,252,102,62,248,0,62,192,0,254,254,192,62,192,0,62,254,62,252,62,252,248,192,62,124,62,240,224,240,62,62,62
 db 0,192,0,112,254,192,140,0,0,112,252,248,0,248,0,192,62,224,248,248,254,252,252,240,252,252,0,0,0,0,248,248,102,254,248,0,62,192,192,254,254,192,62,192,0,62,254,62,248,62,248,252,192,62,248,190,224,192,224,254,254,62
 db 0,128,0,254,110,152,222,0,0,112,224,128,0,0,0,128,62,224,240,124,254,252,124,224,126,248,0,0,0,248,248,224,102,254,124,0,62,192,128,126,254,192,62,192,0,62,254,62,224,30,224,252,192,62,248,254,240,192,192,254,254,62
 db 0,0,0,254,110,60,252,0,0,112,240,128,0,0,0,0,62,224,224,62,254,126,62,192,62,240,0,0,128,248,240,192,252,254,62,0,126,0,0,30,62,192,62,224,0,62,254,126,0,110,224,126,192,62,240,254,248,192,128,254,254,126
 db 0,0,0,252,254,102,248,0,0,240,184,128,0,0,0,0,126,224,192,126,254,126,62,128,62,224,128,0,192,248,224,192,184,62,126,240,254,240,0,254,62,192,126,240,254,62,254,254,0,246,240,126,192,126,240,254,252,192,0,62,62,254
 db 0,128,0,112,254,102,248,0,0,224,152,128,192,0,128,0,252,248,254,254,248,252,124,0,126,192,192,192,224,0,192,0,0,62,252,248,252,248,0,254,62,192,252,248,254,62,254,252,0,120,248,252,192,252,224,254,254,192,254,62,62,252
 db 0,192,0,112,252,60,252,0,0,224,128,0,192,0,192,0,252,248,254,252,248,252,252,0,254,128,192,192,240,0,128,192,6,30,252,252,252,252,0,252,62,192,252,252,254,30,126,252,0,188,124,252,192,252,224,252,126,192,254,30,30,252
 db 0,192,0,96,96,24,222,0,128,192,0,0,128,0,192,0,248,248,254,248,248,248,248,0,252,0,128,128,240,0,0,224,254,14,248,254,248,254,0,248,62,192,248,126,254,14,62,248,0,222,62,248,192,248,192,120,60,192,254,14,14,248
 db 0,128,0,0,0,0,140,0,128,128,0,0,0,0,128,0,224,248,254,224,248,224,224,0,240,0,0,0,224,0,0,192,248,6,224,254,224,254,0,224,62,192,224,60,254,6,30,224,0,236,30,224,192,224,192,48,24,192,254,6,6,224


TitleBitmap:
 ;thrust 64*28
 ;repeatvalue, bitmap
 db 7, $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 db 3, $00,$00,$00,$00,$00,$00,$00,$00
 db 1, $1E,$1E,$39,$FF,$78,$E7,$FC,$FF
 db 2, $1E,$1E,$39,$FF,$78,$EF,$FC,$FF
 db 1, $1E,$1E,$39,$C7,$78,$EF,$FC,$FF
 db 2, $1E,$1E,$39,$C7,$78,$EF,$00,$3C
 db 1, $1E,$1F,$F9,$C7,$78,$EF,$00,$3C
 db 2, $1E,$1F,$F9,$C7,$78,$EF,$FC,$3C
 db 1, $1E,$1F,$F9,$FF,$78,$E7,$FC,$3C
 db 1, $1E,$1F,$F9,$FF,$78,$E0,$1C,$3C
 db 1, $1E,$1E,$39,$FF,$78,$E0,$1C,$3C
 db 2, $1E,$1E,$39,$FC,$7F,$E0,$1C,$3C
 db 2, $1E,$1E,$39,$DE,$7F,$EF,$FC,$3C
 db 1, $1E,$1E,$39,$CF,$3F,$EF,$FC,$3C
 db 1, $1E,$1E,$39,$CF,$3F,$CF,$FC,$3C

;128 values, range -63 -- +63
SineTable:
 db 0,3,6,9,12,15,18,21,24,27,30,32,35,38,40,42,45,47,49,51,52,54,56,57,58,59,60
 db 61,62,62,63,63,63,63,63,62,62,61,60,59,58,57,56,54,52,51,49,47,45,42,40,38,35
 db 32,30,27,24,21,18,15,12,9,6,3,0,-3,-6,-9,-12,-15,-18,-21,-24,-27,-30,-32,-35
 db -38,-40,-42,-45,-47,-49,-51,-52,-54,-56,-57,-58,-59,-60,-61,-62,-62,-63,-63
 db -63,-63,-63,-62,-62,-61,-60,-59,-58,-57,-56,-54,-52,-51,-49,-47,-45,-42,-40
 db -38,-35,-32,-30,-27,-24,-21,-18,-15,-12,-9,-6,-3




;Music_RAM_Size = 400                  ;Reserve memory for music player
 include "Thrust_Music.asm"


;-----------------
;Vectrex RAM section
  bss

  org TemporaryArea

TitleLogoY: ds 1
VolumeTimer: ds 1

ScrollInt: ds 1
ScrollTextPtr: ds 2
SineIndex1: ds 1
SineIndex2: ds 1

  code
