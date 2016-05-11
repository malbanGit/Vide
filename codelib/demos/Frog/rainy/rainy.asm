;
; Rainy intro by Frog
; http://frog.enlight.ru
; frog@enlight.ru
;
; July 2015
;
			include "vectrex.i" ; vectrex rom routines


frame_top		equ	$C880	; db top Y edge of split frame (from center)
frame_bottom	equ	$C881   ; db bottom Y edge of split frame (from center)
counter_dash	equ	$C882	; db counter for dashed lines etc pseudo-random stuff
counter_g		equ	$C884	; dw global counter (never reset)

                        org     0

                        db      "g GCE 2015", $80 	; 'g' is copyright sign
                        dw      $F600            	; music from the rom (no music)
                        db      $F8, $24, $30, $D6	; height, width, rel y, rel x
                        db      "RAINY BY FROG", $80	; app title, ending with $80
                        db      0                 	; end of header


                        ldd     #$f832
                        sta     Vec_Text_Height
                        stb     Vec_Text_Width

			ldu 	#0

			clr     counter_g
			clr     frame_top
			clr     frame_bottom

; LOOP START ------------------------------------

loop:
                        jsr     Wait_Recal        ;Reset/recalibrate system


                        lda     #$ff              ; scale factor ($7f default? $ff - max)
                        sta     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

			lda     #$CE 		  ; /Blank low, /ZERO high
			sta     <VIA_cntl         ; enable beam, disable zeroing

			lda     #$7f          	  ; color of rain (0-7f)
			jsr     Set_Intensity

; FRAME EDGE LINES ---------------------------

                        lda     frame_top         ; Y
                        ldb     #-64              ; X
                        jsr     Moveto_d

                        lda     #0                ; Y
                        ldb     #127              ; X
                        jsr     Draw_Line_d

                        lda     frame_bottom      ; Y
                        ldb     #0                ; X
                        jsr     Moveto_d

                        lda     #0                ; Y
                        ldb     #-127             ; X
                        jsr     Draw_Line_d

; RAIN PLANES --------------------------------------

                        lda     frame_top
                        cmpa    #64
                        bne     skipall

                        lda     #$15              ; color of rain (0-7f)
                        jsr     Set_Intensity

                        ldx     #rain_x_table1
                        jsr     Rain_Plane


                        ldu     counter_g
                        cmpu    #90
                        bge     skip2

                        lda     #$20           	; color of rain (0-7f)
                        jsr     Set_Intensity

                        ldx     #rain_x_table2
                        jsr     Rain_Plane
skip2:

                        ldu     counter_g
                        cmpu    #100
                        ble     skip3

                        lda     #$30            ; color of rain (0-7f)
                        jsr     Set_Intensity

                        ldx     #rain_x_table3
                        jsr     Rain_Plane
skip3:

skipall:

; PRINT TEXT --------------------

                        jsr     Center_Beam

                        lda     #$7f
                        jsr     Set_Intensity

                        ldu     #test_str
                        lda     #10		; Y
                        ldb     #-20             ; X
                        jsr     Print_Str_d

                        lda     frame_top

                        cmpa    #64
                        beq     skip_expand

; expanding frame
                        inc     frame_top
                        dec     frame_bottom
                        dec     frame_bottom
skip_expand:

                        inc     counter_g
                        leau    1,u
                        bra     loop

test_str:
                        db      "RAINY"
                        db      $80

; ======================
; X - address of table
Rain_Plane:
nextline:
                        jsr     Center_Beam

                        lda   	frame_top               ; Y
                        deca				; frame gap compensation 63
                        ldb     ,x+
                        cmpb    #0
                        beq     plane_done
                        adcb    counter_dash
                        eorb    ,x
                        jsr     Moveto_d_2

                        lda   	frame_bottom            ; Y -124
                        adda	#3			; frame gap compensation -127
                        ldb     ,x+

                        jsr     Draw_Line_d_2

                        lda     ,x
                        lsra
                        lsra
                        sta     Vec_Dot_Dwell
                        jsr     Dot_here

                        bra     nextline
plane_done:
			rts

rain_x_table1:
                        db      -51,-70, -35,-61, -23,-53, -10,-45, +5,-40, +25,-40, +43,-35, +60,-40, +70,-35, +90,-40, 0,0
rain_x_table2:
                        db      -53,-60, -37,-51, -27,-43, -11,-35, +8,-30, +29,-30, +45,-25, +65,-32, +71,-25, +93,-30, 0,0
rain_x_table3:
                        db      -60,-53, -48,-48, -35,-40, -21,-31, -4,-28, +15,-26, +33,-21, +51,-29, +57,-21, +81,-23, 0,0

; A - y coord, B - x coord
Draw_Line_d_2:
                        sta     <VIA_port_a     ;Send Y to A/D
                        clr     <VIA_port_b     ;Enable mux

                        nop                     ;Wait a moment
                        inc     <VIA_port_b     ;Disable mux
                        stb     <VIA_port_a     ;Send X to A/D

                        ldb     #$40          	;B-reg = T1 interrupt bit

                        lda     #$aa
                        sta     <VIA_shift_reg  ;Put pattern in shift register

                        eora    counter_dash

                        clr     <VIA_t1_cnt_hi

wait_timer:

                        sta     <VIA_shift_reg  ;Put pattern in shift register
                        inc     counter_dash
                        bitb    <VIA_int_flags  ;Wait for T1 to time out
                        beq     wait_timer

                        ldd     #$00CE
                        stb     <VIA_cntl       ;/BLANK low and /ZERO low
                        sta     <VIA_shift_reg  ;clear shift register

                        rts

Moveto_d_2:
                        sta     <VIA_port_a     ;Send Y to A/D
                        clr     <VIA_port_b     ;Enable mux
                        nop                     ;Wait a moment
                        inc     <VIA_port_b     ;Disable mux
                        stb     <VIA_port_a     ;Send X to A/D
                        ldd     #$0000          ;Shift reg=$00 (empty line), T1H=0
                        sta     <VIA_shift_reg  ;Put pattern in shift register
                        stb     <VIA_t1_cnt_hi  ;Set T1H (scale factor?)
                        ldd     #$0040          ;B-reg = T1 interrupt bit
LF3F4b:                 bitb    <VIA_int_flags  ;Wait for T1 to time out
                        beq     LF3F4b
                        nop                     ;Wait a moment more
                        rts

Center_Beam:
                        lda     #$CC		;/BLANK low and /ZERO low
                        sta     <VIA_cntl       ; enable beam, enable zeroing

                        ldd     #$0302
                        clr     <VIA_port_a     ;clear D/A register
                        sta     <VIA_port_b     ;mux=1, disable mux
                        stb     <VIA_port_b     ;mux=1, enable mux
                        stb     <VIA_port_b     ;do it again
                        ldb     #$01
                        stb     <VIA_port_b     ;disable mux

                        lda     #$CE 		;/Blank low, /ZERO high
                        sta     <VIA_cntl       ; enable beam, disable zeroing

                        rts

Set_Intensity:				        ; Intensity (0-7f)

                        sta     <VIA_port_a

                        lda     #$04            ; select channel Intensity, enable mux
                        sta     <VIA_port_b

                        lda     #$05
                        sta     <VIA_port_b     ; disable mux

                        rts
