;  T61860.ASM - Test file for AS61860 assembler
;
;  19-Apr-03 by Edgar Puehringer
;
;  Assemble:
;	as61860	-glaxff	t61860
;
	.AREA t61860 (ABS)
        .ORG  0x8030

; CPU registers

REG_I	=    0x00               ; index register
REG_J	=    0x01               ; index register
REG_A	=    0x02               ; accumulator
REG_B	=    0x03               ; accumulator
REG_XL	=    0x04               ; LSB of adress pointer
REG_XH	=    0x05               ; MSB of adress pointer
REG_YL	=    0x06               ; LSB of adress pointer
REG_YH	=    0x07               ; MSB of adress pointer
REG_K	=    0x08               ; counter
REG_L	=    0x09               ; counter
REG_M	=    0x0A               ; counter
REG_N	=    0x0B               ; counter

; table jump sample
	
LLLL:	PTC 	0x05, 	MMMM	; 7A 05s80rFB
	DTC			; 69
	.CASE	0x4C,	LLL1	; 4Cs80r48
	.CASE	0x4D,	LLL2	; 4Ds80r4C
	.CASE	0x51,	LLL3	; 51s80r4E
	.CASE	0x53,	LLL4	; 53s80r51
	.CASE	0x56,	LLL5	; 56s80r55
	.DEFAULT	LLL0	;s80r46
	 
LLL0:	ADB			; 14
	ADCM			; C4
LLL1:	ADIA	0x03		; 74 03
	ADIM	0x04		; 70 04
LLL2:	ADM			; 44
	ADN			; 0C
LLL3:	ADW			; 0E
	ANIA	0x04		; 64 04
LLL4:	ANID	0x04		; D4 04
	ANIM	0x05		; 60 05
LLL5:	ANMA			; 46
	CAL	0X00FE		; E0 FE
	CALL    LLLL		; 78s80r30
	CPIA	0x06		; 67 06
	CPIM	0x07		; 63 07
	CPMA			; C7
	DATA			; 35
	DECA			; 43
	DECB			; C3
	DECI			; 41
	DECJ			; C1
	DECK			; 49
	DECL			; C9
	DECM			; 4B
	DECN			; CB
	DECP			; 51
	DX			; 05
	
	DXL			; 25
	DY			; 07
	DYS			; 27
	EXAB			; DA
	EXAM			; DB
	EXB			; 0B
	EXBD			; 1B
	EXW			; 09
	EXWD			; 19
	FILD			; 1F
	FILM			; 1E
	INA			; 4C
	INB			; CC
	INCA			; 42
	INCB			; C2
	INCI			; 40
	INCJ			; C0
	INCK			; 48
	INCL			; C8
	INCM			; 4A
	INCN			; CA
	INCP			; 50
	IY			; 06
	IYS			; 26
	IX			; 04
	IXL			; 24
	JP 	LLLL		; 79s80r30
	JPC	LLLL		; 7Fs80r30

	
	JPNC	LLLL		; 7Ds80r30
	JPNZ	LLLL		; 7Cs80r30
	JPZ	LLLL		; 7Es80r30
	JRCM	LLLL		; 3B 65
	JRCP	MMMM		; 3A 64
	JRM	LLLL		; 2D 69
	JRNCM	LLLL		; 2B 6B
	JRNCP   MMMM		; 2A 5E
	JRNZM	LLLL		; 29 6F
	JRNZP	MMMM		; 28 5A
	JRP	MMMM		; 2C 58
	JRZM	LLLL		; 39 75
	JRZP	MMMM		; 38 54
	LEAVE			; D8
	LDD			; 57
	LDM			; 59
	LDP			; 20
	LDQ			; 21
	LDR			; 22
	LIA	0x01		; 02 01
	LIB	0x02		; 03 02

	LIDL	0x03		; 11 03
	LIDP	LLLL		; 10s80r30
	LII	0x04		; 00 04
	LIJ	0x05		; 01 05
	LIP	0x06		; 12 06
	LIQ	0x07		; 13 07
	LOOP	LLLL		; 2F 90
	LP	REG_I		; 80
	MVB			; 0A
	MVBD			; 1A
	MVDM			; 53
	MVMD			; 55
	MVW			; 08
	MVWD			; 18
	NOPT			; CE
	NOPW			; 4D
	ORIA	0x08		; 65 08
	ORID	0x09		; D5 09
	ORIM	0x01		; 61 01
	ORMA			; 47
	OUTA			; 5D
	OUTB			; DD
	OUTF			; 5F
	OUTC			; DF
	POP			; 5B
	PUSH			; 34
	RA			; 23
	RC			; D1
	READ			; 56


	READM			; 54
	RTN			; 37
	SBB			; 15
	SBCM			; C5
	SBIA	0x02		; 75 02
	SBIM	0x03		; 71 03
	SBM			; 45
	SBN			; 0D
	SBW			; 0F
	SC			; D0
	SL			; 5A
	SLW			; 1D
	SR			; D2
	SRW			; 1C
	STD			; 52
	STP			; 30
	STQ			; 31
	STR			; 32
	SWP			; 58
	TEST	0x04		; 6B 04
	TSIA	0x05		; 66 05
	TSID	0x06		; D6 06
	TSIM	0x07		; 62 07
	TSIP			; C6
	WAIT	0x09		; 4E 09
	WAITJ			; 4F

MMMM:

; .sbasic character translation

	.sbasic	'\000', '\001', '\002', '\003'	; 00 01 02 03
	.sbasic	'\004', '\005', '\006', '\007'	; 04 05 06 07
	.sbasic	'\010', '\011', '\012', '\013'	; 08 09 0A 0B
	.sbasic	'\014', '\015', '\016', '\017'	; 0C 0D 0E 0F
	.sbasic	'\020', '\021', '\022', '\023'	; 10 11 12 13
	.sbasic	'\024', '\025', '\026', '\027'	; 14 15 16 17
	.sbasic	'\030', '\031', '\032', '\033'	; 18 19 1A 1B
	.sbasic	'\034', '\035', '\036', '\037'	; 1C 1D 1E 1F
	.sbasic	/ !"#/				; 11 14 12 15
	.sbasic	/$%&'/				; 18 16 1F 27
	.sbasic	/()*+/				; 30 31 37 35
	.sbasic	@,-./@				; 1B 36 4A 38
	.sbasic	/0123/				; 40 41 42 43
	.sbasic	/4567/				; 44 45 46 47
	.sbasic	/89:/, '\073'			; 48 49 1D 1C
	.sbasic	/<=>?/				; 33 34 32 13
	.sbasic	/@ABC/				; 1E 51 52 53
	.sbasic	/DEFG/				; 54 55 56 57
	.sbasic	/HIJK/				; 58 59 5A 5B
	.sbasic	/LMNO/				; 5C 5D 5E 5F
	.sbasic	/PQRS/				; 60 61 62 63
	.sbasic	/TUVW/				; 64 65 66 67
	.sbasic	/XYZ[/				; 68 69 6A 5B
	.sbasic	/\]^_/				; 5C 5D 39 4E
	.sbasic	/`abc/				; 60 61 4C 4C
	.sbasic	/defg/				; 64 4B 66 67
	.sbasic	/hijk/				; 68 10 6A 6B
	.sbasic	/lmno/				; 6C 6D 6E 6F
	.sbasic	/pqrs/				; 19 71 72 1A
	.sbasic	/tuvw/				; 74 75 76 77
	.sbasic	/xyz{/				; 78 17 7A 7B
	.sbasic	/|}~/, '\177'			; 7C 7D 4D 7F

.if 0

Symbol Table

    .__.ABS.       =   0000 G   |   2 LLL0               8046 GR
  2 LLL1               8048 GR  |   2 LLL2               804C GR
  2 LLL3               804E GR  |   2 LLL4               8051 GR
  2 LLL5               8055 GR  |   2 LLLL               8030 GR
  2 MMMM               80FB GR  |     REG_A          =   0002 G
    REG_B          =   0003 G   |     REG_I          =   0000 G
    REG_J          =   0001 G   |     REG_K          =   0008 G
    REG_L          =   0009 G   |     REG_M          =   000A G
    REG_N          =   000B G   |     REG_XH         =   0005 G
    REG_XL         =   0004 G   |     REG_YH         =   0007 G
    REG_YL         =   0006 G


Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
   2 t61860           size 80FB   flags  808
[_DSEG]
   1 _DATA            size    0   flags C0C0	

.endif


