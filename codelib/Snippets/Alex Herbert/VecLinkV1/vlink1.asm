; Note:
; This is a disassembly of a binary file I got from a fellow vectrexian.
; The original file was programmed by Alex Herbert
;
; I was assured that Alex had given is consent in making the file available, 
; but sadly I had never the opportunity to get in contact with Alex himself.
; 
; Alex: if you do not wish to share this file, please contact me and I will remove it.
;
;
; veclink V1 in Port 1
; button 4 (bit 7) is triggering a VIA interrupt (CA1)
; which is used to synchronize the communication
; with button 4 connected one vectrex can trigger an interrupt on the other
; the actual data is transported
; via bit 5 and 6 (on what I call the primary vectrex) (Port 1: Button 2 and 3)
; via bit 4 and 5 (on what I call the secondary vectrex) (Port 1: Button 1 and 2)
; a quarter of a parallel connection :-)
; the communication seems to be "bi" directional
; sending and data sets CA1, the other side waits for CA1
; and immediately sorts out the data of the 2 bits
; and with acknowledgment sends its own data back... and so forth
;
; cable schematics:
;
;Vectrex A                Vectrex B
;1 |--------------------------| 4
;      |
;      |
;      >
;     <   680 Ohm Resistor
;      >
;     <
;      |
;      |
;8 |--------------------------| 8
;      |
;      |
;      >
;     <   680 Ohm Resistor
;      >
;     <
;      |
;      |
;4 |--------------------------| 3
;2 |--------------------------| 1
;3 |--------------------------| 2
;
;
; Additional information that was made available to me:
; (quotation)
; "
; According To the information I have received from Alex Herbert there are several versions of the cable.
; Depending on which of Alex's libraries you use the following will be true.
; Earlier version of the cable. The I/O on pin 4 is harder to drive than pins 1,2,3 so the pull up resistors 
; were used to try and correct the voltage levels, but - even then it was still iffy.
;  
; The new cable just avoids this by not using pin 4. It means we have 1 less pin for data which should in theory 
; reduce the maximum bandwidth, but I was able to optimize it quite well and didn't loose much performance. 
;  
; This cable has been performing rock solid. 
;"
; 
; 
; Malban - Thoughts:
; Since I have no cable of my own, I can't do any further tests.
;
; The "linkage" routines below do sort of work (most of the time)
; as reported by Alex:
;    "...Earlier version of the cable. The I/O on pin 4 is harder to drive than pins 1,2,3 so the pull 
;     up resistors were used to try and correct the voltage levels, but even then it was still iffy."
;
; The linkage thus seems to be not to stable.
; Emulation of the above cable also results sometimes in "broken" links - I regard that mostly as
; syncing problems of two emulators running in two different threads, but I can't help to wonder...
;
; examining the core communication routine, I noticed the:
;
;                    ora      #$80                         
;
; with every data transfer that is done, my first guess was, that setting the high bit 
; should set the CA1 on the other vectrex to do the actual syncing. 
; (this is what my old comments still state - but this is WRONG!)
;
; BUT the cable (look above) is "crossed", so setting bit 4 on the one vectrex which is 
; sending data does not achieve any CA1 interrupt on the other side.
; Setting bit 4 on the primary vectrex will result in bit 3 of the secondary vectrex
; while setting bit 4 on the secondary vectrex will result in bit 1 being set on the primary. 
; (all bits in regard to above picture, not the actual bits of port A of PSG)
;
; So - Question:             Is the below given communication routine actually buggy?
; or
; Question alternative:      What am I missing?
;
; Tentive answer from Malban:
; My guess is, that the ora $80 are left overs from an "older" example routine and an even older veclink cable (v0.9?).
; The actual syncing is done in "JoytickFFCommunication_A", which sends "$ff" to the other vectrex, which inherently obviously
; will set the CA1 flag, since all bits receive a 1.
; This theory is backed up by the fact that you can comment out all of the ora $80 and the routine still works
; equally well (or not well in the case of a slow emulator)
;
                    include  "VECTREX.I"
S_INTENSITY         equ      2 
S_XPOS              equ      1 
S_YPOS              equ      0 
intensityIndexNibble  EQU    $C826                        ; low byte of "Vec_Loop_Count", this counter is increased 
                                                          ; with every call WaitRecal, it is used below as an 
                                                          ; offset for intensity levels of the "you" sign 
statusFlag          EQU      $C880                        ; negative = link not established, 0 = I am primary, 1 = I am secondary 
;
primary_structure   EQU      $C881                        ; 3 bytes 
primary_pos         EQU      $C881 
primary_y           EQU      $C881 
primary_x           EQU      $C882 
primary_intensity   EQU      $C883 
;
secondary_structure  EQU     $C884                        ; 3 bytes 
secondary_pos       EQU      $C884 
secondary_y         EQU      $C884 
secondary_x         EQU      $C885 
secondary_intensity  EQU     $C886 
;
joy_y               EQU      $C887                        ; contains digital joytick position Y, +1 = up, -1 = down, 0 = no move 
joy_x               EQU      $C888                        ; contains digital joytick position X, +1 = right, -1 = left, 0 = no move 
jumper              EQU      $C889                        ; contains indirect jump addresses used in main loop 
_CBF0               EQU      $CBF0                        ; have not figured out what this is... 
; GCS Copyright
                    DB       "g GCE     ", $80            ; it seems communication VLinkCable is done via
; Start music pointer
Copyright_Len: 
                    DW       no_music                     ; Start music pointer 
; end of header
                    DB       $00                          ; end of header 
; start of cartridge code!
                    jmp      >start                       ; start of cartridge code! 

no_music: 
                    DB       $00, $00, $00, $00, $00, $80 
                    direct   $D0 
; this routine syncs 3 bytes *2 (both structures) (actually the number of bytes between primary_structure and secondary_structure)
; while doing the syncing the link is continually tested if it still in working order
; this routine also sets the status flag of the link connection
; negative = link not established, 0 = I am primary, 1 = I am secondary
syncVectrex_3bytes: 
                    lda      #$D0                         ; setup DP 
                    tfr      a,dp 
                    direct   $D0 
                    ldx      #primary_structure           ; reading and writing from the view of primary vectrex 
                    ldy      #secondary_structure         ; read data to this address [data original from secondary vectrex] 
                    lda      #$FF                         ; default status: link is broken (needed for a "hard" exit in the subroutines) 
                    sta      >statusFlag                  ; store the status of the connection 
                    jsr      >JoytickFFCommunication_A    ; sends a "ff" to the other vectrex and receives one "byte" - also tests the link 
                    pshs     a                            ; remember value got from joystick port 2 
                    lda      #$BF                         ; 1011 1111 test byte to look if we are primary or secondary 
                                                          ; upper bit 3 is "cross"-connected to either bit 2 or 4, the later triggers a CA1 
                                                          ; examining the result tells us if we are secondary or primary 
                    jsr      >write_A_toJoy2              ; tell the other vectrex 
                    lda      #$18                         ; 0001 1000 ; SHIFT mode = 110 - SHIFT out under control of system clock 
                    sta      <VIA_aux_cntl                ; (bit 6+7 = 00) timer one shot mode ramp not controlled by bit 7 of VIA B 
                    puls     a                            ; get last read value from joystick port 
                    bita     #$80                         ; (equal to CA1 interrupt) 
                    beq      otherWasFound                ; if bit 7 is set, branch [other vectrex was already found] 
                    ldd      #$FFFF                       ; wait a "long time" for other vectrex 
                    jsr      >wait_CA1_Timer_D            ; if return happens we found a vectrex, 
                                                          ; if there is NO return, than the subroutine 
                                                          ; went straight ahead to "our" caller and the next instruction is never reached! 
otherWasFound: 
                                                          ; send ff and read one "byte" 
                    jsr      >JoytickFFCommunication_A    ; if vectrex is not found, the subroutine returns directly 
                    anda     #$F0                         ; only bits of port 2 
                    cmpa     #$70                         ; upper halfbyte ($f0) without CA1 ($80) 
                                                          ; this is the "examining" of the "#$BF" that was send from the other side... 
                                                          ; if we recieved x000 xxxx (from the sent 1011 xxxx), than we are primary 
                                                          ; if not, than we are secondary 
                    lbne     secondaryVectrexCommunication 
                    lda      #$8F                         ; $1000 1111, triger CA1 on other vectrex, 000 data, 1111 "buttons" of joy 1 (ignore) 
; we are primary!
; which puts the other vectrex as secondary
; receive bit 7 and 6 [rr00 0000] (and send nothing)
                    jsr      >write_A_toJoy2              ; the other vectrex receives a 000 as data, which will be "ignored" 
next_byte_communication: 
                    jsr      >wait_CA1_Timer_01ff 
                    jsr      >JoytickFFCommunication_A 
; only bit 5 and 6 contain data
                    anda     #$60                         ; from data 
                    asla                                  ; 0xx0 0000 -> xx00 0000, correct bit position 
                    sta      ,y                           ; store received upper two bits in y 
; load data to transport
                    lda      ,x                           ; to data 
                    lsra                                  ; put bits to 5 and 6 xx00 0000 -> 0xx0 0000 
                    anda     #$60                         ; only bit 5 and 6 contain data 
                    ora      #$80                         ; = bit 7 (CA1 of other vectrex) 
; receive bit 5 and 4 [00rr 0000]
                    jsr      >write_A_toJoy2              ; send bit 7 and 6 [ww00 0000] 
                    jsr      >wait_CA1_Timer_01ff 
                    jsr      >JoytickFFCommunication_A 
                    anda     #$60                         ; only bit 5 and 6 contain data 
                    lsra                                  ; 0xx0 0000 -> 00xx 0000, correct bit position 
                    ora      ,y                           ; and combine the two bits with already received data 
                    sta      ,y                           ; write data 
                    lda      ,x                           ; get next data to be sent 
                    asla                                  ; put bits to 5 and 6 00xx 0000 -> 0xx0 0000 
                    anda     #$60                         ; only bit 5 and 6 contain data 
                    ora      #$80                         ; = bit 7 (CA1 of other vectrex) 
; receive bit 3 and 2 [0000 rr00]
                    jsr      >write_A_toJoy2              ; send bit 5 and 4 [00ww 0000] 
                    jsr      >wait_CA1_Timer_01ff 
                    jsr      >JoytickFFCommunication_A 
                    anda     #$60                         ; only bit 5 and 6 contain data 
                    lsra     
                    lsra     
                    lsra                                  ; 0xx0 0000 -> 0000 xx00, correct bit position 
                    ora      ,y                           ; and combine the two bits with already received data 
                    sta      ,y                           ; write data 
                    lda      ,x                           ; get next data to be sent 
                    asla     
                    asla     
                    asla                                  ; put bits to 5 and 6 0000 xx00 -> 0xx0 0000 
                    anda     #$60                         ; only bit 5 and 6 contain data 
                    ora      #$80                         ; = bit 7 (CA1 of other vectrex) 
; receive bit 1 and 0 [0000 00rr]
                    jsr      >write_A_toJoy2              ; send bit 3 and 2 [0000 ww00] 
                    jsr      >wait_CA1_Timer_01ff 
                    jsr      >JoytickFFCommunication_A 
                    anda     #$60                         ; only bit 5 and 6 contain data 
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    lsra                                  ; 0xx0 0000 -> 0000 00xx, correct bit position 
                    ora      ,y                           ; and combine the two bits with already received data 
                    sta      ,y+                          ; write data, inc y 
                    lda      ,x+                          ; get next data to be sent, inc x 
                    asla     
                    asla     
                    asla     
                    asla     
                    asla                                  ; put bits to 5 and 6 0000 00xx -> 0xx0 0000 
                    anda     #$60                         ; only bit 5 and 6 contain data 
                    ora      #$80                         ; = bit 7 (CA1 of other vectrex) 
; (also receive bit 7 and 6 [rr00 0000] - if any avalable)
                    jsr      >write_A_toJoy2              ; send bit 1 and 0 [0000 00ww] 
; (3 bytes)
                    cmpx     #secondary_structure         ; did we finish sending all data? 
                    bne      next_byte_communication      ; no, than go on sending 
                    inc      >statusFlag                  ; dont know, indicator second primary? 
                    jsr      >wait_CA1_Timer_01ff         ; one last sync for good will? 
                    jsr      >JoytickFFCommunication_A 
                    ldd      #$0200                       ; restore some sensible timer settings? 
                    std      <VIA_t1_cnt_lo               ; VIA timer lo -> hi 
                    lda      #$98                         ; clean up aux VIA register 
; (bit 6+7 = 10) timer one shot mode ramp controlled by bit 7 of VIA B
                    sta      <VIA_aux_cntl                ; 1001 1000 SHIFT mode = 110 - SHIFT out under control of system clock 
                    rts                                   ; done 

; a) read and write addresses are switched
; b) for data transport bit 4 and 5 are used instead of 5 and 6
; send bit 7 and 6 [ww00 0000]
; receive bit 7 and 6 [rr00 0000]
; load data to transport
secondaryVectrexCommunication: 
                    lda      ,y                           ; secondary communication has two quirks 
                    lsra                                  ; put bits to 4 and 5 xx00 0000 -> 00xx 0000 
                    lsra     
                    anda     #$30                         ; only bit 4 and 5 contain data 
                    ora      #$80                         ; = bit 7 (CA1 of other vectrex) 
                    jsr      >write_A_toJoy2 
                    jsr      >wait_CA1_Timer_01ff 
                    jsr      >JoytickFFCommunication_A 
                    anda     #$30                         ; only bit 4 and 5 contain data 
                    asla     
                    asla                                  ; 00xx 0000 -> xx00 0000, correct bit position 
                    sta      ,x                           ; store received upper two bits in x 
; receive bit 5 and 4 [00rr 0000]
; get next data to be sent
                    lda      ,y                           ; send bit 5 and 4 [00ww 0000] 
                    anda     #$30                         ; only bit 4 and 5 contain data 
                    ora      #$80                         ; = bit 7 (CA1 of other vectrex) 
                    jsr      >write_A_toJoy2 
                    jsr      >wait_CA1_Timer_01ff 
                    jsr      >JoytickFFCommunication_A 
                    anda     #$30                         ; only bit 4 and 5 contain data 
                    ora      ,x                           ; and combine the two bits with already received data 
                    sta      ,x                           ; write data 
; receive bit 3 and 2 [0000 rr00]
; get next data to be sent
                    lda      ,y                           ; send bit 3 and 2 [0000 ww00] 
                    asla     
                    asla                                  ; put bits to 4 and 5 0000 xx00 -> 00xx 0000 
                    anda     #$30                         ; only bit 4 and 5 contain data 
                    ora      #$80                         ; = bit 7 (CA1 of other vectrex) 
                    jsr      >write_A_toJoy2 
                    jsr      >wait_CA1_Timer_01ff 
                    jsr      >JoytickFFCommunication_A 
                    anda     #$30                         ; only bit 4 and 5 contain data 
                    lsra     
                    lsra                                  ; 00xx 0000 -> 0000 xx00, correct bit position 
                    ora      ,x                           ; and combine the two bits with already received data 
                    sta      ,x                           ; write data 
; receive bit 1 and 0 [0000 00rr]
; get next data to be sent, and inc y
                    lda      ,y+                          ; send bit 1 and 0 [0000 00ww] 
                    asla     
                    asla     
                    asla     
                    asla                                  ; put bits to 4 and 5 0000 00xx -> 00xx 0000 
                    anda     #$30                         ; only bit 4 and 5 contain data 
                    ora      #$80                         ; = bit 7 (CA1 of other vectrex) 
                    jsr      >write_A_toJoy2 
                    jsr      >wait_CA1_Timer_01ff 
                    jsr      >JoytickFFCommunication_A 
                    anda     #$30                         ; only bit 4 and 5 contain data 
                    lsra     
                    lsra     
                    lsra     
                    lsra                                  ; 0000 00xx -> 0000 xx00, correct bit position 
                    ora      ,x                           ; and combine the two bits with already received data 
                    sta      ,x+                          ; write data, inc x 
; (3 bytes)
                    cmpx     #secondary_structure         ; did we finish sending all data? 
                    bne      secondaryVectrexCommunication 
                    lda      #$80                         ; = bit 7 (CA1 of other vectrex) 
                    jsr      >write_A_toJoy2              ; one last sync for good will? 
                    jsr      >JoytickFFCommunication_A 
                    neg      >statusFlag                  ; dont know, indicator second primary? 
                    ldd      #$0200                       ; restore some sensible timer settings? 
                    std      <VIA_t1_cnt_lo               ; VIA timer1 lo -> hi 
; VIA timer 2 lo -> hi ???
                    std      <VIA_t2_lo                   ; what is that for? 
; (bit 6+7 = 10) timer one shot mode ramp controlled by bit 7 of VIA B
; clean up aux VIA register
                    lda      #$98                         ; 1001 1000 SHIFT mode = 110 - SHIFT out under control of system clock 
                    sta      <VIA_aux_cntl 
                    rts      

; with timeout after 0x01ff cylces
wait_CA1_Timer_01ff: 
                    ldd      #$FF01                       ; wait for interrupt CA1 
; with timeout given in D (Timer 16 bit)
; init timer
; store given parameter to A to timer 1 low [latch (reg 6 is written]
; B to timer 1 high [latch reg 6 is transfered to reg 4]
; B is also transfere3d to reg 7 high latch
; resets interrupt flag
; store timer values
wait_CA1_Timer_D: 
                    std      <VIA_t1_cnt_lo               ; wait for interrupt CA1 
                    ldd      #$0240                       ; interrupt test flags 
vl_test0155: 
                    bitb     <VIA_int_flags               ; test interrupt flag register ($d) for #$40 (Timer 1) 
                    bne      vl_test0160                  ; if = -> branch, timeout was reached 
                    bita     <VIA_int_flags               ; test interrupt flag register ($d) for #$02 (CA1) 
; connecting another vectrex one can thus
; generate an interupt from that other vectrex via joystick port
; if CA1 interrupt not detected  - go on trying
                    beq      vl_test0155                  ; CA1 is connected to Joystick Port 2 Button 4 
; clear 0x02 to VIA interrupt flag register by writing 1
                    sta      <VIA_int_flags               ; CA1 interrupt was detected 
                    rts                                   ; go back 

; clean up aux VIA register
vl_test0160: 
                    lda      #$98                         ; timeout happened 
; (bit 6+7 = 10) timer one shot mode ramp controlled by bit 7 of VIA B
                    sta      <VIA_aux_cntl                ; 1001 1000 SHIFT mode = 110 - SHIFT out under control of system clock 
                    puls     a,b,pc                       ; is this a double RTS? go back 2 subroutine calls? 
; write value to joystick port 2 (buttons)
; Port A of PSG is kept in OUTPUT mode
; store given value on stack
write_A_toJoy2: 
                    sta      <<-$01,s                     ; value given in A 
; Register 7 of PSG
                    lda      #7                           ; Latch Reg $07 of PSG 
                    sta      <VIA_port_a                  ; VIA A = 0x07 (DAC) 
                    ldd      #$9981 
                    sta      <VIA_port_b                  ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
; $7f to VIA A (DAC) $7f = 0111 1111, disable all noise and tone in psg,
                    lda      #$7F                         ; write value of $7f to reg $07 (latched) 
; $7f to VIA A (DAC)
                    sta      <VIA_port_a                  ; ENABLE OUTPUT on port A of PSG (port B irrelevant since it is a 8912) 
                    ldd      #$9181 
                    sta      <VIA_port_b                  ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    lda      #$0E                         ; Latch Reg $E of PSG (Port A) 
                    sta      <VIA_port_a                  ; $0e to VIA A (DAC) 
                    ldd      #$9981 
                    sta      <VIA_port_b                  ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
; read value from stack
                    lda      <<-$01,s                     ; write A to port 
                    sta      <VIA_port_a                  ; output value to via VIA port A to Port A of PSG (Joystick buttons) 
                    ldd      #$9181 
                    sta      <VIA_port_b                  ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    rts      

; setup joyport communication
; sends $ff to Joystick 2
; $ff inherently has bit 7 set, which also triggers CA1 on other vectrex
; and reads afterwards joystick port 2
; value of read is kept in A
; PSG port A is kept in INPUT mode
; Latch Reg $07 of PSG
; Register 7 of PSG
JoytickFFCommunication_A: 
                    lda      #7 
                    sta      <VIA_port_a                  ; VIA A = 0x07 (DAC) 
                    ldd      #$9981 
                    sta      <VIA_port_b                  ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
; $3f to VIA A (DAC) $3f = 0011 1111, disable all noise and tone in psg,
                    lda      #$3F                         ; write value of $3f to reg $07 (latched) 
                    sta      <VIA_port_a                  ; enable INPUT on port A of PSG (port B irrelevant since it is a 8912) 
                    ldd      #$9181 
                    sta      <VIA_port_b                  ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    lda      #$0E                         ; Latch Reg $E of PSG (Port A) 
                    sta      <VIA_port_a                  ; $0e to VIA A (DAC) 
                    ldd      #$9981 
                    sta      <VIA_port_b                  ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    lda      #$FF                         ; write value of $ff to reg $0e (latched) 
                    sta      <VIA_port_a                  ; write $ff to VIA A (DAC) 
                    ldd      #$9181 
                    sta      <VIA_port_b                  ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    ldd      #$0089 
                    sta      <VIA_DDR_a                   ; configure VIA A as input (all zeroes 0) 
                    stb      <VIA_port_b                  ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG) 
                    ldb      #$81 
                    lda      <VIA_port_a                  ; read value to a from VIA A, which in turn reads Port A of PSG 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    ldb      #$FF 
                    stb      <VIA_DDR_a                   ; configure VIA A as output (all zeroes 1) 
                    rts      

start: 
                    lda      #$D0                         ; set up direct page to d0 for the complete "game" 
                    tfr      a,dp 
                    direct   $D0 
                    lda      #$20                         ; load a space and store it to... 
                    sta      >_CBF0                       ; not used? CBF0 is part of the BIOS highscore setting 
                    bsr      init_jumper                  ; init main subroutine to "init" 
main_loop: 
                    clra                                  ; the last thing done in the mainloop "last round" was a draw 
                    sta      >VIA_shift_reg               ; this must be finished here with a mov 0 to SHIFT (switch the beam off) 
                    jsr      >Wait_Recal                  ; recalibrate 
                    jsr      >queryInputPort0             ; query input devices (port 0) 
                    jsr      >syncVectrex_3bytes          ; sync 3 bytes TO other player and 3 bytes from other player, also sets link status 
                    jsr      [>jumper]                    ; go to the current main routine (one of: "no link" (or "init"), "primary", "secondary") 
                    bra      main_loop                    ; and repeat that forever 

; each time the link cable is "faulty" (connection is lost)
; this routine is called (or upon startup)
; this sets the main "subroutine" to "init"
init_jumper: 
                    ldd      #init_vars_main              ; in the first update round (or link is broken), initialize 
                    std      >jumper                      ; the "main" subroutine is init the player vars (which also is "no link") 
                    rts      

; this routine sets up player vars (position, intensity...)
; checks the current link status
; and sets the main "subroutine" (jumper) according to the link status
; each player structure consists of 3 bytes
; ypos, xpos, intensity
; the first three "word" moves, fill both player structures
init_vars_main: 
                    ldd      #$00C0                       ; position of primary player (y,x) 
                    std      >primary_pos 
                    ldd      #$4F00                       ; primary intensity and secondary y 
                    std      >primary_intensity 
                    ldd      #$404F                       ; secondary x and secondary intensity 
                    std      >secondary_x 
; check current connection state
                    lda      >statusFlag 
                    bmi      no_link                      ; if negative no link was found 
                    bne      we_are_secondary             ; if positive (1) jump, we are secondary 
                    ldd      #primary_main                ; we are primary, load our main routine and store it 
                    std      >jumper                      ; to the indirect jump table 
                    rts      

we_are_secondary: 
                    ldd      #secondary_main              ; we are secondary, load our main routine and store it 
                    std      >jumper                      ; to the indirect jump table 
                    rts      

;"main" loop entry if link is broken,
; this is accessed "directly" from "init_vars_main"
; not thru a jumper
; this is an "endpoint" of the jumper call to init_vars_main and is 
; exited with a jump to a subroutine, which returns correctly to the main loop (saving a few cycles)
no_link: 
                    lda      #$D0                         ; setup DP 
                    tfr      a,dp 
                    direct   $D0 
                    jsr      >Reset0Ref                   ; reset vector beam 
                    lda      #$3F                         ; set intensity 
                    jsr      >Intensity_a                 ; to $3f 
                    ldd      #$10E0                       ; move to a position 
                    jsr      >Moveto_d_7F 
                    lda      #$0F                         ; set a low scaling factor 
                    sta      <VIA_t1_cnt_lo               ; (timer 1 is scaling) 
                    ldu      #no_link_string              ; load the vector representation of "no link" to U 
                    jmp      >draw_vector_list            ; and draw that -> and exit subroutine to main 

; drawing the "you" at the right position
; players are actually drawn with the "same" routine (no differentiation between primary and secondary)
primary_main: 
                    lda      >statusFlag                  ; ensure link is still valid 
                    bne      init_jumper                  ; if not, jump to init (must be 0 for primary) 
                    lda      #$D0                         ; setup DP 
                    tfr      a,dp 
                    direct   $D0 
                    jsr      >Reset0Ref                   ; reset vector beam 
                    ldx      #intensity_blink             ; intensity of "you" string offset table 
                    lda      >intensityIndexNibble        ; load waitRecal counter as an offset 
                    lsra                                  ; divide by two 
                    anda     #$0F                         ; and only use the lower nibble 
                    lda      a,x                          ; as an offset index to the "blink" intensities 
                    jsr      >Intensity_a                 ; set intensity 
                    ldx      #primary_structure           ; x = current used player structure 
                    bsr      check_input_port0            ; get current input readings (joystick and buttons), and set D to POS of player 
                    jsr      >Moveto_d_7F                 ; move "cursor" to that position 
                    lda      #$09                         ; set a low scaling factor 
                    sta      <VIA_t1_cnt_lo               ; (timer 1 is scaling) 
                    ldu      #you                         ; load pointer of vectorlist "you" to U 
                    jsr      >draw_vector_list            ; and output it at the current position 
                    bra      draw_players                 ; draw the player "signs" 

; drawing the "you" at the right position
; players are actually drawn with the "same" routine (no differentiation between primary and secondary)
secondary_main: 
                    lda      >statusFlag                  ; ensure link is still valid 
                    cmpa     #$01                         ; must be 1 for secondary 
                    bne      init_jumper                  ; if not, jump to init 
                    lda      #$D0                         ; setup DP 
                    tfr      a,dp 
                    direct   $D0 
                    jsr      >Reset0Ref                   ; reset vector beam 
                    ldx      #intensity_blink             ; intensity of "you" string offset table 
                    lda      >intensityIndexNibble        ; load waitRecal counter as an offset 
                    lsra                                  ; divide by two 
                    anda     #$0F                         ; and only use the lower nibble 
                    lda      a,x                          ; as an offset index to the "blink" intensities 
                    jsr      >Intensity_a                 ; set intensity 
                    ldx      #secondary_structure         ; x = current used player structure 
                    bsr      check_input_port0            ; get current input readings (joystick and buttons), and set D to POS of player 
                    jsr      >Moveto_d_7F                 ; move "cursor" to that position 
                    lda      #$09                         ; set a low scaling factor 
                    sta      <VIA_t1_cnt_lo               ; (timer 1 is scaling) 
                    ldu      #you                         ; load pointer of vectorlist "you" to U 
                    jsr      >draw_vector_list            ; and output it at the current position 
                    bra      draw_players                 ; draw the player "signs" 

; in x is the player structure given
; apply the current input to the given player structure
; digital joystick movements (filled before) are represented 
; by +1, 0, -1 (for vertical and horizontal joystick positions) 
; button states are respected and applied (intensity change of pressed or released)
; exits with D filled with position of player
check_input_port0: 
; first
; check the button state of port 0
; if any button is pressed, intensity in the player structure is decreased (not below 0)
; if no button is pressed it is increased (not above intensity $4f)
                    lda      >Vec_Btn_State               ; load current button state 
                    bita     #$0F                         ; test for any button of port 0 (mask: 0000 1111) 
                    beq      increase_intensity 
                                                          ; decrease intensity if no button was pressed 
                    lda      <<S_INTENSITY,x              ; load current intensity 
                    beq      check_digital_pos            ; check if already zero, if yes, just go on 
                    deca                                  ; if not - decrease it 
                    sta      <<S_INTENSITY,x              ; and store it in the player structure 
                    bra      check_digital_pos            ; go on 

increase_intensity: 
                    lda      <<S_INTENSITY,x              ; load current intensity 
                    cmpa     #$4F                         ; check if maxed 
                    bcc      check_digital_pos            ; if yes - go on 
                    inca                                  ; if not increase 
                    sta      <<S_INTENSITY,x              ; and store it 
check_digital_pos: 
                    ldd      >joy_y                       ; load the last got joystick vertical/horizontal values to D[Y,X] (0,-1 or 1)) 
                    asla                                  ; double Y (contains now -2, 0 or +2) 
                    adda     ,x                           ; add to that value the current Y pos from player structure 
                    aslb                                  ; do the same with x: double X (contains now -2, 0 or +2) 
                    addb     <<S_XPOS,x                   ; add to that value the current X pos from player structure 
                    std      ,x                           ; and store the result back to the player structure 
                    rts                                   ; leaving with d set to the position Y, X 

draw_players: 
                    jsr      >Reset0Ref                   ; reset vector beam 
                    lda      >primary_intensity           ; get intensity of primary 
                    jsr      >Intensity_a                 ; set that intensity 
                    ldd      >primary_pos                 ; load the primary position 
                    jsr      >Moveto_d_7F                 ; move there 
                    lda      #$3F                         ; load a "medium" scale value 
                    sta      <VIA_t1_cnt_lo               ; and set it (timer 1 is scaling) 
                    ldu      #triangle                    ; for primary load the trianlge vectorlist 
                    jsr      >draw_vector_list            ; and draw it 
                    jsr      >Reset0Ref                   ; repeat the above for secondary player, - reset vector beam 
                    lda      >secondary_intensity         ; get intensity of secondary 
                    jsr      >Intensity_a                 ; set that intensity 
                    ldd      >secondary_pos               ; load the secondary position 
                    jsr      >Moveto_d_7F                 ; move there 
                    lda      #$3F                         ; load a "medium" scale value 
                    sta      <VIA_t1_cnt_lo               ; and set it (timer 1 is scaling) 
                    ldu      #diamond                     ; for secondary load the diamond vectorlist 
                    jsr      >draw_vector_list            ; and draw it 
                    rts                                   ; done 

; expects pointer to a vector list in U
; format of vector list is: %Y %X %M (delta Y, delta X, mode)
; mode: $80 = end
;       anything else = pattern
draw_vector_list: 
                    lda      ,u+                          ; load Y delta to A 
display_next_vector: 
                    sta      <VIA_port_a                  ; store to DAC 
                    clr      <VIA_port_b                  ; clr port B (mux enabled, mux sel = y) -> thus integrator Y will update with Y delta 
                    pulu     a,b                          ; get X delta to A and pattern to B 
                    inc      <VIA_port_b                  ; disable mux 
                    sta      <VIA_port_a                  ; set X delta to A 
                    clra                                  ; 
; I think Alex is doing a trick here
; to prevent the "dotting" of vectors 
; when being displayed 
; usually the light is switched ON too soon, this might prevent that (a little)
                    andb     #$1F                         ; shorten the pattern by 3 upper bits (6 cycles are still "blank") [1 shift needs 2 cpu cycles] 
                                                          ; as long, as bit 0 is 1 at the end of the complete shift cycle, the line will be displayed 
                                                          ; correctly, I wonder what appears on screen if bit 0 of the pattern is 0, than probably 
                                                          ; only the beginning and the end of the line is shown 
                    stb      <VIA_shift_reg               ; put that configured pattern to shift, shifting starts 
                    sta      <VIA_t1_cnt_hi               ; start the timer (this instruction takes exactly 6 cycles - this is the above done offset!) 
                    ldb      <<-$01,u                     ; load the un altered pattern to b 
                    andb     #$F0                         ; and patch that also (upper 4 bits only) 
                                                          ; I don't know what patching the "switch of" shift really accomplishes 
                                                          ; since RAMP will be disabled by the timer, and shift will still be on for to long... 
                    lda      #$40                         ; test bit for timer 1 
timerLoop: 
                    bita     <VIA_int_flags               ; test if timer has run out 
                    beq      timerLoop                    ; if timer is still counting down - continue 
                    stb      <VIA_shift_reg               ; store the "other" side of the patched pattern to shiftreg 
                    lda      ,u+                          ; load net pattern byte 
                    cmpa     #$80                         ; if == $80 we finished with our vector list 
                    bne      display_next_vector          ; if not - display next vector 
                    rts      

triangle:                                                 ;        triangle list in format: %Y %X %M 
                    DB       $14, $00, $00 
                    DB       $D8, $14, $FF 
                    DB       $00, $D8, $FF 
                    DB       $28, $14, $FF 
                    DB       $80 
diamond:                                                  ;        diamond list in format: %Y %X %M 
                    DB       $14, $00, $00 
                    DB       $EC, $14, $FF 
                    DB       $EC, $EC, $FF 
                    DB       $14, $EC, $FF 
                    DB       $14, $14, $FF 
                    DB       $80 
you:                                                      ;        text "YOU" in format: %Y %X %M 
                    DB       $60, $7F, $00 
                    DB       $F0, $E0, $FF 
                    DB       $F0, $20, $FF 
                    DB       $F0, $38, $00 
                    DB       $20, $00, $FF 
                    DB       $20, $E0, $FF 
                    DB       $E0, $20, $00 
                    DB       $20, $20, $FF 
                    DB       $00, $18, $00 
                    DB       $00, $40, $FF 
                    DB       $C0, $00, $FF 
                    DB       $00, $C0, $FF 
                    DB       $40, $00, $FF 
                    DB       $00, $58, $00 
                    DB       $C0, $00, $FF 
                    DB       $00, $40, $FF 
                    DB       $40, $00, $FF 
                    DB       $80 
no_link_string:                                           ;        text "NO LINK" in format: %Y %X %M 
                    DB       $40, $00, $FF 
                    DB       $C0, $40, $FF 
                    DB       $40, $00, $FF 
                    DB       $00, $10, $00 
                    DB       $00, $40, $FF 
                    DB       $C0, $00, $FF 
                    DB       $00, $C0, $FF 
                    DB       $40, $00, $FF 
                    DB       $00, $78, $00 
                    DB       $C0, $00, $FF 
                    DB       $00, $40, $FF 
                    DB       $00, $10, $00 
                    DB       $40, $00, $FF 
                    DB       $C0, $10, $00 
                    DB       $40, $00, $FF 
                    DB       $C0, $40, $FF 
                    DB       $40, $00, $FF 
                    DB       $00, $10, $00 
                    DB       $C0, $00, $FF 
                    DB       $00, $40, $00 
                    DB       $20, $C0, $FF 
                    DB       $20, $40, $FF 
                    DB       $80 
; query joystick buttons
; joytick pot readings are also switched by the (de)muliplexer (analog section)
; with joystick pots the switching is not done in regard of the output (in opposite to "input" switching of integrator logic)
; but with regard to input
; thus, the SEL part of the mux now selects which joystick pot is selected and send to the compare logic.
; mux sel:
;    xxxx x00x: port 0 horizontal
;    xxxx x01x: port 0 vertical
;    xxxx x10x: port 1 horizontal
;    xxxx x11x: port 1 vertical
; 
; the result of the pot reading is compared to the 
; value present in the dac and according to the comparisson the compare flag of VIA (bit 5 of port b) is set.
; (compare bit is set if contents of dac was "smaller" (signed) than the "pot" read)
queryInputPort0: 
                    lda      #$D0                         ; setup DP 
                    tfr      a,dp 
                    direct   $D0 
                    jsr      >Read_Btns                   ; read joystick buttons and set the result to BIOS RAM location (Vec_Btn_State) 
                                                          ; reset integrator offsets 
                    lda      #$03                         ; mux disabled, mux sel = 01 (vertical pot port 0) 
                    sta      <VIA_port_b                  ; 
                    clr      <VIA_port_a                  ; dac = 0 
                    dec      <VIA_port_b                  ; mux enabled, mux sel = 01 
                    ldb      #$20                         ; a wait loop 32 times a loop (waiting for the pots to "read" values, and feed to compare logic) 
waitLoopV: 
                    decb                                  ; ... 
                    bne      waitLoopV                    ; wait... 
                    inc      <VIA_port_b                  ; disable mux 
                    ldb      #$20                         ; load b with comparator bit (0010 0000) 
                    lda      #$40                         ; load a with test value (positive y) 
                    sta      <VIA_port_a                  ; test value to DAC 
                    lda      #$01                         ; default result value y was pushed UP 
                    bitb     <VIA_port_b                  ; test comparator 
                    bne      yReadDone                    ; if comparator cleared - joystick was moved up 
                    neg      <VIA_port_a                  ; "load" with negative value 
                    nega                                  ; also switch the possible result in A 
                    bitb     <VIA_port_b                  ; test comparator again 
                    beq      yReadDone                    ; if cleared the joystick was moved down 
                    clra                                  ; if still not cleared, we clear a as the final vertical test result (no move at all) 
yReadDone: 
                    sta      >joy_y                       ; remember the result in "our" joystick data 
;
; now the same for horizontal
                    lda      #$01                         ; mux disabled, mux sel = 00 (horizontal pot port 0) 
                    sta      <VIA_port_b                  ; 
                    clr      <VIA_port_a                  ; dac = 0 
                    dec      <VIA_port_b                  ; mux enabled, mux sel = 01 
                    ldb      #$20                         ; a wait loop 32 times a loop (waiting for the pots to "read" values, and feed to compare logic) 
waitLoopH: 
                    decb                                  ; ... 
                    bne      waitLoopH                    ; wait... 
                    inc      <VIA_port_b                  ; disable mux 
                    ldb      #$20                         ; load b with comparator bit (0010 0000) 
                    lda      #$40                         ; load a with test value (positive x) 
                    sta      <VIA_port_a                  ; test value to DAC 
                    lda      #$01                         ; default result value x was pushed right 
                    bitb     <VIA_port_b                  ; test comparator 
                    bne      xReadDone                    ; if comparator cleared - joystick was moved right 
                    neg      <VIA_port_a                  ; "load" with negative value 
                    nega                                  ; also switch the possible result in A 
                    bitb     <VIA_port_b                  ; test comparator again 
                    beq      xReadDone                    ; if cleared the joystick was moved left 
                    clra                                  ; if still not cleared, we clear a as the final vertical test result (no move at all) 
xReadDone: 
                    sta      >joy_x                       ; remember the result in "our" joystick data 
                    rts                                   ; done 

; the "you" string is shown with different intensity levels
; this is an offset table to the intensities used (16) -> blinking
intensity_blink: 
                    DB       $27, $2B 
                    DB       $2F, $33 
                    DB       $37, $3B 
                    DB       $3F, $43 
                    DB       $47, $43 
                    DB       $3F, $3B 
                    DB       $37, $33 
                    DB       $2F, $2B 
