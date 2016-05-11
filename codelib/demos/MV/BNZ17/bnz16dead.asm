init_part_gfx_stecher:					;; GFX 1 : STECHER-OUTLINE
		lda #FX_READY
		sta fx_fadeover
		jsr initstecher
		rts
init_part_gfx_stecher_fadeout:					;; GFX 1 : STECHER-OUTLINE
		jsr initstecher_fadeout
		rts
part_gfx_stecher:	
		lda fx_fadeover
		cmpa #FX_OVER
		beq part4_2
		jsr fadeover
		rts
part4_2: 		
		jsr drawstecher
		rts

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; stecherbild          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
initstecher:
		lda #1
		sta gfx_di
		sta gfx_intensity
		sta gfx_dx
		lda #-30
		sta gfx_xpos
		rts
initstecher_fadeout:
		lda #-1
		sta gfx_di
		rts


drawstecher:
        ldx #miezezwo
        jsr drawgfx
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Coolfont            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;-----------------------------------------------------------------------;
;       F495    Print_Str                                               ;
;                                                                       ;
; This is the routine which does the actual printing of a string.  The  ;
; U register points to the start of the string, while $C82A contains    ;
; the height of the character, cell, and $C82B contains the width of    ;
; the character cell.  The string is terminated with an 0x80.           ;
;                                                                       ;
; The string is displayed by drawing 7 horizontal rows of dots.  The    ;
; first row is drawn for each character, then the second, etc.  The     ;
; character generation table is located at ($F9D4 + $20).  Only         ;
; characters 0x20-0x6F (upper case) are defined; the lower case         ;
; characters a-o produce special icons.                                 ;
;                                                                       ;
; ENTRY DP = $D0                                                        ;
;       U-reg points to the start of the string                         ;
;                                                                       ;
; EXIT: U-reg points to next byte after terminator                      ;
;                                                                       ;
;       D-reg, X-reg trashed                                            ;
;-----------------------------------------------------------------------;
pixelgfx_bidi:       STU     Vec_Str_Ptr     ;Save string pointer
                LDX     chartabaddr ;Point to start of chargen bitmaps
                LDD     #$1883          ;$8x = enable RAMP?
                CLR     <VIA_port_a     ;Clear D/A output
                STA     <VIA_aux_cntl   ;Shift reg mode = 110, T1 PB7 enabled
                LDX     chartabaddr ;Point to start of chargen bitmaps
                
LF4A5_2:          STB     <VIA_port_b     ;Update RAMP, set mux to channel 1
                DEC     <VIA_port_b     ;Enable mux
                LDD     #$8081
                NOP                     ;Wait a moment
                INC     <VIA_port_b     ;Disable mux
                STB     <VIA_port_b     ;Enable RAMP, set mux to channel 0
                STA     <VIA_port_b     ;Enable mux
                TST     $C800           ;I think this is a delay only
                INC     <VIA_port_b     ;Enable RAMP, disable mux
;                inc		Vec_Text_Width ;tilt
;                inc		Vec_Text_Width ;tilt
                LDA     Vec_Text_Width  ;Get text width
                NEG Vec_Text_Width
                STA     <VIA_port_a     ;Send it to the D/A
                LDD     #$0100
                LDU     Vec_Str_Ptr     ;Point to start of text string
                STA     <VIA_port_b     ;Enable RAMP, disable mux
                BRA     LF4CB_2

LF4C7_2:          LDA     A,X             ;Get bitmap from chargen table
                STA     <VIA_shift_reg  ;This loop needs to have exactly 18 cycles (8*2+2)
LF4CB_2:          LDA     ,U+             ;Get next character
                BPL     LF4C7_2           ;Go back if not terminator
                clra
                nop
                
                sta <VIA_shift_reg

                
                andcc #$FF
                nop
                nop
;				nop
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                LDA     #$81
                STA     <VIA_port_b     ;Disable RAMP, disable mux
                NEG     <VIA_port_a     ;Negate text width to D/A
;                dec		<VIA_port_a    ;tilt
                LDA     #$01
                STA     <VIA_port_b     ;Disable RAMP, disable mux
                CMPX    chartabend;     Check for last row
                BEQ     LF50A_2EXIT_2           ;Branch if last row
                LEAX    $50,X           ;Point to next chargen row
                ; Skip return vector move
                lda     #$81
                bra		LF4EX_2
                ; End Skip
                TFR     U,D             ;Get string length
                SUBD    Vec_Str_Ptr
                SUBB    #$02            ; -  2
                ASLB                    ; *  2
;                BRN     LF4EB_2           ;Delay a moment
LF4EB_2:          LDA     #$81
                NOP
                DECB
                BNE     LF4EB_2           ;Delay some more in a loop
LF4EX_2:          STA     <VIA_port_b     ;Enable RAMP, disable mux
                ;;;;;;;;;;;;; FLD Y
                LDb     font_sinidx2 ;Get text height
                addb	#8
                andb	#$3f
                stb		font_sinidx2
                ldy		sintabaddr
                lda		b,y
                asra
                asra
                asra
                nega
                ;;; FLD orig code
  ;       LDA Vec_Text_Height
                ;;;;;;;;;;;;; End FLD Y
                STa     <VIA_port_a     ;Store text height in D/A
                DEC     <VIA_port_b     ;Enable mux
                LDD     #$8101
                NOP                     ;Wait a moment
                STA     <VIA_port_b     ;Enable RAMP, disable mux
                CLR     <VIA_port_a     ;Clear D/A
                STB     <VIA_port_b     ;Disable RAMP, disable mux
                STA     <VIA_port_b     ;Enable RAMP, disable mux
                LDB     #$03            ;$0x = disable RAMP?
                BRA     LF4X1_2           ;Go back for next scan line
LF50A_2EXIT_2:
				jmp LF50A_2                

LF4X1_2:          STB     <VIA_port_b     ;Update RAMP, set mux to channel 1
                DEC     <VIA_port_b     ;Enable mux
                LDD     #$8081
                NOP                     ;Wait a moment
                INC     <VIA_port_b     ;Disable mux
                STB     <VIA_port_b     ;Enable RAMP, set mux to channel 0
                STA     <VIA_port_b     ;Enable mux
                TST     $C800           ;I think this is a delay only
                INC     <VIA_port_b     ;Enable RAMP, disable mux
;                inc		Vec_Text_Width ;tilt
 ;               inc		Vec_Text_Width ;tilt
                LDA     Vec_Text_Width  ;Get text width
                NEG Vec_Text_Width
                STA     <VIA_port_a     ;Send it to the D/A
				lda ,-u					;dec str ptr by 1
                LDD     #$0100
                
;                LDY     Vec_Str_Ptr     ;Point to start of text string
                STA     <VIA_port_b     ;Enable RAMP, disable mux
                BRA     LF4X3_2

LF4X2_2:          LDA     A,X             ;Get bitmap from chargen table
                STA     <VIA_shift_reg  ;This loop needs to have exactly 18 cycles (8*2+2)
LF4X3_2:          LDA     ,-U             ;Get next character
                BPL     LF4X2_2           ;Go back if not terminator
                nop
                clra
                sta <VIA_shift_reg
                nop
                nop
                
;                nop
                nop
                andcc #$FF
                nop
                nop
                nop
                nop
                nop
                nop
                LDA     #$81
                STA     <VIA_port_b     ;Disable RAMP, disable mux
                NEG     <VIA_port_a     ;Negate text width to D/A
                dec		<VIA_port_a    ;tilt
                LDA     #$01
                STA     <VIA_port_b     ;Disable RAMP, disable mux
                CMPX    chartabend;     Check for last row
                BEQ     LF50A_2           ;Branch if last row
                LEAX    $50,X           ;Point to next chargen row
                ; Skip return vector move
                lda     #$81
                bra		LF4X5_2
                ; End Skip
                TFR     U,D             ;Get string length
                SUBD    Vec_Str_Ptr
                SUBB    #$02            ; -  2
                ASLB                    ; *  2
;                BRN     LF4X4_2           ;Delay a moment
LF4X4_2:          LDA     #$81
                NOP
                DECB
                BNE     LF4X4_2           ;Delay some more in a loop
LF4X5_2:          STA     <VIA_port_b     ;Enable RAMP, disable mux
                ;;;;;;;;;;;;; FLD Y
                LDb     font_sinidx2 ;Get text height
                addb	#8
                andb	#$3f
                stb		font_sinidx2
                ldu		#sintab
                lda		b,u
                asra
                asra
                asra
                nega
                ;;; FLD orig. code
   ;    LDA Vec_Text_Height
                ;;;;;;;;;;;;; End FLD Y
                STa     <VIA_port_a     ;Store text height in D/A
                DEC     <VIA_port_b     ;Enable mux
                LDD     #$8101
                NOP                     ;Wait a moment
                STA     <VIA_port_b     ;Enable RAMP, disable mux
                CLR     <VIA_port_a     ;Clear D/A
                STB     <VIA_port_b     ;Disable RAMP, disable mux
                STA     <VIA_port_b     ;Enable RAMP, disable mux
                LDB     #$03            ;$0x = disable RAMP?
                bra     LF4A5_2           ;Go back for next scan line

LF50A_2:          LDA     #$98
                STA     <VIA_aux_cntl   ;T1->PB7 enabled
                JMP     Reset0Ref       ;Reset the zero reference
                
              