
MY_DRAW_VL       macro
                 LDD     ,X++
                 STA     <VIA_port_a       ; Send Y to A/D
                 CLRA
                 STA     <VIA_port_b       ; Enable mux
;                 ...
                 INC     <VIA_port_b       ; Disable mux
                 STB     <VIA_port_a       ; Send X to A/D

                 DEC     <VIA_shift_reg    ; Put pattern in shift register
                 STA     <VIA_t1_cnt_hi    ; enable timer 1
                 LDB     #$40              ; B-reg = T1 interrupt bit
timer1_test\?:
                 BITB    <VIA_int_flags    ; Wait for T1 to time out
                 BEQ     timer1_test\?
                 STA     <VIA_shift_reg    ; Clear shift register (blank output)
                 endm

MY_MOV_DRAW_VL   macro
                 LDD     ,X++
                 STA     <VIA_port_a       ; Send Y to A/D
                 CLRA
                 STA     <VIA_port_b       ; Enable mux
;                 ...
                 INC     <VIA_port_b       ; Disable mux
                 STB     <VIA_port_a       ; Send X to A/D
                 ; assuming shift is zero -> should really allways be thus
                 STA     <VIA_t1_cnt_hi    ; enable timer 1
                 LDB     #$40              ; B-reg = T1 interrupt bit
timer1_test\?:
                 BITB    <VIA_int_flags    ; Wait for T1 to time out
                 BEQ     timer1_test\?
;                 STA     <VIA_shift_reg    ; Clear shift register (blank output)
                 endm


                 INCLUDE "vectrex.i"

segment_helper   EQU $c880
segment_size     EQU $c882

                 ORG     0
; start of vectrex memory with cartridge name...
                 DB      "g GCE 1998", $80 ; 'g' is copyright sign
                 DW      music             ; music from the rom
                 DB      $F8, $50, $20, -$80; hight, width, rel y, rel x (from 0,0)
                 DB      "7 SEGMENT TEST", $80; some game information, ending with $80
                 DB      0                 ; end of game header
;***************************************************************************
; here the cartridge program starts off
                 direct  $d0
                 LDA     #20
                 STA     segment_size
main:
                 ; first allways is a wait_recal, as usual
                 JSR     Wait_Recal        ; same as makro: WAIT_RECAL_DIGIT
                 LDA     #$CE            ;/Blank low, /ZERO high
                 STA     VIA_cntl

                 LDA     segment_size     ; TIME FOR THE VECTORS
                 STA     VIA_t1_cnt_lo
                 LDU     #sample_number
                 JSR     draw_7segment
                 BRA     main              ; default... should never be here

; expects some pointer to BCD-number in U, backwards
; ends with negative 'digit'
; leaves c823 in negative state
draw_7segment:
                 LDY     #segment_decode  ; load address of 7 segment decode table
digit_done:
                 LDA     ,U+              ; get first digit to be displayed
                 BMI     Reset0Ref        ; if below zero (high bit set), than
                                          ; we are finnished and we will
                                          ; jmp to reset0ref, and rts from there
                 LDA     A,Y              ; load value from the decode table
                 LDB     #1               ; this is our 'wandering' bit, used for
                                          ; testing the bits we got from  our
                                          ; decoder table
                 STD     segment_helper   ; and remember both...
                 LDX     #segment_shape   ; load address of 7 segment 'vector'-list
                 BRA     start_new_segment; and start drawing this 7 segment  'unit'
next_segment_line:
                 ASL     segment_helper+1 ; shift the bit in 'B' 1 (B from 4 lines above)
                                          ; we go thru all 8 bits, once we have done all
                                          ; shifting it reaches zero, than we are finnished
                                          ; with this segment.
                                          ; we use all 8 bits, 7 for the segments, the 8'th
                                          ; for positioning the beam for the next segment
                                          ; pretty clever!
                 BEQ    digit_done        ; if zero, we are done with this segment, and jump to digit_done
                 LDB    segment_helper+1  ; otherwise load our test-bit to B
start_new_segment:
                 ; if the bit is set, in the value we got from our
                 ; decode table...
                 ; we draw a line, otherwise
                 ; we only move to next position
                 BITB    segment_helper   ; test the bit
                 BEQ     move_to_next_segment_line; if not set, we only move to the next segment
                 ; draw this segment line
                 MY_DRAW_VL               ; makro... the same as
                                          ; BIOS Draw_VL function, but
                                          ; using this we save couple of
                                          ; thousand cycles...
                 BRA     next_segment_line; and go back, look for next segment
move_to_next_segment_line:                ; makro... the same as
                 MY_MOV_DRAW_VL           ; BIOS Mov_Draw_VL function, but
                                          ; using this we save couple of
                                          ; thousand cycles...
                 BRA     next_segment_line; and go back, look for next segment

sample_number:
                 db 1,2,3,-1
sample_number_end:


segment_decode:          ; 7 SEGMENT DECODER FOR SCORE DISPLAY
                 DB      $77,$11,$6B,$3B,$1D,$3E,$7E,$13      ; 0-7
                 DB      $7F,$3F,$5F,$7C,$66,$79,$6E,$4E      ; 8-9,A-F
                 DB      $00,$20,$08,$02,$0F,$78              ; BLANK,DASHES,SQUARES

segment_shape:        ; DRAWS SHAPE OF 7 SEG RECTANGLE
J      EQU     $40
                 DB      J,0       ; bit 0       1           ------
                 DB      0,-J      ; bit 1       2           I 2  I
                 DB      -J,0      ; bit 2       3          3I    I1
                 DB      0,J       ; bit 3       4           I 4  I
                 DB      -J,0      ; bit 4       5     end8 #------* start
                 DB      0,-J      ; bit 5       6          7I    I5
                 DB      J,0       ; bit 6       7           I 6  I
                 DB      0,-(J/4)  ; bit 7       8           ------
                 ; bit 7 is the space between to segments
music:
        FDB     $ff16,$feb6
        FCB     $00,  $80
