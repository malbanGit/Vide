; ds1w_open
;
; function:
;       Prepares Vectrex I/O hardware (6522) for 1-Wire communication.
;
; on entry:
;       dp = $d0
;
; on exit:
;       d  = undefined


ds1w_openU
        ldd     #$8118
        sta     CNTRL           ; make sure PB7 is set, PB6 is cleared
        stb     ACNTRL          ; Disable T1 output on PB7 (RAMP)
        rts




; ds1w_close
;
; function:
;       Restores Vectrex I/O hardware (6522) defaults.
;
; on entry:
;       dp = $d0
;
; on exit:
;       b  = undefined


ds1w_closeU
        ldb     #$98
        stb     ACNTRL          ; Enable T1 output on PB7 (RAMP)
        rts




; ds1w_reset
;
; function:
;       Reset 1-Wire device(s), and detect if device is present.
;
; on entry:
;       dp = $d0
;
; on exit:
;       a  = 0 if device is present, -1 if not.
;       b  = undefined
;       cc = z=1 and n=0 if device present,
;            z=0 and n=1 if device not present.


ds1w_resetU
        ldd     #DS1W_RESETDUR  ; reset pulse duration
        std     T1LOLC          ; start timer

        ; generate reset pulse

        lda     #$df
        sta     DCNTRL          ; PB6 direction = output

        ldb     #$40
dsreset_loop1U
        bitb    IFLAG
        beq     dsreset_loop1U  ; wait for timer

        lda     #$9f
        sta     DCNTRL          ; PB6 direction = input

        ; check for presence pulse

        bitb    CNTRL           ; test PB6
        beq     ds1w_notpresentU ; PB6 was low too early (emulator?)

        ldd     #DS1W_PRESDUR   ; presence pulse detect duration
        std     T1LOLC          ; start timer

        ldb     #$40
dsreset_loop2U
        bitb    CNTRL           ; test PB6
        beq     dsreset_loop3U
        bitb    IFLAG           ; timeout?
        beq     dsreset_loop2U
        bra     ds1w_notpresentU ; PB6 didn't go low (no device attached?)

dsreset_loop3U
        bitb    IFLAG
        beq     dsreset_loop3U   ; wait for timer

        bitb    CNTRL
        beq     ds1w_notpresentU ; PB6 stayed low too long (fault?)

ds1w_presentU
        lda     #DS1W_TSLOTDUR  ; time slot duration
        sta     T1LOLC          ; load timer latch

        clra                    ; return "no error"
        rts

ds1w_notpresentU
        lda     #-1             ; return "device not present"
        rts




; ds1w_txbyte
;
; function:
;       Transmit byte to 1-Wire device.
;
; on entry:
;       a  = byte to send
;       dp = $d0
;
; on exit:
;       d  = undefined


ds1w_txbyteU
        ldb     #$08            ; bits in byte
        stb     -1,s            ; put loop counter 'above' stack

ds1w_txbitsU
        lsra                    ; shift data into carry
        bcs     ds1w_txbit1U

ds1w_txbit0U
        clr     T1HOC           ; start timer

        ; long pulse low  ~~\________/~~

        ldb     #$df
        stb     DCNTRL          ; PB6 direction = output

        ldb     #$40
dstx0_loopU
        bitb    IFLAG
        beq     dstx0_loopU      ; wait for end of time slot

        ldb     #$9f
        stb     DCNTRL          ; PB6 direction = input

        dec     -1,s
        bne     ds1w_txbitsU
        rts

ds1w_txbit1U
        clr     T1HOC           ; start timer

        ; short pulse low  ~~\_/~~~~~~~~~

        ldb     #$df
        stb     DCNTRL          ; PB6 direction = output

        ldb     #$9f
        stb     DCNTRL          ; PB6 direction = input

        ldb     #$40
dstx1_loopU
        bitb    IFLAG
        beq     dstx1_loopU      ; wait for end of time slot

        dec     -1,s
        bne     ds1w_txbitsU
        rts




; ds1w_rxbyte
;
; function:
;       Receive byte from 1-Wire device.
;
; on entry:
;       dp = $d0
;
; on exit:
;       a  = received byte
;       b  = undefined


ds1w_rxbyteU
        ldb     #$08            ; bits in byte
        stb     -1,s            ; put loop counter 'above' stack

ds1w_rxbitsU
        clr     T1HOC           ; start timer

        ; short pulse low  ~~\_xxxxxx~~~~

        ldb     #$df
        stb     DCNTRL          ; PB6 direction = output

        ldb     #$9f
        stb     DCNTRL          ; PB6 direction = input

        ; read response

        nop                     ; timing

        ldb     CNTRL           ; read PB
        lslb                    ; shift PB6...
        lslb                    ; ...into carry...
        rora                    ; ...and rotate into result byte

        ldb     #$40
dsrx_loopU
        bitb    IFLAG
        beq     dsrx_loopU       ; wait for end of time slot

        dec     -1,s
        bne     ds1w_rxbitsU
        rts



;        direct  -1



