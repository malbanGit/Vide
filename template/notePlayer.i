;***************************************************************************
; The cartridge ROM starts at address 0
                    CODE     
                    ORG      0 
; the first few bytes are mandatory, otherwise the BIOS will not load
; the ROM file, and will start MineStorm instead
                    DB       "g GCE 2017", $80 ; 'g' is copyright sign
                    DW       adsr_notes                   ; music from the rom 
title: 
                    DB       $F8, $50, $20, -$80          ; hight, width, rel y, rel x (from 0,0) 
                    DB       "MUSIC PLAY", $80            ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
main: 
                    BRA      main                         ; and repeat forever 

;***************************************************************************
; DATA SECTION
;***************************************************************************