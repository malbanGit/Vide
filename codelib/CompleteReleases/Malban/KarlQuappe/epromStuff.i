; this file is part of Karl Quappe, written by Malban in 2016
;
; Most parts were written by:
;
;   2016 Thomas G. Sontowski:
;   based on Alex Herbert's ds2430 driver
;
; if 32 byte save is enabled only a dirty "translation" of bigger data is done, much redundancy!
;***************************************************************************
                    include  "ds2431LowLevel.i"
                    include  "ds2431HighLevel.i"
;***************************************************************************
;;;;;;;;;;;;;
EEPROM_CHECKSUM     equ      $87                          ; any value other than $00 or $e0 
EEPROM_STORESIZE_HS  equ     32                           ;32 only 31 bytes must be used, last byte is always a generated checksum 
EEPROM_STORESIZE_OPTIONS  equ  8                          ;8 only 7 bytes must be used, last byte is always a generated checksum 
EEPROM_OPTION_BLOCK  EQU     0 
EEPROM_HS1_BLOCK    EQU      8 
EEPROM_HS2_BLOCK    EQU      40 
;;;;;;;;;;;;;
resetEprom 
                    jsr      copyDefaults 
                    tst      ignoreDs2431 
                    bne      noDevice1 
                    tst      ds2431Present 
                    beq      noDSDevice 
                    ldd      #(EEPROM_STORESIZE_OPTIONS*256)+EEPROM_OPTION_BLOCK 
                    std      current_eprom_blocksize 
                    ldx      #optionsBlock 
                    bSR      eeprom_save_options 
                    ldd      #(EEPROM_STORESIZE_HS*256)+EEPROM_HS1_BLOCK 
                    std      current_eprom_blocksize 
                    ldx      #highScoreCompetitionBlock 
                    bSR      eeprom_save_highscore 
                    ldd      #(EEPROM_STORESIZE_HS*256)+EEPROM_HS2_BLOCK 
                    std      current_eprom_blocksize 
                    ldx      #highScoreHardcoreBlock 
                    bra      eeprom_save_highscore 

noDSDevice 
                    tst      v4ecartflags 
                    bpl      noDevice1 
                    jmp      store_score 

noDevice1 
                    rts      

cleanStart 
                    jmp      copyDefaults 

;***************************************************************************
checkEprom 
                    tst      ignoreDs2431 
                    bne      cleanStart 
                    clr      ds2431Present 
                    jsr      ds1w_open                    ; open 1-wire port 
                    jsr      ds1w_reset                   ; reset device 
                    ;tsta     
                    bne      notPresent 
                    inc      ds2431Present 
notPresent 
                    jmp      ds1w_close                   ; close port 

;***************************************************************************
; current_eprom_blocksize = blocksize
; current_eprom_blockadr = block address in eeprom
; x = address to save
eeprom_save_highscore 
                    tfr      x,y 
                    bsr      toNewEeprom 
                    ldx      #newEepromRAMStart 
eeprom_save_options 
                    ldb      #$d0 
                    tfr      b,dp 
                    direct   $D0 
                    ldb      current_eprom_blocksize 
                    decb     
                    tst      ignoreDs2431 
                    bne      noDevice1 
                    tst      v4ecartflags 
                    bpl      eepromSave_1 
                    jmp      store_score 

eepromSave_1 
                    pshs     x 
                    lda      #(EEPROM_CHECKSUM)           ;<<8)+(EEPROM_STORESIZE-1) ; 
eesave_loop                                               ;        
                    suba     ,x+                          ; create checksum byte 
                    decb                                  ; 
                    bne      eesave_loop                  ; 
                    sta      ,x                           ; 
                    puls     x 
                    lbsr     ds2431_verify                ; compare ram to eeprom 
                    tsta                                  ; 
                    lbne     ds2431_save                  ; if different, then update eeprom 
                    rts      

;***************************************************************************
; current_eprom_blocksize = blocksize
; current_eprom_blockadr = block address in eeprom
; x = address to load To 

eeprom_load_highscore 
                    stx      eeprom_tmp 
                    ldx      #newEepromRAMStart           ; 
eeprom_load_option 
eeprom_load_1 
                    tst      ignoreDs2431 
                    bne      noDevice1 
 
                    tst      v4ecartflags 
                    bpl      eeprom_load_2
; COPY_VECROM_TO_RAM
                ldu #vec4SaveBuffer            ; Source copy the vec4ever switching function into place
                ldx #v4e_saveBlockStart ; destination
                lda #1+(v4e_saveBlockEnd-v4e_saveBlockStart)
                jmp Move_Mem_a
; rts
eeprom_load_2
                    jsr      ds2431_load                  ; load 32 byte eeprom to ram 
                    ldb      current_eprom_blocksize 
                    clra     
eeload_loop                                               ;        
                    adda     ,x+                          ; sum the bytes 
                    decb                                  ; 
                    bne      eeload_loop                  ; 
                    cmpa     #EEPROM_CHECKSUM             ; equal to checksum? 
                    lbne     resetEprom                   ; if not, then format the eeprom 
                    lda      current_eprom_blocksize 
                    cmpa     #8 
                    beq      doneEEL 
                    ldx      eeprom_tmp 
                    bsr      fromNewEeprom 
doneEEL 
                    rts                                   ; otherwise, return 

;                    struct   HighScoreEntry 
;                    ds       NAME,3                       ; 
;                    ds       LEVEL,1                      ; 
;                    ds       ASCIISCORE,6                 ; 
;                    end      struct 
;***************************************************************************
; from address in y
; to address always new eeprom
; d + x trashed,
;y at the end of the copying
toNewEeprom: 
                    lda      #5 
                    sta      levelDoneTemp 
; handle name 3 chars
                    ldx      #newEepromRAMStart 
convertNextScore: 
                    bsr      Encode3chars 
; handle level 5 bits 
                    lda      ,y+                          ; load level 
                    sta      ,x+                          ; store level 
                                                          ; handle score 
                    pshs     y,x 
                    tfr      y,x 
                    jsr      toConversion5                ; put current score to conversion buffer 
                    jsr      convertAsciiToD              ; current score as "number" in D 
                    puls     y,x 
                    leay     6,y 
                    std      ,x++                         ; store score 
                    dec      levelDoneTemp 
                    bne      convertNextScore 
; conversion done
; bytes in newEepromRAMStart
; = 3 + 5*5 = 28
                    rts      

;***************************************************************************
; x address to copy to
fromNewEeprom 
                    lda      #5 
                    sta      levelDoneTemp 
; handle name 3 chars
                    tfr      x,y 
;                    ldy      #eepromRAMStart 
                    ldx      #newEepromRAMStart 
convertNextScore2: 
                    bsr      Decode3chars 
; handle level 5 bits 
                    lda      ,x+                          ; load level 
                    sta      ,y+                          ; store level 
                                                          ; handle score 
                    ldd      ,x++                         ; get 16bit score 
                    pshs     y,x 
                    jsr      convertDToAscii 
                    puls     y,x 
                    ldu      #conversionBuffer 
                    ldd      ,u++                         ; copy 6 ascii bytes 
                    std      ,y++ 
                    ldd      ,u++ 
                    std      ,y++ 
                    ldd      ,u++ 
                    std      ,y++ 
                    dec      levelDoneTemp 
                    bne      convertNextScore2 
                    rts      

;***************************************************************************
                                                          ; input : y = output string pointer 
                                                          ; x = input pointer to uint16 
Decode3chars        lda      ,x                           ; byte 0: 1aaaaabb 
                    asra     
                    asra     
                    anda     #$1f 
                    beq      decode_zero 
                    adda     # 'A'-' '-1
decode_zero         adda     # ' '
                    sta      ,y+                          ; char 0 
                    lda      ,x+                          ; byte 0: 1aaaaabb 
                    ldb      ,x                           ; byte 1: bbbccccc 
                    rolb     
                    rola     
                    rolb     
                    rola     
                    rolb     
                    rola     
                    anda     #$1f 
                    beq      decode_one 
                    adda     # 'A'-' '-1
decode_one          adda     # ' '
                    sta      ,y+                          ; char 1 
                    lda      ,x+                          ; byte 1: bbbccccc 
                    anda     #$1f 
                    beq      decode_two 
                    adda     # 'A'-' '-1
decode_two          adda     # ' '
                    sta      ,y+                          ; char 2 
                    rts      

;***************************************************************************
; routines from thomas encode/decode
                                                          ; input : y = string pointer 
                                                          ; x = output pointer to uint16 
Encode3chars        lda      ,y+                          ; char 0 
                    suba     # ' '
                    beq      encode_zero 
                    suba     # 'A'-' '-1
encode_zero         asla     
                    asla     
                    ora      #$80                         ; the flag bit 
                    sta      ,x                           ; byte 0: 1aaaaa00 
                    lda      ,y+                          ; char 1 
                    suba     # ' '
                    beq      encode_one 
                    suba     # 'A'-' '-1
encode_one          clrb     
                    asra     
                    rorb     
                    asra     
                    rorb     
                    asra     
                    rorb     
                    ora      ,x                           ; byte 0: 1aaaaabb 
                    sta      ,x+ 
                    stb      ,x                           ; byte 1: bbb00000 
                    lda      ,y+                          ; char 2 
                    suba     # ' '
                    beq      encode_two 
                    suba     # 'A'-' '-1
encode_two          ora      ,x                           ; byte 1: bbbccccc 
                    sta      ,x+ 
                    rts      

;***************************************************************************
;;;;;;;;;;;;;
