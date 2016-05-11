teapotBframecount equ 18 ; number of animations
teapotBframetotal equ 256 ; total number of frames in animation 
; index table 
teapotBframetab        fdb teapotBframe0
       fdb teapotBframe1
       fdb teapotBframe2
       fdb teapotBframe3
       fdb teapotBframe4
       fdb teapotBframe5
       fdb teapotBframe6
       fdb teapotBframe7
       fdb teapotBframe8
       fdb teapotBframe9
       fdb teapotBframe10
       fdb teapotBframe11
       fdb teapotBframe12
       fdb teapotBframe13
       fdb teapotBframe14
       fdb teapotBframe15
       fdb teapotBframe16
       fdb teapotBframe17

; Animation 0
teapotBframe0:
       fcb 15 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(5,2)->(-4,2)
       fcb 0 ; drawmode 
       fcb -2,5 ; starx/y relative to previous node
       fdb 0,-153 ; dx/dy. dx(abs:-153|rel:-153) dy(abs:0|rel:0)
; node # 1 D(-34,9)->(-42,9)
       fcb 2 ; drawmode 
       fcb -7,-39 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-136|rel:17) dy(abs:0|rel:0)
; node # 2 D(-23,29)->(-29,29)
       fcb 2 ; drawmode 
       fcb -20,11 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-102|rel:34) dy(abs:0|rel:0)
; node # 3 D(7,23)->(-1,23)
       fcb 2 ; drawmode 
       fcb 6,30 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-136|rel:-34) dy(abs:0|rel:0)
; node # 4 D(5,2)->(-4,2)
       fcb 2 ; drawmode 
       fcb 21,-2 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-153|rel:-17) dy(abs:0|rel:0)
; node # 5 D(3,-15)->(-6,-15)
       fcb 2 ; drawmode 
       fcb 17,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-153|rel:0) dy(abs:0|rel:0)
; node # 6 D(-35,-10)->(-43,-10)
       fcb 2 ; drawmode 
       fcb -5,-38 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-136|rel:17) dy(abs:0|rel:0)
; node # 7 D(-35,-44)->(-41,-45)
       fcb 2 ; drawmode 
       fcb 34,0 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:-102|rel:34) dy(abs:17|rel:17)
; node # 8 D(-57,-44)->(-58,-45)
       fcb 2 ; drawmode 
       fcb 0,-22 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:-17|rel:85) dy(abs:17|rel:0)
; node # 9 D(-52,-47)->(-45,-49)
       fcb 2 ; drawmode 
       fcb 3,5 ; starx/y relative to previous node
       fdb 17,136 ; dx/dy. dx(abs:119|rel:136) dy(abs:34|rel:17)
; node # 10 D(-56,0)->(-49,0)
       fcb 2 ; drawmode 
       fcb -47,-4 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:119|rel:0) dy(abs:0|rel:-34)
; node # 11 D(-54,26)->(-48,26)
       fcb 2 ; drawmode 
       fcb -26,2 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:102|rel:-17) dy(abs:0|rel:0)
; node # 12 D(-35,45)->(-30,46)
       fcb 2 ; drawmode 
       fcb -19,19 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:85|rel:-17) dy(abs:-17|rel:-17)
; node # 13 D(1,46)->(10,46)
       fcb 2 ; drawmode 
       fcb -1,36 ; starx/y relative to previous node
       fdb 17,68 ; dx/dy. dx(abs:153|rel:68) dy(abs:0|rel:17)
; node # 14 D(-5,24)->(9,24)
       fcb 2 ; drawmode 
       fcb 22,-6 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:238|rel:85) dy(abs:0|rel:0)
; node # 15 D(-8,-4)->(6,-4)
       fcb 2 ; drawmode 
       fcb 28,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:238|rel:0) dy(abs:0|rel:0)
; node # 16 D(-56,0)->(-49,0)
       fcb 2 ; drawmode 
       fcb -4,-48 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:119|rel:-119) dy(abs:0|rel:0)
; node # 17 D(-62,-3)->(-65,-3)
       fcb 2 ; drawmode 
       fcb 3,-6 ; starx/y relative to previous node
       fdb 0,-170 ; dx/dy. dx(abs:-51|rel:-170) dy(abs:0|rel:0)
; node # 18 D(-57,-44)->(-58,-45)
       fcb 2 ; drawmode 
       fcb 41,5 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:-17|rel:34) dy(abs:17|rel:17)
; node # 19 D(-8,-56)->(-6,-57)
       fcb 2 ; drawmode 
       fcb 12,49 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:34|rel:51) dy(abs:17|rel:0)
; node # 20 D(-52,-47)->(-45,-49)
       fcb 2 ; drawmode 
       fcb -9,-44 ; starx/y relative to previous node
       fdb 17,85 ; dx/dy. dx(abs:119|rel:85) dy(abs:34|rel:17)
; node # 21 D(-14,-55)->(-1,-54)
       fcb 2 ; drawmode 
       fcb 8,38 ; starx/y relative to previous node
       fdb -51,102 ; dx/dy. dx(abs:221|rel:102) dy(abs:-17|rel:-51)
; node # 22 D(-8,-4)->(6,-4)
       fcb 2 ; drawmode 
       fcb -51,6 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:238|rel:17) dy(abs:0|rel:17)
; node # 23 D(46,-13)->(54,-13)
       fcb 2 ; drawmode 
       fcb 9,54 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:136|rel:-102) dy(abs:0|rel:0)
; node # 24 D(51,13)->(58,13)
       fcb 2 ; drawmode 
       fcb -26,5 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:119|rel:-17) dy(abs:0|rel:0)
; node # 25 D(-5,24)->(9,24)
       fcb 2 ; drawmode 
       fcb -11,-56 ; starx/y relative to previous node
       fdb 0,119 ; dx/dy. dx(abs:238|rel:119) dy(abs:0|rel:0)
; node # 26 D(-54,26)->(-48,26)
       fcb 2 ; drawmode 
       fcb -2,-49 ; starx/y relative to previous node
       fdb 0,-136 ; dx/dy. dx(abs:102|rel:-136) dy(abs:0|rel:0)
; node # 27 D(-62,18)->(-65,19)
       fcb 2 ; drawmode 
       fcb 8,-8 ; starx/y relative to previous node
       fdb -17,-153 ; dx/dy. dx(abs:-51|rel:-153) dy(abs:-17|rel:-17)
; node # 28 D(-62,-3)->(-65,-3)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-51|rel:0) dy(abs:0|rel:17)
; node # 29 D(-35,-10)->(-43,-10)
       fcb 2 ; drawmode 
       fcb 7,27 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:-136|rel:-85) dy(abs:0|rel:0)
; node # 30 D(-34,9)->(-42,9)
       fcb 2 ; drawmode 
       fcb -19,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:0|rel:0)
; node # 31 D(-62,18)->(-65,19)
       fcb 2 ; drawmode 
       fcb -9,-28 ; starx/y relative to previous node
       fdb -17,85 ; dx/dy. dx(abs:-51|rel:85) dy(abs:-17|rel:-17)
; node # 32 D(-42,37)->(-44,39)
       fcb 2 ; drawmode 
       fcb -19,20 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:-34|rel:17) dy(abs:-34|rel:-17)
; node # 33 D(-23,29)->(-29,29)
       fcb 2 ; drawmode 
       fcb 8,19 ; starx/y relative to previous node
       fdb 34,-68 ; dx/dy. dx(abs:-102|rel:-68) dy(abs:0|rel:34)
; node # 34 M(-35,45)->(-30,46)
       fcb 0 ; drawmode 
       fcb -16,-12 ; starx/y relative to previous node
       fdb -17,187 ; dx/dy. dx(abs:85|rel:187) dy(abs:-17|rel:-17)
; node # 35 D(-42,37)->(-44,39)
       fcb 2 ; drawmode 
       fcb 8,-7 ; starx/y relative to previous node
       fdb -17,-119 ; dx/dy. dx(abs:-34|rel:-119) dy(abs:-34|rel:-17)
; node # 36 M(-34,9)->(-42,9)
       fcb 0 ; drawmode 
       fcb 28,8 ; starx/y relative to previous node
       fdb 34,-102 ; dx/dy. dx(abs:-136|rel:-102) dy(abs:0|rel:34)
; node # 37 D(-48,-18)->(-58,-18)
       fcb 2 ; drawmode 
       fcb 27,-14 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-170|rel:-34) dy(abs:0|rel:0)
; node # 38 D(-59,-31)->(-71,-31)
       fcb 2 ; drawmode 
       fcb 13,-11 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-204|rel:-34) dy(abs:0|rel:0)
; node # 39 D(-57,-31)->(-68,-32)
       fcb 2 ; drawmode 
       fcb 0,2 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-187|rel:17) dy(abs:17|rel:17)
; node # 40 D(-39,-13)->(-46,-13)
       fcb 2 ; drawmode 
       fcb -18,18 ; starx/y relative to previous node
       fdb -17,68 ; dx/dy. dx(abs:-119|rel:68) dy(abs:0|rel:-17)
; node # 41 D(-34,9)->(-42,9)
       fcb 2 ; drawmode 
       fcb -22,5 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:0|rel:0)
; node # 42 D(-31,-14)->(-38,-14)
       fcb 2 ; drawmode 
       fcb 23,3 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:0|rel:0)
; node # 43 D(-39,-13)->(-46,-13)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:0|rel:0)
; node # 44 M(-49,-32)->(-60,-33)
       fcb 0 ; drawmode 
       fcb 19,-10 ; starx/y relative to previous node
       fdb 17,-68 ; dx/dy. dx(abs:-187|rel:-68) dy(abs:17|rel:17)
; node # 45 D(-57,-31)->(-68,-32)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-187|rel:0) dy(abs:17|rel:0)
; node # 46 M(-59,-31)->(-71,-31)
       fcb 0 ; drawmode 
       fcb 0,-2 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-204|rel:-17) dy(abs:0|rel:-17)
; node # 47 D(-49,-32)->(-60,-33)
       fcb 2 ; drawmode 
       fcb 1,10 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-187|rel:17) dy(abs:17|rel:17)
; node # 48 D(-31,-14)->(-38,-14)
       fcb 2 ; drawmode 
       fcb -18,18 ; starx/y relative to previous node
       fdb -17,68 ; dx/dy. dx(abs:-119|rel:68) dy(abs:0|rel:-17)
; node # 49 M(-35,-44)->(-41,-45)
       fcb 0 ; drawmode 
       fcb 30,-4 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-102|rel:17) dy(abs:17|rel:17)
; node # 50 D(-2,-48)->(-9,-48)
       fcb 2 ; drawmode 
       fcb 4,33 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-119|rel:-17) dy(abs:0|rel:-17)
; node # 51 D(3,-15)->(-6,-15)
       fcb 2 ; drawmode 
       fcb -33,5 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-153|rel:-34) dy(abs:0|rel:0)
; node # 52 D(39,-19)->(32,-19)
       fcb 2 ; drawmode 
       fcb 4,36 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-119|rel:34) dy(abs:0|rel:0)
; node # 53 D(28,-53)->(23,-53)
       fcb 2 ; drawmode 
       fcb 34,-11 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-85|rel:34) dy(abs:0|rel:0)
; node # 54 D(-2,-48)->(-9,-48)
       fcb 2 ; drawmode 
       fcb -5,-30 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-119|rel:-34) dy(abs:0|rel:0)
; node # 55 D(-8,-56)->(-6,-57)
       fcb 2 ; drawmode 
       fcb 8,-6 ; starx/y relative to previous node
       fdb 17,153 ; dx/dy. dx(abs:34|rel:153) dy(abs:17|rel:17)
; node # 56 D(-1,-66)->(0,-66)
       fcb 2 ; drawmode 
       fcb 10,7 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:17|rel:-17) dy(abs:0|rel:-17)
; node # 57 D(-8,-64)->(-7,-65)
       fcb 2 ; drawmode 
       fcb -2,-7 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:17|rel:0) dy(abs:17|rel:17)
; node # 58 D(-17,-64)->(-15,-65)
       fcb 2 ; drawmode 
       fcb 0,-9 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:34|rel:17) dy(abs:17|rel:0)
; node # 59 D(-8,-56)->(-6,-57)
       fcb 2 ; drawmode 
       fcb -8,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:34|rel:0) dy(abs:17|rel:0)
; node # 60 D(28,-53)->(23,-53)
       fcb 2 ; drawmode 
       fcb -3,36 ; starx/y relative to previous node
       fdb -17,-119 ; dx/dy. dx(abs:-85|rel:-119) dy(abs:0|rel:-17)
; node # 61 D(45,-58)->(45,-56)
       fcb 2 ; drawmode 
       fcb 5,17 ; starx/y relative to previous node
       fdb -34,85 ; dx/dy. dx(abs:0|rel:85) dy(abs:-34|rel:-34)
; node # 62 D(-8,-56)->(-6,-57)
       fcb 2 ; drawmode 
       fcb -2,-53 ; starx/y relative to previous node
       fdb 51,34 ; dx/dy. dx(abs:34|rel:34) dy(abs:17|rel:51)
; node # 63 D(-14,-55)->(-1,-54)
       fcb 2 ; drawmode 
       fcb -1,-6 ; starx/y relative to previous node
       fdb -34,187 ; dx/dy. dx(abs:221|rel:187) dy(abs:-17|rel:-34)
; node # 64 D(30,-59)->(38,-58)
       fcb 2 ; drawmode 
       fcb 4,44 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:136|rel:-85) dy(abs:-17|rel:0)
; node # 65 D(46,-13)->(54,-13)
       fcb 2 ; drawmode 
       fcb -46,16 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:136|rel:0) dy(abs:0|rel:17)
; node # 66 D(61,-20)->(59,-18)
       fcb 2 ; drawmode 
       fcb 7,15 ; starx/y relative to previous node
       fdb -34,-170 ; dx/dy. dx(abs:-34|rel:-170) dy(abs:-34|rel:-34)
; node # 67 D(67,2)->(64,3)
       fcb 2 ; drawmode 
       fcb -22,6 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-51|rel:-17) dy(abs:-17|rel:17)
; node # 68 D(51,13)->(58,13)
       fcb 2 ; drawmode 
       fcb -11,-16 ; starx/y relative to previous node
       fdb 17,170 ; dx/dy. dx(abs:119|rel:170) dy(abs:0|rel:17)
; node # 69 D(39,37)->(44,36)
       fcb 2 ; drawmode 
       fcb -24,-12 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:85|rel:-34) dy(abs:17|rel:17)
; node # 70 D(52,27)->(50,26)
       fcb 2 ; drawmode 
       fcb 10,13 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:-34|rel:-119) dy(abs:17|rel:0)
; node # 71 D(67,2)->(64,3)
       fcb 2 ; drawmode 
       fcb 25,15 ; starx/y relative to previous node
       fdb -34,-17 ; dx/dy. dx(abs:-51|rel:-17) dy(abs:-17|rel:-34)
; node # 72 D(43,0)->(35,0)
       fcb 2 ; drawmode 
       fcb 2,-24 ; starx/y relative to previous node
       fdb 17,-85 ; dx/dy. dx(abs:-136|rel:-85) dy(abs:0|rel:17)
; node # 73 D(36,22)->(29,21)
       fcb 2 ; drawmode 
       fcb -22,-7 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:17|rel:17)
; node # 74 D(7,23)->(-1,23)
       fcb 2 ; drawmode 
       fcb -1,-29 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:0|rel:-17)
; node # 75 M(39,37)->(44,36)
       fcb 0 ; drawmode 
       fcb -14,32 ; starx/y relative to previous node
       fdb 17,221 ; dx/dy. dx(abs:85|rel:221) dy(abs:17|rel:17)
; node # 76 D(1,46)->(10,46)
       fcb 2 ; drawmode 
       fcb -9,-38 ; starx/y relative to previous node
       fdb -17,68 ; dx/dy. dx(abs:153|rel:68) dy(abs:0|rel:-17)
; node # 77 M(36,22)->(29,21)
       fcb 0 ; drawmode 
       fcb 24,35 ; starx/y relative to previous node
       fdb 17,-272 ; dx/dy. dx(abs:-119|rel:-272) dy(abs:17|rel:17)
; node # 78 D(52,27)->(50,26)
       fcb 2 ; drawmode 
       fcb -5,16 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:-34|rel:85) dy(abs:17|rel:0)
; node # 79 M(43,0)->(35,0)
       fcb 0 ; drawmode 
       fcb 27,-9 ; starx/y relative to previous node
       fdb -17,-102 ; dx/dy. dx(abs:-136|rel:-102) dy(abs:0|rel:-17)
; node # 80 D(39,-19)->(32,-19)
       fcb 2 ; drawmode 
       fcb 19,-4 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:0|rel:0)
; node # 81 D(61,-20)->(59,-18)
       fcb 2 ; drawmode 
       fcb 1,22 ; starx/y relative to previous node
       fdb -34,85 ; dx/dy. dx(abs:-34|rel:85) dy(abs:-34|rel:-34)
; node # 82 D(45,-58)->(45,-56)
       fcb 2 ; drawmode 
       fcb 38,-16 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:0|rel:34) dy(abs:-34|rel:0)
; node # 83 D(30,-59)->(38,-58)
       fcb 2 ; drawmode 
       fcb 1,-15 ; starx/y relative to previous node
       fdb 17,136 ; dx/dy. dx(abs:136|rel:136) dy(abs:-17|rel:17)
; node # 84 D(-8,-56)->(-6,-57)
       fcb 2 ; drawmode 
       fcb -3,-38 ; starx/y relative to previous node
       fdb 34,-102 ; dx/dy. dx(abs:34|rel:-102) dy(abs:17|rel:34)
; node # 85 M(-1,-66)->(0,-66)
       fcb 0 ; drawmode 
       fcb 10,7 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:17|rel:-17) dy(abs:0|rel:-17)
; node # 86 D(-10,-66)->(-7,-66)
       fcb 2 ; drawmode 
       fcb 0,-9 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:51|rel:34) dy(abs:0|rel:0)
; node # 87 D(-17,-64)->(-15,-65)
       fcb 2 ; drawmode 
       fcb -2,-7 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:34|rel:-17) dy(abs:17|rel:17)
; node # 88 M(-8,-64)->(-7,-65)
       fcb 0 ; drawmode 
       fcb 0,9 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:17|rel:-17) dy(abs:17|rel:0)
; node # 89 D(-8,-56)->(-6,-57)
       fcb 2 ; drawmode 
       fcb -8,0 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:34|rel:17) dy(abs:17|rel:0)
; node # 90 D(-35,-44)->(-41,-45)
       fcb 2 ; drawmode 
       fcb -12,-27 ; starx/y relative to previous node
       fdb 0,-136 ; dx/dy. dx(abs:-102|rel:-136) dy(abs:17|rel:0)
; node # 91 M(-10,-66)->(-7,-66)
       fcb 0 ; drawmode 
       fcb 22,25 ; starx/y relative to previous node
       fdb -17,153 ; dx/dy. dx(abs:51|rel:153) dy(abs:0|rel:-17)
; node # 92 D(-8,-56)->(-6,-57)
       fcb 2 ; drawmode 
       fcb -10,2 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:34|rel:-17) dy(abs:17|rel:17)
; node # 93 M(40,-40)->(46,-39)
       fcb 0 ; drawmode 
       fcb -16,48 ; starx/y relative to previous node
       fdb -34,68 ; dx/dy. dx(abs:102|rel:68) dy(abs:-17|rel:-34)
; node # 94 D(76,-45)->(85,-43)
       fcb 2 ; drawmode 
       fcb 5,36 ; starx/y relative to previous node
       fdb -17,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:-34|rel:-17)
; node # 95 D(78,-23)->(87,-22)
       fcb 2 ; drawmode 
       fcb -22,2 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:-17|rel:17)
; node # 96 D(52,2)->(59,2)
       fcb 2 ; drawmode 
       fcb -25,-26 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:119|rel:-34) dy(abs:0|rel:17)
; node # 97 D(43,4)->(52,4)
       fcb 2 ; drawmode 
       fcb -2,-9 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:153|rel:34) dy(abs:0|rel:0)
; node # 98 D(69,-21)->(81,-20)
       fcb 2 ; drawmode 
       fcb 25,26 ; starx/y relative to previous node
       fdb -17,51 ; dx/dy. dx(abs:204|rel:51) dy(abs:-17|rel:-17)
; node # 99 D(66,-44)->(80,-42)
       fcb 2 ; drawmode 
       fcb 23,-3 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:238|rel:34) dy(abs:-34|rel:-17)
; node # 100 D(31,-39)->(39,-38)
       fcb 2 ; drawmode 
       fcb -5,-35 ; starx/y relative to previous node
       fdb 17,-102 ; dx/dy. dx(abs:136|rel:-102) dy(abs:-17|rel:17)
; node # 101 D(40,-40)->(46,-39)
       fcb 2 ; drawmode 
       fcb 1,9 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:102|rel:-34) dy(abs:-17|rel:0)
; node # 102 D(34,-46)->(42,-45)
       fcb 2 ; drawmode 
       fcb 6,-6 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:136|rel:34) dy(abs:-17|rel:0)
; node # 103 D(77,-53)->(90,-51)
       fcb 2 ; drawmode 
       fcb 7,43 ; starx/y relative to previous node
       fdb -17,85 ; dx/dy. dx(abs:221|rel:85) dy(abs:-34|rel:-17)
; node # 104 D(81,-15)->(92,-15)
       fcb 2 ; drawmode 
       fcb -38,4 ; starx/y relative to previous node
       fdb 34,-34 ; dx/dy. dx(abs:187|rel:-34) dy(abs:0|rel:34)
; node # 105 D(51,13)->(58,13)
       fcb 2 ; drawmode 
       fcb -28,-30 ; starx/y relative to previous node
       fdb 0,-68 ; dx/dy. dx(abs:119|rel:-68) dy(abs:0|rel:0)
; node # 106 D(43,4)->(52,4)
       fcb 2 ; drawmode 
       fcb 9,-8 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:153|rel:34) dy(abs:0|rel:0)
; node # 107 M(43,0)->(35,0)
       fcb 0 ; drawmode 
       fcb 4,0 ; starx/y relative to previous node
       fdb 0,-289 ; dx/dy. dx(abs:-136|rel:-289) dy(abs:0|rel:0)
; node # 108 D(5,2)->(-4,2)
       fcb 2 ; drawmode 
       fcb -2,-38 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-153|rel:-17) dy(abs:0|rel:0)
; node # 109 M(28,-1)->(28,-1)
       fcb 0 ; drawmode 
       fcb 3,23 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:0|rel:153) dy(abs:0|rel:0)
; node # 110 M(66,-44)->(80,-42)
       fcb 0 ; drawmode 
       fcb 43,38 ; starx/y relative to previous node
       fdb -34,238 ; dx/dy. dx(abs:238|rel:238) dy(abs:-34|rel:-34)
; node # 111 D(77,-53)->(90,-51)
       fcb 2 ; drawmode 
       fcb 9,11 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:221|rel:-17) dy(abs:-34|rel:0)
; node # 112 M(51,13)->(58,13)
       fcb 0 ; drawmode 
       fcb -66,-26 ; starx/y relative to previous node
       fdb 34,-102 ; dx/dy. dx(abs:119|rel:-102) dy(abs:0|rel:34)
; node # 113 D(52,2)->(59,2)
       fcb 2 ; drawmode 
       fcb 11,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:119|rel:0) dy(abs:0|rel:0)
; node # 114 M(78,-23)->(87,-22)
       fcb 0 ; drawmode 
       fcb 25,26 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:153|rel:34) dy(abs:-17|rel:-17)
; node # 115 D(81,-15)->(92,-15)
       fcb 2 ; drawmode 
       fcb -8,3 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:187|rel:34) dy(abs:0|rel:17)
; node # 116 D(69,-21)->(81,-20)
       fcb 2 ; drawmode 
       fcb 6,-12 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:204|rel:17) dy(abs:-17|rel:-17)
; node # 117 D(78,-23)->(87,-22)
       fcb 2 ; drawmode 
       fcb 2,9 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:153|rel:-51) dy(abs:-17|rel:0)
; node # 118 M(66,-44)->(80,-42)
       fcb 0 ; drawmode 
       fcb 21,-12 ; starx/y relative to previous node
       fdb -17,85 ; dx/dy. dx(abs:238|rel:85) dy(abs:-34|rel:-17)
; node # 119 D(76,-45)->(85,-43)
       fcb 2 ; drawmode 
       fcb 1,10 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:153|rel:-85) dy(abs:-34|rel:0)
; node # 120 M(76,-45)->(85,-43)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:-34|rel:0)
; node # 121 D(77,-53)->(90,-51)
       fcb 2 ; drawmode 
       fcb 8,1 ; starx/y relative to previous node
       fdb 0,68 ; dx/dy. dx(abs:221|rel:68) dy(abs:-34|rel:0)
; node # 122 M(31,-39)->(39,-38)
       fcb 0 ; drawmode 
       fcb -14,-46 ; starx/y relative to previous node
       fdb 17,-85 ; dx/dy. dx(abs:136|rel:-85) dy(abs:-17|rel:17)
; node # 123 D(34,-46)->(42,-45)
       fcb 2 ; drawmode 
       fcb 7,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:136|rel:0) dy(abs:-17|rel:0)
       fcb  1  ; end of anim
; Animation 1
teapotBframe1:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-4,2)->(-13,2)
       fcb 0 ; drawmode 
       fcb -2,-4 ; starx/y relative to previous node
       fdb 0,-164 ; dx/dy. dx(abs:-164|rel:-164) dy(abs:0|rel:0)
; node # 1 D(-42,9)->(-49,10)
       fcb 2 ; drawmode 
       fcb -7,-38 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:-18|rel:-18)
; node # 2 D(-29,29)->(-35,30)
       fcb 2 ; drawmode 
       fcb -20,13 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:-18|rel:0)
; node # 3 D(-1,23)->(-8,23)
       fcb 2 ; drawmode 
       fcb 6,28 ; starx/y relative to previous node
       fdb 18,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:18)
; node # 4 D(-4,2)->(-13,2)
       fcb 2 ; drawmode 
       fcb 21,-3 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 5 D(-6,-15)->(-14,-16)
       fcb 2 ; drawmode 
       fcb 17,-2 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:18|rel:18)
; node # 6 D(-43,-10)->(-49,-10)
       fcb 2 ; drawmode 
       fcb -5,-37 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:-18)
; node # 7 D(-41,-45)->(-45,-47)
       fcb 2 ; drawmode 
       fcb 35,2 ; starx/y relative to previous node
       fdb 36,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:36|rel:36)
; node # 8 D(-58,-45)->(-57,-47)
       fcb 2 ; drawmode 
       fcb 0,-17 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:18|rel:91) dy(abs:36|rel:0)
; node # 9 D(-45,-49)->(-36,-50)
       fcb 2 ; drawmode 
       fcb 4,13 ; starx/y relative to previous node
       fdb -18,146 ; dx/dy. dx(abs:164|rel:146) dy(abs:18|rel:-18)
; node # 10 D(-49,0)->(-39,0)
       fcb 2 ; drawmode 
       fcb -49,-4 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:182|rel:18) dy(abs:0|rel:-18)
; node # 11 D(-48,26)->(-38,27)
       fcb 2 ; drawmode 
       fcb -26,1 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:182|rel:0) dy(abs:-18|rel:-18)
; node # 12 D(-30,46)->(-24,47)
       fcb 2 ; drawmode 
       fcb -20,18 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:109|rel:-73) dy(abs:-18|rel:0)
; node # 13 D(10,46)->(18,45)
       fcb 2 ; drawmode 
       fcb 0,40 ; starx/y relative to previous node
       fdb 36,37 ; dx/dy. dx(abs:146|rel:37) dy(abs:18|rel:36)
; node # 14 D(9,24)->(23,24)
       fcb 2 ; drawmode 
       fcb 22,-1 ; starx/y relative to previous node
       fdb -18,110 ; dx/dy. dx(abs:256|rel:110) dy(abs:0|rel:-18)
; node # 15 D(6,-4)->(20,-4)
       fcb 2 ; drawmode 
       fcb 28,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:256|rel:0) dy(abs:0|rel:0)
; node # 16 D(-49,0)->(-39,0)
       fcb 2 ; drawmode 
       fcb -4,-55 ; starx/y relative to previous node
       fdb 0,-74 ; dx/dy. dx(abs:182|rel:-74) dy(abs:0|rel:0)
; node # 17 D(-65,-3)->(-65,-3)
       fcb 2 ; drawmode 
       fcb 3,-16 ; starx/y relative to previous node
       fdb 0,-182 ; dx/dy. dx(abs:0|rel:-182) dy(abs:0|rel:0)
; node # 18 D(-58,-45)->(-57,-47)
       fcb 2 ; drawmode 
       fcb 42,7 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:36|rel:36)
; node # 19 D(-6,-57)->(-6,-57)
       fcb 2 ; drawmode 
       fcb 12,52 ; starx/y relative to previous node
       fdb -36,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:-36)
; node # 20 D(-45,-49)->(-36,-50)
       fcb 2 ; drawmode 
       fcb -8,-39 ; starx/y relative to previous node
       fdb 18,164 ; dx/dy. dx(abs:164|rel:164) dy(abs:18|rel:18)
; node # 21 D(-1,-54)->(11,-54)
       fcb 2 ; drawmode 
       fcb 5,44 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:219|rel:55) dy(abs:0|rel:-18)
; node # 22 D(6,-4)->(20,-4)
       fcb 2 ; drawmode 
       fcb -50,7 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:256|rel:37) dy(abs:0|rel:0)
; node # 23 D(54,-13)->(59,-12)
       fcb 2 ; drawmode 
       fcb 9,48 ; starx/y relative to previous node
       fdb -18,-165 ; dx/dy. dx(abs:91|rel:-165) dy(abs:-18|rel:-18)
; node # 24 D(58,13)->(63,12)
       fcb 2 ; drawmode 
       fcb -26,4 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:91|rel:0) dy(abs:18|rel:36)
; node # 25 D(9,24)->(23,24)
       fcb 2 ; drawmode 
       fcb -11,-49 ; starx/y relative to previous node
       fdb -18,165 ; dx/dy. dx(abs:256|rel:165) dy(abs:0|rel:-18)
; node # 26 D(-48,26)->(-38,27)
       fcb 2 ; drawmode 
       fcb -2,-57 ; starx/y relative to previous node
       fdb -18,-74 ; dx/dy. dx(abs:182|rel:-74) dy(abs:-18|rel:-18)
; node # 27 D(-65,19)->(-66,20)
       fcb 2 ; drawmode 
       fcb 7,-17 ; starx/y relative to previous node
       fdb 0,-200 ; dx/dy. dx(abs:-18|rel:-200) dy(abs:-18|rel:0)
; node # 28 D(-65,-3)->(-65,-3)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:18)
; node # 29 D(-43,-10)->(-49,-10)
       fcb 2 ; drawmode 
       fcb 7,22 ; starx/y relative to previous node
       fdb 0,-109 ; dx/dy. dx(abs:-109|rel:-109) dy(abs:0|rel:0)
; node # 30 D(-42,9)->(-49,10)
       fcb 2 ; drawmode 
       fcb -19,1 ; starx/y relative to previous node
       fdb -18,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:-18|rel:-18)
; node # 31 D(-65,19)->(-66,20)
       fcb 2 ; drawmode 
       fcb -10,-23 ; starx/y relative to previous node
       fdb 0,110 ; dx/dy. dx(abs:-18|rel:110) dy(abs:-18|rel:0)
; node # 32 D(-44,39)->(-45,40)
       fcb 2 ; drawmode 
       fcb -20,21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:-18|rel:0)
; node # 33 D(-29,29)->(-35,30)
       fcb 2 ; drawmode 
       fcb 10,15 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:-109|rel:-91) dy(abs:-18|rel:0)
; node # 34 M(-30,46)->(-24,47)
       fcb 0 ; drawmode 
       fcb -17,-1 ; starx/y relative to previous node
       fdb 0,218 ; dx/dy. dx(abs:109|rel:218) dy(abs:-18|rel:0)
; node # 35 D(-44,39)->(-45,40)
       fcb 2 ; drawmode 
       fcb 7,-14 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-18|rel:-127) dy(abs:-18|rel:0)
; node # 36 M(-42,9)->(-49,10)
       fcb 0 ; drawmode 
       fcb 30,2 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:-128|rel:-110) dy(abs:-18|rel:0)
; node # 37 D(-58,-18)->(-67,-19)
       fcb 2 ; drawmode 
       fcb 27,-16 ; starx/y relative to previous node
       fdb 36,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:18|rel:36)
; node # 38 D(-71,-31)->(-83,-33)
       fcb 2 ; drawmode 
       fcb 13,-13 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-219|rel:-55) dy(abs:36|rel:18)
; node # 39 D(-68,-32)->(-77,-33)
       fcb 2 ; drawmode 
       fcb 1,3 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-164|rel:55) dy(abs:18|rel:-18)
; node # 40 D(-46,-13)->(-51,-13)
       fcb 2 ; drawmode 
       fcb -19,22 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:0|rel:-18)
; node # 41 D(-42,9)->(-49,10)
       fcb 2 ; drawmode 
       fcb -22,4 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:-18|rel:-18)
; node # 42 D(-38,-14)->(-44,-15)
       fcb 2 ; drawmode 
       fcb 23,4 ; starx/y relative to previous node
       fdb 36,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:18|rel:36)
; node # 43 D(-46,-13)->(-51,-13)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:0|rel:-18)
; node # 44 M(-60,-33)->(-71,-34)
       fcb 0 ; drawmode 
       fcb 20,-14 ; starx/y relative to previous node
       fdb 18,-110 ; dx/dy. dx(abs:-201|rel:-110) dy(abs:18|rel:18)
; node # 45 D(-68,-32)->(-77,-33)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-164|rel:37) dy(abs:18|rel:0)
; node # 46 M(-71,-31)->(-83,-33)
       fcb 0 ; drawmode 
       fcb -1,-3 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-219|rel:-55) dy(abs:36|rel:18)
; node # 47 D(-60,-33)->(-71,-34)
       fcb 2 ; drawmode 
       fcb 2,11 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:18|rel:-18)
; node # 48 D(-38,-14)->(-44,-15)
       fcb 2 ; drawmode 
       fcb -19,22 ; starx/y relative to previous node
       fdb 0,92 ; dx/dy. dx(abs:-109|rel:92) dy(abs:18|rel:0)
; node # 49 M(-41,-45)->(-45,-47)
       fcb 0 ; drawmode 
       fcb 31,-3 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:36|rel:18)
; node # 50 D(-9,-48)->(-16,-49)
       fcb 2 ; drawmode 
       fcb 3,32 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:18|rel:-18)
; node # 51 D(-6,-15)->(-14,-16)
       fcb 2 ; drawmode 
       fcb -33,3 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:18|rel:0)
; node # 52 D(32,-19)->(25,-18)
       fcb 2 ; drawmode 
       fcb 4,38 ; starx/y relative to previous node
       fdb -36,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:-18|rel:-36)
; node # 53 D(23,-53)->(17,-52)
       fcb 2 ; drawmode 
       fcb 34,-9 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:-18|rel:0)
; node # 54 D(-9,-48)->(-16,-49)
       fcb 2 ; drawmode 
       fcb -5,-32 ; starx/y relative to previous node
       fdb 36,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:18|rel:36)
; node # 55 D(-6,-57)->(-6,-57)
       fcb 2 ; drawmode 
       fcb 9,3 ; starx/y relative to previous node
       fdb -18,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:-18)
; node # 56 D(0,-66)->(1,-66)
       fcb 2 ; drawmode 
       fcb 9,6 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:0|rel:0)
; node # 57 D(-7,-65)->(-8,-65)
       fcb 2 ; drawmode 
       fcb -1,-7 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:0|rel:0)
; node # 58 D(-15,-65)->(-13,-65)
       fcb 2 ; drawmode 
       fcb 0,-8 ; starx/y relative to previous node
       fdb 0,54 ; dx/dy. dx(abs:36|rel:54) dy(abs:0|rel:0)
; node # 59 D(-6,-57)->(-5,-57)
       fcb 2 ; drawmode 
       fcb -8,9 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:0|rel:0)
; node # 60 D(23,-53)->(17,-52)
       fcb 2 ; drawmode 
       fcb -4,29 ; starx/y relative to previous node
       fdb -18,-127 ; dx/dy. dx(abs:-109|rel:-127) dy(abs:-18|rel:-18)
; node # 61 D(45,-56)->(43,-55)
       fcb 2 ; drawmode 
       fcb 3,22 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-36|rel:73) dy(abs:-18|rel:0)
; node # 62 D(-6,-57)->(-5,-57)
       fcb 2 ; drawmode 
       fcb 1,-51 ; starx/y relative to previous node
       fdb 18,54 ; dx/dy. dx(abs:18|rel:54) dy(abs:0|rel:18)
; node # 63 D(-1,-54)->(11,-54)
       fcb 2 ; drawmode 
       fcb -3,5 ; starx/y relative to previous node
       fdb 0,201 ; dx/dy. dx(abs:219|rel:201) dy(abs:0|rel:0)
; node # 64 D(38,-58)->(44,-56)
       fcb 2 ; drawmode 
       fcb 4,39 ; starx/y relative to previous node
       fdb -36,-110 ; dx/dy. dx(abs:109|rel:-110) dy(abs:-36|rel:-36)
; node # 65 D(54,-13)->(59,-12)
       fcb 2 ; drawmode 
       fcb -45,16 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:91|rel:-18) dy(abs:-18|rel:18)
; node # 66 D(59,-18)->(56,-18)
       fcb 2 ; drawmode 
       fcb 5,5 ; starx/y relative to previous node
       fdb 18,-145 ; dx/dy. dx(abs:-54|rel:-145) dy(abs:0|rel:18)
; node # 67 D(64,3)->(60,3)
       fcb 2 ; drawmode 
       fcb -21,5 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-73|rel:-19) dy(abs:0|rel:0)
; node # 68 D(58,13)->(63,12)
       fcb 2 ; drawmode 
       fcb -10,-6 ; starx/y relative to previous node
       fdb 18,164 ; dx/dy. dx(abs:91|rel:164) dy(abs:18|rel:18)
; node # 69 D(44,36)->(47,35)
       fcb 2 ; drawmode 
       fcb -23,-14 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:54|rel:-37) dy(abs:18|rel:0)
; node # 70 D(50,26)->(46,25)
       fcb 2 ; drawmode 
       fcb 10,6 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-73|rel:-127) dy(abs:18|rel:0)
; node # 71 D(64,3)->(60,3)
       fcb 2 ; drawmode 
       fcb 23,14 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-73|rel:0) dy(abs:0|rel:-18)
; node # 72 D(35,0)->(26,0)
       fcb 2 ; drawmode 
       fcb 3,-29 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:-164|rel:-91) dy(abs:0|rel:0)
; node # 73 D(29,21)->(22,21)
       fcb 2 ; drawmode 
       fcb -21,-6 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 74 D(-1,23)->(-8,23)
       fcb 2 ; drawmode 
       fcb -2,-30 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:0)
; node # 75 M(44,36)->(47,35)
       fcb 0 ; drawmode 
       fcb -13,45 ; starx/y relative to previous node
       fdb 18,182 ; dx/dy. dx(abs:54|rel:182) dy(abs:18|rel:18)
; node # 76 D(10,46)->(18,45)
       fcb 2 ; drawmode 
       fcb -10,-34 ; starx/y relative to previous node
       fdb 0,92 ; dx/dy. dx(abs:146|rel:92) dy(abs:18|rel:0)
; node # 77 M(29,21)->(22,21)
       fcb 0 ; drawmode 
       fcb 25,19 ; starx/y relative to previous node
       fdb -18,-274 ; dx/dy. dx(abs:-128|rel:-274) dy(abs:0|rel:-18)
; node # 78 D(50,26)->(46,25)
       fcb 2 ; drawmode 
       fcb -5,21 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-73|rel:55) dy(abs:18|rel:18)
; node # 79 M(35,0)->(26,0)
       fcb 0 ; drawmode 
       fcb 26,-15 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:-164|rel:-91) dy(abs:0|rel:-18)
; node # 80 D(32,-19)->(25,-18)
       fcb 2 ; drawmode 
       fcb 19,-3 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:-18|rel:-18)
; node # 81 D(59,-18)->(56,-18)
       fcb 2 ; drawmode 
       fcb -1,27 ; starx/y relative to previous node
       fdb 18,74 ; dx/dy. dx(abs:-54|rel:74) dy(abs:0|rel:18)
; node # 82 D(45,-56)->(43,-55)
       fcb 2 ; drawmode 
       fcb 38,-14 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:-18|rel:-18)
; node # 83 D(38,-58)->(44,-56)
       fcb 2 ; drawmode 
       fcb 2,-7 ; starx/y relative to previous node
       fdb -18,145 ; dx/dy. dx(abs:109|rel:145) dy(abs:-36|rel:-18)
; node # 84 D(-6,-57)->(-5,-57)
       fcb 2 ; drawmode 
       fcb -1,-44 ; starx/y relative to previous node
       fdb 36,-91 ; dx/dy. dx(abs:18|rel:-91) dy(abs:0|rel:36)
; node # 85 M(0,-66)->(1,-66)
       fcb 0 ; drawmode 
       fcb 9,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:0)
; node # 86 D(-7,-66)->(-4,-67)
       fcb 2 ; drawmode 
       fcb 0,-7 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:54|rel:36) dy(abs:18|rel:18)
; node # 87 D(-15,-65)->(-13,-65)
       fcb 2 ; drawmode 
       fcb -1,-8 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:36|rel:-18) dy(abs:0|rel:-18)
; node # 88 M(-7,-65)->(-8,-65)
       fcb 0 ; drawmode 
       fcb 0,8 ; starx/y relative to previous node
       fdb 0,-54 ; dx/dy. dx(abs:-18|rel:-54) dy(abs:0|rel:0)
; node # 89 D(-6,-57)->(-5,-57)
       fcb 2 ; drawmode 
       fcb -8,1 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:18|rel:36) dy(abs:0|rel:0)
; node # 90 D(-41,-45)->(-45,-47)
       fcb 2 ; drawmode 
       fcb -12,-35 ; starx/y relative to previous node
       fdb 36,-91 ; dx/dy. dx(abs:-73|rel:-91) dy(abs:36|rel:36)
; node # 91 M(-7,-66)->(-4,-67)
       fcb 0 ; drawmode 
       fcb 21,34 ; starx/y relative to previous node
       fdb -18,127 ; dx/dy. dx(abs:54|rel:127) dy(abs:18|rel:-18)
; node # 92 D(-6,-57)->(-5,-57)
       fcb 2 ; drawmode 
       fcb -9,1 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:0|rel:-18)
; node # 93 M(46,-39)->(51,-37)
       fcb 0 ; drawmode 
       fcb -18,52 ; starx/y relative to previous node
       fdb -36,73 ; dx/dy. dx(abs:91|rel:73) dy(abs:-36|rel:-36)
; node # 94 D(85,-43)->(92,-41)
       fcb 2 ; drawmode 
       fcb 4,39 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:128|rel:37) dy(abs:-36|rel:0)
; node # 95 D(87,-22)->(93,-21)
       fcb 2 ; drawmode 
       fcb -21,2 ; starx/y relative to previous node
       fdb 18,-19 ; dx/dy. dx(abs:109|rel:-19) dy(abs:-18|rel:18)
; node # 96 D(59,2)->(60,3)
       fcb 2 ; drawmode 
       fcb -24,-28 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:18|rel:-91) dy(abs:-18|rel:0)
; node # 97 D(52,4)->(58,4)
       fcb 2 ; drawmode 
       fcb -2,-7 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:109|rel:91) dy(abs:0|rel:18)
; node # 98 D(81,-20)->(89,-20)
       fcb 2 ; drawmode 
       fcb 24,29 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:146|rel:37) dy(abs:0|rel:0)
; node # 99 D(80,-42)->(89,-40)
       fcb 2 ; drawmode 
       fcb 22,-1 ; starx/y relative to previous node
       fdb -36,18 ; dx/dy. dx(abs:164|rel:18) dy(abs:-36|rel:-36)
; node # 100 D(39,-38)->(46,-37)
       fcb 2 ; drawmode 
       fcb -4,-41 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:128|rel:-36) dy(abs:-18|rel:18)
; node # 101 D(46,-39)->(51,-37)
       fcb 2 ; drawmode 
       fcb 1,7 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:91|rel:-37) dy(abs:-36|rel:-18)
; node # 102 D(42,-45)->(48,-44)
       fcb 2 ; drawmode 
       fcb 6,-4 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:109|rel:18) dy(abs:-18|rel:18)
; node # 103 D(90,-51)->(97,-48)
       fcb 2 ; drawmode 
       fcb 6,48 ; starx/y relative to previous node
       fdb -36,19 ; dx/dy. dx(abs:128|rel:19) dy(abs:-54|rel:-36)
; node # 104 D(92,-15)->(99,-13)
       fcb 2 ; drawmode 
       fcb -36,2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:128|rel:0) dy(abs:-36|rel:18)
; node # 105 D(58,13)->(63,12)
       fcb 2 ; drawmode 
       fcb -28,-34 ; starx/y relative to previous node
       fdb 54,-37 ; dx/dy. dx(abs:91|rel:-37) dy(abs:18|rel:54)
; node # 106 D(52,4)->(58,4)
       fcb 2 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:109|rel:18) dy(abs:0|rel:-18)
; node # 107 M(35,0)->(26,0)
       fcb 0 ; drawmode 
       fcb 4,-17 ; starx/y relative to previous node
       fdb 0,-273 ; dx/dy. dx(abs:-164|rel:-273) dy(abs:0|rel:0)
; node # 108 D(-4,2)->(-13,2)
       fcb 2 ; drawmode 
       fcb -2,-39 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 109 M(28,-1)->(28,-1)
       fcb 0 ; drawmode 
       fcb 3,32 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:0|rel:164) dy(abs:0|rel:0)
; node # 110 M(80,-42)->(89,-40)
       fcb 0 ; drawmode 
       fcb 41,52 ; starx/y relative to previous node
       fdb -36,164 ; dx/dy. dx(abs:164|rel:164) dy(abs:-36|rel:-36)
; node # 111 D(90,-51)->(97,-48)
       fcb 2 ; drawmode 
       fcb 9,10 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:128|rel:-36) dy(abs:-54|rel:-18)
; node # 112 M(58,13)->(63,12)
       fcb 0 ; drawmode 
       fcb -64,-32 ; starx/y relative to previous node
       fdb 72,-37 ; dx/dy. dx(abs:91|rel:-37) dy(abs:18|rel:72)
; node # 113 D(59,2)->(60,3)
       fcb 2 ; drawmode 
       fcb 11,1 ; starx/y relative to previous node
       fdb -36,-73 ; dx/dy. dx(abs:18|rel:-73) dy(abs:-18|rel:-36)
; node # 114 M(87,-22)->(93,-21)
       fcb 0 ; drawmode 
       fcb 24,28 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:109|rel:91) dy(abs:-18|rel:0)
; node # 115 D(92,-15)->(99,-13)
       fcb 2 ; drawmode 
       fcb -7,5 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:128|rel:19) dy(abs:-36|rel:-18)
; node # 116 D(81,-20)->(89,-20)
       fcb 2 ; drawmode 
       fcb 5,-11 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:146|rel:18) dy(abs:0|rel:36)
; node # 117 D(87,-22)->(93,-21)
       fcb 2 ; drawmode 
       fcb 2,6 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:109|rel:-37) dy(abs:-18|rel:-18)
; node # 118 M(80,-42)->(89,-40)
       fcb 0 ; drawmode 
       fcb 20,-7 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:164|rel:55) dy(abs:-36|rel:-18)
; node # 119 D(85,-43)->(92,-41)
       fcb 2 ; drawmode 
       fcb 1,5 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:128|rel:-36) dy(abs:-36|rel:0)
; node # 120 M(85,-43)->(92,-41)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:128|rel:0) dy(abs:-36|rel:0)
; node # 121 D(90,-51)->(97,-48)
       fcb 2 ; drawmode 
       fcb 8,5 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:128|rel:0) dy(abs:-54|rel:-18)
; node # 122 M(39,-38)->(46,-37)
       fcb 0 ; drawmode 
       fcb -13,-51 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:128|rel:0) dy(abs:-18|rel:36)
; node # 123 D(42,-45)->(48,-44)
       fcb 2 ; drawmode 
       fcb 7,3 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:109|rel:-19) dy(abs:-18|rel:0)
       fcb  1  ; end of anim
; Animation 2
teapotBframe2:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-13,2)->(-22,2)
       fcb 0 ; drawmode 
       fcb -2,-13 ; starx/y relative to previous node
       fdb 0,-164 ; dx/dy. dx(abs:-164|rel:-164) dy(abs:0|rel:0)
; node # 1 D(-49,10)->(-55,9)
       fcb 2 ; drawmode 
       fcb -8,-36 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:18|rel:18)
; node # 2 D(-35,30)->(-40,30)
       fcb 2 ; drawmode 
       fcb -20,14 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:0|rel:-18)
; node # 3 D(-8,23)->(-16,23)
       fcb 2 ; drawmode 
       fcb 7,27 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-146|rel:-55) dy(abs:0|rel:0)
; node # 4 D(-13,2)->(-22,2)
       fcb 2 ; drawmode 
       fcb 21,-5 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 5 D(-14,-16)->(-23,-16)
       fcb 2 ; drawmode 
       fcb 18,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 6 D(-49,-10)->(-54,-11)
       fcb 2 ; drawmode 
       fcb -6,-35 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:18|rel:18)
; node # 7 D(-45,-47)->(-49,-48)
       fcb 2 ; drawmode 
       fcb 37,4 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:18|rel:0)
; node # 8 D(-57,-47)->(-54,-48)
       fcb 2 ; drawmode 
       fcb 0,-12 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:54|rel:127) dy(abs:18|rel:0)
; node # 9 D(-36,-50)->(-25,-51)
       fcb 2 ; drawmode 
       fcb 3,21 ; starx/y relative to previous node
       fdb 0,147 ; dx/dy. dx(abs:201|rel:147) dy(abs:18|rel:0)
; node # 10 D(-39,0)->(-27,0)
       fcb 2 ; drawmode 
       fcb -50,-3 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:219|rel:18) dy(abs:0|rel:-18)
; node # 11 D(-38,27)->(-26,28)
       fcb 2 ; drawmode 
       fcb -27,1 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:219|rel:0) dy(abs:-18|rel:-18)
; node # 12 D(-24,47)->(-16,48)
       fcb 2 ; drawmode 
       fcb -20,14 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:146|rel:-73) dy(abs:-18|rel:0)
; node # 13 D(18,45)->(25,45)
       fcb 2 ; drawmode 
       fcb 2,42 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:128|rel:-18) dy(abs:0|rel:18)
; node # 14 D(23,24)->(36,24)
       fcb 2 ; drawmode 
       fcb 21,5 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:237|rel:109) dy(abs:0|rel:0)
; node # 15 D(20,-4)->(33,-4)
       fcb 2 ; drawmode 
       fcb 28,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:237|rel:0) dy(abs:0|rel:0)
; node # 16 D(-39,0)->(-27,0)
       fcb 2 ; drawmode 
       fcb -4,-59 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:219|rel:-18) dy(abs:0|rel:0)
; node # 17 D(-65,-3)->(-63,-4)
       fcb 2 ; drawmode 
       fcb 3,-26 ; starx/y relative to previous node
       fdb 18,-183 ; dx/dy. dx(abs:36|rel:-183) dy(abs:18|rel:18)
; node # 18 D(-57,-47)->(-55,-48)
       fcb 2 ; drawmode 
       fcb 44,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:18|rel:0)
; node # 19 D(-6,-57)->(-3,-58)
       fcb 2 ; drawmode 
       fcb 10,51 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:18|rel:0)
; node # 20 D(-36,-50)->(-25,-51)
       fcb 2 ; drawmode 
       fcb -7,-30 ; starx/y relative to previous node
       fdb 0,147 ; dx/dy. dx(abs:201|rel:147) dy(abs:18|rel:0)
; node # 21 D(11,-54)->(22,-54)
       fcb 2 ; drawmode 
       fcb 4,47 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:201|rel:0) dy(abs:0|rel:-18)
; node # 22 D(20,-4)->(33,-4)
       fcb 2 ; drawmode 
       fcb -50,9 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:237|rel:36) dy(abs:0|rel:0)
; node # 23 D(59,-12)->(62,-12)
       fcb 2 ; drawmode 
       fcb 8,39 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:54|rel:-183) dy(abs:0|rel:0)
; node # 24 D(63,12)->(66,12)
       fcb 2 ; drawmode 
       fcb -24,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:0|rel:0)
; node # 25 D(23,24)->(36,24)
       fcb 2 ; drawmode 
       fcb -12,-40 ; starx/y relative to previous node
       fdb 0,183 ; dx/dy. dx(abs:237|rel:183) dy(abs:0|rel:0)
; node # 26 D(-38,27)->(-26,28)
       fcb 2 ; drawmode 
       fcb -3,-61 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:219|rel:-18) dy(abs:-18|rel:-18)
; node # 27 D(-66,20)->(-64,21)
       fcb 2 ; drawmode 
       fcb 7,-28 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:36|rel:-183) dy(abs:-18|rel:0)
; node # 28 D(-65,-3)->(-63,-4)
       fcb 2 ; drawmode 
       fcb 23,1 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:18|rel:36)
; node # 29 D(-49,-10)->(-54,-11)
       fcb 2 ; drawmode 
       fcb 7,16 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-91|rel:-127) dy(abs:18|rel:0)
; node # 30 D(-49,10)->(-55,9)
       fcb 2 ; drawmode 
       fcb -20,0 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:18|rel:0)
; node # 31 D(-66,20)->(-64,21)
       fcb 2 ; drawmode 
       fcb -10,-17 ; starx/y relative to previous node
       fdb -36,145 ; dx/dy. dx(abs:36|rel:145) dy(abs:-18|rel:-36)
; node # 32 D(-45,40)->(-44,41)
       fcb 2 ; drawmode 
       fcb -20,21 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:-18|rel:0)
; node # 33 D(-35,30)->(-40,30)
       fcb 2 ; drawmode 
       fcb 10,10 ; starx/y relative to previous node
       fdb 18,-109 ; dx/dy. dx(abs:-91|rel:-109) dy(abs:0|rel:18)
; node # 34 M(-24,47)->(-16,48)
       fcb 0 ; drawmode 
       fcb -17,11 ; starx/y relative to previous node
       fdb -18,237 ; dx/dy. dx(abs:146|rel:237) dy(abs:-18|rel:-18)
; node # 35 D(-45,40)->(-44,41)
       fcb 2 ; drawmode 
       fcb 7,-21 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:18|rel:-128) dy(abs:-18|rel:0)
; node # 36 M(-49,10)->(-55,9)
       fcb 0 ; drawmode 
       fcb 30,-4 ; starx/y relative to previous node
       fdb 36,-127 ; dx/dy. dx(abs:-109|rel:-127) dy(abs:18|rel:36)
; node # 37 D(-67,-19)->(-75,-20)
       fcb 2 ; drawmode 
       fcb 29,-18 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:18|rel:0)
; node # 38 D(-83,-33)->(-94,-35)
       fcb 2 ; drawmode 
       fcb 14,-16 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-201|rel:-55) dy(abs:36|rel:18)
; node # 39 D(-77,-33)->(-87,-35)
       fcb 2 ; drawmode 
       fcb 0,6 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:-182|rel:19) dy(abs:36|rel:0)
; node # 40 D(-51,-13)->(-56,-14)
       fcb 2 ; drawmode 
       fcb -20,26 ; starx/y relative to previous node
       fdb -18,91 ; dx/dy. dx(abs:-91|rel:91) dy(abs:18|rel:-18)
; node # 41 D(-49,10)->(-55,9)
       fcb 2 ; drawmode 
       fcb -23,2 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:18|rel:0)
; node # 42 D(-44,-15)->(-50,-15)
       fcb 2 ; drawmode 
       fcb 25,5 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:-18)
; node # 43 D(-51,-13)->(-56,-14)
       fcb 2 ; drawmode 
       fcb -2,-7 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:18|rel:18)
; node # 44 M(-71,-34)->(-81,-36)
       fcb 0 ; drawmode 
       fcb 21,-20 ; starx/y relative to previous node
       fdb 18,-91 ; dx/dy. dx(abs:-182|rel:-91) dy(abs:36|rel:18)
; node # 45 D(-77,-33)->(-87,-35)
       fcb 2 ; drawmode 
       fcb -1,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-182|rel:0) dy(abs:36|rel:0)
; node # 46 M(-83,-33)->(-94,-35)
       fcb 0 ; drawmode 
       fcb 0,-6 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-201|rel:-19) dy(abs:36|rel:0)
; node # 47 D(-71,-34)->(-81,-36)
       fcb 2 ; drawmode 
       fcb 1,12 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:-182|rel:19) dy(abs:36|rel:0)
; node # 48 D(-44,-15)->(-50,-15)
       fcb 2 ; drawmode 
       fcb -19,27 ; starx/y relative to previous node
       fdb -36,73 ; dx/dy. dx(abs:-109|rel:73) dy(abs:0|rel:-36)
; node # 49 M(-45,-47)->(-49,-48)
       fcb 0 ; drawmode 
       fcb 32,-1 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:18|rel:18)
; node # 50 D(-16,-49)->(-22,-49)
       fcb 2 ; drawmode 
       fcb 2,29 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:0|rel:-18)
; node # 51 D(-14,-16)->(-23,-16)
       fcb 2 ; drawmode 
       fcb -33,2 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:0|rel:0)
; node # 52 D(25,-18)->(16,-18)
       fcb 2 ; drawmode 
       fcb 2,39 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 53 D(17,-52)->(12,-51)
       fcb 2 ; drawmode 
       fcb 34,-8 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:-18|rel:-18)
; node # 54 D(-16,-49)->(-22,-49)
       fcb 2 ; drawmode 
       fcb -3,-33 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:0|rel:18)
; node # 55 D(-6,-57)->(-3,-58)
       fcb 2 ; drawmode 
       fcb 8,10 ; starx/y relative to previous node
       fdb 18,163 ; dx/dy. dx(abs:54|rel:163) dy(abs:18|rel:18)
; node # 56 D(1,-66)->(2,-66)
       fcb 2 ; drawmode 
       fcb 9,7 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:0|rel:-18)
; node # 57 D(-8,-65)->(-8,-65)
       fcb 2 ; drawmode 
       fcb -1,-9 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:0)
; node # 58 D(-13,-65)->(-12,-66)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:18|rel:18)
; node # 59 D(-5,-57)->(-3,-58)
       fcb 2 ; drawmode 
       fcb -8,8 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:18|rel:0)
; node # 60 D(17,-52)->(12,-51)
       fcb 2 ; drawmode 
       fcb -5,22 ; starx/y relative to previous node
       fdb -36,-127 ; dx/dy. dx(abs:-91|rel:-127) dy(abs:-18|rel:-36)
; node # 61 D(43,-55)->(41,-53)
       fcb 2 ; drawmode 
       fcb 3,26 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-36|rel:55) dy(abs:-36|rel:-18)
; node # 62 D(-5,-57)->(-3,-58)
       fcb 2 ; drawmode 
       fcb 2,-48 ; starx/y relative to previous node
       fdb 54,72 ; dx/dy. dx(abs:36|rel:72) dy(abs:18|rel:54)
; node # 63 D(11,-54)->(22,-54)
       fcb 2 ; drawmode 
       fcb -3,16 ; starx/y relative to previous node
       fdb -18,165 ; dx/dy. dx(abs:201|rel:165) dy(abs:0|rel:-18)
; node # 64 D(44,-56)->(49,-55)
       fcb 2 ; drawmode 
       fcb 2,33 ; starx/y relative to previous node
       fdb -18,-110 ; dx/dy. dx(abs:91|rel:-110) dy(abs:-18|rel:-18)
; node # 65 D(59,-12)->(62,-12)
       fcb 2 ; drawmode 
       fcb -44,15 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:54|rel:-37) dy(abs:0|rel:18)
; node # 66 D(56,-18)->(51,-17)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb -18,-145 ; dx/dy. dx(abs:-91|rel:-145) dy(abs:-18|rel:-18)
; node # 67 D(60,3)->(54,2)
       fcb 2 ; drawmode 
       fcb -21,4 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:18|rel:36)
; node # 68 D(63,12)->(66,12)
       fcb 2 ; drawmode 
       fcb -9,3 ; starx/y relative to previous node
       fdb -18,163 ; dx/dy. dx(abs:54|rel:163) dy(abs:0|rel:-18)
; node # 69 D(47,35)->(48,34)
       fcb 2 ; drawmode 
       fcb -23,-16 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:18|rel:18)
; node # 70 D(46,25)->(42,25)
       fcb 2 ; drawmode 
       fcb 10,-1 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:-73|rel:-91) dy(abs:0|rel:-18)
; node # 71 D(60,3)->(54,2)
       fcb 2 ; drawmode 
       fcb 22,14 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:18|rel:18)
; node # 72 D(26,0)->(18,0)
       fcb 2 ; drawmode 
       fcb 3,-34 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:-18)
; node # 73 D(22,21)->(15,21)
       fcb 2 ; drawmode 
       fcb -21,-4 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 74 D(-8,23)->(-16,23)
       fcb 2 ; drawmode 
       fcb -2,-30 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 75 M(47,35)->(48,34)
       fcb 0 ; drawmode 
       fcb -12,55 ; starx/y relative to previous node
       fdb 18,164 ; dx/dy. dx(abs:18|rel:164) dy(abs:18|rel:18)
; node # 76 D(18,45)->(25,45)
       fcb 2 ; drawmode 
       fcb -10,-29 ; starx/y relative to previous node
       fdb -18,110 ; dx/dy. dx(abs:128|rel:110) dy(abs:0|rel:-18)
; node # 77 M(22,21)->(15,21)
       fcb 0 ; drawmode 
       fcb 24,4 ; starx/y relative to previous node
       fdb 0,-256 ; dx/dy. dx(abs:-128|rel:-256) dy(abs:0|rel:0)
; node # 78 D(46,25)->(42,25)
       fcb 2 ; drawmode 
       fcb -4,24 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-73|rel:55) dy(abs:0|rel:0)
; node # 79 M(26,0)->(18,0)
       fcb 0 ; drawmode 
       fcb 25,-20 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:0|rel:0)
; node # 80 D(25,-18)->(16,-18)
       fcb 2 ; drawmode 
       fcb 18,-1 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 81 D(56,-18)->(51,-17)
       fcb 2 ; drawmode 
       fcb 0,31 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:-18|rel:-18)
; node # 82 D(43,-55)->(41,-53)
       fcb 2 ; drawmode 
       fcb 37,-13 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-36|rel:55) dy(abs:-36|rel:-18)
; node # 83 D(44,-56)->(49,-55)
       fcb 2 ; drawmode 
       fcb 1,1 ; starx/y relative to previous node
       fdb 18,127 ; dx/dy. dx(abs:91|rel:127) dy(abs:-18|rel:18)
; node # 84 D(-5,-57)->(-3,-58)
       fcb 2 ; drawmode 
       fcb 1,-49 ; starx/y relative to previous node
       fdb 36,-55 ; dx/dy. dx(abs:36|rel:-55) dy(abs:18|rel:36)
; node # 85 M(1,-66)->(2,-66)
       fcb 0 ; drawmode 
       fcb 9,6 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:0|rel:-18)
; node # 86 D(-4,-67)->(0,-67)
       fcb 2 ; drawmode 
       fcb 1,-5 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:73|rel:55) dy(abs:0|rel:0)
; node # 87 D(-13,-65)->(-12,-66)
       fcb 2 ; drawmode 
       fcb -2,-9 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:18|rel:-55) dy(abs:18|rel:18)
; node # 88 M(-8,-65)->(-8,-65)
       fcb 0 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:-18)
; node # 89 D(-5,-57)->(-3,-58)
       fcb 2 ; drawmode 
       fcb -8,3 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:36|rel:36) dy(abs:18|rel:18)
; node # 90 D(-45,-47)->(-49,-48)
       fcb 2 ; drawmode 
       fcb -10,-40 ; starx/y relative to previous node
       fdb 0,-109 ; dx/dy. dx(abs:-73|rel:-109) dy(abs:18|rel:0)
; node # 91 M(-4,-67)->(0,-67)
       fcb 0 ; drawmode 
       fcb 20,41 ; starx/y relative to previous node
       fdb -18,146 ; dx/dy. dx(abs:73|rel:146) dy(abs:0|rel:-18)
; node # 92 D(-5,-57)->(-3,-58)
       fcb 2 ; drawmode 
       fcb -10,-1 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:36|rel:-37) dy(abs:18|rel:18)
; node # 93 M(51,-37)->(54,-36)
       fcb 0 ; drawmode 
       fcb -20,56 ; starx/y relative to previous node
       fdb -36,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:-18|rel:-36)
; node # 94 D(92,-41)->(94,-38)
       fcb 2 ; drawmode 
       fcb 4,41 ; starx/y relative to previous node
       fdb -36,-18 ; dx/dy. dx(abs:36|rel:-18) dy(abs:-54|rel:-36)
; node # 95 D(93,-21)->(94,-18)
       fcb 2 ; drawmode 
       fcb -20,1 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:-54|rel:0)
; node # 96 D(60,3)->(64,3)
       fcb 2 ; drawmode 
       fcb -24,-33 ; starx/y relative to previous node
       fdb 54,55 ; dx/dy. dx(abs:73|rel:55) dy(abs:0|rel:54)
; node # 97 D(58,4)->(62,3)
       fcb 2 ; drawmode 
       fcb -1,-2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:73|rel:0) dy(abs:18|rel:18)
; node # 98 D(89,-20)->(94,-19)
       fcb 2 ; drawmode 
       fcb 24,31 ; starx/y relative to previous node
       fdb -36,18 ; dx/dy. dx(abs:91|rel:18) dy(abs:-18|rel:-36)
; node # 99 D(89,-40)->(94,-38)
       fcb 2 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:91|rel:0) dy(abs:-36|rel:-18)
; node # 100 D(46,-37)->(51,-36)
       fcb 2 ; drawmode 
       fcb -3,-43 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:91|rel:0) dy(abs:-18|rel:18)
; node # 101 D(51,-37)->(54,-36)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:54|rel:-37) dy(abs:-18|rel:0)
; node # 102 D(48,-44)->(52,-42)
       fcb 2 ; drawmode 
       fcb 7,-3 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:73|rel:19) dy(abs:-36|rel:-18)
; node # 103 D(97,-48)->(100,-45)
       fcb 2 ; drawmode 
       fcb 4,49 ; starx/y relative to previous node
       fdb -18,-19 ; dx/dy. dx(abs:54|rel:-19) dy(abs:-54|rel:-18)
; node # 104 D(99,-13)->(100,-13)
       fcb 2 ; drawmode 
       fcb -35,2 ; starx/y relative to previous node
       fdb 54,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:0|rel:54)
; node # 105 D(63,12)->(66,12)
       fcb 2 ; drawmode 
       fcb -25,-36 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:54|rel:36) dy(abs:0|rel:0)
; node # 106 D(58,4)->(62,3)
       fcb 2 ; drawmode 
       fcb 8,-5 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:73|rel:19) dy(abs:18|rel:18)
; node # 107 M(26,0)->(18,0)
       fcb 0 ; drawmode 
       fcb 4,-32 ; starx/y relative to previous node
       fdb -18,-219 ; dx/dy. dx(abs:-146|rel:-219) dy(abs:0|rel:-18)
; node # 108 D(-13,2)->(-22,2)
       fcb 2 ; drawmode 
       fcb -2,-39 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 109 M(28,-1)->(28,-1)
       fcb 0 ; drawmode 
       fcb 3,41 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:0|rel:164) dy(abs:0|rel:0)
; node # 110 M(89,-40)->(94,-38)
       fcb 0 ; drawmode 
       fcb 39,61 ; starx/y relative to previous node
       fdb -36,91 ; dx/dy. dx(abs:91|rel:91) dy(abs:-36|rel:-36)
; node # 111 D(97,-48)->(100,-45)
       fcb 2 ; drawmode 
       fcb 8,8 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:54|rel:-37) dy(abs:-54|rel:-18)
; node # 112 M(63,12)->(66,12)
       fcb 0 ; drawmode 
       fcb -60,-34 ; starx/y relative to previous node
       fdb 54,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:0|rel:54)
; node # 113 D(60,3)->(64,3)
       fcb 2 ; drawmode 
       fcb 9,-3 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:73|rel:19) dy(abs:0|rel:0)
; node # 114 M(93,-21)->(94,-18)
       fcb 0 ; drawmode 
       fcb 24,33 ; starx/y relative to previous node
       fdb -54,-55 ; dx/dy. dx(abs:18|rel:-55) dy(abs:-54|rel:-54)
; node # 115 D(99,-13)->(100,-13)
       fcb 2 ; drawmode 
       fcb -8,6 ; starx/y relative to previous node
       fdb 54,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:54)
; node # 116 D(89,-20)->(94,-19)
       fcb 2 ; drawmode 
       fcb 7,-10 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:91|rel:73) dy(abs:-18|rel:-18)
; node # 117 D(93,-21)->(94,-18)
       fcb 2 ; drawmode 
       fcb 1,4 ; starx/y relative to previous node
       fdb -36,-73 ; dx/dy. dx(abs:18|rel:-73) dy(abs:-54|rel:-36)
; node # 118 M(89,-40)->(94,-38)
       fcb 0 ; drawmode 
       fcb 19,-4 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:91|rel:73) dy(abs:-36|rel:18)
; node # 119 D(92,-41)->(94,-38)
       fcb 2 ; drawmode 
       fcb 1,3 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:36|rel:-55) dy(abs:-54|rel:-18)
; node # 120 M(92,-41)->(94,-38)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:-54|rel:0)
; node # 121 D(97,-48)->(100,-45)
       fcb 2 ; drawmode 
       fcb 7,5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:-54|rel:0)
; node # 122 M(46,-37)->(51,-36)
       fcb 0 ; drawmode 
       fcb -11,-51 ; starx/y relative to previous node
       fdb 36,37 ; dx/dy. dx(abs:91|rel:37) dy(abs:-18|rel:36)
; node # 123 D(48,-44)->(52,-42)
       fcb 2 ; drawmode 
       fcb 7,2 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:73|rel:-18) dy(abs:-36|rel:-18)
       fcb  1  ; end of anim
; Animation 3
teapotBframe3:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-22,2)->(-31,2)
       fcb 0 ; drawmode 
       fcb -2,-22 ; starx/y relative to previous node
       fdb 0,-164 ; dx/dy. dx(abs:-164|rel:-164) dy(abs:0|rel:0)
; node # 1 D(-55,9)->(-60,10)
       fcb 2 ; drawmode 
       fcb -7,-33 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:-18|rel:-18)
; node # 2 D(-40,30)->(-44,31)
       fcb 2 ; drawmode 
       fcb -21,15 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:-18|rel:0)
; node # 3 D(-16,23)->(-23,23)
       fcb 2 ; drawmode 
       fcb 7,24 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:0|rel:18)
; node # 4 D(-22,2)->(-31,2)
       fcb 2 ; drawmode 
       fcb 21,-6 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 5 D(-23,-16)->(-31,-16)
       fcb 2 ; drawmode 
       fcb 18,-1 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 6 D(-54,-11)->(-58,-11)
       fcb 2 ; drawmode 
       fcb -5,-31 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-73|rel:73) dy(abs:0|rel:0)
; node # 7 D(-49,-48)->(-50,-50)
       fcb 2 ; drawmode 
       fcb 37,5 ; starx/y relative to previous node
       fdb 36,55 ; dx/dy. dx(abs:-18|rel:55) dy(abs:36|rel:36)
; node # 8 D(-54,-48)->(-52,-50)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 0,54 ; dx/dy. dx(abs:36|rel:54) dy(abs:36|rel:0)
; node # 9 D(-25,-51)->(-13,-51)
       fcb 2 ; drawmode 
       fcb 3,29 ; starx/y relative to previous node
       fdb -36,183 ; dx/dy. dx(abs:219|rel:183) dy(abs:0|rel:-36)
; node # 10 D(-27,0)->(-14,0)
       fcb 2 ; drawmode 
       fcb -51,-2 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:237|rel:18) dy(abs:0|rel:0)
; node # 11 D(-26,28)->(-14,28)
       fcb 2 ; drawmode 
       fcb -28,1 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:219|rel:-18) dy(abs:0|rel:0)
; node # 12 D(-16,48)->(-8,48)
       fcb 2 ; drawmode 
       fcb -20,10 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:146|rel:-73) dy(abs:0|rel:0)
; node # 13 D(25,45)->(32,44)
       fcb 2 ; drawmode 
       fcb 3,41 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:128|rel:-18) dy(abs:18|rel:18)
; node # 14 D(36,24)->(46,23)
       fcb 2 ; drawmode 
       fcb 21,11 ; starx/y relative to previous node
       fdb 0,54 ; dx/dy. dx(abs:182|rel:54) dy(abs:18|rel:0)
; node # 15 D(33,-4)->(44,-4)
       fcb 2 ; drawmode 
       fcb 28,-3 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:201|rel:19) dy(abs:0|rel:-18)
; node # 16 D(-27,0)->(-14,0)
       fcb 2 ; drawmode 
       fcb -4,-60 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:237|rel:36) dy(abs:0|rel:0)
; node # 17 D(-63,-4)->(-60,-4)
       fcb 2 ; drawmode 
       fcb 4,-36 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:54|rel:-183) dy(abs:0|rel:0)
; node # 18 D(-55,-48)->(-52,-50)
       fcb 2 ; drawmode 
       fcb 44,8 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:36|rel:36)
; node # 19 D(-3,-58)->(-2,-58)
       fcb 2 ; drawmode 
       fcb 10,52 ; starx/y relative to previous node
       fdb -36,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:0|rel:-36)
; node # 20 D(-25,-51)->(-13,-51)
       fcb 2 ; drawmode 
       fcb -7,-22 ; starx/y relative to previous node
       fdb 0,201 ; dx/dy. dx(abs:219|rel:201) dy(abs:0|rel:0)
; node # 21 D(22,-54)->(33,-53)
       fcb 2 ; drawmode 
       fcb 3,47 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:-18|rel:-18)
; node # 22 D(33,-4)->(44,-4)
       fcb 2 ; drawmode 
       fcb -50,11 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:201|rel:0) dy(abs:0|rel:18)
; node # 23 D(62,-12)->(63,-12)
       fcb 2 ; drawmode 
       fcb 8,29 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:18|rel:-183) dy(abs:0|rel:0)
; node # 24 D(66,12)->(65,11)
       fcb 2 ; drawmode 
       fcb -24,4 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:18|rel:18)
; node # 25 D(36,24)->(46,23)
       fcb 2 ; drawmode 
       fcb -12,-30 ; starx/y relative to previous node
       fdb 0,200 ; dx/dy. dx(abs:182|rel:200) dy(abs:18|rel:0)
; node # 26 D(-26,28)->(-14,28)
       fcb 2 ; drawmode 
       fcb -4,-62 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:219|rel:37) dy(abs:0|rel:-18)
; node # 27 D(-64,21)->(-62,21)
       fcb 2 ; drawmode 
       fcb 7,-38 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:36|rel:-183) dy(abs:0|rel:0)
; node # 28 D(-63,-4)->(-60,-4)
       fcb 2 ; drawmode 
       fcb 25,1 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:0|rel:0)
; node # 29 D(-54,-11)->(-58,-11)
       fcb 2 ; drawmode 
       fcb 7,9 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-73|rel:-127) dy(abs:0|rel:0)
; node # 30 D(-55,9)->(-60,10)
       fcb 2 ; drawmode 
       fcb -20,-1 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-91|rel:-18) dy(abs:-18|rel:-18)
; node # 31 D(-64,21)->(-62,21)
       fcb 2 ; drawmode 
       fcb -12,-9 ; starx/y relative to previous node
       fdb 18,127 ; dx/dy. dx(abs:36|rel:127) dy(abs:0|rel:18)
; node # 32 D(-44,41)->(-42,42)
       fcb 2 ; drawmode 
       fcb -20,20 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:-18|rel:-18)
; node # 33 D(-40,30)->(-44,31)
       fcb 2 ; drawmode 
       fcb 11,4 ; starx/y relative to previous node
       fdb 0,-109 ; dx/dy. dx(abs:-73|rel:-109) dy(abs:-18|rel:0)
; node # 34 M(-16,48)->(-8,48)
       fcb 0 ; drawmode 
       fcb -18,24 ; starx/y relative to previous node
       fdb 18,219 ; dx/dy. dx(abs:146|rel:219) dy(abs:0|rel:18)
; node # 35 D(-44,41)->(-42,42)
       fcb 2 ; drawmode 
       fcb 7,-28 ; starx/y relative to previous node
       fdb -18,-110 ; dx/dy. dx(abs:36|rel:-110) dy(abs:-18|rel:-18)
; node # 36 M(-55,9)->(-60,10)
       fcb 0 ; drawmode 
       fcb 32,-11 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-91|rel:-127) dy(abs:-18|rel:0)
; node # 37 D(-75,-20)->(-82,-21)
       fcb 2 ; drawmode 
       fcb 29,-20 ; starx/y relative to previous node
       fdb 36,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:18|rel:36)
; node # 38 D(-94,-35)->(-105,-37)
       fcb 2 ; drawmode 
       fcb 15,-19 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-201|rel:-73) dy(abs:36|rel:18)
; node # 39 D(-87,-35)->(-94,-37)
       fcb 2 ; drawmode 
       fcb 0,7 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-128|rel:73) dy(abs:36|rel:0)
; node # 40 D(-56,-14)->(-59,-14)
       fcb 2 ; drawmode 
       fcb -21,31 ; starx/y relative to previous node
       fdb -36,74 ; dx/dy. dx(abs:-54|rel:74) dy(abs:0|rel:-36)
; node # 41 D(-55,9)->(-60,10)
       fcb 2 ; drawmode 
       fcb -23,1 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-91|rel:-37) dy(abs:-18|rel:-18)
; node # 42 D(-50,-15)->(-55,-16)
       fcb 2 ; drawmode 
       fcb 24,5 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:-91|rel:0) dy(abs:18|rel:36)
; node # 43 D(-56,-14)->(-59,-14)
       fcb 2 ; drawmode 
       fcb -1,-6 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-54|rel:37) dy(abs:0|rel:-18)
; node # 44 M(-81,-36)->(-89,-38)
       fcb 0 ; drawmode 
       fcb 22,-25 ; starx/y relative to previous node
       fdb 36,-92 ; dx/dy. dx(abs:-146|rel:-92) dy(abs:36|rel:36)
; node # 45 D(-87,-35)->(-94,-37)
       fcb 2 ; drawmode 
       fcb -1,-6 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:36|rel:0)
; node # 46 M(-94,-35)->(-105,-37)
       fcb 0 ; drawmode 
       fcb 0,-7 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-201|rel:-73) dy(abs:36|rel:0)
; node # 47 D(-81,-36)->(-89,-38)
       fcb 2 ; drawmode 
       fcb 1,13 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-146|rel:55) dy(abs:36|rel:0)
; node # 48 D(-50,-15)->(-55,-16)
       fcb 2 ; drawmode 
       fcb -21,31 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-91|rel:55) dy(abs:18|rel:-18)
; node # 49 M(-49,-48)->(-50,-50)
       fcb 0 ; drawmode 
       fcb 33,1 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-18|rel:73) dy(abs:36|rel:18)
; node # 50 D(-22,-49)->(-28,-50)
       fcb 2 ; drawmode 
       fcb 1,27 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:-109|rel:-91) dy(abs:18|rel:-18)
; node # 51 D(-23,-16)->(-31,-16)
       fcb 2 ; drawmode 
       fcb -33,-1 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:-18)
; node # 52 D(16,-18)->(8,-18)
       fcb 2 ; drawmode 
       fcb 2,39 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 53 D(12,-51)->(6,-51)
       fcb 2 ; drawmode 
       fcb 33,-4 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:0)
; node # 54 D(-22,-49)->(-28,-50)
       fcb 2 ; drawmode 
       fcb -2,-34 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:18|rel:18)
; node # 55 D(-3,-58)->(-2,-58)
       fcb 2 ; drawmode 
       fcb 9,19 ; starx/y relative to previous node
       fdb -18,127 ; dx/dy. dx(abs:18|rel:127) dy(abs:0|rel:-18)
; node # 56 D(2,-66)->(4,-66)
       fcb 2 ; drawmode 
       fcb 8,5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:0|rel:0)
; node # 57 D(-8,-65)->(-7,-65)
       fcb 2 ; drawmode 
       fcb -1,-10 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:0|rel:0)
; node # 58 D(-12,-66)->(-9,-66)
       fcb 2 ; drawmode 
       fcb 1,-4 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:54|rel:36) dy(abs:0|rel:0)
; node # 59 D(-3,-58)->(-2,-58)
       fcb 2 ; drawmode 
       fcb -8,9 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:0|rel:0)
; node # 60 D(12,-51)->(6,-51)
       fcb 2 ; drawmode 
       fcb -7,15 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-109|rel:-127) dy(abs:0|rel:0)
; node # 61 D(41,-53)->(37,-52)
       fcb 2 ; drawmode 
       fcb 2,29 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:-18|rel:-18)
; node # 62 D(-3,-58)->(-2,-58)
       fcb 2 ; drawmode 
       fcb 5,-44 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:18|rel:91) dy(abs:0|rel:18)
; node # 63 D(22,-54)->(33,-53)
       fcb 2 ; drawmode 
       fcb -4,25 ; starx/y relative to previous node
       fdb -18,183 ; dx/dy. dx(abs:201|rel:183) dy(abs:-18|rel:-18)
; node # 64 D(49,-55)->(51,-53)
       fcb 2 ; drawmode 
       fcb 1,27 ; starx/y relative to previous node
       fdb -18,-165 ; dx/dy. dx(abs:36|rel:-165) dy(abs:-36|rel:-18)
; node # 65 D(62,-12)->(63,-12)
       fcb 2 ; drawmode 
       fcb -43,13 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:0|rel:36)
; node # 66 D(51,-17)->(45,-17)
       fcb 2 ; drawmode 
       fcb 5,-11 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-109|rel:-127) dy(abs:0|rel:0)
; node # 67 D(54,2)->(47,2)
       fcb 2 ; drawmode 
       fcb -19,3 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:0)
; node # 68 D(66,12)->(65,11)
       fcb 2 ; drawmode 
       fcb -10,12 ; starx/y relative to previous node
       fdb 18,110 ; dx/dy. dx(abs:-18|rel:110) dy(abs:18|rel:18)
; node # 69 D(48,34)->(48,33)
       fcb 2 ; drawmode 
       fcb -22,-18 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:18|rel:0)
; node # 70 D(42,25)->(36,24)
       fcb 2 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb 0,-109 ; dx/dy. dx(abs:-109|rel:-109) dy(abs:18|rel:0)
; node # 71 D(54,2)->(47,2)
       fcb 2 ; drawmode 
       fcb 23,12 ; starx/y relative to previous node
       fdb -18,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:-18)
; node # 72 D(18,0)->(8,0)
       fcb 2 ; drawmode 
       fcb 2,-36 ; starx/y relative to previous node
       fdb 0,-54 ; dx/dy. dx(abs:-182|rel:-54) dy(abs:0|rel:0)
; node # 73 D(15,21)->(7,21)
       fcb 2 ; drawmode 
       fcb -21,-3 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-146|rel:36) dy(abs:0|rel:0)
; node # 74 D(-16,23)->(-23,23)
       fcb 2 ; drawmode 
       fcb -2,-31 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 75 M(48,34)->(48,33)
       fcb 0 ; drawmode 
       fcb -11,64 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:18|rel:18)
; node # 76 D(25,45)->(32,44)
       fcb 2 ; drawmode 
       fcb -11,-23 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:18|rel:0)
; node # 77 M(15,21)->(7,21)
       fcb 0 ; drawmode 
       fcb 24,-10 ; starx/y relative to previous node
       fdb -18,-274 ; dx/dy. dx(abs:-146|rel:-274) dy(abs:0|rel:-18)
; node # 78 D(42,25)->(36,24)
       fcb 2 ; drawmode 
       fcb -4,27 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:18|rel:18)
; node # 79 M(18,0)->(8,0)
       fcb 0 ; drawmode 
       fcb 25,-24 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-182|rel:-73) dy(abs:0|rel:-18)
; node # 80 D(16,-18)->(8,-18)
       fcb 2 ; drawmode 
       fcb 18,-2 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-146|rel:36) dy(abs:0|rel:0)
; node # 81 D(51,-17)->(45,-17)
       fcb 2 ; drawmode 
       fcb -1,35 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:0)
; node # 82 D(41,-53)->(37,-52)
       fcb 2 ; drawmode 
       fcb 36,-10 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:-18|rel:-18)
; node # 83 D(49,-55)->(51,-53)
       fcb 2 ; drawmode 
       fcb 2,8 ; starx/y relative to previous node
       fdb -18,109 ; dx/dy. dx(abs:36|rel:109) dy(abs:-36|rel:-18)
; node # 84 D(-3,-58)->(-2,-58)
       fcb 2 ; drawmode 
       fcb 3,-52 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:0|rel:36)
; node # 85 M(2,-66)->(4,-66)
       fcb 0 ; drawmode 
       fcb 8,5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:0|rel:0)
; node # 86 D(0,-67)->(3,-67)
       fcb 2 ; drawmode 
       fcb 1,-2 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:0|rel:0)
; node # 87 D(-12,-66)->(-9,-66)
       fcb 2 ; drawmode 
       fcb -1,-12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:0|rel:0)
; node # 88 M(-8,-65)->(-7,-65)
       fcb 0 ; drawmode 
       fcb -1,4 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:0|rel:0)
; node # 89 D(-3,-58)->(-2,-58)
       fcb 2 ; drawmode 
       fcb -7,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:0)
; node # 90 D(-49,-48)->(-50,-50)
       fcb 2 ; drawmode 
       fcb -10,-46 ; starx/y relative to previous node
       fdb 36,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:36|rel:36)
; node # 91 M(0,-67)->(3,-67)
       fcb 0 ; drawmode 
       fcb 19,49 ; starx/y relative to previous node
       fdb -36,72 ; dx/dy. dx(abs:54|rel:72) dy(abs:0|rel:-36)
; node # 92 D(-3,-58)->(-2,-58)
       fcb 2 ; drawmode 
       fcb -9,-3 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:0|rel:0)
; node # 93 M(54,-36)->(54,-36)
       fcb 0 ; drawmode 
       fcb -22,57 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:0)
; node # 94 D(94,-38)->(95,-36)
       fcb 2 ; drawmode 
       fcb 2,40 ; starx/y relative to previous node
       fdb -36,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:-36|rel:-36)
; node # 95 D(94,-18)->(94,-18)
       fcb 2 ; drawmode 
       fcb -20,0 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:36)
; node # 96 D(64,3)->(64,3)
       fcb 2 ; drawmode 
       fcb -21,-30 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 97 D(62,3)->(63,1)
       fcb 2 ; drawmode 
       fcb 0,-2 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:36|rel:36)
; node # 98 D(94,-19)->(92,-18)
       fcb 2 ; drawmode 
       fcb 22,32 ; starx/y relative to previous node
       fdb -54,-54 ; dx/dy. dx(abs:-36|rel:-54) dy(abs:-18|rel:-54)
; node # 99 D(94,-38)->(93,-36)
       fcb 2 ; drawmode 
       fcb 19,0 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:-36|rel:-18)
; node # 100 D(51,-36)->(55,-35)
       fcb 2 ; drawmode 
       fcb -2,-43 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:73|rel:91) dy(abs:-18|rel:18)
; node # 101 D(54,-36)->(54,-36)
       fcb 2 ; drawmode 
       fcb 0,3 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:0|rel:-73) dy(abs:0|rel:18)
; node # 102 D(52,-42)->(54,-41)
       fcb 2 ; drawmode 
       fcb 6,-2 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:36|rel:36) dy(abs:-18|rel:-18)
; node # 103 D(100,-45)->(100,-42)
       fcb 2 ; drawmode 
       fcb 3,48 ; starx/y relative to previous node
       fdb -36,-36 ; dx/dy. dx(abs:0|rel:-36) dy(abs:-54|rel:-36)
; node # 104 D(100,-13)->(100,-12)
       fcb 2 ; drawmode 
       fcb -32,0 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-18|rel:36)
; node # 105 D(66,12)->(65,11)
       fcb 2 ; drawmode 
       fcb -25,-34 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:18|rel:36)
; node # 106 D(62,3)->(63,1)
       fcb 2 ; drawmode 
       fcb 9,-4 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:18|rel:36) dy(abs:36|rel:18)
; node # 107 M(18,0)->(8,0)
       fcb 0 ; drawmode 
       fcb 3,-44 ; starx/y relative to previous node
       fdb -36,-200 ; dx/dy. dx(abs:-182|rel:-200) dy(abs:0|rel:-36)
; node # 108 D(-22,2)->(-31,2)
       fcb 2 ; drawmode 
       fcb -2,-40 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-164|rel:18) dy(abs:0|rel:0)
; node # 109 M(28,-1)->(28,-1)
       fcb 0 ; drawmode 
       fcb 3,50 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:0|rel:164) dy(abs:0|rel:0)
; node # 110 M(94,-38)->(93,-36)
       fcb 0 ; drawmode 
       fcb 37,66 ; starx/y relative to previous node
       fdb -36,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:-36|rel:-36)
; node # 111 D(100,-45)->(100,-42)
       fcb 2 ; drawmode 
       fcb 7,6 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:-54|rel:-18)
; node # 112 M(66,12)->(65,11)
       fcb 0 ; drawmode 
       fcb -57,-34 ; starx/y relative to previous node
       fdb 72,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:18|rel:72)
; node # 113 D(64,3)->(64,3)
       fcb 2 ; drawmode 
       fcb 9,-2 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:-18)
; node # 114 M(94,-18)->(94,-18)
       fcb 0 ; drawmode 
       fcb 21,30 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 115 D(100,-13)->(100,-12)
       fcb 2 ; drawmode 
       fcb -5,6 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-18|rel:-18)
; node # 116 D(94,-19)->(92,-18)
       fcb 2 ; drawmode 
       fcb 6,-6 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:-18|rel:0)
; node # 117 D(94,-18)->(94,-18)
       fcb 2 ; drawmode 
       fcb -1,0 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:18)
; node # 118 M(94,-38)->(93,-36)
       fcb 0 ; drawmode 
       fcb 20,0 ; starx/y relative to previous node
       fdb -36,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:-36|rel:-36)
; node # 119 D(94,-38)->(95,-36)
       fcb 2 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:18|rel:36) dy(abs:-36|rel:0)
; node # 120 M(94,-38)->(95,-36)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:-36|rel:0)
; node # 121 D(100,-45)->(100,-42)
       fcb 2 ; drawmode 
       fcb 7,6 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:-54|rel:-18)
; node # 122 M(51,-36)->(55,-35)
       fcb 0 ; drawmode 
       fcb -9,-49 ; starx/y relative to previous node
       fdb 36,73 ; dx/dy. dx(abs:73|rel:73) dy(abs:-18|rel:36)
; node # 123 D(52,-42)->(54,-41)
       fcb 2 ; drawmode 
       fcb 6,1 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:36|rel:-37) dy(abs:-18|rel:0)
       fcb  1  ; end of anim
; Animation 4
teapotBframe4:
       fcb 15 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-31,2)->(-40,2)
       fcb 0 ; drawmode 
       fcb -2,-31 ; starx/y relative to previous node
       fdb 0,-153 ; dx/dy. dx(abs:-153|rel:-153) dy(abs:0|rel:0)
; node # 1 D(-60,10)->(-64,10)
       fcb 2 ; drawmode 
       fcb -8,-29 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:-68|rel:85) dy(abs:0|rel:0)
; node # 2 D(-44,31)->(-47,32)
       fcb 2 ; drawmode 
       fcb -21,16 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:-51|rel:17) dy(abs:-17|rel:-17)
; node # 3 D(-23,23)->(-30,24)
       fcb 2 ; drawmode 
       fcb 8,21 ; starx/y relative to previous node
       fdb 0,-68 ; dx/dy. dx(abs:-119|rel:-68) dy(abs:-17|rel:0)
; node # 4 D(-31,2)->(-40,2)
       fcb 2 ; drawmode 
       fcb 21,-8 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:-153|rel:-34) dy(abs:0|rel:17)
; node # 5 D(-31,-16)->(-39,-16)
       fcb 2 ; drawmode 
       fcb 18,0 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-136|rel:17) dy(abs:0|rel:0)
; node # 6 D(-58,-11)->(-62,-11)
       fcb 2 ; drawmode 
       fcb -5,-27 ; starx/y relative to previous node
       fdb 0,68 ; dx/dy. dx(abs:-68|rel:68) dy(abs:0|rel:0)
; node # 7 D(-50,-50)->(-52,-52)
       fcb 2 ; drawmode 
       fcb 39,8 ; starx/y relative to previous node
       fdb 34,34 ; dx/dy. dx(abs:-34|rel:34) dy(abs:34|rel:34)
; node # 8 D(-52,-50)->(-43,-51)
       fcb 2 ; drawmode 
       fcb 0,-2 ; starx/y relative to previous node
       fdb -17,187 ; dx/dy. dx(abs:153|rel:187) dy(abs:17|rel:-17)
; node # 9 D(-13,-51)->(0,-51)
       fcb 2 ; drawmode 
       fcb 1,39 ; starx/y relative to previous node
       fdb -17,68 ; dx/dy. dx(abs:221|rel:68) dy(abs:0|rel:-17)
; node # 10 D(-14,0)->(0,-1)
       fcb 2 ; drawmode 
       fcb -51,-1 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:238|rel:17) dy(abs:17|rel:17)
; node # 11 D(-14,28)->(0,28)
       fcb 2 ; drawmode 
       fcb -28,0 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:238|rel:0) dy(abs:0|rel:-17)
; node # 12 D(-8,48)->(0,48)
       fcb 2 ; drawmode 
       fcb -20,6 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:136|rel:-102) dy(abs:0|rel:0)
; node # 13 D(32,44)->(38,43)
       fcb 2 ; drawmode 
       fcb 4,40 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:102|rel:-34) dy(abs:17|rel:17)
; node # 14 D(46,23)->(55,22)
       fcb 2 ; drawmode 
       fcb 21,14 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:153|rel:51) dy(abs:17|rel:0)
; node # 15 D(44,-4)->(52,-4)
       fcb 2 ; drawmode 
       fcb 27,-2 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:136|rel:-17) dy(abs:0|rel:-17)
; node # 16 D(-14,0)->(0,-1)
       fcb 2 ; drawmode 
       fcb -4,-58 ; starx/y relative to previous node
       fdb 17,102 ; dx/dy. dx(abs:238|rel:102) dy(abs:17|rel:17)
; node # 17 D(-60,-4)->(-53,-4)
       fcb 2 ; drawmode 
       fcb 4,-46 ; starx/y relative to previous node
       fdb -17,-119 ; dx/dy. dx(abs:119|rel:-119) dy(abs:0|rel:-17)
; node # 18 D(-52,-50)->(-43,-51)
       fcb 2 ; drawmode 
       fcb 46,8 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:153|rel:34) dy(abs:17|rel:17)
; node # 19 D(-2,-58)->(0,-58)
       fcb 2 ; drawmode 
       fcb 8,50 ; starx/y relative to previous node
       fdb -17,-119 ; dx/dy. dx(abs:34|rel:-119) dy(abs:0|rel:-17)
; node # 20 D(-13,-51)->(0,-51)
       fcb 2 ; drawmode 
       fcb -7,-11 ; starx/y relative to previous node
       fdb 0,187 ; dx/dy. dx(abs:221|rel:187) dy(abs:0|rel:0)
; node # 21 D(33,-53)->(42,-51)
       fcb 2 ; drawmode 
       fcb 2,46 ; starx/y relative to previous node
       fdb -34,-68 ; dx/dy. dx(abs:153|rel:-68) dy(abs:-34|rel:-34)
; node # 22 D(44,-4)->(52,-4)
       fcb 2 ; drawmode 
       fcb -49,11 ; starx/y relative to previous node
       fdb 34,-17 ; dx/dy. dx(abs:136|rel:-17) dy(abs:0|rel:34)
; node # 23 D(63,-12)->(62,-11)
       fcb 2 ; drawmode 
       fcb 8,19 ; starx/y relative to previous node
       fdb -17,-153 ; dx/dy. dx(abs:-17|rel:-153) dy(abs:-17|rel:-17)
; node # 24 D(65,11)->(64,10)
       fcb 2 ; drawmode 
       fcb -23,2 ; starx/y relative to previous node
       fdb 34,0 ; dx/dy. dx(abs:-17|rel:0) dy(abs:17|rel:34)
; node # 25 D(46,23)->(55,22)
       fcb 2 ; drawmode 
       fcb -12,-19 ; starx/y relative to previous node
       fdb 0,170 ; dx/dy. dx(abs:153|rel:170) dy(abs:17|rel:0)
; node # 26 D(-14,28)->(0,28)
       fcb 2 ; drawmode 
       fcb -5,-60 ; starx/y relative to previous node
       fdb -17,85 ; dx/dy. dx(abs:238|rel:85) dy(abs:0|rel:-17)
; node # 27 D(-62,21)->(-55,22)
       fcb 2 ; drawmode 
       fcb 7,-48 ; starx/y relative to previous node
       fdb -17,-119 ; dx/dy. dx(abs:119|rel:-119) dy(abs:-17|rel:-17)
; node # 28 D(-60,-4)->(-53,-4)
       fcb 2 ; drawmode 
       fcb 25,2 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:119|rel:0) dy(abs:0|rel:17)
; node # 29 D(-58,-11)->(-62,-11)
       fcb 2 ; drawmode 
       fcb 7,2 ; starx/y relative to previous node
       fdb 0,-187 ; dx/dy. dx(abs:-68|rel:-187) dy(abs:0|rel:0)
; node # 30 D(-60,10)->(-64,10)
       fcb 2 ; drawmode 
       fcb -21,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-68|rel:0) dy(abs:0|rel:0)
; node # 31 D(-62,21)->(-55,22)
       fcb 2 ; drawmode 
       fcb -11,-2 ; starx/y relative to previous node
       fdb -17,187 ; dx/dy. dx(abs:119|rel:187) dy(abs:-17|rel:-17)
; node # 32 D(-42,42)->(-38,43)
       fcb 2 ; drawmode 
       fcb -21,20 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:68|rel:-51) dy(abs:-17|rel:0)
; node # 33 D(-44,31)->(-47,32)
       fcb 2 ; drawmode 
       fcb 11,-2 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:-51|rel:-119) dy(abs:-17|rel:0)
; node # 34 M(-8,48)->(0,48)
       fcb 0 ; drawmode 
       fcb -17,36 ; starx/y relative to previous node
       fdb 17,187 ; dx/dy. dx(abs:136|rel:187) dy(abs:0|rel:17)
; node # 35 D(-42,42)->(-38,43)
       fcb 2 ; drawmode 
       fcb 6,-34 ; starx/y relative to previous node
       fdb -17,-68 ; dx/dy. dx(abs:68|rel:-68) dy(abs:-17|rel:-17)
; node # 36 M(-60,10)->(-64,10)
       fcb 0 ; drawmode 
       fcb 32,-18 ; starx/y relative to previous node
       fdb 17,-136 ; dx/dy. dx(abs:-68|rel:-136) dy(abs:0|rel:17)
; node # 37 D(-82,-21)->(-87,-21)
       fcb 2 ; drawmode 
       fcb 31,-22 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-85|rel:-17) dy(abs:0|rel:0)
; node # 38 D(-105,-37)->(-112,-40)
       fcb 2 ; drawmode 
       fcb 16,-23 ; starx/y relative to previous node
       fdb 51,-34 ; dx/dy. dx(abs:-119|rel:-34) dy(abs:51|rel:51)
; node # 39 D(-94,-37)->(-99,-39)
       fcb 2 ; drawmode 
       fcb 0,11 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:-85|rel:34) dy(abs:34|rel:-17)
; node # 40 D(-59,-14)->(-61,-15)
       fcb 2 ; drawmode 
       fcb -23,35 ; starx/y relative to previous node
       fdb -17,51 ; dx/dy. dx(abs:-34|rel:51) dy(abs:17|rel:-17)
; node # 41 D(-60,10)->(-64,10)
       fcb 2 ; drawmode 
       fcb -24,-1 ; starx/y relative to previous node
       fdb -17,-34 ; dx/dy. dx(abs:-68|rel:-34) dy(abs:0|rel:-17)
; node # 42 D(-55,-16)->(-58,-16)
       fcb 2 ; drawmode 
       fcb 26,5 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-51|rel:17) dy(abs:0|rel:0)
; node # 43 D(-59,-14)->(-61,-15)
       fcb 2 ; drawmode 
       fcb -2,-4 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-34|rel:17) dy(abs:17|rel:17)
; node # 44 M(-89,-38)->(-96,-40)
       fcb 0 ; drawmode 
       fcb 24,-30 ; starx/y relative to previous node
       fdb 17,-85 ; dx/dy. dx(abs:-119|rel:-85) dy(abs:34|rel:17)
; node # 45 D(-94,-37)->(-99,-39)
       fcb 2 ; drawmode 
       fcb -1,-5 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-85|rel:34) dy(abs:34|rel:0)
; node # 46 M(-105,-37)->(-112,-40)
       fcb 0 ; drawmode 
       fcb 0,-11 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:-119|rel:-34) dy(abs:51|rel:17)
; node # 47 D(-89,-38)->(-96,-40)
       fcb 2 ; drawmode 
       fcb 1,16 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:34|rel:-17)
; node # 48 D(-55,-16)->(-58,-16)
       fcb 2 ; drawmode 
       fcb -22,34 ; starx/y relative to previous node
       fdb -34,68 ; dx/dy. dx(abs:-51|rel:68) dy(abs:0|rel:-34)
; node # 49 M(-50,-50)->(-52,-52)
       fcb 0 ; drawmode 
       fcb 34,5 ; starx/y relative to previous node
       fdb 34,17 ; dx/dy. dx(abs:-34|rel:17) dy(abs:34|rel:34)
; node # 50 D(-28,-50)->(-33,-52)
       fcb 2 ; drawmode 
       fcb 0,22 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-85|rel:-51) dy(abs:34|rel:0)
; node # 51 D(-31,-16)->(-39,-16)
       fcb 2 ; drawmode 
       fcb -34,-3 ; starx/y relative to previous node
       fdb -34,-51 ; dx/dy. dx(abs:-136|rel:-51) dy(abs:0|rel:-34)
; node # 52 D(8,-18)->(0,-18)
       fcb 2 ; drawmode 
       fcb 2,39 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:0|rel:0)
; node # 53 D(6,-51)->(0,-52)
       fcb 2 ; drawmode 
       fcb 33,-2 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:-102|rel:34) dy(abs:17|rel:17)
; node # 54 D(-28,-50)->(-33,-52)
       fcb 2 ; drawmode 
       fcb -1,-34 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-85|rel:17) dy(abs:34|rel:17)
; node # 55 D(-2,-58)->(0,-58)
       fcb 2 ; drawmode 
       fcb 8,26 ; starx/y relative to previous node
       fdb -34,119 ; dx/dy. dx(abs:34|rel:119) dy(abs:0|rel:-34)
; node # 56 D(4,-66)->(5,-66)
       fcb 2 ; drawmode 
       fcb 8,6 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:17|rel:-17) dy(abs:0|rel:0)
; node # 57 D(-7,-65)->(-6,-66)
       fcb 2 ; drawmode 
       fcb -1,-11 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:17|rel:0) dy(abs:17|rel:17)
; node # 58 D(-9,-66)->(-6,-67)
       fcb 2 ; drawmode 
       fcb 1,-2 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:51|rel:34) dy(abs:17|rel:0)
; node # 59 D(-2,-58)->(0,-58)
       fcb 2 ; drawmode 
       fcb -8,7 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:34|rel:-17) dy(abs:0|rel:-17)
; node # 60 D(6,-51)->(0,-52)
       fcb 2 ; drawmode 
       fcb -7,8 ; starx/y relative to previous node
       fdb 17,-136 ; dx/dy. dx(abs:-102|rel:-136) dy(abs:17|rel:17)
; node # 61 D(37,-52)->(32,-52)
       fcb 2 ; drawmode 
       fcb 1,31 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:-85|rel:17) dy(abs:0|rel:-17)
; node # 62 D(-2,-58)->(0,-58)
       fcb 2 ; drawmode 
       fcb 6,-39 ; starx/y relative to previous node
       fdb 0,119 ; dx/dy. dx(abs:34|rel:119) dy(abs:0|rel:0)
; node # 63 D(33,-53)->(42,-51)
       fcb 2 ; drawmode 
       fcb -5,35 ; starx/y relative to previous node
       fdb -34,119 ; dx/dy. dx(abs:153|rel:119) dy(abs:-34|rel:-34)
; node # 64 D(51,-53)->(52,-51)
       fcb 2 ; drawmode 
       fcb 0,18 ; starx/y relative to previous node
       fdb 0,-136 ; dx/dy. dx(abs:17|rel:-136) dy(abs:-34|rel:0)
; node # 65 D(63,-12)->(62,-11)
       fcb 2 ; drawmode 
       fcb -41,12 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:-17|rel:-34) dy(abs:-17|rel:17)
; node # 66 D(45,-17)->(38,-16)
       fcb 2 ; drawmode 
       fcb 5,-18 ; starx/y relative to previous node
       fdb 0,-102 ; dx/dy. dx(abs:-119|rel:-102) dy(abs:-17|rel:0)
; node # 67 D(47,2)->(39,2)
       fcb 2 ; drawmode 
       fcb -19,2 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:0|rel:17)
; node # 68 D(65,11)->(64,10)
       fcb 2 ; drawmode 
       fcb -9,18 ; starx/y relative to previous node
       fdb 17,119 ; dx/dy. dx(abs:-17|rel:119) dy(abs:17|rel:17)
; node # 69 D(48,33)->(46,32)
       fcb 2 ; drawmode 
       fcb -22,-17 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-34|rel:-17) dy(abs:17|rel:0)
; node # 70 D(36,24)->(29,24)
       fcb 2 ; drawmode 
       fcb 9,-12 ; starx/y relative to previous node
       fdb -17,-85 ; dx/dy. dx(abs:-119|rel:-85) dy(abs:0|rel:-17)
; node # 71 D(47,2)->(39,2)
       fcb 2 ; drawmode 
       fcb 22,11 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:0|rel:0)
; node # 72 D(8,0)->(0,0)
       fcb 2 ; drawmode 
       fcb 2,-39 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:0|rel:0)
; node # 73 D(7,21)->(0,21)
       fcb 2 ; drawmode 
       fcb -21,-1 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:0|rel:0)
; node # 74 D(-23,23)->(-30,24)
       fcb 2 ; drawmode 
       fcb -2,-30 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:-17|rel:-17)
; node # 75 M(48,33)->(46,32)
       fcb 0 ; drawmode 
       fcb -10,71 ; starx/y relative to previous node
       fdb 34,85 ; dx/dy. dx(abs:-34|rel:85) dy(abs:17|rel:34)
; node # 76 D(32,44)->(38,43)
       fcb 2 ; drawmode 
       fcb -11,-16 ; starx/y relative to previous node
       fdb 0,136 ; dx/dy. dx(abs:102|rel:136) dy(abs:17|rel:0)
; node # 77 M(7,21)->(0,21)
       fcb 0 ; drawmode 
       fcb 23,-25 ; starx/y relative to previous node
       fdb -17,-221 ; dx/dy. dx(abs:-119|rel:-221) dy(abs:0|rel:-17)
; node # 78 D(36,24)->(29,24)
       fcb 2 ; drawmode 
       fcb -3,29 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:0|rel:0)
; node # 79 M(8,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 24,-28 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:0|rel:0)
; node # 80 D(8,-18)->(0,-18)
       fcb 2 ; drawmode 
       fcb 18,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:0|rel:0)
; node # 81 D(45,-17)->(38,-16)
       fcb 2 ; drawmode 
       fcb -1,37 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:-17|rel:-17)
; node # 82 D(37,-52)->(32,-52)
       fcb 2 ; drawmode 
       fcb 35,-8 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:-85|rel:34) dy(abs:0|rel:17)
; node # 83 D(51,-53)->(52,-51)
       fcb 2 ; drawmode 
       fcb 1,14 ; starx/y relative to previous node
       fdb -34,102 ; dx/dy. dx(abs:17|rel:102) dy(abs:-34|rel:-34)
; node # 84 D(-2,-58)->(0,-58)
       fcb 2 ; drawmode 
       fcb 5,-53 ; starx/y relative to previous node
       fdb 34,17 ; dx/dy. dx(abs:34|rel:17) dy(abs:0|rel:34)
; node # 85 M(4,-66)->(5,-66)
       fcb 0 ; drawmode 
       fcb 8,6 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:17|rel:-17) dy(abs:0|rel:0)
; node # 86 D(3,-67)->(5,-67)
       fcb 2 ; drawmode 
       fcb 1,-1 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:34|rel:17) dy(abs:0|rel:0)
; node # 87 D(-9,-66)->(-6,-67)
       fcb 2 ; drawmode 
       fcb -1,-12 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:51|rel:17) dy(abs:17|rel:17)
; node # 88 M(-7,-65)->(-6,-66)
       fcb 0 ; drawmode 
       fcb -1,2 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:17|rel:-34) dy(abs:17|rel:0)
; node # 89 D(-2,-58)->(0,-58)
       fcb 2 ; drawmode 
       fcb -7,5 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:34|rel:17) dy(abs:0|rel:-17)
; node # 90 D(-50,-50)->(-52,-52)
       fcb 2 ; drawmode 
       fcb -8,-48 ; starx/y relative to previous node
       fdb 34,-68 ; dx/dy. dx(abs:-34|rel:-68) dy(abs:34|rel:34)
; node # 91 M(3,-67)->(5,-67)
       fcb 0 ; drawmode 
       fcb 17,53 ; starx/y relative to previous node
       fdb -34,68 ; dx/dy. dx(abs:34|rel:68) dy(abs:0|rel:-34)
; node # 92 D(-2,-58)->(0,-58)
       fcb 2 ; drawmode 
       fcb -9,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:34|rel:0) dy(abs:0|rel:0)
; node # 93 M(54,-36)->(53,-34)
       fcb 0 ; drawmode 
       fcb -22,56 ; starx/y relative to previous node
       fdb -34,-51 ; dx/dy. dx(abs:-17|rel:-51) dy(abs:-34|rel:-34)
; node # 94 D(95,-36)->(93,-34)
       fcb 2 ; drawmode 
       fcb 0,41 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-34|rel:-17) dy(abs:-34|rel:0)
; node # 95 D(94,-18)->(92,-16)
       fcb 2 ; drawmode 
       fcb -18,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-34|rel:0) dy(abs:-34|rel:0)
; node # 96 D(64,3)->(63,3)
       fcb 2 ; drawmode 
       fcb -21,-30 ; starx/y relative to previous node
       fdb 34,17 ; dx/dy. dx(abs:-17|rel:17) dy(abs:0|rel:34)
; node # 97 D(63,1)->(60,1)
       fcb 2 ; drawmode 
       fcb 2,-1 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-51|rel:-34) dy(abs:0|rel:0)
; node # 98 D(92,-18)->(88,-17)
       fcb 2 ; drawmode 
       fcb 19,29 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-68|rel:-17) dy(abs:-17|rel:-17)
; node # 99 D(93,-36)->(89,-33)
       fcb 2 ; drawmode 
       fcb 18,1 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:-68|rel:0) dy(abs:-51|rel:-34)
; node # 100 D(55,-35)->(56,-33)
       fcb 2 ; drawmode 
       fcb -1,-38 ; starx/y relative to previous node
       fdb 17,85 ; dx/dy. dx(abs:17|rel:85) dy(abs:-34|rel:17)
; node # 101 D(54,-36)->(53,-34)
       fcb 2 ; drawmode 
       fcb 1,-1 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-17|rel:-34) dy(abs:-34|rel:0)
; node # 102 D(54,-41)->(54,-40)
       fcb 2 ; drawmode 
       fcb 5,0 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:0|rel:17) dy(abs:-17|rel:17)
; node # 103 D(100,-42)->(97,-40)
       fcb 2 ; drawmode 
       fcb 1,46 ; starx/y relative to previous node
       fdb -17,-51 ; dx/dy. dx(abs:-51|rel:-51) dy(abs:-34|rel:-17)
; node # 104 D(100,-12)->(96,-11)
       fcb 2 ; drawmode 
       fcb -30,0 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-68|rel:-17) dy(abs:-17|rel:17)
; node # 105 D(65,11)->(64,10)
       fcb 2 ; drawmode 
       fcb -23,-35 ; starx/y relative to previous node
       fdb 34,51 ; dx/dy. dx(abs:-17|rel:51) dy(abs:17|rel:34)
; node # 106 D(63,1)->(60,1)
       fcb 2 ; drawmode 
       fcb 10,-2 ; starx/y relative to previous node
       fdb -17,-34 ; dx/dy. dx(abs:-51|rel:-34) dy(abs:0|rel:-17)
; node # 107 M(8,0)->(0,0)
       fcb 0 ; drawmode 
       fcb 1,-55 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:-136|rel:-85) dy(abs:0|rel:0)
; node # 108 D(-31,2)->(-40,2)
       fcb 2 ; drawmode 
       fcb -2,-39 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-153|rel:-17) dy(abs:0|rel:0)
; node # 109 M(28,-1)->(28,-1)
       fcb 0 ; drawmode 
       fcb 3,59 ; starx/y relative to previous node
       fdb 0,153 ; dx/dy. dx(abs:0|rel:153) dy(abs:0|rel:0)
; node # 110 M(93,-36)->(89,-33)
       fcb 0 ; drawmode 
       fcb 35,65 ; starx/y relative to previous node
       fdb -51,-68 ; dx/dy. dx(abs:-68|rel:-68) dy(abs:-51|rel:-51)
; node # 111 D(100,-42)->(97,-40)
       fcb 2 ; drawmode 
       fcb 6,7 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-51|rel:17) dy(abs:-34|rel:17)
; node # 112 M(65,11)->(64,10)
       fcb 0 ; drawmode 
       fcb -53,-35 ; starx/y relative to previous node
       fdb 51,34 ; dx/dy. dx(abs:-17|rel:34) dy(abs:17|rel:51)
; node # 113 D(64,3)->(63,3)
       fcb 2 ; drawmode 
       fcb 8,-1 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-17|rel:0) dy(abs:0|rel:-17)
; node # 114 M(94,-18)->(92,-16)
       fcb 0 ; drawmode 
       fcb 21,30 ; starx/y relative to previous node
       fdb -34,-17 ; dx/dy. dx(abs:-34|rel:-17) dy(abs:-34|rel:-34)
; node # 115 D(100,-12)->(96,-11)
       fcb 2 ; drawmode 
       fcb -6,6 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:-68|rel:-34) dy(abs:-17|rel:17)
; node # 116 D(92,-18)->(88,-17)
       fcb 2 ; drawmode 
       fcb 6,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-68|rel:0) dy(abs:-17|rel:0)
; node # 117 D(94,-18)->(92,-16)
       fcb 2 ; drawmode 
       fcb 0,2 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:-34|rel:34) dy(abs:-34|rel:-17)
; node # 118 M(93,-36)->(89,-33)
       fcb 0 ; drawmode 
       fcb 18,-1 ; starx/y relative to previous node
       fdb -17,-34 ; dx/dy. dx(abs:-68|rel:-34) dy(abs:-51|rel:-17)
; node # 119 D(95,-36)->(93,-34)
       fcb 2 ; drawmode 
       fcb 0,2 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:-34|rel:34) dy(abs:-34|rel:17)
; node # 120 M(95,-36)->(93,-34)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-34|rel:0) dy(abs:-34|rel:0)
; node # 121 D(100,-42)->(97,-40)
       fcb 2 ; drawmode 
       fcb 6,5 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-51|rel:-17) dy(abs:-34|rel:0)
; node # 122 M(55,-35)->(56,-33)
       fcb 0 ; drawmode 
       fcb -7,-45 ; starx/y relative to previous node
       fdb 0,68 ; dx/dy. dx(abs:17|rel:68) dy(abs:-34|rel:0)
; node # 123 D(54,-41)->(54,-40)
       fcb 2 ; drawmode 
       fcb 6,-1 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:0|rel:-17) dy(abs:-17|rel:17)
       fcb  1  ; end of anim
; Animation 5
teapotBframe5:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-40,2)->(-47,2)
       fcb 0 ; drawmode 
       fcb -2,-40 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:0|rel:0)
; node # 1 D(-64,10)->(-66,11)
       fcb 2 ; drawmode 
       fcb -8,-24 ; starx/y relative to previous node
       fdb -18,92 ; dx/dy. dx(abs:-36|rel:92) dy(abs:-18|rel:-18)
; node # 2 D(-47,32)->(-48,33)
       fcb 2 ; drawmode 
       fcb -22,17 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:-18|rel:0)
; node # 3 D(-30,24)->(-37,24)
       fcb 2 ; drawmode 
       fcb 8,17 ; starx/y relative to previous node
       fdb 18,-110 ; dx/dy. dx(abs:-128|rel:-110) dy(abs:0|rel:18)
; node # 4 D(-40,2)->(-47,2)
       fcb 2 ; drawmode 
       fcb 22,-10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:0)
; node # 5 D(-39,-16)->(-45,-17)
       fcb 2 ; drawmode 
       fcb 18,1 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:18|rel:18)
; node # 6 D(-62,-11)->(-63,-12)
       fcb 2 ; drawmode 
       fcb -5,-23 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:-18|rel:91) dy(abs:18|rel:0)
; node # 7 D(-52,-52)->(-51,-53)
       fcb 2 ; drawmode 
       fcb 41,10 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:18|rel:36) dy(abs:18|rel:0)
; node # 8 D(-43,-51)->(-34,-52)
       fcb 2 ; drawmode 
       fcb -1,9 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:164|rel:146) dy(abs:18|rel:0)
; node # 9 D(0,-51)->(13,-51)
       fcb 2 ; drawmode 
       fcb 0,43 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:237|rel:73) dy(abs:0|rel:-18)
; node # 10 D(0,-1)->(14,0)
       fcb 2 ; drawmode 
       fcb -50,0 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:256|rel:19) dy(abs:-18|rel:-18)
; node # 11 D(0,28)->(13,28)
       fcb 2 ; drawmode 
       fcb -29,0 ; starx/y relative to previous node
       fdb 18,-19 ; dx/dy. dx(abs:237|rel:-19) dy(abs:0|rel:18)
; node # 12 D(0,48)->(8,48)
       fcb 2 ; drawmode 
       fcb -20,0 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:146|rel:-91) dy(abs:0|rel:0)
; node # 13 D(38,43)->(41,42)
       fcb 2 ; drawmode 
       fcb 5,38 ; starx/y relative to previous node
       fdb 18,-92 ; dx/dy. dx(abs:54|rel:-92) dy(abs:18|rel:18)
; node # 14 D(55,22)->(60,22)
       fcb 2 ; drawmode 
       fcb 21,17 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:91|rel:37) dy(abs:0|rel:-18)
; node # 15 D(52,-4)->(59,-4)
       fcb 2 ; drawmode 
       fcb 26,-3 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:128|rel:37) dy(abs:0|rel:0)
; node # 16 D(0,-1)->(14,0)
       fcb 2 ; drawmode 
       fcb -3,-52 ; starx/y relative to previous node
       fdb -18,128 ; dx/dy. dx(abs:256|rel:128) dy(abs:-18|rel:-18)
; node # 17 D(-53,-4)->(-44,-4)
       fcb 2 ; drawmode 
       fcb 3,-53 ; starx/y relative to previous node
       fdb 18,-92 ; dx/dy. dx(abs:164|rel:-92) dy(abs:0|rel:18)
; node # 18 D(-43,-51)->(-34,-52)
       fcb 2 ; drawmode 
       fcb 47,10 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:164|rel:0) dy(abs:18|rel:18)
; node # 19 D(0,-58)->(1,-58)
       fcb 2 ; drawmode 
       fcb 7,43 ; starx/y relative to previous node
       fdb -18,-146 ; dx/dy. dx(abs:18|rel:-146) dy(abs:0|rel:-18)
; node # 20 D(0,-51)->(13,-51)
       fcb 2 ; drawmode 
       fcb -7,0 ; starx/y relative to previous node
       fdb 0,219 ; dx/dy. dx(abs:237|rel:219) dy(abs:0|rel:0)
; node # 21 D(42,-51)->(49,-50)
       fcb 2 ; drawmode 
       fcb 0,42 ; starx/y relative to previous node
       fdb -18,-109 ; dx/dy. dx(abs:128|rel:-109) dy(abs:-18|rel:-18)
; node # 22 D(52,-4)->(59,-4)
       fcb 2 ; drawmode 
       fcb -47,10 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:128|rel:0) dy(abs:0|rel:18)
; node # 23 D(62,-11)->(58,-11)
       fcb 2 ; drawmode 
       fcb 7,10 ; starx/y relative to previous node
       fdb 0,-201 ; dx/dy. dx(abs:-73|rel:-201) dy(abs:0|rel:0)
; node # 24 D(64,10)->(60,10)
       fcb 2 ; drawmode 
       fcb -21,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-73|rel:0) dy(abs:0|rel:0)
; node # 25 D(55,22)->(60,22)
       fcb 2 ; drawmode 
       fcb -12,-9 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:91|rel:164) dy(abs:0|rel:0)
; node # 26 D(0,28)->(13,28)
       fcb 2 ; drawmode 
       fcb -6,-55 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:237|rel:146) dy(abs:0|rel:0)
; node # 27 D(-55,22)->(-47,23)
       fcb 2 ; drawmode 
       fcb 6,-55 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:146|rel:-91) dy(abs:-18|rel:-18)
; node # 28 D(-53,-4)->(-44,-4)
       fcb 2 ; drawmode 
       fcb 26,2 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:164|rel:18) dy(abs:0|rel:18)
; node # 29 D(-62,-11)->(-63,-12)
       fcb 2 ; drawmode 
       fcb 7,-9 ; starx/y relative to previous node
       fdb 18,-182 ; dx/dy. dx(abs:-18|rel:-182) dy(abs:18|rel:18)
; node # 30 D(-64,10)->(-66,11)
       fcb 2 ; drawmode 
       fcb -21,-2 ; starx/y relative to previous node
       fdb -36,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:-18|rel:-36)
; node # 31 D(-55,22)->(-47,23)
       fcb 2 ; drawmode 
       fcb -12,9 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:146|rel:182) dy(abs:-18|rel:0)
; node # 32 D(-38,43)->(-33,44)
       fcb 2 ; drawmode 
       fcb -21,17 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:91|rel:-55) dy(abs:-18|rel:0)
; node # 33 D(-47,32)->(-48,33)
       fcb 2 ; drawmode 
       fcb 11,-9 ; starx/y relative to previous node
       fdb 0,-109 ; dx/dy. dx(abs:-18|rel:-109) dy(abs:-18|rel:0)
; node # 34 M(0,48)->(8,48)
       fcb 0 ; drawmode 
       fcb -16,47 ; starx/y relative to previous node
       fdb 18,164 ; dx/dy. dx(abs:146|rel:164) dy(abs:0|rel:18)
; node # 35 D(-38,43)->(-33,44)
       fcb 2 ; drawmode 
       fcb 5,-38 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:91|rel:-55) dy(abs:-18|rel:-18)
; node # 36 M(-64,10)->(-66,11)
       fcb 0 ; drawmode 
       fcb 33,-26 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-36|rel:-127) dy(abs:-18|rel:0)
; node # 37 D(-87,-21)->(-90,-23)
       fcb 2 ; drawmode 
       fcb 31,-23 ; starx/y relative to previous node
       fdb 54,-18 ; dx/dy. dx(abs:-54|rel:-18) dy(abs:36|rel:54)
; node # 38 D(-112,-40)->(-117,-43)
       fcb 2 ; drawmode 
       fcb 19,-25 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-91|rel:-37) dy(abs:54|rel:18)
; node # 39 D(-99,-39)->(-102,-42)
       fcb 2 ; drawmode 
       fcb -1,13 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-54|rel:37) dy(abs:54|rel:0)
; node # 40 D(-61,-15)->(-60,-16)
       fcb 2 ; drawmode 
       fcb -24,38 ; starx/y relative to previous node
       fdb -36,72 ; dx/dy. dx(abs:18|rel:72) dy(abs:18|rel:-36)
; node # 41 D(-64,10)->(-66,11)
       fcb 2 ; drawmode 
       fcb -25,-3 ; starx/y relative to previous node
       fdb -36,-54 ; dx/dy. dx(abs:-36|rel:-54) dy(abs:-18|rel:-36)
; node # 42 D(-58,-16)->(-60,-17)
       fcb 2 ; drawmode 
       fcb 26,6 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:18|rel:36)
; node # 43 D(-61,-15)->(-60,-16)
       fcb 2 ; drawmode 
       fcb -1,-3 ; starx/y relative to previous node
       fdb 0,54 ; dx/dy. dx(abs:18|rel:54) dy(abs:18|rel:0)
; node # 44 M(-96,-40)->(-100,-42)
       fcb 0 ; drawmode 
       fcb 25,-35 ; starx/y relative to previous node
       fdb 18,-91 ; dx/dy. dx(abs:-73|rel:-91) dy(abs:36|rel:18)
; node # 45 D(-99,-39)->(-102,-42)
       fcb 2 ; drawmode 
       fcb -1,-3 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:-54|rel:19) dy(abs:54|rel:18)
; node # 46 M(-112,-40)->(-117,-43)
       fcb 0 ; drawmode 
       fcb 1,-13 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-91|rel:-37) dy(abs:54|rel:0)
; node # 47 D(-96,-40)->(-100,-42)
       fcb 2 ; drawmode 
       fcb 0,16 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:36|rel:-18)
; node # 48 D(-58,-16)->(-60,-17)
       fcb 2 ; drawmode 
       fcb -24,38 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-36|rel:37) dy(abs:18|rel:-18)
; node # 49 M(-52,-52)->(-51,-53)
       fcb 0 ; drawmode 
       fcb 36,6 ; starx/y relative to previous node
       fdb 0,54 ; dx/dy. dx(abs:18|rel:54) dy(abs:18|rel:0)
; node # 50 D(-33,-52)->(-37,-53)
       fcb 2 ; drawmode 
       fcb 0,19 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:-73|rel:-91) dy(abs:18|rel:0)
; node # 51 D(-39,-16)->(-45,-17)
       fcb 2 ; drawmode 
       fcb -36,-6 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:18|rel:0)
; node # 52 D(0,-18)->(-8,-18)
       fcb 2 ; drawmode 
       fcb 2,39 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:-18)
; node # 53 D(0,-52)->(-6,-52)
       fcb 2 ; drawmode 
       fcb 34,0 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:0)
; node # 54 D(-33,-52)->(-37,-53)
       fcb 2 ; drawmode 
       fcb 0,-33 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:18|rel:18)
; node # 55 D(0,-58)->(1,-58)
       fcb 2 ; drawmode 
       fcb 6,33 ; starx/y relative to previous node
       fdb -18,91 ; dx/dy. dx(abs:18|rel:91) dy(abs:0|rel:-18)
; node # 56 D(5,-66)->(6,-65)
       fcb 2 ; drawmode 
       fcb 8,5 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:-18|rel:-18)
; node # 57 D(-6,-66)->(-5,-66)
       fcb 2 ; drawmode 
       fcb 0,-11 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:18)
; node # 58 D(-6,-67)->(-3,-67)
       fcb 2 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:54|rel:36) dy(abs:0|rel:0)
; node # 59 D(0,-58)->(1,-58)
       fcb 2 ; drawmode 
       fcb -9,6 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:0|rel:0)
; node # 60 D(0,-52)->(-6,-52)
       fcb 2 ; drawmode 
       fcb -6,0 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-109|rel:-127) dy(abs:0|rel:0)
; node # 61 D(32,-52)->(27,-51)
       fcb 2 ; drawmode 
       fcb 0,32 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:-18|rel:-18)
; node # 62 D(0,-58)->(1,-58)
       fcb 2 ; drawmode 
       fcb 6,-32 ; starx/y relative to previous node
       fdb 18,109 ; dx/dy. dx(abs:18|rel:109) dy(abs:0|rel:18)
; node # 63 D(42,-51)->(49,-50)
       fcb 2 ; drawmode 
       fcb -7,42 ; starx/y relative to previous node
       fdb -18,110 ; dx/dy. dx(abs:128|rel:110) dy(abs:-18|rel:-18)
; node # 64 D(52,-51)->(51,-50)
       fcb 2 ; drawmode 
       fcb 0,10 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:-18|rel:-146) dy(abs:-18|rel:0)
; node # 65 D(62,-11)->(58,-11)
       fcb 2 ; drawmode 
       fcb -40,10 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-73|rel:-55) dy(abs:0|rel:18)
; node # 66 D(38,-16)->(30,-16)
       fcb 2 ; drawmode 
       fcb 5,-24 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:0|rel:0)
; node # 67 D(39,2)->(31,2)
       fcb 2 ; drawmode 
       fcb -18,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 68 D(64,10)->(60,10)
       fcb 2 ; drawmode 
       fcb -8,25 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-73|rel:73) dy(abs:0|rel:0)
; node # 69 D(46,32)->(43,31)
       fcb 2 ; drawmode 
       fcb -22,-18 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:-54|rel:19) dy(abs:18|rel:18)
; node # 70 D(29,24)->(22,23)
       fcb 2 ; drawmode 
       fcb 8,-17 ; starx/y relative to previous node
       fdb 0,-74 ; dx/dy. dx(abs:-128|rel:-74) dy(abs:18|rel:0)
; node # 71 D(39,2)->(31,2)
       fcb 2 ; drawmode 
       fcb 22,10 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:-18)
; node # 72 D(0,0)->(-9,0)
       fcb 2 ; drawmode 
       fcb 2,-39 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 73 D(0,21)->(-8,21)
       fcb 2 ; drawmode 
       fcb -21,0 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 74 D(-30,24)->(-37,24)
       fcb 2 ; drawmode 
       fcb -3,-30 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 75 M(46,32)->(43,31)
       fcb 0 ; drawmode 
       fcb -8,76 ; starx/y relative to previous node
       fdb 18,74 ; dx/dy. dx(abs:-54|rel:74) dy(abs:18|rel:18)
; node # 76 D(38,43)->(41,42)
       fcb 2 ; drawmode 
       fcb -11,-8 ; starx/y relative to previous node
       fdb 0,108 ; dx/dy. dx(abs:54|rel:108) dy(abs:18|rel:0)
; node # 77 M(0,21)->(-8,21)
       fcb 0 ; drawmode 
       fcb 22,-38 ; starx/y relative to previous node
       fdb -18,-200 ; dx/dy. dx(abs:-146|rel:-200) dy(abs:0|rel:-18)
; node # 78 D(29,24)->(22,23)
       fcb 2 ; drawmode 
       fcb -3,29 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:18|rel:18)
; node # 79 M(0,0)->(-9,0)
       fcb 0 ; drawmode 
       fcb 24,-29 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:-18)
; node # 80 D(0,-18)->(-8,-18)
       fcb 2 ; drawmode 
       fcb 18,0 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 81 D(38,-16)->(30,-16)
       fcb 2 ; drawmode 
       fcb -2,38 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 82 D(32,-52)->(27,-51)
       fcb 2 ; drawmode 
       fcb 36,-6 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-91|rel:55) dy(abs:-18|rel:-18)
; node # 83 D(52,-51)->(51,-50)
       fcb 2 ; drawmode 
       fcb -1,20 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-18|rel:73) dy(abs:-18|rel:0)
; node # 84 D(0,-58)->(1,-58)
       fcb 2 ; drawmode 
       fcb 7,-52 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:18|rel:36) dy(abs:0|rel:18)
; node # 85 M(5,-66)->(6,-65)
       fcb 0 ; drawmode 
       fcb 8,5 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:-18|rel:-18)
; node # 86 D(5,-67)->(8,-66)
       fcb 2 ; drawmode 
       fcb 1,0 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:54|rel:36) dy(abs:-18|rel:0)
; node # 87 D(-6,-67)->(-3,-67)
       fcb 2 ; drawmode 
       fcb 0,-11 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:0|rel:18)
; node # 88 M(-6,-66)->(-5,-66)
       fcb 0 ; drawmode 
       fcb -1,0 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:0|rel:0)
; node # 89 D(0,-58)->(1,-58)
       fcb 2 ; drawmode 
       fcb -8,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:0)
; node # 90 D(-52,-52)->(-51,-53)
       fcb 2 ; drawmode 
       fcb -6,-52 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:18|rel:18)
; node # 91 M(5,-67)->(8,-66)
       fcb 0 ; drawmode 
       fcb 15,57 ; starx/y relative to previous node
       fdb -36,36 ; dx/dy. dx(abs:54|rel:36) dy(abs:-18|rel:-36)
; node # 92 D(0,-58)->(1,-58)
       fcb 2 ; drawmode 
       fcb -9,-5 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:0|rel:18)
; node # 93 M(53,-34)->(51,-33)
       fcb 0 ; drawmode 
       fcb -24,53 ; starx/y relative to previous node
       fdb -18,-54 ; dx/dy. dx(abs:-36|rel:-54) dy(abs:-18|rel:-18)
; node # 94 D(93,-34)->(88,-32)
       fcb 2 ; drawmode 
       fcb 0,40 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-91|rel:-55) dy(abs:-36|rel:-18)
; node # 95 D(92,-16)->(87,-15)
       fcb 2 ; drawmode 
       fcb -18,-1 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-91|rel:0) dy(abs:-18|rel:18)
; node # 96 D(63,3)->(61,3)
       fcb 2 ; drawmode 
       fcb -19,-29 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-36|rel:55) dy(abs:0|rel:18)
; node # 97 D(60,1)->(56,1)
       fcb 2 ; drawmode 
       fcb 2,-3 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-73|rel:-37) dy(abs:0|rel:0)
; node # 98 D(88,-17)->(82,-16)
       fcb 2 ; drawmode 
       fcb 18,28 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:-18|rel:-18)
; node # 99 D(89,-33)->(83,-32)
       fcb 2 ; drawmode 
       fcb 16,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:-18|rel:0)
; node # 100 D(56,-33)->(55,-32)
       fcb 2 ; drawmode 
       fcb 0,-33 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:-18|rel:91) dy(abs:-18|rel:0)
; node # 101 D(53,-34)->(51,-33)
       fcb 2 ; drawmode 
       fcb 1,-3 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:-18|rel:0)
; node # 102 D(54,-40)->(53,-38)
       fcb 2 ; drawmode 
       fcb 6,1 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:-36|rel:-18)
; node # 103 D(97,-40)->(91,-37)
       fcb 2 ; drawmode 
       fcb 0,43 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:-109|rel:-91) dy(abs:-54|rel:-18)
; node # 104 D(96,-11)->(89,-10)
       fcb 2 ; drawmode 
       fcb -29,-1 ; starx/y relative to previous node
       fdb 36,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:-18|rel:36)
; node # 105 D(64,10)->(60,10)
       fcb 2 ; drawmode 
       fcb -21,-32 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-73|rel:55) dy(abs:0|rel:18)
; node # 106 D(60,1)->(56,1)
       fcb 2 ; drawmode 
       fcb 9,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-73|rel:0) dy(abs:0|rel:0)
; node # 107 M(0,0)->(-9,0)
       fcb 0 ; drawmode 
       fcb 1,-60 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:-164|rel:-91) dy(abs:0|rel:0)
; node # 108 D(-40,2)->(-47,2)
       fcb 2 ; drawmode 
       fcb -2,-40 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 109 M(28,-1)->(28,-1)
       fcb 0 ; drawmode 
       fcb 3,68 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:0)
; node # 110 M(89,-33)->(83,-32)
       fcb 0 ; drawmode 
       fcb 32,61 ; starx/y relative to previous node
       fdb -18,-109 ; dx/dy. dx(abs:-109|rel:-109) dy(abs:-18|rel:-18)
; node # 111 D(97,-40)->(91,-37)
       fcb 2 ; drawmode 
       fcb 7,8 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:-54|rel:-36)
; node # 112 M(64,10)->(60,10)
       fcb 0 ; drawmode 
       fcb -50,-33 ; starx/y relative to previous node
       fdb 54,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:0|rel:54)
; node # 113 D(63,3)->(61,3)
       fcb 2 ; drawmode 
       fcb 7,-1 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-36|rel:37) dy(abs:0|rel:0)
; node # 114 M(92,-16)->(87,-15)
       fcb 0 ; drawmode 
       fcb 19,29 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-91|rel:-55) dy(abs:-18|rel:-18)
; node # 115 D(96,-11)->(89,-10)
       fcb 2 ; drawmode 
       fcb -5,4 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:-18|rel:0)
; node # 116 D(88,-17)->(82,-16)
       fcb 2 ; drawmode 
       fcb 6,-8 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:-18|rel:0)
; node # 117 D(92,-16)->(87,-15)
       fcb 2 ; drawmode 
       fcb -1,4 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:-18|rel:0)
; node # 118 M(89,-33)->(83,-32)
       fcb 0 ; drawmode 
       fcb 17,-3 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:-18|rel:0)
; node # 119 D(93,-34)->(88,-32)
       fcb 2 ; drawmode 
       fcb 1,4 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:-36|rel:-18)
; node # 120 M(93,-34)->(88,-32)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-91|rel:0) dy(abs:-36|rel:0)
; node # 121 D(97,-40)->(91,-37)
       fcb 2 ; drawmode 
       fcb 6,4 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:-54|rel:-18)
; node # 122 M(56,-33)->(55,-32)
       fcb 0 ; drawmode 
       fcb -7,-41 ; starx/y relative to previous node
       fdb 36,91 ; dx/dy. dx(abs:-18|rel:91) dy(abs:-18|rel:36)
; node # 123 D(54,-40)->(53,-38)
       fcb 2 ; drawmode 
       fcb 7,-2 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:-36|rel:-18)
       fcb  1  ; end of anim
; Animation 6
teapotBframe6:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-47,2)->(-54,2)
       fcb 0 ; drawmode 
       fcb -2,-47 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:0|rel:0)
; node # 1 D(-66,11)->(-66,12)
       fcb 2 ; drawmode 
       fcb -9,-19 ; starx/y relative to previous node
       fdb -18,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:-18|rel:-18)
; node # 2 D(-48,33)->(-49,34)
       fcb 2 ; drawmode 
       fcb -22,18 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:-18|rel:0)
; node # 3 D(-37,24)->(-42,25)
       fcb 2 ; drawmode 
       fcb 9,11 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-91|rel:-73) dy(abs:-18|rel:0)
; node # 4 D(-47,2)->(-54,2)
       fcb 2 ; drawmode 
       fcb 22,-10 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:0|rel:18)
; node # 5 D(-45,-17)->(-51,-18)
       fcb 2 ; drawmode 
       fcb 19,2 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:18|rel:18)
; node # 6 D(-63,-12)->(-62,-12)
       fcb 2 ; drawmode 
       fcb -5,-18 ; starx/y relative to previous node
       fdb -18,127 ; dx/dy. dx(abs:18|rel:127) dy(abs:0|rel:-18)
; node # 7 D(-51,-53)->(-49,-55)
       fcb 2 ; drawmode 
       fcb 41,12 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:36|rel:36)
; node # 8 D(-34,-52)->(-23,-54)
       fcb 2 ; drawmode 
       fcb -1,17 ; starx/y relative to previous node
       fdb 0,165 ; dx/dy. dx(abs:201|rel:165) dy(abs:36|rel:0)
; node # 9 D(13,-51)->(24,-51)
       fcb 2 ; drawmode 
       fcb -1,47 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:201|rel:0) dy(abs:0|rel:-36)
; node # 10 D(14,0)->(27,0)
       fcb 2 ; drawmode 
       fcb -51,1 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:237|rel:36) dy(abs:0|rel:0)
; node # 11 D(13,28)->(26,28)
       fcb 2 ; drawmode 
       fcb -28,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:237|rel:0) dy(abs:0|rel:0)
; node # 12 D(8,48)->(16,48)
       fcb 2 ; drawmode 
       fcb -20,-5 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:146|rel:-91) dy(abs:0|rel:0)
; node # 13 D(41,42)->(44,41)
       fcb 2 ; drawmode 
       fcb 6,33 ; starx/y relative to previous node
       fdb 18,-92 ; dx/dy. dx(abs:54|rel:-92) dy(abs:18|rel:18)
; node # 14 D(60,22)->(64,21)
       fcb 2 ; drawmode 
       fcb 20,19 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:73|rel:19) dy(abs:18|rel:0)
; node # 15 D(59,-4)->(63,-4)
       fcb 2 ; drawmode 
       fcb 26,-1 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:73|rel:0) dy(abs:0|rel:-18)
; node # 16 D(14,0)->(27,0)
       fcb 2 ; drawmode 
       fcb -4,-45 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:237|rel:164) dy(abs:0|rel:0)
; node # 17 D(-44,-4)->(-33,-4)
       fcb 2 ; drawmode 
       fcb 4,-58 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:201|rel:-36) dy(abs:0|rel:0)
; node # 18 D(-34,-52)->(-23,-54)
       fcb 2 ; drawmode 
       fcb 48,10 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:201|rel:0) dy(abs:36|rel:36)
; node # 19 D(1,-58)->(3,-58)
       fcb 2 ; drawmode 
       fcb 6,35 ; starx/y relative to previous node
       fdb -36,-165 ; dx/dy. dx(abs:36|rel:-165) dy(abs:0|rel:-36)
; node # 20 D(13,-51)->(24,-51)
       fcb 2 ; drawmode 
       fcb -7,12 ; starx/y relative to previous node
       fdb 0,165 ; dx/dy. dx(abs:201|rel:165) dy(abs:0|rel:0)
; node # 21 D(49,-50)->(54,-48)
       fcb 2 ; drawmode 
       fcb -1,36 ; starx/y relative to previous node
       fdb -36,-110 ; dx/dy. dx(abs:91|rel:-110) dy(abs:-36|rel:-36)
; node # 22 D(59,-4)->(63,-4)
       fcb 2 ; drawmode 
       fcb -46,10 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:73|rel:-18) dy(abs:0|rel:36)
; node # 23 D(58,-11)->(55,-10)
       fcb 2 ; drawmode 
       fcb 7,-1 ; starx/y relative to previous node
       fdb -18,-127 ; dx/dy. dx(abs:-54|rel:-127) dy(abs:-18|rel:-18)
; node # 24 D(60,10)->(54,10)
       fcb 2 ; drawmode 
       fcb -21,2 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-109|rel:-55) dy(abs:0|rel:18)
; node # 25 D(60,22)->(64,21)
       fcb 2 ; drawmode 
       fcb -12,0 ; starx/y relative to previous node
       fdb 18,182 ; dx/dy. dx(abs:73|rel:182) dy(abs:18|rel:18)
; node # 26 D(13,28)->(26,28)
       fcb 2 ; drawmode 
       fcb -6,-47 ; starx/y relative to previous node
       fdb -18,164 ; dx/dy. dx(abs:237|rel:164) dy(abs:0|rel:-18)
; node # 27 D(-47,23)->(-36,24)
       fcb 2 ; drawmode 
       fcb 5,-60 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:201|rel:-36) dy(abs:-18|rel:-18)
; node # 28 D(-44,-4)->(-33,-4)
       fcb 2 ; drawmode 
       fcb 27,3 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:201|rel:0) dy(abs:0|rel:18)
; node # 29 D(-63,-12)->(-62,-12)
       fcb 2 ; drawmode 
       fcb 8,-19 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:18|rel:-183) dy(abs:0|rel:0)
; node # 30 D(-66,11)->(-66,12)
       fcb 2 ; drawmode 
       fcb -23,-3 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:-18|rel:-18)
; node # 31 D(-47,23)->(-36,24)
       fcb 2 ; drawmode 
       fcb -12,19 ; starx/y relative to previous node
       fdb 0,201 ; dx/dy. dx(abs:201|rel:201) dy(abs:-18|rel:0)
; node # 32 D(-33,44)->(-26,45)
       fcb 2 ; drawmode 
       fcb -21,14 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:128|rel:-73) dy(abs:-18|rel:0)
; node # 33 D(-48,33)->(-49,34)
       fcb 2 ; drawmode 
       fcb 11,-15 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:-18|rel:-146) dy(abs:-18|rel:0)
; node # 34 M(8,48)->(16,48)
       fcb 0 ; drawmode 
       fcb -15,56 ; starx/y relative to previous node
       fdb 18,164 ; dx/dy. dx(abs:146|rel:164) dy(abs:0|rel:18)
; node # 35 D(-33,44)->(-26,45)
       fcb 2 ; drawmode 
       fcb 4,-41 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:128|rel:-18) dy(abs:-18|rel:-18)
; node # 36 M(-66,11)->(-66,12)
       fcb 0 ; drawmode 
       fcb 33,-33 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:0|rel:-128) dy(abs:-18|rel:0)
; node # 37 D(-90,-23)->(-91,-25)
       fcb 2 ; drawmode 
       fcb 34,-24 ; starx/y relative to previous node
       fdb 54,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:36|rel:54)
; node # 38 D(-117,-43)->(-119,-46)
       fcb 2 ; drawmode 
       fcb 20,-27 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:54|rel:18)
; node # 39 D(-102,-42)->(-102,-45)
       fcb 2 ; drawmode 
       fcb -1,15 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:54|rel:0)
; node # 40 D(-60,-16)->(-60,-17)
       fcb 2 ; drawmode 
       fcb -26,42 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:18|rel:-36)
; node # 41 D(-66,11)->(-66,12)
       fcb 2 ; drawmode 
       fcb -27,-6 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-18|rel:-36)
; node # 42 D(-60,-17)->(-58,-17)
       fcb 2 ; drawmode 
       fcb 28,6 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:36|rel:36) dy(abs:0|rel:18)
; node # 43 D(-60,-16)->(-60,-17)
       fcb 2 ; drawmode 
       fcb -1,0 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:0|rel:-36) dy(abs:18|rel:18)
; node # 44 M(-100,-42)->(-101,-45)
       fcb 0 ; drawmode 
       fcb 26,-40 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:54|rel:36)
; node # 45 D(-102,-42)->(-102,-45)
       fcb 2 ; drawmode 
       fcb 0,-2 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:54|rel:0)
; node # 46 M(-117,-43)->(-119,-46)
       fcb 0 ; drawmode 
       fcb 1,-15 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:54|rel:0)
; node # 47 D(-100,-42)->(-101,-45)
       fcb 2 ; drawmode 
       fcb -1,17 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:54|rel:0)
; node # 48 D(-60,-17)->(-58,-17)
       fcb 2 ; drawmode 
       fcb -25,40 ; starx/y relative to previous node
       fdb -54,54 ; dx/dy. dx(abs:36|rel:54) dy(abs:0|rel:-54)
; node # 49 M(-51,-53)->(-49,-55)
       fcb 0 ; drawmode 
       fcb 36,9 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:36|rel:36)
; node # 50 D(-37,-53)->(-41,-53)
       fcb 2 ; drawmode 
       fcb 0,14 ; starx/y relative to previous node
       fdb -36,-109 ; dx/dy. dx(abs:-73|rel:-109) dy(abs:0|rel:-36)
; node # 51 D(-45,-17)->(-51,-18)
       fcb 2 ; drawmode 
       fcb -36,-8 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:18|rel:18)
; node # 52 D(-8,-18)->(-17,-18)
       fcb 2 ; drawmode 
       fcb 1,37 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:0|rel:-18)
; node # 53 D(-6,-52)->(-12,-51)
       fcb 2 ; drawmode 
       fcb 34,2 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:-18|rel:-18)
; node # 54 D(-37,-53)->(-41,-53)
       fcb 2 ; drawmode 
       fcb 1,-31 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:0|rel:18)
; node # 55 D(1,-58)->(3,-58)
       fcb 2 ; drawmode 
       fcb 5,38 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:36|rel:109) dy(abs:0|rel:0)
; node # 56 D(6,-65)->(7,-65)
       fcb 2 ; drawmode 
       fcb 7,5 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:0|rel:0)
; node # 57 D(-5,-66)->(-3,-66)
       fcb 2 ; drawmode 
       fcb 1,-11 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:0|rel:0)
; node # 58 D(-3,-67)->(0,-67)
       fcb 2 ; drawmode 
       fcb 1,2 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:0|rel:0)
; node # 59 D(1,-58)->(3,-58)
       fcb 2 ; drawmode 
       fcb -9,4 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:36|rel:-18) dy(abs:0|rel:0)
; node # 60 D(-6,-52)->(-12,-51)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb -18,-145 ; dx/dy. dx(abs:-109|rel:-145) dy(abs:-18|rel:-18)
; node # 61 D(27,-51)->(21,-49)
       fcb 2 ; drawmode 
       fcb -1,33 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:-36|rel:-18)
; node # 62 D(1,-58)->(3,-58)
       fcb 2 ; drawmode 
       fcb 7,-26 ; starx/y relative to previous node
       fdb 36,145 ; dx/dy. dx(abs:36|rel:145) dy(abs:0|rel:36)
; node # 63 D(49,-50)->(54,-48)
       fcb 2 ; drawmode 
       fcb -8,48 ; starx/y relative to previous node
       fdb -36,55 ; dx/dy. dx(abs:91|rel:55) dy(abs:-36|rel:-36)
; node # 64 D(51,-50)->(49,-48)
       fcb 2 ; drawmode 
       fcb 0,2 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-36|rel:-127) dy(abs:-36|rel:0)
; node # 65 D(58,-11)->(55,-10)
       fcb 2 ; drawmode 
       fcb -39,7 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-54|rel:-18) dy(abs:-18|rel:18)
; node # 66 D(30,-16)->(23,-16)
       fcb 2 ; drawmode 
       fcb 5,-28 ; starx/y relative to previous node
       fdb 18,-74 ; dx/dy. dx(abs:-128|rel:-74) dy(abs:0|rel:18)
; node # 67 D(31,2)->(22,2)
       fcb 2 ; drawmode 
       fcb -18,1 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 68 D(60,10)->(54,10)
       fcb 2 ; drawmode 
       fcb -8,29 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:0|rel:0)
; node # 69 D(43,31)->(39,30)
       fcb 2 ; drawmode 
       fcb -21,-17 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:18|rel:18)
; node # 70 D(22,23)->(15,23)
       fcb 2 ; drawmode 
       fcb 8,-21 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:0|rel:-18)
; node # 71 D(31,2)->(22,2)
       fcb 2 ; drawmode 
       fcb 21,9 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 72 D(-9,0)->(-18,0)
       fcb 2 ; drawmode 
       fcb 2,-40 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 73 D(-8,21)->(-15,21)
       fcb 2 ; drawmode 
       fcb -21,1 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 74 D(-37,24)->(-42,25)
       fcb 2 ; drawmode 
       fcb -3,-29 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:-18|rel:-18)
; node # 75 M(43,31)->(39,30)
       fcb 0 ; drawmode 
       fcb -7,80 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:18|rel:36)
; node # 76 D(41,42)->(44,41)
       fcb 2 ; drawmode 
       fcb -11,-2 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:54|rel:127) dy(abs:18|rel:0)
; node # 77 M(-8,21)->(-15,21)
       fcb 0 ; drawmode 
       fcb 21,-49 ; starx/y relative to previous node
       fdb -18,-182 ; dx/dy. dx(abs:-128|rel:-182) dy(abs:0|rel:-18)
; node # 78 D(22,23)->(15,23)
       fcb 2 ; drawmode 
       fcb -2,30 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:0)
; node # 79 M(-9,0)->(-18,0)
       fcb 0 ; drawmode 
       fcb 23,-31 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 80 D(-8,-18)->(-17,-18)
       fcb 2 ; drawmode 
       fcb 18,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 81 D(30,-16)->(23,-16)
       fcb 2 ; drawmode 
       fcb -2,38 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 82 D(27,-51)->(21,-49)
       fcb 2 ; drawmode 
       fcb 35,-3 ; starx/y relative to previous node
       fdb -36,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:-36|rel:-36)
; node # 83 D(51,-50)->(49,-48)
       fcb 2 ; drawmode 
       fcb -1,24 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-36|rel:73) dy(abs:-36|rel:0)
; node # 84 D(1,-58)->(3,-58)
       fcb 2 ; drawmode 
       fcb 8,-50 ; starx/y relative to previous node
       fdb 36,72 ; dx/dy. dx(abs:36|rel:72) dy(abs:0|rel:36)
; node # 85 M(6,-65)->(7,-65)
       fcb 0 ; drawmode 
       fcb 7,5 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:0|rel:0)
; node # 86 D(8,-66)->(11,-66)
       fcb 2 ; drawmode 
       fcb 1,2 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:54|rel:36) dy(abs:0|rel:0)
; node # 87 D(-3,-67)->(0,-67)
       fcb 2 ; drawmode 
       fcb 1,-11 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:0|rel:0)
; node # 88 M(-5,-66)->(-3,-66)
       fcb 0 ; drawmode 
       fcb -1,-2 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:36|rel:-18) dy(abs:0|rel:0)
; node # 89 D(1,-58)->(3,-58)
       fcb 2 ; drawmode 
       fcb -8,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:0|rel:0)
; node # 90 D(-51,-53)->(-49,-55)
       fcb 2 ; drawmode 
       fcb -5,-52 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:36|rel:36)
; node # 91 M(8,-66)->(11,-66)
       fcb 0 ; drawmode 
       fcb 13,59 ; starx/y relative to previous node
       fdb -36,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:0|rel:-36)
; node # 92 D(1,-58)->(3,-58)
       fcb 2 ; drawmode 
       fcb -8,-7 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:36|rel:-18) dy(abs:0|rel:0)
; node # 93 M(51,-33)->(47,-32)
       fcb 0 ; drawmode 
       fcb -25,50 ; starx/y relative to previous node
       fdb -18,-109 ; dx/dy. dx(abs:-73|rel:-109) dy(abs:-18|rel:-18)
; node # 94 D(88,-32)->(81,-30)
       fcb 2 ; drawmode 
       fcb -1,37 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:-36|rel:-18)
; node # 95 D(87,-15)->(80,-15)
       fcb 2 ; drawmode 
       fcb -17,-1 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:36)
; node # 96 D(61,3)->(57,3)
       fcb 2 ; drawmode 
       fcb -18,-26 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-73|rel:55) dy(abs:0|rel:0)
; node # 97 D(56,1)->(51,1)
       fcb 2 ; drawmode 
       fcb 2,-5 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-91|rel:-18) dy(abs:0|rel:0)
; node # 98 D(82,-16)->(74,-16)
       fcb 2 ; drawmode 
       fcb 17,26 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-146|rel:-55) dy(abs:0|rel:0)
; node # 99 D(83,-32)->(75,-30)
       fcb 2 ; drawmode 
       fcb 16,1 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:-36|rel:-36)
; node # 100 D(55,-32)->(53,-31)
       fcb 2 ; drawmode 
       fcb 0,-28 ; starx/y relative to previous node
       fdb 18,110 ; dx/dy. dx(abs:-36|rel:110) dy(abs:-18|rel:18)
; node # 101 D(51,-33)->(47,-32)
       fcb 2 ; drawmode 
       fcb 1,-4 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-73|rel:-37) dy(abs:-18|rel:0)
; node # 102 D(53,-38)->(49,-37)
       fcb 2 ; drawmode 
       fcb 5,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-73|rel:0) dy(abs:-18|rel:0)
; node # 103 D(91,-37)->(83,-35)
       fcb 2 ; drawmode 
       fcb -1,38 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:-36|rel:-18)
; node # 104 D(89,-10)->(81,-10)
       fcb 2 ; drawmode 
       fcb -27,-2 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:36)
; node # 105 D(60,10)->(54,10)
       fcb 2 ; drawmode 
       fcb -20,-29 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:0)
; node # 106 D(56,1)->(51,1)
       fcb 2 ; drawmode 
       fcb 9,-4 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:0|rel:0)
; node # 107 M(-9,0)->(-18,0)
       fcb 0 ; drawmode 
       fcb 1,-65 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-164|rel:-73) dy(abs:0|rel:0)
; node # 108 D(-47,2)->(-54,2)
       fcb 2 ; drawmode 
       fcb -2,-38 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 109 M(28,-1)->(28,-1)
       fcb 0 ; drawmode 
       fcb 3,75 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:0)
; node # 110 M(83,-32)->(75,-30)
       fcb 0 ; drawmode 
       fcb 31,55 ; starx/y relative to previous node
       fdb -36,-146 ; dx/dy. dx(abs:-146|rel:-146) dy(abs:-36|rel:-36)
; node # 111 D(91,-37)->(83,-35)
       fcb 2 ; drawmode 
       fcb 5,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:-36|rel:0)
; node # 112 M(60,10)->(54,10)
       fcb 0 ; drawmode 
       fcb -47,-31 ; starx/y relative to previous node
       fdb 36,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:36)
; node # 113 D(61,3)->(57,3)
       fcb 2 ; drawmode 
       fcb 7,1 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:0|rel:0)
; node # 114 M(87,-15)->(80,-15)
       fcb 0 ; drawmode 
       fcb 18,26 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:0|rel:0)
; node # 115 D(89,-10)->(81,-10)
       fcb 2 ; drawmode 
       fcb -5,2 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 116 D(82,-16)->(74,-16)
       fcb 2 ; drawmode 
       fcb 6,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 117 D(87,-15)->(80,-15)
       fcb 2 ; drawmode 
       fcb -1,5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 118 M(83,-32)->(75,-30)
       fcb 0 ; drawmode 
       fcb 17,-4 ; starx/y relative to previous node
       fdb -36,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:-36|rel:-36)
; node # 119 D(88,-32)->(81,-30)
       fcb 2 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:-36|rel:0)
; node # 120 M(88,-32)->(81,-30)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:-36|rel:0)
; node # 121 D(91,-37)->(83,-35)
       fcb 2 ; drawmode 
       fcb 5,3 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:-36|rel:0)
; node # 122 M(55,-32)->(53,-31)
       fcb 0 ; drawmode 
       fcb -5,-36 ; starx/y relative to previous node
       fdb 18,110 ; dx/dy. dx(abs:-36|rel:110) dy(abs:-18|rel:18)
; node # 123 D(53,-38)->(49,-37)
       fcb 2 ; drawmode 
       fcb 6,-2 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-73|rel:-37) dy(abs:-18|rel:0)
       fcb  1  ; end of anim
; Animation 7
teapotBframe7:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-54,2)->(-60,3)
       fcb 0 ; drawmode 
       fcb -2,-54 ; starx/y relative to previous node
       fdb -18,-109 ; dx/dy. dx(abs:-109|rel:-109) dy(abs:-18|rel:-18)
; node # 1 D(-66,12)->(-64,12)
       fcb 2 ; drawmode 
       fcb -10,-12 ; starx/y relative to previous node
       fdb 18,145 ; dx/dy. dx(abs:36|rel:145) dy(abs:0|rel:18)
; node # 2 D(-49,34)->(-47,35)
       fcb 2 ; drawmode 
       fcb -22,17 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:-18|rel:-18)
; node # 3 D(-42,25)->(-46,25)
       fcb 2 ; drawmode 
       fcb 9,7 ; starx/y relative to previous node
       fdb 18,-109 ; dx/dy. dx(abs:-73|rel:-109) dy(abs:0|rel:18)
; node # 4 D(-54,2)->(-60,3)
       fcb 2 ; drawmode 
       fcb 23,-12 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:-18|rel:-18)
; node # 5 D(-51,-18)->(-56,-18)
       fcb 2 ; drawmode 
       fcb 20,3 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:0|rel:18)
; node # 6 D(-62,-12)->(-59,-12)
       fcb 2 ; drawmode 
       fcb -6,-11 ; starx/y relative to previous node
       fdb 0,145 ; dx/dy. dx(abs:54|rel:145) dy(abs:0|rel:0)
; node # 7 D(-49,-55)->(-45,-56)
       fcb 2 ; drawmode 
       fcb 43,13 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:73|rel:19) dy(abs:18|rel:18)
; node # 8 D(-23,-54)->(-11,-54)
       fcb 2 ; drawmode 
       fcb -1,26 ; starx/y relative to previous node
       fdb -18,146 ; dx/dy. dx(abs:219|rel:146) dy(abs:0|rel:-18)
; node # 9 D(24,-51)->(35,-50)
       fcb 2 ; drawmode 
       fcb -3,47 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:-18|rel:-18)
; node # 10 D(27,0)->(39,0)
       fcb 2 ; drawmode 
       fcb -51,3 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:219|rel:18) dy(abs:0|rel:18)
; node # 11 D(26,28)->(38,27)
       fcb 2 ; drawmode 
       fcb -28,-1 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:219|rel:0) dy(abs:18|rel:18)
; node # 12 D(16,48)->(24,47)
       fcb 2 ; drawmode 
       fcb -20,-10 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:146|rel:-73) dy(abs:18|rel:0)
; node # 13 D(44,41)->(44,40)
       fcb 2 ; drawmode 
       fcb 7,28 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:0|rel:-146) dy(abs:18|rel:0)
; node # 14 D(64,21)->(65,20)
       fcb 2 ; drawmode 
       fcb 20,20 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:18|rel:0)
; node # 15 D(63,-4)->(65,-4)
       fcb 2 ; drawmode 
       fcb 25,-1 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:0|rel:-18)
; node # 16 D(27,0)->(39,0)
       fcb 2 ; drawmode 
       fcb -4,-36 ; starx/y relative to previous node
       fdb 0,183 ; dx/dy. dx(abs:219|rel:183) dy(abs:0|rel:0)
; node # 17 D(-33,-4)->(-20,-4)
       fcb 2 ; drawmode 
       fcb 4,-60 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:237|rel:18) dy(abs:0|rel:0)
; node # 18 D(-23,-54)->(-11,-54)
       fcb 2 ; drawmode 
       fcb 50,10 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:219|rel:-18) dy(abs:0|rel:0)
; node # 19 D(3,-58)->(5,-57)
       fcb 2 ; drawmode 
       fcb 4,26 ; starx/y relative to previous node
       fdb -18,-183 ; dx/dy. dx(abs:36|rel:-183) dy(abs:-18|rel:-18)
; node # 20 D(24,-51)->(35,-50)
       fcb 2 ; drawmode 
       fcb -7,21 ; starx/y relative to previous node
       fdb 0,165 ; dx/dy. dx(abs:201|rel:165) dy(abs:-18|rel:0)
; node # 21 D(54,-48)->(57,-47)
       fcb 2 ; drawmode 
       fcb -3,30 ; starx/y relative to previous node
       fdb 0,-147 ; dx/dy. dx(abs:54|rel:-147) dy(abs:-18|rel:0)
; node # 22 D(63,-4)->(65,-4)
       fcb 2 ; drawmode 
       fcb -44,9 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:36|rel:-18) dy(abs:0|rel:18)
; node # 23 D(55,-10)->(49,-10)
       fcb 2 ; drawmode 
       fcb 6,-8 ; starx/y relative to previous node
       fdb 0,-145 ; dx/dy. dx(abs:-109|rel:-145) dy(abs:0|rel:0)
; node # 24 D(54,10)->(49,10)
       fcb 2 ; drawmode 
       fcb -20,-1 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:0|rel:0)
; node # 25 D(64,21)->(65,20)
       fcb 2 ; drawmode 
       fcb -11,10 ; starx/y relative to previous node
       fdb 18,109 ; dx/dy. dx(abs:18|rel:109) dy(abs:18|rel:18)
; node # 26 D(26,28)->(38,27)
       fcb 2 ; drawmode 
       fcb -7,-38 ; starx/y relative to previous node
       fdb 0,201 ; dx/dy. dx(abs:219|rel:201) dy(abs:18|rel:0)
; node # 27 D(-36,24)->(-23,24)
       fcb 2 ; drawmode 
       fcb 4,-62 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:237|rel:18) dy(abs:0|rel:-18)
; node # 28 D(-33,-4)->(-20,-4)
       fcb 2 ; drawmode 
       fcb 28,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:237|rel:0) dy(abs:0|rel:0)
; node # 29 D(-62,-12)->(-59,-12)
       fcb 2 ; drawmode 
       fcb 8,-29 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:54|rel:-183) dy(abs:0|rel:0)
; node # 30 D(-66,12)->(-64,12)
       fcb 2 ; drawmode 
       fcb -24,-4 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:36|rel:-18) dy(abs:0|rel:0)
; node # 31 D(-36,24)->(-23,24)
       fcb 2 ; drawmode 
       fcb -12,30 ; starx/y relative to previous node
       fdb 0,201 ; dx/dy. dx(abs:237|rel:201) dy(abs:0|rel:0)
; node # 32 D(-26,45)->(-18,45)
       fcb 2 ; drawmode 
       fcb -21,10 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:146|rel:-91) dy(abs:0|rel:0)
; node # 33 D(-49,34)->(-47,35)
       fcb 2 ; drawmode 
       fcb 11,-23 ; starx/y relative to previous node
       fdb -18,-110 ; dx/dy. dx(abs:36|rel:-110) dy(abs:-18|rel:-18)
; node # 34 M(16,48)->(24,47)
       fcb 0 ; drawmode 
       fcb -14,65 ; starx/y relative to previous node
       fdb 36,110 ; dx/dy. dx(abs:146|rel:110) dy(abs:18|rel:36)
; node # 35 D(-26,45)->(-18,45)
       fcb 2 ; drawmode 
       fcb 3,-42 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:146|rel:0) dy(abs:0|rel:-18)
; node # 36 M(-66,12)->(-64,12)
       fcb 0 ; drawmode 
       fcb 33,-40 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:36|rel:-110) dy(abs:0|rel:0)
; node # 37 D(-91,-25)->(-88,-27)
       fcb 2 ; drawmode 
       fcb 37,-25 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:36|rel:36)
; node # 38 D(-119,-46)->(-116,-49)
       fcb 2 ; drawmode 
       fcb 21,-28 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:54|rel:18)
; node # 39 D(-102,-45)->(-99,-48)
       fcb 2 ; drawmode 
       fcb -1,17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:54|rel:0)
; node # 40 D(-60,-17)->(-57,-18)
       fcb 2 ; drawmode 
       fcb -28,42 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:18|rel:-36)
; node # 41 D(-66,12)->(-64,12)
       fcb 2 ; drawmode 
       fcb -29,-6 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:36|rel:-18) dy(abs:0|rel:-18)
; node # 42 D(-58,-17)->(-53,-17)
       fcb 2 ; drawmode 
       fcb 29,8 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:91|rel:55) dy(abs:0|rel:0)
; node # 43 D(-60,-17)->(-57,-18)
       fcb 2 ; drawmode 
       fcb 0,-2 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:54|rel:-37) dy(abs:18|rel:18)
; node # 44 M(-101,-45)->(-96,-48)
       fcb 0 ; drawmode 
       fcb 28,-41 ; starx/y relative to previous node
       fdb 36,37 ; dx/dy. dx(abs:91|rel:37) dy(abs:54|rel:36)
; node # 45 D(-102,-45)->(-99,-48)
       fcb 2 ; drawmode 
       fcb 0,-1 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:54|rel:-37) dy(abs:54|rel:0)
; node # 46 M(-119,-46)->(-116,-49)
       fcb 0 ; drawmode 
       fcb 1,-17 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:54|rel:0) dy(abs:54|rel:0)
; node # 47 D(-101,-45)->(-96,-48)
       fcb 2 ; drawmode 
       fcb -1,18 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:91|rel:37) dy(abs:54|rel:0)
; node # 48 D(-58,-17)->(-54,-17)
       fcb 2 ; drawmode 
       fcb -28,43 ; starx/y relative to previous node
       fdb -54,-18 ; dx/dy. dx(abs:73|rel:-18) dy(abs:0|rel:-54)
; node # 49 M(-49,-55)->(-45,-56)
       fcb 0 ; drawmode 
       fcb 38,9 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:73|rel:0) dy(abs:18|rel:18)
; node # 50 D(-41,-53)->(-44,-55)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb 18,-127 ; dx/dy. dx(abs:-54|rel:-127) dy(abs:36|rel:18)
; node # 51 D(-51,-18)->(-56,-18)
       fcb 2 ; drawmode 
       fcb -35,-10 ; starx/y relative to previous node
       fdb -36,-37 ; dx/dy. dx(abs:-91|rel:-37) dy(abs:0|rel:-36)
; node # 52 D(-17,-18)->(-25,-18)
       fcb 2 ; drawmode 
       fcb 0,34 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-146|rel:-55) dy(abs:0|rel:0)
; node # 53 D(-12,-51)->(-18,-52)
       fcb 2 ; drawmode 
       fcb 33,5 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:18|rel:18)
; node # 54 D(-41,-53)->(-44,-55)
       fcb 2 ; drawmode 
       fcb 2,-29 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-54|rel:55) dy(abs:36|rel:18)
; node # 55 D(3,-58)->(5,-57)
       fcb 2 ; drawmode 
       fcb 5,44 ; starx/y relative to previous node
       fdb -54,90 ; dx/dy. dx(abs:36|rel:90) dy(abs:-18|rel:-54)
; node # 56 D(7,-65)->(7,-65)
       fcb 2 ; drawmode 
       fcb 7,4 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:0|rel:-36) dy(abs:0|rel:18)
; node # 57 D(-3,-66)->(-2,-66)
       fcb 2 ; drawmode 
       fcb 1,-10 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:0|rel:0)
; node # 58 D(0,-67)->(3,-67)
       fcb 2 ; drawmode 
       fcb 1,3 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:54|rel:36) dy(abs:0|rel:0)
; node # 59 D(3,-58)->(5,-57)
       fcb 2 ; drawmode 
       fcb -9,3 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:36|rel:-18) dy(abs:-18|rel:-18)
; node # 60 D(-12,-51)->(-18,-52)
       fcb 2 ; drawmode 
       fcb -7,-15 ; starx/y relative to previous node
       fdb 36,-145 ; dx/dy. dx(abs:-109|rel:-145) dy(abs:18|rel:36)
; node # 61 D(21,-49)->(15,-49)
       fcb 2 ; drawmode 
       fcb -2,33 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:-18)
; node # 62 D(3,-58)->(5,-57)
       fcb 2 ; drawmode 
       fcb 9,-18 ; starx/y relative to previous node
       fdb -18,145 ; dx/dy. dx(abs:36|rel:145) dy(abs:-18|rel:-18)
; node # 63 D(54,-48)->(57,-47)
       fcb 2 ; drawmode 
       fcb -10,51 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:-18|rel:0)
; node # 64 D(49,-48)->(44,-47)
       fcb 2 ; drawmode 
       fcb 0,-5 ; starx/y relative to previous node
       fdb 0,-145 ; dx/dy. dx(abs:-91|rel:-145) dy(abs:-18|rel:0)
; node # 65 D(55,-10)->(49,-10)
       fcb 2 ; drawmode 
       fcb -38,6 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:0|rel:18)
; node # 66 D(23,-16)->(14,-15)
       fcb 2 ; drawmode 
       fcb 6,-32 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:-18|rel:-18)
; node # 67 D(22,2)->(13,2)
       fcb 2 ; drawmode 
       fcb -18,-1 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:18)
; node # 68 D(54,10)->(49,10)
       fcb 2 ; drawmode 
       fcb -8,32 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:0|rel:0)
; node # 69 D(39,30)->(34,30)
       fcb 2 ; drawmode 
       fcb -20,-15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-91|rel:0) dy(abs:0|rel:0)
; node # 70 D(15,23)->(8,23)
       fcb 2 ; drawmode 
       fcb 7,-24 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:0|rel:0)
; node # 71 D(22,2)->(13,2)
       fcb 2 ; drawmode 
       fcb 21,7 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 72 D(-18,0)->(-27,0)
       fcb 2 ; drawmode 
       fcb 2,-40 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 73 D(-15,21)->(-23,21)
       fcb 2 ; drawmode 
       fcb -21,3 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 74 D(-42,25)->(-46,25)
       fcb 2 ; drawmode 
       fcb -4,-27 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-73|rel:73) dy(abs:0|rel:0)
; node # 75 M(39,30)->(34,30)
       fcb 0 ; drawmode 
       fcb -5,81 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-91|rel:-18) dy(abs:0|rel:0)
; node # 76 D(44,41)->(44,40)
       fcb 2 ; drawmode 
       fcb -11,5 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:0|rel:91) dy(abs:18|rel:18)
; node # 77 M(-15,21)->(-23,21)
       fcb 0 ; drawmode 
       fcb 20,-59 ; starx/y relative to previous node
       fdb -18,-146 ; dx/dy. dx(abs:-146|rel:-146) dy(abs:0|rel:-18)
; node # 78 D(15,23)->(8,23)
       fcb 2 ; drawmode 
       fcb -2,30 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 79 M(-18,0)->(-27,0)
       fcb 0 ; drawmode 
       fcb 23,-33 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 80 D(-17,-18)->(-25,-18)
       fcb 2 ; drawmode 
       fcb 18,1 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 81 D(23,-16)->(14,-15)
       fcb 2 ; drawmode 
       fcb -2,40 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:-18|rel:-18)
; node # 82 D(21,-49)->(15,-49)
       fcb 2 ; drawmode 
       fcb 33,-2 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:0|rel:18)
; node # 83 D(49,-48)->(44,-47)
       fcb 2 ; drawmode 
       fcb -1,28 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:-18|rel:-18)
; node # 84 D(3,-58)->(5,-57)
       fcb 2 ; drawmode 
       fcb 10,-46 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:36|rel:127) dy(abs:-18|rel:0)
; node # 85 M(7,-65)->(7,-65)
       fcb 0 ; drawmode 
       fcb 7,4 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:0|rel:-36) dy(abs:0|rel:18)
; node # 86 D(11,-66)->(13,-65)
       fcb 2 ; drawmode 
       fcb 1,4 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:36|rel:36) dy(abs:-18|rel:-18)
; node # 87 D(0,-67)->(3,-67)
       fcb 2 ; drawmode 
       fcb 1,-11 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:0|rel:18)
; node # 88 M(-3,-66)->(-2,-66)
       fcb 0 ; drawmode 
       fcb -1,-3 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:0|rel:0)
; node # 89 D(3,-58)->(5,-57)
       fcb 2 ; drawmode 
       fcb -8,6 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:-18|rel:-18)
; node # 90 D(-49,-55)->(-45,-56)
       fcb 2 ; drawmode 
       fcb -3,-52 ; starx/y relative to previous node
       fdb 36,37 ; dx/dy. dx(abs:73|rel:37) dy(abs:18|rel:36)
; node # 91 M(11,-66)->(13,-65)
       fcb 0 ; drawmode 
       fcb 11,60 ; starx/y relative to previous node
       fdb -36,-37 ; dx/dy. dx(abs:36|rel:-37) dy(abs:-18|rel:-36)
; node # 92 D(3,-58)->(5,-57)
       fcb 2 ; drawmode 
       fcb -8,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:-18|rel:0)
; node # 93 M(47,-32)->(42,-31)
       fcb 0 ; drawmode 
       fcb -26,44 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-91|rel:-127) dy(abs:-18|rel:0)
; node # 94 D(81,-30)->(74,-29)
       fcb 2 ; drawmode 
       fcb -2,34 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:-18|rel:0)
; node # 95 D(80,-15)->(72,-14)
       fcb 2 ; drawmode 
       fcb -15,-1 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:-18|rel:0)
; node # 96 D(57,3)->(51,3)
       fcb 2 ; drawmode 
       fcb -18,-23 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:18)
; node # 97 D(51,1)->(44,1)
       fcb 2 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:0)
; node # 98 D(74,-16)->(65,-15)
       fcb 2 ; drawmode 
       fcb 17,23 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:-18|rel:-18)
; node # 99 D(75,-30)->(66,-29)
       fcb 2 ; drawmode 
       fcb 14,1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:-18|rel:0)
; node # 100 D(53,-31)->(48,-30)
       fcb 2 ; drawmode 
       fcb 1,-22 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:-18|rel:0)
; node # 101 D(47,-32)->(42,-31)
       fcb 2 ; drawmode 
       fcb 1,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-91|rel:0) dy(abs:-18|rel:0)
; node # 102 D(49,-37)->(46,-36)
       fcb 2 ; drawmode 
       fcb 5,2 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-54|rel:37) dy(abs:-18|rel:0)
; node # 103 D(83,-35)->(74,-34)
       fcb 2 ; drawmode 
       fcb -2,34 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:-164|rel:-110) dy(abs:-18|rel:0)
; node # 104 D(81,-10)->(71,-9)
       fcb 2 ; drawmode 
       fcb -25,-2 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-182|rel:-18) dy(abs:-18|rel:0)
; node # 105 D(54,10)->(49,10)
       fcb 2 ; drawmode 
       fcb -20,-27 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:-91|rel:91) dy(abs:0|rel:18)
; node # 106 D(51,1)->(44,1)
       fcb 2 ; drawmode 
       fcb 9,-3 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:0|rel:0)
; node # 107 M(-18,0)->(-27,0)
       fcb 0 ; drawmode 
       fcb 1,-69 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 108 D(-54,2)->(-60,3)
       fcb 2 ; drawmode 
       fcb -2,-36 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:-18|rel:-18)
; node # 109 M(28,-1)->(28,-1)
       fcb 0 ; drawmode 
       fcb 3,82 ; starx/y relative to previous node
       fdb 18,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:0|rel:18)
; node # 110 M(75,-30)->(66,-29)
       fcb 0 ; drawmode 
       fcb 29,47 ; starx/y relative to previous node
       fdb -18,-164 ; dx/dy. dx(abs:-164|rel:-164) dy(abs:-18|rel:-18)
; node # 111 D(83,-35)->(74,-34)
       fcb 2 ; drawmode 
       fcb 5,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:-18|rel:0)
; node # 112 M(54,10)->(49,10)
       fcb 0 ; drawmode 
       fcb -45,-29 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:0|rel:18)
; node # 113 D(57,3)->(51,3)
       fcb 2 ; drawmode 
       fcb 7,3 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:0|rel:0)
; node # 114 M(80,-15)->(72,-14)
       fcb 0 ; drawmode 
       fcb 18,23 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:-18|rel:-18)
; node # 115 D(81,-10)->(71,-9)
       fcb 2 ; drawmode 
       fcb -5,1 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-182|rel:-36) dy(abs:-18|rel:0)
; node # 116 D(74,-16)->(65,-15)
       fcb 2 ; drawmode 
       fcb 6,-7 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-164|rel:18) dy(abs:-18|rel:0)
; node # 117 D(80,-15)->(72,-14)
       fcb 2 ; drawmode 
       fcb -1,6 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:-18|rel:0)
; node # 118 M(75,-30)->(66,-29)
       fcb 0 ; drawmode 
       fcb 15,-5 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:-18|rel:0)
; node # 119 D(81,-30)->(74,-29)
       fcb 2 ; drawmode 
       fcb 0,6 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:-18|rel:0)
; node # 120 M(81,-30)->(74,-29)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:-18|rel:0)
; node # 121 D(83,-35)->(74,-34)
       fcb 2 ; drawmode 
       fcb 5,2 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:-18|rel:0)
; node # 122 M(53,-31)->(48,-30)
       fcb 0 ; drawmode 
       fcb -4,-30 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:-18|rel:0)
; node # 123 D(49,-37)->(46,-36)
       fcb 2 ; drawmode 
       fcb 6,-4 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-54|rel:37) dy(abs:-18|rel:0)
       fcb  1  ; end of anim
; Animation 8
teapotBframe8:
       fcb 15 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-60,3)->(-65,3)
       fcb 0 ; drawmode 
       fcb -3,-60 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:-85|rel:-85) dy(abs:0|rel:0)
; node # 1 D(-64,12)->(-59,13)
       fcb 2 ; drawmode 
       fcb -9,-4 ; starx/y relative to previous node
       fdb -17,170 ; dx/dy. dx(abs:85|rel:170) dy(abs:-17|rel:-17)
; node # 2 D(-47,35)->(-44,36)
       fcb 2 ; drawmode 
       fcb -23,17 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:51|rel:-34) dy(abs:-17|rel:0)
; node # 3 D(-46,25)->(-51,26)
       fcb 2 ; drawmode 
       fcb 10,1 ; starx/y relative to previous node
       fdb 0,-136 ; dx/dy. dx(abs:-85|rel:-136) dy(abs:-17|rel:0)
; node # 4 D(-60,3)->(-65,3)
       fcb 2 ; drawmode 
       fcb 22,-14 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-85|rel:0) dy(abs:0|rel:17)
; node # 5 D(-56,-18)->(-60,-18)
       fcb 2 ; drawmode 
       fcb 21,4 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-68|rel:17) dy(abs:0|rel:0)
; node # 6 D(-59,-12)->(-54,-13)
       fcb 2 ; drawmode 
       fcb -6,-3 ; starx/y relative to previous node
       fdb 17,153 ; dx/dy. dx(abs:85|rel:153) dy(abs:17|rel:17)
; node # 7 D(-45,-56)->(-38,-58)
       fcb 2 ; drawmode 
       fcb 44,14 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:119|rel:34) dy(abs:34|rel:17)
; node # 8 D(-11,-54)->(1,-54)
       fcb 2 ; drawmode 
       fcb -2,34 ; starx/y relative to previous node
       fdb -34,85 ; dx/dy. dx(abs:204|rel:85) dy(abs:0|rel:-34)
; node # 9 D(35,-50)->(44,-49)
       fcb 2 ; drawmode 
       fcb -4,46 ; starx/y relative to previous node
       fdb -17,-51 ; dx/dy. dx(abs:153|rel:-51) dy(abs:-17|rel:-17)
; node # 10 D(39,0)->(48,0)
       fcb 2 ; drawmode 
       fcb -50,4 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:0|rel:17)
; node # 11 D(38,27)->(47,26)
       fcb 2 ; drawmode 
       fcb -27,-1 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:153|rel:0) dy(abs:17|rel:17)
; node # 12 D(24,47)->(29,46)
       fcb 2 ; drawmode 
       fcb -20,-14 ; starx/y relative to previous node
       fdb 0,-68 ; dx/dy. dx(abs:85|rel:-68) dy(abs:17|rel:0)
; node # 13 D(44,40)->(44,39)
       fcb 2 ; drawmode 
       fcb 7,20 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:0|rel:-85) dy(abs:17|rel:0)
; node # 14 D(65,20)->(64,19)
       fcb 2 ; drawmode 
       fcb 20,21 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-17|rel:-17) dy(abs:17|rel:0)
; node # 15 D(65,-4)->(64,-3)
       fcb 2 ; drawmode 
       fcb 24,0 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:-17|rel:0) dy(abs:-17|rel:-34)
; node # 16 D(39,0)->(48,0)
       fcb 2 ; drawmode 
       fcb -4,-26 ; starx/y relative to previous node
       fdb 17,170 ; dx/dy. dx(abs:153|rel:170) dy(abs:0|rel:17)
; node # 17 D(-20,-4)->(-6,-4)
       fcb 2 ; drawmode 
       fcb 4,-59 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:238|rel:85) dy(abs:0|rel:0)
; node # 18 D(-11,-54)->(1,-54)
       fcb 2 ; drawmode 
       fcb 50,9 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:204|rel:-34) dy(abs:0|rel:0)
; node # 19 D(5,-57)->(6,-57)
       fcb 2 ; drawmode 
       fcb 3,16 ; starx/y relative to previous node
       fdb 0,-187 ; dx/dy. dx(abs:17|rel:-187) dy(abs:0|rel:0)
; node # 20 D(35,-50)->(44,-49)
       fcb 2 ; drawmode 
       fcb -7,30 ; starx/y relative to previous node
       fdb -17,136 ; dx/dy. dx(abs:153|rel:136) dy(abs:-17|rel:-17)
; node # 21 D(57,-47)->(58,-45)
       fcb 2 ; drawmode 
       fcb -3,22 ; starx/y relative to previous node
       fdb -17,-136 ; dx/dy. dx(abs:17|rel:-136) dy(abs:-34|rel:-17)
; node # 22 D(65,-4)->(64,-3)
       fcb 2 ; drawmode 
       fcb -43,8 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:-17|rel:-34) dy(abs:-17|rel:17)
; node # 23 D(49,-10)->(42,-10)
       fcb 2 ; drawmode 
       fcb 6,-16 ; starx/y relative to previous node
       fdb 17,-102 ; dx/dy. dx(abs:-119|rel:-102) dy(abs:0|rel:17)
; node # 24 D(49,10)->(41,9)
       fcb 2 ; drawmode 
       fcb -20,0 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:17|rel:17)
; node # 25 D(65,20)->(64,19)
       fcb 2 ; drawmode 
       fcb -10,16 ; starx/y relative to previous node
       fdb 0,119 ; dx/dy. dx(abs:-17|rel:119) dy(abs:17|rel:0)
; node # 26 D(38,27)->(47,26)
       fcb 2 ; drawmode 
       fcb -7,-27 ; starx/y relative to previous node
       fdb 0,170 ; dx/dy. dx(abs:153|rel:170) dy(abs:17|rel:0)
; node # 27 D(-23,24)->(-10,24)
       fcb 2 ; drawmode 
       fcb 3,-61 ; starx/y relative to previous node
       fdb -17,68 ; dx/dy. dx(abs:221|rel:68) dy(abs:0|rel:-17)
; node # 28 D(-20,-4)->(-6,-4)
       fcb 2 ; drawmode 
       fcb 28,3 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:238|rel:17) dy(abs:0|rel:0)
; node # 29 D(-59,-12)->(-54,-13)
       fcb 2 ; drawmode 
       fcb 8,-39 ; starx/y relative to previous node
       fdb 17,-153 ; dx/dy. dx(abs:85|rel:-153) dy(abs:17|rel:17)
; node # 30 D(-64,12)->(-59,13)
       fcb 2 ; drawmode 
       fcb -24,-5 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:85|rel:0) dy(abs:-17|rel:-34)
; node # 31 D(-23,24)->(-10,24)
       fcb 2 ; drawmode 
       fcb -12,41 ; starx/y relative to previous node
       fdb 17,136 ; dx/dy. dx(abs:221|rel:136) dy(abs:0|rel:17)
; node # 32 D(-18,45)->(-10,46)
       fcb 2 ; drawmode 
       fcb -21,5 ; starx/y relative to previous node
       fdb -17,-85 ; dx/dy. dx(abs:136|rel:-85) dy(abs:-17|rel:-17)
; node # 33 D(-47,35)->(-44,36)
       fcb 2 ; drawmode 
       fcb 10,-29 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:51|rel:-85) dy(abs:-17|rel:0)
; node # 34 M(24,47)->(29,46)
       fcb 0 ; drawmode 
       fcb -12,71 ; starx/y relative to previous node
       fdb 34,34 ; dx/dy. dx(abs:85|rel:34) dy(abs:17|rel:34)
; node # 35 D(-18,45)->(-10,46)
       fcb 2 ; drawmode 
       fcb 2,-42 ; starx/y relative to previous node
       fdb -34,51 ; dx/dy. dx(abs:136|rel:51) dy(abs:-17|rel:-34)
; node # 36 M(-64,12)->(-59,13)
       fcb 0 ; drawmode 
       fcb 33,-46 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:85|rel:-51) dy(abs:-17|rel:0)
; node # 37 D(-88,-27)->(-80,-27)
       fcb 2 ; drawmode 
       fcb 39,-24 ; starx/y relative to previous node
       fdb 17,51 ; dx/dy. dx(abs:136|rel:51) dy(abs:0|rel:17)
; node # 38 D(-116,-49)->(-108,-53)
       fcb 2 ; drawmode 
       fcb 22,-28 ; starx/y relative to previous node
       fdb 68,0 ; dx/dy. dx(abs:136|rel:0) dy(abs:68|rel:68)
; node # 39 D(-99,-48)->(-92,-51)
       fcb 2 ; drawmode 
       fcb -1,17 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:119|rel:-17) dy(abs:51|rel:-17)
; node # 40 D(-57,-18)->(-54,-19)
       fcb 2 ; drawmode 
       fcb -30,42 ; starx/y relative to previous node
       fdb -34,-68 ; dx/dy. dx(abs:51|rel:-68) dy(abs:17|rel:-34)
; node # 41 D(-64,12)->(-59,13)
       fcb 2 ; drawmode 
       fcb -30,-7 ; starx/y relative to previous node
       fdb -34,34 ; dx/dy. dx(abs:85|rel:34) dy(abs:-17|rel:-34)
; node # 42 D(-53,-17)->(-47,-17)
       fcb 2 ; drawmode 
       fcb 29,11 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:102|rel:17) dy(abs:0|rel:17)
; node # 43 D(-57,-18)->(-54,-19)
       fcb 2 ; drawmode 
       fcb 1,-4 ; starx/y relative to previous node
       fdb 17,-51 ; dx/dy. dx(abs:51|rel:-51) dy(abs:17|rel:17)
; node # 44 M(-96,-48)->(-86,-50)
       fcb 0 ; drawmode 
       fcb 30,-39 ; starx/y relative to previous node
       fdb 17,119 ; dx/dy. dx(abs:170|rel:119) dy(abs:34|rel:17)
; node # 45 D(-99,-48)->(-92,-51)
       fcb 2 ; drawmode 
       fcb 0,-3 ; starx/y relative to previous node
       fdb 17,-51 ; dx/dy. dx(abs:119|rel:-51) dy(abs:51|rel:17)
; node # 46 M(-116,-49)->(-108,-53)
       fcb 0 ; drawmode 
       fcb 1,-17 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:136|rel:17) dy(abs:68|rel:17)
; node # 47 D(-96,-48)->(-86,-50)
       fcb 2 ; drawmode 
       fcb -1,20 ; starx/y relative to previous node
       fdb -34,34 ; dx/dy. dx(abs:170|rel:34) dy(abs:34|rel:-34)
; node # 48 D(-54,-17)->(-47,-17)
       fcb 2 ; drawmode 
       fcb -31,42 ; starx/y relative to previous node
       fdb -34,-51 ; dx/dy. dx(abs:119|rel:-51) dy(abs:0|rel:-34)
; node # 49 M(-45,-56)->(-38,-58)
       fcb 0 ; drawmode 
       fcb 39,9 ; starx/y relative to previous node
       fdb 34,0 ; dx/dy. dx(abs:119|rel:0) dy(abs:34|rel:34)
; node # 50 D(-44,-55)->(-45,-56)
       fcb 2 ; drawmode 
       fcb -1,1 ; starx/y relative to previous node
       fdb -17,-136 ; dx/dy. dx(abs:-17|rel:-136) dy(abs:17|rel:-17)
; node # 51 D(-56,-18)->(-60,-18)
       fcb 2 ; drawmode 
       fcb -37,-12 ; starx/y relative to previous node
       fdb -17,-51 ; dx/dy. dx(abs:-68|rel:-51) dy(abs:0|rel:-17)
; node # 52 D(-25,-18)->(-33,-19)
       fcb 2 ; drawmode 
       fcb 0,31 ; starx/y relative to previous node
       fdb 17,-68 ; dx/dy. dx(abs:-136|rel:-68) dy(abs:17|rel:17)
; node # 53 D(-18,-52)->(-24,-53)
       fcb 2 ; drawmode 
       fcb 34,7 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-102|rel:34) dy(abs:17|rel:0)
; node # 54 D(-44,-55)->(-45,-56)
       fcb 2 ; drawmode 
       fcb 3,-26 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:-17|rel:85) dy(abs:17|rel:0)
; node # 55 D(5,-57)->(6,-57)
       fcb 2 ; drawmode 
       fcb 2,49 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:17|rel:34) dy(abs:0|rel:-17)
; node # 56 D(7,-65)->(8,-65)
       fcb 2 ; drawmode 
       fcb 8,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:17|rel:0) dy(abs:0|rel:0)
; node # 57 D(-2,-66)->(0,-66)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:34|rel:17) dy(abs:0|rel:0)
; node # 58 D(3,-67)->(7,-66)
       fcb 2 ; drawmode 
       fcb 1,5 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:68|rel:34) dy(abs:-17|rel:-17)
; node # 59 D(5,-57)->(6,-57)
       fcb 2 ; drawmode 
       fcb -10,2 ; starx/y relative to previous node
       fdb 17,-51 ; dx/dy. dx(abs:17|rel:-51) dy(abs:0|rel:17)
; node # 60 D(-18,-52)->(-24,-53)
       fcb 2 ; drawmode 
       fcb -5,-23 ; starx/y relative to previous node
       fdb 17,-119 ; dx/dy. dx(abs:-102|rel:-119) dy(abs:17|rel:17)
; node # 61 D(15,-49)->(9,-48)
       fcb 2 ; drawmode 
       fcb -3,33 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:-102|rel:0) dy(abs:-17|rel:-34)
; node # 62 D(5,-57)->(6,-57)
       fcb 2 ; drawmode 
       fcb 8,-10 ; starx/y relative to previous node
       fdb 17,119 ; dx/dy. dx(abs:17|rel:119) dy(abs:0|rel:17)
; node # 63 D(57,-47)->(58,-45)
       fcb 2 ; drawmode 
       fcb -10,52 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:17|rel:0) dy(abs:-34|rel:-34)
; node # 64 D(44,-47)->(40,-45)
       fcb 2 ; drawmode 
       fcb 0,-13 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:-68|rel:-85) dy(abs:-34|rel:0)
; node # 65 D(49,-10)->(42,-10)
       fcb 2 ; drawmode 
       fcb -37,5 ; starx/y relative to previous node
       fdb 34,-51 ; dx/dy. dx(abs:-119|rel:-51) dy(abs:0|rel:34)
; node # 66 D(14,-15)->(5,-15)
       fcb 2 ; drawmode 
       fcb 5,-35 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-153|rel:-34) dy(abs:0|rel:0)
; node # 67 D(13,2)->(4,2)
       fcb 2 ; drawmode 
       fcb -17,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-153|rel:0) dy(abs:0|rel:0)
; node # 68 D(49,10)->(41,9)
       fcb 2 ; drawmode 
       fcb -8,36 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-136|rel:17) dy(abs:17|rel:17)
; node # 69 D(34,30)->(28,29)
       fcb 2 ; drawmode 
       fcb -20,-15 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-102|rel:34) dy(abs:17|rel:0)
; node # 70 D(8,23)->(0,23)
       fcb 2 ; drawmode 
       fcb 7,-26 ; starx/y relative to previous node
       fdb -17,-34 ; dx/dy. dx(abs:-136|rel:-34) dy(abs:0|rel:-17)
; node # 71 D(13,2)->(4,2)
       fcb 2 ; drawmode 
       fcb 21,5 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-153|rel:-17) dy(abs:0|rel:0)
; node # 72 D(-27,0)->(-36,0)
       fcb 2 ; drawmode 
       fcb 2,-40 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-153|rel:0) dy(abs:0|rel:0)
; node # 73 D(-23,21)->(-30,21)
       fcb 2 ; drawmode 
       fcb -21,4 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-119|rel:34) dy(abs:0|rel:0)
; node # 74 D(-46,25)->(-51,26)
       fcb 2 ; drawmode 
       fcb -4,-23 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:-85|rel:34) dy(abs:-17|rel:-17)
; node # 75 M(34,30)->(28,29)
       fcb 0 ; drawmode 
       fcb -5,80 ; starx/y relative to previous node
       fdb 34,-17 ; dx/dy. dx(abs:-102|rel:-17) dy(abs:17|rel:34)
; node # 76 D(44,40)->(44,39)
       fcb 2 ; drawmode 
       fcb -10,10 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:0|rel:102) dy(abs:17|rel:0)
; node # 77 M(-23,21)->(-30,21)
       fcb 0 ; drawmode 
       fcb 19,-67 ; starx/y relative to previous node
       fdb -17,-119 ; dx/dy. dx(abs:-119|rel:-119) dy(abs:0|rel:-17)
; node # 78 D(8,23)->(0,23)
       fcb 2 ; drawmode 
       fcb -2,31 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-136|rel:-17) dy(abs:0|rel:0)
; node # 79 M(-27,0)->(-36,0)
       fcb 0 ; drawmode 
       fcb 23,-35 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-153|rel:-17) dy(abs:0|rel:0)
; node # 80 D(-25,-18)->(-33,-19)
       fcb 2 ; drawmode 
       fcb 18,2 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-136|rel:17) dy(abs:17|rel:17)
; node # 81 D(14,-15)->(5,-15)
       fcb 2 ; drawmode 
       fcb -3,39 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-153|rel:-17) dy(abs:0|rel:-17)
; node # 82 D(15,-49)->(9,-48)
       fcb 2 ; drawmode 
       fcb 34,1 ; starx/y relative to previous node
       fdb -17,51 ; dx/dy. dx(abs:-102|rel:51) dy(abs:-17|rel:-17)
; node # 83 D(44,-47)->(40,-45)
       fcb 2 ; drawmode 
       fcb -2,29 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:-68|rel:34) dy(abs:-34|rel:-17)
; node # 84 D(5,-57)->(6,-57)
       fcb 2 ; drawmode 
       fcb 10,-39 ; starx/y relative to previous node
       fdb 34,85 ; dx/dy. dx(abs:17|rel:85) dy(abs:0|rel:34)
; node # 85 M(7,-65)->(8,-65)
       fcb 0 ; drawmode 
       fcb 8,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:17|rel:0) dy(abs:0|rel:0)
; node # 86 D(13,-65)->(15,-65)
       fcb 2 ; drawmode 
       fcb 0,6 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:34|rel:17) dy(abs:0|rel:0)
; node # 87 D(3,-67)->(7,-66)
       fcb 2 ; drawmode 
       fcb 2,-10 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:68|rel:34) dy(abs:-17|rel:-17)
; node # 88 M(-2,-66)->(0,-66)
       fcb 0 ; drawmode 
       fcb -1,-5 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:34|rel:-34) dy(abs:0|rel:17)
; node # 89 D(5,-57)->(6,-57)
       fcb 2 ; drawmode 
       fcb -9,7 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:17|rel:-17) dy(abs:0|rel:0)
; node # 90 D(-45,-56)->(-38,-58)
       fcb 2 ; drawmode 
       fcb -1,-50 ; starx/y relative to previous node
       fdb 34,102 ; dx/dy. dx(abs:119|rel:102) dy(abs:34|rel:34)
; node # 91 M(13,-65)->(15,-65)
       fcb 0 ; drawmode 
       fcb 9,58 ; starx/y relative to previous node
       fdb -34,-85 ; dx/dy. dx(abs:34|rel:-85) dy(abs:0|rel:-34)
; node # 92 D(5,-57)->(6,-57)
       fcb 2 ; drawmode 
       fcb -8,-8 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:17|rel:-17) dy(abs:0|rel:0)
; node # 93 M(42,-31)->(36,-30)
       fcb 0 ; drawmode 
       fcb -26,37 ; starx/y relative to previous node
       fdb -17,-119 ; dx/dy. dx(abs:-102|rel:-119) dy(abs:-17|rel:-17)
; node # 94 D(74,-29)->(64,-27)
       fcb 2 ; drawmode 
       fcb -2,32 ; starx/y relative to previous node
       fdb -17,-68 ; dx/dy. dx(abs:-170|rel:-68) dy(abs:-34|rel:-17)
; node # 95 D(72,-14)->(62,-13)
       fcb 2 ; drawmode 
       fcb -15,-2 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-170|rel:0) dy(abs:-17|rel:17)
; node # 96 D(51,3)->(45,3)
       fcb 2 ; drawmode 
       fcb -17,-21 ; starx/y relative to previous node
       fdb 17,68 ; dx/dy. dx(abs:-102|rel:68) dy(abs:0|rel:17)
; node # 97 D(44,1)->(38,1)
       fcb 2 ; drawmode 
       fcb 2,-7 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-102|rel:0) dy(abs:0|rel:0)
; node # 98 D(65,-15)->(54,-14)
       fcb 2 ; drawmode 
       fcb 16,21 ; starx/y relative to previous node
       fdb -17,-85 ; dx/dy. dx(abs:-187|rel:-85) dy(abs:-17|rel:-17)
; node # 99 D(66,-29)->(56,-28)
       fcb 2 ; drawmode 
       fcb 14,1 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-170|rel:17) dy(abs:-17|rel:0)
; node # 100 D(48,-30)->(44,-29)
       fcb 2 ; drawmode 
       fcb 1,-18 ; starx/y relative to previous node
       fdb 0,102 ; dx/dy. dx(abs:-68|rel:102) dy(abs:-17|rel:0)
; node # 101 D(42,-31)->(36,-30)
       fcb 2 ; drawmode 
       fcb 1,-6 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-102|rel:-34) dy(abs:-17|rel:0)
; node # 102 D(46,-36)->(41,-35)
       fcb 2 ; drawmode 
       fcb 5,4 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-85|rel:17) dy(abs:-17|rel:0)
; node # 103 D(74,-34)->(64,-32)
       fcb 2 ; drawmode 
       fcb -2,28 ; starx/y relative to previous node
       fdb -17,-85 ; dx/dy. dx(abs:-170|rel:-85) dy(abs:-34|rel:-17)
; node # 104 D(71,-9)->(61,-9)
       fcb 2 ; drawmode 
       fcb -25,-3 ; starx/y relative to previous node
       fdb 34,0 ; dx/dy. dx(abs:-170|rel:0) dy(abs:0|rel:34)
; node # 105 D(49,10)->(41,9)
       fcb 2 ; drawmode 
       fcb -19,-22 ; starx/y relative to previous node
       fdb 17,34 ; dx/dy. dx(abs:-136|rel:34) dy(abs:17|rel:17)
; node # 106 D(44,1)->(38,1)
       fcb 2 ; drawmode 
       fcb 9,-5 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:-102|rel:34) dy(abs:0|rel:-17)
; node # 107 M(-27,0)->(-36,0)
       fcb 0 ; drawmode 
       fcb 1,-71 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:-153|rel:-51) dy(abs:0|rel:0)
; node # 108 D(-60,3)->(-65,3)
       fcb 2 ; drawmode 
       fcb -3,-33 ; starx/y relative to previous node
       fdb 0,68 ; dx/dy. dx(abs:-85|rel:68) dy(abs:0|rel:0)
; node # 109 M(28,-1)->(28,-1)
       fcb 0 ; drawmode 
       fcb 4,88 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:0|rel:85) dy(abs:0|rel:0)
; node # 110 M(66,-29)->(56,-28)
       fcb 0 ; drawmode 
       fcb 28,38 ; starx/y relative to previous node
       fdb -17,-170 ; dx/dy. dx(abs:-170|rel:-170) dy(abs:-17|rel:-17)
; node # 111 D(74,-34)->(64,-32)
       fcb 2 ; drawmode 
       fcb 5,8 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-170|rel:0) dy(abs:-34|rel:-17)
; node # 112 M(49,10)->(41,9)
       fcb 0 ; drawmode 
       fcb -44,-25 ; starx/y relative to previous node
       fdb 51,34 ; dx/dy. dx(abs:-136|rel:34) dy(abs:17|rel:51)
; node # 113 D(51,3)->(45,3)
       fcb 2 ; drawmode 
       fcb 7,2 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:-102|rel:34) dy(abs:0|rel:-17)
; node # 114 M(72,-14)->(62,-13)
       fcb 0 ; drawmode 
       fcb 17,21 ; starx/y relative to previous node
       fdb -17,-68 ; dx/dy. dx(abs:-170|rel:-68) dy(abs:-17|rel:-17)
; node # 115 D(71,-9)->(61,-9)
       fcb 2 ; drawmode 
       fcb -5,-1 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:-170|rel:0) dy(abs:0|rel:17)
; node # 116 D(65,-15)->(54,-14)
       fcb 2 ; drawmode 
       fcb 6,-6 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-187|rel:-17) dy(abs:-17|rel:-17)
; node # 117 D(72,-14)->(62,-13)
       fcb 2 ; drawmode 
       fcb -1,7 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-170|rel:17) dy(abs:-17|rel:0)
; node # 118 M(66,-29)->(56,-28)
       fcb 0 ; drawmode 
       fcb 15,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-170|rel:0) dy(abs:-17|rel:0)
; node # 119 D(74,-29)->(64,-27)
       fcb 2 ; drawmode 
       fcb 0,8 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-170|rel:0) dy(abs:-34|rel:-17)
; node # 120 M(74,-29)->(64,-27)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-170|rel:0) dy(abs:-34|rel:0)
; node # 121 D(74,-34)->(64,-32)
       fcb 2 ; drawmode 
       fcb 5,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-170|rel:0) dy(abs:-34|rel:0)
; node # 122 M(48,-30)->(44,-29)
       fcb 0 ; drawmode 
       fcb -4,-26 ; starx/y relative to previous node
       fdb 17,102 ; dx/dy. dx(abs:-68|rel:102) dy(abs:-17|rel:17)
; node # 123 D(46,-36)->(41,-35)
       fcb 2 ; drawmode 
       fcb 6,-2 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-85|rel:-17) dy(abs:-17|rel:0)
       fcb  1  ; end of anim
; Animation 9
teapotBframe9:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-65,3)->(-68,3)
       fcb 0 ; drawmode 
       fcb -3,-65 ; starx/y relative to previous node
       fdb 0,-54 ; dx/dy. dx(abs:-54|rel:-54) dy(abs:0|rel:0)
; node # 1 D(-59,13)->(-52,13)
       fcb 2 ; drawmode 
       fcb -10,6 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:128|rel:182) dy(abs:0|rel:0)
; node # 2 D(-44,36)->(-40,37)
       fcb 2 ; drawmode 
       fcb -23,15 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:73|rel:-55) dy(abs:-18|rel:-18)
; node # 3 D(-51,26)->(-52,27)
       fcb 2 ; drawmode 
       fcb 10,-7 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:-18|rel:-91) dy(abs:-18|rel:0)
; node # 4 D(-65,3)->(-68,3)
       fcb 2 ; drawmode 
       fcb 23,-14 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-54|rel:-36) dy(abs:0|rel:18)
; node # 5 D(-60,-18)->(-62,-19)
       fcb 2 ; drawmode 
       fcb 21,5 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:18|rel:18)
; node # 6 D(-54,-13)->(-46,-13)
       fcb 2 ; drawmode 
       fcb -5,6 ; starx/y relative to previous node
       fdb -18,182 ; dx/dy. dx(abs:146|rel:182) dy(abs:0|rel:-18)
; node # 7 D(-38,-58)->(-31,-59)
       fcb 2 ; drawmode 
       fcb 45,16 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:128|rel:-18) dy(abs:18|rel:18)
; node # 8 D(1,-54)->(13,-55)
       fcb 2 ; drawmode 
       fcb -4,39 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:219|rel:91) dy(abs:18|rel:0)
; node # 9 D(44,-49)->(51,-47)
       fcb 2 ; drawmode 
       fcb -5,43 ; starx/y relative to previous node
       fdb -54,-91 ; dx/dy. dx(abs:128|rel:-91) dy(abs:-36|rel:-54)
; node # 10 D(48,0)->(56,0)
       fcb 2 ; drawmode 
       fcb -49,4 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:146|rel:18) dy(abs:0|rel:36)
; node # 11 D(47,26)->(54,26)
       fcb 2 ; drawmode 
       fcb -26,-1 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:128|rel:-18) dy(abs:0|rel:0)
; node # 12 D(29,46)->(34,45)
       fcb 2 ; drawmode 
       fcb -20,-18 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:91|rel:-37) dy(abs:18|rel:18)
; node # 13 D(44,39)->(42,38)
       fcb 2 ; drawmode 
       fcb 7,15 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-36|rel:-127) dy(abs:18|rel:0)
; node # 14 D(64,19)->(62,18)
       fcb 2 ; drawmode 
       fcb 20,20 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:18|rel:0)
; node # 15 D(64,-3)->(62,-3)
       fcb 2 ; drawmode 
       fcb 22,0 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:-18)
; node # 16 D(48,0)->(56,0)
       fcb 2 ; drawmode 
       fcb -3,-16 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:146|rel:182) dy(abs:0|rel:0)
; node # 17 D(-6,-4)->(8,-4)
       fcb 2 ; drawmode 
       fcb 4,-54 ; starx/y relative to previous node
       fdb 0,110 ; dx/dy. dx(abs:256|rel:110) dy(abs:0|rel:0)
; node # 18 D(1,-54)->(13,-55)
       fcb 2 ; drawmode 
       fcb 50,7 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:219|rel:-37) dy(abs:18|rel:18)
; node # 19 D(6,-57)->(7,-56)
       fcb 2 ; drawmode 
       fcb 3,5 ; starx/y relative to previous node
       fdb -36,-201 ; dx/dy. dx(abs:18|rel:-201) dy(abs:-18|rel:-36)
; node # 20 D(44,-49)->(51,-47)
       fcb 2 ; drawmode 
       fcb -8,38 ; starx/y relative to previous node
       fdb -18,110 ; dx/dy. dx(abs:128|rel:110) dy(abs:-36|rel:-18)
; node # 21 D(58,-45)->(57,-44)
       fcb 2 ; drawmode 
       fcb -4,14 ; starx/y relative to previous node
       fdb 18,-146 ; dx/dy. dx(abs:-18|rel:-146) dy(abs:-18|rel:18)
; node # 22 D(64,-3)->(62,-3)
       fcb 2 ; drawmode 
       fcb -42,6 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:0|rel:18)
; node # 23 D(42,-10)->(35,-9)
       fcb 2 ; drawmode 
       fcb 7,-22 ; starx/y relative to previous node
       fdb -18,-92 ; dx/dy. dx(abs:-128|rel:-92) dy(abs:-18|rel:-18)
; node # 24 D(41,9)->(34,9)
       fcb 2 ; drawmode 
       fcb -19,-1 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:18)
; node # 25 D(64,19)->(62,18)
       fcb 2 ; drawmode 
       fcb -10,23 ; starx/y relative to previous node
       fdb 18,92 ; dx/dy. dx(abs:-36|rel:92) dy(abs:18|rel:18)
; node # 26 D(47,26)->(54,26)
       fcb 2 ; drawmode 
       fcb -7,-17 ; starx/y relative to previous node
       fdb -18,164 ; dx/dy. dx(abs:128|rel:164) dy(abs:0|rel:-18)
; node # 27 D(-10,24)->(5,24)
       fcb 2 ; drawmode 
       fcb 2,-57 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:274|rel:146) dy(abs:0|rel:0)
; node # 28 D(-6,-4)->(8,-4)
       fcb 2 ; drawmode 
       fcb 28,4 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:256|rel:-18) dy(abs:0|rel:0)
; node # 29 D(-54,-13)->(-46,-13)
       fcb 2 ; drawmode 
       fcb 9,-48 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:146|rel:-110) dy(abs:0|rel:0)
; node # 30 D(-59,13)->(-52,13)
       fcb 2 ; drawmode 
       fcb -26,-5 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:128|rel:-18) dy(abs:0|rel:0)
; node # 31 D(-10,24)->(5,24)
       fcb 2 ; drawmode 
       fcb -11,49 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:274|rel:146) dy(abs:0|rel:0)
; node # 32 D(-10,46)->(-1,46)
       fcb 2 ; drawmode 
       fcb -22,0 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:164|rel:-110) dy(abs:0|rel:0)
; node # 33 D(-44,36)->(-40,37)
       fcb 2 ; drawmode 
       fcb 10,-34 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:73|rel:-91) dy(abs:-18|rel:-18)
; node # 34 M(29,46)->(34,45)
       fcb 0 ; drawmode 
       fcb -10,73 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:91|rel:18) dy(abs:18|rel:36)
; node # 35 D(-10,46)->(-1,46)
       fcb 2 ; drawmode 
       fcb 0,-39 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:164|rel:73) dy(abs:0|rel:-18)
; node # 36 M(-59,13)->(-52,13)
       fcb 0 ; drawmode 
       fcb 33,-49 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:128|rel:-36) dy(abs:0|rel:0)
; node # 37 D(-80,-27)->(-70,-29)
       fcb 2 ; drawmode 
       fcb 40,-21 ; starx/y relative to previous node
       fdb 36,54 ; dx/dy. dx(abs:182|rel:54) dy(abs:36|rel:36)
; node # 38 D(-108,-53)->(-95,-56)
       fcb 2 ; drawmode 
       fcb 26,-28 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:237|rel:55) dy(abs:54|rel:18)
; node # 39 D(-92,-51)->(-82,-54)
       fcb 2 ; drawmode 
       fcb -2,16 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:182|rel:-55) dy(abs:54|rel:0)
; node # 40 D(-54,-19)->(-47,-19)
       fcb 2 ; drawmode 
       fcb -32,38 ; starx/y relative to previous node
       fdb -54,-54 ; dx/dy. dx(abs:128|rel:-54) dy(abs:0|rel:-54)
; node # 41 D(-59,13)->(-52,13)
       fcb 2 ; drawmode 
       fcb -32,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:128|rel:0) dy(abs:0|rel:0)
; node # 42 D(-47,-17)->(-38,-18)
       fcb 2 ; drawmode 
       fcb 30,12 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:164|rel:36) dy(abs:18|rel:18)
; node # 43 D(-54,-19)->(-47,-19)
       fcb 2 ; drawmode 
       fcb 2,-7 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:128|rel:-36) dy(abs:0|rel:-18)
; node # 44 M(-86,-50)->(-72,-53)
       fcb 0 ; drawmode 
       fcb 31,-32 ; starx/y relative to previous node
       fdb 54,128 ; dx/dy. dx(abs:256|rel:128) dy(abs:54|rel:54)
; node # 45 D(-92,-51)->(-82,-54)
       fcb 2 ; drawmode 
       fcb 1,-6 ; starx/y relative to previous node
       fdb 0,-74 ; dx/dy. dx(abs:182|rel:-74) dy(abs:54|rel:0)
; node # 46 M(-108,-53)->(-95,-56)
       fcb 0 ; drawmode 
       fcb 2,-16 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:237|rel:55) dy(abs:54|rel:0)
; node # 47 D(-86,-50)->(-72,-53)
       fcb 2 ; drawmode 
       fcb -3,22 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:256|rel:19) dy(abs:54|rel:0)
; node # 48 D(-47,-17)->(-38,-18)
       fcb 2 ; drawmode 
       fcb -33,39 ; starx/y relative to previous node
       fdb -36,-92 ; dx/dy. dx(abs:164|rel:-92) dy(abs:18|rel:-36)
; node # 49 M(-38,-58)->(-31,-59)
       fcb 0 ; drawmode 
       fcb 41,9 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:128|rel:-36) dy(abs:18|rel:0)
; node # 50 D(-45,-56)->(-45,-58)
       fcb 2 ; drawmode 
       fcb -2,-7 ; starx/y relative to previous node
       fdb 18,-128 ; dx/dy. dx(abs:0|rel:-128) dy(abs:36|rel:18)
; node # 51 D(-60,-18)->(-62,-19)
       fcb 2 ; drawmode 
       fcb -38,-15 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:18|rel:-18)
; node # 52 D(-33,-19)->(-40,-19)
       fcb 2 ; drawmode 
       fcb 1,27 ; starx/y relative to previous node
       fdb -18,-92 ; dx/dy. dx(abs:-128|rel:-92) dy(abs:0|rel:-18)
; node # 53 D(-24,-53)->(-29,-54)
       fcb 2 ; drawmode 
       fcb 34,9 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:18|rel:18)
; node # 54 D(-45,-56)->(-45,-58)
       fcb 2 ; drawmode 
       fcb 3,-21 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:0|rel:91) dy(abs:36|rel:18)
; node # 55 D(6,-57)->(7,-56)
       fcb 2 ; drawmode 
       fcb 1,51 ; starx/y relative to previous node
       fdb -54,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:-18|rel:-54)
; node # 56 D(8,-65)->(7,-64)
       fcb 2 ; drawmode 
       fcb 8,2 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:-18|rel:0)
; node # 57 D(0,-66)->(1,-66)
       fcb 2 ; drawmode 
       fcb 1,-8 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:18|rel:36) dy(abs:0|rel:18)
; node # 58 D(7,-66)->(9,-66)
       fcb 2 ; drawmode 
       fcb 0,7 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:0|rel:0)
; node # 59 D(6,-57)->(7,-56)
       fcb 2 ; drawmode 
       fcb -9,-1 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:-18|rel:-18)
; node # 60 D(-24,-53)->(-29,-54)
       fcb 2 ; drawmode 
       fcb -4,-30 ; starx/y relative to previous node
       fdb 36,-109 ; dx/dy. dx(abs:-91|rel:-109) dy(abs:18|rel:36)
; node # 61 D(9,-48)->(2,-48)
       fcb 2 ; drawmode 
       fcb -5,33 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:0|rel:-18)
; node # 62 D(6,-57)->(7,-56)
       fcb 2 ; drawmode 
       fcb 9,-3 ; starx/y relative to previous node
       fdb -18,146 ; dx/dy. dx(abs:18|rel:146) dy(abs:-18|rel:-18)
; node # 63 D(58,-45)->(57,-44)
       fcb 2 ; drawmode 
       fcb -12,52 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:-18|rel:0)
; node # 64 D(40,-45)->(35,-44)
       fcb 2 ; drawmode 
       fcb 0,-18 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-91|rel:-73) dy(abs:-18|rel:0)
; node # 65 D(42,-10)->(35,-9)
       fcb 2 ; drawmode 
       fcb -35,2 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:-18|rel:0)
; node # 66 D(5,-15)->(-3,-15)
       fcb 2 ; drawmode 
       fcb 5,-37 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:18)
; node # 67 D(4,2)->(-5,2)
       fcb 2 ; drawmode 
       fcb -17,-1 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 68 D(41,9)->(34,9)
       fcb 2 ; drawmode 
       fcb -7,37 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 69 D(28,29)->(23,29)
       fcb 2 ; drawmode 
       fcb -20,-13 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:0|rel:0)
; node # 70 D(0,23)->(-7,23)
       fcb 2 ; drawmode 
       fcb 6,-28 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:0|rel:0)
; node # 71 D(4,2)->(-5,2)
       fcb 2 ; drawmode 
       fcb 21,4 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 72 D(-36,0)->(-44,0)
       fcb 2 ; drawmode 
       fcb 2,-40 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 73 D(-30,21)->(-36,21)
       fcb 2 ; drawmode 
       fcb -21,6 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:0)
; node # 74 D(-51,26)->(-52,27)
       fcb 2 ; drawmode 
       fcb -5,-21 ; starx/y relative to previous node
       fdb -18,91 ; dx/dy. dx(abs:-18|rel:91) dy(abs:-18|rel:-18)
; node # 75 M(28,29)->(23,29)
       fcb 0 ; drawmode 
       fcb -3,79 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-91|rel:-73) dy(abs:0|rel:18)
; node # 76 D(44,39)->(42,38)
       fcb 2 ; drawmode 
       fcb -10,16 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-36|rel:55) dy(abs:18|rel:18)
; node # 77 M(-30,21)->(-36,21)
       fcb 0 ; drawmode 
       fcb 18,-74 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-109|rel:-73) dy(abs:0|rel:-18)
; node # 78 D(0,23)->(-7,23)
       fcb 2 ; drawmode 
       fcb -2,30 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:0)
; node # 79 M(-36,0)->(-44,0)
       fcb 0 ; drawmode 
       fcb 23,-36 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 80 D(-33,-19)->(-40,-19)
       fcb 2 ; drawmode 
       fcb 19,3 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 81 D(5,-15)->(-3,-15)
       fcb 2 ; drawmode 
       fcb -4,38 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 82 D(9,-48)->(2,-48)
       fcb 2 ; drawmode 
       fcb 33,4 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 83 D(40,-45)->(35,-44)
       fcb 2 ; drawmode 
       fcb -3,31 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:-18|rel:-18)
; node # 84 D(6,-57)->(7,-56)
       fcb 2 ; drawmode 
       fcb 12,-34 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:18|rel:109) dy(abs:-18|rel:0)
; node # 85 M(8,-65)->(7,-64)
       fcb 0 ; drawmode 
       fcb 8,2 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:-18|rel:0)
; node # 86 D(15,-65)->(16,-64)
       fcb 2 ; drawmode 
       fcb 0,7 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:18|rel:36) dy(abs:-18|rel:0)
; node # 87 D(7,-66)->(9,-66)
       fcb 2 ; drawmode 
       fcb 1,-8 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:0|rel:18)
; node # 88 M(0,-66)->(1,-66)
       fcb 0 ; drawmode 
       fcb 0,-7 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:0|rel:0)
; node # 89 D(6,-57)->(7,-56)
       fcb 2 ; drawmode 
       fcb -9,6 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:-18|rel:-18)
; node # 90 D(-38,-58)->(-31,-59)
       fcb 2 ; drawmode 
       fcb 1,-44 ; starx/y relative to previous node
       fdb 36,110 ; dx/dy. dx(abs:128|rel:110) dy(abs:18|rel:36)
; node # 91 M(15,-65)->(16,-64)
       fcb 0 ; drawmode 
       fcb 7,53 ; starx/y relative to previous node
       fdb -36,-110 ; dx/dy. dx(abs:18|rel:-110) dy(abs:-18|rel:-36)
; node # 92 D(6,-57)->(7,-56)
       fcb 2 ; drawmode 
       fcb -8,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:-18|rel:0)
; node # 93 M(36,-30)->(30,-30)
       fcb 0 ; drawmode 
       fcb -27,30 ; starx/y relative to previous node
       fdb 18,-127 ; dx/dy. dx(abs:-109|rel:-127) dy(abs:0|rel:18)
; node # 94 D(64,-27)->(54,-26)
       fcb 2 ; drawmode 
       fcb -3,28 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-182|rel:-73) dy(abs:-18|rel:-18)
; node # 95 D(62,-13)->(52,-13)
       fcb 2 ; drawmode 
       fcb -14,-2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-182|rel:0) dy(abs:0|rel:18)
; node # 96 D(45,3)->(37,3)
       fcb 2 ; drawmode 
       fcb -16,-17 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-146|rel:36) dy(abs:0|rel:0)
; node # 97 D(38,1)->(29,1)
       fcb 2 ; drawmode 
       fcb 2,-7 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 98 D(54,-14)->(44,-14)
       fcb 2 ; drawmode 
       fcb 15,16 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-182|rel:-18) dy(abs:0|rel:0)
; node # 99 D(56,-28)->(46,-27)
       fcb 2 ; drawmode 
       fcb 14,2 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-182|rel:0) dy(abs:-18|rel:-18)
; node # 100 D(44,-29)->(38,-29)
       fcb 2 ; drawmode 
       fcb 1,-12 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-109|rel:73) dy(abs:0|rel:18)
; node # 101 D(36,-30)->(30,-30)
       fcb 2 ; drawmode 
       fcb 1,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:0)
; node # 102 D(41,-35)->(35,-34)
       fcb 2 ; drawmode 
       fcb 5,5 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:-18|rel:-18)
; node # 103 D(64,-32)->(53,-31)
       fcb 2 ; drawmode 
       fcb -3,23 ; starx/y relative to previous node
       fdb 0,-92 ; dx/dy. dx(abs:-201|rel:-92) dy(abs:-18|rel:0)
; node # 104 D(61,-9)->(50,-9)
       fcb 2 ; drawmode 
       fcb -23,-3 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:0|rel:18)
; node # 105 D(41,9)->(34,9)
       fcb 2 ; drawmode 
       fcb -18,-20 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-128|rel:73) dy(abs:0|rel:0)
; node # 106 D(38,1)->(29,1)
       fcb 2 ; drawmode 
       fcb 8,-3 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 107 M(-36,0)->(-44,0)
       fcb 0 ; drawmode 
       fcb 1,-74 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 108 D(-65,3)->(-68,3)
       fcb 2 ; drawmode 
       fcb -3,-29 ; starx/y relative to previous node
       fdb 0,92 ; dx/dy. dx(abs:-54|rel:92) dy(abs:0|rel:0)
; node # 109 M(28,-1)->(28,-1)
       fcb 0 ; drawmode 
       fcb 4,93 ; starx/y relative to previous node
       fdb 0,54 ; dx/dy. dx(abs:0|rel:54) dy(abs:0|rel:0)
; node # 110 M(56,-28)->(46,-27)
       fcb 0 ; drawmode 
       fcb 27,28 ; starx/y relative to previous node
       fdb -18,-182 ; dx/dy. dx(abs:-182|rel:-182) dy(abs:-18|rel:-18)
; node # 111 D(64,-32)->(53,-31)
       fcb 2 ; drawmode 
       fcb 4,8 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-201|rel:-19) dy(abs:-18|rel:0)
; node # 112 M(41,9)->(34,9)
       fcb 0 ; drawmode 
       fcb -41,-23 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-128|rel:73) dy(abs:0|rel:18)
; node # 113 D(45,3)->(37,3)
       fcb 2 ; drawmode 
       fcb 6,4 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 114 M(62,-13)->(52,-13)
       fcb 0 ; drawmode 
       fcb 16,17 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-182|rel:-36) dy(abs:0|rel:0)
; node # 115 D(61,-9)->(50,-9)
       fcb 2 ; drawmode 
       fcb -4,-1 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-201|rel:-19) dy(abs:0|rel:0)
; node # 116 D(54,-14)->(44,-14)
       fcb 2 ; drawmode 
       fcb 5,-7 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:-182|rel:19) dy(abs:0|rel:0)
; node # 117 D(62,-13)->(52,-13)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-182|rel:0) dy(abs:0|rel:0)
; node # 118 M(56,-28)->(46,-27)
       fcb 0 ; drawmode 
       fcb 15,-6 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-182|rel:0) dy(abs:-18|rel:-18)
; node # 119 D(64,-27)->(54,-26)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-182|rel:0) dy(abs:-18|rel:0)
; node # 120 M(64,-27)->(54,-26)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-182|rel:0) dy(abs:-18|rel:0)
; node # 121 D(64,-32)->(53,-31)
       fcb 2 ; drawmode 
       fcb 5,0 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-201|rel:-19) dy(abs:-18|rel:0)
; node # 122 M(44,-29)->(38,-29)
       fcb 0 ; drawmode 
       fcb -3,-20 ; starx/y relative to previous node
       fdb 18,92 ; dx/dy. dx(abs:-109|rel:92) dy(abs:0|rel:18)
; node # 123 D(41,-35)->(35,-34)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:-18|rel:-18)
       fcb  1  ; end of anim
; Animation 10
teapotBframe10:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-68,3)->(-69,3)
       fcb 0 ; drawmode 
       fcb -3,-68 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:0|rel:0)
; node # 1 D(-52,13)->(-42,13)
       fcb 2 ; drawmode 
       fcb -10,16 ; starx/y relative to previous node
       fdb 0,200 ; dx/dy. dx(abs:182|rel:200) dy(abs:0|rel:0)
; node # 2 D(-40,37)->(-33,38)
       fcb 2 ; drawmode 
       fcb -24,12 ; starx/y relative to previous node
       fdb -18,-54 ; dx/dy. dx(abs:128|rel:-54) dy(abs:-18|rel:-18)
; node # 3 D(-52,27)->(-53,28)
       fcb 2 ; drawmode 
       fcb 10,-12 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:-18|rel:-146) dy(abs:-18|rel:0)
; node # 4 D(-68,3)->(-69,3)
       fcb 2 ; drawmode 
       fcb 24,-16 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:0|rel:18)
; node # 5 D(-62,-19)->(-62,-20)
       fcb 2 ; drawmode 
       fcb 22,6 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:18|rel:18)
; node # 6 D(-46,-13)->(-36,-14)
       fcb 2 ; drawmode 
       fcb -6,16 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:182|rel:182) dy(abs:18|rel:0)
; node # 7 D(-31,-59)->(-21,-60)
       fcb 2 ; drawmode 
       fcb 46,15 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:182|rel:0) dy(abs:18|rel:0)
; node # 8 D(13,-55)->(25,-54)
       fcb 2 ; drawmode 
       fcb -4,44 ; starx/y relative to previous node
       fdb -36,37 ; dx/dy. dx(abs:219|rel:37) dy(abs:-18|rel:-36)
; node # 9 D(51,-47)->(56,-46)
       fcb 2 ; drawmode 
       fcb -8,38 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:91|rel:-128) dy(abs:-18|rel:0)
; node # 10 D(56,0)->(61,0)
       fcb 2 ; drawmode 
       fcb -47,5 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:91|rel:0) dy(abs:0|rel:18)
; node # 11 D(54,26)->(59,25)
       fcb 2 ; drawmode 
       fcb -26,-2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:91|rel:0) dy(abs:18|rel:18)
; node # 12 D(34,45)->(38,44)
       fcb 2 ; drawmode 
       fcb -19,-20 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:73|rel:-18) dy(abs:18|rel:0)
; node # 13 D(42,38)->(39,37)
       fcb 2 ; drawmode 
       fcb 7,8 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-54|rel:-127) dy(abs:18|rel:0)
; node # 14 D(62,18)->(57,18)
       fcb 2 ; drawmode 
       fcb 20,20 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-91|rel:-37) dy(abs:0|rel:-18)
; node # 15 D(62,-3)->(58,-3)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:0|rel:0)
; node # 16 D(56,0)->(61,0)
       fcb 2 ; drawmode 
       fcb -3,-6 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:91|rel:164) dy(abs:0|rel:0)
; node # 17 D(8,-4)->(22,-4)
       fcb 2 ; drawmode 
       fcb 4,-48 ; starx/y relative to previous node
       fdb 0,165 ; dx/dy. dx(abs:256|rel:165) dy(abs:0|rel:0)
; node # 18 D(13,-55)->(25,-54)
       fcb 2 ; drawmode 
       fcb 51,5 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:219|rel:-37) dy(abs:-18|rel:-18)
; node # 19 D(7,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb 1,-6 ; starx/y relative to previous node
       fdb 18,-201 ; dx/dy. dx(abs:18|rel:-201) dy(abs:0|rel:18)
; node # 20 D(51,-47)->(56,-46)
       fcb 2 ; drawmode 
       fcb -9,44 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:91|rel:73) dy(abs:-18|rel:-18)
; node # 21 D(57,-44)->(54,-42)
       fcb 2 ; drawmode 
       fcb -3,6 ; starx/y relative to previous node
       fdb -18,-145 ; dx/dy. dx(abs:-54|rel:-145) dy(abs:-36|rel:-18)
; node # 22 D(62,-3)->(58,-3)
       fcb 2 ; drawmode 
       fcb -41,5 ; starx/y relative to previous node
       fdb 36,-19 ; dx/dy. dx(abs:-73|rel:-19) dy(abs:0|rel:36)
; node # 23 D(35,-9)->(27,-9)
       fcb 2 ; drawmode 
       fcb 6,-27 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:0|rel:0)
; node # 24 D(34,9)->(25,9)
       fcb 2 ; drawmode 
       fcb -18,-1 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 25 D(62,18)->(57,18)
       fcb 2 ; drawmode 
       fcb -9,28 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:0|rel:0)
; node # 26 D(54,26)->(59,25)
       fcb 2 ; drawmode 
       fcb -8,-8 ; starx/y relative to previous node
       fdb 18,182 ; dx/dy. dx(abs:91|rel:182) dy(abs:18|rel:18)
; node # 27 D(5,24)->(19,24)
       fcb 2 ; drawmode 
       fcb 2,-49 ; starx/y relative to previous node
       fdb -18,165 ; dx/dy. dx(abs:256|rel:165) dy(abs:0|rel:-18)
; node # 28 D(8,-4)->(22,-4)
       fcb 2 ; drawmode 
       fcb 28,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:256|rel:0) dy(abs:0|rel:0)
; node # 29 D(-46,-13)->(-36,-14)
       fcb 2 ; drawmode 
       fcb 9,-54 ; starx/y relative to previous node
       fdb 18,-74 ; dx/dy. dx(abs:182|rel:-74) dy(abs:18|rel:18)
; node # 30 D(-52,13)->(-42,13)
       fcb 2 ; drawmode 
       fcb -26,-6 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:182|rel:0) dy(abs:0|rel:-18)
; node # 31 D(5,24)->(19,24)
       fcb 2 ; drawmode 
       fcb -11,57 ; starx/y relative to previous node
       fdb 0,74 ; dx/dy. dx(abs:256|rel:74) dy(abs:0|rel:0)
; node # 32 D(-1,46)->(8,46)
       fcb 2 ; drawmode 
       fcb -22,-6 ; starx/y relative to previous node
       fdb 0,-92 ; dx/dy. dx(abs:164|rel:-92) dy(abs:0|rel:0)
; node # 33 D(-40,37)->(-33,38)
       fcb 2 ; drawmode 
       fcb 9,-39 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:128|rel:-36) dy(abs:-18|rel:-18)
; node # 34 M(34,45)->(38,44)
       fcb 0 ; drawmode 
       fcb -8,74 ; starx/y relative to previous node
       fdb 36,-55 ; dx/dy. dx(abs:73|rel:-55) dy(abs:18|rel:36)
; node # 35 D(-1,46)->(8,46)
       fcb 2 ; drawmode 
       fcb -1,-35 ; starx/y relative to previous node
       fdb -18,91 ; dx/dy. dx(abs:164|rel:91) dy(abs:0|rel:-18)
; node # 36 M(-52,13)->(-42,13)
       fcb 0 ; drawmode 
       fcb 33,-51 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:182|rel:18) dy(abs:0|rel:0)
; node # 37 D(-70,-29)->(-55,-29)
       fcb 2 ; drawmode 
       fcb 42,-18 ; starx/y relative to previous node
       fdb 0,92 ; dx/dy. dx(abs:274|rel:92) dy(abs:0|rel:0)
; node # 38 D(-95,-56)->(-75,-59)
       fcb 2 ; drawmode 
       fcb 27,-25 ; starx/y relative to previous node
       fdb 54,91 ; dx/dy. dx(abs:365|rel:91) dy(abs:54|rel:54)
; node # 39 D(-82,-54)->(-66,-56)
       fcb 2 ; drawmode 
       fcb -2,13 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:292|rel:-73) dy(abs:36|rel:-18)
; node # 40 D(-47,-19)->(-39,-20)
       fcb 2 ; drawmode 
       fcb -35,35 ; starx/y relative to previous node
       fdb -18,-146 ; dx/dy. dx(abs:146|rel:-146) dy(abs:18|rel:-18)
; node # 41 D(-52,13)->(-42,13)
       fcb 2 ; drawmode 
       fcb -32,-5 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:182|rel:36) dy(abs:0|rel:-18)
; node # 42 D(-38,-18)->(-28,-18)
       fcb 2 ; drawmode 
       fcb 31,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:182|rel:0) dy(abs:0|rel:0)
; node # 43 D(-47,-19)->(-39,-20)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:146|rel:-36) dy(abs:18|rel:18)
; node # 44 M(-72,-53)->(-54,-55)
       fcb 0 ; drawmode 
       fcb 34,-25 ; starx/y relative to previous node
       fdb 18,183 ; dx/dy. dx(abs:329|rel:183) dy(abs:36|rel:18)
; node # 45 D(-82,-54)->(-66,-56)
       fcb 2 ; drawmode 
       fcb 1,-10 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:292|rel:-37) dy(abs:36|rel:0)
; node # 46 M(-95,-56)->(-75,-59)
       fcb 0 ; drawmode 
       fcb 2,-13 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:365|rel:73) dy(abs:54|rel:18)
; node # 47 D(-72,-53)->(-54,-55)
       fcb 2 ; drawmode 
       fcb -3,23 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:329|rel:-36) dy(abs:36|rel:-18)
; node # 48 D(-38,-18)->(-28,-18)
       fcb 2 ; drawmode 
       fcb -35,34 ; starx/y relative to previous node
       fdb -36,-147 ; dx/dy. dx(abs:182|rel:-147) dy(abs:0|rel:-36)
; node # 49 M(-31,-59)->(-21,-60)
       fcb 0 ; drawmode 
       fcb 41,7 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:182|rel:0) dy(abs:18|rel:18)
; node # 50 D(-45,-58)->(-44,-60)
       fcb 2 ; drawmode 
       fcb -1,-14 ; starx/y relative to previous node
       fdb 18,-164 ; dx/dy. dx(abs:18|rel:-164) dy(abs:36|rel:18)
; node # 51 D(-62,-19)->(-62,-20)
       fcb 2 ; drawmode 
       fcb -39,-17 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:18|rel:-18)
; node # 52 D(-40,-19)->(-46,-20)
       fcb 2 ; drawmode 
       fcb 0,22 ; starx/y relative to previous node
       fdb 0,-109 ; dx/dy. dx(abs:-109|rel:-109) dy(abs:18|rel:0)
; node # 53 D(-29,-54)->(-33,-54)
       fcb 2 ; drawmode 
       fcb 35,11 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:0|rel:-18)
; node # 54 D(-45,-58)->(-44,-60)
       fcb 2 ; drawmode 
       fcb 4,-16 ; starx/y relative to previous node
       fdb 36,91 ; dx/dy. dx(abs:18|rel:91) dy(abs:36|rel:36)
; node # 55 D(7,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb -2,52 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:-36)
; node # 56 D(7,-64)->(7,-64)
       fcb 2 ; drawmode 
       fcb 8,0 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:0)
; node # 57 D(1,-66)->(1,-67)
       fcb 2 ; drawmode 
       fcb 2,-6 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:18|rel:18)
; node # 58 D(9,-66)->(12,-66)
       fcb 2 ; drawmode 
       fcb 0,8 ; starx/y relative to previous node
       fdb -18,54 ; dx/dy. dx(abs:54|rel:54) dy(abs:0|rel:-18)
; node # 59 D(7,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb -10,-2 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:18|rel:-36) dy(abs:0|rel:0)
; node # 60 D(-29,-54)->(-33,-54)
       fcb 2 ; drawmode 
       fcb -2,-36 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:-73|rel:-91) dy(abs:0|rel:0)
; node # 61 D(2,-48)->(-4,-48)
       fcb 2 ; drawmode 
       fcb -6,31 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:0|rel:0)
; node # 62 D(7,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb 8,5 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:18|rel:127) dy(abs:0|rel:0)
; node # 63 D(57,-44)->(54,-42)
       fcb 2 ; drawmode 
       fcb -12,50 ; starx/y relative to previous node
       fdb -36,-72 ; dx/dy. dx(abs:-54|rel:-72) dy(abs:-36|rel:-36)
; node # 64 D(35,-44)->(28,-44)
       fcb 2 ; drawmode 
       fcb 0,-22 ; starx/y relative to previous node
       fdb 36,-74 ; dx/dy. dx(abs:-128|rel:-74) dy(abs:0|rel:36)
; node # 65 D(35,-9)->(27,-9)
       fcb 2 ; drawmode 
       fcb -35,0 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 66 D(-3,-15)->(-11,-15)
       fcb 2 ; drawmode 
       fcb 6,-38 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 67 D(-5,2)->(-15,2)
       fcb 2 ; drawmode 
       fcb -17,-2 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-182|rel:-36) dy(abs:0|rel:0)
; node # 68 D(34,9)->(25,9)
       fcb 2 ; drawmode 
       fcb -7,39 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-164|rel:18) dy(abs:0|rel:0)
; node # 69 D(23,29)->(15,28)
       fcb 2 ; drawmode 
       fcb -20,-11 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:18|rel:18)
; node # 70 D(-7,23)->(-15,23)
       fcb 2 ; drawmode 
       fcb 6,-30 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:-18)
; node # 71 D(-5,2)->(-15,2)
       fcb 2 ; drawmode 
       fcb 21,2 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-182|rel:-36) dy(abs:0|rel:0)
; node # 72 D(-44,0)->(-51,0)
       fcb 2 ; drawmode 
       fcb 2,-39 ; starx/y relative to previous node
       fdb 0,54 ; dx/dy. dx(abs:-128|rel:54) dy(abs:0|rel:0)
; node # 73 D(-36,21)->(-42,22)
       fcb 2 ; drawmode 
       fcb -21,8 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:-18|rel:-18)
; node # 74 D(-52,27)->(-53,28)
       fcb 2 ; drawmode 
       fcb -6,-16 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:-18|rel:91) dy(abs:-18|rel:0)
; node # 75 M(23,29)->(15,28)
       fcb 0 ; drawmode 
       fcb -2,75 ; starx/y relative to previous node
       fdb 36,-128 ; dx/dy. dx(abs:-146|rel:-128) dy(abs:18|rel:36)
; node # 76 D(42,38)->(39,37)
       fcb 2 ; drawmode 
       fcb -9,19 ; starx/y relative to previous node
       fdb 0,92 ; dx/dy. dx(abs:-54|rel:92) dy(abs:18|rel:0)
; node # 77 M(-36,21)->(-42,22)
       fcb 0 ; drawmode 
       fcb 17,-78 ; starx/y relative to previous node
       fdb -36,-55 ; dx/dy. dx(abs:-109|rel:-55) dy(abs:-18|rel:-36)
; node # 78 D(-7,23)->(-15,23)
       fcb 2 ; drawmode 
       fcb -2,29 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:18)
; node # 79 M(-44,0)->(-51,0)
       fcb 0 ; drawmode 
       fcb 23,-37 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 80 D(-40,-19)->(-46,-20)
       fcb 2 ; drawmode 
       fcb 19,4 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:18|rel:18)
; node # 81 D(-3,-15)->(-11,-15)
       fcb 2 ; drawmode 
       fcb -4,37 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:-18)
; node # 82 D(2,-48)->(-4,-48)
       fcb 2 ; drawmode 
       fcb 33,5 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:0)
; node # 83 D(35,-44)->(28,-44)
       fcb 2 ; drawmode 
       fcb -4,33 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:0)
; node # 84 D(7,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb 12,-28 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:18|rel:146) dy(abs:0|rel:0)
; node # 85 M(7,-64)->(7,-64)
       fcb 0 ; drawmode 
       fcb 8,0 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:0)
; node # 86 D(16,-64)->(17,-63)
       fcb 2 ; drawmode 
       fcb 0,9 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:-18|rel:-18)
; node # 87 D(9,-66)->(12,-66)
       fcb 2 ; drawmode 
       fcb 2,-7 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:54|rel:36) dy(abs:0|rel:18)
; node # 88 M(1,-66)->(1,-67)
       fcb 0 ; drawmode 
       fcb 0,-8 ; starx/y relative to previous node
       fdb 18,-54 ; dx/dy. dx(abs:0|rel:-54) dy(abs:18|rel:18)
; node # 89 D(7,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb -10,6 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:0|rel:-18)
; node # 90 D(-31,-59)->(-21,-60)
       fcb 2 ; drawmode 
       fcb 3,-38 ; starx/y relative to previous node
       fdb 18,164 ; dx/dy. dx(abs:182|rel:164) dy(abs:18|rel:18)
; node # 91 M(16,-64)->(17,-63)
       fcb 0 ; drawmode 
       fcb 5,47 ; starx/y relative to previous node
       fdb -36,-164 ; dx/dy. dx(abs:18|rel:-164) dy(abs:-18|rel:-36)
; node # 92 D(7,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb -8,-9 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:18)
; node # 93 M(30,-30)->(23,-29)
       fcb 0 ; drawmode 
       fcb -26,23 ; starx/y relative to previous node
       fdb -18,-146 ; dx/dy. dx(abs:-128|rel:-146) dy(abs:-18|rel:-18)
; node # 94 D(54,-26)->(43,-26)
       fcb 2 ; drawmode 
       fcb -4,24 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-201|rel:-73) dy(abs:0|rel:18)
; node # 95 D(52,-13)->(41,-12)
       fcb 2 ; drawmode 
       fcb -13,-2 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:-18|rel:-18)
; node # 96 D(37,3)->(29,3)
       fcb 2 ; drawmode 
       fcb -16,-15 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-146|rel:55) dy(abs:0|rel:18)
; node # 97 D(29,1)->(21,1)
       fcb 2 ; drawmode 
       fcb 2,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 98 D(44,-14)->(32,-14)
       fcb 2 ; drawmode 
       fcb 15,15 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:0|rel:0)
; node # 99 D(46,-27)->(35,-27)
       fcb 2 ; drawmode 
       fcb 13,2 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:0|rel:0)
; node # 100 D(38,-29)->(31,-28)
       fcb 2 ; drawmode 
       fcb 2,-8 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-128|rel:73) dy(abs:-18|rel:-18)
; node # 101 D(30,-30)->(23,-29)
       fcb 2 ; drawmode 
       fcb 1,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:-18|rel:0)
; node # 102 D(35,-34)->(28,-34)
       fcb 2 ; drawmode 
       fcb 4,5 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:18)
; node # 103 D(53,-31)->(41,-30)
       fcb 2 ; drawmode 
       fcb -3,18 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:-219|rel:-91) dy(abs:-18|rel:-18)
; node # 104 D(50,-9)->(37,-9)
       fcb 2 ; drawmode 
       fcb -22,-3 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-237|rel:-18) dy(abs:0|rel:18)
; node # 105 D(34,9)->(25,9)
       fcb 2 ; drawmode 
       fcb -18,-16 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-164|rel:73) dy(abs:0|rel:0)
; node # 106 D(29,1)->(21,1)
       fcb 2 ; drawmode 
       fcb 8,-5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 107 M(-44,0)->(-51,0)
       fcb 0 ; drawmode 
       fcb 1,-73 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 108 D(-68,3)->(-69,3)
       fcb 2 ; drawmode 
       fcb -3,-24 ; starx/y relative to previous node
       fdb 0,110 ; dx/dy. dx(abs:-18|rel:110) dy(abs:0|rel:0)
; node # 109 M(28,-1)->(21,1)
       fcb 0 ; drawmode 
       fcb 4,96 ; starx/y relative to previous node
       fdb -36,-110 ; dx/dy. dx(abs:-128|rel:-110) dy(abs:-36|rel:-36)
; node # 110 M(46,-27)->(35,-27)
       fcb 0 ; drawmode 
       fcb 26,18 ; starx/y relative to previous node
       fdb 36,-73 ; dx/dy. dx(abs:-201|rel:-73) dy(abs:0|rel:36)
; node # 111 D(53,-31)->(41,-30)
       fcb 2 ; drawmode 
       fcb 4,7 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:-18|rel:-18)
; node # 112 M(34,9)->(25,9)
       fcb 0 ; drawmode 
       fcb -40,-19 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-164|rel:55) dy(abs:0|rel:18)
; node # 113 D(37,3)->(29,3)
       fcb 2 ; drawmode 
       fcb 6,3 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 114 M(52,-13)->(41,-12)
       fcb 0 ; drawmode 
       fcb 16,15 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-201|rel:-55) dy(abs:-18|rel:-18)
; node # 115 D(50,-9)->(37,-9)
       fcb 2 ; drawmode 
       fcb -4,-2 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-237|rel:-36) dy(abs:0|rel:18)
; node # 116 D(44,-14)->(32,-14)
       fcb 2 ; drawmode 
       fcb 5,-6 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-219|rel:18) dy(abs:0|rel:0)
; node # 117 D(52,-13)->(41,-12)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:-18|rel:-18)
; node # 118 M(46,-27)->(35,-27)
       fcb 0 ; drawmode 
       fcb 14,-6 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:0|rel:18)
; node # 119 D(54,-26)->(43,-26)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:0|rel:0)
; node # 120 M(54,-26)->(43,-26)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:0|rel:0)
; node # 121 D(53,-31)->(41,-30)
       fcb 2 ; drawmode 
       fcb 5,-1 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:-18|rel:-18)
; node # 122 M(38,-29)->(31,-28)
       fcb 0 ; drawmode 
       fcb -2,-15 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:-128|rel:91) dy(abs:-18|rel:0)
; node # 123 D(35,-34)->(28,-34)
       fcb 2 ; drawmode 
       fcb 5,-3 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:18)
       fcb  1  ; end of anim
; Animation 11
teapotBframe11:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-69,3)->(-67,3)
       fcb 0 ; drawmode 
       fcb -3,-69 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:36|rel:36) dy(abs:0|rel:0)
; node # 1 D(-42,13)->(-30,14)
       fcb 2 ; drawmode 
       fcb -10,27 ; starx/y relative to previous node
       fdb -18,183 ; dx/dy. dx(abs:219|rel:183) dy(abs:-18|rel:-18)
; node # 2 D(-33,38)->(-26,39)
       fcb 2 ; drawmode 
       fcb -25,9 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:128|rel:-91) dy(abs:-18|rel:0)
; node # 3 D(-53,28)->(-52,29)
       fcb 2 ; drawmode 
       fcb 10,-20 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:18|rel:-110) dy(abs:-18|rel:0)
; node # 4 D(-69,3)->(-67,3)
       fcb 2 ; drawmode 
       fcb 25,-16 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:36|rel:18) dy(abs:0|rel:18)
; node # 5 D(-62,-20)->(-60,-21)
       fcb 2 ; drawmode 
       fcb 23,7 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:18|rel:18)
; node # 6 D(-36,-14)->(-24,-14)
       fcb 2 ; drawmode 
       fcb -6,26 ; starx/y relative to previous node
       fdb -18,183 ; dx/dy. dx(abs:219|rel:183) dy(abs:0|rel:-18)
; node # 7 D(-21,-60)->(-10,-61)
       fcb 2 ; drawmode 
       fcb 46,15 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:18|rel:18)
; node # 8 D(25,-54)->(35,-53)
       fcb 2 ; drawmode 
       fcb -6,46 ; starx/y relative to previous node
       fdb -36,-19 ; dx/dy. dx(abs:182|rel:-19) dy(abs:-18|rel:-36)
; node # 9 D(56,-46)->(59,-45)
       fcb 2 ; drawmode 
       fcb -8,31 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:54|rel:-128) dy(abs:-18|rel:0)
; node # 10 D(61,0)->(63,0)
       fcb 2 ; drawmode 
       fcb -46,5 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:36|rel:-18) dy(abs:0|rel:18)
; node # 11 D(59,25)->(62,24)
       fcb 2 ; drawmode 
       fcb -25,-2 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:18|rel:18)
; node # 12 D(38,44)->(40,43)
       fcb 2 ; drawmode 
       fcb -19,-21 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:36|rel:-18) dy(abs:18|rel:0)
; node # 13 D(39,37)->(35,36)
       fcb 2 ; drawmode 
       fcb 7,1 ; starx/y relative to previous node
       fdb 0,-109 ; dx/dy. dx(abs:-73|rel:-109) dy(abs:18|rel:0)
; node # 14 D(57,18)->(51,17)
       fcb 2 ; drawmode 
       fcb 19,18 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:18|rel:0)
; node # 15 D(58,-3)->(53,-3)
       fcb 2 ; drawmode 
       fcb 21,1 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:0|rel:-18)
; node # 16 D(61,0)->(63,0)
       fcb 2 ; drawmode 
       fcb -3,3 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:36|rel:127) dy(abs:0|rel:0)
; node # 17 D(22,-4)->(34,-4)
       fcb 2 ; drawmode 
       fcb 4,-39 ; starx/y relative to previous node
       fdb 0,183 ; dx/dy. dx(abs:219|rel:183) dy(abs:0|rel:0)
; node # 18 D(25,-54)->(35,-53)
       fcb 2 ; drawmode 
       fcb 50,3 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:182|rel:-37) dy(abs:-18|rel:-18)
; node # 19 D(8,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb 2,-17 ; starx/y relative to previous node
       fdb 18,-182 ; dx/dy. dx(abs:0|rel:-182) dy(abs:0|rel:18)
; node # 20 D(56,-46)->(59,-45)
       fcb 2 ; drawmode 
       fcb -10,48 ; starx/y relative to previous node
       fdb -18,54 ; dx/dy. dx(abs:54|rel:54) dy(abs:-18|rel:-18)
; node # 21 D(54,-42)->(50,-41)
       fcb 2 ; drawmode 
       fcb -4,-2 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-73|rel:-127) dy(abs:-18|rel:0)
; node # 22 D(58,-3)->(53,-3)
       fcb 2 ; drawmode 
       fcb -39,4 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-91|rel:-18) dy(abs:0|rel:18)
; node # 23 D(27,-9)->(18,-10)
       fcb 2 ; drawmode 
       fcb 6,-31 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-164|rel:-73) dy(abs:18|rel:18)
; node # 24 D(25,9)->(16,9)
       fcb 2 ; drawmode 
       fcb -18,-2 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:-18)
; node # 25 D(57,18)->(51,17)
       fcb 2 ; drawmode 
       fcb -9,32 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:18|rel:18)
; node # 26 D(59,25)->(62,24)
       fcb 2 ; drawmode 
       fcb -7,2 ; starx/y relative to previous node
       fdb 0,163 ; dx/dy. dx(abs:54|rel:163) dy(abs:18|rel:0)
; node # 27 D(19,24)->(31,24)
       fcb 2 ; drawmode 
       fcb 1,-40 ; starx/y relative to previous node
       fdb -18,165 ; dx/dy. dx(abs:219|rel:165) dy(abs:0|rel:-18)
; node # 28 D(22,-4)->(34,-4)
       fcb 2 ; drawmode 
       fcb 28,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:219|rel:0) dy(abs:0|rel:0)
; node # 29 D(-36,-14)->(-24,-14)
       fcb 2 ; drawmode 
       fcb 10,-58 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:219|rel:0) dy(abs:0|rel:0)
; node # 30 D(-42,13)->(-30,14)
       fcb 2 ; drawmode 
       fcb -27,-6 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:219|rel:0) dy(abs:-18|rel:-18)
; node # 31 D(19,24)->(31,24)
       fcb 2 ; drawmode 
       fcb -11,61 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:219|rel:0) dy(abs:0|rel:18)
; node # 32 D(8,46)->(17,46)
       fcb 2 ; drawmode 
       fcb -22,-11 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:164|rel:-55) dy(abs:0|rel:0)
; node # 33 D(-33,38)->(-26,39)
       fcb 2 ; drawmode 
       fcb 8,-41 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:128|rel:-36) dy(abs:-18|rel:-18)
; node # 34 M(38,44)->(40,43)
       fcb 0 ; drawmode 
       fcb -6,71 ; starx/y relative to previous node
       fdb 36,-92 ; dx/dy. dx(abs:36|rel:-92) dy(abs:18|rel:36)
; node # 35 D(8,46)->(17,46)
       fcb 2 ; drawmode 
       fcb -2,-30 ; starx/y relative to previous node
       fdb -18,128 ; dx/dy. dx(abs:164|rel:128) dy(abs:0|rel:-18)
; node # 36 M(-42,13)->(-30,14)
       fcb 0 ; drawmode 
       fcb 33,-50 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:219|rel:55) dy(abs:-18|rel:-18)
; node # 37 D(-55,-29)->(-37,-32)
       fcb 2 ; drawmode 
       fcb 42,-13 ; starx/y relative to previous node
       fdb 72,110 ; dx/dy. dx(abs:329|rel:110) dy(abs:54|rel:72)
; node # 38 D(-75,-59)->(-50,-62)
       fcb 2 ; drawmode 
       fcb 30,-20 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:457|rel:128) dy(abs:54|rel:0)
; node # 39 D(-66,-56)->(-46,-58)
       fcb 2 ; drawmode 
       fcb -3,9 ; starx/y relative to previous node
       fdb -18,-92 ; dx/dy. dx(abs:365|rel:-92) dy(abs:36|rel:-18)
; node # 40 D(-39,-20)->(-28,-20)
       fcb 2 ; drawmode 
       fcb -36,27 ; starx/y relative to previous node
       fdb -36,-164 ; dx/dy. dx(abs:201|rel:-164) dy(abs:0|rel:-36)
; node # 41 D(-42,13)->(-30,14)
       fcb 2 ; drawmode 
       fcb -33,-3 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:219|rel:18) dy(abs:-18|rel:-18)
; node # 42 D(-28,-18)->(-16,-18)
       fcb 2 ; drawmode 
       fcb 31,14 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:219|rel:0) dy(abs:0|rel:18)
; node # 43 D(-39,-20)->(-28,-20)
       fcb 2 ; drawmode 
       fcb 2,-11 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:0|rel:0)
; node # 44 M(-54,-55)->(-32,-57)
       fcb 0 ; drawmode 
       fcb 35,-15 ; starx/y relative to previous node
       fdb 36,201 ; dx/dy. dx(abs:402|rel:201) dy(abs:36|rel:36)
; node # 45 D(-66,-56)->(-46,-58)
       fcb 2 ; drawmode 
       fcb 1,-12 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:365|rel:-37) dy(abs:36|rel:0)
; node # 46 M(-75,-59)->(-50,-62)
       fcb 0 ; drawmode 
       fcb 3,-9 ; starx/y relative to previous node
       fdb 18,92 ; dx/dy. dx(abs:457|rel:92) dy(abs:54|rel:18)
; node # 47 D(-54,-55)->(-32,-57)
       fcb 2 ; drawmode 
       fcb -4,21 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:402|rel:-55) dy(abs:36|rel:-18)
; node # 48 D(-28,-18)->(-16,-18)
       fcb 2 ; drawmode 
       fcb -37,26 ; starx/y relative to previous node
       fdb -36,-183 ; dx/dy. dx(abs:219|rel:-183) dy(abs:0|rel:-36)
; node # 49 M(-21,-60)->(-10,-61)
       fcb 0 ; drawmode 
       fcb 42,7 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:18|rel:18)
; node # 50 D(-44,-60)->(-41,-61)
       fcb 2 ; drawmode 
       fcb 0,-23 ; starx/y relative to previous node
       fdb 0,-147 ; dx/dy. dx(abs:54|rel:-147) dy(abs:18|rel:0)
; node # 51 D(-62,-20)->(-60,-21)
       fcb 2 ; drawmode 
       fcb -40,-18 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:36|rel:-18) dy(abs:18|rel:0)
; node # 52 D(-46,-20)->(-52,-20)
       fcb 2 ; drawmode 
       fcb 0,16 ; starx/y relative to previous node
       fdb -18,-145 ; dx/dy. dx(abs:-109|rel:-145) dy(abs:0|rel:-18)
; node # 53 D(-33,-54)->(-37,-56)
       fcb 2 ; drawmode 
       fcb 34,13 ; starx/y relative to previous node
       fdb 36,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:36|rel:36)
; node # 54 D(-44,-60)->(-41,-61)
       fcb 2 ; drawmode 
       fcb 6,-11 ; starx/y relative to previous node
       fdb -18,127 ; dx/dy. dx(abs:54|rel:127) dy(abs:18|rel:-18)
; node # 55 D(8,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb -4,52 ; starx/y relative to previous node
       fdb -18,-54 ; dx/dy. dx(abs:0|rel:-54) dy(abs:0|rel:-18)
; node # 56 D(7,-64)->(7,-64)
       fcb 2 ; drawmode 
       fcb 8,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 57 D(1,-67)->(3,-67)
       fcb 2 ; drawmode 
       fcb 3,-6 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:36|rel:36) dy(abs:0|rel:0)
; node # 58 D(12,-66)->(14,-65)
       fcb 2 ; drawmode 
       fcb -1,11 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:-18|rel:-18)
; node # 59 D(8,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb -10,-4 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:0|rel:-36) dy(abs:0|rel:18)
; node # 60 D(-33,-54)->(-37,-56)
       fcb 2 ; drawmode 
       fcb -2,-41 ; starx/y relative to previous node
       fdb 36,-73 ; dx/dy. dx(abs:-73|rel:-73) dy(abs:36|rel:36)
; node # 61 D(-4,-48)->(-11,-48)
       fcb 2 ; drawmode 
       fcb -6,29 ; starx/y relative to previous node
       fdb -36,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:0|rel:-36)
; node # 62 D(8,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb 8,12 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:0)
; node # 63 D(54,-42)->(50,-41)
       fcb 2 ; drawmode 
       fcb -14,46 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-73|rel:-73) dy(abs:-18|rel:-18)
; node # 64 D(28,-44)->(21,-43)
       fcb 2 ; drawmode 
       fcb 2,-26 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:-18|rel:0)
; node # 65 D(27,-9)->(18,-10)
       fcb 2 ; drawmode 
       fcb -35,-1 ; starx/y relative to previous node
       fdb 36,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:18|rel:36)
; node # 66 D(-11,-15)->(-20,-16)
       fcb 2 ; drawmode 
       fcb 6,-38 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:18|rel:0)
; node # 67 D(-15,2)->(-24,2)
       fcb 2 ; drawmode 
       fcb -17,-4 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:-18)
; node # 68 D(25,9)->(16,9)
       fcb 2 ; drawmode 
       fcb -7,40 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 69 D(15,28)->(9,28)
       fcb 2 ; drawmode 
       fcb -19,-10 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:0|rel:0)
; node # 70 D(-15,23)->(-22,23)
       fcb 2 ; drawmode 
       fcb 5,-30 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:0)
; node # 71 D(-15,2)->(-24,2)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 72 D(-51,0)->(-57,0)
       fcb 2 ; drawmode 
       fcb 2,-36 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:0|rel:0)
; node # 73 D(-42,22)->(-47,23)
       fcb 2 ; drawmode 
       fcb -22,9 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:-18|rel:-18)
; node # 74 D(-53,28)->(-52,29)
       fcb 2 ; drawmode 
       fcb -6,-11 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:18|rel:109) dy(abs:-18|rel:0)
; node # 75 M(15,28)->(9,28)
       fcb 0 ; drawmode 
       fcb 0,68 ; starx/y relative to previous node
       fdb 18,-127 ; dx/dy. dx(abs:-109|rel:-127) dy(abs:0|rel:18)
; node # 76 D(39,37)->(35,36)
       fcb 2 ; drawmode 
       fcb -9,24 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:18|rel:18)
; node # 77 M(-42,22)->(-47,23)
       fcb 0 ; drawmode 
       fcb 15,-81 ; starx/y relative to previous node
       fdb -36,-18 ; dx/dy. dx(abs:-91|rel:-18) dy(abs:-18|rel:-36)
; node # 78 D(-15,23)->(-22,23)
       fcb 2 ; drawmode 
       fcb -1,27 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:0|rel:18)
; node # 79 M(-51,0)->(-57,0)
       fcb 0 ; drawmode 
       fcb 23,-36 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:0|rel:0)
; node # 80 D(-46,-20)->(-52,-20)
       fcb 2 ; drawmode 
       fcb 20,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:0)
; node # 81 D(-11,-15)->(-20,-16)
       fcb 2 ; drawmode 
       fcb -5,35 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:18|rel:18)
; node # 82 D(-4,-48)->(-11,-48)
       fcb 2 ; drawmode 
       fcb 33,7 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:-18)
; node # 83 D(28,-44)->(21,-43)
       fcb 2 ; drawmode 
       fcb -4,32 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:-18|rel:-18)
; node # 84 D(8,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb 12,-20 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:18)
; node # 85 M(7,-64)->(7,-64)
       fcb 0 ; drawmode 
       fcb 8,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 86 D(17,-63)->(17,-63)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 87 D(12,-66)->(14,-65)
       fcb 2 ; drawmode 
       fcb 3,-5 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:36|rel:36) dy(abs:-18|rel:-18)
; node # 88 M(1,-67)->(3,-67)
       fcb 0 ; drawmode 
       fcb 1,-11 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:0|rel:18)
; node # 89 D(8,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb -11,7 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:0|rel:-36) dy(abs:0|rel:0)
; node # 90 D(-21,-60)->(-10,-61)
       fcb 2 ; drawmode 
       fcb 4,-29 ; starx/y relative to previous node
       fdb 18,201 ; dx/dy. dx(abs:201|rel:201) dy(abs:18|rel:18)
; node # 91 M(17,-63)->(17,-63)
       fcb 0 ; drawmode 
       fcb 3,38 ; starx/y relative to previous node
       fdb -18,-201 ; dx/dy. dx(abs:0|rel:-201) dy(abs:0|rel:-18)
; node # 92 D(8,-56)->(8,-56)
       fcb 2 ; drawmode 
       fcb -7,-9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 93 M(31,-28)->(24,-28)
       fcb 0 ; drawmode 
       fcb -28,23 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:0|rel:0)
; node # 94 D(43,-26)->(32,-25)
       fcb 2 ; drawmode 
       fcb -2,12 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-201|rel:-73) dy(abs:-18|rel:-18)
; node # 95 D(41,-12)->(29,-12)
       fcb 2 ; drawmode 
       fcb -14,-2 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:0|rel:18)
; node # 96 D(29,3)->(21,2)
       fcb 2 ; drawmode 
       fcb -15,-12 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-146|rel:73) dy(abs:18|rel:18)
; node # 97 D(21,1)->(12,1)
       fcb 2 ; drawmode 
       fcb 2,-8 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:-18)
; node # 98 D(32,-14)->(21,-13)
       fcb 2 ; drawmode 
       fcb 15,11 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:-201|rel:-37) dy(abs:-18|rel:-18)
; node # 99 D(35,-27)->(23,-26)
       fcb 2 ; drawmode 
       fcb 13,3 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:-18|rel:0)
; node # 100 D(23,-29)->(16,-29)
       fcb 2 ; drawmode 
       fcb 2,-12 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:-128|rel:91) dy(abs:0|rel:18)
; node # 101 D(31,-28)->(24,-28)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:0)
; node # 102 D(28,-34)->(20,-33)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:-18|rel:-18)
; node # 103 D(41,-30)->(29,-29)
       fcb 2 ; drawmode 
       fcb -4,13 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:-18|rel:0)
; node # 104 D(37,-9)->(26,-8)
       fcb 2 ; drawmode 
       fcb -21,-4 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:-18|rel:0)
; node # 105 D(25,9)->(16,9)
       fcb 2 ; drawmode 
       fcb -18,-12 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-164|rel:37) dy(abs:0|rel:18)
; node # 106 D(21,1)->(12,1)
       fcb 2 ; drawmode 
       fcb 8,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 107 M(-51,0)->(-57,0)
       fcb 0 ; drawmode 
       fcb 1,-72 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:0|rel:0)
; node # 108 D(-69,3)->(-67,3)
       fcb 2 ; drawmode 
       fcb -3,-18 ; starx/y relative to previous node
       fdb 0,145 ; dx/dy. dx(abs:36|rel:145) dy(abs:0|rel:0)
; node # 109 M(21,1)->(12,1)
       fcb 0 ; drawmode 
       fcb 2,90 ; starx/y relative to previous node
       fdb 0,-200 ; dx/dy. dx(abs:-164|rel:-200) dy(abs:0|rel:0)
; node # 110 M(35,-27)->(23,-26)
       fcb 0 ; drawmode 
       fcb 28,14 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-219|rel:-55) dy(abs:-18|rel:-18)
; node # 111 D(41,-30)->(29,-29)
       fcb 2 ; drawmode 
       fcb 3,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:-18|rel:0)
; node # 112 M(25,9)->(16,9)
       fcb 0 ; drawmode 
       fcb -39,-16 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-164|rel:55) dy(abs:0|rel:18)
; node # 113 D(29,3)->(21,2)
       fcb 2 ; drawmode 
       fcb 6,4 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:18|rel:18)
; node # 114 M(41,-12)->(29,-12)
       fcb 0 ; drawmode 
       fcb 15,12 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:0|rel:-18)
; node # 115 D(37,-9)->(26,-8)
       fcb 2 ; drawmode 
       fcb -3,-4 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:-18|rel:-18)
; node # 116 D(32,-14)->(21,-13)
       fcb 2 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:-18|rel:0)
; node # 117 D(41,-12)->(29,-12)
       fcb 2 ; drawmode 
       fcb -2,9 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:0|rel:18)
; node # 118 M(35,-27)->(23,-26)
       fcb 0 ; drawmode 
       fcb 15,-6 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:-18|rel:-18)
; node # 119 D(43,-26)->(32,-25)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:-18|rel:0)
; node # 120 M(43,-26)->(32,-25)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:-18|rel:0)
; node # 121 D(41,-30)->(29,-29)
       fcb 2 ; drawmode 
       fcb 4,-2 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:-18|rel:0)
; node # 122 M(23,-29)->(16,-29)
       fcb 0 ; drawmode 
       fcb -1,-18 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:-128|rel:91) dy(abs:0|rel:18)
; node # 123 D(28,-34)->(20,-33)
       fcb 2 ; drawmode 
       fcb 5,5 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:-18|rel:-18)
       fcb  1  ; end of anim
; Animation 12
teapotBframe12:
       fcb 15 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-67,3)->(-64,3)
       fcb 0 ; drawmode 
       fcb -3,-67 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:51|rel:51) dy(abs:0|rel:0)
; node # 1 D(-30,14)->(-17,14)
       fcb 2 ; drawmode 
       fcb -11,37 ; starx/y relative to previous node
       fdb 0,170 ; dx/dy. dx(abs:221|rel:170) dy(abs:0|rel:0)
; node # 2 D(-26,39)->(-17,39)
       fcb 2 ; drawmode 
       fcb -25,4 ; starx/y relative to previous node
       fdb 0,-68 ; dx/dy. dx(abs:153|rel:-68) dy(abs:0|rel:0)
; node # 3 D(-52,29)->(-50,30)
       fcb 2 ; drawmode 
       fcb 10,-26 ; starx/y relative to previous node
       fdb -17,-119 ; dx/dy. dx(abs:34|rel:-119) dy(abs:-17|rel:-17)
; node # 4 D(-67,3)->(-64,3)
       fcb 2 ; drawmode 
       fcb 26,-15 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:51|rel:17) dy(abs:0|rel:17)
; node # 5 D(-60,-21)->(-56,-21)
       fcb 2 ; drawmode 
       fcb 24,7 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:68|rel:17) dy(abs:0|rel:0)
; node # 6 D(-24,-14)->(-11,-13)
       fcb 2 ; drawmode 
       fcb -7,36 ; starx/y relative to previous node
       fdb -17,153 ; dx/dy. dx(abs:221|rel:153) dy(abs:-17|rel:-17)
; node # 7 D(-10,-61)->(0,-61)
       fcb 2 ; drawmode 
       fcb 47,14 ; starx/y relative to previous node
       fdb 17,-51 ; dx/dy. dx(abs:170|rel:-51) dy(abs:0|rel:17)
; node # 8 D(35,-53)->(44,-51)
       fcb 2 ; drawmode 
       fcb -8,45 ; starx/y relative to previous node
       fdb -34,-17 ; dx/dy. dx(abs:153|rel:-17) dy(abs:-34|rel:-34)
; node # 9 D(59,-45)->(59,-42)
       fcb 2 ; drawmode 
       fcb -8,24 ; starx/y relative to previous node
       fdb -17,-153 ; dx/dy. dx(abs:0|rel:-153) dy(abs:-51|rel:-17)
; node # 10 D(63,0)->(64,0)
       fcb 2 ; drawmode 
       fcb -45,4 ; starx/y relative to previous node
       fdb 51,17 ; dx/dy. dx(abs:17|rel:17) dy(abs:0|rel:51)
; node # 11 D(62,24)->(63,23)
       fcb 2 ; drawmode 
       fcb -24,-1 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:17|rel:0) dy(abs:17|rel:17)
; node # 12 D(40,43)->(41,42)
       fcb 2 ; drawmode 
       fcb -19,-22 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:17|rel:0) dy(abs:17|rel:0)
; node # 13 D(35,36)->(29,35)
       fcb 2 ; drawmode 
       fcb 7,-5 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:-102|rel:-119) dy(abs:17|rel:0)
; node # 14 D(51,17)->(45,17)
       fcb 2 ; drawmode 
       fcb 19,16 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-102|rel:0) dy(abs:0|rel:-17)
; node # 15 D(53,-3)->(45,-4)
       fcb 2 ; drawmode 
       fcb 20,2 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:-136|rel:-34) dy(abs:17|rel:17)
; node # 16 D(63,0)->(64,0)
       fcb 2 ; drawmode 
       fcb -3,10 ; starx/y relative to previous node
       fdb -17,153 ; dx/dy. dx(abs:17|rel:153) dy(abs:0|rel:-17)
; node # 17 D(34,-4)->(46,-3)
       fcb 2 ; drawmode 
       fcb 4,-29 ; starx/y relative to previous node
       fdb -17,187 ; dx/dy. dx(abs:204|rel:187) dy(abs:-17|rel:-17)
; node # 18 D(35,-53)->(44,-51)
       fcb 2 ; drawmode 
       fcb 49,1 ; starx/y relative to previous node
       fdb -17,-51 ; dx/dy. dx(abs:153|rel:-51) dy(abs:-34|rel:-17)
; node # 19 D(8,-56)->(9,-55)
       fcb 2 ; drawmode 
       fcb 3,-27 ; starx/y relative to previous node
       fdb 17,-136 ; dx/dy. dx(abs:17|rel:-136) dy(abs:-17|rel:17)
; node # 20 D(59,-45)->(59,-42)
       fcb 2 ; drawmode 
       fcb -11,51 ; starx/y relative to previous node
       fdb -34,-17 ; dx/dy. dx(abs:0|rel:-17) dy(abs:-51|rel:-34)
; node # 21 D(50,-41)->(44,-40)
       fcb 2 ; drawmode 
       fcb -4,-9 ; starx/y relative to previous node
       fdb 34,-102 ; dx/dy. dx(abs:-102|rel:-102) dy(abs:-17|rel:34)
; node # 22 D(53,-3)->(45,-4)
       fcb 2 ; drawmode 
       fcb -38,3 ; starx/y relative to previous node
       fdb 34,-34 ; dx/dy. dx(abs:-136|rel:-34) dy(abs:17|rel:34)
; node # 23 D(18,-10)->(10,-11)
       fcb 2 ; drawmode 
       fcb 7,-35 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:17|rel:0)
; node # 24 D(16,9)->(7,9)
       fcb 2 ; drawmode 
       fcb -19,-2 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-153|rel:-17) dy(abs:0|rel:-17)
; node # 25 D(51,17)->(45,17)
       fcb 2 ; drawmode 
       fcb -8,35 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-102|rel:51) dy(abs:0|rel:0)
; node # 26 D(62,24)->(63,23)
       fcb 2 ; drawmode 
       fcb -7,11 ; starx/y relative to previous node
       fdb 17,119 ; dx/dy. dx(abs:17|rel:119) dy(abs:17|rel:17)
; node # 27 D(31,24)->(43,23)
       fcb 2 ; drawmode 
       fcb 0,-31 ; starx/y relative to previous node
       fdb 0,187 ; dx/dy. dx(abs:204|rel:187) dy(abs:17|rel:0)
; node # 28 D(34,-4)->(46,-3)
       fcb 2 ; drawmode 
       fcb 28,3 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:204|rel:0) dy(abs:-17|rel:-34)
; node # 29 D(-24,-14)->(-11,-13)
       fcb 2 ; drawmode 
       fcb 10,-58 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:221|rel:17) dy(abs:-17|rel:0)
; node # 30 D(-30,14)->(-17,14)
       fcb 2 ; drawmode 
       fcb -28,-6 ; starx/y relative to previous node
       fdb 17,0 ; dx/dy. dx(abs:221|rel:0) dy(abs:0|rel:17)
; node # 31 D(31,24)->(43,23)
       fcb 2 ; drawmode 
       fcb -10,61 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:204|rel:-17) dy(abs:17|rel:17)
; node # 32 D(17,46)->(25,45)
       fcb 2 ; drawmode 
       fcb -22,-14 ; starx/y relative to previous node
       fdb 0,-68 ; dx/dy. dx(abs:136|rel:-68) dy(abs:17|rel:0)
; node # 33 D(-26,39)->(-17,39)
       fcb 2 ; drawmode 
       fcb 7,-43 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:153|rel:17) dy(abs:0|rel:-17)
; node # 34 M(40,43)->(41,42)
       fcb 0 ; drawmode 
       fcb -4,66 ; starx/y relative to previous node
       fdb 17,-136 ; dx/dy. dx(abs:17|rel:-136) dy(abs:17|rel:17)
; node # 35 D(17,46)->(25,45)
       fcb 2 ; drawmode 
       fcb -3,-23 ; starx/y relative to previous node
       fdb 0,119 ; dx/dy. dx(abs:136|rel:119) dy(abs:17|rel:0)
; node # 36 M(-30,14)->(-17,14)
       fcb 0 ; drawmode 
       fcb 32,-47 ; starx/y relative to previous node
       fdb -17,85 ; dx/dy. dx(abs:221|rel:85) dy(abs:0|rel:-17)
; node # 37 D(-37,-32)->(-17,-33)
       fcb 2 ; drawmode 
       fcb 46,-7 ; starx/y relative to previous node
       fdb 17,120 ; dx/dy. dx(abs:341|rel:120) dy(abs:17|rel:17)
; node # 38 D(-50,-62)->(-20,-63)
       fcb 2 ; drawmode 
       fcb 30,-13 ; starx/y relative to previous node
       fdb 0,171 ; dx/dy. dx(abs:512|rel:171) dy(abs:17|rel:0)
; node # 39 D(-46,-58)->(-23,-60)
       fcb 2 ; drawmode 
       fcb -4,4 ; starx/y relative to previous node
       fdb 17,-120 ; dx/dy. dx(abs:392|rel:-120) dy(abs:34|rel:17)
; node # 40 D(-28,-20)->(-16,-21)
       fcb 2 ; drawmode 
       fcb -38,18 ; starx/y relative to previous node
       fdb -17,-188 ; dx/dy. dx(abs:204|rel:-188) dy(abs:17|rel:-17)
; node # 41 D(-30,14)->(-17,14)
       fcb 2 ; drawmode 
       fcb -34,-2 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:221|rel:17) dy(abs:0|rel:-17)
; node # 42 D(-16,-18)->(-3,-18)
       fcb 2 ; drawmode 
       fcb 32,14 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:221|rel:0) dy(abs:0|rel:0)
; node # 43 D(-28,-20)->(-16,-21)
       fcb 2 ; drawmode 
       fcb 2,-12 ; starx/y relative to previous node
       fdb 17,-17 ; dx/dy. dx(abs:204|rel:-17) dy(abs:17|rel:17)
; node # 44 M(-32,-57)->(-7,-58)
       fcb 0 ; drawmode 
       fcb 37,-4 ; starx/y relative to previous node
       fdb 0,222 ; dx/dy. dx(abs:426|rel:222) dy(abs:17|rel:0)
; node # 45 D(-46,-58)->(-23,-60)
       fcb 2 ; drawmode 
       fcb 1,-14 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:392|rel:-34) dy(abs:34|rel:17)
; node # 46 M(-50,-62)->(-20,-63)
       fcb 0 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb -17,120 ; dx/dy. dx(abs:512|rel:120) dy(abs:17|rel:-17)
; node # 47 D(-32,-57)->(-7,-58)
       fcb 2 ; drawmode 
       fcb -5,18 ; starx/y relative to previous node
       fdb 0,-86 ; dx/dy. dx(abs:426|rel:-86) dy(abs:17|rel:0)
; node # 48 D(-16,-18)->(-3,-18)
       fcb 2 ; drawmode 
       fcb -39,16 ; starx/y relative to previous node
       fdb -17,-205 ; dx/dy. dx(abs:221|rel:-205) dy(abs:0|rel:-17)
; node # 49 M(-10,-61)->(0,-61)
       fcb 0 ; drawmode 
       fcb 43,6 ; starx/y relative to previous node
       fdb 0,-51 ; dx/dy. dx(abs:170|rel:-51) dy(abs:0|rel:0)
; node # 50 D(-41,-61)->(-36,-63)
       fcb 2 ; drawmode 
       fcb 0,-31 ; starx/y relative to previous node
       fdb 34,-85 ; dx/dy. dx(abs:85|rel:-85) dy(abs:34|rel:34)
; node # 51 D(-60,-21)->(-56,-21)
       fcb 2 ; drawmode 
       fcb -40,-19 ; starx/y relative to previous node
       fdb -34,-17 ; dx/dy. dx(abs:68|rel:-17) dy(abs:0|rel:-34)
; node # 52 D(-52,-20)->(-55,-22)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb 34,-119 ; dx/dy. dx(abs:-51|rel:-119) dy(abs:34|rel:34)
; node # 53 D(-37,-56)->(-39,-57)
       fcb 2 ; drawmode 
       fcb 36,15 ; starx/y relative to previous node
       fdb -17,17 ; dx/dy. dx(abs:-34|rel:17) dy(abs:17|rel:-17)
; node # 54 D(-41,-61)->(-36,-63)
       fcb 2 ; drawmode 
       fcb 5,-4 ; starx/y relative to previous node
       fdb 17,119 ; dx/dy. dx(abs:85|rel:119) dy(abs:34|rel:17)
; node # 55 D(8,-56)->(9,-55)
       fcb 2 ; drawmode 
       fcb -5,49 ; starx/y relative to previous node
       fdb -51,-68 ; dx/dy. dx(abs:17|rel:-68) dy(abs:-17|rel:-51)
; node # 56 D(7,-64)->(7,-63)
       fcb 2 ; drawmode 
       fcb 8,-1 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:0|rel:-17) dy(abs:-17|rel:0)
; node # 57 D(3,-67)->(4,-66)
       fcb 2 ; drawmode 
       fcb 3,-4 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:17|rel:17) dy(abs:-17|rel:0)
; node # 58 D(14,-65)->(16,-64)
       fcb 2 ; drawmode 
       fcb -2,11 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:34|rel:17) dy(abs:-17|rel:0)
; node # 59 D(8,-56)->(9,-55)
       fcb 2 ; drawmode 
       fcb -9,-6 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:17|rel:-17) dy(abs:-17|rel:0)
; node # 60 D(-37,-56)->(-39,-57)
       fcb 2 ; drawmode 
       fcb 0,-45 ; starx/y relative to previous node
       fdb 34,-51 ; dx/dy. dx(abs:-34|rel:-51) dy(abs:17|rel:34)
; node # 61 D(-11,-48)->(-17,-49)
       fcb 2 ; drawmode 
       fcb -8,26 ; starx/y relative to previous node
       fdb 0,-68 ; dx/dy. dx(abs:-102|rel:-68) dy(abs:17|rel:0)
; node # 62 D(8,-56)->(9,-55)
       fcb 2 ; drawmode 
       fcb 8,19 ; starx/y relative to previous node
       fdb -34,119 ; dx/dy. dx(abs:17|rel:119) dy(abs:-17|rel:-34)
; node # 63 D(50,-41)->(44,-40)
       fcb 2 ; drawmode 
       fcb -15,42 ; starx/y relative to previous node
       fdb 0,-119 ; dx/dy. dx(abs:-102|rel:-119) dy(abs:-17|rel:0)
; node # 64 D(21,-43)->(15,-42)
       fcb 2 ; drawmode 
       fcb 2,-29 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-102|rel:0) dy(abs:-17|rel:0)
; node # 65 D(18,-10)->(10,-11)
       fcb 2 ; drawmode 
       fcb -33,-3 ; starx/y relative to previous node
       fdb 34,-34 ; dx/dy. dx(abs:-136|rel:-34) dy(abs:17|rel:34)
; node # 66 D(-20,-16)->(-28,-17)
       fcb 2 ; drawmode 
       fcb 6,-38 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-136|rel:0) dy(abs:17|rel:0)
; node # 67 D(-24,2)->(-33,2)
       fcb 2 ; drawmode 
       fcb -18,-4 ; starx/y relative to previous node
       fdb -17,-17 ; dx/dy. dx(abs:-153|rel:-17) dy(abs:0|rel:-17)
; node # 68 D(16,9)->(7,9)
       fcb 2 ; drawmode 
       fcb -7,40 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-153|rel:0) dy(abs:0|rel:0)
; node # 69 D(9,28)->(2,28)
       fcb 2 ; drawmode 
       fcb -19,-7 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-119|rel:34) dy(abs:0|rel:0)
; node # 70 D(-22,23)->(-29,23)
       fcb 2 ; drawmode 
       fcb 5,-31 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-119|rel:0) dy(abs:0|rel:0)
; node # 71 D(-24,2)->(-33,2)
       fcb 2 ; drawmode 
       fcb 21,-2 ; starx/y relative to previous node
       fdb 0,-34 ; dx/dy. dx(abs:-153|rel:-34) dy(abs:0|rel:0)
; node # 72 D(-57,0)->(-62,0)
       fcb 2 ; drawmode 
       fcb 2,-33 ; starx/y relative to previous node
       fdb 0,68 ; dx/dy. dx(abs:-85|rel:68) dy(abs:0|rel:0)
; node # 73 D(-47,23)->(-50,24)
       fcb 2 ; drawmode 
       fcb -23,10 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:-51|rel:34) dy(abs:-17|rel:-17)
; node # 74 D(-52,29)->(-50,30)
       fcb 2 ; drawmode 
       fcb -6,-5 ; starx/y relative to previous node
       fdb 0,85 ; dx/dy. dx(abs:34|rel:85) dy(abs:-17|rel:0)
; node # 75 M(9,28)->(2,28)
       fcb 0 ; drawmode 
       fcb 1,61 ; starx/y relative to previous node
       fdb 17,-153 ; dx/dy. dx(abs:-119|rel:-153) dy(abs:0|rel:17)
; node # 76 D(35,36)->(29,35)
       fcb 2 ; drawmode 
       fcb -8,26 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-102|rel:17) dy(abs:17|rel:17)
; node # 77 M(-47,23)->(-50,24)
       fcb 0 ; drawmode 
       fcb 13,-82 ; starx/y relative to previous node
       fdb -34,51 ; dx/dy. dx(abs:-51|rel:51) dy(abs:-17|rel:-34)
; node # 78 D(-22,23)->(-29,23)
       fcb 2 ; drawmode 
       fcb 0,25 ; starx/y relative to previous node
       fdb 17,-68 ; dx/dy. dx(abs:-119|rel:-68) dy(abs:0|rel:17)
; node # 79 M(-57,0)->(-62,0)
       fcb 0 ; drawmode 
       fcb 23,-35 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-85|rel:34) dy(abs:0|rel:0)
; node # 80 D(-52,-20)->(-55,-22)
       fcb 2 ; drawmode 
       fcb 20,5 ; starx/y relative to previous node
       fdb 34,34 ; dx/dy. dx(abs:-51|rel:34) dy(abs:34|rel:34)
; node # 81 D(-20,-16)->(-28,-17)
       fcb 2 ; drawmode 
       fcb -4,32 ; starx/y relative to previous node
       fdb -17,-85 ; dx/dy. dx(abs:-136|rel:-85) dy(abs:17|rel:-17)
; node # 82 D(-11,-48)->(-17,-49)
       fcb 2 ; drawmode 
       fcb 32,9 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-102|rel:34) dy(abs:17|rel:0)
; node # 83 D(21,-43)->(15,-42)
       fcb 2 ; drawmode 
       fcb -5,32 ; starx/y relative to previous node
       fdb -34,0 ; dx/dy. dx(abs:-102|rel:0) dy(abs:-17|rel:-34)
; node # 84 D(8,-56)->(9,-55)
       fcb 2 ; drawmode 
       fcb 13,-13 ; starx/y relative to previous node
       fdb 0,119 ; dx/dy. dx(abs:17|rel:119) dy(abs:-17|rel:0)
; node # 85 M(7,-64)->(7,-63)
       fcb 0 ; drawmode 
       fcb 8,-1 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:0|rel:-17) dy(abs:-17|rel:0)
; node # 86 D(17,-63)->(17,-62)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-17|rel:0)
; node # 87 D(14,-65)->(16,-64)
       fcb 2 ; drawmode 
       fcb 2,-3 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:34|rel:34) dy(abs:-17|rel:0)
; node # 88 M(3,-67)->(4,-66)
       fcb 0 ; drawmode 
       fcb 2,-11 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:17|rel:-17) dy(abs:-17|rel:0)
; node # 89 D(8,-56)->(9,-55)
       fcb 2 ; drawmode 
       fcb -11,5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:17|rel:0) dy(abs:-17|rel:0)
; node # 90 D(-10,-61)->(0,-61)
       fcb 2 ; drawmode 
       fcb 5,-18 ; starx/y relative to previous node
       fdb 17,153 ; dx/dy. dx(abs:170|rel:153) dy(abs:0|rel:17)
; node # 91 M(17,-63)->(17,-62)
       fcb 0 ; drawmode 
       fcb 2,27 ; starx/y relative to previous node
       fdb -17,-170 ; dx/dy. dx(abs:0|rel:-170) dy(abs:-17|rel:-17)
; node # 92 D(8,-56)->(9,-55)
       fcb 2 ; drawmode 
       fcb -7,-9 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:17|rel:17) dy(abs:-17|rel:0)
; node # 93 M(24,-28)->(16,-28)
       fcb 0 ; drawmode 
       fcb -28,16 ; starx/y relative to previous node
       fdb 17,-153 ; dx/dy. dx(abs:-136|rel:-153) dy(abs:0|rel:17)
; node # 94 D(32,-25)->(20,-25)
       fcb 2 ; drawmode 
       fcb -3,8 ; starx/y relative to previous node
       fdb 0,-68 ; dx/dy. dx(abs:-204|rel:-68) dy(abs:0|rel:0)
; node # 95 D(29,-12)->(18,-12)
       fcb 2 ; drawmode 
       fcb -13,-3 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-187|rel:17) dy(abs:0|rel:0)
; node # 96 D(21,2)->(12,3)
       fcb 2 ; drawmode 
       fcb -14,-8 ; starx/y relative to previous node
       fdb -17,34 ; dx/dy. dx(abs:-153|rel:34) dy(abs:-17|rel:-17)
; node # 97 D(12,1)->(4,1)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb 17,17 ; dx/dy. dx(abs:-136|rel:17) dy(abs:0|rel:17)
; node # 98 D(21,-13)->(9,-13)
       fcb 2 ; drawmode 
       fcb 14,9 ; starx/y relative to previous node
       fdb 0,-68 ; dx/dy. dx(abs:-204|rel:-68) dy(abs:0|rel:0)
; node # 99 D(23,-26)->(11,-26)
       fcb 2 ; drawmode 
       fcb 13,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-204|rel:0) dy(abs:0|rel:0)
; node # 100 D(16,-29)->(7,-29)
       fcb 2 ; drawmode 
       fcb 3,-7 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-153|rel:51) dy(abs:0|rel:0)
; node # 101 D(24,-28)->(16,-28)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-136|rel:17) dy(abs:0|rel:0)
; node # 102 D(20,-33)->(13,-33)
       fcb 2 ; drawmode 
       fcb 5,-4 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-119|rel:17) dy(abs:0|rel:0)
; node # 103 D(29,-29)->(17,-29)
       fcb 2 ; drawmode 
       fcb -4,9 ; starx/y relative to previous node
       fdb 0,-85 ; dx/dy. dx(abs:-204|rel:-85) dy(abs:0|rel:0)
; node # 104 D(26,-8)->(14,-8)
       fcb 2 ; drawmode 
       fcb -21,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-204|rel:0) dy(abs:0|rel:0)
; node # 105 D(16,9)->(7,9)
       fcb 2 ; drawmode 
       fcb -17,-10 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-153|rel:51) dy(abs:0|rel:0)
; node # 106 D(12,1)->(4,1)
       fcb 2 ; drawmode 
       fcb 8,-4 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-136|rel:17) dy(abs:0|rel:0)
; node # 107 M(-57,0)->(-62,0)
       fcb 0 ; drawmode 
       fcb 1,-69 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-85|rel:51) dy(abs:0|rel:0)
; node # 108 D(-67,3)->(-64,3)
       fcb 2 ; drawmode 
       fcb -3,-10 ; starx/y relative to previous node
       fdb 0,136 ; dx/dy. dx(abs:51|rel:136) dy(abs:0|rel:0)
; node # 109 M(12,1)->(4,1)
       fcb 0 ; drawmode 
       fcb 2,79 ; starx/y relative to previous node
       fdb 0,-187 ; dx/dy. dx(abs:-136|rel:-187) dy(abs:0|rel:0)
; node # 110 M(23,-26)->(11,-26)
       fcb 0 ; drawmode 
       fcb 27,11 ; starx/y relative to previous node
       fdb 0,-68 ; dx/dy. dx(abs:-204|rel:-68) dy(abs:0|rel:0)
; node # 111 D(29,-29)->(17,-29)
       fcb 2 ; drawmode 
       fcb 3,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-204|rel:0) dy(abs:0|rel:0)
; node # 112 M(16,9)->(7,9)
       fcb 0 ; drawmode 
       fcb -38,-13 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-153|rel:51) dy(abs:0|rel:0)
; node # 113 D(21,2)->(12,3)
       fcb 2 ; drawmode 
       fcb 7,5 ; starx/y relative to previous node
       fdb -17,0 ; dx/dy. dx(abs:-153|rel:0) dy(abs:-17|rel:-17)
; node # 114 M(29,-12)->(18,-12)
       fcb 0 ; drawmode 
       fcb 14,8 ; starx/y relative to previous node
       fdb 17,-34 ; dx/dy. dx(abs:-187|rel:-34) dy(abs:0|rel:17)
; node # 115 D(26,-8)->(14,-8)
       fcb 2 ; drawmode 
       fcb -4,-3 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-204|rel:-17) dy(abs:0|rel:0)
; node # 116 D(21,-13)->(9,-13)
       fcb 2 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-204|rel:0) dy(abs:0|rel:0)
; node # 117 D(29,-12)->(18,-12)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb 0,17 ; dx/dy. dx(abs:-187|rel:17) dy(abs:0|rel:0)
; node # 118 M(23,-26)->(11,-26)
       fcb 0 ; drawmode 
       fcb 14,-6 ; starx/y relative to previous node
       fdb 0,-17 ; dx/dy. dx(abs:-204|rel:-17) dy(abs:0|rel:0)
; node # 119 D(32,-25)->(20,-25)
       fcb 2 ; drawmode 
       fcb -1,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-204|rel:0) dy(abs:0|rel:0)
; node # 120 M(32,-25)->(20,-25)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-204|rel:0) dy(abs:0|rel:0)
; node # 121 D(29,-29)->(17,-29)
       fcb 2 ; drawmode 
       fcb 4,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-204|rel:0) dy(abs:0|rel:0)
; node # 122 M(16,-29)->(7,-29)
       fcb 0 ; drawmode 
       fcb 0,-13 ; starx/y relative to previous node
       fdb 0,51 ; dx/dy. dx(abs:-153|rel:51) dy(abs:0|rel:0)
; node # 123 D(20,-33)->(13,-33)
       fcb 2 ; drawmode 
       fcb 4,4 ; starx/y relative to previous node
       fdb 0,34 ; dx/dy. dx(abs:-119|rel:34) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 13
teapotBframe13:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-64,3)->(-57,3)
       fcb 0 ; drawmode 
       fcb -3,-64 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:128|rel:128) dy(abs:0|rel:0)
; node # 1 D(-17,14)->(-3,14)
       fcb 2 ; drawmode 
       fcb -11,47 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:256|rel:128) dy(abs:0|rel:0)
; node # 2 D(-17,39)->(-7,40)
       fcb 2 ; drawmode 
       fcb -25,0 ; starx/y relative to previous node
       fdb -18,-74 ; dx/dy. dx(abs:182|rel:-74) dy(abs:-18|rel:-18)
; node # 3 D(-50,30)->(-45,31)
       fcb 2 ; drawmode 
       fcb 9,-33 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:91|rel:-91) dy(abs:-18|rel:0)
; node # 4 D(-64,3)->(-57,3)
       fcb 2 ; drawmode 
       fcb 27,-14 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:128|rel:37) dy(abs:0|rel:18)
; node # 5 D(-56,-21)->(-49,-22)
       fcb 2 ; drawmode 
       fcb 24,8 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:128|rel:0) dy(abs:18|rel:18)
; node # 6 D(-11,-13)->(2,-14)
       fcb 2 ; drawmode 
       fcb -8,45 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:237|rel:109) dy(abs:18|rel:0)
; node # 7 D(0,-61)->(10,-61)
       fcb 2 ; drawmode 
       fcb 48,11 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:182|rel:-55) dy(abs:0|rel:-18)
; node # 8 D(44,-51)->(50,-50)
       fcb 2 ; drawmode 
       fcb -10,44 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:109|rel:-73) dy(abs:-18|rel:-18)
; node # 9 D(59,-42)->(58,-41)
       fcb 2 ; drawmode 
       fcb -9,15 ; starx/y relative to previous node
       fdb 0,-127 ; dx/dy. dx(abs:-18|rel:-127) dy(abs:-18|rel:0)
; node # 10 D(64,0)->(62,0)
       fcb 2 ; drawmode 
       fcb -42,5 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:0|rel:18)
; node # 11 D(63,23)->(61,22)
       fcb 2 ; drawmode 
       fcb -23,-1 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:18|rel:18)
; node # 12 D(41,42)->(41,41)
       fcb 2 ; drawmode 
       fcb -19,-22 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:18|rel:0)
; node # 13 D(29,35)->(25,35)
       fcb 2 ; drawmode 
       fcb 7,-12 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-73|rel:-73) dy(abs:0|rel:-18)
; node # 14 D(45,17)->(37,16)
       fcb 2 ; drawmode 
       fcb 18,16 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:18|rel:18)
; node # 15 D(45,-4)->(39,-3)
       fcb 2 ; drawmode 
       fcb 21,0 ; starx/y relative to previous node
       fdb -36,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:-18|rel:-36)
; node # 16 D(64,0)->(62,0)
       fcb 2 ; drawmode 
       fcb -4,19 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-36|rel:73) dy(abs:0|rel:18)
; node # 17 D(46,-3)->(54,-4)
       fcb 2 ; drawmode 
       fcb 3,-18 ; starx/y relative to previous node
       fdb 18,182 ; dx/dy. dx(abs:146|rel:182) dy(abs:18|rel:18)
; node # 18 D(44,-51)->(50,-50)
       fcb 2 ; drawmode 
       fcb 48,-2 ; starx/y relative to previous node
       fdb -36,-37 ; dx/dy. dx(abs:109|rel:-37) dy(abs:-18|rel:-36)
; node # 19 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb 4,-35 ; starx/y relative to previous node
       fdb 18,-109 ; dx/dy. dx(abs:0|rel:-109) dy(abs:0|rel:18)
; node # 20 D(59,-42)->(58,-41)
       fcb 2 ; drawmode 
       fcb -13,50 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:-18|rel:-18)
; node # 21 D(44,-40)->(39,-38)
       fcb 2 ; drawmode 
       fcb -2,-15 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-91|rel:-73) dy(abs:-36|rel:-18)
; node # 22 D(45,-4)->(39,-3)
       fcb 2 ; drawmode 
       fcb -36,1 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:-18|rel:18)
; node # 23 D(10,-11)->(1,-9)
       fcb 2 ; drawmode 
       fcb 7,-35 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:-36|rel:-18)
; node # 24 D(7,9)->(-2,8)
       fcb 2 ; drawmode 
       fcb -20,-3 ; starx/y relative to previous node
       fdb 54,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:18|rel:54)
; node # 25 D(45,17)->(37,16)
       fcb 2 ; drawmode 
       fcb -8,38 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:18|rel:0)
; node # 26 D(63,23)->(61,22)
       fcb 2 ; drawmode 
       fcb -6,18 ; starx/y relative to previous node
       fdb 0,110 ; dx/dy. dx(abs:-36|rel:110) dy(abs:18|rel:0)
; node # 27 D(43,23)->(52,23)
       fcb 2 ; drawmode 
       fcb 0,-20 ; starx/y relative to previous node
       fdb -18,200 ; dx/dy. dx(abs:164|rel:200) dy(abs:0|rel:-18)
; node # 28 D(46,-3)->(54,-4)
       fcb 2 ; drawmode 
       fcb 26,3 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:146|rel:-18) dy(abs:18|rel:18)
; node # 29 D(-11,-13)->(2,-14)
       fcb 2 ; drawmode 
       fcb 10,-57 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:237|rel:91) dy(abs:18|rel:0)
; node # 30 D(-17,14)->(-3,14)
       fcb 2 ; drawmode 
       fcb -27,-6 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:256|rel:19) dy(abs:0|rel:-18)
; node # 31 D(43,23)->(52,23)
       fcb 2 ; drawmode 
       fcb -9,60 ; starx/y relative to previous node
       fdb 0,-92 ; dx/dy. dx(abs:164|rel:-92) dy(abs:0|rel:0)
; node # 32 D(25,45)->(31,44)
       fcb 2 ; drawmode 
       fcb -22,-18 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:109|rel:-55) dy(abs:18|rel:18)
; node # 33 D(-17,39)->(-7,40)
       fcb 2 ; drawmode 
       fcb 6,-42 ; starx/y relative to previous node
       fdb -36,73 ; dx/dy. dx(abs:182|rel:73) dy(abs:-18|rel:-36)
; node # 34 M(41,42)->(41,41)
       fcb 0 ; drawmode 
       fcb -3,58 ; starx/y relative to previous node
       fdb 36,-182 ; dx/dy. dx(abs:0|rel:-182) dy(abs:18|rel:36)
; node # 35 D(25,45)->(31,44)
       fcb 2 ; drawmode 
       fcb -3,-16 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:109|rel:109) dy(abs:18|rel:0)
; node # 36 M(-17,14)->(-3,14)
       fcb 0 ; drawmode 
       fcb 31,-42 ; starx/y relative to previous node
       fdb -18,147 ; dx/dy. dx(abs:256|rel:147) dy(abs:0|rel:-18)
; node # 37 D(-17,-33)->(5,-34)
       fcb 2 ; drawmode 
       fcb 47,0 ; starx/y relative to previous node
       fdb 18,146 ; dx/dy. dx(abs:402|rel:146) dy(abs:18|rel:18)
; node # 38 D(-20,-63)->(10,-63)
       fcb 2 ; drawmode 
       fcb 30,-3 ; starx/y relative to previous node
       fdb -18,146 ; dx/dy. dx(abs:548|rel:146) dy(abs:0|rel:-18)
; node # 39 D(-23,-60)->(2,-60)
       fcb 2 ; drawmode 
       fcb -3,-3 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:457|rel:-91) dy(abs:0|rel:0)
; node # 40 D(-16,-21)->(-4,-21)
       fcb 2 ; drawmode 
       fcb -39,7 ; starx/y relative to previous node
       fdb 0,-238 ; dx/dy. dx(abs:219|rel:-238) dy(abs:0|rel:0)
; node # 41 D(-17,14)->(-3,14)
       fcb 2 ; drawmode 
       fcb -35,-1 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:256|rel:37) dy(abs:0|rel:0)
; node # 42 D(-3,-18)->(10,-18)
       fcb 2 ; drawmode 
       fcb 32,14 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:237|rel:-19) dy(abs:0|rel:0)
; node # 43 D(-16,-21)->(-4,-21)
       fcb 2 ; drawmode 
       fcb 3,-13 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:219|rel:-18) dy(abs:0|rel:0)
; node # 44 M(-7,-58)->(18,-57)
       fcb 0 ; drawmode 
       fcb 37,9 ; starx/y relative to previous node
       fdb -18,238 ; dx/dy. dx(abs:457|rel:238) dy(abs:-18|rel:-18)
; node # 45 D(-23,-60)->(2,-60)
       fcb 2 ; drawmode 
       fcb 2,-16 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:457|rel:0) dy(abs:0|rel:18)
; node # 46 M(-20,-63)->(10,-63)
       fcb 0 ; drawmode 
       fcb 3,3 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:548|rel:91) dy(abs:0|rel:0)
; node # 47 D(-7,-58)->(18,-57)
       fcb 2 ; drawmode 
       fcb -5,13 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:457|rel:-91) dy(abs:-18|rel:-18)
; node # 48 D(-3,-18)->(10,-18)
       fcb 2 ; drawmode 
       fcb -40,4 ; starx/y relative to previous node
       fdb 18,-220 ; dx/dy. dx(abs:237|rel:-220) dy(abs:0|rel:18)
; node # 49 M(0,-61)->(10,-61)
       fcb 0 ; drawmode 
       fcb 43,3 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:182|rel:-55) dy(abs:0|rel:0)
; node # 50 D(-36,-63)->(-31,-65)
       fcb 2 ; drawmode 
       fcb 2,-36 ; starx/y relative to previous node
       fdb 36,-91 ; dx/dy. dx(abs:91|rel:-91) dy(abs:36|rel:36)
; node # 51 D(-56,-21)->(-49,-22)
       fcb 2 ; drawmode 
       fcb -42,-20 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:128|rel:37) dy(abs:18|rel:-18)
; node # 52 D(-55,-22)->(-59,-22)
       fcb 2 ; drawmode 
       fcb 1,1 ; starx/y relative to previous node
       fdb -18,-201 ; dx/dy. dx(abs:-73|rel:-201) dy(abs:0|rel:-18)
; node # 53 D(-39,-57)->(-41,-59)
       fcb 2 ; drawmode 
       fcb 35,16 ; starx/y relative to previous node
       fdb 36,37 ; dx/dy. dx(abs:-36|rel:37) dy(abs:36|rel:36)
; node # 54 D(-36,-63)->(-31,-65)
       fcb 2 ; drawmode 
       fcb 6,3 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:91|rel:127) dy(abs:36|rel:0)
; node # 55 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb -8,45 ; starx/y relative to previous node
       fdb -36,-91 ; dx/dy. dx(abs:0|rel:-91) dy(abs:0|rel:-36)
; node # 56 D(7,-63)->(5,-63)
       fcb 2 ; drawmode 
       fcb 8,-2 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:0|rel:0)
; node # 57 D(4,-66)->(5,-66)
       fcb 2 ; drawmode 
       fcb 3,-3 ; starx/y relative to previous node
       fdb 0,54 ; dx/dy. dx(abs:18|rel:54) dy(abs:0|rel:0)
; node # 58 D(16,-64)->(17,-64)
       fcb 2 ; drawmode 
       fcb -2,12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:0)
; node # 59 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb -9,-7 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:0)
; node # 60 D(-39,-57)->(-41,-59)
       fcb 2 ; drawmode 
       fcb 2,-48 ; starx/y relative to previous node
       fdb 36,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:36|rel:36)
; node # 61 D(-17,-49)->(-24,-50)
       fcb 2 ; drawmode 
       fcb -8,22 ; starx/y relative to previous node
       fdb -18,-92 ; dx/dy. dx(abs:-128|rel:-92) dy(abs:18|rel:-18)
; node # 62 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb 6,26 ; starx/y relative to previous node
       fdb -18,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:-18)
; node # 63 D(44,-40)->(39,-38)
       fcb 2 ; drawmode 
       fcb -15,35 ; starx/y relative to previous node
       fdb -36,-91 ; dx/dy. dx(abs:-91|rel:-91) dy(abs:-36|rel:-36)
; node # 64 D(15,-42)->(7,-42)
       fcb 2 ; drawmode 
       fcb 2,-29 ; starx/y relative to previous node
       fdb 36,-55 ; dx/dy. dx(abs:-146|rel:-55) dy(abs:0|rel:36)
; node # 65 D(10,-11)->(1,-9)
       fcb 2 ; drawmode 
       fcb -31,-5 ; starx/y relative to previous node
       fdb -36,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:-36|rel:-36)
; node # 66 D(-28,-17)->(-36,-16)
       fcb 2 ; drawmode 
       fcb 6,-38 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:-18|rel:18)
; node # 67 D(-33,2)->(-41,2)
       fcb 2 ; drawmode 
       fcb -19,-5 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:18)
; node # 68 D(7,9)->(-2,8)
       fcb 2 ; drawmode 
       fcb -7,40 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:18|rel:18)
; node # 69 D(2,28)->(-5,28)
       fcb 2 ; drawmode 
       fcb -19,-5 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:-18)
; node # 70 D(-29,23)->(-35,24)
       fcb 2 ; drawmode 
       fcb 5,-31 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:-18|rel:-18)
; node # 71 D(-33,2)->(-41,2)
       fcb 2 ; drawmode 
       fcb 21,-4 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:18)
; node # 72 D(-62,0)->(-65,0)
       fcb 2 ; drawmode 
       fcb 2,-29 ; starx/y relative to previous node
       fdb 0,92 ; dx/dy. dx(abs:-54|rel:92) dy(abs:0|rel:0)
; node # 73 D(-50,24)->(-53,25)
       fcb 2 ; drawmode 
       fcb -24,12 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-54|rel:0) dy(abs:-18|rel:-18)
; node # 74 D(-50,30)->(-45,31)
       fcb 2 ; drawmode 
       fcb -6,0 ; starx/y relative to previous node
       fdb 0,145 ; dx/dy. dx(abs:91|rel:145) dy(abs:-18|rel:0)
; node # 75 M(2,28)->(-5,28)
       fcb 0 ; drawmode 
       fcb 2,52 ; starx/y relative to previous node
       fdb 18,-219 ; dx/dy. dx(abs:-128|rel:-219) dy(abs:0|rel:18)
; node # 76 D(29,35)->(25,35)
       fcb 2 ; drawmode 
       fcb -7,27 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-73|rel:55) dy(abs:0|rel:0)
; node # 77 M(-50,24)->(-53,25)
       fcb 0 ; drawmode 
       fcb 11,-79 ; starx/y relative to previous node
       fdb -18,19 ; dx/dy. dx(abs:-54|rel:19) dy(abs:-18|rel:-18)
; node # 78 D(-29,23)->(-35,24)
       fcb 2 ; drawmode 
       fcb 1,21 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-109|rel:-55) dy(abs:-18|rel:0)
; node # 79 M(-62,0)->(-65,0)
       fcb 0 ; drawmode 
       fcb 23,-33 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-54|rel:55) dy(abs:0|rel:18)
; node # 80 D(-55,-22)->(-59,-22)
       fcb 2 ; drawmode 
       fcb 22,7 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-73|rel:-19) dy(abs:0|rel:0)
; node # 81 D(-28,-17)->(-36,-16)
       fcb 2 ; drawmode 
       fcb -5,27 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-146|rel:-73) dy(abs:-18|rel:-18)
; node # 82 D(-17,-49)->(-24,-50)
       fcb 2 ; drawmode 
       fcb 32,11 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:18|rel:36)
; node # 83 D(15,-42)->(7,-42)
       fcb 2 ; drawmode 
       fcb -7,32 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:-18)
; node # 84 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb 13,-6 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:0|rel:146) dy(abs:0|rel:0)
; node # 85 M(7,-63)->(5,-63)
       fcb 0 ; drawmode 
       fcb 8,-2 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:0|rel:0)
; node # 86 D(17,-62)->(16,-61)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:-18|rel:-18)
; node # 87 D(16,-64)->(17,-64)
       fcb 2 ; drawmode 
       fcb 2,-1 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:18|rel:36) dy(abs:0|rel:18)
; node # 88 M(4,-66)->(5,-66)
       fcb 0 ; drawmode 
       fcb 2,-12 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:0|rel:0)
; node # 89 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb -11,5 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:0)
; node # 90 D(0,-61)->(10,-61)
       fcb 2 ; drawmode 
       fcb 6,-9 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:182|rel:182) dy(abs:0|rel:0)
; node # 91 M(17,-62)->(16,-61)
       fcb 0 ; drawmode 
       fcb 1,17 ; starx/y relative to previous node
       fdb -18,-200 ; dx/dy. dx(abs:-18|rel:-200) dy(abs:-18|rel:-18)
; node # 92 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb -7,-8 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:18)
; node # 93 M(16,-28)->(9,-27)
       fcb 0 ; drawmode 
       fcb -27,7 ; starx/y relative to previous node
       fdb -18,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:-18|rel:-18)
; node # 94 D(20,-25)->(8,-25)
       fcb 2 ; drawmode 
       fcb -3,4 ; starx/y relative to previous node
       fdb 18,-91 ; dx/dy. dx(abs:-219|rel:-91) dy(abs:0|rel:18)
; node # 95 D(18,-12)->(6,-13)
       fcb 2 ; drawmode 
       fcb -13,-2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:18|rel:18)
; node # 96 D(12,3)->(4,3)
       fcb 2 ; drawmode 
       fcb -15,-6 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-146|rel:73) dy(abs:0|rel:-18)
; node # 97 D(4,1)->(-5,1)
       fcb 2 ; drawmode 
       fcb 2,-8 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 98 D(9,-13)->(-2,-15)
       fcb 2 ; drawmode 
       fcb 14,5 ; starx/y relative to previous node
       fdb 36,-37 ; dx/dy. dx(abs:-201|rel:-37) dy(abs:36|rel:36)
; node # 99 D(11,-26)->(0,-26)
       fcb 2 ; drawmode 
       fcb 13,2 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:0|rel:-36)
; node # 100 D(7,-29)->(0,-29)
       fcb 2 ; drawmode 
       fcb 3,-4 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-128|rel:73) dy(abs:0|rel:0)
; node # 101 D(16,-28)->(9,-27)
       fcb 2 ; drawmode 
       fcb -1,9 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:-18|rel:-18)
; node # 102 D(13,-33)->(5,-32)
       fcb 2 ; drawmode 
       fcb 5,-3 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:-18|rel:0)
; node # 103 D(17,-29)->(4,-29)
       fcb 2 ; drawmode 
       fcb -4,4 ; starx/y relative to previous node
       fdb 18,-91 ; dx/dy. dx(abs:-237|rel:-91) dy(abs:0|rel:18)
; node # 104 D(14,-8)->(1,-8)
       fcb 2 ; drawmode 
       fcb -21,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-237|rel:0) dy(abs:0|rel:0)
; node # 105 D(7,9)->(-2,8)
       fcb 2 ; drawmode 
       fcb -17,-7 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-164|rel:73) dy(abs:18|rel:18)
; node # 106 D(4,1)->(-5,1)
       fcb 2 ; drawmode 
       fcb 8,-3 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:-18)
; node # 107 M(-62,0)->(-65,0)
       fcb 0 ; drawmode 
       fcb 1,-66 ; starx/y relative to previous node
       fdb 0,110 ; dx/dy. dx(abs:-54|rel:110) dy(abs:0|rel:0)
; node # 108 D(-64,3)->(-57,3)
       fcb 2 ; drawmode 
       fcb -3,-2 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:128|rel:182) dy(abs:0|rel:0)
; node # 109 M(4,1)->(-5,1)
       fcb 0 ; drawmode 
       fcb 2,68 ; starx/y relative to previous node
       fdb 0,-292 ; dx/dy. dx(abs:-164|rel:-292) dy(abs:0|rel:0)
; node # 110 M(11,-26)->(0,-26)
       fcb 0 ; drawmode 
       fcb 27,7 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-201|rel:-37) dy(abs:0|rel:0)
; node # 111 D(17,-29)->(4,-29)
       fcb 2 ; drawmode 
       fcb 3,6 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-237|rel:-36) dy(abs:0|rel:0)
; node # 112 M(7,9)->(-2,8)
       fcb 0 ; drawmode 
       fcb -38,-10 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-164|rel:73) dy(abs:18|rel:18)
; node # 113 D(12,3)->(4,3)
       fcb 2 ; drawmode 
       fcb 6,5 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:-18)
; node # 114 M(18,-12)->(6,-13)
       fcb 0 ; drawmode 
       fcb 15,6 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:18|rel:18)
; node # 115 D(14,-8)->(1,-9)
       fcb 2 ; drawmode 
       fcb -4,-4 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-237|rel:-18) dy(abs:18|rel:0)
; node # 116 D(9,-13)->(-2,-15)
       fcb 2 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-201|rel:36) dy(abs:36|rel:18)
; node # 117 D(18,-12)->(6,-13)
       fcb 2 ; drawmode 
       fcb -1,9 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:18|rel:-18)
; node # 118 M(11,-26)->(0,-26)
       fcb 0 ; drawmode 
       fcb 14,-7 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:0|rel:-18)
; node # 119 D(20,-25)->(8,-25)
       fcb 2 ; drawmode 
       fcb -1,9 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:0|rel:0)
; node # 120 M(20,-25)->(8,-25)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:0|rel:0)
; node # 121 D(17,-29)->(4,-29)
       fcb 2 ; drawmode 
       fcb 4,-3 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-237|rel:-18) dy(abs:0|rel:0)
; node # 122 M(7,-29)->(0,-29)
       fcb 0 ; drawmode 
       fcb 0,-10 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:-128|rel:109) dy(abs:0|rel:0)
; node # 123 D(13,-33)->(5,-32)
       fcb 2 ; drawmode 
       fcb 4,6 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:-18|rel:-18)
       fcb  1  ; end of anim
; Animation 14
teapotBframe14:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-57,3)->(-49,3)
       fcb 0 ; drawmode 
       fcb -3,-57 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:146|rel:146) dy(abs:0|rel:0)
; node # 1 D(-3,14)->(12,14)
       fcb 2 ; drawmode 
       fcb -11,54 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:274|rel:128) dy(abs:0|rel:0)
; node # 2 D(-7,40)->(2,40)
       fcb 2 ; drawmode 
       fcb -26,-4 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:164|rel:-110) dy(abs:0|rel:0)
; node # 3 D(-45,31)->(-39,31)
       fcb 2 ; drawmode 
       fcb 9,-38 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:109|rel:-55) dy(abs:0|rel:0)
; node # 4 D(-57,3)->(-49,3)
       fcb 2 ; drawmode 
       fcb 28,-12 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:146|rel:37) dy(abs:0|rel:0)
; node # 5 D(-49,-22)->(-41,-23)
       fcb 2 ; drawmode 
       fcb 25,8 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:146|rel:0) dy(abs:18|rel:18)
; node # 6 D(2,-14)->(16,-14)
       fcb 2 ; drawmode 
       fcb -8,51 ; starx/y relative to previous node
       fdb -18,110 ; dx/dy. dx(abs:256|rel:110) dy(abs:0|rel:-18)
; node # 7 D(10,-61)->(21,-60)
       fcb 2 ; drawmode 
       fcb 47,8 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:201|rel:-55) dy(abs:-18|rel:-18)
; node # 8 D(50,-50)->(55,-49)
       fcb 2 ; drawmode 
       fcb -11,40 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:91|rel:-110) dy(abs:-18|rel:0)
; node # 9 D(58,-41)->(55,-39)
       fcb 2 ; drawmode 
       fcb -9,8 ; starx/y relative to previous node
       fdb -18,-145 ; dx/dy. dx(abs:-54|rel:-145) dy(abs:-36|rel:-18)
; node # 10 D(62,0)->(60,0)
       fcb 2 ; drawmode 
       fcb -41,4 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:0|rel:36)
; node # 11 D(61,22)->(59,22)
       fcb 2 ; drawmode 
       fcb -22,-1 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:0|rel:0)
; node # 12 D(41,41)->(40,40)
       fcb 2 ; drawmode 
       fcb -19,-20 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:18|rel:18)
; node # 13 D(25,35)->(19,34)
       fcb 2 ; drawmode 
       fcb 6,-16 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:-109|rel:-91) dy(abs:18|rel:0)
; node # 14 D(37,16)->(29,15)
       fcb 2 ; drawmode 
       fcb 19,12 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:18|rel:0)
; node # 15 D(39,-3)->(31,-3)
       fcb 2 ; drawmode 
       fcb 19,2 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:-18)
; node # 16 D(62,0)->(60,0)
       fcb 2 ; drawmode 
       fcb -3,23 ; starx/y relative to previous node
       fdb 0,110 ; dx/dy. dx(abs:-36|rel:110) dy(abs:0|rel:0)
; node # 17 D(54,-4)->(58,-4)
       fcb 2 ; drawmode 
       fcb 4,-8 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:73|rel:109) dy(abs:0|rel:0)
; node # 18 D(50,-50)->(55,-49)
       fcb 2 ; drawmode 
       fcb 46,-4 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:91|rel:18) dy(abs:-18|rel:-18)
; node # 19 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb 5,-41 ; starx/y relative to previous node
       fdb 18,-91 ; dx/dy. dx(abs:0|rel:-91) dy(abs:0|rel:18)
; node # 20 D(58,-41)->(55,-39)
       fcb 2 ; drawmode 
       fcb -14,49 ; starx/y relative to previous node
       fdb -36,-54 ; dx/dy. dx(abs:-54|rel:-54) dy(abs:-36|rel:-36)
; node # 21 D(39,-38)->(32,-38)
       fcb 2 ; drawmode 
       fcb -3,-19 ; starx/y relative to previous node
       fdb 36,-74 ; dx/dy. dx(abs:-128|rel:-74) dy(abs:0|rel:36)
; node # 22 D(39,-3)->(31,-3)
       fcb 2 ; drawmode 
       fcb -35,0 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 23 D(1,-9)->(-7,-9)
       fcb 2 ; drawmode 
       fcb 6,-38 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 24 D(-2,8)->(-11,8)
       fcb 2 ; drawmode 
       fcb -17,-3 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 25 D(37,16)->(29,15)
       fcb 2 ; drawmode 
       fcb -8,39 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:18|rel:18)
; node # 26 D(61,22)->(59,22)
       fcb 2 ; drawmode 
       fcb -6,24 ; starx/y relative to previous node
       fdb -18,110 ; dx/dy. dx(abs:-36|rel:110) dy(abs:0|rel:-18)
; node # 27 D(52,23)->(57,22)
       fcb 2 ; drawmode 
       fcb -1,-9 ; starx/y relative to previous node
       fdb 18,127 ; dx/dy. dx(abs:91|rel:127) dy(abs:18|rel:18)
; node # 28 D(54,-4)->(58,-4)
       fcb 2 ; drawmode 
       fcb 27,2 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:73|rel:-18) dy(abs:0|rel:-18)
; node # 29 D(2,-14)->(16,-14)
       fcb 2 ; drawmode 
       fcb 10,-52 ; starx/y relative to previous node
       fdb 0,183 ; dx/dy. dx(abs:256|rel:183) dy(abs:0|rel:0)
; node # 30 D(-3,14)->(12,14)
       fcb 2 ; drawmode 
       fcb -28,-5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:274|rel:18) dy(abs:0|rel:0)
; node # 31 D(52,23)->(57,22)
       fcb 2 ; drawmode 
       fcb -9,55 ; starx/y relative to previous node
       fdb 18,-183 ; dx/dy. dx(abs:91|rel:-183) dy(abs:18|rel:18)
; node # 32 D(31,44)->(36,43)
       fcb 2 ; drawmode 
       fcb -21,-21 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:91|rel:0) dy(abs:18|rel:0)
; node # 33 D(-7,40)->(2,40)
       fcb 2 ; drawmode 
       fcb 4,-38 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:164|rel:73) dy(abs:0|rel:-18)
; node # 34 M(41,41)->(40,40)
       fcb 0 ; drawmode 
       fcb -1,48 ; starx/y relative to previous node
       fdb 18,-182 ; dx/dy. dx(abs:-18|rel:-182) dy(abs:18|rel:18)
; node # 35 D(31,44)->(36,43)
       fcb 2 ; drawmode 
       fcb -3,-10 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:91|rel:109) dy(abs:18|rel:0)
; node # 36 M(-3,14)->(12,14)
       fcb 0 ; drawmode 
       fcb 30,-34 ; starx/y relative to previous node
       fdb -18,183 ; dx/dy. dx(abs:274|rel:183) dy(abs:0|rel:-18)
; node # 37 D(5,-34)->(26,-32)
       fcb 2 ; drawmode 
       fcb 48,8 ; starx/y relative to previous node
       fdb -36,110 ; dx/dy. dx(abs:384|rel:110) dy(abs:-36|rel:-36)
; node # 38 D(10,-63)->(41,-62)
       fcb 2 ; drawmode 
       fcb 29,5 ; starx/y relative to previous node
       fdb 18,182 ; dx/dy. dx(abs:566|rel:182) dy(abs:-18|rel:18)
; node # 39 D(2,-60)->(26,-59)
       fcb 2 ; drawmode 
       fcb -3,-8 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:438|rel:-128) dy(abs:-18|rel:0)
; node # 40 D(-4,-21)->(9,-21)
       fcb 2 ; drawmode 
       fcb -39,-6 ; starx/y relative to previous node
       fdb 18,-201 ; dx/dy. dx(abs:237|rel:-201) dy(abs:0|rel:18)
; node # 41 D(-3,14)->(12,14)
       fcb 2 ; drawmode 
       fcb -35,1 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:274|rel:37) dy(abs:0|rel:0)
; node # 42 D(10,-18)->(22,-18)
       fcb 2 ; drawmode 
       fcb 32,13 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:219|rel:-55) dy(abs:0|rel:0)
; node # 43 D(-4,-21)->(9,-21)
       fcb 2 ; drawmode 
       fcb 3,-14 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:237|rel:18) dy(abs:0|rel:0)
; node # 44 M(18,-57)->(42,-56)
       fcb 0 ; drawmode 
       fcb 36,22 ; starx/y relative to previous node
       fdb -18,201 ; dx/dy. dx(abs:438|rel:201) dy(abs:-18|rel:-18)
; node # 45 D(2,-60)->(26,-59)
       fcb 2 ; drawmode 
       fcb 3,-16 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:438|rel:0) dy(abs:-18|rel:0)
; node # 46 M(10,-63)->(41,-62)
       fcb 0 ; drawmode 
       fcb 3,8 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:566|rel:128) dy(abs:-18|rel:0)
; node # 47 D(18,-57)->(42,-56)
       fcb 2 ; drawmode 
       fcb -6,8 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:438|rel:-128) dy(abs:-18|rel:0)
; node # 48 D(10,-18)->(22,-18)
       fcb 2 ; drawmode 
       fcb -39,-8 ; starx/y relative to previous node
       fdb 18,-219 ; dx/dy. dx(abs:219|rel:-219) dy(abs:0|rel:18)
; node # 49 M(10,-61)->(21,-60)
       fcb 0 ; drawmode 
       fcb 43,0 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:-18|rel:-18)
; node # 50 D(-31,-65)->(-23,-65)
       fcb 2 ; drawmode 
       fcb 4,-41 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:146|rel:-55) dy(abs:0|rel:18)
; node # 51 D(-49,-22)->(-41,-23)
       fcb 2 ; drawmode 
       fcb -43,-18 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:146|rel:0) dy(abs:18|rel:18)
; node # 52 D(-59,-22)->(-60,-23)
       fcb 2 ; drawmode 
       fcb 0,-10 ; starx/y relative to previous node
       fdb 0,-164 ; dx/dy. dx(abs:-18|rel:-164) dy(abs:18|rel:0)
; node # 53 D(-41,-59)->(-41,-60)
       fcb 2 ; drawmode 
       fcb 37,18 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:18|rel:0)
; node # 54 D(-31,-65)->(-23,-65)
       fcb 2 ; drawmode 
       fcb 6,10 ; starx/y relative to previous node
       fdb -18,146 ; dx/dy. dx(abs:146|rel:146) dy(abs:0|rel:-18)
; node # 55 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb -10,40 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:0|rel:-146) dy(abs:0|rel:0)
; node # 56 D(5,-63)->(5,-62)
       fcb 2 ; drawmode 
       fcb 8,-4 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-18|rel:-18)
; node # 57 D(5,-66)->(6,-65)
       fcb 2 ; drawmode 
       fcb 3,0 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:-18|rel:0)
; node # 58 D(17,-64)->(17,-64)
       fcb 2 ; drawmode 
       fcb -2,12 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:18)
; node # 59 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb -9,-8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:0)
; node # 60 D(-41,-59)->(-41,-60)
       fcb 2 ; drawmode 
       fcb 4,-50 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:18|rel:18)
; node # 61 D(-24,-50)->(-29,-50)
       fcb 2 ; drawmode 
       fcb -9,17 ; starx/y relative to previous node
       fdb -18,-91 ; dx/dy. dx(abs:-91|rel:-91) dy(abs:0|rel:-18)
; node # 62 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb 5,33 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:0|rel:91) dy(abs:0|rel:0)
; node # 63 D(39,-38)->(32,-38)
       fcb 2 ; drawmode 
       fcb -17,30 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:0|rel:0)
; node # 64 D(7,-42)->(0,-42)
       fcb 2 ; drawmode 
       fcb 4,-32 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:0)
; node # 65 D(1,-9)->(-7,-9)
       fcb 2 ; drawmode 
       fcb -33,-6 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 66 D(-36,-16)->(-43,-17)
       fcb 2 ; drawmode 
       fcb 7,-37 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:18|rel:18)
; node # 67 D(-41,2)->(-48,2)
       fcb 2 ; drawmode 
       fcb -18,-5 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:-18)
; node # 68 D(-2,8)->(-11,8)
       fcb 2 ; drawmode 
       fcb -6,39 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:0|rel:0)
; node # 69 D(-5,28)->(-12,28)
       fcb 2 ; drawmode 
       fcb -20,-3 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 70 D(-35,24)->(-40,25)
       fcb 2 ; drawmode 
       fcb 4,-30 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:-18|rel:-18)
; node # 71 D(-41,2)->(-48,2)
       fcb 2 ; drawmode 
       fcb 22,-6 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:0|rel:18)
; node # 72 D(-65,0)->(-67,-1)
       fcb 2 ; drawmode 
       fcb 2,-24 ; starx/y relative to previous node
       fdb 18,92 ; dx/dy. dx(abs:-36|rel:92) dy(abs:18|rel:18)
; node # 73 D(-53,25)->(-54,25)
       fcb 2 ; drawmode 
       fcb -25,12 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:0|rel:-18)
; node # 74 D(-45,31)->(-39,31)
       fcb 2 ; drawmode 
       fcb -6,8 ; starx/y relative to previous node
       fdb 0,127 ; dx/dy. dx(abs:109|rel:127) dy(abs:0|rel:0)
; node # 75 M(-5,28)->(-12,28)
       fcb 0 ; drawmode 
       fcb 3,40 ; starx/y relative to previous node
       fdb 0,-237 ; dx/dy. dx(abs:-128|rel:-237) dy(abs:0|rel:0)
; node # 76 D(25,35)->(19,34)
       fcb 2 ; drawmode 
       fcb -7,30 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:18|rel:18)
; node # 77 M(-53,25)->(-54,25)
       fcb 0 ; drawmode 
       fcb 10,-78 ; starx/y relative to previous node
       fdb -18,91 ; dx/dy. dx(abs:-18|rel:91) dy(abs:0|rel:-18)
; node # 78 D(-35,24)->(-40,25)
       fcb 2 ; drawmode 
       fcb 1,18 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-91|rel:-73) dy(abs:-18|rel:-18)
; node # 79 M(-65,0)->(-67,-1)
       fcb 0 ; drawmode 
       fcb 24,-30 ; starx/y relative to previous node
       fdb 36,55 ; dx/dy. dx(abs:-36|rel:55) dy(abs:18|rel:36)
; node # 80 D(-59,-22)->(-60,-23)
       fcb 2 ; drawmode 
       fcb 22,6 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:18|rel:0)
; node # 81 D(-36,-16)->(-43,-17)
       fcb 2 ; drawmode 
       fcb -6,23 ; starx/y relative to previous node
       fdb 0,-110 ; dx/dy. dx(abs:-128|rel:-110) dy(abs:18|rel:0)
; node # 82 D(-24,-50)->(-29,-50)
       fcb 2 ; drawmode 
       fcb 34,12 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:0|rel:-18)
; node # 83 D(7,-42)->(0,-42)
       fcb 2 ; drawmode 
       fcb -8,31 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-128|rel:-37) dy(abs:0|rel:0)
; node # 84 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb 13,2 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:0)
; node # 85 M(5,-63)->(5,-62)
       fcb 0 ; drawmode 
       fcb 8,-4 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:-18|rel:-18)
; node # 86 D(16,-61)->(15,-61)
       fcb 2 ; drawmode 
       fcb -2,11 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:0|rel:18)
; node # 87 D(17,-64)->(17,-64)
       fcb 2 ; drawmode 
       fcb 3,1 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:0)
; node # 88 M(5,-66)->(6,-65)
       fcb 0 ; drawmode 
       fcb 2,-12 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:-18|rel:-18)
; node # 89 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb -11,4 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:18)
; node # 90 D(10,-61)->(21,-60)
       fcb 2 ; drawmode 
       fcb 6,1 ; starx/y relative to previous node
       fdb -18,201 ; dx/dy. dx(abs:201|rel:201) dy(abs:-18|rel:-18)
; node # 91 M(16,-61)->(15,-61)
       fcb 0 ; drawmode 
       fcb 0,6 ; starx/y relative to previous node
       fdb 18,-219 ; dx/dy. dx(abs:-18|rel:-219) dy(abs:0|rel:18)
; node # 92 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb -6,-7 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:0|rel:18) dy(abs:0|rel:0)
; node # 93 M(9,-27)->(1,-27)
       fcb 0 ; drawmode 
       fcb -28,0 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:-146|rel:-146) dy(abs:0|rel:0)
; node # 94 D(8,-25)->(-4,-25)
       fcb 2 ; drawmode 
       fcb -2,-1 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:0|rel:0)
; node # 95 D(6,-13)->(-5,-12)
       fcb 2 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:-18|rel:-18)
; node # 96 D(4,3)->(-5,2)
       fcb 2 ; drawmode 
       fcb -16,-2 ; starx/y relative to previous node
       fdb 36,37 ; dx/dy. dx(abs:-164|rel:37) dy(abs:18|rel:36)
; node # 97 D(-5,1)->(-14,1)
       fcb 2 ; drawmode 
       fcb 2,-9 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:-18)
; node # 98 D(-2,-15)->(-14,-13)
       fcb 2 ; drawmode 
       fcb 16,3 ; starx/y relative to previous node
       fdb -36,-55 ; dx/dy. dx(abs:-219|rel:-55) dy(abs:-36|rel:-36)
; node # 99 D(0,-26)->(-12,-26)
       fcb 2 ; drawmode 
       fcb 11,2 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:0|rel:36)
; node # 100 D(0,-29)->(-8,-29)
       fcb 2 ; drawmode 
       fcb 3,0 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-146|rel:73) dy(abs:0|rel:0)
; node # 101 D(9,-27)->(1,-27)
       fcb 2 ; drawmode 
       fcb -2,9 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 102 D(5,-32)->(-2,-32)
       fcb 2 ; drawmode 
       fcb 5,-4 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 103 D(4,-29)->(-6,-29)
       fcb 2 ; drawmode 
       fcb -3,-1 ; starx/y relative to previous node
       fdb 0,-54 ; dx/dy. dx(abs:-182|rel:-54) dy(abs:0|rel:0)
; node # 104 D(1,-8)->(-11,-9)
       fcb 2 ; drawmode 
       fcb -21,-3 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-219|rel:-37) dy(abs:18|rel:18)
; node # 105 D(-2,8)->(-11,8)
       fcb 2 ; drawmode 
       fcb -16,-3 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-164|rel:55) dy(abs:0|rel:-18)
; node # 106 D(-5,1)->(-14,1)
       fcb 2 ; drawmode 
       fcb 7,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 107 M(-65,0)->(-67,-1)
       fcb 0 ; drawmode 
       fcb 1,-60 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:-36|rel:128) dy(abs:18|rel:18)
; node # 108 D(-57,3)->(-49,3)
       fcb 2 ; drawmode 
       fcb -3,8 ; starx/y relative to previous node
       fdb -18,182 ; dx/dy. dx(abs:146|rel:182) dy(abs:0|rel:-18)
; node # 109 M(-5,1)->(-14,1)
       fcb 0 ; drawmode 
       fcb 2,52 ; starx/y relative to previous node
       fdb 0,-310 ; dx/dy. dx(abs:-164|rel:-310) dy(abs:0|rel:0)
; node # 110 M(0,-26)->(-12,-26)
       fcb 0 ; drawmode 
       fcb 27,5 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-219|rel:-55) dy(abs:0|rel:0)
; node # 111 D(4,-29)->(-6,-29)
       fcb 2 ; drawmode 
       fcb 3,4 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-182|rel:37) dy(abs:0|rel:0)
; node # 112 M(-2,8)->(-11,8)
       fcb 0 ; drawmode 
       fcb -37,-6 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-164|rel:18) dy(abs:0|rel:0)
; node # 113 D(4,3)->(-5,2)
       fcb 2 ; drawmode 
       fcb 5,6 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:18|rel:18)
; node # 114 M(6,-13)->(-5,-12)
       fcb 0 ; drawmode 
       fcb 16,2 ; starx/y relative to previous node
       fdb -36,-37 ; dx/dy. dx(abs:-201|rel:-37) dy(abs:-18|rel:-36)
; node # 115 D(1,-9)->(-11,-9)
       fcb 2 ; drawmode 
       fcb -4,-5 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:0|rel:18)
; node # 116 D(-2,-15)->(-14,-13)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:-36|rel:-36)
; node # 117 D(6,-13)->(-5,-12)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:-18|rel:18)
; node # 118 M(0,-26)->(-12,-26)
       fcb 0 ; drawmode 
       fcb 13,-6 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:0|rel:18)
; node # 119 D(8,-25)->(-4,-25)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:0|rel:0)
; node # 120 M(8,-25)->(-4,-25)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:0|rel:0)
; node # 121 D(4,-29)->(-6,-29)
       fcb 2 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-182|rel:37) dy(abs:0|rel:0)
; node # 122 M(0,-29)->(-8,-29)
       fcb 0 ; drawmode 
       fcb 0,-4 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-146|rel:36) dy(abs:0|rel:0)
; node # 123 D(5,-32)->(-2,-32)
       fcb 2 ; drawmode 
       fcb 3,5 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
       fcb  1  ; end of anim
; Animation 15
teapotBframe15:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-49,3)->(-37,4)
       fcb 0 ; drawmode 
       fcb -3,-49 ; starx/y relative to previous node
       fdb -18,219 ; dx/dy. dx(abs:219|rel:219) dy(abs:-18|rel:-18)
; node # 1 D(12,14)->(26,13)
       fcb 2 ; drawmode 
       fcb -11,61 ; starx/y relative to previous node
       fdb 36,37 ; dx/dy. dx(abs:256|rel:37) dy(abs:18|rel:36)
; node # 2 D(2,40)->(13,39)
       fcb 2 ; drawmode 
       fcb -26,-10 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:201|rel:-55) dy(abs:18|rel:0)
; node # 3 D(-39,31)->(-30,32)
       fcb 2 ; drawmode 
       fcb 9,-41 ; starx/y relative to previous node
       fdb -36,-37 ; dx/dy. dx(abs:164|rel:-37) dy(abs:-18|rel:-36)
; node # 4 D(-49,3)->(-37,4)
       fcb 2 ; drawmode 
       fcb 28,-10 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:219|rel:55) dy(abs:-18|rel:0)
; node # 5 D(-41,-23)->(-30,-23)
       fcb 2 ; drawmode 
       fcb 26,8 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:0|rel:18)
; node # 6 D(16,-14)->(29,-14)
       fcb 2 ; drawmode 
       fcb -9,57 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:237|rel:36) dy(abs:0|rel:0)
; node # 7 D(21,-60)->(30,-59)
       fcb 2 ; drawmode 
       fcb 46,5 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:164|rel:-73) dy(abs:-18|rel:-18)
; node # 8 D(55,-49)->(57,-47)
       fcb 2 ; drawmode 
       fcb -11,34 ; starx/y relative to previous node
       fdb -18,-128 ; dx/dy. dx(abs:36|rel:-128) dy(abs:-36|rel:-18)
; node # 9 D(55,-39)->(51,-38)
       fcb 2 ; drawmode 
       fcb -10,0 ; starx/y relative to previous node
       fdb 18,-109 ; dx/dy. dx(abs:-73|rel:-109) dy(abs:-18|rel:18)
; node # 10 D(60,0)->(54,0)
       fcb 2 ; drawmode 
       fcb -39,5 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:0|rel:18)
; node # 11 D(59,22)->(53,20)
       fcb 2 ; drawmode 
       fcb -22,-1 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:36|rel:36)
; node # 12 D(40,40)->(36,39)
       fcb 2 ; drawmode 
       fcb -18,-19 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:18|rel:-18)
; node # 13 D(19,34)->(12,33)
       fcb 2 ; drawmode 
       fcb 6,-21 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:18|rel:0)
; node # 14 D(29,15)->(20,16)
       fcb 2 ; drawmode 
       fcb 19,10 ; starx/y relative to previous node
       fdb -36,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:-18|rel:-36)
; node # 15 D(31,-3)->(23,-3)
       fcb 2 ; drawmode 
       fcb 18,2 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:18)
; node # 16 D(60,0)->(54,0)
       fcb 2 ; drawmode 
       fcb -3,29 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:0)
; node # 17 D(58,-4)->(64,-4)
       fcb 2 ; drawmode 
       fcb 4,-2 ; starx/y relative to previous node
       fdb 0,218 ; dx/dy. dx(abs:109|rel:218) dy(abs:0|rel:0)
; node # 18 D(55,-49)->(57,-47)
       fcb 2 ; drawmode 
       fcb 45,-3 ; starx/y relative to previous node
       fdb -36,-73 ; dx/dy. dx(abs:36|rel:-73) dy(abs:-36|rel:-36)
; node # 19 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb 6,-46 ; starx/y relative to previous node
       fdb 36,-36 ; dx/dy. dx(abs:0|rel:-36) dy(abs:0|rel:36)
; node # 20 D(55,-39)->(51,-38)
       fcb 2 ; drawmode 
       fcb -16,46 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-73|rel:-73) dy(abs:-18|rel:-18)
; node # 21 D(32,-38)->(25,-37)
       fcb 2 ; drawmode 
       fcb -1,-23 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:-18|rel:0)
; node # 22 D(31,-3)->(23,-3)
       fcb 2 ; drawmode 
       fcb -35,-1 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:18)
; node # 23 D(-7,-9)->(-16,-9)
       fcb 2 ; drawmode 
       fcb 6,-38 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 24 D(-11,8)->(-20,9)
       fcb 2 ; drawmode 
       fcb -17,-4 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:-18|rel:-18)
; node # 25 D(29,15)->(20,16)
       fcb 2 ; drawmode 
       fcb -7,40 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:-18|rel:0)
; node # 26 D(59,22)->(53,20)
       fcb 2 ; drawmode 
       fcb -7,30 ; starx/y relative to previous node
       fdb 54,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:36|rel:54)
; node # 27 D(57,22)->(63,21)
       fcb 2 ; drawmode 
       fcb 0,-2 ; starx/y relative to previous node
       fdb -18,218 ; dx/dy. dx(abs:109|rel:218) dy(abs:18|rel:-18)
; node # 28 D(58,-4)->(64,-4)
       fcb 2 ; drawmode 
       fcb 26,1 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:109|rel:0) dy(abs:0|rel:-18)
; node # 29 D(16,-14)->(29,-14)
       fcb 2 ; drawmode 
       fcb 10,-42 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:237|rel:128) dy(abs:0|rel:0)
; node # 30 D(12,14)->(26,13)
       fcb 2 ; drawmode 
       fcb -28,-4 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:256|rel:19) dy(abs:18|rel:18)
; node # 31 D(57,22)->(63,21)
       fcb 2 ; drawmode 
       fcb -8,45 ; starx/y relative to previous node
       fdb 0,-147 ; dx/dy. dx(abs:109|rel:-147) dy(abs:18|rel:0)
; node # 32 D(36,43)->(41,42)
       fcb 2 ; drawmode 
       fcb -21,-21 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:91|rel:-18) dy(abs:18|rel:0)
; node # 33 D(2,40)->(13,39)
       fcb 2 ; drawmode 
       fcb 3,-34 ; starx/y relative to previous node
       fdb 0,110 ; dx/dy. dx(abs:201|rel:110) dy(abs:18|rel:0)
; node # 34 M(40,40)->(36,39)
       fcb 0 ; drawmode 
       fcb 0,38 ; starx/y relative to previous node
       fdb 0,-274 ; dx/dy. dx(abs:-73|rel:-274) dy(abs:18|rel:0)
; node # 35 D(36,43)->(41,42)
       fcb 2 ; drawmode 
       fcb -3,-4 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:91|rel:164) dy(abs:18|rel:0)
; node # 36 M(12,14)->(26,13)
       fcb 0 ; drawmode 
       fcb 29,-24 ; starx/y relative to previous node
       fdb 0,165 ; dx/dy. dx(abs:256|rel:165) dy(abs:18|rel:0)
; node # 37 D(26,-32)->(47,-32)
       fcb 2 ; drawmode 
       fcb 46,14 ; starx/y relative to previous node
       fdb -18,128 ; dx/dy. dx(abs:384|rel:128) dy(abs:0|rel:-18)
; node # 38 D(41,-62)->(67,-60)
       fcb 2 ; drawmode 
       fcb 30,15 ; starx/y relative to previous node
       fdb -36,91 ; dx/dy. dx(abs:475|rel:91) dy(abs:-36|rel:-36)
; node # 39 D(26,-59)->(49,-59)
       fcb 2 ; drawmode 
       fcb -3,-15 ; starx/y relative to previous node
       fdb 36,-55 ; dx/dy. dx(abs:420|rel:-55) dy(abs:0|rel:36)
; node # 40 D(9,-21)->(22,-21)
       fcb 2 ; drawmode 
       fcb -38,-17 ; starx/y relative to previous node
       fdb 0,-183 ; dx/dy. dx(abs:237|rel:-183) dy(abs:0|rel:0)
; node # 41 D(12,14)->(26,13)
       fcb 2 ; drawmode 
       fcb -35,3 ; starx/y relative to previous node
       fdb 18,19 ; dx/dy. dx(abs:256|rel:19) dy(abs:18|rel:18)
; node # 42 D(22,-18)->(34,-18)
       fcb 2 ; drawmode 
       fcb 32,10 ; starx/y relative to previous node
       fdb -18,-37 ; dx/dy. dx(abs:219|rel:-37) dy(abs:0|rel:-18)
; node # 43 D(9,-21)->(22,-21)
       fcb 2 ; drawmode 
       fcb 3,-13 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:237|rel:18) dy(abs:0|rel:0)
; node # 44 M(42,-56)->(63,-54)
       fcb 0 ; drawmode 
       fcb 35,33 ; starx/y relative to previous node
       fdb -36,147 ; dx/dy. dx(abs:384|rel:147) dy(abs:-36|rel:-36)
; node # 45 D(26,-59)->(49,-59)
       fcb 2 ; drawmode 
       fcb 3,-16 ; starx/y relative to previous node
       fdb 36,36 ; dx/dy. dx(abs:420|rel:36) dy(abs:0|rel:36)
; node # 46 M(41,-62)->(67,-60)
       fcb 0 ; drawmode 
       fcb 3,15 ; starx/y relative to previous node
       fdb -36,55 ; dx/dy. dx(abs:475|rel:55) dy(abs:-36|rel:-36)
; node # 47 D(42,-56)->(63,-54)
       fcb 2 ; drawmode 
       fcb -6,1 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:384|rel:-91) dy(abs:-36|rel:0)
; node # 48 D(22,-18)->(34,-18)
       fcb 2 ; drawmode 
       fcb -38,-20 ; starx/y relative to previous node
       fdb 36,-165 ; dx/dy. dx(abs:219|rel:-165) dy(abs:0|rel:36)
; node # 49 M(21,-60)->(30,-59)
       fcb 0 ; drawmode 
       fcb 42,-1 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:164|rel:-55) dy(abs:-18|rel:-18)
; node # 50 D(-23,-65)->(-15,-66)
       fcb 2 ; drawmode 
       fcb 5,-44 ; starx/y relative to previous node
       fdb 36,-18 ; dx/dy. dx(abs:146|rel:-18) dy(abs:18|rel:36)
; node # 51 D(-41,-23)->(-30,-23)
       fcb 2 ; drawmode 
       fcb -42,-18 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:201|rel:55) dy(abs:0|rel:-18)
; node # 52 D(-60,-23)->(-59,-24)
       fcb 2 ; drawmode 
       fcb 0,-19 ; starx/y relative to previous node
       fdb 18,-183 ; dx/dy. dx(abs:18|rel:-183) dy(abs:18|rel:18)
; node # 53 D(-41,-60)->(-40,-61)
       fcb 2 ; drawmode 
       fcb 37,19 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:18|rel:0)
; node # 54 D(-23,-65)->(-15,-66)
       fcb 2 ; drawmode 
       fcb 5,18 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:146|rel:128) dy(abs:18|rel:0)
; node # 55 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb -10,32 ; starx/y relative to previous node
       fdb -18,-146 ; dx/dy. dx(abs:0|rel:-146) dy(abs:0|rel:-18)
; node # 56 D(5,-62)->(3,-63)
       fcb 2 ; drawmode 
       fcb 7,-4 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:18|rel:18)
; node # 57 D(6,-65)->(7,-65)
       fcb 2 ; drawmode 
       fcb 3,1 ; starx/y relative to previous node
       fdb -18,54 ; dx/dy. dx(abs:18|rel:54) dy(abs:0|rel:-18)
; node # 58 D(17,-64)->(17,-62)
       fcb 2 ; drawmode 
       fcb -1,11 ; starx/y relative to previous node
       fdb -36,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:-36|rel:-36)
; node # 59 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb -9,-8 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:0|rel:0) dy(abs:0|rel:36)
; node # 60 D(-41,-60)->(-40,-61)
       fcb 2 ; drawmode 
       fcb 5,-50 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:18|rel:18)
; node # 61 D(-29,-50)->(-34,-51)
       fcb 2 ; drawmode 
       fcb -10,12 ; starx/y relative to previous node
       fdb 0,-109 ; dx/dy. dx(abs:-91|rel:-109) dy(abs:18|rel:0)
; node # 62 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb 5,38 ; starx/y relative to previous node
       fdb -18,91 ; dx/dy. dx(abs:0|rel:91) dy(abs:0|rel:-18)
; node # 63 D(32,-38)->(25,-37)
       fcb 2 ; drawmode 
       fcb -17,23 ; starx/y relative to previous node
       fdb -18,-128 ; dx/dy. dx(abs:-128|rel:-128) dy(abs:-18|rel:-18)
; node # 64 D(0,-42)->(-8,-42)
       fcb 2 ; drawmode 
       fcb 4,-32 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:18)
; node # 65 D(-7,-9)->(-16,-9)
       fcb 2 ; drawmode 
       fcb -33,-7 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 66 D(-43,-17)->(-50,-17)
       fcb 2 ; drawmode 
       fcb 8,-36 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:0)
; node # 67 D(-48,2)->(-55,2)
       fcb 2 ; drawmode 
       fcb -19,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:0)
; node # 68 D(-11,8)->(-20,9)
       fcb 2 ; drawmode 
       fcb -6,37 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-164|rel:-36) dy(abs:-18|rel:-18)
; node # 69 D(-12,28)->(-19,28)
       fcb 2 ; drawmode 
       fcb -20,-1 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:0|rel:18)
; node # 70 D(-40,25)->(-46,25)
       fcb 2 ; drawmode 
       fcb 3,-28 ; starx/y relative to previous node
       fdb 0,19 ; dx/dy. dx(abs:-109|rel:19) dy(abs:0|rel:0)
; node # 71 D(-48,2)->(-55,2)
       fcb 2 ; drawmode 
       fcb 23,-8 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:0)
; node # 72 D(-67,-1)->(-67,-1)
       fcb 2 ; drawmode 
       fcb 3,-19 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:0|rel:128) dy(abs:0|rel:0)
; node # 73 D(-54,25)->(-53,26)
       fcb 2 ; drawmode 
       fcb -26,13 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:-18|rel:-18)
; node # 74 D(-39,31)->(-30,32)
       fcb 2 ; drawmode 
       fcb -6,15 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:164|rel:146) dy(abs:-18|rel:0)
; node # 75 M(-12,28)->(-19,28)
       fcb 0 ; drawmode 
       fcb 3,27 ; starx/y relative to previous node
       fdb 18,-292 ; dx/dy. dx(abs:-128|rel:-292) dy(abs:0|rel:18)
; node # 76 D(19,34)->(12,33)
       fcb 2 ; drawmode 
       fcb -6,31 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:18|rel:18)
; node # 77 M(-54,25)->(-53,26)
       fcb 0 ; drawmode 
       fcb 9,-73 ; starx/y relative to previous node
       fdb -36,146 ; dx/dy. dx(abs:18|rel:146) dy(abs:-18|rel:-36)
; node # 78 D(-40,25)->(-46,25)
       fcb 2 ; drawmode 
       fcb 0,14 ; starx/y relative to previous node
       fdb 18,-127 ; dx/dy. dx(abs:-109|rel:-127) dy(abs:0|rel:18)
; node # 79 M(-67,-1)->(-67,-1)
       fcb 0 ; drawmode 
       fcb 26,-27 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:0|rel:0)
; node # 80 D(-60,-23)->(-59,-24)
       fcb 2 ; drawmode 
       fcb 22,7 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:18|rel:18)
; node # 81 D(-43,-17)->(-50,-17)
       fcb 2 ; drawmode 
       fcb -6,17 ; starx/y relative to previous node
       fdb -18,-146 ; dx/dy. dx(abs:-128|rel:-146) dy(abs:0|rel:-18)
; node # 82 D(-29,-50)->(-34,-51)
       fcb 2 ; drawmode 
       fcb 33,14 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-91|rel:37) dy(abs:18|rel:18)
; node # 83 D(0,-42)->(-8,-42)
       fcb 2 ; drawmode 
       fcb -8,29 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-146|rel:-55) dy(abs:0|rel:-18)
; node # 84 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb 13,9 ; starx/y relative to previous node
       fdb 0,146 ; dx/dy. dx(abs:0|rel:146) dy(abs:0|rel:0)
; node # 85 M(5,-62)->(3,-63)
       fcb 0 ; drawmode 
       fcb 7,-4 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:18|rel:18)
; node # 86 D(15,-61)->(13,-60)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:-36|rel:0) dy(abs:-18|rel:-36)
; node # 87 D(17,-64)->(17,-62)
       fcb 2 ; drawmode 
       fcb 3,2 ; starx/y relative to previous node
       fdb -18,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:-36|rel:-18)
; node # 88 M(6,-65)->(7,-65)
       fcb 0 ; drawmode 
       fcb 1,-11 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:0|rel:36)
; node # 89 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb -10,3 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:0)
; node # 90 D(21,-60)->(30,-59)
       fcb 2 ; drawmode 
       fcb 5,12 ; starx/y relative to previous node
       fdb -18,164 ; dx/dy. dx(abs:164|rel:164) dy(abs:-18|rel:-18)
; node # 91 M(15,-61)->(13,-60)
       fcb 0 ; drawmode 
       fcb 1,-6 ; starx/y relative to previous node
       fdb 0,-200 ; dx/dy. dx(abs:-36|rel:-200) dy(abs:-18|rel:0)
; node # 92 D(9,-55)->(9,-55)
       fcb 2 ; drawmode 
       fcb -6,-6 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:18)
; node # 93 M(1,-27)->(-7,-27)
       fcb 0 ; drawmode 
       fcb -28,-8 ; starx/y relative to previous node
       fdb 0,-146 ; dx/dy. dx(abs:-146|rel:-146) dy(abs:0|rel:0)
; node # 94 D(-4,-25)->(-15,-24)
       fcb 2 ; drawmode 
       fcb -2,-5 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-201|rel:-55) dy(abs:-18|rel:-18)
; node # 95 D(-5,-12)->(-17,-12)
       fcb 2 ; drawmode 
       fcb -13,-1 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:0|rel:18)
; node # 96 D(-5,2)->(-14,2)
       fcb 2 ; drawmode 
       fcb -14,0 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-164|rel:55) dy(abs:0|rel:0)
; node # 97 D(-14,1)->(-23,2)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:-18|rel:-18)
; node # 98 D(-14,-13)->(-25,-14)
       fcb 2 ; drawmode 
       fcb 14,0 ; starx/y relative to previous node
       fdb 36,-37 ; dx/dy. dx(abs:-201|rel:-37) dy(abs:18|rel:36)
; node # 99 D(-12,-26)->(-23,-26)
       fcb 2 ; drawmode 
       fcb 13,2 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:0|rel:-18)
; node # 100 D(-8,-29)->(-20,-29)
       fcb 2 ; drawmode 
       fcb 3,4 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:0|rel:0)
; node # 101 D(1,-27)->(-7,-27)
       fcb 2 ; drawmode 
       fcb -2,9 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-146|rel:73) dy(abs:0|rel:0)
; node # 102 D(-2,-32)->(-10,-33)
       fcb 2 ; drawmode 
       fcb 5,-3 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:18|rel:18)
; node # 103 D(-8,-29)->(-20,-29)
       fcb 2 ; drawmode 
       fcb -3,-6 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:0|rel:-18)
; node # 104 D(-11,-9)->(-23,-9)
       fcb 2 ; drawmode 
       fcb -20,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:0|rel:0)
; node # 105 D(-11,8)->(-20,9)
       fcb 2 ; drawmode 
       fcb -17,0 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-164|rel:55) dy(abs:-18|rel:-18)
; node # 106 D(-14,1)->(-23,2)
       fcb 2 ; drawmode 
       fcb 7,-3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:-18|rel:0)
; node # 107 M(-67,-1)->(-67,-1)
       fcb 0 ; drawmode 
       fcb 2,-53 ; starx/y relative to previous node
       fdb 18,164 ; dx/dy. dx(abs:0|rel:164) dy(abs:0|rel:18)
; node # 108 D(-49,3)->(-37,4)
       fcb 2 ; drawmode 
       fcb -4,18 ; starx/y relative to previous node
       fdb -18,219 ; dx/dy. dx(abs:219|rel:219) dy(abs:-18|rel:-18)
; node # 109 M(-14,1)->(-23,2)
       fcb 0 ; drawmode 
       fcb 2,35 ; starx/y relative to previous node
       fdb 0,-383 ; dx/dy. dx(abs:-164|rel:-383) dy(abs:-18|rel:0)
; node # 110 M(-12,-26)->(-23,-26)
       fcb 0 ; drawmode 
       fcb 27,2 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-201|rel:-37) dy(abs:0|rel:18)
; node # 111 D(-8,-29)->(-14,-29)
       fcb 2 ; drawmode 
       fcb 3,4 ; starx/y relative to previous node
       fdb 0,92 ; dx/dy. dx(abs:-109|rel:92) dy(abs:0|rel:0)
; node # 112 M(-11,8)->(-20,9)
       fcb 0 ; drawmode 
       fcb -37,-3 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:-18|rel:-18)
; node # 113 D(-5,2)->(-14,2)
       fcb 2 ; drawmode 
       fcb 6,6 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:18)
; node # 114 M(-5,-12)->(-17,-12)
       fcb 0 ; drawmode 
       fcb 14,0 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-219|rel:-55) dy(abs:0|rel:0)
; node # 115 D(-11,-9)->(-23,-9)
       fcb 2 ; drawmode 
       fcb -3,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:0|rel:0)
; node # 116 D(-14,-13)->(-25,-14)
       fcb 2 ; drawmode 
       fcb 4,-3 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:18|rel:18)
; node # 117 D(-5,-12)->(-17,-12)
       fcb 2 ; drawmode 
       fcb -1,9 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:0|rel:-18)
; node # 118 M(-12,-26)->(-23,-26)
       fcb 0 ; drawmode 
       fcb 14,-7 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:0|rel:0)
; node # 119 D(-4,-25)->(-15,-24)
       fcb 2 ; drawmode 
       fcb -1,8 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:-18|rel:-18)
; node # 120 M(-4,-25)->(-15,-24)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:-18|rel:0)
; node # 121 D(-8,-29)->(-20,-29)
       fcb 2 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:0|rel:18)
; node # 122 M(-8,-29)->(-14,-29)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,110 ; dx/dy. dx(abs:-109|rel:110) dy(abs:0|rel:0)
; node # 123 D(-2,-32)->(-10,-33)
       fcb 2 ; drawmode 
       fcb 3,6 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:18|rel:18)
       fcb  1  ; end of anim
; Animation 16
teapotBframe16:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-37,4)->(-23,4)
       fcb 0 ; drawmode 
       fcb -4,-37 ; starx/y relative to previous node
       fdb 0,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:0|rel:0)
; node # 1 D(26,13)->(38,13)
       fcb 2 ; drawmode 
       fcb -9,63 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:219|rel:-37) dy(abs:0|rel:0)
; node # 2 D(13,39)->(22,39)
       fcb 2 ; drawmode 
       fcb -26,-13 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:164|rel:-55) dy(abs:0|rel:0)
; node # 3 D(-30,32)->(-21,33)
       fcb 2 ; drawmode 
       fcb 7,-43 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:164|rel:0) dy(abs:-18|rel:-18)
; node # 4 D(-37,4)->(-23,4)
       fcb 2 ; drawmode 
       fcb 28,-7 ; starx/y relative to previous node
       fdb 18,92 ; dx/dy. dx(abs:256|rel:92) dy(abs:0|rel:18)
; node # 5 D(-30,-23)->(-18,-24)
       fcb 2 ; drawmode 
       fcb 27,7 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:219|rel:-37) dy(abs:18|rel:18)
; node # 6 D(29,-14)->(40,-14)
       fcb 2 ; drawmode 
       fcb -9,59 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:201|rel:-18) dy(abs:0|rel:-18)
; node # 7 D(30,-59)->(38,-58)
       fcb 2 ; drawmode 
       fcb 45,1 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:146|rel:-55) dy(abs:-18|rel:-18)
; node # 8 D(57,-47)->(58,-45)
       fcb 2 ; drawmode 
       fcb -12,27 ; starx/y relative to previous node
       fdb -18,-128 ; dx/dy. dx(abs:18|rel:-128) dy(abs:-36|rel:-18)
; node # 9 D(51,-38)->(45,-37)
       fcb 2 ; drawmode 
       fcb -9,-6 ; starx/y relative to previous node
       fdb 18,-127 ; dx/dy. dx(abs:-109|rel:-127) dy(abs:-18|rel:18)
; node # 10 D(54,0)->(49,0)
       fcb 2 ; drawmode 
       fcb -38,3 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-91|rel:18) dy(abs:0|rel:18)
; node # 11 D(53,20)->(47,20)
       fcb 2 ; drawmode 
       fcb -20,-1 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:0|rel:0)
; node # 12 D(36,39)->(33,38)
       fcb 2 ; drawmode 
       fcb -19,-17 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-54|rel:55) dy(abs:18|rel:18)
; node # 13 D(12,33)->(6,33)
       fcb 2 ; drawmode 
       fcb 6,-24 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-109|rel:-55) dy(abs:0|rel:-18)
; node # 14 D(20,16)->(12,15)
       fcb 2 ; drawmode 
       fcb 17,8 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:18|rel:18)
; node # 15 D(23,-3)->(14,-3)
       fcb 2 ; drawmode 
       fcb 19,3 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:-18)
; node # 16 D(54,0)->(49,0)
       fcb 2 ; drawmode 
       fcb -3,31 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-91|rel:73) dy(abs:0|rel:0)
; node # 17 D(64,-4)->(65,-4)
       fcb 2 ; drawmode 
       fcb 4,10 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:18|rel:109) dy(abs:0|rel:0)
; node # 18 D(57,-47)->(58,-45)
       fcb 2 ; drawmode 
       fcb 43,-7 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:18|rel:0) dy(abs:-36|rel:-36)
; node # 19 D(9,-55)->(8,-54)
       fcb 2 ; drawmode 
       fcb 8,-48 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:-18|rel:18)
; node # 20 D(51,-38)->(45,-37)
       fcb 2 ; drawmode 
       fcb -17,42 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:-109|rel:-91) dy(abs:-18|rel:0)
; node # 21 D(25,-37)->(17,-36)
       fcb 2 ; drawmode 
       fcb -1,-26 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:-18|rel:0)
; node # 22 D(23,-3)->(14,-3)
       fcb 2 ; drawmode 
       fcb -34,-2 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:18)
; node # 23 D(-16,-9)->(-24,-9)
       fcb 2 ; drawmode 
       fcb 6,-39 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 24 D(-20,9)->(-28,9)
       fcb 2 ; drawmode 
       fcb -18,-4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 25 D(20,16)->(12,15)
       fcb 2 ; drawmode 
       fcb -7,40 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:18|rel:18)
; node # 26 D(53,20)->(47,20)
       fcb 2 ; drawmode 
       fcb -4,33 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:0|rel:-18)
; node # 27 D(63,21)->(65,20)
       fcb 2 ; drawmode 
       fcb -1,10 ; starx/y relative to previous node
       fdb 18,145 ; dx/dy. dx(abs:36|rel:145) dy(abs:18|rel:18)
; node # 28 D(64,-4)->(65,-4)
       fcb 2 ; drawmode 
       fcb 25,1 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:18|rel:-18) dy(abs:0|rel:-18)
; node # 29 D(29,-14)->(40,-14)
       fcb 2 ; drawmode 
       fcb 10,-35 ; starx/y relative to previous node
       fdb 0,183 ; dx/dy. dx(abs:201|rel:183) dy(abs:0|rel:0)
; node # 30 D(26,13)->(38,13)
       fcb 2 ; drawmode 
       fcb -27,-3 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:219|rel:18) dy(abs:0|rel:0)
; node # 31 D(63,21)->(65,20)
       fcb 2 ; drawmode 
       fcb -8,37 ; starx/y relative to previous node
       fdb 18,-183 ; dx/dy. dx(abs:36|rel:-183) dy(abs:18|rel:18)
; node # 32 D(41,42)->(43,41)
       fcb 2 ; drawmode 
       fcb -21,-22 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:18|rel:0)
; node # 33 D(13,39)->(22,39)
       fcb 2 ; drawmode 
       fcb 3,-28 ; starx/y relative to previous node
       fdb -18,128 ; dx/dy. dx(abs:164|rel:128) dy(abs:0|rel:-18)
; node # 34 M(36,39)->(33,38)
       fcb 0 ; drawmode 
       fcb 0,23 ; starx/y relative to previous node
       fdb 18,-218 ; dx/dy. dx(abs:-54|rel:-218) dy(abs:18|rel:18)
; node # 35 D(41,42)->(43,41)
       fcb 2 ; drawmode 
       fcb -3,5 ; starx/y relative to previous node
       fdb 0,90 ; dx/dy. dx(abs:36|rel:90) dy(abs:18|rel:0)
; node # 36 M(26,13)->(38,13)
       fcb 0 ; drawmode 
       fcb 29,-15 ; starx/y relative to previous node
       fdb -18,183 ; dx/dy. dx(abs:219|rel:183) dy(abs:0|rel:-18)
; node # 37 D(47,-32)->(62,-29)
       fcb 2 ; drawmode 
       fcb 45,21 ; starx/y relative to previous node
       fdb -54,55 ; dx/dy. dx(abs:274|rel:55) dy(abs:-54|rel:-54)
; node # 38 D(67,-60)->(89,-57)
       fcb 2 ; drawmode 
       fcb 28,20 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:402|rel:128) dy(abs:-54|rel:0)
; node # 39 D(49,-59)->(68,-56)
       fcb 2 ; drawmode 
       fcb -1,-18 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:347|rel:-55) dy(abs:-54|rel:0)
; node # 40 D(22,-21)->(32,-20)
       fcb 2 ; drawmode 
       fcb -38,-27 ; starx/y relative to previous node
       fdb 36,-165 ; dx/dy. dx(abs:182|rel:-165) dy(abs:-18|rel:36)
; node # 41 D(26,13)->(38,13)
       fcb 2 ; drawmode 
       fcb -34,4 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:219|rel:37) dy(abs:0|rel:18)
; node # 42 D(34,-18)->(44,-18)
       fcb 2 ; drawmode 
       fcb 31,8 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:182|rel:-37) dy(abs:0|rel:0)
; node # 43 D(22,-21)->(32,-20)
       fcb 2 ; drawmode 
       fcb 3,-12 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:182|rel:0) dy(abs:-18|rel:-18)
; node # 44 M(63,-54)->(79,-52)
       fcb 0 ; drawmode 
       fcb 33,41 ; starx/y relative to previous node
       fdb -18,110 ; dx/dy. dx(abs:292|rel:110) dy(abs:-36|rel:-18)
; node # 45 D(49,-59)->(68,-56)
       fcb 2 ; drawmode 
       fcb 5,-14 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:347|rel:55) dy(abs:-54|rel:-18)
; node # 46 M(67,-60)->(89,-57)
       fcb 0 ; drawmode 
       fcb 1,18 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:402|rel:55) dy(abs:-54|rel:0)
; node # 47 D(63,-54)->(79,-52)
       fcb 2 ; drawmode 
       fcb -6,-4 ; starx/y relative to previous node
       fdb 18,-110 ; dx/dy. dx(abs:292|rel:-110) dy(abs:-36|rel:18)
; node # 48 D(34,-18)->(44,-18)
       fcb 2 ; drawmode 
       fcb -36,-29 ; starx/y relative to previous node
       fdb 36,-110 ; dx/dy. dx(abs:182|rel:-110) dy(abs:0|rel:36)
; node # 49 M(30,-59)->(38,-58)
       fcb 0 ; drawmode 
       fcb 41,-4 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:146|rel:-36) dy(abs:-18|rel:-18)
; node # 50 D(-15,-66)->(-6,-66)
       fcb 2 ; drawmode 
       fcb 7,-45 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:164|rel:18) dy(abs:0|rel:18)
; node # 51 D(-30,-23)->(-18,-24)
       fcb 2 ; drawmode 
       fcb -43,-15 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:219|rel:55) dy(abs:18|rel:18)
; node # 52 D(-59,-24)->(-57,-24)
       fcb 2 ; drawmode 
       fcb 1,-29 ; starx/y relative to previous node
       fdb -18,-183 ; dx/dy. dx(abs:36|rel:-183) dy(abs:0|rel:-18)
; node # 53 D(-40,-61)->(-38,-63)
       fcb 2 ; drawmode 
       fcb 37,19 ; starx/y relative to previous node
       fdb 36,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:36|rel:36)
; node # 54 D(-15,-66)->(-6,-66)
       fcb 2 ; drawmode 
       fcb 5,25 ; starx/y relative to previous node
       fdb -36,128 ; dx/dy. dx(abs:164|rel:128) dy(abs:0|rel:-36)
; node # 55 D(9,-55)->(8,-54)
       fcb 2 ; drawmode 
       fcb -11,24 ; starx/y relative to previous node
       fdb -18,-182 ; dx/dy. dx(abs:-18|rel:-182) dy(abs:-18|rel:-18)
; node # 56 D(3,-63)->(2,-63)
       fcb 2 ; drawmode 
       fcb 8,-6 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:0|rel:18)
; node # 57 D(7,-65)->(8,-65)
       fcb 2 ; drawmode 
       fcb 2,4 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:18|rel:36) dy(abs:0|rel:0)
; node # 58 D(17,-62)->(17,-62)
       fcb 2 ; drawmode 
       fcb -3,10 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:0|rel:-18) dy(abs:0|rel:0)
; node # 59 D(9,-55)->(8,-54)
       fcb 2 ; drawmode 
       fcb -7,-8 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:-18|rel:-18)
; node # 60 D(-40,-61)->(-38,-63)
       fcb 2 ; drawmode 
       fcb 6,-49 ; starx/y relative to previous node
       fdb 54,54 ; dx/dy. dx(abs:36|rel:54) dy(abs:36|rel:54)
; node # 61 D(-34,-51)->(-38,-53)
       fcb 2 ; drawmode 
       fcb -10,6 ; starx/y relative to previous node
       fdb 0,-109 ; dx/dy. dx(abs:-73|rel:-109) dy(abs:36|rel:0)
; node # 62 D(9,-55)->(8,-54)
       fcb 2 ; drawmode 
       fcb 4,43 ; starx/y relative to previous node
       fdb -54,55 ; dx/dy. dx(abs:-18|rel:55) dy(abs:-18|rel:-54)
; node # 63 D(25,-37)->(17,-36)
       fcb 2 ; drawmode 
       fcb -18,16 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-146|rel:-128) dy(abs:-18|rel:0)
; node # 64 D(-8,-42)->(-15,-42)
       fcb 2 ; drawmode 
       fcb 5,-33 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:18)
; node # 65 D(-16,-9)->(-24,-9)
       fcb 2 ; drawmode 
       fcb -33,-8 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 66 D(-50,-17)->(-55,-18)
       fcb 2 ; drawmode 
       fcb 8,-34 ; starx/y relative to previous node
       fdb 18,55 ; dx/dy. dx(abs:-91|rel:55) dy(abs:18|rel:18)
; node # 67 D(-55,2)->(-61,2)
       fcb 2 ; drawmode 
       fcb -19,-5 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-109|rel:-18) dy(abs:0|rel:-18)
; node # 68 D(-20,9)->(-28,9)
       fcb 2 ; drawmode 
       fcb -7,35 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:0)
; node # 69 D(-19,28)->(-25,29)
       fcb 2 ; drawmode 
       fcb -19,1 ; starx/y relative to previous node
       fdb -18,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:-18|rel:-18)
; node # 70 D(-46,25)->(-50,25)
       fcb 2 ; drawmode 
       fcb 3,-27 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:0|rel:18)
; node # 71 D(-55,2)->(-61,2)
       fcb 2 ; drawmode 
       fcb 23,-9 ; starx/y relative to previous node
       fdb 0,-36 ; dx/dy. dx(abs:-109|rel:-36) dy(abs:0|rel:0)
; node # 72 D(-67,-1)->(-65,-1)
       fcb 2 ; drawmode 
       fcb 3,-12 ; starx/y relative to previous node
       fdb 0,145 ; dx/dy. dx(abs:36|rel:145) dy(abs:0|rel:0)
; node # 73 D(-53,26)->(-50,27)
       fcb 2 ; drawmode 
       fcb -27,14 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:54|rel:18) dy(abs:-18|rel:-18)
; node # 74 D(-30,32)->(-21,33)
       fcb 2 ; drawmode 
       fcb -6,23 ; starx/y relative to previous node
       fdb 0,110 ; dx/dy. dx(abs:164|rel:110) dy(abs:-18|rel:0)
; node # 75 M(-19,28)->(-25,29)
       fcb 0 ; drawmode 
       fcb 4,11 ; starx/y relative to previous node
       fdb 0,-273 ; dx/dy. dx(abs:-109|rel:-273) dy(abs:-18|rel:0)
; node # 76 D(12,33)->(6,33)
       fcb 2 ; drawmode 
       fcb -5,31 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-109|rel:0) dy(abs:0|rel:18)
; node # 77 M(-53,26)->(-50,27)
       fcb 0 ; drawmode 
       fcb 7,-65 ; starx/y relative to previous node
       fdb -18,163 ; dx/dy. dx(abs:54|rel:163) dy(abs:-18|rel:-18)
; node # 78 D(-46,25)->(-50,25)
       fcb 2 ; drawmode 
       fcb 1,7 ; starx/y relative to previous node
       fdb 18,-127 ; dx/dy. dx(abs:-73|rel:-127) dy(abs:0|rel:18)
; node # 79 M(-67,-1)->(-65,-1)
       fcb 0 ; drawmode 
       fcb 26,-21 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:36|rel:109) dy(abs:0|rel:0)
; node # 80 D(-59,-24)->(-57,-24)
       fcb 2 ; drawmode 
       fcb 23,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:36|rel:0) dy(abs:0|rel:0)
; node # 81 D(-50,-17)->(-55,-18)
       fcb 2 ; drawmode 
       fcb -7,9 ; starx/y relative to previous node
       fdb 18,-127 ; dx/dy. dx(abs:-91|rel:-127) dy(abs:18|rel:18)
; node # 82 D(-34,-51)->(-38,-53)
       fcb 2 ; drawmode 
       fcb 34,16 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-73|rel:18) dy(abs:36|rel:18)
; node # 83 D(-8,-42)->(-15,-42)
       fcb 2 ; drawmode 
       fcb -9,26 ; starx/y relative to previous node
       fdb -36,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:0|rel:-36)
; node # 84 D(9,-55)->(8,-54)
       fcb 2 ; drawmode 
       fcb 13,17 ; starx/y relative to previous node
       fdb -18,110 ; dx/dy. dx(abs:-18|rel:110) dy(abs:-18|rel:-18)
; node # 85 M(3,-63)->(2,-63)
       fcb 0 ; drawmode 
       fcb 8,-6 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-18|rel:0) dy(abs:0|rel:18)
; node # 86 D(13,-60)->(11,-60)
       fcb 2 ; drawmode 
       fcb -3,10 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:0|rel:0)
; node # 87 D(17,-62)->(17,-62)
       fcb 2 ; drawmode 
       fcb 2,4 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:0)
; node # 88 M(7,-65)->(8,-65)
       fcb 0 ; drawmode 
       fcb 3,-10 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:0|rel:0)
; node # 89 D(9,-55)->(8,-54)
       fcb 2 ; drawmode 
       fcb -10,2 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-18|rel:-36) dy(abs:-18|rel:-18)
; node # 90 D(30,-59)->(38,-58)
       fcb 2 ; drawmode 
       fcb 4,21 ; starx/y relative to previous node
       fdb 0,164 ; dx/dy. dx(abs:146|rel:164) dy(abs:-18|rel:0)
; node # 91 M(13,-60)->(11,-60)
       fcb 0 ; drawmode 
       fcb 1,-17 ; starx/y relative to previous node
       fdb 18,-182 ; dx/dy. dx(abs:-36|rel:-182) dy(abs:0|rel:18)
; node # 92 D(9,-55)->(8,-54)
       fcb 2 ; drawmode 
       fcb -5,-4 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:-18|rel:-18)
; node # 93 M(-7,-27)->(-14,-27)
       fcb 0 ; drawmode 
       fcb -28,-16 ; starx/y relative to previous node
       fdb 18,-110 ; dx/dy. dx(abs:-128|rel:-110) dy(abs:0|rel:18)
; node # 94 D(-15,-24)->(-27,-25)
       fcb 2 ; drawmode 
       fcb -3,-8 ; starx/y relative to previous node
       fdb 18,-91 ; dx/dy. dx(abs:-219|rel:-91) dy(abs:18|rel:18)
; node # 95 D(-17,-12)->(-29,-12)
       fcb 2 ; drawmode 
       fcb -12,-2 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:0|rel:-18)
; node # 96 D(-14,2)->(-22,2)
       fcb 2 ; drawmode 
       fcb -14,3 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-146|rel:73) dy(abs:0|rel:0)
; node # 97 D(-23,2)->(-31,1)
       fcb 2 ; drawmode 
       fcb 0,-9 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:18|rel:18)
; node # 98 D(-25,-14)->(-37,-14)
       fcb 2 ; drawmode 
       fcb 16,-2 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:0|rel:-18)
; node # 99 D(-23,-26)->(-35,-27)
       fcb 2 ; drawmode 
       fcb 12,2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:18|rel:18)
; node # 100 D(-15,-29)->(-22,-30)
       fcb 2 ; drawmode 
       fcb 3,8 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:-128|rel:91) dy(abs:18|rel:0)
; node # 101 D(-7,-27)->(-14,-27)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:-18)
; node # 102 D(-10,-33)->(-18,-33)
       fcb 2 ; drawmode 
       fcb 6,-3 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 103 D(-20,-29)->(-32,-30)
       fcb 2 ; drawmode 
       fcb -4,-10 ; starx/y relative to previous node
       fdb 18,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:18|rel:18)
; node # 104 D(-23,-9)->(-35,-8)
       fcb 2 ; drawmode 
       fcb -20,-3 ; starx/y relative to previous node
       fdb -36,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:-18|rel:-36)
; node # 105 D(-20,9)->(-28,9)
       fcb 2 ; drawmode 
       fcb -18,3 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-146|rel:73) dy(abs:0|rel:18)
; node # 106 D(-23,2)->(-31,1)
       fcb 2 ; drawmode 
       fcb 7,-3 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:18|rel:18)
; node # 107 M(-67,-1)->(-65,-1)
       fcb 0 ; drawmode 
       fcb 3,-44 ; starx/y relative to previous node
       fdb -18,182 ; dx/dy. dx(abs:36|rel:182) dy(abs:0|rel:-18)
; node # 108 D(-37,4)->(-23,4)
       fcb 2 ; drawmode 
       fcb -5,30 ; starx/y relative to previous node
       fdb 0,220 ; dx/dy. dx(abs:256|rel:220) dy(abs:0|rel:0)
; node # 109 M(-23,2)->(-31,1)
       fcb 0 ; drawmode 
       fcb 2,14 ; starx/y relative to previous node
       fdb 18,-402 ; dx/dy. dx(abs:-146|rel:-402) dy(abs:18|rel:18)
; node # 110 M(-23,-26)->(-35,-27)
       fcb 0 ; drawmode 
       fcb 28,0 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:18|rel:0)
; node # 111 D(-20,-29)->(-32,-30)
       fcb 2 ; drawmode 
       fcb 3,3 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:18|rel:0)
; node # 112 M(-20,9)->(-28,9)
       fcb 0 ; drawmode 
       fcb -38,0 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-146|rel:73) dy(abs:0|rel:-18)
; node # 113 D(-14,2)->(-22,2)
       fcb 2 ; drawmode 
       fcb 7,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-146|rel:0) dy(abs:0|rel:0)
; node # 114 M(-17,-12)->(-29,-12)
       fcb 0 ; drawmode 
       fcb 14,-3 ; starx/y relative to previous node
       fdb 0,-73 ; dx/dy. dx(abs:-219|rel:-73) dy(abs:0|rel:0)
; node # 115 D(-23,-9)->(-35,-8)
       fcb 2 ; drawmode 
       fcb -3,-6 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:-18|rel:-18)
; node # 116 D(-25,-14)->(-37,-14)
       fcb 2 ; drawmode 
       fcb 5,-2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:0|rel:18)
; node # 117 D(-17,-12)->(-29,-12)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:0|rel:0)
; node # 118 M(-23,-26)->(-35,-27)
       fcb 0 ; drawmode 
       fcb 14,-6 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:18|rel:18)
; node # 119 D(-15,-24)->(-27,-25)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:18|rel:0)
; node # 120 M(-15,-24)->(-27,-25)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:18|rel:0)
; node # 121 D(-20,-29)->(-32,-30)
       fcb 2 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:18|rel:0)
; node # 122 M(-15,-29)->(-22,-30)
       fcb 0 ; drawmode 
       fcb 0,5 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:-128|rel:91) dy(abs:18|rel:0)
; node # 123 D(-10,-33)->(-18,-33)
       fcb 2 ; drawmode 
       fcb 4,5 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:-18)
       fcb  1  ; end of anim
; Animation 17
teapotBframe17:
       fcb 14 ; Duration
       fcb 0 ; Masking 
       fcb 0 ; Masking effect
; node # 0 M(-23,4)->(-9,4)
       fcb 0 ; drawmode 
       fcb -4,-23 ; starx/y relative to previous node
       fdb 0,256 ; dx/dy. dx(abs:256|rel:256) dy(abs:0|rel:0)
; node # 1 D(38,13)->(48,13)
       fcb 2 ; drawmode 
       fcb -9,61 ; starx/y relative to previous node
       fdb 0,-74 ; dx/dy. dx(abs:182|rel:-74) dy(abs:0|rel:0)
; node # 2 D(22,39)->(30,38)
       fcb 2 ; drawmode 
       fcb -26,-16 ; starx/y relative to previous node
       fdb 18,-36 ; dx/dy. dx(abs:146|rel:-36) dy(abs:18|rel:18)
; node # 3 D(-21,33)->(-10,33)
       fcb 2 ; drawmode 
       fcb 6,-43 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:201|rel:55) dy(abs:0|rel:-18)
; node # 4 D(-23,4)->(-9,4)
       fcb 2 ; drawmode 
       fcb 29,-2 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:256|rel:55) dy(abs:0|rel:0)
; node # 5 D(-18,-24)->(-5,-24)
       fcb 2 ; drawmode 
       fcb 28,5 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:237|rel:-19) dy(abs:0|rel:0)
; node # 6 D(40,-14)->(49,-13)
       fcb 2 ; drawmode 
       fcb -10,58 ; starx/y relative to previous node
       fdb -18,-73 ; dx/dy. dx(abs:164|rel:-73) dy(abs:-18|rel:-18)
; node # 7 D(38,-58)->(44,-56)
       fcb 2 ; drawmode 
       fcb 44,-2 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:109|rel:-55) dy(abs:-36|rel:-18)
; node # 8 D(58,-45)->(56,-43)
       fcb 2 ; drawmode 
       fcb -13,20 ; starx/y relative to previous node
       fdb 0,-145 ; dx/dy. dx(abs:-36|rel:-145) dy(abs:-36|rel:0)
; node # 9 D(45,-37)->(39,-37)
       fcb 2 ; drawmode 
       fcb -8,-13 ; starx/y relative to previous node
       fdb 36,-73 ; dx/dy. dx(abs:-109|rel:-73) dy(abs:0|rel:36)
; node # 10 D(49,0)->(41,0)
       fcb 2 ; drawmode 
       fcb -37,4 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-146|rel:-37) dy(abs:0|rel:0)
; node # 11 D(47,20)->(41,19)
       fcb 2 ; drawmode 
       fcb -20,-2 ; starx/y relative to previous node
       fdb 18,37 ; dx/dy. dx(abs:-109|rel:37) dy(abs:18|rel:18)
; node # 12 D(33,38)->(29,37)
       fcb 2 ; drawmode 
       fcb -18,-14 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-73|rel:36) dy(abs:18|rel:0)
; node # 13 D(6,33)->(-1,33)
       fcb 2 ; drawmode 
       fcb 5,-27 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:0|rel:-18)
; node # 14 D(12,15)->(2,15)
       fcb 2 ; drawmode 
       fcb 18,6 ; starx/y relative to previous node
       fdb 0,-54 ; dx/dy. dx(abs:-182|rel:-54) dy(abs:0|rel:0)
; node # 15 D(14,-3)->(4,-3)
       fcb 2 ; drawmode 
       fcb 18,2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-182|rel:0) dy(abs:0|rel:0)
; node # 16 D(49,0)->(41,0)
       fcb 2 ; drawmode 
       fcb -3,35 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-146|rel:36) dy(abs:0|rel:0)
; node # 17 D(65,-4)->(64,-3)
       fcb 2 ; drawmode 
       fcb 4,16 ; starx/y relative to previous node
       fdb -18,128 ; dx/dy. dx(abs:-18|rel:128) dy(abs:-18|rel:-18)
; node # 18 D(58,-45)->(56,-43)
       fcb 2 ; drawmode 
       fcb 41,-7 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:-36|rel:-18)
; node # 19 D(8,-54)->(7,-54)
       fcb 2 ; drawmode 
       fcb 9,-50 ; starx/y relative to previous node
       fdb 36,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:0|rel:36)
; node # 20 D(45,-37)->(39,-37)
       fcb 2 ; drawmode 
       fcb -17,37 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:-109|rel:-91) dy(abs:0|rel:0)
; node # 21 D(17,-36)->(8,-37)
       fcb 2 ; drawmode 
       fcb -1,-28 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-164|rel:-55) dy(abs:18|rel:18)
; node # 22 D(14,-3)->(4,-3)
       fcb 2 ; drawmode 
       fcb -33,-3 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-182|rel:-18) dy(abs:0|rel:-18)
; node # 23 D(-24,-9)->(-32,-9)
       fcb 2 ; drawmode 
       fcb 6,-38 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-146|rel:36) dy(abs:0|rel:0)
; node # 24 D(-28,9)->(-37,9)
       fcb 2 ; drawmode 
       fcb -18,-4 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-164|rel:-18) dy(abs:0|rel:0)
; node # 25 D(12,15)->(2,15)
       fcb 2 ; drawmode 
       fcb -6,40 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-182|rel:-18) dy(abs:0|rel:0)
; node # 26 D(47,20)->(41,19)
       fcb 2 ; drawmode 
       fcb -5,35 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:-109|rel:73) dy(abs:18|rel:18)
; node # 27 D(65,20)->(65,19)
       fcb 2 ; drawmode 
       fcb 0,18 ; starx/y relative to previous node
       fdb 0,109 ; dx/dy. dx(abs:0|rel:109) dy(abs:18|rel:0)
; node # 28 D(65,-4)->(64,-3)
       fcb 2 ; drawmode 
       fcb 24,0 ; starx/y relative to previous node
       fdb -36,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:-18|rel:-36)
; node # 29 D(40,-14)->(49,-13)
       fcb 2 ; drawmode 
       fcb 10,-25 ; starx/y relative to previous node
       fdb 0,182 ; dx/dy. dx(abs:164|rel:182) dy(abs:-18|rel:0)
; node # 30 D(38,13)->(48,13)
       fcb 2 ; drawmode 
       fcb -27,-2 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:182|rel:18) dy(abs:0|rel:18)
; node # 31 D(65,20)->(65,19)
       fcb 2 ; drawmode 
       fcb -7,27 ; starx/y relative to previous node
       fdb 18,-182 ; dx/dy. dx(abs:0|rel:-182) dy(abs:18|rel:18)
; node # 32 D(43,41)->(44,39)
       fcb 2 ; drawmode 
       fcb -21,-22 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:18|rel:18) dy(abs:36|rel:18)
; node # 33 D(22,39)->(30,38)
       fcb 2 ; drawmode 
       fcb 2,-21 ; starx/y relative to previous node
       fdb -18,128 ; dx/dy. dx(abs:146|rel:128) dy(abs:18|rel:-18)
; node # 34 M(33,38)->(29,37)
       fcb 0 ; drawmode 
       fcb 1,11 ; starx/y relative to previous node
       fdb 0,-219 ; dx/dy. dx(abs:-73|rel:-219) dy(abs:18|rel:0)
; node # 35 D(43,41)->(44,39)
       fcb 2 ; drawmode 
       fcb -3,10 ; starx/y relative to previous node
       fdb 18,91 ; dx/dy. dx(abs:18|rel:91) dy(abs:36|rel:18)
; node # 36 M(38,13)->(48,13)
       fcb 0 ; drawmode 
       fcb 28,-5 ; starx/y relative to previous node
       fdb -36,164 ; dx/dy. dx(abs:182|rel:164) dy(abs:0|rel:-36)
; node # 37 D(62,-29)->(75,-28)
       fcb 2 ; drawmode 
       fcb 42,24 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:237|rel:55) dy(abs:-18|rel:-18)
; node # 38 D(89,-57)->(104,-54)
       fcb 2 ; drawmode 
       fcb 28,27 ; starx/y relative to previous node
       fdb -36,37 ; dx/dy. dx(abs:274|rel:37) dy(abs:-54|rel:-36)
; node # 39 D(68,-56)->(84,-53)
       fcb 2 ; drawmode 
       fcb -1,-21 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:292|rel:18) dy(abs:-54|rel:0)
; node # 40 D(32,-20)->(43,-20)
       fcb 2 ; drawmode 
       fcb -36,-36 ; starx/y relative to previous node
       fdb 54,-91 ; dx/dy. dx(abs:201|rel:-91) dy(abs:0|rel:54)
; node # 41 D(38,13)->(48,13)
       fcb 2 ; drawmode 
       fcb -33,6 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:182|rel:-19) dy(abs:0|rel:0)
; node # 42 D(44,-18)->(51,-17)
       fcb 2 ; drawmode 
       fcb 31,6 ; starx/y relative to previous node
       fdb -18,-54 ; dx/dy. dx(abs:128|rel:-54) dy(abs:-18|rel:-18)
; node # 43 D(32,-20)->(43,-20)
       fcb 2 ; drawmode 
       fcb 2,-12 ; starx/y relative to previous node
       fdb 18,73 ; dx/dy. dx(abs:201|rel:73) dy(abs:0|rel:18)
; node # 44 M(79,-52)->(91,-49)
       fcb 0 ; drawmode 
       fcb 32,47 ; starx/y relative to previous node
       fdb -54,18 ; dx/dy. dx(abs:219|rel:18) dy(abs:-54|rel:-54)
; node # 45 D(68,-56)->(84,-53)
       fcb 2 ; drawmode 
       fcb 4,-11 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:292|rel:73) dy(abs:-54|rel:0)
; node # 46 M(89,-57)->(104,-54)
       fcb 0 ; drawmode 
       fcb 1,21 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:274|rel:-18) dy(abs:-54|rel:0)
; node # 47 D(79,-52)->(91,-49)
       fcb 2 ; drawmode 
       fcb -5,-10 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:219|rel:-55) dy(abs:-54|rel:0)
; node # 48 D(44,-18)->(51,-17)
       fcb 2 ; drawmode 
       fcb -34,-35 ; starx/y relative to previous node
       fdb 36,-91 ; dx/dy. dx(abs:128|rel:-91) dy(abs:-18|rel:36)
; node # 49 M(38,-58)->(44,-56)
       fcb 0 ; drawmode 
       fcb 40,-6 ; starx/y relative to previous node
       fdb -18,-19 ; dx/dy. dx(abs:109|rel:-19) dy(abs:-36|rel:-18)
; node # 50 D(-6,-66)->(2,-67)
       fcb 2 ; drawmode 
       fcb 8,-44 ; starx/y relative to previous node
       fdb 54,37 ; dx/dy. dx(abs:146|rel:37) dy(abs:18|rel:54)
; node # 51 D(-18,-24)->(-5,-24)
       fcb 2 ; drawmode 
       fcb -42,-12 ; starx/y relative to previous node
       fdb -18,91 ; dx/dy. dx(abs:237|rel:91) dy(abs:0|rel:-18)
; node # 52 D(-57,-24)->(-52,-25)
       fcb 2 ; drawmode 
       fcb 0,-39 ; starx/y relative to previous node
       fdb 18,-146 ; dx/dy. dx(abs:91|rel:-146) dy(abs:18|rel:18)
; node # 53 D(-38,-63)->(-35,-65)
       fcb 2 ; drawmode 
       fcb 39,19 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:54|rel:-37) dy(abs:36|rel:18)
; node # 54 D(-6,-66)->(2,-67)
       fcb 2 ; drawmode 
       fcb 3,32 ; starx/y relative to previous node
       fdb -18,92 ; dx/dy. dx(abs:146|rel:92) dy(abs:18|rel:-18)
; node # 55 D(8,-54)->(7,-54)
       fcb 2 ; drawmode 
       fcb -12,14 ; starx/y relative to previous node
       fdb -18,-164 ; dx/dy. dx(abs:-18|rel:-164) dy(abs:0|rel:-18)
; node # 56 D(2,-63)->(0,-63)
       fcb 2 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:0|rel:0)
; node # 57 D(8,-65)->(8,-65)
       fcb 2 ; drawmode 
       fcb 2,6 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:0)
; node # 58 D(17,-62)->(15,-61)
       fcb 2 ; drawmode 
       fcb -3,9 ; starx/y relative to previous node
       fdb -18,-36 ; dx/dy. dx(abs:-36|rel:-36) dy(abs:-18|rel:-18)
; node # 59 D(8,-54)->(7,-54)
       fcb 2 ; drawmode 
       fcb -8,-9 ; starx/y relative to previous node
       fdb 18,18 ; dx/dy. dx(abs:-18|rel:18) dy(abs:0|rel:18)
; node # 60 D(-38,-63)->(-35,-65)
       fcb 2 ; drawmode 
       fcb 9,-46 ; starx/y relative to previous node
       fdb 36,72 ; dx/dy. dx(abs:54|rel:72) dy(abs:36|rel:36)
; node # 61 D(-38,-53)->(-42,-54)
       fcb 2 ; drawmode 
       fcb -10,0 ; starx/y relative to previous node
       fdb -18,-127 ; dx/dy. dx(abs:-73|rel:-127) dy(abs:18|rel:-18)
; node # 62 D(8,-54)->(7,-54)
       fcb 2 ; drawmode 
       fcb 1,46 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-18|rel:55) dy(abs:0|rel:-18)
; node # 63 D(17,-36)->(8,-37)
       fcb 2 ; drawmode 
       fcb -18,9 ; starx/y relative to previous node
       fdb 18,-146 ; dx/dy. dx(abs:-164|rel:-146) dy(abs:18|rel:18)
; node # 64 D(-15,-42)->(-22,-43)
       fcb 2 ; drawmode 
       fcb 6,-32 ; starx/y relative to previous node
       fdb 0,36 ; dx/dy. dx(abs:-128|rel:36) dy(abs:18|rel:0)
; node # 65 D(-24,-9)->(-32,-9)
       fcb 2 ; drawmode 
       fcb -33,-9 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:-18)
; node # 66 D(-55,-18)->(-59,-18)
       fcb 2 ; drawmode 
       fcb 9,-31 ; starx/y relative to previous node
       fdb 0,73 ; dx/dy. dx(abs:-73|rel:73) dy(abs:0|rel:0)
; node # 67 D(-61,2)->(-65,2)
       fcb 2 ; drawmode 
       fcb -20,-6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-73|rel:0) dy(abs:0|rel:0)
; node # 68 D(-28,9)->(-37,9)
       fcb 2 ; drawmode 
       fcb -7,33 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:-164|rel:-91) dy(abs:0|rel:0)
; node # 69 D(-25,29)->(-31,29)
       fcb 2 ; drawmode 
       fcb -20,3 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-109|rel:55) dy(abs:0|rel:0)
; node # 70 D(-50,25)->(-52,26)
       fcb 2 ; drawmode 
       fcb 4,-25 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-36|rel:73) dy(abs:-18|rel:-18)
; node # 71 D(-61,2)->(-65,2)
       fcb 2 ; drawmode 
       fcb 23,-11 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:-73|rel:-37) dy(abs:0|rel:18)
; node # 72 D(-65,-1)->(-58,-1)
       fcb 2 ; drawmode 
       fcb 3,-4 ; starx/y relative to previous node
       fdb 0,201 ; dx/dy. dx(abs:128|rel:201) dy(abs:0|rel:0)
; node # 73 D(-50,27)->(-46,28)
       fcb 2 ; drawmode 
       fcb -28,15 ; starx/y relative to previous node
       fdb -18,-55 ; dx/dy. dx(abs:73|rel:-55) dy(abs:-18|rel:-18)
; node # 74 D(-21,33)->(-10,33)
       fcb 2 ; drawmode 
       fcb -6,29 ; starx/y relative to previous node
       fdb 18,128 ; dx/dy. dx(abs:201|rel:128) dy(abs:0|rel:18)
; node # 75 M(-25,29)->(-31,29)
       fcb 0 ; drawmode 
       fcb 4,-4 ; starx/y relative to previous node
       fdb 0,-310 ; dx/dy. dx(abs:-109|rel:-310) dy(abs:0|rel:0)
; node # 76 D(6,33)->(-1,33)
       fcb 2 ; drawmode 
       fcb -4,31 ; starx/y relative to previous node
       fdb 0,-19 ; dx/dy. dx(abs:-128|rel:-19) dy(abs:0|rel:0)
; node # 77 M(-50,27)->(-46,28)
       fcb 0 ; drawmode 
       fcb 6,-56 ; starx/y relative to previous node
       fdb -18,201 ; dx/dy. dx(abs:73|rel:201) dy(abs:-18|rel:-18)
; node # 78 D(-50,25)->(-52,26)
       fcb 2 ; drawmode 
       fcb 2,0 ; starx/y relative to previous node
       fdb 0,-109 ; dx/dy. dx(abs:-36|rel:-109) dy(abs:-18|rel:0)
; node # 79 M(-65,-1)->(-58,-1)
       fcb 0 ; drawmode 
       fcb 26,-15 ; starx/y relative to previous node
       fdb 18,164 ; dx/dy. dx(abs:128|rel:164) dy(abs:0|rel:18)
; node # 80 D(-57,-24)->(-52,-25)
       fcb 2 ; drawmode 
       fcb 23,8 ; starx/y relative to previous node
       fdb 18,-37 ; dx/dy. dx(abs:91|rel:-37) dy(abs:18|rel:18)
; node # 81 D(-55,-18)->(-59,-18)
       fcb 2 ; drawmode 
       fcb -6,2 ; starx/y relative to previous node
       fdb -18,-164 ; dx/dy. dx(abs:-73|rel:-164) dy(abs:0|rel:-18)
; node # 82 D(-38,-53)->(-42,-54)
       fcb 2 ; drawmode 
       fcb 35,17 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-73|rel:0) dy(abs:18|rel:18)
; node # 83 D(-15,-42)->(-22,-43)
       fcb 2 ; drawmode 
       fcb -11,23 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-128|rel:-55) dy(abs:18|rel:0)
; node # 84 D(8,-54)->(7,-54)
       fcb 2 ; drawmode 
       fcb 12,23 ; starx/y relative to previous node
       fdb -18,110 ; dx/dy. dx(abs:-18|rel:110) dy(abs:0|rel:-18)
; node # 85 M(2,-63)->(0,-63)
       fcb 0 ; drawmode 
       fcb 9,-6 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-36|rel:-18) dy(abs:0|rel:0)
; node # 86 D(11,-60)->(8,-59)
       fcb 2 ; drawmode 
       fcb -3,9 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-54|rel:-18) dy(abs:-18|rel:-18)
; node # 87 D(17,-62)->(15,-61)
       fcb 2 ; drawmode 
       fcb 2,6 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-36|rel:18) dy(abs:-18|rel:0)
; node # 88 M(8,-65)->(8,-65)
       fcb 0 ; drawmode 
       fcb 3,-9 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:0|rel:36) dy(abs:0|rel:18)
; node # 89 D(8,-54)->(7,-54)
       fcb 2 ; drawmode 
       fcb -11,0 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-18|rel:-18) dy(abs:0|rel:0)
; node # 90 D(38,-58)->(44,-56)
       fcb 2 ; drawmode 
       fcb 4,30 ; starx/y relative to previous node
       fdb -36,127 ; dx/dy. dx(abs:109|rel:127) dy(abs:-36|rel:-36)
; node # 91 M(11,-60)->(8,-59)
       fcb 0 ; drawmode 
       fcb 2,-27 ; starx/y relative to previous node
       fdb 18,-163 ; dx/dy. dx(abs:-54|rel:-163) dy(abs:-18|rel:18)
; node # 92 D(8,-54)->(7,-54)
       fcb 2 ; drawmode 
       fcb -6,-3 ; starx/y relative to previous node
       fdb 18,36 ; dx/dy. dx(abs:-18|rel:36) dy(abs:0|rel:18)
; node # 93 M(-14,-27)->(-22,-27)
       fcb 0 ; drawmode 
       fcb -27,-22 ; starx/y relative to previous node
       fdb 0,-128 ; dx/dy. dx(abs:-146|rel:-128) dy(abs:0|rel:0)
; node # 94 D(-27,-25)->(-38,-25)
       fcb 2 ; drawmode 
       fcb -2,-13 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-201|rel:-55) dy(abs:0|rel:0)
; node # 95 D(-29,-12)->(-40,-12)
       fcb 2 ; drawmode 
       fcb -13,-2 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:0|rel:0)
; node # 96 D(-22,2)->(-31,2)
       fcb 2 ; drawmode 
       fcb -14,7 ; starx/y relative to previous node
       fdb 0,37 ; dx/dy. dx(abs:-164|rel:37) dy(abs:0|rel:0)
; node # 97 D(-31,1)->(-39,1)
       fcb 2 ; drawmode 
       fcb 1,-9 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 98 D(-37,-14)->(-48,-14)
       fcb 2 ; drawmode 
       fcb 15,-6 ; starx/y relative to previous node
       fdb 0,-55 ; dx/dy. dx(abs:-201|rel:-55) dy(abs:0|rel:0)
; node # 99 D(-35,-27)->(-46,-28)
       fcb 2 ; drawmode 
       fcb 13,2 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:18|rel:18)
; node # 100 D(-22,-30)->(-29,-30)
       fcb 2 ; drawmode 
       fcb 3,13 ; starx/y relative to previous node
       fdb -18,73 ; dx/dy. dx(abs:-128|rel:73) dy(abs:0|rel:-18)
; node # 101 D(-14,-27)->(-22,-27)
       fcb 2 ; drawmode 
       fcb -3,8 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-146|rel:-18) dy(abs:0|rel:0)
; node # 102 D(-18,-33)->(-25,-33)
       fcb 2 ; drawmode 
       fcb 6,-4 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-128|rel:18) dy(abs:0|rel:0)
; node # 103 D(-32,-30)->(-44,-30)
       fcb 2 ; drawmode 
       fcb -3,-14 ; starx/y relative to previous node
       fdb 0,-91 ; dx/dy. dx(abs:-219|rel:-91) dy(abs:0|rel:0)
; node # 104 D(-35,-8)->(-47,-9)
       fcb 2 ; drawmode 
       fcb -22,-3 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-219|rel:0) dy(abs:18|rel:18)
; node # 105 D(-28,9)->(-37,9)
       fcb 2 ; drawmode 
       fcb -17,7 ; starx/y relative to previous node
       fdb -18,55 ; dx/dy. dx(abs:-164|rel:55) dy(abs:0|rel:-18)
; node # 106 D(-31,1)->(-39,1)
       fcb 2 ; drawmode 
       fcb 8,-3 ; starx/y relative to previous node
       fdb 0,18 ; dx/dy. dx(abs:-146|rel:18) dy(abs:0|rel:0)
; node # 107 M(-65,-1)->(-58,-1)
       fcb 0 ; drawmode 
       fcb 2,-34 ; starx/y relative to previous node
       fdb 0,274 ; dx/dy. dx(abs:128|rel:274) dy(abs:0|rel:0)
; node # 108 D(-23,4)->(-9,4)
       fcb 2 ; drawmode 
       fcb -5,42 ; starx/y relative to previous node
       fdb 0,128 ; dx/dy. dx(abs:256|rel:128) dy(abs:0|rel:0)
; node # 109 M(-31,1)->(-39,1)
       fcb 0 ; drawmode 
       fcb 3,-8 ; starx/y relative to previous node
       fdb 0,-402 ; dx/dy. dx(abs:-146|rel:-402) dy(abs:0|rel:0)
; node # 110 M(-35,-27)->(-46,-28)
       fcb 0 ; drawmode 
       fcb 28,-4 ; starx/y relative to previous node
       fdb 18,-55 ; dx/dy. dx(abs:-201|rel:-55) dy(abs:18|rel:18)
; node # 111 D(-32,-30)->(-44,-30)
       fcb 2 ; drawmode 
       fcb 3,3 ; starx/y relative to previous node
       fdb -18,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:0|rel:-18)
; node # 112 M(-28,9)->(-37,9)
       fcb 0 ; drawmode 
       fcb -39,4 ; starx/y relative to previous node
       fdb 0,55 ; dx/dy. dx(abs:-164|rel:55) dy(abs:0|rel:0)
; node # 113 D(-22,2)->(-31,2)
       fcb 2 ; drawmode 
       fcb 7,6 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-164|rel:0) dy(abs:0|rel:0)
; node # 114 M(-29,-12)->(-40,-12)
       fcb 0 ; drawmode 
       fcb 14,-7 ; starx/y relative to previous node
       fdb 0,-37 ; dx/dy. dx(abs:-201|rel:-37) dy(abs:0|rel:0)
; node # 115 D(-35,-8)->(-47,-9)
       fcb 2 ; drawmode 
       fcb -4,-6 ; starx/y relative to previous node
       fdb 18,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:18|rel:18)
; node # 116 D(-37,-14)->(-48,-14)
       fcb 2 ; drawmode 
       fcb 6,-2 ; starx/y relative to previous node
       fdb -18,18 ; dx/dy. dx(abs:-201|rel:18) dy(abs:0|rel:-18)
; node # 117 D(-29,-12)->(-40,-12)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:0|rel:0)
; node # 118 M(-35,-27)->(-46,-28)
       fcb 0 ; drawmode 
       fcb 15,-6 ; starx/y relative to previous node
       fdb 18,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:18|rel:18)
; node # 119 D(-27,-25)->(-38,-25)
       fcb 2 ; drawmode 
       fcb -2,8 ; starx/y relative to previous node
       fdb -18,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:0|rel:-18)
; node # 120 M(-27,-25)->(-38,-25)
       fcb 0 ; drawmode 
       fcb 0,0 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-201|rel:0) dy(abs:0|rel:0)
; node # 121 D(-32,-30)->(-44,-30)
       fcb 2 ; drawmode 
       fcb 5,-5 ; starx/y relative to previous node
       fdb 0,-18 ; dx/dy. dx(abs:-219|rel:-18) dy(abs:0|rel:0)
; node # 122 M(-22,-30)->(-29,-30)
       fcb 0 ; drawmode 
       fcb 0,10 ; starx/y relative to previous node
       fdb 0,91 ; dx/dy. dx(abs:-128|rel:91) dy(abs:0|rel:0)
; node # 123 D(-18,-33)->(-25,-33)
       fcb 2 ; drawmode 
       fcb 3,4 ; starx/y relative to previous node
       fdb 0,0 ; dx/dy. dx(abs:-128|rel:0) dy(abs:0|rel:0)
       fcb  1  ; end of anim
