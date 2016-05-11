;--- music data [created with Mod2Vectrex v1.03 - 16.08.2005 by Wolfram Heyer (the@BigBadWolF.de)] ---

songLength	EQU	$30
songLoop    EQU $04

;;;;;;;;;;   Pattern  ; Part
script:
	FDB	pattern04, part_loader, init_part_loader  ; 12		loader
	FDB	pattern03, part_loader, init_part_loader
	FDB	pattern00, part_loader, init_part_loader
	FDB	pattern00, part_loader, init_part_loader
	FDB	pattern01, part_opener, init_part_opener   ; prestart opener
	FDB	pattern02, part_opener, init_part_opener		
	FDB	pattern00, part_opener, init_part_opener  
	FDB	pattern05, part_opener, init_part_opener   
	FDB	pattern06, part_opener, init_part_opener   
	FDB	pattern07, part_opener_logo, init_part_opener			; opener - logo
	FDB	pattern08, part_opener_logo, init_part_opener   
	FDB	pattern09, part_opener_logo, init_part_opener   
	FDB	pattern06, part3, init_part3   ; 12
	FDB	pattern0B, part3, init_part3   
	FDB	pattern0C, part_tentacle, init_part_tentacle   
	FDB	pattern0A, part_tentacle, init_part_tentacle   
	FDB	pattern00, part4a, init_part4a   
	FDB	pattern18, part4a, init_part4a   
	FDB	pattern15, part4, init_part4	; 16      cubes
	FDB	pattern16, part4, init_part4
	FDB	pattern15, part4, init_part4
	FDB	pattern17, part4, init_part4
	FDB	pattern19, part4, init_part4    
	FDB	pattern1A, part4, init_part4
	FDB	pattern19, part4, init_part4
	FDB	pattern1B, part4, init_part4
	FDB	pattern00, part5, init_part5	; 8
	FDB	pattern00, part5, init_part5
	FDB	pattern0D, part_girl2, init_part_girl2
	FDB	pattern10, part_girl2, init_part_girl2
	FDB	pattern0E, part_grid, init_grid	; 6			grid
	FDB	pattern0F, part_grid, init_grid
	FDB	pattern11, part_grid, init_grid
	FDB	pattern0D, part_metalvotze, init_part_metalvotze	; 6
	FDB	pattern01, part_metalvotze, init_part_metalvotze
	FDB	pattern1C, part7b, init_part7b
	FDB	pattern15, part_elite, init_elite    ;8			elite
	FDB	pattern16, part_elite, init_elite
	FDB	pattern19, part_elite, init_elite	
	FDB	pattern1B, part_elite, init_elite
	FDB	pattern00, greetings, init_greetings    ; 4
	FDB	pattern00, greetings, init_greetings
	FDB	pattern12, greetings, init_greetings	; 8
	FDB	pattern13, greetings, init_greetings
	FDB	pattern00, greetings, init_greetings
	FDB	pattern14, greetings, init_greetings
	FDB	pattern14, part_eod, init_part_eod
	FDB	pattern14, part_eod, init_part_eod

pattern00:
	FDB	adsr
	FDB	twang

	FCB	$FF,	$8C,	$1F,	$02	; $00
	FCB			$13,	$02	; $01
	FCB		$00,		$02	; $02
	FCB	$00,			$02	; $03
	FCB	$FF,	$8C,	$1F,	$02	; $04
	FCB			$13,	$02	; $05
	FCB	$C1,	$00,		$02	; $06
	FCB	$00,			$02	; $07
	FCB	$EF,	$8C,	$24,	$02	; $08
	FCB			$18,	$02	; $09
	FCB		$00,		$02	; $0A
	FCB	$00,			$02	; $0B
	FCB	$C1,	$8C,	$24,	$02	; $0C
	FCB			$18,	$02	; $0D
	FCB	$C1,	$00,		$02	; $0E
	FCB	$00,			$02	; $0F
	FCB	$C1,	$8C,	$1D,	$02	; $10
	FCB			$11,	$02	; $11
	FCB		$00,		$02	; $12
	FCB	$00,			$02	; $13
	FCB	$FF,	$8C,	$1D,	$02	; $14
	FCB			$11,	$02	; $15
	FCB	$C1,	$00,		$02	; $16
	FCB	$00,			$02	; $17
	FCB	$EF,	$8C,	$22,	$02	; $18
	FCB			$16,	$02	; $19
	FCB		$00,		$02	; $1A
	FCB	$00,			$02	; $1B
	FCB	$C1,	$8C,	$22,	$02	; $1C
	FCB			$16,	$02	; $1D
	FCB	$C1,	$00,		$02	; $1E
	FCB	$00,			$02	; $1F
	FCB	$FF,	$8C,	$1B,	$02	; $20
	FCB			$0F,	$02	; $21
	FCB		$00,		$02	; $22
	FCB	$00,			$02	; $23
	FCB	$FF,	$8C,	$1B,	$02	; $24
	FCB			$0F,	$02	; $25
	FCB	$C1,	$00,		$02	; $26
	FCB	$00,			$02	; $27
	FCB	$EF,	$8C,	$1F,	$02	; $28
	FCB			$13,	$02	; $29
	FCB		$00,		$02	; $2A
	FCB	$00,			$02	; $2B
	FCB	$C1,	$8C,	$1F,	$02	; $2C
	FCB			$13,	$02	; $2D
	FCB	$C1,	$00,		$02	; $2E
	FCB	$00,			$02	; $2F
	FCB	$C1,	$9B,	$1D,	$02	; $30
	FCB			$11,	$02	; $31
	FCB		$0F,		$02	; $32
	FCB	$00,			$02	; $33
	FCB	$FF,	$98,	$1F,	$02	; $34
	FCB			$13,	$02	; $35
	FCB	$C1,	$0C,		$02	; $36
	FCB	$00,			$02	; $37
	FCB	$EF,	$9A,	$1D,	$02	; $38
	FCB			$11,	$02	; $39
	FCB		$0E,		$02	; $3A
	FCB	$00,			$02	; $3B
	FCB	$EF,	$96,	$22,	$02	; $3C
	FCB			$16,	$02	; $3D
	FCB	$C1,	$0A,		$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern01:
	FDB	adsr
	FDB	twang

	FCB	$FF,	$8F,	$1F,	$02	; $00
	FCB			$13,	$02	; $01
	FCB		$83,	$0F,	$02	; $02
	FCB			$0C,	$02	; $03
	FCB	$FF,	$8F,	$1F,	$02	; $04
	FCB	$00,			$02	; $05
	FCB		$03,		$02	; $06
	FCB	$00,			$02	; $07
	FCB	$EF,	$8F,	$24,	$02	; $08
	FCB			$13,	$02	; $09
	FCB		$83,	$0F,	$02	; $0A
	FCB			$0C,	$02	; $0B
	FCB	$C1,	$8F,	$27,	$02	; $0C
	FCB			$13,	$02	; $0D
	FCB		$83,	$0F,	$02	; $0E
	FCB			$0C,	$02	; $0F
	FCB	$C1,	$8F,	$1D,	$02	; $10
	FCB	$00,			$02	; $11
	FCB		$03,		$02	; $12
	FCB	$00,			$02	; $13
	FCB	$FF,	$8F,	$1D,	$02	; $14
	FCB			$13,	$02	; $15
	FCB		$83,	$0F,	$02	; $16
	FCB			$0C,	$02	; $17
	FCB	$EF,	$8F,	$22,	$02	; $18
	FCB			$13,	$02	; $19
	FCB		$83,	$0F,	$02	; $1A
	FCB			$0C,	$02	; $1B
	FCB	$C1,	$8F,	$22,	$02	; $1C
	FCB	$00,			$02	; $1D
	FCB	$C1,	$03,		$02	; $1E
	FCB	$00,			$02	; $1F
	FCB	$FF,	$8F,	$1B,	$02	; $20
	FCB			$13,	$02	; $21
	FCB		$83,	$0F,	$02	; $22
	FCB			$0C,	$02	; $23
	FCB	$FF,	$8F,	$1B,	$02	; $24
	FCB	$00,			$02	; $25
	FCB		$03,		$02	; $26
	FCB	$00,			$02	; $27
	FCB	$EF,	$8F,	$1F,	$02	; $28
	FCB			$13,	$02	; $29
	FCB		$83,	$0F,	$02	; $2A
	FCB			$0C,	$02	; $2B
	FCB	$C1,	$8F,	$1F,	$02	; $2C
	FCB			$13,	$02	; $2D
	FCB		$83,	$0F,	$02	; $2E
	FCB			$0C,	$02	; $2F
	FCB	$C1,	$8F,	$1D,	$02	; $30
	FCB	$00,			$02	; $31
	FCB		$03,		$02	; $32
	FCB	$00,			$02	; $33
	FCB	$FF,	$8F,	$1F,	$02	; $34
	FCB			$13,	$02	; $35
	FCB		$83,	$0F,	$02	; $36
	FCB			$0C,	$02	; $37
	FCB	$EF,	$8F,	$1D,	$02	; $38
	FCB			$13,	$02	; $39
	FCB		$83,	$0F,	$02	; $3A
	FCB			$0C,	$02	; $3B
	FCB	$EF,	$8F,	$22,	$02	; $3C
	FCB	$00,			$02	; $3D
	FCB	$C1,	$03,		$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern02:
	FDB	adsr
	FDB	twang

	FCB	$FF,	$96,	$1F,	$02	; $00
	FCB			$0A,	$02	; $01
	FCB		$8A,	$0E,	$02	; $02
	FCB			$11,	$02	; $03
	FCB	$FF,	$96,	$1F,	$02	; $04
	FCB			$0A,	$02	; $05
	FCB		$8A,	$0E,	$02	; $06
	FCB			$11,	$02	; $07
	FCB	$EF,	$96,	$24,	$02	; $08
	FCB			$0A,	$02	; $09
	FCB		$8A,	$0E,	$02	; $0A
	FCB			$11,	$02	; $0B
	FCB	$C1,	$96,	$24,	$02	; $0C
	FCB			$0A,	$02	; $0D
	FCB		$8A,	$0E,	$02	; $0E
	FCB			$11,	$02	; $0F
	FCB	$C1,	$96,	$1D,	$02	; $10
	FCB	$00,			$02	; $11
	FCB		$0A,		$02	; $12
	FCB	$00,			$02	; $13
	FCB	$FF,	$96,	$1D,	$02	; $14
	FCB			$0A,	$02	; $15
	FCB		$8A,	$0E,	$02	; $16
	FCB			$11,	$02	; $17
	FCB	$EF,	$96,	$22,	$02	; $18
	FCB			$0A,	$02	; $19
	FCB		$8A,	$0E,	$02	; $1A
	FCB			$11,	$02	; $1B
	FCB	$C1,	$96,	$22,	$02	; $1C
	FCB	$00,			$02	; $1D
	FCB	$C1,	$0A,		$02	; $1E
	FCB	$00,			$02	; $1F
	FCB	$FF,	$96,	$1B,	$02	; $20
	FCB			$0A,	$02	; $21
	FCB		$8A,	$0E,	$02	; $22
	FCB			$11,	$02	; $23
	FCB	$FF,	$96,	$1B,	$02	; $24
	FCB	$00,			$02	; $25
	FCB		$0A,		$02	; $26
	FCB	$00,			$02	; $27
	FCB	$EF,	$96,	$1F,	$02	; $28
	FCB			$0A,	$02	; $29
	FCB		$8A,	$0E,	$02	; $2A
	FCB			$11,	$02	; $2B
	FCB	$C1,	$96,	$1F,	$02	; $2C
	FCB	$00,			$02	; $2D
	FCB		$0A,		$02	; $2E
	FCB	$00,			$02	; $2F
	FCB	$C1,	$96,	$1D,	$02	; $30
	FCB			$0A,	$02	; $31
	FCB		$8A,	$0E,	$02	; $32
	FCB			$11,	$02	; $33
	FCB	$FF,	$96,	$1F,	$02	; $34
	FCB	$00,			$02	; $35
	FCB		$0A,		$02	; $36
	FCB	$00,			$02	; $37
	FCB	$EF,	$96,	$1D,	$02	; $38
	FCB			$0A,	$02	; $39
	FCB		$8A,	$0E,	$02	; $3A
	FCB			$11,	$02	; $3B
	FCB	$EF,	$96,	$22,	$02	; $3C
	FCB	$00,			$02	; $3D
	FCB	$C1,	$0A,		$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern03:
	FDB	adsr
	FDB	twang

	FCB			$2B,	$02	; $00
	FCB	$00,			$02	; $01
	FCB	$00,			$02	; $02
	FCB	$00,			$02	; $03
	FCB			$2B,	$02	; $04
	FCB	$00,			$02	; $05
	FCB	$00,			$02	; $06
	FCB	$00,			$02	; $07
	FCB		$AB,	$30,	$02	; $08
	FCB	$00,			$02	; $09
	FCB	$00,			$02	; $0A
	FCB	$00,			$02	; $0B
	FCB		$AB,	$30,	$02	; $0C
	FCB	$00,			$02	; $0D
	FCB	$00,			$02	; $0E
	FCB	$00,			$02	; $0F
	FCB		$B0,	$29,	$02	; $10
	FCB	$00,			$02	; $11
	FCB	$00,			$02	; $12
	FCB	$00,			$02	; $13
	FCB		$B0,	$29,	$02	; $14
	FCB	$00,			$02	; $15
	FCB	$00,			$02	; $16
	FCB	$00,			$02	; $17
	FCB		$A9,	$2E,	$02	; $18
	FCB	$00,			$02	; $19
	FCB	$00,			$02	; $1A
	FCB	$00,			$02	; $1B
	FCB		$A9,	$2E,	$02	; $1C
	FCB	$00,			$02	; $1D
	FCB	$00,			$02	; $1E
	FCB	$00,			$02	; $1F
	FCB		$AE,	$27,	$02	; $20
	FCB	$00,			$02	; $21
	FCB	$00,			$02	; $22
	FCB	$00,			$02	; $23
	FCB		$AE,	$27,	$02	; $24
	FCB	$00,			$02	; $25
	FCB	$00,			$02	; $26
	FCB	$00,			$02	; $27
	FCB		$A7,	$2B,	$02	; $28
	FCB	$00,			$02	; $29
	FCB	$00,			$02	; $2A
	FCB	$00,			$02	; $2B
	FCB		$A7,	$2B,	$02	; $2C
	FCB	$00,			$02	; $2D
	FCB	$00,			$02	; $2E
	FCB	$00,			$02	; $2F
	FCB		$AB,	$29,	$02	; $30
	FCB	$00,			$02	; $31
	FCB	$00,			$02	; $32
	FCB	$00,			$02	; $33
	FCB		$AB,	$2B,	$02	; $34
	FCB	$00,			$02	; $35
	FCB	$00,			$02	; $36
	FCB	$00,			$02	; $37
	FCB		$A9,	$29,	$02	; $38
	FCB	$00,			$02	; $39
	FCB	$00,			$02	; $3A
	FCB	$00,			$02	; $3B
	FCB		$AB,	$2E,	$02	; $3C
	FCB	$00,			$02	; $3D
	FCB	$00,			$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern04:
	FDB	adsr
	FDB	twang

	FCB			$2B,	$02	; $00
	FCB	$00,			$02	; $01
	FCB	$00,			$02	; $02
	FCB	$00,			$02	; $03
	FCB			$2B,	$02	; $04
	FCB	$00,			$02	; $05
	FCB	$00,			$02	; $06
	FCB	$00,			$02	; $07
	FCB		$13,		$02	; $08
	FCB	$00,			$02	; $09
	FCB	$00,			$02	; $0A
	FCB	$00,			$02	; $0B
	FCB		$13,		$02	; $0C
	FCB	$00,			$02	; $0D
	FCB	$00,			$02	; $0E
	FCB	$00,			$02	; $0F
	FCB			$29,	$02	; $10
	FCB	$00,			$02	; $11
	FCB	$00,			$02	; $12
	FCB	$00,			$02	; $13
	FCB			$29,	$02	; $14
	FCB	$00,			$02	; $15
	FCB	$00,			$02	; $16
	FCB	$00,			$02	; $17
	FCB		$11,		$02	; $18
	FCB	$00,			$02	; $19
	FCB	$00,			$02	; $1A
	FCB	$00,			$02	; $1B
	FCB		$11,		$02	; $1C
	FCB	$00,			$02	; $1D
	FCB	$00,			$02	; $1E
	FCB	$00,			$02	; $1F
	FCB			$27,	$02	; $20
	FCB	$00,			$02	; $21
	FCB	$00,			$02	; $22
	FCB	$00,			$02	; $23
	FCB			$27,	$02	; $24
	FCB	$00,			$02	; $25
	FCB	$00,			$02	; $26
	FCB	$00,			$02	; $27
	FCB		$0F,		$02	; $28
	FCB	$00,			$02	; $29
	FCB	$00,			$02	; $2A
	FCB	$00,			$02	; $2B
	FCB		$0F,		$02	; $2C
	FCB	$00,			$02	; $2D
	FCB	$00,			$02	; $2E
	FCB	$00,			$02	; $2F
	FCB			$29,	$02	; $30
	FCB	$00,			$02	; $31
	FCB	$00,			$02	; $32
	FCB	$00,			$02	; $33
	FCB			$29,	$02	; $34
	FCB	$00,			$02	; $35
	FCB	$00,			$02	; $36
	FCB	$00,			$02	; $37
	FCB		$11,		$02	; $38
	FCB	$00,			$02	; $39
	FCB	$00,			$02	; $3A
	FCB	$00,			$02	; $3B
	FCB		$11,		$02	; $3C
	FCB	$00,			$02	; $3D
	FCB	$00,			$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern05:
	FDB	adsr
	FDB	twang

	FCB	$FF,	$8C,	$1F,	$02	; $00
	FCB			$13,	$02	; $01
	FCB		$00,		$02	; $02
	FCB	$00,			$02	; $03
	FCB		$8C,	$1F,	$02	; $04
	FCB			$13,	$02	; $05
	FCB	$C1,	$00,		$02	; $06
	FCB	$00,			$02	; $07
	FCB		$8C,	$24,	$02	; $08
	FCB			$18,	$02	; $09
	FCB		$00,		$02	; $0A
	FCB	$00,			$02	; $0B
	FCB	$C1,	$8C,	$24,	$02	; $0C
	FCB			$18,	$02	; $0D
	FCB	$C1,	$00,		$02	; $0E
	FCB	$00,			$02	; $0F
	FCB	$C1,	$8C,	$1D,	$02	; $10
	FCB			$11,	$02	; $11
	FCB		$00,		$02	; $12
	FCB	$00,			$02	; $13
	FCB		$8C,	$1D,	$02	; $14
	FCB			$11,	$02	; $15
	FCB	$C1,	$00,		$02	; $16
	FCB	$00,			$02	; $17
	FCB	$EF,	$8C,	$22,	$02	; $18
	FCB			$16,	$02	; $19
	FCB		$00,		$02	; $1A
	FCB	$00,			$02	; $1B
	FCB	$C1,	$8C,	$22,	$02	; $1C
	FCB			$16,	$02	; $1D
	FCB	$C1,	$00,		$02	; $1E
	FCB	$00,			$02	; $1F
	FCB	$FF,	$A4,	$1B,	$02	; $20
	FCB		$A3,	$0F,	$02	; $21
	FCB		$22,		$02	; $22
	FCB		$21,		$02	; $23
	FCB		$A0,	$1B,	$02	; $24
	FCB		$9F,	$0F,	$02	; $25
	FCB	$C1,	$1E,		$02	; $26
	FCB		$1D,		$02	; $27
	FCB		$9C,	$1F,	$02	; $28
	FCB		$9B,	$13,	$02	; $29
	FCB		$1A,		$02	; $2A
	FCB		$19,		$02	; $2B
	FCB	$C1,	$98,	$1F,	$02	; $2C
	FCB		$97,	$13,	$02	; $2D
	FCB	$C1,	$16,		$02	; $2E
	FCB		$15,		$02	; $2F
	FCB	$EF,	$94,	$1D,	$02	; $30
	FCB	$C1,	$93,	$11,	$02	; $31
	FCB	$EF,	$12,		$02	; $32
	FCB	$C1,	$11,		$02	; $33
	FCB	$EF,	$90,	$1F,	$02	; $34
	FCB		$8F,	$13,	$02	; $35
	FCB		$0E,		$02	; $36
	FCB		$0D,		$02	; $37
	FCB	$EF,	$8C,	$1D,	$02	; $38
	FCB		$8B,	$11,	$02	; $39
	FCB		$0A,		$02	; $3A
	FCB		$09,		$02	; $3B
	FCB	$EF,	$88,	$22,	$02	; $3C
	FCB		$87,	$16,	$02	; $3D
	FCB	$C1,	$06,		$02	; $3E
	FCB		$05,		$02	; $3F
	FCB	$00,	$80	; end-marker

pattern06:
	FDB	adsr
	FDB	twang

	FCB	$A2,	$FF,	$1F,	$02	; $00
	FCB	$A2,		$13,	$02	; $01
	FCB	$A4,	$00,		$02	; $02
	FCB	$00,			$02	; $03
	FCB	$A4,	$8C,	$1F,	$02	; $04
	FCB	$A4,		$13,	$02	; $05
	FCB		$00,		$02	; $06
	FCB	$00,			$02	; $07
	FCB	$A2,	$EF,	$24,	$02	; $08
	FCB	$A2,		$18,	$02	; $09
	FCB	$A2,	$00,		$02	; $0A
	FCB	$00,			$02	; $0B
	FCB	$A4,	$8C,	$24,	$02	; $0C
	FCB	$A4,		$18,	$02	; $0D
	FCB	$A4,	$00,		$02	; $0E
	FCB	$24,			$02	; $0F
	FCB		$8C,	$1D,	$02	; $10
	FCB			$11,	$02	; $11
	FCB		$00,		$02	; $12
	FCB	$00,			$02	; $13
	FCB	$A2,	$8C,	$1D,	$02	; $14
	FCB			$11,	$02	; $15
	FCB	$A2,	$00,		$02	; $16
	FCB	$00,			$02	; $17
	FCB	$A4,	$EF,	$22,	$02	; $18
	FCB	$A4,		$16,	$02	; $19
	FCB	$A4,	$00,		$02	; $1A
	FCB	$00,			$02	; $1B
	FCB	$A6,	$8C,	$22,	$02	; $1C
	FCB			$16,	$02	; $1D
	FCB	$A6,	$00,		$02	; $1E
	FCB	$00,			$02	; $1F
	FCB	$A7,	$FF,	$1B,	$02	; $20
	FCB	$A7,		$0F,	$02	; $21
	FCB	$A7,	$00,		$02	; $22
	FCB	$27,			$02	; $23
	FCB		$8C,	$1B,	$02	; $24
	FCB			$0F,	$02	; $25
	FCB		$00,		$02	; $26
	FCB	$00,			$02	; $27
	FCB	$A6,	$EF,	$1F,	$02	; $28
	FCB	$A7,		$13,	$02	; $29
	FCB	$A7,	$00,		$02	; $2A
	FCB	$00,			$02	; $2B
	FCB	$A7,	$8C,	$1F,	$02	; $2C
	FCB			$13,	$02	; $2D
	FCB	$A7,	$00,		$02	; $2E
	FCB	$00,			$02	; $2F
	FCB	$A7,	$8C,	$1D,	$02	; $30
	FCB	$A7,		$11,	$02	; $31
	FCB	$A7,	$00,		$02	; $32
	FCB	$00,			$02	; $33
	FCB	$A6,	$8C,	$1F,	$02	; $34
	FCB	$A6,		$13,	$02	; $35
	FCB	$A6,	$00,		$02	; $36
	FCB	$00,			$02	; $37
	FCB	$A4,	$EF,	$1D,	$02	; $38
	FCB	$A4,		$11,	$02	; $39
	FCB	$A4,	$00,		$02	; $3A
	FCB	$24,			$02	; $3B
	FCB		$EF,	$22,	$02	; $3C
	FCB			$16,	$02	; $3D
	FCB		$41,		$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern07:
	FDB	adsr
	FDB	twang

	FCB	$A9,	$FF,	$1F,	$02	; $00
	FCB	$A9,		$13,	$02	; $01
	FCB	$AB,	$83,	$0F,	$02	; $02
	FCB	$AB,		$0C,	$02	; $03
	FCB		$8F,	$1F,	$02	; $04
	FCB	$00,			$02	; $05
	FCB		$03,		$02	; $06
	FCB	$00,			$02	; $07
	FCB	$AB,	$EF,	$24,	$02	; $08
	FCB			$13,	$02	; $09
	FCB	$AB,	$83,	$0F,	$02	; $0A
	FCB			$0C,	$02	; $0B
	FCB	$AB,	$8F,	$27,	$02	; $0C
	FCB	$AB,		$13,	$02	; $0D
	FCB		$83,	$0F,	$02	; $0E
	FCB			$0C,	$02	; $0F
	FCB	$AB,	$8F,	$1D,	$02	; $10
	FCB	$2B,			$02	; $11
	FCB	$AB,	$03,		$02	; $12
	FCB	$00,			$02	; $13
	FCB	$A9,	$8F,	$1D,	$02	; $14
	FCB	$A9,		$13,	$02	; $15
	FCB	$A9,	$83,	$0F,	$02	; $16
	FCB			$0C,	$02	; $17
	FCB	$A7,	$EF,	$22,	$02	; $18
	FCB	$A7,		$13,	$02	; $19
	FCB	$A7,	$83,	$0F,	$02	; $1A
	FCB			$0C,	$02	; $1B
	FCB	$A9,	$8F,	$22,	$02	; $1C
	FCB	$29,			$02	; $1D
	FCB	$A9,	$03,		$02	; $1E
	FCB	$29,			$02	; $1F
	FCB	$A9,	$FF,	$1B,	$02	; $20
	FCB	$A9,		$13,	$02	; $21
	FCB	$A8,	$83,	$0F,	$02	; $22
	FCB	$A8,		$0C,	$02	; $23
	FCB	$A7,	$8F,	$1B,	$02	; $24
	FCB	$27,			$02	; $25
	FCB	$A7,	$03,		$02	; $26
	FCB	$27,			$02	; $27
	FCB	$A7,	$EF,	$1F,	$02	; $28
	FCB	$A7,		$13,	$02	; $29
	FCB	$A7,	$83,	$0F,	$02	; $2A
	FCB			$0C,	$02	; $2B
	FCB	$A7,	$8F,	$1F,	$02	; $2C
	FCB			$13,	$02	; $2D
	FCB	$A7,	$83,	$0F,	$02	; $2E
	FCB	$A7,		$0C,	$02	; $2F
	FCB		$8F,	$1D,	$02	; $30
	FCB	$00,			$02	; $31
	FCB		$03,		$02	; $32
	FCB	$00,			$02	; $33
	FCB	$A6,	$8F,	$1F,	$02	; $34
	FCB	$A7,		$13,	$02	; $35
	FCB		$83,	$0F,	$02	; $36
	FCB			$0C,	$02	; $37
	FCB	$A6,	$EF,	$1D,	$02	; $38
	FCB	$A7,		$13,	$02	; $39
	FCB		$83,	$0F,	$02	; $3A
	FCB			$0C,	$02	; $3B
	FCB		$EF,	$22,	$02	; $3C
	FCB	$00,			$02	; $3D
	FCB		$41,		$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern08:
	FDB	adsr
	FDB	twang

	FCB	$A4,	$FF,	$1F,	$02	; $00
	FCB	$A6,		$0A,	$02	; $01
	FCB		$8A,	$0E,	$02	; $02
	FCB			$11,	$02	; $03
	FCB	$A4,	$96,	$1F,	$02	; $04
	FCB	$A6,		$0A,	$02	; $05
	FCB		$8A,	$0E,	$02	; $06
	FCB			$11,	$02	; $07
	FCB	$A7,	$EF,	$24,	$02	; $08
	FCB	$A7,		$0A,	$02	; $09
	FCB		$8A,	$0E,	$02	; $0A
	FCB			$11,	$02	; $0B
	FCB	$A6,	$96,	$24,	$02	; $0C
	FCB	$A6,		$0A,	$02	; $0D
	FCB		$8A,	$0E,	$02	; $0E
	FCB			$11,	$02	; $0F
	FCB		$96,	$1D,	$02	; $10
	FCB	$00,			$02	; $11
	FCB		$0A,		$02	; $12
	FCB	$00,			$02	; $13
	FCB	$A1,	$96,	$1D,	$02	; $14
	FCB	$A2,		$0A,	$02	; $15
	FCB	$A2,	$8A,	$0E,	$02	; $16
	FCB	$A2,		$11,	$02	; $17
	FCB		$EF,	$22,	$02	; $18
	FCB			$0A,	$02	; $19
	FCB		$8A,	$0E,	$02	; $1A
	FCB			$11,	$02	; $1B
	FCB		$96,	$22,	$02	; $1C
	FCB	$00,			$02	; $1D
	FCB		$0A,		$02	; $1E
	FCB	$00,			$02	; $1F
	FCB	$A6,	$FF,	$1B,	$02	; $20
	FCB	$A6,		$0A,	$02	; $21
	FCB	$A6,	$8A,	$0E,	$02	; $22
	FCB	$A6,		$11,	$02	; $23
	FCB	$A6,	$96,	$1B,	$02	; $24
	FCB	$26,			$02	; $25
	FCB	$A6,	$0A,		$02	; $26
	FCB	$00,			$02	; $27
	FCB	$A7,	$EF,	$1F,	$02	; $28
	FCB	$A7,		$0A,	$02	; $29
	FCB	$A7,	$8A,	$0E,	$02	; $2A
	FCB			$11,	$02	; $2B
	FCB	$A6,	$96,	$1F,	$02	; $2C
	FCB	$26,			$02	; $2D
	FCB	$A6,	$0A,		$02	; $2E
	FCB	$26,			$02	; $2F
	FCB	$A6,	$96,	$1D,	$02	; $30
	FCB	$A6,		$0A,	$02	; $31
	FCB	$A6,	$8A,	$0E,	$02	; $32
	FCB	$A6,		$11,	$02	; $33
	FCB	$A4,	$96,	$1F,	$02	; $34
	FCB	$24,			$02	; $35
	FCB	$A3,	$0A,		$02	; $36
	FCB	$23,			$02	; $37
	FCB	$A2,	$EF,	$1D,	$02	; $38
	FCB	$A2,		$0A,	$02	; $39
	FCB	$A2,	$8A,	$0E,	$02	; $3A
	FCB	$A2,		$11,	$02	; $3B
	FCB		$EF,	$22,	$02	; $3C
	FCB	$00,			$02	; $3D
	FCB		$41,		$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern09:
	FDB	adsr
	FDB	twang

	FCB	$9F,	$FF,	$1F,	$02	; $00
	FCB	$9F,		$09,	$02	; $01
	FCB	$A1,	$85,	$0C,	$02	; $02
	FCB	$A1,		$11,	$02	; $03
	FCB		$91,	$1F,	$02	; $04
	FCB			$09,	$02	; $05
	FCB		$85,	$0C,	$02	; $06
	FCB			$11,	$02	; $07
	FCB	$A1,	$EF,	$24,	$02	; $08
	FCB	$A1,		$09,	$02	; $09
	FCB	$A1,	$85,	$0C,	$02	; $0A
	FCB	$A1,		$11,	$02	; $0B
	FCB	$A1,	$91,	$24,	$02	; $0C
	FCB	$A1,		$09,	$02	; $0D
	FCB	$A1,	$85,	$0C,	$02	; $0E
	FCB			$11,	$02	; $0F
	FCB	$9F,	$91,	$1D,	$02	; $10
	FCB	$9F,		$09,	$02	; $11
	FCB	$A1,	$85,	$0C,	$02	; $12
	FCB			$11,	$02	; $13
	FCB	$A1,	$91,	$1D,	$02	; $14
	FCB	$A1,		$09,	$02	; $15
	FCB		$85,	$0C,	$02	; $16
	FCB			$11,	$02	; $17
	FCB	$A2,	$EF,	$22,	$02	; $18
	FCB	$A2,		$09,	$02	; $19
	FCB	$A2,	$85,	$0C,	$02	; $1A
	FCB			$11,	$02	; $1B
	FCB	$A3,	$91,	$22,	$02	; $1C
	FCB	$A4,		$09,	$02	; $1D
	FCB	$A4,	$85,	$0C,	$02	; $1E
	FCB	$A4,		$11,	$02	; $1F
	FCB	$A4,	$FF,	$1B,	$02	; $20
	FCB	$A4,		$09,	$02	; $21
	FCB	$A4,	$85,	$0C,	$02	; $22
	FCB	$A4,		$11,	$02	; $23
	FCB	$A4,	$91,	$1B,	$02	; $24
	FCB	$A4,		$09,	$02	; $25
	FCB	$A4,	$85,	$0C,	$02	; $26
	FCB	$A4,		$11,	$02	; $27
	FCB		$EF,	$1F,	$02	; $28
	FCB			$09,	$02	; $29
	FCB		$85,	$0C,	$02	; $2A
	FCB			$11,	$02	; $2B
	FCB		$91,	$1F,	$02	; $2C
	FCB			$09,	$02	; $2D
	FCB		$85,	$0C,	$02	; $2E
	FCB			$11,	$02	; $2F
	FCB	$A7,	$93,	$1D,	$02	; $30
	FCB	$A6,		$13,	$02	; $31
	FCB		$87,	$1A,	$02	; $32
	FCB			$1D,	$02	; $33
	FCB	$A7,	$93,	$1F,	$02	; $34
	FCB	$A6,		$13,	$02	; $35
	FCB		$87,	$1A,	$02	; $36
	FCB			$1D,	$02	; $37
	FCB	$A6,	$EF,	$1D,	$02	; $38
	FCB	$A6,		$13,	$02	; $39
	FCB		$87,	$1A,	$02	; $3A
	FCB			$1D,	$02	; $3B
	FCB	$A6,	$EF,	$22,	$02	; $3C
	FCB	$A6,		$13,	$02	; $3D
	FCB		$C1,	$1A,	$02	; $3E
	FCB			$1D,	$02	; $3F
	FCB	$00,	$80	; end-marker

pattern0A:
	FDB	adsr
	FDB	twang

	FCB	$A2,	$FF,	$1F,	$02	; $00
	FCB	$A2,		$09,	$02	; $01
	FCB	$A4,	$85,	$0C,	$02	; $02
	FCB	$A4,		$11,	$02	; $03
	FCB		$91,	$1F,	$02	; $04
	FCB			$09,	$02	; $05
	FCB		$85,	$0C,	$02	; $06
	FCB			$11,	$02	; $07
	FCB	$A2,	$EF,	$24,	$02	; $08
	FCB			$09,	$02	; $09
	FCB	$A4,	$85,	$0C,	$02	; $0A
	FCB	$A4,		$11,	$02	; $0B
	FCB	$A4,	$91,	$24,	$02	; $0C
	FCB	$A4,		$09,	$02	; $0D
	FCB	$A4,	$85,	$0C,	$02	; $0E
	FCB			$11,	$02	; $0F
	FCB	$A2,	$91,	$1D,	$02	; $10
	FCB	$A4,		$09,	$02	; $11
	FCB	$A4,	$85,	$0C,	$02	; $12
	FCB	$A4,		$11,	$02	; $13
	FCB	$A4,	$91,	$1D,	$02	; $14
	FCB	$A4,		$09,	$02	; $15
	FCB		$85,	$0C,	$02	; $16
	FCB			$11,	$02	; $17
	FCB		$EF,	$22,	$02	; $18
	FCB			$09,	$02	; $19
	FCB		$85,	$0C,	$02	; $1A
	FCB			$11,	$02	; $1B
	FCB		$91,	$22,	$02	; $1C
	FCB			$09,	$02	; $1D
	FCB		$85,	$0C,	$02	; $1E
	FCB			$11,	$02	; $1F
	FCB	$A6,	$FF,	$1B,	$02	; $20
	FCB	$A6,		$09,	$02	; $21
	FCB	$A6,	$85,	$0C,	$02	; $22
	FCB			$11,	$02	; $23
	FCB	$A7,	$91,	$1B,	$02	; $24
	FCB	$A7,		$09,	$02	; $25
	FCB	$A7,	$85,	$0C,	$02	; $26
	FCB			$11,	$02	; $27
	FCB	$A6,	$EF,	$1F,	$02	; $28
	FCB	$A6,		$09,	$02	; $29
	FCB	$A6,	$85,	$0C,	$02	; $2A
	FCB	$A6,		$11,	$02	; $2B
	FCB		$91,	$1F,	$02	; $2C
	FCB			$09,	$02	; $2D
	FCB		$85,	$0C,	$02	; $2E
	FCB			$11,	$02	; $2F
	FCB	$A6,	$93,	$1D,	$02	; $30
	FCB	$A6,		$13,	$02	; $31
	FCB		$87,	$1A,	$02	; $32
	FCB			$1D,	$02	; $33
	FCB	$A6,	$93,	$1F,	$02	; $34
	FCB	$A6,		$13,	$02	; $35
	FCB		$87,	$1A,	$02	; $36
	FCB			$1D,	$02	; $37
	FCB	$AE,	$EF,	$1D,	$02	; $38
	FCB	$AE,		$13,	$02	; $39
	FCB		$87,	$1A,	$02	; $3A
	FCB			$1D,	$02	; $3B
	FCB	$AD,	$EF,	$22,	$02	; $3C
	FCB	$AD,		$13,	$02	; $3D
	FCB		$C1,	$1A,	$02	; $3E
	FCB			$1D,	$02	; $3F
	FCB	$00,	$80	; end-marker

pattern0B:
	FDB	adsr
	FDB	twang

	FCB	$A9,	$FF,	$1F,	$02	; $00
	FCB	$A9,		$13,	$02	; $01
	FCB	$AB,	$83,	$0F,	$02	; $02
	FCB	$AB,		$0C,	$02	; $03
	FCB		$8F,	$1F,	$02	; $04
	FCB	$00,			$02	; $05
	FCB		$03,		$02	; $06
	FCB	$00,			$02	; $07
	FCB	$AB,	$EF,	$24,	$02	; $08
	FCB			$13,	$02	; $09
	FCB	$AB,	$83,	$0F,	$02	; $0A
	FCB			$0C,	$02	; $0B
	FCB	$AB,	$8F,	$27,	$02	; $0C
	FCB	$AB,		$13,	$02	; $0D
	FCB		$83,	$0F,	$02	; $0E
	FCB			$0C,	$02	; $0F
	FCB	$AB,	$8F,	$1D,	$02	; $10
	FCB	$2B,			$02	; $11
	FCB	$AB,	$03,		$02	; $12
	FCB	$00,			$02	; $13
	FCB	$A9,	$8F,	$1D,	$02	; $14
	FCB	$A9,		$13,	$02	; $15
	FCB	$A9,	$83,	$0F,	$02	; $16
	FCB			$0C,	$02	; $17
	FCB	$AE,	$EF,	$22,	$02	; $18
	FCB	$AE,		$13,	$02	; $19
	FCB	$AE,	$83,	$0F,	$02	; $1A
	FCB			$0C,	$02	; $1B
	FCB	$B0,	$8F,	$22,	$02	; $1C
	FCB	$30,			$02	; $1D
	FCB	$B0,	$03,		$02	; $1E
	FCB	$30,			$02	; $1F
	FCB	$B0,	$FF,	$1B,	$02	; $20
	FCB	$B0,		$13,	$02	; $21
	FCB	$B0,	$83,	$0F,	$02	; $22
	FCB	$B0,		$0C,	$02	; $23
	FCB	$AF,	$8F,	$1B,	$02	; $24
	FCB	$2E,			$02	; $25
	FCB	$AD,	$03,		$02	; $26
	FCB	$2C,			$02	; $27
	FCB	$AB,	$EF,	$1F,	$02	; $28
	FCB	$AB,		$13,	$02	; $29
	FCB	$AB,	$83,	$0F,	$02	; $2A
	FCB			$0C,	$02	; $2B
	FCB	$AB,	$8F,	$1F,	$02	; $2C
	FCB			$13,	$02	; $2D
	FCB	$AB,	$83,	$0F,	$02	; $2E
	FCB	$AB,		$0C,	$02	; $2F
	FCB		$8F,	$1D,	$02	; $30
	FCB	$00,			$02	; $31
	FCB		$03,		$02	; $32
	FCB	$00,			$02	; $33
	FCB	$AB,	$8F,	$1F,	$02	; $34
	FCB	$AB,		$13,	$02	; $35
	FCB		$83,	$0F,	$02	; $36
	FCB			$0C,	$02	; $37
	FCB	$AE,	$EF,	$1D,	$02	; $38
	FCB	$AE,		$13,	$02	; $39
	FCB		$83,	$0F,	$02	; $3A
	FCB			$0C,	$02	; $3B
	FCB		$EF,	$22,	$02	; $3C
	FCB	$00,			$02	; $3D
	FCB		$41,		$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern0C:
	FDB	adsr
	FDB	twang

	FCB	$AB,	$FF,	$1F,	$02	; $00
	FCB	$A7,		$0A,	$02	; $01
	FCB		$8A,	$0E,	$02	; $02
	FCB			$11,	$02	; $03
	FCB	$AB,	$96,	$1F,	$02	; $04
	FCB	$A7,		$0A,	$02	; $05
	FCB		$8A,	$0E,	$02	; $06
	FCB			$11,	$02	; $07
	FCB		$EF,	$24,	$02	; $08
	FCB			$0A,	$02	; $09
	FCB		$8A,	$0E,	$02	; $0A
	FCB			$11,	$02	; $0B
	FCB	$A9,	$96,	$24,	$02	; $0C
	FCB	$A6,		$0A,	$02	; $0D
	FCB		$8A,	$0E,	$02	; $0E
	FCB			$11,	$02	; $0F
	FCB	$A9,	$96,	$1D,	$02	; $10
	FCB	$26,			$02	; $11
	FCB		$0A,		$02	; $12
	FCB	$00,			$02	; $13
	FCB		$96,	$1D,	$02	; $14
	FCB			$0A,	$02	; $15
	FCB		$8A,	$0E,	$02	; $16
	FCB			$11,	$02	; $17
	FCB	$A7,	$EF,	$22,	$02	; $18
	FCB	$A4,		$0A,	$02	; $19
	FCB		$8A,	$0E,	$02	; $1A
	FCB			$11,	$02	; $1B
	FCB	$A7,	$96,	$22,	$02	; $1C
	FCB	$24,			$02	; $1D
	FCB		$0A,		$02	; $1E
	FCB	$00,			$02	; $1F
	FCB		$FF,	$1B,	$02	; $20
	FCB			$0A,	$02	; $21
	FCB		$8A,	$0E,	$02	; $22
	FCB			$11,	$02	; $23
	FCB	$A6,	$96,	$1B,	$02	; $24
	FCB	$22,			$02	; $25
	FCB		$0A,		$02	; $26
	FCB	$00,			$02	; $27
	FCB	$A6,	$EF,	$1F,	$02	; $28
	FCB	$A2,		$0A,	$02	; $29
	FCB		$8A,	$0E,	$02	; $2A
	FCB			$11,	$02	; $2B
	FCB		$96,	$1F,	$02	; $2C
	FCB	$00,			$02	; $2D
	FCB		$0A,		$02	; $2E
	FCB	$00,			$02	; $2F
	FCB	$A7,	$96,	$1D,	$02	; $30
	FCB	$A2,		$0A,	$02	; $31
	FCB	$A2,	$8A,	$0E,	$02	; $32
	FCB			$11,	$02	; $33
	FCB	$A6,	$96,	$1F,	$02	; $34
	FCB	$1F,			$02	; $35
	FCB	$9F,	$0A,		$02	; $36
	FCB	$00,			$02	; $37
	FCB	$A4,	$EF,	$1D,	$02	; $38
	FCB	$9D,		$0A,	$02	; $39
	FCB	$9D,	$8A,	$0E,	$02	; $3A
	FCB			$11,	$02	; $3B
	FCB	$A7,	$EF,	$22,	$02	; $3C
	FCB	$22,			$02	; $3D
	FCB	$A2,	$41,		$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern0D:
	FDB	adsr
	FDB	twang

	FCB		$FF,	$1F,	$02	; $00
	FCB			$13,	$02	; $01
	FCB	$00,			$02	; $02
	FCB	$00,			$02	; $03
	FCB		$80,	$1F,	$02	; $04
	FCB			$13,	$02	; $05
	FCB	$00,			$02	; $06
	FCB	$00,			$02	; $07
	FCB		$EF,	$24,	$02	; $08
	FCB			$18,	$02	; $09
	FCB	$00,			$02	; $0A
	FCB	$00,			$02	; $0B
	FCB		$80,	$24,	$02	; $0C
	FCB			$18,	$02	; $0D
	FCB	$00,			$02	; $0E
	FCB	$00,			$02	; $0F
	FCB		$80,	$1D,	$02	; $10
	FCB			$11,	$02	; $11
	FCB	$00,			$02	; $12
	FCB	$00,			$02	; $13
	FCB		$80,	$1D,	$02	; $14
	FCB			$11,	$02	; $15
	FCB	$00,			$02	; $16
	FCB	$00,			$02	; $17
	FCB		$EF,	$22,	$02	; $18
	FCB			$16,	$02	; $19
	FCB	$00,			$02	; $1A
	FCB	$00,			$02	; $1B
	FCB		$80,	$22,	$02	; $1C
	FCB			$16,	$02	; $1D
	FCB	$00,			$02	; $1E
	FCB	$00,			$02	; $1F
	FCB		$FF,	$1B,	$02	; $20
	FCB			$0F,	$02	; $21
	FCB	$00,			$02	; $22
	FCB	$00,			$02	; $23
	FCB		$80,	$1B,	$02	; $24
	FCB			$0F,	$02	; $25
	FCB	$00,			$02	; $26
	FCB	$00,			$02	; $27
	FCB		$EF,	$1F,	$02	; $28
	FCB			$13,	$02	; $29
	FCB	$00,			$02	; $2A
	FCB	$00,			$02	; $2B
	FCB		$80,	$1F,	$02	; $2C
	FCB			$13,	$02	; $2D
	FCB	$00,			$02	; $2E
	FCB	$00,			$02	; $2F
	FCB		$8F,	$1D,	$02	; $30
	FCB			$11,	$02	; $31
	FCB	$0F,			$02	; $32
	FCB	$00,			$02	; $33
	FCB		$8F,	$1F,	$02	; $34
	FCB			$13,	$02	; $35
	FCB	$0C,			$02	; $36
	FCB	$00,			$02	; $37
	FCB		$EF,	$1D,	$02	; $38
	FCB			$11,	$02	; $39
	FCB	$0E,			$02	; $3A
	FCB	$00,			$02	; $3B
	FCB		$8A,	$22,	$02	; $3C
	FCB			$16,	$02	; $3D
	FCB	$0A,			$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern0E:
	FDB	adsr
	FDB	twang

	FCB		$83,	$03,	$02	; $00
	FCB	$00,			$02	; $01
	FCB	$03,			$02	; $02
	FCB	$00,			$02	; $03
	FCB		$83,	$03,	$02	; $04
	FCB	$00,			$02	; $05
	FCB	$03,			$02	; $06
	FCB	$00,			$02	; $07
	FCB		$83,	$03,	$02	; $08
	FCB	$00,			$02	; $09
	FCB	$03,			$02	; $0A
	FCB	$00,			$02	; $0B
	FCB		$83,	$03,	$02	; $0C
	FCB	$00,			$02	; $0D
	FCB	$03,			$02	; $0E
	FCB	$00,			$02	; $0F
	FCB		$83,	$03,	$02	; $10
	FCB	$00,			$02	; $11
	FCB	$03,			$02	; $12
	FCB	$00,			$02	; $13
	FCB		$83,	$03,	$02	; $14
	FCB	$00,			$02	; $15
	FCB	$03,			$02	; $16
	FCB	$00,			$02	; $17
	FCB		$83,	$03,	$02	; $18
	FCB	$00,			$02	; $19
	FCB	$03,			$02	; $1A
	FCB	$00,			$02	; $1B
	FCB		$83,	$03,	$02	; $1C
	FCB	$00,			$02	; $1D
	FCB	$03,			$02	; $1E
	FCB	$00,			$02	; $1F
	FCB		$83,	$03,	$02	; $20
	FCB	$00,			$02	; $21
	FCB	$03,			$02	; $22
	FCB	$00,			$02	; $23
	FCB		$83,	$03,	$02	; $24
	FCB	$00,			$02	; $25
	FCB	$03,			$02	; $26
	FCB	$00,			$02	; $27
	FCB		$83,	$03,	$02	; $28
	FCB	$00,			$02	; $29
	FCB	$03,			$02	; $2A
	FCB	$00,			$02	; $2B
	FCB		$83,	$03,	$02	; $2C
	FCB	$00,			$02	; $2D
	FCB	$03,			$02	; $2E
	FCB	$00,			$02	; $2F
	FCB		$83,	$03,	$02	; $30
	FCB	$00,			$02	; $31
	FCB	$03,			$02	; $32
	FCB	$00,			$02	; $33
	FCB		$82,	$02,	$02	; $34
	FCB	$00,			$02	; $35
	FCB	$82,	$83,	$03,	$02	; $36
	FCB	$00,			$02	; $37
	FCB	$83,	$85,	$05,	$02	; $38
	FCB	$00,			$02	; $39
	FCB	$05,			$02	; $3A
	FCB	$00,			$02	; $3B
	FCB		$87,	$07,	$02	; $3C
	FCB	$00,			$02	; $3D
	FCB	$07,			$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern0F:
	FDB	adsr
	FDB	twang

	FCB		$85,	$05,	$02	; $00
	FCB	$00,			$02	; $01
	FCB	$05,			$02	; $02
	FCB	$00,			$02	; $03
	FCB		$85,	$05,	$02	; $04
	FCB	$00,			$02	; $05
	FCB	$05,			$02	; $06
	FCB	$00,			$02	; $07
	FCB		$85,	$05,	$02	; $08
	FCB	$00,			$02	; $09
	FCB	$05,			$02	; $0A
	FCB	$00,			$02	; $0B
	FCB		$85,	$05,	$02	; $0C
	FCB	$00,			$02	; $0D
	FCB	$05,			$02	; $0E
	FCB	$00,			$02	; $0F
	FCB		$85,	$05,	$02	; $10
	FCB	$00,			$02	; $11
	FCB	$05,			$02	; $12
	FCB	$00,			$02	; $13
	FCB		$85,	$05,	$02	; $14
	FCB	$00,			$02	; $15
	FCB	$05,			$02	; $16
	FCB	$00,			$02	; $17
	FCB		$85,	$05,	$02	; $18
	FCB	$00,			$02	; $19
	FCB	$05,			$02	; $1A
	FCB	$00,			$02	; $1B
	FCB		$85,	$05,	$02	; $1C
	FCB	$00,			$02	; $1D
	FCB	$05,			$02	; $1E
	FCB	$00,			$02	; $1F
	FCB		$85,	$05,	$02	; $20
	FCB	$00,			$02	; $21
	FCB	$05,			$02	; $22
	FCB	$00,			$02	; $23
	FCB		$85,	$05,	$02	; $24
	FCB	$00,			$02	; $25
	FCB	$05,			$02	; $26
	FCB	$00,			$02	; $27
	FCB		$85,	$05,	$02	; $28
	FCB	$00,			$02	; $29
	FCB	$05,			$02	; $2A
	FCB	$00,			$02	; $2B
	FCB		$85,	$05,	$02	; $2C
	FCB	$00,			$02	; $2D
	FCB	$05,			$02	; $2E
	FCB	$00,			$02	; $2F
	FCB		$EF,	$05,	$02	; $30
	FCB	$00,			$02	; $31
	FCB	$85,	$41,		$02	; $32
	FCB	$00,			$02	; $33
	FCB		$EF,	$05,	$02	; $34
	FCB	$00,			$02	; $35
	FCB	$05,			$02	; $36
	FCB	$00,			$02	; $37
	FCB		$EF,	$02,	$02	; $38
	FCB	$00,			$02	; $39
	FCB	$02,			$02	; $3A
	FCB	$00,			$02	; $3B
	FCB		$EF,	$02,	$02	; $3C
	FCB	$00,			$02	; $3D
	FCB	$82,	$41,		$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern10:
	FDB	adsr
	FDB	twang

	FCB		$FF,	$00,	$02	; $00
	FCB	$00,			$02	; $01
	FCB	$00,			$02	; $02
	FCB	$00,			$02	; $03
	FCB		$80,	$00,	$02	; $04
	FCB	$00,			$02	; $05
	FCB	$00,			$02	; $06
	FCB	$00,			$02	; $07
	FCB		$EF,	$00,	$02	; $08
	FCB	$00,			$02	; $09
	FCB	$00,			$02	; $0A
	FCB	$00,			$02	; $0B
	FCB		$80,	$00,	$02	; $0C
	FCB	$00,			$02	; $0D
	FCB	$00,			$02	; $0E
	FCB	$00,			$02	; $0F
	FCB		$80,	$00,	$02	; $10
	FCB	$00,			$02	; $11
	FCB	$00,			$02	; $12
	FCB	$00,			$02	; $13
	FCB		$80,	$00,	$02	; $14
	FCB	$00,			$02	; $15
	FCB	$00,			$02	; $16
	FCB	$00,			$02	; $17
	FCB		$EF,	$00,	$02	; $18
	FCB	$00,			$02	; $19
	FCB	$00,			$02	; $1A
	FCB	$00,			$02	; $1B
	FCB		$80,	$00,	$02	; $1C
	FCB	$00,			$02	; $1D
	FCB	$00,			$02	; $1E
	FCB	$00,			$02	; $1F
	FCB		$FF,	$00,	$02	; $20
	FCB	$00,			$02	; $21
	FCB	$00,			$02	; $22
	FCB	$00,			$02	; $23
	FCB		$80,	$00,	$02	; $24
	FCB	$00,			$02	; $25
	FCB	$00,			$02	; $26
	FCB	$00,			$02	; $27
	FCB		$EF,	$00,	$02	; $28
	FCB	$00,			$02	; $29
	FCB	$00,			$02	; $2A
	FCB	$00,			$02	; $2B
	FCB		$80,	$00,	$02	; $2C
	FCB	$00,			$02	; $2D
	FCB	$00,			$02	; $2E
	FCB	$00,			$02	; $2F
	FCB		$8F,	$0F,	$02	; $30
	FCB	$00,			$02	; $31
	FCB	$0F,			$02	; $32
	FCB	$00,			$02	; $33
	FCB		$8F,	$0C,	$02	; $34
	FCB	$00,			$02	; $35
	FCB	$0C,			$02	; $36
	FCB	$00,			$02	; $37
	FCB		$8E,	$0E,	$02	; $38
	FCB	$00,			$02	; $39
	FCB	$0E,			$02	; $3A
	FCB	$00,			$02	; $3B
	FCB		$8A,	$0A,	$02	; $3C
	FCB	$00,			$02	; $3D
	FCB	$0A,			$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern11:
	FDB	adsr
	FDB	twang

	FCB		$FF,	$00,	$02	; $00
	FCB	$00,			$02	; $01
	FCB	$00,			$02	; $02
	FCB	$00,			$02	; $03
	FCB		$80,	$00,	$02	; $04
	FCB	$00,			$02	; $05
	FCB	$00,			$02	; $06
	FCB	$00,			$02	; $07
	FCB		$EF,	$00,	$02	; $08
	FCB	$00,			$02	; $09
	FCB	$00,			$02	; $0A
	FCB	$00,			$02	; $0B
	FCB		$80,	$00,	$02	; $0C
	FCB	$00,			$02	; $0D
	FCB	$00,			$02	; $0E
	FCB	$00,			$02	; $0F
	FCB		$80,	$00,	$02	; $10
	FCB	$00,			$02	; $11
	FCB	$00,			$02	; $12
	FCB	$00,			$02	; $13
	FCB		$80,	$00,	$02	; $14
	FCB	$00,			$02	; $15
	FCB	$00,			$02	; $16
	FCB	$00,			$02	; $17
	FCB		$EF,	$00,	$02	; $18
	FCB	$00,			$02	; $19
	FCB	$00,			$02	; $1A
	FCB	$00,			$02	; $1B
	FCB		$80,	$00,	$02	; $1C
	FCB	$00,			$02	; $1D
	FCB	$00,			$02	; $1E
	FCB	$00,			$02	; $1F
	FCB		$FF,	$00,	$02	; $20
	FCB	$00,			$02	; $21
	FCB	$00,			$02	; $22
	FCB	$00,			$02	; $23
	FCB		$80,	$00,	$02	; $24
	FCB	$00,			$02	; $25
	FCB	$00,			$02	; $26
	FCB	$00,			$02	; $27
	FCB		$EF,	$00,	$02	; $28
	FCB	$00,			$02	; $29
	FCB	$00,			$02	; $2A
	FCB	$00,			$02	; $2B
	FCB		$80,	$00,	$02	; $2C
	FCB	$00,			$02	; $2D
	FCB	$00,			$02	; $2E
	FCB	$00,			$02	; $2F
	FCB		$8F,	$0F,	$02	; $30
	FCB	$00,			$02	; $31
	FCB	$0F,			$02	; $32
	FCB	$00,			$02	; $33
	FCB		$8F,	$0C,	$02	; $34
	FCB	$00,			$02	; $35
	FCB	$0C,			$02	; $36
	FCB	$00,			$02	; $37
	FCB		$EF,	$0E,	$02	; $38
	FCB	$00,			$02	; $39
	FCB	$0E,			$02	; $3A
	FCB	$00,			$02	; $3B
	FCB		$8A,	$0A,	$02	; $3C
	FCB	$00,			$02	; $3D
	FCB	$0A,			$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern12:
	FDB	adsr
	FDB	twang

	FCB		$83,	$1F,	$02	; $00
	FCB			$13,	$02	; $01
	FCB	$03,			$02	; $02
	FCB	$00,			$02	; $03
	FCB		$83,	$1F,	$02	; $04
	FCB			$13,	$02	; $05
	FCB	$03,			$02	; $06
	FCB	$00,			$02	; $07
	FCB		$03,		$02	; $08
	FCB	$00,			$02	; $09
	FCB	$03,			$02	; $0A
	FCB	$00,			$02	; $0B
	FCB		$03,		$02	; $0C
	FCB	$00,			$02	; $0D
	FCB	$03,			$02	; $0E
	FCB	$00,			$02	; $0F
	FCB		$83,	$24,	$02	; $10
	FCB			$18,	$02	; $11
	FCB	$03,			$02	; $12
	FCB	$00,			$02	; $13
	FCB		$83,	$24,	$02	; $14
	FCB			$18,	$02	; $15
	FCB	$03,			$02	; $16
	FCB	$00,			$02	; $17
	FCB		$03,		$02	; $18
	FCB	$00,			$02	; $19
	FCB	$03,			$02	; $1A
	FCB	$00,			$02	; $1B
	FCB		$03,		$02	; $1C
	FCB	$00,			$02	; $1D
	FCB	$03,			$02	; $1E
	FCB	$00,			$02	; $1F
	FCB		$83,	$1D,	$02	; $20
	FCB			$11,	$02	; $21
	FCB	$03,			$02	; $22
	FCB	$00,			$02	; $23
	FCB		$83,	$1D,	$02	; $24
	FCB			$11,	$02	; $25
	FCB	$03,			$02	; $26
	FCB	$00,			$02	; $27
	FCB		$03,		$02	; $28
	FCB	$00,			$02	; $29
	FCB	$03,			$02	; $2A
	FCB	$00,			$02	; $2B
	FCB		$03,		$02	; $2C
	FCB	$00,			$02	; $2D
	FCB	$03,			$02	; $2E
	FCB	$00,			$02	; $2F
	FCB		$83,	$22,	$02	; $30
	FCB			$16,	$02	; $31
	FCB	$03,			$02	; $32
	FCB	$00,			$02	; $33
	FCB		$82,	$22,	$02	; $34
	FCB			$16,	$02	; $35
	FCB	$82,	$03,		$02	; $36
	FCB	$00,			$02	; $37
	FCB	$83,	$05,		$02	; $38
	FCB	$00,			$02	; $39
	FCB	$05,			$02	; $3A
	FCB	$00,			$02	; $3B
	FCB		$07,		$02	; $3C
	FCB	$00,			$02	; $3D
	FCB	$07,			$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern13:
	FDB	adsr
	FDB	twang

	FCB		$85,	$1F,	$02	; $00
	FCB			$13,	$02	; $01
	FCB	$05,			$02	; $02
	FCB	$00,			$02	; $03
	FCB		$85,	$1F,	$02	; $04
	FCB			$13,	$02	; $05
	FCB	$05,			$02	; $06
	FCB	$00,			$02	; $07
	FCB		$05,		$02	; $08
	FCB	$00,			$02	; $09
	FCB	$05,			$02	; $0A
	FCB	$00,			$02	; $0B
	FCB		$05,		$02	; $0C
	FCB	$00,			$02	; $0D
	FCB	$05,			$02	; $0E
	FCB	$00,			$02	; $0F
	FCB		$85,	$24,	$02	; $10
	FCB			$18,	$02	; $11
	FCB	$05,			$02	; $12
	FCB	$00,			$02	; $13
	FCB		$85,	$24,	$02	; $14
	FCB			$18,	$02	; $15
	FCB	$05,			$02	; $16
	FCB	$00,			$02	; $17
	FCB		$05,		$02	; $18
	FCB	$00,			$02	; $19
	FCB	$05,			$02	; $1A
	FCB	$00,			$02	; $1B
	FCB		$05,		$02	; $1C
	FCB	$00,			$02	; $1D
	FCB	$05,			$02	; $1E
	FCB	$00,			$02	; $1F
	FCB		$85,	$27,	$02	; $20
	FCB			$1B,	$02	; $21
	FCB	$05,			$02	; $22
	FCB	$00,			$02	; $23
	FCB		$85,	$27,	$02	; $24
	FCB			$1B,	$02	; $25
	FCB	$05,			$02	; $26
	FCB	$00,			$02	; $27
	FCB		$05,		$02	; $28
	FCB	$00,			$02	; $29
	FCB	$05,			$02	; $2A
	FCB	$00,			$02	; $2B
	FCB		$05,		$02	; $2C
	FCB	$00,			$02	; $2D
	FCB	$05,			$02	; $2E
	FCB	$00,			$02	; $2F
	FCB		$EF,	$2B,	$02	; $30
	FCB			$1F,	$02	; $31
	FCB	$05,			$02	; $32
	FCB	$00,			$02	; $33
	FCB		$EF,	$2B,	$02	; $34
	FCB			$1F,	$02	; $35
	FCB	$05,			$02	; $36
	FCB	$00,			$02	; $37
	FCB		$6F,		$02	; $38
	FCB	$00,			$02	; $39
	FCB	$02,			$02	; $3A
	FCB	$00,			$02	; $3B
	FCB		$6F,		$02	; $3C
	FCB	$00,			$02	; $3D
	FCB	$82,	$41,		$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern14:
	FDB	adsr
	FDB	twang

	FCB	$FF,	$8C,	$1F,	$02	; $00
	FCB			$13,	$02	; $01
	FCB		$00,		$02	; $02
	FCB	$00,			$02	; $03
	FCB	$FF,	$8C,	$1F,	$02	; $04
	FCB			$13,	$02	; $05
	FCB	$C1,	$00,		$02	; $06
	FCB	$00,			$02	; $07
	FCB	$EF,	$8C,	$24,	$02	; $08
	FCB			$18,	$02	; $09
	FCB		$00,		$02	; $0A
	FCB	$00,			$02	; $0B
	FCB	$C1,	$8C,	$24,	$02	; $0C
	FCB			$18,	$02	; $0D
	FCB	$C1,	$00,		$02	; $0E
	FCB	$00,			$02	; $0F
	FCB	$C1,	$8C,	$1D,	$02	; $10
	FCB			$11,	$02	; $11
	FCB		$00,		$02	; $12
	FCB	$00,			$02	; $13
	FCB	$FF,	$8C,	$1D,	$02	; $14
	FCB			$11,	$02	; $15
	FCB	$C1,	$00,		$02	; $16
	FCB	$00,			$02	; $17
	FCB	$EF,	$8C,	$22,	$02	; $18
	FCB			$16,	$02	; $19
	FCB		$00,		$02	; $1A
	FCB	$00,			$02	; $1B
	FCB	$C1,	$8C,	$22,	$02	; $1C
	FCB			$16,	$02	; $1D
	FCB	$C1,	$00,		$02	; $1E
	FCB	$00,			$02	; $1F
	FCB	$FF,	$8C,	$1B,	$02	; $20
	FCB			$0F,	$02	; $21
	FCB		$00,		$02	; $22
	FCB	$00,			$02	; $23
	FCB	$FF,	$8C,	$1B,	$02	; $24
	FCB			$0F,	$02	; $25
	FCB	$C1,	$00,		$02	; $26
	FCB	$00,			$02	; $27
	FCB	$EF,	$8C,	$1F,	$02	; $28
	FCB			$13,	$02	; $29
	FCB		$00,		$02	; $2A
	FCB	$00,			$02	; $2B
	FCB	$C1,	$8C,	$1F,	$02	; $2C
	FCB			$13,	$02	; $2D
	FCB	$C1,	$00,		$02	; $2E
	FCB	$00,			$02	; $2F
	FCB	$C1,	$9B,	$1D,	$02	; $30
	FCB			$11,	$02	; $31
	FCB		$0F,		$02	; $32
	FCB	$00,			$02	; $33
	FCB	$FF,	$98,	$1F,	$02	; $34
	FCB			$13,	$02	; $35
	FCB	$C1,	$0C,		$02	; $36
	FCB	$00,			$02	; $37
	FCB	$EF,	$9A,	$1D,	$02	; $38
	FCB			$11,	$02	; $39
	FCB		$0E,		$02	; $3A
	FCB	$00,			$02	; $3B
	FCB	$EF,	$96,	$22,	$02	; $3C
	FCB			$16,	$02	; $3D
	FCB	$C1,	$0A,		$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern15:
	FDB	adsr
	FDB	twang

	FCB	$FF,	$9F,	$0C,	$02	; $00
	FCB		$1B,		$02	; $01
	FCB		$98,	$18,	$02	; $02
	FCB		$13,		$02	; $03
	FCB	$C1,	$9F,	$0C,	$02	; $04
	FCB		$1B,		$02	; $05
	FCB		$98,	$18,	$02	; $06
	FCB		$13,		$02	; $07
	FCB	$C1,		$0C,	$02	; $08
	FCB	$00,			$02	; $09
	FCB			$18,	$02	; $0A
	FCB	$00,			$02	; $0B
	FCB	$FF,	$9F,	$0C,	$02	; $0C
	FCB		$1B,		$02	; $0D
	FCB		$98,	$18,	$02	; $0E
	FCB		$13,		$02	; $0F
	FCB	$EF,	$9F,	$0C,	$02	; $10
	FCB		$1B,		$02	; $11
	FCB		$98,	$18,	$02	; $12
	FCB		$13,		$02	; $13
	FCB	$C1,		$0C,	$02	; $14
	FCB	$00,			$02	; $15
	FCB			$18,	$02	; $16
	FCB	$00,			$02	; $17
	FCB	$C1,	$9F,	$0C,	$02	; $18
	FCB		$1B,		$02	; $19
	FCB		$98,	$18,	$02	; $1A
	FCB		$13,		$02	; $1B
	FCB	$FF,	$9F,	$0C,	$02	; $1C
	FCB		$1B,		$02	; $1D
	FCB		$98,	$18,	$02	; $1E
	FCB		$13,		$02	; $1F
	FCB	$FF,	$A0,	$08,	$02	; $20
	FCB		$1B,		$02	; $21
	FCB		$98,	$14,	$02	; $22
	FCB		$14,		$02	; $23
	FCB	$C1,	$A0,	$08,	$02	; $24
	FCB		$1B,		$02	; $25
	FCB		$98,	$14,	$02	; $26
	FCB		$14,		$02	; $27
	FCB	$C1,		$08,	$02	; $28
	FCB	$00,			$02	; $29
	FCB			$14,	$02	; $2A
	FCB	$00,			$02	; $2B
	FCB	$FF,	$A0,	$08,	$02	; $2C
	FCB		$1B,		$02	; $2D
	FCB		$98,	$14,	$02	; $2E
	FCB		$14,		$02	; $2F
	FCB	$EF,	$A0,	$08,	$02	; $30
	FCB		$1B,		$02	; $31
	FCB		$98,	$14,	$02	; $32
	FCB		$14,		$02	; $33
	FCB	$C1,		$08,	$02	; $34
	FCB	$00,			$02	; $35
	FCB			$14,	$02	; $36
	FCB	$00,			$02	; $37
	FCB	$C1,	$A0,	$08,	$02	; $38
	FCB		$1B,		$02	; $39
	FCB		$98,	$14,	$02	; $3A
	FCB		$14,		$02	; $3B
	FCB	$FF,	$A0,	$08,	$02	; $3C
	FCB		$1B,		$02	; $3D
	FCB		$98,	$14,	$02	; $3E
	FCB		$14,		$02	; $3F
	FCB	$00,	$80	; end-marker

pattern16:
	FDB	adsr
	FDB	twang

	FCB	$FF,	$9D,	$0A,	$02	; $00
	FCB		$1A,		$02	; $01
	FCB		$96,	$16,	$02	; $02
	FCB		$11,		$02	; $03
	FCB	$C1,	$9D,	$0A,	$02	; $04
	FCB		$1A,		$02	; $05
	FCB		$96,	$16,	$02	; $06
	FCB		$11,		$02	; $07
	FCB	$C1,		$0A,	$02	; $08
	FCB	$00,			$02	; $09
	FCB			$16,	$02	; $0A
	FCB	$00,			$02	; $0B
	FCB	$FF,	$9D,	$0A,	$02	; $0C
	FCB		$1A,		$02	; $0D
	FCB		$96,	$16,	$02	; $0E
	FCB		$11,		$02	; $0F
	FCB	$EF,	$9D,	$0A,	$02	; $10
	FCB		$1A,		$02	; $11
	FCB		$96,	$16,	$02	; $12
	FCB		$11,		$02	; $13
	FCB	$C1,		$0A,	$02	; $14
	FCB	$00,			$02	; $15
	FCB			$16,	$02	; $16
	FCB	$00,			$02	; $17
	FCB	$C1,	$9D,	$0A,	$02	; $18
	FCB		$1A,		$02	; $19
	FCB		$96,	$16,	$02	; $1A
	FCB		$11,		$02	; $1B
	FCB	$FF,	$9D,	$0A,	$02	; $1C
	FCB		$1A,		$02	; $1D
	FCB		$96,	$16,	$02	; $1E
	FCB		$11,		$02	; $1F
	FCB	$FF,	$9B,	$08,	$02	; $20
	FCB		$18,		$02	; $21
	FCB		$94,	$14,	$02	; $22
	FCB		$0F,		$02	; $23
	FCB	$C1,	$9B,	$08,	$02	; $24
	FCB		$18,		$02	; $25
	FCB		$94,	$14,	$02	; $26
	FCB		$0F,		$02	; $27
	FCB	$C1,		$08,	$02	; $28
	FCB	$00,			$02	; $29
	FCB			$14,	$02	; $2A
	FCB	$00,			$02	; $2B
	FCB	$FF,	$9B,	$08,	$02	; $2C
	FCB		$18,		$02	; $2D
	FCB		$94,	$14,	$02	; $2E
	FCB		$0F,		$02	; $2F
	FCB	$EF,	$9B,	$08,	$02	; $30
	FCB		$18,		$02	; $31
	FCB		$94,	$14,	$02	; $32
	FCB		$0F,		$02	; $33
	FCB	$C1,		$08,	$02	; $34
	FCB	$00,			$02	; $35
	FCB			$14,	$02	; $36
	FCB	$00,			$02	; $37
	FCB	$C1,	$9D,	$0A,	$02	; $38
	FCB		$1A,		$02	; $39
	FCB		$96,	$16,	$02	; $3A
	FCB		$11,		$02	; $3B
	FCB	$FF,	$9D,	$0A,	$02	; $3C
	FCB		$1A,		$02	; $3D
	FCB		$96,	$16,	$02	; $3E
	FCB		$11,		$02	; $3F
	FCB	$00,	$80	; end-marker

pattern17:
	FDB	adsr
	FDB	twang

	FCB	$FF,	$A2,	$0A,	$02	; $00
	FCB		$1D,		$02	; $01
	FCB		$9A,	$16,	$02	; $02
	FCB		$16,		$02	; $03
	FCB	$C1,	$A2,	$0A,	$02	; $04
	FCB		$1D,		$02	; $05
	FCB		$9A,	$16,	$02	; $06
	FCB		$16,		$02	; $07
	FCB	$C1,		$0A,	$02	; $08
	FCB	$00,			$02	; $09
	FCB			$16,	$02	; $0A
	FCB	$00,			$02	; $0B
	FCB	$FF,	$A2,	$0A,	$02	; $0C
	FCB		$1D,		$02	; $0D
	FCB		$9A,	$16,	$02	; $0E
	FCB		$16,		$02	; $0F
	FCB	$EF,	$A2,	$0A,	$02	; $10
	FCB		$1D,		$02	; $11
	FCB		$9A,	$16,	$02	; $12
	FCB		$16,		$02	; $13
	FCB	$C1,		$0A,	$02	; $14
	FCB	$00,			$02	; $15
	FCB			$16,	$02	; $16
	FCB	$00,			$02	; $17
	FCB	$C1,	$A2,	$0A,	$02	; $18
	FCB		$1D,		$02	; $19
	FCB		$9A,	$16,	$02	; $1A
	FCB		$16,		$02	; $1B
	FCB	$FF,	$A2,	$0A,	$02	; $1C
	FCB		$1D,		$02	; $1D
	FCB		$9A,	$16,	$02	; $1E
	FCB		$16,		$02	; $1F
	FCB	$FF,	$9B,	$08,	$02	; $20
	FCB		$18,		$02	; $21
	FCB		$94,	$14,	$02	; $22
	FCB		$0F,		$02	; $23
	FCB	$C1,	$9B,	$08,	$02	; $24
	FCB		$18,		$02	; $25
	FCB		$94,	$14,	$02	; $26
	FCB		$0F,		$02	; $27
	FCB	$C1,		$08,	$02	; $28
	FCB	$00,			$02	; $29
	FCB			$14,	$02	; $2A
	FCB	$00,			$02	; $2B
	FCB	$FF,	$9B,	$08,	$02	; $2C
	FCB		$18,		$02	; $2D
	FCB		$94,	$14,	$02	; $2E
	FCB		$0F,		$02	; $2F
	FCB	$EF,	$9B,	$08,	$02	; $30
	FCB		$18,		$02	; $31
	FCB		$94,	$14,	$02	; $32
	FCB		$0F,		$02	; $33
	FCB	$C1,		$08,	$02	; $34
	FCB	$00,			$02	; $35
	FCB			$14,	$02	; $36
	FCB	$00,			$02	; $37
	FCB	$C1,	$9D,	$0A,	$02	; $38
	FCB		$1A,		$02	; $39
	FCB		$96,	$16,	$02	; $3A
	FCB		$11,		$02	; $3B
	FCB	$FF,	$9D,	$0A,	$02	; $3C
	FCB		$1A,		$02	; $3D
	FCB		$96,	$16,	$02	; $3E
	FCB		$11,		$02	; $3F
	FCB	$00,	$80	; end-marker

pattern18:
	FDB	adsr
	FDB	twang

	FCB	$FF,	$8C,	$1F,	$02	; $00
	FCB			$13,	$02	; $01
	FCB		$00,		$02	; $02
	FCB	$00,			$02	; $03
	FCB	$C1,	$8C,	$1F,	$02	; $04
	FCB			$13,	$02	; $05
	FCB		$00,		$02	; $06
	FCB	$00,			$02	; $07
	FCB	$C1,	$8C,	$24,	$02	; $08
	FCB			$18,	$02	; $09
	FCB		$00,		$02	; $0A
	FCB	$00,			$02	; $0B
	FCB	$FF,	$8C,	$24,	$02	; $0C
	FCB			$18,	$02	; $0D
	FCB		$00,		$02	; $0E
	FCB	$00,			$02	; $0F
	FCB	$EF,	$8C,	$1D,	$02	; $10
	FCB			$11,	$02	; $11
	FCB		$00,		$02	; $12
	FCB	$00,			$02	; $13
	FCB	$C1,	$8C,	$1D,	$02	; $14
	FCB			$11,	$02	; $15
	FCB		$00,		$02	; $16
	FCB	$00,			$02	; $17
	FCB	$C1,	$8C,	$22,	$02	; $18
	FCB			$16,	$02	; $19
	FCB		$00,		$02	; $1A
	FCB	$00,			$02	; $1B
	FCB	$FF,	$8C,	$22,	$02	; $1C
	FCB			$16,	$02	; $1D
	FCB		$00,		$02	; $1E
	FCB	$00,			$02	; $1F
	FCB	$FF,	$8C,	$1B,	$02	; $20
	FCB			$0F,	$02	; $21
	FCB		$00,		$02	; $22
	FCB	$00,			$02	; $23
	FCB	$C1,	$8C,	$1B,	$02	; $24
	FCB			$0F,	$02	; $25
	FCB		$00,		$02	; $26
	FCB	$00,			$02	; $27
	FCB	$C1,	$0C,		$02	; $28
	FCB	$00,			$02	; $29
	FCB		$00,		$02	; $2A
	FCB	$00,			$02	; $2B
	FCB	$FF,	$8C,	$1B,	$02	; $2C
	FCB			$0F,	$02	; $2D
	FCB		$00,		$02	; $2E
	FCB	$00,			$02	; $2F
	FCB	$EF,		$1A,	$02	; $30
	FCB			$0E,	$02	; $31
	FCB	$00,			$02	; $32
	FCB	$00,			$02	; $33
	FCB	$C1,		$1A,	$02	; $34
	FCB			$0E,	$02	; $35
	FCB	$00,			$02	; $36
	FCB	$00,			$02	; $37
	FCB	$41,			$02	; $38
	FCB	$00,			$02	; $39
	FCB	$00,			$02	; $3A
	FCB	$00,			$02	; $3B
	FCB	$FF,		$1A,	$02	; $3C
	FCB			$0E,	$02	; $3D
	FCB	$00,			$02	; $3E
	FCB	$00,			$02	; $3F
	FCB	$00,	$80	; end-marker

pattern19:
	FDB	adsr
	FDB	twang

	FCB	$FF,	$9F,	$0C,	$02	; $00
	FCB		$1B,		$02	; $01
	FCB		$98,	$18,	$02	; $02
	FCB		$13,		$02	; $03
	FCB	$FF,	$9F,	$0C,	$02	; $04
	FCB		$1B,		$02	; $05
	FCB	$C1,	$98,	$18,	$02	; $06
	FCB		$13,		$02	; $07
	FCB	$EF,		$0C,	$02	; $08
	FCB	$00,			$02	; $09
	FCB			$18,	$02	; $0A
	FCB	$00,			$02	; $0B
	FCB	$C1,	$9F,	$0C,	$02	; $0C
	FCB		$1B,		$02	; $0D
	FCB	$C1,	$98,	$18,	$02	; $0E
	FCB		$13,		$02	; $0F
	FCB	$C1,	$9F,	$0C,	$02	; $10
	FCB		$1B,		$02	; $11
	FCB		$98,	$18,	$02	; $12
	FCB		$13,		$02	; $13
	FCB	$FF,		$0C,	$02	; $14
	FCB	$00,			$02	; $15
	FCB	$C1,		$18,	$02	; $16
	FCB	$00,			$02	; $17
	FCB	$EF,	$9F,	$0C,	$02	; $18
	FCB		$1B,		$02	; $19
	FCB		$98,	$18,	$02	; $1A
	FCB		$13,		$02	; $1B
	FCB	$C1,	$9F,	$0C,	$02	; $1C
	FCB		$1B,		$02	; $1D
	FCB	$C1,	$98,	$18,	$02	; $1E
	FCB		$13,		$02	; $1F
	FCB	$FF,	$A0,	$08,	$02	; $20
	FCB		$1B,		$02	; $21
	FCB		$98,	$14,	$02	; $22
	FCB		$14,		$02	; $23
	FCB	$FF,	$A0,	$08,	$02	; $24
	FCB		$1B,		$02	; $25
	FCB	$C1,	$98,	$14,	$02	; $26
	FCB		$14,		$02	; $27
	FCB	$EF,		$08,	$02	; $28
	FCB	$00,			$02	; $29
	FCB			$14,	$02	; $2A
	FCB	$00,			$02	; $2B
	FCB	$C1,	$A0,	$08,	$02	; $2C
	FCB		$1B,		$02	; $2D
	FCB	$C1,	$98,	$14,	$02	; $2E
	FCB		$14,		$02	; $2F
	FCB	$C1,	$A0,	$08,	$02	; $30
	FCB		$1B,		$02	; $31
	FCB		$98,	$14,	$02	; $32
	FCB		$14,		$02	; $33
	FCB	$FF,		$08,	$02	; $34
	FCB	$00,			$02	; $35
	FCB	$C1,		$14,	$02	; $36
	FCB	$00,			$02	; $37
	FCB	$EF,	$A0,	$08,	$02	; $38
	FCB		$1B,		$02	; $39
	FCB		$98,	$14,	$02	; $3A
	FCB		$14,		$02	; $3B
	FCB	$C1,	$A0,	$08,	$02	; $3C
	FCB		$1B,		$02	; $3D
	FCB	$EF,	$98,	$14,	$02	; $3E
	FCB		$14,		$02	; $3F
	FCB	$00,	$80	; end-marker

pattern1A:
	FDB	adsr
	FDB	twang

	FCB	$FF,	$9D,	$0A,	$02	; $00
	FCB		$1A,		$02	; $01
	FCB		$96,	$16,	$02	; $02
	FCB		$11,		$02	; $03
	FCB	$FF,	$9D,	$0A,	$02	; $04
	FCB		$1A,		$02	; $05
	FCB	$C1,	$96,	$16,	$02	; $06
	FCB		$11,		$02	; $07
	FCB	$EF,		$0A,	$02	; $08
	FCB	$00,			$02	; $09
	FCB			$16,	$02	; $0A
	FCB	$00,			$02	; $0B
	FCB	$C1,	$9D,	$0A,	$02	; $0C
	FCB		$1A,		$02	; $0D
	FCB	$C1,	$96,	$16,	$02	; $0E
	FCB		$11,		$02	; $0F
	FCB	$C1,	$9D,	$0A,	$02	; $10
	FCB		$1A,		$02	; $11
	FCB		$96,	$16,	$02	; $12
	FCB		$11,		$02	; $13
	FCB	$FF,		$0A,	$02	; $14
	FCB	$00,			$02	; $15
	FCB	$C1,		$16,	$02	; $16
	FCB	$00,			$02	; $17
	FCB	$EF,	$9D,	$0A,	$02	; $18
	FCB		$1A,		$02	; $19
	FCB		$96,	$16,	$02	; $1A
	FCB		$11,		$02	; $1B
	FCB	$C1,	$9D,	$0A,	$02	; $1C
	FCB		$1A,		$02	; $1D
	FCB	$C1,	$96,	$16,	$02	; $1E
	FCB		$11,		$02	; $1F
	FCB	$FF,	$9B,	$08,	$02	; $20
	FCB		$18,		$02	; $21
	FCB		$94,	$14,	$02	; $22
	FCB		$0F,		$02	; $23
	FCB	$FF,	$9B,	$08,	$02	; $24
	FCB		$18,		$02	; $25
	FCB	$C1,	$94,	$14,	$02	; $26
	FCB		$0F,		$02	; $27
	FCB	$EF,		$08,	$02	; $28
	FCB	$00,			$02	; $29
	FCB			$14,	$02	; $2A
	FCB	$00,			$02	; $2B
	FCB	$C1,	$9B,	$08,	$02	; $2C
	FCB		$18,		$02	; $2D
	FCB	$C1,	$94,	$14,	$02	; $2E
	FCB		$0F,		$02	; $2F
	FCB	$C1,	$9B,	$08,	$02	; $30
	FCB		$18,		$02	; $31
	FCB		$94,	$14,	$02	; $32
	FCB		$0F,		$02	; $33
	FCB	$FF,		$08,	$02	; $34
	FCB	$00,			$02	; $35
	FCB	$C1,		$14,	$02	; $36
	FCB	$00,			$02	; $37
	FCB	$EF,	$9D,	$0A,	$02	; $38
	FCB		$1A,		$02	; $39
	FCB		$96,	$16,	$02	; $3A
	FCB		$11,		$02	; $3B
	FCB	$C1,	$9D,	$0A,	$02	; $3C
	FCB		$1A,		$02	; $3D
	FCB	$EF,	$96,	$16,	$02	; $3E
	FCB		$11,		$02	; $3F
	FCB	$00,	$80	; end-marker

pattern1B:
	FDB	adsr
	FDB	twang

	FCB	$FF,	$A2,	$0A,	$02	; $00
	FCB		$1D,		$02	; $01
	FCB		$9A,	$16,	$02	; $02
	FCB		$16,		$02	; $03
	FCB	$FF,	$A2,	$0A,	$02	; $04
	FCB		$1D,		$02	; $05
	FCB	$C1,	$9A,	$16,	$02	; $06
	FCB		$16,		$02	; $07
	FCB	$EF,		$0A,	$02	; $08
	FCB	$00,			$02	; $09
	FCB			$16,	$02	; $0A
	FCB	$00,			$02	; $0B
	FCB	$C1,	$A2,	$0A,	$02	; $0C
	FCB		$1D,		$02	; $0D
	FCB	$C1,	$9A,	$16,	$02	; $0E
	FCB		$16,		$02	; $0F
	FCB	$C1,	$A2,	$0A,	$02	; $10
	FCB		$1D,		$02	; $11
	FCB		$9A,	$16,	$02	; $12
	FCB		$16,		$02	; $13
	FCB	$FF,		$0A,	$02	; $14
	FCB	$00,			$02	; $15
	FCB	$C1,		$16,	$02	; $16
	FCB	$00,			$02	; $17
	FCB	$EF,	$A2,	$0A,	$02	; $18
	FCB		$1D,		$02	; $19
	FCB		$9A,	$16,	$02	; $1A
	FCB		$16,		$02	; $1B
	FCB	$C1,	$A2,	$0A,	$02	; $1C
	FCB		$1D,		$02	; $1D
	FCB	$C1,	$9A,	$16,	$02	; $1E
	FCB		$16,		$02	; $1F
	FCB	$FF,	$A3,	$13,	$02	; $20
	FCB		$1F,		$02	; $21
	FCB		$9D,	$07,	$02	; $22
	FCB		$1A,		$02	; $23
	FCB	$FF,	$A3,	$13,	$02	; $24
	FCB		$1F,		$02	; $25
	FCB	$C1,	$9D,	$07,	$02	; $26
	FCB		$1A,		$02	; $27
	FCB	$EF,		$13,	$02	; $28
	FCB	$00,			$02	; $29
	FCB			$07,	$02	; $2A
	FCB	$00,			$02	; $2B
	FCB	$C1,	$A3,	$13,	$02	; $2C
	FCB		$1F,		$02	; $2D
	FCB	$C1,	$9D,	$07,	$02	; $2E
	FCB		$1A,		$02	; $2F
	FCB	$C1,	$A3,	$13,	$02	; $30
	FCB		$1F,		$02	; $31
	FCB		$9D,	$07,	$02	; $32
	FCB		$1A,		$02	; $33
	FCB	$FF,		$13,	$02	; $34
	FCB	$00,			$02	; $35
	FCB	$C1,		$07,	$02	; $36
	FCB	$00,			$02	; $37
	FCB	$EF,	$9F,	$13,	$02	; $38
	FCB		$1A,		$02	; $39
	FCB		$97,	$07,	$02	; $3A
	FCB		$13,		$02	; $3B
	FCB	$C1,	$9F,	$13,	$02	; $3C
	FCB		$1A,		$02	; $3D
	FCB	$EF,	$97,	$07,	$02	; $3E
	FCB		$13,		$02	; $3F
	FCB	$00,	$80	; end-marker

pattern1C:
	FDB	adsr
	FDB	twang

	FCB	$FF,	$96,	$1F,	$02	; $00
	FCB			$0A,	$02	; $01
	FCB		$8A,	$0E,	$02	; $02
	FCB			$11,	$02	; $03
	FCB	$FF,	$96,	$1F,	$02	; $04
	FCB			$0A,	$02	; $05
	FCB		$8A,	$0E,	$02	; $06
	FCB			$11,	$02	; $07
	FCB	$EF,	$96,	$24,	$02	; $08
	FCB			$0A,	$02	; $09
	FCB		$8A,	$0E,	$02	; $0A
	FCB			$11,	$02	; $0B
	FCB	$C1,	$96,	$24,	$02	; $0C
	FCB			$0A,	$02	; $0D
	FCB		$8A,	$0E,	$02	; $0E
	FCB			$11,	$02	; $0F
	FCB	$C1,	$96,	$1D,	$02	; $10
	FCB	$00,			$02	; $11
	FCB		$0A,		$02	; $12
	FCB	$00,			$02	; $13
	FCB	$FF,	$96,	$1D,	$02	; $14
	FCB			$0A,	$02	; $15
	FCB		$8A,	$0E,	$02	; $16
	FCB			$11,	$02	; $17
	FCB	$EF,	$96,	$22,	$02	; $18
	FCB			$0A,	$02	; $19
	FCB		$8A,	$0E,	$02	; $1A
	FCB			$11,	$02	; $1B
	FCB	$C1,	$96,	$22,	$02	; $1C
	FCB	$00,			$02	; $1D
	FCB	$C1,	$0A,		$02	; $1E
	FCB	$00,			$02	; $1F
	FCB	$FF,	$96,	$1B,	$02	; $20
	FCB			$0A,	$02	; $21
	FCB		$8A,	$0E,	$02	; $22
	FCB			$11,	$02	; $23
	FCB	$FF,	$96,	$1B,	$02	; $24
	FCB	$00,			$02	; $25
	FCB		$0A,		$02	; $26
	FCB	$00,			$02	; $27
	FCB	$EF,	$96,	$1F,	$02	; $28
	FCB			$0A,	$02	; $29
	FCB		$8A,	$0E,	$02	; $2A
	FCB			$11,	$02	; $2B
	FCB	$C1,	$96,	$1F,	$02	; $2C
	FCB	$00,			$02	; $2D
	FCB		$0A,		$02	; $2E
	FCB	$00,			$02	; $2F
	FCB	$EF,	$0A,		$02	; $30
	FCB		$09,		$02	; $31
	FCB		$08,		$02	; $32
	FCB		$07,		$02	; $33
	FCB		$06,		$02	; $34
	FCB	$EF,	$0A,		$02	; $35
	FCB		$0A,		$02	; $36
	FCB		$09,		$02	; $37
	FCB		$08,		$02	; $38
	FCB		$07,		$02	; $39
	FCB		$06,		$02	; $3A
	FCB	$EF,	$0A,		$02	; $3B
	FCB		$09,		$02	; $3C
	FCB		$08,		$02	; $3D
	FCB		$07,		$02	; $3E
	FCB		$06,		$02	; $3F
	FCB	$00,	$80	; end-marker

