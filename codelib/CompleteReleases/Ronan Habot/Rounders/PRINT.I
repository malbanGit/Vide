Char_Table EQU $F9F4
Char_Table_End EQU $FBD4

Vec_Text_Height EQU     $C82A   ;Default text height
Vec_Text_Width  EQU     $C82B   ;Default text width

VIA_port_b      EQU     $D000   ;VIA port B data I/O register
VIA_port_a      EQU     $D001   ;VIA port A data I/O register (handshaking)
VIA_DDR_b       EQU     $D002   ;VIA port B data direction register (0=input 1=output)
VIA_DDR_a       EQU     $D003   ;VIA port A data direction register (0=input 1=output)
;VIA_t1_cnt_lo   EQU     $D004   ;VIA timer 1 count register lo (scale factor)
VIA_t1_cnt_hi   EQU     $D005   ;VIA timer 1 count register hi
VIA_t1_lch_lo   EQU     $D006   ;VIA timer 1 latch register lo
VIA_t1_lch_hi   EQU     $D007   ;VIA timer 1 latch register hi
VIA_t2_lo       EQU     $D008   ;VIA timer 2 count/latch register lo (refresh)
VIA_t2_hi       EQU     $D009   ;VIA timer 2 count/latch register hi
VIA_shift_reg   EQU     $D00A   ;VIA shift register
VIA_aux_cntl    EQU     $D00B   ;VIA auxiliary control register
VIA_cntl        EQU     $D00C   ;VIA control register
VIA_int_flags   EQU     $D00D   ;VIA interrupt flags register
VIA_int_enable  EQU     $D00E   ;VIA interrupt enable register

;**************************************************************************
;
_my_Char_Tableb1:
 db  $00, $1c, $14, $14, $3c, $26, $14, $08, $08, $08, $2a, $08, $00, $00, $00, $20
 db  $24, $0c, $22, $22, $18, $02, $04, $20, $22, $22, $0c, $0c, $10, $00, $04, $22
 db  $22, $14, $24, $22, $24, $02, $02, $02, $22, $08, $20, $12, $02, $36, $26, $22
 db  $22, $22, $22, $22, $2a, $22, $22, $22, $22, $22, $20, $04, $02, $20, $14, $00
 db  $00, $1c, $60, $08, $1c, $1c, $00, $44, $10, $1c, $00, $00, $6c, $82, $fe, $fe

_my_Char_Tableb2:
 db  $00, $08, $00, $14, $1c, $08, $0c, $00, $04, $10, $2a, $3e, $00, $1c, $00, $08
 db  $24, $08, $1c, $18, $12, $20, $1e, $08, $1c, $3c, $00, $0c, $04, $00, $10, $10
 db  $3a, $22, $1c, $02, $24, $0e, $0e, $32, $3e, $08, $20, $06, $02, $2a, $32, $22
 db  $1e, $22, $1e, $08, $08, $22, $14, $2a, $08, $08, $08, $04, $08, $20, $00, $00
 db  $fe, $08, $20, $08, $22, $3e, $1e, $8a, $38, $3e, $82, $38, $92, $82, $fe, $fe

_my_Char_Tableb3:
 db  $00, $00, $00, $14, $28, $32, $12, $00, $08, $08, $00, $08, $04, $00, $00, $02
 db  $24, $08, $02, $22, $10, $22, $22, $02, $22, $10, $0c, $08, $10, $00, $04, $00
 db  $02, $22, $24, $22, $24, $02, $02, $22, $22, $08, $22, $12, $22, $22, $22, $22
 db  $02, $12, $12, $22, $08, $22, $08, $2a, $22, $08, $02, $04, $20, $20, $00, $00
 db  $24, $08, $1e, $1c, $1c, $1c, $0c, $44, $6c, $14, $38, $82, $00, $82, $fe, $fe

Char_Tablef1 EQU Char_Table-$20
Char_Tablef2 EQU Char_Table+$50+$50-$20
Char_Tablef3 EQU Char_Table+$50+$50+$50+$50-$20
Char_Tablef4 EQU Char_Table+$50+$50+$50+$50+$50+$50-$20

Char_Tableb1 EQU _my_Char_Tableb1-$20
Char_Tableb2 EQU _my_Char_Tableb2-$20
Char_Tableb3 EQU _my_Char_Tableb3-$20

_ZERO_VECTOR_BEAM macro
                 CLR     VIA_shift_reg
                 LDB     #$CC
                 STB     VIA_cntl          ; /BLANK low and /ZERO low

                 endm

; expects
; b = speed
; first char
; u pointer to string
; X pointer to character display table
; Y speed set to zero
; ...
;
ONE_LINE_FORTH macro t
                 STB     <VIA_port_a       ; Send it to the D/A
                 LDB     #1
                 STB     <VIA_port_b       ; enable RAMP, disable mux

                 NOP                       ; delay needed for drawing
                 NOP
                 NOP
                 brn     LF4C7_1\?
LF4C7_1\?:
                 LDA     A,X               ; Get bitmap from chargen table
                 STA     <VIA_shift_reg    ; Save in shift register
                 LDA     ,U+               ; Get next character
                 BPL     LF4C7_1\?         ; Go back if not terminator
; A=$81
                 STA     <VIA_port_b       ; disable RAMP, disable mux
                 LDX     #\1
                 LDB     Vec_Text_Height   ; Get text height
         endm
ONE_LINE_FORTH_LAST macro
                 STB     <VIA_port_a       ; Send it to the D/A
                 LDB     #1
                 STB     <VIA_port_b       ; enable RAMP, disable mux

                 NOP                       ; delay needed for drawing
                 NOP
                 NOP
                 brn     LF4C7_1\?
LF4C7_1\?:
                 LDA     A,X               ; Get bitmap from chargen table
                 STA     <VIA_shift_reg    ; Save in shift register
                 LDA     ,U+               ; Get next character
                 BPL     LF4C7_1\?         ; Go back if not terminator
; A=$81
                 STA     <VIA_port_b       ; disable RAMP, disable mux
         endm

;
;**************************************************************************
;
; expects
; b = speed
; first char
; u pointer to string
; X pointer to inverted character display table
; Y speed set to zero
; ...
ONE_LINE_BACK macro t
                 STB     VIA_port_a        ; negative x speed
                 LDB     #1
                 STB     VIA_port_b        ; enable RAMP, disable mux

                 NOP                       ; delay needed for drawing
                 NOP
                 NOP
                 brn     LF4C7_2\?
LF4C7_2\?:
                 LDA     A,X               ; Get bitmap from chargen table
                 STA     <VIA_shift_reg    ; Save in shift register
                 LDA     ,-U               ; Get next character
                 BPL     LF4C7_2\?         ; Go back if not terminator
; A=$81
                 STA     <VIA_port_b       ; disable RAMP, disable mux
                 LDX     #\1
                 LDB     Vec_Text_Height   ; Get text height
         endm
;
;**************************************************************************
;
MOVE_DOWN_BEFOR_FORTH macro
; now move down
                 STB     <VIA_port_a       ; store 'height' to dac (y)
                 DEC     <VIA_port_b       ; disable RAMP, enable mux
                 INC     <VIA_port_b       ; disable RAMP, disable mux
                 CLR     <VIA_port_a       ; zero dac
; now only y set, x to zero
                 LDB     #01
                 STB     <VIA_port_b       ; enable RAMP, disable mux
; here we move down
                 LDB     ,U+
                 LDA     ,U+
                 DEC     <VIA_port_b       ; enable RAMP, enable mux
                                           ; tricky, cutting y off while
                                           ; integrating, saves one switch of mux
; still b=$81
                 STB     <VIA_port_b       ; disable RAMP, disable mux
                 LDB     Vec_Text_Width
; now finnished moving down
         endm
;
;**************************************************************************
;
MOVE_DOWN_BEFOR_BACK macro
; now move down
                 STB     <VIA_port_a       ; store 'height' to dac (y)
                 DEC     <VIA_port_b       ; disable RAMP, enable mux
                 INC     <VIA_port_b       ; disable RAMP, disable mux
                 CLR     <VIA_port_a       ; zero dac
; now only y set, x to zero
                 LDB     #01
                 STB     <VIA_port_b       ; enable RAMP, disable mux
                 LDB     ,-U
                 LDA     ,-U               ; Get first character
                 DEC     <VIA_port_b       ; enable RAMP, enable mux
                                           ; tricky, cutting y off while
                                           ; integrating, saves one switch of mux
; still B=$81
                 STB     <VIA_port_b       ; disable RAMP, disable mux
                 LDB     Vec_Text_Width_neg
; now finnished moving down
         endm
;
;**************************************************************************
;
PRINT_STR macro
; U=String pointer to first $81
                 LDA     #$18
                 CLR     <VIA_port_a       ; Clear D/A output
                 STA     <VIA_aux_cntl     ; Shift reg mode = 110, T1 PB7 enabled
                 LDX     #Char_Tablef1
LF4A5\?
                 LDA     #$80
                 STA     <VIA_port_b       ; enable mux, set y to 0 disable ramp
                 INC     <VIA_port_b       ; disable RAMP, disable mux
                 LDB     ,U+
                 LDB     Vec_Text_Width    ; Get text width
                 NEGB
                 STB     Vec_Text_Width_neg
                 NEGB
                 LDA     ,U+

                 ONE_LINE_FORTH Char_Tableb1
                 MOVE_DOWN_BEFOR_BACK
                 ONE_LINE_BACK Char_Tablef2
                 MOVE_DOWN_BEFOR_FORTH
                 ONE_LINE_FORTH Char_Tableb2
                 MOVE_DOWN_BEFOR_BACK
                 ONE_LINE_BACK Char_Tablef3
                 MOVE_DOWN_BEFOR_FORTH
                 ONE_LINE_FORTH Char_Tableb3
                 MOVE_DOWN_BEFOR_BACK
                 ONE_LINE_BACK Char_Tablef4
                 MOVE_DOWN_BEFOR_FORTH
                 ONE_LINE_FORTH_LAST

LF50A\?:
                 LDA     #$98              ;
                 STA     <VIA_aux_cntl     ; T1->PB7 enabled
                 _ZERO_VECTOR_BEAM
                 endm
;
;**************************************************************************
;
; this is mainly taken from move to d makro...
; for a describtion look at that or the rom dissassembly...
PRINT_STR_D macro
; Moveto_d_7F start
                 STA     VIA_port_a
                 LDA     #$7F
                 STA     VIA_t1_cnt_lo
                 LDA     #$CE
                 STA     VIA_cntl
                 CLRA
                 STA     VIA_port_b
                 STA     VIA_shift_reg
                 INC     VIA_port_b
                 STB     VIA_port_a
                 STA     VIA_t1_cnt_hi
                 LDD     #$40
LF33D\?
                 BITB    VIA_int_flags
                 BEQ     LF33D\?
                 STA     VIA_port_a
                 PRINT_STR
                 endm
;
;**************************************************************************
;
PRINT_STR_YX     macro
                 LDD     ,U++
                 PRINT_STR_D
                 endm
;
;**************************************************************************
;
PRINT_LIST       macro
Print_List1\?:
                 PRINT_STR_YX
                 LDA     ,U
                 BNE     Print_List1\?
                 RTS
                 endm
;
;**************************************************************************
;
PRINT_STR_HWXY macro
                 LDD     ,U++       ; text size
                 STD     Vec_Text_HW
                 LDD     ,U++       ; position
                 PRINT_STR_D
                 endm
;
;**************************************************************************
;


; special printstr routines
; expect
; strings termitated on both ends with $81

;***************************************************************************
my_Print_Str_hwyx
                 PRINT_STR_HWXY
                 RTS
;***************************************************************************
;my_print_str_d
;                 PRINT_STR_D
;                 RTS
;***************************************************************************
my_Print_Str
                 PRINT_STR
                 RTS
;***************************************************************************
my_Print_List
                 PRINT_LIST
                 RTS
;***************************************************************************
my_Print_Ships:
                 PSHS    B                 ; Save B-reg
                 LDB     #$81              ; build print struct... with $81 header ... on the stack
                 LEAU    -10,S             ; Point U into the stack
                 PSHU    B                 ; push $81
                 LDB     #$20              ; load  space
                 PSHU    B                 ; push space
                 PSHU    A                 ; Save A-reg = ship symbol

                 PULS    A                 ; Get back B-reg (no of ships)
                 CMPA    #$09              ; If B-reg >9 then
                 BLS     LF3A3_
                 LDA     #$6C-$30          ; load $6C = infinty symbol
LF3A3_:
                 ADDA    #$30              ; otherwise make an ascii number
                 LDB     #'-'              ; load minus
                 PSHU    D                 ; Push digit and minus sign
                 LDB     #$81              ; end of string...
                 PSHU    B                 ; push end of string
                 PSHU    X                 ; Push (y,x) coordinates
                 LDD     ,U++              ; move to position
                 jsr     Moveto_d_7F       ; and print it (u points to constructed string structure)
                 jmp     my_Print_Str      ; print it
;***************************************************************************
