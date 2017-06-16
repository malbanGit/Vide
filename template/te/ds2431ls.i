;
;
; DS2431LS.I
; 
;
;   2016 Thomas G. Sontowski:
;   based on Alex Herbert's ds2430 driver
;




; DS2431 Commands

DS2431_WRITESP  equ     $0f     ; Write bytes to Scratch Pad
DS2431_COPYSP   equ     $55     ; Copy entire Scratch Pad to EEPROM
DS2431_READSP   equ     $aa     ; Read bytes from Scratch Pad
DS2431_READMEM  equ     $f0     ; As READSP, but copies EEPROM to SP first

; DS2431 Timings

DS2431_COPYDUR  equ     $983a   ; $3a98 = 15000 cycles = 10ms (A1: 12.5ms, A2 and later: 10ms)



; Subroutines

;        code




; ds2431_load
;
; function:
;       load DS2431 EEPROM to RAM
;
; on entry:
;       x = load address
;
; on exit:
;       a = 0 if no error,
;           non-zero if error

ds2431_load
    if EPROMDONGLE
        ldd     #EEPROM_STORESIZE*256+8
    else
        lda     #EEPROM_STORESIZE ; number of bytes to save (loop counter)
    endif
        pshs    d,x             ; stack used registers

        jsr     ds1w_open       ; open 1-wire port

        jsr     ds1w_reset      ; reset device
    if EPROMDONGLE
        bmi     eeprom_not_identified ; exit if no device present
    else
        bmi     ds2431load_exit ; exit if no device present
    endif

    if EPROMDONGLE
        lda     #DS1W_READ_ROM
        jsr     ds1w_txbyte
eeprom_identify_loop
        jsr     ds1w_rxbyte     ; read byte from ROM
        sta     ,x+             ; save to ram
        dec     1,s             ; decrement loop counter
        bne     eeprom_identify_loop     ; until all bytes are read
        ldx     2,s
        ldd     1,x
        cmpd    #EPROMID_0      ; check unique id, ignore crc&family id
        bne     eeprom_not_identified
        ldd     3,x
        cmpd    #EPROMID_1
        bne     eeprom_not_identified
        ldd     5,x
        cmpd    #EPROMID_2
        beq     eeprom_identified
eeprom_not_identified
        rts
eeprom_identified
    else
        lda     #DS1W_SKIPROM   ; no need to access rom, non-overdrive version
        jsr     ds1w_txbyte     ; send command
    endif

        lda     #DS2431_READMEM ; read memory
        jsr     ds1w_txbyte     ; send command

        clra                    ; address of first byte to load
        jsr     ds1w_txbyte     ; send address
        clra                    ; address of first byte to load
        jsr     ds1w_txbyte     ; send address

ds2431load_loop
        jsr     ds1w_rxbyte     ; read byte from scratch pad
        sta     ,x+             ; save to ram
        dec     ,s              ; decrement loop counter
        bne     ds2431load_loop ; until all bytes are read

ds2431load_exit
        jsr     ds1w_close      ; close port
        puls    d,x,pc          ; restore registers from stack and return

;        direct  -1

    if USE_MUSIC
ds2431_hide
        jsr     ds1w_open       ; open 1-wire port
    
        jsr     ds1w_reset      ; reset device
        bmi     ds2431hide_exit ; exit if no device present

        lda     #DS1W_MATCHROM  ; send match command for a non-existing ic
        jsr     ds1w_txbyte     ; send command
        clra
        jsr     ds1w_txbyte
        clra
        jsr     ds1w_txbyte     ; send 0,0,0,0 to match against
        clra
        jsr     ds1w_txbyte
        clra
        jsr     ds1w_txbyte
ds2431hide_exit
        jsr     ds1w_close      ; open 1-wire port

        rts
    endif

; ds2431_save
;
; function:
;       save RAM to DS2431 EEPROM
;
; on entry:
;       x = address of data to save
;
; on exit:
;       a = 0 if no error,
;           non-zero if error


ds2431_save
        ldd     #EEPROM_STORESIZE*256    ; number of bytes to save (loop counter)
        tst     store_everything_flag
        bne     ds2431_save_all
        ldd     #8*256+40       ; just the last 8 bytes (incl. options and checksum)
        leax    40,x
ds2431_save_all
        pshs    d,x             ; stack used registers

        jsr     ds1w_open       ; open 1-wire port

ds2431_scratchpadloop
        jsr     ds1w_reset      ; reset device
        bmi     dssave_exit     ; exit if no device present

        lda     #DS1W_SKIPROM   ; no need to access rom
        jsr     ds1w_txbyte     ; send command

        lda     #DS2431_WRITESP ; write bytes to scratch pad
        jsr     ds1w_txbyte     ; send command

        lda     1,s             ; address
        jsr     ds1w_txbyte     ; send address
        clra
        jsr     ds1w_txbyte

dssave_loop
        lda     ,x+             ; get byte from ram
        jsr     ds1w_txbyte     ; send byte
        dec     ,s              ; decrement loop counter
        lda     ,s
        bita    #$7
        bne     dssave_loop     ; until 8 bytes are sent

        jsr     ds1w_reset      ; reset device

        lda     #DS1W_SKIPROM   ; no need to access rom
        jsr     ds1w_txbyte     ; send command

        lda     #DS2431_READSP
        jsr     ds1w_txbyte     ; send command

        ; read the authorization code
        jsr     ds1w_rxbyte     ; read byte from scratch pad
        sta     -6,s            ; TA1
        jsr     ds1w_rxbyte     ; read byte from scratch pad
        sta     -5,s            ; TA2
        jsr     ds1w_rxbyte     ; read byte from scratch pad
        sta     -4,s            ; E/S

        jsr     ds1w_reset      ; reset device

        lda     #DS1W_SKIPROM   ; no need to access rom
        jsr     ds1w_txbyte     ; send command

        lda     #DS2431_COPYSP  ; copy scratch pad to eeprom
        jsr     ds1w_txbyte     ; send command

        lda     -6,s
        jsr     ds1w_txbyte     ; send validation
        lda     -5,s
        jsr     ds1w_txbyte     ; send validation
        lda     -4,s
        jsr     ds1w_txbyte     ; send validation

        ldd     #DS2431_COPYDUR ; eeprom write (scratch pad copy) duration
        std     T1LOLC          ; start timer

        ldb     #$40
dssave_loop2
        bitb    IFLAG
        beq     dssave_loop2    ; wait for timer
        tst     ,s
        beq     dssave_exit
        lda     1,s
        adda    #8
        sta     1,s
        bra     ds2431_scratchpadloop

dssave_exit
        jsr     ds1w_close      ; close port
    if USE_MUSIC
        jsr     ds2431_hide
    endif
        puls    d,x,pc          ; restore registers from stack and return

;        direct  -1



