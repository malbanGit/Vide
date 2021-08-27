;***************************************************************************
;
; all banks start with this!
;
;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
                    BSS      
                    ORG      $c800 
                    INCLUDE  "inAllBanks.i"               ; RAM and defines
;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    CODE     
                    ORG      0 
; for dissi compatability I leave the header in for now!
; the first few bytes are mandatory, otherwise the BIOS will not load
; the ROM file, and will start MineStorm instead
                    DB       "g GCE 2021", $80 ; 'g' is copyright sign
                    DW       music1                       ; music from the rom 
                    DB       $F8, $50, $20, -$48          ; hight, width, rel y, rel x (from 0,0) 
                    DB       "4 BANK TEST", $80           ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
                    direct   $d0 
                    jmp      main 

                    direct   $d0 
;
; .....................................................
;
jmpBank0_T1 
                    IRQ_TO_0_T1  
                    PB6_TO_0  
                    jmp      ,x 

;...........
jmpBank1_T1 
                    IRQ_TO_0_T1  
                    PB6_TO_1  
                    jmp      ,x 

;...........
jmpBank0_Shift 
                    IRQ_TO_0_SHIFT  
                    PB6_TO_0  
                    jmp      ,x 

;...........
jmpBank1_Shift 
                    IRQ_TO_0_SHIFT  
                    PB6_TO_1  
                    jmp      ,x 

;...........
jmpBank2 
                    IRQ_TO_1  
                    PB6_TO_0  
                    jmp      ,x 

;...........
jmpBank3 
                    IRQ_TO_1  
                    PB6_TO_1  
                    jmp      ,x 

;...........
jsrBank3to0T1 
                    IRQ_TO_0_T1  
                    PB6_TO_0  
                    jsr      ,x 
                    PB6_TO_1  
                    IRQ_TO_1  
                    rts      

;...........
jsrBank3to0_Shift 
                    IRQ_TO_0_SHIFT  
                    PB6_TO_0  
                    jsr      ,x 
                    PB6_TO_1  
                    IRQ_TO_1  
                    rts      

;...........
jsrBank2to0_T1 
; PB6 stays
                    IRQ_TO_0_T1  
                    jsr      ,x 
                    IRQ_TO_1  
                    rts      

;...........
jsrBank2to0_Shift 
; PB6 stays
                    IRQ_TO_0_SHIFT  
                    jsr      ,x 
                    IRQ_TO_1  
                    rts      

;...........
jsrBank1to0 
jsrBank3to2 
                    PB6_TO_0  
                    jsr      ,x 
                    PB6_TO_1  
                    rts      

;...........
jsrBank0to1 
jsrBank2to3 
                    PB6_TO_1  
                    jsr      ,x 
                    PB6_TO_0  
                    rts      

;...........
jsrBank3to1T1 
                    IRQ_TO_0_T1  
                    jsr      ,x 
                    IRQ_TO_1  
                    rts      

;...........
jsrBank3to1_Shift 
                    IRQ_TO_0_SHIFT  
                    jsr      ,x 
                    IRQ_TO_1  
                    rts      

;...........
jsrBank2to1T1 
                    IRQ_TO_0_T1  
                    PB6_TO_1  
                    jsr      ,x 
                    PB6_TO_0  
                    IRQ_TO_1  
                    rts      

;...........
jsrBank2to1_Shift 
                    IRQ_TO_0_SHIFT  
                    PB6_TO_1  
                    jsr      ,x 
                    PB6_TO_0  
                    IRQ_TO_1  
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main 
