; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains all definitions for morphing objects used throughout   ;
; vectrex frogger                                                           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
_0:
                DB 11
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  5*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  5*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
_1:
                DB 7
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -2*VEC_BLOWUP, -2*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  2*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
_2:
                DB 9
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  5*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  5*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  5*VEC_BLOWUP
_3:
                DB 9
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  5*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -3*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  3*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  5*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
_4:
                DB 8
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  3*VEC_BLOWUP
                DB  3*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -3*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  2*VEC_BLOWUP
_5:
                DB 9
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  5*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  5*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  5*VEC_BLOWUP
_dot:
                DB  0
                DB  0*VEC_BLOWUP,  0*VEC_BLOWUP
_written:
written:
                DB 41
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -3*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  3*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -3*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -3*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -3*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  4*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -3*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  2*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -2*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  2*VEC_BLOWUP
                DB  3*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -3*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
_by:
                DB 27
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  2*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  2*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
_chris:
                DB 46
                DB -1*VEC_BLOWUP,  2*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -2*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  3*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -2*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -3*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -3*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  3*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  3*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  3*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -4*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -2*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  2*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
_frog1:
                DB 62
                DB -5*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  2*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -4*VEC_BLOWUP,  2*VEC_BLOWUP
                DB -5*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  3*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  2*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  2*VEC_BLOWUP
                DB -3*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  5*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  4*VEC_BLOWUP,  2*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -2*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  4*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -3*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -2*VEC_BLOWUP, -4*VEC_BLOWUP
                DB  2*VEC_BLOWUP, -4*VEC_BLOWUP
                DB  3*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  2*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  3*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  3*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  2*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  2*VEC_BLOWUP, -2*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  2*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -3*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -2*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -3*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  2*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -2*VEC_BLOWUP, -2*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -4*VEC_BLOWUP, -1*VEC_BLOWUP
_rip:
                DB 39
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  2*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  2*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  3*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  2*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -3*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -5*VEC_BLOWUP
                DB  5*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  2*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  3*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  4*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -2*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -4*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  4*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -4*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  2*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -4*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -2*VEC_BLOWUP
_home1:
                DB 47
                DB  0*VEC_BLOWUP,  4*VEC_BLOWUP
                DB -2*VEC_BLOWUP, -2*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  2*VEC_BLOWUP, -2*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  2*VEC_BLOWUP
                DB  2*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  3*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -3*VEC_BLOWUP
                DB  2*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  2*VEC_BLOWUP,  2*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  4*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  2*VEC_BLOWUP
                DB -2*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -3*VEC_BLOWUP
                DB  3*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  2*VEC_BLOWUP, -2*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -3*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  3*VEC_BLOWUP
                DB -2*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -2*VEC_BLOWUP,  2*VEC_BLOWUP
                DB -2*VEC_BLOWUP, -2*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  1*VEC_BLOWUP
                DB  2*VEC_BLOWUP, -2*VEC_BLOWUP
                DB  0*VEC_BLOWUP,  4*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB -1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB -1*VEC_BLOWUP, -3*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -3*VEC_BLOWUP
                DB  0*VEC_BLOWUP, -3*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -3*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
                DB  1*VEC_BLOWUP,  0*VEC_BLOWUP
                DB  1*VEC_BLOWUP, -1*VEC_BLOWUP
morph_init1:
                DW _frog1               ; morph from
                DW _written             ; morph to
                DB MORPH_STEPS_INTRO    ; morph steps
                DB MORPH_DELAY_INIT     ; delay between one morph step
                DW morph_init2          ; optional (0 or structure)
                                        ; pointer to next morph structure
                DB MORPH_STARTUP_DELAY  ; startup delay
morph_init2:
                DW _written             ; morph from
                DW _by                  ; morph to
                DB MORPH_STEPS_INTRO    ; morph steps
                DB MORPH_DELAY_INIT     ; delay between one morph step
                DW morph_init3          ; optional (0 or structure)
                                        ; pointer to next morph structure
                DB MORPH_STARTUP_DELAY  ; startup delay
morph_init3:
                DW _by                  ; morph from
                DW _chris               ; morph to
                DB MORPH_STEPS_INTRO    ; morph steps
                DB MORPH_DELAY_INIT     ; delay between one morph step
                DW 0;morph_init4          ; optional (0 or structure)
                                        ; pointer to next morph structure
                DB MORPH_STARTUP_DELAY  ; startup delay
morph_countdown1:
                ; only one morphing at a time supported for now!!!
                DW _5                   ; morph from
                DW _4                   ; morph to
                DB MORPH_STEPS_Z        ; morph steps
                DB 2                    ; delay between one morph step
                DW morph_countdown2     ; optional (0 or structure)
                                        ; pointer to next morph structure
                DB 20                   ; startup delay
morph_countdown2:
                DW _4                   ; morph from
                DW _3                   ; morph to
                DB MORPH_STEPS_Z        ; morph steps
                DB 2                    ; delay between one morph step
                DW morph_countdown3     ; optional (0 or structure)
                                        ; pointer to next morph structure
                DB 20                   ; startup delay
morph_countdown3:
                DW _3                   ; morph from
                DW _2                   ; morph to
                DB MORPH_STEPS_Z        ; morph steps
                DB 2                    ; delay between one morph step
                DW morph_countdown4     ; optional (0 or structure)
                                        ; pointer to next morph structure
                DB 20                   ; startup delay
morph_countdown4:
                DW _2                   ; morph from
                DW _1                   ; morph to
                DB MORPH_STEPS_Z        ; morph steps
                DB 2                    ; delay between one morph step
                DW morph_countdown5     ; optional (0 or structure)
                                        ; pointer to next morph structure
                DB 20                   ; startup delay
morph_countdown5:
                DW _1                   ; morph from
                DW _0                   ; morph to
                DB MORPH_STEPS_Z        ; morph steps
                DB 2                    ; delay between one morph step
                DW morph_countdown6     ; optional (0 or structure)
                                        ; pointer to next morph structure
                DB 20                   ; startup delay
morph_countdown6:
                DW _0                   ; morph from
                DW _dot                 ; morph to
                DB MORPH_STEPS_Z        ; morph steps
                DB 2                    ; delay between one morph step
                DW 0                    ; optional (0 or structure)
                                        ; pointer to next morph structure
                DB 20                   ; startup delay
morph_death1:
                DW _frog1               ; morph from
                DW _rip                 ; morph to
                DB 15                   ; morph steps
                DB 2                    ; delay between one morph step
                DW 0                    ; optional (0 or structure)
                                        ; pointer to next morph structure
                DB 20                   ; startup delay
morph_home1:
                DW _frog1               ; morph from
                DW _home1               ; morph to
                DB 15                   ; morph steps
                DB 2                    ; delay between one morph step
                DW 0                    ; optional (0 or structure)
                                        ; pointer to next morph structure
                DB 20                   ; startup delay
;***************************************************************************
