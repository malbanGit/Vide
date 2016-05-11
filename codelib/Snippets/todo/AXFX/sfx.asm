                    	INCLUDE  "vectrex.i"
sfx_pointer         EQU      $c880 
sfx_status          EQU      $c882 
                    ORG      0 
                    	db      "g GCE 2014", $80 
                    dw       music1 
                    db       $F8, $50, $20, -$45 
                    	db      "SFXTEST",$80
                    db       0 
init: 
                    LDD      #$0000               ; init sfx vars 
                    STD      sfx_pointer 
                    STA      sfx_status 
                    JSR      Read_Btns            ; init button read 
loopforever: 
                    JSR      Wait_Recal           ; wait for vector refresh 
                    lda      #0                   ; Y-coordinate 
                    ldb      #-80                 ; X-coordinate 
                    ldu      #message1            ; print message 
                    jsr      Print_Str_d 
                    LDA      sfx_status           ; check if sfx to play 
                    BEQ      checkbuttons 
                    JSR      sfx_doframe 
checkbuttons: 
                    JSR      Read_Btns            ; get button status 
                    CMPA     #$00                 ; is a button pressed? 
                    BEQ      loopforever          ; no, than loop 
checkbutton1: 
                    BITA     #$01                 ; test for button 1 
                    BEQ      checkbutton2         ; if not pressed jump 
                    LDX      #sfx1                ; play sfx1 
                    STX      sfx_pointer 
                    LDA      #$01 
                    STA      sfx_status 
                    BRA      loopforever 

checkbutton2: 
                    BITA     #$02                 ; test for button 2 
                    BEQ      checkbutton3         ; if not pressed jump 
                    LDX      #sfx2                ; play sfx2 
                    STX      sfx_pointer 
                    LDA      #$01 
                    STA      sfx_status 
                    BRA      loopforever 

checkbutton3: 
                    BITA     #$04                 ; test for button 3 
                    BEQ      checkbutton4         ; if not pressed jump 
                    LDX      #sfx3                ; play sfx3 
                    STX      sfx_pointer 
                    LDA      #$01 
                    STA      sfx_status 
                    BRA      loopforever 

checkbutton4: 
                    BITA     #$08                 ; test for button 4 
                    BEQ      loopforever          ; if not pressed jump 
                    LDX      #sfx4                ; play sfx4 
                    STX      sfx_pointer 
                    LDA      #$01 
                    STA      sfx_status 
                    BRA      loopforever 

sfx_doframe: 
                    LDU      sfx_pointer          ; get current frame pointer 
                    LDB      ,U 
                    CMPB     #$D0                 ; check first flag byte D0 
                    BNE      sfx_checktonefreq    ; no match - continue to process frame 
                    LDB      1,U 
                    CMPB     #$20                 ; check second flag byte 20 
                    BEQ      sfx_endofeffect      ; match - end of effect found so stop playing 
sfx_checktonefreq: 
                    LEAY     1,U                  ; init Y as pointer to next data or flag byte 
                    LDB      ,U                   ; check if need to set tone freq 
                    BITB     #%00100000           ; if bit 5 of B is set 
                    BEQ      sfx_checknoisefreq   ; skip as no tone freq data 
                    LDB      1,U                  ; get next data byte and copy to tone freq reg4 
                    LDA      #$04 
                    JSR      Sound_Byte           ; set tone freq 
                    LDB      2,U                  ; get next data byte and copy to tone freq reg5 
                    LDA      #$05 
                    JSR      Sound_Byte           ; set tone freq 
                    LEAY     2,Y                  ; increment pointer to next data/flag byte 
sfx_checknoisefreq: 
                    LDB      ,U                   ; check if need to set noise freq 
                    BITB     #%01000000           ; if bit 6 of B is only set 
                    BEQ      sfx_checkvolume      ; skip as no noise freq data 
                    LDB      ,Y                   ; get next data byte and copy to noise freq reg 
                    LDA      #$06 
                    JSR      Sound_Byte           ; set noise freq 
                    LEAY     1,Y                  ; increment pointer to next flag byte 
sfx_checkvolume: 
                    LDB      ,U                   ; set volume on channel 3 
                    ANDB     #%00001111           ; get volume from bits 0-3 
                    LDA      #$0A                 ; set reg10 
                    JSR      Sound_Byte           ; Set volume 
sfx_checktonedisable: 
                    LDB      ,U                   ; check disable tone channel 3 
                    BITB     #%00010000           ; if bit 4 of B is set disable the tone 
                    BEQ      sfx_enabletone 
sfx_disabletone: 
                    LDB      $C807                ; set bit2 in reg7 
                    ORB      #%00000100 
                    LDA      #$07 
                    JSR      Sound_Byte           ; disable tone 
                    BRA      sfx_checknoisedisable 

sfx_enabletone: 
                    LDB      $C807                ; clear bit2 in reg7 
                    ANDB     #%11111011 
                    LDA      #$07 
                    JSR      Sound_Byte           ; enable tone 
sfx_checknoisedisable: 
                    LDB      ,U                   ; check disable noise 
                    BITB     #%10000000           ; if bit7 of B is set disable noise 
                    BEQ      sfx_enablenoise 
sfx_disablenoise: 
                    LDB      $C807                ; set bit5 in reg7 
                    ORB      #%00100000 
                    LDA      #$07 
                    JSR      Sound_Byte           ; disable noise 
                    BRA      sfx_nextframe 

sfx_enablenoise: 
                    LDB      $C807                ; clear bit5 in reg 7 
                    ANDB     #%11011111 
                    LDA      #$07 
                    JSR      Sound_Byte           ; enable noise 
sfx_nextframe: 
                    STY      sfx_pointer          ; update frame pointer to next flag byte in Y 
                    RTS      

sfx_endofeffect: 
                    LDB      #$00                 ; set volume off channel 3 
                    LDA      #$0A                 ; set reg1sf0 
                    JSR      Sound_Byte           ; Set volume 
                    LDD      #$0000               ; reset sfx 
                    STD      sfx_pointer 
                    STA      sfx_status 
                    RTS      

message1: 
                    	fcc	    "PRESS 1-4"
                    fcb      $80 
sfx1: 
                    fcb      $EE,$3C,$0,$C,$AE,$68,$0,$AE,$94,$0 
                    fcb      $AE,$C0,$0,$AE,$EC,$0,$AE,$18,$1,$AE 
                    fcb      $44,$1,$AD,$70,$1,$AD,$3C,$0,$AD,$68 
                    fcb      $0,$AD,$94,$0,$AC,$C0,$0,$AC,$EC,$0 
                    fcb      $AC,$18,$1,$AC,$44,$1,$AB,$70,$1,$AB 
                    fcb      $3C,$0,$AB,$68,$0,$AB,$94,$0,$AA,$C0 
                    fcb      $0,$AA,$EC,$0,$AA,$18,$1,$AA,$44,$1 
                    fcb      $A9,$70,$1,$A9,$3C,$0,$A9,$68,$0,$A9 
                    fcb      $94,$0,$A8,$C0,$0,$A8,$EC,$0,$A8,$18 
                    fcb      $1,$A8,$44,$1,$A7,$70,$1,$A7,$3C,$0 
                    fcb      $A7,$68,$0,$A7,$94,$0,$A6,$C0,$0,$A6 
                    fcb      $EC,$0,$A6,$18,$1,$A6,$44,$1,$A5,$70 
                    fcb      $1,$A5,$3C,$0,$A5,$68,$0,$A5,$94,$0 
                    fcb      $A4,$C0,$0,$A4,$EC,$0,$A4,$18,$1,$A4 
                    fcb      $44,$1,$A3,$70,$1,$A3,$3C,$0,$A3,$68 
                    fcb      $0,$A3,$94,$0,$A2,$C0,$0,$A2,$EC,$0 
                    fcb      $A2,$18,$1,$A2,$44,$1,$A1,$70,$1,$A1 
                    fcb      $3C,$0,$A1,$68,$0,$A1,$94,$0,$A1,$C0 
                    fcb      $0,$A1,$EC,$0,$A1,$18,$1,$A1,$44,$1 
                    fcb      $A1,$70,$1,$A1,$3C,$0,$A1,$68,$0,$A1 
                    fcb      $94,$0,$A1,$C0,$0,$A1,$EC,$0,$A1,$18 
                    fcb      $1,$A1,$44,$1,$A1,$70,$1,$A1,$3C,$0 
                    fcb      $A1,$68,$0,$A1,$94,$0,$A1,$C0,$0,$A1 
                    fcb      $EC,$0,$A1,$18,$1,$A1,$44,$1,$D0,$20 
sfx2: 
                    fcb      $6F,$1,$4,$7,$F,$2F,$64,$0,$F,$2E 
                    fcb      $5A,$0,$2E,$5C,$0,$2D,$5F,$0,$2D,$61 
                    fcb      $0,$2C,$64,$0,$2C,$66,$0,$2B,$69,$0 
                    fcb      $2B,$6B,$0,$2A,$6E,$0,$2A,$70,$0,$29 
                    fcb      $73,$0,$29,$75,$0,$28,$78,$0,$28,$7A 
                    fcb      $0,$27,$7D,$0,$27,$7F,$0,$26,$82,$0 
                    fcb      $26,$84,$0,$25,$87,$0,$25,$89,$0,$24 
                    fcb      $8C,$0,$24,$8E,$0,$23,$91,$0,$23,$93 
                    fcb      $0,$22,$96,$0,$22,$98,$0,$21,$9B,$0 
                    fcb      $D0,$20 
sfx3: 
                    fcb      $6F,$57,$0,$6,$4E,$C,$4D,$12,$4B,$18 
                    fcb      $4A,$16,$49,$1C,$48,$2,$47,$8,$46,$E 
                    fcb      $45,$14,$44,$1A,$43,$0,$42,$B,$41,$11 
                    fcb      $41,$17,$D0,$20 
sfx4: 
                    fcb      $7F,$F7,$1,$1,$1F,$1F,$5C,$2,$5A,$1 
                    fcb      $58,$2,$18,$56,$1,$52,$2,$12,$12,$D0 
                    fcb      $20 
