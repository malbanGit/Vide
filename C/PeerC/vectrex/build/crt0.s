
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	crt0.c
;----- asm -----
	.bank rom(BASE=0x0000,SIZE=0x8000,FSFX=_rom)
	.area .cartridge	(BANK=rom) 
	.area .text  			(BANK=rom)
	.area .text.hot		(BANK=rom)
	.area .text.unlikely	(BANK=rom)
	
	.bank ram(BASE=0xc880,SIZE=0x036b,FSFX=_ram)
	.area .data  (BANK=ram)
	.area .bss   (BANK=ram)
	
		.area .text					
	_crt0_init_data:				
		ldu		#s_.text			
		leau	l_.text,u			
		leau	l_.text.hot,u		
		leau	l_.text.unlikely,u	
		ldy		#s_.data			
		ldx		#l_.data			
		beq		_crt0_init_bss		
	_crt0_copy_data:				
		lda		,u+					
		sta		,y+					
		leax	-1,x				
		bne		_crt0_copy_data		
	_crt0_init_bss:				
		ldy		#s_.bss				
		ldx		#l_.bss				
		beq		_crt0_startup		
	_crt0_zero_bss:				
		clr		,y+					
		leax	-1,x				
		bne		_crt0_zero_bss		
	_crt0_startup:					
		jsr		_main				
		tstb						
		ble		_crt0_restart		
		clr		0xcbfe;	cold reset	
	_crt0_restart:					
		jmp 	0xf000;	rum			
	
