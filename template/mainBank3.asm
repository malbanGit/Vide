CURRENT_BANK        EQU      3                            ; 
                    Bank     3 
                    include  "commonGround.i"
; following is needed for VIDE
; to replace "vars" in this bank with values from the other bank
; #genVarlist# varFromBank3
;
;***************************************************************************
; CODE SECTION
;***************************************************************************
; NOTE!
; the PrintStr_d in the other banks subroutines
; use BIOS routines, which (inherently) also switch banks!
; (since they use SHIFT and T1 timer of VIA, and thus also change the Interrupt flag)
;
; in this example this is "ok", since the interrupt flags upon
; entering and exiting the BIOS functions are equal
; and so they "return" to the correct banks!
;
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                                                          ; vector beam to $5f 
                    jsr      printBankString 
REPLACE_1_2_printBankString_varFromBank0_1 
                    ldx      #0 
                    jsr      jsrBank3to0T1 
REPLACE_1_2_printBankString_varFromBank1_1 
                    ldx      #0 
                    jsr      jsrBank3to1T1 
REPLACE_1_2_printBankString_varFromBank2_1 
                    ldx      #0 
                    jsr      jsrBank3to2 
                    BRA      main                         ; and repeat forever 

;***************************************************************************
printBankString: 
                    LDU      #bank_string                 ; address of string 
                    LDA      #-$30                        ; Text position relative Y 
                    LDB      #0                           ; Text position relative X 
                    JSR      Print_Str_d                  ; Vectrex BIOS print 
                    rts      

;***************************************************************************
bank_string: 
                    DB       "BANK 3"                     ; only capital letters
                    DB       $80                          ; $80 is end of string 
