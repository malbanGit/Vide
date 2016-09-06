;--- music data [created with VIDE: Mod2Vectrex v1.08 - 02.01.2011 by Wolf, additions by Nitro/NCE, PAS to Java by Malban] ---

adsr: 
  fcb $AB, $BB, $88, $76, $55, $55, $43, $33, $32, $22, $11, $10, $00, $00, $00, $00      ; channel 2
  fcb $DD, $DD, $CC, $CC, $BB, $BB, $AA, $AA, $00, $00, $00, $00, $00, $00, $00, $00      ; channel 1
  fcb $F9, $9F, $F9, $FD, $7C, $6B, $59, $47, $45, $32, $32, $00, $00, $00, $00, $00      ; channel 0

twang: 
  fcb $10, $00, $10, $00, $10, $00, $10, $00      ; channel 2
  fcb $00, $00, $00, $00, $00, $00, $00, $00      ; channel 1
  fcb $80, $80, $80, $80, $80, $80, $80, $80      ; channel 0


SPEED = 10
; Player identifier values
SIL            EQU     $3f   ;  Silence
NOISE          EQU     $40   ;  Sound is a 'noise'
CONT           EQU     $80   ;  continue to next note (max 2 continues per line)
; 
; Instrument mapping
_01            EQU     $3F   ;  Silence  :  At last it's true!     -> Silence
_02            EQU     $3F   ;  Silence  :  A long waited chip-    -> Silence
_03            EQU     $3F   ;  Noise    :  version of this        -> Bass drum
_04            EQU     $2F   ;  Noise    :  massive dancehit!      -> Snare drum
; _05                        ;  Note     :  Tracked of'coz by      -> Note
_06            EQU     $3F   ;  Silence  :  #ACE of THE ZYNAPS     -> Silence
; _07                        ;  Note     :  in the year of 1993!   -> Note
_08            EQU     $3F   ;  Silence  :  Contact for any        -> Silence
_09            EQU     $3F   ;  Silence  :  reason ...             -> Silence
_10            EQU     $3F   ;  Silence  :  Mikko Virtanen         -> Silence
_11            EQU     $3F   ;  Silence  :  Urpupolku 6a13 15240   -> Silence
_12            EQU     $3F   ;  Silence  :  Lahti Finland          -> Silence
_13            EQU     $3F   ;  Silence  :  Greetings to           -> Silence
_14            EQU     $3F   ;  Silence  :  AI,Sir Remix,          -> Silence
_15            EQU     $3F   ;  Silence  :  Rascal,Proffa,         -> Silence
_16            EQU     $3F   ;  Silence  :  Crescent,Dr.Dre,       -> Silence
_17            EQU     $3F   ;  Silence  :  Fysik,Mac,JL,          -> Silence
_18            EQU     $3F   ;  Silence  :  KML and White Angel.   -> Silence
; 
; Note mapping
G2_            EQU     $00
GS2            EQU     $01
A2_            EQU     $02
AS2            EQU     $03
B2_            EQU     $04
C3_            EQU     $05
CS3            EQU     $06
D3_            EQU     $07
DS3            EQU     $08
E3_            EQU     $09
F3_            EQU     $0A
FS3            EQU     $0B
G3_            EQU     $0C
GS3            EQU     $0D
A3_            EQU     $0E
AS3            EQU     $0F
B3_            EQU     $10
C4_            EQU     $11
CS4            EQU     $12
D4_            EQU     $13
DS4            EQU     $14
E4_            EQU     $15
F4_            EQU     $16
FS4            EQU     $17
G4_            EQU     $18
GS4            EQU     $19
A4_            EQU     $1A
AS4            EQU     $1B
B4_            EQU     $1C
C5_            EQU     $1D
CS5            EQU     $1E
D5_            EQU     $1F
DS5            EQU     $20
E5_            EQU     $21
F5_            EQU     $22
FS5            EQU     $23
G5_            EQU     $24
GS5            EQU     $25
A5_            EQU     $26
AS5            EQU     $27
B5_            EQU     $28
C6_            EQU     $29
CS6            EQU     $2A
D6_            EQU     $2B
DS6            EQU     $2C
E6_            EQU     $2D
F6_            EQU     $2E
FS6            EQU     $2F
G6_            EQU     $30
GS6            EQU     $31
A6_            EQU     $32
AS6            EQU     $33
B6_            EQU     $34
C7_            EQU     $35
CS7            EQU     $36
D7_            EQU     $37
DS7            EQU     $38
E7_            EQU     $39
F7_            EQU     $3A
FS7            EQU     $3B
G7_            EQU     $3C
GS7            EQU     $3D
A7_            EQU     $3E
AS7            EQU     $3F
; 
; Song values
songLength     EQU     $0D
loopPosition   EQU     $00

;   Pattern 
script:
  fdb pattern00
  fdb pattern01
  fdb pattern02
  fdb pattern03
  fdb pattern04
  fdb pattern05
  fdb pattern06
  fdb pattern07
  fdb pattern08
  fdb pattern08
  fdb pattern09
  fdb pattern0A
  fdb pattern0B

pattern00:
  fdb adsr
  fdb twang

  fcb C4_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $00
  fcb C4_      +CONT, C3_           ,                             SPEED ; $01
  fcb G3_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $02
  fcb G3_      +CONT, C4_           ,                             SPEED ; $03
  fcb DS3      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $04
  fcb G3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $05
  fcb DS3      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $06
  fcb C3_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $07
  fcb DS3      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $08
  fcb C3_      +CONT, C3_           ,                             SPEED ; $09
  fcb DS3      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $0A
  fcb C3_      +CONT, C4_           ,                             SPEED ; $0B
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $0C
  fcb C3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $0D
  fcb AS3      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $0E
  fcb C3_      +CONT, C3_           ,                             SPEED ; $0F
  fcb C4_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $10
  fcb C3_      +CONT, C3_           ,                             SPEED ; $11
  fcb G3_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $12
  fcb G3_      +CONT, C4_           ,                             SPEED ; $13
  fcb DS3      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $14
  fcb G3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $15
  fcb DS3      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $16
  fcb C3_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $17
  fcb DS3      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $18
  fcb C3_      +CONT, C3_           ,                             SPEED ; $19
  fcb DS3      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $1A
  fcb C3_      +CONT, C3_           ,                             SPEED ; $1B
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $1C
  fcb C3_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $1D
  fcb D4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $1E
  fcb C3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $1F
  fcb DS4      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $20
  fcb C3_      +CONT, C3_           ,                             SPEED ; $21
  fcb D4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $22
  fcb DS4      +CONT, C4_           ,                             SPEED ; $23
  fcb D4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $24
  fcb DS4      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $25
  fcb D4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $26
  fcb C4_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $27
  fcb D4_      +CONT, AS2      +CONT, _03+NOISE     ,             SPEED ; $28
  fcb C4_      +CONT, AS2           ,                             SPEED ; $29
  fcb C4_      +CONT, AS3      +CONT, _03+NOISE     ,             SPEED ; $2A
  fcb D4_      +CONT, AS2           ,                             SPEED ; $2B
  fcb C4_      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $2C
  fcb D4_      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $2D
  fcb C4_      +CONT, AS3      +CONT, _04+NOISE     ,             SPEED ; $2E
  fcb AS3      +CONT, AS3           ,                             SPEED ; $2F
  fcb C4_      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $30
  fcb AS3      +CONT, GS2           ,                             SPEED ; $31
  fcb AS3      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $32
  fcb GS3      +CONT, GS2           ,                             SPEED ; $33
  fcb AS3      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $34
  fcb GS3      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $35
  fcb AS3      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $36
  fcb AS3      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $37
  fcb C4_      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $38
  fcb AS3      +CONT, GS2           ,                             SPEED ; $39
  fcb C4_      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $3A
  fcb AS3      +CONT, GS2           ,                             SPEED ; $3B
  fcb C4_      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $3C
  fcb AS3      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $3D
  fcb AS3      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $3E
  fcb AS3      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $3F
 fcb $00, $80 ; end-marker

pattern01:
  fdb adsr
  fdb twang

  fcb C4_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $00
  fcb C4_      +CONT, C3_           ,                             SPEED ; $01
  fcb G3_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $02
  fcb G3_      +CONT, C4_           ,                             SPEED ; $03
  fcb DS3      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $04
  fcb G3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $05
  fcb DS3      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $06
  fcb C3_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $07
  fcb DS3      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $08
  fcb C3_      +CONT, C3_           ,                             SPEED ; $09
  fcb DS3      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $0A
  fcb C3_      +CONT, C4_           ,                             SPEED ; $0B
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $0C
  fcb C3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $0D
  fcb AS3      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $0E
  fcb C3_      +CONT, C3_           ,                             SPEED ; $0F
  fcb C4_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $10
  fcb C3_      +CONT, C3_           ,                             SPEED ; $11
  fcb G3_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $12
  fcb G3_      +CONT, C4_           ,                             SPEED ; $13
  fcb DS3      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $14
  fcb G3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $15
  fcb DS3      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $16
  fcb C3_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $17
  fcb DS3      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $18
  fcb C3_      +CONT, C3_           ,                             SPEED ; $19
  fcb DS3      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $1A
  fcb C3_      +CONT, C3_           ,                             SPEED ; $1B
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $1C
  fcb C3_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $1D
  fcb D4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $1E
  fcb C3_      +CONT, C3_           ,                             SPEED ; $1F
  fcb DS4      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $20
  fcb C3_      +CONT, C3_           ,                             SPEED ; $21
  fcb D4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $22
  fcb DS4      +CONT, C4_           ,                             SPEED ; $23
  fcb D4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $24
  fcb DS4      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $25
  fcb D4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $26
  fcb C4_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $27
  fcb D4_      +CONT, AS2      +CONT, _03+NOISE     ,             SPEED ; $28
  fcb C4_      +CONT, AS2           ,                             SPEED ; $29
  fcb C4_      +CONT, AS3      +CONT, _03+NOISE     ,             SPEED ; $2A
  fcb D4_      +CONT, AS2           ,                             SPEED ; $2B
  fcb C4_      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $2C
  fcb D4_      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $2D
  fcb C4_      +CONT, AS3      +CONT, _04+NOISE     ,             SPEED ; $2E
  fcb AS3      +CONT, AS3           ,                             SPEED ; $2F
  fcb C4_      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $30
  fcb AS3      +CONT, GS2           ,                             SPEED ; $31
  fcb AS3      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $32
  fcb C4_      +CONT, GS2           ,                             SPEED ; $33
  fcb AS3      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $34
  fcb C4_      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $35
  fcb AS3      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $36
  fcb D4_      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $37
  fcb DS4      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $38
  fcb D4_      +CONT, GS2           ,                             SPEED ; $39
  fcb DS4      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $3A
  fcb D4_      +CONT, GS2           ,                             SPEED ; $3B
  fcb G4_      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $3C
  fcb D4_      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $3D
  fcb F4_      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $3E
  fcb D4_      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $3F
 fcb $00, $80 ; end-marker

pattern02:
  fdb adsr
  fdb twang

  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $00
  fcb G4_      +CONT, DS3           ,                             SPEED ; $01
  fcb DS4      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $02
  fcb DS4      +CONT, DS4           ,                             SPEED ; $03
  fcb AS3      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $04
  fcb DS4      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $05
  fcb AS3      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $06
  fcb G3_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $07
  fcb AS3      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $08
  fcb G3_      +CONT, DS3           ,                             SPEED ; $09
  fcb AS3      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $0A
  fcb G3_      +CONT, DS4           ,                             SPEED ; $0B
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $0C
  fcb G3_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $0D
  fcb F4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $0E
  fcb G3_      +CONT, DS3           ,                             SPEED ; $0F
  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $10
  fcb G3_      +CONT, DS3           ,                             SPEED ; $11
  fcb DS4      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $12
  fcb DS4      +CONT, DS4           ,                             SPEED ; $13
  fcb AS3      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $14
  fcb DS4      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $15
  fcb AS3      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $16
  fcb G3_      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $17
  fcb AS3      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $18
  fcb G3_      +CONT, DS3           ,                             SPEED ; $19
  fcb AS3      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $1A
  fcb G3_      +CONT, DS3           ,                             SPEED ; $1B
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $1C
  fcb G3_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $1D
  fcb A4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $1E
  fcb G3_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $1F
  fcb AS4      +CONT, G3_      +CONT, _03+NOISE     ,             SPEED ; $20
  fcb G3_      +CONT, G3_           ,                             SPEED ; $21
  fcb A4_      +CONT, G4_      +CONT, _03+NOISE     ,             SPEED ; $22
  fcb AS4      +CONT, G4_           ,                             SPEED ; $23
  fcb A4_      +CONT, G3_      +CONT, _04+NOISE     ,             SPEED ; $24
  fcb AS4      +CONT, G3_      +CONT, _04+NOISE     ,             SPEED ; $25
  fcb A4_      +CONT, G4_      +CONT, _04+NOISE     ,             SPEED ; $26
  fcb G4_      +CONT, G3_      +CONT, _03+NOISE     ,             SPEED ; $27
  fcb A4_      +CONT, F3_      +CONT, _03+NOISE     ,             SPEED ; $28
  fcb G4_      +CONT, F3_           ,                             SPEED ; $29
  fcb G4_      +CONT, F4_      +CONT, _03+NOISE     ,             SPEED ; $2A
  fcb A4_      +CONT, F4_           ,                             SPEED ; $2B
  fcb G4_      +CONT, F3_      +CONT, _04+NOISE     ,             SPEED ; $2C
  fcb A4_      +CONT, F3_      +CONT, _04+NOISE     ,             SPEED ; $2D
  fcb G4_      +CONT, F4_      +CONT, _04+NOISE     ,             SPEED ; $2E
  fcb F4_      +CONT, F3_           ,                             SPEED ; $2F
  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $30
  fcb F4_      +CONT, DS3           ,                             SPEED ; $31
  fcb F4_      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $32
  fcb DS4      +CONT, DS4           ,                             SPEED ; $33
  fcb F4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $34
  fcb DS4      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $35
  fcb F4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $36
  fcb F4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $37
  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $38
  fcb F4_      +CONT, DS3           ,                             SPEED ; $39
  fcb G4_      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $3A
  fcb F4_      +CONT, DS4           ,                             SPEED ; $3B
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $3C
  fcb F4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $3D
  fcb F4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $3E
  fcb F4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $3F
 fcb $00, $80 ; end-marker

pattern03:
  fdb adsr
  fdb twang

  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $00
  fcb G4_      +CONT, DS3           ,                             SPEED ; $01
  fcb DS4      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $02
  fcb DS4      +CONT, DS4           ,                             SPEED ; $03
  fcb AS3      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $04
  fcb DS4      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $05
  fcb AS3      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $06
  fcb G3_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $07
  fcb AS3      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $08
  fcb G3_      +CONT, DS3           ,                             SPEED ; $09
  fcb AS3      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $0A
  fcb G3_      +CONT, DS4           ,                             SPEED ; $0B
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $0C
  fcb G3_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $0D
  fcb F4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $0E
  fcb G3_      +CONT, DS3           ,                             SPEED ; $0F
  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $10
  fcb G3_      +CONT, DS3           ,                             SPEED ; $11
  fcb DS4      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $12
  fcb DS4      +CONT, DS4           ,                             SPEED ; $13
  fcb AS3      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $14
  fcb DS4      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $15
  fcb AS3      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $16
  fcb G3_      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $17
  fcb AS3      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $18
  fcb G3_      +CONT, DS3           ,                             SPEED ; $19
  fcb AS3      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $1A
  fcb G3_      +CONT, DS3           ,                             SPEED ; $1B
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $1C
  fcb G3_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $1D
  fcb A4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $1E
  fcb G3_      +CONT, DS4           ,                             SPEED ; $1F
  fcb AS4      +CONT, G3_      +CONT, _03+NOISE     ,             SPEED ; $20
  fcb G3_      +CONT, G3_           ,                             SPEED ; $21
  fcb A4_      +CONT, G4_      +CONT, _03+NOISE     ,             SPEED ; $22
  fcb AS4      +CONT, G4_           ,                             SPEED ; $23
  fcb A4_      +CONT, G3_      +CONT, _04+NOISE     ,             SPEED ; $24
  fcb AS4      +CONT, G3_      +CONT, _04+NOISE     ,             SPEED ; $25
  fcb A4_      +CONT, G4_      +CONT, _04+NOISE     ,             SPEED ; $26
  fcb G4_      +CONT, G3_      +CONT, _03+NOISE     ,             SPEED ; $27
  fcb A4_      +CONT, F3_      +CONT, _03+NOISE     ,             SPEED ; $28
  fcb G4_      +CONT, F3_           ,                             SPEED ; $29
  fcb G4_      +CONT, F4_      +CONT, _03+NOISE     ,             SPEED ; $2A
  fcb A4_      +CONT, F4_           ,                             SPEED ; $2B
  fcb G4_      +CONT, F3_      +CONT, _04+NOISE     ,             SPEED ; $2C
  fcb A4_      +CONT, F3_      +CONT, _04+NOISE     ,             SPEED ; $2D
  fcb G4_      +CONT, F4_      +CONT, _04+NOISE     ,             SPEED ; $2E
  fcb F4_      +CONT, F3_           ,                             SPEED ; $2F
  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $30
  fcb F4_      +CONT, DS3           ,                             SPEED ; $31
  fcb F4_      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $32
  fcb DS4      +CONT, DS4           ,                             SPEED ; $33
  fcb F4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $34
  fcb DS4      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $35
  fcb F4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $36
  fcb F4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $37
  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $38
  fcb F4_      +CONT, DS3           ,                             SPEED ; $39
  fcb G4_      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $3A
  fcb F4_      +CONT, DS4           ,                             SPEED ; $3B
  fcb C4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $3C
  fcb F4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $3D
  fcb AS3      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $3E
  fcb F4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $3F
 fcb $00, $80 ; end-marker

pattern04:
  fdb adsr
  fdb twang

  fcb C4_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $00
  fcb C4_      +CONT, C3_           ,                             SPEED ; $01
  fcb G3_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $02
  fcb G3_      +CONT, C4_           ,                             SPEED ; $03
  fcb DS3      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $04
  fcb G3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $05
  fcb DS3      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $06
  fcb C3_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $07
  fcb DS3      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $08
  fcb C3_      +CONT, C3_           ,                             SPEED ; $09
  fcb DS3      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $0A
  fcb C3_      +CONT, C3_           ,                             SPEED ; $0B
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $0C
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $0D
  fcb AS3      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $0E
  fcb AS3      +CONT, C4_           ,                             SPEED ; $0F
  fcb C4_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $10
  fcb AS3      +CONT, C3_           ,                             SPEED ; $11
  fcb G3_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $12
  fcb G3_      +CONT, C4_           ,                             SPEED ; $13
  fcb DS3      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $14
  fcb G3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $15
  fcb DS3      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $16
  fcb C3_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $17
  fcb DS3      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $18
  fcb C3_      +CONT, C3_           ,                             SPEED ; $19
  fcb DS3      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $1A
  fcb C3_      +CONT, C3_           ,                             SPEED ; $1B
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $1C
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $1D
  fcb D4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $1E
  fcb D4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $1F
  fcb DS4      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $20
  fcb D4_      +CONT, C3_           ,                             SPEED ; $21
  fcb D4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $22
  fcb DS4      +CONT, C4_           ,                             SPEED ; $23
  fcb D4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $24
  fcb DS4      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $25
  fcb D4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $26
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $27
  fcb D4_      +CONT, AS2      +CONT, _03+NOISE     ,             SPEED ; $28
  fcb D4_      +CONT, AS2           ,                             SPEED ; $29
  fcb C4_      +CONT, AS3      +CONT, _03+NOISE     ,             SPEED ; $2A
  fcb D4_      +CONT, AS3           ,                             SPEED ; $2B
  fcb C4_      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $2C
  fcb D4_      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $2D
  fcb C4_      +CONT, AS3      +CONT, _04+NOISE     ,             SPEED ; $2E
  fcb AS3      +CONT, AS3           ,                             SPEED ; $2F
  fcb C4_      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $30
  fcb C4_      +CONT, GS2           ,                             SPEED ; $31
  fcb AS3      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $32
  fcb GS3      +CONT, GS3           ,                             SPEED ; $33
  fcb AS3      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $34
  fcb GS3      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $35
  fcb AS3      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $36
  fcb AS3      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $37
  fcb C4_      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $38
  fcb AS3      +CONT, GS2           ,                             SPEED ; $39
  fcb C4_      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $3A
  fcb AS3      +CONT, GS3           ,                             SPEED ; $3B
  fcb C4_      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $3C
  fcb C4_      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $3D
  fcb AS3      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $3E
  fcb AS3      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $3F
 fcb $00, $80 ; end-marker

pattern05:
  fdb adsr
  fdb twang

  fcb C4_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $00
  fcb C4_      +CONT, C3_           ,                             SPEED ; $01
  fcb G3_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $02
  fcb G3_      +CONT, C4_           ,                             SPEED ; $03
  fcb DS3      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $04
  fcb G3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $05
  fcb DS3      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $06
  fcb C3_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $07
  fcb DS3      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $08
  fcb C3_      +CONT, C3_           ,                             SPEED ; $09
  fcb DS3      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $0A
  fcb C3_      +CONT, C3_           ,                             SPEED ; $0B
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $0C
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $0D
  fcb AS3      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $0E
  fcb AS3      +CONT, C4_           ,                             SPEED ; $0F
  fcb C4_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $10
  fcb AS3      +CONT, C3_           ,                             SPEED ; $11
  fcb G3_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $12
  fcb G3_      +CONT, C4_           ,                             SPEED ; $13
  fcb DS3      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $14
  fcb G3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $15
  fcb DS3      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $16
  fcb C3_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $17
  fcb DS3      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $18
  fcb C3_      +CONT, C3_           ,                             SPEED ; $19
  fcb DS3      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $1A
  fcb C3_      +CONT, C3_           ,                             SPEED ; $1B
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $1C
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $1D
  fcb D4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $1E
  fcb D4_      +CONT, C4_           ,                             SPEED ; $1F
  fcb DS4      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $20
  fcb D4_      +CONT, C3_           ,                             SPEED ; $21
  fcb D4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $22
  fcb DS4      +CONT, C4_           ,                             SPEED ; $23
  fcb D4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $24
  fcb DS4      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $25
  fcb D4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $26
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $27
  fcb D4_      +CONT, AS2      +CONT, _03+NOISE     ,             SPEED ; $28
  fcb D4_      +CONT, AS2           ,                             SPEED ; $29
  fcb C4_      +CONT, AS3      +CONT, _03+NOISE     ,             SPEED ; $2A
  fcb D4_      +CONT, AS3           ,                             SPEED ; $2B
  fcb C4_      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $2C
  fcb D4_      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $2D
  fcb C4_      +CONT, AS3      +CONT, _04+NOISE     ,             SPEED ; $2E
  fcb AS3      +CONT, AS3           ,                             SPEED ; $2F
  fcb C4_      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $30
  fcb C4_      +CONT, GS2           ,                             SPEED ; $31
  fcb AS3      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $32
  fcb C4_      +CONT, GS3           ,                             SPEED ; $33
  fcb AS3      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $34
  fcb C4_      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $35
  fcb AS3      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $36
  fcb D4_      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $37
  fcb DS4      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $38
  fcb D4_      +CONT, GS2           ,                             SPEED ; $39
  fcb DS4      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $3A
  fcb D4_      +CONT, GS3           ,                             SPEED ; $3B
  fcb G4_      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $3C
  fcb G4_      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $3D
  fcb F4_      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $3E
  fcb F4_      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $3F
 fcb $00, $80 ; end-marker

pattern06:
  fdb adsr
  fdb twang

  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $00
  fcb G4_      +CONT, DS3           ,                             SPEED ; $01
  fcb DS4      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $02
  fcb DS4      +CONT, DS4           ,                             SPEED ; $03
  fcb AS3      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $04
  fcb DS4      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $05
  fcb AS3      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $06
  fcb G3_      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $07
  fcb AS3      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $08
  fcb G3_      +CONT, DS3           ,                             SPEED ; $09
  fcb AS3      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $0A
  fcb G3_      +CONT, DS4           ,                             SPEED ; $0B
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $0C
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $0D
  fcb F4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $0E
  fcb F4_      +CONT, DS3           ,                             SPEED ; $0F
  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $10
  fcb F4_      +CONT, DS3           ,                             SPEED ; $11
  fcb DS4      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $12
  fcb F4_      +CONT, DS4           ,                             SPEED ; $13
  fcb AS3      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $14
  fcb DS4      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $15
  fcb AS3      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $16
  fcb G3_      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $17
  fcb AS3      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $18
  fcb G3_      +CONT, DS3           ,                             SPEED ; $19
  fcb AS3      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $1A
  fcb G3_      +CONT, DS4           ,                             SPEED ; $1B
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $1C
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $1D
  fcb A4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $1E
  fcb A4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $1F
  fcb AS4      +CONT, G3_      +CONT, _03+NOISE     ,             SPEED ; $20
  fcb AS4      +CONT, G3_           ,                             SPEED ; $21
  fcb A4_      +CONT, G4_      +CONT, _03+NOISE     ,             SPEED ; $22
  fcb AS4      +CONT, G4_           ,                             SPEED ; $23
  fcb AS4      +CONT, G3_      +CONT, _04+NOISE     ,             SPEED ; $24
  fcb AS4      +CONT, G3_      +CONT, _04+NOISE     ,             SPEED ; $25
  fcb AS4      +CONT, G4_      +CONT, _04+NOISE     ,             SPEED ; $26
  fcb G4_      +CONT, G4_      +CONT, _03+NOISE     ,             SPEED ; $27
  fcb A4_      +CONT, F3_      +CONT, _03+NOISE     ,             SPEED ; $28
  fcb A4_      +CONT, F3_           ,                             SPEED ; $29
  fcb G4_      +CONT, F4_      +CONT, _03+NOISE     ,             SPEED ; $2A
  fcb A4_      +CONT, F4_           ,                             SPEED ; $2B
  fcb A4_      +CONT, F3_      +CONT, _04+NOISE     ,             SPEED ; $2C
  fcb A4_      +CONT, F3_      +CONT, _04+NOISE     ,             SPEED ; $2D
  fcb A4_      +CONT, F4_      +CONT, _04+NOISE     ,             SPEED ; $2E
  fcb F4_      +CONT, F4_           ,                             SPEED ; $2F
  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $30
  fcb G4_      +CONT, DS3           ,                             SPEED ; $31
  fcb F4_      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $32
  fcb DS4      +CONT, DS4           ,                             SPEED ; $33
  fcb F4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $34
  fcb DS4      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $35
  fcb F4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $36
  fcb F4_      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $37
  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $38
  fcb F4_      +CONT, DS3           ,                             SPEED ; $39
  fcb G4_      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $3A
  fcb F4_      +CONT, DS4           ,                             SPEED ; $3B
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $3C
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $3D
  fcb F4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $3E
  fcb F4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $3F
 fcb $00, $80 ; end-marker

pattern07:
  fdb adsr
  fdb twang

  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $00
  fcb G4_      +CONT, DS3           ,                             SPEED ; $01
  fcb DS4      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $02
  fcb DS4      +CONT, DS4           ,                             SPEED ; $03
  fcb AS3      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $04
  fcb DS4      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $05
  fcb AS3      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $06
  fcb G3_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $07
  fcb AS3      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $08
  fcb G3_      +CONT, DS3           ,                             SPEED ; $09
  fcb AS3      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $0A
  fcb G3_      +CONT, DS4           ,                             SPEED ; $0B
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $0C
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $0D
  fcb F4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $0E
  fcb F4_      +CONT, DS3           ,                             SPEED ; $0F
  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $10
  fcb F4_      +CONT, DS3           ,                             SPEED ; $11
  fcb DS4      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $12
  fcb F4_      +CONT, DS4           ,                             SPEED ; $13
  fcb AS3      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $14
  fcb DS4      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $15
  fcb AS3      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $16
  fcb G3_      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $17
  fcb AS3      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $18
  fcb G3_      +CONT, DS3           ,                             SPEED ; $19
  fcb AS3      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $1A
  fcb G3_      +CONT, DS3           ,                             SPEED ; $1B
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $1C
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $1D
  fcb A4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $1E
  fcb A4_      +CONT, DS4           ,                             SPEED ; $1F
  fcb AS4      +CONT, G3_      +CONT, _03+NOISE     ,             SPEED ; $20
  fcb A4_      +CONT, G3_           ,                             SPEED ; $21
  fcb A4_      +CONT, G4_      +CONT, _03+NOISE     ,             SPEED ; $22
  fcb AS4      +CONT, G4_           ,                             SPEED ; $23
  fcb A4_      +CONT, G3_      +CONT, _04+NOISE     ,             SPEED ; $24
  fcb AS4      +CONT, G3_      +CONT, _04+NOISE     ,             SPEED ; $25
  fcb A4_      +CONT, G4_      +CONT, _04+NOISE     ,             SPEED ; $26
  fcb G4_      +CONT, G3_      +CONT, _03+NOISE     ,             SPEED ; $27
  fcb A4_      +CONT, F3_      +CONT, _03+NOISE     ,             SPEED ; $28
  fcb A4_      +CONT, F3_           ,                             SPEED ; $29
  fcb G4_      +CONT, F4_      +CONT, _03+NOISE     ,             SPEED ; $2A
  fcb A4_      +CONT, F4_           ,                             SPEED ; $2B
  fcb G4_      +CONT, F3_      +CONT, _04+NOISE     ,             SPEED ; $2C
  fcb A4_      +CONT, F3_      +CONT, _04+NOISE     ,             SPEED ; $2D
  fcb G4_      +CONT, F4_      +CONT, _04+NOISE     ,             SPEED ; $2E
  fcb F4_      +CONT, F3_           ,                             SPEED ; $2F
  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $30
  fcb G4_      +CONT, DS3           ,                             SPEED ; $31
  fcb F4_      +CONT, DS4      +CONT, _03+NOISE     ,             SPEED ; $32
  fcb DS4      +CONT, DS4           ,                             SPEED ; $33
  fcb F4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $34
  fcb DS4      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $35
  fcb F4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $36
  fcb F4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $37
  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $38
  fcb F4_      +CONT, DS4           ,                             SPEED ; $39
  fcb G4_      +CONT, DS3      +CONT, _03+NOISE     ,             SPEED ; $3A
  fcb F4_      +CONT, DS3           ,                             SPEED ; $3B
  fcb G4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $3C
  fcb F4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $3D
  fcb G4_      +CONT, DS3      +CONT, _04+NOISE     ,             SPEED ; $3E
  fcb F4_      +CONT, DS4      +CONT, _04+NOISE     ,             SPEED ; $3F
 fcb $00, $80 ; end-marker

pattern08:
  fdb adsr
  fdb twang

  fcb                 C3_      +CONT, _03+NOISE     ,             SPEED ; $00
  fcb                 C3_           ,                             SPEED ; $01
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $02
  fcb                 C4_           ,                             SPEED ; $03
  fcb                 C3_      +CONT, _04+NOISE     ,             SPEED ; $04
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $05
  fcb                 C4_      +CONT, _04+NOISE     ,             SPEED ; $06
  fcb                 C4_      +CONT, _03+NOISE     ,             SPEED ; $07
  fcb C4_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $08
  fcb                 C3_           ,                             SPEED ; $09
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $0A
  fcb                 C3_           ,                             SPEED ; $0B
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $0C
  fcb                 C3_      +CONT, _04+NOISE     ,             SPEED ; $0D
  fcb C4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $0E
  fcb C4_      +CONT, C4_           ,                             SPEED ; $0F
  fcb                 C3_      +CONT, _03+NOISE     ,             SPEED ; $10
  fcb C4_      +CONT, C3_           ,                             SPEED ; $11
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $12
  fcb                 C4_           ,                             SPEED ; $13
  fcb                 C3_      +CONT, _04+NOISE     ,             SPEED ; $14
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $15
  fcb                 C4_      +CONT, _04+NOISE     ,             SPEED ; $16
  fcb                 C4_      +CONT, _03+NOISE     ,             SPEED ; $17
  fcb C4_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $18
  fcb                 C3_           ,                             SPEED ; $19
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $1A
  fcb                 C3_           ,                             SPEED ; $1B
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $1C
  fcb                 C3_      +CONT, _04+NOISE     ,             SPEED ; $1D
  fcb C4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $1E
  fcb C4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $1F
  fcb AS2      +CONT, AS2      +CONT, _03+NOISE     ,             SPEED ; $20
  fcb AS2      +CONT, AS2           ,                             SPEED ; $21
  fcb AS3      +CONT, AS3      +CONT, _03+NOISE     ,             SPEED ; $22
  fcb                 AS3           ,                             SPEED ; $23
  fcb                 AS2      +CONT, _04+NOISE     ,             SPEED ; $24
  fcb AS3      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $25
  fcb                 AS3      +CONT, _04+NOISE     ,             SPEED ; $26
  fcb                 AS3      +CONT, _03+NOISE     ,             SPEED ; $27
  fcb GS2      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $28
  fcb                 GS2           ,                             SPEED ; $29
  fcb GS3      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $2A
  fcb                 GS3           ,                             SPEED ; $2B
  fcb GS2      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $2C
  fcb                 GS2      +CONT, _04+NOISE     ,             SPEED ; $2D
  fcb GS3      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $2E
  fcb GS2      +CONT, GS2           ,                             SPEED ; $2F
  fcb                 C3_      +CONT, _03+NOISE     ,             SPEED ; $30
  fcb                 C3_           ,                             SPEED ; $31
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $32
  fcb                 C4_           ,                             SPEED ; $33
  fcb                 C3_      +CONT, _04+NOISE     ,             SPEED ; $34
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $35
  fcb                 C4_      +CONT, _04+NOISE     ,             SPEED ; $36
  fcb                 C4_      +CONT, _03+NOISE     ,             SPEED ; $37
  fcb C4_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $38
  fcb                 C3_           ,                             SPEED ; $39
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $3A
  fcb                 C3_           ,                             SPEED ; $3B
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $3C
  fcb C4_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $3D
  fcb                 C4_      +CONT, _04+NOISE     ,             SPEED ; $3E
  fcb C4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $3F
 fcb $00, $80 ; end-marker

pattern09:
  fdb adsr
  fdb twang

  fcb C3_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $00
  fcb C3_      +CONT, C3_           ,                             SPEED ; $01
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $02
  fcb                 C4_           ,                             SPEED ; $03
  fcb C3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $04
  fcb C3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $05
  fcb C4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $06
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $07
  fcb C3_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $08
  fcb C3_      +CONT, C3_           ,                             SPEED ; $09
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $0A
  fcb                 C3_           ,                             SPEED ; $0B
  fcb C3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $0C
  fcb                 C3_      +CONT, _04+NOISE     ,             SPEED ; $0D
  fcb C4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $0E
  fcb                 C4_           ,                             SPEED ; $0F
  fcb AS2      +CONT, AS2      +CONT, _03+NOISE     ,             SPEED ; $10
  fcb AS2      +CONT, AS2           ,                             SPEED ; $11
  fcb AS3      +CONT, AS3      +CONT, _03+NOISE     ,             SPEED ; $12
  fcb                 AS3           ,                             SPEED ; $13
  fcb AS2      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $14
  fcb                 AS2      +CONT, _04+NOISE     ,             SPEED ; $15
  fcb AS3      +CONT, AS3      +CONT, _04+NOISE     ,             SPEED ; $16
  fcb                 AS3      +CONT, _03+NOISE     ,             SPEED ; $17
  fcb AS2      +CONT, AS2      +CONT, _03+NOISE     ,             SPEED ; $18
  fcb AS2      +CONT, AS2           ,                             SPEED ; $19
  fcb AS3      +CONT, AS3      +CONT, _03+NOISE     ,             SPEED ; $1A
  fcb                 AS3           ,                             SPEED ; $1B
  fcb AS2      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $1C
  fcb                 AS2      +CONT, _04+NOISE     ,             SPEED ; $1D
  fcb AS3      +CONT, AS3      +CONT, _04+NOISE     ,             SPEED ; $1E
  fcb                 AS3           ,                             SPEED ; $1F
  fcb GS2      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $20
  fcb GS2      +CONT, GS3           ,                             SPEED ; $21
  fcb GS3      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $22
  fcb                 GS2           ,                             SPEED ; $23
  fcb GS2      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $24
  fcb                 GS3      +CONT, _04+NOISE     ,             SPEED ; $25
  fcb GS3      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $26
  fcb                 GS2      +CONT, _03+NOISE     ,             SPEED ; $27
  fcb GS2      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $28
  fcb GS2      +CONT, GS3           ,                             SPEED ; $29
  fcb GS3      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $2A
  fcb                 GS2           ,                             SPEED ; $2B
  fcb GS2      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $2C
  fcb                 GS3      +CONT, _04+NOISE     ,             SPEED ; $2D
  fcb GS3      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $2E
  fcb                 GS2           ,                             SPEED ; $2F
  fcb F4_      +CONT, F4_      +CONT, _03+NOISE     ,             SPEED ; $30
  fcb F4_      +CONT, F3_           ,                             SPEED ; $31
  fcb F3_      +CONT, F3_      +CONT, _03+NOISE     ,             SPEED ; $32
  fcb                 F4_           ,                             SPEED ; $33
  fcb F4_      +CONT, F4_      +CONT, _04+NOISE     ,             SPEED ; $34
  fcb                 F3_      +CONT, _04+NOISE     ,             SPEED ; $35
  fcb F3_      +CONT, F4_      +CONT, _04+NOISE     ,             SPEED ; $36
  fcb                 F4_      +CONT, _03+NOISE     ,             SPEED ; $37
  fcb F4_      +CONT, F4_      +CONT, _03+NOISE     ,             SPEED ; $38
  fcb F4_      +CONT, F3_           ,                             SPEED ; $39
  fcb F3_      +CONT, F4_      +CONT, _03+NOISE     ,             SPEED ; $3A
  fcb                 F3_           ,                             SPEED ; $3B
  fcb F4_      +CONT, F3_      +CONT, _04+NOISE     ,             SPEED ; $3C
  fcb                 G2_      +CONT, _04+NOISE     ,             SPEED ; $3D
  fcb G2_      +CONT, G2_      +CONT, _04+NOISE     ,             SPEED ; $3E
  fcb G3_      +CONT, G3_      +CONT, _04+NOISE     ,             SPEED ; $3F
 fcb $00, $80 ; end-marker

pattern0A:
  fdb adsr
  fdb twang

  fcb C3_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $00
  fcb C3_      +CONT, C3_           ,                             SPEED ; $01
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $02
  fcb C4_      +CONT, C4_           ,                             SPEED ; $03
  fcb C3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $04
  fcb C3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $05
  fcb C4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $06
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $07
  fcb C3_      +CONT, C3_      +CONT, _03+NOISE     ,             SPEED ; $08
  fcb C3_      +CONT, C3_           ,                             SPEED ; $09
  fcb C4_      +CONT, C4_      +CONT, _03+NOISE     ,             SPEED ; $0A
  fcb C4_      +CONT, C3_           ,                             SPEED ; $0B
  fcb C3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $0C
  fcb C3_      +CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $0D
  fcb C4_      +CONT, C4_      +CONT, _04+NOISE     ,             SPEED ; $0E
  fcb C4_      +CONT, C4_           ,                             SPEED ; $0F
  fcb AS2      +CONT, AS2      +CONT, _03+NOISE     ,             SPEED ; $10
  fcb AS2      +CONT, AS2           ,                             SPEED ; $11
  fcb AS3      +CONT, AS3      +CONT, _03+NOISE     ,             SPEED ; $12
  fcb AS3      +CONT, AS3           ,                             SPEED ; $13
  fcb AS2      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $14
  fcb AS2      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $15
  fcb AS3      +CONT, AS3      +CONT, _04+NOISE     ,             SPEED ; $16
  fcb AS3      +CONT, AS3      +CONT, _03+NOISE     ,             SPEED ; $17
  fcb AS2      +CONT, AS2      +CONT, _03+NOISE     ,             SPEED ; $18
  fcb AS2      +CONT, AS2           ,                             SPEED ; $19
  fcb AS3      +CONT, AS3      +CONT, _03+NOISE     ,             SPEED ; $1A
  fcb AS3      +CONT, AS3           ,                             SPEED ; $1B
  fcb AS2      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $1C
  fcb AS2      +CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $1D
  fcb AS3      +CONT, AS3      +CONT, _04+NOISE     ,             SPEED ; $1E
  fcb AS3      +CONT, AS3      +CONT, _04+NOISE     ,             SPEED ; $1F
  fcb GS2      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $20
  fcb GS2      +CONT, GS3           ,                             SPEED ; $21
  fcb GS3      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $22
  fcb GS3      +CONT, GS2           ,                             SPEED ; $23
  fcb GS2      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $24
  fcb GS2      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $25
  fcb GS3      +CONT, GS2      +CONT, _04+NOISE     ,             SPEED ; $26
  fcb GS3      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $27
  fcb GS2      +CONT, GS2      +CONT, _03+NOISE     ,             SPEED ; $28
  fcb GS2      +CONT, GS3           ,                             SPEED ; $29
  fcb GS3      +CONT, GS3      +CONT, _03+NOISE     ,             SPEED ; $2A
  fcb GS3      +CONT, GS2           ,                             SPEED ; $2B
  fcb GS2      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $2C
  fcb GS2      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $2D
  fcb GS3      +CONT, GS3      +CONT, _04+NOISE     ,             SPEED ; $2E
  fcb GS3      +CONT, GS2           ,                             SPEED ; $2F
  fcb SIL,                                                        SPEED ; $30
  fcb SIL,                                                        SPEED ; $31
  fcb SIL,                                                        SPEED ; $32
  fcb SIL,                                                        SPEED ; $33
  fcb SIL,                                                        SPEED ; $34
  fcb SIL,                                                        SPEED ; $35
  fcb SIL,                                                        SPEED ; $36
  fcb SIL,                                                        SPEED ; $37
  fcb SIL,                                                        SPEED ; $38
  fcb SIL,                                                        SPEED ; $39
  fcb SIL,                                                        SPEED ; $3A
  fcb SIL,                                                        SPEED ; $3B
  fcb SIL,                                                        SPEED ; $3C
  fcb SIL,                                                        SPEED ; $3D
  fcb SIL,                                                        SPEED ; $3E
  fcb SIL,                                                        SPEED ; $3F
 fcb $00, $80 ; end-marker

pattern0B:
  fdb adsr
  fdb twang

  fcb _04+NOISE+CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $00
  fcb _04+NOISE+CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $01
  fcb                 C3_           ,                             SPEED ; $02
  fcb _04+NOISE+CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $03
  fcb _04+NOISE+CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $04
  fcb                 C3_           ,                             SPEED ; $05
  fcb _04+NOISE+CONT, AS2      +CONT, _04+NOISE     ,             SPEED ; $06
  fcb                 AS2           ,                             SPEED ; $07
  fcb _04+NOISE+CONT, C3_      +CONT, _04+NOISE     ,             SPEED ; $08
  fcb                 C3_      +CONT, _04+NOISE     ,             SPEED ; $09
  fcb                 C3_      +CONT, _04+NOISE     ,             SPEED ; $0A
  fcb                 C3_      +CONT, _04+NOISE     ,             SPEED ; $0B
  fcb                 C3_      +CONT, _04+NOISE     ,             SPEED ; $0C
  fcb                 C3_      +CONT, _04+NOISE     ,             SPEED ; $0D
  fcb                                 _04+NOISE     ,             SPEED ; $0E
  fcb                                 _04+NOISE     ,             SPEED ; $0F
  fcb SIL,                                                        SPEED ; $10
  fcb SIL,                                                        SPEED ; $11
  fcb SIL,                                                        SPEED ; $12
  fcb SIL,                                                        SPEED ; $13
  fcb SIL,                                                        SPEED ; $14
  fcb SIL,                                                        SPEED ; $15
  fcb SIL,                                                        SPEED ; $16
  fcb SIL,                                                        SPEED ; $17
  fcb SIL,                                                        SPEED ; $18
  fcb SIL,                                                        SPEED ; $19
  fcb SIL,                                                        SPEED ; $1A
  fcb SIL,                                                        SPEED ; $1B
  fcb SIL,                                                        SPEED ; $1C
  fcb SIL,                                                        SPEED ; $1D
  fcb SIL,                                                        SPEED ; $1E
  fcb SIL,                                                        SPEED ; $1F
  fcb SIL,                                                        SPEED ; $20
  fcb SIL,                                                        SPEED ; $21
  fcb SIL,                                                        SPEED ; $22
  fcb SIL,                                                        SPEED ; $23
  fcb SIL,                                                        SPEED ; $24
  fcb SIL,                                                        SPEED ; $25
  fcb SIL,                                                        SPEED ; $26
  fcb SIL,                                                        SPEED ; $27
  fcb SIL,                                                        SPEED ; $28
  fcb SIL,                                                        SPEED ; $29
  fcb SIL,                                                        SPEED ; $2A
  fcb SIL,                                                        SPEED ; $2B
  fcb SIL,                                                        SPEED ; $2C
  fcb SIL,                                                        SPEED ; $2D
  fcb SIL,                                                        SPEED ; $2E
  fcb SIL,                                                        SPEED ; $2F
  fcb SIL,                                                        SPEED ; $30
  fcb SIL,                                                        SPEED ; $31
  fcb SIL,                                                        SPEED ; $32
  fcb SIL,                                                        SPEED ; $33
  fcb SIL,                                                        SPEED ; $34
  fcb SIL,                                                        SPEED ; $35
  fcb SIL,                                                        SPEED ; $36
  fcb SIL,                                                        SPEED ; $37
  fcb SIL,                                                        SPEED ; $38
  fcb SIL,                                                        SPEED ; $39
  fcb SIL,                                                        SPEED ; $3A
  fcb SIL,                                                        SPEED ; $3B
  fcb SIL,                                                        SPEED ; $3C
  fcb SIL,                                                        SPEED ; $3D
  fcb SIL,                                                        SPEED ; $3E
  fcb SIL,                                                        SPEED ; $3F
 fcb $00, $80 ; end-marker

