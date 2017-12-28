;***************************************************************************
; Test program, for trying out things
;***************************************************************************
; DEFINE SECTION
;***************************************************************************
                INCLUDE "VECTREX.I"             ; vectrex function includes
                ORG     0                       ; cartridge name...
;***************************************************************************
; HEADER SECTION
;***************************************************************************
                DB      "g GCE 1998", $80       ; 'g' is copyright sign
                DW      music2                  ; music from the rom
                DB      $F8, $50, $20, -$55     ; height, width, rel y, rel x
                                                ; (from 0,0)
                DB      "MONSTER HOUSE",$80     ; some game information,
                                                ; ending with $80
                DB      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; start cartridge

                LDA     #1                      ;setup the joystick
                STA     Vec_Joy_Mux_1_X    
house_chr       EQU     $C88F                   ;House as text, 3 bytes of RAM.     
score_chr       EQU     $C893                   ;Score as text, 5 bytes of RAM.
hi_score_chr    EQU     $C898                   ;Hi Score as text, 5 bytes of RAM.
hi_score        EQU     $C89D                   ;Hi score 2 bytes

;****************************************************************************
intro_loop:
                JSR     Intensity_7F            ; set intensity & show press button message
                
                LDU     #start_string           ; load from string address  
                LDA     #30                     ; Text position relative Y
                LDB     #-110                   ; Text position relative X
                JSR     Print_Str_d             ; Vectrex BIOS print routine
            
                JSR     Read_Btns               ; get button status
                CMPA    #$00                    ; is a button pressed?
                BEQ     intro_loop              ; if not loop
;****************************************************************************

init:

batX            EQU     $C880                   ;set the bat X position
                STA     batX
X_hit_box       EQU     $C881                   ;stores the X hit position (for hit check loops)
                LDA     #0
                STA     X_hit_box
ballX           EQU     $C882                   ;set the ball X position
                LDA     #0
                STA     ballX
ballY           EQU     $C883                   ;set the ball Y position
                LDA     #0
                STA     ballY
ballX_d         EQU     $C884                   ;set the ball X direction
                LDA     #1
                STA     ballX_d
ballY_d         EQU     $C885                   ;set the ball X direction
                LDA     #0
                STA     ballY_d 
NMEx            EQU     $C886                   ;set the enemy X position
                LDA     #0 
                STA     NMEx     
NMEy            EQU     $C887                   ;set the enemy Y position
                LDA     #120
                STA     NMEy             
houseX          EQU     $C888                   ;set the house X position
                LDA	    #-8
		        STA     houseX        
bat_hit         EQU     $C889                   ;location used for bat hit count
                LDA     #0
                STA     bat_hit   
offset          EQU     $C88A                   ;general location used to reset vector positions to 0
                LDA     #0
                STA     offset         
loop            EQU     $C88B                   ;general location used for looping
                LDA     #0
                STA     loop     
house           EQU     $C88C                   ;location used to store lives count
                LDA     #4
                STA     house
score           EQU     $C88D                   ;location used to store score count
                LDA     #0                      ;two bytes of RAM
                STA     score
                LDA     #0   
                STA     score+1                 ; stored to $C88E
                 



;***************************************************************************
;***************************************************************************
main:
                JSR     Wait_Recal              ; Vectrex BIOS recalibration
                JSR     show_scores             ; jump to display scores 
                JSR     showNME                 ; jump to show enemy subroutean
                BSR     showBall                ; branch to show ball subroutean
                BSR     showBat                 ; branch to show bat subroutean
                JSR     showHouse               ; jump to show house subroutean
                BSR     checkButtons            ; branch to check buttons subroutean
                JSR     checkStick              ; jump to check joystick subroutean
                JSR     moveNME                 ; jump to move enemy subroutean
                JSR     moveBall                ; jump to move ball subroutean
                JSR     checkBallBounce         ; jump to check bounce subroutean
                JSR     checkBatHit             ; jump to check for bat hit sudroutean
                JSR     checkMNEHit             ; jump to check for enemy hit subroutean
		        JSR	    checkHouseHit		    ; jump to check for house capture subroutean
                BRA     main                    ; and repeat forever

;***************************************************************************
;***************************************************************************
showBall:                                       ; Reset Absolute Position (0,0) & draw bat
                LDA     NMEy                    ; load the ball y position to A 
                STA     offset                  ; Store to the offset mem location
                NEG     offset                  ; Negate the contents of the mem location
                LDA     offset                  ; load A with the contents of the mem location
                LDB     NMEx                    ; load the ball x position to B 
                STB     offset                  ; Store to the offset mem location
                NEG     offset                  ; Negate the contents of the mem location
                LDB     offset                  ; load B with the contents of the mem location
                JSR     Moveto_d                ; move vector back to (0,0)
                LDA     ballY                   ; ball y position
                LDB     ballX                   ; ball x position
                JSR     Moveto_d                ; move vector
                JSR     Intensity_7F            ; Set intensity to $7f
                LDA     #0                      ; to 0 (y)
                LDB     #0                      ; to 0 (x)
                LDX     #ball_list              ; load the address of the to be drawn vector list to X
                JSR     Draw_VLc                ; draw the line now
                RTS
;***************************************************************************                
showBat:                                        ; Reset Absolute Position (0,0) & draw bat
                LDA     ballY                   ; load the ball y position to A 
                STA     offset                  ; Store to the offset mem location
                NEG     offset                  ; Negate the contents of the mem location
                LDA     offset                  ; load A with the contents of the mem location
                LDB     ballX                   ; load the ball x position to B 
                STB     offset                  ; Store to the offset mem location
                NEG     offset                  ; Negate the contents of the mem location
                LDB     offset                  ; load B with the contents of the mem location
                JSR     Moveto_d                ; move vector back to (0,0)
                LDA     #-100                   ; to -100 (y)
                LDB     batX                    ; to contents of mem location (x)
                JSR     Moveto_d                ; move vector
                JSR     Intensity_5F            ; Set intensity to $5f
                LDA     #0                      ; to 0 (y)
                LDB     #50                     ; to 50 (x)
                JSR     Draw_Line_d             ; draw the line now
                LDA     #0                      ; to 0 (y)
                LDB     #-50                    ; to 50 (x)
                JSR     Moveto_d                ; move vector (put plot point to begining of bat)
                RTS
;***************************************************************************
checkButtons:
                JSR     Read_Btns               ; get button status
                CMPA    #$00                    ; is a button pressed?
                BEQ     but_end                 ; if not jump to return
                BITA    #$01                    ; test for button 1 1
                BEQ     but_end                 ; if not pressed jump and return
                ;JMP     test                   ; jump to test if pressed
but_end:
                RTS
;***************************************************************************
checkStick:
                JSR     Joy_Digital             ; read joystick positions
                LDA     Vec_Joy_1_X             ; load joystick 1 position X to A
                BEQ     joy_end                 ; if zero dont move the x position
                BMI     moveLeft                ; if negative move left
                BPL     moveRight               ; otherwise move right
joy_end
                RTS
;***************************************************************************
moveRight:
                LDA     batX                    ; read mem contents to A reg
                CMPA    #78                     ; compare with right high end
                BEQ     x_top                   ; jump to return if at top
                INCA                            ; increas the A reg
                STA     batX                    ; store A reg value to mem
x_top:
                RTS
;***************************************************************************
moveLeft:
                LDA     batX                    ; read mem contents to A reg
                CMPA    #-127                   ; compare with left low end
                BEQ     x_bot                   ; jump to return if at bottom
                DECA                            ; decrement the A reg
                STA     batX                    ; store A reg value to mem
x_bot:
                RTS
;***************************************************************************
moveBall:
                LDA     ballX_d                 ; load A with X direction of ball
                CMPA    #1                      ; check direction
                BEQ     x_go_right              ; go right (increment) if true 
                LDA     ballX                   ; if not get ball x position to A
                DECA                            ; decrement A register
                STA     ballX                   ; store contents of A 
                BRA     end_ball_X_move
x_go_right
                LDA     ballX                   ; get ball x position to A
                INCA                            ; increment A register
                STA     ballX                   ; store contents of A 
end_ball_X_move
                LDA     ballY_d                 ; load A with Y direction of ball
                CMPA    #1                      ; check direction
                BEQ     y_go_right              ; go right (increment) if true 
                LDA     ballY                   ; if not get ball Y position to A
                DECA                            ; decrement A register
                STA     ballY                   ; store contents of A 
                BRA     end_ball_Y_move
y_go_right
                LDA     ballY                   ; get ball Y position to A
                INCA                            ; increment A register
                STA     ballY                   ; store contents of A 
end_ball_Y_move   
                RTS
;***************************************************************************                
checkBallBounce
                LDA     ballX                   ; load A with ball x position 
                CMPA    #120                    ; compaire A with high value
                BNE     x_check_lower           ; jump if not equal
                LDA     #-1                     ; otherwise load A with -One
                STA     ballX_d                 ; store A to ball x direction
                BRA     y_check_high            ; branch over ball x lower check
x_check_lower:
                LDA     ballX                   ; load A with ball x position 
                CMPA    #-120                   ; compaire A with low value
                BNE     y_check_high            ; jump if not equal
                LDA     #1                      ; otherwise load A with One
                STA     ballX_d                 ; store A to ball x direction
y_check_high:
                LDA     ballY                   ; load A with ball y position 
                CMPA    #125                    ; compaire A with high value
                BNE     y_check_lower           ; jump if not equal
                LDA     #-1                     ; otherwise load A with -One
                STA     ballY_d                 ; store A to ball y direction
                BRA     no_y_change             ; branch over ball y lower check
y_check_lower:
                LDA     ballY                   ; load A with ball y position 
                CMPA    #-125                   ; compaire A with low value
                BNE     no_y_change             ; jump if not equal
                LDA     #1                      ; otherwise load A with One
                STA     ballY_d                 ; store A to ball y direction
no_y_change:
                RTS
;***************************************************************************
checkBatHit:
                LDA     ballY                   ; get Y position of ball
                CMPA    #-100                   ; see if it matches the bat Y pos
                BNE     end_hit                 ; jump to end if not equal   
                ;compare from bat x position to + 50 for a 'hit' (length of bat)
                LDA     #50                     ; load 50 to A for loop counter
                STA     loop                    ; store 50 to loop counter 
                LDA     batX                    ; load A with the X bat position
                STA     X_hit_box               ; store the X bat position to the hit pos 
x_hit_loop:
                LDA     ballX                   ; get X position of ball 
                CMPA    X_hit_box               ; see if it matches the bat X hit pos
                BNE     no_x_hit                ; jump if not equal 
                NEG     ballY_d                 ; change Y bounce direction
                INC     bat_hit                 ; increase bat hit count
                BRA     end_hit                 ; jump to end, as hit has happened
no_x_hit:
                INC     X_hit_box               ; increase contents of the hit counter
                DEC     loop                    ; decreas contents of the loop counter
                BNE     x_hit_loop              ; jump to start of loop if not 0 
end_hit: 
                RTS
;***************************************************************************
showNME:                                        ;first things to be drawn
                LDA     NMEy                    ; (y) pos
                LDB     NMEx                    ; (x) pos
                JSR     Moveto_d                ; move vector
                JSR     Intensity_7F            ; Set intensity to $7f
                LDA     #0                      ; to 0 (y)
                LDB     #0                      ; to 0 (x)
                LDX     #nme_list               ; load the vector list to X
                JSR     Draw_VLc                ; draw the line now
                RTS
;***************************************************************************                
moveNME: 
                ;randome x move up 
                JSR     Random             	; get random number to A
                ANDA    #($3)              	; only the 2 lower bits are needed
                CMPA    #1                 	; one in three chance of moving
                BNE     nme_x_move_2	  	; branch if not equal
                LDA     NMEx               	; load A with enemy x position
                INCA				        ; increase A register by One
                CMPA    #127			    ; compaire A register with 127 (hi end)
                BEQ     nme_x_move_2		; branch if euqal
                STA     NMEx			    ; store the A register to enemy x pos
nme_x_move_2:
                ;randome x move down 
                JSR     Random             	; get random number to A
                ANDA    #($3)              	; only the 2 lower bits are needed
                CMPA    #1                 	; one in three chance of moving
                BNE     nme_x_move3	  	    ; branch if not equal
                LDA     NMEx               	; load A with enemy x position
                DECA				        ; decrease A register by One
                CMPA    #-127			    ; compaire A register with -127 (low end)
                BEQ     nme_x_move3	  	    ; branch if equal
                STA     NMEx			    ; store the A register to enemy x pos
nme_x_move3:
                ;conditional x move up or down
                JSR     Random             	; get random number to A
                ANDA    #($7)              	; only the 3 lower bits are needed
                CMPA    #1                 	; one in seven chance of moving
                BNE     no_nme_x_move  	    ; branch if not equal
                LDA     NMEx               	; load A with enemy x position
                CMPA    houseX              ; compaire A with house location
                BGT     nme_x_down          ; branch if A is greater than house x
                INCA                        ; decrease the value of A
                CMPA    #127			    ; compaire A register with -127 (low end)
                BEQ     no_nme_x_move 	    ; branch if equal
                STA     NMEx                ; store the A register to enemy x pos
                BRA     no_nme_x_move       ; brach to no_nme_x_move
nme_x_down:
                DECA                        ; increase the value of A
                CMPA    #-127			    ; compaire A register with 127 (hi end)
                BEQ     no_nme_x_move		; branch if euqal
                STA     NMEx                ; store the A register to enemy x pos
no_nme_x_move:
                JSR     Random             	; get random number to A
                ANDA    #($7)              	; the 3 lower bits are needed
                CMPA    #1                 	; one in seven chance of moving
                BNE     nme_y_move_2	  	; branch if not equal
                LDA     NMEy			    ; load A with enemy y position
                INCA				        ; increase A register by One
                CMPA    #110			    ; compaire A register with 110 (hi end)
                BEQ     nme_y_move_2	  	; branch if equal
                STA     NMEy			    ; store the A register to enemy y pos
nme_y_move_2:
                JSR     Random             	; get random number to A
                ANDA    #($3)              	; only the 2 lower bits are needed
                CMPA    #1                 	; one in three chance of moving
                BNE     no_nme_y_move	  	; branch if not equal
                LDA     NMEy			    ; load A with enemy y position
                DECA				        ; decrease A register by One
		CMPA    #-117			            ; compaire A register with -117 (low end)
                BEQ     no_nme_y_move	  	; branch if equal		
                STA     NMEy			    ; store the A register to enemy y pos
no_nme_y_move:
                RTS
;***************************************************************************                
showHouse:                                      ; Reset Absolute Position (0,0) & draw bat
                LDA     #-100                   ; load the bat y position to A 
                STA     offset                  ; Store to the offset mem location
                NEG     offset                  ; Negate the contents of the mem location
                LDA     offset                  ; load A with the contents of the mem location
                LDB     batX                    ; load the bat x position to B 
                STB     offset                  ; Store to the offset mem location
                NEG     offset                  ; Negate the contents of the mem location
                LDB     offset                  ; load B with the contents of the mem location
                JSR     Moveto_d                ; move vector back to (0,0)
		        LDA     #-120                   ; house y position
                LDB     houseX                  ; to 0 (x)
                JSR     Moveto_d                ; move vector
                JSR     Intensity_3F            ; Set intensity
                LDA     #0                      ; to 0 (y)
                LDB     #0			; to house position (x)
                LDX     #house_list             ; load the vector list to X
                JSR     Draw_VLc                ; draw the house data
                RTS    
;***************************************************************************                
checkMNEHit: 
                LDA     ballY                   ; get Y position of ball
                CMPA    NMEy                    ; see if it matches the enemy Y pos
                BNE     end_hit_nme             ; jump to end if not equal   
                ;compare from enemy x position to + 14 for a 'hit' (20pxl length of enemy)
                LDA     #25                     ; load A for loop counter
                STA     loop                    ; store A to loop counter 
                LDA     NMEx                    ; load A with the X enemy position
                STA     X_hit_box               ; store the X bat position to the hit pos 
x_hit_loop_nme:
                LDA     ballX                   ; get X position of ball 
                CMPA    X_hit_box               ; see if it matches the X hit box pos
                BNE     no_x_hit_nme            ; jump if not equal 
                LDA	    #120			        ; load 120 to A
		        STA	    NMEy			        ; Store A to NMEy memory location
		        JSR     Random                  ; get random stored in A
                ADDA    #-128                   ; change random number to plot position
		        STA	    NMEx			        ; store A to enemy x location
		        JSR     addtenpoints            ; add to score
                BRA     end_hit_nme             ; jump to end, as hit has happened
no_x_hit_nme:
                INC     X_hit_box               ; increase contents of the hit counter
                DEC     loop                    ; decreas contents of the loop counter
                BNE     x_hit_loop_nme          ; jump to start of loop if not 0 
end_hit_nme: 
                RTS
;***************************************************************************
checkHouseHit:
		        ;check for enemy hit
		        LDA	    NMEy			; load contents of enemy y to A
		        CMPA	#-116			; compaire this with enemy bottom pos
		        BNE	    no_Hit			; branch to end if no match
		        LDA	    NMEx			; load contents of enemy x to A
		        CMPA	houseX			; compaire this with house x position
		        BNE	    no_Hit			; branch to end if no match
		        BSR 	move_house		; branch to move house subroutean
		        BSR	    reset_enemy		; branch to move enemy subroutean	
		        ;check for ball hit	
		        LDA	    ballY			; load contents of ball y to A
		        CMPA	#-100			; compaire this with house y  pos
		        BNE	    no_Hit			; branch to end if no match
		        LDA	    ballX			; load contents of ball x to A
		        CMPA	houseX			; compaire this with house x position
		        BNE	    no_Hit			; branch to end if no match
		        BSR 	move_house		; branch to move house subroutean	
no_Hit:
		        RTS
move_house:
		        JSR     Random                  ; get random number and store in A
                ADDA    #-128                   ; change random number to plot position
		        STA	    houseX          		; store A value to house x position
		        LDA	    house			        ; load A with the contents of house
		        DECA				            ; decrease A by one
		        STA	    house		            ; store A to house location (houses left)
		        RTS
reset_enemy:
		        LDA	    #120		            ; load 120 to A
		        STA	    NMEy		            ; Store A to NMEy memory location
		        JSR     Random                  ; get random stored in A
                ADDA    #-128                   ; change random number to plot position
		        STA	    NMEx			        ; store A to enemy x location
		        RTS
;***************************************************************************
show_scores:    
                JSR     Intensity_1F            ; set intensity for TEXT string
                JSR     house_to_text           ; sub to convert house value to text
                LDU	    #hi_score_string        ; load house string to U
	            LDA	    #127	                ; text Y	
	            LDB	    #-128		            ; text X
	            JSR	    Print_Str_d	            ; Vectrex BIOS print routine
                LDU     #hi_score_chr           ; load from string address  
                LDA     #127                    ; Text position relative Y
                LDB     #-10                    ; Text position relative X
                JSR     Print_Str_d             ; Vectrex BIOS print routine
                 
                JSR     Intensity_5F            ; set intensity for TEXT string
                JSR     house_to_text           ; sub to convert house value to text
                LDU	    #house_chr	            ; load house string to U
	            LDA	    #-128	                ; text Y	
	            LDB	    #-50		            ; text X
	            JSR	    Print_Str_d	            ; Vectrex BIOS print routine
                LDU     #lives_string           ; load from string address  
                LDA     #-128                   ; Text position relative Y
                LDB     #-120                   ; Text position relative X
                JSR     Print_Str_d             ; Vectrex BIOS print routine
                 
                JSR     Intensity_3F            ; set intensity for TEXT string
                JSR     score_to_text           ; sub to convert score value to text
                LDU	    #score_chr	            ; load score string to U
	            LDA	    #-128	                ; text Y	
	            LDB	    #+65		            ; text X
	            JSR	    Print_Str_d	            ; Vectrex BIOS print routine
                LDU     #nme_hit_string         ; load from string address  
                LDA     #-128                   ; Text position relative Y
                LDB     #-5                     ; Text position relative X
                JSR     Print_Str_d             ; Vectrex BIOS print routine   
                
                ;check for dead        
                LDA     house
                CMPA    #0
                BEQ     dead
                RTS
;***************************************************************************               
house_to_text:
	            LDA	    house		            ; High byte of the word
	            DECA
	            TFR	    a,b                     ; move hi to lo reg
	            LSRA			                ; High nibble of the byte
	            LSRA
	            LSRA
	            LSRA
	            ADDA	#48		                ; Number to ASCII value
	            STA	    house_chr               ; to hi byte of text
	            ANDB	#15		                ; Low nibble
	            ADDB	#48		                ; Number to ASCII value
	            stb	    house_chr+1             ; to low byte of text
	            ; and a line end to the end
	            LDA	    $80		                ; end of string
	            STA	    house_chr+2
                RTS
;***************************************************************************
score_to_text:
	            LDA	    score		            ; High byte of the word
	            TFR	    a,b                     ; move hi to lo reg
	            LSRA			                ; High nibble of the byte
	            LSRA
	            LSRA
	            LSRA
	            ADDA	#48		                ; Number to ASCII value
	            STA	    score_chr               ; to hi byte of text
	            ANDB	#15		                ; Low nibble
	            ADDB	#48		                ; Number to ASCII value
	            stb	    score_chr+1             ; to low byte of text
	            ; next address byte
	            LDA	    score+1		            ; Low byte of the word
	            TFR	    a,b                     ; move hi to lo reg
	            LSRA			                ; High nibble of the byte
	            LSRA
	            LSRA
	            LSRA
	            ADDA	#48		                ; Number to ASCII value
	            STA	    score_chr+2
	            ANDB	#15		                ; Low nibble
	            ADDB	#48	                    ; Number to ASCII value
	            STB	    score_chr+3
	            ; add an end of string line at the end
	            LDA	    $80		                ; end of string
	            STA	    score_chr+4
                RTS
;***************************************************************************
addtenpoints:    
	            LDA	    score+1
	            ADDA	#$10		; Add 10 points
	            DAA			
	            TFR	    a,b
	            LDA	    score
	            ADCA	#0
	            DAA
	            STD	    score	
	            RTS
;***************************************************************************
dead:
                JSR     high_score_check        ; check for new hi-score
but_loop:
                JSR     Intensity_7F            ; set intensity
                
                LDU     #dead_string            ; load from string address  
                LDA     #32                     ; Text position relative Y
                LDB     #-32                    ; Text position relative X
                JSR     Print_Str_d             ; Vectrex BIOS print routine
                
                LDU     #hi_score_string        ; load from string address
                LDA     #0                      ; Text position relative Y
                LDB     #-90                    ; Text position relative X
                JSR     Print_Str_d             ; Vectrex BIOS print routine
                
                LDU     #hi_score_chr           ; load from string address
                LDA     #0                      ; Text position relative Y
                LDB     #20                     ; Text position relative X
                JSR     Print_Str_d             ; Vectrex BIOS print routine 
                
                LDU	#nme_hit_string         ; load & show last score
                LDA	#-32         		;
                LDB	#-90         		;
                JSR	Print_Str_d         	;
                
                LDU	#score_chr         	;
                LDA     #-32                    ;
		LDB     #20                     ; 
                JSR     Print_Str_d             ; 
                
                LDU     #start_string           ; load from string address  
		LDA     #90                     ; Text position relative Y
		LDB     #-110                   ; Text position relative X
                JSR     Print_Str_d             ; Vectrex BIOS print routine
                
                
                JSR     Read_Btns               ; get button status
                CMPA    #$00                    ; is a button pressed?
                BEQ     but_loop                ; if not loop
                BNE     init                    ; restart if button press
;***************************************************************************
high_score_check:
                LDA     hi_score            ; Get the (high part of) current hi-score
                CMPA    score               ; compaire hi-score (A) with score 
                BGT     no_change           ; branch if hi-score is greater than score
                LDA     hi_score+1          ; If high not greater check low part
                CMPA    score +1            ; compaire hi-score (low part) with score 
                BGT     no_change           ; branch if hi-score is greater than score
                
                LDA	score          	    ; If not load the current score to A
                STA	hi_score	    ; and store it as the new hi-score
                LDA	score+1             ;
                STA	hi_score+1	    ; 
                
                LDA     score_chr           ; 
                STA     hi_score_chr        ; 
                LDA     score_chr+1         ; These lines are executed if 
                STA     hi_score_chr+1      ; the last score is more than the
                LDA     score_chr+2         ; hi score.
                STA     hi_score_chr+2      ; 
                LDA     score_chr+3         ; They copy the score string values 
                STA     hi_score_chr+3      ; into the hi-score string values.  
                LDA     score_chr+4         ; 
                STA     hi_score_chr+4      ; 
no_change:
                RTS
;***************************************************************************
; Data definition 
;***************************************************************************
ball_size EQU 1
ball_list:
                DB      7
                DB      0*ball_size,  1*ball_size
                DB      1*ball_size,  1*ball_size
                DB      1*ball_size,  0*ball_size
                DB      1*ball_size, -1*ball_size
                DB      0*ball_size, -1*ball_size
                DB      -1*ball_size, -1*ball_size
                DB      -1*ball_size, 0*ball_size
                DB      -1*ball_size, 1*ball_size  
nme_size EQU 5
nme_list:       DB      15
                DB      1*nme_size,  0*nme_size
                DB      0*nme_size,  1*nme_size
                DB      1*nme_size,  0*nme_size
                DB      0*nme_size,  3*nme_size
                DB      -1*nme_size,  0*nme_size
                DB      0*nme_size,  1*nme_size
                DB      -1*nme_size,  0*nme_size
                DB      0*nme_size,  -1*nme_size
                DB      -2*nme_size,  0*nme_size
                DB      0*nme_size,  -1*nme_size 
                DB      1*nme_size,  0*nme_size  
		        DB      0*nme_size,  -1*nme_size
                DB      -1*nme_size,  0*nme_size
                DB      0*nme_size,  -1*nme_size
                DB      2*nme_size,  0*nme_size
                DB      0*nme_size,  -1*nme_size  
                   
house_size EQU 3
house_list:
                DB      4
                DB      2*house_size, 0*house_size
                DB      1*house_size, 2*house_size
                DB      -1*house_size,  2*house_size
                DB      -2*house_size,  0*house_size
                DB      0*house_size,  -4*house_size
lives_string:
                DB      "HOUSE: "               ; string data
                DB      $80                     ; end of string
nme_hit_string:
                DB      "SCORE:"                ; string data
                DB      $80                     ; end of string
hi_score_string:
                DB      "HI SCORE:"             ; string data
                DB      $80                     ; end of string
dead_string:
                DB      "DEAD"                  ; string data
                DB      $80                     ; end of string
start_string:
                DB      "PRESS START BUTTON"	; string data
                DB      $80                     ; end of string

;***************************************************************************
                END main
;***************************************************************************

