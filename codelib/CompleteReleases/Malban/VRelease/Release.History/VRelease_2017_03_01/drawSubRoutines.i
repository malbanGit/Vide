                    ***********************************************************  
; obviously non optimized!
;
; list in x
; list:
; counter
; move y,x
; draw y,x * count
drawRotated 
                    ldd      1,x 
                    jsr      Moveto_d 
                    lda      ,x 
                    leax     3,x 
                    jsr      Draw_VL_a 
                    rts      

; like draw_vlc with additional pattern byte befor each coordinate
; pattern byte is taken "directly" and used as shift value
draw_vlcp 
                    JSR      Draw_VL_mode                 ; Vectrex BIOS print routine 
                    rts      

; pointer the same list as "drawRotated" but only the corner "dots" are drawn
explosionDotDraw 
; in U pointer to current object
                    lda      SCALE,u 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo) 
                    JSR      Intensity_7F                 ; Sets the intensity of the 
                    ldd      Y_POS,u                      ; last position of object is center of explosion -> move there 
                    jsr      Moveto_d 
                    lda      EXPLOSION_SCALE,u 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldx      #rotList 
                    ldd      1,x 
                    jsr      Moveto_d 
                    jsr      Dot_here 
                    lda      ,x 
                    sta      tmp_count2 
                    leax     3,x 
next_edd: 
                    lda      tmp_count2 
                    deca     
                    sta      tmp_count2 
                    bmi      done_edd 
                    ldd      ,x++ 
                    jsr      Moveto_d 
                    jsr      Dot_here 
                    bra      next_edd 

done_edd: 
                    rts      
