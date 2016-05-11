; *** Veccy Bird
;To do
;Music and or AYFX?	 - low priority - integrate the YM code - maybe one day
;By Michael Simonds 2014
                    	include  "VECTREX.I"
;Macros
;next time use macros to save time!!!
; *** Needed variables
;does the assembler support DB DW etc? is so we could define these variables easier!? - might be lower case only
;note $c800 to $c80e are the ram location the bios shadows the sound chip registers and other things, so this must not be used for variables!
;this is why user ram must start at above $c880
t_width             equ      $c880                ;Size for tile width //not used? 
s_speed             equ      t_width+1            ;Speed of scroll //not used? 
cur_tile            equ      s_speed+1            ;Current Tile 
cur_offset          equ      cur_tile+1           ;distance between tiles 
scr_offset          equ      cur_offset+1         ;scroll offset, we scroll one tile amount then move the level array. 
level_shift         equ      scr_offset+1         ;shift the level position, so we can repeat a pattern 
b_pipe              equ      level_shift+1        ;bottom pipe from level array 
t_pipe              equ      b_pipe+1             ;top pipe from level array 
flap_on             equ      t_pipe+1             ;0 = not flapping, 1 = flapping animation //not used yet 
bird_x              equ      flap_on+1            ;bird x (probably always 0 so could of been a constant instead?) 
bird_y              equ      bird_x+1             ;bird y position 
bird_vel            equ      bird_y+1             ;velocity in the y of the bird 
bird_vel_count      equ      bird_vel+1           ;counter so we don't update velocity every frame 
flap_snd_count      equ      bird_vel_count+1     ;how long a sound is playing - might need more of these? 
point_snd_count     equ      flap_snd_count+1     ;how long a sound is playing - might need more of these? 
scr_byte1           equ      point_snd_count+1    ;score digits 3byte, 1byte per digit (unpacked BDC) 
scr_byte2           equ      scr_byte1+1          ;byte 1 is the lower digits 
scr_byte3           equ      scr_byte2+1          ;byte3 is now not used as we only go to 50 
scr_txt             equ      scr_byte3+1          ;4bytes for ascii version of score, 3 for text and 1 for terminator 
game_over_intensity  equ     scr_txt+4 
game_over_text_scale  equ    game_over_intensity+1 
dead_flag           equ      game_over_text_scale+1 ;use this as bool for things like override pipes intensity 1=dead 
bird_attract_move_counter  equ  dead_flag+1 
tap_intensity       equ      bird_attract_move_counter+1 
hiscr_byte1         equ      tap_intensity+1 
hiscr_byte2         equ      hiscr_byte1+1 
hiscr_byte3         equ      hiscr_byte2+1        ;byte3 is now not used as we only go to 50 
hiscr_txt           equ      hiscr_byte3+1        ;4 bytes for score, 1 is terminator of string 
wing_anim_counter   equ      hiscr_txt+4 
bird_rotation       equ      wing_anim_counter+1  ;rotation value of bird 
r_beak              equ      bird_rotation+1      ;storage for rotated bird vectors many bytes! 46 
r_eyeball           equ      r_beak+20 
r_bottom            equ      r_eyeball+4 
r_wing              equ      r_bottom+8 
r_wing_2            equ      r_wing+12 
r_wing_3            equ      r_wing_2+12 
r_eye               equ      r_wing_3+12 
r_top               equ      r_eye+14 
credit_roll_counter_a  equ   r_top+10             ;how long before we show the credits needs to inc and reset 
credit_length       equ      credit_roll_counter_a+1 
credit_intensity    equ      credit_length+1 
tmp_1               equ      credit_intensity+1   ;used for anything ? 
tmp_2               equ      tmp_1+1              ;used for anything 
; All this below is just for the particle system used on the win screen!
;emitter1
particle_1_xy       equ      tmp_2+1              ; SOME NUMBER OF BYTES FOR PARTICLE XY (stored as 16bit) 
particle_1_vel_xy   equ      particle_1_xy+64     ; SOME NUMBER OF BYTES FOR PARTICLE VELOCITY XY (stored as 16bit) 
emitter_1_intensity  equ     particle_1_vel_xy+64 ;1 byte intensity 
emitter_1_y         equ      emitter_1_intensity+1 ;2 bytes for subpixel 
emitter_1_x         equ      emitter_1_y+2        ;2 bytes for subpixel 
emitter_1_life      equ      emitter_1_x+2        ;1 byte 
;emitter2
particle_2_xy       equ      emitter_1_life+1     ; SOME NUMBER OF BYTES FOR PARTICLE XY (stored as 16bit) 
particle_2_vel_xy   equ      particle_2_xy+64     ; SOME NUMBER OF BYTES FOR PARTICLE VELOCITY XY (stored as 16bit) 
emitter_2_intensity  equ     particle_2_vel_xy+64 ;1 byte intensity 
emitter_2_y         equ      emitter_2_intensity+1 ;2 bytes for subpixel 
emitter_2_x         equ      emitter_2_y+2        ;2 bytes for subpixel 
emitter_2_life      equ      emitter_2_x+2        ;1 byte 
;emitter3
particle_3_xy       equ      emitter_2_life+1     ; SOME NUMBER OF BYTES FOR PARTICLE XY (stored as 16bit) 
particle_3_vel_xy   equ      particle_3_xy+64     ; SOME NUMBER OF BYTES FOR PARTICLE VELOCITY XY (stored as 16bit) 
emitter_3_intensity  equ     particle_3_vel_xy+64 ;1 byte intensity 
emitter_3_y         equ      emitter_3_intensity+1 ;2 bytes for subpixel 
emitter_3_x         equ      emitter_3_y+2        ;2 bytes for subpixel 
emitter_3_life      equ      emitter_3_x+2        ;1 byte 
emitter_1_on        equ      emitter_3_life+1     ;should be 1 why 4?? 
emitter_2_on        equ      emitter_1_on+1 
emitter_3_on        equ      emitter_2_on+1 
prev_part_yx        equ      emitter_3_on+1       ;2 bytes /temp previous 8bit particle xy pos in 1 word 
emitter_1_pcount    equ      prev_part_yx+2 
emitter_2_pcount    equ      emitter_1_pcount+1 
emitter_3_pcount    equ      emitter_2_pcount+1 
emitter_current_pcount  equ  emitter_3_pcount+1   ;copy of current pcount of the emitter being updated 
firework_counter    equ      emitter_current_pcount+1 ;1byte counter 
emitter_1_vel_y     equ      firework_counter+1 
emitter_1_vel_x     equ      emitter_1_vel_y+2 
emitter_2_vel_y     equ      emitter_1_vel_x+2 
emitter_2_vel_x     equ      emitter_2_vel_y+2 
emitter_3_vel_y     equ      emitter_2_vel_x+2 
emitter_3_vel_x     equ      emitter_3_vel_y+2 
rocket_1_on         equ      emitter_3_vel_x+2 
rocket_2_on         equ      rocket_1_on+1 
rocket_3_on         equ      rocket_2_on+1 
sound_flag_1        equ      rocket_3_on+1 
sound_flag_2        equ      sound_flag_1+1 
sound_flag_3        equ      sound_flag_2+1 
sound_explode_flag_1  equ    sound_flag_3+1 
sound_explode_flag_2  equ    sound_explode_flag_1+1 
sound_explode_flag_3  equ    sound_explode_flag_2+1 
;when I used 3x128bytes for particles I must of ran out of mem and got unexpected bytes set wrong
;for the emitter, note there are only 874 bytes of safe ram available to the user!!
;Constants in rom
BIRDVCOUNT          equ      8                    ; how often we update bird velocity to increase the acceleration downward 
LOGOX               equ      0                    ; position of logo 
LOGOY               equ      70                   ;add # before like #LOGOY when using to get 
LOGOSCALE           equ      66 
                    org      0 
; *** Init block
                    fcb      $67,$20 
                    	fcc     "GCE 2014"
                    fcb      $80 
                    fdb      musa 
                    fdb      $f850 
                    fdb      $30b8 
                    	fcc     "VECCY BIRD"
                    fcb      $80,$0 
; *** Start Code
;boot initialise, anything we need to do only when loading the game for the first time
boot_init: 
;setup highscores
                    clra     
                    sta      hiscr_byte1          ;ascii version of the high score 
                    sta      hiscr_byte2 
;	sta		hiscr_byte3		;originally the max score was 999, now its only 50, so no need for a 3rd digit 
                    lda      #$80 
                    sta      scr_txt+3            ;terminator 
                    lda      #32                  ;spaces ;reset ascii score 
                    sta      hiscr_txt 
                    sta      hiscr_txt+1 
                    lda      #48                  ;0s 
                    sta      hiscr_txt+2 
                    lda      #$80                 ;string terminator 
                    sta      hiscr_txt+3 
;copy highscore from memory if required
                                                  ;lda     $C83B ;is highscore valid? will be 0 if cold boot? 
                                                  ;cmpa    #0 
                                                  ;beq     no_score_copy 
                    lda      Vec_High_Score+5 
                    cmpa     #32 
                    bne      byte1_is_valid 
                    lda      #48                  ;if a space (32) change it to 48 which is 0 
byte1_is_valid: 
                    suba     #48 
                    sta      scr_byte1 
                    sta      hiscr_byte1 
                    lda      Vec_High_Score+4 
                    cmpa     #32 
                    bne      byte2_is_valid 
                    lda      #48                  ;if a space (32) change it to 48 which is 0 
byte2_is_valid: 
                    suba     #48                  ;bring value back to decimal 
                    sta      scr_byte2 
                    sta      hiscr_byte2 
                    jsr      update_hiscr 
no_score_copy: 
;initialise some variables call this after boot and when game ends
init: 
                    lda      #31 
                    sta      scr_offset 
                                                  ;//all   set to 0 
                    clra                          ;Set a to 0 (good habit to clr as its faster) 
                    sta      level_shift 
                    sta      flap_snd_count       ;set counter for sound length to 0 
                    sta      point_snd_count      ;count to play two sounds for the points 
                    sta      scr_byte1 
                    sta      scr_byte2 
;	sta		scr_byte3
                    sta      game_over_intensity 
                    sta      game_over_text_scale 
                    sta      dead_flag 
                    sta      bird_attract_move_counter 
                    sta      tap_intensity 
                    sta      wing_anim_counter 
                    sta      bird_rotation 
                    sta      emitter_1_on         ;0 
                    sta      emitter_2_on         ;0 
                    sta      emitter_3_on         ;0 
                    sta      rocket_1_on 
                    sta      rocket_2_on 
                    sta      rocket_3_on 
                    sta      sound_flag_1         ;as used for fireworks 
                    sta      sound_flag_2 
                    sta      sound_flag_3 
                    sta      sound_explode_flag_1 
                    sta      sound_explode_flag_2 
                    sta      sound_explode_flag_3 
                    lda      #16                  ;max of 16 
                    sta      emitter_1_pcount 
                    sta      emitter_2_pcount 
                    sta      emitter_3_pcount 
                    lda      #-6 
                    ldb      #-6 
                    std      emitter_1_y 
                    lda      #6 
                    ldb      #6 
                    std      emitter_2_y 
                    lda      #6 
                    ldb      #-6 
                    std      emitter_3_y 
;	jsr 	init_emitter_1 ;start emitter
;	jsr 	init_emitter_2 ;start emitter
;	jsr 	init_emitter_3 ;start emitter
                    lda      #127 
                    sta      credit_roll_counter_a 
;	lda		#4				;debug score forced to start at 40
;	sta		scr_byte2
;	debug level position add in to jump to a certain point
;	lda		#100
;	sta		level_shift
                    lda      #32                  ;spaces ;reset ascii score 
                    sta      scr_txt 
                    sta      scr_txt+1 
                    lda      #48                  ;0s 
                    sta      scr_txt+2 
                    lda      #$80                 ;string terminator 
                    sta      scr_txt+3 
                    jsr      Clear_Sound          ;turn off any sounds 
                    jsr      Read_Btns            ;get the state of buttons for comparison to when we do want to check them 
                    lda      #1 
                    sta      flap_on              ;set flapping anim state on 
                    lda      #-31 
                    sta      bird_x 
                    clra     
                    sta      bird_y               ;set bird position to middle of screen 
                    lda      #1 
                    sta      bird_vel             ;inital bird velocity 
                    lda      #BIRDVCOUNT 
                    sta      bird_vel_count       ;counter for which frame we update velocity down 
startscreen: 
;	jsr		win_screen ;debug winscreen
;	jsr		calib
                    jsr      Wait_Recal           ; BIOS recalibration 
                    jsr      bird_attract_mode    ;moves bird up and down 
                    jsr      draw_bird            ;56078-27731 = 28347 cycles 
                    jsr      draw_titles          ;56078-34377 = 21701 cycles total!?!! /without reset0ref =55405 (only saves 673) 
                                                  ;drawtitles  56078-38433 = same as normal but final draw vector jsr removed (so 17645 cycles drawing) 
                    jsr      draw_copyright       ;56078 cycles with this text, 48464 without (7600 cycles-ish) 
                    jsr      draw_tap             ;56078 cycles -48875 = 7204 cycles 
                    jsr      check_credit_roll    ;if timer then roll credits 
                    jsr      Read_Btns 
                    cmpa     #0 
                    beq      startscreen          ;no button pressed 
                                                  ;if      button pressed carry on--> 
game_loop: 
;	jsr		calib
                    jsr      Wait_Recal           ; BIOS recalibration 
                    jsr      scroll 
                    jsr      check_flapsound      ;check if sound has stopped playing or not 
                    jsr      drawlevel 
                    jsr      move_bird 
                    jsr      draw_bird 
                    jsr      check_score 
                    jsr      check_collision      ;must be done after check score because score gets current pipe ;comment to turn off collision 
                    lda      dead_flag 
                    cmpa     #1 
                    beq      goto_init 
                    jsr      print_score 
                    bra      game_loop 

goto_init: 
                    bra      init 

bird_dead_mode:                                   ;things  we do once in this mode 
;	jsr		calib
                    jsr      Wait_Recal           ; BIOS recalibration 
                    clra     
                    sta      flap_on              ;set flapping animation flag, so no flapping 
                    jsr      check_if_hiscore 
                    jsr      Clear_Sound 
                    jsr      play_deadsound 
bird_dead_mode_r:                                 ;things  we repeat 
;	jsr		calib	;we need to do this again because we loop back to this point
                    jsr      Wait_Recal           ; BIOS recalibration 
                    jsr      check_flapsound      ;this is now check general sound 
                    lda      #1 
                    sta      dead_flag 
                    jsr      drawlevel 
                    jsr      bird_dead_pos        ;make the bird fall to the ground 
                    jsr      draw_bird 
                    jsr      draw_game_over 
                    jsr      draw_dead_score_text 
                    jsr      draw_dead_hiscore_text 
                    jsr      draw_score_name 
                    lda      game_over_intensity 
                    cmpa     #100 
                    bge      bird_dead_mode_allow_buttons 
                    bra      bird_dead_mode_r     ;loop back as buttons not allowed yet 

bird_dead_mode_allow_buttons: 
                    jsr      Read_Btns 
                    cmpa     #0 
                    beq      bird_dead_mode_r 
                                                  ;bra     win_screen;tempDEBUUUUUG to get to win_screen 
                                                  ;bra     init ;reset to start screen ; does this fill up the stack??? 
                    rts      

;calib:				;waste of cycles!!!! so now inlined
                                                  ;        jsr Wait_Recal ; BIOS recalibration 
;	rts
                    	include	  "GETNAME.I"        ;get_score_name
check_if_hiscore:                                 ;{       
;	lda		scr_byte3		;byte1 is the lower digit
;	cmpa	hiscr_byte3		;check if the 100s are higher than current high score
;	bgt		update_hiscr	;if score is greater than
                    lda      scr_byte2            ;load 10s 
                    cmpa     hiscr_byte2          ;compare 
                    bgt      update_hiscr         ;if greater than update score 
                    beq      check_byte_1         ;if equal to check second byte 
                    rts                           ;otherwise return 

check_byte_1: 
                    lda      scr_byte1            ;load byte1 
                    cmpa     hiscr_byte1          ;compare 
                    bgt      update_hiscr         ;if greater than update score 
                    rts                           ;score was not higher 

update_hiscr:                                     ;copy    score to high score 
                    lda      scr_byte1 
                    sta      hiscr_byte1 
                    adda     #48 
                    sta      hiscr_txt+2 
                    sta      Vec_High_Score+5     ; highscore format is 7bytes"xxxxxx",$80 
                    lda      scr_byte2 
                    sta      hiscr_byte2 
                    adda     #48 
                    sta      hiscr_txt+1 
                    sta      Vec_High_Score+4     ;also copy to vectrex high score 
;	lda		scr_byte3
;	sta		hiscr_byte3
;	adda	#48
;	sta		hiscr_txt
                                                  ;strip   high score ;remove leading 00s before returning from updating the score 
;	lda		hiscr_txt
;	cmpa	#48
;	bne		update_hiscr_r
;	lda		#32
;	sta		hiscr_txt
                    lda      hiscr_txt+1          ;strip highscore 
                    cmpa     #48 
                    bne      update_hiscr_r 
                    lda      #32 
                    sta      hiscr_txt+1 
                    sta      Vec_High_Score+4     ;also copy space to vectrex score if required 
update_hiscr_r: 
                    rts      

;}
;{ Check if scored
check_score:                                      ;did     we pass through a pipe mid point if so score = +1 
                    ldb      #1                   ;check the pipe of the tile on screen (where the x of the bird is) 
                    addb     level_shift          ;the offset of the level 
                    ldx      #level 
                    lda      b,x 
                    cmpa     #0 
                    bne      tile_has_height      ;if not 0 then find out out 
                    bra      check_score_rt       ;return from check score because there is no pipe 

tile_has_height: 
                    lda      scr_offset           ;load the scroll offset 
                    cmpa     #25                  ;are we at this point in the scroll? 
                    bne      check_score_rt       ;if not just return 
                    jsr      play_pointsound      ;otherwise play sound for score 
;score routine goes here ------ simple 3byte not packed
                    lda      scr_byte1            ;load byte storing single figures 
                    inca                          ;increase score by 1 
                    cmpa     #10                  ;is it higher than 9 
                    beq      inc_digit2           ;if so jump to increase digit 2 
                    sta      scr_byte1            ;or just store increased value 
                    adda     #48                  ;also add 48 for ascii version 
                    sta      scr_txt+2            ;save ascii 
                    bra      strip_score          ;no need to increase next digit, so continue to strip digits 

inc_digit2: 
                    clra     
                    sta      scr_byte1            ;reset byte1 
                    adda     #48 
                    sta      scr_txt+2            ;save ascii byte1 but reversed in memory else it would be 100 instead of 001 
                    lda      scr_byte2 
                    inca     
                    cmpa     #5 
;	beq		inc_digit3
                    beq      scoremax             ;over 5 (50) go to win screen 
                    sta      scr_byte2 
                    adda     #48 
                    sta      scr_txt+1            ;save ascii byte2 
                    bra      strip_score 

;inc_digit3					;no longer required
;	clra
;	sta		scr_byte2
;	adda	#48
;	sta		scr_txt+1
;	lda		scr_byte3
;	inca
;	cmpa	#10
;	beq		scoremax
;	sta		scr_byte3
;	adda	#48
;	sta		scr_txt
;	bra		strip_score
scoremax: 
                                                  ;if      we get here the score must of maxed out to 50 
                                                  ;put     in a win screen?? 
                                                  ;set     final score to 50! 
                    sta      scr_byte2 
                    adda     #48 
                    sta      scr_txt+1            ;save ascii byte2 
                    clra     
                    sta      scr_byte1            ;reset byte1 
                    adda     #48 
                    sta      scr_txt+2 
                    jsr      strip_score 
                    jsr      update_hiscr 
                    jsr      win_screen 
strip_score:                                      ;remove  leading 00s before returning from updating the score 
                    lda      scr_txt 
                    cmpa     #48 
                    bne      check_score_rt 
                    lda      #32 
                    sta      scr_txt 
                    lda      scr_txt+1 
                    cmpa     #48 
                    bne      check_score_rt 
                    lda      #32 
                    sta      scr_txt+1 
check_score_rt: 
                    rts      

;}	
check_collision:                                  ;{ 
                    ldb      #1                   ;check the pipe of the 3rd tile 
                    addb     level_shift          ;the offset of the level 
                    ldx      #level 
                    lda      b,x 
                    cmpa     #0 
                    bne      check_pipe_1         ;if not 0 check pipes 
                    rts                           ;no pipe so don't check 

check_pipe_1: 
                    cmpa     #1 
                    bne      check_pipe_2 
                    ldb      bird_y 
                    cmpb     #95 
                    bge      bird_dead_mode       ;branch if greater then or equal 
                    cmpb     #53 
                    ble      bird_dead_mode       ;branch if less than or equal 
                    rts      

check_pipe_2: 
                    cmpa     #2 
                    bne      check_pipe_3 
                    ldb      bird_y               ;not sure why but b seems to get trashed so load it again 
                    cmpb     #65 
                    bge      bird_dead_mode       ;branch if greater then or equal 
                    cmpb     #23 
                    ble      bird_dead_mode       ;branch if less than or equal 
                    rts      

check_pipe_3: 
                    cmpa     #3 
                    bne      check_pipe_4 
                    ldb      bird_y               ;not sure why but b seems to get trashed so load it again 
                    cmpb     #35 
                    bge      bird_dead_mode       ;branch if greater then or equal 
                    cmpb     #-7 
                    ble      bird_dead_mode       ;branch if less than or equal 
                    rts      

check_pipe_4: 
                    cmpa     #4 
                    bne      check_pipe_5 
                    ldb      bird_y               ;not sure why but b seems to get trashed so load it again 
                    cmpb     #5 
                    bge      bird_dead_mode       ;branch if greater then or equal 
                    cmpb     #-37 
                    ble      bird_dead_mode       ;branch if less than or equal 
                    rts      

check_pipe_5: 
                    cmpa     #5 
                    bne      check_pipe_6 
                    ldb      bird_y               ;not sure why but b seems to get trashed so load it again 
                    cmpb     #-25 
                    bge      bird_dead_mode       ;branch if greater then or equal 
                    cmpb     #-67 
                    ble      bird_dead_mode       ;branch if less than or equal 
                    rts      

check_pipe_6: 
                    cmpa     #6 
                    bne      check_pipe_rt        ;We should never get here anyway- if we do something is wrong!! it should of been 0 to 6 
                    ldb      bird_y               ;not sure why but b seems to get trashed so load it again 
                    cmpb     #-55 
                    bge      bird_dead_mode       ;branch if greater then or equal 
                    cmpb     #-97 
                    ble      bird_dead_mode       ;branch if less than or equal 
check_pipe_rt: 
                    rts      

;}
scroll:                                           ;we      scroll one tile distance and then shift the whole level by 1 
                    lda      scr_offset 
                    deca                          ;reduce offset by 1 
                    sta      scr_offset 
                    bne      sc_rt                ;if not 0 return else if 0... 
                    lda      #31                  ;reset the scroll 
                    sta      scr_offset           ;store offset 
                    lda      level_shift          ;load the where we start drawing the level offset in memory 
                    inca                          ; increase offset 
                    sta      level_shift          ; store shift 
                    cmpa     #121                 ; check if we want to jump the level back to a certain point 
                    bge      move_back            ; go to reset the shift 
                    bra      sc_rt 

move_back: 
                    lda      #7                   ;This is the position in the level index we are resetting to 
                    sta      level_shift          ;reset the shift 
                                                  ;continue  
sc_rt:                                            ;to      return to main 
                    rts      

drawlevel: 
                    lda      #-95                 ;left side of the screen 
                    adda     scr_offset           ;add scroll offset 
                    sta      cur_offset 
                    ldb      #0                   ;number of tiles 
                    stb      cur_tile 
tile: 
                    ldb      cur_tile 
                    addb     level_shift 
                    ldx      #level 
                    lda      b,x 
                    sta      b_pipe               ;save the level data for drawing the correct height 
                    cmpa     #0                   ;best way to do this? 
                    bne      draw                 ;if the tile is not 0, go draw something 
afterdraw: 
                    lda      cur_tile 
                    inca                          ;load the next tile to draw on screen 
                    cmpa     #6                   ;number of tiles to draw on screen 
                    bge      endx                 ;if we got to the end of the screen stop drawing tiles 
                    sta      cur_tile             ;or save the next tile to draw 
                    lda      cur_offset           ;the screen offset of where to draw the tile 
                    adda     #32                  ;next tile starts 32 along the x 
                    sta      cur_offset           ;save the offset 
                    bra      tile                 ;draw the next tile 

endx: 
                    rts      

draw: 
                    jsr      Reset0Ref 
                    lda      #-127                ;Y position 
                    ldb      cur_offset           ;X position 
                    jsr      Moveto_d_7F 
                    jsr      setpipeintensity 
                                                  ;check   which pipe we are drawing 
                    lda      b_pipe 
                    cmpa     #1 
                    beq      draw_pipeup_1 
                    cmpa     #2 
                    beq      draw_pipeup_2 
                    cmpa     #3 
                    beq      draw_pipeup_3 
                    cmpa     #4 
                    beq      draw_pipeup_4 
                    cmpa     #5 
                    beq      draw_pipeup_5 
                    cmpa     #6 
                    beq      draw_pipeup_6 
                                                  ;we      should never get to here...if we do 
                                                  ;b_pipe  contained something other than we expect (we expect 0 to 6) 
draw_pipeup_1: 
                    ldx      #pipeup_1            ; vectors 
                    bra      draw_pipeup_fin 

draw_pipeup_2: 
                    ldx      #pipeup_2            ; vectors 
                    bra      draw_pipeup_fin 

draw_pipeup_3: 
                    ldx      #pipeup_3            ; vectors 
                    bra      draw_pipeup_fin 

draw_pipeup_4: 
                    ldx      #pipeup_4            ; vectors 
                    bra      draw_pipeup_fin 

draw_pipeup_5: 
                    ldx      #pipeup_5            ; vectors 
                    bra      draw_pipeup_fin 

draw_pipeup_6: 
                    ldx      #pipeup_6            ; vectors 
                    bra      draw_pipeup_fin 

draw_pipeup_fin: 
                    lda      #8                   ; number of vectors in pipe 
                    ldb      #127                 ; Scaling 
                    jsr      Draw_VL_ab           ; Draw 
drawdown: 
                    jsr      Reset0Ref 
                    lda      #127 
                    ldb      cur_offset 
                    jsr      Moveto_d_7F 
                                                  ;check   which pipe we are drawing down 
                    lda      b_pipe 
                    cmpa     #1 
                    beq      draw_pipedown_1 
                    cmpa     #2 
                    beq      draw_pipedown_2 
                    cmpa     #3 
                    beq      draw_pipedown_3 
                    cmpa     #4 
                    beq      draw_pipedown_4 
                    cmpa     #5 
                    beq      draw_pipedown_5 
                    cmpa     #6 
                    beq      draw_pipedown_6 
                                                  ;we      should never get to here...if we do 
                                                  ;b_pipe  contained something other than we expect 
draw_pipedown_1: 
                    ldx      #pipedown_1          ; vectors 
                    bra      draw_pipedown_fin 

draw_pipedown_2: 
                    ldx      #pipedown_2          ; vectors 
                    bra      draw_pipedown_fin 

draw_pipedown_3: 
                    ldx      #pipedown_3          ; vectors 
                    bra      draw_pipedown_fin 

draw_pipedown_4: 
                    ldx      #pipedown_4          ; vectors 
                    bra      draw_pipedown_fin 

draw_pipedown_5: 
                    ldx      #pipedown_5          ; vectors 
                    bra      draw_pipedown_fin 

draw_pipedown_6: 
                    ldx      #pipedown_6          ; vectors 
                    bra      draw_pipedown_fin 

draw_pipedown_fin: 
                    lda      #8                   ; number of vectors in pipe 
                    ldb      #127                 ; Scaling 
                    jsr      Draw_VL_ab           ; Draw 
                    bra      afterdraw 

;pipe intensity	
setpipeintensity: 
                    lda      dead_flag            ;check if dead, if so set all the pipes to a low intensity 
                    cmpa     #1                   ;#1 is dead 
                    bne      setpipe_r 
                    lda      #40 
                    jsr      Intensity_a 
                    bra      setpipeend 

setpipe_r                                         ;set     pipes to different intensity depending where they are on the screen. 
                    lda      cur_offset 
                    cmpa     #40 
                    bge      setrightfade         ;branch if equal or higher 
                    cmpa     #-40 
                    ble      setleftfade          ;branch if equal or lower 
                    lda      #100                 ;if normal set intensity standard level 
                    jsr      Intensity_a 
                    bra      setpipeend           ;normal so go to end 

setrightfade: 
                    lda      cur_offset 
                    suba     #80 
                    nega     
                    adda     #60 
                    jsr      Intensity_a 
                    bra      setpipeend 

setleftfade: 
                    lda      cur_offset 
                    adda     #120 
                    jsr      Intensity_a 
                                                  ;will    carry on to setpipeend 
setpipeend: 
                    rts      

;end of pipe intensity
move_bird: 
                    lda      bird_vel_count 
                    deca     
                    sta      bird_vel_count 
                    cmpa     #0 
                    bne      bird_buttons         ;if its not time to update velocity skip it 
                    lda      #BIRDVCOUNT          ;reset counter to this CONSTANT VALUE 
                    sta      bird_vel_count       ;this counter decides how quickly we update the velocity 
                    lda      bird_vel 
                    inca     
                    cmpa     #6                   ;are we at max? 
                    blt      update_bird_vel      ;branch if less or equal 
                    lda      #6                   ;else set velocity to max 
                    sta      bird_vel 
update_bird_vel: 
                    sta      bird_vel             ;save new bird velocity 
bird_buttons: 
                    jsr      Read_Btns 
                    cmpa     #0 
                    beq      update_bird_pos      ;no button pressed go to update 
                    lda      bird_vel             ;button pressed so put up velocity 
                    adda     #-4 
                    sta      bird_vel 
                    jsr      play_flapsound 
update_bird_pos: 
                    ldb      bird_vel 
                    negb     
                    aslb     
                    stb      bird_rotation 
                    lda      bird_y 
                    suba     bird_vel 
                    sta      bird_y 
                    cmpa     #-120                ;check if bird hit bottom of screen 
                    ble      bird_hit_ground      ;less than or equal 
                    cmpa     #120 
                    bge      bird_hit_top         ;greater than or equal to 
                    rts                           ;return to game loop 

bird_hit_top: 
                    lda      #120 
                    sta      bird_y               ;set y to top of screen 
                    lda      #0 
                    sta      bird_vel             ;set velocity to 0 to stop bird flying out the top of the screen 
                    rts      

bird_hit_ground: 
                    lda      #-120 
                    sta      bird_y 
                    bra      bird_dead_mode       ; HIT ground - dead! 

                    rts      

dead_bird_hit_top:                                ;unlikely  
                    lda      #120 
                    sta      bird_y               ;set y to top of screen 
                    lda      #0 
                    sta      bird_vel             ;set velocity to 0 to stop bird flying out the top of the screen 
                    rts      

dead_bird_hit_ground:                             ;when  dead bird hits ground 
                    lda      #-120                ;we are already in bird_dead_mode so don't want to call it again 
                    sta      bird_y               ;this is why we have another version of this routine 
                    rts      

bird_dead_pos: 
                    lda      bird_y 
                    cmpa     #-116 
                    bge      bird_dead_pos_update 
                    rts      

bird_dead_pos_update: 
                    ldb      bird_vel 
                    cmpb     #12 
                    bge      bird_dead_pos_v 
                    addb     #1 
                    stb      bird_vel 
bird_dead_pos_v 
                    ldb      #-15 
                    stb      bird_rotation 
                    lda      bird_y 
                    suba     bird_vel 
                    sta      bird_y 
                    cmpa     #-120                ;check if bird hit bottom of screen 
                    ble      dead_bird_hit_ground ;less than or equal 
                    cmpa     #120 
                    bge      dead_bird_hit_top    ;greater than or equal to 
                    rts                           ;return to game loop 

bird_attract_mode:                                ;move    bird up and down when in attract mode 
                    ldb      bird_attract_move_counter 
                    ldx      #bird_attract_move_anim 
                    lda      b,x 
                    sta      bird_y 
                    incb     
                    cmpb     #17 
                    bge      bird_attract_move_reset 
                    stb      bird_attract_move_counter 
                    rts      

bird_attract_move_reset: 
                    lda      #0 
                    sta      bird_attract_move_counter 
                    rts      

;///////////////PRINTING TEXT/// should macro this???
;{
print_score: 
                    jsr      Reset0Ref 
                    jsr      Intensity_5F         ; Sets the intensity of the 
                    lda      #-6 
                    ldb      #48 
                    sta      Vec_Text_Height 
                    stb      Vec_Text_Width 
                    ldu      #scr_txt             ; address of string 
                    lda      #120                 ; Text position relative Y 
                    ldb      #-20                 ; Text position relative X 
                    jsr      Print_Str_d          ; Vectrex BIOS print routine 
                    rts      

                    	include  "DRAWLOGO.I"        ;contains draw_titles
print_win: 
                    jsr      Reset0Ref 
                    lda      credit_intensity 
                    deca     
                    sta      credit_intensity 
                    jsr      Intensity_a          ; Sets the intensity of the 
                    lda      #-6 
                    ldb      #40 
                    sta      Vec_Text_Height 
                    stb      Vec_Text_Width 
                    ldu      #win_string          ; address of string 
                    lda      #60                  ; Text position relative Y 
                    ldb      #-70                 ; Text position relative X 
                    jsr      Print_Str_d          ; Vectrex BIOS print routine 
                    rts      

draw_copyright: 
                    jsr      Reset0Ref 
                    lda      #40 
                    jsr      Intensity_a          ; Sets the intensity of the 
                    lda      #-4 
                    ldb      #40 
                    sta      Vec_Text_Height 
                    stb      Vec_Text_Width 
                    ldu      #copyright_string    ; address of string 
                    lda      #-100                ; Text position relative Y 
                    ldb      #-75                 ; Text position relative X 
                    jsr      Print_Str_d          ; Vectrex BIOS print routine 
                    rts      

draw_score_name: 
                    jsr      Reset0Ref 
                    lda      #100 
                    jsr      Intensity_a          ; Sets the intensity of the 
                    lda      #-6 
                    ldb      #60 
                    sta      Vec_Text_Height 
                    stb      Vec_Text_Width 
                    jsr      get_score_name       ;load scorename into u 
                    lda      #0                   ; Text position relative Y 
                    ldb      #-80                 ; Text position relative X 
                    jsr      Print_Str_d          ; Vectrex BIOS print routine 
                    rts      

draw_tap: 
                    jsr      Reset0Ref 
                    lda      tap_intensity 
                    cmpa     #120 
                    ble      draw_tap_r 
                    lda      #30 
                    sta      tap_intensity 
draw_tap_r: 
                    inca     
                    inca     
                    sta      tap_intensity 
                    jsr      Intensity_a          ; Sets the intensity of the 
                    lda      #-6 
                    ldb      #50 
                    sta      Vec_Text_Height 
                    stb      Vec_Text_Width 
                    ldu      #tap_string          ; address of string 
                    lda      #-30                 ; Text position relative Y 
                    ldb      #-20                 ; Text position relative X 
                    jsr      Print_Str_d          ; Vectrex BIOS print routine 
                    rts      

draw_dead_score_text: 
                    jsr      Reset0Ref 
                    lda      #120 
                    jsr      Intensity_a          ; Sets the intensity of the 
                    lda      #-6 
                    ldb      #40 
                    sta      Vec_Text_Height 
                    stb      Vec_Text_Width 
                    ldu      #score_text_string   ; address of string 
                    lda      #-30                 ; Text position relative Y 
                    ldb      #-30                 ; Text position relative X 
                    jsr      Print_Str_d          ; Vectrex BIOS print routine 
                                                  ;continue  to draw score ascii 
                    jsr      Reset0Ref 
                    lda      #120 
                    jsr      Intensity_a          ; Sets the intensity of the 
                    lda      #-6 
                    ldb      #40 
                    sta      Vec_Text_Height 
                    stb      Vec_Text_Width 
                    ldu      #scr_txt             ; address of string 
                    lda      #-30                 ; Text position relative Y 
                    ldb      #0                   ; Text position relative X 
                    jsr      Print_Str_d          ; Vectrex BIOS print routine 
                    rts      

draw_dead_hiscore_text: 
                    jsr      Reset0Ref 
                    lda      #120 
                    jsr      Intensity_a          ; Sets the intensity of the 
                    lda      #-6 
                    ldb      #40 
                    sta      Vec_Text_Height 
                    stb      Vec_Text_Width 
                    ldu      #hiscore_text_string ; address of string 
                    lda      #-50                 ; Text position relative Y 
                    ldb      #-30                 ; Text position relative X 
                    jsr      Print_Str_d          ; Vectrex BIOS print routine 
                                                  ;continue  to draw hiscore ascii 
                    jsr      Reset0Ref 
                    lda      #120 
                    jsr      Intensity_a          ; Sets the intensity of the 
                    lda      #-6 
                    ldb      #40 
                    sta      Vec_Text_Height 
                    stb      Vec_Text_Width 
                    ldu      #hiscr_txt           ; address of string 
                    lda      #-50                 ; Text position relative Y 
                    ldb      #0                   ; Text position relative X 
                    jsr      Print_Str_d          ; Vectrex BIOS print routine 
                    rts      

draw_game_over: 
                    jsr      Reset0Ref 
                    lda      game_over_intensity  ;fade up 
                    cmpa     #120 
                    bge      draw_game_over_r     ;greater or equal 
                    adda     #4                   ;increase intensity if required 
                    sta      game_over_intensity 
draw_game_over_r: 
                    jsr      Intensity_a          ; Sets the intensity of the gameover 
                    lda      game_over_text_scale ;scale 2 
                    cmpa     #-10                 ;is it at the value we want 
                    ble      draw_game_over_t     ;if less carry on else decrease 
                    deca     
                    sta      game_over_text_scale 
draw_game_over_t 
                    ldb      #120 
                    sta      Vec_Text_Height 
                    stb      Vec_Text_Width 
                    ldu      #game_over_string    ; address of string 
                    lda      game_over_text_scale ;use the text scale to offset the text a bit 
                    nega                          ;make it positive 
                    adda     #60                  ;add y pos of text 
                    ldb      #-95                 ; Text position relative X 
                    jsr      Print_Str_d          ; Vectrex BIOS print routine 
                    rts      

                    	include  "CREDROLL.I"        ;lets roll the credits - credit_roll
;}	
;////////////////////SOUND EFFECTS////////////////////////
;A bit of a mess but it works don't consider this a good example!!
;{
check_flapsound:                                  ;check   if the sound is still playing or not, if not clear it //messy branching?? 
                    lda      flap_snd_count 
                    cmpa     #0 
                    bne      check_f 
                    jsr      Clear_Sound 
                    bra      check_f_r 

check_f: 
                    dec      flap_snd_count 
                    bra      check_f_r_2          ;dont bother checking for point sound 2 

check_f_r: 
                    lda      point_snd_count      ;check if old first point sound finished 
                    cmpa     #1                   ;if a sound has finished playing check if we want to play point sound 
                    bne      check_f_r_2 
                    jsr      play_pointsound_2    ;if = 1 then play the second sound 
check_f_r_2: 
                    rts      

play_flapsound: 
                    lda      #$01                 ; Modify Register 1 
;	ldb     $fc93                   ; Tone Frequency = #$0XX
                    ldb      #-100                ; Tone Frequency = #$0XX 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$00                 ; Modify Register 0 
;	ldb     $fc92                   ; Tone Frequency = #$Xff
                    ldb      #100                 ; Tone Frequency = #$Xff 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$08                 ; Modify Register 8 
                    ldb      #15                  ; Volume=15 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$07                 ; Modify Register 7 
                    ldb      $c807                ; Get previous value for reg 7 
                    andb     #$fe                 ; Turn on-or off? Tone on Voice 1 
                    andb     #$08                 ; Turn on Noise on Voice 1 
                    jsr      Sound_Byte           ; Set register 
                    lda      #5                   ; Set soundflag to 10 
                    sta      flap_snd_count 
                    rts                           ; And return to main program 

play_deadsound: 
                    lda      #$01                 ; Modify Register 1 
                    ldb      $fc33                ; Tone Frequency = #$0XX 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$00                 ; Modify Register 0 
                    ldb      $fc22                ; Tone Frequency = #$Xff 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$03                 ; Modify Register 3 
                    ldb      $fc98                ; Tone Frequency = #$Xff 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$06                 ; Modify Register 6 
                    ldb      $fc77                ; noise 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$08                 ; Modify Register 8 
                    ldb      #15                  ; Volume=15 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$09                 ; Modify Register 9 
                    ldb      #15                  ; Volume=1 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$10                 ; Modify Register 10 
                    ldb      #15                  ; Volume=1 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$07                 ; Modify Register 7 
                    ldb      #$00 
                                                  ;ldb     $c807 ; Get previous value for reg 7 
                                                  ;andb    #$fe ; Turn on-or off? Tone on Voice 1 
                                                  ;andb    #$08 ; Turn on Noise on Voice 1 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$08                 ;envelope register/on/off - not sure if this is working 
                    ldb      #$77 
                    jsr      Sound_Byte 
                    lda      #$11                 ;envelope register period- not sure if this is working fine 
                    ldb      #$01 
                    jsr      Sound_Byte 
                    lda      #$64                 ;envelope register period- not sure if this is working corse 
                    ldb      #$0F 
                    jsr      Sound_Byte 
                    lda      #$13                 ;envelope register - not sure if this is working 
                    ldb      #$0f 
                    jsr      Sound_Byte 
                    lda      #5                   ; Set soundflag to 10 
                    sta      flap_snd_count 
                    rts                           ; And return to main program 

;Point sound/////
play_pointsound: 
                    lda      #$01                 ; Modify Register 1 
                    ldb      $fc20                ; Tone Frequency = #$0XX 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$00                 ; Modify Register 0 
                    ldb      $fc27                ; Tone Frequency = #$Xff 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$08                 ; Modify Register 8 
                    ldb      #15                  ; Volume=15 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$07                 ; Modify Register 7 
                    ldb      $c807                ; Get previous value for reg 7 
                    andb     #$fe                 ; Turn on Tone on Voice 1 
                    orb      #$08                 ; Turn on Noise on Voice 1 
                    jsr      Sound_Byte           ; Set register 
                                                  ;lda     #$13 ;envelope register - not sure if this is working 
                                                  ;ldb     #12 
                                                  ;jsr     Sound_Byte 
                    lda      #2                   ; Set soundflag to 10 
                    sta      flap_snd_count 
                    lda      #1 
                    sta      point_snd_count      ;once is is 0 we will play another higher note 
                    rts                           ; And return to main program 

play_pointsound_2: 
                    lda      #$01                 ; Modify Register 1 
                    ldb      $fc20                ; Tone Frequency = #$0XX 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$00                 ; Modify Register 0 
                    ldb      $fc90                ; Tone Frequency = #$Xff 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$08                 ; Modify Register 8 
                    ldb      #12                  ; Volume=15 
                    jsr      Sound_Byte           ; Set register 
                    lda      #$07                 ; Modify Register 7 
                    ldb      $c807                ; Get previous value for reg 7 
                    andb     #$fe                 ; Turn on Tone on Voice 1 
                    orb      #$08                 ; Turn on Noise on Voice 1 
                    jsr      Sound_Byte           ; Set register 
;	lda		#$13				;envelope register - not sure if this is working
;	ldb		#100
;	jsr		Sound_Byte
                    lda      #3                   ; Set soundflag to 10 
                    sta      flap_snd_count 
                    lda      #0 
                    sta      point_snd_count      ;reset this bool flag its not really a count 
                    rts                           ; And return to main program 

;}	
;////////////////Print Debug Commented out when not req//////////////////////////
;print_debug:
;	jsr		Reset0Ref
;	jsr     Intensity_5F            ;Sets the intensity of the
;
;	ldu     #debug_string     		;address of string
;	lda     #$10                    ; Text position relative Y
;	ldb     #-$50                   ; Text position relative X
;    jsr    Print_Str_d				; Vectrex BIOS print routine
;	rts
;DRAW THE BIRD
draw_bird:                                        ;{ 
                                                  ;rotate  bird vectors 
                    ldx      #beak                ; Load the vector list 
                    ldb      #45                  ; Number of vectors for the WHOLE BIRD AND WING ANIMS!! add up all the vectors n-1 
                    lda      bird_rotation        ; Rotation angle 
                    ldu      #r_beak              ; Save to ram location 
                    jsr      Rot_VL_ab            ; Rotates the coordinates using Bios routine 
                    lda      #100 
                    jsr      Intensity_a 
                    jsr      dr_beak 
dr_beak: 
                    jsr      Reset0Ref 
                    lda      bird_y 
                    ldb      bird_x 
                    jsr      Moveto_d_7F 
                    ldx      #r_beak              ;vectors 
                    lda      #9                   ;number of vectors 
                    ldb      #16                  ;Scaling 
                    jsr      Mov_Draw_VL_ab       ;Draw 
dr_eyeball: 
                    jsr      Reset0Ref 
                    lda      bird_y 
                    ldb      bird_x 
                    jsr      Moveto_d_7F 
                    ldx      #r_eyeball           ; vectors 
                    lda      #1                   ; number of vectors 
                    ldb      #16                  ; Scaling 
                    jsr      Mov_Draw_VL_ab       ; Draw 
dr_bottom: 
                    jsr      Reset0Ref 
                    lda      bird_y 
                    ldb      bird_x 
                    jsr      Moveto_d_7F 
                    ldx      #r_bottom            ; vectors 
                    lda      #3                   ; number of vectors 
                    ldb      #16                  ; Scaling 
                    jsr      Mov_Draw_VL_ab       ; Draw 
dr_wing: 
                    jsr      Reset0Ref 
                    lda      bird_y 
                    ldb      bird_x 
                    jsr      Moveto_d_7F 
                                                  ;which   wing to draw using wing_anim_counter, count to say 12 compare every 4 or something - depending on speed required 
                    lda      flap_on              ;check if flap is on 
                    cmpa     #0                   ;if its not 0 
                    bne      flapping             ;carry on flapping 
                    sta      wing_anim_counter    ;else it is 0, so force the 0 value in the wing anim counter so it doesnt move 
flapping: 
                    lda      wing_anim_counter 
                    cmpa     #6                   ;at this value change wing animation 
                    bge      dr_wing_2 
                    ldx      #r_wing              ;vectors 
                    bra      dr_wing_final 

dr_wing_2: 
                    cmpa     #12                  ;at this value change wing animation 
                    bge      dr_wing_3 
                    ldx      #r_wing_2 
                    bra      dr_wing_final 

dr_wing_3 
                    cmpa     #18                  ;at this value change wing animation 
                    bge      dr_wing_reset 
                    ldx      #r_wing_3 
                    bra      dr_wing_final 

dr_wing_reset 
                    ldb      #0 
                    stb      wing_anim_counter 
dr_wing_final: 
                    inc      wing_anim_counter 
                    lda      #5                   ; number of vectors 
                    ldb      #16                  ; Scaling 
                    jsr      Mov_Draw_VL_ab       ; Draw 
dr_eye: 
                    jsr      Reset0Ref 
                    lda      bird_y 
                    ldb      bird_x 
                    jsr      Moveto_d_7F 
                    ldx      #r_eye               ; vectors 
                    lda      #6                   ; number of vectors 
                    ldb      #16                  ; Scaling 
                    jsr      Mov_Draw_VL_ab       ; Draw 
dr_top: 
                    jsr      Reset0Ref 
                    lda      bird_y 
                    ldb      bird_x 
                    jsr      Moveto_d_7F 
                    ldx      #r_top               ; vectors 
                    lda      #4                   ; number of vectors 
                    ldb      #16                  ; Scaling 
                    jsr      Mov_Draw_VL_ab       ; Draw 
                    rts                           ;Final return from drawing bird 

                                                  ;Final   return from drawing bird 
                                                  ;}       
                    	include	  "WINSCREEN.I"      ;all code for winscreen
                    	include  "PARTICLES.I"       ;contains particle code
                                                  ;Level   Data 6 tiles per screen, note 2nd and last fcb statement are the same to allow looping forever if required 
                                                  ;0       means no pipe any other number 1 to 6 is different height of pipe 
level                                             ;{       
                    fcb      0,0,0,0,0,0 
                    fcb      2,0,0,3,0,0          ;7jumpback to here using 7 
                    fcb      4,0,0,5,0,0          ;13 
                    fcb      2,0,0,1,0,0          ;19 
                    fcb      2,0,0,2,0,0          ;25 
                    fcb      3,0,4,0,5,0          ;31 
                    fcb      3,0,2,0,4,0          ;37 
                    fcb      5,0,6,0,4,0          ;43 
                    fcb      2,0,4,0,4,0          ;49 
                    fcb      3,0,2,0,1,0          ;55 
                    fcb      2,0,1,0,3,0          ;61 
                    fcb      2,0,1,0,2,0          ;67 
                    fcb      3,0,4,0,5,0          ;73 
                    fcb      6,0,0,4,0,0          ;79 
                    fcb      2,0,3,0,4,0          ;85 
                    fcb      3,0,0,6,0,0          ;91 
                    fcb      0,1,0,0,6,0          ;97 
                    fcb      0,3,0,5,0,0          ;103 
                    fcb      0,2,0,3,0,0          ;109 
                    fcb      0,2,0,0,4,0          ;115 
                    fcb      2,0,0,3,0,0          ;121 (121 is the max... as its the starting digit of the line... so 121+7=127) 
;}
bird_attract_move_anim 
                    fcb      0,1,1,2,3,4,5,6,7,7,6,5,4,3,2,1,0 
;pipe vectors	
                    	include  "PIPEVEC.I"
;bird graphics
                    	include  "BIRDVEC.I"
;scrname
                    	include  "SCRNAME.I"
                    	include  "CREDITS.I"
;veccy logo data
                    	include  "VECLOGO2.I"
;debug_string:
;	db   "DEBUG"              ; only capital letters
;	db   $80                      ; $80 is end of string
win_string: 
                    	db      "YOURE THE BEST! AROUND!" ; only capital letters
                    db       $80                  ; $80 is end of string 
title_string: 
                    	db      "VECCY BIRD"         ; only capital letters
                    db       $80                  ; $80 is end of string 
tap_string: 
                    	db      "TAP"                ; only capital letters
                    db       $80                  ; $80 is end of string 
game_over_string: 
                    	db      "GAME OVER"          ; only capital letters
                    db       $80                  ; $80 is end of string 
score_text_string: 
                    	db      "SCORE"              ; only capital letters
                    db       $80                  ; $80 is end of string 
hiscore_text_string: 
                    	db      "BEST"               ; only capital letters
                    db       $80                  ; $80 is end of string 
copyright_string: 
                    db       $67 
                    	db      "MICHAEL SIMONDS 2014 V1.5" ; only capital letters
                    db       $80                  ; $80 is end of string 
musa                                              ;        Start music that plays nothing 
                    fdb      $fee8 
                    fdb      $fbe6 
                    fcb      $0,$80 
                    fcb      $0,$80 
