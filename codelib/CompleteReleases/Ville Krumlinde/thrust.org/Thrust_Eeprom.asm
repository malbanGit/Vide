;Thrust EEPROM support
;368 bytes
;todo optimize size:  gör om ds1w_txbyte så att den tar count i A och data i X
;                     load o verify har samma setup-code, gör till en sub som bägge anropar


;
;
; Example DS2430A code
;
;
; Copyright (c) 2003 Alex Herbert
;
;


; PIA Registers

CNTRL   equ     $d000   ; ORB / IRB - Output Register B / Input Register B
DAC     equ     $d001   ; ORA / IRA - Output Register A / Input Register A
DCNTRL  equ     $d002   ; DDRB      - Data Direction Register B
DDAC    equ     $d003   ; DDRA      - Data Direction Register A
T1LOLC  equ     $d004   ; T1C-L     - Timer 1 Counter/Latch Low byte
T1HOC   equ     $d005   ; T1C-H     - Timer 1 Counter High byte
T1LOL   equ     $d006   ; T1L-L     - Timer 1 Latch Low byte
T1HOL   equ     $d007   ; T1L-H     - Timer 1 Latch High byte
T2LOLC  equ     $d008   ; T2C-L     - Timer 2 Counter/Latch Low byte
T2HOC   equ     $d009   ; T2C-H     - Timer 2 Counter High byte
SHIFT   equ     $d00a   ; SR        - Shift Register
ACNTRL  equ     $d00b   ; ACR       - Auxiliary Control Register
PCNTRL  equ     $d00c   ; PCR       - Peripheral Control Register
IFLAG   equ     $d00d   ; IFR       - Interrupt Flag Register
IENABL  equ     $d00e   ; IER       - Interrupt Enable Register



DP_IO macro
  lda   #0xD0
  tfr   a,dp
  endm


; EEPROM constants
EEPROM_CHECKSUM equ     $87     ; any value other than $00 or $e0


;
;
; DS1W - Dallas Semiconductor 1-Wire Driver
;
;
; Copyright (c) 2002 Alex Herbert
;
;


; 1-Wire Timing constants
DS1W_RESETDUR   equ     $2a03   ; Reset Pulse duration
                                ; $032a = 810 cycles = 540us

DS1W_PRESDUR    equ     $d002   ; Presence Pulse duration
                                ; $02d0 = 720 cycles = 480us

DS1W_TSLOTDUR   equ     $78     ; Time Slot duration
                                ; $78 = 120cycles = 80us


; Note:
;
; For reliability DS1W_RESETDUR and DS1W_TSLOTDUR are set above the
; minimums specified by the datasheet. To improve performance, values
; closer to the specified minimums may be used.
;
; DS1W_RESETDUR minimum = 480us
; DS1W_TSLOTDUR minimum = 60us




; 1-Wire ROM commands

DS1W_READROM    equ     $33
DS1W_SKIPROM    equ     $cc

DS1W_MATCHROM   equ     $55
DS1W_SEARCHROM  equ     $f0




; Subroutines

        code

        direct  CNTRL



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
ds1w_open
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
ds1w_close
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
ds1w_reset
        ldd     #DS1W_RESETDUR  ; reset pulse duration
        std     T1LOLC          ; start timer

        ; generate reset pulse

        lda     #$df
        sta     DCNTRL          ; PB6 direction = output

        ldb     #$40
dsreset_loop1
        bitb    IFLAG
        beq     dsreset_loop1   ; wait for timer

        lda     #$9f
        sta     DCNTRL          ; PB6 direction = input

        ; check for presence pulse

        bitb    CNTRL           ; test PB6
        beq     ds1w_notpresent ; PB6 was low too early (emulator?)

        ldd     #DS1W_PRESDUR   ; presence pulse detect duration
        std     T1LOLC          ; start timer

        ldb     #$40
dsreset_loop2
        bitb    CNTRL           ; test PB6
        beq     dsreset_loop3
        bitb    IFLAG           ; timeout?
        beq     dsreset_loop2
        bra     ds1w_notpresent ; PB6 didn't go low (no device attached?)

dsreset_loop3
        bitb    IFLAG
        beq     dsreset_loop3   ; wait for timer

        bitb    CNTRL
        beq     ds1w_notpresent ; PB6 stayed low too long (fault?)

ds1w_present
        lda     #DS1W_TSLOTDUR  ; time slot duration
        sta     T1LOLC          ; load timer latch

        clra                    ; return "no error"
        rts

ds1w_notpresent
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
ds1w_txbyte
        ldb     #$08            ; bits in byte
        stb     -1,sp           ; put loop counter 'above' stack

ds1w_txbits
        lsra                    ; shift data into carry
        bcs     ds1w_txbit1

ds1w_txbit0
        clr     T1HOC           ; start timer

        ; long pulse low  ~~\________/~~

        ldb     #$df
        stb     DCNTRL          ; PB6 direction = output

        ldb     #$40
dstx0_loop
        bitb    IFLAG
        beq     dstx0_loop      ; wait for end of time slot

        ldb     #$9f
        stb     DCNTRL          ; PB6 direction = input

        dec     -1,sp
        bne     ds1w_txbits
        rts

ds1w_txbit1
        clr     T1HOC           ; start timer

        ; short pulse low  ~~\_/~~~~~~~~~

        ldb     #$df
        stb     DCNTRL          ; PB6 direction = output

        ldb     #$9f
        stb     DCNTRL          ; PB6 direction = input

        ldb     #$40
dstx1_loop
        bitb    IFLAG
        beq     dstx1_loop      ; wait for end of time slot

        dec     -1,sp
        bne     ds1w_txbits
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
ds1w_rxbyte
        ldb     #$08            ; bits in byte
        stb     -1,sp           ; put loop counter 'above' stack

ds1w_rxbits
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
dsrx_loop
        bitb    IFLAG
        beq     dsrx_loop       ; wait for end of time slot

        dec     -1,sp
        bne     ds1w_rxbits
        rts

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



eeprom_load
        ldx     #eeprom_buffer          ;
        jsr     ds2430_load             ; load 32 byte eeprom to ram

        ldd     #$0020                  ;
eeload_loop                             ;
        adda    ,x+                     ; sum the bytes
        decb                            ;
        bne     eeload_loop             ;

        cmpa    #EEPROM_CHECKSUM        ; equal to checksum?
        bne     eeprom_format           ; if not, then format the eeprom

        rts                             ; otherwise, return


;Init eeprom-buffer with valid data
;Called when eeprom is erased, or eeprom is not present
DefaultString: db '  1000',$80
eeprom_format
  ldu #eeprom_buffer
  mCombine d,DefaultButtonConfig,0
  ;First byte is control, second is bonusgameenabled, the rest are highscores
  std ,u++
  ldb #4
eeformat_loop
  ldx #DefaultString
  jsr Text_CopyString
  decb
  bne eeformat_loop


;        ldx     #eeprom_buffer          ;
;        ldu     #eeprom_defaults        ;
;        ldb     #$1f                    ;
;eeformat_loop                           ; copy default data (rom) to ram
;        pulu    a                       ;
;        sta     ,x+                     ;
;        decb                            ;
;        bne     eeformat_loop           ;


eeprom_save
        ldx     #eeprom_buffer          ;
        ldd     #(EEPROM_CHECKSUM<<8)+$1f ;
eesave_loop                             ;
        suba    ,x+                     ; create checksum byte
        decb                            ;
        bne     eesave_loop             ;
        sta     ,x                      ;

        ldx     #eeprom_buffer          ;
        jsr     ds2430_verify           ; compare ram to eeprom
        tsta                            ;
        bne     ds2430_save             ; if different, then update eeprom

        rts


