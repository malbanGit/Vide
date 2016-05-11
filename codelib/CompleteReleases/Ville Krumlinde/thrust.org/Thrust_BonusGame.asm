; Zzap Strikes Back - Bonusgame hidden inside Thrust.
; Copyright (C) 2004  Ville Krumlinde

;todo optimize size
;   skip all y-coords, assume 0?
;   direct c9 instead?
;   macros instead of subroutines
;   gör subs av mMove_to_d i hela, mMove_to_d=jsr FxMoveToD
;
;fixlist
;  coolare bullet for homing shots
;  svårare
;    1 extra headträff
;    öka level every two walkers
;    öka hitpoints baserat på levelhi?
;  radar plot base
;  thrust flame
; *highscore visas /10
;
;  activate vid 50.000?
;    har nått 93000 i normal game
; --> testa:   har nått level 6 i normal game
;  smalare huvud för varje round
;  lägre intensity på bakre berg
;  walker mer hitpoints
;  kortare värld
;  större diff på shotintensities
;  walker fler shots
;  walker lysande shots
;  svårare att träffa head
;
;  skip ship vs walker collision?
;  rewrite setview-code
;    om ship right
;      opt = shipx + velocx - edge
;      diff=opt-view
;      om diff<>0
;        asr diff, minst 1
;        öka view med diff
;  defender style control: flip dir med button? accelerate med button?
;  öka shipshot speed efter tid, så att man inte kan åka ikapp sina egna skott
;  gameover, öka shipy tills utanför skärm, gameover
;  roligt ljud vid explode walker
;  pulse-sound
;  jump-sound
;  score
;    score för headshot
;    score för bodyshot
;    blinka weakspot i ryggen, om hit döda direkt
;  radar
;    world length 8192 / 64 = 0..128
;    loop walkers
;    screenx=walkerx >> 6
;      lo rol2 in i ny byte
;      b|=hi shl2
;    screeny=walkery >> 3
;    RadarGetScreenCoords x,y
; *eget gamemode
;    titlescreen
;    save highscore
;    egen text i gameover
; *collision ship är inte centrerad
; *slide left/right ska bara påverka viewx, ej shipx
;
;optimize speed
;  mountain och ship ritas i scale $7f
;
;tillåt att skepp åker ovan skärmen 32 koords
;  och under 32 koords
;  då måste viewy följa
;  drawstars
;  flytta ship,mountains och stjärnor separat? parallax effekt?
;
;title
;  'ZZAP STRIKES BACK'
;  'PRESS FIRE'
;  HIGHSCORE
;
;activate
;  om cheatactive visa som alternativ 4 i modeselect
;  alt vid highscore i normal game
;  tst BonusGameActivated (eeprom)
;    sätts efter nytt highscore
;    samt vid enable cheat
;  alt
;    som nu helt hidden
;  GameMode = 3 BonusGame
;    save highscore also
;    hur visa highscore?
;      egen titlescreen
;  1 start, 2 options, 3 zzgf
;    3 visar ny titlescreen
;
;walker
;  dela upp i body och huvud
;  animera ben och huvud
;  hittest mod body och huvud, mer sårbar på huvud
;    gör först generellt hittest, sedan på separat yta
;
;  WalkerWidth
;    WalkerBaseW = (WalkerWidth/4)*3
;    WalkerLegW = (WalkerBaseW/6) * 2
;
;  WalkerBaseW = 128
;  WalkerNeckW = 32
;  WalkerHeadW = 32
;
;  WalkerTotalWidth = WalkerBaseW + WalkerNeckW + WalkerHeadW
;  CopyLinesAddY
;  DrawLeg offsetx,length
;
;  /------\
;  |      |-/\
;  |      |-\/
;  --------
;  | |  | |
;  |_|  |_|
;
; 6 bytes stack per line, 18 lines, 108 bytes stack space needed by clipdraw
;  ;positive y is down, positive x is right
;  ;  db 1  ;line count
;  ;  db 1  ;linetype, 0=vert, 1=horiz, 2=slope
;  ;  db FullW,0  ;x0,y0
;  ;  db 0,HalfH  ;x1,y1
;
;  hotspot
;    träffar man denna så dör walker direkt
;
;  explode
;    FxTargetWalker index, obs ny emit får ej ske innan shatter är klar
;    sänk walker långsamt genom att öka dess y
;
;walker damage
;  inital life 64
;  headshot minska med 8
;    emit explosion i head vart 32:e
;  base minska med 2
;  flash if low?
;
;difficulty
;  zzappace är 32-0, börjar på 32, minskar 1 vart 16:e sekund
;  zzappace är 255-0, börjar på 255, shr 1 vart 16:e sekund
;  både Pace och PaceMask?
;  alt.
;    öka pace för varje dödad walker
;    ha en klocka för varje behov
;    återgå till långsamt tempo efter snabbaste
;      flytta fram walkeremitpoint vid varje varv
;    WalkerSpeed mask8frame,6,4,3,2,1
;    ShootDelay 8,7,6,5,4,3,2,1 (multipliceras med random 4)
;    JumpDelay
;    JumpHeight
;    ShotYSpread, ShotXSpeed
;    ZzapIncDifficulty, ZzapResetDifficulty
;  IncreaseDifficulty()
;    anropa flera ggr för att testa
;    ZzapShotDelay
;    inc ZzapLevelNo
;      om mod 8=0
;      InitDifficulty()
;      IncreaseDifficulty() för att inte börja på noll
;      move forward walker emitpoint
;    lsr ZzapShotDelay
;  ZzapLevel
;  ZzapDifficultyEntry
;    zdShotDelay
;  InitDifficulty
;    allt noll
;    mSetByte ZzapShotDelay,$ff
;    mSetByte ZzapWalkerSpeed,0
;  updatewalkers
;    updatera x med två ifall framecounter and (4-bytetabell) är 0
;
;    lda zzapshotdelay
;    anda loopcounterlow
;    bne skipshots
;
;    om jumping
;      updatera y
;      använd jumpscale för att öka y
;    annars
;      lda jumpdelay
;      anda framecounter
;      bne nojump
;      set jumping
;      jumpscale -2 -- 2
;
;    walkerentry
;      jumpIndex 0--63, -1=not jumping
;      jumpScale init med rnd * zdconfig.jumpscaleRange
;    zdconfig
;      jumpIndex 0--64, -1=not jumping
;      jumpIndexIncrease 1--4
;      jumpIndexIncreaseRange 2
;      jumpScale
;      jumpScaleRange
;      jumpDelay only randomize jumpdelay
;      för scale ta walkerindex
;
;
;move walkers
;  loopcounter and (zzappace and 15)
;
;sound
;  "puls" ljud när walkers rör sig
;  ökar i takt med zzapclock
;  zc=zzappace shl 4
;  (loopcounter and (255 shl zc))
;
;draw walker
;  walkervisible-flag
;    då ritas ej score och radar
;  sätt upp headrect och baserect
;  shots vs walkers
;    endast om visible
;    testa mot head och base
;
;
;walker-shots
;  klocka styr hur ofta walker skjuter, samt dess homingness
;  träff med skepp, drain energy vänd riktning och velocity
;    ZzapClock ds ökar med 1 varje sekund
;      alt ZzapPace ökar med 1 vart 8:e sekund, stannar på 8
;    WalkerShotTimer (dec vart 8:e frame) 8=1 sekund, 4=1/2 sekund
;      max 5 sekunder, min 1 sekund
;      rnd +/- 1 sekund
;      (8-zzapPace)*4 + (rnd and 15 - 7)
;      alt span 1 skott vart 4:e sekund -- 1 vart 0.2 sekund
;        timer range 1 -- (4*8)
;        timer = 33 - (zzappace<<1)
;    homingness
;      mask = 32 - zzappace<<1
;      mask = zzappace-1
;  emit
;    om !walkerVisible exit
;    emit ifrån headrect
;    xveloc=fast speed * zzapclock
;    WalkerShotEntry
;      wsActive
;      wsVelocX +/-
;      wsWalkerShotX
;      wsWalkerShotY
;  DrawWalkerShots
;    remove ifall utanför skärm
;  UpdateWalkerShot
;    loop
;      om active
;        flytta
;        remove ifall utanför skärm
;        collision vs ship
;      annars lagra i ledig slot
;    om ledig slot
;      och timer=0
;      och walkervisible
;      emit
;        origin HeadX
;        sätt wsVelocX i riktning mot skepp
;
;
;base
;  rita stationarypod som base
;  ifall walker når pod, gameover
;    sätt viewx till base, loop med waitcalc, emit planetexplode ljud
;
;score
;  använd samma rutiner som vanliga spelet? eget gamemode?
;
;radar
;  display med radar o score, fadas bort när walker är visible
;

  code

; Relative coordinates for mountain.
Zzap_MountainYCoords:
  db 5,10,-10,-5,20,3,4,5
  db -10,0,-10,0,20,0,0,-32


; For each of the values in MountainYCoords there is a y-coordinate
; saying where to start drawing. This could be calculated using the
; relative values, but it's easier having a list.
Zzap_MountainABSYCoords:
  db 0,5,15,5,0,20,23,27
  db 32,22,22,12,12,32,32,32




; Vectors for ship facing left.
Zzap_ShipLeftVectorList:
  db  -25,-50
  db  50,100
  db  -35,-40
  db  -15,20
  db  0,-85
  ;thrust flame
  db 8,82
  db 8,24
  db 8,-24


; Vectors for ship facing right.
Zzap_ShipRightVectorList:
  db  -25,50
  db  50,-100
  db  -35,40
  db  -15,-20
  db  0,85
  ;thrust flame
  db 8,-82
  db 8,-24
  db 8,24

ZzShipWidth = 100


  bss

;Start memory in drawlist to avoid collisions with main game
Zzap_RamStart = DrawList
  org Zzap_RamStart

; Ship coordinates.
; The Y values is a direct Vectrex coordinate used in drawing.
; The X value is a position in game world.
Zzap_ShipY = ShipY
Zzap_ShipX = ShipX

Zzap_ShipVelocX = ShipSpeedX
Zzap_ShipVelocY = ShipSpeedY

; Direction ship is facing.
Zzap_ShipDir = ShipAngle        ;1=left, -1=right


; X coordinate in game world for left edge of screen.
; This value is subtracted from ship and shot x coord to produce screen coord.
Zzap_LeftOffsetX = ViewX


; Ship shots.

; Max nr of shots visible at one time. This value can be increased.
Zzap_ShipShotCount = 4

; A shot is growing from the nose of the ship until reaching a length of this value.
Zzap_ShipShotMaxLength = 50

; Structure holding info about one shot.
  struct Zzap_ShipShotEntry
    db Zzap_ssShotActive       ;Flag: is shot active?
    db Zzap_ssShotDir          ;Direction for shot.
    dw Zzap_ssShotY            ;Y game world coordinate.
    dw Zzap_ssShotX            ;X game world coordinate.
    db Zzap_ssShotLength       ;Current length of shot.
  end struct

; Array with shots.
Zzap_ShipShotList: ds Zzap_ShipShotEntry * Zzap_ShipShotCount

ZzapShipTookDamage=DoorCounter
ZzapShipLives=ShipLives


;8192 is the length the radar assumes
ZzapWorldStartX = 256
ZzapWorldEndX = ZzapWorldStartX + 8192
;ViewX for new game
ZzapViewStartX = ZzapWorldEndX - 256

ZzapWorldTopY = 0-128
ZzapWorldEndY = 255

WalkerFloorY = ZzapWorldEndY - 32


;Walkers (enemies)
WalkerCount = 8

  struct WalkerEntry
    db weWalkerActive           ;-1=active, 0=dead, 1 dying
    db weWalkerLife
    dw weWalkerX
    dw weWalkerY                ;sprite center coords in world-space
    db weJumpIndex              ;-1=not jumping, 0..63 index to sinetable
  end struct

WalkerList: ds WalkerEntry * WalkerCount

;Walker measurements
WalkerBaseH=48
WalkerBaseW=84 ;120-32
WalkerLegH=64-16
WalkerLegW=(WalkerBaseW/7)*1 + 4
HeadW = 32
;Default head height, shrinks for each level
DefaultHeadH = 32-8
;Total width/height of walker sprite
WalkerWidth=WalkerBaseW+HeadW
WalkerHeight=WalkerBaseH + WalkerLegH

WalkerDistance = 750            ;Distance between each walker

;Walker shots
WalkerShotCount=5
 struct WalkerShotEntry
   db wsActive
   db wsVelocX
   db wsVelocY
   dw wsWalkerShotX
   dw wsWalkerShotY
 end struct

WalkerShotList: ds WalkerShotEntry * WalkerShotCount

;Coordinates for base
BaseX = ZzapWorldEndX - 128
BaseY = WalkerFloorY - 10

ZzapShipH = 16
ZzapShipW = 32

ZzapShipArea = 8                    ;Hit area for ship

; 0 = no walker visible, else points to visible walkerentry
WalkerVisible = ScrollX  ;2 bytes
WalkerVisibleI: ds 1    ;index of visible walker
VisibleHeadX: ds 2
VisibleHeadY: ds 2
VisibleBaseX: ds 2
VisibleBaseY: ds 2

;Game difficulty configuration, increased by each walker shot
 struct ZzapConfigEntry
   db zcShotDelay
   db zcShotYSpread
   db zcWalkerSpeedMask
   db zcJumpDelay
   db zcJumping
   db zcJumpScale
   db zcHeadH
   db zcHalfHeadH
   db zcWalkerLife
 end struct
ZzapConfig: ds ZzapConfigEntry

; Use same level as maingame, levelno is displayed in gameover
ZzapLevel = CurLevel

; Dynamic length, keep at end of BSS-section
WalkerDrawList:


;*******************
  code

Zzap_Start:
  ldx #Zzap_RamStart
  jsr clear_256_bytes   ;Clear buffer

  mDptoC8
  jsr Zzap_InitNewGame

; jsr Text_ShowWellDone
  jsr ZzapTitleScreen

Zzap_MainLoop:
  mDptoC8
  jsr Zzap_ControlShip
  jsr Zzap_UpdateShipShots
  jsr UpdateFrameCounter
  jsr UpdateSound
  jsr UpdateWalkers
  jsr UpdateWalkerShots
  jsr UpdateFx

  mTestFlag GameOverFlag
  bne ZzapGameOver

  jsr waitrecal         ;Wait for screen sync
  ;DP is now D0

  jsr UpdateSoundChip

  jsr Zzap_DrawMountain
  jsr Zzap_DrawShip
  jsr Zzap_DrawShipShots
  jsr DrawWalkers
  jsr DrawWalkerShots
  jsr DrawBase
  jsr DrawFx
  jsr DrawDisplay
  jsr DrawRadar
;  jsr DrawStars

  bra Zzap_MainLoop

ZzapGameOver:
  jsr Text_GameOver
  rts

ZzapTitleScreen:
  mDecLocals 0,0,40

  leax LocalBuffer,s
  mCombine d,1,2
  std ,x++

  lda #3
  sta ,x+
  ldd #GameMenuCallback
  std ,x++

  mMakeTextCoord -2,4
  std ,x++
  ldd #ZzapGameText1
  std ,x++

  mMakeTextCoord 0,16
  std ,x++
  ldd #ZzapGameText2
  std ,x++

  mMakeTextCoord 0,-2
  std ,x++
  leau 4,x
  stu ,x++

  ldd #0
  std ,x

  ldx #Highscores + (HighscoreEntry * 3)
  ldb #$80
  jsr CopyScoreFromXtoU

  leax LocalBuffer,s
  jsr Text_PrintWait

  mFreeLocals
  rts
ZzapGameText1: db "ZSB!",$80
ZzapGameText2: db "HIGHSCORE:",$80


;*****************
DrawRadar:
  direct -1
  mDecLocals 1,1,4
  ldu #WalkerList
  lda #WalkerCount
  sta LocalB1,s
zdrLoop:
  lda weWalkerActive,u
  beq zdrNext

  leax weWalkerX,u
  lda #$7f-16
  bsr RadarPlotCoords
  lda #5
  jsr DrawPlusAtCurrentPosition

zdrNext:
  leau WalkerEntry,u
  dec LocalB1,s
  bne zdrLoop

  ldx #Zzap_ShipX
  lda #$7f-16
  bsr RadarPlotCoords
  mDot_at_current_position

  leax LocalBuffer,s
  ldd #BaseX
  std ,x
  ldd #BaseY
  std 2,x
  lda #$7f-32
  bsr RadarPlotCoords
;  lda #3
  jsr DrawBulletAtCurrentPosition
;  mDot_at_current_position

  mFreeLocals
  rts

RadarPlotCoords: ;x points to world coords X,Y, a=intensity
  pshs a
  jsr reset0ref

  ldd ,x

  ;div 8192
  rolb
  rola
  rolb
  rola
  suba #64
  sta -1,s

  ldd 2,x
  asra
  rorb
  asra
  rorb
  asra
  rorb
  asra
  rorb
  tfr b,a
  nega
  adda #100

  ldb -1,s

  jsr move_pen7f_to_d
  puls a
  mSetIntensity
  rts
;  mDot_at_current_position
;  lda #3
;  jmp DrawPlusAtCurrentPosition
;  rts

;*****************
SetDifficulty:  ;set difficulty based on value in zzaplevel (0--7)
  direct $c8
  mDecLocals 2,0,0
LocalLevelLo = LocalB1
LocalLevelHi = LocalB2

  lda ZzapLevel
 lsra          ;increase difficulty every two walkers
  tfr a,b
  anda #7
  sta LocalLevelLo,s
  lsrb
  lsrb
  lsrb
  ;b=level high
  ;locallevelo is never lower than hi
  ;this makes the base difficulty increase after each round (one round=8 walkers)
  cmpb #7
  ble *+4
    ldb #7      ;level 64 = difficulty at max
  stb LocalLevelHi,s
  cmpb LocalLevelLo,s
  ble *+4
    stb LocalLevelLo,s

  ldx #ZzapConfig

  lda LocalLevelLo,s
  ldu #WalkerShotDelayTable
  ldb a,u
  stb zcShotDelay,x

  ldu #WalkerJumpDelayTable
  lda LocalLevelLo,s
  lsra
  ldb a,u
  stb zcJumpDelay,x

  lda LocalLevelLo,s
  lsra
  ldu #WalkerSpreadTable
  lda a,u
  sta zcShotYSpread,x

  ldu #WalkerSpeedTable
  lda LocalLevelLo,s
  lsra
  lda a,u
  sta zcWalkerSpeedMask,x

  lda LocalLevelHi,s
  lsla
  nega
  adda #DefaultHeadH
  sta zcHeadH,x
  asra
  sta zcHalfHeadH,x

  ;Walker life
  lda LocalLevelHi,s
  lsla
  lsla
  adda #58
  sta zcWalkerLife,x

  mFreeLocals
  direct -1
  rts
WalkerSpeedTable: db FRAME4MASK,FRAME3MASK,FRAME2MASK,0
WalkerSpreadTable: db 1,2,4,8
WalkerShotDelayTable:
  db FRAME192MASK,FRAME96MASK,FRAME64MASK,FRAME48MASK
  db FRAME32MASK,FRAME16MASK,FRAME12MASK,FRAME6MASK
WalkerJumpDelayTable:
  db 0,FRAME192MASK,FRAME64MASK,FRAME8MASK

;*****************
UpdateWalkerShots:
;  UpdateWalkerShot
;    loop
;      active?
;        move
;        collision vs ship
;      else save free slot index
;    if free slot
;      and timer=0
;      and walkervisible
;      emit
;        origin HeadX
;        set wsVelocX in direction towards ship
  direct $c8
  mDecLocals 1,1,0
LocalFree=LocalW1

  clr LocalFree,s

  ldu #WalkerShotList
  lda #WalkerShotCount
  sta LocalB1,s
zuwsLoop:
  tst wsActive,u
  lbeq zuwsInactive

  ldb wsVelocX,u      ;update x
  sex
  addd wsWalkerShotX,u
  std wsWalkerShotX,u

  lda LoopCounterLow
  anda #15
  bne zuwsSkipIncVelocX
    ldb wsVelocX,u
    aslb
    stb wsVelocX,u
zuwsSkipIncVelocX:

ZuwsMaxDistance = 256 + WalkerWidth
  ldd Zzap_ShipX
  addd #ZuwsMaxDistance
  cmpd wsWalkerShotX,u
  ble zuwsRemove
  subd #ZuwsMaxDistance*2
  cmpd wsWalkerShotX,u
  bge zuwsRemove

  ldx wsWalkerShotY,u

  ldb wsVelocY,u
  leax b,x

  lda LocalB1,s
  anda #1
  beq zuwsNoHome
  lda FrameCounter
  anda #FRAME3MASK
  bne zuwsNoHome
    ldb #1      ;slightly homing shots
    cmpx Zzap_ShipY
    beq zuwsNoHome
      bcs *+3
        negb
      addb wsVelocY,u
      stb wsVelocY,u
zuwsNoHome:

  lda LoopCounterLow
  anda #1
  bne zuwsSkipY

  stx wsWalkerShotY,u
zuwsSkipY:

    ;collision vs ship
    ldy #Zzap_ShipX
    mPointVsRect ZzapShipArea,ZzapShipArea,zuwsMiss,wsWalkerShotX,wsWalkerShotY,0,2
      jsr ZzapShipTakeDamage
zuwsMiss:
    bra zuwsNext
zuwsRemove:
    clr wsActive,u
zuwsInactive:
    stu LocalFree,s
zuwsNext:
  leau WalkerShotEntry,u
  dec LocalB1,s
  bne zuwsLoop

  ;test if emit
  ldu #ZzapConfig
  lda zcShotDelay,u
  anda FrameCounter
  bne zuwsNoEmit
  tst LocalFree,s
  beq zuwsNoEmit
  tst WalkerVisible
  beq zuwsNoEmit
    ldy LocalFree,s
    lda #1
    sta wsActive,y
    ldx #VisibleHeadX
    ldd 2,x
    addb zcHalfHeadH,u
    std wsWalkerShotY,y
    ldx ,x
    leax HeadW/2,x
    stx wsWalkerShotX,y
    cmpx Zzap_ShipX
    lda #3
    bcs *+3
      nega
    sta wsVelocX,y
    mRandomToA

    ldb zcShotYSpread,u
    decb
    stb -1,s
    anda -1,s
    incb
    lsrb
    stb -1,s
    suba -1,s

;    anda #7
;    suba #4
    sta wsVelocY,y
    mEmitSound GunFireSoundId
zuwsNoEmit:

  mFreeLocals
  direct -1
  rts

;*****************
DrawWalkerShots:
  ;DP must be D0
  mDecLocals 1,0,4

  mSetScale $7f                 ;Scale $7f is required for move_pen_d to reach whole screen

  ldx #WalkerShotList
  lda #WalkerShotCount
  sta LocalB1,s
zdwsLoop:
  tst wsActive,x
  beq zdwsNotActive

  leau LocalBuffer,s
  ldd wsWalkerShotX,x
  std ,u
  ldd wsWalkerShotY,x
  std 2,u
  pshs x
  ldx #WarpVectorList
  mCombine d,6,$7f
  jsr FxDrawSpriteVL                 ;Draw a single sprite  u=pointer to x,y  x=vectorlist a=scale b=intensity
  puls x

;  tsta
;  beq zdwsNotOnScreen
;    jsr DrawBulletAtCurrentPosition
;    jsr DrawBulletAtCurrentPosition
;    jsr DrawBulletAtCurrentPosition
;zdwsNotOnScreen:

zdwsNotActive:
  leax WalkerShotEntry,x
  dec LocalB1,s
  bne zdwsLoop

  mFreeLocals
  rts

;*****************
Zzap_InitNewGame:
  direct $c8

  mSetByte GameMode,BonusGame

  clra
  jsr InitNewGame
  inc ShipLives
  jsr PrepareLevel

  mSetByte ZzapLevel,0
  jsr SetDifficulty

  ldd #32000
  std CurLevelEndX              ;CurLevelEndX = (CurLevelSizeX * TileW)
  ldd #0
  std CurLevelEndY              ;CurLevelEndY = largest View Y

  ldx #ZzapViewStartX
  stx Zzap_LeftOffsetX
  leax 128,x
  stx Zzap_ShipX

  ldd #WalkerFloorY-255
  std ViewY

  ldd #50
  std Zzap_ShipY

  lda #1
  sta Zzap_ShipDir

  ;Init walkers
  ldx #ZzapViewStartX
  ldu #WalkerList
  ldb #WalkerCount
zngWLoop:
  pshs b
  leax -WalkerDistance,x
  bsr InitOneWalker
  leau WalkerEntry,u
  puls b
  decb
  bne zngWLoop

;  jsr clear_sound_chip
  direct -1
  rts

InitOneWalker: ;x=X coord, u=entry
  lda #-1
  sta weWalkerActive,u
;  lda #100 + 16
  ldy #ZzapConfig
  lda zcWalkerLife,y
  sta weWalkerLife,u
  ldd #WalkerFloorY - (WalkerHeight/2)
  std weWalkerY,u
  stx weWalkerX,u
  rts

;*****************
Zzap_DrawShip:
  direct -1

  mTestFlag InactiveFlag
  beq *+3
    rts

  tst ZzapShipTookDamage
  beq zdsShipOk
    dec ZzapShipTookDamage
    lda LoopCounterLow
    anda #2
    bne zdsNoDraw
zdsShipOk:

  ;DP must be D0
  jsr reset0ref         ;Reset pen

  ldx Zzap_ShipX
  ldy Zzap_ShipY
  jsr FxGetScreenCoords
  jsr  move_pen7f_to_d    ;Set pen position to value of d register

  mSetIntensity $5f

  tst  Zzap_ShipDir
  bmi  Zzap_dsSkip1
  ldx  #Zzap_ShipLeftVectorList
  bra  Zzap_dsSkip2
Zzap_dsSkip1:
  ldx  #Zzap_ShipRightVectorList
Zzap_dsSkip2:

  lda   #4              ;Nr of vectors in list
  ldb   #32             ;Scale
  jsr   move_draw_VL4   ;Draw list

  tst stick1_button3
  beq zdsNoThrust
    mRandomToA
    anda #127
    ora #32
    mSetIntensity
    lda #2
    jsr $F3B9   ;move draw, use current scale
zdsNoThrust:
zdsNoDraw:
  rts



;*****************
Zzap_DrawShipShots:
  direct -1

  clr $c823     ;set up draw with pattern
;  lda #%10101010
;  sta Pattern

  ;DP must be D0
;  mSetIntensity $4f

  ;Draw all active shots.
  ldu #Zzap_ShipShotList
  lda #Zzap_ShipShotCount
Zzap_dssLoop:
  pshs d

  tst Zzap_ssShotActive,u
  beq Zzap_dssNext

  ;vary pattern and intensity for each shot
  ldx #$F00B
  lda a,x
  sta Pattern
  anda #127
  mSetIntensity

  ldx Zzap_ssShotX,u
  ldy Zzap_ssShotY,u
  jsr FxGetScreenCoords
  beq Zzap_dssRemove    ;remove if offscreen

  pshs d
  jsr reset0ref
  puls d
  jsr move_pen7f_to_d
  ldb Zzap_ssShotLength,u
  tst Zzap_ssShotDir,u
  bpl *+3
    negb
  clra
  jsr $F439 ;draw pattern

  bra Zzap_dssNext

Zzap_dssRemove:
  clr Zzap_ssShotActive,u

Zzap_dssNext:
  puls d
  leau Zzap_ShipShotEntry,u
  deca
  bne Zzap_dssLoop
  rts


;*****************
Zzap_UpdateShipShots:
  direct $c8
  mDecLocals 2,0,0

  ;Move all active shots.
  ;Increase length of shots that haven't reached full length.
  ;Remove shots that have left screen.

  ldu #Zzap_ShipShotList
  lda #Zzap_ShipShotCount
  sta LocalB1,s
Zzap_ussLoop:
  tst Zzap_ssShotActive,u
  lbeq Zzap_ussNext

  ;Update x and length
  ldb #Zzap_ShipShotMaxLength
  cmpb Zzap_ssShotLength,u
  blo Zzap_ussLenMax
    ldb Zzap_ssShotLength,u
    addb #16
    stb Zzap_ssShotLength,u
Zzap_ussLenMax:
  ldx Zzap_ssShotX,u
  lda #17
  tst Zzap_ssShotDir,u
  bmi *+3
    nega
  leax a,x
  stx Zzap_ssShotX,u
zussXFin:

  ;Collision vs enemies
  tst WalkerVisible
  lbeq zussSkipWalkers

  ldy #ZzapConfig
  ;  mPointVsRect HeadW,HeadH,zussWalkerHeadMiss,Zzap_ssShotX,Zzap_ssShotY, 0,2
  ldx     Zzap_ssShotX,u
  ldd     VisibleHeadX
  subd    #HeadW/2
  std -2,s
  cmpx -2,s
  blt    zussWalkerHeadMiss
  addd    #HeadW
  std -2,s
  cmpx -2,s
  bgt    zussWalkerHeadMiss
  ldx     Zzap_ssShotY,u
  ldd     VisibleHeadY
  subb    zcHalfHeadH,y
  std -2,s
  cmpx -2,s
  blt    zussWalkerHeadMiss
  addb    zcHeadH,y
  std -2,s
  cmpx -2,s
  bgt    zussWalkerHeadMiss


  ;walker has been hit by head-shot
    mEmitSound WarpOutSoundId
    mGiveScore 30
    lda #-5
    bra zussWalkerTakeDamage
zussWalkerHeadMiss:

  ldy #VisibleBaseX
  mPointVsRect WalkerBaseW,WalkerBaseH,zussWalkerBaseMiss,Zzap_ssShotX,Zzap_ssShotY, 0,2
    mGiveScore 10
    lda #-1
    bra zussWalkerTakeDamage

zussWalkerTakeDamage:
  ldx WalkerVisible
  adda weWalkerLife,x
  sta weWalkerLife,x
  bpl zussWalkerAlive
;    lda #1
;    sta weWalkerActive,x        ;start death animation
    neg weWalkerActive,x        ;-1 becomes 1, start death animation
    ldb WalkerVisibleI
    mEmitFx FxTargetWalker,FxTypeDotShatter,b
    mGiveScore 100
    mEmitSound WalkerDestroyedSoundId
    inc ZzapLevel
    pshs u  ;SetDifficulty overwrites U
    jsr SetDifficulty
    puls u
zussWalkerAlive:

  ;Remove shot
  clr Zzap_ssShotActive,u

zussWalkerBaseMiss:

zussSkipWalkers:

Zzap_ussNext:
  leau Zzap_ShipShotEntry,u
  dec LocalB1,s
  bne Zzap_ussLoop

  mFreeLocals
  rts




;*****************
Zzap_ControlShip:
  direct $c8

  mTestFlag InactiveFlag
  beq *+3
    rts

;  mDecLocals 0,0,0

  ;Read input from joystick.
  ;Update ship velocity values and move ship.
  ;Emit new shot if fired.

  ;DP must be D0
  pshs dp
  mDptoD0
  jsr read_joystick
  lda #$8 + 2
  jsr read_switches
  puls dp
  direct $c8

ZzapShipMaxY=4
  ldb Zzap_ShipVelocY
  tst $c81c
  beq Zzap_csUDMoveCentered
  blt Zzap_csMoveDown
  ;MoveUp
    cmpb #-ZzapShipMaxY
    ble Zzap_csUDApplyVeloc
;    decb
    decb
    bra Zzap_csUDApplyVeloc
Zzap_csMoveDown:
    cmpb #ZzapShipMaxY
    bge Zzap_csUDApplyVeloc
;    incb
    incb
    bra Zzap_csUDApplyVeloc
Zzap_csUDMoveCentered:
    ;dampen when centered
   tstb
   beq Zzap_csUDApplyVeloc
   bpl *+4
     incb
     db $86 ;eat next byte
     decb
Zzap_csUDApplyVeloc:
  stb Zzap_ShipVelocY
;  asrb
;  asrb
;  asrb
  sex
  addd Zzap_ShipY
  cmpd #ZzapWorldTopY+(ZzapShipH/2)
  bge Zzap_csTestFloor
    clr Zzap_ShipVelocY
    ldd #ZzapWorldTopY+(ZzapShipH/2)
    bra Zzap_csStoreY
Zzap_csTestFloor:
  cmpd #ZzapWorldEndY-(ZzapShipH/2)
  ble Zzap_csStoreY
    clr Zzap_ShipVelocY
    ldd #ZzapWorldEndY-(ZzapShipH/2)
Zzap_csStoreY:
  std Zzap_ShipY

  ldx #ViewY
  cmpd ,x
  bgt Zzap_csViewTopOk
    std ,x
    bra Zzap_csViewYFin
Zzap_csViewTopOk:
  subd #255
  cmpd ,x
  ble Zzap_csViewYFin
    std ,x
Zzap_csViewYFin:

  ;inc Zzap_ShipVelocY ;todo more gravity?

; lda LoopCounterLow
; anda #1
; beq Zzap_csLRMoveFinished

ZzapShipMaxX=48

  tst stick1_button3
  beq Zzap_csLRMoveCentered
  lda #2
  ldb #ZzapShipMaxX
  tst Zzap_ShipDir
  bmi *+4
    nega
    negb
  adda Zzap_ShipVelocX
  cmpa #ZzapShipMaxX
  ble *+4
    tfr b,a
  cmpa #-ZzapShipMaxX
  bge *+4
    tfr b,a
zcsLRMoveStore:
;    stb Zzap_ShipDir
    sta Zzap_ShipVelocX
    mEmitSound ThrustSoundId
    bra Zzap_csLRMoveFinished
Zzap_csLRMoveCentered:
  lda Zzap_ShipVelocX  ;dampen veloc x
  beq Zzap_csLRMoveFinished
  bpl *+4
    inca
    db $c6 ;eat next byte
    deca
  sta Zzap_ShipVelocX
Zzap_csLRMoveFinished:

  tst stick1_button2
  beq zcsNoFlip
    neg Zzap_ShipDir
zcsNoFlip:

  tst stick1_button4
  beq Zzap_csFireFinish
    ;Find free
    ldu #Zzap_ShipShotList
    lda #Zzap_ShipShotCount
Zzap_csFire1:
    tst Zzap_ssShotActive,u
    beq Zzap_csFreeFound
    leau Zzap_ShipShotEntry,u
    deca
    bne Zzap_csFire1
    bra Zzap_csFireFinish  ;No free found
Zzap_csFreeFound:
    ;lda #1
    com Zzap_ssShotActive,u
    lda Zzap_ShipDir
    sta Zzap_ssShotDir,u
    ldx Zzap_ShipX
    stx Zzap_ssShotX,u
    ldx Zzap_ShipY
    leax 6,x
    stx Zzap_ssShotY,u
    clr Zzap_ssShotLength,u
;    mEmitSound WalkerDestroyedSoundId
    mEmitSound ShipFireSoundId
Zzap_csFireFinish:

  lda Zzap_ShipVelocX
  asra
  asra

  ;Move ship X
  ldx Zzap_ShipX
  leax a,x

  cmpx #ZzapWorldEndX-(ZzShipWidth/2)
  blt *+5
    ldx #ZzapWorldEndX-(ZzShipWidth/2)
  cmpx #ZzapWorldStartX+(ZzShipWidth/2)
  bgt *+5
    ldx #ZzapWorldStartX+(ZzShipWidth/2)

  stx Zzap_ShipX

  ;Update view coordinate
  ;Add ship velocity and test for world ends
  ldx Zzap_LeftOffsetX
  leax a,x
  cmpx #ZzapWorldEndX-256
  blt *+5
    ldx #ZzapWorldEndX-256
  cmpx #ZzapWorldStartX
  bgt *+5
    ldx #ZzapWorldStartX

  ;slide viewx to left or right edge depending on ship direction
  ldu Zzap_ShipX
  lda Zzap_ShipVelocX
  nega
  leau a,u
  stx -2,s
  tst Zzap_ShipDir
  bpl zcsSlideLeft
    leau -64,u
    cmpu -2,s
    ble zcsSlideMax
      leax 2,x
      bra zcsSlideStoreX
zcsSlideLeft:
    leau -(256-32),u
    cmpu -2,s
    bge zcsSlideMax
      leax -2,x
      bra zcsSlideStoreX
zcsSlideMax:
  tfr u,x
zcsSlideStoreX:
  stx Zzap_LeftOffsetX

  bsr ZzapUpdateClipView

  ;Collision ship vs walkers
  tst WalkerVisible
  beq zcsWalkerFinish
    ldu #ShipX
    ldy #ZzapConfig
;    mPointVsRect HeadW,HeadH,zcsWalkerHeadMiss,0,2, 0,2
    ldx     0,u
    ldd     VisibleHeadX
    subd    #HeadW/2
    std -2,s
    cmpx -2,s
    blt    zcsWalkerHeadMiss
    addd    #HeadW
    std -2,s
    cmpx -2,s
    bgt    zcsWalkerHeadMiss
    ldx     2,u
    ldd     VisibleHeadY
    subb    zcHalfHeadH,y
    std -2,s
    cmpx -2,s
    blt    zcsWalkerHeadMiss
    addb    zcHeadH,y
    std -2,s
    cmpx -2,s
    bgt    zcsWalkerHeadMiss
      bsr ZzapShipTakeDamage
      bra zcsWalkerFinish
zcsWalkerHeadMiss:
    ldy #VisibleBaseX
    mPointVsRect WalkerBaseW,WalkerBaseH,zcsWalkerFinish,0,2, 0,2
      bsr ZzapShipTakeDamage
zcsWalkerFinish:

;  mFreeLocals
  direct -1
  rts

ZzapUpdateClipView:
  ;Update clip-region used by drawenemies
  direct $c8
  ldb #255
  ldx ViewX
  ldu #_clip_xmin
  stx ,u
  abx
  stx 4,u
  ldx ViewY
  stx 2,u
  abx
  ;clip walkers at floor level, makes their death-animation looks nice
  cmpx #WalkerFloorY
  ble *+5
    ldx #WalkerFloorY
  stx 6,u
  direct -1
  rts

;*****************
ZzapShipTakeDamage:
  direct $c8

  tst ZzapShipTookDamage        ;skip if already damaged
  bne zstNotGameOver

  lda #50
  neg Zzap_ShipDir
  bmi *+3
    nega
  sta Zzap_ShipVelocX

  mEmitSound ExplosionSoundId
  mSetByte ZzapShipTookDamage,255
  dec ZzapShipLives
  bne zstNotGameOver
    jsr ExplodeShip
zstNotGameOver:
  direct -1
  rts

;*****************
Zzap_DrawMountain:
  ;Draw background mountain.
  ;The mountain is drawn twice at different height and intensity.
  mDecLocals 2,0,0
LocalOffset = LocalB2

  ;DP must be D0
  mSetIntensity $3f

  ;Calc start in ycoord table.
  ldy  #Zzap_MountainYCoords

  lda  Zzap_LeftOffsetX+1
  lsra
  lsra
  lsra
  lsra
  anda #15
  sta LocalOffset,s

  ldx  #Zzap_MountainABSYCoords
  lda  a,x
  ldb ViewY+1
;  asrb
;  asrb
  asrb
  stb -1,s
  adda -1,s
  adda #20

  ldb  Zzap_LeftOffsetX+1
  andb #15
  negb
  subb #111
  jsr  move_pen7f_to_d

  lda  #16    ;Nr of segments to draw
  sta LocalB1,s
  lda LocalOffset,s
Zzap_dmLoop1:
  pshs a
  ldb  #16    ;X increment
  lda  a,y
  mDrawToD
  puls a
  inca
  anda #15      ;keep index within table-size
  dec LocalB1,s
  bne Zzap_dmLoop1

  ;****




  jsr   reset0ref             ;Reset pen
  mSetIntensity $10

  lda LocalOffset,s
  ldx  #Zzap_MountainABSYCoords
  lda  a,x
  ldb ViewY+1
;  asrb
;  asrb
;  asrb
  asrb
  stb -1,s
  adda -1,s
  adda #80

  ldb  Zzap_LeftOffsetX+1
  andb #15
  lsrb
  negb
  subb #111
  jsr  move_pen7f_to_d

;  mSetScale $3f

  lda  #32    ;Nr of segments to draw
  sta LocalB1,s
  lda LocalOffset,s
Zzap_dmLoop11:
  pshs a
  lda  a,y
  ldb  #8     ;X increment
  mDrawToD
  puls a
  inca
  anda #15      ;keep index within table-size
  dec LocalB1,s
  bne Zzap_dmLoop11

  mFreeLocals
  rts



;*****************
UpdateWalkers:
  direct $c8
  mDecLocals 2,2,0
LocalJumpY = LocalB2
LocalFree = LocalW1
LocalMinX = LocalW2

;   loop walkers
;     move right
;     game over if reached right edge
;     keep track of walker with lowest x
;   if lowest x<threshold
;     emit new walker at left edge


  ldy #ZzapConfig

;  lda zcWalkerSpeedMask,y
;  anda FrameCounter
;  bne zuwNoPulse
;  lda LoopCounterLow
;  anda #7
;  bne zuwNoPulse
;    mEmitSound GunFireSoundId
;zuwNoPulse:

  lda zcJumping,y
  bmi zuwNoJumping
    tfr a,b
    inca
    cmpa #64
    bne *+4
      lda #-1
    sta zcJumping,y
    ldx #SineTable
    ldb b,x
    asrb
    asrb

    lda zcJumpScale,y
    mul

    negb

    stb LocalJumpY,s
    mEmitSound WalkerBounceSoundId
    bra zuwJumpFin
zuwNoJumping:
    clr LocalJumpY,s
    lda zcJumpDelay,y
    beq zuwJumpFin
    anda FrameCounter
    bne zuwJumpFin
      mRandomToA
      anda #7
      beq zuwJumpFin
      ;Range: 1..8
      inca
      sta zcJumpScale,y
      clr zcJumping,y
zuwJumpFin:

  clr LocalFree,s
  lda #$7F      ;high signed value
  sta LocalMinX,s

  ldu #WalkerList
  lda #WalkerCount
  sta LocalB1,s
zuwLoop:
  lda weWalkerActive,u
  beq zuwInactive
  bmi zuwNotDying
    ldx weWalkerY,u
    leax 2,x
    stx weWalkerY,u
    cmpx #WalkerFloorY + (WalkerHeight/2)       ;remove when fallen under floor
    ble *+4
      clr weWalkerActive,u
    bra zuwNext
zuwNotDying:

  ;Move X-coord
  ldx weWalkerX,u

  lda zcWalkerSpeedMask,y
  anda FrameCounter
  bne zuwDontWalk

  leax 3,x
  stx weWalkerX,u
  cmpx #BaseX - WalkerWidth/2
  blo zuwNotReachedBase
    bsr WalkerHitBase
    bra zuwExit
zuwNotReachedBase:

zuwDontWalk:

  cmpx LocalMinX,s
  bge zuwNotLowest
    stx LocalMinX,s
zuwNotLowest:


  ;Update Y
  ldb LocalJumpY,s
  ldx #WalkerFloorY - (WalkerHeight/2)
  leax b,x
  stx weWalkerY,u

  bra zuwNext

zuwInactive:
  stu LocalFree,s

zuwNext:
  leau WalkerEntry,u
  dec LocalB1,s
  bne zuwLoop

  ;emit new if free and minx<threshold
  tst LocalFree,s
  beq zuwNoEmit
  ldx LocalMinX,s
  cmpx #ZzapWorldStartX-WalkerWidth+WalkerDistance
  ble zuwNoEmit
    ldu LocalFree,s
    ldx #ZzapWorldStartX-WalkerWidth
    jsr InitOneWalker
zuwNoEmit:

zuwExit:

  mFreeLocals
  direct -1
  rts

WalkerHitBase:
  direct $c8
  lda #100
  pshs a,dp
  ldd #BaseX - 128
  std ViewX
  ldd #WalkerFloorY-255
  std ViewY
  bsr ZzapUpdateClipView
  mEmitSound PlanetExplodeSoundId
  mSetFlag GameOverFlag
whsMainLoop:
  mDptoC8
  jsr UpdateSound
  jsr waitrecal         ;Wait for screen sync
  ;DP is now D0
  jsr UpdateSoundChip
  jsr Zzap_DrawMountain
  jsr DrawWalkers
  jsr DrawBase
  dec ,s
  bne whsMainLoop
  puls a,dp,pc
  direct -1

;*****************
WalkerLineCount = 18
DrawWalkers:
  mDecLocals 2,2,WalkerLineCount * 5
LocalLines = LocalBuffer
LocalDist = LocalB1
LocalInt = LocalB2
LocalXMin = LocalW1
LocalXMax = LocalW2
  direct -1

;    loop enemies
;      check if on screen
;        clip and draw
;        break (only one can be visible at a time)

  ;No walker is visible as default
  mSetByte WalkerVisible,0

  ldd ViewX
  subd #WalkerWidth/2
  std LocalXMin,s
  addd #256 + WalkerWidth
  std LocalXMax,s

  ldu #WalkerList
  lda #WalkerCount
  sta LocalB1,s
zdwLoop:
  tst weWalkerActive,u
  beq zdwNext

  ldd weWalkerX,u
  cmpd LocalXMin,s
  blt zdwNext
  cmpd LocalXMax,s
  bgt zdwNext

  ;Store info about visible walker, if not dying
  tst weWalkerActive,u
  bpl zdwVisibleIsDying
    stu WalkerVisible
zdwVisibleIsDying:
  lda #WalkerCount
  suba LocalB1,s
  sta WalkerVisibleI

  bra dwDraw

zdwNext:
  leau WalkerEntry,u
  dec LocalB1,s
  bne zdwLoop

  jmp dwExit

dwDraw:


_off=0
mWa macro value
 if \0=1
   lda #value
 endif
 sta _off,x
_off=_off+1
 endm
mWd macro
 if \0=2
   mCombine d,\1,\2
 endif
 std _off,x
_off=_off+2
 if _off>$e
   ;Avoid extra byte for offsets>$f
   ;Accumulate offset to x, reset offset
   leax _off,x
_off=0
 endif
 endm

  lda #$60              ;intensity
  tst weWalkerActive,u
  bmi zdwAliveInt
    mRandomToA
zdwAliveInt:
  sta LocalInt,s

  ;Leg and head animation
  mTicToc 64
  asra
  asra
  sta LocalDist,s

  leax LocalLines,s
  ldd #WalkerDrawList   ;write result buffer
  mWd

  ldd weWalkerY,u       ;write top-left coords
  subd #WalkerHeight/2
  mWd
  addd #WalkerBaseH/2   ;also store visible base coords for hittests
  std VisibleBaseY
  ldd weWalkerX,u
  subd #WalkerWidth/2
  mWd
  addd #WalkerBaseW/2   ;also store visible base coords for hittests
  std VisibleBaseX


  ;Linecount
  mWa 12

  ;Base top
  mWa 2
  mWd 0,WalkerBaseH/8
  mWd WalkerBaseW/7,0

  mWa 1
  mWd WalkerBaseW/7,0
  mWd (WalkerBaseW/7)*6,0

  mWa 2
  mWd (WalkerBaseW/7)*6,0
  mWd (WalkerBaseW/7)*7,WalkerBaseH/8

  ;Base lower
  mWa 0
  mWd 0,WalkerBaseH/8
  mWd 0,WalkerBaseH

  mWa 1
  mWd 0,WalkerBaseH
  mWd WalkerBaseW,WalkerBaseH

  mWa 0
  mWd WalkerBaseW,WalkerBaseH/8
  mWd WalkerBaseW,WalkerBaseH

  ;Legs
LegX=4  ;Offset X from WalkerBase that leg is attached

  ;Left leg

  mWa 0
  mWd LegX,WalkerBaseH
  mCombine d,LegX,WalkerBaseH+WalkerLegH
  subb LocalDist,s
  mWd

  mWa 1
  mCombine d,LegX,WalkerBaseH+WalkerLegH
  subb LocalDist,s
  mWd
  mCombine d,LegX+WalkerLegW,WalkerBaseH+WalkerLegH
  subb LocalDist,s
  mWd

  mWa 0
  mWd LegX+WalkerLegW,WalkerBaseH
  mCombine d,LegX+WalkerLegW,WalkerBaseH+WalkerLegH
  subb LocalDist,s
  mWd

  ;Right leg
  lda #16
  suba LocalDist,s
  sta LocalDist,s

  mWa 0
  mWd WalkerBaseW-WalkerLegW-LegX,WalkerBaseH
  mCombine d,WalkerBaseW-WalkerLegW-LegX,WalkerBaseH+WalkerLegH
  subb LocalDist,s
  mWd

  mWa 1
  mCombine d,WalkerBaseW-WalkerLegW-LegX,WalkerBaseH+WalkerLegH
  subb LocalDist,s
  mWd
  mCombine d,WalkerBaseW-LegX,WalkerBaseH+WalkerLegH
  subb LocalDist,s
  mWd

  mWa 0
  mWd WalkerBaseW-LegX,WalkerBaseH
  mCombine d,WalkerBaseW-LegX,WalkerBaseH+WalkerLegH
  subb LocalDist,s
  mWd

  leay LocalLines,s
  lda LocalInt,s      ;intensity
  jsr ClipDraw


  ;Neck and head are drawn separately

  ;This is needed because a single clipdraw call only handles x +- 128 and
  ;total width of a walker is >128

  ;Head
  leax LocalLines,s
_off=2                  ;skip write result buffer, it's already valid

  ldy #ZzapConfig

  ldb LocalDist,s       ;animate head Y
  addb #4
  stb LocalDist,s

  ldd weWalkerY,u       ;write top-left coords, offset x with BaseW, offset y with dist
  subd #WalkerHeight/2
  addb LocalDist,s      ;add bounce
  addb #WalkerBaseH/8   ;add an offset from base top
  mWd
  addb zcHalfHeadH,y
  std VisibleHeadY      ;also store visible head center coords for hittests
  ldd weWalkerX,u
  subd #WalkerWidth/2
  addd #WalkerBaseW
  mWd
  addd #HeadW/2
  std VisibleHeadX      ;also store visible head center coords for hittests

  ;Linecount for head
  mWa 5

HeadSlopeH = 7
HeadSlopeW = HeadSlopeH*2
  mWa 1
  mWd 0,0
  mWd HeadW-HeadSlopeW,0

  mWa 2
  clra
  ldb zcHeadH,y
  subb #HeadSlopeH
  mWd

  ldb zcHeadH,y
  lda #HeadSlopeW
  mWd

  mWa 1
  lda #HeadSlopeW
  mWd
  lda #HeadW
  mWd

  mWa 0
  lda #HeadW
  mWd
  mWd HeadW,HeadSlopeH

  mWa 2
  mWd HeadW-HeadSlopeW,0
  mWd HeadW,HeadSlopeH

  leay LocalLines,s
  lda LocalInt,s      ;intensity
  jsr ClipDraw

dwExit:
  mFreeLocals
  rts


;*****************
DrawBase:
  mDecLocals 0,0,4
  ;DP must be D0
  mSetIntensity $5f

  ;Draw base
  leau LocalBuffer,s
  ldd #BaseX
  std ,u
  ldd #BaseY
  std 2,u
  ldx #SpriteStationaryPod
  jsr DrawSprite

  ;Draw floor
  ldx ViewX
  leax 4,x
  ldy #WalkerFloorY
  jsr FxGetScreenCoords
  beq dbFloorOffscreen
    std LocalBuffer,s
    jsr reset0ref
    ldd LocalBuffer,s
    jsr move_pen7f_to_d
    ;scale $ff to draw full width
    mSetScale $ff
    mCombine d,0,127
    jsr draw_to_d
dbFloorOffscreen:

  mFreeLocals
  rts
