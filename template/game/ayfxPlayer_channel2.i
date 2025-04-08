; bank 1
;
; original vectrex routine were written by Richard Chadd
;
; (optimized version!)
; regs used by below implementation
; U and D
; X is also used, but can be spared - see below comments
; this is only channel 2 is implemented
SHADOW_BASE         =        $c83f 
;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;
sfx_endofeffect_2: 
                    direct   $ff 
                                                            ; set volume off channel 3 
                                                            ; set reg1sf0 
                                                            ; Set volume 
                    LDD      #$0000                         ; reset sfx 
                    sta      SHADOW_BASE+$09 
                    STD      sfx_pointer_2 
                                                            ; allow playing of normal effects 
noay2: 
                    RTS      

sfx_doframe_intern_2:                                       ;#isfunction  
                    LDU      sfx_pointer_2                  ; get current frame pointer 
                    BEQ      noay2 
                    LDB      ,U+ 
                    CMPB     #$D0                           ; check first flag byte D0 
                    BNE      sfx_checktonefreq_2            ; no match - continue to process frame 
                    LDA      ,U 
                    CMPA     #$20                           ; check second flag byte 20 
                    BEQ      sfx_endofeffect_2              ; match - end of effect found so stop playing 
sfx_checktonefreq_2: 
                    BITB     #%00100000                     ; if bit 5 of B is set 
                    BEQ      sfx_checknoisefreq_2           ; skip as no tone freq data 
                    ldx      ,u++                           ; alternative to destroying d load any 2 byte reg, 
                    stx      SHADOW_BASE+02                 ; here I destroy d 
; or if x mus be preserved
;                    ldd      ,u++ ; alternative to destroying d load any 2 byte reg,
;                    std      SHADOW_BASE+02 ; here I destroy d
;                    ldb -2,u ; and load b anew - one instruction to many, 
sfx_checknoisefreq_2: 
                    BITB     #%01000000                     ; if bit 6 of B is only set 
                    BEQ      sfx_checkvolume_2              ; skip as no noise freq data 
                    LDA      ,U+                            ; get next data byte and copy to noise freq reg 
                    STA      SHADOW_BASE+06                 ; set noise freq 
sfx_checkvolume_2: 
                    tfr      b,a 
                    ANDA     #%00001111                     ; get volume from bits 0-3 
                    STA      SHADOW_BASE+$09                ; set tone freq 
sfx_checktonedisable_2: 
                    LDA      SHADOW_BASE+$07                ; in the following reg 7 will be altered - load once 
                    BITB     #%00010000                     ; if bit 4 of B is set disable the tone 
                    BEQ      sfx_enabletone_2 
sfx_disabletone_2: 
                    ORA      #%00000010 
                    BITB     #%10000000                     ; if bit7 of B is set disable noise 
                    BEQ      sfx_enablenoise_2 
                    ORA      #%00010000 
                    STA      SHADOW_BASE+$07                ; set tone freq 
                    STU      sfx_pointer_2                  ; update frame pointer to next flag byte in Y 
                    RTS      

sfx_enabletone_2: 
                    ANDA     #%11111101 
sfx_checknoisedisable_2: 
                    BITB     #%10000000                     ; if bit7 of B is set disable noise 
                    BEQ      sfx_enablenoise_2 
sfx_disablenoise_2: 
                    ORA      #%00010000 
                    STA      SHADOW_BASE+$07                ; set tone freq 
                    STU      sfx_pointer_2                  ; update frame pointer to next flag byte in Y 
                    RTS      

sfx_enablenoise_2: 
                    ANDA     #%11101111 
                    STA      SHADOW_BASE+$07                ; set tone freq 
                    STU      sfx_pointer_2                  ; update frame pointer to next flag byte in Y 
                    RTS      
