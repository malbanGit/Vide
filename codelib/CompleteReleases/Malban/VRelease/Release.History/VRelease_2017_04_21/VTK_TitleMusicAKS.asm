
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
 dw $00CF ; $000A: size of instrument table (without this word pointer)
 dw instrument0_title ; $000C: [$0026] pointer to instrument 0
 dw instrument1_title ; $000E: [$002F] pointer to instrument 1
 dw instrument2_title ; $0010: [$0037] pointer to instrument 2
 dw instrument3_title ; $0012: [$0046] pointer to instrument 3
 dw instrument4_title ; $0014: [$0055] pointer to instrument 4
 dw instrument5_title ; $0016: [$0063] pointer to instrument 5
 dw instrument6_title ; $0018: [$0071] pointer to instrument 6
 dw instrument7_title ; $001A: [$007A] pointer to instrument 7
 dw instrument8_title ; $001C: [$0087] pointer to instrument 8
 dw instrument9_title ; $001E: [$0090] pointer to instrument 9
 dw instrument10_title ; $0020: [$00A2] pointer to instrument 10
 dw instrument11_title ; $0022: [$00B4] pointer to instrument 11
 dw instrument12_title ; $0024: [$00C9] pointer to instrument 12
instrument0_title:
 db $00 ; $0026: speed
 db $00 ; $0027: retrig
instrument0loop_title:
 db $00 ; $0028: dataColumn_0 (non hard), vol=$0
 db $00 ; $0029: dataColumn_0 (non hard), vol=$0
 db $00 ; $002A: dataColumn_0 (non hard), vol=$0
 db $00 ; $002B: dataColumn_0 (non hard), vol=$0
 db $0D ; $002C: dataColumn_0 (hard)
 dw instrument0loop_title ; $002D: [$0028] loop
instrument1_title:
 db $03 ; $002F: speed
 db $00 ; $0030: retrig
instrument1loop_title:
 db $3C ; $0031: dataColumn_0 (non hard), vol=$F
 db $7C ; $0032: dataColumn_0 (non hard), vol=$F
 db $0C ; $0033: arpegio
 db $0D ; $0034: dataColumn_0 (hard)
 dw instrument1loop_title ; $0035: [$0031] loop
instrument2_title:
 db $01 ; $0037: speed
 db $00 ; $0038: retrig
 db $34 ; $0039: dataColumn_0 (non hard), vol=$D
 db $34 ; $003A: dataColumn_0 (non hard), vol=$D
 db $34 ; $003B: dataColumn_0 (non hard), vol=$D
 db $2C ; $003C: dataColumn_0 (non hard), vol=$B
 db $24 ; $003D: dataColumn_0 (non hard), vol=$9
 db $20 ; $003E: dataColumn_0 (non hard), vol=$8
instrument2loop_title:
 db $1C ; $003F: dataColumn_0 (non hard), vol=$7
 db $1C ; $0040: dataColumn_0 (non hard), vol=$7
 db $1C ; $0041: dataColumn_0 (non hard), vol=$7
 db $1C ; $0042: dataColumn_0 (non hard), vol=$7
 db $0D ; $0043: dataColumn_0 (hard)
 dw instrument2loop_title ; $0044: [$003F] loop
instrument3_title:
 db $01 ; $0046: speed
 db $00 ; $0047: retrig
 db $24 ; $0048: dataColumn_0 (non hard), vol=$9
 db $20 ; $0049: dataColumn_0 (non hard), vol=$8
 db $20 ; $004A: dataColumn_0 (non hard), vol=$8
 db $1C ; $004B: dataColumn_0 (non hard), vol=$7
 db $18 ; $004C: dataColumn_0 (non hard), vol=$6
 db $14 ; $004D: dataColumn_0 (non hard), vol=$5
instrument3loop_title:
 db $10 ; $004E: dataColumn_0 (non hard), vol=$4
 db $10 ; $004F: dataColumn_0 (non hard), vol=$4
 db $10 ; $0050: dataColumn_0 (non hard), vol=$4
 db $10 ; $0051: dataColumn_0 (non hard), vol=$4
 db $0D ; $0052: dataColumn_0 (hard)
 dw instrument3loop_title ; $0053: [$004E] loop
instrument4_title:
 db $03 ; $0055: speed
 db $00 ; $0056: retrig
 db $78 ; $0057: dataColumn_0 (non hard), vol=$E
 db $0C ; $0058: arpegio
 db $30 ; $0059: dataColumn_0 (non hard), vol=$C
 db $28 ; $005A: dataColumn_0 (non hard), vol=$A
 db $24 ; $005B: dataColumn_0 (non hard), vol=$9
 db $24 ; $005C: dataColumn_0 (non hard), vol=$9
 db $20 ; $005D: dataColumn_0 (non hard), vol=$8
 db $1C ; $005E: dataColumn_0 (non hard), vol=$7
 db $18 ; $005F: dataColumn_0 (non hard), vol=$6
 db $0D ; $0060: dataColumn_0 (hard)
 dw instrument0loop_title ; $0061: [$0028] loop
instrument5_title:
 db $01 ; $0063: speed
 db $00 ; $0064: retrig
 db $76 ; $0065: dataColumn_0 (non hard), vol=$D
 db $2C ; $0066: dataColumn_1, noise=$0C
 db $17 ; $0067: arpegio
 db $74 ; $0068: dataColumn_0 (non hard), vol=$D
 db $15 ; $0069: arpegio
 db $74 ; $006A: dataColumn_0 (non hard), vol=$D
 db $10 ; $006B: arpegio
 db $34 ; $006C: dataColumn_0 (non hard), vol=$D
 db $34 ; $006D: dataColumn_0 (non hard), vol=$D
 db $0D ; $006E: dataColumn_0 (hard)
 dw instrument0loop_title ; $006F: [$0028] loop
instrument6_title:
 db $01 ; $0071: speed
 db $00 ; $0072: retrig
 db $2A ; $0073: dataColumn_0 (non hard), vol=$A
 db $01 ; $0074: dataColumn_1, noise=$01
 db $2E ; $0075: dataColumn_0 (non hard), vol=$B
 db $01 ; $0076: dataColumn_1, noise=$01
 db $0D ; $0077: dataColumn_0 (hard)
 dw instrument0loop_title ; $0078: [$0028] loop
instrument7_title:
 db $03 ; $007A: speed
 db $00 ; $007B: retrig
 db $7C ; $007C: dataColumn_0 (non hard), vol=$F
 db $18 ; $007D: arpegio
 db $70 ; $007E: dataColumn_0 (non hard), vol=$C
 db $0C ; $007F: arpegio
 db $6C ; $0080: dataColumn_0 (non hard), vol=$B
 db $0C ; $0081: arpegio
 db $64 ; $0082: dataColumn_0 (non hard), vol=$9
 db $0C ; $0083: arpegio
 db $0D ; $0084: dataColumn_0 (hard)
 dw instrument0loop_title ; $0085: [$0028] loop
instrument8_title:
 db $01 ; $0087: speed
 db $00 ; $0088: retrig
 db $2A ; $0089: dataColumn_0 (non hard), vol=$A
 db $03 ; $008A: dataColumn_1, noise=$03
 db $26 ; $008B: dataColumn_0 (non hard), vol=$9
 db $03 ; $008C: dataColumn_1, noise=$03
 db $0D ; $008D: dataColumn_0 (hard)
 dw instrument0loop_title ; $008E: [$0028] loop
instrument9_title:
 db $03 ; $0090: speed
 db $00 ; $0091: retrig
 db $30 ; $0092: dataColumn_0 (non hard), vol=$C
 db $70 ; $0093: dataColumn_0 (non hard), vol=$C
 db $03 ; $0094: arpegio
 db $6C ; $0095: dataColumn_0 (non hard), vol=$B
 db $07 ; $0096: arpegio
 db $20 ; $0097: dataColumn_0 (non hard), vol=$8
 db $5C ; $0098: dataColumn_0 (non hard), vol=$7
 db $03 ; $0099: arpegio
 db $54 ; $009A: dataColumn_0 (non hard), vol=$5
 db $07 ; $009B: arpegio
 db $10 ; $009C: dataColumn_0 (non hard), vol=$4
 db $4C ; $009D: dataColumn_0 (non hard), vol=$3
 db $03 ; $009E: arpegio
 db $0D ; $009F: dataColumn_0 (hard)
 dw instrument0loop_title ; $00A0: [$0028] loop
instrument10_title:
 db $03 ; $00A2: speed
 db $00 ; $00A3: retrig
 db $30 ; $00A4: dataColumn_0 (non hard), vol=$C
 db $70 ; $00A5: dataColumn_0 (non hard), vol=$C
 db $05 ; $00A6: arpegio
 db $6C ; $00A7: dataColumn_0 (non hard), vol=$B
 db $08 ; $00A8: arpegio
 db $20 ; $00A9: dataColumn_0 (non hard), vol=$8
 db $5C ; $00AA: dataColumn_0 (non hard), vol=$7
 db $05 ; $00AB: arpegio
 db $54 ; $00AC: dataColumn_0 (non hard), vol=$5
 db $08 ; $00AD: arpegio
 db $10 ; $00AE: dataColumn_0 (non hard), vol=$4
 db $4C ; $00AF: dataColumn_0 (non hard), vol=$3
 db $05 ; $00B0: arpegio
 db $0D ; $00B1: dataColumn_0 (hard)
 dw instrument0loop_title ; $00B2: [$0028] loop
instrument11_title:
 db $01 ; $00B4: speed
 db $00 ; $00B5: retrig
 db $7E ; $00B6: dataColumn_0 (non hard), vol=$F
 db $22 ; $00B7: dataColumn_1, noise=$02
 db $18 ; $00B8: arpegio
 db $7C ; $00B9: dataColumn_0 (non hard), vol=$F
 db $1C ; $00BA: arpegio
 db $7C ; $00BB: dataColumn_0 (non hard), vol=$F
 db $1E ; $00BC: arpegio
 db $7A ; $00BD: dataColumn_0 (non hard), vol=$E
 db $23 ; $00BE: dataColumn_1, noise=$03
 db $30 ; $00BF: arpegio
 db $76 ; $00C0: dataColumn_0 (non hard), vol=$D
 db $22 ; $00C1: dataColumn_1, noise=$02
 db $18 ; $00C2: arpegio
 db $72 ; $00C3: dataColumn_0 (non hard), vol=$C
 db $23 ; $00C4: dataColumn_1, noise=$03
 db $18 ; $00C5: arpegio
 db $0D ; $00C6: dataColumn_0 (hard)
 dw instrument0loop_title ; $00C7: [$0028] loop
instrument12_title:
 db $03 ; $00C9: speed
 db $00 ; $00CA: retrig
 db $30 ; $00CB: dataColumn_0 (non hard), vol=$C
 db $70 ; $00CC: dataColumn_0 (non hard), vol=$C
 db $05 ; $00CD: arpegio
 db $6C ; $00CE: dataColumn_0 (non hard), vol=$B
 db $07 ; $00CF: arpegio
 db $20 ; $00D0: dataColumn_0 (non hard), vol=$8
 db $5C ; $00D1: dataColumn_0 (non hard), vol=$7
 db $05 ; $00D2: arpegio
 db $54 ; $00D3: dataColumn_0 (non hard), vol=$5
 db $07 ; $00D4: arpegio
 db $10 ; $00D5: dataColumn_0 (non hard), vol=$4
 db $4C ; $00D6: dataColumn_0 (non hard), vol=$3
 db $05 ; $00D7: arpegio
 db $0D ; $00D8: dataColumn_0 (hard)
 dw instrument0loop_title ; $00D9: [$0028] loop
; start of linker definition
linker_title:
 db $20 ; $00DB: first height
 db $00 ; $00DC: transposition1
 db $00 ; $00DD: transposition2
 db $00 ; $00DE: transposition3
 dw specialtrackDef0_title ; $00DF: [$0214] specialTrack
pattern0Definition_title:
 db $10 ; $00E1: pattern 0 state
 dw trackDef0_title ; $00E2: [$021B] pattern 0, track 1
 dw trackDef1_title ; $00E4: [$0216] pattern 0, track 2
 dw trackDef1_title ; $00E6: [$0216] pattern 0, track 3
 db $20 ; $00E8: new height
pattern1Definition_title:
 db $10 ; $00E9: pattern 1 state
 dw trackDef3_title ; $00EA: [$025E] pattern 1, track 1
 dw trackDef1_title ; $00EC: [$0216] pattern 1, track 2
 dw trackDef1_title ; $00EE: [$0216] pattern 1, track 3
 db $0D ; $00F0: new height
pattern2Definition_title:
 db $10 ; $00F1: pattern 2 state
 dw trackDef4_title ; $00F2: [$026B] pattern 2, track 1
 dw trackDef5_title ; $00F4: [$029B] pattern 2, track 2
 dw trackDef6_title ; $00F6: [$02BE] pattern 2, track 3
 db $10 ; $00F8: new height
pattern3Definition_title:
 db $00 ; $00F9: pattern 3 state
 dw trackDef7_title ; $00FA: [$0279] pattern 3, track 1
 dw trackDef5_title ; $00FC: [$029B] pattern 3, track 2
 dw trackDef6_title ; $00FE: [$02BE] pattern 3, track 3
pattern4Definition_title:
 db $00 ; $0100: pattern 4 state
 dw trackDef9_title ; $0101: [$0286] pattern 4, track 1
 dw trackDef5_title ; $0103: [$029B] pattern 4, track 2
 dw trackDef6_title ; $0105: [$02BE] pattern 4, track 3
pattern5Definition_title:
 db $00 ; $0107: pattern 5 state
 dw trackDef1_title ; $0108: [$0216] pattern 5, track 1
 dw trackDef5_title ; $010A: [$029B] pattern 5, track 2
 dw trackDef6_title ; $010C: [$02BE] pattern 5, track 3
pattern6Definition_title:
 db $00 ; $010E: pattern 6 state
 dw trackDef1_title ; $010F: [$0216] pattern 6, track 1
 dw trackDef5_title ; $0111: [$029B] pattern 6, track 2
 dw trackDef6_title ; $0113: [$02BE] pattern 6, track 3
pattern7Definition_title:
 db $00 ; $0115: pattern 7 state
 dw trackDef1_title ; $0116: [$0216] pattern 7, track 1
 dw trackDef5_title ; $0118: [$029B] pattern 7, track 2
 dw trackDef6_title ; $011A: [$02BE] pattern 7, track 3
pattern8Definition_title:
 db $00 ; $011C: pattern 8 state
 dw trackDef1_title ; $011D: [$0216] pattern 8, track 1
 dw trackDef5_title ; $011F: [$029B] pattern 8, track 2
 dw trackDef6_title ; $0121: [$02BE] pattern 8, track 3
pattern9Definition_title:
 db $00 ; $0123: pattern 9 state
 dw trackDef1_title ; $0124: [$0216] pattern 9, track 1
 dw trackDef5_title ; $0126: [$029B] pattern 9, track 2
 dw trackDef6_title ; $0128: [$02BE] pattern 9, track 3
pattern10Definition_title:
 db $02 ; $012A: pattern 10 state
 db $07 ; $012B: transposition 1
 dw trackDef16_title ; $012C: [$02E1] pattern 10, track 1
 dw trackDef5_title ; $012E: [$029B] pattern 10, track 2
 dw trackDef6_title ; $0130: [$02BE] pattern 10, track 3
pattern11Definition_title:
 db $00 ; $0132: pattern 11 state
 dw trackDef16_title ; $0133: [$02E1] pattern 11, track 1
 dw trackDef5_title ; $0135: [$029B] pattern 11, track 2
 dw trackDef6_title ; $0137: [$02BE] pattern 11, track 3
pattern12Definition_title:
 db $00 ; $0139: pattern 12 state
 dw trackDef16_title ; $013A: [$02E1] pattern 12, track 1
 dw trackDef5_title ; $013C: [$029B] pattern 12, track 2
 dw trackDef6_title ; $013E: [$02BE] pattern 12, track 3
pattern13Definition_title:
 db $00 ; $0140: pattern 13 state
 dw trackDef16_title ; $0141: [$02E1] pattern 13, track 1
 dw trackDef5_title ; $0143: [$029B] pattern 13, track 2
 dw trackDef6_title ; $0145: [$02BE] pattern 13, track 3
pattern14Definition_title:
 db $02 ; $0147: pattern 14 state
 db $03 ; $0148: transposition 1
 dw trackDef16_title ; $0149: [$02E1] pattern 14, track 1
 dw trackDef5_title ; $014B: [$029B] pattern 14, track 2
 dw trackDef6_title ; $014D: [$02BE] pattern 14, track 3
pattern15Definition_title:
 db $00 ; $014F: pattern 15 state
 dw trackDef16_title ; $0150: [$02E1] pattern 15, track 1
 dw trackDef5_title ; $0152: [$029B] pattern 15, track 2
 dw trackDef6_title ; $0154: [$02BE] pattern 15, track 3
pattern16Definition_title:
 db $00 ; $0156: pattern 16 state
 dw trackDef16_title ; $0157: [$02E1] pattern 16, track 1
 dw trackDef5_title ; $0159: [$029B] pattern 16, track 2
 dw trackDef6_title ; $015B: [$02BE] pattern 16, track 3
pattern17Definition_title:
 db $00 ; $015D: pattern 17 state
 dw trackDef16_title ; $015E: [$02E1] pattern 17, track 1
 dw trackDef5_title ; $0160: [$029B] pattern 17, track 2
 dw trackDef6_title ; $0162: [$02BE] pattern 17, track 3
pattern18Definition_title:
 db $02 ; $0164: pattern 18 state
 db $00 ; $0165: transposition 1
 dw trackDef16_title ; $0166: [$02E1] pattern 18, track 1
 dw trackDef5_title ; $0168: [$029B] pattern 18, track 2
 dw trackDef6_title ; $016A: [$02BE] pattern 18, track 3
pattern19Definition_title:
 db $00 ; $016C: pattern 19 state
 dw trackDef16_title ; $016D: [$02E1] pattern 19, track 1
 dw trackDef5_title ; $016F: [$029B] pattern 19, track 2
 dw trackDef6_title ; $0171: [$02BE] pattern 19, track 3
pattern20Definition_title:
 db $00 ; $0173: pattern 20 state
 dw trackDef16_title ; $0174: [$02E1] pattern 20, track 1
 dw trackDef5_title ; $0176: [$029B] pattern 20, track 2
 dw trackDef6_title ; $0178: [$02BE] pattern 20, track 3
pattern21Definition_title:
 db $00 ; $017A: pattern 21 state
 dw trackDef16_title ; $017B: [$02E1] pattern 21, track 1
 dw trackDef5_title ; $017D: [$029B] pattern 21, track 2
 dw trackDef6_title ; $017F: [$02BE] pattern 21, track 3
pattern22Definition_title:
 db $02 ; $0181: pattern 22 state
 db $02 ; $0182: transposition 1
 dw trackDef16_title ; $0183: [$02E1] pattern 22, track 1
 dw trackDef5_title ; $0185: [$029B] pattern 22, track 2
 dw trackDef6_title ; $0187: [$02BE] pattern 22, track 3
pattern23Definition_title:
 db $00 ; $0189: pattern 23 state
 dw trackDef16_title ; $018A: [$02E1] pattern 23, track 1
 dw trackDef5_title ; $018C: [$029B] pattern 23, track 2
 dw trackDef6_title ; $018E: [$02BE] pattern 23, track 3
pattern24Definition_title:
 db $00 ; $0190: pattern 24 state
 dw trackDef16_title ; $0191: [$02E1] pattern 24, track 1
 dw trackDef5_title ; $0193: [$029B] pattern 24, track 2
 dw trackDef6_title ; $0195: [$02BE] pattern 24, track 3
pattern25Definition_title:
 db $00 ; $0197: pattern 25 state
 dw trackDef16_title ; $0198: [$02E1] pattern 25, track 1
 dw trackDef5_title ; $019A: [$029B] pattern 25, track 2
 dw trackDef6_title ; $019C: [$02BE] pattern 25, track 3
pattern26Definition_title:
 db $02 ; $019E: pattern 26 state
 db $03 ; $019F: transposition 1
 dw trackDef16_title ; $01A0: [$02E1] pattern 26, track 1
 dw trackDef5_title ; $01A2: [$029B] pattern 26, track 2
 dw trackDef6_title ; $01A4: [$02BE] pattern 26, track 3
pattern27Definition_title:
 db $00 ; $01A6: pattern 27 state
 dw trackDef16_title ; $01A7: [$02E1] pattern 27, track 1
 dw trackDef5_title ; $01A9: [$029B] pattern 27, track 2
 dw trackDef6_title ; $01AB: [$02BE] pattern 27, track 3
pattern28Definition_title:
 db $00 ; $01AD: pattern 28 state
 dw trackDef16_title ; $01AE: [$02E1] pattern 28, track 1
 dw trackDef5_title ; $01B0: [$029B] pattern 28, track 2
 dw trackDef6_title ; $01B2: [$02BE] pattern 28, track 3
pattern29Definition_title:
 db $00 ; $01B4: pattern 29 state
 dw trackDef16_title ; $01B5: [$02E1] pattern 29, track 1
 dw trackDef5_title ; $01B7: [$029B] pattern 29, track 2
 dw trackDef6_title ; $01B9: [$02BE] pattern 29, track 3
pattern30Definition_title:
 db $02 ; $01BB: pattern 30 state
 db $05 ; $01BC: transposition 1
 dw trackDef16_title ; $01BD: [$02E1] pattern 30, track 1
 dw trackDef5_title ; $01BF: [$029B] pattern 30, track 2
 dw trackDef6_title ; $01C1: [$02BE] pattern 30, track 3
pattern31Definition_title:
 db $00 ; $01C3: pattern 31 state
 dw trackDef16_title ; $01C4: [$02E1] pattern 31, track 1
 dw trackDef5_title ; $01C6: [$029B] pattern 31, track 2
 dw trackDef6_title ; $01C8: [$02BE] pattern 31, track 3
pattern32Definition_title:
 db $00 ; $01CA: pattern 32 state
 dw trackDef16_title ; $01CB: [$02E1] pattern 32, track 1
 dw trackDef5_title ; $01CD: [$029B] pattern 32, track 2
 dw trackDef6_title ; $01CF: [$02BE] pattern 32, track 3
pattern33Definition_title:
 db $00 ; $01D1: pattern 33 state
 dw trackDef16_title ; $01D2: [$02E1] pattern 33, track 1
 dw trackDef5_title ; $01D4: [$029B] pattern 33, track 2
 dw trackDef6_title ; $01D6: [$02BE] pattern 33, track 3
pattern34Definition_title:
 db $02 ; $01D8: pattern 34 state
 db $00 ; $01D9: transposition 1
 dw trackDef41_title ; $01DA: [$02F5] pattern 34, track 1
 dw trackDef5_title ; $01DC: [$029B] pattern 34, track 2
 dw trackDef43_title ; $01DE: [$0352] pattern 34, track 3
pattern35Definition_title:
 db $00 ; $01E0: pattern 35 state
 dw trackDef44_title ; $01E1: [$0323] pattern 35, track 1
 dw trackDef5_title ; $01E3: [$029B] pattern 35, track 2
 dw trackDef46_title ; $01E5: [$0379] pattern 35, track 3
pattern36Definition_title:
 db $00 ; $01E7: pattern 36 state
 dw trackDef41_title ; $01E8: [$02F5] pattern 36, track 1
 dw trackDef5_title ; $01EA: [$029B] pattern 36, track 2
 dw trackDef43_title ; $01EC: [$0352] pattern 36, track 3
pattern37Definition_title:
 db $00 ; $01EE: pattern 37 state
 dw trackDef44_title ; $01EF: [$0323] pattern 37, track 1
 dw trackDef5_title ; $01F1: [$029B] pattern 37, track 2
 dw trackDef46_title ; $01F3: [$0379] pattern 37, track 3
pattern38Definition_title:
 db $00 ; $01F5: pattern 38 state
 dw trackDef41_title ; $01F6: [$02F5] pattern 38, track 1
 dw trackDef5_title ; $01F8: [$029B] pattern 38, track 2
 dw trackDef43_title ; $01FA: [$0352] pattern 38, track 3
pattern39Definition_title:
 db $00 ; $01FC: pattern 39 state
 dw trackDef44_title ; $01FD: [$0323] pattern 39, track 1
 dw trackDef5_title ; $01FF: [$029B] pattern 39, track 2
 dw trackDef46_title ; $0201: [$0379] pattern 39, track 3
pattern40Definition_title:
 db $00 ; $0203: pattern 40 state
 dw trackDef41_title ; $0204: [$02F5] pattern 40, track 1
 dw trackDef5_title ; $0206: [$029B] pattern 40, track 2
 dw trackDef43_title ; $0208: [$0352] pattern 40, track 3
pattern41Definition_title:
 db $00 ; $020A: pattern 41 state
 dw trackDef44_title ; $020B: [$0323] pattern 41, track 1
 dw trackDef5_title ; $020D: [$029B] pattern 41, track 2
 dw trackDef46_title ; $020F: [$0379] pattern 41, track 3
pattern42Definition_title:
 db $01 ; $0211: pattern 42 state
 dw pattern0Definition_title ; $0212: [$00E1] song restart address
specialtrackDef0_title:
 db $15 ; $0214: data, speed 5
 db $00 ; $0215: wait 128
trackDef1_title:
 db $42 ; $0216: normal track data
 db $80 ; $0217: vol off, pitch, no note, no instrument
 dw $0000 ; $0218: pitch
 db $00 ; $021A: track end signature found
trackDef0_title:
 db $52 ; $021B: normal track data
 db $E1 ; $021C: vol = $F (inverted), no pitch, no note, no instrument
 dw $FFF6 ; $021D: pitch
 db $01 ; $021F: instrument
 db $42 ; $0220: normal track data
 db $00 ; $0221: vol off, no pitch, no note, no instrument
 db $42 ; $0222: normal track data
 db $00 ; $0223: vol off, no pitch, no note, no instrument
 db $42 ; $0224: normal track data
 db $00 ; $0225: vol off, no pitch, no note, no instrument
 db $42 ; $0226: normal track data
 db $00 ; $0227: vol off, no pitch, no note, no instrument
 db $42 ; $0228: normal track data
 db $00 ; $0229: vol off, no pitch, no note, no instrument
 db $42 ; $022A: normal track data
 db $00 ; $022B: vol off, no pitch, no note, no instrument
 db $42 ; $022C: normal track data
 db $00 ; $022D: vol off, no pitch, no note, no instrument
 db $42 ; $022E: normal track data
 db $00 ; $022F: vol off, no pitch, no note, no instrument
 db $42 ; $0230: normal track data
 db $00 ; $0231: vol off, no pitch, no note, no instrument
 db $42 ; $0232: normal track data
 db $00 ; $0233: vol off, no pitch, no note, no instrument
 db $42 ; $0234: normal track data
 db $00 ; $0235: vol off, no pitch, no note, no instrument
 db $42 ; $0236: normal track data
 db $00 ; $0237: vol off, no pitch, no note, no instrument
 db $42 ; $0238: normal track data
 db $00 ; $0239: vol off, no pitch, no note, no instrument
 db $42 ; $023A: normal track data
 db $00 ; $023B: vol off, no pitch, no note, no instrument
 db $42 ; $023C: normal track data
 db $00 ; $023D: vol off, no pitch, no note, no instrument
 db $42 ; $023E: normal track data
 db $00 ; $023F: vol off, no pitch, no note, no instrument
 db $42 ; $0240: normal track data
 db $00 ; $0241: vol off, no pitch, no note, no instrument
 db $42 ; $0242: normal track data
 db $00 ; $0243: vol off, no pitch, no note, no instrument
 db $42 ; $0244: normal track data
 db $00 ; $0245: vol off, no pitch, no note, no instrument
 db $42 ; $0246: normal track data
 db $00 ; $0247: vol off, no pitch, no note, no instrument
 db $42 ; $0248: normal track data
 db $00 ; $0249: vol off, no pitch, no note, no instrument
 db $42 ; $024A: normal track data
 db $00 ; $024B: vol off, no pitch, no note, no instrument
 db $42 ; $024C: normal track data
 db $00 ; $024D: vol off, no pitch, no note, no instrument
 db $42 ; $024E: normal track data
 db $00 ; $024F: vol off, no pitch, no note, no instrument
 db $42 ; $0250: normal track data
 db $00 ; $0251: vol off, no pitch, no note, no instrument
 db $42 ; $0252: normal track data
 db $00 ; $0253: vol off, no pitch, no note, no instrument
 db $42 ; $0254: normal track data
 db $00 ; $0255: vol off, no pitch, no note, no instrument
 db $42 ; $0256: normal track data
 db $00 ; $0257: vol off, no pitch, no note, no instrument
 db $42 ; $0258: normal track data
 db $00 ; $0259: vol off, no pitch, no note, no instrument
 db $42 ; $025A: normal track data
 db $00 ; $025B: vol off, no pitch, no note, no instrument
 db $42 ; $025C: normal track data
 db $00 ; $025D: vol off, no pitch, no note, no instrument
trackDef3_title:
 db $42 ; $025E: normal track data
 db $80 ; $025F: vol off, pitch, no note, no instrument
 dw $0000 ; $0260: pitch
 db $42 ; $0262: normal track data
 db $00 ; $0263: vol off, no pitch, no note, no instrument
 db $06 ; $0264: normal track data,  wait 2
 db $42 ; $0265: normal track data
 db $03 ; $0266: vol = $E (inverted), no pitch, no note, no instrument
 db $08 ; $0267: normal track data,  wait 3
 db $42 ; $0268: normal track data,  note: C0
 db $05 ; $0269: vol = $D (inverted), no pitch, no note, no instrument
 db $00 ; $026A: track end signature found
trackDef4_title:
 db $42 ; $026B: normal track data
 db $80 ; $026C: vol off, pitch, no note, no instrument
 dw $0000 ; $026D: pitch
 db $02 ; $026F: normal track data,  wait 0
 db $42 ; $0270: normal track data,  note: C0
 db $07 ; $0271: vol = $C (inverted), no pitch, no note, no instrument
 db $08 ; $0272: normal track data,  wait 3
 db $42 ; $0273: normal track data
 db $09 ; $0274: vol = $B (inverted), no pitch, no note, no instrument
 db $08 ; $0275: normal track data,  wait 3
 db $42 ; $0276: normal track data
 db $0B ; $0277: vol = $A (inverted), no pitch, no note, no instrument
 db $00 ; $0278: track end signature found
trackDef7_title:
 db $42 ; $0279: normal track data
 db $80 ; $027A: vol off, pitch, no note, no instrument
 dw $0000 ; $027B: pitch
 db $42 ; $027D: normal track data,  note: C0
 db $0D ; $027E: vol = $9 (inverted), no pitch, no note, no instrument
 db $08 ; $027F: normal track data,  wait 3
 db $42 ; $0280: normal track data,  note: C0
 db $0F ; $0281: vol = $8 (inverted), no pitch, no note, no instrument
 db $08 ; $0282: normal track data,  wait 3
 db $42 ; $0283: normal track data
 db $11 ; $0284: vol = $7 (inverted), no pitch, no note, no instrument
 db $00 ; $0285: track end signature found
trackDef9_title:
 db $42 ; $0286: normal track data
 db $93 ; $0287: vol = $6 (inverted), no pitch, no note, no instrument
 dw $0000 ; $0288: pitch
 db $04 ; $028A: normal track data,  wait 1
 db $42 ; $028B: normal track data,  note: C0
 db $15 ; $028C: vol = $5 (inverted), no pitch, no note, no instrument
 db $04 ; $028D: normal track data,  wait 1
 db $42 ; $028E: normal track data,  note: C0
 db $17 ; $028F: vol = $4 (inverted), no pitch, no note, no instrument
 db $04 ; $0290: normal track data,  wait 1
 db $42 ; $0291: normal track data
 db $19 ; $0292: vol = $3 (inverted), no pitch, no note, no instrument
 db $04 ; $0293: normal track data,  wait 1
 db $42 ; $0294: normal track data
 db $1B ; $0295: vol = $2 (inverted), no pitch, no note, no instrument
 db $02 ; $0296: normal track data,  wait 0
 db $42 ; $0297: normal track data,  note: C0
 db $1D ; $0298: vol = $1 (inverted), no pitch, no note, no instrument
 db $42 ; $0299: normal track data,  note: C0
 db $1F ; $029A: vol = $0 (inverted), no pitch, no note, no instrument
trackDef5_title:
 db $A8 ; $029B: normal track data
 db $E1 ; $029C: vol = $F (inverted), no pitch, no note, no instrument
 dw $0000 ; $029D: pitch
 db $02 ; $029F: instrument
 db $C0 ; $02A0: normal track data
 db $49 ; $02A1: vol = $B (inverted), no pitch, no note, no instrument
 db $B8 ; $02A2: normal track data
 db $41 ; $02A3: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $02A4: normal track data
 db $49 ; $02A5: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $02A6: normal track data
 db $41 ; $02A7: vol = $F (inverted), no pitch, no note, no instrument
 db $B8 ; $02A8: normal track data
 db $49 ; $02A9: vol = $B (inverted), no pitch, no note, no instrument
 db $B6 ; $02AA: normal track data
 db $41 ; $02AB: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $02AC: normal track data
 db $49 ; $02AD: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $02AE: normal track data
 db $41 ; $02AF: vol = $F (inverted), no pitch, no note, no instrument
 db $B6 ; $02B0: normal track data
 db $49 ; $02B1: vol = $B (inverted), no pitch, no note, no instrument
 db $BC ; $02B2: normal track data
 db $41 ; $02B3: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $02B4: normal track data
 db $49 ; $02B5: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $02B6: normal track data
 db $41 ; $02B7: vol = $F (inverted), no pitch, no note, no instrument
 db $BC ; $02B8: normal track data
 db $49 ; $02B9: vol = $B (inverted), no pitch, no note, no instrument
 db $C0 ; $02BA: normal track data
 db $41 ; $02BB: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $02BC: normal track data
 db $49 ; $02BD: vol = $B (inverted), no pitch, no note, no instrument
trackDef6_title:
 db $A8 ; $02BE: normal track data
 db $E9 ; $02BF: vol = $B (inverted), no pitch, no note, no instrument
 dw $0000 ; $02C0: pitch
 db $03 ; $02C2: instrument
 db $A8 ; $02C3: normal track data
 db $41 ; $02C4: vol = $F (inverted), no pitch, no note, no instrument
 db $C0 ; $02C5: normal track data
 db $49 ; $02C6: vol = $B (inverted), no pitch, no note, no instrument
 db $B8 ; $02C7: normal track data
 db $41 ; $02C8: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $02C9: normal track data
 db $49 ; $02CA: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $02CB: normal track data
 db $41 ; $02CC: vol = $F (inverted), no pitch, no note, no instrument
 db $B8 ; $02CD: normal track data
 db $49 ; $02CE: vol = $B (inverted), no pitch, no note, no instrument
 db $B6 ; $02CF: normal track data
 db $41 ; $02D0: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $02D1: normal track data
 db $49 ; $02D2: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $02D3: normal track data
 db $41 ; $02D4: vol = $F (inverted), no pitch, no note, no instrument
 db $B6 ; $02D5: normal track data
 db $49 ; $02D6: vol = $B (inverted), no pitch, no note, no instrument
 db $BC ; $02D7: normal track data
 db $41 ; $02D8: vol = $F (inverted), no pitch, no note, no instrument
 db $A8 ; $02D9: normal track data
 db $49 ; $02DA: vol = $B (inverted), no pitch, no note, no instrument
 db $A8 ; $02DB: normal track data
 db $41 ; $02DC: vol = $F (inverted), no pitch, no note, no instrument
 db $BC ; $02DD: normal track data
 db $49 ; $02DE: vol = $B (inverted), no pitch, no note, no instrument
 db $C0 ; $02DF: normal track data
 db $41 ; $02E0: vol = $F (inverted), no pitch, no note, no instrument
trackDef16_title:
 db $6A ; $02E1: normal track data
 db $E1 ; $02E2: vol = $F (inverted), no pitch, no note, no instrument
 dw $0000 ; $02E3: pitch
 db $04 ; $02E5: instrument
 db $02 ; $02E6: normal track data,  wait 0
 db $2B ; $02E7: full optimization, no escape: G#1
 db $02 ; $02E8: normal track data,  wait 0
 db $2B ; $02E9: full optimization, no escape: G#1
 db $02 ; $02EA: normal track data,  wait 0
 db $2B ; $02EB: full optimization, no escape: G#1
 db $02 ; $02EC: normal track data,  wait 0
 db $2B ; $02ED: full optimization, no escape: G#1
 db $02 ; $02EE: normal track data,  wait 0
 db $2B ; $02EF: full optimization, no escape: G#1
 db $02 ; $02F0: normal track data,  wait 0
 db $2B ; $02F1: full optimization, no escape: G#1
 db $02 ; $02F2: normal track data,  wait 0
 db $2B ; $02F3: full optimization, no escape: G#1
 db $00 ; $02F4: track end signature found
trackDef41_title:
 db $5E ; $02F5: normal track data
 db $E0 ; $02F6: vol off, pitch, note, instrument
 dw $0000 ; $02F7: pitch
 db $05 ; $02F9: instrument
 db $8A ; $02FA: normal track data
 db $60 ; $02FB: vol off, no pitch, note, instrument
 db $06 ; $02FC: instrument
 db $5C ; $02FD: normal track data
 db $60 ; $02FE: vol off, no pitch, note, instrument
 db $07 ; $02FF: instrument
 db $21 ; $0300: full optimization, no escape: D#1
 db $8A ; $0301: normal track data
 db $60 ; $0302: vol off, no pitch, note, instrument
 db $08 ; $0303: instrument
 db $8A ; $0304: normal track data
 db $60 ; $0305: vol off, no pitch, note, instrument
 db $06 ; $0306: instrument
 db $8A ; $0307: normal track data
 db $60 ; $0308: vol off, no pitch, note, instrument
 db $08 ; $0309: instrument
 db $5E ; $030A: normal track data
 db $60 ; $030B: vol off, no pitch, note, instrument
 db $05 ; $030C: instrument
 db $8A ; $030D: normal track data
 db $60 ; $030E: vol off, no pitch, note, instrument
 db $06 ; $030F: instrument
 db $8A ; $0310: normal track data
 db $60 ; $0311: vol off, no pitch, note, instrument
 db $08 ; $0312: instrument
 db $5E ; $0313: normal track data
 db $60 ; $0314: vol off, no pitch, note, instrument
 db $05 ; $0315: instrument
 db $8A ; $0316: normal track data
 db $60 ; $0317: vol off, no pitch, note, instrument
 db $06 ; $0318: instrument
 db $8A ; $0319: normal track data
 db $60 ; $031A: vol off, no pitch, note, instrument
 db $08 ; $031B: instrument
 db $8A ; $031C: normal track data
 db $60 ; $031D: vol off, no pitch, note, instrument
 db $06 ; $031E: instrument
 db $5C ; $031F: normal track data
 db $60 ; $0320: vol off, no pitch, note, instrument
 db $07 ; $0321: instrument
 db $21 ; $0322: full optimization, no escape: D#1
trackDef44_title:
 db $5E ; $0323: normal track data
 db $E0 ; $0324: vol off, pitch, note, instrument
 dw $0000 ; $0325: pitch
 db $05 ; $0327: instrument
 db $8A ; $0328: normal track data
 db $60 ; $0329: vol off, no pitch, note, instrument
 db $06 ; $032A: instrument
 db $5C ; $032B: normal track data
 db $60 ; $032C: vol off, no pitch, note, instrument
 db $07 ; $032D: instrument
 db $21 ; $032E: full optimization, no escape: D#1
 db $8A ; $032F: normal track data
 db $60 ; $0330: vol off, no pitch, note, instrument
 db $08 ; $0331: instrument
 db $8A ; $0332: normal track data
 db $60 ; $0333: vol off, no pitch, note, instrument
 db $06 ; $0334: instrument
 db $8A ; $0335: normal track data
 db $60 ; $0336: vol off, no pitch, note, instrument
 db $08 ; $0337: instrument
 db $5E ; $0338: normal track data
 db $60 ; $0339: vol off, no pitch, note, instrument
 db $05 ; $033A: instrument
 db $8A ; $033B: normal track data
 db $60 ; $033C: vol off, no pitch, note, instrument
 db $06 ; $033D: instrument
 db $8A ; $033E: normal track data
 db $60 ; $033F: vol off, no pitch, note, instrument
 db $08 ; $0340: instrument
 db $5E ; $0341: normal track data
 db $60 ; $0342: vol off, no pitch, note, instrument
 db $05 ; $0343: instrument
 db $8A ; $0344: normal track data
 db $60 ; $0345: vol off, no pitch, note, instrument
 db $06 ; $0346: instrument
 db $B6 ; $0347: normal track data
 db $60 ; $0348: vol off, no pitch, note, instrument
 db $09 ; $0349: instrument
 db $42 ; $034A: normal track data
 db $00 ; $034B: vol off, no pitch, no note, no instrument
 db $56 ; $034C: normal track data
 db $60 ; $034D: vol off, no pitch, note, instrument
 db $07 ; $034E: instrument
 db $8A ; $034F: normal track data
 db $60 ; $0350: vol off, no pitch, note, instrument
 db $08 ; $0351: instrument
trackDef43_title:
 db $B6 ; $0352: normal track data
 db $E0 ; $0353: vol off, pitch, note, instrument
 dw $0000 ; $0354: pitch
 db $0A ; $0356: instrument
 db $42 ; $0357: normal track data
 db $00 ; $0358: vol off, no pitch, no note, no instrument
 db $8A ; $0359: normal track data
 db $60 ; $035A: vol off, no pitch, note, instrument
 db $08 ; $035B: instrument
 db $8A ; $035C: normal track data
 db $60 ; $035D: vol off, no pitch, note, instrument
 db $06 ; $035E: instrument
 db $5C ; $035F: normal track data
 db $60 ; $0360: vol off, no pitch, note, instrument
 db $0B ; $0361: instrument
 db $42 ; $0362: normal track data
 db $00 ; $0363: vol off, no pitch, no note, no instrument
 db $60 ; $0364: normal track data
 db $60 ; $0365: vol off, no pitch, note, instrument
 db $07 ; $0366: instrument
 db $27 ; $0367: full optimization, no escape: F#1
 db $B6 ; $0368: normal track data
 db $60 ; $0369: vol off, no pitch, note, instrument
 db $0A ; $036A: instrument
 db $02 ; $036B: normal track data,  wait 0
 db $5C ; $036C: normal track data
 db $60 ; $036D: vol off, no pitch, note, instrument
 db $07 ; $036E: instrument
 db $21 ; $036F: full optimization, no escape: D#1
 db $5C ; $0370: normal track data
 db $60 ; $0371: vol off, no pitch, note, instrument
 db $0B ; $0372: instrument
 db $02 ; $0373: normal track data,  wait 0
 db $B6 ; $0374: normal track data
 db $60 ; $0375: vol off, no pitch, note, instrument
 db $0C ; $0376: instrument
 db $42 ; $0377: normal track data
 db $00 ; $0378: vol off, no pitch, no note, no instrument
trackDef46_title:
 db $8A ; $0379: normal track data
 db $E0 ; $037A: vol off, pitch, note, instrument
 dw $0000 ; $037B: pitch
 db $08 ; $037D: instrument
 db $02 ; $037E: normal track data,  wait 0
 db $B6 ; $037F: normal track data
 db $60 ; $0380: vol off, no pitch, note, instrument
 db $0A ; $0381: instrument
 db $42 ; $0382: normal track data
 db $00 ; $0383: vol off, no pitch, no note, no instrument
 db $5C ; $0384: normal track data
 db $60 ; $0385: vol off, no pitch, note, instrument
 db $0B ; $0386: instrument
 db $02 ; $0387: normal track data,  wait 0
 db $60 ; $0388: normal track data
 db $60 ; $0389: vol off, no pitch, note, instrument
 db $07 ; $038A: instrument
 db $27 ; $038B: full optimization, no escape: F#1
 db $B6 ; $038C: normal track data
 db $60 ; $038D: vol off, no pitch, note, instrument
 db $0A ; $038E: instrument
 db $42 ; $038F: normal track data
 db $00 ; $0390: vol off, no pitch, no note, no instrument
 db $5C ; $0391: normal track data
 db $60 ; $0392: vol off, no pitch, note, instrument
 db $07 ; $0393: instrument
 db $21 ; $0394: full optimization, no escape: D#1
 db $5C ; $0395: normal track data
 db $60 ; $0396: vol off, no pitch, note, instrument
 db $0B ; $0397: instrument
 db $8A ; $0398: normal track data
 db $60 ; $0399: vol off, no pitch, note, instrument
 db $08 ; $039A: instrument
 db $8A ; $039B: normal track data
 db $60 ; $039C: vol off, no pitch, note, instrument
 db $06 ; $039D: instrument
 db $5C ; $039E: normal track data
 db $60 ; $039F: vol off, no pitch, note, instrument
 db $07 ; $03A0: instrument