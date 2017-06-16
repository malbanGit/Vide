; this file is part of Release, written by Malban in 2017
;

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
 dw $0168 ; $000A: size of instrument table (without this word pointer)
 dw instrument0TitleMusic ; $000C: [$0032] pointer to instrument 0
 dw instrument1TitleMusic ; $000E: [$003B] pointer to instrument 1
 dw instrument2TitleMusic ; $0010: [$0043] pointer to instrument 2
 dw instrument3TitleMusic ; $0012: [$0053] pointer to instrument 3
 dw instrument4TitleMusic ; $0014: [$0062] pointer to instrument 4
 dw instrument5TitleMusic ; $0016: [$0070] pointer to instrument 5
 dw instrument6TitleMusic ; $0018: [$007E] pointer to instrument 6
 dw instrument7TitleMusic ; $001A: [$0087] pointer to instrument 7
 dw instrument8TitleMusic ; $001C: [$0094] pointer to instrument 8
 dw instrument9TitleMusic ; $001E: [$009D] pointer to instrument 9
 dw instrument10TitleMusic ; $0020: [$00B6] pointer to instrument 10
 dw instrument11TitleMusic ; $0022: [$00C8] pointer to instrument 11
 dw instrument12TitleMusic ; $0024: [$00DD] pointer to instrument 12
 dw instrument13TitleMusic ; $0026: [$00EF] pointer to instrument 13
 dw instrument14TitleMusic ; $0028: [$00F9] pointer to instrument 14
 dw instrument15TitleMusic ; $002A: [$0104] pointer to instrument 15
 dw instrument16TitleMusic ; $002C: [$011D] pointer to instrument 16
 dw instrument17TitleMusic ; $002E: [$0142] pointer to instrument 17
 dw instrument18TitleMusic ; $0030: [$015B] pointer to instrument 18
instrument0TitleMusic:
 db $00 ; $0032: speed
 db $00 ; $0033: retrig
instrument0loopTitleMusic:
 db $00 ; $0034: dataColumn_0 (non hard), vol=$0
 db $00 ; $0035: dataColumn_0 (non hard), vol=$0
 db $00 ; $0036: dataColumn_0 (non hard), vol=$0
 db $00 ; $0037: dataColumn_0 (non hard), vol=$0
 db $0D ; $0038: dataColumn_0 (hard)
 dw instrument0loopTitleMusic ; $0039: [$0034] loop
instrument1TitleMusic:
 db $03 ; $003B: speed
 db $00 ; $003C: retrig
instrument1loopTitleMusic:
 db $3C ; $003D: dataColumn_0 (non hard), vol=$F
 db $7C ; $003E: dataColumn_0 (non hard), vol=$F
 db $0C ; $003F: arpegio
 db $0D ; $0040: dataColumn_0 (hard)
 dw instrument1loopTitleMusic ; $0041: [$003D] loop
instrument2TitleMusic:
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
 dw instrument0loopTitleMusic ; $0051: [$0034] loop
instrument3TitleMusic:
 db $01 ; $0053: speed
 db $00 ; $0054: retrig
 db $28 ; $0055: dataColumn_0 (non hard), vol=$A
 db $24 ; $0056: dataColumn_0 (non hard), vol=$9
 db $24 ; $0057: dataColumn_0 (non hard), vol=$9
 db $20 ; $0058: dataColumn_0 (non hard), vol=$8
 db $1C ; $0059: dataColumn_0 (non hard), vol=$7
 db $18 ; $005A: dataColumn_0 (non hard), vol=$6
instrument3loopTitleMusic:
 db $14 ; $005B: dataColumn_0 (non hard), vol=$5
 db $14 ; $005C: dataColumn_0 (non hard), vol=$5
 db $14 ; $005D: dataColumn_0 (non hard), vol=$5
 db $14 ; $005E: dataColumn_0 (non hard), vol=$5
 db $0D ; $005F: dataColumn_0 (hard)
 dw instrument3loopTitleMusic ; $0060: [$005B] loop
instrument4TitleMusic:
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
 dw instrument0loopTitleMusic ; $006E: [$0034] loop
instrument5TitleMusic:
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
 dw instrument0loopTitleMusic ; $007C: [$0034] loop
instrument6TitleMusic:
 db $01 ; $007E: speed
 db $00 ; $007F: retrig
 db $2A ; $0080: dataColumn_0 (non hard), vol=$A
 db $01 ; $0081: dataColumn_1, noise=$01
 db $2E ; $0082: dataColumn_0 (non hard), vol=$B
 db $01 ; $0083: dataColumn_1, noise=$01
 db $0D ; $0084: dataColumn_0 (hard)
 dw instrument0loopTitleMusic ; $0085: [$0034] loop
instrument7TitleMusic:
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
 dw instrument0loopTitleMusic ; $0092: [$0034] loop
instrument8TitleMusic:
 db $01 ; $0094: speed
 db $00 ; $0095: retrig
 db $2A ; $0096: dataColumn_0 (non hard), vol=$A
 db $03 ; $0097: dataColumn_1, noise=$03
 db $26 ; $0098: dataColumn_0 (non hard), vol=$9
 db $03 ; $0099: dataColumn_1, noise=$03
 db $0D ; $009A: dataColumn_0 (hard)
 dw instrument0loopTitleMusic ; $009B: [$0034] loop
instrument9TitleMusic:
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
 dw instrument0loopTitleMusic ; $00B4: [$0034] loop
instrument10TitleMusic:
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
 dw instrument0loopTitleMusic ; $00C6: [$0034] loop
instrument11TitleMusic:
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
 dw instrument0loopTitleMusic ; $00DB: [$0034] loop
instrument12TitleMusic:
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
 dw instrument0loopTitleMusic ; $00ED: [$0034] loop
instrument13TitleMusic:
 db $01 ; $00EF: speed
 db $00 ; $00F0: retrig
 db $6C ; $00F1: dataColumn_0 (non hard), vol=$B
 db $0C ; $00F2: arpegio
 db $24 ; $00F3: dataColumn_0 (non hard), vol=$9
 db $60 ; $00F4: dataColumn_0 (non hard), vol=$8
 db $0C ; $00F5: arpegio
 db $0D ; $00F6: dataColumn_0 (hard)
 dw instrument0loopTitleMusic ; $00F7: [$0034] loop
instrument14TitleMusic:
 db $01 ; $00F9: speed
 db $00 ; $00FA: retrig
 db $2C ; $00FB: dataColumn_0 (non hard), vol=$B
 db $6C ; $00FC: dataColumn_0 (non hard), vol=$B
 db $0C ; $00FD: arpegio
 db $18 ; $00FE: dataColumn_0 (non hard), vol=$6
 db $54 ; $00FF: dataColumn_0 (non hard), vol=$5
 db $18 ; $0100: arpegio
 db $0D ; $0101: dataColumn_0 (hard)
 dw instrument0loopTitleMusic ; $0102: [$0034] loop
instrument15TitleMusic:
 db $01 ; $0104: speed
 db $00 ; $0105: retrig
instrument15loopTitleMusic:
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
 dw instrument15loopTitleMusic ; $011B: [$0106] loop
instrument16TitleMusic:
 db $03 ; $011D: speed
 db $00 ; $011E: retrig
instrument16loopTitleMusic:
 db $F4 ; $011F: dataColumn_0 (non hard), vol=$D
 dw $FFF1 ; $0120: pitch
 db $0C ; $0122: arpegio
 db $F4 ; $0123: dataColumn_0 (non hard), vol=$D
 dw $FFDE ; $0124: pitch
 db $0F ; $0126: arpegio
 db $F4 ; $0127: dataColumn_0 (non hard), vol=$D
 dw $FFF1 ; $0128: pitch
 db $0C ; $012A: arpegio
 db $F4 ; $012B: dataColumn_0 (non hard), vol=$D
 dw $FFDE ; $012C: pitch
 db $0F ; $012E: arpegio
 db $F4 ; $012F: dataColumn_0 (non hard), vol=$D
 dw $FFF1 ; $0130: pitch
 db $0C ; $0132: arpegio
 db $F4 ; $0133: dataColumn_0 (non hard), vol=$D
 dw $FFDE ; $0134: pitch
 db $0F ; $0136: arpegio
 db $F4 ; $0137: dataColumn_0 (non hard), vol=$D
 dw $FFF1 ; $0138: pitch
 db $0C ; $013A: arpegio
 db $F4 ; $013B: dataColumn_0 (non hard), vol=$D
 dw $FFDE ; $013C: pitch
 db $0F ; $013E: arpegio
 db $0D ; $013F: dataColumn_0 (hard)
 dw instrument16loopTitleMusic ; $0140: [$011F] loop
instrument17TitleMusic:
 db $03 ; $0142: speed
 db $00 ; $0143: retrig
 db $30 ; $0144: dataColumn_0 (non hard), vol=$C
 db $70 ; $0145: dataColumn_0 (non hard), vol=$C
 db $02 ; $0146: arpegio
 db $6C ; $0147: dataColumn_0 (non hard), vol=$B
 db $07 ; $0148: arpegio
 db $28 ; $0149: dataColumn_0 (non hard), vol=$A
 db $68 ; $014A: dataColumn_0 (non hard), vol=$A
 db $02 ; $014B: arpegio
 db $64 ; $014C: dataColumn_0 (non hard), vol=$9
 db $07 ; $014D: arpegio
 db $24 ; $014E: dataColumn_0 (non hard), vol=$9
 db $60 ; $014F: dataColumn_0 (non hard), vol=$8
 db $02 ; $0150: arpegio
 db $60 ; $0151: dataColumn_0 (non hard), vol=$8
 db $07 ; $0152: arpegio
 db $20 ; $0153: dataColumn_0 (non hard), vol=$8
 db $58 ; $0154: dataColumn_0 (non hard), vol=$6
 db $02 ; $0155: arpegio
 db $54 ; $0156: dataColumn_0 (non hard), vol=$5
 db $07 ; $0157: arpegio
 db $0D ; $0158: dataColumn_0 (hard)
 dw instrument0loopTitleMusic ; $0159: [$0034] loop
instrument18TitleMusic:
 db $03 ; $015B: speed
 db $00 ; $015C: retrig
 db $30 ; $015D: dataColumn_0 (non hard), vol=$C
 db $70 ; $015E: dataColumn_0 (non hard), vol=$C
 db $05 ; $015F: arpegio
 db $6C ; $0160: dataColumn_0 (non hard), vol=$B
 db $07 ; $0161: arpegio
 db $28 ; $0162: dataColumn_0 (non hard), vol=$A
 db $68 ; $0163: dataColumn_0 (non hard), vol=$A
 db $05 ; $0164: arpegio
 db $64 ; $0165: dataColumn_0 (non hard), vol=$9
 db $07 ; $0166: arpegio
 db $24 ; $0167: dataColumn_0 (non hard), vol=$9
 db $60 ; $0168: dataColumn_0 (non hard), vol=$8
 db $05 ; $0169: arpegio
 db $60 ; $016A: dataColumn_0 (non hard), vol=$8
 db $07 ; $016B: arpegio
 db $20 ; $016C: dataColumn_0 (non hard), vol=$8
 db $58 ; $016D: dataColumn_0 (non hard), vol=$6
 db $05 ; $016E: arpegio
 db $54 ; $016F: dataColumn_0 (non hard), vol=$5
 db $07 ; $0170: arpegio
 db $0D ; $0171: dataColumn_0 (hard)
 dw instrument0loopTitleMusic ; $0172: [$0034] loop
; start of linker definition
linkerTitleMusic:
 db $20 ; $0174: first height
 db $00 ; $0175: transposition1
 db $00 ; $0176: transposition2
 db $00 ; $0177: transposition3
 dw specialtrackDef0TitleMusic ; $0178: [$039B] specialTrack
pattern0DefinitionTitleMusic:
 db $10 ; $017A: pattern 0 state
 dw trackDef0TitleMusic ; $017B: [$03A2] pattern 0, track 1
 dw trackDef1TitleMusic ; $017D: [$039D] pattern 0, track 2
 dw trackDef1TitleMusic ; $017F: [$039D] pattern 0, track 3
 db $20 ; $0181: new height
pattern1DefinitionTitleMusic:
 db $10 ; $0182: pattern 1 state
 dw trackDef3TitleMusic ; $0183: [$03E7] pattern 1, track 1
 dw trackDef1TitleMusic ; $0185: [$039D] pattern 1, track 2
 dw trackDef1TitleMusic ; $0187: [$039D] pattern 1, track 3
 db $0D ; $0189: new height
pattern2DefinitionTitleMusic:
 db $10 ; $018A: pattern 2 state
 dw trackDef4TitleMusic ; $018B: [$03F4] pattern 2, track 1
 dw trackDef5TitleMusic ; $018D: [$0424] pattern 2, track 2
 dw trackDef6TitleMusic ; $018F: [$0447] pattern 2, track 3
 db $10 ; $0191: new height
pattern3DefinitionTitleMusic:
 db $00 ; $0192: pattern 3 state
 dw trackDef7TitleMusic ; $0193: [$0402] pattern 3, track 1
 dw trackDef5TitleMusic ; $0195: [$0424] pattern 3, track 2
 dw trackDef6TitleMusic ; $0197: [$0447] pattern 3, track 3
pattern4DefinitionTitleMusic:
 db $00 ; $0199: pattern 4 state
 dw trackDef9TitleMusic ; $019A: [$040F] pattern 4, track 1
 dw trackDef5TitleMusic ; $019C: [$0424] pattern 4, track 2
 dw trackDef6TitleMusic ; $019E: [$0447] pattern 4, track 3
pattern5DefinitionTitleMusic:
 db $00 ; $01A0: pattern 5 state
 dw trackDef1TitleMusic ; $01A1: [$039D] pattern 5, track 1
 dw trackDef5TitleMusic ; $01A3: [$0424] pattern 5, track 2
 dw trackDef6TitleMusic ; $01A5: [$0447] pattern 5, track 3
pattern6DefinitionTitleMusic:
 db $00 ; $01A7: pattern 6 state
 dw trackDef1TitleMusic ; $01A8: [$039D] pattern 6, track 1
 dw trackDef5TitleMusic ; $01AA: [$0424] pattern 6, track 2
 dw trackDef6TitleMusic ; $01AC: [$0447] pattern 6, track 3
pattern7DefinitionTitleMusic:
 db $00 ; $01AE: pattern 7 state
 dw trackDef1TitleMusic ; $01AF: [$039D] pattern 7, track 1
 dw trackDef5TitleMusic ; $01B1: [$0424] pattern 7, track 2
 dw trackDef6TitleMusic ; $01B3: [$0447] pattern 7, track 3
pattern8DefinitionTitleMusic:
 db $00 ; $01B5: pattern 8 state
 dw trackDef1TitleMusic ; $01B6: [$039D] pattern 8, track 1
 dw trackDef5TitleMusic ; $01B8: [$0424] pattern 8, track 2
 dw trackDef6TitleMusic ; $01BA: [$0447] pattern 8, track 3
pattern9DefinitionTitleMusic:
 db $00 ; $01BC: pattern 9 state
 dw trackDef1TitleMusic ; $01BD: [$039D] pattern 9, track 1
 dw trackDef5TitleMusic ; $01BF: [$0424] pattern 9, track 2
 dw trackDef6TitleMusic ; $01C1: [$0447] pattern 9, track 3
pattern10DefinitionTitleMusic:
 db $02 ; $01C3: pattern 10 state
 db $07 ; $01C4: transposition 1
 dw trackDef16TitleMusic ; $01C5: [$046A] pattern 10, track 1
 dw trackDef5TitleMusic ; $01C7: [$0424] pattern 10, track 2
 dw trackDef6TitleMusic ; $01C9: [$0447] pattern 10, track 3
pattern11DefinitionTitleMusic:
 db $00 ; $01CB: pattern 11 state
 dw trackDef16TitleMusic ; $01CC: [$046A] pattern 11, track 1
 dw trackDef5TitleMusic ; $01CE: [$0424] pattern 11, track 2
 dw trackDef6TitleMusic ; $01D0: [$0447] pattern 11, track 3
pattern12DefinitionTitleMusic:
 db $00 ; $01D2: pattern 12 state
 dw trackDef16TitleMusic ; $01D3: [$046A] pattern 12, track 1
 dw trackDef5TitleMusic ; $01D5: [$0424] pattern 12, track 2
 dw trackDef6TitleMusic ; $01D7: [$0447] pattern 12, track 3
pattern13DefinitionTitleMusic:
 db $00 ; $01D9: pattern 13 state
 dw trackDef16TitleMusic ; $01DA: [$046A] pattern 13, track 1
 dw trackDef5TitleMusic ; $01DC: [$0424] pattern 13, track 2
 dw trackDef6TitleMusic ; $01DE: [$0447] pattern 13, track 3
pattern14DefinitionTitleMusic:
 db $02 ; $01E0: pattern 14 state
 db $03 ; $01E1: transposition 1
 dw trackDef16TitleMusic ; $01E2: [$046A] pattern 14, track 1
 dw trackDef5TitleMusic ; $01E4: [$0424] pattern 14, track 2
 dw trackDef6TitleMusic ; $01E6: [$0447] pattern 14, track 3
pattern15DefinitionTitleMusic:
 db $00 ; $01E8: pattern 15 state
 dw trackDef16TitleMusic ; $01E9: [$046A] pattern 15, track 1
 dw trackDef5TitleMusic ; $01EB: [$0424] pattern 15, track 2
 dw trackDef6TitleMusic ; $01ED: [$0447] pattern 15, track 3
pattern16DefinitionTitleMusic:
 db $00 ; $01EF: pattern 16 state
 dw trackDef16TitleMusic ; $01F0: [$046A] pattern 16, track 1
 dw trackDef5TitleMusic ; $01F2: [$0424] pattern 16, track 2
 dw trackDef6TitleMusic ; $01F4: [$0447] pattern 16, track 3
pattern17DefinitionTitleMusic:
 db $00 ; $01F6: pattern 17 state
 dw trackDef16TitleMusic ; $01F7: [$046A] pattern 17, track 1
 dw trackDef5TitleMusic ; $01F9: [$0424] pattern 17, track 2
 dw trackDef6TitleMusic ; $01FB: [$0447] pattern 17, track 3
pattern18DefinitionTitleMusic:
 db $02 ; $01FD: pattern 18 state
 db $00 ; $01FE: transposition 1
 dw trackDef16TitleMusic ; $01FF: [$046A] pattern 18, track 1
 dw trackDef5TitleMusic ; $0201: [$0424] pattern 18, track 2
 dw trackDef6TitleMusic ; $0203: [$0447] pattern 18, track 3
pattern19DefinitionTitleMusic:
 db $00 ; $0205: pattern 19 state
 dw trackDef16TitleMusic ; $0206: [$046A] pattern 19, track 1
 dw trackDef5TitleMusic ; $0208: [$0424] pattern 19, track 2
 dw trackDef6TitleMusic ; $020A: [$0447] pattern 19, track 3
pattern20DefinitionTitleMusic:
 db $00 ; $020C: pattern 20 state
 dw trackDef16TitleMusic ; $020D: [$046A] pattern 20, track 1
 dw trackDef5TitleMusic ; $020F: [$0424] pattern 20, track 2
 dw trackDef6TitleMusic ; $0211: [$0447] pattern 20, track 3
pattern21DefinitionTitleMusic:
 db $00 ; $0213: pattern 21 state
 dw trackDef16TitleMusic ; $0214: [$046A] pattern 21, track 1
 dw trackDef5TitleMusic ; $0216: [$0424] pattern 21, track 2
 dw trackDef6TitleMusic ; $0218: [$0447] pattern 21, track 3
pattern22DefinitionTitleMusic:
 db $02 ; $021A: pattern 22 state
 db $02 ; $021B: transposition 1
 dw trackDef16TitleMusic ; $021C: [$046A] pattern 22, track 1
 dw trackDef5TitleMusic ; $021E: [$0424] pattern 22, track 2
 dw trackDef6TitleMusic ; $0220: [$0447] pattern 22, track 3
pattern23DefinitionTitleMusic:
 db $00 ; $0222: pattern 23 state
 dw trackDef16TitleMusic ; $0223: [$046A] pattern 23, track 1
 dw trackDef5TitleMusic ; $0225: [$0424] pattern 23, track 2
 dw trackDef6TitleMusic ; $0227: [$0447] pattern 23, track 3
pattern24DefinitionTitleMusic:
 db $00 ; $0229: pattern 24 state
 dw trackDef16TitleMusic ; $022A: [$046A] pattern 24, track 1
 dw trackDef5TitleMusic ; $022C: [$0424] pattern 24, track 2
 dw trackDef6TitleMusic ; $022E: [$0447] pattern 24, track 3
pattern25DefinitionTitleMusic:
 db $00 ; $0230: pattern 25 state
 dw trackDef16TitleMusic ; $0231: [$046A] pattern 25, track 1
 dw trackDef5TitleMusic ; $0233: [$0424] pattern 25, track 2
 dw trackDef6TitleMusic ; $0235: [$0447] pattern 25, track 3
pattern26DefinitionTitleMusic:
 db $02 ; $0237: pattern 26 state
 db $03 ; $0238: transposition 1
 dw trackDef16TitleMusic ; $0239: [$046A] pattern 26, track 1
 dw trackDef5TitleMusic ; $023B: [$0424] pattern 26, track 2
 dw trackDef6TitleMusic ; $023D: [$0447] pattern 26, track 3
pattern27DefinitionTitleMusic:
 db $00 ; $023F: pattern 27 state
 dw trackDef16TitleMusic ; $0240: [$046A] pattern 27, track 1
 dw trackDef5TitleMusic ; $0242: [$0424] pattern 27, track 2
 dw trackDef6TitleMusic ; $0244: [$0447] pattern 27, track 3
pattern28DefinitionTitleMusic:
 db $00 ; $0246: pattern 28 state
 dw trackDef16TitleMusic ; $0247: [$046A] pattern 28, track 1
 dw trackDef5TitleMusic ; $0249: [$0424] pattern 28, track 2
 dw trackDef6TitleMusic ; $024B: [$0447] pattern 28, track 3
pattern29DefinitionTitleMusic:
 db $00 ; $024D: pattern 29 state
 dw trackDef16TitleMusic ; $024E: [$046A] pattern 29, track 1
 dw trackDef5TitleMusic ; $0250: [$0424] pattern 29, track 2
 dw trackDef6TitleMusic ; $0252: [$0447] pattern 29, track 3
pattern30DefinitionTitleMusic:
 db $02 ; $0254: pattern 30 state
 db $05 ; $0255: transposition 1
 dw trackDef16TitleMusic ; $0256: [$046A] pattern 30, track 1
 dw trackDef5TitleMusic ; $0258: [$0424] pattern 30, track 2
 dw trackDef6TitleMusic ; $025A: [$0447] pattern 30, track 3
pattern31DefinitionTitleMusic:
 db $00 ; $025C: pattern 31 state
 dw trackDef16TitleMusic ; $025D: [$046A] pattern 31, track 1
 dw trackDef5TitleMusic ; $025F: [$0424] pattern 31, track 2
 dw trackDef6TitleMusic ; $0261: [$0447] pattern 31, track 3
pattern32DefinitionTitleMusic:
 db $00 ; $0263: pattern 32 state
 dw trackDef16TitleMusic ; $0264: [$046A] pattern 32, track 1
 dw trackDef5TitleMusic ; $0266: [$0424] pattern 32, track 2
 dw trackDef6TitleMusic ; $0268: [$0447] pattern 32, track 3
pattern33DefinitionTitleMusic:
 db $00 ; $026A: pattern 33 state
 dw trackDef16TitleMusic ; $026B: [$046A] pattern 33, track 1
 dw trackDef5TitleMusic ; $026D: [$0424] pattern 33, track 2
 dw trackDef6TitleMusic ; $026F: [$0447] pattern 33, track 3
pattern34DefinitionTitleMusic:
 db $02 ; $0271: pattern 34 state
 db $00 ; $0272: transposition 1
 dw trackDef41TitleMusic ; $0273: [$047E] pattern 34, track 1
 dw trackDef5TitleMusic ; $0275: [$0424] pattern 34, track 2
 dw trackDef43TitleMusic ; $0277: [$04DB] pattern 34, track 3
pattern35DefinitionTitleMusic:
 db $00 ; $0279: pattern 35 state
 dw trackDef44TitleMusic ; $027A: [$04AC] pattern 35, track 1
 dw trackDef5TitleMusic ; $027C: [$0424] pattern 35, track 2
 dw trackDef46TitleMusic ; $027E: [$0502] pattern 35, track 3
pattern36DefinitionTitleMusic:
 db $00 ; $0280: pattern 36 state
 dw trackDef41TitleMusic ; $0281: [$047E] pattern 36, track 1
 dw trackDef5TitleMusic ; $0283: [$0424] pattern 36, track 2
 dw trackDef43TitleMusic ; $0285: [$04DB] pattern 36, track 3
pattern37DefinitionTitleMusic:
 db $00 ; $0287: pattern 37 state
 dw trackDef44TitleMusic ; $0288: [$04AC] pattern 37, track 1
 dw trackDef5TitleMusic ; $028A: [$0424] pattern 37, track 2
 dw trackDef46TitleMusic ; $028C: [$0502] pattern 37, track 3
pattern38DefinitionTitleMusic:
 db $00 ; $028E: pattern 38 state
 dw trackDef41TitleMusic ; $028F: [$047E] pattern 38, track 1
 dw trackDef5TitleMusic ; $0291: [$0424] pattern 38, track 2
 dw trackDef43TitleMusic ; $0293: [$04DB] pattern 38, track 3
pattern39DefinitionTitleMusic:
 db $00 ; $0295: pattern 39 state
 dw trackDef44TitleMusic ; $0296: [$04AC] pattern 39, track 1
 dw trackDef5TitleMusic ; $0298: [$0424] pattern 39, track 2
 dw trackDef46TitleMusic ; $029A: [$0502] pattern 39, track 3
pattern40DefinitionTitleMusic:
 db $00 ; $029C: pattern 40 state
 dw trackDef41TitleMusic ; $029D: [$047E] pattern 40, track 1
 dw trackDef5TitleMusic ; $029F: [$0424] pattern 40, track 2
 dw trackDef43TitleMusic ; $02A1: [$04DB] pattern 40, track 3
pattern41DefinitionTitleMusic:
 db $00 ; $02A3: pattern 41 state
 dw trackDef44TitleMusic ; $02A4: [$04AC] pattern 41, track 1
 dw trackDef5TitleMusic ; $02A6: [$0424] pattern 41, track 2
 dw trackDef46TitleMusic ; $02A8: [$0502] pattern 41, track 3
pattern42DefinitionTitleMusic:
 db $00 ; $02AA: pattern 42 state
 dw trackDef53TitleMusic ; $02AB: [$0529] pattern 42, track 1
 dw trackDef54TitleMusic ; $02AD: [$0581] pattern 42, track 2
 dw trackDef55TitleMusic ; $02AF: [$0559] pattern 42, track 3
pattern43DefinitionTitleMusic:
 db $00 ; $02B1: pattern 43 state
 dw trackDef53TitleMusic ; $02B2: [$0529] pattern 43, track 1
 dw trackDef56TitleMusic ; $02B4: [$05A4] pattern 43, track 2
 dw trackDef55TitleMusic ; $02B6: [$0559] pattern 43, track 3
pattern44DefinitionTitleMusic:
 db $00 ; $02B8: pattern 44 state
 dw trackDef53TitleMusic ; $02B9: [$0529] pattern 44, track 1
 dw trackDef56TitleMusic ; $02BB: [$05A4] pattern 44, track 2
 dw trackDef55TitleMusic ; $02BD: [$0559] pattern 44, track 3
pattern45DefinitionTitleMusic:
 db $00 ; $02BF: pattern 45 state
 dw trackDef53TitleMusic ; $02C0: [$0529] pattern 45, track 1
 dw trackDef58TitleMusic ; $02C2: [$05C6] pattern 45, track 2
 dw trackDef55TitleMusic ; $02C4: [$0559] pattern 45, track 3
pattern46DefinitionTitleMusic:
 db $00 ; $02C6: pattern 46 state
 dw trackDef59TitleMusic ; $02C7: [$05E8] pattern 46, track 1
 dw trackDef60TitleMusic ; $02C9: [$06D5] pattern 46, track 2
 dw trackDef61TitleMusic ; $02CB: [$0618] pattern 46, track 3
pattern47DefinitionTitleMusic:
 db $00 ; $02CD: pattern 47 state
 dw trackDef59TitleMusic ; $02CE: [$05E8] pattern 47, track 1
 dw trackDef1TitleMusic ; $02D0: [$039D] pattern 47, track 2
 dw trackDef61TitleMusic ; $02D2: [$0618] pattern 47, track 3
pattern48DefinitionTitleMusic:
 db $00 ; $02D4: pattern 48 state
 dw trackDef59TitleMusic ; $02D5: [$05E8] pattern 48, track 1
 dw trackDef1TitleMusic ; $02D7: [$039D] pattern 48, track 2
 dw trackDef61TitleMusic ; $02D9: [$0618] pattern 48, track 3
pattern49DefinitionTitleMusic:
 db $00 ; $02DB: pattern 49 state
 dw trackDef59TitleMusic ; $02DC: [$05E8] pattern 49, track 1
 dw trackDef1TitleMusic ; $02DE: [$039D] pattern 49, track 2
 dw trackDef61TitleMusic ; $02E0: [$0618] pattern 49, track 3
pattern50DefinitionTitleMusic:
 db $00 ; $02E2: pattern 50 state
 dw trackDef53TitleMusic ; $02E3: [$0529] pattern 50, track 1
 dw trackDef62TitleMusic ; $02E5: [$0640] pattern 50, track 2
 dw trackDef55TitleMusic ; $02E7: [$0559] pattern 50, track 3
pattern51DefinitionTitleMusic:
 db $00 ; $02E9: pattern 51 state
 dw trackDef53TitleMusic ; $02EA: [$0529] pattern 51, track 1
 dw trackDef56TitleMusic ; $02EC: [$05A4] pattern 51, track 2
 dw trackDef55TitleMusic ; $02EE: [$0559] pattern 51, track 3
pattern52DefinitionTitleMusic:
 db $00 ; $02F0: pattern 52 state
 dw trackDef53TitleMusic ; $02F1: [$0529] pattern 52, track 1
 dw trackDef56TitleMusic ; $02F3: [$05A4] pattern 52, track 2
 dw trackDef55TitleMusic ; $02F5: [$0559] pattern 52, track 3
pattern53DefinitionTitleMusic:
 db $00 ; $02F7: pattern 53 state
 dw trackDef53TitleMusic ; $02F8: [$0529] pattern 53, track 1
 dw trackDef58TitleMusic ; $02FA: [$05C6] pattern 53, track 2
 dw trackDef55TitleMusic ; $02FC: [$0559] pattern 53, track 3
pattern54DefinitionTitleMusic:
 db $00 ; $02FE: pattern 54 state
 dw trackDef59TitleMusic ; $02FF: [$05E8] pattern 54, track 1
 dw trackDef60TitleMusic ; $0301: [$06D5] pattern 54, track 2
 dw trackDef61TitleMusic ; $0303: [$0618] pattern 54, track 3
pattern55DefinitionTitleMusic:
 db $00 ; $0305: pattern 55 state
 dw trackDef59TitleMusic ; $0306: [$05E8] pattern 55, track 1
 dw trackDef1TitleMusic ; $0308: [$039D] pattern 55, track 2
 dw trackDef61TitleMusic ; $030A: [$0618] pattern 55, track 3
pattern56DefinitionTitleMusic:
 db $00 ; $030C: pattern 56 state
 dw trackDef59TitleMusic ; $030D: [$05E8] pattern 56, track 1
 dw trackDef1TitleMusic ; $030F: [$039D] pattern 56, track 2
 dw trackDef61TitleMusic ; $0311: [$0618] pattern 56, track 3
pattern57DefinitionTitleMusic:
 db $00 ; $0313: pattern 57 state
 dw trackDef59TitleMusic ; $0314: [$05E8] pattern 57, track 1
 dw trackDef1TitleMusic ; $0316: [$039D] pattern 57, track 2
 dw trackDef67TitleMusic ; $0318: [$0663] pattern 57, track 3
pattern58DefinitionTitleMusic:
 db $00 ; $031A: pattern 58 state
 dw trackDef53TitleMusic ; $031B: [$0529] pattern 58, track 1
 dw trackDef68TitleMusic ; $031D: [$0686] pattern 58, track 2
 dw trackDef55TitleMusic ; $031F: [$0559] pattern 58, track 3
pattern59DefinitionTitleMusic:
 db $00 ; $0321: pattern 59 state
 dw trackDef53TitleMusic ; $0322: [$0529] pattern 59, track 1
 dw trackDef69TitleMusic ; $0324: [$069F] pattern 59, track 2
 dw trackDef55TitleMusic ; $0326: [$0559] pattern 59, track 3
pattern60DefinitionTitleMusic:
 db $00 ; $0328: pattern 60 state
 dw trackDef53TitleMusic ; $0329: [$0529] pattern 60, track 1
 dw trackDef68TitleMusic ; $032B: [$0686] pattern 60, track 2
 dw trackDef55TitleMusic ; $032D: [$0559] pattern 60, track 3
pattern61DefinitionTitleMusic:
 db $00 ; $032F: pattern 61 state
 dw trackDef53TitleMusic ; $0330: [$0529] pattern 61, track 1
 dw trackDef69TitleMusic ; $0332: [$069F] pattern 61, track 2
 dw trackDef55TitleMusic ; $0334: [$0559] pattern 61, track 3
pattern62DefinitionTitleMusic:
 db $00 ; $0336: pattern 62 state
 dw trackDef59TitleMusic ; $0337: [$05E8] pattern 62, track 1
 dw trackDef68TitleMusic ; $0339: [$0686] pattern 62, track 2
 dw trackDef61TitleMusic ; $033B: [$0618] pattern 62, track 3
pattern63DefinitionTitleMusic:
 db $00 ; $033D: pattern 63 state
 dw trackDef59TitleMusic ; $033E: [$05E8] pattern 63, track 1
 dw trackDef69TitleMusic ; $0340: [$069F] pattern 63, track 2
 dw trackDef61TitleMusic ; $0342: [$0618] pattern 63, track 3
pattern64DefinitionTitleMusic:
 db $00 ; $0344: pattern 64 state
 dw trackDef59TitleMusic ; $0345: [$05E8] pattern 64, track 1
 dw trackDef68TitleMusic ; $0347: [$0686] pattern 64, track 2
 dw trackDef61TitleMusic ; $0349: [$0618] pattern 64, track 3
pattern65DefinitionTitleMusic:
 db $00 ; $034B: pattern 65 state
 dw trackDef59TitleMusic ; $034C: [$05E8] pattern 65, track 1
 dw trackDef69TitleMusic ; $034E: [$069F] pattern 65, track 2
 dw trackDef61TitleMusic ; $0350: [$0618] pattern 65, track 3
pattern66DefinitionTitleMusic:
 db $00 ; $0352: pattern 66 state
 dw trackDef53TitleMusic ; $0353: [$0529] pattern 66, track 1
 dw trackDef68TitleMusic ; $0355: [$0686] pattern 66, track 2
 dw trackDef55TitleMusic ; $0357: [$0559] pattern 66, track 3
pattern67DefinitionTitleMusic:
 db $00 ; $0359: pattern 67 state
 dw trackDef53TitleMusic ; $035A: [$0529] pattern 67, track 1
 dw trackDef69TitleMusic ; $035C: [$069F] pattern 67, track 2
 dw trackDef55TitleMusic ; $035E: [$0559] pattern 67, track 3
pattern68DefinitionTitleMusic:
 db $00 ; $0360: pattern 68 state
 dw trackDef53TitleMusic ; $0361: [$0529] pattern 68, track 1
 dw trackDef68TitleMusic ; $0363: [$0686] pattern 68, track 2
 dw trackDef55TitleMusic ; $0365: [$0559] pattern 68, track 3
pattern69DefinitionTitleMusic:
 db $00 ; $0367: pattern 69 state
 dw trackDef53TitleMusic ; $0368: [$0529] pattern 69, track 1
 dw trackDef69TitleMusic ; $036A: [$069F] pattern 69, track 2
 dw trackDef55TitleMusic ; $036C: [$0559] pattern 69, track 3
pattern70DefinitionTitleMusic:
 db $00 ; $036E: pattern 70 state
 dw trackDef59TitleMusic ; $036F: [$05E8] pattern 70, track 1
 dw trackDef68TitleMusic ; $0371: [$0686] pattern 70, track 2
 dw trackDef61TitleMusic ; $0373: [$0618] pattern 70, track 3
pattern71DefinitionTitleMusic:
 db $00 ; $0375: pattern 71 state
 dw trackDef59TitleMusic ; $0376: [$05E8] pattern 71, track 1
 dw trackDef69TitleMusic ; $0378: [$069F] pattern 71, track 2
 dw trackDef61TitleMusic ; $037A: [$0618] pattern 71, track 3
pattern72DefinitionTitleMusic:
 db $00 ; $037C: pattern 72 state
 dw trackDef59TitleMusic ; $037D: [$05E8] pattern 72, track 1
 dw trackDef68TitleMusic ; $037F: [$0686] pattern 72, track 2
 dw trackDef61TitleMusic ; $0381: [$0618] pattern 72, track 3
pattern73DefinitionTitleMusic:
 db $00 ; $0383: pattern 73 state
 dw trackDef59TitleMusic ; $0384: [$05E8] pattern 73, track 1
 dw trackDef69TitleMusic ; $0386: [$069F] pattern 73, track 2
 dw trackDef61TitleMusic ; $0388: [$0618] pattern 73, track 3
pattern74DefinitionTitleMusic:
 db $00 ; $038A: pattern 74 state
 dw trackDef84TitleMusic ; $038B: [$06C5] pattern 74, track 1
 dw trackDef85TitleMusic ; $038D: [$06B9] pattern 74, track 2
 dw trackDef86TitleMusic ; $038F: [$06D0] pattern 74, track 3
pattern75DefinitionTitleMusic:
 db $00 ; $0391: pattern 75 state
 dw trackDef1TitleMusic ; $0392: [$039D] pattern 75, track 1
 dw trackDef1TitleMusic ; $0394: [$039D] pattern 75, track 2
 dw trackDef1TitleMusic ; $0396: [$039D] pattern 75, track 3
pattern76DefinitionTitleMusic:
 db $01 ; $0398: pattern 76 state
 dw pattern0DefinitionTitleMusic ; $0399: [$017A] song restart address
specialtrackDef0TitleMusic:
 db $15 ; $039B: data, speed 5
 db $00 ; $039C: wait 128
trackDef1TitleMusic:
 db $42 ; $039D: normal track data
 db $80 ; $039E: vol off, pitch, no note, no instrument
 dw $0000 ; $039F: pitch
 db $00 ; $03A1: track end signature found
trackDef0TitleMusic:
 db $52 ; $03A2: normal track data
 db $E1 ; $03A3: vol = $F (inverted), no pitch, no note, no instrument
 dw $0000 ; $03A4: pitch
 db $01 ; $03A6: instrument
 db $42 ; $03A7: normal track data
 db $80 ; $03A8: vol off, pitch, no note, no instrument
 dw $FFF6 ; $03A9: pitch
 db $42 ; $03AB: normal track data
 db $00 ; $03AC: vol off, no pitch, no note, no instrument
 db $42 ; $03AD: normal track data
 db $00 ; $03AE: vol off, no pitch, no note, no instrument
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
trackDef3TitleMusic:
 db $42 ; $03E7: normal track data
 db $80 ; $03E8: vol off, pitch, no note, no instrument
 dw $0000 ; $03E9: pitch
 db $42 ; $03EB: normal track data
 db $00 ; $03EC: vol off, no pitch, no note, no instrument
 db $06 ; $03ED: normal track data,  wait 2
 db $42 ; $03EE: normal track data
 db $03 ; $03EF: vol = $E (inverted), no pitch, no note, no instrument
 db $08 ; $03F0: normal track data,  wait 3
 db $42 ; $03F1: normal track data,  note: C0
 db $05 ; $03F2: vol = $D (inverted), no pitch, no note, no instrument
 db $00 ; $03F3: track end signature found
trackDef4TitleMusic:
 db $42 ; $03F4: normal track data
 db $80 ; $03F5: vol off, pitch, no note, no instrument
 dw $0000 ; $03F6: pitch
 db $02 ; $03F8: normal track data,  wait 0
 db $42 ; $03F9: normal track data,  note: C0
 db $07 ; $03FA: vol = $C (inverted), no pitch, no note, no instrument
 db $08 ; $03FB: normal track data,  wait 3
 db $42 ; $03FC: normal track data
 db $09 ; $03FD: vol = $B (inverted), no pitch, no note, no instrument
 db $08 ; $03FE: normal track data,  wait 3
 db $42 ; $03FF: normal track data
 db $0B ; $0400: vol = $A (inverted), no pitch, no note, no instrument
 db $00 ; $0401: track end signature found
trackDef7TitleMusic:
 db $42 ; $0402: normal track data
 db $80 ; $0403: vol off, pitch, no note, no instrument
 dw $0000 ; $0404: pitch
 db $42 ; $0406: normal track data,  note: C0
 db $0D ; $0407: vol = $9 (inverted), no pitch, no note, no instrument
 db $08 ; $0408: normal track data,  wait 3
 db $42 ; $0409: normal track data,  note: C0
 db $0F ; $040A: vol = $8 (inverted), no pitch, no note, no instrument
 db $08 ; $040B: normal track data,  wait 3
 db $42 ; $040C: normal track data
 db $11 ; $040D: vol = $7 (inverted), no pitch, no note, no instrument
 db $00 ; $040E: track end signature found
trackDef9TitleMusic:
 db $42 ; $040F: normal track data
 db $93 ; $0410: vol = $6 (inverted), no pitch, no note, no instrument
 dw $0000 ; $0411: pitch
 db $04 ; $0413: normal track data,  wait 1
 db $42 ; $0414: normal track data,  note: C0
 db $15 ; $0415: vol = $5 (inverted), no pitch, no note, no instrument
 db $04 ; $0416: normal track data,  wait 1
 db $42 ; $0417: normal track data,  note: C0
 db $17 ; $0418: vol = $4 (inverted), no pitch, no note, no instrument
 db $04 ; $0419: normal track data,  wait 1
 db $42 ; $041A: normal track data
 db $19 ; $041B: vol = $3 (inverted), no pitch, no note, no instrument
 db $04 ; $041C: normal track data,  wait 1
 db $42 ; $041D: normal track data
 db $1B ; $041E: vol = $2 (inverted), no pitch, no note, no instrument
 db $02 ; $041F: normal track data,  wait 0
 db $42 ; $0420: normal track data,  note: C0
 db $1D ; $0421: vol = $1 (inverted), no pitch, no note, no instrument
 db $42 ; $0422: normal track data,  note: C0
 db $1F ; $0423: vol = $0 (inverted), no pitch, no note, no instrument
trackDef5TitleMusic:
 db $A8 ; $0424: normal track data
 db $E1 ; $0425: vol = $F (inverted), no pitch, no note, no instrument
 dw $0000 ; $0426: pitch
 db $02 ; $0428: instrument
 db $C0 ; $0429: normal track data
 db $49 ; $042A: vol = $B (inverted), no pitch, no note, no instrument
 db $B8 ; $042B: normal track data
 db $41 ; $042C: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $042D: normal track data
 db $49 ; $042E: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $042F: normal track data
 db $41 ; $0430: vol = $F (inverted), no pitch, no note, no instrument
 db $B8 ; $0431: normal track data
 db $49 ; $0432: vol = $B (inverted), no pitch, no note, no instrument
 db $B6 ; $0433: normal track data
 db $41 ; $0434: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $0435: normal track data
 db $49 ; $0436: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $0437: normal track data
 db $41 ; $0438: vol = $F (inverted), no pitch, no note, no instrument
 db $B6 ; $0439: normal track data
 db $49 ; $043A: vol = $B (inverted), no pitch, no note, no instrument
 db $BC ; $043B: normal track data
 db $41 ; $043C: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $043D: normal track data
 db $49 ; $043E: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $043F: normal track data
 db $41 ; $0440: vol = $F (inverted), no pitch, no note, no instrument
 db $BC ; $0441: normal track data
 db $49 ; $0442: vol = $B (inverted), no pitch, no note, no instrument
 db $C0 ; $0443: normal track data
 db $41 ; $0444: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $0445: normal track data
 db $49 ; $0446: vol = $B (inverted), no pitch, no note, no instrument
trackDef6TitleMusic:
 db $A8 ; $0447: normal track data
 db $E9 ; $0448: vol = $B (inverted), no pitch, no note, no instrument
 dw $0000 ; $0449: pitch
 db $03 ; $044B: instrument
 db $A8 ; $044C: normal track data
 db $41 ; $044D: vol = $F (inverted), no pitch, no note, no instrument
 db $C0 ; $044E: normal track data
 db $49 ; $044F: vol = $B (inverted), no pitch, no note, no instrument
 db $B8 ; $0450: normal track data
 db $41 ; $0451: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $0452: normal track data
 db $49 ; $0453: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $0454: normal track data
 db $41 ; $0455: vol = $F (inverted), no pitch, no note, no instrument
 db $B8 ; $0456: normal track data
 db $49 ; $0457: vol = $B (inverted), no pitch, no note, no instrument
 db $B6 ; $0458: normal track data
 db $41 ; $0459: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $045A: normal track data
 db $49 ; $045B: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $045C: normal track data
 db $41 ; $045D: vol = $F (inverted), no pitch, no note, no instrument
 db $B6 ; $045E: normal track data
 db $49 ; $045F: vol = $B (inverted), no pitch, no note, no instrument
 db $BC ; $0460: normal track data
 db $41 ; $0461: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $0462: normal track data
 db $49 ; $0463: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $0464: normal track data
 db $41 ; $0465: vol = $F (inverted), no pitch, no note, no instrument
 db $BC ; $0466: normal track data
 db $49 ; $0467: vol = $B (inverted), no pitch, no note, no instrument
 db $C0 ; $0468: normal track data
 db $41 ; $0469: vol = $F (inverted), no pitch, no note, no instrument
trackDef16TitleMusic:
 db $6A ; $046A: normal track data
 db $E1 ; $046B: vol = $F (inverted), no pitch, no note, no instrument
 dw $0000 ; $046C: pitch
 db $04 ; $046E: instrument
 db $02 ; $046F: normal track data,  wait 0
 db $2B ; $0470: full optimization, no escape: G#1
 db $02 ; $0471: normal track data,  wait 0
 db $2B ; $0472: full optimization, no escape: G#1
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
 db $00 ; $047D: track end signature found
trackDef41TitleMusic:
 db $5E ; $047E: normal track data
 db $E0 ; $047F: vol off, pitch, note, instrument
 dw $0000 ; $0480: pitch
 db $05 ; $0482: instrument
 db $8A ; $0483: normal track data
 db $60 ; $0484: vol off, no pitch, note, instrument
 db $06 ; $0485: instrument
 db $5C ; $0486: normal track data
 db $60 ; $0487: vol off, no pitch, note, instrument
 db $07 ; $0488: instrument
 db $21 ; $0489: full optimization, no escape: D#1
 db $8A ; $048A: normal track data
 db $60 ; $048B: vol off, no pitch, note, instrument
 db $08 ; $048C: instrument
 db $8A ; $048D: normal track data
 db $60 ; $048E: vol off, no pitch, note, instrument
 db $06 ; $048F: instrument
 db $8A ; $0490: normal track data
 db $60 ; $0491: vol off, no pitch, note, instrument
 db $08 ; $0492: instrument
 db $5E ; $0493: normal track data
 db $60 ; $0494: vol off, no pitch, note, instrument
 db $05 ; $0495: instrument
 db $8A ; $0496: normal track data
 db $60 ; $0497: vol off, no pitch, note, instrument
 db $06 ; $0498: instrument
 db $8A ; $0499: normal track data
 db $60 ; $049A: vol off, no pitch, note, instrument
 db $08 ; $049B: instrument
 db $5E ; $049C: normal track data
 db $60 ; $049D: vol off, no pitch, note, instrument
 db $05 ; $049E: instrument
 db $8A ; $049F: normal track data
 db $60 ; $04A0: vol off, no pitch, note, instrument
 db $06 ; $04A1: instrument
 db $8A ; $04A2: normal track data
 db $60 ; $04A3: vol off, no pitch, note, instrument
 db $08 ; $04A4: instrument
 db $8A ; $04A5: normal track data
 db $60 ; $04A6: vol off, no pitch, note, instrument
 db $06 ; $04A7: instrument
 db $5C ; $04A8: normal track data
 db $60 ; $04A9: vol off, no pitch, note, instrument
 db $07 ; $04AA: instrument
 db $21 ; $04AB: full optimization, no escape: D#1
trackDef44TitleMusic:
 db $5E ; $04AC: normal track data
 db $E0 ; $04AD: vol off, pitch, note, instrument
 dw $0000 ; $04AE: pitch
 db $05 ; $04B0: instrument
 db $8A ; $04B1: normal track data
 db $60 ; $04B2: vol off, no pitch, note, instrument
 db $06 ; $04B3: instrument
 db $5C ; $04B4: normal track data
 db $60 ; $04B5: vol off, no pitch, note, instrument
 db $07 ; $04B6: instrument
 db $21 ; $04B7: full optimization, no escape: D#1
 db $8A ; $04B8: normal track data
 db $60 ; $04B9: vol off, no pitch, note, instrument
 db $08 ; $04BA: instrument
 db $8A ; $04BB: normal track data
 db $60 ; $04BC: vol off, no pitch, note, instrument
 db $06 ; $04BD: instrument
 db $8A ; $04BE: normal track data
 db $60 ; $04BF: vol off, no pitch, note, instrument
 db $08 ; $04C0: instrument
 db $5E ; $04C1: normal track data
 db $60 ; $04C2: vol off, no pitch, note, instrument
 db $05 ; $04C3: instrument
 db $8A ; $04C4: normal track data
 db $60 ; $04C5: vol off, no pitch, note, instrument
 db $06 ; $04C6: instrument
 db $8A ; $04C7: normal track data
 db $60 ; $04C8: vol off, no pitch, note, instrument
 db $08 ; $04C9: instrument
 db $5E ; $04CA: normal track data
 db $60 ; $04CB: vol off, no pitch, note, instrument
 db $05 ; $04CC: instrument
 db $8A ; $04CD: normal track data
 db $60 ; $04CE: vol off, no pitch, note, instrument
 db $06 ; $04CF: instrument
 db $B6 ; $04D0: normal track data
 db $60 ; $04D1: vol off, no pitch, note, instrument
 db $09 ; $04D2: instrument
 db $42 ; $04D3: normal track data
 db $00 ; $04D4: vol off, no pitch, no note, no instrument
 db $56 ; $04D5: normal track data
 db $60 ; $04D6: vol off, no pitch, note, instrument
 db $07 ; $04D7: instrument
 db $8A ; $04D8: normal track data
 db $60 ; $04D9: vol off, no pitch, note, instrument
 db $08 ; $04DA: instrument
trackDef43TitleMusic:
 db $B6 ; $04DB: normal track data
 db $E0 ; $04DC: vol off, pitch, note, instrument
 dw $0000 ; $04DD: pitch
 db $0A ; $04DF: instrument
 db $42 ; $04E0: normal track data
 db $00 ; $04E1: vol off, no pitch, no note, no instrument
 db $8A ; $04E2: normal track data
 db $60 ; $04E3: vol off, no pitch, note, instrument
 db $08 ; $04E4: instrument
 db $8A ; $04E5: normal track data
 db $60 ; $04E6: vol off, no pitch, note, instrument
 db $06 ; $04E7: instrument
 db $5C ; $04E8: normal track data
 db $60 ; $04E9: vol off, no pitch, note, instrument
 db $0B ; $04EA: instrument
 db $42 ; $04EB: normal track data
 db $00 ; $04EC: vol off, no pitch, no note, no instrument
 db $60 ; $04ED: normal track data
 db $60 ; $04EE: vol off, no pitch, note, instrument
 db $07 ; $04EF: instrument
 db $27 ; $04F0: full optimization, no escape: F#1
 db $B6 ; $04F1: normal track data
 db $60 ; $04F2: vol off, no pitch, note, instrument
 db $0A ; $04F3: instrument
 db $02 ; $04F4: normal track data,  wait 0
 db $5C ; $04F5: normal track data
 db $60 ; $04F6: vol off, no pitch, note, instrument
 db $07 ; $04F7: instrument
 db $21 ; $04F8: full optimization, no escape: D#1
 db $5C ; $04F9: normal track data
 db $60 ; $04FA: vol off, no pitch, note, instrument
 db $0B ; $04FB: instrument
 db $02 ; $04FC: normal track data,  wait 0
 db $B6 ; $04FD: normal track data
 db $60 ; $04FE: vol off, no pitch, note, instrument
 db $0C ; $04FF: instrument
 db $42 ; $0500: normal track data
 db $00 ; $0501: vol off, no pitch, no note, no instrument
trackDef46TitleMusic:
 db $42 ; $0502: normal track data
 db $80 ; $0503: vol off, pitch, no note, no instrument
 dw $0000 ; $0504: pitch
 db $02 ; $0506: normal track data,  wait 0
 db $B6 ; $0507: normal track data
 db $60 ; $0508: vol off, no pitch, note, instrument
 db $0A ; $0509: instrument
 db $42 ; $050A: normal track data
 db $00 ; $050B: vol off, no pitch, no note, no instrument
 db $5C ; $050C: normal track data
 db $60 ; $050D: vol off, no pitch, note, instrument
 db $0B ; $050E: instrument
 db $02 ; $050F: normal track data,  wait 0
 db $60 ; $0510: normal track data
 db $60 ; $0511: vol off, no pitch, note, instrument
 db $07 ; $0512: instrument
 db $27 ; $0513: full optimization, no escape: F#1
 db $B6 ; $0514: normal track data
 db $60 ; $0515: vol off, no pitch, note, instrument
 db $0A ; $0516: instrument
 db $42 ; $0517: normal track data
 db $00 ; $0518: vol off, no pitch, no note, no instrument
 db $5C ; $0519: normal track data
 db $60 ; $051A: vol off, no pitch, note, instrument
 db $07 ; $051B: instrument
 db $21 ; $051C: full optimization, no escape: D#1
 db $5C ; $051D: normal track data
 db $60 ; $051E: vol off, no pitch, note, instrument
 db $0B ; $051F: instrument
 db $8A ; $0520: normal track data
 db $60 ; $0521: vol off, no pitch, note, instrument
 db $08 ; $0522: instrument
 db $8A ; $0523: normal track data
 db $60 ; $0524: vol off, no pitch, note, instrument
 db $06 ; $0525: instrument
 db $5C ; $0526: normal track data
 db $60 ; $0527: vol off, no pitch, note, instrument
 db $07 ; $0528: instrument
trackDef53TitleMusic:
 db $5E ; $0529: normal track data
 db $E0 ; $052A: vol off, pitch, note, instrument
 dw $0000 ; $052B: pitch
 db $05 ; $052D: instrument
 db $8A ; $052E: normal track data
 db $60 ; $052F: vol off, no pitch, note, instrument
 db $06 ; $0530: instrument
 db $60 ; $0531: normal track data
 db $60 ; $0532: vol off, no pitch, note, instrument
 db $07 ; $0533: instrument
 db $8A ; $0534: normal track data
 db $60 ; $0535: vol off, no pitch, note, instrument
 db $06 ; $0536: instrument
 db $8A ; $0537: normal track data
 db $60 ; $0538: vol off, no pitch, note, instrument
 db $08 ; $0539: instrument
 db $8A ; $053A: normal track data
 db $60 ; $053B: vol off, no pitch, note, instrument
 db $06 ; $053C: instrument
 db $8A ; $053D: normal track data
 db $60 ; $053E: vol off, no pitch, note, instrument
 db $08 ; $053F: instrument
 db $5E ; $0540: normal track data
 db $60 ; $0541: vol off, no pitch, note, instrument
 db $05 ; $0542: instrument
 db $8A ; $0543: normal track data
 db $60 ; $0544: vol off, no pitch, note, instrument
 db $06 ; $0545: instrument
 db $8A ; $0546: normal track data
 db $60 ; $0547: vol off, no pitch, note, instrument
 db $08 ; $0548: instrument
 db $5E ; $0549: normal track data
 db $60 ; $054A: vol off, no pitch, note, instrument
 db $05 ; $054B: instrument
 db $8A ; $054C: normal track data
 db $60 ; $054D: vol off, no pitch, note, instrument
 db $06 ; $054E: instrument
 db $42 ; $054F: normal track data
 db $00 ; $0550: vol off, no pitch, no note, no instrument
 db $42 ; $0551: normal track data
 db $00 ; $0552: vol off, no pitch, no note, no instrument
 db $60 ; $0553: normal track data
 db $60 ; $0554: vol off, no pitch, note, instrument
 db $07 ; $0555: instrument
 db $8A ; $0556: normal track data
 db $60 ; $0557: vol off, no pitch, note, instrument
 db $08 ; $0558: instrument
trackDef55TitleMusic:
 db $42 ; $0559: normal track data
 db $80 ; $055A: vol off, pitch, no note, no instrument
 dw $0000 ; $055B: pitch
 db $02 ; $055D: normal track data,  wait 0
 db $C0 ; $055E: normal track data
 db $60 ; $055F: vol off, no pitch, note, instrument
 db $0D ; $0560: instrument
 db $42 ; $0561: normal track data
 db $00 ; $0562: vol off, no pitch, no note, no instrument
 db $5C ; $0563: normal track data
 db $60 ; $0564: vol off, no pitch, note, instrument
 db $0B ; $0565: instrument
 db $02 ; $0566: normal track data,  wait 0
 db $60 ; $0567: normal track data
 db $60 ; $0568: vol off, no pitch, note, instrument
 db $07 ; $0569: instrument
 db $42 ; $056A: normal track data
 db $00 ; $056B: vol off, no pitch, no note, no instrument
 db $C0 ; $056C: normal track data
 db $60 ; $056D: vol off, no pitch, note, instrument
 db $0E ; $056E: instrument
 db $42 ; $056F: normal track data
 db $00 ; $0570: vol off, no pitch, no note, no instrument
 db $60 ; $0571: normal track data
 db $60 ; $0572: vol off, no pitch, note, instrument
 db $07 ; $0573: instrument
 db $42 ; $0574: normal track data
 db $00 ; $0575: vol off, no pitch, no note, no instrument
 db $5C ; $0576: normal track data
 db $60 ; $0577: vol off, no pitch, note, instrument
 db $0B ; $0578: instrument
 db $8A ; $0579: normal track data
 db $60 ; $057A: vol off, no pitch, note, instrument
 db $08 ; $057B: instrument
 db $8A ; $057C: normal track data
 db $60 ; $057D: vol off, no pitch, note, instrument
 db $06 ; $057E: instrument
 db $42 ; $057F: normal track data
 db $00 ; $0580: vol off, no pitch, no note, no instrument
trackDef54TitleMusic:
 db $82 ; $0581: normal track data
 db $EB ; $0582: vol = $A (inverted), no pitch, no note, no instrument
 dw $0002 ; $0583: pitch
 db $0F ; $0585: instrument
 db $42 ; $0586: normal track data
 db $09 ; $0587: vol = $B (inverted), no pitch, no note, no instrument
 db $42 ; $0588: normal track data,  note: C0
 db $07 ; $0589: vol = $C (inverted), no pitch, no note, no instrument
 db $42 ; $058A: normal track data,  note: C0
 db $05 ; $058B: vol = $D (inverted), no pitch, no note, no instrument
 db $42 ; $058C: normal track data
 db $03 ; $058D: vol = $E (inverted), no pitch, no note, no instrument
 db $42 ; $058E: normal track data
 db $01 ; $058F: vol = $F (inverted), no pitch, no note, no instrument
 db $42 ; $0590: normal track data
 db $00 ; $0591: vol off, no pitch, no note, no instrument
 db $42 ; $0592: normal track data
 db $00 ; $0593: vol off, no pitch, no note, no instrument
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
trackDef56TitleMusic:
 db $42 ; $05A4: normal track data
 db $80 ; $05A5: vol off, pitch, no note, no instrument
 dw $0002 ; $05A6: pitch
 db $42 ; $05A8: normal track data
 db $00 ; $05A9: vol off, no pitch, no note, no instrument
 db $42 ; $05AA: normal track data
 db $00 ; $05AB: vol off, no pitch, no note, no instrument
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
trackDef58TitleMusic:
 db $42 ; $05C6: normal track data
 db $80 ; $05C7: vol off, pitch, no note, no instrument
 dw $0002 ; $05C8: pitch
 db $42 ; $05CA: normal track data
 db $00 ; $05CB: vol off, no pitch, no note, no instrument
 db $42 ; $05CC: normal track data
 db $03 ; $05CD: vol = $E (inverted), no pitch, no note, no instrument
 db $42 ; $05CE: normal track data
 db $00 ; $05CF: vol off, no pitch, no note, no instrument
 db $42 ; $05D0: normal track data
 db $00 ; $05D1: vol off, no pitch, no note, no instrument
 db $42 ; $05D2: normal track data
 db $00 ; $05D3: vol off, no pitch, no note, no instrument
 db $42 ; $05D4: normal track data,  note: C0
 db $05 ; $05D5: vol = $D (inverted), no pitch, no note, no instrument
 db $42 ; $05D6: normal track data
 db $00 ; $05D7: vol off, no pitch, no note, no instrument
 db $42 ; $05D8: normal track data
 db $00 ; $05D9: vol off, no pitch, no note, no instrument
 db $42 ; $05DA: normal track data
 db $00 ; $05DB: vol off, no pitch, no note, no instrument
 db $42 ; $05DC: normal track data,  note: C0
 db $07 ; $05DD: vol = $C (inverted), no pitch, no note, no instrument
 db $42 ; $05DE: normal track data
 db $00 ; $05DF: vol off, no pitch, no note, no instrument
 db $42 ; $05E0: normal track data
 db $00 ; $05E1: vol off, no pitch, no note, no instrument
 db $42 ; $05E2: normal track data
 db $00 ; $05E3: vol off, no pitch, no note, no instrument
 db $42 ; $05E4: normal track data
 db $09 ; $05E5: vol = $B (inverted), no pitch, no note, no instrument
 db $42 ; $05E6: normal track data
 db $00 ; $05E7: vol off, no pitch, no note, no instrument
trackDef59TitleMusic:
 db $5E ; $05E8: normal track data
 db $E0 ; $05E9: vol off, pitch, note, instrument
 dw $0000 ; $05EA: pitch
 db $05 ; $05EC: instrument
 db $8A ; $05ED: normal track data
 db $60 ; $05EE: vol off, no pitch, note, instrument
 db $06 ; $05EF: instrument
 db $58 ; $05F0: normal track data
 db $60 ; $05F1: vol off, no pitch, note, instrument
 db $07 ; $05F2: instrument
 db $8A ; $05F3: normal track data
 db $60 ; $05F4: vol off, no pitch, note, instrument
 db $06 ; $05F5: instrument
 db $8A ; $05F6: normal track data
 db $60 ; $05F7: vol off, no pitch, note, instrument
 db $08 ; $05F8: instrument
 db $8A ; $05F9: normal track data
 db $60 ; $05FA: vol off, no pitch, note, instrument
 db $06 ; $05FB: instrument
 db $8A ; $05FC: normal track data
 db $60 ; $05FD: vol off, no pitch, note, instrument
 db $08 ; $05FE: instrument
 db $5E ; $05FF: normal track data
 db $60 ; $0600: vol off, no pitch, note, instrument
 db $05 ; $0601: instrument
 db $8A ; $0602: normal track data
 db $60 ; $0603: vol off, no pitch, note, instrument
 db $06 ; $0604: instrument
 db $8A ; $0605: normal track data
 db $60 ; $0606: vol off, no pitch, note, instrument
 db $08 ; $0607: instrument
 db $5E ; $0608: normal track data
 db $60 ; $0609: vol off, no pitch, note, instrument
 db $05 ; $060A: instrument
 db $8A ; $060B: normal track data
 db $60 ; $060C: vol off, no pitch, note, instrument
 db $06 ; $060D: instrument
 db $42 ; $060E: normal track data
 db $00 ; $060F: vol off, no pitch, no note, no instrument
 db $42 ; $0610: normal track data
 db $00 ; $0611: vol off, no pitch, no note, no instrument
 db $58 ; $0612: normal track data
 db $60 ; $0613: vol off, no pitch, note, instrument
 db $07 ; $0614: instrument
 db $8A ; $0615: normal track data
 db $60 ; $0616: vol off, no pitch, note, instrument
 db $08 ; $0617: instrument
trackDef61TitleMusic:
 db $42 ; $0618: normal track data
 db $80 ; $0619: vol off, pitch, no note, no instrument
 dw $0000 ; $061A: pitch
 db $02 ; $061C: normal track data,  wait 0
 db $C0 ; $061D: normal track data
 db $60 ; $061E: vol off, no pitch, note, instrument
 db $0D ; $061F: instrument
 db $42 ; $0620: normal track data
 db $00 ; $0621: vol off, no pitch, no note, no instrument
 db $5C ; $0622: normal track data
 db $60 ; $0623: vol off, no pitch, note, instrument
 db $0B ; $0624: instrument
 db $02 ; $0625: normal track data,  wait 0
 db $58 ; $0626: normal track data
 db $60 ; $0627: vol off, no pitch, note, instrument
 db $07 ; $0628: instrument
 db $42 ; $0629: normal track data
 db $00 ; $062A: vol off, no pitch, no note, no instrument
 db $C0 ; $062B: normal track data
 db $60 ; $062C: vol off, no pitch, note, instrument
 db $0E ; $062D: instrument
 db $42 ; $062E: normal track data
 db $00 ; $062F: vol off, no pitch, no note, no instrument
 db $58 ; $0630: normal track data
 db $60 ; $0631: vol off, no pitch, note, instrument
 db $07 ; $0632: instrument
 db $42 ; $0633: normal track data
 db $00 ; $0634: vol off, no pitch, no note, no instrument
 db $5C ; $0635: normal track data
 db $60 ; $0636: vol off, no pitch, note, instrument
 db $0B ; $0637: instrument
 db $8A ; $0638: normal track data
 db $60 ; $0639: vol off, no pitch, note, instrument
 db $08 ; $063A: instrument
 db $8A ; $063B: normal track data
 db $60 ; $063C: vol off, no pitch, note, instrument
 db $06 ; $063D: instrument
 db $42 ; $063E: normal track data
 db $00 ; $063F: vol off, no pitch, no note, no instrument
trackDef62TitleMusic:
 db $7C ; $0640: normal track data,  note: F2
 db $EF ; $0641: vol = $8 (inverted), no pitch, no note, no instrument
 dw $0002 ; $0642: pitch
 db $10 ; $0644: instrument
 db $42 ; $0645: normal track data
 db $00 ; $0646: vol off, no pitch, no note, no instrument
 db $42 ; $0647: normal track data,  note: C0
 db $0D ; $0648: vol = $9 (inverted), no pitch, no note, no instrument
 db $42 ; $0649: normal track data
 db $00 ; $064A: vol off, no pitch, no note, no instrument
 db $42 ; $064B: normal track data
 db $0B ; $064C: vol = $A (inverted), no pitch, no note, no instrument
 db $42 ; $064D: normal track data
 db $00 ; $064E: vol off, no pitch, no note, no instrument
 db $42 ; $064F: normal track data
 db $09 ; $0650: vol = $B (inverted), no pitch, no note, no instrument
 db $42 ; $0651: normal track data
 db $00 ; $0652: vol off, no pitch, no note, no instrument
 db $42 ; $0653: normal track data,  note: C0
 db $07 ; $0654: vol = $C (inverted), no pitch, no note, no instrument
 db $42 ; $0655: normal track data
 db $00 ; $0656: vol off, no pitch, no note, no instrument
 db $42 ; $0657: normal track data,  note: C0
 db $05 ; $0658: vol = $D (inverted), no pitch, no note, no instrument
 db $42 ; $0659: normal track data
 db $00 ; $065A: vol off, no pitch, no note, no instrument
 db $42 ; $065B: normal track data
 db $03 ; $065C: vol = $E (inverted), no pitch, no note, no instrument
 db $42 ; $065D: normal track data
 db $00 ; $065E: vol off, no pitch, no note, no instrument
 db $42 ; $065F: normal track data
 db $01 ; $0660: vol = $F (inverted), no pitch, no note, no instrument
 db $42 ; $0661: normal track data
 db $00 ; $0662: vol off, no pitch, no note, no instrument
trackDef67TitleMusic:
 db $42 ; $0663: normal track data
 db $80 ; $0664: vol off, pitch, no note, no instrument
 dw $0000 ; $0665: pitch
 db $02 ; $0667: normal track data,  wait 0
 db $C0 ; $0668: normal track data
 db $60 ; $0669: vol off, no pitch, note, instrument
 db $0D ; $066A: instrument
 db $42 ; $066B: normal track data
 db $00 ; $066C: vol off, no pitch, no note, no instrument
 db $5C ; $066D: normal track data
 db $60 ; $066E: vol off, no pitch, note, instrument
 db $0B ; $066F: instrument
 db $02 ; $0670: normal track data,  wait 0
 db $58 ; $0671: normal track data
 db $60 ; $0672: vol off, no pitch, note, instrument
 db $07 ; $0673: instrument
 db $42 ; $0674: normal track data
 db $00 ; $0675: vol off, no pitch, no note, no instrument
 db $C0 ; $0676: normal track data
 db $60 ; $0677: vol off, no pitch, note, instrument
 db $0E ; $0678: instrument
 db $42 ; $0679: normal track data
 db $00 ; $067A: vol off, no pitch, no note, no instrument
 db $58 ; $067B: normal track data
 db $60 ; $067C: vol off, no pitch, note, instrument
 db $07 ; $067D: instrument
 db $42 ; $067E: normal track data
 db $00 ; $067F: vol off, no pitch, no note, no instrument
 db $5C ; $0680: normal track data
 db $60 ; $0681: vol off, no pitch, note, instrument
 db $0B ; $0682: instrument
 db $1D ; $0683: full optimization, no escape: C#1
 db $1D ; $0684: full optimization, no escape: C#1
 db $1D ; $0685: full optimization, no escape: C#1
trackDef68TitleMusic:
 db $42 ; $0686: normal track data
 db $80 ; $0687: vol off, pitch, no note, no instrument
 dw $0000 ; $0688: pitch
 db $42 ; $068A: normal track data
 db $00 ; $068B: vol off, no pitch, no note, no instrument
 db $C0 ; $068C: normal track data
 db $61 ; $068D: vol = $F (inverted), no pitch, no note, no instrument
 db $09 ; $068E: instrument
 db $06 ; $068F: normal track data,  wait 2
 db $42 ; $0690: normal track data
 db $00 ; $0691: vol off, no pitch, no note, no instrument
 db $02 ; $0692: normal track data,  wait 0
 db $81 ; $0693: full optimization, no escape: D#5
 db $02 ; $0694: normal track data,  wait 0
 db $42 ; $0695: normal track data
 db $00 ; $0696: vol off, no pitch, no note, no instrument
 db $02 ; $0697: normal track data,  wait 0
 db $42 ; $0698: normal track data
 db $00 ; $0699: vol off, no pitch, no note, no instrument
 db $02 ; $069A: normal track data,  wait 0
 db $C0 ; $069B: normal track data
 db $60 ; $069C: vol off, no pitch, note, instrument
 db $11 ; $069D: instrument
 db $00 ; $069E: track end signature found
trackDef69TitleMusic:
 db $42 ; $069F: normal track data
 db $80 ; $06A0: vol off, pitch, no note, no instrument
 dw $0000 ; $06A1: pitch
 db $02 ; $06A3: normal track data,  wait 0
 db $C0 ; $06A4: normal track data
 db $60 ; $06A5: vol off, no pitch, note, instrument
 db $09 ; $06A6: instrument
 db $02 ; $06A7: normal track data,  wait 0
 db $42 ; $06A8: normal track data
 db $00 ; $06A9: vol off, no pitch, no note, no instrument
 db $02 ; $06AA: normal track data,  wait 0
 db $42 ; $06AB: normal track data
 db $00 ; $06AC: vol off, no pitch, no note, no instrument
 db $02 ; $06AD: normal track data,  wait 0
 db $C0 ; $06AE: normal track data
 db $60 ; $06AF: vol off, no pitch, note, instrument
 db $12 ; $06B0: instrument
 db $02 ; $06B1: normal track data,  wait 0
 db $42 ; $06B2: normal track data
 db $00 ; $06B3: vol off, no pitch, no note, no instrument
 db $02 ; $06B4: normal track data,  wait 0
 db $C0 ; $06B5: normal track data
 db $60 ; $06B6: vol off, no pitch, note, instrument
 db $09 ; $06B7: instrument
 db $00 ; $06B8: track end signature found
trackDef85TitleMusic:
 db $C0 ; $06B9: normal track data
 db $E0 ; $06BA: vol off, pitch, note, instrument
 dw $0000 ; $06BB: pitch
 db $09 ; $06BD: instrument
 db $02 ; $06BE: normal track data,  wait 0
 db $42 ; $06BF: normal track data
 db $00 ; $06C0: vol off, no pitch, no note, no instrument
 db $08 ; $06C1: normal track data,  wait 3
 db $C0 ; $06C2: normal track data,  note: D#5
 db $4D ; $06C3: vol = $9 (inverted), no pitch, no note, no instrument
 db $00 ; $06C4: track end signature found
trackDef84TitleMusic:
 db $5E ; $06C5: normal track data
 db $E0 ; $06C6: vol off, pitch, note, instrument
 dw $0000 ; $06C7: pitch
 db $05 ; $06C9: instrument
 db $8A ; $06CA: normal track data
 db $60 ; $06CB: vol off, no pitch, note, instrument
 db $06 ; $06CC: instrument
 db $42 ; $06CD: normal track data
 db $00 ; $06CE: vol off, no pitch, no note, no instrument
 db $00 ; $06CF: track end signature found
trackDef86TitleMusic:
 db $42 ; $06D0: normal track data
 db $80 ; $06D1: vol off, pitch, no note, no instrument
 dw $0000 ; $06D2: pitch
 db $00 ; $06D4: track end signature found
trackDef60TitleMusic:
 db $42 ; $06D5: normal track data
 db $80 ; $06D6: vol off, pitch, no note, no instrument
 dw $0002 ; $06D7: pitch
 db $42 ; $06D9: normal track data
 db $0B ; $06DA: vol = $A (inverted), no pitch, no note, no instrument
 db $42 ; $06DB: normal track data
 db $00 ; $06DC: vol off, no pitch, no note, no instrument
 db $42 ; $06DD: normal track data
 db $00 ; $06DE: vol off, no pitch, no note, no instrument
 db $42 ; $06DF: normal track data,  note: C0
 db $0D ; $06E0: vol = $9 (inverted), no pitch, no note, no instrument
 db $42 ; $06E1: normal track data
 db $00 ; $06E2: vol off, no pitch, no note, no instrument
 db $42 ; $06E3: normal track data
 db $00 ; $06E4: vol off, no pitch, no note, no instrument
 db $42 ; $06E5: normal track data,  note: C0
 db $0F ; $06E6: vol = $8 (inverted), no pitch, no note, no instrument
 db $42 ; $06E7: normal track data
 db $00 ; $06E8: vol off, no pitch, no note, no instrument
 db $42 ; $06E9: normal track data
 db $11 ; $06EA: vol = $7 (inverted), no pitch, no note, no instrument
 db $42 ; $06EB: normal track data
 db $00 ; $06EC: vol off, no pitch, no note, no instrument
 db $42 ; $06ED: normal track data
 db $13 ; $06EE: vol = $6 (inverted), no pitch, no note, no instrument
 db $42 ; $06EF: normal track data
 db $00 ; $06F0: vol off, no pitch, no note, no instrument
 db $42 ; $06F1: normal track data,  note: C0
 db $15 ; $06F2: vol = $5 (inverted), no pitch, no note, no instrument
 db $42 ; $06F3: normal track data
 db $19 ; $06F4: vol = $3 (inverted), no pitch, no note, no instrument
 db $42 ; $06F5: normal track data,  note: C0
 db $1F ; $06F6: vol = $0 (inverted), no pitch, no note, no instrument