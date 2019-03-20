        .title  68HC16 Assembler Test

        .module pc6816

        ; This file should be assembled as follows:
        ;
        ; as6816 -xlff pc6816
        ;

        ind8    =       0x12
        ind16   =       0x3456

        mask8   =       0x78
        
        .globl  extern


j1:     bra     j1                      ; B0 FA
j2:     bsr     j2                      ; 36 FA

j3:     bra     aj3                     ; B0pFC                 ; B0 FA
j4:     bsr     aj4                     ; 36pFC                 ; 36 FA

j5:     brclr   ind8,x,#mask8,j5        ; CB 78 12 FA
j6:     brclr   ind16,x,#mask8,j6       ; 0A 78 34 56 FF FA
j6a:    brclr   extern,x,#mask8,j6a     ; 0A 78s00r00 FF FA
        
j7:     brclr   ind8,x,#mask8,aj7       ; 0A 78 00 12q00p00     ; 0A 78 00 12 FF FA
j8:     brclr   ind16,x,#mask8,aj8      ; 0A 78 34 56q00p00     ; 0A 78 34 56 FF FA
j8a:    brclr   extern,x,#mask8,aj8a    ; 0A 78s00r00q00p00     ; 0A 78 9A BC FF FA
        
j9:     lbra    j9                      ; 37 80 FF FA
j10:    lbsr    j10                     ; 27 F9 FF FA
       
j11:    lbra    aj11                    ; 37 80qFFpFE           ; 37 80 FF FA
j12:    lbsr    aj12                    ; 27 F9qFFpFE           ; 27 F9 FF FA




        
