; Macros, defines and BSS.
; Copyright (C) 2004  Ville Krumlinde


ScreenW equ 256
ScreenH equ 256
TileCountX equ 8   ;Must be power of 2
TileCountY equ 8   ;Must be power of 2
TileW equ ScreenW/TileCountX
TileH equ ScreenH/TileCountY

ShipMaxVeloc equ 8      ;Max velocity of ship

EmptySpaceH = 240       ;Height of empty space over levels
WorldTopY = -EmptySpaceH

DrawScale equ 20 ;15        ;Scale value used when drawing sprite-vectors

StartLevel = 1 - 1

Fixed = 2               ;Nr of bits to use for fixed point coords (need to change more than this)

;normal setting all 0
Immortal = 0            ;Set to 1 to make ship immortal
Level1Only = 0          ;Set to 1 to only include level 1 (smaller binary for debug)
DemoRecord = 0          ;Set to 1 to record user input for demo-playback.

RefuelDistance = 64             ;Max Y distance from ship to fuel when refueling.
BeamLength = 60                 ;Length of tractor beam (distance to pod)

ShipArea = 8                    ;Hit area for ship
PlantArea = 24                  ;Hit area, shot and ship vs powerplant
PodArea = 6                     ;Hit area, carried pod vs gunshots, level, fuelcells
FuelArea = 24                   ;Hit area, shots and ship vs fuelcells
GunArea = 14                    ;Hit area, ship shots vs guns
SwitchArea = 10                 ;Hit area, shot vs switch
StationaryPodArea = 14          ;Hit area, ship vs stationary pod

;B1 is lock, B2 is Tractor, B3 is Thrust, B4 is fire
DefaultButtonConfig = (3 << 6) | (1 << 4) | (2 << 2) | (0 << 0)
;DefaultButtonConfig = (0 << 6) | (1 << 4) | (2 << 2) | (3 << 0)

WallIntensity = $30

  struct LevelEntry
    db leSizeX          ;level width in tiles (must be first byte)
    db leSizeY          ;level height in tiles
    dw leTiles          ;address of tiles
    dw leGuns           ;address to list of guns
    dw leFuel           ;address to list of fuel pods
    dw leOrbX           ;X/Y coords of orb
    dw leOrbY
    dw lePowerX         ;X/Y coords of powerplant
    dw lePowerY
    dw leRestart        ;pointer to list of restart points
    dw leDoors          ;pointer to list of doors
    dw leSwitches       ;pointer to list of doorswitches
  end struct

  struct SpriteEntry
    dw seLinesRel       ;address to vectorlist used when drawing not clipped
    dw seLinesAbs       ;address to vectorlist used when drawing clipped
  end struct

  struct TileEntry
    dw teLinesRel       ;address to vectorlist used when drawing not clipped
    dw teLinesAbs       ;address to vectorlist used when drawing clipped
    dw teCollisionSub   ;address to subroutine for collisiontest
  end struct


;Returns an oscillating (sawtooth) value in a
;Max must be power of 2
;Max=4, returns 012210
mTicToc macro max
  local l1
  lda LoopCounterLow
  anda #max-1
  cmpa #max/2
  bcc l1
  eora #max-1
l1:
  endm


;Set the hi/lo part of a 16-bit register individually
mCombine macro reg,hival,loval
  ld\1 #(lo hival)<<8 | (lo loval)
  endm


;Collision test point vs box.
;size is width/height intersection test
;miss_label is where to bransch if no intersection
;u and y points to x1,y1 and x2,y2 respectively
;(x1>=x2 - (size/2)) && (x1<=x2 + (size/2)) &&  (y1>=y2 - (size/2)) && (y1<=y2 + (size/2));
mPointVsArea macro size,miss_label, X1,Y1, X2,Y2
  ldx     X1,u
  ldd     X2,y
  subd    #size/2
  std -2,s
  cmpx -2,s
  lblt    miss_label
  addd    #size
  std -2,s
  cmpx -2,s
  lbgt    miss_label
  ldx     Y1,u
  ldd     Y2,y
  subd    #size/2
  std -2,s
  cmpx -2,s
  lblt    miss_label
  addd    #size
  std -2,s
  cmpx -2,s
  lbgt    miss_label
  endm


;Collision test point vs rectangle.
;sizeW/H is width/height of rectangle
;x1/y1 is point, x2/y2 is rectangle center
;miss_label is where to branch if no intersection
;u and y points to x1,y1 and x2,y2 respectively
;(x1>=x2 - (sizeW/2)) && (x1<=x2 + (sizeW/2)) &&  (y1>=y2 - (sizeH/2)) && (y1<=y2 + (sizeH/2));
mPointVsRect macro sizeW,sizeH,miss_label, X1,Y1, X2,Y2
  ldx     X1,u
  ldd     X2,y
  subd    #sizeW/2
  std -2,s
  cmpx -2,s
  blt    miss_label
  addd    #sizeW
  std -2,s
  cmpx -2,s
  bgt    miss_label
  ldx     Y1,u
  ldd     Y2,y
  subd    #sizeH/2
  std -2,s
  cmpx -2,s
  blt    miss_label
  addd    #sizeH
  std -2,s
  cmpx -2,s
  bgt    miss_label
  endm


;Collision test area vs area
;xmin1,xmax1,ymin1,ymax1 are s-relative dimensions of first rectangle
;centerx2,centery2 are u-relative center-coords of second rectangle
;size2 is height/width of second rectangle
mTestAreaVsArea macro xmin1,xmax1,ymin1,ymax1,centerx2,centery2,size2,miss_label
  ldx     centerx2,u

  leax    size2/2,x
  cmpx    xmin1,s
  blt    miss_label

  leax    -size2,x
  cmpx    xmax1,s
  bgt    miss_label

  ldx     centery2,u
  leax    size2/2,x
  cmpx    ymin1,s
  blt    miss_label

  leax    -size2,x
  cmpx    ymax1,s
  bgt    miss_label
  endm


;Helper macro for mDecLocals
_mLocal macro s1,size,label
 if s1>0
   if size=1
LocalB\3 = FrameSize
   endif
   if size=2
LocalW\3 = FrameSize
   endif
FrameSize=FrameSize + size
s1=s1-1
 endif
 endm

;Declare local stack frame.
;  s1 nr of 1-byte locals,
;  s2 nr of 2-byte locals
;  bufsize is size of extra buffer (can be omitted)
;Locals are named Local1B etc for byte, Local1W for word, buffer is named LocalBuffer.
mDecLocals macro s1,s2,bufsize
  nolist
FrameSize=0
_aa=s1                  ;declare one byte locals
  _mLocal _aa,1,1
  _mLocal _aa,1,2
  _mLocal _aa,1,3
  _mLocal _aa,1,4
  _mLocal _aa,1,5
  _mLocal _aa,1,6
  _mLocal _aa,1,7
  ;7 B is max, add more if needed
_aa=s2                  ;declare two byte locals
  _mLocal _aa,2,1
  _mLocal _aa,2,2
  _mLocal _aa,2,3
  _mLocal _aa,2,4
  _mLocal _aa,2,5
  if \0=3              ;declare buffer
LocalBuffer = FrameSize
FrameSize = FrameSize + bufsize
  endif
  ;5 W is max, add more if needed
  leas -FrameSize,s
  list
 endm

;Free local stack frame declared with mDecLocals
mFreeLocals macro
  leas FrameSize,s
 endm


mSetFlag macro flag
  if 255>flag
    lda #flag
    ora GameFlags1
    sta GameFlags1
  else
    lda #(flag)>>8
    ora GameFlags2
    sta GameFlags2
  endif
  endm

mTestFlag macro flag
  if 255>flag
    lda GameFlags1
    bita #flag
  else
    lda GameFlags2
    bita #(flag)>>8
  endif
  endm

mClearFlag macro flag
  if 255>flag
    lda #~flag
    anda GameFlags1
    sta GameFlags1
  else
    lda #~((flag)>>8)
    anda GameFlags2
    sta GameFlags2
  endif
  endm

;D0 directs -1, all d0 relative code is written with explicit '<'
mDptoD0 macro
  lda   #0xD0
  tfr   a,dp
  direct -1
  endm

;C8 always directs c8, all game variables are implicitly relative
mDptoC8 macro
  lda   #0xC8
  tfr   a,dp
  direct $c8
  endm


;Returns a value in D between 0-255 if coord is on screen
;Tests for world wrap-around
mGetScreenX macro xptr
  local L143
  if  \0 = 0    ;no param, X holds X-coord
    tfr x,y
  endif
  if  \0 = 1
    ldy     xptr
  endif
  if  \0 = 2   ;as09 treats "2,y" as two separate macro arguments
    ldy     \1,\2
  endif
  ldx     ViewX
  tfr     y,d
  stx -2,s
  subd -2,s
  bge     L143
  ldd     CurLevelEndX
;  stx -2,s
  subd -2,s
  sty -2,s
  addd -2,s
L143:
  endm


;Coordinates in game world are stored in fixed point three bytes
;The integer part is in the first two bytes, the fraction is in the top two bits of the third byte

;Store d into three bytes in x
mStore_D_as_fixed macro
  clr 2,x

  asra
  rorb
  ror 2,x

  asra
  rorb
  ror 2,x

  std ,x
  endm


;Read three bytes from x into d
mGet_D_from_fixed macro
  ldd ,x

  asl 2,x
  rolb
  rola

  asl 2,x
  rolb
  rola
  endm



;Update x-coordinate in sprite structure. Apply velocity and test for world wrap.
;  u is pointer to sprite structure
;  X_Offset is u-relative offset to 3 byte x-coordinate
;  VelocX_Offset is u-relative offset to x-velocity
mUpdateXCoord macro X_Offset, VelocX_Offset
  local CheckRightEdge,XOk
  leax X_Offset,u               ;Update sprite X coordinate
  mGet_D_from_fixed
  std -2,s
  ldb VelocX_Offset,u
  sex
  addd -2,s
  mStore_D_as_fixed
  tsta                          ;Check for world ends
  bpl CheckRightEdge
    addd CurLevelEndX           ;Left end hit, wrap
    std X_Offset,u
    bra XOk
CheckRightEdge:
    subd CurLevelEndX
    bmi XOk
    std X_Offset,u              ;Right edge hit
XOk:
  endm


;Update y-coordinate in sprite structure. Apply velocity and test for top of world.
;  u is pointer to sprite structure
;  X_Offset is u-relative offset to 3 byte x-coordinate
;  VelocX_Offset is u-relative offset to x-velocity
;  HitTopLabel label where to jump if top of world
mUpdateYCoord macro Y_Offset, VelocY_Offset, HitTopLabel
  local NotHitTopOfWorld
  leax Y_Offset,u               ;Update sprite Y coordinate
  mGet_D_from_fixed
  std -2,s
  ldb VelocY_Offset,u
  sex
  addd -2,s
  cmpd #WorldTopY << Fixed
  bgt NotHitTopOfWorld
    lbra HitTopLabel            ;Top of world hit, bransch to remove
NotHitTopOfWorld:
  mStore_D_as_fixed
  endm




;Clear bit A in address adddr.
;  a holds the bit nr
;  addr is the address of the byte where the bit should be cleared
mClearBitA macro addr
  local lop
  ldb #255                    ;start with all bits set
  andcc #$fe                  ;clear carry flag, rolb will shift it into b
lop:                          ;rotate a zero into b
  rolb
  deca
  bpl lop
  andb addr                   ;b now has a hole in it, AND with addr to clear bit
  stb addr
  endm

;16 bit version of ClearBitA
mClearWordBitA macro addr
  local lop
  sta -1,s
  ldd #$ffff                  ;start with all bits set
  andcc #$fe                  ;clear carry flag, rolb will shift it into d
lop:                          ;rotate a zero into d
  rolb
  rola
  dec -1,s
  bpl lop
  anda addr                  ;D now has a hole in it, AND with addr to clear bit
  andb addr+1
  std addr
  endm

mSetBitA macro addr
  local lop,fin
  ldb #1
lop:
  deca
  bmi fin
  rolb
  bra lop
fin:
  orb addr
  stb addr
  endm

mSetByte macro addr, value
 if 0=value
   clr addr
 else
   lda #value
   sta addr
 endif
 endm

mSetWord macro addr, value
 if 0=value
   clra
   clrb
 else
   ldd #value
 endif
 std addr
 endm


;D = D div TileW
mDivTileW macro
  if TileW > 32
    asra
    rorb
  endif
  if TileW > 16
    asra
    rorb
  endif
  if TileW > 8
    asra
    rorb
  endif
  if TileW > 4
    asra
    rorb
  endif
  if TileW > 2
    asra
    rorb
  endif
  if TileW > 1
    asra
    rorb
  endif
  endm

;D = D div TileH
mDivTileH macro
  if TileH > 32
    asra
    rorb
  endif
  if TileH > 16
    asra
    rorb
  endif
  if TileH > 8
    asra
    rorb
  endif
  if TileH > 4
    asra
    rorb
  endif
  if TileH > 2
    asra
    rorb
  endif
  if TileH > 1
    asra
    rorb
  endif
  endm

;x,y is world coords, returns tile pointer in y
mGetLevelTile macro
  ;calc tile pointer: x = tiles + (CurLevelSizeX * (WorldY div TileH)) + (WorldX div TileW)
  tfr x,d               ;x
  mDivTileW
  ldx CurLevelEntry
  ldx leTiles,x
  abx
  tfr y,d               ;y
  mDivTileH
  lda CurLevelSizeX
  mul
  leax d,x
  endm




;Get a random value to A
mRandomToA macro
  jsr random                    ;call rom
  endm

;Set pointer to three byte random seed in u, save old ptr in oldptr,s
mSetRandomSeedToU macro oldptr
  if \0=1
    ldd $c87b
    std oldptr,s
  endif
  stu $c87b
  endm


mTestRangeD macro min,max,falselabel
  cmpd #min
  blt falselabel
  cmpd #max
  bgt falselabel
  endm

mSetIntensity macro intensity
  if \0=1
    lda   #intensity            ;if argument exists, load into a, otherwise use current a
  endif
  if false
    sta   <01
    ;sta   $C827
    ldd   #$0504
    sta   <00
    stb   <00
    stb   <00
    ldb   #01
    stb   <00
  endif
  sta   <01
  ldd   #$0401
  sta   <00
  stb   <00
  endm


mSetScale macro scale
  if \0=1
    lda #scale                  ;if argument exists, load into a, otherwise use current a
  endif
  sta <$04
  endm


mDrawToD macro
  local wait1
  sta   <$01
  clr   <$00
;  leax  2,x
  ;Ev. måste flera nop läggas till här för att kompensera att föregående rad
  ;kommenterats bort
;  nop
  inc   <$00
  stb   <$01
  ldd   #$FF00
  sta   <$0A
  stb   <$05
  lda   #$40
wait1:
  bita  <$0D
  beq   wait1
;  nop
  stb   <$0A
  endm

;Move to d, without the extra wait that the ROM version use
mMove_pen_d_Quick macro
  local PF33D,PF33B,PF341
  sta   <0x01
  clr   <0x00
  lda   #0xCE
  sta   <0x0C
  clr   <0x0A
  inc   <0x00
  stb   <0x01
  clr   <0x05
  ldb   #0x40
PF33D: bitb  <0x0D
  beq   PF33D
;PF33B: lda   #0x04
;PF341: deca
;  bne   PF341
  endm

;move pen to d
 if false
mMove_pen_d macro
  local PF58B,PF592,PF33B,PF33D,PF341,PF345,exit
  sta   <0x01
  clr   <0x00
  std -2,s
  lda   #0xCE
  sta   <0x0C
  clr   <0x0A
  inc   <0x00
  stb   <0x01
  clr   <0x05
  ldd -2,s
  ;inline convert ab to abs
  ;the following is just to calc how long to wait for finish
  tsta
  bpl   PF58B
  nega
  bvc   PF58B
  deca
PF58B: tstb
  bpl   PF592
  negb
  bvc   PF592
  decb
PF592:  ;end inline
  stb   -1,s
  ora   -1,s
  ldb   #0x40
  cmpa  #0x40
  bls   PF345
  cmpa  #0x64
  bls   PF33B
  lda   #0x08
  bra   PF33D
PF33B: lda   #0x04
PF33D: bitb  <0x0D
  beq   PF33D
PF341: deca
  bne   PF341
  bra exit
PF345: bitb  <0x0D
  beq   PF345
exit:
 endm
 endif

mDot_at_current_position macro dot_dwell
  ; From vectrex.txt
  ;    "(WARNING! high intensity and long Vec_Dot_Dwell might result in a burn in on
  ;     your vectrex monitor, be carefull while experimenting with this!)"
  local PF2CC
       lda   #0xFF
       sta   <0x0A
;       ldb   #dot_dwell         ;dot_dwell is a value for how long the dot is lit
;PF2CC: decb                     ;dwell is not the same as intensity
;       bne   PF2CC
       clr   <0x0A
 endm

mGiveScore macro Score
  lda #Score / 10
  jsr GiveScoreA
  endm

 if false  ;removed in 1.01
mVerifyCheckSum macro
  local vcsLoop,vcsOk
  ldx #CreditsText-20
  leax 20,x
  ldy #0
  clra
vcsLoop:
  ldb ,x+
  pshs a
  andb #7
  anda #7
  mul
  leay d,y
  puls a
  inca
  cmpx #CreditsTextEnd
  bne vcsLoop
  cmpy #CreditsTextCheckSum
  beq vcsOk
    ;sty ,s      ;crash
    rts
vcsOk:
 endm
 endif

;System Executive Entry Points
convert_a_to_bcd_and_add  equ     $f85e
add_score_d             equ     $f87c
byte_2_sound_chip       equ $f256
clear_256_bytes         equ     $f545
clear_sound_chip        equ $f272
compare_scores          equ     $f8c7
convert_angle_to_rise_run equ     $F601
copy_bytes_2_sound_chip equ $f27d
covert_add_bcd          equ     $f85e
display_string          equ     $f495
do_sound                equ     $f289
dot_at_current_position equ  $F2C5
dot_at_d                equ     $f2c3
dot_d                   equ     $f2c3
dot_ix                  equ     $f2c1
dptoC8                  equ     $f1af
dptoD0                  equ     $f1aa
draw_to_d               equ $f3df
draw_vl_a               equ     $f3da
draw_vl_count4          equ     $f3ce
drawl1b                 equ     $f40e
dwp_with_count=$F434
explosion_snd           equ     $f92e
get_abs_val_ab          equ     $F584
get_pl_game             equ     $f7a9
init_music_buf          equ     $f533
init_sound              equ     $f68d
init_sound_chk          equ     $f687
intensity_to_1f         equ     $f29d
intensity_to_3f         equ     $f2a1
intensity_to_5f         equ     $f2a5
intensity_to_7f         equ     $f2a9
intensity_to_A          equ     $f2ab
joy_analog              equ     $f1f5
move_block              equ     $f67f
move_block2             equ     $f683
move_draw_VL4           equ     $f3b7
move_pen                equ     $f310
move_pen7f              equ     $f30c
move_pen7f_to_d         equ     $f2fc
move_pen_d              equ     $f312
move_penff              equ     $f308
moveto_d_7f             equ     $F2FC
check_4_new_hi_score = $f8d8
obj_hit                 equ     $f8ff
print_1_string          equ     $f373
print_at_d              equ     $f37a
print_ships             equ     $f393
print_str_d             equ     $f37a
printu2                 equ     $f38a
random                  equ     $f511
read_joystick           equ     $f1f8
read_switches           equ     $f1b4
read_switches2          equ     $f1ba
reset0ref               equ     $f354
rot_vec_list1           equ     $f61f
rot_vec_list2           equ     $f610
set_dft_score           equ     $f84f
waitrecal               equ     $f192

;System RAM locations
stick1_button1 equ $c812
stick1_button2 equ $c813
stick1_button3 equ $c814
stick1_button4 equ $c815
_text_size              equ     $c82a
_stick1_mask            equ     $c81f
_stick2_mask            equ     $c820
_stick3_mask            equ     $c821
_stick4_mask            equ     $c822
_stick_res              equ     $c81a
_stick_type             equ     $c823
_pot_y                  equ     $c81c
_intensity              equ     $c827
_music_ready            equ     $c856
_refresh_time           equ     $c83d

LoopCounterHigh = $C825
LoopCounterLow = $C826
Pattern = $C829


;*****************************
; BSS section.
; Data declared here is not part of the binary image.
; The ORG line tells the assembler where to start allocating memory adresses
; to the names defined in this section.

; Labels needs to be declared before use to let the assembler optimize direct addressing with DP.

  bss
  org $c880

HighscoreEntry = (6+1)  ;score + end $80

;**************
;EEPROM-buffer, loaded with eeprom content or default values on boot
;Keep in sync with eeprom_format
eeprom_buffer           ;32 bytes
ButtonConfig:
  ds 1                  ;Button configuration
BonusGameEnabled:
  ds 1                  ;non-zero if bonus game is enabled
Highscores:
  ds HighscoreEntry*4   ;Highscores for each game mode, including hidden bonus game
  ds 31-(*-eeprom_buffer);pad to 32-bytes
  ds 1                  ;last byte is checksum
;End of EEPROM
;**************


UserRamStart:

;Temps used by refreshdrawlist, and collision
TemporaryArea:
TempPosXStart: db 0
TempPosX: db 0  ;keep
TempPosY: db 0  ;together
TempTileWY: dw 0
TempTileWX: dw 0
TempTileWXStart: dw 0
TempTilePtr: ds 2
TempAdjustX: ds 1


;Represents the center point between ship and the pod
;Fixed point 2 bits, 3 bytes
;The fraction part is in the third byte, this makes it easy to read the integer part with ldd.
CenterX: ds 3
CenterY: ds 3

;Current angle between ship and pod
;8 bit fixed point, hi(Alpha) is 0..240 (unsigned)
ALPHA_MAX      = 240
Alpha: ds 2
AlphaHi: equ Alpha

;Amount to change alpha (spin speed)
AlphaDelta: ds 2

ShipAngle: ds 1
LockedShipAngle = $C868         ;Angle when using locked thrust (rom unused)

ShipSpeedX: ds 2
ShipSpeedXHi: equ ShipSpeedX
ShipSpeedY: ds 2
ShipSpeedYHi: equ ShipSpeedY

; Ship coordinates.
; Position in game world.
ShipX: ds 2     ;keep
ShipY: ds 2     ;together

; Pod (when carried by ship)
PodX: ds 2      ;keep
PodY: ds 2      ;together

;Ship directions 0--32, 8=up.
;Vectrex ROM direction 0--64, 0=up.
SHIP_DIRMAX       = 32
VEC_DIRMAX        = 64

;Conversion macro: ship angle -> vectrex angle
mShipAngleToVec macro reg
 local l1
 lsl\1
 sub\1 #16
 bpl l1
   add\1 #VEC_DIRMAX
l1:
 endm

ShipVectorCount equ 10
ThrustVectorCount = 3


; Scrolling view
ScrollX: ds 1           ;0=no scroll, negative scroll left, positive scroll right
ScrollY: ds 1           ;0=no scroll, negative scroll up, positive scroll down


NeedRefresh:  db 0      ;1 if need refresh drawlist

; Coordinate in game world for top left edge of screen.
; This value is subtracted from sprite coord to produce screen coord.
ViewX: ds 2
ViewY: ds 2


; Game mode = difficulty
NormalGame = 0
HardGame = 1
TimeAttackGame = 2
BonusGame = 3
DemoGame = 4
GameMode = $C87A   ;(rom game version)


; Current level
CurLevelEntry: ds 2
CurLevelSizeX: ds 1
CurLevelEndX:  ds 2
CurLevelEndY:  ds 2     ;Actually highest ViewY (=EndY - ScreenH)
CurLevel:      ds 1

; CLIP globals (same as viewx/y)
_clip_xmin:     ds   2
_clip_ymin:     ds   2
_clip_xmax:     ds   2
_clip_ymax:     ds   2


; Status-display: Score and fuel
DigitCount = 6
PlayerScore: ds DigitCount
;NOTE first byte after PlayerScore is overwritten in Text_GameOver
ShipLives: ds 1
ShipFuel: ds 2


; Demo mode, use same RAM as playerscore, no score is displayed in demomode
DemoBase = PlayerScore
DemoMode = DemoBase
DemoPtr = DemoBase+1
DemoCounter = DemoBase+3
DemoSelected = $C86C            ;temp for which demo was selected in menu (rom unused)

; Time attack
TimeAttackTime: ds 1            ;countdown in timeattack game


; Frame counter
; This differs from the ROM loopcounter.
; Two separate counters are combined in one byte, which makes
; non-power of two frame interval tests possible.
; Thanks to Thomas Jentzsch.
FRAME2MASK      = %00000001
FRAME3MASK      = %11000000
FRAME4MASK      = %00000011
FRAME6MASK      = FRAME2MASK|FRAME3MASK     ; %11000001
FRAME8MASK      = %00000111
FRAME12MASK     = FRAME4MASK|FRAME3MASK     ; %11000011
FRAME16MASK     = %00001111
FRAME32MASK     = %00011111
FRAME48MASK     = FRAME16MASK|FRAME3MASK    ; %11001111
FRAME64MASK     = %00111111
FRAME96MASK     = FRAME32MASK|FRAME3MASK    ; %11011111
FRAME192MASK    = FRAME64MASK|FRAME3MASK    ; %11111111
FrameCounter: ds 1


;---------------------------------------
LevelClearLabel:        ;256 bytes from this label is cleared when a level is finished
;---------------------------------------


; Flags
ShieldFlag = 1          ;ship shield is active
RefuelFlag = 2          ;ship is refueling
HasOrbFlag = 4          ;ship is carrying orb
PullFlag   = 8          ;ship is pulling orb from orb-platform
InactiveFlag = 16       ;ship is invisible and cannot be controlled (exploding, materializing)
ThrustFlag   = 32       ;ship is thrusting
GameOverFlag = 64       ;set when game over
ReverseGravFlag = 128   ;Reverse gravity
NoLandscapeFlag = 256   ;Landscape is invisible
HomingGunShotsFlag = 512  ;Homing gunshots (hard gamemode)
LockedThrustFlag = 1024 ;Locked thrust angle active (hard gamemode)

GameFlags1: ds 1
GameFlags2: ds 1


; Guns
MaxGunCount = 16
GunsActive: ds 2        ;Each bit is a activeflag for a gun

  struct GunEntry       ;Guns are stored in rom with level data
    ds geGunX,2         ;x
    ds geGunY,2         ;y
    ds geGunSprite,1    ;sprite id
  end struct


; Fuel cells
MaxFuelCount = 8
FuelActive: ds 1                ;Each bit is a activeflag for a fuel cell
FuelAmounts: ds MaxFuelCount    ;Amount of fuel left in each cell
FullFuel = 16                   ;Amount of fuel in a full cell

  struct FuelEntry      ;Fuel cells are stored in rom with level data
    ds 2                ;x
    ds 2                ;y
  end struct


; Doors and switches

DoorSize = 32                   ;Opencounter for door

  struct DoorEntry
    db deDoorDir                ;Direction door closes: 0=right, 1=up
    dw deDoorX
    dw deDoorY
  end struct

  struct SwitchEntry            ;Door switch
    dw seSwitchX
    dw seSwitchY
    db seSwitchDir              ;0=left wall, 1=right wall
  end struct


DoorCounter: ds 1               ;Counter used when opening doors


; Powerplant
PowerLife ds 1                  ;hitpoints. <0 = countdown, >0 = hitpoints left
PowerShot ds 1                  ;>0 recently shot

; Perfect bonus
PerfectBonus: ds 1


; Gun shots
GunShotActive: ds 1       ;Each bit is a activeflag for a gunshot.
MaxGunShots = 3
GunShotAllActive = %111   ;Must be in sync with maxgunshots

  struct GunShotEntry
    ds gsShotX,3          ;3 byte world coordinate
    ds gsShotY,3          ;3 byte world coordinate
    db gsShotVelocX       ;Velocity
    db gsShotVelocY
  end struct
GunShotTimer: ds 1        ;Delay timer for next shot
GunShotMask: ds 1         ;Mask and delay for new shots, constants depending on level no and gamemode
GunShotDelay: ds 1
GunShotSpeed: ds 1
GunShots: ds GunShotEntry * MaxGunShots


; Fx
; Each entry is three bytes:
;    Time       8 bits: timeleft, 0=inactive
;    TargetType 4 bits: ship,Pod,gun,fuel,switch,plant
;    FxType     4 bits: explosion,teleportfx,250score,planetexplode
;    Index      8 bits: fuel,switch etc index
MaxFx = 3
FxList: ds 3 * MaxFx


; Ship shots.

; Max nr of shots active at one time. This value can be increased.
ShipShotCount = 4

; Structure holding info about one shot.
  struct ShipShotEntry
    db ssShotActive       ;Flag: is shot active?
    ds ssShotX,3          ;3 byte world coordinate
    ds ssShotY,3          ;3 byte world coordinate
    db ssShotVelocX       ;Velocity
    db ssShotVelocY
  end struct

; Array with shots.
ShipShotList:
  ds ShipShotEntry * ShipShotCount


;Sound data, see Thrust_Sound.asm
;Sound slot = Sound channel
SlotCount = 3
SoundSlots: ds SlotCount*2              ;contains id,timer of current sound, 0=empty


; Cheat mode, if both are zero then cheat is not active
CheatLives = $C86A  ;rom unused, <>0 for infinitive lives
CheatLevel = $C86B  ;rom unused, <>0 for select start level
Cheat = CheatLives


; Dynamic length, keep at end of BSS-section
DrawList:
