;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ___modqi3 - signed modulo
;;; Arguments: Dividend in b, divisor on the stack
;;; Returns result in b.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
 .globl _modqi3
 .area	.text
_modqi3:
    sex 
    pshs    d
    ldb 1,s
    bne    do_mod_modqi3        ; check dividend
  jmp _abort ;rts ; do nothing on div by 0
    ;SIGFPE
do_mod_modqi3:
    sex
    bsr    _seuclid
    rts    
    