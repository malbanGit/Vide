                INCLUDE \6809\VECTREX.INC
                LIST    ON

                FCC     /g GCE 2001/
                FCB     $80

                FDB     $FF8F

                FDB     $F848
                FDB     $20D0
                FCC     /TEXT DEMO/
                FCB     $80

                FCB     $00

Start           LDU     #Text_Table

Loop            JSR     DP_to_D0

                JSR     Print_Str_hwyx

                LDD     ,U
                BNE     Loop

                JSR     DP_to_C8
*               LDU     #music
*               JSR     Init_Music_chk
                JSR     Wait_Recal

                BRA     Start

Text_Table      FCB     -8,72           h,w
                FCB     20,-48          y,x
                FCC     /(-48,20) -8,72/
                FCB     $80

                FCB     -4,36           h,w
                FCB     48,-48          y,x
                FCC     /(-48,48) -4,36/
                FCB     $80

                FCB     -12,48          h,w
                FCB     -48,-48         y,x
                FCC     /(-48,-48) -12,48/
                FCB     $80

*               this one is upside-down and backwards

                FCB     6,-48           h,w
                FCB     30,48           y,x
                FCC     /(48,30) 6,-48
                FCB     $80

                FDB     0               end of list

                END
