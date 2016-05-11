;--- music data [created with Mod2Vectrex v1.05 - 16.03.2009 by Nitro/NCE + Wolfram Heyer (the@BigBadWolF.de)] ---

songLength	EQU	$2C
loopPosition	EQU	$65

;;;;;;;;;;   Pattern  ; Part
script:
	FDB	pattern70, part1, init_part1
	FDB	pattern61, part1, init_part1
	FDB	pattern72, part1, init_part1
	FDB	pattern74, part1, init_part1
	FDB	pattern31, part1, init_part1
	FDB	pattern2C, part1, init_part1
	FDB	pattern20, part1, init_part1
	FDB	pattern69, part1, init_part1
	FDB	pattern6E, part1, init_part1
	FDB	pattern69, part1, init_part1
	FDB	pattern74, part1, init_part1
	FDB	pattern5F, part1, init_part1
	FDB	pattern70, part1, init_part1
	FDB	pattern61, part1, init_part1
	FDB	pattern72, part1, init_part1
	FDB	pattern74, part1, init_part1
	FDB	pattern31, part1, init_part1
	FDB	pattern0D, part1, init_part1
	FDB	pattern0A, part1, init_part1
	FDB	pattern09, part1, init_part1
	FDB	pattern46, part1, init_part1
	FDB	pattern44, part1, init_part1
	FDB	pattern42, part1, init_part1
	FDB	pattern09, part1, init_part1
	FDB	pattern70, part1, init_part1
	FDB	pattern61, part1, init_part1
	FDB	pattern74, part1, init_part1
	FDB	pattern74, part1, init_part1
	FDB	pattern65, part1, init_part1
	FDB	pattern72, part1, init_part1
	FDB	pattern6E, part1, init_part1
	FDB	pattern34, part1, init_part1
	FDB	pattern32, part1, init_part1
	FDB	pattern2C, part1, init_part1
	FDB	pattern20, part1, init_part1
	FDB	pattern70, part1, init_part1
	FDB	pattern61, part1, init_part1
	FDB	pattern72, part1, init_part1
	FDB	pattern74, part1, init_part1
	FDB	pattern31, part1, init_part1
	FDB	pattern2C, part1, init_part1
	FDB	pattern20, part1, init_part1
	FDB	pattern69, part1, init_part1
	FDB	pattern6E, part1, init_part1

pattern09:
	FDB	adsr
	FDB	twang

	FCB	$00,			$09	; $00
	FCB	$00,			$06	; $01
	FCB	$00,			$00	; $02
	FCB	$00,			$09	; $03
	FCB	$00,			$02	; $04
	FCB	$00,			$02	; $05
	FCB	$00,			$04	; $06
	FCB	$00,			$04	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$09	; $09
	FCB	$00,			$02	; $0A
	FCB	$00,			$09	; $0B
	FCB	$00,			$0B	; $0C
	FCB	$00,			$09	; $0D
	FCB	$00,			$03	; $0E
	FCB	$00,			$09	; $0F
	FCB	$00,			$09	; $10
	FCB	$00,			$09	; $11
	FCB	$00,			$00	; $12
	FCB	$00,			$00	; $13
	FCB	$00,			$00	; $14
	FCB	$00,			$0A	; $15
	FCB	$00,			$09	; $16
	FCB	$00,			$09	; $17
	FCB	$00,			$06	; $18
	FCB	$00,			$00	; $19
	FCB	$00,			$09	; $1A
	FCB	$00,			$02	; $1B
	FCB	$00,			$03	; $1C
	FCB	$00,			$04	; $1D
	FCB	$00,			$04	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$09	; $20
	FCB	$00,			$02	; $21
	FCB	$00,			$09	; $22
	FCB	$00,			$0B	; $23
	FCB	$00,			$09	; $24
	FCB	$00,			$03	; $25
	FCB	$00,			$09	; $26
	FCB	$00,			$09	; $27
	FCB	$00,			$09	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0E	; $2A
	FCB	$00,			$0A	; $2B
	FCB	$00,			$06	; $2C
	FCB	$00,			$00	; $2D
	FCB	$00,			$09	; $2E
	FCB	$00,			$02	; $2F
	FCB	$00,			$00	; $30
	FCB	$00,			$04	; $31
	FCB	$00,			$04	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$09	; $34
	FCB	$30,			$02	; $35
	FCB	$00,			$09	; $36
	FCB	$00,			$0B	; $37
	FCB	$00,			$09	; $38
	FCB	$00,			$03	; $39
	FCB	$00,			$09	; $3A
	FCB	$00,			$09	; $3B
	FCB		$14,		$09	; $3C
	FCB	$00,			$0B	; $3D
	FCB	$00,			$00	; $3E
	FCB	$00,			$00	; $3F
	FCB	$00,	$80	; end-marker

pattern0A:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0A	; $00
	FCB	$00,			$09	; $01
	FCB	$00,			$09	; $02
	FCB	$00,			$06	; $03
	FCB	$00,			$00	; $04
	FCB	$00,			$09	; $05
	FCB	$00,			$02	; $06
	FCB	$00,			$01	; $07
	FCB	$00,			$04	; $08
	FCB	$00,			$04	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$09	; $0B
	FCB	$00,			$02	; $0C
	FCB	$00,			$09	; $0D
	FCB	$00,			$0B	; $0E
	FCB	$00,			$09	; $0F
	FCB	$00,			$03	; $10
	FCB	$00,			$09	; $11
	FCB	$00,			$09	; $12
	FCB		$14,		$09	; $13
	FCB	$00,			$02	; $14
	FCB	$00,			$00	; $15
	FCB	$00,			$00	; $16
	FCB	$00,			$0A	; $17
	FCB	$00,			$09	; $18
	FCB	$00,			$09	; $19
	FCB	$00,			$06	; $1A
	FCB	$00,			$00	; $1B
	FCB	$00,			$09	; $1C
	FCB	$00,			$02	; $1D
	FCB	$00,			$02	; $1E
	FCB	$00,			$04	; $1F
	FCB	$00,			$04	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$09	; $22
	FCB	$00,			$02	; $23
	FCB	$00,			$09	; $24
	FCB	$00,			$0B	; $25
	FCB	$00,			$09	; $26
	FCB	$00,			$03	; $27
	FCB	$00,			$09	; $28
	FCB	$00,			$09	; $29
	FCB		$14,		$09	; $2A
	FCB	$00,			$02	; $2B
	FCB	$00,			$00	; $2C
	FCB	$00,			$00	; $2D
	FCB	$00,			$0A	; $2E
	FCB	$00,			$09	; $2F
	FCB	$00,			$09	; $30
	FCB	$00,			$06	; $31
	FCB	$00,			$00	; $32
	FCB	$00,			$09	; $33
	FCB	$00,			$02	; $34
	FCB	$00,			$03	; $35
	FCB	$00,			$04	; $36
	FCB	$00,			$04	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$09	; $39
	FCB	$00,			$02	; $3A
	FCB	$00,			$09	; $3B
	FCB	$00,			$0B	; $3C
	FCB	$00,			$09	; $3D
	FCB	$00,			$03	; $3E
	FCB	$00,			$09	; $3F
	FCB	$00,	$80	; end-marker

pattern0D:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0B	; $00
	FCB	$00,			$09	; $01
	FCB	$00,			$03	; $02
	FCB	$00,			$09	; $03
	FCB	$00,			$09	; $04
	FCB	$00,			$09	; $05
	FCB	$00,			$01	; $06
	FCB	$00,			$00	; $07
	FCB	$00,			$00	; $08
	FCB	$00,			$0A	; $09
	FCB	$00,			$09	; $0A
	FCB	$00,			$09	; $0B
	FCB	$00,			$06	; $0C
	FCB	$00,			$00	; $0D
	FCB	$00,			$09	; $0E
	FCB	$00,			$02	; $0F
	FCB	$00,			$01	; $10
	FCB	$00,			$04	; $11
	FCB	$00,			$04	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$09	; $14
	FCB	$00,			$02	; $15
	FCB	$00,			$09	; $16
	FCB	$00,			$0B	; $17
	FCB	$00,			$09	; $18
	FCB	$00,			$03	; $19
	FCB	$00,			$09	; $1A
	FCB	$00,			$09	; $1B
	FCB	$00,			$09	; $1C
	FCB	$00,			$01	; $1D
	FCB	$00,			$00	; $1E
	FCB	$00,			$00	; $1F
	FCB	$00,			$0A	; $20
	FCB	$00,			$09	; $21
	FCB	$00,			$09	; $22
	FCB	$00,			$06	; $23
	FCB	$00,			$00	; $24
	FCB	$00,			$09	; $25
	FCB	$00,			$02	; $26
	FCB	$00,			$02	; $27
	FCB	$00,			$04	; $28
	FCB	$00,			$04	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$09	; $2B
	FCB	$00,			$02	; $2C
	FCB	$00,			$09	; $2D
	FCB	$00,			$0B	; $2E
	FCB	$00,			$09	; $2F
	FCB	$00,			$03	; $30
	FCB	$00,			$09	; $31
	FCB	$00,			$09	; $32
	FCB	$00,			$09	; $33
	FCB	$00,			$01	; $34
	FCB	$00,			$00	; $35
	FCB	$00,			$00	; $36
	FCB	$00,			$0A	; $37
	FCB	$00,			$09	; $38
	FCB	$00,			$09	; $39
	FCB	$00,			$06	; $3A
	FCB	$00,			$00	; $3B
	FCB	$00,			$09	; $3C
	FCB	$00,			$02	; $3D
	FCB	$00,			$03	; $3E
	FCB	$00,			$04	; $3F
	FCB	$00,	$80	; end-marker

pattern20:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern2C:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern31:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern32:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern34:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern42:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern44:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern46:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern5F:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern61:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern65:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern69:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern6E:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern70:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern72:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

pattern74:
	FDB	adsr
	FDB	twang

	FCB	$00,			$0D	; $00
	FCB	$00,			$0D	; $01
	FCB	$00,			$0D	; $02
	FCB	$00,			$0D	; $03
	FCB	$00,			$0D	; $04
	FCB	$00,			$0D	; $05
	FCB	$00,			$0D	; $06
	FCB	$00,			$0D	; $07
	FCB	$00,			$0D	; $08
	FCB	$00,			$0D	; $09
	FCB	$00,			$0D	; $0A
	FCB	$00,			$0D	; $0B
	FCB	$00,			$0D	; $0C
	FCB	$00,			$0D	; $0D
	FCB	$00,			$0D	; $0E
	FCB	$00,			$0D	; $0F
	FCB	$00,			$0D	; $10
	FCB	$00,			$0D	; $11
	FCB	$00,			$0D	; $12
	FCB	$00,			$0D	; $13
	FCB	$00,			$0D	; $14
	FCB	$00,			$0D	; $15
	FCB	$00,			$0D	; $16
	FCB	$00,			$0D	; $17
	FCB	$00,			$0D	; $18
	FCB	$00,			$0D	; $19
	FCB	$00,			$0D	; $1A
	FCB	$00,			$0D	; $1B
	FCB	$00,			$0D	; $1C
	FCB	$00,			$0D	; $1D
	FCB	$00,			$0D	; $1E
	FCB	$00,			$0D	; $1F
	FCB	$00,			$0D	; $20
	FCB	$00,			$0D	; $21
	FCB	$00,			$0D	; $22
	FCB	$00,			$0D	; $23
	FCB	$00,			$0D	; $24
	FCB	$00,			$0D	; $25
	FCB	$00,			$0D	; $26
	FCB	$00,			$0D	; $27
	FCB	$00,			$0D	; $28
	FCB	$00,			$0D	; $29
	FCB	$00,			$0D	; $2A
	FCB	$00,			$0D	; $2B
	FCB	$00,			$0D	; $2C
	FCB	$00,			$0D	; $2D
	FCB	$00,			$0D	; $2E
	FCB	$00,			$0D	; $2F
	FCB	$00,			$0D	; $30
	FCB	$00,			$0D	; $31
	FCB	$00,			$0D	; $32
	FCB	$00,			$0D	; $33
	FCB	$00,			$0D	; $34
	FCB	$00,			$0D	; $35
	FCB	$00,			$0D	; $36
	FCB	$00,			$0D	; $37
	FCB	$00,			$0D	; $38
	FCB	$00,			$0D	; $39
	FCB	$00,			$0D	; $3A
	FCB	$00,			$0D	; $3B
	FCB	$00,			$0D	; $3C
	FCB	$00,			$0D	; $3D
	FCB	$00,			$0D	; $3E
	FCB	$00,			$0D	; $3F
	FCB	$00,	$80	; end-marker

