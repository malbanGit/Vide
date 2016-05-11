
; Electric Force - 233 bytes intro by Frog (for CC'2015)
; http://frog.enlight.ru
; frog@enlight.ru
;
; rev. 2 (optimized), July 2015
; (real Vectrex required!)

                include "vectrex.i"

counter         equ     $C880

;***************************************************************************
                org     0

                db      "g GCE 2015", $80 	; 'g' is copyright sign
                dw      $F600            	; music from the rom (no music)
                db      $FC, $30, 33, -$36	; height, width, rel y, rel x
	        	db      "ELECTRIC FORCE", $80	; app title, ending with $80
                db      0                 	; end of header

                ldx     #Char_Table       	; just source of some numbers...
                stx     counter
loop:
                jsr     Wait_Recal        	; recalibrate CRT, reset beam to 0,0

                lda     #$ff              	; scale (max possible)
                sta     <VIA_t1_cnt_lo

                jsr     Intensity_5F

; FRAME EDGE LINES ---------------------------


                ldd     #(60*256+(-64)) 	; Y,X
                jsr     Moveto_d

                ldd     #(0*256+(127)) 		; Y,X
                jsr     Draw_Line_d

                ldd     #(-102*256+(0)) 	; Y,X
                jsr     Moveto_d

                ldd     #(0*256+(-127)) 	; Y,X
                jsr     Draw_Line_d

; text

                ldu     #alltext
                jsr     Print_List_hw

; start drawing curve

                ldy     #0
nextcurve:
                jsr     Reset0Ref               ; recalibrate crt (x,y = 0)
                lda     #$CE                    ; /Blank low, /ZERO high
                sta     <VIA_cntl               ; enable beam, disable zeroing

                ldd     #(116*256+(30))         ; Y,X
                jsr     Moveto_d

                lda     ,y+
                rola
                jsr     Intensity_a

; Draw_Curve begin
; params: y - coeff. to make curves look different

                ldd     #$1881
                stb     <VIA_port_b        	; disable MUX, disable ~RAMP
                sta     <VIA_aux_cntl      	; AUX: shift mode 4. PB7 not timer controlled. PB7 is ~RAMP

                lda     #-85              	; Y -86
                sta     <VIA_port_a        	; Y to DAC

                decb                      	; b now $80
                stb     <VIA_port_b        	; enable MUX

                clrb
                inc     <VIA_port_b        	; MUX off, only X on DAC now
                stb     <VIA_port_a        	; X to DAC

                incb
                stb     <VIA_port_b        	; MUX disable, ~RAMP enable. Start integration

                ldb     #$ff
                stb     <VIA_shift_reg     	; pattern

                ldx     #0
                tfr     y,d
                exg     a,b
nextchunk:
                adca    counter

                rola
                sta     <VIA_port_a        	; put X to DAC

                leax    1,x                     ; inc x
                cmpx    #12                     ; 12 (+1) segments per curve
                bne     nextchunk

                ldb     #$81              	; ramp off, MUX off
                stb     <VIA_port_b

                lda     #$98
                sta     <VIA_aux_cntl      	; restore usual AUX setting (enable PB7 timer, SHIFT mode 4)

; Draw_Curve end


; draw bright end dot
                ldb     #30                     ; end dot brightness (hold dot long enough)

repeat_dot:     decb
                bne     repeat_dot

                clr     <VIA_shift_reg  	; Blank beam in VIA shift register

                cmpy    #30                     ; number of curves (max. which fit in 30000 cycles)
                bne     nextcurve

                inc     counter
                bra     loop

; Text lines
; height, width, rel y, rel x, string, eol ($80)

alltext:
                db      $fc,$20,120,15,'233 BYTES',$80
                db      $fc,$20,14,-113,'BY FROG',$80
                db      $fc,$20,-4,-113,'CC',$27,'2015',$80
                db      $fb,$20,50,-113,'ELECTRIC FORCE',$80
                db      0
