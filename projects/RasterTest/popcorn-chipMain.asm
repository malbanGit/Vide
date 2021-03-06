;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
                    INCLUDE  "VECTREX.I"                  ; vectrex function includes
music_ram           equ      $c880 
;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    BSS      
                    ORG      $c880                        ; start of our ram space 
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
                    DB       "PLAY MOD", $80              ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
                    clra     
                    sta      plr_pattern 
                    jmp      loadmusic 

main: 
                    lda      Vec_Music_Flag 
                    beq      loadmusic 
                    jsr      DP_to_C8                     ; DP to RAM 
                    ldu      plr_geilmusik                ; get some music, here music1 
                    jsr      Init_Music_chk_mod               ; and init new notes 
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 

        jsr   Do_Sound			; do actual sound loading to AY

                    JSR      Intensity_5F                 ; Sets the intensity of the 
                                                          ; vector beam to $5f 
                    LDU      #hello_world_string          ; address of string 
                    LDA      #$10                         ; Text position relative Y 
                    LDB      #-$50                        ; Text position relative X 
                    JSR      Print_Str_d                  ; Vectrex BIOS print routine 
                    BRA      main                         ; and repeat forever 

loadmusic: 
                    lda      #1 
                    sta      Vec_Music_Flag 
                    lda      plr_pattern 
                    inc      plr_pattern 
                    cmpa     #songLength 
                    bne      plr_cnt 
                    lda      #loopPosition                ;; load pattern to loop from 
                    sta      plr_pattern 
                    inc      plr_pattern 
plr_cnt: 
                    ldx      #script 
                    ldb      #2 
                    mul      
                    ldy      d,x 
                    sty      plr_geilmusik 
                    bra      main 

;***************************************************************************
; DATA SECTION
;***************************************************************************
hello_world_string: 
                    DB       "POPCORN-CHIP"                   ; only capital letters
                    DB       $80                          ; $80 is end of string 
;***************************************************************************
                    INCLUDE  "modPlayer.i"                 ; vectrex function includes
                    INCLUDE  "popcorn-chip.asm"                  ; vectrex function includes
