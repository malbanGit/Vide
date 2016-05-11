vozlogoframecount equ 7 ; number of animations
vozlogoframetotal equ 245 ; total number of frames in animation 
; index table 
vozlogoframetab        fdb vozlogoframe0
       fdb vozlogoframe1
       fdb vozlogoframe2
       fdb vozlogoframe3
       fdb vozlogoframe4
       fdb vozlogoframe5
       fdb vozlogoframe6

; Animation 0
vozlogoframe0:
       fcb 33 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(0,0)->(-88,0)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,-682 ; dx/dy. dx(abs:-682|rel:-682) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 1
vozlogoframe1:
       fcb 33 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(0,0)->(-75,-50)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 387,-581 ; dx/dy. dx(abs:-581|rel:-581) dy(abs:387|rel:387)
; node # 2 D(-88,0)->(-88,-4)
       fcb 2 ; drawmode 
       fcb 0,-88 ; starx/y relative to previous node
       fdb -356,581 ; dx/dy. dx(abs:0|rel:581) dy(abs:31|rel:-356)
; node # 3 D(0,0)->(-65,48)
       fcb 2 ; drawmode 
       fcb 0,88 ; starx/y relative to previous node
       fdb -403,-504 ; dx/dy. dx(abs:-504|rel:-504) dy(abs:-372|rel:-403)
       fcb  1  ; end of anim
; Animation 2
vozlogoframe2:
       fcb 34 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,-1)->(0,-1)
       fcb 0 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-86,-12)->(-68,-13)
       fcb 0 ; drawmode 
       fcb 11,-86 ; starx/y relative to previous node
       fdb 7,135 ; dx/dy. dx(abs:135|rel:135) dy(abs:7|rel:7)
; node # 2 D(-88,-4)->(-73,-3)
       fcb 2 ; drawmode 
       fcb -8,-2 ; starx/y relative to previous node
       fdb -14,-23 ; dx/dy. dx(abs:112|rel:-23) dy(abs:-7|rel:-14)
; node # 3 D(-88,-4)->(-88,-4)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 7,-112 ; dx/dy. dx(abs:0|rel:-112) dy(abs:0|rel:7)
; node # 4 D(-75,-50)->(-75,-50)
       fcb 2 ; drawmode 
       fcb 46,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-81,-28)->(-62,-28)
       fcb 2 ; drawmode 
       fcb -22,-6 ; starx/y relative to previous node
       fdb 0,143 ; dx/dy. dx(abs:143|rel:143) dy(abs:0|rel:0)
; node # 6 D(-75,-50)->(-48,-51)
       fcb 2 ; drawmode 
       fcb 22,6 ; starx/y relative to previous node
       fdb 7,60 ; dx/dy. dx(abs:203|rel:60) dy(abs:7|rel:7)
; node # 7 D(-88,-4)->(-36,-3)
       fcb 2 ; drawmode 
       fcb -46,-13 ; starx/y relative to previous node
       fdb -14,188 ; dx/dy. dx(abs:391|rel:188) dy(abs:-7|rel:-14)
; node # 8 D(-88,-4)->(-73,-3)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,-279 ; dx/dy. dx(abs:112|rel:-279) dy(abs:-7|rel:0)
; node # 9 M(-85,-15)->(-57,-15)
       fcb 0 ; drawmode 
       fcb 11,3 ; starx/y relative to previous node
       fdb 7,98 ; dx/dy. dx(abs:210|rel:98) dy(abs:0|rel:7)
; node # 10 D(-88,-4)->(-51,-3)
       fcb 2 ; drawmode 
       fcb -11,-3 ; starx/y relative to previous node
       fdb -7,68 ; dx/dy. dx(abs:278|rel:68) dy(abs:-7|rel:-7)
; node # 11 M(-86,1)->(-36,2)
       fcb 0 ; drawmode 
       fcb -5,2 ; starx/y relative to previous node
       fdb 0,98 ; dx/dy. dx(abs:376|rel:98) dy(abs:-7|rel:0)
; node # 12 D(-88,-4)->(-36,-2)
       fcb 2 ; drawmode 
       fcb 5,-2 ; starx/y relative to previous node
       fdb -8,15 ; dx/dy. dx(abs:391|rel:15) dy(abs:-15|rel:-8)
; node # 13 M(-86,1)->(-36,2)
       fcb 0 ; drawmode 
       fcb -5,2 ; starx/y relative to previous node
       fdb 8,-15 ; dx/dy. dx(abs:376|rel:-15) dy(abs:-7|rel:8)
; node # 14 D(-65,48)->(-51,47)
       fcb 2 ; drawmode 
       fcb -47,21 ; starx/y relative to previous node
       fdb 14,-271 ; dx/dy. dx(abs:105|rel:-271) dy(abs:7|rel:14)
; node # 15 D(-65,48)->(-65,48)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -7,-105 ; dx/dy. dx(abs:0|rel:-105) dy(abs:0|rel:-7)
; node # 16 D(-88,-4)->(-88,-4)
       fcb 2 ; drawmode 
       fcb 52,-23 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 M(-88,-4)->(-62,-3)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -7,195 ; dx/dy. dx(abs:195|rel:195) dy(abs:-7|rel:-7)
; node # 18 D(-75,26)->(-59,26)
       fcb 2 ; drawmode 
       fcb -30,13 ; starx/y relative to previous node
       fdb 7,-75 ; dx/dy. dx(abs:120|rel:-75) dy(abs:0|rel:7)
       fcb  1  ; end of anim
; Animation 3
vozlogoframe3:
       fcb 34 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,-1)->(0,-1)
       fcb 0 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-68,-13)->(-68,-13)
       fcb 0 ; drawmode 
       fcb 12,-68 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-73,-3)->(-73,-3)
       fcb 2 ; drawmode 
       fcb -10,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-88,-4)->(-88,-4)
       fcb 2 ; drawmode 
       fcb 1,-15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-75,-50)->(-75,-50)
       fcb 2 ; drawmode 
       fcb 46,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-62,-28)->(-62,-28)
       fcb 2 ; drawmode 
       fcb -22,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-48,-51)->(-48,-51)
       fcb 2 ; drawmode 
       fcb 23,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-36,-3)->(-36,-3)
       fcb 2 ; drawmode 
       fcb -48,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-73,-3)->(-73,-3)
       fcb 2 ; drawmode 
       fcb 0,-37 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(-57,-15)->(-57,-15)
       fcb 0 ; drawmode 
       fcb 12,16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 D(-51,-3)->(-51,-3)
       fcb 2 ; drawmode 
       fcb -12,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 M(-46,-43)->(-45,-42)
       fcb 0 ; drawmode 
       fcb 40,5 ; starx/y relative to previous node
       fdb -7,7 ; dx/dy. dx(abs:7|rel:7) dy(abs:-7|rel:-7)
; node # 12 D(-46,-43)->(-11,-46)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 29,256 ; dx/dy. dx(abs:263|rel:256) dy(abs:22|rel:29)
; node # 13 D(-37,-6)->(-11,-1)
       fcb 2 ; drawmode 
       fcb -37,9 ; starx/y relative to previous node
       fdb -59,-68 ; dx/dy. dx(abs:195|rel:-68) dy(abs:-37|rel:-59)
; node # 14 D(-37,-6)->(-36,-6)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 37,-188 ; dx/dy. dx(abs:7|rel:-188) dy(abs:0|rel:37)
; node # 15 M(-43,-32)->(-28,-31)
       fcb 0 ; drawmode 
       fcb 26,-6 ; starx/y relative to previous node
       fdb -7,105 ; dx/dy. dx(abs:112|rel:105) dy(abs:-7|rel:-7)
; node # 16 D(-43,-32)->(-11,-33)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 14,128 ; dx/dy. dx(abs:240|rel:128) dy(abs:7|rel:14)
; node # 17 M(-36,2)->(-13,1)
       fcb 0 ; drawmode 
       fcb -34,7 ; starx/y relative to previous node
       fdb 0,-67 ; dx/dy. dx(abs:173|rel:-67) dy(abs:7|rel:0)
; node # 18 D(-36,2)->(-36,2)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -7,-173 ; dx/dy. dx(abs:0|rel:-173) dy(abs:0|rel:-7)
; node # 19 D(-36,-2)->(-36,-2)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 M(-40,-17)->(-29,-18)
       fcb 0 ; drawmode 
       fcb 15,-4 ; starx/y relative to previous node
       fdb 7,82 ; dx/dy. dx(abs:82|rel:82) dy(abs:7|rel:7)
; node # 21 D(-40,-17)->(-11,-15)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -22,136 ; dx/dy. dx(abs:218|rel:136) dy(abs:-15|rel:-22)
; node # 22 M(-36,2)->(-13,1)
       fcb 0 ; drawmode 
       fcb -19,4 ; starx/y relative to previous node
       fdb 22,-45 ; dx/dy. dx(abs:173|rel:-45) dy(abs:7|rel:22)
; node # 23 D(-51,47)->(-7,44)
       fcb 2 ; drawmode 
       fcb -45,-15 ; starx/y relative to previous node
       fdb 15,158 ; dx/dy. dx(abs:331|rel:158) dy(abs:22|rel:15)
; node # 24 D(-65,48)->(-65,48)
       fcb 2 ; drawmode 
       fcb -1,-14 ; starx/y relative to previous node
       fdb -22,-331 ; dx/dy. dx(abs:0|rel:-331) dy(abs:0|rel:-22)
; node # 25 D(-88,-4)->(-88,-4)
       fcb 2 ; drawmode 
       fcb 52,-23 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 M(-62,-3)->(-62,-3)
       fcb 0 ; drawmode 
       fcb -1,26 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 D(-59,26)->(-59,26)
       fcb 2 ; drawmode 
       fcb -29,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 M(-51,47)->(-51,47)
       fcb 0 ; drawmode 
       fcb -21,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 29 D(-36,2)->(-36,2)
       fcb 2 ; drawmode 
       fcb 45,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 30 M(-41,17)->(-27,18)
       fcb 0 ; drawmode 
       fcb -15,-5 ; starx/y relative to previous node
       fdb -7,105 ; dx/dy. dx(abs:105|rel:105) dy(abs:-7|rel:-7)
; node # 31 D(-46,32)->(-27,33)
       fcb 2 ; drawmode 
       fcb -15,-5 ; starx/y relative to previous node
       fdb 0,38 ; dx/dy. dx(abs:143|rel:38) dy(abs:-7|rel:0)
       fcb  1  ; end of anim
; Animation 4
vozlogoframe4:
       fcb 35 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,-1)->(0,0)
       fcb 0 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb -7,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-7|rel:-7)
; node # 1 M(-68,-13)->(-68,-13)
       fcb 0 ; drawmode 
       fcb 12,-68 ; starx/y relative to previous node
       fdb 7,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:7)
; node # 2 D(-73,-3)->(-73,-3)
       fcb 2 ; drawmode 
       fcb -10,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-88,-4)->(-88,-4)
       fcb 2 ; drawmode 
       fcb 1,-15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-75,-50)->(-75,-50)
       fcb 2 ; drawmode 
       fcb 46,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-62,-28)->(-62,-28)
       fcb 2 ; drawmode 
       fcb -22,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-48,-51)->(-48,-51)
       fcb 2 ; drawmode 
       fcb 23,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-36,-3)->(-36,-3)
       fcb 2 ; drawmode 
       fcb -48,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-73,-3)->(-73,-3)
       fcb 2 ; drawmode 
       fcb 0,-37 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(-57,-15)->(-57,-15)
       fcb 0 ; drawmode 
       fcb 12,16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 D(-51,-3)->(-51,-3)
       fcb 2 ; drawmode 
       fcb -12,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 M(-45,-42)->(-45,-42)
       fcb 0 ; drawmode 
       fcb 39,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-11,-46)->(-11,-46)
       fcb 2 ; drawmode 
       fcb 4,34 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-11,-1)->(-11,-1)
       fcb 2 ; drawmode 
       fcb -45,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-36,-6)->(-36,-6)
       fcb 2 ; drawmode 
       fcb 5,-25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 M(-28,-31)->(-28,-31)
       fcb 0 ; drawmode 
       fcb 25,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(-11,-33)->(-11,-33)
       fcb 2 ; drawmode 
       fcb 2,17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-11,-33)->(-1,-32)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -7,73 ; dx/dy. dx(abs:73|rel:73) dy(abs:-7|rel:-7)
; node # 18 D(-11,1)->(-5,0)
       fcb 2 ; drawmode 
       fcb -34,0 ; starx/y relative to previous node
       fdb 14,-30 ; dx/dy. dx(abs:43|rel:-30) dy(abs:7|rel:14)
; node # 19 M(-11,1)->(12,-1)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 7,125 ; dx/dy. dx(abs:168|rel:125) dy(abs:14|rel:7)
; node # 20 D(-11,-30)->(8,-31)
       fcb 2 ; drawmode 
       fcb 31,0 ; starx/y relative to previous node
       fdb -7,-30 ; dx/dy. dx(abs:138|rel:-30) dy(abs:7|rel:-7)
; node # 21 D(-11,-30)->(22,-29)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -14,103 ; dx/dy. dx(abs:241|rel:103) dy(abs:-7|rel:-14)
; node # 22 M(-11,-46)->(-11,-46)
       fcb 0 ; drawmode 
       fcb 16,0 ; starx/y relative to previous node
       fdb 7,-241 ; dx/dy. dx(abs:0|rel:-241) dy(abs:0|rel:7)
; node # 23 D(-11,-46)->(24,-48)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 14,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:14|rel:14)
; node # 24 D(-11,-30)->(22,-29)
       fcb 2 ; drawmode 
       fcb -16,0 ; starx/y relative to previous node
       fdb -21,-15 ; dx/dy. dx(abs:241|rel:-15) dy(abs:-7|rel:-21)
; node # 25 M(-13,1)->(20,-1)
       fcb 0 ; drawmode 
       fcb -31,-2 ; starx/y relative to previous node
       fdb 21,0 ; dx/dy. dx(abs:241|rel:0) dy(abs:14|rel:21)
; node # 26 D(-36,2)->(-36,2)
       fcb 2 ; drawmode 
       fcb -1,-23 ; starx/y relative to previous node
       fdb -14,-241 ; dx/dy. dx(abs:0|rel:-241) dy(abs:0|rel:-14)
; node # 27 D(-36,-2)->(-36,-2)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 M(-29,-18)->(-29,-18)
       fcb 0 ; drawmode 
       fcb 16,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 29 D(-11,-15)->(-11,-15)
       fcb 2 ; drawmode 
       fcb -3,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 30 M(-13,1)->(20,-1)
       fcb 0 ; drawmode 
       fcb -16,-2 ; starx/y relative to previous node
       fdb 14,241 ; dx/dy. dx(abs:241|rel:241) dy(abs:14|rel:14)
; node # 31 D(-11,15)->(19,14)
       fcb 2 ; drawmode 
       fcb -14,2 ; starx/y relative to previous node
       fdb -7,-22 ; dx/dy. dx(abs:219|rel:-22) dy(abs:7|rel:-7)
; node # 32 D(-11,15)->(9,15)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -7,-73 ; dx/dy. dx(abs:146|rel:-73) dy(abs:0|rel:-7)
; node # 33 D(-7,44)->(15,42)
       fcb 2 ; drawmode 
       fcb -29,4 ; starx/y relative to previous node
       fdb 14,14 ; dx/dy. dx(abs:160|rel:14) dy(abs:14|rel:14)
; node # 34 D(-7,44)->(-7,44)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -14,-160 ; dx/dy. dx(abs:0|rel:-160) dy(abs:0|rel:-14)
; node # 35 D(-11,15)->(-3,15)
       fcb 2 ; drawmode 
       fcb 29,-4 ; starx/y relative to previous node
       fdb 0,58 ; dx/dy. dx(abs:58|rel:58) dy(abs:0|rel:0)
; node # 36 D(-11,15)->(-11,15)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,-58 ; dx/dy. dx(abs:0|rel:-58) dy(abs:0|rel:0)
; node # 37 M(-13,1)->(-13,1)
       fcb 0 ; drawmode 
       fcb 14,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 D(-7,44)->(-7,44)
       fcb 2 ; drawmode 
       fcb -43,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(-65,48)->(-65,48)
       fcb 2 ; drawmode 
       fcb -4,-58 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 D(-88,-4)->(-88,-4)
       fcb 2 ; drawmode 
       fcb 52,-23 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 41 M(-62,-3)->(-62,-3)
       fcb 0 ; drawmode 
       fcb -1,26 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 42 D(-59,26)->(-59,26)
       fcb 2 ; drawmode 
       fcb -29,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 43 M(-51,47)->(-51,47)
       fcb 0 ; drawmode 
       fcb -21,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 44 D(-36,2)->(-36,2)
       fcb 2 ; drawmode 
       fcb 45,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 45 M(-27,18)->(-27,18)
       fcb 0 ; drawmode 
       fcb -16,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 46 D(-27,33)->(-27,33)
       fcb 2 ; drawmode 
       fcb -15,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 5
vozlogoframe5:
       fcb 38 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-68,-13)->(-68,-13)
       fcb 0 ; drawmode 
       fcb 13,-68 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-73,-3)->(-73,-3)
       fcb 2 ; drawmode 
       fcb -10,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-88,-4)->(-88,-4)
       fcb 2 ; drawmode 
       fcb 1,-15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-75,-50)->(-75,-50)
       fcb 2 ; drawmode 
       fcb 46,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-62,-28)->(-62,-28)
       fcb 2 ; drawmode 
       fcb -22,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-48,-51)->(-48,-51)
       fcb 2 ; drawmode 
       fcb 23,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-36,-3)->(-36,-3)
       fcb 2 ; drawmode 
       fcb -48,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-73,-3)->(-73,-3)
       fcb 2 ; drawmode 
       fcb 0,-37 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(-57,-15)->(-57,-15)
       fcb 0 ; drawmode 
       fcb 12,16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 D(-51,-3)->(-51,-3)
       fcb 2 ; drawmode 
       fcb -12,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 M(-45,-42)->(-45,-42)
       fcb 0 ; drawmode 
       fcb 39,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-11,-46)->(-11,-46)
       fcb 2 ; drawmode 
       fcb 4,34 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-11,-1)->(-11,-1)
       fcb 2 ; drawmode 
       fcb -45,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-36,-6)->(-36,-6)
       fcb 2 ; drawmode 
       fcb 5,-25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 M(-28,-31)->(-28,-31)
       fcb 0 ; drawmode 
       fcb 25,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(-11,-33)->(-11,-33)
       fcb 2 ; drawmode 
       fcb 2,17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-1,-32)->(-1,-32)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-5,0)->(-5,0)
       fcb 2 ; drawmode 
       fcb -32,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 M(12,-1)->(12,-1)
       fcb 0 ; drawmode 
       fcb 1,17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(8,-31)->(8,-31)
       fcb 2 ; drawmode 
       fcb 30,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(22,-29)->(22,-29)
       fcb 2 ; drawmode 
       fcb -2,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 M(23,-33)->(33,-33)
       fcb 0 ; drawmode 
       fcb 4,1 ; starx/y relative to previous node
       fdb 0,67 ; dx/dy. dx(abs:67|rel:67) dy(abs:0|rel:0)
; node # 23 D(22,-25)->(35,-25)
       fcb 2 ; drawmode 
       fcb -8,-1 ; starx/y relative to previous node
       fdb 0,20 ; dx/dy. dx(abs:87|rel:20) dy(abs:0|rel:0)
; node # 24 M(21,-11)->(36,-11)
       fcb 0 ; drawmode 
       fcb -14,-1 ; starx/y relative to previous node
       fdb 0,14 ; dx/dy. dx(abs:101|rel:14) dy(abs:0|rel:0)
; node # 25 D(20,-1)->(37,-2)
       fcb 2 ; drawmode 
       fcb -10,-1 ; starx/y relative to previous node
       fdb 6,13 ; dx/dy. dx(abs:114|rel:13) dy(abs:6|rel:6)
; node # 26 M(-11,-46)->(-11,-46)
       fcb 0 ; drawmode 
       fcb 45,-31 ; starx/y relative to previous node
       fdb -6,-114 ; dx/dy. dx(abs:0|rel:-114) dy(abs:0|rel:-6)
; node # 27 D(24,-48)->(24,-48)
       fcb 2 ; drawmode 
       fcb 2,35 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 D(24,-48)->(37,-48)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,87 ; dx/dy. dx(abs:87|rel:87) dy(abs:0|rel:0)
; node # 29 D(20,-1)->(58,-1)
       fcb 2 ; drawmode 
       fcb -47,-4 ; starx/y relative to previous node
       fdb 0,169 ; dx/dy. dx(abs:256|rel:169) dy(abs:0|rel:0)
; node # 30 D(20,-1)->(20,-1)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,-256 ; dx/dy. dx(abs:0|rel:-256) dy(abs:0|rel:0)
; node # 31 D(-36,2)->(-36,2)
       fcb 2 ; drawmode 
       fcb -3,-56 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 32 D(-36,-2)->(-36,-2)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 33 M(-29,-18)->(-29,-18)
       fcb 0 ; drawmode 
       fcb 16,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 D(-11,-15)->(-11,-15)
       fcb 2 ; drawmode 
       fcb -3,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 M(19,15)->(21,15)
       fcb 0 ; drawmode 
       fcb -30,30 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:13|rel:13) dy(abs:0|rel:0)
; node # 36 D(20,-1)->(20,-1)
       fcb 2 ; drawmode 
       fcb 16,1 ; starx/y relative to previous node
       fdb 0,-13 ; dx/dy. dx(abs:0|rel:-13) dy(abs:0|rel:0)
; node # 37 D(24,-48)->(24,-48)
       fcb 2 ; drawmode 
       fcb 47,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 M(20,-1)->(58,-1)
       fcb 0 ; drawmode 
       fcb -47,-4 ; starx/y relative to previous node
       fdb 0,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:0|rel:0)
; node # 39 D(18,19)->(58,19)
       fcb 2 ; drawmode 
       fcb -20,-2 ; starx/y relative to previous node
       fdb 0,13 ; dx/dy. dx(abs:269|rel:13) dy(abs:0|rel:0)
; node # 40 M(16,31)->(58,29)
       fcb 0 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb 13,13 ; dx/dy. dx(abs:282|rel:13) dy(abs:13|rel:13)
; node # 41 D(16,31)->(48,29)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,-67 ; dx/dy. dx(abs:215|rel:-67) dy(abs:13|rel:0)
; node # 42 D(18,19)->(58,19)
       fcb 2 ; drawmode 
       fcb 12,2 ; starx/y relative to previous node
       fdb -13,54 ; dx/dy. dx(abs:269|rel:54) dy(abs:0|rel:-13)
; node # 43 M(16,31)->(58,29)
       fcb 0 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb 13,13 ; dx/dy. dx(abs:282|rel:13) dy(abs:13|rel:13)
; node # 44 D(15,42)->(58,40)
       fcb 2 ; drawmode 
       fcb -11,-1 ; starx/y relative to previous node
       fdb 0,7 ; dx/dy. dx(abs:289|rel:7) dy(abs:13|rel:0)
; node # 45 D(15,42)->(15,42)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb -13,-289 ; dx/dy. dx(abs:0|rel:-289) dy(abs:0|rel:-13)
; node # 46 D(19,14)->(45,14)
       fcb 2 ; drawmode 
       fcb 28,4 ; starx/y relative to previous node
       fdb 0,175 ; dx/dy. dx(abs:175|rel:175) dy(abs:0|rel:0)
; node # 47 D(9,15)->(9,15)
       fcb 2 ; drawmode 
       fcb -1,-10 ; starx/y relative to previous node
       fdb 0,-175 ; dx/dy. dx(abs:0|rel:-175) dy(abs:0|rel:0)
; node # 48 D(15,42)->(15,42)
       fcb 2 ; drawmode 
       fcb -27,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 49 D(-7,44)->(-7,44)
       fcb 2 ; drawmode 
       fcb -2,-22 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 50 D(-3,15)->(-3,15)
       fcb 2 ; drawmode 
       fcb 29,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 51 D(-11,15)->(-11,15)
       fcb 2 ; drawmode 
       fcb 0,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 52 M(-13,1)->(-13,1)
       fcb 0 ; drawmode 
       fcb 14,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 53 D(-7,44)->(-7,44)
       fcb 2 ; drawmode 
       fcb -43,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 54 D(-65,48)->(-65,48)
       fcb 2 ; drawmode 
       fcb -4,-58 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 55 D(-88,-4)->(-88,-4)
       fcb 2 ; drawmode 
       fcb 52,-23 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 56 M(-62,-3)->(-62,-3)
       fcb 0 ; drawmode 
       fcb -1,26 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 57 D(-59,26)->(-59,26)
       fcb 2 ; drawmode 
       fcb -29,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 58 M(-51,47)->(-51,47)
       fcb 0 ; drawmode 
       fcb -21,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 59 D(-36,2)->(-36,2)
       fcb 2 ; drawmode 
       fcb 45,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 60 M(-27,18)->(-27,18)
       fcb 0 ; drawmode 
       fcb -16,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 61 D(-27,33)->(-27,33)
       fcb 2 ; drawmode 
       fcb -15,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 6
vozlogoframe6:
       fcb 38 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(0,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 1 M(-68,-13)->(-68,-13)
       fcb 0 ; drawmode 
       fcb 13,-68 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 2 D(-73,-3)->(-73,-3)
       fcb 2 ; drawmode 
       fcb -10,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 3 D(-88,-4)->(-88,-4)
       fcb 2 ; drawmode 
       fcb 1,-15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 4 D(-75,-50)->(-75,-50)
       fcb 2 ; drawmode 
       fcb 46,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 5 D(-62,-28)->(-62,-28)
       fcb 2 ; drawmode 
       fcb -22,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 6 D(-48,-51)->(-48,-51)
       fcb 2 ; drawmode 
       fcb 23,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 7 D(-36,-3)->(-36,-3)
       fcb 2 ; drawmode 
       fcb -48,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 8 D(-73,-3)->(-73,-3)
       fcb 2 ; drawmode 
       fcb 0,-37 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 9 M(-57,-15)->(-57,-15)
       fcb 0 ; drawmode 
       fcb 12,16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 10 D(-51,-3)->(-51,-3)
       fcb 2 ; drawmode 
       fcb -12,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 11 M(-45,-42)->(-45,-42)
       fcb 0 ; drawmode 
       fcb 39,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 12 D(-11,-46)->(-11,-46)
       fcb 2 ; drawmode 
       fcb 4,34 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 13 D(-11,-1)->(-11,-1)
       fcb 2 ; drawmode 
       fcb -45,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 14 D(-36,-6)->(-36,-6)
       fcb 2 ; drawmode 
       fcb 5,-25 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 15 M(-28,-31)->(-28,-31)
       fcb 0 ; drawmode 
       fcb 25,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 16 D(-11,-33)->(-11,-33)
       fcb 2 ; drawmode 
       fcb 2,17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 17 D(-1,-32)->(-1,-32)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 18 D(-5,0)->(-5,0)
       fcb 2 ; drawmode 
       fcb -32,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 19 M(12,-1)->(12,-1)
       fcb 0 ; drawmode 
       fcb 1,17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 20 D(8,-31)->(8,-31)
       fcb 2 ; drawmode 
       fcb 30,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 21 D(22,-29)->(22,-29)
       fcb 2 ; drawmode 
       fcb -2,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 22 M(33,-33)->(33,-33)
       fcb 0 ; drawmode 
       fcb 4,11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 23 D(35,-25)->(35,-25)
       fcb 2 ; drawmode 
       fcb -8,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 24 M(36,-11)->(36,-11)
       fcb 0 ; drawmode 
       fcb -14,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 25 D(37,-2)->(37,-2)
       fcb 2 ; drawmode 
       fcb -9,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 26 M(-11,-46)->(-11,-46)
       fcb 0 ; drawmode 
       fcb 44,-48 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 27 D(24,-48)->(24,-48)
       fcb 2 ; drawmode 
       fcb 2,35 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 28 D(37,-48)->(59,-49)
       fcb 2 ; drawmode 
       fcb 0,13 ; starx/y relative to previous node
       fdb 6,148 ; dx/dy. dx(abs:148|rel:148) dy(abs:6|rel:6)
; node # 29 D(50,-19)->(64,-20)
       fcb 2 ; drawmode 
       fcb -29,13 ; starx/y relative to previous node
       fdb 0,-54 ; dx/dy. dx(abs:94|rel:-54) dy(abs:6|rel:0)
; node # 30 D(49,-21)->(85,-24)
       fcb 2 ; drawmode 
       fcb 2,-1 ; starx/y relative to previous node
       fdb 14,148 ; dx/dy. dx(abs:242|rel:148) dy(abs:20|rel:14)
; node # 31 D(58,-1)->(86,-2)
       fcb 2 ; drawmode 
       fcb -20,9 ; starx/y relative to previous node
       fdb -14,-54 ; dx/dy. dx(abs:188|rel:-54) dy(abs:6|rel:-14)
; node # 32 D(20,-1)->(20,-1)
       fcb 2 ; drawmode 
       fcb 0,-38 ; starx/y relative to previous node
       fdb -6,-188 ; dx/dy. dx(abs:0|rel:-188) dy(abs:0|rel:-6)
; node # 33 D(-36,2)->(-36,2)
       fcb 2 ; drawmode 
       fcb -3,-56 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 34 D(-36,-2)->(-36,-2)
       fcb 2 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 35 M(-29,-18)->(-29,-18)
       fcb 0 ; drawmode 
       fcb 16,7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 36 D(-11,-15)->(-11,-15)
       fcb 2 ; drawmode 
       fcb -3,18 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 37 M(21,15)->(21,15)
       fcb 0 ; drawmode 
       fcb -30,32 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 38 D(20,-1)->(20,-1)
       fcb 2 ; drawmode 
       fcb 16,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 39 D(24,-48)->(24,-48)
       fcb 2 ; drawmode 
       fcb 47,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 40 M(37,-48)->(37,-48)
       fcb 0 ; drawmode 
       fcb 0,13 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 41 D(58,-1)->(58,-1)
       fcb 2 ; drawmode 
       fcb -47,21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 42 D(58,40)->(58,40)
       fcb 2 ; drawmode 
       fcb -41,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 43 M(58,29)->(58,29)
       fcb 0 ; drawmode 
       fcb 11,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 44 D(48,29)->(48,29)
       fcb 2 ; drawmode 
       fcb 0,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 45 D(58,19)->(58,19)
       fcb 2 ; drawmode 
       fcb 10,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 46 M(58,12)->(72,12)
       fcb 0 ; drawmode 
       fcb 7,0 ; starx/y relative to previous node
       fdb 0,94 ; dx/dy. dx(abs:94|rel:94) dy(abs:0|rel:0)
; node # 47 D(58,12)->(86,11)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 6,94 ; dx/dy. dx(abs:188|rel:94) dy(abs:6|rel:6)
; node # 48 M(58,25)->(71,25)
       fcb 0 ; drawmode 
       fcb -13,0 ; starx/y relative to previous node
       fdb -6,-101 ; dx/dy. dx(abs:87|rel:-101) dy(abs:0|rel:-6)
; node # 49 D(58,25)->(88,23)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 13,115 ; dx/dy. dx(abs:202|rel:115) dy(abs:13|rel:13)
; node # 50 M(58,-1)->(86,-2)
       fcb 0 ; drawmode 
       fcb 26,0 ; starx/y relative to previous node
       fdb -7,-14 ; dx/dy. dx(abs:188|rel:-14) dy(abs:6|rel:-7)
; node # 51 D(58,40)->(90,39)
       fcb 2 ; drawmode 
       fcb -41,0 ; starx/y relative to previous node
       fdb 0,27 ; dx/dy. dx(abs:215|rel:27) dy(abs:6|rel:0)
; node # 52 D(15,42)->(15,42)
       fcb 2 ; drawmode 
       fcb -2,-43 ; starx/y relative to previous node
       fdb -6,-215 ; dx/dy. dx(abs:0|rel:-215) dy(abs:0|rel:-6)
; node # 53 D(45,14)->(45,14)
       fcb 2 ; drawmode 
       fcb 28,30 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 54 D(9,15)->(9,15)
       fcb 2 ; drawmode 
       fcb -1,-36 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 55 D(15,42)->(15,42)
       fcb 2 ; drawmode 
       fcb -27,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 56 D(-7,44)->(-7,44)
       fcb 2 ; drawmode 
       fcb -2,-22 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 57 D(-3,15)->(-3,15)
       fcb 2 ; drawmode 
       fcb 29,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 58 D(-11,15)->(-11,15)
       fcb 2 ; drawmode 
       fcb 0,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 59 M(-13,1)->(-13,1)
       fcb 0 ; drawmode 
       fcb 14,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 60 D(-7,44)->(-7,44)
       fcb 2 ; drawmode 
       fcb -43,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 61 D(-65,48)->(-65,48)
       fcb 2 ; drawmode 
       fcb -4,-58 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 62 D(-88,-4)->(-88,-4)
       fcb 2 ; drawmode 
       fcb 52,-23 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 63 M(-62,-3)->(-62,-3)
       fcb 0 ; drawmode 
       fcb -1,26 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 64 D(-59,26)->(-59,26)
       fcb 2 ; drawmode 
       fcb -29,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 65 M(-51,47)->(-51,47)
       fcb 0 ; drawmode 
       fcb -21,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 66 D(-36,2)->(-36,2)
       fcb 2 ; drawmode 
       fcb 45,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 67 M(-27,18)->(-27,18)
       fcb 0 ; drawmode 
       fcb -16,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 68 D(-27,33)->(-27,33)
       fcb 2 ; drawmode 
       fcb -15,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
