lineartframecount equ 1 ; number of animations
; index table 
lineartframetab        fdb lineartframe0

; Animation 0
lineartframe0:
; node # 0 M(8,16)->(0,0)
       fcb 0 ; drawmode 
       fcb -16,8 ; position relative to previous node
; node # 1 D(-65,22)->(-12,29)
       fcb 2 ; drawmode 
       fcb -6,-73 ; position relative to previous node
; node # 2 D(-123,27)->(-120,7)
       fcb 2 ; drawmode 
       fcb -5,-58 ; position relative to previous node
; node # 3 D(-107,-42)->(-107,-42)
       fcb 2 ; drawmode 
       fcb 69,16 ; position relative to previous node
; node # 4 D(-86,-33)->(-86,-33)
       fcb 2 ; drawmode 
       fcb -9,21 ; position relative to previous node
; node # 5 D(-99,5)->(-99,5)
       fcb 2 ; drawmode 
       fcb -38,-13 ; position relative to previous node
; node # 6 D(-84,-2)->(-84,-2)
       fcb 2 ; drawmode 
       fcb 7,15 ; position relative to previous node
; node # 7 D(-84,-16)->(-84,-16)
       fcb 2 ; drawmode 
       fcb 14,0 ; position relative to previous node
; node # 8 D(-69,-17)->(-69,-17)
       fcb 2 ; drawmode 
       fcb 1,15 ; position relative to previous node
; node # 9 D(-68,22)->(-68,21)
       fcb 2 ; drawmode 
       fcb -39,1 ; position relative to previous node
; node # 10 M(-84,23)->(-81,22)
       fcb 0 ; drawmode 
       fcb -1,-16 ; position relative to previous node
; node # 11 D(-84,-2)->(-81,8)
       fcb 2 ; drawmode 
       fcb 25,0 ; position relative to previous node
; node # 12 M(-69,-11)->(-69,-11)
       fcb 0 ; drawmode 
       fcb 9,15 ; position relative to previous node
; node # 13 D(-34,-24)->(5,-25)
       fcb 2 ; drawmode 
       fcb 13,35 ; position relative to previous node
; node # 14 D(-29,19)->(-30,18)
       fcb 2 ; drawmode 
       fcb -43,5 ; position relative to previous node
; node # 15 M(-48,20)->(-45,20)
       fcb 0 ; drawmode 
       fcb -1,-19 ; position relative to previous node
; node # 16 D(-51,0)->(-51,0)
       fcb 2 ; drawmode 
       fcb 20,-3 ; position relative to previous node
; node # 17 M(-33,-24)->(-29,-21)
       fcb 0 ; drawmode 
       fcb 24,18 ; position relative to previous node
; node # 18 D(7,-22)->(7,-22)
       fcb 2 ; drawmode 
       fcb -2,40 ; position relative to previous node
; node # 19 D(7,4)->(7,1)
       fcb 2 ; drawmode 
       fcb -26,0 ; position relative to previous node
; node # 20 M(-8,-9)->(-8,-9)
       fcb 0 ; drawmode 
       fcb 13,-15 ; position relative to previous node
; node # 21 D(-13,-9)->(-13,-9)
       fcb 2 ; drawmode 
       fcb 0,-5 ; position relative to previous node
; node # 22 M(-15,1)->(-15,1)
       fcb 0 ; drawmode 
       fcb -10,-2 ; position relative to previous node
; node # 23 D(7,4)->(-2,1)
       fcb 2 ; drawmode 
       fcb -3,22 ; position relative to previous node
; node # 24 D(8,16)->(29,23)
       fcb 2 ; drawmode 
       fcb -12,1 ; position relative to previous node
; node # 25 D(112,7)->(112,5)
       fcb 2 ; drawmode 
       fcb 9,104 ; position relative to previous node
; node # 26 D(100,-24)->(100,-24)
       fcb 2 ; drawmode 
       fcb 31,-12 ; position relative to previous node
; node # 27 D(118,-28)->(118,-28)
       fcb 2 ; drawmode 
       fcb 4,18 ; position relative to previous node
; node # 28 D(113,-46)->(113,-46)
       fcb 2 ; drawmode 
       fcb 18,-5 ; position relative to previous node
; node # 29 D(70,-33)->(70,-33)
       fcb 2 ; drawmode 
       fcb -13,-43 ; position relative to previous node
; node # 30 D(64,-9)->(64,-9)
       fcb 2 ; drawmode 
       fcb -24,-6 ; position relative to previous node
; node # 31 D(90,9)->(90,8)
       fcb 2 ; drawmode 
       fcb -18,26 ; position relative to previous node
; node # 32 D(86,-21)->(86,-21)
       fcb 2 ; drawmode 
       fcb 30,-4 ; position relative to previous node
; node # 33 D(66,-17)->(66,-17)
       fcb 2 ; drawmode 
       fcb -4,-20 ; position relative to previous node
; node # 34 M(66,9)->(68,9)
       fcb 0 ; drawmode 
       fcb -26,0 ; position relative to previous node
; node # 35 D(60,1)->(62,3)
       fcb 2 ; drawmode 
       fcb 8,-6 ; position relative to previous node
; node # 36 M(53,-13)->(53,-16)
       fcb 0 ; drawmode 
       fcb 14,-7 ; position relative to previous node
; node # 37 D(52,-19)->(57,-25)
       fcb 2 ; drawmode 
       fcb 6,-1 ; position relative to previous node
; node # 38 M(70,-33)->(53,-42)
       fcb 0 ; drawmode 
       fcb 14,18 ; position relative to previous node
; node # 39 D(7,-22)->(21,-20)
       fcb 2 ; drawmode 
       fcb -11,-63 ; position relative to previous node
; node # 40 M(21,-15)->(21,-16)
       fcb 0 ; drawmode 
       fcb -7,14 ; position relative to previous node
; node # 41 D(23,-9)->(23,-9)
       fcb 2 ; drawmode 
       fcb -6,2 ; position relative to previous node
; node # 42 M(26,0)->(26,0)
       fcb 0 ; drawmode 
       fcb -9,3 ; position relative to previous node
; node # 43 D(30,13)->(30,13)
       fcb 2 ; drawmode 
       fcb -13,4 ; position relative to previous node
; node # 44 M(51,12)->(51,10)
       fcb 0 ; drawmode 
       fcb 1,21 ; position relative to previous node
; node # 45 D(35,-27)->(35,-25)
       fcb 2 ; drawmode 
       fcb 39,-16 ; position relative to previous node
       fcb  1  ; end of anim
