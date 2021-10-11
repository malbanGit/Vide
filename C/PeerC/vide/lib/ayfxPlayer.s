 .module ayfxplayer.s

 .area .text

 .area .bss

 .globl _currentSFX_1
_currentSFX_1:        .blkb       2                            ; sfx player used
 .globl _currentSFX_2
_currentSFX_2:        .blkb       2                            ; sfx player used
 .globl _currentSFX_3
_currentSFX_3:        .blkb       2                            ; sfx player used
 .globl _sfx_status_1
_sfx_status_1:        .blkb       1                            ; sfx player used
 .globl _sfx_status_2
_sfx_status_2:        .blkb       1                            ; sfx player used
 .globl _sfx_status_3
_sfx_status_3:        .blkb       1                            ; sfx player used
 .globl _sfx_pointer_1
_sfx_pointer_1:       .blkb       2                            ; sfx player used
 .globl _sfx_pointer_2
_sfx_pointer_2:       .blkb       2                            ; sfx player used
 .globl _sfx_pointer_3
_sfx_pointer_3:       .blkb       2                            ; sfx player used

 .area .text

; this file is part of Release, written by Malban in 2017
;
; original vectrex routine were written by Richard Chadd
;
; (optimized version!)
; regs used by below implementation
; U and D
; X is also used, but can be spared - see below comments
; this is only channel 1 is implemented
SHADOW_BASE         =        0xC84C;0xc83f
;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 .globl sfx_endofeffect_1
sfx_endofeffect_1:
                                                          ; set volume off channel 3
                                                          ; set reg1sf0
                                                          ; Set volume
                    LDD      #0x0000                       ; reset sfx
                    sta      SHADOW_BASE-0x08
                    STD      _sfx_pointer_1
                    STA      _sfx_status_1
                    std      _currentSFX_1
 .globl noay1
noay1:
                    RTS

 .globl sfx_doframe_intern_1
sfx_doframe_intern_1:                                     ;#isfunction
                    LDA      _sfx_status_1                 ; check if sfx to play
                    BEQ      noay1
                    LDU      _sfx_pointer_1                ; get current frame pointer
                    LDB      ,U+
                    CMPB     #0xD0                         ; check first flag byte D0
                    BNE      sfx_checktonefreq_1          ; no match - continue to process frame
                    LDA      ,U
                    CMPA     #0x20                         ; check second flag byte 20
                    BEQ      sfx_endofeffect_1            ; match - end of effect found so stop playing
 .globl sfx_checktonefreq_1
sfx_checktonefreq_1:
                    BITB     #0b00100000                   ; if bit 5 of B is set
                    BEQ      sfx_checknoisefreq_1         ; skip as no tone freq data
                    ldd      ,u++ ; alternative to destroying d load any 2 byte reg,
                    std      SHADOW_BASE-00 ; here I destroy d
                    ldb      -3,u ; and load b anew - one instruction to many,
 .globl sfx_checknoisefreq_1
sfx_checknoisefreq_1:
                    BITB     #0b01000000                   ; if bit 6 of B is only set
                    BEQ      sfx_checkvolume_1            ; skip as no noise freq data
                    LDA      ,U+                          ; get next data byte and copy to noise freq reg
                    STA      SHADOW_BASE-06               ; set noise freq
 .globl sfx_checkvolume_1
sfx_checkvolume_1:
                    tfr      b,a
                    ANDA     #0b00001111                   ; get volume from bits 0-3
                    STA      SHADOW_BASE-0x08              ; set tone freq
 .globl sfx_checktonedisable_1
sfx_checktonedisable_1:
                    LDA      SHADOW_BASE-0x07              ; in the following reg 7 will be altered - load once
                    BITB     #0b00010000                   ; if bit 4 of B is set disable the tone
                    BEQ      sfx_enabletone_1
 .globl sfx_disabletone_1
sfx_disabletone_1:
                    ORA      #0b00000001
                    BITB     #0b10000000                   ; if bit7 of B is set disable noise
                    BEQ      sfx_enablenoise_1
                    ORA      #0b00001000
                    STA      SHADOW_BASE-0x07              ; set tone freq
                    STU      _sfx_pointer_1                ; update frame pointer to next flag byte in Y
                    RTS

 .globl sfx_enabletone_1
sfx_enabletone_1:
                    ANDA     #0b11111110
 .globl sfx_checknoisedisable_1
sfx_checknoisedisable_1:
                    BITB     #0b10000000                   ; if bit7 of B is set disable noise
                    BEQ      sfx_enablenoise_1
 .globl sfx_disablenoise_1
sfx_disablenoise_1:
                    ORA      #0b00001000
                    STA      SHADOW_BASE-0x07              ; set tone freq
                    STU      _sfx_pointer_1                ; update frame pointer to next flag byte in Y
                    RTS

 .globl sfx_enablenoise_1
sfx_enablenoise_1:
                    ANDA     #0b11110111
                    STA      SHADOW_BASE-0x07              ; set tone freq
                    STU      _sfx_pointer_1                ; update frame pointer to next flag byte in Y
                    RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 .globl sfx_endofeffect_2
sfx_endofeffect_2:
                                                          ; set volume off channel 3
                                                          ; set reg1sf0
                                                          ; Set volume
                    LDD      #0x0000                       ; reset sfx
                    sta      SHADOW_BASE-0x09
                    STD      _sfx_pointer_2
                    STA      _sfx_status_2
                    std      _currentSFX_2

 .globl noay2
noay2:
                    RTS

 .globl sfx_doframe_intern_2
sfx_doframe_intern_2:  ;#isfunction


                    LDA      _sfx_status_2                ; check if sfx to play
                    BEQ      noay2

                    LDU      _sfx_pointer_2                ; get current frame pointer
                    LDB      ,U+
                    CMPB     #0xD0                         ; check first flag byte D0
                    BNE      sfx_checktonefreq_2          ; no match - continue to process frame
                    LDA      ,U
                    CMPA     #0x20                         ; check second flag byte 20
                    BEQ      sfx_endofeffect_2            ; match - end of effect found so stop playing
 .globl sfx_checktonefreq_2
sfx_checktonefreq_2:
                    BITB     #0b00100000                   ; if bit 5 of B is set
                    BEQ      sfx_checknoisefreq_2         ; skip as no tone freq data
                    ldd      ,u++ ; alternative to destroying d load any 2 byte reg,
                    std      SHADOW_BASE-02 ; here I destroy d
                    ldb -3,u ; and load b anew - one instruction to many,
 .globl sfx_checknoisefreq_2
sfx_checknoisefreq_2:
                    BITB     #0b01000000                   ; if bit 6 of B is only set
                    BEQ      sfx_checkvolume_2            ; skip as no noise freq data
                    LDA      ,U+                          ; get next data byte and copy to noise freq reg
                    STA      SHADOW_BASE-06               ; set noise freq
 .globl sfx_checkvolume_2
sfx_checkvolume_2:
                    tfr      b,a
                    ANDA     #0b00001111                   ; get volume from bits 0-3
                    STA      SHADOW_BASE-0x09              ; set tone freq
 .globl sfx_checktonedisable_2
sfx_checktonedisable_2:
                    LDA      SHADOW_BASE-0x07              ; in the following reg 7 will be altered - load once
                    BITB     #0b00010000                   ; if bit 4 of B is set disable the tone
                    BEQ      sfx_enabletone_2
 .globl sfx_disabletone_2
sfx_disabletone_2:
                    ORA      #0b00000010
                    BITB     #0b10000000                   ; if bit7 of B is set disable noise
                    BEQ      sfx_enablenoise_2
                    ORA      #0b00010000
                    STA      SHADOW_BASE-0x07              ; set tone freq
                    STU      _sfx_pointer_2                ; update frame pointer to next flag byte in Y
                    RTS

 .globl sfx_enabletone_2
sfx_enabletone_2:
                    ANDA     #0b11111101
 .globl sfx_checknoisedisable_2
sfx_checknoisedisable_2:
                    BITB     #0b10000000                   ; if bit7 of B is set disable noise
                    BEQ      sfx_enablenoise_2
 .globl sfx_disablenoise_2
sfx_disablenoise_2:
                    ORA      #0b00010000
                    STA      SHADOW_BASE-0x07              ; set tone freq
                    STU      _sfx_pointer_2                ; update frame pointer to next flag byte in Y
                    RTS

 .globl sfx_enablenoise_2
sfx_enablenoise_2:
                    ANDA     #0b11101111
                    STA      SHADOW_BASE-0x07              ; set tone freq
                    STU      _sfx_pointer_2                ; update frame pointer to next flag byte in Y
                    RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 .globl sfx_endofeffect_3
sfx_endofeffect_3:
                                                          ; set volume off channel 3
                                                          ; set reg1sf0
                                                          ; Set volume
                    LDD      #0x0000                       ; reset sfx
                    sta      SHADOW_BASE-0x0a
                    STD      _sfx_pointer_3
                    STA      _sfx_status_3
                    std      _currentSFX_3

 .globl noay3
noay3:
                    RTS

 .globl sfx_doframe_intern_3
sfx_doframe_intern_3:  ;#isfunction


                    LDA      _sfx_status_3                ; check if sfx to play
                    BEQ      noay3

                    LDU      _sfx_pointer_3                ; get current frame pointer
                    LDB      ,U+
                    CMPB     #0xD0                         ; check first flag byte D0
                    BNE      sfx_checktonefreq_3          ; no match - continue to process frame
                    LDA      ,U
                    CMPA     #0x20                         ; check second flag byte 20
                    BEQ      sfx_endofeffect_3            ; match - end of effect found so stop playing
 .globl sfx_checktonefreq_3
sfx_checktonefreq_3:
                    BITB     #0b00100000                   ; if bit 5 of B is set
                    BEQ      sfx_checknoisefreq_3         ; skip as no tone freq data
                    ldd      ,u++ ; alternative to destroying d load any 2 byte reg,
                    std      SHADOW_BASE-04 ; here I destroy d
                    ldb -3,u ; and load b anew - one instruction to many,
 .globl sfx_checknoisefreq_3
sfx_checknoisefreq_3:
                    BITB     #0b01000000                   ; if bit 6 of B is only set
                    BEQ      sfx_checkvolume_3            ; skip as no noise freq data
                    LDA      ,U+                          ; get next data byte and copy to noise freq reg
                    STA      SHADOW_BASE-06               ; set tone freq
 .globl sfx_checkvolume_3
sfx_checkvolume_3:
                    tfr      b,a
                    ANDA     #0b00001111                   ; get volume from bits 0-3
                    STA      SHADOW_BASE-0x0A              ; set tone freq
 .globl sfx_checktonedisable_3
sfx_checktonedisable_3:
                    LDA      SHADOW_BASE-0x07              ; in the following reg 7 will be altered - load once
                    BITB     #0b00010000                   ; if bit 4 of B is set disable the tone
                    BEQ      sfx_enabletone_3
 .globl sfx_disabletone_3
sfx_disabletone_3:
                    ORA      #0b00000100
                    BITB     #0b10000000                   ; if bit7 of B is set disable noise
                    BEQ      sfx_enablenoise_3
                    ORA      #0b00100000
                    STA      SHADOW_BASE-0x07              ; set tone freq
                    STU      _sfx_pointer_3                ; update frame pointer to next flag byte in Y
                    RTS

 .globl sfx_enabletone_3
sfx_enabletone_3:
                    ANDA     #0b11111011
 .globl sfx_checknoisedisable_3
sfx_checknoisedisable_3:
                    BITB     #0b10000000                   ; if bit7 of B is set disable noise
                    BEQ      sfx_enablenoise_3
 .globl sfx_disablenoise_3
sfx_disablenoise_3:
                    ORA      #0b00100000
                    STA      SHADOW_BASE-0x07              ; set tone freq
                    STU      _sfx_pointer_3                ; update frame pointer to next flag byte in Y
                    RTS

 .globl sfx_enablenoise_3
sfx_enablenoise_3:
                    ANDA     #0b11011111
                    STA      SHADOW_BASE-0x07              ; set tone freq
                    STU      _sfx_pointer_3                ; update frame pointer to next flag byte in Y
                    RTS
