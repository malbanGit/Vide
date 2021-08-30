                              1 ;;; gcc for m6809 : Mar 17 2019 15:46:08
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O3
                              5 	.module	crt0.c
                              6 ; GNU C (GCC) version 4.3.6 (gcc6809) (m6809-unknown-none)
                              7 ;	compiled by GNU C version 4.2.1 Compatible Apple LLVM 10.0.0 (clang-1000.11.45.5), GMP version 4.3.2, MPFR version 2.4.2.
                              8 ; GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
                              9 ; options passed:  -O3 -fno-gcse -fverbose-asm -W -Wall -Wextra
                             10 ; -Wconversion -Werror -fomit-frame-pointer -fno-toplevel-reorder -mint8
                             11 ; -msoft-reg-count=0 -std=gnu99 -fno-time-report
                             12 ; -I/Users/chrissalo/NetBeansProjects/Vide/C/PeerC/vectrex/include
                             13 ; -D__RUM_FUNCTION=1 -DOMMIT_FRAMEPOINTER=1
                             14 ; -I/Users/chrissalo/NetBeansProjects/Vide/crt0/include
                             15 ; /Users/chrissalo/NetBeansProjects/Vide/crt0/source/crt0.c
                             16 ; options enabled:  -falign-loops -fargument-alias -fauto-inc-dec
                             17 ; -fbranch-count-reg -fcaller-saves -fcommon -fcprop-registers
                             18 ; -fcrossjumping -fcse-follow-jumps -fdefer-pop
                             19 ; -fdelete-null-pointer-checks -fearly-inlining
                             20 ; -feliminate-unused-debug-types -fexpensive-optimizations
                             21 ; -fforward-propagate -ffunction-cse -fgcse-after-reload -fgcse-lm
                             22 ; -fguess-branch-probability -fident -fif-conversion -fif-conversion2
                             23 ; -finline-functions -finline-functions-called-once
                             24 ; -finline-small-functions -fipa-pure-const -fipa-reference -fivopts
                             25 ; -fkeep-static-consts -fleading-underscore -fmath-errno -fmerge-constants
                             26 ; -fmerge-debug-strings -fmove-loop-invariants -fomit-frame-pointer
                             27 ; -foptimize-register-move -foptimize-sibling-calls -fpcc-struct-return
                             28 ; -fpeephole -fpeephole2 -fpredictive-commoning -fregmove -freorder-blocks
                             29 ; -freorder-functions -frerun-cse-after-loop -fsched-interblock
                             30 ; -fsched-spec -fsched-stalled-insns-dep -fsigned-zeros
                             31 ; -fsplit-ivs-in-unroller -fsplit-wide-types -fstrict-aliasing
                             32 ; -fstrict-overflow -fthread-jumps -ftrapping-math -ftree-ccp -ftree-ch
                             33 ; -ftree-copy-prop -ftree-copyrename -ftree-dce -ftree-dominator-opts
                             34 ; -ftree-dse -ftree-fre -ftree-loop-im -ftree-loop-ivcanon
                             35 ; -ftree-loop-optimize -ftree-parallelize-loops= -ftree-pre -ftree-reassoc
                             36 ; -ftree-salias -ftree-scev-cprop -ftree-sink -ftree-sra -ftree-store-ccp
                             37 ; -ftree-ter -ftree-vect-loop-version -ftree-vectorize -ftree-vrp
                             38 ; -funit-at-a-time -funswitch-loops -fverbose-asm -fzero-initialized-in-bss
                             39 
                             40 ; Compiler executable checksum: a36a086a9355d13dad12c3def897e1f7
                             41 
                             42 ;----- asm -----
                             43 	.bank rom(BASE=0x0000,SIZE=0xC000,FSFX=_rom)
                             44 	.area .cartridge		(BANK=rom)
                             45 	.area .text  			(BANK=rom)
                             46 	.area .text.hot		(BANK=rom)
                             47 	.area .text.unlikely	(BANK=rom)
                             48 	
                             49 	.bank ram(BASE=0xc880,SIZE=0x036b,FSFX=_ram)
                             50 	.area .data  (BANK=ram)
                             51 	.area .bss   (BANK=ram)
                             52 	
                             53 		.area .text					
   001B                      54 	_crt0_init_data:				
   001B CE 00 1B      [ 3]   55 		ldu		#s_.text			
   001E 33 C9 01 0F   [ 8]   56 		leau	l_.text,u			
   0022 33 C9 00 00   [ 8]   57 		leau	l_.text.hot,u		
   0026 33 C9 00 00   [ 8]   58 		leau	l_.text.unlikely,u	
   002A 10 8E C8 80   [ 4]   59 		ldy		#s_.data			
   002E 8E 00 01      [ 3]   60 		ldx		#l_.data			
   0031 27 08         [ 3]   61 		beq		_crt0_init_bss		
   0033                      62 	_crt0_copy_data:				
   0033 A6 C0         [ 6]   63 		lda		,u+					
   0035 A7 A0         [ 6]   64 		sta		,y+					
   0037 30 1F         [ 5]   65 		leax	-1,x				
   0039 26 F8         [ 3]   66 		bne		_crt0_copy_data		
   003B                      67 	_crt0_init_bss:				
   003B 10 8E C8 81   [ 4]   68 		ldy		#s_.bss				
   003F 8E 00 00      [ 3]   69 		ldx		#l_.bss				
   0042 27 06         [ 3]   70 		beq		_crt0_startup		
   0044                      71 	_crt0_zero_bss:				
   0044 6F A0         [ 8]   72 		clr		,y+					
   0046 30 1F         [ 5]   73 		leax	-1,x				
   0048 26 FA         [ 3]   74 		bne		_crt0_zero_bss		
   004A                      75 	_crt0_startup:					
   004A BD 00 56      [ 8]   76 		jsr		_main				
   004D 5D            [ 2]   77 		tstb						
   004E 2F 03         [ 3]   78 		ble		_crt0_restart		
   0050 7F CB FE      [ 7]   79 		clr		0xcbfe;	cold reset	
   0053                      80 	_crt0_restart:					
   0053 7E F0 00      [ 4]   81 		jmp 	0xf000;	rum			
                             82 	
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  3 A$crt0$55          0000 GR  |   3 A$crt0$56          0003 GR
  3 A$crt0$57          0007 GR  |   3 A$crt0$58          000B GR
  3 A$crt0$59          000F GR  |   3 A$crt0$60          0013 GR
  3 A$crt0$61          0016 GR  |   3 A$crt0$63          0018 GR
  3 A$crt0$64          001A GR  |   3 A$crt0$65          001C GR
  3 A$crt0$66          001E GR  |   3 A$crt0$68          0020 GR
  3 A$crt0$69          0024 GR  |   3 A$crt0$70          0027 GR
  3 A$crt0$72          0029 GR  |   3 A$crt0$73          002B GR
  3 A$crt0$74          002D GR  |   3 A$crt0$76          002F GR
  3 A$crt0$77          0032 GR  |   3 A$crt0$78          0033 GR
  3 A$crt0$79          0035 GR  |   3 A$crt0$81          0038 GR
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

