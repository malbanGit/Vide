; can be assembled correctly now
; compatibilty added by Malban
;
; assenmble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti prelude.asm >error
;
; used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
;
*       Notes on the production of music using the Vectrex music routines.

*       Each beat can have up to three voices.  The notes are listed together,
*       each but the last having its sign bit set.  There follows a duration.
*       It would appear that silence has a note value of 63.  One thing that
*       remains to be determined is how to produce new attacks while sustaining
*       other voices.  Apparently this is accomplished simply by letting the
*       envelop sustain a voice while another attack begins.

*       This early attempt turned out to be an exercise in manually
*       transcribing music (which I don't read well anyway) and typing.
*       The careful listener will detect at least two errors in my
*       transcription.

**      Public domain 1985 by Jeff Woolsey.

EXEC    EQU     $F000

        ORG     0

        DB     'g GCE 1812',$80
        FDB     MUSIC
        DB     $F8,$50,$40,$E0
        DB     'BACH',$80
        DB     $F8,$50,$20,$C0
        DB     'PRELUDE #1',$80
        DB     $F8,$50,$00,$E0
        DB     'WELL',$80
        DB     $F8,$50,$F0,$C8
        DB     'TEMPERED',$80
        DB     $F8,$50,$E0,$B8
        DB     'CLAVICHORD',$80
        DB     0

        LDD     #0
        STD     $CBFE           ;SET COLD BOOT (WASTE SOME TIME WHEN DONE)
        JMP     EXEC

*       ENVLOP  DB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*               DB     $FF,$EE,$DD,$CC,$BB,$AA,$99,$88

NVLOP1  DB     $FF,$FF,$EE,$EE,$DD,$DD,$CC,$CC
        DB     $BB,$BB,$AA,$AA,$99,$99,$88,$88

MUSIC   FDB     NVLOP1,$FEB6

        DB     $3F,100                 ;SET A SPELL

        DB     $BF,$BF,$18,7           ;MEASURE 1 BUMPED UP AN OCTAVE
        DB     $BF,$1C,7
        DB     $1F,7
        DB     $24,7
        DB     $A8,$1C,7
        DB     $1F,7
        DB     $24,7
        DB     $28,7
        DB     $BF,$BF,$18,7
        DB     $BF,$1C,7
        DB     $1F,7
        DB     $24,7
        DB     $A8,$1C,7
        DB     $1F,7
        DB     $24,7
        DB     $28,7

        DB     $BF,$BF,$18,7           ;MEASURE 2 BUMPED UP AN OCTAVE
        DB     $BF,$1A,7
        DB     $21,7
        DB     $26,7
        DB     $A9,$1A,7
        DB     $21,7
        DB     $26,7
        DB     $29,7
        DB     $BF,$BF,$18,7
        DB     $BF,$1A,7
        DB     $21,7
        DB     $26,7
        DB     $A9,$1A,7
        DB     $21,7
        DB     $26,7
        DB     $29,7

        DB     $BF,$BF,$17,7           ;MEASURE 3 BUMPED UP AN OCTAVE
        DB     $BF,$1A,7
        DB     $1F,7
        DB     $26,7
        DB     $A9,$1A,7
        DB     $1F,7
        DB     $26,7
        DB     $29,7
        DB     $BF,$BF,$17,7
        DB     $BF,$1A,7
        DB     $1F,7
        DB     $26,7
        DB     $A9,$1A,7
        DB     $1F,7
        DB     $26,7
        DB     $29,7

        DB     $BF,$BF,$18,7           ;MEASURE 4 BUMPED UP AN OCTAVE
        DB     $BF,$1C,7
        DB     $1F,7
        DB     $24,7
        DB     $A8,$1C,7
        DB     $1F,7
        DB     $24,7
        DB     $28,7
        DB     $BF,$BF,$18,7
        DB     $BF,$1C,7
        DB     $1F,7
        DB     $24,7
        DB     $A8,$1C,7
        DB     $1F,7
        DB     $24,7
        DB     $28,7

        DB     $BF,$BF,$18,7           ;MEASURE 5 BUMPED UP AN OCTAVE
        DB     $BF,$1C,7
        DB     $21,7
        DB     $28,7
        DB     $AD,$1C,7
        DB     $21,7
        DB     $28,7
        DB     $2D,7
        DB     $BF,$BF,$18,7
        DB     $BF,$1C,7
        DB     $21,7
        DB     $28,7
        DB     $AD,$1C,7
        DB     $21,7
        DB     $28,7
        DB     $2D,7

        DB     $BF,$BF,$18,7           ;MEASURE 6 BUMPED UP AN OCTAVE
        DB     $BF,$1A,7
        DB     $1E,7
        DB     $21,7
        DB     $A6,$1A,7
        DB     $1E,7
        DB     $21,7
        DB     $26,7
        DB     $BF,$BF,$18,7
        DB     $BF,$1A,7
        DB     $1E,7
        DB     $21,7
        DB     $A6,$1A,7
        DB     $1E,7
        DB     $21,7
        DB     $26,7

        DB     $BF,$BF,$17,7           ;MEASURE 7 BUMPED UP AN OCTAVE
        DB     $BF,$1A,7
        DB     $1F,7
        DB     $26,7
        DB     $AB,$1A,7
        DB     $1F,7
        DB     $26,7
        DB     $2B,7
        DB     $BF,$BF,$17,7
        DB     $BF,$1A,7
        DB     $1F,7
        DB     $26,7
        DB     $AB,$1A,7
        DB     $1F,7
        DB     $26,7
        DB     $2B,7

        DB     $BF,$BF,$17,7           ;MEASURE 8 BUMPED UP AN OCTAVE
        DB     $BF,$18,7
        DB     $1C,7
        DB     $1F,7
        DB     $A4,$18,7
        DB     $1C,7
        DB     $1F,7
        DB     $24,7
        DB     $BF,$BF,$17,7
        DB     $BF,$18,7
        DB     $1C,7
        DB     $1F,7
        DB     $A4,$18,7
        DB     $1C,7
        DB     $1F,7
        DB     $24,7

        DB     $BF,$BF,$15,7           ;MEASURE 9 BUMPED UP AN OCTAVE
        DB     $BF,$18,7
        DB     $1C,7
        DB     $1F,7
        DB     $A4,$18,7
        DB     $1C,7
        DB     $1F,7
        DB     $24,7
        DB     $BF,$BF,$15,7
        DB     $BF,$18,7
        DB     $1C,7
        DB     $1F,7
        DB     $A4,$18,7
        DB     $1C,7
        DB     $1F,7
        DB     $24,7

        DB     $BF,$BF,$0C,7           ;MEASURE 10 BUMPED UP AN OCTAVE
        DB     $BF,$15,7
        DB     $1A,7
        DB     $1D,7
        DB     $A4,$15,7
        DB     $1A,7
        DB     $1D,7
        DB     $24,7
        DB     $BF,$BF,$0C,7
        DB     $BF,$15,7
        DB     $1A,7
        DB     $1D,7
        DB     $A4,$15,7
        DB     $1A,7
        DB     $1D,7
        DB     $24,7

        DB     $BF,$BF,$13,7           ;MEASURE 11 BUMPED UP AN OCTAVE
        DB     $BF,$17,7
        DB     $1A,7
        DB     $1F,7
        DB     $A3,$17,7
        DB     $1A,7
        DB     $1F,7
        DB     $23,7
        DB     $BF,$BF,$13,7
        DB     $BF,$17,7
        DB     $1A,7
        DB     $1F,7
        DB     $A3,$17,7
        DB     $1A,7
        DB     $1F,7
        DB     $23,7

        DB     $BF,$BF,$13,7           ;MEASURE 12 BUMPED UP AN OCTAVE
        DB     $BF,$16,7
        DB     $1C,7
        DB     $1F,7
        DB     $A5,$16,7
        DB     $1C,7
        DB     $1F,7
        DB     $25,7
        DB     $BF,$BF,$13,7
        DB     $BF,$16,7
        DB     $1C,7
        DB     $1F,7
        DB     $A5,$16,7
        DB     $1C,7
        DB     $1F,7
        DB     $25,7

        DB     $BF,$BF,$11,7           ;MEASURE 13 BUMPED UP AN OCTAVE
        DB     $BF,$15,7
        DB     $1A,7
        DB     $21,7
        DB     $A6,$15,7
        DB     $1A,7
        DB     $21,7
        DB     $26,7
        DB     $BF,$BF,$11,7
        DB     $BF,$15,7
        DB     $1A,7
        DB     $21,7
        DB     $A6,$15,7
        DB     $1A,7
        DB     $21,7
        DB     $26,7

        DB     $BF,$BF,$11,7           ;MEASURE 14 BUMPED UP AN OCTAVE
        DB     $BF,$14,7
        DB     $1A,7
        DB     $1D,7
        DB     $A3,$14,7
        DB     $1A,7
        DB     $1D,7
        DB     $23,7
        DB     $BF,$BF,$11,7
        DB     $BF,$14,7
        DB     $1A,7
        DB     $1D,7
        DB     $A3,$14,7
        DB     $1A,7
        DB     $1D,7
        DB     $23,7

        DB     $BF,$BF,$10,7           ;MEASURE 15 BUMPED UP AN OCTAVE
        DB     $BF,$13,7
        DB     $18,7
        DB     $1F,7
        DB     $98,$13,7
        DB     $18,7
        DB     $1F,7
        DB     $24,7
        DB     $BF,$BF,$10,7
        DB     $BF,$13,7
        DB     $18,7
        DB     $1F,7
        DB     $98,$13,7
        DB     $18,7
        DB     $1F,7
        DB     $24,7

        DB     $BF,$BF,$10,7           ;MEASURE 16 BUMPED UP AN OCTAVE
        DB     $BF,$11,7
        DB     $15,7
        DB     $18,7
        DB     $9D,$11,7
        DB     $15,7
        DB     $18,7
        DB     $1D,7
        DB     $BF,$BF,$10,7
        DB     $BF,$11,7
        DB     $15,7
        DB     $18,7
        DB     $9D,$11,7
        DB     $15,7
        DB     $18,7
        DB     $1D,7

        DB     $BF,$BF,$0E,7           ;MEASURE 17 BUMPED UP AN OCTAVE
        DB     $BF,$11,7
        DB     $15,7
        DB     $18,7
        DB     $9D,$11,7
        DB     $15,7
        DB     $18,7
        DB     $1D,7
        DB     $BF,$BF,$0E,7
        DB     $BF,$11,7
        DB     $15,7
        DB     $18,7
        DB     $9D,$11,7
        DB     $15,7
        DB     $18,7
        DB     $1D,7

        DB     $BF,$BF,$07,7           ;MEASURE 18 BUMPED UP AN OCTAVE
        DB     $BF,$0E,7
        DB     $13,7
        DB     $17,7
        DB     $9D,$0E,7
        DB     $13,7
        DB     $17,7
        DB     $1D,7
        DB     $BF,$BF,$07,7
        DB     $BF,$0E,7
        DB     $13,7
        DB     $17,7
        DB     $9D,$0E,7
        DB     $13,7
        DB     $17,7
        DB     $1D,7

        DB     $BF,$BF,$0C,7           ;MEASURE 19 BUMPED UP AN OCTAVE
        DB     $BF,$10,7
        DB     $13,7
        DB     $18,7
        DB     $9C,$10,7
        DB     $13,7
        DB     $18,7
        DB     $1C,7
        DB     $BF,$BF,$0C,7
        DB     $BF,$10,7
        DB     $13,7
        DB     $18,7
        DB     $9C,$10,7
        DB     $13,7
        DB     $18,7
        DB     $1C,7

        DB     $BF,$BF,$0C,7           ;MEASURE 20 BUMPED UP AN OCTAVE
        DB     $BF,$13,7
        DB     $16,7
        DB     $18,7
        DB     $9C,$13,7
        DB     $16,7
        DB     $18,7
        DB     $1C,7
        DB     $BF,$BF,$0C,7
        DB     $BF,$13,7
        DB     $16,7
        DB     $18,7
        DB     $9C,$13,7
        DB     $16,7
        DB     $18,7
        DB     $1C,7

        DB     $BF,$BF,$05,7           ;MEASURE 21 BUMPED UP AN OCTAVE
        DB     $BF,$11,7
        DB     $15,7
        DB     $18,7
        DB     $9C,$11,7
        DB     $15,7
        DB     $18,7
        DB     $1C,7
        DB     $BF,$BF,$05,7
        DB     $BF,$11,7
        DB     $15,7
        DB     $18,7
        DB     $9C,$11,7
        DB     $15,7
        DB     $18,7
        DB     $1C,7

        DB     $BF,$BF,$06,7           ;MEASURE 22 BUMPED UP AN OCTAVE
        DB     $BF,$0C,7
        DB     $15,7
        DB     $18,7
        DB     $9B,$0C,7
        DB     $15,7
        DB     $18,7
        DB     $1B,7
        DB     $BF,$BF,$06,7
        DB     $BF,$0C,7
        DB     $15,7
        DB     $18,7
        DB     $9B,$0C,7
        DB     $15,7
        DB     $18,7
        DB     $1B,7

        DB     $BF,$BF,$07,7           ;MEASURE 23 BUMPED UP AN OCTAVE
        DB     $BF,$0F,7
        DB     $17,7
        DB     $18,7
        DB     $9B,$0F,7
        DB     $17,7
        DB     $18,7
        DB     $1B,7
        DB     $BF,$BF,$07,7
        DB     $BF,$0F,7
        DB     $17,7
        DB     $18,7
        DB     $9B,$0F,7
        DB     $17,7
        DB     $18,7
        DB     $1B,7

        DB     $BF,$BF,$08,7           ;MEASURE 24 BUMPED UP AN OCTAVE
        DB     $BF,$11,7
        DB     $17,7
        DB     $18,7
        DB     $9A,$11,7
        DB     $17,7
        DB     $18,7
        DB     $1A,7
        DB     $BF,$BF,$08,7
        DB     $BF,$11,7
        DB     $17,7
        DB     $18,7
        DB     $9A,$11,7
        DB     $17,7
        DB     $18,7
        DB     $1A,7

        DB     $BF,$BF,$07,7           ;MEASURE 25 BUMPED UP AN OCTAVE
        DB     $BF,$11,7
        DB     $13,7
        DB     $17,7
        DB     $9A,$11,7
        DB     $13,7
        DB     $17,7
        DB     $1A,7
        DB     $BF,$BF,$07,7
        DB     $BF,$11,7
        DB     $13,7
        DB     $17,7
        DB     $9A,$11,7
        DB     $13,7
        DB     $17,7
        DB     $1A,7

        DB     $BF,$BF,$07,7           ;MEASURE 26 BUMPED UP AN OCTAVE
        DB     $BF,$10,7
        DB     $13,7
        DB     $18,7
        DB     $9C,$10,7
        DB     $13,7
        DB     $18,7
        DB     $1C,7
        DB     $BF,$BF,$07,7
        DB     $BF,$10,7
        DB     $13,7
        DB     $18,7
        DB     $9C,$10,7
        DB     $13,7
        DB     $18,7
        DB     $1C,7

        DB     $BF,$BF,$07,7           ;MEASURE 27 BUMPED UP AN OCTAVE
        DB     $BF,$0E,7
        DB     $13,7
        DB     $18,7
        DB     $9D,$0E,7
        DB     $13,7
        DB     $18,7
        DB     $1D,7
        DB     $BF,$BF,$07,7
        DB     $BF,$0E,7
        DB     $13,7
        DB     $18,7
        DB     $9D,$0E,7
        DB     $13,7
        DB     $18,7
        DB     $1D,7

        DB     $BF,$BF,$07,7           ;MEASURE 28 BUMPED UP AN OCTAVE
        DB     $BF,$0E,7
        DB     $13,7
        DB     $17,7
        DB     $9D,$0E,7
        DB     $13,7
        DB     $17,7
        DB     $1D,7
        DB     $BF,$BF,$07,7
        DB     $BF,$0E,7
        DB     $13,7
        DB     $17,7
        DB     $9D,$0E,7
        DB     $13,7
        DB     $17,7
        DB     $1D,7

        DB     $BF,$BF,$07,7           ;MEASURE 29 BUMPED UP AN OCTAVE
        DB     $BF,$0F,7
        DB     $15,7
        DB     $18,7
        DB     $9E,$0F,7
        DB     $15,7
        DB     $18,7
        DB     $1E,7
        DB     $BF,$BF,$07,7
        DB     $BF,$0F,7
        DB     $15,7
        DB     $18,7
        DB     $9E,$0F,7
        DB     $15,7
        DB     $18,7
        DB     $1E,7

        DB     $BF,$BF,$07,7           ;MEASURE 30 BUMPED UP AN OCTAVE
        DB     $BF,$10,7
        DB     $13,7
        DB     $18,7
        DB     $9F,$10,7
        DB     $13,7
        DB     $18,7
        DB     $1F,7
        DB     $BF,$BF,$07,7
        DB     $BF,$10,7
        DB     $13,7
        DB     $18,7
        DB     $9F,$10,7
        DB     $13,7
        DB     $18,7
        DB     $1F,7

        DB     $BF,$BF,$07,7           ;MEASURE 31 BUMPED UP AN OCTAVE
        DB     $BF,$0E,7
        DB     $13,7
        DB     $18,7
        DB     $9D,$0E,7
        DB     $13,7
        DB     $18,7
        DB     $1D,7
        DB     $BF,$BF,$07,7
        DB     $BF,$0E,7
        DB     $13,7
        DB     $18,7
        DB     $9D,$0E,7
        DB     $13,7
        DB     $18,7
        DB     $1D,7

        DB     $BF,$BF,$07,7           ;MEASURE 32 BUMPED UP AN OCTAVE
        DB     $BF,$0E,7
        DB     $13,7
        DB     $17,7
        DB     $9D,$0E,7
        DB     $13,7
        DB     $17,7
        DB     $1D,7
        DB     $BF,$BF,$07,7
        DB     $BF,$0E,7
        DB     $13,7
        DB     $17,7
        DB     $9D,$0E,7
        DB     $13,7
        DB     $17,7
        DB     $1D,7

        DB     $BF,$BF,$00,7           ;MEASURE 33 BUMPED UP AN OCTAVE
        DB     $BF,$0C,7
        DB     $13,7
        DB     $16,7
        DB     $9C,$0C,7
        DB     $13,7
        DB     $16,7
        DB     $1C,7
        DB     $BF,$BF,$00,7
        DB     $BF,$0C,7
        DB     $13,7
        DB     $16,7
        DB     $9C,$0C,7
        DB     $13,7
        DB     $16,7
        DB     $1C,7


        DB     $BF,$BF,$00,7           ;MEASURE 34 BUMPED UP AN OCTAVE
        DB     $BF,$0C,7
        DB     $11,7
        DB     $15,7
        DB     $98,$0C,7
        DB     $1C,7
        DB     $18,7
        DB     $15,7
        DB     $98,$0C,7
        DB     $15,7
        DB     $11,7
        DB     $15,7
        DB     $11,7
        DB     $0E,7
        DB     $11,7
        DB     $0E,7

        DB     $BF,$BF,$00,7           ;MEASURE 35 BUMPED UP AN OCTAVE
        DB     $BF,$0B,7
        DB     $1F,7
        DB     $23,7
        DB     $A6,$0B,7
        DB     $29,7
        DB     $26,7
        DB     $23,7
        DB     $A6,$0B,7
        DB     $23,7
        DB     $1F,7
        DB     $23,7
        DB     $1A,7
        DB     $1D,7
        DB     $1C,7
        DB     $1A,7

        DB     $A4,$9F,$1C,98          ;MEASURE 36 BUMPED UP AN OCTAVE

        DB     $3F,100
        DB     $3F,100
        DB     $3F,100
        DB     $3F,100
        DB     $3F,100
        DB     $3F,100

        DB     0,$80,$80,$80,$80,$80           ;END OF MUSIC

        END
