;***************************************************************************
; DEFINE SECTION
;***************************************************************************
                    include  "gameConfig.i"
; load vectrex bios routine definitions
                    INCLUDE  "vectrex.i"                  ; vectrex function includes
                    INCLUDE  "macro.i"                  ; vectrex function includes

;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    include  "RAM.i"

;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    CODE     
                    ORG      0 
; the first few bytes are mandatory, otherwise the BIOS will not load
; the ROM file, and will start MineStorm instead
                    DB       "g GCE 2022", $80 ; 'g' is copyright sign
                    DW       music1                       ; music from the rom 
                    DB       $F8, $50, $20, -$80          ; hight, width, rel y, rel x (from 0,0) 
                    DB       "GAME_NAME", $80             ; some game information, ending with $80
                    DB       0                            ; end of game header 

;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off

                    ldd      #jmpBack1FromObjectHandling
                    std      OBJECTS_DONE_A 
					lda		 #$80
					sta      gameScale
					lda 	 #GLOBAL_ANIMATION_DELAY
					sta 	 animCountdown
					ldd      #0
					std      sfx_pointer_1
					std      sfx_pointer_2
					std      sfx_pointer_3
					sta 	 currentLevel
					sta 	 currentLevelFlags
					sta 	 analogSampleCount

 if USE_CALIBRATION = 1
                    sta      calibrationValue 
					jsr	     doCalibration
 endif

					sta ADVdirection
					lda #50
					sta loadTimer           
					jsr      initCurrentLevel
					;jsr initLevel_1


main: 
					jsr      doYMsound
					; todo 
					; jostick in relation to what is configured!
					lda     currentLevelFlags
					bita	#LEVEL_USES_ANALOG_INPUT
					beq     useDigital
					jsr 	GetJoy_Analog
					bra     joyDecisionDone
useDigital					
					jsr 	Joy_Digital
joyDecisionDone					
					
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 
					jsr		Read_Btns
					
					dec 	 animCountdown
					bpl		 animCountDownNotFinished
					lda 	 #GLOBAL_ANIMATION_DELAY
					sta 	 animCountdown
animCountDownNotFinished:					
					jsr 	Intensity_5F

 if USE_CALIBRATION = 1
					jsr	     calibrationZero
 endif
					ldx		 sceneListForLevel
					jsr 	 displayScenes;
					lda      gameScale
                    sta      <VIA_t1_cnt_lo 


                    lds      objectlist_used_head 
                    puls     d,pc                         ; (D = y,x) ; do all objects 


jmpBack1FromObjectHandling
                    lds      #Vec_Default_Stk             ; correct the stack to default address 
                    bra      main
initCurrentLevel:
					ldx		#allLevelList
					lda 	currentLevel
					lsla	
					ldx		a,x
					bne	    levelAvalaible
					clr 	currentLevel
					bra 	initCurrentLevel
levelAvalaible:
					jsr		,x
					jmp 	jmpBack1FromObjectHandling
; this is a TEST!
; do something more efficient for real!
;-> but it proves that analog is much more stable with sampling of data!
GetJoy_Analog
 jsr 	Joy_Analog
 
 ; following looks stupidly long and winded and cycle wasty.
 ; but keep in mind, the above Joy_Analog uses more than 2000 cycles!
 
 ; the following "median" stuff for all 4 directions, take about 300 cycles
 ; depending on how you use analog it is defenitively useful!
 ldx #analogSamples
 lda analogSampleCount
 lsla
 lsla
 leax a,x
 ldd Vec_Joy_1_X
 std ,x++
 ldd Vec_Joy_2_X
 std ,x

 ; 4 median Vec_Joy_1_X
 ldx #0
 lda analogSamples
 leax a,x
 lda analogSamples+4
 leax a,x
 lda analogSamples+8
 leax a,x
 lda analogSamples+12
 leax a,x 
 tfr x,d
 MY_LSR_D
 MY_LSR_D
 stb Vec_Joy_1_X

 ; 4 median Vec_Joy_1_Y
 ldx #0
 lda analogSamples+1
 leax a,x
 lda analogSamples+1+4
 leax a,x
 lda analogSamples+1+8
 leax a,x
 lda analogSamples+1+12
 leax a,x
 tfr x,d
 MY_LSR_D
 MY_LSR_D
 stb Vec_Joy_1_Y

 ; 4 median Vec_Joy_2_X
 ldx #0
 lda analogSamples+2
 leax a,x
 lda analogSamples+2+4
 leax a,x
 lda analogSamples+2+8
 leax a,x
 lda analogSamples+2+12
 leax a,x
 tfr x,d
 MY_LSR_D
 MY_LSR_D
 stb Vec_Joy_2_X

 ; 4 median Vec_Joy_2_Y
 ldx #0
 lda analogSamples+3
 leax a,x
 lda analogSamples+3+4
 leax a,x
 lda analogSamples+3+8
 leax a,x
 lda analogSamples+3+12
 leax a,x
 tfr x,d
 MY_LSR_D
 MY_LSR_D
 stb Vec_Joy_2_Y
 
 inc analogSampleCount
 lda analogSampleCount
 cmpa #4
 bne kjh
 clr analogSampleCount
kjh
 rts


;***************************************************************************
; DATA SECTION
;***************************************************************************
                    include  "object.asm"
                    include  "font_5.asm"
                    include  "font_standard.asm"
					
                    include  "ayfxPlayer_channel1.i"
                    include  "ayfxPlayer_channel2.i"
                    include  "ayfxPlayer_channel3.i"

; in a sprite max
; in b spriteID to check
checkObjectCount 
	pshs x
	sta -1,s		; put on stack - but dont push
	stb temp8bit
					; go thru all possible sprites!
                    ldx      objectlist_used_head         ; load head of the object list 
checkObjectCountNextObject: 
                    ldu      BEHAVIOUR,x                  ; load behaviour address 
                    lda      -1,u                         ; load sprite ID of the other sprite, check if we are interested 
                    cmpa     temp8bit                     ; interested in this one? 
                    bne      checkObjectDontCount 	      ; if not, branch 
					dec		 -1,s						  ; if zero (or below) check failed
					bne 	  checkObjectDontCount		  ; if not zero - than we are ok... and continue check
	puls x,pc
														  ; not check for BELOW zero!
checkObjectDontCount					
                    ldx      NEXT_OBJECT,x                ; initiate the next possible object to test 
                    cmpx     #OBJECT_LIST_COMPARE_ADDRESS ; is it the end of the list? 
                    bhi      checkObjectCountNextObject ; no, than branch to next check 
checkObjectCountNotFail
	lda #1 ; Z = 0
	puls x,pc
checkObjectCountFail




; input in D
; uses first free AFX channel
; destroys X
playSound:
	ldx sfx_pointer_1
	bne ps2
	std sfx_pointer_1
	rts
ps2:
	ldx sfx_pointer_2
	bne ps3
	std sfx_pointer_2
	rts
ps3:
	ldx sfx_pointer_3
	bne psNone
	std sfx_pointer_3
psNone:	
	rts

doYMsound ;#isfunction  
                    jSR      sfx_doframe_intern_3 
                    JSR      sfx_doframe_intern_2 
                    JSR      sfx_doframe_intern_1 
                    direct   $d0 
copySoundRegs 
; copy all shadows
                    lda      #13                          ; number of regs to copy (+1) 
                    ldx      #Vec_Music_Work              ; music players write here 
                    ldu      #Vec_Snd_Shadow              ; shadow of actual PSG 
next_reg_dsy: 
                    ldb      a, x 
                    cmpb     a, u 
                    beq      inc_reg_dsy 
; no put to psg
                    stb      a,u                          ; ensure shadow has copy 
; a = register
; b = value
                    STA      <VIA_port_a                  ;store register select byte 
                    LDA      #$19                         ;sound BDIR on, BC1 on, mux off _ LATCH 
                    STA      <VIA_port_b 
                    LDA      #$01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
                    STA      <VIA_port_b 
                    LDA      <VIA_port_a                  ;read sound chip status (?) 
                    STB      <VIA_port_a                  ;store data byte 
                    LDB      #$11                         ;sound BDIR on, BC1 off, mux off - WRITE 
                    STB      <VIA_port_b 
                    LDB      #$01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
                    STB      <VIA_port_b 
inc_reg_dsy: 
                    deca     
                    bpl      next_reg_dsy 
doneSound_2: 
                    rts      


;                   include  "vectorlists.i"
;                   include  "smartlist.asm"

oneSceneDone:
					puls     x
displayScenes:
					ldy	     ,x++;
					beq	     allScenesDone
					pshs	 x

nextScenePart: 
                    lda      #OBJECT_SCALE
                    sta      VIA_t1_cnt_lo 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl 
                    
					LDU      ,y++ 
                    beq      oneSceneDone
 pshs y
                    bsr      drawMySmart 
 puls y
                    BRA      nextScenePart 
drawMySmart                                            ;#isfunction  
                    ldx      #(%11111110*256)+$98         ; 
                    ldy      #(%00001111*256)+$98         ; 
                    pulu     d,pc 
allScenesDone:
					rts

 if USE_CALIBRATION = 1
                    jsr      calibrationZero 
 
calibrationZero                                           ;#isfunction  
                    ldb      #$CC 
                    stb      <VIA_cntl 
                    ldd      #$8100 
                    std      <VIA_port_b 
                    dec      <VIA_port_b 
                    ldb      >calibrationValue 
                    lda      #$82 
                    std      <VIA_port_b 
                    ldd      #$83FF 
                    stb      <VIA_port_a 
                    sta      <VIA_port_b 
                    rts      
 
doCalibration
					jsr		 Read_Btns
                    JSR      Joy_Digital 
                    LDA      Vec_Joy_1_X 
                    BEQ      joyDone 
                    BMI      left_move 
right_move: 
                    inc      calibrationValue 
                    bra      joyDone 

left_move 
                    dec      calibrationValue 
joyDone 
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 
                    lda      Vec_Btn_State                ; load current button state 
					beq 	 noButtonPressedCalibrate
					rts
; trigger: button down 1
noButtonPressedCalibrate
                    jsr      Intensity_5F 

                    ldd      #$0130
                    std      #Vec_Text_HW
                    lda      gameScale
                    sta      VIA_t1_cnt_lo 

					ldu 	 #calibText1
					ldd      #(100*256)-60
					jsr      sync_Std_Print_Str_d

					ldu 	 #calibText2
					ldd      #(80*256)-90
					jsr      sync_Std_Print_Str_d

					ldu 	 #calibText3
					ldd      #(60*256)-80
					jsr      sync_Std_Print_Str_d

                    jsr      calibrationZero 
                    ldd      #$0000 
                    jsr      Moveto_d 
                    
                    lda      #OBJECT_SCALE 
                    sta      VIA_t1_cnt_lo 

					ldu      #_City1_
                    bsr      drawMySmart 

                    lda #$2f
                    jsr      Intensity_a
					ldy 	#_Net
_nextScenePart: 
                    lda      #OBJECT_SCALE
                    sta      VIA_t1_cnt_lo 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl 
                    
					LDU      ,y++ 
                    beq      _SceneDone
 pshs y
                    bsr      drawMySmart 
 puls y
                    BRA      _nextScenePart 
_SceneDone

                    BRA      doCalibration                         ; and repeat forever 
calibText1
 dB "USE LEFT OR RIGHT",$80 
calibText2
 dB "UNTIL THE SPRITES LOOK OK",$80 
calibText3
 dB "ANY BUTTON TO CONTINUE",$80 
 endif


_City1_

	db  $30,  $58, hi(SM_continue_move_multi6), lo(SM_continue_move_multi6)
	db -$60,  $00, hi(SM_startDraw_yd4_multi3), lo(SM_startDraw_yd4_multi3)
	db  $00, -$3E, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $60,  $00, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $48, -$30, hi(SM_continue_draw), lo(SM_continue_draw)
	db -$48, -$18, hi(SM_continue_draw_yd4), lo(SM_continue_draw_yd4)
	db -$60,  $00, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $00, -$3C, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $58,  $00, hi(SM_continue_draw_multi3), lo(SM_continue_draw_multi3)
	db  $60, -$30, hi(SM_continue_draw), lo(SM_continue_draw)
	db -$60, -$30, hi(SM_continue_draw_yd4), lo(SM_continue_draw_yd4)
	db -$58,  $00, hi(SM_continue_draw_multi3), lo(SM_continue_draw_multi3)
	db  $00, -$3C, hi(SM_continue_draw_multi4), lo(SM_continue_draw_multi4)
	db  $58,  $00, hi(SM_continue_draw_multi3), lo(SM_continue_draw_multi3)
	db  $60, -$30, hi(SM_continue_draw), lo(SM_continue_draw)
	db -$60, -$30, hi(SM_continue_draw_yd4), lo(SM_continue_draw_yd4)
	db -$58,  $00, hi(SM_continue_draw_multi3), lo(SM_continue_draw_multi3)
	db  $00, -$3C, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $60,  $00, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $48, -$18, hi(SM_continue_draw), lo(SM_continue_draw)
	db -$48, -$30, hi(SM_continue_draw_yd4), lo(SM_continue_draw_yd4)
	db -$60,  $00, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $00, -$3E, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $60,  $00, hi(SM_continue_draw_multi3), lo(SM_continue_draw_multi3)
	db  $48, -$30, hi(SM_continue_draw), lo(SM_continue_draw)
	db -$5A,  $00, hi(SM_continue_draw_yd4_multi4), lo(SM_continue_draw_yd4_multi4)
	db -$54,  $24, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $00,  $54, hi(SM_continue_draw_multi12), lo(SM_continue_draw_multi12)
	db  $54,  $24, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $5A,  $00, hi(SM_continue_draw_multi4), lo(SM_continue_draw_multi4)
	db -$48, -$30, hi(SM_continue_draw_yd4), lo(SM_continue_draw_yd4)
	db -$4C, -$08, hi(SM_startMove_multi6), lo(SM_startMove_multi6)
	db -$48, -$18, hi(SM_startDraw), lo(SM_startDraw)
	db  $48, -$30, hi(SM_continue_draw), lo(SM_continue_draw)
	db -$3C, -$18, hi(SM_continue_draw_yd4_multi2), lo(SM_continue_draw_yd4_multi2)
	db  $3C, -$18, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db -$30, -$18, hi(SM_continue_draw_yd4), lo(SM_continue_draw_yd4)
	db  $30, -$30, hi(SM_continue_draw), lo(SM_continue_draw)
	db -$54, -$0C, hi(SM_continue_draw_yd4_multi2), lo(SM_continue_draw_yd4_multi2)
	db  $54, -$24, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db -$30, -$18, hi(SM_continue_draw_yd4), lo(SM_continue_draw_yd4)
	db  $30, -$18, hi(SM_continue_draw), lo(SM_continue_draw)
	db -$3C, -$30, hi(SM_continue_draw_yd4_multi2), lo(SM_continue_draw_yd4_multi2)
	db  $3C, -$30, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db $00, -$18, hi(SM_continue_draw_yd4_newY_eq_oldX), lo(SM_continue_draw_yd4_newY_eq_oldX) ; y is -$30
	db  $30, -$18, hi(SM_continue_draw), lo(SM_continue_draw)
	db -$54, -$24, hi(SM_continue_draw_yd4_multi2), lo(SM_continue_draw_yd4_multi2)
	db  $54, -$0C, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db $00, -$30, hi(SM_continue_draw_yd4_yEqx), lo(SM_continue_draw_yd4_yEqx); y is -$30
	db  $30, -$18, hi(SM_continue_draw), lo(SM_continue_draw)
	db -$3C, -$18, hi(SM_continue_draw_yd4_multi2), lo(SM_continue_draw_yd4_multi2)
	db  $3C, -$18, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db -$48, -$30, hi(SM_continue_draw_yd4), lo(SM_continue_draw_yd4)
	db  $48, -$18, hi(SM_continue_draw), lo(SM_continue_draw)
	db  $56, -$16, hi(SM_startMove_multi2), lo(SM_startMove_multi2)
	db  $3A,  $38, hi(SM_startDraw_multi2), lo(SM_startDraw_multi2)
	db  $24,  $4C, hi(SM_startMove), lo(SM_startMove)
	db  $20,  $3C, hi(SM_startDraw_multi2), lo(SM_startDraw_multi2)
	db  $2C,  $64, hi(SM_startMove), lo(SM_startMove)
	db  $1C,  $50, hi(SM_startDraw), lo(SM_startDraw)
	db  $00,  $50, hi(SM_continue_draw), lo(SM_continue_draw)
	db -$14,  $50, hi(SM_continue_draw), lo(SM_continue_draw)
	db -$1C,  $60, hi(SM_startMove), lo(SM_startMove)
	db -$22,  $38, hi(SM_startDraw_multi2), lo(SM_startDraw_multi2)
	db -$40,  $4C, hi(SM_startMove), lo(SM_startMove)
	db -$30,  $36, hi(SM_startDraw_multi2), lo(SM_startDraw_multi2)
	db  $00, $00, hi(SM_lastDraw_rts), lo(SM_lastDraw_rts)

;
;Vectorlists for scene: Net
;
_Net:
 DW _Net_0 ; list of all single vectorlists in this
 DW _Net_1
 DW _Net_2
 DW _Net_3
 DW _Net_4
 DW 0

_Net_0
	db -$15,  $50, hi(SM_continue_move_multi3), lo(SM_continue_move_multi3)
	db -$30, -$58, hi(SM_startDraw_multi2), lo(SM_startDraw_multi2)
	db  $00, -$40, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $30, -$58, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $40,  $00, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $30,  $58, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $00,  $40, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db -$30,  $58, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db -$40,  $00, hi(SM_continue_draw_multi2), lo(SM_continue_draw_multi2)
	db  $00, $00, hi(SM_lastDraw_rts), lo(SM_lastDraw_rts)
_Net_1
	db  $60,  $35, hi(SM_continue_move_multi6), lo(SM_continue_move_multi6)
	db  $00, -$50, hi(SM_startDraw_multi8), lo(SM_startDraw_multi8)
	db -$4A, -$2A, hi(SM_continue_draw_multi6), lo(SM_continue_draw_multi6)
	db -$55,  $00, hi(SM_continue_draw_multi3), lo(SM_continue_draw_multi3)
	db -$4A,  $2A, hi(SM_continue_draw_multi6), lo(SM_continue_draw_multi6)
	db  $00,  $50, hi(SM_continue_draw_multi8), lo(SM_continue_draw_multi8)
	db  $4A,  $2A, hi(SM_continue_draw_multi6), lo(SM_continue_draw_multi6)
	db  $55,  $00, hi(SM_continue_draw_multi3), lo(SM_continue_draw_multi3)
	db  $4A, -$2A, hi(SM_continue_draw_multi6), lo(SM_continue_draw_multi6)
	db  $00, $00, hi(SM_lastDraw_rts), lo(SM_lastDraw_rts)
_Net_2
	db  $54,  $30, hi(SM_continue_move_multi12), lo(SM_continue_move_multi12)
	db -$64,  $36, hi(SM_startDraw_yd4_multi8), lo(SM_startDraw_yd4_multi8)
	db -$45,  $00, hi(SM_continue_draw_multi6), lo(SM_continue_draw_multi6)
	db -$64, -$36, hi(SM_continue_draw_multi8), lo(SM_continue_draw_multi8)
	db  $00, -$60, hi(SM_continue_draw_multi12), lo(SM_continue_draw_multi12)
	db  $64, -$36, hi(SM_continue_draw_multi8), lo(SM_continue_draw_multi8)
	db  $45,  $00, hi(SM_continue_draw_multi6), lo(SM_continue_draw_multi6)
	db  $64,  $36, hi(SM_continue_draw_multi8), lo(SM_continue_draw_multi8)
	db  $00,  $60, hi(SM_continue_draw_multi12), lo(SM_continue_draw_multi12)
	db  $00, $00, hi(SM_lastDraw_rts), lo(SM_lastDraw_rts)
_Net_3
	db -$12,  $5A, hi(SM_continue_move_multi16), lo(SM_continue_move_multi16)
	db  $60,  $00, hi(SM_startDraw_multi6), lo(SM_startDraw_multi6)
	db  $60, -$31, hi(SM_continue_draw_multi12), lo(SM_continue_draw_multi12)
	db  $00, -$46, hi(SM_continue_draw_multi16), lo(SM_continue_draw_multi16)
	db  $00, -$46, hi(SM_continue_draw_multi8), lo(SM_continue_draw_multi8)
	db -$60, -$31, hi(SM_continue_draw_multi12), lo(SM_continue_draw_multi12)
	db -$60,  $00, hi(SM_continue_draw_multi6), lo(SM_continue_draw_multi6)
	db -$60,  $31, hi(SM_continue_draw_multi12), lo(SM_continue_draw_multi12)
	db  $00,  $46, hi(SM_continue_draw_multi16), lo(SM_continue_draw_multi16)
	db  $00,  $46, hi(SM_continue_draw_multi8), lo(SM_continue_draw_multi8)
	db  $60,  $31, hi(SM_continue_draw_multi12), lo(SM_continue_draw_multi12)
	db  $00, $00, hi(SM_lastDraw_rts), lo(SM_lastDraw_rts)
_Net_4
	db -$12, -$5A, hi(SM_continue_move_multi16), lo(SM_continue_move_multi16)
	db  $12,  $64, hi(SM_startDraw_multi12), lo(SM_startDraw_multi12)
	db  $40,  $00, hi(SM_startMove_multi2), lo(SM_startMove_multi2)
	db  $12, -$64, hi(SM_startDraw_multi12), lo(SM_startDraw_multi12)
	db  $5E,  $17, hi(SM_startMove_multi16), lo(SM_startMove_multi16)
	db -$44,  $2A, hi(SM_startDraw_yd4_multi16), lo(SM_startDraw_yd4_multi16)
	db -$44,  $2A, hi(SM_continue_draw_yd4_multi8), lo(SM_continue_draw_yd4_multi8)
	db  $00,  $40, hi(SM_startMove_multi2), lo(SM_startMove_multi2)
	db  $63,  $3C, hi(SM_startDraw_multi16), lo(SM_startDraw_multi16)
	db -$5B,  $1A, hi(SM_startMove_yd4_multi16), lo(SM_startMove_yd4_multi16)
	db -$12, -$64, hi(SM_startDraw_multi12), lo(SM_startDraw_multi12)
	db -$40,  $00, hi(SM_startMove_multi2), lo(SM_startMove_multi2)
	db -$12,  $64, hi(SM_startDraw_multi12), lo(SM_startDraw_multi12)
	db -$5E, -$17, hi(SM_startMove_multi16), lo(SM_startMove_multi16)
	db  $44, -$2A, hi(SM_startDraw_multi16), lo(SM_startDraw_multi16)
	db  $44, -$2A, hi(SM_continue_draw_multi8), lo(SM_continue_draw_multi8)
	db  $00, -$40, hi(SM_startMove_multi2), lo(SM_startMove_multi2)
	db -$45, -$2A, hi(SM_startDraw_multi16), lo(SM_startDraw_multi16)
	db -$45, -$2A, hi(SM_continue_draw_multi8), lo(SM_continue_draw_multi8)
	db  $00, $00, hi(SM_lastDraw_rts), lo(SM_lastDraw_rts)


;LEVEL_INCLUDE_FILES