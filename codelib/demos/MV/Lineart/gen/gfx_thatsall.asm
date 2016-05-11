thatsallframecount equ 1 ; number of animations
; index table 
thatsallframetab        fdb thatsallframe0

; Animation 0
thatsallframe0:
; node # 0 M(-94,-2)->(-94,-2)
       fcb 0 ; drawmode 
       fcb 2,-94 ; position relative to previous node
; node # 1 D(-93,0)->(-93,0)
       fcb 2 ; drawmode 
       fcb -2,1 ; position relative to previous node
; node # 2 M(-91,-4)->(-91,-4)
       fcb 0 ; drawmode 
       fcb 4,2 ; position relative to previous node
; node # 3 D(-90,-1)->(-90,-1)
       fcb 2 ; drawmode 
       fcb -3,1 ; position relative to previous node
; node # 4 M(-79,3)->(-79,3)
       fcb 0 ; drawmode 
       fcb -4,11 ; position relative to previous node
; node # 5 D(-82,3)->(-82,3)
       fcb 2 ; drawmode 
       fcb 0,-3 ; position relative to previous node
; node # 6 D(-84,0)->(-84,0)
       fcb 2 ; drawmode 
       fcb 3,-2 ; position relative to previous node
; node # 7 D(-81,-4)->(-81,-4)
       fcb 2 ; drawmode 
       fcb 4,3 ; position relative to previous node
; node # 8 D(-73,-7)->(-73,-7)
       fcb 2 ; drawmode 
       fcb 3,8 ; position relative to previous node
; node # 9 D(-68,-8)->(-68,-8)
       fcb 2 ; drawmode 
       fcb 1,5 ; position relative to previous node
; node # 10 D(-64,-11)->(-64,-11)
       fcb 2 ; drawmode 
       fcb 3,4 ; position relative to previous node
; node # 11 M(-68,-8)->(-68,-8)
       fcb 0 ; drawmode 
       fcb -3,-4 ; position relative to previous node
; node # 12 D(-72,1)->(-72,1)
       fcb 2 ; drawmode 
       fcb -9,-4 ; position relative to previous node
; node # 13 D(-77,20)->(-77,20)
       fcb 2 ; drawmode 
       fcb -19,-5 ; position relative to previous node
; node # 14 D(-80,25)->(-80,25)
       fcb 2 ; drawmode 
       fcb -5,-3 ; position relative to previous node
; node # 15 D(-85,28)->(-85,28)
       fcb 2 ; drawmode 
       fcb -3,-5 ; position relative to previous node
; node # 16 D(-91,26)->(-91,26)
       fcb 2 ; drawmode 
       fcb 2,-6 ; position relative to previous node
; node # 17 D(-93,21)->(-93,21)
       fcb 2 ; drawmode 
       fcb 5,-2 ; position relative to previous node
; node # 18 D(-91,15)->(-91,15)
       fcb 2 ; drawmode 
       fcb 6,2 ; position relative to previous node
; node # 19 D(-86,15)->(-86,15)
       fcb 2 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 20 M(-68,5)->(-68,5)
       fcb 0 ; drawmode 
       fcb 10,18 ; position relative to previous node
; node # 21 D(-59,-4)->(-59,-4)
       fcb 2 ; drawmode 
       fcb 9,9 ; position relative to previous node
; node # 22 D(-57,-10)->(-57,-10)
       fcb 2 ; drawmode 
       fcb 6,2 ; position relative to previous node
; node # 23 D(-58,-13)->(-58,-13)
       fcb 2 ; drawmode 
       fcb 3,-1 ; position relative to previous node
; node # 24 D(-61,-11)->(-61,-11)
       fcb 2 ; drawmode 
       fcb -2,-3 ; position relative to previous node
; node # 25 D(-69,18)->(-69,18)
       fcb 2 ; drawmode 
       fcb -29,-8 ; position relative to previous node
; node # 26 M(-66,7)->(-66,7)
       fcb 0 ; drawmode 
       fcb 11,3 ; position relative to previous node
; node # 27 D(-61,3)->(-61,3)
       fcb 2 ; drawmode 
       fcb 4,5 ; position relative to previous node
; node # 28 D(-59,4)->(-59,4)
       fcb 2 ; drawmode 
       fcb -1,2 ; position relative to previous node
; node # 29 D(-60,14)->(-60,14)
       fcb 2 ; drawmode 
       fcb -10,-1 ; position relative to previous node
; node # 30 D(-58,15)->(-58,15)
       fcb 2 ; drawmode 
       fcb -1,2 ; position relative to previous node
; node # 31 D(-55,10)->(-55,10)
       fcb 2 ; drawmode 
       fcb 5,3 ; position relative to previous node
; node # 32 D(-54,4)->(-54,4)
       fcb 2 ; drawmode 
       fcb 6,1 ; position relative to previous node
; node # 33 D(-51,-1)->(-51,-1)
       fcb 2 ; drawmode 
       fcb 5,3 ; position relative to previous node
; node # 34 D(-47,-1)->(-47,-1)
       fcb 2 ; drawmode 
       fcb 0,4 ; position relative to previous node
; node # 35 M(-47,-2)->(-47,-2)
       fcb 0 ; drawmode 
       fcb 1,0 ; position relative to previous node
; node # 36 D(-47,3)->(-47,3)
       fcb 2 ; drawmode 
       fcb -5,0 ; position relative to previous node
; node # 37 D(-48,10)->(-48,10)
       fcb 2 ; drawmode 
       fcb -7,-1 ; position relative to previous node
; node # 38 D(-52,12)->(-52,12)
       fcb 2 ; drawmode 
       fcb -2,-4 ; position relative to previous node
; node # 39 D(-55,10)->(-55,10)
       fcb 2 ; drawmode 
       fcb 2,-3 ; position relative to previous node
; node # 40 M(-48,10)->(-48,10)
       fcb 0 ; drawmode 
       fcb 0,7 ; position relative to previous node
; node # 41 D(-46,10)->(-46,10)
       fcb 2 ; drawmode 
       fcb 0,2 ; position relative to previous node
; node # 42 D(-42,6)->(-42,6)
       fcb 2 ; drawmode 
       fcb 4,4 ; position relative to previous node
; node # 43 D(-38,-13)->(-38,-13)
       fcb 2 ; drawmode 
       fcb 19,4 ; position relative to previous node
; node # 44 M(-33,-17)->(-33,-17)
       fcb 0 ; drawmode 
       fcb 4,5 ; position relative to previous node
; node # 45 D(-32,-14)->(-32,-14)
       fcb 2 ; drawmode 
       fcb -3,1 ; position relative to previous node
; node # 46 M(-34,-11)->(-34,-11)
       fcb 0 ; drawmode 
       fcb -3,-2 ; position relative to previous node
; node # 47 D(-47,-7)->(-47,-7)
       fcb 2 ; drawmode 
       fcb -4,-13 ; position relative to previous node
; node # 48 M(-42,6)->(-42,6)
       fcb 0 ; drawmode 
       fcb -13,5 ; position relative to previous node
; node # 49 D(-41,8)->(-41,8)
       fcb 2 ; drawmode 
       fcb -2,1 ; position relative to previous node
; node # 50 D(-39,7)->(-39,7)
       fcb 2 ; drawmode 
       fcb 1,2 ; position relative to previous node
; node # 51 D(-35,-1)->(-35,-1)
       fcb 2 ; drawmode 
       fcb 8,4 ; position relative to previous node
; node # 52 D(-32,-5)->(-32,-5)
       fcb 2 ; drawmode 
       fcb 4,3 ; position relative to previous node
; node # 53 D(-31,-3)->(-31,-3)
       fcb 2 ; drawmode 
       fcb -2,1 ; position relative to previous node
; node # 54 D(-29,2)->(-29,2)
       fcb 2 ; drawmode 
       fcb -5,2 ; position relative to previous node
; node # 55 D(-30,5)->(-30,5)
       fcb 2 ; drawmode 
       fcb -3,-1 ; position relative to previous node
; node # 56 D(-33,6)->(-33,6)
       fcb 2 ; drawmode 
       fcb -1,-3 ; position relative to previous node
; node # 57 D(-35,3)->(-35,3)
       fcb 2 ; drawmode 
       fcb 3,-2 ; position relative to previous node
; node # 58 M(-17,1)->(-17,1)
       fcb 0 ; drawmode 
       fcb 2,18 ; position relative to previous node
; node # 59 D(-14,-10)->(-14,-10)
       fcb 2 ; drawmode 
       fcb 11,3 ; position relative to previous node
; node # 60 M(-14,-8)->(-14,-8)
       fcb 0 ; drawmode 
       fcb -2,0 ; position relative to previous node
; node # 61 D(-17,-9)->(-17,-9)
       fcb 2 ; drawmode 
       fcb 1,-3 ; position relative to previous node
; node # 62 D(-20,-8)->(-20,-8)
       fcb 2 ; drawmode 
       fcb -1,-3 ; position relative to previous node
; node # 63 D(-22,-3)->(-22,-3)
       fcb 2 ; drawmode 
       fcb -5,-2 ; position relative to previous node
; node # 64 D(-22,2)->(-22,2)
       fcb 2 ; drawmode 
       fcb -5,0 ; position relative to previous node
; node # 65 D(-20,3)->(-20,3)
       fcb 2 ; drawmode 
       fcb -1,2 ; position relative to previous node
; node # 66 D(-17,1)->(-17,1)
       fcb 2 ; drawmode 
       fcb 2,3 ; position relative to previous node
; node # 67 D(-15,2)->(-15,2)
       fcb 2 ; drawmode 
       fcb -1,2 ; position relative to previous node
; node # 68 D(-11,-2)->(-11,-2)
       fcb 2 ; drawmode 
       fcb 4,4 ; position relative to previous node
; node # 69 D(-3,-15)->(-3,-15)
       fcb 2 ; drawmode 
       fcb 13,8 ; position relative to previous node
; node # 70 D(-1,-21)->(-1,-21)
       fcb 2 ; drawmode 
       fcb 6,2 ; position relative to previous node
; node # 71 D(-1,-25)->(-1,-25)
       fcb 2 ; drawmode 
       fcb 4,0 ; position relative to previous node
; node # 72 D(-4,-24)->(-4,-24)
       fcb 2 ; drawmode 
       fcb -1,-3 ; position relative to previous node
; node # 73 D(-8,-15)->(-8,-15)
       fcb 2 ; drawmode 
       fcb -9,-4 ; position relative to previous node
; node # 74 D(-10,0)->(-10,0)
       fcb 2 ; drawmode 
       fcb -15,-2 ; position relative to previous node
; node # 75 D(-8,1)->(-8,1)
       fcb 2 ; drawmode 
       fcb -1,2 ; position relative to previous node
; node # 76 D(1,-8)->(1,-8)
       fcb 2 ; drawmode 
       fcb 9,9 ; position relative to previous node
; node # 77 D(7,-18)->(7,-18)
       fcb 2 ; drawmode 
       fcb 10,6 ; position relative to previous node
; node # 78 D(8,-26)->(8,-26)
       fcb 2 ; drawmode 
       fcb 8,1 ; position relative to previous node
; node # 79 D(3,-23)->(3,-23)
       fcb 2 ; drawmode 
       fcb -3,-5 ; position relative to previous node
; node # 80 D(0,-12)->(0,-12)
       fcb 2 ; drawmode 
       fcb -11,-3 ; position relative to previous node
; node # 81 D(-1,-2)->(-1,-2)
       fcb 2 ; drawmode 
       fcb -10,-1 ; position relative to previous node
; node # 82 D(1,0)->(1,0)
       fcb 2 ; drawmode 
       fcb -2,2 ; position relative to previous node
; node # 83 D(5,-3)->(5,-3)
       fcb 2 ; drawmode 
       fcb 3,4 ; position relative to previous node
; node # 84 M(17,-9)->(17,-9)
       fcb 0 ; drawmode 
       fcb 6,12 ; position relative to previous node
; node # 85 D(14,-10)->(14,-10)
       fcb 2 ; drawmode 
       fcb 1,-3 ; position relative to previous node
; node # 86 D(12,-5)->(12,-5)
       fcb 2 ; drawmode 
       fcb -5,-2 ; position relative to previous node
; node # 87 D(14,-1)->(14,-1)
       fcb 2 ; drawmode 
       fcb -4,2 ; position relative to previous node
; node # 88 D(19,-1)->(19,-1)
       fcb 2 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 89 D(27,-14)->(27,-14)
       fcb 2 ; drawmode 
       fcb 13,8 ; position relative to previous node
; node # 90 D(29,-20)->(29,-20)
       fcb 2 ; drawmode 
       fcb 6,2 ; position relative to previous node
; node # 91 D(35,-28)->(35,-28)
       fcb 2 ; drawmode 
       fcb 8,6 ; position relative to previous node
; node # 92 M(40,-28)->(40,-28)
       fcb 0 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 93 D(22,-28)->(22,-28)
       fcb 2 ; drawmode 
       fcb 0,-18 ; position relative to previous node
; node # 94 D(19,-23)->(19,-23)
       fcb 2 ; drawmode 
       fcb -5,-3 ; position relative to previous node
; node # 95 D(22,-21)->(22,-21)
       fcb 2 ; drawmode 
       fcb -2,3 ; position relative to previous node
; node # 96 M(20,-13)->(20,-13)
       fcb 0 ; drawmode 
       fcb -8,-2 ; position relative to previous node
; node # 97 D(27,-14)->(27,-14)
       fcb 2 ; drawmode 
       fcb 1,7 ; position relative to previous node
; node # 98 D(34,-12)->(34,-12)
       fcb 2 ; drawmode 
       fcb -2,7 ; position relative to previous node
; node # 99 D(28,-6)->(28,-6)
       fcb 2 ; drawmode 
       fcb -6,-6 ; position relative to previous node
; node # 100 D(30,-1)->(30,-1)
       fcb 2 ; drawmode 
       fcb -5,2 ; position relative to previous node
; node # 101 D(33,0)->(33,0)
       fcb 2 ; drawmode 
       fcb -1,3 ; position relative to previous node
; node # 102 D(38,-5)->(38,-5)
       fcb 2 ; drawmode 
       fcb 5,5 ; position relative to previous node
; node # 103 D(36,-10)->(36,-10)
       fcb 2 ; drawmode 
       fcb 5,-2 ; position relative to previous node
; node # 104 M(37,-8)->(37,-8)
       fcb 0 ; drawmode 
       fcb -2,1 ; position relative to previous node
; node # 105 D(42,-8)->(42,-8)
       fcb 2 ; drawmode 
       fcb 0,5 ; position relative to previous node
; node # 106 D(50,-14)->(50,-14)
       fcb 2 ; drawmode 
       fcb 6,8 ; position relative to previous node
; node # 107 D(53,-25)->(53,-25)
       fcb 2 ; drawmode 
       fcb 11,3 ; position relative to previous node
; node # 108 D(48,-22)->(48,-22)
       fcb 2 ; drawmode 
       fcb -3,-5 ; position relative to previous node
; node # 109 D(41,-3)->(41,-3)
       fcb 2 ; drawmode 
       fcb -19,-7 ; position relative to previous node
; node # 110 D(43,-1)->(43,-1)
       fcb 2 ; drawmode 
       fcb -2,2 ; position relative to previous node
; node # 111 D(51,-5)->(51,-5)
       fcb 2 ; drawmode 
       fcb 4,8 ; position relative to previous node
; node # 112 M(50,0)->(50,0)
       fcb 0 ; drawmode 
       fcb -5,-1 ; position relative to previous node
; node # 113 D(58,-21)->(58,-21)
       fcb 2 ; drawmode 
       fcb 21,8 ; position relative to previous node
; node # 114 D(61,-24)->(61,-24)
       fcb 2 ; drawmode 
       fcb 3,3 ; position relative to previous node
; node # 115 D(63,-21)->(63,-21)
       fcb 2 ; drawmode 
       fcb -3,2 ; position relative to previous node
; node # 116 D(58,-12)->(58,-12)
       fcb 2 ; drawmode 
       fcb -9,-5 ; position relative to previous node
; node # 117 D(53,-9)->(53,-9)
       fcb 2 ; drawmode 
       fcb -3,-5 ; position relative to previous node
; node # 118 D(59,-10)->(59,-10)
       fcb 2 ; drawmode 
       fcb 1,6 ; position relative to previous node
; node # 119 D(61,-6)->(61,-6)
       fcb 2 ; drawmode 
       fcb -4,2 ; position relative to previous node
; node # 120 D(55,-3)->(55,-3)
       fcb 2 ; drawmode 
       fcb -3,-6 ; position relative to previous node
; node # 121 D(51,-5)->(51,-5)
       fcb 2 ; drawmode 
       fcb 2,-4 ; position relative to previous node
; node # 122 M(55,-3)->(55,-3)
       fcb 0 ; drawmode 
       fcb -2,4 ; position relative to previous node
; node # 123 D(55,0)->(55,0)
       fcb 2 ; drawmode 
       fcb -3,0 ; position relative to previous node
; node # 124 D(58,2)->(58,2)
       fcb 2 ; drawmode 
       fcb -2,3 ; position relative to previous node
; node # 125 D(68,-6)->(68,-6)
       fcb 2 ; drawmode 
       fcb 8,10 ; position relative to previous node
; node # 126 D(70,-7)->(70,-7)
       fcb 2 ; drawmode 
       fcb 1,2 ; position relative to previous node
; node # 127 M(68,-6)->(68,-6)
       fcb 0 ; drawmode 
       fcb -1,-2 ; position relative to previous node
; node # 128 D(70,-1)->(70,-1)
       fcb 2 ; drawmode 
       fcb -5,2 ; position relative to previous node
; node # 129 D(67,4)->(67,4)
       fcb 2 ; drawmode 
       fcb -5,-3 ; position relative to previous node
; node # 130 D(64,2)->(64,2)
       fcb 2 ; drawmode 
       fcb 2,-3 ; position relative to previous node
; node # 131 M(72,6)->(72,6)
       fcb 0 ; drawmode 
       fcb -4,8 ; position relative to previous node
; node # 132 D(73,4)->(73,4)
       fcb 2 ; drawmode 
       fcb 2,1 ; position relative to previous node
; node # 133 M(75,0)->(75,0)
       fcb 0 ; drawmode 
       fcb 4,2 ; position relative to previous node
; node # 134 D(84,-18)->(84,-18)
       fcb 2 ; drawmode 
       fcb 18,9 ; position relative to previous node
; node # 135 M(88,-17)->(88,-17)
       fcb 0 ; drawmode 
       fcb -1,4 ; position relative to previous node
; node # 136 D(87,-14)->(87,-14)
       fcb 2 ; drawmode 
       fcb -3,-1 ; position relative to previous node
; node # 137 M(91,-14)->(91,-14)
       fcb 0 ; drawmode 
       fcb 0,4 ; position relative to previous node
; node # 138 D(92,-16)->(92,-16)
       fcb 2 ; drawmode 
       fcb 2,1 ; position relative to previous node
       fcb  1  ; end of anim
