; this file is part of Release, written by Malban in 2017
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

;DS2430_LOCKAR   equ     $5a     ; Lock Application Register
;DS2430_READSR   equ     $66     ; Read Status Register
;DS2430_WRITEAR  equ     $99     ; Write bytes to Application Register
;DS2430_READAR   equ     $c3     ; Read bytes from Application Register

;DS2430_VALKEY   equ     $a5     ; Validation byte for COPYSP and LOCKAR



; DS2431 Timings

DS2431_COPYDUR  equ     $983a   ; $3a98 = 15000 cycles = 10ms (A1: 12.5ms, A2 and later: 10ms)




; Subroutines

        code



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
        lda     current_eprom_blocksize    ; number of bytes to save (loop counter)
;        lda     #EEPROM_STORESIZE ; number of bytes to save (loop counter)
        pshs    d,x             ; stack used registers

 DP_IO

        jsr     ds1w_open       ; open 1-wire port

        jsr     ds1w_reset      ; reset device
        bmi     ds2431load_exit ; exit if no device present

        lda     #DS1W_SKIPROM   ; no need to access rom, non-overdrive version
        bsr     ds1w_txbyte     ; send command

        lda     #DS2431_READMEM ; read memory
        bsr     ds1w_txbyte     ; send command

        lda     current_eprom_blockadr    ; 
;        clra                    ; address of first byte to load
        bsr     ds1w_txbyte     ; send address
        clra                    ; address of first byte to load
        bsr     ds1w_txbyte     ; send address

ds2431load_loop
        bsr     ds1w_rxbyte     ; read byte from scratch pad
        sta     ,x+             ; save to ram
        dec     ,s              ; decrement loop counter
        bne     ds2431load_loop ; until all bytes are read

ds2431load_exit
        jsr     ds1w_close      ; close port
        puls    d,x,pc          ; restore registers from stack and return




; ds2430_save
;
; function:
;       save RAM to DS2430 EEPROM
;
; on entry:
;       x = address of data to save
; 
; on exit:
;       a = 0 if no error,
;           non-zero if error
ds2431_save 
        lda     current_eprom_blocksize    ; number of bytes to save (loop counter)
 ldb current_eprom_blockadr

; clrb
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
 jsr ensureBank1
        puls    d,x,pc          ; restore registers from stack and return

        direct  -1


; ds2431_verify
;
; function:
;       compare DS2431 EEPROM to RAM
;
; on entry:
;       x = data address
;
; on exit:
;       a = 0 if same,
;           non-zero if different


ds2431_verify
        lda     current_eprom_blocksize    ; number of bytes to save (loop counter)
;        lda     #EEPROM_STORESIZE ; number of bytes to verify (loop counter)
        pshs    d,x             ; stack used registers

        jsr     ds1w_open       ; open 1-wire port

        jsr     ds1w_reset      ; reset device
        bmi     dsverify_exit   ; exit if no device present

        lda     #DS1W_SKIPROM   ; no need to access rom
        jsr     ds1w_txbyte     ; send command

        lda     #DS2431_READMEM ; copy eeprom to scratch pad
        jsr     ds1w_txbyte     ; send command

;        clra                    ; address of first byte to verify
 lda current_eprom_blockadr
        jsr     ds1w_txbyte     ; send address
        clra                    ; address of first byte to verify
        jsr     ds1w_txbyte     ; send address

dsverify_loop
        jsr     ds1w_rxbyte     ; read byte from scratch pad
        cmpa    ,x+             ; compare to ram
        bne     dsverify_exit   ; exit if not same
        dec     ,s              ; decrement loop counter
        bne     dsverify_loop   ; until all bytes are read

dsverify_exit
        jsr     ds1w_close      ; close port
        puls    d,x,pc          ; restore registers from stack and return

;        direct  -1



