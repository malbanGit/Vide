; A sample should have a small buffer behind it,
; since it is only checked during recalibration whether the sample
; is finished.
; Using 2kHz samples playes about 40 samples per update round
; -> in worst case we play 39 garbage samples.
;
; turning is here worst case, since after turning another 'clean'
; sample should be played.
; without this buffer there is a noticeable 'click'.
sample_buffer:
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0      ;
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0      ;
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0      ;
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0      ;
turning_sample_start:
                INCLUDE "data\\turning.DB"
turning_sample_end:
turning_sample_length   EQU (turning_sample_end - turning_sample_start)
;***************************************************************************
west_sample_start:
                INCLUDE "data\\WEST.DB"
west_sample_end:
west_sample_length   EQU (west_sample_end - west_sample_start)
;***************************************************************************
east_sample_start:
                INCLUDE "data\\east.DB"
east_sample_end:
east_sample_length   EQU (east_sample_end - east_sample_start)
;***************************************************************************
north_sample_start:
                INCLUDE "data\\north.DB"
north_sample_end:
north_sample_length   EQU (north_sample_end - north_sample_start)
;***************************************************************************
south_sample_start:
                INCLUDE "data\\south.DB"
south_sample_end:
south_sample_length   EQU (south_sample_end - south_sample_start)
;***************************************************************************
south_sample_struct:
                DB 0                     ; not looping
                DW turning_sample_start  ; start position of sample
                DW turning_sample_length ; the length
                DW south_sample_start    ; start position of sample
                DW south_sample_length   ; the length
                DW 0                     ; finish sample
;***************************************************************************
north_sample_struct:
                DB 0                     ; not looping
                DW turning_sample_start  ; start position of sample
                DW turning_sample_length ; the length
                DW north_sample_start    ; start position of sample
                DW north_sample_length   ; the length
                DW 0                     ; finish sample
;***************************************************************************
east_sample_struct:
                DB 0                     ; not looping
                DW turning_sample_start  ; start position of sample
                DW turning_sample_length ; the length
                DW east_sample_start     ; start position of sample
                DW east_sample_length    ; the length
                DW 0                     ; finish sample
;***************************************************************************
west_sample_struct:
                DB 0                     ; not looping
                DW turning_sample_start  ; start position of sample
                DW turning_sample_length ; the length
                DW west_sample_start     ; start position of sample
                DW west_sample_length    ; the length
                DW 0                     ; finish sample
;***************************************************************************
