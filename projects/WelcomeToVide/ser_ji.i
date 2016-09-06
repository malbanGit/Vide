;
;
; SER_JI.I - Serial Output on Joystick port, Inverted
;
;
; Copyright (c) Alex Herbert 2002
;
;
;
; This code assumes that the following constant have been declared.
; If not... un-comment them!
;
;VIA_port_b   equ     $d000
;VIA_port_a     equ     $d001
;VIA_DDR_a    equ     $d003
;VIA_t1_cnt_lo  equ     $d004
;VIA_aux_cntl  equ     $d00b
;VIA_int_flags   equ     $d00d
VIA_port_b          EQU      $D000                        ;VIA port B data I/O register 
                    *        0 sample/hold (0=enable mux 1=disable mux) 
                    *        1 mux sel 0 
                    *        2 mux sel 1 
                    *        3 sound BC1 
                    *        4 sound BDIR 
                    *        5 comparator input 
                    *        6 external device (slot pin 35) initialized to input 
                    *        7 /RAMP 
VIA_port_a          EQU      $D001                        ;VIA port A data I/O register (handshaking) 
VIA_DDR_b           EQU      $D002                        ;VIA port B data direction register (0=input 1=output) 
VIA_DDR_a           EQU      $D003                        ;VIA port A data direction register (0=input 1=output) 
VIA_t1_cnt_lo       EQU      $D004                        ;VIA timer 1 count register lo (scale factor) 
VIA_t1_cnt_hi       EQU      $D005                        ;VIA timer 1 count register hi 
VIA_t1_lch_lo       EQU      $D006                        ;VIA timer 1 latch register lo 
VIA_t1_lch_hi       EQU      $D007                        ;VIA timer 1 latch register hi 
VIA_t2_lo           EQU      $D008                        ;VIA timer 2 count/latch register lo (refresh) 
VIA_t2_hi           EQU      $D009                        ;VIA timer 2 count/latch register hi 
VIA_shift_reg       EQU      $D00A                        ;VIA shift register 
VIA_aux_cntl        EQU      $D00B                        ;VIA auxiliary control register 
                    *        0 PA latch enable 
                    *        1 PB latch enable 
                    *        2 \ 110=output to CB2 under control of phase 2 clock 
                    *        3 > shift register control (110 is the only mode used by the Vectrex ROM) 
                    *        4 / 
                    *        5 0=t2 one shot 1=t2 free running 
                    *        6 0=t1 one shot 1=t1 free running 
                    *        7 0=t1 disable PB7 output 1=t1 enable PB7 output 
VIA_cntl            EQU      $D00C                        ;VIA control register 
                    *        0 CA1 control CA1 -> SW7 0=IRQ on low 1=IRQ on high 
                    *        1 \ 
                    *        2 > CA2 control CA2 -> /ZERO 110=low 111=high 
                    *        3 / 
                    *        4 CB1 control CB1 -> NC 0=IRQ on low 1=IRQ on high 
                    *        5 \ 
                    *        6 > CB2 control CB2 -> /BLANK 110=low 111=high 
                    *        7 / 
VIA_int_flags       EQU      $D00D                        ;VIA interrupt flags register 
                    *        bit cleared by 
                    *        0 CA2 interrupt flag reading or writing port A I/O 
                    *        1 CA1 interrupt flag reading or writing port A I/O 
                    *        2 shift register interrupt flag reading or writing shift register 
                    *        3 CB2 interrupt flag reading or writing port B I/O 
                    *        4 CB1 interrupt flag reading or writing port A I/O 
                    *        5 timer 2 interrupt flag read t2 low or write t2 high 
                    *        6 timer 1 interrupt flag read t1 count low or write t1 high 
                    *        7 IRQ status flag write logic 0 to IER or IFR bit 
VIA_int_enable      EQU      $D00E                        ;VIA interrupt enable register 
                    *        0 CA2 interrupt enable 
                    *        1 CA1 interrupt enable 
                    *        2 shift register interrupt enable 
                    *        3 CB2 interrupt enable 
                    *        4 CB1 interrupt enable 
                    *        5 timer 2 interrupt enable 
                    *        6 timer 1 interrupt enable 
                    *        7 IER set/clear control 
;
;
; Baud rate setting
;
SER_BITTIME         equ      $9c00                        ; $009c = 156 cycles = 9615 baud 
;
; Subroutines
;
                    code     
                    direct   VIA_port_b                   ; assume dp = $d0 
;
; ser_txbyte
; ----------
;
; Function:
;       transmit byte serially (8n1, inverted) via joystick ports.
;
; On entry:
;       a = byte to transmit
;       dp = $d0
;
; On exit:
;       d,cc = corrupted
;
; Stack usage:
;       5 bytes (7 if you include the return address)
;
ser_txbyte 
                    pshs     a                            ; put data on stack 
                    ldd      #$9907 
                                                          ; load PSG latch address with (BC1 + BDIR = 11) 
                    std      VIA_port_b                   ; PSG register 7 
                    ldd      #$5881 
                    sta      VIA_aux_cntl                 ; T1 mode = free-run, no output on RAMP (PB7) 
                    stb      VIA_port_b                   ; PSG inactive (BC1 + BDIR = 00)
                    ldd      #SER_BITTIME 
                    std      VIA_t1_cnt_lo                ; set and start timer (T1) 
                    ldd      #$0089 
                    sta      VIA_DDR_a                    ; 6522 I/O port data direction = input 
                    stb      VIA_port_b                   ; enable PSG reading (BC1 + BDIR = 01) 

                    ldb      #$08                         ; loop counter (here for timing) 
                    lda      VIA_port_a                   ; read PSG register 7 

                    pshs     d                            ; save PSG R7 and loop counter on stack 
                    ora      #$40                         ; set bit 6, meaning this will be our "zero" start bit
                                                          ; bit 6 set means that portA is in output mode
                                                          ; output of "Output Data portA" which is "$ef"
                                                          ; which is a 1 for all but bit 4
                                                          ; bit 4 is our vecVoice "dataline"
                                

                    sta      VIA_port_a                   ; store data for PSG write (to DAC)

                    ldd      #$ff81 
                    stb      VIA_port_b                   ; disable PSG reading (BC1 + BDIR = 00)
                    sta      VIA_DDR_a                    ; 6522 I/O direction = output (ff = all bits)
                    bsr      ser_txbit                    ; transmit start bit [0] hey 
sertx_loop 
                    lsr      2,s                          ; shift next data bit into carry 
                    bcs      ser_tx1 
ser_tx0 
                    lda      ,s 
                    ora      #$40 
                    sta      VIA_port_a                   ; store data for PSG write 
                    bsr      ser_txbit                    ; transmit data bit [0] 
                    bra      sertx_next 

ser_tx1 
                    lda      ,s 
                    sta      VIA_port_a                   ; store data for PSG write 
                    bsr      ser_txbit                    ; transmit data bit [1] 
sertx_next 
                    dec      1,s                          ; decrement loop counter 
                    bne      sertx_loop                   ; loop if more bits to send 
                    lda      ,s 
                    sta      VIA_port_a                   ; store data for PSG write 
                    bsr      ser_txbit                    ; tansmit stop bit [1] 
                    lda      #$18 
                    sta      VIA_aux_cntl                 ; T1 = single-shot, no output on RAMP (PB7) 
                    ldd      #$0200 
                    std      VIA_t1_cnt_lo                ; force T1 timeout 
                    lda      #$98 
                    sta      VIA_aux_cntl                 ; T1 = single-shot, RAMP output (PB7) enabled 
                    leas     3,s                          ; restore stack 
                    rts      

ser_txbit 
                    lda      #$40 
sertxbit_loop 
                    bita     VIA_int_flags                ; test T1 interrupt flag 
                    beq      sertxbit_loop                ; loop until T1 timeout 
                    lda      #$91                         ; (BC1 + BDIR = 10) 
                    sta      VIA_port_b                   ; enable PSG register write 
                    stb      VIA_port_b                   ; latch data (BC1 + BDIR = 00)
                    lda      VIA_t1_cnt_lo                ; clear T1 interrupt flag 
                    rts      

                    direct   -1 
