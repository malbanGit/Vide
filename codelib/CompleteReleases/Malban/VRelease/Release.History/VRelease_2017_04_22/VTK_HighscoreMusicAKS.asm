
; This file was build using VIDE - Vectrex Integrated Development Environment
; Original bin file was: projects/VRelease/VTK_HighscoreMusic.bin
; 
; offset for AKS file assumed: $0000 guessed by accessing byte data[13] * 256)
; not used by vectrex player and therefor omitted:
;  DB "AT10" ; Signature of Arkos Tracker files
;  DB $01 ; sample channel
;  DB $40, 42, 0f ; YM custom frequence - little endian
;  DB $02 ; Replay frequency (0=13hz,1=25hz,2=50hz,3=100hz,4=150hz,5=300hz)
 db $06 ; $0009: default speed
 dw $00DA ; $000A: size of instrument table (without this word pointer)
 dw instrument0_HS ; $000C: [$001E] pointer to instrument 0
 dw instrument1_HS ; $000E: [$0027] pointer to instrument 1
 dw instrument2_HS ; $0010: [$0039] pointer to instrument 2
 dw instrument3_HS ; $0012: [$005B] pointer to instrument 3
 dw instrument4_HS ; $0014: [$0076] pointer to instrument 4
 dw instrument5_HS ; $0016: [$0092] pointer to instrument 5
 dw instrument6_HS ; $0018: [$009B] pointer to instrument 6
 dw instrument7_HS ; $001A: [$00A4] pointer to instrument 7
 dw instrument8_HS ; $001C: [$00BD] pointer to instrument 8
instrument0_HS:
 db $00 ; $001E: speed
 db $00 ; $001F: retrig
instrument0loop_HS:
 db $00 ; $0020: dataColumn_0 (non hard), vol=$0
 db $00 ; $0021: dataColumn_0 (non hard), vol=$0
 db $00 ; $0022: dataColumn_0 (non hard), vol=$0
 db $00 ; $0023: dataColumn_0 (non hard), vol=$0
 db $0D ; $0024: dataColumn_0 (hard)
 dw instrument0loop_HS ; $0025: [$0020] loop
instrument1_HS:
 db $01 ; $0027: speed
 db $00 ; $0028: retrig
 db $7E ; $0029: dataColumn_0 (non hard), vol=$F
 db $37 ; $002A: dataColumn_1, noise=$17
 db $F6 ; $002B: arpegio
 db $7C ; $002C: dataColumn_0 (non hard), vol=$F
 db $DB ; $002D: arpegio
 db $5C ; $002E: dataColumn_0 (non hard), vol=$7
 db $DF ; $002F: arpegio
 db $78 ; $0030: dataColumn_0 (non hard), vol=$E
 db $D8 ; $0031: arpegio
 db $6C ; $0032: dataColumn_0 (non hard), vol=$B
 db $CD ; $0033: arpegio
 db $1E ; $0034: dataColumn_0 (non hard), vol=$7
 db $01 ; $0035: dataColumn_1, noise=$01
 db $0D ; $0036: dataColumn_0 (hard)
 dw instrument0loop_HS ; $0037: [$0020] loop
instrument2_HS:
 db $01 ; $0039: speed
 db $00 ; $003A: retrig
 db $3E ; $003B: dataColumn_0 (non hard), vol=$F
 db $3F ; $003C: dataColumn_1, noise=$1F
 db $3E ; $003D: dataColumn_0 (non hard), vol=$F
 db $00 ; $003E: dataColumn_1
 db $0E ; $003F: dataColumn_0 (non hard), vol=$3
 db $31 ; $0040: dataColumn_1, noise=$11
 db $32 ; $0041: dataColumn_0 (non hard), vol=$C
 db $0A ; $0042: dataColumn_1, noise=$0A
 db $12 ; $0043: dataColumn_0 (non hard), vol=$4
 db $26 ; $0044: dataColumn_1, noise=$06
 db $2E ; $0045: dataColumn_0 (non hard), vol=$B
 db $1D ; $0046: dataColumn_1, noise=$1D
 db $2E ; $0047: dataColumn_0 (non hard), vol=$B
 db $28 ; $0048: dataColumn_1, noise=$08
 db $1E ; $0049: dataColumn_0 (non hard), vol=$7
 db $09 ; $004A: dataColumn_1, noise=$09
 db $12 ; $004B: dataColumn_0 (non hard), vol=$4
 db $27 ; $004C: dataColumn_1, noise=$07
 db $52 ; $004D: dataColumn_0 (non hard), vol=$4
 db $24 ; $004E: dataColumn_1, noise=$04
 db $0C ; $004F: arpegio
 db $12 ; $0050: dataColumn_0 (non hard), vol=$4
 db $01 ; $0051: dataColumn_1, noise=$01
 db $4C ; $0052: dataColumn_0 (non hard), vol=$3
 db $0C ; $0053: arpegio
 db $0A ; $0054: dataColumn_0 (non hard), vol=$2
 db $21 ; $0055: dataColumn_1, noise=$01
 db $48 ; $0056: dataColumn_0 (non hard), vol=$2
 db $0C ; $0057: arpegio
 db $0D ; $0058: dataColumn_0 (hard)
 dw instrument0loop_HS ; $0059: [$0020] loop
instrument3_HS:
 db $03 ; $005B: speed
 db $00 ; $005C: retrig
 db $34 ; $005D: dataColumn_0 (non hard), vol=$D
 db $B0 ; $005E: dataColumn_0 (non hard), vol=$C
 dw $FFFF ; $005F: pitch
 db $30 ; $0061: dataColumn_0 (non hard), vol=$C
 db $AC ; $0062: dataColumn_0 (non hard), vol=$B
 dw $FFFF ; $0063: pitch
 db $2C ; $0065: dataColumn_0 (non hard), vol=$B
 db $A8 ; $0066: dataColumn_0 (non hard), vol=$A
 dw $0001 ; $0067: pitch
 db $24 ; $0069: dataColumn_0 (non hard), vol=$9
 db $A0 ; $006A: dataColumn_0 (non hard), vol=$8
 dw $FFFF ; $006B: pitch
 db $1C ; $006D: dataColumn_0 (non hard), vol=$7
 db $98 ; $006E: dataColumn_0 (non hard), vol=$6
 dw $0001 ; $006F: pitch
 db $14 ; $0071: dataColumn_0 (non hard), vol=$5
 db $10 ; $0072: dataColumn_0 (non hard), vol=$4
 db $0D ; $0073: dataColumn_0 (hard)
 dw instrument0loop_HS ; $0074: [$0020] loop
instrument4_HS:
 db $01 ; $0076: speed
 db $00 ; $0077: retrig
 db $BC ; $0078: dataColumn_0 (non hard), vol=$F
 dw $FFFF ; $0079: pitch
 db $BC ; $007B: dataColumn_0 (non hard), vol=$F
 dw $FFFE ; $007C: pitch
 db $B8 ; $007E: dataColumn_0 (non hard), vol=$E
 dw $0001 ; $007F: pitch
 db $34 ; $0081: dataColumn_0 (non hard), vol=$D
 db $AC ; $0082: dataColumn_0 (non hard), vol=$B
 dw $0001 ; $0083: pitch
 db $A0 ; $0085: dataColumn_0 (non hard), vol=$8
 dw $FFFE ; $0086: pitch
 db $A4 ; $0088: dataColumn_0 (non hard), vol=$9
 dw $FFFF ; $0089: pitch
 db $20 ; $008B: dataColumn_0 (non hard), vol=$8
 db $9C ; $008C: dataColumn_0 (non hard), vol=$7
 dw $0002 ; $008D: pitch
 db $0D ; $008F: dataColumn_0 (hard)
 dw instrument0loop_HS ; $0090: [$0020] loop
instrument5_HS:
 db $01 ; $0092: speed
 db $00 ; $0093: retrig
 db $16 ; $0094: dataColumn_0 (non hard), vol=$5
 db $01 ; $0095: dataColumn_1, noise=$01
 db $2A ; $0096: dataColumn_0 (non hard), vol=$A
 db $01 ; $0097: dataColumn_1, noise=$01
 db $0D ; $0098: dataColumn_0 (hard)
 dw instrument0loop_HS ; $0099: [$0020] loop
instrument6_HS:
 db $02 ; $009B: speed
 db $00 ; $009C: retrig
 db $26 ; $009D: dataColumn_0 (non hard), vol=$9
 db $01 ; $009E: dataColumn_1, noise=$01
 db $16 ; $009F: dataColumn_0 (non hard), vol=$5
 db $02 ; $00A0: dataColumn_1, noise=$02
 db $0D ; $00A1: dataColumn_0 (hard)
 dw instrument0loop_HS ; $00A2: [$0020] loop
instrument7_HS:
 db $01 ; $00A4: speed
 db $00 ; $00A5: retrig
instrument7loop_HS:
 db $F0 ; $00A6: dataColumn_0 (non hard), vol=$C
 dw $FFFF ; $00A7: pitch
 db $32 ; $00A9: arpegio
 db $6C ; $00AA: dataColumn_0 (non hard), vol=$B
 db $21 ; $00AB: arpegio
 db $68 ; $00AC: dataColumn_0 (non hard), vol=$A
 db $1C ; $00AD: arpegio
 db $70 ; $00AE: dataColumn_0 (non hard), vol=$C
 db $18 ; $00AF: arpegio
 db $68 ; $00B0: dataColumn_0 (non hard), vol=$A
 db $32 ; $00B1: arpegio
 db $EC ; $00B2: dataColumn_0 (non hard), vol=$B
 dw $FFFC ; $00B3: pitch
 db $0F ; $00B5: arpegio
 db $68 ; $00B6: dataColumn_0 (non hard), vol=$A
 db $12 ; $00B7: arpegio
 db $6C ; $00B8: dataColumn_0 (non hard), vol=$B
 db $2C ; $00B9: arpegio
 db $0D ; $00BA: dataColumn_0 (hard)
 dw instrument7loop_HS ; $00BB: [$00A6] loop
instrument8_HS:
 db $01 ; $00BD: speed
 db $00 ; $00BE: retrig
instrument8loop_HS:
 db $F0 ; $00BF: dataColumn_0 (non hard), vol=$C
 dw $FFFA ; $00C0: pitch
 db $0A ; $00C2: arpegio
 db $EC ; $00C3: dataColumn_0 (non hard), vol=$B
 dw $FFFE ; $00C4: pitch
 db $02 ; $00C6: arpegio
 db $F0 ; $00C7: dataColumn_0 (non hard), vol=$C
 dw $FFFB ; $00C8: pitch
 db $0F ; $00CA: arpegio
 db $EC ; $00CB: dataColumn_0 (non hard), vol=$B
 dw $FFFA ; $00CC: pitch
 db $04 ; $00CE: arpegio
 db $E8 ; $00CF: dataColumn_0 (non hard), vol=$A
 dw $FFFE ; $00D0: pitch
 db $0F ; $00D2: arpegio
 db $F0 ; $00D3: dataColumn_0 (non hard), vol=$C
 dw $FFFB ; $00D4: pitch
 db $12 ; $00D6: arpegio
 db $EC ; $00D7: dataColumn_0 (non hard), vol=$B
 dw $FFFA ; $00D8: pitch
 db $0C ; $00DA: arpegio
 db $F0 ; $00DB: dataColumn_0 (non hard), vol=$C
 dw $FFFE ; $00DC: pitch
 db $06 ; $00DE: arpegio
 db $EC ; $00DF: dataColumn_0 (non hard), vol=$B
 dw $FFFC ; $00E0: pitch
 db $14 ; $00E2: arpegio
 db $0D ; $00E3: dataColumn_0 (hard)
 dw instrument8loop_HS ; $00E4: [$00BF] loop
; start of linker definition
linker_HS:
 db $10 ; $00E6: first height
 db $00 ; $00E7: transposition1
 db $00 ; $00E8: transposition2
 db $00 ; $00E9: transposition3
 dw specialtrackDef0_HS ; $00EA: [$01DD] specialTrack
pattern0Definition_HS:
 db $00 ; $00EC: pattern 0 state
 dw trackDef0_HS ; $00ED: [$01FE] pattern 0, track 1
 dw trackDef1_HS ; $00EF: [$01DF] pattern 0, track 2
 dw trackDef2_HS ; $00F1: [$0231] pattern 0, track 3
pattern1Definition_HS:
 db $00 ; $00F3: pattern 1 state
 dw trackDef0_HS ; $00F4: [$01FE] pattern 1, track 1
 dw trackDef1_HS ; $00F6: [$01DF] pattern 1, track 2
 dw trackDef2_HS ; $00F8: [$0231] pattern 1, track 3
pattern2Definition_HS:
 db $00 ; $00FA: pattern 2 state
 dw trackDef0_HS ; $00FB: [$01FE] pattern 2, track 1
 dw trackDef1_HS ; $00FD: [$01DF] pattern 2, track 2
 dw trackDef2_HS ; $00FF: [$0231] pattern 2, track 3
pattern3Definition_HS:
 db $00 ; $0101: pattern 3 state
 dw trackDef0_HS ; $0102: [$01FE] pattern 3, track 1
 dw trackDef1_HS ; $0104: [$01DF] pattern 3, track 2
 dw trackDef2_HS ; $0106: [$0231] pattern 3, track 3
pattern4Definition_HS:
 db $00 ; $0108: pattern 4 state
 dw trackDef0_HS ; $0109: [$01FE] pattern 4, track 1
 dw trackDef6_HS ; $010B: [$020E] pattern 4, track 2
 dw trackDef2_HS ; $010D: [$0231] pattern 4, track 3
pattern5Definition_HS:
 db $00 ; $010F: pattern 5 state
 dw trackDef0_HS ; $0110: [$01FE] pattern 5, track 1
 dw trackDef6_HS ; $0112: [$020E] pattern 5, track 2
 dw trackDef2_HS ; $0114: [$0231] pattern 5, track 3
pattern6Definition_HS:
 db $00 ; $0116: pattern 6 state
 dw trackDef0_HS ; $0117: [$01FE] pattern 6, track 1
 dw trackDef6_HS ; $0119: [$020E] pattern 6, track 2
 dw trackDef2_HS ; $011B: [$0231] pattern 6, track 3
pattern7Definition_HS:
 db $00 ; $011D: pattern 7 state
 dw trackDef0_HS ; $011E: [$01FE] pattern 7, track 1
 dw trackDef6_HS ; $0120: [$020E] pattern 7, track 2
 dw trackDef2_HS ; $0122: [$0231] pattern 7, track 3
pattern8Definition_HS:
 db $00 ; $0124: pattern 8 state
 dw trackDef0_HS ; $0125: [$01FE] pattern 8, track 1
 dw trackDef10_HS ; $0127: [$0253] pattern 8, track 2
 dw trackDef2_HS ; $0129: [$0231] pattern 8, track 3
pattern9Definition_HS:
 db $00 ; $012B: pattern 9 state
 dw trackDef0_HS ; $012C: [$01FE] pattern 9, track 1
 dw trackDef11_HS ; $012E: [$0276] pattern 9, track 2
 dw trackDef2_HS ; $0130: [$0231] pattern 9, track 3
pattern10Definition_HS:
 db $00 ; $0132: pattern 10 state
 dw trackDef0_HS ; $0133: [$01FE] pattern 10, track 1
 dw trackDef11_HS ; $0135: [$0276] pattern 10, track 2
 dw trackDef2_HS ; $0137: [$0231] pattern 10, track 3
pattern11Definition_HS:
 db $00 ; $0139: pattern 11 state
 dw trackDef0_HS ; $013A: [$01FE] pattern 11, track 1
 dw trackDef13_HS ; $013C: [$0298] pattern 11, track 2
 dw trackDef2_HS ; $013E: [$0231] pattern 11, track 3
pattern12Definition_HS:
 db $00 ; $0140: pattern 12 state
 dw trackDef0_HS ; $0141: [$01FE] pattern 12, track 1
 dw trackDef1_HS ; $0143: [$01DF] pattern 12, track 2
 dw trackDef2_HS ; $0145: [$0231] pattern 12, track 3
pattern13Definition_HS:
 db $00 ; $0147: pattern 13 state
 dw trackDef0_HS ; $0148: [$01FE] pattern 13, track 1
 dw trackDef1_HS ; $014A: [$01DF] pattern 13, track 2
 dw trackDef2_HS ; $014C: [$0231] pattern 13, track 3
pattern14Definition_HS:
 db $00 ; $014E: pattern 14 state
 dw trackDef0_HS ; $014F: [$01FE] pattern 14, track 1
 dw trackDef1_HS ; $0151: [$01DF] pattern 14, track 2
 dw trackDef2_HS ; $0153: [$0231] pattern 14, track 3
pattern15Definition_HS:
 db $00 ; $0155: pattern 15 state
 dw trackDef0_HS ; $0156: [$01FE] pattern 15, track 1
 dw trackDef1_HS ; $0158: [$01DF] pattern 15, track 2
 dw trackDef2_HS ; $015A: [$0231] pattern 15, track 3
pattern16Definition_HS:
 db $00 ; $015C: pattern 16 state
 dw trackDef0_HS ; $015D: [$01FE] pattern 16, track 1
 dw trackDef6_HS ; $015F: [$020E] pattern 16, track 2
 dw trackDef2_HS ; $0161: [$0231] pattern 16, track 3
pattern17Definition_HS:
 db $00 ; $0163: pattern 17 state
 dw trackDef0_HS ; $0164: [$01FE] pattern 17, track 1
 dw trackDef6_HS ; $0166: [$020E] pattern 17, track 2
 dw trackDef2_HS ; $0168: [$0231] pattern 17, track 3
pattern18Definition_HS:
 db $00 ; $016A: pattern 18 state
 dw trackDef0_HS ; $016B: [$01FE] pattern 18, track 1
 dw trackDef6_HS ; $016D: [$020E] pattern 18, track 2
 dw trackDef2_HS ; $016F: [$0231] pattern 18, track 3
pattern19Definition_HS:
 db $00 ; $0171: pattern 19 state
 dw trackDef0_HS ; $0172: [$01FE] pattern 19, track 1
 dw trackDef6_HS ; $0174: [$020E] pattern 19, track 2
 dw trackDef2_HS ; $0176: [$0231] pattern 19, track 3
pattern20Definition_HS:
 db $00 ; $0178: pattern 20 state
 dw trackDef0_HS ; $0179: [$01FE] pattern 20, track 1
 dw trackDef6_HS ; $017B: [$020E] pattern 20, track 2
 dw trackDef2_HS ; $017D: [$0231] pattern 20, track 3
pattern21Definition_HS:
 db $00 ; $017F: pattern 21 state
 dw trackDef0_HS ; $0180: [$01FE] pattern 21, track 1
 dw trackDef6_HS ; $0182: [$020E] pattern 21, track 2
 dw trackDef2_HS ; $0184: [$0231] pattern 21, track 3
pattern22Definition_HS:
 db $00 ; $0186: pattern 22 state
 dw trackDef0_HS ; $0187: [$01FE] pattern 22, track 1
 dw trackDef6_HS ; $0189: [$020E] pattern 22, track 2
 dw trackDef2_HS ; $018B: [$0231] pattern 22, track 3
pattern23Definition_HS:
 db $00 ; $018D: pattern 23 state
 dw trackDef0_HS ; $018E: [$01FE] pattern 23, track 1
 dw trackDef6_HS ; $0190: [$020E] pattern 23, track 2
 dw trackDef2_HS ; $0192: [$0231] pattern 23, track 3
pattern24Definition_HS:
 db $00 ; $0194: pattern 24 state
 dw trackDef1_HS ; $0195: [$01DF] pattern 24, track 1
 dw trackDef1_HS ; $0197: [$01DF] pattern 24, track 2
 dw trackDef2_HS ; $0199: [$0231] pattern 24, track 3
pattern25Definition_HS:
 db $00 ; $019B: pattern 25 state
 dw trackDef1_HS ; $019C: [$01DF] pattern 25, track 1
 dw trackDef1_HS ; $019E: [$01DF] pattern 25, track 2
 dw trackDef2_HS ; $01A0: [$0231] pattern 25, track 3
pattern26Definition_HS:
 db $00 ; $01A2: pattern 26 state
 dw trackDef1_HS ; $01A3: [$01DF] pattern 26, track 1
 dw trackDef27_HS ; $01A5: [$02B8] pattern 26, track 2
 dw trackDef2_HS ; $01A7: [$0231] pattern 26, track 3
pattern27Definition_HS:
 db $00 ; $01A9: pattern 27 state
 dw trackDef1_HS ; $01AA: [$01DF] pattern 27, track 1
 dw trackDef11_HS ; $01AC: [$0276] pattern 27, track 2
 dw trackDef2_HS ; $01AE: [$0231] pattern 27, track 3
pattern28Definition_HS:
 db $00 ; $01B0: pattern 28 state
 dw trackDef1_HS ; $01B1: [$01DF] pattern 28, track 1
 dw trackDef11_HS ; $01B3: [$0276] pattern 28, track 2
 dw trackDef2_HS ; $01B5: [$0231] pattern 28, track 3
pattern29Definition_HS:
 db $00 ; $01B7: pattern 29 state
 dw trackDef1_HS ; $01B8: [$01DF] pattern 29, track 1
 dw trackDef13_HS ; $01BA: [$0298] pattern 29, track 2
 dw trackDef2_HS ; $01BC: [$0231] pattern 29, track 3
pattern30Definition_HS:
 db $00 ; $01BE: pattern 30 state
 dw trackDef1_HS ; $01BF: [$01DF] pattern 30, track 1
 dw trackDef1_HS ; $01C1: [$01DF] pattern 30, track 2
 dw trackDef2_HS ; $01C3: [$0231] pattern 30, track 3
pattern31Definition_HS:
 db $00 ; $01C5: pattern 31 state
 dw trackDef1_HS ; $01C6: [$01DF] pattern 31, track 1
 dw trackDef1_HS ; $01C8: [$01DF] pattern 31, track 2
 dw trackDef2_HS ; $01CA: [$0231] pattern 31, track 3
pattern32Definition_HS:
 db $00 ; $01CC: pattern 32 state
 dw trackDef1_HS ; $01CD: [$01DF] pattern 32, track 1
 dw trackDef1_HS ; $01CF: [$01DF] pattern 32, track 2
 dw trackDef2_HS ; $01D1: [$0231] pattern 32, track 3
pattern33Definition_HS:
 db $00 ; $01D3: pattern 33 state
 dw trackDef1_HS ; $01D4: [$01DF] pattern 33, track 1
 dw trackDef1_HS ; $01D6: [$01DF] pattern 33, track 2
 dw trackDef31_HS ; $01D8: [$01E4] pattern 33, track 3
pattern34Definition_HS:
 db $01 ; $01DA: pattern 34 state
 dw pattern0Definition_HS ; $01DB: [$00EC] song restart address
specialtrackDef0_HS:
 db $1D ; $01DD: data, speed 7
 db $00 ; $01DE: wait 128
trackDef1_HS:
 db $42 ; $01DF: normal track data
 db $80 ; $01E0: vol off, pitch, no note, no instrument
 dw $0000 ; $01E1: pitch
 db $00 ; $01E3: track end signature found
trackDef31_HS:
 db $BA ; $01E4: normal track data
 db $E1 ; $01E5: vol = $F (inverted), no pitch, no note, no instrument
 dw $0000 ; $01E6: pitch
 db $01 ; $01E8: instrument
 db $04 ; $01E9: normal track data,  wait 1
 db $BA ; $01EA: normal track data,  note: C5
 db $4D ; $01EB: vol = $9 (inverted), no pitch, no note, no instrument
 db $BA ; $01EC: normal track data
 db $41 ; $01ED: vol = $F (inverted), no pitch, no note, no instrument
 db $04 ; $01EE: normal track data,  wait 1
 db $BA ; $01EF: normal track data,  note: C5
 db $4D ; $01F0: vol = $9 (inverted), no pitch, no note, no instrument
 db $BA ; $01F1: normal track data
 db $41 ; $01F2: vol = $F (inverted), no pitch, no note, no instrument
 db $04 ; $01F3: normal track data,  wait 1
 db $BA ; $01F4: normal track data,  note: C5
 db $4D ; $01F5: vol = $9 (inverted), no pitch, no note, no instrument
 db $A2 ; $01F6: normal track data
 db $61 ; $01F7: vol = $F (inverted), no pitch, no note, no instrument
 db $02 ; $01F8: instrument
 db $02 ; $01F9: normal track data,  wait 0
 db $A2 ; $01FA: normal track data,  note: C4
 db $4F ; $01FB: vol = $8 (inverted), no pitch, no note, no instrument
 db $A2 ; $01FC: normal track data
 db $41 ; $01FD: vol = $F (inverted), no pitch, no note, no instrument
trackDef0_HS:
 db $62 ; $01FE: normal track data
 db $E0 ; $01FF: vol off, pitch, note, instrument
 dw $0000 ; $0200: pitch
 db $03 ; $0202: instrument
 db $06 ; $0203: normal track data,  wait 2
 db $3B ; $0204: full optimization, no escape: E2
 db $04 ; $0205: normal track data,  wait 1
 db $37 ; $0206: full optimization, no escape: D2
 db $04 ; $0207: normal track data,  wait 1
 db $3B ; $0208: full optimization, no escape: E2
 db $02 ; $0209: normal track data,  wait 0
 db $31 ; $020A: full optimization, no escape: B1
 db $02 ; $020B: normal track data,  wait 0
 db $37 ; $020C: full optimization, no escape: D2
 db $00 ; $020D: track end signature found
trackDef6_HS:
 db $7A ; $020E: normal track data
 db $E1 ; $020F: vol = $F (inverted), no pitch, no note, no instrument
 dw $0000 ; $0210: pitch
 db $04 ; $0212: instrument
 db $8E ; $0213: normal track data
 db $4B ; $0214: vol = $A (inverted), no pitch, no note, no instrument
 db $92 ; $0215: normal track data
 db $41 ; $0216: vol = $F (inverted), no pitch, no note, no instrument
 db $7A ; $0217: normal track data
 db $4B ; $0218: vol = $A (inverted), no pitch, no note, no instrument
 db $8E ; $0219: normal track data
 db $41 ; $021A: vol = $F (inverted), no pitch, no note, no instrument
 db $92 ; $021B: normal track data
 db $4B ; $021C: vol = $A (inverted), no pitch, no note, no instrument
 db $92 ; $021D: normal track data
 db $41 ; $021E: vol = $F (inverted), no pitch, no note, no instrument
 db $8E ; $021F: normal track data
 db $4B ; $0220: vol = $A (inverted), no pitch, no note, no instrument
 db $9C ; $0221: normal track data
 db $41 ; $0222: vol = $F (inverted), no pitch, no note, no instrument
 db $92 ; $0223: normal track data
 db $4B ; $0224: vol = $A (inverted), no pitch, no note, no instrument
 db $A0 ; $0225: normal track data
 db $41 ; $0226: vol = $F (inverted), no pitch, no note, no instrument
 db $9C ; $0227: normal track data
 db $4B ; $0228: vol = $A (inverted), no pitch, no note, no instrument
 db $88 ; $0229: normal track data
 db $41 ; $022A: vol = $F (inverted), no pitch, no note, no instrument
 db $A0 ; $022B: normal track data
 db $4B ; $022C: vol = $A (inverted), no pitch, no note, no instrument
 db $8E ; $022D: normal track data
 db $41 ; $022E: vol = $F (inverted), no pitch, no note, no instrument
 db $88 ; $022F: normal track data
 db $4B ; $0230: vol = $A (inverted), no pitch, no note, no instrument
trackDef2_HS:
 db $BA ; $0231: normal track data
 db $E0 ; $0232: vol off, pitch, note, instrument
 dw $0000 ; $0233: pitch
 db $01 ; $0235: instrument
 db $02 ; $0236: normal track data,  wait 0
 db $8A ; $0237: normal track data
 db $60 ; $0238: vol off, no pitch, note, instrument
 db $05 ; $0239: instrument
 db $02 ; $023A: normal track data,  wait 0
 db $A2 ; $023B: normal track data
 db $60 ; $023C: vol off, no pitch, note, instrument
 db $02 ; $023D: instrument
 db $02 ; $023E: normal track data,  wait 0
 db $8A ; $023F: normal track data
 db $60 ; $0240: vol off, no pitch, note, instrument
 db $06 ; $0241: instrument
 db $02 ; $0242: normal track data,  wait 0
 db $8A ; $0243: normal track data
 db $60 ; $0244: vol off, no pitch, note, instrument
 db $05 ; $0245: instrument
 db $02 ; $0246: normal track data,  wait 0
 db $BA ; $0247: normal track data
 db $60 ; $0248: vol off, no pitch, note, instrument
 db $01 ; $0249: instrument
 db $02 ; $024A: normal track data,  wait 0
 db $A2 ; $024B: normal track data
 db $60 ; $024C: vol off, no pitch, note, instrument
 db $02 ; $024D: instrument
 db $02 ; $024E: normal track data,  wait 0
 db $8A ; $024F: normal track data
 db $60 ; $0250: vol off, no pitch, note, instrument
 db $06 ; $0251: instrument
 db $00 ; $0252: track end signature found
trackDef10_HS:
 db $92 ; $0253: normal track data,  note: E3
 db $E7 ; $0254: vol = $C (inverted), no pitch, no note, no instrument
 dw $0001 ; $0255: pitch
 db $07 ; $0257: instrument
 db $42 ; $0258: normal track data,  note: C0
 db $05 ; $0259: vol = $D (inverted), no pitch, no note, no instrument
 db $42 ; $025A: normal track data
 db $03 ; $025B: vol = $E (inverted), no pitch, no note, no instrument
 db $42 ; $025C: normal track data
 db $01 ; $025D: vol = $F (inverted), no pitch, no note, no instrument
 db $42 ; $025E: normal track data
 db $00 ; $025F: vol off, no pitch, no note, no instrument
 db $42 ; $0260: normal track data
 db $00 ; $0261: vol off, no pitch, no note, no instrument
 db $42 ; $0262: normal track data
 db $00 ; $0263: vol off, no pitch, no note, no instrument
 db $42 ; $0264: normal track data
 db $00 ; $0265: vol off, no pitch, no note, no instrument
 db $42 ; $0266: normal track data
 db $00 ; $0267: vol off, no pitch, no note, no instrument
 db $42 ; $0268: normal track data
 db $00 ; $0269: vol off, no pitch, no note, no instrument
 db $42 ; $026A: normal track data
 db $00 ; $026B: vol off, no pitch, no note, no instrument
 db $42 ; $026C: normal track data
 db $00 ; $026D: vol off, no pitch, no note, no instrument
 db $42 ; $026E: normal track data
 db $00 ; $026F: vol off, no pitch, no note, no instrument
 db $42 ; $0270: normal track data
 db $00 ; $0271: vol off, no pitch, no note, no instrument
 db $42 ; $0272: normal track data
 db $00 ; $0273: vol off, no pitch, no note, no instrument
 db $42 ; $0274: normal track data
 db $00 ; $0275: vol off, no pitch, no note, no instrument
trackDef11_HS:
 db $42 ; $0276: normal track data
 db $80 ; $0277: vol off, pitch, no note, no instrument
 dw $0001 ; $0278: pitch
 db $42 ; $027A: normal track data
 db $00 ; $027B: vol off, no pitch, no note, no instrument
 db $42 ; $027C: normal track data
 db $00 ; $027D: vol off, no pitch, no note, no instrument
 db $42 ; $027E: normal track data
 db $00 ; $027F: vol off, no pitch, no note, no instrument
 db $42 ; $0280: normal track data
 db $00 ; $0281: vol off, no pitch, no note, no instrument
 db $42 ; $0282: normal track data
 db $00 ; $0283: vol off, no pitch, no note, no instrument
 db $42 ; $0284: normal track data
 db $00 ; $0285: vol off, no pitch, no note, no instrument
 db $42 ; $0286: normal track data
 db $00 ; $0287: vol off, no pitch, no note, no instrument
 db $42 ; $0288: normal track data
 db $00 ; $0289: vol off, no pitch, no note, no instrument
 db $42 ; $028A: normal track data
 db $00 ; $028B: vol off, no pitch, no note, no instrument
 db $42 ; $028C: normal track data
 db $00 ; $028D: vol off, no pitch, no note, no instrument
 db $42 ; $028E: normal track data
 db $00 ; $028F: vol off, no pitch, no note, no instrument
 db $42 ; $0290: normal track data
 db $00 ; $0291: vol off, no pitch, no note, no instrument
 db $42 ; $0292: normal track data
 db $00 ; $0293: vol off, no pitch, no note, no instrument
 db $42 ; $0294: normal track data
 db $00 ; $0295: vol off, no pitch, no note, no instrument
 db $42 ; $0296: normal track data
 db $00 ; $0297: vol off, no pitch, no note, no instrument
trackDef13_HS:
 db $42 ; $0298: normal track data
 db $83 ; $0299: vol = $E (inverted), no pitch, no note, no instrument
 dw $0000 ; $029A: pitch
 db $42 ; $029C: normal track data,  note: C0
 db $05 ; $029D: vol = $D (inverted), no pitch, no note, no instrument
 db $42 ; $029E: normal track data,  note: C0
 db $07 ; $029F: vol = $C (inverted), no pitch, no note, no instrument
 db $02 ; $02A0: normal track data,  wait 0
 db $42 ; $02A1: normal track data
 db $09 ; $02A2: vol = $B (inverted), no pitch, no note, no instrument
 db $42 ; $02A3: normal track data
 db $0B ; $02A4: vol = $A (inverted), no pitch, no note, no instrument
 db $42 ; $02A5: normal track data,  note: C0
 db $0D ; $02A6: vol = $9 (inverted), no pitch, no note, no instrument
 db $02 ; $02A7: normal track data,  wait 0
 db $42 ; $02A8: normal track data,  note: C0
 db $0F ; $02A9: vol = $8 (inverted), no pitch, no note, no instrument
 db $42 ; $02AA: normal track data
 db $11 ; $02AB: vol = $7 (inverted), no pitch, no note, no instrument
 db $42 ; $02AC: normal track data
 db $13 ; $02AD: vol = $6 (inverted), no pitch, no note, no instrument
 db $42 ; $02AE: normal track data,  note: C0
 db $15 ; $02AF: vol = $5 (inverted), no pitch, no note, no instrument
 db $42 ; $02B0: normal track data,  note: C0
 db $17 ; $02B1: vol = $4 (inverted), no pitch, no note, no instrument
 db $42 ; $02B2: normal track data
 db $19 ; $02B3: vol = $3 (inverted), no pitch, no note, no instrument
 db $42 ; $02B4: normal track data
 db $1B ; $02B5: vol = $2 (inverted), no pitch, no note, no instrument
 db $42 ; $02B6: normal track data,  note: C0
 db $1F ; $02B7: vol = $0 (inverted), no pitch, no note, no instrument
trackDef27_HS:
 db $92 ; $02B8: normal track data,  note: E3
 db $E7 ; $02B9: vol = $C (inverted), no pitch, no note, no instrument
 dw $0001 ; $02BA: pitch
 db $08 ; $02BC: instrument
 db $42 ; $02BD: normal track data,  note: C0
 db $05 ; $02BE: vol = $D (inverted), no pitch, no note, no instrument
 db $42 ; $02BF: normal track data
 db $03 ; $02C0: vol = $E (inverted), no pitch, no note, no instrument
 db $42 ; $02C1: normal track data
 db $01 ; $02C2: vol = $F (inverted), no pitch, no note, no instrument
 db $42 ; $02C3: normal track data
 db $00 ; $02C4: vol off, no pitch, no note, no instrument
 db $42 ; $02C5: normal track data
 db $00 ; $02C6: vol off, no pitch, no note, no instrument
 db $42 ; $02C7: normal track data
 db $00 ; $02C8: vol off, no pitch, no note, no instrument
 db $42 ; $02C9: normal track data
 db $00 ; $02CA: vol off, no pitch, no note, no instrument
 db $42 ; $02CB: normal track data
 db $00 ; $02CC: vol off, no pitch, no note, no instrument
 db $42 ; $02CD: normal track data
 db $00 ; $02CE: vol off, no pitch, no note, no instrument
 db $42 ; $02CF: normal track data
 db $00 ; $02D0: vol off, no pitch, no note, no instrument
 db $42 ; $02D1: normal track data
 db $00 ; $02D2: vol off, no pitch, no note, no instrument
 db $42 ; $02D3: normal track data
 db $00 ; $02D4: vol off, no pitch, no note, no instrument
 db $42 ; $02D5: normal track data
 db $00 ; $02D6: vol off, no pitch, no note, no instrument
 db $42 ; $02D7: normal track data
 db $00 ; $02D8: vol off, no pitch, no note, no instrument
 db $42 ; $02D9: normal track data
 db $00 ; $02DA: vol off, no pitch, no note, no instrument