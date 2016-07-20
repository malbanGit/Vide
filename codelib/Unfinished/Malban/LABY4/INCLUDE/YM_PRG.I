                direct  $d0             ; following code uses d0
;***************************************************************************
do_ym_sound:
                ldd     ym_data_current
                beq     do_ym_sound_done
                subd    #1
                std     ym_data_current
                clra
                sta     current_register
                ldu     #ym_data_start
next_reg:
                jsr     get_current_byte
                lda     current_register
                ; A PSG reg
                ; B data
                jsr     Sound_Byte

                leau    STRUCTURE_LENGTH,u
                inc     current_register
                lda     current_register
                cmpa    #11
                bne     next_reg
do_ym_sound_done:
                RTS

no_valid_byte:
; no we must look at the bits
; a will be our bit register
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POSITION,u
                bne     byte_ready_1
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #$80
                stb     BIT_POSITION,u
byte_ready_1:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
;;;;;;;;;;;;;;;;;;; GET_BIT END
; zero flag show bit
; A is 1 or zero
                lbne     no_single_byte
single_byte:
                ; must be zero
                ; 1 is allways only 8 bit...
                inc      CURRENT_RLE_COUNTER+1,u
dechifer:
                clr       calc_bits
                clr       calc_coder
try_next_bit:
                lsl       calc_coder
                inc       calc_bits    ; increase used bits
;;;;;;;;;;;; GET_BIT_START
                ldb     BIT_POSITION,u
                bne     byte_ready
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #$80
                stb     BIT_POSITION,u
byte_ready:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
                beq     no_add     ; and if non zero
                inc     calc_coder
;;;;;;;;;;;; GET_BIT_END
no_add:
; we load one complete set of mapper index, bits, coder, map-value
                ldx       CURRENT_RLE_MAPPER,u
search_again:
                leax      3,x
                lda       ,x          ; load bits from map
                anda      #127         ; map out phrases
                cmpa      calc_bits      ; neu
                bgt       try_next_bit ; neu
                bne       search_again
                ldb       1,x          ; load coder-byte
                cmpb      calc_coder
                bne       search_again
                ldb       2,x           ; load current mapped byte!
; in b is the byte value we sought
; test for phrase
                lda       ,x          ; load bits from map
                anda     #128         ; map in phrases only
                beq      no_phrase_d
; if phrase, than in b the count of the phrase used
                ldx      CURRENT_PHRASE_START,u
                tstb
                beq     phrase_found
next_phrase:
                lda     ,x+
                leax    a,x
                decb
                bne     next_phrase
phrase_found:
                stx     CURRENT_IS_PHRASE,u
                clr     CURRENT_PHRASE_BYTE,u
                bra      out
no_phrase_d:
                clr      CURRENT_IS_PHRASE,u
                clr      CURRENT_IS_PHRASE+1,u
                stb      CURRENT_UNPACKED_BYTE,u
out:

; U pointer to data structure
; A number of register
get_current_byte:
; do we have a byte that is valid?
                ldd      CURRENT_RLE_COUNTER,u
                beq      no_valid_byte
; yep... use current byte
                ldx       CURRENT_IS_PHRASE,u
                beq       no_phrase
                lda       ,x+ ; length of phrase
                ldb       CURRENT_PHRASE_BYTE,u
                ldb       b,x ; this is the current byte
                stb       CURRENT_UNPACKED_BYTE,u
                inc       CURRENT_PHRASE_BYTE,u
                cmpa      CURRENT_PHRASE_BYTE,u
                bne       counter_not_minus_one
                clr       CURRENT_PHRASE_BYTE,u
                ldd       CURRENT_RLE_COUNTER,u
no_phrase:
                subd      #1
                std       CURRENT_RLE_COUNTER,u
counter_not_minus_one:
                ldb       CURRENT_UNPACKED_BYTE,u
                rts

no_single_byte:
; non single byte here... must decode
; first we look for how many bits the RLE counter spreads

                ; we already encountered a 1
                ; and we allways use + 2
                lda     #2
                sta     temp
more_bits:
                inc     temp
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POSITION,u
                bne     byte_ready_2
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #$80
                stb     BIT_POSITION,u
byte_ready_2:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
;;;;;;;;;;;;;;;;;;; GET_BIT END
                bne     more_bits
; in temp is the # of bits for the counter
; the following '#temp' bits represent the RLE count
; lsb first
                incb            ; we start at 1, since zero is an
                                ; 'own' 'subroutine',
                                ; which doesn't manipulate the temps
                stb     temp2   ; bit counter for shifting
                stb     temp3   ; bit counter for shifting
go_on:
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POSITION,u
                bne     byte_ready_3
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #$80
                stb     BIT_POSITION,u
byte_ready_3:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
                beq     end_here_3
; return 1
                ldb     #1
end_here_3:
;;;;;;;;;;;;;;;;;;; GET_BIT END
; in D now one bit at the right position for the RLE counter
                stb     CURRENT_RLE_COUNTER+1,u
; the first 3 (here only the first one) rounds
; we need not check for temp, since it is at least 3...
go_on_2:
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POSITION,u
                bne     byte_ready_4
; load a new byte
                ldx     BYTE_POSITION,u
                ldb     ,x+
                stb     CURRENT_BYTE,u
                stx     BYTE_POSITION,u
                ldb     #$80
                stb     BIT_POSITION,u
byte_ready_4:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POSITION,u

; is the bit at the current position set?
                andb    CURRENT_BYTE,u
                beq     end_here_4
; return 1
                ldb     #1
end_here_4:
                clra
shifting_not_yet_done:
                      LSLA               ; LSR A
                      LSLB               ; LSR B
                      BCC no_carry       ; if no carry, than exit
                      ORA #1             ; otherwise underflow from A to 7bit of B
no_carry:
                dec     temp3
                bne     shifting_not_yet_done
shifting_done:
; in D now one bit at the right position for the RLE counter
                addd    CURRENT_RLE_COUNTER,u
                std     CURRENT_RLE_COUNTER,u

                inc     temp2
                lda     temp2
                sta     temp3
                cmpa    temp
                bne     go_on_2
; now the current counter should be set

; we still need to dechifer the following byte...
                bra       dechifer

init_ym_sound:
                ldx     #ym_data_start
                ldd     #(STRUCTURE_LENGTH*11)
                jsr     Clear_x_d

                ldy     ,u++
                ldd     ,y
                std     ym_data_len
                std     ym_data_current
                ldb     #11
next_reg_init:
                ldy     ,u++
                sty     CURRENT_RLE_MAPPER,x
                ldy     ,u++
                sty     CURRENT_PHRASE_START,x
                ldy     ,u++
                sty     BYTE_POSITION,x
                leax    STRUCTURE_LENGTH,x
                decb
                bne     next_reg_init
                stu     ym_name
                RTS
