
;;;;;;;;;;;;;;;;;;;;;;;;;;;
; switch to bank          ;
; IN: a - no of bank      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
switchROM:  std cartnum
;    	lda #64					; switch port B6 to output
;		ora VIA_DDR_b
;		sta VIA_DDR_b
		lda #switchroutineROM_END - switchroutineROM ; copy switching routine to ram
		ldx #switchroutineROM
		ldy #switchroutine
		inca
copyram: ldb ,x+
		 stb ,y+
		deca
		bne copyram		
;		ldd cartnum
 lda #$ff-$40
 anda <VIA_port_b
 sta <VIA_port_b
 		lda cartnum+1
 inca
 
;		tfr d,y
		jmp switchroutine


switchroutineROM:

;switch:
;		ldb #$9f
;		stb <VIA_DDR_b
;		leay -1,y
;		clrb
;delay:	decb
;		bne delay
;		ldb #$df
;		stb <VIA_DDR_b
;		nop
;		nop
;		cmpy #0
;		bne switch

switch: 
                    ldb      #$9f                         ; Prepare DDR Registers % 1001 1111 
                    stb      <VIA_DDR_b                   ; all ORB to output except ORB 5 and 6, PB6 goes HIGH 
                    deca                                  ; reduce bank counter by one 
                    clrb                                  ; do a full $ff wait loop, clr b 
delay: 
                    decb                                  ; b-- (first round this initiates the "$ff) 
                    bne      delay                        ; if not zero delay further 
                    ldb      #$df                         ; Prepare DDR Registers % 1101 1111 
                    stb      <VIA_DDR_b                   ; all ORB to output except ORB 5, PB6 goes LOW 
                    nop                                   ; delay 
                    nop                                   ; delay for a pulse length to VecFlash 
                    tsta                                  ; test a (bank counter) for 0 
                    bne      switch                       ; if not zero, continue bankswitching 



fastboot:
		jsr waitrecal
		jsr waitrecal
                    noopt      
		jmp flashstart
                    opt      
	if DEPRECATED=1
fastboot:
		ldu #$11		; go to end of fixed header
fastboot2:		lda ,u+ ; search for end of cart name
		bpl fastboot2
		jmp 1,u			; jump to startaddress
	endif
switchroutineROM_END:
		


