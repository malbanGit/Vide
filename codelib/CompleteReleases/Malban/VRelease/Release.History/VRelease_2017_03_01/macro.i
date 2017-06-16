;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro D = D *2
MY_LSL_D            macro    
                    ASLB     
                    ROLA     
                    endm                                  ; done 
; macro D = D /2
MY_LSR_D            macro    
                    ASRA     
                    RORB     
                    endm                                  ; done 
; set X to correct correction pointer for current sidedness polygon
SET_CORRECTION_POINTER  macro  
                    ldx      #polygon_5_correction 
                    lda      sided 
                    cmpa     #5 
                    beq      done\? 
                    leax     <(polygon_6_correction-polygon_5_correction),x 
                    cmpa     #6 
                    beq      done\? 
                    leax     <(polygon_7_correction-polygon_6_correction),x 
                    cmpa     #7 
                    beq      done\? 
                    leax     <(polygon_8_correction-polygon_7_correction),x 
done\? 
                    endm     
; load the "divider" for n polygone (given in sided)
; to d
GET_POLY_DIV        macro    
                    lda      sided 
                    cmpa     #5 
                    bne      test_n6\? 
                    ldd      #FIVE_ADD 
                    bra      got_it\? 

test_n6\?: 
                    cmpa     #6 
                    bne      test_n7\? 
                    ldd      #SIX_ADD 
                    bra      got_it\? 

test_n7\?: 
                    cmpa     #7 
                    bne      test_n8\? 
                    ldd      #SEVEN_ADD 
                    bra      got_it\? 

test_n8\?: 
                    ldd      #EIGHT_ADD 
got_it\?: 
                    endm     