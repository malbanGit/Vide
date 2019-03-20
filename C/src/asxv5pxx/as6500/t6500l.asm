        .sbttl  Assembler Link Tests

        .module t6500l

        ; This file and TCONST.ASM should be assembled and linked.
        ;
        ; AS6500 -XGOLFF T6500L
        ; AS6500 -XGOLFF TCONST
        ;
        ; ASLINK -C
        ; -XMS
        ; T6500L
        ; TCONST
        ; -E
        ;
        ; The following tests verify the correct processing of
        ; external references for the direct page, index mode offsets,
        ; and branches.
        ;
        ; *L signifies an error will be reported at link time.

        ; branch test must be first

        .r65c02
        
        .area   TEST    (ABS,OVR)

        .blkb   0x7E            ;bra1:
        bra     bra1            ;   80p00  [80 80]
        .blkb   0x7F            ;bra2:
        bra     bra2            ;*L 80p00  [80 7F]
        bra     bra3            ;   80p00  [80 7F]
        .blkb   0x7F
        .blkb   0x00            ;bra3:
        bra     bra4            ;*L 80p00  [80 [80]
        .blkb   0x80
        .blkb   0x00            ;bra4:

        .blkb   0x7E            ;bra5:
        bra     bra5            ;   80p00  [80 80]
        .blkb   0x7F            ;bra6:
        bra     bra6            ;*L 80p00  [80 7F]
        bra     bra7            ;   80p00  [80 7F]
        .blkb   0x7F
        .blkb   0x00            ;bra7:
        bra     bra8            ;*L 80p00  [80 [80]
        .blkb   0x80
        .blkb   0x00            ;bra8:

        ; direct page test

        .area   DIRECT  (ABS,OVR)
        .setdp  0,DIRECT

        asl     *minus1         ;*L 06*00  [06 FF]
        asl     *zero           ;   06*00  [06 00]
        asl     *two55          ;   06*00  [06 FF]
        asl     *two56          ;*L 06*00  [06 00]

        asl     *lminus1        ;*L 06*00  [06 FF]
        asl     *lzero          ;   06*00  [06 00]
        asl     *ltwo55         ;   06*00  [06 FF]
        asl     *ltwo56         ;*L 06*00  [06 00]

        ; indexed test

        lda	[minus1,x]	;*L A1*00  [A1 FF]
        lda	[zero,x]	;   A1*00  [A1 00]
        lda	[two55,x]	;   A1*00  [A1 FF]
        lda	[two56,x]	;*L A1*00  [A1 00]

        ; direct page boundary / length checking

        .area   A

        .blkb   1

        .area   PAGE0   (PAG)   ;*L Linker -- page boundary error

        .setdp  0,PAGE0         ;*L Linker -- page definition boundary error

        .blkb   0x101           ;*L Linker -- page length error

