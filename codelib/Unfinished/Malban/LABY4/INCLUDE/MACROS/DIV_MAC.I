; all stuff contained here is public domain (?)
;
 if DIVIDE_I != 1

 include "INCLUDE\\MACROS\\6809_MAC.I"

DIVIDE_I equ 1

;***************************************************************************
MY_LSR_D              macro
                ASRA
                RORB
                      endm               ; done

;***************************************************************************
DIV_D_64_A              macro
                ASLB                              ; this divides d by 64
                ROLA                              ; result in A
                ASLB
                ROLA
                      endm               ; done
;***************************************************************************
 endif
