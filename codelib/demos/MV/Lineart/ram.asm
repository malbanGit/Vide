;;;;;;;
; RAM ;
;;;;;;;
; overall ram
cartnum 				equ		$C880
plr_pattern				equ		$C882
plr_geilmusik			equ		$C883
plr_geilmusik_hi		equ		$C884
plr_part				equ		$C885
plr_part_hi				equ		$C886
plr_part_init			equ		$C887
plr_part_init_hi		equ		$C888
; per-bank ram
switchroutine 			equ plr_part_init_hi+1
logo_curframe			equ		$C889
gfx_xpos				equ		$C88A
gfx_dx   				equ		$C88B
gfx_intensity			equ		$C88C
gfx_di					equ		$C88D
gfx_dxsubcnt			equ		$C88F
gfx_count2              equ     $C890
font_sinidx				equ		$C894
loader_delay			equ	    font_sinidx
loader_int1				equ		loader_delay +1
loader_int2				equ		loader_int1 +1
loader_int3				equ		loader_int2	+1
loader_delay2			equ		loader_int3 +1
loader_chars			equ		loader_delay2 +1
loader_prompt			equ		loader_chars +1

font_sinidx2			equ		$C895
grid_cnt				equ		font_sinidx2 + 1	
sintabaddr				equ		$C896
chartabaddr				equ		$C898
chartabend				equ		$C89A
vid_transtab			equ		chartabend +2
vid_frametab			equ		vid_transtab + 2
vid_framecount			equ		vid_frametab + 2
vid_running				equ		vid_framecount + 1
remainderX				equ		vid_running + 1
remainderY				equ		remainderX + 1
vid_pattern				equ		remainderY + 1
logo_rom				equ		vid_pattern + 1
logo_temp				equ		logo_rom + 2
logo_compressed			equ		logo_temp+560

greet_loopcounter		equ		$C888
greet_nextindex			equ		$C889
greet_tbl_indices		equ		$C88A
greet_tbl_timers		equ		$C88F

