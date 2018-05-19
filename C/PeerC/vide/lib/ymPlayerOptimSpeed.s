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
Sound_Byte=$F256 
Clear_x_d=$F548 
VIA_port_b=$D000   ;VIA port B data I/O register
VIA_port_a=$D001   ;VIA port A data I/O register (handshaking)

 if USE_ENVELOPES
REGS_MAX = 14
 else
REGS_MAX = 11
 endif

INFO_START=0 
BYTE_POS=0 
BIT_POS=2 
CURRENT_DATA_BYTE=3 
CURRENT_REG_BYTE=4 
CURRENT_RLE_COUNTER=5 
REG_PHRASE_MAP=7 
CURRENT_IS_PHRASE=9 
CURRENT_PLACE_IN_PHRASE=11 
PHRASE_DEFINITION_START=12 
REG_USED=14 
CURRENT_PHRASE_LEN=15 
INFO_END=16 
STRUCT_LEN=(INFO_END-INFO_START) 
; uses 166 byte RAM!
                    BSS      
                    org      ym_ram 
cregister: 
                    ds       1 
temp: 
                    ds       1 
temp2: 
                    ds       1 
temp3: 
                    ds       1 
calc_coder: 
                    ds       1 
calc_bits: 
                    ds       1 
ym_len: 
                    ds       2 
ym_data_current: 
                    ds       2 
ym_name: 
                    ds       2 
ym_regs_used:       ds       1 
ym_regs_count:      ds       1 
ym_data_start: 
                    ds       REGS_MAX * STRUCT_LEN 
; uses X and B
; all other registeres stay the same
read_one_bit_from_data  macro  
                    local    bit_is_ready 
;;;;;;;;;;;; GET_BIT_START
                    ldb      BIT_POS,u 
                    bne      bit_is_ready 
; load a new byte
                    ldx      BYTE_POS,u 
                    ldb      ,x+ 
                    stb      CURRENT_DATA_BYTE,u 
                    stx      BYTE_POS,u 
                    ldb      #$80 
                    stb      BIT_POS,u 
bit_is_ready: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      BIT_POS,u 
; is the bit at the current position set?
                    andb     CURRENT_DATA_BYTE,u 
;;;;;;;;;;;; GET_BIT_END
                    endm  

; store data in reg a in an
; appropriate way to PSG register (here: BIOS working buffer)
Vec_Music_Work  EQU     $C83F   ;Music work buffer (14 bytes, backwards?)

STORE_PSG           macro    register 
;                    ldu      #(Vec_Music_Work + register) 
;                    sta      ,u 
                    sta      (Vec_Music_Work + register) 
                    endm     
STORE_PSG_b         macro    register 
;                    ldu      #(Vec_Music_Work + register) 
;                    stb      ,u 
                    stb      (Vec_Music_Work + register) 
                    endm   
   
WRITE_PSG           macro                                 ;   a = reg, b = data 
 STORE_PSG_b
;                    STA      <VIA_port_a                  ;store register select byte 
;                    LDA      #$19                         ;sound BDIR on, BC1 on, mux off _ LATCH 
;                    STA      <VIA_port_b 
;                    LDA      #$01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
;                    STA      <VIA_port_b 
;                    LDA      <VIA_port_a                  ;read sound chip status (?) 
;                    STB      <VIA_port_a                  ;store data byte 
;                    LDB      #$11                         ;sound BDIR on, BC1 off, mux off - WRITE 
;                    STB      <VIA_port_b 
;                    LDB      #$01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
;                    STB      <VIA_port_b 
                    endm     
                    code     
reg_max_data: 
 if USE_ENVELOPES
                    db       8,4,8,4,8,4,5,6,5,5,5,8,8,5,8,8 
 else
                    db       8,4,8,4,8,4,5,6,4,4,4,8,8,5,8,8 
 endif 
rleEncodedData: 
; non single entity here... must decode RLE
; first we look for how many bits the RLE counter spreads
; in A will be out bit counter, how many bits our actual counter uses
                    clra     
moreBits: 
                    inca     
                    read_one_bit_from_data  
                    bne      moreBits 
                    exg      a,b 
                    tfr      d,y                          ; in y now our count of bits 
; in y is the # of bits for the counter
; the following '#y' bits represent the RLE count
; MSB first
; in a (later d) will be our new RLE count
                    clra     
                    read_one_bit_from_data  
                    beq      rleCounterBit0NotSet 
                    inca     
rleCounterBit0NotSet: 
                    lsla     
                    read_one_bit_from_data  
                    beq      rleCounterBit1NotSet 
                    inca     
rleCounterBit1NotSet: 
                    lsla     
                    read_one_bit_from_data  
                    beq      rleCounterBit2NotSet 
                    inca     
rleCounterBit2NotSet: 
                    leay     -1,y 
                    lbeq     rle8bitdone 
                    lsla     
                    read_one_bit_from_data  
                    beq      rleCounterBit3NotSet 
                    inca     
rleCounterBit3NotSet: 
                    leay     -1,y 
                    lbeq     rle8bitdone 
                    lsla     
                    read_one_bit_from_data  
                    beq      rleCounterBit4NotSet 
                    inca     
rleCounterBit4NotSet: 
                    leay     -1,y 
                    beq      rle8bitdone 
                    lsla     
                    read_one_bit_from_data  
                    beq      rleCounterBit5NotSet 
                    inca     
rleCounterBit5NotSet: 
                    leay     -1,y 
                    beq      rle8bitdone 
                    lsla     
                    read_one_bit_from_data  
                    beq      rleCounterBit6NotSet 
                    inca     
rleCounterBit6NotSet: 
                    leay     -1,y 
                    beq      rle8bitdone 
                    lsla     
                    read_one_bit_from_data  
                    beq      rleCounterBit7NotSet 
                    inca     
rleCounterBit7NotSet: 
                    leay     -1,y 
                    beq      rle8bitdone 
; now the counter has more than 8 bit, gets trickier
                    sta      CURRENT_RLE_COUNTER+1,u      ; assuming high byte is zero of counter 
read16bitContinue 
                    ldd      CURRENT_RLE_COUNTER,u 
; this does a LSLD
                    lsla                                  ; LSL A 
                    lslb                                  ; LSL B 
                    bcc      no_carry                     ; if no carry, than exit 
                    ora      #1                           ; otherwise overflow from B to 0bit of A 
no_carry: 
; LSLD finish
                    std      CURRENT_RLE_COUNTER,u 
                    read_one_bit_from_data  
                    beq      rleCounterBitXNotSet 
                    inc      CURRENT_RLE_COUNTER+1,u 
rleCounterBitXNotSet: 
                    leay     -1,y 
                    bne      read16bitContinue 
rle16bitdone: 
; now the current counter should be set
; we still need to dechifer the following byte...
                    bra      dechifer 

rle8bitdone: 
                    sta      CURRENT_RLE_COUNTER+1,u      ; assuming high byte is zero of counter 
; now the current counter should be set
; we still need to dechifer the following byte...
                    bra      dechifer 

;***************************************************************************
;***************************************************************************
do_ym_sound: 
                    ldd      ym_data_current              ; load current VBL Counter 
                    beq      ymsodone                     ; if 0, than we are done 
                    subd     #1                           ; otherwise remember we are doing one byte now 
                    std      ym_data_current              ; and store it 
                    lda      ym_regs_used                 ; get the number of regs we are working on 
                    sta      ym_regs_count                ; and remember them as current counter 
                    ldu      #ym_data_start               ; load RAM start address of our wokring structure 
next_reg: 
;                    jsr      getCurrentRegByte            ; in relation to RAM structure (U), get the next register byte 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; was subroutine, now inlined-start
; U pointer to data structure
; A number of register
getCurrentRegByte: 
; do we have a byte that is valid?
                    ldd      CURRENT_RLE_COUNTER,u        ; if current RLE counter is zero, than we must get a new byte 
                    beq      noValidByte                  ; jump to get new byte 
; yep... use current byte
                    ldx      CURRENT_IS_PHRASE,u          ; otherwise, lets check if we are in a phrase (x = pointer to phrase or zero) 
                    beq      not_in_phrase                ; jump if not 
                    ldb      CURRENT_PLACE_IN_PHRASE,u    ; where in our phrase are we? 
                    lda      CURRENT_PHRASE_LEN,u         ; length of phrase 
inPhraseOut: 
                    ldb      b,x                          ; load the next byte of our phrase 
                    stb      CURRENT_REG_BYTE,u           ; store that to current output 
                    inc      CURRENT_PLACE_IN_PHRASE,u    ; check if we are at the end of the phrase 
                    cmpa     CURRENT_PLACE_IN_PHRASE,u    ; (in a is phrase len) 
                    bne      currentPharseNotEnded        ; if phrase is not at end - continue 
                    clr      CURRENT_PLACE_IN_PHRASE,u    ; other wise we set place to zero 
                    ldd      CURRENT_RLE_COUNTER,u        ; and decrease out RLE counter 
not_in_phrase: 
                    subd     #1 
                    std      CURRENT_RLE_COUNTER,u 
currentPharseNotEnded: 
done: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; was subroutine, now inlined-end
                    ldb      CURRENT_REG_BYTE,u 
                    lda      REG_USED,u                   ; load current register 
                                                          ; A PSG reg 
                                                          ; B data 
 if USE_ENVELOPES
 cmpa #13
 bne no13
 bitb #$10
 bne doNotWriteReg13 ; if b part of phrase than $ff, if single byte than $1f, indicator for envelope not changed
no13:
 endif


                    ldy     #$C84C
 nega
				  stb a,y


;                    ldy      #Vec_Music_Work
;				  stb a,y
;                    sta      ,u 

;                    WRITE_PSG  

;                    jsr      Sound_Byte                   ; and actually output that to the sound chip 
doNotWriteReg13:
                    leau     STRUCT_LEN,u                 ; go to next "register" of sound data 
                    dec      ym_regs_count                ; but only if we are not done yet, if counter is zero 
                    bne      next_reg                     ; we do not branch :-) 
ymsodone: 
                    rts      
;***************************************************************************
;***************************************************************************

noValidByte: 
; no we must look at the bits
; a will be our bit register
                    read_one_bit_from_data  
; check bit, if 1 than RLE encoded
; if not - not
                    lbne      rleEncodedData 
                                                          ; must be zero 
                                                          ; 1 is always only 8 bit... 
                    inc      CURRENT_RLE_COUNTER+1,u 
dechifer: 
; check bit
; if 1 than shannon encoded
; if 0 - not
                    read_one_bit_from_data  
                    beq      directByte                   ; if bit is zero - jump 
                    sts      temp                         ; save stackpointer 
                    lds      REG_PHRASE_MAP,u             ; load the starting position of the phrase mappings for this register 
                    ldy      PHRASE_DEFINITION_START,u    ; and also the phrase definition address 
                    clra                                  ; was calc_bits, a contains the number of bits our current shannon code checkings 
                    sta      calc_coder                   ; starting with zero for coder also 
getNextCodeBit: 
                    lsl      calc_coder                   ; prepare load of next coder bit - shift all previous codes one position 
                    inca                                  ; increase used bits 
                    read_one_bit_from_data  
                    beq      code_bit_notset              ; if bit is zero - jump 
                    inc      calc_coder                   ; otherwise set bit in current code 
code_bit_notset: 
testNextPhrase: 
                    cmpa     ,s                           ; check if it count of currently referenced phrase equals the current shannon bitcount 
                    blt      getNextCodeBit               ; if lower, load next bit (and increase shannon bits) 
                    beq      bitLenFound                  ; if equal, than we must check if codes equal 
; if greater, than we advance one in our phrase table, and check the next phrase
increaseCodeBits: 
                    ldb      2,s                          ; load length of last phase and 
                    leay     b,y                          ; add that to our future pointer to phrases 
                    leas     3,s                          ; advance one phrase in out mapping (one mapping = 3 byte) 
                    bra      testNextPhrase               ; and test the next such got phrase 

; here we come if
; shannon bit length of read data == shannon bit length phrase that the maping references
; there can be more than one, so we must still seek the one with the
; correct code
bitLenFound: 
                    ldb      1,s                          ; load coder-byte, from current phrase 
                    cmpb     calc_coder                   ; and compare with current loaded coder-byte from "bitstream" 
                    bne      increaseCodeBits             ; if not the same, check next phrase in phrase mapping (jump) 
                    lda      2,s                          ; otherwise we found the correct phrase, load length of current phrase 
                    sta      CURRENT_PHRASE_LEN,u         ; and remember that 
                    lds      temp                         ; restore stack 
                    tfr      y,x                          ; pointer to current found phrase to X (will be resused in out) 
                    clrb                                  ; current position in phrase is at start 0 
                    stx      CURRENT_IS_PHRASE,u          ; store the phrase to the structure 
                    stb      CURRENT_PLACE_IN_PHRASE,u    ; also the position 
                    jmp      inPhraseOut                  ; and output the next phrase byte 

; direct bytes are not shannon encoded 
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
                    ldx      #reg_max_data 
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
reg8Bits: 
                    read_one_bit_from_data  
                    beq      noBit1 
                    inca     
noBit1: 
                    lsla     
                    read_one_bit_from_data  
                    beq      noBit2 
                    inca     
noBit2: 
                    lsla     
reg6Bits: 
                    read_one_bit_from_data  
                    beq      noBit3 
                    inca     
noBit3: 
                    lsla     
reg5Bits: 
                    read_one_bit_from_data  
                    beq      noBit4 
                    inca     
noBit4: 
                    lsla     
reg4Bits: 
                    read_one_bit_from_data  
                    beq      noBit5 
                    inca     
noBit5: 
                    lsla     
                    read_one_bit_from_data  
                    beq      noBit6 
                    inca     
noBit6: 
                    lsla     
                    read_one_bit_from_data  
                    beq      noBit7 
                    inca     
noBit7: 
                    lsla     
                    read_one_bit_from_data  
                    beq      noBit8 
                    inca     
noBit8: 
                    sta      CURRENT_REG_BYTE,u 
                    jmp      done 
;***************************************************************************
;***************************************************************************
init_ym_sound: 
                    ldx      #ym_data_start               ; load start address of ram buffer for YM play 
                    ldd      #(STRUCT_LEN*REGS_MAX)             ; load length of buffer 
                    jsr      Clear_x_d                    ; clear buffer 
                    clr      ym_regs_used                 ; count of registers that are used by the player - reset 
                    ldy      ,u++                         ; first load start of all data to y 
                    ldd      ,y                           ; load vbl_len to d 
                    std      ym_len                       ; and store it to len reset 
                    std      ym_data_current              ; and store it to current data pointer 
                    ldb      ,u+                          ; load number of next register to work on 
nreg_init: 
                    inc      ym_regs_used                 ; count the registers we actually use 
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
regInitDone: 
                    stu      ym_name 
                    rts      
;***************************************************************************
;***************************************************************************
