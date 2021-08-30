;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___udivqi3 - unsigned division
;;; Arguments: Dividend in b, divisor on the stack
;;; Returns result in b.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 .globl _udivqi3
 .area	.text
_udivqi3:
    sex 
    pshs    d
    ldb 1,s
    bne    do_udiv_udivqi3        ; check dividend
  jmp _abort ;rts ; do nothing on div by 0
    ;SIGFPE
do_udiv_udivqi3:
    sex
    bsr    _euclid
    puls d,pc    
    