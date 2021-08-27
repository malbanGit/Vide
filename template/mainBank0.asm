CURRENT_BANK        EQU      0                            ; 
                    Bank     0 
                    include  "commonGround.i"
; following is needed for VIDE
; to replace "vars" in this bank with values from the other bank
; #genVarlist# varFromBank0
;
;***************************************************************************
; CODE SECTION
;***************************************************************************
printBankString 
                    LDU      #bank_string                 ; address of string 
                    LDA      #$60                         ; Text position relative Y 
                    LDB      #0                           ; Text position relative X 
                    JSR      Print_Str_d                  ; Vectrex BIOS print 
                    rts      

;***************************************************************************
bank_string: 
                    DB       "BANK 0"                     ; only capital letters
                    DB       $80                          ; $80 is end of string 
