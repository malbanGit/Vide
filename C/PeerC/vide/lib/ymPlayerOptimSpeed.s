 .module ymplayer.pre.s
 .area .text

; ; hey dissi "watch 0xcircleHalf 2 0"
; Note:
; this file seems fairly unstructured
; the gist is, the current "sorting" of the different unpack sections
; allows in many routines to use "short" branches, which:
; a) saves space
; b) saves cycles 
; 
; when routines are working correct these opimizations
; must be allowed :-)
;
USE_ENVELOPES = 1


Sound_Byte = 0xF256 
Clear_x_d = 0xF548 
VIA_port_b = 0xD000   ;VIA port B data I/O register
VIA_port_a = 0xD001   ;VIA port A data I/O register (handshaking)

REGS_MAX = 14

INFO_START = 0 
BYTE_POS = 0 
BIT_POS = 2 
CURRENT_DATA_BYTE = 3 
CURRENT_REG_BYTE = 4 
CURRENT_RLE_COUNTER = 5 
REG_PHRASE_MAP = 7 
CURRENT_IS_PHRASE = 9 
CURRENT_PLACE_IN_PHRASE = 11 
PHRASE_DEFINITION_START = 12 
REG_USED = 14 
CURRENT_PHRASE_LEN = 15 
INFO_END = 16 
STRUCT_LEN = (INFO_END-INFO_START) 
; uses 166 byte RAM!
                    .area .bss      
      ;              org      ym_ram 
 .globl _cregister
_cregister: 
                    .blkb       1 
 .globl _temp
_temp: 
                    .blkb       1 
 .globl _temp2
_temp2: 
                    .blkb       1 
 .globl _temp3
_temp3: 
                    .blkb       1 
 .globl _calc_coder
_calc_coder: 
                    .blkb       1 
 .globl _calc_bits
_calc_bits: 
                    .blkb       1 
 .globl _ym_len
_ym_len: 
                    .blkb       2 
 .globl _ym_data_current
_ym_data_current: 
                    .blkb       2 
 .globl _ym_name
_ym_name: 
                    .blkb       2 
 .globl _ym_regs_used
_ym_regs_used:       .blkb       1 
 .globl _ym_regs_count
_ym_regs_count:      .blkb       1 
 .globl _ym_data_start
_ym_data_start: 
                    .blkb       REGS_MAX * STRUCT_LEN 
; uses X and B
; all other registeres stay the same
                    .area .text     
                    .setdp   0xd000,_DATA 
 .globl _reg_max_data
_reg_max_data: 
                    .byte       8,4,8,4,8,4,5,6,5,5,5,8,8,5,8,8 
 .globl rleEncodedData
rleEncodedData: 
; non single entity here... must decode RLE
; first we look for how many bits the RLE counter spreads
; in A will be out bit counter, how many bits our actual counter uses
                    clra     
 .globl moreBits
moreBits: 
                    inca     
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready1 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready1
bit_is_ready1: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    bne      moreBits 
                    exg      a,b 
                    tfr      d,y                          ; in y now our count of bits 
; in y is the # of bits for the counter
; the following '#y' bits represent the RLE count
; MSB first
; in a (later d) will be our new RLE count
                    clra     
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready2 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready2
bit_is_ready2: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      rleCounterBit0NotSet 
                    inca     
 .globl rleCounterBit0NotSet
rleCounterBit0NotSet: 
                    lsla     
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready3 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready3
bit_is_ready3: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      rleCounterBit1NotSet 
                    inca     
 .globl rleCounterBit1NotSet
rleCounterBit1NotSet: 
                    lsla     
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready4 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready4
bit_is_ready4: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      rleCounterBit2NotSet 
                    inca     
 .globl rleCounterBit2NotSet
rleCounterBit2NotSet: 
                    leay     -1,y 
                    lbeq     rle8bitdone 
                    lsla     
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready5 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready5
bit_is_ready5: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      rleCounterBit3NotSet 
                    inca     
 .globl rleCounterBit3NotSet
rleCounterBit3NotSet: 
                    leay     -1,y 
                    lbeq     rle8bitdone 
                    lsla     
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready6 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready6
bit_is_ready6: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      rleCounterBit4NotSet 
                    inca     
 .globl rleCounterBit4NotSet
rleCounterBit4NotSet: 
                    leay     -1,y 
                    beq      rle8bitdone 
                    lsla     
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready7 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready7
bit_is_ready7: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      rleCounterBit5NotSet 
                    inca     
 .globl rleCounterBit5NotSet
rleCounterBit5NotSet: 
                    leay     -1,y 
                    beq      rle8bitdone 
                    lsla     
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready8 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready8
bit_is_ready8: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      rleCounterBit6NotSet 
                    inca     
 .globl rleCounterBit6NotSet
rleCounterBit6NotSet: 
                    leay     -1,y 
                    beq      rle8bitdone 
                    lsla     
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready9 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready9
bit_is_ready9: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      rleCounterBit7NotSet 
                    inca     
 .globl rleCounterBit7NotSet
rleCounterBit7NotSet: 
                    leay     -1,y 
                    beq      rle8bitdone 
; now the counter has more than 8 bit, gets trickier
                    sta      CURRENT_RLE_COUNTER+1,u      ; assuming high byte is zero of counter 
 .globl read16bitContinue
read16bitContinue: 
                    ldd      CURRENT_RLE_COUNTER,u 
; this does a LSLD
                    lsla                                  ; LSL A 
                    lslb                                  ; LSL B 
                    bcc      no_carry                     ; if no carry, than exit 
                    ora      #1                           ; otherwise overflow from B to 0bit of A 
 .globl no_carry
no_carry: 
; LSLD finish
                    std      CURRENT_RLE_COUNTER,u 
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready10 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready10
bit_is_ready10: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      rleCounterBitXNotSet 
                    inc      CURRENT_RLE_COUNTER+1,u 
 .globl rleCounterBitXNotSet
rleCounterBitXNotSet: 
                    leay     -1,y 
                    bne      read16bitContinue 
 .globl rle16bitdone
rle16bitdone: 
; now the current counter should be set
; we still need to dechifer the following byte...
                    bra      dechifer 

 .globl rle8bitdone
rle8bitdone: 
                    sta      CURRENT_RLE_COUNTER+1,u      ; assuming high byte is zero of counter 
; now the current counter should be set
; we still need to dechifer the following byte...
                    bra      dechifer 

;***************************************************************************
;***************************************************************************
 .globl do_ym_sound
do_ym_sound: 
                    ldd      _ym_data_current              ; load current VBL Counter 
                    beq      ymsodone                     ; if 0, than we are done 
                    subd     #1                           ; otherwise remember we are doing one byte now 
                    std      _ym_data_current              ; and store it 
                    lda      _ym_regs_used                 ; get the number of regs we are working on 
                    sta      _ym_regs_count                ; and remember them as current counter 
                    ldu      #_ym_data_start               ; load RAM start address of our wokring structure 
 .globl next_reg
next_reg: 
;                    jsr      getCurrentRegByte            ; in relation to RAM structure (U), get the next register byte 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; was subroutine, now inlined-start
; U pointer to data structure
; A number of register
 .globl getCurrentRegByte
getCurrentRegByte: 
; do we have a byte that is valid?
                    ldd      CURRENT_RLE_COUNTER,u        ; if current RLE counter is zero, than we must get a new byte 
                    beq      noValidByte                  ; jump to get new byte 
; yep... use current byte
                    ldx      CURRENT_IS_PHRASE,u          ; otherwise, lets check if we are in a phrase (x = pointer to phrase or zero) 
                    beq      not_in_phrase                ; jump if not 
                    ldb      CURRENT_PLACE_IN_PHRASE,u    ; where in our phrase are we? 
                    lda      CURRENT_PHRASE_LEN,u         ; length of phrase 
 .globl inPhraseOut
inPhraseOut: 
                    ldb      b,x                          ; load the next byte of our phrase 
                    stb      CURRENT_REG_BYTE,u           ; store that to current output 
                    inc      CURRENT_PLACE_IN_PHRASE,u    ; check if we are at the end of the phrase 
                    cmpa     CURRENT_PLACE_IN_PHRASE,u    ; (in a is phrase len) 
                    bne      currentPharseNotEnded        ; if phrase is not at end - continue 
                    clr      CURRENT_PLACE_IN_PHRASE,u    ; other wise we set place to zero 
                    ldd      CURRENT_RLE_COUNTER,u        ; and decrease out RLE counter 
 .globl not_in_phrase
not_in_phrase: 
                    subd     #1 
                    std      CURRENT_RLE_COUNTER,u 
 .globl currentPharseNotEnded
currentPharseNotEnded: 
 .globl done
done: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; was subroutine, now inlined-end
                    ldb      CURRENT_REG_BYTE,u 
                    lda      REG_USED,u                   ; load current register 
                                                          ; A PSG reg 
                                                          ; B data 
 cmpa #13
 bne no13
 bitb #0x10
 bne doNotWriteReg13 ; if b part of phrase than 0xff, if single byte than 0x1f, indicator for envelope not changed
 .globl no13
no13:
; macro call ->                     WRITE_PSG  
                    STA      *VIA_port_a                  ;store register select byte 
                    LDA      #0x19                         ;sound BDIR on, BC1 on, mux off _ LATCH 
                    STA      *VIA_port_b 
                    LDA      #0x01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
                    STA      *VIA_port_b 
                    LDA      *VIA_port_a                  ;read sound chip status (?) 
                    STB      *VIA_port_a                  ;store data byte 
                    LDB      #0x11                         ;sound BDIR on, BC1 off, mux off - WRITE 
                    STB      *VIA_port_b 
                    LDB      #0x01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
                    STB      *VIA_port_b 

;                    jsr      Sound_Byte                   ; and actually output that to the sound chip 
 .globl doNotWriteReg13
doNotWriteReg13:
                    leau     STRUCT_LEN,u                 ; go to next "register" of sound data 
                    dec      _ym_regs_count                ; but only if we are not done yet, if counter is zero 
                    bne      next_reg                     ; we do not branch :-) 
 .globl ymsodone
ymsodone: 
                    rts      
;***************************************************************************
;***************************************************************************

 .globl noValidByte
noValidByte: 
; no we must look at the bits
; a will be our bit register
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready12 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready12
bit_is_ready12: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
; check bit, if 1 than RLE encoded
; if not - not
                    lbne      rleEncodedData 
                                                          ; must be zero 
                                                          ; 1 is always only 8 bit... 
                    inc      CURRENT_RLE_COUNTER+1,u 
 .globl dechifer
dechifer: 
; check bit
; if 1 than shannon encoded
; if 0 - not
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready13 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready13
bit_is_ready13: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      directByte                   ; if bit is zero - jump 
                    sts      _temp                         ; save stackpointer 
                    lds      REG_PHRASE_MAP,u             ; load the starting position of the phrase mappings for this register 
                    ldy      PHRASE_DEFINITION_START,u    ; and also the phrase definition address 
                    clra                                  ; was _calc_bits, a contains the number of bits our current shannon code checkings 
                    sta      _calc_coder                   ; starting with zero for coder also 
 .globl getNextCodeBit
getNextCodeBit: 
                    lsl      _calc_coder                   ; prepare load of next coder bit - shift all previous codes one position 
                    inca                                  ; increase used bits 
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready14 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready14
bit_is_ready14: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      code_bit_notset              ; if bit is zero - jump 
                    inc      _calc_coder                   ; otherwise set bit in current code 
 .globl code_bit_notset
code_bit_notset: 
 .globl testNextPhrase
testNextPhrase: 
                    cmpa     ,s                           ; check if it count of currently referenced phrase equals the current shannon bitcount 
                    blt      getNextCodeBit               ; if lower, load next bit (and increase shannon bits) 
                    beq      bitLenFound                  ; if equal, than we must check if codes equal 
; if greater, than we advance one in our phrase table, and check the next phrase
 .globl increaseCodeBits
increaseCodeBits: 
                    ldb      2,s                          ; load length of last phase and 
                    leay     b,y                          ; add that to our future pointer to phrases 
                    leas     3,s                          ; advance one phrase in out mapping (one mapping = 3 byte) 
                    bra      testNextPhrase               ; and test the next such got phrase 

; here we come if
; shannon bit length of read data == shannon bit length phrase that the maping references
; there can be more than one, so we must still seek the one with the
; correct code
 .globl bitLenFound
bitLenFound: 
                    ldb      1,s                          ; load coder-byte, from current phrase 
                    cmpb     _calc_coder                   ; and compare with current loaded coder-byte from "bitstream" 
                    bne      increaseCodeBits             ; if not the same, check next phrase in phrase mapping (jump) 
                    lda      2,s                          ; otherwise we found the correct phrase, load length of current phrase 
                    sta      CURRENT_PHRASE_LEN,u         ; and remember that 
                    lds      _temp                         ; restore stack 
                    tfr      y,x                          ; pointer to current found phrase to X (will be resused in out) 
                    clrb                                  ; current position in phrase is at start 0 
                    stx      CURRENT_IS_PHRASE,u          ; store the phrase to the structure 
                    stb      CURRENT_PLACE_IN_PHRASE,u    ; also the position 
                    jmp      inPhraseOut                  ; and output the next phrase byte 

; direct bytes are not shannon encoded 
 .globl directByte
directByte: 
                                                          ; get 8 bit 
                    ldd      CURRENT_RLE_COUNTER,u 
                    subd     #1 
                    std      CURRENT_RLE_COUNTER,u 
                    clra     
                    sta      CURRENT_IS_PHRASE,u 
                    sta      CURRENT_IS_PHRASE+1,u 
; some sort of loop unrolling
; we check for each register how many
; relevant bits it uses
; and read only so many bits from our "stream"
; the coder also provides only that many bits
                    ldx      #_reg_max_data 
                    ldb      REG_USED,u 
                    ldb      b,x                          ; number of relevant bits for reg 
                    cmpb     #8 
                    beq      reg8Bits 
                    cmpb     #6 
                    beq      reg6Bits 
                    cmpb     #5 
                    beq      reg5Bits 
                    cmpb     #4 
                    beq      reg4Bits 
 .globl reg8Bits
reg8Bits: 
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready15 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready15
bit_is_ready15: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      noBit1 
                    inca     
 .globl noBit1
noBit1: 
                    lsla     
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready16 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready16
bit_is_ready16: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      noBit2 
                    inca     
 .globl noBit2
noBit2: 
                    lsla     
 .globl reg6Bits
reg6Bits: 
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready17 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready17
bit_is_ready17: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      noBit3 
                    inca     
 .globl noBit3
noBit3: 
                    lsla     
 .globl reg5Bits
reg5Bits: 
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready18 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready18
bit_is_ready18: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      noBit4 
                    inca     
 .globl noBit4
noBit4: 
                    lsla     
 .globl reg4Bits
reg4Bits: 
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready19 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready19
bit_is_ready19: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      noBit5 
                    inca     
 .globl noBit5
noBit5: 
                    lsla     
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready20 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready20
bit_is_ready20: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      noBit6 
                    inca     
 .globl noBit6
noBit6: 
                    lsla     
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready21 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready21
bit_is_ready21: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      noBit7 
                    inca     
 .globl noBit7
noBit7: 
                    lsla     
; macro call ->                     read_one_bit_from_data  
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready22 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #0x80 
                    stb      BIT_POS,u 
 .globl bit_is_ready22
bit_is_ready22: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    beq      noBit8 
                    inca     
 .globl noBit8
noBit8: 
                    sta      CURRENT_REG_BYTE,u 
                    jmp      done 
;***************************************************************************
;***************************************************************************
 .globl init_ym_sound
init_ym_sound: 
                    ldx      #_ym_data_start               ; load start address of ram buffer for YM play 
                    ldd      #(STRUCT_LEN*REGS_MAX)             ; load length of buffer 
                    jsr      Clear_x_d                    ; clear buffer 
                    clr      _ym_regs_used                 ; count of registers that are used by the player - reset 
                    ldy      ,u++                         ; first load start of all data to y 
                    ldd      ,y                           ; load vbl_len to d 
                    std      _ym_len                       ; and store it to len reset 
                    std      _ym_data_current              ; and store it to current data pointer 
                    ldb      ,u+                          ; load number of next register to work on 
 .globl nreg_init
nreg_init: 
                    inc      _ym_regs_used                 ; count the registers we actually use 
                    stb      REG_USED,x                   ; and store the register of the current data 
                    ldy      ,u++                         ; load location of translation map to y 
                    sty      REG_PHRASE_MAP,x             ; and store it 
                    ldy      ,u++                         ; load location of phrases 
                    sty      PHRASE_DEFINITION_START,x    ; and store it 
                    ldy      ,u++                         ; load location of RLE data 
                    sty      BYTE_POS,x                   ; and store it 
                    leax     STRUCT_LEN,x                 ; add structure length to x 
                    ldb      ,u+                          ; load number of next register to work on 
                    bpl      nreg_init                    ; if negative than we are done 
 .globl regInitDone
regInitDone: 
                    stu      _ym_name 
                    rts      
;***************************************************************************
;***************************************************************************
