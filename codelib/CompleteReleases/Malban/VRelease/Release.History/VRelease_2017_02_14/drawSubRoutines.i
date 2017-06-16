***********************************************************
; obviously non optimized!
;
; list in x
; list:
; counter
; move y,x
; draw y,x * count
drawRotated

 ldd 1,x
 jsr Moveto_d
 lda ,x
 leax 3,x
 jsr Draw_VL_a 
 rts

; like draw_vlc with additional pattern byte befor each coordinate
; pattern byte is taken "directly" and used as shift value
draw_vlcp
                    JSR      Draw_VL_mode         ; Vectrex BIOS print routine 
 rts

