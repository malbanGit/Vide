
PLAYER: 
PLY_PLAY: 

                    tst      musicOption 
                    lbne      playMusic_NOk_m_pac 

;Manage Speed. If Speed counter is over, we have to read the Pattern further.
                    dec      PLY_SPEEDCPT 
                    lbne     PLY_SPEEDEND 
;Moving forward in the Pattern. Test if it is not over.
                    dec      PLY_HEIGHTCPT 
                    BNE      PLY_HEIGHTEND 
;Pattern Over. We have to read the Linker.
;Get the Transpositions, if they have changed, or detect the Song Ending !
                    LDX      PLY_LINKER_PT 
                    LDA      ,X+ 
; A = 
;{DB PatternState :
;
;	b5 = New Special Track ?
;	b4 = New Height ?
;	b3 = New Transposition 3 ?
;	b2 = New Transposition 2 ?
;	b1 = New Transposition 1 ?
;	b0 = Song over ? 1 = song over - no new bytes following -> loop possible...
                    RORA     
                    BCC      PLY_SONGNOTOVER 
;Song over ! We read the address of the Loop point.
;
; if b0 == 1
; dw Pointeur on Linker to loop. Restart reading.
;
                    ldx      ,x 
;We know the Song won't restart now, so we can skip the first bit.                                                                                      ;WE KNOW THE SONG WON'T RESTART NOW, SO WE CAN SKIP THE FIRST BIT.
                    LDA      ,X+ 
; now it looks like we just started a new pattern!
                    RORA                                  ; skip the song over, when we just start a new pattern - cant be over yet, can it? 
PLY_SONGNOTOVER: 
;if b0 = 0 :
;
;DB Transposition 1 if Transposition1?
;DB Transposition 2 if Transposition2?
;DB Transposition 3 if Transposition3?
;DW Track1
;DW Track2
;DW Track3
;DB Height if New Height?.
;DW Special Track if New Special Track?
;
;} * Length + 1		(+1 because the Loop item has to be added to the list).
                    RORA                                  ; if b1 = 1 
                    BCC      PLY_NONEWTRANSPOSITION1 
                    LDB      ,X+ 
                    STB      Channel1Data + PLY_TRANSPOSITION 
PLY_NONEWTRANSPOSITION1: 
                    RORA                                  ; if b2 = 1 
                    BCC      PLY_NONEWTRANSPOSITION2 
                    LDB      ,X+ 
                    STB      Channel2Data + PLY_TRANSPOSITION 
PLY_NONEWTRANSPOSITION2: 
                    RORA                                  ; if b3 = 1 
                    BCC      PLY_NONEWTRANSPOSITION3 
                    LDB      ,X+ 
                    STB      Channel3Data + PLY_TRANSPOSITION 
PLY_NONEWTRANSPOSITION3 
                    LDu      ,X++ 
                    STu      Channel1Data + PLY_TRACK_PT 
                    LDu      ,X++ 
                    STu      Channel2Data + PLY_TRACK_PT 
                    LDu      ,X++ 
                    STu      Channel3Data + PLY_TRACK_PT 
                    RORA                                  ; if b4 = 1 
                    BCC      PLY_NONEWHEIGHT 
                    LDB      ,X+ 
                    STB      PLY_HEIGHT 
PLY_NONEWHEIGHT: 
                    RORA                                  ; if b5 = 1 
                    BCC      PLY_NONEWSPECIALTRACK 
PLY_NEWSPECIALTRACK: 
                    ldu      , x++ 
                    STu      PLY_SAVESPECIALTRACK 
PLY_NONEWSPECIALTRACK: 
                    STX      PLY_LINKER_PT                ; this pattern was read, whenever the tracks are playered - the next pattern will start here 
; a new pattern allways resets the special track - whether an old one - or a just gotten one
                    LDX      PLY_SAVESPECIALTRACK 
                    STX      PLY_SPECIALTRACK_PT 
;Reset the SpecialTrack/Tracks line counter.
;We can't rely on the song data, because the Pattern Height is not related to the Tracks Height.
; countdowns allways test for dec->beq - so placing a one is a garantied "reset"
                    LDA      #$1 
                    sta      PLY_SPECIALTRACK_WAITCOUNTER 
                    sta      Channel1Data + PLY_TRACK_WAITCOUNTER 
                    sta      Channel2Data + PLY_TRACK_WAITCOUNTER 
                    sta      Channel3Data + PLY_TRACK_WAITCOUNTER 
                    LDA      PLY_HEIGHT 
                    STA      PLY_HEIGHTCPT 
PLY_HEIGHTEND: 
;Read the Special Track/Tracks.
;------------------------------
;
; note:
; vectrex player does not support digidrums!
;SpecialTracks
;-------------
;
;DB Data
;b0 = Data (1) or Wait (0)
;If Wait :
;b7-b1 = Wait b7-b1 lines. (1=1 line, 0=128 lines)
;If Data :
;b1 = Speed (0) or Digidrum (1) ?
;b7-b2 = Value. If value = 0, escape code : read next byte to know value.
;
;If Escape Code :
;{
; DB Value
;}
_read_special_track 
;Read the Special Track.
                    dec      PLY_SPECIALTRACK_WAITCOUNTER 
                    BNE      PLY_SPECIALTRACK_DONE 
                    LDX      PLY_SPECIALTRACK_PT 
                    LDA      ,X+ 
                    LSRA                                  ; if b0=0 -> carry will be clear -> jump to WAIT 
                    BCC      PLY_SPECIALTRACK_NEWWAIT 
                    LSRA                                  ; regardless if speed or digidrum -> if a right shift results in 0 A, than we have an escape situation, if not -> jump 
                    BNE      PLY_SPECIALTRACK_NOESCAPECODE 
                    LDA      ,X+                          ; load the escaped (additional) value 
PLY_SPECIALTRACK_NOESCAPECODE 
; if carry was set by the last right shift, the special track
; denotes a digidrum, since it is not supported
; we just ignore it and jump to the end
                    bcs      PLY_PT_SPECIALTRACK_ENDDATA 
PLY_SPECIALTRACK_SPEED 
                    STA      PLY_SPEED                    ; the data we got was the speed - store it 
PLY_PT_SPECIALTRACK_ENDDATA 
                    LDA      #$1                          ; reset wait counter, next round might be more waiting :-) 
PLY_SPECIALTRACK_NEWWAIT 
                    STX      PLY_SPECIALTRACK_PT          ; is this used anywhere? 
                    STA      PLY_SPECIALTRACK_WAITCOUNTER 
PLY_SPECIALTRACK_DONE 
                    ldy      #Channel1Data 
readnextchannel 
_read_track 
;Read the Track 1.
;-----------------
;Store the parameters, because the player below is called every frame, but the Read Track isn't.
                    dec      PLY_TRACK_WAITCOUNTER,y 
                    lBNE     PLY_TRACK_NEWINSTRUMENT_WAIT_CONT 
                    LDX      PLY_TRACK_PT, y 
PLY_READTRACK 
                    LDb      ,X+ 
                    LSRb                                  ;Full Optimisation ? If yes = Note only, no Pitch, no Volume, Same Instrument. 
                    BCS      PLY_READTRACK_FULLOPTIMISATION 
                    SUBb     #32                          ;0-31 = Wait. 
                    BCS      PLY_READTRACK_WAIT 
                    BEQ      PLY_READTRACK_NOOPTIMISATION_ESCAPECODE 
                    DECb                                  ;0 (32-32) = Escape Code for more Notes (parameters will be read) 
;Note. Parameters are present. But the note is only present if Note? flag is 1.
;Read Parameters
PLY_READTRACK_READPARAMETERS 
                    LDA      ,X+ 
                    sta      tmp_track_param              ;Save Parameters. 
                    bita     #$80                         ; is pitch following? -> load it 
                    beq      PLY_READTRACK_PITCH_END 
                    ldu      ,x++ 
                    stu      PLY_TRACK_PITCHADD,y 
PLY_READTRACK_PITCH_END 
                    bita     #$20                         ; is instrument following? -> load it 
                    beq      do_continue_p_vol 
; in a original parameter
; use it to correct volume, if any
; befor "destroying" a with instrument data
                    RORA                                  ;Volume ? If bit 4(0?) was 1, then volume exists on b3-b0 - inverted volume 
                    BCC      PLY_TRACK_SAMEVOLUME_2 
                    ANDA     #%1111 
                    STA      PLY_TRACK_VOLUME , y 
PLY_TRACK_SAMEVOLUME_2 
                    LDA      ,X+ 
                    sta      tmp_track_instrument 
                    bra      do_continue_p_vol_done 

PLY_READTRACK_NOOPTIMISATION_ESCAPECODE 
                    LDb      ,X+                          ; load note to B 
                    BRA      PLY_READTRACK_READPARAMETERS 

;---------  
PLY_READTRACK_FULLOPTIMISATION 
                    STX      PLY_TRACK_PT, y 
                    clra                                  ; is param now, no need to save - accessed directly in full opt 
                    SUBb     #$1 
                    BCC      full_opt_note_given 
                    LDb      ,X+ 
;cc_out_save_note
                                                          ; no pitch 
                                                          ; no vol 
                                                          ; but certainly note 
                    bra      full_opt_note_given 

;---------  
PLY_READTRACK_WAIT 
                    ADDb     #32 
                    SET_CARRY  
                    STX      PLY_TRACK_PT, y 
                    bra      PLY_TRACK_NEWINSTRUMENT_SETWAIT 

do_continue_p_vol 
; in b now note - if any
; in a original parameter
                    RORA                                  ;Volume ? If bit 4(0?) was 1, then volume exists on b3-b0 - inverted volume 
                    BCC      PLY_TRACK_SAMEVOLUME_1 
                    ANDA     #%1111 
                    STA      PLY_TRACK_VOLUME , y 
PLY_TRACK_SAMEVOLUME_1 
do_continue_p_vol_done 
; in b current note
; in tmp_b_instrument the current instrument number
; in tmp_d_param, the parameters of the last read track info
;76543210
;pnivvvvo
;
;DB Parameters
;p = New Pitch ?
;n = Note ?
;i = New Instrument ? Only tested if Note? = 1.
;v = Inverted Volume if Volume?=1. %0000 if Volume? is off.
;o = Volume ?
;No Wait command. Can be a Note and/or Effects.
                    lda      tmp_track_param 
                    STX      PLY_TRACK_PT, y 
                    bita     #$40                         ;Note ? If no Note, we don't have to test if a new Instrument is here. 
                    beq      PLY_TRACK_NONOTEGIVEN 
full_opt_note_given 
                    ADDb     PLY_TRANSPOSITION, y         ;Transpose Note according to the Transposition in the Linker. 
                    STb      PLY_TRACK_NOTE, y 
                    LDX      #$0                          ;Reset the TrackPitch. 
                    STX      PLY_TRACK_PITCH , y 
                    bita     #$20                         ;New Instrument ?; 
                    bne      PLY_TRACK_NEWINSTRUMENT 
                    LDX      PLY_TRACK_SAVEPTINSTRUMENT, y ;Same Instrument. We recover its address to restart it. 
                    LDA      PLY_TRACK_INSTRUMENTSPEED, y ;Reset the Instrument Speed Counter. Never seemed useful... 
                    STA      PLY_TRACK_INSTRUMENTSPEEDCPT , y 
                    BRA      PLY_TRACK_INSTRUMENTRESETPT 

PLY_TRACK_NEWINSTRUMENT                                   ;New  Instrument. We have to get its new address, and Speed. 
                    clra     
                    ldb      tmp_track_instrument 
                    MY_LSL_D  
                    LDX      PLY_TRACK_INSTRUMENTSTABLEPT 
                    ldx      d,x 
                    lda      ,x+ 
                    STA      PLY_TRACK_INSTRUMENTSPEED , y 
                    STA      PLY_TRACK_INSTRUMENTSPEEDCPT , y 
                    STX      PLY_TRACK_SAVEPTINSTRUMENT, y ;When using the Instrument again, no need to give the Speed, it is skipped. ;WHEN USING THE INSTRUMENT AGAIN, NO NEED TO GIVE THE SPEED, IT IS SKIPPED. 
PLY_TRACK_INSTRUMENTRESETPT 
                    LDA      ,X+ 
                    BEQ      noIntrumentRetrigger 
                    STA      PLY_PSGREG13_RETRIG 
noIntrumentRetrigger 
                    STX      PLY_TRACK_INSTRUMENT, y 
PLY_TRACK_NONOTEGIVEN 
                    LDb      #$1             
PLY_TRACK_NEWINSTRUMENT_SETWAIT 
                    STb      PLY_TRACK_WAITCOUNTER , y   
PLY_TRACK_NEWINSTRUMENT_WAIT_CONT 
                    leay     ArkosChannel, y 
                    cmpy     #ChannelDataEnd 
                    lbne     readnextchannel 
                    LDA      PLY_SPEED 
                    STA      PLY_SPEEDCPT 




PLY_SPEEDEND 
                    LDD      #PLY_PSGREGISTERSARRAY + 4 
                    std      PLY_FREQ_REG 
                    ldd      #PLY_PSGREGISTERSARRAY + 10 
                    std      PLY_VOL_REG 
                    LDY      #Channel3Data 
playnextchannel 
_play_sound_track
;Play the Sound on Track 
;-------------------------
;Plays the sound on each frame, but only save the forwarded Instrument pointer when Instrument Speed is reached.
;This is needed because TrackPitch is involved in the Software Frequency/Hardware Frequency calculation, and is calculated every frame.
                    LDD      PLY_TRACK_PITCH, y 
                    ADDD     PLY_TRACK_PITCHADD , y 
                    STD      PLY_TRACK_PITCH , y 
; arithmetic shift right D (halfing and preserving sign)
; slow down pitch by quartering the current pitch
; (after the add)
                    ASRA     
                    RORB     
                    ASRA     
                    RORB     
                    TFR      D,U                          ; U = (PLY_TRACK_PITCH/4) 
                    LDX      PLY_TRACK_INSTRUMENT, y 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PLAY SOUND
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Plays a sound stream.
;X Pointer to Instrument Data
;Y Pointer to track data
; U current track pitch
;RET=
;X =New Instrument pointer.
; data in track record is set
PLY_PLAYSOUND: 
;instrument 
;DB FirstByte
;if b0=0, NON-HARD sound. If b0=1, HARD Sound.
                    LDB      ,X+ 
                    RORB     
                    BCS      PLY_PS_HARD 
;************       
;SOFTWARE SOUND, b0 = 0       
;************    
;76543210
;pavvvvn0
;
;p = Pitch?
;a = Arpeggio?
;v = Volume
;n = Second Byte needed? Needed when Noise, or Manual frequency, or noise with no sound.
                    RORB                                  ; is b1 (n) set 
                    BCS      PLY_PS_S_SECONDBYTENEEDED    ; if yes jump to read second byte 
                    TFR      B,A                          ; for volume check copy the first byte to a 
                    ANDA     #%1111                       ; 
                    BNE      PLY_PS_S_SOUNDON             ; if is 0 than no sound at all 
                                                          ;Null Volume. It means no Sound. We stop the Sound, the Noise, and it's over. 
                    STA      [PLY_VOL_REG]                ;We have to make the volume to 0, because if a bass Hard was activated before, we have to stop it. 
                    lda      #%1001                       ; these are the register mask bits for this sound (or this no sound) 
                    sta      PLY_TRACK_REG_7,y 
                    jmp      out_sound 

; A = volume
PLY_PS_S_SOUNDON: 
; Volume is here, no Second Byte needed. It means we have a simple Software sound (Sound = On, Noise = Off)
; We have to test Arpeggio and Pitch, however.
                    SUBA     PLY_TRACK_VOLUME,y           ; tmp_volumeN ;Code Volume. volume of instrument minus inverted volume 
                    BCC      vol_not_null_1 
                    CLRA     
vol_not_null_1 
                    STA      [PLY_VOL_REG] 
                    LDA      #%1000 
                    sta      PLY_TRACK_REG_7,y 
                    RORB                                  ;Needed for the subroutine to get the good flags. 
                    LBSR     PLY_PS_CALCULATEFREQUENCY 
; in u frequency + pitch, in little endian order, ready to be written to psg
                    stu      [PLY_FREQ_REG] 
                    jmp      out_sound 

PLY_PS_S_SECONDBYTENEEDED 
                    LDA      #%1000 
                    sta      PLY_TRACK_REG_7,y 
; A second byte of instrument data
                    LDA      ,X+ 
                    ANDA     #%11111 
                    BEQ      PLY_PS_S_SBN_NONOISE 
                    STA      PLY_PSGREG6 
                    clr      PLY_TRACK_REG_7,y 
PLY_PS_S_SBN_NONOISE: 
                    TFR      B,A 
                    ANDA     #%1111 
                    SUBA     PLY_TRACK_VOLUME,y 
                                                          ;CODE VOLUME. 
                    BCC      no_vol_underflow_1 
                    CLRA     
no_vol_underflow_1 
                    STA      [PLY_VOL_REG] 
                    lda      -1,x 
                    bita     #%00100000 
                    BNE      PLY_PS_S_SBN_SOUND 
                    inc      PLY_TRACK_REG_7,y 
                    jmp      out_sound 

PLY_PS_S_SBN_SOUND 
                    RORB                                  ;Needed for the subroutine to get the good flags. 
                    bita     #%01000000 
                    LBSR     PLY_PS_CALCULATEFREQUENCY_TESTMANUALFREQUENCY 
                    stu      [PLY_FREQ_REG]               ; set frequency - u gotton from above jsr 
                    jmp      out_sound 

; u current track pitch
; X is pointer to instrument
; B = first byte of instrument + one ror
;**********          
;HARD SOUND          
;**********          
PLY_PS_HARD 
                                                          ;We don't set the Volume to 16 now because we may have reached the end of the sound ! 
                    RORB                                  ;Test Retrig here, it is common to every Hard sounds. 
                    BCC      PLY_PS_HARD_NORETRIG 
;Retrig only if it is the first step in this line of Instrument !
                    LDA      Channel1Data + PLY_TRACK_INSTRUMENTSPEED ; forced first channel pointer 
                    CMPA     Channel1Data + PLY_TRACK_INSTRUMENTSPEEDCPT ; forced first channel pointer 
                    BNE      PLY_PS_HARD_NORETRIG 
                    lda      #PLY_RETRIGVALUE 
                    STA      PLY_PSGREG13_RETRIG 
PLY_PS_HARD_NORETRIG 
                                                          ; Test bit 1 of B Use BITB 
                    bitb     #%00000010                   ;WE DON'T SHIFT THE BITS, SO THAT WE CAN USE THE SAME CODE (FREQUENCY CALCULATION) SEVERAL TIMES. 
                    LBNE     PLY_PS_HARD_LOOPORINDEPENDENT 
                    lda      #$10 
                    STA      [PLY_VOL_REG] 
                    lda      #%1000 
                    sta      PLY_TRACK_REG_7,y 
                    lda      ,x+ 
;Second Byte :
;76543210
;nssscccc;
;
;n = Noise ?
;s = Inverted Shift (7 - Editor Shift)
;c = Hardware Enveloppe
                    sta      tmp_instrument_second_byte   ;Get the Hardware Envelope waveform. 
                    ANDA     #%1111 
                    STA      PLY_PSGREG13 
                                                          ; Test bit 0 of B Use BITA or BITB 
                    bitb     #%00000001 
                    BEQ      PLY_PS_HARDWAREDEPENDENT 
;upon entry in  
; x instrumentpointer after second byte of current data
; a = second byte (also in tmp_instrument_second_byte)
; b = first byte ror *2
; y = pointer to current frequency register of channel 
; u = current track pitch
;************        
;SOFTWARE DEP        
;************        
                                                          ;MANUAL FREQUENCY ? -2 BECAUSE THE BYTE HAS BEEN SHIFTED PREVIOUSLY. 
                    bitb     #%00000100 
                    JSR      PLY_PS_CALCULATEFREQUENCY_TESTMANUALFREQUENCY 
                                                          ; in u current frequency in little endian format, ready to be written to PSG 
                    stu      [PLY_FREQ_REG] 
                                                          ; check for HW pitch and remember 
                    BITB     #%00100000                  
                    pshs     cc 
                    LDb      tmp_instrument_second_byte   ;0 reload second byte of current instrument data 
; encoded in bit 4 - 6 shift 3 times -> *2
; shift is stored in inverse, 7 - shift
                    LSRb     
                    LSRb     
                    LSRb     
                    ANDb     #%01110                      ; blend out all other data 
                    clra     
                    addd     #PLY_PS_SD_SHIFT_ADREESS 
                    exg      u,d                          ; shifts only possible with u->D 
                    exg      a,b                          ; to big endian 
                    jmp      ,u 

PLY_PS_SD_SHIFT_ADREESS 
                    LSRA     
                    RORB     
                    LSRA     
                    RORB     
                    LSRA     
                    RORB     
                    LSRA     
                    RORB     
                    LSRA     
                    RORB     
                    LSRA     
                    RORB     
                    LSRA     
                    RORB     
                    BCC      no_shift_carry_sd 
                    addd     #1 
no_shift_carry_sd 
; in d now frequency software, shifted X times, in big endian order
;Hardware Pitch ?
                    puls     cc 
                    BEQ      PLY_PS_SD_NOHARDWAREPITCH 
;Get Pitch and add it to the just calculated Hardware Frequency.
                    addd     ,x++ 
PLY_PS_SD_NOHARDWAREPITCH 
                    exg      a,b                          ; correct endianness of calculated frequency to little endian for PSG poke 
                    STD      PLY_PSGREG11 
PLY_PS_SD_NOISE 
                    lda      tmp_instrument_second_byte   ; second byte of instrument reloaded 
                    BITA     #%10000000                   ; any noise? 
                    BEQ      ret_nla_here 
                    LDA      ,X+ 
                    STA      PLY_PSGREG6 
                    clr      PLY_TRACK_REG_7,y 
ret_nla_here 
; NOTE:
; y is not set to point to psg registers anymore - 
; but at this point is not needed anymore
;        RTS    
                    jmp      out_sound 

;upon entry in  
; x instrumentpointer after second byte of current data
; a = second byte (also in tmp_instrument_second_byte)
; b = first byte ror *2
; y = pointer to current frequency register of channel 
; u = current track pitch
;************       
;HARDWARE DEP       
;************       
PLY_PS_HARDWAREDEPENDENT 
                                                          ;MANUAL HARDWARE FREQUENCY ? -2 BECAUSE THE BYTE HAS BEEN SHIFTED PREVIOUSLY. 
                    bitb     #%00000100 
                    jsr      PLY_PS_CALCULATEFREQUENCY_TESTMANUALFREQUENCY 
                                                          ; in u current frequency in little endian format, ready to be written to PSG 
                    STU      PLY_PSGREG11                 ;CODE HARDWARE FREQUENCY. 
; test for softwarepitch and remember result (we lose b below, an save a reload - save? puls push???)
                    BITB     #%00100000 
                    pshs     cc 
                    ldb      tmp_instrument_second_byte   ;0 reload second byte of current instrument data 
;Second Byte :
;76543210
;nssscccc
;
;n = Noise ?
;s = Inverted Shift (7 - Editor Shift)
;c = Hardware Enveloppe
; encoded in bit 4 - 6 shift 3 times -> *2
; shift is stored in inverse, 7 - shift
                    LSRb     
                    LSRb     
                    LSRb     
                    ANDb     #%01110 
                    clra     
                    addd     #PLY_PS_HD_SHIFT_ADREESS 
                    exg      u,d                          ; shifts only possible with u->D 
                    exg      a,b                          ; to big endian 
                    jmp      ,u 

PLY_PS_HD_SHIFT_ADREESS 
                    ASLB     
                    ROLA     
                    ASLB     
                    ROLA     
                    ASLB     
                    ROLA     
                    ASLB     
                    ROLA     
                    ASLB     
                    ROLA     
                    ASLB     
                    ROLA     
                    ASLB     
                    ROLA     
; in d the shifted frequency in big endian format
; software pitch configured?
                    puls     cc 
                    BEQ      PLY_PS_HD_NOSOFTWAREPITCH 
;Get Pitch and add it to the just calculated Hardware Frequency.
                    addd     ,x++ 
PLY_PS_HD_NOSOFTWAREPITCH 
                    exg      a,b                          ; correct endianness of calculated frequency to little endian for PSG poke 
                    std      [PLY_FREQ_REG] 
                    bra      PLY_PS_SD_NOISE 

PLY_PS_HARD_LOOPORINDEPENDENT 
                                                          ;Test bit 0 of B Use BITA or BITB 
                    BITB     #%00000001 
                    BEQ      PLY_PS_INDEPENDENT 
                    ldx      ,x 
                    jmp      PLY_PLAYSOUND 

; u current track pitch
; X is pointer to instrument
; B = first byte of instrument + 2 ror
;***********        
;INDEPENDENT        
;***********        
; in b shifted twice:
;------------------
;76543210
;spam10r1
;
;After shifting (done twice):
;76543210
;--spam10		(spam, ahah).
;
;
;s = Sound ? If Sound? = 0, no need to take care of Software Manual Frequency, Pitch and Arpeggio.
;m = Manual Frequency? (if 1, Arpeggio and Pitch not read). Manual Frequency can only be present if Sound? = 1.
;a = Arpeggio?
;p = Pitch?
;r = Retrig?
PLY_PS_INDEPENDENT 
                    lda      #$10 
                    STA      [PLY_VOL_REG] 
;        Test bit 7-2 of B  
                    BITB     #%00100000 
                    BNE      PLY_PS_I_SOUNDON 
                    lda      #%1001 
                    sta      PLY_TRACK_REG_7,y 
                    BRA      PLY_PS_I_SKIPSOFTWAREFREQUENCYCALCULATION 

PLY_PS_I_SOUNDON 
                    lda      #%1000 
                    sta      PLY_TRACK_REG_7,y 
; hardare calculation expects one frequency calculation already being done -> u than is little endian!
                    exg      d,u 
                    exg      a,b 
                    exg      d,u 
                    LDA      PLY_TRACK_NOTE,y 
;        Test bit 4-2 of B Use BITA or BITB   
                    BITB     #%00000100 
                    bsr      PLY_PS_CALCULATEFREQUENCY_TESTMANUALFREQUENCY 
                                                          ; in u current frequency in little endian format, ready to be written to PSG 
                    stu      [PLY_FREQ_REG]               ; write software note with its frequency to PSG 
PLY_PS_I_SKIPSOFTWAREFREQUENCYCALCULATION 
; load second byte of independend instrument data
; B after load = :
;76543210
;npamcccc
;
;n = Noise ?
;p = Hardware Pitch?
;a = Hardware Arpeggio?
;m = Manual Hardware Frequency? (if 1, Arpeggio and Pitch not read).
;c = Hardware Enveloppe
                    LDB      ,X+ 
                    TFR      B,A 
                    ANDA     #%1111 
                    STA      PLY_PSGREG13 
                    RORB     
                    RORB     
                    exg      d,u 
                    exg      a,b 
                    exg      d,u 
                                                          ;MANUAL HARDWARE FREQUENCY ? -2 BECAUSE THE BYTE HAS BEEN SHIFTED PREVIOUSLY. 
                    BITB     #%00000100 
                    bsr      PLY_PS_CALCULATEFREQUENCY_TESTMANUALFREQUENCY 
                                                          ; b stays the same during frequency test 
                                                          ; in u current frequency in little endian format, ready to be written to PSG 
                    STu      PLY_PSGREG11                 ;CODE HARDWARE FREQUENCY. 
                    BITB     #%00100000 
                    BEQ      outahere_1 
                    LDA      ,X+ 
                    STA      PLY_PSGREG6 
                    lda      PLY_TRACK_REG_7,y 
                    anda     #%11110111 
                    sta      PLY_TRACK_REG_7,y 
outahere_1 
out_sound 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    dec      PLY_TRACK_INSTRUMENTSPEEDCPT , y 
                    BNE      PLY_TRACK_PLAYNOFORWARD 
                    STX      PLY_TRACK_INSTRUMENT , y 
                    LDA      PLY_TRACK_INSTRUMENTSPEED , y 
                    STA      PLY_TRACK_INSTRUMENTSPEEDCPT , y 
PLY_TRACK_PLAYNOFORWARD 
                    leay     -ArkosChannel, y 
                    cmpy     #Channel1Data-ArkosChannel 
                    beq      doneplaying 
                    ldd      PLY_FREQ_REG 
                    subd     #2 
                    std      PLY_FREQ_REG 
                    ldd      PLY_VOL_REG 
                    subd     #1 
                    std      PLY_VOL_REG 
                    jmp      playnextchannel 

doneplaying 
                    lda      PLY_TRACK_REG_7 +Channel3Data 
                    ASLA     
                    ORA      PLY_TRACK_REG_7 +Channel2Data 
                    ROLA     
                    ORA      PLY_TRACK_REG_7 +Channel1Data 
;SEND THE REGISTERS TO PSG.
PLY_SENDREGISTERS 
;A=REGISTER 7       
                    STORE_PSG  7 
                    lda      PLY_PSGREG13 
                    CMPA     PLY_PSGREG13_RETRIG          ;IF ISRETRIG?, FORCE THE R13 TO BE TRIGGERED. 
                    BEQ      backFromPlayer 
                    STA      PLY_PSGREG13_RETRIG 
                    STORE_PSG  13 
; destroy shadow - otherwise 13 on same is not retriggered
                    lda      #$ff 
                    sta      Vec_Snd_Shadow+13 
backFromPlayer 
playMusic_NOk_m_pac
                    RTS      

;Subroutine that =
;If Manual Frequency? (Flag Z off), read frequency (Word) and adds the TrackPitch.
;Else, Auto Frequency.
;	if Arpeggio? = 1 (bit 3 from B), read it (Byte).
;	if Pitch? = 1 (bit 4 from B), read it (Word).
;	Calculate the frequency according to the Note + Arpeggio + TrackPitch.
; U track pitch
; X pointer to instrument data
;
;RET=
;X = Instrument pointer.
;u current frequency in little endian order, ready to be written to psg
; y,b stays same
PLY_PS_CALCULATEFREQUENCY_TESTMANUALFREQUENCY 
                    lBEQ      PLY_PS_CALCULATEFREQUENCY 
;Manual Frequency. We read it, no need to read Pitch and Arpeggio.
;However, we add TrackPitch to the read Frequency, and that's all.
                    exg      u,d 
                    addd     ,X++ 
                    exg      a,b                          ; switching endian anyway because PSG regs are sortof little endian 
                    exg      u,d 
                    RTS      
; in u address of song 
PLY_INIT_ALL
;Header
;------
;DB "AT10"
;DB SampleChannel (1,2,3)
;DB*3 YM Clock (little endian. 1000000=CPC, 1750000=Pentagon 128K, 1773400=ZX Spectrum/MSX, 2000000=Atari ST, or any other in case of custom frequency).
;DB ReplayFrequency(0=13hz,1=25hz,2=50hz,3=100hz,4=150hz,5=300hz)
;DB Speed (>=1)
;dw Instruments Chunk Size (not including this Word)
;
;{
;    dw Pointers on Instruments
;} * nbInstruments
;
;{
;    ds InstrumentData (see the Instrument structure below)
;} * nbInstruments
; Linker...
; vectrex conversion skips the 9 "header" bytes and we start of directly at SPEED
initCodeModifications 
; these inits are by the original player "inherent"
; since it uses selfmodifying code and the
; init values are present in the code itself
                    ldx      #arkosPlayerMemStart 
                    ldd      #(arkosPlayerMemEnd-arkosPlayerMemStart+1) 
                    jsr      Clear_x_d 
                    ldd      #$0101 
                    std      PLY_SPEEDCPT 
                    std      PLY_HEIGHT 
                    sta      Channel1Data+PLY_TRACK_INSTRUMENTSPEEDCPT 
                    sta      Channel2Data+PLY_TRACK_INSTRUMENTSPEEDCPT 
                    sta      Channel3Data+PLY_TRACK_INSTRUMENTSPEEDCPT 
                    lda      #6 
                    sta      Channel1Data+PLY_TRACK_INSTRUMENTSPEED 
                    sta      Channel2Data+PLY_TRACK_INSTRUMENTSPEED 
                    sta      Channel3Data+PLY_TRACK_INSTRUMENTSPEED 
                    lda      #PLY_RETRIGVALUE 
                    sta      PLY_PSGREG13_RETRIG 
; no the player init
                    lda      ,u+ 
                    sta      PLY_SPEED                    ;Copy Speed. 
                    ldd      ,u++                         ;Get Instruments chunk size. 
                    stu      PLY_TRACK_INSTRUMENTSTABLEPT 
                    leau     d,u                          ;Skip Instruments to go to the Linker address. 
                                                          ;Get the pre-Linker information of the first pattern. 
;Pre-Linker
;----------
;First comes a unique bloc, just before the real Linker, and only used at the initialisation of the song. It is used to optimise the Looping of the song.
;
;DB First Height
;DB Transposition1
;DB Transposition2
;DB Transposition3
;DW Special Track
;after that the first pattern starts...
                    ldd     ,u++
                    sta      PLY_HEIGHT 
                    stb      Channel1Data + PLY_TRANSPOSITION 
                    ldd      ,u++
                    sta      Channel2Data + PLY_TRANSPOSITION 
                    stb      Channel3Data + PLY_TRANSPOSITION 
                    ldd      ,u++ 
                    std      PLY_SAVESPECIALTRACK 
;Store the Linker address.
                    STu      PLY_LINKER_PT 
                    lda      #$ff                         ; make sure the hardware envelope is in an "unkown" state 
                    STA      PLY_PSGREG13 
;Set the Instruments pointers to Instrument 0 data (Header has to be skipped).
                    LDX      PLY_TRACK_INSTRUMENTSTABLEPT 
                    ldx      ,x 
                                                          ;Skip Instrument 0 Header. 
                    leax     2,x 
                    STX      Channel1Data + PLY_TRACK_INSTRUMENT 
                    STX      Channel2Data + PLY_TRACK_INSTRUMENT 
                    STX      Channel3Data + PLY_TRACK_INSTRUMENT 
                    RTS      

PLY_STOP 
                    ldd      #00 
                    std      PLY_PSGREG8 
                    std      PLY_PSGREG9 
                    std      PLY_PSGREG10 
                    lda      #%00111111 
                    jmp      PLY_SENDREGISTERS 
