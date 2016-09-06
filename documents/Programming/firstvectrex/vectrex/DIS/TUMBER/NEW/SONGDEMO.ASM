; Song Demo
; by Christopher L. Tumber
; Last update: July 1, 1998
;
; Plays a "song" using three voices. This is my new and improved song
; playing routine. I'll post full instructions and docs later. A compiled
; version will show up on my web site shortly.
;
;****************************************************************************
; Section from Malban...
;
; Random thought:
; one thought might be to put the duration within the music structure...
; this way each voice could have different durations...
; I dunno what that could be used for... but well...
;
; this version was changed to fit the below assembler,
; also some documentation added...
;
; actually pretty much changed, the whole data structure and the
; function itself looks a bit different, though I can asure you, that
; the core is the same, even if it looks different.
;
; the main difference is, it uses no only one function to play a voice
; instead of three, and it doesn't use any user RAM anymore (though BIOS RAM)
; some data neccessary for the music must now be handled in the ROM area,
; but only the static stuff...
;
; as far as my changes are concerned this program is public domain, but
; the original version was done by Christopher L. Tumber, though he
; didn't put any copyright notices in his source, I guess he would
; mind if this was alltogether put in the public domain.
; so... if you use this source in any way, please give him some credit at
; least...
;
; the mentioned changes were done by: Malban, August 1998
; comments and vectrex talk are welcome
; my email: xxxx@aol.com
;
; followin command line was used to assemble:
;
; C:>as09.exe -h0 -l -cti songdemo.asm >error
;
; I used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
;****************************************************************************

                INCLUDE "VECTREX.I"        ; vectrex function includes

BIOS_music_data         EQU     $FC8D      ; here are the BIOS notes...

; Song structure to save RAM for loss in ROM, this structure must be used in
; the ROM area of your vectrex program
NOTES           EQU 0                      ; 2 (lengths...)
VOICE           EQU 2                      ; 1
WHOLE_ADSR      EQU 3                      ; 2
HALF_ADSR       EQU 5                      ; 2
QUARTER_ADSR    EQU 7                      ; 2
EIGHTH_ADSR     EQU 9                      ; 2
SIXTEENTH_ADSR  EQU 11                     ; 2

; Song structure in RAM
MUSIC           EQU 0                      ; 2 (pointer to the above ROM structure)
POS             EQU 2                      ; 2
COUNT           EQU 4                      ; 1
DUR             EQU 5                      ; 1

; Duration comes in the music data 1 after the actual note...
NOTE_DURATION   EQU 1

; some defines for readability...
WHOLE_NOTE      EQU 0
HALF_NOTE       EQU 1
QUARTER_NOTE    EQU 2
EIGHTH_NOTE     EQU 3
SIXTEENTH_NOTE  EQU 4

VOLUME_BASE     EQU 7                      ; actually it should be eight,
                                           ; but we add the current voice to
                                           ; it, and we start at 1, so
                                           ; 7 + 1 is the BASE = 8...
                                           ; silly me :-)
; since we use our own sound routine, the BIOS RAM locations for
; sound are not used... we might as well use these locations for
; our data, so we don't waste 'our'-own RAM...
; here a mirror table for easier conversion...
;
voice1_ram_structur EQU Vec_ADSR_Table
voice2_ram_structur EQU Vec_Music_Chan
voice3_ram_structur EQU Vec_Expl_4

                 ORG     $0000

;****************************************************************************

; start of vectrex memory with cartridge name...
                 DB      "g GCE 1998", $80 ; 'g' is copyright sign
                 DW      music             ; our own SHORT intro music
                 DB      $F8, $50, $30, $B8; hight, width, rel y, rel x (from 0,0)
                 DB      "SONG DEMO 2", $80; some information, ending with $80
                 DB      0                 ; end of header

; here the cartridge program starts off

;****************************************************************************

                 JSR     setup_intro_mus   ; initialize our music structures
main:
                 LDA     #$c8              ; This is equivalent to jsr dptoD0
                 TFR     A,DP              ; But inlined
                 JSR     Wait_Recal        ; Reset the CRT (not really neccessary for
                                           ; only playing music...)

                 ; now we start each voice with the appropriate music-
                 ; structure loaded in Y (might have been U... what the heck)
                 LDY     #voice1_ram_structur
                 JSR     play_voice
                 LDY     #voice2_ram_structur
                 JSR     play_voice
                 LDY     #voice3_ram_structur
                 JSR     play_voice

                 ; go on forever...
                 BRA     main

;****************************************************************************

; as a matter of fact, the durations can also be in the ROM section,
; since for one game, we probably only have one set of length's
; these are durations of notes, whole is a (well) whole note... and so on :-)
;
; one thought might be to put the duration within the music structure...
; this way each voice could have different durations...
; I dunno what that could be used for... but well...
whole_dur:
                 DB      32                ; duration of a full note
                 DB      16                ; duration of a half note
                 DB       8                ; duration of a quarter note
                 DB       4                ; duration of a eighth note
                 DB       2                ; duration of a sixteenth note

;****************************************************************************

; this is our routine to initialize the structures in vectrex RAM
; here we initialize all three voices...
setup_intro_mus:
                 ; initialize voice 1
                 LDX     #voice1_ram_structur    ; load music structur address
                                                 ; of voice 1 (ram)
                 LDU     #music_structure_voice1 ; load music structure (rom)
                 STU     MUSIC,X                 ; store it in RAM as relevant
                                                 ; music structure for voice 1
                 LDD     ,U                      ; load the notes of music 1
                                                 ; to D
                 STD     POS,X                   ; store it as the beginning
                                                 ; position
                 CLR     COUNT,X                 ; and set the count to zero

                 ; initialize voice 2
                 LDX     #voice2_ram_structur    ; load music structur address
                                                 ; of voice 2 (ram)
                 LDU     #music_structure_voice2 ; load music structure (rom)
                 STU     MUSIC,X                 ; store it in RAM as relevant
                                                 ; music structure for voice 2
                 LDD     ,U                      ; load the notes of music 2
                                                 ; to D
                 STD     POS,X                   ; store it as the beginning
                                                 ; position
                 CLR     COUNT,X                 ; and set the count to zero

                 ; initialize voice 3
                 LDX     #voice3_ram_structur    ; load music structur address
                                                 ; of voice 3 (ram)
                 LDU     #music_structure_voice3 ; load music structure (rom)
                 STU     MUSIC,X                 ; store it in RAM as relevant
                                                 ; music structure for voice 3
                 LDD     ,U                      ; load the notes of music 3
                                                 ; to D
                 STD     POS,X                   ; store it as the beginning
                                                 ; position
                 CLR     COUNT,X                 ; and set the count to zero
                 RTS

;****************************************************************************
; here are some makro definitions  to make the main music routine a
; bit more readable...
; well the makros are not that well readable... sorry...
; the paramters were neccessary to use the makros for each
; of the three voices, they usually represent some bits in the
; PSG registers (or just a label for jump...)

;----------------------------------------------------------------------------
; checking whether we play a note or be silent...
; go out of makro on note... silence is 'played' here...
NOT_RESTART      macro __a, __b, __c       ; name of macro
                 CMPA    #128              ; in A is the note, that was loaded
                                           ; from the position, a 128 means this is a rest
                                           ; note, silence follows...
                 BNE     \1                ; if no rest... jump (parameter of makro...)
                                           ; no we will be silent with this
                                           ; voice :-)
                 LDB     Vec_Snd_Shadow + 7; Register (shadow) 7 of the PSG:
                                           ; Register R7 is a multi functional
                                           ; Enable register which controls the
                                           ; three Noise/Tone Mixers and the general
                                           ; purpose I/O Port.
                 ORB     #\2               ; Pulse on Voice (parameter of makro...)
                 ORB     #\3               ; No noise on Voice (parameter of makro...)
                 LDA     #$07              ; to register 7 of PSG (shadow)
                 JSR     Sound_Byte        ; store B to register A in soundchip (shadow)
                 endm                      ; end of macro
;----------------------------------------------------------------------------
; checking whether the note is noise or tone...
; go out of makro on tone... noise is played here...
NOT_REST_        macro __a, __b, __c       ; name of macro
                 ANDA    #$40              ; is the 6 bit set? (checking
                                           ; whether tone or noise)
                 BEQ     \1                ; if bit 6 not set... then jump
                                           ; (parameter of makro...)
                 LDB     0,X               ; otherwise we will play noise...
                                           ; load the frequency of the note...
                 ANDB    #$1f              ; that means we discard some of
                                           ; the frequency (AND $1F)
                 LDA     #$06              ; Noise Generator Control Register of PSG
                 JSR     Sound_Byte        ; store B to register A in soundchip (shadow)
                 LDB     Vec_Snd_Shadow + 7; Register (shadow) 7 of the PSG:
                                           ; Register R7 is a multi functional
                                           ; Enable register which controls the
                                           ; three Noise/Tone Mixers and the general
                                           ; purpose I/O Port.
                 ORB     #\2               ; No Pulse on Voice (parameter of makro...)
                 ANDB    #\3               ; Noise on Voice (parameter of makro...)
                 LDA     #$07              ; to register 7 of PSG (shadow)
                 JSR     Sound_Byte        ; store B to register A in soundchip (shadow)
                 endm                      ; end of macro
;----------------------------------------------------------------------------
; this makro playes a note (tone)
TONE             macro __a, __b, __c, __d  ; name of macro
                 LDA     0,X               ; load the frequency of the note...
                 LSLA                      ; multiply it by two
                 LDX     #BIOS_music_data  ; load address of BIOS data area
                                           ; for notes
                 LDB     A,X               ; and look information of frequncy
                                           ; up in the BIOS data area
                 LDA     #\1               ; load the coarse tune register number
                                           ; for the voice to A (parameter of makro...)
                 JSR     Sound_Byte        ; and write the found frequency to
                                           ; that register of PSG (shadow)
                 LDX     POS,Y             ; load the position in the piece of
                                           ; music we are playing to X
                 LDA     0,X               ; and get the note again
                                           ; hmmm, might have done a push above...
                                           ; might have saved some cycles :-)
                                           ; doesn't really matter here
                 LSLA                      ; find the place in the BIOS Data again
                 INCA                      ; this time the second half of the frequency...
                 LDX     #BIOS_music_data  ; what was that address of the BIOS
                                           ; music data again?
                 LDB     A,X               ; ah, well, we load the fine tune frequency
                                           ; to reg B
                 LDA     #\2               ; and to A we load the fine tune register number
                                           ; of the voice we are playing (parameter of makro...)
                 JSR     Sound_Byte        ; get it to the PSG (shadow)
                 LDB     Vec_Snd_Shadow + 7; Register (shadow) 7 of the PSG:
                                           ; Register R7 is a multi functional
                                           ; Enable register which controls the
                                           ; three Noise/Tone Mixers and the general
                                           ; purpose I/O Port.
                 ANDB    #\3               ; Pulse on Voice
                 ORB     #\4               ; No noise on Voice
                 LDA     #$07              ; to register 7 of PSG (shadow)
                 JSR     Sound_Byte        ; store B to register A in soundchip (shadow)
                 endm                      ; end of macro
;----------------------------------------------------------------------------
; OK...
; this is it... the one and only play_voice function :-)
;
; in Y is the pointer to the music structure
; Y is a pointer to RAM:
; RAM:
;      pointer to music structure (ROM) 2 bytes
;      position (2 bytes)
;      counter (1 byte)
; (see structure at the top of the file and in the ini routine)

play_voice:
                 LDU     MUSIC,Y           ; load the ROM structure address to
                                           ; U (first thing in the RAM structure)
                 LDA     COUNT,Y           ; load the counter of this note
                 LBNE    hold_voice        ; if not zero... there is no need
                                           ; to play a new note... so jump
                                           ; to hold_voice
                 LDX     POS,Y             ; otherwise load the position in the
                                           ; music piece to register X
                 LDA     0,X               ; load the note we find there to A
                 CMPA    #$ff              ; if it is $ff we are done...
                 BNE     not_restart       ; otherwise we go on playing (jump to not_restart)
                 LDX     NOTES,U           ; we load the first position of the
                                           ; piece of music to X
                 STX     POS,Y             ; and (re) store it to the position pointer
                 LDA     0,X               ; load the note we find there...
                 BRA     not_rest          ; and go on playing it...
not_restart:
                 LDB     VOICE,U           ; let's check what voice
                 CMPB    #3                ; we should use for this song, 3?
                 BEQ     not_restart3      ; yep, than jump there
                 CMPB    #2                ; 2?
                 BEQ     not_restart2      ; yep, than jump there...
                 ; here not_restart voice 1
not_restart1:                              ; ok... lets do the voice 1 kind ...
                 NOT_RESTART not_rest1,1,8 ; (look at the makro for info)
                 JMP     cont              ; and go on...
not_restart2:
                 NOT_RESTART not_rest2,2,16; (look at the makro for info)
                 JMP     cont              ; and go on...
not_restart3:
                 NOT_RESTART not_rest3,4,32; (look at the makro for info)
                 JMP     cont              ; and go on...
not_rest:                                  ; here we are sure not to have a
                                           ; note 'hangover' :-)
                 LDB     VOICE,U           ; but we must check for the same as
                 CMPB    #3                ; above... 3?
                 BEQ     not_rest3         ; yep, than jump there
                 CMPB    #2                ; 2?
                 BEQ     not_rest2         ; yep, than jump there...
                 ; here not restart voice 1
not_rest1:                                 ; ok... lets do the voice 1 kind ...
                 NOT_REST_ tone1, 1, 247   ; (look at the makro for info)
                 JMP     cont              ; and go on...
not_rest2:
                 NOT_REST_ tone2, 2, 239   ; (look at the makro for info)
                 JMP     cont              ; and go on...
not_rest3:
                 NOT_REST_ tone3, 4, 223   ; (look at the makro for info)
                 BRA     cont              ; and go on...
tone1:
                 TONE 1, 0, 254, 8         ; (look at the makro for info)
                 BRA     cont              ; and go on...
tone2:
                 TONE 3, 2, 253, 16        ; (look at the makro for info)
                 BRA     cont              ; and go on...
tone3:
                 TONE 5, 4, 251, 32        ; (look at the makro for info)
cont:
                 LDX     POS,Y             ; get the just played note
                                           ; (again!!!, perhaps a third time!)
                 LDA     NOTE_DURATION,X   ; and load the duration of the note
                 STA     DUR,Y             ; and store it, so that the duration
                                           ; is known for the ADSR table...
                 LDX     #whole_dur        ; load the address of the duration
                 LDA     A,X               ; and load the actual number of
                                           ; 'rounds' for this duration to last
                                           ; if NOTE_DURATION is 0, than it
                                           ; is a full duration, which will
                                           ; be read from
                                           ; #whole_dur + 0, which is in this
                                           ; example 32...
                                           ; othere durations go respectivly...
                 STA     COUNT,Y           ; put that into our 'round'-counter
                 LDX     POS,Y             ; load (maybe for the fourth time)
                                           ; our position in the note table of the
                                           ; piece of music
                 LEAX    2,X               ; and add 2 to it... pointing after that
                                           ; to the next note in the list
                 STX     POS,Y             ; and store it back...

                 ; here we allways come when going into this routine...
hold_voice:
                 DEC     COUNT,Y           ; reduce our 'round' counter by 1
                 LDA     DUR,Y             ; load our current duration
                                           ; and check which duration we have,
                                           ; that we can use the correct
                                           ; ADSR table...
                 CMPA    #WHOLE_NOTE       ; is it a whole note?
                 BNE     not_whole         ; no?, than jump
                 LDX     WHOLE_ADSR,U      ; yep, use the appropriate ADSR
                                           ; table than and...
                 BRA     do_volume         ; go on
not_whole:
                 CMPA    #HALF_NOTE        ; is it a half note?
                 BNE     not_half          ; no?, than jump
                 LDX     HALF_ADSR,U       ; yep, use the appropriate ADSR
                                           ; table than and...
                 BRA     do_volume         ; go on
not_half:
                 CMPA    #QUARTER_NOTE     ; is it a quarter note?
                 BNE     not_quarter       ; no?, than jump
                 LDX     QUARTER_ADSR,U    ; yep, use the appropriate ADSR
                                           ; table than and...
                 BRA     do_volume         ; go on
not_quarter:
                 CMPA    #EIGHTH_NOTE      ; is it a eighth note?
                 BNE     not_eighth        ; no?, than jump
                 LDX     EIGHTH_ADSR,U     ; yep, use the appropriate ADSR
                                           ; table than and...
                 BRA     do_volume         ; go on
not_eighth:
                 LDX     SIXTEENTH_ADSR,U  ; well, only the sixteenth is left...
                                           ; so we use the sixteenth ADSR table...
do_volume:
; in X is now a pointer to the correct ADSR table for our
; current duration
                 LDA     COUNT,Y           ; hm, what was our count again?
                 LDB     A,X               ; use the count'th value in the
                                           ; ADSR table as our current volume...
                                           ; in B is the volume we want to use...
                 LDA     #VOLUME_BASE      ; ahem, look at the define section
                 ADDA    VOICE,U           ; adding the VOICE we are playing
                                           ; gives us the correct PSG register
                                           ; for setting the volume...
                 JSR     Sound_Byte        ; store B to register A in soundchip (shadow)
                 RTS                       ; done!
;****************************************************************************

;****************************************************************************
; ADSR tables for different durations of notes and for each
; voice (they are reusable, but for show here they are different...)
ins1_w_ADSR: fcb 1,3,5,7,9,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,1
ins1_h_ADSR: fcb 1,3,5,7,9,11,11,11,11,11,11,15,15,15,8,1
ins1_q_ADSR: fcb 15,15,15,15,15,15,15,15
ins1_e_ADSR: fcb 15,15,15,15
ins1_s_ADSR: fcb 15,15

ins2_w_ADSR: fcb 1,3,5,7,9,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,1
ins2_h_ADSR: fcb 1,3,5,7,9,11,11,11,11,11,11,15,15,15,8,1
ins2_q_ADSR: fcb 15,15,15,15,15,15,15,15
ins2_e_ADSR: fcb 15,15,15,15
ins2_s_ADSR: fcb 15,15

ins3_w_ADSR: fcb 1,3,5,7,9,11,13,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,1
ins3_h_ADSR: fcb 1,3,5,7,9,11,13,15,15,13,11,9,7,5,3,1
ins3_q_ADSR: fcb 15,15,15,15,15,15,04,01
ins3_e_ADSR: fcb 15,15,15,15
ins3_s_ADSR: fcb 15,15

;****************************************************************************
; song of voice 3... a "hum"
intro_song3: fcb 10, QUARTER_NOTE
             fcb $ff

;****************************************************************************
; song of voice 2... from bottom to top
intro_song2: fcb 1,HALF_NOTE
             fcb 2,HALF_NOTE
             fcb 3,HALF_NOTE
             fcb 4,HALF_NOTE
             fcb 5,HALF_NOTE
             fcb 6,HALF_NOTE
             fcb 7,HALF_NOTE
             fcb 8,HALF_NOTE
             fcb 9,HALF_NOTE
             fcb 10,HALF_NOTE
             fcb 11,HALF_NOTE
             fcb 12,HALF_NOTE
             fcb 13,HALF_NOTE
             fcb 14,HALF_NOTE
             fcb 15,HALF_NOTE
             fcb 16,HALF_NOTE
             fcb 17,HALF_NOTE
             fcb 18,HALF_NOTE
             fcb 19,HALF_NOTE
             fcb 20,HALF_NOTE
             fcb 21,HALF_NOTE
             fcb 22,HALF_NOTE
             fcb 23,HALF_NOTE
             fcb 24,HALF_NOTE
             fcb 25,HALF_NOTE
             fcb 26,HALF_NOTE
             fcb 27,HALF_NOTE
             fcb 28,HALF_NOTE
             fcb 29,HALF_NOTE
             fcb 30,HALF_NOTE
             fcb 31,HALF_NOTE
             fcb 32,HALF_NOTE
             fcb 33,HALF_NOTE
             fcb 34,HALF_NOTE
             fcb 35,HALF_NOTE
             fcb 36,HALF_NOTE
             fcb 37,HALF_NOTE
             fcb 38,HALF_NOTE
             fcb 39,HALF_NOTE
             fcb 40,HALF_NOTE
             fcb 41,HALF_NOTE
             fcb 42,HALF_NOTE
             fcb 43,HALF_NOTE
             fcb 44,HALF_NOTE
             fcb 45,HALF_NOTE
             fcb 46,HALF_NOTE
             fcb 47,HALF_NOTE
             fcb 48,HALF_NOTE
             fcb 49,HALF_NOTE
             fcb 50,HALF_NOTE
             fcb 51,HALF_NOTE
             fcb 52,HALF_NOTE
             fcb 53,HALF_NOTE
             fcb 54,HALF_NOTE
             fcb 55,HALF_NOTE
             fcb 56,HALF_NOTE
             fcb 57,HALF_NOTE
             fcb 58,HALF_NOTE
             fcb 59,HALF_NOTE
             fcb 60,HALF_NOTE
             fcb 61,HALF_NOTE
             fcb 62,HALF_NOTE
             fcb 63,HALF_NOTE
             fcb $ff

;****************************************************************************
; song of voice 1... from top to bottom
intro_song1: fcb 63,HALF_NOTE
             fcb 62,HALF_NOTE
             fcb 61,HALF_NOTE
             fcb 60,HALF_NOTE
             fcb 59,HALF_NOTE
             fcb 58,HALF_NOTE
             fcb 57,HALF_NOTE
             fcb 56,HALF_NOTE
             fcb 55,HALF_NOTE
             fcb 54,HALF_NOTE
             fcb 53,HALF_NOTE
             fcb 52,HALF_NOTE
             fcb 51,HALF_NOTE
             fcb 50,HALF_NOTE
             fcb 49,HALF_NOTE
             fcb 48,HALF_NOTE
             fcb 47,HALF_NOTE
             fcb 46,HALF_NOTE
             fcb 45,HALF_NOTE
             fcb 44,HALF_NOTE
             fcb 43,HALF_NOTE
             fcb 42,HALF_NOTE
             fcb 41,HALF_NOTE
             fcb 40,HALF_NOTE
             fcb 39,HALF_NOTE
             fcb 38,HALF_NOTE
             fcb 37,HALF_NOTE
             fcb 36,HALF_NOTE
             fcb 35,HALF_NOTE
             fcb 34,HALF_NOTE
             fcb 33,HALF_NOTE
             fcb 32,HALF_NOTE
             fcb 31,HALF_NOTE
             fcb 30,HALF_NOTE
             fcb 29,HALF_NOTE
             fcb 28,HALF_NOTE
             fcb 27,HALF_NOTE
             fcb 26,HALF_NOTE
             fcb 25,HALF_NOTE
             fcb 24,HALF_NOTE
             fcb 23,HALF_NOTE
             fcb 22,HALF_NOTE
             fcb 21,HALF_NOTE
             fcb 20,HALF_NOTE
             fcb 19,HALF_NOTE
             fcb 18,HALF_NOTE
             fcb 17,HALF_NOTE
             fcb 16,HALF_NOTE
             fcb 15,HALF_NOTE
             fcb 14,HALF_NOTE
             fcb 13,HALF_NOTE
             fcb 12,HALF_NOTE
             fcb 11,HALF_NOTE
             fcb 10,HALF_NOTE
             fcb 9,HALF_NOTE
             fcb 8,HALF_NOTE
             fcb 7,HALF_NOTE
             fcb 6,HALF_NOTE
             fcb 5,HALF_NOTE
             fcb 4,HALF_NOTE
             fcb 3,HALF_NOTE
             fcb 2,HALF_NOTE
             fcb 1,HALF_NOTE
             fcb 1,WHOLE_NOTE
             fcb $ff

;****************************************************************************
; our vectrex intro music... very short indeed :-)
music:
        FDB     $ff16,$feb6
        FCB     $00,  $80

;****************************************************************************
; and our ROM music structures... so we spare ourselfs
; some of the runtime-initialization... and RAM...
music_structure_voice1:
                 DW       intro_song1      ; pointer to the notes
                 DB       1                ; what voice is to be used
                 DW       ins1_w_ADSR      ; ADSR envelope table for whole notes
                 DW       ins1_h_ADSR      ; ADSR envelope table for half notes
                 DW       ins1_q_ADSR      ; ADSR envelope table for quarter notes
                 DW       ins1_e_ADSR      ; ADSR envelope table for eighth notes
                 DW       ins1_s_ADSR      ; ADSR envelope table for sixteenth notes

music_structure_voice2:
                 DW       intro_song2      ; pointer to the notes
                 DB       2                ; what voice is to be used
                 DW       ins2_w_ADSR      ; ADSR envelope table for whole notes
                 DW       ins2_h_ADSR      ; ADSR envelope table for half notes
                 DW       ins2_q_ADSR      ; ADSR envelope table for quarter notes
                 DW       ins2_e_ADSR      ; ADSR envelope table for eighth notes
                 DW       ins2_s_ADSR      ; ADSR envelope table for sixteenth notes

music_structure_voice3:
                 DW       intro_song3      ; pointer to the notes
                 DB       3                ; what voice is to be used
                 DW       ins3_w_ADSR      ; ADSR envelope table for whole notes
                 DW       ins3_h_ADSR      ; ADSR envelope table for half notes
                 DW       ins3_q_ADSR      ; ADSR envelope table for quarter notes
                 DW       ins3_e_ADSR      ; ADSR envelope table for eighth notes
                 DW       ins3_s_ADSR      ; ADSR envelope table for sixteenth notes

