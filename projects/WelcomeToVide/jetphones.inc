; /* vim: set filetype=dasm: */

; jetphones.inc

; V0.9: B. Watson 20060621

; Useful constants for developing AtariVox applications with DASM.

; This is basically a DASM-readable version of pages 15 and 16 of the
; SpeakJet manual. The phoneme names were taken straight from the manual.

; The pause and control code names were assigned by me, but they're
; pretty obvious. Also, I'm adding descriptive aliases for the non-speech
; noises (e.g. SHOT = M1 (the "Pistol Shot").

; See "phrases.inc" for example usage.

; Phonemes/allophones:
IY     equ  128 ; See, Even, Feed
IH     equ  129 ; Sit, Fix, Pin
EY     equ  130 ; Hair, Gate, Beige
EH     equ  131 ; Met, Check, Red
AY     equ  132 ; Hat, Fast, Fan
AX     equ  133 ; Cotten
UX     equ  134 ; Luck, Up, Uncle
OH     equ  135 ; Hot, Clock, Fox
AW     equ  136 ; Father, Fall
OW     equ  137 ; Comb, Over, Hold
UH     equ  138 ; Book, Could, Should
UW     equ  139 ; Food, June
MM     equ  140 ; Milk, Famous,
NE     equ  141 ; Nip, Danger, Thin
NO     equ  142 ; No, Snow, On
NGE    equ  143 ; Think, Ping
NGO    equ  144 ; Hung, Song
LE     equ  145 ; Lake, Alarm, Lapel
LO     equ  146 ; Clock, Plus, Hello
WW     equ  147 ; Wool, Sweat
RR     equ  148 ; Ray, Brain, Over
IYRR   equ  149 ; Clear, Hear, Year
EYRR   equ  150 ; Hair, Stair, Repair
AXRR   equ  151 ; Fir, Bird, Burn
AWRR   equ  152 ; Part, Farm, Yarn
OWRR   equ  153 ; Corn, Four, Your
EYIY   equ  154 ; Gate, Ate, Ray
OHIY   equ  155 ; Mice, Fight, White
OWIY   equ  156 ; Boy, Toy, Voice
OHIH   equ  157 ; Sky, Five, I
IYEH   equ  158 ; Yes, Yarn, Million
EHLL   equ  159 ; Saddle, Angle, Spell
IYUW   equ  160 ; Cute, Few,
AXUW   equ  161 ; Brown, Clown, Thousan
IHWW   equ  162 ; Two, New, Zoo
AYWW   equ  163 ; Our, Ouch, Owl
OWWW   equ  164 ; Go, Hello, Snow
JH     equ  165 ; Dodge, Jet, Savage
VV     equ  166 ; Vest, Even,
ZZ     equ  167 ; Zoo, Zap
ZH     equ  168 ; Azure, Treasure
DH     equ  169 ; There, That, This
BE     equ  170 ; Bear, Bird, Beed
BO     equ  171 ; Bone, Book Brown
EB     equ  172 ; Cab, Crib, Web
OB     equ  173 ; Bob, Sub, Tub
DE     equ  174 ; Deep, Date, Divide
DO     equ  175 ; Do, Dust, Dog
ED     equ  176 ; Could, Bird
OD     equ  177 ; Bud, Food
GE     equ  178 ; Get, Gate, Guest,
GO     equ  179 ; Got, Glue, Goo
EG     equ  180 ; Peg, Wig
OG     equ  181 ; Dog, Peg
CH     equ  182 ; Church, Feature, March
HE     equ  183 ; Help, Hand, Hair
HO     equ  184 ; Hoe, Hot, Hug
WH     equ  185 ; Who, Whale, White
FF     equ  186 ; Food, Effort, Off
SE     equ  187 ; See, Vest, Plus
SO     equ  188 ; So, Sweat
SH     equ  189 ; Ship, Fiction, Leash
TH     equ  190 ; Thin, month
TT     equ  191 ; Part, Little, Sit
TU     equ  192 ; To, Talk, Ten
TS     equ  193 ; Parts, Costs, Robots
KE     equ  194 ; Can't, Clown, Key
KO     equ  195 ; Comb, Quick, Fox
EK     equ  196 ; Speak, Task
OK     equ  197 ; Book, Took, October
PE     equ  198 ; People, Computer
PO     equ  199 ; Paw, Copy

; Various noises, non-speech:

; R0-R9: Robot
; R0 - R9 make up a musical scale of sorts.
; None of these are affected by the PITCH command,
; though they are affected by SPEED and BEND.
R0     equ  200 ;
R1     equ  201 ;
R2     equ  202 ;
R3     equ  203 ;
R4     equ  204 ;
R5     equ  205 ;
R6     equ  206 ;
R7     equ  207 ;
R8     equ  208 ;
R9     equ  209 ;

; I can't come up with good descriptions for 235 or 237, try them yourself
; Only those marked with [*] are affected by the PITCH command.
; The manual lists these as:
; A0-A9: Alarm
; B0-B9: Beeps
; C0-C9: Biological
; M0-M2: Miscellaneous
A0     equ  210 ; Sounds a bit like the Jungle Hunt rope noise
A1     equ  211 ; Rising "Giggle Stick" (remember the Giggle Stick?)
A2     equ  212 ; Falling "Giggle Stick"
A3     equ  213 ; Rising "Giggle Stick" (higher)
A4     equ  214 ; Rising sweep
A5     equ  215 ; Siren (fall, then rise)
A6     equ  216 ; Fast rising siren
A7     equ  217 ; Slow rising siren
A8     equ  218 ; Whoot-wheet
A9     equ  219 ; High-pitched falling siren
B0     equ  220 ; High beep
B1     equ  221 ; R2D2 falling
B2     equ  222 ; R2D2 talking 1
B3     equ  223 ; R2D2 talking 2
B4     equ  224 ; AM radio tuning (long)
B5     equ  225 ; AM radio tuning (short)
B6     equ  226 ; Bleep (sci-fi button press)
B7     equ  227 ; 2-tone
B8     equ  228 ; Air leaking from a balloon
B9     equ  229 ; Sci-fi "computing" noise
C0     equ  230 ; Laser gun [*]
C1     equ  231 ; Sound like "Cry"
C2     equ  232 ; Sounds like "Words" [*]
C3     equ  233 ; Cricket [*]
C4     equ  234 ; Oui [*]
C5     equ  235 ;
C6     equ  236 ; "Yoink" [*]
C7     equ  237 ;
C8     equ  238 ; R2D2 raspberry
C9     equ  239 ; R2D2 chirp
M0     equ  252 ; Sonar Ping
M1     equ  253 ; Pistol Shot (actually, sounds more like a snare drum)
M2     equ  254 ; WOW [*]

; Convenient names for some of the weird noises:
PING equ M0
SHOT equ M1
WOW equ M2

; DTMF (Touch tone) phone tones:
D0     equ  240 ; 0
D1     equ  241 ; 1
D2     equ  242 ; 2
D3     equ  243 ; 3
D4     equ  244 ; 4
D5     equ  245 ; 5
D6     equ  246 ; 6
D7     equ  247 ; 7
D8     equ  248 ; 8
D9     equ  249 ; 9
D10    equ  250 ; *
D11    equ  251 ; #

; Pauses of various durations:
PAUSE0   equ    0 ; Pause 0 (0ms, the SpeakJet equivalent of NOP?)
PAUSE1   equ    1 ; Pause 1 (100ms, don't wait for silence)
PAUSE2   equ    2 ; Pause 2 (200ms, don't wait for silence)
PAUSE3   equ    3 ; Pause 3 (700ms, don't wait for silence)
PAUSE4   equ    4 ; Pause 4 (30ms, wait for silence)
PAUSE5   equ    5 ; Pause 5 (60ms, wait for silence)
PAUSE6   equ    6 ; Pause 6 (90ms, wait for silence)

; Control codes:
EOP    equ  255 ; End of Phrase
END    equ  EOP

FAST   equ    7 ; Play Next Sound Fast
SLOW   equ    8 ; Play Next Sound Slow

STRESS equ   14 ; Play Next Sound High Tone
RELAX  equ   15 ; Play Next Sound Low Tone

WAIT   equ   16 ; Wait

; These need a parameter equ  (X) to follow them:
VOLUME equ   20 ; Volume, X = 0-127, default 96
SPEED  equ   21 ; Speed,  X = 0-127, default 114
PITCH  equ   22 ; Pitch,  X = 0-255 (in Hz), default 88
BEND   equ   23 ; Bend,   X = 0-15, default 5
RPT    equ   26 ; Repeat, X = 0-255 (# of times to repeat next code)
DELAY  equ   30 ; Delay,  X = 0-255 (in 10ms intervals)

RESET  equ   31 ; Reset Defaults for Volume, Speed, Pitch, Bend

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The rest of this file was copied and pasted from speakjetmanual.pdf.
; I didn't bother to format it nicely :)

; 24  PortCtr, X
; 25  Port, X
; 26  Repeat, X
; 28  Call Phrase, X
; 29  Goto Phrase, X
; Control Codes Details:
;      0 - 6 = Pauses.
; Pauses of various durations, these will cause the volume to ramp down, wait a specified
; amount of time and the ramp back up.  1, 2 & 3, ramp the volume while the format
; frequencies are being changed. 4, 5 & 6 wait for silence before changing the format
; frequencies.
;  0 = 0ms   1 = 100ms   2 = 200ms  3 = 700ms
;  4 = 30ms    5 = 60ms   6 = 90ms
;  7 = Fast.
; Plays the next phoneme at 1/2 the time it normally would play.
;      8 = Slow
; Plays the next phoneme at 1 and 1/2 the time it normally would play.
;      14 = Stress.
; Plays the next phoneme with a small amount of stress in the voice.
;      15 = Relax
; Plays the next phoneme with a small amount of relaxation in the voice.
;  16 = Wait
; This command will stop the voicing and wait for a start command.  The Start command
; can be issued by either sending the SCP start command or by changing the state of one
; of the input lines that has been previously set to do a Start.
;  20 = Volume, X
; This command sets the master volume level.  A value will need to be sent after the
; volume command that specifies the desired volume. Volume levels can range from 0 to
; 127.  The default is 96.
;  21 = Speed, X
; This command sets the play speed.  A value will need to be sent after the speed
; command that specifies the desired speed.  Speeds can range from 0 to 127. The
; default is 114.
;  22 = Pitch, X
; This command sets the Vocalization Pitch in Hertz.  A value will need to be sent after
; the pitch command that specifies the desired pitch. The vocalization pitch is what makes
; a voice sound High pitched or Low pitched.  For singing, the pitch has a range of 3 full
; octaves (32Hz to 240hz).  The Vocalization Pitch works only on sounds that are voiced.
; Pitches can range from 0 to 255.  The default is 88. Note that anything under 30 starts
; to sound like clicks instead of a voice.  Also Note that a value of 0 = 0 Hz and thusly, will
; not actually vocalize.
;
; 23 = Bend, X
; This command sets the frequency Bend.  A value will need to be sent after the Bend
; command that specifies the desired Bend. The frequency Bend adjusts the output
; frequencies of the oscillators. This will change the voicing from a deep-hollow sounding
; voice to a High-metallic sounding voice. Bends can range from 0 to 15.  The default is 5.
;      24 = PortCtr, X
; This command sets the Port Control Value.  A value will need to be sent after the
; PortCtr command that specifies the desired function of the output lines.  The Output line
; control bits are binaurally encoded where a 1 indicates that the output function is chip
; controlled and a 0 indicates that the output function is user controlled. Bit 0 corresponds
; to OUT0, etc... PortCtr values can range from 0 to 7.  The default is 7.
;  25 = Port, X
; This command sets the Port Output Value.  A value will need to be sent after the Port
; command that specifies the desired state of the output lines. When the Output line
; control bits are set to 0, the corresponding port bit is represented on the output line. Bit
; 0 corresponds to OUT0, etc... Port values can range from 0 to 7.  The default is 0.
;  26 = Repeat, X
; This command sets a number of times to Repeat the next code.  A value will need to be
; sent after the Repeat command that specifies the number of times to repeat the next
; command.
; The Repeat range is from 0 to 255.
;  28 = Call Phrase, X
; This command specifies which EEPROM phrase to play then to return from.
; This can be nested 3 deep maximum.
;  29 = Goto Phrase, X
; This command specifies which EEPROM phrase to play.
;  30 = Delay, X
; This command specifies the number of 10ms intervals to delay before continuing
; on to the next code. The Delay range is from 0 to 255.
;  31 = Reset
; This command resets the Volume, Speed, Pitch and Bend to the default values.
;
;
