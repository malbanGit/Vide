; all behaviour routines leave
; with u pointed to the next object structure (or 0)


; GENERAL Object functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; also move objects, moving for "normal" enemies "X" is decrease of scale
do_objects 
 ldu list_objects_head    
 beq do_done
do_next: 
    ; object lists are nicely ordered, so we start at the beginning
                    jsr      [BEHAVIOUR,u] 
 cmpu #0
                    bne      do_next 
do_done: 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SET_U_FREE macro
 ; set u free, as new free head
 ldy list_empty_head
 sty NEXT_OBJECT,u
 stu list_empty_head
 leau ,x
 puls x, y
 endm

; in u pointer to the object that must be removed
; destroys x, y
; sets u to pointer of next object in linked list (or 0)
removeObject:                                             ;#isfunction  
 pshs x, y
 ldx NEXT_OBJECT,u
 beq was_last_re
 ldy PREVIOUS_OBJECT,u
 beq was_first_re

 stx NEXT_OBJECT,y ; set next object as previous next
 sty PREVIOUS_OBJECT,x ; set previous object as next previous

 SET_U_FREE
 rts

was_first_re
 sty PREVIOUS_OBJECT,x ; clear previous' object of next object
 stx list_objects_head; set next object as head
 SET_U_FREE
 rts

was_last_re:
 ldy PREVIOUS_OBJECT,u
 beq was_last_and_first_re
 stx NEXT_OBJECT,y ; clear last objects next object
 sty list_objects_tail; set last object as tail
 SET_U_FREE
 rts


; clear both
was_last_and_first_re:
 stx list_objects_head
 stx list_objects_tail
 SET_U_FREE
 rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SPECIFIC Object functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
; 
; ! the behavhoiur is responsibly to
; increase the U pointer (                    leau     ObjectStruct,u)
; since e.g. a remove does NOT increase the pointer!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
xBehaviour;#isfunction
                    dec      SCALE,u 
                    beq      removeObject 
base_not_reached 
                    lda      SCALE,u 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo) 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                    ldd      Y_POS,u 
                    jsr      Moveto_d 
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldx      CURRENT_LIST,u 
                    jsr      [DRAW_ROUTINE,u] 
                    ldu      NEXT_OBJECT,u 
                    jmp      Reset0Ref 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

explosionBehaviour ;#isfunction 
                    lda  EXPLOSION_SCALE,u 
;                    inca 
;                    inca 
                    inca 
                    sta  EXPLOSION_SCALE,u 
                    cmpa #EXPLOSION_MAX  
                    bgt endExplosion
; draw exposion
                    jsr      [DRAW_ROUTINE,u] 

                    ldu     NEXT_OBJECT,u 
                    jmp      Reset0Ref 
endExplosion:
                    jmp      removeObject 

