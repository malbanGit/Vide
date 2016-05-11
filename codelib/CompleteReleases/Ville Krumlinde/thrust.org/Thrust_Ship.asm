; Code for handling ship and pod movement
; Copyright (C) 2004  Ville Krumlinde

Gravity = 14

; Gamemode settings
ShipShotSpeeds: db 16,32,16
ShipRotateMasks: db 1,3,1


;*****************
Ship_Update:                    ;Update, called from main loop
  direct $c8
  mTestFlag InactiveFlag
  bne suExit

  jsr Ship_Control
  jsr Ship_DoMove
  jsr Ship_UpdateShipPodPos
  bsr Ship_Collisions

  lda GameMode
  cmpa #TimeAttackGame
  bne suExit
  lda LoopCounterLow
  anda #63
  bne suExit
  dec TimeAttackTime
  bne suExit
  mSetFlag GameOverFlag

suExit:
  direct -1
  rts


;*****************
Ship_Collisions:                ;Ship and pod collision tests
  mDecLocals 1,5,0
LocalXmin1=LocalW2
LocalXmax1=LocalW3
LocalYmin1=LocalW4
LocalYmax1=LocalW5
  direct $c8

  ;Ship-tests

  ;Setup hit-rectangle of ship
  ldx ShipX
  leax -(ShipArea/2),x
  stx LocalXmin1,s
  leax ShipArea,x
  stx LocalXmax1,s
  ldx ShipY
  leax -(ShipArea/2),x
  stx LocalYmin1,s
  leax ShipArea,x
  stx LocalYmax1,s
  leau LocalXmin1,s
  jsr ValidateX
  leau LocalXmax1,s
  jsr ValidateX

;TODO?
;  ldx ShipX
;  ldy ShipY
;  mMakeRect LocalXmin1,ShipArea

  ldu CurLevelEntry             ;Collision ship vs fuel
  ldu leFuel,u
  lda ,u+                       ;load count
  sta LocalB1,s
  clra
  ldb FuelActive
scoVsFuelLoop:
  asrb
  bcc scoVsNextFuel
  std LocalW1,s
  mTestAreaVsArea LocalXmin1,LocalXmax1,LocalYmin1,LocalYmax1,0,2,FuelArea,scoVsFuelMiss
  bra scoExplodeShip
scoVsFuelMiss:
  ldd LocalW1,s
scoVsNextFuel:
  leau FuelEntry,u
  inca
  cmpa LocalB1,s
  bne scoVsFuelLoop

  leau LocalXmin1,s             ;Collision ship vs level
  jsr RectVsLevel
  bcs scoExplodeShip

  ldu CurLevelEntry             ;Collision ship vs powerplant
  leau lePowerX,u
  mTestAreaVsArea LocalXmin1,LocalXmax1,LocalYmin1,LocalYmax1,0,2,PlantArea,scoVsPowerMiss
  bra scoExplodeShip
scoVsPowerMiss:

;  mTestFlag HasOrbFlag
;  bne scoVsPodMiss
  ldu CurLevelEntry             ;Collision ship vs stationary pod
  leau leOrbX,u
  mTestAreaVsArea LocalXmin1,LocalXmax1,LocalYmin1,LocalYmax1,0,2,StationaryPodArea,scoVsPodMiss
  bra scoExplodeShip
scoVsPodMiss:

  bra scoPodTests

scoExplodeShip:
  jsr ExplodeShip
  jmp scoExit

  ;Pod-tests

scoPodTests:
  mTestFlag HasOrbFlag
  lbeq scoNoPod

  ;Setup hit-rectangle of pod
  ldx PodX
  leax -(PodArea/2),x
  stx LocalXmin1,s
  leax PodArea,x
  stx LocalXmax1,s
  ldx PodY
  leax -(PodArea/2),x
  stx LocalYmin1,s
  leax PodArea,x
  stx LocalYmax1,s
  leau LocalXmin1,s
  jsr ValidateX
  leau LocalXmax1,s
  jsr ValidateX

  leau LocalXmin1,s             ;Collision pod vs level
  jsr RectVsLevel
  bcs scoExplodeShip

  ldu CurLevelEntry             ;Collision pod vs fuel
  ldu leFuel,u
  lda ,u+                       ;load count
  sta LocalB1,s
  clra
  ldb FuelActive
scoPodVsFuelLoop:
  asrb
  bcc scoPodVsNextFuel
  std LocalW1,s
  mTestAreaVsArea LocalXmin1,LocalXmax1,LocalYmin1,LocalYmax1,0,2,FuelArea,scoPodVsFuelMiss
  bra scoExplodeShip
scoPodVsFuelMiss:
  ldd LocalW1,s
scoPodVsNextFuel:
  leau FuelEntry,u
  inca
  cmpa LocalB1,s
  bne scoPodVsFuelLoop

  ldu CurLevelEntry             ;Collision pod vs powerplant
  leau lePowerX,u
  mTestAreaVsArea LocalXmin1,LocalXmax1,LocalYmin1,LocalYmax1,0,2,PlantArea,scoPodVsPowerMiss
  bra scoExplodeShip
scoPodVsPowerMiss:

scoNoPod:


scoExit:

  direct -1
  mFreeLocals
  rts


;*****************
Ship_Loaded:            ;Set pod to be carried by ship
  direct $c8

  ldy CurLevelEntry
  mClearFlag PullFlag
  mSetFlag HasOrbFlag

  ;Calculate center coordinate
  ldd leOrbX,y
  subd ShipX
  asra
  rorb
  addd ShipX
  std CenterX

  ldd leOrbY,y
  subd ShipY
  asra
  rorb
  addd ShipY
  std CenterY

  jsr Ship_FindLoadAngle
  sta AlphaHi

  jsr Ship_UpdateShipPodPos ;Pod and ship coords need to be recalced

  lda GameMode
  cmpa #NormalGame
  bne slSkipHalf
  ldd ShipSpeedX            ;half speed
  asra
  rorb
  std ShipSpeedX
  ldd ShipSpeedY
  asra
  rorb
  std ShipSpeedY
slSkipHalf:

  mEmitFx FxTargetPod,FxTypePickUpPod,0
  direct -1
  rts


;*****************
Ship_FindLoadAngle:
  ;Find the angle between pod and ship when pod is picked up.
  ;Loop the distance table and find the best match, this is the angle.
  ;This is quite slow but it is only called once during pick up.
  direct $c8
  mDecLocals 5,0,0
LocalDx = LocalB1
LocalDy = LocalB2
LocalBest = LocalB3
LocalLoop = LocalB4
LocalBestI = LocalB5

  ; ShipX := PixX + DistanceLUT[ I ];
  ; ShipY := PixY - DistanceLUT[ I+1 ];
  ; PodX := PixX - DistanceLUT[ I ];
  ; PodY := PixY + DistanceLUT[ I+1 ];

  ldy CurLevelEntry

  ldd ShipX
  subd leOrbX,y
  rola
  rorb
  stb LocalDx,s
  ;b=distance/2, with sign bit

  ldd leOrbY,y
  subd ShipY
  rola
  rorb
  stb LocalDy,s
  ;b=distance/2, with sign bit

  lda #127
  sta LocalBest,s
  clr LocalBestI,s

  ldu #DistanceTable
  lda #ALPHA_MAX
  sta LocalLoop,s
flaLoop:
  lda LocalDx,s
  suba ,u
  bpl flaXPos
    nega
flaXPos:
  sta -1,s

  lda LocalDy,s
  suba 1,u
  bpl flaYPos
    nega
flaYPos:
  adda -1,s

  cmpa LocalBest,s
  bge flaNotBetter
    sta LocalBest,s
    lda LocalLoop,s
    sta LocalBestI,s
flaNotBetter:

  leau 2,u
  dec LocalLoop,s
  bne flaLoop

  lda #ALPHA_MAX
  suba LocalBestI,s

  mFreeLocals
  direct -1
  rts


;*****************
Ship_DemoControl:                        ;read input from demo data, return state in a
  direct $c8

  ldx DemoPtr

  lda DemoCounter
  bne sdcDecCounter
    leax 2,x
    stx DemoPtr
    lda 1,x
    inca
sdcDecCounter:
  deca
  sta DemoCounter

  lda ,x

  direct -1
  rts


Button1 = 1
Button2 = 2
Button3 = 4
Button4 = 8
JoyLeft = 16
JoyRight = 32
JoyDown = 128

;*****************
Ship_ConsoleControl:                    ;read input from joy + buttons, return state in a
  direct $c8

  ;DP must be D0 when reading joystick
  mDptoD0

  jsr read_joystick

  ;A must have bit set for firebutton, to disable autofire
  lda #$1
  ldb ButtonConfig
  bpl sccNo2Fire
    lsla
    lsla
sccNo2Fire:
  rolb
  bpl sccNo1Fire
    lsla
sccNo1Fire:
  jsr read_switches

  ;Back to C8
  mDptoC8

  clra
  ldx #$C812

  ldb ButtonConfig

  stb -1,s
  andb #3
  tst b,x
  beq sccNoButton4
    ora #Button4
sccNoButton4:
  ldb -1,s

  lsrb
  lsrb
  stb -1,s
  andb #3
  tst b,x
  beq sccNoButton3
    ora #Button3
sccNoButton3:
  ldb -1,s

  lsrb
  lsrb
  stb -1,s
  andb #3
  tst b,x
  beq sccNoButton2
    ora #Button2
sccNoButton2:
  ldb -1,s

  lsrb
  lsrb
  tst b,x
  beq sccNoButton1
    ora #Button1
sccNoButton1:

  ldb $c81b     ;read joystick
  beq sccNoJoy
  bpl sccRight
    ora #JoyLeft
    bra sccNoJoy
sccRight:
    ora #JoyRight
sccNoJoy:

  ldb $c81c     ;todo: test down is lock
  beq sccNoUpDown
  bpl sccUp
    ora #JoyDown
    bra sccNoUpDown
sccUp:
sccNoUpDown:

  direct -1
  rts

;*****************
Ship_Control:
  mDecLocals 2,1,4
LocalInput = LocalB1
LocalFuelCount = LocalB2
  direct $c8

  lda DemoMode
  bpl scNoDemo
    bsr Ship_DemoControl        ;read input from recorded demo data
    bra scInputFin
scNoDemo:                       ;read input from console
    bsr Ship_ConsoleControl
scInputFin:
  sta LocalInput,s

  if DemoRecord=1
    ;Unused instruction signal VecxMod to sample user input.
    db $14
  endif

  lda GameMode                  ;lock thrust, button 4
  cmpa #HardGame
  bne scLockFinish
  lda LocalInput,s
  bita #Button4 | JoyDown
  beq scNoLock
    ora #Button3        ;lock automatically also thrusts
    sta LocalInput,s
  mTestFlag LockedThrustFlag
  bne scLockFinish
;  lda ShipAngle
;  sta LockedShipAngle
  ldb #8  ;Lock up or down depending on gravity
  mTestFlag ReverseGravFlag
  beq scLockAngleUp
    addb #SHIP_DIRMAX/2
scLockAngleUp:
  stb LockedShipAngle
  mSetFlag LockedThrustFlag
  bra scLockFinish
scNoLock:
  mClearFlag LockedThrustFlag
scLockFinish:


  ;Thrust
  lda LocalInput,s
  bita #Button3
;  tst stick1_button3
  beq scNotPressed_3
    ldd ShipFuel
    beq scNotPressed_3          ;Ship must have fuel left
    mEmitSound ThrustSoundId
    mSetFlag ThrustFlag
    jsr Ship_DoThrust
    bra scThrustFin
scNotPressed_3:                 ;No thrust
    mClearFlag ThrustFlag
scThrustFin:


;  tst stick1_button1            ;Firebutton
  lda LocalInput,s
  bita #Button1
  beq scFireFinish
    mTestFlag ShieldFlag        ;can't fire while using shield
    bne scFireFinish
    ;Find free
    ldy #ShipShotList
    lda #ShipShotCount
scFire1:
    tst ssShotActive,y
    beq scFreeFound
    leay ShipShotEntry,y
    deca
    bne scFire1
    bra scFireFinish            ;No free found
scFreeFound:
    mEmitSound ShipFireSoundId
    com ssShotActive,y          ;Set active
    ldb ShipAngle               ;Calc rise & run, use angle from ship
    mShipAngleToVec b
    ldx #ShipShotSpeeds
    lda GameMode
    lda a,x                     ;scale
    jsr convert_angle_to_rise_run  ;dp must be c8
    ;D holds result, optimize assign both with std
    nega                        ;Y axis points down in our world
    sta ssShotVelocY,y
    stb ssShotVelocX,y
    ldd ShipX                   ;Set start position, use ship coordinates
    std ssShotX,y
    ldd ShipY
    std ssShotY,y
scFireFinish:


  ldb GameMode
  ldx #ShipRotateMasks
  lda LoopCounterLow
  anda b,x
  beq scLRFinished

;  lda $c81b
  lda LocalInput,s
  anda #JoyLeft | JoyRight
  beq scLRFinished
  bita #JoyLeft
  bne scRotateLeft
    dec ShipAngle               ;Rotate right
    bpl scLRFinished
      lda #SHIP_DIRMAX-1
      sta ShipAngle
    bra scLRFinished
scRotateLeft:                   ;Rotate left
   inc ShipAngle
   lda ShipAngle
   cmpa #SHIP_DIRMAX
   blt scLRFinished
     clr ShipAngle
scLRFinished:


  ;Shield/pull
  lda LocalInput,s
  bita #Button2
;  tst stick1_button2
  lbeq scNoShield
    ldd ShipFuel
    lbeq scNoShield             ;Ship must have fuel left

    mSetFlag ShieldFlag
    mEmitSound ShieldSoundId

    ldd ShipX                   ;Set up buffer with coords of a point under ship
    std LocalBuffer,s
    ldd ShipY
    addd #RefuelDistance / 2
    std LocalBuffer+2,s
    leay LocalBuffer,s

    lda GameMode                ;Refuel while carrying pod is only allowed in hard+ mode
    cmpa #HardGame
    beq scGoFuelTest
    mTestFlag HasOrbFlag
    lbne scSkipFuelTest
scGoFuelTest:

    ldu CurLevelEntry           ;Test if fuel is under ship
    ldu leFuel,u
    lda ,u+                     ;load count
    sta LocalFuelCount,s
    clra
    ldb FuelActive
scFuelLoop:
    asrb
    lbcc scNextFuel
    std LocalW1,s
    ;point is fuel-pos, rect is area under ship
    mPointVsRect (FuelArea+4),RefuelDistance,scFuelMiss, 0,2, 0,2

    mSetFlag RefuelFlag         ;Fuel found

    lda LocalW1,s
    mEmitFx FxTargetFuel,FxTypeRefueling,a

    lda LoopCounterLow          ;Refuel one unit every 4th frame
    anda #3
    lbne scShieldFin

    ldx #FuelAmounts            ;Decrease amount in fuel cell, remove if empty
    lda LocalW1,s
    ldb a,x
    decb
    stb a,x
    lbne scShieldFin

    mEmitFx FxTargetFuel,FxTypeFuelCell,a
    lda LocalW1,s
    mEmitFx FxTargetFuel,FxTypeScore300,a

    lda LocalW1,s
    mClearBitA FuelActive

    mGiveScore 300

    bra scShieldFin
scFuelMiss:
    ldd LocalW1,s
scNextFuel:
    leau FuelEntry,u
    inca
    cmpa LocalFuelCount,s
    bne scFuelLoop
scSkipFuelTest:
    mClearFlag RefuelFlag       ;no fuel found


    mTestFlag HasOrbFlag        ;Test if pod is under ship
    bne scShieldFin

    ldd ShipY
    std LocalBuffer+2,s
    leay LocalBuffer,s

    ldu CurLevelEntry           ;point is pod-pos, rect is area under ship
    leau leOrbX,u
    mPointVsRect BeamLength*2,BeamLength*2,scPodMiss, 0,2, 0,2
    mSetFlag PullFlag           ;pod found
    bra scShieldFin
scPodMiss:
    mTestFlag PullFlag
    beq scShieldFin
      ;Ship has pulled the pod loose from the platform
      jsr Ship_Loaded
    bra scShieldFin
scNoShield:
    mClearFlag (ShieldFlag | RefuelFlag | PullFlag)
scShieldFin:

  ;Decrease 'perfect' bonus when shield is used (and no pull/refuel/invisible)
  mTestFlag ShieldFlag
  beq scSkipPerfect
  lda LoopCounterLow
  anda #7
  bne scSkipPerfect
  mTestFlag RefuelFlag
  bne scSkipPerfect
  mTestFlag PullFlag
  bne scSkipPerfect
  mTestFlag NoLandscapeFlag
  bne scSkipPerfect
    lda PerfectBonus
    cmpa #2                     ;don't decrease below 2
    ble scSkipPerfect
      deca
      sta PerfectBonus
scSkipPerfect:

scExit:
  mFreeLocals
  direct -1
  rts





;*****************
Ship_Draw:
  ;DP must be D0
  ;allocate buffer for rotated vectors
  mDecLocals 0,2,((ShipVectorCount+ThrustVectorCount)*2)
LocalShip = LocalW1
LocalPlatform = LocalW2
LocalOrb = LocalW2

  mTestFlag InactiveFlag
  lbne sddExit

  ;Rotate vectors before reset pen, otherwise position will drift
  ldb #ShipVectorCount-1
  mTestFlag ThrustFlag
  beq sddNoThrust1
    addb #ThrustVectorCount
sddNoThrust1:
  lda ShipAngle
  mShipAngleToVec a
  ldx #ShipVectorList
  leau LocalBuffer,s            ;Vector buffer
  jsr rot_vec_list2             ;Rotate vectors

  jsr reset0ref                 ;Reset pen

  mGetScreenX ShipX
  subb #128
  pshs b

  ldd ShipY
  subd ViewY
  negb
  tfr b,a
  puls b
  adda #127
  std LocalShip,s               ;Save ship screen coords
  jsr move_pen7f_to_d           ;Set pen position to value of d register

  mSetIntensity $4f

  leax LocalBuffer,s            ;Vector buffer
  lda   #ShipVectorCount-1      ;Nr of vectors in list
  ldb   #DrawScale              ;Scale
  jsr   move_draw_VL4           ;Draw list

  mTestFlag ThrustFlag          ;Draw thrust-tail effect
  beq sddNoThrust2
    lda LoopCounterLow
    ;asra
    asla
    asla
    asla
    anda #63
    ;adda #40
    mSetIntensity
    leax LocalBuffer+(ShipVectorCount*2),s            ;Vector buffer
    ldb   #DrawScale              ;Scale
  lda LoopCounterLow
  lsra
  lsra
; lda $C87D+2
; lda ShipSpeedX
; adda ShipSpeedY
; mRandomToA
;  adda DrawList
;  asra
  anda #3
  sta -1,s
  addb -1,s
;    lda LoopCounterLow
;    rora
;    rora
;    anda #0
;    sta -1,s
;    subb -1,s
    lda   #ThrustVectorCount-1      ;Nr of vectors in list
    jsr   move_draw_VL4           ;Draw list
sddNoThrust2:

  mTestFlag ShieldFlag          ;Test for shield
  beq sddNoShield
    jsr reset0ref
    lda #$4f                    ;draw shield
    ldb LoopCounterLow
    andb #31
    stb -1,s
    suba -1,s
    mSetIntensity
    ldd LocalShip,s
    jsr move_pen7f_to_d

    lda #%10001000              ;set drawing pattern
    ldb LoopCounterLow
    lsrb
    lsrb
    andb #3
sddRor:
    beq sddRorFin
    rora
    decb
    bra sddRor
sddRorFin:
    sta $c829

    mSetScale DrawScale

    ldx #ShieldVectorList
    lda #8-1
    jsr FxMoveDrawPattern
sddNoShield:


  mTestFlag LockedThrustFlag
  beq sddNoLock
    ldb #ShipVectorCount-1
    lda LockedShipAngle
    mShipAngleToVec a
    ldx #ShipVectorList
    leau LocalBuffer,s            ;Vector buffer
    jsr rot_vec_list2             ;Rotate vectors

    jsr reset0ref                 ;Reset pen
    mSetIntensity $4f

    ldd LocalShip,s               ;load ship screen coords
    jsr move_pen7f_to_d           ;Set pen position to value of d register

    mTicToc 32
    adda #48
    mSetScale

    mSetByte Pattern,%10001000
    leax LocalBuffer,s            ;Vector buffer
    lda #ShipVectorCount-2        ;Nr of vectors in list
    jsr FxMoveDrawPattern
sddNoLock:


  mTestFlag HasOrbFlag
  beq sddNoOrb
    mSetIntensity $4f
    mGetScreenX PodX
    subb #128
    pshs b
    ldd PodY
    subd ViewY
    negb
    tfr b,a
    puls b
    adda #127
    std LocalOrb,s

    jsr reset0ref               ;Draw Orb
    ldd LocalOrb,s
    jsr move_pen7f_to_d
    ldx #OrbVectorList
    lda ,x+
    ldb #DrawScale
    jsr move_draw_VL4

    jsr reset0ref               ;Draw tractor beam
    ldd LocalShip,s
    jsr move_pen7f_to_d
    ldd LocalShip,s
    suba LocalOrb,s
    nega
    subb LocalOrb+1,s
    negb
    std LocalBuffer,s
    leax LocalBuffer,s
    mSetByte $c829,%10001000    ;use a pattern to draw the beam
    clra
    jsr dwp_with_count
sddNoOrb:


  mTestFlag PullFlag            ;Test if ship is pulling orb from platform
  beq sddNoPull
    mSetIntensity $4f           ;Draw tractor beam from ship to orb-platform

    ldu CurLevelEntry
    mGetScreenX leOrbX,u
    subb #128
    pshs b
    ldd leOrbY,u
    subd ViewY
    negb
    addb #4
    tfr b,a
    puls b
    adda #127
    std LocalPlatform,s

    jsr reset0ref
    ldd LocalShip,s
    jsr move_pen7f_to_d
    ldd LocalShip,s
    suba LocalPlatform,s
    nega
    subb LocalPlatform+1,s
    negb
    jsr draw_to_d
sddNoPull:

sddExit:
  mFreeLocals
  rts



;*****************
Ship_DoMove:                    ;Update centerx/y and alpha
  direct $c8

  mTestFlag HasOrbFlag
  beq sdmNoPod

  ;Alpha += dAlpha, 0..WDIRMAX

;  lda LoopCounterLow
;  anda #SpinFrameMask
;  bne sdmSkipAlpha

  ldd AlphaDelta
  bmi sdmNegD
  addd Alpha
  cmpa #ALPHA_MAX
  blo sdmAlphaOk
    suba #ALPHA_MAX
    bra sdmAlphaOk
sdmNegD:
  ldd Alpha
  addd AlphaDelta
  cmpa #ALPHA_MAX
  blo sdmAlphaOk
    adda #ALPHA_MAX
sdmAlphaOk:
  std Alpha
;sdmSkipAlpha:

  ;Alpha damping

  lda FrameCounter
  anda #FRAME4MASK
  bne sdmExitAlphaDamping
  lda #-1
  ldx AlphaDelta
  beq sdmExitAlphaDamping
  bmi *+3
    nega
  leax a,x
  stx AlphaDelta
sdmExitAlphaDamping:

sdmNoPod:

  ;SpeedX damping + range test
  ldd ShipSpeedX
  beq sdmNoXDamping
  tfr a,b
  asrb
  bmi sdmNegXDamping
  incb
  bra sdmXDampStore
sdmNegXDamping:
  decb
sdmXDampStore:
  negb
  sex
  addd ShipSpeedX
SpeedMax = 12                   ;keep x speed in range
  cmpa #SpeedMax
  blt sdmXHiOk
    lda #SpeedMax
sdmXHiOk:
  cmpa #-SpeedMax
  bge sdmXRangeFin
    lda #-SpeedMax
sdmXRangeFin:
  std ShipSpeedX
sdmNoXDamping:

  ;Gravity + range test
  ldb #Gravity
  mTestFlag ReverseGravFlag
  beq sdmNormalGrav
    negb
    asrb ;try smaller gravity in reverse
sdmNormalGrav:
  sex
  addd ShipSpeedY
  cmpa #SpeedMax                ;keep y speed in range
  blt sdmYHiOk
    lda #SpeedMax
sdmYHiOk:
  cmpa #-SpeedMax
  bge sdmYRangeFin
    lda #-SpeedMax
sdmYRangeFin:
  std ShipSpeedY

  ;Center += ShipSpeed

  ldb ShipSpeedXHi
  sex
  std -2,s
  ldx #CenterX
  mGet_D_from_fixed
  addd -2,s
  mStore_D_as_fixed

  ldb ShipSpeedYHi
  sex
  std -2,s
  ldx #CenterY
  mGet_D_from_fixed
  addd -2,s
  mStore_D_as_fixed

  ldu #CenterX
  jsr ValidateX

  direct -1
  rts



;*****************
Ship_DoThrust:                  ;Adjust speed and spin
  direct $c8
  mDecLocals 1,0,0
LocalAngle = LocalB1

  mTestFlag LockedThrustFlag
  bne sdtLocked
  lda ShipAngle
  bra sdtStoreAngle
sdtLocked:
  lda LockedShipAngle
sdtStoreAngle:
  sta LocalAngle,s

;  lda LocalAngle,s
  lsla
  ldx #AccelTable
  leax a,x

  mTestFlag HasOrbFlag
  beq sdtNoPod

  ;ax := AccelLUT[ dir*2 ];
  ;ay := AccelLUT[ dir*2+1 ];
  ldb ,x
  sex
  addd ShipSpeedX
  std ShipSpeedX

  ldb 1,x
  sex
  addd ShipSpeedY
  std ShipSpeedY

  ;adjust spin
;  lda LoopCounterLow
;  anda #SpinFrameMask
;  bne sdtSkipAlpha
  lda FrameCounter
  anda #FRAME6MASK
  bne sdtSkipAlpha

  ;calc index into spin-table
  lda LocalAngle,s
  ldx #ShipAngleToAlpha
  lda a,x
  suba AlphaHi
  bcc sdtIdxOk
    adda #ALPHA_MAX
sdtIdxOk:

  ;Calc index into sine-table, and decide if value is positive or negative
  clrb
  cmpa #ALPHA_MAX/2
  blo sdtSinPositive
    suba #ALPHA_MAX/2
    decb
sdtSinPositive:
  ;IF W >= 60 then W := 120 - W;
  cmpa #ALPHA_MAX/4
  blo sdtNegSkip
    eora #$FF
    adda #ALPHA_MAX/2
sdtNegSkip:
  lsra                          ;a = 0..30, b = -1 if value is negative

  ldx #SpinSinTab
  lda a,x
  tstb
  beq sdtPositive
    nega
sdtPositive:
  tfr a,b
  sex

  addd AlphaDelta
  std AlphaDelta
sdtSkipAlpha:

  bra sdtExit

sdtNoPod:
  ;ax := AccelLUT[ dir*2 ] * 2;
  ;ay := AccelLUT[ dir*2+1 ] * 2;
  ldb ,x
  sex
  aslb
  rola
  addd ShipSpeedX
  std ShipSpeedX

  ldb 1,x
  sex
  aslb
  rola
  addd ShipSpeedY
  std ShipSpeedY

sdtExit:

  mFreeLocals
  direct -1
  rts


;*****************
Ship_UpdateShipPodPos:                  ;refresh ship/pod coords from center-coords
  ;Must be called after every change to centerx/y to keep ship in sync
ShipExitY = WorldTopY + 50              ;exit below world top so that warp-out effect is visible
  direct $c8

  mTestFlag HasOrbFlag
  beq uspNoPod

  ;Update ship and pod

  ; I := Hi(nAlpha) * 2;
  ldx #DistanceTable
  ldb AlphaHi
  clra
  lslb
  rola
  leax d,x

  ; ShipX := PixX + DistanceLUT[ I ];
  ; ShipY := PixY - DistanceLUT[ I+1 ];
  ; PodX := PixX - DistanceLUT[ I ];
  ; PodY := PixY + DistanceLUT[ I+1 ];
  lda ,x
  ldy CenterX
  leay a,y
  sty ShipX

  nega
  ldy CenterX
  leay a,y
  sty PodX

  lda 1,x
  ldy CenterY
  leay a,y
    cmpy #ShipExitY
    bgt uspPodYOk
    bra uspExitLevel
uspPodYOk:
  sty PodY

  nega
  ldy CenterY
  leay a,y
    cmpy #ShipExitY
    bgt uspShipYOk
    bra uspExitLevel
uspShipYOk:
  sty ShipY

  ldu #ShipX
  bsr ValidateX
  ldu #PodX
  bsr ValidateX

  bra uspExit

uspExitLevel:                   ;Top of world: end of mission
  mSetFlag InactiveFlag         ;disable ship movement
  mEmitFx FxTargetShip,FxTypeWarpOut,0
  mTestFlag HasOrbFlag
  beq uspExit
  mEmitFx FxTargetPod,FxTypeWarpOut,0
  bra uspExit

uspNoPod:                       ;update ship only
  ldd CenterX
  std ShipX
  ldd CenterY
  cmpd #ShipExitY
  ble uspExitLevel
  std ShipY

  ldu #ShipX
  bsr ValidateX

uspExit:

  direct -1
  rts


;*****************
ValidateX:                      ;u=pointer to x coord
  direct $c8
  ldd ,u
  tsta                          ;Check for world ends
  bpl vxCheckRightEdge
    addd CurLevelEndX           ;Left end hit, wrap
;    subd #1
    std ,u
    bra vxXOk
vxCheckRightEdge:
    subd CurLevelEndX
    bmi vxXOk
    std ,u              ;Right edge hit
vxXOk:
  direct -1
  rts


;Distance from center to ship/pod. Xy-pairs.
;This is the complete circle, we could use 1/4 circle instead to save some bytes
DistanceTable:
 db 30,0, 30,0, 29,1, 29,1, 29,3, 29,3, 29,4, 29,4, 29,6, 29,6, 28,7, 28,7, 28,9, 28,9, 28,10, 28,10
 db 27,12, 27,12, 26,13, 26,13, 25,15, 25,15, 25,16, 25,16, 24,17, 24,17, 23,18, 23,18, 22,20, 22,20
 db 21,21, 21,21, 20,22, 20,22, 18,23, 18,23, 17,24, 17,24, 16,25, 16,25, 14,25, 14,25, 13,26, 13,26
 db 12,27, 12,27, 10,28, 10,28, 9,28, 9,28, 7,28, 7,28, 6,29, 6,29, 4,29, 4,29, 3,29, 3,29, 1,29, 1,29
 db 0,30, 0,30, -1,29, -1,29, -3,29, -3,29, -4,29, -4,29, -6,29, -6,29, -7,28, -7,28, -9,28, -9,28
 db -10,28, -10,28, -12,27, -12,27, -13,26, -13,26, -15,25, -15,25, -16,25, -16,25, -17,24, -17,24
 db -18,23, -18,23, -20,22, -20,22, -21,21, -21,21, -22,20, -22,20, -23,18, -23,18, -24,17, -24,17
 db -25,16, -25,16, -25,14, -25,14, -26,13, -26,13, -27,12, -27,12, -28,10, -28,10, -28,9, -28,9
 db -28,7, -28,7, -29,6, -29,6, -29,4, -29,4, -29,3, -29,3, -29,1, -29,1, -30,0, -30,0, -29,-1, -29,-1
 db -29,-3, -29,-3, -29,-4, -29,-4, -29,-6, -29,-6, -28,-7, -28,-7, -28,-9, -28,-9, -28,-10, -28,-10
 db -27,-12, -27,-12, -26,-13, -26,-13, -25,-15, -25,-15, -25,-16, -25,-16, -24,-17, -24,-17, -23,-18
 db -23,-18, -22,-20, -22,-20, -21,-21, -21,-21, -20,-22, -20,-22, -18,-23, -18,-23, -17,-24, -17,-24
 db -16,-25, -16,-25, -14,-25, -14,-25, -13,-26, -13,-26, -12,-27, -12,-27, -10,-28, -10,-28, -9,-28
 db -9,-28, -7,-28, -7,-28, -6,-29, -6,-29, -4,-29, -4,-29, -3,-29, -3,-29, -1,-29, -1,-29, 0,-30
 db 0,-30, 1,-29, 1,-29, 3,-29, 3,-29, 4,-29, 4,-29, 6,-29, 6,-29, 7,-28, 7,-28, 9,-28, 9,-28, 10,-28
 db 10,-28, 12,-27, 12,-27, 13,-26, 13,-26, 15,-25, 15,-25, 16,-25, 16,-25, 17,-24, 17,-24, 18,-23
 db 18,-23, 20,-22, 20,-22, 21,-21, 21,-21, 22,-20, 22,-20, 23,-18, 23,-18, 24,-17, 24,-17, 25,-16
 db 25,-16, 25,-14, 25,-14, 26,-13, 26,-13, 27,-12, 27,-12, 28,-10, 28,-10, 28,-9, 28,-9, 28,-7, 28,-7
 db 29,-6, 29,-6, 29,-4, 29,-4, 29,-3, 29,-3, 29,-1, 29,-1

;Acceleration values xy-pairs for each ship direction
AccelTable:
 db 25,0, 24,-4, 23,-9, 20,-13, 17,-17, 13,-20, 9,-23, 4,-24, 0,-25, -4,-24
 db -9,-23, -13,-20, -17,-17, -20,-13, -23,-9, -24,-4, -25,0, -24,4, -23,9
 db -20,13, -17,17, -13,20, -9,23, -4,24, 0,25, 4,24, 9,23, 13,20, 17,17
 db 20,13, 23,9, 24,4

;Map ShipAngle -> AlphaDir
ShipAngleToAlpha:
 db   0,  8, 15, 23, 30, 38, 45, 53
 db  60, 68, 75, 83, 90, 98,105,113
 db 120,128,135,143,150,158,165,173
 db 180,188,195,203,210,218,225,233

;Contains sine-values for a quarter of a circle
SpinSinTab:
 db   0,  3,  5,  8, 10, 13, 15, 18, 20, 23
 db  25, 27, 29, 31, 33, 35, 37, 39, 40, 42
 db  43, 45, 46, 47, 48, 48, 49, 49, 50, 50
 db  50

DemoList:
  dw DemoData1,DemoData2,DemoData3

;Recorded demo data
;First two bytes: start level, reserved
DemoData1:
 db 0,0
 db $00, $0b, $10, $07, $00, $01, $0c, $07, $20, $09, $2c, $0c, $0c, $0a, $2c, $03
 db $20, $08, $21, $00, $00, $08, $01, $00, $00, $05, $10, $00, $00, $00, $01, $00
 db $00, $05, $01, $00, $00, $05, $01, $00, $00, $03, $01, $00, $00, $00, $10, $0b
 db $1c, $15, $0c, $14, $1c, $07, $0c, $15, $00, $02, $20, $0c, $0c, $07, $00, $09
 db $0c, $05, $00, $11, $20, $02, $2c, $06, $0c, $00, $00, $09, $10, $06, $00, $08
 db $20, $02, $2c, $04, $0c, $04, $1c, $07, $0c, $01, $00, $0b, $02, $06, $12, $06
 db $1e, $02, $0e, $05, $02, $04, $0e, $01, $2e, $02, $22, $05, $2e, $03, $0e, $00
 db $02, $04, $0e, $0b, $02, $0c, $22, $01, $2e, $07, $0e, $0b, $2e, $04, $02, $00
 db $00, $06, $20, $03, $00, $0b, $20, $04, $00, $0e, $01, $00, $00, $04, $01, $00
 db $00, $06, $01, $00, $00, $01, $10, $02, $11, $00, $10, $03, $11, $00, $10, $13
 db $1c, $00, $0c, $07, $2c, $0c, $0c, $15, $1c, $07, $0c, $01, $00, $04, $10, $0c
 db $1c, $02, $0c, $03, $0e, $0b, $2e, $0f, $0e, $10, $1e, $05, $0e, $19, $2e, $06
 db $0e, $29, $1e, $01, $0e, $7d

DemoData2:
 db 1,0
 db $00, $0f, $20, $07, $2c, $01, $0c, $12, $00, $02, $10, $20, $00, $17, $01, $00
 db $00, $08, $20, $0a, $2c, $0f, $0c, $0f, $20, $06, $0c, $07, $1c, $02, $0c, $02
 db $00, $03, $20, $05, $2c, $01, $0c, $06, $00, $09, $10, $19, $00, $04, $0c, $0c
 db $00, $0b, $0c, $06, $00, $19, $20, $03, $00, $11, $10, $04, $00, $00, $0c, $05
 db $00, $02, $20, $06, $2c, $01, $0c, $12, $2c, $14, $20, $00, $00, $26, $01, $00
 db $00, $06, $01, $00, $00, $06, $10, $01, $1c, $0b, $1e, $02, $0e, $0a, $0c, $09
 db $1c, $05, $0c, $0d, $2c, $08, $20, $03, $00, $01, $01, $00, $00, $06, $01, $00
 db $00, $07, $01, $00, $00, $05, $01, $00, $00, $08, $01, $00, $00, $00, $10, $01
 db $00, $04, $01, $00, $00, $0b, $01, $00, $00, $07, $0c, $06, $1c, $0b, $0c, $0f
 db $1c, $06, $10, $02, $00, $12, $20, $07, $00, $12, $20, $07, $00, $02, $0c, $13
 db $00, $27, $0c, $0b, $00, $07, $20, $0c, $00, $06, $0c, $03, $1c, $0a, $0c, $01
 db $00, $03, $01, $00, $00, $07, $10, $0a, $02, $0e, $22, $08, $2e, $01, $0e, $0b
 db $1e, $0a, $0e, $08, $02, $05, $0c, $09, $00, $14, $20, $04, $00, $06, $01, $00
 db $00, $0b, $10, $02, $12, $01, $02, $06, $0e, $02, $2e, $04, $22, $07, $02, $01
 db $0e, $0a, $1e, $0f, $0e, $03, $02, $02, $00, $10, $10, $03, $00, $0b, $01, $00
 db $00, $07, $01, $00, $00, $06, $01, $00, $00, $06, $01, $00, $00, $06, $2c, $06
 db $0c, $0c, $1c, $04, $0c, $06, $00, $06, $20, $03, $00, $07, $01, $00, $00, $06
 db $01, $00, $00, $07, $01, $00, $00, $04, $01, $00, $00, $01, $0c, $04, $2c, $0a
 db $0c, $10, $00, $00, $10, $01, $00, $08, $01, $00, $00, $05, $01, $00, $00, $04
 db $01, $00, $00, $04, $01, $00, $00, $08, $01, $00, $00, $07, $01, $00, $00, $06
 db $0c, $05, $2c, $08, $0c, $0a, $1c, $01, $10, $06, $00, $01, $01, $00, $00, $09
 db $01, $00, $00, $0e, $0c, $05, $2c, $00, $20, $07, $00, $00, $02, $08, $12, $06
 db $0e, $35, $00, $05, $20, $0d, $0c, $08, $00, $04, $10, $05, $1c, $07, $0c, $0e
 db $1c, $03, $0c, $13, $2c, $04, $0c, $19, $1c, $03, $0c, $60, $1c, $03, $0c, $5c
 db $00, $51

DemoData3:
 db 2,0
 db $00, $06, $20, $0f, $2c, $02, $0c, $09, $00, $0d, $10, $1a, $0c, $03, $0e, $07
 db $2e, $06, $0e, $00, $02, $02, $0e, $18, $02, $05, $0e, $03, $2e, $08, $0e, $0c
 db $2e, $01, $2c, $00, $20, $0a, $2c, $00, $0c, $08, $1c, $03, $10, $03, $00, $00
 db $01, $00, $00, $07, $20, $0f, $00, $00, $0c, $03, $00, $05, $20, $0d, $00, $03
 db $0c, $1b, $2c, $00, $20, $14, $2c, $01, $0c, $07, $00, $03, $10, $09, $00, $02
 db $0c, $0f, $2c, $03, $0c, $05, $1c, $0d, $10, $06, $00, $17, $01, $00, $20, $02
 db $00, $03, $01, $00, $00, $03, $20, $06, $2c, $0d, $0e, $09, $0c, $03, $2c, $04
 db $0c, $05, $1c, $0f, $0c, $0e, $00, $14, $02, $0c, $0e, $08, $12, $04, $02, $02
 db $0e, $01, $02, $04, $0e, $03, $2e, $00, $22, $02, $02, $01, $0e, $03, $02, $0d
 db $22, $06, $2e, $00, $0e, $07, $2e, $0b, $0e, $02, $02, $00, $00, $10, $10, $0b
 db $00, $05, $02, $05, $0e, $03, $1e, $02, $12, $03, $1e, $00, $0e, $05, $02, $07
 db $0e, $03, $12, $05, $1e, $00, $0e, $08, $02, $03, $22, $0c, $2e, $05, $0e, $0f
 db $2e, $04, $20, $08, $00, $29, $10, $0b, $00, $00, $02, $03, $0e, $04, $1e, $0c
 db $0e, $0b, $1e, $01, $12, $01, $02, $11, $12, $1b, $10, $02, $00, $03, $01, $00
 db $00, $05, $10, $02, $1c, $11, $1e, $0b, $1f, $00, $0e, $1c, $2e, $0b, $20, $11
 db $01, $00, $00, $09, $01, $00, $00, $07, $01, $00, $00, $09, $01, $00, $00, $06
 db $01, $00, $00, $07, $01, $00, $00, $03, $01, $00, $00, $04, $10, $0a, $1c, $10
 db $0c, $12, $1c, $00, $10, $09, $1c, $00, $0c, $07, $00, $0a, $20, $06, $2c, $0a
 db $0c, $00, $00, $09, $20, $0e, $2c, $03, $0c, $14, $00, $17, $10, $0e, $00, $0d
 db $10, $04, $00, $03, $0c, $1a, $2c, $0c, $0c, $00, $0e, $04, $1e, $06, $0e, $03
 db $02, $09, $12, $00, $1e, $03, $0e, $02, $02, $08, $0e, $01, $02, $04, $12, $03
 db $02, $02, $0e, $03, $02, $06, $0e, $0d, $1e, $08, $0e, $04, $0c, $02, $00, $04
 db $01, $00, $00, $04, $20, $02, $21, $00, $00, $07, $01, $00, $00, $05, $01, $00
 db $00, $06, $01, $00, $00, $06, $01, $00, $00, $03, $01, $00, $00, $03, $01, $00
 db $00, $06, $01, $00, $00, $04, $01, $00, $00, $05, $01, $00, $00, $05, $01, $00
 db $00, $07, $01, $00, $00, $03, $20, $04, $2c, $08, $0e, $14, $02, $03, $00, $01
 db $10, $07, $00, $00, $02, $04, $22, $11, $02, $04, $12, $0c, $02, $04, $22, $01
 db $02, $00, $00, $09, $20, $09, $2c, $01, $0c, $05, $2c, $00, $20, $0e, $00, $13
 db $01, $00, $00, $06, $01, $00, $00, $04, $10, $10, $1c, $09, $1e, $07, $0e, $0c
 db $1e, $03, $0e, $04, $02, $00, $00, $21, $01, $00, $00, $02, $2c, $07, $0c, $0e
 db $0d, $00, $00, $0c, $01, $00, $00, $06, $10, $02, $11, $00, $10, $00, $00, $05
 db $01, $00, $00, $06, $01, $00, $00, $0a, $20, $11, $00, $12, $10, $0a, $00, $09
 db $0c, $16, $00, $08, $20, $05, $02, $03, $0e, $20, $02, $0c, $00, $09, $10, $0a
 db $1c, $00, $0c, $07, $00, $06, $20, $05, $22, $00, $02, $05, $0e, $1c, $2e, $02
 db $0e, $17, $1e, $04, $0e, $08, $0c, $1b, $2c, $05, $0c, $0f, $2c, $04, $0c, $03
 db $1c, $0e, $00, $1a, $01, $00, $00, $07, $01, $00, $00, $07, $01, $00, $00, $07
 db $01, $00, $00, $04, $20, $08, $2c, $04, $0c, $29, $1c, $03, $0c, $18, $00, $07
 db $02, $04, $00, $05, $0c, $07, $00, $01, $10, $04, $00, $09, $10, $08, $1c, $00
 db $0c, $0a, $00, $08, $0c, $13, $2c, $07, $0c, $18, $2c, $05, $0c, $0f, $2c, $03
 db $0c, $0b, $00, $02, $20, $09, $00, $05, $0c, $08, $1c, $0b, $0c, $05, $00, $0f
 db $0c, $02, $1c, $06, $10, $05, $00, $07, $0c, $19, $2c, $06, $0c, $1d, $2c, $03
 db $0c, $0d, $1c, $01, $0c, $35, $2c, $04, $0c, $14, $1c, $03, $0c, $0e, $1c, $04
 db $0c, $d5, $00, $1b