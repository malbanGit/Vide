; defines
Init_Music_Buf      equ      $F533 
Freq_Table          equ      $FC8D 
Music_Table_1       equ      $F9E4 
Music_Table_2       equ      $F9EA 
plr_pattern         equ      music_ram 
plr_geilmusik       equ      plr_pattern+1 
plr_geilmusik_hi    equ      plr_geilmusik+1 
plr_part            equ      plr_geilmusik_hi+1 
plr_part_hi         equ      plr_part+1 
plr_part_init       equ      plr_part_hi+1 
plr_part_init_hi    equ      plr_part_init +1 
; following code is apart from one slight modification a copy of the original
; vectrex rom music play routine
;
; support for a §silence value: note $3f
; also for a ADSR and TWANG table for each channel!


                    direct   $c800 
Init_Music_chk_mod: 
                    lda      <Vec_Music_Flag              ;Test sound active flag 
                    bmi      LF6B3                        ;Continue sound if active 
                    bne      Init_Music_mod                        ;Return if sound not active 
              rts      
Init_Music_mod: 
                    ldx      #Freq_Table                  ;Save pointer to frequency table 
                    stx      <Vec_Freq_Table 
Init_Music_dft_mod: 
                    lda      #$80                         ;Set sound active flag 
                    sta      <Vec_Music_Flag 
                    ldd      ,u++                         ;Save address of ADSR table 
                    std      <Vec_ADSR_Table 
                    ldd      ,u++                         ;Save address of twang table 
                    std      <Vec_Twang_Table 
                    stu      <Vec_Music_Ptr               ;Save pointer to music data 
                    jsr      Init_Music_Buf               ;Initialize music buffer 
                    ldd      #$1F1F 
                    std      <Vec_ADSR_Timers+1           ;Init ADSR timers of chans 2 & 3 
                    ldd      #$0000 
                    std      <Vec_Music_Freq+2            ;Clear frequency of channel 2 
                    std      <Vec_Music_Freq+4            ;Clear frequency of channel 3 
                    ldb      #$03                         ;Count for three channels 
                    stb      <Vec_Music_Chan 
                    bra      LF6E3 

; Continue currently playing sound here
LF6B3:              ldu      #Vec_ADSR_Timers             ;Get address of ADSR timers 
                    ldb      #$03                         ;Count for three channels 
                    stb      <Vec_Music_Chan 
                    decb     
LF6B8:              lda      b,u                          ;Get the channel's ADSR timer 
                    cmpa     #$1F 
                    beq      LF6C0                        ;Skip if at maximum 
                    inc      b,u                          ;Else increment the timer 
LF6C0:              decb                                  ;Go back for the other channels 
                    bpl      LF6B8 
                    ldx      <Vec_Twang_Table 
                    ldu      #Vec_Music_Twang             ; pointer to "counter, current TWANG" for each cahnenl (3*2 bytes) 
                    lda      #$09                         ;07 ;Twang limit is 6-8 depending on channel 
LF6CA:              inc      ,u                           ;increment twang counter 
                    cmpa     ,u                           ;Check against limit 
                    bge      LF6D2 
                    clr      ,u                           ;Clear it if limit exceeded 
LF6D2:              ldb      ,u+                          ;Get twang count 
                    andb     #$07                         ;Mask out low 3 bits 
                    ldb      b,x                          ;Get twang value from table 
                    stb      ,u+                          ;Update current twang value 
                    leax     #8,x                         ; for next channel use next twang table 
                    cmpu     #Vec_Music_Twang +4          ; three twangs done -> jump 
                                                          ; inca ;increment twang limit 
                                                          ; cmpa #$09 
                    bls      LF6CA                        ;Go back until all three channels done 
                    dec      <Vec_Duration                ;decrement the duration timer 
                    lbne     LF74E                        ;Update ADSR while note still playing 

; from here start reading the next note and start "playing" it
LF6E3:              lda      <Vec_Music_Chan              ;Go to next music channel 
                    deca     
                    bpl      LF6EA                        ;If < 0, set it to 2 
                    lda      #$02 
LF6EA:              sta      <Vec_Music_Chan 
LF6EC:              ldb      [Vec_Music_Ptr]              ;Get next byte of music data 

                    andb     #$3f 
                    cmpb     #$3F                         ; if it's a 3F, set the ADSR timer to end (silence) 
                    beq      LF735 
LF6EC3: 
                    ldb      [Vec_Music_Ptr]              ; reload, since we destroyed with SIL test 
                    ldu      #Vec_ADSR_Timers             ;Clear ADSR timer for this channel 
                    clr      a,u 
LF6EC2:             bitb     #$40                         ;If $40 bit of music data set, 
                    beq      LF712                        ;we're going to make some noise 
                    ldx      #Music_Table_1               ;Get bit mask for this channel 
                    lda      a,x 
                    anda     <Vec_Music_Wk_7              ;Turn channel bit off for register 7 
                    sta      <Vec_Music_Wk_7 
                    lda      <Vec_Music_Chan              ;Set current channel bit in register 7 
                    adda     #$03 
                    lda      a,x 
                    ora      <Vec_Music_Wk_7 
                    sta      <Vec_Music_Wk_7 
                    andb     #$1F                         ;Mask off low 5 bits of music data 
                    stb      <Vec_Music_Wk_6              ;and store in register 6 
                    bra      LF735 

LF712:              ldx      #Music_Table_2               ;If $40 bit of music data was cleared, 
                    lda      a,x                          ;Get bit mask for this channel 
                    anda     <Vec_Music_Wk_7              ;Turn channel bit off for register 7 
                    sta      <Vec_Music_Wk_7 
                    lda      <Vec_Music_Chan              ;Set current channel bit in register 7 
                    adda     #$03 
                    lda      a,x 
                    ora      <Vec_Music_Wk_7 
                    sta      <Vec_Music_Wk_7 
                    lda      <Vec_Music_Chan              ;Get $C855 * 2 + 3 
                    asla     
                    adda     #Vec_Music_Freq-Vec_ADSR_Timers 
                    leau     a,u                          ;Point U-reg to #$C861 + $C855 * 2 
                    andb     #$3F                         ;Mask off low 6 bits of music data, 
                    aslb                                  ;multiply by 2 
                    ldx      <Vec_Freq_Table              ;Get pointer to note-to-frequency table 
                    ldd      b,x                          ;Get note table data 
                    std      ,u                           ;Store in word at $C861-$C866 
LF735:              ldx      <Vec_Music_Ptr               ;Re-get byte of music data 
                    ldb      ,x+ 
                    stx      <Vec_Music_Ptr               ;Update music data pointer 
                    tstb     
                    bmi      LF6E3                        ;If byte>=$80, advance to next channel 
                    ldb      ,x+                          ;Get second byte of music data 
                    bpl      LF748                        ;If >=$80, (terminator) 
                    jsr      Init_Music_Buf               ; clear music buffer, 
                    clr      <Vec_Music_Flag              ; clear music flag, 
                    rts                                   ; and exit 

LF748:              stx      <Vec_Music_Ptr               ;Update music data pointer 
                    andb     #$3F                         ;Duration in low 6 bits of second byte 
                    stb      <Vec_Duration                ;Store duration counter 
LF74E:              ldy      <Vec_ADSR_Table              ;Get pointer to ADSR table 
                    ldu      #Vec_ADSR_Timers             ;Point to ADSR timer table 
                    ldx      #Vec_Music_Wk_A 
                    lda      #$02                         ;Count for three channels 
LF759:              ldb      ,u+                          ;Get channel timer? 
                    bitb     #$01                         ;Test low bit of ADSR index 
                    beq      LF766 
                    lsrb                                  ;If odd, divide ADSR index by by 2 
                    ldb      b,y                          ;Get low nibble from ADSR table 
                    andb     #$0F 
                    bra      LF76D 

LF766:              lsrb                                  ;If even, divide ADSR index by 2 
                    ldb      b,y                          ;Get high nibble from ADSR table 
                    lsrb     
                    lsrb     
                    lsrb     
                    lsrb     
LF76D:              stb      a,x                          ;Store ADSR value in regs 10-12 
                    leay     #16,y                        ; each channel has a adsr, they rare 16 byte apart 
                    deca                                  ;decrement channel counter 
                    bpl      LF759                        ;Go back for next channel 
                    ldu      #Vec_Music_Freq+6            ;Point to base frequency table 
                    ldx      #Vec_Music_Wk_5              ;Point to shadow registers of PSG for frequency 
LF778:              ldd      ,--u                         ;Get next base frequency 
                    tst      -8,u                         ;Test twang value 
                    bpl      LF788 
                    neg      -8,u                         ;If <0, negate twang table entry 
                    subb     -8,u                         ;Subtract negated value from frequency 
                    sbca     #$00                         ;Propagate borrow to high byte 
                    neg      -8,u                         ;Un-negate twang entry 
                    bra      LF78C 

LF788:              addb     -8,u                         ;If >0 add twang to base frequency 
                    adca     #$00                         ;Propagate carry to high byte 
LF78C:              std      ,x++                         ;Store freq in regs 5/4, 3/2, 1/0 
                    cmpx     #Vec_Music_Work+14 
                    bne      LF778 
LF793_rts:          rts      

                    direct   $ffff 
