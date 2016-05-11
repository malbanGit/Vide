; BIOS Routines

;ROM
        ORG     $0000

; Init block that needs to be in every program
; the GCE text has to be in place, it is checked
; by BIOS

        FCB     $67,$20
        FCC     "GCE 2008"
        FCB     $80
        FDB     music

        FDB     $f850
        FDB     $30b8
        FCC     "VOZ 2008"
        FCB     $80
        FCB		$0
		jmp demo_start


music:
        FDB     $fee8
        FDB     $feb6
        FCB     $28,$08
        FCB     $0,$80


						include "VECTREX.INC"
						include "rom.asm"
						include "resrces.asm"
						include "gfxcode.asm"
						include "ram.asm"


; Here's the main program
demo_start:
		clra
		sta plr_pattern
		
loadmusic:
		lda   #1
		STA   Vec_Music_Flag          
		lda plr_pattern
		inc	plr_pattern
		cmpa #songLength
		bne plr_cnt
		lda #songLoop			;; load pattern to loop from
		sta plr_pattern
		inc plr_pattern
plr_cnt:
		ldx #script
		ldb #6
		mul
		ldy d,x
		sty plr_geilmusik
		addd #2
		ldy d,x
		sty plr_part
		addd #2
		ldd d,x
		cmpd plr_part_init
		beq mainloop
		std plr_part_init
		jsr [plr_part_init]
mainloop:	
		LDA   Vec_Music_Flag
		BEQ	  loadmusic		 
        JSR   DP_to_C8                ; DP to RAM
        LDU   plr_geilmusik                 ; get some music, here music1
        JSR   Init_Music_chk          ; and init new notes
        jsr waitrecal          ; Resets the BIOS
        JSR   Do_Sound			; do actual sound loading to AY
        jsr checkButtons
		LDA     #$7F
		sta VIA_t1_cnt_lo
		jsr Reset0Ref_D0
		jsr [plr_part]
;		jsr debugmode

		jmp mainloop

checkButtons:
        jsr  Read_Btns			; check buttons to skip parts
		lda  Vec_Buttons		
		beq checkButtons_done
		cmpa #$1				; restart
		bne checkButtons_2
		clra
		sta plr_pattern
		puls a
		puls a
		jmp loadmusic
checkButtons_2:
		cmpa #$2				; 1 ptrn forward
		bne checkButtons_3
		puls a
		puls a
		jmp loadmusic
checkButtons_3:
		cmpa #$4				; 1 ptrn backward
		bne checkButtons_done
		lda plr_pattern
		suba #$2
		bpl checkButtons_3_cont
		clra
checkButtons_3_cont:
		sta plr_pattern
		puls a
		puls a
		jmp loadmusic
checkButtons_done:
		rts
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BEGIN PARTS			   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		
		

		

				
init_part_opener:
		lda #vopenframecount ;load video
		ldx #vopenframetab
		jsr loadvid
		ldd #fldtab			; load FLD table
		std sintabaddr
		ldd #gfx_bresen		; load charset
		std chartabaddr
		ldd #gfx_bresen + $1A4 ; 
		std chartabend
		rts
part_opener:
		jmp playvid
part_opener_logo:
		jmp drawbresen
		
init_part_metalvotze:
		lda #$7E
		sta gfx_intensity
		ldd #consttab			; load FLD table
		std sintabaddr
		ldd #fnt_mv		; load charset
		std chartabaddr
		ldd #fnt_mv + $284 
		std chartabend		
		clra
		sta font_sinidx
		inca
		sta font_sinidx2
		lda #0
		sta gfx_di
		lda #196
		sta gfx_dxsubcnt
		rts
part_metalvotze:
		lda gfx_intensity
		adda gfx_di
		bne part_metalvotze2
		clrb
		stb gfx_di
part_metalvotze2:
		sta gfx_intensity		
		jsr intensitytoA
		lda font_sinidx
		inca
		anda #$3F
		sta font_sinidx
		dec gfx_dxsubcnt
		bne part7a2
		ldb gfx_intensity
		beq part7a2
		ldb #-2
		stb gfx_di
part7a2:		
		ldx #sintab
		lda a,x
		asra
		ldb #-100
		jsr Moveto_d_7F
		jmp drawvoz
		
init_part7b:		
		lda #-5
		sta Vec_Text_Height 
		lda #$25
		sta Vec_Text_Width	
		lda #$7F
		jsr intensitytoA
		rts
part7b:
		lda #30
		ldb #-100
		jsr Moveto_d_7F
		ldu #annc_elite
		jsr Print_Str_d
		lda #15
		ldb #-100
		jsr Moveto_d_7F
		ldu #annc_elite2		
		jsr Print_Str_d
		lda #0
		ldb #-97
		jsr Moveto_d_7F
		ldu #annc_elite3		
		jsr Print_Str_d
		lda #-15
		ldb #-100
		jsr Moveto_d_7F
		ldu #annc_elite4		
		jmp Print_Str_d
		
		
patternmask  fcb $FF,$FF,$FF,$FF,$FF,$FE,$FE,$FE,$FE,$EE,$EE,$EE,$EE,$EA,$EA,$EA,$AA,$AA,$AA,$A2,$A2,$A2,$22,$22,$22,$20,$20,$20,$20,$00,$00,$00
init_part5:
		lda #tunnelframecount
		ldx #tunnelframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		rts
part5:
		ldx #patternmask
		lda #32	
		suba logo_temp
		lda a,x
		ldx #logo_temp
		sta 1,x
		jsr playvid
		rts
titsfadedelay EQU 128
init_part_girl2:	
		lda #1
		sta gfx_di
		sta gfx_intensity
		nega
		sta gfx_dx
		lda #30
		sta gfx_xpos
		lda #$AA
		sta Vec_Pattern
		lda #titsfadedelay
		sta loader_delay
		rts
part_girl2:
		dec loader_delay
		bne part_girl2b
		lda #-1
		sta gfx_di	
part_girl2b:
		ldx #gfxgirl2frame0
        jmp drawgfx

init_part_eod:	
		lda #-4
		sta Vec_Text_Height
		lda #80
		sta Vec_Text_Width
		rts
part_eod:
		clra
		ldb #-120
		jsr Moveto_d_7F
		ldu #annc_eod
		jmp Print_Str_d
		
init_part3:	
		lda #1
		sta gfx_di
		sta gfx_intensity
		sta gfx_dx
		lda #-30
		sta gfx_xpos
		lda #$AA
		sta Vec_Pattern
		lda #titsfadedelay
		sta loader_delay
		rts
part3:
		dec loader_delay
		bne part3b
		lda #-1
		sta gfx_di
part3b:
		ldx #gfx_titsframe0
        jmp drawgfx

init_part4a:		
		lda #-5
		sta Vec_Text_Height 
		lda #$25
		sta Vec_Text_Width	
		rts
part4a:
		lda #30
		ldb #-100
		jsr Moveto_d_7F
		ldu #annc_glenz		
		jsr Print_Str_d
		lda #15
		ldb #-97
		jsr Moveto_d_7F
		ldu #annc_glenz2		
		jsr Print_Str_d
		lda #0
		ldb #-97
		jsr Moveto_d_7F
		ldu #annc_glenz3		
		jsr Print_Str_d
		lda #-15
		ldb #-100
		jsr Moveto_d_7F
		ldu #annc_glenz4		
		jsr Print_Str_d
		rts
CUBELEN EQU 204		
init_part4:		
		lda #vidcubeglframecount
		ldx #vidcubeglframetab
		jsr loadvid
		ldd #hiddentab
		std vid_transtab
		ldd #CUBELEN
		std loader_delay
		clra
		sta loader_int2
		sta loader_int3
		sta loader_delay2
		rts
part4:
		lda loader_delay2
		bne part4_out
		lda loader_int3
		cmpa #$7F
		beq *+3
		inca
		bra part4_go
part4_out:
		lda loader_int3
		beq *+3
		deca
part4_go:		
		sta loader_int3
		sta VIA_t1_cnt_lo
		jsr intensitytoA
		jsr playvid
		ldd loader_delay
		subd #1
		std loader_delay
		beq part4_next
		rts
part4_next:
		ldd #CUBELEN
		std loader_delay
		lda loader_int2
		inca
		cmpa #4
		bne part4_next2a
		ldb #1
		stb loader_delay2
part4_next2a:		
		cmpa #5
		bne part4_next2
		clra
part4_next2:
		sta loader_int2
		ldx #tabletab
		asla
		ldx a,x
		stx vid_transtab
		rts
		
tabletab fdb hiddentab
		 fdb unitytab		
		 fdb solidtab
		 fdb unitytab
		 fdb hiddentab		
		
init_part_tentacle:
		clra
		sta loader_delay
		lda #$7F
		jsr intensitytoA
		lda #tentacleframecount
		ldx #tentacleframetab
		jmp loadvid
part_tentacle:
		ldx #sintab
		lda loader_delay
		inca
		anda #$7F
		sta loader_delay
		ldb a,x
		adda #32
		asla
		anda #$7F
		lda a,x
		asra
		asrb
		jsr Moveto_d
		jmp playvid
		
TIMER_GREETS equ 64
init_greetings:		
		clra
		sta gfx_dx
		sta gfx_di
		sta gfx_xpos
		lda #TIMER_GREETS
		sta loader_delay
init_greetings_rld:		
		lda #greetsframecount
		sta vid_framecount
		ldx #greetsframetab
		stx vid_frametab
		rts
greetings:
        jsr Reset0Ref_D0
		lda loader_delay
		asla
		deca
		sta gfx_intensity
		ldx #vid_frametab
		ldx [,x]
		jsr drawgfx
        dec loader_delay
        bne greetings_done
        lda #TIMER_GREETS
        sta loader_delay
        dec vid_framecount
        beq init_greetings_rld
        ldd vid_frametab
        addd #2
        std vid_frametab
greetings_done:
        rts

		


	
init_part_loader:
		clra
		sta loader_delay
		lda #$7E
		sta loader_int1
		sta loader_int2
		sta loader_int3
		lda #16
		sta loader_delay2
		lda #3
		sta loader_chars
		ldy #prompt2
		ldx #loader_prompt
		deca
init_part_loader_copy:
		ldb ,y+
		stb ,x+
		deca 
		bpl init_part_loader_copy		
		lda #$80
		sta ,x+
		rts
part_loader:
		lda loader_int1
		jsr intensitytoA
		ldu #loadstring
		lda #-5
		sta Vec_Text_Height 
		lda #$25
		sta Vec_Text_Width	
		lda #$7f
		suba loader_int1
		ldb #-50
		jsr Print_Str_d     
		lda loader_delay
		cmpa #255
		beq part_loader_done
		inca
		sta loader_delay
		cmpa #128
		bhi part_loader_done
		cmpa #32
		bhi part_loader_mid
		ldu #loader_prompt
		lda #-16
		ldb #-50
		jsr Print_Str_d
		rts
part_loader_mid
		lda loader_int2
		jsr intensitytoA
		dec loader_delay2
		bne part_loader_mid2
		lda #4
		sta loader_delay2
		lda loader_chars
		ldx #prompt2
		ldb a,x
		blt part_loader_mid2
		ldy #loader_prompt
		stb a,y
		ldb #$80
		inca
		stb a,y
		inc loader_chars
part_loader_mid2:		
		ldu #loader_prompt
		lda #-16
		ldb #-50
		jsr Print_Str_d
		rts
		
part_loader_done:		
		lda loader_int2
		jsr intensitytoA
		ldu #loader_prompt
		lda #-16+$7f
		suba loader_int2
		ldb #-50
		jsr Print_Str_d
		lda loader_int3
		jsr intensitytoA
		ldu #prompt3
		lda #-32+$7f
		suba loader_int3
		ldb #-50
		jsr Print_Str_d
		lda loader_delay
		inca
		bne part_loader_fade_done
		lda loader_int1
		beq part_loader_fade2
		deca
		deca
		deca
		sta loader_int1
		jmp part_loader_fade_done
part_loader_fade2:
		lda loader_int2
		beq part_loader_fade3
		deca
		deca
		deca
		sta loader_int2
		jmp part_loader_fade_done
part_loader_fade3:
		lda loader_int3
		beq part_loader_fade_done0
		deca
		deca
		deca
		sta loader_int3
part_loader_fade_done0:		
		lda #-40
		jsr Moveto_d
		lda #$7F
		jsr intensitytoA
		ldx #attentionframe0
		clra
		clrb
		jsr draw_vl_mode
		jsr Reset0Ref
		ldu #warn
		lda #-45
		ldb #-72
		jsr Print_Str_d
part_loader_fade_done:

		rts



		
	

init_grid:
		clra
		sta font_sinidx
		lda #1
		sta loader_delay2
		lda #$7F
		jsr intensitytoA
		rts
part_grid:
		lda #17
		sta grid_cnt
		lda #-50
		ldb #-50
		jsr Moveto_d
		LDA     #$7F
		sta VIA_t1_cnt_lo
		dec loader_delay2
		bne part_grid_cont
		lda #1
		sta loader_delay2
		lda font_sinidx
		inca
		anda #$7F
		sta font_sinidx
		sta font_sinidx2
part_grid_cont:		
		lda font_sinidx
		sta font_sinidx2
		lda #-120
		pshu a
		jmp grid_nextline3
grid_nextline:
		lda font_sinidx2
		ldx #gridtab
		ldb a,x
		adda #8
		anda #$7F
		sta font_sinidx2
		addb #127
		lsrb
		lsrb
		lsrb
		lsrb
		clra
		jsr Moveto_d
grid_nextline3:
		pulu a 
		nega
		pshu a
		ldb #0
		jsr Draw_line_d

		dec grid_cnt
		bne grid_nextline
		pulu a
		lda #120
		pshu a
		lda #17
		sta grid_cnt
		ldb font_sinidx2
		addb #32
		andb #$7F
		stb font_sinidx2
grid_nextline2:
		pulu b 
		negb
		pshu b
		lda #0
		jsr Draw_line_d
		ldb font_sinidx2
		ldx #gridtab
		lda b,x
		addb #16
		andb #$7F
		stb font_sinidx2
		adda #127
		lsra
		lsra
		lsra
		lsra
		clrb
		nega
		jsr Moveto_d
		dec grid_cnt
		bne grid_nextline2
		pulu a
		rts		
		
init_elite:
		lda #eliteframecount
		ldx #eliteframetab
		jsr loadvid
		clra
		sta loader_int2
		sta loader_int3
		sta loader_delay2
		lda #100
		sta loader_chars
		rts
part_elite:
		lda loader_delay2
		bne part_elite_out
		lda loader_int3
		cmpa #$7F
		beq *+3
		inca
		bra part_elite_go
part_elite_out:
		lda loader_int3
		beq *+3
		deca
part_elite_go:		
		sta loader_int3
		sta VIA_t1_cnt_lo
		jsr intensitytoA
		lda plr_pattern
		cmpa #39
		blt part_elite_go2
		dec loader_chars
		bne part_elite_go2
		ldb #1
		stb loader_delay2
part_elite_go2:
		jsr playvid
		rts		
		
debugmode:
		LDA     #$20
		BITA    VIA_int_flags  ;Check timer t2 expired?
		BNE exitdebug
		LDA     #$40
		sta VIA_t1_cnt_lo
		jsr Reset0Ref_D0
		ldd #$0070
		jsr Moveto_d
		
		lda #$7f
		jsr intensitytoA
		lda VIA_t2_hi
		clrb
		stb Vec_Misc_Count
		jsr Draw_line_d
exitdebug	rts


drawbresen:
		lda #$7f
		jsr intensitytoA
		
		lda font_sinidx
		inca
		anda #$3F
		sta font_sinidx
		sta font_sinidx2
		ldx #sintab2
		lda a,x
		asra
		asra
		asra
		asra
		adda #40
		ldb #-125
		JSR     >Moveto_d_7F
		JSR	DP_to_D0		
		
		ldu #bresenlogo
		lda #$40
		sta Vec_Text_Width	
		jsr pixelgfx   

	     
		rts
		
drawvoz:
		ldu #metalvotzelogo
		lda #$40
		sta Vec_Text_Width	
		jsr pixelgfx

	     
		rts


               
 