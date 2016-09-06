; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains the vector list for the home of frogger                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
homes:
                DB   20                     ; 21 vectors are drawn
                DB    0,      (GRID_SIZE+(GRID_SIZE/2))*HOME_BLOW_UP
                DB    5*HOME_BLOW_UP,      0
                DB    0,      (GRID_SIZE)*HOME_BLOW_UP
                DB  - 5*HOME_BLOW_UP,      0
                DB    0,      (GRID_SIZE)*HOME_BLOW_UP
                DB    5*HOME_BLOW_UP,      0              ;    _   _   _   _   _
                DB    0,      (GRID_SIZE)*HOME_BLOW_UP    ; __I I_I I_I I_I I_I I__
                DB  - 5*HOME_BLOW_UP,      0
                DB    0,      (GRID_SIZE)*HOME_BLOW_UP
                DB    5*HOME_BLOW_UP,      0
                DB    0,      (GRID_SIZE)*HOME_BLOW_UP
                DB  - 5*HOME_BLOW_UP,      0
                DB    0,      (GRID_SIZE)*HOME_BLOW_UP
                DB    5*HOME_BLOW_UP,      0
                DB    0,      (GRID_SIZE)*HOME_BLOW_UP
                DB  - 5*HOME_BLOW_UP,      0
                DB    0,      (GRID_SIZE)*HOME_BLOW_UP
                DB    5*HOME_BLOW_UP,      0
                DB    0,      (GRID_SIZE)*HOME_BLOW_UP
                DB  - 5*HOME_BLOW_UP,      0
                DB    0,      (GRID_SIZE+(GRID_SIZE/2))*HOME_BLOW_UP
