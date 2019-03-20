;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
                    INCLUDE  "VECTREX.I"                  ; vectrex function includes
;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    BSS      
                    ORG      $c880                        ; start of our ram space 
; bidirectional RAM needs
buffer              EQU      $c888                        ; 
Vec_Text_Width_neg  EQU      buffer                       ; variable used in own printing routines 
print_space         EQU      Vec_Text_Width_neg+2         ; buffer for draw numbers 
;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    CODE     
                    ORG      0 
; the first few bytes are mandatory, otherwise the BIOS will not load
; the ROM file, and will start MineStorm instead
                    DB       "g GCE 1998", $80 ; 'g' is copyright sign
                    DW       music1                       ; music from the rom 
                    DB       $F8, $50, $20, -$80          ; hight, width, rel y, rel x (from 0,0) 
                    DB       "NEW PROG", $80              ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
main: 
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                                                          ; vector beam to $5f 
                    lda      #$20 
                    sta      Vec_Text_Width 
                    lda      #-$3 
                    sta      Vec_Text_Height 
                    LDU      #hello_world_string          ; address of string 
                    LDA      #$50                         ; Text position relative Y 
                    LDB      #-$70                        ; Text position relative X 
                    JSR      Print_Str_d                  ; Vectrex BIOS print routine 10486 cycles
;
;
                    JSR      Reset0Ref 
                    JSR      Delay_3 
                    LDU      #hello_world_string_bi       ; address of string 
                    LDA      #$00                         ; Text position relative Y 
                    LDB      #-$70                        ; Text position relative X 
                    JSR      my_Print_Str_d               ; Vectrex BIOS print routine 6209 cycles
;
                 LDA     #$7F
                 STA     VIA_t1_cnt_lo
                    JSR      Reset0Ref 
                    JSR      Delay_3 
; height of string is determined by scale factor!
                    LDU      #hello_world_string          ; address of string 
                    LDA      #-$50                        ; Text position relative Y 
                    LDB      #-$70                        ; Text position relative X 
                    JSR      sync_Print_Str_d             ; Vectrex BIOS print routine 
                    BRA      main                         ; and repeat forever 

;***************************************************************************
; DATA SECTION
;***************************************************************************
hello_world_string: 
                    DB       "HELLO WORLD THIS IS A WONDERFUL DAY" ; only capital letters
                    DB       $80                          ; $80 is end of string 
hello_world_string_bi: 
                    DB       $81                          ; $80 is end of string 
                    DB       "HELLO WORLD THIS IS A WONDERFUL DAY" ; only capital letters
                    DB       $81                          ; $80 is end of string 
;***************************************************************************
                    include  "PRINT_BI.I"                 ; routines for my printing...
                    include  "PRINT_sync.I"               ; routines for my printing...
