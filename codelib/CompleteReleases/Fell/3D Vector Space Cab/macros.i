; Drawing Macros
; By Fell^DSS, Ludum Dare 38 \p/

; Draw a dot by pinging the shiftreg
FastDot_here macro
	lda #$ff
	sta <VIA_shift_reg
	clr <VIA_shift_reg		
	endm

; Draw a counted line list
; Expects: x=list address
FastDraw_VLc macro
	local next_coord
	local t1wait
	lda ,x+
next_coord:
	sta Vec_Misc_Count
	ldd ,x
	sta <VIA_port_a
	clr <VIA_port_b
	leax 2,x
	nop
	inc <VIA_port_b
	stb <VIA_port_a
	ldd #$FF00
	sta <VIA_shift_reg
	stb <VIA_t1_cnt_hi
	ldd #$0040
t1wait:	bitb <VIA_int_flags
	beq t1wait
	nop
	sta <VIA_shift_reg
	lda Vec_Misc_Count
	deca
	bpl next_coord
	endm
		
; Draw a line rapidly
; Expects:
;	(a,b) to be relative coords
; Trashes:
;	d
FastDraw_Line_d macro
	local fdld_wt1
	sta <VIA_port_a     	; Send Y to A/D
	clr <VIA_port_b     	; Enable mux
	nop 			; Wait a moment
	inc <VIA_port_b     	; Disable mux
	stb <VIA_port_a     	; Send X to A/D
	ldd #$FF00          	; Shift reg=$FF (solid line), T1H=0
	sta <VIA_shift_reg  	; Put pattern in shift register
	stb <VIA_t1_cnt_hi  	; Ping T1H
	ldd #$0040          	; B-reg = T1 interrupt bit
fdld_wt1:
	bitb <VIA_int_flags	; Wait for T1 to time out (aw what a shame, this wait is wasted...)
	beq fdld_wt1
	nop 			; Wait a moment more
	sta <VIA_shift_reg	; Clear shift register (blank output)
	endm
		
; WAIT! Pro tip: Don't wait, calculate :P
; Trashes b
Wait_T1 macro
	local fm_wait
	ldb #$40
fm_wait:
        bitb <VIA_int_flags  		; Wait for timer 1
	beq fm_wait
	endm

; Hurry to a relative coord. DOES NOT WAIT!
; Expects:
;	(a,b) = (y,x) coords
; Trashes:
;	a
FastMoveTo_d macro			; Fast MoveTo_d macro
	local fm_wait			; Mark fm_wait label as local
	sta <VIA_port_a			; Store Y in D/A register
	clr <VIA_port_b			; Enable mux
	lda #$CE			; Blank low, zero high
	sta <VIA_cntl
	clr <VIA_shift_reg		; Clear shift register
	inc <VIA_port_b			; Disable mux
	stb <VIA_port_a			; Store X in D/A register
	clr <VIA_t1_cnt_hi		; timer 1 count high
	endm

; Set intensity
; Trashes:
;	d
FastIntensity_a macro
	sta <VIA_port_a     		; Store intensity in D/A
	sta Vec_Brightness  		; Save intensity in $C827
	ldd #$0504        	  	; mux disabled channel 2
	sta <VIA_port_b
	stb <VIA_port_b			; mux enabled channel 2
	stb <VIA_port_b			; do it again just because
	ldb #$01
	stb <VIA_port_b			; turn off mux
	endm

; Get back to the origin sharpish
; Trashes:
;	d
FastZeroRef macro
	ldd #$00CC
	stb <VIA_cntl       		; /BLANK low and /ZERO low
	sta <VIA_shift_reg  		; clear shift register
	ldd #$0302
	clr <VIA_port_a   	  	; clear D/A register
	sta <VIA_port_b     		; mux=1, disable mux
	stb <VIA_port_b     		; mux=1, enable mux
	stb <VIA_port_b     		; do it again
	ldb #$01
	stb <VIA_port_b     		; disable mux
	endm
	