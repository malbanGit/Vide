; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains a grid definition, used for testing positions only     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;;;;;;;;;;; test grid start                                                         ;
                _MOVE_TO -1,0 ; patched for speed... *2                              ;
                _DRAW_REL_LINE_FROM 0,(lo((GRID_SIZE))) , (lo((12*GRID_SIZE))), 0    ;
                _DRAW_REL_LINE_FROM 0,(lo((GRID_SIZE))) , (lo(-(12*GRID_SIZE))), 0   ;
                _DRAW_REL_LINE_FROM 0,(lo((GRID_SIZE))) , (lo((12*GRID_SIZE))), 0    ;
                _DRAW_REL_LINE_FROM 0,(lo((GRID_SIZE))) , (lo(-(12*GRID_SIZE))), 0   ;
                _DRAW_REL_LINE_FROM 0,(lo((GRID_SIZE))) , (lo((12*GRID_SIZE))), 0    ;
                _DRAW_REL_LINE_FROM 0,(lo((GRID_SIZE))) , (lo(-(12*GRID_SIZE))), 0   ;
                _DRAW_REL_LINE_FROM 0,(lo((GRID_SIZE))) , (lo((12*GRID_SIZE))), 0    ;
                _DRAW_REL_LINE_FROM 0,(lo((GRID_SIZE))) , (lo(-(12*GRID_SIZE))), 0   ;
                _DRAW_REL_LINE_FROM 0,(lo((GRID_SIZE))) , (lo((12*GRID_SIZE))), 0    ;
                _DRAW_REL_LINE_FROM 0,(lo((GRID_SIZE))) , (lo(-(12*GRID_SIZE))), 0   ;
                                                                                     ;
                _DRAW_REL_LINE_FROM 0,(lo((GRID_SIZE))), 0, (lo(-(12*GRID_SIZE)))    ;
                                                                                     ;
                _DRAW_REL_LINE_FROM (lo((GRID_SIZE))),0, 0,(lo(+(12*GRID_SIZE)))     ;
                _DRAW_REL_LINE_FROM (lo((GRID_SIZE))),0, 0,(lo(-(12*GRID_SIZE)))     ;
                _DRAW_REL_LINE_FROM (lo((GRID_SIZE))),0, 0,(lo(+(12*GRID_SIZE)))     ;
                _DRAW_REL_LINE_FROM (lo((GRID_SIZE))),0, 0,(lo(-(12*GRID_SIZE)))     ;
                _DRAW_REL_LINE_FROM (lo((GRID_SIZE))),0, 0,(lo(+(12*GRID_SIZE)))     ;
                _DRAW_REL_LINE_FROM (lo((GRID_SIZE))),0, 0,(lo(-(12*GRID_SIZE)))     ;
                _DRAW_REL_LINE_FROM (lo((GRID_SIZE))),0, 0,(lo(+(12*GRID_SIZE)))     ;
                _DRAW_REL_LINE_FROM (lo((GRID_SIZE))),0, 0,(lo(-(12*GRID_SIZE)))     ;
                _DRAW_REL_LINE_FROM (lo((GRID_SIZE))),0, 0,(lo(+(12*GRID_SIZE)))     ;
                _DRAW_REL_LINE_FROM (lo((GRID_SIZE))),0, 0,(lo(-(12*GRID_SIZE)))     ;
                _DRAW_REL_LINE_FROM (lo((GRID_SIZE))),0, 0,(lo(+(12*GRID_SIZE)))     ;
                _DRAW_REL_LINE_FROM (lo((GRID_SIZE))),0, 0,(lo(-(12*GRID_SIZE)))     ;
;;;;;;;;;;;; test grid end                                                           ;
