; all stuff contained here is public domain (?)
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains makro definitions of vectrex BIOS functions, these are ;
; exact clones of the BIOS functions                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 if UTIL_I != 1

UTIL_I equ 1
;***************************************************************************
_DP_TO_CB        macro
                 LDA     #$CB
                 TFR     A,DP
                 direct  $CB             ; pretty for optimizing to use a makro :-)
                 endm
;***************************************************************************
_DP_TO_CA        macro
                 LDA     #$CA
                 TFR     A,DP
                 direct  $CA             ; pretty for optimizing to use a makro :-)
                 endm
;***************************************************************************
_DP_TO_C9        macro
                 LDA     #$C9
                 TFR     A,DP
                 direct  $C9             ; pretty for optimizing to use a makro :-)
                 endm
;***************************************************************************
_DP_TO_C8        macro
                 LDA     #$C8
                 TFR     A,DP
                 direct  $C8             ; pretty for optimizing to use a makro :-)
                 endm
;***************************************************************************
_DP_TO_D0        macro
                 LDA     #$D0
                 TFR     A,DP
                 direct  $D0             ; pretty for optimizing to use a makro :-)
                 endm
;***************************************************************************
_ABS_A_B         macro
                 local  leave_here
                 local  Abs_b
                 TSTA
                 BPL     Abs_b
                 NEGA
                 BVC     Abs_b
                 DECA
Abs_b:           TSTB
                 BPL     leave_here
                 NEGB
                 BVC     leave_here
                 DECB
leave_here:
                 endm
;***************************************************************************
_ABS_B           macro
                 local  leave_here
                 local  Abs_b
Abs_b:           TSTB
                 BPL     leave_here
                 NEGB
                 BVC     leave_here
                 DECB
leave_here:
                 endm
;***************************************************************************

         endif