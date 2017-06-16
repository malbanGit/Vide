; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;                    code     
; following code is not allowed to make assumptions concerning DP
                    direct   $ff 
;***************************************************************************
; if zero flag is set after macro the bit was 0
; if zero is clear after macro the bit was 1
; sets carry according to next bit
;***************************************************************************
; general get 1 bit version
GET_BIT             macro    
                    local    bitPosOk 
                    dec      currentDataBitPos 
                    bpl      bitPosOk 
; load a new byte
                    ldu      nextDataPos                  ; [6] 
                    ldb      ,u+                          ; [6] 
                    stu      nextDataPos                  ; [6] = 18 
                    stb      currentDataByte 
                    ldb      #$7 
                    stb      currentDataBitPos 
bitPosOk: 
;
; remember we use one bit now!
; is the bit at the current position set?
                    rol      currentDataByte 
                    endm     
;***************************************************************************
; three versions to get several bits in a row
; count variable is than kept
; in register b for faster access
; saves anoter 120 cycles to do split macros!
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_BIT_first       macro    
                    local    bitPosOk 
                    ldb      currentDataBitPos 
                    decb     
                    bpl      bitPosOk 
                    ldu      nextDataPos                  ; [6] 
                    ldb      ,u+                          ; [6] 
                    stu      nextDataPos                  ; [6] = 18 
                    stb      currentDataByte 
                    ldb      #$7 
bitPosOk: 
                    rol      currentDataByte 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_BIT_middle      macro    
                    local    bitPosOk 
                    decb     
                    bpl      bitPosOk 
                    ldu      nextDataPos                  ; [6] 
                    ldb      ,u+                          ; [6] 
                    stu      nextDataPos                  ; [6] = 18 
                    stb      currentDataByte 
                    ldb      #$7 
bitPosOk: 
                    rol      currentDataByte 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_BIT_last        macro    
                    local    bitPosOk 
                    decb     
                    bpl      bitPosOk 
                    ldu      nextDataPos                  ; [6] 
                    ldb      ,u+                          ; [6] 
                    stu      nextDataPos                  ; [6] = 18 
                    stb      currentDataByte 
                    ldb      #$7 
bitPosOk: 
                    stb      currentDataBitPos 
                    rol      currentDataByte 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;***************************************************************************
;
; expects nothing
; expect in U start of data
; expects d0 set
;***************************************************************************
init_ym_sound: 
                    ldu      nextDataPos 
                    ldb      ,u+ 
                    stu      nextDataPos 
                    lda      musicOption 
                    beq      playMusicOk 
                    ldx      #0 
                    stx      currentMusic 
                    stx      currentYLenCount 
                    stx      nextMusic 
                    rts      

playMusicOk: 
                    ldx      >currentMusic 
                    beq      no_ym_music 
                    ldu      2,x 
                    stu      nextMusic 
                    ldu      ,x 
                    ldd      -2,u 
                    std      >currentYLenCount 
                    stu      >nextDataPos 
                    stu      >startDataPos 
                    lda      ,u+ 
                    stu      >nextDataPos 
                    ldb      #$8 
                    stb      >currentDataBitPos 
                    sta      >currentDataByte 
                    lda      #FIRST7 
                    STORE_PSG  7 
                    stb      >$c807                       ; ensure difference between shadow and virtual reg, so the new reg 7 gets copied 
no_ym_music: 
emptyStreamInMove: 
                    rts      

;***************************************************************************
oneYMRound 
                    ldx      currentMusic 
                    beq      no_streaming_112 
                                                          ; initialize dispatcher for "in move" stuff - this is only the decoder, other stuff is done "directly" 
                    ldd      #STREAM_PART_1               ; first jumper of ym decoder 
                    std      inMovePointer 
                    jsr      [inMovePointer] 
                    jsr      [inMovePointer] 
                    jsr      [inMovePointer] 
                    jsr      [inMovePointer] 
                    jsr      [inMovePointer] 
                    jsr      [inMovePointer] 
                    jsr      [inMovePointer] 
                    jsr      [inMovePointer] 
                    jsr      [inMovePointer] 
no_streaming_112: 
                    rts      

;***************************************************************************
; frogger music only uses 
; voices 0 and 1 (the first two voices)
; the other channel is reserved for sound effects!
; any change at all?
STREAM_PART_1 
                    GET_BIT  
                    bcc      noChangeAtAllp 
                    ldd      #STREAM_PART_2 
                    std      inMovePointer 
                    rts      

noChangeAtAllp: 
                    ldd      #emptyStreamInMove 
                    std      inMovePointer 
                    rts      

;***************************************************************************
; voice 0 changes?
STREAM_PART_2 
; check voice 0, if next bit 0, than nothing changed in voice0
                    GET_BIT  
                    bcc      noVoiceChange1 
                    ldd      #STREAM_PART_3 
                    std      inMovePointer 
                    rts      

noVoiceChange1: 
                    ldd      #STREAM_PART_6 
                    std      inMovePointer 
                    rts      

;***************************************************************************
; voice 0 Amplitude
STREAM_PART_3 
                    GET_BIT  
                    bcc      voice0AmplitudedonePart 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     
                    STORE_PSG  8 
voice0AmplitudedonePart: 
                    ldd      #STREAM_PART_4 
                    std      inMovePointer 
                    rts      

;***************************************************************************
; voice 0 Frequency low
voice0NoLowFreqPartFront: 
                    ldd      #STREAM_PART_5 
                    std      inMovePointer 
                    rts      

STREAM_PART_4 
; check voice 0 low frequence, if next bit is one, set it
                    GET_BIT  
                    bcc      voice0NoLowFreqPartFront 
                                                          ; get 8 bits of low freq from stream 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     
                    STORE_PSG  0 
voice0NoLowFreqPart: 
                    ldd      #STREAM_PART_5 
                    std      inMovePointer 
                    rts      

;***************************************************************************
; voice 0 Frequency high
STREAM_PART_5 
; check voice 0 high frequency, if next bit is one, set it
                    GET_BIT  
                    bcc      voice0NoHiFreqPart 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     
                    STORE_PSG  1 
voice0NoHiFreqPart: 
                    ldd      #STREAM_PART_6 
                    std      inMovePointer 
                    rts      

;***************************************************************************
STREAM_PART_6 
; voice 1 changes?
; check voice !, if next bit 0, than nothing changed in voice!
                    GET_BIT  
                    bcc      noVoiceChange2 
                    ldd      #STREAM_PART_7 
                    std      inMovePointer 
                    rts      

noVoiceChange2: 
                    ldd      #emptyStreamInMove 
                    std      inMovePointer 
                    rts      

;***************************************************************************
; voice 1 Amplitude
STREAM_PART_7 
                    GET_BIT  
                    bcc      voice1AmplitudedonePart 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     
                    STORE_PSG  9 
voice1AmplitudedonePart: 
                    ldd      #STREAM_PART_8 
                    std      inMovePointer 
                    rts      

;***************************************************************************
; voice 1 Frequency low
voice1NoLowFreqPartFront: 
                    ldd      #STREAM_PART_9 
                    std      inMovePointer 
                    rts      

STREAM_PART_8 
; check voice 1 low frequence, if next bit is one, set it
                    GET_BIT  
                    bcc      voice1NoLowFreqPartFront 
                                                          ; get 8 bits of low freq from stream 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     
                    STORE_PSG  2 
voice1NoLowFreqPart: 
                    ldd      #STREAM_PART_9 
                    std      inMovePointer 
                    rts      

;***************************************************************************
; voice 1 Frequency high
STREAM_PART_9 
; check voice 1 high frequency, if next bit is one, set it
                    GET_BIT  
                    bcc      voice1NoHiFreqPart 
                                                          ; get 4 bits of low freq from stream 
                    lda      #0 
                    GET_BIT_first  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_middle  
                    rola     
                    GET_BIT_last  
                    rola     
                    STORE_PSG  3 
voice1NoHiFreqPart: 
                    ldd      #emptyStreamInMove 
                    std      inMovePointer 
                    rts      

;***************************************************************************
