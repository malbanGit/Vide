;
; I used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
;
 INCLUDE "INCLUDE\\VECTREX.I" ; vectrex function includes

INFO_START EQU 0
BYTE_POSITION EQU 0
BIT_POSITION EQU 2
CURRENT_BYTE EQU 3
CURRENT_UNPACKED_BYTE EQU 4
CURRENT_RLE_COUNTER EQU 5
CURRENT_RLE_MAPPER EQU 7
CURRENT_IS_PHRASE EQU 9
CURRENT_PHRASE_BYTE EQU 11
CURRENT_PHRASE_START EQU 12
INFO_END EQU 14
STRUCTURE_LENGTH EQU (INFO_END-INFO_START)
MAZE_X_RAM EQU 4

current_register:
                DB 0
temp:
                DB 0
temp2:
                DB 0
temp3:
                DB 0
calc_coder:
                DB 0
calc_bits:
                DB 0
ym_data_len:
                DW 0
ym_data_current:
                DW 0
ym_name:
                DW 0
ym_data_start:
                DS (STRUCTURE_LENGTH*11)
