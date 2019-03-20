;  T80C390.ASM - Test file for AS80C390 assembler
;
;  18-Jun-93 BY JOHN HARTMAN
;  22-Jul-93 JLH fix AJMPs to all pages
;  17-Sep-93 JLH test subroutine call and return
;  22-Jul-98 ARB Direct Mode (*) Checks
;		 and complete Assembler Codes added
;
;  Assemble:
;	as8xcxxx -gloaxff t80c390
;

;
;  Alternate methods to define the processor
;
Alternate = 3

.if Alternate-1
.else
	.DS80C390
	.include	"ds8xcxxx.sfr"
.sbttl	/* DS8xCxx.SFR */

.endif

.if Alternate-2
.else
	.cpu	"DS80C390"
	.24bit
	.include	"ds8xcxxx.sfr"
.endif

.if Alternate-3
.else
	.cpu	"Unknown"	0
	.24bit
	.include	"t80c390.sfr"
.endif


;  EQUATES FOR ADDRESS MODES
	.area	DATA
	.ds 0x12
NN:	.ds 0x34-0x12
MM:	.ds 1

	.area	XDATA (REL,CON)
	.ds 0x1234
NNNN:	.ds 1
	.ds 0x0D95
MMMM:	.ds 1

	.area	CODE1 (REL,CON)
	.amode	0		; 16-Bit CALL/JMP Addressing Mode
;
bgncode1::
;
text8051.func.var::
	nop			; 00
text8051.func.varsilly.::
	nop			; 00
text8051.func.varno.no::
	nop			; 00
text8051.func.var0.0::
	nop			; 00
text8051.func.var1.1::
	nop			; 00
text8051.func..FN::
	nop			; 00
text8051.static::
ALLLL:	NOP			; 00
	AJMP	ARN		;n01*0C
	LJMP	ALLLL		; 02s00r06
ARN:	RR	A		; 03
	INC	A		; 04
	INC	NN		; 05*12
	INC	@R0		; 06
	INC	@R1		; 07
	INC	R0		; 08
	INC	R1		; 09
	INC	R2		; 0A
	INC	R3		; 0B
	INC	R4		; 0C
	INC	R5		; 0D
	INC	R6		; 0E
	INC	R7		; 0F
ACNNNN:
	JBC	NN,ALLLL	; 10*12 E9
	ACALL	ALLLL + 0x000	;n11*06
	LCALL	ALLLL		; 12s00r06
	RRC	A		; 13
	DEC	A		; 14
	DEC	NN		; 15*12
	DEC	@R0		; 16
	DEC	@R1		; 17
	DEC	R0		; 18
	DEC	R1		; 19
	DEC	R2		; 1A
	DEC	R3		; 1B
	DEC	R4		; 1C
	DEC	R5		; 1D
	DEC	R6		; 1E
	DEC	R7		; 1F
	JB	NN,ALLLL	; 20*12 D3
	AJMP	ALLLL + 0x100	;n21*06
	RET			; 22
	RL	A		; 23
	ADD	A,#NN		; 24r12
	ADD	A,NN		; 25*12
	ADD	A,@R0		; 26
	ADD	A,@R1		; 27
	ADD	A,R0		; 28
	ADD	A,R1		; 29
	ADD	A,R2		; 2A
	ADD	A,R3		; 2B
	ADD	A,R4		; 2C
	ADD	A,R5		; 2D
	ADD	A,R6		; 2E
	ADD	A,R7		; 2F
	JNB	NN,ALLLL	; 30*12 BE
	ACALL	ALLLL + 0x100	;n31*06
	RETI			; 32
	RLC	A		; 33
	ADDC	A,#NN		; 34r12
	ADDC	A,NN		; 35*12
	ADDC	A,@R0		; 36
	ADDC	A,@R1		; 37
	ADDC	A,R0		; 38
	ADDC	A,R1		; 39
	ADDC	A,R2		; 3A
	ADDC	A,R3		; 3B
	ADDC	A,R4		; 3C
	ADDC	A,R5		; 3D
	ADDC	A,R6		; 3E
	ADDC	A,R7		; 3F
	JC	ALLLL		; 40 AA
	AJMP	ALLLL + 0x200	;n41*06
	ORL	NN,A		; 42*12
	ORL	NN,#MM		; 43*12r34
	ORL	A,#NN		; 44r12
	ORL	A,NN		; 45*12
	ORL	A,@R0		; 46
	ORL	A,@R1		; 47
	ORL	A,R0		; 48
	ORL	A,R1		; 49
	ORL	A,R2		; 4A
	ORL	A,R3		; 4B
	ORL	A,R4		; 4C
	ORL	A,R5		; 4D
	ORL	A,R6		; 4E
	ORL	A,R7		; 4F
	JNC	ALLL2		; 50 12
	ACALL	ALLLL + 0x200	;n51*06
	ANL	NN,A		; 52*12
	ANL	NN,#MM		; 53*12r34
	ANL	A,#NN		; 54r12
	ANL	A,NN		; 55*12
	ANL	A,@R0		; 56
	ANL	A,@R1		; 57
	ANL	A,R0		; 58
	ANL	A,R1		; 59
	ANL	A,R2		; 5A
	ANL	A,R3		; 5B
	ANL	A,R4		; 5C
ALLL2:	ANL	A,R5		; 5D
	ANL	A,R6		; 5E
	ANL	A,R7		; 5F
	JZ	ALLL2		; 60 FB
	AJMP	ALLLL + 0x300	;n61*06
	XRL	NN,A		; 62*12
	XRL	NN,#MM		; 63*12r34
	XRL	A,#NN		; 64r12
	XRL	A,NN		; 65*12
	XRL	A,@R0		; 66
	XRL	A,@R1		; 67
	XRL	A,R0		; 68
	XRL	A,R1		; 69
	XRL	A,R2		; 6A
	XRL	A,R3		; 6B
	XRL	A,R4		; 6C
	XRL	A,R5		; 6D
	XRL	A,R6		; 6E
	XRL	A,R7		; 6F
	JNZ	ALLL2		; 70 E4
	ACALL	ALLLL + 0x300	;n71*06
	ORL	C,NN		; 72*12
	JMP	@A+DPTR		; 73
	MOV	A,#NN		; 74r12
	MOV	NN,#MM		; 75*12r34
	MOV	@R0,#NN		; 76r12
	MOV	@R1,#NN		; 77r12
	MOV	R0,#NN		; 78r12
	MOV	R1,#NN		; 79r12
	MOV	R2,#NN		; 7Ar12
	MOV	R3,#NN		; 7Br12
	MOV	R4,#NN		; 7Cr12
	MOV	R5,#NN		; 7Dr12
	MOV	R6,#NN		; 7Er12
	MOV	R7,#NN		; 7Fr12
	SJMP	ALLL2		; 80 C4
	AJMP	ALLLL + 0x400	;n81*06
	ANL	C,NN		; 82*12
	MOVC	A,@A+PC		; 83
	DIV	AB		; 84
	MOV	NN,MM		; 85*34*12
	MOV	NN,@R0		; 86*12
	MOV	NN,@R1		; 87*12
	MOV	NN,R0		; 88*12
	MOV	NN,R1		; 89*12
	MOV	NN,R2		; 8A*12
	MOV	NN,R3		; 8B*12
	MOV	NN,R4		; 8C*12
	MOV	NN,R5		; 8D*12
	MOV	NN,R6		; 8E*12
	MOV	NN,R7		; 8F*12
	MOV	DPTR,#NNNN	; 90s12r34
	ACALL	ALLLL + 0x400	;n91*06
	MOV	NN,C		; 92*12
	MOVC	A,@A+DPTR	; 93
	SUBB	A,#NN		; 94r12
	SUBB	A,NN		; 95*12
	SUBB	A,@R0		; 96
	SUBB	A,@R1		; 97
	SUBB	A,R0		; 98
	SUBB	A,R1		; 99
	SUBB	A,R2		; 9A
	SUBB	A,R3		; 9B
	SUBB	A,R4		; 9C
	SUBB	A,R5		; 9D
	SUBB	A,R6		; 9E
	SUBB	A,R7		; 9F
	ORL	C,/NN		; A0*12
	AJMP	ALLLL + 0x500	;nA1*06
	MOV	C,NN		; A2*12
	INC	DPTR		; A3
	MUL	AB		; A4
;	un_OP			; A5
	MOV	@R0,NN		; A6*12
	MOV	@R1,NN		; A7*12
	MOV	R0,NN		; A8*12
	MOV	R1,NN		; A9*12
	MOV	R2,NN		; AA*12
	MOV	R3,NN		; AB*12
	MOV	R4,NN		; AC*12
	MOV	R5,NN		; AD*12
	MOV	R6,NN		; AE*12
	MOV	R7,NN		; AF*12
ALLL3:	ANL	C,/NN		; B0*12
	ACALL	ALLLL + 0x500	;nB1*06
	CPL	NN		; B2*12
	CPL	C		; B3
	CJNE	A,#NN,ALLL3	; B4r12 F6
	CJNE	A,NN,ALLL3	; B5*12 F3
	CJNE	@R0,#NN,ALLL3	; B6r12 F0
	CJNE	@R1,#NN,ALLL3	; B7r12 ED
	CJNE	R0,#NN,ALLL3	; B8r12 EA
	CJNE	R1,#NN,ALLL3	; B9r12 E7
	CJNE	R2,#NN,ALLL3	; BAr12 E4
	CJNE	R3,#NN,ALLL3	; BBr12 E1
	CJNE	R4,#NN,ALLL3	; BCr12 DE
	CJNE	R5,#NN,ALLL3	; BDr12 DB
	CJNE	R6,#NN,ALLL3	; BEr12 D8
	CJNE	R7,#NN,ALLL3	; BFr12 D5
	PUSH	NN		; C0*12
	AJMP	ALLLL + 0x600	;nC1*06
	CLR	NN		; C2*12
	CLR	C		; C3
	SWAP	A		; C4
	XCH	A,NN		; C5*12
	XCH	A,@R0		; C6
	XCH	A,@R1		; C7
	XCH	A,R0		; C8
	XCH	A,R1		; C9
	XCH	A,R2		; CA
	XCH	A,R3		; CB
	XCH	A,R4		; CC
	XCH	A,R5		; CD
	XCH	A,R6		; CE
	XCH	A,R7		; CF
	POP	NN		; D0*12
	ACALL	ALLLL + 0x600	;nD1*06
	SETB	NN		; D2*12
	SETB	C		; D3
	DA	A		; D4
	DJNZ	NN,ALLL3	; D5*12 B6
	XCHD	A,@R0		; D6
	XCHD	A,@R1		; D7
	DJNZ	R0,ALLL3	; D8 B2
	DJNZ	R1,ALLL3	; D9 B0
	DJNZ	R2,ALLL3	; DA AE
	DJNZ	R3,ALLL3	; DB AC
	DJNZ	R4,ALLL3	; DC AA
	DJNZ	R5,ALLL3	; DD A8
	DJNZ	R6,ALLL3	; DE A6
	DJNZ	R7,ALLL3	; DF A4
	MOVX	A,@DPTR		; E0
	AJMP	ALLLL + 0x700	;nE1*06
	MOVX	A,@R0		; E2
	MOVX	A,@R1		; E3
	CLR	A		; E4
	MOV	A,NN		; E5*12
	MOV	A,@R0		; E6
	MOV	A,@R1		; E7
	MOV	A,R0		; E8
	MOV	A,R1		; E9
	MOV	A,R2		; EA
	MOV	A,R3		; EB
	MOV	A,R4		; EC
	MOV	A,R5		; ED
	MOV	A,R6		; EE
	MOV	A,R7		; EF
	MOVX	@DPTR,A		; F0
	ACALL	ALLLL + 0x700	;nF1*06
	MOVX	@R0,A		; F2
	MOVX	@R1,A		; F3
	CPL	A		; F4
	MOV	NN,A		; F5*12
	MOV	@R0,A		; F6
	MOV	@R1,A		; F7
	MOV	R0,A		; F8
	MOV	R1,A		; F9
	MOV	R2,A		; FA
	MOV	R3,A		; FB
	MOV	R4,A		; FC
	MOV	R5,A		; FD
	MOV	R6,A		; FE
	MOV	R7,A		; FF
;  Test SFR equates
	MOV	A,P4		; E5 80
	MOV	A,SP		; E5 81
	MOV	A,DPL 		; E5 82
	MOV	A,DPH 		; E5 83
	MOV	A,0x84		; E5 84
	MOV	A,0x85		; E5 85
	MOV	A,0x86		; E5 86
	MOV	A,0x87		; E5 87
	MOV	A,TCON		; E5 88
	MOV	A,TMOD		; E5 89
	MOV	A,TL0 		; E5 8A
	MOV	A,TL1 		; E5 8B
	MOV	A,TH0 		; E5 8C
	MOV	A,TH1		; E5 8D
	MOV	A,0x8E		; E5 8E
	MOV	A,0x8F		; E5 8F
	MOV	A,P1		; E5 90
	MOV	A,0x91		; E5 91
	MOV	A,0x92		; E5 92
	MOV	A,0x93		; E5 93
	MOV	A,0x94		; E5 94
	MOV	A,0x95		; E5 95
	MOV	A,0x96		; E5 96
	MOV	A,0x97		; E5 97
	MOV	A,SCON		; E5 98
	MOV	A,SBUF		; E5 99
	MOV	A,0x9A		; E5 9A
	MOV	A,0x9B		; E5 9B
	MOV	A,0x9C		; E5 9C
	MOV	A,0x9D		; E5 9D
	MOV	A,0x9E		; E5 9E
	MOV	A,0x9F		; E5 9F
	MOV	A,P2		; E5 A0
	MOV	A,0xA1		; E5 A1
	MOV	A,0xA2		; E5 A2
	MOV	A,0xA3		; E5 A3
	MOV	A,0xA4		; E5 A4
	MOV	A,0xA5		; E5 A5
	MOV	A,0xA6		; E5 A6
	MOV	A,0xA7		; E5 A7
	MOV	A,IE 	 	; E5 A8
	MOV	A,0xA9		; E5 A9
	MOV	A,0xAA		; E5 AA
	MOV	A,0xAB		; E5 AB
	MOV	A,0xAC		; E5 AC
	MOV	A,0xAD		; E5 AD
	MOV	A,0xAE		; E5 AE
	MOV	A,0xAF		; E5 AF
	MOV	A,P3 	 	; E5 B0
	MOV	A,0xB1		; E5 B1
	MOV	A,0xB2		; E5 B2
	MOV	A,0xB3		; E5 B3
	MOV	A,0xB4		; E5 B4
	MOV	A,0xB5		; E5 B5
	MOV	A,0xB6		; E5 B6
	MOV	A,0xB7		; E5 B7
	MOV	A,IP 	 	; E5 B8
	MOV	A,0xB9		; E5 B9
	MOV	A,0xBA		; E5 BA
	MOV	A,0xBB		; E5 BB
	MOV	A,0xBC		; E5 BC
	MOV	A,0xBD		; E5 BD
	MOV	A,0xBE		; E5 BE
	MOV	A,0xBF		; E5 BF
	MOV	A,0xC0		; E5 C0
	MOV	A,0xC1		; E5 C1
	MOV	A,0xC2		; E5 C2
	MOV	A,0xC3		; E5 C3
	MOV	A,0xC4		; E5 C4
	MOV	A,0xC5		; E5 C5
	MOV	A,0xC6		; E5 C6
	MOV	A,0xC7		; E5 C7
	MOV	A,T2CON		; E5 C8
	MOV	A,0xC9		; E5 C9
	MOV	A,RCAP2L	; E5 CA
	MOV	A,RCAP2H	; E5 CB
	MOV	A,TL2		; E5 CC
	MOV	A,TH2 	 	; E5 CD
	MOV	A,0xCE		; E5 CE
	MOV	A,0xCF		; E5 CF
	MOV	A,PSW		; E5 D0
	MOV	A,0xD1		; E5 D1
	MOV	A,0xD2		; E5 D2
	MOV	A,0xD3		; E5 D3
	MOV	A,0xD4		; E5 D4
	MOV	A,0xD5		; E5 D5
	MOV	A,0xD6		; E5 D6
	MOV	A,0xD7		; E5 D7
	MOV	A,0xD8		; E5 D8
	MOV	A,0xD9		; E5 D9
	MOV	A,0xDA		; E5 DA
	MOV	A,0xDB		; E5 DB
	MOV	A,0xDC		; E5 DC
	MOV	A,0xDD		; E5 DD
	MOV	A,0xDE		; E5 DE
	MOV	A,0xDF		; E5 DF
	MOV	A,ACC		; E5 E0
	MOV	A,0xE1		; E5 E1
	MOV	A,0xE2		; E5 E2
	MOV	A,0xE3		; E5 E3
	MOV	A,0xE4		; E5 E4
	MOV	A,0xE5		; E5 E5
	MOV	A,0xE6		; E5 E6
	MOV	A,0xE7		; E5 E7
	MOV	A,0xE8		; E5 E8
	MOV	A,0xE9		; E5 E9
	MOV	A,0xEA		; E5 EA
	MOV	A,0xEB		; E5 EB
	MOV	A,0xEC		; E5 EC
	MOV	A,0xED		; E5 ED
	MOV	A,0xEE		; E5 EE
	MOV	A,0xEF		; E5 EF
	
	MOV	A,B		; E5 F0
	MOV	A,0xF1		; E5 F1
	MOV	A,0xF2		; E5 F2
	MOV	A,0xF3		; E5 F3
	MOV	A,0xF4		; E5 F4
	MOV	A,0xF5		; E5 F5
	MOV	A,0xF6		; E5 F6
	MOV	A,0xF7		; E5 F7
	MOV	A,0xF8		; E5 F8
	MOV	A,0xF9		; E5 F9
	MOV	A,0xFA		; E5 FA
	MOV	A,0xFB		; E5 FB
	MOV	A,0xFC		; E5 FC
	MOV	A,0xFD		; E5 FD
	MOV	A,0xFE		; E5 FE
	MOV	A,0xFF		; E5 FF
;	SFR bits
	MOV	C,P4.0		; A2 80
	MOV	C,P4.1		; A2 81
	MOV	C,P4.2 		; A2 82
	MOV	C,P4.3 		; A2 83
	MOV	C,P4.4		; A2 84
	MOV	C,P4.5		; A2 85
	MOV	C,P4.6		; A2 86
	MOV	C,P4.7		; A2 87
	MOV	C,IT0		; A2 88
	MOV	C,IE0		; A2 89
	MOV	C,IT1 		; A2 8A
	MOV	C,IE1 		; A2 8B
	MOV	C,TR0 		; A2 8C
	MOV	C,TF0		; A2 8D
	MOV	C,TR1		; A2 8E
	MOV	C,TF1		; A2 8F
	MOV	C,P1.0		; A2 90
	MOV	C,P1.1		; A2 91
	MOV	C,P1.2		; A2 92
	MOV	C,P1.3		; A2 93
	MOV	C,P1.4		; A2 94
	MOV	C,P1.5		; A2 95
	MOV	C,P1.6		; A2 96
	MOV	C,P1.7		; A2 97
	MOV	C,RI		; A2 98
	MOV	C,TI		; A2 99
	MOV	C,RB8		; A2 9A
	MOV	C,TB8		; A2 9B
	MOV	C,REN		; A2 9C
	MOV	C,SM2		; A2 9D
	MOV	C,SM1		; A2 9E
	MOV	C,SM0		; A2 9F
	MOV	C,P2.0		; A2 A0
	MOV	C,P2.1		; A2 A1
	MOV	C,P2.2		; A2 A2
	MOV	C,P2.3		; A2 A3
	MOV	C,P2.4		; A2 A4
	MOV	C,P2.5		; A2 A5
	MOV	C,P2.6		; A2 A6
	MOV	C,P2.7		; A2 A7
	MOV	C,EX0		; A2 A8
	MOV	C,ET0		; A2 A9
	MOV	C,EX1		; A2 AA
	MOV	C,ET1		; A2 AB
	MOV	C,ES		; A2 AC
	MOV	C,ET2		; A2 AD
	MOV	C,0xAE		; A2 AE
	MOV	C,EA		; A2 AF
	MOV	C,P3.0		; A2 B0
	MOV	C,P3.1		; A2 B1
	MOV	C,P3.2		; A2 B2
	MOV	C,P3.3		; A2 B3
	MOV	C,P3.4		; A2 B4
	MOV	C,P3.5		; A2 B5
	MOV	C,P3.6		; A2 B6
	MOV	C,P3.7		; A2 B7
	MOV	C,PX0		; A2 B8
	MOV	C,PT0		; A2 B9
	MOV	C,PX1		; A2 BA
	MOV	C,PT1		; A2 BB
	MOV	C,PS		; A2 BC
	MOV	C,PT2		; A2 BD
	MOV	C,0xBE		; A2 BE
	MOV	C,0xBF		; A2 BF
	MOV	C,0xC0		; A2 C0
	MOV	C,0xC1		; A2 C1
	MOV	C,0xC2		; A2 C2
	MOV	C,0xC3		; A2 C3
	MOV	C,0xC4		; A2 C4
	MOV	C,0xC5		; A2 C5
	MOV	C,0xC6		; A2 C6
	MOV	C,0xC7		; A2 C7
	MOV	C,CPRL2		; A2 C8
	MOV	C,CT2		; A2 C9
	MOV	C,TR2		; A2 CA
	MOV	C,EXEN2		; A2 CB
	MOV	C,TCLK		; A2 CC
	MOV	C,RCLK		; A2 CD
	MOV	C,EXF2		; A2 CE
	MOV	C,TF2		; A2 CF
	MOV	C,P		; A2 D0
	MOV	C,0xD1		; A2 D1
	MOV	C,OV		; A2 D2
	MOV	C,RS0		; A2 D3
	MOV	C,RS1		; A2 D4
	MOV	C,F0		; A2 D5
	MOV	C,AC		; A2 D6
	MOV	C,CY		; A2 D7
	MOV	C,0xD8		; A2 D8
	MOV	C,0xD9		; A2 D9
	MOV	C,0xDA		; A2 DA
	MOV	C,0xDB		; A2 DB
	MOV	C,0xDC		; A2 DC
	MOV	C,0xDD		; A2 DD
	MOV	C,0xDE		; A2 DE
	MOV	C,0xDF		; A2 DF
	MOV	C,ACC.0		; A2 E0
	MOV	C,ACC.1		; A2 E1
	MOV	C,ACC.2		; A2 E2
	MOV	C,ACC.3		; A2 E3
	MOV	C,ACC.4		; A2 E4
	MOV	C,ACC.5		; A2 E5
	MOV	C,ACC.6		; A2 E6
	MOV	C,ACC.7		; A2 E7
	MOV	C,0xE8		; A2 E8
	MOV	C,0xE9		; A2 E9
	MOV	C,0xEA		; A2 EA
	MOV	C,0xEB		; A2 EB
	MOV	C,0xEC		; A2 EC
	MOV	C,0xED		; A2 ED
	MOV	C,0xEE		; A2 EE
	MOV	C,0xEF		; A2 EF
	
	MOV	C,B.0		; A2 F0
	MOV	C,B.1		; A2 F1
	MOV	C,B.2		; A2 F2
	MOV	C,B.3		; A2 F3
	MOV	C,B.4		; A2 F4
	MOV	C,B.5		; A2 F5
	MOV	C,B.6		; A2 F6
	MOV	C,B.7		; A2 F7
	MOV	C,0xF8		; A2 F8
	MOV	C,0xF9		; A2 F9
	MOV	C,0xFA		; A2 FA
	MOV	C,0xFB		; A2 FB
	MOV	C,0xFC		; A2 FC
	MOV	C,0xFD		; A2 FD
	MOV	C,0xFE		; A2 FE
	MOV	C,0xFF		; A2 FF
;;/* Direct Mode (*) Checks */;;
ALLL4:	INC	*NN		; 05*12
	JBC	*NN,ALLL4	; 10*12 FB
	DEC	*NN		; 15*12
	JB	*NN,ALLL4	; 20*12 F6
	ADD	A,*NN		; 25*12
	JNB	*NN,ALLL4	; 30*12 F1
	ADDC	A,*NN		; 35*12
	ORL	*NN,A		; 42*12
	ORL	*NN,#MM		; 43*12r34
	ORL	A,*NN		; 45*12
	ANL	*NN,A		; 52*12
	ANL	*NN,#MM		; 53*12r34
	ANL	A,*NN		; 55*12
	XRL	*NN,A		; 62*12
	XRL	*NN,#MM		; 63*12r34
	XRL	A,*NN		; 65*12
	ORL	C,*NN		; 72*12
	MOV	*NN,#MM		; 75*12r34
	ANL	C,*NN		; 82*12
	MOV	*NN,*MM		; 85*34*12
	MOV	*NN,@R0		; 86*12
	MOV	*NN,@R1		; 87*12
	MOV	*NN,R0		; 88*12
	MOV	*NN,R1		; 89*12
	MOV	*NN,R2		; 8A*12
	MOV	*NN,R3		; 8B*12
	MOV	*NN,R4		; 8C*12
	MOV	*NN,R5		; 8D*12
	MOV	*NN,R6		; 8E*12
	MOV	*NN,R7		; 8F*12
	MOV	*NN,C		; 92*12
	SUBB	A,*NN		; 95*12
	ORL	C,*/NN		; A0*12
	MOV	C,*NN		; A2*12
	MOV	@R0,*NN		; A6*12
	MOV	@R1,*NN		; A7*12
	MOV	R0,*NN		; A8*12
	MOV	R1,*NN		; A9*12
	MOV	R2,*NN		; AA*12
	MOV	R3,*NN		; AB*12
	MOV	R4,*NN		; AC*12
	MOV	R5,*NN		; AD*12
	MOV	R6,*NN		; AE*12
	MOV	R7,*NN		; AF*12
	ANL	C,*/NN		; B0*12
	CPL	*NN		; B2*12
	CJNE	A,*NN,ALLL4	; B5*12 99
	PUSH	*NN		; C0*12
	CLR	*NN		; C2*12
	XCH	A,*NN		; C5*12
	POP	*NN		; D0*12
	SETB	*NN		; D2*12
	DJNZ	*NN,ALLL4	; D5*12 8C
	MOV	A,*NN		; E5*12
	MOV	*NN,A		; F5*12

	.blkb	0x1000 - (. - bgncode1)

	.area	CODE2 (REL,CON)
	.amode	2		; 24-Bit CALL/JMP Addressing Mode
;
bgncode2::
;
text8051_func_var::
	nop			; 00
text8051_func_varsilly_::
	nop			; 00
text8051_func_varno_no::
	nop			; 00
text8051_func_var0_0::
	nop			; 00
text8051_func_var1_1::
	nop			; 00
text8051_func__FN::
	nop			; 00
text8051_static::
BLLLL:	NOP			; 00
	AJMP	BRN		;M01n00*0E
	LJMP	BLLLL		; 02R00s00r06
BRN:	RR	A		; 03
	INC	A		; 04
	INC	NN		; 05*12
	INC	@R0		; 06
	INC	@R1		; 07
	INC	R0		; 08
	INC	R1		; 09
	INC	R2		; 0A
	INC	R3		; 0B
	INC	R4		; 0C
	INC	R5		; 0D
	INC	R6		; 0E
	INC	R7		; 0F
BCNNNN:
	JBC	NN,BLLLL	; 10*12 E7
	ACALL	BLLLL + 0x000	;M11n00*06
	LCALL	BLLLL		; 12R00s00r06
	RRC	A		; 13
	DEC	A		; 14
	DEC	NN		; 15*12
	DEC	@R0		; 16
	DEC	@R1		; 17
	DEC	R0		; 18
	DEC	R1		; 19
	DEC	R2		; 1A
	DEC	R3		; 1B
	DEC	R4		; 1C
	DEC	R5		; 1D
	DEC	R6		; 1E
	DEC	R7		; 1F
	JB	NN,BLLLL	; 20*12 CF
	AJMP	BLLLL + 0x100	;M01n01*06
	RET			; 22
	RL	A		; 23
	ADD	A,#NN		; 24r12
	ADD	A,NN		; 25*12
	ADD	A,@R0		; 26
	ADD	A,@R1		; 27
	ADD	A,R0		; 28
	ADD	A,R1		; 29
	ADD	A,R2		; 2A
	ADD	A,R3		; 2B
	ADD	A,R4		; 2C
	ADD	A,R5		; 2D
	ADD	A,R6		; 2E
	ADD	A,R7		; 2F
	JNB	NN,BLLLL	; 30*12 B9
	ACALL	BLLLL + 0x100	;M11n01*06
	RETI			; 32
	RLC	A		; 33
	ADDC	A,#NN		; 34r12
	ADDC	A,NN		; 35*12
	ADDC	A,@R0		; 36
	ADDC	A,@R1		; 37
	ADDC	A,R0		; 38
	ADDC	A,R1		; 39
	ADDC	A,R2		; 3A
	ADDC	A,R3		; 3B
	ADDC	A,R4		; 3C
	ADDC	A,R5		; 3D
	ADDC	A,R6		; 3E
	ADDC	A,R7		; 3F
	JC	BLLLL		; 40 A4
	AJMP	BLLLL + 0x200	;M01n02*06
	ORL	NN,A		; 42*12
	ORL	NN,#MM		; 43*12r34
	ORL	A,#NN		; 44r12
	ORL	A,NN		; 45*12
	ORL	A,@R0		; 46
	ORL	A,@R1		; 47
	ORL	A,R0		; 48
	ORL	A,R1		; 49
	ORL	A,R2		; 4A
	ORL	A,R3		; 4B
	ORL	A,R4		; 4C
	ORL	A,R5		; 4D
	ORL	A,R6		; 4E
	ORL	A,R7		; 4F
	JNC	BLLL2		; 50 13
	ACALL	BLLLL + 0x200	;M11n02*06
	ANL	NN,A		; 52*12
	ANL	NN,#MM		; 53*12r34
	ANL	A,#NN		; 54r12
	ANL	A,NN		; 55*12
	ANL	A,@R0		; 56
	ANL	A,@R1		; 57
	ANL	A,R0		; 58
	ANL	A,R1		; 59
	ANL	A,R2		; 5A
	ANL	A,R3		; 5B
	ANL	A,R4		; 5C
BLLL2:	ANL	A,R5		; 5D
	ANL	A,R6		; 5E
	ANL	A,R7		; 5F
	JZ	BLLL2		; 60 FB
	AJMP	BLLLL + 0x300	;M01n03*06
	XRL	NN,A		; 62*12
	XRL	NN,#MM		; 63*12r34
	XRL	A,#NN		; 64r12
	XRL	A,NN		; 65*12
	XRL	A,@R0		; 66
	XRL	A,@R1		; 67
	XRL	A,R0		; 68
	XRL	A,R1		; 69
	XRL	A,R2		; 6A
	XRL	A,R3		; 6B
	XRL	A,R4		; 6C
	XRL	A,R5		; 6D
	XRL	A,R6		; 6E
	XRL	A,R7		; 6F
	JNZ	BLLL2		; 70 E3
	ACALL	BLLLL + 0x300	;M11n03*06
	ORL	C,NN		; 72*12
	JMP	@A+DPTR		; 73
	MOV	A,#NN		; 74r12
	MOV	NN,#MM		; 75*12r34
	MOV	@R0,#NN		; 76r12
	MOV	@R1,#NN		; 77r12
	MOV	R0,#NN		; 78r12
	MOV	R1,#NN		; 79r12
	MOV	R2,#NN		; 7Ar12
	MOV	R3,#NN		; 7Br12
	MOV	R4,#NN		; 7Cr12
	MOV	R5,#NN		; 7Dr12
	MOV	R6,#NN		; 7Er12
	MOV	R7,#NN		; 7Fr12
	SJMP	BLLL2		; 80 C2
	AJMP	BLLLL + 0x400	;M01n04*06
	ANL	C,NN		; 82*12
	MOVC	A,@A+PC		; 83
	DIV	AB		; 84
	MOV	NN,MM		; 85*34*12
	MOV	NN,@R0		; 86*12
	MOV	NN,@R1		; 87*12
	MOV	NN,R0		; 88*12
	MOV	NN,R1		; 89*12
	MOV	NN,R2		; 8A*12
	MOV	NN,R3		; 8B*12
	MOV	NN,R4		; 8C*12
	MOV	NN,R5		; 8D*12
	MOV	NN,R6		; 8E*12
	MOV	NN,R7		; 8F*12
	MOV	DPTR,#NNNN	; 90R00s12r34
	ACALL	BLLLL + 0x400	;M11n04*06
	MOV	NN,C		; 92*12
	MOVC	A,@A+DPTR	; 93
	SUBB	A,#NN		; 94r12
	SUBB	A,NN		; 95*12
	SUBB	A,@R0		; 96
	SUBB	A,@R1		; 97
	SUBB	A,R0		; 98
	SUBB	A,R1		; 99
	SUBB	A,R2		; 9A
	SUBB	A,R3		; 9B
	SUBB	A,R4		; 9C
	SUBB	A,R5		; 9D
	SUBB	A,R6		; 9E
	SUBB	A,R7		; 9F
	ORL	C,/NN		; A0*12
	AJMP	BLLLL + 0x500	;M01n05*06
	MOV	C,NN		; A2*12
	INC	DPTR		; A3
	MUL	AB		; A4
;	un_OP			; A5
	MOV	@R0,NN		; A6*12
	MOV	@R1,NN		; A7*12
	MOV	R0,NN		; A8*12
	MOV	R1,NN		; A9*12
	MOV	R2,NN		; AA*12
	MOV	R3,NN		; AB*12
	MOV	R4,NN		; AC*12
	MOV	R5,NN		; AD*12
	MOV	R6,NN		; AE*12
	MOV	R7,NN		; AF*12
BLLL3:	ANL	C,/NN		; B0*12
	ACALL	BLLLL + 0x500	;M11n05*06
	CPL	NN		; B2*12
	CPL	C		; B3
	CJNE	A,#NN,BLLL3	; B4r12 F5
	CJNE	A,NN,BLLL3	; B5*12 F2
	CJNE	@R0,#NN,BLLL3	; B6r12 EF
	CJNE	@R1,#NN,BLLL3	; B7r12 EC
	CJNE	R0,#NN,BLLL3	; B8r12 E9
	CJNE	R1,#NN,BLLL3	; B9r12 E6
	CJNE	R2,#NN,BLLL3	; BAr12 E3
	CJNE	R3,#NN,BLLL3	; BBr12 E0
	CJNE	R4,#NN,BLLL3	; BCr12 DD
	CJNE	R5,#NN,BLLL3	; BDr12 DA
	CJNE	R6,#NN,BLLL3	; BEr12 D7
	CJNE	R7,#NN,BLLL3	; BFr12 D4
	PUSH	NN		; C0*12
	AJMP	BLLLL + 0x600	;M01n06*06
	CLR	NN		; C2*12
	CLR	C		; C3
	SWAP	A		; C4
	XCH	A,NN		; C5*12
	XCH	A,@R0		; C6
	XCH	A,@R1		; C7
	XCH	A,R0		; C8
	XCH	A,R1		; C9
	XCH	A,R2		; CA
	XCH	A,R3		; CB
	XCH	A,R4		; CC
	XCH	A,R5		; CD
	XCH	A,R6		; CE
	XCH	A,R7		; CF
	POP	NN		; D0*12
	ACALL	BLLLL + 0x600	;M11n06*06
	SETB	NN		; D2*12
	SETB	C		; D3
	DA	A		; D4
	DJNZ	NN,BLLL3	; D5*12 B3
	XCHD	A,@R0		; D6
	XCHD	A,@R1		; D7
	DJNZ	R0,BLLL3	; D8 AF
	DJNZ	R1,BLLL3	; D9 AD
	DJNZ	R2,BLLL3	; DA AB
	DJNZ	R3,BLLL3	; DB A9
	DJNZ	R4,BLLL3	; DC A7
	DJNZ	R5,BLLL3	; DD A5
	DJNZ	R6,BLLL3	; DE A3
	DJNZ	R7,BLLL3	; DF A1
	MOVX	A,@DPTR		; E0
	AJMP	BLLLL + 0x700	;M01n07*06
	MOVX	A,@R0		; E2
	MOVX	A,@R1		; E3
	CLR	A		; E4
	MOV	A,NN		; E5*12
	MOV	A,@R0		; E6
	MOV	A,@R1		; E7
	MOV	A,R0		; E8
	MOV	A,R1		; E9
	MOV	A,R2		; EA
	MOV	A,R3		; EB
	MOV	A,R4		; EC
	MOV	A,R5		; ED
	MOV	A,R6		; EE
	MOV	A,R7		; EF
	MOVX	@DPTR,A		; F0
	ACALL	BLLLL + 0x700	;M11n07*06
	MOVX	@R0,A		; F2
	MOVX	@R1,A		; F3
	CPL	A		; F4
	MOV	NN,A		; F5*12
	MOV	@R0,A		; F6
	MOV	@R1,A		; F7
	MOV	R0,A		; F8
	MOV	R1,A		; F9
	MOV	R2,A		; FA
	MOV	R3,A		; FB
	MOV	R4,A		; FC
	MOV	R5,A		; FD
	MOV	R6,A		; FE
	MOV	R7,A		; FF
;  Test SFR equates
	MOV	A,P4		; E5 80
	MOV	A,SP		; E5 81
	MOV	A,DPL 		; E5 82
	MOV	A,DPH 		; E5 83
	MOV	A,0x84		; E5 84
	MOV	A,0x85		; E5 85
	MOV	A,0x86		; E5 86
	MOV	A,0x87		; E5 87
	MOV	A,TCON		; E5 88
	MOV	A,TMOD		; E5 89
	MOV	A,TL0 		; E5 8A
	MOV	A,TL1 		; E5 8B
	MOV	A,TH0 		; E5 8C
	MOV	A,TH1		; E5 8D
	MOV	A,0x8E		; E5 8E
	MOV	A,0x8F		; E5 8F
	MOV	A,P1		; E5 90
	MOV	A,0x91		; E5 91
	MOV	A,0x92		; E5 92
	MOV	A,0x93		; E5 93
	MOV	A,0x94		; E5 94
	MOV	A,0x95		; E5 95
	MOV	A,0x96		; E5 96
	MOV	A,0x97		; E5 97
	MOV	A,SCON		; E5 98
	MOV	A,SBUF		; E5 99
	MOV	A,0x9A		; E5 9A
	MOV	A,0x9B		; E5 9B
	MOV	A,0x9C		; E5 9C
	MOV	A,0x9D		; E5 9D
	MOV	A,0x9E		; E5 9E
	MOV	A,0x9F		; E5 9F
	MOV	A,P2		; E5 A0
	MOV	A,0xA1		; E5 A1
	MOV	A,0xA2		; E5 A2
	MOV	A,0xA3		; E5 A3
	MOV	A,0xA4		; E5 A4
	MOV	A,0xA5		; E5 A5
	MOV	A,0xA6		; E5 A6
	MOV	A,0xA7		; E5 A7
	MOV	A,IE 	 	; E5 A8
	MOV	A,0xA9		; E5 A9
	MOV	A,0xAA		; E5 AA
	MOV	A,0xAB		; E5 AB
	MOV	A,0xAC		; E5 AC
	MOV	A,0xAD		; E5 AD
	MOV	A,0xAE		; E5 AE
	MOV	A,0xAF		; E5 AF
	MOV	A,P3 	 	; E5 B0
	MOV	A,0xB1		; E5 B1
	MOV	A,0xB2		; E5 B2
	MOV	A,0xB3		; E5 B3
	MOV	A,0xB4		; E5 B4
	MOV	A,0xB5		; E5 B5
	MOV	A,0xB6		; E5 B6
	MOV	A,0xB7		; E5 B7
	MOV	A,IP 	 	; E5 B8
	MOV	A,0xB9		; E5 B9
	MOV	A,0xBA		; E5 BA
	MOV	A,0xBB		; E5 BB
	MOV	A,0xBC		; E5 BC
	MOV	A,0xBD		; E5 BD
	MOV	A,0xBE		; E5 BE
	MOV	A,0xBF		; E5 BF
	MOV	A,0xC0		; E5 C0
	MOV	A,0xC1		; E5 C1
	MOV	A,0xC2		; E5 C2
	MOV	A,0xC3		; E5 C3
	MOV	A,0xC4		; E5 C4
	MOV	A,0xC5		; E5 C5
	MOV	A,0xC6		; E5 C6
	MOV	A,0xC7		; E5 C7
	MOV	A,T2CON		; E5 C8
	MOV	A,0xC9		; E5 C9
	MOV	A,RCAP2L	; E5 CA
	MOV	A,RCAP2H	; E5 CB
	MOV	A,TL2		; E5 CC
	MOV	A,TH2 	 	; E5 CD
	MOV	A,0xCE		; E5 CE
	MOV	A,0xCF		; E5 CF
	MOV	A,PSW		; E5 D0
	MOV	A,0xD1		; E5 D1
	MOV	A,0xD2		; E5 D2
	MOV	A,0xD3		; E5 D3
	MOV	A,0xD4		; E5 D4
	MOV	A,0xD5		; E5 D5
	MOV	A,0xD6		; E5 D6
	MOV	A,0xD7		; E5 D7
	MOV	A,0xD8		; E5 D8
	MOV	A,0xD9		; E5 D9
	MOV	A,0xDA		; E5 DA
	MOV	A,0xDB		; E5 DB
	MOV	A,0xDC		; E5 DC
	MOV	A,0xDD		; E5 DD
	MOV	A,0xDE		; E5 DE
	MOV	A,0xDF		; E5 DF
	MOV	A,ACC		; E5 E0
	MOV	A,0xE1		; E5 E1
	MOV	A,0xE2		; E5 E2
	MOV	A,0xE3		; E5 E3
	MOV	A,0xE4		; E5 E4
	MOV	A,0xE5		; E5 E5
	MOV	A,0xE6		; E5 E6
	MOV	A,0xE7		; E5 E7
	MOV	A,0xE8		; E5 E8
	MOV	A,0xE9		; E5 E9
	MOV	A,0xEA		; E5 EA
	MOV	A,0xEB		; E5 EB
	MOV	A,0xEC		; E5 EC
	MOV	A,0xED		; E5 ED
	MOV	A,0xEE		; E5 EE
	MOV	A,0xEF		; E5 EF
	
	MOV	A,B		; E5 F0
	MOV	A,0xF1		; E5 F1
	MOV	A,0xF2		; E5 F2
	MOV	A,0xF3		; E5 F3
	MOV	A,0xF4		; E5 F4
	MOV	A,0xF5		; E5 F5
	MOV	A,0xF6		; E5 F6
	MOV	A,0xF7		; E5 F7
	MOV	A,0xF8		; E5 F8
	MOV	A,0xF9		; E5 F9
	MOV	A,0xFA		; E5 FA
	MOV	A,0xFB		; E5 FB
	MOV	A,0xFC		; E5 FC
	MOV	A,0xFD		; E5 FD
	MOV	A,0xFE		; E5 FE
	MOV	A,0xFF		; E5 FF
;	SFR bits
	MOV	C,P4.0		; A2 80
	MOV	C,P4.1		; A2 81
	MOV	C,P4.2 		; A2 82
	MOV	C,P4.3 		; A2 83
	MOV	C,P4.4		; A2 84
	MOV	C,P4.5		; A2 85
	MOV	C,P4.6		; A2 86
	MOV	C,P4.7		; A2 87
	MOV	C,IT0		; A2 88
	MOV	C,IE0		; A2 89
	MOV	C,IT1 		; A2 8A
	MOV	C,IE1 		; A2 8B
	MOV	C,TR0 		; A2 8C
	MOV	C,TF0		; A2 8D
	MOV	C,TR1		; A2 8E
	MOV	C,TF1		; A2 8F
	MOV	C,P1.0		; A2 90
	MOV	C,P1.1		; A2 91
	MOV	C,P1.2		; A2 92
	MOV	C,P1.3		; A2 93
	MOV	C,P1.4		; A2 94
	MOV	C,P1.5		; A2 95
	MOV	C,P1.6		; A2 96
	MOV	C,P1.7		; A2 97
	MOV	C,RI		; A2 98
	MOV	C,TI		; A2 99
	MOV	C,RB8		; A2 9A
	MOV	C,TB8		; A2 9B
	MOV	C,REN		; A2 9C
	MOV	C,SM2		; A2 9D
	MOV	C,SM1		; A2 9E
	MOV	C,SM0		; A2 9F
	MOV	C,P2.0		; A2 A0
	MOV	C,P2.1		; A2 A1
	MOV	C,P2.2		; A2 A2
	MOV	C,P2.3		; A2 A3
	MOV	C,P2.4		; A2 A4
	MOV	C,P2.5		; A2 A5
	MOV	C,P2.6		; A2 A6
	MOV	C,P2.7		; A2 A7
	MOV	C,EX0		; A2 A8
	MOV	C,ET0		; A2 A9
	MOV	C,EX1		; A2 AA
	MOV	C,ET1		; A2 AB
	MOV	C,ES		; A2 AC
	MOV	C,ET2		; A2 AD
	MOV	C,0xAE		; A2 AE
	MOV	C,EA		; A2 AF
	MOV	C,P3.0		; A2 B0
	MOV	C,P3.1		; A2 B1
	MOV	C,P3.2		; A2 B2
	MOV	C,P3.3		; A2 B3
	MOV	C,P3.4		; A2 B4
	MOV	C,P3.5		; A2 B5
	MOV	C,P3.6		; A2 B6
	MOV	C,P3.7		; A2 B7
	MOV	C,PX0		; A2 B8
	MOV	C,PT0		; A2 B9
	MOV	C,PX1		; A2 BA
	MOV	C,PT1		; A2 BB
	MOV	C,PS		; A2 BC
	MOV	C,PT2		; A2 BD
	MOV	C,0xBE		; A2 BE
	MOV	C,0xBF		; A2 BF
	MOV	C,0xC0		; A2 C0
	MOV	C,0xC1		; A2 C1
	MOV	C,0xC2		; A2 C2
	MOV	C,0xC3		; A2 C3
	MOV	C,0xC4		; A2 C4
	MOV	C,0xC5		; A2 C5
	MOV	C,0xC6		; A2 C6
	MOV	C,0xC7		; A2 C7
	MOV	C,CPRL2		; A2 C8
	MOV	C,CT2		; A2 C9
	MOV	C,TR2		; A2 CA
	MOV	C,EXEN2		; A2 CB
	MOV	C,TCLK		; A2 CC
	MOV	C,RCLK		; A2 CD
	MOV	C,EXF2		; A2 CE
	MOV	C,TF2		; A2 CF
	MOV	C,P		; A2 D0
	MOV	C,0xD1		; A2 D1
	MOV	C,OV		; A2 D2
	MOV	C,RS0		; A2 D3
	MOV	C,RS1		; A2 D4
	MOV	C,F0		; A2 D5
	MOV	C,AC		; A2 D6
	MOV	C,CY		; A2 D7
	MOV	C,0xD8		; A2 D8
	MOV	C,0xD9		; A2 D9
	MOV	C,0xDA		; A2 DA
	MOV	C,0xDB		; A2 DB
	MOV	C,0xDC		; A2 DC
	MOV	C,0xDD		; A2 DD
	MOV	C,0xDE		; A2 DE
	MOV	C,0xDF		; A2 DF
	MOV	C,ACC.0		; A2 E0
	MOV	C,ACC.1		; A2 E1
	MOV	C,ACC.2		; A2 E2
	MOV	C,ACC.3		; A2 E3
	MOV	C,ACC.4		; A2 E4
	MOV	C,ACC.5		; A2 E5
	MOV	C,ACC.6		; A2 E6
	MOV	C,ACC.7		; A2 E7
	MOV	C,0xE8		; A2 E8
	MOV	C,0xE9		; A2 E9
	MOV	C,0xEA		; A2 EA
	MOV	C,0xEB		; A2 EB
	MOV	C,0xEC		; A2 EC
	MOV	C,0xED		; A2 ED
	MOV	C,0xEE		; A2 EE
	MOV	C,0xEF		; A2 EF
	
	MOV	C,B.0		; A2 F0
	MOV	C,B.1		; A2 F1
	MOV	C,B.2		; A2 F2
	MOV	C,B.3		; A2 F3
	MOV	C,B.4		; A2 F4
	MOV	C,B.5		; A2 F5
	MOV	C,B.6		; A2 F6
	MOV	C,B.7		; A2 F7
	MOV	C,0xF8		; A2 F8
	MOV	C,0xF9		; A2 F9
	MOV	C,0xFA		; A2 FA
	MOV	C,0xFB		; A2 FB
	MOV	C,0xFC		; A2 FC
	MOV	C,0xFD		; A2 FD
	MOV	C,0xFE		; A2 FE
	MOV	C,0xFF		; A2 FF
;;/* Direct Mode (*) Checks */;;
BLLL4:	INC	*NN		; 05*12
	JBC	*NN,BLLL4	; 10*12 FB
	DEC	*NN		; 15*12
	JB	*NN,BLLL4	; 20*12 F6
	ADD	A,*NN		; 25*12
	JNB	*NN,BLLL4	; 30*12 F1
	ADDC	A,*NN		; 35*12
	ORL	*NN,A		; 42*12
	ORL	*NN,#MM		; 43*12r34
	ORL	A,*NN		; 45*12
	ANL	*NN,A		; 52*12
	ANL	*NN,#MM		; 53*12r34
	ANL	A,*NN		; 55*12
	XRL	*NN,A		; 62*12
	XRL	*NN,#MM		; 63*12r34
	XRL	A,*NN		; 65*12
	ORL	C,*NN		; 72*12
	MOV	*NN,#MM		; 75*12r34
	ANL	C,*NN		; 82*12
	MOV	*NN,*MM		; 85*34*12
	MOV	*NN,@R0		; 86*12
	MOV	*NN,@R1		; 87*12
	MOV	*NN,R0		; 88*12
	MOV	*NN,R1		; 89*12
	MOV	*NN,R2		; 8A*12
	MOV	*NN,R3		; 8B*12
	MOV	*NN,R4		; 8C*12
	MOV	*NN,R5		; 8D*12
	MOV	*NN,R6		; 8E*12
	MOV	*NN,R7		; 8F*12
	MOV	*NN,C		; 92*12
	SUBB	A,*NN		; 95*12
	ORL	C,*/NN		; A0*12
	MOV	C,*NN		; A2*12
	MOV	@R0,*NN		; A6*12
	MOV	@R1,*NN		; A7*12
	MOV	R0,*NN		; A8*12
	MOV	R1,*NN		; A9*12
	MOV	R2,*NN		; AA*12
	MOV	R3,*NN		; AB*12
	MOV	R4,*NN		; AC*12
	MOV	R5,*NN		; AD*12
	MOV	R6,*NN		; AE*12
	MOV	R7,*NN		; AF*12
	ANL	C,*/NN		; B0*12
	CPL	*NN		; B2*12
	CJNE	A,*NN,BLLL4	; B5*12 99
	PUSH	*NN		; C0*12
	CLR	*NN		; C2*12
	XCH	A,*NN		; C5*12
	POP	*NN		; D0*12
	SETB	*NN		; D2*12
	DJNZ	*NN,BLLL4	; D5*12 8C
	MOV	A,*NN		; E5*12
	MOV	*NN,A		; F5*12

	.blkb	0x1000 - (. - bgncode2)

