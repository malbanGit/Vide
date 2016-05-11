; Music player
; Copyright (C) 2004  Ville Krumlinde
;
; Translated from original 68000 code and music data by Rob Hubbard
;

;-----------------
;Vectrex RAM section
  bss
  org $c880

;Uncomment to make music use top of ram
  ds 1024 - 392 - $80 - 100

TEMP_D0: ds 2
TEMP_D1: ds 2
TEMP_D4: ds 2
TEMP_D5: ds 2
TEMP_D6: ds 2

  ;Work memory for soundplayer, data is copied from rom into these addresses in init
LA5_BASE: ds 76
L0596E6:  ds 102
L05974C:  ds 102
L0597B2:  ds 102

  code


;----------------------
; Music player
InitMusic:
  jsr dptoD0

  ;6809: copy work-data from rom to ram
  ldu #LA5_BASE_ROM
  ldx #LA5_BASE+46  ;offset 46 is the first one used, save rom-space
  lda #76
  jsr move_block2

  ldu #L0596E6_ROM
  ldx #L0596E6
  lda #102
  jsr move_block2

  ldu #L05974C_ROM
  ldx #L05974C
  lda #102
  jsr move_block2

  ldu #L0597B2_ROM
  ldx #L0597B2
  lda #102
  jsr move_block2



        ; LEA LA5_BASE,A5
        ; CLR.W $2E(A5)
        ; MOVEQ #$D,D1
        ;L059100:
        ; MOVE.B D1,$FF8800
        ; CLR.B $FF8802
        ; DBRA D1,L059100
  ldy #LA5_BASE
  ldd #0
  std $2e,y
  jsr clear_sound_chip

        ; MOVE.B #7,$FF8800
        ; MOVE.B #-1,$FF8802
        ; MOVE.B #-1,$41(A5)
        ; NOP
        ; LEA LA5_BASE,A5
        ; CLR.W $2E(A5)
  ;set mixer register
  lda #7
  ldb #%00111111  ;init mixer register, notes off, io enabled
  ldy #LA5_BASE
  stb $41,y
  jsr byte_2_sound_chip

        ; MOVE.B #-8,$38(A5)
        ; LEA L0596E6,A1
        ; MULU #$C,D0
        ; CLR.L D0
        ; MOVEQ #2,D7
  lda #-8
  sta $38,y
  ldu #L0596E6
  lda #3  ;nr of channels
  ldb #0
L059142:                ;init channel loop
        ; LEA L059818,A0
        ; MOVEA.L A0,A2
        ; ADDA.L 0(A0,D0.W),A2
        ; MOVE.L A2,8(A1)
        ; MOVE.W #1,$28(A1)
        ; CLR.W 0(A1)
        ; CLR.B $5C(A1)
        ; MOVE.L #4,$C(A1)
  pshs d

  ldx #L059818
  ldy b,x

  tfr x,d
  pshs y
  addd ,s++
  tfr d,x

  stx 8+2,u
  ldd #1
  std $28,u
  ldd #0
  std ,u
  sta $5c,u
  ldd #4-2
  std $c+2,u

  ; set up pointer to first pattern
        ; LEA L059818,A3
        ; ADDA.L (A2),A3
        ; MOVE.L A3,4(A1)
  ldy #L059818
  ldd ,x
  leay d,y
  sty 4+2,u

        ; ADDQ.W #4,D0
        ; ADDA.L #$66,A1         ;+102 = next channel data
        ; DBRA D7,L059142
  lda #102
  leau a,u
  puls d
  incb
  incb
  deca
  bne L059142

        ; MOVE.W #1,$32(A5)
        ; ST.B $2E(A5)
  ldy #LA5_BASE
  ldd #1
  std $32,y
  lda #$ff
  sta $2e,y

        ; this label is only used to jump directly to rts from update
        ; L059186:
        ; RTS
  rts


UpdateMusic:  ;call each vbl
        ; LEA LA5_BASE,A5
        ; TST.W $2E(A5)
        ; BEQ.S L059186
  ldy #LA5_BASE
  ldd $2e,y
  lbeq EXIT_UPDATE

        ; MOVE.B $34(A5),D0
        ; MOVE.B D0,$36(A5)
  lda $34,y
  sta $36,y

        ; SUBQ.W #1,$32(A5)
        ; BNE.S L0591C0
  ldd $32,y
  subd #1
  std $32,y
  bne L0591C0

        ; LEA L0596E6,A1
        ; BSR L059228
        ; LEA L05974C,A1
        ; BSR L059228
        ; LEA L0597B2,A1
        ; BSR L059228
  ldx #L0596E6
  jsr L059228
  ldx #L05974C
  jsr L059228
  ldx #L0597B2
  jsr L059228

        ; MOVE.W $30(A5),D0
        ; MOVE.W D0,$32(A5)
  ldy #LA5_BASE
  ldd $30,y
  std $32,y

L0591C0:
  ;L059418 returns three bytes, two bytes in d5, one byte in d4
  ;d5 holds channel pitch hi/lo, d4 holds channel volume
  ;these values are written to LA5_BASE register buffer after each call
        ; LEA L0596E6,A1
        ; BSR L059418
        ; MOVE.B D5,$3A(A5)
        ; LSR.W #8,D5
        ; MOVE.B D5,$3B(A5)
        ; MOVE.B D4,$42(A5)
  ldx #L0596E6
  jsr L059418
  ldy #LA5_BASE
  ldd TEMP_D5
  stb $3a,y
  sta $3b,y
  ldd TEMP_D4
; ldb #0        ;uncomment to mute channel 1
  stb $42,y
        ; LEA L05974C,A1
        ; BSR L059418
        ; MOVE.B D5,$3C(A5)
        ; LSR.W #8,D5
        ; MOVE.B D5,$3D(A5)
        ; MOVE.B D4,$43(A5)
  ldx #L05974C
  jsr L059418
  ldy #LA5_BASE
  ldd TEMP_D5
  stb $3c,y
  sta $3d,y
  ldd TEMP_D4
; ldb #0        ;uncomment to mute channel 2
  stb $43,y
        ; LEA L0597B2,A1
        ; BSR L059418
        ; MOVE.B D5,$3E(A5)
        ; LSR.W #8,D5
        ; MOVE.B D5,$3F(A5)
        ; MOVE.B D4,$44(A5)
  ldx #L0597B2
  jsr L059418
  ldy #LA5_BASE
  ldd TEMP_D5
  stb $3e,y
  sta $3f,y
  ldd TEMP_D4
; ldb #0        ;uncomment to mute channel 3
  stb $44,y

        ; MOVE.B $36(A5),D0
        ; MOVE.B D0,$40(A5)
  ldy #LA5_BASE
  lda $36,y
  sta $40,y    ;noise pitch

 ;**debug, force mixer register
; ldb $41,y
; andb #%00000111 ;keep tone
; orb  #%00010000 ;noise off
; stb $41,y


  ;write all sound chip registers at once
        ; MOVEQ #$D,D1
        ; MOVEA.L A5,A0
        ; ADDA.L #$48,A0  ;a5_offset
        ;L059214:
        ; MOVE.B D1,$FF8800
        ; MOVE.B -(A0),D0
        ; MOVE.B D0,$FF8802
        ; DBRA D1,L059214
  lda #$d
  leax $48,y
L059214:
  ldb ,-x
  pshs x,d
  jsr byte_2_sound_chip
  puls x,d
  deca
  bpl L059214

EXIT_UPDATE:
        ; RTS
  rts



 ; First update channel routine
 ; Read pattern data and updates channel info at x/A1
 ; x holds pointer to current channel data (A1)
L059228:
        ; SUBQ.W #1,$28(A1)
        ; BNE L059282
  ldd $28,x
  subd #1
  std $28,x
  bne L059282

        ; CLR.W 0(A1)
        ; BCLR #0,$60(A1)
  ldd #0
  std ,x
  lda $60,x
  anda #~(1<<0)
  sta $60,x

 ; read data from current pattern
 ; this is a variable length structure
        ; MOVEA.L 4(A1),A6
        ;L05923E:
        ; MOVE.B (A6)+,D0
        ; EXT.W D0
        ; BMI L0592A0
  ldu 4+2,x
L05923E:
  ldb ,u+
  sex
  bmi L0592A0

        ; MOVE.W D0,$30(A1)
        ; BTST #4,0(A1)
        ; BNE.S L059276
  std $30,x
  lda ,x
  bita #1<<4
  bne L059276

        ; MOVE.B $4C(A1),$34(A1)
  lda $4c,x
  sta $34,x

        ; BSET #5,0(A1)
        ; BSET #6,0(A1)
        ; BCLR #4,0(A1)
  lda ,x
  ora #(1<<5) | (1<<6)
  anda #~(1<<4)
  sta ,x

        ; MOVE.B $38(A1),$40(A1)
        ; MOVE.B $44(A1),$48(A1)
  lda $38,x
  sta $40,x
  lda $44,x
  sta $48,x

L059276:
        ; MOVE.W $2C(A1),$28(A1)
        ; MOVE.L A6,4(A1)
  ldd $2c,x
  std $28,x
  stu 4+2,x             ;write back pattern pointer

        ; RTS
  rts


 ; $28(a1) > 0
 ; x holds pointer to current channel data (A1)
L059282:
        ; BTST #3,0(A1)
        ; BEQ L059186
        ; BTST #7,0(A1)
        ; BEQ.S L05929A
  lda ,x
  bita #1<<3
  beq Exit_L059282
  bita #1<<7
  beq L05929A

        ; ADDQ.W #1,$30(A1)
        ; RTS
  ldd $30,x
  addd #1
  std $30,x
Exit_L059282:
  rts

L05929A:
        ; SUBQ.W #1,$30(A1)
        ; RTS
  ldd $30,x
  subd #1
  std $30,x
  rts


 ; negative value in pattern: register d/D0
 ; x holds pointer to current channel data (A1)
L0592A0:
        ; CMP.B #-$49,D0
        ; BLS L059306
  cmpb #-$49
  bls L059306

  ;add until overflow (d becomes positive)
        ; ADDI.W #$20,D0
        ; BCS L0592E2
        ; ADDI.W #$10,D0
        ; BCS L0592EC
        ; ADDI.W #$10,D0
        ; BCC L0592D6
  addd #$20
  bcs L0592E2
  addd #$10
  bcs L0592EC
  addd #$10
  bcc L0592D6

 ; d is index to L059642-table
        ; LEA L059642,A0
        ; LSL.W #2,D0
        ; ADDA.L 0(A0,D0.W),A0
  ldy #L059642
  lslb  ;*2
  ldd b,y
  leay d,y

        ; MOVE.L A0,$18(A1)
        ; MOVE.L A0,$14(A1)
        ; BRA L05923E
  sty $18+2,x
  sty $14+2,x
  bra L05923E

L0592D6:
        ; ADDI.W #9,D0
        ; MOVE.W D0,$30(A5)
        ; BRA L05923E
  addd #9
  ldy #LA5_BASE
  std $30,y
  bra L05923E

L0592E2:
        ; ADDQ.W #1,D0
        ; MOVE.W D0,$2C(A1)
        ; BRA L05923E
  addd #1
  std $2c,x
  bra L05923E

L0592EC:
        ; MOVE.B D0,$4C(A1)
        ; MOVE.B (A6)+,D0
        ; MOVE.B D0,$38(A1)
        ; MOVE.B (A6)+,D0
        ; MOVE.B D0,$3C(A1)
        ; MOVE.B (A6)+,D0
        ; MOVE.B D0,$44(A1)
        ; BRA L05923E
  stb $4c,x
  lda ,u+
  sta $38,x
  lda ,u+
  sta $3c,x
  lda ,u+
  sta $44,x
  bra L05923E

L059306:
  ;b is index into jumptable L05969E
        ; LEA L05969E,A0
        ; ANDI.L #$3F,D0
        ; LSL.W #2,D0
        ;; ADDA.L 0(A0,D0.W),A0
        ; move.l (a0,d0.w),a0    ;jumptable now holds absolute adresses
        ; JMP (A0)
  ldy #L05969E
  andb #$3f
  lda #2
  mul
  jmp [d,y]

L_CMD8:
  ;New track
        ; MOVEA.L 8(A1),A0
        ; ADDA.L $C(A1),A0
  ldy 8+2,x
  ldd $c+2,x
  leay d,y
        ; ADDQ.L #4,$C(A1)
  addd #4-2
  std $c+2,x
        ; MOVE.L (A0),D0
        ; BNE.S L059336
  ldd (0),y
  bne L059336
  ;End of tracks, loop
        ; MOVEA.L 8(A1),A0
        ; MOVE.L #4,$C(A1)
        ; MOVE.L (A0),D0

 ;we do not loop, instead trigger demo game
;  ldy 8+2,x
;  ldd #4-2
;  std $c+2,x
;  ldd (0),y

  lda #DemoGame ;trigger demo game
  sta GameMode
  lda DemoSelected
  inca
  anda #3
  cmpa #3
  bne *+3
    clra
  sta DemoSelected
  puls d,pc      ;hack, return from music to title, otherwise two more channels will call this

L059336:
        ; LEA L059818,A6
        ; ADDA.L D0,A6
        ; BRA L05923E
  ldu #L059818
  leau d,u
  bra L05923E

L_CMD12:
        ; MOVE.B $64(A1),D0
        ; ANDI.B #7,D0
  lda $64,x
  anda #7
        ; OR.B D0,$38(A5)
  tfr a,b
  ldy #LA5_BASE
  orb $38,y
  stb $38,y
        ; LSL.B #3,D0
  lsla
  lsla
  lsla
        ; NOT.B D0
  coma
        ; AND.B D0,$38(A5)
  ldb $38,y
  pshs a
  andb ,s+
  stb $38,y
        ; BRA L05923E
  bra L05923E


L_CMD11:
        ; MOVE.B $64(A1),D0
        ; ANDI.B #$38,D0
        ; OR.B D0,$38(A5)
  lda $64,x
  anda #$38
  tfr a,b
  ldy #LA5_BASE
  orb $38,y
  stb $38,y
        ; LSR.B #3,D0
        ; NOT.B D0
  lsra
  lsra
  lsra
  coma
        ; AND.B D0,$38(A5)
        ; BRA L05923E
  ldb $38,y
  pshs a
  andb ,s+
  stb $38,y
  bra L05923E

L_CMD13:
        ; MOVE.B $64(A1),D0
        ; NOT.B D0
  lda $64,x
  coma
        ; AND.B D0,$38(A5)
        ; BRA L05923E
  ldy #LA5_BASE
  ldb $38,y
  pshs a
  andb ,s+
  stb $38,y
  bra L05923E

L_CMD5:
        ; MOVE.B (A6)+,D0
        ; EXT.W D0
        ; CLR.W $10(A1)
        ; MOVE.W D0,$1C(A1)
  ldb ,u+
  sex
  std $1c,x
  ldd #0
  std $10,x
        ; CLR.W D0
        ; MOVE.B (A6)+,D0
        ; MOVE.W D0,$20(A1)
  ldb ,u+
  std $20,x
        ; BSET #2,0(A1)
        ; BRA L05923E
  lda ,x
  ora #1<<2
  sta ,x
  bra L05923E

L_CMD10:
        ; CLR.W D0
        ; MOVE.B (A6)+,D0
        ; MOVE.B D0,$34(A5)
        ; BRA L05923E
  lda ,u+
  ldy #LA5_BASE
  sta $34,y
  bra L05923E

L_CMD9:
        ; CLR.W D0
        ; MOVE.B (A6)+,D0
        ; MOVE.W D0,$54(A1)
  lda #0
  ldb ,u+
  std $54,x
        ; CLR.W D0
        ; MOVE.B (A6)+,D0
        ; MOVE.W D0,$50(A1)
        ; MOVE.W D0,$58(A1)
        ; BRA L05923E
  ldb ,u+
  std $50,x
  std $58,x
  bra L05923E

L_CMD7:
        ; BSET #7,0(A1)
  lda ,x
  ora #1<<7
  sta ,x
L_CMD6:
        ; BSET #3,0(A1)
        ; BRA L05923E
  lda ,x
  ora #1<<3
  sta ,x
  bra L05923E

L_CMD2:
        ; CLR.B $5C(A1)
        ; BRA L05923E
  lda #0
  sta $5c,x
  bra L05923E

L_CMD3:
        ; MOVE.B #$40,$5C(A1)
        ; BRA L05923E
  lda #$40
  sta $5c,x
  bra L05923E

L_CMD4:
        ; MOVE.B #-$40,$5C(A1)
        ; BRA L05923E
  lda #-$40
  sta $5c,x
  bra L05923E

L_CMD14:
        ; BSET #1,0(A1)
        ; BRA L05923E
  lda ,x
  ora #1<<1
  sta ,x
  bra L05923E

L_CMD1:
        ; CLR.B $34(A1)
  lda #0
  sta $34,x
L_CMD16:
        ; BCLR #5,0(A1)
        ; BRA L059276
  lda ,x
  anda #~(1<<5)
  sta ,x
  bra L059276

L_CMD17:
        ; BSET #4,0(A1)
        ; BRA L05923E
  lda ,x
  ora #1<<4
  sta ,x
  bra L05923E

L_CMD18:
        ; BSET #0,$60(A1)
        ; BRA L05923E
  lda $60,x
  ora #1<<0
  sta $60,x
  bra L05923E


 ; Second update channel routine
 ; Calculate sound register output based on current channel data
 ; x holds pointer to current channel data (A1)
 ; returns values in d4,d5
L059418:
 ; D6 is an alias for 0(A1). It is modified and written back at end of routine.

  ;TEMP_D0 - D6 globals are used many times, set up dp to save size and speed
  pshs dp
  lda #hi TEMP_D0
  tfr a,dp
  direct hi TEMP_D0

        ; MOVE.B 0(A1),D6
        ; BTST #5,D6
        ; BEQ L059484
  ldb ,x
  stb TEMP_D6
  bitb #1<<5
  beq L059484
        ; MOVE.B $40(A1),D0
        ; ADDI.B #-$10,D0
        ; BCS.S L059464
  lda $40,x
  adda #-$10
  bcs L059464
        ; BTST #6,D6
        ; BEQ.S L05946C
  bitb #1<<6
  beq L05946C
        ; ADD.B $34(A1),D0
        ; BCC.S L05943C
        ; MOVEQ #-1,D0
  adda $34,x
  bcc L05943C
  lda #-1
L05943C:
        ; ADDI.B #$10,D0
        ; MOVE.B D0,$34(A1)
  adda #$10
  sta $34,x
        ; MOVE.B $48(A1),D0
        ; ADDI.B #-$10,D0
        ; BCS.S L05945C
  lda $48,x
  adda #-$10
  bcs L05945C
        ; BCLR #6,D6
  ldb TEMP_D6
  andb #~(1<<6)
  stb TEMP_D6
        ; MOVE.B $3C(A1),$40(A1)
        ; BRA L059484
  lda $3c,x
  sta $40,x
  bra L059484
L05945C:
        ; MOVE.B D0,$48(A1)
        ; BRA L059484
  sta $48,x
  bra L059484
L059464:
        ; MOVE.B D0,$40(A1)
        ; BRA L059484
  sta $40,x
  bra L059484
L05946C:
        ; ANDI.B #$F,D0
        ; SUB.B D0,$34(A1)
        ; BPL.S L05947A
  anda #$f
  ldb $34,x
  pshs a
  subb ,s+
  stb $34,x
  bpl L05947A
        ; CLR.B $34(A1)
  lda #0
  sta $34,x
L05947A:
        ; SUBQ.B #1,$48(A1)
        ; BNE.S L059484
  lda $48,x
  deca
  sta $48,x
  bne L059484
        ; BCLR #5,D6
  ldb TEMP_D6
  andb #~(1<<5)
  stb TEMP_D6
L059484:
        ; MOVEA.L $18(A1),A0
        ; CLR.W D0
        ; MOVE.B (A0)+,D0
  ldy $18+2,x
  lda #0
  ldb ,y+
        ; CMP.B #-$79,D0
        ; BNE.S L05949E
  cmpb #-$79
  bne L05949E
        ; MOVE.L $14(A1),$18(A1)
  ldu $14+2,x
  stu $18+2,x
        ; MOVEA.L $18(A1),A0
        ; MOVE.B (A0)+,D0
  ldy $18+2,x
  ldb ,y+
L05949E:
        ; MOVE.L A0,$18(A1)
        ; ADD.W $30(A1),D0
  sty $18+2,x
  addd $30,x
        ; LEA L059582,A0
        ; ADD.W D0,D0
        ; MOVE.W D0,D4
  ldy #L059582
  pshs d
  addd ,s++
  std TEMP_D4
        ; MOVE.W 0(A0,D0.W),D5
  leay d,y
  ldd ,y
  std TEMP_D5
        ; BTST #6,$5C(A1)
        ; BEQ L059514
  lda $5c,x
  bita #1<<6
  lbeq L059514
        ; MOVE.W $50(A1),D1
        ; ADD.W D1,D1
  ldd $50,x
  pshs d
  addd ,s++
  std TEMP_D1
        ; MOVE.W $58(A1),D0
        ; BTST #7,$5C(A1)
        ; BEQ.S L0594D4
  ldd $58,x
  std TEMP_D0
  lda $5c,x
  bita #1<<7
  beq L0594D4
        ; BTST #0,D6
        ; BNE.S L059500
  ldb TEMP_D6
  bitb #1<<0
  bne L059500
L0594D4:
        ; BTST #5,$5C(A1)
        ; BNE.S L0594EC
  lda $5c,x
  bita #1<<5
  bne L0594EC
        ; SUB.W $54(A1),D0
        ; BPL.S L0594FC
  ldd TEMP_D0
  subd $54,x
  std TEMP_D0
  bpl L0594FC
        ; BSET #5,$5C(A1)
        ; MOVEQ #0,D0
        ; BRA.S L0594FC
  lda $5C,x
  ora #1<<5
  sta $5c,x
  ldd #0
  std TEMP_D0
  bra L0594FC
L0594EC:
        ; ADD.W $54(A1),D0
        ; CMP.W D1,D0
        ; BLS.S L0594FC
  ldd TEMP_D0
  addd $54,x
  std TEMP_D0
  cmpd TEMP_D1
  bls L0594FC
        ; BCLR #5,$5C(A1)
        ; MOVE.W D1,D0
  lda $5c,x
  anda #~(1<<5)
  sta $5c,x
  ldd TEMP_D1
  std TEMP_D0
L0594FC:
        ; MOVE.W D0,$58(A1)
  ldd TEMP_D0
  std $58,x
L059500:
        ; LSR.W #1,D1
  ldd TEMP_D1
  lsra
  rorb
  std TEMP_D1
        ; SUB.W D1,D0
  ldd TEMP_D0
  subd TEMP_D1
  std TEMP_D0
        ; SUBI.W #$60,D4
        ; BPL.S L059512
  ldd TEMP_D4
  subd #$60
  std TEMP_D4
  bpl L059512
L05950A:
        ; LSL.W #1,D0
  ldd TEMP_D0
  lslb
  rola
  std TEMP_D0
        ; ADDI.W #$18,D4
        ; BCC.S L05950A
  ldd TEMP_D4
  addd #$18
  std TEMP_D4
  bcc L05950A
L059512:
        ; ADD.W D0,D5
  ldd TEMP_D5
  addd TEMP_D0
  ;TEMP_D0 becomes inactive here
  std TEMP_D5
L059514:
        ; BCHG #0,D6
        ; MOVE.B D6,0(A1)
  lda TEMP_D6
  eora #1<<0  ;?
  sta TEMP_D6
  sta ,x
        ; BTST #2,D6
        ; BEQ.S L05953C
  bita #1<<2
  beq L05953C
        ; MOVE.W $20(A1),D0
        ; SUBQ.W #1,D0
        ; BNE.S L059538
  ldd $20,x
  subd #1
  bne L059538
        ; MOVE.W $1C(A1),D0
        ; ADD.W D0,$10(A1)
  ldd $1c,x
  addd $10,x
  std $10,x
        ; ADD.W $10(A1),D5
        ; BRA.S L05953C`
  ldd TEMP_D5
  addd $10,x
  std TEMP_D5
  bra L05953C
L059538:
        ; MOVE.W D0,$20(A1)
  std $20,x
L05953C:
        ; BTST #0,$60(A1)
        ; BEQ.S L059552
  lda $60,x
  bita #1<<0
  beq L059552
        ; BCLR #0,$60(A1)
        ; CLR.B $36(A5)
        ; MOVEQ #7,D0
        ; BRA.S L05956C
  lda $60,x
  anda #~(1<<0)
  sta $60,x
  ldy #LA5_BASE
  lda #0
  sta $36,y
  ldd #7
  bra L05956C
L059552:
        ; MOVE.B $38(A5),D0
        ; NOT.W D6
        ; ANDI.W #3,D6
        ; BNE.S L05956C
  ldb TEMP_D6
  comb
  andb #3
  lda #0
  tfr d,y
  ldu #LA5_BASE
  ldb $38,u
  leay ,y
  bne L05956C

        ; MOVE.B $34(A5),D0
        ; BCHG #3,D0
        ; MOVE.B D0,$36(A5)
  ldy #LA5_BASE
  lda $34,y
  eora #1<<3
  sta $36,y
        ; MOVEQ #7,D0
  ldd #7
L05956C:
        ; MOVE.B $41(A5),D1
        ; EOR.W D1,D0
  ldy #LA5_BASE
  eorb $41,y
        ; AND.B $64(A1),D0
        ; EOR.W D1,D0
  andb $64,x
  eorb $41,y
        ; MOVE.B D0,$41(A5)
        ; MOVE.B $34(A1),D4
        ; RTS
  stb $41,y
  ldb $34,x
  lda #0
  std TEMP_D4
  ;return values in TEMP_D4, TEMP_D5
  puls dp,pc
  direct -1
;  rts

;Data

L059582:  ;word-tabell, readonly. Frequenzies.
 dw $EEE
 dw $E17
 dw $D4D
 dw $C8E
 dw $BD9
 dw $B2F
 dw $A8E
 dw $9F7
 dw $967
 dw $8E0
 dw $861
 dw $7E8
 dw $777
 dw $70B
 dw $6A6
 dw $647
 dw $5EC
 dw $597
 dw $547
 dw $4FB
 dw $4B3
 dw $470
 dw $430
 dw $3F4
 dw $3BB
 dw $385
 dw $353
 dw $323
 dw $2F6
 dw $2CB
 dw $2A3
 dw $27D
 dw $259
 dw $238
 dw $218
 dw $1FA
 dw $1DD
 dw $1C2
 dw $1A9
 dw $191
 dw $17B
 dw $165
 dw $151
 dw $13E
 dw $12C
 dw $11C
 dw $10C
 dw $FD
 dw $EE
 dw $E1
 dw $D4
 dw $C8
 dw $BD
 dw $B2
 dw $A8
 dw $9F
 dw $96
 dw $8E
 dw $86
 dw $7E
 dw $77
 dw $70
 dw $6A
 dw $64
 dw $5E
 dw $59
 dw $54
 dw $4F
 dw $4B
 dw $47
 dw $43
 dw $3F
 dw $3B
 dw $38
 dw $35
 dw $32
 dw $2F
 dw $2C
 dw $2A
 dw $27
 dw $25
 dw $23
 dw $21
 dw $1F
 dw $1D
 dw $1C
 dw $1A
 dw $19
 dw $17
 dw $16
 dw $15
 dw $13
 dw $12
 dw $11
 dw $10
 dw $F


L059642:  ;longword-table, readonly
 ;Offsets from L059642 to data below
 if false
 dw 0,$2C
 dw 0,$2E
 dw 0,$32
 dw 0,$35
 dw 0,$38
 dw 0,$3B
 dw 0,$3E
 dw 0,$41
 dw 0,$46
 dw 0,$4A
 dw 0,$53
 endif

 ;Converted to word-table, saved 22-bytes
 dw $2C-22
 dw $2E-22
 dw $32-22
 dw $35-22
 dw $38-22
 dw $3B-22
 dw $3E-22
 dw $41-22
 dw $46-22
 dw $4A-22
 dw $53-22

 ;Offset $2c
 dw $87
 dw 7
 dw $C87
 dw 4
 dw $8700
 dw $287
 dw 3
 dw $8700
 dw $587
 dw $E
 dw $870C
 dw $C0C
 dw $1887
 dw 4
 dw $787
 dw 0
 dw $505
 dw $707
 dw $C0C
 dw $8700
 dw 6
 dw $608
 dw $80C
 dw $C87


L05969E:    ;Jumptable, readonly
        ; dc.l L_CMD1
        ; dc.l L_CMD2
        ; dc.l L_CMD3
        ; dc.l L_CMD4
        ; dc.l L_CMD5
        ; dc.l L_CMD6
        ; dc.l L_CMD7
        ; dc.l L_CMD8
        ; dc.l L_CMD9
        ; dc.l L_CMD10
        ; dc.l L_CMD11
        ; dc.l L_CMD12
        ; dc.l L_CMD13
        ; dc.l L_CMD14
        ; ;dw $FFFF ;-1454
        ; ;dw $FA52
        ; ;$590F0
        ; dc.l L0590F0     ;Används denna?
        ; dc.l L_CMD16
        ; dc.l L_CMD17
        ; dc.l L_CMD18
  dw L_CMD1,L_CMD2,L_CMD3,L_CMD4,L_CMD5,L_CMD6,L_CMD7,L_CMD8,L_CMD9,L_CMD10
  dw L_CMD11,L_CMD12,L_CMD13,L_CMD14,0,L_CMD16,L_CMD17,L_CMD18


L059818:        ;music-data, readonly
        ;Song 1, track offsets for each channel
        ; dc.l TRACK_DATA_CHANNEL1-L059818
        ; dc.l TRACK_DATA_CHANNEL2-L059818
        ; dc.l TRACK_DATA_CHANNEL3-L059818

  ;6809: converted to 16-bit offsets
  dw TRACK_DATA_CHANNEL1-L059818
  dw TRACK_DATA_CHANNEL2-L059818
  dw TRACK_DATA_CHANNEL3-L059818

  ;make sure offsets stays the same
  ds 6

;Track data has been converted to 16-offsets from 32-bits.
;About 600 bytes were saved.
;Offsets modifed to oldvalue-savedspace.

;Define track. 319 is the sum of entries. 0 is end of tracks.
mDt macro value
 if 0=value
   dw 0
 else
   dw value - (319*2)
 endif
 endm

 ;Channel 1 track, offset $C, 37 entries
 ;Longword offsets to patterns
TRACK_DATA_CHANNEL1:
 mDt $8E5
 mDt $9B6
 mDt $9B6
 mDt $9B6
 mDt $9B6
 mDt $9B6
 mDt $9B6
 mDt $9B6
 mDt $9B6
 mDt $87E
 mDt $55F
 mDt $50E
 mDt $50E
 mDt $592
 mDt $5F1
 mDt $87E
 mDt $55F
 mDt $50E
 mDt $50E
 mDt $87E
 mDt $8CC
 mDt $8CC
 mDt $8DA
 mDt $9B6
 mDt $9B6
 mDt $9B6
 mDt $9B6
 mDt $87E
 mDt $592
 mDt $5F1
 mDt $87E
 mDt $55F
 mDt $508
 mDt $568
 mDt $568
 mDt $87E
 mDt 0

 ;Channel 2 track, offset $A0, 139 entries
TRACK_DATA_CHANNEL2:
 mDt $65A
 mDt $65A
 mDt $65A
 mDt $65A
 mDt $65A
 mDt $65A
 mDt $65A
 mDt $65A
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $83F
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $67F
 mDt $67F
 mDt $67F
 mDt $67F
 mDt $67F
 mDt $67F
 mDt $67F
 mDt $67F
 mDt $6B5
 mDt $6B5
 mDt $6EA
 mDt $6B5
 mDt $6B5
 mDt $74B
 mDt $74B
 mDt $77C
 mDt $77C
 mDt $7AD
 mDt $7AD
 mDt $77C
 mDt $77C
 mDt $7DE
 mDt $83F
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $83F
 mDt $8F8
 mDt $8F8
 mDt $8F8
 mDt $8F8
 mDt $8F8
 mDt $8F8
 mDt $8F8
 mDt $8F8
 mDt $8F8
 mDt $8F8
 mDt $8F8
 mDt $8F8
 mDt $83F
 mDt $67F
 mDt $67F
 mDt $67F
 mDt $67F
 mDt $67F
 mDt $67F
 mDt $67F
 mDt $67F
 mDt $6B5
 mDt $6B5
 mDt $6EA
 mDt $6B5
 mDt $6B5
 mDt $74B
 mDt $74B
 mDt $77C
 mDt $77C
 mDt $7AD
 mDt $7AD
 mDt $77C
 mDt $77C
 mDt $7DE
 mDt $83F
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $624
 mDt $83F
 mDt 0

 ;Channel 3 track, offset $2CC, 143 entries
TRACK_DATA_CHANNEL3:
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A76
 mDt $A51
 mDt $A51
 mDt $A51
 mDt $A51
 mDt $8A1
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $A51
 mDt $AE3
 mDt $A92
 mDt $AC8
 mDt $A51
 mDt $AE3
 mDt $A92
 mDt $AC8
 mDt $AE3
 mDt $AE3
 mDt $AC8
 mDt $AC8
 mDt $AAD
 mDt $AAD
 mDt $A92
 mDt $A92
 mDt $A51
 mDt $A51
 mDt $AC8
 mDt $AC8
 mDt $AAD
 mDt $AAD
 mDt $A92
 mDt $A92
 mDt $8A1
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $8A1
 mDt $96C
 mDt $96C
 mDt $96C
 mDt $96C
 mDt $96C
 mDt $96C
 mDt $96C
 mDt $96C
 mDt $96C
 mDt $96C
 mDt $96C
 mDt $96C
 mDt $8A1
 mDt $A51
 mDt $AE3
 mDt $A92
 mDt $AC8
 mDt $A51
 mDt $AE3
 mDt $A92
 mDt $AC8
 mDt $AE3
 mDt $AE3
 mDt $AC8
 mDt $AC8
 mDt $AAD
 mDt $AAD
 mDt $A92
 mDt $A92
 mDt $A51
 mDt $A51
 mDt $AC8
 mDt $AC8
 mDt $AAD
 mDt $AAD
 mDt $A92
 mDt $A92
 mDt $8A1
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $9DF
 mDt $A1D
 mDt $A37
 mDt $A03
 mDt $8A1
 mDt 0

 ;Patterns
 dw $C781
 dw $87FF
 dw $8087
 dw $C18A
 dw $8801
 dw $281
 dw $DF00
 dw $1104
 dw $E02D
 dw $2D2D
 dw $2D34
 dw $342D
 dw $2D30
 dw $30E0
 dw $3434
 dw $2D2D
 dw $3434
 dw $3737
 dw $3737
 dw $E037
 dw $3735
 dw $3535
 dw $3535
 dw $3534
 dw $3434
 dw $34E0
 dw $3030
 dw $3030
 dw $3535
 dw $2D2D
 dw $3030
 dw $3535
 dw $E02D
 dw $2D35
 dw $3532
 dw $3232
 dw $3232
 dw $3230
 dw $30E0
 dw $3030
 dw $3030
 dw $3232
 dw $3232
 dw $87C0
 dw $DF00
 dw $6102
 dw $8801
 dw $283
 dw $E52D
 dw $2FE3
 dw $30E5
 dw $3432
 dw $E330
 dw $E52D
 dw $30E3
 dw $3532
 dw $32E1
 dw $30E5
 dw $2F2D
 dw $30E3
 dw $34E5
 dw $3735
 dw $E334
 dw $E530
 dw $34E3
 dw $3532
 dw $32E1
 dw $30E5
 dw $2F87
 dw $C08A
 dw $8801
 dw $282
 dw $DF00
 dw $6102
 dw $E180
 dw $E134
 dw $E032
 dw $E130
 dw $E42D
 dw $E12B
 dw $2DE1
 dw $80E1
 dw $34E0
 dw $32E1
 dw $30E0
 dw $32E3
 dw $8080
 dw $E180
 dw $E132
 dw $E030
 dw $E12F
 dw $E430
 dw $E12F
 dw $2DEF
 dw $2BE1
 dw $80E1
 dw $34E0
 dw $32E1
 dw $30E4
 dw $2DE1
 dw $3034
 dw $E180
 dw $E139
 dw $E037
 dw $E135
 dw $E232
 dw $E180
 dw $E380
 dw $E180
 dw $E137
 dw $E035
 dw $E134
 dw $E435
 dw $E337
 dw $E635
 dw $E834
 dw $87C0
 dw $8A88
 dw $102
 dw $83DF
 dw $F1
 dw $2F7
 dw $32E3
 dw $3435
 dw $F730
 dw $E380
 dw $80F7
 dw $30E3
 dw $3234
 dw $EF2F
 dw $EFC6
 dw $861D
 dw $C0F7
 dw $30E3
 dw $3435
 dw $FF34
 dw $F735
 dw $E337
 dw $39EF
 dw $37EF
 dw $C686
 dw $1D87
 dw $C0DF
 dw $11
 dw $FE1
 dw $8B89
 dw $1F8D
 dw $E0
 dw $8A91
 dw $2891
 dw $2D8B
 dw $8907
 dw $8D00
 dw $8A91
 dw $3091
 dw $348B
 dw $891F
 dw $8D00
 dw $E18D
 dw $E0
 dw $8A91
 dw $2D91
 dw $2D8B
 dw $8907
 dw $8D00
 dw $8A91
 dw $3491
 dw $3291
 dw $3087
 dw $C0DF
 dw $11
 dw $FE1
 dw $8B89
 dw $1F8D
 dw $80
 dw $E089
 dw $78D
 dw $80
 dw $8089
 dw $1F8D
 dw $E1
 dw $8D00
 dw $E080
 dw $8089
 dw $78D
 dw $80
 dw $8080
 dw $87C0
 dw $DF00
 dw $110F
 dw $E18B
 dw $891F
 dw $8D00
 dw $E08A
 dw $911C
 dw $911F
 dw $8B89
 dw $78D
 dw $8A
 dw $9124
 dw $9121
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8D00
 dw $E08A
 dw $911F
 dw $9121
 dw $8B89
 dw $78D
 dw $8A
 dw $9124
 dw $9121
 dw $911F
 dw $87C2
 dw $DF00
 dw $2108
 dw $E18B
 dw $891F
 dw $8D00
 dw $E18A
 dw $9129
 dw $E08B
 dw $8907
 dw $8D00
 dw $E18A
 dw $9129
 dw $E08B
 dw $891F
 dw $8D00
 dw $E18D
 dw $E0
 dw $8A91
 dw $2991
 dw $1D8B
 dw $8907
 dw $8D00
 dw $E18A
 dw $9129
 dw $E091
 dw $2987
 dw $C3E1
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8A91
 dw $29E0
 dw $8B89
 dw $78D
 dw $E1
 dw $8A91
 dw $29E0
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8D00
 dw $E08A
 dw $9129
 dw $911D
 dw $8B89
 dw $78D
 dw $E1
 dw $8A91
 dw $29E0
 dw $9129
 dw $C4E1
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8A91
 dw $28E0
 dw $8B89
 dw $78D
 dw $E1
 dw $8A91
 dw $28E0
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8D00
 dw $E08A
 dw $9128
 dw $911C
 dw $8B89
 dw $78D
 dw $E1
 dw $8A91
 dw $28E0
 dw $9128
 dw $87C2
 dw $E18B
 dw $891F
 dw $8D00
 dw $E18A
 dw $912B
 dw $E08B
 dw $8907
 dw $8D00
 dw $E18A
 dw $912B
 dw $E08B
 dw $891F
 dw $8D00
 dw $E18D
 dw $E0
 dw $8A91
 dw $2B91
 dw $1F8B
 dw $8907
 dw $8D00
 dw $E18A
 dw $912B
 dw $E091
 dw $2B87
 dw $C4E1
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8A91
 dw $2DE0
 dw $8B89
 dw $78D
 dw $E1
 dw $8A91
 dw $2DE0
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8D00
 dw $E08A
 dw $912D
 dw $9121
 dw $8B89
 dw $78D
 dw $E1
 dw $8A91
 dw $2DE0
 dw $912D
 dw $87C5
 dw $E18B
 dw $891F
 dw $8D00
 dw $E18A
 dw $912B
 dw $E08B
 dw $8907
 dw $8D00
 dw $E18A
 dw $912B
 dw $E08B
 dw $891F
 dw $8D00
 dw $E18D
 dw $E0
 dw $8A91
 dw $2B91
 dw $1F8B
 dw $8907
 dw $8D00
 dw $E18A
 dw $912B
 dw $E091
 dw $2B87
 dw $C3E1
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8A91
 dw $30E0
 dw $8B89
 dw $78D
 dw $E1
 dw $8A91
 dw $30E0
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8D00
 dw $E08A
 dw $9130
 dw $9124
 dw $8B89
 dw $78D
 dw $E1
 dw $8A91
 dw $30E0
 dw $9130
 dw $C4E1
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8A91
 dw $2FE0
 dw $8B89
 dw $78D
 dw $E1
 dw $8A91
 dw $2FE0
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8D00
 dw $E08A
 dw $912F
 dw $9123
 dw $8B89
 dw $78D
 dw $E1
 dw $8A91
 dw $2FE0
 dw $912F
 dw $87E1
 dw $8B89
 dw $1F8D
 dw $89
 dw $C8D
 dw $8D
 dw $89
 dw $1F8D
 dw $E0
 dw $8D00
 dw $890C
 dw $8D00
 dw $E18D
 dw $8D
 dw $E0
 dw $891F
 dw $8D00
 dw $E18D
 dw $E0
 dw $890C
 dw $8D00
 dw $E18D
 dw $8D
 dw $8D
 dw $E3
 dw $8D00
 dw $E089
 dw $1F8D
 dw $8D
 dw $8D
 dw $8D
 dw $87
 dw $C581
 dw $DF00
 dw $1104
 dw $E128
 dw $2828
 dw $28E0
 dw $2828
 dw $E128
 dw $28E0
 dw $28E1
 dw $28E0
 dw $28E1
 dw $2828
 dw $28E3
 dw $28E0
 dw $3430
 dw $2D28
 dw $87DF
 dw $61
 dw $2E1
 dw $9115
 dw $9115
 dw $9115
 dw $9115
 dw $E091
 dw $1591
 dw $15E1
 dw $9115
 dw $9115
 dw $E091
 dw $15E1
 dw $15E0
 dw $9115
 dw $E191
 dw $1591
 dw $1591
 dw $15E3
 dw $9115
 dw $8087
 dw $8AD1
 dw $111
 dw $F188
 dw $606
 dw $82C6
 dw $FF86
 dw $1F87
 dw $FFC0
 dw $398F
 dw $3C8F
 dw $3B34
 dw $2D8F
 dw $87BD
 dw $8ADF
 dw $F1
 dw $188
 dw $206
 dw $82C0
 dw $FF21
 dw $241D
 dw $1A18
 dw $1587
 dw $C0DF
 dw $11
 dw $FE0
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8907
 dw $8D00
 dw $E089
 dw $1F8D
 dw $E1
 dw $8907
 dw $8D00
 dw $E089
 dw $1F8D
 dw $8D
 dw $E0
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8907
 dw $8D00
 dw $E089
 dw $1F8D
 dw $E1
 dw $8907
 dw $8D00
 dw $E089
 dw $1F8D
 dw $8D
 dw $E0
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8907
 dw $8D00
 dw $E089
 dw $1F8D
 dw $E1
 dw $8907
 dw $8D00
 dw $E089
 dw $1F8D
 dw $8D
 dw $E0
 dw $8B89
 dw $1F8D
 dw $E1
 dw $8907
 dw $8D00
 dw $E089
 dw $1F8D
 dw $E1
 dw $8907
 dw $8D00
 dw $E08D
 dw $8D
 dw $87
 dw $C0DF
 dw $12
 dw $FE0
 dw $9121
 dw $9145
 dw $9121
 dw $9121
 dw $9145
 dw $9121
 dw $9121
 dw $9121
 dw $E091
 dw $2191
 dw $4591
 dw $2191
 dw $2191
 dw $4591
 dw $2191
 dw $2191
 dw $21E0
 dw $9121
 dw $9145
 dw $9121
 dw $9121
 dw $9145
 dw $9121
 dw $9121
 dw $9121
 dw $E091
 dw $2191
 dw $4591
 dw $2191
 dw $2191
 dw $4591
 dw $2191
 dw $4591
 dw $4587
 dw $DF00
 dw $210F
 dw $8A81
 dw $E1C4
 dw $9139
 dw $C0E0
 dw $9128
 dw $9034
 dw $9128
 dw $9034
 dw $9124
 dw $9030
 dw $E191
 dw $21C4
 dw $9139
 dw $E0C0
 dw $912B
 dw $902D
 dw $9137
 dw $9039
 dw $878A
 dw $DF00
 dw $4103
 dw $C088
 dw $101
 dw $82E0
 dw $2115
 dw $1F21
 dw $E191
 dw $8428
 dw $124
 dw $E121
 dw $E021
 dw $151F
 dw $21E1
 dw $9184
 dw $2801
 dw $2421
 dw $87E0
 dw $1A0E
 dw $181A
 dw $E191
 dw $8428
 dw $124
 dw $E11A
 dw $E01A
 dw $E18
 dw $1AE1
 dw $9184
 dw $2801
 dw $241A
 dw $87E0
 dw $180C
 dw $1718
 dw $E191
 dw $8428
 dw $124
 dw $E118
 dw $E018
 dw $C17
 dw $18E1
 dw $9184
 dw $2801
 dw $2418
 dw $87E0
 dw $1D11
 dw $1C1D
 dw $E191
 dw $8428
 dw $124
 dw $E11D
 dw $E01D
 dw $111C
 dw $1DE1
 dw $9184
 dw $2801
 dw $241D
 dw $878A
 dw $DF00
 dw $6102
 dw $C088
 dw $101
 dw $82E1
 dw $9115
 dw $9115
 dw $E191
 dw $8428
 dw $124
 dw $E080
 dw $E091
 dw $15E3
 dw $9115
 dw $E191
 dw $8428
 dw $124
 dw $8087
 dw $8ADF
 dw $61
 dw $2C0
 dw $8801
 dw $182
 dw $E380
 dw $E191
 dw $8428
 dw $124
 dw $E580
 dw $E191
 dw $8428
 dw $124
 dw $8087
 dw $E191
 dw $1391
 dw $13E1
 dw $9184
 dw $2801
 dw $24E0
 dw $80E0
 dw $9113
 dw $E391
 dw $13E1
 dw $9184
 dw $2801
 dw $2480
 dw $87E1
 dw $9111
 dw $9111
 dw $E191
 dw $8428
 dw $124
 dw $E080
 dw $E091
 dw $11E3
 dw $9111
 dw $E191
 dw $8428
 dw $124
 dw $8087
 dw $E191
 dw $C91
 dw $CE1
 dw $9184
 dw $2801
 dw $24E0
 dw $80E0
 dw $910C
 dw $E391
 dw $CE1
 dw $9184
 dw $2801
 dw $2480
 dw $87E1
 dw $910E
 dw $910E
 dw $E191
 dw $8428
 dw $124
 dw $E080
 dw $E091
 dw $EE3
 dw $910E
 dw $E191
 dw $8428
 dw $124
 dw $8087
 dw 0
 dw 0
 dw 0
 dw 0


;---------------------
; READ/WRITE memory, 3*102 + 76 = 382 bytes
;---------------------

LA5_BASE_ROM:  ;status, read/write
; ds 46  ;$2e
 ;2e is first offset, 44 the highest
 dw $FF00
 dw 6
 dw 6
 dw $700
 dw 0
 dw $F800
 dw $F000
 dw $DD01
 dw $F302
 dw $EA
 dw $F0F
 dw $F00
 dw 0
 dw $20
 dw $FFFF


;+ = reset in init
L0596E6_ROM:  ;channel 1 data, read/write, 102 bytes
 dw 0   ;0 +
 dw 0   ;2
 dw 0,0   ;4 +
 dw 0,0   ;8 +
 dw 0,0   ;C +
 dw 0
 dw 0
 dw 3
 dw $5CA
 dw 3
 dw $5CB
 dw 0
 dw 0
 dw 0
 dw 0
 dw 0
 dw 0
 dw 0  ;$28 +
 dw 0
 dw 2
 dw 0
 dw $2B
 dw 0
 dw $F00
 dw 0
 dw 0
 dw 0
 dw $6100
 dw 0
 dw $100
 dw 0
 dw $200
 dw 0
 dw $200
 dw 0
 dw $F00
 dw 0
 dw 2
 dw 0
 dw 1
 dw 0
 dw 3
 dw 0
 db 0  ;$5c +
 db 0
 dw 0
 dw 0
 dw 0
 dw $900
L05974C_ROM:  ;channel 2 data, read/write
 dw $2100
 dw 0
 dw 3
 dw $E24
 dw 3
 dw $814
 dw 0
 dw $98
 dw 0
 dw 0
 dw 3
 dw $5CA
 dw 3
 dw $5CB
 dw 0
 dw 0
 dw 0
 dw 0
 dw 0
 dw 0
 dw 1
 dw 0
 dw 1
 dw 0
 dw $24
 dw 0
 dw $F00
 dw 0
 dw 0
 dw 0
 dw $1100
 dw 0
 dw $1100
 dw 0
 dw $F00
 dw 0
 dw $F00
 dw 0
 dw $F00
 dw 0
 dw 0
 dw 0
 dw 0
 dw 0
 dw 0
 dw 0
 dw 0
 dw 0
 dw 0
 dw 0
 dw $1200
L0597B2_ROM:  ;channel 3 data, read/write
 dw $2500
 dw 0
 dw 3
 dw $11E8
 dw 3
 dw $A40
 dw 0
 dw $98
 dw $118
 dw 0
 dw 3
 dw $5CA
 dw 3
 dw $5CB
 dw $28
 dw 0
 dw 1
 dw 0
 dw 0
 dw 0
 dw 1
 dw 0
 dw 2
 dw 0
 dw $24
 dw 0
 dw $F00
 dw 0
 dw 0
 dw 0
 dw $6100
 dw 0
 dw $100
 dw 0
 dw $200
 dw 0
 dw $200
 dw 0
 dw $F00
 dw 0
 dw 1
 dw 0
 dw 1
 dw 0
 dw 0
 dw 0
 dw $4000
 dw 0
 dw 0
 dw 0
 dw $2400


