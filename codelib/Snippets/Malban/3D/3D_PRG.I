; expects figure pointer in X
draw_3d:
                 direct        $D0
                 LDU           2,X
start:
                 LDD           ,U
                 STA           $d001
                 CLR           $d000
                 LDA           ,X
                 INC           $d000
                 STB           $d001
                 STA           $d00A
                 CLR           $d005
                 LEAX          4,X
                 LDU           2,X
                 LDA           ,X
                 BGT           end1
                 LDD           #$0040
wait:
                 BITB          $d00D
                 BEQ           wait
                 STA           $d00A
                 BRA           start
end1:
                 LDD           #$0040
end2:
                 BITB          $d00D
                 BEQ           end2
                 STA           $d00A
                 RTS

; expects figure pointer in X
draw_3ds:
                 direct        $D0
                 LDU           2,X
                 LDA           1,X
starts:
                 STA           $d004
                 LDD           ,u
                 STA           $d001
                 CLR           $d000
                 LDA           ,X
                 INC           $d000
                 STB           $d001
                 STA           $d00A
                 CLR           $d005
                 LEAX          4,X
                 LDU           2,X
                 LDA           ,X
                 BGT           end1s
                 LDA           1,X
                 LDB           #$0040
waits:
                 BITB          $d00D
                 BEQ           waits
                 CLR           $d00A
                 BRA           starts
end1s:
                 LDD           #$0040
end2s:
                 BITB          $d00D
                 BEQ           end2s
                 STA           $d00A
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
