; this file is part of Release, written by Malban in 2017
;
;
;
; DS1W - Dallas Semiconductor 1-Wire Driver
;
;
; Copyright (c) 2002 Alex Herbert
;
;
; Memory Base Addresses
GAMCRT              equ      $0000                        ; Cartridge ROM ($0000-$7fff = 32k) 
RAM                 equ      $c800                        ; Internal RAM ($c800-$cbff = 1k) 
LASRAM              equ      $c880                        ; Free RAM ($c880-stack) 
PWRUP               equ      $f000                        ; Executive ROM ($f000-$ffff = 4k) 
; PIA Registers
CNTRL               equ      $d000                        ; ORB / IRB - Output Register B / Input Register B 
DAC                 equ      $d001                        ; ORA / IRA - Output Register A / Input Register A 
DCNTRL              equ      $d002                        ; DDRB - Data Direction Register B 
DDAC                equ      $d003                        ; DDRA - Data Direction Register A 
T1LOLC              equ      $d004                        ; T1C-L - Timer 1 Counter/Latch Low byte 
T1HOC               equ      $d005                        ; T1C-H - Timer 1 Counter High byte 
T1LOL               equ      $d006                        ; T1L-L - Timer 1 Latch Low byte 
T1HOL               equ      $d007                        ; T1L-H - Timer 1 Latch High byte 
T2LOLC              equ      $d008                        ; T2C-L - Timer 2 Counter/Latch Low byte 
T2HOC               equ      $d009                        ; T2C-H - Timer 2 Counter High byte 
SHIFT               equ      $d00a                        ; SR - Shift Register 
ACNTRL              equ      $d00b                        ; ACR - Auxiliary Control Register 
PCNTRL              equ      $d00c                        ; PCR - Peripheral Control Register 
IFLAG               equ      $d00d                        ; IFR - Interrupt Flag Register 
IENABL              equ      $d00e                        ; IER - Interrupt Enable Register 
; Direct Page Macros
DP_RAM              macro    
                    lda      #RAM>>8 
                    tfr      a,dp 
                    direct   RAM 
                    endm     
DP_IO               macro    
                    lda      #CNTRL>>8 
                    tfr      a,dp 
                    direct   CNTRL 
                    endm     
; 1-Wire Timing constants
DS1W_RESETDUR       equ      $2a03                        ; Reset Pulse duration 
                                                          ; $032a = 810 cycles = 540us 
DS1W_PRESDUR        equ      $d002                        ; Presence Pulse duration 
                                                          ; $02d0 = 720 cycles = 480us 
DS1W_TSLOTDUR       equ      $78                          ; Time Slot duration 
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
DS1W_READROM        equ      $33 
DS1W_SKIPROM        equ      $cc 
DS1W_MATCHROM       equ      $55 
DS1W_SEARCHROM      equ      $f0 
; Subroutines
                    code     
                    direct   CNTRL 
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
ds1w_open                                                 ;#isfunction  
                    ldd      #$8118 
                    sta      CNTRL                        ; make sure PB7 is set, PB6 is cleared 
                    stb      ACNTRL                       ; Disable T1 output on PB7 (RAMP) 
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
ds1w_close                                                ;#isfunction  
                    ldb      #$98 
                    stb      ACNTRL                       ; Enable T1 output on PB7 (RAMP) 
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
ds1w_reset                                                ;#isfunction  
                    ldd      #DS1W_RESETDUR               ; reset pulse duration 
                    std      T1LOLC                       ; start timer 
                                                          ; generate reset pulse 
                    lda      #$df 
                    sta      DCNTRL                       ; PB6 direction = output 
                    ldb      #$40 
dsreset_loop1 
                    bitb     IFLAG 
                    beq      dsreset_loop1                ; wait for timer 
                    lda      #$9f 
                    sta      DCNTRL                       ; PB6 direction = input 
                                                          ; check for presence pulse 
                    bitb     CNTRL                        ; test PB6 
                    beq      ds1w_notpresent              ; PB6 was low too early (emulator?) 
                    ldd      #DS1W_PRESDUR                ; presence pulse detect duration 
                    std      T1LOLC                       ; start timer 
                    ldb      #$40 
dsreset_loop2 
                    bitb     CNTRL                        ; test PB6 
                    beq      dsreset_loop3 
                    bitb     IFLAG                        ; timeout? 
                    beq      dsreset_loop2 
                    bra      ds1w_notpresent              ; PB6 didn't go low (no device attached?) 

dsreset_loop3 
                    bitb     IFLAG 
                    beq      dsreset_loop3                ; wait for timer 
                    bitb     CNTRL 
                    beq      ds1w_notpresent              ; PB6 stayed low too long (fault?) 
ds1w_present 
                    lda      #DS1W_TSLOTDUR               ; time slot duration 
                    sta      T1LOLC                       ; load timer latch 
                    clra                                  ; return "no error" 
                    rts      

ds1w_notpresent 
                    lda      #-1                          ; return "device not present" 
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
ds1w_txbyte                                               ;#isfunction  
                    ldb      #$08                         ; bits in byte 
                    stb      -1,sp                        ; put loop counter 'above' stack 
ds1w_txbits 
                    lsra                                  ; shift data into carry 
                    bcs      ds1w_txbit1 
ds1w_txbit0 
                    clr      T1HOC                        ; start timer 
                                                          ; long pulse low ~~\________/~~ 
                    ldb      #$df 
                    stb      DCNTRL                       ; PB6 direction = output 
                    ldb      #$40 
dstx0_loop 
                    bitb     IFLAG 
                    beq      dstx0_loop                   ; wait for end of time slot 
                    ldb      #$9f 
                    stb      DCNTRL                       ; PB6 direction = input 
                    dec      -1,sp 
                    bne      ds1w_txbits 
                    rts      

ds1w_txbit1 
                    clr      T1HOC                        ; start timer 
                                                          ; short pulse low ~~\_/~~~~~~~~~ 
                    ldb      #$df 
                    stb      DCNTRL                       ; PB6 direction = output 
                    ldb      #$9f 
                    stb      DCNTRL                       ; PB6 direction = input 
                    ldb      #$40 
dstx1_loop 
                    bitb     IFLAG 
                    beq      dstx1_loop                   ; wait for end of time slot 
                    dec      -1,sp 
                    bne      ds1w_txbits 
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
ds1w_rxbyte                                               ;#isfunction  
                    ldb      #$08                         ; bits in byte 
                    stb      -1,sp                        ; put loop counter 'above' stack 
ds1w_rxbits 
                    clr      T1HOC                        ; start timer 
                                                          ; short pulse low ~~\_xxxxxx~~~~ 
                    ldb      #$df 
                    stb      DCNTRL                       ; PB6 direction = output 
                    ldb      #$9f 
                    stb      DCNTRL                       ; PB6 direction = input 
                                                          ; read response 
                    nop                                   ; timing 
                    ldb      CNTRL                        ; read PB 
                    lslb                                  ; shift PB6... 
                    lslb                                  ; ...into carry... 
                    rora                                  ; ...and rotate into result byte 
                    ldb      #$40 
dsrx_loop 
                    bitb     IFLAG 
                    beq      dsrx_loop                    ; wait for end of time slot 
                    dec      -1,sp 
                    bne      ds1w_rxbits 
                    rts      

                    direct   -1 
