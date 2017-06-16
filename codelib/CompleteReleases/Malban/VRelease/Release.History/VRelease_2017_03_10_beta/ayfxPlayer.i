;
sfx_doframe: 
                    LDU      sfx_pointer                  ; get current frame pointer 
                    LDB      ,U 
                    CMPB     #$D0                         ; check first flag byte D0 
                    BNE      sfx_checktonefreq            ; no match - continue to process frame 
                    LDB      1,U 
                    CMPB     #$20                         ; check second flag byte 20 
                    BEQ      sfx_endofeffect              ; match - end of effect found so stop playing 
sfx_checktonefreq: 
                    LEAY     1,U                          ; init Y as pointer to next data or flag byte 
                    LDB      ,U                           ; check if need to set tone freq 
                    BITB     #%00100000                   ; if bit 5 of B is set 
                    BEQ      sfx_checknoisefreq           ; skip as no tone freq data 
                    LDB      1,U                          ; get next data byte and copy to tone freq reg4 
                    LDA      #$04 
                    JSR      Sound_Byte                   ; set tone freq 
                    LDB      2,U                          ; get next data byte and copy to tone freq reg5 
                    LDA      #$05 
                    JSR      Sound_Byte                   ; set tone freq 
                    LEAY     2,Y                          ; increment pointer to next data/flag byte 
sfx_checknoisefreq: 
                    LDB      ,U                           ; check if need to set noise freq 
                    BITB     #%01000000                   ; if bit 6 of B is only set 
                    BEQ      sfx_checkvolume              ; skip as no noise freq data 
                    LDB      ,Y                           ; get next data byte and copy to noise freq reg 
                    LDA      #$06 
                    JSR      Sound_Byte                   ; set noise freq 
                    LEAY     1,Y                          ; increment pointer to next flag byte 
sfx_checkvolume: 
                    LDB      ,U                           ; set volume on channel 3 
                    ANDB     #%00001111                   ; get volume from bits 0-3 
                    LDA      #$0A                         ; set reg10 
                    JSR      Sound_Byte                   ; Set volume 
sfx_checktonedisable: 
                    LDB      ,U                           ; check disable tone channel 3 
                    BITB     #%00010000                   ; if bit 4 of B is set disable the tone 
                    BEQ      sfx_enabletone 
sfx_disabletone: 
                    LDB      $C807                        ; set bit2 in reg7 
                    ORB      #%00000100 
                    LDA      #$07 
                    JSR      Sound_Byte                   ; disable tone 
                    BRA      sfx_checknoisedisable 

sfx_enabletone: 
                    LDB      $C807                        ; clear bit2 in reg7 
                    ANDB     #%11111011 
                    LDA      #$07 
                    JSR      Sound_Byte                   ; enable tone 
sfx_checknoisedisable: 
                    LDB      ,U                           ; check disable noise 
                    BITB     #%10000000                   ; if bit7 of B is set disable noise 
                    BEQ      sfx_enablenoise 
sfx_disablenoise: 
                    LDB      $C807                        ; set bit5 in reg7 
                    ORB      #%00100000 
                    LDA      #$07 
                    JSR      Sound_Byte                   ; disable noise 
                    BRA      sfx_nextframe 

sfx_enablenoise: 
                    LDB      $C807                        ; clear bit5 in reg 7 
                    ANDB     #%11011111 
                    LDA      #$07 
                    JSR      Sound_Byte                   ; enable noise 
sfx_nextframe: 
                    STY      sfx_pointer                  ; update frame pointer to next flag byte in Y 
                    RTS      

sfx_endofeffect: 
                    LDB      #$00                         ; set volume off channel 3 
                    LDA      #$0A                         ; set reg1sf0 
                    JSR      Sound_Byte                   ; Set volume 
                    LDD      #$0000                       ; reset sfx 
                    STD      sfx_pointer 
                    STA      sfx_status 
                    RTS      
