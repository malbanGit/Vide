;
;
; VECVOX.I
;
;
; Copyright (c) 2004 Alex Herbert
;
;



;
; Include the serial driver
;

        include "SER_JI.I"



;
; Constants
;

VOX_DATAMASK    equ     $ef     ; bit mask for data line
VOX_STATUSMASK  equ     $20     ; bit mask for status line

VOX_TERM        equ     $ff     ; speech string terminator



;
; Variables
;
; These routines require 2 bytes of RAM for the following variable:
;
; vox_addr - 16-bit pointer to next byte in speech string.
;
; You may wish to comment out the following lines and declare vox_addr
; elsewhere in your code.
;


        bss

vox_addr        ds      2



;
; Subroutines
;


        code


;
; vox_init
; --------
;
; Function:
;       Prepare joystick port for serial transmission and initialize
;       speech string pointer.
;
; Usage:
;       Call vox_init once at the start of your program.
;
; Note:
;       This routine writes $ef to PSG register 14 by calling Exec ROM
;       routine WRREG ($f256).  This is to mask serial output from all
;       joystick pins except the data line. (Port 2, pin 1.)
;       Care should be taken to not overwrite this register.  (There's
;       normally no reason to do so.)
;
; Caution:
;       The dp register will be set to $d0.
;


vox_init
        lda     #$d0
        tfr     a,dp            ; dp = $d0

        ldd     #($0e<<8)|VOX_DATAMASK
        jsr     $f256           ; WRREG (write data mask to PSG reg 14)

vox_init2
        ldx     #vox_silence
        stx     vox_addr        ; point to 'silence' speech string
        rts



;
; vox_speak
; ---------
;
; Function:
;       Sends speech data to the VecVox.
;
; Usage:
;       Call vox_speak once per frame. (I.e. stick it in your main loop)
;       See note below.
;
;       Then, just store the start address of a speech string in
;       vox_addr when you want the VecVox to speak, and let this
;       routine do the work!
;
;       To abort speech in progress, point vox_addr at vox_silence or
;       call vox_init2 (which does exactly that).
;
; Note:
;    1. This subroutine requires that the current joystick button
;       status is held at RAM address $c80f (TRIGGR).  This is usually
;       set by calling the Executive ROM routine INPUT (a.k.a.
;       read_switches2) at $F1BA.
;
;    2. Speech strings should be terminated with VOX_TERM. ($ff)
;
; Caution:
;       Contents of the dp register may (or may not) be set to $d0.
;


vox_speak
        lda     $c80f           ; get joystick buttons (TRIGGR)
        bita    #VOX_STATUSMASK ; mask "buffer full" status
        beq     vox_exit        ; exit if no room in buffer

        ldx     vox_addr        ; get speech pointer
        lda     ,x+             ; read next byte
        cmpa    #VOX_TERM       ; end of string?
        beq     vox_exit        ; ...if so, exit
        stx     vox_addr        ; store speech pointer

        ldb     #$d0
        tfr     b,dp            ; direct page = $d0

        jmp     ser_txbyte      ; send byte

vox_exit
        rts



;
; Silence string
;
; Initial speech string.  Point vox_addr here to abort speech
; in progress.
;


vox_silence
        db      $00,VOX_TERM



