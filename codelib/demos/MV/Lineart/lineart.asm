; BIOS Routines

;ROM
        org     $0000

; Init block that needs to be in every program
; the GCE text has to be in place, it is checked
; by BIOS

        fcb     $67,$20
        fcc     "GCE 2011"
        fcb     $80
        fdb     music

        fdb     $f850
        fdb     $30b8
        fcc     "VOZ 2011"
        fcb     $80
        fcb		$0
		jmp demo_start


music:
        fdb     $fee8
        fdb     $feb6
        fcb     $28,$08
        fcb     $0,$80


; Here's the main program
demo_start:
		clra
		sta plr_pattern
		ldd #5
		std cartnum
flashstart:					;this label must be identical for all banks!!
		jmp loadmusic
		
						include "VECTREX.INC"
						include "rom.asm"
						include "resrces.asm"
						include "gfxcode.asm"
						include "muspl.asm"
						include "ram.asm"
						include "tables.asm"
						include "flash.asm"

loadmusic:
		lda   #1
		sta   Vec_Music_Flag          
		lda plr_pattern
		inc	plr_pattern
		cmpa #songLength
		bne plr_cnt
		lda #loopPosition			;; load pattern to loop from
		sta plr_pattern
		inc plr_pattern
plr_cnt:
		ldx #script
		ldb #4
		mul
		ldy d,x
		sty plr_geilmusik
		addd #2
		ldx d,x
		clra
		ldb 4,x					; load bank index of part
		addb #4
		cmpd cartnum
		beq plr_cnt2
		std cartnum
		dec plr_pattern			; flip one pattern back (as switching the rom jumps to loadmusic again)
		jmp switchROM
plr_cnt2: ldy ,x
		sty plr_part
		ldd 2,x
		cmpd plr_part_init
		beq mainloop
		std plr_part_init
		jsr [plr_part_init]
mainloop:	
		lda   Vec_Music_Flag
		beq	  loadmusic		 
        jsr   DP_to_C8                ; DP to RAM
        ldu   plr_geilmusik                 ; get some music, here music1
        jsr   Init_Music_chk          ; and init new notes
        jsr waitrecal          ; Resets the BIOS
        jsr   Do_Sound			; do actual sound loading to AY
        jsr checkButtons
		lda     #$7F
		sta VIA_t1_cnt_lo
		jsr Reset0Ref_D0
		jsr [plr_part]
		if DEBUG
		jsr debugmode
		endif
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
debugmode:
		lda     #$20
		bita    VIA_int_flags  ;Check timer t2 expired?
		bne exitdebug
		lda     #$40
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
;;;;;;;;;;;;;;;;;;;;;
; signed mul a x b  ;
;;;;;;;;;;;;;;;;;;;;;
smul:	tsta
		bpl smulap
		tstb
		bpl smulanbp
smulanbn:
		nega
		negb
		mul
		rts
smulanbp:
		nega
		mul
		nega
		eorb #$FF
		rts
smulap:
		tstb
		bpl smulapbp
smulapbn:
		negb
		mul
		nega
		eorb #$FF
		rts
smulapbp:
		mul
		rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BEGIN PARTS			   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

	if BANK=BANK_TWISTER
init_parttwister:
		ldx #curvetab
		stx vid_frametab
		clra
		sta gfx_dx
		sta gfx_di
		lda #40
		sta gfx_dxsubcnt
		rts
init_parttwister2:
		lda #255
		sta gfx_di
		sta gfx_count2
		rts
parttwister3:
		lda gfx_dxsubcnt
		beq parttwister4
		cmpa #64
		bne parttwister6
		lda #-1
		sta gfx_count2
		bra parttwister6
parttwister4
		lda #1
		sta gfx_count2
parttwister6		
		lda gfx_count2
		adda gfx_dxsubcnt
		sta gfx_dxsubcnt
parttwister:
		lda     #$7F
		sta VIA_t1_cnt_lo
		lda gfx_di
		beq parttwister2
		dec gfx_di
		inc gfx_dx
		ldx #curvetab
		lda gfx_dx
		lsra
		leax a,x
		stx vid_frametab
parttwister2:
		lda logo_curframe
		inca
		anda #127
		sta logo_curframe
CURVECNT equ 8
CURVEOFF equ 16
CURVELEN equ 32
		lda #CURVECNT
		sta gfx_xpos

nextline:
		ldu #sintab
		lda #CURVELEN
		sta logo_temp
		ldx vid_frametab
		ldy #logo_compressed
		lda gfx_xpos
		ldb #CURVEOFF
		mul
		tfr b,a
		adda logo_curframe
		anda #127
		leau a,u
calcline:
		lda ,x+
		ldb gfx_dxsubcnt
		ldb b,u
		bsr smul
		sta ,y+
		dec logo_temp
		bne calcline
		
		jsr Reset0Ref_D0
		
		ldb ,u				; load sinus from table

		pshs d
		lda 32,u
		adda #127
		lsra
		jsr intensitytoA
		puls d		

		ldu #logo_compressed
		asrb
		asrb
		lda #-127
		jsr Moveto_d
		lda #$50
		ldb #CURVELEN
		jsr CurveX
		dec gfx_xpos
		bne nextline
		
		
		rts
Char_Table equ $f9f4          
Char_Table_End equ $fbd4   

curvetab	
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 16
		fcb 32
		fcb 64
		fcb 32
		fcb 16
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb -16
		fcb -32
		fcb -63
		fcb -32
		fcb -16
curvetab2		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
		fcb 0
curve3
		fcb 0
		fcb 1
		fcb 2
		fcb 4
		fcb 8
		fcb 16
		fcb 32
		fcb 64
		fcb 64
		fcb 64
		fcb 32
		fcb 16
		fcb 8
		fcb 4
		fcb 2
		fcb 1
		fcb 0
		fcb -1
		fcb -2
		fcb -4
		fcb -8
		fcb -16
		fcb -32
		fcb -64
		fcb -64
		fcb -64
		fcb -32
		fcb -16
		fcb -8
		fcb -4
		fcb -2
		fcb -1
		fcb 0
		fcb 1
		fcb 2
		fcb 4
		fcb 8
		fcb 16
		fcb 32
		fcb 64
		fcb 64
		fcb 64
		fcb 32
		fcb 16
		fcb 8
		fcb 4
		fcb 2
		fcb 1
		fcb 0
		fcb -1
		fcb -2
		fcb -4
		fcb -8
		fcb -16
		fcb -32
		fcb -64
		fcb -64
		fcb -64
		fcb -32
		fcb -16
		fcb -8
		fcb -4
		fcb -2
		fcb -1
		fcb 0
		fcb 1
		fcb 2
		fcb 4
		fcb 8
		fcb 16
		fcb 32
		fcb 64
		fcb 127
		fcb 64
		fcb 32
		fcb 16
		fcb 8
		fcb 4
		fcb 2
		fcb 1
		fcb 0
		fcb -1
		fcb -2
		fcb -4
		fcb -8
		fcb -16
		fcb -32
		fcb -64
		fcb -127
		fcb -64
		fcb -32
		fcb -16
		fcb -8
		fcb -4
		fcb -2
		fcb -1
	else
	
ph_twisterlogo fcc "TWISTER" 
			fcb $80
parttwister:
parttwister3:
		lda #-30
		ldb #-60
		ldu #ph_twisterlogo
		jsr Print_Str_d
init_parttwister:
init_parttwister2:
		rts
	endif
	if BANK=BANK_MARCH
init_march:
		lda #marchtransframecount
		ldx #marchtransframetab
		jsr loadvid
		clra
		sta loader_delay
		lda #$7F
		jsr intensitytoA
		rts
part_march:
		
		lda vid_running
		bne part_marchshow
		lda loader_delay
		beq part_marchtrans
		deca
		beq part_marchloop
		deca
		beq part_marchloop
		deca
		beq part_marchloop
		deca
		beq part_marchloop
		deca
		beq part_marchend
		jsr drawframe
		rts
part_marchtrans:
		lda #marchbeginframecount
		ldx #marchbeginframetab
		bra part_marchnext		
part_marchloop:
		lda #marchloopframecount
		ldx #marchloopframetab
		bra part_marchnext
part_marchend:
		lda #marchendframecount
		ldx #marchendframetab
part_marchnext:
		jsr loadvid
		inc loader_delay
part_marchshow:
		jsr playvidonce
		rts
	else
ph_marchlogo fcc "MARCH" 
			fcb $80
part_march:
		lda #-30
		ldb #-60
		ldu #ph_marchlogo
		jsr Print_Str_d
init_march:		rts 
	endif
	if BANK=BANK_BOUNCE				
init_bnc:
		lda #bncintroframecount
		ldx #bncintroframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		lda #-1
		sta loader_delay
		lda #bncloopframetotal-1
		sta loader_int1
		lda #6
		sta gfx_xpos
		rts
part_bnc:
		lda gfx_xpos
		beq part_bncoutro
		lda loader_delay
		blt part_bncintro
		beq part_bncfwd
		jsr frameback
		bra part_bnccheck
part_bncintro:
		jsr framefwd
		lda vid_running
		bne part_bncshow
		lda #bncloopframecount
		ldx #bncloopframetab
		jsr loadvid
		clra
		sta loader_delay		
part_bncfwd:
		jsr framefwd
part_bnccheck:
		dec loader_int1
		bne part_bncshow
		lda loader_delay
		eora #1
		sta loader_delay
		lda #bncloopframetotal-1
		sta loader_int1
		dec gfx_xpos
		bne part_bncshow
		ldx #bncoutroframetab
		lda #bncoutroframecount
		jsr loadvid
		jmp part_bncoutro
part_bncshow:
		clra
		clrb
		jsr Moveto_d	
		jsr drawframe	
		rts
part_bncoutro:
		jsr playvidonce
		rts
	else
ph_bouncelogo fcc "BOUNCE" 
			fcb $80
part_bnc:
		lda #-30
		ldb #-60
		ldu #ph_bouncelogo
		jsr Print_Str_d
init_bnc:		rts 
	endif
									
titsfadedelay equ 160

	if BANK=BANK_NCELOGO
init_part_title:	
		lda #1
		sta gfx_di
		sta gfx_intensity
		clra
		sta gfx_dx
		lda #30
		sta gfx_xpos
		lda #$AA
		sta Vec_Pattern
		lda #titsfadedelay
		sta loader_delay
		rts
part_title:
		lda #$7F
		sta VIA_t1_cnt_lo
		dec loader_delay
		bne part_titleb
		lda #-1
		sta gfx_di	
part_titleb:
		ldx #ncelogoframe0
		lda #$7f
		sta VIA_t1_cnt_lo
        jmp drawgfx
	else
ph_titlelogo fcc "NUANCE" 
			fcb $80
part_title:
		lda #-30
		ldb #-60
		ldu #ph_titlelogo
		jsr Print_Str_d
init_part_title:		rts 
	endif
  
	if BANK=BANK_HAUPTDEMO
hauptdemofadedelay equ 220	
init_hauptdemologo:	
		lda #1
		sta gfx_di
		sta gfx_intensity
		nega
		sta gfx_dx
		lda #30
		sta gfx_xpos
		lda #$AA
		sta Vec_Pattern
		lda #hauptdemofadedelay
		sta loader_delay
		rts
parthauptdemologo:
		dec loader_delay
		bne part_hauptdemob
		lda #-1
		sta gfx_di	
part_hauptdemob:
		ldx #lineartframe0
        jmp drawgfx
	else
ph_hauptdemologo fcc "HAUPTDEMO" 
			fcb $80
parthauptdemologo:
		lda #-30
		ldb #-60
		ldu #ph_hauptdemologo
		jsr Print_Str_d
init_hauptdemologo:		rts  
	endif

	if BANK=BANK_DISCO
init_partdiscostulogo:
		lda #discoframecount
		ldx #discoframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		rts
partdiscostulogo:
		
		jsr playvid
		rts
	else
ph_discostulogo fcc "DISCOSTU" 
			fcb $80
partdiscostulogo:
		lda #-30
		ldb #-60
		ldu #ph_discostulogo
		jsr Print_Str_d
init_partdiscostulogo:		rts 	
	endif
	
	if BANK=BANK_TEAPOT
init_partteapotlogo:
		lda #teapotframecount
		ldx #teapotframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		rts
partteapotlogo:
		lda     #$5F
		sta VIA_t1_cnt_lo		
		jsr playvidonce
		rts
	else
ph_teapotlogo fcc "TEAPOT" 
			fcb $80
partteapotlogo:
		lda #-30
		ldb #-60
		ldu #ph_teapotlogo
		jsr Print_Str_d
init_partteapotlogo:		rts 
	endif
	if BANK=BANK_TEAPOTB
init_partteapotBlogo:
		lda #teapotBframecount
		ldx #teapotBframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		rts
partteapotBlogo:
		lda     #$5F
		sta VIA_t1_cnt_lo		
		jsr playvidonce
		rts
	else
ph_teapotBlogo fcc "TEAPOTB" 
			fcb $80
partteapotBlogo:
		lda #-30
		ldb #-60
		ldu #ph_teapotBlogo
		jsr Print_Str_d
init_partteapotBlogo:		rts 
	endif
	
	if BANK=BANK_EKG
init_partekglogo:
		lda #ekgframecount
		ldx #ekgframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		rts
partekglogo:
		jsr framefwd		; triple anim speed
		jsr framefwd		; 
		jsr playvid
		rts
	else
ph_ekglogo fcc "EKG" 
			fcb $80
partekglogo:
		lda #-30
		ldb #-60
		ldu #ph_ekglogo
		jsr Print_Str_d
init_partekglogo:		rts 
	endif
	
	
	if BANK=BANK_WELT
init_partweltkugellogo:
		lda #weltframecount
		ldx #weltframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		rts
partweltkugellogo:
		lda #$5F
		sta VIA_t1_cnt_lo
		jsr playvid
		rts
	else
ph_weltkugellogo fcc "WELT" 
			fcb $80
partweltkugellogo:
		lda #-30
		ldb #-60
		ldu #ph_weltkugellogo
init_partweltkugellogo:		jsr Print_Str_d
		rts 
	endif
	
	if BANK=BANK_BATTLE
init_partbattle:
		lda #battleframecount
		ldx #battleframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		rts
partbattle:
		jsr playvid
		rts
	else
ph_battle fcc "BATTLEZONE" 
			fcb $80
partbattle:
		lda #-30
		ldb #-60
		ldu #ph_battle
init_partbattle:		jsr Print_Str_d
		rts 
	endif
	
	if BANK=BANK_BRUCE
init_partbrucelogo:
		lda #bruceframecount
		ldx #bruceframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		rts
partbrucelogo:
		jsr playvidonce
		rts
	else
ph_brucelogo fcc "BRUCE" 
			fcb $80
partbrucelogo:
		lda #-30
		ldb #-60
		ldu #ph_brucelogo
init_partbrucelogo:		jsr Print_Str_d
		rts 
	endif
	if BANK=BANK_DUDEL
init_partdudel:
		lda #dudelframecount
		ldx #dudelframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		rts
partdudel:
		jsr playvid
		rts
	else
ph_dudel fcc "DUDELHAEDER" 
			fcb $80
partdudel:
		lda #-30
		ldb #-60
		ldu #ph_dudel
		jsr Print_Str_d
init_partdudel:		rts 
	endif
	if BANK=BANK_AUGE
init_partaugelogo:
		lda #augeframecount
		ldx #augeframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		rts
partaugelogo:
		jsr playvid
		rts
	else
ph_augelogo fcc "AUGE" 
			fcb $80
partaugelogo:
		lda #-30
		ldb #-60
		ldu #ph_augelogo
		jsr Print_Str_d
init_partaugelogo:		rts 
	endif
	
	if BANK=BANK_VOZLOGO	
init_partvozlogo:
		lda #vozlogoframecount
		ldx #vozlogoframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		rts
partvozlogo:
		jsr playvidonce
		rts
	else	
ph_vozlogo fcc "VOZLOGO" 
			fcb $80
partvozlogo:
		lda #-30
		ldb #-60
		ldu #ph_vozlogo
		jsr Print_Str_d
init_partvozlogo:		rts
	endif	
	
CHR_A equ 1
CHR_B equ 2
CHR_C equ 3
CHR_D equ 4
CHR_E equ 5 
CHR_F equ 6
CHR_G equ 7
CHR_H equ 8
CHR_I equ 9
CHR_J equ 10
CHR_K equ 11
CHR_L equ 12
CHR_M equ 13
CHR_N equ 14
CHR_O equ 15
CHR_P equ 16
CHR_Q equ 17
CHR_R equ 18
CHR_S equ 19
CHR_T equ 20
CHR_U equ 21
CHR_V equ 22
CHR_W equ 23
CHR_X equ 24
CHR_Y equ 25
CHR_Z equ 26
	if BANK=BANK_GREETINGS
text_speck		fcb -40,-15
				fcb CHR_S,CHR_P,CHR_E,CHR_C,CHR_K,CHR_D,CHR_R,CHR_U,CHR_M,CHR_M,$80
text_squoquo 	fcb -20,-2
				fcb CHR_S,CHR_Q,CHR_U,CHR_O,CHR_Q,CHR_U,CHR_U,$80
text_asd 		fcb -60,-1
				fcb CHR_A,CHR_S,CHR_D,$80
text_booze		fcb -10,-60
				fcb CHR_B,CHR_O,CHR_O,CHR_Z,CHR_E,$80
text_camelot	fcb -20,-5
				fcb CHR_C,CHR_A,CHR_M,CHR_E,CHR_L,CHR_O,CHR_T,$80
text_chrome		fcb -75,-72
				fcb CHR_C,CHR_H,CHR_R,CHR_O,CHR_M,CHR_E,$80
text_cosine		fcb -57,-1
				fcb CHR_C,CHR_O,CHR_S,CHR_I,CHR_N,CHR_E,$80
text_crest		fcb -34,-80
				fcb CHR_C,CHR_R,CHR_E,CHR_S,CHR_T,$80
text_dss		fcb -26,-30
				fcb CHR_D,CHR_S,CHR_S,$80
text_farbrausch	fcb -84,-1
				fcb CHR_F,CHR_A,CHR_R,CHR_B,CHR_R,CHR_A,CHR_U,CHR_S,CHR_C,CHR_H,$80
text_hitmen		fcb -17,-23
				fcb CHR_H,CHR_I,CHR_T,CHR_M,CHR_E,CHR_N,$80
text_oxyron		fcb -75,-32
				fcb CHR_O,CHR_X,CHR_Y,CHR_R,CHR_O,CHR_N,$80
text_trsi		fcb -60,-34
				fcb CHR_T,CHR_R,CHR_S,CHR_I,$80
text_viruz		fcb -32,-40
				fcb CHR_V,CHR_I,CHR_R,CHR_U,CHR_Z,$80
text_breakpoint	fcb -90,-1
				fcb CHR_B,CHR_R,CHR_E,CHR_A,CHR_K,CHR_P,CHR_O,CHR_I,CHR_N,CHR_T,$80
			
greettable 	fcw text_breakpoint
			fcw text_viruz
			fcw text_trsi
			fcw text_squoquo
			fcw text_speck
			fcw text_oxyron
			fcw text_hitmen
			fcw text_farbrausch
			fcw text_dss
			fcw text_crest
			fcw text_cosine
			fcw text_chrome
			fcw text_camelot
			fcw text_booze
			fcw text_asd
greetingscnt equ 14
greetingsspeed equ 2
greetingsparallel equ 2
init_partgreetingslogo:
		ldd #consttab			; load FLD table
		std sintabaddr
		lda #-127
		sta gfx_dx
		clra
		sta gfx_di
		lda #greetingscnt
		sta greet_nextindex
		ldx #greet_tbl_indices
		ldy #greet_tbl_timers
		lda #greetingsparallel
		clrb
		stb ,y
		stb ,x
init_partgreetingslogo2:
		ldb ,x
		incb
		leax 1,x
		stb ,x
		ldb ,y
		addb #86
		leay 1,y
		stb ,y
		deca
		bpl init_partgreetingslogo2
		rts
			  fcb $80 ; start delimiter for greetingslogo	
greetingslogo fcb 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,$80		
partgreetingslogo:
		lda #$7f
		jsr intensitytoA
		ldd #greetingsgfx		; load charset
		std chartabaddr
		ldd #greetingsgfx + $284
		std chartabend		
		lda #40
		ldb #-60
		jsr     >Moveto_d_7F
		jsr	DP_to_D0		
		
		ldu #greetingslogo
		lda #$40
		sta Vec_Text_Width	
		jsr pixelgfxbidi 

		; setup printing
		ldd #fontgfx		; load charset
		std chartabaddr
		ldd #fontgfx + fontsize
		std chartabend	
		lda #greetingsparallel
		sta greet_loopcounter
		
partgreetnextline:
		jsr Reset0Ref_D0
		lda greet_loopcounter
		ldx #greet_tbl_indices
		leax a,x
		ldy #greet_tbl_timers
		leay a,y
		
		lda #greetingsspeed
		adda ,y
		sta ,y
		cmpa #120
		ble partgreetingsprint
		lda #-127
		sta ,y
		lda greet_nextindex
		sta ,x
		dec greet_nextindex
		bpl partgreetingsprint
		lda #greetingscnt
		sta greet_nextindex
partgreetingsprint:
		ldu #greettable
		lda ,x
		asla
		ldu a,u
		lda ,u+
		ldb ,y
		asrb
		negb
		addb ,u+
		jsr Moveto_d
		lda ,y
		sta Vec_Text_Width
		adda #$7C
		bpl partgreetset
		nega
partgreetset jsr intensitytoA
		jsr pixelgfxbidi
		dec greet_loopcounter
		bpl partgreetnextline
		rts


		lda #greetingsspeed
		adda gfx_di
		sta gfx_di
		cmpa #120
		ble partgreetingsprint2
		lda #-127
		sta gfx_di
		dec gfx_intensity
		dec gfx_intensity
		bpl partgreetingsprint2
		lda #greetingscnt-1
		sta gfx_intensity
partgreetingsprint2:
		ldu #greettable
		lda gfx_intensity
		asla
		ldu a,u
		lda ,u+
		ldb gfx_di
		asrb
		negb
		addb ,u+
		jsr Moveto_d
		lda gfx_di
		sta Vec_Text_Width
		adda #$7C
		bpl partgreetset2
		nega
partgreetset2 jsr intensitytoA
		jsr pixelgfxbidi
		rts
	else
ph_greetingslogo fcc "GREETINGS" 
			fcb $80
init_partgreetingslogo:
		
		rts
partgreetingslogo:
		lda #-30
		ldb #-60
		ldu #ph_greetingslogo
		jsr Print_Str_d
		rts 
	endif

		if BANK=BANK_PRESENTS
init_partpresentslogo:		
		lda #presentsframecount
		ldx #presentsframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		rts
partpresentslogo:
		lda #$5F
		sta VIA_t1_cnt_lo
		jsr playvidonce
		rts
		else
ph_presentslogo fcc "PRESENTS" 
			fcb $80
init_partpresentslogo:
		
		rts
partpresentslogo:
		lda #-30
		ldb #-60
		ldu #ph_presentslogo
		jsr Print_Str_d
		rts 
		endif
		
		if BANK=BANK_CREDITS
		fcb $80
text_widdy fcb CHR_W,CHR_I,CHR_D,CHR_D,CHR_Y,$80
text_nitro fcb CHR_N,CHR_I,CHR_T,CHR_R,CHR_O,$80
text_raven fcb CHR_R,CHR_A,CHR_V,CHR_E,CHR_N,$80
text_faker fcb CHR_F,CHR_A,CHR_K,CHR_E,CHR_R,$80
text_wolf  fcb CHR_W,CHR_O,CHR_L,CHR_F,0,$80
init_partcreditslogo:
		ldd #consttab			; load FLD table
		std sintabaddr
		ldd #creditsgfx		; load charset
		std chartabaddr
		ldd #creditsgfx + $284
		std chartabend	
		lda #64
		sta gfx_dx
		clra
		sta gfx_di
		rts
		fcb $80
creditslogo fcb 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,$80		
partcreditslogo:
		lda #4				; display 5 credits
		sta gfx_xpos
		lda #$7f			; display logo at full brightness
		jsr intensitytoA
		ldd #creditsgfx		; load charset
		std chartabaddr
		ldd #creditsgfx + creditssize
		std chartabend		
		lda #70
		ldb #-100
		jsr     >Moveto_d_7F
		jsr	DP_to_D0		
		ldu #creditslogo
		lda #$40
		sta Vec_Text_Width	
		jsr pixelgfxbidi
		
		ldd #fontgfx		; load charset
		std chartabaddr
		ldd #fontgfx + fontsize
		std chartabend		
		dec gfx_di
		bpl partcredits_print
		lda #1					; downscale anim by 2
		sta gfx_di
		dec gfx_dx
		bne partcredits_print
		lda #127
		sta gfx_dx
partcredits_print:	
		jsr Reset0Ref_D0
		lda #26				; offset 26 sinus entries by name (127/5)
		ldb gfx_xpos
		mul
		addb gfx_dx
		andb #127
		ldu #sintab
		lda b,u
		addb #32			; shift by PI/4 -> cos
		andb #127
		ldb b,u
		pshs d				; save x/y values
		tfr b,a
		adda #127
		lsra
		jsr intensitytoA
		puls d
		asrb
		asrb
		asrb
		subb #30
		asra
		asra
		jsr     >Moveto_d
		ldu #text_widdy
		lda gfx_xpos
		ldb #6
		mul
		leau b,u
		jsr pixelgfxbidi
		dec gfx_xpos
		bpl partcredits_print
		rts
		else
ph_creditslogo fcc "CREDITS" 
			fcb $80
init_partcreditslogo:
		
		rts
partcreditslogo:
		lda #-30
		ldb #-60
		ldu #ph_creditslogo
		jsr Print_Str_d
		rts 
		endif
 
ph_voidlogo fcc "VOID" 
			fcb $80
init_part_void:		
		rts
part_void:
		lda #-30
		ldb #-60
		ldu #ph_voidlogo
		jsr Print_Str_d
		rts 

		if BANK=BANK_ROADRUNNER
	fcb $80
roadrunnerlogo fcb 0,1,2,3,4,5,6,7,$80
init_partrunner:		
		lda #$7F
		jsr intensitytoA
		ldd #consttab			; load FLD table
		std sintabaddr
		rts
partrunner:
		lda #$D0
		tfr a,dp
		lda #60
		ldb #-30
		jsr Moveto_d
		ldd #roadrunnergfx		; load charset
		std chartabaddr
		ldd #roadrunnergfx + roadrunnersize
		std chartabend		
		ldu #roadrunnerlogo
		lda #$30
		sta Vec_Text_Width	
		jsr pixelgfxbidi
		rts
		else
ph_runner fcc "ROADRUNNER" 
			fcb $80
init_partrunner:
		rts
partrunner:
		lda #-30
		ldb #-60
		ldu #ph_runner
		jsr Print_Str_d
		rts 
		endif

	if BANK=BANK_ROADRUNNER
init_partrunner2:	
		lda #$7f
		sta gfx_intensity
		clra
		sta gfx_dx
		sta gfx_di
		lda #30
		sta gfx_xpos
		lda #$7F
		jsr intensitytoA
		rts
partrunner2:
		ldx #thatsallframe0
        jmp drawgfx
	else
ph_runner2 fcc "ROADRUNNER2" 
			fcb $80
partrunner2:
		lda #-30
		ldb #-60
		ldu #ph_runner2
		jsr Print_Str_d
init_partrunner2:		rts  
	endif
		if TEMPLATE 
;;;;;;;;;;;;;;;;;;;
; template  still ;
;;;;;;;;;;;;;;;;;;;  
init_part_still:	
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
part_still:
		dec loader_delay
		bne part_stillb
		lda #-1
		sta gfx_di	
part_stillb:
		ldx #ncelogoframe0
        jmp drawgfx
		

;;;;;;;;;;;;;;;;;;;;;;
; vid template ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;
init_partvid:
		lda #marchtransframecount
		ldx #marchtransframetab
		jsr loadvid
		lda #$7F
		jsr intensitytoA
		rts
partvid:
		
		jsr playvid
		rts
		endif
               
 