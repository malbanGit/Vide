; Vectrex Thrust main program
; Copyright (C) 2004  Ville Krumlinde

;----------------------------------------
; THRUST.ASM
;----------------------------------------

  opt   ;optimizations on
  include "def.asm"
  code
  org 0

  ;ROM-header
  db $67,$20
  db "GCE 2004",$80
  dw $FD0D      ;ptr to execrom-music
  db $FC,$30,  $72,$A8,  "THRUST FOR VECTREX 1.2",$80
  db $FC,$30,  $60,$A8,  "BY VILLE ",$6a,$80
  db $0

Boot:
  jsr eeprom_load

  ldd #$0103            ;init joystick
  std $c81f

;  jsr Zzap_Start        ;uncomment while debugging bonusgame

Start:
  mDptoD0

  jsr eeprom_save       ;save to eeprom if changed (options and highscores)
  jsr ShowTitleScreen

  mDptoC8               ;Set DP to C8 for game logic code

  clra
  jsr InitNewGame
  jsr PrepareLevel

MainLoop:
  mDptoC8               ;Set DP to C8 for game logic code

  jsr Ship_Update
  jsr UpdateFx
  jsr UpdateGuns
  jsr UpdateShipShots
  jsr UpdateGunShots
  jsr UpdateDoors
  jsr AdjustFuel
  jsr UpdateFrameCounter
  jsr UpdateSound

  mTestFlag GameOverFlag
  bne GameOver

  jsr SetView
  jsr RefreshDrawList

  ;Wait for screen sync
  ;DP is D0 after call to waitrecal
  ;Keep DP at D0 for draw vector code
  jsr waitrecal

  jsr UpdateSoundChip
  jsr DrawLevel
  jsr Ship_Draw
  jsr DrawShipShots
  jsr DrawGuns
  jsr DrawFuel
  jsr DrawFx
  jsr DrawGunShots
  jsr DrawOrb
  jsr DrawPowerplant
  jsr DrawStars
  jsr DrawDoors
  jsr DrawSwitches
  jsr DrawDisplay

  bra MainLoop

GameOver:
  lda DemoMode                  ;do not display 'game over' in demo mode
  bmi maiIsDemo
    jsr Text_GameOver
maiIsDemo:

  direct -1
  bra Start



  direct $c8
  include "clip.asm"
  direct -1

  include "Thrust_Sound.asm"
  include "Thrust_Fx.asm"
  include "Thrust_Ship.asm"


;*****************
UpdateFrameCounter:
  direct $c8
  lda FrameCounter
  bpl ufcOkCnt3
    ora #$40
ufcOkCnt3:
  adda #$40
  sta FrameCounter

  anda #$3f
  bne ufcOkCnt64
    lda #$3f
    bra ufcDoAdd
ufcOkCnt64:
  lda #$ff
ufcDoAdd:
  adda FrameCounter
  sta FrameCounter

 if false
    ;Atari 2600 code
    lda     FrameCnt            ; 3
    sta     FrameCnt1
    bpl     .okCnt3             ; 2�
    ora     #$40                ; 2         reset Cnt3
.okCnt3:
    clc                         ; 2
    adc     #$40                ; 2         increase Cnt3
    sta     FrameCnt            ; 3

    and     #$3f                ; 2
    bne     .okCnt64            ; 2�
    lda     #$3f                ; 2         reset Cnt64
    BIT_W                       ; 2
.okCnt64:
    lda     #$ff                ; 2         increase Cnt64
    clc                         ; 2
    adc     FrameCnt            ; 3
    sta     FrameCnt            ; 3 = 28-32
  endif

  direct -1
  rts


;*****************
DrawDisplay:            ;Draw status panel. Copy to buffer and print as a single string.
  lda DemoMode          ;no display in demomode
  bpl ddGoOn
    rts
ddGoOn:
  mDecLocals 0,0,20

  leau LocalBuffer,s

  lda GameMode
  cmpa #TimeAttackGame
  bne ddNoTimeAttack

  ldd #'TI'
  std ,u++
  ldd #'ME'
  std ,u++
  ldd #': '
  std ,u++
  ldb TimeAttackTime    ;time, flash if low
  cmpb #10
  bge ddDoTime
  lda LoopCounterLow
  anda #8
  bne ddDoTime
  ldd #'  '
  std ,u
  std 2,u
  bra ddTimeFin
ddDoTime:
  clra
  tfr d,x
  jsr Text_ConvertX
ddTimeFin:
  ldb #$80              ;end byte
  stb 4,u
  bra ddDoDraw

ddNoTimeAttack:         ;normal game
  ldx #PlayerScore      ;copy score to buffer
  ldb #' '
  bsr CopyScoreFromXtoU

  leau 7,u              ;Nr of ships left
  stb ,u
  lda ShipLives
  adda #'0'
  std 1,u

  leau 3,u              ;Fuel, flash if low
  lda GameMode
  cmpa #BonusGame
  bne ddNotBonus
    ;In bonusgame, draw current level instead of fuel
    ldb CurLevel
    clra
    tfr d,x
    bra ddDrawFuel
ddNotBonus
  ldx ShipFuel
  cmpx #300
  bge ddDrawFuel
  lda LoopCounterLow
  anda #8
  bne ddDrawFuel
ddSkipFuel:
  ldd #'  '
  std ,u
  std 2,u
  bra ddFuelFin
ddDrawFuel:
  jsr Text_ConvertX
ddFuelFin:
  ldb #$80              ;End byte
  stb 4,u

ddDoDraw:
  lda #114
  ldb #-127 + 50
  leax LocalBuffer,s
  jsr Text_Print

  mFreeLocals
  rts

CopyScoreFromXtoU:      ;u=destination buffer, b=end byte
  stb -1,s
  ldd ,x
  std ,u
  ldd 2,x
  std 2,u
  ldd 4,x
  std 4,u
  lda #$30            ;extra zero + end byte
  ldb -1,s
  std 6,u
  rts

;*****************
GiveScoreA:
MAX_LIVES = 9
  ldb DemoMode          ;no score in demomode
  bpl gsaGoOn
    rts
gsaGoOn:
  pshs x,u
  ldx #PlayerScore
  ldy 2,x
  jsr convert_a_to_bcd_and_add
  tfr y,d
  cmpa 2,x              ;extra life each 10000 points
  beq gsaExit
    lda GameMode
    cmpa #HardGame      ;every 20000 for hard mode
    bne gsaExtra
      lda 2,x
      anda #1
      bne gsaExit
gsaExtra:
    lda ShipLives
    cmpa #MAX_LIVES
    beq gsaExit
    inc ShipLives
    mEmitSound ExtraLifeSoundId
gsaExit:
  puls x,u
  rts





;*****************
AdjustFuel:                     ;Update ship fuel amount
  direct $c8
  mDecLocals 1,0,0

  lda FrameCounter
  anda #FRAME3MASK
  bne afExit

  tst CheatLives
  bne afExit

  mTestFlag InactiveFlag
  bne afExit

  ;if refueling, inc 1
  ;else
  ;  if shield -1
  ;  if thrust -1 (if hasorb extra -1)

  clr LocalB1,s

  mTestFlag RefuelFlag
  bne afRefueling

  mTestFlag ThrustFlag
  beq afTestShield
    dec LocalB1,s
;    mTestFlag HasOrbFlag
;    beq afTestShield
;      dec LocalB1,s
afTestShield:
  mTestFlag ShieldFlag
  beq afStore
    dec LocalB1,s
    bra afStore

afRefueling:
  lda #16
  sta LocalB1,s

afStore:
  ldb LocalB1,s
  beq afExit
  sex
  addd ShipFuel
  bpl afOk
    clra
    clrb
afOk:
  std ShipFuel
afExit:

  mFreeLocals
  direct -1
  rts


;*****************              ;See if it's time to emit a new gun shot.
;List of center angle for each gun type
;NE,NW,SE,SW
GunShotAngles: db -8,8,-24,24

UpdateGuns:
  mDecLocals 2,2
LocalAngle = LocalB2
LocalGun = LocalW2
MaxGunDistance = 120            ;Minimum distance from firing gun to ship
  direct $c8

  lda GunShotTimer              ;Check delay timer
  beq ugTimeOk
    deca
    sta GunShotTimer
    lbra ugFin

ugTimeOk:
  lda GunShotActive             ;Exit if no empty slot
  cmpa #GunShotAllActive
  lbeq ugFin

  tst PowerShot                 ;Exit if guns are disabled (powerplant recently shot)
  lbne ugFin

  ldu CurLevelEntry             ;Find a gun that can fire
  ldu leGuns,u
  lbeq ugFin                    ;exit if no guns
  ldb ,u+                       ;load guncount
  stb LocalB1,s
  ldd GunsActive
ugGunLoop:
  asra
  rorb
  bcc ugGunNotActive
  std LocalW1,s

  ldd geGunX,u
  subd ShipX
  mTestRangeD -MaxGunDistance,MaxGunDistance,ugNextGun

  ldd geGunY,u
  subd ShipY
  mTestRangeD -MaxGunDistance,MaxGunDistance,ugNextGun

  ;Gun can shoot, throw a dice to see if choose this gun
  ;Otherwise the first closest gun would always fire
  mRandomToA
  anda #3
  bne ugNextGun

  stu LocalGun,s
  bra ugGunFound

ugNextGun:
  ldd LocalW1,s
ugGunNotActive:
  leau GunEntry,u
  dec LocalB1,s
  bne ugGunLoop
  jmp ugFin                     ;No gun was found, exit
ugGunFound:

  lda #0                        ;Find a free gunshot-slot
  ldb GunShotActive
  ldu #GunShots
ugLoop:
  asrb                          ;test active
  bcs ugAlreadyActive
  std LocalW1,s

  ldx LocalGun,s                ;Slot found, emit shot
  ldd geGunX,x
  std gsShotX,u
  ldd geGunY,x
  std gsShotY,u

  lda geGunSprite,x
  ldx #GunShotAngles
  ldb a,x

  ;16 is 90 deg

  ;gun can shoot in 135 deg (0..23)
  ;repeat until we have a random value 0..23
  ldx #0
ugRndAngle:
  leax 1,x
  cmpx #5                       ;bailout after 5 iterations
  bne ugRndAngle1
    lda #12
    bra ugRndAngle2
ugRndAngle1:
  mRandomToA
  ;improve randomness by xoring loopcounter
  eora LoopCounterLow
  anda #31
  cmpa #23
  bhi ugRndAngle
ugRndAngle2:
  suba #12                      ;a is -12..11

  sta -1,s
  addb -1,s                     ;final angle is gun center + random
  stb LocalAngle,s

  ldb LocalAngle,s              ;Calc rise & run
  lda GunShotSpeed              ;scale

  jsr convert_angle_to_rise_run ;dp must be c8
  nega                          ;Y axis points down in our world
  sta gsShotVelocY,u
  stb gsShotVelocX,u

  lda LocalW1,s                 ;Set shot active
  mSetBitA GunShotActive

  mRandomToA                    ;Reset delay for next shot
  anda GunShotMask
  adda GunShotDelay
  sta GunShotTimer

  ;mEmitSound GunFireSoundId
  ldu CurLevelEntry             ;Get index of firing gun, use for fx
  ldu leGuns,u
  ldb ,u
  subb LocalB1,s
  mEmitFx FxTargetGun,FxTypeGunFire,b

  bra ugFin                     ;Exit

ugNext:
  ldd LocalW1,s
ugAlreadyActive:
  leau GunShotEntry,u
  inca
  cmpa #MaxGunShots
  bne ugLoop

ugFin:
  direct -1
  mFreeLocals
  rts


;*****************              ;Update active gun shots.
UpdateGunShots
  mDecLocals 0,1
  direct $c8

  lda #0                        ;loop from 0 to MaxGunShots
  ldb GunShotActive
  ldu #GunShots
gsMoveLoop:
  asrb                          ;test active
  lbcc gsNotActive
  std LocalW1,s

  ;Move
  mUpdateXCoord gsShotX, gsShotVelocX
  mUpdateYCoord gsShotY, gsShotVelocY, gsRemoveShot

  mTestFlag HomingGunShotsFlag
  beq gsNoHoming
  ;Try to make the homing missiles move unpredictably
  ;Skip homingness a while each second to avoid them constantly circling ship
  lda LoopCounterLow
  cmpa #32
  blo gsNoHoming
  anda #1
  beq gsNoHoming
  lda LocalW1,s
  anda #1
  bne gsNoHoming
ShotVelocXMax=12
  ldd ShipX
  cmpd gsShotX,u
  blo gsHomeXDec
    lda gsShotVelocX,u
    cmpa #ShotVelocXMax
    bge gsHomeXFin
    inca
    sta gsShotVelocX,u
;    inc gsShotVelocX,u
    bra gsHomeXFin
gsHomeXDec:
    lda gsShotVelocX,u
    cmpa #-ShotVelocXMax
    ble gsHomeXFin
    deca
    sta gsShotVelocX,u
;    dec gsShotVelocX,u
gsHomeXFin

ShotVelocYMax=12
  ldd ShipY
  cmpd gsShotY,u
  blo gsHomeYDec
    lda gsShotVelocY,u
    cmpa #ShotVelocYMax
    bge gsHomeYFin
    inca
    sta gsShotVelocY,u
    bra gsHomeYFin
gsHomeYDec:
    lda gsShotVelocY,u
    cmpa #-ShotVelocYMax
    ble gsHomeYFin
    deca
    sta gsShotVelocY,u
gsHomeYFin

gsNoHoming:

  ldy #ShipX                    ;Collision gunshots vs ship
  mPointVsArea ShipArea,gsShipOk, gsShotX,gsShotY, 0,2
    mTestFlag ShieldFlag        ;if shield, just remove shot
    bne gsShipSkipExplode
      jsr ExplodeShip
gsShipSkipExplode:
    bra gsRemoveShot
gsShipOk:

  mTestFlag HasOrbFlag          ;Collision gunshots vs pod
  beq gsPodOk
    ldy #PodX
    mPointVsArea PodArea,gsPodOk, gsShotX,gsShotY, 0,2
      jsr ExplodeShip
      bra gsRemoveShot
gsPodOk:

  ldy gsShotY,u                 ;Collision shots vs level
  ldx gsShotX,u
  jsr PointVsLevel
  bcc gsNoHit
    bra gsRemoveShot
gsNoHit:

  bra gsMoveNext
gsRemoveShot:
  lda LocalW1,s                 ;a is current loop index, clear this bit to remove shot
  mClearBitA GunShotActive

gsMoveNext:
  ldd LocalW1,s
gsNotActive:
  leau GunShotEntry,u
  inca
  cmpa #MaxGunShots
  bne gsMoveLoop

  direct -1
  mFreeLocals
  rts



;*****************
DrawGunShots:
  ;DP must be D0
  mDecLocals 0,2,4

  mSetScale $7f                 ;Scale $7f is required for move_pen_d to reach whole screen

  ldx #GunShots                 ;Draw all active shots.
  lda #MaxGunShots
  ldb GunShotActive
dgsLoop:
  asrb                          ;test active
  bcc dgsNotActive
  std LocalW1,s

  mTestFlag HomingGunShotsFlag
  bne dgsHoming

dgsNormal:
  stx LocalW2,s
  leau LocalBuffer,s
  ldd gsShotX,x
  std ,u
  ldd gsShotY,x
  std 2,u
  lda #$7f
  jsr DrawDot
  ldx LocalW2,s
  bra dgsNext

dgsHoming:
  lda LocalW1,s
  anda #1
  beq dgsNormal

  stx LocalW2,s
  leau LocalBuffer,s
  ldd gsShotX,x
  std ,u
  ldd gsShotY,x
  std 2,u
  lda #$7f
  jsr DrawBullet
  ldx LocalW2,s

  ;Draw a 'tail' on the homing shots by subtracting velocity to draw a dot at the previous position
  leau LocalBuffer,s
  ldb gsShotVelocX,x
  negb
  asrb
  asrb
  sex
  addd ,u
  std ,u
  ldb gsShotVelocY,x
  negb
  asrb
  asrb
  sex
  addd 2,u
  std 2,u
  lda #$34
  jsr DrawBullet
  ldx LocalW2,s

dgsNext:
  ldd LocalW1,s
dgsNotActive:
  leax GunShotEntry,x
  deca
  bne dgsLoop

  mFreeLocals
  rts



;*****************
DrawFuel:                       ;Draw active fuel pods on level
FrameSize set 2                 ;Size of stack frame
Local1 set 0
  ;DP must be D0
  leas    -FrameSize,s

  mSetIntensity $5f

  ldu CurLevelEntry
  ldu leFuel,u
  beq dfExit                    ;exit if no fuel pods
  ldb FuelActive
  lda ,u+                       ;load count
dfLoop:
  asrb                          ;test active
  bcc dfNext

  std Local1,s

  ldx #SpriteFuelCell
  jsr DrawSprite

  ldd Local1,s

dfNext:
  leau FuelEntry,u
  deca
  bne dfLoop

dfExit:
  leas    FrameSize,s
  rts


;*****************
DrawOrb:                        ;Draw stationary orb + platform on level
  ;DP must be D0

  mTestFlag HasOrbFlag          ;Exit if ship is carrying orb
  bne doExit

  mSetIntensity $5f

  ldu CurLevelEntry
  leau leOrbX,u
  ldx #SpriteStationaryPod
  jsr DrawSprite

doExit:
  rts


;*****************
DrawPowerplant:                 ;Draw powerplant on level
  ;DP must be D0
  mDecLocals 0,1,10

  ldb PowerShot                 ;Decrease gun disabled timer
  beq dpSkip
  lda LoopCounterLow
  anda #31
  bne dpSkip
  decb
  stb PowerShot
dpSkip:

  lda PowerLife                 ;Flash if about to explode
  bpl dpDraw
    leax LocalBuffer,s
    nega                        ;Display countdown
    adda #'0'-1
    ldb #' '                    ;ROM display must print at least 2 characters
    stb ,x
    ldb #$80
    std 1,x

    lda LoopCounterLow
    anda #63
    nega
    adda #64
    sta LocalW1,s
    lsra
    lsra
    nega
    ldb #$70
    std   $C82A           ;Specify height and width
    jsr reset0ref
    mCombine d,-30,-30
    adda LocalW1,s
    jsr move_pen_d
;    lda #$40
;    suba LocalW1,s
    mTicToc 64
    adda #32
    mSetIntensity

    tfr x,u
    jsr display_string

    lda LoopCounterLow
    anda #63
    bne dpNoAdjustCounter
      mEmitSound CountdownSoundId
      inc PowerLife
      lda PowerLife
      cmpa #-1
      bne dpNoAdjustCounter
        ;Planet exploded
        mEmitFx FxTargetShip,FxTypePlanetExplode,0
        jsr ExplodeShip
        bra dpExit
dpNoAdjustCounter:

    lda LoopCounterLow
    anda #8
    beq dpExit
dpDraw:
  mSetIntensity $5f

  ldu CurLevelEntry
  leau lePowerX,u
  stu LocalW1,s
  ldx #SpritePowerplant
  jsr DrawSprite

  tst PowerShot                 ;draw rising dot if active
  bne dpExit

  ldx LocalW1,s
  leau LocalBuffer,s
  ldd ,x
  addd #9
  std ,u
  ldd 2,x
  subd #12
  std -2,s
  ldb LoopCounterLow
  andb #15
  lsrb
  negb
  sex
  addd -2,s
  std 2,u
  lda #$60
;  jsr DrawDot
  jsr DrawBullet

dpExit:

  mFreeLocals
  rts


;*****************
DrawGuns:                       ;Draw active guns on level
  mDecLocals 1,1

  ;DP must be D0
  mSetIntensity $5f

  ldu CurLevelEntry
  ldu leGuns,u
  beq dgExit                    ;exit if no guns
  lda ,u+                       ;load guncount
  sta LocalB1,s
  ldd GunsActive
dgLoop:
  asra
  rorb
  bcc dgNext

  std LocalW1,s

  lda geGunSprite,u             ;sprite entry
  asla
  ldx #GunSpriteTable
  ldx a,x
  jsr DrawSprite

  ldd LocalW1,s

dgNext:
  leau GunEntry,u
  dec LocalB1,s
  bne dgLoop

dgExit:
  mFreeLocals
  rts

GunSpriteTable:
  dw SpriteGunNE,SpriteGunNW,SpriteGunSE,SpriteGunSW



;*****************
DrawSwitches:                   ;Draw door switches
  ;DP must be D0
  mDecLocals 1,0,0

  mSetIntensity $5f

  ldu CurLevelEntry
  ldu leSwitches,u
  lda ,u+                       ;load count
  beq dswExit                   ;exit if no switches
dswLoop:
  sta LocalB1,s

  lda seSwitchDir,u
  beq dswDrawLeft
  ldx #SpriteSwitchRight
  bra dswDraw
dswDrawLeft:
  ldx #SpriteSwitchLeft
dswDraw:
  jsr DrawSprite

  lda LocalB1,s
dswNext:
  leau SwitchEntry,u
  deca
  bne dswLoop

dswExit:
  mFreeLocals
  rts



;*****************
UpdateDoors:
  ;  DoorCounter
  ;    0  : st�ngd, exit
  ;    bit 7
  ;      0 : opening
  ;          �ka med 1, om max s�tt bit 7
  ;      1 : closing
  ;          minska med 1, om noll clear bit 7
  ;      >=DoorSize : fully open
  direct $c8

  lda LoopCounterLow
  anda #4
  beq udoExit

  lda DoorCounter
  beq udoExit
  bmi udoClosing

  inca
  bvs udoSetClose
  sta DoorCounter
  bra udoExit
udoSetClose:
  lda #DoorSize
  ora #%10000000
  sta DoorCounter
  bra udoExit

udoClosing:
  anda #%01111111
  deca
  beq udoSetOpen
  ora #%10000000
  sta DoorCounter
  bra udoExit

udoSetOpen:
  lda #0
  sta DoorCounter

udoExit:

  direct -1
  rts


;*****************
;Lines for doors are generated on stack, then drawn with clipdraw
DrawDoors:
DoorLineSize = 25               ;Size of buffer to hold lines
DoorListSize = 25               ;Size of buffer to hold drawlist for lines (5*linecount)
  mDecLocals 3,0,DoorLineSize+DoorListSize
LocalDoorLines = LocalBuffer
LocalDoorList  = LocalBuffer+DoorLineSize
LocalOpen = LocalB2
LocalTmp = LocalB3

  lda DoorCounter
  anda #%01111111
;  cmpa #DoorSize
;  lbge dorExit                  ;doors are fully opened, exit
  sta LocalOpen,s               ;amount to open door

  mSetIntensity WallIntensity

  ldu CurLevelEntry
  ldu leDoors,u

  lda ,u+                       ;load count
  lbeq dorExit
dorLoop:
  sta LocalB1,s

  leax LocalDoorLines,s
  leay LocalDoorList,s
  sty ,x++
  ldd deDoorY,u
  std ,x++
  ldd deDoorX,u
  std ,x++

  lda deDoorDir,u
  asla
  ldy #dorTable
  jmp [a,y]

dorTable:
  dw dorRightDoor,dorUpDoor,dorInvertRightDoor,dorUpDoorWalls

dorRightDoor:                           ;draw door closing right, 1*2 tiles
  ;--
  ;  |
  ;--
  ;positive y is down, positive x is right
  ;  db 1  ;line count
  ;  db 1  ;linetype, 0=vert, 1=horiz, 2=slope
  ;  db FullW,0  ;x0,y0
  ;  db 0,HalfH  ;x1,y1
  lda LocalOpen,s
  cmpa #DoorSize
  lbge dorNext
  asla
  sta LocalTmp,s

dorDoHoriz:
  lda LocalTmp,s
  cmpa #TileW*2
  lbhs dorNext

  lda #3
  sta ,x+

  lda #1        ;line 1
  sta ,x+

  clra
  sta ,x+
  sta ,x+

  lda #TileW*2
  suba LocalTmp,s
  sta ,x+
  clra
  sta ,x+


  clra          ;line 2
  sta ,x+

  lda #TileW*2
  suba LocalTmp,s
  sta ,x+
  clra
  sta ,x+

  lda #TileW*2
  suba LocalTmp,s
  sta ,x+
  lda #TileH
  sta ,x+


  lda #1        ;line 3
  sta ,x+

  clra
  sta ,x+
  lda #TileH
  sta ,x+

  lda #TileW*2
  suba LocalTmp,s
  sta ,x+
  lda #TileH
  sta ,x+

  jmp dorDraw


dorUpDoor:                      ;draw door closing up, 2*2 tiles
  ;----
  ;____
  ;positive y is down, positive x is right
  ;  db 1  ;line count
  ;  db 1  ;linetype, 0=vert, 1=horiz, 2=slope
  ;  db FullW,0  ;x0,y0
  ;  db 0,HalfH  ;x1,y1
  lda LocalOpen,s
  cmpa #DoorSize
  lbge dorNext

  lda #2
  sta ,x+

  ;Bottom line, fixed
  lda #1
  sta ,x+

  lda #0
  sta ,x+
  lda #TileH*2
  sta ,x+

  lda #TileW*2
  sta ,x+
  lda #TileH*2
  sta ,x+


  ;Top line, this moves down when door opens
  lda #1
  sta ,x+

  clra
  sta ,x+
  adda LocalOpen,s              ;add twice, tileh=2*tilew
  adda LocalOpen,s
  sta ,x+

  lda #(TileW*2)
  sta ,x+
  clra
  adda LocalOpen,s              ;add twice, tileh=2*tilew
  adda LocalOpen,s
  sta ,x+
  bra dorDraw

dorInvertRightDoor:
  lda LocalOpen,s
  nega
  adda #DoorSize
  bpl dorInvertR1
    clra
dorInvertR1:
  asla
  sta LocalTmp,s
  bra dorDoHoriz


dorUpDoorWalls:                      ;draw door closing up, 2*2 tiles
  ; ----
  ;|    |
  ;|    |
  ;positive y is down, positive x is right
  ;  db 1  ;line count
  ;  db 1  ;linetype, 0=vert, 1=horiz, 2=slope
  ;  db FullW,0  ;x0,y0
  ;  db 0,HalfH  ;x1,y1
  lda LocalOpen,s
  cmpa #DoorSize
  lbge dorNext

  lda #3
  sta ,x+

  ;Left wall
  clra
  sta ,x+       ;linetype
  sta ,x+       ;x0
  adda LocalOpen,s
  adda LocalOpen,s
  sta ,x+       ;y0
  clra
  sta ,x+       ;x1
  lda #(TileH*2)
  sta ,x+       ;y1

  ;Right wall
  clra
  sta ,x+       ;linetype
  lda #(TileW*2)
  sta ,x+       ;x0
  lda LocalOpen,s
  adda LocalOpen,s
  sta ,x+       ;y0
  lda #(TileW*2)
  sta ,x+       ;x1
  lda #(TileH*2)
  sta ,x+       ;y1

  ;Top line, this moves down when door opens
  lda #1
  sta ,x+

  clra
  sta ,x+
  adda LocalOpen,s              ;add twice, tileh=2*tilew
  adda LocalOpen,s
  sta ,x+

  lda #(TileW*2)
  sta ,x+
  clra
  adda LocalOpen,s              ;add twice, tileh=2*tilew
  adda LocalOpen,s
  sta ,x+
  bra dorDraw


dorDraw:
  leay LocalDoorLines,s
  lda #WallIntensity
  bsr ClipDraw

dorNext:
  lda LocalB1,s
  leau DoorEntry,u
  deca
  lbne dorLoop

dorExit:
  mFreeLocals
  rts


;*****************
ClipDraw:              ;a=intensity, y points to: destlinesptr,offsety,offsetx,abslines
  ;**todo: this will not work when x-world-wrap is on screen
  ;_CohenSutherlandClip is not aware of world-wrap
  ;clipX coord will need to be adjusted to ViewX+Screen(clipX)

  ldx ,y++                      ;destlines

  pshs a,dp                     ;save intensity + dp
  mDptoC8                       ;clip needs c8
  ldd ,y++
  std ,--s                      ;offset y
  ldd ,y++
  std ,--s                      ;offset x
  stx ,--s                      ;pointer to destination drawlist
  sty ,--s                      ;pointer to lines
  jsr _CohenSutherlandClip
  leas  8,s
  puls dp,a                     ;restore dp + intensity
  tstb
  beq cdrExit                   ;empty list, all is clipped

  clr b,x                       ;write end of drawlist, b holds nr of bytes written

  ;a holds intensity
  jsr GoDrawList

cdrExit:
  direct -1
  rts



;*****************
DrawDot:                        ;a=intensity,  u=pointer to x,y
  mDecLocals 3,0
LocalTempX = LocalB1
LocalTempY = LocalB2
LocalInt = LocalB3
  sta LocalInt,s

  ;X coord
  mGetScreenX ,u
  bmi ddExit                    ;offscreen, skip
  tsta
  bne ddExit                    ;offscreen, skip

  subb #128
  stb LocalTempX,s

  ;Y coord
  ldd 2,u
  subd ViewY
  bmi ddExit                    ;offscreen, skip
  tsta
  bne ddExit                    ;offscreen, skip

  stb LocalTempY,s
  jsr reset0ref                 ;this dot should be drawn, reset pen
  mSetScale $7f
  lda LocalInt,s
  mSetIntensity
  lda LocalTempY,s

  nega
  adda #127
  ldb LocalTempX,s

  mMove_pen_d_Quick
  mDot_at_current_position 1
ddExit:
  mFreeLocals
  rts


;*****************
DrawBullet:                        ;a=intensity,  u=pointer to x,y
  mDecLocals 3,0
LocalTempX = LocalB1
LocalTempY = LocalB2
LocalInt = LocalB3
  sta LocalInt,s

  ;X coord
  mGetScreenX ,u
  bmi dbExit                    ;offscreen, skip
  tsta
  bne dbExit                    ;offscreen, skip

  subb #128
  stb LocalTempX,s

  ;Y coord
  ldd 2,u
  subd ViewY
  bmi dbExit                    ;offscreen, skip
  tsta
  bne dbExit                    ;offscreen, skip

  stb LocalTempY,s
  jsr reset0ref                 ;this dot should be drawn, reset pen
  mSetScale $7f
  lda LocalInt,s
  mSetIntensity
  lda LocalTempY,s

  nega
  adda #127
  ldb LocalTempX,s

  mMove_pen_d_Quick
  bsr DrawBulletAtCurrentPosition
;  clra  ;z if visible
dbExit:
  mFreeLocals
  rts


;*****************
 ;Quick draw macros

_QpenOn macro
  lda   #0xFF ;pen on
  sta   <0x0A
 endm

_QpenOff macro
  clr   <0x0A ;pen off
 endm

_Qmove macro xx,yy,ww
One = ($20-1)/2
  mCombine d,xx*One,yy*One
  sta   <0x01
  clr   <0x00
  inc   <0x00
  stb   <0x01
  clr   <0x05
  if 1\3=11
    ;need to wait for long lines (third param=1)
    ldb   #0x40
wait\?
    bitb  <0x0D
    beq   wait\?
  endif
 endm


;*****************
DrawBulletAtCurrentPosition:
  mSetScale 1

;  _db1 -1,-1

  _Qmove 2,-1

  _QpenOn

  _Qmove 0,2
  _Qmove -1,1
  _Qmove -2,0
  _Qmove -1,-1
  _Qmove 0,-2
  _Qmove 1,-1
  _Qmove 2,0
  _Qmove 1,1

 if false
  _db1 2,0
  _db1 0,2
  _db1 -2,0
  _db1 0,-2
 endif

  _QpenOff

  rts


;*****************
DrawPlusAtCurrentPosition:  ;a=scale
  mSetScale

  ;negative y is down, negative x is left

  _Qmove -2,0,1
  _QpenOn
  _Qmove 4,0,1
  _QpenOff
  _Qmove -2,2,1
  _QpenOn
  _Qmove 0,-4,1
  _QpenOff

  rts


;*****************
DotShatter:                     ;u=pointer to x,y   a=time
  mDecLocals 1,3,4
LocalInt = LocalB1
LocalPos = LocalW1
LocalNeg = LocalW2
LocalPtr = LocalW3

  ;Calc intensity based on time
  ldb #$7f
  sta -1,s
  subb -1,s
  subb -1,s
  bpl dsIntPositive
    clrb
dsIntPositive:
  stb LocalInt,s

  ldb LoopCounterLow
  andb #1
  beq dsSkip1
    lsra
dsSkip1:

  tfr a,b
  clra
  std LocalPos,s
  negb
  sex
  std LocalNeg,s

  stu LocalPtr,s
  leau LocalBuffer,s

mShatter macro xmod,ymod
  ldy LocalPtr,s
  ldd ,y
  if xmod!=-1
    addd xmod,s
  endif
  std ,u
  ldd 2,y
  if ymod!=-1
    addd ymod,s
  endif
  std 2,u
  lda LocalInt,s
  jsr DrawDot
  endm

  mShatter LocalNeg,LocalNeg
  mShatter -1,LocalNeg
  mShatter LocalPos,LocalNeg

  mShatter LocalNeg,-1
  mShatter LocalPos,-1

  mShatter LocalNeg,LocalPos
  mShatter -1,LocalPos
  mShatter LocalPos,LocalPos

  mFreeLocals
  rts



;*****************
DrawSprite:                     ;Draw a single sprite  u=pointer to x,y  x=lines
  mDecLocals 1,2
  ;DP must be D0

  stx LocalW1,s

  mGetScreenX 0,u               ;X coord
  bmi drExit                    ;offscreen, skip
  tsta
  bne drExit                    ;offscreen, skip

  subb #128
  stb LocalB1,s

  ldd 2,u                       ;Y coord
  subd ViewY
  bmi drExit                    ;offscreen, skip
  tsta
  bne drExit                    ;offscreen, skip

  negb
  tfr b,a
  ldb LocalB1,s
  adda #127

  std LocalW2,s
  mSetScale $7f                 ;Scale $7f is required for move_pen_d to reach whole screen
  jsr reset0ref
  ldd LocalW2,s
  mMove_pen_d_Quick

  ldx LocalW1,s
  lda ,x+                       ;Nr of vectors in list
drLoop:
  ldb #DrawScale                ;Scale
  jsr move_draw_VL4             ;Draw list
  lda ,x+                       ;Get next count, $ff ends
  bpl drLoop
drExit:

  mFreeLocals
  rts



;*****************
UpdateShipShots:                ;Move all active shots.
  direct $c8
  mDecLocals 3,2
Local1 = LocalW1
Local2 = LocalW2
LocalGunCount = LocalB2
LocalFuelCount = LocalB2        ;fuel use same temp as gun
LocalCount = LocalB2

  ldu #ShipShotList
  lda #ShipShotCount
ussLoop:
  sta LocalB3,s                  ;spill loop index
  tst ssShotActive,u
  lbeq ussNext

  ;Move shots
  mUpdateXCoord ssShotX, ssShotVelocX
  mUpdateYCoord ssShotY, ssShotVelocY, ussRemoveShot

  ldy ssShotY,u                 ;Collision shots vs level
  ldx ssShotX,u
  jsr PointVsLevel
  bcc ussNoHit
    jmp ussRemoveShot          ;remove shot
ussNoHit:

  ldy CurLevelEntry             ;Collision shots vs guns
  ldy leGuns,y
  lbeq ussNoGuns
  lda ,y+                       ;load guncount
  sta LocalGunCount,s
  sta LocalB1,s
  ldd GunsActive
ussGunLoop:
  asra
  rorb
  bcc ussNextGun
  std LocalW1,s
  mPointVsArea GunArea,ussGunMiss, ssShotX,ssShotY, geGunX,geGunY
    lda LocalGunCount,s         ;hit, clear active bit of gun
    suba LocalB1,s
    mClearWordBitA GunsActive

    ldb LocalGunCount,s         ;gun index
    subb LocalB1,s
    mEmitFx FxTargetGun,FxTypeDotShatter,b

    ldb LocalGunCount,s         ;gun index
    subb LocalB1,s
    mEmitFx FxTargetGun,FxTypeScore750,b

    mGiveScore 750
    jmp ussRemoveShot           ;remove shot
ussGunMiss:
  ldd LocalW1,s
ussNextGun:
  leay GunEntry,y
  dec LocalB1,s
  bne ussGunLoop
ussNoGuns:


  ldy CurLevelEntry             ;Collision shots vs fuel
  ldy leFuel,y
  beq ussNoFuel
  lda ,y+                       ;load count
  sta LocalFuelCount,s
  clra
  ldb FuelActive
ussFuelLoop:
  asrb
  bcc ussNextFuel
  std LocalW1,s
  mPointVsArea FuelArea,ussFuelMiss, ssShotX,ssShotY, 0,2
    lda LocalW1,s               ;hit, clear active bit of fuel
    mClearBitA FuelActive

    ldb LocalW1,s               ;fuel cell index
    mEmitFx FxTargetFuel,FxTypeDotShatter,b

    ldb LocalW1,s               ;fuel cell index
    mEmitFx FxTargetFuel,FxTypeScore150,b

    mGiveScore 150
    jmp ussRemoveShot           ;remove shot
ussFuelMiss:
  ldd LocalW1,s
ussNextFuel:
  leay FuelEntry,y
  inca
  cmpa LocalFuelCount,s
  bne ussFuelLoop
ussNoFuel:

  ldy CurLevelEntry             ;Collision shot vs powerplant
  leay lePowerX,y
  mPointVsArea PlantArea,ussPowerMiss, ssShotX,ssShotY, 0,2
    mEmitFx FxTargetPlant,FxTypeDotShatter,0
    lda PowerLife
    bmi ussPowerDead
      tfr a,b
      deca                      ;decrease powerplant hitpoints
      cmpa #1
      bne ussStorePower
        lda #-10                ;Start planet explode countdown
ussStorePower:
      sta PowerLife

      ;one hit when powerlife 15 =  1 second wait
      ;             "          1 = 30 seconds wait
      negb                      ;disable guns for a while
      addb #16
      aslb
      stb PowerShot
ussPowerDead:
    lbra ussRemoveShot           ;remove shot
ussPowerMiss:


  ldy CurLevelEntry             ;Collision shots vs switches
  lda DoorCounter
  bne ussNoSwitches             ;skip check if door is not closed
  ldy leSwitches,y
  lda ,y+                       ;load count
  beq ussNoSwitches
  sta LocalCount,s
  clra
ussSwitchLoop:
  sta LocalB1,s
  mPointVsArea SwitchArea,ussNextSwitch, ssShotX,ssShotY, seSwitchX,seSwitchY
    mSetByte DoorCounter,1      ;hit, open doors

    lda LocalB1,s
    mEmitFx FxTargetSwitch,FxTypeDotShatter,a

    bra ussRemoveShot           ;remove shot
ussNextSwitch:
  lda LocalB1,s
  leay SwitchEntry,y
  inca
  cmpa LocalCount,s
  bne ussSwitchLoop
ussNoSwitches:


  mTestFlag HasOrbFlag          ;shots vs pod
  beq ussPodMiss
  ldy #PodX
  mPointVsArea PodArea,ussPodMiss, ssShotX,ssShotY, 0, 2
  jsr ExplodeShip
  bra ussRemoveShot
ussPodMiss:


  bra ussNext

ussRemoveShot:
  clr ssShotActive,u            ;remove shot

ussNext:
  lda LocalB3,s                 ;restore loop index
  leau ShipShotEntry,u
  deca
  bne ussLoop

  mFreeLocals
  direct -1
  rts



;*****************
DrawShipShots:
  ;DP must be D0
  mDecLocals 2,1
LocalTempX = LocalB1
LocalTempY = LocalB2

  ldu #ShipShotList             ;Draw all active shots.
  lda #ShipShotCount
dssLoop:
  std LocalW1,s
  tst ssShotActive,u
  bne dssActive
dssNext:
  leau ShipShotEntry,u
  ldd LocalW1,s
  deca
  bne dssLoop
  lbra dssFin

dssTestRemove:
  cmpd #256 + 100               ;remove if too far off-screen
  bge dssRemove
  cmpd #-100
  blt dssRemove
  bra dssNext
dssRemove:
  clr ssShotActive,u            ;remove shot
  bra dssNext

dssActive:
  ;X coord
  mGetScreenX ssShotX,u
  bmi dssTestRemove  ;offscreen, skip
  tsta
  bne dssTestRemove  ;offscreen, skip

  subb #128
  stb LocalTempX,s

  ;Y coord
  ldd ssShotY,u
  subd ViewY
  bmi dssNext  ;offscreen, skip
  tsta
  bne dssNext  ;offscreen, skip

  stb LocalTempY,s
  jsr reset0ref                 ;this shot should be drawn, reset pen
  mSetScale $7f                 ;Scale $7f is required for move_pen_d to reach whole screen

  mSetIntensity $50
  lda LocalTempY,s

  nega
  adda #127
  ldb LocalTempX,s

  mMove_pen_d_Quick
  mDot_at_current_position 1
;  jsr DrawBulletAtCurrentPosition
  bra dssNext

dssFin:

  mFreeLocals
  rts



;*****************
  if false
ClipTest:
    ldd ViewX
    std _clip_xmin
    addd #256
    std _clip_xmax

    ldd ViewY
    std _clip_ymin
    addd #256
    std _clip_ymax

    ldd #(TileH*1)  ;offset y
    std ,--s
    ldd #(TileW*6)  ;offset x
    std ,--s
    ldd #DrawList
    std ,--s
    ldd #TestLines
    std ,--s
    jsr     _CohenSutherlandClip    ;CALL: (VOIDmode) _CohenSutherlandClip (11 bytes)
    leas  8,s

    ;end of drawlist
    ldy #DrawList+6
    clr ,y
    mSetByte NeedRefresh,1
  rts
TestLines:
  db 1  ;linecount
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db (TileW * 5),((TileH/2) * 5)  ;x0,y0
  db 0,0  ;x1,y1
  endif


;*****************
OnLoseLife:
;         dec Lives, beq GameOver
;         om Fuel=0, beq GameOver
;         else RestartLevel
  direct $c8

  lda GameMode
  cmpa #BonusGame
  beq ollGameOver

  tst CheatLives
  bne ollCheating
    lda ShipLives
    beq ollGameOver
    deca
    sta ShipLives
    ldd ShipFuel
    beq ollGameOver
ollCheating:

  clra
  sta PerfectBonus              ;no perfect bonus

  ;if planet destroyed, exit mission
  tst PowerLife
  bpl ollPlanetOk

  mClearFlag HasOrbFlag
  jsr OnExitLevel

  bra ollExit
ollPlanetOk:
  jsr RestartLevel
  bra ollExit
ollGameOver:
  mSetFlag GameOverFlag
ollExit:

  direct -1
  rts


;*****************
ViewShipCenter:                 ;Set view with ship in screen center
  direct $c8
  ldd CenterX
  subd #TileCountX / 2 * TileW
  bpl vscXOk
    addd CurLevelEndX
vscXOk:
  std ViewX

  ldd CenterY
  subd #TileCountY / 2 * TileH
  cmpd CurLevelEndY
  blt vscYOk
    ldd CurLevelEndY
vscYOk:
  std ViewY

  mSetByte NeedRefresh,1
  mSetByte ScrollX,0
  mSetByte ScrollY,0
  direct -1
  rts


;*****************
ResetShip:                      ;Resets ship state
  direct $c8
  mClearFlag (InactiveFlag | RefuelFlag | ShieldFlag | PullFlag)

  ;Original Thrust have a slight angle on the towbar when restarting with pod attached
AlphaInitAdjust = (ALPHA_MAX/16)

  ;Init ship direction up or down depending on gravity
  mTestFlag ReverseGravFlag
  bne rsAngleDown
  lda #8
  sta ShipAngle
  lda #(ALPHA_MAX/4) + AlphaInitAdjust
  sta AlphaHi
  bra rsAngleEnd
rsAngleDown:
  lda #8 + SHIP_DIRMAX/2
  sta ShipAngle
  lda #ALPHA_MAX/4 + ALPHA_MAX/2 + AlphaInitAdjust
  sta AlphaHi
rsAngleEnd:

  clra
  clrb
  std AlphaDelta
  std ShipSpeedX
  std ShipSpeedY

  ;mSetFlag HasOrbFlag          ;uncomment to always start with orb

  ;Warp-in effect
  mSetFlag InactiveFlag         ;disable ship movement
  mEmitFx FxTargetShip,FxTypeWarpIn,0
  mTestFlag HasOrbFlag
  beq rsNoPod
    mEmitFx FxTargetPod,FxTypeWarpIn,0
rsNoPod:
  direct -1
  rts


;*****************
RestartLevel:
  mDecLocals 5,0,0
  direct $c8
LocalShipTileX = LocalB2
LocalShipTileY = LocalB3
LocalBest = LocalB4             ;best diff
LocalBestI = LocalB5            ;best index in restart list

  mClearFlag InactiveFlag

  ldd CenterY                   ;find restart point closest to last ship position
  bpl rsPositiveY
    ldd #0
rsPositiveY:
  mDivTileH
  stb LocalShipTileY,s

  ldd CenterX
  mDivTileW
  stb LocalShipTileX,s

  lda #120
  sta LocalBest,s

  ldu CurLevelEntry
  ldu leRestart,u
  ldb ,u+
  stb LocalB1,s
  mTestFlag HasOrbFlag
  beq *+2
    ;Use different defaults for haspod
    ldb #1
  stb LocalBestI,s
rlPosLoop:
  ldb 1,u                       ;compare abs(restartY - shipY) + abs(restartX - shipX), lowest is the winner
  subb LocalShipTileY,s
  mTestFlag HasOrbFlag
  bne rlHasOrb
    ;no pod, only consider points with lower y (closer to planet surface)
    ;if none found, use the first in list
    decb ;0 is also ok
    negb
    bmi rlNext
    bra rlStoreYDiff
rlHasOrb:
    ;pod, only consider points with higher y (closer to pod base)
    ;if none found, use the last in list (requires that the deepest restartpoint is last)
    tstb
    bmi rlNext
rlStoreYDiff:
  stb -1,s

  lda ,u
  suba LocalShipTileX,s
  bpl rlPosX
    nega
rlPosX:
  adda -1,s

  cmpa LocalBest,s
  bge rlNext
    sta LocalBest,s
    lda LocalB1,s
    sta LocalBestI,s
rlNext:
  leau 2,u
  dec LocalB1,s
  bne rlPosLoop

  ;keep pod if more than screenh from PodY
  ldu CurLevelEntry
  ldd leOrbY,u
  subd CenterY
  cmpd #ScreenH/2
  bge rsKeepPod
    mClearFlag HasOrbFlag
rsKeepPod:

  ldu CurLevelEntry
  ldu leRestart,u
  lda ,u+
  suba LocalBestI,s
  lsla
  leau a,u
  ldb ,u+
  lda #TileW
  mul
  addd #TileW/2  ;center within tile
  std CenterX
  ldb ,u+
  lda #TileH
  mul
  addd #TileH/2  ;center within tile
  std CenterY

  mSetByte GunShotActive,0

  jsr ResetShip
  jsr Ship_UpdateShipPodPos
  jsr ViewShipCenter

  mFreeLocals
  direct -1
  rts

;*****************
SplitLevelNo:                     ;returns levello in A, levelhi i B
  ldx #LevelCounts
  lda GameMode
  leax a,x
  lda CurLevel
  clrb
splLoop:
  cmpa ,x
  blt splExit
  suba ,x
  incb
  bra splLoop
splExit:
  rts
LevelCounts: db LevelCountNormal,LevelCount,LevelCount

;*****************
PrepareLevel:                   ;Calculate level constants
  mDecLocals 1,0,0
LocalLevelLo = LocalB1
  direct $c8

  ldx #LevelClearLabel
  jsr clear_256_bytes           ;Clear buffer

  bsr SplitLevelNo
  sta LocalLevelLo,s
  bitb #1                       ;reverse on 1 and 3
  beq plNoReverse
    mSetFlag ReverseGravFlag
plNoReverse:

  cmpb #2                       ;landscape invisible on 2 and 3
  blo plNoNoLand
    mSetFlag NoLandscapeFlag
plNoNoLand:

  lda GameMode
  cmpa #HardGame
  bne plNoHard
    mSetFlag HomingGunShotsFlag
plNoHard:

  lda LocalLevelLo,s
  ldx #Levels
  ldb #LevelEntry               ;size of levelentry
  mul
  pshs x
  addd ,s++
  tfr d,x                       ;x is now levelentry

  stx CurLevelEntry

  mSetWord GunsActive,$ffff     ;all guns active
  mSetByte FuelActive,$ff       ;all fuelpods active

  mSetByte PowerLife,15         ;hitpoints for powerplant

  lda LocalLevelLo,s            ;1500 + (levelno * 100)
  adda #15
  sta PerfectBonus              ;init perfect bonus, decreases when shield is used

  ldu #FuelAmounts              ;all fuelpods full
  lda #FullFuel
  ldb #MaxFuelCount
plFuel:
  sta ,u+
  decb
  bne plFuel

  lda leSizeX,x
  sta CurLevelSizeX

  lda CurLevelSizeX
  ldb #TileW
  mul
  std CurLevelEndX              ;CurLevelEndX = (CurLevelSizeX * TileW)

  lda leSizeY,x
  ldb #TileH
  mul
  subd #ScreenH
  std CurLevelEndY              ;CurLevelEndY = largest View Y

  ;Gun shot constants
  ;Make guns fire more often on higher levels

  ;GunDelayMask = modeconstant >> (levello >> 1)
  lda GameMode
  ldx #GunDelayMasks
  lda a,x
  ldb LocalLevelLo,s
  asrb
plGunMaskLoop:
  tstb
  beq plStoreGunDelayMask
  cmpa #7
  beq plStoreGunDelayMask
  asra
  decb
  bra plGunMaskLoop
plStoreGunDelayMask:
  sta GunShotMask

  ;GunDelay = modeconstant - (levello * 8)
  lda GameMode
  ldx #GunDelays
  lda a,x
  ldb LocalLevelLo,s
plGunDelayLoop:
  tstb
  beq plStoreGunDelay
  tsta
  beq plStoreGunDelay
  suba #8
  decb
  bra plGunDelayLoop
plStoreGunDelay:
  sta GunShotDelay

  ;GunShotSpeed = modeconstant + (levello >> 1)
  lda GameMode
  ldx #GunShotSpeeds
  lda a,x
  ldb LocalLevelLo,s
  asrb
plGunSpeedLoop:
  tstb
  beq plStoreGunSpeed
  cmpa #24
  bge plStoreGunSpeed
  inca
  decb
  bra plGunSpeedLoop
plStoreGunSpeed:
  sta GunShotSpeed

  ;Set ship start position
  ;use first restart point
  ldu CurLevelEntry
  ldu leRestart,u
  lda ,u+
  ldb ,u+
  lda #TileW
  mul
  addd #TileW/2  ;center within tile
  std CenterX
  ldb ,u+
  lda #TileH
  mul
  addd #TileH/2  ;center within tile
  std CenterY

  jsr ResetShip
  jsr Ship_UpdateShipPodPos
  jsr ViewShipCenter

  direct -1
  mFreeLocals
  rts

;Gun fire delay for each game mode
GunDelays: db 48,32,48   ;multiple of 8
GunDelayMasks: db 63,15,63
;Gun shot speeds for each game mode
GunShotSpeeds: db 24,18,24


;*****************
OnExitLevel:
  direct $c8

  lda DemoMode
  bpl oelNoDemo
    mSetFlag GameOverFlag
    bra oelExit
oelNoDemo:

  jsr Text_LevelExit
  bne oelIncomplete

  inc CurLevel

  jsr SplitLevelNo              ;check if new round
  tsta
  bne oelNoSpecial
  tstb
  beq oelNoSpecial              ;only display text on first level on each round
    cmpb #1
    bne oelNoGrav
      clra
      jsr Text_Special          ;display 'reverse gravity'
      bra oelNoSpecial
oelNoGrav:
    cmpb #2
    bne oelNoNoLand
      lda #1
      jsr Text_Special          ;display 'invisible landscape'
      bra oelNoSpecial
oelNoNoLand:
    cmpb #3
    beq oelNoSpecial            ;b=3: both reverse and invisible, no message
    jsr Text_ShowWellDone       ;b=4: game completed
    mSetFlag GameOverFlag
    bra oelExit
oelNoSpecial:

  jsr PrepareLevel
  bra oelExit

oelIncomplete:
  jsr RestartLevel

oelExit:

  direct -1
  rts


;*****************
InitNewGame:    ;a <> 0 skip random reset
  direct $c8

  tsta
  bne ingNoResetRnd
    ;Reset random seeds
    ;This is important for demo-playback and recording
    mSetByte LoopCounterLow,0
    mSetByte FrameCounter,0
    ldx $C87B
    mCombine d,$ae,$77
    std ,x
    sta 2,x
ingNoResetRnd:

  ldx #UserRamStart
  jsr clear_256_bytes   ;Clear buffer

  jsr clear_sound_chip

  ldd #1000
  std ShipFuel

  ;normal = 2
  mSetByte ShipLives,2

  ldx #PlayerScore
  ldd #'  '
  std ,x++
  std ,x++
  std ,x

  lda GameMode
  cmpa #DemoGame
  bne ingNoDemo
    ;Init demo game
    clr GameMode
    mSetByte DemoMode,-1        ;set flag that this is demogame
    lda DemoSelected
    lsla
    ldx #DemoList
    ldx a,x
    stx DemoPtr
    mSetByte DemoCounter,0
    lda ,x                      ;read startlevel from demodata
    sta CurLevel
    bra ingExit
ingNoDemo:
    cmpa #TimeAttackGame
    bne ingNoTimeAttack
    ldb #75                     ;init timeattack
    stb TimeAttackTime
ingNoTimeAttack:
    lda #StartLevel
    adda CheatLevel
    sta CurLevel
ingExit:

  direct -1
  rts


;*****************
ScrollSpeed=4
BorderWidth=76          ;Distance of ship to screen border before scrolling starts
EndBorderWidth=100      ;Distance ship<->border when scrolling stops

SetView:
  direct $c8
  mDecLocals 2,0,0
LocalScreenX = LocalB1
LocalScreenY = LocalB2

  ldd ScrollX           ;load both scrollx/y
  beq svNoRefresh       ;zero if not scrolling
    mSetByte NeedRefresh,1
svNoRefresh:

  ;update scroll x

  ldx ShipX
  mGetScreenX
  stb LocalScreenX,s
  ;b holds screen x

  tst ScrollX
  beq svScrollXFin
  bpl svScrollRight
    ;scroll left
    cmpb #256-EndBorderWidth
    blo *+2
      clr ScrollX
    ldd ViewX
    subd #ScrollSpeed
    bpl svStoreX
    addd CurLevelEndX
    bra svStoreX
svScrollRight:
    cmpb #EndBorderWidth
    bhi *+2
      clr ScrollX
    ldd ViewX
    addd #ScrollSpeed
    cmpd CurLevelEndX
    blo svStoreX
    subd CurLevelEndX
svStoreX:
  std ViewX
svScrollXFin:

  ;update scroll y

  ldd ShipY
  subd ViewY
  stb LocalScreenY,s
  ;b holds screen y

  ldx ViewY
  tst ScrollY
  beq svScrollYFin
  bpl svScrollDown
    ;scroll up
    cmpb #256-EndBorderWidth
    blo *+2
      clr ScrollY
    leax -ScrollSpeed,x
    cmpx #WorldTopY
    bgt svStoreY
    ldx #WorldTopY
    bra svStoreY
svScrollDown:
    cmpb #EndBorderWidth
    bhi *+2
      clr ScrollY
    leax ScrollSpeed,x
    cmpx CurLevelEndY
    blt svStoreY
    ldx CurLevelEndY
svStoreY:
  stx ViewY
svScrollYFin:

  ;test if need to start scrolling

  tst ScrollX
  bne svEndCheckScrollX
    ldb LocalScreenX,s
    cmpb #256 - BorderWidth  ;right edge
    bhi svSetScrollRight
    cmpb #BorderWidth        ;left edge
    blo svSetScrollLeft
    bra svEndCheckScrollX
svSetScrollRight:
    mSetByte ScrollX, 1
    bra svEndCheckScrollX
svSetScrollLeft:
    mSetByte ScrollX, -1
svEndCheckScrollX:

  tst ScrollY
  bne svEndCheckScrollY
    ldb LocalScreenY,s
    cmpb #256 - BorderWidth  ;bottom edge
    bhi svSetScrollDown
    cmpb #BorderWidth        ;top edge
    blo svSetScrollUp
    bra svEndCheckScrollY
svSetScrollDown:
    mSetByte ScrollY, 1
    bra svEndCheckScrollY
svSetScrollUp:
    mSetByte ScrollY, -1
svEndCheckScrollY:

  mFreeLocals
  direct -1
  rts



;*****************
DrawLevel:
  ;DP must be D0
  mDecLocals 1,0,0
LocalInt = LocalB1

  ldx #DrawList
  lda #WallIntensity
  sta LocalInt,s

  mTestFlag NoLandscapeFlag
  beq dlNormal
    ;If no landscape, only draw when shield is used
    mTestFlag ShieldFlag
    bne dlNormal
    clr LocalInt,s
dlNormal:
  lda LocalInt,s
  bsr GoDrawList

  mFreeLocals
  rts


;*****************
GoDrawList:                     ;x=drawlist, a=intensity
  mSetIntensity
  mSetScale $7f       ;Scale $7f is required for move_pen_d to reach whole screen

dlLoop:
  lda ,x+
  beq dlFinish
  bge dlLine

  ;setpen

  ;reset0ref inlined
  ldd   #0x00CC
  stb   <0x0C
  sta   <0x0A
  ldd   #0x0302
  clr   <0x01
  sta   <0x00
  stb   <0x00
;  stb   <0x00
  ldb   #0x01
  stb   <0x00

  ldd ,x++
  mMove_pen_d_Quick

  bra dlLoop

dlLine:
  ;Optimize: Lines could be scaled down (scale 7f/2, length asla b)
  ;This would require no line length larger than 63, doors have larger lines

  ldd ,x++
  mDrawToD

  bra dlLoop

dlFinish:
  rts


 if false
mTestTile macro XX,YY
   db -1, 127 - (YY*TileH), -127 + (XX*TileW)
   db 1, -TileH, 0
   db 1, 0, TileW
 endm

mTestOneRow macro YY
 mTestTile 0,YY
 mTestTile 1,YY
 mTestTile 2,YY
 mTestTile 3,YY
 mTestTile 4,YY
 mTestTile 5,YY
 mTestTile 6,YY
 mTestTile 7,YY
 mTestTile 8,YY
 endm

testdrawlist:
  mTestOneRow 0
  mTestOneRow 1
  mTestOneRow 2
  mTestOneRow 3
  mTestOneRow 4
  mTestOneRow 5
  mTestOneRow 6
  mTestOneRow 7
;  db -1, 127,-127   ;set pen
;  db 1,  -50,50     ;draw line
;  db -1, -120,-120   ;set pen
;  db 1,  25,50     ;draw line
  db 0             ;end list
 endif



;*****************
ExplodeShip:
  if Immortal=0
    mTestFlag InactiveFlag      ;do nothing if already exploding
    bne exsExit
    mTestFlag HasOrbFlag        ;explode orb also if carried
    beq exsNoPod
      mEmitFx FxTargetPod,FxTypeDotShatter,0
exsNoPod:
    mEmitFx FxTargetShip,FxTypeDotShatter,b
    mSetFlag InactiveFlag       ;disable ship movement
exsExit:
  endif
  rts


;*****************
RefreshDrawList:
  direct $c8

  ;refresh DrawList-memory with lines from tiles in the current level
  tst NeedRefresh
  bne rdBegin
    rts ;quick exit if refresh not needed

rdBegin:
 ; tileWX,tileWY
 ; loop x until tileWX is larger than viewX+256
 ;   if tileWX,tileWY is within screen (viewX/Y + 256)
 ;     copy the lines directly
 ;   else
 ;     clip the lines
  mDecLocals 2,4
LocalViewY = LocalW3
LocalEndY = LocalW4             ;Highest world y coord that is on screen

  ;set up clipping region
  ldd ViewX
  std _clip_xmin
  addd #255
  std _clip_xmax
  ldd ViewY
  std _clip_ymin
  addd #255
  std _clip_ymax

  ldd ViewY                     ;setup y-coords, test for empty space (negative y)
  bpl rdNoEmptySpace
    ldd #0                      ;empty space at top of screen, adjust start coords
    std LocalViewY,s
    inca
    addd ViewY
    std LocalEndY,s             ;end = 0 + 256 + viewY (viewY is negative)
    ldd #127                    ;calc start screen y coord
    addd ViewY
    cmpd #-128
    ble rdNothingToDraw
    stb TempPosY
    bra rdYCoordsFin
rdNothingToDraw:                ;no tiles are visible, only empty space
    ldy #DrawList
    lbra rdEndList
rdNoEmptySpace:                 ;normal case, no empty space
  std LocalViewY,s
  inca
  std LocalEndY,s
  ldd LocalViewY,s              ;calc start screen y coord
  andb #TileH-1
  addb #127
  stb TempPosY
rdYCoordsFin:

  ldy LocalViewY,s
  ldx ViewX
  mGetLevelTile
  ;x=tile pointer
  stx TempTilePtr

  ;see if view spans over right edge of level
  ldb CurLevelSizeX
  sex
  std ,--s
  ldd ViewX
  mDivTileW  ;optimize: this value is already calced
  addd #TileCountX+1
  subd ,s++
  bpl rdNeedAdjust
    lda #-1  ;no adjust needed
    bra rdStoreAdjust
rdNeedAdjust:
    lda #TileCountX+1
    stb ,-s
    suba ,s+
rdStoreAdjust:
  ;TempAdjustX = nr of tiles on row before edge, -1 = no wrap
  sta TempAdjustX

  ;calc start world coords for first partly visible tile
  ldd LocalViewY,s
  andb #~(TileH-1)
  std TempTileWY

  ldd ViewX
  andb #~(TileW-1)
  std TempTileWX
  std TempTileWXStart



  ;0123456701234567
  ;       X
  ;calc screen x coord for first unclipped tile
  ldd ViewX
  andb #TileW-1
  beq rdZeroX
  negb
rdZeroX:
  subb #128
  stb TempPosX
  stb TempPosXStart

  ldy #DrawList

  ldb #TileCountY+1
rsYLoop:
  stb LocalB1,s

    lda TempAdjustX
    ldb #TileCountX+1
rsXLoop:
    std LocalW1,s

    ldb ,x+                     ;get tile
    beq rdNextTile              ;0 = no tile
    bitb #32                    ;>=32 = special tiles without lines (solid, doorarea)
    bne rdNextTile

    ;u = tilepointer
    lda #TileEntry
    mul
    ldu #TileTable
    leau d,u

    ;test if tile needs clipping
    ldd TempTileWX
    subd ViewX
    bmi rdNeedClip              ;TileX < ViewX
    cmpd #255-TileW             ;TileXEnd > ViewX + 256
    bge rdNeedClip

    ldd TempTileWY
    subd LocalViewY,s
    bmi rdNeedClip              ;TileY < ViewY

    lda TempPosY
    cmpa #-(128 - TileH)
    ble rdNeedClip              ;ScreenY >= end of screen - tileh

    ;unclipped tile
    ;x = lines rel
    stx LocalW2,s
    ldx teLinesRel,u

    ;set pen
    lda #-1
    sta ,y+
    lda TempPosY
    adda ,x+
    sta ,y+                     ;write y coord
    lda TempPosX
    adda ,x+
    sta ,y+                     ;write x coord

    lda ,x+                     ;copy lines to drawlist
rdLop1:
    sta LocalB2,s
    ldb #1
    stb ,y+
    ldd ,x++
    std ,y++
    lda LocalB2,s
    deca
    bne rdLop1

    ldx LocalW2,s
    bra rdNextTile

rdNeedClip:
    ;clip tile
    ;entry: y=drawlist, u=tile entry
    ldd teLinesAbs,u
;    beq  rdNextTile     ;**safety, remove when all tiles have abs lines

    ldd TempTileWY      ;offset y
    std ,--s
    ldd TempTileWX      ;offset x
    std ,--s
    sty ,--s            ;pointer to drawlist
    ldd teLinesAbs,u
    std ,--s            ;pointer to lines
    jsr _CohenSutherlandClip
    leas  8,s           ;Clean stack
    leay d,y            ;d = nr of bytes written, add to drawlist pointer

rdNextTile:
    ldd TempTileWX              ;update tile world pos
    addd #TileW
    std TempTileWX

    lda TempPosX                ;update screen pos
    adda #TileW
    sta TempPosX

    ldd LocalW1,s
    deca
    bne rsNotYetAdjust
      ;tileptr have crossed right edge of level
      ;x = x - one row
      lda CurLevelSizeX
      ;deca
      nega
      leax a,x
      ;leave a negative value in A, it will not adjust again in this row
rsNotYetAdjust:
    decb
    bne rsXLoop

  ;next row

  ldd TempTileWXStart           ;reset tile world x
  std TempTileWX

  ldd TempTileWY                ;update tile world y
  addd #TileH
  std TempTileWY

;  cmpd CurLevelEndY             ;if tilewy is off-world then finish
;  bgt rdEndList

  ldd LocalEndY,s               ;if tilewy is offscreen then we are finished
  cmpd TempTileWY
  ble rdEndList

  ldx TempTilePtr               ;next row, update tile level pointer

  ldb CurLevelSizeX
  abx                           ;x=x+b
  stx TempTilePtr

  lda TempPosY                  ;next row, update screen y pos
  suba #TileH
  sta TempPosY

  lda TempPosXStart
  sta TempPosX

  ldb LocalB1,s
  decb
  bne rsYLoop

rdEndList:
  lda #0                        ;write end of drawlist
  sta ,y+

  mSetByte NeedRefresh,0

  mFreeLocals

  direct -1
  rts


;*****************
DrawStars:                      ;draw stars in empty space
  ldd ViewY
  bmi dstOk
    rts                         ;no empty space is visible, exit
dstOk:
  mDecLocals 6,3,3
LocalYRange = LocalB1           ;height of starfield visible from top of screen
LocalScreenX = LocalB2
LocalScreenY = LocalB3
LocalSave = LocalB4
LocalInt = LocalB5
LocalDist = LocalB5
LocalYAdd = LocalW1
LocalXAdd = LocalW2
LocalSaveSeed = LocalW3

StarDensity = 20                ;nr of stars to draw

  negb
  stb LocalYRange,s

  lda LoopCounterLow            ;distort starfield with value from loopcounter
  anda #64 + 128                ;the distortion also hides the bug that stars jump when crossing world x-wraparound ;-)
  sta LocalDist,s

  ldb ViewY + 1
  addb LocalDist,s
  clra
  pshs d
  ldd #256
  subd ,s++
  std LocalYAdd,s

  ldb ViewX + 1
  addb LocalDist,s
  clra
  pshs d
  ldd #256
  subd ,s++
  std LocalXAdd,s

  ldd #$E077                    ;reset random seed
  std LocalBuffer,s
  lda #%11101011
  sta LocalBuffer+2,s
  leau LocalBuffer,s
  mSetRandomSeedToU LocalSaveSeed

  lda #StarDensity
dstLoop:
  sta LocalSave,s

  mRandomToA
  suba LocalSave,s              ;Add loop index to coord to avoid overdraw (rom rnd is poor)
  tfr a,b
  clra
  addd LocalXAdd,s
  stb LocalScreenX,s

  mRandomToA
  adda LocalSave,s              ;Add loop index to coord to avoid overdraw (rom rnd is poor)
  tfr a,b
  clra
  addd LocalYAdd,s
  stb LocalScreenY,s

  mRandomToA                    ;random intensity
  anda #63
  pshs a
  lda #64 + 20
  suba ,s+
  sta LocalInt,s

  ldb LocalScreenY,s
  cmpb LocalYRange,s
  bhi dstNext

  jsr reset0ref

  ldb LocalScreenX,s            ;vectrex screen transform
  subb #128
  lda LocalScreenY,s
  nega
  adda #127

  sta -1,s
  mSetScale $7f
  lda -1,s
  mMove_pen_d_Quick

  lda LocalInt,s
  mSetIntensity

  lda LocalBuffer,s
  bita #8 + 16
  beq dstNiceStar
  mDot_at_current_position
  bra dstNext
dstNiceStar:
  lda LoopCounterLow
  asra
  asra
  asra
  adda LocalBuffer,s
  anda #7
  inca
  jsr DrawPlusAtCurrentPosition

dstNext:
  lda LocalSave,s
  deca
  bne dstLoop

  ;    if viewy<0
  ;      yrange=abs(viewy)
  ;    else
  ;      exit
  ;    yadd=256 - (viewy lo)
  ;    xoff=viewx lo byte
  ;    xadd=256 - xoff
  ;    for 0 to starcount
  ;      starX=random
  ;      screenX=lo(starX + xadd)
  ;      starY=random
  ;      screenY=lo(starY + yadd)
  ;      if screenY>yrange
  ;        skip
  ;      else
  ;        set random intensity
  ;        draw dot

  ldu LocalSaveSeed,s           ;restore old random seed
  mSetRandomSeedToU

  mFreeLocals
  rts


;*****************
RectVsLevel:                    ;u=ptr to left,right,top,bottom
LocalLeft=0
LocalRight=2
LocalTop=4
LocalBottom=6

_mRvL macro xx,yy,last
  ldx xx,u
  ldy yy,u
  pshs u
  bsr PointVsLevel
  puls u
  bcs rvlExit
 endm

  _mRvL LocalLeft,LocalTop
  _mRvL LocalRight,LocalTop
  _mRvL LocalLeft,LocalBottom

  ;Last point does not need to save u or branch
  ldx LocalRight,u
  ldy LocalBottom,u
  jmp PointVsLevel

rvlExit:
  rts



;*****************
PointVsLevel:
  ;x and y are coords to test
  ;returns carry set if collision

  direct $c8

  tfr y,d
  bita #128                     ;Test for empty space (negative coord)
  bne tcEmpty
  andb #TileH-1
  stb TempPosY

  tfr x,d
  andb #TileW-1
  stb TempPosX

  mGetLevelTile

  ldb ,x
  beq tcEmpty  ;0 = no tile

  lda #TileEntry
  mul
  ldx #TileTable + teCollisionSub
  leax d,x

  ;a,b = x,y coordinates within tile
  ldd TempPosX

  jmp [,x]
  ;exit through subroutine


;Tile collision routines, set carry if hit
tcEmpty:
  andcc #$fe
  rts
tcFull:
  orcc #1
  rts
;X.
;XX
tcTile02:
  cmpb #TileH/2
  bge tcFull
  asra
  cmpa TempPosY
  bge tcEmpty
  orcc #1
  rts
;..
;X.
tcTile03:
  cmpb #TileH/2
  ble tcEmpty
  subb #TileH/2
  aslb
  cmpb TempPosX
  ble tcEmpty
  orcc #1
  rts
;..
;.X
tcTile04:
  cmpb #TileH/2
  ble tcMiss04
  subb #TileH/2
  lda #TileW
  suba TempPosX
  asra
  sta -1,s
  cmpb -1,s
  ble tcMiss04
tcHit04:
  orcc #1
  rts
tcMiss04:
  andcc #$fe
  rts
;.X
;XX
tcTile05:
  cmpb #TileH/2
  bge tcHit05
  lda #TileW
  suba TempPosX
  asra
  sta -1,s
  cmpb -1,s
  bge tcHit05
tcMiss05:
  andcc #$fe
  rts
tcHit05:
  orcc #1
  rts
;XX
;X.
tcTile06:
  cmpb #TileH/2
  ble tcFull
  subb #TileH/2
  lda #TileW
  suba TempPosX
  asra
  sta -1,s
  cmpb -1,s
  blo tcFull
  andcc #$fe
  rts
;X.
;..
tcTile07:
  cmpb #TileH/2
  bge tcEmpty
  lda #TileW
  suba TempPosX
  asra
  sta -1,s
  cmpb -1,s
  blo tcFull
  andcc #$fe
  rts
;.X
;..
tcTile08:
  cmpb #TileH/2
  bge tcEmpty
  aslb
  cmpb TempPosX
  blo tcFull
  andcc #$fe
  rts
;XX
;.X
tcTile09:
  subb #TileH/2
  bmi tcFull
  aslb
  cmpb TempPosX
  lblo tcFull
  andcc #$fe
  rts

;Tiles for door collision
;Test is adjusted with amount door is open
tcTile33:       ;horiz door 1 of 2
  lda DoorCounter
tc33jumpin:
  beq tcHitDoor

  anda #%01111111
  nega
  adda #DoorSize
  asr TempPosX
  cmpa TempPosX
  bge tcHitDoor

  andcc #$fe
  rts

tcTile34:       ;horiz door 2 of 2
  lda DoorCounter
tc34jumpin:
  beq tcHitDoor

  anda #%01111111
  nega
  adda #DoorSize
  suba #TileW
  asr TempPosX
  cmpa TempPosX
  bge tcHitDoor

  andcc #$fe
  rts
tcHitDoor:
  orcc #1
  rts

tcTile35:       ;vert door 1 of 2
  lda DoorCounter
  anda #%01111111
  asr TempPosY
  cmpa TempPosY
  blo tcHitDoor
  andcc #$fe
  rts

tcTile36:       ;vert door 2 of 2
  lda DoorCounter
  anda #%01111111
  cmpa #TileH/2
  blo tcHitDoor
  suba #TileH/2
  asr TempPosY
  cmpa TempPosY
  blo tcHitDoor
  andcc #$fe
  rts

tcTile37:       ;inverted horiz door 1 of 2
  ;invert door open value and call normal horiz door
  lda DoorCounter
  anda #%01111111
  nega
  adda #DoorSize
  bpl tc37_1
    clra
tc37_1:
  jmp tc33jumpin

tcTile38:       ;inverted horiz door 2 of 2
  ;invert door open value and call normal horiz door
  lda DoorCounter
  anda #%01111111
  nega
  adda #DoorSize
  bpl tc38_1
    clra
tc38_1:
  jmp tc34jumpin

  direct -1



; Tiles, see struct TileEntry
TileTable:
  dw 0,0,0    ;tile 0 is blank
  dw Tile01_LinesRel,Tile01_LinesAbs,tcFull
  dw Tile02_LinesRel,Tile02_LinesAbs,tcTile02
  dw Tile03_LinesRel,Tile03_LinesAbs,tcTile03
  dw Tile04_LinesRel,Tile04_LinesAbs,tcTile04
  dw Tile05_LinesRel,Tile05_LinesAbs,tcTile05
  dw Tile06_LinesRel,Tile06_LinesAbs,tcTile06
  dw Tile07_LinesRel,Tile07_LinesAbs,tcTile07
  dw Tile08_LinesRel,Tile08_LinesAbs,tcTile08
  dw Tile09_LinesRel,Tile09_LinesAbs,tcTile09
  dw Tile10_LinesRel,Tile10_LinesAbs,tcFull
  dw Tile11_LinesRel,Tile11_LinesAbs,tcFull
  dw Tile12_LinesRel,Tile12_LinesAbs,tcTile08
  dw Tile13_LinesRel,Tile13_LinesAbs,tcTile09
  dw Tile14_LinesRel,Tile14_LinesAbs,tcTile02
  dw Tile15_LinesRel,Tile15_LinesAbs,tcFull
  dw Tile16_LinesRel,Tile16_LinesAbs,tcFull
  dw Tile17_LinesRel,Tile17_LinesAbs,tcFull
  dw Tile18_LinesRel,Tile18_LinesAbs,tcFull
  dw Tile19_LinesRel,Tile19_LinesAbs,tcTile07
  dw Tile20_LinesRel,Tile20_LinesAbs,tcTile04
  dw Tile21_LinesRel,Tile21_LinesAbs,tcFull
  dw Tile22_LinesRel,Tile22_LinesAbs,tcTile03
  dw Tile23_LinesRel,Tile23_LinesAbs,tcTile06
  dw Tile24_LinesRel,Tile24_LinesAbs,tcTile05

  dw 0,0,0   ;25 = not yet used
  dw 0,0,0   ;26 = not yet used
  dw 0,0,0   ;27 = not yet used
  dw 0,0,0   ;28 = not yet used
  dw 0,0,0   ;29 = not yet used
  dw 0,0,0   ;30 = not yet used
  dw 0,0,0   ;31 = not yet used

  dw 0,0,tcFull               ;a 32 = empty solid
  dw 0,0,tcTile33             ;b 33 = horiz door 1 of 2
  dw 0,0,tcTile34             ;c 34 = horiz door 2 of 2
  dw 0,0,tcTile35             ;d 35 = vert door 1 of 2
  dw 0,0,tcTile36             ;e 36 = vert door 2 of 2
  dw 0,0,tcTile37             ;f 37 = horiz inverted door 1 of 2
  dw 0,0,tcTile38             ;g 38 = horiz inverted door 2 of 2




FullW equ ((TileW))
HalfW equ ((TileW/2))
FullH equ ((TileH))
HalfH equ ((TileH/2))

;--
;XX
;XX
Tile01_LinesRel:
  db 0,0  ;start pos
  db 1    ;line count
  db 0, FullW
Tile01_LinesAbs:
  db 1  ;line count
  db 1  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,0      ;x0,y0
  db FullW,0  ;x1,y1

;X.
;XX
Tile02_LinesRel:
  db 0,0  ;start pos
  db 1    ;line count
  db -HalfH, FullW
Tile02_LinesAbs:
  db 1  ;line count
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,0      ;x0,y0
  db FullW,HalfH  ;x1,y1

;..
;X.
Tile03_LinesRel:
  db -HalfH,0  ;start pos
  db 1    ;line count
  db -HalfH, FullW
Tile03_LinesAbs:
  db 1  ;line count
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,HalfH      ;x0,y0
  db FullW,FullH  ;x1,y1

;..
;.X
Tile04_LinesRel:
  db -FullH,0  ;start pos
  db 1    ;line count
  db HalfH, FullW
Tile04_LinesAbs:
  db 1  ;line count
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,FullH      ;x0,y0
  db FullW,HalfH  ;x1,y1


;.X
;XX
Tile05_LinesRel:
  db 0,FullW  ;start pos
  db 1    ;line count
  db -HalfH, -FullW
Tile05_LinesAbs:
  db 1  ;line count
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db FullW,0  ;x0,y0
  db 0,HalfH  ;x1,y1

;XX
;X.
Tile06_LinesRel:
  db -FullH,0  ;start pos
  db 1    ;line count
  db HalfH, FullW
Tile06_LinesAbs:
  db 1  ;line count
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,FullH  ;x0,y0
  db FullW,HalfH  ;x1,y1

;X.
;..
Tile07_LinesRel:
  db -HalfH,0  ;start pos
  db 1    ;line count
  db HalfH, FullW
Tile07_LinesAbs:
  db 1  ;line count
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,HalfH  ;x0,y0
  db FullW,0  ;x1,y1

;.X
;..
Tile08_LinesRel:
  db 0,0  ;start pos
  db 1    ;line count
  db -HalfH, FullW
Tile08_LinesAbs:
  db 1  ;line count
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,0  ;x0,y0
  db FullW,HalfH  ;x1,y1

;XX
;.X
Tile09_LinesRel:
  db -HalfH,0  ;start pos
  db 1    ;line count
  db -HalfH, FullW
Tile09_LinesAbs:
  db 1  ;line count
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,HalfH  ;x0,y0
  db FullW,FullH  ;x1,y1

;|XX
;|XX
Tile10_LinesRel:  ;A
  db 0,0  ;start pos
  db 1    ;line count
  db -FullH, 0
Tile10_LinesAbs:
  db 1  ;line count
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,0  ;x0,y0
  db 0,FullH  ;x1,y1

;XX|
;XX|
Tile11_LinesRel:  ;B
  db 0,FullW  ;start pos
  db 1    ;line count
  db -FullH, 0
Tile11_LinesAbs:
  db 1  ;line count
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db FullW,0  ;x0,y0
  db FullW,FullH  ;x1,y1

;.X
;..|
Tile12_LinesRel:  ;C
  db 0,0  ;start pos
  db 2    ;line count
  db -HalfH, FullW
  db -HalfH, 0
Tile12_LinesAbs:
  db 2  ;line count
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,0  ;x0,y0
  db FullW,HalfH  ;x1,y1
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db FullW,HalfH  ;x0,y0
  db FullW,FullH  ;x1,y1

;|XX
; .X
Tile13_LinesRel:  ;D
  db 0,0  ;start pos
  db 2    ;line count
  db -HalfH, 0
  db -HalfH, FullW
Tile13_LinesAbs:
  db 2  ;line count
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,0      ;x0,y0
  db 0,HalfH  ;x1,y1
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,HalfH      ;x0,y0
  db FullW,FullH  ;x1,y1

;X.
;XX|
Tile14_LinesRel:  ;E
  db 0,0  ;start pos
  db 2    ;line count
  db -HalfH, FullW
  db -HalfH, 0
Tile14_LinesAbs:
  db 2  ;line count
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,0      ;x0,y0
  db FullW,HalfH  ;x1,y1
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db FullW,HalfH      ;x0,y0
  db FullW,FullH  ;x1,y1

;--
;XX|
;XX|
Tile15_LinesRel:  ;F
  db 0,0  ;start pos
  db 2    ;line count
  db 0, FullW
  db -FullH, 0
Tile15_LinesAbs:
  db 2  ;line count
  db 1  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,0      ;x0,y0
  db FullW,0  ;x1,y1
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db FullW,0      ;x0,y0
  db FullW,FullH  ;x1,y1

; --
;|XX
;|XX
Tile16_LinesRel:  ;G
  db -FullH,0  ;start pos
  db 2    ;line count
  db FullH, 0
  db 0, FullW
Tile16_LinesAbs:
  db 2  ;line count
  db 1  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,0      ;x0,y0
  db FullW,0  ;x1,y1
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,0      ;x0,y0
  db 0,FullH  ;x1,y1

;XX
;XX
;--
Tile17_LinesRel:  ;H
  db -FullH,0  ;start pos
  db 1    ;line count
  db 0, FullW
Tile17_LinesAbs:
  db 1  ;line count
  db 1  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,FullH      ;x0,y0
  db FullW,FullH  ;x1,y1

;|XX
;|XX
; --
Tile18_LinesRel:  ;I
  db 0,0  ;start pos
  db 2    ;line count
  db -FullH, 0
  db 0, FullW
Tile18_LinesAbs:
  db 2  ;line count
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,0      ;x0,y0
  db 0,FullH  ;x1,y1
  db 1  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,FullH      ;x0,y0
  db FullW,FullH  ;x1,y1

; X.
;|..
Tile19_LinesRel:  ;J
  db 0,FullW   ;start pos
  db 2    ;line count
  db -HalfH, -FullW
  db -HalfH, 0
Tile19_LinesAbs:
  db 2  ;line count
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db FullW,0  ;x0,y0
  db 0,HalfH  ;x1,y1
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,HalfH  ;x0,y0
  db 0,FullH  ;x1,y1

;..|
;.X
Tile20_LinesRel:  ;K
  db 0,FullW  ;start pos
  db 2    ;line count
  db -HalfH,0
  db -HalfH, -FullW
Tile20_LinesAbs:
  db 2  ;line count
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db FullW,0      ;x0,y0
  db FullW,HalfH  ;x1,y1
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db FullW,HalfH  ;x0,y0
  db 0,FullH      ;x1,y1

;XX|
;XX|
;--
Tile21_LinesRel:  ;L
  db 0,FullW  ;start pos
  db 2    ;line count
  db -FullH, 0
  db 0, -FullW
Tile21_LinesAbs:
  db 2  ;line count
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db FullW,0      ;x0,y0
  db FullW,FullH  ;x1,y1
  db 1  ;linetype, 0=vert, 1=horiz, 2=slope
  db FullW,FullH      ;x0,y0
  db 0,FullH  ;x1,y1

;|..
; X.
Tile22_LinesRel:  ;M
  db 0,0  ;start pos
  db 2    ;line count
  db -HalfH,0
  db -HalfH, FullW
Tile22_LinesAbs:
  db 2  ;line count
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,0      ;x0,y0
  db 0,HalfH  ;x1,y1
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,HalfH  ;x0,y0
  db FullW,FullH      ;x1,y1

;XX|
;X.
Tile23_LinesRel:   ;N
  db -FullH,0  ;start pos
  db 2    ;line count
  db HalfH, FullW
  db HalfH, 0
Tile23_LinesAbs:
  db 2  ;line count
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,FullH  ;x0,y0
  db FullW,HalfH  ;x1,y1
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db FullW,HalfH  ;x0,y0
  db FullW,0  ;x1,y1

; .X
;|XX
Tile24_LinesRel:   ;O
  db 0,FullW  ;start pos
  db 2    ;line count
  db -HalfH, -FullW
  db -HalfH, 0
Tile24_LinesAbs:
  db 2  ;line count
  db 2  ;linetype, 0=vert, 1=horiz, 2=slope
  db FullW,0  ;x0,y0
  db 0,HalfH  ;x1,y1
  db 0  ;linetype, 0=vert, 1=horiz, 2=slope
  db 0,HalfH  ;x0,y0
  db 0,FullH  ;x1,y1


;-----------------
;LEVELS
;-----------------

  include "Thrust_Levels.asm"

; END OF LEVELS
;--------------



ShipUnit equ 12
ShipVectorList:
  ;rel y, rel x. first coord is not drawn, only moved.
  ;negative y is down, negative x is left
  db  (ShipUnit * 4), (ShipUnit * 0)
  db -(ShipUnit * 6),-(ShipUnit * 3)
  db  (ShipUnit * 0),-(ShipUnit * 1)
  db -(ShipUnit * 2), (ShipUnit * 2)
  db  (ShipUnit * 1), (ShipUnit * 1)
  db  (ShipUnit * 0), (ShipUnit * 2)
  db -(ShipUnit * 1), (ShipUnit * 1)
  db  (ShipUnit * 2), (ShipUnit * 2)
  db  (ShipUnit * 0),-(ShipUnit * 1)
  db  (ShipUnit * 6),-(ShipUnit * 3)
  ;Extra points for thrust-effect at ships tail
  ;\/
  db -(ShipUnit * 7),-(ShipUnit * 1 - 3) ;invisible line from ships tip to tail
  db -(ShipUnit * 2), (ShipUnit * 1 - 3)
  db  (ShipUnit * 2), (ShipUnit * 1 - 3)


SU=8
OrbVectorList:
  db  8                 ;count-1
  db  (SU * 4),-(SU * 2)
  db  (SU * 0), (SU * 4)
  db -(SU * 2), (SU * 2)
  db -(SU * 4), (SU * 0)
  db -(SU * 2),-(SU * 2)
  db  (SU * 0),-(SU * 4)
  db  (SU * 2),-(SU * 2)
  db  (SU * 4), (SU * 0)
  db  (SU * 2), (SU * 2)

;/\
;\/
SU=24
WarpVectorList:
  db  4                 ;count-1
  db  (SU * 2), (SU * 0)
  db -(SU * 2),-(SU * 2)
  db -(SU * 2), (SU * 2)
  db  (SU * 2), (SU * 2)
  db  (SU * 2),-(SU * 2)
  db  $ff       ;end byte so it can be drawn with drawsprite also

ShieldUnit = 17
ShieldVectorList:
  db  (ShieldUnit * 4),-(ShieldUnit * 2)
  db  (ShieldUnit * 0), (ShieldUnit * 4)
  db -(ShieldUnit * 2), (ShieldUnit * 2)
  db -(ShieldUnit * 4), (ShieldUnit * 0)
  db -(ShieldUnit * 2),-(ShieldUnit * 2)
  db  (ShieldUnit * 0),-(ShieldUnit * 4)
  db  (ShieldUnit * 2),-(ShieldUnit * 2)
  db  (ShieldUnit * 4), (ShieldUnit * 0)
  db  (ShieldUnit * 2), (ShieldUnit * 2)

SU=15
RefuelVectorList:
  db  (SU * 4),-(SU * 4)
  db  (SU * 0), (SU * 8)
  db -(SU * 8), (SU * 0)
  db  (SU * 0),-(SU * 8)
  db  (SU * 8), (SU * 0)


;-----------------
;Lines for sprites that use the DrawSprite-routine
;-----------------

;Sprite scale factor. Set to a value that makes the sprites look good when drawn with scale DrawScale
SF set 4

;Sprite unit Height and Width. Relative to size of tiles.
;The "-1" allows a 8x8 -128 -- 127 resolution without hitting 128
SH set ((TileH/8) * SF)-1
SW set ((TileW/8) * SF)-1

SpriteGunNE:
  db 6                  ;count-1
  db  (SH*2),-(SW*4)    ;start pos
  db  (SH*0), (SW*4)
  db -(SH*1), (SW*0)
  db  (SH*0), (SW*2)
  db -(SH*1), (SW*0)
  db  (SH*0), (SW*2)
  db -(SH*2), (SW*0)
  db $FF                ;end

SpriteGunNW:
  db 6                  ;count-1
  db  (SH*2), (SW*4)    ;start pos
  db  (SH*0),-(SW*4)
  db -(SH*1), (SW*0)
  db  (SH*0),-(SW*2)
  db -(SH*1), (SW*0)
  db  (SH*0),-(SW*2)
  db -(SH*2), (SW*0)
  db $FF                ;end

SpriteGunSE:
  db 6                  ;count-1
  db -(SH*2),-(SW*4)    ;start pos
  db  (SH*0), (SW*4)
  db  (SH*1), (SW*0)
  db  (SH*0), (SW*2)
  db  (SH*1), (SW*0)
  db  (SH*0), (SW*2)
  db  (SH*2), (SW*0)
  db $FF                ;end

SpriteGunSW:
  db 6                  ;count-1
  db -(SH*2), (SW*4)    ;start pos
  db  (SH*0),-(SW*4)
  db  (SH*1), (SW*0)
  db  (SH*0),-(SW*2)
  db  (SH*1), (SW*0)
  db  (SH*0),-(SW*2)
  db  (SH*2), (SW*0)
  db $FF                ;end


SpriteFuelCell:
  db 5                  ;count-1
  db -(SH*4),-(SW*4)    ;start pos
  db  (SH*7), (SW*0)
  db  (SH*1), (SW*1)
  db  (SH*0), (SW*6)
  db -(SH*1), (SW*1)
  db -(SH*7), (SW*0)
  db 2                  ;count-1
  db  (SH*2),-(SW*5)    ;start pos
  db  (SH*3), (SW*0)
  db  (SH*0), (SW*2)
  db 1                  ;count-1
  db -(SH*1),-(SW*1)    ;start pos
  db  (SH*0),-(SW*1)
  db $FF                ;end


mVec macro yy,xx
  db (yy*SH),(xx*SW)
  endm



; /\
; \/
;|  |
;|  |
SpriteStationaryPod:
  db 4
  mVec 0,0
  mVec 2,2
  mVec 2,-2
  mVec -2,-2
  mVec -2,2
  db 6
  mVec -4,-4
  mVec 4,0
  mVec 0,2
  mVec -2,2
  mVec 2,2
  mVec 0,2
  mVec -4,0
  db $FF


SpritePowerplant:
  db 6
  mVec 4,3
  mVec -6,0
  mVec 0,-7
  mVec -2,0
  mVec 0,8
  mVec 8,0
  mVec 0,-1
  db 5
  mVec -1,0
  mVec 1,-1
  mVec 0,-4
  mVec -2,-2
  mVec -3,0
  mVec -1,1
  db $FF


;\
;/
SpriteSwitchLeft:
  db 2
  mVec -2,0
  mVec 2,2
  mVec 2,-2
  db $FF
SpriteSwitchRight:
  db 2
  mVec -2,0
  mVec 2,-2
  mVec 2,2
  db $FF


Score150_Lines:
  ;1
  db 1
  mVec 2,-5
  mVec -4,0

  ;5
  db 5
  mVec 4,6
  mVec 0,-4
  mVec -2,0
  mVec 0,4
  mVec -2,0
  mVec 0,-4

  ;0
  db 4
  mVec 4,5
  mVec 0,4
  mVec -4,0
  mVec 0,-4
  mVec 4,0

  db $ff

Score300_Lines:
  ;3
  db 3
  mVec 2,-6
  mVec 0,4
  mVec -4,0
  mVec 0,-4
  db 1
  mVec 2,0
  mVec 0,4

  ;0
  db 4
  mVec 2,1
  mVec 0,4
  mVec -4,0
  mVec 0,-4
  mVec 4,0

  ;0
  db 4
  mVec 0,5
  mVec 0,4
  mVec -4,0
  mVec 0,-4
  mVec 4,0

  db $ff

Score750_Lines:
  ;7
  db 2
  mVec 2,-6
  mVec 0,4
  mVec -4,-4

  ;5
  db 5
  mVec 4,7
  mVec 0,-4
  mVec -2,0
  mVec 0,4
  mVec -2,0
  mVec 0,-4

  ;0
  db 4
  mVec 4,5
  mVec 0,4
  mVec -4,0
  mVec 0,-4
  mVec 4,0

  db $ff


;END OF SPRITES
;-----------------


  include "Thrust_Text.asm"
  include "Thrust_BonusGame.asm"
  include "Thrust_Title.asm"
  include "Thrust_Eeprom.asm"
