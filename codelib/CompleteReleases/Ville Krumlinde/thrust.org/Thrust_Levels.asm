; Level-definitions
; Copyright (C) 2004  Ville Krumlinde

;Macro for defining a level, see struct LevelEntry
LevelDef macro LevelNo, SizeX,SizeY, PodX, PodY, PowerX, PowerY
  db SizeX,SizeY
  dw Level\1_Tiles,Level\1_Guns,Level\1_Fuel
  dw PodX * TileW + HalfW, PodY * TileH + HalfH + (HalfH/4) + 1
  dw PowerX * TileW + HalfW, PowerY * TileH + HalfH + (HalfH/4) + 1
  dw Level\1_Restart
  dw Level\1_Doors
  dw Level\1_Switches
 endm

LevelCountNormal = 6    ;6 levels in normal mode
LevelCount = 8          ;hard+ and timeattack modes
Levels:
  LevelDef 1, 32,8 ,  16, 5,  19, 3
  if Level1Only!=1
  LevelDef 2, 25,18,  8,15,   3, 3
  LevelDef 3, 22,30,  2,27,   17, 5
  LevelDef 4, 24,34,  17,32,  7,19
  LevelDef 5, 22,43,  17,41,  11,11
  LevelDef 6, 30,52,  22,50,  27,50
  LevelDef 7, 23,20,  13,15,  19,15
  LevelDef 8, 25,36,  8,34,   16,23
  endif

  cmap "0",0,1,2,3,4,5,6,7,8,9    ; decode ASCII digits to binary
  cmap "A",10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26   ;normal tiles
  cmap "a",32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48   ;special tiles without lines

FuelY = HalfH + 5                       ;Fuel pod Y offset
GunY = (HalfH/2)                        ;Gun Y offset

;Off is 1 or -1, meaning to adjust Y quarter of a tile down or up respectively
;0=NE,1=NW,2=SE,3=SW
GunDef macro Type,Off,X1,Y1             ;Gun definition macro
   dw (TileW * X1) + HalfW, (TileH * Y1) + HalfH + (GunY*Off)
   db Type
 endm

FuelDef macro X1,Y1                     ;Fuel pod definition macro
   dw (TileW * X1) + HalfW, (TileH * Y1) + FuelY
 endm

RestartDef macro X1,Y1                  ;Restart point definition macro
   db X1,Y1
 endm

DoorDef macro Type, X1,Y1               ;Door definition
   db Type
   dw (TileW * X1), (TileH * Y1)
 endm

SwitchDef macro Type, X1,Y1
   if Type=0
     dw (TileW * X1)                    ;left wall
   else
     dw (TileW * X1) + TileW            ;right wall
   endif
   dw (TileH * Y1) + HalfH
   db Type
 endm


;**todo level data restrictions:
; - level must be at least TileCountY high or RefreshDrawList won't work
; - doors must have x > TileCountX or they won't be drawn correctly

Level1_Tiles:
  db "00000000000000000000000000000000"
  db "00000000000000000000000000000000"
  db "00000000000000000000000000000000"
  db "00000000000000000000000000000000"
  db "111112300000000000G1111111111111"
  db "aaaaaaa11112300000Aaaaaaaaaaaaaa"
  db "000000aaaaaaa11111aa000000000000"
  db "000000000000aaaaaaaa000000000000"
Level1_Guns:
  db 1  ;count
  GunDef 0,1, 12,5
Level1_Fuel:
  db 1  ;count
  FuelDef 9,4
Level1_Restart:
  db 1  ;count
  RestartDef 9,2
Level1_Doors:   ;also need mapchange for collision, 'bc' for horiz door, 'de' for vert door
  db 0  ;count
;  DoorDef 2, 10,2
Level1_Switches:
  db 0  ;count
;  SwitchDef 0, 13,2

 if Level1Only!=1

Level2_Tiles:
  db "0000000000000000000000000"
  db "0000000000000000000000000"
  db "0000000000000000000000000"
  db "0000000000000000045111123"
  db "11111230000000045aa000000"
  db "000000a23000045aaa0000000"
  db "000000aaaE000Aaa000000000"
  db "00000000aB000Aa0000000000"
  db "00000000aB000Aa0000000000"
  db "00000000aB000Aa0000000000"
  db "00000000aB000Daaa00000000"
  db "0000000a67000089aa0000000"
  db "0000aa6700000000Aa0000000"
  db "0000aB0000000000Aa0000000"
  db "0000aB0000000045aa0000000"
  db "0000aa23000045aaa00000000"
  db "00000aaa1111aaaa000000000"
  db "0000000000000000000000000"
Level2_Guns:
  db 2  ;count
  GunDef 2,-1, 7,12
  GunDef 3,-1, 14,11
Level2_Fuel:
  db 1  ;count
  FuelDef 11,15
Level2_Restart:
  db 1  ;count
  RestartDef 4,1
Level2_Doors:     db 0  ;count
Level2_Switches:  db 0  ;count


Level3_Tiles:
  db "0000000000000000000000"
  db "0000000000000000000000"
  db "0000000000000000000000"
  db "0000000000000000000000"
  db "111111111111F000000G11"
  db "00000000000aB000000Aa0"
  db "00000000000aB000G11a00"
  db "00000000000aB000Aa0000"
  db "00000000000aB000Aa0000"
  db "00000000000aB000IHHHHa"
  db "00000000000aJ00000000A"
  db "0000000000aB000000000A"
  db "0000000000aB00000000Ka"
  db "0000000000aB000G1111a0"
  db "0000000000aB000Aa00000"
  db "0000000HHHHL000Aa00000"
  db "0aHHH6700000000Aa00000"
  db "aJ0000000000000Aa00000"
  db "B00000000000000Aa00000"
  db "B0000000000G111a000000"
  db "B0000000000Aa000000000"
  db "B0000000000Aa000000000"
  db "B0004511111a0000000000"
  db "B000Aa0000000000000000"
  db "B000Aa0000000000000000"
  db "B000Aa0000000000000000"
  db "B000Aa0000000000000000"
  db "aM00Aa0000000000000000"
  db "0a11a00000000000000000"
  db "0aaaa00000000000000000"
Level3_Guns:
  db 5  ;count
  GunDef 1, 1, 20,12
  GunDef 2,-1, 12,10
  GunDef 2,-1, 6,16
  GunDef 2,-1, 1,17
  GunDef 1,-1, 5,22
Level3_Fuel:
  db 6  ;count
  FuelDef 10,3
  FuelDef 16,12
  FuelDef 17,12
  FuelDef 18,12
  FuelDef 12,18
  FuelDef 7,21
Level3_Restart:
  db 3  ;count
  RestartDef 9,0
  RestartDef 14,11
  RestartDef 4,19
Level3_Doors:     db 0  ;count
Level3_Switches:  db 0  ;count


Level4_Tiles:
  db "000000000000000000000000"
  db "11111230000000G111111111"
  db "000000a2300000Aa00000000"
  db "00000000a11F00Aa00000000"
  db "0000000000aB00Aa00000000"
  db "0000000000aB00Aa00000000"
  db "0000000000aB00Aa00000000"
  db "000000000a6700Aa00000000"
  db "0000000a670000Aa00000000"
  db "00000a67000000Aa00000000"
  db "000a6700000000Aa00000000"
  db "00aB0000000000Aa00000000"
  db "00aB0000000000Aa00000000"
  db "000a12300G1111aa00000000"
  db "00000aN00Aa0000000000000"
  db "000a6700089a000000000000"
  db "000B000000089a0000000000"
  db "000B00000000089HHHHHHHHa"
  db "000B0000000000000000000A"
  db "000B0000000000000000000A"
  db "000a1111111230000000000A"
  db "000000000000a2300000000A"
  db "00000000000000a11111F00A"
  db "0000000000000000000aBbcA"
  db "0000000000000000000aB00A"
  db "000000000000000000a6700A"
  db "0000000000000000a670000A"
  db "00000000000000a67000000A"
  db "0000000000000aB00000000A"
  db "0000000000000aB00000045a"
  db "00000000000000a230045a00"
  db "000000000000000aB00Aa000"
  db "000000000000000aB00Aa000"
  db "0000000000000000a11a0000"
Level4_Guns:
  db 7  ;count
  GunDef 2,-1, 9,8
  GunDef 2,-1, 5,15
  GunDef 2,-1, 18,26
  GunDef 3,-1, 13,17
  GunDef 1, 1, 21,29
  GunDef 0, 1, 6,13
  GunDef 0, 1, 12,20
Level4_Fuel:
  db 1  ;count
  FuelDef 19,21
Level4_Restart:
  db 4  ;count
  RestartDef 11,0
  RestartDef 10,10
  RestartDef 18,19
  RestartDef 18,28
Level4_Doors:   ;also need mapchange for collision, 'bc' for horiz door, 'de' for vert door
  db 1  ;count
  DoorDef 0, 21,23
Level4_Switches:
  db 2  ;count
  SwitchDef 1, 22,25
  SwitchDef 1, 22,20


Level5_Tiles:
 db "0000000000000000000000"
 db "111123000000G111111111"
 db "00000aE00000A000000000"
 db "00000aB00000A000000000"
 db "000000a11F00A000000000"
 db "000000000B00A000000000"
 db "000000000B00A000000000"
 db "000000000B00A000000000"
 db "00000000HL00IHa0000000"
 db "0000006700000089a00000"
 db "00000B0000000000A00000"
 db "00000B0000000000A00000"
 db "00000a1F00G11111a00000"
 db "0000000B00A00000000000"
 db "0000000B00Ia0000000000"
 db "000000aN000A0000000000"
 db "0aHHH670000A0000000000"
 db "0B000000000A0000000000"
 db "0B000000000A0000000000"
 db "0B00000000Ka0000000000"
 db "0B000G1111a00000000000"
 db "0B000A0000000000000000"
 db "0B00089a00000000000000"
 db "0B0000089a000000000000"
 db "0a230000089a0000000000"
 db "000a2300000A0000000000"
 db "00000L00000A0000000000"
 db "0000B000000IHa00000000"
 db "0000B0000000089a000000"
 db "0000a2300000000A000000"
 db "000000a11F00000IHHa000"
 db "000000000B00000000A000"
 db "000000000B00000000A000"
 db "000000000a23000000A000"
 db "00000000000a111FddA000"
 db "000000000000000BeeA000"
 db "000000000000000B0089a0"
 db "000000000000000B0000Ca"
 db "000000000000000B00000A"
 db "000000000000000B00000A"
 db "000000000000000B0000Ka"
 db "000000000000000aM045a0"
 db "0000000000000000a1a000"
Level5_Guns:
  db 7  ;count
  GunDef 2,-1, 7,9
  GunDef 3,-1, 14,9
  GunDef 1, 1, 10,19
  GunDef 3,-1, 13,28
  GunDef 0, 1, 6,29
  GunDef 0, 1, 11,33
  GunDef 3,-1, 20,37
Level5_Fuel:
  db 8  ;count
  FuelDef 8,3
  FuelDef 13,11
  FuelDef 14,11
  FuelDef 6,19
  FuelDef 8,29
  FuelDef 9,29
  FuelDef 13,33
  FuelDef 14,33
Level5_Restart:
  db 5  ;count
  RestartDef 8,0
  RestartDef 11,9
  RestartDef 9,16
  RestartDef 8,26
  RestartDef 18,38
Level5_Doors:   ;also need mapchange for collision, 'bc' for horiz door, 'de' for vert door
  db 1  ;count
  DoorDef 1, 16,34
Level5_Switches:
  db 2  ;count
  SwitchDef 1, 17,32
  SwitchDef 0, 16,39


Level6_Tiles:
 db "000000000000000000000000000000"
 db "F00000000000000000451111111111"
 db "B00000000000000045a00000000000"
 db "B000000000000045a0000000000000"
 db "aM000000000000A000000000000000"
 db "0a11112300000089a0000000000000"
 db "0000000a2300000089a00000000000"
 db "000000000a2300000089a000000000"
 db "00000000000a2300000089a0000000"
 db "0000000000000a2300000089a00000"
 db "000000000000000a2300000089a000"
 db "00000000000000000a23000000A000"
 db "0000000000000000000a230000A000"
 db "000000000000000000000a2300A000"
 db "00000000000000000000000B00A000"
 db "00000000000000000000aHHL00Aa00"
 db "0000000000000000000aJ0000089a0"
 db "0000000000000000000B00000000Ca"
 db "0000000000000000000B000000000A"
 db "0000000000000000000B000045111a"
 db "0000000000000000000B0045a00000"
 db "0000000000000000000B00A0000000"
 db "0000000000000000000B00A0000000"
 db "0000000000000000000B00A0000000"
 db "0000000000000000000B00Da000000"
 db "0000000000000000000B000Ca00000"
 db "0000000000000000000B0000A00000"
 db "0000000000000000000B000Ka00000"
 db "00000000000000000aHL000A000000"
 db "00000000000000000B00000A000000"
 db "00000000000000000B00000A000000"
 db "00000000000000000B00000A000000"
 db "00000000000000000B00G11a000000"
 db "0000000000000000aN00A000000000"
 db "00000000000000a67000A000000000"
 db "00000000000000B0000089a0000000"
 db "00000000000000aM00000089a00000"
 db "000000000000000a2300000089a000"
 db "00000000000000000a23000000A000"
 db "0000000000000000000a230000A000"
 db "000000000000000000000a2300A000"
 db "00000000000000000000000BbcA000"
 db "000000000000000000000a6700A000"
 db "000000000000000000000B0000A000"
 db "000000000000000000000B0000A000"
 db "000000000000000000000B0000A000"
 db "00000000000000000000aJ0000A000"
 db "00000000000000000000B00045a000"
 db "00000000000000000000B00Oa00000"
 db "00000000000000000000B00A00HHH0"
 db "00000000000000000000B00A0B000A"
 db "00000000000000000000a11a001110"
Level6_Guns:
  db 10  ;count
  ;0=NE,1=NW,2=SE,3=SW
  GunDef 3,-1, 16,6
  GunDef 2,-1, 20,16
  GunDef 3,-1, 28,17
  GunDef 3,-1, 23,25
  GunDef 1, 1, 23,27
  GunDef 2,-1, 16,34
  GunDef 3,-1, 22,36
  GunDef 2,-1, 23,42
  GunDef 2,-1, 21,46
  GunDef 1, 1, 24,47
Level6_Fuel:
  db 2  ;count
  FuelDef 26,18
  FuelDef 21,31
Level6_Restart:
  db 5  ;count
  RestartDef 9,3
  RestartDef 22,18
  RestartDef 21,26
  RestartDef 18,35
  RestartDef 24,44
Level6_Doors:   ;also need mapchange for collision, 'bc' for horiz door, 'de' for vert door
  db 1  ;count
  DoorDef 0, 24,41
  ;**todo horiz pointy -> door
Level6_Switches:
  db 2  ;count
  SwitchDef 1, 25,40
  SwitchDef 0, 22,44

Level7_Tiles:
  db "00000000000000000000000"
  db "00000000045F00000000000"
  db "111111111a0BbcG11111111"
  db "00000000000BbcA00000000"
  db "00000000000B00A00000000"
  db "00000000000B00A00000000"
  db "00000000000BfgA00000000"
  db "00000000000BfgA00000000"
  db "a0000000000B00DHHHHHHHH"
  db "89a00000000B00000000dd0"
  db "0089a000000B00000000ee0"
  db "300089a0000a111E0G11112"
  db "a23000A0000000aN0Da0000"
  db "0aB000A0000000B000A0000"
  db "00B000A00000aHN000DHa00"
  db "00B000A00000B0000000A00"
  db "00B000A00000a1230451a00"
  db "00B000A00000000a1a00000"
  db "00a111a0000000000000000"
  db "00000000000000000000000"
Level7_Guns: ;0=NE,1=NW,2=SE,3=SW
  db 7  ;count
  GunDef 3, 1, 14,8
  GunDef 2, 1, 14,14
  GunDef 3, 1, 18,14
  GunDef 0,-1, 14,16
  GunDef 0, 1, 15,16
  GunDef 1, 1, 17,16
  GunDef 1,-1, 18,16
Level7_Fuel:
  db 3  ;count
  FuelDef 3,17
  FuelDef 4,17
  FuelDef 5,17
Level7_Restart:
  db 3  ;count
  RestartDef 13,0
  RestartDef 13,9
  RestartDef 16,15
Level7_Doors:   ;also need mapchange for collision, 'bc' for horiz door, 'de' for vert door
  db 5  ;count
  DoorDef 0, 12,2
  DoorDef 0, 12,3
  DoorDef 2, 12,6
  DoorDef 2, 12,7
  DoorDef 3, 20,9
Level7_Switches:
  db 3  ;count
  SwitchDef 0, 12,1
  SwitchDef 1, 13,4
  SwitchDef 1, 5,16


Level8_Tiles:
  db "0000000000000000000000000"
  db "11111F00G11111111FbcG1111"
  db "00000B00A00000000B00A0000"
  db "00000B00A00000000B30A0000"
  db "0000aJ43Ca0000000B70A0000"
  db "0000B0870A0000000B00A0000"
  db "0000B0430A0000000B00A0000"
  db "0000aM87Ka0000000B00A0000"
  db "00000B00A00000000B00A0000"
  db "00000B00A00000000B04A0000"
  db "00000B00A00000000B08A0000"
  db "00000B00A00000000B00A0000"
  db "00000B00D00000000B00A0000"
  db "00000B00O00000000B00A0000"
  db "00000B00A00000000B00A0000"
  db "00000B00A00000000B30A0000"
  db "0000aB00Aa0000000B70A0000"
  db "000a674389a000000B00A0000"
  db "0a6743874389a0000B00A0000"
  db "0a2387438745a0000B00A0000"
  db "000a238745a000000B00A0000"
  db "0000aB00Aa0000000B00A0000"
  db "00000B00A00000aHHL00A0000"
  db "00000B00A00000B00000A0000"
  db "00000N00A00000a11F00A0000"
  db "00000E00A0000000aB00Aa000"
  db "00000B00A000000a670089a00"
  db "00000B00A0000a6700430089a"
  db "00000B00A0000a2300870045a"
  db "0000aJ00Ca00000a230045a00"
  db "0000aM00Ka00aa000B00Aa000"
  db "00000B00DHHH69HHHN00A0000"
  db "00000B00000000000000A0000"
  db "00000B00000000000000A0000"
  db "00000B00000043000000A0000"
  db "00000a111111aa111111a0000"
Level8_Guns: ;0=NE,1=NW,2=SE,3=SW
  db 8  ;count
  GunDef 1,-1,  8,13
  GunDef 0,-1,  5,25
  GunDef 1, 1,  8,30
  GunDef 2, 1, 17,31
  GunDef 2,-1, 19,28
  GunDef 2,-1, 18,16
  GunDef 2,-1, 17,26
  GunDef 3,-1, 20,26
Level8_Fuel:
  db 1  ;count
  FuelDef 17,34
Level8_Restart:
  db 7  ;count
  RestartDef 7,0
  RestartDef 7,11
  RestartDef 7,25
  RestartDef 9,33
  RestartDef 19,11
  RestartDef 19,25
  RestartDef 18,33
Level8_Doors:   ;also need mapchange for collision, 'bc' for horiz door, 'de' for vert door
  db 1  ;count
  DoorDef 0, 18,1
Level8_Switches:
  db 1  ;count
  SwitchDef 1, 19,4

 endif ;if Level1Only


  cmap ;reset mapping
