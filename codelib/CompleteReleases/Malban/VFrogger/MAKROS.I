; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain (?)
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains makro definitions of vectrex BIOS functions, these are ;
; exact clones of the BIOS functions                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
        ifndef MACRO_I 

MACRO_I equ 1
                 INCLUDE "VECTREX.I"
; most of these macros are taken from the ROM to avoid
; all those JSR / RTS, in order to save time (over space)
;
; some of these 'functions' look like they could be optimized
; I did however NOT optimze anything, since I'm not sure
; that it isn't used for any timing stuff...

;_ZERO_VECTOR_BEAM      macro
;_INTENSITY_A           macro
;_INTENSITY             macro value
;_SCALE_A               macro
;_SCALE_B               macro
;_SCALE                 macro value
;_DRAW_LINE_D           macro
;_DRAW_LINE             macro __x,__y
;_DRAW_REL_LINE_FROM    macro __x1,__y1,__x2,_y2
;_DRAW_ZERO_LINE_FROM   macro __x1,__y1,__x2,_y2
;_DRAW_LINE_PATTERN     macro __x,__y,__p
;_ABS_A_B               macro
;_ABS_B                 macro
;_MOVE_TO_D             macro
;_MOVE_TO               macro __x,__y
;_DRAW_VLC              macro
;_DRAW_DIRECT_VLC       macro list_address
;_DRAW_DIRECT_POS_VLC   macro __x, __y, list_address
;_DP_TO_C8              macro
;_DP_TO_D0              macro
;_DO_SOUND              macro
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
_ZERO_VECTOR_BEAM macro
                 LDB     #$CC
                 STB     <VIA_cntl       ;/BLANK low and /ZERO low
                 endm
;***************************************************************************
_INTENSITY_A     macro
                 STA     <VIA_port_a     ;Store intensity in D/A
                 STA     Vec_Brightness  ;Save intensity in $C827
                 LDD     #$0504          ;mux disabled channel 2
                 STA     <VIA_port_b     ;
                 STB     <VIA_port_b     ;mux enabled channel 2
                 STB     <VIA_port_b     ;do it again just because ?
                 LDB     #$01            ;
                 STB     <VIA_port_b     ;turn off mux
                 endm
;***************************************************************************
_INTENSITY       macro value
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
;***************************************************************************
_DRAW_LINE_D     macro
                 local  LF3F4            ;defines 'LF3F4' as a local variable
                 STA     <VIA_port_a     ;Send Y to A/D
                 CLR     <VIA_port_b     ;Enable mux
                 ; the followin two instructions might be optimized
                 ; but there is something about 18 cycles :-)
                 LEAX    2,X             ;Point to next coordinate pair
                 NOP                     ;Wait a moment
                 INC     <VIA_port_b     ;Disable mux
                 STB     <VIA_port_a     ;Send X to A/D
                 LDD     #$FF00          ;Shift reg=$FF (solid line), T1H=0
                 STA     <VIA_shift_reg  ;Put pattern in shift register
                 STB     <VIA_t1_cnt_hi  ;Set T1H (scale factor?)
                 LDD     #$0040          ;B-reg = T1 interrupt bit
LF3F4:           BITB    <VIA_int_flags  ;Wait for T1 to time out
                 BEQ     LF3F4           ;
                 NOP                     ;Wait a moment more
                 STA     <VIA_shift_reg  ;Clear shift register (blank output)
                 endm
;***************************************************************************
_DRAW_LINE       macro __x,__y
                 LDA     #\2
                 LDB     #\1
                 _DRAW_LINE_D
                 endm
;***************************************************************************
_DRAW_LINE_PATTERN     macro __x,__y,__p
                 LDA     #\2
                 LDB     #\1

                 STA     <VIA_port_a    ;Send Y to A/D
                 CLR     <VIA_port_b    ;Enable mux
                 LEAX    2,X            ;Point to next coordinate pair (here a NOP)
                 INC     <VIA_port_b    ;Disable mux
                 STB     <VIA_port_a    ;Send X to A/D
                 LDA     \3             ;Get default pattern
                 LDB     #$40           ;B-reg = T1 interrupt bit
                 STA     <VIA_shift_reg ;Put pattern in shift register
                 CLR     <VIA_t1_cnt_hi ;Clear T1H (scale factor?)
                 BITB    VIA_int_flags  ;Check if T1 timed out (note wasted byte)
                 BEQ     LF45C\?        ;Update pattern if not
                 CLR     <VIA_shift_reg ;Clear shift register (blank output)
                 BRA     done\?
;                This code is for lines that are not really short lines
LF459\?:         LDA     \3             ;Get default pattern
LF45C\?:         STA     <VIA_shift_reg ;Update pattern register
                 NOP                    ;Wait a moment
                 BITB    <VIA_int_flags ;Check if T1 timed out
                 BEQ     LF459\?        ;Update pattern again if not
                 LDA     $C823          ;Get line counter (here also NOP)
                 CLR     <VIA_shift_reg ;Clear shift register (blank output)
done\?:
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
_MOVE_TO_D       macro
                 local   LF345
                 local   LF33B
                 local   LF33D
                 local   LF341
                 local   leave_here
                 STA     <VIA_port_a     ;Store Y in D/A register
                 CLR     <VIA_port_b     ;Enable mux
                 PSHS    D               ;Save D-register on stack
                 LDA     #$CE            ;Blank low, zero high?
                 STA     <VIA_cntl       ;
                 CLR     <VIA_shift_reg  ;Clear shift regigster
                 INC     <VIA_port_b     ;Disable mux
                 STB     <VIA_port_a     ;Store X in D/A register
                 CLR     <VIA_t1_cnt_hi  ;timer 1 count high
                 PULS    D               ;Get back D-reg
                 _ABS_A_B                ;
                 STB     -1,S            ;
                 ORA     -1,S            ;
                 LDB     #$40            ;
                 CMPA    #$40            ;
                 BLS     LF345           ;
                 CMPA    #$64            ;
                 BLS     LF33B           ;
                 LDA     #$08            ;
                 BRA     LF33D           ;

LF33B:           LDA     #$04            ;Wait for timer 1
LF33D:           BITB    <VIA_int_flags  ;
                 BEQ     LF33D           ;
LF341:           DECA                    ;Delay a moment
                 BNE     LF341           ;
                 BRA     leave_here      ;
                                         ;
LF345:           BITB    <VIA_int_flags  ;Wait for timer 1
                 BEQ     LF345
leave_here:
                 endm
;***************************************************************************
_MOVE_TO         macro __x, __y
                 LDA     #\2
                 LDB     #\1
                 _MOVE_TO_D
                 endm
;***************************************************************************
_DRAW_REL_LINE_FROM macro __x1,__y1,__x2,__y2
                 _MOVE_TO \1,\2
                 _DRAW_LINE \3,\4
                 endm
;***************************************************************************
_DRAW_ZERO_LINE_FROM macro __x1,__y1,__x2,__y2
                 _ZERO_VECTOR_BEAM
                 _DRAW_REL_LINE_FROM \1, \2, \3, \4
                 endm
;***************************************************************************
_DRAW_VLC        macro
                 LDA     ,X+             ;
_DRAW_VLA\?                              ; the local directive doesn't work here ???
                                         ; I think because it is a makro using makro...
                 STA     $C823           ;
                 LDD     ,X              ;
                 _DRAW_LINE_D            ;
                 LDA     $C823           ;Decrement line count
                 DECA                    ;
                 BPL     _DRAW_VLA\?     ;Go back for more points
                 endm
;***************************************************************************
_DRAW_DIRECT_VLC macro list_address
                 LDX     #\1             ; address of home vector list
                 _DRAW_VLC
                 endm
;***************************************************************************
_DRAW_DIRECT_VLCP macro list_address
                 LDX     \1              ; address of home vector list
                 _DRAW_VLC
                 endm
;***************************************************************************
_DRAW_DIRECT_POS_VLC macro __x, __y, list_address
                 _MOVE_TO \1,\2
                 _DRAW_DIRECT_VLC \3
                 endm
;***************************************************************************
_DRAW_DIRECT_POS_VLCP macro __x, __y, list_address
                 _MOVE_TO \1,\2
                 _DRAW_DIRECT_VLCP \3
                 endm
;***************************************************************************
_DO_SOUND        macro
                 local   LF291
                 local   LF299
                 LDX     #Vec_Snd_Shadow ;point to shadow memory
                 LDU     #Vec_Music_Work ;point to sound buffer
                 LDA     #$0D            ;init count for 14 registers
LF291:           LDB     ,U+             ;get next register
                 CMPB    A,X             ;skip if unchanged
                 BEQ     LF299           ;
                 STB     A,X             ;
                 STA     <VIA_port_a     ;store register select byte
                 LDA     #$19            ;sound BDIR on, BC1 on, mux off
                 STA     <VIA_port_b     ;
                 LDA     #$01            ;sound BDIR off, BC1 off, mux off
                 STA     <VIA_port_b     ;
                 LDA     <VIA_port_a     ;read sound chip status (?)
                 STB     <VIA_port_a     ;store data byte
                 LDB     #$11            ;sound BDIR on, BC1 off, mux off
                 STB     <VIA_port_b     ;
                 LDB     #$01            ;sound BDIR off, BC1 off, mux off
                 STB     <VIA_port_b     ;
LF299:           DECA                    ;go back for next register
                 BPL     LF291           ;
                 endm
;***************************************************************************
         endif