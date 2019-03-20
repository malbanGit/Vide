; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains all level definitions (16 levels) and the object table ;
; of sprites which can be used for levels                                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Note:
; The levels are optimized as they are. All levels can even under worst case
; conditions be played with 50Hz display.
; They all take less than 30000 cycles to draw.
; If you make other levels, please be sure that each level takes
; less than 30000 cycles to be drawn. It's easy to go above, since 30 sprites
; can be drawn at maximum (not counting otter, log snakes, girls and
; home sprites). Be carfull, display will 'WOBBLE'!
;
; actually these levels could probably be 'packed' than we would probably
; have space for 30-40-50??? levels...
;                      1
; well, it is not all THAT interesting to make levels...
;
;****************************************************************************
; some objects are not used...
; if you make new objects... comment them here...
; for how to make objects look at any object include file
object_table: 
                    DW       carbig_m1a_object            ; moving left -1 '01' 
                    DW       van_m1a_object               ; moving left -1 '02' 
                    DW       caterpillar_1a_object        ; moving right 1 '03' 
                    DW       speeder_m1a_object           ; moving left -1 '04' 
                    DW       log1a_object                 ; moving right 1 '05' 
                    DW       log2a_object                 ; moving left -1 '06' 
                    DW       turtle1a_object              ; moving right 1 '07' 
                    DW       snake1a_object               ; moving right 1 '08' 
                    DW       snake2a_object               ; moving right 2 '09' 
                    DW       snake3a_object               ; moving left -1 '10' 
                    DW       snake4a_object               ; moving left -2 '11' 
                    DW       turtle2a_object              ; moving left -1 '12' 
                    DW       turtle3a_object              ; moving right 2 '13' 
                    DW       turtle4a_object              ; moving left -2 '14' 
                    DW       log3a_object                 ; moving left -1 '15' left of big 
                    DW       log4a_object                 ; moving left -1 '16' right of big 
                    DW       _l_object                    ; moving left -1 '17' 
                    DW       _e_object                    ; moving left -1 '18' 
                    DW       _v_object                    ; moving left -1 '19' 
                    DW       _d_object                    ; moving left -1 '20' 
                    DW       _o_object                    ; moving left -1 '21' 
                    DW       _n_object                    ; moving left -1 '22' 
                    DW       carbig_1a_object             ; moving right 1 '23' 
                    DW       caterpillar_m1a_object       ; moving left -1 '24' 
                    DW       croco3a_object               ; moving left -1 '25' 
                    DW       croco4a_object               ; moving left -2 '26' 
                    DW       turtled1a_object             ; moving right 1 '27' 
                    DW       turtled2a_object             ; moving left -1 '28' 
                    DW       turtled3a_object             ; moving right 2 '29' 
                    DW       turtled4a_object             ; moving left -2 '30' 
                    DW       carbig_2a_object             ; moving right 2 '31' 
                    DW       caterpillar_m2a_object       ;log6a_object ; moving right 1 '32' right of big 
                    DW       carbig_m1a_object            ; moving left -1 '33' 
                    DW       carsmall_1a_object           ; moving right 1 '34' 
                    DW       carsmall_2a_object           ; moving right 2 '35' 
                    DW       log7a_object                 ; moving right 2 '36' 
                    DW       log8a_object                 ; moving left -2 '37' 
                    DW       log9a_object                 ; moving left -2 '38' left of big 
                    DW       log10a_object                ; moving left -2 '39' right of big 
                    DW       carbig_m3a_object            ;log11a_object ; moving right 2 '40' left of big 
                    DW       speeder_m3a_object           ; moving right 3 '41' right of big 
                    DW       van_m2a_object               ; moving left -2 '42' 
                    DW       van_m3a_object               ; moving left -3 '43' 
                    DW       caterpillar_1a_object        ; moving right 1 '44' 
                    DW       caterpillar_2a_object        ; moving right 2 '45' 
                    DW       speeder_m1a_object           ; moving left -1 '46' 
                    DW       speeder_m2a_object           ; moving left -2 '47' 
                    if       ARCADE_MOVE = 1 
                    DW       crocoM3a_object              ; Moving right 1, 48 
                    DW       crocoM4a_object              ; Moving right 2, 49 
                    DW       log3a_P_object               ; moving right 1 '50' left of big 
                    DW       log4a_P_object               ; moving right 1 '51' right of big 
                    DW       log9a_P_object               ; moving right 2 '52' left of big 
                    DW       log10a_P_object              ; moving right 2 '53' right of big 
                    endif    
                    if       HALFSPEED = 1 
                    DW       van_mHalfe_object            ; moving left 1/2 '54' VAN 
                    endif    
levels: 
; per level 11 bands (5 river + middle band + 5 street)
; 7 objects per band MAX
; 30 objects absolut MAX
; not more than 6 dive objects (changing after dive timer)
; objects not in adjacents positions
;...........................................................................
level1_data:                                              ;       verified  
                    DB       00,00,06,00,00,06,00,00,06,00,00,06 ; per band 12 pos, river 
                    DB       00,00,07,00,07,00,00,00,07,00,07,00 ; per band 12 pos, river 
                    DB       00,00,15,00,16,00,00,00,15,00,16,00 ; per band 12 pos, river 
                    DB       00,00,05,00,00,00,00,05,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,12,00,12,00,12,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; middle band 
                    DB       02,00,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,34,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,01,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,00,00,00,00,03,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,00,00,00,00,04,00,00,00 ; per band 12 pos, street 
                    DB       0                            ; fly timer, after how many ticks 
                    DB       0                            ; crocodile will appear and disappear 
                    DB       0                            ; mole timer $ 10 
                    DB       0                            ; snake on log after what rounds 
                    DB       0                            ; female 1 every round 
                    DB       120                          ; must be dividable by 2, 120 max! 
                    DB       $ff                          ; turtle dive timer, $ff = not diving turtle 
;...........................................................................
level2_data:                                              ;       verified  
                    DB       00,00,06,00,00,00,00,06,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,07,00,07,00,00,00,27,00,27,00 ; per band 12 pos, river 
                    DB       00,00,15,00,16,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,05,00,00,00,00,05,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,12,00,12,00,12,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; middle band 
                    DB       00,00,00,00,00,02,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,00,00,34,00,00,00,00,34 ; per band 12 pos, street 
                    DB       00,01,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,03,00,00,00,03,00,00,00 ; per band 12 pos, street 
                    DB       00,04,00,00,00,00,00,00,04,00,00,00 ; per band 12 pos, street 
                    DB       $20                          ; fly timer, after how many ticks 
                    DB       $0                           ; crocodile will appear and disappear 
                    DB       0                            ; mole 
                    DB       0                            ; snake on log 
                    DB       0                            ; female 
                    DB       120                          ; timer muss durch 2 teilbar sein 
                                                          ; 120 max! 
                    DB       $30                          ; turtle dive timer at least 6 $a is ok!!! 
;...........................................................................
level3_data:                                              ;       verified  
                    DB       00,00,25,00,00,00,00,06,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,13,00,13,00,00,00,13,00,13,00 ; per band 12 pos, river 
                    DB       00,00,15,00,16,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,05,00,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,30,00,30,00,30,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; middle band 
                    DB       42,00,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       35,00,00,35,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,00,00,33,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,44,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,04,00,00,00,00,00,00,00,04,00,00 ; per band 12 pos, street 
                    DB       $0                           ; fly timer, after how many ticks 
                    DB       $25                          ; crocodile will appear and disappear 
                    DB       0                            ; mole 
                    DB       0                            ; snake on log 
                    DB       2                            ; female 
                    DB       120                          ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $20                          ; turtle dive timer 
;...........................................................................
level4_data:                                              ;       verified  
                    DB       00,00,00,00,00,00,00,25,00,00,00,00 ; per band 12 pos, river 
                    DB       00,07,00,07,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,15,00,16,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,05,00,00,00,00,05,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,12,00,12,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,10,00,00,00 ; middle band 
                    DB       00,43,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,35,00,00,00,00,35,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,01,00,00,00,00,00,00,01 ; per band 12 pos, street 
                    DB       00,00,00,00,03,00,00,00,03,00,00,00 ; per band 12 pos, street 
                    DB       00,46,00,00,00,00,00,00,46,00,00,00 ; per band 12 pos, street 
                    DB       $30                          ; fly timer, after how many ticks 
                    DB       $00                          ; crocodile will appear and disappear 
                    DB       0                            ; mole 
                    DB       0                            ; snake on log 
                    DB       1                            ; female 
                    DB       100                          ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $ff                          ; turtle dive timer, $ff = not diving turtle 
;...........................................................................
level5_data:                                              ;       verified  
                    DB       00,00,00,00,00,00,00,06,00,00,00,00 ; per band 12 pos, river 
                    DB       07,00,07,00,00,00,27,00,27,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,15,00,16,00,00 ; per band 12 pos, river 
                    DB       00,36,00,00,00,00,00,00,36,00,00,00 ; per band 12 pos, river 
                    DB       00,00,12,00,12,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       10,00,00,00,00,00,00,08,00,00,00,00 ; middle band 
                    DB       00,00,00,02,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,34,00,00,00,00,00,34,00,00,00,00 ; per band 12 pos, street 
                    DB       00,01,00,00,00,00,00,00,01,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,00,00,00,45,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,46,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       $30                          ; fly timer, after how many ticks 
                    DB       $0                           ; crocodile will appear and disappear 
                    DB       0                            ; mole 
                    DB       0                            ; snake on log 
                    DB       2                            ; female 
                    DB       100                          ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $15                          ; turtle dive timer 
;...........................................................................
level6_data:                                              ;       verified  
                    DB       00,00,00,00,00,06,00,00,00,06,00,00 ; per band 12 pos, river 
                    DB       00,07,00,07,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,15,00,16,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,05,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,12,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; middle band 
                    DB       00,00,00,43,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,34,00,00,00,00,00,34,00,00,00,00 ; per band 12 pos, street 
                    DB       00,01,00,00,00,00,00,00,01,00,00,00 ; per band 12 pos, street 
                    DB       00,45,00,00,00,45,00,00,00,45,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,47,00,00,00,00,47,00,00 ; per band 12 pos, street 
                    DB       $20                          ; fly timer, after how many ticks 
                    DB       $00                          ; crocodile will appear and disappear 
                    DB       0                            ; mole 
                    DB       0                            ; snake on log 
                    DB       1                            ; female 
                    DB       80                           ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $ff                          ; turtle dive timer, $ff = not diving turtle 
;...........................................................................
level7_data:                                              ;       verified  
                    DB       00,00,00,06,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,07,00,07,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,15,00,16,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,05,00,00,00 ; per band 12 pos, river 
                    DB       00,00,12,00,00,00,00,00,12,00,12,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; middle band 
                    DB       00,00,00,00,00,02,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,35,00,00,00,00,35,00,00,00,00 ; per band 12 pos, street 
                    DB       00,01,00,00,00,00,01,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,03,00,00,00,03,00,00,00 ; per band 12 pos, street 
                    DB       00,04,00,00,00,00,04,00,00,00,00,00 ; per band 12 pos, street 
                    DB       $0                           ; fly timer, after how many ticks 
                    DB       $10                          ; crocodile will appear and disappear 
                    DB       0                            ; mole 
                    DB       2                            ; snake on log 
                    DB       2                            ; female 
                    DB       80; 120                          ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $ff                          ; turtle dive timer, $ff = not diving turtle 
;...........................................................................
level8_data:                                              ;       verified  
                    DB       00,00,06,00,00,00,00,06,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,07,00,07,00,00,00,27,00,27,00 ; per band 12 pos, river 
                    DB       00,00,15,00,16,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,05,00,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,12,00,28,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       08,00,00,00,00,00,00,00,00,00,00,00 ; middle band 
                    DB       02,00,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,34,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,01,00,00,00,00,00,01,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,00,00,00,00,03,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,04,00,00,00,00,04,00,00,00 ; per band 12 pos, street 
                    DB       $a                           ; fly timer, after how many ticks 
                    DB       $20                          ; crocodile will appear and disappear 
                    DB       $1f                          ; mole 
                    DB       0                            ; snake on log 
                    DB       2                            ; female 
                    DB      80; 120                          ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $10                          ; turtle dive timer 
;...........................................................................
level9_data:                                              ;       ok       non arcade conform! 
                    DB       00,00,25,00,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,07,00,07,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,38,00,39,00,00 ; per band 12 pos, river 
                    DB       00,00,05,00,00,00,00,00,05,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,28,00,12,00,00,00,00,00 ; per band 12 pos, river 
                    DB       08,00,00,00,09,00,00,00,00,00,00,00 ; middle band 
                    DB       44,00,00,00,44,00,00,00,44,00,00,00 ; per band 12 pos, street 
                    DB       00,00,34,00,00,00,34,00,00,00,34,00 ; per band 12 pos, street 
                    DB       00,00,00,00,00,00,47,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,01,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,00,02,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       $0                           ; fly timer, after how many ticks 
                    DB       $20                          ; crocodile will appear and disappear 
                    DB       $18                          ; mole 
                    DB       0                            ; snake on log 
                    DB       0                            ; female 
                    DB       70                           ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $15                          ; turtle dive timer 
;...........................................................................
level10_data:                                             ;      ok       non arcade conform! 
                    DB       00,00,00,25,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,07,00,07,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,38,00,39,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,05,00,00,00 ; per band 12 pos, river 
                    DB       00,00,12,00,12,00,12,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,10,00,00,00,00,11,00,00,00,00 ; middle band 
                    DB       00,40,00,00,00,40,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,34,00,00,00,00,00,34,00,00 ; per band 12 pos, street 
                    DB       00,02,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,00,00,46,00,00,00,00,46 ; per band 12 pos, street 
                    DB       00,00,00,00,00,44,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       $a                           ; fly timer, after how many ticks 
                    DB       $b                           ; crocodile will appear and disappear 
                    DB       $c                           ; mole 
                    DB       0                            ; snake on log 
                    DB       1                            ; female 
                    DB      70; 120                          ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $ff                          ; turtle dive timer, $ff = not diving turtle 
;...........................................................................
level11_data:                                             ;      ok       non arcade conform! 
                    DB       00,00,00,00,00,06,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,07,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,38,00,39,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,36,00,00,00 ; per band 12 pos, river 
                    DB       00,00,14,00,14,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; middle band 
                    DB       00,47,00,00,47,00,00,00,00,47,00,00 ; per band 12 pos, street 
                    DB       00,35,00,00,00,35,00,00,00,35,00,00 ; per band 12 pos, street 
                    DB       00,00,00,43,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,23,00,00,00,00,23,00,00,00,23,00 ; per band 12 pos, street 
                    DB       00,24,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       $0                           ; fly timer, after how many ticks 
                    DB       $30                          ; crocodile will appear and disappear 
                    DB       9                            ; mole 
                    DB       0                            ; snake on log 
                    DB       2                            ; female 
                    DB      70; 120                          ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $ff                          ; turtle dive timer, $ff = not diving turtle 
;...........................................................................
level12_data:                                             ;      ok       non arcade conform! 
                    DB       00,00,37,00,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,13,00,13,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,38,00,39,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,36,00,00,00 ; per band 12 pos, river 
                    DB       00,00,12,00,12,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       11,00,00,00,00,00,00,00,00,00,00,00 ; middle band 
                    DB       00,00,00,02,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,34,00,00,00,00,00,00,00,00,34,00 ; per band 12 pos, street 
                    DB       00,01,00,00,00,00,00,00,01,00,00,00 ; per band 12 pos, street 
                    DB       00,03,00,00,00,00,00,03,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,46,00,00,00,00,46,00,00 ; per band 12 pos, street 
                    DB       $20                          ; fly timer, after how many ticks 
                    DB       $18                          ; crocodile will appear and disappear 
                    DB       10                           ; mole 
                    DB       2                            ; snake on log 
                    DB       2                            ; female 
                    DB      70; 100                          ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $ff                          ; turtle dive timer, $ff = not diving turtle 
;...........................................................................
level13_data: 
                    DB       00,00,26,00,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,13,00,29,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,38,00,39,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,36,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,30,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       10,00,00,00,00,00,00,11,00,00,00,00 ; middle band 
                    DB       00,00,00,02,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,35,00,00,00,35,00,00,00,00,00,35 ; per band 12 pos, street 
                    DB       00,00,00,00,43,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,31,00,00,00,31,00,00,00,31,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,00,00,00,00,24,00,00,00 ; per band 12 pos, street 
                    DB       $19                          ; fly timer, after how many ticks 
                    DB       $20                          ; crocodile will appear and disappear 
                    DB       9                            ; mole 
                    DB       0                            ; snake on log 
                    DB       3                            ; female 
                    DB      70; 100                          ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $15                          ; turtle dive timer 
;...........................................................................
level14_data: 
                    DB       00,00,06,00,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,07,00,00,00,00,00,27,00,00,00,00 ; per band 12 pos, river 
                    DB       00,15,00,16,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,36,00,00,00,36,00,00,00 ; per band 12 pos, river 
                    DB       00,00,14,00,30,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,09,11,00,00,00,00 ; middle band 
                    DB       00,00,00,04,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,35,00,00,00,00,00,35,00 ; per band 12 pos, street 
                    DB       00,47,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,03,00,00,00,00,00,03,00,00,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,01,00,00,00,00,01,00,00 ; per band 12 pos, street 
                    DB       $25                          ; fly timer, after how many ticks 
                    DB       $20                          ; crocodile will appear and disappear 
                    DB       $10                          ; mole 
                    DB       0                            ; snake on log 
                    DB       2                            ; female 
                    DB      70; 100                          ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $1a                          ; turtle dive timer 
;...........................................................................
level15_data:                                             ;;;;;;;;;;;;; 
                    DB       06,00,00,00,00,00,06,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,13,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,38,00,39,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,36,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,30,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       08,00,00,00,00,00,00,00,00,00,00,00 ; middle band 
                    DB       00,00,00,00,00,00,00,00,00,47,00,00 ; per band 12 pos, street 
                    DB       00,35,00,00,35,00,00,35,00,00,35,00 ; per band 12 pos, street 
                    DB       00,00,00,02,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,23,00,00,23,00,00,23,00,00,23,00 ; per band 12 pos, street 
                    DB       00,24,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       $10                          ; fly timer, after how many ticks 
                    DB       $0                           ; crocodile will appear and disappear 
                    DB       9                            ; mole 
                    DB       1                            ; snake on log 
                    DB       0                            ; female 
                    DB      70; 120                          ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $15                          ; turtle dive timer 
;...........................................................................
level16_data: 
                    DB       00,00,25,00,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,07,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,38,00,39,00,00 ; per band 12 pos, river 
                    DB       00,00,00,00,00,00,00,00,36,00,00,00 ; per band 12 pos, river 
                    DB       00,00,30,00,14,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       08,00,00,00,00,00,00,08,00,00,00,00 ; middle band 
                    DB       00,00,00,43,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,23,00,00,23,00,00,23,00,00,23,00 ; per band 12 pos, street 
                    DB       00,47,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       00,35,00,00,00,35,00,00,00,35,00,00 ; per band 12 pos, street 
                    DB       00,00,00,00,32,00,00,00,00,00,00,00 ; per band 12 pos, street 
                    DB       $0                           ; fly timer, after how many ticks 
                    DB       $20                          ; crocodile will appear and disappear 
                    DB       9                            ; mole 
                    DB       1                            ; snake on log 
                    DB       0                            ; female 
                    DB     60;  120                          ; timer muss durch 2 teilbar sein, 120 max! 
                    DB       $15                          ; turtle dive timer 
;...........................................................................
level_done_data: 
;                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
;                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
;                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
;                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, river 
                    DB       17,18,19,18,17,00,20,21,22,18,00,00 ; per band 12 pos, river 
;                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; middle band 
;                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
;                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
;                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
;                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
;                    DB       00,00,00,00,00,00,00,00,00,00,00,00 ; per band 12 pos, street 
;                    DB       0                            ; fly 
;                    DB       0                            ; crocodile 
;                    DB       0                            ; mole 
;                    DB       0                            ; snake on log 
;                    DB       0                            ; female 
;                    DB       0                            ; timer 
;                    DB       $ff                          ; turtle dive timer 
;...........................................................................
