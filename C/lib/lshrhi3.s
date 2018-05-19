; shift d x positions right
; input x
; output x unchanged
; output d


_lshrhi3:
	pshs	x
start_lshrhi3:
	leax	-1,x
	cmpx	#-1
	beq	end_lshrhi3
	lsra
	rorb
	bra	start_lshrhi3
end_lshrhi3:
	puls	x,pc