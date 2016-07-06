;
;
; DS2430LS.I
; 
;
; Copyright (c) 2002 Alex Herbert
;
;




; DS2430 Commands

DS2430_WRITESP  equ     $0f     ; Write bytes to Scratch Pad
DS2430_COPYSP   equ     $55     ; Copy entire Scratch Pad to EEPROM
DS2430_READSP   equ     $aa     ; Read bytes from Scratch Pad
DS2430_READMEM  equ     $f0     ; As READSP, but copies EEPROM to SP first

DS2430_LOCKAR   equ     $5a     ; Lock Application Register
DS2430_READSR   equ     $66     ; Read Status Register
DS2430_WRITEAR  equ     $99     ; Write bytes to Application Register
DS2430_READAR   equ     $c3     ; Read bytes from Application Register

DS2430_VALKEY   equ     $a5     ; Validation byte for COPYSP and LOCKAR



; DS2430 Timings

DS2430_COPYDUR  equ     $983a   ; $3a98 = 15000 cycles = 10ms




; Subroutines

        code




; ds2430_load
;
; function:
;       load DS2430 EEPROM to RAM
;
; on entry:
;       x = load address
;
; on exit:
;       a = 0 if no error,
;           non-zero if error


ds2430_load
        lda     #$20            ; number of bytes to load (loop counter)
        pshs    d,dp,x          ; stack used registers
        
        DP_IO                   ; dp = $d0

        jsr     ds1w_open       ; open 1-wire port

        jsr     ds1w_reset      ; reset device
        bmi     dsload_exit     ; exit if no device present

        lda     #DS1W_SKIPROM   ; no need to access rom
        jsr     ds1w_txbyte     ; send command

        lda     #DS2430_READMEM ; copy eeprom to scratch pad
        jsr     ds1w_txbyte     ; send command

        clra                    ; address of first byte to load
        jsr     ds1w_txbyte     ; send address

dsload_loop
        jsr     ds1w_rxbyte     ; read byte from scratch pad
        sta     ,x+             ; save to ram
        dec     ,s              ; decrement loop counter
        bne     dsload_loop     ; until all bytes are read

dsload_exit
        jsr     ds1w_close      ; close port
        puls    d,dp,x,pc       ; restore registers from stack and return

        direct  -1




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

ds2430_save
        lda     #$20            ; number of bytes to save (loop counter)
        pshs    d,dp,x          ; stack used registers

        DP_IO                   ; dp = $d0

        jsr     ds1w_open       ; open 1-wire port

        jsr     ds1w_reset      ; reset device
        bmi     dssave_exit     ; exit if no device present

        lda     #DS1W_SKIPROM   ; no need to access rom
        jsr     ds1w_txbyte     ; send command

        lda     #DS2430_WRITESP ; write bytes to scratch pad
        jsr     ds1w_txbyte     ; send command

        clra                    ; address of first byte
        jsr     ds1w_txbyte     ; send address

dssave_loop
        lda     ,x+             ; get byte from ram
        jsr     ds1w_txbyte     ; send byte
        dec     ,s              ; decrement loop counter
        bne     dssave_loop     ; until all bytes are sent

        jsr     ds1w_reset      ; reset device

        lda     #DS1W_SKIPROM   ; no need to access rom
        jsr     ds1w_txbyte     ; send command

        lda     #DS2430_COPYSP  ; copy scratch pad to eeprom
        jsr     ds1w_txbyte     ; send command

        lda     #DS2430_VALKEY  ; validation key
        jsr     ds1w_txbyte     ; send key

        ldd     #DS2430_COPYDUR ; eeprom write (scratch pad copy) duration
        std     T1LOLC          ; start timer

        ldb     #$40
dssave_loop2
        bitb    IFLAG
        beq     dssave_loop2    ; wait for timer

dssave_exit
        jsr     ds1w_close      ; close port
        puls    d,dp,x,pc       ; restore registers from stack and return

        direct  -1


; ds2430_verify
;
; function:
;       compare DS2430 EEPROM to RAM
;
; on entry:
;       x = data address
;
; on exit:
;       a = 0 if same,
;           non-zero if different


ds2430_verify
        lda     #$20            ; number of bytes to verify (loop counter)
        pshs    d,dp,x          ; stack used registers
        
        DP_IO                   ; dp = $d0

        jsr     ds1w_open       ; open 1-wire port

        jsr     ds1w_reset      ; reset device
        bmi     dsverify_exit   ; exit if no device present

        lda     #DS1W_SKIPROM   ; no need to access rom
        jsr     ds1w_txbyte     ; send command

        lda     #DS2430_READMEM ; copy eeprom to scratch pad
        jsr     ds1w_txbyte     ; send command

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
        puls    d,dp,x,pc       ; restore registers from stack and return

        direct  -1


