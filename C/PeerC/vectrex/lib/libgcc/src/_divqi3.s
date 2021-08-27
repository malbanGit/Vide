;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___divqi3 - signed division
;;; Arguments: Dividend in b, divisor on the stack
;;; Returns result in b.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 .globl _divqi3
 .area	.text
_divqi3:
    sex 
    pshs    d
    ldb 1,s
    bne    do_div_divqi3        ; check dividend
  jmp _abort ;rts ; do nothing on div by 0
    ;SIGFPE
do_div_divqi3:
    sex
    bsr    _seuclid
    puls    d, pc

