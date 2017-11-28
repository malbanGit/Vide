;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
Wait_Recal          EQU      $F192                        ; 
DP_to_C8            EQU      $F1AF                        ; 
Read_Btns           EQU      $F1BA                        ; 
Do_Sound            EQU      $F289                        ; 
Intensity_5F        EQU      $F2A5                        ; 
Print_Str_d         EQU      $F37A                        ; 
Explosion_Snd       EQU      $F92E                        ; 
Vec_Expl_Flag       EQU      $C867                        ;Explosion_Snd initialization flag 
Vec_Expl_Timer      EQU      $C877                        ;Used by Explosion_Snd 
;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    CODE     
                    ORG      0 
; the first few bytes are mandatory, otherwise the BIOS will not load
; the ROM file, and will start MineStorm instead
                    DB       "g GCE 2017", $80 ; 'g' is copyright sign
                    DW       noMusic                      ; music from the rom 
                    DB       $F8, $50, $20, -$80          ; hight, width, rel y, rel x (from 0,0) 
                    DB       "EXPLOSION", $80             ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
main: 
                    jsr      DP_to_C8                     ; DP to RAM 
                    jsr      Explosion_Snd                ; 
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 
                    jsr      Do_Sound                     ; this actually plays the sound 
                    JSR      Intensity_5F                 ; Sets the intensity of the vector beam to $5f 
                    LDU      #hello_world_string          ; address of string 
                    LDd      #$10B0                       ; Text position relative Y , x 
                    JSR      Print_Str_d                  ; Vectrex BIOS print routine 
                    JSR      Read_Btns                    ; get one status first, for BRA main ; and repeat forever 
                    tsta                                  ; is a button pressed? 
                    BEQ      main                         ; no, than go on 
                    lda      #-1                          ; high bit set by any negative number 
                    sta      Vec_Expl_Flag                ; set high bit for Explosion flag 
                    ldu      #explosionData               ; point to explosion table entry 
                    bra      main 

;***************************************************************************
; DATA SECTION
;***************************************************************************
hello_world_string: 
                    DB       "EXPLOSION BUTTON"         ; only capital letters
                    DB       $80                          ; $80 is end of string 
;***************************************************************************
noMusic: 
                    dw       0,0 
                    db       1,255 

