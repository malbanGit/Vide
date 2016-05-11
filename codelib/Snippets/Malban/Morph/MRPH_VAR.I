;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; morphing subroutines                                                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 INCLUDE "INCLUDE\\VECTREX.I" ; vectrex function includes


; Macro
 INCLUDE "include\\macros\\div_mac.i"
 INCLUDE "include\\macros\\div_var.i"

MAX_VECTOR_MORPH EQU 20

; morphing stati...
MORPHING_DONE                   EQU  (lo(10)) ; this morphing structure finnished
MORPHING_WORKING                EQU  (lo(11)) ; is morphing
MORPHING_COMPLETE               EQU  (lo(0))  ; no more morphing

; a morph structure
;structure:
;               DW               ; morph from vector list
;               DW               ; morph to vector list
;               DB               ; morph steps
;               DB               ; delay between one morph step
;               DW               ; optional (0 or structure)
;                                ; pointer to next morph structure
;               DB               ; startup delay
;

morph_status                    DB 1 ; status---
morph_tmp                       DB 1 ; saves a few cycles... for the step counter only in one_morph_step
morph_tmp2                      DB 1 ;
morph_sign                      DB 1 ; number of steps between 'from' and 'to' variable
morph_counter                   DB 1 ; number of steps between 'from' and 'to' variable
morph_steps                     DB 1 ; number of steps between 'from' and 'to' constant
morph_delay                     DB 2 ; delay between one step and another (variable)
morph_structure                 DB 2 ; pointer to morphstructure of current morphing
morph_div_jsr                   DB 2 ; pointer to indirectly JSR to a divide routine (for optimization)

; current_morph_vectorlist_org
; is the original startlist, but possibly lengthened to the
; max vectorlist length of the two passed vectors (filled with 0,0 coordinates)
current_morph_vectorlist_org    DS 2*MAX_VECTOR_MORPH

; current_morph_vectorlist
; is the storage area for the next to be drawn vectorlist
; is set to the original vector list (not max length)
current_morph_vectorlist        DS 2*MAX_VECTOR_MORPH

; current_morph_vector_diffs
; not a real vector list, this contains the difference between the
; points of the two passed vector lists
; used in 'do_one_morph_step' to calculate the next vector
current_morph_vector_diffs      DS 2*MAX_VECTOR_MORPH

