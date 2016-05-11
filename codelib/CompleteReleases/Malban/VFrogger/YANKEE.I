; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains the yankee doodle music for the game                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;               Music data bytes:
;                     Bits 0-5 = frequency
;                     Bit 6 clear = tone
;                     Bit 6 set = noise
;                     Bit 7 set = next music data byte is for next channel
;                     Bit 7 clear, play note with duration in next music data byte:
;                             bits 0-5 = duration
;                             bit 6 = unused
;                             bit 7 set = end of music
                FDB     $FEE8,$FEB6             ; ADSR and twang address tables, in Vectrex ROM
                FCB     2,12                    ;;;;;;;;
                FCB     0,12                    ; first byte is a note, to be found
                FCB     2,12                    ; in vectrex rom, is a 64 byte table...
                FCB     0,12                    ; last byte is length of note
                FCB     2,6                     ;;;;;;;;
                FCB     0,6
                FCB     2,6
                FCB     0,6
                FCB     2,6
                FCB     0,6
                FCB     2,12
                FCB     0,12                    ;;;;;;;;
                FCB     2,12
                FCB     0,12
                FCB     2,12
                FCB     0,12                    ;;;;;;;;
                FCB     2,6
                FCB     0,6
                FCB     2,6
                FCB     0,6
                FCB     2,6
                FCB     0,6
                FCB     2,6                     ;;;;;;;;
                FCB     0,6
                FCB     2,12
                FCB     0,12
                FCB     128+2,128+26,26-12, 12  ;
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     128+2,128+31,31-12, 12  ; a 128 means the next byte is a note for the
                FCB     128+0,128+33,33-12, 12  ; next channel...
                FCB     128+2,128+35,35-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     128+2,128+35,35-12, 12
                FCB     128+0,128+33,33-12, 12
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     128+2,128+31,31-12, 12
                FCB     128+0,128+33,33-12, 12
                FCB     128+2,128+35,35-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     2,12
                FCB     128+0,128+30,30-12, 12
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     128+2,128+31,31-12, 12
                FCB     128+0,128+33,33-12, 12
                FCB     128+2,128+35,35-12, 12
                FCB     128+0,128+36,36-12, 12  ;;;;;;;;
                FCB     128+2,128+35,35-12, 12
                FCB     128+0,128+33,33-12, 12
                FCB     128+2,128+31,31-12, 12
                FCB     128+0,128+30,30-12, 12  ;;;;;;;;
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+28,28-12, 12
                FCB     128+2,128+30,30-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     2, 12
                FCB     128+0,128+31,31-12, 12
                FCB     2, 12
                FCB     128+0,128+28,28-12, 18  ;;;;;;;;
                FCB     128+30,30-12, 06
                FCB     128+2,128+28,28-12, 12
                FCB     128+0,128+26,26-12, 12
                FCB     128+2,128+28,28-12, 12  ;;;;;;;;
                FCB     128+0,128+30,30-12, 12
                FCB     128+2,128+31,31-12, 12
                FCB     0, 12
                FCB     128+0,128+26,26-12, 18  ;;;;;;;;
                FCB     128+28,28-12, 06
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+24,24-12, 12
                FCB     128+2,128+23,23-12, 12  ;;;;;;;;
                FCB     0, 12
                FCB     128+2,128+26,26-12, 12
                FCB     0, 12
                FCB     128+2,128+28,28-12, 18  ;;;;;;;;
                FCB     128+30,30-12, 06
                FCB     128+0,128+28,28-12, 12
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+28,28-12, 12  ;;;;;;;;
                FCB     128+2,128+30,30-12, 12
                FCB     128+0,128+31,31-12, 12
                FCB     128+2,128+28,28-12, 12
                FCB     128+0,128+26,26-12, 12  ;;;;;;;;
                FCB     128+2,128+31,31-12, 12
                FCB     128+0,128+30,30-12, 12
                FCB     128+2,128+33,33-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     2, 12
                FCB     128+0,128+31,31-12, 12
                FCB     2, 12
                FCB     19, $ff                 ; $FF is end marker for music
                                                ; (high byte set) and end marker for
                                                ; copy routine
