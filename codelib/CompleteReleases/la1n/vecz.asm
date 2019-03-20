;***************************************************************************
; vecZ 2o16 BY LA1N.CH   
;***************************************************************************
; 
; OLDSCHOOL VECTOR/WIREFRAME SHOOTEMUP IN THE MOOD OF 1984
; SCROLLING UP GAME IN THE TRADITION OF RIVER RAID, XEVIOUS, XENON 2 
; VARIOUS ANIMATED ENEMIES ALL DESIGNED WITH ONLY 4 LINES AND THE
; BIG BOSS vecZ WAITING FOR YOU AT THE END.
;
; rene.bauer@zhdk.ch
; @ixistenz
; bin/sourcecode: http://www.la1n.ch/vecz/ 
; rom (soon): http://www.madtronix.com  
;
; GREETINGS TO ABAGAMES FOR THE OPENGL/VECTOR WORKS LIKE GUNROAR, 
; TUKIMI-FIGHTERS ETC. NICE WORK
; GREETINGS TO RICHARDH FOR HIS MULTICARDS (THANKS!) 
; GREETINGS TO JEFF MINTER STILL BEEING THERE
; GREETINGS TO BAUDSURFER SORRY STILL ON GAME THING BUT CALLING BACK
;
; CREDITS FOR RIVER RAID, XEVIOUS, R-TYPE, XENON, ZYNAPS, XENON II, 
;             GUNROAR IKARUGA
;
; MECHANICS: 
; SIMPLE ENTER THE VECZ AND TRY TO DESTROY ITS EMPIRE! 
; AND OF COURSE: IT IS NOT ABOUT SHOOTEMUP ALL - IT IS ABOUT SURVIVE AND 
; SHOOTEMUP IS ONLY ONE TACTIC! 
;
; YOU WILL FIND OLDER PROJECTS OF LA1N AT HTTP://WWW.LA1N.CH
; OR LOOK FOR OUR GAMEART/ARTGAMES AT HTTP://WWW.AND-OR.CH
;
; REMARK:
; IT IS CLEAR NOW WHY ALMOST THE MOST SHOOTERS ON VECTREX ARE HORIZONTAL SHOOTERS:
; YOU NEED (A LOT) LESS LINES FOR THE WHOLE SCREEN THAN VERTICAL SHOOTERS
;
; TESTED: 
; - PARAJVEv0.7
; - VECTREX WITH MULTICARD
;
; WORKING PROCESS: THE GAME WAS MADE DURING LOOKING WHILE CODING/COMPILING
; A LOT OF THE TRASH MOVIES COMING OUT ON ITUNES - IF YOU WOULD FIND SOME 
; PARALLES WITH THIS MOVIE TRASH - COULD BE .-) 
;
;***************************************************************************
; COMPILE
;***************************************************************************
;
; AS09-DOS.EXE -w200 -h0 -l  -o  -mcti C:\ASMDASM\AS09_142\vecz.asm
; 
;***************************************************************************
; VERSIONS
;***************************************************************************
;
; TODOS
; MUSIC
;
; HISTORY

; 	    j. romero in the dark labyrinth
; 0.84	added some snd-effects (ay/ym)
; 0.831	some leveldesign
; 0.83	speed up iteration over level_segment s
; 0.822 updated gui positions
; 0.821 leveldesign
; 0.82	updated level editor
; 0.81	polishing won-state 
; 0.8	added a big boss
; 0.79  more graphics - real challenge work with only 4 lines a sprite
; 0.78  speed up again ...  > back again (problems with ...) > 	inc		level_segment_offset
; 0.77  turned on shadow again (problem: new vectrex is brighter much brighter)
; 0.76	level ...
; 0.75	working on intensity (backside potenti for intensity)
; 0.74  sound effects
; 0.73	faster than light (only every 3rd frame > detect collisions)
; 0.72  hide/show background
; 0.71 	clean up some rom data (not used titles)
; 0.7	new animations
; 0.63  new spaceship for player
; 0.62  first implementation of won
; 0.61  bug fix (game over > back to menu)
; 0.60	created a level editor processing in & first export
; 0.58  more title graphics
; 0.57	new game over (button problem)
; 0.56  more levels
; 0.55  new logo (made with illustrator & processing tool)
; 0.54	shooting enemies (base stations - five eyes .-)
; 0.53  new leveldesign
; 0.52  release x enemies
; 0.51  optimization: http://www.playvectrex.com/designit/chrissalo/optimization.htm
; 0.50  pref for stripes_amount 
; 0.49	change in structure: display top
; 0.48	new enemies
; 0.47	add type - appearat
; 0.46  add explosions and explosion animation [20150116]
; 0.45	add message/comment system [20150112]
; 0.4	implementation anim system [20150111]
; 0.3	implemented spawn system [20150107]
; 0.21	problems with scrolling 
; 0.2	background system
; 0.1 	new object system
;
;***************************************************************************
; ARCHITECTURE
;***************************************************************************
; 
; STRIPES (stored in #leveldata)
;
; - 1: A
; - 2: B
; - 3: C
;
; Important 'variables'
; 
; - level_segment (<!!!! starting at )
; - Position in the levelY (level_segment): Ex. 2
; - Counting down stripesize (level_segment_offset) 
; - Stripe: |----> <-----|
;   (level_positionx	/level_positionxx	/ level_positiony
;
; - Scrolling to next pixelline (scrolling_flag)
; - Time to spawn (spawn_flag)
;	
; 
;***************************************************************************
; FOR THE REST OF US (PROGRAMMERS)
;***************************************************************************
;
; lda a,x ; position x from a [a]
; adda b ?
; add a,b ?
;
; Code is horrible, sorry. 90% of the code could be
; made much simpler. No entry for coders heaven .-)
;
; Infos about vectrec: http://www.vectrex.de
;
; Read:
; Most important commands (LD,ST, Tables(Index)
; http://www.playvectrex.com/designit/christumber/tutorial.htm#Indexed%20Addressing%20and%20Tables
; most important commands
; constants: equ { #, RAM: $c0f8 }
; load: ld[a|b|x|y] {8BIT: #3,RAM: $c0f8} > lld
; load index: lda 4,x | lda ,x+| lda,x++
; lea change pointer! leax 10,x / add 10 bytes in the pointer
; store: st[a|b|x|y] {#3,RAM: $c0f8}
; transfer tfr [a|b|x|y] [a|b|x|y] (copy a to b)
;
; Memory (RAM/ROM etc)
; http://www.playvectrex.com/designit/chrissalo/memorymap.htm
; 
; CodeSnipped: 
; http://pelikonepeijoonit.net/files/vec/coders.html
;
; BIOS & description
; http://www.playvectrex.com/designit/chrissalo/bios.htm
;
; ALL IN ONE
; http://www.electronics.dit.ie/staff/ypanarin/Lecture%20Notes/K235-1/04%20Assembly%206800%20A.pdf
; http://www.maddes.net/m6809pm/appendix_a.htm
; 
; All functions
; http://vectrexmuseum.com/share/coder/html/bios.htm#F511
;
; Draw
;
;           ^ -Y
;           | 
;           |
;   X-<---------->X+
;           |
;           |
;           \ +Y
;
; http://www.playvectrex.com/designit/chrissalo/linedrawing.htm
; "Print"
; http://vectrexprogramming.blogspot.co.uk/2014/11/converting-byte-value-to-ascii-in-6809.html
; Drawing Tool
; http://www.vectorzoa.com/vecdraw/vecdraw.html
;
; Collision Detection
; http://pelikonepeijoonit.net/files/vec/coleman.as9
;
; Joystick
; http://vectrexmuseum.com/share/coder/html/joystick1.asm
;
; Sound
; http://www.playvectrex.com/designit/chrissalo/soundplaying.htm
; Sound effects
; http://vectrexmuseum.com/share/coder/other/TEXT/SOUND/SOUND.TXT
; Audio-Processor: AY (General Instruments) > Licenses Yamaha (YM (Intellivision, MSX) > Tracker ~�Atari ST)
; http://vectorgaming.proboards.com/thread/312/vectrex-sound-programming?page=1
; http://en.wikipedia.org/wiki/General_Instrument_AY-3-8910
;
; Random +Example
; http://vectrexmuseum.com/share/coder/html/bios.htm#F511
;
; StartUP
; http://vectorgaming.proboards.com/thread/992/vectrex-programming-tutorial-tools-tech
; Forum
; http://vectrexprogramming.blogspot.co.uk
;
; Add Hardware:
; 3D-Imager, Pen: http://vectrexmuseum.com/share/coder/
;
; INTERESTING: LDA [$C880] ( LDD ( VALUE($C880) ) )
;
; MOST IMPORTANT:
;
; - leax
; - TFR: Transfer (a->b) 
;
; TIPS:
; LDA #$05
; STA volcano
; .
; .
; LDX #$C880      ;Set register X to #$C880
; LDA volcano,X   ;LoaD register A with the value stored in the memory location
;                 ;which is the sum of the value in register X and the value
;                ;in memory location volcano
; 

        include "VECTREX.I"             ; vectrex function includes
				
        org $0000

;***************************************************************************
; CONSTANTTS (everything memory addresses, values, constants)
;***************************************************************************

state   equ $C880

;		state
;		0: menu
;		1: intro
;		2: ingame
;		3: gameover
;		4: won

STATE_MENU			equ		0
STATE_INTRO			equ		1
STATE_INGAME		equ		2
STATE_GAMEOVER		equ		3
STATE_WON			equ		4

; lifes 
lifes   	equ $C881
level   	equ $C882 ; level ... 0-4
shield   	equ $C882+1
score   	equ $C882+2

; temps
button_up 	equ $C882+3

; temps for etc
sprites_for_var  		equ $C882+4
sprites_for_var_var  	equ $C882+5
sprites_tmp_type 		equ $C882+6
sprites_tmp_move 		equ $C882+7
soundeffect				 equ $C882+8

; 1 or 0 (show borders ...)
fbackground		 	equ $C882+9

; score as string - 10 bytes
str_score			equ $C882+10 ; position y,x,+6bytes!


; button up counter
button_upcounter	equ $C882+47+241; $C882+16

; debug
debug_value			equ	$C882+17 ; 2bytes: byte y, byte x

; STRIPE TABLE INDEX (levelX)
; [x,y] {newtype,newtypesub, newx,newy, arg1,arg2}
STRIPE_SIZE				equ		8

STRIPE_X				equ		0
STRIPE_XX				equ		1
STRIPE_TYPE				equ		2
STRIPE_TYPESUB			equ		3
STRIPE_RELEASEX			equ		4
STRIPE_RELEASEY			equ		5
STRIPE_ARG0			equ		6
STRIPE_ARG1			equ		7

; STRIPE_DISPLAY_SIZE
STRIPES_AMOUNT	equ	11 ; amount of stripes 10
STRIPES_SIZE	equ	20 ; size of stripe  20

; SPAWN
STRIPES_SPAWNAT	equ 10 ; STRIPES_AMOUNT-1

; collision things
COLLTEST		equ	$f8ff	; Collision detection
collisionAyx	equ	$C882+18 ; 2bytes: byte y, byte x
collisionByx	equ	$C882+21 ; 2bytes: byte y, byte x

; big boss specials
bigbossReleased equ $C882+25  ; 0: not yet 1: release 2: killed > end of game�
bigbossBehaviour equ $C882+26

; bigbossDefeated 
bigbossDefeated	equ	$C882+27 

; time
counter_ms		equ	$C882+30
counter_sec		equ	$C882+31
counter_min		equ	$C882+32
spritesmove		equ	$C882+33

; level
; SEG2 (10px) 
; SEG1 (10px)
level_segment			equ  $C882+34 ; *10
level_segment_offset	equ  $C882+35 ; 0-9

; level_position
level_positionx		equ $C882+36
level_positionxx	equ $C882+37
level_positiony		equ $C882+38

; joystick_direction
joystick_direction	equ $C882+39

; anim
anim_flag			equ	$C882+40

; scroll
scrolling_flag		equ	$C882+41

; release (release it ...)
spawn_flag			equ	$C882+42

; messages
message_counter		equ	$C882+43
message_index		equ	$C882+44

; temp
temp			equ	$C882+45
temptemp		equ	$C882+46

spawn_more_counter  equ $C882+47 ; x=1bytes, y=1byted > n*2 sprites[i]       
spawn_offset  		equ $C882+48 ; x=1bytes, y=1byted > n*2 sprites[i]       

; display text
display_textcounter equ $C882+49 
display_textindex 	equ $C882+50

; sprites
spritesnr 		equ $C882+51  ; nr 12
;	table for everything ...	
spritesyx    	equ $C882+52 ; x=1bytes, y=1byted > n*2 sprites[i]       

PLAYERY	equ $C882+52
PLAYERX	equ $C882+52+1

; special sprites
; 0: player
SPRITE_PLAYER		equ		0
; 5: explosion
SPRITE_EXPLOSION	equ		5

; sprite-object
; 12-bytes for:
; [ 0] y
; [ 1] x
; [ 2] state: 0/1 ...
; [ 3] ***
; [ 4] type
;			0: player-objects
;			1: shoot
;			2: extra-objects
;			3: enemy-object
;
;			4: obsticals(?)
;			5: background

OBJ_TYPE_PLAYER		equ		0
OBJ_TYPE_SHOOT		equ		1
OBJ_TYPE_EXTRA		equ		2
OBJ_TYPE_ENEMY		equ		3
OBJ_TYPE_EXPLOSION	equ		4
OBJ_TYPE_BACKGR		equ		5

; used in the levelx table
OBJ_TYPE_MESSAGE	equ		6
OBJ_TYPE_NEWLEVEL	equ		7
OBJ_TYPE_WON		equ		8
OBJ_TYPE_HIDEBACK 	equ 	9
OBJ_TYPE_SHOWBACK 	equ 	10

;				
; [ 5] param
; [ 6] move
; [ 7] anim
; [ 8] height
; [ 9] with
; [10] intensity*
; [11] hits
;
; * not used
;
; INDEX
;
OBJ_SIZE	equ		12
;
OBJ_Y		equ		0
OBJ_X		equ		1
OBJ_STATE	equ		2
OBJ_TYPE	equ		3
OBJ_TYPESUB	equ		4
OBJ_PARAM	equ		5
OBJ_MOVE	equ		6
OBJ_ANIM	equ		7
OBJ_HEIGHT	equ		8
OBJ_WIDTH	equ		9
OBJ_PARAMEXT	equ		10
OBJ_HITS	equ		11

; sprite 0 > the player!
; sprite x > x*7bytes...

; spritesyx    13*12 = +add      

; spawn_more_counter 
; spawn_offset  equ $C882+47+241 ; x=1bytes, y=1byted > n*2 sprites[i]       


; rendered level 
rendered_level  equ $C882+53+242 ; x=1bytes, y=1byted > n*2 sprites[i]       
rendered_level_right  equ $C882+53+350 ; x=1bytes, y=1byted > n*2 sprites[i]       

; variables for the soundeffects
; problems with this routine and mem
sfx_pointer	EQU	$c882+520		
sfx_status	EQU	$c882+540

;***************************************************************************
; INIT
;***************************************************************************

		db      "g GCE LA1N", $80       ; 'g' is copyright sign
        dw      music1                  ; music from the rom
        db      $F8, $50, $20, -$55     ; height, width, rel y, rel x
                                                ; (from 0,0)
        db      "VECZ 2o16 0.84",$80   ; some game information,
        db      0                       ; end of game header

;***************************************************************************
; CODE SECTION
;***************************************************************************
; INIT
; start cartridge

        ; init
        lda 	 #STATE_MENU
        sta	 	 state
        lda      #0
        sta      level
		lda	 	 #0
		sta		 message_counter	
		lda	 	 #0
		sta 	 message_index
        
        lda		 #42 ; 42
        ; sta		 highscore
        lda      #0
        sta      score
        lda      #12 ; 12
        sta      spritesnr

; visual presets
        jsr     Intensity_3F       
        
; tmp
;		soundeffect
		lda		#0
		sta 	soundeffect
	
; reset all sprites
		lda		#0
		sta 	sprites_for_var   
		ldx 	#spritesyx
		lda		#-55
sprites_reset:           
		pshs    x 
		;lda     #0                    
		; code
		adda	#15
; defaults		
		sta		OBJ_Y,x
		ldb		#0	
		stb		OBJ_X,x
		; set to 0
		ldb		#0
		stb		OBJ_STATE,x ; state
		ldb		#0
		stb		3,x
		ldb		#2
		ldb		#0
		stb		4,x
		stb		5,x
		stb		6,x
		ldb		#4
		sta		OBJ_ANIM,x
		; types
; 4xshoots > 3 only
		; +4 = type
		ldb 	sprites_for_var
		cmpb	#1
		blt		not_shoot_range ; /1-5
		cmpb	#2 ; 5 default
		bgt		not_shoot_range
		ldb		#-80
		stb		1,x
		ldb		#0
		stb		OBJ_STATE,x		
		ldb		#1
		stb		3,x	 	
		ldb	    #MOVE_UPSHOOT ; up to top ... 
		stb		OBJ_MOVE,x
		; 1/1 - shoot
		;ldb		#0
		;stb		1,x
not_shoot_range:
; 4xshoots
		; +4 = type
		ldb 	sprites_for_var
		cmpb	#5
		bne		not_explosion
		ldb		#-80
		stb		OBJ_X,x
		ldb	    #0 ; status ... 
		stb		OBJ_STATE,x		
		ldb		#SPRITE_EXPLOSION
		stb		OBJ_TYPE,x		
		ldb		#0
		stb		OBJ_TYPESUB,x	
		ldb		#0
		stb		OBJ_MOVE,x			
		ldb	    #13 ; up to top ... 
		stb		OBJ_HITS,x
		; 1/1 - shoot
		;ldb		#0
		;stb		1,x
not_explosion:
; rest enemies
		ldb 	sprites_for_var
		cmpb	#6
		blt		no_enemy		
		ldb	    #0 ; status ... 
		stb		OBJ_STATE,x
		ldb		#3
		stb		OBJ_TYPE,x
		ldb		#0
		stb		OBJ_TYPESUB,x
		;ldb		#10
		;stb		1,x
		ldb	    #2 ; left ... 
		stb		OBJ_MOVE,x
		ldb		#2
		stb		OBJ_HITS,x
no_enemy:		
		; /code
		puls 	x ; restore x
		; +12 bytes
  		leax	12,x
		; lda sprites_for_var,x
		inc 	sprites_for_var
		ldb		sprites_for_var
		cmpb	#18 ; 12-1!!
		beq 	no_sprites_reset   
		jmp 	sprites_reset      
no_sprites_reset:

		; define some examples
		lda		#ENEMY_SINUS
		sta		spritesyx+72+12*0+OBJ_TYPESUB
		lda		#ENEMY_PINGPONG
		sta		spritesyx+72+12*1+OBJ_TYPESUB
		lda		#ENEMY_DOWN
		sta		spritesyx+72+12*2+OBJ_TYPESUB
		lda		#ENEMY_FASTDOWN
		sta		spritesyx+72+12*3+OBJ_TYPESUB
		lda		#5
		sta		spritesyx+72+12*4+OBJ_TYPESUB

; reset
		ldx		#level_segment
		lda		#0
		sta		,x
		ldx		#level_segment_offset
		lda		#18
		sta		,x
		sta		scrolling_flag
		sta		spawn_flag

; reset level (display)
		ldx		#rendered_level
    	lda		#2
    	sta		,x
    	lda		#10
    	sta		1,x
    	sta		2,x
    	lda		#20
    	sta		3,x
    	sta		4,x
    	    	
    	; handmade 

; set up player
		lda 	#1
		sta		spritesyx+OBJ_STATE		
		lda 	#0
		sta		spritesyx+OBJ_TYPE		

; reset score
		lda		#120
		sta 	str_score
		lda		#0
		sta 	str_score+1	
		lda		#48
		sta 	str_score+2
		lda		#48
		sta 	str_score+3
		lda		#48
		sta 	str_score+4
		lda		#32
		sta 	str_score+5
		lda		#48+3
		sta 	str_score+6		
		lda		$80
		sta 	str_score+7

; button
		lda		#0
		sta		button_up		
		lda		#90
		sta		button_upcounter				

; init music
  		lda     #1                      ; one means, we are about to
        sta     Vec_Music_Flag          ; store it in appropriate RAM
	 	lda		#EFFECT_TITLE
		sta 	soundeffect	 
		      
; init joysticks etc
		lda		#1                      ; these set up the joystick
        sta		Vec_Joy_Mux_1_X         ; enquiries
        lda     #3                      ; allowing only all directions
        sta     Vec_Joy_Mux_1_Y         ; for joystick one
        lda     #0                      ; this setting up saves a few
        sta     Vec_Joy_Mux_2_X         ; hundred cycles
        sta     Vec_Joy_Mux_2_Y         ; don't miss it, if you don't
                                                ; need the second joystick!
                                                
; sndeffects
		ldd #$0000 					; init sfx vars
		std	sfx_pointer
		sta sfx_status
	                                               
;***************************************************************************
; MAINLOOP
;***************************************************************************
; here the cartridge program starts off

main:

		; debug: 0
		; lda		#0
		; sta		debug_value
		
;***************************************************************************
; INGAME: SOUNDEFFECTS
;***************************************************************************

;
; sound/music effect system 
;
; musixs & effects
; music1: standard short bling
; music2: some jap. sound
; music3: "marschmusik"
; music4: t�t�tt�tt�t�t
; music5: d�dod�d�
; music6: d�lololo�l� 
; music7: midage
; music8: positive some notes(short)
; music9: tatarutataturuta
; musica: dito
; musicb: bad end sound (short)
; musicc: positve short notes (short)
; musicd: tttttt��t
;

; waiting sound effects (only ingame!)
; do only these soundeffects ingame
; soundeffect
; 		1: title
; 		2: menu
;		3: game
;		4: gameover
;		5: explosion
;		6: hit
;		7: shoot
;   	8: die
;   	9: next
; play soundeffects       
		
		lda		soundeffect
		cmpa	#0
		lbeq		no_soundeffect
		; default sound effect 
; music
EFFECT_TITLE  equ 1	
		lda		soundeffect
		cmpa	#EFFECT_TITLE
		bne		no_music_title

;		version 1 (as music notes)
;		jsr     DP_to_C8                ; DP to RAM
;		ldu     #music3                 ; get some music, here music1
;        jsr     Init_Music_chk          ; and init new notes		

        jmp		music_start_now
no_music_title:

; music menu
EFFECT_MENU  equ 2	
		lda		soundeffect
		cmpa	#EFFECT_MENU
		bne		no_music_menu

;		version 1 (as music notes)

		jsr     DP_to_C8                ; DP to RAM
		ldu     #music8                 ; get some music, here music1
;        ldu     #music_title                 ; get some music, here music1
        jsr     Init_Music_chk          ; and init new notes		


        jmp		music_start_now
no_music_menu:
; music game
EFFECT_GAME  equ 3	
		lda		soundeffect
		cmpa	#EFFECT_GAME
		bne		no_music_game
;		version 1 (as music notes)
;		jsr     DP_to_C8                ; DP to RAM
;       ldu     #music8                 ; get some music, here music1
;       jsr     Init_Music_chk          ; and init new notes		

        jmp		music_start_now
no_music_game:
; music gameover
		lda		soundeffect
EFFECT_GAMEOVER  equ 4		
		cmpa	#EFFECT_GAMEOVER
		bne		no_music_gameover
		
;		version 1 (as music notes)
;		jsr     DP_to_C8                ; DP to RAM
;       ldu     #musicb                 ; get some music, here music1
;       jsr     Init_Music_chk          ; and init new notes		

;		version 2
	    ldx 	#sfx4					; play
		stx 	sfx_pointer
		lda 	#$01
		sta 	sfx_status 

        jmp		music_start_now
no_music_gameover:
; music bonbon
EFFECT_EXPLOSION	equ	5
		lda		soundeffect
		cmpa	#EFFECT_EXPLOSION
		bne		no_music_explosion
;		version 1 (as music notes)
;		jsr     DP_to_C8                ; DP to RAM
;       ldu     #music_explosion                 ; get some music, here music1
;      ldu		#death_sound
;      jsr     Init_Music_chk          ; and init new notes		

;		version 2
	    ldx 	#sfx1					; play
		stx 	sfx_pointer
		lda 	#$01
		sta 	sfx_status 

        jmp		music_start_now
no_music_explosion:

; music bonbon
EFFECT_HIT		equ	6
		lda		soundeffect
		cmpa	#EFFECT_HIT
		bne		no_music_hit
;		version 1 (as music notes)
;		jsr     DP_to_C8                ; DP to RAM
;       ldu     #music_explosion                 ; get some music, here music1
;      ldu		#death_sound
;      jsr     Init_Music_chk          ; and init new notes		

;		version 2
	    ldx 	#sfx2					; play
		stx 	sfx_pointer
		lda 	#$01
		sta 	sfx_status 

        jmp		music_start_now
no_music_hit:

; music shoot
EFFECT_SHOOT	equ	7
		lda		soundeffect
		cmpa	#EFFECT_SHOOT
		bne		no_music_shoot

;		version 1 (as music notes)
;		jsr     DP_to_C8                ; DP to RAM
;        ldu     #music_shoot                 ; get some music, here music1
;        jsr     Init_Music_chk          ; and init new notes		

; 		version 2
	    ldx 	#sfx4					; play
		stx 	sfx_pointer
		lda 	#$01
		sta 	sfx_status 

        jmp		music_start_now 
no_music_shoot:

; music bonbon
EFFECT_DIE	equ	8
		lda		soundeffect
		cmpa	#EFFECT_DIE
		bne		no_music_die
		
;		version 1 (as music notes)
;		jsr     DP_to_C8                ; DP to RAM
;       ldu     #music_die                 ; get some music, here music1
;      jsr     Init_Music_chk          ; and init new notes		

;		version 2
	    ldx 	#sfx2					; play
		stx 	sfx_pointer
		lda 	#$01
		sta 	sfx_status 


        jmp		music_start_now
no_music_die:


; levelup / new text
EFFECT_NEXT	equ	9
		lda		soundeffect
		cmpa	#EFFECT_NEXT
		bne		no_music_levelup
;		version 1 (as music notes)
;		jsr     DP_to_C8                ; DP to RAM
;       ldu     #music8                 ; get some music, here music1
;       jsr     Init_Music_chk          ; and init new notes		

;		version 2
	    ldx 	#sfx2					; play
		stx 	sfx_pointer
		lda 	#$01
		sta 	sfx_status 

        jmp		music_start_now
no_music_levelup:

; 		restart
music_start_now:
		lda		#0
		sta 	soundeffect
no_soundeffect:		

; todo: more complex 
; is a routine playing? doit



;***************************************************************************
; INGAME: WAIT FOR RECAL
;***************************************************************************

; wait recal ..
        jsr     Wait_Recal              ; Vectrex BIOS recalibration
        jsr     Intensity_3F            ; Sets the intensity of the
                                        ; vector beam to $5f
        jsr     Delay_3                 ; delay for 30 cycles
; scale
        lda     #127                     ; load 50
        lda     #135                     ; load 50
        ;lda     #155                     ; load 50
        ;lda     #160                     ; load 50
        sta     VIA_t1_cnt_lo           ; 50 as scaling

;***************************************************************************
; INGAME: PLAYER CONTROL JOYSTICK (DIRECTIONS & BUTTONS)
;***************************************************************************

; player control / buttons
	jsr     Read_Btns               ; get button status
    lda     Vec_Btn_State           ; get the current state of all
    cmpa    #$00                    ; is a button pressed?
    lbeq     no_buttons_pressed               ; no, than go on
    ; button down
    ldb		button_up
    cmpb	#0
    lbne		buttons_pressed_done                                            
; start game
    ;ldu     #string_joystick_right      
    ;jsr     Print_Str_yx 	
    ldb		state
    cmpb	#0
    lbne		press_state_menu
    ; menu
	lda		#STATE_INGAME
	sta		state
	; message
	lda	 	 #13
	sta		 message_counter	
	lda	 	 #0
	sta 	 message_index
	; start game
	lda		#3
	sta		lifes
	lda      #12 ; 12
    sta      spritesnr
	; shield
	lda		#0
	sta		shield
	; border
	lda		#1 ; border
	sta 	fbackground
	; level
	lda      #0
    sta      level
    lda      #0
	sta		score
	lda		#1
	sta		button_up
	lda		#48
; really start the game now ... 	
	sta      str_score+2	
	sta      str_score+3	
	sta      str_score+4	
	; play music (set flag to wait for music)
   	lda     #1                      ; one means, we are about to
    sta     Vec_Music_Flag          ; store it in appropriate RAM               	
	lda		#EFFECT_TITLE
	sta 	soundeffect	
	; move demo sprites
    lda      #-70
    sta 	spritesyx+OBJ_Y
    lda      #0
    sta 	spritesyx+OBJ_X
	; offsets
; reset
	ldx		#level_segment
	lda		#2
	sta		,x
	lda		#1
	ldx		#level_segment_offset
	lda		#0
	sta		,x	
	; level
	lda		#0
	sta		level
	lda		#0
	sta		counter_ms	
	sta		counter_sec
	sta		counter_min	
	sta 	bigbossReleased
	sta		bigbossDefeated
	; button_upcounter
	lda		#80
	sta		button_upcounter	
	; update ...
		lda		#1
		sta		PLAYERY+OBJ_STATE
; clear all
		pshs 	x
		lda	#11
		sta 	sprites_for_var   ;variable with a value of 5
		ldx 	#spritesyx
		leax	12,x ; 6*12 (player + 4 x shoot + explosion)
sprites_mechanics_find_clearall:           ;This is the label at the start of the loop
		lda		#0
		sta		OBJ_STATE,x
		leax	12,x
		dec sprites_for_var   ;Subtract the loop_variable by 1
		bne sprites_mechanics_find_clearall      ;If the loop variable is not Zero, jump to loop_start
		puls 	x		
; / clear all	
	
	
    jmp		buttons_pressed_done	
press_state_menu:
; ingame shoot
; shoot!
	ldb		state
    cmpb	#STATE_INGAME 
    bne		no_ingame_button
; find the first free shoot
	lda	spritesnr
	sta sprites_for_var   ;variable with a value of 5
	ldx #spritesyx
sprites_mechanics_findshootx:           ;This is the label at the start of the loop
	pshs    x ; store x 
; code
; not active
	lda		2,x
	cmpa	#0
	bne		active_notinteresting				
	; find shoot!
	lda		3,x
	cmpa	#1
	bne 	active_notinteresting
	; activate!
	lda		#1
	sta		2,x
	; shootx=playerx
	lda		spritesyx
	adda	#8
	sta		,x
	lda		spritesyx+1
	;suba	10
	sta		1,x
	; param range
	lda		#20 ; ...
	sta		OBJ_PARAM,x	
	lda		#0
	sta		OBJ_PARAMEXT,x	
	; break the for
	puls 	x ; restore x
	lda		#1
	sta		button_up
	
		; play shoot now!!
	   	lda     #1                      ; one means, we are about to
	    sta     Vec_Music_Flag          ; store it in appropriate RAM               	
		lda		#EFFECT_SHOOT
		sta 	soundeffect	

	
	jmp		buttons_pressed_done	
active_notinteresting:
; /code
	puls 	x ; restore x
	leax	12,x
	; for
	dec sprites_for_var   ;Subtract the loop_variable by 1
	bne sprites_mechanics_findshootx      ;If the loop variable is not Zero, jump to loop_start
; / find




	lda		#1
	sta		button_up
	jmp		buttons_pressed_done	
no_ingame_button	
; gameover > menu
    ldb		state
 	cmpb	#STATE_GAMEOVER
    bne		press_state_gameover
; 	lda		#0
;	sta		button_up
    ; shield ok?
    lda		button_upcounter
 	cmpa	#2
 	blt		buttons_pressed_done_on 
	jmp 	buttons_pressed_done
buttons_pressed_done_on 	  
    ; menu
	lda		#STATE_MENU
	sta		state
	lda		#1
	sta		button_up	
press_state_gameover:

; gamewon > menu
    ldb		state
 	cmpb	#STATE_WON
    bne		press_state_won
; 	lda		#0
;	sta		button_up
    ; shield ok?
    lda		button_upcounter
 	cmpa	#2
 	blt		buttons_pressed_done_on_won 
	jmp 	buttons_pressed_done
buttons_pressed_done_on_won 	  
    ; menu
	lda		#STATE_MENU
	sta		state
	lda		#1
	sta		button_up	
press_state_won:


	jmp 	buttons_pressed_done
no_buttons_pressed:
	lda		#0
	sta		button_up				
buttons_pressed_done:
				
; player control / joystick
; movement x
		ldb		state
	    cmpb	#STATE_INGAME  
	    lbne		joystick_done
		; sprites
        lda		#0
        sta spritesmove
		; joystick stuff
        jsr 	Joy_Digital
  		lda     Vec_Joy_1_X 
		beq     no_x_movement 
        bmi     left_move               ; if negative, than left
right_move:
		inc 	spritesyx+1
		inc 	spritesyx+1
		inc 	spritesyx+1
		lda		spritesyx+1
		cmpa	#100
		blt		bigger_than_right
		lda		#100
		sta		spritesyx+1
bigger_than_right		
        bra     no_x_movement                  ; goto x done
left_move:
		dec 	spritesyx+1
		dec 	spritesyx+1
		dec 	spritesyx+1
		lda		spritesyx+1
		cmpa	#-105
		bgt		lower_than_left
		lda		#-105
		sta		spritesyx+1
lower_than_left		
        bra     no_x_movement                  ; goto x done        
no_x_movement
; movement y
		lda     Vec_Joy_1_Y             ; load joystick 1 position
        beq     no_y_movement           ; if zero, than no y position
        bmi     down_move               ; if negative, than down
up_move:
		inc 	spritesyx
		inc 	spritesyx
		lda		spritesyx
		cmpa	#120
		blt		bigger_than_up
		lda		#120
		sta		spritesyx
bigger_than_up	
        bra     no_y_movement                  ; goto y done
down_move:
		dec 	spritesyx
		dec 	spritesyx
		lda		spritesyx
		cmpa	#-90
		bgt		lower_than_down
		lda		#-90
		sta		spritesyx
lower_than_down		                                                       ; otherwise up
        bra     no_y_movement                  ; goto y done
no_y_movement:

joystick_done:

;***************************************************************************
; INGAME: DISPLAY TOP
;***************************************************************************

		ldb		state
		; GAME OVER
    	cmpb	#STATE_GAMEOVER
    	lbeq	display_sprites		
		; GAME WON
    	cmpb	#STATE_WON
    	lbeq	display_sprites		
    	; INGAME
    	cmpb	#STATE_INGAME 
    	lbne	no_display_top
display_sprites

;***************************************************************************
; INGAME: DISPLAY SPRITES
;***************************************************************************
		; jmp 	no_sprites_display
		; anim
		ldx		#spritesyx
		lda spritesnr
		sta sprites_for_var   ;variable with a value of 5
		ldx #spritesyx
		ldu	#spritesyx
sprites_display:           ;This is the label at the start of the loop
		pshs    x ; store x 		
; active?
		lda		OBJ_STATE,x
		cmpa	#0
		lbeq		sprites_display_next				
; code

		; for display: move enemy boss  
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_BOSS
		lbeq	render_boss	
		; default
		lda		OBJ_Y,x ; y-pos
		ldb		OBJ_X,x ; x-pos
		jmp		render_no_boss		
render_boss
		lda		OBJ_Y,x ; y-pos
		ldb		OBJ_X,x ; x-pos
		suba	#0
		subb	#12		
render_no_boss:		
		
		; OFFSET?
		jsr     Moveto_d           
		;ldx     #grafix_player ; default grafixs 
		; store x was changed!
		puls	x	
		pshs    x 
		; restore x 
		; the types
		ldb		OBJ_TYPE,x
		; type: player / shoot

; player
		cmpb	#OBJ_TYPE_PLAYER
		bne		no_player_display
		; version 1.0
		ldx     #grafix_player ; default grafixs 
		; start game
		lda		shield
		cmpa	#0
		beq		no_shield_atthemoment
		ldx     #grafix_player_shield		
no_shield_atthemoment		
		jmp		no_enemy_display				
no_player_display:
	
; explosion
		cmpb	#SPRITE_EXPLOSION
		bne		no_sprite_display
		; version 1.0
		ldx     #grafix_explosion ; default grafixs 
		jmp		no_enemy_display				
no_sprite_display:	
; shoot
; debug
		jmp 	no_shoot_display
		cmpb	#OBJ_TYPE_SHOOT
		bne		no_shoot_display
		; version 1.0
;		ldx     #grafix_shoot ; default grafixs 				
		ldx     #grafix_shoot_laser ; default grafixs 				
		; only dottes
		lda		,x
		ldb		1,x
		jsr		Dot_d
		jmp		sprites_display_next						
no_shoot_display:
; shoot
;		ldx     #grafix_shoot 
		ldx		#grafix_shoot_laser
	
; type: enemy	   
		ldb		OBJ_TYPE,u
		cmpb	#OBJ_TYPE_ENEMY
		lbne		no_enemy_display
; ENEMY_SHOOT
		ldb		OBJ_TYPESUB,u	
		cmpb	#ENEMY_SHOOT
		bne		no_enemy_shoot
		ldx     #grafix_enemy_shoot ;		
		jmp		subtype_done		
no_enemy_shoot: 
; ENEMY_DOWN
		ldb		OBJ_TYPESUB,u	
		cmpb	#ENEMY_DOWN
		bne		no_enemy_down
		ldx     #grafix_enemy_down ;		
		jmp		subtype_done		
no_enemy_down:
; ENEMY_DOWN_FAST
		ldb		OBJ_TYPESUB,u	
		cmpb	#ENEMY_FASTDOWN
		bne		no_enemy_fastdown
		ldx     #grafix_fastdownenemy ;		
		jmp		subtype_done		
no_enemy_fastdown:
; ENEMY_DOWNSEARCH
		ldb		OBJ_TYPESUB,u	
		cmpb	#ENEMY_DOWNSEARCH
		bne		no_enemy_downsearch
		ldx     #grafix_downsearch ;		
		jmp		subtype_done		
no_enemy_downsearch:
; ENEMY_MISSILE
		ldb		OBJ_TYPESUB,u	
		cmpb	#ENEMY_MISSILE
		bne		no_enemy_missile
		ldx     #grafix_enemymissile ;		
		jmp		subtype_done		
no_enemy_missile:
; ENEMY_BOSS = ENDBOSS
		ldb		OBJ_TYPESUB,u	
		cmpb	#ENEMY_BOSS ; ENDBOSS
		bne		no_enemy_boss
		ldx     #grafix_enemyboss ;		
		jmp		subtype_done		
no_enemy_boss:

; ENEMY_LEFT
		ldb		OBJ_TYPESUB,u	
		cmpb	#ENEMY_LEFT
		bne		no_enemy_left
		ldx     #grafix_enemyleftright ;		
		jmp		subtype_done		
no_enemy_left
; ENEMY_RIGHT
		ldb		OBJ_TYPESUB,u	
		cmpb	#ENEMY_RIGHT
		bne		no_enemy_right
		ldx     #grafix_enemyleftright ;		
		jmp		subtype_done		
no_enemy_right

; ENEMY_SINUS
		lda		OBJ_TYPESUB,u	
		cmpa	#ENEMY_SINUS
		bne		no_ENEMY_SINUS
		ldx     #grafix_enemy_sin ;		
		jmp		subtype_done		
no_ENEMY_SINUS:

; ENEMY_DIAG
		lda		OBJ_TYPESUB,u	
		cmpa	#ENEMY_DIAG
		bne		no_ENEMY_DIAG 
		ldx     #grafix_enemydiag ;		
		jmp		subtype_done		
no_ENEMY_DIAG:



; ENEMY_STAY
		lda		OBJ_TYPESUB,u	
		cmpa	#ENEMY_STAY
		bne		no_ENEMY_STAY
		ldx     #grafix_enemy_stay ;		
		jmp		subtype_done		
no_ENEMY_STAY:

; ENEMY_STAYSHOOT
		lda		OBJ_TYPESUB,u	
		cmpa	#ENEMY_STAYSHOOT
		bne		no_ENEMY_STAYSHOOT
		ldx     #grafix_enemy_stayshoot ;		
		jmp		subtype_done		
no_ENEMY_STAYSHOOT:

; ENEMY_PINGPONG
		lda		OBJ_TYPESUB,u	
		cmpa	#ENEMY_PINGPONG
		bne		no_ENEMY_PINGPONG
		ldx     #grafix_enemy_ship ;
		lda		#66
		sta		debug_value				
		jmp		subtype_done		
no_ENEMY_PINGPONG:

		; default
		
		lda		#55
		lda		OBJ_TYPESUB,u
		sta		debug_value	
		
		
		ldx		#grafix_enemy_sin
					
		; add the anims!
subtype_done:
					
no_enemy_display:		   
		; draw it now

	;***************************************************************************
	; INGAME: DISPLAY SPRITES ANIM SPRITES
	;***************************************************************************
		; jmp 	no_animations
		; anim now?
		; leax	9,x
; anim 0 default
; anim 1		
		lda		OBJ_ANIM,u
		cmpa	#1
		bne 	no_anim_1
		leax	27,x
no_anim_1:		
; anim 2		
		lda		OBJ_ANIM,u
		cmpa	#2
		bne 	no_anim_2
		leax	18,x
no_anim_2:	
; anim 3		
		lda		OBJ_ANIM,u
		cmpa	#3
		bne 	no_anim_3
		leax	9,x
no_anim_3:	
; anim 4		
		lda		OBJ_ANIM,u
		cmpa	#4
		bne 	no_anim_4
		leax	0,x
no_anim_4:	
no_animations:
		; version 1.0
        jsr     Draw_VLc  
		; jump back to zero/zero
		; jsr 	Reset0Ref  ; reset to 0,0  
		; /code	
sprites_display_next:
		jsr		Reset0Ref
		; puls
		puls 	x ; restore x
		leax	12,x
		leau	12,u
		dec sprites_for_var   ;Subtract the loop_variable by 1
		bne sprites_display      ;If the loop variable is not Zero, jump to loop_start
no_sprites_display:

;***************************************************************************
; INGAME: DISPLAY BACKGROUNDS
;***************************************************************************
		; jmp 	no_background_renderings_here
		; jmp 	no_background_rendering
		lda		fbackground
		cmpa	#1
		lbne	no_background_renderings_here

		lda		#0	; y
		ldb		#0 	; x
		sta		level_positiony
		stb		level_positionx			
		stb		level_positionxx			
		; ------------------------
		lda		#0
		sta		sprites_tmp_type
		sta		sprites_tmp_move

		; prepare the level
		ldu 	#leveldata
		; add level_segment
		lda		level_segment
		deca
		cmpa	#0
		blt		no_count_segments
		inca
count_segments:

; counting up levelsegements / scrolling up
; index counting down
; version 1
		; temp coord.
		jmp 	version1
		ldb		,u
		stb		sprites_tmp_type
		ldb		1,u
		stb		sprites_tmp_move
		leau	STRIPE_SIZE,u
		deca
version1:

; version 2
		; temp coord.
		;jmp 	version2		
		; <7
		cmpa	#10
		bgt		multi_step
		cmpa	#30
		bgt		multi_big_step
					
; --1
single_step:
		ldb		,u
		stb		sprites_tmp_type
		ldb		1,u
		stb		sprites_tmp_move
		leau	STRIPE_SIZE,u
		; --a
		deca
		jmp		steps_done		
; --10
multi_step:
		leau	STRIPE_SIZE*9,u
		;  a = a - 5
		suba	#9
		jmp 	steps_done
; --30
multi_big_step:
		leau	STRIPE_SIZE*30,u
		;  a = a - 5
		suba	#29		
steps_done:		
version2:
		
		; count segments
		cmpa	#0
		bne		count_segments
		
no_count_segments:
		; ------------------------
		; 		render
		ldx 	#rendered_level
		ldy 	#rendered_level_right
		; db length
		lda 	#STRIPES_AMOUNT+1 ; number points
		sta 	,x
		sta 	,y
		leax	1,x		 
		leay	1,y		
		; add first = it is the last 
		; point 1 > 
		; 2. point > ...
		lda		#0		
		sta		,x		 
		sta		,y		 		
		lda		sprites_tmp_type		
		sta		1,x		 		
		sta		level_positionx
		lda		sprites_tmp_move		
		sta		1,y		 		
		sta		level_positionxx

		; for (i=0;i<..
		lda 	#15
		sta		sprites_for_var
		lda		#0
level_for:
		; rom-table: y,x1,x2,e,e1
		; y,x1

; ----------------------------
; stripe size
; ----------------------------
		lda		#STRIPES_SIZE
; -------------------------		
; sphere simulation
; -------------------------		
		jmp		no_sphere_simulation
		;
		; smaller on top > sphere simulation
; sphere simulation (fake)
		ldb		sprites_for_var
; \_	
		cmpb	#STRIPES_SIZE
		bne		simulation_sphere_01
		lda		#14				
simulation_sphere_01:
		cmpb	#STRIPES_SIZE-1
		bne		simulation_sphere_02
		lda		#23				
simulation_sphere_02:
		cmpb	#STRIPES_SIZE-2
		bne		simulation_sphere_03
		lda		#18				
simulation_sphere_03:
; ----		
; _/
		jmp		simulation_sphere_2
		cmpb	#8
		bgt		simulation_sphere_0
		lda		#16	
simulation_sphere_0:
		cmpb	#5
		bgt		simulation_sphere_1
		lda		#4		
simulation_sphere_1:
		cmpb	#2
		bgt		simulation_sphere_2
		lda		#2		
simulation_sphere_2:			

no_sphere_simulation:
; / ------------------------
; / sphere simulation
; / -------------------------
		; debug
		; lda		#10

		sta		,x
		sta		,y
		
		; relative x
		ldb		,u		
		subb	level_positionx
		stb		1,x		
		ldb		,u
		stb		level_positionx				
		; relative xx
		ldb		1,u		
		subb	level_positionxx
		stb		1,y		
		ldb		1,u
		stb		level_positionxx
		; add 5 ...
		leau	STRIPE_SIZE,u		
		leax	2,x		
		leay	2,y		
		; for_
		dec		sprites_for_var
		bne		level_for	
		

no_background_rendering:
		
; display
        jsr     Intensity_3F 
		jsr 	Reset0Ref  ; reset to 0,0 		              
		lda		#-107 ;
		suba	level_segment_offset
		ldb		#0 ; 
		; version 2.0
		ldb		sprites_tmp_type
		; patch
		jsr     Moveto_d    
        jsr     Delay_3 
		ldx		#rendered_level
		jsr     Draw_VLc  
		jsr 	Reset0Ref  ; reset to 0,0 		
		; jump back to zero/zero
			
			; shadow
			jmp		no_shadow1
			jsr     Intensity_1F
			lda     #140                     ; load 50
        	sta     VIA_t1_cnt_lo           ; 50 as scaling
			lda		#-105 ;
			suba	level_segment_offset
			; version 2.0
			ldb		sprites_tmp_type
			subb	#3 
			; version 1.0 offset
			ldb		#-3 ; 			jsr     Moveto_d    
			jsr     Moveto_d    
;        	jsr     Delay_3 
			ldx		#rendered_level
			jsr     Draw_VLc  
			jsr 	Reset0Ref  ; reset to 0,0 
			lda     #127                     ; load 50
        	sta     VIA_t1_cnt_lo           ; 50 as scaling
			jsr     Intensity_3F
			; jump back to zero/zero			
no_shadow1:


			; shadow
			; jmp		no_shadow2
			jsr     Intensity_1F
			lda     #140                     ; load 50
        	sta     VIA_t1_cnt_lo           ; 50 as scaling
			lda		#-107 ;
			suba	level_segment_offset
			ldb		#0 
			; 			jsr     Moveto_d    
			; version 1.0
			ldb		#0
			; version 2.0
			ldb		sprites_tmp_move
			subb	#3 		
			jsr     Moveto_d    
;        	jsr     Delay_3 
			ldx		#rendered_level_right
			jsr     Draw_VLc  
			jsr 	Reset0Ref  ; reset to 0,0 
			lda     #156                     ; load 50
        	sta     VIA_t1_cnt_lo           ; 50 as scaling
			jsr     Intensity_3F
			; jump back to zero/zero			
no_shadow2:


		lda		#-107 ; y + 110
		suba	level_segment_offset
		; version 1.0
		ldb		#0
		; version 2.0
		ldb		sprites_tmp_move
		; subb	#3 		
		jsr     Moveto_d    
        jsr     Delay_3 
		; draw it now
		ldx		#rendered_level_right
        jsr     Draw_VLc
		jsr 	Reset0Ref  ; reset to 0,0 		
		; jump back to zero/zero




        jsr     Intensity_3F       

no_background_renderings_here:	


no_display_top:

;***************************************************************************
; GAMEOVER: COUNT DOWN PRESSED
;***************************************************************************
		ldb		state
;		cmpb	#STATE_GAMEOVER
;    	lbeq	not_state_gameover		
    	dec		button_upcounter 
    	ldb		button_upcounter
    	;stb		score
    	cmpb	#1
    	bgt		not_state_gameover
    	ldb		#1
    	stb		button_upcounter
not_state_gameover

;***************************************************************************
; INGAME: MECHANICS MOVE SPRITES
;***************************************************************************

;***************************************************************************
; INGAME: INGAME MECHANICS
;***************************************************************************
; colissions mechanics only ingame
		lda		state
		cmpa	#STATE_INGAME
		lbne	mechanics_done
		; level management
		; add counter for 
		
		; check for amount of sprites
		ldb		#12
		lda		fbackground
		cmpa	#0
		bne		no_other_spriteamount
		ldb		#20
no_other_spriteamount:
		stb		spritesnr

		; flags
		lda		#0
		sta		scrolling_flag   	; scroll flag = 0
		sta 	spawn_flag			; spawn flag = 0
		sta		anim_flag			; anim flag = 0
		
;***************************************************************************
; INGAME: LEVELUP? WAIT
;***************************************************************************
; counter_ms
		
		inc		counter_ms	
		lda		counter_ms
		cmpa	#3
		blt	no_counter_activity
		lda		#0
		sta		counter_ms
; counter_sec		
		inc 	counter_sec
		; scroll_flag
		lda		#1
		sta		scrolling_flag
		sta		anim_flag
		lda		bigbossReleased
		cmpa	#1
		beq		no_stepforward
		; more level updates
		inc		level_segment_offset
;		inc		level_segment_offset
no_stepforward:		
		;	message counter 
		lda		message_counter
		cmpa	#0
		beq		no_message_counter	
		dec 	message_counter 
no_message_counter:		

		; levelsegments
		lda		level_segment_offset
		cmpa	#STRIPES_SIZE
		blt		no_new_segment
		lda		#0
		sta		level_segment_offset
		; new segment
		inc		level_segment
		; release_flag
		lda		#1
		sta 	spawn_flag
		; check new objects!!!
no_new_segment:
		
		lda		counter_sec
		cmpa	#4
		blt	no_counter_activity
		lda		#0
		sta		counter_sec
; counter_min
;		inc 	counter_min
;		lda		counter_min
;		cmpa	#120
;		blt	no_counter_activity
; level
no_counter_activity:

		; debug
		; lda		spawn_flag
		; sta		debug_value

;***************************************************************************
; INGAME: SPAWN OBJECTS
;***************************************************************************
; release objects
		; jmp 	no_spawning
; spawn_flag

		; shield
		lda		anim_flag
		cmpa	#1
		lbne	no_shield_x	
		lda		shield
		cmpa	#0
		beq		no_shield_x
		dec 	shield
no_shield_x

; spawn flag
		lda		spawn_flag
		cmpa	#1
		lbne		no_spawning				
		; let's spawn here ...
		; go five strikes up
		ldu 	#leveldata
		; debug		
		;jmp		count_segments_tmp_spawn
		; add level_segment
		lda		level_segment
		cmpa	#0
		beq		count_segments_tmp_spawn 
		inca
count_segments_tmp_spawnxx:
		leau	STRIPE_SIZE,u
		deca
		cmpa	#0
		bne		count_segments_tmp_spawnxx		
		; do now the the spawnings!		
count_segments_tmp_spawn:
		; add 9 x ----
		leau	STRIPES_SPAWNAT*STRIPE_SIZE,u ; 10 x 8 (10 stripes) 
		; > change coordinates
		; temp coord.
		; create spawns etc now!
		lda		STRIPE_TYPE,u ; new enemy in the level table?
		cmpa	#0
		lbeq		no_enemy_to_spawn; active_notinterestingxx
		; debug 
		;ldb		3,u
		;stb		debug_value
; specials ----------------------------
; message
		cmpa	#OBJ_TYPE_MESSAGE ; status 0!!!
		bne     no_messages
		inc		level
		lda		#15
		sta		message_counter
		; lda		#2 ; MESSAGE
		; sta		message_index
		lda		message_index
		inc		message_index

		; play sound 
;	   	lda     #1                      ; one means, we are about to
;	    sta     Vec_Music_Flag          ; store it in appropriate RAM               	
		lda		#EFFECT_NEXT
		sta 	soundeffect	

		; add 21 bytes
		jmp		no_enemy_to_spawn
no_messages:
; won - a special stripe action 
		cmpa	#OBJ_TYPE_WON ; status 0!!!
		bne     no_won
		
		lda		#STATE_WON
		sta		state
		
		;sta		score
		; sta ...
		lda		#70
		sta		button_upcounter	

		jmp		no_enemy_to_spawn
no_won:

; background
; hide back
		cmpa	#OBJ_TYPE_HIDEBACK ; status 0!!!
		bne     no_hide
		lda		#0
		sta		fbackground		 
		jmp		no_enemy_to_spawn
no_hide:
; background
; show back
		cmpa	#OBJ_TYPE_SHOWBACK ; status 0!!!
		bne     no_show
		lda		#1
		sta		fbackground		 
		jmp		no_enemy_to_spawn
no_show:


; new level
		cmpa	#OBJ_TYPE_NEWLEVEL ; status 0!!!
		bne     no_newlevel
		; clear sprites now ...

; clear all
		pshs 	x
		lda	#11
		sta 	sprites_for_var   ;variable with a value of 5
		ldx 	#spritesyx
		leax	12,x ; 6*12 (player + 4 x shoot + explosion)
sprites_mechanics_find_clear:           ;This is the label at the start of the loop
		lda		#0
		sta		OBJ_STATE,x
		leax	12,x
		dec sprites_for_var   ;Subtract the loop_variable by 1
		bne sprites_mechanics_find_clear      ;If the loop variable is not Zero, jump to loop_start
		puls 	x		
; / clear all
		
		jmp		no_enemy_to_spawn
		
no_newlevel:		
; end of game! won
;		cmpa	#OBJ_TYPE_WON ; status 0!!!
;		bne     no_end_ofgame
;		lda		#STATE_WON
;		sta		state	
		
;		sta		score
;		jmp		no_enemy_to_spawn	
;no_end_ofgame:		
		; enemies
		cmpa	#OBJ_TYPE_ENEMY ; status 0!!!
		beq     do_the_spawnings
		jmp		no_enemy_to_spawn
do_the_spawnings:
		; ++score
		; inc		score

		; SPAWN AMOUNT
		; 1-3 times? offset
		; STRIPE_ARG0
		; 0-3 ; show 
		
;		lda 	#2 ; ADD 1
		lda		STRIPE_ARG0,u
		adda	#1
		sta		spawn_more_counter
		lda		#0 ;
		sta		spawn_offset					
spawn_for:		
		
		; find the first object
		lda		#7
		sta 	sprites_for_var   ;variable with a value of 5
		ldx 	#spritesyx 
		leax	72,x ; 6*12 (player + 4 x shoot + explosion)
sprites_mechanics_findshootxx:           ;This is the label at the start of the loop
		pshs    x ; store x 
		; not active
		lda		OBJ_STATE,x
		cmpa	#0
		lbne	active_notinterestingxx				

		
		; [stripe]x,xx,[object]ot,ots,ox

		; ACTIVATE  !
		
		; status
		lda		#1
		sta		OBJ_STATE,x
		
		; Type
		lda		#3
		sta		OBJ_TYPE,x
		; TypeSub
		lda		STRIPE_TYPESUB,u
		lda		3,u
		; lda		#ENEMY_SINUS
		sta		OBJ_TYPESUB,x

		; default moving
		lda		#0
		sta		OBJ_MOVE,x
		
		; typesub: ...
		; sta		debug_value
		
		; Y
		lda		#113; -107+11*20 = 220-107
		; lda		#-107+(STRIPES_SPAWNAT+1)*STRIPE_SIZE
		; adda 	STRIPE_ARG1,u
		sta		OBJ_Y,x

		; Y (!=0)
		lda		STRIPE_RELEASEY,u ; STRIPE_RELEASEY
		cmpa	#0
		beq		no_release_aty
		
		adda 	STRIPE_ARG0,u
		sta		OBJ_Y,x
		; lda		#0
		; sta		OBJ_Y,x
		; add release here!
		; explosion ...
		
no_release_aty
		

		; X
		lda		STRIPE_RELEASEX,u
		; ADD OFFSET
		adda	spawn_offset					
		sta		OBJ_X,x

		; fill in the correct values
		; movement [6] >
		lda		#11
		sta		OBJ_MOVE,x

		; anim
		lda		#2
		lda 	spawn_more_counter
		sta		OBJ_ANIM,x
		
		; hits 2 hits!!!
		lda		#2
		sta		OBJ_HITS,x

		; PARAM ... 
		lda		#4
		sta		OBJ_PARAM,x	
		lda		#0
		sta		OBJ_PARAMEXT,x	
				
		; ------------------------------------
		; enemies! generate the correct prefs!!
		; ------------------------------------
		;
		;	0 - stands still (1x)
		;   1 - mine (1x)
		;   2 - bridge (10x)
		; 	35 - enemy shoot (never or 127x)
ENEMY_SHOOT EQU 35						
		;   10 - down (1x)
ENEMY_DOWN	EQU	10		
		;   11 - fast down (1x)
ENEMY_FASTDOWN	EQU	11
ENEMY_DOWNSEARCH EQU 16		
		; 	12 - up
ENEMY_BOSS	EQU	12 ; ENDBOSS
		;	13 - sinus!
ENEMY_SINUS	EQU	13

; diag
		;	16 - sinus!
ENEMY_DIAG	EQU	60

		;	20 - from left


; STAY
ENEMY_STAY	EQU	14
; SHOOT
ENEMY_STAYSHOOT	EQU	15

ENEMY_LEFT	EQU	20		
		;	21 - from right
ENEMY_RIGHT	EQU	21		
		; 	22 - pingpong
ENEMY_PINGPONG	EQU	22		
		; 
		; 	30 - shoot
		; 	31 - missile
		; 	32
		; 
		; 	22 - pingpong
ENEMY_MISSILE	EQU	31		

		
		; 	40 - CREATE A SPRITE
ENEMY_APPEAR	EQU 40
		
		; RESET PARAM
		lda		#2
		sta		OBJ_PARAM,x		
		
		; NO TEMPLATE
		; jmp 	no_template

; ENEMY_PINGPONG		
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_PINGPONG ; ENEMY_TYP1
		bne 	no_spawn_enemypingpong
		lda		#MOVE_LEFT_PINGPONG
		sta		OBJ_MOVE,x		
		; 10 hits!!!
		lda		#4
		sta		OBJ_HITS,x	
		jmp		template_done
no_spawn_enemypingpong:		

; ENEMY_SINUS
		;jmp		no_enemytyp_sinus_atall	
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_SINUS 
		bne 	no_spawn_enemysinus
		; settings ... 
		lda		#MOVE_SINUSSQUARE
		sta		OBJ_MOVE,x	
		; 10 hits!!!
		lda		#5
		sta		OBJ_HITS,x	
		jmp		template_done
no_spawn_enemysinus:

; ENEMY_DIAG
		;jmp		no_enemytyp_sinus_atall	
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_DIAG 
		bne 	no_spawn_enemydiag
		; settings ... 
		lda		#MOVE_DIAG
		sta		OBJ_MOVE,x	
		lda		#35
		sta 	OBJ_PARAM,x
		; 10 hits!!!
		lda		#4
		sta		OBJ_HITS,x	
		jmp		template_done
no_spawn_enemydiag:


; ENEMY_STAY
		;jmp		no_enemytyp_sinus_atall	
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_STAY 
		bne 	no_spawn_enemystay
		; settings ... 
		lda		#MOVE_STAY
		sta		OBJ_MOVE,x	
		; 10 hits!!!
		lda		#14
		sta		OBJ_HITS,x	
		jmp		template_done
no_spawn_enemystay:

; ENEMY_STAYSHOOT
		;jmp		no_enemytyp_sinus_atall	
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_STAYSHOOT 
		bne 	no_spawn_enemystayshoot
		; settings ... 
		lda		#0
		sta		OBJ_PARAM,x
		lda		#MOVE_STAY
		sta		OBJ_MOVE,x	
		; 10 hits!!!
		lda		#15
		sta		OBJ_HITS,x	
		jmp		template_done
no_spawn_enemystayshoot:



; ENEMY_DOWN
		;jmp		no_enemytyp_sinus	
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_DOWN 
		bne 	no_spawn_movedown
		; setting  s ... 
		lda		#MOVE_DOWN
		sta		OBJ_MOVE,x	
		; 10 hits!!!
		lda		#2
		sta		OBJ_HITS,x	
		jmp		template_done
no_spawn_movedown:
; ENEMY_FASTDOWN
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_FASTDOWN 
		bne 	no_spawn_movefastdown
		; setting  s ... 
		lda		#MOVE_FASTDOWN
		sta		OBJ_MOVE,x	
		; 10 hits!!!
		lda		#2
		sta		OBJ_HITS,x	
		jmp		template_done
no_spawn_movefastdown:
; ENEMY_DOWNSEARCH
		;jmp		no_enemytyp_sinus	
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_DOWNSEARCH 
		bne 	no_spawn_movedownsearch
		; setting  s ... 
		lda		#MOVE_DOWNSEARCH
		sta		OBJ_MOVE,x	
		; 10 hits!!!
		lda		#10
		sta		OBJ_HITS,x	
		jmp		template_done
no_spawn_movedownsearch:

; ENEMY_MISSILE
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_MISSILE 
		bne 	no_spawn_missile
		; setting  s ... 
		lda		#MOVE_MISSILE
		sta		OBJ_MOVE,x	
		lda		#2
		sta		OBJ_HITS,x	
		jmp		template_done
no_spawn_missile:


; ENEMY_BOSS ENDBOSS
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_BOSS  ; ENDBOSS
		bne 	no_spawn_moveup
		; setting  s ... 
		lda		#MOVE_BOSS
		sta		OBJ_MOVE,x	
		; 10 hits!!!
		lda		#40
		sta		OBJ_HITS,x	
		; behaviour to 0
		lda		#0
		sta		bigbossBehaviour
		; bigbossReleased
		lda		#1
		sta		bigbossReleased
		jmp		template_done
no_spawn_moveup:

; ENEMY_LEFT
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_LEFT 
		bne 	no_spawn_moveleft
		; setting  s ... 
		lda		#MOVE_LEFT
		sta		OBJ_MOVE,x	
		; 10 hits!!!
		lda		#1
		sta		OBJ_HITS,x	
		jmp		template_done
no_spawn_moveleft:
; ENEMY_RIGHT
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_RIGHT 
		bne 	no_spawn_moveright
		; setting  s ... 
		lda		#MOVE_RIGHT
		sta		OBJ_MOVE,x	
		; 10 hits!!!
		lda		#1
		sta		OBJ_HITS,x	
		jmp		template_done
no_spawn_moveright:


no_enemytyp_sinus_atall:
; 


template_done:


no_template: 

		; offset
		lda		spawn_offset	
		; adda	#15
		adda	#5
		adda	STRIPE_ARG1,u
		sta 	spawn_offset


; ;***************************************************************************

		
		; ...
		puls 	x ; restore x (alternative)
		jmp		spawn_next	
active_notinterestingxx:
		; /code
		puls 	x ; restore x (alternative)
		leax	12,x
		; for
		dec sprites_for_var   ;Subtract the loop_variable by 1
		bne sprites_mechanics_findshootxx      ;If the loop variable is not Zero, jump to loop_start
		; / find

spawn_next:

; /spawn_for		
		dec		spawn_more_counter	
		bne	spawn_for


no_enemy_to_spawn:		
		; / search new enemy !!!!!!!!!!!!!!!!!!!!!! 


no_count_segments_tmp_spawn:
no_spawning:


;***************************************************************************
; INGAME: INGAME MECHANICS SPRITES MOVEMENT
;***************************************************************************
; MOVE ETC

; MOVEMENTS OBJ[6]
;
;	0 player (controlled by controller)
;
;	ATTENTION: REAL MOVEMENT (here swaped!)
;           ^ -Y
;           | 
;           |
;   X-<---------->X+
;           |
;           |
;           \ +Y
;
; 	0 = stay
MOVE_STAY	EQU		0
;	1 < left (only)
;	2 > right (only)
MOVE_LEFT	EQU		1
MOVE_RIGHT	EQU		2
;	3 < left (ping pong) ; via param!
;	4 > right (ping pong) ; via param! 
MOVE_LEFT_PINGPONG	EQU		3
MOVE_RIGHT_PINGPONG	EQU		4
;
;	5 < left (ping pong down)
;	6 > right (ping pong down)
;	7 < left (ping pong up)
;	8 > right (ping pong down)
;
;	10  stay still *
;	11 down
MOVE_DOWN		EQU		11
MOVE_FASTDOWN		EQU		17
MOVE_DOWNSEARCH	EQU	18
;	12 up *
;   13 up (shoot ...) stops on top !!
MOVE_UPSHOOT	EQU 13
;   14 down with sinus! 
MOVE_SINUS		EQU		14
;   15 slow up
MOVE_UP		EQU		15
MOVE_SLOWUP		EQU		15
MOVE_BOSS EQU 19
; SQUARE
MOVE_SINUSSQUARE		EQU		31

MOVE_MISSILE		EQU		41

MOVE_DIAG	EQU  16
MOVE_DIAGINV	EQU  67

; up ... inv
MOVE_DIAGUP	EQU  68
MOVE_DIAGUPINV	EQU  69


;
;	20 follow player
;	21 follow player nearer than 50
;
;	30 .. 
;
;   * not yet implemented
;
		lda spritesnr
;		lda	#12
		sta sprites_for_var   ;variable with a value of 5
		ldx #spritesyx
sprites_mechanics:           ;This is the label at the start of the loop
		pshs    x ; store x 
; active?

; movetype - types ----

; movetype: obj[6]	

; movement: player 0

; movement: 1-10	
; move: left_only
		lda		OBJ_MOVE,x
		cmpa	#MOVE_LEFT
		bne		no_left_only
		; x=x-1
		ldb		OBJ_X,x
		subb	#1
		stb		OBJ_X,x		
		; playerx
		cmpb	PLAYERX
		bgt 	no_moveleft_toplayer
		subb	#1	
		stb		OBJ_X,x		
		lda		#ENEMY_SHOOT
		sta		OBJ_TYPESUB,x
		lda		#MOVE_DOWN
		sta		OBJ_MOVE,x
no_moveleft_toplayer
no_left_only:

; move: left_pingpong
		lda		OBJ_MOVE,x
		cmpa	#MOVE_LEFT_PINGPONG
		bne		no_left_pingpong
		; via param
		dec		OBJ_PARAM,x
		ldb		OBJ_PARAM,x
		cmpb	#1
		bne		no_left_ping_param
		ldb		#MOVE_RIGHT_PINGPONG
		stb		6,x	
no_left_ping_param		
		; x=x-1
		ldb		OBJ_X,x
		subb	#2
		stb		OBJ_X,x	
		cmpb	#-100
		bgt		no_left_pingpong
		ldb		#4
		stb		6,x	
no_left_pingpong:

; move: right_only
		lda		OBJ_MOVE,x
		cmpa	#MOVE_RIGHT
		bne		no_right_only
; playerx
		ldb		OBJ_X,x 
		cmpb	PLAYERX
		blt 	no_moveright_toplayer
		subb	#1	
		stb		OBJ_X,x		
		lda		#ENEMY_SHOOT
		sta		OBJ_TYPESUB,x
		lda		#MOVE_DOWN
		sta		OBJ_MOVE,x
no_moveright_toplayer

		; x=x-1
		ldb		OBJ_X,x 
		addb	#1
		stb		OBJ_X,x	
		cmpb	#100
		blt		no_right_only
		ldb		#0
		stb		OBJ_STATE,x	
no_right_only:

; move: right_only
		lda		OBJ_MOVE,x
		cmpa	#MOVE_RIGHT_PINGPONG
		bne		no_right_pingpong
		; via param
		inc		OBJ_PARAM,x
		ldb		OBJ_PARAM,x
		cmpb	#35
		bne		no_right_ping_param
		ldb		#MOVE_LEFT_PINGPONG
		stb		6,x	
no_right_ping_param		
		; x=x+1
		ldb		OBJ_X,x
		addb	#2
		; addb	#1
		stb		OBJ_X,x		
		cmpb	#70
		blt		no_right_pingpong
		ldb		#3
		stb		6,x	
no_right_pingpong:


; MOVE ENEMY_BOSS
; move-enemy
		lda		OBJ_MOVE,x
		cmpa	#MOVE_BOSS
		lbne	no_move_boss

		; move down at the beginning
		clra
		lda  	OBJ_Y,x
		cmpa	#60
		blt		no_bossgodown
		suba	#1
		sta		OBJ_Y,x
no_bossgodown:		

		; only move on scrolling up
		lda		scrolling_flag ;
		cmpa	#1
		lbne 	boss_stay				
		; y=y+1
		ldb		OBJ_Y,x
		addb	#1
		stb		OBJ_Y,x	
boss_stay:

;		no_move_boss

		
		; active big boss?
		lda		OBJ_STATE,x
		cmpa	#1
		lbne 	bigspawn_nobehavior
		
		; boss follows the player
		; bigbossTargetX
		; store position
		;lda		OBJ_X,x
		;sta bigbossTargetX

		; follow for x (or) 
		; search player x ... 	
		ldb		OBJ_X,x
		cmpb	PLAYERX 
		blt		no_bigboss_to_search_b
		subb	#1	
		stb		OBJ_X,x		
no_bigboss_to_search_b:
		cmpb	PLAYERX
		bgt		no_bigboss_to_search_l
		addb	#1
		stb		OBJ_X,x		
no_bigboss_to_search_l:


		; shooten 
;		jmp bigspawn_nobehavior
		
		; behaviour - update counter
		inc 	bigbossBehaviour 
		lda		#40
		cmpa	bigbossBehaviour
		bne		do_bigboss_behavior
		; reset
		lda		#0
		sta		bigbossBehaviour
		; spawn a sprite now
do_bigboss_behavior:
		; spawn here 
		; inc param
		inc		OBJ_PARAM,x
		lda		OBJ_PARAM,x
		cmpa	#80
		lblt	bigno_resetbehaviour
		lda		#3
		sta		OBJ_PARAM,x		
bigno_resetbehaviour:
		; behaviours!
		lda		OBJ_PARAM,x		
		sta		temptemp ; // store param
		cmpa	#10
		lbeq	big_dobehaviour
		cmpa	#20
		lbeq	big_dobehaviour
		cmpa	#40
		lbeq	big_dobehaviour
		cmpa	#50
		lbeq	big_dobehaviour
		jmp		bigspawn_nobehavior
big_dobehaviour:
		; spawn now
		; param
		lda		OBJ_PARAM,x		
		sta		temptemp ; // store param
		; y
	 	lda		OBJ_Y,x
		sta		sprites_tmp_move
		; y
	 	lda		OBJ_Y,x
		sta		sprites_tmp_move
		; x
		lda		OBJ_X,x
		sta		sprites_tmp_type
		; shoot now
		pshs 	x
		; for ...
		lda	#7 ; inner counter ... (for (for)) > use own counter!
		sta 	sprites_for_var_var   ;variable with a value of 5
		ldx 	#spritesyx
		leax	72,x ; 6*12 (player + 4 x shoot + explosion)
bigspawn_loop:           ;This is the label at the start of the loop
;		pshs    x ; store x 
; code
; not active
		lda		OBJ_STATE,x
		cmpa	#0
		bne		bigspawn_activenointerest				
		
; defaults
		; activate!
		lda		#1
		sta		OBJ_STATE,x
		; type
		lda		#OBJ_TYPE_ENEMY
		sta		OBJ_TYPE,x
		; typesub
		lda		#ENEMY_SHOOT
		sta		OBJ_TYPESUB,x
		; param
		lda		#3
		sta		OBJ_PARAM,x
		; hits
		lda		#90
		sta		OBJ_HITS,x		
		; x/y
		lda		sprites_tmp_move
		sta		OBJ_Y,x
		lda		sprites_tmp_type
		sta		OBJ_X,x
		lda		#MOVE_FASTDOWN
		sta		OBJ_MOVE,x
		lda		#1
		sta		OBJ_HITS,x		
		; default
		lda		#0
		sta		OBJ_ANIM,x		
; specials
		; some special shoots
		lda		temptemp		
		cmpa	#40
		bne		big_nopingpong
		lda		#ENEMY_FASTDOWN
		sta		OBJ_TYPESUB,x
		lda		#MOVE_FASTDOWN
		sta		OBJ_MOVE,x	
		lda		#8
		sta		OBJ_HITS,x			
big_nopingpong:	
		; some special shoots
		lda		temptemp		
		cmpa	#50
		bne		big_nodown
		lda		#ENEMY_DOWN
		sta		OBJ_TYPESUB,x
		lda		#MOVE_DOWN
		sta		OBJ_MOVE,x	
		lda		#3
		sta		OBJ_HITS,x
		adda	#20			
big_nodown:		
		
		; end done
		jmp		bigspawn_activedone	
bigspawn_activenointerest:
; /code
;		puls 	x ; restore x
		leax	12,x
		; for
		dec sprites_for_var_var   ;Subtract the loop_variable by 1
		bne bigspawn_loop      ;If the loop variable is not Zero, jump to loop_start
; / find
bigspawn_activedone
		; push x
		; UP
		puls 	x	
		; PARAM
		inc		OBJ_PARAM,x
		;jmp 	end_of_movement	
bigspawn_nobehavior:

		
no_move_boss:

;
; movement: 10-20	
; 
; move-down
		lda		OBJ_MOVE,x
		cmpa	#MOVE_DOWN
		bne		no_down_to
		; y=y+1
		ldb		OBJ_Y,x
		subb	#1
		stb		OBJ_Y,x		
no_down_to
; move-down-fast
		lda		OBJ_MOVE,x
		cmpa	#MOVE_FASTDOWN
		bne		no_down_to_fast
		; y=y+1
		ldb		OBJ_Y,x
		subb	#3
		stb		OBJ_Y,x	
no_down_to_fast

; move-down-search
		lda		OBJ_MOVE,x
		cmpa	#MOVE_DOWNSEARCH
		bne		no_downsearch_to
		; y=y+1
		ldb		OBJ_Y,x
		subb	#1
		stb		OBJ_Y,x
		; search player ... 	
;		lda		anim_flag
;		cmpa	#0
;		bne		no_downsearch_to
		lda		level_segment_offset
		cmpa	#10
		bgt		no_missile_to
		
		ldb		OBJ_X,x
		cmpb	PLAYERX
		blt		no_downsearch_to_search_b
		subb	#1	
		stb		OBJ_X,x		
no_downsearch_to_search_b
		cmpb	PLAYERX
		bgt		no_downsearch_to_search_l
		addb	#1
		stb		OBJ_X,x		
no_downsearch_to_search_l
no_downsearch_to

; move-missile
		lda		level_segment_offset
		cmpa	#5
		bgt		no_missile_to
;		lda		level_segment_offset
;		cmpa	#5
;		blt 	no_missile_to		
		lda		OBJ_MOVE,x
		cmpa	#MOVE_MISSILE
		bne		no_missile_to
		ldb		OBJ_Y,x
		; search player x ... 	
		ldb		OBJ_X,x
		cmpb	PLAYERX
		blt		no_missile_to_search_b
		subb	#1	
		stb		OBJ_X,x		
no_missile_to_search_b
		cmpb	PLAYERX
		bgt		no_missile_to_search_l
		addb	#1
		stb		OBJ_X,x		
no_missile_to_search_l
		; search player x ... 	
		ldb		OBJ_Y,x
		cmpb	PLAYERY
		blt		no_missile_to_search_by
		subb	#1	
		stb		OBJ_Y,x		
no_missile_to_search_by
		cmpb	PLAYERY
		bgt		no_missile_to_search_ly
		addb	#1
		stb		OBJ_Y,x		
no_missile_to_search_ly

no_missile_to:

; STAYSHOOT
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_STAYSHOOT
		bne		no_movestay	
		lda		bigbossReleased
		cmpa	#0
		beq		no_movestay
		lda		scrolling_flag ;
		cmpa	#1
		lbne 	no_stay				
		; y=y+1
		ldb		OBJ_Y,x
		addb	#1
		stb		OBJ_Y,x	
no_stay:		
no_movestay:		

; move-up-slow
		lda		OBJ_MOVE,x
		cmpa	#MOVE_SLOWUP
		bne		no_up_slow
		; y=y+1
		ldb		OBJ_Y,x
		addb	#1
		stb		OBJ_Y,x	
no_up_slow
; move-up-top
		lda		OBJ_MOVE,x
		cmpa	#MOVE_UPSHOOT
		bne		no_up_to_top
		; x=x+1
		ldb		OBJ_Y,x
		addb	#5
		stb		OBJ_Y,x
		; check the param (go down)
		dec		OBJ_PARAM,x
		lda		OBJ_PARAM,x
		cmpa	#0
		bne		no_enofrange
		ldb		#0
		stb		OBJ_STATE,x
no_enofrange:		
; deactivate?
		; Y>-128
		ldb		OBJ_Y,x
		cmpb	#-122
		bgt		no_up_to_top
		; to zero ...
		ldb		#0
		stb		OBJ_STATE,x
no_up_to_top

; ---------------
; MOVEMENTS
; ---------------
		; jmp 	no_diagonale_movements		

; MOVE: MOVE_DIAG

		lda		OBJ_MOVE,x
		cmpa	#MOVE_DIAG
		bne		no_diag
		; x=x+1
		ldb		OBJ_Y,x
		subb	#3
		stb		OBJ_Y,x
		ldb		OBJ_X,x
		addb	#3
		stb		OBJ_X,x		
		; check the param (go down)
		dec		OBJ_PARAM,x
		lda		OBJ_PARAM,x
		cmpa	#0
		bne		no_diagrange
		ldb		#0
		stb		OBJ_STATE,x
no_diagrange:		
; deactivate?
;		; Y>-128
		ldb		OBJ_X,x
		cmpb	#-122
		blt		no_diag
;		; to zero ...
		ldb		#0
;		stb		OBJ_STATE,x
no_diag

		; jmp 	no_diagonale_movements		

; MOVE: DIAGINV

		lda		OBJ_MOVE,x
		cmpa	#MOVE_DIAGINV
		bne		no_diaginv
		; x=x+1
		ldb		OBJ_Y,x
		subb	#3
		stb		OBJ_Y,x
		ldb		OBJ_X,x
		subb	#3
		stb		OBJ_X,x		
		; check the param (go down)
		dec		OBJ_PARAM,x
		lda		OBJ_PARAM,x
		cmpa	#0
		bne		no_diaginvrange
		ldb		#0
;		stb		OBJ_STATE,x
no_diaginvrange:		
; deactivate?
;		; Y>-128
		ldb		OBJ_X,x
		cmpb	#122
		blt		no_diaginv
;		; to zero ...
		ldb		#0
;		stb		OBJ_STATE,x
no_diaginv

no_diagonale_movements:

; move-sinussquare
		; jmp		no_move_sinussquare
		lda		OBJ_MOVE,x
		cmpa	#MOVE_SINUSSQUARE
		beq		move_sinussquare_x
		jmp 	no_move_sinussquare
move_sinussquare_x			
		clrb
		dec		OBJ_Y, x
		inc		OBJ_PARAM, x
		ldb		OBJ_PARAM, x
		cmpb	#40
		bgt		no_move_sinussquare_0
		inc		OBJ_X,x
		jmp		no_move_sinussquare
no_move_sinussquare_0:		
		cmpb	#80
		bgt		no_move_sinussquare_1
		dec		OBJ_X,x
		jmp		no_move_sinussquare
no_move_sinussquare_1:		
		cmpb	#120
		blt		no_move_sinussquare_2
		ldb		#0
		stb		OBJ_PARAM, x
no_move_sinussquare_2:	
				
no_move_sinussquare:

; MOVE: SINUS

; version 2.0
		jmp		no_move_sinus
		; debug
		cmpa	#MOVE_SINUS
		bne		no_move_sinus2
		; inc param
		;inc		OBJ_Y,x
		; inc		OBJ_X,x
		lda		spawn_flag ;
		cmpa	#1
		bne 	no_move_sinus2
		inc		OBJ_PARAM, x
		lda		OBJ_PARAM, x
		cmpa	#14
		bne		no_move_sinus_end2
		lda		#0
		sta		OBJ_PARAM, x
no_move_sinus_end2:
		lda		OBJ_X,x
		adda	OBJ_PARAM,x
		suba	#7
		sta		OBJ_X, x	
no_move_sinus2
; table version
; version 1.0
		jmp		no_move_sinus
		; debug
; MOVE SINUS		
		cmpa	#MOVE_SINUS
		bne		no_move_sinus
		; inc param
		; inc		OBJ_Y,x
		; inc		OBJ_X,x
		lda		scrolling_flag ;
		cmpa	#1
		bne 	no_move_sinus
		inc		OBJ_PARAM, x
		lda		OBJ_PARAM, x
		cmpa	#14
		bne		no_move_sinus_end
		lda		#0
		sta		OBJ_PARAM, x
no_move_sinus_end:
		lda		OBJ_PARAM, x
		sta		temp
		lda		OBJ_X, x
		pshs	x
		ldx		#sinus_movement
		adda	temp, x
		puls	x
		sta		OBJ_X, x				
no_move_sinus
; / MOVE SINUS
	


; behavior stayshoot
; MOVE: STAY SHOOT
		lda		OBJ_STATE,x
		cmpa	#0
		beq		no_behavior_stayshoot
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_STAYSHOOT
		beq		behavior_shoot
		jmp 	no_behavior_stayshoot
behavior_shoot			
		; inc param
		inc		OBJ_PARAM,x
		lda		OBJ_PARAM,x
		cmpa	#60
		bne		no_behavior_stayshoot
		lda		#0
		sta		OBJ_PARAM,x
		; y
		lda		OBJ_Y,x
		sta		sprites_tmp_move
		; x
		lda		OBJ_X,x
		sta		sprites_tmp_type
				
		; shoot now
		; jmp		no_behavior_stayshoot
		; push x
		; DOWN
		pshs 	x
		; for ...
		lda	#7
		sta 	sprites_for_var_var   ;variable with a value of 5
		ldx 	#spritesyx
		leax	72,x ; 6*12 (player + 4 x shoot + explosion)
sprites_mechanics_find_diag:           ;This is the label at the start of the loop
;		pshs    x ; store x 
; code
; not active
		lda		OBJ_STATE,x
		cmpa	#0
		bne		active_notinteresting_diag				
		; activate!
		lda		#1
		sta		OBJ_STATE,x
		; type
		lda		#OBJ_TYPE_ENEMY
		sta		OBJ_TYPE,x
		; typesub
		lda		#ENEMY_DIAG
		sta		OBJ_TYPESUB,x
		lda		#90
		sta		OBJ_HITS,x		
		; hits
		lda		sprites_tmp_move
		sta		OBJ_Y,x
		lda		sprites_tmp_type
		sta		OBJ_X,x
		lda		#MOVE_DIAG
		sta		OBJ_MOVE,x
		lda		sprites_tmp_type
		cmpa	#0
		blt		no_stayshoot_left
		lda		#MOVE_DIAGINV
		sta		OBJ_MOVE,x
no_stayshoot_left		
		; param
		lda		#0
		sta		OBJ_PARAM,x
		; left or right ...	
		; break the for
;		puls 	x ; restore x
		jmp		active_notinterestingdone_diag	
active_notinteresting_diag:
; /code
;		puls 	x ; restore x
		leax	12,x
		; for
		dec sprites_for_var_var   ;Subtract the loop_variable by 1
		bne sprites_mechanics_find_diag      ;If the loop variable is not Zero, jump to loop_start
; / find
active_notinterestingdone_diag
		; push x
		; UP
		puls 	x		
no_behavior_stayshoot
; / MOVE STAY SHOOT


end_of_movement

; -------------------------
; go down
; / under the screen?
; -------------------------		

; go down
; MOVE: END OF SCREEN
		; > 5 
		; go down
		lda 	sprites_for_var
		cmpa	#6
		bgt		no_left_pingpong_scrolling
		ldb		scrolling_flag
		cmpb	#1
		bne     no_left_pingpong_scrolling
		ldb		OBJ_Y,x
		subb	#1 
		stb		OBJ_Y,x
		
		; check going over the edge
		cmpb	#-110
		bgt		under_thehorizont
		lda		#0
		sta		OBJ_STATE,x
under_thehorizont:	

; / MOVE: END OF SCREEN
	
no_left_pingpong_scrolling:

		; go down
		
		
; /code
		puls 	x ; restore x
		leax	12,x
		; for
		dec sprites_for_var   ;Subtract the loop_variable by 1
		bne sprites_mechanics      ;If the loop variable is not Zero, jump to loop_start
	

;***************************************************************************
; INGAME: GAMEMECHANICS  PLAYGROUND  (LEFT/RIGHT BORDERS)
;***************************************************************************
		; jmp		no_playground
		; prepare the level
		ldx 	#leveldata
; debug		
		; jmp		no_count_segments_tmp
		; add level_segment
		lda		level_segment
		; deca
		cmpa	#0
		bne		count_segments_tmp 
		;inca
count_segments_tmp:
		; temp coord.
		leax	STRIPE_SIZE,x
		deca
		cmpa	#0
		bne		count_segments_tmp
no_count_segments_tmp:

		; ------------------------
		lda		#-100
		sta		level_positionx
		lda		#100
		sta		level_positionxx		
		; 		create
		lda 	#STRIPES_AMOUNT+1
		sta		sprites_for_var
		; y-position ... 
		lda		#-107
		suba	level_segment_offset
		sta		level_positiony
level_for_playfield:

		; x1< <x2
		lda		,x
		sta		level_positionx
		lda		1,x
		sta		level_positionxx


; player -------

; version 2.0
		; jmp		no_player_version_2
		ldb		spritesyx
		cmpb	level_positiony			
		blt		no_stripe_2
		subb	#STRIPES_SIZE+1
		cmpb	level_positiony			
		bgt		no_stripe_2
		; set to left side
			
;		debug		
;		lda		sprites_for_var
;		sta		spritesyx+1
		
		; debug: store to highscore
		; lda		sprites_for_var
		; sta		debug_value
		
; player left & playground		
		lda		PLAYERX
		cmpa	level_positionx
		bgt		playground_player_left_2
		lda		PLAYERX
		adda	#5
		sta		PLAYERX
		; ++score
		lda		score
		; adda	#1
		sta		score		
playground_player_left_2:		
; player right & playground		
		lda		PLAYERX
;		; suba		#20 ; user offset
		cmpa	level_positionxx
		blt		playground_player_right_2
		lda		PLAYERX
		suba	#5
		sta		PLAYERX
		; ++score
		lda		score
		; adda	#1
		sta		score		
playground_player_right_2:
no_player_version_2:
no_stripe_2:


		; new table y-absolute,x1,x2,e,1
		lda		level_positiony
		adda	#STRIPES_SIZE
		sta		level_positiony
		; add 5 ...
		leax	STRIPE_SIZE,x		
		; for_
		dec		sprites_for_var
		bne		level_for_playfield	

	;***************************************************************************
	; INGAME: GAMEMECHANICS PLAYGROUND
	;***************************************************************************
		
no_playground:



;***************************************************************************
; INGAME: INGAME MECHANICS COLLISIONS
;***************************************************************************
		; jmp no_collsisions
		lda	 	counter_ms
		cmpa	#0
		lbne  	no_collsion_atall
		
; test object x > loop col over y!
; for x / for y
		ldu 	#spritesyx
		lda		#12
		lda		spritesnr
		sta 	sprites_for_var 
; for x------------
sprites_mechanics_collisions:         
; for x / for y
		ldx 	#spritesyx
		lda		#12
		lda		spritesnr
		sta 	sprites_for_var_var 
; for x------------
sprites_mechanics_col:         
		pshs	x
	
; A!=B	
; never the same ..	
		lda		sprites_for_var			
		suba	sprites_for_var_var
		cmpa	#0
		lbeq		not_the_same

; A active!
		lda		2,u
		cmpa	#0
		lbeq		not_the_same
; B active!
		lda		2,x
		cmpa	#0
		lbeq		not_the_same
; NO EXPLOSION! SPRITE 5!
		lda		OBJ_TYPE,x
		cmpa	#OBJ_TYPE_EXPLOSION
		lbeq	not_the_same				
;
; COLLISION
;
; A (y,x)
		lda	   ,u
		sta	   collisionAyx	
		lda	   1,u
		sta	   collisionAyx+1	
; B (y,x)
; test the player
		lda	   spritesyx
		sta	   collisionByx	
		lda	   spritesyx+1
		sta	   collisionByx+1
		lda	   ,x
		sta	   collisionByx	
		lda	   1,x
		sta	   collisionByx+1

; Do collision		
; 	store x
		pshs	x
		; SPECIAL SIZES! BIGBOSS
;		lda		OBJ_TYPESUB,x
;		cmpa	#ENEMY_BOSS
;		lbeq		col_bigboss	
		ldx     collisionAyx        ; Y/X Coordinates of object A
		ldy     collisionByx        ; Y/X Coordinates of object B
		; default
		lda	#12		; (Height of object #1 + Height of object #2)/2
		ldb	#12		; (Width of object #1 + Width of object #2)/2 Thanks to Alex H.
;		jmp al_col_bigboss
;col_bigboss:	
;		ldx     collisionAyx        ; Y/X Coordinates of object A
;		ldy     collisionByx        ; Y/X Coordinates of object B
;        lda	#12		; 
;		ldb	#12		; 		
;al_col_bigboss:
	
		; / SPECIAL SIZES! BIGBOSS
        jsr   	COLLTEST	; Check for collision
        lbcc	no_collissionfound		; Branch to 'alldone' if no collision  bcs would branch if collision
; 	restore x
		puls	x
		pshs	x
; collision --------------------------		

;		lda		1,u
;		inca
;		sta		1,u		

; -------------------------------
; collision: player & enemy
; -------------------------------

		lda		3,u
		cmpa	#0
		bne		no_col_player_enemy
		lda		3,x
		cmpa	#3
		bne		no_col_player_enemy
		; only if shield ==0 !
		lda		shield
		cmpa	#0
		bne		no_col_player_enemy
		; ++score
		lda		score
		; adda	#1
		sta		score
		; move right			
		lda		1,u
		;inca	
		sta		1,u
		; sta 0
		lda		#0
		stb		2,x
		dec 	lifes
		; shield
		lda		#60
		sta		shield
		; destroy other
		lda		#0
		sta		OBJ_STATE,x		
		; explosion!
		lda		#1
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_STATE
		lda		PLAYERY
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_Y
		lda		PLAYERX
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_X
		lda		#5
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_ANIM ; anim!!!
		lda		#MOVE_STAY
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_MOVE ; anim!!!	
		; sound die
		; sound
	   	lda     #1                      ; one means, we are about to
	    sta     Vec_Music_Flag          ; store it in appropriate RAM               	
		lda		#EFFECT_DIE
		sta 	soundeffect			
		; game over
		lda		lifes
		cmpa	#0
		bne		no_gameover
		lda		#STATE_GAMEOVER
		sta		state
		; OBJ_STATE,x
		lda		#0
		sta		PLAYERY+OBJ_STATE
		; sta ...
		lda		#30
		sta		button_upcounter	
		; sound
	   	lda     #1                      ; one means, we are about to
	    sta     Vec_Music_Flag          ; store it in appropriate RAM               	
		lda		#EFFECT_GAMEOVER
		sta 	soundeffect			
no_gameover	


	
		; end of the story
		jmp		no_deathhit	
no_col_player_enemy:
		
; ---------------------------
; collision: shoot & enemy
; ---------------------------
		lda		3,u
		cmpa	#1
		lbne		no_col_shoot_enemy
		lda		3,x
		cmpa	#3
		lbne		no_col_shoot_enemy	
		; no collision shoot & enemy shoot!
		lda		OBJ_TYPESUB,x

		; shoot&shoot		
		cmpa	#ENEMY_SHOOT
;		cmpa	#35
		beq 	collision_shootshoot		
		jmp 	no_collision_shootshoot		
collision_shootshoot
		jmp		no_col_shoot_enemy	
no_collision_shootshoot
		
		; go left
		lda		1,u
		deca	
		sta		1,u
		
		; deactivate shoot
		lda		#0
;		sta		OBJ_STATE,u
;		sta		OBJ_ANIM,x
;		lda		#OBJ_TYPE_EXPLOSION
;		sta		OBJ_TYPE,x		

		; fast forward in anim on hit!
		inc		OBJ_ANIM,x
		;inc		OBJ_ANIM,x
		;inc		OBJ_ANIM,x
		
		; lda		#0
		; sta		OBJ_ANIM,x
		; lda		OBJ_Y,x
		; adda	#3
		; sta		OBJ_Y,x
				
		; shoot&enemy
		; deactive enemy
		
		; hits ...
		dec		OBJ_HITS,x
		lda		OBJ_HITS,x
		cmpa	#0
		bne		no_deathhit
		; deactive enemy ...
		lda		#0
		sta		OBJ_STATE,x
		
; killed the boss?
; game won? 
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_BOSS
		bne		not_killedtheboss
		; state won!
		lda		#STATE_WON
		sta		state
		; add some score
		lda		score
		adda	#100
		sta		score
		; big boss defeated
		lda		#1
		sta		bigbossDefeated
		; wait
		lda		#70
		sta		button_upcounter	
not_killedtheboss:
		
		
		; add score
		lda		score
		adda	#1
		sta		score	
		; special scores
		
		; -------------------------------
		; explosion ...
		; -------------------------------
		; OBJ_TYPE_EXPLOSION
		; sprite 5 is the explosion ...
		lda		#1
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_STATE
		lda		OBJ_Y,x
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_Y
		lda		OBJ_X,x
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_X
		lda		#5
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_ANIM ; anim!!!
		lda		#MOVE_SLOWUP
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_MOVE ; anim!!!	
		
		; play music (set flag to wait for music)
		lda		shield
		cmpa	#1 
		bgt		no_shield_sound
	   	lda     #1                      ; one means, we are about to
	    sta     Vec_Music_Flag          ; store it in appropriate RAM               	
		lda		#EFFECT_EXPLOSION
		sta 	soundeffect	
no_shield_sound	
		; / EXPLOSION

		; some turn into enemy shoots!
		lda		OBJ_TYPESUB,x
		cmpa	#ENEMY_STAYSHOOT
		beq		enemy_shootleft		
		cmpa	#ENEMY_STAY
		beq		enemy_shootleft		
		cmpa	#ENEMY_PINGPONG
		beq		enemy_shootleft		
;		cmpa	#ENEMY_FASTDOWN
;		beq		enemy_shootleft		
		cmpa	#ENEMY_DOWN
		beq		enemy_shootleft		
		jmp		no_enemyshoot_left
enemy_shootleft:		
		lda		#1
		sta		OBJ_STATE,x
		lda		#ENEMY_SHOOT
		sta 	OBJ_TYPESUB,x
		lda		#MOVE_FASTDOWN
		sta		OBJ_MOVE,x		
no_enemyshoot_left:

; / EXPLOSION (...)

;		; some turn into enemy shoots!
;		lda		OBJ_TYPESUB,x
;		cmpa	#ENEMY_PINGPONG
;		beq		enemy_shootleft		
;		cmpa	#ENEMY_FASTDOWN
;		beq		enemy_shootleft		
;		cmpa	#ENEMY_DOWN
;		beq		enemy_shootleft		
;		jmp		no_enemyshoot_left
;enemy_shootleft:		
;		lda		#1
;		sta		OBJ_STATE,x
;		lda		#ENEMY_SHOOT
;		sta 	OBJ_TYPESUB,x
;		lda		#MOVE_FASTDOWN
;		sta		OBJ_MOVE,x		
;no_enemyshoot_left:
;

		; end of the story
		jmp		death_end	
no_deathhit:
		; -------------------------------
		; explosion ...
		; -------------------------------
		; OBJ_TYPE_EXPLOSION
		; sprite 5 is the explosion ...
		lda		#1
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_STATE
		lda		OBJ_Y,x
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_Y
		lda		OBJ_X,x
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_X
		lda		#5
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_ANIM ; anim!!!
		lda		#MOVE_STAY
		sta		spritesyx+SPRITE_EXPLOSION*OBJ_SIZE+OBJ_MOVE ; anim!!!	
		
		; play music (set flag to wait for music)
	   	lda     #1                      ; one means, we are about to
	    sta     Vec_Music_Flag          ; store it in appropriate RAM               	
		lda		#EFFECT_HIT
		sta 	soundeffect	
				
death_end:

no_col_shoot_enemy:

; / collision --------------------------		
no_collissionfound:
		puls	x

; / /A!=B
not_the_same:


; / not active
not_active:

; /for y
; /for x
no_mechanic_forfor
		puls	x
		leax	12,x
;		; for
		dec 	sprites_for_var_var 
		bne 	sprites_mechanics_col      
   
; /for x
no_mechanic_for
		leau	12,u
		; for
		dec 	sprites_for_var 
		bne 	sprites_mechanics_collisions      

no_collsisions:		

no_collsion_atall
		
mechanics_done:

		; lda		anim_flag
		; sta		debug_value


;***************************************************************************
; INGAME: ANIM
;***************************************************************************
		; jmp		no_anim
		; debug
		
		; animation?
		lda	 	state
		cmpa	#STATE_GAMEOVER
		beq		no_anim
		lda	 	state
		cmpa	#STATE_WON
		beq		no_anim	
; start to animate		
		lda		anim_flag
		cmpa	#1
		bne		no_anim
		lda		#12
		lda		spritesnr
		ldx		#spritesyx	
		sta		sprites_for_var	
anim_thesprites:
		; code
		dec		OBJ_ANIM,x
		lda		OBJ_ANIM,x
		cmpa	#0
		bgt		no_set_anim_back
		lda		#4
		sta		OBJ_ANIM,x
		; special explosion
		; stop object
		lda		OBJ_TYPE,x
		cmpa	#SPRITE_EXPLOSION
		bne 	no_set_anim_back
		lda		#0
		sta		OBJ_STATE,x
no_set_anim_back:		
		; /code		
		leax	12,x
		; for
		dec sprites_for_var   ;Subtract the loop_variable by 1
		bne anim_thesprites      ;If the loop variable is not Zero, jump to loop_start		
no_anim:


  
;***************************************************************************
; INGAME: DISPLAYS
;***************************************************************************

;***************************************************************************
; INGAME: DEBUG SPRITES AS POINTS
;***************************************************************************
; debug display sprite points
		jmp sprites_for_debug_done
		
		lda     #135                     ; load 50
        sta     VIA_t1_cnt_lo           ; 50 as scaling

		; intensity
        jsr     Intensity_3F       
		; show all dots here!
		; for (i=4;i>=0;i--)  		
		lda spritesnr
		; lda	#12
		sta sprites_for_var   ;variable with a value of 5
		ldx #spritesyx
sprites_for_debug:           ;This is the label at the start of the loop
		pshs    X ; store x 
		lda     #0                    ; load A with 6, dots - 1
        sta     Vec_Misc_Count          ; set it as counter for dots
        ; version 1.0
        ; jsr     Dot_List                ; Plot a series of dots   
 		; version 2.0
 		lda		 ,x
 		ldb		1,x
 		jsr		Dot_d
        jsr 	Reset0Ref  ; reset to 0,0     
 		; attention Dot_List is changing flags and register!!!
		puls 	x ; restore x
		leax	12,x
		dec sprites_for_var   ;Subtract the loop_variable by 1
		bne sprites_for_debug      ;If the loop variable is not Zero, jump to loop_start
sprites_for_debug_done:

;***************************************************************************
; INGAME: DEBUG RECT
;***************************************************************************
; debug test rectangle
		jmp debug_rect
        jsr     Intensity_3F       
		lda		#110
		ldb		#0
		jsr     Moveto_d           
        ldx     #grafix_quad      
        jsr     Draw_VLc  
        jsr 	Reset0Ref ; reset to 0,0
        ; move to 0 0 
        ;lda     #-110                      ; to 0 (y)
        ;ldb     #0                      ; to 0 (x)
        ;jsr     Moveto_d                ; move the vector beam the
        jsr     Delay_3 
        jsr     Intensity_3F       
		lda		#10
		ldb		#10
		jsr     Moveto_d           
        ldx     #grafix_quad      
        jsr     Draw_VLc  
        jsr 	Reset0Ref  ; reset to 0,0     
debug_rect:

; HARDCORE: DEBUG
; reset all sprites
		jmp		no_hardcore_debug
		lda		#12
		lda		spritesnr
		sta 	sprites_for_var   
		ldx 	#spritesyx
		leax	72,x
do_it_again_sam:           
		; ldb		4,x
		ldb		sprites_for_var
		ldb		#2
		stb		4,x			
no_no_no:		
		; /code
		; +12 bytes
  		leax	12,x
		; lda sprites_for_var,x
		dec 	sprites_for_var		
		bne		do_it_again_sam
no_hardcore_debug
		
;***************************************************************************
; INGAME: DEBUG DISPLAY SPRITES
;***************************************************************************
		jmp 	no_spritesdebug
		lda		#ENEMY_SINUS
		sta		spritesyx+72+12*0+OBJ_TYPESUB
		lda		#ENEMY_PINGPONG
		sta		spritesyx+72+12*1+OBJ_TYPESUB
		lda		#ENEMY_DOWN
		sta		spritesyx+72+12*2+OBJ_TYPESUB
		lda		#ENEMY_FASTDOWN
		sta		spritesyx+72+12*3+OBJ_TYPESUB
		lda		#ENEMY_LEFT
		sta		spritesyx+72+12*4+OBJ_TYPESUB
no_spritesdebug		
		

;***************************************************************************
; MENU/GAMEOVER: DISPLAY TEXT 
;***************************************************************************
		;jmp		no_textes
; display texts: title, ingame comments
		lda	state
; menu
		cmpa #STATE_MENU
		lbne state_menu
		
		; check for playing music
; 		TST	Vec_Music_Flag	; Loop if music is still playing
; 		BNE	menumusic_notplaying
; 		jmp	menumusic_playing
; menumusic_notplaying:		
;
; 		JSR	DP_to_D0		
; 		jsr     DP_to_C8                ; DP to RAM
 ;        ldu     #music8                 ; get some music, here music1
  ;       jsr     Init_Music_chk          ; and init new notes		
; 		jsr	Wait_Recal ;	Wait for the next frame
; 		jsr	Do_Sound ;	Play the sound
; 		
; menumusic_playing:
		
;		ldu     #string_title      
;        jsr     Print_Str_yx          
        
        ; play
        ldu     #string_menu_play      
        jsr     Print_Str_yx    
        
        ; code
        ldu     #string_menu_code      
        jsr     Print_Str_yx    
        ; credits
        ldu     #string_menu_credits      
        jsr     Print_Str_yx    
        
        ; info
        ; ldu     #string_menu_info      
        ; jsr     Print_Str_yx          
        
		jsr 	Reset0Ref  ; reset to 0,0 	        
		
		; movement
;		inc 	sprites_tmp_type
		; sprites_tmp_move equ $C882+7
;		lda		sprites_tmp_type
;		cmpa	#40
;		bgt		go_down
;		lda		#0
;		sta		sprites_tmp_type 
;go_down

offset_titlescreen equ -10
offsetmonster_titlescreen equ 10

		; logo
		lda		#50-offset_titlescreen ; y-pos
		;adda	sprites_tmp_type
		ldb		#-110 ; x-pos
		; OFFSET?
		jsr     Moveto_d 
		ldx		#logo
		jsr     Draw_VLc  
		jsr 	Reset0Ref  ; reset to 0,0 	        

		
		; mouth ..
		; ;	db -47,-125
		lda		#-104-offset_titlescreen-offsetmonster_titlescreen ; y-pos
		ldb		#-94 ; x-pos
		jsr     Moveto_d 
		; logo mouth ...
		ldx		#grafix_monster
		lda		bigbossDefeated
		cmpa	#1
		bne		default_logo
		ldx		#grafix_won		
default_logo:		
		jsr     Draw_VLc  
		jsr 	Reset0Ref  ; reset to 0,0 	    
		; mouth shadow
;		lda		#-109-offset_titlescreen-offsetmonster_titlescreen ; y-pos
;		ldb		#-102 ; x-pos
;		jsr     Moveto_d 
;		ldx		#grafix_monster
;		jsr     Draw_VLc  
;		jsr 	Reset0Ref  ; reset to 0,0 	    
		    
		; eyes
		lda		bigbossDefeated
		cmpa	#1
		beq		no_eyes
		
		; the eyes!!
		;	db -10,-74
		lda		#-10-offset_titlescreen-offsetmonster_titlescreen ; y-pos
		ldb		#-74 ; x-pos
		jsr     Moveto_d 
		ldx		#grafix_eye0
		jsr     Draw_VLc  
		jsr 	Reset0Ref  ; reset to 0,0 	        
		; db 6,-39
		lda		#6-offset_titlescreen-offsetmonster_titlescreen ; y-pos
		ldb		#-39 ; x-pos
		jsr     Moveto_d 
		ldx		#grafix_eye0+7
		jsr     Draw_VLc  
		jsr 	Reset0Ref  ; reset to 0,0 	        
        ; ; db 17,-31
		lda		#17-offset_titlescreen-offsetmonster_titlescreen; y-pos
		ldb		#-31 ; x-pos
		jsr     Moveto_d 
		ldx		#grafix_eye0+14
		jsr     Draw_VLc  
		jsr 	Reset0Ref  ; reset to 0,0 	        
		; db -33,-79
		lda		#-33-offset_titlescreen-offsetmonster_titlescreen; y-pos
		ldb		#-79 ; x-pos
		jsr     Moveto_d 
		ldx		#grafix_eye0+21
		jsr     Draw_VLc  
		jsr 	Reset0Ref  ; reset to 0,0 	        
no_eyes:

        lbra 	state_done
        
state_menu:


; display: state_won
		lda	 	state
		cmpa 	#STATE_WON
		bne 	state_won
		
  		ldu     #string_won      
        jsr     Print_Str_yx    

		; text
		lda		button_upcounter
		cmpa	#2
		bgt		no_won_text
        ldu     #string_pressbutton      
        jsr     Print_Str_yx    
no_won_text   
		
;
;		jsr 	Reset0Ref  ; reset to 0,0 	        

;offset_wonscreen 		equ -10
;offsetmonster_wonscreen equ 10

		; logo
;		lda		#50-offset_wonscreen ; y-pos
;		;adda	sprites_tmp_type
;		ldb		#-110 ; x-pos
;		; OFFSET?
;		jsr     Moveto_d 
;		ldx		#logo
;		jsr     Draw_VLc  
;		jsr 	Reset0Ref  ; reset to 0,0 	        
;		
		; mouth ..
;		; ;	db -47,-125
;		lda		#-104-offset_wonscreen-offsetmonster_wonscreen ; y-pos
;		ldb		#-94 ; x-pos
;		jsr     Moveto_d 
;		ldx		#grafix_won ; #grafix_monster
;		jsr     Draw_VLc  
;		jsr 	Reset0Ref  ; reset to 0,0 	        

		; add ...
		; ;	db -47,-125
;		lda		#9-offset_wonscreen-offsetmonster_wonscreen ; y-pos
;		ldb		#-118 ; x-pos
;		jsr     Moveto_d 
;		ldx		#grafix_won
;		jsr     Draw_VLc  
;		jsr 	Reset0Ref  ; reset to 0,0 	        

           
       lbra 	state_done
state_won
; / DISPLAY: WON

; intro
		cmpa #STATE_INTRO
		bne state_intro
;		ldu     #string_explanation      
;       jsr     Print_Str_yx          
;		ldu     #string_explanation_ext      
;        jsr     Print_Str_yx          

        lbra 	state_done
state_intro:
; ingame
		cmpa #STATE_INGAME
		bne 	state_ingame
;		ldu     #string_ingame      
;        jsr     Print_Str_yx                   
        lbra 	state_done
       
state_ingame:
; gameover
		cmpa 	#STATE_GAMEOVER
		bne 	state_intro
		ldu     #string_gameover      
        jsr     Print_Str_yx  

		; text
		lda		button_upcounter
		cmpa	#2
		bgt		no_gameover_text
        ldu     #string_pressbutton      
        jsr     Print_Str_yx    
no_gameover_text           
        
                        
        bra 	state_done
state_gameover:

		

state_done:
no_textes:

;***************************************************************************
; INGAME/MENU: DISPLAY MESSAGES
;***************************************************************************
; debug	
	; lda		message_counter
	; sta 	debug_value
; display messages
	lda	 	message_counter
	cmpa	#0
	beq		no_messagetoshow 	
	; lda	 	message_index
	ldu     #str_level0
	; leau	message_index,u
	lda 	message_index
	cmpa	#1
	bne		no_message_index_1
	ldu     #str_level1
no_message_index_1:	      
	cmpa	#2
	bne		no_message_index_2
	ldu     #str_level2
no_message_index_2:	
	cmpa	#3
	bne		no_message_index_3
	ldu     #str_level3
no_message_index_3:	
	cmpa	#4
	bne		no_message_index_4
	ldu     #str_level4
no_message_index_4:	
	cmpa	#5
	bne		no_message_index_5
	ldu     #str_level5
no_message_index_5:
	cmpa	#6
	bne		no_message_index_6
	ldu     #str_level6
no_message_index_6:	
	cmpa	#7
	bne		no_message_index_7
	ldu     #str_level7
no_message_index_7:	
    jsr     Print_Str_yx 	
no_messagetoshow:

;***************************************************************************
; INGAME/MENU: DISPLAY SCORE AND HIGHSCORE
;***************************************************************************
;		jmp 	no_score
; actual scores 
; sorry dirty as hell! no chance for coder heaven .-)
; new highscore?
		lda 	score
;		 lda		button_upcounter
;		cmpa	highscore
;		blt		no_new_highscore
;		; sta		highscore
;no_new_highscore:
		lda		state
		cmpa	#STATE_MENU
		lbeq	no_score
; scores
		lda 	#1
		sta 	sprites_for_var
scores_display:
		; clear string
		lda		#48
		sta		str_score+2
		sta		str_score+3
		sta		str_score+4
		sta 	str_score+4
		lda		#32
		sta 	str_score+5
		lda		#48
		adda	lifes
		sta 	str_score+6		
		lda		$80
		sta 	str_score+7
		; score
		lda		sprites_for_var
		cmpa	#1
		bne		not_score_actual
; score		
		lda		#125
		sta		str_score
		lda		#0
		sta		str_score+1
		lda 	score
		jmp		no_score_display			
not_score_actual:
; highscore
		lda		#115
		sta		str_score
		lda		#0
		sta		str_score+1
		; lda		highscore
		; debug
		; lda		counter_sec	
		; lda		level	
		lda		debug_value
		
; debug
		;ldx		#spritesyx
		;leax	12,x
		;lda		2,x		
no_score_display:			
; display score
; 100
		cmpa    #100
		blt		biggerthan100
		suba    #100
		; 1xx
		ldb		#1 ; max 100
		addb		#48 ; 0
		stb		str_score+2		
biggerthan100:	
 
; 00,10,20,30,40,50,60,70,80
; 90
		cmpa    #90
		blt		biggerthan90
		suba    #90
		; .9x
		ldb		#9  ; 
		addb		#48 ; 0
		stb		str_score+3						
		jmp 	under10
biggerthan90:		
; 80
		cmpa    #80
		blt		biggerthan80
		suba    #80
		; .9x
		ldb		#8  ; 
		addb	#48 ; 0
		stb		str_score+3						
		jmp 	under10
biggerthan80:		
; 70
		cmpa    #70
		blt		biggerthan70
		suba    #70
		; .9x
		ldb		#7  ; 
		addb	#48 ; 0
		stb		str_score+3						
		jmp 	under10
biggerthan70:
; 60
		cmpa    #60
		blt		biggerthan60
		suba    #60
		; .9x
		ldb		#6  ; 
		addb	#48 ; 0
		stb		str_score+3						
		jmp 	under10
biggerthan60:
; 50
		cmpa    #50
		blt		biggerthan50
		suba    #50
		; .9x
		ldb		#5  ; 
		addb	#48 ; 0
		stb		str_score+3						
		jmp 	under10
biggerthan50:
; 40
		cmpa    #40
		blt		biggerthan40
		suba    #40
		; .9x
		ldb		#4  ; 
		addb	#48 ; 0
		stb		str_score+3						
		jmp 	under10
biggerthan40:
; 30
		cmpa    #30
		blt		biggerthan30
		suba    #30
		; .9x
		ldb		#3  ; 
		addb	#48 ; 0
		stb		str_score+3						
		jmp 	under10
biggerthan30:
; 20
		cmpa    #20
		blt		biggerthan20
		suba    #20
		; .9x
		ldb		#2  ; 
		addb	#48 ; 0
		stb		str_score+3						
		jmp 	under10
biggerthan20:
; 10
		cmpa    #10
		blt		biggerthan10
		suba    #10
		; .9x
		ldb		#1  ; 
		addb	#48 ; 0
		stb		str_score+3						
		jmp 	under10
biggerthan10:
under10:
		adda	#48 ; 0
		sta		str_score+4						
; show score
		ldu     #str_score      
        jsr     Print_Str_yx 
; / score		
		dec sprites_for_var  
		bne scores_display 

; show title not menu
		lda	state
		cmpa #0
		beq not_menu_state         
        ; title
		;ldu     #string_title_short      
        ;jsr     Print_Str_yx  
not_menu_state:
no_score:

;***************************************************************************
; UPDATE SOUND
;***************************************************************************


; music - do the sound
		lda	 	state
;		cmpa 	#STATE_MENU
;		bne  	nosoundingame

;        jsr     Init_Music_chk          ; and init new notes		
        jsr    	Do_Sound                ; ROM function that does the        

nosoundingame:

; soundeffects

		lda	 	state
;		cmpa 	#STATE_MENU
;		beq  	nofxtodo
		
		; play soundeffects 
;		; via ay/ym (if there are!)
		lda 	sfx_status				; check if sfx to play
		beq 	nofxtodo
		jsr 	sfx_doframe	
		
nofxtodo:

;***************************************************************************
; LOOP
;***************************************************************************

; gameloop
        lbra     main                    ; and repeat forever

;***************************************************************************
; END OF MAIN
;***************************************************************************

; SOUND EFFECTS 
; http://vectorgaming.proboards.com/thread/312/vectrex-sound-programming?page=3

sfx_doframe:
	LDU sfx_pointer				; get current frame pointer
	LDB ,U
	CMPB #$D0					; check first flag byte D0
	BNE sfx_checktonefreq		; no match - continue to process frame
	LDB 1,U
	CMPB #$20					; check second flag byte 20
	BEQ sfx_endofeffect			; match - end of effect found so stop playing
sfx_checktonefreq:
	LEAY 1,U 					; init Y as pointer to next data or flag byte

	LDB ,U 						; check if need to set tone freq
	BITB #%00100000				; if bit 5 of B is set
	BEQ sfx_checknoisefreq			; skip as no tone freq data

	LDB 1,U						; get next data byte and copy to tone freq reg4
 	LDA #$04
 	JSR Sound_Byte 				; set tone freq

	LDB 2,U						; get next data byte and copy to tone freq reg5
 	LDA #$05
 	JSR Sound_Byte 				; set tone freq

	LEAY 2,Y					; increment pointer to next data/flag byte 

sfx_checknoisefreq:
	LDB ,U						; check if need to set noise freq
	BITB #%01000000				; if bit 6 of B is only set
	BEQ	sfx_checkvolume				; skip as no noise freq data

	LDB ,Y						; get next data byte and copy to noise freq reg
	LDA #$06
	JSR Sound_Byte 				; set noise freq

	LEAY 1,Y					; increment pointer to next flag byte

sfx_checkvolume:
	LDB ,U						; set volume on channel 3		
	ANDB #%00001111				; get volume from bits 0-3
	LDA #$0A              		; set reg10
	JSR Sound_Byte 				; Set volume

sfx_checktonedisable:
	LDB ,U						; check disable tone channel 3
	BITB #%00010000				; if bit 4 of B is set disable the tone
	BEQ sfx_enabletone
sfx_disabletone:
	LDB $C807					; set bit2 in reg7
	ORB #%00000100		
	LDA #$07
 	JSR Sound_Byte 				; disable tone
	BRA sfx_checknoisedisable
sfx_enabletone:
	LDB $C807					; clear bit2 in reg7
	ANDB #%11111011	
	LDA #$07
 	JSR Sound_Byte 				; enable tone
							
sfx_checknoisedisable:
	LDB ,U						; check disable noise
	BITB #%10000000				; if bit7 of B is set disable noise
	BEQ sfx_enablenoise
sfx_disablenoise:
	LDB $C807					; set bit5 in reg7
	ORB #%00100000
	LDA #$07
 	JSR Sound_Byte 				; disable noise
	BRA sfx_nextframe
sfx_enablenoise:
	LDB $C807					; clear bit5 in reg 7
	ANDB #%11011111		
	LDA #$07
 	JSR Sound_Byte				; enable noise

sfx_nextframe:
	STY sfx_pointer				; update frame pointer to next flag byte in Y
	RTS

sfx_endofeffect:

	ldb #$00					; set volume off channel 3	
	lda #$0A              		; set reg1sf0
	jsr Sound_Byte 				; Set volume

	ldd #$0000 					; reset sfx
	std	sfx_pointer
	sta sfx_status
	rts

;***************************************************************************
; DATA SECTION EP ROM!!! READ ONLY!!!
;***************************************************************************

;***************************************************************************
; DATA SECTION (EPROM): GRAPHICS
;***************************************************************************

; graphics
; raster 10x10!

rect_size equ 2

; player
; 4/2
rect_player_mul equ 5
rect_player_div equ 5

;	db 3
;	db 11,4 
;	db -17,7 
;	db 7,-7 
;	db 6,0 

; avatar / ship / avatar
grafix_player: 


	db 3
	db 14,-1 
	db -14,-1 
	db 2,7 
	db 12,-1 	

	; org
	db 3
	db 14,0 
	db -14,-1 
	db 2,6 
	db 12,-1 

	db 3
	db 14,1 
	db -14,0 
	db 2,4 
	db 12,-1 


	db 3
	db 14,2 
	db -14,0 
	db 2,1 
	db 12,-1 

	


; player shield 
grafix_player_shield:
		; anim0-4
	db 3
	db 14,-1 
	db -14,-1 
	db 2,7 
	db 12,-1 	

	; org
	db 0
	db 0,0 
	db -14,-1 
	db 2,6 
	db 12,-1 

	db 3
	db 14,1 
	db -14,0 
	db 2,4 
	db 12,-1 


	db 0
	db 0,0 
	db -14,0 
	db 2,1 
	db 12,-1 


				
; shoots * not used
grafix_shoot:

rect_size_shoot	equ	2
			
		; version 1
		

grafix_shoot_laser:

		; version 2
		db 	1
		db	3*rect_size_shoot,0*rect_size_shoot
		db	-3*rect_size_shoot,0*rect_size_shoot
		db	0*rect_size_shoot,0*rect_size_shoot
		db	0*rect_size_shoot,0*rect_size_shoot

		db 	3
		db	-1*rect_size,0*rect_size
		db	0*rect_size,1*rect_size
		db	1*rect_size,0*rect_size
		db	0*rect_size,-1*rect_size
		db	3
		db	-2*rect_size,0*rect_size
		db	0*rect_size,2*rect_size
		db	2*rect_size,0*rect_size
		db	0*rect_size,-2*rect_size
		db 	3
		db	-1*rect_size,0*rect_size
		db	0*rect_size,1*rect_size
		db	1*rect_size,0*rect_size
		db	0*rect_size,-1*rect_size
		db	3
		db	-2*rect_size,0*rect_size
		db	0*rect_size,2*rect_size
		db	2*rect_size,0*rect_size
		db	0*rect_size,-2*rect_size
		

; enemy shoot
; ENEMY_SHOOT
grafix_enemy_shoot:
		db 	3
		db	-1*rect_size,0*rect_size
		db	0*rect_size,1*rect_size
		db	1*rect_size,0*rect_size
		db	0*rect_size,-1*rect_size
		db	3
		db	-2*rect_size,0*rect_size
		db	0*rect_size,2*rect_size
		db	2*rect_size,0*rect_size
		db	0*rect_size,-2*rect_size
		db 	3
		db	-1*rect_size,0*rect_size
		db	0*rect_size,1*rect_size
		db	1*rect_size,0*rect_size
		db	0*rect_size,-1*rect_size
		db	3
		db	-2*rect_size,0*rect_size
		db	0*rect_size,2*rect_size
		db	2*rect_size,0*rect_size
		db	0*rect_size,-2*rect_size


; boss grafix ... 
grafix_enemyboss:

;    ^
;   /\/
;  /\/\

grafix_bigboss:


grbigboss_size	equ	8

; size = 9*8 = 72
;


		db 	3
		db	 9*grbigboss_size,4*grbigboss_size
		db	 -9*grbigboss_size,-2*grbigboss_size
		db	 9*grbigboss_size,-2*grbigboss_size
		db	 -9*grbigboss_size,4*grbigboss_size

		db 	3
		db	 7*grbigboss_size,4*grbigboss_size
		db	 -7*grbigboss_size,-2*grbigboss_size
		db	 7*grbigboss_size,-2*grbigboss_size
		db	 -7*grbigboss_size,4*grbigboss_size

		db 	3
		db	 5*grbigboss_size,4*grbigboss_size
		db	 -5*grbigboss_size,-2*grbigboss_size
		db	 5*grbigboss_size,-2*grbigboss_size
		db	 -5*grbigboss_size,4*grbigboss_size

		db 	3
		db	 6*grbigboss_size,4*grbigboss_size
		db	 -6*grbigboss_size,-2*grbigboss_size
		db	 6*grbigboss_size,-2*grbigboss_size
		db	 -6*grbigboss_size,4*grbigboss_size


; grafix_enemy_stay
grafix_enemy_stay:


		db 	3
		db	9*rect_size, 3*rect_size
		db	-11*rect_size, -2*rect_size
		db	 11*rect_size,  2*rect_size
		db  -9*rect_size, 3*rect_size	

		db 	3
		db	10*rect_size, 3*rect_size
		db	-12*rect_size, -2*rect_size
		db	 12*rect_size,  2*rect_size
		db  -10*rect_size, 3*rect_size	

		db 	3
		db	13*rect_size, 3*rect_size
		db	-15*rect_size, -2*rect_size
		db	 15*rect_size,  2*rect_size
		db  -13*rect_size, 3*rect_size	

		db 	3
		db	12*rect_size, 3*rect_size
		db	-14*rect_size, -2*rect_size
		db	 14*rect_size,  2*rect_size
		db  -12*rect_size, 3*rect_size	



; grafix_enemy_stayshoot
grafix_enemy_stayshoot:

rect_size_stay equ 4

		db 	3
		db	 9*rect_size_stay,2*rect_size_stay
		db	 -11*rect_size_stay,1*rect_size_stay
		db	 4*rect_size_stay,-4*rect_size_stay
		db	 -3*rect_size_stay,5*rect_size_stay

		db 	3
		db	 8*rect_size_stay,2*rect_size_stay
		db	 -9*rect_size_stay,1*rect_size_stay
		db	 4*rect_size_stay,-4*rect_size_stay
		db	 -3*rect_size_stay,5*rect_size_stay

		db 	3
		db	 6*rect_size_stay,2*rect_size_stay
		db	 -7*rect_size_stay,1*rect_size_stay
		db	 4*rect_size_stay,-4*rect_size_stay
		db	 -3*rect_size_stay,5*rect_size_stay


		db 	3
		db	 8*rect_size_stay,2*rect_size_stay
		db	 -9*rect_size_stay,1*rect_size_stay
		db	 4*rect_size_stay,-4*rect_size_stay
		db	 -3*rect_size_stay,5*rect_size_stay



; grafix_enemy_missile
grafix_enemymissile:

;---------------------PART 0--Ebene_1--------------
	db 3
	db 2,-6 
	db 11,5 
	db -12,4 
	db 2,-6 

;---------------------PART 1--base_2_--------------
	db 3
	db 1,-3 
	db 7,3 
	db -7,3 
	db 1,-4 

;---------------------PART 2--base_1_--------------
	db 3
	db 1,-2 
	db 5,2 
	db -5,2 
	db 1,-3 

	db 3
	db 1,-2 
	db 5,2 
	db -5,2 
	db 1,-3 
		
; grafix_enemydiag
grafix_enemydiag:


rect_sizedialog equ 4


		db 	3
		db	2*rect_sizedialog, -1*rect_sizedialog
		db	1*rect_sizedialog,  2*rect_sizedialog
		db	-3*rect_sizedialog, -1*rect_sizedialog
		db	 3*rect_sizedialog,0*rect_sizedialog

		db 	3
		db	2*rect_sizedialog,  0*rect_sizedialog
		db	1*rect_sizedialog,  1*rect_sizedialog
		db	-3*rect_sizedialog, -1*rect_sizedialog
		db	 3*rect_sizedialog,0*rect_sizedialog

		db 	3
		db	2*rect_sizedialog,  0*rect_sizedialog
		db	1*rect_sizedialog,  -1*rect_sizedialog
		db	-3*rect_sizedialog,  1*rect_sizedialog
		db	 3*rect_sizedialog,0*rect_sizedialog

		db 	3
		db	2*rect_sizedialog,  1*rect_sizedialog
		db	1*rect_sizedialog,  -2*rect_sizedialog
		db	-3*rect_sizedialog,  1*rect_sizedialog
		db	 3*rect_sizedialog,0*rect_sizedialog


; enemy: twin
; 
grafix_enemy_1:


grafix_enemyleftright:
;   _
;  | |
;  |
;

		db 	3
		db	 (9-0)*rect_size_fast,(4-0)*rect_size_fast
		db	 (-10+0)*rect_size_fast,(-2+0)*rect_size_fast
		db	 (4-0)*rect_size_fast,(-3+0)*rect_size_fast
		db	 (-5+0)*rect_size_fast,(1-0)*rect_size_fast

		db 	3
		db	 (9-1)*rect_size_fast,(4-1)*rect_size_fast
		db	 (-9+1)*rect_size_fast,(-2+1)*rect_size_fast
		db	 (4-1)*rect_size_fast,(-3+0)*rect_size_fast
		db	 (-4+1)*rect_size_fast,(1-0)*rect_size_fast

		db 	3
		db	 (9-1)*rect_size_fast,(4-2)*rect_size_fast
		db	 (-9+1)*rect_size_fast,(-2+2)*rect_size_fast
		db	 (4-1)*rect_size_fast,(-3+0)*rect_size_fast
		db	 (-4+1)*rect_size_fast,(1-0)*rect_size_fast

		db 	3
		db	 (9-1)*rect_size_fast,(4-1)*rect_size_fast
		db	 (-9+1)*rect_size_fast,(-2+1)*rect_size_fast
		db	 (4-1)*rect_size_fast,(-3+0)*rect_size_fast
		db	 (-4+1)*rect_size_fast,(1-0)*rect_size_fast



; used?
grafix_enemy_down:

;  ____
;  \  /
;  
;

		db 	2
		db	6*rect_size,-1*rect_size
		db	0*rect_size,5*rect_size
		db	-6*rect_size,-1*rect_size
		db	 6*rect_size,-1*rect_size

		db 	3
		db	-1*rect_size,0*rect_size
		db	6*rect_size,-1*rect_size
		db	2*rect_size,4*rect_size
		db	-6*rect_size,-1*rect_size

		db 	3
		db	-2*rect_size,0*rect_size
		db	4*rect_size,-1*rect_size
		db	2*rect_size,3*rect_size
		db	-8*rect_size,-1*rect_size

		db 	3
		db	2*rect_size,0*rect_size
		db	6*rect_size,-1*rect_size
		db	-3*rect_size,5*rect_size
		db	-6*rect_size,-1*rect_size

	
; enemy: twin
grafix_enemy_sin:  ; sinus!

;  _
; | | 
;  -
;

		db 	3
		db	6*rect_size,   4*rect_size
		db	-7*rect_size, -3*rect_size
		db	 7*rect_size,  -3*rect_size
		db  -6*rect_size,  4*rect_size	

		db 	3
		db	6*rect_size,   3*rect_size
		db	-7*rect_size, -2*rect_size
		db	 9*rect_size,  -3*rect_size
		db  -7*rect_size,  4*rect_size	

		db 	3
		db	6*rect_size,   2*rect_size
		db	-7*rect_size, -1*rect_size
		db	 10*rect_size,  -3*rect_size
		db  -8*rect_size,  4*rect_size	

		db 	3
		db	6*rect_size,   3*rect_size
		db	-7*rect_size, -2*rect_size
		db	 9*rect_size,  -3*rect_size
		db  -7*rect_size,  4*rect_size	







;  _
; | |
; �_� 
;  |
; ---
;|| ||
; |_|  
; | | 
; | | 
;

; cool sprite big boss
;		db 	3
;		db	 9*rect_size,4*rect_size
;		db	 -9*rect_size,-2*rect_size
;		db	 5*rect_size,-2*rect_size
;		db	 -5*rect_size,4*rect_size

grafix_fastdownenemy:

rect_size_fast equ 2

		db 	3
		db	 ( 3+1)*rect_size_fast,(3+1)*rect_size_fast
		db	 (-6+0)*rect_size_fast,(-1+0)*rect_size_fast
		db	 ( 6-0)*rect_size_fast,(-1+0)*rect_size_fast
		db	 (-3+0)*rect_size_fast,( 3-0)*rect_size_fast

		db 	3
		db	 ( 3+1)*rect_size_fast,(3+1)*rect_size_fast
		db	 (-6+0)*rect_size_fast,(-1+0)*rect_size_fast
		db	 ( 6-0)*rect_size_fast,(-1+0)*rect_size_fast
		db	 (-3+0)*rect_size_fast,( 3+0)*rect_size_fast

		db 	3
		db	 ( 3-0)*rect_size_fast,(3-0)*rect_size_fast
		db	 (-6+0)*rect_size_fast,(-1+0)*rect_size_fast
		db	 ( 6-0)*rect_size_fast,(-1+0)*rect_size_fast
		db	 (-3-1)*rect_size_fast,( 3+1)*rect_size_fast

		db 	3
		db	 ( 3-0)*rect_size_fast,(3-0)*rect_size_fast
		db	 (-6+0)*rect_size_fast,(-1+0)*rect_size_fast
		db	 ( 6-0)*rect_size_fast,(-1+0)*rect_size_fast
		db	 (-3-1)*rect_size_fast,( 3+1)*rect_size_fast


grafix_downsearch:

rect_size_fastdown equ 3

		
		db 	3
		db	 ( 3+1)*rect_size_fast,(3+1)*rect_size_fast
		db	 (-3+0)*rect_size_fast,(-1+0)*rect_size_fast
		db	 ( 3-0)*rect_size_fast,(-1+0)*rect_size_fast
		db	 (-3+0)*rect_size_fast,( 3+0)*rect_size_fast

		db 	3
		db	 ( 3-0)*rect_size_fastdown,(3-0)*rect_size_fastdown
		db	 (-3+0)*rect_size_fastdown,(-1+0)*rect_size_fastdown
		db	 ( 3-0)*rect_size_fastdown,(-1+0)*rect_size_fastdown
		db	 (-3-1)*rect_size_fastdown,( 3+1)*rect_size_fastdown

		db 	3
		db	 ( 3-0)*rect_size_fast,(3-0)*rect_size_fast
		db	 (-3+0)*rect_size_fast,(-1+0)*rect_size_fast
		db	 ( 3-0)*rect_size_fast,(-1+0)*rect_size_fast
		db	 (-3-1)*rect_size_fast,( 3+1)*rect_size_fast

		db 	3
		db	 ( 3-0)*rect_size_fastdown,(3-0)*rect_size_fastdown
		db	 (-3+0)*rect_size_fastdown,(-1+0)*rect_size_fastdown
		db	 ( 3-0)*rect_size_fastdown,(-1+0)*rect_size_fastdown
		db	 (-3-1)*rect_size_fastdown,( 3+1)*rect_size_fastdown



; der stier

		db 	3
		db	5*rect_size_pong, 1*rect_size_pong
		db	-3*rect_size_pong, 5*rect_size_pong
		db	 5*rect_size_pong,  -3*rect_size_pong
		db  -6*rect_size_pong, 1*rect_size_pong	



grafix_enemy_ship: 



;
; /\ ping pong 
;
	
rect_size_pong equ 3	

	
; submarine
;  _|_____
;	|_____\
;
	
		db 	3
		db	1*rect_size_pong, 8*rect_size_pong
		db	-2*rect_size_pong, 2*rect_size_pong
		db	 0*rect_size_pong,-8*rect_size_pong
		db  5*rect_size_pong,0*rect_size_pong

		db 	3
		db	1*rect_size_pong, 8*rect_size_pong
		db	-2*rect_size_pong, 2*rect_size_pong
		db	 0*rect_size_pong,-8*rect_size_pong
		db  5*rect_size_pong,0*rect_size_pong


		db 	3
		db	1*rect_size_pong, 8*rect_size_pong
		db	-2*rect_size_pong, 2*rect_size_pong
		db	 0*rect_size_pong,-8*rect_size_pong
		db  6*rect_size_pong,0*rect_size_pong


		db 	3
		db	1*rect_size_pong, 8*rect_size_pong
		db	-2*rect_size_pong, 2*rect_size_pong
		db	 0*rect_size_pong,-8*rect_size_pong
		db  5*rect_size_pong,0*rect_size_pong


; 
; boat   
;  _|______
;	|_____/
;
		db 	3
		db	2*rect_size_pong, 8*rect_size_pong
		db	-3*rect_size_pong, -2*rect_size_pong
		db	 0*rect_size_pong,-5*rect_size_pong
		db  3*rect_size_pong,0*rect_size_pong


		
; demo		
grafix_quad: ; logo vw 10
		db 	3
		db	20*rect_size,00*rect_size
		db	0*rect_size,20*rect_size
		db 	-20*rect_size,0*rect_size
		db 	0*rect_size,-20*rect_size
		
; explosion		
grafix_explosion: ; logo vw 10


	db 3
	db 2,-2 
	db 2,3 
	db -3,2 
	db -2,-3 
	
	db 3
	db 6,-6 
	db 6,9 
	db -9,7 
	db -6,-9 
	
	db 3
	db 4,-3 
	db 3,5 
	db -5,4 
	db -3,-5 
	
	db 0
	db 1,1 
	db 2,3 
	db -3,2 
	db -2,-3 




; titlescreen
; logo

logo:	

	db 46
	db 0,0 
	db 0,1 
	db 0,42 
	db 7,0 
	db 0,-27 
	db 28,0 
	db 0,8 
	db -35,-1 
	db 0,20 
	db 35,0 
	db 0,8 
	db -28,0 
	db 0,-8 
	db 0,55 
	db -7,0 
	db 0,-34 
	db 36,0 
	db 0,34 
	db -9,0 
	db 0,-27 
	db -5,0 
	db 0,21 
	db -7,0 
	db 0,-21 
	db -8,0 
	db 0,75 
	db -7,0 
	db 0,-34 
	db 36,0 
	db 0,34 
	db -8,0 
	db 0,-27 
	db -21,0 
	db 0,48 
	db 14,0 
	db 0,28 
	db 14,0 
	db 0,-35 
	db -7,0 
	db 0,27 
	db -14,0 
	db 0,-27 
	db -13,0 
	db 0,35 
	db 6,0 
	db 0,-28 
	db 0,46


; the monster with the open mound!
;position:
;	db -104,-98
grafix_monster:
	db 7
	db 0,0 
	db 46,10 
	db -13,39 
	db 36,-21 
	db 59,53 
	db -21,30 
	db 42,-17
	
; eyes
;position:
;	db -10,-74
grafix_eye0:
	db 2
	db 17,11 
	db -16,13 
	db -1,-24
grafix_eye1:
	db 2
	db 11,-23 
	db 0,19 
	db -11,4
; db 17,-31
grafix_eye2:
	db 2
	db 13,-8 
	db 1,15 
	db -14,-7
; 	db -33,-79
grafix_eye3:
	db 2
	db 14,-8 
	db 0,15 
	db -14,-7
	
; game won
;position_5:
;db -102,-105

grafix_won:
	db 9
	db 47,13 
	db -4,20 
	db 9,0 
	db 0,6 
	db 17,-8 
	db 61,57 
	db -4,7 
	db 7,0 
	db -3,8 
	db 19,-7 
	
;***************************************************************************
; DATA SECTION (EPROM): LEVELS
;***************************************************************************
; 	[-110  110]
;   ENDTAG: 0,0 

;***************************************************************************
;PREDEFINED MOVEMENTS
;***************************************************************************

sinus_movement:
		db	-1,-2,-2,-3,-2,-2,-1,0,1,2,2,3,2,2,1
		
; another movement
strange_movement:
		db	0,-1,-1,-3,-4,-5,-1,0,1,2,2,3,2,2,1

;***************************************************************************
;PREDEFINED LEVELS
;***************************************************************************


		; generate with an external tool ...
		; add position_offset/direction ...
		; [x,y] {newtype,newtypesub, newx,newy, how_many_sprites+1 , spwawn_offset  }
		; attention add on: 
		;  newtype:
		;
		; 		6: text [] 
		;  		7: next level (kill all sprites!)
		;

leveldata: ; 12 stripes void

; VecZLevelEditor: level exported


	db -113,109,0,ENEMY_FASTDOWN,0,0,0,0  
	db -74,62,0,ENEMY_FASTDOWN,0,0,0,0  
	db -113,96,0,ENEMY_FASTDOWN,0,0,0,0  
	db -66,50,0,ENEMY_FASTDOWN,0,0,0,0  
	db -100,103,0,1,0,0,0,0  
	db -65,69,0,1,0,0,0,0  
	db -113,100,0,1,0,0,0,0  
	db -43,48,0,1,0,0,0,0  
	db -102,97,0,1,-6,0,0,20  
	db -52,47,0,ENEMY_FASTDOWN,0,0,0,0  
	db -82,99,0,ENEMY_FASTDOWN,0,0,0,0  
	db -64,82,0,ENEMY_FASTDOWN,0,0,0,0  
	db -80,82,0,1,100,0,0,0  
	db -52,68,OBJ_TYPE_MESSAGE,1,-63,0,0,0  
	db -34,75,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,13,0,0,0  
	db -77,50,OBJ_TYPE_ENEMY,ENEMY_STAY,5,0,0,20  
	db -62,75,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,-14,0,0,30  
	db -76,76,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,-20,0,1,0  
	db -29,76,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,26,0,0,20  
	db -29,74,OBJ_TYPE_ENEMY,ENEMY_DOWN,-5,0,0,10  
	db -28,65,OBJ_TYPE_ENEMY,ENEMY_DOWN,38,0,0,20  
	db -59,62,OBJ_TYPE_ENEMY,ENEMY_DOWN,-8,0,0,0  
	db -64,61,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,4,0,0,20  
	db -72,64,OBJ_TYPE_ENEMY,ENEMY_SINUS,-27,0,1,20  
	db -47,85,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,8,0,1,30  
	db -55,72,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,-19,0,0,0  
	db -67,45,OBJ_TYPE_ENEMY,ENEMY_STAY,-9,0,0,0  
	db -71,76,OBJ_TYPE_ENEMY,ENEMY_DOWN,-32,0,1,50  
	db -45,69,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,6,0,1,30  
	db -39,69,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,-34,0,2,30  
	db -103,60,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-36,0,0,0  
	db -77,25,OBJ_TYPE_MESSAGE,ENEMY_FASTDOWN,0,0,0,0  
	db -75,66,OBJ_TYPE_ENEMY,ENEMY_SINUS,-28,0,1,20  
	db -78,74,OBJ_TYPE_ENEMY,ENEMY_DOWN,19,0,1,30  
	db -98,88,OBJ_TYPE_ENEMY,ENEMY_DOWN,-8,0,0,0  
	db -70,87,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-45,0,0,0  
	db 9,63,OBJ_TYPE_ENEMY,ENEMY_SHOOT,18,0,0,0  
	db -50,67,OBJ_TYPE_ENEMY,ENEMY_SHOOT,-25,0,0,0  
	db -51,69,OBJ_TYPE_ENEMY,ENEMY_DOWN,19,0,0,0  
	db -78,64,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-19,0,0,0  
	db -95,60,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,-2,0,2,20  
	db -95,63,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-72,0,0,0  
	db -92,63,OBJ_TYPE_ENEMY,ENEMY_DOWNSEARCH,26,0,0,30  
	db -58,60,OBJ_TYPE_ENEMY,ENEMY_SINUS,-33,0,1,30  
	db -50,53,OBJ_TYPE_ENEMY,ENEMY_SHOOT,-21,0,0,0  
	db -71,65,OBJ_TYPE_MESSAGE,ENEMY_MISSILE,-64,0,0,0  
	db -61,62,OBJ_TYPE_ENEMY,ENEMY_DOWN,-6,0,1,30  
	db -61,72,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,-34,0,1,50  
	db -57,67,OBJ_TYPE_ENEMY,ENEMY_DOWN,-16,0,1,10  
	db -97,67,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-37,0,0,50  
	db -15,62,OBJ_TYPE_ENEMY,ENEMY_SHOOT,13,0,0,0  
	db -30,44,OBJ_TYPE_ENEMY,ENEMY_SINUS,0,0,0,30  
	db -22,38,OBJ_TYPE_ENEMY,ENEMY_DOWNSEARCH,0,0,1,20  
	db -22,92,OBJ_TYPE_ENEMY,ENEMY_SINUS,-5,0,1,20  
	db -69,100,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,-21,0,2,20  
	db -63,101,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-32,0,0,50  
	db -56,79,OBJ_TYPE_ENEMY,ENEMY_DOWN,8,0,1,20  
	db -54,62,OBJ_TYPE_ENEMY,ENEMY_SHOOT,-8,0,1,0  
	db -61,62,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,-15,0,1,20  
	db -74,42,OBJ_TYPE_ENEMY,ENEMY_SHOOT,-4,0,1,30  
	db -85,38,OBJ_TYPE_ENEMY,ENEMY_SHOOT,-51,0,2,30  
	db -32,29,OBJ_TYPE_ENEMY,ENEMY_DOWNSEARCH,73,0,1,20  
	db -57,57,OBJ_TYPE_ENEMY,ENEMY_DOWN,0,0,1,10  
	db -60,108,OBJ_TYPE_MESSAGE,ENEMY_DOWN,-36,0,0,0  
	db -63,112,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-29,0,0,50  
	db -32,57,OBJ_TYPE_ENEMY,ENEMY_SINUS,18,0,1,20  
	db -44,83,OBJ_TYPE_ENEMY,ENEMY_SINUS,-21,0,2,30  
	db -55,37,OBJ_TYPE_ENEMY,ENEMY_STAY,-17,0,0,0  
	db -72,24,0,ENEMY_DOWN,-32,0,1,30  
	db -85,20,OBJ_TYPE_ENEMY,ENEMY_SINUS,-58,0,0,0  
	db -90,16,OBJ_TYPE_ENEMY,ENEMY_SINUS,-28,0,1,10  
	db -93,-9,OBJ_TYPE_ENEMY,ENEMY_LEFT,49,0,2,30  
	db -99,-3,OBJ_TYPE_ENEMY,ENEMY_SINUS,-75,0,1,30  
	db -84,67,OBJ_TYPE_ENEMY,ENEMY_STAY,-47,0,0,30  
	db -71,59,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-66,0,0,30  
	db -45,18,OBJ_TYPE_MESSAGE,ENEMY_FASTDOWN,-9,0,0,0  
	db -89,53,OBJ_TYPE_ENEMY,ENEMY_DOWNSEARCH,-30,0,1,30  
	db -99,49,OBJ_TYPE_ENEMY,ENEMY_SHOOT,-47,0,2,20  
	db -84,32,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-81,0,0,0  
	db -76,35,OBJ_TYPE_ENEMY,ENEMY_SHOOT,-5,0,0,0  
	db -39,35,OBJ_TYPE_ENEMY,ENEMY_DOWNSEARCH,-9,0,1,20  
	db -41,25,OBJ_TYPE_ENEMY,ENEMY_STAYSHOOT,48,0,0,0  
	db -54,14,OBJ_TYPE_ENEMY,ENEMY_DOWN,-29,0,2,20  
	db -40,11,OBJ_TYPE_ENEMY,ENEMY_SHOOT,-28,0,0,0  
	db -40,24,OBJ_TYPE_ENEMY,ENEMY_STAYSHOOT,-74,0,0,30  
	db -39,38,OBJ_TYPE_ENEMY,ENEMY_SINUS,-13,0,1,20  
	db -26,52,OBJ_TYPE_ENEMY,ENEMY_DOWN,-15,0,1,30  
	db -10,70,OBJ_TYPE_MESSAGE,ENEMY_SINUS,0,0,1,30  
	db 14,86,OBJ_TYPE_ENEMY,ENEMY_SINUS,23,0,1,20  
	db -35,86,OBJ_TYPE_ENEMY,ENEMY_SHOOT,22,0,1,20  
	db -38,82,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-27,0,0,0  
	db -26,56,OBJ_TYPE_ENEMY,ENEMY_DOWN,0,0,1,10  
	db -23,48,OBJ_TYPE_ENEMY,ENEMY_LEFT,64,0,0,0  
	db -32,45,OBJ_TYPE_ENEMY,ENEMY_SINUS,-10,0,1,30  
	db -43,42,OBJ_TYPE_ENEMY,ENEMY_SINUS,3,0,1,30  
	db -47,27,OBJ_TYPE_ENEMY,ENEMY_DOWN,-34,0,2,20  
	db -36,25,OBJ_TYPE_ENEMY,ENEMY_STAY,-29,0,1,30  
	db -35,38,OBJ_TYPE_ENEMY,ENEMY_LEFT,-105,0,2,20  
	db -31,44,OBJ_TYPE_ENEMY,ENEMY_DOWNSEARCH,-20,0,1,20  
	db -39,40,OBJ_TYPE_ENEMY,ENEMY_RIGHT,71,0,2,30  
	db -22,40,OBJ_TYPE_ENEMY,ENEMY_DOWN,-26,0,2,20  
	db 3,33,OBJ_TYPE_ENEMY,ENEMY_SHOOT,10,0,1,30  
	db -34,50,OBJ_TYPE_MESSAGE,ENEMY_FASTDOWN,0,0,0,0  
	db -41,63,OBJ_TYPE_ENEMY,ENEMY_SHOOT,12,0,1,20  
	db -56,66,OBJ_TYPE_ENEMY,ENEMY_DOWNSEARCH,-6,0,1,30  
	db -61,66,OBJ_TYPE_ENEMY,ENEMY_STAY,-8,0,0,30  
	db -63,66,OBJ_TYPE_ENEMY,ENEMY_SHOOT,13,0,1,30  
	db -50,64,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-45,0,1,30  
	db -61,59,OBJ_TYPE_ENEMY,ENEMY_STAYSHOOT,85,0,0,50  
	db -59,49,OBJ_TYPE_ENEMY,ENEMY_DOWN,-6,0,0,50  
	db -40,43,OBJ_TYPE_ENEMY,ENEMY_DOWN,-23,0,1,30  
	db 26,67,0,ENEMY_BOSS,-101,0,0,30  
	db 7,78,OBJ_TYPE_ENEMY,ENEMY_STAY,46,0,0,0  
	db 4,93,OBJ_TYPE_ENEMY,ENEMY_STAY,34,0,0,0  
	db 4,102,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,13,0,0,0  
	db -103,78,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-7,0,0,0  
	db -92,-36,OBJ_TYPE_ENEMY,ENEMY_SHOOT,21,0,2,30  
	db -103,-11,OBJ_TYPE_ENEMY,ENEMY_SINUS,21,0,0,0  
	db -103,-48,OBJ_TYPE_ENEMY,ENEMY_SINUS,0,0,2,30  
	db -103,-10,OBJ_TYPE_ENEMY,ENEMY_DOWN,21,0,0,0  
	db -103,-51,OBJ_TYPE_ENEMY,ENEMY_FASTDOWN,0,0,0,0  
	db -86,-35,0,1,0,0,0,0  
	db -77,-27,OBJ_TYPE_ENEMY,ENEMY_STAY,-66,0,0,0  
	db -74,-18,OBJ_TYPE_ENEMY,ENEMY_STAY,-63,0,1,20  
	db -79,70,OBJ_TYPE_ENEMY,ENEMY_SHOOT,-49,0,0,0  
	db -97,112,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-66,0,1,30  
	db -53,79,0,ENEMY_FASTDOWN,0,0,0,0  
	db -101,109,OBJ_TYPE_ENEMY,ENEMY_SHOOT,-40,0,2,20  
	db -79,76,OBJ_TYPE_ENEMY,ENEMY_SHOOT,-63,0,1,30  
	db -81,85,0,ENEMY_FASTDOWN,0,0,0,0  
	db -96,82,OBJ_TYPE_ENEMY,ENEMY_DIAG,-103,0,0,0  
	db -105,88,OBJ_TYPE_ENEMY,ENEMY_STAY,0,0,0,0  
	db -111,94,OBJ_TYPE_ENEMY,ENEMY_DIAG,-106,0,1,20  
	db -114,111,OBJ_TYPE_ENEMY,ENEMY_PINGPONG,-50,0,1,50  
	db -114,113,OBJ_TYPE_ENEMY,ENEMY_SINUS,-59,0,2,30  
	db -114,114,OBJ_TYPE_ENEMY,ENEMY_BOSS,0,0,0,0  
	db -113,114,0,1,0,0,0,0  
	db -89,-84,0,ENEMY_STAYSHOOT,55,0,0,0  


;***************************************************************************
; DATA SECTION (EPROM): TEXTS
;***************************************************************************

; texts	& display text     	

; string title (-115)
string_title:
     	DB 60,-125,"ooo VECZ 2o16 ooo ", $80		
string_menu_play:
     	DB -30,-40,"o ENTER  ", $80		
string_menu_code:
     	DB 120,-125,"CODE_DESIGN_LA1N.CH__", $80		

string_menu_credits:
     	DB -100,-125,"  ++ TIME TO DIE +++", $80		

string_won:
     	DB 60,-120,"+++VECZ+DESTROYED+++++", $80		

string_pressbutton:
     	DB -30,-40,"o MENU", $80		


	
string_gameover:
     	DB 60,-120,"+++++GAME+OVER++++++", $80		

string_title_short:
     	DB 120,-120,"ooo------", $80		

; ---------------------------------------------------
; level strings
; ---------------------------------------------------
str_level0:
;                 "--------------------"
     	DB 40,-120," 1. WAITING FOR YOU   ", $80	 
str_level1:
     	DB 40,-120,"   2. TINY YOU ARE    ", $80		
str_level2:
     	DB 40,-120,"     3. YOU DARE?     ", $80		
str_level3:
     	DB 40,-120,"    4. TAKE THIS     ", $80		
str_level4:
     	DB 40,-120,"    5. GRRRRRRRR     ", $80		
str_level5:
     	DB 40,-120,"  6. THINK, SO EASY? ", $80		
str_level6:
     	DB 40,-120,"     7. GIGER TIME    ", $80		
str_level7:
     	DB 40,-120,"    8. CRUNCH TIME    ", $80		
       
;***************************************************************************
; DATA SECTION (EPROM): SOUNDs
;***************************************************************************

;
; http://vectrexmuseum.com/share/coder/other/TEXT/SOUND/ADSR_ROM.TXT
; http://www.playvectrex.com/designit/chrissalo/soundplaying.htm
; http://vectrexmuseum.com/share/coder/html/soundplaying.htm
; example: http://www.playvectrex.com/designit/chrissalo/sound2.asm
;
; MUSIC-TRACKER: ArkosTracker
;
; AY-CHIP SOUNDCHIP
; > AYFX Editor SOUNDTOOL
; https://www.youtube.com/watch?v=XI6aW2QSUXw
; 
;
;  	0*128+1, 12  ;  (channel*128) + note, length
;  	1*128+1, 12  ;  (channel*128) + note, length
;   19, $80 
; 

; channel 0: explosion
; channel 1: shoot
; channel 2: music

music_title:
                FDB     $FEE8, $FEB6            ; ADSR and twang address tables, in Vectrex ROM
                FCB     2,12                    ;;;;;;;;
                FCB     0,12                    ; first byte is a note, to be
                FCB     2,12                    ; found in vectrex rom, is a
                FCB     0,12                    ; 64 byte table...
                FCB     2,6                     ; last byte is length of note
                FCB     0,6
                FCB     2,6
                FCB     0,6
                FCB     2,6
                FCB     0,6
                FCB     2,12
                FCB     0,12                    ;;;;;;;;
                FCB     2,12
                FCB     0,12
                FCB     2,12
                FCB     0,12                    ;;;;;;;;
                FCB     2,6
                FCB     0,6
                FCB     2,6
                FCB     0,6
                FCB     2,6
                FCB     0,6
                FCB     2,6                     ;;;;;;;;
                FCB     0,6
                FCB     2,12
                FCB     0,12
                FCB     128+2,128+26,26-12, 12  ;
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     128+2,128+31,31-12, 12  ; a 128 means the next byte is
                FCB     128+0,128+33,33-12, 12  ; a note for the next channel
                FCB     128+2,128+35,35-12, 12  ; channel...
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     128+2,128+35,35-12, 12
                FCB     128+0,128+33,33-12, 12
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     128+2,128+31,31-12, 12
                FCB     128+0,128+33,33-12, 12
                FCB     128+2,128+35,35-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     2,12
                FCB     128+0,128+30,30-12, 12
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     128+2,128+31,31-12, 12
                FCB     128+0,128+33,33-12, 12
                FCB     128+2,128+35,35-12, 12
                FCB     128+0,128+36,36-12, 12  ;;;;;;;;
                FCB     128+2,128+35,35-12, 12
                FCB     128+0,128+33,33-12, 12
                FCB     128+2,128+31,31-12, 12
                FCB     128+0,128+30,30-12, 12  ;;;;;;;;
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+28,28-12, 12
                FCB     128+2,128+30,30-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     2, 12
                FCB     128+0,128+31,31-12, 12
                FCB     2, 12
                FCB     128+0,128+28,28-12, 18  ;;;;;;;;
                FCB     128+30,30-12, 06
                FCB     128+2,128+28,28-12, 12
                FCB     128+0,128+26,26-12, 12
                FCB     128+2,128+28,28-12, 12  ;;;;;;;;
                FCB     128+0,128+30,30-12, 12
                FCB     128+2,128+31,31-12, 12
                FCB     0, 12
                FCB     128+0,128+26,26-12, 18  ;;;;;;;;
                FCB     128+28,28-12, 06
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+24,24-12, 12
                FCB     128+2,128+23,23-12, 12  ;;;;;;;;
                FCB     0, 12
                FCB     128+2,128+26,26-12, 12
                FCB     0, 12
                FCB     128+2,128+28,28-12, 18  ;;;;;;;;
                FCB     128+30,30-12, 06
                FCB     128+0,128+28,28-12, 12
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+28,28-12, 12  ;;;;;;;;
                FCB     128+2,128+30,30-12, 12
                FCB     128+0,128+31,31-12, 12
                FCB     128+2,128+28,28-12, 12
                FCB     128+0,128+26,26-12, 12  ;;;;;;;;
                FCB     128+2,128+31,31-12, 12
                FCB     128+0,128+30,30-12, 12
                FCB     128+2,128+33,33-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     2, 12
                FCB     128+0,128+31,31-12, 12
                FCB     2, 12
                FCB     19, $80                 ; $80 is end marker for music
                                                ; (high byte set)

music_bonbon:	
		; instrument & 
		; fdb	$FEE8, $FEB6            ; ADSR and twang address tables, in Vectrex ROM
		fdb	$FEEE, $FEB6            ; ADSR and twang address tables, in Vectrex ROM
        fcb     2,6
		fcb     0,12                    ;;;;;;;;
        fcb 19, $80                 ; $80 is end marker for music

music_shoot:	

		; version 1.0
		; instrument & 
		; fdb	$FEE8, $FEB6            ; ADSR and twang address tables, in Vectrex ROM
		fdb	$FEEE, $FEB6            ; ADSR and twang address tables, in Vectrex ROM
        fcb     10,1
		fcb     2,1                    ;;;;;;;;
        fcb     128+10,1
		fcb     128+2,1                    ;;;;;;;;
        fcb     128+1, $80                 ; $80 is end marker for music

music_explosion
		; instrument & 
		; fdb	$FEE8, $FEB6            ; ADSR and twang address tables, in Vectrex ROM
		fdb	$FEEE, $FEB6            ; ADSR and twang address tables, in Vectrex ROM
        fcb     1,12
		fcb     3,6                    ;;;;;;;;
		fcb     4,10                   ;;;;;;;;
		fcb 19, $80                 ; $80 is end marker for music


music_die:	
		; instrument & 
		; fdb	$FEE8, $FEB6            ; ADSR and twang address tables, in Vectrex ROM
		fdb	$FEEE, $FEB6            ; ADSR and twang address tables, in Vectrex ROM
        fcb     2,2
		fcb     0,1                    ;;;;;;;;
        fcb     2,2
        fcb 19, $80                 ; $80 is end marker for music

music_levelup:	
		; instrument & 
		; fdb	$FEE8, $FEB6            ; ADSR and twang address tables, in Vectrex ROM
		fdb	$FEEE, $FEB6            ; ADSR and twang address tables, in Vectrex ROM
        fcb     2,20
		fcb     0,12                    ;;;;;;;;
        fcb     2,20
        fcb 19, $80                 ; $80 is end marker for music

; taken sound effects


sfx1:

  fcb $EE,$3C,$0,$C,$AE,$68,$0,$AE,$94,$0
  fcb $AE,$C0,$0,$AE,$EC,$0,$AE,$18,$1,$AE
  fcb $44,$1,$AD,$70,$1,$AD,$3C,$0,$AD,$68
  fcb $0,$AD,$94,$0,$AC,$C0,$0,$AC,$EC,$0
  fcb $AC,$18,$1,$AC,$44,$1,$AB,$70,$1,$AB
  fcb $3C,$0,$AB,$68,$0,$AB,$94,$0,$AA,$C0
  fcb $0,$AA,$EC,$0,$AA,$18,$1,$AA,$44,$1
  fcb $A9,$70,$1,$A9,$3C,$0,$A9,$68,$0,$A9
  fcb $94,$0,$A8,$C0,$0,$A8,$EC,$0,$A8,$18
  fcb $1,$A8,$44,$1,$A7,$70,$1,$A7,$3C,$0
  fcb $A7,$68,$0,$A7,$94,$0,$A6,$C0,$0,$A6
  fcb $EC,$0,$A6,$18,$1,$A6,$44,$1,$A5,$70
  fcb $1,$A5,$3C,$0,$A5,$68,$0,$A5,$94,$0
  fcb $A4,$C0,$0,$A4,$EC,$0,$A4,$18,$1,$A4
  fcb $44,$1,$A3,$70,$1,$A3,$3C,$0,$A3,$68
  fcb $0,$A3,$94,$0,$A2,$C0,$0,$A2,$EC,$0
  fcb $A2,$18,$1,$A2,$44,$1,$A1,$70,$1,$A1
  fcb $3C,$0,$A1,$68,$0,$A1,$94,$0,$A1,$C0
  fcb $0,$A1,$EC,$0,$A1,$18,$1,$A1,$44,$1
  fcb $A1,$70,$1,$A1,$3C,$0,$A1,$68,$0,$A1
  fcb $94,$0,$A1,$C0,$0,$A1,$EC,$0,$A1,$18
  fcb $1,$A1,$44,$1,$A1,$70,$1,$A1,$3C,$0
  fcb $A1,$68,$0,$A1,$94,$0,$A1,$C0,$0,$A1
  fcb $EC,$0,$A1,$18,$1,$A1,$44,$1,$D0,$20

sfx2:

  fcb $6F,$1,$4,$7,$F,$2F,$64,$0,$F,$2E
  fcb $5A,$0,$2E,$5C,$0,$2D,$5F,$0,$2D,$61
  fcb $0,$2C,$64,$0,$2C,$66,$0,$2B,$69,$0
  fcb $2B,$6B,$0,$2A,$6E,$0,$2A,$70,$0,$29
  fcb $73,$0,$29,$75,$0,$28,$78,$0,$28,$7A
  fcb $0,$27,$7D,$0,$27,$7F,$0,$26,$82,$0
  fcb $26,$84,$0,$25,$87,$0,$25,$89,$0,$24
  fcb $8C,$0,$24,$8E,$0,$23,$91,$0,$23,$93
  fcb $0,$22,$96,$0,$22,$98,$0,$21,$9B,$0
  fcb $D0,$20

sfx3:

  fcb $6F,$57,$0,$6,$4E,$C,$4D,$12,$4B,$18
  fcb $4A,$16,$49,$1C,$48,$2,$47,$8,$46,$E
  fcb $45,$14,$44,$1A,$43,$0,$42,$B,$41,$11
  fcb $41,$17,$D0,$20

sfx4:
  fcb $7F,$F7,$1,$1,$1F,$1F,$5C,$2,$5A,$1
  fcb $58,$2,$18,$56,$1,$52,$2,$12,$12,$D0
  fcb $20
  

; from frogger

;***************************************************************************
weirdos:
                 DW     $FDC3, $FEB6       ; piano
                 DW     $ED8F, $FEB6       ; minestorm
                 DW     $EFFF, $FEDC       ; psychadelic :-), a missread address, but what the heck
                                           ; it sounds weird!!!
                 DW     $FE28, $FD79       ; well, another one of those
                 DW     $FE66, $FEB6       ; video game beep
                 DW     $FEE8, $FEB6       ; organ with echo
weirdos_end:
;***************************************************************************
death_sound:
                 DW     $FEE8,$FEB6
                 DB     30+128,30+128,30,4
                 DB     20+128,20+128,20,6
                 DB     10+128,10+128,10,12
                 DB     0, $80
;***************************************************************************
frog_home_sound:
                 DW     $FE66, $FEB6
                 FCB    128+2,128+28,28-12, 12
                 FCB    128+0,128+26,26-12, 12
                 FCB    128+2,128+31,31-12, 12
                 FCB    128+0,128+30,30-12, 12
                 FCB    128+2,128+33,33-12, 12
                 FCB    128+0,128+31,31-12, 12
                 FCB    2, 12
                 FCB    128+0,128+31,31-12, 12
                 FCB    2, 12
                 FCB    19, $ff            ; $FF is end marker for music
;***************************************************************************
girl_got_sound:
                 DW     $FEE8,$FEB6
                 DB     40+128,40-12+128,40-12-12,4
                 DB     50+128,50-12+128,50-12-12,6
                 DB     60+128,60-12+128,60-12-12,12
                 DB     0, $80
;***************************************************************************
level_done_sound:
                 FDB     $FEE8,$FEB6             ; ADSR and twang address tables, in Vectrex ROM
                 FCB     128+2,128+26,26-12, 12  ;
                 FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                 FCB     128+2,128+31,31-12, 12  ; a 128 means the next byte is a note for the
                 FCB     128+0,128+33,33-12, 12  ; next channel...
                 FCB     128+2,128+35,35-12, 12
                 FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                 FCB     128+2,128+35,35-12, 12
                 FCB     128+0,128+33,33-12, 12
                 FCB     128+2,128+26,26-12, 12
                 FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                 FCB     128+2,128+31,31-12, 12
                 FCB     128+0,128+33,33-12, 12
                 FCB     128+2,128+35,35-12, 12
                 FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                 FCB     2,12
                 FCB     128+0,128+30,30-12, 12
                 FCB     128+2,128+26,26-12, 12
                 FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                 FCB     128+2,128+31,31-12, 12
                 FCB     128+0,128+33,33-12, 12
                 FCB     128+2,128+35,35-12, 12
                 FCB     128+0,128+36,36-12, 12  ;;;;;;;;
                 FCB     128+2,128+35,35-12, 12
                 FCB     128+0,128+33,33-12, 12
                 FCB     128+2,128+31,31-12, 12
                 FCB     128+0,128+30,30-12, 12  ;;;;;;;;
                 FCB     128+2,128+26,26-12, 12
                 FCB     128+0,128+28,28-12, 12
                 FCB     128+2,128+30,30-12, 12
                 FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                 FCB     2, 12
                 FCB     19, $ff           ; $FF is end marker for music
                                           ; (high byte set)



;***************************************************************************
triller1:
                 DW     $FEE8,$FEB6
                 DB     50+128,50-12+128,50-12-12,12
                 DB     0, $80
;***************************************************************************
triller2:
                 DW     $FEE8,$FEB6
                 DB     63+128,63-12+128,63-12-12,12
                 DB     0, $80
;***************************************************************************
frog_jump:
                 DW     $FEE8,$FEB6
                 DB     30+128,30+128,30,02
                 DB     30+12+128,30+12+128,30+12,03
                 DB     0, $80
;***************************************************************************
ta_ta_ta1:
                 DW     $FEE8,$FEB6
                 DB     30+128,30-12+128,30-12-12,8
                 DB     0+128,0+128,0,2
                 DB     32+128,32-12+128,32-12-12,8
                 DB     0+128,0+128,0,2
                 DB     34+128,34-12+128,34-12-12,30
                 DB     0, $80
;***************************************************************************
ta_ta_ta2:
                 DW     $FEE8,$FEB6
                 DB     40+128,40-12+128,40-12-12,8
                 DB     0+128,0+128,0,2
                 DB     42+128,42-12+128,42-12-12,8
                 DB     0+128,0+128,0,2
                 DB     44+128,44-12+128,44-12-12,8
                 DB     0+128,0+128,0,2
                 DB     46+128,46-12+128,46-12-12,30
                 DB     0, $80
