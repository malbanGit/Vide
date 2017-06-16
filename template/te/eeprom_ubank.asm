;***************************************************************************
; DEFINE SECTION
;***************************************************************************
    setdp $d0               ; DP to D0 is default for the entire game

; PIA Registers

    if PHYSICAL_CART
        if !TEST_CART

        org     eeprom_load+$8000

eeprom_loadU
        ldx     #eeprom_buffer          ;
    if USE_DS2431
        jsr     ds2431_load             ; load 48 byte eeprom data to ram
    else
        jsr     ds2430_load             ; load 32 byte eeprom data to ram
    endif
        ldd     #EEPROM_STORESIZE
eeload_loopU                             ;
        adda    ,x+                     ; sum the bytes
        decb                            ;
        bne     eeload_loopU             ;

        cmpa    #EEPROM_CHECKSUM        ; equal to checksum?
        bne     eeprom_nothing_loadedU
        ldx     #eeprom_buffer
    if USE_DS2431
        ldb     #40
    else
        ldb     #30
    endif
        ldu     #hiscore_encoded_table
eeprom_loadedU
        lda     ,x+
        sta     ,u+
        decb
        bne     eeprom_loadedU
        lda     ,x
        sta     options
eeprom_nothing_loadedU
    if USE_MUSIC
        jsr     ds2431_hide
    endif
        rts                             ; otherwise, return

StoreOptionsOnlyU
        clr     store_everything_flag
        bra     StoreOptionsOnly2U
StoreHiscoreAndOptionsU
        ldb     #1
        stb     store_everything_flag
StoreOptionsOnly2U
        ldx     #hiscore_encoded_table
        ldu     #eeprom_buffer
    if USE_DS2431
        ldb     #40
    else
        ldb     #30
    endif
StoreHiscoreAndOptionsCopyU
        lda     ,x+
        sta     ,u+
        decb
        bne     StoreHiscoreAndOptionsCopyU
        lda     options                 ; options at the back so that
        sta     ,u                      ; an options change only results in 8 bytes to store
eeprom_saveU
        ldx     #eeprom_buffer
        ldd     #(EEPROM_CHECKSUM<<8)+EEPROM_STORESIZE-1
eesave_loopU
        suba    ,x+                     ; create checksum byte
        decb
        bne     eesave_loopU
        sta     ,x

        ldx     #eeprom_buffer          ;
    if USE_DS2431
        bra     ds2431_saveU
    else
        jsr     ds2430_verify           ; compare ram to eeprom
        tsta                            ;
        bne     ds2430_save             ; if different, then update eeprom
        rts
    endif


    if USE_DS2431
        include "INC/ds2431ls_ubank.i"
    else
        include "INC/ds2430ls.i"
        include "INC/ds2430v.i"
    endif
        include "INC/ds1w_ubank.i"

        endif   ; if !TEST_CART
    endif   ; if PHYSICAL_CART

;***************************************************************************
; CODE SECTION
;***************************************************************************
