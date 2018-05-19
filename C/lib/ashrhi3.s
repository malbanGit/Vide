; shift d x positions right
; input x
; output x unchanged
; output d

_ashrhi3:
	pshs	x
start_ashrhi3:
	leax	-1,x
	cmpx	#-1
	beq	end_ashrhi3
	asra
	rorb
	bra	start_ashrhi3
end_ashrhi3:
	puls	x,pc