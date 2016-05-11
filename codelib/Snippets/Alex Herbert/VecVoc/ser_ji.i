;
;
; SER_JI.I - Serial Output on Joystick port, Inverted
;
;
; Copyright (c) Alex Herbert 2002
;
;




;
; This code assumes that the following constant have been declared.
; If not... un-comment them!
;
;CNTRL   equ     $d000
;DAC     equ     $d001
;DDAC    equ     $d003
;T1LOLC  equ     $d004
;ACNTRL  equ     $d00b
;IFLAG   equ     $d00d
;



;
; Baud rate setting
;

SER_BITTIME     equ     $9c00   ; $009c = 156 cycles = 9615 baud



;
; Subroutines
;


        code
        direct  CNTRL           ; assume dp = $d0



;
; ser_txbyte
; ----------
;
; Function:
;       transmit byte serially (8n1, inverted) via joystick ports.
;
; On entry:
;       a = byte to transmit
;       dp = $d0
;
; On exit:
;       d,cc = corrupted
;
; Stack usage:
;       5 bytes (7 if you include the return address)
;


ser_txbyte
        pshs    a               ; put data on stack

        ldd     #$9907
        std     CNTRL           ; select PSG register 7
        ldd     #$5881
        sta     ACNTRL          ; T1 mode = free-run, no output on RAMP (PB7)
        stb     CNTRL           ; latch PSG register

        ldd     #SER_BITTIME
        std     T1LOLC          ; set and start timer (T1)

        ldd     #$0089
        sta     DDAC            ; 6522 I/O port data direction = input
        stb     CNTRL           ; enable PSG reading
        ldb     #$08            ; loop counter (here for timing)
        lda     DAC             ; read PSG register 7
        pshs    d               ; save PSG R7 and loop counter on stack
        ora     #$40
        sta     DAC             ; store data for PSG write
        ldd     #$ff81
        stb     CNTRL           ; disable PSG reading
        sta     DDAC            ; 6522 I/O direction = output

        bsr     ser_txbit       ; transmit start bit [0]

sertx_loop
        lsr     2,s             ; shift next data bit into carry
        bcs     ser_tx1

ser_tx0
        lda     ,s
        ora     #$40
        sta     DAC             ; store data for PSG write
        bsr     ser_txbit       ; transmit data bit [0]
        bra     sertx_next

ser_tx1
        lda     ,s
        sta     DAC             ; store data for PSG write
        bsr     ser_txbit       ; transmit data bit [1]

sertx_next
        dec     1,s             ; decrement loop counter
        bne     sertx_loop      ; loop if more bits to send

        lda     ,s
        sta     DAC             ; store data for PSG write
        bsr     ser_txbit       ; tansmit stop bit [1]

        lda     #$18
        sta     ACNTRL          ; T1 = single-shot, no output on RAMP (PB7)
        ldd     #$0200
        std     T1LOLC          ; force T1 timeout
        lda     #$98
        sta     ACNTRL          ; T1 = single-shot, RAMP output (PB7) enabled

        leas    3,s             ; restore stack
        rts


ser_txbit
        lda     #$40
sertxbit_loop
        bita    IFLAG           ; test T1 interrupt flag
        beq     sertxbit_loop   ; loop until T1 timeout

        lda     #$91
        sta     CNTRL           ; enable PSG register write
        stb     CNTRL           ; latch data

        lda     T1LOLC          ; clear T1 interrupt flag

        rts



        direct  -1



