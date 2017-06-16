;***************************************************************************
; DATA SECTION
;***************************************************************************
; VLMode Lists
enemyXList: 
                    DB       $00, +$3F, -$3F              ; mode, y, x 
                    DB       $ff, -$7E, +$7E              ; mode, y, x 
                    DB       $00, +$00, -$7E              ; mode, y, x 
                    DB       $ff, +$7E, +$7E              ; mode, y, x 
                    DB       $01                          ; endmarker (1) 

score10:
 DB $00, +$3F, 0              ; mode, y, x 
 DB $ff, +$00, +$3F ; mode, y, x
 DB $ff, -$7E, +$00 ; mode, y, x
 DB $ff, +$00, -$3F ; mode, y, x
 DB $ff, +$7E, +$00 ; mode, y, x
 DB $00, +$00, -$3F ; mode, y, x
 DB $ff, -$7E, +$00 ; mode, y, x
 DB $01 ; endmarker (1)

NumberList:
 DW NumberList_0 ; list of all single vectorlists in this
 DW NumberList_1
 DW NumberList_2
 DW NumberList_3
 DW NumberList_4
 DW NumberList_5
 DW NumberList_6
 DW NumberList_7
 DW NumberList_8
 DW NumberList_9
NumberList_0:
 DB $ff, +$00, +$4C ; mode, y, x
 DB $ff, +$65, +$00 ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $ff, -$65, +$00 ; mode, y, x
 DB $00, +$00, +$7F ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_1:
 DB $00, +$00, +$4C ; mode, y, x
 DB $ff, +$65, +$00 ; mode, y, x
 DB $00, -$65, +$33 ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_2:
 DB $00, +$65, +$00 ; mode, y, x
 DB $ff, +$00, +$4C ; mode, y, x
 DB $ff, -$65, -$4C ; mode, y, x
 DB $ff, +$00, +$4C ; mode, y, x
 DB $00, +$00, +$33 ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_3:
 DB $ff, +$00, +$4C ; mode, y, x
 DB $ff, +$32, -$33 ; mode, y, x
 DB $ff, +$33, +$33 ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $00, -$65, +$7F ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_4:
 DB $00, +$00, +$19 ; move to y, x
 DB $00, +$00, +$19 ; mode, y, x
 DB $ff, +$65, +$00 ; mode, y, x
 DB $ff, -$4C, -$32 ; mode, y, x
 DB $ff, +$00, +$4C ; mode, y, x
 DB $00, -$19, +$33 ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_5:
 DB $ff, +$00, +$4C ; mode, y, x
 DB $ff, +$32, +$00 ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $ff, +$33, +$00 ; mode, y, x
 DB $ff, +$00, +$4C ; mode, y, x
 DB $00, -$65, +$33 ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_6:
 DB $ff, +$65, +$00 ; mode, y, x
 DB $00, -$33, +$00 ; mode, y, x
 DB $ff, +$00, +$4C ; mode, y, x
 DB $ff, -$32, +$00 ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $00, +$00, +$7F ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_7:
 DB $ff, +$65, +$4C ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $00, -$65, +$7F ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_8:
 DB $ff, +$65, +$4C ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $ff, -$65, +$4C ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $00, +$00, +$7F ; mode, y, x
 DB $01 ; endmarker (1)
NumberList_9:
 DB $00, +$00, +$4C ; mode, y, x
 DB $ff, +$65, +$00 ; mode, y, x
 DB $ff, +$00, -$4C ; mode, y, x
 DB $ff, -$33, +$00 ; mode, y, x
 DB $ff, +$00, +$4C ; mode, y, x
 DB $00, -$32, +$33 ; mode, y, x
 DB $01 ; endmarker (1)



; Starlet list
; count
; move y,x
; data y,x ...

StarletList:
 DW StarletList_0 ; list of all single vectorlists in this
 DW StarletList_1
 DW StarletList_2
 DW StarletList_3
 DW StarletList_4
 DW StarletList_5
 DW StarletList_6
 DW StarletList_7
 DW StarletList_8
 DW StarletList_9
 DW StarletList_10

StarletList_0:
 DB +$09 ; number of lines to draw
 DB +$4C, +$38 ; draw to y, x
 DB +$71, -$38 ; draw to y, x
 DB -$71, -$38 ; draw to y, x
 DB -$13, -$7E ; draw to y, x
 DB -$57, +$5B ; draw to y, x
 DB -$7D, -$15 ; draw to y, x
 DB +$3A, +$70 ; draw to y, x
 DB -$3A, +$70 ; draw to y, x
 DB +$7D, -$16 ; draw to y, x
 DB +$57, +$5B ; draw to y, x
 DB +$13, -$7D ; draw to y, x
StarletList_1:
 DB +$09 ; number of lines to draw
 DB +$52, +$2F ; draw to y, x
 DB +$6A, -$44 ; draw to y, x
 DB -$77, -$2B ; draw to y, x
 DB -$21, -$7B ; draw to y, x
 DB -$4C, +$64 ; draw to y, x
 DB -$7F, -$06 ; draw to y, x
 DB +$47, +$67 ; draw to y, x
 DB -$2D, +$76 ; draw to y, x
 DB +$7A, -$23 ; draw to y, x
 DB +$60, +$50 ; draw to y, x
 DB +$05, -$7E ; draw to y, x
StarletList_2:
 DB +$09 ; number of lines to draw
 DB +$57, +$25 ; draw to y, x
 DB +$61, -$4F ; draw to y, x
 DB -$7B, -$1E ; draw to y, x
 DB -$2F, -$76 ; draw to y, x
 DB -$40, +$6C ; draw to y, x
 DB -$7F, +$08 ; draw to y, x
 DB +$53, +$5F ; draw to y, x
 DB -$20, +$7B ; draw to y, x
 DB +$75, -$31 ; draw to y, x
 DB +$6A, +$44 ; draw to y, x
 DB -$0A, -$7E ; draw to y, x
StarletList_3:
 DB +$09 ; number of lines to draw
 DB +$5B, +$1B ; draw to y, x
 DB +$57, -$5A ; draw to y, x
 DB -$7E, -$10 ; draw to y, x
 DB -$3A, -$70 ; draw to y, x
 DB -$35, +$74 ; draw to y, x
 DB -$7D, +$16 ; draw to y, x
 DB +$5D, +$55 ; draw to y, x
 DB -$12, +$7D ; draw to y, x
 DB +$6D, -$3E ; draw to y, x
 DB +$73, +$38 ; draw to y, x
 DB -$18, -$7C ; draw to y, x
StarletList_4:
 DB +$09 ; number of lines to draw
 DB +$5D, +$10 ; draw to y, x
 DB +$4C, -$63 ; draw to y, x
 DB -$7E, -$01 ; draw to y, x
 DB -$47, -$69 ; draw to y, x
 DB -$27, +$79 ; draw to y, x
 DB -$7A, +$25 ; draw to y, x
 DB +$66, +$49 ; draw to y, x
 DB -$03, +$7F ; draw to y, x
 DB +$65, -$4B ; draw to y, x
 DB +$78, +$2B ; draw to y, x
 DB -$26, -$79 ; draw to y, x
StarletList_5:
 DB +$09 ; number of lines to draw
 DB +$5F, +$05 ; draw to y, x
 DB +$40, -$6B ; draw to y, x
 DB -$7E, +$0D ; draw to y, x
 DB -$53, -$5F ; draw to y, x
 DB -$19, +$7C ; draw to y, x
 DB -$74, +$33 ; draw to y, x
 DB +$6E, +$3D ; draw to y, x
 DB +$0B, +$7E ; draw to y, x
 DB +$5C, -$56 ; draw to y, x
 DB +$7C, +$1E ; draw to y, x
 DB -$33, -$75 ; draw to y, x
StarletList_6:
 DB +$09 ; number of lines to draw
 DB +$5F, -$04 ; draw to y, x
 DB +$33, -$74 ; draw to y, x
 DB -$7B, +$1C ; draw to y, x
 DB -$5E, -$55 ; draw to y, x
 DB -$0A, +$7E ; draw to y, x
 DB -$6E, +$3E ; draw to y, x
 DB +$74, +$32 ; draw to y, x
 DB +$1A, +$7C ; draw to y, x
 DB +$52, -$60 ; draw to y, x
 DB +$7E, +$0F ; draw to y, x
 DB -$40, -$6C ; draw to y, x
StarletList_7:
 DB +$09 ; number of lines to draw
 DB +$5E, -$0E ; draw to y, x
 DB +$25, -$79 ; draw to y, x
 DB -$77, +$29 ; draw to y, x
 DB -$67, -$4A ; draw to y, x
 DB +$04, +$7F ; draw to y, x
 DB -$65, +$4A ; draw to y, x
 DB +$79, +$24 ; draw to y, x
 DB +$28, +$78 ; draw to y, x
 DB +$46, -$68 ; draw to y, x
 DB +$7F, +$00 ; draw to y, x
 DB -$4C, -$63 ; draw to y, x
StarletList_8:
 DB +$09 ; number of lines to draw
 DB +$5B, -$19 ; draw to y, x
 DB +$19, -$7C ; draw to y, x
 DB -$73, +$36 ; draw to y, x
 DB -$6E, -$3D ; draw to y, x
 DB +$12, +$7D ; draw to y, x
 DB -$5C, +$55 ; draw to y, x
 DB +$7C, +$17 ; draw to y, x
 DB +$36, +$72 ; draw to y, x
 DB +$39, -$70 ; draw to y, x
 DB +$7E, -$0E ; draw to y, x
 DB -$57, -$5A ; draw to y, x
StarletList_9:
 DB +$09 ; number of lines to draw
 DB +$58, -$24 ; draw to y, x
 DB +$0A, -$7E ; draw to y, x
 DB -$6A, +$44 ; draw to y, x
 DB -$77, -$31 ; draw to y, x
 DB +$21, +$7B ; draw to y, x
 DB -$52, +$5F ; draw to y, x
 DB +$7E, +$08 ; draw to y, x
 DB +$41, +$6C ; draw to y, x
 DB +$2E, -$76 ; draw to y, x
 DB +$7C, -$1D ; draw to y, x
 DB -$61, -$50 ; draw to y, x
StarletList_10:
 DB +$09 ; number of lines to draw
 DB +$53, -$2D ; draw to y, x
 DB -$05, -$7F ; draw to y, x
 DB -$61, +$4F ; draw to y, x
 DB -$7A, -$22 ; draw to y, x
 DB +$2D, +$76 ; draw to y, x
 DB -$46, +$68 ; draw to y, x
 DB +$7E, -$07 ; draw to y, x
 DB +$4D, +$64 ; draw to y, x
 DB +$20, -$7B ; draw to y, x
 DB +$78, -$2B ; draw to y, x
 DB -$6A, -$43 ; draw to y, x


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
circle: 
; circle generated 0°-360° in 360 steps (cos, -sin), radius: 108
; if radius is greater a 5 sided polygon has sides longer than 127!
                    db       $6C, $00                     ; degrees: 0° 
                    db       $6B, $FF                     ; degrees: 1° 
                    db       $6B, $FD                     ; degrees: 2° 
                    db       $6B, $FB                     ; degrees: 3° 
                    db       $6B, $F9                     ; degrees: 4° 
                    db       $6B, $F7                     ; degrees: 5° 
                    db       $6B, $F5                     ; degrees: 6° 
                    db       $6B, $F3                     ; degrees: 7° 
                    db       $6A, $F1                     ; degrees: 8° 
                    db       $6A, $F0                     ; degrees: 9° 
                    db       $6A, $EE                     ; degrees: 10° 
                    db       $6A, $EC                     ; degrees: 11° 
                    db       $69, $EA                     ; degrees: 12° 
                    db       $69, $E8                     ; degrees: 13° 
                    db       $68, $E6                     ; degrees: 14° 
                    db       $68, $E5                     ; degrees: 15° 
                    db       $67, $E3                     ; degrees: 16° 
                    db       $67, $E1                     ; degrees: 17° 
                    db       $66, $DF                     ; degrees: 18° 
                    db       $66, $DD                     ; degrees: 19° 
                    db       $65, $DC                     ; degrees: 20° 
                    db       $64, $DA                     ; degrees: 21° 
                    db       $64, $D8                     ; degrees: 22° 
                    db       $63, $D6                     ; degrees: 23° 
                    db       $62, $D5                     ; degrees: 24° 
                    db       $61, $D3                     ; degrees: 25° 
                    db       $61, $D1                     ; degrees: 26° 
                    db       $60, $CF                     ; degrees: 27° 
                    db       $5F, $CE                     ; degrees: 28° 
                    db       $5E, $CC                     ; degrees: 29° 
                    db       $5D, $CB                     ; degrees: 30° 
                    db       $5C, $C9                     ; degrees: 31° 
                    db       $5B, $C7                     ; degrees: 32° 
                    db       $5A, $C6                     ; degrees: 33° 
                    db       $59, $C4                     ; degrees: 34° 
                    db       $58, $C3                     ; degrees: 35° 
                    db       $57, $C1                     ; degrees: 36° 
                    db       $56, $C0                     ; degrees: 37° 
                    db       $55, $BE                     ; degrees: 38° 
                    db       $53, $BD                     ; degrees: 39° 
                    db       $52, $BB                     ; degrees: 40° 
                    db       $51, $BA                     ; degrees: 41° 
                    db       $50, $B8                     ; degrees: 42° 
                    db       $4E, $B7                     ; degrees: 43° 
                    db       $4D, $B5                     ; degrees: 44° 
                    db       $4C, $B4                     ; degrees: 45° 
                    db       $4B, $B3                     ; degrees: 46° 
                    db       $49, $B2                     ; degrees: 47° 
                    db       $48, $B0                     ; degrees: 48° 
                    db       $46, $AF                     ; degrees: 49° 
                    db       $45, $AE                     ; degrees: 50° 
                    db       $43, $AD                     ; degrees: 51° 
                    db       $42, $AB                     ; degrees: 52° 
                    db       $40, $AA                     ; degrees: 53° 
                    db       $3F, $A9                     ; degrees: 54° 
                    db       $3D, $A8                     ; degrees: 55° 
                    db       $3C, $A7                     ; degrees: 56° 
                    db       $3A, $A6                     ; degrees: 57° 
                    db       $39, $A5                     ; degrees: 58° 
                    db       $37, $A4                     ; degrees: 59° 
                    db       $36, $A3                     ; degrees: 60° 
                    db       $34, $A2                     ; degrees: 61° 
                    db       $32, $A1                     ; degrees: 62° 
                    db       $31, $A0                     ; degrees: 63° 
                    db       $2F, $9F                     ; degrees: 64° 
                    db       $2D, $9F                     ; degrees: 65° 
                    db       $2B, $9E                     ; degrees: 66° 
                    db       $2A, $9D                     ; degrees: 67° 
                    db       $28, $9C                     ; degrees: 68° 
                    db       $26, $9C                     ; degrees: 69° 
                    db       $24, $9B                     ; degrees: 70° 
                    db       $23, $9A                     ; degrees: 71° 
                    db       $21, $9A                     ; degrees: 72° 
                    db       $1F, $99                     ; degrees: 73° 
                    db       $1D, $99                     ; degrees: 74° 
                    db       $1B, $98                     ; degrees: 75° 
                    db       $1A, $98                     ; degrees: 76° 
                    db       $18, $97                     ; degrees: 77° 
                    db       $16, $97                     ; degrees: 78° 
                    db       $14, $96                     ; degrees: 79° 
                    db       $12, $96                     ; degrees: 80° 
                    db       $10, $96                     ; degrees: 81° 
                    db       $0F, $96                     ; degrees: 82° 
                    db       $0D, $95                     ; degrees: 83° 
                    db       $0B, $95                     ; degrees: 84° 
                    db       $09, $95                     ; degrees: 85° 
                    db       $07, $95                     ; degrees: 86° 
                    db       $05, $95                     ; degrees: 87° 
                    db       $03, $95                     ; degrees: 88° 
                    db       $01, $95                     ; degrees: 89° 
                    db       $00, $94                     ; degrees: 90° 
                    db       $FF, $95                     ; degrees: 91° 
                    db       $FD, $95                     ; degrees: 92° 
                    db       $FB, $95                     ; degrees: 93° 
                    db       $F9, $95                     ; degrees: 94° 
                    db       $F7, $95                     ; degrees: 95° 
                    db       $F5, $95                     ; degrees: 96° 
                    db       $F3, $95                     ; degrees: 97° 
                    db       $F1, $96                     ; degrees: 98° 
                    db       $F0, $96                     ; degrees: 99° 
                    db       $EE, $96                     ; degrees: 100° 
                    db       $EC, $96                     ; degrees: 101° 
                    db       $EA, $97                     ; degrees: 102° 
                    db       $E8, $97                     ; degrees: 103° 
                    db       $E6, $98                     ; degrees: 104° 
                    db       $E5, $98                     ; degrees: 105° 
                    db       $E3, $99                     ; degrees: 106° 
                    db       $E1, $99                     ; degrees: 107° 
                    db       $DF, $9A                     ; degrees: 108° 
                    db       $DD, $9A                     ; degrees: 109° 
                    db       $DC, $9B                     ; degrees: 110° 
                    db       $DA, $9C                     ; degrees: 111° 
                    db       $D8, $9C                     ; degrees: 112° 
                    db       $D6, $9D                     ; degrees: 113° 
                    db       $D5, $9E                     ; degrees: 114° 
                    db       $D3, $9F                     ; degrees: 115° 
                    db       $D1, $9F                     ; degrees: 116° 
                    db       $CF, $A0                     ; degrees: 117° 
                    db       $CE, $A1                     ; degrees: 118° 
                    db       $CC, $A2                     ; degrees: 119° 
                    db       $CB, $A3                     ; degrees: 120° 
                    db       $C9, $A4                     ; degrees: 121° 
                    db       $C7, $A5                     ; degrees: 122° 
                    db       $C6, $A6                     ; degrees: 123° 
                    db       $C4, $A7                     ; degrees: 124° 
                    db       $C3, $A8                     ; degrees: 125° 
                    db       $C1, $A9                     ; degrees: 126° 
                    db       $C0, $AA                     ; degrees: 127° 
                    db       $BE, $AB                     ; degrees: 128° 
                    db       $BD, $AD                     ; degrees: 129° 
                    db       $BB, $AE                     ; degrees: 130° 
                    db       $BA, $AF                     ; degrees: 131° 
                    db       $B8, $B0                     ; degrees: 132° 
                    db       $B7, $B2                     ; degrees: 133° 
                    db       $B5, $B3                     ; degrees: 134° 
                    db       $B4, $B4                     ; degrees: 135° 
                    db       $B3, $B5                     ; degrees: 136° 
                    db       $B2, $B7                     ; degrees: 137° 
                    db       $B0, $B8                     ; degrees: 138° 
                    db       $AF, $BA                     ; degrees: 139° 
                    db       $AE, $BB                     ; degrees: 140° 
                    db       $AD, $BD                     ; degrees: 141° 
                    db       $AB, $BE                     ; degrees: 142° 
                    db       $AA, $C0                     ; degrees: 143° 
                    db       $A9, $C1                     ; degrees: 144° 
                    db       $A8, $C3                     ; degrees: 145° 
                    db       $A7, $C4                     ; degrees: 146° 
                    db       $A6, $C6                     ; degrees: 147° 
                    db       $A5, $C7                     ; degrees: 148° 
                    db       $A4, $C9                     ; degrees: 149° 
                    db       $A3, $CB                     ; degrees: 150° 
                    db       $A2, $CC                     ; degrees: 151° 
                    db       $A1, $CE                     ; degrees: 152° 
                    db       $A0, $CF                     ; degrees: 153° 
                    db       $9F, $D1                     ; degrees: 154° 
                    db       $9F, $D3                     ; degrees: 155° 
                    db       $9E, $D5                     ; degrees: 156° 
                    db       $9D, $D6                     ; degrees: 157° 
                    db       $9C, $D8                     ; degrees: 158° 
                    db       $9C, $DA                     ; degrees: 159° 
                    db       $9B, $DC                     ; degrees: 160° 
                    db       $9A, $DD                     ; degrees: 161° 
                    db       $9A, $DF                     ; degrees: 162° 
                    db       $99, $E1                     ; degrees: 163° 
                    db       $99, $E3                     ; degrees: 164° 
                    db       $98, $E5                     ; degrees: 165° 
                    db       $98, $E6                     ; degrees: 166° 
                    db       $97, $E8                     ; degrees: 167° 
                    db       $97, $EA                     ; degrees: 168° 
                    db       $96, $EC                     ; degrees: 169° 
                    db       $96, $EE                     ; degrees: 170° 
                    db       $96, $F0                     ; degrees: 171° 
                    db       $96, $F1                     ; degrees: 172° 
                    db       $95, $F3                     ; degrees: 173° 
                    db       $95, $F5                     ; degrees: 174° 
                    db       $95, $F7                     ; degrees: 175° 
                    db       $95, $F9                     ; degrees: 176° 
                    db       $95, $FB                     ; degrees: 177° 
                    db       $95, $FD                     ; degrees: 178° 
                    db       $95, $FF                     ; degrees: 179° 
                    db       $94, $00                     ; degrees: 180° 
                    db       $95, $01                     ; degrees: 181° 
                    db       $95, $03                     ; degrees: 182° 
                    db       $95, $05                     ; degrees: 183° 
                    db       $95, $07                     ; degrees: 184° 
                    db       $95, $09                     ; degrees: 185° 
                    db       $95, $0B                     ; degrees: 186° 
                    db       $95, $0D                     ; degrees: 187° 
                    db       $96, $0F                     ; degrees: 188° 
                    db       $96, $10                     ; degrees: 189° 
                    db       $96, $12                     ; degrees: 190° 
                    db       $96, $14                     ; degrees: 191° 
                    db       $97, $16                     ; degrees: 192° 
                    db       $97, $18                     ; degrees: 193° 
                    db       $98, $1A                     ; degrees: 194° 
                    db       $98, $1B                     ; degrees: 195° 
                    db       $99, $1D                     ; degrees: 196° 
                    db       $99, $1F                     ; degrees: 197° 
                    db       $9A, $21                     ; degrees: 198° 
                    db       $9A, $23                     ; degrees: 199° 
                    db       $9B, $24                     ; degrees: 200° 
                    db       $9C, $26                     ; degrees: 201° 
                    db       $9C, $28                     ; degrees: 202° 
                    db       $9D, $2A                     ; degrees: 203° 
                    db       $9E, $2B                     ; degrees: 204° 
                    db       $9F, $2D                     ; degrees: 205° 
                    db       $9F, $2F                     ; degrees: 206° 
                    db       $A0, $31                     ; degrees: 207° 
                    db       $A1, $32                     ; degrees: 208° 
                    db       $A2, $34                     ; degrees: 209° 
                    db       $A3, $36                     ; degrees: 210° 
                    db       $A4, $37                     ; degrees: 211° 
                    db       $A5, $39                     ; degrees: 212° 
                    db       $A6, $3A                     ; degrees: 213° 
                    db       $A7, $3C                     ; degrees: 214° 
                    db       $A8, $3D                     ; degrees: 215° 
                    db       $A9, $3F                     ; degrees: 216° 
                    db       $AA, $40                     ; degrees: 217° 
                    db       $AB, $42                     ; degrees: 218° 
                    db       $AD, $43                     ; degrees: 219° 
                    db       $AE, $45                     ; degrees: 220° 
                    db       $AF, $46                     ; degrees: 221° 
                    db       $B0, $48                     ; degrees: 222° 
                    db       $B2, $49                     ; degrees: 223° 
                    db       $B3, $4B                     ; degrees: 224° 
                    db       $B4, $4C                     ; degrees: 225° 
                    db       $B5, $4D                     ; degrees: 226° 
                    db       $B7, $4E                     ; degrees: 227° 
                    db       $B8, $50                     ; degrees: 228° 
                    db       $BA, $51                     ; degrees: 229° 
                    db       $BB, $52                     ; degrees: 230° 
                    db       $BD, $53                     ; degrees: 231° 
                    db       $BE, $55                     ; degrees: 232° 
                    db       $C0, $56                     ; degrees: 233° 
                    db       $C1, $57                     ; degrees: 234° 
                    db       $C3, $58                     ; degrees: 235° 
                    db       $C4, $59                     ; degrees: 236° 
                    db       $C6, $5A                     ; degrees: 237° 
                    db       $C7, $5B                     ; degrees: 238° 
                    db       $C9, $5C                     ; degrees: 239° 
                    db       $CA, $5D                     ; degrees: 240° 
                    db       $CC, $5E                     ; degrees: 241° 
                    db       $CE, $5F                     ; degrees: 242° 
                    db       $CF, $60                     ; degrees: 243° 
                    db       $D1, $61                     ; degrees: 244° 
                    db       $D3, $61                     ; degrees: 245° 
                    db       $D5, $62                     ; degrees: 246° 
                    db       $D6, $63                     ; degrees: 247° 
                    db       $D8, $64                     ; degrees: 248° 
                    db       $DA, $64                     ; degrees: 249° 
                    db       $DC, $65                     ; degrees: 250° 
                    db       $DD, $66                     ; degrees: 251° 
                    db       $DF, $66                     ; degrees: 252° 
                    db       $E1, $67                     ; degrees: 253° 
                    db       $E3, $67                     ; degrees: 254° 
                    db       $E5, $68                     ; degrees: 255° 
                    db       $E6, $68                     ; degrees: 256° 
                    db       $E8, $69                     ; degrees: 257° 
                    db       $EA, $69                     ; degrees: 258° 
                    db       $EC, $6A                     ; degrees: 259° 
                    db       $EE, $6A                     ; degrees: 260° 
                    db       $F0, $6A                     ; degrees: 261° 
                    db       $F1, $6A                     ; degrees: 262° 
                    db       $F3, $6B                     ; degrees: 263° 
                    db       $F5, $6B                     ; degrees: 264° 
                    db       $F7, $6B                     ; degrees: 265° 
                    db       $F9, $6B                     ; degrees: 266° 
                    db       $FB, $6B                     ; degrees: 267° 
                    db       $FD, $6B                     ; degrees: 268° 
                    db       $FF, $6B                     ; degrees: 269° 
                    db       $00, $6C                     ; degrees: 270° 
                    db       $01, $6B                     ; degrees: 271° 
                    db       $03, $6B                     ; degrees: 272° 
                    db       $05, $6B                     ; degrees: 273° 
                    db       $07, $6B                     ; degrees: 274° 
                    db       $09, $6B                     ; degrees: 275° 
                    db       $0B, $6B                     ; degrees: 276° 
                    db       $0D, $6B                     ; degrees: 277° 
                    db       $0F, $6A                     ; degrees: 278° 
                    db       $10, $6A                     ; degrees: 279° 
                    db       $12, $6A                     ; degrees: 280° 
                    db       $14, $6A                     ; degrees: 281° 
                    db       $16, $69                     ; degrees: 282° 
                    db       $18, $69                     ; degrees: 283° 
                    db       $1A, $68                     ; degrees: 284° 
                    db       $1B, $68                     ; degrees: 285° 
                    db       $1D, $67                     ; degrees: 286° 
                    db       $1F, $67                     ; degrees: 287° 
                    db       $21, $66                     ; degrees: 288° 
                    db       $23, $66                     ; degrees: 289° 
                    db       $24, $65                     ; degrees: 290° 
                    db       $26, $64                     ; degrees: 291° 
                    db       $28, $64                     ; degrees: 292° 
                    db       $2A, $63                     ; degrees: 293° 
                    db       $2B, $62                     ; degrees: 294° 
                    db       $2D, $61                     ; degrees: 295° 
                    db       $2F, $61                     ; degrees: 296° 
                    db       $31, $60                     ; degrees: 297° 
                    db       $32, $5F                     ; degrees: 298° 
                    db       $34, $5E                     ; degrees: 299° 
                    db       $36, $5D                     ; degrees: 300° 
                    db       $37, $5C                     ; degrees: 301° 
                    db       $39, $5B                     ; degrees: 302° 
                    db       $3A, $5A                     ; degrees: 303° 
                    db       $3C, $59                     ; degrees: 304° 
                    db       $3D, $58                     ; degrees: 305° 
                    db       $3F, $57                     ; degrees: 306° 
                    db       $40, $56                     ; degrees: 307° 
                    db       $42, $55                     ; degrees: 308° 
                    db       $43, $53                     ; degrees: 309° 
                    db       $45, $52                     ; degrees: 310° 
                    db       $46, $51                     ; degrees: 311° 
                    db       $48, $50                     ; degrees: 312° 
                    db       $49, $4E                     ; degrees: 313° 
                    db       $4B, $4D                     ; degrees: 314° 
                    db       $4C, $4C                     ; degrees: 315° 
                    db       $4D, $4B                     ; degrees: 316° 
                    db       $4E, $49                     ; degrees: 317° 
                    db       $50, $48                     ; degrees: 318° 
                    db       $51, $46                     ; degrees: 319° 
                    db       $52, $45                     ; degrees: 320° 
                    db       $53, $43                     ; degrees: 321° 
                    db       $55, $42                     ; degrees: 322° 
                    db       $56, $40                     ; degrees: 323° 
                    db       $57, $3F                     ; degrees: 324° 
                    db       $58, $3D                     ; degrees: 325° 
                    db       $59, $3C                     ; degrees: 326° 
                    db       $5A, $3A                     ; degrees: 327° 
                    db       $5B, $39                     ; degrees: 328° 
                    db       $5C, $37                     ; degrees: 329° 
                    db       $5D, $36                     ; degrees: 330° 
                    db       $5E, $34                     ; degrees: 331° 
                    db       $5F, $32                     ; degrees: 332° 
                    db       $60, $31                     ; degrees: 333° 
                    db       $61, $2F                     ; degrees: 334° 
                    db       $61, $2D                     ; degrees: 335° 
                    db       $62, $2B                     ; degrees: 336° 
                    db       $63, $2A                     ; degrees: 337° 
                    db       $64, $28                     ; degrees: 338° 
                    db       $64, $26                     ; degrees: 339° 
                    db       $65, $24                     ; degrees: 340° 
                    db       $66, $23                     ; degrees: 341° 
                    db       $66, $21                     ; degrees: 342° 
                    db       $67, $1F                     ; degrees: 343° 
                    db       $67, $1D                     ; degrees: 344° 
                    db       $68, $1B                     ; degrees: 345° 
                    db       $68, $1A                     ; degrees: 346° 
                    db       $69, $18                     ; degrees: 347° 
                    db       $69, $16                     ; degrees: 348° 
                    db       $6A, $14                     ; degrees: 349° 
                    db       $6A, $12                     ; degrees: 350° 
                    db       $6A, $10                     ; degrees: 351° 
                    db       $6A, $0F                     ; degrees: 352° 
                    db       $6B, $0D                     ; degrees: 353° 
                    db       $6B, $0B                     ; degrees: 354° 
                    db       $6B, $09                     ; degrees: 355° 
                    db       $6B, $07                     ; degrees: 356° 
                    db       $6B, $05                     ; degrees: 357° 
                    db       $6B, $03                     ; degrees: 358° 
                    db       $6B, $01                     ; degrees: 359° 
; some overflow angles
; since random does 0-127 instead of 0-120
                    db       $6C, $00                     ; degrees: 0° 
                    db       $6B, $FF                     ; degrees: 1° 
                    db       $6B, $FD                     ; degrees: 2° 
                    db       $6B, $FB                     ; degrees: 3° 
                    db       $6B, $F9                     ; degrees: 4° 
                    db       $6B, $F7                     ; degrees: 5° 
                    db       $6B, $F5                     ; degrees: 6° 
                    db       $6B, $F3                     ; degrees: 7° 
                    db       $6A, $F1                     ; degrees: 8° 
                    db       $6A, $F0                     ; degrees: 9° 
                    db       $6A, $EE                     ; degrees: 10° 
                    db       $6A, $EC                     ; degrees: 11° 
                    db       $69, $EA                     ; degrees: 12° 
                    db       $69, $E8                     ; degrees: 13° 
                    db       $68, $E6                     ; degrees: 14° 
                    db       $68, $E5                     ; degrees: 15° 
                    db       $67, $E3                     ; degrees: 16° 
                    db       $67, $E1                     ; degrees: 17° 
                    db       $66, $DF                     ; degrees: 18° 
                    db       $66, $DD                     ; degrees: 19° 
                    db       $65, $DC                     ; degrees: 20° 
                    db       $64, $DA                     ; degrees: 21° 
                    db       $64, $D8                     ; degrees: 22° 
