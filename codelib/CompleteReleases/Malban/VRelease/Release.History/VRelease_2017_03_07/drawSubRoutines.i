                    ***********************************************************  
; obviously non optimized!
;
; list in x
; list:
; counter
; move y,x
; draw y,x * count
drawRotated 
                    ldd      1,x 
                    jsr      Moveto_d 
                    lda      ,x 
                    leax     3,x 
                    jsr      Draw_VL_a 
                    rts      

; like draw_vlc with additional pattern byte befor each coordinate
; pattern byte is taken "directly" and used as shift value
draw_vlcp 
                    JSR      Draw_VL_mode                 ; Vectrex BIOS print routine 
                    rts      

; pointer the same list as "drawRotated" but only the corner "dots" are drawn
explosionDotDraw 
; in U pointer to current object
                    lda      SCALE+u_offset1,u 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo) 
                    JSR      Intensity_7F                 ; Sets the intensity of the 
                    ldd      Y_POS+u_offset1,u                      ; last position of object is center of explosion -> move there 
                    jsr      Moveto_d 
                    lda      EXPLOSION_SCALE+u_offset1,u 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldx      #rotList 
                    ldd      1,x 
                    jsr      Moveto_d 
                    jsr      Dot_here 
                    lda      ,x 
                    sta      tmp_count2 
                    leax     3,x 
next_edd: 
                    lda      tmp_count2 
                    deca     
                    sta      tmp_count2 
                    bmi      done_edd 
                    ldd      ,x++ 
                    jsr      Moveto_d 
                    jsr      Dot_here 
                    bra      next_edd 

done_edd: 
                    rts      

; input list in X
; 0 move
; negative use as shift
; positive end
myDraw_VL_mode: 
                    LDA      #$80 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
next_line
 lda ,x+
 beq move_vl
 bmi draw_vl
done_vl:
; VIA values back to default
                    LDD      #$98CC  ;[6] check
                    STa      <VIA_aux_cntl                ; [4] Shift reg mode = 000 free disable, T1 PB7 enabled 
                    STB      <VIA_cntl                    ; [4] $CC /BLANK low and /ZERO low 
 rts
draw_vl:
 nop 4
    lda      #$ce                         ; [2] 
    sta      <VIA_cntl                    ; [4]  ; light OFF, ZERO OFF 
 ldd ,x++
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee ; light ON, ZERO OFF
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles)
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off

 lda ,x+ ;[7]
 bmi draw_vl ; [3]
 beq move_vl ; [3]

 bra done_vl; [3]





move_vl:
 nop 3 ; one branch not taken less
    lda      #$ce                         ; [2] 
    sta      <VIA_cntl                    ; [4]  ; light OFF, ZERO OFF 
 ldd ,x++
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
;                    ldb      #$ee ; light ON, ZERO OFF
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles)
; light on
             ;       stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off

 lda ,x+ ;[7]
 bmi draw_vl ; [3]
 beq move_vl ; [3]
 bra done_vl; [3]

