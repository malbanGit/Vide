;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
                    INCLUDE  "VECTREX.I"                  ; vectrex function includes
SCALE_DRAW          equ      $60 
SCALE_MOVE          equ      $20 
WIDTH               equ      $40 
XPOS                equ      -$40 
YPOS                equ      $7f 
delayReset          EQU      5 
delayReset_rm       EQU      6 
;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    BSS      
                    ORG      $c880                        ; start of our ram space 
sfx_pointer_1       ds       2 
sfx_status_1        ds       1 
sfx_pointer_2       ds       2 
sfx_status_2        ds       1 
sfx_pointer_3       ds       2 
sfx_status_3        ds       1 
delayCounter        ds       1 
animationCounter    ds       1 
SCROLL_RAM_START    =        animationCounter+1 
music_ram           equ      SCROLL_RAM_START+20 
cube_ram            equ      music_ram+10 
ym_ram              equ      music_ram 
;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    CODE     
                    ORG      0 
; the first few bytes are mandatory, otherwise the BIOS will not load
; the ROM file, and will start MineStorm instead
                    DB       "g GCE 2016", $80 ; 'g' is copyright sign
                    DW       music1                       ; music from the rom 
                    DB       $F8, $50, $20, -$80          ; hight, width, rel y, rel x (from 0,0) 
                    DB       "RASTER EXAMPLE UNI", $80    ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
start: 
                    lda      #WIDTH 
                    sta      Vec_Text_Width 
                    LDA      #delayReset 
                    STA      delayCounter 
                    CLR      animationCounter 
new_game: 
                    clra     
                    sta      plr_pattern 
                    jmp      loadmusic 

main: 
; mod
                    lda      Vec_Music_Flag 
                    beq      loadmusic 
                    jsr      DP_to_C8                     ; DP to RAM 
                    ldu      plr_geilmusik                ; get some music, here music1 
                    jsr      Init_Music_chk_mod           ; and init new notes 
; recal
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 
                    jsr      Do_Sound                     ; do actual sound loading to AY 
                    JSR      Intensity_7F                 ; Sets the intensity of the 
                    JSR      Read_Btns                    ; get button status 
                    CMPA     #$00                         ; is a button pressed? 
                    BNE      start_main2                  ; no, than go on 
                                                          ; vector beam to $5f 
; raster malban
                    LDA      #YPOS                        ; Text position relative Y 
                    LDB      #XPOS                        ; Text position relative X 
                    LDU      #C1_data 
                    JSR      draw_raster_image            ; Vectrex BIOS print routine 
; malban writing
                    ldu      #vData                       ; address of list 
                    LDA      #$7f                         ; Text position relative Y 
                    LDB      #-$0                         ; Text position relative X 
                    tfr      d,x                          ; in x position of list 
                    lda      #$40                         ; scale positioning 
                    ldb      #$20                         ; scale move in list 
                    jsr      draw_synced_list 
                    jsr      Reset0Ref 
;; cube
                    LDA      #$50                         ; scalefactor 
                    STA      VIA_t1_cnt_lo 
                    LDA      #-$70                        ; position relative Y 
                    LDB      #$00                         ; position relative X 
                    JSR      Moveto_d                     ; sets up VIA control register after a wait recal 
                    LDA      #$20                         ; scalefactor 
                    STA      VIA_t1_cnt_lo 
                    LDA      animationCounter             ; current animation frame 
                    ASLA                                  ; times two since it is a word pointer 
                    LDX      #AnimList                    ; address of data 
                    LDX      a,X 
                    JSR      Draw_VL_mode                 ; Vectrex BIOS print routine 
                    DEC      delayCounter 
                    BNE      main 
                    LDA      #delayReset 
                    STA      delayCounter 
                    INC      animationCounter 
                    LDA      animationCounter 
                    CMPA     #vDataLength 
                    BNE      main 
                    CLR      animationCounter 
                    BRA      main                         ; go back to main loop 

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

start_main2: 
; different ayfx setups
;; scroller setup
NORMAL_TEXT_SIZE    EQU      $F160                        ; big text that is 
SCALE_FACTOR_GAME   EQU      $80 
                    JSR      DP_to_C8 
             ;       direct   $C8 
                    LDD      #NORMAL_TEXT_SIZE            ; load default text height & width 
                    STD      Vec_Text_HW                  ; poke it to ram location 
                                                          ; just for show a little scroll text... 
                                                          ; scrolltext destroys a whole load of valuable 
                                                          ; ram space... 
                                                          ; had to use some ram twice... 
                    LDA      #-$70                        ; y position of scroller 
                    STA      scroll_y                     ; store it 
                    LDA      #-70                        ; left boundary 
                    STA      scroll_x_left                ; store it 
                    LDA      #70                         ; right boundary 
                    STA      scroll_x_right               ; store it 
                    LDA      #-1                          ; scroll speed (going from right to left) 
                    STA      scroll_speed                 ; store it 
                    LDA      #$7f                         ; and intensity of scroll text 
                    STA      scroll_intensity             ; store it 
                    LDX      #scroll_text 
                    jsr      set_up_scrolling 
 JSR      DP_to_D0 
 direct   $D0
;;;
; AYFX setup
                    ldu      #SONG_DATA 
                    JSR      init_ym_sound 
                    LDD      #$0000                       ; init sfx vars 
                    STD      sfx_pointer_1 
                    STA      sfx_status_1 
                    STD      sfx_pointer_2 
                    STA      sfx_status_2 
                    STD      sfx_pointer_3 
                    STA      sfx_status_3 
;; animation
                    LDA      #delayReset_rm 
                    STA      delayCounter 
                    CLR      animationCounter 
main2: 
                    jsr      unshadow_sound 
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 
                    JSR      Intensity_7F                 ; Sets the intensity of the 
                    jsr      do_one_scroll_step 
; animation playing
                    LDA      animationCounter             ; current animation frame 
                    ASLA                                  ; times two since it is a word pointer 
                    LDU      #rmData                      ; address of data 
                    LDU      a,U 
                    LDA      #$0                          ; Text position relative Y 
                    LDB      #-$0                         ; Text position relative X 
                    tfr      d,x                          ; in x position of list 
                    lda      #$80                         ; scale positioning 
                    ldb      #$18                         ; scale move in list 
                    JSR      draw_synced_list_rm          ; Vectrex BIOS print routine 
                    DEC      delayCounter 
                    BNE      main2_cont 
                    LDA      #delayReset_rm 
                    STA      delayCounter 
                    INC      animationCounter 
                    LDA      animationCounter 
                    CMPA     #rmDataLength 
                    BNE      main2_cont 
                    CLR      animationCounter 
main2_cont: 
                    JSR      do_ym_sound 
                    ldd      ym_data_current 
                    beq      start_main2                  ; loop default 
                    JSR      sfx_doframe 
                    JSR      Read_Btns                    ; get button status 
                    CMPA     #$01                         ; is a button pressed? 
                    BNE      nextbuttontest2              ; no, than go on 
                    LDX      #aleste_1_data               ; play sfx_effect 
                    STX      sfx_pointer_1 
                    LDA      #$01 
                    STA      sfx_status_1 
                    bra      main2 

nextbuttontest2: 
                    CMPA     #$02                         ; is a button pressed? 
                    BNE      nextbuttontest3              ; no, than go on 
                    LDX      #druid_5_data                ; play sfx_effect 
                    STX      sfx_pointer_2 
                    LDA      #$01 
                    STA      sfx_status_2 
                    bra      main2 

nextbuttontest3: 
                    CMPA     #$04                         ; is a button pressed? 
                    BNE      nextbuttontest4              ; no, than go on 
                    LDX      #nemesis_17_data             ; play sfx_effect 
                    STX      sfx_pointer_3 
                    LDA      #$01 
                    STA      sfx_status_3 
                    bra      main2 

nextbuttontest4: 
                    CMPA     #$08                         ; is a button pressed? 
                    beq      start 
                    bra      main2 

;***************************************************************************
; DATA SECTION
;***************************************************************************
                    include  "rasterDrawC1.asm"
                    include  "vectorDrawMalban.asm"
                    INCLUDE  "modPlayer.i"                ; vectrex function includes
                    INCLUDE  "popcorn-chip.asm"           ; vectrex function includes
                    INCLUDE  "Cube.asm"                   ; vectrex function includes
                    INCLUDE  "ymPlayer.i"                 ; vectrex function includes
                    INCLUDE  "Bitmap.asm"
                    include  "ayfxPlayer.i"
                    include  "aleste_1.asm"
                    include  "druid_5.asm"
                    include  "nemesis_17.asm"
                    include  "RunningMan.asm"
                    INCLUDE  "scrollerCode.asm"           ; vectrex function includes
scroll_text: 
                    DB       "THIS IS A SCROLLTEXT DONE BY MALBAN. THE SCROLLTEXT SCROLLS TILL IT GETS ALL DIZZY.  0  .  0  .  0  .  0       ...", $80
