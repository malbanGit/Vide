; expects figure pointer in X
draw_3d:
                 direct        $D0
                 LDU           2,X
start_3d:
                 LDD           ,U
                 STA           VIA_port_a
                 CLR           VIA_port_b
                 LDA           ,X
                 INC           VIA_port_b
                 STB           VIA_port_a
                 STA           VIA_shift_reg
                 CLR           VIA_t1_cnt_hi
                 LEAX          4,X
                 LDU           2,X
                 LDA           ,X
                 BGT           end1_3d
                 LDD           #$0040
wait_3d:
                 BITB          VIA_int_flags
                 BEQ           wait_3d
                 STA           VIA_shift_reg
                 BRA           start_3d
end1_3d:
                 LDD           #$0040
end2_3d:
                 BITB          VIA_int_flags
                 BEQ           end2_3d
                 STA           VIA_shift_reg
                 RTS




***********************************************************  
; draw bigger vlists than above one - scale 40
; input list in X
; destroys u
; 0 move
; negative use as shift
; positive end
myDraw_VL_mode4_3d: 
                    LDA      #$80 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
 ldu 2,x
                    lda      ,x ; skip scale info
                    beq      move_vl4_3d
                    bmi      draw_vl4_3d 
done_vl4_3d: 
; VIA values back to default
; nop 6
                    LDD      #$98ce                       ;[6] check $ce = light off
                    STa      <VIA_aux_cntl                ; [4] Shift reg mode = 000 free disable, T1 PB7 enabled 
 nop 2
                    STB      <VIA_cntl                    ; [4] $CC /BLANK low and /ZERO low 
                    rts      

draw_vl4_3d: 
;                    ldd      ,u 
;                    ldu      #$ce00 
;                    stu      <VIA_cntl 

 ldd #$ce00
 nop
                    sta      <VIA_cntl 
                    ldd      ,u 

                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 

                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee                         ; $ee = light ON, ZERO OFF 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
 leax 4,x
 ldu 2,x
                    lda      ,x                          ;[7] 
; nop 1;NEW
                    bmi      draw_vl4_3d                     ; [3] 
                    beq      move_vl4_3d                     ; [3] 
                    bra      done_vl4_3d                     ; [3] 

move_vl4_3d: 
;                    ldd      ,u 
;                    ldu      #$ce00 
;                    stu      <VIA_cntl 

 ldd #$ce00
 nop

                    sta      <VIA_cntl 
                    ldd      ,u 

                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 

                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
 leax 4,x
 ldu 2,x
                                                          ; stb <VIA_cntl ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
                    lda      ,x                          ;[7] 
                    bmi      draw_vl4_3d                     ; [3] 
                    beq      move_vl4_3d                     ; [3] 
                    bra      done_vl4_3d                     ; [3] 









; expects figure pointer in X
draw_3ds:
                 direct        $D0
                 LDU           2,X
                 LDA           1,X
start_3ds:
                 STA           VIA_t1_cnt_lo
                 LDD           ,u
                 STA           VIA_port_a
                 CLR           VIA_port_b
                 LDA           ,X
                 INC           VIA_port_b
                 STB           VIA_port_a
                 STA           VIA_shift_reg
                 CLR           VIA_t1_cnt_hi
                 LEAX          4,X
                 LDU           2,X
                 LDA           ,X
                 BGT           end1_3ds
                 LDA           1,X
                 LDB           #$0040
wait_3ds:
                 BITB          VIA_int_flags
                 BEQ           wait_3ds
                 CLR           VIA_shift_reg
                 BRA           start_3ds
end1_3ds:
                 LDD           #$0040
end2_3ds:
                 BITB          VIA_int_flags
                 BEQ           end2_3ds
                 STA           VIA_shift_reg
                 RTS


; Cosinus data
cosinus3d:

                 DB 63, 62, 61, 60, 58, 55, 52, 48, 43, 39, 34            ; 11
                 DB 28, 23, 17, 10, 4, -1, -7, -14, -20, -25, -31         ; 22
                 DB -36, -41, -46, -50, -53, -56, -59, -61, -62, -62, -62 ; 33
                 DB -62, -61, -59, -56, -53, -50, -46, -41, -36, -31, -25 ; 44
                 DB -20, -14, -7, -1, 4, 10, 17, 23, 28, 34, 39           ; 55
                 DB 43, 48, 52, 55, 58, 60, 61, 62, 63

; Sinus data
sinus3d:
                 DB 0, 6, 12, 18, 24, 30, 35, 40, 45, 49, 52              ; 11
                 DB 56, 58, 60, 62, 62, 62, 62, 61, 59, 57, 54            ; 22
                 DB 51, 47, 42, 38, 32, 27, 21, 15, 9, 3, -3              ; 33
                 DB -9, -15, -21, -27, -32, -38, -42, -47, -51, -54, -57  ; 44
                 DB -59, -61, -62, -62, -62, -62, -60, -58, -56, -52, -49 ; 55
                 DB -45, -40, -35, -30, -24, -18, -12, -6, -3
