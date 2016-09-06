;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
                    INCLUDE  "VECTREX.I"                  ; vectrex function includes
                    INCLUDE  "drawMACRO.i"                ; vectrex function includes
;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    BSS      
                    ORG      $c880                        ; start of our ram space 
SCROLL_RAM_START    =        $c880 
SCALE_FACTOR_GAME=$60 
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
                    DB       "SCROLLING", $80             ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
NORMAL_TEXT_SIZE    EQU      $F160                        ; big text that is 
                    JSR      DP_to_C8 
                    direct   $C8 
                    LDD      #NORMAL_TEXT_SIZE            ; load default text height & width 
                    STD      Vec_Text_HW                  ; poke it to ram location 
                                                          ; just for show a little scroll text... 
                                                          ; scrolltext destroys a whole load of valuable 
                                                          ; ram space... 
                                                          ; had to use some ram twice... 
                    LDA      #-$70                        ; y position of scroller 
                    STA      scroll_y                     ; store it 
                    LDA      #-100                        ; left boundary 
                    STA      scroll_x_left                ; store it 
                    LDA      #100                         ; right boundary 
                    STA      scroll_x_right               ; store it 
                    LDA      #-1                          ; scroll speed (going from right to left) 
                    STA      scroll_speed                 ; store it 
                    LDA      #$60                         ; and intensity of scroll text 
                    STA      scroll_intensity             ; store it 
                    LDX      #hello_world_string 
                    jsr      set_up_scrolling 
main1 
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                                                          ; vector beam to $5f 
                    JSR      DP_to_D0 

                    jsr      do_one_scroll_step 
                    bra      main1 

hello_world_string: 
                    DB       "THIS IS A SCROLLTEXT DONE BY MALBAN. THE SCROLLTEXT SCROLLS TILL IT GETS AL DIZZY. 0 . 0 . 0 . 0...", $80
                    INCLUDE  "scrollerCode.asm"           ; vectrex function includes
