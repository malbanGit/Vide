
; INVITRON intro for Vectrex by Frog
; Invitation intro for Chaos Constructions'2015
;
; http://frog.enlight.ru
; e-mail: frog@enlight.ru
; July 2015


                include "vectrex.i"

; RAM till $c926 (inc. $c926) used by music player!

chunk_n         equ    $c931

textline_i      equ    $c932            ; current addr inside fadetbl DW
textline_pos    equ    $c934            ; current addr inside texttbl DW


textline_pos_tmp equ    $c936           ; current addr inside texttbl temp DW

dot_jump_flag   equ    $c938           ;

blocks_xcnts    equ    $c940            ; X pos counters

blocks_ints     equ     $c940 + 20      ; corresponding intensity counters

;***************************************************************************
                org     0

                db      "g GCE 2015", $80 ; 'g' is copyright sign
                dw      $F600            ; music from the rom (no music)
                db      $F8, $32, 33, -$38; height, width, rel y, rel x (from 0,0)
                db      "INVITRON BY FROG", $80;
                db      0                 ; end of header

                lbra     start

                include "invitron_music_player.asm" ; music player
                include "invitron_music_data.asm" ; music data (encoded with ym_vpack w/o parameters)
                include "invitron_sound_sample.asm" ; digitized sample data (signed, 8 bit)
                include "invitron_texts.asm"

start:

; ============= SHOW TITLE TEXT

                ldd     #fadetbl2
                std     textline_i

loop_title:
                jsr     Wait_Recal

                lda     [textline_i]
                jsr     Intensity_a


                ldd     #$fd28
                sta     Vec_Text_Height
                stb     Vec_Text_Width

                ldu     #titletext0     ; WELCOME TO
                lda     #20           ; y
                ldb     #-30           ; x
                jsr     Print_Str2


                ldd     #$fd20
                sta     Vec_Text_Height
                stb     Vec_Text_Width

                ldu     #titletext2a     ; AUGUST 29-30.
                lda     #-3             ; y
                ldb     #-75           ; x
                jsr     Print_Str2

                ldu     #titletext2b     ; ST.PETERSBURG,RUSSIA
                lda     #-3             ; y
                ldb     #-15           ; x
                jsr     Print_Str2


                ldd     #$fb32
                sta     Vec_Text_Height
                stb     Vec_Text_Width

                ldu     #titletext1     ; CHAOS CONSTRUCTIONS'2015
                lda     #10             ; y
                ldb     #-78           ; x
                jsr     Print_Str2


                ldu     textline_i
                leau    1,u
                stu     textline_i

                cmpu    #fadetbl_end2
                bne     loop_title

; ============== PLAY DIGITIZED SAMPLE

                lda     #%10000110      ; enable mux, set mux to sound channel (%11)
                sta     <VIA_port_b     ; write back to reg B in 6522

                ldx     #sample         ; sample address
                ldy     #20614          ; sample length (bytes)

next:

                lda     ,-y
                lda     ,x+             ; get sound byte
                sta     <VIA_port_a     ; output byte to DAC
                cmpy    #$0000
                beq     done

                ldb     #$1e            ; delay. $1e for 7KHz
delay:
                decb
                cmpb    #$00
                bne     delay

                bra     next

done:

                lda     #%10000001      ; disable mux
                sta     <VIA_port_b


; ============== TRON STYLE PART (MAIN)
start_tron:
                ldd     #texttbl
                std     textline_pos

                lda     #%10010100
                sta     dot_jump_flag

                ldd     #$f832
                sta     Vec_Text_Height
                stb     Vec_Text_Width


                ldu     #SONG_DATA              ; init music player
                jsr     init_ym_sound

                lda     #127
                sta     blocks_xcnts
                lda     #0
                sta     blocks_xcnts + 1
                lda     #20
                sta     blocks_xcnts + 2
                lda     #120
                sta     blocks_xcnts + 3

                lda     #100
                sta     blocks_xcnts + 4
                lda     #70
                sta     blocks_xcnts + 5
                lda     #40
                sta     blocks_xcnts + 6
                lda     #120
                sta     blocks_xcnts + 7
; opposite direction
                lda     #0
                sta     blocks_xcnts + 8
                lda     #40
                sta     blocks_xcnts + 9


; initial intensity
                lda     #$3f
                sta     blocks_ints
                lda     #$30
                sta     blocks_ints + 1
                lda     #$1f
                sta     blocks_ints + 2
                lda     #$3f
                sta     blocks_ints + 3
                lda     #$3f
                sta     blocks_ints + 4
                lda     #$3f
                sta     blocks_ints + 5
                lda     #$1f
                sta     blocks_ints + 6
                lda     #$25
                sta     blocks_ints + 7

; opposite direction
                lda     #$0f
                sta     blocks_ints + 8
                lda     #$0f
                sta     blocks_ints + 9

                lda     #$ff              ; scale factor
                sta     <VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                ldd     #fadetbl
                std     textline_i

main_loop:
                jsr     Wait_Recal
                lda     [textline_i]

; Intensity_a_M begin
                sta     <VIA_port_a     ;Store intensity in D/A
                ldd     #$0504          ;mux disabled channel 2
                sta     <VIA_port_b
                stb     <VIA_port_b     ;mux enabled channel 2
                stb     <VIA_port_b     ;do it again just because
                ldb     #$01
                stb     <VIA_port_b     ;turn off mux
; Intensity_a_M end


                ldu     textline_pos
                lda     #10             ; y 10
                ldb     #-80           ; x -105
                jsr     Print_Str2
                stu     textline_pos_tmp

                lda     #$ff              ; scale factor
                sta     <VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                ldx     #blocks         ; pointer to blocks structure (in ROM)
                ldy     #blocks_xcnts   ; pointer to Y counters for blocks (in RAM)
                ldu     #0              ; init blocks counter

nextchunk:

; Center_Beam_M begin

                lda     #$CC                    ; /BLANK low and /ZERO low
                sta     <VIA_cntl               ; enable beam, enable zeroing

                ldd     #$0302
                clr     <VIA_port_a             ; clear D/A register
                sta     <VIA_port_b             ; mux=1, disable mux
                stb     <VIA_port_b             ; mux=1, enable mux
                stb     <VIA_port_b             ; do it again
                ldb     #$01
                stb     <VIA_port_b             ; disable mux

                lda     #$CE                    ; /Blank low, /ZERO high
                sta     <VIA_cntl               ; enable beam, disable zeroing

; Center_Beam_M end

                lda     ,x+             ; pointer to blocks structure
                ldb     ,y+             ; Y counters

; Moveto_d begin
                sta     <VIA_port_a     ;Send Y to A/D
                clr     <VIA_port_b     ;Enable mux
                nop                     ;Wait a moment
                inc     <VIA_port_b     ;Disable mux
                stb     <VIA_port_a     ;Send X to A/D
                ldd     #$0000          ;Shift reg=$FF (solid line), T1H=0
                sta     <VIA_shift_reg  ;Put pattern in shift register
                stb     <VIA_t1_cnt_hi  ;Set T1H (scale factor?)
                ldd     #$0040          ;B-reg = T1 interrupt bit
LF3F4a:         bitb    <VIA_int_flags  ;Wait for T1 to time out
                beq     LF3F4a
                nop                     ;Wait a moment more
; Moveto_d end


; Dot_here begin
                lda     #$FF            ;Set pattern to all 1's
                sta     <VIA_shift_reg  ;Store in VIA shift register
                ldb     #8   ; Vec_Dot_Dwell Get dot dwell (brightness)
dh1:            decb                    ;Delay leaving beam in place
                bne     dh1
                clr     <VIA_shift_reg  ;Blank beam in VIA shift register
; Dot_here end


                lda     blocks_ints,u

; Intensity_a_M begin
                sta     <VIA_port_a     ;Store intensity in D/A
                ldd     #$0504          ;mux disabled channel 2
                sta     <VIA_port_b
                stb     <VIA_port_b     ;mux enabled channel 2
                stb     <VIA_port_b     ;do it again just because
                ldb     #$01
                stb     <VIA_port_b     ;turn off mux
; Intensity_a_M end

                jsr     Draw_VLc

; Dot_here begin
                lda     #$FF            ;Set pattern to all 1's
                sta     <VIA_shift_reg  ;Store in VIA shift register
                ldb     #8   ; Vec_Dot_Dwell Get dot dwell (brightness)
dh2:            decb                    ;Delay leaving beam in place
                bne     dh2
                clr     <VIA_shift_reg  ;Blank beam in VIA shift register
; Dot_here end

                leau    1,u                     ; inc U
                cmpu    #10                      ; total number of blocks (top + bottom)
                bne     nextchunk

; move blocks with different speed
                dec     blocks_xcnts
                dec     blocks_xcnts + 1
                dec     blocks_xcnts + 1
                dec     blocks_xcnts + 2

                dec     blocks_xcnts + 3
                dec     blocks_xcnts + 4
                dec     blocks_xcnts + 4
                dec     blocks_xcnts + 5
                dec     blocks_xcnts + 6
                dec     blocks_xcnts + 6
                dec     blocks_xcnts + 7

                inc     blocks_xcnts + 8
                inc     blocks_xcnts + 9

; flashing
                com     blocks_ints + 3
                neg     blocks_ints + 5

; draw dots

; Center_Beam_M begin

                lda     #$CC                    ; /BLANK low and /ZERO low
                sta     <VIA_cntl               ; enable beam, enable zeroing

                ldd     #$0302
                clr     <VIA_port_a             ; clear D/A register
                sta     <VIA_port_b             ; mux=1, disable mux
                stb     <VIA_port_b             ; mux=1, enable mux
                stb     <VIA_port_b             ; do it again
                ldb     #$01
                stb     <VIA_port_b             ; disable mux

                lda     #$CE                    ; /Blank low, /ZERO high
                sta     <VIA_cntl               ; enable beam, disable zeroing

; Center_Beam_M end

                clra
                ldb     blocks_xcnts

; Moveto_d begin

                sta     <VIA_port_a     ;Send Y to A/D
                clr     <VIA_port_b     ;Enable mux
                nop                     ;Wait a moment
                inc     <VIA_port_b     ;Disable mux
                stb     <VIA_port_a     ;Send X to A/D
                ldd     #$0000          ;Shift reg=$FF (solid line), T1H=0
                sta     <VIA_shift_reg  ;Put pattern in shift register
                stb     <VIA_t1_cnt_hi  ;Set T1H (scale factor?)
                ldd     #$0040          ;B-reg = T1 interrupt bit
LF3F4c:         bitb    <VIA_int_flags  ;Wait for T1 to time out
                beq     LF3F4c
                nop                     ;Wait a moment more
; Moveto_d end


                ldu     #0              ; init dots counter
                ldx     #dots
nextdot:
                lda     blocks_xcnts + 1        ; to make dots flash sometimes
                adca    11,x
                asla

; Intensity_a_M begin
                sta     <VIA_port_a     ;Store intensity in D/A
                ldd     #$0504          ;mux disabled channel 2
                sta     <VIA_port_b
                stb     <VIA_port_b     ;mux enabled channel 2
                stb     <VIA_port_b     ;do it again just because
                ldb     #$01
                stb     <VIA_port_b     ;turn off mux
; Intensity_a_M end


; Dot_ix begin

                ldd     ,x++

; jump dot up and down
                stu     dot_jump_flag

                bita    dot_jump_flag
                bne     skip_add
                deca
skip_add:

; Moveto_d begin

                sta     <VIA_port_a     ;Send Y to A/D
                clr     <VIA_port_b     ;Enable mux
                nop                     ;Wait a moment
                inc     <VIA_port_b     ;Disable mux
                stb     <VIA_port_a     ;Send X to A/D
                ldd     #$0000          ;Shift reg=$FF (solid line), T1H=0
                sta     <VIA_shift_reg  ;Put pattern in shift register
                stb     <VIA_t1_cnt_hi  ;Set T1H (scale factor?)
                ldd     #$0040          ;B-reg = T1 interrupt bit
LF3F4b:         bitb    <VIA_int_flags  ;Wait for T1 to time out
                beq     LF3F4b
                nop                     ;Wait a moment more
; Moveto_d end

                lda     #$FF            ;Set pattern to all 1's
                sta     <VIA_shift_reg  ;Store in VIA shift register
                ldb     #5   ;Get dot dwell (brightness)
dix1:           decb                    ;Delay leaving beam in place
                bne     dix1
                clr     <VIA_shift_reg  ;Blank beam in VIA shift register

; Dot_ix end

                leau    1,u                     ; inc U
                cmpu    #6                       ; total number of dots 6
                bne     nextdot           ;Go back until finished


;   play music
                jsr     do_ym_sound
                ldd     ym_data_current
                bne     keep_playing            ; loop default
                ldu     #SONG_DATA              ; repeat song
                jsr     init_ym_sound
keep_playing:

                ldu     textline_i
                leau    1,u
                stu     textline_i

                cmpu    #fadetbl_end
                bne     stillfade               ; continue fading

                ldd     #fadetbl                ; go next part of text and restart fading
                std     textline_i
                ldd     textline_pos_tmp
                std     textline_pos

                cmpd    #texttbl_end-2
                bls     stillfade

                ldd     #texttbl
                std     textline_pos
stillfade:

                bra     main_loop
; -----------------------------------
blocks:
; Y start, count-1, y,x , y,x, y,x, ...
; top blocks
                db      57, 0, 0,40
                db      55, 2, 0,5, -1,1, 0,58
                db      63, 3, 0,50, 2,2, 0,10, 3,0
                db      70, 3, -3,3, 0,27, -2,2, 0,30

; bottom blocks
                db      -54, 2, 0,29, -5,5, 0,29
                db      -57, 0, 0,50
                db      -63, 7, 0,20, -2,2, 0,10, 2,2, 0,20, -4,4, 0,3, 2,0
                db      -70, 4, 0,32, -1,1, 0,10, 3,3, 0,15

; opposite direction lines
                db      74, 2, 0,29, -2,2, 0,29
                db      -74, 2, 0,5, -1,1, 0,58

; bottom and top several dots
dots:
                db      -63,-40, -10,45, 23,40
                db      127,15, -7,-60, -8,-30

fadetbl:
                db      0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24
                db      26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46
                db      48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70
                db      72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92
                db      94, 96, 98, 100, 101, 102, 103, 104, 106, 107, 108, 109, 110, 111, 112
                db      113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126

                db      127, 127, 127, 127, 127, 127, 127, 117, 127, 117, 127, 127, 127, 127, 127, 127, 127, 127

                db      126, 125, 124, 123, 122, 121, 120, 119, 118, 117, 116, 115, 114, 113, 112
                db      111, 110, 109, 108, 107, 106, 105, 104, 103, 102, 100, 98, 96, 94, 92
                db      90, 88, 86, 84, 82, 80, 78, 76, 74, 72, 70, 68
                db      67, 65, 63, 61, 59, 57, 55, 53, 51, 49, 47, 45
                db      43, 41, 39, 37, 35, 33, 31, 29, 27, 25, 23
                db      21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 0
fadetbl_end:


fadetbl2:
                db      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24
                db      25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47
                db      48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70
                db      71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93
                db      94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112
                db      113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126

                db      127, 127, 127, 127, 127, 127, 127, 117, 127, 117, 127, 127, 127, 127, 127, 127, 127, 127
                db      127, 127, 127, 127, 127, 127, 127, 117, 127, 117, 127, 127, 127, 127, 127, 127, 127, 127
                db      127, 127, 127, 127, 127, 127, 127, 117, 127, 117, 127, 127, 127, 127, 127, 127, 127, 127

                db      126, 125, 124, 123, 122, 121, 120, 119, 118, 117, 116, 115, 114, 113, 112, 111
                db      110, 109, 108, 107, 106, 105, 104, 103, 102, 101, 100, 99, 98, 97, 96, 95, 94, 93, 92, 91
                db      90, 89, 88, 87, 86, 85, 84, 83, 82, 81, 80, 79, 78, 77, 76, 75, 74, 73, 72, 71, 70, 69, 68
                db      67, 66, 65, 64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45
                db      44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22
                db      21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
fadetbl_end2:


titletext0:     db      "WELCOME TO", $80
titletext1:     db      "CHAOS CONSTRUCTIONS'2015", $80
titletext2a:    db      "29-30 AUGUST.", $80
titletext2b:    db      "ST.PETERSBURG, RUSSIA", $80


Print_Str2:
                jsr     >Moveto_d_7F

                stu     Vec_Str_Ptr     ;Save string pointer

                ldx     #Char_Table-$20 ;Point to start of chargen bitmaps $F9D4 ?
                ldd     #$1883          ;$8x = enable RAMP? YES! (bit 7)
                clr     <VIA_port_a     ;Clear D/A output

                sta     <VIA_aux_cntl   ;Shift reg mode = 110, T1 PB7 (RAMP) enabled
                ldx     #Char_Table-$20 ;Point to start of chargen bitmaps $F9D4 ?

next_scan_line:                         ; LF4A5
                stb     <VIA_port_b     ;$83 Update RAMP, set mux to channel 1 ; START ZEREF UPDATE
                dec     <VIA_port_b     ;Enable mux
                ldd     #$8081
                nop                     ;Wait a moment ; TIMING
                inc     <VIA_port_b     ;Disable mux
                stb     <VIA_port_b     ;Enable RAMP, set mux to channel 0
                sta     <VIA_port_b     ;Enable mux ; START Y=0 SAMPLE

                jsr     Delay_RTS ; f57d

                inc     <VIA_port_b     ;Enable RAMP, disable mux ; Y S/H FINISHED
                lda     Vec_Text_Width  ;Get text width
                sta     <VIA_port_a     ;Send it to the D/A ; FOR HORIZ SPEED
                ldd     #$0100
                ldu     Vec_Str_Ptr     ;Point to start of text string
                sta     <VIA_port_b     ;Disable RAMP, disable mux ; START RAMP
                bra     skip_this       ; LF4CB

not_terminator:
                lda     a,x             ;Get bitmap from chargen table  ; 5- CYCLE COUNT  LF4C7
                sta     <VIA_shift_reg  ;Save in shift register

skip_this:                              ; LF4CB
                lda     ,u+             ;Get next character
                bpl     not_terminator  ;Go back if not terminator ; TOTAL 18 FOR LOOP ; LF4C7

                lda     #$81
                sta     <VIA_port_b     ;Enable RAMP, disable mux ; STOP RAMP, TIME=18 CYCLES+18 PER CHAR
                neg     <VIA_port_a     ;Negate text width to D/A
                lda     #$01
                sta     <VIA_port_b     ;Disable RAMP, disable mux
                cmpx    #Char_Table + $50*6-$20;     Check for last row
                beq     last_row        ;Branch if last row  ; LF50A
                leax    $50,x           ;Point to next chargen row
                tfr     u,d             ;Get string length ; 6 CYCLES - CALCULATE #CHARS SHOWN
                subd    Vec_Str_Ptr
                subb    #$02            ; -  2
                aslb                    ; *  2
                ;brn     some_delay      ;Delay a moment  LF4EB Removed to compensate left skew  !!!

some_delay:     lda     #$81            ; LF4EB
                nop
                decb
                ;subb #$01
                bne     some_delay      ; Delay some more in a loop ; LF4EB
                sta     <VIA_port_b     ; $81->VIA_port_b. Enable RAMP, disable mux. stop integrate ; WHOLE RETRACE 45+ 9 PER B DELAY LOOP. 39-12 for FWD OVERHEAD#27. EQUIV OF 3 CHARS
                ldb     Vec_Text_Height ;Get text height


                aslb
                aslb                    ; height * 4
                stb     <VIA_port_a     ; height * 4 -> DAC
                dec     <VIA_port_b     ; $80 -> VIA_port_b. enable MUX, disable ~RAMP (bit7=1), MUX to channel Y
                ldb     #$01
                inc     <VIA_port_b     ; $81 -> VIA_port_b. ramp off, MUX off. Stop Integrate, MUX to channel Y
                clr     <VIA_port_a     ; clear DAC
                stb     <VIA_port_b     ; 1 -> VIA_port_b.  ; MUX disable, ~RAMP enable . Start integrate
                ldb     #$83
                sta     <VIA_port_b     ; $81 -> VIA_port_b. ramp off, MUX off. Stop Integrate, MUX to channel Y

                bra     next_scan_line  ;Go back for next scan line   LF4A5

last_row:                               ; LF50A
                lda     #$98
                sta     <VIA_aux_cntl   ;T1->PB7 enabled

                ldd     #$00CC
                stb     <VIA_cntl       ;/BLANK low and /ZERO low
                sta     <VIA_shift_reg  ;clear shift register


                rts



