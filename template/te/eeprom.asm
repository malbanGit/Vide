;***************************************************************************
; DEFINE SECTION
;***************************************************************************
    setdp $d0               ; DP to D0 is default for the entire game

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

; EEPROM constants
EEPROM_CHECKSUM     equ     $87             ; any value other than $00 or $e0

    if USE_DS2431
EEPROM_STORESIZE    equ     48              ; DS2431 - multiple of 8
    else
EEPROM_STORESIZE    equ     32              ; DS2430
    endif

    if PHYSICAL_CART
        if !TEST_CART

; family code 14h for DS2430A, 2Dh for DS2431

; xx xx xx xx xx xx xx xx
; 14 9C AF       00 00 0E
DS1W_READ_ROM   equ $33

eeprom_buffer           equ ramstring

    if DETECT_EEPROM
        ; debug code
eeprom_identify
        ldx     #hiscore_decoded_table
        clra
        clrb
        std     ,x
        std     2,x
        std     4,x
        std     6,x
        lda     #8              ; number of bytes to load (loop counter)
        pshs    d,x             ; stack used registers

        jsr     ds1w_open       ; open 1-wire port

        jsr     ds1w_reset      ; reset device
        bmi     eeprom_identify_exit     ; exit if no device present

        lda     #DS1W_READ_ROM
        jsr     ds1w_txbyte

eeprom_identify_loop
        jsr     ds1w_rxbyte     ; read byte from ROM
        sta     ,x+             ; save to ram
        dec     ,s              ; decrement loop counter
        bne     eeprom_identify_loop     ; until all bytes are read

eeprom_identify_exit
        jsr     ds1w_close      ; close port
        puls    d,x,pc          ; restore registers from stack and return
    endif   ;DETECT_EEPROM

eeprom_load
        ldx     #eeprom_buffer          ;
    if USE_DS2431
        jsr     ds2431_load             ; load 48 byte eeprom data to ram
    else
        jsr     ds2430_load             ; load 32 byte eeprom data to ram
    endif
        ldd     #EEPROM_STORESIZE
eeload_loop                             ;
        adda    ,x+                     ; sum the bytes
        decb                            ;
        bne     eeload_loop             ;

        cmpa    #EEPROM_CHECKSUM        ; equal to checksum?
        bne     eeprom_nothing_loaded
        ldx     #eeprom_buffer
    if USE_DS2431
        ldb     #40
    else
        ldb     #30
    endif
        ldu     #hiscore_encoded_table
eeprom_loaded
        lda     ,x+
        sta     ,u+
        decb
        bne     eeprom_loaded
        lda     ,x
        sta     options
eeprom_nothing_loaded
    if USE_MUSIC
        jsr     ds2431_hide
    endif
        rts                             ; otherwise, return

StoreOptionsOnly
        clr     store_everything_flag
        bra     StoreOptionsOnly2
StoreHiscoreAndOptions
        ldb     #1
        stb     store_everything_flag
StoreOptionsOnly2
        ldx     #hiscore_encoded_table
        ldu     #eeprom_buffer
    if USE_DS2431
        ldb     #40
    else
        ldb     #30
    endif
StoreHiscoreAndOptionsCopy
        lda     ,x+
        sta     ,u+
        decb
        bne     StoreHiscoreAndOptionsCopy
        lda     options                 ; options at the back so that
        sta     ,u                      ; an options change only results in 8 bytes to store
eeprom_save
        ldx     #eeprom_buffer
        ldd     #(EEPROM_CHECKSUM<<8)+EEPROM_STORESIZE-1
eesave_loop
        suba    ,x+                     ; create checksum byte
        decb
        bne     eesave_loop
        sta     ,x

        ldx     #eeprom_buffer          ;
    if USE_DS2431
        bra     ds2431_save
    else
        jsr     ds2430_verify           ; compare ram to eeprom
        tsta                            ;
        bne     ds2430_save             ; if different, then update eeprom
        rts
    endif


    if USE_DS2431
        include "INC/ds2431ls.i"
    else
        include "INC/ds2430ls.i"
        include "INC/ds2430v.i"
    endif
        include "INC/ds1w.i"

        endif   ; if !TEST_CART
    endif   ; if PHYSICAL_CART

;***************************************************************************
; CODE SECTION
;***************************************************************************
