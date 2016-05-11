;;;;;;;
; RAM ;
;;;;;;;
logo_curframe			EQU		$C880
plr_pattern				EQU		$C881
plr_geilmusik			EQU		$C882
plr_geilmusik_hi		EQU		$C883
plr_part				EQU		$C884
plr_part_hi				EQU		$C885
plr_part_init			EQU		$C886
plr_part_init_hi		EQU		$C887
gfx_xpos				EQU		$C888
gfx_dx   				EQU		$C88A
gfx_intensity			EQU		$C88B
gfx_di					EQU		$C88C
gfx_dxsubcnt			EQU		$C88E
font_sinidx				EQU		$C894
loader_delay			EQU	    font_sinidx
loader_int1				EQU		loader_delay +1
loader_int2				EQU		loader_int1 +1
loader_int3				EQU		loader_int2	+1
loader_delay2			EQU		loader_int3 +1
loader_chars			EQU		loader_delay2 +1
loader_prompt			EQU		loader_chars +1

font_sinidx2			EQU		$C895
grid_cnt				EQU		font_sinidx2 + 1	
sintabaddr				EQU		$C896
chartabaddr				EQU		$C898
chartabend				EQU		$C89A
vid_transtab			EQU		chartabend +2
vid_frametab			EQU		vid_transtab + 2
vid_framecount			EQU		vid_frametab + 2

remainderX				EQU		vid_framecount + 1
remainderY				EQU		remainderX + 1
logo_temp				EQU		remainderY + 1
logo_compressed			EQU		logo_temp+560

	
