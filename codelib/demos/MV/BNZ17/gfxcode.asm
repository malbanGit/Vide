; graphics display routines

		   fcb -1
unitytab   fcb 0
		   fcb 1
		   fcb 2
		   	
		   fcb 0
hiddentab  fcb 0
		   fcb 1
		   fcb 2
		   fcb 2
solidtab   fcb 0
		   fcb 1
		   fcb 2


loadvid:
		sta vid_framecount
		clra
		sta logo_curframe
		tfr x,d
		std vid_frametab
		ldd #unitytab
		std vid_transtab
		jsr copy_nextframe
		rts
playvid:
		clra
		clrb
		jsr Moveto_d			; do a "fake" move, so that the drawing hardware is correctly initialized. will be obsolete later.
;		lda #$7f
;		jsr intensitytoA
;		lda VIA_t2_hi
		jsr interpolateframe
		jsr compressframe
		jsr drawframe
		rts
		


drawframe:
;		ldb #$7F
;		stb   VIA_t1_cnt_lo      ;Set scale factor
		jsr DP_to_D0
        ldx #logo_compressed
		jsr draw_vl_mode
		rts
		
interpolateframe:
		dec logo_temp			; decrease anim duration
		beq copy_nextframe		; fetch next frame if expired
		ldx #logo_temp+2		; load adress of masking effect
		ldb ,x++					; load masking effect
		beq	interpolate_next	; skip if none
ip_case1:
		clra
		lda logo_temp+1
		rora
		bcc ip_case1b
		adca #128
ip_case1b:
		sta logo_temp+1				; save at mask position
interpolate_next:		
		ldd ,x					; load x
		addd 4,x				; add dx
		std ,x++				; store x
		ldd ,x					; load y
		addd 4,x				; add dy
		std ,x++				; store y
		lda ,x++				; skip dx
		lda ,x++				; skip dy
		lda ,x+					; fetch drawmode
		cmpa #1					; finished?
		bne interpolate_next
		rts
		
compressframe:
		clra
		sta remainderX
		sta remainderY
		ldx #logo_temp			;source
		ldy #logo_compressed	;destination
		lda ,x+					; skip duration
		lda ,x+					; read pattern
		sta Vec_Pattern			; store to bios location
		lda ,x+ 				; skip masking effect
compressframe_next:				
		lda ,x+					; copy drawmode
		ldu	vid_transtab
		lda a,u
		sta ,y+
		cmpa #1					; end marker?
		beq compressframe_out
		lda ,x+				; copy x-hi
		ldb ,x+				; skip x-lo
		addb remainderX
		stb remainderX
		adca #0
savex:
		sta ,y+
		lda ,x+				; copy y-hi
		ldb ,x+				; skip y-lo
		addb remainderY
		stb remainderY
		adca #0
savey:
		sta ,y+
		lda ,x++				; skip increments (x4)
		lda ,x++
		bra compressframe_next
compressframe_out: 
		rts
		
copy_nextframe:						; calculate start address for copying
		lda logo_curframe			; which is current frame no.
		
		asla						; mul by 2
		ldx vid_frametab				; load table base
		ldd a,x						; load frame addr from table
		tfr d,x						; result -> x (source reg)
		lda logo_curframe			; incr/check overflow of curframe
		inca
		cmpa vid_framecount				; compare with no of frames
		bne copy_logo				; 
		clra
copy_logo:							; copy current keyframe to tmp
		sta logo_curframe			; write back number of current frame
		ldy #logo_temp				; load destination
copy_loop:							; actual copying
		lda ,x+						; read duration
		sta ,y+						; write duration
		ldd ,x++					; read masking
		std ,y++					; write masking
copy_loop_inner:
		lda ,x+						; read drawmode
		sta ,y+						; write drawmode
		cmpa #1						; finished?
		beq copy_loop_done
		ldd ,x++					; copy 8 bytes (x,y,dx,dy)
		std ,y++
		ldd ,x++
		std ,y++
		ldd ,x++
		std ,y++
		ldd ,x++
		std ,y++
		bra copy_loop_inner


copy_loop_done:
		rts
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GFX Display Routine   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

GFXSUBCNT EQU 6
drawgfx:
		lda #$3f
		sta VIA_t1_cnt_lo
		lda gfx_intensity
		adda gfx_di
		bvs draw_gfx_di_done
		beq draw_gfx_di_done
draw_gfx_draw:
		sta gfx_intensity
		jsr intensitytoA
		clra
		ldb gfx_dxsubcnt
		incb
		cmpb #GFXSUBCNT
		beq  draw_gfx_updatex
draw_gfx_updatex_done:
		stb gfx_dxsubcnt
		ldb gfx_xpos
		jsr Moveto_d
		jsr draw_vl_mode
		rts
draw_gfx_di_done:
		suba gfx_di
		sta gfx_intensity
		clr gfx_di
		jmp draw_gfx_draw
draw_gfx_updatex:
		ldb gfx_xpos
		addb gfx_dx
		stb gfx_xpos
		clrb
		jmp draw_gfx_updatex_done	
		

               
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

pixelgfx:      STU     Vec_Str_Ptr     ;Save string pointer
                LDX     chartabaddr ;Point to start of chargen bitmaps
                LDD     #$1883          ;$8x = enable RAMP?
                CLR     <VIA_port_a     ;Clear D/A output
                STA     <VIA_aux_cntl   ;Shift reg mode = 110, T1 PB7 enabled
                LDX     chartabaddr ;Point to start of chargen bitmaps
LF4A5:          STB     <VIA_port_b     ;Update RAMP, set mux to channel 1
                DEC     <VIA_port_b     ;Enable mux
                LDD     #$8081
                NOP                     ;Wait a moment
                INC     <VIA_port_b     ;Disable mux
                STB     <VIA_port_b     ;Enable RAMP, set mux to channel 0
                STA     <VIA_port_b     ;Enable mux
                TST     $C800           ;I think this is a delay only
                INC     <VIA_port_b     ;Enable RAMP, disable mux
                LDA     Vec_Text_Width  ;Get text width
                STA     <VIA_port_a     ;Send it to the D/A
                LDD     #$0100
                LDU     Vec_Str_Ptr     ;Point to start of text string
                STA     <VIA_port_b     ;Enable RAMP, disable mux
                BRA     LF4CB

LF4C7:          LDA     A,X             ;Get bitmap from chargen table
                STA     <VIA_shift_reg  ;This loop needs to have exactly 18 cycles (8*2+2)
LF4CB:          LDA     ,U+             ;Get next character
                BPL     LF4C7           ;Go back if not terminator
                clra
                sta <VIA_shift_reg
                LDA     #$81
                STA     <VIA_port_b     ;Disable RAMP, disable mux
                NEG     <VIA_port_a     ;Negate text width to D/A
                LDA     #$01
                STA     <VIA_port_b     ;Disable RAMP, disable mux
                CMPX    chartabend ;     Check for last row
                BEQ     LF50A           ;Branch if last row
                LEAX    $1C,X           ;Point to next chargen row
                TFR     U,D             ;Get string length
                SUBD    Vec_Str_Ptr
                SUBB    #$02            ; -  2
                ASLB                    ; *  2
                ANDCC #$FF				;Delay a moment 
                BRN     LF4EB           
LF4EB:          LDA     #$81
                NOP
                DECB
                BNE     LF4EB           ;Delay some more in a loop
                STA     <VIA_port_b     ;Enable RAMP, disable mux
                
                                ;;;;;;;;;;;;; FLD Y
                LDb     font_sinidx2 ;Get text height
                addb	#8
                andb	#$3f
                stb		font_sinidx2
                ldy		sintabaddr
                lda		b,y
;                asra
;                asra
;                asra
                nega
                ;;; FLD orig code
   ;      LDA Vec_Text_Height
                ;;;;;;;;;;;;; End Wobble Y
    ;            LDB     Vec_Text_Height ;Get text height
                STA     <VIA_port_a     ;Store text height in D/A
                DEC     <VIA_port_b     ;Enable mux
                LDD     #$8101
                NOP                     ;Wait a moment
                STA     <VIA_port_b     ;Enable RAMP, disable mux
                CLR     <VIA_port_a     ;Clear D/A
                STB     <VIA_port_b     ;Disable RAMP, disable mux
                STA     <VIA_port_b     ;Enable RAMP, disable mux
                LDB     #$03            ;$0x = disable RAMP?
                BRA     LF4A5           ;Go back for next scan line

LF50A:          LDA     #$98
                STA     <VIA_aux_cntl   ;T1->PB7 enabled
                JMP     Reset0Ref       ;Reset the zero reference
