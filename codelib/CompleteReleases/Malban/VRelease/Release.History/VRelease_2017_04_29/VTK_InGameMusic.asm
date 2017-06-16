; this file is part of Release, written by Malban in 2017
;

; This file was build using VIDE - Vectrex Integrated Development Environment
; Original bin file was: projects/ArkosPlayer/rel2.bin
; 
; offset for AKS file assumed: $0000 guessed by accessing byte data[13] * 256)
; not used by vectrex player and therefor omitted:
;  DB "AT10" ; Signature of Arkos Tracker files
;  DB $01 ; sample channel
;  DB $40, 42, 0f ; YM custom frequence - little endian
;  DB $02 ; Replay frequency (0=13hz,1=25hz,2=50hz,3=100hz,4=150hz,5=300hz)
 db $06 ; $0009: default speed
 dw $00F7 ; $000A: size of instrument table (without this word pointer)
 dw instrument0 ; $000C: [$0026] pointer to instrument 0
 dw instrument1 ; $000E: [$002F] pointer to instrument 1
 dw instrument2 ; $0010: [$0037] pointer to instrument 2
 dw instrument3 ; $0012: [$004F] pointer to instrument 3
 dw instrument4 ; $0014: [$005A] pointer to instrument 4
 dw instrument5 ; $0016: [$0064] pointer to instrument 5
 dw instrument6 ; $0018: [$007B] pointer to instrument 6
 dw instrument7 ; $001A: [$008C] pointer to instrument 7
 dw instrument8 ; $001C: [$009A] pointer to instrument 8
 dw instrument9 ; $001E: [$00A6] pointer to instrument 9
 dw instrument10 ; $0020: [$00BC] pointer to instrument 10
 dw instrument11 ; $0022: [$00C9] pointer to instrument 11
 dw instrument12 ; $0024: [$00F2] pointer to instrument 12
instrument0:
 db $00 ; $0026: speed
 db $00 ; $0027: retrig
instrument0loop:
 db $00 ; $0028: dataColumn_0 (non hard)
 db $00 ; $0029: dataColumn_0 (non hard)
 db $00 ; $002A: dataColumn_0 (non hard)
 db $00 ; $002B: dataColumn_0 (non hard)
 db $0D ; $002C: dataColumn_0 (hard)
 dw instrument0loop ; $002D: [$0028] loop
instrument1:
 db $03 ; $002F: speed
 db $00 ; $0030: retrig
instrument1loop:
 db $3C ; $0031: dataColumn_0 (non hard)
 db $7C ; $0032: dataColumn_0 (non hard)
 db $0C ; $0033: arpegio
 db $0D ; $0034: dataColumn_0 (hard)
 dw instrument1loop ; $0035: [$0031] loop
instrument2:
 db $01 ; $0037: speed
 db $00 ; $0038: retrig
 db $68 ; $0039: dataColumn_0 (non hard)
 db $0C ; $003A: arpegio
 db $68 ; $003B: dataColumn_0 (non hard)
 db $F4 ; $003C: arpegio
 db $68 ; $003D: dataColumn_0 (non hard)
 db $F4 ; $003E: arpegio
 db $64 ; $003F: dataColumn_0 (non hard)
 db $F4 ; $0040: arpegio
 db $20 ; $0041: dataColumn_0 (non hard)
 db $5C ; $0042: dataColumn_0 (non hard)
 db $F4 ; $0043: arpegio
 db $58 ; $0044: dataColumn_0 (non hard)
 db $F4 ; $0045: arpegio
 db $02 ; $0046: dataColumn_0 (non hard)
 db $20 ; $0047: dataColumn_1
 db $02 ; $0048: dataColumn_0 (non hard)
 db $20 ; $0049: dataColumn_1
 db $02 ; $004A: dataColumn_0 (non hard)
 db $20 ; $004B: dataColumn_1
 db $0D ; $004C: dataColumn_0 (hard)
 dw instrument0loop ; $004D: [$0028] loop
instrument3:
 db $01 ; $004F: speed
 db $00 ; $0050: retrig
 db $6C ; $0051: dataColumn_0 (non hard)
 db $F4 ; $0052: arpegio
 db $64 ; $0053: dataColumn_0 (non hard)
 db $0C ; $0054: arpegio
 db $64 ; $0055: dataColumn_0 (non hard)
 db $F4 ; $0056: arpegio
 db $0D ; $0057: dataColumn_0 (hard)
 dw instrument0loop ; $0058: [$0028] loop
instrument4:
 db $02 ; $005A: speed
 db $00 ; $005B: retrig
 db $3C ; $005C: dataColumn_0 (non hard)
 db $38 ; $005D: dataColumn_0 (non hard)
 db $70 ; $005E: dataColumn_0 (non hard)
 db $0C ; $005F: arpegio
 db $28 ; $0060: dataColumn_0 (non hard)
 db $0D ; $0061: dataColumn_0 (hard)
 dw instrument0loop ; $0062: [$0028] loop
instrument5:
 db $01 ; $0064: speed
 db $00 ; $0065: retrig
 db $7C ; $0066: dataColumn_0 (non hard)
 db $0C ; $0067: arpegio
 db $7C ; $0068: dataColumn_0 (non hard)
 db $09 ; $0069: arpegio
 db $74 ; $006A: dataColumn_0 (non hard)
 db $0E ; $006B: arpegio
 db $6C ; $006C: dataColumn_0 (non hard)
 db $07 ; $006D: arpegio
 db $64 ; $006E: dataColumn_0 (non hard)
 db $0B ; $006F: arpegio
 db $58 ; $0070: dataColumn_0 (non hard)
 db $0A ; $0071: arpegio
 db $54 ; $0072: dataColumn_0 (non hard)
 db $09 ; $0073: arpegio
 db $50 ; $0074: dataColumn_0 (non hard)
 db $06 ; $0075: arpegio
 db $4C ; $0076: dataColumn_0 (non hard)
 db $04 ; $0077: arpegio
 db $0D ; $0078: dataColumn_0 (hard)
 dw instrument0loop ; $0079: [$0028] loop
instrument6:
 db $01 ; $007B: speed
 db $00 ; $007C: retrig
 db $34 ; $007D: dataColumn_0 (non hard)
 db $6C ; $007E: dataColumn_0 (non hard)
 db $0C ; $007F: arpegio
 db $18 ; $0080: dataColumn_0 (non hard)
 db $6C ; $0081: dataColumn_0 (non hard)
 db $18 ; $0082: arpegio
 db $28 ; $0083: dataColumn_0 (non hard)
 db $4C ; $0084: dataColumn_0 (non hard)
 db $0C ; $0085: arpegio
 db $1C ; $0086: dataColumn_0 (non hard)
 db $60 ; $0087: dataColumn_0 (non hard)
 db $18 ; $0088: arpegio
 db $0D ; $0089: dataColumn_0 (hard)
 dw instrument0loop ; $008A: [$0028] loop
instrument7:
 db $01 ; $008C: speed
 db $00 ; $008D: retrig
 db $7C ; $008E: dataColumn_0 (non hard)
 db $0F ; $008F: arpegio
 db $74 ; $0090: dataColumn_0 (non hard)
 db $0A ; $0091: arpegio
 db $7C ; $0092: dataColumn_0 (non hard)
 db $06 ; $0093: arpegio
 db $6C ; $0094: dataColumn_0 (non hard)
 db $03 ; $0095: arpegio
 db $18 ; $0096: dataColumn_0 (non hard)
 db $0D ; $0097: dataColumn_0 (hard)
 dw instrument0loop ; $0098: [$0028] loop
instrument8:
 db $01 ; $009A: speed
 db $00 ; $009B: retrig
 db $28 ; $009C: dataColumn_0 (non hard)
 db $68 ; $009D: dataColumn_0 (non hard)
 db $0C ; $009E: arpegio
 db $2C ; $009F: dataColumn_0 (non hard)
 db $68 ; $00A0: dataColumn_0 (non hard)
 db $0C ; $00A1: arpegio
 db $28 ; $00A2: dataColumn_0 (non hard)
 db $0D ; $00A3: dataColumn_0 (hard)
 dw instrument0loop ; $00A4: [$0028] loop
instrument9:
 db $01 ; $00A6: speed
 db $00 ; $00A7: retrig
 db $68 ; $00A8: dataColumn_0 (non hard)
 db $18 ; $00A9: arpegio
 db $6C ; $00AA: dataColumn_0 (non hard)
 db $0C ; $00AB: arpegio
 db $70 ; $00AC: dataColumn_0 (non hard)
 db $18 ; $00AD: arpegio
 db $2C ; $00AE: dataColumn_0 (non hard)
 db $70 ; $00AF: dataColumn_0 (non hard)
 db $18 ; $00B0: arpegio
 db $64 ; $00B1: dataColumn_0 (non hard)
 db $0C ; $00B2: arpegio
 db $5C ; $00B3: dataColumn_0 (non hard)
 db $18 ; $00B4: arpegio
 db $58 ; $00B5: dataColumn_0 (non hard)
 db $0C ; $00B6: arpegio
 db $50 ; $00B7: dataColumn_0 (non hard)
 db $18 ; $00B8: arpegio
 db $0D ; $00B9: dataColumn_0 (hard)
 dw instrument0loop ; $00BA: [$0028] loop
instrument10:
 db $01 ; $00BC: speed
 db $00 ; $00BD: retrig
 db $78 ; $00BE: dataColumn_0 (non hard)
 db $12 ; $00BF: arpegio
instrument10loop:
 db $70 ; $00C0: dataColumn_0 (non hard)
 db $FA ; $00C1: arpegio
 db $70 ; $00C2: dataColumn_0 (non hard)
 db $06 ; $00C3: arpegio
 db $70 ; $00C4: dataColumn_0 (non hard)
 db $06 ; $00C5: arpegio
 db $0D ; $00C6: dataColumn_0 (hard)
 dw instrument10loop ; $00C7: [$00C0] loop
instrument11:
 db $01 ; $00C9: speed
 db $00 ; $00CA: retrig
 db $7C ; $00CB: dataColumn_0 (non hard)
 db $0C ; $00CC: arpegio
 db $7C ; $00CD: dataColumn_0 (non hard)
 db $06 ; $00CE: arpegio
 db $78 ; $00CF: dataColumn_0 (non hard)
 db $06 ; $00D0: arpegio
 db $78 ; $00D1: dataColumn_0 (non hard)
 db $06 ; $00D2: arpegio
 db $74 ; $00D3: dataColumn_0 (non hard)
 db $06 ; $00D4: arpegio
 db $74 ; $00D5: dataColumn_0 (non hard)
 db $06 ; $00D6: arpegio
 db $70 ; $00D7: dataColumn_0 (non hard)
 db $06 ; $00D8: arpegio
 db $70 ; $00D9: dataColumn_0 (non hard)
 db $06 ; $00DA: arpegio
 db $6C ; $00DB: dataColumn_0 (non hard)
 db $06 ; $00DC: arpegio
 db $68 ; $00DD: dataColumn_0 (non hard)
 db $06 ; $00DE: arpegio
 db $64 ; $00DF: dataColumn_0 (non hard)
 db $06 ; $00E0: arpegio
 db $60 ; $00E1: dataColumn_0 (non hard)
 db $06 ; $00E2: arpegio
 db $5C ; $00E3: dataColumn_0 (non hard)
 db $06 ; $00E4: arpegio
 db $5C ; $00E5: dataColumn_0 (non hard)
 db $06 ; $00E6: arpegio
 db $58 ; $00E7: dataColumn_0 (non hard)
 db $06 ; $00E8: arpegio
 db $58 ; $00E9: dataColumn_0 (non hard)
 db $06 ; $00EA: arpegio
 db $54 ; $00EB: dataColumn_0 (non hard)
 db $06 ; $00EC: arpegio
 db $50 ; $00ED: dataColumn_0 (non hard)
 db $06 ; $00EE: arpegio
 db $0D ; $00EF: dataColumn_0 (hard)
 dw instrument0loop ; $00F0: [$0028] loop
instrument12:
 db $02 ; $00F2: speed
 db $00 ; $00F3: retrig
 db $6C ; $00F4: dataColumn_0 (non hard)
 db $0C ; $00F5: arpegio
 db $20 ; $00F6: dataColumn_0 (non hard)
 db $02 ; $00F7: dataColumn_0 (non hard)
 db $20 ; $00F8: dataColumn_1
 db $02 ; $00F9: dataColumn_0 (non hard)
 db $20 ; $00FA: dataColumn_1
 db $02 ; $00FB: dataColumn_0 (non hard)
 db $20 ; $00FC: dataColumn_1
 db $58 ; $00FD: dataColumn_0 (non hard)
 db $0C ; $00FE: arpegio
 db $10 ; $00FF: dataColumn_0 (non hard)
 db $0D ; $0100: dataColumn_0 (hard)
 dw instrument0loop ; $0101: [$0028] loop
; start of linker definition
linker:
 db $20 ; $0103: first height
 db $00 ; $0104: transposition1
 db $00 ; $0105: transposition2
 db $00 ; $0106: transposition3
 dw specialtrackDef0 ; $0107: [$05CD] specialTrack
pattern0Definition:
 db $10 ; $0109: pattern 0 state
 dw trackDef0 ; $010A: [$05F2] pattern 0, track 1
 dw trackDef1 ; $010C: [$05CF] pattern 0, track 2
 dw trackDef1 ; $010E: [$05CF] pattern 0, track 3
 db $20 ; $0110: new height
pattern1Definition:
 db $10 ; $0111: pattern 1 state
 dw trackDef3 ; $0112: [$0637] pattern 1, track 1
 dw trackDef1 ; $0114: [$05CF] pattern 1, track 2
 dw trackDef1 ; $0116: [$05CF] pattern 1, track 3
 db $10 ; $0118: new height
pattern2Definition:
 db $10 ; $0119: pattern 2 state
 dw trackDef4 ; $011A: [$065A] pattern 2, track 1
 dw trackDef1 ; $011C: [$05CF] pattern 2, track 2
 dw trackDef1 ; $011E: [$05CF] pattern 2, track 3
 db $08 ; $0120: new height
pattern3Definition:
 db $00 ; $0121: pattern 3 state
 dw trackDef4 ; $0122: [$065A] pattern 3, track 1
 dw trackDef1 ; $0124: [$05CF] pattern 3, track 2
 dw trackDef1 ; $0126: [$05CF] pattern 3, track 3
pattern4Definition:
 db $00 ; $0128: pattern 4 state
 dw trackDef4 ; $0129: [$065A] pattern 4, track 1
 dw trackDef1 ; $012B: [$05CF] pattern 4, track 2
 dw trackDef1 ; $012D: [$05CF] pattern 4, track 3
pattern5Definition:
 db $00 ; $012F: pattern 5 state
 dw trackDef4 ; $0130: [$065A] pattern 5, track 1
 dw trackDef1 ; $0132: [$05CF] pattern 5, track 2
 dw trackDef1 ; $0134: [$05CF] pattern 5, track 3
pattern6Definition:
 db $00 ; $0136: pattern 6 state
 dw trackDef4 ; $0137: [$065A] pattern 6, track 1
 dw trackDef1 ; $0139: [$05CF] pattern 6, track 2
 dw trackDef1 ; $013B: [$05CF] pattern 6, track 3
pattern7Definition:
 db $00 ; $013D: pattern 7 state
 dw trackDef4 ; $013E: [$065A] pattern 7, track 1
 dw trackDef1 ; $0140: [$05CF] pattern 7, track 2
 dw trackDef1 ; $0142: [$05CF] pattern 7, track 3
pattern8Definition:
 db $00 ; $0144: pattern 8 state
 dw trackDef5 ; $0145: [$066A] pattern 8, track 1
 dw trackDef1 ; $0147: [$05CF] pattern 8, track 2
 dw trackDef1 ; $0149: [$05CF] pattern 8, track 3
pattern9Definition:
 db $00 ; $014B: pattern 9 state
 dw trackDef5 ; $014C: [$066A] pattern 9, track 1
 dw trackDef1 ; $014E: [$05CF] pattern 9, track 2
 dw trackDef1 ; $0150: [$05CF] pattern 9, track 3
pattern10Definition:
 db $00 ; $0152: pattern 10 state
 dw trackDef5 ; $0153: [$066A] pattern 10, track 1
 dw trackDef1 ; $0155: [$05CF] pattern 10, track 2
 dw trackDef1 ; $0157: [$05CF] pattern 10, track 3
pattern11Definition:
 db $00 ; $0159: pattern 11 state
 dw trackDef5 ; $015A: [$066A] pattern 11, track 1
 dw trackDef1 ; $015C: [$05CF] pattern 11, track 2
 dw trackDef1 ; $015E: [$05CF] pattern 11, track 3
pattern12Definition:
 db $00 ; $0160: pattern 12 state
 dw trackDef5 ; $0161: [$066A] pattern 12, track 1
 dw trackDef1 ; $0163: [$05CF] pattern 12, track 2
 dw trackDef1 ; $0165: [$05CF] pattern 12, track 3
pattern13Definition:
 db $00 ; $0167: pattern 13 state
 dw trackDef5 ; $0168: [$066A] pattern 13, track 1
 dw trackDef1 ; $016A: [$05CF] pattern 13, track 2
 dw trackDef1 ; $016C: [$05CF] pattern 13, track 3
pattern14Definition:
 db $00 ; $016E: pattern 14 state
 dw trackDef5 ; $016F: [$066A] pattern 14, track 1
 dw trackDef1 ; $0171: [$05CF] pattern 14, track 2
 dw trackDef1 ; $0173: [$05CF] pattern 14, track 3
pattern15Definition:
 db $00 ; $0175: pattern 15 state
 dw trackDef5 ; $0176: [$066A] pattern 15, track 1
 dw trackDef1 ; $0178: [$05CF] pattern 15, track 2
 dw trackDef1 ; $017A: [$05CF] pattern 15, track 3
pattern16Definition:
 db $00 ; $017C: pattern 16 state
 dw trackDef6 ; $017D: [$067B] pattern 16, track 1
 dw trackDef1 ; $017F: [$05CF] pattern 16, track 2
 dw trackDef1 ; $0181: [$05CF] pattern 16, track 3
pattern17Definition:
 db $00 ; $0183: pattern 17 state
 dw trackDef6 ; $0184: [$067B] pattern 17, track 1
 dw trackDef1 ; $0186: [$05CF] pattern 17, track 2
 dw trackDef1 ; $0188: [$05CF] pattern 17, track 3
pattern18Definition:
 db $00 ; $018A: pattern 18 state
 dw trackDef6 ; $018B: [$067B] pattern 18, track 1
 dw trackDef1 ; $018D: [$05CF] pattern 18, track 2
 dw trackDef1 ; $018F: [$05CF] pattern 18, track 3
pattern19Definition:
 db $00 ; $0191: pattern 19 state
 dw trackDef6 ; $0192: [$067B] pattern 19, track 1
 dw trackDef1 ; $0194: [$05CF] pattern 19, track 2
 dw trackDef1 ; $0196: [$05CF] pattern 19, track 3
pattern20Definition:
 db $00 ; $0198: pattern 20 state
 dw trackDef6 ; $0199: [$067B] pattern 20, track 1
 dw trackDef1 ; $019B: [$05CF] pattern 20, track 2
 dw trackDef1 ; $019D: [$05CF] pattern 20, track 3
pattern21Definition:
 db $00 ; $019F: pattern 21 state
 dw trackDef6 ; $01A0: [$067B] pattern 21, track 1
 dw trackDef1 ; $01A2: [$05CF] pattern 21, track 2
 dw trackDef1 ; $01A4: [$05CF] pattern 21, track 3
pattern22Definition:
 db $00 ; $01A6: pattern 22 state
 dw trackDef6 ; $01A7: [$067B] pattern 22, track 1
 dw trackDef1 ; $01A9: [$05CF] pattern 22, track 2
 dw trackDef1 ; $01AB: [$05CF] pattern 22, track 3
pattern23Definition:
 db $00 ; $01AD: pattern 23 state
 dw trackDef6 ; $01AE: [$067B] pattern 23, track 1
 dw trackDef1 ; $01B0: [$05CF] pattern 23, track 2
 dw trackDef1 ; $01B2: [$05CF] pattern 23, track 3
pattern24Definition:
 db $00 ; $01B4: pattern 24 state
 dw trackDef7 ; $01B5: [$0692] pattern 24, track 1
 dw trackDef1 ; $01B7: [$05CF] pattern 24, track 2
 dw trackDef1 ; $01B9: [$05CF] pattern 24, track 3
pattern25Definition:
 db $00 ; $01BB: pattern 25 state
 dw trackDef8 ; $01BC: [$06AA] pattern 25, track 1
 dw trackDef1 ; $01BE: [$05CF] pattern 25, track 2
 dw trackDef1 ; $01C0: [$05CF] pattern 25, track 3
pattern26Definition:
 db $00 ; $01C2: pattern 26 state
 dw trackDef7 ; $01C3: [$0692] pattern 26, track 1
 dw trackDef1 ; $01C5: [$05CF] pattern 26, track 2
 dw trackDef1 ; $01C7: [$05CF] pattern 26, track 3
pattern27Definition:
 db $00 ; $01C9: pattern 27 state
 dw trackDef8 ; $01CA: [$06AA] pattern 27, track 1
 dw trackDef1 ; $01CC: [$05CF] pattern 27, track 2
 dw trackDef1 ; $01CE: [$05CF] pattern 27, track 3
pattern28Definition:
 db $00 ; $01D0: pattern 28 state
 dw trackDef7 ; $01D1: [$0692] pattern 28, track 1
 dw trackDef1 ; $01D3: [$05CF] pattern 28, track 2
 dw trackDef1 ; $01D5: [$05CF] pattern 28, track 3
pattern29Definition:
 db $00 ; $01D7: pattern 29 state
 dw trackDef8 ; $01D8: [$06AA] pattern 29, track 1
 dw trackDef1 ; $01DA: [$05CF] pattern 29, track 2
 dw trackDef1 ; $01DC: [$05CF] pattern 29, track 3
pattern30Definition:
 db $00 ; $01DE: pattern 30 state
 dw trackDef7 ; $01DF: [$0692] pattern 30, track 1
 dw trackDef1 ; $01E1: [$05CF] pattern 30, track 2
 dw trackDef1 ; $01E3: [$05CF] pattern 30, track 3
pattern31Definition:
 db $00 ; $01E5: pattern 31 state
 dw trackDef8 ; $01E6: [$06AA] pattern 31, track 1
 dw trackDef1 ; $01E8: [$05CF] pattern 31, track 2
 dw trackDef1 ; $01EA: [$05CF] pattern 31, track 3
pattern32Definition:
 db $00 ; $01EC: pattern 32 state
 dw trackDef9 ; $01ED: [$06C1] pattern 32, track 1
 dw trackDef1 ; $01EF: [$05CF] pattern 32, track 2
 dw trackDef1 ; $01F1: [$05CF] pattern 32, track 3
pattern33Definition:
 db $00 ; $01F3: pattern 33 state
 dw trackDef10 ; $01F4: [$06DB] pattern 33, track 1
 dw trackDef1 ; $01F6: [$05CF] pattern 33, track 2
 dw trackDef1 ; $01F8: [$05CF] pattern 33, track 3
pattern34Definition:
 db $00 ; $01FA: pattern 34 state
 dw trackDef9 ; $01FB: [$06C1] pattern 34, track 1
 dw trackDef1 ; $01FD: [$05CF] pattern 34, track 2
 dw trackDef1 ; $01FF: [$05CF] pattern 34, track 3
pattern35Definition:
 db $00 ; $0201: pattern 35 state
 dw trackDef11 ; $0202: [$06F3] pattern 35, track 1
 dw trackDef1 ; $0204: [$05CF] pattern 35, track 2
 dw trackDef1 ; $0206: [$05CF] pattern 35, track 3
pattern36Definition:
 db $00 ; $0208: pattern 36 state
 dw trackDef9 ; $0209: [$06C1] pattern 36, track 1
 dw trackDef1 ; $020B: [$05CF] pattern 36, track 2
 dw trackDef1 ; $020D: [$05CF] pattern 36, track 3
pattern37Definition:
 db $00 ; $020F: pattern 37 state
 dw trackDef10 ; $0210: [$06DB] pattern 37, track 1
 dw trackDef1 ; $0212: [$05CF] pattern 37, track 2
 dw trackDef1 ; $0214: [$05CF] pattern 37, track 3
pattern38Definition:
 db $00 ; $0216: pattern 38 state
 dw trackDef9 ; $0217: [$06C1] pattern 38, track 1
 dw trackDef1 ; $0219: [$05CF] pattern 38, track 2
 dw trackDef1 ; $021B: [$05CF] pattern 38, track 3
pattern39Definition:
 db $00 ; $021D: pattern 39 state
 dw trackDef12 ; $021E: [$070D] pattern 39, track 1
 dw trackDef1 ; $0220: [$05CF] pattern 39, track 2
 dw trackDef1 ; $0222: [$05CF] pattern 39, track 3
pattern40Definition:
 db $00 ; $0224: pattern 40 state
 dw trackDef9 ; $0225: [$06C1] pattern 40, track 1
 dw trackDef1 ; $0227: [$05CF] pattern 40, track 2
 dw trackDef1 ; $0229: [$05CF] pattern 40, track 3
pattern41Definition:
 db $00 ; $022B: pattern 41 state
 dw trackDef10 ; $022C: [$06DB] pattern 41, track 1
 dw trackDef1 ; $022E: [$05CF] pattern 41, track 2
 dw trackDef1 ; $0230: [$05CF] pattern 41, track 3
pattern42Definition:
 db $00 ; $0232: pattern 42 state
 dw trackDef9 ; $0233: [$06C1] pattern 42, track 1
 dw trackDef1 ; $0235: [$05CF] pattern 42, track 2
 dw trackDef1 ; $0237: [$05CF] pattern 42, track 3
pattern43Definition:
 db $00 ; $0239: pattern 43 state
 dw trackDef11 ; $023A: [$06F3] pattern 43, track 1
 dw trackDef1 ; $023C: [$05CF] pattern 43, track 2
 dw trackDef1 ; $023E: [$05CF] pattern 43, track 3
pattern44Definition:
 db $00 ; $0240: pattern 44 state
 dw trackDef9 ; $0241: [$06C1] pattern 44, track 1
 dw trackDef1 ; $0243: [$05CF] pattern 44, track 2
 dw trackDef1 ; $0245: [$05CF] pattern 44, track 3
pattern45Definition:
 db $00 ; $0247: pattern 45 state
 dw trackDef10 ; $0248: [$06DB] pattern 45, track 1
 dw trackDef1 ; $024A: [$05CF] pattern 45, track 2
 dw trackDef1 ; $024C: [$05CF] pattern 45, track 3
pattern46Definition:
 db $00 ; $024E: pattern 46 state
 dw trackDef9 ; $024F: [$06C1] pattern 46, track 1
 dw trackDef1 ; $0251: [$05CF] pattern 46, track 2
 dw trackDef1 ; $0253: [$05CF] pattern 46, track 3
pattern47Definition:
 db $00 ; $0255: pattern 47 state
 dw trackDef12 ; $0256: [$070D] pattern 47, track 1
 dw trackDef1 ; $0258: [$05CF] pattern 47, track 2
 dw trackDef1 ; $025A: [$05CF] pattern 47, track 3
pattern48Definition:
 db $10 ; $025C: pattern 48 state
 dw trackDef0 ; $025D: [$05F2] pattern 48, track 1
 dw trackDef1 ; $025F: [$05CF] pattern 48, track 2
 dw trackDef1 ; $0261: [$05CF] pattern 48, track 3
 db $20 ; $0263: new height
pattern49Definition:
 db $10 ; $0264: pattern 49 state
 dw trackDef13 ; $0265: [$078A] pattern 49, track 1
 dw trackDef1 ; $0267: [$05CF] pattern 49, track 2
 dw trackDef1 ; $0269: [$05CF] pattern 49, track 3
 db $06 ; $026B: new height
pattern50Definition:
 db $10 ; $026C: pattern 50 state
 dw trackDef14 ; $026D: [$07F8] pattern 50, track 1
 dw trackDef1 ; $026F: [$05CF] pattern 50, track 2
 dw trackDef1 ; $0271: [$05CF] pattern 50, track 3
 db $14 ; $0273: new height
pattern51Definition:
 db $10 ; $0274: pattern 51 state
 dw trackDef15 ; $0275: [$0836] pattern 51, track 1
 dw trackDef1 ; $0277: [$05CF] pattern 51, track 2
 dw trackDef1 ; $0279: [$05CF] pattern 51, track 3
 db $0C ; $027B: new height
pattern52Definition:
 db $10 ; $027C: pattern 52 state
 dw trackDef14 ; $027D: [$07F8] pattern 52, track 1
 dw trackDef1 ; $027F: [$05CF] pattern 52, track 2
 dw trackDef1 ; $0281: [$05CF] pattern 52, track 3
 db $14 ; $0283: new height
pattern53Definition:
 db $10 ; $0284: pattern 53 state
 dw trackDef16 ; $0285: [$085B] pattern 53, track 1
 dw trackDef1 ; $0287: [$05CF] pattern 53, track 2
 dw trackDef1 ; $0289: [$05CF] pattern 53, track 3
 db $0C ; $028B: new height
pattern54Definition:
 db $10 ; $028C: pattern 54 state
 dw trackDef14 ; $028D: [$07F8] pattern 54, track 1
 dw trackDef1 ; $028F: [$05CF] pattern 54, track 2
 dw trackDef1 ; $0291: [$05CF] pattern 54, track 3
 db $14 ; $0293: new height
pattern55Definition:
 db $10 ; $0294: pattern 55 state
 dw trackDef15 ; $0295: [$0836] pattern 55, track 1
 dw trackDef1 ; $0297: [$05CF] pattern 55, track 2
 dw trackDef1 ; $0299: [$05CF] pattern 55, track 3
 db $0C ; $029B: new height
pattern56Definition:
 db $10 ; $029C: pattern 56 state
 dw trackDef14 ; $029D: [$07F8] pattern 56, track 1
 dw trackDef1 ; $029F: [$05CF] pattern 56, track 2
 dw trackDef1 ; $02A1: [$05CF] pattern 56, track 3
 db $14 ; $02A3: new height
pattern57Definition:
 db $10 ; $02A4: pattern 57 state
 dw trackDef16 ; $02A5: [$085B] pattern 57, track 1
 dw trackDef1 ; $02A7: [$05CF] pattern 57, track 2
 dw trackDef1 ; $02A9: [$05CF] pattern 57, track 3
 db $0C ; $02AB: new height
pattern58Definition:
 db $10 ; $02AC: pattern 58 state
 dw trackDef17 ; $02AD: [$0727] pattern 58, track 1
 dw trackDef1 ; $02AF: [$05CF] pattern 58, track 2
 dw trackDef1 ; $02B1: [$05CF] pattern 58, track 3
 db $18 ; $02B3: new height
pattern59Definition:
 db $10 ; $02B4: pattern 59 state
 dw trackDef18 ; $02B5: [$0770] pattern 59, track 1
 dw trackDef1 ; $02B7: [$05CF] pattern 59, track 2
 dw trackDef1 ; $02B9: [$05CF] pattern 59, track 3
 db $08 ; $02BB: new height
pattern60Definition:
 db $10 ; $02BC: pattern 60 state
 dw trackDef17 ; $02BD: [$0727] pattern 60, track 1
 dw trackDef1 ; $02BF: [$05CF] pattern 60, track 2
 dw trackDef1 ; $02C1: [$05CF] pattern 60, track 3
 db $18 ; $02C3: new height
pattern61Definition:
 db $10 ; $02C4: pattern 61 state
 dw trackDef19 ; $02C5: [$079A] pattern 61, track 1
 dw trackDef1 ; $02C7: [$05CF] pattern 61, track 2
 dw trackDef1 ; $02C9: [$05CF] pattern 61, track 3
 db $08 ; $02CB: new height
pattern62Definition:
 db $10 ; $02CC: pattern 62 state
 dw trackDef17 ; $02CD: [$0727] pattern 62, track 1
 dw trackDef1 ; $02CF: [$05CF] pattern 62, track 2
 dw trackDef1 ; $02D1: [$05CF] pattern 62, track 3
 db $18 ; $02D3: new height
pattern63Definition:
 db $10 ; $02D4: pattern 63 state
 dw trackDef18 ; $02D5: [$0770] pattern 63, track 1
 dw trackDef1 ; $02D7: [$05CF] pattern 63, track 2
 dw trackDef1 ; $02D9: [$05CF] pattern 63, track 3
 db $08 ; $02DB: new height
pattern64Definition:
 db $10 ; $02DC: pattern 64 state
 dw trackDef17 ; $02DD: [$0727] pattern 64, track 1
 dw trackDef1 ; $02DF: [$05CF] pattern 64, track 2
 dw trackDef1 ; $02E1: [$05CF] pattern 64, track 3
 db $18 ; $02E3: new height
pattern65Definition:
 db $10 ; $02E4: pattern 65 state
 dw trackDef19 ; $02E5: [$079A] pattern 65, track 1
 dw trackDef1 ; $02E7: [$05CF] pattern 65, track 2
 dw trackDef1 ; $02E9: [$05CF] pattern 65, track 3
 db $08 ; $02EB: new height
pattern66Definition:
 db $00 ; $02EC: pattern 66 state
 dw trackDef20 ; $02ED: [$07B4] pattern 66, track 1
 dw trackDef1 ; $02EF: [$05CF] pattern 66, track 2
 dw trackDef1 ; $02F1: [$05CF] pattern 66, track 3
pattern67Definition:
 db $00 ; $02F3: pattern 67 state
 dw trackDef21 ; $02F4: [$07CD] pattern 67, track 1
 dw trackDef1 ; $02F6: [$05CF] pattern 67, track 2
 dw trackDef1 ; $02F8: [$05CF] pattern 67, track 3
pattern68Definition:
 db $00 ; $02FA: pattern 68 state
 dw trackDef20 ; $02FB: [$07B4] pattern 68, track 1
 dw trackDef1 ; $02FD: [$05CF] pattern 68, track 2
 dw trackDef1 ; $02FF: [$05CF] pattern 68, track 3
pattern69Definition:
 db $00 ; $0301: pattern 69 state
 dw trackDef22 ; $0302: [$07E2] pattern 69, track 1
 dw trackDef1 ; $0304: [$05CF] pattern 69, track 2
 dw trackDef1 ; $0306: [$05CF] pattern 69, track 3
pattern70Definition:
 db $00 ; $0308: pattern 70 state
 dw trackDef20 ; $0309: [$07B4] pattern 70, track 1
 dw trackDef1 ; $030B: [$05CF] pattern 70, track 2
 dw trackDef1 ; $030D: [$05CF] pattern 70, track 3
pattern71Definition:
 db $00 ; $030F: pattern 71 state
 dw trackDef21 ; $0310: [$07CD] pattern 71, track 1
 dw trackDef1 ; $0312: [$05CF] pattern 71, track 2
 dw trackDef1 ; $0314: [$05CF] pattern 71, track 3
pattern72Definition:
 db $00 ; $0316: pattern 72 state
 dw trackDef20 ; $0317: [$07B4] pattern 72, track 1
 dw trackDef1 ; $0319: [$05CF] pattern 72, track 2
 dw trackDef1 ; $031B: [$05CF] pattern 72, track 3
pattern73Definition:
 db $00 ; $031D: pattern 73 state
 dw trackDef22 ; $031E: [$07E2] pattern 73, track 1
 dw trackDef1 ; $0320: [$05CF] pattern 73, track 2
 dw trackDef1 ; $0322: [$05CF] pattern 73, track 3
pattern74Definition:
 db $00 ; $0324: pattern 74 state
 dw trackDef20 ; $0325: [$07B4] pattern 74, track 1
 dw trackDef1 ; $0327: [$05CF] pattern 74, track 2
 dw trackDef1 ; $0329: [$05CF] pattern 74, track 3
pattern75Definition:
 db $00 ; $032B: pattern 75 state
 dw trackDef21 ; $032C: [$07CD] pattern 75, track 1
 dw trackDef1 ; $032E: [$05CF] pattern 75, track 2
 dw trackDef1 ; $0330: [$05CF] pattern 75, track 3
pattern76Definition:
 db $00 ; $0332: pattern 76 state
 dw trackDef20 ; $0333: [$07B4] pattern 76, track 1
 dw trackDef1 ; $0335: [$05CF] pattern 76, track 2
 dw trackDef1 ; $0337: [$05CF] pattern 76, track 3
pattern77Definition:
 db $00 ; $0339: pattern 77 state
 dw trackDef22 ; $033A: [$07E2] pattern 77, track 1
 dw trackDef1 ; $033C: [$05CF] pattern 77, track 2
 dw trackDef1 ; $033E: [$05CF] pattern 77, track 3
pattern78Definition:
 db $00 ; $0340: pattern 78 state
 dw trackDef20 ; $0341: [$07B4] pattern 78, track 1
 dw trackDef1 ; $0343: [$05CF] pattern 78, track 2
 dw trackDef1 ; $0345: [$05CF] pattern 78, track 3
pattern79Definition:
 db $00 ; $0347: pattern 79 state
 dw trackDef21 ; $0348: [$07CD] pattern 79, track 1
 dw trackDef1 ; $034A: [$05CF] pattern 79, track 2
 dw trackDef1 ; $034C: [$05CF] pattern 79, track 3
pattern80Definition:
 db $00 ; $034E: pattern 80 state
 dw trackDef20 ; $034F: [$07B4] pattern 80, track 1
 dw trackDef1 ; $0351: [$05CF] pattern 80, track 2
 dw trackDef1 ; $0353: [$05CF] pattern 80, track 3
pattern81Definition:
 db $00 ; $0355: pattern 81 state
 dw trackDef22 ; $0356: [$07E2] pattern 81, track 1
 dw trackDef1 ; $0358: [$05CF] pattern 81, track 2
 dw trackDef1 ; $035A: [$05CF] pattern 81, track 3
pattern82Definition:
 db $10 ; $035C: pattern 82 state
 dw trackDef23 ; $035D: [$0880] pattern 82, track 1
 dw trackDef1 ; $035F: [$05CF] pattern 82, track 2
 dw trackDef1 ; $0361: [$05CF] pattern 82, track 3
 db $02 ; $0363: new height
pattern83Definition:
 db $10 ; $0364: pattern 83 state
 dw trackDef24 ; $0365: [$0919] pattern 83, track 1
 dw trackDef1 ; $0367: [$05CF] pattern 83, track 2
 dw trackDef1 ; $0369: [$05CF] pattern 83, track 3
 db $04 ; $036B: new height
pattern84Definition:
 db $00 ; $036C: pattern 84 state
 dw trackDef24 ; $036D: [$0919] pattern 84, track 1
 dw trackDef1 ; $036F: [$05CF] pattern 84, track 2
 dw trackDef1 ; $0371: [$05CF] pattern 84, track 3
pattern85Definition:
 db $00 ; $0373: pattern 85 state
 dw trackDef24 ; $0374: [$0919] pattern 85, track 1
 dw trackDef1 ; $0376: [$05CF] pattern 85, track 2
 dw trackDef1 ; $0378: [$05CF] pattern 85, track 3
pattern86Definition:
 db $00 ; $037A: pattern 86 state
 dw trackDef24 ; $037B: [$0919] pattern 86, track 1
 dw trackDef1 ; $037D: [$05CF] pattern 86, track 2
 dw trackDef1 ; $037F: [$05CF] pattern 86, track 3
pattern87Definition:
 db $00 ; $0381: pattern 87 state
 dw trackDef24 ; $0382: [$0919] pattern 87, track 1
 dw trackDef1 ; $0384: [$05CF] pattern 87, track 2
 dw trackDef1 ; $0386: [$05CF] pattern 87, track 3
pattern88Definition:
 db $00 ; $0388: pattern 88 state
 dw trackDef24 ; $0389: [$0919] pattern 88, track 1
 dw trackDef1 ; $038B: [$05CF] pattern 88, track 2
 dw trackDef1 ; $038D: [$05CF] pattern 88, track 3
pattern89Definition:
 db $00 ; $038F: pattern 89 state
 dw trackDef24 ; $0390: [$0919] pattern 89, track 1
 dw trackDef1 ; $0392: [$05CF] pattern 89, track 2
 dw trackDef1 ; $0394: [$05CF] pattern 89, track 3
pattern90Definition:
 db $00 ; $0396: pattern 90 state
 dw trackDef24 ; $0397: [$0919] pattern 90, track 1
 dw trackDef1 ; $0399: [$05CF] pattern 90, track 2
 dw trackDef1 ; $039B: [$05CF] pattern 90, track 3
pattern91Definition:
 db $00 ; $039D: pattern 91 state
 dw trackDef24 ; $039E: [$0919] pattern 91, track 1
 dw trackDef1 ; $03A0: [$05CF] pattern 91, track 2
 dw trackDef1 ; $03A2: [$05CF] pattern 91, track 3
pattern92Definition:
 db $00 ; $03A4: pattern 92 state
 dw trackDef24 ; $03A5: [$0919] pattern 92, track 1
 dw trackDef1 ; $03A7: [$05CF] pattern 92, track 2
 dw trackDef1 ; $03A9: [$05CF] pattern 92, track 3
pattern93Definition:
 db $00 ; $03AB: pattern 93 state
 dw trackDef24 ; $03AC: [$0919] pattern 93, track 1
 dw trackDef1 ; $03AE: [$05CF] pattern 93, track 2
 dw trackDef1 ; $03B0: [$05CF] pattern 93, track 3
pattern94Definition:
 db $00 ; $03B2: pattern 94 state
 dw trackDef24 ; $03B3: [$0919] pattern 94, track 1
 dw trackDef1 ; $03B5: [$05CF] pattern 94, track 2
 dw trackDef1 ; $03B7: [$05CF] pattern 94, track 3
pattern95Definition:
 db $00 ; $03B9: pattern 95 state
 dw trackDef24 ; $03BA: [$0919] pattern 95, track 1
 dw trackDef1 ; $03BC: [$05CF] pattern 95, track 2
 dw trackDef1 ; $03BE: [$05CF] pattern 95, track 3
pattern96Definition:
 db $00 ; $03C0: pattern 96 state
 dw trackDef24 ; $03C1: [$0919] pattern 96, track 1
 dw trackDef1 ; $03C3: [$05CF] pattern 96, track 2
 dw trackDef1 ; $03C5: [$05CF] pattern 96, track 3
pattern97Definition:
 db $00 ; $03C7: pattern 97 state
 dw trackDef24 ; $03C8: [$0919] pattern 97, track 1
 dw trackDef1 ; $03CA: [$05CF] pattern 97, track 2
 dw trackDef1 ; $03CC: [$05CF] pattern 97, track 3
pattern98Definition:
 db $10 ; $03CE: pattern 98 state
 dw trackDef24 ; $03CF: [$0919] pattern 98, track 1
 dw trackDef1 ; $03D1: [$05CF] pattern 98, track 2
 dw trackDef1 ; $03D3: [$05CF] pattern 98, track 3
 db $02 ; $03D5: new height
pattern99Definition:
 db $00 ; $03D6: pattern 99 state
 dw trackDef25 ; $03D7: [$0895] pattern 99, track 1
 dw trackDef1 ; $03D9: [$05CF] pattern 99, track 2
 dw trackDef1 ; $03DB: [$05CF] pattern 99, track 3
pattern100Definition:
 db $10 ; $03DD: pattern 100 state
 dw trackDef26 ; $03DE: [$0887] pattern 100, track 1
 dw trackDef1 ; $03E0: [$05CF] pattern 100, track 2
 dw trackDef1 ; $03E2: [$05CF] pattern 100, track 3
 db $04 ; $03E4: new height
pattern101Definition:
 db $10 ; $03E5: pattern 101 state
 dw trackDef26 ; $03E6: [$0887] pattern 101, track 1
 dw trackDef1 ; $03E8: [$05CF] pattern 101, track 2
 dw trackDef1 ; $03EA: [$05CF] pattern 101, track 3
 db $02 ; $03EC: new height
pattern102Definition:
 db $00 ; $03ED: pattern 102 state
 dw trackDef27 ; $03EE: [$089C] pattern 102, track 1
 dw trackDef1 ; $03F0: [$05CF] pattern 102, track 2
 dw trackDef1 ; $03F2: [$05CF] pattern 102, track 3
pattern103Definition:
 db $10 ; $03F4: pattern 103 state
 dw trackDef26 ; $03F5: [$0887] pattern 103, track 1
 dw trackDef1 ; $03F7: [$05CF] pattern 103, track 2
 dw trackDef1 ; $03F9: [$05CF] pattern 103, track 3
 db $04 ; $03FB: new height
pattern104Definition:
 db $10 ; $03FC: pattern 104 state
 dw trackDef26 ; $03FD: [$0887] pattern 104, track 1
 dw trackDef1 ; $03FF: [$05CF] pattern 104, track 2
 dw trackDef1 ; $0401: [$05CF] pattern 104, track 3
 db $02 ; $0403: new height
pattern105Definition:
 db $00 ; $0404: pattern 105 state
 dw trackDef28 ; $0405: [$08A3] pattern 105, track 1
 dw trackDef1 ; $0407: [$05CF] pattern 105, track 2
 dw trackDef1 ; $0409: [$05CF] pattern 105, track 3
pattern106Definition:
 db $10 ; $040B: pattern 106 state
 dw trackDef26 ; $040C: [$0887] pattern 106, track 1
 dw trackDef1 ; $040E: [$05CF] pattern 106, track 2
 dw trackDef1 ; $0410: [$05CF] pattern 106, track 3
 db $04 ; $0412: new height
pattern107Definition:
 db $00 ; $0413: pattern 107 state
 dw trackDef26 ; $0414: [$0887] pattern 107, track 1
 dw trackDef1 ; $0416: [$05CF] pattern 107, track 2
 dw trackDef1 ; $0418: [$05CF] pattern 107, track 3
pattern108Definition:
 db $00 ; $041A: pattern 108 state
 dw trackDef26 ; $041B: [$0887] pattern 108, track 1
 dw trackDef1 ; $041D: [$05CF] pattern 108, track 2
 dw trackDef1 ; $041F: [$05CF] pattern 108, track 3
pattern109Definition:
 db $10 ; $0421: pattern 109 state
 dw trackDef26 ; $0422: [$0887] pattern 109, track 1
 dw trackDef1 ; $0424: [$05CF] pattern 109, track 2
 dw trackDef1 ; $0426: [$05CF] pattern 109, track 3
 db $02 ; $0428: new height
pattern110Definition:
 db $00 ; $0429: pattern 110 state
 dw trackDef25 ; $042A: [$0895] pattern 110, track 1
 dw trackDef1 ; $042C: [$05CF] pattern 110, track 2
 dw trackDef1 ; $042E: [$05CF] pattern 110, track 3
pattern111Definition:
 db $10 ; $0430: pattern 111 state
 dw trackDef26 ; $0431: [$0887] pattern 111, track 1
 dw trackDef1 ; $0433: [$05CF] pattern 111, track 2
 dw trackDef1 ; $0435: [$05CF] pattern 111, track 3
 db $04 ; $0437: new height
pattern112Definition:
 db $10 ; $0438: pattern 112 state
 dw trackDef26 ; $0439: [$0887] pattern 112, track 1
 dw trackDef1 ; $043B: [$05CF] pattern 112, track 2
 dw trackDef1 ; $043D: [$05CF] pattern 112, track 3
 db $02 ; $043F: new height
pattern113Definition:
 db $00 ; $0440: pattern 113 state
 dw trackDef27 ; $0441: [$089C] pattern 113, track 1
 dw trackDef1 ; $0443: [$05CF] pattern 113, track 2
 dw trackDef1 ; $0445: [$05CF] pattern 113, track 3
pattern114Definition:
 db $10 ; $0447: pattern 114 state
 dw trackDef26 ; $0448: [$0887] pattern 114, track 1
 dw trackDef1 ; $044A: [$05CF] pattern 114, track 2
 dw trackDef1 ; $044C: [$05CF] pattern 114, track 3
 db $04 ; $044E: new height
pattern115Definition:
 db $10 ; $044F: pattern 115 state
 dw trackDef26 ; $0450: [$0887] pattern 115, track 1
 dw trackDef1 ; $0452: [$05CF] pattern 115, track 2
 dw trackDef1 ; $0454: [$05CF] pattern 115, track 3
 db $02 ; $0456: new height
pattern116Definition:
 db $00 ; $0457: pattern 116 state
 dw trackDef28 ; $0458: [$08A3] pattern 116, track 1
 dw trackDef1 ; $045A: [$05CF] pattern 116, track 2
 dw trackDef1 ; $045C: [$05CF] pattern 116, track 3
pattern117Definition:
 db $10 ; $045E: pattern 117 state
 dw trackDef26 ; $045F: [$0887] pattern 117, track 1
 dw trackDef1 ; $0461: [$05CF] pattern 117, track 2
 dw trackDef1 ; $0463: [$05CF] pattern 117, track 3
 db $04 ; $0465: new height
pattern118Definition:
 db $00 ; $0466: pattern 118 state
 dw trackDef26 ; $0467: [$0887] pattern 118, track 1
 dw trackDef1 ; $0469: [$05CF] pattern 118, track 2
 dw trackDef1 ; $046B: [$05CF] pattern 118, track 3
pattern119Definition:
 db $00 ; $046D: pattern 119 state
 dw trackDef26 ; $046E: [$0887] pattern 119, track 1
 dw trackDef1 ; $0470: [$05CF] pattern 119, track 2
 dw trackDef1 ; $0472: [$05CF] pattern 119, track 3
pattern120Definition:
 db $10 ; $0474: pattern 120 state
 dw trackDef26 ; $0475: [$0887] pattern 120, track 1
 dw trackDef1 ; $0477: [$05CF] pattern 120, track 2
 dw trackDef1 ; $0479: [$05CF] pattern 120, track 3
 db $02 ; $047B: new height
pattern121Definition:
 db $00 ; $047C: pattern 121 state
 dw trackDef25 ; $047D: [$0895] pattern 121, track 1
 dw trackDef1 ; $047F: [$05CF] pattern 121, track 2
 dw trackDef1 ; $0481: [$05CF] pattern 121, track 3
pattern122Definition:
 db $00 ; $0483: pattern 122 state
 dw trackDef26 ; $0484: [$0887] pattern 122, track 1
 dw trackDef1 ; $0486: [$05CF] pattern 122, track 2
 dw trackDef1 ; $0488: [$05CF] pattern 122, track 3
pattern123Definition:
 db $10 ; $048A: pattern 123 state
 dw trackDef29 ; $048B: [$08AA] pattern 123, track 1
 dw trackDef1 ; $048D: [$05CF] pattern 123, track 2
 dw trackDef1 ; $048F: [$05CF] pattern 123, track 3
 db $04 ; $0491: new height
pattern124Definition:
 db $10 ; $0492: pattern 124 state
 dw trackDef27 ; $0493: [$089C] pattern 124, track 1
 dw trackDef1 ; $0495: [$05CF] pattern 124, track 2
 dw trackDef1 ; $0497: [$05CF] pattern 124, track 3
 db $02 ; $0499: new height
pattern125Definition:
 db $00 ; $049A: pattern 125 state
 dw trackDef26 ; $049B: [$0887] pattern 125, track 1
 dw trackDef1 ; $049D: [$05CF] pattern 125, track 2
 dw trackDef1 ; $049F: [$05CF] pattern 125, track 3
pattern126Definition:
 db $00 ; $04A1: pattern 126 state
 dw trackDef26 ; $04A2: [$0887] pattern 126, track 1
 dw trackDef1 ; $04A4: [$05CF] pattern 126, track 2
 dw trackDef1 ; $04A6: [$05CF] pattern 126, track 3
pattern127Definition:
 db $00 ; $04A8: pattern 127 state
 dw trackDef26 ; $04A9: [$0887] pattern 127, track 1
 dw trackDef1 ; $04AB: [$05CF] pattern 127, track 2
 dw trackDef1 ; $04AD: [$05CF] pattern 127, track 3
pattern128Definition:
 db $00 ; $04AF: pattern 128 state
 dw trackDef28 ; $04B0: [$08A3] pattern 128, track 1
 dw trackDef1 ; $04B2: [$05CF] pattern 128, track 2
 dw trackDef1 ; $04B4: [$05CF] pattern 128, track 3
pattern129Definition:
 db $00 ; $04B6: pattern 129 state
 dw trackDef26 ; $04B7: [$0887] pattern 129, track 1
 dw trackDef1 ; $04B9: [$05CF] pattern 129, track 2
 dw trackDef1 ; $04BB: [$05CF] pattern 129, track 3
pattern130Definition:
 db $00 ; $04BD: pattern 130 state
 dw trackDef26 ; $04BE: [$0887] pattern 130, track 1
 dw trackDef1 ; $04C0: [$05CF] pattern 130, track 2
 dw trackDef1 ; $04C2: [$05CF] pattern 130, track 3
pattern131Definition:
 db $00 ; $04C4: pattern 131 state
 dw trackDef26 ; $04C5: [$0887] pattern 131, track 1
 dw trackDef1 ; $04C7: [$05CF] pattern 131, track 2
 dw trackDef1 ; $04C9: [$05CF] pattern 131, track 3
pattern132Definition:
 db $00 ; $04CB: pattern 132 state
 dw trackDef26 ; $04CC: [$0887] pattern 132, track 1
 dw trackDef1 ; $04CE: [$05CF] pattern 132, track 2
 dw trackDef1 ; $04D0: [$05CF] pattern 132, track 3
pattern133Definition:
 db $10 ; $04D2: pattern 133 state
 dw trackDef26 ; $04D3: [$0887] pattern 133, track 1
 dw trackDef1 ; $04D5: [$05CF] pattern 133, track 2
 dw trackDef1 ; $04D7: [$05CF] pattern 133, track 3
 db $01 ; $04D9: new height
pattern134Definition:
 db $00 ; $04DA: pattern 134 state
 dw trackDef26 ; $04DB: [$0887] pattern 134, track 1
 dw trackDef1 ; $04DD: [$05CF] pattern 134, track 2
 dw trackDef1 ; $04DF: [$05CF] pattern 134, track 3
pattern135Definition:
 db $00 ; $04E1: pattern 135 state
 dw trackDef26 ; $04E2: [$0887] pattern 135, track 1
 dw trackDef1 ; $04E4: [$05CF] pattern 135, track 2
 dw trackDef1 ; $04E6: [$05CF] pattern 135, track 3
pattern136Definition:
 db $00 ; $04E8: pattern 136 state
 dw trackDef26 ; $04E9: [$0887] pattern 136, track 1
 dw trackDef1 ; $04EB: [$05CF] pattern 136, track 2
 dw trackDef1 ; $04ED: [$05CF] pattern 136, track 3
pattern137Definition:
 db $00 ; $04EF: pattern 137 state
 dw trackDef26 ; $04F0: [$0887] pattern 137, track 1
 dw trackDef1 ; $04F2: [$05CF] pattern 137, track 2
 dw trackDef1 ; $04F4: [$05CF] pattern 137, track 3
pattern138Definition:
 db $00 ; $04F6: pattern 138 state
 dw trackDef1 ; $04F7: [$05CF] pattern 138, track 1
 dw trackDef1 ; $04F9: [$05CF] pattern 138, track 2
 dw trackDef1 ; $04FB: [$05CF] pattern 138, track 3
pattern139Definition:
 db $10 ; $04FD: pattern 139 state
 dw trackDef25 ; $04FE: [$0895] pattern 139, track 1
 dw trackDef1 ; $0500: [$05CF] pattern 139, track 2
 dw trackDef1 ; $0502: [$05CF] pattern 139, track 3
 db $02 ; $0504: new height
pattern140Definition:
 db $00 ; $0505: pattern 140 state
 dw trackDef26 ; $0506: [$0887] pattern 140, track 1
 dw trackDef1 ; $0508: [$05CF] pattern 140, track 2
 dw trackDef1 ; $050A: [$05CF] pattern 140, track 3
pattern141Definition:
 db $00 ; $050C: pattern 141 state
 dw trackDef26 ; $050D: [$0887] pattern 141, track 1
 dw trackDef1 ; $050F: [$05CF] pattern 141, track 2
 dw trackDef1 ; $0511: [$05CF] pattern 141, track 3
pattern142Definition:
 db $00 ; $0513: pattern 142 state
 dw trackDef26 ; $0514: [$0887] pattern 142, track 1
 dw trackDef1 ; $0516: [$05CF] pattern 142, track 2
 dw trackDef1 ; $0518: [$05CF] pattern 142, track 3
pattern143Definition:
 db $00 ; $051A: pattern 143 state
 dw trackDef27 ; $051B: [$089C] pattern 143, track 1
 dw trackDef1 ; $051D: [$05CF] pattern 143, track 2
 dw trackDef1 ; $051F: [$05CF] pattern 143, track 3
pattern144Definition:
 db $00 ; $0521: pattern 144 state
 dw trackDef26 ; $0522: [$0887] pattern 144, track 1
 dw trackDef1 ; $0524: [$05CF] pattern 144, track 2
 dw trackDef1 ; $0526: [$05CF] pattern 144, track 3
pattern145Definition:
 db $00 ; $0528: pattern 145 state
 dw trackDef26 ; $0529: [$0887] pattern 145, track 1
 dw trackDef1 ; $052B: [$05CF] pattern 145, track 2
 dw trackDef1 ; $052D: [$05CF] pattern 145, track 3
pattern146Definition:
 db $00 ; $052F: pattern 146 state
 dw trackDef26 ; $0530: [$0887] pattern 146, track 1
 dw trackDef1 ; $0532: [$05CF] pattern 146, track 2
 dw trackDef1 ; $0534: [$05CF] pattern 146, track 3
pattern147Definition:
 db $00 ; $0536: pattern 147 state
 dw trackDef28 ; $0537: [$08A3] pattern 147, track 1
 dw trackDef1 ; $0539: [$05CF] pattern 147, track 2
 dw trackDef1 ; $053B: [$05CF] pattern 147, track 3
pattern148Definition:
 db $00 ; $053D: pattern 148 state
 dw trackDef26 ; $053E: [$0887] pattern 148, track 1
 dw trackDef1 ; $0540: [$05CF] pattern 148, track 2
 dw trackDef1 ; $0542: [$05CF] pattern 148, track 3
pattern149Definition:
 db $00 ; $0544: pattern 149 state
 dw trackDef26 ; $0545: [$0887] pattern 149, track 1
 dw trackDef1 ; $0547: [$05CF] pattern 149, track 2
 dw trackDef1 ; $0549: [$05CF] pattern 149, track 3
pattern150Definition:
 db $00 ; $054B: pattern 150 state
 dw trackDef26 ; $054C: [$0887] pattern 150, track 1
 dw trackDef1 ; $054E: [$05CF] pattern 150, track 2
 dw trackDef1 ; $0550: [$05CF] pattern 150, track 3
pattern151Definition:
 db $10 ; $0552: pattern 151 state
 dw trackDef26 ; $0553: [$0887] pattern 151, track 1
 dw trackDef1 ; $0555: [$05CF] pattern 151, track 2
 dw trackDef1 ; $0557: [$05CF] pattern 151, track 3
 db $08 ; $0559: new height
pattern152Definition:
 db $00 ; $055A: pattern 152 state
 dw trackDef30 ; $055B: [$08B6] pattern 152, track 1
 dw trackDef1 ; $055D: [$05CF] pattern 152, track 2
 dw trackDef1 ; $055F: [$05CF] pattern 152, track 3
pattern153Definition:
 db $00 ; $0561: pattern 153 state
 dw trackDef31 ; $0562: [$08CE] pattern 153, track 1
 dw trackDef1 ; $0564: [$05CF] pattern 153, track 2
 dw trackDef1 ; $0566: [$05CF] pattern 153, track 3
pattern154Definition:
 db $00 ; $0568: pattern 154 state
 dw trackDef32 ; $0569: [$08E6] pattern 154, track 1
 dw trackDef1 ; $056B: [$05CF] pattern 154, track 2
 dw trackDef1 ; $056D: [$05CF] pattern 154, track 3
pattern155Definition:
 db $00 ; $056F: pattern 155 state
 dw trackDef32 ; $0570: [$08E6] pattern 155, track 1
 dw trackDef1 ; $0572: [$05CF] pattern 155, track 2
 dw trackDef1 ; $0574: [$05CF] pattern 155, track 3
pattern156Definition:
 db $00 ; $0576: pattern 156 state
 dw trackDef30 ; $0577: [$08B6] pattern 156, track 1
 dw trackDef1 ; $0579: [$05CF] pattern 156, track 2
 dw trackDef1 ; $057B: [$05CF] pattern 156, track 3
pattern157Definition:
 db $00 ; $057D: pattern 157 state
 dw trackDef31 ; $057E: [$08CE] pattern 157, track 1
 dw trackDef1 ; $0580: [$05CF] pattern 157, track 2
 dw trackDef1 ; $0582: [$05CF] pattern 157, track 3
pattern158Definition:
 db $00 ; $0584: pattern 158 state
 dw trackDef32 ; $0585: [$08E6] pattern 158, track 1
 dw trackDef1 ; $0587: [$05CF] pattern 158, track 2
 dw trackDef1 ; $0589: [$05CF] pattern 158, track 3
pattern159Definition:
 db $00 ; $058B: pattern 159 state
 dw trackDef32 ; $058C: [$08E6] pattern 159, track 1
 dw trackDef1 ; $058E: [$05CF] pattern 159, track 2
 dw trackDef1 ; $0590: [$05CF] pattern 159, track 3
pattern160Definition:
 db $00 ; $0592: pattern 160 state
 dw trackDef30 ; $0593: [$08B6] pattern 160, track 1
 dw trackDef1 ; $0595: [$05CF] pattern 160, track 2
 dw trackDef1 ; $0597: [$05CF] pattern 160, track 3
pattern161Definition:
 db $00 ; $0599: pattern 161 state
 dw trackDef31 ; $059A: [$08CE] pattern 161, track 1
 dw trackDef1 ; $059C: [$05CF] pattern 161, track 2
 dw trackDef1 ; $059E: [$05CF] pattern 161, track 3
pattern162Definition:
 db $00 ; $05A0: pattern 162 state
 dw trackDef32 ; $05A1: [$08E6] pattern 162, track 1
 dw trackDef1 ; $05A3: [$05CF] pattern 162, track 2
 dw trackDef1 ; $05A5: [$05CF] pattern 162, track 3
pattern163Definition:
 db $00 ; $05A7: pattern 163 state
 dw trackDef32 ; $05A8: [$08E6] pattern 163, track 1
 dw trackDef1 ; $05AA: [$05CF] pattern 163, track 2
 dw trackDef1 ; $05AC: [$05CF] pattern 163, track 3
pattern164Definition:
 db $00 ; $05AE: pattern 164 state
 dw trackDef30 ; $05AF: [$08B6] pattern 164, track 1
 dw trackDef1 ; $05B1: [$05CF] pattern 164, track 2
 dw trackDef1 ; $05B3: [$05CF] pattern 164, track 3
pattern165Definition:
 db $00 ; $05B5: pattern 165 state
 dw trackDef31 ; $05B6: [$08CE] pattern 165, track 1
 dw trackDef1 ; $05B8: [$05CF] pattern 165, track 2
 dw trackDef1 ; $05BA: [$05CF] pattern 165, track 3
pattern166Definition:
 db $00 ; $05BC: pattern 166 state
 dw trackDef32 ; $05BD: [$08E6] pattern 166, track 1
 dw trackDef1 ; $05BF: [$05CF] pattern 166, track 2
 dw trackDef1 ; $05C1: [$05CF] pattern 166, track 3
pattern167Definition:
 db $00 ; $05C3: pattern 167 state
 dw trackDef33 ; $05C4: [$08FE] pattern 167, track 1
 dw trackDef1 ; $05C6: [$05CF] pattern 167, track 2
 dw trackDef1 ; $05C8: [$05CF] pattern 167, track 3
pattern168Definition:
 db $01 ; $05CA: pattern 168 state
 dw pattern0Definition ; $05CB: [$0109] song restart address
specialtrackDef0:
 db $21 ; $05CD: data, speed 8
 db $00 ; $05CE: wait 128
trackDef1:
 db $42 ; $05CF: normal track data,  note: C0
 db $80 ; $05D0: vol off
 dw $0000 ; $05D1: pitch
 db $42 ; $05D3: normal track data,  note: C0
 db $00 ; $05D4: vol off
 db $42 ; $05D5: normal track data,  note: C0
 db $00 ; $05D6: vol off
 db $42 ; $05D7: normal track data,  note: C0
 db $00 ; $05D8: vol off
 db $42 ; $05D9: normal track data,  note: C0
 db $00 ; $05DA: vol off
 db $42 ; $05DB: normal track data,  note: C0
 db $00 ; $05DC: vol off
 db $42 ; $05DD: normal track data,  note: C0
 db $00 ; $05DE: vol off
 db $42 ; $05DF: normal track data,  note: C0
 db $00 ; $05E0: vol off
 db $42 ; $05E1: normal track data,  note: C0
 db $00 ; $05E2: vol off
 db $42 ; $05E3: normal track data,  note: C0
 db $00 ; $05E4: vol off
 db $42 ; $05E5: normal track data,  note: C0
 db $00 ; $05E6: vol off
 db $42 ; $05E7: normal track data,  note: C0
 db $00 ; $05E8: vol off
 db $18 ; $05E9: normal track data,  wait 11
 db $42 ; $05EA: normal track data,  note: C0
 db $00 ; $05EB: vol off
 db $42 ; $05EC: normal track data,  note: C0
 db $00 ; $05ED: vol off
 db $02 ; $05EE: normal track data,  wait 0
 db $42 ; $05EF: normal track data,  note: C0
 db $00 ; $05F0: vol off
 db $00 ; $05F1: track end signature found
trackDef0:
 db $68 ; $05F2: normal track data,  note: G1
 db $E1 ; $05F3: vol = $F (inverted)
 dw $0000 ; $05F4: pitch
 db $01 ; $05F6: instrument
 db $42 ; $05F7: normal track data,  note: C0
 db $80 ; $05F8: vol off
 dw $0002 ; $05F9: pitch
 db $42 ; $05FB: normal track data,  note: C0
 db $00 ; $05FC: vol off
 db $42 ; $05FD: normal track data,  note: C0
 db $00 ; $05FE: vol off
 db $42 ; $05FF: normal track data,  note: C0
 db $00 ; $0600: vol off
 db $42 ; $0601: normal track data,  note: C0
 db $03 ; $0602: vol = $E (inverted)
 db $42 ; $0603: normal track data,  note: C0
 db $00 ; $0604: vol off
 db $42 ; $0605: normal track data,  note: C0
 db $00 ; $0606: vol off
 db $42 ; $0607: normal track data,  note: C0
 db $00 ; $0608: vol off
 db $42 ; $0609: normal track data,  note: C0
 db $00 ; $060A: vol off
 db $42 ; $060B: normal track data,  note: C0
 db $05 ; $060C: vol = $D (inverted)
 db $42 ; $060D: normal track data,  note: C0
 db $00 ; $060E: vol off
 db $42 ; $060F: normal track data,  note: C0
 db $00 ; $0610: vol off
 db $42 ; $0611: normal track data,  note: C0
 db $00 ; $0612: vol off
 db $42 ; $0613: normal track data,  note: C0
 db $00 ; $0614: vol off
 db $42 ; $0615: normal track data,  note: C0
 db $07 ; $0616: vol = $C (inverted)
 db $42 ; $0617: normal track data,  note: C0
 db $00 ; $0618: vol off
 db $42 ; $0619: normal track data,  note: C0
 db $00 ; $061A: vol off
 db $42 ; $061B: normal track data,  note: C0
 db $00 ; $061C: vol off
 db $42 ; $061D: normal track data,  note: C0
 db $00 ; $061E: vol off
 db $42 ; $061F: normal track data,  note: C0
 db $09 ; $0620: vol = $B (inverted)
 db $42 ; $0621: normal track data,  note: C0
 db $00 ; $0622: vol off
 db $42 ; $0623: normal track data,  note: C0
 db $00 ; $0624: vol off
 db $42 ; $0625: normal track data,  note: C0
 db $00 ; $0626: vol off
 db $42 ; $0627: normal track data,  note: C0
 db $00 ; $0628: vol off
 db $42 ; $0629: normal track data,  note: C0
 db $0B ; $062A: vol = $A (inverted)
 db $42 ; $062B: normal track data,  note: C0
 db $00 ; $062C: vol off
 db $42 ; $062D: normal track data,  note: C0
 db $0D ; $062E: vol = $9 (inverted)
 db $42 ; $062F: normal track data,  note: C0
 db $0F ; $0630: vol = $8 (inverted)
 db $42 ; $0631: normal track data,  note: C0
 db $11 ; $0632: vol = $7 (inverted)
 db $42 ; $0633: normal track data,  note: C0
 db $13 ; $0634: vol = $6 (inverted)
 db $42 ; $0635: normal track data,  note: C0
 db $15 ; $0636: vol = $5 (inverted)
trackDef3:
 db $BA ; $0637: normal track data,  note: C5
 db $F3 ; $0638: vol = $6 (inverted)
 dw $0000 ; $0639: pitch
 db $02 ; $063B: instrument
 db $02 ; $063C: normal track data,  wait 0
 db $BA ; $063D: normal track data,  note: C5
 db $71 ; $063E: vol = $7 (inverted)
 db $03 ; $063F: instrument
 db $BA ; $0640: normal track data,  note: C5
 db $4F ; $0641: vol = $8 (inverted)
 db $BA ; $0642: normal track data,  note: C5
 db $4D ; $0643: vol = $9 (inverted)
 db $BA ; $0644: normal track data,  note: C5
 db $4B ; $0645: vol = $A (inverted)
 db $BA ; $0646: normal track data,  note: C5
 db $49 ; $0647: vol = $B (inverted)
 db $BA ; $0648: normal track data,  note: C5
 db $55 ; $0649: vol = $5 (inverted)
 db $BA ; $064A: normal track data,  note: C5
 db $67 ; $064B: vol = $C (inverted)
 db $02 ; $064C: instrument
 db $BA ; $064D: normal track data,  note: C5
 db $51 ; $064E: vol = $7 (inverted)
 db $BA ; $064F: normal track data,  note: C5
 db $65 ; $0650: vol = $D (inverted)
 db $03 ; $0651: instrument
 db $BA ; $0652: normal track data,  note: C5
 db $43 ; $0653: vol = $E (inverted)
 db $BA ; $0654: normal track data,  note: C5
 db $41 ; $0655: vol = $F (inverted)
 db $7B ; $0656: full optimization, no escape: C5
 db $7B ; $0657: full optimization, no escape: C5
 db $BA ; $0658: normal track data,  note: C5
 db $4D ; $0659: vol = $9 (inverted)
trackDef4:
 db $BA ; $065A: normal track data,  note: C5
 db $E1 ; $065B: vol = $F (inverted)
 dw $0000 ; $065C: pitch
 db $02 ; $065E: instrument
 db $BA ; $065F: normal track data,  note: C5
 db $4D ; $0660: vol = $9 (inverted)
 db $BA ; $0661: normal track data,  note: C5
 db $61 ; $0662: vol = $F (inverted)
 db $03 ; $0663: instrument
 db $7B ; $0664: full optimization, no escape: C5
 db $7B ; $0665: full optimization, no escape: C5
 db $7B ; $0666: full optimization, no escape: C5
 db $7B ; $0667: full optimization, no escape: C5
 db $BA ; $0668: normal track data,  note: C5
 db $4D ; $0669: vol = $9 (inverted)
trackDef5:
 db $6E ; $066A: normal track data,  note: A#1
 db $E1 ; $066B: vol = $F (inverted)
 dw $0000 ; $066C: pitch
 db $04 ; $066E: instrument
 db $33 ; $066F: full optimization, no escape: C2
 db $BA ; $0670: normal track data,  note: C5
 db $60 ; $0671: vol off
 db $03 ; $0672: instrument
 db $7B ; $0673: full optimization, no escape: C5
 db $7B ; $0674: full optimization, no escape: C5
 db $7B ; $0675: full optimization, no escape: C5
 db $BA ; $0676: normal track data,  note: C5
 db $60 ; $0677: vol off
 db $02 ; $0678: instrument
 db $BA ; $0679: normal track data,  note: C5
 db $4D ; $067A: vol = $9 (inverted)
trackDef6:
 db $6E ; $067B: normal track data,  note: A#1
 db $E1 ; $067C: vol = $F (inverted)
 dw $0000 ; $067D: pitch
 db $04 ; $067F: instrument
 db $33 ; $0680: full optimization, no escape: C2
 db $72 ; $0681: normal track data,  note: C2
 db $60 ; $0682: vol off
 db $05 ; $0683: instrument
 db $BA ; $0684: normal track data,  note: C5
 db $60 ; $0685: vol off
 db $03 ; $0686: instrument
 db $BA ; $0687: normal track data,  note: C5
 db $60 ; $0688: vol off
 db $02 ; $0689: instrument
 db $BA ; $068A: normal track data,  note: C5
 db $60 ; $068B: vol off
 db $03 ; $068C: instrument
 db $72 ; $068D: normal track data,  note: C2
 db $60 ; $068E: vol off
 db $05 ; $068F: instrument
 db $72 ; $0690: normal track data,  note: C2
 db $4F ; $0691: vol = $8 (inverted)
trackDef7:
 db $6E ; $0692: normal track data,  note: A#1
 db $E1 ; $0693: vol = $F (inverted)
 dw $0000 ; $0694: pitch
 db $04 ; $0696: instrument
 db $33 ; $0697: full optimization, no escape: C2
 db $72 ; $0698: normal track data,  note: C2
 db $60 ; $0699: vol off
 db $05 ; $069A: instrument
 db $BA ; $069B: normal track data,  note: C5
 db $60 ; $069C: vol off
 db $03 ; $069D: instrument
 db $A2 ; $069E: normal track data,  note: C4
 db $60 ; $069F: vol off
 db $06 ; $06A0: instrument
 db $BA ; $06A1: normal track data,  note: C5
 db $60 ; $06A2: vol off
 db $03 ; $06A3: instrument
 db $72 ; $06A4: normal track data,  note: C2
 db $60 ; $06A5: vol off
 db $05 ; $06A6: instrument
 db $BA ; $06A7: normal track data,  note: C5
 db $60 ; $06A8: vol off
 db $06 ; $06A9: instrument
trackDef8:
 db $6E ; $06AA: normal track data,  note: A#1
 db $E0 ; $06AB: vol off
 dw $0000 ; $06AC: pitch
 db $04 ; $06AE: instrument
 db $33 ; $06AF: full optimization, no escape: C2
 db $72 ; $06B0: normal track data,  note: C2
 db $60 ; $06B1: vol off
 db $05 ; $06B2: instrument
 db $BA ; $06B3: normal track data,  note: C5
 db $60 ; $06B4: vol off
 db $03 ; $06B5: instrument
 db $BA ; $06B6: normal track data,  note: C5
 db $60 ; $06B7: vol off
 db $06 ; $06B8: instrument
 db $BA ; $06B9: normal track data,  note: C5
 db $60 ; $06BA: vol off
 db $03 ; $06BB: instrument
 db $72 ; $06BC: normal track data,  note: C2
 db $60 ; $06BD: vol off
 db $05 ; $06BE: instrument
 db $72 ; $06BF: normal track data,  note: C2
 db $4F ; $06C0: vol = $8 (inverted)
trackDef9:
 db $68 ; $06C1: normal track data,  note: G1
 db $E1 ; $06C2: vol = $F (inverted)
 dw $0000 ; $06C3: pitch
 db $07 ; $06C5: instrument
 db $72 ; $06C6: normal track data,  note: C2
 db $60 ; $06C7: vol off
 db $04 ; $06C8: instrument
 db $72 ; $06C9: normal track data,  note: C2
 db $60 ; $06CA: vol off
 db $05 ; $06CB: instrument
 db $BA ; $06CC: normal track data,  note: C5
 db $60 ; $06CD: vol off
 db $03 ; $06CE: instrument
 db $A2 ; $06CF: normal track data,  note: C4
 db $60 ; $06D0: vol off
 db $06 ; $06D1: instrument
 db $BA ; $06D2: normal track data,  note: C5
 db $60 ; $06D3: vol off
 db $03 ; $06D4: instrument
 db $72 ; $06D5: normal track data,  note: C2
 db $60 ; $06D6: vol off
 db $05 ; $06D7: instrument
 db $BA ; $06D8: normal track data,  note: C5
 db $60 ; $06D9: vol off
 db $06 ; $06DA: instrument
trackDef10:
 db $68 ; $06DB: normal track data,  note: G1
 db $E0 ; $06DC: vol off
 dw $0000 ; $06DD: pitch
 db $07 ; $06DF: instrument
 db $72 ; $06E0: normal track data,  note: C2
 db $60 ; $06E1: vol off
 db $04 ; $06E2: instrument
 db $72 ; $06E3: normal track data,  note: C2
 db $60 ; $06E4: vol off
 db $05 ; $06E5: instrument
 db $68 ; $06E6: normal track data,  note: G1
 db $60 ; $06E7: vol off
 db $07 ; $06E8: instrument
 db $CE ; $06E9: normal track data,  note: A#5
 db $63 ; $06EA: vol = $E (inverted)
 db $08 ; $06EB: instrument
 db $93 ; $06EC: full optimization, no escape: C6
 db $72 ; $06ED: normal track data,  note: C2
 db $61 ; $06EE: vol = $F (inverted)
 db $05 ; $06EF: instrument
 db $BA ; $06F0: normal track data,  note: C5
 db $60 ; $06F1: vol off
 db $02 ; $06F2: instrument
trackDef11:
 db $68 ; $06F3: normal track data,  note: G1
 db $E0 ; $06F4: vol off
 dw $0000 ; $06F5: pitch
 db $07 ; $06F7: instrument
 db $72 ; $06F8: normal track data,  note: C2
 db $60 ; $06F9: vol off
 db $04 ; $06FA: instrument
 db $72 ; $06FB: normal track data,  note: C2
 db $60 ; $06FC: vol off
 db $05 ; $06FD: instrument
 db $BA ; $06FE: normal track data,  note: C5
 db $60 ; $06FF: vol off
 db $02 ; $0700: instrument
 db $BA ; $0701: normal track data,  note: C5
 db $60 ; $0702: vol off
 db $09 ; $0703: instrument
 db $BA ; $0704: normal track data,  note: C5
 db $60 ; $0705: vol off
 db $03 ; $0706: instrument
 db $72 ; $0707: normal track data,  note: C2
 db $60 ; $0708: vol off
 db $05 ; $0709: instrument
 db $BA ; $070A: normal track data,  note: C5
 db $60 ; $070B: vol off
 db $02 ; $070C: instrument
trackDef12:
 db $68 ; $070D: normal track data,  note: G1
 db $E0 ; $070E: vol off
 dw $0000 ; $070F: pitch
 db $07 ; $0711: instrument
 db $72 ; $0712: normal track data,  note: C2
 db $60 ; $0713: vol off
 db $04 ; $0714: instrument
 db $72 ; $0715: normal track data,  note: C2
 db $60 ; $0716: vol off
 db $05 ; $0717: instrument
 db $BA ; $0718: normal track data,  note: C5
 db $60 ; $0719: vol off
 db $02 ; $071A: instrument
 db $BA ; $071B: normal track data,  note: C5
 db $60 ; $071C: vol off
 db $06 ; $071D: instrument
 db $BA ; $071E: normal track data,  note: C5
 db $60 ; $071F: vol off
 db $03 ; $0720: instrument
 db $72 ; $0721: normal track data,  note: C2
 db $60 ; $0722: vol off
 db $05 ; $0723: instrument
 db $CE ; $0724: normal track data,  note: A#5
 db $60 ; $0725: vol off
 db $08 ; $0726: instrument
trackDef17:
 db $68 ; $0727: normal track data,  note: G1
 db $E0 ; $0728: vol off
 dw $0000 ; $0729: pitch
 db $07 ; $072B: instrument
 db $BA ; $072C: normal track data,  note: C5
 db $60 ; $072D: vol off
 db $02 ; $072E: instrument
 db $72 ; $072F: normal track data,  note: C2
 db $60 ; $0730: vol off
 db $05 ; $0731: instrument
 db $BA ; $0732: normal track data,  note: C5
 db $60 ; $0733: vol off
 db $03 ; $0734: instrument
 db $BA ; $0735: normal track data,  note: C5
 db $65 ; $0736: vol = $D (inverted)
 db $06 ; $0737: instrument
 db $7E ; $0738: normal track data,  note: F#2
 db $61 ; $0739: vol = $F (inverted)
 db $0A ; $073A: instrument
 db $72 ; $073B: normal track data,  note: C2
 db $60 ; $073C: vol off
 db $05 ; $073D: instrument
 db $96 ; $073E: normal track data,  note: F#3
 db $60 ; $073F: vol off
 db $0A ; $0740: instrument
 db $68 ; $0741: normal track data,  note: G1
 db $60 ; $0742: vol off
 db $07 ; $0743: instrument
 db $96 ; $0744: normal track data,  note: F#3
 db $6B ; $0745: vol = $A (inverted)
 db $0A ; $0746: instrument
 db $72 ; $0747: normal track data,  note: C2
 db $61 ; $0748: vol = $F (inverted)
 db $05 ; $0749: instrument
 db $BA ; $074A: normal track data,  note: C5
 db $60 ; $074B: vol off
 db $03 ; $074C: instrument
 db $BA ; $074D: normal track data,  note: C5
 db $60 ; $074E: vol off
 db $08 ; $074F: instrument
 db $7E ; $0750: normal track data,  note: F#2
 db $60 ; $0751: vol off
 db $0A ; $0752: instrument
 db $72 ; $0753: normal track data,  note: C2
 db $60 ; $0754: vol off
 db $05 ; $0755: instrument
 db $8A ; $0756: normal track data,  note: C3
 db $60 ; $0757: vol off
 db $0A ; $0758: instrument
 db $68 ; $0759: normal track data,  note: G1
 db $60 ; $075A: vol off
 db $07 ; $075B: instrument
 db $8A ; $075C: normal track data,  note: C3
 db $6B ; $075D: vol = $A (inverted)
 db $0A ; $075E: instrument
 db $72 ; $075F: normal track data,  note: C2
 db $61 ; $0760: vol = $F (inverted)
 db $05 ; $0761: instrument
 db $BA ; $0762: normal track data,  note: C5
 db $60 ; $0763: vol off
 db $03 ; $0764: instrument
 db $BA ; $0765: normal track data,  note: C5
 db $63 ; $0766: vol = $E (inverted)
 db $09 ; $0767: instrument
 db $BA ; $0768: normal track data,  note: C5
 db $65 ; $0769: vol = $D (inverted)
 db $08 ; $076A: instrument
 db $72 ; $076B: normal track data,  note: C2
 db $61 ; $076C: vol = $F (inverted)
 db $05 ; $076D: instrument
 db $72 ; $076E: normal track data,  note: C2
 db $47 ; $076F: vol = $C (inverted)
trackDef18:
 db $68 ; $0770: normal track data,  note: G1
 db $E1 ; $0771: vol = $F (inverted)
 dw $0000 ; $0772: pitch
 db $07 ; $0774: instrument
 db $BA ; $0775: normal track data,  note: C5
 db $60 ; $0776: vol off
 db $02 ; $0777: instrument
 db $72 ; $0778: normal track data,  note: C2
 db $60 ; $0779: vol off
 db $05 ; $077A: instrument
 db $BA ; $077B: normal track data,  note: C5
 db $60 ; $077C: vol off
 db $03 ; $077D: instrument
 db $BA ; $077E: normal track data,  note: C5
 db $65 ; $077F: vol = $D (inverted)
 db $06 ; $0780: instrument
 db $68 ; $0781: normal track data,  note: G1
 db $61 ; $0782: vol = $F (inverted)
 db $07 ; $0783: instrument
 db $72 ; $0784: normal track data,  note: C2
 db $60 ; $0785: vol off
 db $05 ; $0786: instrument
 db $BA ; $0787: normal track data,  note: C5
 db $60 ; $0788: vol off
 db $03 ; $0789: instrument
trackDef13:
 db $42 ; $078A: normal track data,  note: C0
 db $97 ; $078B: vol = $4 (inverted)
 dw $0002 ; $078C: pitch
 db $42 ; $078E: normal track data,  note: C0
 db $19 ; $078F: vol = $3 (inverted)
 db $42 ; $0790: normal track data,  note: C0
 db $1B ; $0791: vol = $2 (inverted)
 db $42 ; $0792: normal track data,  note: C0
 db $1D ; $0793: vol = $1 (inverted)
 db $42 ; $0794: normal track data,  note: C0
 db $1F ; $0795: vol = $0 (inverted)
 db $42 ; $0796: normal track data,  note: C0
 db $80 ; $0797: vol off
 dw $0000 ; $0798: pitch
trackDef19:
 db $68 ; $079A: normal track data,  note: G1
 db $E1 ; $079B: vol = $F (inverted)
 dw $0000 ; $079C: pitch
 db $07 ; $079E: instrument
 db $8E ; $079F: normal track data,  note: D3
 db $60 ; $07A0: vol off
 db $0A ; $07A1: instrument
 db $72 ; $07A2: normal track data,  note: C2
 db $60 ; $07A3: vol off
 db $05 ; $07A4: instrument
 db $90 ; $07A5: normal track data,  note: D#3
 db $60 ; $07A6: vol off
 db $0A ; $07A7: instrument
 db $BA ; $07A8: normal track data,  note: C5
 db $60 ; $07A9: vol off
 db $08 ; $07AA: instrument
 db $92 ; $07AB: normal track data,  note: E3
 db $60 ; $07AC: vol off
 db $0A ; $07AD: instrument
 db $72 ; $07AE: normal track data,  note: C2
 db $60 ; $07AF: vol off
 db $05 ; $07B0: instrument
 db $68 ; $07B1: normal track data,  note: G1
 db $60 ; $07B2: vol off
 db $07 ; $07B3: instrument
trackDef20:
 db $68 ; $07B4: normal track data,  note: G1
 db $E0 ; $07B5: vol off
 dw $0000 ; $07B6: pitch
 db $07 ; $07B8: instrument
 db $BA ; $07B9: normal track data,  note: C5
 db $60 ; $07BA: vol off
 db $02 ; $07BB: instrument
 db $72 ; $07BC: normal track data,  note: C2
 db $60 ; $07BD: vol off
 db $05 ; $07BE: instrument
 db $72 ; $07BF: normal track data,  note: C2
 db $4F ; $07C0: vol = $8 (inverted)
 db $BA ; $07C1: normal track data,  note: C5
 db $61 ; $07C2: vol = $F (inverted)
 db $02 ; $07C3: instrument
 db $BA ; $07C4: normal track data,  note: C5
 db $69 ; $07C5: vol = $B (inverted)
 db $03 ; $07C6: instrument
 db $72 ; $07C7: normal track data,  note: C2
 db $61 ; $07C8: vol = $F (inverted)
 db $05 ; $07C9: instrument
 db $BA ; $07CA: normal track data,  note: C5
 db $60 ; $07CB: vol off
 db $03 ; $07CC: instrument
trackDef21:
 db $A2 ; $07CD: normal track data,  note: C4
 db $E0 ; $07CE: vol off
 dw $0000 ; $07CF: pitch
 db $02 ; $07D1: instrument
 db $BA ; $07D2: normal track data,  note: C5
 db $60 ; $07D3: vol off
 db $03 ; $07D4: instrument
 db $72 ; $07D5: normal track data,  note: C2
 db $60 ; $07D6: vol off
 db $05 ; $07D7: instrument
 db $33 ; $07D8: full optimization, no escape: C2
 db $72 ; $07D9: normal track data,  note: C2
 db $49 ; $07DA: vol = $B (inverted)
 db $72 ; $07DB: normal track data,  note: C2
 db $4F ; $07DC: vol = $8 (inverted)
 db $72 ; $07DD: normal track data,  note: C2
 db $41 ; $07DE: vol = $F (inverted)
 db $BA ; $07DF: normal track data,  note: C5
 db $60 ; $07E0: vol off
 db $03 ; $07E1: instrument
trackDef22:
 db $A2 ; $07E2: normal track data,  note: C4
 db $E0 ; $07E3: vol off
 dw $0000 ; $07E4: pitch
 db $02 ; $07E6: instrument
 db $BA ; $07E7: normal track data,  note: C5
 db $60 ; $07E8: vol off
 db $03 ; $07E9: instrument
 db $72 ; $07EA: normal track data,  note: C2
 db $60 ; $07EB: vol off
 db $05 ; $07EC: instrument
 db $A2 ; $07ED: normal track data,  note: C4
 db $63 ; $07EE: vol = $E (inverted)
 db $06 ; $07EF: instrument
 db $A2 ; $07F0: normal track data,  note: C4
 db $4F ; $07F1: vol = $8 (inverted)
 db $72 ; $07F2: normal track data,  note: C2
 db $63 ; $07F3: vol = $E (inverted)
 db $05 ; $07F4: instrument
 db $33 ; $07F5: full optimization, no escape: C2
 db $72 ; $07F6: normal track data,  note: C2
 db $41 ; $07F7: vol = $F (inverted)
trackDef14:
 db $68 ; $07F8: normal track data,  note: G1
 db $E1 ; $07F9: vol = $F (inverted)
 dw $0000 ; $07FA: pitch
 db $07 ; $07FC: instrument
 db $BA ; $07FD: normal track data,  note: C5
 db $60 ; $07FE: vol off
 db $02 ; $07FF: instrument
 db $72 ; $0800: normal track data,  note: C2
 db $60 ; $0801: vol off
 db $05 ; $0802: instrument
 db $BA ; $0803: normal track data,  note: C5
 db $60 ; $0804: vol off
 db $03 ; $0805: instrument
 db $BA ; $0806: normal track data,  note: C5
 db $63 ; $0807: vol = $E (inverted)
 db $06 ; $0808: instrument
 db $66 ; $0809: normal track data,  note: F#1
 db $61 ; $080A: vol = $F (inverted)
 db $0B ; $080B: instrument
 db $72 ; $080C: normal track data,  note: C2
 db $60 ; $080D: vol off
 db $05 ; $080E: instrument
 db $7E ; $080F: normal track data,  note: F#2
 db $60 ; $0810: vol off
 db $0B ; $0811: instrument
 db $68 ; $0812: normal track data,  note: G1
 db $60 ; $0813: vol off
 db $07 ; $0814: instrument
 db $7E ; $0815: normal track data,  note: F#2
 db $6D ; $0816: vol = $9 (inverted)
 db $0B ; $0817: instrument
 db $72 ; $0818: normal track data,  note: C2
 db $61 ; $0819: vol = $F (inverted)
 db $05 ; $081A: instrument
 db $BA ; $081B: normal track data,  note: C5
 db $60 ; $081C: vol off
 db $03 ; $081D: instrument
 db $BA ; $081E: normal track data,  note: C5
 db $60 ; $081F: vol off
 db $08 ; $0820: instrument
 db $66 ; $0821: normal track data,  note: F#1
 db $60 ; $0822: vol off
 db $0B ; $0823: instrument
 db $72 ; $0824: normal track data,  note: C2
 db $60 ; $0825: vol off
 db $05 ; $0826: instrument
 db $72 ; $0827: normal track data,  note: C2
 db $60 ; $0828: vol off
 db $0B ; $0829: instrument
 db $68 ; $082A: normal track data,  note: G1
 db $60 ; $082B: vol off
 db $07 ; $082C: instrument
 db $72 ; $082D: normal track data,  note: C2
 db $6D ; $082E: vol = $9 (inverted)
 db $0B ; $082F: instrument
 db $72 ; $0830: normal track data,  note: C2
 db $61 ; $0831: vol = $F (inverted)
 db $05 ; $0832: instrument
 db $BA ; $0833: normal track data,  note: C5
 db $60 ; $0834: vol off
 db $03 ; $0835: instrument
trackDef15:
 db $BA ; $0836: normal track data,  note: C5
 db $E3 ; $0837: vol = $E (inverted)
 dw $0000 ; $0838: pitch
 db $09 ; $083A: instrument
 db $BA ; $083B: normal track data,  note: C5
 db $61 ; $083C: vol = $F (inverted)
 db $08 ; $083D: instrument
 db $72 ; $083E: normal track data,  note: C2
 db $60 ; $083F: vol off
 db $05 ; $0840: instrument
 db $72 ; $0841: normal track data,  note: C2
 db $47 ; $0842: vol = $C (inverted)
 db $68 ; $0843: normal track data,  note: G1
 db $61 ; $0844: vol = $F (inverted)
 db $07 ; $0845: instrument
 db $BA ; $0846: normal track data,  note: C5
 db $60 ; $0847: vol off
 db $02 ; $0848: instrument
 db $72 ; $0849: normal track data,  note: C2
 db $60 ; $084A: vol off
 db $05 ; $084B: instrument
 db $BA ; $084C: normal track data,  note: C5
 db $60 ; $084D: vol off
 db $03 ; $084E: instrument
 db $BA ; $084F: normal track data,  note: C5
 db $65 ; $0850: vol = $D (inverted)
 db $06 ; $0851: instrument
 db $68 ; $0852: normal track data,  note: G1
 db $61 ; $0853: vol = $F (inverted)
 db $07 ; $0854: instrument
 db $72 ; $0855: normal track data,  note: C2
 db $60 ; $0856: vol off
 db $05 ; $0857: instrument
 db $BA ; $0858: normal track data,  note: C5
 db $60 ; $0859: vol off
 db $03 ; $085A: instrument
trackDef16:
 db $BA ; $085B: normal track data,  note: C5
 db $E3 ; $085C: vol = $E (inverted)
 dw $0000 ; $085D: pitch
 db $09 ; $085F: instrument
 db $BA ; $0860: normal track data,  note: C5
 db $65 ; $0861: vol = $D (inverted)
 db $08 ; $0862: instrument
 db $72 ; $0863: normal track data,  note: C2
 db $61 ; $0864: vol = $F (inverted)
 db $05 ; $0865: instrument
 db $72 ; $0866: normal track data,  note: C2
 db $47 ; $0867: vol = $C (inverted)
 db $68 ; $0868: normal track data,  note: G1
 db $61 ; $0869: vol = $F (inverted)
 db $07 ; $086A: instrument
 db $5E ; $086B: normal track data,  note: D1
 db $60 ; $086C: vol off
 db $0B ; $086D: instrument
 db $72 ; $086E: normal track data,  note: C2
 db $60 ; $086F: vol off
 db $05 ; $0870: instrument
 db $60 ; $0871: normal track data,  note: D#1
 db $60 ; $0872: vol off
 db $0B ; $0873: instrument
 db $BA ; $0874: normal track data,  note: C5
 db $60 ; $0875: vol off
 db $08 ; $0876: instrument
 db $62 ; $0877: normal track data,  note: E1
 db $60 ; $0878: vol off
 db $0B ; $0879: instrument
 db $72 ; $087A: normal track data,  note: C2
 db $60 ; $087B: vol off
 db $05 ; $087C: instrument
 db $68 ; $087D: normal track data,  note: G1
 db $60 ; $087E: vol off
 db $07 ; $087F: instrument
trackDef23:
 db $68 ; $0880: normal track data,  note: G1
 db $E0 ; $0881: vol off
 dw $0000 ; $0882: pitch
 db $07 ; $0884: instrument
 db $68 ; $0885: normal track data,  note: G1
 db $53 ; $0886: vol = $6 (inverted)
trackDef26:
 db $A2 ; $0887: normal track data,  note: C4
 db $E1 ; $0888: vol = $F (inverted)
 dw $0000 ; $0889: pitch
 db $0C ; $088B: instrument
 db $04 ; $088C: normal track data,  wait 1
 db $A2 ; $088D: normal track data,  note: C4
 db $4F ; $088E: vol = $8 (inverted)
 db $42 ; $088F: normal track data,  note: C0
 db $09 ; $0890: vol = $B (inverted)
 db $02 ; $0891: normal track data,  wait 0
 db $A2 ; $0892: normal track data,  note: C4
 db $55 ; $0893: vol = $5 (inverted)
 db $00 ; $0894: track end signature found
trackDef25:
 db $66 ; $0895: normal track data,  note: F#1
 db $E0 ; $0896: vol off
 dw $0000 ; $0897: pitch
 db $04 ; $0899: instrument
 db $66 ; $089A: normal track data,  note: F#1
 db $4D ; $089B: vol = $9 (inverted)
trackDef27:
 db $68 ; $089C: normal track data,  note: G1
 db $E1 ; $089D: vol = $F (inverted)
 dw $0000 ; $089E: pitch
 db $04 ; $08A0: instrument
 db $68 ; $08A1: normal track data,  note: G1
 db $4D ; $08A2: vol = $9 (inverted)
trackDef28:
 db $6A ; $08A3: normal track data,  note: G#1
 db $E0 ; $08A4: vol off
 dw $0000 ; $08A5: pitch
 db $04 ; $08A7: instrument
 db $6A ; $08A8: normal track data,  note: G#1
 db $4D ; $08A9: vol = $9 (inverted)
trackDef29:
 db $A2 ; $08AA: normal track data,  note: C4
 db $E0 ; $08AB: vol off
 dw $0000 ; $08AC: pitch
 db $0C ; $08AE: instrument
 db $42 ; $08AF: normal track data,  note: C0
 db $00 ; $08B0: vol off
 db $D2 ; $08B1: normal track data,  note: C6
 db $60 ; $08B2: vol off
 db $02 ; $08B3: instrument
 db $D2 ; $08B4: normal track data,  note: C6
 db $4B ; $08B5: vol = $A (inverted)
trackDef30:
 db $68 ; $08B6: normal track data,  note: G1
 db $E1 ; $08B7: vol = $F (inverted)
 dw $0000 ; $08B8: pitch
 db $07 ; $08BA: instrument
 db $D2 ; $08BB: normal track data,  note: C6
 db $63 ; $08BC: vol = $E (inverted)
 db $03 ; $08BD: instrument
 db $72 ; $08BE: normal track data,  note: C2
 db $61 ; $08BF: vol = $F (inverted)
 db $05 ; $08C0: instrument
 db $D2 ; $08C1: normal track data,  note: C6
 db $63 ; $08C2: vol = $E (inverted)
 db $02 ; $08C3: instrument
 db $62 ; $08C4: normal track data,  note: E1
 db $61 ; $08C5: vol = $F (inverted)
 db $04 ; $08C6: instrument
 db $27 ; $08C7: full optimization, no escape: F#1
 db $72 ; $08C8: normal track data,  note: C2
 db $60 ; $08C9: vol off
 db $05 ; $08CA: instrument
 db $D2 ; $08CB: normal track data,  note: C6
 db $63 ; $08CC: vol = $E (inverted)
 db $03 ; $08CD: instrument
trackDef31:
 db $68 ; $08CE: normal track data,  note: G1
 db $E1 ; $08CF: vol = $F (inverted)
 dw $0000 ; $08D0: pitch
 db $07 ; $08D2: instrument
 db $D2 ; $08D3: normal track data,  note: C6
 db $63 ; $08D4: vol = $E (inverted)
 db $03 ; $08D5: instrument
 db $72 ; $08D6: normal track data,  note: C2
 db $61 ; $08D7: vol = $F (inverted)
 db $05 ; $08D8: instrument
 db $D2 ; $08D9: normal track data,  note: C6
 db $63 ; $08DA: vol = $E (inverted)
 db $02 ; $08DB: instrument
 db $66 ; $08DC: normal track data,  note: F#1
 db $61 ; $08DD: vol = $F (inverted)
 db $04 ; $08DE: instrument
 db $29 ; $08DF: full optimization, no escape: G1
 db $72 ; $08E0: normal track data,  note: C2
 db $60 ; $08E1: vol off
 db $05 ; $08E2: instrument
 db $D2 ; $08E3: normal track data,  note: C6
 db $63 ; $08E4: vol = $E (inverted)
 db $03 ; $08E5: instrument
trackDef32:
 db $68 ; $08E6: normal track data,  note: G1
 db $E1 ; $08E7: vol = $F (inverted)
 dw $0000 ; $08E8: pitch
 db $07 ; $08EA: instrument
 db $D2 ; $08EB: normal track data,  note: C6
 db $63 ; $08EC: vol = $E (inverted)
 db $03 ; $08ED: instrument
 db $72 ; $08EE: normal track data,  note: C2
 db $61 ; $08EF: vol = $F (inverted)
 db $05 ; $08F0: instrument
 db $D2 ; $08F1: normal track data,  note: C6
 db $63 ; $08F2: vol = $E (inverted)
 db $02 ; $08F3: instrument
 db $68 ; $08F4: normal track data,  note: G1
 db $61 ; $08F5: vol = $F (inverted)
 db $04 ; $08F6: instrument
 db $2B ; $08F7: full optimization, no escape: G#1
 db $72 ; $08F8: normal track data,  note: C2
 db $60 ; $08F9: vol off
 db $05 ; $08FA: instrument
 db $D2 ; $08FB: normal track data,  note: C6
 db $63 ; $08FC: vol = $E (inverted)
 db $03 ; $08FD: instrument
trackDef33:
 db $68 ; $08FE: normal track data,  note: G1
 db $E1 ; $08FF: vol = $F (inverted)
 dw $0000 ; $0900: pitch
 db $07 ; $0902: instrument
 db $D2 ; $0903: normal track data,  note: C6
 db $63 ; $0904: vol = $E (inverted)
 db $03 ; $0905: instrument
 db $72 ; $0906: normal track data,  note: C2
 db $61 ; $0907: vol = $F (inverted)
 db $05 ; $0908: instrument
 db $D2 ; $0909: normal track data,  note: C6
 db $63 ; $090A: vol = $E (inverted)
 db $02 ; $090B: instrument
 db $5A ; $090C: normal track data,  note: C1
 db $E0 ; $090D: vol off
 dw $FFD4 ; $090E: pitch
 db $01 ; $0910: instrument
 db $42 ; $0911: normal track data,  note: C0
 db $01 ; $0912: vol = $F (inverted)
 db $42 ; $0913: normal track data,  note: C0
 db $80 ; $0914: vol off
 dw $FFD3 ; $0915: pitch
 db $42 ; $0917: normal track data,  note: C0
 db $00 ; $0918: vol off
trackDef24:
 db $A2 ; $0919: normal track data,  note: C4
 db $E1 ; $091A: vol = $F (inverted)
 dw $0000 ; $091B: pitch
 db $0C ; $091D: instrument
 db $42 ; $091E: normal track data,  note: C0
 db $00 ; $091F: vol off
 db $42 ; $0920: normal track data,  note: C0
 db $00 ; $0921: vol off
 db $A2 ; $0922: normal track data,  note: C4
 db $51 ; $0923: vol = $7 (inverted)