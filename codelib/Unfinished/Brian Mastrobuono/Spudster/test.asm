Intensity_5F    equ     $F2A5                   ; BIOS Intensity routine
Print_Str_d     equ     $F37A                   ; BIOS print routine
Wait_Recal      equ     $F192                   ; BIOS recalibration
music1          equ     $FD0D                   ; address of a (BIOS ROM)

Debug_0		equ     $C880
Debug_1		equ     $C881
Debug_2		equ     $C882
Debug_3		equ     $C883
Debug_4		equ     $C884
tempA		equ		$C885
tempB		equ		$C886

                                                ; music
; start of vectrex memory with cartridge name...
                org     0
;***************************************************************************
; HEADER SECTION
;***************************************************************************
                db      "g GCE 2014", $80       ; 'g' is copyright sign
                dw      music1                  ; music from the rom
                db      $F8, $50, $20, -$56     ; height, width, rel y, rel x
                                                ; (from 0,0)
                db      "RISE RUN TEST",$80; some game information,
                                                ; ending with $80
                db      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
main:
                jsr     Wait_Recal              ; Vectrex BIOS recalibration
                jsr     Intensity_5F            ; Sets the intensity of the
				lda		#125
				;ldb		#80
				;jsr		$F603
				;sta		tempA
				;stb		tempB	

                jsr		Reg_To_Decimal	
				ldu		#Debug_0
				lda     #$10                    ; Text position relative Y
                ldb     #-$50                   ; Text position relative X
                jsr     Print_Str_d             ; Vectrex BIOS print routine
;				lda		tempB	
 ;               jsr		Reg_To_Decimal	
;				ldu		Debug_0
;				lda     #$10                    ; Text position relative Y
 ;               ldb     #-$30                   ; Text position relative X
                bra     main                    ; and repeat forever
;Requires 5 bytes of ram to save each digit to
;Debug_0 (sign)
;Debug_1 (Digit 1)  
;Debug_2 (Digit 2)  
;Debug_3 (Digit 3)  
;Debug_4 (string terminator)

;Convert Register A to a 3 byte Decimal for printing to screen
Reg_To_Decimal:
    tfr     a,b     ;transfer a copy of a to b
    tstb            ;test a to check if neg
    bpl     Reg_DA  ;branch if plus (positive)
    nega            ;else is negative so negate a to be positive
    ldb     #45     ;"-" sign
    stb     Debug_0
    bra     Reg_D0
    
Reg_DA:
    ldb     #43     ;"+" sign
    stb     Debug_0
    
Reg_D0: 
    tfr     a,b
    suba    #100
    bge     Reg_D1  ;if 0 or Greater first digit = 1
    lda     #48     ;else it = 0 = (ascii 48)
    sta     Debug_1
    bra     Reg_D2
    
Reg_D1:
    tfr     a,b     ;copy remaining number after subtraction of 100 to b
    lda     #49     ;set digit to 1+ascii (ascii 49)
    sta     Debug_1
    
Reg_D2: 
    clra                ;clear a is the counter
Reg_D2_Loop:            ;Div10
    inca                ;this might mean our count is 1 more than it should be
    subb    #10         ;take away 10 until it is less than or equal to 0
    bge     Reg_D2_Loop ;if b is 0 or greater
    adda    #47         ;Result is 1 higher than required so add ascii 48-1
    sta     Debug_2     ;a count is the middle digit
    
    ;b must now contain the final digit but it will be negative, we need to add 10 to b + ascii
    addb    #58     ;add 10+ascii
    stb     Debug_3
    
    lda     #$80     ;string terminator
    sta     Debug_4
    
    rts
