;
;
; DS2431V.I
; 
;
; Copyright (c) 2016 Thomas G. Sontowski
;
;

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
        lda     #EEPROM_STORESIZE ; number of bytes to verify (loop counter)
        pshs    d,x             ; stack used registers

        jsr     ds1w_open       ; open 1-wire port

        jsr     ds1w_reset      ; reset device
        bmi     dsverify_exit   ; exit if no device present

        lda     #DS1W_SKIPROM   ; no need to access rom
        jsr     ds1w_txbyte     ; send command

        lda     #DS2431_READMEM ; copy eeprom to scratch pad
        jsr     ds1w_txbyte     ; send command

        clra                    ; address of first byte to verify
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


