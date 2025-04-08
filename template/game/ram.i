USE_ANALOG = 1
; SIZE 17
                    struct   ObjectStruct 
                    ds       Y_POS,1                      ; D current position ; BUG TARGET POS 
                    ds       X_POS,1                      ; D ; BUG TARGET POS 
                    ds       BEHAVIOUR,2                  ; PC 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       C_TEXT,0 
                    ds       C_DATA_W,0 
                    ds       C_COUNTER,0				  ; Patrol: reuse general Byte 1 as counter 
                    ds       C_DATA_B1,1 
                    ds       C_DATA_POS,0				  ; Patrol: reuse general Byte 2 as dataPosition
                    ds       C_DATA_B2,1 
                    ds       C_INTENSITY, 1               ; #noDoubleWarn 
                    ds       C_TIMER, 1                   ; #noDoubleWarn 
                    ds       C_ANIM_PLACE, 1              ; #noDoubleWarn 
                    ds       C_FLAG, 1                    ; #noDoubleWarn 
                    ds       C_Y_DELTA,1                  ; speed in vertical direction
                    ds       C_X_DELTA,1                  ; speed in horizontal direction
                    ds       C_HEIGHT,1                   ; assuming sprite starts in the middle
                    ds       C_WIDTH,1                    ; assuming sprite starts in the middle
                    ds       C_COLLISION_ID,1             ; opposite spriteID the last collision in this round happened with
                    end struct 

S_Y_POS = -4
S_X_POS = -3
S_BEHAVIOUR = -2

STACK_PULL_OFFSET = S_Y_POS

                    struct   SmallObjectStruct 
                    ds       S_NEXT_OBJECT,2              ; positive = end of list 
                    ds       TEXT,0 
                    ds       DATA_W,0 					  ; used in PATROL, LONG TIMER, and TEXT
                    ds       COUNTER,0					  ; reuse general Byte 1 as counter 
                    ds       DATA_B1,1 
                    ds       DATA_POS,0					  ; reuse general Byte 2 as dataPosition
                    ds       DATA_B2,1 
                    ds       INTENSITY, 1                 ; #noDoubleWarn 
                    ds       TIMER, 1                     ; #noDoubleWarn 
                    ds       ANIM_PLACE, 1                ; #noDoubleWarn 
                    ds       FLAG, 1                      ; %0000 0000
														  ; %0s00 WESN 
														  ; N=1 North was hit
														  ; S=1 South was hit
														  ; E=1 East was hit
														  ; W=1 West was hit
														  ; if  a diagonal hit occured
														  ; BOTH directions should be set!

														  ; s = 1 a sprite <-> sprite collision happened!
														  
														  ; NOT YET-> IF colision, than in DATA_W 
														  ; address of opposite struct
														  
                    ds       Y_DELTA,1                    ; speed in vertical direction
                    ds       X_DELTA,1                    ; speed in horizontal direction
                    ds       HEIGHT,1                     ; assuming sprite starts in the middle, for text these are text sizes
                    ds       WIDTH,1                      ; assuming sprite starts in the middle
                    ds       COLLISION_ID,1               ; opposite spriteID the last collision in this round happened with
														  
														  
                    end struct 

COLLISION_NORTH = 0x01			; not used
COLLISION_SOUTH = 0x02  			; not used
COLLISION_EAST = 0x04 		 			; not used
COLLISION_WEST = 0x08 		 			; not used

LoS_HiN = (COLLISION_SOUTH + (COLLISION_NORTH*16))
LoN_HiS = (COLLISION_NORTH + (COLLISION_SOUTH*16))
LoE_HiW = (COLLISION_EAST + (COLLISION_WEST*16))
LoW_HiE = (COLLISION_WEST + (COLLISION_EAST*16))

NO_HORZONTAL_AND = (LoS_HiN+LoN_HiS)
NO_VERTICAL_AND = (LoE_HiW+LoW_HiE)


SPRITE_SPRITE_COLLISION_BIT = 0x40		



                    BSS      
                    ORG      $c880 

OBJECTS_DONE_A        ds       2                          ; 
OBJECTS_DONE          =        OBJECTS_DONE_A-2 

objectlist_empty_head  ds    2                            ; if empty these contain a value that points to a RTS, smaller than OBJECT_LIST_COMPARE_ADDRESS 
objectlist_used_head  ds     2                            ; if greater OBJECT_LIST_COMPARE_ADDRESS, than this is a pointer to a RAM location of an Object 

OBJECT_LIST_COMPARE_ADDRESS  ds  0                        ; compare value to above 5 addresses - these must be greater than above addreses, 

GLOBAL_ANIMATION_DELAY = 2
gameScale           ds 1                                  ; movement scale!
animCountdown		ds 1

main1Pointer        ds 2
actionDelta1 		ds 2 ; y, x
collision1Map 		ds 1
main2Pointer        ds 2
actionDelta2 		ds 2
collision2Map 		ds 1

 if USE_CALIBRATION = 1
calibrationValue ds 1

 endif


currentLevel		ds 1
sceneListForLevel   ds 2	; level init code puts here a pointer to all background scenes (null terminated list)
currentLevelFlags   ds 1
LEVEL_USES_ANALOG_INPUT = 1
INTENSITY_IS_DEFAULT = 2	; a sprite can change the intensity, if so, it sets the bit to 1
							; 0 meaning everything is fine
							; 1 meaning the intensity must be restored to default

temp16bit	 		ds 2
temp8bit	 		ds 1
vListTemp			ds 2

 if USE_ANALOG = 1
analogSamples ds 4*4
analogSampleCount ds 1
 
 endif

loadTimer ds 1 ; just for test DELETE! in TEST for spawn rate of shots
ADVdirection ds 1 ; just for test DELETE! in TEST5 for button presses

sfx_pointer_1       ds       2                            ; sfx player used 
sfx_pointer_2       ds       2                            ; sfx player used 
sfx_pointer_3       ds       2                            ; sfx player used 



GLOBAL_RAM          ds 0
					



objectCount         ds       1 
object_list         ds 0                                  ; not used!!!!
LEVEL_RAM           ds 0





                    CODE     
