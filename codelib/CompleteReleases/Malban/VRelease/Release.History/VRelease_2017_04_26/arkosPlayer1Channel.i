; this file is part of Release, written by Malban in 2017
;
; This is more or lesse the same as the "complete" Arkos player
; only this one assumes only music played is on channel 1
;
Vec_Music_Work      EQU      $C83F                        ;Music work buffer (14 bytes, backwards?) 
STORE_PSG           macro    register 
                    sta      (Vec_Music_Work + register) 
                    endm     
;
CLEAR_CARRY         macro    
                    ANDCC    #$FE 
                    endm     
;
SET_CARRY           macro    
                    ORCC     #$01 
                    endm     
;
MY_LSL_D            macro    
                    LSLB     
                    ROLA     
                    endm                                  ; done 

                    code     
PLY_RETRIGVALUE     EQU      #$FE                         ; some value greater than 0x0f 


PLY_PLAY_1CHANNEL_PART1 
                    ldy      #Channel1Data 
;Manage Speed. If Speed counter is over, we have to read the Pattern further.
                    dec      PLY_SPEEDCPT 
                    lbne     PLY_SPEEDEND_CH1 
;Moving forward in the Pattern. Test if it is not over.
                    dec      PLY_HEIGHTCPT 
                    BNE      PLY_HEIGHTEND_CH1 
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
                    BCC      PLY_SONGNOTOVER_CH1 
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
PLY_SONGNOTOVER_CH1: 
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
                    LDu      ,X
                    STu      Channel1Data + PLY_TRACK_PT 
                   leax 6,x
                    bita #$08                                 
                    beq      PLY_NONEWHEIGHT_CH1 
                    LDB      ,X+ 
                    STB      PLY_HEIGHT 
PLY_NONEWHEIGHT_CH1: 
                    bita #$10                                 
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
                    LDA      PLY_HEIGHT 
                    STA      PLY_HEIGHTCPT 
PLY_HEIGHTEND_CH1: 



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
_read_special_track_CH1 
;Read the Special Track.
                    dec      PLY_SPECIALTRACK_WAITCOUNTER 
                    BNE      PLY_SPECIALTRACK_DONE_CH1 
                    LDX      PLY_SPECIALTRACK_PT 
                    LDA      ,X+ 
                    LSRA                                  ; if b0=0 -> carry will be clear -> jump to WAIT 
                    BCC      PLY_SPECIALTRACK_NEWWAIT_CH1 
                    LSRA                                  ; regardless if speed or digidrum -> if a right shift results in 0 A, than we have an escape situation, if not -> jump 
                    BNE      PLY_SPECIALTRACK_NOESCAPECODE_CH1 
                    LDA      ,X+                          ; load the escaped (additional) value 
PLY_SPECIALTRACK_NOESCAPECODE_CH1 
; if carry was set by the last right shift, the special track
; denotes a digidrum, since it is not supported
; we just ignore it and jump to the end
                    bcs      PLY_PT_SPECIALTRACK_ENDDATA_CH1 
PLY_SPECIALTRACK_SPEED_CH1 
                    STA      PLY_SPEED                    ; the data we got was the speed - store it 
PLY_PT_SPECIALTRACK_ENDDATA_CH1 
                    LDA      #$1                          ; reset wait counter, next round might be more waiting :-) 
PLY_SPECIALTRACK_NEWWAIT_CH1 
                    STX      PLY_SPECIALTRACK_PT          ; is this used anywhere? 
                    STA      PLY_SPECIALTRACK_WAITCOUNTER 
PLY_SPECIALTRACK_DONE_CH1 
readnextchannel_CH1 
_read_track_CH1 
;Read the Track 1.
;-----------------
;Store the parameters, because the player below is called every frame, but the Read Track isn't.
                    dec      PLY_TRACK_WAITCOUNTER,y
                    lBNE     PLY_TRACK_NEWINSTRUMENT_WAIT_CONT_CH1 
                    LDX      PLY_TRACK_PT, y 
PLY_READTRACK_CH1 
                    LDb      ,X+ 
                    LSRb                                  ;Full Optimisation ? If yes = Note only, no Pitch, no Volume, Same Instrument. 
                    BCS      PLY_READTRACK_FULLOPTIMISATION_CH1 
                    SUBb     #32                          ;0-31 = Wait. 
                    BCS      PLY_READTRACK_WAIT_CH1 
                    BEQ      PLY_READTRACK_NOOPTIMISATION_ESCAPECODE_CH1 
                    DECb                                  ;0 (32-32) = Escape Code for more Notes (parameters will be read) 
;Note. Parameters are present. But the note is only present if Note? flag is 1.
;Read Parameters
PLY_READTRACK_READPARAMETERS_CH1 
                    LDA      ,X+ 
                    sta      tmp_track_param              ;Save Parameters. 
                    bita     #$80                         ; is pitch following? -> load it 
                    beq      PLY_READTRACK_PITCH_END_CH1 
                    ldu      ,x++ 
                    stu      PLY_TRACK_PITCHADD,y 
PLY_READTRACK_PITCH_END_CH1 
                    bita     #$20                         ; is instrument following? -> load it 
                    beq      do_continue_p_vol_CH1 
; in a original parameter
; use it to correct volume, if any
; befor "destroying" a with instrument data
                    RORA                                  ;Volume ? If bit 4(0?) was 1, then volume exists on b3-b0 - inverted volume 
                    BCC      PLY_TRACK_SAMEVOLUME_2_CH1 
                    ANDA     #%1111 
                    STA      PLY_TRACK_VOLUME , y 
PLY_TRACK_SAMEVOLUME_2_CH1 
                    LDA      ,X+ 
                    sta      tmp_track_instrument 
                    bra      do_continue_p_vol_done_CH1 

PLY_READTRACK_NOOPTIMISATION_ESCAPECODE_CH1 
                    LDb      ,X+                          ; load note to B 
                    BRA      PLY_READTRACK_READPARAMETERS_CH1 

;---------  
PLY_READTRACK_FULLOPTIMISATION_CH1 
                    STX      PLY_TRACK_PT, y 
                    clra                                  ; is param now, no need to save - accessed directly in full opt 
                    SUBb     #$1 
                    BCC      full_opt_note_given_CH1 
                    LDb      ,X+ 
;cc_out_save_note
                                                          ; no pitch 
                                                          ; no vol 
                                                          ; but certainly note 
                    bra      full_opt_note_given_CH1 

;---------  
PLY_READTRACK_WAIT_CH1 
                    ADDb     #32 
                    SET_CARRY  
                    STX      PLY_TRACK_PT, y 
                    bra      PLY_TRACK_NEWINSTRUMENT_SETWAIT_CH1 

do_continue_p_vol_CH1 
; in b now note - if any
; in a original parameter
                    RORA                                  ;Volume ? If bit 4(0?) was 1, then volume exists on b3-b0 - inverted volume 
                    BCC      PLY_TRACK_SAMEVOLUME_1_CH1 
                    ANDA     #%1111 
                    STA      PLY_TRACK_VOLUME , y 
PLY_TRACK_SAMEVOLUME_1_CH1 
do_continue_p_vol_done_CH1 
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
                    beq      PLY_TRACK_NONOTEGIVEN_CH1 
full_opt_note_given_CH1 
                    ADDb     PLY_TRANSPOSITION, y         ;Transpose Note according to the Transposition in the Linker. 
                    STb      PLY_TRACK_NOTE, y 
                    LDX      #$0                          ;Reset the TrackPitch. 
                    STX      PLY_TRACK_PITCH , y 
                    bita     #$20                         ;New Instrument ?; 
                    bne      PLY_TRACK_NEWINSTRUMENT_CH1 
                    LDX      PLY_TRACK_SAVEPTINSTRUMENT, y ;Same Instrument. We recover its address to restart it. 
                    LDA      PLY_TRACK_INSTRUMENTSPEED, y ;Reset the Instrument Speed Counter. Never seemed useful... 
                    STA      PLY_TRACK_INSTRUMENTSPEEDCPT , y 
                    BRA      PLY_TRACK_INSTRUMENTRESETPT_CH1 

PLY_TRACK_NEWINSTRUMENT_CH1                                   ;New  Instrument. We have to get its new address, and Speed. 
                    clra     
                    ldb      tmp_track_instrument 
                    MY_LSL_D  
                    LDX      PLY_TRACK_INSTRUMENTSTABLEPT 
                    ldx      d,x 
                    lda      ,x+ 
                    STA      PLY_TRACK_INSTRUMENTSPEED , y 
                    STA      PLY_TRACK_INSTRUMENTSPEEDCPT , y 
                    STX      PLY_TRACK_SAVEPTINSTRUMENT, y ;When using the Instrument again, no need to give the Speed, it is skipped. ;WHEN USING THE INSTRUMENT AGAIN, NO NEED TO GIVE THE SPEED, IT IS SKIPPED. 
PLY_TRACK_INSTRUMENTRESETPT_CH1 
                    LDA      ,X+ 
                    BEQ      noIntrumentRetrigger_CH1 
                    STA      PLY_PSGREG13_RETRIG 
noIntrumentRetrigger_CH1 
                    STX      PLY_TRACK_INSTRUMENT, y 
PLY_TRACK_NONOTEGIVEN_CH1 
                    LDb      #$1             
PLY_TRACK_NEWINSTRUMENT_SETWAIT_CH1 
                    STb      PLY_TRACK_WAITCOUNTER , y   
PLY_TRACK_NEWINSTRUMENT_WAIT_CONT_CH1 
;                    leay     ArkosChannel, y 
;                    cmpy     #ChannelDataEnd 
;                    lbne     readnextchannel 
                    LDA      PLY_SPEED 
                    STA      PLY_SPEEDCPT 
PLY_SPEEDEND_CH1 
                    ldd      #PLY_PLAY_1CHANNEL_PART2 
                    std      inMovePointer 
 rts
;*****************************************************************************************************
;*****************************************************************************************************
;*****************************************************************************************************

PLY_PLAY_1CHANNEL_PART2
 pshs u,x
                    ldy      #Channel1Data 
PLY_PLAY_1CHANNEL_PART2_woy
;                    LDD      #PLY_PSGREGISTERSARRAY; + 4 
;                    std      PLY_FREQ_REG 
;                    ldd      #PLY_PSGREGISTERSARRAY+8; + 10 
;                    std      PLY_VOL_REG 
;                    LDY      #Channel3Data 
playnextchannel_CH1 
_play_sound_track_CH1
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
PLY_PLAYSOUND_CH1: 
;instrument 
;DB FirstByte
;if b0=0, NON-HARD sound. If b0=1, HARD Sound.
                    LDB      ,X+ 
                    RORB     
                    BCS      PLY_PS_HARD_CH1 
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
                    BCS      PLY_PS_S_SECONDBYTENEEDED_CH1    ; if yes jump to read second byte 
                    TFR      B,A                          ; for volume check copy the first byte to a 
                    ANDA     #%1111                       ; 
                    BNE      PLY_PS_S_SOUNDON_CH1             ; if is 0 than no sound at all 
                                                          ;Null Volume. It means no Sound. We stop the Sound, the Noise, and it's over. 
;                    STA      [PLY_VOL_REG]                ;We have to make the volume to 0, because if a bass Hard was activated before, we have to stop it. 
                    sta      (Vec_Music_Work + 8) 
                    lda      #%1001                       ; these are the register mask bits for this sound (or this no sound) 
                    sta      PLY_TRACK_REG_7,y 
                    bra      out_sound_CH1 

; A = volume
PLY_PS_S_SOUNDON_CH1: 
; Volume is here, no Second Byte needed. It means we have a simple Software sound (Sound = On, Noise = Off)
; We have to test Arpeggio and Pitch, however.
                    SUBA     PLY_TRACK_VOLUME,y           ; tmp_volumeN ;Code Volume. volume of instrument minus inverted volume 
                    BCC      vol_not_null_1_CH1 
                    CLRA     
vol_not_null_1_CH1 
;                    STA      [PLY_VOL_REG] 
                    sta      (Vec_Music_Work + 8) 
                    LDA      #%1000 
                    sta      PLY_TRACK_REG_7,y 
                    RORB                                  ;Needed for the subroutine to get the good flags. 
                    BSR     PLY_PS_CALCULATEFREQUENCY 
; in u frequency + pitch, in little endian order, ready to be written to psg
                    stu      (Vec_Music_Work + 0) 
;  stu      [PLY_FREQ_REG] 
                    bra      out_sound_CH1 

PLY_PS_S_SECONDBYTENEEDED_CH1 
                    LDA      #%1000 
                    sta      PLY_TRACK_REG_7,y 
; A second byte of instrument data
                    LDA      ,X+ 
                    ANDA     #%11111 
                    BEQ      PLY_PS_S_SBN_NONOISE_CH1 
                    STA      PLY_PSGREG6 
                    clr      PLY_TRACK_REG_7,y 
PLY_PS_S_SBN_NONOISE_CH1: 
                    TFR      B,A 
                    ANDA     #%1111 
                    SUBA     PLY_TRACK_VOLUME,y 
                                                          ;CODE VOLUME. 
                    BCC      no_vol_underflow_1_CH1 
                    CLRA     
no_vol_underflow_1_CH1
;                    STA      [PLY_VOL_REG] 
                    sta      (Vec_Music_Work + 8) 
                    lda      -1,x 
                    bita     #%00100000 
                    BNE      PLY_PS_S_SBN_SOUND_CH1 
                    inc      PLY_TRACK_REG_7,y 
                    bra      out_sound_CH1 

PLY_PS_S_SBN_SOUND_CH1 
                    RORB                                  ;Needed for the subroutine to get the good flags. 
                    bita     #%01000000 
                    BSR     PLY_PS_CALCULATEFREQUENCY 
                    stu      (Vec_Music_Work + 0) 
;                    stu      [PLY_FREQ_REG]               ; set frequency - u gotton from above jsr 
                    bra      out_sound_CH1 

; u current track pitch
; X is pointer to instrument
; B = first byte of instrument + one ror
;**********          
;HARD SOUND          
;**********          
PLY_PS_HARD_CH1 
                    ldx      ,x 
                    bra      PLY_PLAYSOUND_CH1 

outahere_1_CH1 
out_sound_CH1 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    dec      PLY_TRACK_INSTRUMENTSPEEDCPT , y 
                    BNE      PLY_TRACK_PLAYNOFORWARD_CH1 
                    STX      PLY_TRACK_INSTRUMENT , y 
                    LDA      PLY_TRACK_INSTRUMENTSPEED , y 
                    STA      PLY_TRACK_INSTRUMENTSPEEDCPT , y 
PLY_TRACK_PLAYNOFORWARD_CH1 

doneplaying_CH1 
 lda (Vec_Music_Work + 7)
 anda #%00111110
; lda #$3e
                    STORE_PSG  7 
                    ldd      #emptyStreamInMove 
                    std      inMovePointer 
 puls u,x
 rts



PLY_PLAY_1CHANNEL: 
                    tst      musicOption 
                    bne      playMusic_NOk_m_p1c 

 jsr PLY_PLAY_1CHANNEL_PART1 
 jmp PLY_PLAY_1CHANNEL_PART2_woy
playMusic_NOk_m_p1c
                    RTS      

; in tmp_de all pitches together
; pitch is a frequency modifier
; arepgio is also a frequency modifier but indirect thru a note change
;X Pointer to Instrument Data
;U current track pitch
;B = first byte of instrument data (ROR *3) (when from SOFTWARE SOUND)
;Note (tmp_noteVolumne)
;Inverted Volume (tmp_noteVolumne)
;RET=
;X = Instrument pointer.
;u current frequency in little endian order, ready to be written to psg
; y,b stays same
PLY_PS_CALCULATEFREQUENCY: 
; test for arpegio for later use
                    bitb     #%00001000 
                    pshs     cc, b 
; Pitch ?
; Test bit 5-1 of B Use BITA or BITB  
                    bitb     #%00010000 
                    BEQ      PLY_PS_S_SOUNDON_NOPITCH 
                    LDD      ,X++ 
                    leau     d,u 
PLY_PS_S_SOUNDON_NOPITCH: 
;Arpeggio ?
                    LDb      PLY_TRACK_NOTE,y 
                    puls     cc                           ; reuse arpegio test from above 
                    BEQ      PLY_PS_S_SOUNDON_ARPEGGIOEND 
                    ADDb     ,X+                          ;ADD ARPEGGIO TO NOTE. 
                    CMPb     #144                         ; was max note reached? 
                    BCS      no_max_appegio 
                    LDb      #143                         ; if so set max note 
no_max_appegio 
PLY_PS_S_SOUNDON_ARPEGGIOEND: 
                    clra     
                                                          ; in d now the note inclusive the arpegio 
                    MY_LSL_D                              ; for pointer in table double it 
                    addd     #PLY_FREQUENCYTABLE 
                    exg      u,d 
                    addd     ,u 
                    exg      a,b                          ; switching en dian anyway because PSG regs are sortof little endian 
                    tfr      d,u 
                    puls     b, pc 
                    RTS      

PLY_FREQUENCYTABLE 
; Vectrex
; generated by using a PSG divider 16 and 1500000 Hz
                    dw       4095 ,4095 ,4095,4095,4095,4095,4054,3827,3612,3409,3218 ,3037 
                    dw       2867 ,2706,2554,2411,2275,2148,2027,1913,1806,1705,1609,1519 
                    dw       1433,1353,1277,1205,1138,1074,1014,957,903,852,804,759 
                    dw       717,676,638,603,569,537,507,478,451,426,402,380 
                    dw       358,338,319,301,284,268,253,239,226,213,201,190 
                    dw       179,169,160,151,142,134,127,120,113,107,101,95 
                    dw       90,85,80,75,71,67,63,60,56,53,50,47 
                    dw       45,42,40,38,36,34,32,30,28,27,25,24 
                    dw       22,21,20,19,18,17,16,15,14,13,13,12 
                    dw       11,11,10,9,9,8,8,7,7,7,6,6 
                    dw       6,6,6,5,5,5,4,4,4,4,4,3 
                    dw       4,3,3,3,3,3,2,2,2,2,2,2 
; use this to compare generated YM files with tracker
; CPC
;                    dw       3822,3608,3405,3214,3034,2863,2703,2551,2408,2273,2145,2025 
;                    dw       1911,1804,1703,1607,1517,1432,1351,1276,1204,1136,1073,1012 
;                    dw       956,902,851,804,758,716,676,638,602,568,536,506 
;                    dw       478,451,426,402,379,358,338,319,301,284,268,253 
;                    dw       239,225,213,201,190,179,169,159,150,142,134,127 
;                    dw       119,113,106,100,95,89,84,80,75,71,67,63 
;                    dw       60,56,53,50,47,45,42,40,38,36,34,32 
;                    dw       30,28,27,25,24,22,21,20,19,18,17,16 
;                    dw       15,14,13,13,12,11,11,10,9,9,8,8 
;                    dw       7,7,7,6,6,6,5,5,5,4,4,4 
;                    dw       4,4,3,3,3,3,3,2,2,2,2,2 
;                    dw       2,2,2,2,1,1,1,1,1,1,1,1 
*******************
; in u address of song 
PLY_INIT_CH1 
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
initCodeModifications_CH1  
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


 lda (Vec_Music_Work + 7)
 lda #$3f
                    STORE_PSG  7 
                    RTS      

decode_1ChannelRest

decode_on: 
                    jsr      [inMovePointer] 
                    ldd      inMovePointer 
                    cmpd     #emptyStreamInMove 
                    bne      decode_on 
no_decode 
                    rts    
