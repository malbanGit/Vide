; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains all definitions for morphing objects used throughout   ;
; vectrex frogger                                                           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
_0: 
                    DB       11 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, -5*VEC_BLOWUP 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 5*VEC_BLOWUP 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, -5*VEC_BLOWUP 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 5*VEC_BLOWUP 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
_1: 
                    DB       7 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, -1*VEC_BLOWUP 
                    DB       -2*VEC_BLOWUP, -2*VEC_BLOWUP 
                    DB       2*VEC_BLOWUP, 2*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 1*VEC_BLOWUP 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
_2: 
                    DB       9 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, -5*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 5*VEC_BLOWUP 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, -5*VEC_BLOWUP 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 5*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, -5*VEC_BLOWUP 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 5*VEC_BLOWUP 
_3: 
                    DB       9 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, -5*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 5*VEC_BLOWUP 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, -3*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 3*VEC_BLOWUP 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, -5*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 5*VEC_BLOWUP 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
_4: 
                    DB       8 
                    DB       0*VEC_BLOWUP, -5*VEC_BLOWUP 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 3*VEC_BLOWUP 
                    DB       3*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       -3*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 2*VEC_BLOWUP 
_5: 
                    DB       9 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, -5*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 5*VEC_BLOWUP 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, -5*VEC_BLOWUP 
                    DB       5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 5*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, -5*VEC_BLOWUP 
                    DB       -5*VEC_BLOWUP, 0*VEC_BLOWUP 
                    DB       0*VEC_BLOWUP, 5*VEC_BLOWUP 
_dot: 
                    DB       0 
                    DB       0*VEC_BLOWUP, 0*VEC_BLOWUP 
morph_countdown1: 
                                                          ; only one morphing at a time supported for now!!! 
                    DW       _5                           ; morph from 
                    DW       _4                           ; morph to 
                    DB       MORPH_STEPS_Z                ; morph steps 
                    DB       2                            ; delay between one morph step 
                    DW       morph_countdown2             ; optional (0 or structure) 
                                                          ; pointer to next morph structure 
                    DB       20                           ; startup delay 
morph_countdown2: 
                    DW       _4                           ; morph from 
                    DW       _3                           ; morph to 
                    DB       MORPH_STEPS_Z                ; morph steps 
                    DB       2                            ; delay between one morph step 
                    DW       morph_countdown3             ; optional (0 or structure) 
                                                          ; pointer to next morph structure 
                    DB       20                           ; startup delay 
morph_countdown3: 
                    DW       _3                           ; morph from 
                    DW       _2                           ; morph to 
                    DB       MORPH_STEPS_Z                ; morph steps 
                    DB       2                            ; delay between one morph step 
                    DW       morph_countdown4             ; optional (0 or structure) 
                                                          ; pointer to next morph structure 
                    DB       20                           ; startup delay 
morph_countdown4: 
                    DW       _2                           ; morph from 
                    DW       _1                           ; morph to 
                    DB       MORPH_STEPS_Z                ; morph steps 
                    DB       2                            ; delay between one morph step 
                    DW       morph_countdown5             ; optional (0 or structure) 
                                                          ; pointer to next morph structure 
                    DB       20                           ; startup delay 
morph_countdown5: 
                    DW       _1                           ; morph from 
                    DW       _0                           ; morph to 
                    DB       MORPH_STEPS_Z                ; morph steps 
                    DB       2                            ; delay between one morph step 
                    DW       morph_countdown6             ; optional (0 or structure) 
                                                          ; pointer to next morph structure 
                    DB       20                           ; startup delay 
morph_countdown6: 
                    DW       _0                           ; morph from 
                    DW       _dot                         ; morph to 
                    DB       MORPH_STEPS_Z                ; morph steps 
                    DB       2                            ; delay between one morph step 
                    DW       0                            ; optional (0 or structure) 
                                                          ; pointer to next morph structure 
                    DB       20                           ; startup delay 
;***************************************************************************
