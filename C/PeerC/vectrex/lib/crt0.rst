                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	crt0.c
                              6 ;----- asm -----
                              7 	.bank rom(BASE=0x0000,SIZE=0x8000,FSFX=_rom)
                              8 	.area .cartridge	(BANK=rom) 
                              9 	.area .text  			(BANK=rom)
                             10 	.area .text.hot		(BANK=rom)
                             11 	.area .text.unlikely	(BANK=rom)
                             12 	
                             13 	.bank ram(BASE=0xc880,SIZE=0x036b,FSFX=_ram)
                             14 	.area .data  (BANK=ram)
                             15 	.area .bss   (BANK=ram)
                             16 	
                             17 		.area .text					
   0019                      18 	_crt0_init_data:				
   0019 CE 00 19      [ 3]   19 		ldu		#s_.text			
   001C 33 C9 7F 0E   [ 8]   20 		leau	l_.text,u			
   0020 33 C9 00 00   [ 8]   21 		leau	l_.text.hot,u		
   0024 33 C9 00 00   [ 8]   22 		leau	l_.text.unlikely,u	
   0028 10 8E C8 80   [ 4]   23 		ldy		#s_.data			
   002C 8E 00 1A      [ 3]   24 		ldx		#l_.data			
   002F 27 08         [ 3]   25 		beq		_crt0_init_bss		
   0031                      26 	_crt0_copy_data:				
   0031 A6 C0         [ 6]   27 		lda		,u+					
   0033 A7 A0         [ 6]   28 		sta		,y+					
   0035 30 1F         [ 5]   29 		leax	-1,x				
   0037 26 F8         [ 3]   30 		bne		_crt0_copy_data		
   0039                      31 	_crt0_init_bss:				
   0039 10 8E C8 9A   [ 4]   32 		ldy		#s_.bss				
   003D 8E 02 29      [ 3]   33 		ldx		#l_.bss				
   0040 27 06         [ 3]   34 		beq		_crt0_startup		
   0042                      35 	_crt0_zero_bss:				
   0042 6F A0         [ 8]   36 		clr		,y+					
   0044 30 1F         [ 5]   37 		leax	-1,x				
   0046 26 FA         [ 3]   38 		bne		_crt0_zero_bss		
   0048                      39 	_crt0_startup:					
   0048 BD 56 FD      [ 8]   40 		jsr		_main				
   004B 5D            [ 2]   41 		tstb						
   004C 2F 03         [ 3]   42 		ble		_crt0_restart		
   004E 7F CB FE      [ 7]   43 		clr		0xcbfe;	cold reset	
   0051                      44 	_crt0_restart:					
   0051 7E F0 00      [ 4]   45 		jmp 	0xf000;	rum			
                             46 	
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  3 _crt0_copy_dat     0018 R   |   3 _crt0_init_bss     0020 R
  3 _crt0_init_dat     0000 R   |   3 _crt0_restart      0038 R
  3 _crt0_startup      002F R   |   3 _crt0_zero_bss     0029 R
    _main              **** GX  |     l_.bss             **** GX
    l_.data            **** GX  |     l_.text            **** GX
    l_.text.hot        **** GX  |     l_.text.unlike     **** GX
    s_.bss             **** GX  |     s_.data            **** GX
    s_.text            **** GX

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[rom]
   2 .cartridge       size    0   flags 8080
   3 .text            size   3B   flags 8180
   4 .text.hot        size    0   flags 8080
   5 .text.unlikely   size    0   flags 8080
[ram]
   6 .data            size    0   flags 8080
   7 .bss             size    0   flags 8080

