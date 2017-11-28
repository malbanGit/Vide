Sound_Byte=$F256 
Clear_x_d=$F548 
                    BSS      
                    org      ym_ram 
startDataPos:       ds       2 
nextDataPos:        ds       2 
currentDataBitPos:  ds       1 
currentDataByte:    ds       1 
                    code     
; if zero flag is set after macro the bit was 0
; if zero is clear after macro the bit was 1
GET_BIT             macro    
                    local    bitPosOk 
                    ldb      currentDataBitPos 
                    bne      bitPosOk 
; load a new byte
                    ldx      nextDataPos 
                    ldb      ,x+ 
                    stb      currentDataByte 
                    stx      nextDataPos 
                    ldb      #$80 
                    stb      currentDataBitPos 
bitPosOk: 
; bit position correct here
;
; remember we use one bit now!
                    lsr      currentDataBitPos 
; is the bit at the current position set?
                    andb     currentDataByte 
                    endm     
;***************************************************************************
WRITE_PSG           macro                                 ; a = reg, b = data 
                    STA      <VIA_port_a                  ;store register select byte 
                    LDA      #$19                         ;sound BDIR on, BC1 on, mux off _ LATCH 
                    STA      <VIA_port_b 
                    LDA      #$01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
                    STA      <VIA_port_b 
                    LDA      <VIA_port_a                  ;read sound chip status (?) 
                    STB      <VIA_port_a                  ;store data byte 
                    LDB      #$11                         ;sound BDIR on, BC1 off, mux off - WRITE 
                    STB      <VIA_port_b 
                    LDB      #$01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
                    STB      <VIA_port_b 
                    endm     
;***************************************************************************
; store data in reg a in an
; appropriate way to PSG register
STORE_PSG           macro    register 
                    ldb      #register 
                    exg      a,b 
                    WRITE_PSG  
                    endm     
; expects u to point to shadow area
; expect in U start of data
init_ym_sound: 
                    stu      nextDataPos 
                    stu      startDataPos 
                    lda      ,u+ 
                    stu      nextDataPos 
                    ldb      #$80 
                    stb      currentDataBitPos 
                    sta      currentDataByte 
                    lda      #FIRST7 
                    sta      $c807 
                    STORE_PSG  7 
                    rts      

;***************************************************************************
; No shadowing
; uses psg shadow reg 7 
do_ym_sound: 
; check first bit, if 0, than nothing AT all changed
                    GET_BIT  
                    lbeq     done 
                    if       HAS_VOICE0=1 
;;;;
;; voice 0
;;;;
; check voice 0, if next bit 0, than nothing changed in voice0
                    GET_BIT  
                    lbeq     voice0done 
; check next bit, if 0, than amplitude is the same
                    GET_BIT  
                    lbeq     voice0Amplitudedone 
                                                          ; get 4 bits of amplitude from stream 
                    lda      #0 
                    GET_BIT  
                    lbeq     voice0AmplitudeBit0Done 
                    inca     
voice0AmplitudeBit0Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice0AmplitudeBit1Done 
                    inca     
voice0AmplitudeBit1Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice0AmplitudeBit2Done 
                    inca     
voice0AmplitudeBit2Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice0AmplitudeBit3Done 
                    inca     
voice0AmplitudeBit3Done: 
                    if       HAS_ENVELOPE = 1 
                    lsla     
                    GET_BIT  
                    lbeq     voice0AmplitudeBit4Done 
                    inca     
voice0AmplitudeBit4Done: 
                    endif    
                    STORE_PSG  8 
voice0Amplitudedone: 
; check if noise, when next bit is set, than noise
                    lda      $C807                        ; load reg 7 shadow 
                    if       HAS_SOME_NOISE = 1 
                    if       HAS_NOISE0 = 1 
                    GET_BIT  
                    lbeq     voice0SetNoNoise 
voice0SetNoise: 
                    anda     #(%11110111)                 ; set bit 3 to 0 
                    bra      voice0NoiseDone 

voice0SetNoNoise: 
                    ora      #(%00001000)                 ; set bit 3 to 1 
voice0NoiseDone: 
                    endif    
                    endif    
; check if tone, when next bit is set, than noise
                    if       HAS_DIF_TONE0 = 1 
                    if       HAS_TONE0 = 1 
                    GET_BIT  
                    lbeq     voice0SetNoTone 
voice0SetTone: 
                    anda     #(%11111110)                 ; set bit 0 to 0 
                    bra      voice0ToneDone 

voice0SetNoTone: 
                    ora      #(%00000001)                 ; set bit 0 to 1 
voice0ToneDone: 
                    endif    
                    endif    
                    sta      $C807                        ; load reg 7 shadow 
; check voice 0 low frequence, if next bit is one, set it
                    GET_BIT  
                    lbeq     voice0NoLowFreq 
                                                          ; get 8 bits of low freq from stream 
                    lda      #0 
                    GET_BIT  
                    lbeq     voice0LowFreqBit0Done 
                    inca     
voice0LowFreqBit0Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice0LowFreqBit1Done 
                    inca     
voice0LowFreqBit1Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice0LowFreqBit2Done 
                    inca     
voice0LowFreqBit2Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice0LowFreqBit3Done 
                    inca     
voice0LowFreqBit3Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice0LowFreqBit4Done 
                    inca     
voice0LowFreqBit4Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice0LowFreqBit5Done 
                    inca     
voice0LowFreqBit5Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice0LowFreqBit6Done 
                    inca     
voice0LowFreqBit6Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice0LowFreqBit7Done 
                    inca     
voice0LowFreqBit7Done: 
                    STORE_PSG  0 
voice0NoLowFreq: 
; check voice 0 high frequency, if next bit is one, set it
                    GET_BIT  
                    lbeq     voice0NoHiFreq 
                                                          ; get 4 bits of low freq from stream 
                    lda      #0 
                    GET_BIT  
                    lbeq     voice0HiFreqBit0Done 
                    inca     
voice0HiFreqBit0Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice0HiFreqBit1Done 
                    inca     
voice0HiFreqBit1Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice0HiFreqBit2Done 
                    inca     
voice0HiFreqBit2Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice0HiFreqBit3Done 
                    inca     
voice0HiFreqBit3Done: 
                    STORE_PSG  1 
voice0NoHiFreq: 
voice0done: 
                    endif    
                    if       HAS_VOICE1=1 
;;;;
;; voice 1
;;;;
; check voice 1, if next bit 0, than nothing changed in voice1
                    GET_BIT  
                    lbeq     voice1done 
; check next bit, if 0, than amplitude is the same
                    GET_BIT  
                    lbeq     voice1Amplitudedone 
                                                          ; get 4 bits of amplitude from stream 
                    lda      #0 
                    GET_BIT  
                    lbeq     voice1AmplitudeBit0Done 
                    inca     
voice1AmplitudeBit0Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice1AmplitudeBit1Done 
                    inca     
voice1AmplitudeBit1Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice1AmplitudeBit2Done 
                    inca     
voice1AmplitudeBit2Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice1AmplitudeBit3Done 
                    inca     
voice1AmplitudeBit3Done: 
                    if       HAS_ENVELOPE = 1 
                    lsla     
                    GET_BIT  
                    lbeq     voice1AmplitudeBit4Done 
                    inca     
voice1AmplitudeBit4Done: 
                    endif    
                    STORE_PSG  9 
voice1Amplitudedone: 
; check if noise, when next bit is set, than noise
                    lda      $C807                        ; load reg 7 shadow 
                    if       HAS_SOME_NOISE = 1 
                    if       HAS_NOISE1 = 1 
                    GET_BIT  
                    lbeq     voice1SetNoNoise 
voice1SetNoise: 
                    anda     #(%11101111)                 ; set bit 4 to 0 
                    bra      voice1NoiseDone 

voice1SetNoNoise: 
                    ora      #(%00010000)                 ; set bit 4 to 1 
voice1NoiseDone: 
                    endif    
                    endif    
; check if tone, when next bit is set, than noise
                    if       HAS_DIF_TONE1 = 1 
                    if       HAS_TONE1 = 1 
                    GET_BIT  
                    lbeq     voice1SetNoTone 
voice1SetTone: 
                    anda     #(%11111101)                 ; set bit 1 to 0 
                    bra      voice1ToneDone 

voice1SetNoTone: 
                    ora      #(%00000010)                 ; set bit 1 to 1 
voice1ToneDone: 
                    endif    
                    endif    
                    sta      $C807                        ; and store the value to shadow 
; check voice 1 low frequence, if next bit is one, set it
                    GET_BIT  
                    lbeq     voice1NoLowFreq 
                                                          ; get 8 bits of low freq from stream 
                    lda      #0 
                    GET_BIT  
                    lbeq     voice1LowFreqBit0Done 
                    inca     
voice1LowFreqBit0Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice1LowFreqBit1Done 
                    inca     
voice1LowFreqBit1Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice1LowFreqBit2Done 
                    inca     
voice1LowFreqBit2Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice1LowFreqBit3Done 
                    inca     
voice1LowFreqBit3Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice1LowFreqBit4Done 
                    inca     
voice1LowFreqBit4Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice1LowFreqBit5Done 
                    inca     
voice1LowFreqBit5Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice1LowFreqBit6Done 
                    inca     
voice1LowFreqBit6Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice1LowFreqBit7Done 
                    inca     
voice1LowFreqBit7Done: 
                    STORE_PSG  2 
voice1NoLowFreq: 
; check voice 1 high frequency, if next bit is one, set it
                    GET_BIT  
                    lbeq     voice1NoHiFreq 
                                                          ; get 4 bits of low freq from stream 
                    lda      #0 
                    GET_BIT  
                    lbeq     voice1HiFreqBit0Done 
                    inca     
voice1HiFreqBit0Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice1HiFreqBit1Done 
                    inca     
voice1HiFreqBit1Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice1HiFreqBit2Done 
                    inca     
voice1HiFreqBit2Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice1HiFreqBit3Done 
                    inca     
voice1HiFreqBit3Done: 
                    STORE_PSG  3 
voice1NoHiFreq: 
voice1done: 
                    endif    
                    if       HAS_VOICE2 = 1 
;;;;
;; voice 2
;;;;
; check voice 2, if next bit 0, than nothing changed in voice2
                    GET_BIT  
                    lbeq     voice2done 
; check next bit, if 0, than amplitude is the same
                    GET_BIT  
                    lbeq     voice2Amplitudedone 
                                                          ; get 4 bits of amplitude from stream 
                    lda      #0 
                    GET_BIT  
                    lbeq     voice2AmplitudeBit0Done 
                    inca     
voice2AmplitudeBit0Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice2AmplitudeBit1Done 
                    inca     
voice2AmplitudeBit1Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice2AmplitudeBit2Done 
                    inca     
voice2AmplitudeBit2Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice2AmplitudeBit3Done 
                    inca     
voice2AmplitudeBit3Done: 
                    if       HAS_ENVELOPE = 1 
                    lsla     
                    GET_BIT  
                    lbeq     voice2AmplitudeBit4Done 
                    inca     
voice2AmplitudeBit4Done: 
                    endif    
                    STORE_PSG  10 
voice2Amplitudedone: 
; check if noise, when next bit is set, than noise
                    lda      $C807                        ; load reg 7 shadow 
                    if       HAS_SOME_NOISE = 1 
                    if       HAS_NOISE2 = 1 
                    GET_BIT  
                    lbeq     voice2SetNoNoise 
voice2SetNoise: 
                    anda     #(%11011111)                 ; set bit 5 to 0 
                    bra      voice2NoiseDone 

voice2SetNoNoise: 
                    ora      #(%00100000)                 ; set bit 5 to 1 
voice2NoiseDone: 
                    endif    
                    endif    
; check if tone, when next bit is set, than noise
                    if       HAS_DIF_TONE2 = 1 
                    if       HAS_TONE2 = 1 
                    GET_BIT  
                    lbeq     voice2SetNoTone 
voice2SetTone: 
                    anda     #(%11111011)                 ; set bit 2 to 0 
                    bra      voice2ToneDone 

voice2SetNoTone: 
                    ora      #(%00000100)                 ; set bit 2 to 1 
voice2ToneDone: 
                    endif    
                    endif    
                    sta      $C807                        ; save reg 7 shadow 
; check voice 2 low frequence, if next bit is one, set it
                    GET_BIT  
                    lbeq     voice2NoLowFreq 
                                                          ; get 8 bits of low freq from stream 
                    lda      #0 
                    GET_BIT  
                    lbeq     voice2LowFreqBit0Done 
                    inca     
voice2LowFreqBit0Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice2LowFreqBit1Done 
                    inca     
voice2LowFreqBit1Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice2LowFreqBit2Done 
                    inca     
voice2LowFreqBit2Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice2LowFreqBit3Done 
                    inca     
voice2LowFreqBit3Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice2LowFreqBit4Done 
                    inca     
voice2LowFreqBit4Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice2LowFreqBit5Done 
                    inca     
voice2LowFreqBit5Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice2LowFreqBit6Done 
                    inca     
voice2LowFreqBit6Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice2LowFreqBit7Done 
                    inca     
voice2LowFreqBit7Done: 
                    STORE_PSG  4 
voice2NoLowFreq: 
; check voice 2 high frequency, if next bit is one, set it
                    GET_BIT  
                    lbeq     voice2NoHiFreq 
                                                          ; get 4 bits of low freq from stream 
                    lda      #0 
                    GET_BIT  
                    lbeq     voice2HiFreqBit0Done 
                    inca     
voice2HiFreqBit0Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice2HiFreqBit1Done 
                    inca     
voice2HiFreqBit1Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice2HiFreqBit2Done 
                    inca     
voice2HiFreqBit2Done: 
                    lsla     
                    GET_BIT  
                    lbeq     voice2HiFreqBit3Done 
                    inca     
voice2HiFreqBit3Done: 
                    STORE_PSG  5 
voice2NoHiFreq: 
voice2done: 
                    endif    
                    if       HAS_SOME_NOISE = 1 
; last, check if noise data must be set
                    GET_BIT  
                    lbeq     noNoiseData 
                                                          ; get 5 bits of low freq from stream 
                    lda      #0 
                    GET_BIT  
                    lbeq     noiseBit0Done 
                    inca     
noiseBit0Done: 
                    lsla     
                    GET_BIT  
                    lbeq     noiseBit1Done 
                    inca     
noiseBit1Done: 
                    lsla     
                    GET_BIT  
                    lbeq     noiseBit2Done 
                    inca     
noiseBit2Done: 
                    lsla     
                    GET_BIT  
                    lbeq     noiseBit3Done 
                    inca     
noiseBit3Done: 
                    lsla     
                    GET_BIT  
                    lbeq     noiseBit4Done 
                    inca     
noiseBit4Done: 
                    STORE_PSG  6 
                    endif    
noNoiseData: 

                    if       HAS_ENVELOPE = 1 
                    GET_BIT  
                    lbeq     noEnvData 

                    lda      #0 
                    GET_BIT  
                    lbeq     envBit0Done 
                    inca     
envBit0Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envBit1Done 
                    inca     
envBit1Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envBit2Done 
                    inca     
envBit2Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envBit3Done 
                    inca     
envBit3Done: 

                    STORE_PSG 13
noEnvData:

                    GET_BIT  
                    lbeq     noEnvFreqData 
                    lda      #0 
                    GET_BIT  
                    lbeq    envFreqHiBit0Done 
                    inca     
envFreqHiBit0Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqHiBit1Done 
                    inca     
envFreqHiBit1Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqHiBit2Done 
                    inca     
envFreqHiBit2Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqHiBit3Done 
                    inca     
envFreqHiBit3Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqHiBit4Done 
                    inca     
envFreqHiBit4Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqHiBit5Done 
                    inca     
envFreqHiBit5Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqHiBit6Done 
                    inca     
envFreqHiBit6Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqHiBit7Done 
                    inca     
envFreqHiBit7Done: 
                    STORE_PSG  11

                    lda      #0 
                    GET_BIT  
                    lbeq    envFreqLoBit0Done 
                    inca     
envFreqLoBit0Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqLoBit1Done 
                    inca     
envFreqLoBit1Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqLoBit2Done 
                    inca     
envFreqLoBit2Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqLoBit3Done 
                    inca     
envFreqLoBit3Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqLoBit4Done 
                    inca     
envFreqLoBit4Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqLoBit5Done 
                    inca     
envFreqLoBit5Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqLoBit6Done 
                    inca     
envFreqLoBit6Done: 
                    lsla     
                    GET_BIT  
                    lbeq     envFreqLoBit7Done 
                    inca     
envFreqLoBit7Done: 
                    STORE_PSG  12




noEnvFreqData:
                    endif    
 

                    lda      $c807 
                    STORE_PSG  7 
done: 
                    rts      
