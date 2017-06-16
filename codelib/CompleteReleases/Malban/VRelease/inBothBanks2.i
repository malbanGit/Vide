; this file is part of Release, written by Malban in 2017
;
; org $7cc8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
START_OF_LAST_MEM   ds       0 
first_init:                                               ;#isfunction  
                    direct   $d0 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; persistency stuff start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    lda      Vec_Loop_Count+1 
                    sta      RecalCounterLow 
                    jsr      Random 
                    sta      my_random2 
                    jsr      Random 
                    sta      my_random 
                    ldd      #phaseList                   ;+10*2 
                    std      initialPhase 
                    clr      musicOption                  ; play music (0 = play, !=0 not play) 
                    clr      ignoreDs2431                 ; we assume a eEprom is available 
                    bsr      copyDefaultsToRAM 
; check if we should ignore eEprom completly (Button press on startup)
                    JSR      Read_Btns                    ; get button status 
                    CMPA     #$00                         ; is a button pressed? 
                    if       USE_PB6 = 1 
                    beq      noignore 
                    else     
                    nop      2 
                    endif    
                    inc      ignoreDs2431                 ; yes, than set ignore flag 
noignore 
                    ldx      v4eStorageLoaded             ; check if v4e did load bytes from storage area 
                    bne      noScoreDefaults              ; if != 0, than yes -> jump 
                    lda      v4ecartflags                 ; check if there is any v4e at all? 
                    bpl      nov4e                        ; if not (positive) jump 
; first time vec4 rom init
                    jsr      COPY_RAM_TO_VECROM           ; otherwise fill the (usual) ROM with default values (v4e this is RAM to!) 
nov4e 
noScoreDefaults 
                    jsr      checkEprom                   ; is there an eprom (ignore flag always checked in eeprom routines) 
                                                          ; eprom saves valus in three stages, to keep times smaller (when only block save is needed) 
                    ldd      #(EEPROM_STORESIZE_OPTIONS*256)+EEPROM_OPTION_BLOCK 
                    std      current_eprom_blocksize 
                    ldx      #optionsBlock 
                    jsr      eeprom_load_option           ; load eprom data (also resets if no data found) 
                    lda      v4ecartflags                 ; check if there is any v4e at all? 
                    bmi      donotSaveagain               ; if yes, than don't save the same stuff 2 times, poor Flash... 
                    ldd      #(EEPROM_STORESIZE_HS*256)+EEPROM_HS1_BLOCK 
                    std      current_eprom_blocksize 
                    ldx      #highScoreBlock 
                    jsr      eeprom_load_highscore        ; load eprom data (also resets if no data found) 
donotSaveagain 
                    jmp      start_cart 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; persistency stuff end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
copyDefaultsToRAM:                                        ;#isfunction  
                    ldu      #defaultValuesEeprom         ; copy the vec4ever switching function into place 
                    ldx      #v4e_saveBlockStart 
                    lda      #1+v4e_saveBlockEnd - v4e_saveBlockStart 
                    jsr      Move_Mem_a 
                    rts      

;***************************************************************************
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ensureBank0
; rts
;                    ldd      #$DFFF                       ; Prepare DDR Registers % 1101 1111 1111 1111 
;                    std      >VIA_DDR_b                   ; all ORB/ORA to output except ORB 5, PB6 goes LOW 
;                                                          ; RESET to sensible values
;                    ldd      #$0100                       ; A = $01, B = 0 
;                    std      >VIA_port_b                  ; ORB = $1 (ramp on, mux off), ORA = 0 (DAC) 
;                    ldd      #$987F                       ; A= $98, B = $7F 
;                    sta      >VIA_aux_cntl                ; Standard AUX Cont = $98, T1 One shot mode with control of ramp 
;                    stb      >VIA_t1_cnt_lo               ; Timer = $7f, RAMP On, after timer expires ramp off 
; rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ensureBank1
; rts
;                    ldd      #$9FFF                       ; Prepare DDR Registers % 1001 1111 1111 1111 
;                    std      >VIA_DDR_b                   ; all ORB/ORA to output except ORB 5, PB6 goes LOW 
;                                                          ; RESET to sensible values
;                    ldd      #$0100                       ; A = $01, B = 0 
;                    std      >VIA_port_b                  ; ORB = $1 (ramp on, mux off), ORA = 0 (DAC) 
;                    ldd      #$987F                       ; A= $98, B = $7F 
;                    sta      >VIA_aux_cntl                ; Standard AUX Cont = $98, T1 One shot mode with control of ramp 
;                    stb      >VIA_t1_cnt_lo               ; Timer = $7f, RAMP On, after timer expires ramp off 
; rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;toOtherBank
;    if CURRENT_BANK=2
; bra ensureBank0
; else 
; bra ensureBank1
; endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;***************************************************************************
                    INCLUDE  "eprom.i"
;***************************************************************************
goback                                                    ;#isfunction  
ramfunction         equ      object_list                  ; $c900 place of our ram function destination 
;
;   Immediately back to menu
;
                    ldu      #ramfunctiondata             ; copy the vec4ever switching function into place 
                    ldx      #ramfunction 
                    lda      #1+ramfuncend-ramfunctiondata 
                    jsr      Move_Mem_a 
                    ldx      #$1000                       ; the 'switch back to menu' command 
                    jmp      ramfunction                  ; up up and away 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
COPY_RAM_TO_VECROM                                        ;#isfunction  
                    ldu      #v4e_saveBlockStart          ; Source copy the vec4ever switching function into place 
                    ldx      #vec4SaveBuffer              ; destination 
                    lda      #1+(v4e_saveBlockEnd-v4e_saveBlockStart) 
                    jmp      Move_Mem_a 

store_score                                               ;#isfunction  
                    bsr      COPY_RAM_TO_VECROM 
                    ldu      #StoreHiscoreFnc             ; copy the vec4ever switching function into place 
                    ldx      #ramfunction 
                    lda      #1+StoreHiscoreFncEnd-StoreHiscoreFnc 
                    jsr      Move_Mem_a 
                    ldx      #$4000                       ; the 'store data' command 
                    jmp      ramfunction                  ; up up and away 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; the function below does the magic handshake with the cart,
; then waits for the new cart data to appear in the cart address
; space and jumps back to the v4e cart
;
StoreHiscoreFnc                                           ;#isfunction  
                    lda      $7ff0                        ; notify v4e 
                    lda      ,x                           ; and put command on the bus 
                    ldd      # "g "
v4eloop             cmpd     $0                           ; while the cart is working there is only one data byte 
                    bne      v4eloop                      ; header just in case 
                    rts      

StoreHiscoreFncEnd 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; the function below does the magic handshake with the cart,
; then waits for the new cart data to appear in the cart address
; space and jumps back to the menu
;
ramfunctiondata                                           ;#isfunction  
                    ldb      $7ff0                        ; notify the cart uProc 
                    ldb      ,x                           ; put command on the bus 
                    ldx      #0 
                    ldd      # "g "
ramloop             cmpd     0,x                          ; while the cart is setting up itself there is only one data byte 
                    bne      ramloop                      ; available, so check for .two. known and different ones 
                    leax     $D,x                         ; 0-A: "GCE xxxx",$80 / B+C: music pointer (could contain a zero..) 
ramloop2            lda      ,x+                          ; look for end of menu cart header 
                    bne      ramloop2 
                    tfr      x,pc                         ; return to menu code data 
ramfuncend 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
vec4SaveBuffer:                                           ;#isfunction  
                    ds       (v4e_saveBlockEnd-v4e_saveBlockStart) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PADDBYTES:          ds       131                          ; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
vec4Register:                                             ;#isfunction  
                    ds       16 
END_OF_MEM          ds       0 
