; bank switch routine must reside in RAM
; at least with my tests it didn't work while in ROM (FLASH)
; for this demo, each button advances bank by one,
; bank = (bank + 1 ) % maxBank
                    inc      bankToSwitchTo               ; advance one bank 
                    lda      bankToSwitchTo               ; load value 
                    cmpa     #BANK_MAX                    ; compare to max bank 
                    bne      noMax                        ; if not max - go on 
                    clr      bankToSwitchTo               ; otherwise reset bank counter 
                    inc      bankToSwitchTo               ; start with ONE 
noMax: 
; following routine sets the bank to the bankNo in "bankToSwitchTo"
                    lda      #switchRoutineROMEnd - switchRoutineROMStart ; length of routine ($15) 
                    ldx      #switchRoutineROMStart       ; load start addresses 
                    ldy      #switchRoutineRAMStart 
                    inca                                  ; +1, since we stop at 0 
copyram:            ldb      ,x+                          ; load rom value 
                    stb      ,y+                          ; write to ram 
                    deca                                  ; till finished 
                    bne      copyram 
                    lda      bankToSwitchTo               ; load next bank value 
                    jmp      switchRoutineRAMStart        ; and jump to ram routine 


; switch routine in general works this way:
; first time when external line is set to high from low (after a LONG time... (>2000 cycles?)
; bank is resetted to 0
; if another switch from high to low occurs within a short (but not too short) time (about 1500 cycles) bank is increased by one
; so to reach "higher" banks we have to loop thru all lower banks...

; 21 byte of routine to a RAM location
switchRoutineROMStart: 
; cart num in a
switch: 
                    ldb      #$9f                         ; Prepare DDR Registers % 1001 1111 
                    stb      <VIA_DDR_b                   ; all ORB to output except ORB 5 and 6, PB6 goes HIGH 
                    deca                                  ; reduce bank counter by one 
                    clrb                                  ; do a full $ff wait loop, clr b 
delay: 
                    decb                                  ; b-- (first round this initiates the "$ff) 
                    bne      delay                        ; if not zero delay further 
                    ldb      #$df                         ; Prepare DDR Registers % 1101 1111 
                    stb      <VIA_DDR_b                   ; all ORB to output except ORB 5, PB6 goes LOW 
                    nop                                   ; delay 
                    nop                                   ; delay for a pulse length to VecFlash 
                    tsta                                  ; test a (bank counter) for 0 
                    bne      switch                       ; if not zero, continue bankswitching 
                    noopt    
                    jmp      main                         ; here no opt is neccessary, since in RAM this MUST be a LONG branch! 
                    opt      
switchRoutineROMEnd: 
