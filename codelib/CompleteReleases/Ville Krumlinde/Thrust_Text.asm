; Thrust text constants and text/menu display code.
; Copyright (C) 2004  Ville Krumlinde

mMakeTextCoord macro lineY,lengthX
 mCombine d, (-(10*(lineY))), (0 - ((lengthX*8)/2))
 endm


;From x to u, until (and including) end byte
Text_CopyString = $F8DE


;*****************
Text_Print:   ;x=string pointer, a/b screen coords
  mDecLocals 0,2,0

  std LocalW1,s
  stx LocalW2,s

  ldd   #0xFC30    ;#0xFC38
  std   $C82A           ;Specify height and width
  jsr reset0ref
  mSetScale $7f
  mSetIntensity $40
  ldd LocalW1,s
  jsr move_pen_d

  ldu LocalW2,s
  jsr display_string    ;rom struntar i scale

  mFreeLocals
  rts


;*****************
Text_Print_Intensity:   ;x=string pointer, y screen coords, a intensity
  mDecLocals 1,1,0

  sta LocalB1,s
  stx LocalW1,s

  ldd   #0xFC30    ;#0xFC38
  std   $C82A           ;Specify height and width
  jsr reset0ref
  mSetScale $7f
  lda LocalB1,s
  mSetIntensity
  tfr y,d
  jsr move_pen_d

  ldu LocalW1,s
  jsr display_string    ;rom-code ignores current scale

  mFreeLocals
  rts



;*****************
Text_PrintWait:   ;waits for one second
;x = pointer to list: {1},coords,stringptr,coords,stringptr, ... , $0000
;if first byte is 1, then wait for keypress
MaxLines = 10
  mDecLocals 3,4,MaxLines
LocalExitType = LocalB2
LocalSaveDP = LocalB3
LocalCallback = LocalW4

  leau LocalBuffer,s    ;init wait-buffer
  lda #-2
  ldb #MaxLines
tpwInitWait:
  sta ,u+
  suba #26
  decb
  bne tpwInitWait

  clrb
  lda ,x
  cmpa #1
  bne tpwNoMenu         ;check for first byte 1: 'menu' mode, return keypress
    leax 1,x
    incb
tpwNoMenu:
  stb LocalExitType,s

  lda ,x
  cmpa #2
  bne tpwNoQuick        ;check for first byte 2: skip animation
    leax 1,x
    lda #$40
    leau LocalBuffer,s    ;init wait-buffer
    ldb #MaxLines
tpwInitQuick:
    sta ,u+
    decb
    bne tpwInitQuick
tpwNoQuick:

  clra
  clrb
  std LocalCallback,s
  lda ,x
  cmpa #3
  bne tpwNoCallback     ;check for first byte 3: callback
    ldd 1,x
    std LocalCallback,s
    leax 3,x
tpwNoCallback:

  stx LocalW1,s

  ;Save dp, meny is called from both title (d0) and game (c8)-code
  tfr dp,a
  sta LocalSaveDP,s
  mDptoD0

  lda #120
  sta LocalB1,s
tpwWait:
  jsr waitrecal         ;Wait for screen sync
  jsr UpdateSoundChip

  ldx LocalCallback,s
  beq tpwNoCallCallback
    jsr ,x
tpwNoCallCallback:

  leau LocalBuffer,s
  stu LocalW3,s

  ldy LocalW1,s
tpwNextLine:
  ldd ,y++
  beq tpwNoMoreLines
  ldx ,y++
  sty LocalW2,s
  tfr d,y

  ldu LocalW3,s         ;update wait-buffer for each line
  lda ,u+
  stu LocalW3,s
  cmpa #$40
  beq tpwSkipInc
  inca
  inca
  sta -1,u
  bmi tpwSkipLine
tpwSkipInc:

  ;value from wait-buffer is used for intensity and coord-offsets
  sta -1,s
  nega
  adda #$40
  ldu #SineTable
  lda a,u
; asra
  sta -2,s
  tfr y,d
  adda -2,s
  addb -2,s
  tfr d,y
  lda -1,s
  adda #$10
  jsr Text_Print_Intensity

tpwSkipLine:
  ldy LocalW2,s
  bra tpwNextLine
tpwNoMoreLines:

  jsr UpdateSound

  tst LocalExitType,s
  beq tpwTestDelayExit

  lda #1 + 2 + 4 + 8    ;exit after keypress (menu)
  jsr read_switches

  ldx #$C812
  ldb #3
tpwNextButton:
  tst b,x
  bne tpwExit           ;exit with key in B
  decb
  bpl tpwNextButton

  bra tpwWait

tpwTestDelayExit:       ;exit after 1 second
  dec LocalB1,s
  beq tpwExit

  bra tpwWait

tpwExit:
  ;Restore dp
  lda LocalSaveDP,s
  tfr a,dp

  mFreeLocals
  rts


;*****************
Text_PrintX:            ;x holds value to be printed (max 9999), a/b screen coords
  mDecLocals 0,1,5

  std LocalW1,s

  leau LocalBuffer,s
  bsr Text_ConvertX

  ldb #$80              ;add end byte
  stb 4,u

  ldd LocalW1,s
  leax LocalBuffer,s
  jsr Text_Print

  mFreeLocals
  rts


;*****************
Text_ConvertX           ;x holds value to be converted (max 9999), u = destination buffer (4 bytes needed)
  ;NOTE: this subroutine has two entry-points, be careful with stack usage
  ldd #'  '
  std ,u
  std 2,u

  cmpx #100
  lblo tlsBelow100
  cmpx #1000
  lblo tlsBelow1000

m_1 macro max,digit
  cmpx #max-1
  bls tpd\1
  leax -max,x
  lda #'digit'
  sta 0,u
  bra tlsBelow1000
tpd\1:
  endm

  m_1 9000,9
  m_1 8000,8
  m_1 7000,7
  m_1 6000,6
  m_1 5000,5
  m_1 4000,4
  m_1 3000,3
  m_1 2000,2
  m_1 1000,1

m_2 macro max,digit
  cmpx #max-1
  bls tpd\1
  leax -max,x
  lda #'digit'
  sta 1,u
  bra tlsBelow100
tpd\1:
  endm

tlsBelow1000:
  m_2 900,9
  m_2 800,8
  m_2 700,7
  m_2 600,6
  m_2 500,5
  m_2 400,4
  m_2 300,3
  m_2 200,2
  m_2 100,1

  lda #'0'
  sta 1,u

m_3 macro max,digit
  cmpb #max-1
  bls tpd\1
  subb #max
  addb #'0'
  lda #'digit'
  std 2,u
  bra tlsExit
tpd\1:
  endm

Text_ConvertX2:           ;x holds value to be converted (max 99), u = destination buffer-2 (2 bytes needed)

tlsBelow100:
  tfr x,d
  m_3 90,9
  m_3 80,8
  m_3 70,7
  m_3 60,6
  m_3 50,5
  m_3 40,4
  m_3 30,3
  m_3 20,2
  m_3 10,1

  lda #'0'
  addb #'0'
  std 2,u

tlsExit:
  rts



;*****************
Text_LevelExit:         ;returns z set if level is finished
  direct $c8
  mDecLocals 1,1,50
LocalString1 = LocalBuffer + 18
LocalString2 = LocalString1 + 20
LocalLevelFin = LocalB1
LocalBonus = LocalW1

;
;  hasPod
;    line 0: "planet destroyed" (if planteddestroyed)
;    line 1: "mission 2 complete"
;    line 2: "bonus xxx" (2000 + (400 * levelno)) + (2000 if planteddestroyed)
;
; level exit utan orb men planetdestroyed
; samma ifall planet destroyed, ej exit
;(vid loselife, testa destroyed, ta bort orb, och anropa onlevelexit)
;          PLANET DESTROYED
;          MISSION 1 FAILED
;          NO BONUS
;          (level++)
;

  clr LocalLevelFin,s           ;level completed as default

  mTestFlag HasOrbFlag
  lbeq txlNoOrb

  ldx #CompleteString
  leau LocalString1,s
  jsr Text_CopyString

  ldb CurLevel                  ;insert level no
  incb
  sex
  tfr d,x
  leau LocalString1+8-2,s
  jsr Text_ConvertX2

  leay LocalBuffer,s
  mCombine d,30,-70
  std ,y++
  leax LocalString1,s
  stx ,y++

  ldd #2000
  std LocalBonus,s

  tst PowerLife
  bpl txlPlanetAlive
    mCombine d,50,-60
    std ,y++
    ldx #PlanetString
    stx ,y++
    ldd #2000
    addd LocalBonus,s
    std LocalBonus,s
txlPlanetAlive:

  ldx #BonusString              ;bonus string
  leau LocalString2,s
  jsr Text_CopyString

  ;detect 'perfect'
  lda GameMode
  cmpa #NormalGame
  beq txlNoPerfect      ;no perfect for normal game

  tst PowerLife
  bpl txlNoPerfect

  ldu CurLevelEntry     ;check all guns destroyed
  ldu leGuns,u
  lda ,u
  sta -1,s
  ldd GunsActive
txlGunLoop:
  asra
  rorb
  bcs txlNoPerfect
  dec -1,s
  bne txlGunLoop

  ldu CurLevelEntry     ;check all fuel collected/destroyed
  ldu leFuel,u
  lda ,u
  ldb FuelActive
txlFuelLoop:
  asrb
  bcs txlNoPerfect
  deca
  bne txlFuelLoop
    ;perfect: all guns, all fuel, pod collected, planet destroyed, no lives lost
    ;ldd #2000
    lda PerfectBonus
    beq txlNoPerfect            ;no perfect, lost life
    ldb #100
    mul
    addd LocalBonus,s
    std LocalBonus,s
    mMakeTextCoord 6,8
    std ,y++
    ldd #PerfectString
    std ,y++
    mEmitSound PerfectBonusSoundId
txlNoPerfect:


  ;levelno*400 = (levelno*2)*200
  jsr SplitLevelNo              ;bonus is calced on level lo-nr
  lsla
  ldb #200
  mul
  addd LocalBonus,s
  std LocalBonus,s

  ldx LocalBonus,s
  leau LocalString2+6,s
  jsr Text_ConvertX

  mCombine d,10,-40
  std ,y++
  leax LocalString2,s
  stx ,y++

  clra
  clrb
  std ,y                        ;end word

  ;Add bonus to player score
  ;Givescore only handles 8-bit values so add the 16-bit bonus in 8-bit portions
  ;Not pretty but it works
txlGiveBonus:
  ldd LocalBonus,s
  cmpd #2000
  blo txlRestBonus
  subd #2000
  std LocalBonus,s
  mGiveScore 2000
  bra txlGiveBonus
txlRestBonus:
  cmpd #100
  blo txlBonusFin
  subd #100
  pshs d
  mGiveScore 100
  puls d
  bra txlRestBonus
txlBonusFin:

  leax LocalBuffer,s
  bra txlPrintAndExit


txlNoOrb:
  tst PowerLife
  bpl txlInComplete

  ;Planet destroyed, no orb: no bonus, advance mission
  ldx #FailedString
  leau LocalString1,s
  jsr Text_CopyString

  ldb CurLevel                  ;insert level no
  incb
  sex
  tfr d,x
  leau LocalString1+8-2,s
  jsr Text_ConvertX2

  leay LocalBuffer,s
  mCombine d,50,-60
  std ,y++
  ldx #PlanetString
  stx ,y++

  mCombine d,30,-70 + 6
  std ,y++
  leax LocalString1,s
  stx ,y++

  mCombine d,10,-40 + 6
  std ,y++
  ldx #NoBonusString
  stx ,y++

  clra
  clrb
  std ,y
  leax LocalBuffer,s
  bra txlPrintAndExit

txlInComplete:
  ;Exit without orb: stay on same mission
  ldx #InCompletePtr
  inc LocalLevelFin,s           ;level incomplete

txlPrintAndExit:

  lda GameMode
  cmpa #TimeAttackGame          ;skip text if time-attack
  beq txlSkipWait
    jsr Text_PrintWait
txlSkipWait:

txlExit:
  tst LocalLevelFin,s
  mFreeLocals
  direct -1
  rts
CompleteString:
  db "MISSION __ COMPLETE",$80
FailedString:
  db "MISSION __ FAILED",$80
PlanetString:
  db "PLANET DESTROYED",$80
BonusString:
  db "BONUS ____",$80
NoBonusString:
  db "NO BONUS",$80
InCompleteString:
  db "MISSION INCOMPLETE",$80
InCompletePtr:
  db 8,-50
  dw InCompleteString
  dw 0
PerfectString:
  db "PERFECT!",$80

;*****************
Text_GameOver:
  direct $c8
  mDecLocals 0,1,60
LocalString1 = LocalBuffer + 24
LocalString2 = LocalString1 + 20

;   GAME OVER
;
;   HARD GAME
;
;FINAL SCORE 20000
;    LEVEL 5
;
;  PRESS BUTTON

  ;test for highscore and bonusgame
  ldd Cheat
  bne tgoNoHighscore    ;no test if cheating

  ;enable bonusgame
  tst BonusGameEnabled
  bne tgoSkipBonusGame        ;skip if already enabled
  tst GameMode
  bne tgoSkipBonusGame        ;must be normal game
  lda CurLevel
  cmpa #LevelCountNormal-1    ;must have completed all levels
  ble tgoSkipBonusGame
    inc BonusGameEnabled
tgoSkipBonusGame:

  ldu #Highscores
  ldb #HighscoreEntry
  lda GameMode
  mul
  leau d,u
  ldx #PlayerScore
  lda #$80              ;temporarily store an end-byte so that we can call rom
  sta DigitCount,x
  ;check x vs u, copy to u if higher
  jsr check_4_new_hi_score
  tsta
  bpl tgoNoHighscore
    ;new highscore
    mEmitSound PerfectBonusSoundId
tgoNoHighscore:

  ldx #FinalScoreString         ;'final score'
  leau LocalString1,s
  jsr Text_CopyString

  ldx #PlayerScore              ;insert score
  leay LocalString1+12,s
  ldd ,x++
  std ,y++
  ldd ,x++
  std ,y++
  ldd ,x++
  std ,y++


  leay LocalBuffer,s
  lda #1
  sta ,y+                       ;wait for keypress flag

  mMakeTextCoord 1,19
;  mCombine d,-12,-70
  std ,y++
  leax LocalString1,s
  stx ,y++

  ldx #LevelReachedString       ;'level reached xx'
  leau LocalString2,s
  jsr Text_CopyString
  ldb CurLevel                  ;insert level no
  incb
  sex
  tfr d,x
  leau LocalString2+6-2,s
  jsr Text_ConvertX2
  mMakeTextCoord 2,8
  std ,y++
  leax LocalString2,s
  stx ,y++

;  ldd ShipFuel
;  bne tgoFuelOk
;  mCombine d,-22,-39
;  std ,y++
;  ldd #FuelString
;  std ,y++
;tgoFuelOk:

;  mCombine d,8,-32
  mMakeTextCoord -3,9
  std ,y++
  ldd #GameOverString
  std ,y++

;  mCombine d,-2,-40
  mMakeTextCoord -1,11
  std ,y++                      ;display game mode
  lda GameMode
  asla
  ldx #GameModeStringList
  ldx a,x
  stx ,y++

;  mCombine d,-116,-50
  mMakeTextCoord 10,12
  std ,y++
  ldd #PressButtonString
  std ,y++

  clr ,y+                       ;end word
  clr ,y+

  leax LocalBuffer,s
  jsr Text_PrintWait

  mFreeLocals
  direct -1
  rts
GameOverString:   db "GAME OVER",$80
;FuelString:       db "OUT OF FUEL",$80
FinalScoreString: db "FINAL SCORE ______0",$80
;NOTE 11 chars strings assumed by display highscore
GameModeString1: db "NORMAL GAME",$80
GameModeString2: db " HARD+ GAME",$80
GameModeString3: db "TIME ATTACK",$80
GameModeString4: db " ",$80     ;no title in bonusgame
GameModeStringList:
  dw GameModeString1,GameModeString2,GameModeString3,GameModeString4
PressButtonString: db "PRESS BUTTON",$80
LevelReachedString: db "LEVEL __",$80


;*****************
Text_Special:
  mDecLocals 0,0,20
  leay LocalBuffer,s

  ldx #SpecialStringsList
  lsla
  ldx a,x

  lda #8
  ldb ,x+
  std ,y++

  stx ,y++
  clr ,y+
  clr ,y+
  leax LocalBuffer,s
  jsr Text_PrintWait

  mFreeLocals
  rts
SpecialString1: db -50,'REVERSE GRAVITY',$80
SpecialString2: db -62,'INVISIBLE LANDSCAPE',$80
SpecialStringsList:
  dw SpecialString1,SpecialString2


mLine macro yy,str,xx
  db (-yy * 10)+30
  if \0=3
    db -60 + xx
  else
    db -60
  endif
  dw str
  endm


;*****************
Text_ShowDemoMenu:      ;dp=d0
  ldx #DemoMenuPtr
  jsr Text_PrintWait
  ;B holds key pressed
  rts

DemoMenu0: db "DEMO",$80
DemoMenu1: db "1. MISSION 1",$80
DemoMenu2: db "2. MISSION 2",$80
DemoMenu3: db "3. MISSION 3",$80
DemoMenu4: db "4. EXIT",$80
DemoMenuPtr:
  db 1
  mLine 1,DemoMenu0
  mLine 2,DemoMenu1
  mLine 3,DemoMenu2
  mLine 4,DemoMenu3
  mLine 5,DemoMenu4
  dw 0

;*****************
Text_ShowOptionsMenu:      ;dp=d0
  ldx #OptionsMenuPtr
  jsr Text_PrintWait
  ;B holds key pressed
  rts

OptionsMenu0: db "OPTIONS",$80
OptionsMenu1: db "1. CONTROLS",$80
OptionsMenu2: db "2. DEMO",$80
OptionsMenu3: db "3. RESET HIGHSCORES",$80
OptionsMenu4: db "4. EXIT",$80
OptionsMenuPtr:
  db 1,2
  mLine 1,OptionsMenu0
  mLine 2,OptionsMenu1
  mLine 3,OptionsMenu2
  mLine 4,OptionsMenu3
  mLine 5,OptionsMenu4
  dw 0

;*****************
CheatTemp = TemporaryArea ;Temp memory used by menu
Text_ShowCheatMenu:      ;dp=d0

  ldu #CheatTemp
  tst CheatLives
  beq tcmOff
    ldd #'ON'
    std ,u++
    bra tcmLivesFin
tcmOff:
    ldd #'OF'
    std ,u++
    stb ,u+
tcmLivesFin:
  lda #$80
  sta ,u+

  ldu #CheatTemp+4-2
  ldb CheatLevel
  incb
  sex
  tfr d,x
  jsr Text_ConvertX2
  ldb #$80
  stb 4,u

  ldx #CheatMenuPtr
  jsr Text_PrintWait
  ;B holds key pressed
  rts

CheatMenu0: db "CHEAT",$80
CheatMenu1: db "START LEVEL",$80
CheatMenuPtr:
  db 1,2
  mLine 3,CheatMenu0
    mLine 3,CheatTemp,100
  mLine 4,CheatMenu1
    mLine 4,CheatTemp+4,100
  dw 0

;*****************
Text_ShowGameMenu:      ;dp=d0
  ldx #GameMenuPtr
  jsr Text_PrintWait
  ;B holds key pressed
  rts

GameMenuCallback:
  mDecLocals 2,1,0

  ldx #$F0FD
  lda LoopCounterLow
  lsra
  anda #3
  lda a,x
  sta Pattern

  lda LoopCounterLow
  anda #127
  sta LocalB2,s

  lda #4
  sta LocalB1,s
gmcLoop:
  jsr reset0ref
  mSetIntensity $40

  lda LocalB2,s
  ldx #SineTable
  lda a,x

  asra
  adda #31
  adda #128

  mSetScale

  ldx #RefuelVectorList
  lda #4-1
  jsr FxMoveDrawPattern

  lda LocalB2,s
  adda #4
  bpl gmcNoWrap
    suba #128
gmcNoWrap:
  sta LocalB2,s

  dec LocalB1,s
  bne gmcLoop

  mFreeLocals
  rts

GameMenu0: db "SELECT GAME MODE",$80
GameMenu1: db "1. NORMAL",$80
GameMenu2: db "2. HARD+",$80
GameMenu3: db "3. TIME ATTACK",$80
GameMenuPtr:
  db 1,2
  db 3
  dw GameMenuCallback
  mLine 1,GameMenu0
  mLine 2,GameMenu1
  mLine 3,GameMenu2
  mLine 4,GameMenu3
  dw 0


;*****************
Text_ShowWellDone:      ;game completed
  mEmitSound PerfectBonusSoundId
  ldx #WellDonePtr
  jsr Text_PrintWait
  rts

WellDoneCallback:
  lda #100
  sta TitleLogoY
  jsr DrawTitleLogo
  lda #-100
  sta TitleLogoY
  jsr DrawTitleLogo
  rts

WellDone0: db 'WELL DONE!',$80
WellDonePtr:
  db 1,2
  db 3
  dw WellDoneCallback
  db 8,-40
  dw WellDone0
  dw 0


;*****************
Text_ShowControlMenu:      ;dp=d0, a=button to select
  mDecLocals 1,0,20

  sta LocalB1,s

  leax LocalBuffer,s
  lda #1
  sta ,x+
  mMakeTextCoord 0,32
  std ,x++
  ldd #ControlMenu0
  std ,x++

  mMakeTextCoord 0,1
  std ,x++
  lda LocalB1,s
  asla
  ldu #ControlStringList
  ldd a,u
  std ,x++
  clra
  clrb
  std ,x

  leax LocalBuffer,s
  jsr Text_PrintWait
  ;B holds key pressed
  mFreeLocals
  rts

ControlMenu0: db "PRESS BUTTON FOR:",$80
ControlMenu1: db "FIRE",$80
ControlMenu2: db "SHIELD/TRACTOR",$80
ControlMenu3: db "THRUST",$80
ControlMenu4: db "LOCK",$80
ControlStringList:
  dw ControlMenu1,ControlMenu2,ControlMenu3,ControlMenu4

;*****************
Text_ShowResetMenu:      ;dp=d0
  ldx #ResetMenuPtr
  jsr Text_PrintWait
  ;B holds key pressed
  rts

ResetMenu0: db "PRESS 2 TO RESET",$80
ResetMenuPtr:
  db 1,2
  mLine 1,ResetMenu0
  dw 0
