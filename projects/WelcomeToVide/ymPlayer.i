Sound_Byte=$F256
Clear_x_d=$F548

INFO_START=0
BYTE_POS=0
BIT_POS=2
CBYTE=3
CU_BYTE=4
CRLE_COUNTER=5
CRLE_MAPPER=7
CIS_PHRASE=9
CP_BYTE=11
CP_START=12
REG_USED=14
INFO_END=15
STRUCT_LEN=(INFO_END-INFO_START)
; uses 166 byte RAM!
        BSS
 org ym_ram
;                ds   780
cregister:
                ds   1
temp:
                ds   1
temp2:
                ds   1
temp3:
                ds   1
calc_coder:
                ds   1
calc_bits:
                ds   1
ym_len:
                ds   2

ym_data_current:
                ds   2
ym_name:
                ds   2
ym_regs_used:   ds   1
ym_regs_count:  ds   1
ym_data_start:
                ds   11 * STRUCT_LEN

        code
;***************************************************************************
WRITE_PSG macro; a = reg, b = data
                STA     <VIA_port_a     ;store register select byte
                LDA     #$19            ;sound BDIR on, BC1 on, mux off _ LATCH
                STA     <VIA_port_b
                LDA     #$01            ;sound BDIR off, BC1 off, mux off - INACTIVE 
                STA     <VIA_port_b
                LDA     <VIA_port_a     ;read sound chip status (?)
                STB     <VIA_port_a     ;store data byte
                LDB     #$11            ;sound BDIR on, BC1 off, mux off - WRITE
                STB     <VIA_port_b
                LDB     #$01            ;sound BDIR off, BC1 off, mux off - INACTIVE
                STB     <VIA_port_b
 endm
; expects u to point to shadow area
WRITE_PSG_SHADOW_REG macro reg
                lda #reg
                ldb a,u
                WRITE_PSG
 endm

;***************************************************************************
unshadow_sound ; only regs 0 - 10
  ldu #Vec_Snd_Shadow
  WRITE_PSG_SHADOW_REG 0
  WRITE_PSG_SHADOW_REG 1
  WRITE_PSG_SHADOW_REG 2
  WRITE_PSG_SHADOW_REG 3
  WRITE_PSG_SHADOW_REG 4
  WRITE_PSG_SHADOW_REG 5
  WRITE_PSG_SHADOW_REG 6
  WRITE_PSG_SHADOW_REG 7
  WRITE_PSG_SHADOW_REG 8
  WRITE_PSG_SHADOW_REG 9
  WRITE_PSG_SHADOW_REG 10

 rts
;***************************************************************************
;***************************************************************************
init_ym_sound:
                ldx     #ym_data_start        ; load start address of ram buffer for YM play
                ldd     #(STRUCT_LEN*11)      ; load length of buffer
                jsr     Clear_x_d             ; clear buffer
                clr     ym_regs_used          ; count of registers that are used by the player - reset

                ldy     ,u++                  ; first load start of all data to y
                ldd     ,y                    ; load vbl_len to d
                std     ym_len                ; and store it to len reset
                std     ym_data_current       ; and store it to current data pointer
                ldb     ,u+                   ; load number of next register to work on
nreg_init:
                inc     ym_regs_used          ; count the registers we actually use
                stb     REG_USED,x            ; and store the register of the current data
                ldy     ,u++                  ; load location of translation map to y
                sty     CRLE_MAPPER,x         ; and store it
                ldy     ,u++                  ; load location of phrases 
                sty     CP_START,x            ; and store it
                ldy     ,u++                  ; load location of RLE data
                sty     BYTE_POS,x            ; and store it
                leax    STRUCT_LEN,x          ; add structure length to x
                ldb     ,u+                   ; load number of next register to work on
                bpl     nreg_init             ; if negative than we are done
regInitDone:
                stu     ym_name
                rts

;***************************************************************************
; No shadowing
do_ym_sound:
                ldd     ym_data_current       ; load current VBL Counter
                beq     ymsodone              ; if 0, than we are done
                subd    #1                    ; otherwise remember we are doing one byte now
                std     ym_data_current       ; and store it
                lda     ym_regs_used          ; get the number of regs we are working on
                sta     ym_regs_count         ; and remember them as current counter
                ldu     #ym_data_start        ; load RAM start address of our wokring structur
 ldy #Vec_Snd_Shadow
next_reg:
; U pointer to data structure
; A number of register
get_cbyte:
; do we have a byte that is valid?
                ldd      CRLE_COUNTER,u
                beq      nv_byte
; yep... use current byte
                ldx       CIS_PHRASE,u
                beq       no_p
                lda       ,x+ ; length of phrase
                ldb       CP_BYTE,u
                ldb       b,x ; this is the current byte
                stb       CU_BYTE,u
                inc       CP_BYTE,u
                cmpa      CP_BYTE,u
                bne       cnotmone
                clr       CP_BYTE,u
                ldd       CRLE_COUNTER,u
no_p:
                subd      #1
                std       CRLE_COUNTER,u
cnotmone:
                ldb       CU_BYTE,u

; in b the current value for register
; A PSG reg
                lda     REG_USED,u            ; load current register
 stb a,y ; to sound shadow register
; or direct
; WRITE_PSG_REG
                leau    STRUCT_LEN,u          ; go to next "register" of sound data
                dec     ym_regs_count         ; but only if we are not done yet, if counter is zero
                bne     next_reg              ; we do not branch :-)
ymsodone:
; if not written directly...
; - done in main  jsr unshadow_sound
               rts


;***************************************************************************
nv_byte:
; no we must look at the bits
; a will be our bit register
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POS,u
                bne     bready_1
; load a new byte
                ldx     BYTE_POS,u
                ldb     ,x+
                stb     CBYTE,u
                stx     BYTE_POS,u
                ldb     #$80
                stb     BIT_POS,u
bready_1:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POS,u

; is the bit at the current position set?
                andb    CBYTE,u
;;;;;;;;;;;;;;;;;;; GET_BIT END
; zero flag show bit
; A is 1 or zero
                lbne     ns_byte
si_byte:
                ; must be zero
                ; 1 is allways only 8 bit...
                inc      CRLE_COUNTER+1,u
dechifer:
                clr       calc_bits
                clr       calc_coder
tn_bit:
                lsl       calc_coder
                inc       calc_bits    ; increase used bits
;;;;;;;;;;;; GET_BIT_START
                ldb     BIT_POS,u
                bne     bready
; load a new byte
                ldx     BYTE_POS,u
                ldb     ,x+
                stb     CBYTE,u
                stx     BYTE_POS,u
                ldb     #$80
                stb     BIT_POS,u
bready:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POS,u

; is the bit at the current position set?
                andb    CBYTE,u
                beq     no_add     ; and if non zero
                inc     calc_coder
;;;;;;;;;;;; GET_BIT_END
no_add:
; we load one complete set of mapper index, bits, coder, map-value
                ldx       CRLE_MAPPER,u
sagain:
                leax      3,x
                lda       ,x          ; load bits from map
                anda      #127         ; map out phrases
                cmpa      calc_bits      ; neu
                bgt       tn_bit ; neu
                bne       sagain
                ldb       1,x          ; load coder-byte
                cmpb      calc_coder
                bne       sagain
                ldb       2,x           ; load current mapped byte!
; in b is the byte value we sought
; test for phrase
                lda       ,x          ; load bits from map
                anda     #128         ; map in phrases only
                beq      no_p_d
; if phrase, than in b the count of the phrase used
                ldx      CP_START,u
                tstb
                beq     pfound
nphrase:
                lda     ,x+
                leax    a,x
                decb
                bne     nphrase
pfound:
                stx     CIS_PHRASE,u
                clr     CP_BYTE,u
                bra      get_cbyte
no_p_d:
                clr      CIS_PHRASE,u
                clr      CIS_PHRASE+1,u
                stb      CU_BYTE,u
                bra      get_cbyte



ns_byte:
; non single byte here... must decode
; first we look for how many bits the RLE counter spreads

                ; we already encountered a 1
                ; and we allways use + 2
                lda     #2
                sta     temp
mbits:
                inc     temp
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POS,u
                bne     bready_2
; load a new byte
                ldx     BYTE_POS,u
                ldb     ,x+
                stb     CBYTE,u
                stx     BYTE_POS,u
                ldb     #$80
                stb     BIT_POS,u
bready_2:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POS,u

; is the bit at the current position set?
                andb    CBYTE,u
;;;;;;;;;;;;;;;;;;; GET_BIT END
                bne     mbits
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
                ldb     BIT_POS,u
                bne     bready_3
; load a new byte
                ldx     BYTE_POS,u
                ldb     ,x+
                stb     CBYTE,u
                stx     BYTE_POS,u
                ldb     #$80
                stb     BIT_POS,u
bready_3:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POS,u

; is the bit at the current position set?
                andb    CBYTE,u
                beq     ehere_3
; return 1
                ldb     #1
ehere_3:
;;;;;;;;;;;;;;;;;;; GET_BIT END
; in D now one bit at the right position for the RLE counter
                stb     CRLE_COUNTER+1,u
; the first 3 (here only the first one) rounds
; we need not check for temp, since it is at least 3...
go_on_2:
;;;;;;;;;;;;;;;;;;; GET_BIT START
                ldb     BIT_POS,u
                bne     bready_4
; load a new byte
                ldx     BYTE_POS,u
                ldb     ,x+
                stb     CBYTE,u
                stx     BYTE_POS,u
                ldb     #$80
                stb     BIT_POS,u
bready_4:
; bit position correct here
;
; remember we use one bit now!
                lsr     BIT_POS,u

; is the bit at the current position set?
                andb    CBYTE,u
                beq     ehere_4
; return 1
                ldb     #1
ehere_4:
                clra
snotydone:
                lsla               ; LSR A
                lslb               ; LSR B
                bcc no_carry       ; if no carry, than exit
                ora #1             ; otherwise underflow from A to 7bit of B
no_carry:
                dec     temp3
                bne     snotydone
sdone:
; in D now one bit at the right position for the RLE counter
                addd    CRLE_COUNTER,u
                std     CRLE_COUNTER,u

                inc     temp2
                lda     temp2
                sta     temp3
                cmpa    temp
                bne     go_on_2
; now the current counter should be set

; we still need to dechifer the following byte...
                lbra       dechifer



