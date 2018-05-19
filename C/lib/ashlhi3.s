; shift d x positions left
; input x
; output x unchanged
; output d

_ashlhi3:
	pshs	x
start_ashlhi3:
	leax	-1,x
	cmpx	#-1
	beq	end__ashlhi3
	aslb
	rola
	bra	start_ashlhi3
end__ashlhi3:
	puls	x,pc
	
	