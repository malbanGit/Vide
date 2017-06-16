
; This file was build using VIDE - Vectrex Integrated Development Environment
; Original bin file was: projects/VRelease/VTK_TitleMusic.bin
; 
; offset for AKS file assumed: $0000 guessed by accessing byte data[13] * 256)
; not used by vectrex player and therefor omitted:
;  DB "AT10" ; Signature of Arkos Tracker files
;  DB $01 ; sample channel
;  DB $40, 42, 0f ; YM custom frequence - little endian
;  DB $02 ; Replay frequency (0=13hz,1=25hz,2=50hz,3=100hz,4=150hz,5=300hz)
 db $06 ; $0009: default speed
 dw $016C ; $000A: size of instrument table (without this word pointer)
 dw instrument0TitleMusik ; $000C: [$0032] pointer to instrument 0
 dw instrument1TitleMusik ; $000E: [$003B] pointer to instrument 1
 dw instrument2TitleMusik ; $0010: [$0043] pointer to instrument 2
 dw instrument3TitleMusik ; $0012: [$0053] pointer to instrument 3
 dw instrument4TitleMusik ; $0014: [$0062] pointer to instrument 4
 dw instrument5TitleMusik ; $0016: [$0070] pointer to instrument 5
 dw instrument6TitleMusik ; $0018: [$007E] pointer to instrument 6
 dw instrument7TitleMusik ; $001A: [$0087] pointer to instrument 7
 dw instrument8TitleMusik ; $001C: [$0094] pointer to instrument 8
 dw instrument9TitleMusik ; $001E: [$009D] pointer to instrument 9
 dw instrument10TitleMusik ; $0020: [$00B6] pointer to instrument 10
 dw instrument11TitleMusik ; $0022: [$00C8] pointer to instrument 11
 dw instrument12TitleMusik ; $0024: [$00DD] pointer to instrument 12
 dw instrument13TitleMusik ; $0026: [$00EF] pointer to instrument 13
 dw instrument14TitleMusik ; $0028: [$00F9] pointer to instrument 14
 dw instrument15TitleMusik ; $002A: [$0104] pointer to instrument 15
 dw instrument16TitleMusik ; $002C: [$011D] pointer to instrument 16
 dw instrument17TitleMusik ; $002E: [$0146] pointer to instrument 17
 dw instrument18TitleMusik ; $0030: [$015F] pointer to instrument 18
instrument0TitleMusik:
 db $00 ; $0032: speed
 db $00 ; $0033: retrig
instrument0loopTitleMusik:
 db $00 ; $0034: dataColumn_0 (non hard), vol=$0
 db $00 ; $0035: dataColumn_0 (non hard), vol=$0
 db $00 ; $0036: dataColumn_0 (non hard), vol=$0
 db $00 ; $0037: dataColumn_0 (non hard), vol=$0
 db $0D ; $0038: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $0039: [$0034] loop
instrument1TitleMusik:
 db $03 ; $003B: speed
 db $00 ; $003C: retrig
instrument1loopTitleMusik:
 db $3C ; $003D: dataColumn_0 (non hard), vol=$F
 db $7C ; $003E: dataColumn_0 (non hard), vol=$F
 db $0C ; $003F: arpegio
 db $0D ; $0040: dataColumn_0 (hard)
 dw instrument1loopTitleMusik ; $0041: [$003D] loop
instrument2TitleMusik:
 db $01 ; $0043: speed
 db $00 ; $0044: retrig
 db $B8 ; $0045: dataColumn_0 (non hard), vol=$E
 dw $FFFF ; $0046: pitch
 db $34 ; $0048: dataColumn_0 (non hard), vol=$D
 db $B0 ; $0049: dataColumn_0 (non hard), vol=$C
 dw $0001 ; $004A: pitch
 db $2C ; $004C: dataColumn_0 (non hard), vol=$B
 db $AC ; $004D: dataColumn_0 (non hard), vol=$B
 dw $0001 ; $004E: pitch
 db $0D ; $0050: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $0051: [$0034] loop
instrument3TitleMusik:
 db $01 ; $0053: speed
 db $00 ; $0054: retrig
 db $28 ; $0055: dataColumn_0 (non hard), vol=$A
 db $24 ; $0056: dataColumn_0 (non hard), vol=$9
 db $24 ; $0057: dataColumn_0 (non hard), vol=$9
 db $20 ; $0058: dataColumn_0 (non hard), vol=$8
 db $1C ; $0059: dataColumn_0 (non hard), vol=$7
 db $18 ; $005A: dataColumn_0 (non hard), vol=$6
instrument3loopTitleMusik:
 db $14 ; $005B: dataColumn_0 (non hard), vol=$5
 db $14 ; $005C: dataColumn_0 (non hard), vol=$5
 db $14 ; $005D: dataColumn_0 (non hard), vol=$5
 db $14 ; $005E: dataColumn_0 (non hard), vol=$5
 db $0D ; $005F: dataColumn_0 (hard)
 dw instrument3loopTitleMusik ; $0060: [$005B] loop
instrument4TitleMusik:
 db $03 ; $0062: speed
 db $00 ; $0063: retrig
 db $78 ; $0064: dataColumn_0 (non hard), vol=$E
 db $0C ; $0065: arpegio
 db $30 ; $0066: dataColumn_0 (non hard), vol=$C
 db $28 ; $0067: dataColumn_0 (non hard), vol=$A
 db $24 ; $0068: dataColumn_0 (non hard), vol=$9
 db $24 ; $0069: dataColumn_0 (non hard), vol=$9
 db $20 ; $006A: dataColumn_0 (non hard), vol=$8
 db $1C ; $006B: dataColumn_0 (non hard), vol=$7
 db $18 ; $006C: dataColumn_0 (non hard), vol=$6
 db $0D ; $006D: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $006E: [$0034] loop
instrument5TitleMusik:
 db $01 ; $0070: speed
 db $00 ; $0071: retrig
 db $7E ; $0072: dataColumn_0 (non hard), vol=$F
 db $2C ; $0073: dataColumn_1, noise=$0C
 db $17 ; $0074: arpegio
 db $78 ; $0075: dataColumn_0 (non hard), vol=$E
 db $15 ; $0076: arpegio
 db $78 ; $0077: dataColumn_0 (non hard), vol=$E
 db $10 ; $0078: arpegio
 db $38 ; $0079: dataColumn_0 (non hard), vol=$E
 db $38 ; $007A: dataColumn_0 (non hard), vol=$E
 db $0D ; $007B: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $007C: [$0034] loop
instrument6TitleMusik:
 db $01 ; $007E: speed
 db $00 ; $007F: retrig
 db $2A ; $0080: dataColumn_0 (non hard), vol=$A
 db $01 ; $0081: dataColumn_1, noise=$01
 db $2E ; $0082: dataColumn_0 (non hard), vol=$B
 db $01 ; $0083: dataColumn_1, noise=$01
 db $0D ; $0084: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $0085: [$0034] loop
instrument7TitleMusik:
 db $03 ; $0087: speed
 db $00 ; $0088: retrig
 db $7C ; $0089: dataColumn_0 (non hard), vol=$F
 db $18 ; $008A: arpegio
 db $70 ; $008B: dataColumn_0 (non hard), vol=$C
 db $0C ; $008C: arpegio
 db $6C ; $008D: dataColumn_0 (non hard), vol=$B
 db $0C ; $008E: arpegio
 db $64 ; $008F: dataColumn_0 (non hard), vol=$9
 db $0C ; $0090: arpegio
 db $0D ; $0091: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $0092: [$0034] loop
instrument8TitleMusik:
 db $01 ; $0094: speed
 db $00 ; $0095: retrig
 db $2A ; $0096: dataColumn_0 (non hard), vol=$A
 db $03 ; $0097: dataColumn_1, noise=$03
 db $26 ; $0098: dataColumn_0 (non hard), vol=$9
 db $03 ; $0099: dataColumn_1, noise=$03
 db $0D ; $009A: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $009B: [$0034] loop
instrument9TitleMusik:
 db $03 ; $009D: speed
 db $00 ; $009E: retrig
 db $30 ; $009F: dataColumn_0 (non hard), vol=$C
 db $70 ; $00A0: dataColumn_0 (non hard), vol=$C
 db $03 ; $00A1: arpegio
 db $6C ; $00A2: dataColumn_0 (non hard), vol=$B
 db $07 ; $00A3: arpegio
 db $28 ; $00A4: dataColumn_0 (non hard), vol=$A
 db $68 ; $00A5: dataColumn_0 (non hard), vol=$A
 db $03 ; $00A6: arpegio
 db $64 ; $00A7: dataColumn_0 (non hard), vol=$9
 db $07 ; $00A8: arpegio
 db $24 ; $00A9: dataColumn_0 (non hard), vol=$9
 db $60 ; $00AA: dataColumn_0 (non hard), vol=$8
 db $03 ; $00AB: arpegio
 db $60 ; $00AC: dataColumn_0 (non hard), vol=$8
 db $07 ; $00AD: arpegio
 db $20 ; $00AE: dataColumn_0 (non hard), vol=$8
 db $58 ; $00AF: dataColumn_0 (non hard), vol=$6
 db $03 ; $00B0: arpegio
 db $54 ; $00B1: dataColumn_0 (non hard), vol=$5
 db $07 ; $00B2: arpegio
 db $0D ; $00B3: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $00B4: [$0034] loop
instrument10TitleMusik:
 db $03 ; $00B6: speed
 db $00 ; $00B7: retrig
 db $30 ; $00B8: dataColumn_0 (non hard), vol=$C
 db $70 ; $00B9: dataColumn_0 (non hard), vol=$C
 db $05 ; $00BA: arpegio
 db $6C ; $00BB: dataColumn_0 (non hard), vol=$B
 db $08 ; $00BC: arpegio
 db $20 ; $00BD: dataColumn_0 (non hard), vol=$8
 db $5C ; $00BE: dataColumn_0 (non hard), vol=$7
 db $05 ; $00BF: arpegio
 db $54 ; $00C0: dataColumn_0 (non hard), vol=$5
 db $08 ; $00C1: arpegio
 db $10 ; $00C2: dataColumn_0 (non hard), vol=$4
 db $4C ; $00C3: dataColumn_0 (non hard), vol=$3
 db $05 ; $00C4: arpegio
 db $0D ; $00C5: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $00C6: [$0034] loop
instrument11TitleMusik:
 db $01 ; $00C8: speed
 db $00 ; $00C9: retrig
 db $7E ; $00CA: dataColumn_0 (non hard), vol=$F
 db $22 ; $00CB: dataColumn_1, noise=$02
 db $18 ; $00CC: arpegio
 db $7C ; $00CD: dataColumn_0 (non hard), vol=$F
 db $1C ; $00CE: arpegio
 db $7C ; $00CF: dataColumn_0 (non hard), vol=$F
 db $1E ; $00D0: arpegio
 db $7A ; $00D1: dataColumn_0 (non hard), vol=$E
 db $23 ; $00D2: dataColumn_1, noise=$03
 db $30 ; $00D3: arpegio
 db $76 ; $00D4: dataColumn_0 (non hard), vol=$D
 db $22 ; $00D5: dataColumn_1, noise=$02
 db $18 ; $00D6: arpegio
 db $72 ; $00D7: dataColumn_0 (non hard), vol=$C
 db $23 ; $00D8: dataColumn_1, noise=$03
 db $18 ; $00D9: arpegio
 db $0D ; $00DA: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $00DB: [$0034] loop
instrument12TitleMusik:
 db $03 ; $00DD: speed
 db $00 ; $00DE: retrig
 db $30 ; $00DF: dataColumn_0 (non hard), vol=$C
 db $70 ; $00E0: dataColumn_0 (non hard), vol=$C
 db $05 ; $00E1: arpegio
 db $6C ; $00E2: dataColumn_0 (non hard), vol=$B
 db $07 ; $00E3: arpegio
 db $20 ; $00E4: dataColumn_0 (non hard), vol=$8
 db $5C ; $00E5: dataColumn_0 (non hard), vol=$7
 db $05 ; $00E6: arpegio
 db $54 ; $00E7: dataColumn_0 (non hard), vol=$5
 db $07 ; $00E8: arpegio
 db $10 ; $00E9: dataColumn_0 (non hard), vol=$4
 db $4C ; $00EA: dataColumn_0 (non hard), vol=$3
 db $05 ; $00EB: arpegio
 db $0D ; $00EC: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $00ED: [$0034] loop
instrument13TitleMusik:
 db $01 ; $00EF: speed
 db $00 ; $00F0: retrig
 db $6C ; $00F1: dataColumn_0 (non hard), vol=$B
 db $0C ; $00F2: arpegio
 db $24 ; $00F3: dataColumn_0 (non hard), vol=$9
 db $60 ; $00F4: dataColumn_0 (non hard), vol=$8
 db $0C ; $00F5: arpegio
 db $0D ; $00F6: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $00F7: [$0034] loop
instrument14TitleMusik:
 db $01 ; $00F9: speed
 db $00 ; $00FA: retrig
 db $2C ; $00FB: dataColumn_0 (non hard), vol=$B
 db $6C ; $00FC: dataColumn_0 (non hard), vol=$B
 db $0C ; $00FD: arpegio
 db $18 ; $00FE: dataColumn_0 (non hard), vol=$6
 db $54 ; $00FF: dataColumn_0 (non hard), vol=$5
 db $18 ; $0100: arpegio
 db $0D ; $0101: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $0102: [$0034] loop
instrument15TitleMusik:
 db $01 ; $0104: speed
 db $00 ; $0105: retrig
instrument15loopTitleMusik:
 db $F0 ; $0106: dataColumn_0 (non hard), vol=$C
 dw $FFFF ; $0107: pitch
 db $32 ; $0109: arpegio
 db $6C ; $010A: dataColumn_0 (non hard), vol=$B
 db $21 ; $010B: arpegio
 db $68 ; $010C: dataColumn_0 (non hard), vol=$A
 db $1C ; $010D: arpegio
 db $70 ; $010E: dataColumn_0 (non hard), vol=$C
 db $18 ; $010F: arpegio
 db $68 ; $0110: dataColumn_0 (non hard), vol=$A
 db $32 ; $0111: arpegio
 db $EC ; $0112: dataColumn_0 (non hard), vol=$B
 dw $FFFC ; $0113: pitch
 db $0F ; $0115: arpegio
 db $68 ; $0116: dataColumn_0 (non hard), vol=$A
 db $12 ; $0117: arpegio
 db $6C ; $0118: dataColumn_0 (non hard), vol=$B
 db $2C ; $0119: arpegio
 db $0D ; $011A: dataColumn_0 (hard)
 dw instrument15loopTitleMusik ; $011B: [$0106] loop
instrument16TitleMusik:
 db $02 ; $011D: speed
 db $00 ; $011E: retrig
instrument16loopTitleMusik:
 db $F8 ; $011F: dataColumn_0 (non hard), vol=$E
 dw $FFFE ; $0120: pitch
 db $0C ; $0122: arpegio
 db $F0 ; $0123: dataColumn_0 (non hard), vol=$C
 dw $FFFF ; $0124: pitch
 db $02 ; $0126: arpegio
 db $F4 ; $0127: dataColumn_0 (non hard), vol=$D
 dw $FFFE ; $0128: pitch
 db $0C ; $012A: arpegio
 db $F8 ; $012B: dataColumn_0 (non hard), vol=$E
 dw $FFFF ; $012C: pitch
 db $02 ; $012E: arpegio
 db $F4 ; $012F: dataColumn_0 (non hard), vol=$D
 dw $FFFE ; $0130: pitch
 db $0C ; $0132: arpegio
 db $EC ; $0133: dataColumn_0 (non hard), vol=$B
 dw $FFFF ; $0134: pitch
 db $01 ; $0136: arpegio
 db $F8 ; $0137: dataColumn_0 (non hard), vol=$E
 dw $FFFE ; $0138: pitch
 db $0C ; $013A: arpegio
 db $F4 ; $013B: dataColumn_0 (non hard), vol=$D
 dw $FFFF ; $013C: pitch
 db $02 ; $013E: arpegio
 db $F4 ; $013F: dataColumn_0 (non hard), vol=$D
 dw $FFFE ; $0140: pitch
 db $0C ; $0142: arpegio
 db $0D ; $0143: dataColumn_0 (hard)
 dw instrument16loopTitleMusik ; $0144: [$011F] loop
instrument17TitleMusik:
 db $03 ; $0146: speed
 db $00 ; $0147: retrig
 db $30 ; $0148: dataColumn_0 (non hard), vol=$C
 db $70 ; $0149: dataColumn_0 (non hard), vol=$C
 db $02 ; $014A: arpegio
 db $6C ; $014B: dataColumn_0 (non hard), vol=$B
 db $07 ; $014C: arpegio
 db $28 ; $014D: dataColumn_0 (non hard), vol=$A
 db $68 ; $014E: dataColumn_0 (non hard), vol=$A
 db $02 ; $014F: arpegio
 db $64 ; $0150: dataColumn_0 (non hard), vol=$9
 db $07 ; $0151: arpegio
 db $24 ; $0152: dataColumn_0 (non hard), vol=$9
 db $60 ; $0153: dataColumn_0 (non hard), vol=$8
 db $02 ; $0154: arpegio
 db $60 ; $0155: dataColumn_0 (non hard), vol=$8
 db $07 ; $0156: arpegio
 db $20 ; $0157: dataColumn_0 (non hard), vol=$8
 db $58 ; $0158: dataColumn_0 (non hard), vol=$6
 db $02 ; $0159: arpegio
 db $54 ; $015A: dataColumn_0 (non hard), vol=$5
 db $07 ; $015B: arpegio
 db $0D ; $015C: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $015D: [$0034] loop
instrument18TitleMusik:
 db $03 ; $015F: speed
 db $00 ; $0160: retrig
 db $30 ; $0161: dataColumn_0 (non hard), vol=$C
 db $70 ; $0162: dataColumn_0 (non hard), vol=$C
 db $05 ; $0163: arpegio
 db $6C ; $0164: dataColumn_0 (non hard), vol=$B
 db $07 ; $0165: arpegio
 db $28 ; $0166: dataColumn_0 (non hard), vol=$A
 db $68 ; $0167: dataColumn_0 (non hard), vol=$A
 db $05 ; $0168: arpegio
 db $64 ; $0169: dataColumn_0 (non hard), vol=$9
 db $07 ; $016A: arpegio
 db $24 ; $016B: dataColumn_0 (non hard), vol=$9
 db $60 ; $016C: dataColumn_0 (non hard), vol=$8
 db $05 ; $016D: arpegio
 db $60 ; $016E: dataColumn_0 (non hard), vol=$8
 db $07 ; $016F: arpegio
 db $20 ; $0170: dataColumn_0 (non hard), vol=$8
 db $58 ; $0171: dataColumn_0 (non hard), vol=$6
 db $05 ; $0172: arpegio
 db $54 ; $0173: dataColumn_0 (non hard), vol=$5
 db $07 ; $0174: arpegio
 db $0D ; $0175: dataColumn_0 (hard)
 dw instrument0loopTitleMusik ; $0176: [$0034] loop
; start of linker definition
linkerTitleMusik:
 db $20 ; $0178: first height
 db $00 ; $0179: transposition1
 db $00 ; $017A: transposition2
 db $00 ; $017B: transposition3
 dw specialtrackDef0TitleMusik ; $017C: [$039F] specialTrack
pattern0DefinitionTitleMusik:
 db $10 ; $017E: pattern 0 state
 dw trackDef0TitleMusik ; $017F: [$03A6] pattern 0, track 1
 dw trackDef1TitleMusik ; $0181: [$03A1] pattern 0, track 2
 dw trackDef1TitleMusik ; $0183: [$03A1] pattern 0, track 3
 db $20 ; $0185: new height
pattern1DefinitionTitleMusik:
 db $10 ; $0186: pattern 1 state
 dw trackDef3TitleMusik ; $0187: [$03EB] pattern 1, track 1
 dw trackDef1TitleMusik ; $0189: [$03A1] pattern 1, track 2
 dw trackDef1TitleMusik ; $018B: [$03A1] pattern 1, track 3
 db $0D ; $018D: new height
pattern2DefinitionTitleMusik:
 db $10 ; $018E: pattern 2 state
 dw trackDef4TitleMusik ; $018F: [$03F8] pattern 2, track 1
 dw trackDef5TitleMusik ; $0191: [$0428] pattern 2, track 2
 dw trackDef6TitleMusik ; $0193: [$044B] pattern 2, track 3
 db $10 ; $0195: new height
pattern3DefinitionTitleMusik:
 db $00 ; $0196: pattern 3 state
 dw trackDef7TitleMusik ; $0197: [$0406] pattern 3, track 1
 dw trackDef5TitleMusik ; $0199: [$0428] pattern 3, track 2
 dw trackDef6TitleMusik ; $019B: [$044B] pattern 3, track 3
pattern4DefinitionTitleMusik:
 db $00 ; $019D: pattern 4 state
 dw trackDef9TitleMusik ; $019E: [$0413] pattern 4, track 1
 dw trackDef5TitleMusik ; $01A0: [$0428] pattern 4, track 2
 dw trackDef6TitleMusik ; $01A2: [$044B] pattern 4, track 3
pattern5DefinitionTitleMusik:
 db $00 ; $01A4: pattern 5 state
 dw trackDef1TitleMusik ; $01A5: [$03A1] pattern 5, track 1
 dw trackDef5TitleMusik ; $01A7: [$0428] pattern 5, track 2
 dw trackDef6TitleMusik ; $01A9: [$044B] pattern 5, track 3
pattern6DefinitionTitleMusik:
 db $00 ; $01AB: pattern 6 state
 dw trackDef1TitleMusik ; $01AC: [$03A1] pattern 6, track 1
 dw trackDef5TitleMusik ; $01AE: [$0428] pattern 6, track 2
 dw trackDef6TitleMusik ; $01B0: [$044B] pattern 6, track 3
pattern7DefinitionTitleMusik:
 db $00 ; $01B2: pattern 7 state
 dw trackDef1TitleMusik ; $01B3: [$03A1] pattern 7, track 1
 dw trackDef5TitleMusik ; $01B5: [$0428] pattern 7, track 2
 dw trackDef6TitleMusik ; $01B7: [$044B] pattern 7, track 3
pattern8DefinitionTitleMusik:
 db $00 ; $01B9: pattern 8 state
 dw trackDef1TitleMusik ; $01BA: [$03A1] pattern 8, track 1
 dw trackDef5TitleMusik ; $01BC: [$0428] pattern 8, track 2
 dw trackDef6TitleMusik ; $01BE: [$044B] pattern 8, track 3
pattern9DefinitionTitleMusik:
 db $00 ; $01C0: pattern 9 state
 dw trackDef1TitleMusik ; $01C1: [$03A1] pattern 9, track 1
 dw trackDef5TitleMusik ; $01C3: [$0428] pattern 9, track 2
 dw trackDef6TitleMusik ; $01C5: [$044B] pattern 9, track 3
pattern10DefinitionTitleMusik:
 db $02 ; $01C7: pattern 10 state
 db $07 ; $01C8: transposition 1
 dw trackDef16TitleMusik ; $01C9: [$046E] pattern 10, track 1
 dw trackDef5TitleMusik ; $01CB: [$0428] pattern 10, track 2
 dw trackDef6TitleMusik ; $01CD: [$044B] pattern 10, track 3
pattern11DefinitionTitleMusik:
 db $00 ; $01CF: pattern 11 state
 dw trackDef16TitleMusik ; $01D0: [$046E] pattern 11, track 1
 dw trackDef5TitleMusik ; $01D2: [$0428] pattern 11, track 2
 dw trackDef6TitleMusik ; $01D4: [$044B] pattern 11, track 3
pattern12DefinitionTitleMusik:
 db $00 ; $01D6: pattern 12 state
 dw trackDef16TitleMusik ; $01D7: [$046E] pattern 12, track 1
 dw trackDef5TitleMusik ; $01D9: [$0428] pattern 12, track 2
 dw trackDef6TitleMusik ; $01DB: [$044B] pattern 12, track 3
pattern13DefinitionTitleMusik:
 db $00 ; $01DD: pattern 13 state
 dw trackDef16TitleMusik ; $01DE: [$046E] pattern 13, track 1
 dw trackDef5TitleMusik ; $01E0: [$0428] pattern 13, track 2
 dw trackDef6TitleMusik ; $01E2: [$044B] pattern 13, track 3
pattern14DefinitionTitleMusik:
 db $02 ; $01E4: pattern 14 state
 db $03 ; $01E5: transposition 1
 dw trackDef16TitleMusik ; $01E6: [$046E] pattern 14, track 1
 dw trackDef5TitleMusik ; $01E8: [$0428] pattern 14, track 2
 dw trackDef6TitleMusik ; $01EA: [$044B] pattern 14, track 3
pattern15DefinitionTitleMusik:
 db $00 ; $01EC: pattern 15 state
 dw trackDef16TitleMusik ; $01ED: [$046E] pattern 15, track 1
 dw trackDef5TitleMusik ; $01EF: [$0428] pattern 15, track 2
 dw trackDef6TitleMusik ; $01F1: [$044B] pattern 15, track 3
pattern16DefinitionTitleMusik:
 db $00 ; $01F3: pattern 16 state
 dw trackDef16TitleMusik ; $01F4: [$046E] pattern 16, track 1
 dw trackDef5TitleMusik ; $01F6: [$0428] pattern 16, track 2
 dw trackDef6TitleMusik ; $01F8: [$044B] pattern 16, track 3
pattern17DefinitionTitleMusik:
 db $00 ; $01FA: pattern 17 state
 dw trackDef16TitleMusik ; $01FB: [$046E] pattern 17, track 1
 dw trackDef5TitleMusik ; $01FD: [$0428] pattern 17, track 2
 dw trackDef6TitleMusik ; $01FF: [$044B] pattern 17, track 3
pattern18DefinitionTitleMusik:
 db $02 ; $0201: pattern 18 state
 db $00 ; $0202: transposition 1
 dw trackDef16TitleMusik ; $0203: [$046E] pattern 18, track 1
 dw trackDef5TitleMusik ; $0205: [$0428] pattern 18, track 2
 dw trackDef6TitleMusik ; $0207: [$044B] pattern 18, track 3
pattern19DefinitionTitleMusik:
 db $00 ; $0209: pattern 19 state
 dw trackDef16TitleMusik ; $020A: [$046E] pattern 19, track 1
 dw trackDef5TitleMusik ; $020C: [$0428] pattern 19, track 2
 dw trackDef6TitleMusik ; $020E: [$044B] pattern 19, track 3
pattern20DefinitionTitleMusik:
 db $00 ; $0210: pattern 20 state
 dw trackDef16TitleMusik ; $0211: [$046E] pattern 20, track 1
 dw trackDef5TitleMusik ; $0213: [$0428] pattern 20, track 2
 dw trackDef6TitleMusik ; $0215: [$044B] pattern 20, track 3
pattern21DefinitionTitleMusik:
 db $00 ; $0217: pattern 21 state
 dw trackDef16TitleMusik ; $0218: [$046E] pattern 21, track 1
 dw trackDef5TitleMusik ; $021A: [$0428] pattern 21, track 2
 dw trackDef6TitleMusik ; $021C: [$044B] pattern 21, track 3
pattern22DefinitionTitleMusik:
 db $02 ; $021E: pattern 22 state
 db $02 ; $021F: transposition 1
 dw trackDef16TitleMusik ; $0220: [$046E] pattern 22, track 1
 dw trackDef5TitleMusik ; $0222: [$0428] pattern 22, track 2
 dw trackDef6TitleMusik ; $0224: [$044B] pattern 22, track 3
pattern23DefinitionTitleMusik:
 db $00 ; $0226: pattern 23 state
 dw trackDef16TitleMusik ; $0227: [$046E] pattern 23, track 1
 dw trackDef5TitleMusik ; $0229: [$0428] pattern 23, track 2
 dw trackDef6TitleMusik ; $022B: [$044B] pattern 23, track 3
pattern24DefinitionTitleMusik:
 db $00 ; $022D: pattern 24 state
 dw trackDef16TitleMusik ; $022E: [$046E] pattern 24, track 1
 dw trackDef5TitleMusik ; $0230: [$0428] pattern 24, track 2
 dw trackDef6TitleMusik ; $0232: [$044B] pattern 24, track 3
pattern25DefinitionTitleMusik:
 db $00 ; $0234: pattern 25 state
 dw trackDef16TitleMusik ; $0235: [$046E] pattern 25, track 1
 dw trackDef5TitleMusik ; $0237: [$0428] pattern 25, track 2
 dw trackDef6TitleMusik ; $0239: [$044B] pattern 25, track 3
pattern26DefinitionTitleMusik:
 db $02 ; $023B: pattern 26 state
 db $03 ; $023C: transposition 1
 dw trackDef16TitleMusik ; $023D: [$046E] pattern 26, track 1
 dw trackDef5TitleMusik ; $023F: [$0428] pattern 26, track 2
 dw trackDef6TitleMusik ; $0241: [$044B] pattern 26, track 3
pattern27DefinitionTitleMusik:
 db $00 ; $0243: pattern 27 state
 dw trackDef16TitleMusik ; $0244: [$046E] pattern 27, track 1
 dw trackDef5TitleMusik ; $0246: [$0428] pattern 27, track 2
 dw trackDef6TitleMusik ; $0248: [$044B] pattern 27, track 3
pattern28DefinitionTitleMusik:
 db $00 ; $024A: pattern 28 state
 dw trackDef16TitleMusik ; $024B: [$046E] pattern 28, track 1
 dw trackDef5TitleMusik ; $024D: [$0428] pattern 28, track 2
 dw trackDef6TitleMusik ; $024F: [$044B] pattern 28, track 3
pattern29DefinitionTitleMusik:
 db $00 ; $0251: pattern 29 state
 dw trackDef16TitleMusik ; $0252: [$046E] pattern 29, track 1
 dw trackDef5TitleMusik ; $0254: [$0428] pattern 29, track 2
 dw trackDef6TitleMusik ; $0256: [$044B] pattern 29, track 3
pattern30DefinitionTitleMusik:
 db $02 ; $0258: pattern 30 state
 db $05 ; $0259: transposition 1
 dw trackDef16TitleMusik ; $025A: [$046E] pattern 30, track 1
 dw trackDef5TitleMusik ; $025C: [$0428] pattern 30, track 2
 dw trackDef6TitleMusik ; $025E: [$044B] pattern 30, track 3
pattern31DefinitionTitleMusik:
 db $00 ; $0260: pattern 31 state
 dw trackDef16TitleMusik ; $0261: [$046E] pattern 31, track 1
 dw trackDef5TitleMusik ; $0263: [$0428] pattern 31, track 2
 dw trackDef6TitleMusik ; $0265: [$044B] pattern 31, track 3
pattern32DefinitionTitleMusik:
 db $00 ; $0267: pattern 32 state
 dw trackDef16TitleMusik ; $0268: [$046E] pattern 32, track 1
 dw trackDef5TitleMusik ; $026A: [$0428] pattern 32, track 2
 dw trackDef6TitleMusik ; $026C: [$044B] pattern 32, track 3
pattern33DefinitionTitleMusik:
 db $00 ; $026E: pattern 33 state
 dw trackDef16TitleMusik ; $026F: [$046E] pattern 33, track 1
 dw trackDef5TitleMusik ; $0271: [$0428] pattern 33, track 2
 dw trackDef6TitleMusik ; $0273: [$044B] pattern 33, track 3
pattern34DefinitionTitleMusik:
 db $02 ; $0275: pattern 34 state
 db $00 ; $0276: transposition 1
 dw trackDef41TitleMusik ; $0277: [$0482] pattern 34, track 1
 dw trackDef5TitleMusik ; $0279: [$0428] pattern 34, track 2
 dw trackDef43TitleMusik ; $027B: [$04DF] pattern 34, track 3
pattern35DefinitionTitleMusik:
 db $00 ; $027D: pattern 35 state
 dw trackDef44TitleMusik ; $027E: [$04B0] pattern 35, track 1
 dw trackDef5TitleMusik ; $0280: [$0428] pattern 35, track 2
 dw trackDef46TitleMusik ; $0282: [$0506] pattern 35, track 3
pattern36DefinitionTitleMusik:
 db $00 ; $0284: pattern 36 state
 dw trackDef41TitleMusik ; $0285: [$0482] pattern 36, track 1
 dw trackDef5TitleMusik ; $0287: [$0428] pattern 36, track 2
 dw trackDef43TitleMusik ; $0289: [$04DF] pattern 36, track 3
pattern37DefinitionTitleMusik:
 db $00 ; $028B: pattern 37 state
 dw trackDef44TitleMusik ; $028C: [$04B0] pattern 37, track 1
 dw trackDef5TitleMusik ; $028E: [$0428] pattern 37, track 2
 dw trackDef46TitleMusik ; $0290: [$0506] pattern 37, track 3
pattern38DefinitionTitleMusik:
 db $00 ; $0292: pattern 38 state
 dw trackDef41TitleMusik ; $0293: [$0482] pattern 38, track 1
 dw trackDef5TitleMusik ; $0295: [$0428] pattern 38, track 2
 dw trackDef43TitleMusik ; $0297: [$04DF] pattern 38, track 3
pattern39DefinitionTitleMusik:
 db $00 ; $0299: pattern 39 state
 dw trackDef44TitleMusik ; $029A: [$04B0] pattern 39, track 1
 dw trackDef5TitleMusik ; $029C: [$0428] pattern 39, track 2
 dw trackDef46TitleMusik ; $029E: [$0506] pattern 39, track 3
pattern40DefinitionTitleMusik:
 db $00 ; $02A0: pattern 40 state
 dw trackDef41TitleMusik ; $02A1: [$0482] pattern 40, track 1
 dw trackDef5TitleMusik ; $02A3: [$0428] pattern 40, track 2
 dw trackDef43TitleMusik ; $02A5: [$04DF] pattern 40, track 3
pattern41DefinitionTitleMusik:
 db $00 ; $02A7: pattern 41 state
 dw trackDef44TitleMusik ; $02A8: [$04B0] pattern 41, track 1
 dw trackDef5TitleMusik ; $02AA: [$0428] pattern 41, track 2
 dw trackDef46TitleMusik ; $02AC: [$0506] pattern 41, track 3
pattern42DefinitionTitleMusik:
 db $00 ; $02AE: pattern 42 state
 dw trackDef53TitleMusik ; $02AF: [$052D] pattern 42, track 1
 dw trackDef54TitleMusik ; $02B1: [$0585] pattern 42, track 2
 dw trackDef55TitleMusik ; $02B3: [$055D] pattern 42, track 3
pattern43DefinitionTitleMusik:
 db $00 ; $02B5: pattern 43 state
 dw trackDef53TitleMusik ; $02B6: [$052D] pattern 43, track 1
 dw trackDef56TitleMusik ; $02B8: [$05A8] pattern 43, track 2
 dw trackDef55TitleMusik ; $02BA: [$055D] pattern 43, track 3
pattern44DefinitionTitleMusik:
 db $00 ; $02BC: pattern 44 state
 dw trackDef53TitleMusik ; $02BD: [$052D] pattern 44, track 1
 dw trackDef56TitleMusik ; $02BF: [$05A8] pattern 44, track 2
 dw trackDef55TitleMusik ; $02C1: [$055D] pattern 44, track 3
pattern45DefinitionTitleMusik:
 db $00 ; $02C3: pattern 45 state
 dw trackDef53TitleMusik ; $02C4: [$052D] pattern 45, track 1
 dw trackDef58TitleMusik ; $02C6: [$05CA] pattern 45, track 2
 dw trackDef55TitleMusik ; $02C8: [$055D] pattern 45, track 3
pattern46DefinitionTitleMusik:
 db $00 ; $02CA: pattern 46 state
 dw trackDef59TitleMusik ; $02CB: [$05EC] pattern 46, track 1
 dw trackDef60TitleMusik ; $02CD: [$06D9] pattern 46, track 2
 dw trackDef61TitleMusik ; $02CF: [$061C] pattern 46, track 3
pattern47DefinitionTitleMusik:
 db $00 ; $02D1: pattern 47 state
 dw trackDef59TitleMusik ; $02D2: [$05EC] pattern 47, track 1
 dw trackDef1TitleMusik ; $02D4: [$03A1] pattern 47, track 2
 dw trackDef61TitleMusik ; $02D6: [$061C] pattern 47, track 3
pattern48DefinitionTitleMusik:
 db $00 ; $02D8: pattern 48 state
 dw trackDef59TitleMusik ; $02D9: [$05EC] pattern 48, track 1
 dw trackDef1TitleMusik ; $02DB: [$03A1] pattern 48, track 2
 dw trackDef61TitleMusik ; $02DD: [$061C] pattern 48, track 3
pattern49DefinitionTitleMusik:
 db $00 ; $02DF: pattern 49 state
 dw trackDef59TitleMusik ; $02E0: [$05EC] pattern 49, track 1
 dw trackDef1TitleMusik ; $02E2: [$03A1] pattern 49, track 2
 dw trackDef61TitleMusik ; $02E4: [$061C] pattern 49, track 3
pattern50DefinitionTitleMusik:
 db $00 ; $02E6: pattern 50 state
 dw trackDef53TitleMusik ; $02E7: [$052D] pattern 50, track 1
 dw trackDef62TitleMusik ; $02E9: [$0644] pattern 50, track 2
 dw trackDef55TitleMusik ; $02EB: [$055D] pattern 50, track 3
pattern51DefinitionTitleMusik:
 db $00 ; $02ED: pattern 51 state
 dw trackDef53TitleMusik ; $02EE: [$052D] pattern 51, track 1
 dw trackDef56TitleMusik ; $02F0: [$05A8] pattern 51, track 2
 dw trackDef55TitleMusik ; $02F2: [$055D] pattern 51, track 3
pattern52DefinitionTitleMusik:
 db $00 ; $02F4: pattern 52 state
 dw trackDef53TitleMusik ; $02F5: [$052D] pattern 52, track 1
 dw trackDef56TitleMusik ; $02F7: [$05A8] pattern 52, track 2
 dw trackDef55TitleMusik ; $02F9: [$055D] pattern 52, track 3
pattern53DefinitionTitleMusik:
 db $00 ; $02FB: pattern 53 state
 dw trackDef53TitleMusik ; $02FC: [$052D] pattern 53, track 1
 dw trackDef58TitleMusik ; $02FE: [$05CA] pattern 53, track 2
 dw trackDef55TitleMusik ; $0300: [$055D] pattern 53, track 3
pattern54DefinitionTitleMusik:
 db $00 ; $0302: pattern 54 state
 dw trackDef59TitleMusik ; $0303: [$05EC] pattern 54, track 1
 dw trackDef60TitleMusik ; $0305: [$06D9] pattern 54, track 2
 dw trackDef61TitleMusik ; $0307: [$061C] pattern 54, track 3
pattern55DefinitionTitleMusik:
 db $00 ; $0309: pattern 55 state
 dw trackDef59TitleMusik ; $030A: [$05EC] pattern 55, track 1
 dw trackDef1TitleMusik ; $030C: [$03A1] pattern 55, track 2
 dw trackDef61TitleMusik ; $030E: [$061C] pattern 55, track 3
pattern56DefinitionTitleMusik:
 db $00 ; $0310: pattern 56 state
 dw trackDef59TitleMusik ; $0311: [$05EC] pattern 56, track 1
 dw trackDef1TitleMusik ; $0313: [$03A1] pattern 56, track 2
 dw trackDef61TitleMusik ; $0315: [$061C] pattern 56, track 3
pattern57DefinitionTitleMusik:
 db $00 ; $0317: pattern 57 state
 dw trackDef59TitleMusik ; $0318: [$05EC] pattern 57, track 1
 dw trackDef1TitleMusik ; $031A: [$03A1] pattern 57, track 2
 dw trackDef67TitleMusik ; $031C: [$0667] pattern 57, track 3
pattern58DefinitionTitleMusik:
 db $00 ; $031E: pattern 58 state
 dw trackDef53TitleMusik ; $031F: [$052D] pattern 58, track 1
 dw trackDef68TitleMusik ; $0321: [$068A] pattern 58, track 2
 dw trackDef55TitleMusik ; $0323: [$055D] pattern 58, track 3
pattern59DefinitionTitleMusik:
 db $00 ; $0325: pattern 59 state
 dw trackDef53TitleMusik ; $0326: [$052D] pattern 59, track 1
 dw trackDef69TitleMusik ; $0328: [$06A3] pattern 59, track 2
 dw trackDef55TitleMusik ; $032A: [$055D] pattern 59, track 3
pattern60DefinitionTitleMusik:
 db $00 ; $032C: pattern 60 state
 dw trackDef53TitleMusik ; $032D: [$052D] pattern 60, track 1
 dw trackDef68TitleMusik ; $032F: [$068A] pattern 60, track 2
 dw trackDef55TitleMusik ; $0331: [$055D] pattern 60, track 3
pattern61DefinitionTitleMusik:
 db $00 ; $0333: pattern 61 state
 dw trackDef53TitleMusik ; $0334: [$052D] pattern 61, track 1
 dw trackDef69TitleMusik ; $0336: [$06A3] pattern 61, track 2
 dw trackDef55TitleMusik ; $0338: [$055D] pattern 61, track 3
pattern62DefinitionTitleMusik:
 db $00 ; $033A: pattern 62 state
 dw trackDef59TitleMusik ; $033B: [$05EC] pattern 62, track 1
 dw trackDef68TitleMusik ; $033D: [$068A] pattern 62, track 2
 dw trackDef61TitleMusik ; $033F: [$061C] pattern 62, track 3
pattern63DefinitionTitleMusik:
 db $00 ; $0341: pattern 63 state
 dw trackDef59TitleMusik ; $0342: [$05EC] pattern 63, track 1
 dw trackDef69TitleMusik ; $0344: [$06A3] pattern 63, track 2
 dw trackDef61TitleMusik ; $0346: [$061C] pattern 63, track 3
pattern64DefinitionTitleMusik:
 db $00 ; $0348: pattern 64 state
 dw trackDef59TitleMusik ; $0349: [$05EC] pattern 64, track 1
 dw trackDef68TitleMusik ; $034B: [$068A] pattern 64, track 2
 dw trackDef61TitleMusik ; $034D: [$061C] pattern 64, track 3
pattern65DefinitionTitleMusik:
 db $00 ; $034F: pattern 65 state
 dw trackDef59TitleMusik ; $0350: [$05EC] pattern 65, track 1
 dw trackDef69TitleMusik ; $0352: [$06A3] pattern 65, track 2
 dw trackDef61TitleMusik ; $0354: [$061C] pattern 65, track 3
pattern66DefinitionTitleMusik:
 db $00 ; $0356: pattern 66 state
 dw trackDef53TitleMusik ; $0357: [$052D] pattern 66, track 1
 dw trackDef68TitleMusik ; $0359: [$068A] pattern 66, track 2
 dw trackDef55TitleMusik ; $035B: [$055D] pattern 66, track 3
pattern67DefinitionTitleMusik:
 db $00 ; $035D: pattern 67 state
 dw trackDef53TitleMusik ; $035E: [$052D] pattern 67, track 1
 dw trackDef69TitleMusik ; $0360: [$06A3] pattern 67, track 2
 dw trackDef55TitleMusik ; $0362: [$055D] pattern 67, track 3
pattern68DefinitionTitleMusik:
 db $00 ; $0364: pattern 68 state
 dw trackDef53TitleMusik ; $0365: [$052D] pattern 68, track 1
 dw trackDef68TitleMusik ; $0367: [$068A] pattern 68, track 2
 dw trackDef55TitleMusik ; $0369: [$055D] pattern 68, track 3
pattern69DefinitionTitleMusik:
 db $00 ; $036B: pattern 69 state
 dw trackDef53TitleMusik ; $036C: [$052D] pattern 69, track 1
 dw trackDef69TitleMusik ; $036E: [$06A3] pattern 69, track 2
 dw trackDef55TitleMusik ; $0370: [$055D] pattern 69, track 3
pattern70DefinitionTitleMusik:
 db $00 ; $0372: pattern 70 state
 dw trackDef59TitleMusik ; $0373: [$05EC] pattern 70, track 1
 dw trackDef68TitleMusik ; $0375: [$068A] pattern 70, track 2
 dw trackDef61TitleMusik ; $0377: [$061C] pattern 70, track 3
pattern71DefinitionTitleMusik:
 db $00 ; $0379: pattern 71 state
 dw trackDef59TitleMusik ; $037A: [$05EC] pattern 71, track 1
 dw trackDef69TitleMusik ; $037C: [$06A3] pattern 71, track 2
 dw trackDef61TitleMusik ; $037E: [$061C] pattern 71, track 3
pattern72DefinitionTitleMusik:
 db $00 ; $0380: pattern 72 state
 dw trackDef59TitleMusik ; $0381: [$05EC] pattern 72, track 1
 dw trackDef68TitleMusik ; $0383: [$068A] pattern 72, track 2
 dw trackDef61TitleMusik ; $0385: [$061C] pattern 72, track 3
pattern73DefinitionTitleMusik:
 db $00 ; $0387: pattern 73 state
 dw trackDef59TitleMusik ; $0388: [$05EC] pattern 73, track 1
 dw trackDef69TitleMusik ; $038A: [$06A3] pattern 73, track 2
 dw trackDef61TitleMusik ; $038C: [$061C] pattern 73, track 3
pattern74DefinitionTitleMusik:
 db $00 ; $038E: pattern 74 state
 dw trackDef84TitleMusik ; $038F: [$06C9] pattern 74, track 1
 dw trackDef85TitleMusik ; $0391: [$06BD] pattern 74, track 2
 dw trackDef86TitleMusik ; $0393: [$06D4] pattern 74, track 3
pattern75DefinitionTitleMusik:
 db $00 ; $0395: pattern 75 state
 dw trackDef1TitleMusik ; $0396: [$03A1] pattern 75, track 1
 dw trackDef1TitleMusik ; $0398: [$03A1] pattern 75, track 2
 dw trackDef1TitleMusik ; $039A: [$03A1] pattern 75, track 3
pattern76DefinitionTitleMusik:
 db $01 ; $039C: pattern 76 state
 dw pattern0DefinitionTitleMusik ; $039D: [$017E] song restart address
specialtrackDef0TitleMusik:
 db $15 ; $039F: data, speed 5
 db $00 ; $03A0: wait 128
trackDef1TitleMusik:
 db $42 ; $03A1: normal track data
 db $80 ; $03A2: vol off, pitch, no note, no instrument
 dw $0000 ; $03A3: pitch
 db $00 ; $03A5: track end signature found
trackDef0TitleMusik:
 db $52 ; $03A6: normal track data
 db $E1 ; $03A7: vol = $F (inverted), no pitch, no note, no instrument
 dw $0000 ; $03A8: pitch
 db $01 ; $03AA: instrument
 db $42 ; $03AB: normal track data
 db $80 ; $03AC: vol off, pitch, no note, no instrument
 dw $FFF6 ; $03AD: pitch
 db $42 ; $03AF: normal track data
 db $00 ; $03B0: vol off, no pitch, no note, no instrument
 db $42 ; $03B1: normal track data
 db $00 ; $03B2: vol off, no pitch, no note, no instrument
 db $42 ; $03B3: normal track data
 db $00 ; $03B4: vol off, no pitch, no note, no instrument
 db $42 ; $03B5: normal track data
 db $00 ; $03B6: vol off, no pitch, no note, no instrument
 db $42 ; $03B7: normal track data
 db $00 ; $03B8: vol off, no pitch, no note, no instrument
 db $42 ; $03B9: normal track data
 db $00 ; $03BA: vol off, no pitch, no note, no instrument
 db $42 ; $03BB: normal track data
 db $00 ; $03BC: vol off, no pitch, no note, no instrument
 db $42 ; $03BD: normal track data
 db $00 ; $03BE: vol off, no pitch, no note, no instrument
 db $42 ; $03BF: normal track data
 db $00 ; $03C0: vol off, no pitch, no note, no instrument
 db $42 ; $03C1: normal track data
 db $00 ; $03C2: vol off, no pitch, no note, no instrument
 db $42 ; $03C3: normal track data
 db $00 ; $03C4: vol off, no pitch, no note, no instrument
 db $42 ; $03C5: normal track data
 db $00 ; $03C6: vol off, no pitch, no note, no instrument
 db $42 ; $03C7: normal track data
 db $00 ; $03C8: vol off, no pitch, no note, no instrument
 db $42 ; $03C9: normal track data
 db $00 ; $03CA: vol off, no pitch, no note, no instrument
 db $42 ; $03CB: normal track data
 db $00 ; $03CC: vol off, no pitch, no note, no instrument
 db $42 ; $03CD: normal track data
 db $00 ; $03CE: vol off, no pitch, no note, no instrument
 db $42 ; $03CF: normal track data
 db $00 ; $03D0: vol off, no pitch, no note, no instrument
 db $42 ; $03D1: normal track data
 db $00 ; $03D2: vol off, no pitch, no note, no instrument
 db $42 ; $03D3: normal track data
 db $00 ; $03D4: vol off, no pitch, no note, no instrument
 db $42 ; $03D5: normal track data
 db $00 ; $03D6: vol off, no pitch, no note, no instrument
 db $42 ; $03D7: normal track data
 db $00 ; $03D8: vol off, no pitch, no note, no instrument
 db $42 ; $03D9: normal track data
 db $00 ; $03DA: vol off, no pitch, no note, no instrument
 db $42 ; $03DB: normal track data
 db $00 ; $03DC: vol off, no pitch, no note, no instrument
 db $42 ; $03DD: normal track data
 db $00 ; $03DE: vol off, no pitch, no note, no instrument
 db $42 ; $03DF: normal track data
 db $00 ; $03E0: vol off, no pitch, no note, no instrument
 db $42 ; $03E1: normal track data
 db $00 ; $03E2: vol off, no pitch, no note, no instrument
 db $42 ; $03E3: normal track data
 db $00 ; $03E4: vol off, no pitch, no note, no instrument
 db $42 ; $03E5: normal track data
 db $00 ; $03E6: vol off, no pitch, no note, no instrument
 db $42 ; $03E7: normal track data
 db $00 ; $03E8: vol off, no pitch, no note, no instrument
 db $42 ; $03E9: normal track data
 db $00 ; $03EA: vol off, no pitch, no note, no instrument
trackDef3TitleMusik:
 db $42 ; $03EB: normal track data
 db $80 ; $03EC: vol off, pitch, no note, no instrument
 dw $0000 ; $03ED: pitch
 db $42 ; $03EF: normal track data
 db $00 ; $03F0: vol off, no pitch, no note, no instrument
 db $06 ; $03F1: normal track data,  wait 2
 db $42 ; $03F2: normal track data
 db $03 ; $03F3: vol = $E (inverted), no pitch, no note, no instrument
 db $08 ; $03F4: normal track data,  wait 3
 db $42 ; $03F5: normal track data,  note: C0
 db $05 ; $03F6: vol = $D (inverted), no pitch, no note, no instrument
 db $00 ; $03F7: track end signature found
trackDef4TitleMusik:
 db $42 ; $03F8: normal track data
 db $80 ; $03F9: vol off, pitch, no note, no instrument
 dw $0000 ; $03FA: pitch
 db $02 ; $03FC: normal track data,  wait 0
 db $42 ; $03FD: normal track data,  note: C0
 db $07 ; $03FE: vol = $C (inverted), no pitch, no note, no instrument
 db $08 ; $03FF: normal track data,  wait 3
 db $42 ; $0400: normal track data
 db $09 ; $0401: vol = $B (inverted), no pitch, no note, no instrument
 db $08 ; $0402: normal track data,  wait 3
 db $42 ; $0403: normal track data
 db $0B ; $0404: vol = $A (inverted), no pitch, no note, no instrument
 db $00 ; $0405: track end signature found
trackDef7TitleMusik:
 db $42 ; $0406: normal track data
 db $80 ; $0407: vol off, pitch, no note, no instrument
 dw $0000 ; $0408: pitch
 db $42 ; $040A: normal track data,  note: C0
 db $0D ; $040B: vol = $9 (inverted), no pitch, no note, no instrument
 db $08 ; $040C: normal track data,  wait 3
 db $42 ; $040D: normal track data,  note: C0
 db $0F ; $040E: vol = $8 (inverted), no pitch, no note, no instrument
 db $08 ; $040F: normal track data,  wait 3
 db $42 ; $0410: normal track data
 db $11 ; $0411: vol = $7 (inverted), no pitch, no note, no instrument
 db $00 ; $0412: track end signature found
trackDef9TitleMusik:
 db $42 ; $0413: normal track data
 db $93 ; $0414: vol = $6 (inverted), no pitch, no note, no instrument
 dw $0000 ; $0415: pitch
 db $04 ; $0417: normal track data,  wait 1
 db $42 ; $0418: normal track data,  note: C0
 db $15 ; $0419: vol = $5 (inverted), no pitch, no note, no instrument
 db $04 ; $041A: normal track data,  wait 1
 db $42 ; $041B: normal track data,  note: C0
 db $17 ; $041C: vol = $4 (inverted), no pitch, no note, no instrument
 db $04 ; $041D: normal track data,  wait 1
 db $42 ; $041E: normal track data
 db $19 ; $041F: vol = $3 (inverted), no pitch, no note, no instrument
 db $04 ; $0420: normal track data,  wait 1
 db $42 ; $0421: normal track data
 db $1B ; $0422: vol = $2 (inverted), no pitch, no note, no instrument
 db $02 ; $0423: normal track data,  wait 0
 db $42 ; $0424: normal track data,  note: C0
 db $1D ; $0425: vol = $1 (inverted), no pitch, no note, no instrument
 db $42 ; $0426: normal track data,  note: C0
 db $1F ; $0427: vol = $0 (inverted), no pitch, no note, no instrument
trackDef5TitleMusik:
 db $A8 ; $0428: normal track data
 db $E1 ; $0429: vol = $F (inverted), no pitch, no note, no instrument
 dw $0000 ; $042A: pitch
 db $02 ; $042C: instrument
 db $C0 ; $042D: normal track data
 db $49 ; $042E: vol = $B (inverted), no pitch, no note, no instrument
 db $B8 ; $042F: normal track data
 db $41 ; $0430: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $0431: normal track data
 db $49 ; $0432: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $0433: normal track data
 db $41 ; $0434: vol = $F (inverted), no pitch, no note, no instrument
 db $B8 ; $0435: normal track data
 db $49 ; $0436: vol = $B (inverted), no pitch, no note, no instrument
 db $B6 ; $0437: normal track data
 db $41 ; $0438: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $0439: normal track data
 db $49 ; $043A: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $043B: normal track data
 db $41 ; $043C: vol = $F (inverted), no pitch, no note, no instrument
 db $B6 ; $043D: normal track data
 db $49 ; $043E: vol = $B (inverted), no pitch, no note, no instrument
 db $BC ; $043F: normal track data
 db $41 ; $0440: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $0441: normal track data
 db $49 ; $0442: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $0443: normal track data
 db $41 ; $0444: vol = $F (inverted), no pitch, no note, no instrument
 db $BC ; $0445: normal track data
 db $49 ; $0446: vol = $B (inverted), no pitch, no note, no instrument
 db $C0 ; $0447: normal track data
 db $41 ; $0448: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $0449: normal track data
 db $49 ; $044A: vol = $B (inverted), no pitch, no note, no instrument
trackDef6TitleMusik:
 db $A8 ; $044B: normal track data
 db $E9 ; $044C: vol = $B (inverted), no pitch, no note, no instrument
 dw $0000 ; $044D: pitch
 db $03 ; $044F: instrument
 db $A8 ; $0450: normal track data
 db $41 ; $0451: vol = $F (inverted), no pitch, no note, no instrument
 db $C0 ; $0452: normal track data
 db $49 ; $0453: vol = $B (inverted), no pitch, no note, no instrument
 db $B8 ; $0454: normal track data
 db $41 ; $0455: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $0456: normal track data
 db $49 ; $0457: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $0458: normal track data
 db $41 ; $0459: vol = $F (inverted), no pitch, no note, no instrument
 db $B8 ; $045A: normal track data
 db $49 ; $045B: vol = $B (inverted), no pitch, no note, no instrument
 db $B6 ; $045C: normal track data
 db $41 ; $045D: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $045E: normal track data
 db $49 ; $045F: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $0460: normal track data
 db $41 ; $0461: vol = $F (inverted), no pitch, no note, no instrument
 db $B6 ; $0462: normal track data
 db $49 ; $0463: vol = $B (inverted), no pitch, no note, no instrument
 db $BC ; $0464: normal track data
 db $41 ; $0465: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $0466: normal track data
 db $49 ; $0467: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $0468: normal track data
 db $41 ; $0469: vol = $F (inverted), no pitch, no note, no instrument
 db $BC ; $046A: normal track data
 db $49 ; $046B: vol = $B (inverted), no pitch, no note, no instrument
 db $C0 ; $046C: normal track data
 db $41 ; $046D: vol = $F (inverted), no pitch, no note, no instrument
trackDef16TitleMusik:
 db $6A ; $046E: normal track data
 db $E1 ; $046F: vol = $F (inverted), no pitch, no note, no instrument
 dw $0000 ; $0470: pitch
 db $04 ; $0472: instrument
 db $02 ; $0473: normal track data,  wait 0
 db $2B ; $0474: full optimization, no escape: G#1
 db $02 ; $0475: normal track data,  wait 0
 db $2B ; $0476: full optimization, no escape: G#1
 db $02 ; $0477: normal track data,  wait 0
 db $2B ; $0478: full optimization, no escape: G#1
 db $02 ; $0479: normal track data,  wait 0
 db $2B ; $047A: full optimization, no escape: G#1
 db $02 ; $047B: normal track data,  wait 0
 db $2B ; $047C: full optimization, no escape: G#1
 db $02 ; $047D: normal track data,  wait 0
 db $2B ; $047E: full optimization, no escape: G#1
 db $02 ; $047F: normal track data,  wait 0
 db $2B ; $0480: full optimization, no escape: G#1
 db $00 ; $0481: track end signature found
trackDef41TitleMusik:
 db $5E ; $0482: normal track data
 db $E0 ; $0483: vol off, pitch, note, instrument
 dw $0000 ; $0484: pitch
 db $05 ; $0486: instrument
 db $8A ; $0487: normal track data
 db $60 ; $0488: vol off, no pitch, note, instrument
 db $06 ; $0489: instrument
 db $5C ; $048A: normal track data
 db $60 ; $048B: vol off, no pitch, note, instrument
 db $07 ; $048C: instrument
 db $21 ; $048D: full optimization, no escape: D#1
 db $8A ; $048E: normal track data
 db $60 ; $048F: vol off, no pitch, note, instrument
 db $08 ; $0490: instrument
 db $8A ; $0491: normal track data
 db $60 ; $0492: vol off, no pitch, note, instrument
 db $06 ; $0493: instrument
 db $8A ; $0494: normal track data
 db $60 ; $0495: vol off, no pitch, note, instrument
 db $08 ; $0496: instrument
 db $5E ; $0497: normal track data
 db $60 ; $0498: vol off, no pitch, note, instrument
 db $05 ; $0499: instrument
 db $8A ; $049A: normal track data
 db $60 ; $049B: vol off, no pitch, note, instrument
 db $06 ; $049C: instrument
 db $8A ; $049D: normal track data
 db $60 ; $049E: vol off, no pitch, note, instrument
 db $08 ; $049F: instrument
 db $5E ; $04A0: normal track data
 db $60 ; $04A1: vol off, no pitch, note, instrument
 db $05 ; $04A2: instrument
 db $8A ; $04A3: normal track data
 db $60 ; $04A4: vol off, no pitch, note, instrument
 db $06 ; $04A5: instrument
 db $8A ; $04A6: normal track data
 db $60 ; $04A7: vol off, no pitch, note, instrument
 db $08 ; $04A8: instrument
 db $8A ; $04A9: normal track data
 db $60 ; $04AA: vol off, no pitch, note, instrument
 db $06 ; $04AB: instrument
 db $5C ; $04AC: normal track data
 db $60 ; $04AD: vol off, no pitch, note, instrument
 db $07 ; $04AE: instrument
 db $21 ; $04AF: full optimization, no escape: D#1
trackDef44TitleMusik:
 db $5E ; $04B0: normal track data
 db $E0 ; $04B1: vol off, pitch, note, instrument
 dw $0000 ; $04B2: pitch
 db $05 ; $04B4: instrument
 db $8A ; $04B5: normal track data
 db $60 ; $04B6: vol off, no pitch, note, instrument
 db $06 ; $04B7: instrument
 db $5C ; $04B8: normal track data
 db $60 ; $04B9: vol off, no pitch, note, instrument
 db $07 ; $04BA: instrument
 db $21 ; $04BB: full optimization, no escape: D#1
 db $8A ; $04BC: normal track data
 db $60 ; $04BD: vol off, no pitch, note, instrument
 db $08 ; $04BE: instrument
 db $8A ; $04BF: normal track data
 db $60 ; $04C0: vol off, no pitch, note, instrument
 db $06 ; $04C1: instrument
 db $8A ; $04C2: normal track data
 db $60 ; $04C3: vol off, no pitch, note, instrument
 db $08 ; $04C4: instrument
 db $5E ; $04C5: normal track data
 db $60 ; $04C6: vol off, no pitch, note, instrument
 db $05 ; $04C7: instrument
 db $8A ; $04C8: normal track data
 db $60 ; $04C9: vol off, no pitch, note, instrument
 db $06 ; $04CA: instrument
 db $8A ; $04CB: normal track data
 db $60 ; $04CC: vol off, no pitch, note, instrument
 db $08 ; $04CD: instrument
 db $5E ; $04CE: normal track data
 db $60 ; $04CF: vol off, no pitch, note, instrument
 db $05 ; $04D0: instrument
 db $8A ; $04D1: normal track data
 db $60 ; $04D2: vol off, no pitch, note, instrument
 db $06 ; $04D3: instrument
 db $B6 ; $04D4: normal track data
 db $60 ; $04D5: vol off, no pitch, note, instrument
 db $09 ; $04D6: instrument
 db $42 ; $04D7: normal track data
 db $00 ; $04D8: vol off, no pitch, no note, no instrument
 db $56 ; $04D9: normal track data
 db $60 ; $04DA: vol off, no pitch, note, instrument
 db $07 ; $04DB: instrument
 db $8A ; $04DC: normal track data
 db $60 ; $04DD: vol off, no pitch, note, instrument
 db $08 ; $04DE: instrument
trackDef43TitleMusik:
 db $B6 ; $04DF: normal track data
 db $E0 ; $04E0: vol off, pitch, note, instrument
 dw $0000 ; $04E1: pitch
 db $0A ; $04E3: instrument
 db $42 ; $04E4: normal track data
 db $00 ; $04E5: vol off, no pitch, no note, no instrument
 db $8A ; $04E6: normal track data
 db $60 ; $04E7: vol off, no pitch, note, instrument
 db $08 ; $04E8: instrument
 db $8A ; $04E9: normal track data
 db $60 ; $04EA: vol off, no pitch, note, instrument
 db $06 ; $04EB: instrument
 db $5C ; $04EC: normal track data
 db $60 ; $04ED: vol off, no pitch, note, instrument
 db $0B ; $04EE: instrument
 db $42 ; $04EF: normal track data
 db $00 ; $04F0: vol off, no pitch, no note, no instrument
 db $60 ; $04F1: normal track data
 db $60 ; $04F2: vol off, no pitch, note, instrument
 db $07 ; $04F3: instrument
 db $27 ; $04F4: full optimization, no escape: F#1
 db $B6 ; $04F5: normal track data
 db $60 ; $04F6: vol off, no pitch, note, instrument
 db $0A ; $04F7: instrument
 db $02 ; $04F8: normal track data,  wait 0
 db $5C ; $04F9: normal track data
 db $60 ; $04FA: vol off, no pitch, note, instrument
 db $07 ; $04FB: instrument
 db $21 ; $04FC: full optimization, no escape: D#1
 db $5C ; $04FD: normal track data
 db $60 ; $04FE: vol off, no pitch, note, instrument
 db $0B ; $04FF: instrument
 db $02 ; $0500: normal track data,  wait 0
 db $B6 ; $0501: normal track data
 db $60 ; $0502: vol off, no pitch, note, instrument
 db $0C ; $0503: instrument
 db $42 ; $0504: normal track data
 db $00 ; $0505: vol off, no pitch, no note, no instrument
trackDef46TitleMusik:
 db $42 ; $0506: normal track data
 db $80 ; $0507: vol off, pitch, no note, no instrument
 dw $0000 ; $0508: pitch
 db $02 ; $050A: normal track data,  wait 0
 db $B6 ; $050B: normal track data
 db $60 ; $050C: vol off, no pitch, note, instrument
 db $0A ; $050D: instrument
 db $42 ; $050E: normal track data
 db $00 ; $050F: vol off, no pitch, no note, no instrument
 db $5C ; $0510: normal track data
 db $60 ; $0511: vol off, no pitch, note, instrument
 db $0B ; $0512: instrument
 db $02 ; $0513: normal track data,  wait 0
 db $60 ; $0514: normal track data
 db $60 ; $0515: vol off, no pitch, note, instrument
 db $07 ; $0516: instrument
 db $27 ; $0517: full optimization, no escape: F#1
 db $B6 ; $0518: normal track data
 db $60 ; $0519: vol off, no pitch, note, instrument
 db $0A ; $051A: instrument
 db $42 ; $051B: normal track data
 db $00 ; $051C: vol off, no pitch, no note, no instrument
 db $5C ; $051D: normal track data
 db $60 ; $051E: vol off, no pitch, note, instrument
 db $07 ; $051F: instrument
 db $21 ; $0520: full optimization, no escape: D#1
 db $5C ; $0521: normal track data
 db $60 ; $0522: vol off, no pitch, note, instrument
 db $0B ; $0523: instrument
 db $8A ; $0524: normal track data
 db $60 ; $0525: vol off, no pitch, note, instrument
 db $08 ; $0526: instrument
 db $8A ; $0527: normal track data
 db $60 ; $0528: vol off, no pitch, note, instrument
 db $06 ; $0529: instrument
 db $5C ; $052A: normal track data
 db $60 ; $052B: vol off, no pitch, note, instrument
 db $07 ; $052C: instrument
trackDef53TitleMusik:
 db $5E ; $052D: normal track data
 db $E0 ; $052E: vol off, pitch, note, instrument
 dw $0000 ; $052F: pitch
 db $05 ; $0531: instrument
 db $8A ; $0532: normal track data
 db $60 ; $0533: vol off, no pitch, note, instrument
 db $06 ; $0534: instrument
 db $60 ; $0535: normal track data
 db $60 ; $0536: vol off, no pitch, note, instrument
 db $07 ; $0537: instrument
 db $8A ; $0538: normal track data
 db $60 ; $0539: vol off, no pitch, note, instrument
 db $06 ; $053A: instrument
 db $8A ; $053B: normal track data
 db $60 ; $053C: vol off, no pitch, note, instrument
 db $08 ; $053D: instrument
 db $8A ; $053E: normal track data
 db $60 ; $053F: vol off, no pitch, note, instrument
 db $06 ; $0540: instrument
 db $8A ; $0541: normal track data
 db $60 ; $0542: vol off, no pitch, note, instrument
 db $08 ; $0543: instrument
 db $5E ; $0544: normal track data
 db $60 ; $0545: vol off, no pitch, note, instrument
 db $05 ; $0546: instrument
 db $8A ; $0547: normal track data
 db $60 ; $0548: vol off, no pitch, note, instrument
 db $06 ; $0549: instrument
 db $8A ; $054A: normal track data
 db $60 ; $054B: vol off, no pitch, note, instrument
 db $08 ; $054C: instrument
 db $5E ; $054D: normal track data
 db $60 ; $054E: vol off, no pitch, note, instrument
 db $05 ; $054F: instrument
 db $8A ; $0550: normal track data
 db $60 ; $0551: vol off, no pitch, note, instrument
 db $06 ; $0552: instrument
 db $42 ; $0553: normal track data
 db $00 ; $0554: vol off, no pitch, no note, no instrument
 db $42 ; $0555: normal track data
 db $00 ; $0556: vol off, no pitch, no note, no instrument
 db $60 ; $0557: normal track data
 db $60 ; $0558: vol off, no pitch, note, instrument
 db $07 ; $0559: instrument
 db $8A ; $055A: normal track data
 db $60 ; $055B: vol off, no pitch, note, instrument
 db $08 ; $055C: instrument
trackDef55TitleMusik:
 db $42 ; $055D: normal track data
 db $80 ; $055E: vol off, pitch, no note, no instrument
 dw $0000 ; $055F: pitch
 db $02 ; $0561: normal track data,  wait 0
 db $C0 ; $0562: normal track data
 db $60 ; $0563: vol off, no pitch, note, instrument
 db $0D ; $0564: instrument
 db $42 ; $0565: normal track data
 db $00 ; $0566: vol off, no pitch, no note, no instrument
 db $5C ; $0567: normal track data
 db $60 ; $0568: vol off, no pitch, note, instrument
 db $0B ; $0569: instrument
 db $02 ; $056A: normal track data,  wait 0
 db $60 ; $056B: normal track data
 db $60 ; $056C: vol off, no pitch, note, instrument
 db $07 ; $056D: instrument
 db $42 ; $056E: normal track data
 db $00 ; $056F: vol off, no pitch, no note, no instrument
 db $C0 ; $0570: normal track data
 db $60 ; $0571: vol off, no pitch, note, instrument
 db $0E ; $0572: instrument
 db $42 ; $0573: normal track data
 db $00 ; $0574: vol off, no pitch, no note, no instrument
 db $60 ; $0575: normal track data
 db $60 ; $0576: vol off, no pitch, note, instrument
 db $07 ; $0577: instrument
 db $42 ; $0578: normal track data
 db $00 ; $0579: vol off, no pitch, no note, no instrument
 db $5C ; $057A: normal track data
 db $60 ; $057B: vol off, no pitch, note, instrument
 db $0B ; $057C: instrument
 db $8A ; $057D: normal track data
 db $60 ; $057E: vol off, no pitch, note, instrument
 db $08 ; $057F: instrument
 db $8A ; $0580: normal track data
 db $60 ; $0581: vol off, no pitch, note, instrument
 db $06 ; $0582: instrument
 db $42 ; $0583: normal track data
 db $00 ; $0584: vol off, no pitch, no note, no instrument
trackDef54TitleMusik:
 db $82 ; $0585: normal track data
 db $EB ; $0586: vol = $A (inverted), no pitch, no note, no instrument
 dw $0002 ; $0587: pitch
 db $0F ; $0589: instrument
 db $42 ; $058A: normal track data
 db $09 ; $058B: vol = $B (inverted), no pitch, no note, no instrument
 db $42 ; $058C: normal track data,  note: C0
 db $07 ; $058D: vol = $C (inverted), no pitch, no note, no instrument
 db $42 ; $058E: normal track data,  note: C0
 db $05 ; $058F: vol = $D (inverted), no pitch, no note, no instrument
 db $42 ; $0590: normal track data
 db $03 ; $0591: vol = $E (inverted), no pitch, no note, no instrument
 db $42 ; $0592: normal track data
 db $01 ; $0593: vol = $F (inverted), no pitch, no note, no instrument
 db $42 ; $0594: normal track data
 db $00 ; $0595: vol off, no pitch, no note, no instrument
 db $42 ; $0596: normal track data
 db $00 ; $0597: vol off, no pitch, no note, no instrument
 db $42 ; $0598: normal track data
 db $00 ; $0599: vol off, no pitch, no note, no instrument
 db $42 ; $059A: normal track data
 db $00 ; $059B: vol off, no pitch, no note, no instrument
 db $42 ; $059C: normal track data
 db $00 ; $059D: vol off, no pitch, no note, no instrument
 db $42 ; $059E: normal track data
 db $00 ; $059F: vol off, no pitch, no note, no instrument
 db $42 ; $05A0: normal track data
 db $00 ; $05A1: vol off, no pitch, no note, no instrument
 db $42 ; $05A2: normal track data
 db $00 ; $05A3: vol off, no pitch, no note, no instrument
 db $42 ; $05A4: normal track data
 db $00 ; $05A5: vol off, no pitch, no note, no instrument
 db $42 ; $05A6: normal track data
 db $00 ; $05A7: vol off, no pitch, no note, no instrument
trackDef56TitleMusik:
 db $42 ; $05A8: normal track data
 db $80 ; $05A9: vol off, pitch, no note, no instrument
 dw $0002 ; $05AA: pitch
 db $42 ; $05AC: normal track data
 db $00 ; $05AD: vol off, no pitch, no note, no instrument
 db $42 ; $05AE: normal track data
 db $00 ; $05AF: vol off, no pitch, no note, no instrument
 db $42 ; $05B0: normal track data
 db $00 ; $05B1: vol off, no pitch, no note, no instrument
 db $42 ; $05B2: normal track data
 db $00 ; $05B3: vol off, no pitch, no note, no instrument
 db $42 ; $05B4: normal track data
 db $00 ; $05B5: vol off, no pitch, no note, no instrument
 db $42 ; $05B6: normal track data
 db $00 ; $05B7: vol off, no pitch, no note, no instrument
 db $42 ; $05B8: normal track data
 db $00 ; $05B9: vol off, no pitch, no note, no instrument
 db $42 ; $05BA: normal track data
 db $00 ; $05BB: vol off, no pitch, no note, no instrument
 db $42 ; $05BC: normal track data
 db $00 ; $05BD: vol off, no pitch, no note, no instrument
 db $42 ; $05BE: normal track data
 db $00 ; $05BF: vol off, no pitch, no note, no instrument
 db $42 ; $05C0: normal track data
 db $00 ; $05C1: vol off, no pitch, no note, no instrument
 db $42 ; $05C2: normal track data
 db $00 ; $05C3: vol off, no pitch, no note, no instrument
 db $42 ; $05C4: normal track data
 db $00 ; $05C5: vol off, no pitch, no note, no instrument
 db $42 ; $05C6: normal track data
 db $00 ; $05C7: vol off, no pitch, no note, no instrument
 db $42 ; $05C8: normal track data
 db $00 ; $05C9: vol off, no pitch, no note, no instrument
trackDef58TitleMusik:
 db $42 ; $05CA: normal track data
 db $80 ; $05CB: vol off, pitch, no note, no instrument
 dw $0002 ; $05CC: pitch
 db $42 ; $05CE: normal track data
 db $00 ; $05CF: vol off, no pitch, no note, no instrument
 db $42 ; $05D0: normal track data
 db $03 ; $05D1: vol = $E (inverted), no pitch, no note, no instrument
 db $42 ; $05D2: normal track data
 db $00 ; $05D3: vol off, no pitch, no note, no instrument
 db $42 ; $05D4: normal track data
 db $00 ; $05D5: vol off, no pitch, no note, no instrument
 db $42 ; $05D6: normal track data
 db $00 ; $05D7: vol off, no pitch, no note, no instrument
 db $42 ; $05D8: normal track data,  note: C0
 db $05 ; $05D9: vol = $D (inverted), no pitch, no note, no instrument
 db $42 ; $05DA: normal track data
 db $00 ; $05DB: vol off, no pitch, no note, no instrument
 db $42 ; $05DC: normal track data
 db $00 ; $05DD: vol off, no pitch, no note, no instrument
 db $42 ; $05DE: normal track data
 db $00 ; $05DF: vol off, no pitch, no note, no instrument
 db $42 ; $05E0: normal track data,  note: C0
 db $07 ; $05E1: vol = $C (inverted), no pitch, no note, no instrument
 db $42 ; $05E2: normal track data
 db $00 ; $05E3: vol off, no pitch, no note, no instrument
 db $42 ; $05E4: normal track data
 db $00 ; $05E5: vol off, no pitch, no note, no instrument
 db $42 ; $05E6: normal track data
 db $00 ; $05E7: vol off, no pitch, no note, no instrument
 db $42 ; $05E8: normal track data
 db $09 ; $05E9: vol = $B (inverted), no pitch, no note, no instrument
 db $42 ; $05EA: normal track data
 db $00 ; $05EB: vol off, no pitch, no note, no instrument
trackDef59TitleMusik:
 db $5E ; $05EC: normal track data
 db $E0 ; $05ED: vol off, pitch, note, instrument
 dw $0000 ; $05EE: pitch
 db $05 ; $05F0: instrument
 db $8A ; $05F1: normal track data
 db $60 ; $05F2: vol off, no pitch, note, instrument
 db $06 ; $05F3: instrument
 db $58 ; $05F4: normal track data
 db $60 ; $05F5: vol off, no pitch, note, instrument
 db $07 ; $05F6: instrument
 db $8A ; $05F7: normal track data
 db $60 ; $05F8: vol off, no pitch, note, instrument
 db $06 ; $05F9: instrument
 db $8A ; $05FA: normal track data
 db $60 ; $05FB: vol off, no pitch, note, instrument
 db $08 ; $05FC: instrument
 db $8A ; $05FD: normal track data
 db $60 ; $05FE: vol off, no pitch, note, instrument
 db $06 ; $05FF: instrument
 db $8A ; $0600: normal track data
 db $60 ; $0601: vol off, no pitch, note, instrument
 db $08 ; $0602: instrument
 db $5E ; $0603: normal track data
 db $60 ; $0604: vol off, no pitch, note, instrument
 db $05 ; $0605: instrument
 db $8A ; $0606: normal track data
 db $60 ; $0607: vol off, no pitch, note, instrument
 db $06 ; $0608: instrument
 db $8A ; $0609: normal track data
 db $60 ; $060A: vol off, no pitch, note, instrument
 db $08 ; $060B: instrument
 db $5E ; $060C: normal track data
 db $60 ; $060D: vol off, no pitch, note, instrument
 db $05 ; $060E: instrument
 db $8A ; $060F: normal track data
 db $60 ; $0610: vol off, no pitch, note, instrument
 db $06 ; $0611: instrument
 db $42 ; $0612: normal track data
 db $00 ; $0613: vol off, no pitch, no note, no instrument
 db $42 ; $0614: normal track data
 db $00 ; $0615: vol off, no pitch, no note, no instrument
 db $58 ; $0616: normal track data
 db $60 ; $0617: vol off, no pitch, note, instrument
 db $07 ; $0618: instrument
 db $8A ; $0619: normal track data
 db $60 ; $061A: vol off, no pitch, note, instrument
 db $08 ; $061B: instrument
trackDef61TitleMusik:
 db $42 ; $061C: normal track data
 db $80 ; $061D: vol off, pitch, no note, no instrument
 dw $0000 ; $061E: pitch
 db $02 ; $0620: normal track data,  wait 0
 db $C0 ; $0621: normal track data
 db $60 ; $0622: vol off, no pitch, note, instrument
 db $0D ; $0623: instrument
 db $42 ; $0624: normal track data
 db $00 ; $0625: vol off, no pitch, no note, no instrument
 db $5C ; $0626: normal track data
 db $60 ; $0627: vol off, no pitch, note, instrument
 db $0B ; $0628: instrument
 db $02 ; $0629: normal track data,  wait 0
 db $58 ; $062A: normal track data
 db $60 ; $062B: vol off, no pitch, note, instrument
 db $07 ; $062C: instrument
 db $42 ; $062D: normal track data
 db $00 ; $062E: vol off, no pitch, no note, no instrument
 db $C0 ; $062F: normal track data
 db $60 ; $0630: vol off, no pitch, note, instrument
 db $0E ; $0631: instrument
 db $42 ; $0632: normal track data
 db $00 ; $0633: vol off, no pitch, no note, no instrument
 db $58 ; $0634: normal track data
 db $60 ; $0635: vol off, no pitch, note, instrument
 db $07 ; $0636: instrument
 db $42 ; $0637: normal track data
 db $00 ; $0638: vol off, no pitch, no note, no instrument
 db $5C ; $0639: normal track data
 db $60 ; $063A: vol off, no pitch, note, instrument
 db $0B ; $063B: instrument
 db $8A ; $063C: normal track data
 db $60 ; $063D: vol off, no pitch, note, instrument
 db $08 ; $063E: instrument
 db $8A ; $063F: normal track data
 db $60 ; $0640: vol off, no pitch, note, instrument
 db $06 ; $0641: instrument
 db $42 ; $0642: normal track data
 db $00 ; $0643: vol off, no pitch, no note, no instrument
trackDef62TitleMusik:
 db $70 ; $0644: normal track data,  note: B1
 db $EF ; $0645: vol = $8 (inverted), no pitch, no note, no instrument
 dw $0002 ; $0646: pitch
 db $10 ; $0648: instrument
 db $42 ; $0649: normal track data
 db $00 ; $064A: vol off, no pitch, no note, no instrument
 db $42 ; $064B: normal track data,  note: C0
 db $0D ; $064C: vol = $9 (inverted), no pitch, no note, no instrument
 db $42 ; $064D: normal track data
 db $00 ; $064E: vol off, no pitch, no note, no instrument
 db $42 ; $064F: normal track data
 db $0B ; $0650: vol = $A (inverted), no pitch, no note, no instrument
 db $42 ; $0651: normal track data
 db $00 ; $0652: vol off, no pitch, no note, no instrument
 db $42 ; $0653: normal track data
 db $09 ; $0654: vol = $B (inverted), no pitch, no note, no instrument
 db $42 ; $0655: normal track data
 db $00 ; $0656: vol off, no pitch, no note, no instrument
 db $42 ; $0657: normal track data,  note: C0
 db $07 ; $0658: vol = $C (inverted), no pitch, no note, no instrument
 db $42 ; $0659: normal track data
 db $00 ; $065A: vol off, no pitch, no note, no instrument
 db $42 ; $065B: normal track data,  note: C0
 db $05 ; $065C: vol = $D (inverted), no pitch, no note, no instrument
 db $42 ; $065D: normal track data
 db $00 ; $065E: vol off, no pitch, no note, no instrument
 db $42 ; $065F: normal track data
 db $03 ; $0660: vol = $E (inverted), no pitch, no note, no instrument
 db $42 ; $0661: normal track data
 db $00 ; $0662: vol off, no pitch, no note, no instrument
 db $42 ; $0663: normal track data
 db $01 ; $0664: vol = $F (inverted), no pitch, no note, no instrument
 db $42 ; $0665: normal track data
 db $00 ; $0666: vol off, no pitch, no note, no instrument
trackDef67TitleMusik:
 db $42 ; $0667: normal track data
 db $80 ; $0668: vol off, pitch, no note, no instrument
 dw $0000 ; $0669: pitch
 db $02 ; $066B: normal track data,  wait 0
 db $C0 ; $066C: normal track data
 db $60 ; $066D: vol off, no pitch, note, instrument
 db $0D ; $066E: instrument
 db $42 ; $066F: normal track data
 db $00 ; $0670: vol off, no pitch, no note, no instrument
 db $5C ; $0671: normal track data
 db $60 ; $0672: vol off, no pitch, note, instrument
 db $0B ; $0673: instrument
 db $02 ; $0674: normal track data,  wait 0
 db $58 ; $0675: normal track data
 db $60 ; $0676: vol off, no pitch, note, instrument
 db $07 ; $0677: instrument
 db $42 ; $0678: normal track data
 db $00 ; $0679: vol off, no pitch, no note, no instrument
 db $C0 ; $067A: normal track data
 db $60 ; $067B: vol off, no pitch, note, instrument
 db $0E ; $067C: instrument
 db $42 ; $067D: normal track data
 db $00 ; $067E: vol off, no pitch, no note, no instrument
 db $58 ; $067F: normal track data
 db $60 ; $0680: vol off, no pitch, note, instrument
 db $07 ; $0681: instrument
 db $42 ; $0682: normal track data
 db $00 ; $0683: vol off, no pitch, no note, no instrument
 db $5C ; $0684: normal track data
 db $60 ; $0685: vol off, no pitch, note, instrument
 db $0B ; $0686: instrument
 db $1D ; $0687: full optimization, no escape: C#1
 db $1D ; $0688: full optimization, no escape: C#1
 db $1D ; $0689: full optimization, no escape: C#1
trackDef68TitleMusik:
 db $42 ; $068A: normal track data
 db $80 ; $068B: vol off, pitch, no note, no instrument
 dw $0000 ; $068C: pitch
 db $42 ; $068E: normal track data
 db $00 ; $068F: vol off, no pitch, no note, no instrument
 db $C0 ; $0690: normal track data
 db $61 ; $0691: vol = $F (inverted), no pitch, no note, no instrument
 db $09 ; $0692: instrument
 db $06 ; $0693: normal track data,  wait 2
 db $42 ; $0694: normal track data
 db $00 ; $0695: vol off, no pitch, no note, no instrument
 db $02 ; $0696: normal track data,  wait 0
 db $81 ; $0697: full optimization, no escape: D#5
 db $02 ; $0698: normal track data,  wait 0
 db $42 ; $0699: normal track data
 db $00 ; $069A: vol off, no pitch, no note, no instrument
 db $02 ; $069B: normal track data,  wait 0
 db $42 ; $069C: normal track data
 db $00 ; $069D: vol off, no pitch, no note, no instrument
 db $02 ; $069E: normal track data,  wait 0
 db $C0 ; $069F: normal track data
 db $60 ; $06A0: vol off, no pitch, note, instrument
 db $11 ; $06A1: instrument
 db $00 ; $06A2: track end signature found
trackDef69TitleMusik:
 db $42 ; $06A3: normal track data
 db $80 ; $06A4: vol off, pitch, no note, no instrument
 dw $0000 ; $06A5: pitch
 db $02 ; $06A7: normal track data,  wait 0
 db $C0 ; $06A8: normal track data
 db $60 ; $06A9: vol off, no pitch, note, instrument
 db $09 ; $06AA: instrument
 db $02 ; $06AB: normal track data,  wait 0
 db $42 ; $06AC: normal track data
 db $00 ; $06AD: vol off, no pitch, no note, no instrument
 db $02 ; $06AE: normal track data,  wait 0
 db $42 ; $06AF: normal track data
 db $00 ; $06B0: vol off, no pitch, no note, no instrument
 db $02 ; $06B1: normal track data,  wait 0
 db $C0 ; $06B2: normal track data
 db $60 ; $06B3: vol off, no pitch, note, instrument
 db $12 ; $06B4: instrument
 db $02 ; $06B5: normal track data,  wait 0
 db $42 ; $06B6: normal track data
 db $00 ; $06B7: vol off, no pitch, no note, no instrument
 db $02 ; $06B8: normal track data,  wait 0
 db $C0 ; $06B9: normal track data
 db $60 ; $06BA: vol off, no pitch, note, instrument
 db $09 ; $06BB: instrument
 db $00 ; $06BC: track end signature found
trackDef85TitleMusik:
 db $C0 ; $06BD: normal track data
 db $E0 ; $06BE: vol off, pitch, note, instrument
 dw $0000 ; $06BF: pitch
 db $09 ; $06C1: instrument
 db $02 ; $06C2: normal track data,  wait 0
 db $42 ; $06C3: normal track data
 db $00 ; $06C4: vol off, no pitch, no note, no instrument
 db $08 ; $06C5: normal track data,  wait 3
 db $C0 ; $06C6: normal track data,  note: D#5
 db $4D ; $06C7: vol = $9 (inverted), no pitch, no note, no instrument
 db $00 ; $06C8: track end signature found
trackDef84TitleMusik:
 db $5E ; $06C9: normal track data
 db $E0 ; $06CA: vol off, pitch, note, instrument
 dw $0000 ; $06CB: pitch
 db $05 ; $06CD: instrument
 db $8A ; $06CE: normal track data
 db $60 ; $06CF: vol off, no pitch, note, instrument
 db $06 ; $06D0: instrument
 db $42 ; $06D1: normal track data
 db $00 ; $06D2: vol off, no pitch, no note, no instrument
 db $00 ; $06D3: track end signature found
trackDef86TitleMusik:
 db $42 ; $06D4: normal track data
 db $80 ; $06D5: vol off, pitch, no note, no instrument
 dw $0000 ; $06D6: pitch
 db $00 ; $06D8: track end signature found
trackDef60TitleMusik:
 db $42 ; $06D9: normal track data
 db $80 ; $06DA: vol off, pitch, no note, no instrument
 dw $0002 ; $06DB: pitch
 db $42 ; $06DD: normal track data
 db $0B ; $06DE: vol = $A (inverted), no pitch, no note, no instrument
 db $42 ; $06DF: normal track data
 db $00 ; $06E0: vol off, no pitch, no note, no instrument
 db $42 ; $06E1: normal track data
 db $00 ; $06E2: vol off, no pitch, no note, no instrument
 db $42 ; $06E3: normal track data,  note: C0
 db $0D ; $06E4: vol = $9 (inverted), no pitch, no note, no instrument
 db $42 ; $06E5: normal track data
 db $00 ; $06E6: vol off, no pitch, no note, no instrument
 db $42 ; $06E7: normal track data
 db $00 ; $06E8: vol off, no pitch, no note, no instrument
 db $42 ; $06E9: normal track data,  note: C0
 db $0F ; $06EA: vol = $8 (inverted), no pitch, no note, no instrument
 db $42 ; $06EB: normal track data
 db $00 ; $06EC: vol off, no pitch, no note, no instrument
 db $42 ; $06ED: normal track data
 db $11 ; $06EE: vol = $7 (inverted), no pitch, no note, no instrument
 db $42 ; $06EF: normal track data
 db $00 ; $06F0: vol off, no pitch, no note, no instrument
 db $42 ; $06F1: normal track data
 db $13 ; $06F2: vol = $6 (inverted), no pitch, no note, no instrument
 db $42 ; $06F3: normal track data
 db $00 ; $06F4: vol off, no pitch, no note, no instrument
 db $42 ; $06F5: normal track data,  note: C0
 db $15 ; $06F6: vol = $5 (inverted), no pitch, no note, no instrument
 db $42 ; $06F7: normal track data
 db $19 ; $06F8: vol = $3 (inverted), no pitch, no note, no instrument
 db $42 ; $06F9: normal track data,  note: C0
 db $1F ; $06FA: vol = $0 (inverted), no pitch, no note, no instrument