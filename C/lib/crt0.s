;
;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    CODE     
                    ORG      0 
; the first few bytes are mandatory, otherwise the BIOS will not load
; the ROM file, and will start MineStorm instead
                    DB       "g GCE VIDE", $80 ; 'g' is copyright sign
                    DW       music1                       ; music from the rom 
                    DB       $F8, $50, $20, -$30          ; hight, width, rel y, rel x (from 0,0) 
release_string 
                    DB       "VIDE-C", $80               ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
                    
                    