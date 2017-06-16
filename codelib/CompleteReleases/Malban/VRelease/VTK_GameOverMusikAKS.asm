; this file is part of Release, written by Malban in 2017
;

; This file was build using VIDE - Vectrex Integrated Development Environment
; Original bin file was: projects/VRelease/VTK_GameOverMusik.bin
; 
; offset for AKS file assumed: $0000 guessed by accessing byte data[13] * 256)
; not used by vectrex player and therefor omitted:
;  DB "AT10" ; Signature of Arkos Tracker files
;  DB $01 ; sample channel
;  DB $40, 42, 0f ; YM custom frequence - little endian
;  DB $02 ; Replay frequency (0=13hz,1=25hz,2=50hz,3=100hz,4=150hz,5=300hz)
 db $06 ; $0009: default speed
 dw $0095 ; $000A: size of instrument table (without this word pointer)
 dw instrument0GameOverMusik ; $000C: [$0014] pointer to instrument 0
 dw instrument1GameOverMusik ; $000E: [$001D] pointer to instrument 1
 dw instrument2GameOverMusik ; $0010: [$0057] pointer to instrument 2
 dw instrument3GameOverMusik ; $0012: [$007E] pointer to instrument 3
instrument0GameOverMusik:
 db $00 ; $0014: speed
 db $00 ; $0015: retrig
instrument0loopGameOverMusik:
 db $00 ; $0016: dataColumn_0 (non hard), vol=$0
 db $00 ; $0017: dataColumn_0 (non hard), vol=$0
 db $00 ; $0018: dataColumn_0 (non hard), vol=$0
 db $00 ; $0019: dataColumn_0 (non hard), vol=$0
 db $0D ; $001A: dataColumn_0 (hard)
 dw instrument0loopGameOverMusik ; $001B: [$0016] loop
instrument1GameOverMusik:
 db $05 ; $001D: speed
 db $00 ; $001E: retrig
 db $34 ; $001F: dataColumn_0 (non hard), vol=$D
 db $B0 ; $0020: dataColumn_0 (non hard), vol=$C
 dw $FFFF ; $0021: pitch
 db $30 ; $0023: dataColumn_0 (non hard), vol=$C
instrument1loopGameOverMusik:
 db $AC ; $0024: dataColumn_0 (non hard), vol=$B
 dw $FFFF ; $0025: pitch
 db $AC ; $0027: dataColumn_0 (non hard), vol=$B
 dw $FFFE ; $0028: pitch
 db $AC ; $002A: dataColumn_0 (non hard), vol=$B
 dw $0001 ; $002B: pitch
 db $AC ; $002D: dataColumn_0 (non hard), vol=$B
 dw $FFFE ; $002E: pitch
 db $AC ; $0030: dataColumn_0 (non hard), vol=$B
 dw $FFFF ; $0031: pitch
 db $AC ; $0033: dataColumn_0 (non hard), vol=$B
 dw $FFFE ; $0034: pitch
 db $AC ; $0036: dataColumn_0 (non hard), vol=$B
 dw $0001 ; $0037: pitch
 db $2C ; $0039: dataColumn_0 (non hard), vol=$B
 db $AC ; $003A: dataColumn_0 (non hard), vol=$B
 dw $FFFE ; $003B: pitch
 db $2C ; $003D: dataColumn_0 (non hard), vol=$B
 db $AC ; $003E: dataColumn_0 (non hard), vol=$B
 dw $FFFF ; $003F: pitch
 db $AC ; $0041: dataColumn_0 (non hard), vol=$B
 dw $FFFE ; $0042: pitch
 db $2C ; $0044: dataColumn_0 (non hard), vol=$B
 db $AC ; $0045: dataColumn_0 (non hard), vol=$B
 dw $0001 ; $0046: pitch
 db $AC ; $0048: dataColumn_0 (non hard), vol=$B
 dw $FFFE ; $0049: pitch
 db $2C ; $004B: dataColumn_0 (non hard), vol=$B
 db $AC ; $004C: dataColumn_0 (non hard), vol=$B
 dw $FFFE ; $004D: pitch
 db $2C ; $004F: dataColumn_0 (non hard), vol=$B
 db $AC ; $0050: dataColumn_0 (non hard), vol=$B
 dw $FFFE ; $0051: pitch
 db $2C ; $0053: dataColumn_0 (non hard), vol=$B
 db $0D ; $0054: dataColumn_0 (hard)
 dw instrument1loopGameOverMusik ; $0055: [$0024] loop
instrument2GameOverMusik:
 db $02 ; $0057: speed
 db $00 ; $0058: retrig
 db $A0 ; $0059: dataColumn_0 (non hard), vol=$8
 dw $FFFF ; $005A: pitch
 db $68 ; $005C: dataColumn_0 (non hard), vol=$A
 db $03 ; $005D: arpegio
instrument2loopGameOverMusik:
 db $EC ; $005E: dataColumn_0 (non hard), vol=$B
 dw $0001 ; $005F: pitch
 db $01 ; $0061: arpegio
 db $68 ; $0062: dataColumn_0 (non hard), vol=$A
 db $FF ; $0063: arpegio
 db $98 ; $0064: dataColumn_0 (non hard), vol=$6
 dw $0001 ; $0065: pitch
 db $A8 ; $0067: dataColumn_0 (non hard), vol=$A
 dw $FFFD ; $0068: pitch
 db $5C ; $006A: dataColumn_0 (non hard), vol=$7
 db $02 ; $006B: arpegio
 db $1C ; $006C: dataColumn_0 (non hard), vol=$7
 db $E8 ; $006D: dataColumn_0 (non hard), vol=$A
 dw $FFFF ; $006E: pitch
 db $02 ; $0070: arpegio
 db $18 ; $0071: dataColumn_0 (non hard), vol=$6
 db $E4 ; $0072: dataColumn_0 (non hard), vol=$9
 dw $FFFF ; $0073: pitch
 db $03 ; $0075: arpegio
 db $24 ; $0076: dataColumn_0 (non hard), vol=$9
 db $EC ; $0077: dataColumn_0 (non hard), vol=$B
 dw $FFFD ; $0078: pitch
 db $01 ; $007A: arpegio
 db $0D ; $007B: dataColumn_0 (hard)
 dw instrument2loopGameOverMusik ; $007C: [$005E] loop
instrument3GameOverMusik:
 db $02 ; $007E: speed
 db $00 ; $007F: retrig
 db $B0 ; $0080: dataColumn_0 (non hard), vol=$C
 dw $FFFF ; $0081: pitch
 db $30 ; $0083: dataColumn_0 (non hard), vol=$C
instrument3loopGameOverMusik:
 db $F0 ; $0084: dataColumn_0 (non hard), vol=$C
 dw $0001 ; $0085: pitch
 db $01 ; $0087: arpegio
 db $70 ; $0088: dataColumn_0 (non hard), vol=$C
 db $FF ; $0089: arpegio
 db $B0 ; $008A: dataColumn_0 (non hard), vol=$C
 dw $0001 ; $008B: pitch
 db $30 ; $008D: dataColumn_0 (non hard), vol=$C
 db $70 ; $008E: dataColumn_0 (non hard), vol=$C
 db $01 ; $008F: arpegio
 db $30 ; $0090: dataColumn_0 (non hard), vol=$C
 db $B0 ; $0091: dataColumn_0 (non hard), vol=$C
 dw $FFFF ; $0092: pitch
 db $30 ; $0094: dataColumn_0 (non hard), vol=$C
 db $F0 ; $0095: dataColumn_0 (non hard), vol=$C
 dw $FFFF ; $0096: pitch
 db $01 ; $0098: arpegio
 db $30 ; $0099: dataColumn_0 (non hard), vol=$C
 db $F0 ; $009A: dataColumn_0 (non hard), vol=$C
 dw $FFFF ; $009B: pitch
 db $01 ; $009D: arpegio
 db $0D ; $009E: dataColumn_0 (hard)
 dw instrument3loopGameOverMusik ; $009F: [$0084] loop
; start of linker definition
linkerGameOverMusik:
 db $10 ; $00A1: first height
 db $00 ; $00A2: transposition1
 db $00 ; $00A3: transposition2
 db $00 ; $00A4: transposition3
 dw specialtrackDef0GameOverMusik ; $00A5: [$00BF] specialTrack
pattern0DefinitionGameOverMusik:
 db $00 ; $00A7: pattern 0 state
 dw trackDef0GameOverMusik ; $00A8: [$00C1] pattern 0, track 1
 dw trackDef1GameOverMusik ; $00AA: [$0109] pattern 0, track 2
 dw trackDef2GameOverMusik ; $00AC: [$00E4] pattern 0, track 3
pattern1DefinitionGameOverMusik:
 db $00 ; $00AE: pattern 1 state
 dw trackDef3GameOverMusik ; $00AF: [$014E] pattern 1, track 1
 dw trackDef4GameOverMusik ; $00B1: [$012C] pattern 1, track 2
 dw trackDef3GameOverMusik ; $00B3: [$014E] pattern 1, track 3
pattern2DefinitionGameOverMusik:
 db $00 ; $00B5: pattern 2 state
 dw trackDef5GameOverMusik ; $00B6: [$0172] pattern 2, track 1
 dw trackDef6GameOverMusik ; $00B8: [$0196] pattern 2, track 2
 dw trackDef5GameOverMusik ; $00BA: [$0172] pattern 2, track 3
pattern3DefinitionGameOverMusik:
 db $01 ; $00BC: pattern 3 state
 dw pattern0DefinitionGameOverMusik ; $00BD: [$00A7] song restart address
specialtrackDef0GameOverMusik:
 db $3D ; $00BF: data, speed 15
 db $00 ; $00C0: wait 128
trackDef0GameOverMusik:
 db $84 ; $00C1: normal track data,  note: A2
 db $E5 ; $00C2: vol = $D (inverted), no pitch, no note, no instrument
 dw $0004 ; $00C3: pitch
 db $01 ; $00C5: instrument
 db $42 ; $00C6: normal track data
 db $03 ; $00C7: vol = $E (inverted), no pitch, no note, no instrument
 db $42 ; $00C8: normal track data
 db $00 ; $00C9: vol off, no pitch, no note, no instrument
 db $42 ; $00CA: normal track data
 db $01 ; $00CB: vol = $F (inverted), no pitch, no note, no instrument
 db $42 ; $00CC: normal track data
 db $00 ; $00CD: vol off, no pitch, no note, no instrument
 db $42 ; $00CE: normal track data
 db $00 ; $00CF: vol off, no pitch, no note, no instrument
 db $42 ; $00D0: normal track data
 db $00 ; $00D1: vol off, no pitch, no note, no instrument
 db $42 ; $00D2: normal track data
 db $00 ; $00D3: vol off, no pitch, no note, no instrument
 db $42 ; $00D4: normal track data
 db $00 ; $00D5: vol off, no pitch, no note, no instrument
 db $42 ; $00D6: normal track data
 db $00 ; $00D7: vol off, no pitch, no note, no instrument
 db $42 ; $00D8: normal track data
 db $00 ; $00D9: vol off, no pitch, no note, no instrument
 db $42 ; $00DA: normal track data
 db $00 ; $00DB: vol off, no pitch, no note, no instrument
 db $42 ; $00DC: normal track data
 db $00 ; $00DD: vol off, no pitch, no note, no instrument
 db $42 ; $00DE: normal track data
 db $00 ; $00DF: vol off, no pitch, no note, no instrument
 db $42 ; $00E0: normal track data
 db $00 ; $00E1: vol off, no pitch, no note, no instrument
 db $42 ; $00E2: normal track data
 db $00 ; $00E3: vol off, no pitch, no note, no instrument
trackDef2GameOverMusik:
 db $84 ; $00E4: normal track data,  note: A2
 db $E7 ; $00E5: vol = $C (inverted), no pitch, no note, no instrument
 dw $0000 ; $00E6: pitch
 db $01 ; $00E8: instrument
 db $42 ; $00E9: normal track data,  note: C0
 db $85 ; $00EA: vol = $D (inverted), no pitch, no note, no instrument
 dw $0004 ; $00EB: pitch
 db $42 ; $00ED: normal track data
 db $03 ; $00EE: vol = $E (inverted), no pitch, no note, no instrument
 db $42 ; $00EF: normal track data
 db $00 ; $00F0: vol off, no pitch, no note, no instrument
 db $42 ; $00F1: normal track data
 db $01 ; $00F2: vol = $F (inverted), no pitch, no note, no instrument
 db $42 ; $00F3: normal track data
 db $00 ; $00F4: vol off, no pitch, no note, no instrument
 db $42 ; $00F5: normal track data
 db $00 ; $00F6: vol off, no pitch, no note, no instrument
 db $42 ; $00F7: normal track data
 db $00 ; $00F8: vol off, no pitch, no note, no instrument
 db $42 ; $00F9: normal track data
 db $00 ; $00FA: vol off, no pitch, no note, no instrument
 db $42 ; $00FB: normal track data
 db $00 ; $00FC: vol off, no pitch, no note, no instrument
 db $42 ; $00FD: normal track data
 db $00 ; $00FE: vol off, no pitch, no note, no instrument
 db $42 ; $00FF: normal track data
 db $00 ; $0100: vol off, no pitch, no note, no instrument
 db $42 ; $0101: normal track data
 db $00 ; $0102: vol off, no pitch, no note, no instrument
 db $42 ; $0103: normal track data
 db $00 ; $0104: vol off, no pitch, no note, no instrument
 db $42 ; $0105: normal track data
 db $00 ; $0106: vol off, no pitch, no note, no instrument
 db $42 ; $0107: normal track data
 db $00 ; $0108: vol off, no pitch, no note, no instrument
trackDef1GameOverMusik:
 db $B4 ; $0109: normal track data,  note: A4
 db $F5 ; $010A: vol = $5 (inverted), no pitch, no note, no instrument
 dw $FFFF ; $010B: pitch
 db $02 ; $010D: instrument
 db $42 ; $010E: normal track data
 db $00 ; $010F: vol off, no pitch, no note, no instrument
 db $42 ; $0110: normal track data
 db $13 ; $0111: vol = $6 (inverted), no pitch, no note, no instrument
 db $42 ; $0112: normal track data
 db $00 ; $0113: vol off, no pitch, no note, no instrument
 db $42 ; $0114: normal track data
 db $11 ; $0115: vol = $7 (inverted), no pitch, no note, no instrument
 db $42 ; $0116: normal track data
 db $00 ; $0117: vol off, no pitch, no note, no instrument
 db $42 ; $0118: normal track data,  note: C0
 db $0F ; $0119: vol = $8 (inverted), no pitch, no note, no instrument
 db $42 ; $011A: normal track data
 db $00 ; $011B: vol off, no pitch, no note, no instrument
 db $42 ; $011C: normal track data,  note: C0
 db $0D ; $011D: vol = $9 (inverted), no pitch, no note, no instrument
 db $42 ; $011E: normal track data
 db $00 ; $011F: vol off, no pitch, no note, no instrument
 db $42 ; $0120: normal track data
 db $0B ; $0121: vol = $A (inverted), no pitch, no note, no instrument
 db $42 ; $0122: normal track data
 db $00 ; $0123: vol off, no pitch, no note, no instrument
 db $42 ; $0124: normal track data
 db $09 ; $0125: vol = $B (inverted), no pitch, no note, no instrument
 db $42 ; $0126: normal track data
 db $00 ; $0127: vol off, no pitch, no note, no instrument
 db $42 ; $0128: normal track data,  note: C0
 db $07 ; $0129: vol = $C (inverted), no pitch, no note, no instrument
 db $42 ; $012A: normal track data
 db $00 ; $012B: vol off, no pitch, no note, no instrument
trackDef4GameOverMusik:
 db $42 ; $012C: normal track data,  note: C0
 db $85 ; $012D: vol = $D (inverted), no pitch, no note, no instrument
 dw $FFFF ; $012E: pitch
 db $42 ; $0130: normal track data
 db $00 ; $0131: vol off, no pitch, no note, no instrument
 db $42 ; $0132: normal track data
 db $03 ; $0133: vol = $E (inverted), no pitch, no note, no instrument
 db $42 ; $0134: normal track data
 db $00 ; $0135: vol off, no pitch, no note, no instrument
 db $42 ; $0136: normal track data
 db $00 ; $0137: vol off, no pitch, no note, no instrument
 db $42 ; $0138: normal track data
 db $00 ; $0139: vol off, no pitch, no note, no instrument
 db $42 ; $013A: normal track data
 db $00 ; $013B: vol off, no pitch, no note, no instrument
 db $42 ; $013C: normal track data
 db $00 ; $013D: vol off, no pitch, no note, no instrument
 db $42 ; $013E: normal track data
 db $00 ; $013F: vol off, no pitch, no note, no instrument
 db $42 ; $0140: normal track data,  note: C0
 db $05 ; $0141: vol = $D (inverted), no pitch, no note, no instrument
 db $42 ; $0142: normal track data,  note: C0
 db $07 ; $0143: vol = $C (inverted), no pitch, no note, no instrument
 db $42 ; $0144: normal track data
 db $09 ; $0145: vol = $B (inverted), no pitch, no note, no instrument
 db $42 ; $0146: normal track data
 db $0B ; $0147: vol = $A (inverted), no pitch, no note, no instrument
 db $42 ; $0148: normal track data,  note: C0
 db $0D ; $0149: vol = $9 (inverted), no pitch, no note, no instrument
 db $42 ; $014A: normal track data,  note: C0
 db $0F ; $014B: vol = $8 (inverted), no pitch, no note, no instrument
 db $42 ; $014C: normal track data
 db $11 ; $014D: vol = $7 (inverted), no pitch, no note, no instrument
trackDef3GameOverMusik:
 db $42 ; $014E: normal track data
 db $80 ; $014F: vol off, pitch, no note, no instrument
 dw $0004 ; $0150: pitch
 db $42 ; $0152: normal track data
 db $00 ; $0153: vol off, no pitch, no note, no instrument
 db $42 ; $0154: normal track data
 db $00 ; $0155: vol off, no pitch, no note, no instrument
 db $42 ; $0156: normal track data
 db $00 ; $0157: vol off, no pitch, no note, no instrument
 db $42 ; $0158: normal track data
 db $00 ; $0159: vol off, no pitch, no note, no instrument
 db $42 ; $015A: normal track data
 db $00 ; $015B: vol off, no pitch, no note, no instrument
 db $42 ; $015C: normal track data
 db $00 ; $015D: vol off, no pitch, no note, no instrument
 db $42 ; $015E: normal track data
 db $00 ; $015F: vol off, no pitch, no note, no instrument
 db $42 ; $0160: normal track data
 db $00 ; $0161: vol off, no pitch, no note, no instrument
 db $42 ; $0162: normal track data
 db $00 ; $0163: vol off, no pitch, no note, no instrument
 db $42 ; $0164: normal track data
 db $00 ; $0165: vol off, no pitch, no note, no instrument
 db $42 ; $0166: normal track data
 db $00 ; $0167: vol off, no pitch, no note, no instrument
 db $42 ; $0168: normal track data
 db $00 ; $0169: vol off, no pitch, no note, no instrument
 db $42 ; $016A: normal track data
 db $00 ; $016B: vol off, no pitch, no note, no instrument
 db $42 ; $016C: normal track data
 db $00 ; $016D: vol off, no pitch, no note, no instrument
 db $42 ; $016E: normal track data
 db $80 ; $016F: vol off, pitch, no note, no instrument
 dw $0000 ; $0170: pitch
trackDef5GameOverMusik:
 db $42 ; $0172: normal track data
 db $83 ; $0173: vol = $E (inverted), no pitch, no note, no instrument
 dw $0004 ; $0174: pitch
 db $42 ; $0176: normal track data,  note: C0
 db $05 ; $0177: vol = $D (inverted), no pitch, no note, no instrument
 db $42 ; $0178: normal track data,  note: C0
 db $07 ; $0179: vol = $C (inverted), no pitch, no note, no instrument
 db $42 ; $017A: normal track data
 db $09 ; $017B: vol = $B (inverted), no pitch, no note, no instrument
 db $42 ; $017C: normal track data
 db $0B ; $017D: vol = $A (inverted), no pitch, no note, no instrument
 db $42 ; $017E: normal track data,  note: C0
 db $0D ; $017F: vol = $9 (inverted), no pitch, no note, no instrument
 db $42 ; $0180: normal track data
 db $00 ; $0181: vol off, no pitch, no note, no instrument
 db $42 ; $0182: normal track data,  note: C0
 db $0F ; $0183: vol = $8 (inverted), no pitch, no note, no instrument
 db $42 ; $0184: normal track data
 db $11 ; $0185: vol = $7 (inverted), no pitch, no note, no instrument
 db $42 ; $0186: normal track data
 db $13 ; $0187: vol = $6 (inverted), no pitch, no note, no instrument
 db $42 ; $0188: normal track data,  note: C0
 db $15 ; $0189: vol = $5 (inverted), no pitch, no note, no instrument
 db $42 ; $018A: normal track data,  note: C0
 db $17 ; $018B: vol = $4 (inverted), no pitch, no note, no instrument
 db $42 ; $018C: normal track data
 db $19 ; $018D: vol = $3 (inverted), no pitch, no note, no instrument
 db $42 ; $018E: normal track data
 db $1B ; $018F: vol = $2 (inverted), no pitch, no note, no instrument
 db $42 ; $0190: normal track data,  note: C0
 db $1D ; $0191: vol = $1 (inverted), no pitch, no note, no instrument
 db $42 ; $0192: normal track data,  note: C0
 db $9F ; $0193: vol = $0 (inverted), no pitch, no note, no instrument
 dw $0000 ; $0194: pitch
trackDef6GameOverMusik:
 db $8A ; $0196: normal track data,  note: C3
 db $EF ; $0197: vol = $8 (inverted), no pitch, no note, no instrument
 dw $0022 ; $0198: pitch
 db $03 ; $019A: instrument
 db $42 ; $019B: normal track data,  note: C0
 db $0D ; $019C: vol = $9 (inverted), no pitch, no note, no instrument
 db $42 ; $019D: normal track data
 db $0B ; $019E: vol = $A (inverted), no pitch, no note, no instrument
 db $42 ; $019F: normal track data
 db $09 ; $01A0: vol = $B (inverted), no pitch, no note, no instrument
 db $42 ; $01A1: normal track data
 db $0B ; $01A2: vol = $A (inverted), no pitch, no note, no instrument
 db $42 ; $01A3: normal track data,  note: C0
 db $0D ; $01A4: vol = $9 (inverted), no pitch, no note, no instrument
 db $42 ; $01A5: normal track data
 db $00 ; $01A6: vol off, no pitch, no note, no instrument
 db $42 ; $01A7: normal track data
 db $00 ; $01A8: vol off, no pitch, no note, no instrument
 db $42 ; $01A9: normal track data
 db $00 ; $01AA: vol off, no pitch, no note, no instrument
 db $42 ; $01AB: normal track data,  note: C0
 db $0F ; $01AC: vol = $8 (inverted), no pitch, no note, no instrument
 db $42 ; $01AD: normal track data
 db $11 ; $01AE: vol = $7 (inverted), no pitch, no note, no instrument
 db $42 ; $01AF: normal track data
 db $13 ; $01B0: vol = $6 (inverted), no pitch, no note, no instrument
 db $42 ; $01B1: normal track data,  note: C0
 db $15 ; $01B2: vol = $5 (inverted), no pitch, no note, no instrument
 db $42 ; $01B3: normal track data,  note: C0
 db $17 ; $01B4: vol = $4 (inverted), no pitch, no note, no instrument
 db $42 ; $01B5: normal track data
 db $19 ; $01B6: vol = $3 (inverted), no pitch, no note, no instrument
 db $42 ; $01B7: normal track data,  note: C0
 db $9F ; $01B8: vol = $0 (inverted), no pitch, no note, no instrument
 dw $0000 ; $01B9: pitch