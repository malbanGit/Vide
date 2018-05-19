; graphics display routines


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Memory structure scheme   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ROM: ;
;;;;;;;;
; duration
; mask pattern
; mask effect
;;;;;;;;
; mode (!=3):	(=3):			
; xhi			intensity
; yhi
; dxhi
; dxlo
; dyhi
; dylo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; RAM (interpolate)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; xhi
; xlo
; yhi
; ylo
;;;;;;;;;;;;;;;;;;;;;;;;;;;
; RAM (compressed)
;;;;;;;;;;;;;;;;;;;;;;;;;;;
; x
; y
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mode translation tables ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;


		   


loadvid:
		sta vid_framecount
		clra
		sta logo_curframe
		tfr x,d
		std vid_frametab
		lda #1					; remember the vid is ready
		sta vid_running
		ldd #unitytab
		std vid_transtab
		dec logo_curframe	  ; adjust counter, for it's increased on first copy
		jsr copy_nextframe
		rts
playvidonce:
		clra
		clrb
		jsr Moveto_d			; do a "fake" move, so that the drawing hardware is correctly initialized. will be obsolete later.
		lda vid_running
		beq playvid_draw
		jsr framefwd
playvid_draw:		bsr drawframe
		rts

playvid:
		clra
		clrb
		jsr Moveto_d			; do a "fake" move, so that the drawing hardware is correctly initialized. will be obsolete later.
		lda vid_running
		bne playvid_draw2
		lda vid_framecount
		ldx vid_frametab
		bsr loadvid
playvid_draw2:		
		jsr framefwd
		bsr drawframe
		rts

drawframe:
		jsr DP_to_D0
        ldx #logo_temp
		bsr Draw_VL_Mode_i_anim
		rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; equivalent to Draw_VL_Mode  ;
; addtl. interprets dm=3 as   ;
; setIntensity                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Draw_VL_Mode_i_anim:   lda     Vec_0Ref_Enable ;Save old Check0Ref flag
                pshs    a
				pshs u
				ldu vid_transtab		; load drawing translation
                clra
				clrb
				jsr Moveto_d
				sta remainderX
				sta remainderY
				lda ,x+					; skip duration
				lda ,x+					; read pattern
				sta vid_pattern			; store to pattern location
				lda ,x+ 				; skip masking effect
                ldy		logo_rom
                leay	3,y				; skip duration, pattern, patterneffect
                clr     Vec_0Ref_Enable ;Don't reset the zero reference yet
draw_loop:      lda     ,y+             ;Get the next mode byte
				lsla					; table entries are 2 bytes wide (short bra)
				jmp a,u
				; jumptables
				bra draw_pat
unitytab:		bra draw_mov
				bra draw_exit
				bra draw_sol
				bra draw_intensity
				;;;;
				bra draw_mov	; map pattern to move
hiddentab:  	bra draw_mov
				bra draw_exit
				bra draw_sol
				bra draw_intensity
				;;;;
				bra draw_sol	; map pattern to solid
solidtab:   	bra draw_mov
				bra draw_exit
				bra draw_sol
				bra draw_intensity
				; end jumptables
draw_pat:		lda vid_pattern			; load real pattern
				bra do_draw
draw_mov:		clra
				bra do_draw
draw_sol:		lda #$FF				; set solid pattern
do_draw:                
				sta Vec_Pattern			; store to bios location
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				; put effective values for x/y to dac  ;
				; sum up fraction part to remainderX/Y ;
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
				;; calculate X 
				ldd 2,x				; load x
				addb remainderX		; adjust remainder
				stb remainderX
				adca #0
				pshs a				; remember X, we need Y on the d/a first
				; calculate Y
				ldd ,x				; load y
				addb remainderY		; adjust remainder
				stb remainderY
				adca #0
				ldb #$40
waitline:		bitb VIA_int_flags ; wait until last line was drawn
				beq waitline
				clr     <VIA_shift_reg ; turn off beam
				;; INLINE Draw_Pat_VL_d
				sta     <VIA_port_a     ;Send Y to A/D
                clr     <VIA_port_b     ;Enable mux
				puls a					; fetch X
				; output
                inc     <VIA_port_b     ;Disable mux
                sta     <VIA_port_a     ;Send X to A/D
                leax    4,x             ;Point to next coordinate pair
                lda     Vec_Pattern     ;Get default pattern
                ldb     #$40            ;B-reg = T1 interrupt bit
                sta     <VIA_shift_reg  ;Put pattern in shift register
                clr     <VIA_t1_cnt_hi  ; Trigger start actual drawing
				leay	6,y				; adjust rom-pointer
                bra     draw_loop
draw_intensity: ldb #$40				; we need the d/a, so we have to wait for the last line to be complete
				bitb VIA_int_flags
				beq draw_intensity
				clr <VIA_shift_reg
				lda		,y+
                jsr		intensitytoA
                bra     draw_loop

draw_exit:     	puls u
    			puls    a               ;If =1, exit
                sta     Vec_0Ref_Enable ;Restore old Check0Ref flag
				ldb #$40
waitline2:		bitb VIA_int_flags ; wait until last line was drawn
				beq waitline2
				clr     <VIA_shift_reg ; turn off beam
                jmp     Check0Ref       ;Reset zero reference if necessary

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; equivalent to Draw_VL_Mode  ;
; addtl. interprets dm=3 as   ;
; setIntensity                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Draw_VL_Mode_i:   lda     Vec_0Ref_Enable ;Save old Check0Ref flag
                pshs    a
                clr     Vec_0Ref_Enable ;Don't reset the zero reference yet
LF476y:          lda     ,x+             ;Get the next mode byte
                bpl     LF47Ey
                jsr     Draw_Pat_VL     ;If <0, draw a patterned line
                bra     LF476y

LF47Ey:          bne     LF485y
                jsr     Mov_Draw_VL     ;If =0, move to the next point
                bra     LF476y

LF485y:          deca
                beq     LF48Dy			; test =1? -> exit
                deca
                deca
                beq		newIntensity3
                jsr     Draw_VL         ;If <>1, draw a solid line
                bra     LF476y
newIntensity3:   lda		,x+
                jsr		intensitytoA
                bra     LF476y

LF48Dy:          puls    a               ;If =1, exit
                sta     Vec_0Ref_Enable ;Restore old Check0Ref flag
                jmp     Check0Ref       ;Reset zero reference if necessary                
                
; y points to rom
; x points to ram		
framefwd:
		dec logo_temp			; decrease anim duration
		ble copy_nextframe		; fetch next frame if expired
		ldy logo_rom
		ldx #logo_temp+3		; load adress of masking effect
		leay 2,y
		ldb ,y+					; load masking effect
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
        lda ,y+
        cmpa #3
        bne interpolate_next2
;        sta ,x+						; copy intensity cmd to ram
        lda ,y+
;        sta ,x+
        leay 1,y
interpolate_next2:		
		ldd ,x					; load x 
		addd 2,y				; add dx 
		std ,x++				; store x 
		ldd ,x					; load y 
		addd 4,y				; add dy 
		std ,x++				; store y
		leay 6,y
		lda ,y					; fetch drawmode
		cmpa #1					; finished?
		bne interpolate_next
		rts
copy_nextframe:
		bsr switch_fwd
		bsr	copy_frame
		rts		
; y points to rom
; x points to ram		
frameback:
		lda logo_temp
		inca
		sta logo_temp			; decrease anim duration
		ldy logo_rom
		cmpa 0,y
		bgt copy_prevframe		; fetch next frame if expired
		ldx #logo_temp+3		; load adress of masking effect
		leay 2,y
		ldb ,y+					; load masking effect
		beq	interpolate_nextba	; skip if none
ip_case1ba:
		clra
		lda logo_temp+1
		rora
		bcc ip_case1bba
		adca #128
ip_case1bba:
		sta logo_temp+1				; save at mask position
interpolate_nextba:
		lda ,y+
		cmpa #3
		bne interpolate_nextba2
;		sta ,x+						; copy intensity cmd to ram
        lda ,y+
;        sta ,x+		
        leay 1,y
interpolate_nextba2:		
		ldd ,x					; load x 
		subd 2,y				; add dx 
		std ,x++				; store x 
		ldd ,x					; load y 
		subd 4,y				; add dy 
		std ,x++				; store y
		leay 6,y
		lda ,y					; fetch drawmode
		cmpa #1					; finished?
		bne interpolate_nextba
		rts
		

copy_prevframe:
		bsr	copy_frame
		bsr switch_back
		lda #1
		sta logo_temp		; clear duration as this is the end position of the anim
		rts
copy_frame:						; calculate start address for copying
		ldx logo_rom
		ldy #logo_temp				; load destination
copy_loop:							; actual copying
		lda ,x+						; read duration
		sta ,y+						; write duration
		ldd ,x++					; read masking
		std ,y++					; write masking
copy_loop_inner:
		lda ,x+						; read drawmode
		cmpa #1						; finished?
		beq copy_loop_done
		cmpa #3
		bne copy_inner2				; skip 2 bytes if cmd==3
		leax 1,x
		bra copy_loop_inner
copy_inner2:	
		clrb						; copy 8 bytes (x,y,dx,dy)
		lda ,x+						; extend x,y to word
		std ,y++
		lda ,x+
		std ,y++
		leax 4,x					; adjust rom ptr past dx,dy
		bra copy_loop_inner
copy_loop_done:
		rts
		

switch_fwd:
		lda logo_curframe			; incr/check overflow of curframe
		inca
		cmpa vid_framecount				; compare with no of frames
		bne copy_logo				; 
		clra
		sta vid_running				; also clear running flag
		puls d
		rts
copy_logo:							; copy current keyframe to tmp
		sta logo_curframe			; write back number of current frame
		asla						; mul by 2
		ldx vid_frametab				; load table base
		ldx a,x						; load frame addr from table -> x
		stx logo_rom

		rts
switch_back:

		lda logo_curframe			; incr/check overflow of curframe
		deca
		cmpa #-1				; compare with no of frames
		bne copy_logo				; 
		lda #1
		sta vid_running
		lda vid_framecount
		deca
		bra copy_logo

		
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GFX Display Routine   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

GFXSUBCNT equ 6
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
		jsr Draw_VL_Mode
		rts
draw_gfx_di_done:
		suba gfx_di
		sta gfx_intensity
		clr gfx_di
		bra draw_gfx_draw
draw_gfx_updatex:
		ldb gfx_xpos
		addb gfx_dx
		stb gfx_xpos
		clrb
		bra draw_gfx_updatex_done	
		

               
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

pixelgfx:      stu     Vec_Str_Ptr     ;Save string pointer
                ldx     chartabaddr ;Point to start of chargen bitmaps
                ldd     #$1883          ;$8x = enable RAMP?
                clr     <VIA_port_a     ;Clear D/A output
                sta     <VIA_aux_cntl   ;Shift reg mode = 110, T1 PB7 enabled
                ldx     chartabaddr ;Point to start of chargen bitmaps
LF4A5:          stb     <VIA_port_b     ;Update RAMP, set mux to channel 1
                dec     <VIA_port_b     ;Enable mux
                ldd     #$8081
                nop                     ;Wait a moment
                inc     <VIA_port_b     ;Disable mux
                stb     <VIA_port_b     ;Enable RAMP, set mux to channel 0
                sta     <VIA_port_b     ;Enable mux
                tst     $C800           ;I think this is a delay only
                inc     <VIA_port_b     ;Enable RAMP, disable mux
                lda     Vec_Text_Width  ;Get text width
                sta     <VIA_port_a     ;Send it to the D/A
                ldd     #$0100
                ldu     Vec_Str_Ptr     ;Point to start of text string
                sta     <VIA_port_b     ;Enable RAMP, disable mux
                bra     LF4CB

LF4C7:          lda     a,x             ;Get bitmap from chargen table
                sta     <VIA_shift_reg  ;This loop needs to have exactly 18 cycles (8*2+2)
LF4CB:          lda     ,u+             ;Get next character
                bpl     LF4C7           ;Go back if not terminator
                clra
                sta <VIA_shift_reg
                lda     #$81
                sta     <VIA_port_b     ;Disable RAMP, disable mux
                neg     <VIA_port_a     ;negate text width to D/A
                lda     #$01
                sta     <VIA_port_b     ;Disable RAMP, disable mux
                cmpx    chartabend ;     Check for last row
                beq     LF50A           ;branch if last row
                leax    $1C,x           ;Point to next chargen row
                tfr     u,d             ;Get string length
                subd    Vec_Str_Ptr
                subb    #$02            ; -  2
                aslb                    ; *  2
                andcc #$FF				;Delay a moment 
                brn     LF4EB           
LF4EB:          lda     #$81
                nop
                decb
                bne     LF4EB           ;Delay some more in a loop
                sta     <VIA_port_b     ;Enable RAMP, disable mux
                
                                ;;;;;;;;;;;;; FLD Y
                ldb     font_sinidx2 ;Get text height
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
   ;      lda Vec_Text_Height
                ;;;;;;;;;;;;; End Wobble Y
    ;            ldb     Vec_Text_Height ;Get text height
                sta     <VIA_port_a     ;Store text height in D/A
                dec     <VIA_port_b     ;Enable mux
                ldd     #$8101
                nop                     ;Wait a moment
                sta     <VIA_port_b     ;Enable RAMP, disable mux
                clr     <VIA_port_a     ;Clear D/A
                stb     <VIA_port_b     ;Disable RAMP, disable mux
                sta     <VIA_port_b     ;Enable RAMP, disable mux
                ldb     #$03            ;$0x = disable RAMP?
                bra     LF4A5           ;Go back for next scan line

LF50A:          lda     #$98
                sta     <VIA_aux_cntl   ;T1->PB7 enabled
                jmp     Reset0Ref       ;Reset the zero reference


;-----------------------------------------------------------------------;
;       F46E    Draw_VL_mode                                            ;
;                                                                       ;
; This routine processes the vector list pointed to by the X register.  ;
; The current scale factor is used.  The vector list has the following  ;
; format:                                                               ;
;                                                                       ;
;       mode, rel y, rel x,                                             ;
;       mode, rel y, rel x,                                             ;
;        .      .      .                                                ;
;        .      .      .                                                ;
;       mode, rel y, rel x,                                             ;
;       0x01                                                            ;
;                                                                       ;
; where mode has the following meaning:                                 ;
;                                                                       ;
;       < 0  use the pattern in $C829                                   ;
;       = 0  move to specified endpoint                                 ;
;       = 1  end of list, so return                                     ;
;       > 1  draw to specified endpoint                                 ;
;                                                                       ;
; ENTRY DP = $D0                                                        ;
;       X-reg points to the vector list                                 ;
;       $C829 contains the line pattern.                                ;
;                                                                       ;
; EXIT: X-reg points to next byte after terminator                      ;
;                                                                       ;
;       D-reg trashed                                                   ;
;-----------------------------------------------------------------------;

Draw_VL_Mode_p:   lda     Vec_0Ref_Enable ;Save old Check0Ref flag
                pshs    a
                clr     Vec_0Ref_Enable ;Don't reset the zero reference yet
LF476:          lda     ,x+             ;Get the next mode byte
                bpl     LF47E
                lda		,x+				; update scale
                sta		VIA_t1_cnt_lo
                jsr     Draw_Pat_VL     ;If <0, draw a patterned line
                bra     LF476

LF47E:          bne     LF485
                lda		,x+				; update scale
                sta		VIA_t1_cnt_lo
                jsr     Mov_Draw_VL     ;If =0, move to the next point
                bra     LF476

LF485:          deca
                beq     LF48D
                deca
                beq		newIntensity
                lda		,x+				; update scale
                sta		VIA_t1_cnt_lo
                jsr     Draw_VL         ;If <>1, draw a solid line
                bra     LF476
newIntensity:   lda		,x+
                jsr		intensitytoA
                bra     LF476


LF48D:          puls    a               ;If =1, exit
                sta     Vec_0Ref_Enable ;Restore old Check0Ref flag
                jmp     Check0Ref       ;Reset zero reference if necessary

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; draw curve along y axis     ;
; A: velocity Y               ;
; B: number of values to write;
; U: ptr to array of values   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
CurveX:			pshs b
				ldb #$81				; disable RAMP, disable mux
				stb <VIA_port_b
				sta     <VIA_port_a     ;set Y velocity
				clra
                sta     <VIA_aux_cntl   ;disable shift, disable latch
    			lda #$EE				; disable blank
				sta <VIA_cntl        
				ldb #$81				;disable ramp, disable mux
LF4A52:         stb     <VIA_port_b     ;Update RAMP, set mux to channel 1
                dec     <VIA_port_b     ;Enable mux
                ldd     #$8081
                nop                     ;Wait a moment
                inc     <VIA_port_b     ;Disable mux
                stb     <VIA_port_b     ;Enable RAMP, set mux to channel 0
                sta     <VIA_port_b     ;Enable mux
                tst     $C800           ;I think this is a delay only
                inc     <VIA_port_b     ;Enable RAMP, disable mux
                lda ,u+					; prefetch first value
                sta     <VIA_port_a     ;Send it to the D/A
                lda     #$01
				puls b
                sta     <VIA_port_b     ;Enable RAMP, disable mux
LF4C72:			lda     ,u+             ;Get next x-velocity
				sta <VIA_port_a			;convert
				decb					;loopcounter
                bne     LF4C72           ;Go back if not terminator
                lda     #$81
                sta     <VIA_port_b     ;Disable RAMP, disable mux
                lda     #$98
                sta     <VIA_aux_cntl   ;T1->PB7 enabled
                rts
                

				
TILTFIX1 equ -8
TILTFIX2 equ  8			
TEXTHEIGHT equ -5
pixelgfxbidi:   stu     Vec_Str_Ptr     ;Save string pointer
                ldx     chartabaddr ;Point to start of chargen bitmaps
                ldd     #$1883          ;$8x = enable RAMP?
                clr     <VIA_port_a     ;Clear D/A output
                sta     <VIA_aux_cntl   ;Shift reg mode = 110, T1 PB7 enabled
                ldx     chartabaddr ;Point to start of chargen bitmaps
LF4A5b:          stb     <VIA_port_b     ;Update RAMP, set mux to channel 1
                dec     <VIA_port_b     ;Enable mux
                ldd     #$8081
                nop                     ;Wait a moment
                inc     <VIA_port_b     ;Disable mux
                stb     <VIA_port_b     ;Enable RAMP, set mux to channel 0
                sta     <VIA_port_b     ;Enable mux
                tst     $C800           ;I think this is a delay only
                inc     <VIA_port_b     ;Enable RAMP, disable mux
                lda     Vec_Text_Width  ;Get text width
                sta     <VIA_port_a     ;Send it to the D/A
                ldd     #$0100
                sta     <VIA_port_b     ;Enable RAMP, disable mux
				nop
				nop
                bra     LF4CBb

LF4C7b:          lda     a,x             ;Get bitmap from chargen table
                sta     <VIA_shift_reg  ;This loop needs to have exactly 18 cycles (8*2+2)
LF4CBb:          lda     ,u+             ;Get next character
                bpl     LF4C7b           ;Go back if not terminator
                clra
                sta <VIA_shift_reg
                lda     #$80
                sta     <VIA_port_b     ;Disable RAMP, disable mux
				lda #TEXTHEIGHT
				sta <VIA_port_a
;				lda Vec_Text_Width
;				suba #TILTFIX1
				inc <VIA_port_b
 clra
                sta     <VIA_port_a     ;negate text width to D/A
				neg     Vec_Text_Width
                lda     #$01
                sta     <VIA_port_b     ;Disable RAMP, disable mux
                cmpx    chartabend ;     Check for last row
                beq     LF50Ab          ;branch if last row
                leax    $1C,x           ;Point to next chargen row
				lda     #$80
                sta     <VIA_port_b     ;Enable RAMP, disable mux
                clr     <VIA_port_a     ;Clear D/A
                ldb     #$03            ;$0x = disable RAMP?
				leau -1,u				; one char backward so char points to terminator of string
;;;;;;;;;;;;;;;;;;;;				
; inverse scanline ;
;;;;;;;;;;;;;;;;;;;;			
LF4A5c:          stb     <VIA_port_b     ;Update RAMP, set mux to channel 1
                dec     <VIA_port_b     ;Enable mux
                ldd     #$8081
                nop                     ;Wait a moment
                inc     <VIA_port_b     ;Disable mux
                stb     <VIA_port_b     ;Enable RAMP, set mux to channel 0
                sta     <VIA_port_b     ;Enable mux
                tst     $C800           ;I think this is a delay only
                inc     <VIA_port_b     ;Enable RAMP, disable mux
                lda     Vec_Text_Width  ;Get text width
                sta     <VIA_port_a     ;Send it to the D/A
                ldd     #$0100
                sta     <VIA_port_b     ;Enable RAMP, disable mux
				nop
				nop
                bra     LF4CBc
				
LF50Ab:			lda     #$98			; EXIT routine
                sta     <VIA_aux_cntl   ;T1->PB7 enabled
                jmp     Reset0Ref       ;Reset the zero reference				
				
LF4C7c:          lda     a,x             ;Get bitmap from chargen table
                sta     <VIA_shift_reg  ;This loop needs to have exactly 18 cycles (8*2+2)
LF4CBc:          lda     ,-u             ;Get next character
                bpl     LF4C7c           ;Go back if not terminator
                clra
                sta <VIA_shift_reg
                lda     #$80
                sta     <VIA_port_b     ;Disable RAMP, disable mux
				lda #TEXTHEIGHT
				sta <VIA_port_a
;				lda Vec_Text_Width
;				suba #TILTFIX2
 clra
				inc <VIA_port_b
                sta     <VIA_port_a     ;negate text width to D/A
				neg     Vec_Text_Width
                lda     #$01
                sta     <VIA_port_b     ;Disable RAMP, disable mux
                cmpx    chartabend ;     Check for last row
                beq     LF50Ab          ;branch if last row
                leax    $1C,x           ;Point to next chargen row
				lda     #$80
                sta     <VIA_port_b     ;Enable RAMP, disable mux
 				clr     <VIA_port_a     ;Clear D/A
                ldb     #$03            ;$0x = disable RAMP?
				leau    1,u				; one char forward so pointer points to first char again
                jmp     LF4A5b           ;Go back for next scan line
				
				