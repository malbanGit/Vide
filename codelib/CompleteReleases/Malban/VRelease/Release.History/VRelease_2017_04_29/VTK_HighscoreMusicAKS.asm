; this file is part of Release, written by Malban in 2017
;

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
 dw $00B1 ; $000A: size of instrument table (without this word pointer)
 dw instrument0HighscoreMusik ; $000C: [$001C] pointer to instrument 0
 dw instrument1HighscoreMusik ; $000E: [$0025] pointer to instrument 1
 dw instrument2HighscoreMusik ; $0010: [$0040] pointer to instrument 2
 dw instrument3HighscoreMusik ; $0012: [$005C] pointer to instrument 3
 dw instrument4HighscoreMusik ; $0014: [$006E] pointer to instrument 4
 dw instrument5HighscoreMusik ; $0016: [$0079] pointer to instrument 5
 dw instrument6HighscoreMusik ; $0018: [$009B] pointer to instrument 6
 dw instrument7HighscoreMusik ; $001A: [$00A4] pointer to instrument 7
instrument0HighscoreMusik:
 db $00 ; $001C: speed
 db $00 ; $001D: retrig
instrument0loopHighscoreMusik:
 db $00 ; $001E: dataColumn_0 (non hard), vol=$0
 db $00 ; $001F: dataColumn_0 (non hard), vol=$0
 db $00 ; $0020: dataColumn_0 (non hard), vol=$0
 db $00 ; $0021: dataColumn_0 (non hard), vol=$0
 db $0D ; $0022: dataColumn_0 (hard)
 dw instrument0loopHighscoreMusik ; $0023: [$001E] loop
instrument1HighscoreMusik:
 db $03 ; $0025: speed
 db $00 ; $0026: retrig
 db $34 ; $0027: dataColumn_0 (non hard), vol=$D
 db $B0 ; $0028: dataColumn_0 (non hard), vol=$C
 dw $FFFF ; $0029: pitch
 db $30 ; $002B: dataColumn_0 (non hard), vol=$C
 db $AC ; $002C: dataColumn_0 (non hard), vol=$B
 dw $FFFF ; $002D: pitch
 db $2C ; $002F: dataColumn_0 (non hard), vol=$B
 db $A8 ; $0030: dataColumn_0 (non hard), vol=$A
 dw $0001 ; $0031: pitch
 db $24 ; $0033: dataColumn_0 (non hard), vol=$9
 db $A0 ; $0034: dataColumn_0 (non hard), vol=$8
 dw $FFFF ; $0035: pitch
 db $1C ; $0037: dataColumn_0 (non hard), vol=$7
 db $98 ; $0038: dataColumn_0 (non hard), vol=$6
 dw $0001 ; $0039: pitch
 db $14 ; $003B: dataColumn_0 (non hard), vol=$5
 db $10 ; $003C: dataColumn_0 (non hard), vol=$4
 db $0D ; $003D: dataColumn_0 (hard)
 dw instrument0loopHighscoreMusik ; $003E: [$001E] loop
instrument2HighscoreMusik:
 db $01 ; $0040: speed
 db $00 ; $0041: retrig
 db $BC ; $0042: dataColumn_0 (non hard), vol=$F
 dw $FFFF ; $0043: pitch
 db $BC ; $0045: dataColumn_0 (non hard), vol=$F
 dw $FFFE ; $0046: pitch
 db $B8 ; $0048: dataColumn_0 (non hard), vol=$E
 dw $0001 ; $0049: pitch
 db $34 ; $004B: dataColumn_0 (non hard), vol=$D
 db $AC ; $004C: dataColumn_0 (non hard), vol=$B
 dw $0001 ; $004D: pitch
 db $A0 ; $004F: dataColumn_0 (non hard), vol=$8
 dw $FFFE ; $0050: pitch
 db $A4 ; $0052: dataColumn_0 (non hard), vol=$9
 dw $FFFF ; $0053: pitch
 db $20 ; $0055: dataColumn_0 (non hard), vol=$8
 db $9C ; $0056: dataColumn_0 (non hard), vol=$7
 dw $0002 ; $0057: pitch
 db $0D ; $0059: dataColumn_0 (hard)
 dw instrument0loopHighscoreMusik ; $005A: [$001E] loop
instrument3HighscoreMusik:
 db $01 ; $005C: speed
 db $00 ; $005D: retrig
 db $7E ; $005E: dataColumn_0 (non hard), vol=$F
 db $37 ; $005F: dataColumn_1, noise=$17
 db $F6 ; $0060: arpegio
 db $7C ; $0061: dataColumn_0 (non hard), vol=$F
 db $DB ; $0062: arpegio
 db $5C ; $0063: dataColumn_0 (non hard), vol=$7
 db $DF ; $0064: arpegio
 db $78 ; $0065: dataColumn_0 (non hard), vol=$E
 db $D8 ; $0066: arpegio
 db $6C ; $0067: dataColumn_0 (non hard), vol=$B
 db $CD ; $0068: arpegio
 db $1E ; $0069: dataColumn_0 (non hard), vol=$7
 db $01 ; $006A: dataColumn_1, noise=$01
 db $0D ; $006B: dataColumn_0 (hard)
 dw instrument0loopHighscoreMusik ; $006C: [$001E] loop
instrument4HighscoreMusik:
 db $01 ; $006E: speed
 db $00 ; $006F: retrig
 db $16 ; $0070: dataColumn_0 (non hard), vol=$5
 db $01 ; $0071: dataColumn_1, noise=$01
 db $2A ; $0072: dataColumn_0 (non hard), vol=$A
 db $01 ; $0073: dataColumn_1, noise=$01
 db $02 ; $0074: dataColumn_0 (non hard), vol=$0
 db $20 ; $0075: dataColumn_1
 db $0D ; $0076: dataColumn_0 (hard)
 dw instrument0loopHighscoreMusik ; $0077: [$001E] loop
instrument5HighscoreMusik:
 db $01 ; $0079: speed
 db $00 ; $007A: retrig
 db $3E ; $007B: dataColumn_0 (non hard), vol=$F
 db $3F ; $007C: dataColumn_1, noise=$1F
 db $3E ; $007D: dataColumn_0 (non hard), vol=$F
 db $00 ; $007E: dataColumn_1
 db $0E ; $007F: dataColumn_0 (non hard), vol=$3
 db $31 ; $0080: dataColumn_1, noise=$11
 db $32 ; $0081: dataColumn_0 (non hard), vol=$C
 db $0A ; $0082: dataColumn_1, noise=$0A
 db $12 ; $0083: dataColumn_0 (non hard), vol=$4
 db $26 ; $0084: dataColumn_1, noise=$06
 db $2E ; $0085: dataColumn_0 (non hard), vol=$B
 db $1D ; $0086: dataColumn_1, noise=$1D
 db $2E ; $0087: dataColumn_0 (non hard), vol=$B
 db $28 ; $0088: dataColumn_1, noise=$08
 db $1E ; $0089: dataColumn_0 (non hard), vol=$7
 db $09 ; $008A: dataColumn_1, noise=$09
 db $12 ; $008B: dataColumn_0 (non hard), vol=$4
 db $27 ; $008C: dataColumn_1, noise=$07
 db $52 ; $008D: dataColumn_0 (non hard), vol=$4
 db $24 ; $008E: dataColumn_1, noise=$04
 db $0C ; $008F: arpegio
 db $12 ; $0090: dataColumn_0 (non hard), vol=$4
 db $01 ; $0091: dataColumn_1, noise=$01
 db $4C ; $0092: dataColumn_0 (non hard), vol=$3
 db $0C ; $0093: arpegio
 db $0A ; $0094: dataColumn_0 (non hard), vol=$2
 db $21 ; $0095: dataColumn_1, noise=$01
 db $48 ; $0096: dataColumn_0 (non hard), vol=$2
 db $0C ; $0097: arpegio
 db $0D ; $0098: dataColumn_0 (hard)
 dw instrument0loopHighscoreMusik ; $0099: [$001E] loop
instrument6HighscoreMusik:
 db $02 ; $009B: speed
 db $00 ; $009C: retrig
 db $26 ; $009D: dataColumn_0 (non hard), vol=$9
 db $01 ; $009E: dataColumn_1, noise=$01
 db $16 ; $009F: dataColumn_0 (non hard), vol=$5
 db $02 ; $00A0: dataColumn_1, noise=$02
 db $0D ; $00A1: dataColumn_0 (hard)
 dw instrument0loopHighscoreMusik ; $00A2: [$001E] loop
instrument7HighscoreMusik:
 db $01 ; $00A4: speed
 db $00 ; $00A5: retrig
instrument7loopHighscoreMusik:
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
 dw instrument7loopHighscoreMusik ; $00BB: [$00A6] loop
; start of linker definition
linkerHighscoreMusik:
 db $10 ; $00BD: first height
 db $00 ; $00BE: transposition1
 db $00 ; $00BF: transposition2
 db $00 ; $00C0: transposition3
 dw specialtrackDef0HighscoreMusik ; $00C1: [$0136] specialTrack
pattern0DefinitionHighscoreMusik:
 db $00 ; $00C3: pattern 0 state
 dw trackDef0HighscoreMusik ; $00C4: [$013D] pattern 0, track 1
 dw trackDef1HighscoreMusik ; $00C6: [$0159] pattern 0, track 2
 dw trackDef2HighscoreMusik ; $00C8: [$017C] pattern 0, track 3
pattern1DefinitionHighscoreMusik:
 db $00 ; $00CA: pattern 1 state
 dw trackDef0HighscoreMusik ; $00CB: [$013D] pattern 1, track 1
 dw trackDef1HighscoreMusik ; $00CD: [$0159] pattern 1, track 2
 dw trackDef2HighscoreMusik ; $00CF: [$017C] pattern 1, track 3
pattern2DefinitionHighscoreMusik:
 db $00 ; $00D1: pattern 2 state
 dw trackDef0HighscoreMusik ; $00D2: [$013D] pattern 2, track 1
 dw trackDef1HighscoreMusik ; $00D4: [$0159] pattern 2, track 2
 dw trackDef2HighscoreMusik ; $00D6: [$017C] pattern 2, track 3
pattern3DefinitionHighscoreMusik:
 db $00 ; $00D8: pattern 3 state
 dw trackDef0HighscoreMusik ; $00D9: [$013D] pattern 3, track 1
 dw trackDef1HighscoreMusik ; $00DB: [$0159] pattern 3, track 2
 dw trackDef2HighscoreMusik ; $00DD: [$017C] pattern 3, track 3
pattern4DefinitionHighscoreMusik:
 db $00 ; $00DF: pattern 4 state
 dw trackDef0HighscoreMusik ; $00E0: [$013D] pattern 4, track 1
 dw trackDef1HighscoreMusik ; $00E2: [$0159] pattern 4, track 2
 dw trackDef2HighscoreMusik ; $00E4: [$017C] pattern 4, track 3
pattern5DefinitionHighscoreMusik:
 db $00 ; $00E6: pattern 5 state
 dw trackDef0HighscoreMusik ; $00E7: [$013D] pattern 5, track 1
 dw trackDef1HighscoreMusik ; $00E9: [$0159] pattern 5, track 2
 dw trackDef2HighscoreMusik ; $00EB: [$017C] pattern 5, track 3
pattern6DefinitionHighscoreMusik:
 db $00 ; $00ED: pattern 6 state
 dw trackDef0HighscoreMusik ; $00EE: [$013D] pattern 6, track 1
 dw trackDef1HighscoreMusik ; $00F0: [$0159] pattern 6, track 2
 dw trackDef2HighscoreMusik ; $00F2: [$017C] pattern 6, track 3
pattern7DefinitionHighscoreMusik:
 db $00 ; $00F4: pattern 7 state
 dw trackDef0HighscoreMusik ; $00F5: [$013D] pattern 7, track 1
 dw trackDef1HighscoreMusik ; $00F7: [$0159] pattern 7, track 2
 dw trackDef2HighscoreMusik ; $00F9: [$017C] pattern 7, track 3
pattern8DefinitionHighscoreMusik:
 db $00 ; $00FB: pattern 8 state
 dw trackDef0HighscoreMusik ; $00FC: [$013D] pattern 8, track 1
 dw trackDef10HighscoreMusik ; $00FE: [$019F] pattern 8, track 2
 dw trackDef2HighscoreMusik ; $0100: [$017C] pattern 8, track 3
pattern9DefinitionHighscoreMusik:
 db $00 ; $0102: pattern 9 state
 dw trackDef0HighscoreMusik ; $0103: [$013D] pattern 9, track 1
 dw trackDef11HighscoreMusik ; $0105: [$01C2] pattern 9, track 2
 dw trackDef2HighscoreMusik ; $0107: [$017C] pattern 9, track 3
pattern10DefinitionHighscoreMusik:
 db $00 ; $0109: pattern 10 state
 dw trackDef0HighscoreMusik ; $010A: [$013D] pattern 10, track 1
 dw trackDef11HighscoreMusik ; $010C: [$01C2] pattern 10, track 2
 dw trackDef2HighscoreMusik ; $010E: [$017C] pattern 10, track 3
pattern11DefinitionHighscoreMusik:
 db $00 ; $0110: pattern 11 state
 dw trackDef0HighscoreMusik ; $0111: [$013D] pattern 11, track 1
 dw trackDef13HighscoreMusik ; $0113: [$01E4] pattern 11, track 2
 dw trackDef2HighscoreMusik ; $0115: [$017C] pattern 11, track 3
pattern12DefinitionHighscoreMusik:
 db $00 ; $0117: pattern 12 state
 dw trackDef0HighscoreMusik ; $0118: [$013D] pattern 12, track 1
 dw trackDef14HighscoreMusik ; $011A: [$0138] pattern 12, track 2
 dw trackDef2HighscoreMusik ; $011C: [$017C] pattern 12, track 3
pattern13DefinitionHighscoreMusik:
 db $00 ; $011E: pattern 13 state
 dw trackDef0HighscoreMusik ; $011F: [$013D] pattern 13, track 1
 dw trackDef14HighscoreMusik ; $0121: [$0138] pattern 13, track 2
 dw trackDef2HighscoreMusik ; $0123: [$017C] pattern 13, track 3
pattern14DefinitionHighscoreMusik:
 db $00 ; $0125: pattern 14 state
 dw trackDef0HighscoreMusik ; $0126: [$013D] pattern 14, track 1
 dw trackDef14HighscoreMusik ; $0128: [$0138] pattern 14, track 2
 dw trackDef2HighscoreMusik ; $012A: [$017C] pattern 14, track 3
pattern15DefinitionHighscoreMusik:
 db $00 ; $012C: pattern 15 state
 dw trackDef0HighscoreMusik ; $012D: [$013D] pattern 15, track 1
 dw trackDef14HighscoreMusik ; $012F: [$0138] pattern 15, track 2
 dw trackDef2HighscoreMusik ; $0131: [$017C] pattern 15, track 3
pattern16DefinitionHighscoreMusik:
 db $01 ; $0133: pattern 16 state
 dw pattern0DefinitionHighscoreMusik ; $0134: [$00C3] song restart address
specialtrackDef0HighscoreMusik:
 db $1D ; $0136: data, speed 7
 db $00 ; $0137: wait 128
trackDef14HighscoreMusik:
 db $42 ; $0138: normal track data
 db $80 ; $0139: vol off, pitch, no note, no instrument
 dw $0000 ; $013A: pitch
 db $00 ; $013C: track end signature found
trackDef0HighscoreMusik:
 db $62 ; $013D: normal track data
 db $E0 ; $013E: vol off, pitch, note, instrument
 dw $0000 ; $013F: pitch
 db $01 ; $0141: instrument
 db $42 ; $0142: normal track data
 db $00 ; $0143: vol off, no pitch, no note, no instrument
 db $42 ; $0144: normal track data
 db $00 ; $0145: vol off, no pitch, no note, no instrument
 db $02 ; $0146: normal track data,  wait 0
 db $3B ; $0147: full optimization, no escape: E2
 db $02 ; $0148: normal track data,  wait 0
 db $42 ; $0149: normal track data
 db $00 ; $014A: vol off, no pitch, no note, no instrument
 db $37 ; $014B: full optimization, no escape: D2
 db $42 ; $014C: normal track data
 db $00 ; $014D: vol off, no pitch, no note, no instrument
 db $42 ; $014E: normal track data
 db $00 ; $014F: vol off, no pitch, no note, no instrument
 db $3B ; $0150: full optimization, no escape: E2
 db $42 ; $0151: normal track data
 db $00 ; $0152: vol off, no pitch, no note, no instrument
 db $31 ; $0153: full optimization, no escape: B1
 db $42 ; $0154: normal track data
 db $00 ; $0155: vol off, no pitch, no note, no instrument
 db $37 ; $0156: full optimization, no escape: D2
 db $42 ; $0157: normal track data
 db $00 ; $0158: vol off, no pitch, no note, no instrument
trackDef1HighscoreMusik:
 db $7A ; $0159: normal track data
 db $E1 ; $015A: vol = $F (inverted), no pitch, no note, no instrument
 dw $0000 ; $015B: pitch
 db $02 ; $015D: instrument
 db $8E ; $015E: normal track data
 db $4B ; $015F: vol = $A (inverted), no pitch, no note, no instrument
 db $92 ; $0160: normal track data
 db $41 ; $0161: vol = $F (inverted), no pitch, no note, no instrument
 db $7A ; $0162: normal track data
 db $4B ; $0163: vol = $A (inverted), no pitch, no note, no instrument
 db $8E ; $0164: normal track data
 db $41 ; $0165: vol = $F (inverted), no pitch, no note, no instrument
 db $92 ; $0166: normal track data
 db $4B ; $0167: vol = $A (inverted), no pitch, no note, no instrument
 db $92 ; $0168: normal track data
 db $41 ; $0169: vol = $F (inverted), no pitch, no note, no instrument
 db $8E ; $016A: normal track data
 db $4B ; $016B: vol = $A (inverted), no pitch, no note, no instrument
 db $9C ; $016C: normal track data
 db $41 ; $016D: vol = $F (inverted), no pitch, no note, no instrument
 db $92 ; $016E: normal track data
 db $4B ; $016F: vol = $A (inverted), no pitch, no note, no instrument
 db $A0 ; $0170: normal track data
 db $41 ; $0171: vol = $F (inverted), no pitch, no note, no instrument
 db $9C ; $0172: normal track data
 db $4B ; $0173: vol = $A (inverted), no pitch, no note, no instrument
 db $88 ; $0174: normal track data
 db $41 ; $0175: vol = $F (inverted), no pitch, no note, no instrument
 db $A0 ; $0176: normal track data
 db $4B ; $0177: vol = $A (inverted), no pitch, no note, no instrument
 db $8E ; $0178: normal track data
 db $41 ; $0179: vol = $F (inverted), no pitch, no note, no instrument
 db $88 ; $017A: normal track data
 db $4B ; $017B: vol = $A (inverted), no pitch, no note, no instrument
trackDef2HighscoreMusik:
 db $BA ; $017C: normal track data
 db $E1 ; $017D: vol = $F (inverted), no pitch, no note, no instrument
 dw $0000 ; $017E: pitch
 db $03 ; $0180: instrument
 db $02 ; $0181: normal track data,  wait 0
 db $8A ; $0182: normal track data
 db $60 ; $0183: vol off, no pitch, note, instrument
 db $04 ; $0184: instrument
 db $02 ; $0185: normal track data,  wait 0
 db $A2 ; $0186: normal track data
 db $60 ; $0187: vol off, no pitch, note, instrument
 db $05 ; $0188: instrument
 db $02 ; $0189: normal track data,  wait 0
 db $8A ; $018A: normal track data
 db $60 ; $018B: vol off, no pitch, note, instrument
 db $06 ; $018C: instrument
 db $42 ; $018D: normal track data
 db $00 ; $018E: vol off, no pitch, no note, no instrument
 db $8A ; $018F: normal track data
 db $60 ; $0190: vol off, no pitch, note, instrument
 db $04 ; $0191: instrument
 db $02 ; $0192: normal track data,  wait 0
 db $BA ; $0193: normal track data
 db $60 ; $0194: vol off, no pitch, note, instrument
 db $03 ; $0195: instrument
 db $02 ; $0196: normal track data,  wait 0
 db $A2 ; $0197: normal track data
 db $60 ; $0198: vol off, no pitch, note, instrument
 db $05 ; $0199: instrument
 db $02 ; $019A: normal track data,  wait 0
 db $8A ; $019B: normal track data
 db $60 ; $019C: vol off, no pitch, note, instrument
 db $06 ; $019D: instrument
 db $00 ; $019E: track end signature found
trackDef10HighscoreMusik:
 db $92 ; $019F: normal track data,  note: E3
 db $E7 ; $01A0: vol = $C (inverted), no pitch, no note, no instrument
 dw $0001 ; $01A1: pitch
 db $07 ; $01A3: instrument
 db $42 ; $01A4: normal track data,  note: C0
 db $05 ; $01A5: vol = $D (inverted), no pitch, no note, no instrument
 db $42 ; $01A6: normal track data
 db $03 ; $01A7: vol = $E (inverted), no pitch, no note, no instrument
 db $42 ; $01A8: normal track data
 db $01 ; $01A9: vol = $F (inverted), no pitch, no note, no instrument
 db $42 ; $01AA: normal track data
 db $00 ; $01AB: vol off, no pitch, no note, no instrument
 db $42 ; $01AC: normal track data
 db $00 ; $01AD: vol off, no pitch, no note, no instrument
 db $42 ; $01AE: normal track data
 db $00 ; $01AF: vol off, no pitch, no note, no instrument
 db $42 ; $01B0: normal track data
 db $00 ; $01B1: vol off, no pitch, no note, no instrument
 db $42 ; $01B2: normal track data
 db $00 ; $01B3: vol off, no pitch, no note, no instrument
 db $42 ; $01B4: normal track data
 db $00 ; $01B5: vol off, no pitch, no note, no instrument
 db $42 ; $01B6: normal track data
 db $00 ; $01B7: vol off, no pitch, no note, no instrument
 db $42 ; $01B8: normal track data
 db $00 ; $01B9: vol off, no pitch, no note, no instrument
 db $42 ; $01BA: normal track data
 db $00 ; $01BB: vol off, no pitch, no note, no instrument
 db $42 ; $01BC: normal track data
 db $00 ; $01BD: vol off, no pitch, no note, no instrument
 db $42 ; $01BE: normal track data
 db $00 ; $01BF: vol off, no pitch, no note, no instrument
 db $42 ; $01C0: normal track data
 db $00 ; $01C1: vol off, no pitch, no note, no instrument
trackDef11HighscoreMusik:
 db $42 ; $01C2: normal track data
 db $80 ; $01C3: vol off, pitch, no note, no instrument
 dw $0001 ; $01C4: pitch
 db $42 ; $01C6: normal track data
 db $00 ; $01C7: vol off, no pitch, no note, no instrument
 db $42 ; $01C8: normal track data
 db $00 ; $01C9: vol off, no pitch, no note, no instrument
 db $42 ; $01CA: normal track data
 db $00 ; $01CB: vol off, no pitch, no note, no instrument
 db $42 ; $01CC: normal track data
 db $00 ; $01CD: vol off, no pitch, no note, no instrument
 db $42 ; $01CE: normal track data
 db $00 ; $01CF: vol off, no pitch, no note, no instrument
 db $42 ; $01D0: normal track data
 db $00 ; $01D1: vol off, no pitch, no note, no instrument
 db $42 ; $01D2: normal track data
 db $00 ; $01D3: vol off, no pitch, no note, no instrument
 db $42 ; $01D4: normal track data
 db $00 ; $01D5: vol off, no pitch, no note, no instrument
 db $42 ; $01D6: normal track data
 db $00 ; $01D7: vol off, no pitch, no note, no instrument
 db $42 ; $01D8: normal track data
 db $00 ; $01D9: vol off, no pitch, no note, no instrument
 db $42 ; $01DA: normal track data
 db $00 ; $01DB: vol off, no pitch, no note, no instrument
 db $42 ; $01DC: normal track data
 db $00 ; $01DD: vol off, no pitch, no note, no instrument
 db $42 ; $01DE: normal track data
 db $00 ; $01DF: vol off, no pitch, no note, no instrument
 db $42 ; $01E0: normal track data
 db $00 ; $01E1: vol off, no pitch, no note, no instrument
 db $42 ; $01E2: normal track data
 db $00 ; $01E3: vol off, no pitch, no note, no instrument
trackDef13HighscoreMusik:
 db $42 ; $01E4: normal track data
 db $83 ; $01E5: vol = $E (inverted), no pitch, no note, no instrument
 dw $0000 ; $01E6: pitch
 db $42 ; $01E8: normal track data,  note: C0
 db $05 ; $01E9: vol = $D (inverted), no pitch, no note, no instrument
 db $42 ; $01EA: normal track data,  note: C0
 db $07 ; $01EB: vol = $C (inverted), no pitch, no note, no instrument
 db $02 ; $01EC: normal track data,  wait 0
 db $42 ; $01ED: normal track data
 db $09 ; $01EE: vol = $B (inverted), no pitch, no note, no instrument
 db $42 ; $01EF: normal track data
 db $0B ; $01F0: vol = $A (inverted), no pitch, no note, no instrument
 db $42 ; $01F1: normal track data,  note: C0
 db $0D ; $01F2: vol = $9 (inverted), no pitch, no note, no instrument
 db $02 ; $01F3: normal track data,  wait 0
 db $42 ; $01F4: normal track data,  note: C0
 db $0F ; $01F5: vol = $8 (inverted), no pitch, no note, no instrument
 db $42 ; $01F6: normal track data
 db $11 ; $01F7: vol = $7 (inverted), no pitch, no note, no instrument
 db $42 ; $01F8: normal track data
 db $13 ; $01F9: vol = $6 (inverted), no pitch, no note, no instrument
 db $42 ; $01FA: normal track data,  note: C0
 db $15 ; $01FB: vol = $5 (inverted), no pitch, no note, no instrument
 db $42 ; $01FC: normal track data,  note: C0
 db $17 ; $01FD: vol = $4 (inverted), no pitch, no note, no instrument
 db $42 ; $01FE: normal track data
 db $19 ; $01FF: vol = $3 (inverted), no pitch, no note, no instrument
 db $42 ; $0200: normal track data
 db $1B ; $0201: vol = $2 (inverted), no pitch, no note, no instrument
 db $42 ; $0202: normal track data,  note: C0
 db $1F ; $0203: vol = $0 (inverted), no pitch, no note, no instrument