
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
		ldd cartnum
		tfr d,y
		jmp switchroutine
switchroutineROM:
switch:
		ldb #$9f
		stb <VIA_DDR_b
		leay -1,y
		clrb
delay:	decb
		bne delay
		ldb #$df
		stb <VIA_DDR_b
		nop
		nop
		cmpy #0
		bne switch
fastboot:
		jsr waitrecal
		jsr waitrecal
		jmp flashstart
	if DEPRECATED=1
fastboot:
		ldu #$11		; go to end of fixed header
fastboot2:		lda ,u+ ; search for end of cart name
		bpl fastboot2
		jmp 1,u			; jump to startaddress
	endif
switchroutineROM_END:
		


