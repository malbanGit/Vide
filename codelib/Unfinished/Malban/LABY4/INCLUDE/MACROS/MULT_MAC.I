;***************************************************************************
; there are many 16 bit operands missing, so is
; a LSRD
; this macro does a 16 bit LSR on register D
MY_LSL_D              macro
                      LSLA               ; LSR A
                      LSLB               ; LSR B
                      BCC no_carry\?     ; if no carry, than exit
                      INCA
no_carry\?:
                      endm               ; done
;***************************************************************************
