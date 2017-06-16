Sound_Byte=$F256

        BSS
        org ym_ram
ym_len:
                ds   2
ym_reg_base:
                ds   2
ym_data_pos:
                ds   2


        code
;***************************************************************************

;***************************************************************************
do_ym_sound:
                ldd     ym_len                ; load current VBL Counter
                beq     ymsodone              ; if 0, than we are done
                subd    #1                    ; otherwise remember we are doing one byte now
                std     ym_len                ; and store it

                ldu     ym_data_pos           ; load current ym data position to u
                ldy     ym_reg_base           ; get start address of regs we want to use
                lda     ,y+                   ; reg to use in a
next_reg:
 cmpa #$d
 bne no13
 cmpb #$ff
 beq noOutput
no13
                ldb     ,u+
                ; A PSG reg
                ; B data
                jsr     Sound_Byte            ; and actually output that to the sound chip
noOutput:
                lda     ,y+                   ; reg to use in a
                bpl     next_reg              ; we do not branch :-)
ymsodone:
                stu     ym_data_pos
                rts


init_ym_sound:

                ldd     ,u++                  ; first load count of data and store it
                std     ym_len
                stu     ym_reg_base
                ldd     ,u++                  ; load regInfo start
seek_reg_end:
                lda     ,u+                
                bpl     seek_reg_end          ; find register end point ($ff)
                stu     ym_data_pos           ; that address is start of ymdata
                rts

