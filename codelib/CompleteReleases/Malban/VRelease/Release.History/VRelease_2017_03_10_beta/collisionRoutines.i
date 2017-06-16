; b = lower part of U
; all following "divi" routines
; substract from U some fraction
; original it was supposed to 
; substract the name giving divider - but that was cancled
; look at the header what fraction is removed

div32:
;;;; - 1 / 16 (0,031)
 lsrb 
 lsrb 
 lsrb 
 lsrb 
 lsrb ; b = b/16
 negb
 leau b,u
 rts
div16:
;;;; - 1 / 16 (0,0625)
 lsrb 
 lsrb 
 lsrb 
 lsrb ; b = b/16
 negb
 leau b,u
 rts
div12:
;;;; -1/16-1/64 (0,0781)
 lsrb 
 lsrb 
 lsrb 
 lsrb ; b = b/16
 negb
 leau b,u
 negb
 lsrb 
 lsrb ; b = b/64
 negb
 leau b,u
 rts
div11:
;;;; -1/8 + 1/32 (0,1 => 0,93)
 lsrb 
 lsrb 
 lsrb ; b = b/8
 negb
 leau b,u
 negb
 lsrb 
 lsrb ; b = b/64
 leau b,u
 rts
div10:
;;;; -1/8 + 1/64 (0,1 => 0,109)
 lsrb 
 lsrb 
 lsrb ; b = b/8
 negb
 leau b,u
 negb
 lsrb 
 lsrb 
 lsrb ; b = b/64
 leau b,u
 rts
div9:
;;;; -1/8 + 1/18 (0,1 => 0,117)
 lsrb 
 lsrb 
 lsrb ; b = b/8
 negb
 leau b,u
 negb
 lsrb 
 lsrb 
 lsrb 
 lsrb ; b = b/128
 leau b,u
 rts
div8:
;;;; -1/8 ( 0,125)
 lsrb 
 lsrb 
 lsrb ; b = b/8
 negb
 leau b,u
 rts
div7:
;;;; -1/8 - 1/64 (0,1406)
 lsrb 
 lsrb 
 lsrb ; b = b/8
 negb
 leau b,u
 negb
 lsrb 
 lsrb 
 lsrb ; b = b /64
 negb
 leau b,u
 rts
div6:
;;;; -1/8 - 1/32 ( 0,156)
 lsrb 
 lsrb 
 lsrb ; b = b/8
 negb
 leau b,u
 negb
 lsrb 
 lsrb ; b = b/32
 negb
 leau b,u
 rts

div52:
;;;; -1/4 + 1/16+1/64 (0,171)
 lsrb 
 lsrb ; b = b/4
 negb
 leau b,u
 negb
 lsrb 
 lsrb ; b = b/16
 leau b,u
 lsrb 
 lsrb ; b = b/64
 leau b,u
 rts
div53:
;;;; -1/4 + 1/16(0,1875)
 lsrb 
 lsrb ; b = b/4
 negb
 leau b,u
 negb
 lsrb 
 lsrb ; b = b/16
 leau b,u
 rts
div55:
;;;; -1/4 + 1/32 + 1/64(0,2031)
 lsrb 
 lsrb ; b = b/4
 negb
 leau b,u
 negb
 lsrb 
 lsrb 
 lsrb ; b = b/32
 leau b,u
 lsrb ; b = b/64
 leau b,u
 rts
div5:
;;;; -1/4 + 1/32 (0,218)
 lsrb 
 lsrb ; b = b/4
 negb
 leau b,u
 negb
 lsrb 
 lsrb 
 lsrb ; b = b/32
 leau b,u
 rts

NO_DIV = 0
DIV_BY32 = 1
DIV_BY16 = 2
DIV_BY12 = 3
DIV_BY11 = 4
DIV_BY10 = 5
DIV_BY9 = 6
DIV_BY8 = 7
DIV_BY7= 8
DIV_BY6 = 9
DIV_BY52 = 10
DIV_BY53 = 11
DIV_BY55 = 12
DIV_BY5 = 13

divi_list:
 dw 0
 dw div32
 dw div16
 dw div12
 dw div11
 dw div10
 dw div9
 dw div8
 dw div7
 dw div6
 dw div52
 dw div53
 dw div55
 dw div5

getDivi_b:
 pshs u,x
 clra
 tfr d,u
 lda ,y
 beq subCompleteDone
 lsla

 ldx #divi_list
 jsr [a,x] 

 tfr u,d
subCompleteDone:
 puls u,x
 rts

