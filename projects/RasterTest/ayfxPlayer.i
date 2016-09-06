; plays a ayfx to psg shadow
; ors 7
; 
;
sfx_doframe: 
                    LDX      #Vec_Snd_Shadow              ;point to shadow memory 
                    LDA      sfx_status_1                 ; check if sfx to play 
                    BEQ      noay1 
                    JSR      sfx_doframe_intern_1 
noay1: 
                    LDA      sfx_status_2                 ; check if sfx to play 
                    BEQ      noay2 
                    JSR      sfx_doframe_intern_2 
noay2: 
                    LDA      sfx_status_3                 ; check if sfx to play 
                    BEQ      noay3 
                    JSR      sfx_doframe_intern_3 
noay3: 
                    rts      

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;
sfx_doframe_intern_1: 
                    LDU      sfx_pointer_1                ; get current frame pointer 
                    LDB      ,U 
                    CMPB     #$D0                         ; check first flag byte D0 
                    BNE      sfx_checktonefreq_1          ; no match - continue to process frame 
                    LDB      1,U 
                    CMPB     #$20                         ; check second flag byte 20 
                    BEQ      sfx_endofeffect_1            ; match - end of effect found so stop playing 
sfx_checktonefreq_1: 
                    LEAY     1,U                          ; init Y as pointer to next data or flag byte 
                    LDB      ,U                           ; check if need to set tone freq 
                    BITB     #%00100000                   ; if bit 5 of B is set 
                    BEQ      sfx_checknoisefreq_1         ; skip as no tone freq data 
                    LDB      1,U                          ; get next data byte and copy to tone freq reg0 
                    LDA      #$00 
                    STB      A,X                          ; set tone freq 
                    LDB      2,U                          ; get next data byte and copy to tone freq reg1 
                    LDA      #$01 
                    STB      A,X                          ; set tone freq 
                    LEAY     2,Y                          ; increment pointer to next data/flag byte 
sfx_checknoisefreq_1: 
                    LDB      ,U                           ; check if need to set noise freq 
                    BITB     #%01000000                   ; if bit 6 of B is only set 
                    BEQ      sfx_checkvolume_1            ; skip as no noise freq data 
                    LDB      ,Y                           ; get next data byte and copy to noise freq reg 
                    LDA      #$06 
                    STB      A,X                          ; set noise freq 
                    LEAY     1,Y                          ; increment pointer to next flag byte 
sfx_checkvolume_1: 
                    LDB      ,U                           ; set volume on channel 1 
                    ANDB     #%00001111                   ; get volume from bits 0-3 
                    LDA      #$08                         ; set reg8 
                    STB      A,X                          ; Set volume 
sfx_checktonedisable_1: 
                    LDB      ,U                           ; check disable tone channel 1 
                    BITB     #%00010000                   ; if bit 4 of B is set disable the tone 
                    BEQ      sfx_enabletone_1 
sfx_disabletone_1: 
                    LDB      $C807                        ; set bit0 in reg7 
                    ORB      #%00000001 
                    LDA      #$07 
                    STB      A,X                          ; disable tone 
                    BRA      sfx_checknoisedisable_1 

sfx_enabletone_1: 
                    LDB      $C807                        ; clear bit0 in reg7 
                    ANDB     #%11111110 
                    LDA      #$07 
                    STB      A,X                          ; enable tone 
sfx_checknoisedisable_1: 
                    LDB      ,U                           ; check disable noise 
                    BITB     #%10000000                   ; if bit7 of B is set disable noise 
                    BEQ      sfx_enablenoise_1 
sfx_disablenoise_1: 
                    LDB      $C807                        ; set bit3 in reg7 
                    ORB      #%00001000 
                    LDA      #$07 
                    STB      A,X                          ; disable noise 
                    BRA      sfx_nextframe_1 

sfx_enablenoise_1: 
                    LDB      $C807                        ; clear bit3 in reg 7 
                    ANDB     #%11110111 
                    LDA      #$07 
                    STB      A,X                          ; enable noise 
sfx_nextframe_1: 
                    STY      sfx_pointer_1                ; update frame pointer to next flag byte in Y 
                    RTS      

sfx_endofeffect_1: 
                    LDB      #$00                         ; set volume off channel 0 
                    LDA      #$08                        ; set reg1sf0 
                    STB      A,X                          ; Set volume 
                    LDD      #$0000                       ; reset sfx 
                    STD      sfx_pointer_1 
                    STA      sfx_status_1 
                    RTS      

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;
sfx_doframe_intern_2: 
                    LDU      sfx_pointer_2                ; get current frame pointer 
                    LDB      ,U 
                    CMPB     #$D0                         ; check first flag byte D0 
                    BNE      sfx_checktonefreq_2          ; no match - continue to process frame 
                    LDB      1,U 
                    CMPB     #$20                         ; check second flag byte 20 
                    BEQ      sfx_endofeffect_2            ; match - end of effect found so stop playing 
sfx_checktonefreq_2: 
                    LEAY     1,U                          ; init Y as pointer to next data or flag byte 
                    LDB      ,U                           ; check if need to set tone freq 
                    BITB     #%00100000                   ; if bit 5 of B is set 
                    BEQ      sfx_checknoisefreq_2         ; skip as no tone freq data 
                    LDB      1,U                          ; get next data byte and copy to tone freq reg2 
                    LDA      #$02 
                    STB      A,X                          ; set tone freq 
                    LDB      2,U                          ; get next data byte and copy to tone freq reg3 
                    LDA      #$03 
                    STB      A,X                          ; set tone freq 
                    LEAY     2,Y                          ; increment pointer to next data/flag byte 
sfx_checknoisefreq_2: 
                    LDB      ,U                           ; check if need to set noise freq 
                    BITB     #%01000000                   ; if bit 6 of B is only set 
                    BEQ      sfx_checkvolume_2            ; skip as no noise freq data 
                    LDB      ,Y                           ; get next data byte and copy to noise freq reg 
                    LDA      #$06 
                    STB      A,X                          ; set noise freq 
                    LEAY     1,Y                          ; increment pointer to next flag byte 
sfx_checkvolume_2: 
                    LDB      ,U                           ; set volume on channel 2 
                    ANDB     #%00001111                   ; get volume from bits 0-3 
                    LDA      #$09                         ; set reg9 
                    STB      A,X                          ; Set volume 
sfx_checktonedisable_2: 
                    LDB      ,U                           ; check disable tone channel 2 
                    BITB     #%00010000                   ; if bit 4 of B is set disable the tone 
                    BEQ      sfx_enabletone_2 
sfx_disabletone_2: 
                    LDB      $C807                        ; set bit1 in reg7 
                    ORB      #%00000010 
                    LDA      #$07 
                    STB      A,X                          ; disable tone 
                    BRA      sfx_checknoisedisable_2 

sfx_enabletone_2: 
                    LDB      $C807                        ; clear bit1 in reg7 
                    ANDB     #%11111101 
                    LDA      #$07 
                    STB      A,X                          ; enable tone 
sfx_checknoisedisable_2: 
                    LDB      ,U                           ; check disable noise 
                    BITB     #%10000000                   ; if bit7 of B is set disable noise 
                    BEQ      sfx_enablenoise_2 
sfx_disablenoise_2: 
                    LDB      $C807                        ; set bit4 in reg7 
                    ORB      #%00010000 
                    LDA      #$07 
                    STB      A,X                          ; disable noise 
                    BRA      sfx_nextframe_2 

sfx_enablenoise_2: 
                    LDB      $C807                        ; clear bit4 in reg 7 
                    ANDB     #%11101111 
                    LDA      #$07 
                    STB      A,X                          ; enable noise 
sfx_nextframe_2: 
                    STY      sfx_pointer_2                ; update frame pointer to next flag byte in Y 
                    RTS      

sfx_endofeffect_2: 
                    LDB      #$00                         ; set volume off channel 2 
                    LDA      #$09                         ; set reg1sf0 
                    STB      A,X                          ; Set volume 
                    LDD      #$0000                       ; reset sfx 
                    STD      sfx_pointer_2 
                    STA      sfx_status_2 
                    RTS      

;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;
sfx_endofeffect_3: 
                    LDB      #$00                         ; set volume off channel 3 
                    LDA      #$0A                         ; set reg1sf0 
                    STB      A,X                          ; Set volume 
                    LDD      #$0000                       ; reset sfx 
                    STD      sfx_pointer_3 
                    STA      sfx_status_3 
                    RTS      

sfx_doframe_intern_3: 
                    LDU      sfx_pointer_3                ; get current frame pointer 
                    LDB      ,U 
                    CMPB     #$D0                         ; check first flag byte D0 
                    BNE      sfx_checktonefreq_3          ; no match - continue to process frame 
                    LDB      1,U 
                    CMPB     #$20                         ; check second flag byte 20 
                    BEQ      sfx_endofeffect_3            ; match - end of effect found so stop playing 
sfx_checktonefreq_3: 
                    LEAY     1,U                          ; init Y as pointer to next data or flag byte 
                    LDB      ,U                           ; check if need to set tone freq 
                    BITB     #%00100000                   ; if bit 5 of B is set 
                    BEQ      sfx_checknoisefreq_3         ; skip as no tone freq data 
                    LDB      1,U                          ; get next data byte and copy to tone freq reg4 
                    LDA      #$04 
                    STB      A,X                          ; set tone freq 
                    LDB      2,U                          ; get next data byte and copy to tone freq reg5 
                    LDA      #$05 
                    STB      A,X                          ; set tone freq 
                    LEAY     2,Y                          ; increment pointer to next data/flag byte 
sfx_checknoisefreq_3: 
                    LDB      ,U                           ; check if need to set noise freq 
                    BITB     #%01000000                   ; if bit 6 of B is only set 
                    BEQ      sfx_checkvolume_3            ; skip as no noise freq data 
                    LDB      ,Y                           ; get next data byte and copy to noise freq reg 
                    LDA      #$06 
                    STB      A,X                          ; set noise freq 
                    LEAY     1,Y                          ; increment pointer to next flag byte 
sfx_checkvolume_3: 
                    LDB      ,U                           ; set volume on channel 3 
                    ANDB     #%00001111                   ; get volume from bits 0-3 
                    LDA      #$0A                         ; set reg10 
                    STB      A,X                          ; Set volume 
sfx_checktonedisable_3: 
                    LDB      ,U                           ; check disable tone channel 3 
                    BITB     #%00010000                   ; if bit 4 of B is set disable the tone 
                    BEQ      sfx_enabletone_3 
sfx_disabletone_3: 
                    LDB      $C807                        ; set bit2 in reg7 
                    ORB      #%00000100 
                    LDA      #$07 
                    STB      A,X                          ; disable tone 
                    BRA      sfx_checknoisedisable_3 

sfx_enabletone_3: 
                    LDB      $C807                        ; clear bit2 in reg7 
                    ANDB     #%11111011 
                    LDA      #$07 
                    STB      A,X                          ; enable tone 
sfx_checknoisedisable_3: 
                    LDB      ,U                           ; check disable noise 
                    BITB     #%10000000                   ; if bit7 of B is set disable noise 
                    BEQ      sfx_enablenoise_3 
sfx_disablenoise_3: 
                    LDB      $C807                        ; set bit5 in reg7 
                    ORB      #%00100000 
                    LDA      #$07 
                    STB      A,X                          ; disable noise 
                    BRA      sfx_nextframe_3 

sfx_enablenoise_3: 
                    LDB      $C807                        ; clear bit5 in reg 7 
                    ANDB     #%11011111 
                    LDA      #$07 
                    STB      A,X                          ; enable noise 
sfx_nextframe_3: 
                    STY      sfx_pointer_3                ; update frame pointer to next flag byte in Y 
                    RTS      

sfx_endofeffect_3: 
                    LDB      #$00                         ; set volume off channel 3 
                    LDA      #$0A                         ; set reg1sf0 
                    STB      A,X                          ; Set volume 
                    LDD      #$0000                       ; reset sfx 
                    STD      sfx_pointer_3 
                    STA      sfx_status_3 
                    RTS      
