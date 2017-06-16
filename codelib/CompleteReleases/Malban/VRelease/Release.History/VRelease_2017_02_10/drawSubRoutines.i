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
