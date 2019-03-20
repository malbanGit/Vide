; all stuff contained here is public domain (?)
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains makro definitions of vectrex BIOS functions, these are ;
; exact clones of the BIOS functions                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
        if BEAM_I != 1

BEAM_I equ 1
 INCLUDE "INCLUDE/VECTREX.I"
;***************************************************************************
_ZERO_VECTOR_BEAM macro
                 LDB     #$CC
                 STB     VIA_cntl       ;/BLANK low and /ZERO low
                 endm
;***************************************************************************
; like BIOS, but Macro
_INTENSITY_A     macro
                 STA     VIA_port_a     ;Store intensity in D/A
                 STA     Vec_Brightness  ;Save intensity in $C827
                 LDD     #$0504          ;mux disabled channel 2
                 STA     VIA_port_b     ;
                 STB     VIA_port_b     ;mux enabled channel 2
                 STB     VIA_port_b     ;do it again just because ?
                 LDB     #$01            ;
                 STB     VIA_port_b     ;turn off mux
                 endm
;***************************************************************************
; like BIOS, but Macro
_INTENSITY       macro value
                 LDA     #\1
                 _INTENSITY_A
                 endm

;***************************************************************************
; optimzed
INTENSITY_A     macro
                 STA     VIA_port_a     ;Store intensity in D/A
                 LDD     #$0504          ;mux disabled channel 2
                 STA     VIA_port_b     ;
                 STB     VIA_port_b     ;mux enabled channel 2
                 LDB     #$01            ;
                 STB     VIA_port_b     ;turn off mux
                 endm
;***************************************************************************
; optimzed
INTENSITY       macro value
                 LDA     #\1
                 _INTENSITY_A
                 endm
;***************************************************************************
_SCALE_A         macro
                 STA     VIA_t1_cnt_lo   ; move to time 1 lo, this means scaling
                 endm
_SCALE_B         macro
                 STB     VIA_t1_cnt_lo   ; move to time 1 lo, this means scaling
                 endm
;***************************************************************************
_SCALE           macro value
                 LDA     #\1             ; scale for placing first point
                 _SCALE_A
                 endm
; ***************************************************************************

         endif