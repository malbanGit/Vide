                              1 ;;; gcc for m6809 : Mar 17 2019 12:45:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O3
                              5 	.module	crt0.c
                              6 ; GNU C (GCC) version 4.3.6 (gcc6809) (m6809-unknown-none)
                              7 ;	compiled by GNU C version 7.4.0, GMP version 4.3.2, MPFR version 2.4.2.
                              8 ; GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
                              9 ; options passed:  -O3 -fno-gcse -fverbose-asm -W -Wall -Wextra
                             10 ; -Wconversion -fomit-frame-pointer -fno-toplevel-reorder -mint8
                             11 ; -msoft-reg-count=0 -std=gnu99 -fno-time-report
                             12 ; -IC:\Dev\Vide\C\PeerC\vectrex\include -D__RUM_FUNCTION=1
                             13 ; -DOMMIT_FRAMEPOINTER=1 crt0.c
                             14 ; options enabled:  -falign-loops -fargument-alias -fauto-inc-dec
                             15 ; -fbranch-count-reg -fcaller-saves -fcommon -fcprop-registers
                             16 ; -fcrossjumping -fcse-follow-jumps -fdefer-pop
                             17 ; -fdelete-null-pointer-checks -fearly-inlining
                             18 ; -feliminate-unused-debug-types -fexpensive-optimizations
                             19 ; -fforward-propagate -ffunction-cse -fgcse-after-reload -fgcse-lm
                             20 ; -fguess-branch-probability -fident -fif-conversion -fif-conversion2
                             21 ; -finline-functions -finline-functions-called-once
                             22 ; -finline-small-functions -fipa-pure-const -fipa-reference -fivopts
                             23 ; -fkeep-static-consts -fleading-underscore -fmath-errno -fmerge-constants
                             24 ; -fmerge-debug-strings -fmove-loop-invariants -fomit-frame-pointer
                             25 ; -foptimize-register-move -foptimize-sibling-calls -fpcc-struct-return
                             26 ; -fpeephole -fpeephole2 -fpredictive-commoning -fregmove -freorder-blocks
                             27 ; -freorder-functions -frerun-cse-after-loop -fsched-interblock
                             28 ; -fsched-spec -fsched-stalled-insns-dep -fsigned-zeros
                             29 ; -fsplit-ivs-in-unroller -fsplit-wide-types -fstrict-aliasing
                             30 ; -fstrict-overflow -fthread-jumps -ftrapping-math -ftree-ccp -ftree-ch
                             31 ; -ftree-copy-prop -ftree-copyrename -ftree-dce -ftree-dominator-opts
                             32 ; -ftree-dse -ftree-fre -ftree-loop-im -ftree-loop-ivcanon
                             33 ; -ftree-loop-optimize -ftree-parallelize-loops= -ftree-pre -ftree-reassoc
                             34 ; -ftree-salias -ftree-scev-cprop -ftree-sink -ftree-sra -ftree-store-ccp
                             35 ; -ftree-ter -ftree-vect-loop-version -ftree-vectorize -ftree-vrp
                             36 ; -funit-at-a-time -funswitch-loops -fverbose-asm -fzero-initialized-in-bss
                             37 
                             38 ; Compiler executable checksum: 8f282e2d9663ae6148257c524e608c63
                             39 
                             40 ;----- asm -----
                             41 	.bank rom(BASE=0x0000,SIZE=0xC000,FSFX=_rom)
                             42 	.area .cartridge		(BANK=rom)
                             43 	.area .bootloader		(CSEG,BANK=rom)
                             44 	.area .bankswitch.data	(DSEG,BANK=rom)
                             45 	.area .bankswitch.code	(CSEG,BANK=rom)
                             46 	.area .text  			(BANK=rom)
                             47 	.area .text.hot		(BANK=rom)
                             48 	.area .text.unlikely	(BANK=rom)
                             49 	.area .text.unlikely	(BANK=rom)
                             50 	.area .text.last		(BANK=rom)
                             51 	
                             52 	.bank ram(BASE=0xc880,SIZE=0x036b,FSFX=_ram)
                             53 	.area .data  (BANK=ram)
                             54 	.area .bss   (BANK=ram)
                             55 	
                             56 		.area .bootloader			
   0000                      57 	_crt0_init_data:				
   0000 CE 00 3B      [ 3]   58 		ldu		#s_.text			
   0003 33 C9 00 00   [ 8]   59 		leau	l_.text,u			
   0007 33 C9 00 00   [ 8]   60 		leau	l_.text.hot,u		
   000B 33 C9 00 00   [ 8]   61 		leau	l_.text.unlikely,u	
   000F 10 8E C8 80   [ 4]   62 		ldy		#s_.data			
   0013 8E 00 00      [ 3]   63 		ldx		#l_.data			
   0016 27 17         [ 3]   64 		beq		_crt0_startup		
   0018                      65 	_crt0_copy_data:				
   0018 A6 C0         [ 6]   66 		lda		,u+					
   001A A7 A0         [ 6]   67 		sta		,y+					
   001C 30 1F         [ 5]   68 		leax	-1,x				
   001E 26 F8         [ 3]   69 		bne		_crt0_copy_data		
   0020                      70 	_crt0_init_bss:				
   0020 10 8E C8 80   [ 4]   71 		ldy		#s_.bss				
   0024 8E 00 00      [ 3]   72 		ldx		#l_.bss				
   0027 27 06         [ 3]   73 		beq		_crt0_startup		
   0029                      74 	_crt0_zero_bss:				
   0029 6F A0         [ 8]   75 		clr		,y+					
   002B 30 1F         [ 5]   76 		leax	-1,x				
   002D 26 FA         [ 3]   77 		bne		_crt0_zero_bss		
   002F                      78 	_crt0_startup:					
   002F BD 00 00      [ 8]   79 		jsr		_main				
   0032 5D            [ 2]   80 		tstb						
   0033 2F 03         [ 3]   81 		ble		_crt0_restart		
   0035 7F CB FE      [ 7]   82 		clr		0xcbfe;	cold reset	
   0038                      83 	_crt0_restart:					
   0038 7E F0 00      [ 4]   84 		jmp 	0xf000;	rum			
                             85 	
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  3 A$crt0$58          0000 GR  |   3 A$crt0$59          0003 GR
  3 A$crt0$60          0007 GR  |   3 A$crt0$61          000B GR
  3 A$crt0$62          000F GR  |   3 A$crt0$63          0013 GR
  3 A$crt0$64          0016 GR  |   3 A$crt0$66          0018 GR
  3 A$crt0$67          001A GR  |   3 A$crt0$68          001C GR
  3 A$crt0$69          001E GR  |   3 A$crt0$71          0020 GR
  3 A$crt0$72          0024 GR  |   3 A$crt0$73          0027 GR
  3 A$crt0$75          0029 GR  |   3 A$crt0$76          002B GR
  3 A$crt0$77          002D GR  |   3 A$crt0$79          002F GR
  3 A$crt0$80          0032 GR  |   3 A$crt0$81          0033 GR
  3 A$crt0$82          0035 GR  |   3 A$crt0$84          0038 GR
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
   3 .bootloader      size   3B   flags C180
   4 .bankswitch.da   size    0   flags C0C0
   5 .bankswitch.co   size    0   flags C080
   6 .text            size    0   flags 8080
   7 .text.hot        size    0   flags 8080
   8 .text.unlikely   size    0   flags 8080
   9 .text.last       size    0   flags 8080
[ram]
   A .data            size    0   flags 8080
   B .bss             size    0   flags 8080

