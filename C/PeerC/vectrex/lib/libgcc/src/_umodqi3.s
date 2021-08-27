;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___umodqi3 - unsigned modulo
;;; Arguments: Dividend in b, divisor on the stack
;;; Returns result in b.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 .globl _umodqi3
 .area	.text
_umodqi3:
    sex 
    pshs    d
    ldb 1,s
    bne    do_umod_umodqi3        ; check dividend
  jmp _abort ;rts ; do nothing on div by 0
    ;SIGFPE
do_umod_umodqi3:
    sex
    bsr    _euclid
    rts    