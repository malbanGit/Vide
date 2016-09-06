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

        FCC     'g GCE 1812',$80
        FDB     MUSIC
        FCB     $F8,$50,$40,$E0
        FCC     'BACH',$80
        FCB     $F8,$50,$20,$C0
        FCC     'PRELUDE #1',$80
        FCB     $F8,$50,$00,$E0
        FCC     'WELL',$80
        FCB     $F8,$50,$F0,$C8
        FCC     'TEMPERED',$80
        FCB     $F8,$50,$E0,$B8
        FCC     'CLAVICHORD',$80
        FCB     0

        LDD     #0
        STD     $CBFE           SET COLD BOOT (WASTE SOME TIME WHEN DONE)
        JMP     EXEC

*       ENVLOP  FCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
*               FCB     $FF,$EE,$DD,$CC,$BB,$AA,$99,$88

NVLOP1  FCB     $FF,$FF,$EE,$EE,$DD,$DD,$CC,$CC
        FCB     $BB,$BB,$AA,$AA,$99,$99,$88,$88

MUSIC   FDB     NVLOP1,$FEB6

        FCB     $3F,100                 SET A SPELL

        FCB     $BF,$BF,$18,7           MEASURE 1 BUMPED UP AN OCTAVE
        FCB     $BF,$1C,7
        FCB     $1F,7
        FCB     $24,7
        FCB     $A8,$1C,7
        FCB     $1F,7
        FCB     $24,7
        FCB     $28,7
        FCB     $BF,$BF,$18,7
        FCB     $BF,$1C,7
        FCB     $1F,7
        FCB     $24,7
        FCB     $A8,$1C,7
        FCB     $1F,7
        FCB     $24,7
        FCB     $28,7

        FCB     $BF,$BF,$18,7           MEASURE 2 BUMPED UP AN OCTAVE
        FCB     $BF,$1A,7
        FCB     $21,7
        FCB     $26,7
        FCB     $A9,$1A,7
        FCB     $21,7
        FCB     $26,7
        FCB     $29,7
        FCB     $BF,$BF,$18,7
        FCB     $BF,$1A,7
        FCB     $21,7
        FCB     $26,7
        FCB     $A9,$1A,7
        FCB     $21,7
        FCB     $26,7
        FCB     $29,7

        FCB     $BF,$BF,$17,7           MEASURE 3 BUMPED UP AN OCTAVE
        FCB     $BF,$1A,7
        FCB     $1F,7
        FCB     $26,7
        FCB     $A9,$1A,7
        FCB     $1F,7
        FCB     $26,7
        FCB     $29,7
        FCB     $BF,$BF,$17,7
        FCB     $BF,$1A,7
        FCB     $1F,7
        FCB     $26,7
        FCB     $A9,$1A,7
        FCB     $1F,7
        FCB     $26,7
        FCB     $29,7

        FCB     $BF,$BF,$18,7           MEASURE 4 BUMPED UP AN OCTAVE
        FCB     $BF,$1C,7
        FCB     $1F,7
        FCB     $24,7
        FCB     $A8,$1C,7
        FCB     $1F,7
        FCB     $24,7
        FCB     $28,7
        FCB     $BF,$BF,$18,7
        FCB     $BF,$1C,7
        FCB     $1F,7
        FCB     $24,7
        FCB     $A8,$1C,7
        FCB     $1F,7
        FCB     $24,7
        FCB     $28,7

        FCB     $BF,$BF,$18,7           MEASURE 5 BUMPED UP AN OCTAVE
        FCB     $BF,$1C,7
        FCB     $21,7
        FCB     $28,7
        FCB     $AD,$1C,7
        FCB     $21,7
        FCB     $28,7
        FCB     $2D,7
        FCB     $BF,$BF,$18,7
        FCB     $BF,$1C,7
        FCB     $21,7
        FCB     $28,7
        FCB     $AD,$1C,7
        FCB     $21,7
        FCB     $28,7
        FCB     $2D,7

        FCB     $BF,$BF,$18,7           MEASURE 6 BUMPED UP AN OCTAVE
        FCB     $BF,$1A,7
        FCB     $1E,7
        FCB     $21,7
        FCB     $A6,$1A,7
        FCB     $1E,7
        FCB     $21,7
        FCB     $26,7
        FCB     $BF,$BF,$18,7
        FCB     $BF,$1A,7
        FCB     $1E,7
        FCB     $21,7
        FCB     $A6,$1A,7
        FCB     $1E,7
        FCB     $21,7
        FCB     $26,7

        FCB     $BF,$BF,$17,7           MEASURE 7 BUMPED UP AN OCTAVE
        FCB     $BF,$1A,7
        FCB     $1F,7
        FCB     $26,7
        FCB     $AB,$1A,7
        FCB     $1F,7
        FCB     $26,7
        FCB     $2B,7
        FCB     $BF,$BF,$17,7
        FCB     $BF,$1A,7
        FCB     $1F,7
        FCB     $26,7
        FCB     $AB,$1A,7
        FCB     $1F,7
        FCB     $26,7
        FCB     $2B,7

        FCB     $BF,$BF,$17,7           MEASURE 8 BUMPED UP AN OCTAVE
        FCB     $BF,$18,7
        FCB     $1C,7
        FCB     $1F,7
        FCB     $A4,$18,7
        FCB     $1C,7
        FCB     $1F,7
        FCB     $24,7
        FCB     $BF,$BF,$17,7
        FCB     $BF,$18,7
        FCB     $1C,7
        FCB     $1F,7
        FCB     $A4,$18,7
        FCB     $1C,7
        FCB     $1F,7
        FCB     $24,7

        FCB     $BF,$BF,$15,7           MEASURE 9 BUMPED UP AN OCTAVE
        FCB     $BF,$18,7
        FCB     $1C,7
        FCB     $1F,7
        FCB     $A4,$18,7
        FCB     $1C,7
        FCB     $1F,7
        FCB     $24,7
        FCB     $BF,$BF,$15,7
        FCB     $BF,$18,7
        FCB     $1C,7
        FCB     $1F,7
        FCB     $A4,$18,7
        FCB     $1C,7
        FCB     $1F,7
        FCB     $24,7

        FCB     $BF,$BF,$0C,7           MEASURE 10 BUMPED UP AN OCTAVE
        FCB     $BF,$15,7
        FCB     $1A,7
        FCB     $1D,7
        FCB     $A4,$15,7
        FCB     $1A,7
        FCB     $1D,7
        FCB     $24,7
        FCB     $BF,$BF,$0C,7
        FCB     $BF,$15,7
        FCB     $1A,7
        FCB     $1D,7
        FCB     $A4,$15,7
        FCB     $1A,7
        FCB     $1D,7
        FCB     $24,7

        FCB     $BF,$BF,$13,7           MEASURE 11 BUMPED UP AN OCTAVE
        FCB     $BF,$17,7
        FCB     $1A,7
        FCB     $1F,7
        FCB     $A3,$17,7
        FCB     $1A,7
        FCB     $1F,7
        FCB     $23,7
        FCB     $BF,$BF,$13,7
        FCB     $BF,$17,7
        FCB     $1A,7
        FCB     $1F,7
        FCB     $A3,$17,7
        FCB     $1A,7
        FCB     $1F,7
        FCB     $23,7

        FCB     $BF,$BF,$13,7           MEASURE 12 BUMPED UP AN OCTAVE
        FCB     $BF,$16,7
        FCB     $1C,7
        FCB     $1F,7
        FCB     $A5,$16,7
        FCB     $1C,7
        FCB     $1F,7
        FCB     $25,7
        FCB     $BF,$BF,$13,7
        FCB     $BF,$16,7
        FCB     $1C,7
        FCB     $1F,7
        FCB     $A5,$16,7
        FCB     $1C,7
        FCB     $1F,7
        FCB     $25,7

        FCB     $BF,$BF,$11,7           MEASURE 13 BUMPED UP AN OCTAVE
        FCB     $BF,$15,7
        FCB     $1A,7
        FCB     $21,7
        FCB     $A6,$15,7
        FCB     $1A,7
        FCB     $21,7
        FCB     $26,7
        FCB     $BF,$BF,$11,7
        FCB     $BF,$15,7
        FCB     $1A,7
        FCB     $21,7
        FCB     $A6,$15,7
        FCB     $1A,7
        FCB     $21,7
        FCB     $26,7

        FCB     $BF,$BF,$11,7           MEASURE 14 BUMPED UP AN OCTAVE
        FCB     $BF,$14,7
        FCB     $1A,7
        FCB     $1D,7
        FCB     $A3,$14,7
        FCB     $1A,7
        FCB     $1D,7
        FCB     $23,7
        FCB     $BF,$BF,$11,7
        FCB     $BF,$14,7
        FCB     $1A,7
        FCB     $1D,7
        FCB     $A3,$14,7
        FCB     $1A,7
        FCB     $1D,7
        FCB     $23,7

        FCB     $BF,$BF,$10,7           MEASURE 15 BUMPED UP AN OCTAVE
        FCB     $BF,$13,7
        FCB     $18,7
        FCB     $1F,7
        FCB     $98,$13,7
        FCB     $18,7
        FCB     $1F,7
        FCB     $24,7
        FCB     $BF,$BF,$10,7
        FCB     $BF,$13,7
        FCB     $18,7
        FCB     $1F,7
        FCB     $98,$13,7
        FCB     $18,7
        FCB     $1F,7
        FCB     $24,7

        FCB     $BF,$BF,$10,7           MEASURE 16 BUMPED UP AN OCTAVE
        FCB     $BF,$11,7
        FCB     $15,7
        FCB     $18,7
        FCB     $9D,$11,7
        FCB     $15,7
        FCB     $18,7
        FCB     $1D,7
        FCB     $BF,$BF,$10,7
        FCB     $BF,$11,7
        FCB     $15,7
        FCB     $18,7
        FCB     $9D,$11,7
        FCB     $15,7
        FCB     $18,7
        FCB     $1D,7

        FCB     $BF,$BF,$0E,7           MEASURE 17 BUMPED UP AN OCTAVE
        FCB     $BF,$11,7
        FCB     $15,7
        FCB     $18,7
        FCB     $9D,$11,7
        FCB     $15,7
        FCB     $18,7
        FCB     $1D,7
        FCB     $BF,$BF,$0E,7
        FCB     $BF,$11,7
        FCB     $15,7
        FCB     $18,7
        FCB     $9D,$11,7
        FCB     $15,7
        FCB     $18,7
        FCB     $1D,7

        FCB     $BF,$BF,$07,7           MEASURE 18 BUMPED UP AN OCTAVE
        FCB     $BF,$0E,7
        FCB     $13,7
        FCB     $17,7
        FCB     $9D,$0E,7
        FCB     $13,7
        FCB     $17,7
        FCB     $1D,7
        FCB     $BF,$BF,$07,7
        FCB     $BF,$0E,7
        FCB     $13,7
        FCB     $17,7
        FCB     $9D,$0E,7
        FCB     $13,7
        FCB     $17,7
        FCB     $1D,7

        FCB     $BF,$BF,$0C,7           MEASURE 19 BUMPED UP AN OCTAVE
        FCB     $BF,$10,7
        FCB     $13,7
        FCB     $18,7
        FCB     $9C,$10,7
        FCB     $13,7
        FCB     $18,7
        FCB     $1C,7
        FCB     $BF,$BF,$0C,7
        FCB     $BF,$10,7
        FCB     $13,7
        FCB     $18,7
        FCB     $9C,$10,7
        FCB     $13,7
        FCB     $18,7
        FCB     $1C,7

        FCB     $BF,$BF,$0C,7           MEASURE 20 BUMPED UP AN OCTAVE
        FCB     $BF,$13,7
        FCB     $16,7
        FCB     $18,7
        FCB     $9C,$13,7
        FCB     $16,7
        FCB     $18,7
        FCB     $1C,7
        FCB     $BF,$BF,$0C,7
        FCB     $BF,$13,7
        FCB     $16,7
        FCB     $18,7
        FCB     $9C,$13,7
        FCB     $16,7
        FCB     $18,7
        FCB     $1C,7

        FCB     $BF,$BF,$05,7           MEASURE 21 BUMPED UP AN OCTAVE
        FCB     $BF,$11,7
        FCB     $15,7
        FCB     $18,7
        FCB     $9C,$11,7
        FCB     $15,7
        FCB     $18,7
        FCB     $1C,7
        FCB     $BF,$BF,$05,7
        FCB     $BF,$11,7
        FCB     $15,7
        FCB     $18,7
        FCB     $9C,$11,7
        FCB     $15,7
        FCB     $18,7
        FCB     $1C,7

        FCB     $BF,$BF,$06,7           MEASURE 22 BUMPED UP AN OCTAVE
        FCB     $BF,$0C,7
        FCB     $15,7
        FCB     $18,7
        FCB     $9B,$0C,7
        FCB     $15,7
        FCB     $18,7
        FCB     $1B,7
        FCB     $BF,$BF,$06,7
        FCB     $BF,$0C,7
        FCB     $15,7
        FCB     $18,7
        FCB     $9B,$0C,7
        FCB     $15,7
        FCB     $18,7
        FCB     $1B,7

        FCB     $BF,$BF,$07,7           MEASURE 23 BUMPED UP AN OCTAVE
        FCB     $BF,$0F,7
        FCB     $17,7
        FCB     $18,7
        FCB     $9B,$0F,7
        FCB     $17,7
        FCB     $18,7
        FCB     $1B,7
        FCB     $BF,$BF,$07,7
        FCB     $BF,$0F,7
        FCB     $17,7
        FCB     $18,7
        FCB     $9B,$0F,7
        FCB     $17,7
        FCB     $18,7
        FCB     $1B,7

        FCB     $BF,$BF,$08,7           MEASURE 24 BUMPED UP AN OCTAVE
        FCB     $BF,$11,7
        FCB     $17,7
        FCB     $18,7
        FCB     $9A,$11,7
        FCB     $17,7
        FCB     $18,7
        FCB     $1A,7
        FCB     $BF,$BF,$08,7
        FCB     $BF,$11,7
        FCB     $17,7
        FCB     $18,7
        FCB     $9A,$11,7
        FCB     $17,7
        FCB     $18,7
        FCB     $1A,7

        FCB     $BF,$BF,$07,7           MEASURE 25 BUMPED UP AN OCTAVE
        FCB     $BF,$11,7
        FCB     $13,7
        FCB     $17,7
        FCB     $9A,$11,7
        FCB     $13,7
        FCB     $17,7
        FCB     $1A,7
        FCB     $BF,$BF,$07,7
        FCB     $BF,$11,7
        FCB     $13,7
        FCB     $17,7
        FCB     $9A,$11,7
        FCB     $13,7
        FCB     $17,7
        FCB     $1A,7

        FCB     $BF,$BF,$07,7           MEASURE 26 BUMPED UP AN OCTAVE
        FCB     $BF,$10,7
        FCB     $13,7
        FCB     $18,7
        FCB     $9C,$10,7
        FCB     $13,7
        FCB     $18,7
        FCB     $1C,7
        FCB     $BF,$BF,$07,7
        FCB     $BF,$10,7
        FCB     $13,7
        FCB     $18,7
        FCB     $9C,$10,7
        FCB     $13,7
        FCB     $18,7
        FCB     $1C,7

        FCB     $BF,$BF,$07,7           MEASURE 27 BUMPED UP AN OCTAVE
        FCB     $BF,$0E,7
        FCB     $13,7
        FCB     $18,7
        FCB     $9D,$0E,7
        FCB     $13,7
        FCB     $18,7
        FCB     $1D,7
        FCB     $BF,$BF,$07,7
        FCB     $BF,$0E,7
        FCB     $13,7
        FCB     $18,7
        FCB     $9D,$0E,7
        FCB     $13,7
        FCB     $18,7
        FCB     $1D,7

        FCB     $BF,$BF,$07,7           MEASURE 28 BUMPED UP AN OCTAVE
        FCB     $BF,$0E,7
        FCB     $13,7
        FCB     $17,7
        FCB     $9D,$0E,7
        FCB     $13,7
        FCB     $17,7
        FCB     $1D,7
        FCB     $BF,$BF,$07,7
        FCB     $BF,$0E,7
        FCB     $13,7
        FCB     $17,7
        FCB     $9D,$0E,7
        FCB     $13,7
        FCB     $17,7
        FCB     $1D,7

        FCB     $BF,$BF,$07,7           MEASURE 29 BUMPED UP AN OCTAVE
        FCB     $BF,$0F,7
        FCB     $15,7
        FCB     $18,7
        FCB     $9E,$0F,7
        FCB     $15,7
        FCB     $18,7
        FCB     $1E,7
        FCB     $BF,$BF,$07,7
        FCB     $BF,$0F,7
        FCB     $15,7
        FCB     $18,7
        FCB     $9E,$0F,7
        FCB     $15,7
        FCB     $18,7
        FCB     $1E,7

        FCB     $BF,$BF,$07,7           MEASURE 30 BUMPED UP AN OCTAVE
        FCB     $BF,$10,7
        FCB     $13,7
        FCB     $18,7
        FCB     $9F,$10,7
        FCB     $13,7
        FCB     $18,7
        FCB     $1F,7
        FCB     $BF,$BF,$07,7
        FCB     $BF,$10,7
        FCB     $13,7
        FCB     $18,7
        FCB     $9F,$10,7
        FCB     $13,7
        FCB     $18,7
        FCB     $1F,7

        FCB     $BF,$BF,$07,7           MEASURE 31 BUMPED UP AN OCTAVE
        FCB     $BF,$0E,7
        FCB     $13,7
        FCB     $18,7
        FCB     $9D,$0E,7
        FCB     $13,7
        FCB     $18,7
        FCB     $1D,7
        FCB     $BF,$BF,$07,7
        FCB     $BF,$0E,7
        FCB     $13,7
        FCB     $18,7
        FCB     $9D,$0E,7
        FCB     $13,7
        FCB     $18,7
        FCB     $1D,7

        FCB     $BF,$BF,$07,7           MEASURE 32 BUMPED UP AN OCTAVE
        FCB     $BF,$0E,7
        FCB     $13,7
        FCB     $17,7
        FCB     $9D,$0E,7
        FCB     $13,7
        FCB     $17,7
        FCB     $1D,7
        FCB     $BF,$BF,$07,7
        FCB     $BF,$0E,7
        FCB     $13,7
        FCB     $17,7
        FCB     $9D,$0E,7
        FCB     $13,7
        FCB     $17,7
        FCB     $1D,7

        FCB     $BF,$BF,$00,7           MEASURE 33 BUMPED UP AN OCTAVE
        FCB     $BF,$0C,7
        FCB     $13,7
        FCB     $16,7
        FCB     $9C,$0C,7
        FCB     $13,7
        FCB     $16,7
        FCB     $1C,7
        FCB     $BF,$BF,$00,7
        FCB     $BF,$0C,7
        FCB     $13,7
        FCB     $16,7
        FCB     $9C,$0C,7
        FCB     $13,7
        FCB     $16,7
        FCB     $1C,7


        FCB     $BF,$BF,$00,7           MEASURE 34 BUMPED UP AN OCTAVE
        FCB     $BF,$0C,7
        FCB     $11,7
        FCB     $15,7
        FCB     $98,$0C,7
        FCB     $1C,7
        FCB     $18,7
        FCB     $15,7
        FCB     $98,$0C,7
        FCB     $15,7
        FCB     $11,7
        FCB     $15,7
        FCB     $11,7
        FCB     $0E,7
        FCB     $11,7
        FCB     $0E,7

        FCB     $BF,$BF,$00,7           MEASURE 35 BUMPED UP AN OCTAVE
        FCB     $BF,$0B,7
        FCB     $1F,7
        FCB     $23,7
        FCB     $A6,$0B,7
        FCB     $29,7
        FCB     $26,7
        FCB     $23,7
        FCB     $A6,$0B,7
        FCB     $23,7
        FCB     $1F,7
        FCB     $23,7
        FCB     $1A,7
        FCB     $1D,7
        FCB     $1C,7
        FCB     $1A,7

        FCB     $A4,$9F,$1C,98          MEASURE 36 BUMPED UP AN OCTAVE

        FCB     $3F,100
        FCB     $3F,100
        FCB     $3F,100
        FCB     $3F,100
        FCB     $3F,100
        FCB     $3F,100

        FCB     0,$80,$80,$80,$80,$80           END OF MUSIC

        END
