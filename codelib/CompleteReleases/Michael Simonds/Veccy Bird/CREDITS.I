;Credits
;print hardware list format
;     height, width, rel y, rel x, string, 0x80,                        ;
;     height, width, rel y, rel x, string, 0x80,                        ;
;     0x00                            
Credit_0
	fcb	-6,55,80,-110
	db   "    PROGRAMMING & ART"
	db	$80
	
	fcb	-6,55,35,-110
	db   "       INSPIRED BY"
	db   $80

	fcb	-6,55,-30,-110
	db   "        GREETINGS"
	db   $80	
	
	db	$00		;list terminator
	
Credit_1

	fcb	-4,35,75,-45
	db   "MICHAEL SIMONDS"
	db	$80

	
	
	fcb	-4,35,20,-35
	db   "QUACK(ZX81)"
	db	$80
	
	fcb	-4,35,10,-58
	db   "DONG (FLAPPY) NGUYEN"
	db	$80
	

	
	fcb	-4,35,-45,-38
	db   "THE EPS CREW"
	db	$80
	
	fcb	-4,35,-55,-60
	db   "VECTOR GAMING FORUMS"
	db	$80
	
	fcb	-4,35,-65,-85
	db   "TUMBER, SALOMON & ALL PIONEERS"
	db	$80
	
		fcb	-4,35,-75,-30
	db   "RICHARD H"
	db	$80
	
		fcb	-4,35,-85,-50
	db   "SARAH BEN AND MAX"
	db	$80
	
	;	fcb	-4,35,-110,-58
	;db   "VECTREX REGENERATION"
	;db	$80
	
	
	db	$00		;list terminator
