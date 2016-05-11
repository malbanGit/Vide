; Thrust sound effects
; Copyright (C) 2004  Ville Krumlinde

;   todo: anropa init_music_buf samtidigt som levelclearlabel
;     ResetSounds, nullar buffer, sätter mixer till konstant
;
;dåligt
;  vad är fel med current solution?
;  två ljud kan inte dela channel
;
;Sound_Thrust_Init
;  sätter mixers
;  sätter timer
;Sound_Thrust_Update
;  sätter ljudreg
;
;ideer
;  freq baserat på sinus
;  arpeggio baserat på sinus
;  vibrato baserat på sinus
;
;  slå på/av vibrato/arpeggio
;    källor: frame tictoc, sinus
;
;  random changes



SoundShadow equ $C800                   ;current chip values
SoundWork equ $C83F                     ;current work values


;Use frequency-table from Thrust_Music.asm
Octave = 24
OctaveCount = 8
FreqTable = L059582


mSoundId macro id,slot,name
name = (id << 2) | slot
 endm

;This is a bit clumsy:
; - changing id (priority) also means having to switch position in tables
; - changing slot (channel) also means having to change channel in sound code
 mSoundId 1,2,ThrustSoundId
 mSoundId 14,2,WalkerDestroyedSoundId

 mSoundId 2,0,GunFireSoundId
 mSoundId 3,0,ShipFireSoundId
 mSoundId 4,0,ExtraLifeSoundId

 mSoundId 5,1,WalkerBounceSoundId
 mSoundId 6,1,ShieldSoundId
 mSoundId 7,1,WarpOutSoundId
 mSoundId 8,1,ExplosionSoundId
 mSoundId 9,1,PickupSoundId
 mSoundId 10,1,WarpInSoundId
 mSoundId 11,1,CountdownSoundId
 mSoundId 12,1,PlanetExplodeSoundId
 mSoundId 13,1,PerfectBonusSoundId


SoundsTable:
  dw 0                  ;0 is unused
  dw Sound_Thrust
  dw Sound_GunFire
  dw Sound_ShipFire
  dw Sound_ExtraLife
  dw Sound_Dummy        ;bounce
  dw Sound_Shield
  dw Sound_WarpOut
  dw Sound_Explosion
  dw Sound_Pickup
  dw Sound_WarpIn
  dw Sound_Countdown
  dw Sound_PlanetExplode
  dw Sound_PerfectBonus
  dw Sound_WalkerDestroyed

SoundsInitTable:
  dw 0                  ;0 is unused
  dw Sound_Thrust_Init
  dw Sound_GunFire_Init
  dw Sound_ShipFire_Init
  dw Sound_ExtraLife_Init
  dw Sound_WalkerBounce_Init
  dw Sound_Shield_Init
  dw Sound_WarpOut_Init
  dw Sound_Explosion_Init
  dw Sound_Pickup_Init
  dw Sound_WarpIn_Init
  dw Sound_Countdown_Init
  dw Sound_PlanetExplode_Init
  dw Sound_PerfectBonus_Init
  dw Sound_WalkerDestroyed_Init

;Emit sound, all registers except D are preserved
mEmitSound macro SoundId
  if \0=1
    lda #SoundId
  endif
  jsr EmitSound
  endm


;*****************
EmitSound:
  pshs x,y,u

  tfr a,b

  anda #3
  lsla
  lsrb
  andb #254
  ;a=slot*2, b=sound id * 2

  ldx #SoundSlots
  tst a,x
  beq esOkEmit          ;slot is free
  cmpb a,x              ;slot busy, test priority
  blo esExit

esOkEmit:
  stb a,x

  leay a,x
  ;y=sound slot

  ldu #SoundsInitTable
  ldx #SoundWork
  jsr [b,u]
  sta 1,y               ;set timer

esExit:

  puls x,y,u,pc
;  rts


;*****************
UpdateSound:
  direct $c8
  ldx #SoundWork
  ldu #SoundSlots + ((SlotCount-1)*2)
  lda #SlotCount
usLop1:
  ldb ,u                ;b=sound id * 2
  beq usNext

  dec 1,u               ;decrease time
  beq usSoundFin

  pshs a,u

  lda 1,u               ;a=timer

  ldy #SoundsTable
  jsr [b,y]

  puls a,u

  bra usNext

usSoundFin:
  clr ,u                ;make slot empty
  tfr a,b

  addb #7
  negb
  addb #$d              ;b=this channels volume register
  clr b,x               ;clear volume

usNext:
  leau -2,u
  deca
  bne usLop1
  direct -1
Sound_Dummy:
  rts


;*****************
UpdateSoundChip = $f289


;*****************
;Sound-routines
;Separate sound-function for each soundid
;*****************

;SoundWork have the registers reversed
RegPitchA1 = $d - 0
RegPitchA2 = $d - 1
RegPitchB1 = $d - 2
RegPitchB2 = $d - 3
RegPitchC1 = $d - 4
RegPitchC2 = $d - 5
RegNoisePitch = $d - 6
RegMixer =      $d - 7
RegVolA = $d - 8
RegVolB = $d - 9
RegVolC = $d - 10

MixerToneA = 1
MixerToneB = 2
MixerToneC = 4
MixerNoiseA = 8
MixerNoiseB = 16
MixerNoiseC = 32

;x must point to sound regs
mMixerOn macro flag
 lda #~flag
 anda RegMixer,x
 sta RegMixer,x
 endm

;x must point to sound regs
mMixerOff macro flag
 lda #flag
 ora RegMixer,x
 sta RegMixer,x
 endm

;x must point to sound regs
mMixerOnOff macro onbit,offbit
 lda #~onbit
 anda RegMixer,x
 ora #offbit
 sta RegMixer,x
 endm

;x must point to sound regs
mSound macro reg,value
 if \0>1
   lda #value
 endif
 sta reg,x
 endm

Sound_Thrust_Init:   ;return start time in A
;  mMixerOn MixerNoiseC
;  mMixerOff MixerToneC
  mMixerOnOff MixerNoiseC,MixerToneC
  mSound RegNoisePitch,$1f
  mSound RegVolC,13
  lda #13
  rts

Sound_Thrust:   ;a=time, x=sound regs
  dec RegNoisePitch,x  ;**todo: keep this? affects explosion sounds also
  dec RegVolC,x
  rts

Sound_ShipFire_Init:
  mSound RegVolA,14
;  mSound RegPitchA1,50
;  mSound RegPitchA2,0
  mMixerOn MixerToneA
  lda #10
  rts

Sound_ShipFire:
  direct $c8
  ;Arpeggio every frame + note falling every 2nd frame
  ldu #FreqTable + (Octave*4) + Octave/2
  ldb LoopCounterLow
  andb #1
  beq  ssf1
    leau Octave,u
ssf1:
  lsra
  lsla
  leau a,u
  ldd ,u
  std RegPitchA2,x
  direct -1
  rts

Sound_Explosion_Init:   ;return start time in A
  mMixerOn MixerNoiseB
  mMixerOff MixerToneB
  mSound RegNoisePitch,$1f
  mSound RegVolB,15
  lda #64
  rts

Sound_Explosion:   ;a=time, x=sound regs
  adda #64
  lsra
  lsra
  lsra
  sta RegVolB,x
  rts


Sound_Shield_Init:   ;x=sound regs, return start time in A
  direct $c8
  mMixerOnOff MixerToneB,MixerNoiseB
  mSound RegVolB,11

  ldu #FreqTable ;+ (Octave)
  mTestFlag RefuelFlag
  beq ss1
    lda #Octave
    leau a,u
    mSound RegVolB,12
ss1:

  mTicToc 4
  ldb #Octave/2
  mul
  ldd d,u

  std RegPitchB2,x

  lda #2
  direct -1
  rts

Sound_Shield:   ;a=time, x=sound regs
  ;All sound is made in init
  rts

Sound_Pickup_Init:   ;x=sound regs, return start time in A
  mMixerOnOff MixerToneB,MixerNoiseB

  ldd #$21
  std RegPitchB2,x
;  mSound RegPitchB2
;  tfr b,a
;  mSound RegPitchB1

  lda #8
  rts

Sound_Pickup:   ;a=time, x=sound regs
  anda #2
  bne spBeep
    clr RegVolB,x
    bra spExit
spBeep:
    mSound RegVolB,14
spExit:
  rts

Sound_GunFire_Init:   ;x=sound regs, return start time in A
  direct $c8
  mMixerOnOff MixerToneA,MixerNoiseA

  ;Slightly higher tone if homing
  ldu #FreqTable + (Octave*0) + (2*9)
  mTestFlag HomingGunShotsFlag
  beq sgfNoHoming
    leau Octave*2,u
sgfNoHoming:
  ldd ,u

  std RegPitchA2,x
  mSound RegVolA,12
  lda #2
  direct -1
  rts

Sound_GunFire:   ;a=time, x=sound regs
  rts

Sound_WarpOut_Init:   ;x=sound regs, return start time in A
  mMixerOnOff MixerToneB,MixerNoiseB
  mSound RegVolB,13
  lda #32
  rts

Sound_WarpOut:   ;a=time, x=sound regs
  direct $c8
  ldu #FreqTable + Octave*2
  bra SoundWarpSub
  direct -1
;  rts

Sound_WarpIn_Init:   ;x=sound regs, return start time in A
  mMixerOnOff MixerToneB,MixerNoiseB
  mSound RegVolB,12
  lda #32
  rts

Sound_WarpIn:   ;a=time, x=sound regs
  direct $c8
  ldu #FreqTable + Octave*2
  nega
  adda #32      ;reverse time
  bra SoundWarpSub
  direct -1
;  rts

SoundWarpSub:
  direct $c8
  asra
  asla
  asla
  leau a,u

  lda LoopCounterLow
  anda #1
  ldb #Octave
  mul
  ldd d,u

  std RegPitchB2,x
  direct -1
  rts

Sound_PlanetExplode_Init:   ;x=sound regs, return start time in A
  mMixerOnOff MixerToneB,MixerNoiseB
  mSound RegVolB,14
  lda #64
  rts

Sound_PlanetExplode:   ;a=time, x=sound regs
  direct $c8
  ldu #FreqTable + Octave*3

  cmpa #40
  bge speNoRandom
    mRandomToA
    anda #31
    asla
    leau a,u
speNoRandom:

  lda LoopCounterLow
  anda #1
  ldb #Octave
  mul

  ldd d,u
  std RegPitchB2,x

  direct -1
  rts

Sound_PerfectBonus_Init:   ;x=sound regs, return start time in A
  mMixerOnOff MixerToneB,MixerNoiseB
  clr RegVolB,x
  lda #80
  rts

Sound_PerfectBonus:   ;a=time, x=sound regs
  direct $c8
  ldu #FreqTable ;+ Octave*1

  cmpa #32
  bge speNoSound

  asra
  asla
  asla
  ldy #SineTable
  lda a,y
  asla
  leau a,u

  lda LoopCounterLow
  anda #1
  ldb #Octave
  mul
  leau b,u

  mTicToc 32
  lda a,y
  asra
  adda 1,u

  mSound RegPitchB1
  lda ,u
  mSound RegPitchB2

  mSound RegVolB,14
speNoSound:
  direct -1
  rts

Sound_ExtraLife_Init:   ;x=sound regs, return start time in A
  mMixerOnOff MixerToneA,MixerNoiseA
  lda #8
  rts

Sound_ExtraLife:   ;a=time, x=sound regs
  direct $c8
  anda #2
  ldb #7
  mul
  stb RegVolA,x

  ldu #FreqTable + Octave*8  + (2*8)
  ldd ,u

  std RegPitchA2,x
  direct -1
  rts

Sound_WalkerBounce_Init:   ;x=sound regs, return start time in A
  direct $c8
  mMixerOnOff MixerToneB,MixerNoiseB

  ;Use hardcoded adress for jumping to avoid long constants
  lda ZzapConfig+4
;  lda zcJumping,y

  lsra
  lsra
  anda #15
  nega
  adda #15
  anda #127
  sta RegVolB,x

  ldd #$60c

  std RegPitchB2,x

  lda #2
  direct -1
  rts

Sound_WalkerDestroyed_Init:   ;x=sound regs, return start time in A
  mMixerOnOff MixerToneC,MixerNoiseC
  mSound RegVolC,15
  lda #64
  rts

Sound_WalkerDestroyed:   ;a=time, x=sound regs
  direct $c8

  ldu #FreqTable + Octave*2

  sta -1,s

  anda #3
  ldb #Octave
  mul
  leau d,u

  ldb -1,s
  asrb
  asrb
  asrb

  lda -1,s
  mul
  addd ,u

  std RegPitchC2,x

  direct -1
  rts

Sound_Countdown_Init:   ;x=sound regs, return start time in A
  mMixerOnOff MixerToneB,MixerNoiseB
  lda #14
  sta RegVolB,x
  lda #2
  rts

Sound_Countdown:   ;a=time, x=sound regs
  direct $c8

  ldu #FreqTable + Octave*4
  lda #10
  adda PowerLife
  ldb #Octave/4
  mul
  leau d,u

  ldd ,u

  std RegPitchB2,x
  direct -1
  rts
