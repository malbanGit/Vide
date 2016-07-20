;
; VOX_DEMO
;
; VecVox demo/example program
;
;
; Copyright (c) Alex Herbert 2004
;



;
; Memory segments
;

        bss
        org     $c880

        code
        org     $0000


;
; 6522 registers
;

CNTRL   equ     $d000
DAC     equ     $d001
DDAC    equ     $d003
T1LOLC  equ     $d004
ACNTRL  equ     $d00b
IFLAG   equ     $d00d


;
; Executive ROM routines
;

FRWAIT  equ     $f192
INPUT   equ     $f1ba


;
; Executive variables
;

EDGE    equ     $c811



;
; Cartridge header
;

        db      "g GCE     ",$80
        dw      null_music
        db      $00


;
; Program execution starts here...
;


main
        jsr     vox_init        ; VecVox: initialize variables
                                ; (must be called once at start)

main_loop
        jsr     FRWAIT          ; sync to frame timer

        jsr     INPUT           ; read joystick buttons

        jsr     vox_speak       ; VecVox: output speech data
                                ; (must be called in main loop,
                                ; once per frame, after reading
                                ; joystick buttons.)


        lda     EDGE            ; get button edges

check_button1
        bita    #$01            ; button 1 pressed?
        beq     check_button2   ; if not, check button 2

        ldx     #demo_string1
        stx     vox_addr        ; start speaking demo_string1

        bra     main_loop


check_button2
        bita    #$02            ; button 2 pressed?
        beq     check_button3   ; if not, check button 3

        ldx     #demo_string2
        stx     vox_addr        ; start speaking demo_string2

        bra     main_loop


check_button3
        bita    #$04            ; button 3 pressed?
        beq     check_button4   ; if not, check button 4

        ldx     #demo_string3
        stx     vox_addr        ; start speaking demo_string3

        bra     main_loop


check_button4
        bita    #$08            ; button 4 pressed?
        beq     main_loop       ; if not, then loop

        ldx     #demo_string4
        stx     vox_addr        ; start speaking demo_string4

        bra     main_loop



;
; Speech strings
;


demo_string1
        db      20,127,21,114,22,88,23,5,31,20,127,6,22
        db      65,132,194,191,7,129,166,7,154
        db      191,129,176,2
        db      22,73,170,154,187,129,7,4,197,2,22,82
        db      195,153,131,196,191,2,22,87,174,7,129,187
        db      194,134,166,151,2,22,73,8,129,141,4,178
        db      154,165,2,22,65,186,7,154,166,7,148,129,1
        db      91,2,1,8,178,154,165,129,143
        db      2,2,22,123,184,7,160,140,134,7,142,7
        db      137,7,156,176,2,22,110,8,129
        db      141,7,137,166,7,154,189,133,142,187,2,22
        db      98,165,132,141,7,160,7,150,128,2,22,87
        db      194,8,128,198,2,22,82,145,151,141,2
        db      140,160,167,129,196,2,22,65,141,160
        db      2,22,73,136,186,191,131,141,2,2,22,65
        db      199,7,145,131,141,191,128,2,22,82,195
        db      7,147,8,129,4,196,2,22,73,8,148,130
        db      174,128,2,22,65,187,129,141,187
        db      131,148,129,191,128,2,2,22,131,191,8,128
        db      182,7,151,7,148,2
        db      6,22,123,8,134,7,144,195,138,8,146
        db      2,22,110,166,7,154,194,154,189,134
        db      142,2,22,98,147,159,194,134,140,2
        db      22,87,131,131,195,187,148,154,2,22
        db      82,158,187,187,2,2,21,120,8,132,8
        db      141,177,22,73,186,7,155,142,7,145
        db      128,2,2,6,21,100,22,65,167,7,128,18
        db      170,7,148,134,21,0,0,31
        db      VOX_TERM

demo_string2
        db      20,96,21,114,22,88,23,5,31,22,98
        db      174,26,6
        db      128,22,82,175,26,2,134,22,65,175,26,8
        db      139,22,82,175,26,8,134,22,98
        db      175,26,8,128,22,131,175,26,8
        db      134,140,140,0,31
        db      VOX_TERM

demo_string3
        db      20,96,21,114,22,88,23,5,22,65,183
        db      7,159,146,164,183,7,160,140
        db      131,141,30,20,22,82,8
        db      169,8,129,187,8,129,167,166,131,196
        db      196,166,136,194,187,187,30,50
        db      23,0,22,68,157,132,132,140
        db      154,128,194,134,140,7,198,7,160
        db      191,133,148,191,136,194,129,143
        db      140,7,134,8,189,128,141,195,7
        db      148,128,154,191,129,176,171,157
        db      6,23,15,148,129,129,182,135,135,175
        db      6,183,138,191,182,129,141,187,187,141,141,31
        db      VOX_TERM

demo_string4
        db      20,96,21,114,22,88,23,5,21,120,23
        db      0,230,23,230,23,2,230,23,3,230,23,4,230
        db      23,5,230,23,6,230,23,7,230,23,8,230,23
        db      9,230,23,10,230,23,11,230,23,12,230,23
        db      13,230,23,14,230,23,15,230,23,0,232,23
        db      232,23,2,232,23,3,232,23,4,232,23,5,232
        db      23,6,232,23,7,232,23,8,232,23,9,232,23
        db      10,232,23,11,232,23,12,232,23,13,232,23
        db      14,232,23,15,232
        db      VOX_TERM



;
; Include the VecVox driver
;

        include "VECVOX.I"


;
; Title music
;

null_music
        dw      $0000
        dw      $0000
        db      $00,$80



