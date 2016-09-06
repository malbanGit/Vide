; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for all letters and a do, used;
; in scroll text                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;

                DB  0                      ; y offset
                DB  0                      ; x offset
; sprite definition
_t_:
                DB 23
                DB  2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP

                DB  -5   ; y offset
                DB  1    ; x offset
; sprite definition
_fs:
                DB 3
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -7    ; y offset
                DB  1    ; x offset
; sprite definition
_a:
                DB 6
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -7    ; y offset
                DB  1    ; x offset
; sprite definition
_b:
                DB 8
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  5    ; y offset
                DB  8    ; x offset
; sprite definition
_c:
                DB 7
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -7    ; y offset
                DB  1    ; x offset
; sprite definition
_d:
                DB 7
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -7    ; y offset
                DB  8    ; x offset
; sprite definition
_e:
                DB 5
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -7    ; y offset
                DB  1    ; x offset
; sprite definition
_f:
                DB 4
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  5    ; y offset
                DB  8    ; x offset
; sprite definition
_g:
                DB 9
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB  6    ; y offset
                DB  1    ; x offset
; sprite definition
_h:
                DB 6
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  6    ; y offset
                DB  1    ; x offset
; sprite definition
_i:
                DB 5
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  6    ; y offset
                DB  1    ; x offset
; sprite definition
_j:
                DB 6
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
;                DB  6    ; y offset
;                DB  1    ; x offset
; sprite definition
_k:
;                DB 5
;                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
;                DB  5*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
;                DB -5*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
;                DB -5*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
;                DB  5*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
;                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  6    ; y offset
                DB  1    ; x offset
; sprite definition
_l:
                DB 2
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -7    ; y offset
                DB  1    ; x offset
; sprite definition
_m:
                DB 5
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -7    ; y offset
                DB  1    ; x offset
; sprite definition
_n:
                DB 5
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -7    ; y offset
                DB  3    ; x offset
; sprite definition
_o:
                DB 9
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -7    ; y offset
                DB  1    ; x offset
; sprite definition
_p:
                DB 6
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
;                DB -3    ; y offset
;                DB  4    ; x offset
; sprite definition
_q:
;                DB 10
;                DB -3*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
;                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
;                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
;                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
;                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
;                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
;                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
;                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
;                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -7    ; y offset
                DB  1    ; x offset
; sprite definition
_r:
                DB 8
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  5    ; y offset
                DB  8    ; x offset
; sprite definition
_s:
                DB 10
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  6    ; y offset
                DB  1    ; x offset
; sprite definition
_t:
                DB 3
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  6    ; y offset
                DB  1    ; x offset
; sprite definition
_u:
                DB 6
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  6    ; y offset
                DB  1    ; x offset
; sprite definition
_v:
                DB 3
                DB -5*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  6    ; y offset
                DB  1    ; x offset
; sprite definition
_w:
                DB 5
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  6    ; y offset
                DB  1    ; x offset
; sprite definition
_x:
                DB 5
                DB -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  6    ; y offset
                DB  1    ; x offset
; sprite definition
_y:
                DB 3
                DB -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
;                DB  6    ; y offset
;                DB  1    ; x offset
; sprite definition
_z:
;                DB 3
;                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
;                DB -5*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
;                DB -5*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
;                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
_abc:
                dw _a, _b, _c, _d, _e, _f, _g, _h, _i, _j
                dw _k, _l, _m, _n, _o, _p, _q, _r, _s, _t
                dw _u, _v, _w, _x, _y, _z
