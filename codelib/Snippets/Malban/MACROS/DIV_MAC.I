; all stuff contained here is public domain (?)
;
 if DIVIDE_I != 1

 include "include\\macros\\6809_mac.i"

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
MY_DIV_D_16_UNSIGNED macro
                      LSLA
                      LSLA
                      LSLA
                      LSLA
                      LSRB
                      LSRB
                      LSRB
                      LSRB
                      STA divide_tmp
                      ORB divide_tmp
                      endm
;***************************************************************************
 endif
