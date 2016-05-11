_DRAW_LINE_D     macro
                 local  LF3F4            ;defines 'LF3F4' as a local variable
                 sta     <VIA_port_a     ;Send Y to A/D
                 clr     <VIA_port_b     ;Enable mux
                 ; the followin two instructions might be optimized
                 ; but there is something about 18 cycles :-)
                 leax    2,x             ;Point to next coordinate pair
                 nop                     ;Wait a moment
                 inc     <VIA_port_b     ;Disable mux
                 stb     <VIA_port_a     ;Send X to A/D
                 ldd     #$FF00          ;Shift reg=$FF (solid line), T1H=0
                 sta     <VIA_shift_reg  ;Put pattern in shift register
                 stb     <VIA_t1_cnt_hi  ;Set T1H (scale factor?)
                 ldd     #$0040          ;B-reg = T1 interrupt bit
LF3F4:           bitb    <VIA_int_flags  ;Wait for T1 to time out
                 beq     LF3F4           ;
                 nop                     ;Wait a moment more
                 sta     <VIA_shift_reg  ;Clear shift register (blank output)
                 endm
draw_titles:
	lda		#80
	jsr		Intensity_a
	jsr 	Reset0Ref
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_v        ; vectors
    lda    #7      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw

	;original V 51085 cost 1426
	;both Vs 52437	cost 2778
	;larger scale with more vectors 51032 (scaled down) cost 1373 (saving 53 cycles?)
	;no V at all 49659 
	
	;larger v
	;jsr 	Reset0Ref	
    ;lda    #LOGOY-1
    ;ldb    #LOGOX-45
    ;jsr    Moveto_d_7F 
    ;ldx    #logo_v2        ; vectors
    ;lda    #9      ; number of vectors n-1
    ;ldb    #LOGOSCALE/2-1         ; Scaling
	;jsr    Mov_Draw_VL_ab         ; Draw
	
	jsr 	Reset0Ref		;drawing this single line is 51032-50439=539 cycles!!!
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_b1        ; vectors
    lda    #1      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw
	
	jsr 	Reset0Ref
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_b2        ; vectors
    lda    #1      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw

	
	jsr 	Reset0Ref
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_r1        ; vectors
    lda    #1      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw

	
	jsr 	Reset0Ref
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_d1        ; vectors
    lda    #1      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw

	
	jsr 	Reset0Ref
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_d        ; vectors
    lda    #4      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw

	
	jsr 	Reset0Ref
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_r        ; vectors
    lda    #9      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw

	
	
	jsr 	Reset0Ref
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_i        ; vectors
    lda    #12      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw
	
	jsr 	Reset0Ref
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_b        ; vectors
    lda    #7      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw
	
	jsr 	Reset0Ref
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_y        ; vectors
    lda    #10      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw
	
		jsr 	Reset0Ref
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_c1        ; vectors
    lda    #6      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw

		jsr 	Reset0Ref
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_c        ; vectors
    lda    #6      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw
	
		jsr 	Reset0Ref
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_e1        ; vectors
    lda    #4      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw
	
		jsr 	Reset0Ref
    lda    #LOGOY
    ldb    #LOGOX
    jsr    Moveto_d_7F 
    ldx    #logo_e        ; vectors
    lda    #6      ; number of vectors n-1
    ldb    #LOGOSCALE          ; Scaling
	jsr    Mov_Draw_VL_ab         ; Draw
	
	rts