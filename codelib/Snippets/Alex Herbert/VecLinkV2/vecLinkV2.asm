; Note:
; This file is an example I put together from two different sources.
; a) the visible part is taken from the vecLink V1 test binary, which I also disassembled 
;    binaries/and commented disassembly available 
; b) The serial communication routines were taken from BerzerkArena, I disassembled the
;    relevant parts and put the routines in the example from a)
;
; BOTH original files were programmed by Alex Herbert
;
; I was assured that Alex had given is consent in making the file available, 
; but sadly I had never the opportunity to get in contact with Alex himself.
; 
; Alex: if you do not wish to share this file, please contact me and I will remove it.
;
;
; veclink V2 in Port 1
; The used transfer protocoll:
; The bits of port A used: 
; - bit 4 (control bit)    [button 1 of port 1] 
; - bit 5 (data bit) [button 2 of port 1] 
; - bit 6 (acknowledge bit) [button 3 of port 1] 
; Control bit
; Each byte is send in 4 "packages" of 2 bit. The first bit of such a package has the control 
; bit set to 0 (zero), the second bit in such a package has the control bit set to 1 (one).
; Data bit
; This bit - as the name implies - carries the one bit of data used in one "transfer" round.
; Acknowledge bit
; The receiving vectrex must send an acknowledgement "message" in which the bit 6 must be set.
; If any of the above is not true while the communication is done (actually there is a timer 
; which waits for the appropriate resonse, one byte must be transfered in $ffff cycles (T1 Timer)), 
; the communication is broken and a message is displayed.
; Special
; The complete "game" is played with PSG Port A set to output 
; (on both ends of the serial cable), the serial communication still works in both directions.
; Protocoll Higher Level
; One of the two vectrex must be the first, this is always the case :-).
; Primary vectrex:
; The first one obviously does not receive any data before. 
; If no data is received, than a "$4d" is sent. (bit 4 cleared, sign that we want to send data!)
; Secondary vectrex:
; The secondary vectrex receives the above mentioned "$4d" and responds with sending a "$73".
; If both above sendings and readings are aknowledged by both vectri, 
; the main routines are set (as in veclink V1 example) to primary and secondary routines.
; within those routines "syncVectrex_3bytes()" is called, which by a statusflag decides 
; whether it is called from primary or secondary and does the actual 3 byte sync accordingly.
;
; cable schematics:
; Vectrex A                Vectrex B
; 1 |--------------------------| 1
; 2 |--------------------------| 2
; 3 |--------------------------| 3
; 8 |--------------------------| 8
; All other pins MUST NOT be connected.
; (or damage to your Vectrexes is quite probable).
;
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
                    DB       "g GCE     ", $80            ; GCS Copyright
Copyright_Len: 
                    DW       no_music                     ; Start music pointer 
                    DB       $00                          ; end of header 
                    jmp      >start                       ; start of cartridge code! 

no_music: 
                    DB       $00, $00, $00, $00, $00, $80 
                    direct   $D0 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; called once only, leaves port A of PSG in output mode
; sets DP to d0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
serial_output_ff: 
                    lda      #$D0                         ; write $FF to joystickport, enable output on joystick port 
                    tfr      a,dp                         ; setup DP 
                    lda      #$0E                         ; A= $E reg 14 of PSG, 
                    sta      <VIA_port_a                  ; Via Port A = 14 
                    ldd      #$9981 
                    sta      <VIA_port_b                  ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    lda      #$FF                         ; Write $FF to joystick port(s) / PSG Port A ; -) 
                    sta      <VIA_port_a                  ; Fill via port A with $ff to be written to PSG port A to be written to Jostick buttons... 
                    lda      #$91 
                    sta      <VIA_port_b                  ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    lda      #$07                         ; 
                    sta      <VIA_port_a                  ; prepare latch of Reg 7 to PSG 
                    lda      #$99 
                    sta      <VIA_port_b                  ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    lda      #$FF                         ; Write $FF to Reg 7 of PSG -> enabled output via port A of PSG ; -) 
                    sta      <VIA_port_a                  ; Fill via port A with $ff to be written to PSG port A to be written to Jostick buttons... 
                    lda      #$91 
                    sta      <VIA_port_b                  ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    rts                                   ; done 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sends value in A to joyport serial communication
; dp is kept in original state
; if completed correctly:
; b=0, not 0 otherwise
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
serial_write_A: 
                    ldb      #$04                         ; number of "double bits" to send (4*2 = 8 -> complete byte), starting with least significant bit 
                    pshs     dp,b,a                       ; remember current DP, "$4" and A (push DP first, than b than a, s is pointing to the pushed copy of A) 
                    lda      #$D0                         ; setup DP 
                    tfr      a,dp 
                                                          ; prepare output to joystick, latch 14 to psg... 
                    ldd      #$0E99                       ; A= $E (reg 14, port A of PSG), B = $99 
                    sta      <VIA_port_a                  ; Via Port A = 14 
                    stb      <VIA_port_b                  ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address) 
                    ldd      #$1881                       ; B = $81 mask for BDIR/BC inactive, A=$18 0001 1000 ->SHIFT mode = 110 - SHIFT out under control of system clock 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                                                          ; disable ramping, while we use T1 for timeout checking... 
                    sta      <VIA_aux_cntl                ; SHIFT mode = 110 - SHIFT out under control of system clock, T1 does not control RAMP 
                                                          ; -), for the complete communication 
                    ldd      #$FFFF                       ; Realy long timer 
                    std      <VIA_t1_cnt_lo               ; to T1 
writeNextDoubleBit: 
                    lda      #$EF                         ; 1110 1111 port A default mask for bit set (bit 5), bit 4 = 0 indicates start of 2bit communication 
                    lsr      ,s                           ; test lowest bit of (pushed copy) of A 
                    bcs      outputBitMaskToPSG_start     ; if the bit was set -> branch 
                    lda      #$CF                         ; 1100 1111 port A default mask for bit clear (bit 5), bit 4 = 0 indicates start of 2bit communication 
outputBitMaskToPSG_start: 
                    sta      <VIA_port_a                  ; output current mask to psg 14 
                    ldd      #$9181 
                    sta      <VIA_port_b                  ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    clr      <VIA_DDR_a                   ; set via port A to input 
continueReadTry0: 
                    ldd      #$8981                       ; A = $89, B = $81 
                    sta      <VIA_port_b                  ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG) 
                    nop                                   ; delay ; -) 
                    lda      <VIA_port_a                  ; get value from buttons -> PSG port A -> Via port A -> to register A 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    bita     #$40                         ; check if we received a bit (in bit 6) 
                    beq      bit0SendSuccess              ; waiting to receive a 0 in bit 6 as acknowledgement of communication 
                    lda      #$40                         ; test for T1 timeout interrupt flag 
                    bita     <VIA_int_flags               ; check 
                    beq      continueReadTry0 
                    bra      linkTimeout 

bit0SendSuccess: 
                    com      <VIA_DDR_a                   ; switch Via port A to output 
                    lda      #$FF                         ; 1111 1111 port A default mask for bit set (bit 5), bit 4 = 1 indicates continue of 2bit communication 
                    lsr      ,s 
                    bcs      outputBitMaskToPSG_cont 
                    lda      #$DF                         ; 1101 1111 port A default mask for bit clear (bit 5), bit 4 = 1 indicates continue of 2bit communication 
outputBitMaskToPSG_cont: 
                    sta      <VIA_port_a                  ; output current mask to psg 14 
                    ldd      #$9181 
                    sta      <VIA_port_b                  ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    clr      <VIA_DDR_a                   ; set via port A to input 
continueReadTryX: 
                    ldd      #$8981                       ; A = $89, B = $81 
                    sta      <VIA_port_b                  ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG) 
                    nop                                   ; delay ; -) 
                    lda      <VIA_port_a                  ; get value from buttons -> PSG port A -> Via port A -> to register A 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    bita     #$40                         ; check if we received a bit (in bit 6) 
                    bne      bit1SendSuccess              ; waiting to receive a 0 in bit 6 as acknowledgement of communication 
                    lda      #$40                         ; test for T1 timeout interrupt flag 
                    bita     <VIA_int_flags               ; check 
                    beq      continueReadTryX 
                    bra      linkTimeout 

bit1SendSuccess: 
                    com      <VIA_DDR_a                   ; switch Via port A to output 
                    dec      <<$01,s                      ; counter (4) reached 0? 
                    bne      writeNextDoubleBit           ; if not jump and do next 
                    lda      #$FF                         ; A = FF, 1111 1111 
                    sta      <VIA_port_a                  ; send a "full" byte (bit 4,5,6 set) as end of communication 
                    ldd      #$9181 
                    sta      <VIA_port_b                  ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    ldd      #$0200                       ; A= 02, B = 0 
                    std      <VIA_t1_cnt_lo               ; store a mini T1 timer 
                    lda      #$98                         ; restore T1, ramp on...1001 1000 SHIFT mode = 110 - SHIFT out under control of system clock 
                    sta      <VIA_aux_cntl 
                    puls     a,b,dp,pc                    ; remove used values, reset dp and return to caller 
linkTimeout: 
                    ldd      #$FF91                       ; A = FF, 1111 1111 
                    sta      <VIA_DDR_a                   ; Via port A to output 
                    sta      <VIA_port_a                  ; send a "full" byte (bit 4,5,6 set) as end of communication 
                    stb      <VIA_port_b                  ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG) 
                    ldd      #$9881 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    sta      <VIA_aux_cntl                ; restore T1, ramp on...1001 1000 SHIFT mode = 110 - SHIFT out under control of system clock 
                    puls     a,b,dp,pc                    ; remove used values, reset dp and return to caller
 
; if the other side wants to send data
serial_read_A_withTest: 
                    lda      #$0E                         ; A= $E (reg 14 of PSG) 
                    sta      >VIA_port_a                  ; to VIA port A 
                    ldd      #$9981                       ; A= $99, B = $81 
                    sta      >VIA_port_b                  ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address) 
                    stb      >VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    clr      >VIA_DDR_a                   ; VIA port A as input 
                    ldd      #$8981                       ; A = $89, B = $81 
                    sta      >VIA_port_b                  ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG) 
                    nop                                   ; delay ; -) 
                    lda      >VIA_port_a                  ; get value from buttons -> PSG port A -> Via port A -> to register A 
                    stb      >VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    ldb      #$FF                         ; B = $FF 
                    stb      >VIA_DDR_a                   ; set via port A as output 
                    bita     #$10                         ; test bit 4 of received data 
                    beq      serial_read_A                ; if bit is 0 than a commnication request is issued from the other side 
                    rts                                   ; if not - return 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; received value from joyport to A serial communication
; dp is kept in original state
; if completed correctly:
; B=0, not 0 otherwise
; A contains received value on success
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
serial_read_A: 
                    ldb      #$04                         ; load 4 double bits 
                    pshs     dp,b,a                       ; remember current DP, "$4" and A (push DP first, than b than a, s is pointing to the pushed copy of A) 
                    direct   $D0 
                    lda      #$D0                         ; 
                    tfr      a,dp                         ; setup DP to d0 
                    ldd      #$0E99                       ; A= $E (reg 14 of PSG), B = $99 
                    sta      <VIA_port_a                  ; A to via port A, prepare latch of PSG reg 14 
                    stb      <VIA_port_b                  ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address) 
                    ldd      #$1881                       ; A= $18 (for Aux), and $81 for psg inactive 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                                                          ; disable ramping, while we use T1 for timeout checking...
                    sta      <VIA_aux_cntl                ; SHIFT mode = 110 - SHIFT out under control of system clock, T1 does not control RAMP 
                    ldd      #$FFFF                       ; set a huge timer for the complete commuication timeout 
                    std      <VIA_t1_cnt_lo               ; store to timer lo and hi timer 1 
readNextDoubleBit: 
                    clr      <VIA_DDR_a                   ; set via port A as input (clear DDRA) 
tryReadingBitOne: 
                    ldd      #$8981                       ; A= 89, B 81 
                    sta      <VIA_port_b                  ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG) 
                    nop                                   ; delay ; -) 
                    lda      <VIA_port_a                  ; get value from buttons -> PSG port A -> Via port A -> to register A 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    bita     #$10                         ; test bit 4, for two bit commication correctness - it must be 0, for the first of the 2 bit commucation 
                    beq      bitOneComAck                 ; if that is so - branch 
                    lda      #$40                         ; test bit for T1 
                    bita     <VIA_int_flags               ; otherwise test for T1 timeout 
                    beq      tryReadingBitOne             ; if not timeout - read again... perhaps with more luck 
                    bra      linkTimeout                  ; otherwise - jump to timeout 

bitOneComAck: 
                    ldd      #$8981                       ; A= 89, B =81 
                    sta      <VIA_port_b                  ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG) 
                    nop                                   ; delay ; -) 
                    lda      <VIA_port_a                  ; get value from buttons -> PSG port A -> Via port A -> to register A 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    com      <VIA_DDR_a                   ; set port A as output (all $ff now) 
                    asla                                  ; communication "data" bit is bit 5 
                    asla                                  ; doing 3 asls puts the data bit to carry 
                    asla     
                    ror      ,s                           ; and a ror pushes the bit into the hi bit of our return data, this will be done 8 times so in the end the first received bit will be in place of the least significant bit 
                    lda      #$BF                         ; A = $BF, 1011 1111, load a with our "acceptance" bit cleared (bit 6) 
                    sta      <VIA_port_a                  ; store it to Via port A which will send it to port A of PSG -> to joystick port to other veccy 
                    ldd      #$9181                       ; A = $91, B = 81 
                    sta      <VIA_port_b                  ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    clr      <VIA_DDR_a                   ; prepare next read, and set via port A to input again 
tryReadingBitTwo: 
                    ldd      #$8981                       ; A= 89, B =81 
                    sta      <VIA_port_b                  ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG) 
                    nop                                   ; delay ; -) 
                    lda      <VIA_port_a                  ; get value from buttons -> PSG port A -> Via port A -> to register A 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    bita     #$10                         ; test bit 4, for two bit commication correctness - this time it must be 1 (second bit of 2 bit communication) 
                    bne      bitTwoComAck                 ; if that is so - branch 
                    lda      #$40                         ; test bit for T1 
                    bita     <VIA_int_flags               ; otherwise test for T1 timeout 
                    beq      tryReadingBitTwo             ; if not timeout - read again... perhaps with more luck 
                    jmp      >linkTimeout                 ; otherwise - jump to timeout 

bitTwoComAck: 
                    ldd      #$8981                       ; A= 89, B 81 
                    sta      <VIA_port_b                  ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (Read from PSG) 
                    nop                                   ; delay ; -) 
                    lda      <VIA_port_a                  ; get value from buttons -> PSG port A -> Via port A -> to register A 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    com      <VIA_DDR_a                   ; set port A as output (all $ff now) 
                    asla                                  ; doing 3 asls puts the data bit to carry 
                    asla     
                    asla     
                    ror      ,s                           ; and a ror pushes the bit into the hi bit of our return data, and all other bits one to the right 
                    lda      #$FF                         ; A = $FF, 1111 1111, load a with our "acceptance" bit set (bit 6) 
                    sta      <VIA_port_a                  ; store it to Via port A which will send it to port A of PSG -> to joystick port to other veccy 
                    ldd      #$9181                       ; A = $91, B = 81 
                    sta      <VIA_port_b                  ; VIA Port B = 91, mux disabled, RAMP disabled, BC1/BDIR = 10 (Write to PSG) 
                    stb      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    dec      <<$01,s                      ; do the above 4 times (2bits *2 = 8bit = 1 byte) 
                    direct   $FF 
                    bne      readNextDoubleBit            ; if not done - read next to bits 
                    ldd      #$0200                       ; A= 02, B = 0 
                    std      <$04                         ; store a mini T1 timer 
                    lda      #$98                         ; 
                    sta      <$0B                         ; restore T1, ramp on...1001 1000 SHIFT mode = 110 - SHIFT out under control of system clock 
                    puls     a,b,dp,pc                    ; remove used values, reset dp and return to caller, result is "loaded" to reg A, B = 0! 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this routine syncs 3 bytes *2 (both structures) 
; while doing the syncing the link is continually tested if it still in working order
; this routine also sets the status flag of the link connection
; negative = link not established, 0 = I am primary, 1 = I am secondary
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
syncVectrex_3bytes: 
                    lda      #$D0                         ; setup DP 
                    tfr      a,dp 
                    direct   $D0 
                    ldy      #secondary_structure         ; read data to this address [data original from secondary vectrex] 
                    lda      >statusFlag 
                    ldb      #$ff                         ; default while communication -> link not established
                    stb      >statusFlag                  ; with this we can exit easily
                    tsta                                  ; check the known status
                    beq      primarySync                  ; 0 = primary           
                    bpl      secondarySync                ; 1 = secondary
linkFailed: 
                    rts                                   ; -1 = no link -> exit
; do syncing from the primary vectrex
; first write, than read
; didn't do fancy optimized loops here, just a three byte sync for both sides, thats all
primarySync: 
                    ldx      #primary_structure           ; address of primary data to index register
                    lda      ,x+ ; load one byte
                    jsr      >serial_write_A ; send it
                    tstb     ; test b = 0
                    lbne     linkFailed ; if not -> communication failed
                    lda      ,x+ ; repeat ...
                    jsr      >serial_write_A 
                    tstb     
                    lbne     linkFailed 
                    lda      ,x+ 
                    jsr      >serial_write_A 
                    tstb     
                    lbne     linkFailed 
                    ldx      #secondary_structure         ; address of secondary data to index register
                    jsr      >serial_read_A ; read one byte
                    tstb     ; test for error
                    lbne     linkFailed ; if so -> jump
                    sta      ,x+ ; otherwise -> store the byte
                    jsr      >serial_read_A ; repeat...
                    tstb     
                    lbne     linkFailed 
                    sta      ,x+ 
                    jsr      >serial_read_A 
                    tstb     
                    lbne     linkFailed 
                    sta      ,x+ 
                    clr      >statusFlag ; we are primary -> restore the "ok" flag
                    rts      

; do syncing from the secondary vectrex
; first read, than write
; same as above, no further comments here
secondarySync: 
                    ldx      #primary_structure           ; reading and writing from the view of primary vectrex 
                    jsr      >serial_read_A 
                    tstb     
                    lbne     linkFailed 
                    sta      ,x+ 
                    jsr      >serial_read_A 
                    tstb     
                    lbne     linkFailed 
                    sta      ,x+ 
                    jsr      >serial_read_A 
                    tstb     
                    lbne     linkFailed 
                    sta      ,x+ 
                    ldx      #secondary_structure         ; read data to this address [data original from secondary vectrex] 
                    lda      ,x+ 
                    jsr      >serial_write_A 
                    tstb     
                    lbne     linkFailed 
                    lda      ,x+ 
                    jsr      >serial_write_A 
                    tstb     
                    lbne     linkFailed 
                    lda      ,x+ 
                    jsr      >serial_write_A 
                    tstb     
                    lbne     linkFailed 
                    lda      #1 
                    sta      >statusFlag 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start: 
                    lda      #$D0                         ; set up direct page to d0 for the complete "game" 
                    tfr      a,dp 
                    direct   $D0 
                    jsr      serial_output_ff             ; init PSG port A as output
                    bsr      init_jumper                  ; init main subroutine to "init" 
main_loop: 
                    clra                                  ; the last thing done in the mainloop "last round" was a draw 
                    sta      >VIA_shift_reg               ; this must be finished here with a mov 0 to SHIFT (switch the beam off) 
                    jsr      >Wait_Recal                  ; recalibrate 
                    jsr      >queryInputPort0             ; query input devices (port 0) 
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
                    lda      #$FF                         ; default status: link is broken (needed for a "hard" exit in the subroutines) 
                    sta      >statusFlag                  ; store the status of the connection 
                    jsr      >serial_read_A_withTest      ; read one serial byte (with connection test) 
                    cmpd     #$4D00                       ; if = $4d -> jump 
                    beq      secondaryTest                ; if 4d is received, the other vectrex was first, we are now secondary
                    lda      #$4D                         ; send 4d as a sign that we are "primary" than we send first! 0100 1101 
                    jsr      >serial_write_A              ; write it to putput 
                    tstb                                  ; only if 4 double byte counter is zero, there was a success 
                    lbne     linkFailed_nl                ; branch if not successfull 
                    jsr      >serial_read_A               ; Wait for other side to ackowledge our priority 
                    cmpd     #$7300                       ; A= $73 - 0111 0011 Jup, we are king of the hill! (and B = 00) 
                    beq      primarySuccess 
linkFailed_nl: 
                    jsr      >Reset0Ref                   ; reset vector beam 
                    lda      #$3F                         ; set intensity 
                    jsr      >Intensity_a                 ; to $3f 
                    ldd      #$10E0                       ; move to a position 
                    jsr      >Moveto_d_7F 
                    lda      #$0F                         ; set a low scaling factor 
                    sta      <VIA_t1_cnt_lo               ; (timer 1 is scaling) 
                    ldu      #no_link_string              ; load the vector representation of "no link" to U 
                    jmp      >draw_vector_list            ; and draw that -> and exit subroutine to main 

primarySuccess: 
                    clr      >statusFlag 
                    rts      

secondaryTest: 
                    lda      #$73                         ; acknowledge we are secondary 
                    jsr      >serial_write_A              ; send that 
                    tstb     
                    lbne     linkFailed_nl 
                    lda      #1 
                    sta      >statusFlag 
                    rts      

; drawing the "you" at the right position
; players are actually drawn with the "same" routine (no differentiation between primary and secondary)
primary_main: 
                    jsr      >syncVectrex_3bytes          ; sync 3 bytes TO other player and 3 bytes from other player, also sets link status 
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
                    jsr      >syncVectrex_3bytes          ; sync 3 bytes TO other player and 3 bytes from other player, also sets link status 
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in x is the player structure given
; apply the current input to the given player structure
; digital joystick movements (filled before) are represented 
; by +1, 0, -1 (for vertical and horizontal joystick positions) 
; button states are respected and applied (intensity change of pressed or released)
; exits with D filled with position of player
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
