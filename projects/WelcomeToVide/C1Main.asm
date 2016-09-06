;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
                    INCLUDE  "VECTREX.I"                  ; vectrex function includes
SCALE_MOVE          equ      $20 
XPOS                equ      -$60 
YPOS                equ      $7f 
VOX_DONE            EQU      1 
VOX_STARTED         EQU      2 
VOX_STARTING        EQU      3 
;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    BSS      
                    ORG      $c880                        ; start of our ram space 
voxStart            equ      $c880 
scrollRestart       equ      $c881 
scrollRestart_last  equ      $c882 
turtle_visible      equ      $c883 
SCROLL_RAM_START    =        $c884 
music_ram           equ      SCROLL_RAM_START+20 
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
                    DB       "VIDE GREETINGS", $80        ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
start: 
                    jsr      vox_init                     ; VecVox: initialize variables 
NORMAL_TEXT_SIZE    EQU      $F160                        ; big text that is 
SCALE_FACTOR_GAME   EQU      $80 
                    JSR      DP_to_C8 
                    direct   $C8                          ; direct $C8 
                    LDD      #NORMAL_TEXT_SIZE            ; load default text height & width 
                    STD      Vec_Text_HW                  ; poke it to ram location 
                    LDA      #-$70                        ; y position of scroller 
                    STA      scroll_y                     ; store it 
                    LDA      #-70                         ; left boundary 
                    STA      scroll_x_left                ; store it 
                    LDA      #70                          ; right boundary 
                    STA      scroll_x_right               ; store it 
                    LDA      #-2                          ; scroll speed (going from right to left) 
                    STA      scroll_speed                 ; store it 
                    LDA      #$7f                         ; and intensity of scroll text 
                    STA      scroll_intensity             ; store it 
                    LDX      #scroll_text 
                    jsr      set_up_scrolling 
                    JSR      DP_to_D0 
                    direct   $D0 
                    clr      scrollRestart_last 
                    lda      #VOX_STARTING 
                    sta      voxStart 
startYM: 
                    ldu      #SONG_DATA 
                    JSR      init_ym_sound 
main: 
                    lda      voxStart 
                    cmpa     #VOX_STARTING 
                    bne      noVoxStart 
                    lda      #VOX_STARTED 
                    sta      voxStart 
                    clr      turtle_visible 
                    ldx      #speechData 
                    stx      vox_addr                     ; start speaking demo_string4 
noVoxStart: 
                    ldd      ym_data_current 
                    beq      startYM                      ; loop default 
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 
                    JSR      Intensity_7F                 ; Sets the intensity of the 
                    clr      scrollRestart 
                    jsr      do_one_scroll_step 
                    lda      scrollRestart 
                    eora     scrollRestart_last 
                    beq      norestartscroll 
                    lda      scrollRestart 
                    beq      norestartscroll 
                    ldb      #VOX_STARTING 
                    stb      voxStart 
norestartscroll: 
                    lda      scrollRestart 
                    sta      scrollRestart_last 
                                                          ; vector beam to $5f 
                    JSR      do_ym_sound 
                    LDA      #YPOS                        ; Text position relative Y 
                    LDB      #XPOS                        ; Text position relative X 
                    LDU      #C1_data 
                    JSR      draw_raster_image            ; Vectrex BIOS print routine 
                    tst      turtle_visible 
                    bne      no_hush 
                    jsr      hushNow 
no_hush 
                    jsr      unshadow_sound 
                    jsr      Read_Btns                    ; read joystick buttons 
                    jsr      vox_speak                    ; VecVox: output speech data 
                    bra      main 

hushNow: 
                    ldu      #Vec_Snd_Shadow 
                    lda      8,u 
 suba #3
 bmi nostore1
                    sta      8,u 
nostore1
                    lda      9,u 
 suba #3
 bmi nostore2
                    sta      9,u 
nostore2
                    lda      10,u 
 suba #3
 bmi nostore3
                    sta      10,u 
nostore3
                    rts      
hushNow2: 
                    ldu      #Vec_Snd_Shadow 
                    lda      8,u 
                    lsra     
                    sta      8,u 
                    lda      9,u 
                    lsra     
                    sta      9,u 
                    lda      10,u 
                    lsra     
                    sta      10,u 
                    rts      

;***************************************************************************
; DATA SECTION
;***************************************************************************
                    include  "rasterDrawC1.asm"
                    INCLUDE  "ymPlayer.i"                 ; vectrex function includes
                    INCLUDE  "BRAT.asm"
                    INCLUDE  "scrollerCode.asm"           ; vectrex function includes
; Vec Vox routines
                    INCLUDE  "VECVOX.I"                   ; VecVox output routines
;
; Speech strings
                    INCLUDE  "speechData.i"               ; vectrex function includes
scroll_text: 
                    DB       "WELCOME TO VIDE THE VECTREX INTEGRATED DEVELOPMENT ENVIRONMENT.  0    0    0    0                                                                                                         ", $80
