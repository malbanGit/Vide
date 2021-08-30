CURRENT_BANK        EQU      2                            ; 
                    Bank     2 
                    include  "commonGround.i"
; following is needed for VIDE
; to replace "vars" in this bank with values from the other bank
; #genVarlist# varFromBank2
;
;***************************************************************************
; CODE SECTION
;***************************************************************************
printBankString 
                    LDU      #bank_string                 ; address of string 
                    LDA      #$00                         ; Text position relative Y 
                    LDB      #0                           ; Text position relative X 
                    JSR      Print_Str_d                  ; Vectrex BIOS print 
                    rts      

;***************************************************************************
bank_string: 
                    DB       "BANK 2"                     ; only capital letters
                    DB       $80                          ; $80 is end of string 
