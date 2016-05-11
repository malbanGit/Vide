; Thrust graphical effects
; Copyright (C) 2004  Ville Krumlinde

;    Time       8 bits:
;    TargetType 4 bits: ship,orb,gun,fuel,switch,plant
;    FxType     4 bits: explosion,teleportfx,250score,planetexplode
;    Index      8 bits: fuel,switch etc index
;      en del dör direkt, refuel stänger av sig själv, använder endast loopcounter
;  DrawFx
;    jumptable for targettype, returns coords
;      FxGetCoords index
;    jumptable for fxtype
;      FxDrawFx coords,time
;      every fx-rutin can also be called separately, FxRotatingStar is called from refueling
;  UpdateFx
;    dec time
;    jumptable for Finish
;      FxFinish_Ship FxType
;        case TeleportInFx
;          set active
;        case TeleportOutFx
;          jsr finishlevel
;        case Explosion
;          call loselife
;  Thrust_Fx.asm
;  requirements
;    able to draw refueling effect
;    teleport in/out effect
;  mEmitFx FxTarget,FxType,InitTime,IndexReg (optional)


FxTempEntry = TemporaryArea    ;Temporary storage for drawfx

FxTargetShip   = 0
FxTargetPod    = 1
FxTargetGun    = 2
FxTargetPlant  = 3
FxTargetFuel   = 4
FxTargetSwitch = 5
FxTargetWalker = 6      ;bonus game

FxTypeDotShatter = 0
FxTypeRefueling  = 1
FxTypePickUpPod  = 2
FxTypeScore150   = 3
FxTypeScore300   = 4
FxTypeScore750   = 5
FxTypeWarpIn     = 6
FxTypeWarpOut    = 7
FxTypeFuelCell   = 8
FxTypePlanetExplode = 9
FxTypeGunFire = 10

ShatterStartTime = 64

;A holds byte, exits with targettype in a, and fxtype in b
mFxSplitTargetFx macro
  tfr a,b
  anda #15
  lsrb
  lsrb
  lsrb
  lsrb
  endm


;Emit effect, all registers except D are preserved
mEmitFx macro FxTarget,FxType,IndexReg
  if ('IndexReg'!='0') && ('IndexReg'!='b')
    tfr IndexReg,b
  endif
  lda #FxTarget | (FxType<<4)
  jsr EmitFx
  endm


;*****************
EmitFx:         ;a=encoded target/type, b=index
  pshs x,y
  mDecLocals 4,0,0
LocalTarget = LocalB1
LocalFx = LocalB2
LocalIndex = LocalB3
LocalEncoded = LocalB4

  sta LocalEncoded,s
  stb LocalIndex,s
  mFxSplitTargetFx
  sta LocalTarget,s
  stb LocalFx,s

  ;find free
  ldx #FxList
  ldb #MaxFx
efxLoop:
  tst ,x
  beq efxFound
  leax 3,x
  decb
  bne efxLoop

  ;no free found, replace first that isn't target ship
  ;ships fx must be prioritized because ExplodeShip/ExitLevel is called from end of fx
  ldx #FxList
efxLoop2:
  lda 1,x
  anda #15
  cmpa #FxTargetShip
  bne efxFound
  leax 3,x
  bra efxLoop2

efxFound:                       ;free found, write new fx
  ldy #FxInitTable
  lda LocalFx,s
  lsla
  leay a,y

  lda ,y                        ;time
  sta ,x

  lda LocalEncoded,s            ;target/fx as one byte
  sta 1,x

  lda LocalIndex,s              ;index
  sta 2,x

  lda 1,y                       ;sound fx
  beq efxNoSound
    mEmitSound
efxNoSound:

  mFreeLocals
  puls x,y,pc
;  rts


;*****************
DrawFx:
  mDecLocals 4,1,0
LocalTarget = LocalB2
LocalFx = LocalB3
LocalTime = LocalB4

  ldy #FxList
  ldb #MaxFx
dfxLoop:
  lda ,y
  beq dfxNext

  stb LocalB1,s
  sty LocalW1,s

  sta LocalTime,s

  lda 1,y
  mFxSplitTargetFx
  sta LocalTarget,s
  stb LocalFx,s

  ldb LocalTarget,s
  lslb
  ldx #FxGetCoordsTable
  lda 2,y               ;A holds index
  jsr [b,x]

  ;X and Y holds world coords

  ldu #FxDrawTable
  ldb LocalFx,s
  lslb
  lda LocalTime,s       ;A holds time
  jsr [b,u]

  ldb LocalB1,s
  ldy LocalW1,s

dfxNext:
  leay 3,y
  decb
  bne dfxLoop

  mFreeLocals
  rts


;*****************
UpdateFx:
  mDecLocals 3,1,0
  direct $c8
LocalTarget = LocalB2
LocalFx = LocalB3

  ldy #FxList
  ldb #MaxFx
ufxLoop:
  tst ,y
  beq ufxNext

  dec ,y                ;decrease time
  bne ufxNext

  stb LocalB1,s         ;reached zero, call finishevent
  sty LocalW1,s

  lda 1,y
  mFxSplitTargetFx
  sta LocalTarget,s
  stb LocalFx,s

  ldu #FxFinishTable
  ldb LocalTarget,s
  lslb
  leau b,u
  lda LocalFx,s         ;A holds fxtype
  ldb 2,y               ;B holds index
  jsr [,u]

  ldb LocalB1,s
  ldy LocalW1,s

ufxNext:
  leay 3,y
  decb
  bne ufxLoop

  direct -1
  mFreeLocals
  rts


;*****************
FxGetScreenCoords:      ;X/Y world coords, returns screen coords in D, Z set if offscreen
  sty -4,s              ;save y, mGetScreenMacro uses -2

  ;transform x
  mGetScreenX
  bmi fxsOffScreen
  tsta
  bne fxsOffScreen
  subb #128
  stb -1,s

  ldd -4,s              ;load y
  subd ViewY            ;transform y
  bmi fxsOffScreen
  tsta
  bne fxsOffScreen

  negb
  tfr b,a
  ldb -1,s
  adda #127
  rts
fxsOffScreen:
  clra
  rts

;*****************
FxDrawSpriteVL:                 ;Draw a single sprite  u=pointer to x,y  x=vectorlist a=scale b=intensity
  mDecLocals 2,2,0
  ;DP must be D0

  ;**todo: perhaps make a FxDrawVL also, this routine takes sprite format of VL

  sta LocalB1,s
  stb LocalB2,s
  stx LocalW1,s

  ldx ,u
  ldy 2,u
  jsr FxGetScreenCoords
  beq fxdExit

  std LocalW2,s
  mSetScale $7f                 ;Scale $7f is required for move_pen_d to reach whole screen
  jsr reset0ref
  ldd LocalW2,s
  mMove_pen_d_Quick

  lda LocalB2,s
  mSetIntensity

  ldx LocalW1,s
  lda ,x+                       ;Nr of vectors in list
fxdLoop:
  ldb LocalB1,s                 ;Scale
  jsr move_draw_VL4             ;Draw list
  lda ,x+                       ;Get next count, $ff ends
  bpl fxdLoop
fxdExit:

  mFreeLocals
  rts


;*****************
FxMoveDrawPattern:                ;a=point count, x=vectors, 'Pattern' holds current pattern
  sta -1,s
  ldd ,x++
  mMove_pen_d_Quick
  lda -1,s
  jmp dwp_with_count


;*****************
Draw_Warp:                      ;A=time, X/Y=world coords
  mDecLocals 2,1,0
  sta LocalB1,s
  jsr FxGetScreenCoords
  std LocalW1,s

  jsr reset0ref
  ldd LocalW1,s
  jsr move_pen7f_to_d

  ;draw several times without reset0ref, each ring is drawn a bit above the last one
  lda #4
  sta LocalB2,s
dwLoop:
  lda LocalB1,s
  adda #20
  mSetIntensity

  ldx #WarpVectorList
  lda ,x+
  ldb LocalB1,s
  addb #6       ;scale

  jsr move_draw_VL4

  lda LocalB1,s
  adda #6
  sta LocalB1,s

  dec LocalB2,s
  bne dwLoop

  mFreeLocals
  rts


;*****************
DrawRisingScore:                    ;A=time, X/Y=world coords, U=vectorlist
  ;Draw a slowly rising score amount
  mDecLocals 1,0,4

  sta LocalB1,s
  sta -1,s
  lda #32
  suba -1,s
  tfr a,b
;  lsla
  nega

  stx LocalBuffer,s
  leay a,y
  sty LocalBuffer+2,s

  tfr u,x
  leau LocalBuffer,s

  tfr b,a ;scale
  lsra
;  lsra

  ldb LocalB1,s ;intensity
  addb #$40

  jsr FxDrawSpriteVL

  mFreeLocals
  rts


;*****************
;GetCoords-routines
;Returns world-coords in X and Y for each type of target
;*****************


;*****************
FxGetCoords_Ship:
  ldx ShipX
  ldy ShipY
  rts

;*****************
FxGetCoords_Pod:
  ldx PodX
  ldy PodY
  rts

;*****************
FxGetCoords_Gun:                ;index in A
  ldu CurLevelEntry             ;Gun
  ldu leGuns,u
  leau 1,u                      ;skip gun count
  ldb #GunEntry
  mul
  leau d,u                      ;u points to gun entry
  stu FxTempEntry
  ldx geGunX,u
  ldy geGunY,u
  rts

;*****************
FxGetCoords_Plant:
  ldu CurLevelEntry
  ldx lePowerX,u
  ldy lePowerY,u
  rts

;*****************
FxGetCoords_Fuel:               ;index in A
  ldu CurLevelEntry
  ldu leFuel,u
  leau 1,u                      ;skip fuel count
  ldb #FuelEntry
  mul
  leau d,u                      ;u points to fuel coords
  ldx ,u
  ldy 2,u
  rts

;*****************
FxGetCoords_Switch:             ;index in A
  ldu CurLevelEntry
  ldu leSwitches,u
  leau 1,u                      ;skip switch count
  ldb #SwitchEntry
  mul
  leau d,u                      ;u points to fuel coords
  ldx seSwitchX,u
  ldy seSwitchY,u
  rts

;*****************
FxGetCoords_Walker:             ;index in A
  ldu #WalkerList
  ldb #WalkerEntry
  mul
  leau d,u
  ;Walker constants are not declared yet
  ;avoid 2-bytes offsets
  ldx 2,u ;weWalkerX
  ldy 4,u ;weWalkerY
  rts





;*****************
;Draw-routines
;Separate draw-function for each fxtype
;*****************


;*****************
FxDraw_DotShatter:              ;A=time, X/Y=world coords
  mDecLocals 0,0,4
  stx LocalBuffer,s
  sty LocalBuffer+2,s
  leau LocalBuffer,s

  nega                          ;reverse time
  adda #ShatterStartTime

  jsr DotShatter
  mFreeLocals
  rts

;*****************
FxDraw_Refueling:
  mDecLocals 1,1,0

  ;Surround fuelcell with box
  jsr FxGetScreenCoords
  std LocalW1,s
  jsr reset0ref
  mSetIntensity $70
  ldd LocalW1,s
  jsr move_pen7f_to_d
  ldx #RefuelVectorList

  mRandomToA
  sta Pattern

  ldb #DrawScale
  lda LoopCounterLow
  anda #15
  nega
  pshs a
  subb ,s+
  tfr b,a
  mSetScale

  lda #4-1
  jsr FxMoveDrawPattern

  ;Draw dots rising from the fuelcell
  lda #12
  sta LocalB1,s
  ldy #$F000            ;offset each coordinate with data from exec-rom + loopcounter
fdrStars:
  jsr reset0ref

  lda LoopCounterLow
  adda ,y+
  anda #31
  adda LocalW1,s
  adda #16

  ldb ,y+
  andb #TileW-1
  subb #TileW/2
  addb LocalW1+1,s

  jsr move_pen7f_to_d
  mDot_at_current_position 1

  dec LocalB1,s
  bne fdrStars

  mFreeLocals
  rts

;*****************
FxDraw_PickUpPod:               ;A=time, X/Y=world coords
  mDecLocals 2,1,20
  sta LocalB1,s
  jsr FxGetScreenCoords
  std LocalW1,s

  lda LoopCounterLow            ;angle
  ldx #OrbVectorList
  ldb ,x+
  stb LocalB2,s                 ;vector count
  leau LocalBuffer,s            ;Vector buffer
  jsr rot_vec_list2             ;Rotate vectors

  jsr reset0ref

  lda LocalB1,s
  adda #$40
  mSetIntensity

  ldd LocalW1,s
  jsr move_pen7f_to_d
  leax LocalBuffer,s
  lda LocalB2,s
  ldb LocalB1,s
  addb #DrawScale
  jsr move_draw_VL4
  mFreeLocals
  rts

;*****************
FxDraw_Score150:                ;A=time, X/Y=world coords
  ldu #Score150_Lines
  jsr DrawRisingScore
  rts

;*****************
FxDraw_Score300:                ;A=time, X/Y=world coords
  ldu #Score300_Lines
  jsr DrawRisingScore
  rts

;*****************
FxDraw_Score750:                ;A=time, X/Y=world coords
  ldu #Score750_Lines
  jsr DrawRisingScore
  rts

;*****************
FxDraw_WarpIn:                  ;A=time, X/Y=world coords
  cmpa #24
  bne wi1
    sta -1,s
    mClearFlag InactiveFlag
    lda -1,s
wi1:
  jsr Draw_Warp
  rts

;*****************
FxDraw_WarpOut:                 ;A=time, X/Y=world coords
  sta -1,s
  lda #32                       ;reverse time
  suba -1,s
  jsr Draw_Warp
  rts


;*****************
FxDraw_FuelCell:                ;A=time, X/Y=world coords
  mDecLocals 1,0,4

  sta LocalB1,s

  stx LocalBuffer,s
  sty LocalBuffer+2,s
  leau LocalBuffer,s

  ;scale
;  lsra

  ldb LocalB1,s ;intensity
  addb #$40

  ldx #SpriteFuelCell
  jsr FxDrawSpriteVL

  mFreeLocals
  rts


;*****************
FxDraw_PlanetExplode:                ;A=time, X/Y=world coords
  anda #2
  beq peShow
    mClearFlag NoLandscapeFlag
    bra peOk
peShow:
    mSetFlag NoLandscapeFlag
peOk:
  rts


;*****************
FxDraw_GunFire:                ;A=time, X/Y=world coords
  mDecLocals 1,0,4
  sta LocalB1,s

  stx LocalBuffer,s
  sty LocalBuffer+2,s

  ;Get lines for gun
  ldu FxTempEntry
  ldb geGunSprite,u
  aslb
  ldx #GunSpriteTable
  ldx b,x

  ;scale
  lsla
  adda #DrawScale

  ldb LocalB1,s ;intensity
  addb #$60
;  ldb #$5f

  leau LocalBuffer,s
  jsr FxDrawSpriteVL

  mFreeLocals
  rts

;-----------------
;Finish-routines
;Separate finish-function for each target
;Called when time has run out for the fx
;-----------------

;*****************
FxFinish_Ship:                  ;A=fxtype
  cmpa #FxTypeDotShatter
  bne fxsNext1
    jsr OnLoseLife
    bra fxsExit
fxsNext1:
;  cmpa #FxTypeWarpIn
;  bne fxsNext2
;    mClearFlag InactiveFlag
;    bra fxsExit
;fxsNext2:
  cmpa #FxTypeWarpOut
  bne fxsNext3
    jsr OnExitLevel
    bra fxsExit
fxsNext3:
fxsExit:
  rts

FxFinish_Dummy:                 ;A=fxtype
  rts

FxInitTable: ;Starttime, soundfx for each fxtype
  db ShatterStartTime,ExplosionSoundId
  db 2,0
  db 64,PickupSoundId
  db 32,0
  db 32,0
  db 32,0
  db 32,WarpInSoundId
  db 32,WarpOutSoundId
  db DrawScale,PickupSoundId
  db 64,PlanetExplodeSoundId
  db 8,GunFireSoundId

FxDrawTable:
  dw FxDraw_DotShatter
  dw FxDraw_Refueling
  dw FxDraw_PickUpPod
  dw FxDraw_Score150
  dw FxDraw_Score300
  dw FxDraw_Score750
  dw FxDraw_WarpIn
  dw FxDraw_WarpOut
  dw FxDraw_FuelCell
  dw FxDraw_PlanetExplode
  dw FxDraw_GunFire

FxGetCoordsTable:
  dw FxGetCoords_Ship
  dw FxGetCoords_Pod
  dw FxGetCoords_Gun
  dw FxGetCoords_Plant
  dw FxGetCoords_Fuel
  dw FxGetCoords_Switch
  dw FxGetCoords_Walker

FxFinishTable:          ;OnFinish-event for each target
  dw FxFinish_Ship
  dw FxFinish_Dummy
  dw FxFinish_Dummy
  dw FxFinish_Dummy
  dw FxFinish_Dummy
  dw FxFinish_Dummy
  dw FxFinish_Dummy
  dw FxFinish_Dummy
