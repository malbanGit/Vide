;;; gcc for m6809 : Mar 17 2019 12:45:32
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mabi=bx -mint8 -fomit-frame-pointer -O3
	.module	crt0.c
; GNU C (GCC) version 4.3.6 (gcc6809) (m6809-unknown-none)
;	compiled by GNU C version 7.4.0, GMP version 4.3.2, MPFR version 2.4.2.
; GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
; options passed:  -O3 -fno-gcse -fverbose-asm -W -Wall -Wextra
; -Wconversion -fomit-frame-pointer -fno-toplevel-reorder -mint8
; -msoft-reg-count=0 -std=gnu99 -fno-time-report
; -IC:\Dev\Vide\C\PeerC\vectrex\include -D__RUM_FUNCTION=1
; -DOMMIT_FRAMEPOINTER=1 crt0.c
; options enabled:  -falign-loops -fargument-alias -fauto-inc-dec
; -fbranch-count-reg -fcaller-saves -fcommon -fcprop-registers
; -fcrossjumping -fcse-follow-jumps -fdefer-pop
; -fdelete-null-pointer-checks -fearly-inlining
; -feliminate-unused-debug-types -fexpensive-optimizations
; -fforward-propagate -ffunction-cse -fgcse-after-reload -fgcse-lm
; -fguess-branch-probability -fident -fif-conversion -fif-conversion2
; -finline-functions -finline-functions-called-once
; -finline-small-functions -fipa-pure-const -fipa-reference -fivopts
; -fkeep-static-consts -fleading-underscore -fmath-errno -fmerge-constants
; -fmerge-debug-strings -fmove-loop-invariants -fomit-frame-pointer
; -foptimize-register-move -foptimize-sibling-calls -fpcc-struct-return
; -fpeephole -fpeephole2 -fpredictive-commoning -fregmove -freorder-blocks
; -freorder-functions -frerun-cse-after-loop -fsched-interblock
; -fsched-spec -fsched-stalled-insns-dep -fsigned-zeros
; -fsplit-ivs-in-unroller -fsplit-wide-types -fstrict-aliasing
; -fstrict-overflow -fthread-jumps -ftrapping-math -ftree-ccp -ftree-ch
; -ftree-copy-prop -ftree-copyrename -ftree-dce -ftree-dominator-opts
; -ftree-dse -ftree-fre -ftree-loop-im -ftree-loop-ivcanon
; -ftree-loop-optimize -ftree-parallelize-loops= -ftree-pre -ftree-reassoc
; -ftree-salias -ftree-scev-cprop -ftree-sink -ftree-sra -ftree-store-ccp
; -ftree-ter -ftree-vect-loop-version -ftree-vectorize -ftree-vrp
; -funit-at-a-time -funswitch-loops -fverbose-asm -fzero-initialized-in-bss

; Compiler executable checksum: 8f282e2d9663ae6148257c524e608c63

;----- asm -----
	.bank rom(BASE=0x0000,SIZE=0xC000,FSFX=_rom)
	.area .cartridge		(BANK=rom)
	.area .bootloader		(CSEG,BANK=rom)
	.area .bankswitch.data	(DSEG,BANK=rom)
	.area .bankswitch.code	(CSEG,BANK=rom)
	.area .text  			(BANK=rom)
	.area .text.hot		(BANK=rom)
	.area .text.unlikely	(BANK=rom)
	.area .text.unlikely	(BANK=rom)
	.area .text.last		(BANK=rom)
	
	.bank ram(BASE=0xc880,SIZE=0x036b,FSFX=_ram)
	.area .data  (BANK=ram)
	.area .bss   (BANK=ram)
	
		.area .bootloader			
	_crt0_init_data:				
		ldu		#s_.text			
		leau	l_.text,u			
		leau	l_.text.hot,u		
		leau	l_.text.unlikely,u	
		ldy		#s_.data			
		ldx		#l_.data			
		beq		_crt0_startup		
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
	
